-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/08/2017
-- Modified date:	28/11/2017
-- Description:		Retorna el numero de seguimiento de acuerdo al momento en el que se llame el procedimiento
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoMunicipio] --[PAT].[C_TableroSeguimientoMunicipio] 1, 1, 411
(	@IdDerecho INT
	,@IdTablero INT
	,@IdUsuario INT
)
AS
BEGIN

		declare @IdMunicipio int
		select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

		select distinct
		e.Descripcion as Derecho
		,b.Descripcion as Componente
		,c.Descripcion as Medida
		,a.PreguntaIndicativa
		,d.Descripcion as Unidad
		,a.PreguntaCompromiso
		,ISNULL(f.IdSeguimiento, 0) as IdSeguimiento
		,ISNULL(f.CantidadPrimer, -1) as CompromisoPrimerSemestre
		,ISNULL(f.CantidadSegundo, -1) as CompromisoSegundoSemestre
		,ISNULL(f.CantidadPrimer + REPLACE(f.CantidadSegundo, -1, 0), -1) as CompromisoTotal
		,ISNULL(f.PresupuestoPrimer, -1) as PresupuestoPrimerSemestre
		,ISNULL(f.PresupuestoSegundo, -1) as PresupuestoSegundoSemestre
		,ISNULL(f.PresupuestoPrimer + REPLACE(f.PresupuestoSegundo, -1, 0), -1) as PresupuestoTotal
		,a.ID 
		,a.IdComponente 
		,a.IdDerecho 
		,a.IdMedida 
		,a.IdUnidadMedida
		,ISNULL(R.RespuestaCompromiso, 0) AS RespuestaIndicativa
		,ISNULL(R.Presupuesto, 0) AS Presupuesto, r.RespuestaIndicativa as NecesidadIdentificada,ExplicacionPregunta
		from [PAT].PreguntaPAT AS a
		join [PAT].[PreguntaPATMunicipio] as PM on a.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		inner join [PAT].Componente AS b on b.ID = a.IdComponente
		inner join [PAT].Medida AS c on c.ID = a.IdMedida
		inner join [PAT].UnidadMedida AS d on d.ID = a.IdUnidadMedida
		inner join [PAT].Derecho AS e on e.ID = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT as R on R.IdPreguntaPAT = a.ID and r.IdMunicipio = @IdMunicipio
		LEFT OUTER JOIN [PAT].Seguimiento as f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
		where a.ACTIVO = 1
		and e.ID = @IdDerecho
		and a.IdTablero = @IdTablero
		order by a.ID  asc
END



go

