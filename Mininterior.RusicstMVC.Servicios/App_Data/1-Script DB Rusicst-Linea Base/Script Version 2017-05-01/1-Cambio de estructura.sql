--======================================================================================================
-- AUTHOR: Equipo de desarrollo OIM - Christian Mauricio Ospina
-- PROJECT: RUSICST

-- Script que modifica la estructura de base de datos integrando las tablas de AspNetIdentity 
-- Adicionalmente se ajusta la tabla de TipoUsuario, creando sus referencias con las tablas de usuario
-- campaña email. Se ajustan cosntraint y se recrean dando como resultado un modelo consistente a nivel
-- relacional.
--======================================================================================================

--=====================================================================
-- Elimina el constraint FK_AsignacionPlanMejoramientoUsuario_Usuario
--=====================================================================
IF (EXISTS (SELECT * FROM sys.objects WHERE object_id in 
			(   
				SELECT fk.constraint_object_id FROM sys.foreign_key_columns AS fk
				WHERE fk.referenced_object_id = (SELECT object_id FROM sys.tables WHERE name = 'Usuario')
				AND name = 'FK_AsignacionPlanMejoramientoUsuario_Usuario'
			)))
BEGIN 
	ALTER TABLE [PlanesMejoramiento].[AsignacionPlanMejoramientoUsuario] DROP CONSTRAINT FK_AsignacionPlanMejoramientoUsuario_Usuario;
END

GO

--=====================================================================
-- Elimina el constraint FK_Autoevaluacion2_Usuario
--=====================================================================
IF (EXISTS (SELECT DISTINCT name FROM sys.objects WHERE object_id in 
			(   
				SELECT fk.constraint_object_id FROM sys.foreign_key_columns AS fk
				WHERE fk.referenced_object_id = (SELECT object_id FROM sys.tables WHERE name = 'Usuario')
				AND name = 'FK_Autoevaluacion2_Usuario'
			)))
BEGIN 
	ALTER TABLE [dbo].[Autoevaluacion2] DROP CONSTRAINT FK_Autoevaluacion2_Usuario;
END

GO

--=====================================================================
-- Elimina el constraint FK_PermisoUsuarioEncuesta_Usuario
--=====================================================================
IF (EXISTS (SELECT DISTINCT name FROM sys.objects WHERE object_id in 
			(   
				SELECT fk.constraint_object_id FROM sys.foreign_key_columns AS fk
				WHERE fk.referenced_object_id = (SELECT object_id FROM sys.tables WHERE name = 'Usuario')
				AND name = 'FK_PermisoUsuarioEncuesta_Usuario'
			)))
BEGIN 
	ALTER TABLE [dbo].[PermisoUsuarioEncuesta] DROP CONSTRAINT FK_PermisoUsuarioEncuesta_Usuario;
END

GO

--=====================================================================
-- Elimina el constraint FK_Respuesta_Usuario
--=====================================================================
IF (EXISTS (SELECT DISTINCT name FROM sys.objects WHERE object_id in 
			(   
				SELECT fk.constraint_object_id FROM sys.foreign_key_columns AS fk
				WHERE fk.referenced_object_id = (SELECT object_id FROM sys.tables WHERE name = 'Usuario')
				AND name = 'FK_Respuesta_Usuario'
			)))
BEGIN 
	ALTER TABLE [dbo].[Respuesta] DROP CONSTRAINT FK_Respuesta_Usuario;
END

GO

--=====================================================================
-- Elimina el constraint FK_SesssionChat_Usuario
--=====================================================================
IF (EXISTS (SELECT DISTINCT name FROM sys.objects WHERE object_id in 
			(   
				SELECT fk.constraint_object_id FROM sys.foreign_key_columns AS fk
				WHERE fk.referenced_object_id = (SELECT object_id FROM sys.tables WHERE name = 'Usuario')
				AND name = 'FK_SesssionChat_Usuario'
			)))
BEGIN 
	ALTER TABLE [dbo].[SessionChat] DROP CONSTRAINT FK_SesssionChat_Usuario;
END

GO

