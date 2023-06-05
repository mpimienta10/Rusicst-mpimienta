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
		,a.[Ayuda]
		,a.[EsObligatoria]
		,a.[SoloSi]
		,a.[Texto]	
	FROM 
		Pregunta a
		INNER JOIN TipoPregunta b ON a.IdTipoPregunta = b.Id
	WHERE 
		a.[Id]= @Id
		
		
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
--				preguntas de acuerdo a filtro seleccionado									
--******************************************************************************************************/
ALTER PROCEDURE [dbo].[C_PreguntasSeccionEncuesta]

	@idEncuesta		INT ,
	@idGrupo		INT = NULL, 
	@idseccion		INT = NULL,
	@idSubseccion	INT = NULL,
	@nombrePregunta VARCHAR(400) = NULL

AS

	SET NOCOUNT ON;	

	SELECT 
		 TOP 1300 a.Id
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
		 AND (@idSubseccion  IS NULL OR c.Id = @idSubseccion) 
		 AND (@nombrePregunta IS NULL OR (a.Nombre LIKE '%' + @nombrePregunta + '%'))
		
		
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_RespuestasEncuestaXUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_RespuestasEncuestaXUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-08																			 
-- Descripcion: Carga el listado de respuestas por encuesta en la rejilla por usuario.										
--****************************************************************************************************
ALTER PROCEDURE [dbo].[C_RespuestasEncuestaXUsuario]

	@username VARCHAR(255)	
	 
AS

	SELECT 
		 x.Id
		,x.Titulo
		,x.FechaFin
		,x.Ayuda
		,x.FechaInicio
	FROM 
		[dbo].[Encuesta] AS x
		INNER JOIN  [dbo].[Envio]  e ON x.Id = e.IdEncuesta
		INNER JOIN dbo.Usuario f ON e.IdUsuario = f.Id
	WHERE 
		f.UserName = @username
		
	

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
	@TipoReporte				VARCHAR(128)

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
				([Titulo], [Ayuda], [FechaInicio], [FechaFin], [IsDeleted], [IdTipoEncuesta], [EncuestaRelacionada], [AutoevaluacionHabilitada])
			SELECT 
				@Titulo, @Ayuda, @FechaInicio, @FechaFin, @IsDeleted, @IdTipoEncuesta, @EncuestaRelacionada, @AutoevaluacionHabilitada

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_PreguntaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_PreguntaInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																		 
-- Fecha creacion: 2017-03-07																		 
-- Descripcion: Inserta los datos de una pregunta
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--=================================================================================================
 ALTER PROC [dbo].[I_PreguntaInsert] 

	@IdSeccion		INT,
	@Nombre			VARCHAR(512),
	@TipoPregunta	VARCHAR(255),
	@Ayuda			VARCHAR(MAX),
	@EsObligatoria	BIT,
	@EsMultiple		BIT,
	@SoloSi			VARCHAR(MAX),
	@Texto			VARCHAR(MAX)

AS 
	BEGIN
		
		SET NOCOUNT ON;

	-- Obtener Id del tipo de encuesta
		DECLARE @IdTipoPregunta INT

		SELECT @IdTipoPregunta = Id
		FROM TipoPregunta
		WHERE Nombre = @TipoPregunta

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
	@TipoReporte				VARCHAR(128)

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
				[Titulo] = @Titulo, [Ayuda] = @Ayuda, [FechaInicio] = @FechaInicio, [FechaFin] = @FechaFin, [IsDeleted] = @IsDeleted, [IdTipoEncuesta] = @IdTipoEncuesta, [EncuestaRelacionada] = @EncuestaRelacionada, [AutoevaluacionHabilitada] = @AutoevaluacionHabilitada
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
	@TipoPregunta	VARCHAR(255),
	@Ayuda			VARCHAR(MAX),
	@EsObligatoria	BIT,
	@SoloSi			VARCHAR(MAX),
	@Texto			VARCHAR(MAX)

AS 

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0 
	DECLARE @esValido AS BIT = 1

	-- Obtener Id del tipo de encuesta
	DECLARE @IdTipoPregunta INT

	SELECT @IdTipoPregunta = Id
	FROM TipoPregunta
	WHERE Nombre = @TipoPregunta

	SET @IdTipoPregunta = ISNULL(@IdTipoPregunta, 0)
	
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ObtenerTextoPreguntaClean]') AND type in (N'FN')) 
EXEC dbo.sp_executesql @statement = N'CREATE FUNCTION [dbo].[ObtenerTextoPreguntaClean] (@Text VARCHAR(MAX)) RETURNS VARCHAR(MAX) AS BEGIN DECLARE @Result VARCHAR(MAX) RETURN @Result END'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[ObtenerTextoPreguntaClean](@Text varchar(max)) 

RETURNS VARCHAR(MAX)

AS
BEGIN

   DECLARE @Result VARCHAR(MAX)
   
   while CHARINDEX('%',@Text) > 0
	begin
		set @Text = replace(@Text, SUBSTRING(@Text,CHARINDEX('%',@Text), CHARINDEX('%',@Text,CHARINDEX('%',@Text)+1) -CHARINDEX('%',@Text)+1), '')
	end

	set @Result = REPLACE(REPLACE(@Text, '[[', ''), ']]', '')

   RETURN @Result
   
END

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

	  @idEncuesta			INT
	 ,@listaIdSubsecciones	VARCHAR(128)
	 ,@idDepartamento		INT = NULL
	 ,@idMunicipio			INT = NULL
	 ,@usuario				VARCHAR(255)
	
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
		a.UserName = @usuario 

	IF(@TipoUsuario = 'ALCALDIA')
		BEGIN
			SELECT @Municipio =  IdMunicipio 
			FROM [dbo].[Usuario] 
			WHERE UserName = @usuario

			SET @Departamento = NULL
		END
	ELSE
		BEGIN
			SET @Departamento = @idDepartamento
			SET @Municipio = @idMunicipio
		END

	-- Ejecuta la consulta
	SELECT 
		TOP 100 E.Titulo Encuesta
		,S.Titulo Seccion
		,P.Id PreguntaId
		,P.Nombre Pregunta
		,[dbo].[ObtenerTextoPreguntaClean](P.Texto) PreguntaTexto
		,U.Username Usuario
		,R.Valor Respuesta
		,U.IdDepartamento Departamento
		,U.IdMunicipio Municipio
	FROM [dbo].[Encuesta] E
		INNER JOIN [dbo].[Seccion] S ON E.Id = S.IdEncuesta
		INNER JOIN [dbo].[Pregunta] P ON S.Id = P.IdSeccion
		INNER JOIN [dbo].[Respuesta] R ON P.Id = R.IdPregunta
		INNER JOIN [dbo].[Usuario] U ON R.IdUsuario = U.Id
	WHERE 
		S.IdEncuesta = @idEncuesta
		-- Ejecuta la función para que obtenga los Id's del parámetro que trae las secciones ------------------
		AND (@listaIdSubsecciones IS NULL OR S.Id IN (SELECT * FROM [dbo].[Split](@listaIdSubsecciones, ','))) 
		-------------------------------------------------------------------------------------------------------
		AND (@Departamento IS NULL OR U.IdDepartamento = @Departamento)
		AND (@Municipio IS NULL OR U.IdMunicipio = @Municipio)
	ORDER BY 
		E.Id, S.Id, P.Id
		

