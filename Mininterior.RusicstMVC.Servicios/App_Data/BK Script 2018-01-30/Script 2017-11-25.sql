
-- Actualización de la plantilla que recupera el correo
UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET [ParametroValor] = '<p><br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la Atención y Reparación Integral a las Víctimas</b>.<br><br>Su solicitud de Recuperación de Contraseña ha sido confirmada por parte del Ministerio.<br><br>Clave: <b>{0}</b><br><br>Por favor ingrese al siguiente vínculo <strong><a href="{1}" target="_blank"><singleline label="Title">RUSICST </singleline></a></strong> para ingresar al Sistema de Información.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención,<br><br><br><b>Grupo de Articulación Interna para la Política Pública de Victimas del Conflicto Armado</b></p>'
WHERE [NombreParametro] = 'PlantillaRecuperarClave'

-- Actualización de la plantilla que confirma la solicitud
UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET [ParametroValor] = '<p><br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la Atención y Reparación Integral a las Víctimas</b>.<br><br>Su solicitud de Usuario ha sido confirmada por parte del Ministerio. Por favor ingrese al siguiente <strong><a href="{0}"><singleline label="Title">Vinculo de Confirmación </singleline></a></strong>  para confirmar su registro.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención,<br><br><br><b>Grupo de Articulación Interna para la Política Pública de Victimas del Conflicto Armado</b></p>'
WHERE [NombreParametro] = 'PlantillaConfirmacionSolicitud'

-- Actualización de la plantilla que muestra el error
UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET [ParametroValor] = '<p><br/><br/>Se reportó un error con la siguiente información.</p><p>Id del Error: <b>{0}</b></p><p>Descripción: {1}</p><p><b><br>Grupo de Articulación Interna para la Política Pública de Victimas del Conflicto Armado</p>'
WHERE [NombreParametro] = 'PlantillaError'

-- Actualización de la plantilla que creación de usuario
UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET [ParametroValor] = '<p><br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la  Atención y Reparación Integral a las Víctimas</b>.<br><br>Su usuario ha sido creado o actualizado correctamente en el sistema, con las siguientes credenciales:<br><br><b>Usuario:</b>{0}<br><b>Contraseña:</b> {1}<br><br>Diríjase al siguiente Vínculo, para ingresar al sistema <strong><a href="{2}">RUSICST.</a></strong><br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se  requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br>Agradecemos su atención,<br><br><b>Grupo de Articulación Interna para la Política Pública de Victimas del Conflicto Armado</b></p>'
WHERE [NombreParametro] = 'PlantillaCreacionUsuario'

-- Actualización de la plantilla que rechazo de solicitud
UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET [ParametroValor] = '<p><br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la  Atención y Reparación Integral a las Víctimas</b>.<br><br>Su solicitud de Usuario ha sido rechazada, por favor comuniquese al correo <b>reporteunificado@mininterior.gov.co</b>, para tener un mayor detalle de esta decisión.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se  requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención,<br><br><br><b>Grupo de Articulación Interna para la Política Pública de Victimas del Conflicto Armado</b></p>'
WHERE [NombreParametro] = 'PlantillaRechazoSolicitud'

-- Actualización de la plantilla que solicitud de usuario
UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET [ParametroValor] = '<p><br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la Atención y Reparación Integral a las Víctimas</b>.<br><br>Su solicitud de Usuario ha sido enviada con éxito al Ministerio. Por favor ingrese al siguiente <strong><a href="{0}"><singleline label="Title">Vinculo de Confirmación </singleline></a></strong>  para confirmar su solicitud.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención,<br><br><br><b>Grupo de Articulación Interna para la Política Pública de Victimas del Conflicto Armado</b></p>'
WHERE [NombreParametro] = 'PlantillaSolicitudUsuario'

