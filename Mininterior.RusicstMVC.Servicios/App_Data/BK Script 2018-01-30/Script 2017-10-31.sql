
--------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	25/10/2017
-- Description:		Obtiene informacion para el seguimiento para el detalle del consolidado para los municipios que respondieron la pregunta indicada
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] --pat.C_TableroSeguimientoDetalleConsolidadoDepartamento 1,375,21
( @IdTablero INT ,@IdUsuario INT ,@IdPregunta INT )
AS
BEGIN
	declare @IdMunicipio int, @IdDepartamento int
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	SELECT DISTINCT 
	B.Descripcion AS Componente
	,C.Descripcion AS Medida
	,E.Descripcion AS Derecho
	,A.PreguntaIndicativa 
	,D.Descripcion AS Unidad
	,RM.IdMunicipio
	,M.Nombre AS Municipio 
	,RM.RespuestaIndicativa AS  NecesidadIdentificada 
	,RM.RespuestaCompromiso 
	,RD.RespuestaCompromiso AS CompromisoGobernacion
	,ISNULL(SM.CantidadPrimer, -1) AS CantidadPrimerSemestre
	,ISNULL(SM.CantidadSegundo, -1) AS CantidadSegundoSemestre
	,A.Id AS IdPRegunta
	,E.Id AS IdDerecho
	,RM.IdUsuario AS IdUsuarioAlcaldia
	,ISNULL(SG.IdSeguimiento, 0) AS IdSeguimiento
	,(SELECT TOP 1 XX.Id FROM [PAT].RespuestaPAT XX  
							join pat.PreguntaPAT as p on XX.IdPreguntaPAT = p.Id
							WHERE XX.IdMunicipio = @IdMunicipio and XX.IdPreguntaPAT = @IdPregunta and p.IdTablero = @IdTablero) AS IdRespuestaDepartamentoMunicipio
	FROM [PAT].PreguntaPAT A
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	LEFT OUTER JOIN [PAT].RespuestaPAT RM ON A.Id =RM.IdPreguntaPAT and RM.IdDepartamento = @IdDepartamento and IdMunicipio is not null --para que tome las respuestas de alcaldias
	LEFT OUTER JOIN Municipio AS M ON RM.IdMunicipio = M.ID
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON A.Id=RD.IdPreguntaPAT  AND RD.IdUsuario = @IdUsuario and RD.IdMunicipioRespuesta = RM.IdMunicipio 
	LEFT OUTER JOIN [PAT].seguimiento SM ON A.ID =SM.IdPregunta AND SM.IdTablero = A.IdTablero AND  SM.IdUsuario = RM.IdUsuario
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  A.ID =SG.IdPregunta  AND A.IdTablero=SG.IdTablero  AND RM.IdUsuario =SG.IdUsuarioAlcaldia --[PAT].[fn_GetIdUsuario](RM.ID_ENTIDAD)
	WHERE   a.IdTablero= @IdTablero and A.ID = @IdPregunta
	order by M.Nombre asc

END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ConsolidadosMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ConsolidadosMunicipio] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	25/10/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados por municipios de la pregunta indicada
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_ConsolidadosMunicipio]   ( @IdUsuario INT, @idPregunta INT, @idTablero tinyint)--1513,7,1
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE  @IDENTIDAD INT, @NOMBREMUNICIPIO VARCHAR(100), @IdDepartamento int
	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
	SELECT @NOMBREMUNICIPIO = Nombre FROM Municipio WHERE Id = 	@IDENTIDAD	
	select @IdDepartamento = IdDepartamento from Municipio where Id =@IDENTIDAD 			
	print @IdDepartamento

	select distinct D.Descripcion AS DERECHO, 	
	C.Descripcion AS COMPONENTE,
	M.Descripcion AS MEDIDA,
	P.Id AS ID_PREGUNTA,
	P.PreguntaIndicativa,
	Mun.Id as ID_MUNICIPIO_RESPUESTA,
	Mun.Nombre as ENTIDAD,
	R.RespuestaIndicativa AS INDICATIVA_MUNICIPIO,
	R.RespuestaCompromiso AS COMPROMISO_MUNICIPIO,
	R.Presupuesto AS PRESUPUESTO_MUNICIPIO,
	P.IdTablero AS ID_TABLERO,
	RESPUESTA.Id,
	RESPUESTA.RespuestaCompromiso, 
	RESPUESTA.Presupuesto,
	RESPUESTA.ObservacionCompromiso 
	FROM  [PAT].[PreguntaPAT] AS P 
	JOIN [PAT].[RespuestaPAT] R ON R.IdPreguntaPAT = P.Id AND P.Nivel = 3
	JOIN Municipio as Mun on R.IdMunicipio = Mun.Id
	LEFT OUTER JOIN (select top 1 * from [PAT].[RespuestaPATDepartamento] order by Id desc ) AS RESPUESTA on  P.Id = RESPUESTA.IdPreguntaPAT and R.IdMunicipio = RESPUESTA.IdMunicipioRespuesta,	
	[PAT].[Derecho] D,
	[PAT].[Componente] C,
	[PAT].[Medida] M,
	[PAT].[Tablero] T
	WHERE P.IDDERECHO = D.ID 
	AND P.IDCOMPONENTE = C.ID 
	AND P.IDMEDIDA = M.ID 
	AND P.IDTABLERO = T.ID
	AND T.ID = @idTablero 
	AND P.ACTIVO = 1 
	AND P.Id = @idPregunta
	and Mun.IdDepartamento = @IdDepartamento	
	order by Mun.Nombre

END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoConsolidadoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoConsolidadoDepartamento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	25/10/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para una pregunta en especial
-- =============================================
ALTER PROC [PAT].[C_TableroSeguimientoConsolidadoDepartamento] --[PAT].[C_TableroSeguimientoConsolidadoDepartamento]  1, 375, 6
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
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	LEFT OUTER JOIN [PAT].RespuestaPAT RM ON A.Id =RM.IdPreguntaPAT and RM.IdDepartamento = @IdDepartamento and IdMunicipio is not null --para que tome las respuestas de alcaldias
	LEFT OUTER JOIN Municipio AS M ON RM.IdMunicipio = M.ID
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON A.Id=RD.IdPreguntaPAT  AND RD.IdUsuario = @IdUsuario and RD.IdMunicipioRespuesta = RM.IdMunicipio 	
	LEFT OUTER JOIN [PAT].Seguimiento as SM ON A.ID= SM.IdPregunta AND a.IdTablero =SM.IdTablero AND  RD.IdUsuario = SM.IdUsuario 
	LEFT OUTER join Usuario as URS on SM.IdUsuario = URS.Id and  RD.IdMunicipioRespuesta  =URS.IdMunicipio
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion as SG ON A.ID =SG.IdPregunta AND SG.IdTablero = SM.IdTablero AND SG.IdUsuarioAlcaldia = SM.IdUsuario
	WHERE  A.IdTablero = @IdTablero
	and E.ID = @IdDerecho
	AND A.ACTIVO = 1		
	GROUP BY
	B.Descripcion, C.Descripcion, A.PreguntaIndicativa, D.Descripcion, E.Descripcion, A.Id, E.Id