GO


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_InformesAutoevaluacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_InformesAutoevaluacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: Marzo 1 de 2017
-- Description:	Procedimiento que carga la consulta de Informe 
--				de Autoevaluación, recibe como parámetros el Id
--				de la encuesta, el departamento y el municipio
-- ============================================================
ALTER PROCEDURE [dbo].[C_InformesAutoevaluacion]
	
	@IdEncuesta		INT = NULL
	,@IdDepartamento	INT = NULL
	,@IdMunicipio		INT = NULL
AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			TOP 1300 [E].[Titulo] AS Encuesta
			,[U].[UserName] Usuario
			,[D].[Nombre] AS Departamento
			,[M].[Nombre] AS Municipio
			,[A].[Acciones]
			,[A].[Autoevaluacion]
			,[A].[Avance]
			,[A].[Calificacion]
			,[A].[FechaCumplimiento]
			,[O].[Texto] AS Objetivo
			,[C].[Nombre] AS Categoria
			,[P].[Nombre] AS Proceso
			,[A].[Recomendacion]
			,[A].[Recursos]
			,[A].[Responsable]
		FROM 
			[dbo].[Autoevaluacion2] A
			INNER JOIN [dbo].[Encuesta] E ON [A].[IdEncuesta] = [E].[Id]
			INNER JOIN [dbo].[Objetivo] O ON [A].[IdObjetivo] = [O].[Id]
			INNER JOIN [dbo].[Categoria] C ON [O].[IdCategoria] = [C].[Id]
			INNER JOIN [dbo].[Proceso] P ON [C].[IdProceso] = [P].[Id]
			INNER JOIN [dbo].[Usuario] U ON [A].[IdUsuario] = [U].[Id]
			LEFT JOIN [dbo].[Municipio] M ON [U].[IdMunicipio] = [M].[Id]
			LEFT JOIN [dbo].[Departamento] D ON [M].[IdDepartamento] = [D].[Id]
		WHERE 
			(@IdEncuesta IS NULL OR [A].[IdEncuesta] = @IdEncuesta)
			AND (@IdDepartamento IS NULL OR [D].[Id] = @IdDepartamento)
			AND (@IdMunicipio IS NULL OR m.[Id] = @IdMunicipio)
	END
		
GO

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_OpcionesMenu]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_OpcionesMenu] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		ROBINSON MOSCOSO
-- Create date:	31/01/2017
-- Description:	Se modifica OpcionesMenu para darle nombre a los campos resultantes 
--				Procedimiento que retorna la información de todas las opciones de Menus
-- =============================================
ALTER PROCEDURE [dbo].[C_OpcionesMenu]  

AS

BEGIN

	SELECT 
		 DISTINCT 
		 dbo.Recurso.Nombre AS Menu
		,dbo.SubRecurso.Nombre AS SubMenu
		,dbo.SubRecurso.Url AS Url
	FROM
		dbo.Recurso 
		INNER JOIN dbo.RolRecurso ON dbo.Recurso.Id = dbo.RolRecurso.IdRecurso 
		INNER JOIN dbo.SubRecurso ON dbo.RolRecurso.IdSubRecurso = dbo.SubRecurso.IdSubRecurso
	ORDER BY 
		 menu,SubMenu 	

END
		
GO

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_OpcionesRol]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_OpcionesRol] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Robinson Moscoso
-- Create date:	10/12/2014
-- Description:	Procedimiento que retorna la información de todas las opciones por Rol
-- =============================================
ALTER PROCEDURE [dbo].[C_OpcionesRol] 

AS
	BEGIN

		SELECT 
			dbo.RolRecurso.IdRol
			,dbo.Recurso.Nombre AS Menu
			,dbo.SubRecurso.Nombre AS SubMenu
			,dbo.SubRecurso.Url AS Url
		FROM dbo.Recurso 
			INNER JOIN dbo.RolRecurso ON dbo.Recurso.Id = dbo.RolRecurso.IdRecurso 
			INNER JOIN dbo.SubRecurso ON dbo.RolRecurso.IdSubRecurso = dbo.SubRecurso.IdSubRecurso
		ORDER BY 
			dbo.RolRecurso.IdRol
			,Menu
			,SubMenu
	END
		
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[C_UsuariosEnSistema]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[C_UsuariosEnSistema]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[UsariosEnSistema]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[UsariosEnSistema]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[UsariosEnviaronReporte]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[UsariosEnviaronReporte]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[UsariosGuardaronInformacionAutoevaluacion]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[UsariosGuardaronInformacionAutoevaluacion]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[UsuariosGuardaronInformacionSistema]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[UsuariosGuardaronInformacionSistema]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[UsuariosPasaronAutoevaluación]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[UsuariosPasaronAutoevaluación]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[OpcionesMenu]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[OpcionesMenu]
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[OpcionesRol]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[OpcionesRol]
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosEnSistema]') AND type in (N'P', N'PC')) 
EXEC sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosEnSistema] AS'

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
			 c.Nombre AS Departamento
			,b.Nombre AS Municipio
			,a.Username as NombreDeUsuario
			,a.UserName Nombre 
			,a.Email
			,a.TelefonoCelular
			,d.Nombre TipoUsuario
			,a.Activo
		FROM
			Usuario a
			INNER JOIN TipoUsuario d ON a.IdTipoUsuario = d.Id
			LEFT OUTER JOIN Municipio b ON a.IdMunicipio = b.Id 
			LEFT OUTER JOIN Departamento c ON a.IdDepartamento = c.Id 
		ORDER BY 
			 Departamento
			,Municipio
			,a.Username
	
	END
		
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[VisorGenerico].[C_UsuariosEnviaronReporte]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [VisorGenerico].[C_UsuariosEnviaronReporte]
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosEnviaronReporte]') AND type in (N'P', N'PC')) 
EXEC sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosEnviaronReporte] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Robinson Moscoso																			 
-- Fecha creacion: 2017-01-27																			 
-- Descripcion: Consulta la informacion para identificar los usaurios que enviarion o no reporte												
-- Retorna: UsariosEnviaronReporte								 
--****************************************************************************************************
ALTER PROC [dbo].[C_UsuariosEnviaronReporte] 

	@IdEncuesta	INT

