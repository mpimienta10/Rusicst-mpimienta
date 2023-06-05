
IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Recurso Plan de Mejoramiento'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Recurso Plan de Mejoramiento', 169)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Recurso Plan de Mejoramiento'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Recurso Plan de Mejoramiento', 170)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Recurso Plan de Mejoramiento'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Recurso Plan de Mejoramiento', 171)
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

END
    
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosHistoricoSolicitudes]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosHistoricoSolicitudes] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==============================================================================================================
-- Autor : Equipo de desarrollo OIM - Christian Ospina
-- Fecha : 2017-04-05																			 
-- Descripción: Consulta la información de los usuarios que tienen algún 																 
--==============================================================================================================
ALTER PROC [dbo].[C_UsuariosHistoricoSolicitudes]

AS
	BEGIN
		SELECT
--======================================================================================
-- ORDEN DE LA CONSULTA NECESARIA PARA QUE SE MUESTRE EN ESTE MISMO ORDEN EN LA REJILLA
--=======================================================================================
			 [U].[Nombres]
			,[U].[FechaSolicitud]
			,[U].[Cargo]
			,[U].[TelefonoFijo]
			,[T].[Nombre] TipoUsuario
			,[U].[TelefonoCelular]
			,[U].[Email]
			,[M].[Nombre] Municipio
			,[D].[Nombre] Departamento
			,[U].[DocumentoSolicitud]
--=======================================================================================
			,[U].[Id]
			,[E].[Nombre] Estado
			,[UTramite].[UserName]	UsuarioTramite		
			,[U].[TelefonoFijoIndicativo]
			,[U].[TelefonoFijoExtension]
			,[U].[EmailAlternativo]
			,[U].[Activo]
			,[U].[FechaNoRepudio]
			,[U].[FechaTramite]
			,[U].[FechaConfirmacion]	
		FROM 
			[dbo].[Usuario] U
			LEFT JOIN [dbo].[TipoUsuario] T ON [U].[IdTipoUsuario] = [T].[Id]
			LEFT JOIN [dbo].[Estado] E ON [U].[IdEstado] = [E].[Id]	
			LEFT JOIN [dbo].[Departamento] D ON [D].[Id] = [U].[IdDepartamento]
			LEFT JOIN [dbo].[Municipio] M ON [M].[Id] = [U].[IdMunicipio]
			LEFT JOIN [dbo].[Usuario] UTramite ON [UTramite].[Id] = [U].[IdUsuarioTramite] 
		ORDER BY 
			[U].[FechaSolicitud] DESC
	END


