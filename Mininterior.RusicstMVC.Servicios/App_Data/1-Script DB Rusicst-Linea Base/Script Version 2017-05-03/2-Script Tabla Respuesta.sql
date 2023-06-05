--==============================================================================================
-- Retiramos el constraint que asigna el valor por default a la columna usuario
--==============================================================================================
ALTER TABLE [dbo].[Respuesta] DROP CONSTRAINT [DF__Respuesta__Usuar__08B54D69]

--==============================================================================================
-- Eliminar el indice para poder hacer el cambio de varchar a int
-- Se encontraron dos indices apuntando a la columna de usuarios
--==============================================================================================
DROP INDEX [idx_usuario] ON [dbo].[Respuesta]
DROP INDEX [IDX_Afinamiento_Reporte_Ejecutivo2_1] ON [dbo].[Respuesta]

--==============================================================================================
-- Actualiza la información del Usuario de la tabla Respuesta. Reemplaza los usuarios por el Id
--==============================================================================================
UPDATE R SET R.Usuario = U.Id
FROM [dbo].[Respuesta] R
INNER JOIN [dbo].[Usuario] U ON R.Usuario = U.UserName

--============================================================
-- Cambiar el tipo de dato de Varchar a Int 
--============================================================
ALTER TABLE [dbo].[Respuesta] ALTER COLUMN [Usuario] INT NULL

--==========================================================================
-- Renombrar la columna Usuario por IdUsuario
--==========================================================================
EXEC sp_RENAME '[dbo].[Respuesta].[Usuario]', 'IdUsuario', 'COLUMN'

--==========================================================================
-- Crear el indice para el usuario
--==========================================================================
CREATE NONCLUSTERED INDEX IDX_Usuario ON [dbo].[Respuesta] (IdUsuario);

--==========================================================================
-- Crear el constraint entre la tabla respuesta y la tabla usuario
--==========================================================================
ALTER TABLE [dbo].[Respuesta] ADD CONSTRAINT FK_Respuesta_Usuario FOREIGN KEY (IdUsuario) REFERENCES [dbo].[Usuario](Id);