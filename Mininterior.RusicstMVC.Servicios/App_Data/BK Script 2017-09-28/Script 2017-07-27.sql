--=================================================================================
-- ELIMINA LAS RESPUESTAS QUE NO ESTAN ATADAS A LAS PREGUNTAS
--=================================================================================
DELETE FROM Respuesta WHERE IdPregunta NOT IN (SELECT DISTINCT Id FROM Pregunta)
GO

--=================================================================================
-- COLOCA LA LLAVE FORANEA ENTRE LA TABLA DE RESPUESTAS Y PREGUNTAS
--=================================================================================
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_NAME ='FK_Respuesta_Pregunta')
	BEGIN
		ALTER TABLE [dbo].[Respuesta] WITH CHECK ADD  CONSTRAINT [FK_Respuesta_Pregunta] FOREIGN KEY([IdPregunta]) REFERENCES [dbo].[Pregunta] ([Id])
		ALTER TABLE [dbo].[Respuesta] CHECK CONSTRAINT [FK_Respuesta_Pregunta]
	END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntasSeccionEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PreguntasSeccionEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
--Autor: Liliana Rodriguez																			 
--Fecha creacion: 2017-02-24																			 
--Descripcion:	Trae el listado de las preguntas para llenar la rejilla de modificar 
--				preguntas de acuerdo a filtro seleccionado El idGrupo es obligatorio y traera la mayor cantidad
--				de preguntas. Entre mas especifica sea la consulta, será mas especifico el resultado								
--******************************************************************************************************/
ALTER PROCEDURE [dbo].[C_PreguntasSeccionEncuesta]

	@idEncuesta		INT,
	@idGrupo		INT, 
	@idseccion		INT = NULL,
	@idSubseccion	INT = NULL,
	@nombrePregunta VARCHAR(400) = NULL

AS

	SET NOCOUNT ON;	

	IF(@idSubseccion IS NULL AND @idseccion IS NULL)
		BEGIN
			SELECT 
				 a.Id
				,ISNULL(CONVERT(INT, e.CodigoPregunta), 0) AS IdPregunta
				,a.Texto 
				,f.Nombre TipoPregunta
				,CASE WHEN a.EsObligatoria = 1 THEN 'Si' ELSE 'No' END  Obligatoria
				,a.SoloSi AS Validacion
				,a.Nombre
			FROM 
				dbo.Pregunta a 
				INNER JOIN dbo.TipoPregunta f ON a.IdTipoPregunta = f.Id
				INNER JOIN dbo.Seccion c ON c.Id = a.IdSeccion
				LEFT OUTER JOIN BancoPreguntas.PreguntaModeloAnterior b ON b.IdPreguntaAnterior = a.Id
				INNER JOIN BancoPreguntas.Preguntas e ON e.IdPregunta = b.IdPregunta
			WHERE 
				 c.IdEncuesta = @IdEncuesta	
			 AND C.SuperSeccion IN (SELECT Id FROM Seccion WHERE IdEncuesta = @idEncuesta AND SuperSeccion IN (SELECT Id FROM Seccion WHERE IdEncuesta = @idEncuesta AND Id = @idGrupo))
		END 

	ELSE IF (@idSubseccion IS NULL)
		BEGIN
			SELECT 
				 a.Id
				,ISNULL(CONVERT(INT, e.CodigoPregunta), 0) AS IdPregunta
				,a.Texto 
				,f.Nombre TipoPregunta
				,CASE WHEN a.EsObligatoria = 1 THEN 'Si' ELSE 'No' END  Obligatoria
				,a.SoloSi AS Validacion
				,a.Nombre
			FROM 
				dbo.Pregunta a 
				INNER JOIN dbo.TipoPregunta f ON a.IdTipoPregunta = f.Id
				INNER JOIN dbo.Seccion c ON c.Id = a.IdSeccion
				LEFT OUTER JOIN BancoPreguntas.PreguntaModeloAnterior b ON b.IdPreguntaAnterior = a.Id
				INNER JOIN BancoPreguntas.Preguntas e ON e.IdPregunta = b.IdPregunta
			WHERE 
				 c.IdEncuesta = @IdEncuesta	
			 AND C.SuperSeccion = @idseccion
		END		
	ELSE
		 BEGIN
			SELECT 
				 a.Id
				,ISNULL(CONVERT(INT, e.CodigoPregunta), 0) AS IdPregunta
				,a.Texto 
				,f.Nombre TipoPregunta
				,CASE WHEN a.EsObligatoria = 1 THEN 'Si' ELSE 'No' END  Obligatoria
				,a.SoloSi AS Validacion
				,a.Nombre
			FROM 
				dbo.Pregunta a 
				INNER JOIN dbo.TipoPregunta f ON a.IdTipoPregunta = f.Id
				INNER JOIN dbo.Seccion c ON c.Id = a.IdSeccion
				LEFT OUTER JOIN BancoPreguntas.PreguntaModeloAnterior b ON b.IdPreguntaAnterior = a.Id
				INNER JOIN BancoPreguntas.Preguntas e ON e.IdPregunta = b.IdPregunta
			WHERE 
				 c.IdEncuesta = @IdEncuesta	
			 AND C.Id = @idSubseccion
		END
		 	
