
--====================================================================
-- Elimina los roles que no se llaman alcaldia o gobernación
--====================================================================
DELETE FROM AspNetRoles WHERE Name NOT IN ('ALCALDIA', 'GOBERNACION')

GO

--===============================================================================
-- ELIMINAR LOS REGISTROS QUE TIENEN DEPENDENCIA CON EL ROL = rol prueba17082016
--===============================================================================
DELETE FROM [Roles].[UsuarioRol] WHERE IdRol = 4

GO

--====================================================================================================
-- ACTUALIZA LA INFORMACION DE LA TABLA [Roles].[Rol] COLOCANDO LOS MISMOS NOMBRES DE LA TABLA DE ROL
-- Alcaldías = ALCALDIA, Gobernaciones = GOBERNACION
--====================================================================================================
UPDATE [Roles].[Rol] SET Nombre = 'GOBERNACION' WHERE IdRol = 3
UPDATE [Roles].[Rol] SET Nombre = 'ALCALDIA' WHERE IdRol = 2

GO

--====================================================================================================
-- QUITAR LOS INDICES 'IDX_Rol', 'IDX_Usuario', 'IDX_Usuario_Rol'
--====================================================================================================
DROP INDEX [IDX_Rol] ON [Roles].[UsuarioRol]
DROP INDEX [IDX_Usuario] ON [Roles].[UsuarioRol]
DROP INDEX [IDX_Usuario_Rol] ON [Roles].[UsuarioRol]

GO

--====================================================================================================
-- QUITAR LOS CONSTRAINT
--====================================================================================================
ALTER TABLE [Roles].[UsuarioRol] DROP CONSTRAINT [FK_UsuarioRol_Rol];
ALTER TABLE [Roles].[UsuarioRol] DROP CONSTRAINT [FK_UsuarioRol_Usuario];

GO

--====================================================================================================
-- CAMBIA EL TIPO DE DATO DE LA COLUMNA [IdRol] POR NVARCHAR(128) [IdUsuario] POR NVARCHAR(128) DE
-- LA TABLA [Roles].[UsuarioRol]
--====================================================================================================
ALTER TABLE [Roles].[UsuarioRol] ALTER COLUMN [IdRol] NVARCHAR(128) NOT NULL
ALTER TABLE [Roles].[UsuarioRol] ALTER COLUMN [IdUsuario] NVARCHAR(128) NOT NULL

GO

--====================================================================================================
-- ACTUALIZA EL IdRol COLOCANDO EL IDENTIFICADOR DE LA TABLA ASPNETROLES  
--====================================================================================================
UPDATE UR SET UR.IdRol = R.Id
FROM [Roles].[UsuarioRol] UR
INNER JOIN [Roles].[Rol] RR ON UR.IdRol = RR.IdRol
INNER JOIN [dbo].[AspNetRoles] R ON R.Name = RR.Nombre

GO

--====================================================================================================
-- ACTUALIZA EL [IdUsuario] DE LA TABLA [Roles].[UsuarioRol] COLOCANDO EL Id DE LA TABLA 
-- [dbo].[AspNetUsers]
--====================================================================================================
UPDATE UR SET UR.IdUsuario = U.IdUser
FROM [Roles].[UsuarioRol] UR
INNER JOIN [dbo].[Usuario] U ON UR.IdUsuario = U.Id

GO

--====================================================================================================
-- INSERTA LA INFORMACION EN LA TABLA DE [dbo].[AspNetUserRoles] DESDE LA TABLA [Roles].[UsuarioRol]
--====================================================================================================
INSERT INTO [dbo].[AspNetUserRoles]([UserId], [RoleId])
SELECT IdUsuario, IdRol FROM [Roles].[UsuarioRol]

GO
