GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaMunicipiosXUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaMunicipiosXUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-08																			 
-- Descripcion: Carga el listado de municipios ligados al departamento de un usuario								
--******************************************************************************************************/
ALTER PROCEDURE [dbo].[C_ListaMunicipiosXUsuario]

	@IdUsuario		INT,
	@IdTipoUsuario	INT

AS

	SELECT 
		 m.Id
		,m.[Nombre] 
	FROM 
		[dbo].[Usuario] AS u
		INNER JOIN [dbo].[Departamento] AS d ON u.[IdDepartamento]= d.Id
		INNER JOIN [dbo].[Municipio] AS m ON d.Id = m.[IdDepartamento] 
	WHERE 
		u.[IdTipoUsuario] = @IdTipoUsuario 
		AND u.[Id] = @IdUsuario
	ORDER 
		BY m.[Nombre]	

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

	@IdGrupo		INT,
	@ParametroID	VARCHAR(50),
	@ParametroValor	VARCHAR(MAX)

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
					
					INSERT INTO [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor])
					SELECT @IdGrupo, @ParametroID, @ParametroValor
					
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
	
	 @IdGrupo			  INT
	,@ParametroID		  VARCHAR(50) = NULL
	,@ParametroIDNuevo	  VARCHAR(50) = NULL
	,@ParametroValor	  VARCHAR(MAX) = NULL
	,@ParametroValorNuevo VARCHAR(MAX) = NULL

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
						[ParametroID] = ISNULL(@ParametroIDNuevo, [ParametroID])
					   ,[ParametroValor] = ISNULL(@ParametroValorNuevo, [ParametroValor])						
					WHERE 
						(@ParametroID IS NULL OR [ParametroID] = @ParametroID)
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

	@IdGrupo	 INT,
	@ParametroID VARCHAR(50)

AS 
	
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF(@esValido = 1) 
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY
				DELETE FROM [ParametrizacionSistema].[ParametrosSistema]
					WHERE [IDGrupo] = @IdGrupo
					AND [ParametroID] = @ParametroID		
		
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_SistemaUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_SistemaUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 13/03/2017
-- Description:	Actualiza un registro en la tabla SISTEMA 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 2 actualizado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[U_SistemaUpdate] 
	
	 @Id							INT
	,@FromEmail						VARCHAR(255)
	,@SmtpHost						VARCHAR(255)
	,@SmtpPort						INT
	,@SmtpEnableSsl					BIT
	,@SmtpUsername					VARCHAR(255)
	,@SmtpPassword					VARCHAR(255)
	,@TextoBienvenida				VARCHAR(MAX)
	,@FormatoFecha					VARCHAR(255)
	,@PlantillaEmailPassword		VARCHAR(MAX)
	,@UploadDirectory				VARCHAR(1000)
	,@PlantillaEmailConfirmacion	VARCHAR(MAX)
	,@SaveMessageConfirmPopup		VARCHAR(255)
	

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
						[dbo].[Sistema]
					SET 
						[FromEmail] = @FromEmail, [SmtpHost] = @SmtpHost, [SmtpPort] = @SmtpPort, [SmtpEnableSsl] = @SmtpEnableSsl, 
						[SmtpUsername] = @SmtpUsername, [SmtpPassword] = @SmtpPassword, [TextoBienvenida] = @TextoBienvenida, 
						[FormatoFecha] = @FormatoFecha, [PlantillaEmailPassword] = @PlantillaEmailPassword, [UploadDirectory] = @UploadDirectory, 
						[PlantillaEmailConfirmacion] = @PlantillaEmailConfirmacion, [SaveMessageConfirmPopup] = @SaveMessageConfirmPopup
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



