--- Procedimientos actualizados.

USE [rusicst]
GO

if exists (select * from sys.procedures where name like '%C_ReporteConsolidadoDetalle%')
begin
drop procedure C_ReporteConsolidadoDetalle
end

/****** Object:  StoredProcedure [dbo].[C_ReporteConsolidadoDetalle]    Script Date: 24-May-17 04:06:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- ==================================================================================================================
-- Author:	Desarrolladores RUSICST - Ajustado por el equipo de desarrollo de la OIM (Nelson Restrepo)
-- Create date:	Desconocida - Update date : 30-03-2017
-- Description:	Procedimiento que retorna los datos para el informe consolidado. Se cambio de nombre para que estos
--				tengan coherencia con los nombres de los otros procedimientos. Se deja el procedimiento original que
--				estaba con el nombre reporte_ejecutivo2.
-- ==================================================================================================================
CREATE PROCEDURE [dbo].[C_ReporteConsolidadoDetalle] 
		(
			@IdDepartamento INT, 
			@IdEncuesta INT
		)
		AS
			BEGIN 
	
			DECLARE @TipoEncuesta VARCHAR(50)
			DECLARE @CantidadRespuestasObligatorias INT
			
			SET @TipoEncuesta = (SELECT '%' + SUBSTRING(b.Nombre, 6, 11) + '%' FROM Encuesta a, TipoEncuesta b WHERE a.IdTipoEncuesta = b.Id AND (a.Id = @IdEncuesta))
			SET @CantidadRespuestasObligatorias = (SELECT COUNT (*) FROM Seccion S, Pregunta P WHERE S.Id = P.IdSeccion AND S.IdEncuesta = @IdEncuesta AND P.EsObligatoria = 1)

			PRINT '0 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @TablaUsuarioUno TABLE
			(
				Username VARCHAR(50)
			)			

			INSERT INTO @TablaUsuarioUno
			(
				Username
			)
			SELECT 
				Usuario Username
			FROM
				(SELECT b.UserName Usuario, a.IdPregunta FROM Respuesta a, Usuario b WHERE a.IdUsuario = b.Id AND a.Valor != '-') Respuesta,
				(SELECT Id, IdSeccion FROM Pregunta WHERE EsObligatoria = 1) Pregunta,
				(SELECT Id, IdEncuesta FROM Seccion WHERE IdEncuesta = @IdEncuesta) Seccion
			WHERE Respuesta.IdPregunta = Pregunta.Id 
				AND Pregunta.IdSeccion = Seccion.Id
			GROUP BY 
				Usuario
			HAVING 
				(COUNT(DISTINCT IdPregunta) - @CantidadRespuestasObligatorias) = 0

			DECLARE @TablaUsuarioDos TABLE
			(
				Username VARCHAR(50)
			)

			INSERT INTO @TablaUsuarioDos
			SELECT 
				DISTINCT Respuesta.Usuario Username
			FROM 
				(SELECT b.UserName Usuario, a.IdPregunta FROM Respuesta a, Usuario b WHERE a.IdUsuario = b.Id AND b.UserName LIKE @TipoEncuesta) Respuesta,
				Pregunta, 
				(SELECT Id FROM Seccion WHERE IdEncuesta = @IdEncuesta) Seccion
				WHERE Respuesta.IdPregunta = Pregunta.Id 
				AND Pregunta.IdSeccion = Seccion.Id

			DECLARE @TablaUsuarioTres TABLE
			(
				Username VARCHAR(50)
			)
			INSERT INTO @TablaUsuarioTres
			SELECT 
				DISTINCT b.UserName Usuario 
			FROM 
				Autoevaluacion2 a, Usuario b 
			WHERE 
				a.IdUsuario = b.Id
				AND (a.IdEncuesta = @IdEncuesta) 
				AND a.Recomendacion IS NOT NULL 
				AND LEN(a.Acciones) > 0

			DECLARE @FECFIN DATETIME 
			DECLARE @FECINI DATETIME
											 
			PRINT '1 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			IF EXISTS (	SELECT TOP 1 [FechaFin] FROM [PermisoUsuarioEncuesta] WHERE IdEncuesta = @IdEncuesta ORDER BY FechaFin DESC)
			BEGIN
				SET @FECFIN = (SELECT TOP 1 [FechaFin] FROM [PermisoUsuarioEncuesta] WHERE IdEncuesta = @IdEncuesta ORDER BY FechaFin DESC)
			END
			ELSE
				BEGIN
					SET @FECFIN =(SELECT FechaFin FROM Encuesta WHERE ID = @IdEncuesta)
				END
	
			SET @FECINI = (SELECT FechaInicio FROM Encuesta WHERE ID = @IdEncuesta) 
	
			PRINT '2 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			DECLARE @Tabla1 TABLE
			(
				divipola VARCHAR(50), 
				nombre VARCHAR(250), 
				municipio NUMERIC(38)
			)
	
			INSERT INTO @Tabla1 
			(
			divipola , 
			nombre , 
			municipio 
			)
			SELECT TOP (100) PERCENT 
				Departamento.Divipola, 
				Departamento.Nombre, 
				COUNT(DISTINCT Municipio.Divipola) AS municipio
			FROM 
				Departamento, 
				Municipio, 
				Usuario 
			WHERE Departamento.Id = Municipio.IdDepartamento 
				AND Departamento.Id = Usuario.IdDepartamento 
				AND Municipio.Id = Usuario.IdMunicipio
				AND Departamento.Divipola = (CASE WHEN @IdDepartamento = '-1' THEN Departamento.Divipola ELSE @IdDepartamento END)
			GROUP BY 
				Departamento.Divipola, Departamento.Nombre, Usuario.Activo
			HAVING 
				(Usuario.Activo = 1) 
			ORDER BY 
				Departamento.Nombre

			PRINT @TipoEncuesta

			PRINT '3 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			DECLARE @Tabla2 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla2 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT(Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				@TablaUsuarioUno tu,
				Municipio, 
				Departamento
			WHERE tu.Username = Usuario.Username
				AND Usuario.IdMunicipio = Municipio.Id
				AND Usuario.IdDepartamento = Departamento.Id
				AND	Departamento.Divipola = (CASE WHEN @IdDepartamento = '-1' THEN Departamento.Divipola ELSE @IdDepartamento END)
			GROUP BY 
				Departamento.Nombre, Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '4 - ' + CONVERT(VARCHAR, GETDATE(), 113)
		
			DECLARE @Tabla3 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC (38)
			)
	
			INSERT INTO @Tabla3 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				Municipio, 
				Departamento 
			WHERE 
				Usuario.IdMunicipio = Municipio.Id 	
				AND Usuario.IdDepartamento = Departamento.Id
				AND Usuario.Username NOT IN 	(	SELECT 
														b.UserName Usuario 
													FROM 
														Respuesta a, Usuario b
													WHERE 
														a.IdUsuario = b.Id
														AND a.IdPregunta IN 	(	SELECT 
																						Pregunta.Id
																					FROM 
																						Seccion, 
																						Pregunta 
																					WHERE Seccion.Id = Pregunta.IdSeccion
																					AND (Seccion.IdEncuesta = @IdEncuesta) 
																						AND (Pregunta.EsObligatoria = 1)
																				)
													GROUP BY 
														b.UserName
													HAVING 
														(COUNT(*) - (	SELECT 
																			COUNT (*) 
																		FROM 
																			Seccion, 
																			Pregunta 
																		WHERE
																			Seccion.Id = Pregunta.IdSeccion 
																			AND Seccion.IdEncuesta = @IdEncuesta
																			AND Pregunta.EsObligatoria = 1
																	) 
														) = 0
												)
	    		AND Departamento.Divipola = (CASE WHEN @IdDepartamento = '-1' THEN Departamento.Divipola ELSE @IdDepartamento END)
			GROUP BY 
				Departamento.Nombre, Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '5 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			DECLARE @Tabla4 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla4 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Usuario.Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				Municipio, 
				Departamento 
				WHERE
					Usuario.IdMunicipio = Municipio.Id 
					AND Usuario.IdDepartamento = Departamento.Id 	
					AND Usuario.Username IN (SELECT Username FROM @TablaUsuarioTres)
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '6 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla5 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC(38)
			)
			INSERT INTO @Tabla5 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Usuario.Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				Municipio,
				Departamento
			WHERE 
				Usuario.IdMunicipio = Municipio.Divipola 
				AND Usuario.IdDepartamento = Departamento.Divipola
				AND Usuario.Username NOT IN (SELECT Username FROM @TablaUsuarioTres)
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '7 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla6 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla6 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				Municipio, 
				Departamento 
			WHERE 
				Usuario.IdMunicipio = Municipio.Id 
				AND Usuario.IdDepartamento = Departamento.Id
				AND (Usuario.Username IN 	(	SELECT 
												DISTINCT b.UserName Usuario
											FROM 
												Envio a, Usuario b
											WHERE 
												a.IdUsuario = b.Id
												AND (a.IdEncuesta = @IdEncuesta)
											)
					) 
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '8 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla7 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(35)
			)
	
			INSERT INTO @Tabla7 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				Municipio, 
				Departamento 
			WHERE 
				Usuario.IdMunicipio = Municipio.Id 
				AND Usuario.IdDepartamento = Departamento.Id
				AND (Usuario.Username NOT IN 	(	SELECT 
													DISTINCT b.UserName Usuario
												FROM 
													Envio a, Usuario b
												WHERE 
													a.IdUsuario = b.Id
													AND (a.IdEncuesta = @IdEncuesta)
											)
					) 
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '9 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla8 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC(38)
			)
	
			INSERT INTO @Tabla8 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			--IF OBJECT_ID('tempdb..@TABLA8') IS NOT NULL DROP TABLE @TABLA8
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				@TablaUsuarioDos td, 
				Municipio,  
				Departamento 
			WHERE
				Usuario.Username = td.Username
				AND Usuario.IdMunicipio = Municipio.Id
				AND Usuario.IdDepartamento = Departamento.Id
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '10 - ' + CONVERT(VARCHAR, GETDATE(), 113)
		
			DECLARE @Tabla9 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla9 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				Municipio, 
				Departamento 
			WHERE 
				Usuario.IdMunicipio = Municipio.Id 
				AND Usuario.IdDepartamento = Departamento.Id
				AND Usuario.Username NOT IN (SELECT Username FROM @TablaUsuarioDos)
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '11 - ' + CONVERT(VARCHAR, GETDATE(), 113)
		
			DECLARE @Tabla10 TABLE
			(
				DIVIPOLA VARCHAR (250),
				DEPARTAMENTO VARCHAR (250), 
				MUNICIPIOS VARCHAR (250), 
				SI_GUARDO VARCHAR (250),
				NO_GUARDO VARCHAR (250),
				SI_COM_REP VARCHAR (250),
				NO_COM_REP VARCHAR (250),
				SI_ENVIARON VARCHAR (250),
				NO_ENVIARON VARCHAR (250),
				SI_INFO_PLAN VARCHAR (250),
				NO_INFO_PLAN VARCHAR (250)
			)
			
			INSERT INTO @Tabla10 
			(
				DIVIPOLA,
				DEPARTAMENTO, 
				MUNICIPIOS, 
				SI_GUARDO,
				NO_GUARDO,
				SI_COM_REP,
				NO_COM_REP,
				SI_ENVIARON,
				NO_ENVIARON,
				SI_INFO_PLAN,
				NO_INFO_PLAN 
			)
			SELECT
				tab1.Divipola AS DIVIPOLA,
				tab1.Nombre AS DEPARTAMENTO, 
				(tab1.municipio) AS MUNICIPIOS, 
				(tab8.TOTAL_ENVIO) AS SI_GUARDO,
				(tab9.TOTAL_ENVIO) AS NO_GUARDO,
				(tab2.TOTAL_ENVIO) AS SI_COM_REP,
				(tab3.TOTAL_ENVIO) AS NO_COM_REP,
				(tab6.TOTAL_ENVIO) AS SI_ENVIARON,
				(tab7.TOTAL_ENVIO) AS NO_ENVIARON,
				(tab4.TOTAL_ENVIO) AS SI_INFO_PLAN,
				(tab5.TOTAL_ENVIO) AS NO_INFO_PLAN 
			FROM 
				@Tabla1 tab1,
				@TABLA2 tab2, 
				@TABLA3 tab3, 
				@TABLA4 tab4, 
				@TABLA5 tab5, 
				@TABLA6 tab6, 
				@TABLA7 tab7, 
				@TABLA8 tab8, 
				@TABLA9 tab9 
			WHERE
				tab1.Divipola = tab2.Divipola 
				AND tab1.Divipola = tab3.Divipola
				AND tab1.Divipola = tab4.Divipola
				AND tab1.Divipola = tab5.Divipola
				AND tab1.Divipola = tab6.Divipola
				AND tab1.Divipola = tab7.Divipola
				AND tab1.Divipola = tab8.Divipola
				AND tab1.Divipola = tab9.Divipola
				

			PRINT '12 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			--SELECT * FROM @Tabla10
	
			PRINT '13 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			SELECT	
				 T10.DIVIPOLA
				,T10.DEPARTAMENTO
				,T10.MUNICIPIOS
				,T10.SI_GUARDO
				,T10.NO_GUARDO
				,T10.SI_COM_REP
				,T10.NO_COM_REP
				,T10.SI_ENVIARON
				,T10.NO_ENVIARON
				,T10.SI_INFO_PLAN
				,T10.NO_INFO_PLAN
			FROM @Tabla10 T10
	
			PRINT '15 - ' + CONVERT(VARCHAR, GETDATE(), 113)

		END
		
GO


USE [rusicst]
GO

if exists (select * from sys.procedures where name like '%C_ReporteConsolidadoTotales%')
begin
drop procedure C_ReporteConsolidadoTotales
end

/****** Object:  StoredProcedure [dbo].[C_ReporteConsolidadoTotales]    Script Date: 24-May-17 04:08:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- ==================================================================================================================
-- Author:	Desarrolladores RUSICST - Ajustado por el equipo de desarrollo de la OIM (Nelson Restrepo)
-- Create date:	Desconocida - Update date : 30-03-2017
-- Description:	Procedimiento que retorna los datos para el informe consolidado. Se cambio de nombre para que estos
--				tengan coherencia con los nombres de los otros procedimientos. Se deja el procedimiento original que
--				estaba con el nombre reporte_ejecutivo2.
-- ==================================================================================================================
CREATE PROCEDURE [dbo].[C_ReporteConsolidadoTotales] 
		(
			@IdDepartamento INT, 
			@IdEncuesta INT
		)
		AS
			BEGIN 
	
			DECLARE @TipoEncuesta VARCHAR(50)
			DECLARE @CantidadRespuestasObligatorias INT
			
			SET @TipoEncuesta = (SELECT '%' + SUBSTRING(b.Nombre, 6, 11) + '%' FROM Encuesta a, TipoEncuesta b WHERE a.IdTipoEncuesta = b.Id AND (a.Id = @IdEncuesta))
			SET @CantidadRespuestasObligatorias = (SELECT COUNT (*) FROM Seccion, Pregunta WHERE Seccion.Id = Pregunta.IdSeccion AND Seccion.IdEncuesta = @IdEncuesta AND Pregunta.EsObligatoria = 1)

			PRINT '0 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @TablaUsuarioUno TABLE
			(
				Username VARCHAR(50)
			)			

			INSERT INTO @TablaUsuarioUno
			(
				Username
			)
			SELECT 
				Usuario Username
			FROM 
				(SELECT b.UserName Usuario, a.IdPregunta FROM Respuesta a, Usuario b WHERE a.IdUsuario = b.Id AND a.Valor != '-') Respuesta,
				(SELECT Id, IdSeccion FROM Pregunta WHERE EsObligatoria = 1) Pregunta,
				(SELECT Id, IdEncuesta FROM Seccion WHERE IdEncuesta = @IdEncuesta) Seccion 
			WHERE
				Respuesta.IdPregunta = Pregunta.Id 
				AND Pregunta.IdSeccion = Seccion.Id
			GROUP BY 
				Usuario
			HAVING 
				(COUNT(DISTINCT IdPregunta) - @CantidadRespuestasObligatorias) = 0

			DECLARE @TablaUsuarioDos TABLE
			(
				Username VARCHAR(50)
			)

			INSERT INTO @TablaUsuarioDos
			SELECT 
				DISTINCT Respuesta.Usuario Username
			FROM 
				(SELECT b.UserName Usuario, a.IdPregunta FROM Respuesta a, Usuario b WHERE a.IdUsuario = b.Id AND b.UserName LIKE @TipoEncuesta) Respuesta,
				Pregunta,
				(SELECT Id FROM Seccion WHERE IdEncuesta = @IdEncuesta) Seccion 
			WHERE Respuesta.IdPregunta = Pregunta.Id 
			AND Pregunta.IdSeccion = Seccion.Id

			DECLARE @TablaUsuarioTres TABLE
			(
				Username VARCHAR(50)
			)
			INSERT INTO @TablaUsuarioTres
			SELECT 
				DISTINCT b.UserName Usuario 
			FROM 
				Autoevaluacion2 a, Usuario b 
			WHERE 
				a.IdUsuario = b.Id
				AND (a.IdEncuesta = @IdEncuesta) 
				AND a.Recomendacion IS NOT NULL 
				AND LEN(a.Acciones) > 0

			DECLARE @FECFIN DATETIME 
			DECLARE @FECINI DATETIME
											 
			PRINT '1 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			IF EXISTS (	SELECT TOP 1 [FechaFin] FROM [PermisoUsuarioEncuesta] WHERE IdEncuesta = @IdEncuesta ORDER BY FechaFin DESC)
			BEGIN
				SET @FECFIN = (SELECT TOP 1 [FechaFin] FROM [PermisoUsuarioEncuesta] WHERE IdEncuesta = @IdEncuesta ORDER BY FechaFin DESC)
			END
			ELSE
				BEGIN
					SET @FECFIN =(SELECT FechaFin FROM Encuesta WHERE ID = @IdEncuesta)
				END
	
			SET @FECINI = (SELECT FechaInicio FROM Encuesta WHERE ID = @IdEncuesta) 
	
			PRINT '2 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			DECLARE @Tabla1 TABLE
			(
				divipola VARCHAR(50), 
				nombre VARCHAR(250), 
				municipio NUMERIC(38)
			)
	
			INSERT INTO @Tabla1 
			(
			divipola , 
			nombre , 
			municipio 
			)
			SELECT TOP (100) PERCENT 
				Departamento.Divipola, 
				Departamento.Nombre, 
				COUNT(DISTINCT Municipio.Divipola) AS municipio
			FROM 
				Departamento, 
				Municipio,  
				Usuario 
			WHERE 
				Departamento.Id = Municipio.IdDepartamento
				AND Departamento.Id = Usuario.IdDepartamento 
				AND Municipio.Id = Usuario.IdMunicipio
				AND Departamento.Divipola = (CASE WHEN @IdDepartamento = '-1' THEN Departamento.Divipola ELSE @IdDepartamento END)
			GROUP BY 
				Departamento.Divipola, Departamento.Nombre, Usuario.Activo
			HAVING 
				(Usuario.Activo = 1) 
			ORDER BY 
				Departamento.Nombre

			PRINT @TipoEncuesta

			PRINT '3 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			DECLARE @Tabla2 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla2 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				@TablaUsuarioUno tu, 
				Municipio, 
				Departamento 
			WHERE 
				tu.Username = Usuario.Username
				AND Usuario.IdMunicipio = Municipio.Id
				AND Usuario.IdDepartamento = Departamento.Id
				AND Departamento.Divipola = (CASE WHEN @IdDepartamento = '-1' THEN Departamento.Divipola ELSE @IdDepartamento END)
			GROUP BY 
				Departamento.Nombre, Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '4 - ' + CONVERT(VARCHAR, GETDATE(), 113)
		
			DECLARE @Tabla3 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC (38)
			)
	
			INSERT INTO @Tabla3 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				Municipio, 
				Departamento 
			WHERE 
				Usuario.IdMunicipio = Municipio.Id 
				AND Usuario.IdDepartamento = Departamento.Id
				AND (Usuario.Username NOT IN 	(	SELECT 
														b.UserName Usuario 
													FROM 
														Respuesta a, Usuario b
													WHERE 
														a.IdUsuario = b.Id
														AND a.IdPregunta IN 	(	SELECT 
																						Pregunta.Id
																					FROM 
																						Seccion, 
																						Pregunta 
																					WHERE 
																						Seccion.Id = Pregunta.IdSeccion
																						AND (Seccion.IdEncuesta = @IdEncuesta) 
																						AND (Pregunta.EsObligatoria = 1)
																		)
													GROUP BY 
														b.UserName
													HAVING 
														(COUNT(*) - (	SELECT 
																			COUNT (*) 
																		FROM 
																			Seccion, 
																			Pregunta 
																		WHERE 
																			Seccion.Id = Pregunta.IdSeccion
																			AND (Seccion.IdEncuesta = @IdEncuesta) 
																			AND (Pregunta.EsObligatoria = 1)
																	) 
														) = 0
												)
					) 
				AND Departamento.Divipola = (CASE WHEN @IdDepartamento = '-1' THEN Departamento.Divipola ELSE @IdDepartamento END)
			GROUP BY 
				Departamento.Nombre, Departamento.Divipola
			ORDER BY 
				Departamento.Nombre


			PRINT '5 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			DECLARE @Tabla4 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla4 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Usuario.Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				Municipio, 
				Departamento 
				WHERE 
					Usuario.IdMunicipio = Municipio.Id 
					AND Usuario.IdDepartamento = Departamento.Id	
					AND Usuario.Username IN (SELECT Username FROM @TablaUsuarioTres)
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre


			PRINT '6 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla5 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC(38)
			)
			INSERT INTO @Tabla5 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Usuario.Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				Municipio, 
				Departamento 
			WHERE 
				Usuario.IdMunicipio = Municipio.Divipola 
				AND Usuario.IdDepartamento = Departamento.Divipola
				AND Usuario.Username NOT IN (SELECT Username FROM @TablaUsuarioTres)
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '7 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla6 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla6 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				Municipio, 
				Departamento 
			WHERE 
				Usuario.IdMunicipio = Municipio.Id 
				AND Usuario.IdDepartamento = Departamento.Id
				AND (Usuario.Username IN 	(	SELECT 
												DISTINCT b.UserName Usuario
											FROM 
												Envio a, Usuario b
											WHERE 
												a.IdUsuario = b.Id
												AND (a.IdEncuesta = @IdEncuesta)
										)
					) 
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '8 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla7 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(35)
			)
	
			INSERT INTO @Tabla7 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				Municipio, 
				Departamento 
			WHERE 
				Usuario.IdMunicipio = Municipio.Id 
				AND Usuario.IdDepartamento = Departamento.Id
				AND (Usuario.Username NOT IN 	(	SELECT 
													DISTINCT b.UserName Usuario
												FROM 
													Envio a, Usuario b
												WHERE 
													a.IdUsuario = b.Id
													AND (a.IdEncuesta = @IdEncuesta)
											)
					) 
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '9 - ' + CONVERT(VARCHAR, GETDATE(), 113)

			DECLARE @Tabla8 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR(250), 
				TOTAL_ENVIO NUMERIC(38)
			)
	
			INSERT INTO @Tabla8 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			--IF OBJECT_ID('tempdb..@TABLA8') IS NOT NULL DROP TABLE @TABLA8
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				@TablaUsuarioDos td, 
				Municipio, 
				Departamento 
			WHERE
				Usuario.Username = td.Username
				AND Usuario.IdMunicipio = Municipio.Id 
				AND Usuario.IdDepartamento = Departamento.Id
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '10 - ' + CONVERT(VARCHAR, GETDATE(), 113)
		
			DECLARE @Tabla9 TABLE
			(
				divipola VARCHAR(50), 
				Expr1 VARCHAR (250), 
				TOTAL_ENVIO NUMERIC(38)
			)

			INSERT INTO @Tabla9 
			(
				divipola , 
				Expr1 , 
				TOTAL_ENVIO 
			)
			SELECT 
				Departamento.Divipola,
				Departamento.Nombre AS Expr1, 
				COUNT( Departamento.Divipola) AS TOTAL_ENVIO
			FROM 
				(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0)) Usuario,
				Municipio, 
				Departamento 
			WHERE 
				Usuario.IdMunicipio = Municipio.Id 
				AND Usuario.IdDepartamento = Departamento.Id
				AND Usuario.Username NOT IN (SELECT Username FROM @TablaUsuarioDos)
			GROUP BY 
				Departamento.Nombre, 
				Departamento.Divipola
			ORDER BY 
				Departamento.Nombre

			PRINT '11 - ' + CONVERT(VARCHAR, GETDATE(), 113)
		
			DECLARE @Tabla10 TABLE
			(
				DIVIPOLA VARCHAR (250),
				DEPARTAMENTO VARCHAR (250), 
				MUNICIPIOS VARCHAR (250), 
				SI_GUARDO VARCHAR (250),
				NO_GUARDO VARCHAR (250),
				SI_COM_REP VARCHAR (250),
				NO_COM_REP VARCHAR (250),
				SI_ENVIARON VARCHAR (250),
				NO_ENVIARON VARCHAR (250),
				SI_INFO_PLAN VARCHAR (250),
				NO_INFO_PLAN VARCHAR (250)
			)

			INSERT INTO @Tabla10 
			(
				DIVIPOLA,
				DEPARTAMENTO, 
				MUNICIPIOS, 
				SI_GUARDO,
				NO_GUARDO,
				SI_COM_REP,
				NO_COM_REP,
				SI_ENVIARON,
				NO_ENVIARON,
				SI_INFO_PLAN,
				NO_INFO_PLAN 
			)
			SELECT
				tab1.Divipola AS DIVIPOLA,
				tab1.Nombre AS DEPARTAMENTO, 
				(tab1.municipio) AS MUNICIPIOS, 
				(tab8.TOTAL_ENVIO) AS SI_GUARDO,
				(tab9.TOTAL_ENVIO) AS NO_GUARDO,
				(tab2.TOTAL_ENVIO) AS SI_COM_REP,
				(tab3.TOTAL_ENVIO) AS NO_COM_REP,
				(tab6.TOTAL_ENVIO) AS SI_ENVIARON,
				(tab7.TOTAL_ENVIO) AS NO_ENVIARON,
				(tab4.TOTAL_ENVIO) AS SI_INFO_PLAN,
				(tab5.TOTAL_ENVIO) AS NO_INFO_PLAN 
			FROM 
				@Tabla1 tab1,
				@TABLA2 tab2,   
				@TABLA3 tab3,   
				@TABLA4 tab4,  
				@TABLA5 tab5, 
				@TABLA6 tab6,  
				@TABLA7 tab7,  
				@TABLA8 tab8,  
				@TABLA9 tab9 
			WHERE
				tab1.Divipola = tab2.Divipola
				AND tab1.Divipola = tab3.Divipola
				AND tab1.Divipola = tab4.Divipola 
				AND tab1.Divipola = tab5.Divipola 
				AND tab1.Divipola = tab6.Divipola 
				AND tab1.Divipola = tab7.Divipola 
				AND tab1.Divipola = tab8.Divipola 
				AND tab1.Divipola = tab9.Divipola 

			PRINT '12 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			--SELECT * FROM @Tabla10
	
			PRINT '13 - ' + CONVERT(VARCHAR, GETDATE(), 113)
			DECLARE @Tabla11 TABLE
			(
			ENTIDADES NUMERIC,
			SI_GUARDO NUMERIC, 
			NO_GUARDO NUMERIC,
			SI_COM_REP NUMERIC,
			NO_COM_REP NUMERIC,
			SI_ENVIARON NUMERIC,
			NO_ENVIARON NUMERIC,
			SI_INFO_PLAN NUMERIC,
			NO_INFO_PLAN NUMERIC
			)
	
			INSERT INTO @Tabla11 
			(
				ENTIDADES,
				SI_GUARDO, 
				NO_GUARDO, 
				SI_COM_REP,
				NO_COM_REP,
				SI_ENVIARON,
				NO_ENVIARON,
				SI_INFO_PLAN,
				NO_INFO_PLAN 
			)
			SELECT
				SUM(ISNULL(tab1.municipio,0)) AS ENTIDADES, 
				SUM(ISNULL(tab8.TOTAL_ENVIO,0)) AS SI_GUARDO,
				SUM(ISNULL(tab9.TOTAL_ENVIO,0)) AS NO_GUARDO,
				SUM(ISNULL(tab2.TOTAL_ENVIO,0)) AS SI_COM_REP,
				SUM(ISNULL(tab3.TOTAL_ENVIO,0)) AS NO_COM_REP,
				SUM(ISNULL(tab6.TOTAL_ENVIO,0)) AS SI_ENVIARON,
				SUM(ISNULL(tab7.TOTAL_ENVIO,0)) AS NO_ENVIARON,
				SUM(ISNULL(tab4.TOTAL_ENVIO,0)) AS SI_INFO_PLAN,
				SUM(ISNULL(tab5.TOTAL_ENVIO,0)) AS NO_INFO_PLAN 
			FROM 
				@Tabla1 tab1,
				@TABLA2 tab2,   
				@TABLA3 tab3,   
				@TABLA4 tab4,  
				@TABLA5 tab5, 
				@TABLA6 tab6,  
				@TABLA7 tab7,  
				@TABLA8 tab8,  
				@TABLA9 tab9 
			WHERE
				tab1.Divipola = tab2.Divipola
				AND tab1.Divipola = tab3.Divipola
				AND tab1.Divipola = tab4.Divipola 
				AND tab1.Divipola = tab5.Divipola 
				AND tab1.Divipola = tab6.Divipola 
				AND tab1.Divipola = tab7.Divipola 
				AND tab1.Divipola = tab8.Divipola 
				AND tab1.Divipola = tab9.Divipola 

			PRINT '14 - ' + CONVERT(VARCHAR, GETDATE(), 113)
	
			SELECT	
				T11.ENTIDADES
				,T11.SI_GUARDO ENT_SI_GUARDO
				,T11.NO_GUARDO ENT_NO_GUARDO
				,T11.SI_COM_REP ENT_SI_COM_REP
				,T11.NO_COM_REP ENT_NO_COM_REP
				,T11.SI_ENVIARON ENT_SI_ENVIARON
				,T11.NO_ENVIARON ENT_NO_ENVIARON
				,T11.SI_INFO_PLAN ENT_SI_INFO_PLAN
				,T11.NO_INFO_PLAN ENT_NO_INFO_PLAN
			FROM @Tabla11 T11
	
			PRINT '15 - ' + CONVERT(VARCHAR, GETDATE(), 113)

		END

GO


USE [rusicst]
GO

if exists (select * from sys.procedures where name like '%C_UsuariosEnviaronReporte%')
begin
drop procedure C_UsuariosEnviaronReporte
end

/****** Object:  StoredProcedure [dbo].[C_UsuariosEnviaronReporte]    Script Date: 24-May-17 04:10:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--****************************************************************************************************
-- Autor: Robinson Moscoso																			 
-- Fecha creacion: 2017-01-27																			 
-- Descripcion: Consulta la informacion para identificar los usaurios que enviarion o no reporte												
-- Retorna: UsariosEnviaronReporte								 
--****************************************************************************************************
CREATE PROC [dbo].[C_UsuariosEnviaronReporte] 

	@IdEncuesta	INT

AS
	BEGIN

		SELECT    
			c.Nombre Departamento
			,b.Nombre Municipio
			,a.Username Usuario
			,a.UserName Nombre
			,a.Email
			,'SI' AS [ENVIO]
		FROM
			Usuario a,
			Municipio b, 
			Departamento c 
		WHERE    
			a.IdMunicipio = b.Id
			AND a.IdDepartamento = c.Id
			AND (a.UserName LIKE (SELECT '%' + SUBSTRING(e.Nombre, 6, 11) + '%' AS Expr1
										FROM   Encuesta d, TipoEncuesta e
										WHERE 
										d.IdTipoEncuesta = e.Id 
										AND (d.Id = @IdEncuesta)
										AND (a.Activo = 1) 
										AND (a.IdMunicipio + a.IdDepartamento > 0))) 
										AND (a.Username IN (  SELECT DISTINCT g.UserName
																FROM Envio f, Usuario g
																WHERE 
																f.IdUsuario = g.Id
																AND (f.IdEncuesta = @IdEncuesta))) 

		UNION ALL
		SELECT     
			c.Nombre Departamento
			,b.Nombre Municipio
			,a.Username Usuario
			,a.UserName NombreUsuario
			,a.Email
			,'NO' AS ENVIO
		FROM   
			Usuario a,
			Municipio b, 
			Departamento c
		WHERE 
			a.IdMunicipio = b.Id 
			AND a.IdDepartamento = c.Id
			AND (a.Username LIKE (SELECT '%' + SUBSTRING(e.Nombre, 6, 11) + '%' AS Expr1
										FROM   Encuesta d, TipoEncuesta e
										WHERE 
										d.IdTipoEncuesta = e.Id
										AND (d.Id = @IdEncuesta)
										AND (a.Activo = 1) 
										AND (a.IdMunicipio + a.IdDepartamento > 0))) 
										AND (a.Username  NOT IN ( SELECT DISTINCT g.UserName
																	FROM Envio f, Usuario g
																	WHERE 
																	f.IdUsuario = g.Id
																	AND (f.IdEncuesta = @IdEncuesta))) 
		ORDER BY 
			c.Nombre
			,b.Nombre
	END
		

GO

USE [rusicst]
GO

if exists (select * from sys.procedures where name like '%C_UsuariosGuardaronInformacionAutoevaluacion%')
begin
drop procedure C_UsuariosGuardaronInformacionAutoevaluacion
end

/****** Object:  StoredProcedure [dbo].[C_UsuariosGuardaronInformacionAutoevaluacion]    Script Date: 24-May-17 04:11:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Robinson Moscoso
-- Create date:	30/01/2017
-- Description:	Procedimiento que retorna la informaci髇 de todos los usuario  
--				en el sistema que guardaron informacion en Autoevaluacion
-- =============================================
CREATE PROCEDURE [dbo].[C_UsuariosGuardaronInformacionAutoevaluacion] 
	
	@Encuesta	 INT

AS
	BEGIN
 
		DECLARE @FECFIN DATETIME 
		DECLARE @FECINI DATETIME 
		
		SELECT   
			 c.Nombre Departamento
			,b.Nombre Municipio
			,a.Username Usuario
			,a.Nombres Nombre 
			,a.Email
			,'SI' AS Guardo
		FROM      
			Usuario a,
			Municipio b, 
			Departamento c 
		WHERE     
			a.IdMunicipio = b.Id 
			AND a.IdDepartamento = c.Id
			AND (a.Username LIKE (SELECT '%' + SUBSTRING(e.Nombre, 6, 11) + '%' AS Expr1
										FROM  Encuesta d, TipoEncuesta e
										WHERE
										d.IdTipoEncuesta = e.Id
										AND (d.Id = @Encuesta)
										AND (a.Activo = 1) 
										AND (a.IdMunicipio + a.IdDepartamento > 0))) 
										AND (a.Username IN (  SELECT DISTINCT g.UserName 
																FROM Autoevaluacion2 f, Usuario g
																WHERE 
																f.IdUsuario = g.Id
																AND (IdEncuesta = @Encuesta)
																AND Recomendacion IS NOT NULL 
																AND LEN(Acciones) > 0))
		UNION ALL
		SELECT    
			 c.Nombre Departamento
			,b.Nombre Municipio
			,a.Username Usuario
			,a.Nombres Nombre
			,a.Email
			,'NO' AS  Guardo
		FROM
			Usuario a, 
			Municipio b, 
			Departamento c 
		WHERE
			a.IdMunicipio = b.Id 
			AND a.IdDepartamento = c.Id
			AND (a.Username LIKE (SELECT '%' + SUBSTRING(e.Nombre, 6, 11) + '%' AS Expr1
										FROM  Encuesta d, TipoEncuesta e 
										WHERE 
										d.IdTipoEncuesta = e.Id
										AND (d.Id = @Encuesta)
										AND (a.Activo = 1) 
										AND (a.IdMunicipio + a.IdDepartamento > 0))) 
										AND (a.Username  NOT IN (	SELECT DISTINCT g.UserName 
																		FROM Autoevaluacion2 f, Usuario g
																		WHERE 
																		f.IdUsuario = g.Id
																		AND (IdEncuesta = @Encuesta)
																		AND Recomendacion IS NOT NULL 
																		AND LEN(Acciones) > 0))
		ORDER BY 
			 c.Nombre
			,b.Nombre

	END
		

GO


USE [rusicst]
GO

/****** Object:  StoredProcedure [dbo].[C_UsuariosGuardaronInformacionSistema]    Script Date: 24-May-17 04:14:53 PM ******/
SET ANSI_NULLS ON
GO

