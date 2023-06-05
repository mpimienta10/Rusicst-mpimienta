
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Roles_RolEncuestaXEncuesta]') AND type in (N'P', N'PC')) 
DROP PROCEDURE [dbo].[C_Roles_RolEncuestaXEncuesta]

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_RolXEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_RolXEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 14/06/2017
-- Description:	Obtiene los roles de la encuesta permitidos por encuesta
-- =============================================
ALTER PROCEDURE [dbo].[C_RolXEncuesta] 

	@IdEncuesta	 INT

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			A.Id, A.Name
		FROM Roles.RolEncuesta R
		INNER JOIN AspNetRoles A ON A.Id = R.IdRol

		WHERE
			IdEncuesta = @IdEncuesta

	END	

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_RolRecursoInsert]') AND type in (N'P', N'PC')) 
DROP PROCEDURE [dbo].[I_RolRecursoInsert]

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_TipoUsuarioRecursoInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_TipoUsuarioRecursoInsert] AS'

GO

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
ALTER PROCEDURE [dbo].[I_TipoUsuarioRecursoInsert] 
	
	@IdTipoUsuario		INT, 
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
								IF (NOT EXISTS(SELECT * FROM [dbo].[TipoUsuarioRecurso] WHERE [IdTipoUsuario] = @IdTipoUsuario AND [IdRecurso] = @IdRecurso AND [IdSubRecurso] = @IdSubRecurso))
									BEGIN
										INSERT INTO [dbo].[TipoUsuarioRecurso]([IdTipoUsuario],[IdRecurso],[IdSubRecurso])
										VALUES (@IdTipoUsuario, @IdRecurso, @IdSubRecurso)
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_RolRecursoDelete]') AND type in (N'P', N'PC')) 
DROP PROCEDURE [dbo].[D_RolRecursoDelete]

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_TipoUsuarioRecursoDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_TipoUsuarioRecursoDelete] AS'

GO

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
ALTER PROCEDURE [dbo].[D_TipoUsuarioRecursoDelete] 
	
	 @IdTipoUsuario	INT
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
					DELETE [dbo].[TipoUsuarioRecurso]
					WHERE [IdTipoUsuario] = @IdTipoUsuario
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
			 TU.Id IdTipoUsuario
			,TU.Nombre IdRol
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

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_SeccionInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_SeccionInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 14/06/2017
-- Description:	Obtiene los roles de la encuesta permitidos por encuesta
-- =============================================
ALTER PROC [dbo].[I_SeccionInsert] 

	@IdEncuesta					INT,
	@Titulo						VARCHAR(MAX),
	@Ayuda						VARCHAR(MAX) = NULL,
	@SuperSeccion				INT = NULL,
	@Eliminado					BIT = 0,
	@Archivo					IMAGE = NULL,
	@OcultaTitulo				BIT = 0,
	@Estilos					VARCHAR(MAX) = NULL
AS 

	BEGIN
		-- Parámetros para el manejo de la respuesta
		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0
		DECLARE @esValido AS BIT = 1

		--Preguntar si una seccion puede repetir el nombre
		IF(@esValido = 1) 
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY
				-- Inserta la seccion
				INSERT INTO [dbo].[Seccion] 
					([IdEncuesta],[Titulo],[Ayuda],[SuperSeccion],[Eliminado],[Archivo],[OcultaTitulo],[Estilos])
				SELECT 
					@IdEncuesta, @Titulo, @Ayuda, @SuperSeccion, @Eliminado, @Archivo, @OcultaTitulo, @Estilos	


			SELECT @respuesta = 'Se ha insertado el registro'
			SELECT @estadoRespuesta = @@IDENTITY
	
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
--				de filtro. Retira los usuarios que se encuentran retirados y rechazados																 
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
	BEGIN
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
			AND ([U].[IdEstado] <> 4)

		ORDER BY 
			U.Nombres 
	END


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosEnSistema]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosEnSistema] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Robinson Moscoso
-- Create date:	31/01/2017
-- Description:	Procedimiento que retorna la información de todos los usuario en el sistema
-- =============================================
ALTER PROCEDURE [dbo].[C_UsuariosEnSistema] 