--=====================================================================
-- Elimina el constraint FK_UsuarioRol_Usuario
--=====================================================================
IF (EXISTS (SELECT DISTINCT name FROM sys.objects WHERE object_id in 
			(   
				SELECT fk.constraint_object_id FROM sys.foreign_key_columns AS fk
				WHERE fk.referenced_object_id = (SELECT object_id FROM sys.tables WHERE name = 'Usuario')
				AND name = 'FK_UsuarioRol_Usuario'
			)))
BEGIN 
	ALTER TABLE [Roles].[UsuarioRol] DROP CONSTRAINT FK_UsuarioRol_Usuario;
END

GO

--===================================================
-- Quitar la llave principal de la tabla de usuarios
--===================================================
DECLARE @ClaveUsuario VARCHAR(128)
SELECT @ClaveUsuario = name  
FROM sys.key_constraints  
WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'Usuario';  

IF(@ClaveUsuario IS NOT NULL)
	BEGIN
		ALTER TABLE [dbo].[Usuario]
		DROP CONSTRAINT PK__Usuario__536C85E5412EB0B6;   
	END

GO

--======================================================================
-- Colocar llave primaria tipo int con nombre Id y que sea autonumérico
--======================================================================
ALTER TABLE [dbo].[Usuario] ADD [Id] INT IDENTITY
ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT [PK_Usuario] PRIMARY KEY([Id])

GO
--===================================================
-- Quitar la llave principal de la tabla de TipoUsuarios
--===================================================
DECLARE @ClaveTipoUsuario VARCHAR(128)
SELECT @ClaveTipoUsuario = name  
FROM sys.key_constraints  
WHERE type = 'PK' AND OBJECT_NAME(parent_object_id) = N'TipoUsuario';  

IF(@ClaveTipoUsuario IS NOT NULL)
	BEGIN
		ALTER TABLE [dbo].[TipoUsuario]
		DROP CONSTRAINT PK__TipoUsua__8E762CB546E78A0C;   
	END

GO

--======================================================================
-- Colocar llave primaria a TipoUsuario
--======================================================================
ALTER TABLE [dbo].[TipoUsuario] ADD [Id] INT IDENTITY
ALTER TABLE [dbo].[TipoUsuario] ADD CONSTRAINT [PK_TipoUsuario] PRIMARY KEY([Id])

GO

--================================================================================================================
-- Actualiza los datos de la tabla USUARIO actualizando la columna TipoUsuario con el Id de la tabla TIPO USUARIO
--================================================================================================================
UPDATE U SET U.TipoUsuario = TU.Id
FROM Usuario U
INNER JOIN TipoUsuario TU ON U.TipoUsuario = TU.Tipo

GO

--===============================================================
-- Eliminamos el indice [idx_tipo_usuario] que tenía la columna [TipoUsuario] de la tabla  [dbo].[Usuario]
-- es un indice no cluster 
--===============================================================
DROP INDEX [idx_tipo_usuario] ON [dbo].[Usuario]

GO

--============================================================
-- Cambiar el tipo de dato de Varchar a Int 
--============================================================
ALTER TABLE [dbo].[Usuario] ALTER COLUMN [TipoUsuario] INT NULL

GO

--==========================================================================
-- Renombrar la columna TipoUsuario por IdTipoUsuario
--==========================================================================
EXEC sp_RENAME '[dbo].[Usuario].[TipoUsuario]', 'IdTipoUsuario', 'COLUMN'

GO

--================================================================
-- Colocar la llave foranea IdTipoUsuario en la tabla de usuarios 
--================================================================
ALTER TABLE [dbo].[Usuario] WITH NOCHECK ADD CONSTRAINT FK_Usuario_TipoUsuario FOREIGN KEY (IdTipoUsuario) REFERENCES [dbo].[TipoUsuario](Id);
GO

--====================================================================================
-- Creación nuevamente del indice para el Tipo de Usuario en la tabla [dbo].[Usuario]
--====================================================================================
CREATE NONCLUSTERED INDEX IDX_TipoUsuario ON [dbo].[Usuario] (IdTipoUsuario);

GO

