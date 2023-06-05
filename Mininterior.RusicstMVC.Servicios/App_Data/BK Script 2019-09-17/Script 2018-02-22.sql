/****SPS WEBSERVICES PAT****/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosMunicipalesDiligenciadosWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosMunicipalesDiligenciadosWebService] AS'
go

-- =============================================
-- Author:			Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Andrés Bonilla
-- Create date:		10/11/2017
-- Modify Date:		22/02/2018
-- Description:		Retorna las preguntas CON respuestas del tablero indicado, para el derecho y municipio especifico
-- Modificacion:	Se modifica para hacer opcional el parámetro IdDerecho
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosMunicipalesDiligenciadosWebService] --1, 1, 11001
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaMunicipio int
)
AS
BEGIN
	SET NOCOUNT ON;	

	IF @IdDerecho IS NULL OR @IdDerecho = 0 OR @IdDerecho = -1
	BEGIN

	SELECT DISTINCT 
				P.Id AS IdPregunta, 
				P.IdTablero AS IdTablero,					
				R.Id as IdRespuesta,
				M.Divipola as DivipolaMunicipio, 
				R.RespuestaIndicativa as RespuestaIndicativa, 
				R.RespuestaCompromiso as RespuestaCompromiso, 
				R.Presupuesto as Presupuesto,
				R.ObservacionNecesidad as ObservacionNecesidad,
				R.AccionCompromiso as AccionCompromiso,
				STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].RespuestaPATAccion AS ACCION
				WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Acciones,	
				STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].RespuestaPATPrograma AS PROGRAMA
				WHERE R.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Programas	
			FROM  [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id
			LEFT OUTER JOIN PAT.RespuestaPAT AS R on P.Id = R.IdPreguntaPAT
			LEFT OUTER JOIN dbo.Municipio AS M ON R.IdMunicipio = M.Id
			WHERE	P.Nivel = 3 
			AND M.Divipola = @DivipolaMunicipio		
			AND P.IdTablero	= @IdTablero	
			AND P.Activo = 1
			ORDER BY P.ID	

	END
	ELSE
	BEGIN

	SELECT DISTINCT 
				P.Id AS IdPregunta, 
				P.IdTablero AS IdTablero,					
				R.Id as IdRespuesta,
				M.Divipola as DivipolaMunicipio, 
				R.RespuestaIndicativa as RespuestaIndicativa, 
				R.RespuestaCompromiso as RespuestaCompromiso, 
				R.Presupuesto as Presupuesto,
				R.ObservacionNecesidad as ObservacionNecesidad,
				R.AccionCompromiso as AccionCompromiso,
				STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].RespuestaPATAccion AS ACCION
				WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Acciones,	
				STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].RespuestaPATPrograma AS PROGRAMA
				WHERE R.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Programas	
			FROM  [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id
			LEFT OUTER JOIN PAT.RespuestaPAT AS R on P.Id = R.IdPreguntaPAT
			LEFT OUTER JOIN dbo.Municipio AS M ON R.IdMunicipio = M.Id
			WHERE	P.Nivel = 3 
			AND D.Id = @IdDerecho
			AND M.Divipola = @DivipolaMunicipio		
			AND P.IdTablero	= @IdTablero	
			AND P.Activo = 1
			ORDER BY P.ID	

	END

		
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosMunicipalesDiligenciadosRCWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosMunicipalesDiligenciadosRCWebService] AS'
go

