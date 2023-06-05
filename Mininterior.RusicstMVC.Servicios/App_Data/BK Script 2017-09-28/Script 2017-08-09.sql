if exists (select object_id from sys.all_objects where name ='C_TodosTableros')
DROP PROCEDURE [PAT].[C_TodosTableros]
GO
Create PROC [PAT].[C_TodosTableros] 
AS
BEGIN
	select	A.[Id],	A.VigenciaInicio, A.VigenciaFin, A.Activo	from	[PAT].[Tablero] A	
END

go
if exists (select object_id from sys.all_objects where name ='C_TodasMedidas')
DROP PROCEDURE [PAT].[C_TodasMedidas]
GO

create procedure [PAT].[C_TodasMedidas] 
AS
BEGIN
	SELECT  M.Id, M.Descripcion
	FROM  [PAT].Medida as M
	ORDER BY M.Descripcion	
END

--drop table [Retro.ConsultaEncuesta]
--  select * from [Retro.ConsultaEncuesta]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Retro.ConsultaEncuesta]')) 
BEGIN
	-- =============================================
	-- Author:		Equipo de desarrollo OIM - John Betancourt
	-- Create date: 1/08/2017
	-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
	-- =============================================
	CREATE TABLE [Retro.ConsultaEncuesta](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[IdEncuesta] [int] NOT NULL,
		[Presentacion] [varchar](50) NOT NULL,
		[PresTexto] [varchar](max) NOT NULL,
		[Nivel] [varchar](50) NOT NULL,
		[NivTexto] [varchar](max) NOT NULL,
		[Nivel2] [varchar](50) NOT NULL,
		[Niv2Texto] [varchar](max) NOT NULL,
		[NivIdGrafica] [int]  NULL,
		[Desarrollo] [varchar](50) NOT NULL,
		[DesTexto] [varchar](max) NOT NULL,
		[Desarrollo2] [varchar](50) NOT NULL,
		[Des2Texto] [varchar](max) NOT NULL,
		[DesIdGrafica] [int]  NULL,
		[Analisis] [varchar](50) NOT NULL,
		[AnaTexto] [varchar](max) NOT NULL,
		[Revision] [varchar](50) NOT NULL,
		[RevTexto] [varchar](max) NOT NULL,
		[Historial] [varchar](50) NOT NULL,
		[HisTexto] [varchar](max) NOT NULL,
		[Observa] [varchar](50) NOT NULL,
		[ObsTexto] [varchar](max) NOT NULL
	 CONSTRAINT [PK_Retro.ConsultaEncuesta] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	ALTER TABLE [Retro.ConsultaEncuesta]  WITH CHECK ADD  CONSTRAINT [FK_Retro.ConsultaEncuesta_Encuesta] FOREIGN KEY([IdEncuesta])
	REFERENCES [dbo].[Encuesta] ([Id])
END

GO

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_EncuestaRetroUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_EncuestaRetroUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================  
-- Autor: Equipo de desarrollo OIM - John Betancourt A. 
-- Fecha creacion: 2017-08-04
-- Descripcion: Actualiza un registro en la realiemntacion                     
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado            
-- Estado int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado            
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'      
--====================================================================================================  
ALTER PROC [dbo].[U_EncuestaRetroUpdate]   
 
	@IdEncuesta int = NULL,
	@Presentacion  varchar(50) = NULL,
	@PresTexto varchar(max) = NULL,
	@Nivel varchar(50) = NULL,
	@NivTexto varchar(max) = NULL,
	@Nivel2 varchar(50) = NULL,
	@Niv2Texto varchar(max) = NULL,
	@NivIdGrafica int = NULL,
	@Desarrollo varchar(50) = NULL,
	@DesTexto varchar(max) = NULL,
	@Desarrollo2 varchar(50) = NULL,
	@Des2Texto varchar(max) = NULL,
	@DesIdGrafica int = NULL,
	@Analisis varchar(50) = NULL,
	@AnaTexto varchar(max) = NULL,
	@Revision varchar(50) = NULL,
	@RevTexto varchar(max) = NULL,
	@Historial varchar(50) = NULL,
	@HisTexto varchar(max) = NULL,
	@Observa varchar(50) = NULL,
	@ObsTexto varchar(max) = NULL,
	@IdTipoGuardado int = NULL
AS   
  
 -- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0  
 DECLARE @esValido AS BIT = 1  
  
   
 IF(@esValido = 1)   
 BEGIN  
  BEGIN TRANSACTION  
  BEGIN TRY  

	IF(@IdTipoGuardado = 1)
		BEGIN
		   UPDATE   
			[dbo].[Retro.ConsultaEncuesta]  
		   SET      
			Presentacion = @Presentacion,
			PresTexto  = @PresTexto  
		   WHERE    
			IdEncuesta = @IdEncuesta
		END 
	ELSE IF(@IdTipoGuardado = 2)
		BEGIN
		   UPDATE   
			[dbo].[Retro.ConsultaEncuesta]  
		   SET      
			Nivel = @Nivel,
			NivTexto = @NivTexto,
			Nivel2 = @Nivel2,
			Niv2Texto = @Niv2Texto,
			NivIdGrafica = @NivIdGrafica
		   WHERE    
			IdEncuesta = @IdEncuesta
		END
	ELSE IF(@IdTipoGuardado = 3)
		BEGIN
		   UPDATE   
			[dbo].[Retro.ConsultaEncuesta]  
		   SET
		   	Desarrollo = @Desarrollo,
			DesTexto = @DesTexto,
			Desarrollo2 = @Desarrollo2,
			Des2Texto = @Des2Texto,
			DesIdGrafica = @DesIdGrafica
         WHERE    
			IdEncuesta = @IdEncuesta
		END
	ELSE IF(@IdTipoGuardado = 4)
		BEGIN
		   UPDATE   
			[dbo].[Retro.ConsultaEncuesta]  
		   SET
		   	Analisis = @Analisis,
			AnaTexto = @AnaTexto
         WHERE    
			IdEncuesta = @IdEncuesta
		END    
	ELSE IF(@IdTipoGuardado = 5)
		BEGIN
		   UPDATE   
			[dbo].[Retro.ConsultaEncuesta]  
		   SET
			Revision = @Revision,
			RevTexto = @RevTexto
         WHERE    
			IdEncuesta = @IdEncuesta
		END
	ELSE IF(@IdTipoGuardado = 6)
		BEGIN
		   UPDATE   
			[dbo].[Retro.ConsultaEncuesta]  
		   SET
			Historial = @Historial,
			HisTexto = @HisTexto
         WHERE    
			IdEncuesta = @IdEncuesta
		END
	ELSE IF(@IdTipoGuardado = 7)
		BEGIN
		   UPDATE   
			[dbo].[Retro.ConsultaEncuesta]  
		   SET
			Observa = @Observa,
			ObsTexto = @ObsTexto
         WHERE    
			IdEncuesta = @IdEncuesta
		END      
	
       
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
 
 GO

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 1/08/2017
-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroEncuesta] 

	@IdEncuesta					INT

