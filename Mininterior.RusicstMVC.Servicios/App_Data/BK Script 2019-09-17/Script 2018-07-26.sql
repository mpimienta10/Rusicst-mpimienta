
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerIdTipoPlanEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerIdTipoPlanEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2018-04-10																			 
-- Fecha modificacion: 2018-07-26				
-- Descripcion: Retorna los datos de tipo envio, idseguimiento, idplan necesarios para poder verificar
--				Si se debe remitir el usuario a la planeacion (diligenciamiento) o al seguimiento
--				del plan de mejoramiento
-- Modificacion: Se incluye el parametro idUsuario para validar si el usuario envió el plan y encuesta
--				Anterior, si es así debe pasar al seguimiento, de lo contrario a la planeacion del nuevo plan
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerIdTipoPlanEncuesta] --1083
(
	@IdEncuesta INT
	,@IdUsuario INT
)

AS

BEGIN

DECLARE @IdEncuestaSeguimiento INT
DECLARE @TipoPlan varchar(5)
DECLARE @IdPlan INT
DECLARE @IdSeguimiento INT

DECLARE @EncuestasReplica TABLE (
	IdEncuesta INT
)

INSERT INTO @EncuestasReplica
SELECT Id FROM dbo.Encuesta WHERE Titulo LIKE '%RÉPLICA%' OR Titulo LIKE '%REPLICA%'

	DECLARE @RolEncuesta UNIQUEIDENTIFIER

	SELECT 
		@RolEncuesta = IdRol
	FROM
		Roles.RolEncuesta 
	WHERE
		IdEncuesta = @IdEncuesta



	SELECT TOP 1
		@IdEncuestaSeguimiento = IdEncuesta
	FROM
		Roles.RolEncuesta
	WHERE
		IdRol = @RolEncuesta
		AND
		IdEncuesta < @IdEncuesta
		AND
		IdEncuesta NOT IN (
			Select IdEncuesta From @EncuestasReplica
		)

	ORDER BY
		IdEncuesta DESC

---SI HIZO EL ENVIO DE LA ENCUESTA PASADA + PLAN DEBE IR A SEGUIMIENTO DEL PLAN PASADO
IF EXISTS (SELECT 1 FROM dbo.Envio WHERE IdEncuesta = @IdEncuestaSeguimiento AND IdUsuario = @IdUsuario)
BEGIN

	IF EXISTS(SELECT 1 FROM PlanesMejoramiento.PlanMejoramientoEncuesta WHERE IdEncuesta = @IdEncuestaSeguimiento)
	BEGIN

		SET @TipoPlan = 'SP'

		SELECT 
			@IdPlan = IdPlanMejoriamiento 
		FROM 
			PlanesMejoramiento.PlanMejoramientoEncuesta 
		WHERE 
			IdEncuesta = @IdEncuestaSeguimiento

		---SI NO TIENE PROPIO, TIENE SEGUIMIENTO
		IF EXISTS(SELECT 1 FROM PlanesMejoramiento.PlanMejoramientoSeguimiento WHERE IdPlanMejoramiento = @IdPlan AND GETDATE() BETWEEN FechaInicio AND FechaFin)
		BEGIN
			SELECT 
				@IdSeguimiento = IdPlanSeguimiento
			FROM 
				PlanesMejoramiento.PlanMejoramientoSeguimiento 
			WHERE 
				IdPlanMejoramiento = @IdPlan 
				AND 
				GETDATE() BETWEEN FechaInicio AND FechaFin
		END
		ELSE
		BEGIN
			
			--SI TAMPOCO TIENE SEGUIMENTO LO MANDAMOS AL PLAN DE MEJORAMIENTO PROPIO
			IF EXISTS(SELECT 1 FROM PlanesMejoramiento.PlanMejoramientoEncuesta WHERE IdEncuesta = @IdEncuesta)
			BEGIN

				SET @TipoPlan = 'P'

				SELECT 
					@IdPlan = IdPlanMejoriamiento 
				FROM 
					PlanesMejoramiento.PlanMejoramientoEncuesta 
				WHERE 
					IdEncuesta = @IdEncuesta

			END
			ELSE ---SI TAMPOCO TIENE PLAN PROPIO ENTONCES ERROR
			BEGIN
				SET @TipoPlan = 'ND'
				SET @IdPlan = -1
			END			
		END
	END		
	ELSE
	BEGIN
			
		SET @TipoPlan = 'ND'
		SET @IdPlan = -1
	END
END
ELSE
BEGIN
	--TIENE PLAN DE MEJORAMIENTO PROPIO
	IF EXISTS(SELECT 1 FROM PlanesMejoramiento.PlanMejoramientoEncuesta WHERE IdEncuesta = @IdEncuesta)
	BEGIN

		SET @TipoPlan = 'P'

		SELECT 
			@IdPlan = IdPlanMejoriamiento 
		FROM 
			PlanesMejoramiento.PlanMejoramientoEncuesta 
		WHERE 
			IdEncuesta = @IdEncuesta
	END
	ELSE ---SI TAMPOCO TIENE PLAN PROPIO ENTONCES ERROR
	BEGIN
		SET @TipoPlan = 'ND'
		SET @IdPlan = -1
	END	

END

SELECT @IdEncuesta as IdEncuesta, @IdEncuestaSeguimiento as IdEncuestaSeguimiento, @IdPlan as IdPlan, @TipoPlan as TipoPlan, @IdSeguimiento AS IdSeguimiento

END

GO