drop table RetroGraficaDesarrollo
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroGraficaDesarrollo]')) 
BEGIN
	-- =============================================
	-- Author:		Equipo de desarrollo OIM - John Betancourt
	-- Create date: 1/08/2017
	-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
	-- =============================================
	CREATE TABLE [RetroGraficaDesarrollo](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[IdRetroAdmin] [int] NOT NULL,
		[ColorDis] [varchar](50) NOT NULL,
		[ColorImp] [varchar](50) NOT NULL,
		[ColorEval] [varchar](50) NOT NULL,
		[NombreSerie1] [varchar](50) NOT NULL,
		[NombreSerie2] [varchar](50) NOT NULL,
		[NombreSerie3] [varchar](50) NOT NULL,
		[NombreSerie4] [varchar](50) NOT NULL,
		[NombreSerie5] [varchar](50) NOT NULL,
		[NombreSerie6] [varchar](50) NOT NULL,
		[NombreSerie7] [varchar](50) NOT NULL,
		[NombreSerie8] [varchar](50) NOT NULL,
		[NombreSerie9] [varchar](50) NOT NULL,
		[NombreGrafica] [varchar](50) NOT NULL
	 CONSTRAINT [PK_RetroGraficaDesarrollo] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_RetroHistorialTodosInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_RetroHistorialTodosInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 18/09/2017
-- Description:	obtiene la informacion Retroalimentacion de la grafica Nivel x encuesta
-- =============================================
ALTER PROCEDURE [I_RetroHistorialTodosInsert] 
	@Encuesta			INT, --30
	@IdPregunta			VARCHAR(8), --10007189
	@Nombre				VARCHAR(8)

AS

DECLARE @respuesta AS NVARCHAR(2000) = ''    
DECLARE @estadoRespuesta  AS INT = 0   


IF EXISTS (select 1 from RetroHistorialRusicst where IdEncuesta = @Encuesta) 
BEGIN
	SELECT @respuesta = 'Ya existe un historial para esta encuesta'    
	SELECT @estadoRespuesta = 0 
END
ELSE
BEGIN
	DECLARE @Envio TABLE (UserName VARCHAR(50), ENVIO varchar(2) )
	DECLARE @Diligencio TABLE (UserName VARCHAR(50), Diligencio varchar(2) )
	DECLARE @Completo TABLE (UserName VARCHAR(50), Completo varchar(2) )
	DECLARE @Guardo TABLE (UserName VARCHAR(50), Guardo varchar(2) )
	DECLARE @Carta TABLE (UserName VARCHAR(50), Carta varchar(2) )


	DECLARE @TipoEncuesta varchar(20)
	select @TipoEncuesta = Nombre from TipoEncuesta where Id = (select IdTipoEncuesta from Encuesta where id=@Encuesta)

	--ENVIO -- C_ConsultaRetroUsariosEnviaronReporte
	if (@Encuesta<58)
	BEGIN
	INSERT INTO @Envio 
	SELECT Username, [ENVIO] from(
	SELECT usuario.Username, 1 AS [ENVIO]
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  )
					AND (dbo.Usuario.Id IN (SELECT DISTINCT IdUsuario
												  FROM dbo.Envio
												  WHERE (IdEncuesta = @Encuesta)))
	UNION ALL
	SELECT usuario.Username, 0 AS ENVIO
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  )
					AND (dbo.Usuario.Id not IN (SELECT DISTINCT IdUsuario
												  FROM dbo.Envio
												  WHERE (IdEncuesta = @Encuesta)) )                                            
	) as env1                                              
	END
	else
	begin
	INSERT INTO @Envio 
	SELECT Username, [ENVIO] from(
	SELECT usuario.Username, 1 AS [ENVIO]
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  ) 
					AND (dbo.Usuario.Username IN (SELECT DISTINCT PlanesMejoramiento.FinalizacionPlan.Usuario
	FROM         PlanesMejoramiento.FinalizacionPlan INNER JOIN
						  PlanesMejoramiento.PlanMejoramiento ON PlanesMejoramiento.FinalizacionPlan.IdPlanMejoramiento = PlanesMejoramiento.PlanMejoramiento.IdPlanMejoramiento INNER JOIN
						  PlanesMejoramiento.PlanMejoramientoEncuesta ON 
						  PlanesMejoramiento.PlanMejoramiento.IdPlanMejoramiento = PlanesMejoramiento.PlanMejoramientoEncuesta.IdPlanMejoriamiento INNER JOIN
						  dbo.Encuesta ON PlanesMejoramiento.PlanMejoramientoEncuesta.IdEncuesta = dbo.Encuesta.Id AND 
						  PlanesMejoramiento.PlanMejoramientoEncuesta.IdEncuesta = dbo.Encuesta.Id
	WHERE     (dbo.Encuesta.Id = @Encuesta))) 

	UNION ALL

	SELECT usuario.Username,0 AS ENVIO
	FROM   dbo.Usuario LEFT OUTER JOIN
		   dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
		   dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  )
			  
				  AND (dbo.Usuario.Username  NOT IN (SELECT DISTINCT PlanesMejoramiento.FinalizacionPlan.Usuario
	FROM         PlanesMejoramiento.FinalizacionPlan INNER JOIN
						  PlanesMejoramiento.PlanMejoramiento ON PlanesMejoramiento.FinalizacionPlan.IdPlanMejoramiento = PlanesMejoramiento.PlanMejoramiento.IdPlanMejoramiento INNER JOIN
						  PlanesMejoramiento.PlanMejoramientoEncuesta ON 
						  PlanesMejoramiento.PlanMejoramiento.IdPlanMejoramiento = PlanesMejoramiento.PlanMejoramientoEncuesta.IdPlanMejoriamiento INNER JOIN
						  dbo.Encuesta ON PlanesMejoramiento.PlanMejoramientoEncuesta.IdEncuesta = dbo.Encuesta.Id AND 
						  PlanesMejoramiento.PlanMejoramientoEncuesta.IdEncuesta = dbo.Encuesta.Id
	WHERE     (dbo.Encuesta.Id = @Encuesta))) 
	) env

	end

	--DILIGENCIO  --C_ConsultaRetroUsariosGuardaronInformacionAutoevaluacion
	if @Encuesta<58
	BEGIN
	INSERT INTO @Diligencio
	SELECT Username, [INFORMACION EN AUTOEVALUACION] from(
	SELECT    usuario.Username , 1 AS [INFORMACION EN AUTOEVALUACION]
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11)) 
									  AND (dbo.Usuario.Id 
										  IN (SELECT DISTINCT IdUsuario 
											  FROM dbo.Autoevaluacion2 
											   WHERE (IdEncuesta = @Encuesta)
														AND Recomendacion IS NOT NULL 
														AND LEN(Acciones)>0))
	UNION ALL
	SELECT    usuario.Username, 0 AS  [INFORMACION EN AUTOEVALUACION]
	FROM         dbo.Usuario LEFT OUTER JOIN
						  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
						  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) ) 
									  AND (dbo.Usuario.Id NOT IN (SELECT DISTINCT IdUsuario 
																		 FROM dbo.Autoevaluacion2 
																		 WHERE (IdEncuesta = @Encuesta)
													   AND Recomendacion IS NOT NULL 
													   AND LEN(Acciones)>0))
	) dil1
	END
	else
	begin
	INSERT INTO @Diligencio
	SELECT Username, [INFORMACION EN AUTOEVALUACION] from(
	SELECT    usuario.Username, 1 AS [INFORMACION EN AUTOEVALUACION]
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11))
									  AND (dbo.Usuario.Username 
									  IN (SELECT DISTINCT PlanesMejoramiento.AccionesPlan.Usuario
	FROM         PlanesMejoramiento.AccionesPlan INNER JOIN
						  PlanesMejoramiento.Recomendacion ON PlanesMejoramiento.AccionesPlan.IdRecomendacion = PlanesMejoramiento.Recomendacion.IdRecomendacion INNER JOIN
						  dbo.Pregunta ON PlanesMejoramiento.Recomendacion.IdPregunta = dbo.Pregunta.Id INNER JOIN
						  dbo.Seccion ON dbo.Pregunta.IdSeccion = dbo.Seccion.Id AND dbo.Pregunta.IdSeccion = dbo.Seccion.Id
	WHERE     (dbo.Seccion.IdEncuesta = @Encuesta) AND (PlanesMejoramiento.AccionesPlan.Accion IS NOT NULL)))
	UNION ALL
	SELECT    usuario.Username, 0 AS  [INFORMACION EN AUTOEVALUACION]
	FROM      dbo.Usuario LEFT OUTER JOIN
						  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
						  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select substring(@TipoEncuesta,6,11))
									  AND (dbo.Usuario.Username  NOT IN (SELECT DISTINCT PlanesMejoramiento.AccionesPlan.Usuario
	FROM         PlanesMejoramiento.AccionesPlan INNER JOIN
						  PlanesMejoramiento.Recomendacion ON PlanesMejoramiento.AccionesPlan.IdRecomendacion = PlanesMejoramiento.Recomendacion.IdRecomendacion INNER JOIN
						  dbo.Pregunta ON PlanesMejoramiento.Recomendacion.IdPregunta = dbo.Pregunta.Id INNER JOIN
						  dbo.Seccion ON dbo.Pregunta.IdSeccion = dbo.Seccion.Id AND dbo.Pregunta.IdSeccion = dbo.Seccion.Id
	WHERE     (dbo.Seccion.IdEncuesta = @Encuesta) AND (PlanesMejoramiento.AccionesPlan.Accion IS NOT NULL)))
	)dil2
	END
	---COMPLETO --C_ConsultaRetroUsuariosPasaronAutoevaluación
	BEGIN
	INSERT INTO @Completo
	SELECT Username, [PASO A AUTOEVALUACION] from(
	SELECT usuario.Username,1 AS [PASO A AUTOEVALUACION]
	FROM dbo.Usuario LEFT OUTER JOIN
	dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
	dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
	dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id

	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  )
	AND (dbo.Usuario.Id IN 
	(select a.IdUsuario from 
	(SELECT   IdUsuario
	FROM Respuesta 
	WHERE IdPregunta IN ((SELECT dbo.Pregunta.Id
	FROM dbo.Seccion INNER JOIN dbo.Pregunta ON dbo.Seccion.Id = dbo.Pregunta.IdSeccion
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta) 
	AND (dbo.Pregunta.EsObligatoria = 1)) )and valor!='-' 
	GROUP BY convert(char,IdUsuario)+'_'+convert(char,IdPregunta), IdUsuario) a
	GROUP BY  IdUsuario
	having (SELECT COUNT (*)
	FROM dbo.Seccion INNER JOIN dbo.Pregunta ON dbo.Seccion.Id = dbo.Pregunta.IdSeccion
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta) 
	AND (dbo.Pregunta.EsObligatoria = 1)) - COUNT(*)<1))

	UNION ALL

	SELECT usuario.Username, 0 AS [PASO A AUTOEVALUACION]
	FROM dbo.Usuario LEFT OUTER JOIN
	dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
	dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
	dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  )
	AND (dbo.Usuario.Id not IN
	(select a.IdUsuario from 
	(SELECT   IdUsuario
	FROM Respuesta 
	WHERE IdPregunta IN ((SELECT dbo.Pregunta.Id
	FROM dbo.Seccion INNER JOIN dbo.Pregunta ON dbo.Seccion.Id = dbo.Pregunta.IdSeccion
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta) 
	AND (dbo.Pregunta.EsObligatoria = 1)) )and valor!='-' 
	GROUP BY convert(char,IdUsuario)+'_'+convert(char,IdPregunta), IdUsuario) a
	GROUP BY  IdUsuario
	having (SELECT COUNT (*)
	FROM dbo.Seccion INNER JOIN dbo.Pregunta ON dbo.Seccion.Id = dbo.Pregunta.IdSeccion
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta) 
	AND (dbo.Pregunta.EsObligatoria = 1)) - COUNT(*)<1))
	) comp
	END

	--GUARDO --C_ConsultaRetroUsuariosGuardaronInformacionSistema
	INSERT INTO @Guardo
	SELECT Username, [GUARDO] from(
	SELECT usuario.Username, 1 AS [GUARDO]
	FROM dbo.Usuario LEFT OUTER JOIN
		dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
		dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
		dbo.TipoUsuario TU ON Usuario.IdTipoUsuario = TU.Id
		WHERE TU.Tipo IN (SELECT substring(@TipoEncuesta,6,11) as tipo)	
		AND dbo.Usuario.Id   IN
	(SELECT DISTINCT dbo.Respuesta.IdUsuario
		FROM dbo.Respuesta INNER JOIN
			dbo.Pregunta ON dbo.Respuesta.IdPregunta = dbo.Pregunta.Id INNER JOIN
			dbo.Seccion ON dbo.Pregunta.IdSeccion = dbo.Seccion.Id INNER JOIN
			dbo.Usuario ON dbo.Respuesta.IdUsuario = dbo.Usuario.Id
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta)) 
	UNION ALL
	SELECT usuario.Username, 0 AS [GUARDO]
	FROM dbo.Usuario LEFT OUTER JOIN
		dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
		dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
		dbo.TipoUsuario TU ON Usuario.IdTipoUsuario = TU.Id
		WHERE TU.Tipo IN (SELECT substring(@TipoEncuesta,6,11) as tipo)
		AND dbo.Usuario.Id   NOT IN
	(SELECT DISTINCT dbo.Respuesta.IdUsuario
		FROM dbo.Respuesta INNER JOIN
			dbo.Pregunta ON dbo.Respuesta.IdPregunta = dbo.Pregunta.Id INNER JOIN
			dbo.Seccion ON dbo.Pregunta.IdSeccion = dbo.Seccion.Id INNER JOIN
			dbo.Usuario ON dbo.Respuesta.IdUsuario = dbo.Usuario.Id 
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta)) 
	) gua

	--CARTA AVAL
	INSERT INTO @Carta
	SELECT Username, CartaAval from(
	SELECT U.UserName,
		 r.Valor
		  ,CAST(CASE r.Valor
			WHEN ISNULL(r.Valor,0) THEN 1
			ELSE 0 END as bit) CartaAval
	  FROM [BancoPreguntas].[Preguntas] P
	  INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
	  INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
	  INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
	  INNER JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @Encuesta
	  LEFT JOIN Respuesta r ON PO.Id = r.IdPregunta --AND r.IdUsuario = @IdUser
	  INNER JOIN Usuario U ON r.IdUsuario = U.Id
	  WHERE CodigoPregunta = @IdPregunta
	  ) car


	INSERT INTO [dbo].[RetroHistorialRusicst]
	SELECT	E.UserName AS Usuario, @Nombre AS Periodo, 
			convert(Bit, G.Guardo) AS Guardo, convert(Bit, C.Completo) AS Completo, convert(Bit, D.Diligencio) AS Diligencio, 
			convert(Bit, E.ENVIO) AS Adjunto, convert(Bit, ISNULL(CA.Carta,0)) AS Envio , @IdPregunta AS CodigoPregunta, 
			@Encuesta IdEncuesta, @Nombre Nombre
	FROM @Diligencio D 
	INNER JOIN @Envio E on D.UserName = E.UserName
	INNER JOIN @Completo C on D.UserName = C.UserName
	INNER JOIN @Guardo G on D.UserName = G.UserName
	LEFT  JOIN @Carta CA on D.UserName = CA.UserName
	ORDER BY E.UserName

	SELECT @respuesta = 'Historial creado con exito'    
	SELECT @estadoRespuesta = 1

