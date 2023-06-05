-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - liliana Rodriguez
-- Create date:		10/07/2017
-- Modified date:	11/01/2018
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados, con las respuestas dadas por el gobernador 
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroMunicipioTotales] -- [PAT].[C_TableroMunicipioTotales]  null, 1,100,375,6,1
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT,  @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @RESULTADO TABLE (
		ID_PREGUNTA SMALLINT,
		PREGUNTAINDICATIVA NVARCHAR(500),
		PREGUNTACOMPROMISO NVARCHAR(500),
		DERECHO NVARCHAR(50),
		COMPONENTE NVARCHAR(100),
		MEDIDA NVARCHAR(50),
		UNIDADMEDIDA NVARCHAR(100),
		IDTABLERO TINYINT,
		IDENTIDAD INT,
		TOTALNECESIDADES INT,
		TOTALCOMPROMISOS INT,
		ID INT
		)
	
	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize

	SET @ORDEN = @sortOrder
	IF @ORDEN = ''
			SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE  @IdMunicipio INT, @IDDEPARTAMENTO INT

	SELECT @IDDEPARTAMENTO = IdDepartamento , @IdMunicipio = IdMunicipio FROM USUARIO WHERE Id = @IdUsuario

	SET @SQL = 'SELECT DISTINCT TOP (@TOP) 
					IDPREGUNTA,PREGUNTAINDICATIVA,PREGUNTACOMPROMISO,
					DERECHO,COMPONENTE,MEDIDA,UNIDADMEDIDA,IDTABLERO,IDENTIDAD,TOTALNECESIDADES,TOTALCOMPROMISOS,ID
				FROM ( 
				 SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.PREGUNTAINDICATIVA, 
						P.PREGUNTACOMPROMISO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						(SELECT SUM(R1.RespuestaIndicativa) 
							FROM  [PAT].[RespuestaPAT] R1	
							join Municipio MUN ON R1.IdMunicipio = MUN.Id
							WHERE R1.[IdPreguntaPAT]=P.Id  AND MUN.IdDepartamento = @IDDEPARTAMENTO							
						) TOTALNECESIDADES,
						(SELECT SUM(R1.RESPUESTACOMPROMISO) 
							FROM  [PAT].[RespuestaPAT] R1
							join Municipio MUN ON R1.IdMunicipio = MUN.Id
							WHERE R1.IdPreguntaPAT=P.Id AND MUN.IdDepartamento = @IDDEPARTAMENTO								
						) TOTALCOMPROMISOS,
						(SELECT TOP 1 RR.ID FROM [PAT].[RespuestaPAT] RR WHERE P.Id = RR.IdPreguntaPAT and RR.IdDepartamento =  @IDDEPARTAMENTO and RR.IdMunicipio is null	) AS ID
				FROM    [PAT].[PreguntaPAT] as P 
						join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT
						join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = @IDDEPARTAMENTO
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdDepartamento =  @IDDEPARTAMENTO and R.IdMunicipio is null,						
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND P.IdTablero = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1
					AND P.ApoyoDepartamental = 1 					
					AND D.ID = @IdDerecho'		
	SET @SQL = @SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY P.ID'--+ @ORDEN 	
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IdMunicipio INT,@IdDerecho INT, @IDDEPARTAMENTO int'
		
	PRINT @SQL

	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IdMunicipio=@IdMunicipio, @IdDerecho=@IdDerecho, @IDDEPARTAMENTO=@IDDEPARTAMENTO
	SELECT * from @RESULTADO
END
go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	11/01/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para una pregunta en especial
-- =============================================
ALTER PROC [PAT].[C_TableroSeguimientoConsolidadoDepartamento] --[PAT].[C_TableroSeguimientoConsolidadoDepartamento]  3, 375, 1
(	@IdTablero INT ,@IdUsuario INT ,@IdDerecho INT )
AS
BEGIN
	DECLARE  @IdDepartamento INT	
	select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

--SELECT
--B.DESCRIPCION AS COMPONENTE
--,C.DESCRIPCION AS MEDIDA
--,E.DESCRIPCION AS DERECHO
--,A.PREGUNTA_INDICATIVA 
--,D.DESCRIPCION AS UNIDAD
--,SUM(ISNULL(RD.RESPUESTA_COMPROMISO, 0)) AS TOTALCOMPROMISO
--,SUM(ISNULL(RD.PRESUPUESTO, 0)) AS TOTALPRESUPUESTO
--,ISNULL(SUM(SM.CantidadPrimer), -1) AS AVANCEPRIMERALCALDIAS
--,ISNULL(SUM(SM.CantidadSegundo), -1) AS AVANCESEGUNDOALCALDIAS
--,ISNULL(SUM(SG.CantidadPrimer), -1) AS AVANCEPRIMERGOBERNA
--,ISNULL(SUM(SG.CantidadSegundo), -1) AS AVANCESEGUNDOGOBERNA
--,A.ID AS ID_PREGUNTA
--,E.ID AS ID_DERECHO
--FROM [PAT].[TB_PREGUNTA] A
--inner join [PAT].[TB_COMPONENTE] b on b.ID = a.[ID_COMPONENTE]
--inner join [PAT].[TB_MEDIDA] c on c.ID = a.ID_MEDIDA
--inner join [PAT].[TB_UNIDAD_MEDIDA] d on d.ID = a.ID_UNIDAD_MEDIDA
--inner join [PAT].[TB_DERECHO] e on e.ID = a.ID_DERECHO
--LEFT OUTER JOIN [PAT].[TB_PAT_RESPUESTA_DEPARTAMENTO] RD ON RD.ID_PREGUNTA = A.ID AND RD.ID_ENTIDAD = PAT.fn_GetIdEntidad(@IdUsuario) AND RD.ID_TABLERO = @IdTablero
--LEFT OUTER JOIN [PAT].[TB_SEGUIMIENTO] SM ON SM.IdPregunta = A.ID AND SM.IdTablero = RD.ID_TABLERO AND SM.IdUsuario = [PAT].[fn_GetIdUsuario](RD.ID_ENTIDAD_MUNICIPIO)
--LEFT OUTER JOIN [PAT].[TB_SEGUIMIENTO_GOBERNACION] SG ON SG.IdPregunta = A.ID AND SG.IdTablero = SM.IdTablero AND SG.IdUsuarioAlcaldia = SM.IdUsuario
--WHERE E.ID = @IdDerecho AND A.ACTIVO = @Activo AND A.ID >= @IdPreguntaIni AND A.ID <= @IdPreguntaFin
--GROUP BY B.DESCRIPCION, C.DESCRIPCION, A.PREGUNTA_INDICATIVA, D.DESCRIPCION, E.DESCRIPCION, A.ID, E.ID

	SELECT DISTINCT
	B.Descripcion AS Componente
	,C.Descripcion AS Medida
	,E.Descripcion AS Derecho
	,A.PreguntaIndicativa 
	,D.DESCRIPCION AS UNIDAD
	
	,SUM(ISNULL(RD.RespuestaCompromiso, 0)) AS TotalCompromiso
	,SUM(ISNULL(RD.Presupuesto, 0)) AS TotalPresupuesto
	
	,ISNULL(SUM(isnull(SM.CantidadPrimer,0)), -1) AS AvancePrimerSemestreAlcladias
	,ISNULL(SUM(isnull(SM.CantidadSegundo,0)), -1) AS AvanceSegundoSemestreAlcladias

	,ISNULL(SUM( ISNULL(SG.CantidadPrimer,0)), -1) AS AvancePrimerSemestreGobernaciones
	,ISNULL(SUM(isnull(SG.CantidadSegundo,0)), -1) AS AvanceSegundoSemestreGobernaciones
	,A.Id AS IdPregunta
	,E.Id AS IdDerecho
	FROM [PAT].PreguntaPAT as A
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	join [PAT].[PreguntaPATMunicipio] as PM on a.Id = PM.IdPreguntaPAT
	join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = @IdDepartamento
	LEFT OUTER JOIN [PAT].RespuestaPAT as RM on RM.IdPreguntaPAT = A.ID and RM.IdMunicipio = PM.IdMunicipio AND RM.IdDepartamento = @IdDepartamento
	LEFT OUTER JOIN [PAT].Seguimiento as SM on SM.IdPregunta = a.ID and SM.IdUsuario = RM.IdUsuario
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON RD.IdPreguntaPAT =A.Id  AND RD.IdUsuario = @IdUsuario and RD.IdMunicipioRespuesta = RM.IdMunicipio 	
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion as SG ON SG.IdPregunta=A.ID   AND SG.IdUsuarioAlcaldia = SM.IdUsuario
	WHERE  A.IdTablero = @IdTablero
	and A.Nivel = 3
	and E.ID = @IdDerecho
	AND A.ACTIVO = 1		
	AND A.ApoyoDepartamental = 1 	
	GROUP BY
	B.Descripcion, C.Descripcion, A.PreguntaIndicativa, D.Descripcion, E.Descripcion, A.Id, E.Id

END

GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	11/01/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDepartamentoRetornosReubicaciones] --[PAT].[C_TableroSeguimientoDepartamentoRetornosReubicaciones]  2, 181
(	@IdTablero INT,@IdMunicipio INT)
AS
BEGIN

	
	SELECT distinct A.[Id]
		  ,[Hogares]
		  ,[Personas]
		  ,[Sector]
		  ,[Componente]
		  ,[Comunidad]
		  ,[Ubicacion]
		  ,[MedidaRetornoReubicacion]
		  ,[IndicadorRetornoReubicacion]
		  ,[EntidadResponsable]
		  ,A.[IdDepartamento]
		  ,[IdMunicipio]
		  ,M.Nombre AS Municipio
		  ,[IdTablero]
		FROM [PAT].PreguntaPATRetornosReubicaciones as A
		JOIN Municipio AS M ON A.IdMunicipio = M.Id
		WHERE A.IdMunicipio= @IdMunicipio 	AND IdTablero = @IdTablero