AS
	BEGIN

		SELECT    
			c.Nombre Departamento
			,b.Nombre Municipio
			,a.Username Usuario
			,a.UserName Nombre
			,a.Email
			,'SI' AS [ENVIO]
		FROM
			Usuario a
			LEFT OUTER JOIN Municipio b ON a.IdMunicipio = b.Id
			LEFT OUTER JOIN Departamento c ON a.IdDepartamento = c.Id
		WHERE    
			(a.UserName LIKE (SELECT '%' + SUBSTRING(e.Nombre, 6, 11) + '%' AS Expr1
										FROM   Encuesta d, TipoEncuesta e
										WHERE 
										d.IdTipoEncuesta = e.Id 
										AND (d.Id = @IdEncuesta)
										AND (a.Activo = 1) 
										AND (a.IdMunicipio + a.IdDepartamento > 0))) 
										AND (a.Username IN (  SELECT DISTINCT g.UserName
																FROM Envio f, Usuario g
																WHERE 
																f.IdUsuario = g.Id
																AND (f.IdEncuesta = @IdEncuesta))) 

		UNION ALL
		SELECT     
			c.Nombre Departamento
			,b.Nombre Municipio
			,a.Username Usuario
			,a.UserName NombreUsuario
			,a.Email
			,'NO' AS ENVIO
		FROM   
			Usuario a
			LEFT OUTER JOIN Municipio b ON a.IdMunicipio = b.Id 
			LEFT OUTER JOIN Departamento c ON a.IdDepartamento = c.Id
		WHERE 
			(a.Username LIKE (SELECT '%' + SUBSTRING(e.Nombre, 6, 11) + '%' AS Expr1
										FROM   Encuesta d, TipoEncuesta e
										WHERE 
										d.IdTipoEncuesta = e.Id
										AND (d.Id = @IdEncuesta)
										AND (a.Activo = 1) 
										AND (a.IdMunicipio + a.IdDepartamento > 0))) 
										AND (a.Username  NOT IN ( SELECT DISTINCT g.UserName
																	FROM Envio f, Usuario g
																	WHERE 
																	f.IdUsuario = g.Id
																	AND (f.IdEncuesta = @IdEncuesta))) 
		ORDER BY 
			c.Nombre
			,b.Nombre
	END
		

GO

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosGuardaronInformacionAutoevaluacion]') AND type in (N'P', N'PC')) 
EXEC sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosGuardaronInformacionAutoevaluacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Robinson Moscoso
-- Create date:	30/01/2017
-- Description:	Procedimiento que retorna la información de todos los usuario  
--				en el sistema que guardaron informacion en Autoevaluacion
-- =============================================
ALTER PROCEDURE [dbo].[C_UsuariosGuardaronInformacionAutoevaluacion] 
	
	@Encuesta	 INT

AS
	BEGIN
 
		DECLARE @FECFIN DATETIME 
		DECLARE @FECINI DATETIME 
		
		SELECT   
			 c.Nombre Departamento
			,b.Nombre Municipio
			,a.Username Usuario
			,a.Nombres Nombre 
			,a.Email
			,'SI' AS Guardo
		FROM      
			Usuario a
			LEFT OUTER JOIN Municipio b ON a.IdMunicipio = b.Id 
			LEFT OUTER JOIN Departamento c ON a.IdDepartamento = c.Id
		WHERE     
			(a.Username LIKE (SELECT '%' + SUBSTRING(e.Nombre, 6, 11) + '%' AS Expr1
										FROM  Encuesta d, TipoEncuesta e
										WHERE
										d.IdTipoEncuesta = e.Id
										AND (d.Id = @Encuesta)
										AND (a.Activo = 1) 
										AND (a.IdMunicipio + a.IdDepartamento > 0))) 
										AND (a.Username IN (  SELECT DISTINCT g.UserName 
																FROM Autoevaluacion2 f, Usuario g
																WHERE 
																f.IdUsuario = g.Id
																AND (IdEncuesta = @Encuesta)
																AND Recomendacion IS NOT NULL 
																AND LEN(Acciones) > 0))
		UNION ALL
		SELECT    
			 c.Nombre Departamento
			,b.Nombre Municipio
			,a.Username Usuario
			,a.Nombres Nombre
			,a.Email
			,'NO' AS  Guardo
		FROM
			Usuario a 
			LEFT OUTER JOIN Municipio b ON a.IdMunicipio = b.Id 
			LEFT OUTER JOIN Departamento c ON a.IdDepartamento = c.Id
		WHERE
			(a.Username LIKE (SELECT '%' + SUBSTRING(e.Nombre, 6, 11) + '%' AS Expr1
										FROM  Encuesta d, TipoEncuesta e 
										WHERE 
										d.IdTipoEncuesta = e.Id
										AND (d.Id = @Encuesta)
										AND (a.Activo = 1) 
										AND (a.IdMunicipio + a.IdDepartamento > 0))) 
										AND (a.Username  NOT IN (	SELECT DISTINCT g.UserName 
																		FROM Autoevaluacion2 f, Usuario g
																		WHERE 
																		f.IdUsuario = g.Id
																		AND (IdEncuesta = @Encuesta)
																		AND Recomendacion IS NOT NULL 
																		AND LEN(Acciones) > 0))
		ORDER BY 
			 c.Nombre
			,b.Nombre

	END
		

GO

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosGuardaronInformacionSistema]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosGuardaronInformacionSistema] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================
-- Author:	Robinson Moscoso 
--			Ajustado por el equipo de desarrollo de la OIM - Nelson Restrepo
-- Create date:	31-01-2017 - Update date : 30-03-2017
-- Description:	Procedimiento que retorna la información de los usuarios que guardaron Informacion en el Sistema
-- ==================================================================================================================

ALTER PROCEDURE [dbo].[C_UsuariosGuardaronInformacionSistema] 

	@IdEncuesta INT