-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	20/11/2017
-- Description:		Trae el listado de todas las preguntas municipales del tablero, derecho y municipio indicado  
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroMunicipio] --[PAT].[C_TableroMunicipio] null, 1, 20, 411 , 1,3
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		IDPREGUNTA SMALLINT,IDDERECHO SMALLINT,IDCOMPONENTE TINYINT,IDMEDIDA SMALLINT,NIVEL TINYINT,
		PREGUNTAINDICATIVA NVARCHAR(500),IDUNIDADMEDIDA TINYINT,PREGUNTACOMPROMISO NVARCHAR(500),APOYODEPARTAMENTAL BIT,
		APOYOENTIDADNACIONAL BIT,ACTIVO BIT,DERECHO NVARCHAR(50),COMPONENTE NVARCHAR(100),MEDIDA NVARCHAR(50),
		UNIDADMEDIDA NVARCHAR(100),IDTABLERO TINYINT,IDENTIDAD INT,ID INT,RESPUESTAINDICATIVA INT,
		RESPUESTACOMPROMISO INT,PRESUPUESTO MONEY,OBSERVACIONNECESIDAD NVARCHAR(1000),ACCIONCOMPROMISO NVARCHAR(1000), 
		RequiereAdjunto bit,MensajeAdjunto NVARCHAR(max),ExplicacionPregunta NVARCHAR(max),NombreAdjunto NVARCHAR(200), ObservacionPresupuesto NVARCHAR(max)
		)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize 

	SET @ORDEN = @sortOrder
	SET @ORDEN = 'P.ID'
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	Declare @IdMunicipio int
	SELECT @IdMunicipio =  U.[IdMunicipio] FROM [dbo].[Usuario] (NOLOCK) U WHERE U.ID = @IdUsuario
	
	SET @SQL = 'SELECT 	DISTINCT
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO,
		RequiereAdjunto,MensajeAdjunto,ExplicacionPregunta,NombreAdjunto,ObservacionPresupuesto
		FROM (
		SELECT DISTINCT TOP (@TOP) LINEA,
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO,
		RequiereAdjunto,MensajeAdjunto,ExplicacionPregunta,NombreAdjunto,ObservacionPresupuesto
	FROM ( 
    SELECT DISTINCT row_number() OVER (ORDER BY '+ @ORDEN +') AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID ,
						R.RespuestaIndicativa, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO,
						P.RequiereAdjunto,
						P.MensajeAdjunto,
						P.ExplicacionPregunta,
						R.NombreAdjunto,
						R.ObservacionPresupuesto
				FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdMunicipio =  @IdMunicipio ,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T,
						[PAT].[PreguntaPATMunicipio] as PM
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND P.ID = PM.IdPreguntaPAT and PM.IdMunicipio = @IdMunicipio
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 					
					AND D.ID = @IdDerecho'	
	SET @SQL =@SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY LINEA ) AS T'
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IdMunicipio INT,@IdDerecho INT'
		
	--PRINT @SQL
	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IdMunicipio=@IdMunicipio, @IdDerecho=@IdDerecho
	SELECT * from @RESULTADO
END

go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		10/07/2017
-- Modified date:	28/11/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT departamental
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroDepartamento]  --[PAT].[C_TableroDepartamento] 375,1
 (@IdUsuario INT, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE  @IdDepartamento INT	
	select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

	SELECT distinct	P.Id AS ID_PREGUNTA, 
			P.IdDerecho, 
			P.IdComponente, 
			P.IdMedida, 
			P.NIVEL as Nivel, 
			P.PreguntaIndicativa, 
			P.IdUnidadMedida, 
			P.PreguntaCompromiso, 
			P.ApoyoDepartamental, 
			P.ApoyoEntidadNacional, 
			P.ACTIVO as Activo, 
			DERECHO.Descripcion AS Derecho, 
			COMPONENTE.Descripcion AS Componente, 
			MEDIDA.Descripcion AS Medida, 
			UNIDAD_MEDIDA.Descripcion AS UnidadMedida,	
			@idTablero AS IdTablero,			
			@IdDepartamento AS IdEntidad,						
			R.Id as IdRespuesta,
			R.RespuestaIndicativa,  
			R.RespuestaCompromiso, 
			R.Presupuesto,
			R.ObservacionNecesidad, 
			R.AccionCompromiso,
			P.RequiereAdjunto,
			P.MensajeAdjunto,
			P.ExplicacionPregunta,
			R.NombreAdjunto 
	FROM  PAT.PreguntaPAT AS P
	JOIN PAT.PreguntaPATDepartamento AS PD ON P.Id = PD.IdPreguntaPAT AND PD.IdDepartamento =@IdDepartamento
	INNER JOIN PAT.Derecho DERECHO ON P.IdDerecho = DERECHO.Id 
	INNER JOIN PAT.Componente COMPONENTE ON P.IdComponente= COMPONENTE.Id
	INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
	INNER JOIN PAT.UnidadMedida UNIDAD_MEDIDA ON P.IdUnidadMedida = UNIDAD_MEDIDA.Id
	LEFT OUTER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id	
	LEFT OUTER JOIN [PAT].[RespuestaPAT] AS R ON P.Id = R.IdPreguntaPAT AND R.IdDepartamento =  @IdDepartamento 	
	WHERE TABLERO.Id = @idTablero
	AND	P.NIVEL = 2 and P.ACTIVO = 1
END

go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez -Vilma rodriguez
-- Create date:		29/08/2017
-- Modified date:	28/11/2017
-- Description:		Obtiene informacion de las preguntas por departamento para el seguimiento de un tablero departamental
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDepartamento] -- [PAT].[C_TableroSeguimientoDepartamento] 1, 1013
(	@IdTablero INT ,@IdUsuario INT )
AS
BEGIN		
		DECLARE  @IdDepartamento INT	
		select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

		select distinct
		e.Descripcion as Derecho
		,b.Descripcion as Componente
		,c.Descripcion as Medida
		,a.PreguntaIndicativa
		,d.Descripcion as Unidad
		,a.PreguntaCompromiso
		,ISNULL(f.IdSeguimiento, 0) as IdSeguimiento
		,ISNULL(f.CantidadPrimer, -1) as CompromisoPrimerSemestre
		,ISNULL(f.CantidadSegundo, -1) as CompromisoSegundoSemestre
		,ISNULL(f.CantidadPrimer + REPLACE(f.CantidadSegundo, -1, 0), -1) as CompromisoTotal
		,ISNULL(f.PresupuestoPrimer, -1) as PresupuestoPrimerSemestre
		,ISNULL(f.PresupuestoSegundo, -1) as PresupuestoSegundoSemestre
		,ISNULL(f.PresupuestoPrimer + REPLACE(f.PresupuestoSegundo, -1, 0), -1) as PresupuestoTotal
		,a.Id 
		,a.IdComponente 
		,a.IdDerecho
		,a.IdMedida 
		,a.IdUnidadMedida
		,ISNULL(R.RespuestaCompromiso, 0) AS RespuestaIndicativa
		,ISNULL(R.Presupuesto, 0) AS Presupuesto
		from [PAT].PreguntaPAT AS a
		join pat.PreguntaPATDepartamento as PD on a.Id = PD.IdPreguntaPAT and PD.IdDepartamento = @IdDepartamento
		inner join [PAT].Componente b on b.Id = a.IdComponente
		inner join [PAT].[Medida] c on c.Id = a.IdMedida
		inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
		inner join [PAT].Derecho e on e.Id = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT R on R.IdPreguntaPAT = a.ID and R.IdDepartamento= @IdDepartamento
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
		where a.IdTablero = @IdTablero
		and a.NIVEL = 2
		order by a.Id  asc
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_SeguimientoDepartamentoPorMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_SeguimientoDepartamentoPorMunicipio] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/11/2017
-- Modified date:	28/11/2017
-- Description:		Obtiene informacion para el seguimiento para el detalle del consolidado para los municipios que respondieron la pregunta indicada
-- =============================================
ALTER PROC  [PAT].[C_SeguimientoDepartamentoPorMunicipio] --pat.C_SeguimientoDepartamentoPorMunicipio 15218,22
( @IdMunicipio INT ,@IdPregunta INT )
AS
BEGIN
	declare @idDepartamento int
	select @idDepartamento = IdDepartamento from Municipio where Id =@IdMunicipio
	SELECT DISTINCT 
	 A.Id AS IdPRegunta
	,A.PreguntaIndicativa 
	,RM.IdMunicipio
	,M.Nombre AS Municipio 	
	,RD.RespuestaCompromiso AS CompromisoG
	,RD.Presupuesto as PresupuestoG
	,ISNULL(SG.CantidadPrimer, 0) AS CantidadPrimerSemestreG
	,ISNULL(SG.CantidadSegundo, 0) AS CantidadSegundoSemestreG	
	,ISNULL(SG.PresupuestoPrimer, 0) AS PresupuestoPrimerSemestreG
	,ISNULL(SG.PresupuestoSegundo, 0) AS PresupuestoSegundoSemestreG	
	,ISNULL(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, 0, 0), 0) as CompromisoTotalG
	,ISNULL(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, 0, 0), 0) as PresupuestoTotalG
	FROM [PAT].PreguntaPAT A
	LEFT OUTER JOIN [PAT].RespuestaPAT RM ON A.Id =RM.IdPreguntaPAT and RM.IdDepartamento = @IdDepartamento and IdMunicipio is not null --para que tome las respuestas de alcaldias
	LEFT OUTER JOIN Municipio AS M ON RM.IdMunicipio = M.ID
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON A.Id=RD.IdPreguntaPAT   and RD.IdMunicipioRespuesta = RM.IdMunicipio --AND RD.IdUsuario = @IdUsuario
	LEFT OUTER JOIN [PAT].seguimiento SM ON A.ID =SM.IdPregunta AND SM.IdTablero = A.IdTablero AND  SM.IdUsuario = RM.IdUsuario
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  A.ID =SG.IdPregunta  AND A.IdTablero=SG.IdTablero  AND RM.IdUsuario =SG.IdUsuarioAlcaldia --[PAT].[fn_GetIdUsuario](RM.ID_ENTIDAD)
	WHERE A.ID = @IdPregunta and RD.IdMunicipioRespuesta = 	@IdMunicipio