END

SELECT @respuesta AS respuesta, @estadoRespuesta AS estado       
--I_RetroHistorialTodosInsert 30, '10007189', 'Gokusin' 

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_RetroDesPreguntaXIdDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_RetroDesPreguntaXIdDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Equipo de desarrollo OIM - John Betancourt A.  
-- Create date: 25/08/2017  
-- Description: elimina una pregunat desarrollo x codigo pregunta  
-- =============================================  
ALTER PROC [dbo].[D_RetroDesPreguntaXIdDelete]   
 @IdPregunta INT  
AS  
  
 -- Parámetros para el manejo de la respuesta    
 DECLARE @respuesta AS NVARCHAR(2000) = ''    
 DECLARE @estadoRespuesta  AS INT = 0    
 BEGIN    
  BEGIN TRANSACTION    
  BEGIN TRY   
  
 DELETE FROM [dbo].[RetroDesPreguntasXEncuestas]  
    WHERE Id = @IdPregunta  
 SELECT @respuesta = 'Se ha Eliminado el registro'    
 SELECT @estadoRespuesta = 3  
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroGraficaDesarrollo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroGraficaDesarrollo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 15/08/2017
-- Description:	obtiene los datos de la grafica de desarrollo
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroGraficaDesarrollo] 

	@IdRetroAdmin 				INT
