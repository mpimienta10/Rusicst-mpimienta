GO

/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ListadoUsuariosActivosPlan]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-25																		 
-- Descripcion: Consulta la informacion de los Usuarios Activos en el Sistema para asignar un Plan de Mejoramiento
-- ***************************************************************************************************
CREATE PROCEDURE [PlanesMejoramiento].[C_ListadoUsuariosActivosPlan] 

AS
BEGIN

	SELECT 
		a.Username,
		a.Nombres,
		d.Nombre as TipoUsuario,
		ISNULL(b.Nombre, '') Departamento,
		ISNULL(c.Nombre, '') Municipio
	FROM Usuario a
	INNER JOIN [dbo].[TipoUsuario] d on d.Id = a.IdTipoUsuario
	LEFT OUTER JOIN Departamento b ON a.IdDepartamento = b.Id
	LEFT OUTER JOIN Municipio c ON a.IdMunicipio = c.Id
	WHERE
	a.Activo = 1
	
END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerCantidadRecomendacionesObjetivo]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-10-24																			
-- Descripcion: Consulta La cantidad de recomendaciones que tiene un objetivo especifico indicado
-- ***************************************************************************************************
CREATE PROC [PlanesMejoramiento].[C_ObtenerCantidadRecomendacionesObjetivo]
(
	@IdObjetivo INT
)

AS

BEGIN

	SELECT 
		ISNULL(COUNT(A.IdRecomendacion), 0)
	FROM 
		[PlanesMejoramiento].[Recomendacion] A
	WHERE
		A.[IdObjetivoEspecifico] = @IdObjetivo

END

GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerColorSemaforo]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23																			 
-- Descripcion: Consulta la informacion de las Encuestas asignadas a un Plan de Mejoramiento
-- ***************************************************************************************************
CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerColorSemaforo]
(
	@Porcentaje INT
)
AS
BEGIN

	DECLARE @ColorResultado VARCHAR(50) 
	
	SELECT @ColorResultado = Color
	FROM PlanesMejoramiento.Semaforo
	WHERE RangoInicial <= @Porcentaje AND RangoFinal >= @Porcentaje
	
	SELECT ISNULL(@ColorResultado, 'Sin Color') as Color
	
END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerIdEncuestaByTitulo]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23																			 
-- Descripcion: Consulta la informacion del Id de una Encuesta por su Titulo
-- ***************************************************************************************************
CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerIdEncuestaByTitulo] --'ACTUIZACION INFORMACION RUSICST 2012 FECHA LIMITE DE ENVIO 5 DE ABRIL DE 2013'
(
	@NombreEncuesta varchar(500)
)

AS 

BEGIN
		
	IF EXISTS (SELECT 1
	FROM [rusicst].[dbo].[Encuesta]
	where Titulo = @NombreEncuesta)
	
	BEGIN
	
		SELECT ISNULL([Id], 0) as [Id]
		FROM [rusicst].[dbo].[Encuesta]
		where Titulo = @NombreEncuesta
		
	END
	ELSE
	BEGIN
		SELECT 0 AS [Id]
	END

END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerIdPadrePregunta]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23																			 
-- Descripcion: Consulta el IdSeccion de la Etapa de una pregunta
-- ***************************************************************************************************
CREATE PROC [PlanesMejoramiento].[C_ObtenerIdPadrePregunta]
(
	@IdPregunta INT
)

AS

BEGIN

DECLARE @IdPadre INT
DECLARE @SuperSeccion INT
DECLARE @OUT TABLE
(
	IdPadre INT
)

SELECT	
	@SuperSeccion = IdSeccion
FROM 
	dbo.Pregunta 
WHERE
	Id = @IdPregunta

SET @IdPadre = 0

