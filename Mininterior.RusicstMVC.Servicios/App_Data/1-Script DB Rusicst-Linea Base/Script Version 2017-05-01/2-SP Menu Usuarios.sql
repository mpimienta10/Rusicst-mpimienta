GO
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ObtenerPermisosRol]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_ObtenerPermisosRol]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ObtenerExtensionesTiempo]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_ObtenerExtensionesTiempo]
END

--=============================================================================================
-- PROCEDIMIENTO ALMACENADOS
--=============================================================================================

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_TipoUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_TipoUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 23/02/2017
-- Description:	Selecciona la información de Tipos de Usuario
-- =============================================
ALTER PROCEDURE [dbo].[C_TipoUsuario] 

		 @Id	 INT = NULL
		,@Tipo	 VARCHAR(255) = NULL
		,@Nombre VARCHAR(255) = NULL
		,@Activo BIT = NULL

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			 [Id]
			,[Tipo]
			,[Nombre]
			,[Activo]
		FROM
			[dbo].[TipoUsuario]
		WHERE (@Id IS NULL OR Id = @Id)
		AND	(@Tipo IS NULL OR Tipo = @Tipo)
		AND (@Nombre IS NULL OR Nombre = @Nombre)
		AND (@Activo IS NULL OR Activo = @Activo)

	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_TipoUsuarioDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_TipoUsuarioDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Description:	Elimina un registro de Tipos de Usuario 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[D_TipoUsuarioDelete] 
	
	@Id	INT

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
					DELETE [dbo].[TipoUsuario] 
					WHERE [Id] = @Id

					SELECT @respuesta = 'Se ha eliminado el registro'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_TipoUsuarioUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_TipoUsuarioUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Description:	Actualiza la información de Tipos de Usuario 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[U_TipoUsuarioUpdate] 
	
	@Id		INT,
	@Tipo	VARCHAR(255), 
	@Nombre VARCHAR(255),
	@Activo	BIT

AS

	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		IF (EXISTS(SELECT * FROM [dbo].[TipoUsuario] WHERE [Nombre] = @Nombre AND [Tipo] <> @Tipo ))
			BEGIN
				SET @esValido = 0
				SET @respuesta += 'El Nombre ya se encuentra asignado a otra definición.'
			END

		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY
					UPDATE [dbo].[TipoUsuario] 
					SET [Tipo] = @Tipo, [Nombre] = @Nombre, [Activo] = @Activo	
					WHERE [Id] = @Id

					SELECT @respuesta = 'Se ha actualizado el registro'
					SELECT @estadoRespuesta = 2
	
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_TipoUsuarioInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_TipoUsuarioInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Description:	Inserta un registro en Tipos de Usuario 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[I_TipoUsuarioInsert] 
	
	@Tipo	VARCHAR(255), 
	@Nombre VARCHAR(255),
	@Activo	BIT

AS
	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		IF (EXISTS(SELECT * FROM [dbo].[TipoUsuario] WHERE [Tipo] = @Tipo))
			BEGIN
				SET @esValido = 0
				SET @respuesta += 'El Tipo ya se encuentra asignado a otra definición.'
			END

		IF (EXISTS(SELECT * FROM [dbo].[TipoUsuario] WHERE [Nombre] = @Nombre))
			BEGIN
				SET @esValido = 0
				SET @respuesta += 'El Nombre ya se encuentra asignado a otra definición.'
			END

		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY
					INSERT INTO [dbo].[TipoUsuario] ([Tipo], [Nombre], [Activo])
					SELECT @Tipo, @Nombre, @Activo	
					SELECT @respuesta = 'Se ha insertado el registro'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Usuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_Usuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==============================================================================================================