-- Actualización de la plantilla bienvenida
UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET [ParametroValor] = '<p><br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la  Atención y Reparación Integral a las Víctimas</b>.<br></p><p>Siendo la construcción de paz un compromiso nacional y la garantía de los derechos de las víctimas una responsabilidad del Estado en su conjunto, el <b>Reporte Unificado del Sistema de Información, Coordinación y Seguimiento Territorial de la Política Pública de Víctimas –RUSICST</b>, herramienta de seguimiento a la implementación de la política pública de víctimas, como es de su conocimiento es responsabilidad del <b>Ministerio del Interior</b> y <b>La UARIV</b> el diseño y puesta en funcionamiento, así como es de las entidades territoriales el reporte periódico.</p><p>Nos permitimos informarle que la plataforma para el reporte ha sido diseñada de tal manera que sea más efectivo el proceso y se encuentra alojado en el link:</p><div style="text-align: center;"><b><a href="{0}">RUSICST</a></b></div><p>Cada entidad territorial cuenta con la responsabilidad de suministrar la información, para lo cual se le asigna un usuario y contraseña personal y confidencial por lo tanto es responsabilidad del enlace designado por la Autoridad territorial el uso y manejo de la misma.</p><p><b>El Ministerio del Interior</b> y <b>La UARIV</b> en el proceso de implementación ha venido desarrollando capacitaciones programadas para el mes de febrero, en los diferentes departamentos, con el fin de aumentar la capacidad de los enlaces en el proceso de reporte.</p><p>Es un gusto darle la bienvenida al <b>RUSICST</b> y asignarle su respectivo usuario y contraseña:</p><div style="text-align: center;">Usuario: <b>{1}</b><br>Contraseña: <b>{2}</b></div><p>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.</p><p>Agradecemos su atención,<br/><br/></p><p><b>Grupo de Articulación Interna para la Política Pública de Victimas del Conflicto Armado</b></p>'
WHERE [NombreParametro] = 'PlantillaBienvenida'

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_InformeRespuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_InformeRespuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																			 
-- Fecha creacion: 2017-03-16																			 
-- Descripcion: Trae el listado de respuestas de acuerdo a los criterios de búsqueda. En el parámetro 
--				@listaIdSubsecciones trae concatenados las secciones que se quieren consultar en específico		
--				Se ajusta la consulta para validar si es un usuario tipo alcaldía o tipo gobernación	
--==========================================================================================================
ALTER PROCEDURE [dbo].[C_InformeRespuesta]

	  @IdEncuesta			INT
	 ,@listaIdSubsecciones	VARCHAR(128)
	 ,@IdDepartamento		INT = NULL
	 ,@IdMunicipio			INT = NULL
	 ,@Usuario				VARCHAR(255)