-- =============================================
-- Author:			Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Andrés Bonilla
-- Create date:		10/11/2017
-- Modify Date:		22/02/2018
-- Description:		Retorna las preguntas de Reparacion colectiva y respuestas del tablero indicado, para el derecho y municipio especifico
-- Modificacion:	Se modifica para hacer opcional el parámetro IdDerecho
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosMunicipalesDiligenciadosRCWebService] --1, 6, 11001
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaMunicipio int
) 
AS
BEGIN
	SET NOCOUNT ON;	
	IF @IdDerecho = 6 OR @IdDerecho IS NULL OR @IdDerecho = 0 OR @IdDerecho = -1
		SELECT DISTINCT 
				P.Id AS IdPregunta, 
				P.IdTablero AS IdTablero,				
				MUN.Divipola as DivipolaMunicipio, 				
				P.IdMedida as IdMedida, 
				P.Sujeto as Sujeto, 
				M.Descripcion AS Medida, 
				P.MedidaReparacionColectiva as MedidaReparacionColectiva, 
				R.Id as IdRespuesta,
				R.Accion as Accion, 
				R.Presupuesto as Presupuesto,
				STUFF((SELECT CAST( ACCION.AccionReparacionColectiva  AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].RespuestaPATAccionReparacionColectiva AS ACCION
				WHERE R.Id = ACCION.IdRespuestaPATReparacionColectiva AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Acciones
		FROM    PAT.PreguntaPATReparacionColectiva AS P
		INNER JOIN PAT.Medida M ON P.IdMedida = M.Id
		INNER JOIN PAT.RespuestaPATReparacionColectiva AS R ON R.IdPreguntaPATReparacionColectiva = P.Id
		INNER JOIN dbo.Municipio MUN ON P.IdMunicipio = MUN.Id
		WHERE  
		P.IdTablero = @IdTablero
		AND MUN.Divipola = @DivipolaMunicipio
		ORDER BY P.Id
END



GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosMunicipalesDiligenciadosRRWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosMunicipalesDiligenciadosRRWebService] AS'
go

-- =============================================
-- Author:			Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Andrés Bonilla
-- Create date:		10/11/2017
-- Modify Date:		22/02/2018
-- Description:		Retorna las preguntas de Retornos y reubicaciones y respuestas del tablero indicado, para el derecho y municipio especifico
-- Modificacion:	Se modifica para hacer opcional el parámetro IdDerecho
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosMunicipalesDiligenciadosRRWebService] 
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaMunicipio int
) 
AS
BEGIN
	SET NOCOUNT ON;	
	IF @IdDerecho = 6 OR @IdDerecho IS NULL OR @IdDerecho = 0 OR @IdDerecho = -1
		SELECT DISTINCT 
			P.Id AS IdPregunta
			,P.IdTablero AS IdTablero
			,M.Divipola as DivipolaMunicipio
			,P.[Hogares] as Hogares
			,P.[Personas] as Personas
			,P.[Sector] as Sector
			,P.[Componente] as Componente
			,P.[Comunidad] as Comunidad
			,P.[Ubicacion] as Ubicacion
			,P.[MedidaRetornoReubicacion] as MedidaRetornoReubicacion
			,P.[IndicadorRetornoReubicacion] as Indicador
			,R.Id as IdRespuesta
			,R.Accion as Accion
			,R.Presupuesto as Presupuesto
			,P.EntidadResponsable as EntidadResponsable						
			,STUFF((SELECT CAST( ACCION.AccionRetornoReubicacion AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].RespuestaPATAccionRetornosReubicaciones AS ACCION
			WHERE R.Id = ACCION.IdRespuestaPATRetornoReubicacion AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Acciones
		FROM    PAT.PreguntaPATRetornosReubicaciones AS P
		JOIN PAT.RespuestaPATRetornosReubicaciones AS R ON R.IdPreguntaPATRetornoReubicacion = P.Id 
		INNER JOIN dbo.Municipio AS M ON M.Id = P.IdMunicipio
		WHERE  
		P.IdTablero = @IdTablero
		AND M.Divipola = @DivipolaMunicipio
	end		

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosMunicipalesSeguimientoWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosMunicipalesSeguimientoWebService] AS'
go

-- =============================================
-- Author:			Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Andrés Bonilla
-- Create date:		10/11/2017
-- Modify Date:		22/02/2018
-- Description:		Retorna los datos del seguimiento del tablero PAT Indicado, por derecho y Divipola
-- Modificacion:	Se modifica para hacer opcional el parámetro IdDerecho
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosMunicipalesSeguimientoWebService] --1, NULL, 5172
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaMunicipio int
)
AS
BEGIN
	SET NOCOUNT ON;	

	IF @IdDerecho IS NULL OR @IdDerecho = 0 OR @IdDerecho = -1
	BEGIN

	SELECT DISTINCT 
			P.Id AS IdPregunta, 
			P.IdTablero AS IdTablero,					
			R.Id as IdRespuesta,
			@DivipolaMunicipio as DivipolaMunicipio, 
			R.RespuestaIndicativa as RespuestaIndicativa, 
			R.RespuestaCompromiso as RespuestaCompromiso, 
			R.Presupuesto as Presupuesto,
			R.ObservacionNecesidad as ObservacionNecesidad,
			R.AccionCompromiso as AccionCompromiso,

			STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].RespuestaPATAccion AS ACCION
			WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Acciones,	
				
			STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].RespuestaPATPrograma AS PROGRAMA
			WHERE R.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Programas	

			,SM.IdSeguimiento
			,SM.CantidadPrimer AS CantidadSeguimientoPrimerSemestre
			,SM.CantidadSegundo AS CantidadSeguimientoSegundoSemestre
			,SM.PresupuestoPrimer AS PresupuestoSeguimientoPrimerSemestre
			,SM.PresupuestoSegundo AS PresupuestoSeguimientoSegundoSemestre
			,SM.Observaciones AS ObservacionesSeguimiento
			,SM.FechaSeguimiento

			,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].[SeguimientoProgramas] AS PROGRAMA
			WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento  and NumeroSeguimiento =1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSeguimiento
			
			--adicionales
			,SM.ObservacionesSegundo AS ObservacionesSegundoSeguimiento
			,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].[SeguimientoProgramas] AS PROGRAMA
			WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento  and NumeroSeguimiento =2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimiento
			--,CONVERT(decimal, ISNULL( REPLACE(isnull(SM.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(SM.CantidadSegundo,0), -1, 0),0)) as CantidadTotalSeguimiento
			--,CONVERT(decimal,  ISNULL( REPLACE(isnull(SM.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(SM.PresupuestoSegundo,0), -1, 0),0)) as PresupuestoTotalSeguimiento
			,SM.CantidadPrimer +  SM.CantidadSegundo as CantidadTotalSeguimiento
			,SM.PresupuestoPrimer + SM.PresupuestoSegundo as PresupuestoTotalSeguimiento
			FROM  [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id
			LEFT OUTER JOIN PAT.RespuestaPAT AS R on P.Id = R.IdPreguntaPAT AND R.IdMunicipio = [PAT].[fn_GetIdMunicipio](@DivipolaMunicipio)
			LEFT OUTER JOIN 
			(
				SELECT DISTINCT
				   [IdSeguimiento]
				  ,[IdTablero]
				  ,[IdPregunta]
				  ,[IdUsuario]
				  ,[FechaSeguimiento]
				  ,[CantidadPrimer]
				  ,[PresupuestoPrimer]
				  ,[CantidadSegundo]
				  ,[PresupuestoSegundo]
				  ,[Observaciones]
				  ,USU.IdDepartamento
				  ,USU.IdMunicipio
				  ,SEG.ObservacionesSegundo
			  FROM [PAT].[Seguimiento] SEG
			  INNER JOIN dbo.Usuario USU ON SEG.IdUsuario = USU.Id
			  WHERE USU.IdMunicipio = [PAT].[fn_GetIdMunicipio](@DivipolaMunicipio)
			) AS SM ON SM.IdTablero = P.IdTablero AND SM.IdPregunta = P.Id
			WHERE	P.Nivel = 3 
			AND P.IdTablero	= @IdTablero	
			AND P.Activo = 1
			ORDER BY P.ID

	END
	ELSE
	BEGIN

	SELECT DISTINCT 
			P.Id AS IdPregunta, 
			P.IdTablero AS IdTablero,					
			R.Id as IdRespuesta,
			@DivipolaMunicipio as DivipolaMunicipio, 
			R.RespuestaIndicativa as RespuestaIndicativa, 
			R.RespuestaCompromiso as RespuestaCompromiso, 
			R.Presupuesto as Presupuesto,
			R.ObservacionNecesidad as ObservacionNecesidad,
			R.AccionCompromiso as AccionCompromiso,

			STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].RespuestaPATAccion AS ACCION
			WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Acciones,	
				
			STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].RespuestaPATPrograma AS PROGRAMA
			WHERE R.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Programas	

			,SM.IdSeguimiento
			,SM.CantidadPrimer AS CantidadSeguimientoPrimerSemestre
			,SM.CantidadSegundo AS CantidadSeguimientoSegundoSemestre
			,SM.PresupuestoPrimer AS PresupuestoSeguimientoPrimerSemestre
			,SM.PresupuestoSegundo AS PresupuestoSeguimientoSegundoSemestre
			,SM.Observaciones AS ObservacionesSeguimiento
			,SM.FechaSeguimiento

			,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].[SeguimientoProgramas] AS PROGRAMA
			WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento  and NumeroSeguimiento =1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSeguimiento
			
			--adicionales
			,SM.ObservacionesSegundo AS ObservacionesSegundoSeguimiento
			,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].[SeguimientoProgramas] AS PROGRAMA
			WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento  and NumeroSeguimiento =2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimiento
			--,CONVERT(decimal, ISNULL( REPLACE(isnull(SM.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(SM.CantidadSegundo,0), -1, 0),0)) as CantidadTotalSeguimiento
			--,CONVERT(decimal,  ISNULL( REPLACE(isnull(SM.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(SM.PresupuestoSegundo,0), -1, 0),0)) as PresupuestoTotalSeguimiento
			,SM.CantidadPrimer +  SM.CantidadSegundo as CantidadTotalSeguimiento
			,SM.PresupuestoPrimer + SM.PresupuestoSegundo as PresupuestoTotalSeguimiento
			FROM  [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id
			LEFT OUTER JOIN PAT.RespuestaPAT AS R on P.Id = R.IdPreguntaPAT AND R.IdMunicipio = [PAT].[fn_GetIdMunicipio](@DivipolaMunicipio)
			LEFT OUTER JOIN 
			(
				SELECT DISTINCT
				   [IdSeguimiento]
				  ,[IdTablero]
				  ,[IdPregunta]
				  ,[IdUsuario]
				  ,[FechaSeguimiento]
				  ,[CantidadPrimer]
				  ,[PresupuestoPrimer]
				  ,[CantidadSegundo]
				  ,[PresupuestoSegundo]
				  ,[Observaciones]
				  ,USU.IdDepartamento
				  ,USU.IdMunicipio
				  ,SEG.ObservacionesSegundo
			  FROM [PAT].[Seguimiento] SEG
			  INNER JOIN dbo.Usuario USU ON SEG.IdUsuario = USU.Id
			  WHERE USU.IdMunicipio = [PAT].[fn_GetIdMunicipio](@DivipolaMunicipio)
			) AS SM ON SM.IdTablero = P.IdTablero AND SM.IdPregunta = P.Id
			WHERE	P.Nivel = 3 
			AND D.Id = @IdDerecho	
			AND P.IdTablero	= @IdTablero	
			AND P.Activo = 1
			ORDER BY P.ID

	END

			
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosMunicipalesSeguimientoODWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosMunicipalesSeguimientoODWebService] AS'
go

-- =============================================
-- Author:			Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Andrés Bonilla
-- Create date:		10/11/2017
-- Modify Date:		22/02/2018
-- Description:		Retorna los datos del seguimiento de otros derechos 
--					del tablero PAT Indicado, por medida y Divipola
-- Modificacion:	Se modifica para hacer opcional el parámetro IdDerecho
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosMunicipalesSeguimientoODWebService] --1, 6, 5172
(
	@IdTablero int, 
	@IdMedida int, 
	@DivipolaMunicipio int
)
AS
BEGIN
	SET NOCOUNT ON;	

	IF @IdMedida IS NULL OR @IdMedida = 0 OR @IdMedida = -1
	BEGIN

		SELECT 
		a.[IdSeguimiento]
		,a.[IdTablero]
		,@DivipolaMunicipio AS DivipolaMunicipio
		,[FechaSeguimiento]
		,[Accion]
		,a.[IdUnidad]
		,f.Descripcion AS UnidadMedida
		,[NumSeguimiento] AS Cantidad
		,[Presupuesto]
		,[Observaciones]
		,[Programa]
		,c.Descripcion AS Medida
		,d.Descripcion AS Componente
		,e.Descripcion AS Derecho
	FROM [PAT].[SeguimientoOtrosDerechos] a
		INNER JOIN [PAT].[SeguimientoOtrosDerechosMedidas] b ON a.IdSeguimiento = b.IdSeguimiento
		INNER JOIN [PAT].[MapaMedidas] c ON b.IdMedida = c.IdMedida
		INNER JOIN [PAT].[MapaComponentes] d ON b.IdComponente = d.IdComponente
		INNER JOIN [PAT].[Derecho] e ON b.IdDerecho = e.Id
		INNER JOIN [PAT].[UnidadMedida] f ON a.IdUnidad = f.Id
		INNER JOIN dbo.Usuario u ON a.IdUsuario = u.Id
	WHERE
		a.IdTablero = @IdTablero
		AND u.IdMunicipio = PAT.fn_GetIdMunicipio(@DivipolaMunicipio)

	END
	ELSE
	BEGIN

	SELECT 
		a.[IdSeguimiento]
		,a.[IdTablero]
		,@DivipolaMunicipio AS DivipolaMunicipio
		,[FechaSeguimiento]
		,[Accion]
		,a.[IdUnidad]
		,f.Descripcion AS UnidadMedida
		,[NumSeguimiento] AS Cantidad
		,[Presupuesto]
		,[Observaciones]
		,[Programa]
		,c.Descripcion AS Medida
		,d.Descripcion AS Componente
		,e.Descripcion AS Derecho
	FROM [PAT].[SeguimientoOtrosDerechos] a
		INNER JOIN [PAT].[SeguimientoOtrosDerechosMedidas] b ON a.IdSeguimiento = b.IdSeguimiento
		INNER JOIN [PAT].[MapaMedidas] c ON b.IdMedida = c.IdMedida
		INNER JOIN [PAT].[MapaComponentes] d ON b.IdComponente = d.IdComponente
		INNER JOIN [PAT].[Derecho] e ON b.IdDerecho = e.Id
		INNER JOIN [PAT].[UnidadMedida] f ON a.IdUnidad = f.Id
		INNER JOIN dbo.Usuario u ON a.IdUsuario = u.Id
	WHERE
		a.IdTablero = @IdTablero
		AND u.IdMunicipio = PAT.fn_GetIdMunicipio(@DivipolaMunicipio)
		AND b.IdMedida = @IdMedida

	END	

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService] AS'
go