END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_EvaluacionSeguimiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_EvaluacionSeguimiento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez 
-- Create date:		17/10/2017
-- Modified date:	25/10/2017
-- Description:		Obtiene informacion para la evaluacion de un seguimiento
-- =============================================
ALTER PROC  [PAT].[C_EvaluacionSeguimiento] -- [PAT].[C_EvaluacionSeguimiento] 1, 11,11001,1, 375
(	@IdTablero INT , @IdDepartamento int, @IdMunicipio int,@IdDerecho int , @IdUsuario int)
AS
BEGIN			
		if (@IdMunicipio = 0)
		BEGIN 
		--Si es para todos los municipios:
		--Seguimiento Primer Semestre:(∑Avance Compromisos Primer Semestre de todos los municipios/ ∑ Compromisos  de todos los municipios)
		--Seguimiento Acumulado Anual: Lo mismo de arriba pero acumulado anual					
		select A.Id as IdPregunta, A.PreguntaIndicativa--, R.RespuestaCompromiso, R.Presupuesto, SG.CantidadPrimer, SG.PresupuestoPrimer
		--datos de alcaldias--		
		,isnull(CONVERT(DECIMAL(10,2),SUM(case when R.RespuestaCompromiso is null then 0 else SA.CantidadPrimer end) /SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end)),0) as AvancePrimerSemestreAlcaldias 		
		,isnull(CONVERT(DECIMAL(10,2),SUM(case when R.RespuestaCompromiso is null then 0 else SA.CantidadPrimer + SA.CantidadSegundo end) /SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end)),0) as AvanceSegundoSemestreAlcaldias 
		,isnull(SUM(case when R.Presupuesto is null then 0 else SA.PresupuestoPrimer end) /SUM(case when R.Presupuesto is null then 0 else R.Presupuesto end),0) as AvancePresupuestoPrimerSemestreAlcaldias 		
		,isnull(SUM(case when R.Presupuesto is null then 0 else SA.PresupuestoPrimer + SA.PresupuestoSegundo end) /SUM(case when R.Presupuesto is null then 0 else R.Presupuesto end),0) as AvancePresupuestoSegundoSemestreAlcaldias 		
		--datos de gobernaciones--
		,isnull(CONVERT(DECIMAL(10,2),SUM(case when R.RespuestaCompromiso is null then 0 else SG.CantidadPrimer end) /SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end)),0) as AvancePrimerSemestreGobernaciones 		
		,isnull(CONVERT(DECIMAL(10,2),SUM(case when R.RespuestaCompromiso is null then 0 else SG.CantidadPrimer + SG.CantidadSegundo end) /SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end)),0) as AvanceSegundoSemestreGobernaciones 
		,isnull(SUM(case when R.Presupuesto is null then 0 else SG.PresupuestoPrimer end) /SUM(case when R.Presupuesto is null then 0 else R.Presupuesto end),0) as AvancePresupuestoPrimerSemestreGobernaciones 		
		,isnull(SUM(case when R.Presupuesto is null then 0 else SG.PresupuestoPrimer + SG.PresupuestoSegundo end) /SUM(case when R.Presupuesto is null then 0 else R.Presupuesto end),0) as AvancePresupuestoSegundoSemestreGobernaciones 		
		FROM [PAT].PreguntaPAT as A		
		left outer join PAT.RespuestaPAT as R on A.Id = R.IdPreguntaPAT  and R.IdDepartamento = @IdDepartamento
		left outer join PAT.SeguimientoGobernacion as SG on A.Id = SG.IdPregunta and SG.IdUsuario = @IdUsuario	--usuario gobernacion			
		left outer join PAT.Seguimiento as SA on A.Id = SA.IdPregunta  and SA.IdUsuario = R.IdUsuario --usuario alcaldia 
		where A.Nivel = 3  and A.IdTablero = @IdTablero and A.IdDerecho = @IdDerecho
		group by A.Id,A.PreguntaIndicativa
		order by A.PreguntaIndicativa

		end
		else	
		BEGIN
			--Si es un muunicipio del departamento:
			--Seguimiento Primer Semestre:(Avance Presupuesto Primer Semestre/ Presupuesto)
			--Seguimiento Acumulado Anual:(Avance Compromisos Acumulado Anual/ Compromisos)

			select A.Id as IdPregunta, A.PreguntaIndicativa, R.RespuestaCompromiso, R.Presupuesto, SG.CantidadPrimer, SG.PresupuestoPrimer
			--datos de alcaldias--
			,CASE WHEN R.RespuestaCompromiso >0 THEN ISNULL( CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),SA.CantidadPrimer)/R.RespuestaCompromiso),0) ELSE 0 END as AvancePrimerSemestreAlcaldias 
			,CASE WHEN R.Presupuesto >0 THEN ISNULL(SA.PresupuestoPrimer/R.Presupuesto,0) ELSE 0 END as AvancePresupuestoPrimerSemestreAlcaldias
			,CASE WHEN R.RespuestaCompromiso >0 THEN ISNULL(CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),(SA.CantidadPrimer + SA.CantidadSegundo))/R.RespuestaCompromiso),0) ELSE 0 END as AvanceSegundoSemestreAlcaldias
			,CASE WHEN R.Presupuesto >0 THEN ISNULL((SA.PresupuestoPrimer + SA.PresupuestoSegundo)/R.Presupuesto,0) ELSE 0 END as AvancePresupuestoSegundoSemestreAlcaldias
			--datos de gobernaciones--
			,CASE WHEN R.RespuestaCompromiso >0 THEN ISNULL( CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),SG.CantidadPrimer)/R.RespuestaCompromiso),0) ELSE 0 END as AvancePrimerSemestreGobernaciones 
			,CASE WHEN R.Presupuesto >0 THEN ISNULL(SG.PresupuestoPrimer/R.Presupuesto,0) ELSE 0 END as AvancePresupuestoPrimerSemestreGobernaciones
			,CASE WHEN R.RespuestaCompromiso >0 THEN ISNULL(CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),(SG.CantidadPrimer + SG.CantidadSegundo))/R.RespuestaCompromiso),0) ELSE 0 END as AvanceSegundoSemestreGobernaciones 
			,CASE WHEN R.Presupuesto >0 THEN ISNULL((SG.PresupuestoPrimer + SG.PresupuestoSegundo)/R.Presupuesto,0) ELSE 0 END as AvancePresupuestoSegundoSemestreGobernaciones
			FROM [PAT].PreguntaPAT as A		
			left outer join PAT.RespuestaPAT as R on A.Id = R.IdPreguntaPAT  and R.IdDepartamento = 5 AND R.IdMunicipio = 5172
			left outer join PAT.SeguimientoGobernacion as SG on A.Id = SG.IdPregunta and SG.IdUsuario = 375	--usuario gobernacion			
			left outer join PAT.Seguimiento as SA on A.Id = SA.IdPregunta  and SA.IdUsuario = R.IdUsuario --usuario alcaldia 
			where A.Nivel = 3  and A.IdTablero = 1 and A.IdDerecho = 1
			order by A.PreguntaIndicativa			
		end
END

go

IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Administración Tableros PAT' AND IdRecurso = 14)
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON	
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso]) VALUES (67, 'Administración Tableros PAT', NULL, 14)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ListadoAdministracionTableros]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ListadoAdministracionTableros] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	28/10/2017
-- Description:		Procedimiento que trae el listado de todos los tableros para su administracion 
-- =============================================
ALTER PROCEDURE [PAT].[C_ListadoAdministracionTableros]	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT tf.Id, tf.IdTablero, YEAR(tf.VigenciaInicio+1) as anoTablero, tf.Nivel, case when tf.Nivel =1 then 'Municipal'  when tf.Nivel =2 then 'Departamental' else 'Nacional' end as NombreNivel ,
	tf.VigenciaInicio, tf.VigenciaFin, Activo, tf.Seguimiento1Inicio, tf.Seguimiento1Fin, tf.Seguimiento2Inicio, tf.Seguimiento2Fin
	FROM PAT.TableroFecha as tf 	
END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ListadoAdministracionTableros]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ListadoAdministracionTableros] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	28/10/2017
-- Description:		Procedimiento que trae el listado de todos los tableros para su administracion 
-- =============================================
ALTER PROCEDURE [PAT].[C_ListadoAdministracionTableros]	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT tf.Id, tf.IdTablero, YEAR(tf.VigenciaInicio+1) as anoTablero, tf.Nivel, case when tf.Nivel =1 then 'Nacional'  when tf.Nivel =2 then 'Departamental' else 'Municipal' end as NombreNivel ,
	tf.VigenciaInicio, tf.VigenciaFin, Activo, tf.Seguimiento1Inicio, tf.Seguimiento1Fin, tf.Seguimiento2Inicio, tf.Seguimiento2Fin
	FROM PAT.TableroFecha as tf 	
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_TableroPatInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_TableroPatInsert] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-10-28																			  
/Descripcion: Inserta la información del tablero municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_TableroPatInsert] 					   			
		AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	declare @id int	
	
	BEGIN TRY
		--Inserta el tablero general
		INSERT INTO [PAT].[Tablero]([VigenciaInicio],[VigenciaFin],[Activo]) VALUES  (GETDATE() ,getdate() ,0)
		select @id = SCOPE_IDENTITY()
		--Inserta los 3 niveles
		INSERT INTO [PAT].[TableroFecha] ([IdTablero] ,[Nivel],[VigenciaInicio],[VigenciaFin],[Activo],[Seguimiento1Inicio],[Seguimiento1Fin],[Seguimiento2Inicio],[Seguimiento2Fin])
		VALUES(@id,1,GETDATE(), GETDATE(),0, null, null, null, null)
		INSERT INTO [PAT].[TableroFecha] ([IdTablero] ,[Nivel],[VigenciaInicio],[VigenciaFin],[Activo],[Seguimiento1Inicio],[Seguimiento1Fin],[Seguimiento2Inicio],[Seguimiento2Fin])
		VALUES(@id,2,GETDATE(), GETDATE(),0, null, null, null, null)
		INSERT INTO [PAT].[TableroFecha] ([IdTablero] ,[Nivel],[VigenciaInicio],[VigenciaFin],[Activo],[Seguimiento1Inicio],[Seguimiento1Fin],[Seguimiento2Inicio],[Seguimiento2Fin])
		VALUES(@id,3,GETDATE(), GETDATE(),0, null, null, null, null)
		
		SELECT @respuesta = 'Se ha ingresado el registro'
		SELECT @estadoRespuesta = 1
	
	END TRY
	BEGIN CATCH
		SELECT @respuesta = ERROR_MESSAGE()
		SELECT @estadoRespuesta = 0
	END CATCH
	
	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_TableroPatUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_TableroPatUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-10-28																			  
/Descripcion: Actualiza la información de las preguntas 
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_TableroPatUpdate] 
			  @Id int,
			  @IdTablero int,
			  @Nivel tinyint,
			  @VigenciaInicio smalldatetime,
			  @VigenciaFin smalldatetime,
			  @Activo bit,
			  @Seguimiento1Inicio datetime,
			  @Seguimiento1Fin datetime,
			  @Seguimiento2Inicio datetime,
			  @Seguimiento2Fin datetime
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado

	BEGIN TRY		
		UPDATE [PAT].[TableroFecha]
		SET [IdTablero] = @IdTablero 
			,[Nivel] = @Nivel
			,[VigenciaInicio] = @VigenciaInicio
			,[VigenciaFin] = @VigenciaFin
			,[Activo] = @Activo
			,[Seguimiento1Inicio] = @Seguimiento1Inicio
			,[Seguimiento1Fin] = @Seguimiento1Fin
			,[Seguimiento2Inicio] = @Seguimiento2Inicio
			,[Seguimiento2Fin] = @Seguimiento2Fin
		WHERE  Id = @id
		--si por lo menos se tiene un nivel activo se debe activar el tablero
		if ((select COUNT(1) from PAT.[TableroFecha] where Activo = 1  and  IdTablero = @IdTablero )>0)
			update PAT.Tablero set Activo = 1 where Id = @IdTablero
		--si todas estan inactivas de debe inactivar el tablero
		if ((select COUNT(1) from PAT.[TableroFecha] where Activo = 0 and  IdTablero = @IdTablero )=3)
			update PAT.Tablero set Activo = @Activo where Id = @IdTablero
		SELECT @respuesta = 'Se ha modificado el registro'
		SELECT @estadoRespuesta = 2
	
	END TRY
	BEGIN CATCH
		SELECT @respuesta = ERROR_MESSAGE()
		SELECT @estadoRespuesta = 0
	END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado			

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_PreguntasPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_PreguntasPat] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	21/07/2017
-- Description:		Obtiene las preguntas del PAT para la rejilla
-- =============================================
ALTER PROCEDURE [PAT].[C_PreguntasPat] 
			  @IdTablero int ,
			  @Nivel tinyint 