--===============================================================
-- Eliminamos el indice [idx_departamento] que tenía la columna [Departamento] de la tabla  [dbo].[Usuario]
-- es un indice no cluster 
--===============================================================
DROP INDEX [idx_departamento] ON [dbo].[Usuario]
DROP INDEX [idx_municipio] ON [dbo].[Usuario]

GO

--====================================================================================
-- Renombramos la columna Departamento por IdDepartamento - Municipio por IdMunicipio
--====================================================================================
EXEC sp_RENAME '[dbo].[Usuario].[Departamento]', 'IdDepartamento', 'COLUMN'
EXEC sp_RENAME '[dbo].[Usuario].[Municipio]', 'IdMunicipio', 'COLUMN'

GO

--================================================================================================
-- Creación nuevamente del indice para el Departamento y el Municipio en la tabla [dbo].[Usuario]
--================================================================================================
CREATE NONCLUSTERED INDEX IDX_Departamento ON [dbo].[Usuario] (IdDepartamento);
CREATE NONCLUSTERED INDEX IDX_Municipio ON [dbo].[Usuario] (IdMunicipio);

GO

--================================================================================================
-- Actualizar la tabla Usuario en las columnas IdDepartamento y IdMunicipio por Bogotá

-- Se encontraron 46 registros en NULL
-- Se encontraron 9 registros en 1
-- Se encontraron 295 registros en 0

-- SELECT TU.Nombre, Username, U.Nombre, Email, IdDepartamento, IdMunicipio 
-- FROM Usuario U
-- INNER JOIN TipoUsuario TU ON U.IdTipoUsuario = TU.Id
-- WHERE IdDepartamento IS NULL OR IdDepartamento = 0 OR IdDepartamento = 1

-- SELECT TU.Nombre, Username, U.Nombre, Email, IdDepartamento, IdMunicipio 
-- FROM Usuario U
-- INNER JOIN TipoUsuario TU ON U.IdTipoUsuario = TU.Id
-- WHERE IdMunicipio IS NULL OR IdMunicipio = 0 OR IdMunicipio = 1

--================================================================================================
UPDATE [dbo].[Usuario] SET [IdDepartamento] = (SELECT [Id] FROM [dbo].[Departamento] WHERE Nombre = 'Bogotá, D.C.')
WHERE [IdDepartamento] IS NULL

UPDATE [dbo].[Usuario] SET [IdMunicipio] = (SELECT [Id] FROM [dbo].[Municipio] WHERE IdDep = (SELECT Id FROM [dbo].[Departamento] WHERE Nombre = 'Bogotá, D.C.'))
WHERE [IdMunicipio] IS NULL

UPDATE [dbo].[Usuario] SET [IdDepartamento] = (SELECT [Id] FROM [dbo].[Departamento] WHERE Nombre = 'Bogotá, D.C.')
WHERE [IdDepartamento] = 0

UPDATE [dbo].[Usuario] SET [IdMunicipio] = (SELECT [Id] FROM [dbo].[Municipio] WHERE IdDep = (SELECT Id FROM [dbo].[Departamento] WHERE Nombre = 'Bogotá, D.C.'))
WHERE [IdMunicipio] = 0

UPDATE [dbo].[Usuario] SET [IdDepartamento] = (SELECT [Id] FROM [dbo].[Departamento] WHERE Nombre = 'Bogotá, D.C.')
WHERE [IdDepartamento] = 1

UPDATE [dbo].[Usuario] SET [IdMunicipio] = (SELECT [Id] FROM [dbo].[Municipio] WHERE IdDep = (SELECT Id FROM [dbo].[Departamento] WHERE Nombre = 'Bogotá, D.C.'))
WHERE [IdMunicipio] = 1

GO

--================================================================================================
-- Colocar las llaves foraneas entre la tabla Usuario y las tablas Departamento y Municipio
--================================================================================================
ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT FK_Usuario_Departamento FOREIGN KEY (IdDepartamento) REFERENCES [dbo].[Departamento](Id);
ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT FK_Usuario_Municipio FOREIGN KEY (IdMunicipio) REFERENCES [dbo].[Municipio](Id);

GO