WHILE (@SuperSeccion IS NOT NULL)
BEGIN
    
    
    SELECT	
		@IdPadre = Id,
		@SuperSeccion = SuperSeccion
	FROM
		[dbo].[Seccion]
	WHERE
		Id = @SuperSeccion
		
		
    IF @SuperSeccion IS NULL
    begin
		INSERT INTO @OUT 
		SELECT @IdPadre
        BREAK;
    end
    
END

SELECT * FROM @OUT

END

GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerIdPlanByEncuestaID]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23																			 
-- Descripcion: Consulta el Id del plan de mejoramiento asociado a un Id de Encuesta dado como parámetro
-- ***************************************************************************************************
CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerIdPlanByEncuestaID] --39
(
	@IdEncuesta INT
)
AS
BEGIN

	SELECT TOP 1 ISNULL(MAX(ISNULL(A.IdPlanMejoramiento, 0)),0) as PlanID
	FROM PlanesMejoramiento.PlanMejoramiento A 
	LEFT OUTER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta B ON B.IdPlanMejoriamiento = A.IdPlanMejoramiento
	WHERE B.IdEncuesta = @IdEncuesta
	
END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerInformacionAccionesPlan]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23																			 
-- Descripcion: Consulta la informacion de las Acciones guardadas por un Usuario en una Recomendacion Especifica
-- ***************************************************************************************************
CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionAccionesPlan]
(
	@IdRecomendacion INT
)
AS
BEGIN

	SELECT e.*
	FROM PlanesMejoramiento.Recomendacion a
	INNER JOIN PlanesMejoramiento.ObjetivoEspecifico b ON a.IdObjetivoEspecifico = b.IdObjetivoEspecifico
	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramiento d ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
	INNER JOIN PlanesMejoramiento.AccionesPlan e ON e.IdRecomendacion = a.IdRecomendacion
	WHERE e.IdRecomendacion = @IdRecomendacion
	
END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerInformacionObjetivosPlanes]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [PlanesMejoramiento].[C_ObtenerInformacionObjetivosPlanes]

  as
  
  BEGIN	
		SELECT d.Nombre as NombrePlan, d.FechaLimite, c.Titulo as NombreSeccion, b.ObjetivoEspecifico, b.IdObjetivoEspecifico
		FROM [PlanesMejoramiento].[ObjetivoEspecifico] b
		inner join [PlanesMejoramiento].[SeccionPlanMejoramiento] c on b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
		inner join [PlanesMejoramiento].[PlanMejoramiento] d on c.IdPlanMejoramiento = d.IdPlanMejoramiento
  END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerInformacionRecomendaciones]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionRecomendaciones] --1270980
(
	@IdPregunta INT
)
AS
BEGIN

	SELECT a.IdRecomendacion, a.Opcion, a.Recomendacion, a.Calificacion, 
	b.IdObjetivoEspecifico, b.ObjetivoEspecifico, 
	b.PorcentajeObjetivo, c.ObjetivoGeneral, c.IdSeccionPlanMejoramiento, 
	c.Titulo, c.Ayuda, d.IdPlanMejoramiento, d.Nombre, d.FechaLimite, 
	d.CondicionesAplicacion, e.CodigoPregunta, e.NombrePregunta, e.IdTipoPregunta
	FROM PlanesMejoramiento.Recomendacion a
	INNER JOIN PlanesMejoramiento.ObjetivoEspecifico b ON a.IdObjetivoEspecifico = b.IdObjetivoEspecifico
	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramiento d ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
	left outer JOIN BancoPreguntas.PreguntaModeloAnterior f ON f.IdPreguntaAnterior = a.IdPregunta
	left outer JOIN BancoPreguntas.Preguntas e ON e.IdPregunta = f.IdPregunta	
	WHERE a.IdPregunta = @IdPregunta
	
