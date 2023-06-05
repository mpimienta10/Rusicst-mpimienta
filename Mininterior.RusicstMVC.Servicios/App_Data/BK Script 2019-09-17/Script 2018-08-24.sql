
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PAT.U_UndoArchivoSeguimiento') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE PAT.U_UndoArchivoSeguimiento AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla		
-- Fecha creacion: 2018-08-24																			  
-- Descripcion: Vacía el nombre de adjunto en seguimiento, seguimiento RC, seguimiento RR y seguimiento OD
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC PAT.U_UndoArchivoSeguimiento
(
	@IdPregunta INT
	,@IdTablero INT
	,@IdUsuario INT
	,@Type varchar(5)
)

AS

BEGIN

	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado

	IF @Type = 'D'
	BEGIN
		BEGIN TRY
			
			UPDATE
				PAT.Seguimiento
			SET
				NombreAdjunto = ''
			WHERE
				IdPregunta = @IdPregunta
				AND
				IdUsuario = @IdUsuario
				AND
				IdTablero = @IdTablero

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH		
	END
	ELSE IF @Type = 'D2'
	BEGIN
		BEGIN TRY
			
			UPDATE
				PAT.Seguimiento
			SET
				NombreAdjuntoSegundo = ''
			WHERE
				IdPregunta = @IdPregunta
				AND
				IdUsuario = @IdUsuario
				AND
				IdTablero = @IdTablero

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END
	ELSE IF @Type = 'RC'
	BEGIN
		BEGIN TRY
			
			UPDATE
				PAT.SeguimientoReparacionColectiva
			SET
				NombreAdjunto = ''
			WHERE
				IdPregunta = @IdPregunta
				AND
				IdUsuario = @IdUsuario
				AND
				IdTablero = @IdTablero

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END
	ELSE IF @Type = 'RR'
	BEGIN
		BEGIN TRY
			
			UPDATE
				PAT.SeguimientoRetornosReubicaciones
			SET
				NombreAdjunto = ''
			WHERE
				IdPregunta = @IdPregunta
				AND
				IdUsuario = @IdUsuario
				AND
				IdTablero = @IdTablero

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END
	ELSE IF @Type = 'OD'
	BEGIN
		BEGIN TRY
			
			UPDATE
				PAT.SeguimientoOtrosDerechos
			SET
				NombreAdjunto = ''
			WHERE
				IdSeguimiento = @IdPregunta
				AND
				IdUsuario = @IdUsuario
				AND
				IdTablero = @IdTablero

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END
	ELSE IF @Type = 'CSD'
	BEGIN
		BEGIN TRY
			
			UPDATE
				PAT.SeguimientoGobernacion
			SET
				NombreAdjunto = ''
			WHERE
				IdSeguimiento = @IdPregunta
				AND
				IdUsuario = @IdUsuario
				AND
				IdTablero = @IdTablero

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END
	ELSE IF @Type = 'CSD2'
	BEGIN
		BEGIN TRY
			
			UPDATE
				PAT.SeguimientoGobernacion
			SET
				NombreAdjuntoSegundo = ''
			WHERE
				IdSeguimiento = @IdPregunta
				AND
				IdUsuario = @IdUsuario
				AND
				IdTablero = @IdTablero

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

END


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerDatosSeguimientoPlanMejoramiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerDatosSeguimientoPlanMejoramiento] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla		
-- Fecha creacion: 2018-08-22																			  
-- Descripcion: Obtiene los datos del seguimiento de plan de mejoramiento							  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerDatosSeguimientoPlanMejoramiento]
(
	@IdSeguimiento INT
)

AS

BEGIN

	SELECT
		A.IdPlanSeguimiento
		,A.NumeroSeguimiento
		,B.IdPlanMejoramiento
		,B.Nombre AS NombrePlan
		,C.Id AS IdEncuesta
		,C.Titulo as NombrenEncuesta
	FROM
		[PlanesMejoramiento].[PlanMejoramientoSeguimiento] A
		INNER JOIN 
			[PlanesMejoramiento].[PlanMejoramiento] B ON B.IdPlanMejoramiento = A.IdPlanMejoramiento
		INNER JOIN 
			[dbo].[Encuesta] C ON C.Id = A.IdEncuesta
	WHERE
		A.IdPlanSeguimiento = @IdSeguimiento

END