AS
BEGIN
	SET NOCOUNT ON;	
	if @IdTablero =0
		SELECT P.Id,
		P.IdDerecho, P.IdComponente, P.IdMedida, 
		M.Descripcion as Medida,
		P.PreguntaIndicativa, 
		UM.Descripcion as UnidadMedida,
		P.PreguntaCompromiso, 
		d.Descripcion as Derecho, 
		C.Descripcion as Componente,
		P.Nivel, 
		P.IdTablero,
		P.Activo,				
		P.IdUnidadMedida, 
		P.ApoyoDepartamental, 
		P.ApoyoEntidadNacional		
		FROM    [PAT].[PreguntaPAT] as P, 
		[PAT].[Derecho] D,
		[PAT].[Componente] C,
		[PAT].[Medida] M,
		[PAT].[UnidadMedida] UM
		WHERE P.IDDERECHO = D.ID 
		AND P.IDCOMPONENTE = C.ID 
		AND P.IDMEDIDA = M.ID 
		AND P.IDUNIDADMEDIDA = UM.ID 	
	else
		SELECT P.Id,
		P.IdDerecho, P.IdComponente, P.IdMedida, 
		M.Descripcion as Medida,
		P.PreguntaIndicativa, 
		UM.Descripcion as UnidadMedida,
		P.PreguntaCompromiso, 
		d.Descripcion as Derecho, 
		C.Descripcion as Componente,
		P.Nivel, 
		P.IdTablero,
		P.Activo,				
		P.IdUnidadMedida, 
		P.ApoyoDepartamental, 
		P.ApoyoEntidadNacional		
		FROM    [PAT].[PreguntaPAT] as P, 
		[PAT].[Derecho] D,
		[PAT].[Componente] C,
		[PAT].[Medida] M,
		[PAT].[UnidadMedida] UM
		WHERE P.IDDERECHO = D.ID 
		AND P.IDCOMPONENTE = C.ID 
		AND P.IDMEDIDA = M.ID 
		AND P.IDUNIDADMEDIDA = UM.ID 	
		and P.IdTablero = @IdTablero and P.Nivel = @Nivel
END
go


update PAT.PreguntaPAT set Activo = 0 where IdTablero = 1 and Id>103

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionSeccionesPlanMejoramiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionSeccionesPlanMejoramiento] AS'

GO

ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionSeccionesPlanMejoramiento] --11, 374
(
	@IdPlanMejoramiento INT
	,@IdUsuario INT
)
AS
BEGIN

SELECT 
A.*
,dbo.GetColorFromPorc(A.POrcTotal) as Color
FROM
(
SELECT c.IdSeccionPlanMejoramiento, c.Titulo, c.Ayuda, c.ObjetivoGeneral,	
	[dbo].[GetTotalPorcentajeSeccion](c.IdSeccionPlanMejoramiento, @IdUsuario) as POrcTotal
	
	FROM PlanesMejoramiento.Recomendacion a 
	INNER JOIN PlanesMejoramiento.ObjetivoEspecifico b ON a.IdObjetivoEspecifico = b.IdObjetivoEspecifico
	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c  ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramiento d ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
	INNER JOIN dbo.Pregunta g  ON g.Id = a.IdPregunta 
	INNER JOIN dbo.Seccion h ON h.Id = g.IdSeccion 
	--INNER JOIN dbo.Respuesta rr ON rr.Id = g.Id AND rr.Valor = a.Opcion
	WHERE d.IdPlanMejoramiento = @IdPlanMejoramiento
	GROUP BY c.IdSeccionPlanMejoramiento, c.Titulo, c.ObjetivoGeneral, c.Ayuda
) AS A
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramiento] AS'

GO

ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramiento] --8, 37, 'pruebasInterior'
(
	@IdPlanMejoramiento INT,
	@IdSeccionPlan INT,
	@IdUsuario INT
)
AS
BEGIN

	SELECT a.IdRecomendacion, a.Opcion, a.Recomendacion, a.Calificacion, 
	b.IdObjetivoEspecifico, b.ObjetivoEspecifico, b.PorcentajeObjetivo, 
	c.ObjetivoGeneral, c.IdSeccionPlanMejoramiento, c.Titulo, c.Ayuda, 
	d.IdPlanMejoramiento, d.Nombre, d.FechaLimite, d.CondicionesAplicacion, 
	CONVERT(VARCHAR, g.Id) AS CodigoPregunta, g.Texto AS NombrePregunta, tp.Nombre AS TipoPregunta, 
	
	ISNULL((select top 1 xx.Titulo from dbo.Seccion xx where xx.Id = a.IdEtapa), '') as EtapaNombre,
	a.IdEtapa as IdEtapa,
	
	--h.Titulo as EtapaNombre, h.Id as IdEtapa,
	
	case i.bitShowPorcentaje when 0 then 'hidePorc' else 'showPorc' end as CssClassName,
	case when GETDATE() between i.FechaInicio and i.FechaFin then 'showPorc' else 'hidePorc' end as CssAction
	,ISNULL(j.Observaciones, '') as [AvancesObservaciones], ISNULL(o.Avance, 0) as [AvanceNombre]
	,ISNULL(o.IdAvance, -1) as [IdAvance] ,ISNULL(j.FechaAvance, GETDATE()) as [AvancesFecha]
	,ISNULL(n.Accion, '') as [Accion], ISNULL(n.Responsable, '') as [AccionResponsable]
	,ISNULL(n.FechaCumplimiento, GETDATE()) as [AccionFecha]
	,ISNULL(p.IdAutoevaluacion, -1) as [IdAutoEv]
	FROM PlanesMejoramiento.Recomendacion a (NOLOCK)
	INNER JOIN PlanesMejoramiento.ObjetivoEspecifico b (NOLOCK) ON a.IdObjetivoEspecifico = b.IdObjetivoEspecifico
	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c (NOLOCK) ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramiento d (NOLOCK) ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta k (NOLOCK) ON k.IdPlanMejoriamiento = d.IdPlanMejoramiento 
	INNER JOIN dbo.Pregunta g (NOLOCK) ON g.Id = a.IdPregunta
	INNER JOIN dbo.TipoPregunta tp (NOLOCK) ON tp.Id = g.IdTipoPregunta
	INNER JOIN dbo.Seccion h (NOLOCK) ON h.Id = g.IdSeccion and h.IdEncuesta = k.IdEncuesta 
	INNER JOIN dbo.Respuesta rr (NOLOCK) ON rr.IdPregunta = g.Id and RTRIM(rr.Valor) = CASE a.Opcion WHEN 'Vacío' THEN '' WHEN 'No Vacío' THEN RTRIM(rr.Valor) ELSE RTRIM(a.Opcion) END --Traer respuestas vacias y no vacias (tipos de pregunta diferentes a unico)
	INNER JOIN dbo.Usuario usu (NOLOCK) ON usu.Id = rr.IdUsuario
	INNER JOIN PlanesMejoramiento.PlanActivacionFecha i (NOLOCK) ON i.IdPlanMejoramiento = d.IdPlanMejoramiento
	LEFT OUTER JOIN PlanesMejoramiento.AvancesPlan j (NOLOCK) ON j.IdRecomendacion = a.IdRecomendacion AND j.IdUsuario = usu.Id
	LEFT OUTER JOIN PlanesMejoramiento.Avance o (NOLOCK) ON o.IdAvance = j.IdAvance and o.Activo = 1
	LEFT OUTER JOIN PlanesMejoramiento.AccionesPlan n (NOLOCK) ON n.IdRecomendacion = a.IdRecomendacion AND n.IdUsuario = usu.Id
	LEFT OUTER JOIN PlanesMejoramiento.DiligenciamientoPlan p (NOLOCK) ON p.IdRecomendacion = a.IdRecomendacion AND p.IdUsuario = usu.Id
	--WHERE d.IdPlanMejoramiento = 28
	--AND c.IdSeccionPlanMejoramiento = 16	
	WHERE d.IdPlanMejoramiento = @IdPlanMejoramiento
	AND c.IdSeccionPlanMejoramiento = @IdSeccionPlan
	AND usu.Id = @IdUsuario
	ORDER BY a.IdEtapa ASC
	
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ValidarPermisoGuardadoPlan]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ValidarPermisoGuardadoPlan] AS'

GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-10-27																			 
-- Descripcion: Retorna el resultado (BIT) de la validacion del usuario permitido para contestar
--				el plan de mejoramiento indicado en el parametro
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ValidarPermisoGuardadoPlan]
(
	@idUsuario INT
	,@idPlan INT
)

AS

BEGIN

SET NOCOUNT ON;

	DECLARE @fecha DATETIME
	DECLARE @valido BIT

	SET @fecha = GETDATE()

	SET @valido = 0

	---Verificamos si el Plan aún está habilitado para contestar
	SELECT 
		@valido = 1 
	FROM 
		PlanesMejoramiento.PlanActivacionFecha 
	WHERE 
		IdPlanMejoramiento = @idPlan
		AND 
			[FechaInicio] <= @fecha 
		AND 
			[FechaFin] >= @fecha

	--Si no está habilitado verificamos las Extensiones de tiempo del Usuario
	IF @valido = 0
	BEGIN

	SELECT 
		@valido = 1 
	FROM 
		[dbo].[PermisoUsuarioEncuesta] 
	WHERE 
		IdUsuario = @idUsuario 
		AND 
			IdEncuesta = @idPlan 
		AND
			FechaFin >= @fecha
		AND
			IdTipoExtension = 2

	END


	SELECT 
		@valido AS UsuarioHabilitado

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerTotalesParaEnviar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerTotalesParaEnviar] AS'

GO