AS
	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @Departamento INT
		DECLARE @Municipio	  INT
		DECLARE @TipoUsuario  VARCHAR(255)

		SET @TipoUsuario = (SELECT TOP 1 b.Nombre FROM [dbo].[Usuario] a
							INNER JOIN [dbo].TipoUsuario b ON a.IdTipoUsuario = b.Id
							WHERE a.UserName = @Usuario)

		-- Valida si el usuario corresponde a una Gobernación o a una Alcaldía
		IF(@TipoUsuario = 'ALCALDIA')
			BEGIN
				SELECT @Municipio = IdMunicipio 
				FROM [dbo].[Usuario] 
				WHERE UserName = @Usuario

				SET @Departamento = NULL
			END
		ELSE IF (@TipoUsuario = 'GOBERNACIÓN')
			BEGIN
				SELECT @Departamento = IdDepartamento 
				FROM [dbo].[Usuario] 
				WHERE UserName = @Usuario
			END	

		--=================================================================
		-- ésta consulta hace que el modelo no cree la entidad tipo result
		-- en el modelo de datos. Es necesario comentarlo 
		--=================================================================
		SELECT CONVERT(INT, splitdata) splitdata 
		INTO #ListaSubSecciones 
		FROM [dbo].[Split](@listaIdSubsecciones, ',')
		
		IF(@TipoUsuario = 'ALCALDIA' OR @TipoUsuario = 'GOBERNACIÓN')
			BEGIN
				-- Ejecuta la consulta
				SELECT 
					 E.Titulo Encuesta
					,S.Titulo Seccion
					,BP.IdPregunta PreguntaId
					,BP.NombrePregunta Pregunta
					,[dbo].[ObtenerTextoPreguntaClean](P.Texto) PreguntaTexto
					,U.Username Usuario
					,R.Valor Respuesta
					,D.Nombre Departamento
					,M.Nombre Municipio
				FROM [dbo].[Encuesta] E
					INNER JOIN [dbo].[Seccion] S ON E.Id = S.IdEncuesta
					INNER JOIN [dbo].[Pregunta] P ON S.Id = P.IdSeccion
					INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA ON P.Id = PA.IdPreguntaAnterior
					INNER JOIN [BancoPreguntas].[Preguntas] BP ON PA.IdPregunta = BP.IdPregunta
					INNER JOIN [dbo].[Respuesta] R ON P.Id = R.IdPregunta
					INNER JOIN [dbo].[Usuario] U ON R.IdUsuario = U.Id
					INNER JOIN [dbo].[Departamento] D ON U.IdDepartamento = D.Id
					INNER JOIN [dbo].[Municipio] M ON U.IdMunicipio = M.Id
				WHERE 
					S.IdEncuesta = @IdEncuesta
					-- Ejecuta la función para que obtenga los Id's del parámetro que trae las secciones ------------------
					AND (@listaIdSubsecciones IS NULL OR S.Id IN (Select splitdata FROM #ListaSubSecciones)) 
					-------------------------------------------------------------------------------------------------------
					AND (@Departamento IS NULL OR (M.IdDepartamento = @Departamento))
					AND (@Municipio IS NULL OR U.IdMunicipio = @Municipio)
				ORDER BY 
					E.Id, S.Id, P.Id
			END
		ELSE
			BEGIN
				-- Ejecuta la consulta
				SELECT 
					 E.Titulo Encuesta
					,S.Titulo Seccion
					,BP.IdPregunta PreguntaId
					,BP.NombrePregunta Pregunta
					,[dbo].[ObtenerTextoPreguntaClean](P.Texto) PreguntaTexto
					,U.Username Usuario
					,R.Valor Respuesta
					,D.Nombre Departamento
					,M.Nombre Municipio
				FROM [dbo].[Encuesta] E
					INNER JOIN [dbo].[Seccion] S ON E.Id = S.IdEncuesta
					INNER JOIN [dbo].[Pregunta] P ON S.Id = P.IdSeccion
					INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA ON P.Id = PA.IdPreguntaAnterior
					INNER JOIN [BancoPreguntas].[Preguntas] BP ON PA.IdPregunta = BP.IdPregunta
					INNER JOIN [dbo].[Respuesta] R ON P.Id = R.IdPregunta
					INNER JOIN [dbo].[Usuario] U ON R.IdUsuario = U.Id
					INNER JOIN [dbo].[Departamento] D ON U.IdDepartamento = D.Id
					INNER JOIN [dbo].[Municipio] M ON U.IdMunicipio = M.Id
				WHERE 
					S.IdEncuesta = @IdEncuesta
					-- Ejecuta la función para que obtenga los Id's del parámetro que trae las secciones ------------------
					AND (@listaIdSubsecciones IS NULL OR S.Id IN (Select splitdata FROM #ListaSubSecciones)) 
					-------------------------------------------------------------------------------------------------------
					AND (@IdDepartamento IS NULL OR (U.IdDepartamento = @IdDepartamento))
					AND (@IdMunicipio IS NULL OR U.IdMunicipio = @IdMunicipio)
				ORDER BY 
					E.Id, S.Id, P.Id
			END
	END
		
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_InformesAutoevaluacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_InformesAutoevaluacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: Marzo 1 de 2017
-- Description:	Procedimiento que carga la consulta de Informe de Autoevaluación, recibe como parámetros el Id de la 
--				encuesta, el departamento y el municipio. La consulta mayor que soporta la capa de presentación se 
--				encuentra entre 28500 y 29000. Se deja el TOP 28500 para evitar rompimientos en la capa de presentación.
-- ========================================================================================================================
ALTER PROCEDURE [dbo].[C_InformesAutoevaluacion] 
	
	 @IdEncuesta		INT = NULL
	,@IdDepartamento	INT = NULL
	,@IdMunicipio		INT = NULL
AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT TOP 28500
			[E].[Titulo] AS Encuesta
			,[U].[UserName] Usuario
			,[D].[Nombre] AS Departamento
			,[M].[Nombre] AS Municipio
			,[A].[Acciones]
			,[A].[Autoevaluacion]
			,[A].[Avance]
			,[A].[Calificacion]
			,[A].[FechaCumplimiento]
			,[O].[Texto] AS Objetivo
			,[C].[Nombre] AS Categoria
			,[P].[Nombre] AS Proceso
			,[A].[Recomendacion]
			,[A].[Recursos]
			,[A].[Responsable]
		FROM 
			[dbo].[Autoevaluacion2] A
			INNER JOIN [dbo].[Encuesta] E ON [A].[IdEncuesta] = [E].[Id]
			INNER JOIN [dbo].[Objetivo] O ON [A].[IdObjetivo] = [O].[Id]
			INNER JOIN [dbo].[Categoria] C ON [O].[IdCategoria] = [C].[Id]
			INNER JOIN [dbo].[Proceso] P ON [C].[IdProceso] = [P].[Id]
			INNER JOIN [dbo].[Usuario] U ON [A].[IdUsuario] = [U].[Id]
			LEFT OUTER JOIN [dbo].[Municipio] M ON [U].[IdMunicipio] = [M].[Id]
			LEFT OUTER JOIN [dbo].[Departamento] D ON [M].[IdDepartamento] = [D].[Id]
		WHERE 
			(@IdEncuesta IS NULL OR [A].[IdEncuesta] = @IdEncuesta)
			AND (@IdDepartamento IS NULL OR [D].[Id] = @IdDepartamento)
			AND (@IdMunicipio IS NULL OR m.[Id] = @IdMunicipio)
	END
		