--===========================================================================================
-- Convierte los datos de la columna TOKEN que tiene tipo de dato Varchar A UNIQUEIDENTIFIER
--===========================================================================================
UPDATE Usuario SET Token = (SELECT  CAST(SUBSTRING(Token, 1, 8) + '-' + 
										 SUBSTRING(Token, 9, 4) + '-' + 
										 SUBSTRING(Token, 13, 4) + '-' +
										 SUBSTRING(Token, 17, 4) + '-' + 
										 SUBSTRING(Token, 21, 12) 
										 AS UNIQUEIDENTIFIER))

GO

--===========================================================================
-- Cambiar el tipo de dato de la columna TOKEN de VARCHAR a UNIQUEIDENTIFIER
--===========================================================================
ALTER TABLE [dbo].[Usuario] DROP CONSTRAINT DF_Token;
ALTER TABLE [dbo].[Usuario] ALTER COLUMN [Token] UNIQUEIDENTIFIER NOT NULL

GO

--=========================================================================================
-- Cambiar los nombres de los constraint que coloca un default en el valor de las columnas
--=========================================================================================
ALTER TABLE [dbo].[Usuario] DROP CONSTRAINT [DF__Usuario__Activo__4316F928];
ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT DF_Usuario_Activo DEFAULT ((1)) FOR [Activo]
GO

ALTER TABLE [dbo].[Usuario] DROP CONSTRAINT [DF__Usuario__DatosAc__06CD04F7];
ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT DF_Usuario_DatosActualizados DEFAULT ((0)) FOR [DatosActualizados]
GO

ALTER TABLE [dbo].[Usuario] DROP CONSTRAINT [DF__Usuario__Enviado__440B1D61];
ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT DF_Usuario_Enviado DEFAULT ((0)) FOR [Enviado]
GO

--================================================================================================================
-- Cambiar el nombre de la columna IdDep por IdDepartamento en la tabla Municipios
--================================================================================================================
EXEC sp_RENAME '[dbo].[Municipio].[IdDep]', 'IdDepartamento', 'COLUMN'

GO

--====================================================
-- Crear la tabla ESTADO
--====================================================
CREATE TABLE [dbo].[Estado]([Id] [int] IDENTITY(1,1) NOT NULL, [Nombre] [varchar](128) NOT NULL, [Descripcion] [varchar](100) NULL, [Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Estado] PRIMARY KEY CLUSTERED 
( [Id] ASC )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY]

GO

--===========================================
-- Inserción de los datos de la tabla ESTADO
--===========================================

INSERT INTO [dbo].[Estado] ([Nombre], [Descripcion], [Activo]) VALUES ('Solicitada', 'Solicitud de Usuario', 1)
INSERT INTO [dbo].[Estado] ([Nombre], [Descripcion], [Activo]) VALUES ('Confirmada', 'Usuario confirma la solicitud', 1)
INSERT INTO [dbo].[Estado] ([Nombre], [Descripcion], [Activo]) VALUES ('MinConfirmada', 'Ministerio confirma la solicitud', 1)
INSERT INTO [dbo].[Estado] ([Nombre], [Descripcion], [Activo]) VALUES ('Rechazada', 'Ministerio rechaza la solicitud', 1)
INSERT INTO [dbo].[Estado] ([Nombre], [Descripcion], [Activo]) VALUES ('Aprobada', 'Ministerio aprueba la solicitud', 1)
INSERT INTO [dbo].[Estado] ([Nombre], [Descripcion], [Activo]) VALUES ('Retiro', 'Ministerio retira el usuario del RUSICST', 1)

GO

