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
						,[IdDepartamento] = ISNULL(@IdDepartamento, [IdDepartamento])
						,[IdMunicipio] = ISNULL(@IdMunicipio, [IdMunicipio])
						,[IdEstado] = ISNULL(@IdEstado, [IdEstado])
						 --=================================================================================
						 -- EL CASE ES UTILIZADO PARA VALIDAR SI LA ACTUALIZACION OBEDECE A UNA REVERSION. 
						 -- SE DEBE HACER SI AL MOMENTO DE REMITIR, EL CORREO NO ES ENVIADO AL DESTINATARIO
						 --=================================================================================
						,[IdUsuarioTramite] = CASE WHEN @IdEstado = 2 THEN NULL ELSE ISNULL(@IdUsuarioTramite, [IdUsuarioTramite]) END
						,[IdTipoUsuario] = CASE WHEN @IdEstado = 2 THEN NULL ELSE ISNULL(@IdTipoUsuario, [IdTipoUsuario]) END
						,[FechaTramite] = CASE WHEN @IdEstado = 2 THEN NULL ELSE ISNULL(@FechaTramite, [FechaTramite]) END
						--==================================================================================
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
		


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_UsuarioInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_UsuarioInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Description:	Inserta un registro en Usuarios, valida si la solicitud de usuario es para la misma ubicación
--				geográfica. De ser así, la rechaza, de lo contrario permite registrar la solicitud. 
--				Esto quiere decir que se podrán registrar varios usuarios con el mismo correo electrónico, 
--				siempre y cuando sean usuarios de diferentes ubicaciones geográficas.
--
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ===========================================================================================================
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

		IF(@IdMunicipio = 0)
			SET @IdMunicipio = NULL

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		--=======================================================================================================================================================================
		-- Ajuste realizado para controlar el registro de los usuarios tipo gobernación y tipo alcaldía. El tipo gobernación no va a seleccionar municipio y el tipo alcaldía sí
		--=======================================================================================================================================================================
		IF(@IdMunicipio IS NOT NULL)
			BEGIN
				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 1 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] = @IdMunicipio))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail.'
					END

				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 2 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] = @IdMunicipio))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Confirmada por el Solicitante.'
					END

				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 3 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] = @IdMunicipio))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Confirmada por el Ministerio.'
					END

				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 5 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] = @IdMunicipio))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Aprobada por el Ministerio. Debe intentar la opción recuperar contraseña. De lo contrario comuniquese con el Administrador del Sistema.'
					END
				END
		ELSE 
			BEGIN
				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 1 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] IS NULL))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail.'
					END

				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 2 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] IS NULL))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Confirmada por el Solicitante.'
					END

				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 3 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] IS NULL))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Confirmada por el Ministerio.'
					END

				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 5 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] IS NULL))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Aprobada por el Ministerio. Debe intentar la opción recuperar contraseña. De lo contrario comuniquese con el Administrador del Sistema.'
					END
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

					SELECT @respuesta += 'La solicitud fue creada satisfactoriamente, pronto recibirá una confirmación al correo electrónico'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PermisosUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PermisosUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Equipo de desarrollo de la OIM																			 
-- Fecha creacion: 2017-02-08																			 
-- Descripcion: Consulta la información de la rejilla de Gestionar Permisos de Usuario												
--****************************************************************************************************
ALTER PROC [dbo].[C_PermisosUsuario]

	@IdTipoUsuario INT = NULL

AS

	BEGIN

	SET NOCOUNT ON;

		SELECT DISTINCT  
			 [TU].[Id] IdTipoUsuario
			,[TU].[Nombre] IdRol
			,[TUR].[IdRecurso]
			,[R].[Nombre] AS NombreRecurso
			,[TUR].[IdSubRecurso] 
			,[SR].[Nombre] AS NombreSubRecurso	 
		FROM 
			[dbo].[TipoUsuarioRecurso] AS TUR
			INNER JOIN [dbo].[Recurso] AS R ON [TUR].[IdRecurso] = [R].[Id]
			INNER JOIN [dbo].[SubRecurso] AS SR ON [TUR].[IdSubRecurso] = [SR].[Id]
			INNER JOIN [dbo].[TipoUsuario] AS TU ON [TUR].[IdTipoUsuario] = [TU].[Id]
		WHERE
			@IdTipoUsuario IS NULL OR ([TU].[Id] = @IdTipoUsuario)

	END