-- Autor : Christian Ospina
-- Fecha : 2017-04-05																			 
-- Descripción: Consulta la información de los usuarios para la rejilla de usuarios de acuerdo a los criterios
--				de filtro																	 
--==============================================================================================================
ALTER PROC [dbo].[C_Usuario]

	 @Id			INT = NULL
	,@Token			UNIQUEIDENTIFIER = NULL
	,@IdTipoUsuario	INT = NULL
	,@IdDepartamento INT = NULL
	,@IdMunicipio	INT = NULL
	,@UserName		VARCHAR(128) = NULL
	,@IdEstado		INT = NULL

	AS
		SELECT
			 [UserName]
--======================================================================================
-- ORDEN DE LA CONSULTA NECESARIA PARA QUE SE MUESTRE EN ESTE MISMO ORDEN EN LA REJILLA
--=======================================================================================
			,[Nombres]
			,[FechaSolicitud]
			,[Cargo]
			,[TelefonoFijo]
			,[T].[Nombre] TipoUsuario
			,[TelefonoCelular]
			,[Email]
			,[M].[Nombre] Municipio
			,[D].[Nombre] Departamento
			,[DocumentoSolicitud]
--=======================================================================================
			,[U].[Id]
			,[IdUser]
			,[IdTipoUsuario]
			,[U].[IdDepartamento]
			,[U].[IdMunicipio]
			,[U].[IdEstado]
			,[E].[Nombre] Estado
			,[IdUsuarioTramite]			
			,[TelefonoFijoIndicativo]
			,[TelefonoFijoExtension]
			,[EmailAlternativo]
			,[Enviado]
			,[DatosActualizados]
			,[Token]
			,[U].[Activo]
			,[FechaNoRepudio]
			,[FechaTramite]
			,[FechaConfirmacion]	
		FROM 
			[dbo].[Usuario] U
			LEFT JOIN [dbo].[TipoUsuario] T ON [U].[IdTipoUsuario] = [T].[Id]
			LEFT JOIN [dbo].[Estado] E ON [U].[IdEstado] = [E].[Id]	
			LEFT JOIN [dbo].[Departamento] D on [D].[Id] = [U].[IdDepartamento]
			LEFT JOIN [dbo].[Municipio] M on [M].[Id] = [U].[IdMunicipio]
		WHERE 
			(@Id IS NULL OR [U].[Id] = @Id) 
			AND (@Token IS NULL OR [U].[Token] = @Token) 
			AND (@IdTipoUsuario IS NULL OR [U].[IdTipoUsuario] = @IdTipoUsuario) 
			AND (@IdDepartamento IS NULL OR [U].[IdDepartamento]  = @IdDepartamento )
			AND (@IdMunicipio IS NULL OR [U].[IdMunicipio] = @IdMunicipio)
			AND (@UserName IS NULL OR [U].[UserName] = @UserName)
			AND (@IdEstado IS NULL OR [U].[IdEstado] = @IdEstado)
			AND ([U].[IdEstado] <> 6)

		ORDER BY 
			U.Nombres 

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_UsuarioUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_UsuarioUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Description:	Actualiza un registro en Usuarios
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[U_UsuarioUpdate] 
	
	 @Id					INT = NULL
	,@IdUser				VARCHAR(128) = NULL
	,@IdTipoUsuario			INT = NULL
	,@IdDepartamento		INT = NULL 
	,@IdMunicipio			INT = NULL 
	,@IdEstado				INT = NULL
	,@IdUsuarioTramite		INT = NULL
	,@UserName				VARCHAR(255) = NULL 
	,@Nombres				VARCHAR(255) = NULL
	,@Cargo					VARCHAR(255) = NULL 
	,@TelefonoFijo			VARCHAR(255) = NULL 
	,@TelefonoFijoIndicativo VARCHAR(255) = NULL
	,@TelefonoFijoExtension	VARCHAR(255) = NULL  
	,@TelefonoCelular		VARCHAR(255) = NULL 
	,@Email					VARCHAR(255) = NULL 
	,@EmailAlternativo		VARCHAR(255) = NULL 
	,@Enviado				BIT = NULL
	,@DatosActualizados		BIT = NULL
	,@Token					UNIQUEIDENTIFIER = NULL
	,@Activo				BIT = NULL
	,@DocumentoSolicitud	VARCHAR(60)
	,@FechaSolicitud		DATETIME
	,@FechaNoRepudio		DATETIME
	,@FechaTramite			DATETIME
	,@FechaConfirmacion		DATETIME
	,@NombreGrupo			VARCHAR(50) = NULL
	,@ParametroID			VARCHAR(50) = NULL

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
					UPDATE 
						[dbo].[Usuario] 
					SET 
						 [IdUser] = ISNULL(@IdUser, [IdUser])
						,[IdTipoUsuario] = ISNULL(@IdTipoUsuario, [IdTipoUsuario])
						,[IdDepartamento] = ISNULL(@IdDepartamento, [IdDepartamento])
						,[IdMunicipio] = ISNULL(@IdMunicipio, [IdMunicipio])
						,[IdEstado] = ISNULL(@IdEstado, [IdEstado])
						,[IdUsuarioTramite] = ISNULL(@IdUsuarioTramite, [IdUsuarioTramite])
						,[UserName] = ISNULL(@UserName, [UserName])
						,[Nombres] = ISNULL(@Nombres, [Nombres])
						,[Cargo] = ISNULL(@Cargo, [Cargo])
						,[TelefonoFijo] = ISNULL(@TelefonoFijo, [TelefonoFijo])
						,[TelefonoFijoIndicativo] = ISNULL(@TelefonoFijoIndicativo, [TelefonoFijoIndicativo])
						,[TelefonoFijoExtension] = ISNULL(@TelefonoFijoExtension, [TelefonoFijoExtension])
						,[TelefonoCelular] = ISNULL(@TelefonoCelular, [TelefonoCelular])
						,[Email] = ISNULL(@Email, [Email])
						,[EmailAlternativo] = ISNULL(@EmailAlternativo, [EmailAlternativo])
						,[Enviado] = ISNULL(@Enviado, [Enviado])
						,[DatosActualizados] = ISNULL(@DatosActualizados, [DatosActualizados])
						,[Token] = ISNULL(@Token, [Token])
						,[Activo] = ISNULL(@Activo, [Activo])
						,[DocumentoSolicitud] = ISNULL(@DocumentoSolicitud, [DocumentoSolicitud])
						,[FechaSolicitud] = ISNULL(@FechaSolicitud, [FechaSolicitud])
						,[FechaNoRepudio] = ISNULL(@FechaNoRepudio, [FechaNoRepudio])
						,[FechaTramite] = ISNULL(@FechaTramite, [FechaTramite])
						,[FechaConfirmacion] = ISNULL(@FechaConfirmacion, [FechaConfirmacion])
					WHERE 
						[Id] = @Id
					
					--===============================================================================
					-- Obtiene el mensaje que esta configurado en la tabla de parámetros del sistema
					--===============================================================================
					IF(@NombreGrupo IS NOT NULL AND @ParametroID IS NOT NULL)
						BEGIN
							SELECT @respuesta = [PS].[ParametroValor]
							FROM [ParametrizacionSistema].[ParametrosSistema] PS
							INNER JOIN [ParametrizacionSistema].[ParametrosSistemaGrupos] PSG ON [PS].[IDGrupo] = [PSG].[IDGrupo]
							WHERE [PSG].[NombreGrupo] = @NombreGrupo
							AND [ParametroID] = @ParametroID
						END
					ELSE
						BEGIN
							SELECT @respuesta = 'Se ha actualizado el registro'
						END

					SELECT @estadoRespuesta = 2
	
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_UsuarioDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_UsuarioDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Update Author: Equipo de desarrollo OIM - Christian Ospina
-- Update date: 30/03/2017
-- Description:	Elimina un registro de Usuario. En caso de tener información relacionada, lo que 
--				hace es Inactivarlo.
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[D_UsuarioDelete]
	
	@Id INT

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
					DELETE [dbo].[Usuario] 
					WHERE [Id] = @Id

					SELECT @respuesta = 'Se ha eliminado el registro'
					SELECT @estadoRespuesta = 3
	
					COMMIT  TRANSACTION
				END TRY

				BEGIN CATCH
					ROLLBACK TRANSACTION
					SELECT @respuesta = ERROR_MESSAGE()
					SELECT @estadoRespuesta = 0
				END CATCH
			END
		
		--=============================================================================
		-- Quiere decir que no eliminó el usuario porque tiene información relacionada
		-- por lo tanto lo inhabilita.
		--=============================================================================
		IF(@estadoRespuesta = 0)
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY
					UPDATE [dbo].[Usuario] 
					SET [Activo] = 0, [IdEstado] = (SELECT 1 Id FROM [Estado] WHERE [Nombre] = 'Retiro')
					WHERE [Id] = @Id

					SELECT @respuesta = 'Se ha retirado el registro'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_CampanaEmail]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_CampanaEmail] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 24/02/2017