AS

	BEGIN

		DECLARE @FECFIN DATETIME 
		DECLARE @FECINI DATETIME 

		DECLARE @TipoEncuesta VARCHAR(50)

		SET @TipoEncuesta = (SELECT '%' + SUBSTRING(b.Nombre, 6, 11) + '%' FROM Encuesta a, TipoEncuesta b WHERE a.IdTipoEncuesta = b.Id AND (a.Id = @IdEncuesta))

		DECLARE @TablaUsuarioDos TABLE
		(
			Username VARCHAR(50)
		)

		INSERT INTO @TablaUsuarioDos
		SELECT 
			DISTINCT Respuesta.Usuario Username
		FROM 
			(SELECT b.UserName Usuario, IdPregunta FROM Respuesta a, Usuario b WHERE a.IdUsuario = b.Id AND b.UserName LIKE @TipoEncuesta) Respuesta
			INNER JOIN Pregunta ON Respuesta.IdPregunta = Pregunta.Id 
			INNER JOIN (SELECT Id FROM Seccion WHERE IdEncuesta = @IdEncuesta) Seccion ON Pregunta.IdSeccion = Seccion.Id

		IF exists (SELECT TOP 1 [FechaFin] FROM [PermisoUsuarioEncuesta] WHERE IdEncuesta = @IdEncuesta ORDER BY FechaFin DESC)
		BEGIN
			SET @FECFIN = (SELECT TOP 1 [FechaFin] FROM [PermisoUsuarioEncuesta] WHERE IdEncuesta = @IdEncuesta ORDER BY FechaFin DESC)
		END
		ELSE
		BEGIN
			SET @FECFIN = (SELECT FechaFin FROM Encuesta WHERE ID = @IdEncuesta)
		END

		SET @FECINI =(SELECT FechaInicio FROM Encuesta WHERE ID = @IdEncuesta) 

		--===================================================
		-- Usuarios que guardaron información en el sistema
		--===================================================
		SELECT 
			Departamento.Nombre AS Departamento
			,Municipio.Nombre as Municipio
			,usuario.Username as Usuario
			,Usuario.Nombres Nombre
			,Usuario.Email
			,'SI' AS GUARDO
		FROM 
			(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (IdMunicipio + IdDepartamento > 0)) Usuario
			LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
			LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
		WHERE 
			Usuario.Username IN (SELECT Username FROM @TablaUsuarioDos)
		UNION ALL
		SELECT 
			Departamento.Nombre AS Departamento
			,Municipio.Nombre as Municipio
			,usuario.Username as Usuario
			,Usuario.Nombres Nombre
			,Usuario.Email
			,'NO' AS GUARDO
		FROM 
			(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (IdMunicipio + IdDepartamento > 0)) Usuario 
			LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
			LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
		WHERE 
			Usuario.Username NOT IN (SELECT Username FROM @TablaUsuarioDos)
		ORDER BY 
			Departamento.Nombre
			,Municipio.Nombre

	END
																								
GO

		IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosPasaronAutoevaluacion]') AND type in (N'P', N'PC')) 
EXEC sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosPasaronAutoevaluacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================================================================================
-- Author:	Robinson Moscoso
-- Create date:	31/01/2017
-- Description:	Procedimiento que retorna la información de todos los usuario en el sistema que pasaron a Autoevaluacion
-- ======================================================================================================================
ALTER PROCEDURE [dbo].[C_UsuariosPasaronAutoevaluacion]

	 @Encuesta INT

AS
BEGIN

SELECT 
	Departamento.Nombre Departamento
	,Municipio.Nombre Municipio
	,usuario.Username Usuario
	,UPPER(Usuario.Nombres) AS Nombre
	,LOWER(Usuario.Email) AS Email
	,'SI' AS Paso
FROM 
	Usuario 
	LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
	LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
WHERE 
	(Usuario.Username LIKE (SELECT '%' + SUBSTRING(b.Nombre, 6, 11) + '%' AS Expr1
									FROM Encuesta a, TipoEncuesta b
									WHERE 
									a.IdTipoEncuesta = b.Id
									AND (a.Id = @Encuesta)
									AND (Usuario.Activo = 1) 
									AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0))) 
	AND (Usuario.Username IN  ( SELECT d.UserName Usuario 
									FROM Respuesta c, Usuario d
									WHERE 
										c.IdUsuario = d.Id
										AND IdPregunta IN (SELECT Pregunta.Id
															FROM Seccion 
															INNER JOIN Pregunta ON Seccion.Id = Pregunta.IdSeccion
															WHERE (Seccion.IdEncuesta = @Encuesta) 
															AND (Pregunta.EsObligatoria = 1)) 
									AND valor != '-'
									GROUP BY d.UserName
									HAVING (COUNT(distinct IdPregunta) - (SELECT COUNT (*)
																			FROM Seccion 
																			INNER JOIN Pregunta ON Seccion.Id = Pregunta.IdSeccion
																			WHERE (Seccion.IdEncuesta = @Encuesta) 
																			AND (Pregunta.EsObligatoria = 1))) = 0))


UNION ALL

SELECT 
	Departamento.Nombre AS Departamento
	,Municipio.Nombre AS Municipio
	,usuario.Username AS Usuario
	,UPPER(Usuario.Nombres) AS Nombre
	,LOWER(Usuario.Email) AS Email
	,'NO' AS Paso
FROM 
	Usuario 
	LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
	LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
WHERE 
	(Usuario.Username LIKE (SELECT '%' + SUBSTRING(b.Nombre, 6, 11) + '%' AS Expr1
								FROM Encuesta a, TipoEncuesta b
								WHERE 
								a.IdTipoEncuesta = b.Id
								AND (a.Id = @Encuesta)
								AND (Usuario.Activo = 1) 
								AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0))) 
								AND (Usuario.Username NOT IN (SELECT d.UserName Usuario 
																	FROM Respuesta c, Usuario d 
																	WHERE 
																		c.IdUsuario = d.Id
																		AND IdPregunta IN (SELECT Pregunta.Id
																						FROM Seccion 
																						INNER JOIN Pregunta ON Seccion.Id = Pregunta.IdSeccion
																						WHERE (Seccion.IdEncuesta = @Encuesta) 
																						AND (Pregunta.EsObligatoria = 1))
																	AND valor != '-'
																	GROUP BY d.UserName
																	HAVING (COUNT(distinct IdPregunta) - (SELECT COUNT (*) 
																										FROM Seccion 
																										INNER JOIN Pregunta ON Seccion.Id = Pregunta.IdSeccion
																										WHERE (Seccion.IdEncuesta = @Encuesta)
																										AND (Pregunta.EsObligatoria = 1))) = 0))
	ORDER BY Departamento.Nombre, Municipio.Nombre

