
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_SeccionEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'drop PROCEDURE [dbo].[C_SeccionEncuesta]'
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																	 
-- Fecha creacion: 2017-03-13																			 
-- Descripcion: Trae el listado de secciones de una encuesta	
-- Modificacion: 2017-06-17 John Betancourt  -- Adicionar campo Estilos								
--=====================================================================================================
create PROCEDURE [dbo].[C_SeccionEncuesta]

	 @IdEncuesta	INT
	
AS

	SELECT 
		  [Id]
		 ,[SuperSeccion]
		 ,[Titulo] 
		 ,[Ayuda]
		 ,[Estilos]
	FROM 
		[dbo].[Seccion] AS s
	WHERE 
		s.IdEncuesta = @IdEncuesta AND Eliminado = 0 --VERIFICAR QUE NO AFECTE LOS OTROS LLAMADOS
	ORDER BY 
		Titulo
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_DisenoInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'drop PROCEDURE [dbo].[I_DisenoInsert] '
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt																		  
-- Fecha creacion: 2017-06-19																			
-- Descripcion: inserta un registro en el diseno
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--====================================================================================================
create PROC [dbo].[I_DisenoInsert] 

	@IdSeccion			INT,
	@Texto				VARCHAR(MAX) = NULL,
	@ColumnSpan			INT = NULL,
	@RowSpan			INT = NULL,
	@RowIndex			INT,
	@ColumnIndex		INT

AS 

	-- Parámetros para el manejo de la respuesta
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
			
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			-- Inserta el diseno
			INSERT INTO [dbo].[Diseno] 
				(IdSeccion, Texto, ColumnSpan, RowSpan, RowIndex, ColumnIndex)
			SELECT 
				@IdSeccion, @Texto, @ColumnSpan, @RowSpan, @RowIndex, @ColumnIndex	


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

	go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_PreguntaEncuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'drop PROCEDURE [dbo].[I_PreguntaEncuestaInsert] '
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================
-- Autor: Equipo de desarrollo OIM - John Betancourt A.																		  
-- Fecha creacion: 2017-06-20																			  
-- Descripcion: Ingresa una pregunta cargada por el archivo excel y devuelve su ID
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int = 0 no hace nada, otro valor = ID de la pregunta insertada
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--====================================================================================================
create PROC [dbo].[I_PreguntaEncuestaInsert] 

	@IdSeccion		INT,
	@Nombre			VARCHAR(512) = NULL,
	@TipoPregunta	VARCHAR(255) = NULL,
	@Ayuda			VARCHAR(MAX) = NULL,
	@EsObligatoria	BIT,
	@EsMultiple		BIT,
	@SoloSi			VARCHAR(MAX) = NULL,
	@Texto			VARCHAR(MAX) = NULL

AS 
	BEGIN
		
		SET NOCOUNT ON;

	-- Obtener Id del tipo de encuesta
		DECLARE @IdTipoPregunta INT

		SELECT @IdTipoPregunta = Id
		FROM TipoPregunta
		WHERE Id = @TipoPregunta

		SET @IdTipoPregunta = ISNULL(@IdTipoPregunta, 0)

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0
		DECLARE @esValido AS BIT = 1
	
		IF(@esValido = 1 AND @IdTipoPregunta != 0) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY

					INSERT INTO [dbo].[Pregunta] ([IdSeccion], [Nombre], [IdTipoPregunta], [Ayuda], [EsObligatoria], [EsMultiple], [SoloSi], [Texto])
					SELECT @IdSeccion, @Nombre, @IdTipoPregunta, @Ayuda, @EsObligatoria, @EsMultiple, @SoloSi, @Texto
					
					SELECT @respuesta = 'Se ha insertado el registro'
					
					-- Recupera el Identity registrado
					SET @estadoRespuesta = @@IDENTITY

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
	go

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_SeccionUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'drop PROCEDURE [dbo].[U_SeccionUpdate] '
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================
-- Autor: Equipo de desarrollo OIM - John Betancourt A.																		  
-- Fecha creacion: 2017-06-17																			  
-- Descripcion: Actualiza un registro en la seccion
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--====================================================================================================
create PROC [dbo].[U_SeccionUpdate] 

	@Id							INT,
	@IdEncuesta					INT,
	@Titulo						VARCHAR(MAX),
	@Ayuda						VARCHAR(MAX) = NULL,
	@SuperSeccion				INT = NULL,
	@Eliminado					BIT = 0,
	@Archivo					IMAGE = NULL,
	@OcultaTitulo				BIT = 0,
	@Estilos					VARCHAR(MAX) = NULL
AS 

	-- Parámetros para el manejo de la respuesta
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0

	BEGIN TRANSACTION
	BEGIN TRY

		-- Inserta la encuesta
		UPDATE 
			[dbo].[Seccion]
		SET    
			[IdEncuesta] = @IdEncuesta, [Titulo] = @Titulo, [Ayuda] = @Ayuda, [SuperSeccion] = @SuperSeccion, [Eliminado] = @Eliminado, [Archivo] = @Archivo, [OcultaTitulo] = @OcultaTitulo, [Estilos] = @Estilos
		WHERE  
			[Id] = @Id	

			
	SELECT @respuesta = 'Se ha actualizado el registro'
	SELECT @estadoRespuesta = 2
	
	COMMIT  TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT @respuesta = ERROR_MESSAGE()
		SELECT @estadoRespuesta = 0
	END CATCH

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado			