-- Description:	Selecciona la información de Campañas Email
-- =============================================
ALTER PROCEDURE [dbo].[C_CampanaEmail] 

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			 [C].[Id]
			,[Fecha]
			,[U].[UserName] Usuario
			,[Asunto]
			,[T].[Nombre] TipoUsuario
			,[Enviados]
			,[Total]
			,[Mensaje]			 
		FROM
			[dbo].[CampanaEmail] C
			INNER JOIN [dbo].[TipoUsuario] T ON [C].[IdTipoUsuario] = [T].[Id]
			INNER JOIN [dbo].[Usuario] U ON [C].[IdUsuario] = [U].[Id]
		ORDER BY
			[Fecha] DESC
		
	END
		
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosSistema]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosSistema] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-09																			 
-- Descripcion: Carga los datos de los parámetros del sistema						
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DatosSistema]

AS

SELECT 
	 [Id]
	,[FromEmail]
	,[SmtpHost]
	,[SmtpPort]
	,[SmtpEnableSsl]
	,[SmtpUsername]
	,[SmtpPassword]
	,[TextoBienvenida]
	,[FormatoFecha]
	,[PlantillaEmailPassword]
	,[UploadDirectory]
	,[PlantillaEmailConfirmacion]
	,[SaveMessageConfirmPopup]
