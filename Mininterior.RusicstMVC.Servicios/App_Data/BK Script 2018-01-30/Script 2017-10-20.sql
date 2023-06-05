IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_ContenidoSeccionDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_ContenidoSeccionDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================  
-- Author:  Equipo de desarrollo - OIM  
-- Create date: 17/06/2017  
-- Description: Procedimiento que elimina las secciones en cascada  
-- Modificacion: John Betancourt Devolver el valor de los parametros  
-- Modificacion 18/10/2017 : John Betancourt validar que si existe respuesta no pueda eliminar
-- =================================================================  
ALTER PROC [dbo].[D_ContenidoSeccionDelete]  
(  
 @IdSeccion INT  
)  
  
AS  
  
 BEGIN  
   
  SET NOCOUNT ON;  
  
  DECLARE @respuesta AS NVARCHAR(2000) = ''  
  DECLARE @estadoRespuesta  AS INT = 0   
  DECLARE @esValido AS BIT = 1  
  

     IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion))  
     BEGIN  
		SET @esValido = 0
		SET @respuesta += 'No es posible eliminar el registro. Se encontraron datos asociados.'
      
     END  
    
	IF(@esValido = 1) BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

		 IF EXISTS(SELECT 1 FROM [BancoPreguntas].[PreguntaModeloAnterior] WHERE IdPreguntaAnterior IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion))  
		 BEGIN  
		  DELETE FROM [BancoPreguntas].[PreguntaModeloAnterior]  
		  WHERE [IdPreguntaAnterior] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion)  
		 END  
   
		 IF EXISTS(SELECT 1 FROM [dbo].[Opciones] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion))  
		 BEGIN  
		  DELETE FROM [dbo].[Opciones]  
		  WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion)  
		 END  
   
		 DELETE FROM [dbo].[Diseno]  
		 WHERE [IdSeccion] = @IdSeccion  
   
		 DELETE FROM [dbo].[Pregunta]  
		 WHERE [IdSeccion] = @IdSeccion  
  
		 SELECT @respuesta = 'Se ha eliminado el registro'  
		 SELECT @estadoRespuesta = 3  
   
		COMMIT  TRANSACTION  
		END TRY  
  
		BEGIN CATCH  
		 ROLLBACK TRANSACTION  
		 SELECT @respuesta = ERROR_MESSAGE()  
		 SELECT @estadoRespuesta = 0  
		END CATCH  
	   END
	END
   
      
   SELECT @respuesta AS respuesta, @estadoRespuesta AS estado  

GO

--delete from [RetroHistorialRusicst] where Periodo = '2017-1'
--delete from [RetroHistorialRusicst] where Periodo = '2016-2'