GO


IF NOT EXISTS(SELECT * FROM information_schema.[columns] WHERE table_name='Encuesta' AND column_name='IsPrueba')
BEGIN
  ALTER TABLE Encuesta ADD IsPrueba INT NOT NULL DEFAULT 0
END 

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_EncuestaPruebaContenidoDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_EncuestaPruebaContenidoDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================  
-- Author:  John Betancourt A. - OIM  
-- Create date: 17/06/2017  
-- Description: Procedimiento que elimina la encuesta de prueba en cascada  
-- =================================================================  
ALTER PROC [dbo].[D_EncuestaPruebaContenidoDelete]  
(  
 @IdEncuesta INT  
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
     IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)))  
     BEGIN  
      DELETE FROM [dbo].[Respuesta]  
      WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta))  
     END  
   
     IF EXISTS(SELECT 1 FROM [BancoPreguntas].[PreguntaModeloAnterior] WHERE IdPreguntaAnterior IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)))  
     BEGIN  
      DELETE FROM [BancoPreguntas].[PreguntaModeloAnterior]  
      WHERE [IdPreguntaAnterior] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta))  
     END  
   
	 IF EXISTS(SELECT 1 FROM [dbo].[Opciones] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)))  
     BEGIN  
      DELETE FROM [dbo].[Recomendacion]  
      WHERE [IdOpcion] IN (SELECT [Id] FROM [dbo].[Opciones] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)))
     END

     IF EXISTS(SELECT 1 FROM [dbo].[Opciones] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)))  
     BEGIN  
      DELETE FROM [dbo].[Opciones]  
      WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta))  
     END  
   
     DELETE FROM [dbo].[Diseno]  
     WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)

     DELETE FROM [dbo].[Pregunta]  
     WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)
	 
	 DELETE FROM [dbo].[Seccion]  
	 WHERE [IdEncuesta] = @IdEncuesta

	 DELETE FROM Roles.RolEncuesta
	 WHERE [IdEncuesta] = @IdEncuesta

	 DELETE FROM Autoevaluacion2
	 WHERE [IdEncuesta] = @IdEncuesta

	 DELETE FROM Envio
	 WHERE [IdEncuesta] = @IdEncuesta

	 DELETE FROM PermisoUsuarioEncuesta
	 WHERE [IdEncuesta] = @IdEncuesta

	 DELETE FROM [dbo].[Encuesta]  
	 WHERE [Id] = @IdEncuesta
  
     SELECT @respuesta = 'Se ha eliminado la encuesta de Prueba y todo su contenido'  
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
-- Modifica:  John Betancourt A. OIM				  
-- Descripción: Validar que no tenga datos asociados antes de realizar la eliminación
-- Modifica:  John Betancourt A. OIM				  
-- Descripción: Eliminar todo el contenido cuando es de Prueba
--*****************************************************************************************************