if exists (select * from sys.procedures where name like '%C_UsuariosGuardaronInformacionSistema%')
begin
drop procedure C_UsuariosGuardaronInformacionSistema
end

SET QUOTED_IDENTIFIER ON
GO



-- ==================================================================================================================
-- Author:	Robinson Moscoso 
--			Ajustado por el equipo de desarrollo de la OIM - Nelson Restrepo
-- Create date:	31-01-2017 - Update date : 30-03-2017
-- Description:	Procedimiento que retorna la informaci髇 de los usuarios que guardaron Informacion en el Sistema
-- ==================================================================================================================

CREATE PROCEDURE [dbo].[C_UsuariosGuardaronInformacionSistema] 

	@IdEncuesta INT

AS

	BEGIN

		DECLARE @FECFIN DATETIME 
		DECLARE @FECINI DATETIME 

		DECLARE @TipoEncuesta VARCHAR(50)

		SET @TipoEncuesta = (SELECT '%' + SUBSTRING(b.Nombre, 6, 11) + '%' FROM Encuesta a, TipoEncuesta b WHERE a.IdTipoEncuesta = b.Id AND (a.Id = @IdEncuesta))

		DECLARE @TablaUsuarioDos TABLE
		(
			Username VARCHAR(50)
		)

		INSERT INTO @TablaUsuarioDos
		SELECT 
			DISTINCT Respuesta.Usuario Username
		FROM 
			(SELECT b.UserName Usuario, IdPregunta FROM Respuesta a, Usuario b WHERE a.IdUsuario = b.Id AND b.UserName LIKE @TipoEncuesta) Respuesta,
			Pregunta,  
			(SELECT Id FROM Seccion WHERE IdEncuesta = @IdEncuesta) Seccion 
		WHERE 
			Respuesta.IdPregunta = Pregunta.Id
			AND Pregunta.IdSeccion = Seccion.Id

		IF exists (SELECT TOP 1 [FechaFin] FROM [PermisoUsuarioEncuesta] WHERE IdEncuesta = @IdEncuesta ORDER BY FechaFin DESC)
		BEGIN
			SET @FECFIN = (SELECT TOP 1 [FechaFin] FROM [PermisoUsuarioEncuesta] WHERE IdEncuesta = @IdEncuesta ORDER BY FechaFin DESC)
		END
		ELSE
		BEGIN
			SET @FECFIN = (SELECT FechaFin FROM Encuesta WHERE ID = @IdEncuesta)
		END

		SET @FECINI =(SELECT FechaInicio FROM Encuesta WHERE ID = @IdEncuesta) 

		--===================================================
		-- Usuarios que guardaron informaci髇 en el sistema
		--===================================================
		SELECT 
			Departamento.Nombre AS Departamento
			,Municipio.Nombre as Municipio
			,usuario.Username as Usuario
			,Usuario.Nombres Nombre
			,Usuario.Email
			,'SI' AS GUARDO
		FROM 
			(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (IdMunicipio + IdDepartamento > 0)) Usuario,
			Municipio, 
			Departamento 
		WHERE 
			Usuario.IdMunicipio = Municipio.Id 
			AND Usuario.IdDepartamento = Departamento.Id
			AND Usuario.Username IN (SELECT Username FROM @TablaUsuarioDos)
		UNION ALL
		SELECT 
			Departamento.Nombre AS Departamento
			,Municipio.Nombre as Municipio
			,usuario.Username as Usuario
			,Usuario.Nombres Nombre
			,Usuario.Email
			,'NO' AS GUARDO
		FROM 
			(SELECT * FROM Usuario WHERE Username LIKE @TipoEncuesta AND Activo = 1 AND (IdMunicipio + IdDepartamento > 0)) Usuario, 
			Municipio, 
			Departamento 
		WHERE 
			Usuario.IdMunicipio = Municipio.Id 
			AND Usuario.IdDepartamento = Departamento.Id
			AND Usuario.Username NOT IN (SELECT Username FROM @TablaUsuarioDos)
		ORDER BY 
			Departamento.Nombre
			,Municipio.Nombre

	END
																								
