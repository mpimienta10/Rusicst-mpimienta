--==========================================================================
-- Elimina los procedimientos que carga las listas para su cambio de nombre
--==========================================================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ObtenerRoles]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_ObtenerRoles]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ObtenerTipoEncuesta]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_ObtenerTipoEncuesta]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestaCombo]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_EncuestaCombo]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Roles].[C_ObtenerRoles]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [Roles].[C_ObtenerRoles]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_GrupoCombo]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_GrupoCombo]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_SeccionCombo]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_SeccionCombo]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_SubSeccionCombo]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_SubSeccionCombo]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DeptosYMunicipios]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_DeptosYMunicipios]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ObtenerMunicipiosDeUsuario]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_ObtenerMunicipiosDeUsuario]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Recurso]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_Recurso]
END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_SubRecurso]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [dbo].[C_SubRecurso]
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaTipoEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaTipoEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Vilma Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-16																			 
-- Descripcion: Consulta la informacion de los tipos de encuesta
--****************************************************************************************************
ALTER PROC [dbo].[C_ListaTipoEncuesta]

AS

	SELECT 
		 [Id]
		,[Nombre]
	FROM 
		[dbo].[TipoEncuesta]
	ORDER BY 
		[Nombre]


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Robinson Moscoso																			 
-- Fecha creacion: 2017-01-25																			 
-- Descripcion: Consulta la informacion de las encuestas para ser utilizada en combos de encuestas												
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--****************************************************************************************************
ALTER PROC [dbo].[C_ListaEncuesta]

AS
	SELECT 
		 [Id]
		,[Titulo]
	FROM 
		[Encuesta]
	WHERE
		[IsDeleted] = 'false'
	ORDER BY 
		[Titulo]		

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Roles].[C_ListaRoles]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [Roles].[C_ListaRoles] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Vilma Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-16																			 
-- Descripcion: Consulta la informacion de los roles del sistema
--****************************************************************************************************
ALTER PROC [Roles].[C_ListaRoles]

AS

	SELECT 
		[IdRol], 
		[Nombre] 
	FROM 
		[Roles].[Rol]
	ORDER BY 
		[Nombre]

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaGrupo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaGrupo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-24																			 
-- Descripcion: Trae el listado de secciones de una encuesta												
--****************************************************************************************************
ALTER PROCEDURE [dbo].[C_ListaGrupo]

	@idEncuesta INT	 

AS

	SELECT 
		 Id
		,Titulo 
	FROM 
		[dbo].[Seccion] AS s
	WHERE 
		s.IdEncuesta = @idEncuesta 
		AND s.SuperSeccion IS NULL
	ORDER BY 
		Titulo
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaSeccion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaSeccion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-24																			 
-- Descripci♀n: Trae el listado de sub secciones de una encuesta por idGrupo									
--****************************************************************************************************
ALTER PROCEDURE [dbo].[C_ListaSeccion]

	 @idEncuesta	INT
	,@idGrupo		INT
	
AS

	SELECT 
		 Id
		,Titulo 
	FROM 
		[dbo].[Seccion] AS s
	WHERE 
		s.IdEncuesta = @idEncuesta 
		AND s.SuperSeccion = @idGrupo
	ORDER BY 
		Titulo
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaSubSeccion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaSubSeccion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-24																			 
-- Descripcion: Trae el listado de sub secciones de una encuesta	por idseccion									
--******************************************************************************************************/
ALTER PROCEDURE [dbo].[C_ListaSubSeccion]

	@idEncuesta INT,
	@idseccion INT	 

AS

	SELECT 
		 Id
		,Titulo 
	FROM 
		[dbo].[Seccion] AS s
	WHERE 
		s.IdEncuesta = @idEncuesta 
		AND s.SuperSeccion = @idseccion
	ORDER BY 
		Titulo
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaDeptosYMunicipios]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaDeptosYMunicipios] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Robinson Moscoso																			 
-- Fecha creacion: 2017-01-25																			 
-- Descripcion: Consulta la informacion de departamentos y municipios para ser utilizada en combos 
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--******************************************************************************************************/
ALTER PROC [dbo].[C_ListaDeptosYMunicipios]

AS

	SELECT 
		D.[Id] AS IdDepartamento    
		,D.[Nombre] AS Departamento
		,M.ID AS IdMunicipio
		,M.Nombre AS Municipio
	FROM 
		[dbo].[Departamento] D 
		INNER JOIN dbo.municipio M ON D.id = M.IdDepartamento
	ORDER BY 
		D.Nombre, M.Nombre				
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaMunicipiosXUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaMunicipiosXUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-08																			 
-- Descripcion: Carga el listado de municipios ligados al departamento de un usuario								
--******************************************************************************************************/
ALTER PROCEDURE [dbo].[C_ListaMunicipiosXUsuario]

	@IdUsuario		INT,
	@IdTipoUsuario	INT

AS

	SELECT 
		 m.Id
		,m.[Nombre] 
	FROM 
		[dbo].[Usuario] AS u
		INNER JOIN [dbo].[Departamento] AS d ON u.[IdDepartamento]= d.Id
		INNER JOIN [dbo].[Municipio] AS m ON d.Id = m.[IdDepartamento] 
	WHERE 
		u.[IdTipoUsuario] = @IdTipoUsuario 
		AND u.[UserName] = @IdUsuario
	ORDER 
		BY m.[Nombre]	

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
			 [IdRecurso]
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
			 [IdSubRecurso]
			,[Nombre]
			,[Url]
		FROM
			[dbo].[SubRecurso]
		
	END