ALTER PROC [PlanesMejoramiento].[C_ObtenerTotalesParaEnviar] --7, 'alcaldia_la_cumbre_valle_del_cauca'
  (
	@IdPlan INT,
	@IdUsuario INT
  )
  
  as

  begin
  
  declare @totConfig int
  declare @totMostr int
  
  declare @totDiligenc int
  declare @totMostrD int
	
  
  --recomendaciones mostradas
  select @totMostr = SUM(A.num)
  FROM (
  select COUNT(*) as num
  from [PlanesMejoramiento].[ObjetivoEspecifico] c (NOLOCK)
  inner join [PlanesMejoramiento].SeccionPlanMejoramiento d (NOLOCK) on d.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
  inner join [PlanesMejoramiento].[Recomendacion] a (NOLOCK) on a.IdObjetivoEspecifico = c.IdObjetivoEspecifico
  inner join dbo.Respuesta b ON b.IdPregunta = a.IdPregunta and RTRIM(b.Valor) = CASE a.Opcion WHEN 'Vacío' THEN '' WHEN 'No Vacío' THEN RTRIM(b.Valor) ELSE RTRIM(a.Opcion) END --Traer respuestas vacias y no vacias (tipos de pregunta diferentes a unico)
  where 
  b.IdUsuario = @IdUsuario
  and d.IdPlanMejoramiento = @IdPlan
  group by a.IdPregunta
  ) AS A
  
  
 -- --recomendaciones configuradas
  select @totConfig = COUNT(num)
  FROM (
  select DISTINCT(a.IdPregunta) as num
  from [PlanesMejoramiento].[ObjetivoEspecifico] c (NOLOCK)
  inner join [PlanesMejoramiento].SeccionPlanMejoramiento d (NOLOCK) on d.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
  inner join [PlanesMejoramiento].[Recomendacion] a (NOLOCK) on a.IdObjetivoEspecifico = c.IdObjetivoEspecifico
  where 
  d.IdPlanMejoramiento = @IdPlan
    group by a.IdPregunta
    ) AS A
    
    set @totMostrD = @totMostr
    
    SELECT 
	@totDiligenc = COUNT(*)
	from PlanesMejoramiento.ObjetivoEspecifico a
	inner join [PlanesMejoramiento].SeccionPlanMejoramiento e (NOLOCK) on e.IdSeccionPlanMejoramiento = a.IdSeccionPlanMejoramiento
	inner join PlanesMejoramiento.Recomendacion b (NOLOCK) on b.IdObjetivoEspecifico = a.IdObjetivoEspecifico
	inner join dbo.Respuesta rr (NOLOCK) on rr.IdPregunta = b.IdPregunta and rr.IdUsuario = @IdUsuario and RTRIM(rr.Valor) = CASE b.Opcion WHEN 'Vacío' THEN '' WHEN 'No Vacío' THEN RTRIM(rr.Valor) ELSE RTRIM(b.Opcion) END --Traer respuestas vacias y no vacias (tipos de pregunta diferentes a unico)
	--inner join dbo.Respuesta rr (NOLOCK) on rr.Valor = b.Opcion and rr.Usuario = @usuario and rr.IdPregunta = b.IdPregunta
	inner join [PlanesMejoramiento].AccionesPlan c (NOLOCK) on c.IdRecomendacion = b.IdRecomendacion 
	where 
		e.IdPlanMejoramiento = @IdPlan
		and c.IdUsuario = @IdUsuario
		and ((c.Accion <> '' and LEN(c.Accion) > 0) AND (c.Responsable <> '' and LEN(c.Responsable) > 0))
		
    
  select ISNULL(@totConfig,0) as [TotalConfigurados], ISNULL(@totDiligenc,0) as [TotalMostrados], ISNULL(@totMostrD, 0) as [Total_a_Diligenciar], ISNULL(@totDiligenc, 0) as [TotalDiligenciado]
  
  end

  GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionPorcentajeCumplimientoPlan]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionPorcentajeCumplimientoPlan] AS'

GO

ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionPorcentajeCumplimientoPlan] --6,'alcaldia_piendamo_cauca'
(
	@IdPlanMejoramiento INT,
	@IdUsuario INT
)
AS
BEGIN

declare @porcObjGral float
declare @porcObjEsp float
declare @idObjEsp int
declare @idRecom int
declare @totalPorc float
declare @totalgral float
declare @cantCumplidos int
declare @cantTotal int
declare @cantObjGral int

select 
@porcObjGral = (100.0/COUNT(a.IdSeccionPlanMejoramiento)),
@cantObjGral = COUNT(a.IdSeccionPlanMejoramiento)
from PlanesMejoramiento.SeccionPlanMejoramiento a
where a.IdPlanMejoramiento = @IdPlanMejoramiento


select @cantTotal = COUNT(c.IDRecomendacion)
from PlanesMejoramiento.SeccionPlanMejoramiento a
inner join PlanesMejoramiento.ObjetivoEspecifico b on b.IdSeccionPlanMejoramiento = a.IdSeccionPlanMejoramiento
inner join PlanesMejoramiento.Recomendacion c on c.IdObjetivoEspecifico = b.IdObjetivoEspecifico
where a.IdPlanMejoramiento = @IdPlanMejoramiento


select @totalPorc = SUM(b.PorcentajeObjetivo)
from PlanesMejoramiento.SeccionPlanMejoramiento a
inner join PlanesMejoramiento.ObjetivoEspecifico b on b.IdSeccionPlanMejoramiento = a.IdSeccionPlanMejoramiento
where a.IdPlanMejoramiento = @IdPlanMejoramiento


select 
@cantCumplidos = COUNT(c.IDRecomendacion)
from PlanesMejoramiento.SeccionPlanMejoramiento a
inner join PlanesMejoramiento.ObjetivoEspecifico b on b.IdSeccionPlanMejoramiento = a.IdSeccionPlanMejoramiento
inner join PlanesMejoramiento.Recomendacion c on c.IdObjetivoEspecifico = b.IdObjetivoEspecifico
where a.IdPlanMejoramiento = @IdPlanMejoramiento
and exists (select 1 from PlanesMejoramiento.AccionesPlan d where d.IdRecomendacion = c.IdRecomendacion and d.IdUsuario = @IdUsuario)


select 
@totalgral = SUM([dbo].[GetTotalPorcentajeSeccion](b.IdSeccionPlanMejoramiento, @IdUsuario)) / COUNT(*)
from
PlanesMejoramiento.PlanMejoramiento a
inner join PlanesMejoramiento.SeccionPlanMejoramiento b on b.IdPlanMejoramiento = a.IdPlanMejoramiento
where a.IdPlanMejoramiento = @IdPlanMejoramiento

select @porcObjGral as PorcObjGral, @totalPorc as TotalPorc, @cantTotal as CantTotalObjEsp, 
		@cantCumplidos as CantTotalObjEspCump, ISNULL(ROUND(@totalgral, 1),0) as TotalGral

END


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerFinalizacionPlan]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerFinalizacionPlan] AS'

GO

ALTER PROC [PlanesMejoramiento].[C_ObtenerFinalizacionPlan] --7, 374
(
	@IdPlan INT
	,@IdUsuario INT
)

AS

BEGIN

	SELECT TOP 1
		[IdFinalizacion]
		,[IdPlan]
		,[FechaFinalizacion]
		,[RutaArchivo]
		,[IdUsuario]
	FROM 
		[PlanesMejoramiento].[FinalizacionPlan]
	WHERE
		IdPlan = @IdPlan
		AND
		IdUsuario = @IdUsuario
	ORDER BY
		IdFinalizacion DESC

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerDatosPlanMejoramiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerDatosPlanMejoramiento] AS'

GO

ALTER PROC [PlanesMejoramiento].[C_ObtenerDatosPlanMejoramiento]
(
	@IdPlan INT
)

AS

BEGIN

	SELECT
		A.IdPlanMejoramiento 
		,A.Nombre
		,C.Id AS IdEncuesta
		,C.Titulo AS NombreEncuesta
	FROM
		[PlanesMejoramiento].[PlanMejoramiento] A
		INNER JOIN 
			[PlanesMejoramiento].[PlanMejoramientoEncuesta] B ON B.IdPlanMejoriamiento = A.IdPlanMejoramiento
		INNER JOIN 
			[dbo].[Encuesta] C ON C.Id = B.IdEncuesta
	WHERE
		A.IdPlanMejoramiento = @IdPlan

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerIdPlanByEncuestaID]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerIdPlanByEncuestaID] AS'

GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23																			 
-- Descripcion: Consulta el Id del plan de mejoramiento asociado a un Id de Encuesta dado como parámetro
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerIdPlanByEncuestaID] --39
(
	@IdEncuesta INT
)
AS
BEGIN

	SELECT TOP 1 ISNULL(MAX(ISNULL(A.IdPlanMejoramiento, 0)),0) as PlanID
	FROM PlanesMejoramiento.PlanMejoramiento A 
	LEFT OUTER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta B ON B.IdPlanMejoriamiento = A.IdPlanMejoramiento
	WHERE B.IdEncuesta = @IdEncuesta
	
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[c_ValidarRespuestasPreguntasObligatorias]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[c_ValidarRespuestasPreguntasObligatorias] AS'

GO

ALTER PROC [PlanesMejoramiento].[c_ValidarRespuestasPreguntasObligatorias]
(
	@IdEncuesta INT
	,@IdUsuario INT
)

AS

BEGIN

declare @preguntasObligatorias table
(
	IdPreguntaOb INT
	,TextoPregunta VARCHAR(1000)
)

declare @respuestasObligatorias table
(
	IdPreguntaOb INT
)


insert into @preguntasObligatorias
select
a.id
,[dbo].[ObtenerTextoPreguntaClean](a.Texto)
from dbo.Pregunta a
inner join dbo.Seccion b on b.Id = a.IdSeccion
inner join dbo.Encuesta c on c.Id = b.IdEncuesta
where c.Id = @IdEncuesta
and a.EsObligatoria = 1


insert into @respuestasObligatorias
select
d.IdPregunta
from dbo.Pregunta a
inner join dbo.Seccion b on b.Id = a.IdSeccion
inner join dbo.Encuesta c on c.Id = b.IdEncuesta
inner join dbo.Respuesta d on d.IdPregunta = a.id and d.IdUsuario = @IdUsuario 
where c.Id = @IdEncuesta
and a.EsObligatoria = 1


select * from @preguntasObligatorias
where IdPreguntaOb NOT IN(
select IdPreguntaOb from @respuestasObligatorias
)

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerTiposAvance]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerTiposAvance] AS'

GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-10-27																			 
-- Descripcion: Consulta la informacion de los tipos de Avance
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerTiposAvance]

AS
BEGIN

	SELECT 
		[IdAvance]
		,[Avance] + '%' AS [Avance]
	FROM 
		[PlanesMejoramiento].[Avance]
	WHERE
		Activo = 1
	
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerTiposAutoEvaluacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerTiposAutoEvaluacion] AS'

GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-10-27																			 
-- Descripcion: Consulta la informacion de los tipos de Autoevaluacion
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerTiposAutoEvaluacion]

