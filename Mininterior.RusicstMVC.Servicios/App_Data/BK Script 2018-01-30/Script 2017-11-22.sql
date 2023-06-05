IF EXISTS(SELECT * FROM information_schema.[columns] WHERE table_name='RetroConsultaEncuesta' AND column_name='Usuario')
BEGIN
 PRINT 'Ya existe la columna :Usuario'
END
ELSE
BEGIN
  ALTER TABLE RetroConsultaEncuesta ADD Usuario VARCHAR(100) NULL
END 

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_DatosPrincipalesRetroEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_DatosPrincipalesRetroEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 22/08/2017
-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
-- =============================================
ALTER PROC [dbo].[I_DatosPrincipalesRetroEncuesta] 

	--@IdMunicipio INT,
	--@IdDepartamento INT,
	@IdRetroAdminEncuesta INT

AS

--Select UserName from Usuario where IdTipoUsuario IN (select Id from TipoUsuario Where Tipo IN ('ALCALDIA','GOBERNACION'))

INSERT [dbo].[RetroConsultaEncuesta] 
			([IdRetroAdmin], --[IdMunicipio], [IdDepartamento], 
			[Presentacion], [PresTexto], 
			[Nivel], [NivTexto], [Nivel2], [Niv2Texto], [NivIdGrafica], 
			[Desarrollo], [DesTexto], [Desarrollo2], [Des2Texto], [DesIdGrafica], 
			[Analisis], [AnaTexto], 
			[Revision], [RevTexto], 
			[Historial], [HisTexto], 
			[Observa], [ObsTexto], [Usuario]) 
			VALUES (@IdRetroAdminEncuesta,-- @IdMunicipio, @IdDepartamento, 
			N'Presentación', '',
			N'1. Nivel de Diligenciamiento', '', N'1.1. Porcentaje de diligenciamiento', '',NULL, 
			N'2. Desarrollo de la politica pública de Atención', '', N'2.1 Nivel de avance por fases', '', NULL, 
			N'3. Analisis del Plan de Mejoramiento Municipal', '',
			N'4. Revision de Archivos adjuntos', '',
			N'5. Historial de Envio Rusicts', '',
			N'6. Observaciones Generales', '','')

INSERT INTO [RetroConsultaEncuesta]
SELECT [IdRetroAdmin], 
			[Presentacion], [PresTexto], 
			[Nivel], [NivTexto], [Nivel2], [Niv2Texto], [NivIdGrafica], 
			[Desarrollo], [DesTexto], [Desarrollo2], [Des2Texto], [DesIdGrafica], 
			[Analisis], [AnaTexto], 
			[Revision], [RevTexto], 
			[Historial], [HisTexto], 
			[Observa], [ObsTexto], UserName
			from [RetroConsultaEncuesta],
			  Usuario where IdTipoUsuario IN (select Id from TipoUsuario Where Tipo IN ('ALCALDIA','GOBERNACION'))
			  AND [IdRetroAdmin] = @IdRetroAdminEncuesta 
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 1/08/2017
-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroEncuesta] 

	@IdRetroAdmin		INT,
	@Municipio			VARCHAR(100) = NULL

AS

IF NOT EXISTS(SELECT 1 FROM [dbo].[RetroConsultaEncuesta] Where [IdRetroAdmin] = @IdRetroAdmin)
	BEGIN
		EXEC I_DatosPrincipalesRetroEncuesta @IdRetroAdmin
	END

IF(@Municipio IS NULL)
	BEGIN
		SELECT [Id]
			  ,[IdRetroAdmin]
			  ,[Presentacion]
			  ,[PresTexto]
			  ,[Nivel]
			  ,[NivTexto]
			  ,[Nivel2]
			  ,[Niv2Texto]
			  ,[NivIdGrafica]
			  ,[Desarrollo]
			  ,[DesTexto]
			  ,[Desarrollo2]
			  ,[Des2Texto]
			  ,[DesIdGrafica]
			  ,[Analisis]
			  ,[AnaTexto]
			  ,[Revision]
			  ,[RevTexto]
			  ,[Historial]
			  ,[HisTexto]
			  ,[Observa]
			  ,[ObsTexto]
		  FROM [dbo].[RetroConsultaEncuesta]
		  Where [IdRetroAdmin] = @IdRetroAdmin
	END
ELSE
	BEGIN
		SELECT [Id]
			  ,[IdRetroAdmin]
			  ,[Presentacion]
			  ,[PresTexto]
			  ,[Nivel]
			  ,[NivTexto]
			  ,[Nivel2]
			  ,[Niv2Texto]
			  ,[NivIdGrafica]
			  ,[Desarrollo]
			  ,[DesTexto]
			  ,[Desarrollo2]
			  ,[Des2Texto]
			  ,[DesIdGrafica]
			  ,[Analisis]
			  ,[AnaTexto]
			  ,[Revision]
			  ,[RevTexto]
			  ,[Historial]
			  ,[HisTexto]
			  ,[Observa]
			  ,[ObsTexto]
		  FROM [dbo].[RetroConsultaEncuesta]
		  Where [IdRetroAdmin] = @IdRetroAdmin AND Usuario = @Municipio
	END

