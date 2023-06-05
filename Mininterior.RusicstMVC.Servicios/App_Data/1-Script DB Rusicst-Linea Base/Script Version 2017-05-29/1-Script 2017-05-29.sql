GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PermisosRol]') AND type in (N'P', N'PC')) 
DROP PROCEDURE [dbo].[C_PermisosRol]

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PermisosUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PermisosUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-08																			 
-- Descripcion: Consulta la informacion de la rejilla de Gestionar Permisos de Usuario												
--****************************************************************************************************
ALTER PROC [dbo].[C_PermisosUsuario]

	@IdTipoUsuario INT = NULL

AS

	BEGIN

	SET NOCOUNT ON;

		SELECT DISTINCT  
			 TU.Nombre 'Tipo Usuario'
			,TUR.IdRecurso
			,R.Nombre AS 'Menú'
			,TUR.IdSubRecurso 
			,SR.Nombre AS 'Opción de Menú'	 
		FROM 
			[dbo].[TipoUsuarioRecurso] AS TUR
			INNER JOIN [dbo].[Recurso] AS R ON TUR.IdRecurso = R.Id
			INNER JOIN [dbo].[SubRecurso] AS SR ON TUR.IdSubRecurso = SR.Id
			INNER JOIN [dbo].[TipoUsuario] AS TU ON TUR.IdTipoUsuario = TU.Id
		WHERE
			@IdTipoUsuario IS NULL OR (TU.Id = @IdTipoUsuario)

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
	,@NombreParametro VARCHAR(50) = NULL

AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		 [PS].[IdGrupo] 
		,[PS].[NombreParametro]
		,[PS].[ParametroValor]
	FROM 
		[ParametrizacionSistema].[ParametrosSistema] PS
		INNER JOIN [ParametrizacionSistema].[ParametrosSistemaGrupos] PSG ON [PS].[IdGrupo] = [PSG].[Id]
	WHERE 
		(@NombreGrupo IS NULL OR [PSG].[NombreGrupo] = @NombreGrupo)
		AND (@NombreParametro IS NULL OR [NombreParametro] = @NombreParametro)
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Equipo de desarrollo OIM - Christian Ospina																		 
-- Fecha creacion: 2017-01-25																			 
-- Descripcion: Consulta la informacion de las encuestas para ser utilizada en combos de encuestas												
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--****************************************************************************************************
ALTER PROC [dbo].[C_ListaEncuesta]

	@IdTipoEncuesta INT = NULL

AS
	SELECT 
		 [Id]
		,UPPER([Titulo]) Titulo
	FROM 
		[Encuesta]
	WHERE
		[IsDeleted] = 'false'
		AND (@IdTipoEncuesta IS NULL  OR [IdTipoEncuesta] = @IdTipoEncuesta)
	ORDER BY 
		[Titulo]		

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_ParametrosSistemaDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_ParametrosSistemaDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--====================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																			  
-- Fecha creacion: 2017-03-08																			  
-- Descripcion: elimina un registro de la tabla de Parámetros Sistema
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--====================================================================================================
ALTER PROCEDURE [dbo].[D_ParametrosSistemaDelete] 

	@IdGrupo		 INT,
	@NombreParametro VARCHAR(50)

AS 
	
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF(@esValido = 1) 
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY
				DELETE FROM [ParametrizacionSistema].[ParametrosSistema]
					WHERE [IdGrupo] = @IdGrupo
					AND [NombreParametro] = @NombreParametro		
		
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


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_ParametrosSistemaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_ParametrosSistemaInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																		 
-- Fecha creacion: 2017-03-08																		 
-- Descripcion: Inserta los datos en la tabla Parámetros Sistema
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--=================================================================================================
 ALTER PROCEDURE [dbo].[I_ParametrosSistemaInsert] 

	@IdGrupo			INT,
	@NombreParametro	VARCHAR(50),
	@ParametroValor		VARCHAR(MAX)

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
					
					INSERT INTO [ParametrizacionSistema].[ParametrosSistema] ([IdGrupo], [NombreParametro], [ParametroValor])
					SELECT @IdGrupo, @NombreParametro, @ParametroValor
					
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
						(@NombreParametroNuevo IS NULL OR [NombreParametro] = @NombreParametroNuevo)
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
		
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PermisosUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PermisosUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-08																			 
-- Descripcion: Consulta la informacion de la rejilla de Gestionar Permisos de Usuario												
--****************************************************************************************************
ALTER PROC [dbo].[C_PermisosUsuario]

	@IdTipoUsuario INT = NULL

AS

	BEGIN

	SET NOCOUNT ON;

		SELECT DISTINCT  
			 TU.Nombre IdRol
			,TUR.IdRecurso
			,R.Nombre AS NombreRecurso
			,TUR.IdSubRecurso 
			,SR.Nombre AS NombreSubRecurso	 
		FROM 
			[dbo].[TipoUsuarioRecurso] AS TUR
			INNER JOIN [dbo].[Recurso] AS R ON TUR.IdRecurso = R.Id
			INNER JOIN [dbo].[SubRecurso] AS SR ON TUR.IdSubRecurso = SR.Id
			INNER JOIN [dbo].[TipoUsuario] AS TU ON TUR.IdTipoUsuario = TU.Id
		WHERE
			@IdTipoUsuario IS NULL OR (TU.Id = @IdTipoUsuario)

	END