AS
	BEGIN
		
		SELECT
			 [c].[Nombre] AS Departamento
			,[b].[Nombre] AS Municipio
			,[a].[Username] AS NombreDeUsuario
			,[a].[UserName] Nombre 
			,[a].[Email]
			,[a].[TelefonoCelular]
			,[d].[Nombre] TipoUsuario
			,[a].[Activo]
		FROM
			[dbo].[Usuario] a
			INNER JOIN [dbo].[TipoUsuario] d ON [a].[IdTipoUsuario] = [d].[Id]
			LEFT OUTER JOIN [dbo].[Municipio] b ON [a].[IdMunicipio] = [b].[Id] 
			LEFT OUTER JOIN [dbo].[Departamento] c ON [a].[IdDepartamento] = [c].[Id]
		WHERE 
			([a].[IdEstado] <> 6)
			AND ([a].[IdEstado] <> 4)
		ORDER BY 
			 [Departamento]
			,[Municipio]
			,[a].[Username]
	
	END
		
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_OpcionesMenu]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_OpcionesMenu] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================================================
-- Author:		ROBINSON MOSCOSO
-- Create date:	31/01/2017
-- Description:	Se modifica OpcionesMenu para darle nombre a los campos resultantes 
--				Procedimiento que retorna la información de todas las opciones de Menus
-- =====================================================================================
ALTER PROCEDURE [dbo].[C_OpcionesMenu]  

AS

BEGIN

	SELECT 
		 DISTINCT 
		 [R].[Nombre] AS Menu
		,[SR].[Nombre] AS SubMenu
		,[SR].[Url] AS Url
	FROM
		[dbo].[Recurso] R 
		INNER JOIN [dbo].[TipoUsuarioRecurso] TUR ON [R].[Id] = [TUR].[IdRecurso] 
		INNER JOIN [dbo].[SubRecurso] SR ON [TUR].[IdSubRecurso] = [SR].[Id]
	ORDER BY 
		 [Menu], [SubMenu] 	

END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_OpcionesRol]') AND type in (N'P', N'PC')) 
DROP PROCEDURE [dbo].[C_OpcionesRol]

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_OpcionesTipoUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_OpcionesTipoUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Robinson Moscoso
-- Create date:	10/12/2014
-- Description:	Procedimiento que retorna la información de todas las opciones por Rol
-- =============================================
ALTER PROCEDURE [dbo].[C_OpcionesTipoUsuario] 

AS
	BEGIN

		SELECT DISTINCT
			 [T].[Nombre] AS TipoUsuario
			,[R].[Nombre] AS Menu
			,[SR].[Nombre] AS SubMenu
			,[SR].[Url] AS Url
		FROM
			[dbo].[Recurso] R 
			INNER JOIN [dbo].[TipoUsuarioRecurso] TUR ON [R].[Id] = [TUR].[IdRecurso] 
			INNER JOIN [dbo].[SubRecurso] SR ON [TUR].[IdSubRecurso] = [SR].[Id]
			INNER JOIN [dbo].[TipoUsuario] T ON [TUR].[IdTipoUsuario] = [T].[Id]
		ORDER BY 
			 [TipoUsuario]
			,[Menu]
			,[SubMenu]
	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_ContenidoSeccionDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_ContenidoSeccionDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================
-- Author:		Equipo de desarrollo - OIM
-- Create date:	17/06/2017
-- Description:	Procedimiento que elimina las secciones en cascada
-- Modificacion: John Betancourt Devolver el valor de los parametros
-- =================================================================
ALTER PROC [dbo].[D_ContenidoSeccionDelete]
(
	@IdSeccion INT
)

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
					IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion))
					BEGIN
						DELETE FROM [dbo].[Respuesta]
						WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion)
					END
	
					IF EXISTS(SELECT 1 FROM [BancoPreguntas].[PreguntaModeloAnterior] WHERE IdPreguntaAnterior IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion))
					BEGIN
						DELETE FROM [BancoPreguntas].[PreguntaModeloAnterior]
						WHERE [IdPreguntaAnterior] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion)
					END
	
					IF EXISTS(SELECT 1 FROM [dbo].[Opciones] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion))
					BEGIN
						DELETE FROM [dbo].[Opciones]
						WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion)
					END
	
					DELETE FROM [dbo].[Diseno]
					WHERE [IdSeccion] = @IdSeccion
	
					DELETE FROM [dbo].[Pregunta]
					WHERE [IdSeccion] = @IdSeccion

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntaXCodigo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PreguntaXCodigo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 17/06/2017
-- Description:	Selecciona la pregunta por código de pregunta
-- ============================================================
ALTER PROCEDURE [dbo].[C_PreguntaXCodigo] 

	@CodigoPregunta	 VARCHAR(8)

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			 [IdPregunta]
			,[CodigoPregunta]
			,[NombrePregunta]
			,[IdTipoPregunta]
		FROM [BancoPreguntas].[Preguntas]
		WHERE [CodigoPregunta] =  @CodigoPregunta

	END	

	