END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerInformacionRecomendacionesPlan]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-09-08																			 
-- Descripcion: Consulta la informacion de las Recomendaciones asignadas a una Seccion de un Plan de Mejoramiento
-- ***************************************************************************************************
CREATE PROC [PlanesMejoramiento].[C_ObtenerInformacionRecomendacionesPlan] --7
  (
	@IdSeccion int
  )
  
  as
  
  BEGIN	
		SELECT b.IdObjetivoEspecifico, d.IdPregunta, a.IdRecomendacion, c.IdSeccionPlanMejoramiento, 
		b.ObjetivoEspecifico, c.ObjetivoGeneral, a.Opcion, a.Calificacion, b.PorcentajeObjetivo, 
		d.NombrePregunta, a.Recomendacion, c.Titulo
		FROM [PlanesMejoramiento].[Recomendacion] a
		inner join [PlanesMejoramiento].[ObjetivoEspecifico] b on a.IdObjetivoEspecifico = b.IdObjetivoEspecifico
		inner join [PlanesMejoramiento].[SeccionPlanMejoramiento] c on b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
		inner join [BancoPreguntas].[PreguntaModeloAnterior] e on e.IdPreguntaAnterior = a.IdPregunta
		inner join [BancoPreguntas].[Preguntas] d on d.IdPregunta = e.IdPregunta
		where c.IdSeccionPlanMejoramiento = @IdSeccion
  END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerListadoEncuestasPlan]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23																			 
-- Descripcion: Consulta la informacion de las Encuestas asignadas a un Plan de Mejoramiento
-- ***************************************************************************************************
CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerListadoEncuestasPlan]
(
	@idPlan int
)

AS

BEGIN


	SELECT DISTINCT b.*
	FROM [PlanesMejoramiento].[PlanMejoramientoEncuesta] a
	JOIN [dbo].[Encuesta] b on b.Id = a.IdEncuesta
	WHERE a.IdPlanMejoriamiento = @idPlan

END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerListadoEncuestasSinResponder]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23																			 
-- Descripcion: Consulta la informacion de las Encuestas que aún no tienen respuesta alguna
-- ***************************************************************************************************
CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerListadoEncuestasSinResponder]

AS

BEGIN

	SELECT DISTINCT A.* 
	FROM dbo.Encuesta A 
	INNER JOIN dbo.Seccion B ON B.IdEncuesta = A.Id
	INNER JOIN dbo.Pregunta C ON C.IdSeccion = B.Id
	WHERE A.Id NOT IN (

		SELECT DISTINCT a.IdEncuesta
		FROM [dbo].[Autoevaluacion2] a
	)
	AND C.Id NOT IN
	(
		SELECT r.IdPregunta
		FROM dbo.Respuesta r
	)

END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerListadoPlanes]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23																			 
-- Descripcion: Consulta la informacion del Listado de Planes de Mejoramiento
-- ***************************************************************************************************
CREATE PROC [PlanesMejoramiento].[C_ObtenerListadoPlanes]

AS

BEGIN


SELECT A.IdPlanMejoramiento, A.Nombre, A.FechaLimite,
	STUFF(
         (SELECT DISTINCT ', ' + C.Titulo
          FROM PlanesMejoramiento.PlanMejoramiento AA
			INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta BB ON AA.IdPlanMejoramiento = BB.IdPlanMejoriamiento
			INNER JOIN dbo.Encuesta C ON C.Id = BB.IdEncuesta
			WHERE AA.IdPlanMejoramiento = A.IdPlanMejoramiento
          FOR XML PATH (''))
          , 1, 1, '')  AS URLList
	FROM PlanesMejoramiento.PlanMejoramiento A
	INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta B ON A.IdPlanMejoramiento = B.IdPlanMejoriamiento
	INNER JOIN dbo.Encuesta C ON C.Id = B.IdEncuesta
	GROUP BY A.IdPlanMejoramiento, A.Nombre, A.FechaLimite
	
	UNION ALL
	
	SELECT A.IdPlanMejoramiento, A.Nombre, A.FechaLimite, '' as URLList
	FROM PlanesMejoramiento.PlanMejoramiento A
	WHERE A.IdPlanMejoramiento NOT IN (
		SELECT XX.IdPlanMejoriamiento FROM PlanesMejoramiento.PlanMejoramientoEncuesta XX 
		WHERE XX.IdPlanMejoriamiento = A.IdPlanMejoramiento
	)

