
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_ParametrosSistemaUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_ParametrosSistemaUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Description:	Actualiza la información de la tabla Parámetros Sistema
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[U_ParametrosSistemaUpdate] 
	
	 @IdGrupo				INT
	,@NombreParametro		VARCHAR(50) = NULL
	,@NombreParametroNuevo	VARCHAR(50) = NULL
	,@ParametroValor		VARCHAR(MAX) = NULL
	,@ParametroValorNuevo	VARCHAR(MAX) = NULL

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
						[ParametrizacionSistema].[ParametrosSistema] 
					SET 
						[NombreParametro] = ISNULL(@NombreParametroNuevo, [NombreParametro])
					   ,[ParametroValor] = ISNULL(@ParametroValorNuevo, [ParametroValor])						
					WHERE 
						(@NombreParametro IS NULL OR [NombreParametro] = @NombreParametro)
						AND [IdGrupo] = @IdGrupo
						AND (@ParametroValor IS NULL OR [ParametroValor] = @ParametroValor)
					
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObtenerRolesEncuestaString]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ObtenerRolesEncuestaString] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [Roles].[ObtenerRolesEncuestaString]
(
	@idEncuesta int
)

AS

BEGIN

	DECLARE @Roles VARCHAR(8000) 
	
	SELECT @Roles = COALESCE(@Roles + ', ', '') + [Name] 
	FROM [rusicst].[dbo].[AspNetRoles] a
	JOIN [rusicst].[Roles].[RolEncuesta] b on b.IdRol = a.Id
	WHERE b.IdEncuesta = @idEncuesta

	SELECT @Roles AS Roles

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestasXUsuarioCompletadas]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_EncuestasXUsuarioCompletadas] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 03/05/2017
-- Description:	Selecciona la información de encuesta completadas por usuario
-- ============================================================================
ALTER PROCEDURE [dbo].[C_EncuestasXUsuarioCompletadas]

	@IdTipoUsuario	INT,
	@IdUsuario		INT

AS

	BEGIN

		DECLARE @TabUsuarios TABLE
		(
			IdEncuesta	INT
		)
	
		INSERT INTO @TabUsuarios

		SELECT 
			 [RE].[IdEncuesta]
		FROM 
			[dbo].[AspNetUserRoles] R
			INNER JOIN [dbo].[AspNetUsers] AspU ON [R].[UserId] = [AspU].[Id]
			INNER JOIN [dbo].[Usuario] U ON [AspU].[Id] = [U].[IdUser]
			INNER JOIN [Roles].[RolEncuesta] RE on [RE].[IdRol] = [R].[RoleId]
		WHERE 
			[U].[Id] = @IdUsuario OR @IdTipoUsuario = (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE [Tipo] = 'ADMIN')
	
		SELECT 
			DISTINCT TOP 1000 [Id]
			,[Titulo]  
			,[FechaFin]
			,[Ayuda]
		FROM 
			[dbo].[Encuesta] a
			INNER JOIN @TabUsuarios b on [b].[IdEncuesta] = [a].[Id]
		WHERE 
			[a].[FechaFin] < GETDATE()
			AND NOT EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
							WHERE [p].[IdEncuesta] = [a].[Id] 
							AND [p].[IdUsuario] = @IdUsuario
							AND [p].[FechaFin] > GETDATE())  	
	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestasXUsuarioNoCompletadas]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_EncuestasXUsuarioNoCompletadas] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 03/05/2017
-- Description:	Selecciona la información de encuesta NO completadas por usuario
-- ============================================================================
ALTER PROCEDURE [dbo].[C_EncuestasXUsuarioNoCompletadas]
	
	@IdTipoUsuario	INT,
	@IdUsuario		INT

AS

	BEGIN

		DECLARE @TabUsuarios table
		(
			IdEncuesta	INT
		)
	
		INSERT INTO @TabUsuarios

		SELECT 
			 [RE].[IdEncuesta]
		FROM 
			[dbo].[AspNetUserRoles] R
			INNER JOIN [dbo].[AspNetUsers] AspU ON [R].[UserId] = [AspU].[Id]
			INNER JOIN [dbo].[Usuario] U ON [AspU].[Id] = [U].[IdUser]
			INNER JOIN [Roles].[RolEncuesta] RE on [RE].[IdRol] = [R].[RoleId]
		WHERE 
			[U].[Id] = @IdUsuario OR @IdTipoUsuario = (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE [Tipo] = 'ADMIN')
	
		SELECT 
			DISTINCT top 1000 [Id]
			,[Titulo]  
			,[FechaFin]
			,[Ayuda]
		FROM 
			[dbo].[Encuesta] a
			INNER JOIN @TabUsuarios b on [b].[IdEncuesta] = [a].[Id]
		WHERE 
			([a].[FechaInicio] < GETDATE() AND [a].[FechaFin] > GETDATE())
			OR EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = [a].[Id] 
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()) 	
	END
		
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
	,@FechaSolicitud		DATETIME = NULL
	,@FechaNoRepudio		DATETIME = NULL
	,@FechaTramite			DATETIME = NULL
	,@FechaRetiro			DATETIME = NULL
	,@FechaConfirmacion		DATETIME = NULL
	,@NombreGrupo			VARCHAR(50) = NULL
	,@NombreParametro		VARCHAR(50) = NULL

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
						 [IdUser] = CASE WHEN @FechaRetiro IS NOT NULL THEN NULL ELSE ISNULL(@IdUser, [IdUser]) END
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
						,[FechaRetiro] = ISNULL(@FechaRetiro, [FechaRetiro])
					WHERE 
						[Id] = @Id
					
					--===============================================================================
					-- Obtiene el mensaje que esta configurado en la tabla de parámetros del sistema
					--===============================================================================
					IF(@NombreGrupo IS NOT NULL AND @NombreParametro IS NOT NULL)
						BEGIN
							SELECT @respuesta = [PS].[ParametroValor]
							FROM [ParametrizacionSistema].[ParametrosSistema] PS
							INNER JOIN [ParametrizacionSistema].[ParametrosSistemaGrupos] PSG ON [PS].[IdGrupo] = [PSG].[Id]
							WHERE [PSG].[NombreGrupo] = @NombreGrupo
							AND [NombreParametro] = @NombreParametro
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
		