ALTER PROC [dbo].[D_EncuestaDelete] 

	@Id INT

AS 

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0 
	DECLARE @esValido AS INT = 1
	
	IF ((SELECT TOP 1 IsPrueba FROM encuesta WHERE id  = @Id)= 1)
		BEGIN
			SET @esValido = 2
		END
	ELSE IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @Id)))
		BEGIN
			SET @esValido = 0
			SET @respuesta += 'No es posible eliminar el registro. Se encontraron datos asociados.'
		END

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

	IF(@esValido = 2) BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			EXEC D_EncuestaPruebaContenidoDelete @Id

			SELECT @respuesta = 'Se ha eliminado la encuesta de Prueba y todo su contenido'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestaConsultar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_EncuestaConsultar] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Robinson Moscoso																			 
-- Fecha creacion: 2017-01-25																			 
-- Descripcion: Consulta la informacion de las encuestas												
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'
-- Modifica:  John Betancourt A. OIM				  
-- Descripción: Adicionar campo de Prueba					 
--****************************************************************************************************
ALTER PROC [dbo].[C_EncuestaConsultar]

		 @id						INT = NULL
		,@Titulo					VARCHAR(255) = NULL
		,@Ayuda						VARCHAR(MAX) = NULL
		,@FechaInicio				DATETIME = NULL
		,@FechaFin					DATETIME = NULL
		,@IsDeleted					BIT = NULL
		,@TipoEncuesta				VARCHAR(255) = NULL
		,@EncuestaRelacionada		INT = NULL
		,@AutoevaluacionHabilitada	BIT = NULL

AS

	SELECT 
		 a.[Id]
		,a.[Titulo]
		,a.[Ayuda]
		,a.[FechaInicio]
		,a.[FechaFin]
		,a.[IsDeleted]
		,b.Nombre [TipoEncuesta] 
		,a.[EncuestaRelacionada]
		,a.[AutoevaluacionHabilitada]
		,a.[IsPrueba]
	FROM 
		[Encuesta] a
		INNER JOIN [TipoEncuesta] b ON a.IdTipoEncuesta = b.Id
	WHERE
		(@Id IS NULL OR a.Id = @Id)
	AND (@Titulo IS NULL OR a.Titulo LIKE '%' + @Titulo + '%')
	AND (@Ayuda IS NULL OR a.Ayuda LIKE '%' + @Ayuda + '%')
	AND (@FechaInicio IS NULL OR a.FechaInicio = @FechaInicio)
	AND (@FechaFin IS NULL OR a.FechaFin = @FechaFin)
	AND (@IsDeleted IS NULL OR a.IsDeleted = @IsDeleted)
	AND (@TipoEncuesta IS NULL OR b.Nombre LIKE '%' + @TipoEncuesta + '%')
	AND (@EncuestaRelacionada IS NULL OR a.EncuestaRelacionada = @EncuestaRelacionada)
	AND (@AutoevaluacionHabilitada IS NULL OR AutoevaluacionHabilitada = @AutoevaluacionHabilitada) 


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_EncuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_EncuestaInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--====================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																			  
-- Fecha creacion: 2017-03-10																			  
-- Descripcion: inserta un registro en la encuesta e inserta todos los tipos de reporte 																  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- Modifica:  John Betancourt A. OIM				  
-- Descripción: Adicionar campo de Prueba				  
--====================================================================================================
ALTER PROC [dbo].[I_EncuestaInsert] 

	@Titulo						VARCHAR(255),
	@Ayuda						VARCHAR(MAX) = NULL,
	@FechaInicio				DATETIME,
	@FechaFin					DATETIME,
	@IsDeleted					BIT = 0,
	@TipoEncuesta				VARCHAR(255),
	@EncuestaRelacionada		INT = NULL,
	@AutoevaluacionHabilitada	BIT,
	@TipoReporte				VARCHAR(128),
	@IsPrueba					INT = 0

