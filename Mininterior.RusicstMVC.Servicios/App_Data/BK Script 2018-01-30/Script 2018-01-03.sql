IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_ContenidoSeccionDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_ContenidoSeccionDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================  
-- Author:  Equipo de desarrollo - OIM  
-- Create date: 17/06/2017  
-- Description: Procedimiento que elimina las secciones en cascada  
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
  
	 IF EXISTS(SELECT IsPrueba FROM [dbo].[Encuesta] WHERE [Id] IN (SELECT [IdEncuesta] FROM [dbo].[seccion] WHERE [Id] = @IdSeccion))  
		 BEGIN  
			SET @esValido = 1
		 END  
	 ELSE IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion))  
     BEGIN  
		SET @esValido = 0
		SET @respuesta += 'No es posible eliminar el registro. Se encontraron datos asociados.'
     END  
    
	IF(@esValido = 1) BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

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
		 
		 DELETE FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion)

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

	IF(@IsPrueba = 1)
		BEGIN
		IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)))
		BEGIN
			SET @esValido = 0
			SET @respuesta += 'No es posible cambiar el tipo de encuesta a prueba. Se encontraron respuestas asociadas.'
		END
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
				[Titulo] = @Titulo, [Ayuda] = @Ayuda, [FechaInicio] =  @FechaInicio , [FechaFin] = @FechaFin, [IsDeleted] = @IsDeleted, [IdTipoEncuesta] = @IdTipoEncuesta, [EncuestaRelacionada] = @EncuestaRelacionada, [AutoevaluacionHabilitada] = @AutoevaluacionHabilitada, [IsPrueba] = @IsPrueba
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

	 DELETE FROM [dbo].[RetroAdmin]  
	 WHERE [IdEncuesta] = @IdEncuesta

	 DELETE FROM [dbo].[Autoevaluacion2]  
	 WHERE [IdEncuesta] = @IdEncuesta
	 
	 DELETE FROM Objetivo where IdCategoria IN (select id FROM Categoria where IdProceso in (select id FROM [dbo].[Proceso] WHERE [IdEncuesta] = @IdEncuesta))

	 DELETE FROM Categoria where IdProceso in (select id FROM [dbo].[Proceso] WHERE [IdEncuesta] = @IdEncuesta)

	 DELETE FROM [dbo].[Proceso]  
	 WHERE [IdEncuesta] = @IdEncuesta

	 DELETE FROM PlanesMejoramiento.PlanMejoramientoEncuesta
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