GO
--==============================================================================================================
-- script que actualiza los datos para la funcionalidad de los permisos colocando el Id identificador IdRecurso
--==============================================================================================================
IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE COLUMN_NAME = 'IdRecurso' AND TABLE_NAME = 'SubRecurso')
BEGIN
	ALTER TABLE [dbo].[SubRecurso] ADD IdRecurso INT NULL
END
GO

UPDATE [dbo].[SubRecurso] SET [IdRecurso] = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Usuarios') 
WHERE [Nombre] IN (	'Administrar tipos de usuario', 'Administrar usuarios', 'Email masivo', 'Gestión de Solicitudes Usuario', 
					'Gestionar Permisos de Usuario', 'Habilitar Reportes a Usuarios')
AND [IdRecurso] IS NULL

UPDATE [dbo].[SubRecurso] SET [IdRecurso] = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Sistema')  
WHERE [Nombre] IN ( 'Bitácora del Sistema', 'Configuración Archivos Ayuda', 'Configuración del Home', 'Configuración del Sistema', 
					'Gestión de Auditoría y Eventos', 'Gestión de Errores Aplicación', 'Gestión de Planes de Mejoramiento', 
					'Parámetros del sistema')
AND [IdRecurso] IS NULL

UPDATE [dbo].[SubRecurso] SET [IdRecurso] = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Reportes')  
WHERE [Nombre] IN (	'Administrar glosario', 'Consulta Reportes Entidades Territoriales', 'Diseño de reportes', 'Modificar Preguntas', 
					'Completar/Consultar Reportes', 'Revisar Respuestas Alcaldias Gobernación')
AND [IdRecurso] IS NULL

UPDATE [dbo].[SubRecurso] SET [IdRecurso] = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Informes')  
WHERE [Nombre] IN (	'Consolidado del Diligenciamiento del RUSICST', 'Informe de Auto Evaluación', 'Informe de respuestas', 
					'Opciones Menú', 'Opciones Por Rol', 'Salida de Información de Gobernaciones', 'Salida de Información Municipal', 
					'Usuarios del Sistema', 'Usuarios Guardaron Información en el Sistema', 'Usuarios Que Enviaron el Reporte',
					'Usuarios que Guardaron Información de Auto-Evaluación', 'Usuarios que Pasaron a Auto-evaluación')
AND [IdRecurso] IS NULL

UPDATE [dbo].[SubRecurso] SET [IdRecurso] = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'ACCESO BI')  
WHERE [Nombre] IN ('Analísis Geógrafico', 'Análisis Predefinidos', 'Analísis')
AND [IdRecurso] IS NULL


-- ACTUALIZA "Actualizar Datos de Contacto Usuario" RELACIONANDOLO CON EL MENU DE INICIO
UPDATE [dbo].[SubRecurso] SET [IdRecurso] = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Inicio')  
WHERE [Nombre] IN ('Actualizar Datos de Contacto Usuario')
AND [IdRecurso] IS NULL

-- ACTUALIZA EL NOMBRE "Completar/Consultar Reportes"
UPDATE [dbo].[SubRecurso] SET [Nombre] = 'Completar/Consultar Reportes' WHERE Id = 8 

-- ACTUALIZA EL NOMBRE "Informe de Respuestas"
UPDATE [dbo].[SubRecurso] SET [Nombre] = 'Informe de Respuestas' WHERE Id = 9 

-- ACTUALIZA EL ITEM "Completar/Consultar Reportes" Y LO REDIRECCIONA PARA LAS ALCALDIAS
UPDATE [dbo].[SubRecurso] SET [IdRecurso] = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Seguimiento Alcaldías')
WHERE [Nombre] = 'Completar/Consultar Reportes' AND Id = 15 