END

go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_SeguimientoNacionalPorMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_SeguimientoNacionalPorMunicipio] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/11/2017
-- Modified date:	28/11/2017
-- Description:		Obtiene informacion del seguimiento municipal de la informacion de entidades nacionales.(esta pendiente de implementar dado que no se tiene informacion)
-- =============================================
ALTER PROC  [PAT].[C_SeguimientoNacionalPorMunicipio] --pat.[C_SeguimientoNacionalPorMunicipio] 5172,21
( @IdMunicipio INT ,@IdPregunta INT )
AS
BEGIN
		
	declare @CompromisoN int, @PresupuestoN int, @CantidadPrimerSemestreN int,@CantidadSegundoSemestreN int,@PresupuestoPrimerSemestreN int,@PresupuestoSegundoSemestreN int, @CompromisoTotalN INT,@PresupuestoTotalN INT			
	select   @CompromisoN =0, @PresupuestoN = 0,@CantidadPrimerSemestreN = 0,@CantidadSegundoSemestreN = 0, @PresupuestoPrimerSemestreN = 0, @PresupuestoSegundoSemestreN = 0, @CompromisoTotalN = 0,@PresupuestoTotalN = 0				
	
	select   @CompromisoN as CompromisoN  , @PresupuestoN as PresupuestoN ,@CantidadPrimerSemestreN as CantidadPrimerSemestreN,@CantidadSegundoSemestreN as CantidadSegundoSemestreN , @PresupuestoPrimerSemestreN as PresupuestoPrimerSemestreN , @PresupuestoSegundoSemestreN as PresupuestoSegundoSemestreN , @CompromisoTotalN as CompromisoTotalN  ,@PresupuestoTotalN as PresupuestoTotalN
	
