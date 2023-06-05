
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
	@UserName VARCHAR(255),
	@FechaInicio DATETIME,
	@FechaFin DATETIME

AS
BEGIN

	IF (CONVERT(VARCHAR, @FechaInicio, 101) < '2018-01-01 00:00:00')
		SET @FechaInicio = '2018-01-01 00:00:01'

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
				AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)

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
				AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
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
					AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)

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
					AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
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
					AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)

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
					AND CONVERT(VARCHAR, [L].[Timestamp], 101) BETWEEN CONVERT(VARCHAR, @FechaInicio, 101) AND CONVERT(VARCHAR, @FechaFin, 101)
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
			 C1.[LogID]
			,C1.Usuario
			,CAST(C1.Fecha as VARCHAR) Fecha
			,C1.Categoria
			,C1.UrlYBrowser	
			FROM (
					SELECT 
						 [L].[LogID]
						,[L].[Title] Usuario
						,CAST([L].[Timestamp] as VARCHAR) Fecha
						,[C].[CategoryName] Categoria
						,[Message] UrlYBrowser
						,[FormattedMessage] Mensaje
					FROM 
						[rusicst_log].[dbo].[CategoryLog] CL
						INNER JOIN [rusicst_log].[dbo].[Log] L ON [CL].[LogID] = [L].[LogID]
						INNER JOIN [rusicst_log].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
					WHERE 
						(@UserName IS NULL OR ([L].[Title] = @UserName))
						AND (@IdCategoria IS NULL OR ([CL].[CategoryID] = @IdCategoria) AND [C].[Ordinal] <> 1)
						AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin

						UNION ALL

						SELECT 
						 [L].[LogID]
						,[L].[Title] Usuario
						,CAST([L].[Timestamp] as VARCHAR) Fecha
						,[C].[CategoryName] Categoria
						,[Message] UrlYBrowser
						,[FormattedMessage] Mensaje
					FROM 
						[rusicst_log_BACKUP].[dbo].[CategoryLog] CL
						INNER JOIN [rusicst_log_BACKUP].[dbo].[Log] L ON [CL].[LogID] = [L].[LogID]
						INNER JOIN [rusicst_log_BACKUP].[dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
					WHERE 
						(@UserName IS NULL OR ([L].[Title] = @UserName))
						AND (@IdCategoria IS NULL OR ([CL].[CategoryID] = @IdCategoria) AND [C].[Ordinal] <> 1)
						AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
						) C1
		ORDER BY C1.Fecha DESC
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RealizarBackup]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[RealizarBackup] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		John Betancourt A. - OIM
-- Create date: 20-02-2018
-- Description:	Procedimiento para realizar el backup de datos de la BD nueva a la historica
-- =============================================
ALTER PROCEDURE [dbo].[RealizarBackup] 
	AS
BEGIN TRANSACTION BackupLog

	DECLARE @intContNew int,
	@intContOld int,
	@intContOK int

	SELECT @intContNew = COUNT(1) from [rusicst_log].[dbo].[Log] where Timestamp < SYSDATETIME()
	--SELECT COUNT(1) from [rusicst_log].[dbo].[Log] where Timestamp < SYSDATETIME()
	SELECT @intContOld = COUNT(1) from [rusicst_log_BACKUP].[dbo].[Log]
	SELECT @intContOK = @intContNew + @intContOld
	SELECT @intContNew,@intContOld

	INSERT INTO [rusicst_log_BACKUP].[dbo].[Log] 
	SELECT EventID, Priority, Severity, Title, Timestamp, MachineName, AppDomainName, ProcessID, ProcessName, ThreadName,
			Win32ThreadId, Message, FormattedMessage 
	FROM [rusicst_log].[dbo].[Log] where Timestamp < SYSDATETIME()
	--select * from [rusicst_log_BACKUP].[dbo].[Log]
	--truncate table [rusicst_log_BACKUP].[dbo].[Log]

	INSERT INTO [rusicst_log_BACKUP].[dbo].[CategoryLog]
	SELECT cl.CategoryID, cl.LogID
	FROM [rusicst_log].[dbo].[CategoryLog] cl 
	INNER JOIN [rusicst_log].[dbo].[Log] l on cl.LogID = l.LogID 
	where Timestamp < SYSDATETIME()


	select @intContOld = COUNT(1) from [rusicst_log_BACKUP].[dbo].[Log]

	if(@intContOK = @intContOld)
	BEGIN
		DELETE cl FROM [rusicst_log].[dbo].[CategoryLog] cl
		INNER JOIN [rusicst_log].[dbo].[Log] l on cl.LogID = l.LogID 
		where Timestamp < SYSDATETIME()
		DELETE FROM [rusicst_log].[dbo].[Log] where (Timestamp < SYSDATETIME())
		--PRINT 'ENTRO'
	END

COMMIT TRANSACTION BackupLog

go