--================================================================================================================================================
-- colocar los campos provenientes de la tabla de solicitud de usuario en la tabla usuario
--================================================================================================================================================
-- DOCUMENTO SOLICITUD
-- FECHA SOLICITUD
-- USUARIO TRAMITE (Se cambia el nombre a IdUserTramite de tipo nvarchar 128) Esta columna debe ser una llave foranea desde la tabla AspNetUsers	
-- FECHA NO REPUDIO
-- FECHA TRAMITE
-- FECHA CONFIRMACION
-- FECHA RETIRO (Se coloca como un nuevo campo para controlar en que fecha se retiro el usuario)
--===================================================================================================================================================
ALTER TABLE [dbo].[Usuario] ADD DocumentoSolicitud NVARCHAR(60)
ALTER TABLE [dbo].[Usuario] ADD FechaSolicitud DATETIME
ALTER TABLE [dbo].[Usuario] ADD FechaNoRepudio DATETIME
ALTER TABLE [dbo].[Usuario] ADD IdUsuarioTramite INT 
ALTER TABLE [dbo].[Usuario] ADD FechaTramite DATETIME
ALTER TABLE [dbo].[Usuario] ADD FechaConfirmacion DATETIME
ALTER TABLE [dbo].[Usuario] ADD FechaRetiro DATETIME
ALTER TABLE [dbo].[Usuario] ADD IdEstado INT
ALTER TABLE [dbo].[Usuario] ADD IdUser NVARCHAR(128)

GO

--==========================================================================================================
-- Se actualiza la información de las columnas adicionadas y se registra una actualización de 950 registros
--==========================================================================================================
UPDATE U
SET 
	U.DocumentoSolicitud = SU.DocumentoSolicitud,
	U.FechaSolicitud = SU.FechaSolicitud,
	U.FechaNoRepudio = SU.FechaNoRepudio,
	U.IdUsuarioTramite = (SELECT TOP 1 Id FROM Usuario WHERE Nombre = SU.UsuarioTramite),
	U.FechaTramite = SU.FechaTramite,
	U.FechaConfirmacion = SU.FechaConfirmacion,
	U.IdEstado = (
				  CASE 
					WHEN SU.Estado = 0 THEN 1
					WHEN SU.Estado = 1 THEN 2
					WHEN SU.Estado = 2 THEN 3
					WHEN SU.Estado = 3 THEN 4
					ELSE 5
				   END
				 )
FROM [dbo].[Usuario] U
INNER JOIN [AdministracionUsuarios].[SolicitudesUsuario] SU ON U.Nombre = SU.Nombres
														   AND U.IdDepartamento = SU.IdDepartamento 
														   AND U.IdMunicipio = SU.IdMunicipio	


GO

--==========================================================================================================
-- Eliminar las solicitudes rechazadas y que no son solicitudes hechas por alcaldias o gobernaciones
--==========================================================================================================
DELETE FROM [AdministracionUsuarios].[SolicitudesUsuario] 
WHERE Estado = 3 AND TipoUsuario NOT IN ('ALCALDIA', 'GOBERNACION') 

--==========================================================================================================
-- Eliminar las solicitudes confirmadas por el ministerio y que no son hechas por alcaldias o gobernaciones
--==========================================================================================================
DELETE FROM [AdministracionUsuarios].[SolicitudesUsuario] 
WHERE Estado = 2 AND TipoUsuario NOT IN ('ALCALDIA', 'GOBERNACION') 

--==========================================================================================================
-- Eliminar las solicitudes con fecha anterior al año actual y que quedaron en estado solicitud
--==========================================================================================================
DELETE FROM [AdministracionUsuarios].[SolicitudesUsuario] 
WHERE Estado = 0 AND YEAR(FechaSolicitud) < 2017

--==========================================================================================================
-- Eliminar las solicitudes con fecha anterior al año actual y que quedaron en estado confirmada
--==========================================================================================================
DELETE FROM [AdministracionUsuarios].[SolicitudesUsuario] 
WHERE Estado = 1 AND YEAR(FechaSolicitud) < 2017


--===========================================================================
-- Renombrar las columnas de la tabla de Usuario
--===========================================================================
EXEC sp_RENAME '[dbo].[Usuario].[Nombre]', 'Nombres', 'COLUMN'
EXEC sp_RENAME '[dbo].[Usuario].[EmailAlt]', 'EmailAlternativo', 'COLUMN'

GO

--=====================================================
-- Modificar la Columna Username colocandola como NULL
--=====================================================
ALTER TABLE [dbo].[Usuario] ALTER COLUMN [Username] VARCHAR(255) NULL
EXEC sp_RENAME '[dbo].[Usuario].[Username]', 'UserName', 'COLUMN'

GO

