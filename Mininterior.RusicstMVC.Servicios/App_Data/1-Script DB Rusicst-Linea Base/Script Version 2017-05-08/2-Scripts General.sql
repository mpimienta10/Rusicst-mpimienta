GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_GlosarioUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_GlosarioUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*****************************************************************************************************
-- Autor: Robinson Moscoso																			  
-- Fecha creacion: 2017-01-25																			  
-- Descripcion: Actualiza la información del glosario												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [dbo].[U_GlosarioUpdate] 

	@Clave VARCHAR(511),
	@Termino VARCHAR(511),
	@Descripcion VARCHAR(MAX)

AS 
	
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (EXISTS(SELECT * FROM Glosario WHERE Termino  = @Termino and Clave <> @Clave))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El término ya se encuentra asignado a otra definición.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE [dbo].[Glosario]
				SET    [Termino] = @Termino, [Descripcion] = @Descripcion
				WHERE  [Clave] = @Clave		
		
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

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_GlosarioInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_GlosarioInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*****************************************************************************************************
-- Autor: Robinson Moscoso																			  
-- Fecha creacion: 2017-01-25																			  
-- Descripcion: Inserta la información del glosario												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [dbo].[I_GlosarioInsert] 

	@Clave VARCHAR(511),
	@Termino VARCHAR(511),
	@Descripcion VARCHAR(MAX)

AS 

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (EXISTS(SELECT * FROM Glosario WHERE Clave  = @Clave))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'La clave del término ya se encuentra asignado a otra definición.'
	END

	IF (EXISTS(SELECT * FROM Glosario WHERE Termino  = @Termino))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El término ya se encuentra asignado a otra definición.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO [dbo].[Glosario] ([Clave], [Termino], [Descripcion])
			SELECT @Clave, @Termino, @Descripcion	
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

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_GlosarioDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_GlosarioDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*****************************************************************************************************
-- Autor: Robinson Moscoso																			  
-- Fecha creacion: 2017-01-25																			  
-- Descripcion: Elimina la información del glosario												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [dbo].[D_GlosarioDelete] 

	@Clave VARCHAR(511)

AS 
	
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [dbo].[Glosario]
				WHERE  [Clave] = @Clave		
		
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestaGrid]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_EncuestaGrid] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																			 
-- Fecha creacion: 2017-02-24																			 
-- Descripcion: Carga las encuestas que NO han sido borradas									
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_EncuestaGrid]

AS

	SELECT 
		 [Id]
		,[Titulo]
		,[FechaInicio]
		,[FechaFin]
		,[Ayuda]
	FROM 
		[Encuesta] 
	WHERE 
		[isDeleted] = 0

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_EncuestaDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_EncuestaDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*****************************************************************************************************
-- Autor: Robinson Moscoso																			  
-- Fecha creacion: 2017-01-25																			  
-- Descripcion: Actualiza la información de la encueta												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--*****************************************************************************************************

ALTER PROC [dbo].[D_EncuestaDelete] 

	@Id INT

AS 

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0 
	DECLARE @esValido AS BIT = 1
	
	IF ((SELECT TOP 1 IsDeleted FROM encuesta WHERE id  = @Id)='true')
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'La encuesta ya se encuentra deshabilitada'
	END

	IF(@esValido = 1) BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE  Encuesta
			SET  [IsDeleted] = 'true'
			WHERE  [Id] = @Id

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_SeccionEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_SeccionEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																	 
-- Fecha creacion: 2017-03-13																			 
-- Descripcion: Trae el listado de secciones de una encuesta									
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_SeccionEncuesta]

	 @IdEncuesta	INT
	
AS

	SELECT 
		  [Id]
		 ,[SuperSeccion]
		 ,[Titulo] 
		 ,[Ayuda]
	FROM 
		[dbo].[Seccion] AS s
	WHERE 
		s.IdEncuesta = @IdEncuesta
	ORDER BY 
		Titulo

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_TiposPregunta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_TiposPregunta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Vilma Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-14																			 
-- Descripcion: Consulta la informacion de todos los tipos de pregunta
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--****************************************************************************************************
ALTER PROCEDURE [dbo].[C_TiposPregunta]

AS

	SELECT 
		 Id
		,Nombre 
	FROM 
		[dbo].[TipoPregunta]

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_PreguntaDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_PreguntaDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--====================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																			  
-- Fecha creacion: 2017-03-07																			  
-- Descripcion: elimina un registro de la tabla de preguntas
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--====================================================================================================
ALTER PROC [dbo].[D_PreguntaDelete] 

	@Id INT