AS 

	-- Parámetros para el manejo de la respuesta
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	-- Obtener Id del tipo de encuesta
	DECLARE @IdTipoEncuesta INT

	SELECT @IdTipoEncuesta = Id
	FROM TipoEncuesta
	WHERE Nombre = @TipoEncuesta

	SET @IdTipoEncuesta = ISNULL(@IdTipoEncuesta, 0)

	IF (EXISTS(SELECT * FROM encuesta WHERE titulo  = @Titulo) OR @IdTipoEncuesta = 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Título ya se encuentra asignado a otra Encuesta o el tipo de encuesta no existe.'
	END

	-- Parámetros para el manejo de los Tipos de Reporte
	DECLARE @i INT
	DECLARE @idTipoReporte INT
	DECLARE @numrows INT
	DECLARE @IdEncuesta INT

	-- Inserta en la tabla temporal los diferentes Ids de Tipos de Reporte
	DECLARE @Temp TABLE (Id INT,splitdata VARCHAR(128))
	INSERT @Temp SELECT ROW_NUMBER() OVER(ORDER BY splitdata) Id, splitdata FROM dbo.Split(@TipoReporte, ','); 

	SET @i = 1
	SET @numrows = (SELECT COUNT(*) FROM @Temp)	

	IF(@esValido = 1) BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			-- Inserta la encuesta
			INSERT INTO [dbo].[Encuesta] 
				([Titulo], [Ayuda], [FechaInicio], [FechaFin], [IsDeleted], [IdTipoEncuesta], [EncuestaRelacionada], [AutoevaluacionHabilitada], [IsPrueba])
			SELECT 
				@Titulo, @Ayuda, @FechaInicio, @FechaFin, @IsDeleted, @IdTipoEncuesta, @EncuestaRelacionada, @AutoevaluacionHabilitada, @IsPrueba

			-- Recupera el Identity registrado
			SET @IdEncuesta = @@IDENTITY

			-- Inserta los tipos de reporte
			IF @numrows > 0
				WHILE (@i <= (SELECT MAX(Id) FROM @Temp))
				BEGIN

					INSERT INTO [Roles].[RolEncuesta] ([IdEncuesta], [IdRol])
					SELECT @IdEncuesta, (SELECT splitdata FROM @Temp WHERE Id = @i)

					SET @i = @i + 1
				END

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


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_EncuestaUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_EncuestaUpdate] AS'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--====================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																			  
-- Fecha creacion: 2017-03-10																			  
-- Descripcion: Actualiza un registro en la encuesta e inserta todos los tipos de reporte 																  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'
-- Modifica:  John Betancourt A. OIM				  
-- Descripción: Adicionar campo de Prueba							  
--====================================================================================================
ALTER PROC [dbo].[U_EncuestaUpdate] 

	@IdEncuesta					INT,
	@Titulo						VARCHAR(255),
	@Ayuda						VARCHAR(MAX) = NULL,
	@FechaInicio				DATETIME,
	@FechaFin					DATETIME,
	@IsDeleted					BIT = 0,
	@TipoEncuesta				VARCHAR(255),
	@EncuestaRelacionada		INT = NULL,
	@AutoevaluacionHabilitada	BIT,
	@TipoReporte				VARCHAR(128),
	@IsPrueba					INT = 0