AS
BEGIN

	SELECT 
		[IdAutoevaluacion]
      ,[Autoevaluacion]
	FROM 
		[PlanesMejoramiento].[Autoevaluacion]
	WHERE
		Activo = 1
	
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerRecursosRecomendacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerRecursosRecomendacion] AS'

GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-10-27																			 
-- Descripcion: Consulta la informacion de los Recursos seleccionados en una recomendacion
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerRecursosRecomendacion]
(
	@IdRecomendacion INT
	,@IdUsuario INT
)

AS
BEGIN

	SELECT 
		B.IdRecursoPlan
		,B.IdRecomendacion
		,ISNULL(B.IdTipoRecurso, A.IdTipoRecurso) AS IdTipoRecurso
		,B.IdUsuario
		,B.NombreRecurso
		,REPLACE(B.ValorRecurso, '$ ', '') AS ValorRecurso
		,A.Clase
		,A.NombreTipoRecurso
		,CASE WHEN B.IdRecursoPlan IS NULL THEN 0 ELSE 1 END AS Seleccionado
	FROM 
		[PlanesMejoramiento].[TipoRecurso] A
		LEFT OUTER JOIN
			[PlanesMejoramiento].[RecursosPlan] B ON A.IdTipoRecurso = B.IdTipoRecurso
			AND B.IdRecomendacion = @IdRecomendacion
			AND B.IdUsuario = @IdUsuario
	
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[D_PlanMejoramientoRespuestasDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[D_PlanMejoramientoRespuestasDelete] AS'

GO

/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-09-01																		 
/Descripcion: Elimina las respuestas previas de un usuario en el diligenciamiento del plan de mejoramiento
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[D_PlanMejoramientoRespuestasDelete]
(
	@IdRecomendacion INT
	,@IdUsuario INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [PlanesMejoramiento].[AccionesPlan]
				WHERE IdRecomendacion = @IdRecomendacion AND IdUsuario = @IdUsuario

			DELETE FROM [PlanesMejoramiento].[RecursosPlan]
				WHERE IdRecomendacion = @IdRecomendacion AND IdUsuario = @IdUsuario

			DELETE FROM [PlanesMejoramiento].[AvancesPlan]
				WHERE IdRecomendacion = @IdRecomendacion AND IdUsuario = @IdUsuario

			DELETE FROM [PlanesMejoramiento].[DiligenciamientoPlan]
				WHERE IdRecomendacion = @IdRecomendacion AND IdUsuario = @IdUsuario
		
			SELECT @respuesta = 'Se han eliminado las Respuestas.'
			SELECT @estadoRespuesta = 3
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoAccionesPlanInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoAccionesPlanInsert] AS'

GO

--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-09-01																			  
-- Descripcion: Inserta la información de la accion y responsable por recomendacion y usuario												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoAccionesPlanInsert]
(
	@IdRecomendacion INT
	,@IdUsuario INT
	,@Accion VARCHAR(2000)
	,@Responsable VARCHAR(500)
	,@FechaCumplimiento DATETIME
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[AccionesPlan] ([IdRecomendacion], [Accion], [Responsable], [FechaCumplimiento], [IdUsuario])
			VALUES (@IdRecomendacion, @Accion, @Responsable, @FechaCumplimiento, @IdUsuario)			

			SELECT @respuesta = 'Se ha guardado la Accion.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoAvancesPlanInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoAvancesPlanInsert] AS'

GO

--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-09-01																			  
-- Descripcion: Inserta la información del avance por recomendacion y usuario												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoAvancesPlanInsert]
(
	@IdRecomendacion INT
	,@IdUsuario INT
	,@IdAvance INT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[AvancesPlan] ([IdRecomendacion], [IdAvance], [Observaciones], [FechaAvance], [IdUsuario])
			VALUES (@IdRecomendacion, @IdAvance, '', GETDATE(), @IdUsuario)			

			SELECT @respuesta = 'Se ha guardado el Avance.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoAutoEvaluacionPlanInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoAutoEvaluacionPlanInsert] AS'

GO

--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-09-01																			  
-- Descripcion: Inserta la información de la autoevaluacion por recomendacion y usuario												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoAutoEvaluacionPlanInsert]
(
	@IdRecomendacion INT
	,@IdUsuario INT
	,@IdAutoevaluacion INT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[DiligenciamientoPlan] ([IdRecomendacion], [IdAutoevaluacion], [FechaAutoevaluacion], [RutaArchivoAutoEvaluacion], [IdUsuario])
			VALUES (@IdRecomendacion, @IdAutoevaluacion, GETDATE(), '', @IdUsuario)			

			SELECT @respuesta = 'Se ha guardado la Autoevaluacion.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoRecursoPlanInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoRecursoPlanInsert] AS'

GO

--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-09-01																			  
-- Descripcion: Inserta la información de los recursos seleccionados por recomendacion y usuario												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoRecursoPlanInsert]
(
	@IdRecomendacion INT
	,@IdTipoRecurso INT
	,@ValorRecurso VARCHAR(250)
	,@IdUsuario INT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[RecursosPlan] ([IdRecomendacion], [IdTipoRecurso], [NombreRecurso], [ValorRecurso], [IdUsuario])
			VALUES (@IdRecomendacion, @IdTipoRecurso, '', @ValorRecurso, @IdUsuario)			

			SELECT @respuesta = 'Se ha guardado el Recurso.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoFinalizacionPlanInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoFinalizacionPlanInsert] AS'

GO

--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-09-01																			  
-- Descripcion: Inserta la información de la finalizacion del plan y ruta archivo por usuario												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoFinalizacionPlanInsert]
(
	@IdPlan INT
	,@IdUsuario INT
	,@RutaArchivo VARCHAR(500)
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF (EXISTS(SELECT * 
			FROM [PlanesMejoramiento].[FinalizacionPlan] 
			WHERE [IdPlan]  = @IdPlan AND [IdUsuario] = @IdUsuario))
	BEGIN

		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE
				[PlanesMejoramiento].[FinalizacionPlan]
			SET
				[FechaFinalizacion] = GETDATE()
				,[RutaArchivo] = @RutaArchivo
			WHERE
				[IdPlan]  = @IdPlan
				AND [IdUsuario] = @IdUsuario

			SELECT @respuesta = 'Se ha Actualizado la ruta del archivo.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	END

	ELSE
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[FinalizacionPlan] ([IdPlan], [FechaFinalizacion], [RutaArchivo], [IdUsuario])
			VALUES (@IdPlan, GETDATE(), @RutaArchivo, @IdUsuario)			

			SELECT @respuesta = 'Se ha guardado el Archivo.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[U_PlanMejoramientoFinalizacionUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[U_PlanMejoramientoFinalizacionUpdate] AS'

GO

/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-09-01																		 
/Descripcion: Actualiza los datos de la finalizacion del plan
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[U_PlanMejoramientoFinalizacionUpdate]
(
	@IdPlan INT
	,@IdUsuario INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	--Si no han guardado archivo en el plan insertamos la finalizacion sin archivo
	IF (NOT EXISTS(SELECT * FROM [PlanesMejoramiento].[FinalizacionPlan] WHERE IdPlan  = @IdPlan AND IdUsuario = @IdUsuario))
	BEGIN
		SET @esValido = 0

		INSERT INTO [PlanesMejoramiento].[FinalizacionPlan] ([IdPlan], [FechaFinalizacion], [RutaArchivo], [IdUsuario])
		VALUES (@IdPlan, GETDATE(), '', @IdUsuario)			

		SELECT @respuesta = 'Se ha Finalizado Correctamente el Plan de Mejoramiento.'
		SELECT @estadoRespuesta = 1
	END
	
	--De lo contrario actualizamos el registro que ya existe para evitar duplicidad
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE
				[PlanesMejoramiento].[FinalizacionPlan]
			SET
				[FechaFinalizacion] = GETDATE()
			WHERE
				[IdPlan]  = @IdPlan
				AND [IdUsuario] = @IdUsuario

			SELECT @respuesta = 'Se ha Finalizado Correctamente el Plan de Mejoramiento.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTotalAvanceObjetivo]') AND type in (N'TF', N'FN')) 

	DROP FUNCTION [dbo].[GetTotalAvanceObjetivo]

GO

CREATE FUNCTION [dbo].[GetTotalAvanceObjetivo](@IdObjetivo int) 

RETURNS DECIMAL

AS
BEGIN

   DECLARE @Result DECIMAL
	
	SELECT @Result = SUM(CONVERT(INT, ISNULL(d.Avance, '0'))) --/ COUNT(*)
	from PlanesMejoramiento.ObjetivoEspecifico a (NOLOCK)
	inner join PlanesMejoramiento.Recomendacion b (NOLOCK) on b.IdObjetivoEspecifico = a.IdObjetivoEspecifico
	left outer join PlanesMejoramiento.AvancesPlan c (NOLOCK) on c.IdRecomendacion = b.IdRecomendacion
	left outer join PlanesMejoramiento.Avance d (NOLOCK) on d.IdAvance = c.IdAvance
	where a.IdObjetivoEspecifico = @IdObjetivo

   RETURN @Result
   
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetTotalPorcentajeSeccion]') AND type in (N'TF', N'FN')) 

	DROP FUNCTION [dbo].[GetTotalPorcentajeSeccion]

GO

CREATE FUNCTION [dbo].[GetTotalPorcentajeSeccion](
@IdSeccion int
,@IdUsuario INT
) 

RETURNS INT