AS 
	
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF(@esValido = 1) 
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY
				DELETE FROM [dbo].[Pregunta]
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_OpcionesXPregunta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_OpcionesXPregunta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 23/02/2017
-- Description:	Selecciona la información de Tipos de Usuario
-- =============================================
ALTER PROCEDURE [dbo].[C_OpcionesXPregunta] 

	@IdPregunta	 INT

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			 [Id]
			,[Valor]
		FROM
			[dbo].[Opciones]
		WHERE
			[IdPregunta] = @IdPregunta

	END	

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_OpcionesUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_OpcionesUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 09/03/2017
-- Description:	Actualiza la información de la tabla de opciones 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[U_OpcionesUpdate] 
	
	@IdOpcion	INT,
	@Valor		VARCHAR(255)
	
AS

	BEGIN
		
		SET NOCOUNT ON;

		-- Obtiene el identificador de la pregunta
		DECLARE @IdPregunta INT
		SELECT @IdPregunta = IdPregunta FROM [dbo].[Opciones] WHERE [Id] = @IdOpcion

		-- Obtiene el identificador de la pregunta
		DECLARE @ValorActual VARCHAR(255)
		SELECT @ValorActual = Valor FROM [dbo].[Opciones] WHERE [Id] = @IdOpcion

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		IF (EXISTS(SELECT * FROM [dbo].[Opciones] WHERE [IdPregunta] = @IdPregunta AND [Valor] = @Valor ))
			BEGIN
				SET @esValido = 0
				SET @respuesta += 'El Valor ya se encuentra asignado a otra opción.'
			END

		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY

					UPDATE [dbo].[Opciones]
					SET [Valor] = @Valor, [Texto] = @Valor
					WHERE [Id] = @IdOpcion

					UPDATE [dbo].[Respuesta] 
					SET [Valor] = @Valor
					WHERE [IdPregunta] IN (	SELECT [IdPregunta] 
											FROM [dbo].[Respuesta] 
											WHERE [IdPregunta] = @IdPregunta
											AND [Valor] = @ValorActual )

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_OpcionesInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_OpcionesInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 09/03/2017
-- Description:	Inserta un registro en la tabla de opciones
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[I_OpcionesInsert] 
	
	@IdPregunta	INT,
	@Valor		VARCHAR(255)

AS
	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		IF (EXISTS(SELECT * FROM [dbo].[Opciones] WHERE [IdPregunta] = @IdPregunta AND [Valor] = @Valor ))
			BEGIN
				SET @esValido = 0
				SET @respuesta += 'El Valor ya se encuentra asignado a otra opción.\n'
			END

		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY

					INSERT INTO [dbo].[Opciones] ([IdPregunta], [Valor], [Texto], [Orden])
					SELECT @IdPregunta, @Valor, @Valor, 0	
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_OpcionesDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_OpcionesDelete] AS'

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
ALTER PROCEDURE [dbo].[D_OpcionesDelete] 
	
	@IdOpcion	INT

AS
	BEGIN
		
		SET NOCOUNT ON;

		-- Obtiene el valor de la opción
		DECLARE @Valor VARCHAR(255)
		SELECT @Valor = Valor FROM [dbo].[Opciones] WHERE [Id] = @IdOpcion

		-- Obtiene el identificador de la pregunta
		DECLARE @IdPregunta INT
		SELECT @IdPregunta = IdPregunta FROM [dbo].[Opciones] WHERE [Id] = @IdOpcion

		-- Opciones utilizadas para retornar el estado de la transacción
		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY

					DELETE [dbo].[Respuesta] WHERE [IdPregunta] = @IdPregunta AND [Valor] = @Valor
					DELETE [dbo].[Recomendacion] WHERE [IdOpcion] = @IdOpcion
					DELETE [dbo].[Opciones] WHERE [Id] = @IdOpcion

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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[C_OpcionesMenu]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[C_OpcionesMenu]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[C_OpcionesRol] ') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[C_OpcionesRol]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[C_UsuariosEnSistema] ') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[C_UsuariosEnSistema]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[C_UsuariosEnviaronReporte] ') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[C_UsuariosEnviaronReporte]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[C_UsuariosGuardaronInformacionAutoevaluacion] ') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[C_UsuariosGuardaronInformacionAutoevaluacion]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[C_UsuariosGuardaronInformacionSistema] ') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[C_UsuariosGuardaronInformacionSistema]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[C_UsuariosPasaronAutoevaluación] ') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[C_UsuariosPasaronAutoevaluación]
END

GO


				
		



