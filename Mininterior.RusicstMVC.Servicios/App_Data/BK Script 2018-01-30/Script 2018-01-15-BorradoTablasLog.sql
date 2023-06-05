--==============================================================
-- Elimina las tablas que manejan el LOG en la BD de producción
--==============================================================
IF(EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA ='dbo' AND TABLE_NAME='CategoryLog'))
DROP TABLE [dbo].[CategoryLog]
GO

IF(EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA ='dbo' AND TABLE_NAME='Log'))
DROP TABLE [dbo].[Log]
GO

IF(EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA ='dbo' AND TABLE_NAME='Category'))
DROP TABLE [dbo].[Category]
GO

--==================================================================================================
-- Elimina los procedimientos almacenados relacionados con las tablas de LOG en la BD de producción
--==================================================================================================
IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Log]') AND type in (N'P', N'PC')) 
DROP PROCEDURE [dbo].[C_Log]
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXCategoria]') AND type in (N'P', N'PC')) 
DROP PROCEDURE [dbo].[C_LogXCategoria]
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXExcepcion]') AND type in (N'P', N'PC')) 
DROP PROCEDURE [dbo].[C_LogXExcepcion]
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_LogInsert]') AND type in (N'P', N'PC')) 
DROP PROCEDURE [dbo].[I_LogInsert]
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaCategory]') AND type in (N'P', N'PC')) 
DROP PROCEDURE [dbo].[C_ListaCategory]
GO