AS
BEGIN

	DECLARE @Result INT

	declare @seccion int

	set @seccion = @IdSeccion

	declare @totConfig int
	declare @totMostr int

	declare @porcTotal float
	declare @avanceTotal int
	declare @porcSeccion float


	--recomendaciones mostradas
	  select @totMostr = ISNULL(SUM(A.num),0)
	  FROM (
	  select COUNT(*) as num
	  from [PlanesMejoramiento].[ObjetivoEspecifico] c (NOLOCK)
	  inner join [PlanesMejoramiento].[Recomendacion] a (NOLOCK) on a.IdObjetivoEspecifico = c.IdObjetivoEspecifico
	  inner join dbo.Respuesta b (NOLOCK) on RTRIM(b.Valor) = CASE a.Opcion WHEN 'Vacío' THEN '' WHEN 'No Vacío' THEN RTRIM(b.Valor) ELSE RTRIM(a.Opcion) END and b.IdPregunta = a.IdPregunta
	  where 
	  b.IdUsuario = @IdUsuario
	  and c.IdSeccionPlanMejoramiento = @seccion
	  group by a.IdPregunta
	  ) AS A

	--recomendaciones configuradas
  select @totConfig = ISNULL(COUNT(num),0)
  FROM (
  select DISTINCT(a.IdPregunta) as num
  from [PlanesMejoramiento].[ObjetivoEspecifico] c (NOLOCK)
  inner join [PlanesMejoramiento].[Recomendacion] a (NOLOCK) on a.IdObjetivoEspecifico = c.IdObjetivoEspecifico
  where 
  c.IdSeccionPlanMejoramiento = @seccion
    group by a.IdPregunta
    ) AS A

	if @totConfig <> @totMostr
	begin
	
	set @porcTotal = 100.00
	
	SELECT 
		@avanceTotal = ISNULL(SUM(CONVERT(INT, ISNULL(d.Avance, '0'))),0) --/ COUNT(*)
	from PlanesMejoramiento.ObjetivoEspecifico a (NOLOCK)
	inner join PlanesMejoramiento.Recomendacion b (NOLOCK) on b.IdObjetivoEspecifico = a.IdObjetivoEspecifico
	inner join dbo.Respuesta rr (NOLOCK) on RTRIM(rr.Valor) = CASE b.Opcion WHEN 'Vacío' THEN '' WHEN 'No Vacío' THEN RTRIM(rr.Valor) ELSE RTRIM(b.Opcion) END and rr.IdUsuario = @IdUsuario and rr.IdPregunta = b.IdPregunta
	left outer join PlanesMejoramiento.AvancesPlan c (NOLOCK) on c.IdRecomendacion = b.IdRecomendacion
	left outer join PlanesMejoramiento.Avance d (NOLOCK) on d.IdAvance = c.IdAvance
	where 
		a.IdSeccionPlanMejoramiento = @seccion
		and c.IdUsuario = @IdUsuario
	
	if @totMostr = 0
	begin
		select @porcSeccion = 100
	end
	else
	begin
		select @porcSeccion = ((@porcTotal * @avanceTotal) / 100.00) / @totMostr
	end
	
	SET @Result = ROUND(@porcSeccion, 0, 1)

	end
	else
	begin
	
	set @porcTotal = 100.00

	SELECT @avanceTotal = ISNULL(SUM(CONVERT(INT, ISNULL(d.Avance, '0'))),0) --/ COUNT(*)
	from PlanesMejoramiento.ObjetivoEspecifico a (NOLOCK)
	inner join PlanesMejoramiento.Recomendacion b (NOLOCK) on b.IdObjetivoEspecifico = a.IdObjetivoEspecifico
	inner join dbo.Respuesta rr (NOLOCK) on RTRIM(rr.Valor) = CASE b.Opcion WHEN 'Vacío' THEN '' WHEN 'No Vacío' THEN RTRIM(rr.Valor) ELSE RTRIM(b.Opcion) END and rr.IdUsuario = @IdUsuario and rr.IdPregunta = b.IdPregunta
	left outer join PlanesMejoramiento.AvancesPlan c (NOLOCK) on c.IdRecomendacion = b.IdRecomendacion
	left outer join PlanesMejoramiento.Avance d (NOLOCK) on d.IdAvance = c.IdAvance
	where a.IdSeccionPlanMejoramiento = @seccion
	and c.IdUsuario = @IdUsuario
	
	if @totMostr = 0
	begin
		select @porcSeccion = 100
	end
	else
	begin
		SELECT @porcSeccion = SUM((CONVERT(INT, ISNULL(d.Avance, '0')) * a.PorcentajeObjetivo) / 100.00) --/ COUNT(*)
		--SELECT CONVERT(INT, ISNULL(d.Avance, '0')), a.PorcentajeObjetivo, CONVERT(INT, ISNULL(d.Avance, '0')) * a.PorcentajeObjetivo, (CONVERT(INT, ISNULL(d.Avance, '0')) * a.PorcentajeObjetivo) / 100.00
		from PlanesMejoramiento.ObjetivoEspecifico a (NOLOCK)
		inner join PlanesMejoramiento.Recomendacion b (NOLOCK) on b.IdObjetivoEspecifico = a.IdObjetivoEspecifico
		inner join dbo.Respuesta rr (NOLOCK) on RTRIM(rr.Valor) = CASE b.Opcion WHEN 'Vacío' THEN '' WHEN 'No Vacío' THEN RTRIM(rr.Valor) ELSE RTRIM(b.Opcion) END  and rr.IdUsuario = @IdUsuario and rr.IdPregunta = b.IdPregunta
		left outer join PlanesMejoramiento.AvancesPlan c (NOLOCK) on c.IdRecomendacion = b.IdRecomendacion
		left outer join PlanesMejoramiento.Avance d (NOLOCK) on d.IdAvance = c.IdAvance
		where a.IdSeccionPlanMejoramiento = @seccion
		and c.IdUsuario = @IdUsuario
	end	
	
	SET @Result = ROUND(@porcSeccion, 0, 1)
	
	end

	RETURN @Result
   
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetColorFromPorc]') AND type in (N'TF', N'FN')) 

	DROP FUNCTION [dbo].[GetColorFromPorc]

GO

CREATE FUNCTION [dbo].[GetColorFromPorc](@Porcentaje int) 

RETURNS VARCHAR(50)

AS
BEGIN

   DECLARE @ColorResultado VARCHAR(50) 
	
	SELECT @ColorResultado = Color
	FROM PlanesMejoramiento.Semaforo
	WHERE RangoInicial <= @Porcentaje AND RangoFinal >= @Porcentaje
	
	SET @ColorResultado = ISNULL(@ColorResultado, '#FFFFFF')

   RETURN @ColorResultado
   
END

GO

--Delete old Procs

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[GuardarEnvio]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[GuardarEnvio]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ListadoUsuariosActivosPlanActivar]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ListadoUsuariosActivosPlanActivar]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerColorSemaforo]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerColorSemaforo]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerEncuestasPlanString]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerEncuestasPlanString]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerEtapasEncuestasPlanMejoramiento]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerEtapasEncuestasPlanMejoramiento]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerIdEncuestaByTitulo]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerIdEncuestaByTitulo]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerIdPadrePregunta]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerIdPadrePregunta]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerIdPlanByEncuestaID]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerIdPlanByEncuestaID]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerInformacionAccionesPlan]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerInformacionAccionesPlan]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerInformacionAvancesPlan]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerInformacionAvancesPlan]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerInformacionObjetivosPlanes]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerInformacionObjetivosPlanes]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerInformacionPlanMejoramiento]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerInformacionPlanMejoramiento]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerInformacionPlanMejoramientoNew]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerInformacionPlanMejoramientoNew]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerInformacionPlanMejoramientoNewTEST]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerInformacionPlanMejoramientoNewTEST]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerInformacionPlanMejoramientoReport]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerInformacionPlanMejoramientoReport]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerInformacionPorcentajeCumplimientoPlan]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerInformacionPorcentajeCumplimientoPlan]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerInformacionRecomendaciones]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerInformacionRecomendaciones]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerInformacionRecomendacionesPlan]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerInformacionRecomendacionesPlan]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerInformacionRecursosPlan]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerInformacionRecursosPlan]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerInformacionSeccionesPlanMejoramiento]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerInformacionSeccionesPlanMejoramiento]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerListadoEncuestasSinResponder]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerListadoEncuestasSinResponder]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerListadoEtapasPlanMejoramiento]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerListadoEtapasPlanMejoramiento]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerListadoPlanes]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerListadoPlanes]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerListadoPlanesActivos]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerListadoPlanesActivos]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerPorcentajeTotalObjetivosPM]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerPorcentajeTotalObjetivosPM]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerPreguntasPlanMejoramiento]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerPreguntasPlanMejoramiento]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerSeccionesEncuestasPlanMejoramiento]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerSeccionesEncuestasPlanMejoramiento]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObtenerTotalesParaEnviar]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ObtenerTotalesParaEnviar]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ValidarActivarPlanMejoramiento]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ValidarActivarPlanMejoramiento]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ValidarRespuestasPreguntasObligatorias]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ValidarRespuestasPreguntasObligatorias]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ValidarRolEncuestaPlan]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ValidarRolEncuestaPlan]
GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ValidarUsuarioRolEncuestaPlan]') AND type in (N'P', N'PC')) 
DROP PROC [PlanesMejoramiento].[ValidarUsuarioRolEncuestaPlan]

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_Derechos]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_Derechos] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	28/10/2017
-- Description:		Obtiene los derechos que tienen preguntas activas asociadas
-- =============================================
ALTER PROC [PAT].[C_Derechos] ( @idTablero tinyint)

AS

BEGIN

	SELECT 
		D.ID, D.DESCRIPCION
	FROM 
		[PAT].[Derecho] D
	WHERE
		D.ID 
			IN
			(
				SELECT DISTINCT PP.IDDERECHO
				FROM [PAT].[PreguntaPAT] pp
				WHERE PP.IDTABLERO = @idTablero	 and pp.Activo = 1			
			)
	ORDER BY D.Descripcion