--===========================================================================
-- Crear la relacion entre el usuario que tramita y la tabla de usuarios
--===========================================================================
ALTER TABLE [dbo].[Usuario] WITH NOCHECK ADD CONSTRAINT FK_Usuario_Usuario FOREIGN KEY (IdUsuarioTramite) REFERENCES [dbo].[Usuario](Id);

GO

--===================================================================================================================================================
-- Actualizar todos los usuarios que estan en el RUSICTS a ESTADO APROBADO y que están en estado ACTIVO
-- Actualizar todos los usuarios que estan en el RUSICTS a ESTADO RETIRO y que están en estado INACTIVO

-- SELECT * FROM [dbo].[Usuario] WHERE IdEstado IS NULL AND Activo = 1 
-- SELECT * FROM [dbo].[Usuario] WHERE IdEstado IS NULL AND Activo = 0
-- SELECT * FROM [dbo].[Usuario] WHERE IdEstado IS NOT NULL AND Activo = 0

--==========================================
-- ESTOS REGISTROS QUEDAN CON DATOS EN NULL 
--==========================================
-- DOCUMENTO SOLICITUD
-- FECHA SOLICITUD
-- USUARIO TRAMITE (Se cambia el nombre a IdUserTramite de tipo nvarchar 128) Esta columna debe ser una llave foranea desde la tabla AspNetUsers	
-- FECHA NO REPUDIO
-- FECHA TRAMITE
-- FECHA CONFIRMACION
-- FECHA RETIRO (Se coloca como un nuevo campo para controlar en que fecha se retiro el usuario)
--===================================================================================================================================================
UPDATE [dbo].[Usuario] SET IdEstado = (SELECT Id FROM Estado WHERE Nombre = 'APROBADA') WHERE IdEstado IS NULL AND Activo = 1
UPDATE [dbo].[Usuario] SET IdEstado = (SELECT Id FROM Estado WHERE Nombre = 'RETIRO'), FechaRetiro = GETDATE() WHERE IdEstado IS NOT NULL AND Activo = 0
UPDATE [dbo].[Usuario] SET IdEstado = (SELECT Id FROM Estado WHERE Nombre = 'RETIRO'), FechaRetiro = GETDATE() WHERE IdEstado IS NULL AND Activo = 0

GO

--===================================================================================================================================================
-- ESTADO (Cambia de nombre a IdEstado - De tipo entero y se coloca como llave foranea entre la tabla Usuario y la tabla Estado)
--===================================================================================================================================================
ALTER TABLE [dbo].[Usuario] ADD CONSTRAINT FK_Usuario_Estado FOREIGN KEY (IdEstado) REFERENCES [dbo].[Estado](Id);

GO

--================================================================================================
-- Creación nuevamente del indice para el Estado la tabla [dbo].[Usuario]
--================================================================================================
CREATE NONCLUSTERED INDEX IDX_Estado ON [dbo].[Usuario] (IdEstado);

GO

--==========================================================================================================
-- Actualiza los datos de la tabla CAMPANA EMAIL actualizando la columna con el Id de la tabla TIPO USUARIO
--==========================================================================================================
UPDATE CE SET CE.TipoUsuario = TU.Id
FROM CampanaEmail CE
INNER JOIN TipoUsuario TU ON CE.TipoUsuario = TU.Tipo

GO

--==========================================================================================================
-- Renombrar el nombre TipoUsuario por IdTipoUsuario y Usuario por IdUsuario
--==========================================================================================================
EXEC sp_RENAME '[dbo].[CampanaEmail].[TipoUsuario]', 'IdTipoUsuario', 'COLUMN'
EXEC sp_RENAME '[dbo].[CampanaEmail].[Usuario]', 'IdUsuario', 'COLUMN'

GO

--==========================================================================================================================
-- Cambiar el tipo de dato de VARCHAR a INT y Colocar la llave foranea entre la tabla TIPO USUARIO y la tabla CAMPANA EMAIL
--==========================================================================================================================
ALTER TABLE [dbo].[CampanaEmail] ALTER COLUMN [IdTipoUsuario] INT
ALTER TABLE [dbo].[CampanaEmail] ADD CONSTRAINT FK_CampanaEmail_TipoUsuario FOREIGN KEY (IdTipoUsuario) REFERENCES [dbo].[TipoUsuario](Id);

