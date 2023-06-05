
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Funcion que retorna el Id de un Departamento a partir de la Divipola
-- =============================================
CREATE FUNCTION [PAT].[fn_GetIdDepartamento] (
	@Divipola INT
)
RETURNS INT
AS
BEGIN	
	DECLARE @RETURN  INT 

	SELECT @RETURN =  U.[Id]
	FROM [dbo].[Departamento] (NOLOCK) U
	WHERE U.Divipola = @Divipola
	RETURN @RETURN
END


GO
/****** Object:  UserDefinedFunction [PAT].[fn_GetIdMunicipio]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Funcion que retorna el Id de un Municipio a partir de la Divipola
-- =============================================
CREATE FUNCTION [PAT].[fn_GetIdMunicipio] (
	@Divipola INT
)
RETURNS INT
AS
BEGIN	
	DECLARE @RETURN  INT 

	SELECT @RETURN =  U.[Id]
	FROM [dbo].[Municipio] (NOLOCK) U
	WHERE U.Divipola = @Divipola
	RETURN @RETURN
END


GO
/****** Object:  UserDefinedFunction [PAT].[fn_GetIdUsuarioDepartamento]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Funcion que retorna el Id de un Usuario Departamental a partir de la Divipola
-- =============================================
CREATE FUNCTION [PAT].[fn_GetIdUsuarioDepartamento] (
	@Divipola INT
)
RETURNS INT
AS
BEGIN	
	DECLARE @RETURN  INT 

	SELECT @RETURN =  U.[Id]
	FROM [dbo].Usuario (NOLOCK) U
	WHERE U.IdDepartamento = @Divipola
	AND U.UserName like '%gobernacion%'
	RETURN @RETURN
END


GO
/****** Object:  UserDefinedFunction [PAT].[fn_GetIdUsuarioMunicipio]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Funcion que retorna el Id de un Usuario Municipal a partir de la Divipola
-- =============================================
CREATE FUNCTION [PAT].[fn_GetIdUsuarioMunicipio] (
	@Divipola INT
)
RETURNS INT
AS
BEGIN	
	DECLARE @RETURN  INT 

	SELECT @RETURN =  U.[Id]
	FROM [dbo].Usuario (NOLOCK) U
	WHERE U.IdMunicipio = @Divipola
	AND U.UserName like '%alcaldia%'
	RETURN @RETURN
END


GO
/****** Object:  StoredProcedure [PAT].[C_AvanceMunicipioWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Obtiene los porcentajes de avance de la gestión del tablero PAT por municipio
-- =============================================
CREATE PROCEDURE [PAT].[C_AvanceMunicipioWebService]  --1, 11001
(
	@IdTablero int, 
	@DivipolaMunicipio int
) 
AS
BEGIN
	SET NOCOUNT ON;	
	
		SELECT	D.Descripcion AS DERECHO, 
		SUM(case when R.RespuestaIndicativa IS NULL or R.RespuestaIndicativa=0 then 0 else 1 end)*100/count(*) PINDICATIVA,
		SUM(case when R.RespuestaCompromiso IS NULL or R.RespuestaCompromiso=0 then 0 else 1 end)*100/count(*) PCOMPROMISO
		FROM    PAT.PreguntaPAT AS P
		INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id
		LEFT OUTER JOIN (SELECT	RESPUESTA.IdPreguntaPAT, 
			RESPUESTA.RespuestaIndicativa, 
			RESPUESTA.RespuestaCompromiso
			FROM    PAT.RespuestaPAT AS RESPUESTA 
			INNER JOIN dbo.Municipio M ON RESPUESTA.IdMunicipio = M.Id
			WHERE M.Divipola = @DivipolaMunicipio
			) AS R ON P.Id = R.IdPreguntaPAT
		WHERE	P.NIVEL = 3 AND P.IdTablero = @IdTablero AND P.Activo = 1
		--AND 1=pat.fn_ValidarPreguntaRyR(P.ID_MEDIDA,pat.fn_GetIdEntidad(@USUARIO))
		group by D.Descripcion 
END


GO
/****** Object:  StoredProcedure [PAT].[C_AvanceTableroSeguimientoMunicipioWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Andrés Bonilla
-- Create date:		14/11/2017
-- Description:		Obtiene los porcentajes de avance del seguimiento de la gestión del tablero PAT por municipio 
-- =============================================
CREATE PROC  [PAT].[C_AvanceTableroSeguimientoMunicipioWebService]
( @DivipolaMunicipio INT ,@IdTablero INT )
AS
BEGIN
	declare @IdMunicipio int
	declare @IdUsuario int

	select @IdUsuario = PAT.fn_GetIdUsuarioMunicipio(@DivipolaMunicipio)
	select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

	SELECT 	A.Derecho
	,ISNULL(CONVERT(INT, CASE WHEN ROUND(CASE A.rc WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.rc)) * 100) END, 0) > 100 THEN 100 ELSE ROUND(CASE A.rc WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.rc)) * 100) END, 0) END),0) AS AvanceCompromiso
	,ISNULL(CONVERT(INT, CASE WHEN ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0) > 100 THEN 100 ELSE ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0) END),0) AS AvancePresupuesto
	FROM
	(
		SELECT	D.Descripcion AS Derecho
		,SUM(C.PresupuestoPrimer) as p1
		,SUM(C.PresupuestoSegundo) as p2
		,SUM(case when R.RespuestaIndicativa is null then 0 else r.RespuestaIndicativa end) as ri
		,SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end) as rc
		,SUM(case when R.Presupuesto is null then 0 else r.Presupuesto end) as pres
		,(SUM(case when C.CantidadPrimer is null or C.CantidadPrimer = -1 then 0 else C.CantidadPrimer end) + SUM(case when C.CantidadSegundo is null or C.CantidadSegundo = -1 then 0 else C.CantidadSegundo end)) as sumc1c2
		,(SUM(case when C.PresupuestoPrimer is null or C.PresupuestoPrimer = -1 then 0 else C.PresupuestoPrimer end) + SUM(case when C.PresupuestoSegundo is null or C.PresupuestoSegundo = -1 then 0 else C.PresupuestoSegundo end)) as sump1p2
		FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
		join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		INNER JOIN [PAT].[Derecho] (NOLOCK) D ON P.IDDERECHO = D.ID 
		INNER JOIN PAT.Tablero (NOLOCK) AS T ON P.IDTABLERO = T.ID				
		LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON R.IdMunicipio = @IdMunicipio  and P.ID = R.[IdPreguntaPAT]	
		LEFT OUTER JOIN [PAT].Seguimiento as C ON C.IdPregunta = P.Id and C.IdUsuario = @IdUsuario
		WHERE	P.NIVEL = 3 
		AND T.ID = @idTablero
		and P.ACTIVO = 1		
		group by D.Descripcion
	) AS A
END

GO
/****** Object:  StoredProcedure [PAT].[C_DatosConsolidadoMunicipiosGobernacionesWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna las preguntas de la gestion departamental
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosConsolidadoMunicipiosGobernacionesWebService] 
(
	@IdTablero int, 
	@DivipolaDepartamento int
) 
AS

BEGIN
			SELECT 
			DISTINCT IdPregunta
			,IdRespuesta
			,DivipolaMunicipio
			,RespuestaIndicativa
			,ObservacionNecesidad
			,RespuestaCompromiso
			,AccionCompromiso
			,CONVERT(FLOAT, PRESUPUESTO) AS Presupuesto
			,AccionesMunicipio
			,ProgramasMunicipio
			,RespuestaCompromisoDepartamento 
			,RespuestaObservacionDepartamento 
			,RespuestaPresupuestoDepartamento
			,AccionesDepartamento
			,ProgramasDepartamento
				FROM ( 
				SELECT DISTINCT 	P.ID AS IdPregunta, 
						P.ACTIVO, 
						P.IdTablero,
						MUN.Divipola AS DivipolaMunicipio,
						R.Id as IdRespuesta,
						R.RespuestaIndicativa AS RespuestaIndicativa, 
						R.RespuestaCompromiso AS RespuestaCompromiso, 
						R.Presupuesto,
						R.ObservacionNecesidad AS ObservacionNecesidad,
						R.AccionCompromiso AS AccionCompromiso
						
						,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
						FROM [PAT].RespuestaPATAccion AS ACCION
						WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesMunicipio,	
						
						STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
						FROM [PAT].RespuestaPATPrograma AS PROGRAMA
						WHERE R.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasMunicipio	
						
						,DEP.RespuestaCompromiso AS RespuestaCompromisoDepartamento 
						
						,DEP.ObservacionCompromiso AS RespuestaObservacionDepartamento
						
						,DEP.Presupuesto AS RespuestaPresupuestoDepartamento
						
						,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
						FROM [PAT].RespuestaPATAccion AS ACCION
						WHERE RD.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesDepartamento,
							
						STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
						FROM [PAT].RespuestaPATPrograma AS PROGRAMA
						WHERE RD.ID = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasDepartamento	

				FROM    PAT.PreguntaPAT AS P
				LEFT OUTER JOIN (SELECT	
										RESPUESTA.Id, 
										RESPUESTA.IdMunicipio,										
										RESPUESTA.IdPreguntaPAT,
										RESPUESTA.RespuestaIndicativa, 
										RESPUESTA.RespuestaCompromiso, 
										RESPUESTA.Presupuesto,
										RESPUESTA.ObservacionNecesidad,
										RESPUESTA.AccionCompromiso
								FROM    PAT.RespuestaPAT AS RESPUESTA
								INNER JOIN dbo.Departamento D ON RESPUESTA.IdDepartamento = D.Id
								WHERE D.Divipola = @DivipolaDepartamento
								) AS R ON P.ID = R.IdPreguntaPAT
					LEFT OUTER JOIN dbo.Municipio MUN ON R.IdMunicipio = MUN.Id
					LEFT OUTER JOIN [PAT].RespuestaPATDepartamento DEP ON R.IdPreguntaPAT = DEP.IdPreguntaPAT AND R.IdMunicipio = DEP.IdMunicipioRespuesta --AND DEP.ID_ENTIDAD = PAT.fn_GetIdEntidad(@ID_ENTIDAD)
					LEFT OUTER JOIN PAT.RespuestaPAT RD ON P.ID = RD.IdPreguntaPAT AND RD.IdDepartamento = (Select xx.Id FROM dbo.Departamento xx WHERE xx.Divipola = @DivipolaDepartamento)
				WHERE	P.NIVEL = 3  
				AND R.IdMunicipio IN ( SELECT xx.Id FROM dbo.Municipio xx WHERE xx.IdDepartamento = (Select xx.Id FROM dbo.Departamento xx WHERE xx.Divipola = @DivipolaDepartamento))
			) AS P 
			WHERE P.Activo = 1 AND P.IdTablero = @IdTablero ORDER BY 3,2,1		

END
GO
/****** Object:  StoredProcedure [PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		14/11/2017
-- Description:		Retorna los datos del consolidado del seguimiento departamental 
--					del tablero PAT Indicado, por derecho y Divipola
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService] --1, null, 5172
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaDepartamento int
)
AS
BEGIN
	SET NOCOUNT ON;	

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
GO
/****** Object:  StoredProcedure [PAT].[C_DatosDepartamentalesDiligenciadosRCWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna las preguntas de la gestion departamental RC
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosDepartamentalesDiligenciadosRCWebService] --1, 5
(
	@IdTablero int, 
	@DivipolaDepartamento int
) 
AS
begin 			
	SELECT 
		p.ID as IdPregunta,
		MUN.Divipola as DivipolaMunicipio,
		rcd.Id as IdRespuesta,
		rc.Accion as AccionMunicipio,
		rc.Presupuesto as PresupuestoMunicipio,
		rcd.AccionDepartamento as AccionDepartamento,
		rcd.PresupuestoDepartamento as PresupuestoDepartamento							
	FROM PAT.PreguntaPATReparacionColectiva p
	INNER JOIN dbo.Departamento D on p.IdDepartamento = D.Id
	INNER JOIN dbo.Municipio MUN ON p.IdMunicipio = MUN.Id
	LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc ON p.Id = rc.IdPreguntaPATReparacionColectiva AND p.IdMunicipio = rc.IdMunicipio
	LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON p.Id = rcd.IdPreguntaPATReparacionColectiva AND rc.IdMunicipio = rcd.IdMunicipioRespuesta
	WHERE p.IdTablero = @IdTablero
	AND D.Divipola = @DivipolaDepartamento
	ORDER BY p.Id, p.IdMunicipio
end
GO
/****** Object:  StoredProcedure [PAT].[C_DatosDepartamentalesDiligenciadosRRWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna las respuestas de la gestion departamental RR
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosDepartamentalesDiligenciadosRRWebService] --2, 5
(
	@IdTablero int, 
	@DivipolaDepartamento int
) 
AS

BEGIN
	SELECT DISTINCT  
	IdPregunta,
	DivipolaMunicipio,
	IdRespuesta,
	AccionMunicipio,
	PresupuestoMunicipio,
	AccionDepartamento,
	PresupuestoDepartamento					
	FROM ( 
			SELECT DISTINCT P.ID AS IdPregunta
			,M.Divipola as DivipolaMunicipio
			,R.ID as IdRespuesta,
			R.Accion as AccionMunicipio, 
			R.Presupuesto as PresupuestoMunicipio,
			R.AccionDepartamento as AccionDepartamento,
			R.PresupuestoDepartamento as PresupuestoDepartamento
			FROM    PAT.PreguntaPATRetornosReubicaciones AS P
			INNER JOIN dbo.Departamento  D ON p.IdDepartamento = D.Id
			INNER JOIN dbo.Municipio M ON p.IdMunicipio = M.Id
			LEFT OUTER JOIN (SELECT	
					RESPUESTA.Id, 
					RESPUESTA.IdMunicipio,
					RESPUESTA.IdPreguntaPATRetornoReubicacion,
					RESPUESTA.Accion, 
					RESPUESTA.Presupuesto,
					RRD.AccionDepartamento,
					RRD.PresupuestoDepartamento
					FROM    PAT.RespuestaPATRetornosReubicaciones AS RESPUESTA  
					LEFT OUTER JOIN PAT.RespuestaPATDepartamentoRetornosReubicaciones AS RRD ON RESPUESTA.IdMunicipio = RRD.IdMunicipioRespuesta AND RESPUESTA.IdPreguntaPATRetornoReubicacion = RRD.IdPreguntaPATRetornoReubicacion
					WHERE RESPUESTA.IdMunicipio in (SELECT xx.Id FROM dbo.Municipio xx WHERE xx.IdDepartamento = (SELECT x.Id FROM dbo.Departamento x WHERE x.Divipola = @DivipolaDepartamento) )
			) AS R ON P.Id = R.IdPreguntaPATRetornoReubicacion
			WHERE
			D.Divipola = @DivipolaDepartamento AND P.IdTablero = @IdTablero
	) 
	AS P 
	ORDER BY 1

END

GO
/****** Object:  StoredProcedure [PAT].[C_DatosDepartamentalesSeguimientoODWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		14/11/2017
-- Description:		Retorna los datos del seguimiento de otros derechos 
--					del tablero PAT Indicado, por medida y Divipola
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosDepartamentalesSeguimientoODWebService] --1, 6, 5172
(
	@IdTablero int, 
	@IdMedida int, 
	@DivipolaDepartamento int
)
AS
BEGIN
	SET NOCOUNT ON;	
	
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
		AND (b.IdMedida = @IdMedida OR @IdMedida IS NULL)
END
GO
/****** Object:  StoredProcedure [PAT].[C_DatosDepartamentalesSeguimientoRCWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		14/11/2017
-- Description:		Retorna los datos del seguimiento departamental para preguntas RC
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosDepartamentalesSeguimientoRCWebService] --1, 5
(
	@IdTablero int, 
	@DivipolaDepartamento int
) 
AS
begin 	

		
	SELECT 
		p.ID as IdPregunta,
		MUN.Divipola as DivipolaMunicipio,
		rcd.Id as IdRespuesta,
		rc.Accion as AccionMunicipio,
		rc.Presupuesto as PresupuestoMunicipio,
		rcd.AccionDepartamento as AccionDepartamento,
		rcd.PresupuestoDepartamento as PresupuestoDepartamento

		,src.AvancePrimer AS AvanceSeguimientoPrimerSemestreMunicipio
		,src.AvanceSegundo AS AvanceSeguimientoSegundoSemestreMunicipio
		,src.FechaSeguimiento AS FechaSeguimientoMunicipio

		,srcd.AvancePrimer AS AvanceSeguimientoPrimerSemestreGobernacion							
		,srcd.AvanceSegundo AS AvanceSeguimientoSegundoSemestreGobernacion
		,srcd.FechaSeguimiento AS FechaSeguimientoGobernacion

	FROM PAT.PreguntaPATReparacionColectiva p
	INNER JOIN dbo.Departamento D on p.IdDepartamento = D.Id
	INNER JOIN dbo.Municipio MUN ON p.IdMunicipio = MUN.Id
	LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc ON p.Id = rc.IdPreguntaPATReparacionColectiva AND p.IdMunicipio = rc.IdMunicipio
	LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON p.Id = rcd.IdPreguntaPATReparacionColectiva AND rc.IdMunicipio = rcd.IdMunicipioRespuesta
	LEFT OUTER JOIN [PAT].[SeguimientoReparacionColectiva] src ON p.Id = src.IdPregunta AND rc.IdUsuario = src.IdUsuario
	LEFT OUTER JOIN [PAT].[SeguimientoGobernacionReparacionColectiva] srcd ON p.Id = srcd.IdPregunta AND rcd.IdUsuario = srcd.IdUsuario AND rc.IdUsuario = srcd.IdUsuarioAlcaldia 
	WHERE p.IdTablero = @IdTablero
	AND D.Divipola = @DivipolaDepartamento
	ORDER BY p.Id, p.IdMunicipio
end
GO
/****** Object:  StoredProcedure [PAT].[C_DatosDepartamentalesSeguimientoRRWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		14/11/2017
-- Description:		Retorna las respuestas del seguimiento de la gestion departamental RR
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosDepartamentalesSeguimientoRRWebService] --2, 5
(
	@IdTablero int, 
	@DivipolaDepartamento int
) 
AS

BEGIN
	SELECT DISTINCT  
	IdPregunta,
	DivipolaMunicipio,
	IdRespuesta,
	AccionMunicipio,
	PresupuestoMunicipio,
	AccionDepartamento,
	PresupuestoDepartamento		
	,AvanceSeguimientoPrimerSemestreMunicipio
	,AvanceSeguimientoSegundoSemestreMunicipio
	,FechaSeguimientoMunicipio
	,AvanceSeguimientoPrimerSemestreGobernacion
	,AvanceSeguimientoSegundoSemestreGobernacion
	,FechaSeguimientoGobernacion			
	FROM ( 
			SELECT DISTINCT P.ID AS IdPregunta
			,M.Divipola as DivipolaMunicipio
			,R.ID as IdRespuesta,
			R.Accion as AccionMunicipio, 
			R.Presupuesto as PresupuestoMunicipio,
			R.AccionDepartamento as AccionDepartamento,
			R.PresupuestoDepartamento as PresupuestoDepartamento

			,srr.AvancePrimer AS AvanceSeguimientoPrimerSemestreMunicipio
			,srr.AvanceSegundo AS AvanceSeguimientoSegundoSemestreMunicipio
			,srr.FechaSeguimiento AS FechaSeguimientoMunicipio

			,srrd.AvancePrimer AS AvanceSeguimientoPrimerSemestreGobernacion							
			,srrd.AvanceSegundo AS AvanceSeguimientoSegundoSemestreGobernacion
			,srrd.FechaSeguimiento AS FechaSeguimientoGobernacion

			FROM    PAT.PreguntaPATRetornosReubicaciones AS P
			INNER JOIN dbo.Departamento  D ON p.IdDepartamento = D.Id
			INNER JOIN dbo.Municipio M ON p.IdMunicipio = M.Id
			LEFT OUTER JOIN (SELECT	
					RESPUESTA.Id, 
					RESPUESTA.IdMunicipio,
					RESPUESTA.IdPreguntaPATRetornoReubicacion,
					RESPUESTA.Accion, 
					RESPUESTA.Presupuesto,
					RRD.AccionDepartamento,
					RRD.PresupuestoDepartamento
					,RRD.IdUsuario 
					,RESPUESTA.IdUsuario AS IdUsuarioMunicipio
					FROM    PAT.RespuestaPATRetornosReubicaciones AS RESPUESTA  
					LEFT OUTER JOIN PAT.RespuestaPATDepartamentoRetornosReubicaciones AS RRD ON RESPUESTA.IdMunicipio = RRD.IdMunicipioRespuesta AND RESPUESTA.IdPreguntaPATRetornoReubicacion = RRD.IdPreguntaPATRetornoReubicacion
					WHERE RESPUESTA.IdMunicipio in (SELECT xx.Id FROM dbo.Municipio xx WHERE xx.IdDepartamento = (SELECT x.Id FROM dbo.Departamento x WHERE x.Divipola = @DivipolaDepartamento) )
			) AS R ON P.Id = R.IdPreguntaPATRetornoReubicacion
			LEFT OUTER JOIN [PAT].[SeguimientoRetornosReubicaciones] srr ON P.Id = srr.IdPregunta AND R.IdUsuarioMunicipio = srr.IdUsuario
			LEFT OUTER JOIN [PAT].[SeguimientoGobernacionRetornosReubicaciones] srrd ON P.Id = srrd.IdPregunta AND r.IdUsuario = srrd.IdUsuario AND r.IdUsuarioMunicipio = srrd.IdUsuarioAlcaldia
			WHERE
			D.Divipola = @DivipolaDepartamento AND P.IdTablero = @IdTablero
	) 
	AS P 
	ORDER BY 1

END

GO
/****** Object:  StoredProcedure [PAT].[C_DatosDepartamentalesSeguimientoWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna los datos del seguimiento del tablero PAT Departamental Indicado, por Divipola
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosDepartamentalesSeguimientoWebService] --1, 25
(
	@IdTablero int, 
	@DivipolaDepartamento int
)
AS
BEGIN
	SET NOCOUNT ON;	

		SELECT DISTINCT 
				P.Id AS IdPregunta, 
				P.IdTablero AS IdTablero,					
				R.Id as IdRespuesta,
				@DivipolaDepartamento as DivipolaDepartamento, 
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
				WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSeguimiento

			FROM  [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id
			LEFT OUTER JOIN PAT.RespuestaPAT AS R on P.Id = R.IdPreguntaPAT AND R.IdDepartamento = [PAT].[fn_GetIdDepartamento](@DivipolaDepartamento)
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
			  FROM [PAT].[Seguimiento] SEG
			  INNER JOIN dbo.Usuario USU ON SEG.IdUsuario = USU.Id
			  WHERE USU.IdDepartamento = [PAT].[fn_GetIdDepartamento](@DivipolaDepartamento)
			) AS SM ON SM.IdTablero = P.IdTablero AND SM.IdPregunta = P.Id
			WHERE	P.Nivel = 2 
			AND P.IdTablero	= @IdTablero	
			AND P.Activo = 1
			ORDER BY P.ID	
END
GO
/****** Object:  StoredProcedure [PAT].[C_DatosMunicipalesDiligenciadosRCWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna las preguntas de Reparacion colectiva y respuestas del tablero indicado, para el derecho y municipio especifico
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosMunicipalesDiligenciadosRCWebService] --1, 6, 11001
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaMunicipio int
) 
AS
BEGIN
	SET NOCOUNT ON;	
	IF @IdDerecho = 6
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
/****** Object:  StoredProcedure [PAT].[C_DatosMunicipalesDiligenciadosRRWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna las preguntas de Retornos y reubicaciones y respuestas del tablero indicado, para el derecho y municipio especifico
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosMunicipalesDiligenciadosRRWebService] 
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaMunicipio int
) 
AS
BEGIN
	SET NOCOUNT ON;	
	IF @IdDerecho = 6
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
/****** Object:  StoredProcedure [PAT].[C_DatosMunicipalesDiligenciadosWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna las preguntas CON respuestas del tablero indicado, para el derecho y municipio especifico
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosMunicipalesDiligenciadosWebService] 
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaMunicipio int
)
AS
BEGIN
	SET NOCOUNT ON;	
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
GO
/****** Object:  StoredProcedure [PAT].[C_DatosMunicipalesSeguimientoODWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		14/11/2017
-- Description:		Retorna los datos del seguimiento de otros derechos 
--					del tablero PAT Indicado, por medida y Divipola
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosMunicipalesSeguimientoODWebService] --1, 6, 5172
(
	@IdTablero int, 
	@IdMedida int, 
	@DivipolaMunicipio int
)
AS
BEGIN
	SET NOCOUNT ON;	

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
		AND (b.IdMedida = @IdMedida OR @IdMedida IS NULL)

END
GO
/****** Object:  StoredProcedure [PAT].[C_DatosMunicipalesSeguimientoRCWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna los datos del seguimiento RC del tablero PAT Indicado, por Divipola
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosMunicipalesSeguimientoRCWebService] --1, 1, 5172
(
	@IdTablero int, 
	@DivipolaMunicipio int
)
AS
BEGIN
	SET NOCOUNT ON;	

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

				,SRC.AvancePrimer AS AvancePrimerSemestre
				,SRC.AvanceSegundo AS AvanceSegundoSemestre
				,SRC.FechaSeguimiento 

		FROM    PAT.PreguntaPATReparacionColectiva AS P
		INNER JOIN PAT.Medida M ON P.IdMedida = M.Id
		INNER JOIN PAT.RespuestaPATReparacionColectiva AS R ON R.IdPreguntaPATReparacionColectiva = P.Id
		INNER JOIN dbo.Municipio MUN ON P.IdMunicipio = MUN.Id
		LEFT OUTER JOIN
		(
		SELECT DISTINCT
			   [IdTablero]
			  ,[IdPregunta]
			  ,[IdUsuario]
			  ,[FechaSeguimiento]
			  ,[AvancePrimer]
			  ,[AvanceSegundo]
			  ,[NombreAdjunto]
			  ,USU.IdMunicipio
			  ,USU.IdDepartamento
			  ,USU.Id
		FROM [PAT].[SeguimientoReparacionColectiva] SEG
		INNER JOIN dbo.Usuario USU ON SEG.IdUsuario = USU.Id
		WHERE USU.IdMunicipio = [PAT].[fn_GetIdMunicipio](@DivipolaMunicipio)
		) AS SRC ON SRC.IdPregunta = P.Id --AND M.Id = SRC.IdMunicipio
		WHERE  
		P.IdTablero = @IdTablero
		AND MUN.Divipola = @DivipolaMunicipio
		ORDER BY P.Id

END
GO
/****** Object:  StoredProcedure [PAT].[C_DatosMunicipalesSeguimientoRRWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna los datos del seguimiento RR del tablero PAT Indicado por Divipola
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosMunicipalesSeguimientoRRWebService] --2, 5172
(
	@IdTablero int, 
	@DivipolaMunicipio int
)
AS
BEGIN
	SET NOCOUNT ON;	

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

			,SRR.AvancePrimer AS AvancePrimerSemestre
			,SRR.AvanceSegundo AS AvanceSegundoSemestre
			,SRR.FechaSeguimiento

		FROM    PAT.PreguntaPATRetornosReubicaciones AS P
		JOIN PAT.RespuestaPATRetornosReubicaciones AS R ON R.IdPreguntaPATRetornoReubicacion = P.Id 
		INNER JOIN dbo.Municipio AS M ON M.Id = P.IdMunicipio
		LEFT OUTER JOIN 
		(
			SELECT DISTINCT 
				[IdTablero]
				,[IdPregunta]
				,[IdUsuario]
				,[FechaSeguimiento]
				,[AvancePrimer]
				,[AvanceSegundo]
				,USU.IdDepartamento
				,USU.IdMunicipio
			FROM [PAT].[SeguimientoRetornosReubicaciones] SEG
			INNER JOIN dbo.Usuario USU ON SEG.IdUsuario = USU.Id
			WHERE USU.IdMunicipio = [PAT].[fn_GetIdMunicipio](@DivipolaMunicipio)
		) AS SRR ON SRR.IdPregunta = P.Id
		WHERE  
		P.IdTablero = @IdTablero
		AND M.Divipola = @DivipolaMunicipio
END
GO
/****** Object:  StoredProcedure [PAT].[C_DatosMunicipalesSeguimientoWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna los datos del seguimiento del tablero PAT Indicado, por derecho y Divipola
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosMunicipalesSeguimientoWebService] --1, 6, 5172
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaMunicipio int
)
AS
BEGIN
	SET NOCOUNT ON;	

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
				WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSeguimiento

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
GO
/****** Object:  StoredProcedure [PAT].[C_DatosPreguntasDepartamentoDiligenciadasWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna las respuestas de las preguntas de la gestion departamental (Nivel 2)
-- =============================================	
CREATE PROCEDURE [PAT].[C_DatosPreguntasDepartamentoDiligenciadasWebService] 
(
	@IdTablero int, 
	@DivipolaDepartamento int
) 
AS
BEGIN	

		SELECT DISTINCT  
			IdPregunta
			,IdRespuesta		
			,RespuestaIndicativa as RespuestaIndicativa
			,ObservacionNecesidad as ObservacionNecesidad
			,RespuestaCompromiso as RespuestaCompromiso
			,AccionCompromiso AS ObservacionCompromiso
			,CONVERT(FLOAT, Presupuesto) AS Presupuesto
			,AccionesMunicipio
			,ProgramasMunicipio
		FROM ( 
					SELECT DISTINCT 
							P.Id AS IdPregunta, 
							R.ID as IdRespuesta,
							R.RespuestaIndicativa, 
							R.RespuestaCompromiso, 
							R.Presupuesto,
							R.ObservacionNecesidad,							
							R.AccionCompromiso						
							,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
							FROM [PAT].RespuestaPATAccion AS ACCION
							WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesMunicipio,	
							STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
							FROM [PAT].RespuestaPATPrograma AS PROGRAMA
							WHERE R.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasMunicipio	
							,P.ACTIVO 
					FROM    PAT.PreguntaPAT AS P
					LEFT OUTER JOIN (SELECT	
											RESPUESTA.Id, 
											RESPUESTA.IdUsuario,										
											RESPUESTA.IdPreguntaPAT,
											RESPUESTA.RespuestaIndicativa, 
											RESPUESTA.RespuestaCompromiso, 
											RESPUESTA.Presupuesto,
											RESPUESTA.ObservacionNecesidad,
											RESPUESTA.AccionCompromiso
									FROM    PAT.RespuestaPAT AS RESPUESTA 
									INNER JOIN dbo.Departamento D ON D.Id = RESPUESTA.IdDepartamento
									WHERE	D.Divipola = @DivipolaDepartamento
					) AS R ON P.Id = R.IdPreguntaPAT
					WHERE	P.NIVEL = 2 AND P.Activo = 1 AND P.IdTablero = @IdTablero
					) AS P ORDER BY IdPregunta

END


GO
/****** Object:  StoredProcedure [PAT].[C_DerechosWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna los derechos asociados a un tablero con preguntas activas 
-- =============================================
CREATE PROC [PAT].[C_DerechosWebService] (@IdTablero int)
AS
BEGIN

		SELECT DISTINCT D.Id AS IdDerecho, D.Descripcion AS Nombre
		FROM [PAT].[Derecho] D
		JOIN [PAT].[PreguntaPAT] P ON D.Id = P.IdDerecho
		WHERE  P.IdTablero = @IdTablero AND P.Activo = 1
END

GO
/****** Object:  StoredProcedure [PAT].[C_MapaPoliticaPublicaWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Obtiene informacion del Mapa de Derechos, 
--					Componentes y Medidas para el Seguimiento PAT
-- =============================================
CREATE PROC [PAT].[C_MapaPoliticaPublicaWebService]

AS

BEGIN

	SELECT 
		a.[IdDerecho]
		,a.[Descripcion] AS Derecho
		,b.IdComponente 
		,b.Descripcion AS Componente
		,c.IdMedida 
		,c.Descripcion AS Medida
	FROM  
		[PAT].[MapaDerechos] a
	INNER JOIN 
		[PAT].[MapaComponentes] b ON a.IdDerecho = b.IdDerecho
	INNER JOIN 
		[PAT].[MapaMedidas] c ON b.IdComponente = c.IdComponente

END
GO
/****** Object:  StoredProcedure [PAT].[C_PreguntasReparacionColectivaWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		27/06/2017
-- Description:		Retorna las preguntas de reparacion colectiva de un tablero indicado
-- =============================================
CREATE PROCEDURE [PAT].[C_PreguntasReparacionColectivaWebService] 
(@IdTablero int)
AS
BEGIN
	SET NOCOUNT ON;	 
	
		SELECT  P.[Id] as IdPregunta
		,P.IdTablero as IdTablero
		,P.IdMedida as IdMedida
		,P.Sujeto as Sujeto
		,P.[MedidaReparacionColectiva] as MedidaReparacionColectiva
		,M.Descripcion as Medida
		,MUN.Divipola AS DivipolaMunicipio           
		FROM [PAT].PreguntaPATReparacionColectiva as P
		INNER JOIN PAT.Medida AS M ON  P.IdMedida = M.Id
		INNER JOIN dbo.Departamento AS D ON P.IdDepartamento = D.Id
		INNER JOIN dbo.Municipio AS MUN ON P.IdMunicipio = MUN.Id
		where P.Activo = 1 AND P.IdTablero = @IdTablero
  END

GO
/****** Object:  StoredProcedure [PAT].[C_PreguntasRetornosReubicacionesWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Retorna las preguntas de retornos y reubicaciones de un tablero indicado
-- =============================================
CREATE PROCEDURE [PAT].[C_PreguntasRetornosReubicacionesWebService] --1
(@IdTablero int)
AS
BEGIN
	SET NOCOUNT ON;	 

		  SELECT P.[Id] AS IdPregunta
		  ,P.IdTablero as IdTablero
		  ,P.MedidaRetornoReubicacion as MedidaRetornoReubicacion		  
		  ,M.Divipola AS DivipolaMunicipio    		  
		  ,P.[Hogares] as Hogares
		  ,P.[Personas] as Personas
		  ,P.[Sector] as Sector
		  ,P.[Componente] as Componente
		  ,P.[Comunidad] as Comunidad
		  ,P.[Ubicacion] as Ubicacion
		  ,P.[IndicadorRetornoReubicacion] as Indicador
		  ,P.[EntidadResponsable] as EntidadResponsable
		  FROM [PAT].[PreguntaPATRetornosReubicaciones] as P       		  
		  INNER JOIN dbo.Departamento D ON P.IdDepartamento = D.Id
		  INNER JOIN dbo.Municipio M ON P.IdMunicipio = M.Id
		  WHERE P.IdTablero = @IdTablero AND P.Activo = 1
		  
  END

GO
/****** Object:  StoredProcedure [PAT].[C_PreguntasWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Obtiene informacion de las preguntas del PAT del tablero indicado
-- =============================================
CREATE PROCEDURE [PAT].[C_PreguntasWebService] (@IdTablero int)
AS
BEGIN
	SET NOCOUNT ON;	 

		SELECT DISTINCT 
		A.Id as IdPregunta,		
		A.IdTablero as IdTablero,
		A.IdDerecho as IdDerecho, 
        A.IdComponente as IdComponente, 
		A.IdMedida as IdMedida, 
		A.Nivel as Nivel, 
        A.IdUnidadMedida as IdUnidadMedida, 
        A.PreguntaIndicativa as PreguntaIndicativa, 
		A.PreguntaCompromiso as PreguntaCompromiso, 
		A.ApoyoDepartamental as ApoyoDepartamental, 
        A.ApoyoEntidadNacional as ApoyoNivelNacional, 
		A.Activo as Activo,
		B.Descripcion AS  Derecho, 
        C.Descripcion AS  Componente, 
		D.Descripcion AS Medida, 
        E.Descripcion AS UnidadMedida		
		FROM PAT.PreguntaPAT A
		INNER JOIN PAT.Derecho B ON A.IdDerecho = B.Id
		INNER JOIN PAT.Componente C ON A.IdComponente = C.Id
		INNER JOIN PAT.Medida D ON A.IdMedida = D.Id
		INNER JOIN PAT.UnidadMedida E ON A.IdUnidadMedida = E.Id
		where A.Activo = 1 AND A.IdTablero = @IdTablero
		ORDER BY A.Id ASC
	
END

GO
/****** Object:  StoredProcedure [PAT].[C_TablerosWebService]    Script Date: 14/11/2017 7:57:08 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Description:		Obtiene el Listado de los Tableros para el WebService PAT
-- =============================================
CREATE PROCEDURE [PAT].[C_TablerosWebService]
AS
BEGIN
	SELECT [Id] AS Id,	
	CONVERT(VARCHAR(10), [VigenciaInicio], 103 ) as VigenciaInicio, 
	CONVERT(VARCHAR(10), [VigenciaFin], 103) AS VigenciaFin, 
	[Activo] AS Activo, 
	YEAR([VigenciaInicio]) + 1 AS Año
	FROM PAT.Tablero
END

GO