GO
--=======================================================================
-- INSERTA EL ITEM "Completar/Consultar Reportes" PARA LAS GOBERNACIONES
--=======================================================================
DECLARE @Id INT

IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Completar/Consultar Reportes' AND IdRecurso = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Seguimiento Gobernaciones'))
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Completar/Consultar Reportes', '', (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Seguimiento Gobernaciones'))
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

--============================================================
-- INSERTA EL ITEM "Informe de Respuestas" PARA LAS ALCALDIAS
--============================================================
IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Informe de Respuestas' AND IdRecurso = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Seguimiento Alcaldías'))
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Informe de Respuestas', '', (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Seguimiento Alcaldías'))
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

--================================================================
-- INSERTA EL ITEM "Informe de Respuestas" PARA LAS GOBERNACIONES
--================================================================
IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Informe de Respuestas' AND IdRecurso = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Seguimiento Gobernaciones'))
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Informe de Respuestas', '', (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Seguimiento Gobernaciones'))
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

--===========================================================================================
-- INSERTA EL ITEM "Informe de Respuestas" PARA LAS ENTIDADES DE CONTROL EN EL MENU REPORTES
--===========================================================================================
IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Informe de Respuestas' AND IdRecurso = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Reportes'))
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Informe de Respuestas', '', (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Reportes'))
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

--=====================================================================================================
-- INSERTA EL ITEM "Revisar Respuestas Alcaldias Gobernación" PARA EL SEGUIMIENTO DE LAS GOBERNACIONES
--=====================================================================================================
IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Revisar Respuestas Alcaldias Gobernación' AND IdRecurso = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Seguimiento Gobernaciones'))
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Revisar Respuestas Alcaldias Gobernación', '', (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Seguimiento Gobernaciones'))
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

--============================================================
-- INSERTA EL ITEM "Informe de Auto Evaluación" PARA REPORTES
--============================================================
IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Informe de Auto Evaluación' AND IdRecurso = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Reportes'))
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Informe de Auto Evaluación', '', (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Reportes'))
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

GO

--=================================
-- ADICIONA EL MENU DE TABLERO PAT
--=================================
IF NOT EXISTS (SELECT * FROM [dbo].[Recurso] WHERE Nombre = 'Tablero PAT')
BEGIN
	SET IDENTITY_INSERT [dbo].[Recurso] ON
	INSERT INTO [dbo].[Recurso] ([Id], [Nombre], [Url]) VALUES (14, 'Tablero PAT', '')
	SET IDENTITY_INSERT [dbo].[Recurso] OFF
END
GO

--===================================
-- INSERTA LOS ITEM PARA TABLERO PAT
--===================================
DECLARE @Id INT, @IdRecurso INT
SET @IdRecurso = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Tablero PAT')

IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Gestión Departamental' AND IdRecurso = @IdRecurso )
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Gestión Departamental', '', @IdRecurso)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Gestión Departamental Gestión Colectiva' AND IdRecurso = @IdRecurso )
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Gestión Departamental Gestión Colectiva', '', @IdRecurso)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Gestión Departamental Retornos y Reubicaciones' AND IdRecurso = @IdRecurso )
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Gestión Departamental Retornos y Reubicaciones', '', @IdRecurso)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Gestión Municipal' AND IdRecurso = @IdRecurso )
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Gestión Municipal', '', @IdRecurso)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Consultas Tablero PAT' AND IdRecurso = @IdRecurso )
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Consultas Tablero PAT', '', @IdRecurso)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Preguntas Tablero PAT' AND IdRecurso = @IdRecurso )
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Preguntas Tablero PAT', '', @IdRecurso)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

GO

DECLARE @Id INT, @IdRecurso INT
SET @IdRecurso = (SELECT Id FROM [dbo].[Recurso] WHERE [Nombre] = 'Ayuda')

IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Acceder a archivos de Ayuda' AND IdRecurso = @IdRecurso )
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON
	SELECT @Id = (MAX(Id) + 1) FROM SubRecurso
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso])
	VALUES (@Id, 'Acceder a archivos de Ayuda', '', @IdRecurso)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

