GO

alter table [dbo].[PermisoUsuarioEncuesta]
add IdTipoExtension INT NOT NULL DEFAULT(1)

GO

ALTER TABLE [dbo].[PermisoUsuarioEncuesta] DROP CONSTRAINT [FK_PermisoUsuarioEncuesta_Encuesta]

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_PermisoUsuarioEncuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_PermisoUsuarioEncuestaInsert] AS'

GO

-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Modifca:		Andrés Bonilla
-- Create date: 04/04/2017
-- Fecha Modificacion: 26/10/2017
-- Description:	Inserta un registro en la tabla Permiso Usuario Encuesta 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- Modificacion: Se agrega el parámetro de ingreso IdTipoExtension para identificar los diferentes
--				 tipos de extensiones de tiempo posibles, 1 - Encuesta, 2 - Plan de Mejoramiento
--				 3 - Tablero PAT
-- ================================================================================================
ALTER PROCEDURE [dbo].[I_PermisoUsuarioEncuestaInsert]
	
	 @IdUsuario			INT
	,@IdEncuesta		INT
	,@FechaFin			DATETIME
	,@UsuarioAutenticado VARCHAR(255)
	,@IdTipoExtension	INT

AS
	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
					BEGIN TRY
						
						--======================================================
						-- Obtiene el ID del usuario que realiza la transacción
						--======================================================
						DECLARE @IdUsuarioTramite INT
						SELECT @IdUsuarioTramite = [Id] FROM [dbo].[Usuario] WHERE [IdUser] = (SELECT [Id] FROM [dbo].[AspNetUsers] WHERE [UserName] = @UsuarioAutenticado)

						DECLARE @FechaFinEncuesta DATETIME
						SELECT @FechaFinEncuesta = FechaFin FROM Encuesta WHERE Id = @IdEncuesta

						IF(@IdUsuarioTramite IS NOT NULL AND LEN(@IdUsuarioTramite) > 0)
							BEGIN
								--============================================================================
								-- SI LA FECHA QUE SE QUIERE COLOCAR ES MENOR A LA FECHA FINAL DE LA ENCUESTA
								--============================================================================
								IF(CAST(@FechaFinEncuesta AS DATE) > CAST(@FechaFin AS DATE) AND @IdTipoExtension = 1)
									BEGIN
										SELECT @respuesta = 'La fecha de fin propuesta, debe ser superior a la fecha de fin (' + CONVERT(VARCHAR, @FechaFinEncuesta, 105) + ') de la encuesta'
									END
								ELSE IF ((SELECT COUNT(*) FROM [dbo].[PermisoUsuarioEncuesta] WHERE [IdUsuario] = @IdUsuario AND [IdEncuesta] = @IdEncuesta) > 0)
									BEGIN
										--==========================================================
										-- OBTIENE LA FECHA QUE TIENE LA ULTIMA EXTENSION DE TIEMPO
										--==========================================================
										SELECT TOP 1 @FechaFinEncuesta = PUE.FechaFin
										FROM PermisoUsuarioEncuesta PUE
										WHERE IdUsuario = @IdUsuario AND IdEncuesta = @IdEncuesta AND IdTipoExtension = @IdTipoExtension
										ORDER BY PUE.FechaFin DESC

										--===========================================================================
										-- VALIDA QUE LA FECHA PROPUESTA SEA SUPERIOR A LA FECHA DE EXTENSION ACTUAL
										--===========================================================================
										IF(CAST(@FechaFinEncuesta AS DATE) >= CAST(GETDATE() AS DATE))
											BEGIN
												SELECT @respuesta = 'Se encontró una Extensión de Tiempo con fecha vigente (' + CONVERT(VARCHAR, @FechaFinEncuesta, 105) + '). Para extender el plazo, esta fecha debe estar vencida.'
											END

										ELSE IF(CAST(@FechaFinEncuesta AS DATE) < CAST(GETDATE() AS DATE) AND CAST(@FechaFinEncuesta AS DATE) > CAST(@FechaFin AS DATE))
											BEGIN
												SELECT @respuesta = 'La fecha de fin propuesta, debe ser superior a la fecha de extensión de tiempo (' + CONVERT(VARCHAR, @FechaFinEncuesta, 105) + ')'
											END

										ELSE
											BEGIN
												INSERT INTO [dbo].[PermisoUsuarioEncuesta]([IdUsuario],[IdEncuesta],[FechaFin],[IdUsuarioTramite],[FechaTramite],[IdTipoExtension])
												SELECT @IdUsuario, @IdEncuesta, @FechaFin, @IdUsuarioTramite, GETDATE(), @IdTipoExtension

												SELECT @respuesta = 'El plazo ha sido extendido'
												SELECT @estadoRespuesta = 1
											END
									END
								ELSE
									BEGIN
										INSERT INTO [dbo].[PermisoUsuarioEncuesta]([IdUsuario],[IdEncuesta],[FechaFin],[IdUsuarioTramite],[FechaTramite],[IdTipoExtension])
										SELECT @IdUsuario, @IdEncuesta, @FechaFin, @IdUsuarioTramite, GETDATE(), @IdTipoExtension

										SELECT @respuesta = 'El plazo ha sido extendido'
										SELECT @estadoRespuesta = 1
									END
							END
	
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ExtensionesTiempo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ExtensionesTiempo] AS'

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
		END AS Reporte
		,[UTramite].[UserName] AS Autoriza
		,[PUE].[FechaTramite]
		,CASE PUE.[IdTipoExtension] WHEN 1 THEN 'Encuesta' WHEN 2 THEN 'Plan de Mejoramiento' WHEN 3 THEN 'Tablero PAT' END AS TipoExtension
	FROM 
		[dbo].[PermisoUsuarioEncuesta] AS PUE
		INNER JOIN [dbo].[Usuario] U ON [PUE].[IdUsuario] = [U].[Id]
		INNER JOIN [dbo].[Usuario] UTramite ON [PUE].[IdUsuarioTramite] = [UTramite].[Id]
		--INNER JOIN [dbo].[Encuesta] AS E ON [PUE].IdEncuesta= [E].Id
	ORDER BY  
		PUE.[IdTipoExtension], [PUE].[FechaFin] DESC

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ValidarPermisosGuardado]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ValidarPermisosGuardado] AS'

GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-10-26																			 
-- Descripcion: Retorna un bit resultado de la validacion de extension de tiempo de un usuario especifico
--				para una encuesta, plan o tablero pat
-- ***************************************************************************************************
ALTER PROC [dbo].[C_ValidarPermisosGuardado]
(
	@idUsuario INT
	,@idEncuesta INT
	,@idTipoExtension INT
)

AS

BEGIN

SET NOCOUNT ON;

	DECLARE @fecha DATETIME
	DECLARE @valido BIT

	SET @fecha = GETDATE()

	SET @valido = 0

	SELECT 
		@valido = 1 
	FROM 
		[dbo].[PermisoUsuarioEncuesta] 
	WHERE 
		IdUsuario = @idUsuario 
		AND 
			IdEncuesta = @idEncuesta 
		AND
			FechaFin >= @fecha
		AND
			IdTipoExtension = @idTipoExtension


	SELECT 
		@valido AS UsuarioHabilitado

END

GO