AS

SELECT [Id]
      ,[IdEncuesta]
      ,[Presentacion]
      ,[PresTexto]
      ,[Nivel]
      ,[NivTexto]
      ,[Nivel2]
      ,[Niv2Texto]
      ,[NivIdGrafica]
      ,[Desarrollo]
      ,[DesTexto]
      ,[Desarrollo2]
      ,[Des2Texto]
      ,[DesIdGrafica]
      ,[Analisis]
      ,[AnaTexto]
      ,[Revision]
      ,[RevTexto]
      ,[Historial]
      ,[HisTexto]
      ,[Observa]
      ,[ObsTexto]
  FROM [dbo].[Retro.ConsultaEncuesta]
  Where [IdEncuesta] = @IdEncuesta
GO


--truncate table [dbo].[Retro.ConsultaEncuesta]
--GO
--SET IDENTITY_INSERT [dbo].[Retro.ConsultaEncuesta] ON 
--GO
--INSERT [dbo].[Retro.ConsultaEncuesta] ([Id], [IdEncuesta], [Presentacion], [PresTexto], [Nivel], [NivTexto], [Nivel2], [Niv2Texto], [NivIdGrafica], [Desarrollo], [DesTexto], [Desarrollo2], [Des2Texto], [DesIdGrafica], [Analisis], [AnaTexto], [Revision], [RevTexto], [Historial], [HisTexto], [Observa], [ObsTexto]) VALUES (1, 27, N'encuetas de alcaldia la 1', N'guardod 7 agosto 2222', N'1. Nivel de Diligenciamiento prueba con ANgela', N'guardado 8 de agosto', N'1.1. Porcentaje de diligenciamiento', N'8 agosto', NULL, N'2. Desarrollo de la politica pública de Atención', N'GUARDADO DESSA', N'2.1 Nivel de avance por fases', N'GUARDO BIEN', NULL, N'3. Analisis del Plan de Mejoramiento Municipal', N'GUARD ANALISI BIEN', N'4. Revision de Archivos adjuntos', N'GUARD ARCHIVOS', N'5. Historial de Envio Rusicts', N'GUARDO HISTORIAL', N'6. Observaciones Generales', N'GUARVOB BIEN OBSERVCION')
--GO
--INSERT [dbo].[Retro.ConsultaEncuesta] ([Id], [IdEncuesta], [Presentacion], [PresTexto], [Nivel], [NivTexto], [Nivel2], [Niv2Texto], [NivIdGrafica], [Desarrollo], [DesTexto], [Desarrollo2], [Des2Texto], [DesIdGrafica], [Analisis], [AnaTexto], [Revision], [RevTexto], [Historial], [HisTexto], [Observa], [ObsTexto]) VALUES (2, 16, N'Presentación', N'El presente Informe de Retroalimentación contiene el análisis realizado por el Ministerio del Interior y la Unidad para las Víctimas, sobre la información reportada por su entidad territorial en el RUSICST al Primer Semestre de 2016.
--			El objetivo principal, es lograr que todas las observaciones y recomendaciones enunciadas en cada una de las secciones desarrolladas a lo largo de este informe sean entendidas y tenidas en cuenta, no sólo para fines del diligenciamiento de la herramienta para futuros reportes, sino como un insumo de valor agregado que permita mejorar tanto la gestión como la implementación de la Política Pública de Víctimas en su territorio, y particularmente evidenciar las buenas prácticas y lecciones aprendidas que deberán tener en cuenta las nuevas administraciones locales.
--			El documento a continuación se encuentra estructurado en cuatro capítulos: el primero muestra el nivel de diligenciamiento de la encuesta RUSICST para el periodo 2016-I por parte de su alcaldía. El segundo capítulo desarrolla el nivel de avance de su alcaldía en los procesos adelantados durante las tres etapas de política pública (Diseño, Implementación, Evaluación) tomando como línea base el segundo semestre del año 2013. En el tercer capítulo se realiza una retroalimentación general a la información consignada en el Plan de Mejoramiento, particularmente en las diferentes secciones donde tuvo que plantear y estructurar acciones que permitirán cumplir los objetivos postulados en cada una de las recomendaciones del plan. Igualmente se muestra el número de recomendaciones por sección del plan de mejoramiento, para identificar las secciones que requieren más trabajo para mejorar. El cuarto capítulo tiene comentarios y observaciones a los Documentos Adjuntos que su entidad territorial adjuntó en el reporte como evidencias. Por último, se presenta el Historial de Reporte de su municipio desde la entrada en vigencia del RUSICST, en el año 2012 hasta el primer semestre de 2016.', N'1. Nivel de Diligenciamiento', N'Este capítulo le muestra a su alcaldía el nivel de diligenciamiento o reporte RUSICST, teniendo en cuenta el número total de preguntas que diligenció para el periodo 2016-I. Complementariamente, se muestra si su nivel de diligenciamiento está por encima o debajo del promedio departamental y nacional. Esto con el propósito de que su alcaldía tenga un punto de referencia frente al reporte y gestión que se realiza de la política pública dentro de su Departamento y la nación. De este modo se incentiva a mejorar o mantener un nivel de reporte óptimo del RUSICST para el siguiente periodo.', N'1.1. Porcentaje de diligenciamiento', N'El gráfico a continuación muestra el porcentaje de diligenciamiento de RUSICST para el periodo 2016-I de su municipio. Ese resultado se compara contra el porcentaje de diligenciamiento del promedio departamental y nacional. Así puede saber si el nivel de diligenciamiento de su municipio estuvo por debajo, igual o encima respecto al promedio de su Departamento y nación.', NULL, N'2. Desarrollo de la politica pública de Atención', N'Este capítulo presenta un diagnóstico sobre el desarrollo en la gestión de la política pública de víctimas de su alcaldía para los primeros semestres de los años 2013 a 2016, de acuerdo con la información reportada en el RUSICST. El fin específico de este apartado, es que se tengan en cuenta el nivel de avance en cada fase de la política pública, con el fin de plantear las acciones pertinentes que le permitan seguir avanzando en la implementación de esta política, y que sirvan como insumo para las nuevas administraciones, frente a los aspectos críticos o débiles sobre los cuales deberán centrar su atención.

--Es importante señalar que, para el desarrollo de este capítulo, se revisaron 98 variables cuyo requisito técnico fue que todas estuvieran presentes en los tres periodos analizados para que la comparación de respuestas fuera válida.', N'2.1 Nivel de avance por fases', N'El gráfico a continuación muestra el nivel de avance para los primeros semestres de los años 2014, 2015 y 2016, en las tres fases de la política pública. Diseño, Implementación y Evaluación. Los resultados observados se comparan al interior de cada fase, entre los periodos mencionados. De este modo puede observar en qué periodo tuvo un mayor avance, por cada una de las tres fases de la política pública, de acuerdo a lo reportado en el RUSICST en los respectivos periodos. Para cada una de los periodos (2014-I, 2015-I y 2016-I) y fases de la política pública, se escogieron un determinado número de preguntas, con la característica que estas guardaran trazabilidad y/o continuidad entre sí a lo largo de la encuesta de RUSICST, con el fin de poder realizar comparaciones de resultados entre cada una de las fases de la política pública.

--De esta forma, al revisar el resultado en cada periodo, usted podrá identificar si avanzó, retrocedió o permaneció en el mismo nivel en los tres periodos analizados.', NULL, N'3. Analisis del Plan de Mejoramiento Municipal', N'En este capítulo encontrará el análisis de la información suministrada por su alcaldía en la sección de Plan de Mejoramiento en la plataforma RUSICST en el primer semestre de 2016.
--			Se sugiere que la administración municipal revise el Plan de Mejoramiento correspondiente a esta retroalimentación para su efectiva implementación. Para ello, debe dinamizarlo dentro del trabajo de los Comités y Subcomités de Justica Transicional. Lo anterior, en aras de que en el próximo proceso de reporte RUSISCT evidencie el fortalecimiento de la implementación de la política pública de víctimas.
--			Le recordamos que el Plan de Mejoramiento es una estrategia de evaluación y seguimiento a la política pública de víctimas mediante la cual su municipio puede identificar las debilidades institucionales que le impiden la gestión adecuada de la Política de Víctimas, de manera que pueda plantear acciones para superarlas y de esta manera avanzar en acciones conducentes que permitan superar la situación de vulnerabilidad y posteriormente ir alcanzando el goce efectivo de derechos de la población víctima del conflicto armado que habita en su territorio.', N'4. Revision de Archivos adjuntos', N'En el siguiente capítulo encontrará una revisión exhaustiva de siete documentos (*) solicitados en el RUSICST que soportan la información reportada por su municipio en el primer semestre del año 2016.
--			En dicha revisión se evalúa la existencia del documento adjunto y la pertinencia del mismo con relación a su forma y contenido.
--			Cuando se considera necesario, se realiza a su entidad territorial algunas recomendaciones u observaciones a los archivos cargados en la plataforma, que le permitirán avanzar en el proceso de documentación de los avances en la política pública de víctimas.', N'5. Historial de Envio Rusicts', N'En el siguiente capítulo encontrará el historial de reportes RUSICST que su municipio ha presentado desde el año 2012, teniendo en cuenta las diferentes etapas del proceso de diligenciamiento de la plataforma: (i) Guardar Información; (ii) Responder Preguntas Obligatorias, (iii) Diligenciar Plan de Mejoramiento y (iv) Enviar el Reporte.
--			La etapa de Guardar Información hace referencia al ingreso del municipio a la plataforma y cargue de información dentro del periodo habilitado para tal fin.
--			La etapa de Preguntas Obligatorias corresponde a cuando el municipio diligencia la totalidad de la información obligatoria, que además le permite acceder al módulo de Plan de Mejoramiento. Cuando una entidad territorial no completa la información mínima requerida, el sistema arroja una pantalla en color rojo con las preguntas que aún le falta por contestar y no le permite continuar con el proceso de envío del RUSICST hasta que no culmine el diligenciamiento y adjunte la carta de aval firmada por la autoridad legal de la entidad territorial.
--			Finalmente, la etapa correspondiente al Diligenciamiento del Plan de Mejoramiento muestra cuando el municipio ingresó acciones de mejora teniendo en cuenta las recomendaciones emitidas por la plataforma de acuerdo a las debilidades identificadas con la información reportada por la entidad territorial.', N'6. Observaciones Generales', N'Teniendo en cuenta los resultados arrojados por la plataforma durante el periodo 2012-2016, es importante que desde la administración municipal se analice la información de todos los periodos, con el fin de evaluar los resultados y desarrollar acciones de mejoramiento que permitan identificar los temas y fases de la política pública de víctimas en los que se deben hacer mayores esfuerzos.
--			Para ello el RUSICST será uno de los principales insumos para el cumplimiento de las obligaciones referentes al balance sobre la implementación de la política pública de victimas en su jurisdicción. Por lo tanto, le recomendamos revisar las metas y compromisos establecidos en su Plan de Acción Territorial para el actual periodo de gobierno y analizar cómo se complementa su implementación con el reporte semestral que se realiza en RUSICST.
--			También, es importante revisar y evaluar, en el marco de los subcomités o mesas temáticas creadas en su territorio, las acciones implementadas durante el cuatrienio de acuerdo a los componentes y medidas trabajadas en cada uno, con el objetivo de consolidar dicha información y realizar una sesión de evaluación y seguimiento del Comité Territorial de Justicia Transicional.
--			Finalmente le recomendamos presentar los resultados de esta evaluación a la población víctima, a través de un proceso de rendición de cuentas.')
--INSERT [dbo].[Retro.ConsultaEncuesta] ([Id], [IdEncuesta], [Presentacion], [PresTexto], [Nivel], [NivTexto], [Nivel2], [Niv2Texto], [NivIdGrafica], [Desarrollo], [DesTexto], [Desarrollo2], [Des2Texto], [DesIdGrafica], [Analisis], [AnaTexto], [Revision], [RevTexto], [Historial], [HisTexto], [Observa], [ObsTexto]) VALUES (3, 18, N'Presentación', N'El presente Informe de Retroalimentación contiene el análisis realizado por el Ministerio del Interior y la Unidad para las Víctimas, sobre la información reportada por su entidad territorial en el RUSICST al Primer Semestre de 2016.
--			El objetivo principal, es lograr que todas las observaciones y recomendaciones enunciadas en cada una de las secciones desarrolladas a lo largo de este informe sean entendidas y tenidas en cuenta, no sólo para fines del diligenciamiento de la herramienta para futuros reportes, sino como un insumo de valor agregado que permita mejorar tanto la gestión como la implementación de la Política Pública de Víctimas en su territorio, y particularmente evidenciar las buenas prácticas y lecciones aprendidas que deberán tener en cuenta las nuevas administraciones locales.
--			El documento a continuación se encuentra estructurado en cuatro capítulos: el primero muestra el nivel de diligenciamiento de la encuesta RUSICST para el periodo 2016-I por parte de su alcaldía. El segundo capítulo desarrolla el nivel de avance de su alcaldía en los procesos adelantados durante las tres etapas de política pública (Diseño, Implementación, Evaluación) tomando como línea base el segundo semestre del año 2013. En el tercer capítulo se realiza una retroalimentación general a la información consignada en el Plan de Mejoramiento, particularmente en las diferentes secciones donde tuvo que plantear y estructurar acciones que permitirán cumplir los objetivos postulados en cada una de las recomendaciones del plan. Igualmente se muestra el número de recomendaciones por sección del plan de mejoramiento, para identificar las secciones que requieren más trabajo para mejorar. El cuarto capítulo tiene comentarios y observaciones a los Documentos Adjuntos que su entidad territorial adjuntó en el reporte como evidencias. Por último, se presenta el Historial de Reporte de su municipio desde la entrada en vigencia del RUSICST, en el año 2012 hasta el primer semestre de 2016.', N'1. Nivel de Diligenciamiento', N'Este capítulo le muestra a su alcaldía el nivel de diligenciamiento o reporte RUSICST, teniendo en cuenta el número total de preguntas que diligenció para el periodo 2016-I. Complementariamente, se muestra si su nivel de diligenciamiento está por encima o debajo del promedio departamental y nacional. Esto con el propósito de que su alcaldía tenga un punto de referencia frente al reporte y gestión que se realiza de la política pública dentro de su Departamento y la nación. De este modo se incentiva a mejorar o mantener un nivel de reporte óptimo del RUSICST para el siguiente periodo.', N'1.1. Porcentaje de diligenciamiento', N'El gráfico a continuación muestra el porcentaje de diligenciamiento de RUSICST para el periodo 2016-I de su municipio. Ese resultado se compara contra el porcentaje de diligenciamiento del promedio departamental y nacional. Así puede saber si el nivel de diligenciamiento de su municipio estuvo por debajo, igual o encima respecto al promedio de su Departamento y nación.', NULL, N'2. Desarrollo de la politica pública de Atención', N'Este capítulo presenta un diagnóstico sobre el desarrollo en la gestión de la política pública de víctimas de su alcaldía para los primeros semestres de los años 2013 a 2016, de acuerdo con la información reportada en el RUSICST. El fin específico de este apartado, es que se tengan en cuenta el nivel de avance en cada fase de la política pública, con el fin de plantear las acciones pertinentes que le permitan seguir avanzando en la implementación de esta política, y que sirvan como insumo para las nuevas administraciones, frente a los aspectos críticos o débiles sobre los cuales deberán centrar su atención.

--Es importante señalar que, para el desarrollo de este capítulo, se revisaron 98 variables cuyo requisito técnico fue que todas estuvieran presentes en los tres periodos analizados para que la comparación de respuestas fuera válida.', N'2.1 Nivel de avance por fases', N'El gráfico a continuación muestra el nivel de avance para los primeros semestres de los años 2014, 2015 y 2016, en las tres fases de la política pública. Diseño, Implementación y Evaluación. Los resultados observados se comparan al interior de cada fase, entre los periodos mencionados. De este modo puede observar en qué periodo tuvo un mayor avance, por cada una de las tres fases de la política pública, de acuerdo a lo reportado en el RUSICST en los respectivos periodos. Para cada una de los periodos (2014-I, 2015-I y 2016-I) y fases de la política pública, se escogieron un determinado número de preguntas, con la característica que estas guardaran trazabilidad y/o continuidad entre sí a lo largo de la encuesta de RUSICST, con el fin de poder realizar comparaciones de resultados entre cada una de las fases de la política pública.

--De esta forma, al revisar el resultado en cada periodo, usted podrá identificar si avanzó, retrocedió o permaneció en el mismo nivel en los tres periodos analizados.', NULL, N'3. Analisis del Plan de Mejoramiento Municipal', N'En este capítulo encontrará el análisis de la información suministrada por su alcaldía en la sección de Plan de Mejoramiento en la plataforma RUSICST en el primer semestre de 2016.
--			Se sugiere que la administración municipal revise el Plan de Mejoramiento correspondiente a esta retroalimentación para su efectiva implementación. Para ello, debe dinamizarlo dentro del trabajo de los Comités y Subcomités de Justica Transicional. Lo anterior, en aras de que en el próximo proceso de reporte RUSISCT evidencie el fortalecimiento de la implementación de la política pública de víctimas.
--			Le recordamos que el Plan de Mejoramiento es una estrategia de evaluación y seguimiento a la política pública de víctimas mediante la cual su municipio puede identificar las debilidades institucionales que le impiden la gestión adecuada de la Política de Víctimas, de manera que pueda plantear acciones para superarlas y de esta manera avanzar en acciones conducentes que permitan superar la situación de vulnerabilidad y posteriormente ir alcanzando el goce efectivo de derechos de la población víctima del conflicto armado que habita en su territorio.', N'4. Revision de Archivos adjuntos', N'En el siguiente capítulo encontrará una revisión exhaustiva de siete documentos (*) solicitados en el RUSICST que soportan la información reportada por su municipio en el primer semestre del año 2016.
--			En dicha revisión se evalúa la existencia del documento adjunto y la pertinencia del mismo con relación a su forma y contenido.
--			Cuando se considera necesario, se realiza a su entidad territorial algunas recomendaciones u observaciones a los archivos cargados en la plataforma, que le permitirán avanzar en el proceso de documentación de los avances en la política pública de víctimas.', N'5. Historial de Envio Rusicts', N'En el siguiente capítulo encontrará el historial de reportes RUSICST que su municipio ha presentado desde el año 2012, teniendo en cuenta las diferentes etapas del proceso de diligenciamiento de la plataforma: (i) Guardar Información; (ii) Responder Preguntas Obligatorias, (iii) Diligenciar Plan de Mejoramiento y (iv) Enviar el Reporte.
--			La etapa de Guardar Información hace referencia al ingreso del municipio a la plataforma y cargue de información dentro del periodo habilitado para tal fin.
--			La etapa de Preguntas Obligatorias corresponde a cuando el municipio diligencia la totalidad de la información obligatoria, que además le permite acceder al módulo de Plan de Mejoramiento. Cuando una entidad territorial no completa la información mínima requerida, el sistema arroja una pantalla en color rojo con las preguntas que aún le falta por contestar y no le permite continuar con el proceso de envío del RUSICST hasta que no culmine el diligenciamiento y adjunte la carta de aval firmada por la autoridad legal de la entidad territorial.
--			Finalmente, la etapa correspondiente al Diligenciamiento del Plan de Mejoramiento muestra cuando el municipio ingresó acciones de mejora teniendo en cuenta las recomendaciones emitidas por la plataforma de acuerdo a las debilidades identificadas con la información reportada por la entidad territorial.', N'6. Observaciones Generales', N'Teniendo en cuenta los resultados arrojados por la plataforma durante el periodo 2012-2016, es importante que desde la administración municipal se analice la información de todos los periodos, con el fin de evaluar los resultados y desarrollar acciones de mejoramiento que permitan identificar los temas y fases de la política pública de víctimas en los que se deben hacer mayores esfuerzos.
--			Para ello el RUSICST será uno de los principales insumos para el cumplimiento de las obligaciones referentes al balance sobre la implementación de la política pública de victimas en su jurisdicción. Por lo tanto, le recomendamos revisar las metas y compromisos establecidos en su Plan de Acción Territorial para el actual periodo de gobierno y analizar cómo se complementa su implementación con el reporte semestral que se realiza en RUSICST.
--			También, es importante revisar y evaluar, en el marco de los subcomités o mesas temáticas creadas en su territorio, las acciones implementadas durante el cuatrienio de acuerdo a los componentes y medidas trabajadas en cada uno, con el objetivo de consolidar dicha información y realizar una sesión de evaluación y seguimiento del Comité Territorial de Justicia Transicional.
--			Finalmente le recomendamos presentar los resultados de esta evaluación a la población víctima, a través de un proceso de rendición de cuentas.')

--INSERT [dbo].[Retro.ConsultaEncuesta] ([Id], [IdEncuesta], [Presentacion], [PresTexto], [Nivel], [NivTexto], [Nivel2], [Niv2Texto], [NivIdGrafica], [Desarrollo], [DesTexto], [Desarrollo2], [Des2Texto], [DesIdGrafica], [Analisis], [AnaTexto], [Revision], [RevTexto], [Historial], [HisTexto], [Observa], [ObsTexto]) VALUES (4, 20, N'Presentación', N'El presente Informe de Retroalimentación contiene el análisis realizado por el Ministerio del Interior y la Unidad para las Víctimas, sobre la información reportada por su entidad territorial en el RUSICST al Primer Semestre de 2016.
--			El objetivo principal, es lograr que todas las observaciones y recomendaciones enunciadas en cada una de las secciones desarrolladas a lo largo de este informe sean entendidas y tenidas en cuenta, no sólo para fines del diligenciamiento de la herramienta para futuros reportes, sino como un insumo de valor agregado que permita mejorar tanto la gestión como la implementación de la Política Pública de Víctimas en su territorio, y particularmente evidenciar las buenas prácticas y lecciones aprendidas que deberán tener en cuenta las nuevas administraciones locales.
--			El documento a continuación se encuentra estructurado en cuatro capítulos: el primero muestra el nivel de diligenciamiento de la encuesta RUSICST para el periodo 2016-I por parte de su alcaldía. El segundo capítulo desarrolla el nivel de avance de su alcaldía en los procesos adelantados durante las tres etapas de política pública (Diseño, Implementación, Evaluación) tomando como línea base el segundo semestre del año 2013. En el tercer capítulo se realiza una retroalimentación general a la información consignada en el Plan de Mejoramiento, particularmente en las diferentes secciones donde tuvo que plantear y estructurar acciones que permitirán cumplir los objetivos postulados en cada una de las recomendaciones del plan. Igualmente se muestra el número de recomendaciones por sección del plan de mejoramiento, para identificar las secciones que requieren más trabajo para mejorar. El cuarto capítulo tiene comentarios y observaciones a los Documentos Adjuntos que su entidad territorial adjuntó en el reporte como evidencias. Por último, se presenta el Historial de Reporte de su municipio desde la entrada en vigencia del RUSICST, en el año 2012 hasta el primer semestre de 2016.', N'1. Nivel de Diligenciamiento', N'Este capítulo le muestra a su alcaldía el nivel de diligenciamiento o reporte RUSICST, teniendo en cuenta el número total de preguntas que diligenció para el periodo 2016-I. Complementariamente, se muestra si su nivel de diligenciamiento está por encima o debajo del promedio departamental y nacional. Esto con el propósito de que su alcaldía tenga un punto de referencia frente al reporte y gestión que se realiza de la política pública dentro de su Departamento y la nación. De este modo se incentiva a mejorar o mantener un nivel de reporte óptimo del RUSICST para el siguiente periodo.', N'1.1. Porcentaje de diligenciamiento', N'El gráfico a continuación muestra el porcentaje de diligenciamiento de RUSICST para el periodo 2016-I de su municipio. Ese resultado se compara contra el porcentaje de diligenciamiento del promedio departamental y nacional. Así puede saber si el nivel de diligenciamiento de su municipio estuvo por debajo, igual o encima respecto al promedio de su Departamento y nación.', NULL, N'2. Desarrollo de la politica pública de Atención', N'Este capítulo presenta un diagnóstico sobre el desarrollo en la gestión de la política pública de víctimas de su alcaldía para los primeros semestres de los años 2013 a 2016, de acuerdo con la información reportada en el RUSICST. El fin específico de este apartado, es que se tengan en cuenta el nivel de avance en cada fase de la política pública, con el fin de plantear las acciones pertinentes que le permitan seguir avanzando en la implementación de esta política, y que sirvan como insumo para las nuevas administraciones, frente a los aspectos críticos o débiles sobre los cuales deberán centrar su atención.

--Es importante señalar que, para el desarrollo de este capítulo, se revisaron 98 variables cuyo requisito técnico fue que todas estuvieran presentes en los tres periodos analizados para que la comparación de respuestas fuera válida.', N'2.1 Nivel de avance por fases', N'El gráfico a continuación muestra el nivel de avance para los primeros semestres de los años 2014, 2015 y 2016, en las tres fases de la política pública. Diseño, Implementación y Evaluación. Los resultados observados se comparan al interior de cada fase, entre los periodos mencionados. De este modo puede observar en qué periodo tuvo un mayor avance, por cada una de las tres fases de la política pública, de acuerdo a lo reportado en el RUSICST en los respectivos periodos. Para cada una de los periodos (2014-I, 2015-I y 2016-I) y fases de la política pública, se escogieron un determinado número de preguntas, con la característica que estas guardaran trazabilidad y/o continuidad entre sí a lo largo de la encuesta de RUSICST, con el fin de poder realizar comparaciones de resultados entre cada una de las fases de la política pública.

--De esta forma, al revisar el resultado en cada periodo, usted podrá identificar si avanzó, retrocedió o permaneció en el mismo nivel en los tres periodos analizados.', NULL, N'3. Analisis del Plan de Mejoramiento Municipal', N'En este capítulo encontrará el análisis de la información suministrada por su alcaldía en la sección de Plan de Mejoramiento en la plataforma RUSICST en el primer semestre de 2016.
--			Se sugiere que la administración municipal revise el Plan de Mejoramiento correspondiente a esta retroalimentación para su efectiva implementación. Para ello, debe dinamizarlo dentro del trabajo de los Comités y Subcomités de Justica Transicional. Lo anterior, en aras de que en el próximo proceso de reporte RUSISCT evidencie el fortalecimiento de la implementación de la política pública de víctimas.
--			Le recordamos que el Plan de Mejoramiento es una estrategia de evaluación y seguimiento a la política pública de víctimas mediante la cual su municipio puede identificar las debilidades institucionales que le impiden la gestión adecuada de la Política de Víctimas, de manera que pueda plantear acciones para superarlas y de esta manera avanzar en acciones conducentes que permitan superar la situación de vulnerabilidad y posteriormente ir alcanzando el goce efectivo de derechos de la población víctima del conflicto armado que habita en su territorio.', N'4. Revision de Archivos adjuntos', N'En el siguiente capítulo encontrará una revisión exhaustiva de siete documentos (*) solicitados en el RUSICST que soportan la información reportada por su municipio en el primer semestre del año 2016.
--			En dicha revisión se evalúa la existencia del documento adjunto y la pertinencia del mismo con relación a su forma y contenido.
--			Cuando se considera necesario, se realiza a su entidad territorial algunas recomendaciones u observaciones a los archivos cargados en la plataforma, que le permitirán avanzar en el proceso de documentación de los avances en la política pública de víctimas.', N'5. Historial de Envio Rusicts', N'En el siguiente capítulo encontrará el historial de reportes RUSICST que su municipio ha presentado desde el año 2012, teniendo en cuenta las diferentes etapas del proceso de diligenciamiento de la plataforma: (i) Guardar Información; (ii) Responder Preguntas Obligatorias, (iii) Diligenciar Plan de Mejoramiento y (iv) Enviar el Reporte.
--			La etapa de Guardar Información hace referencia al ingreso del municipio a la plataforma y cargue de información dentro del periodo habilitado para tal fin.
--			La etapa de Preguntas Obligatorias corresponde a cuando el municipio diligencia la totalidad de la información obligatoria, que además le permite acceder al módulo de Plan de Mejoramiento. Cuando una entidad territorial no completa la información mínima requerida, el sistema arroja una pantalla en color rojo con las preguntas que aún le falta por contestar y no le permite continuar con el proceso de envío del RUSICST hasta que no culmine el diligenciamiento y adjunte la carta de aval firmada por la autoridad legal de la entidad territorial.
--			Finalmente, la etapa correspondiente al Diligenciamiento del Plan de Mejoramiento muestra cuando el municipio ingresó acciones de mejora teniendo en cuenta las recomendaciones emitidas por la plataforma de acuerdo a las debilidades identificadas con la información reportada por la entidad territorial.', N'6. Observaciones Generales', N'Teniendo en cuenta los resultados arrojados por la plataforma durante el periodo 2012-2016, es importante que desde la administración municipal se analice la información de todos los periodos, con el fin de evaluar los resultados y desarrollar acciones de mejoramiento que permitan identificar los temas y fases de la política pública de víctimas en los que se deben hacer mayores esfuerzos.
--			Para ello el RUSICST será uno de los principales insumos para el cumplimiento de las obligaciones referentes al balance sobre la implementación de la política pública de victimas en su jurisdicción. Por lo tanto, le recomendamos revisar las metas y compromisos establecidos en su Plan de Acción Territorial para el actual periodo de gobierno y analizar cómo se complementa su implementación con el reporte semestral que se realiza en RUSICST.
--			También, es importante revisar y evaluar, en el marco de los subcomités o mesas temáticas creadas en su territorio, las acciones implementadas durante el cuatrienio de acuerdo a los componentes y medidas trabajadas en cada uno, con el objetivo de consolidar dicha información y realizar una sesión de evaluación y seguimiento del Comité Territorial de Justicia Transicional.
--			Finalmente le recomendamos presentar los resultados de esta evaluación a la población víctima, a través de un proceso de rendición de cuentas.')

--GO
--SET IDENTITY_INSERT [dbo].[Retro.ConsultaEncuesta] OFF
--GO