GO

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_EncuestaRetroUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_EncuestaRetroUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================  
-- Autor: Equipo de desarrollo OIM - John Betancourt A. 
-- Fecha creacion: 2017-08-04
-- Descripcion: Actualiza un registro en la realiemntacion                     
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado            
-- Estado int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado            
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'      
--====================================================================================================  
ALTER PROC [dbo].[U_EncuestaRetroUpdate]   
 
	@IdRetroAdmin int NULL,
	@Presentacion  varchar(50) = NULL,
	@PresTexto varchar(max) = NULL,
	@Nivel varchar(50) = NULL,
	@NivTexto varchar(max) NULL,
	@Nivel2 varchar(50) = NULL,
	@Niv2Texto varchar(max) = NULL,
	@NivIdGrafica int = NULL,
	@Desarrollo varchar(50) = NULL,
	@DesTexto varchar(max) = NULL,
	@Desarrollo2 varchar(50) = NULL,
	@Des2Texto varchar(max) = NULL,
	@DesIdGrafica int = NULL,
	@Analisis varchar(50) = NULL,
	@AnaTexto varchar(max) = NULL,
	@Revision varchar(50) = NULL,
	@RevTexto varchar(max) = NULL,
	@Historial varchar(50) = NULL,
	@HisTexto varchar(max) = NULL,
	@Observa varchar(50) = NULL,
	@ObsTexto varchar(max) = NULL,
	@IdTipoGuardado int = NULL,
	@Municipio varchar(50) = NULL