FROM 
	[dbo].[Sistema]

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_CampanaEmailInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_CampanaEmailInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Description:	Inserta un registro en Campaña Email 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[I_CampanaEmailInsert] 
	
	 @IdUsuario		INT
	,@IdTipoUsuario	INT
	,@Asunto		VARCHAR(255)
	,@Mensaje		TEXT
	,@Fecha			DATETIME
	,@Total			INT
	,@Enviados		INT

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

					INSERT INTO [dbo].[CampanaEmail] ([IdUsuario], [IdTipoUsuario], [Asunto], [Mensaje], [Fecha], [Total], [Enviados])
					SELECT @IdUsuario, @IdTipoUsuario, @Asunto, @Mensaje, @Fecha, @Total, @Enviados

					SELECT @respuesta = 'Se ha insertado el registro'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_UsuarioInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_UsuarioInsert] AS'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Description:	Inserta un registro en Usuarios
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[I_UsuarioInsert] 
		
	 @IdDepartamento		INT
	,@IdMunicipio			INT
	,@IdEstado				INT
	,@Nombres				VARCHAR(255)
	,@Cargo					VARCHAR(255) 
	,@TelefonoFijo			VARCHAR(255) 
	,@TelefonoFijoIndicativo VARCHAR(255) 
	,@TelefonoFijoExtension	VARCHAR(255)  
	,@TelefonoCelular		VARCHAR(255) 
	,@Email					VARCHAR(255) 
	,@EmailAlternativo		VARCHAR(255) 
	,@Token					UNIQUEIDENTIFIER
	,@FechaSolicitud		DATETIME
	,@DocumentoSolicitud	VARCHAR(60)

