IF  NOT EXISTS (select 1 from sys.columns where Name = N'modifica' and Object_ID = Object_ID(N'dbo.RetroArcPreguntasXEncuesta'))
BEGIN
	BEGIN TRANSACTION
	   ALTER TABLE [dbo].[RetroArcPreguntasXEncuesta] ADD
	    Modifica datetime NULL
	COMMIT
END

IF  NOT EXISTS (select 1 from sys.columns where Name = N'modifica' and Object_ID = Object_ID(N'dbo.RetroArcPreguntasXEncuestaXmunicipio'))
BEGIN
	BEGIN TRANSACTION
	   ALTER TABLE [dbo].[RetroArcPreguntasXEncuestaXmunicipio] ADD
	    Modifica datetime NULL
	COMMIT
END

GO


 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_RetroArcPreguntasInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_RetroArcPreguntasInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Equipo de desarrollo OIM - John Betancourt  
-- Create date: 05/09/2017  
-- Description: ingresa una nueva pregunta tipo archivo   
-- =============================================  
ALTER PROC [dbo].[I_RetroArcPreguntasInsert]   
	@IdRetroAdmin		 INT,  
    @IdEncuesta			INT, 
    @CodigoPregunta		VARCHAR(8),  
    @Documento			VARCHAR(50),  
    @Check				bit,
	@Sumar				bit,
    @Pertenece			INT,
    @Observacion		VARCHAR(500) = NULL,
	@Observacion2		VARCHAR(500) = NULL,
    @Valor				VARCHAR(500)
	  
AS  
  
-- Parámetros para el manejo de la respuesta    
 DECLARE @respuesta AS NVARCHAR(2000) = ''    
 DECLARE @estadoRespuesta  AS INT = 0    
  
 BEGIN    
  BEGIN TRANSACTION    
  BEGIN TRY     
 BEGIN  
  INSERT INTO [dbo].[RetroArcPreguntasXEncuesta]
           ([IdRetroAdmin]
           ,[IdEncuesta]
           ,[CodigoPregunta]
           ,[Documento]
           ,[Check]
		   ,[Sumariza]
           ,[Pertenece]
           ,[Observacion]
		   ,[Observacion2]
           ,[Valor]
		   ,[modifica])
     VALUES 
           (@IdRetroAdmin,
           @IdEncuesta,
           @CodigoPregunta,
           @Documento,
           @Check,
		   @Sumar,
           @Pertenece,
           replace(replace(replace(replace(@Observacion,'//',' '),char(0x000B), ' '),'*',' '),'"',' '),
		   replace(replace(replace(replace(@Observacion2,'//',' '),char(0x000B), ' '),'*',' '),'"',' '),
           @Valor,
		   getdate())  
      SELECT @respuesta = 'Se ha Ingresado el registro'    
	  SELECT @estadoRespuesta = 1  

	  INSERT INTO RetroArcPreguntasXEncuestaXmunicipio
	  SELECT @IdRetroAdmin, M.Id, @CodigoPregunta, @Documento, @Check, @Sumar, @Pertenece, @Observacion, @Valor, 'Admin', @Observacion2, getdate()
	  From Municipio M

 END  
 COMMIT  TRANSACTION    
  END TRY    
  BEGIN CATCH    
   ROLLBACK TRANSACTION    
   SELECT @respuesta = ERROR_MESSAGE()    
   SELECT @estadoRespuesta = 0    
  END CATCH    
 END    
    
 SELECT @respuesta AS respuesta, @estadoRespuesta AS estado       
   
GO


 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_RetroArcPreguntasUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_RetroArcPreguntasUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Equipo de desarrollo OIM - John Betancourt  
-- Create date: 05/09/2017  
-- Description: ingresa una nueva pregunta tipo archivo   
-- =============================================  
ALTER PROC [dbo].[U_RetroArcPreguntasUpdate]   
	@IdRetroArc			INT,
	@CodigoPregunta		VARCHAR(8),  
    @Documento			VARCHAR(50),  
    @Check				bit,
	@Sumar				bit,
    @Pertenece			INT,
    @Observacion		VARCHAR(500),
	@Observacion2		VARCHAR(500),
    @Valor				VARCHAR(500),
    @UltimoUsuario		VARCHAR(50)
	  
