IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ValidarEnvioPlanV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ValidarEnvioPlanV3] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Grupo de Desarrollo OIM - Andrés Bonilla																			 
-- Fecha creacion: 2018-02-05																			 
-- Descripcion: Retorna el resultado (BIT) de la validacion del usuario permitido para enviar
--				el plan de mejoramiento, bajo la condición de que debe haber respondido al menos
--				una acción por cada estrategia presentada en pantalla al momento de diligenciar
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ValidarEnvioPlanV3]
(
	@idPlan INT
	,@idUsuario INT
)

AS

BEGIN

	DECLARE @idEncuesta INT
	DECLARE @puedeEnviar BIT

	DECLARE @tabEstrategiasPorUsuario TABLE
	(
		IdEstrategia INT
	)

	DECLARE @tabEstrategiasTareasPorUsuario TABLE
	(
		IdEstrategia INT
		,CantTareasSelecc INT
	)

	SELECT 
		@idEncuesta = xx.IdEncuesta 
	FROM 
		PlanesMejoramiento.PlanMejoramientoEncuesta xx
	WHERE 
		xx.IdPlanMejoriamiento = @idPlan

	--Estrategias que el usuario debio diligenciar
	INSERT INTO @tabEstrategiasPorUsuario
	SELECT DISTINCT
	b.IdEstrategia
	FROM PlanesMejoramiento.Tareas a (NOLOCK)
	INNER JOIN PlanesMejoramiento.Estrategias b (NOLOCK) ON a.[IdEstrategia] = b.[IdEstrategia]
	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c (NOLOCK) ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramiento d (NOLOCK) ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta k (NOLOCK) ON k.IdPlanMejoriamiento = d.IdPlanMejoramiento 
	INNER JOIN dbo.Pregunta g (NOLOCK) ON g.Id = a.IdPregunta
	INNER JOIN dbo.TipoPregunta tp (NOLOCK) ON tp.Id = g.IdTipoPregunta
	INNER JOIN dbo.Seccion h (NOLOCK) ON h.Id = g.IdSeccion and h.IdEncuesta = k.IdEncuesta 	
	LEFT OUTER JOIN dbo.Respuesta rr (NOLOCK) ON rr.IdPregunta = g.Id AND rr.Valor = CASE tp.Id WHEN 11 THEN a.Opcion ELSE CASE a.Opcion WHEN 'Vacío' THEN NULL ELSE rr.Valor END END AND rr.IdUsuario = @idUsuario --Traer respuestas vacias y no vacias (tipos de pregunta diferentes a unico)
	INNER JOIN PlanesMejoramiento.PlanActivacionFecha i (NOLOCK) ON i.IdPlanMejoramiento = d.IdPlanMejoramiento
	WHERE d.IdPlanMejoramiento = @idPlan
	AND 
	(

		(tp.Id <> 11 AND (
		(a.Opcion = 'Vacío' AND (NOT EXISTS(SELECT TOP 1 1 FROM dbo.Respuesta xx WHERE xx.IdPregunta = g.Id AND xx.IdUsuario = @idUsuario))) 
		OR
		(a.Opcion <> 'Vacío' AND (EXISTS(SELECT TOP 1 1 FROM dbo.Respuesta xx WHERE xx.IdPregunta = g.Id AND xx.IdUsuario = @idUsuario)))
		)) OR (tp.Id = 11 AND rr.Valor = a.Opcion)
	)

	--Cantidad de tareas seleccionadas por estrategia y por usuario
	INSERT INTO @tabEstrategiasTareasPorUsuario
	SELECT
	a.IdEstrategia
	,COUNT(c.IdTareaPlan)
	FROM 
		@tabEstrategiasPorUsuario a
	INNER JOIN 
		PlanesMejoramiento.Tareas b 
			ON b.IdEstrategia = a.IdEstrategia
	LEFT OUTER JOIN 
		PlanesMejoramiento.TareasPlan c 
			ON c.IdTarea = b.IdTarea AND c.IdUsuario = @idUsuario
	GROUP BY a.IdEstrategia

	--Si alguna estrategia no tiene al menos 1 tarea seleccionada, no se deja enviar
	IF EXISTS (SELECT TOP 1 * FROM @tabEstrategiasTareasPorUsuario WHERE CantTareasSelecc = 0)
	BEGIN
		SET @puedeEnviar = 0
	END
	ELSE
	BEGIN
		SET @puedeEnviar = 1
	END

	SELECT @puedeEnviar AS Envia


END