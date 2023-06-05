IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXCategoria]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_LogXCategoria] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Equipo de desarrollo - OIM (Christian Ospina)
-- Modifica:	Equipo de desarrollo - OIM - Andrés Bonilla
-- Modifica:	Equipo de desarrollo - OIM - John Betancourt A.
-- Create date: 18-09-2017
-- Modify date: 24-01-2018
-- Modify date: 12-02-2018
-- Description:	Procedimiento que consulta la información del Log
-- Modification: Se modifica el rendimiento del sp incluyendo condiciones IF en vez de las anteriores en el where
--				 que hacian el procedimiento bastante lento y no concluyente con los datos reales.
-- =============================================
ALTER PROCEDURE [dbo].[C_LogXCategoria] 
	
	@IdCategoria INT = NULL,
	@UserName VARCHAR(255) = NULL,
	@FechaInicio DATETIME,
	@FechaFin DATETIME

AS
BEGIN

	IF (CONVERT(VARCHAR, @FechaInicio, 101) < CONVERT(VARCHAR, CONVERT(DATETIME, '2018-01-01 00:00:00'), 101))
		SET @FechaInicio = CONVERT(DATETIME, '2018-01-01 00:00:00')

	SET NOCOUNT ON;


	IF @UserName IS NULL AND @IdCategoria IS NULL
	BEGIN
		SELECT 
			 TOP 1000 C1.[LogID]
			,C1.Usuario
			,CAST(C1.Fecha as VARCHAR) Fecha
			,C1.Categoria
			,C1.UrlYBrowser	
			FROM (
			SELECT 
				 TOP 1000 [L].[LogID]
				,[L].[Title] Usuario
				,[L].[Timestamp] Fecha
				,[C].[CategoryName] Categoria
				,[Message] UrlYBrowser		
			FROM 
				[rusicst_log].[dbo].[Log] L
				INNER JOIN [rusicst_log].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
				INNER JOIN [rusicst_log].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
			WHERE 
				[C].[Ordinal] <> 1
				--AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
				AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin

			UNION all

			SELECT 
				 TOP 1000 [L].[LogID]
				,[L].[Title] Usuario
				,[L].[Timestamp] Fecha
				,[C].[CategoryName] Categoria
				,[Message] UrlYBrowser		
			FROM 
				[rusicst_log_BACKUP].[dbo].[Log] L
				INNER JOIN [rusicst_log_BACKUP].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
				INNER JOIN [rusicst_log_BACKUP].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
			WHERE 
				[C].[Ordinal] <> 1
				--AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
				AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
		) C1
		ORDER BY C1.Fecha DESC

	END
	ELSE IF @UserName IS NULL AND @IdCategoria IS NOT NULL
	BEGIN
		SELECT 
			 TOP 1000 C1.[LogID]
			,C1.Usuario
			,CAST(C1.Fecha as VARCHAR) Fecha
			,C1.Categoria
			,C1.UrlYBrowser	
			FROM (
				SELECT 
					 TOP 1000 [L].[LogID]
					,[L].[Title] Usuario
					,[L].[Timestamp] Fecha
					,[C].[CategoryName] Categoria
					,[Message] UrlYBrowser		
				FROM 
					[rusicst_log].[dbo].[Log] L
					INNER JOIN [rusicst_log].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
					INNER JOIN [rusicst_log].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
				WHERE 
					[CL].[CategoryID] = @IdCategoria
					AND [C].[Ordinal] <> 1
					--AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
					AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin

				UNION ALL

				SELECT 
					 TOP 1000 [L].[LogID]
					,[L].[Title] Usuario
					,[L].[Timestamp] Fecha
					,[C].[CategoryName] Categoria
					,[Message] UrlYBrowser		
				FROM 
					[rusicst_log_BACKUP].[dbo].[Log] L
					INNER JOIN [rusicst_log_BACKUP].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
					INNER JOIN [rusicst_log_BACKUP].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
				WHERE 
					[CL].[CategoryID] = @IdCategoria
					AND [C].[Ordinal] <> 1
					--AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
					AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
		) C1
		ORDER BY C1.Fecha DESC

	END
	ELSE IF @UserName IS NOT NULL AND @IdCategoria IS NULL
	BEGIN
		SELECT 
			 TOP 1000 C1.[LogID]
			,C1.Usuario
			,CAST(C1.Fecha as VARCHAR) Fecha
			,C1.Categoria
			,C1.UrlYBrowser	
			FROM (
				SELECT 
					 TOP 1000 [L].[LogID]
					,[L].[Title] Usuario
					,[L].[Timestamp] Fecha
					,[C].[CategoryName] Categoria
					,[Message] UrlYBrowser		
				FROM 
					[rusicst_log].[dbo].[Log] L
					INNER JOIN [rusicst_log].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
					INNER JOIN [rusicst_log].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
				WHERE 
					[L].[Title] = @UserName
					AND [C].[Ordinal] <> 1
					--AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
					AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin

				UNION ALL

				SELECT 
					 TOP 1000 [L].[LogID]
					,[L].[Title] Usuario
					,[L].[Timestamp] Fecha
					,[C].[CategoryName] Categoria
					,[Message] UrlYBrowser		
				FROM 
					[rusicst_log_BACKUP].[dbo].[Log] L
					INNER JOIN [rusicst_log_BACKUP].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
					INNER JOIN [rusicst_log_BACKUP].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
				WHERE 
					[CL].[CategoryID] = @IdCategoria
					AND [C].[Ordinal] <> 1
					--AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
					AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
		) C1
		ORDER BY C1.Fecha DESC

	END
	ELSE IF @UserName IS NOT NULL AND @IdCategoria IS NOT NULL
	BEGIN
		SELECT 
			 TOP 1000 C1.[LogID]
			,C1.Usuario
			,CAST(C1.Fecha as VARCHAR) Fecha
			,C1.Categoria
			,C1.UrlYBrowser	
			FROM (
				SELECT 
					 TOP 1000 [L].[LogID]
					,[L].[Title] Usuario
					,[L].[Timestamp] Fecha
					,[C].[CategoryName] Categoria
					,[Message] UrlYBrowser		
				FROM 
					[rusicst_log].[dbo].[Log] L
					INNER JOIN [rusicst_log].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
					INNER JOIN [rusicst_log].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
				WHERE 
					[L].[Title] = @UserName
					AND [CL].[CategoryID] = @IdCategoria
					AND [C].[Ordinal] <> 1
					--AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
					AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin

				UNION ALL

				SELECT 
					 TOP 1000 [L].[LogID]
					,[L].[Title] Usuario
					,[L].[Timestamp] Fecha
					,[C].[CategoryName] Categoria
					,[Message] UrlYBrowser		
				FROM 
					[rusicst_log_BACKUP].[dbo].[Log] L
					INNER JOIN [rusicst_log_BACKUP].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
					INNER JOIN [rusicst_log_BACKUP].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
				WHERE 
					[L].[Title] = @UserName
					AND [CL].[CategoryID] = @IdCategoria
					AND [C].[Ordinal] <> 1
					--AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
					AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
					) C1
		ORDER BY C1.Fecha DESC
	END

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXCategoriaExportar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_LogXCategoriaExportar] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  John Betancourt A. - OIM  
-- Modifica: Equipo de desarrollo - OIM - Andrés Bonilla  
-- Create date: 19-01-2017  
-- Modify date: 24-01-2018  
-- Description: Procedimiento que consulta la información del Log para exportar  
-- Modification: Se modifica el rendimiento del sp incluyendo condiciones IF en vez de las anteriores en el where  
--     que hacian el procedimiento lento y no concluyente con los datos reales.  
-- =============================================  
ALTER PROCEDURE [dbo].[C_LogXCategoriaExportar]   
   
 @IdCategoria INT = NULL,  
 @UserName VARCHAR(255) NULL,  
 @FechaInicio DATETIME,  
 @FechaFin DATETIME  
  
