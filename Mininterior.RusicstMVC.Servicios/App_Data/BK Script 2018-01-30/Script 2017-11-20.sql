IF EXISTS(SELECT * FROM information_schema.[columns] WHERE table_name='RetroArcPreguntasXEncuesta' AND column_name='Observacion2')
BEGIN
 PRINT 'existe la columna :Observacion2'
END
ELSE
BEGIN
  ALTER TABLE RetroArcPreguntasXEncuesta ADD Observacion2 VARCHAR(500) NULL
END 

IF EXISTS(SELECT * FROM information_schema.[columns] WHERE table_name='RetroArcPreguntasXEncuestaXmunicipio' AND column_name='Observacion2')
BEGIN
 PRINT 'existe la columna :Observacion2'
END
ELSE
BEGIN
  ALTER TABLE RetroArcPreguntasXEncuestaXmunicipio ADD Observacion2 VARCHAR(500) NULL
END 

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
      ,[Check] = @Check
	  ,[Sumariza] = @Sumar
      ,[Pertenece] = @Pertenece
      ,[Observacion] = @Observacion
	  ,[Observacion2] = @Observacion2
      ,[Valor] = @Valor
      WHERE Id = @IdRetroArc  
   
   UPDATE [dbo].[RetroArcPreguntasXEncuestaXmunicipio] 
	SET [Documento] = @Documento
	  ,[Sumariza] = @Sumar
      ,[Pertenece] = @Pertenece
      ,[Observacion2] = @Observacion2
      WHERE CodigoPregunta = @CodigoPregunta 
   
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
           ,[Valor])
     VALUES 
           (@IdRetroAdmin,
           @IdEncuesta,
           @CodigoPregunta,
           @Documento,
           @Check,
		   @Sumar,
           @Pertenece,
           @Observacion,
		   @Observacion2,
           @Valor)  
      SELECT @respuesta = 'Se ha Ingresado el registro'    
	  SELECT @estadoRespuesta = 1  

	  INSERT INTO RetroArcPreguntasXEncuestaXmunicipio
	  SELECT @IdRetroAdmin, M.Id, @CodigoPregunta, @Documento, @Check, @Sumar, @Pertenece, @Observacion, @Valor, 'Admin', @Observacion2
	  From Municipio M

	 -- from [BancoPreguntas].[Preguntas] P
		--INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
		--INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
		--INNER JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @IdEncuesta
		--INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
		--RIGHT JOIN Respuesta R ON R.IdPregunta = PO.Id --AND R.IdUsuario = @IdUser
		--INNER JOIN Usuario U ON R.IdUsuario = U.Id
		--INNER JOIN Municipio M on M.Id = U.IdMunicipio
		
	 -- from Municipio M
		--INNER JOIN Usuario U ON M.Id = U.IdMunicipio
		--LEFT JOIN Respuesta R ON R.IdUsuario = U.Id
		--LEFT JOIN Pregunta PO ON R.IdPregunta = PO.Id
		--LEFT JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on  PA.IdPreguntaAnterior = PO.Id
		--LEFT JOIN [BancoPreguntas].[Preguntas] P on P.IdPregunta = PA.IdPregunta
		--LEFT JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @IdEncuesta
		--LEFT JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id		  
		--WHERE P.IdTipoPregunta = 1 AND UserName like 'alcaldi%'
		--AND CodigoPregunta = @CodigoPregunta 

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
      ,[Observacion] = @Observacion
	  ,[Observacion2] = @Observacion2
      ,[Valor] = @Valor
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroRevPreguntasXIdRetroxUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroRevPreguntasXIdRetroxUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 07/09/2017
-- Description:	obtiene la informacion de las pregntas de revision en realimentacion
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroRevPreguntasXIdRetroxUsuario] 

	@IdRetroAdmin 				INT,
	@UserName					VARCHAR(50),
	@IdEncuesta					INT

AS

DECLARE @IdUser varchar(100)
DECLARE @IdMunicipio INT
select @IdUser = Id, @IdMunicipio = IdMunicipio from Usuario where UserName = @UserName

SELECT 
		RAP.Id
      ,RAP.[CodigoPregunta]
	  ,RAP.Documento Nombre
      ,r.Valor
	  ,CAST(CASE r.Valor
		WHEN ISNULL(r.Valor,0) THEN 1
		ELSE 0 END as bit) Envio
	  ,RAP.Sumariza Sumatoria
	  ,RAP.Pertenece Corresponde
	  ,RAP.Observacion Observaciones
	  ,RAP.Observacion2 Observaciones2
  FROM [dbo].[RetroArcPreguntasXEncuestaXMunicipio] RAP
  INNER JOIN [BancoPreguntas].[Preguntas] P on RAP.CodigoPregunta = P.CodigoPregunta
  INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
  INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
  INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
  INNER JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @IdEncuesta
  LEFT JOIN Respuesta r ON PO.Id = r.IdPregunta AND r.IdUsuario = @IdUser
  WHERE [IdRetroAdmin] = @IdRetroAdmin AND IdMunicipio = @IdMunicipio 

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroRevPreguntasXIdRetro]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroRevPreguntasXIdRetro] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 07/09/2017
-- Description:	obtiene la informacion de las pregntas de revision en realimentacion
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroRevPreguntasXIdRetro] 

	@IdRetroAdmin 				INT

AS

SELECT 
		RAP.Id
      ,RAP.IdEncuesta 
      ,RAP.[CodigoPregunta]
	  ,RAP.Documento Nombre
      ,RAP.Valor
	  ,RAP.[Check] Envio
	  ,RAP.Sumariza Sumatoria
	  ,RAP.Pertenece Corresponde
	  ,RAP.Observacion Observaciones
	  ,RAP.Observacion2 Observaciones2
  FROM [dbo].[RetroArcPreguntasXEncuesta] RAP
  INNER JOIN [BancoPreguntas].[Preguntas] P on RAP.CodigoPregunta = P.CodigoPregunta
  INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
  WHERE [IdRetroAdmin] = @IdRetroAdmin

GO