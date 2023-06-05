
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogOld]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_LogOld] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  John Betancourt - OIM
-- Create date: 14/02/2018 
-- Description: Selecciona la información de la auditoría por ID  
-- =============================================  
ALTER PROCEDURE [dbo].[C_LogOld]   
  
 @LogID INT  
  
AS  
 BEGIN  
   
  SET NOCOUNT ON;  
  
  SELECT   
     [LogID]  
    ,[EventID]  
    ,[Priority]  
    ,[Severity]  
    ,[Title]  
    ,[Timestamp]  
    ,[MachineName]  
    ,[AppDomainName]  
    ,[ProcessID]  
    ,[ProcessName]  
    ,[ThreadName]  
    ,[Win32ThreadId]  
    ,[Message]  
    ,[FormattedMessage]      
  FROM  
   [dbo].[Log]  
  WHERE  
   [LogID] = @LogID  
  
 END  
  
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaCategoryLogOld]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaCategoryLogOld] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  John Betancourt - OIM
-- Create date: 14/02/2018
-- Description: Selecciona la información de categoría o acciones relacionadas con la auditoría  
-- =============================================  
ALTER PROCEDURE [dbo].[C_ListaCategoryLogOld]   
  
AS  
 BEGIN  
   
  SET NOCOUNT ON;  
  
  SELECT   
    [CategoryID]  
   ,[CategoryName]  
  FROM  
   [dbo].[Category]  
  ORDER BY   
   [CategoryName]  
  
 END  
 
 GO

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXCategoriaExportarOld]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_LogXCategoriaExportarOld] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		John Betancourt A. - OIM
-- Create date: 14-02-2018
-- Description:	Procedimiento que consulta la información del Log para exportar
-- =============================================
ALTER PROCEDURE [dbo].[C_LogXCategoriaExportarOld] 
	
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
		AND (@IdCategoria IS NULL OR ([CL].[CategoryID] = @IdCategoria))
		AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
	ORDER BY [L].[Timestamp] DESC
END

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXCategoriaOld]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_LogXCategoriaOld] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Modifica:	Equipo de desarrollo - OIM - John Betancourt A.
-- Create date: 14-02-2018
-- Description:	Procedimiento que consulta la información del Log Viejo
-- Modification: Se modifica el rendimiento del sp incluyendo condiciones IF en vez de las anteriores en el where
--				 que hacian el procedimiento bastante lento y no concluyente con los datos reales.
-- =============================================
ALTER PROCEDURE [dbo].[C_LogXCategoriaOld] 
	
	@IdCategoria INT = NULL,
	@UserName VARCHAR(255),
	@FechaInicio DATETIME,
	@FechaFin DATETIME

AS
BEGIN

	IF (CONVERT(VARCHAR, @FechaFin, 101) > '2018-01-01 00:00:00')
		SET @FechaFin = '2017-12-31 23:59:59'

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
			CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
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
			AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
		ORDER BY [L].[Timestamp] DESC
	END

END

GO