AS  
BEGIN  
   
 SET NOCOUNT ON;  
  
 IF @UserName IS NULL AND @IdCategoria IS NULL  
 BEGIN
		SELECT 
			 C1.[LogID]
			,C1.Usuario
			,CAST(C1.Fecha as VARCHAR) Fecha
			,C1.Categoria
			,C1.UrlYBrowser	
			,C1.Mensaje
			FROM (
			SELECT 
				 [L].[LogID]
				,[L].[Title] Usuario
				,[L].[Timestamp] Fecha
				,[C].[CategoryName] Categoria
				,[Message] UrlYBrowser		
				,[FormattedMessage] Mensaje
			FROM 
				[rusicst_log].[dbo].[Log] L
				INNER JOIN [rusicst_log].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
				INNER JOIN [rusicst_log].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
			WHERE 
				[C].[Ordinal] <> 1
				AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin

			UNION all

			SELECT 
				 [L].[LogID]
				,[L].[Title] Usuario
				,[L].[Timestamp] Fecha
				,[C].[CategoryName] Categoria
				,[Message] UrlYBrowser	
				,[FormattedMessage] Mensaje	
			FROM 
				[rusicst_log_BACKUP].[dbo].[Log] L
				INNER JOIN [rusicst_log_BACKUP].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
				INNER JOIN [rusicst_log_BACKUP].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
			WHERE 
				[C].[Ordinal] <> 1
				AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
		) C1
		ORDER BY C1.Fecha DESC
	END
 ELSE IF @UserName IS NULL AND @IdCategoria IS NOT NULL  
 BEGIN
		SELECT 
			 C1.[LogID]
			,C1.Usuario
			,CAST(C1.Fecha as VARCHAR) Fecha
			,C1.Categoria
			,C1.UrlYBrowser	
			,C1.Mensaje
			FROM (
				SELECT 
					 [L].[LogID]
					,[L].[Title] Usuario
					,[L].[Timestamp] Fecha
					,[C].[CategoryName] Categoria
					,[Message] UrlYBrowser
					,[FormattedMessage] Mensaje		
				FROM 
					[rusicst_log].[dbo].[Log] L
					INNER JOIN [rusicst_log].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
					INNER JOIN [rusicst_log].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
				WHERE 
					[CL].[CategoryID] = @IdCategoria
					AND [C].[Ordinal] <> 1
					AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin

				UNION ALL

				SELECT 
					 [L].[LogID]
					,[L].[Title] Usuario
					,[L].[Timestamp] Fecha
					,[C].[CategoryName] Categoria
					,[Message] UrlYBrowser		
					,[FormattedMessage] Mensaje
				FROM 
					[rusicst_log_BACKUP].[dbo].[Log] L
					INNER JOIN [rusicst_log_BACKUP].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
					INNER JOIN [rusicst_log_BACKUP].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
				WHERE 
					[CL].[CategoryID] = @IdCategoria
					AND [C].[Ordinal] <> 1
					AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
		) C1
		ORDER BY C1.Fecha DESC

	END  
 ELSE IF @UserName IS NOT NULL AND @IdCategoria IS NULL
	BEGIN
		SELECT C1.[LogID]
			,C1.Usuario
			,CAST(C1.Fecha as VARCHAR) Fecha
			,C1.Categoria
			,C1.UrlYBrowser	
			,C1.Mensaje
			FROM (
				SELECT 
					 [L].[LogID]
					,[L].[Title] Usuario
					,[L].[Timestamp] Fecha
					,[C].[CategoryName] Categoria
					,[Message] UrlYBrowser
					,[FormattedMessage] Mensaje		
				FROM 
					[rusicst_log].[dbo].[Log] L
					INNER JOIN [rusicst_log].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
					INNER JOIN [rusicst_log].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
				WHERE 
					[L].[Title] = @UserName
					AND [C].[Ordinal] <> 1
					AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin

				UNION ALL

				SELECT 
					 [L].[LogID]
					,[L].[Title] Usuario
					,[L].[Timestamp] Fecha
					,[C].[CategoryName] Categoria
					,[Message] UrlYBrowser
					,[FormattedMessage] Mensaje		
				FROM 
					[rusicst_log_BACKUP].[dbo].[Log] L
					INNER JOIN [rusicst_log_BACKUP].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
					INNER JOIN [rusicst_log_BACKUP].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
				WHERE 
					[CL].[CategoryID] = @IdCategoria
					AND [C].[Ordinal] <> 1
					AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
		) C1
		ORDER BY C1.Fecha DESC

	END
 ELSE IF @UserName IS NOT NULL AND @IdCategoria IS NOT NULL  
 BEGIN
		SELECT 
			 C1.[LogID]
			,C1.Usuario
			,CAST(C1.Fecha as VARCHAR) Fecha
			,C1.Categoria
			,C1.UrlYBrowser	
			,C1.Mensaje
			FROM (
				SELECT 
					 [L].[LogID]
					,[L].[Title] Usuario
					,[L].[Timestamp] Fecha
					,[C].[CategoryName] Categoria
					,[Message] UrlYBrowser		
					,[FormattedMessage] Mensaje
				FROM 
					[rusicst_log].[dbo].[Log] L
					INNER JOIN [rusicst_log].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
					INNER JOIN [rusicst_log].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
				WHERE 
					[L].[Title] = @UserName
					AND [CL].[CategoryID] = @IdCategoria
					AND [C].[Ordinal] <> 1
					AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin

				UNION ALL

				SELECT 
					 [L].[LogID]
					,[L].[Title] Usuario
					,[L].[Timestamp] Fecha
					,[C].[CategoryName] Categoria
					,[Message] UrlYBrowser	
					,[FormattedMessage] Mensaje	
				FROM 
					[rusicst_log_BACKUP].[dbo].[Log] L
					INNER JOIN [rusicst_log_BACKUP].[dbo].[CategoryLog] CL ON [CL].[LogID] = [L].[LogID]
					INNER JOIN [rusicst_log_BACKUP].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
				WHERE 
					[L].[Title] = @UserName
					AND [CL].[CategoryID] = @IdCategoria
					AND [C].[Ordinal] <> 1
					AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
					) C1
		ORDER BY C1.Fecha DESC
	END
END  