AS  
  
-- Parámetros para el manejo de la respuesta    
 DECLARE @respuesta AS NVARCHAR(2000) = ''    
 DECLARE @estadoRespuesta  AS INT = 0    
  
 BEGIN    
  BEGIN TRANSACTION    
  BEGIN TRY     
 BEGIN  
  UPDATE [dbo].[RetroArcPreguntasXEncuesta]
   SET [Documento] = @Documento
	  ,[Sumariza] = @Sumar
      WHERE Id = @IdRetroArc  
   
   IF not exists(select 1 from [dbo].[RetroArcPreguntasXEncuestaXmunicipio] WHERE CodigoPregunta = @CodigoPregunta AND [Documento] = @Documento and [Sumariza] = @Sumar)
   BEGIN
   UPDATE [dbo].[RetroArcPreguntasXEncuestaXmunicipio] 
	SET [Documento] = @Documento
	  ,[Sumariza] = @Sumar
	  ,[Modifica] = GETDATE()
	  ,[UltimoUsuario] = @UltimoUsuario 
      WHERE CodigoPregunta = @CodigoPregunta 
	END
   
   SELECT @respuesta = 'Se ha Actualizado el registro'    
   SELECT @estadoRespuesta = 2
 END  
 COMMIT  TRANSACTION    
  END TRY    
  BEGIN CATCH    
   ROLLBACK TRANSACTION    
   SELECT @respuesta = ERROR_MESSAGE()    
   SELECT @estadoRespuesta = 0    
  END CATCH    
 END    
    
 SELECT @respuesta AS respuesta, @estadoRespuesta AS estado       
   
GO


 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_RetroArcPreguntasUpdateXUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_RetroArcPreguntasUpdateXUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Equipo de desarrollo OIM - John Betancourt  
-- Create date: 05/09/2017  
-- Description: ingresa una nueva pregunta tipo archivo   
-- =============================================  
ALTER PROC [dbo].[U_RetroArcPreguntasUpdateXUsuario]   
	@IdRetroArc			INT,
    @Check				bit,
    @Pertenece			INT,
    @Observacion		VARCHAR(500),
	@Observacion2		VARCHAR(500),
    @Valor				VARCHAR(500),
    @UltimoUsuario		VARCHAR(50)
	  
AS  
  
-- Parámetros para el manejo de la respuesta    
 DECLARE @respuesta AS NVARCHAR(2000) = ''    
 DECLARE @estadoRespuesta  AS INT = 0    
  
 BEGIN    
  BEGIN TRANSACTION    
  BEGIN TRY     
 BEGIN  
  UPDATE [dbo].[RetroArcPreguntasXEncuestaXmunicipio]
   SET [Check] = @Check
      ,[Pertenece] = @Pertenece
      ,[Observacion] = replace(replace(replace(replace(@Observacion,'//',' '),char(0x000B), ' '),'*',' '),'"',' ')
	  ,[Observacion2] = replace(replace(replace(replace(@Observacion2,'//',' '),char(0x000B), ' '),'*',' '),'"',' ')
      ,[Valor] = @Valor
	  ,[modifica] = GETDATE()
	  ,[UltimoUsuario] = @UltimoUsuario
      WHERE Id = @IdRetroArc  
      SELECT @respuesta = 'Se ha Actualizado el registro'    
   SELECT @estadoRespuesta = 2
 END  
 COMMIT  TRANSACTION    
  END TRY    
  BEGIN CATCH    
   ROLLBACK TRANSACTION    
   SELECT @respuesta = ERROR_MESSAGE()    
   SELECT @estadoRespuesta = 0    
  END CATCH    
 END    
    
 SELECT @respuesta AS respuesta, @estadoRespuesta AS estado       
   
GO