END

GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerListadoSeccionesPlan]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23																			 
-- Descripcion: Consulta la informacion de las Secciones creadas en un Plan de Mejoramiento
-- ***************************************************************************************************
CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerListadoSeccionesPlan]
(
	@idPlan int
)

AS

BEGIN

	SELECT 
		   [IdSeccionPlanMejoramiento]
		  ,[ObjetivoGeneral]
		  ,[Titulo]
		  ,[Ayuda]
		  ,[IdSeccionPlanMejoramientoPadre]
		  ,[IdPlanMejoramiento]
	FROM 
		[PlanesMejoramiento].[SeccionPlanMejoramiento]
	WHERE
		IdPlanMejoramiento = @idPlan

END

GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerPorcentajeTotalObjetivosPM]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerPorcentajeTotalObjetivosPM] --13,72
(
	@IdPlanMejoramiento INT,
	@IdSeccion INT
)
AS
BEGIN

	SELECT ISNULL(SUM(ISNULL(C.PorcentajeObjetivo, 0)), 0) AS TotalPorc
	FROM PlanesMejoramiento.PlanMejoramiento A
	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento B ON B.IdPlanMejoramiento = A.IdPlanMejoramiento
	LEFT OUTER JOIN PlanesMejoramiento.ObjetivoEspecifico C ON C.IdSeccionPlanMejoramiento = B.IdSeccionPlanMejoramiento
	WHERE A.IdPlanMejoramiento = @IdPlanMejoramiento AND B.IdSeccionPlanMejoramiento = @IdSeccion
END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerPreguntasPlanMejoramiento]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-09-08																			 
-- Descripcion: Consulta la informacion de las Preguntas de la Encuesta asignada a un Plan de Mejoramiento
-- ***************************************************************************************************
CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerPreguntasPlanMejoramiento]
(
	@IdPlanMejoramiento INT
)
AS
BEGIN

	SELECT DISTINCT c.Id as IdPregunta, e.CodigoPregunta, e.NombrePregunta
	FROM Encuesta a
	INNER JOIN Seccion b ON a.Id = b.IdEncuesta
	INNER JOIN Pregunta c ON b.Id = c.IdSeccion
	INNER JOIN BancoPreguntas.PreguntaModeloAnterior d ON c.Id = d.IdPreguntaAnterior
	INNER JOIN BancoPreguntas.Preguntas e ON d.IdPregunta = e.IdPregunta
	INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta f ON a.Id = f.IdEncuesta
	--INNER JOIN dbo.Opciones g ON g.IdPregunta = c.Id
	WHERE f.IdPlanMejoriamiento = @IdPlanMejoramiento
	
END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerSeccionesEncuestasPlanMejoramiento]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23																			 
-- Descripcion: Consulta la informacion de las Secciones de las Encuestas asociadas a un Plan de Mejoramiento
-- ***************************************************************************************************
CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerSeccionesEncuestasPlanMejoramiento] --1
(
	@IdPlanMejoramiento INT
)
AS
BEGIN

	SELECT b.Id, b.Titulo--, b.Ayuda
	FROM Encuesta a
	INNER JOIN Seccion b ON a.Id = b.IdEncuesta
	INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta f ON a.Id = f.IdEncuesta
	WHERE f.IdPlanMejoriamiento = @IdPlanMejoramiento
	AND b.Eliminado = 0 AND b.OcultaTitulo = 0
	
END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[C_ObtenerTiposRecurso]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-09-01																			 
-- Descripcion: Consulta la informacion de los tipos de recurso creados
-- ***************************************************************************************************
CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerTiposRecurso]