-- =============================================
-- Author:			Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Andrés Bonilla
-- Create date:		14/11/2017
-- Modified date:	06/02/2018
-- Modify Date:		22/02/2018
-- Description:		Retorna los datos del consolidado del seguimiento departamental 
--					del tablero PAT Indicado, por derecho y Divipola
-- Modificacion:	Se modifica para hacer opcional el parámetro IdDerecho
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService] --1, null, 5172
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaDepartamento int
)
AS
BEGIN
	SET NOCOUNT ON;	

	IF @IdDerecho IS NULL OR @IdDerecho = 0 OR @IdDerecho = -1
	BEGIN

	SELECT DISTINCT
		a.Id as IdPregunta
		,a.IdDerecho
		,b.Descripcion AS Derecho
		,rm.IdMunicipio AS DivipolaMunicipio
		,rm.IdDepartamento AS DivipolaDepartamento

		,rm.RespuestaIndicativa AS RespuestaIndicativaMunicipio
		,rm.RespuestaCompromiso AS RespuestaCompromisoMunicipio
		,CONVERT(FLOAT, rm.Presupuesto) AS PresupuestoMunicipio
		,rm.ObservacionNecesidad AS ObservacionMunicipio
		,rm.AccionCompromiso AS AccionCompromisoMunicipio

		--,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATAccion AS ACCION
		--WHERE rm.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesMunicipio,	
						
		--STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		--WHERE rm.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasMunicipio	

		,rd.RespuestaCompromiso AS RespuestaCompromisoGobernacion
		,CONVERT(FLOAT, rd.Presupuesto) AS PresupuestoGobernacion
		,rd.ObservacionCompromiso AS ObservacionCompromisoGobernacion

		--,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATAccion AS ACCION
		--WHERE rdd.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesDepartamento,
							
		--STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		--WHERE rdd.ID = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasDepartamento	

		,sm.CantidadPrimer AS SeguimientoPrimerSemestreMunicipio
		,sm.CantidadSegundo AS SeguimientoSegundoSemestreMunicipio
		,CONVERT(FLOAT, sm.PresupuestoPrimer) AS SeguimientoPresupuestoPrimerSemestreMunicipio
		,CONVERT(FLOAT, sm.PresupuestoSegundo) AS SeguimientoPresupuestoSegundoSemestreMunicipio

		,sd.CantidadPrimer AS SeguimientoPrimerSemestreGobernacion
		,sd.CantidadSegundo AS SeguimientoSegundoSemestreGobernacion
		,CONVERT(FLOAT, sd.PresupuestoPrimer) AS SeguimientoPresupuestoPrimerSemestreGobernacion
		,CONVERT(FLOAT, sd.PresupuestoSegundo) AS SeguimientoPresupuestoSegundoSemestreGobernacion

		--adicionales
		,sd.Observaciones AS ObservacionesPrimerSeguimientoGobernacion
		,sd.ObservacionesSegundo AS ObservacionesSegundoSeguimientoGobernacion

		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =sd.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =sd.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			
		--, CONVERT(FLOAT, REPLACE(isnull(sd.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(sd.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimientoGobernacion
		--, CONVERT(FLOAT,  REPLACE(isnull(sd.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(sd.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimientoGobernacion
		--, CONVERT(FLOAT, REPLACE(isnull(sm.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(sm.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimientoMunicipio
		--, CONVERT(FLOAT,  REPLACE(isnull(sm.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(sm.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimientoMunicipio
		,sd.CantidadPrimer +  sd.CantidadSegundo as CantidadTotalSeguimientoGobernacion
		,sd.PresupuestoPrimer + sd.PresupuestoSegundo as PresupuestoTotalSeguimientoGobernacion
		,sm.CantidadPrimer +  sm.CantidadSegundo as CantidadTotalSeguimientoMunicipio
		,sm.PresupuestoPrimer + sm.PresupuestoSegundo as PresupuestoTotalSeguimientoMunicipio

	FROM [PAT].[PreguntaPAT] a
		INNER JOIN [PAT].[Derecho] b ON a.IdDerecho = b.Id
		LEFT OUTER JOIN [PAT].[RespuestaPAT] rm ON a.Id = rm.IdPreguntaPAT AND rm.IdMunicipio IN (select xx.Id FROM dbo.Municipio xx WHERE xx.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento))
		LEFT OUTER JOIN [PAT].[RespuestaPATDepartamento] rd ON a.Id = rd.IdPreguntaPAT AND rd.IdMunicipioRespuesta = rm.IdMunicipio
		--LEFT OUTER JOIN [PAT].[RespuestaPAT] rdd ON a.Id = rd.IdPreguntaPAT AND rdd.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento)
		LEFT OUTER JOIN [PAT].[Seguimiento] sm ON a.Id = sm.IdPregunta AND sm.IdUsuario = [PAT].[fn_GetIdUsuarioMunicipio](rm.IdMunicipio)
		LEFT OUTER JOIN [PAT].[SeguimientoGobernacion] sd ON a.Id = sd.IdPregunta AND sd.IdUsuarioAlcaldia = [PAT].[fn_GetIdUsuarioMunicipio](rm.IdMunicipio) AND sd.IdUsuario = [PAT].[fn_GetIdUsuarioDepartamento](rm.IdDepartamento)
	WHERE 
		a.IdTablero = @IdTablero
		AND a.Nivel = 3
		AND a.Activo = 1
	ORDER BY 
		a.Id ASC, rm.IdMunicipio ASC

	END
	ELSE
	BEGIN

	SELECT DISTINCT
		a.Id as IdPregunta
		,a.IdDerecho
		,b.Descripcion AS Derecho
		,rm.IdMunicipio AS DivipolaMunicipio
		,rm.IdDepartamento AS DivipolaDepartamento

		,rm.RespuestaIndicativa AS RespuestaIndicativaMunicipio
		,rm.RespuestaCompromiso AS RespuestaCompromisoMunicipio
		,CONVERT(FLOAT, rm.Presupuesto) AS PresupuestoMunicipio
		,rm.ObservacionNecesidad AS ObservacionMunicipio
		,rm.AccionCompromiso AS AccionCompromisoMunicipio

		--,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATAccion AS ACCION
		--WHERE rm.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesMunicipio,	
						
		--STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		--WHERE rm.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasMunicipio	

		,rd.RespuestaCompromiso AS RespuestaCompromisoGobernacion
		,CONVERT(FLOAT, rd.Presupuesto) AS PresupuestoGobernacion
		,rd.ObservacionCompromiso AS ObservacionCompromisoGobernacion

		--,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATAccion AS ACCION
		--WHERE rdd.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesDepartamento,
							
		--STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		--WHERE rdd.ID = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasDepartamento	

		,sm.CantidadPrimer AS SeguimientoPrimerSemestreMunicipio
		,sm.CantidadSegundo AS SeguimientoSegundoSemestreMunicipio
		,CONVERT(FLOAT, sm.PresupuestoPrimer) AS SeguimientoPresupuestoPrimerSemestreMunicipio
		,CONVERT(FLOAT, sm.PresupuestoSegundo) AS SeguimientoPresupuestoSegundoSemestreMunicipio

		,sd.CantidadPrimer AS SeguimientoPrimerSemestreGobernacion
		,sd.CantidadSegundo AS SeguimientoSegundoSemestreGobernacion
		,CONVERT(FLOAT, sd.PresupuestoPrimer) AS SeguimientoPresupuestoPrimerSemestreGobernacion
		,CONVERT(FLOAT, sd.PresupuestoSegundo) AS SeguimientoPresupuestoSegundoSemestreGobernacion

		--adicionales
		,sd.Observaciones AS ObservacionesPrimerSeguimientoGobernacion
		,sd.ObservacionesSegundo AS ObservacionesSegundoSeguimientoGobernacion

		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =sd.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =sd.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			
		--, CONVERT(FLOAT, REPLACE(isnull(sd.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(sd.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimientoGobernacion
		--, CONVERT(FLOAT,  REPLACE(isnull(sd.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(sd.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimientoGobernacion
		--, CONVERT(FLOAT, REPLACE(isnull(sm.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(sm.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimientoMunicipio
		--, CONVERT(FLOAT,  REPLACE(isnull(sm.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(sm.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimientoMunicipio
		,sd.CantidadPrimer +  sd.CantidadSegundo as CantidadTotalSeguimientoGobernacion
		,sd.PresupuestoPrimer + sd.PresupuestoSegundo as PresupuestoTotalSeguimientoGobernacion
		,sm.CantidadPrimer +  sm.CantidadSegundo as CantidadTotalSeguimientoMunicipio
		,sm.PresupuestoPrimer + sm.PresupuestoSegundo as PresupuestoTotalSeguimientoMunicipio

	FROM [PAT].[PreguntaPAT] a
		INNER JOIN [PAT].[Derecho] b ON a.IdDerecho = b.Id
		LEFT OUTER JOIN [PAT].[RespuestaPAT] rm ON a.Id = rm.IdPreguntaPAT AND rm.IdMunicipio IN (select xx.Id FROM dbo.Municipio xx WHERE xx.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento))
		LEFT OUTER JOIN [PAT].[RespuestaPATDepartamento] rd ON a.Id = rd.IdPreguntaPAT AND rd.IdMunicipioRespuesta = rm.IdMunicipio
		--LEFT OUTER JOIN [PAT].[RespuestaPAT] rdd ON a.Id = rd.IdPreguntaPAT AND rdd.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento)
		LEFT OUTER JOIN [PAT].[Seguimiento] sm ON a.Id = sm.IdPregunta AND sm.IdUsuario = [PAT].[fn_GetIdUsuarioMunicipio](rm.IdMunicipio)
		LEFT OUTER JOIN [PAT].[SeguimientoGobernacion] sd ON a.Id = sd.IdPregunta AND sd.IdUsuarioAlcaldia = [PAT].[fn_GetIdUsuarioMunicipio](rm.IdMunicipio) AND sd.IdUsuario = [PAT].[fn_GetIdUsuarioDepartamento](rm.IdDepartamento)
	WHERE 
		a.IdTablero = @IdTablero
		AND b.Id = @IdDerecho
		AND a.Nivel = 3
		AND a.Activo = 1
	ORDER BY 
		a.Id ASC, rm.IdMunicipio ASC

	END

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosDepartamentalesSeguimientoODWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosDepartamentalesSeguimientoODWebService] AS'
go

-- =============================================
-- Author:			Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Andrés Bonilla
-- Create date:		14/11/2017
-- Modify Date:		22/02/2018
-- Description:		Retorna los datos del seguimiento de otros derechos 
--					del tablero PAT Indicado, por medida y Divipola
-- Modificacion:	Se modifica para hacer opcional el parámetro IdDerecho
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosDepartamentalesSeguimientoODWebService] --1, 6, 5172
(
	@IdTablero int, 
	@IdMedida int, 
	@DivipolaDepartamento int
)
AS
BEGIN
	SET NOCOUNT ON;	
	
	IF @IdMedida IS NULL OR @IdMedida = 0 OR @IdMedida = -1
	BEGIN

	SELECT 
		a.[IdSeguimiento]
		,a.[IdTablero]
		,@DivipolaDepartamento AS DivipolaDepartamento
		,um.IdMunicipio AS DivipolaMunicipio
		,[FechaSeguimiento]
		,[Accion]
		,a.[IdUnidad]
		,f.Descripcion AS UnidadMedida
		,[Cantidad]	
		,[Presupuesto]
		,[Observaciones]
		,[Programa]
		,c.Descripcion AS Medida
		,d.Descripcion AS Componente
		,e.Descripcion AS Derecho
	FROM [PAT].[SeguimientoGobernacionOtrosDerechos] a
		INNER JOIN [PAT].[SeguimientoGobernacionOtrosDerechosMedidas] b ON a.IdSeguimiento = b.IdSeguimiento
		INNER JOIN [PAT].[MapaMedidas] c ON b.IdMedida = c.IdMedida
		INNER JOIN [PAT].[MapaComponentes] d ON b.IdComponente = d.IdComponente
		INNER JOIN [PAT].[Derecho] e ON b.IdDerecho = e.Id
		INNER JOIN [PAT].[UnidadMedida] f ON a.IdUnidad = f.Id
		INNER JOIN dbo.Usuario u ON a.IdUsuario = u.Id
		INNER JOIN dbo.Usuario um ON a.IdUsuarioAlcaldia = um.Id
	WHERE
		a.IdTablero = @IdTablero
		AND u.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento)

	END
	ELSE
	BEGIN

	SELECT 
		a.[IdSeguimiento]
		,a.[IdTablero]
		,@DivipolaDepartamento AS DivipolaDepartamento
		,um.IdMunicipio AS DivipolaMunicipio
		,[FechaSeguimiento]
		,[Accion]
		,a.[IdUnidad]
		,f.Descripcion AS UnidadMedida
		,[Cantidad]	
		,[Presupuesto]
		,[Observaciones]
		,[Programa]
		,c.Descripcion AS Medida
		,d.Descripcion AS Componente
		,e.Descripcion AS Derecho
	FROM [PAT].[SeguimientoGobernacionOtrosDerechos] a
		INNER JOIN [PAT].[SeguimientoGobernacionOtrosDerechosMedidas] b ON a.IdSeguimiento = b.IdSeguimiento
		INNER JOIN [PAT].[MapaMedidas] c ON b.IdMedida = c.IdMedida
		INNER JOIN [PAT].[MapaComponentes] d ON b.IdComponente = d.IdComponente
		INNER JOIN [PAT].[Derecho] e ON b.IdDerecho = e.Id
		INNER JOIN [PAT].[UnidadMedida] f ON a.IdUnidad = f.Id
		INNER JOIN dbo.Usuario u ON a.IdUsuario = u.Id
		INNER JOIN dbo.Usuario um ON a.IdUsuarioAlcaldia = um.Id
	WHERE
		a.IdTablero = @IdTablero
		AND u.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento)
		AND b.IdMedida = @IdMedida

	END

END


GO

/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez
/Modifica: Equipo OIM	- Andrés Bonilla																	  
/Fecha creacion:     2017-12-11	
/Fecha modificacion :2018-02-14
/Fecha modificacion :2018-02-22
/Descripcion: Inserta los datos de envio de los tres tipos de tablero: Planeacion Municipal "PM", Planeacion Departamental "PD"
/, Primer Seguimiento Municpal "SM1", Segundo Seguimiento Municpal "SM2"						  
/, Primer Seguimiento Departamental "SD1", Segundo Seguimiento Departamental "SD2"	
/Modificacion: Se cambia la validación de envío de SM2					  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_EnvioTableroPat] 
		@IdUsuario int,
		@IdTablero tinyint,
		@TipoEnvio varchar(3)
		AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	

	declare @id int, @IdDepartamento int,@IdMunicipio  int	
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	select @id = r.IdEnvio from [PAT].[EnvioTableroPat] as r
	where  r.IdMunicipio = @IdMunicipio and r.IdDepartamento = @IdDepartamento and TipoEnvio = @TipoEnvio  and r.IdTablero =@IdTablero


	--Usuarios que no diligenciaron planeacion pueden enviar SM1 o SM2 sin problemas
	DECLARE @UsuariosSinPlaneacion TABLE
	(
		IdUsuario INT
	)

	IF @TipoEnvio = 'SM1' OR @TipoEnvio = 'SM2'
	BEGIN

	INSERT INTO @UsuariosSinPlaneacion	
	select 
	distinct a.idusuario
	from pat.RespuestaPAT a
	inner join pat.PreguntaPAT b on a.IdPreguntaPAT = b.Id
	where
	b.IdTablero = 1
	and b.Activo = 1
	and b.Nivel = 3

	END
	
	--if (@id is not null)
	--begin
	--	set @esValido = 0
	--	set @respuesta += 'El tablero ya ha sido enviado con anterioridad.'
	--end
	------------------------------------------------------------------------------
	--validacion de que halla guardado las preguntas del municipio correspondiente	
	------------------------------------------------------------------------------
	declare @guardoPreguntas bit
	set @guardoPreguntas = 0
	if (@TipoEnvio = 'PM')--planeacion municipal
	begin 
		SELECT @guardoPreguntas =CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		FROM (
			SELECT 
			COUNT(P.Id) AS NUM_PREGUNTAS_CONTESTAR, 
			count(R.Id) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
			FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
			join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
			JOIN Municipio AS M ON PM.IdMunicipio = M.Id
			LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >=0 and R.RespuestaIndicativa >=0 and R.NecesidadIdentificada >=0 AND R.Presupuesto >=0
			WHERE	P.NIVEL = 3 --municipios
			AND P.IdTablero = @idTablero
			and P.ACTIVO = 1	
			and M.Id = @IdMunicipio
		) AS T 
	end
	if (@TipoEnvio = 'SM1' )--seguimiento municipal
	begin 
		set @guardoPreguntas = 0
		--SELECT @guardoPreguntas = CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		--FROM (
		--	SELECT 
		--	COUNT(P.Id) AS NUM_PREGUNTAS_CONTESTAR, 
		--	count(SM.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		--	FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
		--	join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
		--	JOIN Municipio AS M ON PM.IdMunicipio = M.Id
		--	LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >=0
		--	LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = P.ID AND SM.IdUsuario = R.IdUsuario and SM.CantidadPrimer >= 0 	
		--	WHERE	P.NIVEL = 3 --municipios
		--	AND P.IdTablero = @idTablero
		--	and P.ACTIVO = 1	
		--	and M.Id = @IdMunicipio
		--) AS T 
	end
	if ( @TipoEnvio= 'SM2')--seguimiento municipal
	begin 
		--SELECT @guardoPreguntas = CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		--FROM (
		--	SELECT 
		--	COUNT(distinct R.Id) AS NUM_PREGUNTAS_CONTESTAR, 
		--	count(distinct SM.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		--	FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
		--	join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
		--	JOIN Municipio AS M ON PM.IdMunicipio = M.Id
		--	JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >=0
		--	LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = P.ID AND SM.IdUsuario = R.IdUsuario and SM.CantidadSegundo >= 0 and SM.PresupuestoSegundo >=0	and SM.ObservacionesSegundo is not null
		--	WHERE	P.NIVEL = 3 --municipios
		--	AND P.IdTablero = @idTablero
		--	and P.ACTIVO = 1	
		--	and M.Id = @IdMunicipio
		--) AS T 

		IF NOT EXISTS (Select 1 from @UsuariosSinPlaneacion WHERE IdUsuario = @IdUsuario)
		BEGIN
			--Usuarios que no diligenciaron planeacion pueden enviar SM1 o SM2 sin problemas
			SET @guardoPreguntas = 1
		END
		ELSE
		BEGIN
			
			declare @cantPreguntas int

			select @cantPreguntas = count(a.Id)
			from pat.PreguntaPAT a
			where a.IdTablero = @IdTablero and a.Activo = 1 and a.Nivel = 3

			IF EXISTS (
			select 1
			from pat.PreguntaPAT b 
			left outer join pat.RespuestaPAT a on a.IdPreguntaPAT = b.Id
			inner join dbo.Usuario u on u.Id = a.IdUsuario
			where
			b.IdTablero = @IdTablero
			and b.Activo = 1 and b.Nivel = 3
			and u.Activo = 1 and u.IdEstado = 5 and u.IdTipoUsuario = 2
			and u.Id = @IdUsuario
			group by a.IdUsuario, u.UserName
			having (@cantPreguntas - SUM(case when a.RespuestaCompromiso is null then 0 when a.RespuestaCompromiso = 0 then 0 else 1 end)) = 100
			)
			BEGIN
				--Usuarios que llenaron todo en 0 pueden enviar SM1 y SM2 sin problema
				SET @guardoPreguntas = 1
			END
			ELSE
			BEGIN
				
				DECLARE @CantPreguntasSeguimiento INT

				--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
				DECLARE @PreguntasPlaneacion TABLE
				(
					IdPreguntaPAT INT				
				)

				INSERT INTO @PreguntasPlaneacion
				SELECT a.IdPreguntaPAT
				FROM PAT.RespuestaPAT a
				INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
				WHERE
				b.IdTablero = @IdTablero
				AND a.IdUsuario = @IdUsuario
				AND b.Activo = 1 and b.Nivel = 3
				AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)


				SELECT @CantPreguntasSeguimiento = COUNT(DISTINCT IdPregunta)
				FROM PAT.Seguimiento
				WHERE IdPregunta IN (
					SELECT IdPreguntaPAT
					FROM @PreguntasPlaneacion
				) 
				AND IdUsuario = @IdUsuario
				AND IdTablero = @IdTablero
				AND (CantidadSegundo >= 0 OR PresupuestoSegundo >= 0)
				AND ObservacionesSegundo IS NOT NULL

				SELECT @guardoPreguntas = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimiento THEN 1 ELSE 0 END
				FROM @PreguntasPlaneacion
			END
		END

	end

	if (@guardoPreguntas = 0)
	begin
		set @esValido = 0
		set @respuesta += 'El Tablero PAT no se puede enviar ya que aún tiene información pendiente por diligenciar.'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
	
		INSERT INTO [PAT].[EnvioTableroPat]
				   ([IdTablero]
				   ,[IdUsuario]
				   ,[IdMunicipio]
				   ,[IdDepartamento]
				   ,[TipoEnvio]
				   ,[FechaEnvio])
			 VALUES
				   (@IdTablero,@IdUsuario,@IdMunicipio,@IdDepartamento,@TipoEnvio, getdate())
	 			
		
			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado


		
go