GO

--=========================================================
-- Actualizar el nombre del usuario por el id del usuario 
--=========================================================
UPDATE CE SET CE.IdUsuario = U.Id
FROM CampanaEmail CE
INNER JOIN Usuario U ON CE.IdUsuario = U.UserName

GO

--===============================================================================================
-- Colocar la relacion entre la tabla de usuarios y la columna usuario de la tabla campana email
--===============================================================================================
ALTER TABLE [dbo].[CampanaEmail] ALTER COLUMN [IdUsuario] INT
ALTER TABLE [dbo].[CampanaEmail] ADD CONSTRAINT FK_CampanaEmail_Usuario FOREIGN KEY (IdUsuario) REFERENCES [dbo].[Usuario](Id);

GO

--=============================================================================================================
-- Se actualiza la tabla de [dbo].[Autoevaluacion2] colocando los Id del usuario donde se encontraba en nombre
--=============================================================================================================
UPDATE A SET A.Usuario = U.Id
FROM [dbo].[Autoevaluacion2] A
INNER JOIN Usuario U ON A.Usuario = U.UserName

GO

--===============================================================
-- Eliminamos el indice idx_usuario que tenía la columna Usuario
--===============================================================
IF (EXISTS (SELECT O.name Tabla, I.name Indice FROM sys.indexes I 
			INNER JOIN sys.objects O ON I.object_id = O.object_id 
			WHERE I.name = N'idx_usuario' AND O.name = N'Autoevaluacion2'))
BEGIN 
	DROP INDEX [idx_usuario] ON [dbo].[Autoevaluacion2]
END

GO

--================================================================================================================
-- Eliminamos el indice UNIQUE KEY unq_autoevaluacion2_obj que tiene las columnas IdEncuesta, Usuario, IdObjetivo
-- Set ONLINE = OFF para Enterprise Edition.  
--================================================================================================================
IF(EXISTS(SELECT O.name Tabla, I.name Indice FROM sys.indexes I 
		  INNER JOIN sys.objects O ON I.object_id = O.object_id 
		  WHERE I.name = N'unq_autoevaluacion2_obj' AND O.name = N'Autoevaluacion2'))
BEGIN
	ALTER TABLE [dbo].[Autoevaluacion2]  
	DROP CONSTRAINT unq_autoevaluacion2_obj  
	WITH (ONLINE = OFF);
END

GO

--============================================================
-- Cambiamos el tipo de dato de Varchar a Int 
--============================================================
ALTER TABLE [dbo].[Autoevaluacion2] ALTER COLUMN [Usuario] INT

GO

--==========================================================================
-- Renombremos la columna Usuario por IdUsuario
--==========================================================================
EXEC sp_RENAME '[dbo].[Autoevaluacion2].[Usuario]', 'IdUsuario', 'COLUMN'

GO

--=======================================================================================
-- Colocamos la llave foranea entre [dbo].[Autoevaluacion2] y a tabla de [dbo].[Usuario]
--=======================================================================================
ALTER TABLE [dbo].[Autoevaluacion2] ADD CONSTRAINT FK_Autoevaluacion_Usuario FOREIGN KEY (IdUsuario) REFERENCES [dbo].[Usuario](Id);

--===============================================================================================
-- Colocar nuevamente los indices borados de la tabla [dbo].[Autoevaluacion2]
--===============================================================================================
CREATE NONCLUSTERED INDEX IDX_Usuario ON [dbo].[Autoevaluacion2] (IdUsuario);
CREATE UNIQUE INDEX IDX_Encuesta_Usuario_Objetivo ON [dbo].[Autoevaluacion2] (IdEncuesta, IdUsuario, IdObjetivo);

GO

--===============================================================================================
-- Renombrer el indice del primary key de la tabla [dbo].[Autoevaluacion2]
--===============================================================================================
EXEC sp_rename N'dbo.Autoevaluacion2.PK__Autoeval__3214EC0732AB8735', N'PK_Autoevaluacion', N'INDEX';

GO