END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ConsolidadosMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ConsolidadosMunicipio] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	25/10/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados por municipios de la pregunta indicada
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_ConsolidadosMunicipio]   ( @IdUsuario INT, @idPregunta INT, @idTablero tinyint)--1513,7,1
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE  @IDENTIDAD INT, @NOMBREMUNICIPIO VARCHAR(100), @IdDepartamento int
	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
	SELECT @NOMBREMUNICIPIO = Nombre FROM Municipio WHERE Id = 	@IDENTIDAD	
	select @IdDepartamento = IdDepartamento from Municipio where Id =@IDENTIDAD 			
	print @IdDepartamento

	select distinct D.Descripcion AS DERECHO, 	
	C.Descripcion AS COMPONENTE,
	M.Descripcion AS MEDIDA,
	P.Id AS ID_PREGUNTA,
	P.PreguntaIndicativa,
	Mun.Id as ID_MUNICIPIO_RESPUESTA,
	Mun.Nombre as ENTIDAD,
	R.RespuestaIndicativa AS INDICATIVA_MUNICIPIO,
	R.RespuestaCompromiso AS COMPROMISO_MUNICIPIO,
	R.Presupuesto AS PRESUPUESTO_MUNICIPIO,
	P.IdTablero AS ID_TABLERO,
	RD.Id,
	RD.RespuestaCompromiso, 
	RD.Presupuesto,
	RD.ObservacionCompromiso 
	FROM  [PAT].[PreguntaPAT] AS P 
	JOIN [PAT].[RespuestaPAT] R ON R.IdPreguntaPAT = P.Id AND P.Nivel = 3
	--LEFT OUTER JOIN (
	--	select U.IdDepartamento, RD.IdPreguntaPAT, MAX(RD.Id) as IdRespuesta
	--	from [PAT].[RespuestaPATDepartamento]  as RD
	--	join  [PAT].[PreguntaPAT] AS P on RD.IdPreguntaPAT = P.Id 
	--	join Usuario as U on RD.IdUsuario = U.Id
	--	where P.Id = @idPregunta and RD.IdMunicipioRespuesta = -- U.IdDepartamento = @IdDepartamento
	--	group by U.IdDepartamento,RD.IdPreguntaPAT
	--) AS RESPUESTA on P.Id = RESPUESTA.IdPreguntaPAT -- on  RD.Id = RESPUESTA.IdRespuesta,--  R.IdMunicipio = RESPUESTA.IdMunicipioRespuesta,
	--left outer join [PAT].[RespuestaPATDepartamento] as RD on RESPUESTA.IdRespuesta = RD.Id --P.Id = RD.IdPreguntaPAT
	left outer join [PAT].[RespuestaPATDepartamento] as RD on P.Id = RD.IdPreguntaPAT and R.IdMunicipio = RD.IdMunicipioRespuesta
	JOIN Municipio as Mun on R.IdMunicipio = Mun.Id,
		
	[PAT].[Derecho] D,
	[PAT].[Componente] C,
	[PAT].[Medida] M,
	[PAT].[Tablero] T
	WHERE P.IDDERECHO = D.ID 
	AND P.IDCOMPONENTE = C.ID 
	AND P.IDMEDIDA = M.ID 
	AND P.IDTABLERO = T.ID
	AND T.ID = @idTablero 
	AND P.ACTIVO = 1 
	AND P.Id = @idPregunta
	and Mun.IdDepartamento = @IdDepartamento	
	order by Mun.Nombre

END

GO

IF NOT EXISTS (SELECT * FROM [ParametrizacionSistema].[ParametrosSistema] WHERE IdGrupo = 9 and NombreParametro='PlantillaFinalizacionPlan')
begin
insert into [ParametrizacionSistema].[ParametrosSistema]
select 9, 'PlantillaFinalizacionPlan', '<p style="margin: 20px 0 0 0">Reciba un cordial saludo por parte del Ministerio de Interior y la Unidad Administrativa para la Atención y Reparación Integral a las Víctimas.</p>     <p>Mediante el presente correo, nos permitimos confirmarle que el Usuario <b>{0}</b> ha finalizado el diligenciamiento y envío del reporte RUSICST junto con el Plan de Mejoramiento correspondiente a la encuesta <b>{1}.</b>          <br />               </p>           <p>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera.</p>      <p>Agradecemos su atención,</p>      <p><b>Grupo de Articulación Interna para la<br />Política de Víctimas del Conflicto Armado</b></p>'
end

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerListadoEncuestasSinResponder]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerListadoEncuestasSinResponder] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23																			 
-- Descripcion: Consulta la informacion de las Encuestas que aún no tienen respuesta alguna
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerListadoEncuestasSinResponder]-- 15
(
	@IdPlan INT = NULL
)
AS

BEGIN

	SELECT DISTINCT A.* 
	FROM dbo.Encuesta A 
	INNER JOIN dbo.Seccion B ON B.IdEncuesta = A.Id
	INNER JOIN dbo.Pregunta C ON C.IdSeccion = B.Id
	WHERE A.Id NOT IN (

		SELECT DISTINCT a.IdEncuesta
		FROM [dbo].[Autoevaluacion2] a
	)
	AND A.Id NOT IN
	(
		SELECT DISTINCT XX.IdEncuesta
		FROM [PlanesMejoramiento].[PlanMejoramientoEncuesta] XX
		WHERE @IdPlan IS NULL OR XX.IdPlanMejoriamiento <> @IdPlan
	)

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ExtensionesTiempo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ExtensionesTiempo] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-08	
-- Fecha Modificacion: 2017-10-26
-- Modifica: Andrés Bonilla																		 
-- Descripcion: Consulta la informacion de la rejilla de Extensiones de tiempo concedidas												
-- Descripcion Modificacion: Se agrega la Columna de Tipo de Extension
-- ***************************************************************************************************
ALTER PROC [dbo].[C_ExtensionesTiempo]

AS

	SELECT 
		 [PUE].[FechaFin] AS Fecha
		,[U].[UserName] AS Usuario
		,CASE PUE.[IdTipoExtension]
			WHEN 1
				THEN
					(Select top 1 xx.Titulo FROM dbo.Encuesta xx WHERE xx.Id = PUE.IdEncuesta)
			WHEN 2
				THEN 
					(Select top 1 xx.Nombre FROM [PlanesMejoramiento].[PlanMejoramiento] xx WHERE xx.IdPlanMejoramiento = PUE.IdEncuesta)
			WHEN 3
				THEN 
					(Select top 1 CONVERT(VARCHAR, DATEPART(YEAR, xx.[VigenciaInicio])) + (CASE U.IdTipoUsuario WHEN 2 THEN ' - Municipios' WHEN 7 THEN ' - Departamentos' ELSE '' END)  FROM [PAT].[Tablero] xx WHERE xx.Id = PUE.IdEncuesta)
			WHEN 4
				THEN 
					(Select top 1 CONVERT(VARCHAR, DATEPART(YEAR, xx.[VigenciaInicio])) + (CASE U.IdTipoUsuario WHEN 2 THEN ' - Municipios' WHEN 7 THEN ' - Departamentos' ELSE '' END)  FROM [PAT].[Tablero] xx WHERE xx.Id = PUE.IdEncuesta)
		END AS Reporte
		,[UTramite].[UserName] AS Autoriza
		,[PUE].[FechaTramite]
		,CASE PUE.[IdTipoExtension] WHEN 1 THEN 'Encuesta' WHEN 2 THEN 'Plan de Mejoramiento' WHEN 3 THEN 'Tablero PAT - Diligenciamiento' WHEN 4 THEN 'Tablero PAT - Seguimiento' END AS TipoExtension
	FROM 
		[dbo].[PermisoUsuarioEncuesta] AS PUE
		INNER JOIN [dbo].[Usuario] U ON [PUE].[IdUsuario] = [U].[Id]
		INNER JOIN [dbo].[Usuario] UTramite ON [PUE].[IdUsuarioTramite] = [UTramite].[Id]
		--INNER JOIN [dbo].[Encuesta] AS E ON [PUE].IdEncuesta= [E].Id
	ORDER BY  
		PUE.[IdTipoExtension], [PUE].[FechaFin] DESC

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ValidarActivarPlanMejoramiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ValidarActivarPlanMejoramiento] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-10-27																			 
-- Descripcion: Verifica que un plan de mejoramiento cumpla con las condiciones para ser activado
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ValidarActivarPlanMejoramiento]
(
	@IdPlanMejoramiento INT
)
AS
BEGIN

	DECLARE @CantidadSecciones INT
	DECLARE @CantidadSeccionesRecomendacion INT
	DECLARE @Validacion BIT 

	SELECT @CantidadSecciones = COUNT(b.IdSeccionPlanMejoramiento)
	FROM PlanesMejoramiento.PlanMejoramiento a
	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento b ON a.IdPlanMejoramiento = b.IdPlanMejoramiento
	WHERE a.IdPlanMejoramiento = @IdPlanMejoramiento
	
	SELECT @CantidadSeccionesRecomendacion = COUNT(1)
	FROM (	
			SELECT DISTINCT b.IdSeccionPlanMejoramiento
			FROM PlanesMejoramiento.PlanMejoramiento a
			INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento b ON a.IdPlanMejoramiento = b.IdPlanMejoramiento
			INNER JOIN PlanesMejoramiento.ObjetivoEspecifico c ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
			INNER JOIN PlanesMejoramiento.Recomendacion d ON c.IdObjetivoEspecifico = d.IdObjetivoEspecifico
			WHERE a.IdPlanMejoramiento = @IdPlanMejoramiento
		) Secciones
	
	IF (@CantidadSecciones != 0 AND @CantidadSecciones = @CantidadSeccionesRecomendacion)
		BEGIN
			SET @Validacion = 1
		END
	ELSE
		BEGIN
			SET @Validacion = 0
		END
	
	SELECT @Validacion as Validacion

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_RespuestaXIdPreguntaUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_RespuestaXIdPreguntaUsuario] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author: Equipo de desarrollo OIM - Rafael Alba
-- Create date: 25/07/2017
-- Description: Selecciona la respuesta por IdPregunta y Usuario de encuesta
-- ============================================================
ALTER PROCEDURE [dbo].[C_RespuestaXIdPreguntaUsuario] 

@IdPregunta
Int, 
@IdUsuario Int

AS
BEGIN
SET NOCOUNT ON;


DECLARE @TipoPregunta VARCHAR(20)

SELECT @TipoPregunta = TP.Nombre
FROM 
[dbo].[Pregunta] p
INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
WHERE p.Id = @IdPregunta


SELECT [Id]
,[Fecha]
,CASE WHEN @TipoPregunta = 'FECHA' THEN dbo.[ParseDateRespuesta](replace(LEFT(Valor, 10), '/', '-')) ELSE Valor END  as Valor
FROM [dbo].[Respuesta]
WHERE [IdPregunta] = @IdPregunta
AND [IdUsuario] = @IdUsuario 
END


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosSeccionDescarga]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosSeccionDescarga] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Andrés Bonilla
-- Fecha creacion: 2017-10-30
-- Descripcion: Trae los datos de la encuesta a descargar
--=====================================================================================================
ALTER PROC [dbo].[C_DatosSeccionDescarga]
(
	@IdSeccion INT
)

AS

