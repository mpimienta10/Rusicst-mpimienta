IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXCategoriaExportar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_LogXCategoriaExportar] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		John Betancourt A. - OIM
-- Modifica:	Equipo de desarrollo - OIM - Andrés Bonilla
-- Create date: 19-01-2017
-- Modify date: 24-01-2018
-- Description:	Procedimiento que consulta la información del Log para exportar
-- Modification: Se modifica el rendimiento del sp incluyendo condiciones IF en vez de las anteriores en el where
--				 que hacian el procedimiento lento y no concluyente con los datos reales.
-- =============================================
ALTER PROCEDURE [dbo].[C_LogXCategoriaExportar] 
	
	@IdCategoria INT = NULL,
	@UserName VARCHAR(255),
	@FechaInicio DATETIME,
	@FechaFin DATETIME

AS
BEGIN
	
	SET NOCOUNT ON;

	IF @UserName IS NULL AND @IdCategoria IS NULL
	BEGIN

		SELECT 
			 TOP 1000 [L].[LogID]
			,[L].[Title] Usuario
			,CAST([L].[Timestamp] as VARCHAR) Fecha
			,[C].[CategoryName] Categoria
			,[Message] UrlYBrowser	
			,[FormattedMessage] Mensaje	
		FROM 
			[dbo].[Log] L
			INNER JOIN [dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
			INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
		WHERE 
			[C].[Ordinal] <> 1
			AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
		ORDER BY [L].[Timestamp] DESC

	END
	ELSE IF @UserName IS NULL AND @IdCategoria IS NOT NULL
	BEGIN

		SELECT 
			 TOP 1000 [L].[LogID]
			,[L].[Title] Usuario
			,CAST([L].[Timestamp] as VARCHAR) Fecha
			,[C].[CategoryName] Categoria
			,[Message] UrlYBrowser	
			,[FormattedMessage] Mensaje	
		FROM 
			[dbo].[Log] L
			INNER JOIN [dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
			INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
		WHERE 
			[CL].[CategoryID] = @IdCategoria
			AND [C].[Ordinal] <> 1
			AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
		ORDER BY [L].[Timestamp] DESC

	END
	ELSE IF @UserName IS NOT NULL AND @IdCategoria IS NOT NULL
	BEGIN

		SELECT 
			 TOP 1000 [L].[LogID]
			,[L].[Title] Usuario
			,CAST([L].[Timestamp] as VARCHAR) Fecha
			,[C].[CategoryName] Categoria
			,[Message] UrlYBrowser	
			,[FormattedMessage] Mensaje	
		FROM 
			[dbo].[Log] L
			INNER JOIN [dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
			INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
		WHERE 
			[L].[Title] = @UserName
			AND [CL].[CategoryID] = @IdCategoria
			AND [C].[Ordinal] <> 1
			AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
		ORDER BY [L].[Timestamp] DESC
	END
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
-- Modifica:	Equipo de desarrollo - OIM - Andrés Bonilla
-- Create date: 18-09-2017
-- Modify date: 24-01-2018
-- Description:	Procedimiento que consulta la información del Log
-- Modification: Se modifica el rendimiento del sp incluyendo condiciones IF en vez de las anteriores en el where
--				 que hacian el procedimiento bastante lento y no concluyente con los datos reales.
-- =============================================
ALTER PROCEDURE [dbo].[C_LogXCategoria] 
	
	@IdCategoria INT = NULL,
	@UserName VARCHAR(255),
	@FechaInicio DATETIME,
	@FechaFin DATETIME

AS
BEGIN

	
	SET NOCOUNT ON;


	IF @UserName IS NULL AND @IdCategoria IS NULL
	BEGIN

		SELECT 
			 TOP 1000 [L].[LogID]
			,[L].[Title] Usuario
			,CAST([L].[Timestamp] as VARCHAR) Fecha
			,[C].[CategoryName] Categoria
			,[Message] UrlYBrowser		
		FROM 
			[dbo].[Log] L
			INNER JOIN [dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
			INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
		WHERE 
			[C].[Ordinal] <> 1
			AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
		ORDER BY [L].[Timestamp] DESC

	END
	ELSE IF @UserName IS NULL AND @IdCategoria IS NOT NULL
	BEGIN

		SELECT 
			 TOP 1000 [L].[LogID]
			,[L].[Title] Usuario
			,CAST([L].[Timestamp] as VARCHAR) Fecha
			,[C].[CategoryName] Categoria
			,[Message] UrlYBrowser		
		FROM 
			[dbo].[Log] L
			INNER JOIN [dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
			INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
		WHERE 
			[CL].[CategoryID] = @IdCategoria
			AND [C].[Ordinal] <> 1
			AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
		ORDER BY [L].[Timestamp] DESC

	END
	ELSE IF @UserName IS NOT NULL AND @IdCategoria IS NOT NULL
	BEGIN

		SELECT 
			 TOP 1000 [L].[LogID]
			,[L].[Title] Usuario
			,CAST([L].[Timestamp] as VARCHAR) Fecha
			,[C].[CategoryName] Categoria
			,[Message] UrlYBrowser		
		FROM 
			[dbo].[Log] L
			INNER JOIN [dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
			INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
		WHERE 
			[L].[Title] = @UserName
			AND [CL].[CategoryID] = @IdCategoria
			AND [C].[Ordinal] <> 1
			AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
		ORDER BY [L].[Timestamp] DESC
	END

END