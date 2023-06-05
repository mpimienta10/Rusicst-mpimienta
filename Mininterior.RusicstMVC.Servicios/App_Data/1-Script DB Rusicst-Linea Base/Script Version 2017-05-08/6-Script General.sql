IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PermisosRol]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PermisosRol] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-08																			 
-- Descripcion: Consulta la informacion de la rejilla de Gestionar Permisos de Usuario												
--****************************************************************************************************
ALTER PROC [dbo].[C_PermisosRol]

AS

	BEGIN

	SET NOCOUNT ON;

		SELECT DISTINCT  
			 TU.Tipo IdRol
			,TUR.IdRecurso
			,r.Nombre AS NombreRecurso
			,TUR.IdSubRecurso 
			,sr.Nombre AS NombreSubRecurso	 
		FROM 
			[dbo].[TipoUsuarioRecurso] AS TUR
			INNER JOIN [dbo].[Recurso] AS R ON TUR.IdRecurso = R.Id
			INNER JOIN [dbo].[SubRecurso] AS SR ON TUR.IdSubRecurso = SR.Id
			INNER JOIN [dbo].[TipoUsuario] AS TU ON TUR.IdTipoUsuario = TU.Id

	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaRecurso]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaRecurso] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 29/03/2017
-- Description:	Selecciona la información de Recursos
-- ===========================================================
ALTER PROCEDURE [dbo].[C_ListaRecurso] 

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT
			 [Id] IdRecurso
			,[Nombre]
			,[Url]
		FROM
			[dbo].[Recurso]
		
	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaSubRecurso]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaSubRecurso] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 30/03/2017
-- Description:	Selecciona la información de SubRecursos que en
--				en la práctica son los sub-menus
-- ===========================================================
ALTER PROCEDURE [dbo].[C_ListaSubRecurso] 

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT
			 [Id]
			,[Nombre]
			,[Url]
		FROM
			[dbo].[SubRecurso]
		
	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaTipoUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaTipoUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 23/02/2017
-- Description:	Selecciona la información de Tipos de Usuario
-- =============================================
ALTER PROCEDURE [dbo].[C_ListaTipoUsuario] 

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			 [Id]
			,[Nombre]
		FROM
			[dbo].[TipoUsuario]
		WHERE Activo = 1

	END



		