AS

SELECT [Id]
      ,[IdRetroAdmin]
      ,[ColorDis]
      ,[ColorImp]
      ,[ColorEval]
      ,[NombreSerie1]
      ,[NombreSerie2]
      ,[NombreSerie3]
      ,[NombreSerie4]
      ,[NombreSerie5]
      ,[NombreSerie6]
      ,[NombreSerie7]
      ,[NombreSerie8]
      ,[NombreSerie9]
	  ,[NombreGrafica]
  FROM [dbo].[RetroGraficaDesarrollo]
  WHERE [IdRetroAdmin] = @IdRetroAdmin
GO
--[C_ConsultaRetroGraficaDesarrollo] 2

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_EncuestaRetroGrafDesarrolloUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_EncuestaRetroGrafDesarrolloUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================  
-- Autor: Equipo de desarrollo OIM - John Betancourt A. 
-- Fecha creacion: 2017-08-15
-- Descripcion: Actualiza un registro en la realiemntacion                     
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado            
-- Estado int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado            
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'      
--====================================================================================================  
ALTER PROC [dbo].[U_EncuestaRetroGrafDesarrolloUpdate]   
	
	@IdRetroAdmin int,
	@ColorDis varchar(50),
    @ColorImp varchar(50),
	@ColorEval varchar(50),
    @NombreSerie1 varchar(50),
	@NombreSerie2 varchar(50),
	@NombreSerie3 varchar(50),
	@NombreSerie4 varchar(50),
	@NombreSerie5 varchar(50),
	@NombreSerie6 varchar(50),
	@NombreSerie7 varchar(50),
	@NombreSerie8 varchar(50),
	@NombreSerie9 varchar(50),
	@NombreGrafica varchar(50)

