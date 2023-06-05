--======================================================================
-- Colocar llave primaria a Permiso Usuario Encuesta
--======================================================================
ALTER TABLE [dbo].[PermisoUsuarioEncuesta] ADD [Id] INT IDENTITY
ALTER TABLE [dbo].[PermisoUsuarioEncuesta] ADD CONSTRAINT [PK_PermisoUsuarioEncuesta] PRIMARY KEY([Id])

--===========================================================================================================
-- Actualiza la información del Username de la tabla PermisoUsuarioEncuesta Reemplaza los Username por el Id
--===========================================================================================================
UPDATE PUE SET PUE.[Username] = U.Id
FROM [dbo].[PermisoUsuarioEncuesta] PUE
INNER JOIN [dbo].[Usuario] U ON PUE.[Username] = U.UserName

--============================================================
-- Cambiar el tipo de dato de Varchar a Int 
--============================================================
ALTER TABLE [dbo].[PermisoUsuarioEncuesta] ALTER COLUMN [Username] INT NOT NULL

--==========================================================================
-- Renombrar la columna Username por IdUsuario
--==========================================================================
EXEC sp_RENAME '[dbo].[PermisoUsuarioEncuesta].[Username]', 'IdUsuario', 'COLUMN'

--===============================================================================
-- Crear el constraint entre la tabla PERMISO USUARIO ENCUESTA y la tabla usuario
--===============================================================================
ALTER TABLE [dbo].[PermisoUsuarioEncuesta] ADD CONSTRAINT FK_PermisoUsuarioEncuesta_Usuario FOREIGN KEY (IdUsuario) REFERENCES [dbo].[Usuario](Id);

--===========================================================================================================
-- Actualiza la información del WhoAction de la tabla PermisoUsuarioEncuesta Reemplaza los WhoAction por el Id
--===========================================================================================================
UPDATE PUE SET PUE.[WhoAction] = U.Id
FROM [dbo].[PermisoUsuarioEncuesta] PUE
INNER JOIN [dbo].[Usuario] U ON PUE.[WhoAction] = U.UserName

--============================================================
-- Cambiar el tipo de dato de Varchar a Int 
--============================================================
ALTER TABLE [dbo].[PermisoUsuarioEncuesta] ALTER COLUMN [WhoAction] INT NULL

--==========================================================================
-- Renombrar la columna WhoAction por IdUsuarioTramite
--==========================================================================
EXEC sp_RENAME '[dbo].[PermisoUsuarioEncuesta].[WhoAction]', 'IdUsuarioTramite', 'COLUMN'

--==========================================================================
-- Renombrar la columna WhoAction por IdUsuarioTramite
--==========================================================================
EXEC sp_RENAME '[dbo].[PermisoUsuarioEncuesta].[WhenAction]', 'FechaTramite', 'COLUMN'

--===============================================================================
-- Crear el constraint entre la tabla PERMISO USUARIO ENCUESTA y la tabla usuario
--===============================================================================
ALTER TABLE [dbo].[PermisoUsuarioEncuesta] ADD CONSTRAINT FK_PermisoUsuarioEncuesta_UsuarioTramite FOREIGN KEY (IdUsuarioTramite) REFERENCES [dbo].[Usuario](Id);

--==========================================================================
-- Renombrar la columna Id_Encuesta por IdUsuarioTramite
--==========================================================================
EXEC sp_RENAME '[dbo].[PermisoUsuarioEncuesta].[Id_Encuesta]', 'IdEncuesta', 'COLUMN'