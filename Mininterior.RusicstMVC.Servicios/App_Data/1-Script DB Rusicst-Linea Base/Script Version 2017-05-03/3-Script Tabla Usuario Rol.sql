--==============================================================================================
-- Actualiza la información del Usuario de la tabla UsuarioRol. Reemplaza los usuarios por el Id
--==============================================================================================
UPDATE UR SET UR.[Username] = U.Id
FROM [Roles].[UsuarioRol] UR
INNER JOIN [dbo].[Usuario] U ON UR.[Username] = U.UserName

--============================================================
-- Cambiar el tipo de dato de Varchar a Int 
--============================================================
ALTER TABLE [Roles].[UsuarioRol] ALTER COLUMN [Username] INT NULL

--==========================================================================
-- Renombrar la columna Username por IdUsuario
--==========================================================================
EXEC sp_RENAME '[Roles].[UsuarioRol].[Username]', 'IdUsuario', 'COLUMN'

--==========================================================================
-- Crear el indice para el usuario y para el rol
--==========================================================================
CREATE NONCLUSTERED INDEX IDX_Usuario ON [Roles].[UsuarioRol] (IdUsuario);
CREATE NONCLUSTERED INDEX IDX_Rol ON [Roles].[UsuarioRol] (IdRol);
CREATE UNIQUE INDEX IDX_Usuario_Rol ON [Roles].[UsuarioRol] (IdUsuario, IdRol);

--==========================================================================
-- Crear el constraint entre la tabla respuesta y la tabla usuario
--==========================================================================
ALTER TABLE [Roles].[UsuarioRol] ADD CONSTRAINT FK_UsuarioRol_Usuario FOREIGN KEY (IdUsuario) REFERENCES [dbo].[Usuario](Id);