END

go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	14/11/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para una pregunta en especial
-- =============================================
ALTER PROC [PAT].[C_TableroSeguimientoConsolidadoDepartamento] --[PAT].[C_TableroSeguimientoConsolidadoDepartamento]  1, 375, 1
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
--WHERE
--E.ID = @IdDerecho
--AND A.ACTIVO = @Activo
--AND A.ID >= @IdPreguntaIni AND A.ID <= @IdPreguntaFin
--GROUP BY
--B.DESCRIPCION, C.DESCRIPCION, A.PREGUNTA_INDICATIVA, D.DESCRIPCION, E.DESCRIPCION, A.ID, E.ID

	SELECT DISTINCT
	B.Descripcion AS Componente
	,C.Descripcion AS Medida
	,E.Descripcion AS Derecho
	,A.PreguntaIndicativa 
	,D.DESCRIPCION AS UNIDAD
	
	,SUM(ISNULL(RD.RespuestaCompromiso, 0)) AS TotalCompromiso
	,SUM(ISNULL(RD.Presupuesto, 0)) AS TotalPresupuesto
	
	,ISNULL(SUM(SM.CantidadPrimer), -1) AS AvancePrimerSemestreAlcladias
	,ISNULL(SUM(SM.CantidadSegundo), -1) AS AvanceSegundoSemestreAlcladias

	,ISNULL(SUM(SG.CantidadPrimer), -1) AS AvancePrimerSemestreGobernaciones
	,ISNULL(SUM(SG.CantidadSegundo), -1) AS AvanceSegundoSemestreGobernaciones
	,A.Id AS IdPregunta
	,E.Id AS IdDerecho
	FROM [PAT].PreguntaPAT as A
	--join [PAT].[PreguntaPATMunicipio] as PM on A.Id = PM.IdPreguntaPAT
	--join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = IDDEPARTAMENTO
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	LEFT OUTER JOIN [PAT].RespuestaPAT RM ON A.Id =RM.IdPreguntaPAT and RM.IdDepartamento = @IdDepartamento and RM.IdMunicipio is not null --para que tome las respuestas de alcaldias
	LEFT OUTER JOIN Municipio AS M ON RM.IdMunicipio = M.ID
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON A.Id=RD.IdPreguntaPAT  AND RD.IdUsuario = @IdUsuario and RD.IdMunicipioRespuesta = RM.IdMunicipio 	
	LEFT OUTER JOIN [PAT].Seguimiento as SM ON A.ID= SM.IdPregunta AND a.IdTablero =SM.IdTablero AND  RD.IdUsuario = SM.IdUsuario 
	LEFT OUTER join Usuario as URS on SM.IdUsuario = URS.Id and  RD.IdMunicipioRespuesta  =URS.IdMunicipio
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion as SG ON A.ID =SG.IdPregunta AND SG.IdTablero = SM.IdTablero AND SG.IdUsuarioAlcaldia = SM.IdUsuario
	WHERE  A.IdTablero = @IdTablero
	and A.Nivel = 3
	and E.ID = @IdDerecho
	AND A.ACTIVO = 1		
	GROUP BY
	B.Descripcion, C.Descripcion, A.PreguntaIndicativa, D.Descripcion, E.Descripcion, A.Id, E.Id

END

go