END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Reporte_Consolidado_Detalle]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_Reporte_Consolidado_Detalle]
END

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ReporteConsolidadoDetalle]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ReporteConsolidadoDetalle] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================
-- Author:	Desarrolladores RUSICST - Ajustado por el equipo de desarrollo de la OIM (Nelson Restrepo)
-- Create date:	Desconocida - Update date : 30-03-2017
-- Description:	Procedimiento que retorna los datos para el informe consolidado. Se cambio de nombre para que estos
--				tengan coherencia con los nombres de los otros procedimientos. Se deja el procedimiento original que
--				estaba con el nombre reporte_ejecutivo2.
-- ==================================================================================================================
ALTER PROCEDURE [dbo].[C_ReporteConsolidadoDetalle] 
		(
			@IdDepartamento INT, 
			@IdEncuesta INT
		)
		AS
			BEGIN 
	
			DECLARE @TipoEncuesta VARCHAR(50)
			DECLARE @CantidadRespuestasObligatorias INT
			
			SET @TipoEncuesta = (SELECT '%' + SUBSTRING(b.Nombre, 6, 11) + '%' FROM Encuesta a, TipoEncuesta b WHERE a.IdTipoEncuesta = b.Id AND (a.Id = @IdEncuesta))
			SET @CantidadRespuestasObligatorias = (SELECT COUNT (*) FROM Seccion INNER JOIN Pregunta ON Seccion.Id = Pregunta.IdSeccion WHERE Seccion.IdEncuesta = @IdEncuesta AND Pregunta.EsObligatoria = 1)

			PRINT '0 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @TablaUsuarioUno TABLE
			(
				Username VARCHAR(50)
			)			

			INSERT INTO @TablaUsuarioUno
			(
				Username
			)
			SELECT 
				Usuario Username
			FROM 
				(SELECT b.UserName Usuario, a.IdPregunta FROM Respuesta a, Usuario b WHERE a.IdUsuario = b.Id AND a.Valor != '-') Respuesta
				INNER JOIN (SELECT Id, IdSeccion FROM Pregunta WHERE EsObligatoria = 1) Pregunta ON Respuesta.IdPregunta = Pregunta.Id 
				INNER JOIN (SELECT Id, IdEncuesta FROM Seccion WHERE IdEncuesta = @IdEncuesta) Seccion ON Pregunta.IdSeccion = Seccion.Id
			GROUP BY 
				Usuario
			HAVING 
				(COUNT(DISTINCT IdPregunta) - @CantidadRespuestasObligatorias) = 0

			DECLARE @TablaUsuarioDos TABLE
			(
				Username VARCHAR(50)
			)

			INSERT INTO @TablaUsuarioDos
			SELECT 
				DISTINCT Respuesta.Usuario Username
			FROM 
				(SELECT b.UserName Usuario, a.IdPregunta FROM Respuesta a, Usuario b WHERE a.IdUsuario = b.Id AND b.UserName LIKE @TipoEncuesta) Respuesta
				INNER JOIN Pregunta ON Respuesta.IdPregunta = Pregunta.Id 
				INNER JOIN (SELECT Id FROM Seccion WHERE IdEncuesta = @IdEncuesta) Seccion ON Pregunta.IdSeccion = Seccion.Id

			DECLARE @TablaUsuarioTres TABLE
			(
				Username VARCHAR(50)
			)
			INSERT INTO @TablaUsuarioTres
			SELECT 
				DISTINCT b.UserName Usuario 
			FROM 
				Autoevaluacion2 a, Usuario b 
			WHERE 
				a.IdUsuario = b.Id
				AND (a.IdEncuesta = @IdEncuesta) 
				AND a.Recomendacion IS NOT NULL 
				AND LEN(a.Acciones) > 0

			DECLARE @FECFIN DATETIME 
			DECLARE @FECINI DATETIME
											 
			PRINT '1 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			IF EXISTS (	SELECT TOP 1 [FechaFin] FROM [PermisoUsuarioEncuesta] WHERE IdEncuesta = @IdEncuesta ORDER BY FechaFin DESC)
			BEGIN
				SET @FECFIN = (SELECT TOP 1 [FechaFin] FROM [PermisoUsuarioEncuesta] WHERE IdEncuesta = @IdEncuesta ORDER BY FechaFin DESC)
			END
			ELSE
				BEGIN
					SET @FECFIN =(SELECT FechaFin FROM Encuesta WHERE ID = @IdEncuesta)
				END
	
			SET @FECINI = (SELECT FechaInicio FROM Encuesta WHERE ID = @IdEncuesta) 
	
			PRINT '2 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			DECLARE @Tabla1 TABLE
			(
				divipola VARCHAR(50), 
				nombre VARCHAR(250), 
				municipio NUMERIC(38)
			)
	
			INSERT INTO @Tabla1 
			(
			divipola , 
			nombre , 
			municipio 
			)
			SELECT TOP (100) PERCENT 
				Departamento.Divipola, 
				Departamento.Nombre, 
				COUNT(DISTINCT Municipio.Divipola) AS municipio
			FROM 
				Departamento 
				INNER JOIN Municipio ON Departamento.Id = Municipio.IdDepartamento 
				INNER JOIN Usuario ON Departamento.Id = Usuario.IdDepartamento AND Municipio.Id = Usuario.IdMunicipio
			WHERE 
				Departamento.Divipola = (CASE WHEN @IdDepartamento = '-1' THEN Departamento.Divipola ELSE @IdDepartamento END)
			GROUP BY 
				Departamento.Divipola, Departamento.Nombre, Usuario.Activo
			HAVING 
				(Usuario.Activo = 1) 
			ORDER BY 
				Departamento.Nombre

			PRINT @TipoEncuesta

			PRINT '3 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			DECLARE @Tabla2 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla2 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				INNER JOIN @TablaUsuarioUno tu ON tu.Username = Usuario.Username
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
			WHERE 
				Departamento.Divipola = (CASE WHEN @IdDepartamento = '-1' THEN Departamento.Divipola ELSE @IdDepartamento END)
			GROUP BY 
				Departamento.Nombre, Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '4 - ' + CONVERT(VARCHAR, GETDATE(), 113)
		
			DECLARE @Tabla3 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC (38)
			)
	
			INSERT INTO @Tabla3 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
			WHERE 
				(Usuario.Username NOT IN 	(	SELECT 
														b.UserName Usuario 
													FROM 
														Respuesta a, Usuario b
													WHERE 
														a.IdUsuario = b.Id
														AND a.IdPregunta IN 	(	SELECT 
																						Pregunta.Id
																					FROM 
																						Seccion 
																						INNER JOIN Pregunta ON Seccion.Id = Pregunta.IdSeccion
																					WHERE 
																						(Seccion.IdEncuesta = @IdEncuesta) 
																						AND (Pregunta.EsObligatoria = 1)
																		)
													GROUP BY 
														b.UserName
													HAVING 
														(COUNT(*) - (	SELECT 
																			COUNT (*) 
																		FROM 
																			Seccion 
																			INNER JOIN Pregunta ON Seccion.Id = Pregunta.IdSeccion
																		WHERE 
																			(Seccion.IdEncuesta = @IdEncuesta) AND (Pregunta.EsObligatoria = 1)
																	) 
														) = 0
												)
					) 
				AND Departamento.Divipola = (CASE WHEN @IdDepartamento = '-1' THEN Departamento.Divipola ELSE @IdDepartamento END)
			GROUP BY 
				Departamento.Nombre, Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '5 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			DECLARE @Tabla4 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla4 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Usuario.Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
				WHERE 	
					Usuario.Username IN (SELECT Username FROM @TablaUsuarioTres)
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '6 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla5 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC(38)
			)
			INSERT INTO @Tabla5 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Usuario.Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Divipola 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Divipola
			WHERE 
				Usuario.Username NOT IN (SELECT Username FROM @TablaUsuarioTres)
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '7 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla6 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla6 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
			WHERE 
				(Usuario.Username IN 	(	SELECT 
												DISTINCT b.UserName Usuario
											FROM 
												Envio a, Usuario b
											WHERE 
												a.IdUsuario = b.Id
												AND (a.IdEncuesta = @IdEncuesta)
										)
					) 
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '8 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla7 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(35)
			)
	
			INSERT INTO @Tabla7 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
			WHERE 
				(Usuario.Username NOT IN 	(	SELECT 
													DISTINCT b.UserName Usuario
												FROM 
													Envio a, Usuario b
												WHERE 
													a.IdUsuario = b.Id
													AND (a.IdEncuesta = @IdEncuesta)
											)
					) 
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '9 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla8 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC(38)
			)
	
			INSERT INTO @Tabla8 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			--IF OBJECT_ID('tempdb..@TABLA8') IS NOT NULL DROP TABLE @TABLA8
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				INNER JOIN @TablaUsuarioDos td ON Usuario.Username = td.Username
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '10 - ' + CONVERT(VARCHAR, GETDATE(), 113)
		
			DECLARE @Tabla9 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla9 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
			WHERE 
				Usuario.Username NOT IN (SELECT Username FROM @TablaUsuarioDos)
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '11 - ' + CONVERT(VARCHAR, GETDATE(), 113)
		
			DECLARE @Tabla10 TABLE
			(
				DIVIPOLA VARCHAR (250),
				DEPARTAMENTO VARCHAR (250), 
				MUNICIPIOS VARCHAR (250), 
				SI_GUARDO VARCHAR (250),
				NO_GUARDO VARCHAR (250),
				SI_COM_REP VARCHAR (250),
				NO_COM_REP VARCHAR (250),
				SI_ENVIARON VARCHAR (250),
				NO_ENVIARON VARCHAR (250),
				SI_INFO_PLAN VARCHAR (250),
				NO_INFO_PLAN VARCHAR (250)
			)

			INSERT INTO @Tabla10 
			(
				DIVIPOLA,
				DEPARTAMENTO, 
				MUNICIPIOS, 
				SI_GUARDO,
				NO_GUARDO,
				SI_COM_REP,
				NO_COM_REP,
				SI_ENVIARON,
				NO_ENVIARON,
				SI_INFO_PLAN,
				NO_INFO_PLAN 
			)
			SELECT
				tab1.Divipola AS DIVIPOLA,
				tab1.Nombre AS DEPARTAMENTO, 
				(tab1.municipio) AS MUNICIPIOS, 
				(tab8.TOTAL_ENVIO) AS SI_GUARDO,
				(tab9.TOTAL_ENVIO) AS NO_GUARDO,
				(tab2.TOTAL_ENVIO) AS SI_COM_REP,
				(tab3.TOTAL_ENVIO) AS NO_COM_REP,
				(tab6.TOTAL_ENVIO) AS SI_ENVIARON,
				(tab7.TOTAL_ENVIO) AS NO_ENVIARON,
				(tab4.TOTAL_ENVIO) AS SI_INFO_PLAN,
				(tab5.TOTAL_ENVIO) AS NO_INFO_PLAN 
			FROM 
				@Tabla1 tab1
				LEFT OUTER JOIN @TABLA2 tab2 on tab1.Divipola = tab2.Divipola 
				LEFT OUTER JOIN @TABLA3 tab3 on tab1.Divipola = tab3.Divipola 
				LEFT OUTER JOIN @TABLA4 tab4 on tab1.Divipola = tab4.Divipola 
				LEFT OUTER JOIN @TABLA5 tab5 on tab1.Divipola = tab5.Divipola 
				LEFT OUTER JOIN @TABLA6 tab6 on tab1.Divipola = tab6.Divipola 
				LEFT OUTER JOIN @TABLA7 tab7 on tab1.Divipola = tab7.Divipola 
				LEFT OUTER JOIN @TABLA8 tab8 on tab1.Divipola = tab8.Divipola 
				LEFT OUTER JOIN @TABLA9 tab9 on tab1.Divipola = tab9.Divipola 

			PRINT '12 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			--SELECT * FROM @Tabla10
	
			PRINT '13 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			SELECT	
				 T10.DIVIPOLA
				,T10.DEPARTAMENTO
				,T10.MUNICIPIOS
				,T10.SI_GUARDO
				,T10.NO_GUARDO
				,T10.SI_COM_REP
				,T10.NO_COM_REP
				,T10.SI_ENVIARON
				,T10.NO_ENVIARON
				,T10.SI_INFO_PLAN
				,T10.NO_INFO_PLAN
			FROM @Tabla10 T10
	
			PRINT '15 - ' + CONVERT(VARCHAR, GETDATE(), 113)

		END
		
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Reporte_Consolidado_Totales]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_Reporte_Consolidado_Totales]
END

