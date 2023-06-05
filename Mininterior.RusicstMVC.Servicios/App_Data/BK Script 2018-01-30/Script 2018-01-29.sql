-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		10/07/2017
-- Modified date:	22/01/2018
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
			R.NombreAdjunto ,
			R.ObservacionPresupuesto
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
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	29/01/2018
-- Description:		Obtiene informacion para el seguimiento para el detalle del consolidado para los municipios que respondieron la pregunta indicada
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] --pat.C_TableroSeguimientoDetalleConsolidadoDepartamento 4,375,21
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
	,ISNULL(SM.IdSeguimiento, 0) AS IdSeguimientoMunicipio
	,(SELECT TOP 1 XX.Id FROM [PAT].RespuestaPAT XX  
							join pat.PreguntaPAT as p on XX.IdPreguntaPAT = p.Id
							WHERE XX.IdMunicipio = @IdMunicipio and XX.IdPreguntaPAT = @IdPregunta and p.IdTablero = @IdTablero) AS IdRespuestaDepartamentoMunicipio
	,ISNULL(SG.CantidadPrimer, -1) AS CantidadPrimerSemestreGobernaciones
	,ISNULL(SG.CantidadSegundo, -1) AS CantidadSegundoSemestreGobernaciones
	,RD.Presupuesto
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

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	29/01/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero municipal 
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoAlcaldias] --[PAT].[C_DatosExcelSeguimientoAlcaldias] 411, 4
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
		,SM.ObservacionesSegundo
		,SM.NombreAdjuntoSegundo

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