END


GO

/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la información del seguimeinto municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_SeguimientoGobernacionInsert] 
				@IdTablero tinyint
			   ,@IdPregunta smallint
			   ,@IdUsuario int	
			   ,@IdUsuarioAlcaldia int		   
			   ,@CantidadPrimer bigint
			   ,@PresupuestoPrimer money
			   ,@CantidadSegundo bigint
			   ,@PresupuestoSegundo money
			   ,@Observaciones varchar(max)
			   ,@NombreAdjunto varchar(200)
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	
	
	if (@CantidadSegundo = -1)
		set @CantidadSegundo = 0
		
	if (@PresupuestoSegundo = -1)
		set @PresupuestoSegundo = 0
					
	if(@esValido = 1) 
	begin
		BEGIN TRY				
			INSERT INTO [PAT].[SeguimientoGobernacion]
				   ([IdTablero]
				   ,[IdPregunta]
				   ,[IdUsuario]
				   ,[IdUsuarioAlcaldia]
				   ,[FechaSeguimiento]
				   ,[CantidadPrimer]
				   ,[PresupuestoPrimer]
				   ,[CantidadSegundo]
				   ,[PresupuestoSegundo]
				   ,[Observaciones]
				   ,[NombreAdjunto])
			 VALUES
				   (@IdTablero 
				   ,@IdPregunta 
				   ,@IdUsuario 
				   ,@IdUsuarioAlcaldia
				   ,getdate() 
				   ,@CantidadPrimer 
				   ,@PresupuestoPrimer 
				   ,@CantidadSegundo 
				   ,@PresupuestoSegundo 
				   ,@Observaciones 
				   ,@NombreAdjunto )						
		
			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id

	go

	
	update [PAT].[SeguimientoGobernacion] set CantidadSegundo = 0 where CantidadSegundo = -1
	update [PAT].[SeguimientoGobernacion] set PresupuestoSegundo = 0 where PresupuestoSegundo = -1

	go

	-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	11/01/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero municipal 
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoAlcaldias] --[PAT].[C_DatosExcelSeguimientoAlcaldias] 411, 1
( @IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare @IdMunicipio int, @IdDepartamento int
	select  @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	select distinct IdPregunta,IdAccion,IdPrograma,Derecho,Componente,Medida,Pregunta,PreguntaCompromiso,UnidadNecesidad,RespuestaNecesidad
		,ObservacionNecesidad,RespuestaCompromiso,ObservacionCompromiso,PrespuestaPresupuesto,Accion,Programa,AvanceCantidadAlcaldia,AvancePresupuestoAlcaldia
		,ObservacionesSeguimientoAlcaldia,AvanceCantidadGobernacion,AvancePresupuestoGobernacion,ObservacionesSeguimientoGobernacion,ObservacionesSegundo,NombreAdjuntoSegundo
		,ProgramasPrimero,ProgramasSegundo
	from (
		SELECT 
		A.Id AS IdPregunta
		,RMA.Id AS IdAccion
		,RMP.Id AS IdPrograma
		,B.Descripcion AS Derecho
		,C.Descripcion AS Componente
		,D.Descripcion AS Medida
		,A.PreguntaIndicativa AS Pregunta
		,A.PreguntaCompromiso
		,E.Descripcion AS UnidadNecesidad
		,RM.RespuestaIndicativa AS RespuestaNecesidad
		,RM.ObservacionNecesidad
		,RM.RespuestaCompromiso
		,RM.AccionCompromiso AS ObservacionCompromiso
		,RM.Presupuesto AS PrespuestaPresupuesto
		,RMA.Accion
		,RMP.Programa
		,(SM.CantidadPrimer + REPLACE(SM.CantidadSegundo, -1, 0)) AS AvanceCantidadAlcaldia
		,(SM.PresupuestoPrimer + REPLACE(SM.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoAlcaldia
		,SM.Observaciones AS ObservacionesSeguimientoAlcaldia
		,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
		,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
		,SG.Observaciones AS ObservacionesSeguimientoGobernacion
		,ObservacionesSegundo
		,NombreAdjuntoSegundo

		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoProgramas AS SMP
		WHERE SMP.IdSeguimiento =SM.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimero			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoProgramas AS SMP
		WHERE SMP.IdSeguimiento =SM.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundo			
		
		FROM [PAT].PreguntaPAT A (nolock)
		join [PAT].[PreguntaPATMunicipio] as PM (nolock) on A.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		inner join [PAT].Componente b (nolock) on b.Id = a.IdComponente
		inner join [PAT].Medida c (nolock) on c.Id = a.IdMedida
		inner join [PAT].UnidadMedida d (nolock) on d.Id = a.IdUnidadMedida
		inner join [PAT].Derecho e (nolock) on e.Id = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT RM (nolock) ON RM.IdPreguntaPAT = A.Id  and RM.IdMunicipio = @IdMunicipio--AND RM.ID_ENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
		LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA  (nolock)ON RMA.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP  (nolock) ON RMP.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = A.ID AND SM.IdUsuario = @IdUsuario AND SM.IdTablero = @IdTablero
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG (nolock) ON SG.IdPregunta = A.ID AND SG.IdUsuarioAlcaldia = @IdUsuario AND SG.IdTablero = @IdTablero
		WHERE  a.IdTablero= @IdTablero 
		AND A.NIVEL = 3		
		and a.ACTIVO = 1
		) as A
		ORDER BY Derecho ASC, IdPregunta ASC 
END

go