GO

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ReporteConsolidadoTotales]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ReporteConsolidadoTotales] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================
-- Author:	Desarrolladores RUSICST - Ajustado por el equipo de desarrollo de la OIM (Nelson Restrepo)
-- Create date:	Desconocida - Update date : 30-03-2017
-- Description:	Procedimiento que retorna los datos para el informe consolidado. Se cambio de nombre para que estos
--				tengan coherencia con los nombres de los otros procedimientos. Se deja el procedimiento original que
--				estaba con el nombre reporte_ejecutivo2.
-- ==================================================================================================================
ALTER PROCEDURE [dbo].[C_ReporteConsolidadoTotales] 
		(
			@IdDepartamento INT, 
			@IdEncuesta INT
		)
		AS
			BEGIN 
	
			DECLARE @TipoEncuesta VARCHAR(50)
			DECLARE @CantidadRespuestasObligatorias INT
			
			SET @TipoEncuesta = (SELECT '%' + SUBSTRING(b.Nombre, 6, 11) + '%' FROM Encuesta a, TipoEncuesta b WHERE a.IdTipoEncuesta = b.Id AND (a.Id = @IdEncuesta))
			SET @CantidadRespuestasObligatorias = (SELECT COUNT (*) FROM Seccion INNER JOIN Pregunta ON Seccion.Id = Pregunta.IdSeccion WHERE Seccion.IdEncuesta = @IdEncuesta AND Pregunta.EsObligatoria = 1)

			PRINT '0 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @TablaUsuarioUno TABLE
			(
				Username VARCHAR(50)
			)			

			INSERT INTO @TablaUsuarioUno
			(
				Username
			)
			SELECT 
				Usuario Username
			FROM 
				(SELECT b.UserName Usuario, a.IdPregunta FROM Respuesta a, Usuario b WHERE a.IdUsuario = b.Id AND a.Valor != '-') Respuesta
				INNER JOIN (SELECT Id, IdSeccion FROM Pregunta WHERE EsObligatoria = 1) Pregunta ON Respuesta.IdPregunta = Pregunta.Id 
				INNER JOIN (SELECT Id, IdEncuesta FROM Seccion WHERE IdEncuesta = @IdEncuesta) Seccion ON Pregunta.IdSeccion = Seccion.Id
			GROUP BY 
				Usuario
			HAVING 
				(COUNT(DISTINCT IdPregunta) - @CantidadRespuestasObligatorias) = 0

			DECLARE @TablaUsuarioDos TABLE
			(
				Username VARCHAR(50)
			)

			INSERT INTO @TablaUsuarioDos
			SELECT 
				DISTINCT Respuesta.Usuario Username
			FROM 
				(SELECT b.UserName Usuario, a.IdPregunta FROM Respuesta a, Usuario b WHERE a.IdUsuario = b.Id AND b.UserName LIKE @TipoEncuesta) Respuesta
				INNER JOIN Pregunta ON Respuesta.IdPregunta = Pregunta.Id 
				INNER JOIN (SELECT Id FROM Seccion WHERE IdEncuesta = @IdEncuesta) Seccion ON Pregunta.IdSeccion = Seccion.Id

			DECLARE @TablaUsuarioTres TABLE
			(
				Username VARCHAR(50)
			)
			INSERT INTO @TablaUsuarioTres
			SELECT 
				DISTINCT b.UserName Usuario 
			FROM 
				Autoevaluacion2 a, Usuario b 
			WHERE 
				a.IdUsuario = b.Id
				AND (a.IdEncuesta = @IdEncuesta) 
				AND a.Recomendacion IS NOT NULL 
				AND LEN(a.Acciones) > 0

			DECLARE @FECFIN DATETIME 
			DECLARE @FECINI DATETIME
											 
			PRINT '1 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			IF EXISTS (	SELECT TOP 1 [FechaFin] FROM [PermisoUsuarioEncuesta] WHERE IdEncuesta = @IdEncuesta ORDER BY FechaFin DESC)
			BEGIN
				SET @FECFIN = (SELECT TOP 1 [FechaFin] FROM [PermisoUsuarioEncuesta] WHERE IdEncuesta = @IdEncuesta ORDER BY FechaFin DESC)
			END
			ELSE
				BEGIN
					SET @FECFIN =(SELECT FechaFin FROM Encuesta WHERE ID = @IdEncuesta)
				END
	
			SET @FECINI = (SELECT FechaInicio FROM Encuesta WHERE ID = @IdEncuesta) 
	
			PRINT '2 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			DECLARE @Tabla1 TABLE
			(
				divipola VARCHAR(50), 
				nombre VARCHAR(250), 
				municipio NUMERIC(38)
			)
	
			INSERT INTO @Tabla1 
			(
			divipola , 
			nombre , 
			municipio 
			)
			SELECT TOP (100) PERCENT 
				Departamento.Divipola, 
				Departamento.Nombre, 
				COUNT(DISTINCT Municipio.Divipola) AS municipio
			FROM 
				Departamento 
				INNER JOIN Municipio ON Departamento.Id = Municipio.IdDepartamento 
				INNER JOIN Usuario ON Departamento.Id = Usuario.IdDepartamento AND Municipio.Id = Usuario.IdMunicipio
			WHERE 
				Departamento.Divipola = (CASE WHEN @IdDepartamento = '-1' THEN Departamento.Divipola ELSE @IdDepartamento END)
			GROUP BY 
				Departamento.Divipola, Departamento.Nombre, Usuario.Activo
			HAVING 
				(Usuario.Activo = 1) 
			ORDER BY 
				Departamento.Nombre

			PRINT @TipoEncuesta

			PRINT '3 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			DECLARE @Tabla2 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla2 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				INNER JOIN @TablaUsuarioUno tu ON tu.Username = Usuario.Username
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
			WHERE 
				Departamento.Divipola = (CASE WHEN @IdDepartamento = '-1' THEN Departamento.Divipola ELSE @IdDepartamento END)
			GROUP BY 
				Departamento.Nombre, Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '4 - ' + CONVERT(VARCHAR, GETDATE(), 113)
		
			DECLARE @Tabla3 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC (38)
			)
	
			INSERT INTO @Tabla3 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
			WHERE 
				(Usuario.Username NOT IN 	(	SELECT 
														b.UserName Usuario 
													FROM 
														Respuesta a, Usuario b
													WHERE 
														a.IdUsuario = b.Id
														AND a.IdPregunta IN 	(	SELECT 
																						Pregunta.Id
																					FROM 
																						Seccion 
																						INNER JOIN Pregunta ON Seccion.Id = Pregunta.IdSeccion
																					WHERE 
																						(Seccion.IdEncuesta = @IdEncuesta) 
																						AND (Pregunta.EsObligatoria = 1)
																		)
													GROUP BY 
														b.UserName
													HAVING 
														(COUNT(*) - (	SELECT 
																			COUNT (*) 
																		FROM 
																			Seccion 
																			INNER JOIN Pregunta ON Seccion.Id = Pregunta.IdSeccion
																		WHERE 
																			(Seccion.IdEncuesta = @IdEncuesta) AND (Pregunta.EsObligatoria = 1)
																	) 
														) = 0
												)
					) 
				AND Departamento.Divipola = (CASE WHEN @IdDepartamento = '-1' THEN Departamento.Divipola ELSE @IdDepartamento END)
			GROUP BY 
				Departamento.Nombre, Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '5 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			DECLARE @Tabla4 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla4 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Usuario.Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
				WHERE 	
					Usuario.Username IN (SELECT Username FROM @TablaUsuarioTres)
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '6 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla5 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC(38)
			)
			INSERT INTO @Tabla5 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Usuario.Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Divipola 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Divipola
			WHERE 
				Usuario.Username NOT IN (SELECT Username FROM @TablaUsuarioTres)
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '7 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla6 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla6 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
			WHERE 
				(Usuario.Username IN 	(	SELECT 
												DISTINCT b.UserName Usuario
											FROM 
												Envio a, Usuario b
											WHERE 
												a.IdUsuario = b.Id
												AND (a.IdEncuesta = @IdEncuesta)
										)
					) 
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '8 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla7 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(35)
			)
	
			INSERT INTO @Tabla7 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
			WHERE 
				(Usuario.Username NOT IN 	(	SELECT 
													DISTINCT b.UserName Usuario
												FROM 
													Envio a, Usuario b
												WHERE 
													a.IdUsuario = b.Id
													AND (a.IdEncuesta = @IdEncuesta)
											)
					) 
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '9 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla8 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC(38)
			)
	
			INSERT INTO @Tabla8 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			--IF OBJECT_ID('tempdb..@TABLA8') IS NOT NULL DROP TABLE @TABLA8
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				INNER JOIN @TablaUsuarioDos td ON Usuario.Username = td.Username
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '10 - ' + CONVERT(VARCHAR, GETDATE(), 113)
		
			DECLARE @Tabla9 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla9 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario
				LEFT OUTER JOIN Municipio ON Usuario.IdMunicipio = Municipio.Id 
				LEFT OUTER JOIN Departamento ON Usuario.IdDepartamento = Departamento.Id
			WHERE 
				Usuario.Username NOT IN (SELECT Username FROM @TablaUsuarioDos)
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '11 - ' + CONVERT(VARCHAR, GETDATE(), 113)
		
			DECLARE @Tabla10 TABLE
			(
				DIVIPOLA VARCHAR (250),
				DEPARTAMENTO VARCHAR (250), 
				MUNICIPIOS VARCHAR (250), 
				SI_GUARDO VARCHAR (250),
				NO_GUARDO VARCHAR (250),
				SI_COM_REP VARCHAR (250),
				NO_COM_REP VARCHAR (250),
				SI_ENVIARON VARCHAR (250),
				NO_ENVIARON VARCHAR (250),
				SI_INFO_PLAN VARCHAR (250),
				NO_INFO_PLAN VARCHAR (250)
			)

			INSERT INTO @Tabla10 
			(
				DIVIPOLA,
				DEPARTAMENTO, 
				MUNICIPIOS, 
				SI_GUARDO,
				NO_GUARDO,
				SI_COM_REP,
				NO_COM_REP,
				SI_ENVIARON,
				NO_ENVIARON,
				SI_INFO_PLAN,
				NO_INFO_PLAN 
			)
			SELECT
				tab1.Divipola AS DIVIPOLA,
				tab1.Nombre AS DEPARTAMENTO, 
				(tab1.municipio) AS MUNICIPIOS, 
				(tab8.TOTAL_ENVIO) AS SI_GUARDO,
				(tab9.TOTAL_ENVIO) AS NO_GUARDO,
				(tab2.TOTAL_ENVIO) AS SI_COM_REP,
				(tab3.TOTAL_ENVIO) AS NO_COM_REP,
				(tab6.TOTAL_ENVIO) AS SI_ENVIARON,
				(tab7.TOTAL_ENVIO) AS NO_ENVIARON,
				(tab4.TOTAL_ENVIO) AS SI_INFO_PLAN,
				(tab5.TOTAL_ENVIO) AS NO_INFO_PLAN 
			FROM 
				@Tabla1 tab1
				LEFT OUTER JOIN @TABLA2 tab2 on tab1.Divipola = tab2.Divipola 
				LEFT OUTER JOIN @TABLA3 tab3 on tab1.Divipola = tab3.Divipola 
				LEFT OUTER JOIN @TABLA4 tab4 on tab1.Divipola = tab4.Divipola 
				LEFT OUTER JOIN @TABLA5 tab5 on tab1.Divipola = tab5.Divipola 
				LEFT OUTER JOIN @TABLA6 tab6 on tab1.Divipola = tab6.Divipola 
				LEFT OUTER JOIN @TABLA7 tab7 on tab1.Divipola = tab7.Divipola 
				LEFT OUTER JOIN @TABLA8 tab8 on tab1.Divipola = tab8.Divipola 
				LEFT OUTER JOIN @TABLA9 tab9 on tab1.Divipola = tab9.Divipola 

			PRINT '12 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			--SELECT * FROM @Tabla10
	
			PRINT '13 - ' + CONVERT(VARCHAR, GETDATE(), 113)
			DECLARE @Tabla11 TABLE
			(
			ENTIDADES NUMERIC,
			SI_GUARDO NUMERIC, 
			NO_GUARDO NUMERIC,
			SI_COM_REP NUMERIC,
			NO_COM_REP NUMERIC,
			SI_ENVIARON NUMERIC,
			NO_ENVIARON NUMERIC,
			SI_INFO_PLAN NUMERIC,
			NO_INFO_PLAN NUMERIC
			)
	
			INSERT INTO @Tabla11 
			(
				ENTIDADES,
				SI_GUARDO, 
				NO_GUARDO, 
				SI_COM_REP,
				NO_COM_REP,
				SI_ENVIARON,
				NO_ENVIARON,
				SI_INFO_PLAN,
				NO_INFO_PLAN 
			)
			SELECT
				SUM(ISNULL(tab1.municipio,0)) AS ENTIDADES, 
				SUM(ISNULL(tab8.TOTAL_ENVIO,0)) AS SI_GUARDO,
				SUM(ISNULL(tab9.TOTAL_ENVIO,0)) AS NO_GUARDO,
				SUM(ISNULL(tab2.TOTAL_ENVIO,0)) AS SI_COM_REP,
				SUM(ISNULL(tab3.TOTAL_ENVIO,0)) AS NO_COM_REP,
				SUM(ISNULL(tab6.TOTAL_ENVIO,0)) AS SI_ENVIARON,
				SUM(ISNULL(tab7.TOTAL_ENVIO,0)) AS NO_ENVIARON,
				SUM(ISNULL(tab4.TOTAL_ENVIO,0)) AS SI_INFO_PLAN,
				SUM(ISNULL(tab5.TOTAL_ENVIO,0)) AS NO_INFO_PLAN 
			FROM 
				@Tabla1 tab1
				LEFT OUTER JOIN @TABLA2 tab2 on tab1.Divipola = tab2.Divipola 
				LEFT OUTER JOIN @TABLA3 tab3 on tab1.Divipola = tab3.Divipola 
				LEFT OUTER JOIN @TABLA4 tab4 on tab1.Divipola = tab4.Divipola 
				LEFT OUTER JOIN @TABLA5 tab5 on tab1.Divipola = tab5.Divipola 
				LEFT OUTER JOIN @TABLA6 tab6 on tab1.Divipola = tab6.Divipola 
				LEFT OUTER JOIN @TABLA7 tab7 on tab1.Divipola = tab7.Divipola 
				LEFT OUTER JOIN @TABLA8 tab8 on tab1.Divipola = tab8.Divipola 
				LEFT OUTER JOIN @TABLA9 tab9 on tab1.Divipola = tab9.Divipola 

			PRINT '14 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			SELECT	
				T11.ENTIDADES
				,T11.SI_GUARDO ENT_SI_GUARDO
				,T11.NO_GUARDO ENT_NO_GUARDO
				,T11.SI_COM_REP ENT_SI_COM_REP
				,T11.NO_COM_REP ENT_NO_COM_REP
				,T11.SI_ENVIARON ENT_SI_ENVIARON
				,T11.NO_ENVIARON ENT_NO_ENVIARON
				,T11.SI_INFO_PLAN ENT_SI_INFO_PLAN
				,T11.NO_INFO_PLAN ENT_NO_INFO_PLAN
			FROM @Tabla11 T11
	
			PRINT '15 - ' + CONVERT(VARCHAR, GETDATE(), 113)

		END

