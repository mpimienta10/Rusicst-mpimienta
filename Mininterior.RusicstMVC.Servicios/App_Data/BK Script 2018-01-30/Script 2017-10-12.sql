IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroUsuarioDesarrollo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroUsuarioDesarrollo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Territorial
-- =============================================
ALTER  PROC [dbo].[C_ConsultaRetroUsuarioDesarrollo] 
	@IdDepartamento INT
AS
	select Id, UserName 
	from Usuario 
	where IdTipoUsuario IN (select Id from TipoUsuario where Tipo IN ('ALCALDIA','GOBERNACION')) AND Activo =1 AND IdEstado = 5 AND IdDepartamento = @IdDepartamento

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
		AND (@IdCategoria IS NULL OR ([CL].[CategoryID] = @IdCategoria))
		AND [L].Timestamp BETWEEN @FechaInicio AND @FechaFin

END

GO
----------------------------------------------------------------------------------------------
-- REGISTROS PARA LA CATEGORIZACION DE LA AUDITORIA
----------------------------------------------------------------------------------------------

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Respuesta PAT', 108)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Respuesta PAT', 109)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta Acciones PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Respuesta Acciones PAT', 110)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta Acciones PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Respuesta Acciones PAT', 111)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta Programa PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Respuesta Programa PAT', 112)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta Programa PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Respuesta Programa PAT', 113)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta RC PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Respuesta RC PAT', 114)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta RC PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Respuesta RC PAT', 115)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta RC Acciones PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Respuesta RC Acciones PAT', 116)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta RC Acciones PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Respuesta RC Acciones PAT', 117)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta RR PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Respuesta RR PAT', 118)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta RR PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Respuesta RR PAT', 119)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta RR Acciones PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Respuesta RR Acciones PAT', 120)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta RR Acciones PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Respuesta RR Acciones PAT', 121)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta Encuesta'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Respuesta Encuesta', 122)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Pregunta Opción'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Pregunta Opción', 123)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Pregunta Opción'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Pregunta Opción', 124)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Pregunta Opción'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Pregunta Opción', 125)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta Departamento RR PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Respuesta Departamento RR PAT', 126)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta Departamento RR PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Respuesta Departamento RR PAT', 127)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta Departamento RC PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Respuesta Departamento RC PAT', 128)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta Departamento RC PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Respuesta Departamento RC PAT', 129)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta Departamento PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Respuesta Departamento PAT', 130)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta Departamento PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Respuesta Departamento PAT', 131)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Preguntas PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Preguntas PAT', 132)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Preguntas PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Preguntas PAT', 133)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Reparación Colectiva Departamento'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Seguimiento Reparación Colectiva Departamento', 134)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Reparación Colectiva Departamento'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Seguimiento Reparación Colectiva Departamento', 135)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Retornos Reubicaciones Departamento'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Seguimiento Retornos Reubicaciones Departamento', 136)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Retornos Reubicaciones Departamento'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Seguimiento Retornos Reubicaciones Departamento', 137)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Gobernación Otros Derechos'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Seguimiento Gobernación Otros Derechos', 138)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Gobernación Otros Derechos'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Seguimiento Gobernación Otros Derechos', 139)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Gobernación Otros Derechos Medidas'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Seguimiento Gobernación Otros Derechos Medidas', 140)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Gobernación Otros Derechos Medidas'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Seguimiento Gobernación Otros Derechos Medidas', 141)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento PAT Gobernación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Seguimiento PAT Gobernación', 142)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento PAT Gobernación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Seguimiento PAT Gobernación', 143)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Programas Seguimiento PAT Gobernación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Programas Seguimiento PAT Gobernación', 144)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Programa Seguimiento PAT Gobernación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Programa Seguimiento PAT Gobernación', 145)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Programa Respuesta Acciones PAT'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Programa Respuesta Acciones PAT', 146)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Seguimiento Gobernación Otros Derechos Medidas'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Seguimiento Gobernación Otros Derechos Medidas', 147)
GO
