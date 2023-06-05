--================================================================================================================================
-- Arreglar los datos de la tabla [dbo].[TipoUsuario], colocarlos en mayúscula, eliminar el que se llama prueba
-- Insertar en la tabla [dbo].[AspNetRoles] los datos existentes en [dbo].[TipoUsuario]
--================================================================================================================================
DELETE TipoUsuario WHERE Nombre = 'Admin pruebas 2'
DELETE AspNetRoles WHERE Name = 'Admin pruebas 2'
UPDATE TipoUsuario SET Tipo = 'ENTIDAD' WHERE Nombre = 'Entidad de Control'

IF((SELECT COUNT(*) FROM [dbo].[AspNetRoles]) = 0)
	INSERT INTO [dbo].[AspNetRoles]([Id],[Name]) 
	SELECT NEWID(), Tipo FROM TipoUsuario

GO

--================================================================================================================================
-- Eliminar la tabla de roles [Roles].[Rol] y relacionar todo a la tabla [dbo].[AspNetRoles]
	-- Ajustar tabla AsignacionPlanMejoramientoRol
		-- Se elimina el indice con la tabla [Roles].[Rol]
		-- Se elimina la llave foranea FK_AsignacionPlanMejoramientoRol_Rol
		-- Se cambia el tipo de dato en el IdRol. pasa de INT a Varchar(128)
		-- Se redirecciona la llave foranea a la tabla [dbo].[AspNetRoles]
		-- Se recrea el Indice eliminado y se relaciona con la tabla [dbo].[AspNetRoles]
--================================================================================================================================
IF (EXISTS (SELECT O.name Tabla, I.name Indice FROM sys.indexes I INNER JOIN sys.objects O ON I.object_id = O.object_id 
			WHERE I.name = N'IDX_AsignacionPlanMejoramientoRol_Rol' AND O.name = N'AsignacionPlanMejoramientoRol'))
	DROP INDEX [IDX_AsignacionPlanMejoramientoRol_Rol] ON [PlanesMejoramiento].[AsignacionPlanMejoramientoRol]

IF (EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_AsignacionPlanMejoramientoRol_Rol'))
	ALTER TABLE [PlanesMejoramiento].[AsignacionPlanMejoramientoRol] DROP CONSTRAINT FK_AsignacionPlanMejoramientoRol_Rol;

ALTER TABLE [PlanesMejoramiento].[AsignacionPlanMejoramientoRol] ALTER COLUMN IdRol NVARCHAR(128) NOT NULL

IF (NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_AsignacionPlanMejoramientoRol_Rol'))
ALTER TABLE [PlanesMejoramiento].[AsignacionPlanMejoramientoRol] ADD CONSTRAINT FK_AsignacionPlanMejoramientoRol_Rol FOREIGN KEY (IdRol) REFERENCES [dbo].[AspNetRoles](Id);

IF (NOT EXISTS (SELECT O.name Tabla, I.name Indice FROM sys.indexes I INNER JOIN sys.objects O ON I.object_id = O.object_id 
				WHERE I.name = N'IDX_AsignacionPlanMejoramientoRol_Rol' AND O.name = N'AsignacionPlanMejoramientoRol'))
CREATE NONCLUSTERED INDEX IDX_AsignacionPlanMejoramientoRol_Rol ON [PlanesMejoramiento].[AsignacionPlanMejoramientoRol] (IdRol);

GO	
--================================================================================================================================		
-- Ajustar procedimiento C_ListaRoles
--================================================================================================================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Roles].[C_ListaRoles]') AND type in (N'P', N'PC')) 
	DROP PROCEDURE [Roles].[C_ListaRoles]

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaRoles]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaRoles] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Vilma Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-16																			 
-- Descripcion: Consulta la informacion de los roles del sistema
--****************************************************************************************************
ALTER PROC [dbo].[C_ListaRoles]

AS

	SELECT 
		[Id] IdRol, 
		[Name] Nombre
	FROM 
		[dbo].[AspNetRoles]
	ORDER BY 
		[Name]

GO

--================================================================================================================================	
-- Ajustar tabla RolEncuesta
	-- Cambiar el tipo de dato de INT a NVARCHAR
	-- Actualizar los datos de la tabla [Roles].[RolEncuesta] por el Id de la tabla [dbo].[AspNetRoles]
	-- Crear nuevamente la llave foranea 
	-- Crear un indice para las dos llaves foraneas
