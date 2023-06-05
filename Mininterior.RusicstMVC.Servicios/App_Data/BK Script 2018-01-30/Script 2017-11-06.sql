GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXExcepcion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_LogXExcepcion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo - OIM (Christian Ospina)
-- Create date: 25-10-2017
-- Description:	Procedimiento que consulta la información del Log filtrado por las excepciones
--				Organiza la información desde la fecha más reciente a la más antigua
-- =============================================
ALTER PROCEDURE [dbo].[C_LogXExcepcion] 
	
	@FechaInicio DATETIME,
	@FechaFin DATETIME

AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		 TOP 1000 [L].[LogID]
		,CAST([L].[Timestamp] as VARCHAR) Fecha
		,[Message] UrlYBrowser		
	FROM 
		[dbo].[CategoryLog] CL
		INNER JOIN [dbo].[Log] L ON [CL].[LogID] = [L].[LogID]
		INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
	WHERE 
		[C].[Ordinal] = 1 -- CORRESPONDE A LA CATEGORIA EXCEPCIONES
		AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
	ORDER BY 2 DESC

END

GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Establecer Contraseña'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Establecer Contraseña', 172)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Envío Mail Contactenos'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Envío Mail Contactenos', 173)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Envío Mail Contactenos Error'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Envío Mail Contactenos Error', 174)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Remitir Solicitud de Usuario'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Remitir Solicitud de Usuario', 175)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Solicitud de Usuario'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Solicitud de Usuario', 176)
GO