AS   
  
 -- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0  
 BEGIN  
  BEGIN TRANSACTION  
  BEGIN TRY  

 
 IF EXISTS (select 1 from RetroGraficaDesarrollo where IdRetroAdmin = @IdRetroAdmin)  
	BEGIN
		UPDATE   
		[dbo].[RetroGraficaDesarrollo]  
		SET      
			ColorDis = @ColorDis,
			ColorImp = @ColorImp,
			ColorEval = @ColorEval,
			NombreSerie1 = @NombreSerie1,
			NombreSerie2 = @NombreSerie2,
			NombreSerie3 = @NombreSerie3,
			NombreSerie4 = @NombreSerie4,
			NombreSerie5 = @NombreSerie5,
			NombreSerie6 = @NombreSerie6,
			NombreSerie7 = @NombreSerie7,
			NombreSerie8 = @NombreSerie8,
			NombreSerie9 = @NombreSerie9,
			NombreGrafica = @NombreGrafica
		WHERE    
		IdRetroAdmin = @IdRetroAdmin

		SELECT @respuesta = 'Se ha actualizado el registro'  
		SELECT @estadoRespuesta = 2 
	END 
ELSE 
	BEGIN
		INSERT INTO [dbo].[RetroGraficaDesarrollo]
           (IdRetroAdmin, ColorDis, ColorImp, ColorEval, NombreSerie1, NombreSerie2, NombreSerie3,
			NombreSerie4, NombreSerie5, NombreSerie6, NombreSerie7, NombreSerie8, NombreSerie9, NombreGrafica)
		   VALUES
		   (@IdRetroAdmin, @ColorDis, @ColorImp, @ColorEval, @NombreSerie1, @NombreSerie2, @NombreSerie3,
			@NombreSerie4, @NombreSerie5, @NombreSerie6, @NombreSerie7, @NombreSerie8, @NombreSerie9, @NombreGrafica)

			SELECT @respuesta = 'Se ha Ingresado el registro'  
			SELECT @estadoRespuesta = 1
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroGraficaNivel]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroGraficaNivel] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 15/08/2017
-- Description:		obtiene los datos de la grafica de Nivel
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroGraficaNivel] 

	@IdRetroAdmin 				INT
