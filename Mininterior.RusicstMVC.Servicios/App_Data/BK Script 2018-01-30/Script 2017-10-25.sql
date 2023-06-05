GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaCategory]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaCategory] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 07/10/2017
-- Description:	Selecciona la información de categoría o acciones relacionadas con la auditoría
-- =============================================
ALTER PROCEDURE [dbo].[C_ListaCategory] 

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			 [CategoryID]
			,[CategoryName]
		FROM
			[dbo].[Category]
		WHERE
			[Ordinal] <> 1
		ORDER BY 
			[CategoryName]

	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXCategoria]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_LogXCategoria] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo - OIM (Christian Ospina)
-- Create date: 18-09-2017
-- Description:	Procedimiento que consulta la información del Log
-- =============================================
ALTER PROCEDURE [dbo].[C_LogXCategoria] 
	
	@IdCategoria INT = NULL,
	@UserName VARCHAR(255),
	@FechaInicio DATETIME,
	@FechaFin DATETIME

AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		 TOP 1000 [L].[LogID]
		,[L].[Title] Usuario
		,CAST([L].[Timestamp] as VARCHAR) Fecha
		,[C].[CategoryName] Categoria
		,[Message] UrlYBrowser		
	FROM 
		[dbo].[CategoryLog] CL
		INNER JOIN [dbo].[Log] L ON [CL].[LogID] = [L].[LogID]
		INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
	WHERE 
		(@UserName IS NULL OR ([L].[Title] = @UserName))
		AND (@IdCategoria IS NULL OR ([CL].[CategoryID] = @IdCategoria) AND [C].[Ordinal] <> 1)
		AND [L].Timestamp BETWEEN @FechaInicio AND @FechaFin

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
--Fecha Modificacion: 2017-10-25
--Modifica: Andrés Bonilla																		 
--Descripcion:	Trae el listado de las preguntas para llenar la rejilla de modificar 
--				preguntas de acuerdo a filtro seleccionado El idGrupo es obligatorio y traera la mayor cantidad
--				de preguntas. Entre mas especifica sea la consulta, será mas especifico el resultado								
--Modificacion: Se agregan los filtros IdPregunta y CodigoPreguntaBanco para buscar por código único
--				o por código del banco de preguntas
--******************************************************************************************************/
ALTER PROCEDURE [dbo].[C_PreguntasSeccionEncuesta] 

	@idEncuesta		INT = NULL,
	@idGrupo		INT = NULL, 
	@idseccion		INT = NULL,
	@idSubseccion	INT = NULL,
	@nombrePregunta VARCHAR(400) = NULL,
	@idPregunta INT = NULL,
	@codigoBanco varchar(20) = NULL

AS

	SET NOCOUNT ON;	

	IF(@idSubseccion IS NULL AND @idseccion IS NULL AND @idEncuesta IS NOT NULL AND @idGrupo IS NOT NULL)
		BEGIN
		print '1'
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

	ELSE IF (@idSubseccion IS NULL AND @idEncuesta IS NOT NULL AND @idseccion IS NOT NULL)
		BEGIN
		print '2'
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
	ELSE IF (@idEncuesta IS NOT NULL AND @idSubseccion IS NOT NULL)
		 BEGIN
		 print '3'
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
	ELSE IF (@idPregunta IS NOT NULL)
		 BEGIN
		 print '4'
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
				a.Id = @idPregunta
		END	
	ELSE IF (@idEncuesta IS NOT NULL AND @codigoBanco IS NOT NULL)
		 BEGIN
		 print '5'
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
			AND e.CodigoPregunta = @codigoBanco
		END	

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DibujarPreguntasSeccion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarPreguntasSeccion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[C_DibujarPreguntasSeccion]

	 @IdSeccion	INT
	 ,@IdUsuario INT

AS
BEGIN

if @IdUsuario IS NULL
begin

	SELECT 
		P.[Id]	
		,[IdSeccion]
		,P.[Nombre]
		,[RowIndex]
		,[ColumnIndex]
		,TP.[Nombre] AS TipoPregunta
		,p.[Ayuda]
		,[EsObligatoria]
		,[EsMultiple]
		,[SoloSi]
		,[Texto]
		,'' AS Respuesta
		,S.IdEncuesta
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC
end
else
begin

	SELECT 
		P.[Id]	
		,[IdSeccion]
		,P.[Nombre]
		,[RowIndex]
		,[ColumnIndex]
		,TP.[Nombre] AS TipoPregunta
		,p.[Ayuda]
		,[EsObligatoria]
		,[EsMultiple]
		,[SoloSi]
		,[Texto]
		,CASE WHEN TP.[Nombre] = 'FECHA' THEN dbo.[ParseDateRespuesta](replace(LEFT(r.Valor, 10), '/', '-')) ELSE r.Valor END  as Respuesta
		,S.IdEncuesta
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
	LEFT OUTER JOIN [dbo].Respuesta r ON r.IdPregunta = p.Id and r.IdUsuario = @IdUsuario
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC

end
END

GO