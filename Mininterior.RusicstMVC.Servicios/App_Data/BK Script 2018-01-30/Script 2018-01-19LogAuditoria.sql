
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXCategoriaExportar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_LogXCategoriaExportar] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		John Betancourt A. - OIM
-- Create date: 19-01-2017
-- Description:	Procedimiento que consulta la información del Log para exportar
-- =============================================
ALTER PROCEDURE [dbo].[C_LogXCategoriaExportar] 
	
	@IdCategoria INT = NULL,
	@UserName VARCHAR(255),
	@FechaInicio DATETIME,
	@FechaFin DATETIME

AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		 [L].[LogID]
		,[L].[Title] Usuario
		,CAST([L].[Timestamp] as VARCHAR) Fecha
		,[C].[CategoryName] Categoria
		,[Message] UrlYBrowser
		,[FormattedMessage] Mensaje
	FROM 
		[dbo].[CategoryLog] CL
		INNER JOIN [dbo].[Log] L ON [CL].[LogID] = [L].[LogID]
		INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
	WHERE 
		(@UserName IS NULL OR ([L].[Title] = @UserName))
		AND (@IdCategoria IS NULL OR ([CL].[CategoryID] = @IdCategoria) AND [C].[Ordinal] <> 1)
		AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
	ORDER BY [L].[Timestamp] DESC
END

GO