GO

UPDATE [dbo].[SubRecurso] SET [IdRecurso] = 2 WHERE [Nombre] = 'Clasificadores' AND [IdRecurso] IS NULL
UPDATE [dbo].[SubRecurso] SET [IdRecurso] = 3 WHERE [Nombre] = 'Diligenciar Plan de Mejoramiento' AND [IdRecurso] IS NULL
UPDATE [dbo].[SubRecurso] SET [IdRecurso] = 2 WHERE [Nombre] = 'Gestión de Roles' AND [IdRecurso] IS NULL
UPDATE [dbo].[SubRecurso] SET [IdRecurso] = 3 WHERE [Nombre] = 'Gestión del Banco de Preguntas' AND [IdRecurso] IS NULL
UPDATE [dbo].[SubRecurso] SET [IdRecurso] = 10 WHERE [Nombre] = 'Preguntas Tipo Parrafo' AND [IdRecurso] IS NULL
UPDATE [dbo].[SubRecurso] SET [IdRecurso] = 2 WHERE [Nombre] = 'Resultados anteriores' AND [IdRecurso] IS NULL
UPDATE [dbo].[SubRecurso] SET [IdRecurso] = 3 WHERE [Nombre] = 'Tipos de Recurso' AND [IdRecurso] IS NULL
UPDATE [dbo].[SubRecurso] SET [IdRecurso] = 2 WHERE [Nombre] = 'Generar y Enviar Usuarios y Contraseñas' AND [IdRecurso] IS NULL

GO

--============================================================
-- RETIRA LAS URL DE LOS SUBRECURSO PORQUE YA NO CORRESPONDEN
--============================================================
UPDATE [dbo].[SubRecurso] SET Url = NULL 

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaSubRecurso]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaSubRecurso] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 30/03/2017
-- Description:	Selecciona la información de SubRecursos que en
--				en la práctica son los sub-menus
-- ===========================================================
ALTER PROCEDURE [dbo].[C_ListaSubRecurso]

	@IdRecurso INT = NULL

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT
			 [Id]
			,[Nombre]
			,[Url]
		FROM
			[dbo].[SubRecurso]
		WHERE 
			@IdRecurso IS NULL OR [IdRecurso] = @IdRecurso
		
	END

GO

	

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_SeccionDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'drop PROCEDURE [dbo].[D_SeccionDelete]'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*****************************************************************************************************
-- Autor: John Betancourt A. OIM																		  
-- Fecha creacion: 2017-06-27
-- Descripcion: Actualiza la información de la Seccion												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--*****************************************************************************************************

CREATE PROC [dbo].[D_SeccionDelete] 

	@Id INT

AS 

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0 
	DECLARE @esValido AS BIT = 1
	
	IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @Id))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'Se Encontro al menos una respuesta a las preguntas de la sección.'
	END
	ELSE
	BEGIN
		EXEC D_ContenidoSeccionDelete @Id
	END

	IF(@esValido = 1) BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [dbo].Seccion
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

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestaSeccionesSubseccionesDraw]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_EncuestaSeccionesSubseccionesDraw] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Rafael Alba																	 
-- Fecha creacion: 2017-06-16																			 
-- Descripcion: Trae el listado de secciones Y subsecciones de una encuesta para ser pintado									
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_EncuestaSeccionesSubseccionesDraw]
	 @IdEncuesta	INT
AS
	SELECT 
		  [Id]
		 ,[Titulo]
		 ,[SuperSeccion]
		 ,[OcultaTitulo]
		 ,[Estilos]
	FROM 
		[dbo].[Seccion] AS s
	WHERE 
		s.IdEncuesta = @IdEncuesta 
	ORDER BY 
		[SuperSeccion], Titulo

GO

--=======================================
-- TRASLADO DEL MENU GLOSARIO A SISTEMA
--=======================================
UPDATE [dbo].[TipoUsuarioRecurso] SET [IdRecurso] = 3 WHERE [IdTipoUsuario] = 1 AND [IdSubRecurso] = 11