BEGIN

SELECT [Id]
      ,[IdEncuesta]
      ,[Titulo]
      ,[Ayuda]
      ,[SuperSeccion]
      ,[Eliminado]
      ,[OcultaTitulo]
      ,[Estilos]
	  ,[Archivo]
  FROM [dbo].[Seccion]
  where Id = @IdSeccion

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DibujarPreguntasSeccionExcel]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarPreguntasSeccionExcel] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Andrés Bonilla																	 
-- Fecha creacion: 2017-10-30																			 
-- Descripcion: Trae las preguntas y respuestas a dibujar por idseccion e idusuario para descargar excel
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DibujarPreguntasSeccionExcel] --3846, 331

	 @IdSeccion	INT
	 ,@IdUsuario INT

AS
BEGIN

	SELECT 
		P.[Id]	
		,[IdSeccion]
		,P.[Nombre]
		,[RowIndex]
		,[ColumnIndex]
		,TP.[Nombre] AS TipoPregunta
		,p.[Ayuda]
		,[EsObligatoria]
		,[EsMultiple]
		,[SoloSi]
		,[Texto]
		,CASE WHEN TP.[Nombre] = 'FECHA' THEN dbo.[ParseDateRespuesta](replace(LEFT(r.Valor, 10), '/', '-')) ELSE r.Valor END  as Respuesta
		,S.IdEncuesta
		,[dbo].[ObtenerTextoPreguntaClean]([Texto]) AS TextoClean
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
	LEFT OUTER JOIN [dbo].Respuesta r ON r.IdPregunta = p.Id and r.IdUsuario = @IdUsuario
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoEncuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoEncuestaInsert] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-08-23																			  
-- Descripcion: Inserta la información de una Encuesta asociada a un Plan de Mejoramiento												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoEncuestaInsert]
(
	@IdPlan INT
	,@IdEncuesta INT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF (NOT EXISTS(SELECT * FROM [PlanesMejoramiento].[PlanMejoramiento] WHERE IdPlanMejoramiento  = @IdPlan))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Plan de Mejoramiento no existe en el Sistema.'
	END

	IF (EXISTS(SELECT * FROM [PlanesMejoramiento].[PlanMejoramientoEncuesta] WHERE [IdPlanMejoriamiento]  = @IdPlan and [IdEncuesta]= @IdEncuesta))
	BEGIN
		SET @esValido = 0
		
		SELECT @respuesta = 'Se ha asociado la Encuesta al Plan de Mejoramiento.'
		SELECT @estadoRespuesta = 1
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			
			DELETE FROM [PlanesMejoramiento].[PlanMejoramientoEncuesta]
			WHERE IdPlanMejoriamiento = @IdPlan

			INSERT INTO [PlanesMejoramiento].[PlanMejoramientoEncuesta] ([IdPlanMejoriamiento], [IdEncuesta])		
			VALUES (@IdPlan, @IdEncuesta)

			SELECT @respuesta = 'Se ha asociado la Encuesta al Plan de Mejoramiento.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroEncuestaNivel]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroEncuestaNivel] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 15/08/2017
-- Description:	obtiene la informacion Retroalimentacion de la grafica Nivel x encuesta
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroEncuestaNivel] 

	@IdRetroAdmin 				INT,
	@IdUser						VARCHAR(50)


AS

Declare 
@IdEncuesta int,
@idDepartamento int,
@idMunicipo int,
@TotalPreguntas int,
@idUsuarioXMunicipoDep	int,
@TotalRespuestasXMunicipio int,
@TotalRespuestasXDepartamento int,
@NumUsuarioXDep int,
@PromedioDepartamental int,
@TotalRespuestasNacional int,
@NumUsuariosXAlcal int,
@PromedioNacional int,
@IdTipoUsuario int

SELECT @IdEncuesta = IdEncuesta from RetroAdmin where Id = @IdRetroAdmin
SELECT @idMunicipo = IdMunicipio from Usuario where UserName = @IdUser
SELECT @idDepartamento = IdDepartamento from Usuario where UserName = @IdUser
select @IdTipoUsuario = id from TipoUsuario where Tipo = 'ALCALDIA'

--Esta encuesta tiene @TotalPreguntas WHERE
select @TotalPreguntas = count(1) FROM Pregunta WHERE IdSeccion in( select id FROM Seccion where IdEncuesta = @IdEncuesta )

select @idUsuarioXMunicipoDep = id FROM Usuario WHERE UserName = @IdUser

--Este municipio responido a @TotalRespuestasXMunicipio preguntas de las TotalPreguntas
select @TotalRespuestasXMunicipio = count(1) FROM Respuesta WHERE IdPregunta in (
		select id FROM Pregunta WHERE IdSeccion in(select id FROM Seccion WHERE IdEncuesta = @IdEncuesta)) 
	AND IdUsuario = @idUsuarioXMunicipoDep AND (DATALENGTH(Valor) > 0) --Buscar usuario en base a municipio y gobernacion

--Este departamento responido a @TotalRespuestasXDepartamento preguntas de las TotalPreguntas
select @TotalRespuestasXDepartamento = count(1) FROM 
(select IdUsuario FROM Respuesta WHERE IdPregunta in ( select id from Pregunta WHERE IdSeccion in(
								select id from Seccion WHERE IdEncuesta = @IdEncuesta)) AND (DATALENGTH(Valor) > 0)) res
inner join Usuario U on res.IdUsuario = U.id
where IdDepartamento = @idDepartamento and IdTipoUsuario = @IdTipoUsuario

--Obtengo Numero de Usuarios x Departamento
select @NumUsuarioXDep = count(1) from Usuario
where IdDepartamento = @idDepartamento and IdTipoUsuario = @IdTipoUsuario

--select @TotalPreguntas
--select @TotalRespuestasXMunicipio
--select @TotalRespuestasXDepartamento

select @PromedioDepartamental = (@TotalRespuestasXDepartamento/@NumUsuarioXDep)
--select @PromedioDepartamental

--Promedio nacional 
select @TotalRespuestasNacional = count(1) from (select IdUsuario from Respuesta where IdPregunta in (
							select id from Pregunta where IdSeccion in(
								select id from Seccion where IdEncuesta = @IdEncuesta)) AND (DATALENGTH(Valor) > 0)) res
						inner join Usuario U on res.IdUsuario = U.id
						where IdTipoUsuario = @IdTipoUsuario

--total usuario alcaldias
select @NumUsuariosXAlcal = count(1) from Usuario where IdTipoUsuario = @IdTipoUsuario


SELECT @PromedioNacional = (@TotalRespuestasNacional/ @NumUsuariosXAlcal) -- PROMEDIO NACIONAL

IF (@TotalPreguntas != 0)
BEGIN
	Select	
		(@TotalRespuestasXMunicipio * 100)/ @TotalPreguntas as Municipio, 
		(@PromedioDepartamental * 100)/ @TotalPreguntas as PromedioDep, 
		(@PromedioNacional * 100)/ @TotalPreguntas as PromedioNac,
		@TotalPreguntas as TotalPreguntas,
		@TotalRespuestasXMunicipio as RespuestasMunicipio
END
ELSE
BEGIN
	Select	
		0 as Municipio, 
		0 as PromedioDep, 
		0 as PromedioNac,
		@TotalPreguntas as TotalPreguntas,
		@TotalRespuestasXMunicipio as RespuestasMunicipio
END

GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosPregunta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosPregunta] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Vilma Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-14																			 
-- Descripcion: Consulta la informacion de modificar pregunta
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--*****************************************************************************************************
ALTER PROC [dbo].[C_DatosPregunta]

	@Id INT 

AS

	SELECT 
		 a.[Id]
		,a.[Nombre]
		,b.[Nombre] TipoPregunta
		,b.[Id] IdTipoPregunta
		,a.[Ayuda]
		,a.[EsObligatoria]
		,a.[SoloSi]
		,a.[Texto]	
		,a.IdSeccion
	FROM 
		Pregunta a
		INNER JOIN TipoPregunta b ON a.IdTipoPregunta = b.Id
	WHERE 
		a.[Id]= @Id

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_GuardarEnvioPlanMejoramientoEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_GuardarEnvioPlanMejoramientoEncuesta] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [PlanesMejoramiento].[I_GuardarEnvioPlanMejoramientoEncuesta]
  (
    @IdPlan INT,
	@IdUsuario INT
  )
  
  AS
  
  BEGIN
	
	DECLARE @IdEncuesta INT

	SELECT 
		@IdEncuesta = IdEncuesta
	FROM 
		[PlanesMejoramiento].[PlanMejoramientoEncuesta]
	WHERE 
		IdPlanMejoriamiento = @IdPlan



	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [dbo].[Envio] ([IdEncuesta], [IdUsuario], [Fecha])
			VALUES (@IdEncuesta, @IdUsuario, GETDATE())			

			SELECT @respuesta = 'Se ha guardado el Envío de la Encuesta.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

  END

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerIdPlanEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerIdPlanEncuesta] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [PlanesMejoramiento].[C_ObtenerIdPlanEncuesta]
(
	@IdEncuesta INT
)

AS

BEGIN

SELECT
A.*
FROM [PlanesMejoramiento].[PlanMejoramiento] A
INNER JOIN [PlanesMejoramiento].[PlanMejoramientoEncuesta] B ON B.IdPlanMejoriamiento = A.IdPlanMejoramiento
WHERE
B.IdEncuesta = @IdEncuesta

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroDesPreguntasXIdRetro]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroDesPreguntasXIdRetro] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 15/08/2017
-- Description:	obtiene la informacion Retroalimentacion de la grafica Nivel x encuesta
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroDesPreguntasXIdRetro] 

	@IdRetroAdmin 				INT

AS

SELECT 
	  RDP.Id Id
      ,[IdRetroAdmin] Palabra
      ,[IdsEncuestas] IdEncuesta
      ,RDP.[CodigoPregunta]
	  ,[NombrePregunta]
	  ,TP.Nombre
      ,[ValorCalculo] Valor
  FROM [dbo].[RetroDesPreguntasXEncuestas] RDP
  INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = P.CodigoPregunta
  INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
  WHERE [IdRetroAdmin] = @IdRetroAdmin


--C_ConsultaRetroDesPreguntasXIdRetro 2


