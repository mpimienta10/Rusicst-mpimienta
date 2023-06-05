IF  NOT EXISTS (select 1 from sys.columns where Name = N'AsuntoEnvioR' and Object_ID = Object_ID(N'dbo.Sistema'))
BEGIN
	BEGIN TRANSACTION
	   ALTER TABLE [dbo].[Sistema] ADD
	    AsuntoEnvioR varchar(255) NULL
	COMMIT
END

GO

IF  NOT EXISTS (select 1 from sys.columns where Name = N'AsuntoEnvioPT' and Object_ID = Object_ID(N'dbo.Sistema'))
BEGIN
	BEGIN TRANSACTION
	   ALTER TABLE [dbo].[Sistema] ADD
	    AsuntoEnvioPT varchar(255) NULL
	COMMIT
END

GO

IF  NOT EXISTS (select 1 from sys.columns where Name = N'AsuntoEnvioSeguimientoT1' and Object_ID = Object_ID(N'dbo.Sistema'))
BEGIN
	BEGIN TRANSACTION
	   ALTER TABLE [dbo].[Sistema] ADD
	    AsuntoEnvioSeguimientoT1 varchar(255) NULL
	COMMIT
END

GO

IF  NOT EXISTS (select 1 from sys.columns where Name = N'AsuntoEnvioSeguimientoT2' and Object_ID = Object_ID(N'dbo.Sistema'))
BEGIN
	BEGIN TRANSACTION
	   ALTER TABLE [dbo].[Sistema] ADD
	    AsuntoEnvioSeguimientoT2 varchar(255) NULL
	COMMIT
END

GO

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosSistema]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosSistema] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=====================================================================================================  
-- Autor: Liliana Rodriguez      
-- Modificacion: Equipo de desarrollo OIM - John Betancourt A.    - Adicionar los campos de asuntos nuevos, a la consulta               
-- Fecha creacion: 2017-02-09                      
-- Fecha modificacion: 2018-02-26                      
-- Descripcion: Carga los datos de los parámetros del sistema        
--=====================================================================================================  
ALTER PROCEDURE [dbo].[C_DatosSistema]  
  
AS  
  
SELECT   
  [Id]  
 ,[FromEmail]  
 ,[SmtpHost]  
 ,[SmtpPort]  
 ,[SmtpEnableSsl]  
 ,[SmtpUsername]  
 ,[SmtpPassword]  
 ,[TextoBienvenida]  
 ,[FormatoFecha]  
 ,[PlantillaEmailPassword]  
 ,[UploadDirectory]  
 ,[PlantillaEmailConfirmacion]  
 ,[SaveMessageConfirmPopup]  
 ,[PlantillaEmailConfirmacionPlaneacionPat]  
 ,[PlantillaEmailConfirmacionSeguimiento1Pat]  
 ,[PlantillaEmailConfirmacionSeguimiento2Pat]  
 ,[AsuntoEnvioR]
 ,[AsuntoEnvioPT]
 ,[AsuntoEnvioSeguimientoT1]
 ,[AsuntoEnvioSeguimientoT2]
FROM   
 [dbo].[Sistema]  
  

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_SistemaUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_SistemaUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================  
-- Author:  Equipo de desarrollo OIM - Christian Ospina  
-- Modificacion: Equipo de desarrollo OIM - John Betancourt A.   -- Actualizar la informacion de los 4 campos nuevos de asusntos
-- Create date: 13/03/2017  
-- Fecha creacion: 2017-02-09                      
-- Description: Actualiza un registro en la tabla SISTEMA   
--    Retorna: select @respuesta as respuesta, @estadoRespuesta as estado            
--    @estadoRespuesta int = 0 no hace nada, 2 actualizado            
--    respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'   
-- ================================================================================================  
ALTER PROCEDURE [dbo].[U_SistemaUpdate]   
   
  @Id       INT  
 ,@FromEmail      VARCHAR(255)  
 ,@SmtpHost      VARCHAR(255)  
 ,@SmtpPort      INT  
 ,@SmtpEnableSsl     BIT  
 ,@SmtpUsername     VARCHAR(255)  
 ,@SmtpPassword     VARCHAR(255)  
 ,@TextoBienvenida    VARCHAR(MAX)  
 ,@FormatoFecha     VARCHAR(255)  
 ,@PlantillaEmailPassword  VARCHAR(MAX)  
 ,@UploadDirectory    VARCHAR(1000)  
 ,@PlantillaEmailConfirmacion VARCHAR(MAX)  
 ,@SaveMessageConfirmPopup  VARCHAR(255)  
 ,@PlantillaEmailConfirmacionPlaneacionPat VARCHAR(MAX)  
 ,@PlantillaEmailConfirmacionSeguimiento1Pat VARCHAR(MAX)  
 ,@PlantillaEmailConfirmacionSeguimiento2Pat VARCHAR(MAX)  
 ,@AsuntoEnvioR    VARCHAR(1000)  
 ,@AsuntoEnvioPT    VARCHAR(1000)  
 ,@AsuntoEnvioSeguimientoT1    VARCHAR(1000)  
 ,@AsuntoEnvioSeguimientoT2    VARCHAR(1000)  
   
  
AS  
 BEGIN  
    
  SET NOCOUNT ON;  
  
  DECLARE @respuesta AS NVARCHAR(2000) = ''  
  DECLARE @estadoRespuesta  AS INT = 0   
  DECLARE @esValido AS BIT = 1  
   
  IF(@esValido = 1)   
   BEGIN  
    BEGIN TRANSACTION  
    BEGIN TRY  
     UPDATE   
      [dbo].[Sistema]  
     SET   
      [FromEmail] = @FromEmail, [SmtpHost] = @SmtpHost, [SmtpPort] = @SmtpPort, [SmtpEnableSsl] = @SmtpEnableSsl,   
      [SmtpUsername] = @SmtpUsername, [SmtpPassword] = @SmtpPassword, [TextoBienvenida] = @TextoBienvenida,   
      [FormatoFecha] = @FormatoFecha, [PlantillaEmailPassword] = @PlantillaEmailPassword, [UploadDirectory] = @UploadDirectory,   
      [PlantillaEmailConfirmacion] = @PlantillaEmailConfirmacion, [SaveMessageConfirmPopup] = @SaveMessageConfirmPopup  
      ,PlantillaEmailConfirmacionPlaneacionPat =@PlantillaEmailConfirmacionPlaneacionPat   
      ,PlantillaEmailConfirmacionSeguimiento1Pat=@PlantillaEmailConfirmacionSeguimiento1Pat   
      ,PlantillaEmailConfirmacionSeguimiento2Pat=@PlantillaEmailConfirmacionSeguimiento2Pat 
	  ,AsuntoEnvioR = @AsuntoEnvioR  
	  ,AsuntoEnvioPT = @AsuntoEnvioPT
	  ,AsuntoEnvioSeguimientoT1 = @AsuntoEnvioSeguimientoT1
	  ,AsuntoEnvioSeguimientoT2 = @AsuntoEnvioSeguimientoT2
     WHERE [Id] = @Id  
  
     SELECT @respuesta = 'Se ha actualizado el registro'  
     SELECT @estadoRespuesta = 2  
   
     COMMIT  TRANSACTION  
    END TRY  
  
    BEGIN CATCH  
     ROLLBACK TRANSACTION  
     SELECT @respuesta = ERROR_MESSAGE()  
     SELECT @estadoRespuesta = 0  
    END CATCH  
   END  
  
  SELECT @respuesta AS respuesta, @estadoRespuesta AS estado  
  
 END  
  