AS 

	-- Parámetros para el manejo de la respuesta
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	-- Obtener Id del tipo de encuesta
	DECLARE @IdTipoEncuesta INT

	SELECT @IdTipoEncuesta = Id
	FROM TipoEncuesta
	WHERE Nombre = @TipoEncuesta

	SET @IdTipoEncuesta = ISNULL(@IdTipoEncuesta, 0)

	IF (EXISTS(SELECT * FROM encuesta WHERE [titulo]  = @Titulo AND [id] <> @IdEncuesta) OR @IdTipoEncuesta = 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Título ya se encuentra asignado a otra Encuesta o el tipo de encuesta no existe.'
	END

	-- Parámetros para el manejo de los Tipos de Reporte
	DECLARE @i INT
	DECLARE @idTipoReporte INT
	DECLARE @numrows INT

	-- Inserta en la tabla temporal los diferentes Ids de Tipos de Reporte
	DECLARE @Temp TABLE (Id INT,splitdata VARCHAR(128))
	INSERT @Temp SELECT ROW_NUMBER() OVER(ORDER BY splitdata) Id, splitdata FROM dbo.Split(@TipoReporte, ','); 

	SET @i = 1
	SET @numrows = (SELECT COUNT(*) FROM @Temp)	

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			-- Inserta la encuesta
			UPDATE 
				[dbo].[Encuesta]
			SET    
				[Titulo] = @Titulo, [Ayuda] = @Ayuda, [FechaInicio] = @FechaInicio, [FechaFin] = @FechaFin, [IsDeleted] = @IsDeleted, [IdTipoEncuesta] = @IdTipoEncuesta, [EncuestaRelacionada] = @EncuestaRelacionada, [AutoevaluacionHabilitada] = @AutoevaluacionHabilitada, [IsPrueba] = @IsPrueba
			WHERE  
				[Id] = @IdEncuesta	

			-- Elimina los roles relacionados a la encuesta
			DELETE [Roles].[RolEncuesta]
			WHERE [IdEncuesta] = @IdEncuesta
			
			-- Inserta los tipos de reporte
			IF @numrows > 0
				WHILE (@i <= (SELECT MAX(Id) FROM @Temp))
				BEGIN

					INSERT INTO [Roles].[RolEncuesta] ([IdEncuesta], [IdRol])
					SELECT @IdEncuesta, (SELECT splitdata FROM @Temp WHERE Id = @i)

					SET @i = @i + 1
				END

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntaXNombre]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PreguntaXNombre] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		Equipo de desarrollo OIM - Rafael Alba
-- Create date: 25/07/2017
-- Description:	Selecciona la pregunta por nombre de pregunta
-- ============================================================
ALTER PROCEDURE [dbo].[C_PreguntaXNombre] 

	@NombrePregunta	 VARCHAR(512), 
	@IDSeccion Int

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			[Id]
		FROM [dbo].[Pregunta]
		WHERE [Nombre] =  @NombrePregunta 
		AND [IdSeccion] = @IdSeccion

	END	

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_PreguntaUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_PreguntaUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
/Autor: Vilma Liliana Rodriguez																			 
/Fecha creacion: 2017-02-15																			 
/Descripcion: Actualiza los datos de una pregunta
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [dbo].[U_PreguntaUpdate] 

	@Id				INT,
	@Nombre			VARCHAR(512),
	@IdTipoPregunta	INT,
	@Ayuda			VARCHAR(MAX),
	@EsObligatoria	BIT,
	@SoloSi			VARCHAR(MAX),
	@Texto			VARCHAR(MAX)

AS 

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0 
	DECLARE @esValido AS BIT = 1

	IF (NOT EXISTS(SELECT TOP 1 1 FROM dbo.Pregunta WHERE Id = @Id) OR @IdTipoPregunta = 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'La pregunta no se encuentra o el tipo de pregunta no existe.\n'
	END
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE 
				[dbo].[Pregunta] 
			SET
				[Nombre] = @Nombre
				,[IdTipoPregunta] = @IdTipoPregunta
				,[Ayuda]= @Ayuda
				,[EsObligatoria]= @EsObligatoria
				,[SoloSi]= @SoloSi
				,[Texto]= @Texto
			WHERE Id = @Id

		SELECT @respuesta = 'Se ha actualizado el registro'
		SELECT @estadoRespuesta = 2
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosPregunta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosPregunta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Vilma Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-14																			 
-- Descripcion: Consulta la informacion de modificar pregunta
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--*****************************************************************************************************
ALTER PROC [dbo].[C_DatosPregunta]

	@Id INT 

AS

	SELECT 
		 a.[Id]
		,a.[Nombre]
		,b.[Nombre] TipoPregunta
		,b.[Id] IdTipoPregunta
		,a.[Ayuda]
		,a.[EsObligatoria]
		,a.[SoloSi]
		,a.[Texto]	
	FROM 
		Pregunta a
		INNER JOIN TipoPregunta b ON a.IdTipoPregunta = b.Id
	WHERE 
		a.[Id]= @Id