GO


USE [rusicst]
GO

/****** Object:  StoredProcedure [dbo].[C_UsuariosPasaronAutoevaluacion]    Script Date: 24-May-17 04:16:07 PM ******/
SET ANSI_NULLS ON
GO

if exists (select * from sys.procedures where name like '%C_UsuariosPasaronAutoevaluacion%')
begin
drop procedure C_UsuariosPasaronAutoevaluacion
end

SET QUOTED_IDENTIFIER ON
GO


-- ======================================================================================================================
-- Author:	Robinson Moscoso
-- Create date:	31/01/2017
-- Description:	Procedimiento que retorna la informaci髇 de todos los usuario en el sistema que pasaron a Autoevaluacion
-- ======================================================================================================================
CREATE PROCEDURE [dbo].[C_UsuariosPasaronAutoevaluacion]

	 @Encuesta INT

AS
BEGIN

SELECT 
	Departamento.Nombre Departamento
	,Municipio.Nombre Municipio
	,usuario.Username Usuario
	,UPPER(Usuario.Nombres) AS Nombre
	,LOWER(Usuario.Email) AS Email
	,'SI' AS Paso
FROM 
	Usuario, 
	Municipio, 
	Departamento 
WHERE 
	Usuario.IdMunicipio = Municipio.Id 
	AND Usuario.IdDepartamento = Departamento.Id
	AND (Usuario.Username LIKE (SELECT '%' + SUBSTRING(b.Nombre, 6, 11) + '%' AS Expr1
									FROM Encuesta a, TipoEncuesta b
									WHERE 
									a.IdTipoEncuesta = b.Id
									AND (a.Id = @Encuesta)
									AND (Usuario.Activo = 1) 
									AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0))) 
	AND (Usuario.Username IN  ( SELECT d.UserName Usuario 
									FROM Respuesta c, Usuario d
									WHERE 
										c.IdUsuario = d.Id
										AND IdPregunta IN (SELECT Pregunta.Id
															FROM Seccion, 
															Pregunta 
															WHERE 
															Seccion.Id = Pregunta.IdSeccion
															AND (Seccion.IdEncuesta = @Encuesta) 
															AND (Pregunta.EsObligatoria = 1)) 
									AND valor != '-'
									GROUP BY d.UserName
									HAVING (COUNT(distinct IdPregunta) - (SELECT COUNT (*)
																			FROM Seccion, 
																			Pregunta 
																			WHERE 
																			Seccion.Id = Pregunta.IdSeccion
																			AND (Seccion.IdEncuesta = @Encuesta) 
																			AND (Pregunta.EsObligatoria = 1))) = 0))


UNION ALL

SELECT 
	Departamento.Nombre AS Departamento
	,Municipio.Nombre AS Municipio
	,usuario.Username AS Usuario
	,UPPER(Usuario.Nombres) AS Nombre
	,LOWER(Usuario.Email) AS Email
	,'NO' AS Paso
FROM 
	Usuario, 
	Municipio, 
	Departamento 
WHERE 
	Usuario.IdMunicipio = Municipio.Id 
	AND Usuario.IdDepartamento = Departamento.Id
	AND (Usuario.Username LIKE (SELECT '%' + SUBSTRING(b.Nombre, 6, 11) + '%' AS Expr1
								FROM Encuesta a, TipoEncuesta b
								WHERE 
								a.IdTipoEncuesta = b.Id
								AND (a.Id = @Encuesta)
								AND (Usuario.Activo = 1) 
								AND (Usuario.IdMunicipio + Usuario.IdDepartamento > 0))) 
								AND (Usuario.Username NOT IN (SELECT d.UserName Usuario 
																	FROM Respuesta c, Usuario d 
																	WHERE 
																		c.IdUsuario = d.Id
																		AND IdPregunta IN (SELECT Pregunta.Id
																						FROM Seccion, 
																						Pregunta 
																						WHERE 
																						Seccion.Id = Pregunta.IdSeccion
																						AND (Seccion.IdEncuesta = @Encuesta) 
																						AND (Pregunta.EsObligatoria = 1))
																	AND valor != '-'
																	GROUP BY d.UserName
																	HAVING (COUNT(distinct IdPregunta) - (SELECT COUNT (*) 
																										FROM Seccion, 
																										Pregunta 
																										WHERE 
																										Seccion.Id = Pregunta.IdSeccion
																										AND (Seccion.IdEncuesta = @Encuesta)
																										AND (Pregunta.EsObligatoria = 1))) = 0))
	ORDER BY Departamento.Nombre, Municipio.Nombre

END

GO


USE [rusicst]
GO

/****** Object:  View [dbo].[vw_PreguntaClasificador]    Script Date: 24-May-17 04:17:14 PM ******/
SET ANSI_NULLS ON
GO

if exists (select * from sys.views where name like '%vw_PreguntaClasificador%' )
begin
drop view vw_PreguntaClasificador
end

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_PreguntaClasificador]
AS 
SELECT 
	b.IdPregunta, c.NombreDetalleClasificador, d.CodigoClasificador
FROM 
	BancoPreguntas.PreguntaDetalleClasificador b, BancoPreguntas.DetalleClasificador c, BancoPreguntas.Clasificadores d 
WHERE 
	b.IdDetalleClasificador = c.IdDetalleClasificador AND c.IdClasificador = d.IdClasificador

GO

---- Corte de actualizaci髇 1 y 2.

USE [rusicst]
GO

--- Agregar campo IdTablero en table Pregunta PAT

if exists (select * from sys.columns where name='IdTablero' and Object_id in (select object_id from sys.tables where name ='PreguntaPAT'))
begin
	if exists (select * from sysindexes where name = 'IDX_PreguntaPAT_IdTablero')
	begin
		DROP INDEX [IDX_PreguntaPAT_IdTablero] ON [PAT].[PreguntaPAT]  	
	end
	ALTER TABLE [PAT].[PreguntaPAT] DROP CONSTRAINT [FK_TableroFecha_TableroPP]
	alter table [PAT].[PreguntaPAT] drop column [IdTablero]	
end

ALTER TABLE [PAT].[PreguntaPAT] add [IdTablero] [tinyint]
ALTER TABLE [PAT].[PreguntaPAT]  WITH CHECK ADD  CONSTRAINT [FK_TableroFecha_TableroPP] FOREIGN KEY([IdTablero])
REFERENCES [PAT].[Tablero] ([Id])
GO