AS
	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 1))
			BEGIN
				SET @esValido = 0
				SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail.'
			END

		IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 2))
			BEGIN
				SET @esValido = 0
				SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Confirmada por el Solicitante.'
			END

		IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 3))
			BEGIN
				SET @esValido = 0
				SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Confirmada por el Ministerio.'
			END

		IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 5))
			BEGIN
				SET @esValido = 0
				SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Aprobada por el Ministerio. Debe intentar la opción recuperar contraseña. De lo contrario comuniquese con el Administrador del Sistema.'
			END

		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY
					INSERT INTO [dbo].[Usuario] 
					(
						[IdDepartamento], [IdMunicipio], [IdEstado], [Nombres],
						[Cargo], [TelefonoFijo], [TelefonoFijoIndicativo], [TelefonoFijoExtension],
						[TelefonoCelular], [Email], [EmailAlternativo], [Token], [FechaSolicitud], [DocumentoSolicitud]
					)
					
					SELECT 
						@IdDepartamento, @IdMunicipio, @IdEstado, @Nombres, 
						@Cargo, @TelefonoFijo, @TelefonoFijoIndicativo,  @TelefonoFijoExtension, 
						@TelefonoCelular, @Email, @EmailAlternativo, @Token, @FechaSolicitud, @DocumentoSolicitud

					SELECT @respuesta = 'La solicitud fue creada satisfactoriamente, pronto recibirá una confirmación al correo electrónico'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PermisosRol]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PermisosRol] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-08																			 
-- Descripcion: Consulta la informacion de la rejilla de Gestionar Permisos de Usuario												
--****************************************************************************************************
ALTER PROC [dbo].[C_PermisosRol]