--================================================================================================================================	
IF (EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_RolEncuesta_Rol'))
	ALTER TABLE [Roles].[RolEncuesta] DROP CONSTRAINT [FK_RolEncuesta_Rol];
ALTER TABLE [Roles].[RolEncuesta] ALTER COLUMN IdRol NVARCHAR(128) NOT NULL

UPDATE [Roles].[RolEncuesta] SET [IdRol] = (SELECT [Id] FROM [dbo].[AspNetRoles] WHERE [Name] = 'ALCALDIA') WHERE IdRol = (SELECT CAST(IdRol AS NVARCHAR(128)) FROM [Roles].[Rol] WHERE [Nombre] = 'Alcaldías')
UPDATE [Roles].[RolEncuesta] SET [IdRol] = (SELECT [Id] FROM [dbo].[AspNetRoles] WHERE [Name] = 'GOBERNACION') WHERE IdRol = (SELECT CAST(IdRol AS NVARCHAR(128)) FROM [Roles].[Rol] WHERE [Nombre] = 'Gobernaciones')

IF (NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_RolEncuesta_Rol'))
	ALTER TABLE [Roles].[RolEncuesta] ADD CONSTRAINT FK_RolEncuesta_Rol FOREIGN KEY (IdRol) REFERENCES [dbo].[AspNetRoles](Id);

IF (NOT EXISTS (SELECT O.name Tabla, I.name Indice FROM sys.indexes I INNER JOIN sys.objects O ON I.object_id = O.object_id 
				WHERE I.name = N'IDX_RolEncuesta_Encuesta_Rol' AND O.name = N'RolEncuesta'))
CREATE NONCLUSTERED INDEX IDX_RolEncuesta_Encuesta_Rol ON [Roles].[RolEncuesta] (IdEncuesta, IdRol);

GO
--================================================================================================================================
-- Relacionar la tabla [dbo].[AspNetRoles] con la tabla [dbo].[RolRecurso]
	-- Cambiar de tipo de dato el IdRol de INT a nVarchar(128)
	-- Eliminar la llave primaria de la tabla
	-- Borrar los registros que estan en blanco
	-- Actualizar la información colocando el Id de la tabla [dbo].[AspNetRoles] como IdRol
	-- Renombrar la tabla [dbo].[RolRecurso] por [dbo].[TipoUsuarioRecurso]
	-- Colocar la llave foranea entre [dbo].[AspNetRoles] y [dbo].[TipoUsuarioRecurso] 
	-- Coloca la llave foranea entre [dbo].[Recurso] y [dbo].[TipoUsuarioRecurso] 
	-- Elimina los registros huerfanos de la tabla [dbo].[TipoUsuarioRecurso]
	-- Coloca la llave foranea entre [dbo].[SubRecurso] y [dbo].[TipoUsuarioRecurso]
	-- Crear la llave primaria que se compone de las tres columnas
--================================================================================================================================
IF (EXISTS (SELECT * FROM sys.key_constraints WHERE name = N'PK__RolRecur__02C9D83C73501C2F'))
	ALTER TABLE [dbo].[RolRecurso] DROP CONSTRAINT [PK__RolRecur__02C9D83C73501C2F];

GO

DELETE [dbo].[RolRecurso] WHERE LEN([IdRol]) = 0 OR [IdRecurso] = 0 OR [IdSubRecurso] = 0

GO

EXEC sp_rename '[dbo].[RolRecurso]', 'TipoUsuarioRecurso'
EXEC sp_RENAME '[dbo].[TipoUsuarioRecurso].[IdRol]' , 'IdTipoUsuario', 'COLUMN'
EXEC sp_RENAME '[dbo].[SubRecurso].[IdSubRecurso]' , 'Id', 'COLUMN'

GO

DELETE [dbo].[TipoUsuario] WHERE Tipo = 'Admin pruebas 2'

UPDATE TUR
SET [IdTipoUsuario] = TU.Id
FROM [dbo].[TipoUsuarioRecurso] TUR
INNER JOIN [dbo].[TipoUsuario] TU ON TUR.[IdTipoUsuario] = TU.Tipo

UPDATE [dbo].[TipoUsuarioRecurso] SET IdTipoUsuario = (SELECT Id FROM [dbo].[TipoUsuario] WHERE Nombre = 'Entidad de Control')
WHERE IdTipoUsuario = 'Entidad de Control'

GO

ALTER TABLE [dbo].[TipoUsuarioRecurso] ALTER COLUMN [IdTipoUsuario] INT NOT NULL

GO

IF (NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_RolRecurso_Rol'))
	ALTER TABLE [dbo].[TipoUsuarioRecurso] ADD CONSTRAINT FK_TipoUsuarioRecurso_TipoUsuario FOREIGN KEY (IdTipoUsuario) REFERENCES [dbo].[TipoUsuario](Id);

GO

IF (NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_RolRecurso_Recurso'))
	ALTER TABLE [dbo].[TipoUsuarioRecurso] ADD CONSTRAINT FK_TipoUsuarioRecurso_Recurso FOREIGN KEY (IdRecurso) REFERENCES [dbo].[Recurso](Id);

GO

DELETE FROM [dbo].[TipoUsuarioRecurso] WHERE IdSubRecurso IN (SELECT RR.IdSubRecurso FROM TipoUsuarioRecurso RR
														LEFT JOIN SubRecurso SR ON RR.IdSubRecurso = SR.Id
														WHERE SR.Id IS NULL)
GO 
IF (NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = N'FK_RolRecurso_SubRecurso'))
	ALTER TABLE [dbo].[TipoUsuarioRecurso] ADD CONSTRAINT FK_TipoUsuarioRecurso_SubRecurso FOREIGN KEY (IdSubRecurso) REFERENCES [dbo].[SubRecurso](Id);

GO 

IF (NOT EXISTS (SELECT * FROM sys.key_constraints WHERE name = N'PK_RolRecurso'))
	ALTER TABLE [dbo].[TipoUsuarioRecurso] ADD CONSTRAINT [PK_TipoUsuarioRecurso] PRIMARY KEY([IdTipoUsuario], [IdRecurso], [IdSubRecurso])