CREATE NONCLUSTERED INDEX [IDX_PreguntaPAT_IdTablero] ON [PAT].[PreguntaPAT]
(
	[IdTablero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

--- Agregar campo IdTablero en table PreguntaPATReparacionColectiva

if exists (select * from sys.columns where name='IdTablero' and Object_id in (select object_id from sys.tables where name ='PreguntaPATReparacionColectiva'))
begin
	if exists (select * from sysindexes where name = 'IDX_PreguntaPATReparacionColectiva_IdTablero')
	begin
		DROP INDEX [IDX_PreguntaPATReparacionColectiva_IdTablero] ON [PAT].[PreguntaPATReparacionColectiva]  	
	end
	ALTER TABLE [PAT].[PreguntaPATReparacionColectiva] DROP CONSTRAINT [FK_TableroFecha_TableroRC]
	alter table [PAT].[PreguntaPATReparacionColectiva] drop column [IdTablero]	
end

ALTER TABLE [PAT].[PreguntaPATReparacionColectiva] add [IdTablero] [tinyint]
CREATE NONCLUSTERED INDEX [IDX_PreguntaPATReparacionColectiva_IdTablero] ON [PAT].[PreguntaPATReparacionColectiva]
(
	[IdTablero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [PAT].[PreguntaPATReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_TableroFecha_TableroRC] FOREIGN KEY([IdTablero])
REFERENCES [PAT].[Tablero] ([Id])

--- Agregar campo IdTablero en tabla PreguntaPATRetornosReubicaciones

if exists (select * from sys.columns where name='IdTablero' and Object_id in (select object_id from sys.tables where name ='PreguntaPATRetornosReubicaciones'))
begin
	if exists (select * from sysindexes where name = 'IDX_PreguntaPATRetornosReubicaciones_IdTablero')
	begin
		DROP INDEX [IDX_PreguntaPATRetornosReubicaciones_IdTablero] ON [PAT].[PreguntaPATRetornosReubicaciones]  	
	end
	ALTER TABLE [PAT].[PreguntaPATRetornosReubicaciones] DROP CONSTRAINT [FK_TableroFecha_TableroRR]
	alter table [PAT].[PreguntaPATRetornosReubicaciones] drop column [IdTablero]	
end

ALTER TABLE [PAT].[PreguntaPATRetornosReubicaciones] add [IdTablero] [tinyint]
CREATE NONCLUSTERED INDEX [IDX_PreguntaPATRetornosReubicaciones_IdTablero] ON [PAT].[PreguntaPATRetornosReubicaciones]
(
	[IdTablero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [PAT].[PreguntaPATRetornosReubicaciones]  WITH CHECK ADD  CONSTRAINT [FK_TableroFecha_TableroRR] FOREIGN KEY([IdTablero])
REFERENCES [PAT].[Tablero] ([Id])


USE [rusicst]
GO

update  PAT.PreguntaPAT  set IDTABLERO = 1 where ACTIVO = 0 --2016
update  PAT.PreguntaPAT  set IDTABLERO = 2 where ACTIVO = 1 --2017
update  [PAT].[PreguntaPATReparacionColectiva]  set IDTABLERO = 1 where ID <= 2242 --2016
update  [PAT].[PreguntaPATReparacionColectiva]  set IDTABLERO = 2 where id  > 2242 --2017
update  [PAT].[PreguntaPATRetornosReubicaciones] set IDTABLERO = 2

USE [rusicst]
GO

/****** Object:  UserDefinedFunction [PAT].[fn_GetIdEntidad]    Script Date: 07-Jun-17 04:20:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		10/06/2016
-- Modified date:	
-- Description:		Funcion que retorna el Id de la Entidad a traves del idusuario
-- =============================================
ALTER FUNCTION [PAT].[fn_GetIdEntidad] (
	@ID INT
)
RETURNS INT
AS
BEGIN	
	DECLARE @RETURN  INT
	/*
	SELECT @RETURN = ID_ENTIDAD
	FROM TB_USUARIO (NOLOCK) U
	WHERE ID = @ID
	*/ --- Codigo anterior se modifica bajo la nueva estructura de PAT - Icapera 07072017
	
	SELECT @RETURN = U.[Id]
	FROM [dbo].[Usuario] (NOLOCK) U
	WHERE U.ID = @ID
	RETURN @RETURN
END


GO

USE [rusicst]
GO

if exists (select * from sys.procedures where name = 'C_TodosTablerosMunicipiosCompletos')
begin
drop procedure [PAT].[C_TodosTablerosMunicipiosCompletos]
end

/****** Object:  StoredProcedure [PAT].[C_TodosTablerosMunicipiosCompletos]    Script Date: 07-Jun-17 04:30:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [PAT].[C_TodosTablerosMunicipiosCompletos]

AS

BEGIN

select
A.[Id],
B.[VigenciaInicio],
B.[VigenciaFin]
from
[PAT].[Tablero] A,
[PAT].[TableroFecha] B
where
A.[Id]=B.[IdTablero]
and B.[Nivel]=3
and A.[Activo]=0

END
GO

USE [rusicst]
GO

if exists (select * from sys.procedures where name = 'C_TodosTablerosMunicipiosPorCompletar')
begin
drop procedure [PAT].[C_TodosTablerosMunicipiosPorCompletar]
end

/****** Object:  StoredProcedure [PAT].[C_TodosTablerosMunicipiosPorCompletar]    Script Date: 07-Jun-17 04:33:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [PAT].[C_TodosTablerosMunicipiosPorCompletar]

AS

BEGIN

select 
A.Id,
B.Vigenciainicio,
B.VigenciaFin 
from 
[PAT].[Tablero] A, 
[PAT].[TableroFecha] B
Where A.Id=B.IdTablero
and B.Nivel=2
and A.Activo=1

END
GO

USE [rusicst]
GO

if exists (select * from sys.procedures where name = 'C_Derechos')
begin
drop procedure [PAT].[C_Derechos]
end

/****** Object:  StoredProcedure [PAT].[C_Derechos]    Script Date: 07-Jun-17 06:44:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [PAT].[C_Derechos] ( @idTablero tinyint)

AS

BEGIN

	SELECT 
		D.ID, D.DESCRIPCION
	FROM 
		[PAT].[Derecho] D
	WHERE
		D.ID 
			IN
			(
				SELECT DISTINCT PP.IDDERECHO
				FROM [PAT].[PreguntaPAT] pp
				WHERE PP.IDTABLERO = @idTablero
			)

END

GO

USE [rusicst]
GO

if exists (select * from sys.procedures where name = 'C_TableroVigencia')
begin
drop procedure [PAT].[C_TableroVigencia]
end

/****** Object:  StoredProcedure [PAT].[SP_GetTableroVigencia]    Script Date: 07-Jun-17 07:13:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene el tablero vigente
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroVigencia] 
 (@idTablero tinyint)
AS
BEGIN
	SELECT	YEAR(P.VIGENCIAINICIO) ANNO,
			(CONVERT(VARCHAR(10), P.VIGENCIAINICIO, 103) + ' AL ' + CONVERT(VARCHAR(10), P.VIGENCIAFIN, 103)) VIGENCIA
	FROM [PAT].[Tablero] P
	WHERE	P.ACTIVO =1 
		and P.Id=@idTablero
END


GO

USE [rusicst]
GO

if exists (select * from sys.procedures where name = 'C_TableroFechaActivo')
begin
drop procedure [PAT].[C_TableroFechaActivo]
end


/****** Object:  StoredProcedure [PAT].[C_TableroFechaActivo]    Script Date: 07-Jun-17 07:21:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		23/09/2016
-- Modified date:	
-- Description:		Procedimiento que valida activaci髇 del tablero por fechas
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroFechaActivo]
	@NIVEL TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Cant INT
    	DECLARE @Cantidad INT
    	DECLARE @CantidadDef NVARCHAR(100)

	DECLARE  @SQL NVARCHAR(MAX)
	SET @SQL = 'SELECT
					@Cantidad = COUNT(*)
					FROM [PAT].[TableroFecha] 
					WHERE GETDATE() BETWEEN VIGENCIAINICIO AND VIGENCIAFIN
					AND IDTABLERO = (SELECT ID FROM [PAT].[Tablero] WHERE ACTIVO = 1)
					AND NIVEL = @N AND ACTIVO = 1'
	
	SET @CantidadDef = N'@Cantidad INT OUTPUT,@N TINYINT'
    SET @Cant = 0 
  
    EXECUTE sp_executesql @Sql, @CantidadDef, @Cantidad = @Cant OUTPUT, @N=@NIVEL    
    SELECT @Cant Cantidad
END


GO

USE [rusicst]
GO

if exists (select * from sys.procedures where name = 'C_EntidadByUsuario')
begin
drop procedure [PAT].[C_EntidadByUsuario]
end

/****** Object:  StoredProcedure [PAT].[C_EntidadByUsuario]    Script Date: 07-Jun-17 07:31:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [PAT].[C_EntidadByUsuario] --1  
		@IdUsuario INT
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	ID,
			DESCRIPCION,
			ACTIVO
	FROM PAT.Entidad (NOLOCK)
	WHERE ID = [PAT].[fn_GetIdEntidad](@IdUsuario);

END


GO

---- Corte actualizaci髇 3

USE [rusicst]
GO

if exists (select * from sys.procedures where name = 'C_TableroMunicipio')
begin
drop procedure [PAT].[C_TableroMunicipio]
end


/****** Object:  StoredProcedure [PAT].[C_TableroMunicipio]    Script Date: 08-Jun-17 11:00:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las preguntas para la gesti髇 del tablero PAT
-- =============================================
-- =============================================
-- Author:			Ivan Capera
-- Modified date:	08/07/2017
-- Description:		Ajuste estructura consulta y mejoras para SQL Server 2016
-- =============================================


CREATE PROCEDURE [PAT].[C_TableroMunicipio] --null, 1, 20, 506, 'salud'

 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @busqueda VARCHAR(250), @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		IDPREGUNTA SMALLINT,IDDERECHO SMALLINT,IDCOMPONENTE TINYINT,IDMEDIDA SMALLINT,NIVEL TINYINT,
		PREGUNTAINDICATIVA NVARCHAR(500),IDUNIDADMEDIDA TINYINT,PREGUNTACOMPROMISO NVARCHAR(500),APOYODEPARTAMENTAL BIT,
		APOYOENTIDADNACIONAL BIT,ACTIVO BIT,DERECHO NVARCHAR(50),COMPONENTE NVARCHAR(100),MEDIDA NVARCHAR(50),
		UNIDADMEDIDA NVARCHAR(100),IDTABLERO TINYINT,IDENTIDAD INT,ID INT,RESPUESTAINDICATIVA INT,
		RESPUESTACOMPROMISO INT,PRESUPUESTO MONEY,OBSERVACIONNECESIDAD NVARCHAR(1000),ACCIONCOMPROMISO NVARCHAR(1000)
		)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize 

	SET @ORDEN = @sortOrder
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE  @IDENTIDAD INT

	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
	SET @SQL = 'SELECT 	
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO
		FROM (
		SELECT DISTINCT TOP (@TOP) LINEA,
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO
	FROM ( 
    SELECT DISTINCT row_number() OVER (ORDER BY '+ @ORDEN +') AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IDENTIDAD IS NULL THEN @IDENTIDAD ELSE R.IDENTIDAD END AS IDENTIDAD,
						R.ID ,
						R.RespuestaIndicativa, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO
				FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and  R.IDENTIDAD = @IDENTIDAD,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 
					AND 1=pat.ValidarPreguntaRyR(P.IDMEDIDA,@IDENTIDAD) 
					AND D.DESCRIPCION = '''+@busqueda+''''	
	SET @SQL =@SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY LINEA ) AS T'
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IDENTIDAD INT'
		
	PRINT @SQL

	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IDENTIDAD=@IDENTIDAD
	SELECT * from @RESULTADO
END

GO

USE [rusicst]
GO

if exists (select * from sys.procedures where name = 'C_TableroMunicipioRC')
begin
drop procedure [PAT].[C_TableroMunicipioRC]
end

/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioRC1]    Script Date: 08-Jun-17 01:07:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las preguntas para la gesti髇 del tablero PAT de responsabilidad Colectiva	
-- =============================================

CREATE PROCEDURE [PAT].[C_TableroMunicipioRC]-- NULL, 1, 20, 46, 'Reparaci髇 Integral',1
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @busqueda VARCHAR(250), @idTablero tinyint)

AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		LINEA INT,
		IDPREGUNTARC SMALLINT,
		IDDANE INT,
		IDMEDIDA SMALLINT,
		SUJETO NVARCHAR(3000),
		MEDIDARC NVARCHAR(2000),
		MEDIDA NVARCHAR(500),
		IDTABLERO TINYINT,
		IDENTIDAD INT,
		ID INT,
		ACCION NVARCHAR(4000),
		PRESUPUESTO MONEY
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE @IDDANE INT, @IDENTIDAD INT
	
	SELECT @IDDANE= [PAT].[fn_GetDaneMunicipioEntidad](@IdUsuario)
	SELECT @IDENTIDAD =[PAT].[fn_GetIdEntidad](@IdUsuario)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize


	SET @ORDEN = @sortOrder
	IF @ORDEN = '' or @ORDEN is NULL
		SET @ORDEN = 'IDPREGUNTA'

	IF  @busqueda = 'Reparaci髇 Integral'
	BEGIN
		SET @SQL = 'SELECT A.LINEA,
				A.IDPREGUNTA, 
				A.IDDANE,
				A.IDMEDIDA,
				A.SUJETO,
				A.MEDIDARC,
				A.MEDIDA,
				A.IDTABLERO,
				A.IDENTIDAD,
				A.ID,
				A.ACCION,
				A.PRESUPUESTO 
					FROM (SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
							P.ID AS IDPREGUNTA, 
							P.[IdMunicipio] AS IDDANE, 
							P.IDMEDIDA, 
							P.SUJETO, 
							P.[MedidaReparacionColectiva] AS MEDIDARC, 
							M.DESCRIPCION AS MEDIDA, 
							T.ID AS IDTABLERO,
							CASE WHEN R.IDENTIDAD IS NULL THEN @IDENTIDAD ELSE R.IDENTIDAD END AS IDENTIDAD,
							R.ID,
							R.ACCION, 
							R.PRESUPUESTO
						FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
							LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] AS R ON P.ID= R.[IdPreguntaPATReparacionColectiva] AND R.[IdEntidad] = @IDENTIDAD,
							[PAT].[Medida] M,
							[PAT].[Tablero] T
						WHERE	P.IDMEDIDA = M.ID 
							AND P.[IdMunicipio] = @IDDANE
							AND P.IDTABLERO = T.ID
							AND T.ID = @idTablero'
		SET @SQL =@SQL +') AS A WHERE A.LINEA >@PAGINA  AND A.IDPREGUNTA > 2242 ORDER BY A.LINEA ASC'-- AND IDPREGUNTA > 2242
		SET @PARAMETROS = '@TOP INT, @PAGINA INT,@idTablero tinyint,@IDENTIDAD INT,@IDDANE INT'

		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @idTablero=@idTablero, @IDENTIDAD=@IDENTIDAD,@IDDANE=@IDDANE
	END
	SELECT * from @RESULTADO
END



GO

USE [rusicst]
GO

if exists (select * from sys.procedures where name = 'C_TableroMunicipioRR')
begin
drop procedure [PAT].[C_TableroMunicipioRR]
end

/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioRR]    Script Date: 09-Jun-17 11:44:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las preguntas para la gesti髇 del tablero PAT de responsabilidad Colectiva	
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroMunicipioRR] --'', 1, 20, 394, 'Reparaci髇 Integral'
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @busqueda VARCHAR(250), @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		LINEA INT,
		ID_PREGUNTA_RR SMALLINT,
		ID_DANE INT,
		HOGARES SMALLINT,
		PERSONAS SMALLINT,
		SECTOR NVARCHAR(MAX),
		COMPONENTE NVARCHAR(MAX),
		COMUNIDAD NVARCHAR(MAX),
		UBICACION NVARCHAR(MAX),
		MEDIDA_RR NVARCHAR(MAX),
		INDICADOR_RR NVARCHAR(MAX),
		ENTIDAD_RESPONSABLE NVARCHAR(MAX),
		ID_TABLERO TINYINT,
		ID_ENTIDAD INT,
		ID INT,
		ACCION NVARCHAR(1000),
		PRESUPUESTO MONEY
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE @ID_ENTIDAD INT
	DECLARE @ID_DANE INT
		
	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize

	SET @ORDEN = @sortOrder
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'ID_PREGUNTA'

	SELECT @ID_ENTIDAD=PAT.fn_GetIdEntidad(@IdUsuario)
	SELECT @ID_DANE=[PAT].[fn_GetDaneMunicipioEntidad](@IdUsuario)
	IF  @busqueda = 'Reparaci髇 Integral'
	BEGIN
		SET @SQL = 'SELECT	LINEA,IDPREGUNTA,IDDANE,HOGARES,PERSONAS,SECTOR, 
							COMPONENTE, COMUNIDAD, UBICACION, MEDIDARR, INDICADORRR, 
							ENTIDADRESPONSABLE, IDTABLERO,IDENTIDAD,ID,ACCION,PRESUPUESTO 
					FROM (
							SELECT DISTINCT TOP (@TOP) LINEA,IDPREGUNTA,IDDANE,HOGARES,PERSONAS,SECTOR, 
							COMPONENTE,COMUNIDAD,UBICACION,MEDIDARR,INDICADORRR, 
							ENTIDADRESPONSABLE,IDTABLERO,IDENTIDAD,ID,ACCION,PRESUPUESTO
					FROM ( 
							SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
							P.ID AS IDPREGUNTA,
							P.[IdMunicipio] AS IDDANE,
							P.[HOGARES],
							P.[PERSONAS],
							P.[SECTOR],
							P.[COMPONENTE],
							P.[COMUNIDAD],
							P.[UBICACION],
							P.[MedidaRetornoReubicacion] AS MEDIDARR,
							P.[IndicadorRetornoReubicacion] AS INDICADORRR,
							P.[ENTIDADRESPONSABLE], 
							T.ID AS IDTABLERO,
							CASE WHEN R.IDENTIDAD IS NULL THEN @ID_ENTIDAD ELSE R.IDENTIDAD END AS IDENTIDAD,
							R.ID,
							R.ACCION, 
							R.PRESUPUESTO
					FROM   [PAT].[PreguntaPATRetornosReubicaciones] P
					INNER JOIN [PAT].[Tablero] T ON P.[IdTablero] = T.ID
					LEFT OUTER JOIN [PAT].[RespuestaPATRetornosReubicaciones] R ON R.IDENTIDAD = @ID_ENTIDAD and p.ID = R.[IdPreguntaPATRetornoReubicacion]
					WHERE  T.ID = @idTablero and P.[IdMunicipio] = @ID_DANE'
		SET @SQL =@SQL +' ) AS A WHERE A.LINEA >@PAGINA ORDER BY A.LINEA ) as F'
		SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT,@idTablero tinyint, @ID_DANE INT, @ID_ENTIDAD INT'

--		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero,@ID_DANE=@ID_DANE, @ID_ENTIDAD= @ID_ENTIDAD
	END
	SELECT * from @RESULTADO
END



GO

---- Corte Actualizaci髇 PAT 4

USE [rusicst]
GO

IF EXISTS (select * from sys.procedures where name = 'C_NecesidadesIdentificadas')
begin
drop procedure [PAT].[C_NecesidadesIdentificadas]
end

/****** Object:  StoredProcedure [PAT].[C_NecesidadesIdentificadas]    Script Date: 09-Jun-17 09:29:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las necesidades identificadas del municipio acorde con la pregunta del PAT
-- =============================================
CREATE procedure [PAT].[C_NecesidadesIdentificadas] --103, 109
	@USUARIO INT,
	@PREGUNTA SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Cant INT
    DECLARE @Cantidad INT
    DECLARE @CantidadDef NVARCHAR(100)

	DECLARE  @SQL NVARCHAR(MAX)

	SET @SQL = 'SELECT
				@Cantidad = COUNT(1)
				FROM
					(
						SELECT DISTINCT
							A.*
						FROM
							[PAT].[PrecargueSIGO] A
						WHERE--[PAT].[fn_GetDaneMunicipioEntidad]
							A.[CodigoDane] = [PAT].[fn_GetDaneMunicipioEntidad](@USUARIO)
					'
	IF @PREGUNTA = 108
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Solicita asistencia funeraria'''
	ELSE IF @PREGUNTA IN (111, 112)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere acceso a educaci贸n b谩sica o media'''
	ELSE IF @PREGUNTA = 113
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto requiere acceso a educaci贸n b谩sica o media'''
	ELSE IF @PREGUNTA IN (110, 163)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere cuidado inicial'''
	ELSE IF @PREGUNTA = 170
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Mejoramiento vivienda'''
	ELSE IF @PREGUNTA = 171
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Vivienda nueva'''
	ELSE IF @PREGUNTA = 146
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Requiere acceso a Educaci贸n Gitano Rom - Ind铆gena'''
	ELSE IF @PREGUNTA = 148
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Documento de identidad'''
	ELSE IF @PREGUNTA = 149
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Libreta militar'''
	ELSE IF @PREGUNTA = 141
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere acceso a programas regulares de alimentaci贸n'''
	ELSE IF @PREGUNTA IN (140, 142)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto requiere acceso a programas regulares de alimentaci贸n'''
	ELSE IF @PREGUNTA IN (144, 145)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Madre gestante o lactante requiere apoyo alimentario'''
	ELSE IF @PREGUNTA = 127
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto solicita reunificaci贸n familiar'''
	ELSE IF @PREGUNTA = 128
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Afiliaci贸n al SGSSS'''
	ELSE IF @PREGUNTA = 139
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Requiere acceso a programa j贸venes en acci贸n'''
	ELSE IF @PREGUNTA IN (120, 121)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Apoyo a nuevos emprendimientos'''
	ELSE IF @PREGUNTA IN (122, 123)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Fortalecimiento de negocios'''
	ELSE IF @PREGUNTA IN (124, 125)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Empleabilidad'''
	ELSE IF @PREGUNTA = 126
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor solicita reunificaci贸n familiar'''
	ELSE IF @PREGUNTA = 152
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Atenci贸n psicosocial'''
	ELSE IF @PREGUNTA IN (116, 117)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Orientaci贸n ocupacional'''
	ELSE IF @PREGUNTA IN (118, 119)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Educaci贸n y/o orientaci贸n para el trabajo'''
	ELSE
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''ninguna'''
	--SET @SQL = 'SELECT
	--				@Cantidad = COUNT(1)
	--			FROM
	--				(
	--				SELECT
	--						DISTINCT C.TIPO_DOCUMENTO,C.NUMERO_DOCUMENTO,C.ID_MEDIDA,C.ID_NECESIDAD
	--				from	DBO.TB_CARGUE C 
	--				INNER JOIN	DBO.TB_LOTE L ON C.ID_LOTE = L.ID
	--				INNER JOIN	DBO.Entidad E ON C.DANE_MUNICIPIO = E.ID_MUNICIPIO
	--				INNER JOIN	PAT.Pregunta P ON P.ID_MEDIDA = C.ID_MEDIDA
	--				WHERE	L.ID_ESTADO = 3	
	--				AND		E.ID = PAT.GetIdEntidad(@USUARIO)
	--				AND		P.ID  = @PREGUNTA '

	---- MEDIDA IDENTIFICACI覰
	--IF @PREGUNTA = 1
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 6'
	--IF @PREGUNTA = 2
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 7 AND 17'
	--IF @PREGUNTA = 3
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >= 18'

	---- MEDIDA SALUD
	--IF @PREGUNTA = 5
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'

	---- MEDIDA REHABILITACI覰 PSICOSOCIAL


	---- MEDIDA EDUCACI覰
	--IF @PREGUNTA = 7
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 6 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 5'
	--IF @PREGUNTA = 8
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
	--IF @PREGUNTA = 9
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
	--IF @PREGUNTA = 10
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'

	---- MEDIDA GENERACION DE INGRESOS
	--IF @PREGUNTA = 11
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 12
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 13
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 14
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 15
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 5'
	--IF @PREGUNTA = 16
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 5'
	--IF @PREGUNTA = 17
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 4'
	--IF @PREGUNTA = 18
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 4'
	--IF @PREGUNTA = 19
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD in (3,8)'
	--IF @PREGUNTA = 20
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD in (3,8)'

	---- MEDIDA SEGURIDAD ALIMENTARIA
	--IF @PREGUNTA = 21
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 5'
	--IF @PREGUNTA = 22
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
	--IF @PREGUNTA = 23
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'
	--IF @PREGUNTA = 24 
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 25
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'

	---- MEDIDA REUNIFICACI覰 FAMILIAR
	--IF @PREGUNTA = 26
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 17'
	--IF @PREGUNTA = 27
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'

	---- MEDIDA VIVIENDA
	--IF @PREGUNTA = 28
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 29
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 30
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 31
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 32
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 33
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 34
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 35
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 36
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	
	---- MEDIDA ASISTENCIA FUNERARIA
	--IF @PREGUNTA = 37
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 38
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'

	SET @SQL = @SQL + ')P' 
	
	SET @CantidadDef = N'@Cantidad INT OUTPUT,@USUARIO INT'
    SET @Cant = 0 

	print @SQL
  
    EXECUTE sp_executesql @Sql, @CantidadDef, @Cantidad = @Cant OUTPUT, @USUARIO = @USUARIO     
    SELECT @Cant Cantidad
END 

GO



GO

IF EXISTS (select * from sys.procedures where name = 'C_AccionesPAT')
begin
drop procedure [PAT].[C_AccionesPAT]
end

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las acciones compromisos de la gesti髇 municipal del PAT en Responsbilidad Colectiva
-- =============================================
CREATE PROCEDURE [PAT].[C_AccionesPAT]--,'RC'--1,'RR'--1,''
( 
	@ID as INT	, @OPCION VARCHAR(2)
)
AS
BEGIN
	SET NOCOUNT ON;	

	IF @OPCION = '' OR @OPCION IS NULL
	BEGIN	
	SELECT	A.ACCION ,A.ID
		FROM	[PAT].[RespuestaPAT] (NOLOCK) AS R
		JOIN	[PAT].[RespuestaPATAccion] (NOLOCK) AS A ON R.ID = A.[IdRespuestaPAT]
		WHERE	A.ACTIVO = 1 AND R.ID = @ID
	END
	IF @OPCION = 'RC' 
	BEGIN		
		SELECT	A.[AccionReparacionColectiva] AS ACCION ,A.ID
		FROM	[PAT].[RespuestaPATReparacionColectiva] (NOLOCK) AS R
		JOIN	[PAT].[RespuestaPATAccionReparacionColectiva] (NOLOCK) AS A ON R.ID = A.[IdRespuestaPATReparacionColectiva]
		WHERE	A.ACTIVO = 1 AND R.ID = @ID
	END
	IF @OPCION = 'RR' 
	BEGIN	
		SELECT	A.[IdRespuestaPATRetornoReubicacion] AS ACCION ,A.ID
		FROM	[PAT].[RespuestaPATReparacionColectiva] (NOLOCK) AS R
		JOIN	[PAT].[RespuestaPATAccionRetornosReubicaciones] (NOLOCK) AS A ON R.ID = A.[IdRespuestaPATRetornoReubicacion]
		WHERE	A.ACTIVO = 1 AND R.ID = @ID
	END

END




GO

USE [rusicst]
GO

IF EXISTS (select * from sys.procedures where name = 'C_ProgramasPAT')
begin
drop procedure [PAT].[C_ProgramasPAT]
end

/****** Object:  StoredProcedure [PAT].[C_ProgramasPAT]    Script Date: 09-Jun-17 10:06:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene los programas de Oferta cargados en el PAT
-- =============================================
CREATE PROCEDURE [PAT].[C_ProgramasPAT]( 
	@ID as INT	
)
AS
BEGIN
	SET NOCOUNT ON;	

	SELECT	P.PROGRAMA,P.ID
	FROM	[PAT].[RespuestaPAT] (NOLOCK) AS R,
			[PAT].[RespuestaPATPrograma] (NOLOCK) AS P
	WHERE	R.ID = P.[IdRespuestaPAT] AND P.ACTIVO = 1 AND R.ID = @ID
END



GO


if exists (select * from sys.columns where name='FechaModificacion' and Object_id in (select object_id from sys.tables where name ='RespuestaPAT'))
begin
	alter table [PAT].[RespuestaPAT] drop column [FechaModificacion]	
end
	ALTER TABLE [PAT].[RespuestaPAT] add FechaModificacion date

GO

if exists (select * from sys.columns where name='FechaInsercion' and Object_id in (select object_id from sys.tables where name ='RespuestaPAT'))
begin
	alter table [PAT].[RespuestaPAT] drop column [FechaInsercion]	
end
	ALTER TABLE [PAT].[RespuestaPAT] add FechaInsercion date

if exists (select * from sys.columns where name='IdUsuario' and Object_id in (select object_id from sys.tables where name ='RespuestaPAT'))
begin
	alter table [PAT].[RespuestaPAT] drop column [IdUsuario]	
end
	ALTER TABLE [PAT].[RespuestaPAT] add IdUsuario int

GO

USE [rusicst]
GO

IF EXISTS (select * from sys.procedures where name = 'U_RespuestaAccionesUpdate')
begin
drop procedure [PAT].[U_RespuestaAccionesUpdate]
end

/****** Object:  StoredProcedure [PAT].[U_RespuestaAccionesUpdate]    Script Date: 09-Jun-17 10:48:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaAccionesUpdate] 
		@ID int,
		@IDPATRESPUESTA int,
        @ACCION nvarchar(500),
        @ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATAccion]
			SET [IdRespuestaPAT] = @IDPATRESPUESTA
			,[ACCION] = @ACCION
			,[ACTIVO] = @ACTIVO
			 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado
		
GO

USE [rusicst]
GO

IF EXISTS (select * from sys.procedures where name = 'I_RespuestaAccionesInsert')
begin
drop procedure [PAT].[I_RespuestaAccionesInsert]
end

/****** Object:  StoredProcedure [PAT].[I_RespuestaAccionesInsert]    Script Date: 09-Jun-17 10:53:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaAccionesInsert] 
           @IDPATRESPUESTA int,
           @ACCION nvarchar(500),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATAccion]
           ([IdRespuestaPAT]
           ,[ACCION]
           ,[ACTIVO])
			VALUES
           (@IDPATRESPUESTA,
            @ACCION, 
            @ACTIVO)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		
GO

USE [rusicst]
GO

IF EXISTS (select * from sys.procedures where name = 'U_RespuestaProgramaUpdate')
begin
drop procedure [PAT].[U_RespuestaProgramaUpdate]
end

/****** Object:  StoredProcedure [PAT].[U_RespuestaProgramaUpdate]    Script Date: 09-Jun-17 10:57:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaProgramaUpdate] 
		@ID int,
		@ID_PAT_RESPUESTA int,
		@PROGRAMA nvarchar(1000),
		@ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATPrograma]
			SET [IdRespuestaPAT] = @ID_PAT_RESPUESTA,
			    [PROGRAMA] = @PROGRAMA,
			    [ACTIVO] = @ACTIVO
			WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado
		
GO

USE [rusicst]
GO

IF EXISTS (select * from sys.procedures where name = 'I_RespuestaProgramaInsert')
begin
drop procedure [PAT].[I_RespuestaProgramaInsert]
end

/****** Object:  StoredProcedure [PAT].[I_RespuestaProgramaInsert]    Script Date: 09-Jun-17 11:00:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaProgramaInsert] 
           @ID_PAT_RESPUESTA int,
           @PROGRAMA nvarchar(1000),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATPrograma]
           ([IdRespuestaPAT]
           ,[PROGRAMA]
           ,[ACTIVO])
			VALUES
           (@ID_PAT_RESPUESTA,
            @PROGRAMA, 
            @ACTIVO)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		
GO

------ Corte 5 y 6 PAT

USE [rusicst]

GO

if exists (select * from sys.columns where name='FechaModificacion' and Object_id in (select object_id from sys.tables where name ='RespuestaPATReparacionColectiva'))
begin
	alter table [PAT].[RespuestaPATReparacionColectiva] drop column [FechaModificacion]	
end
Alter table PAT.RespuestaPATReparacionColectiva add FechaModificacion date null

if exists (select * from sys.columns where name='FechaInsercion' and Object_id in (select object_id from sys.tables where name ='RespuestaPATReparacionColectiva'))
begin
	alter table [PAT].[RespuestaPATReparacionColectiva] drop column [FechaInsercion]	
end
Alter table PAT.RespuestaPATReparacionColectiva add FechaInsercion date null

if exists (select * from sys.columns where name='IdUsuario' and Object_id in (select object_id from sys.tables where name ='RespuestaPATReparacionColectiva'))
begin
	alter table [PAT].[RespuestaPATReparacionColectiva] drop column [IdUsuario]	
end
Alter table PAT.RespuestaPATReparacionColectiva add IdUsuario int null

if exists (select * from sys.columns where name='FechaModificacion' and Object_id in (select object_id from sys.tables where name ='RespuestaPATRetornosReubicaciones'))
begin
	alter table [PAT].[RespuestaPATRetornosReubicaciones] drop column [FechaModificacion]	
end
Alter table [PAT].[RespuestaPATRetornosReubicaciones] add FechaModificacion date null

if exists (select * from sys.columns where name='FechaInsercion' and Object_id in (select object_id from sys.tables where name ='RespuestaPATRetornosReubicaciones'))
begin
	alter table [PAT].[RespuestaPATRetornosReubicaciones] drop column [FechaInsercion]	
end
Alter table [PAT].[RespuestaPATRetornosReubicaciones] add FechaInsercion date null

if exists (select * from sys.columns where name='IdUsuario' and Object_id in (select object_id from sys.tables where name ='RespuestaPATRetornosReubicaciones'))
begin
	alter table [PAT].[RespuestaPATRetornosReubicaciones] drop column [IdUsuario]	
end
Alter table [PAT].[RespuestaPATRetornosReubicaciones] add IdUsuario int null

GO

USE [rusicst]
GO

IF EXISTS (select * from sys.procedures where name = 'U_RespuestaAccionesRCUpdate')
begin
drop procedure [PAT].[U_RespuestaAccionesRCUpdate]
end

/****** Object:  StoredProcedure [PAT].[U_RespuestaAccionesRCUpdate]    Script Date: 10-Jun-17 12:48:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaAccionesRCUpdate] 
		@ID int,
		@IDPATRESPUESTA int,
        @ACCION nvarchar(500),
        @ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATAccionReparacionColectiva]
			SET [IdRespuestaPATReparacionColectiva] = @IDPATRESPUESTA
			,[AccionReparacionColectiva] = @ACCION
			,[ACTIVO] = @ACTIVO
			 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado
		
	
GO

USE [rusicst]
GO

IF EXISTS (select * from sys.procedures where name = 'I_RespuestaAccionesInsert')
begin
drop procedure [PAT].[I_RespuestaAccionesInsert]
end

/****** Object:  StoredProcedure [PAT].[I_RespuestaAccionesInsert]    Script Date: 10-Jun-17 12:55:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaAccionesInsert] 
           @IDPATRESPUESTA int,
           @ACCION nvarchar(500),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATAccion]
           ([IdRespuestaPAT]
           ,[ACCION]
           ,[ACTIVO])
			VALUES
           (@IDPATRESPUESTA,
            @ACCION, 
            @ACTIVO)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		
GO

USE [rusicst]
GO

IF EXISTS (select * from sys.procedures where name = 'U_RespuestaAccionesRRUpdate')
begin
drop procedure [PAT].[U_RespuestaAccionesRRUpdate]
end

/****** Object:  StoredProcedure [PAT].[U_RespuestaAccionesRRUpdate]    Script Date: 10-Jun-17 01:15:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaAccionesRRUpdate] 
		@ID int,
		@IDPATRESPUESTA int,
        @ACCION nvarchar(500),
        @ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATAccionRetornosReubicaciones]
			SET [IdRespuestaPATRetornoReubicacion] = @IDPATRESPUESTA
			,[AccionRetornoReubicacion] = @ACCION
			,[ACTIVO] = @ACTIVO
			 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado
		
GO

USE [rusicst]
GO

IF EXISTS (select * from sys.procedures where name = 'I_RespuestaAccionesRRInsert')
begin
drop procedure [PAT].[I_RespuestaAccionesRRInsert]
end

/****** Object:  StoredProcedure [PAT].[I_RespuestaAccionesRRInsert]    Script Date: 10-Jun-17 01:21:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaAccionesRRInsert] 
           @IDPATRESPUESTA int,
           @ACCION nvarchar(500),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATAccionRetornosReubicaciones]
           ([IdRespuestaPATRetornoReubicacion]
           ,[AccionRetornoReubicacion]
           ,[ACTIVO])
			VALUES
           (@IDPATRESPUESTA,
            @ACCION, 
            @ACTIVO)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		
GO

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO

if exists (select * from sys.columns where name='IdTablero' and Object_id in (select object_id from sys.tables where name ='RespuestaPATReparacionColectiva'))
begin
	if exists (select * from sysindexes where name = 'IDX_RespuestaPATReparacionColectiva_Tablero')
	begin
		DROP INDEX IDX_RespuestaPATReparacionColectiva_Tablero ON [PAT].[RespuestaPATReparacionColectiva]  	
	end
	ALTER TABLE [PAT].[RespuestaPATReparacionColectiva] DROP CONSTRAINT [FK_RespuestaPATReparacionColectiva_Tablero]
	alter table [PAT].[RespuestaPATReparacionColectiva] drop column [IdTablero]	
end

GO
ALTER TABLE PAT.Tablero SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO

if exists (select * from sys.columns where name='IdTablero' and Object_id in (select object_id from sys.tables where name ='RespuestaPATRetornosReubicaciones'))
begin
	if exists (select * from sysindexes where name = 'IDX_RespuestaPATRetornosReubicaciones_Tablero')
	begin
		DROP INDEX IDX_RespuestaPATRetornosReubicaciones_Tablero ON [PAT].[RespuestaPATRetornosReubicaciones]  	
	end
	if exists (select * from sys.foreign_keys where name = 'FK_RespuestaPATRetornosReubicaciones_Tablero')
	begin
		ALTER TABLE [PAT].[RespuestaPATRetornosReubicaciones] DROP CONSTRAINT [FK_RespuestaPATRetornosReubicaciones_Tablero]	
	end
	alter table [PAT].[RespuestaPATRetornosReubicaciones] drop column [IdTablero]	
end

GO
ALTER TABLE PAT.RespuestaPATRetornosReubicaciones SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
GO

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
-----------------------------------------------------------------------------------------------------------
--SE AGREGA EL UPDATE PARA QUE SE GUARDE EL IDMUNICIPIO CON BASE A LA ENTIDAD ANTES DE QUITAR EL CAMPO
-----------------------------------------------------------------------------------------------------------

UPDATE pat.RespuestaPAT SET IdMunicipio = E.IdMunicipio
from pat.RespuestaPAT rr 
JOIN PAT.Entidad AS E ON rr.IdEntidad = E.Id


UPDATE pat.RespuestaPAT SET IdUsuario = U.Id
from pat.RespuestaPAT rr 
JOIN PAT.Entidad AS E ON rr.IdEntidad = E.Id
jOIN Usuario AS U ON E.IdMunicipio = U.IdMunicipio AND U.Activo=1 AND IdEstado = 5


GO

if exists (select * from sys.columns where name='IdEntidad' and Object_id in (select object_id from sys.tables where name ='RespuestaPAT'))
begin
	if exists (select * from sysindexes where name = 'IDX_RespuestaPAT_Entidad')
	begin
		DROP INDEX IDX_RespuestaPAT_Entidad ON [PAT].[RespuestaPAT] 
	end
	if exists (SELECT * FROM SYS.foreign_keys where name = 'FK_RespuestaPAT_Entidad')
	begin
		ALTER TABLE [PAT].[RespuestaPAT] DROP CONSTRAINT [FK_RespuestaPAT_Entidad]
	end
	ALTER TABLE [PAT].[RespuestaPAT] drop column [IdEntidad]	
end

GO
ALTER TABLE PAT.RespuestaPAT SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
-----------------------------------------

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO

if exists (select * from sys.columns where name='IdEntidad' and Object_id in (select object_id from sys.tables where name ='RespuestaPATReparacionColectiva'))
begin
	if exists (select * from sysindexes where name = 'IDX_RespuestaPATReparacionColectiva_Entidad')
	begin
		DROP INDEX IDX_RespuestaPATReparacionColectiva_Entidad ON [PAT].[RespuestaPATReparacionColectiva] 
	end
	if exists (SELECT * FROM SYS.foreign_keys where name = 'FK_RespuestaPATReparacionColectiva_Entidad')
	begin
		ALTER TABLE [PAT].[RespuestaPATReparacionColectiva] DROP CONSTRAINT [FK_RespuestaPATReparacionColectiva_Entidad]
	end
	ALTER TABLE [PAT].[RespuestaPATReparacionColectiva] drop column [IdEntidad]	
end

GO
ALTER TABLE PAT.RespuestaPATReparacionColectiva SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

GO
---------------------------------

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO

if exists (select * from sys.columns where name='IdEntidad' and Object_id in (select object_id from sys.tables where name ='RespuestaPATRetornosReubicaciones'))
begin
	if exists (select * from sysindexes where name = 'IDX_RespuestaPATRetornosReubicaciones_Entidad')
	begin
		DROP INDEX IDX_RespuestaPATRetornosReubicaciones_Entidad ON [PAT].[RespuestaPATRetornosReubicaciones] 
	end
	if exists (SELECT * FROM SYS.foreign_keys where name = 'FK_RespuestaPATRetornosReubicaciones_Entidad')
	begin
		ALTER TABLE [PAT].[RespuestaPATRetornosReubicaciones] DROP CONSTRAINT [FK_RespuestaPATRetornosReubicaciones_Entidad]
	end
	ALTER TABLE [PAT].[RespuestaPATRetornosReubicaciones] drop column [IdEntidad]	
end

GO
ALTER TABLE PAT.RespuestaPATRetornosReubicaciones SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


go

go

	---------------------------------

	/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Municipio SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION

if not exists (select * from sys.columns where name='IdMunicipio' and Object_id in (select object_id from sys.tables where name ='RespuestaPAT'))
begin
	ALTER TABLE PAT.RespuestaPAT ADD IdMunicipio int NULL
	if not exists (SELECT * FROM SYS.foreign_keys where name = 'FK_RespuestaPAT_Municipio')
	begin
		ALTER TABLE PAT.RespuestaPAT ADD CONSTRAINT FK_RespuestaPAT_Municipio FOREIGN KEY
		(IdMunicipio) REFERENCES dbo.Municipio (Id) ON UPDATE NO ACTION ON DELETE NO ACTION 
	end
end

GO
ALTER TABLE PAT.RespuestaPAT SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
-------------------------
go
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Municipio SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO

if not exists (select * from sys.columns where name='IdMunicipio' and Object_id in (select object_id from sys.tables where name ='RespuestaPATReparacionColectiva'))
begin
	ALTER TABLE PAT.RespuestaPATReparacionColectiva ADD IdMunicipio int NULL
	if not exists (SELECT * FROM SYS.foreign_keys where name = 'FK_RespuestaPATReparacionColectiva_Municipio')
	begin
	ALTER TABLE PAT.RespuestaPATReparacionColectiva ADD CONSTRAINT FK_RespuestaPATReparacionColectiva_Municipio FOREIGN KEY
	(IdMunicipio) REFERENCES dbo.Municipio (Id) ON UPDATE  NO ACTION  ON DELETE  NO ACTION
	end
end
	
GO
ALTER TABLE PAT.RespuestaPATReparacionColectiva SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

go
-----------------------------------

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Municipio SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO

if not exists (select * from sys.columns where name='IdMunicipio' and Object_id in (select object_id from sys.tables where name ='RespuestaPATRetornosReubicaciones'))
begin
	ALTER TABLE PAT.RespuestaPATRetornosReubicaciones ADD IdMunicipio int NULL
	if not exists (SELECT * FROM SYS.foreign_keys where name = 'FK_RespuestaPATRetornosReubicaciones_Municipio')
	begin
	ALTER TABLE PAT.RespuestaPATRetornosReubicaciones ADD CONSTRAINT FK_RespuestaPATRetornosReubicaciones_Municipio FOREIGN KEY
	(IdMunicipio) REFERENCES dbo.Municipio (Id) ON UPDATE  NO ACTION  ON DELETE  NO ACTION 
	end
end
	
GO
ALTER TABLE PAT.RespuestaPATRetornosReubicaciones SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
GO

USE [rusicst]
GO
/****** Object:  UserDefinedFunction [PAT].[fn_GetIdEntidad]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------------------
if exists (select * from sys.procedures where name = 'C_EntidadByUsuario')
begin
	drop procedure [PAT].[C_EntidadByUsuario]
end

GO

if exists (select * from sys.objects where name = 'fn_GetDaneMunicipioEntidad')
begin
	DROP FUNCTION PAT.fn_GetDaneMunicipioEntidad
end 

GO

if exists (select * from sys.objects where name = 'fn_GetDaneMunicipioEntidadRR')
begin
	DROP FUNCTION [PAT].[fn_GetDaneMunicipioEntidadRR] 
end 

GO

if exists (select * from sys.objects where name = 'fn_ValidarPreguntaRyR')
begin
	DROP FUNCTION [PAT].[fn_ValidarPreguntaRyR]
end 

GO

if exists (select * from sys.objects where name = 'fn_GetIdEntidad')
begin
	DROP FUNCTION [PAT].[fn_GetIdEntidad]
end 

GO

-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		10/06/2016
-- Modified date:	
-- Description:		Funcion que retorna el Id de la Entidad a traves del idusuario
-- =============================================
CREATE FUNCTION [PAT].[fn_GetIdEntidad] (
	@ID INT
)
RETURNS INT
AS
BEGIN	
	DECLARE @RETURN  INT
	/*
	SELECT @RETURN = ID_ENTIDAD
	FROM TB_USUARIO (NOLOCK) U
	WHERE ID = @ID
	*/ --- Codigo anterior se modifica bajo la nueva estructura de PAT - Icapera 07072017
	
	SELECT @RETURN =  U.[IdMunicipio]
	FROM [dbo].[Usuario] (NOLOCK) U
	WHERE U.ID = @ID
	RETURN @RETURN
END

GO

if exists (select * from sys.objects where name = 'ValidarPreguntaRyR')
begin
	DROP FUNCTION [PAT].[ValidarPreguntaRyR]
end 

GO


GO
/****** Object:  UserDefinedFunction [PAT].[ValidarPreguntaRyR]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [PAT].[ValidarPreguntaRyR]
(
	@MEDIDA SMALLINT,
	@IDMUNICIPIO INT
)
RETURNS INT
AS
BEGIN	
	DECLARE @RESULTADO INT=1
	IF @MEDIDA = 15
	BEGIN
		/* --- Se hace el cambo debido a que las nuevas estructuras de tablas no corresponden a la sentencia -- Icapera 07072017
		SELECT @RESULTADO = COUNT(*) 
		FROM [PAT].[TB_EntidadControl] EC
		INNER JOIN PAT.TB_DANE D ON EC.ID_DANE = D.ID_DANE
		INNER JOIN PAT.TB_ENTIDAD E ON E.ID_MUNICIPIO = D.ID
		WHERE E.ID = @ENTIDAD
		*/
		SELECT @RESULTADO = COUNT(*) 
		FROM [PAT].[EntidadControl] EC
		WHERE EC.[IdMunicipio] = @IDMUNICIPIO
	END
	RETURN @RESULTADO
END

GO
/****** Object:  StoredProcedure [PAT].[C_AccionesPAT]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_AccionesPAT')
begin
drop procedure [PAT].[C_AccionesPAT]
end

GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las acciones compromisos de la gesti髇 municipal del PAT en Responsbilidad Colectiva
-- =============================================
CREATE PROCEDURE [PAT].[C_AccionesPAT]--,'RC'--1,'RR'--1,''
( 
	@ID as INT	, @OPCION VARCHAR(2)
)
AS
BEGIN
	SET NOCOUNT ON;	

	IF @OPCION = '' OR @OPCION IS NULL
	BEGIN	
	SELECT	A.ACCION ,A.ID
		FROM	[PAT].[RespuestaPAT] (NOLOCK) AS R
		JOIN	[PAT].[RespuestaPATAccion] (NOLOCK) AS A ON R.ID = A.[IdRespuestaPAT]
		WHERE	A.ACTIVO = 1 AND R.ID = @ID
	END
	IF @OPCION = 'RC' 
	BEGIN		
		SELECT	A.[AccionReparacionColectiva] AS ACCION ,A.ID
		FROM	[PAT].[RespuestaPATReparacionColectiva] (NOLOCK) AS R
		JOIN	[PAT].[RespuestaPATAccionReparacionColectiva] (NOLOCK) AS A ON R.ID = A.[IdRespuestaPATReparacionColectiva]
		WHERE	A.ACTIVO = 1 AND R.ID = @ID
	END
	IF @OPCION = 'RR' 
	BEGIN	
		SELECT	A.[AccionRetornoReubicacion] AS ACCION ,A.ID
		FROM	[PAT].[RespuestaPATRetornosReubicaciones] (NOLOCK) AS R
		JOIN	[PAT].[RespuestaPATAccionRetornosReubicaciones] (NOLOCK) AS A ON R.ID = A.[IdRespuestaPATRetornoReubicacion]
		WHERE	A.ACTIVO = 1 AND R.ID = @ID
	END

END


GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroMunicipio]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_ContarTableroMunicipio')
begin
drop procedure [PAT].[C_ContarTableroMunicipio]
end

GO
-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		22/08/2016
-- Modified date:	
-- Description:		Cuenta todas las preguntas del Tablero para paginacion
-- =============================================
-- =============================================
-- Author:			Iv醤 Capera
-- Modified date:	08-07-2017
-- Description:		Ajuste de consulta para contemplar mejoras para SQL Server 2016.
-- =============================================
CREATE PROCEDURE [PAT].[C_ContarTableroMunicipio] --506, 'Salud',2
(@IdUsuario INT, @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @Cantidad INT, @ID_ENTIDAD INT

	SELECT @ID_ENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)

	SELECT @Cantidad = COUNT(1)
	FROM ( 
		     SELECT DISTINCT  
						P.ID AS ID_PREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDAD_MEDIDA,	
						T.ID AS ID_TABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @ID_ENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID ,
						R.RESPUESTAINDICATIVA, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO
		FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdMunicipio =  @ID_ENTIDAD ,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T
		WHERE 
			P.IDDERECHO = D.ID 
			AND P.IDCOMPONENTE = C.ID 
			AND P.IDMEDIDA = M.ID 
			AND P.IDUNIDADMEDIDA = UM.ID 
			AND P.IDTABLERO = T.ID
			AND T.ID = @idTablero 
			AND P.NIVEL = 3 
			AND P.ACTIVO = 1 
			--AND 1=PAT.ValidarPreguntaRyR(P.IDMEDIDA,@ID_ENTIDAD) 
			AND D.Id = @IdDerecho) as P 
	
	SELECT @Cantidad
END

GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroMunicipioRC]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_ContarTableroMunicipioRC')
begin
drop procedure [PAT].[C_ContarTableroMunicipioRC]
end

GO

-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		22/08/2016
-- Modified date:	
-- Description:		Cuenta todas las preguntas del Tablero para paginacion de reparaci髇 colectiva
-- =============================================
CREATE PROCEDURE [PAT].[C_ContarTableroMunicipioRC] --46, ''
(@IdUsuario INT, @idTablero tinyint)

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Cantidad INT, @ID_ENTIDAD INT, @ID_DANE INT

	SELECT @ID_ENTIDAD = pat.fn_GetIdEntidad(@IdUsuario)--, @ID_DANE = PAT.fn_GetDaneMunicipioEntidad(@IdUsuario)
	
	SELECT @Cantidad = COUNT(1)
	FROM ( 
		SELECT	P.ID AS ID_PREGUNTA, 
				P.[IdMunicipio], 
				P.[IdMedida], 
				P.[Sujeto], 
				P.[MedidaReparacionColectiva], 
				M.DESCRIPCION AS MEDIDA, 
				T.ID AS ID_TABLERO,
				CASE WHEN R.IdMunicipio IS NULL THEN @ID_ENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
				R.ID,
				R.ACCION, 
				R.PRESUPUESTO
		FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
		INNER JOIN [PAT].[Medida] M ON P.[IdMedida] = M.ID AND P.[IdMunicipio] = @ID_DANE
		INNER JOIN [PAT].[Tablero] T ON P.[IdTablero] = T.ID
		LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] R ON R.IdMunicipio = @ID_ENTIDAD and P.ID= R.[IdPreguntaPATReparacionColectiva]
		WHERE  T.ID = @idTablero AND P.ID > 2242) AS P--AND P.ID > 2242
	
	SELECT @Cantidad
END



GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroMunicipioRR]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


if exists (select * from sys.procedures where name = 'C_ContarTableroMunicipioRR')
begin
drop procedure [PAT].[C_ContarTableroMunicipioRR]
end

GO

-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		22/08/2016
-- Modified date:	
-- Description:		Cuenta todas las preguntas del Tablero para paginacion de reparaci髇 colectiva
-- =============================================
CREATE PROCEDURE [PAT].[C_ContarTableroMunicipioRR] --506, '', 2
(@IdUsuario INT, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Cantidad INT, @ID_ENTIDAD INT--, @ID_DANE INT

	SELECT @ID_ENTIDAD = pat.fn_GetIdEntidad(@IdUsuario)--, @ID_DANE = PAT.fn_GetDaneMunicipioEntidad(@IdUsuario)

	SELECT @Cantidad = COUNT(1)
	FROM (
	SELECT  
	P.ID AS ID_PREGUNTA
	,P.[IdMunicipio] AS IDDANE
	,P.[HOGARES]
	,P.[PERSONAS]
	,P.[SECTOR]
	,P.[COMPONENTE]
	,P.[COMUNIDAD]
	,P.[UBICACION]
	,P.[MedidaRetornoReubicacion] AS MEDIDARR
	,P.[IndicadorRetornoReubicacion] AS INDICADORRR
	,P.[ENTIDADRESPONSABLE] 
	,T.ID AS ID_TABLERO
	,CASE WHEN R.IdMunicipio IS NULL THEN @ID_ENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
	R.ID,
	R.ACCION, 
	R.PRESUPUESTO
	FROM    [PAT].[PreguntaPATRetornosReubicaciones] P
	INNER JOIN [PAT].[Tablero] T ON P.[IdTablero] = T.ID
	LEFT OUTER JOIN [PAT].[RespuestaPATRetornosReubicaciones] R ON R.IdMunicipio = @ID_ENTIDAD and p.ID = R.[IdPreguntaPATRetornoReubicacion]
	WHERE  T.ID = @idTablero 
	and P.[IdMunicipio] = @ID_ENTIDAD
	) as A
			
	SELECT @Cantidad
END




GO
/****** Object:  StoredProcedure [PAT].[C_DatosExcel_Municipios]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_DatosExcel_Municipios')
begin
drop procedure [PAT].[C_DatosExcel_Municipios]
end

GO

CREATE PROC [PAT].[C_DatosExcel_Municipios] --506, 1
(
	@IdMunicipio INT, @IdTablero INT
)

AS
BEGIN

SELECT 
DISTINCT  
		--ID_PREGUNTA,ID_DERECHO,ID_COMPONENTE,ID_MEDIDA,NIVEL,PREGUNTA_INDICATIVA,ID_UNIDAD_MEDIDA,PREGUNTA_COMPROMISO,APOYO_DEPARTAMENTAL,APOYO_ENTIDAD_NACIONAL,ACTIVO,
		--DERECHO, COMPONENTE,MEDIDA,UNIDAD_MEDIDA,ID_TABLERO,ID_ENTIDAD,id_respuesta,RESPUESTA_INDICATIVA,RESPUESTA_COMPROMISO,PRESUPUESTO,OBSERVACION_NECESIDAD,ACCION_COMPROMISO
LINEA
,IDPREGUNTA AS ID
, '' AS ENTIDAD
,DERECHO
,COMPONENTE
,MEDIDA
,PREGUNTAINDICATIVA
,PREGUNTACOMPROMISO
,UNIDADMEDIDA
,RESPUESTAINDICATIVA
,OBSERVACIONNECESIDAD
,RESPUESTACOMPROMISO
,ACCIONCOMPROMISO AS OBSERVACIONCOMPROMISO
,CONVERT(FLOAT, PRESUPUESTO) AS PRESUPUESTO
,ACCION
,PROGRAMA

	FROM ( 
    SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						R.ID AS IDTABLERO,						
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID as id_respuesta,
						R.RESPUESTAINDICATIVA, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO
						,AA.ACCION
						,AP.PROGRAMA
				FROM    [PAT].[PreguntaPAT] AS P
				INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
				INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
				INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
				INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
				INNER JOIN PAT.Tablero AS T ON P.IDTABLERO = T.ID
				LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] and  R.IdMunicipio = @IdMunicipio											
				LEFT OUTER JOIN [PAT].[RespuestaPATAccion] AS AA ON AA.[IdRespuestaPAT] = R.ID
				LEFT OUTER JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID
				INNER JOIN Usuario AS U ON R.IdUsuario = U.Id  AND U.IdMunicipio = @IdMunicipio
				WHERE  T.ID = @IdTablero and
				P.NIVEL = 3 AND 1=pat.ValidarPreguntaRyR(P.IDMEDIDA,@IdMunicipio) ) AS A WHERE A.ACTIVO = 1  ORDER BY IDPREGUNTA

END


GO
/****** Object:  StoredProcedure [PAT].[C_Derechos]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_Derechos')
begin
drop procedure [PAT].[C_Derechos]
end

GO

CREATE PROC [PAT].[C_Derechos] ( @idTablero tinyint)

AS

BEGIN

	SELECT 
		D.ID, D.DESCRIPCION
	FROM 
		[PAT].[Derecho] D
	WHERE
		D.ID 
			IN
			(
				SELECT DISTINCT PP.IDDERECHO
				FROM [PAT].[PreguntaPAT] pp
				WHERE PP.IDTABLERO = @idTablero
			)

END


GO
/****** Object:  StoredProcedure [PAT].[C_NecesidadesIdentificadas]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_NecesidadesIdentificadas')
begin
drop procedure [PAT].[C_NecesidadesIdentificadas]
end

GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las necesidades identificadas del municipio acorde con la pregunta del PAT
-- =============================================
CREATE procedure [PAT].[C_NecesidadesIdentificadas] --103, 109
	@USUARIO INT,
	@PREGUNTA SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Cant INT
    DECLARE @Cantidad INT
    DECLARE @CantidadDef NVARCHAR(100)

	DECLARE  @SQL NVARCHAR(MAX)

	DECLARE @Divipola  varchar(5)
	SELECT @Divipola =  M.Divipola
	FROM [dbo].[Usuario] (NOLOCK) U
	JOIN Municipio AS M ON U.IdMunicipio = M.Id
	WHERE U.ID = @USUARIO

	SET @SQL = 'SELECT
				@Cantidad = COUNT(1)
				FROM
					(
						SELECT DISTINCT
							A.*
						FROM
							[PAT].[PrecargueSIGO] A
						WHERE
							A.[CodigoDane] = @Divipola
					'
	IF @PREGUNTA = 108
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Solicita asistencia funeraria'''
	ELSE IF @PREGUNTA IN (111, 112)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere acceso a educaci贸n b谩sica o media'''
	ELSE IF @PREGUNTA = 113
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto requiere acceso a educaci贸n b谩sica o media'''
	ELSE IF @PREGUNTA IN (110, 163)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere cuidado inicial'''
	ELSE IF @PREGUNTA = 170
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Mejoramiento vivienda'''
	ELSE IF @PREGUNTA = 171
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Vivienda nueva'''
	ELSE IF @PREGUNTA = 146
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Requiere acceso a Educaci贸n Gitano Rom - Ind铆gena'''
	ELSE IF @PREGUNTA = 148
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Documento de identidad'''
	ELSE IF @PREGUNTA = 149
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Libreta militar'''
	ELSE IF @PREGUNTA = 141
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere acceso a programas regulares de alimentaci贸n'''
	ELSE IF @PREGUNTA IN (140, 142)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto requiere acceso a programas regulares de alimentaci贸n'''
	ELSE IF @PREGUNTA IN (144, 145)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Madre gestante o lactante requiere apoyo alimentario'''
	ELSE IF @PREGUNTA = 127
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto solicita reunificaci贸n familiar'''
	ELSE IF @PREGUNTA = 128
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Afiliaci贸n al SGSSS'''
	ELSE IF @PREGUNTA = 139
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Requiere acceso a programa j贸venes en acci贸n'''
	ELSE IF @PREGUNTA IN (120, 121)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Apoyo a nuevos emprendimientos'''
	ELSE IF @PREGUNTA IN (122, 123)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Fortalecimiento de negocios'''
	ELSE IF @PREGUNTA IN (124, 125)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Empleabilidad'''
	ELSE IF @PREGUNTA = 126
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor solicita reunificaci贸n familiar'''
	ELSE IF @PREGUNTA = 152
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Atenci贸n psicosocial'''
	ELSE IF @PREGUNTA IN (116, 117)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Orientaci贸n ocupacional'''
	ELSE IF @PREGUNTA IN (118, 119)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Educaci贸n y/o orientaci贸n para el trabajo'''
	ELSE
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''ninguna'''
	--SET @SQL = 'SELECT
	--				@Cantidad = COUNT(1)
	--			FROM
	--				(
	--				SELECT
	--						DISTINCT C.TIPO_DOCUMENTO,C.NUMERO_DOCUMENTO,C.ID_MEDIDA,C.ID_NECESIDAD
	--				from	DBO.TB_CARGUE C 
	--				INNER JOIN	DBO.TB_LOTE L ON C.ID_LOTE = L.ID
	--				INNER JOIN	DBO.Entidad E ON C.DANE_MUNICIPIO = E.ID_MUNICIPIO
	--				INNER JOIN	PAT.Pregunta P ON P.ID_MEDIDA = C.ID_MEDIDA
	--				WHERE	L.ID_ESTADO = 3	
	--				AND		E.ID = PAT.GetIdEntidad(@USUARIO)
	--				AND		P.ID  = @PREGUNTA '

	---- MEDIDA IDENTIFICACI覰
	--IF @PREGUNTA = 1
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 6'
	--IF @PREGUNTA = 2
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 7 AND 17'
	--IF @PREGUNTA = 3
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >= 18'

	---- MEDIDA SALUD
	--IF @PREGUNTA = 5
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'

	---- MEDIDA REHABILITACI覰 PSICOSOCIAL


	---- MEDIDA EDUCACI覰
	--IF @PREGUNTA = 7
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 6 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 5'
	--IF @PREGUNTA = 8
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
	--IF @PREGUNTA = 9
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
	--IF @PREGUNTA = 10
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'

	---- MEDIDA GENERACION DE INGRESOS
	--IF @PREGUNTA = 11
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 12
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 13
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 14
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 15
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 5'
	--IF @PREGUNTA = 16
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 5'
	--IF @PREGUNTA = 17
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 4'
	--IF @PREGUNTA = 18
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 4'
	--IF @PREGUNTA = 19
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD in (3,8)'
	--IF @PREGUNTA = 20
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD in (3,8)'

	---- MEDIDA SEGURIDAD ALIMENTARIA
	--IF @PREGUNTA = 21
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 5'
	--IF @PREGUNTA = 22
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
	--IF @PREGUNTA = 23
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'
	--IF @PREGUNTA = 24 
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 25
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'

	---- MEDIDA REUNIFICACI覰 FAMILIAR
	--IF @PREGUNTA = 26
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 17'
	--IF @PREGUNTA = 27
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'

	---- MEDIDA VIVIENDA
	--IF @PREGUNTA = 28
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 29
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 30
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 31
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 32
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 33
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 34
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 35
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 36
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	
	---- MEDIDA ASISTENCIA FUNERARIA
	--IF @PREGUNTA = 37
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 38
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'

	SET @SQL = @SQL + ')P' 
	
	SET @CantidadDef = N'@Cantidad INT OUTPUT,@USUARIO INT,@Divipola  varchar(5)'
    SET @Cant = 0 

	print @SQL
  
    EXECUTE sp_executesql @Sql, @CantidadDef, @Cantidad = @Cant OUTPUT, @USUARIO = @USUARIO ,@Divipola=@Divipola    
    SELECT @Cant Cantidad
END 




GO
/****** Object:  StoredProcedure [PAT].[C_ProgramasPAT]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene los programas de Oferta cargados en el PAT
-- =============================================

if exists (select * from sys.procedures where name = 'C_ProgramasPAT')
begin
drop procedure [PAT].[C_ProgramasPAT]
end

GO

CREATE PROCEDURE [PAT].[C_ProgramasPAT]( 
	@ID as INT	
)
AS
BEGIN
	SET NOCOUNT ON;	

	SELECT	P.PROGRAMA,P.ID
	FROM	[PAT].[RespuestaPAT] (NOLOCK) AS R,
			[PAT].[RespuestaPATPrograma] (NOLOCK) AS P
	WHERE	R.ID = P.[IdRespuestaPAT] AND P.ACTIVO = 1 AND R.ID = @ID
END




GO
/****** Object:  StoredProcedure [PAT].[C_TableroFechaActivo]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_TableroFechaActivo')
begin
drop procedure [PAT].[C_TableroFechaActivo]
end

GO

-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		23/09/2016
-- Modified date:	
-- Description:		Procedimiento que valida activaci髇 del tablero por fechas
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroFechaActivo]
	@NIVEL TINYINT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Cant INT
    	DECLARE @Cantidad INT
    	DECLARE @CantidadDef NVARCHAR(100)

	DECLARE  @SQL NVARCHAR(MAX)
	SET @SQL = 'SELECT
					@Cantidad = COUNT(*)
					FROM [PAT].[TableroFecha] 
					WHERE GETDATE() BETWEEN VIGENCIAINICIO AND VIGENCIAFIN
					AND IDTABLERO = (SELECT ID FROM [PAT].[Tablero] WHERE ACTIVO = 1)
					AND NIVEL = @N AND ACTIVO = 1'
	
	SET @CantidadDef = N'@Cantidad INT OUTPUT,@N TINYINT'
    SET @Cant = 0 
  
    EXECUTE sp_executesql @Sql, @CantidadDef, @Cantidad = @Cant OUTPUT, @N=@NIVEL    
    SELECT @Cant Cantidad
END



GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipio]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_TableroMunicipio')
begin
drop procedure [PAT].[C_TableroMunicipio]
end

GO

CREATE PROCEDURE [PAT].[C_TableroMunicipio] --null, 1, 20, 506, 'salud'

 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		IDPREGUNTA SMALLINT,IDDERECHO SMALLINT,IDCOMPONENTE TINYINT,IDMEDIDA SMALLINT,NIVEL TINYINT,
		PREGUNTAINDICATIVA NVARCHAR(500),IDUNIDADMEDIDA TINYINT,PREGUNTACOMPROMISO NVARCHAR(500),APOYODEPARTAMENTAL BIT,
		APOYOENTIDADNACIONAL BIT,ACTIVO BIT,DERECHO NVARCHAR(50),COMPONENTE NVARCHAR(100),MEDIDA NVARCHAR(50),
		UNIDADMEDIDA NVARCHAR(100),IDTABLERO TINYINT,IDENTIDAD INT,ID INT,RESPUESTAINDICATIVA INT,
		RESPUESTACOMPROMISO INT,PRESUPUESTO MONEY,OBSERVACIONNECESIDAD NVARCHAR(1000),ACCIONCOMPROMISO NVARCHAR(1000)
		)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize 

	SET @ORDEN = @sortOrder
	SET @ORDEN = 'P.ID'
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE  @IDENTIDAD INT

	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
	SET @SQL = 'SELECT 	
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO
		FROM (
		SELECT DISTINCT TOP (@TOP) LINEA,
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO
	FROM ( 
    SELECT DISTINCT row_number() OVER (ORDER BY '+ @ORDEN +') AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IDENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID ,
						R.RespuestaIndicativa, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO
				FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdMunicipio =  @IDENTIDAD ,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 
					AND 1=pat.ValidarPreguntaRyR(P.IDMEDIDA,@IDENTIDAD) 
					AND D.ID = @IdDerecho'	
	SET @SQL =@SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY LINEA ) AS T'
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IDENTIDAD INT,@IdDerecho INT'
		
	PRINT @SQL

	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IDENTIDAD=@IDENTIDAD, @IdDerecho=@IdDerecho
	SELECT * from @RESULTADO
END




GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioAvance]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_TableroMunicipioAvance')
begin
drop procedure [PAT].[C_TableroMunicipioAvance]
end

GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene los porcentajes de avance de la gesti髇 del tablero PAT por municipio
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroMunicipioAvance] -- 506,2
		@IdUsuario INT, @idTablero tinyint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		DERECHO NVARCHAR(50),
		PINDICATIVA INT,
		PCOMPROMISO INT
		)
	
	DECLARE  @ID_ENTIDAD INT
	SELECT  @ID_ENTIDAD  =  [PAT].[fn_GetIdEntidad](@IdUsuario) 

	SELECT	D.DESCRIPCION AS DERECHO, 
			SUM(case when R.RESPUESTAINDICATIVA IS NULL or R.RESPUESTAINDICATIVA=0 then 0 else 1 end)*100/count(*) PINDICATIVA,
			SUM(case when R.RESPUESTACOMPROMISO IS NULL or R.RESPUESTACOMPROMISO=0 then 0 else 1 end)*100/count(*) PCOMPROMISO
	FROM    [PAT].[PreguntaPAT] (NOLOCK) AS P
	INNER JOIN [PAT].[Derecho] (NOLOCK) D ON P.IDDERECHO = D.ID 
	INNER JOIN PAT.Tablero (NOLOCK) AS T ON P.IDTABLERO = T.ID				
	LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON R.IdMunicipio = @ID_ENTIDAD  and P.ID = R.[IdPreguntaPAT]
	WHERE	P.NIVEL = @NIVEL 
	AND 1=pat.ValidarPreguntaRyR(P.IDMEDIDA,@ID_ENTIDAD )  
	AND T.ID = @idTablero
	and P.ACTIVO = 1	
	group by D.DESCRIPCION
END


GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioRC]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_TableroMunicipioRC')
begin
drop procedure [PAT].[C_TableroMunicipioRC]
end

GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las preguntas para la gesti髇 del tablero PAT de responsabilidad Colectiva	
-- =============================================

CREATE PROCEDURE [PAT].[C_TableroMunicipioRC]-- NULL, 1, 20, 46, 'Reparaci髇 Integral',1
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho INT, @idTablero tinyint)

AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		LINEA INT,
		IDPREGUNTARC SMALLINT,
		IDDANE INT,
		IDMEDIDA SMALLINT,
		SUJETO NVARCHAR(3000),
		MEDIDARC NVARCHAR(2000),
		MEDIDA NVARCHAR(500),
		IDTABLERO TINYINT,
		IDENTIDAD INT,
		ID INT,
		ACCION NVARCHAR(4000),
		PRESUPUESTO MONEY
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE @IDDANE INT, @IDENTIDAD INT
	
	--SELECT @IDDANE= [PAT].[fn_GetDaneMunicipioEntidad](@IdUsuario)
	SELECT @IDENTIDAD =[PAT].[fn_GetIdEntidad](@IdUsuario)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize


	SET @ORDEN = @sortOrder
	IF @ORDEN = '' or @ORDEN is NULL
		SET @ORDEN = 'IDPREGUNTA'

	IF  @IdDerecho = 6
	BEGIN
		SET @SQL = 'SELECT A.LINEA,
				A.IDPREGUNTA, 
				A.IDDANE,
				A.IDMEDIDA,
				A.SUJETO,
				A.MEDIDARC,
				A.MEDIDA,
				A.IDTABLERO,
				A.IDENTIDAD,
				A.ID,
				A.ACCION,
				A.PRESUPUESTO 
					FROM (SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
							P.ID AS IDPREGUNTA, 
							P.[IdMunicipio] AS IDDANE, 
							P.IDMEDIDA, 
							P.SUJETO, 
							P.[MedidaReparacionColectiva] AS MEDIDARC, 
							M.DESCRIPCION AS MEDIDA, 
							T.ID AS IDTABLERO,
							CASE WHEN R.IdMunicipio IS NULL THEN @IDENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
							R.ID,
							R.ACCION, 
							R.PRESUPUESTO
						FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
							LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] AS R ON P.ID= R.[IdPreguntaPATReparacionColectiva] AND R.[IdMunicipio] = @IDENTIDAD,
							[PAT].[Medida] M,
							[PAT].[Tablero] T
						WHERE	P.IDMEDIDA = M.ID 
							AND P.[IdMunicipio] = @IDENTIDAD
							AND P.IDTABLERO = T.ID
							AND T.ID = @idTablero'
		SET @SQL =@SQL +') AS A WHERE A.LINEA >@PAGINA  AND A.IDPREGUNTA > 2242 ORDER BY A.LINEA ASC'-- AND IDPREGUNTA > 2242
		SET @PARAMETROS = '@TOP INT, @PAGINA INT,@idTablero tinyint,@IDENTIDAD INT'		
		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @idTablero=@idTablero, @IDENTIDAD=@IDENTIDAD
	END
	SELECT * from @RESULTADO
END




GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioRR]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_TableroMunicipioRR')
begin
drop procedure [PAT].[C_TableroMunicipioRR]
end

GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las preguntas para la gesti髇 del tablero PAT de responsabilidad Colectiva	
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroMunicipioRR] --'', 1, 20, 394, 'Reparaci髇 Integral'
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho INT, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		LINEA INT,
		ID_PREGUNTA_RR SMALLINT,
		ID_DANE INT,
		HOGARES SMALLINT,
		PERSONAS SMALLINT,
		SECTOR NVARCHAR(MAX),
		COMPONENTE NVARCHAR(MAX),
		COMUNIDAD NVARCHAR(MAX),
		UBICACION NVARCHAR(MAX),
		MEDIDA_RR NVARCHAR(MAX),
		INDICADOR_RR NVARCHAR(MAX),
		ENTIDAD_RESPONSABLE NVARCHAR(MAX),
		ID_TABLERO TINYINT,
		ID_ENTIDAD INT,
		ID INT,
		ACCION NVARCHAR(1000),
		PRESUPUESTO MONEY
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE @ID_ENTIDAD INT
	--DECLARE @ID_DANE INT
		
	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize

	SET @ORDEN = @sortOrder
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'ID_PREGUNTA'

	SELECT @ID_ENTIDAD=PAT.fn_GetIdEntidad(@IdUsuario)
	--SELECT @ID_DANE=[PAT].[fn_GetDaneMunicipioEntidad](@IdUsuario)
	IF  @IdDerecho = 6
	BEGIN
		SET @SQL = 'SELECT	LINEA,IDPREGUNTA,IDDANE,HOGARES,PERSONAS,SECTOR, 
							COMPONENTE, COMUNIDAD, UBICACION, MEDIDARR, INDICADORRR, 
							ENTIDADRESPONSABLE, IDTABLERO,IDENTIDAD,ID,ACCION,PRESUPUESTO 
					FROM (
							SELECT DISTINCT TOP (@TOP) LINEA,IDPREGUNTA,IDDANE,HOGARES,PERSONAS,SECTOR, 
							COMPONENTE,COMUNIDAD,UBICACION,MEDIDARR,INDICADORRR, 
							ENTIDADRESPONSABLE,IDTABLERO,IDENTIDAD,ID,ACCION,PRESUPUESTO
					FROM ( 
							SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
							P.ID AS IDPREGUNTA,
							P.[IdMunicipio] AS IDDANE,
							P.[HOGARES],
							P.[PERSONAS],
							P.[SECTOR],
							P.[COMPONENTE],
							P.[COMUNIDAD],
							P.[UBICACION],
							P.[MedidaRetornoReubicacion] AS MEDIDARR,
							P.[IndicadorRetornoReubicacion] AS INDICADORRR,
							P.[ENTIDADRESPONSABLE], 
							T.ID AS IDTABLERO,
							CASE WHEN R.IdMunicipio IS NULL THEN @ID_ENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
							R.ID,
							R.ACCION, 
							R.PRESUPUESTO
					FROM   [PAT].[PreguntaPATRetornosReubicaciones] P
					INNER JOIN [PAT].[Tablero] T ON P.[IdTablero] = T.ID
					LEFT OUTER JOIN [PAT].[RespuestaPATRetornosReubicaciones] R ON R.IdMunicipio = @ID_ENTIDAD and p.ID = R.[IdPreguntaPATRetornoReubicacion]
					WHERE  T.ID = @idTablero and P.[IdMunicipio] = @ID_ENTIDAD'
		SET @SQL =@SQL +' ) AS A WHERE A.LINEA >@PAGINA ORDER BY A.LINEA ) as F'
		SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT,@idTablero tinyint,  @ID_ENTIDAD INT'

--		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero,@ID_ENTIDAD= @ID_ENTIDAD
	END
	SELECT * from @RESULTADO
END




GO
/****** Object:  StoredProcedure [PAT].[C_TableroVigencia]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_TableroVigencia')
begin
drop procedure [PAT].[C_TableroVigencia]
end

GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene el tablero vigente
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroVigencia] 
 (@idTablero tinyint)
AS
BEGIN
	SELECT	YEAR(P.VIGENCIAINICIO) ANNO,
			(CONVERT(VARCHAR(10), P.VIGENCIAINICIO, 103) + ' AL ' + CONVERT(VARCHAR(10), P.VIGENCIAFIN, 103)) VIGENCIA
	FROM [PAT].[Tablero] P
	WHERE	P.ACTIVO =1 
		and P.Id=@idTablero
END



GO
/****** Object:  StoredProcedure [PAT].[C_TodosTablerosMunicipiosCompletos]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_TodosTablerosMunicipiosCompletos')
begin
drop procedure [PAT].[C_TodosTablerosMunicipiosCompletos]
end

GO

CREATE PROC [PAT].[C_TodosTablerosMunicipiosCompletos]

AS

BEGIN

select
A.[Id],
B.[VigenciaInicio],
B.[VigenciaFin]
from
[PAT].[Tablero] A,
[PAT].[TableroFecha] B
where
A.[Id]=B.[IdTablero]
and B.[Nivel]=3
and A.[Activo]=0

END

GO
/****** Object:  StoredProcedure [PAT].[C_TodosTablerosMunicipiosPorCompletar]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'C_TodosTablerosMunicipiosPorCompletar')
begin
drop procedure [PAT].[C_TodosTablerosMunicipiosPorCompletar]
end

GO

CREATE PROC [PAT].[C_TodosTablerosMunicipiosPorCompletar]

AS

BEGIN

select 
A.Id,
B.Vigenciainicio,
B.VigenciaFin 
from 
[PAT].[Tablero] A, 
[PAT].[TableroFecha] B
Where A.Id=B.IdTablero
and B.Nivel=2
and A.Activo=1

END

GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaAccionesInsert]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'I_RespuestaAccionesInsert')
begin
drop procedure [PAT].[I_RespuestaAccionesInsert]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaAccionesInsert] 
           @IDPATRESPUESTA int,
           @ACCION nvarchar(500),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATAccion]
           ([IdRespuestaPAT]
           ,[ACCION]
           ,[ACTIVO])
			VALUES
           (@IDPATRESPUESTA,
            @ACCION, 
            @ACTIVO)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		

GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaAccionesRCInsert]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


if exists (select * from sys.procedures where name = 'I_RespuestaAccionesRCInsert')
begin
drop procedure [PAT].[I_RespuestaAccionesRCInsert]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaAccionesRCInsert] 
           @IDPATRESPUESTA int,
           @ACCION nvarchar(500),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATAccionReparacionColectiva]
           ([IdRespuestaPATReparacionColectiva]
           ,[AccionReparacionColectiva]
           ,[ACTIVO])
			VALUES
           (@IDPATRESPUESTA,
            @ACCION, 
            @ACTIVO)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		

GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaAccionesRRInsert]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'I_RespuestaAccionesRRInsert')
begin
drop procedure [PAT].[I_RespuestaAccionesRRInsert]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaAccionesRRInsert] 
           @IDPATRESPUESTA int,
           @ACCION nvarchar(500),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATAccionRetornosReubicaciones]
           ([IdRespuestaPATRetornoReubicacion]
           ,[AccionRetornoReubicacion]
           ,[ACTIVO])
			VALUES
           (@IDPATRESPUESTA,
            @ACCION, 
            @ACTIVO)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		

GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaInsert]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'I_RespuestaInsert')
begin
drop procedure [PAT].[I_RespuestaInsert]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la informaci髇 del tablero municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaInsert] 
		@IDUSUARIO int,
		@IDPREGUNTA smallint,
		@NECESIDADIDENTIFICADA int,
		@RESPUESTAINDICATIVA int,
		@RESPUESTACOMPROMISO int,
		@PRESUPUESTO money,
		@OBSERVACIONNECESIDAD nvarchar(1000),
		@ACCIONCOMPROMISO nvarchar(1000)		
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	DECLARE  @IDENTIDAD INT

	declare @id int	
	
	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)

	select @id = r.ID from [PAT].[RespuestaPAT] as r
	where r.IdPreguntaPAT = @IDPREGUNTA AND  r.IdMunicipio = @IDENTIDAD
	order by r.ID
	if (@id is not null)
	begin
		set @esValido = 0
		set @respuesta += 'La respuesta ya se encuentra ingresada.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
		
		INSERT INTO [PAT].[RespuestaPAT]
		([IdPreguntaPAT]
		,[NECESIDADIDENTIFICADA]
		,[RESPUESTAINDICATIVA]
		,[RESPUESTACOMPROMISO]
		,[PRESUPUESTO]
		,[OBSERVACIONNECESIDAD]
		,[ACCIONCOMPROMISO]
		,[IDUSUARIO]
		,[FECHAINSERCION]
		,[IdMunicipio])
		VALUES
		(@IDPREGUNTA,
		 @NECESIDADIDENTIFICADA, 
		 @RESPUESTAINDICATIVA, 
		 @RESPUESTACOMPROMISO,
		 @PRESUPUESTO, 
		 @OBSERVACIONNECESIDAD,
		 @ACCIONCOMPROMISO,
		 @IDUSUARIO,
		 GETDATE(),
		 @IDENTIDAD)    			
		
			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id


GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaProgramaInsert]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'I_RespuestaProgramaInsert')
begin
drop procedure [PAT].[I_RespuestaProgramaInsert]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaProgramaInsert] 
           @ID_PAT_RESPUESTA int,
           @PROGRAMA nvarchar(1000),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATPrograma]
           ([IdRespuestaPAT]
           ,[PROGRAMA]
           ,[ACTIVO])
			VALUES
           (@ID_PAT_RESPUESTA,
            @PROGRAMA, 
            @ACTIVO)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		

GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaRCInsert]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'I_RespuestaRCInsert')
begin
drop procedure [PAT].[I_RespuestaRCInsert]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la informaci髇 del tablero municipal para Reparacion colectiva												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaRCInsert] 
					@IDUSUARIO int
				   ,@IDENTIDAD  int
				   ,@IDPREGUNTARC smallint
				   ,@ACCION varchar(max)
				   ,@PRESUPUESTO money
AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	
	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY
			INSERT INTO [PAT].[RespuestaPATReparacionColectiva]
				   ([IdPreguntaPATReparacionColectiva]
				   ,[ACCION]
				   ,[PRESUPUESTO]
				   ,[IdUsuario]
				   ,[FechaInsercion]
				   ,[IdMunicipio])
			 VALUES
				   (@IDPREGUNTARC
				   ,@ACCION
				   ,@PRESUPUESTO
				   ,@IDUSUARIO
				   ,GETDATE()
				   ,@IDENTIDAD)


			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id


GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaRRInsert]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'I_RespuestaRRInsert')
begin
drop procedure [PAT].[I_RespuestaRRInsert]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la informaci髇 del tablero municipal para retornos y reubicaciones												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaRRInsert] 
					@IDUSUARIO int
				   ,@IDPREGUNTARR smallint
				   ,@ACCION varchar(max)
				   ,@PRESUPUESTO money
AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	DECLARE  @IDENTIDAD INT

	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)

	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY
			INSERT INTO [PAT].[RespuestaPATRetornosReubicaciones]
				   ([IdPreguntaPATRetornoReubicacion]
				   ,[ACCION]
				   ,[PRESUPUESTO]
				   ,[IdUsuario]
				   ,[FechaInsercion]
				   ,[IdMunicipio])

			 VALUES
				   (@IDPREGUNTARR
				   ,@ACCION
				   ,@PRESUPUESTO
			  	   ,@IDUSUARIO
				   ,GETDATE()
				   ,@IDENTIDAD)    			



			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id

GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaAccionesRCUpdate]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'U_RespuestaAccionesRCUpdate')
begin
drop procedure [PAT].[U_RespuestaAccionesRCUpdate]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaAccionesRCUpdate] 
		@ID int,
		@IDPATRESPUESTA int,
        @ACCION nvarchar(500),
        @ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATAccionReparacionColectiva]
			SET [IdRespuestaPATReparacionColectiva] = @IDPATRESPUESTA
			,[AccionReparacionColectiva] = @ACCION
			,[ACTIVO] = @ACTIVO
			 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado
		
	

GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaAccionesRRUpdate]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'U_RespuestaAccionesRRUpdate')
begin
drop procedure [PAT].[U_RespuestaAccionesRRUpdate]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaAccionesRRUpdate] 
		@ID int,
		@IDPATRESPUESTA int,
        @ACCION nvarchar(500),
        @ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATAccionRetornosReubicaciones]
			SET [IdRespuestaPATRetornoReubicacion] = @IDPATRESPUESTA
			,[AccionRetornoReubicacion] = @ACCION
			,[ACTIVO] = @ACTIVO
			 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado
		

GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaAccionesUpdate]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'U_RespuestaAccionesUpdate')
begin
drop procedure [PAT].[U_RespuestaAccionesUpdate]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaAccionesUpdate] 
		@ID int,
		@IDPATRESPUESTA int,
        @ACCION nvarchar(500),
        @ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATAccion]
			SET [IdRespuestaPAT] = @IDPATRESPUESTA
			,[ACCION] = @ACCION
			,[ACTIVO] = @ACTIVO
			 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado
		

GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaProgramaUpdate]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'U_RespuestaProgramaUpdate')
begin
drop procedure [PAT].[U_RespuestaProgramaUpdate]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaProgramaUpdate] 
		@ID int,
		@ID_PAT_RESPUESTA int,
		@PROGRAMA nvarchar(1000),
		@ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATPrograma]
			SET [IdRespuestaPAT] = @ID_PAT_RESPUESTA,
			    [PROGRAMA] = @PROGRAMA,
			    [ACTIVO] = @ACTIVO
			WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado
		

GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaRCUpdate]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'U_RespuestaRCUpdate')
begin
drop procedure [PAT].[U_RespuestaRCUpdate]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero para Reparacion colectiva												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaRCUpdate] 
		@ID int,
		@IDPREGUNTARC smallint
		,@ACCION varchar(max)
		,@PRESUPUESTO money
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
	declare @idRespuesta int
	select @idRespuesta = r.ID from [PAT].[RespuestaPATReparacionColectiva] as r
	where r.ID =  @ID
		
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
		
		UPDATE [PAT].[RespuestaPATReparacionColectiva]
		   SET [IdPreguntaPATReparacionColectiva] = @IDPREGUNTARC
			  ,[ACCION] = @ACCION
			  ,[PRESUPUESTO] = @PRESUPUESTO
			  ,[FECHAMODIFICACION]= GETDATE()
		 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado
			

GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaRRUpdate]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'U_RespuestaRRUpdate')
begin
drop procedure [PAT].[U_RespuestaRRUpdate]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero para retornos y reubicaciones				 								  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaRRUpdate] 
		@ID int
		,@IDPREGUNTARR smallint
		,@ACCION varchar(max)
		,@PRESUPUESTO money
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
	declare @idRespuesta int
	select @idRespuesta = r.ID from [PAT].[RespuestaPATRetornosReubicaciones] as r
	where r.ID =  @ID
		
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
		
		UPDATE [PAT].[RespuestaPATRetornosReubicaciones]
		   SET [IdPreguntaPATRetornoReubicacion] = @IDPREGUNTARR
			  ,[ACCION] = @ACCION
			  ,[PRESUPUESTO] = @PRESUPUESTO
			  ,[FECHAMODIFICACION]= GETDATE()
		 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado
	

GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaUpdate]    Script Date: 20/06/2017 14:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if exists (select * from sys.procedures where name = 'U_RespuestaUpdate')
begin
drop procedure [PAT].[U_RespuestaUpdate]
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la informaci髇 del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acci髇 exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaUpdate] 
		@ID int,
		@IDPREGUNTA smallint,
		@NECESIDADIDENTIFICADA int,
		@RESPUESTAINDICATIVA int,
		@RESPUESTACOMPROMISO int,
		@PRESUPUESTO money,
		@OBSERVACIONNECESIDAD nvarchar(1000),
		@ACCIONCOMPROMISO nvarchar(1000),
		@IDUSUARIO int		
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
	declare @idRespuesta int
	select @idRespuesta = r.ID from [PAT].[RespuestaPAT] as r
	where r.[IdPreguntaPAT] = @IDPREGUNTA and r.IdUsuario = @IDUSUARIO
	order by r.ID
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY

		UPDATE [PAT].[RespuestaPAT]
		   SET [IdPreguntaPAT] = @IDPREGUNTA
			  ,[NECESIDADIDENTIFICADA] = @NECESIDADIDENTIFICADA
			  ,[RESPUESTAINDICATIVA] = @RESPUESTAINDICATIVA
			  ,[RESPUESTACOMPROMISO] = @RESPUESTACOMPROMISO
			  ,[PRESUPUESTO] = @PRESUPUESTO
			  ,[OBSERVACIONNECESIDAD] = @OBSERVACIONNECESIDAD
			  ,[ACCIONCOMPROMISO] = @ACCIONCOMPROMISO
			  ,[FechaModificacion] = GETDATE()
		 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado			

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_EntidadesConRespuestaMunicipal]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [PAT].[C_EntidadesConRespuestaMunicipal]
GO
CREATE PROC [PAT].[C_EntidadesConRespuestaMunicipal]
AS
BEGIN


--SELECT 	DISTINCT 
--		C.NOMBRE
--		,C.ID AS ID_ENTIDAD
--		,CASE WHEN C.NOMBRE LIKE 'alcaldia%%' THEN 1 ELSE 2 END AS TIPO
--		,CASE WHEN C.NOMBRE LIKE 'alcaldia%%' THEN 'ALCALDIA' ELSE 'GOBERNACION' END AS TIPO_USUARIO
--		,(SELECT TOP 1 XX.DESCRIPCION FROM [PAT].[TB_DANE] XX WHERE XX.ID = B.ID_DEPARTAMENTO) AS DEPARTAMENTO
--		,(SELECT TOP 1 XX.DESCRIPCION FROM [PAT].[TB_DANE] XX WHERE XX.ID = B.ID_MUNICIPIO) AS MUNICIPIO
--	FROM [PAT].[TB_PAT_RESPUESTA] A
--	INNER JOIN [PAT].[TB_ENTIDAD] B ON B.ID = A.ID_ENTIDAD
--	INNER JOIN [PAT].[TB_USUARIO] C ON C.ID_ENTIDAD = B.ID

	SELECT distinct 
	U.UserName as Entidad,TU.Nombre as TipoUsuario, D.Nombre as Departamento, M.Nombre as Municipio, A.IdMunicipio    
	FROM PAT.RespuestaPAT AS A
	INNER JOIN dbo.Municipio as M on A.IdMunicipio = M.id
	INNER JOIN dbo.Departamento as D on M.IdDepartamento = D.Id
	JOIN dbo.Usuario as U on A.IdUsuario = U.Id
	JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
	order by 3,1
END