AS

SELECT [Id]
      ,[IdRetroAdmin]
      ,[TipoGrafica]
      ,[Color1serie]
      ,[Color2serie]
      ,[Color3serie]
      ,[TituloGraf]
      ,[NombreEje1]
      ,[NombreEje2]
      ,[NombreSerie1]
      ,[NombreSerie2]
      ,[NombreSerie3]
  FROM [dbo].[RetroGraficaNivel]
  WHERE [IdRetroAdmin] = @IdRetroAdmin

GO

--C_ConsultaRetroGraficaNivel 2


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_RetroArcPreguntasDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_RetroArcPreguntasDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Equipo de desarrollo OIM - John Betancourt A.  
-- Create date: 25/08/2017  
-- Description: elimina una realimentacion  
-- =============================================  
ALTER PROC [dbo].[D_RetroArcPreguntasDelete]   
	@IdRetroArc		INT
AS  
  
 -- Parámetros para el manejo de la respuesta    
 DECLARE	@respuesta AS NVARCHAR(2000) = '',
			@estadoRespuesta  AS INT = 0 ,   
			@IdPregunta AS VARCHAR(8)
 BEGIN    
  BEGIN TRANSACTION    
  BEGIN TRY   
 
 SELECT @IdPregunta = CodigoPregunta FROM [dbo].[RetroArcPreguntasXEncuesta] WHERE Id = @IdRetroArc 
 
 DELETE FROM [dbo].[RetroArcPreguntasXEncuesta]  
    WHERE Id = @IdRetroArc 
DELETE FROM [dbo].[RetroArcPreguntasXEncuestaXmunicipio]  
    WHERE CodigoPregunta = @IdPregunta 

 SELECT @respuesta = 'Se ha Eliminado el registro'    
 SELECT @estadoRespuesta = 3  
COMMIT  TRANSACTION    
  END TRY    
  BEGIN CATCH    
   ROLLBACK TRANSACTION    
   SELECT @respuesta = ERROR_MESSAGE()    
   SELECT @estadoRespuesta = 0    
  END CATCH    
 END  
  
 SELECT @respuesta AS respuesta, @estadoRespuesta AS estado       
 