AS
BEGIN

	SELECT 
		[IdTipoRecurso]
		,[NombreTipoRecurso]
		,[Clase]
	FROM 
		[PlanesMejoramiento].[TipoRecurso]
	
END



GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[D_PlanMejoramientoObjetivoEspecificoDelete]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-10-24																		 
/Descripcion: Elimina los datos de un Objetivo Especifico
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PlanesMejoramiento].[D_PlanMejoramientoObjetivoEspecificoDelete]
(
	@IdObjetivo INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[Recomendacion] a
				WHERE a.[IdObjetivoEspecifico] = @IdObjetivo)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'Ha ocurrido un error eliminando el Objetivo Específico. Aún tiene recomendaciones asociadas.'
	END

	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [PlanesMejoramiento].[ObjetivoEspecifico]
				WHERE [IdObjetivoEspecifico] = @IdObjetivo		
		
			SELECT @respuesta = 'Se ha Eliminado el Objetivo Específico.'
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

END


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[D_PlanMejoramientoRecomendacionDelete]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-10-24																		 
/Descripcion: Elimina los datos de una Recomendación
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PlanesMejoramiento].[D_PlanMejoramientoRecomendacionDelete]
(
	@IdRecomendacion INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[RecursosPlan] a
				WHERE a.IdRecomendacion = @IdRecomendacion)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'Ha ocurrido un error eliminando la recomendación seleccionada. La recomendación ya ha sido respondida por algún usuario.'
	END

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[AccionesPlan] a
				WHERE a.IdRecomendacion = @IdRecomendacion)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'Ha ocurrido un error eliminando la recomendación seleccionada. La recomendación ya ha sido respondida por algún usuario.'
	END

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[AvancesPlan] a
				WHERE a.IdRecomendacion = @IdRecomendacion)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'Ha ocurrido un error eliminando la recomendación seleccionada. La recomendación ya ha sido respondida por algún usuario.'
	END

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[DiligenciamientoPlan] a
				WHERE a.IdRecomendacion = @IdRecomendacion)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'Ha ocurrido un error eliminando la recomendación seleccionada. La recomendación ya ha sido respondida por algún usuario.'
	END
	
	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [PlanesMejoramiento].[Recomendacion]
				WHERE [IdRecomendacion] = @IdRecomendacion		
		
			SELECT @respuesta = 'Se ha Eliminado la Recomendación.'
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

END


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[D_PlanMejoramientoRecursoDelete]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-09-01																		 
/Descripcion: Elimina los datos de un Recurso
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PlanesMejoramiento].[D_PlanMejoramientoRecursoDelete]
(
	@IdRecurso INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[RecursosPlan] a
					INNER JOIN [PlanesMejoramiento].[TipoRecurso] b ON b.IdTipoRecurso = a.IdTipoRecurso
				WHERE b.IdTipoRecurso = @IdRecurso)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'No se puede eliminar el tipo de recurso. Por favor verifique que no se encuentre diligenciado en algún Plan de Mejoramiento.'
	END

	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [PlanesMejoramiento].[TipoRecurso]
				WHERE IdTipoRecurso = @IdRecurso		
		
			SELECT @respuesta = 'Se ha eliminado el Tipo de Recurso.'
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

END


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[D_PlanMejoramientoSeccionDelete]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-10-24																		 
/Descripcion: Elimina los datos de una Seccion de un Plan de Mejoramiento
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PlanesMejoramiento].[D_PlanMejoramientoSeccionDelete]
(
	@IdSeccion INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[ObjetivoEspecifico] a
				WHERE a.[IdSeccionPlanMejoramiento] = @IdSeccion)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'La sección no se puede eliminar. Por favor verifique que no tenga objetivos específicos y/o recomendaciones creadas.'
	END

	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [PlanesMejoramiento].[SeccionPlanMejoramiento]
				WHERE 	[IdSeccionPlanMejoramiento] = @IdSeccion	
		
			SELECT @respuesta = 'Se ha eliminado correctamente la Sección.'
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