AS

	SELECT DISTINCT  
		 rR.IdRol
		,rR.IdRecurso
		,r.Nombre AS NombreRecurso
		,rR.IdSubRecurso 
		,sr.Nombre AS NombreSubRecurso	 
	FROM 
		[dbo].[RolRecurso] AS rR
		JOIN [dbo].[Recurso] AS r ON rR.IdRecurso = r.IdRecurso
		JOIN [dbo].[SubRecurso] AS sr ON rR.IdSubRecurso = sr.IdSubRecurso
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Split]') AND type in (N'P', N'PC', 'TF')) 
EXEC dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[Split] (@string NVARCHAR(MAX), @delimiter CHAR(1)) RETURNS @output TABLE(splitdata NVARCHAR(MAX)) BEGIN  RETURN END'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--====================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																			  
-- Fecha creacion: 2017-03-10																			  
-- Descripcion: Función Split que toma dos argumentos. El primero es el texto que se quiere partir y 
--				el segundo es el caracter que hace la separación de la cadena de texto					  
--==================================================================================================== 
ALTER FUNCTION [dbo].[Split] 
( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(splitdata NVARCHAR(MAX) 
) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 
    RETURN 
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_RolRecursoInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_RolRecursoInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 29/03/2017
-- Description:	Inserta los registro en la tabla RolRecurso
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[I_RolRecursoInsert] 
	
	@IdRol				VARCHAR(255), 
	@IdRecurso			INT,
	@ListaIdSubRecurso	VARCHAR(128)

AS
	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		IF(@esValido = 1) 
			BEGIN
				
				BEGIN TRY

					BEGIN TRANSACTION

						DECLARE @IdSubRecurso INT

						DECLARE SubRecursos_Cursor CURSOR FOR  

							SELECT 
								splitdata 
							FROM 
								[dbo].[Split](@ListaIdSubRecurso, ',')

						OPEN SubRecursos_Cursor 

						FETCH NEXT FROM SubRecursos_Cursor 
						INTO @IdSubRecurso 

						WHILE @@FETCH_STATUS = 0  
						   BEGIN  

								-- Valida que no exista la tupla que se quiere insertar
								IF (NOT EXISTS(SELECT * FROM [dbo].[RolRecurso] WHERE [IdRol] = @IdRol AND [IdRecurso] = @IdRecurso AND [IdSubRecurso] = @IdSubRecurso))
									BEGIN
										INSERT INTO [dbo].[RolRecurso]([IdRol],[IdRecurso],[IdSubRecurso])
										VALUES (@IdRol, @IdRecurso, @IdSubRecurso)
									END
								
								FETCH NEXT FROM SubRecursos_Cursor 
								INTO @IdSubRecurso 

						   END; 
					    
						CLOSE SubRecursos_Cursor;  
						DEALLOCATE SubRecursos_Cursor;  

						SELECT @respuesta = 'Se ha insertado el registro'
						SELECT @estadoRespuesta = 1
	
					COMMIT 

				END TRY

				BEGIN CATCH
					
					SELECT @respuesta = ERROR_MESSAGE()
					SELECT @estadoRespuesta = 0
					CLOSE SubRecursos_Cursor;  
					DEALLOCATE SubRecursos_Cursor;
					ROLLBACK

				END CATCH
			END

		SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

	END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_RolRecursoDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_RolRecursoDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Description:	Elimina un registro de Rol Recurso 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[D_RolRecursoDelete] 
	
	 @IdRol			VARCHAR(255)
	,@IdRecurso		INT
	,@IdSubRecurso	INT

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
					DELETE [dbo].[RolRecurso]
					WHERE [IdRol] = @IdRol
					AND [IdRecurso] = @IdRecurso
					AND [IdSubRecurso] = @IdSubRecurso

					SELECT @respuesta = 'Se ha eliminado el registro'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ExtensionesTiempo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ExtensionesTiempo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-08																			 
-- Descripcion: Consulta la informacion de la rejilla de Extensiones de tiempo concedidas												
-- ***************************************************************************************************
ALTER PROC [dbo].[C_ExtensionesTiempo]

AS

	SELECT 
		 x.FechaFin AS Fecha
		,x.Username AS Usuario
		,e.Titulo AS Encuesta
		,x.WhoAction AS WhoAction
		,x.WhenAction AS WhenAction
	FROM 
		[dbo].[PermisoUsuarioEncuesta] AS x
		INNER JOIN [dbo].[Encuesta] AS e ON x.Id_encuesta= e.Id
	ORDER BY  
		x.FechaFin DESC
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_PermisoUsuarioEncuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_PermisoUsuarioEncuestaInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 04/04/2017
-- Description:	Inserta un registro en la tabla Permiso Usuario Encuesta 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[I_PermisoUsuarioEncuestaInsert] 
	
	 @Username		VARCHAR(255)
	,@Id_Encuesta	INT
	,@FechaFin		DATETIME
	,@WhoAction		VARCHAR(255)
	,@WhenAction	DATETIME	

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

						INSERT INTO [dbo].[PermisoUsuarioEncuesta]([Username],[Id_Encuesta],[FechaFin],[WhoAction],[WhenAction])
						SELECT @Username, @Id_Encuesta, @FechaFin, @WhoAction, @WhenAction

						SELECT @respuesta = 'Se ha insertado el registro'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ParametrosSistema]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ParametrosSistema] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: Marzo  de 2017
-- Description:	Procedimieto que trae los datos de parámetros sistema
-- =====================================================================
ALTER PROCEDURE [dbo].[C_ParametrosSistema] 
	
	 @NombreGrupo VARCHAR(50) = NULL
	,@ParametroID VARCHAR(50) = NULL

AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		 [PS].[IDGrupo] 
		,[PS].[ParametroID]
		,[PS].[ParametroValor]
	FROM 
		[ParametrizacionSistema].[ParametrosSistema] PS
		INNER JOIN [ParametrizacionSistema].[ParametrosSistemaGrupos] PSG ON [PS].[IDGrupo] = [PSG].[IDGrupo]
	WHERE 
		(@NombreGrupo IS NULL OR [PSG].[NombreGrupo] = @NombreGrupo)
		AND (@ParametroID IS NULL OR [ParametroID] = @ParametroID)
END