AS   
  
 -- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0  
 DECLARE @esValido AS BIT = 1  
  
   
 IF(@esValido = 1)   
	BEGIN
		IF (@Municipio IS NULL)
			BEGIN  
			  BEGIN TRANSACTION  
			  BEGIN TRY  

				IF(@IdTipoGuardado = 1)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET      
						Presentacion = @Presentacion,
						PresTexto  = @PresTexto  
					   WHERE    
						IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
					END 
				ELSE IF(@IdTipoGuardado = 2)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET      
						Nivel = @Nivel,
						NivTexto = @NivTexto,
						Nivel2 = @Nivel2,
						Niv2Texto = @Niv2Texto,
						NivIdGrafica = @NivIdGrafica
					   WHERE    
						IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
					END
				ELSE IF(@IdTipoGuardado = 3)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET
		   				Desarrollo = @Desarrollo,
						DesTexto = @DesTexto,
						Desarrollo2 = @Desarrollo2,
						Des2Texto = @Des2Texto,
						DesIdGrafica = @DesIdGrafica
					 WHERE    
						IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
					END
				ELSE IF(@IdTipoGuardado = 4)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET
		   				Analisis = @Analisis,
						AnaTexto = @AnaTexto
					 WHERE    
						IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
					END    
				ELSE IF(@IdTipoGuardado = 5)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET
						Revision = @Revision,
						RevTexto = @RevTexto
					 WHERE    
						IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
					END
				ELSE IF(@IdTipoGuardado = 6)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET
						Historial = @Historial,
						HisTexto = @HisTexto
					 WHERE    
						IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
					END
				ELSE IF(@IdTipoGuardado = 7)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET
						Observa = @Observa,
						ObsTexto = @ObsTexto
					 WHERE    
						IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
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
		 ELSE
			 BEGIN  
			  BEGIN TRANSACTION  
			  BEGIN TRY  

				IF(@IdTipoGuardado = 1)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET      
						Presentacion = @Presentacion,
						PresTexto  = @PresTexto  
					   WHERE    
						IdRetroAdmin = @IdRetroAdmin AND Usuario = @Municipio
					END 
				ELSE IF(@IdTipoGuardado = 2)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET      
						Nivel = @Nivel,
						NivTexto = @NivTexto,
						Nivel2 = @Nivel2,
						Niv2Texto = @Niv2Texto,
						NivIdGrafica = @NivIdGrafica
					   WHERE    
						IdRetroAdmin = @IdRetroAdmin AND Usuario = @Municipio
					END
				ELSE IF(@IdTipoGuardado = 3)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET
		   				Desarrollo = @Desarrollo,
						DesTexto = @DesTexto,
						Desarrollo2 = @Desarrollo2,
						Des2Texto = @Des2Texto,
						DesIdGrafica = @DesIdGrafica
					 WHERE    
						IdRetroAdmin = @IdRetroAdmin AND Usuario = @Municipio
					END
				ELSE IF(@IdTipoGuardado = 4)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET
		   				Analisis = @Analisis,
						AnaTexto = @AnaTexto
					 WHERE    
						IdRetroAdmin = @IdRetroAdmin AND Usuario = @Municipio
					END    
				ELSE IF(@IdTipoGuardado = 5)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET
						Revision = @Revision,
						RevTexto = @RevTexto
					 WHERE    
						IdRetroAdmin = @IdRetroAdmin AND Usuario = @Municipio
					END
				ELSE IF(@IdTipoGuardado = 6)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET
						Historial = @Historial,
						HisTexto = @HisTexto
					 WHERE    
						IdRetroAdmin = @IdRetroAdmin AND Usuario = @Municipio
					END
				ELSE IF(@IdTipoGuardado = 7)
					BEGIN
					   UPDATE   
						[dbo].[RetroConsultaEncuesta]  
					   SET
						Observa = @Observa,
						ObsTexto = @ObsTexto
					 WHERE    
						IdRetroAdmin = @IdRetroAdmin AND Usuario = @Municipio
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
				[Titulo] = @Titulo, [Ayuda] = @Ayuda, [FechaInicio] = CONVERT(char(10), @FechaInicio,126) , [FechaFin] = CONVERT(char(10), @FechaFin,126), [IsDeleted] = @IsDeleted, [IdTipoEncuesta] = @IdTipoEncuesta, [EncuestaRelacionada] = @EncuestaRelacionada, [AutoevaluacionHabilitada] = @AutoevaluacionHabilitada, [IsPrueba] = @IsPrueba
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_InformeRespuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_InformeRespuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																			 
-- Fecha creacion: 2017-03-16																			 
-- Descripcion: Trae el listado de respuestas de acuerdo a los criterios de búsqueda. En el parámetro 
--				@listaIdSubsecciones trae concatenados las secciones que se quieren consultar en específico			
--==========================================================================================================
ALTER PROCEDURE [dbo].[C_InformeRespuesta]
(
	  @IdEncuesta			INT
	 ,@listaIdSubsecciones	VARCHAR(128)
	 ,@IdDepartamento		INT = NULL
	 ,@IdMunicipio			INT = NULL
	 ,@Usuario				VARCHAR(255)
)	
AS

	DECLARE @Departamento INT
	DECLARE @Municipio	  INT
	DECLARE @TipoUsuario VARCHAR(255)

	-- Valida si el usuario corresponde a una Gobernación o a una Alcaldía
	SELECT @TipoUsuario = b.Nombre
	FROM 
		[dbo].[Usuario] a
		INNER JOIN [dbo].TipoUsuario b ON a.IdTipoUsuario = b.Id
	WHERE 
		a.UserName = @Usuario 

	IF(@TipoUsuario = 'ALCALDIA')
		BEGIN
			SELECT @Municipio =  IdMunicipio 
			FROM [dbo].[Usuario] 
			WHERE UserName = @Usuario

			SET @Departamento = NULL
		END
	ELSE
		BEGIN
			SET @Departamento = @IdDepartamento
			SET @Municipio = @IdMunicipio
		END

	SELECT CONVERT(INT,splitdata) splitdata INTO #ListaSubSecciones FROM [dbo].[Split](@listaIdSubsecciones, ',')
	-- Ejecuta la consulta
	SELECT 
		E.Titulo Encuesta
		,S.Titulo Seccion
		,BP.IdPregunta PreguntaId
		,BP.NombrePregunta Pregunta
		,[dbo].[ObtenerTextoPreguntaClean](P.Texto) PreguntaTexto
		,U.Username Usuario
		,R.Valor Respuesta
		,U.IdDepartamento Departamento
		,U.IdMunicipio Municipio
	FROM [dbo].[Encuesta] E
		INNER JOIN [dbo].[Seccion] S ON E.Id = S.IdEncuesta
		INNER JOIN [dbo].[Pregunta] P ON S.Id = P.IdSeccion
		INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA ON P.Id = PA.IdPreguntaAnterior
		INNER JOIN [BancoPreguntas].[Preguntas] BP ON PA.IdPregunta = BP.IdPregunta
		INNER JOIN [dbo].[Respuesta] R ON P.Id = R.IdPregunta
		INNER JOIN [dbo].[Usuario] U ON R.IdUsuario = U.Id
	WHERE 
		S.IdEncuesta = @IdEncuesta
		-- Ejecuta la función para que obtenga los Id's del parámetro que trae las secciones ------------------
		AND (@listaIdSubsecciones IS NULL OR S.Id IN (Select splitdata FROM #ListaSubSecciones)) 
		-------------------------------------------------------------------------------------------------------
		AND (@Departamento IS NULL OR U.IdDepartamento = @Departamento)
		AND (@Municipio IS NULL OR U.IdMunicipio = @Municipio)
	ORDER BY 
		E.Id, S.Id, P.Id
		