END


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[I_PlanMejoramientoActivacionInsert]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-10-24																			  
-- Descripcion: Inserta la información de la activacion del plan												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
CREATE PROC [PlanesMejoramiento].[I_PlanMejoramientoActivacionInsert]
(
	@IdPlanMejoramiento int,
	@FechaIni datetime,
	@FechaFin datetime,
	@MuestraPorc bit
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (EXISTS(SELECT * 
			FROM [PlanesMejoramiento].[PlanActivacionFecha] 
			WHERE [IdPlanMejoramiento]  = @IdPlanMejoramiento))
	BEGIN

		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE
				[PlanesMejoramiento].[PlanActivacionFecha]
			SET
				FechaInicio = @FechaIni
				,FechaFin = @FechaFin
				,bitShowPorcentaje = @MuestraPorc
			WHERE
				[IdPlanMejoramiento]  = @IdPlanMejoramiento

			SELECT @respuesta = 'Se ha re-activado el plan de Mejoramiento.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = 'El Plan de Mejoramiento no se puede re-activar!'
			SELECT @estadoRespuesta = 0
		END CATCH

	END

	ELSE
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[PlanActivacionFecha] ([IdPlanMejoramiento], [bitShowPorcentaje], [FechaInicio], [FechaFin])
			VALUES (@IdPlanMejoramiento, @MuestraPorc, @FechaIni, @FechaFin)			

			SELECT @respuesta = 'Se ha activado el plan de Mejoramiento.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = 'El Plan de Mejoramiento no se puede activar!'
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado
END


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[I_PlanMejoramientoEncuestaInsert]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-08-23																			  
-- Descripcion: Inserta la información de una Encuesta asociada a un Plan de Mejoramiento												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
CREATE PROC [PlanesMejoramiento].[I_PlanMejoramientoEncuestaInsert]
(
	@IdPlan INT
	,@IdEncuesta INT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF (NOT EXISTS(SELECT * FROM [PlanesMejoramiento].[PlanMejoramiento] WHERE IdPlanMejoramiento  = @IdPlan))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Plan de Mejoramiento no existe en el Sistema.'
	END

	IF (EXISTS(SELECT * FROM [PlanesMejoramiento].[PlanMejoramientoEncuesta] WHERE [IdPlanMejoriamiento]  = @IdPlan and [IdEncuesta]= @IdEncuesta))
	BEGIN
		SET @esValido = 0
		
		SELECT @respuesta = 'Se ha asociado la Encuesta al Plan de Mejoramiento.'
		SELECT @estadoRespuesta = 1
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			
			INSERT INTO [PlanesMejoramiento].[PlanMejoramientoEncuesta] ([IdPlanMejoriamiento], [IdEncuesta])		
			VALUES (@IdPlan, @IdEncuesta)

			SELECT @respuesta = 'Se ha asociado la Encuesta al Plan de Mejoramiento.'
			SELECT @estadoRespuesta = 1
	
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


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[I_PlanMejoramientoInsert]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-08-23																			  
-- Descripcion: Inserta la información de un Nuevo Plan de Mejoramiento												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
CREATE PROC [PlanesMejoramiento].[I_PlanMejoramientoInsert]
(
	@NombrePlan varchar(2000)
	,@FechaLimite datetime
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF (EXISTS(SELECT * FROM [PlanesMejoramiento].[PlanMejoramiento] WHERE [Nombre]  = @NombrePlan))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Nombre del Plan de Mejoramiento ya existe en el Sistema.'
	END

	IF (LEN(@NombrePlan) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'Debe escribir el Nombre del Plan de Mejoramiento.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[PlanMejoramiento] ([Nombre], [FechaLimite], [CondicionesAplicacion], [Estado])
			VALUES (@NombrePlan, @FechaLimite, 'En Configuracion', 0)			

			SELECT @respuesta = 'Se ha guardado el Plan de Mejoramiento.'
			SELECT @estadoRespuesta = 1
	
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


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[I_PlanMejoramientoObjetivoEspecificoInsert]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-10-24																			  
-- Descripcion: Inserta la información de un Nuevo Objetivo Especifico												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
CREATE PROC [PlanesMejoramiento].[I_PlanMejoramientoObjetivoEspecificoInsert]
(
	@ObjetivoEspecifico varchar(1024)
	,@PorcentajeObjetivo int
	,@IdSeccion int
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF (EXISTS(SELECT * FROM [PlanesMejoramiento].[ObjetivoEspecifico] WHERE [ObjetivoEspecifico]  = @ObjetivoEspecifico AND [IdSeccionPlanMejoramiento] = @IdSeccion))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Objetivo Específico ya existe en el Sistema.'
	END

	IF (LEN(@ObjetivoEspecifico) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'Debe escribir el Objetivo Específico.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[ObjetivoEspecifico] ([ObjetivoEspecifico], [PorcentajeObjetivo], [IdSeccionPlanMejoramiento])
			VALUES (@ObjetivoEspecifico, @PorcentajeObjetivo, @IdSeccion)			

			SELECT @respuesta = 'Se ha guardado el Objetivo.|' + convert(varchar, @@IDENTITY)
			SELECT @estadoRespuesta = 1
	
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


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[I_PlanMejoramientoRecomendacionInsert]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-10-24																			  
-- Descripcion: Inserta la información de una Nueva Recomendación												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
CREATE PROC [PlanesMejoramiento].[I_PlanMejoramientoRecomendacionInsert]
(
	@Recomendacion varchar(4000)
	,@Calificacion int
	,@IdObjetivo int
	,@Opcion varchar(100)
	,@IdPregunta int
	,@IdEtapa int
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (LEN(@Recomendacion) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'Debe escribir la Recomendación.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[Recomendacion] ([Opcion], [Recomendacion], [Calificacion], [IdObjetivoEspecifico], [IdPregunta], [IdEtapa])
			VALUES (@Opcion, @Recomendacion, @Calificacion, @IdObjetivo, @IdPregunta, @IdEtapa)			

			SELECT @respuesta = 'Se ha guardado la Recomendación.'
			SELECT @estadoRespuesta = 1
	
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


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[I_PlanMejoramientoRecursoInsert]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-09-01																			  
-- Descripcion: Inserta la información de un Nuevo Recurso												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
CREATE PROC [PlanesMejoramiento].[I_PlanMejoramientoRecursoInsert]
(
	@NombreTipo varchar(250)
	,@Clase varchar(50)
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF (EXISTS(SELECT * FROM [PlanesMejoramiento].[TipoRecurso] WHERE [NombreTipoRecurso]  = @NombreTipo))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Nombre del Recurso ya existe en el Sistema.'
	END

	IF (LEN(@NombreTipo) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'Debe escribir el Nombre del Recurso.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[TipoRecurso] ([NombreTipoRecurso], [Clase])
			VALUES (@NombreTipo, @Clase)			

			SELECT @respuesta = 'Se ha guardado el Recurso.'
			SELECT @estadoRespuesta = 1
	
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


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[I_SeccionPlanMejoramientoInsert]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-08-28																		  
-- Descripcion: Inserta la información de una Nueva Sección de un Plan de Mejoramiento												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
CREATE PROC [PlanesMejoramiento].[I_SeccionPlanMejoramientoInsert]
(
	@ObjetivoGeneral VARCHAR(2000)
	,@Titulo VARCHAR(200)
	,@Ayuda VARCHAR(2000)
	,@IdSeccionPadre INT
	,@IdPlan INT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF (LEN(@ObjetivoGeneral) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Objetivo General no Puede ir vacío.'
	END

	IF (LEN(@Titulo) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Nombre de la sección no Puede ir vacío.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[SeccionPlanMejoramiento] ([ObjetivoGeneral], [Titulo], [Ayuda], [IdSeccionPlanMejoramientoPadre], [IdPlanMejoramiento])
			VALUES (@ObjetivoGeneral, @Titulo, @Ayuda, @IdSeccionPadre, @IdPlan)			

			SELECT @respuesta = 'Se ha almacenado la Sección en el Plan de Mejoramiento.'
			SELECT @estadoRespuesta = 1
	
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


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[U_PlanMejoramientoRecursoUpdate]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-09-01																		 
/Descripcion: Actualiza los datos de un Recurso
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PlanesMejoramiento].[U_PlanMejoramientoRecursoUpdate]
(
	@IdRecurso INT
	,@NombreTipo varchar(250)
	,@Clase varchar(50)
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (NOT EXISTS(SELECT * FROM [PlanesMejoramiento].[TipoRecurso] WHERE IdTipoRecurso  = @IdRecurso))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Recurso no existe.'
	END
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE 
				[PlanesMejoramiento].[TipoRecurso]
			SET
				NombreTipoRecurso = @NombreTipo
				,Clase = @Clase
			WHERE
				IdTipoRecurso = @IdRecurso

		SELECT @respuesta = 'Se ha Actualizado el registro'
		SELECT @estadoRespuesta = 1
	
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


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[U_PlanMejoramientoUpdate]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-08-23																			 
/Descripcion: Actualiza los datos de un Plan de Mejoramiento
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PlanesMejoramiento].[U_PlanMejoramientoUpdate]
(
	@IdPlan INT
	,@NombrePlan varchar(2000)
	,@FechaLimite datetime
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (NOT EXISTS(SELECT * FROM [PlanesMejoramiento].[PlanMejoramiento] WHERE IdPlanMejoramiento  = @IdPlan))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Plan de Mejoramiento no existe.'
	END
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE 
				[PlanesMejoramiento].[PlanMejoramiento]
			SET
				Nombre = @NombrePlan
				,FechaLimite = @FechaLimite
				,CondicionesAplicacion = 'En Configuracion'
				,Estado = 0
			WHERE
				IdPlanMejoramiento = @IdPlan

		SELECT @respuesta = 'Se ha Actualizado el registro'
		SELECT @estadoRespuesta = 1
	
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


GO
/****** Object:  StoredProcedure [PlanesMejoramiento].[U_SeccionPlanMejoramientoUpdate]    Script Date: 25/10/2017 10:56:31 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-08-28																			 
/Descripcion: Actualiza los datos de una Sección de un Plan de Mejoramiento
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PlanesMejoramiento].[U_SeccionPlanMejoramientoUpdate]
(
	@ObjetivoGeneral VARCHAR(2000)
	,@Titulo VARCHAR(200)
	,@Ayuda VARCHAR(2000)
	,@IdSeccionPadre INT
	,@IdPlan INT
	,@IdSeccionPlan INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (NOT EXISTS(SELECT * FROM [PlanesMejoramiento].[SeccionPlanMejoramiento] WHERE IdSeccionPlanMejoramiento = @IdSeccionPlan and IdPlanMejoramiento  = @IdPlan))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'La Sección a Actualizar en el Plan de Mejoramiento no existe.'
	END

	IF (LEN(@ObjetivoGeneral) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Objetivo General no Puede ir vacío.'
	END

	IF (LEN(@Titulo) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Nombre de la sección no Puede ir vacío.'
	END
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE 
				[PlanesMejoramiento].[SeccionPlanMejoramiento]
			SET
				ObjetivoGeneral = @ObjetivoGeneral 
				,Titulo = @Titulo
				,Ayuda = @Ayuda
				,IdSeccionPlanMejoramientoPadre = @IdSeccionPadre
			WHERE
				IdSeccionPlanMejoramiento = @IdSeccionPlan

		SELECT @respuesta = 'Se ha Editado la Sección en el Plan de Mejoramiento.'
		SELECT @estadoRespuesta = 1
	
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


GO