IF NOT EXISTS (SELECT 1 FROM [RetroHistorialRusicst] where Periodo = '2016-2')
BEGIN
	INSERT INTO [dbo].[RetroHistorialRusicst]
	SELECT	UserName AS Usuario, '2016-2' AS Periodo, 1 AS Guardo, 1 AS Completo, 1 AS Diligencio, 1 AS Adjunto, 1 AS Envio , 
		null AS CodigoPregunta, null IdEncuesta, null Nombre from Usuario where UserName like 'alcaldia%'

	INSERT INTO [dbo].[RetroHistorialRusicst]
	SELECT	UserName AS Usuario, '2017-1' AS Periodo, 1 AS Guardo, 1 AS Completo, 1 AS Diligencio, 1 AS Adjunto, 1 AS Envio , 
		null AS CodigoPregunta, null IdEncuesta, null Nombre from Usuario where UserName like 'alcaldia%'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_abriaqui_antioquia' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 1, Diligencio = 1, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_angelopolis_antioquia' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_caicedo_antioquia' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 1, Diligencio = 1, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_dabeiba_antioquia' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 1, Diligencio = 1, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_sabanalarga_antioquia' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_salgar_antioquia' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_venecia_antioquia' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_galapa_atlantico' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_juan_de_acosta_atlantico' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_manati_atlantico' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_santa lucia_atlantico' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_cordoba_bolivar' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 1, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_el_peñon_bolivar' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_maria_la_baja_bolivar' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_norosi_bolivar' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_chiquiza_boyaca' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 1, Diligencio = 1, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_cubara_boyaca' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_cuitiva_boyaca' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 1, Diligencio = 1, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_cuitiva_boyaca' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_la_victoria_boyaca' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_maripi_boyaca' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_mongui_boyaca' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 1, Diligencio = 1, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_tenza_boyaca' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_tutaza_boyaca' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 1, Diligencio = 1, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_curillo_caqueta' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_solano_caqueta' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_solita_caqueta' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_mercaderes_cauca' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_san_sebastian_cauca' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_suarez_cauca' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_agustin_codazzi_cesar' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_altobaudo_choco' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_rioiro_choco' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_momil_cordoba' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_cota_cundinamarca' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 0, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_nemocon_cundinamarca' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_ubala_cundinamarca' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_inIrida_guainIa' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_ariguani_magdalena' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_puebloviejo_magdalena' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_santabarbaradepinto_magdalena' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_el_tablon_de_gomez_nariño' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_el_tablon_de_gomez_nariño' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 0, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_francisco_pizarro_nariño' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_imues_nariño' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_ipiales_nariño' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_mosquera_nariño' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_los patios_norte_de_santander' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_puerto_leguizamo_putumayo' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 1, Diligencio = 1, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_aguada_santander' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_guapota_santander' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 1, Diligencio = 1, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_socorro_santander' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_buenavista_sucre' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 0, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_la_union_sucre' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_san_marcos_sucre' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_san_marcos_sucre' AND Periodo = '2017-1'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_santiago de tolu_sucre' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_ataco_tolima' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_coyaima_tolima' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_suarez_tolima' AND Periodo = '2016-2'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = 1, Completo = 0, Diligencio = 0, Adjunto = 0, Envio = 0
	WHERE Usuario = 'alcaldia_el_cerrito_valle_del_cauca' AND Periodo = '2016-2'

	INSERT INTO [dbo].[RetroHistorialRusicst]
	SELECT	UserName AS Usuario, '2016-2' AS Periodo, 1 AS Guardo, 1 AS Completo, 1 AS Diligencio, 1 AS Adjunto, 1 AS Envio , 
		null AS CodigoPregunta, null IdEncuesta, null Nombre from Usuario where UserName like 'gobernaci%'

	INSERT INTO [dbo].[RetroHistorialRusicst]
	SELECT	UserName AS Usuario, '2017-1' AS Periodo, 1 AS Guardo, 1 AS Completo, 1 AS Diligencio, 1 AS Adjunto, 1 AS Envio , 
		null AS CodigoPregunta, null IdEncuesta, null Nombre from Usuario where UserName like 'gobernaci%'

	UPDATE [dbo].[RetroHistorialRusicst]
	SET Guardo = null, Completo = null, Diligencio = null, Adjunto = null, Envio = null
	WHERE Usuario = 'gobernacion_san_andres' AND Periodo = '2016-2'
END
ELSE
	SELECT 'Ya existen estos valores'

GO

--=========================================================================================================================
-- Categorías para auditoría
--=========================================================================================================================
IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Retornos Reubicaciones Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Seguimiento Retornos Reubicaciones Municipio', 148)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Retornos Reubicaciones Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Seguimiento Retornos Reubicaciones Municipio', 149)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Seguimiento Reparacion Colectiva Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Seguimiento Seguimiento Reparacion Colectiva Municipio', 150)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Reparacion Colectiva Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Seguimiento Reparacion Colectiva Municipio', 151)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Seguimiento Otros Derechos Medidas Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Seguimiento Otros Derechos Medidas Municipio', 152)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Otros Derechos Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Seguimiento Otros Derechos Municipio', 153)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Otros Derechos Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Seguimiento Otros Derechos Municipio', 154)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Otros Derechos Medidas Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Seguimiento Otros Derechos Medidas Municipio', 155)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Otros Derechos Medidas Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Seguimiento Otros Derechos Medidas Municipio', 156)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento PAT Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Seguimiento PAT Municipio', 157)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento PAT Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Seguimiento PAT Municipio', 158)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'ELiminar Programas Seguimiento PAT Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('ELiminar Programas Seguimiento PAT Municipio', 159)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Programa Seguimiento PAT Gobernación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Programa Seguimiento PAT Gobernación', 160)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Programa Seguimiento PAT Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Programa Seguimiento PAT Municipio', 161)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Programa Seguimiento PAT Municipio'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Programa Seguimiento PAT Municipio', 162)
GO

UPDATE [dbo].[Category] SET [CategoryName] = 'Editar Análisis Recomendación Realimentación' WHERE [Ordinal] = 104
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Preguntas Desarrollo Realimentación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Preguntas Desarrollo Realimentación', 163)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Grafica Desarrollo Realimentación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Grafica Desarrollo Realimentación', 164)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Preguntas Arc Realimentación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Preguntas Arc Realimentación', 165)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Preguntas Arc Realimentación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Preguntas Arc Realimentación', 166)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Preguntas Arc Realimentación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Preguntas Arc Realimentación', 167)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Historial Encuesta Realimentación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Historial Encuesta Realimentación', 168)
GO

