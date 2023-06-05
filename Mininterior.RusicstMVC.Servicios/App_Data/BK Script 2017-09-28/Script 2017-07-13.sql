--==========================================================
-- ACTUALIZA LA INFORMACION PARA EL ROL GESTION DE ROLES
--==========================================================
UPDATE [dbo].[SubRecurso] SET [IdRecurso] = 3 WHERE Id = 47

--================================================================
-- ELIMINA TODOS LOS DATOS RELACIONADOS CON BITACORA DEL SISTEMA
--================================================================
DELETE FROM TipoUsuarioRecurso WHERE IdSubRecurso = (SELECT Id FROM SubRecurso WHERE Nombre LIKE '%Bitácora del Sistema%')
DELETE FROM SubRecurso WHERE Nombre LIKE '%Bitácora del Sistema%'

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosEnSistema]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosEnSistema] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Author:			Robinson Moscoso
-- Create date:	31/01/2017
-- Description:	Procedimiento que retorna la información de todos los usuario en el sistema
--				Esto quiere decir que coloca solo los usuarios que se encuentran aprobados
-- ===========================================================================================
ALTER PROCEDURE [dbo].[C_UsuariosEnSistema] 

AS
	BEGIN
		
		SELECT
			 [c].[Nombre] Departamento
			,[b].[Nombre] Municipio
			,[a].[Nombres] Nombre 
			,[a].[UserName] NombreDeUsuario
			,[a].[Email]
			,[a].[TelefonoCelular]
			,[d].[Nombre] TipoUsuario
			,[a].[Activo]
		FROM
			[dbo].[Usuario] a
			INNER JOIN [dbo].[TipoUsuario] d ON [a].[IdTipoUsuario] = [d].[Id]
			INNER JOIN [dbo].[AspNetUsers] u ON [a].[IdUser] = [u].[Id]
			LEFT OUTER JOIN [dbo].[Municipio] b ON [a].[IdMunicipio] = [b].[Id] 
			LEFT OUTER JOIN [dbo].[Departamento] c ON [a].[IdDepartamento] = [c].[Id]

		WHERE 
			([a].[IdEstado] = 5)
		ORDER BY 
			 [Departamento]
			,[Municipio]
			,[a].[Username]
	
	END	

GO


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_PermisoUsuarioEncuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_PermisoUsuarioEncuestaInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 04/04/2017
-- Description:	Inserta un registro en la tabla Permiso Usuario Encuesta 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[I_PermisoUsuarioEncuestaInsert]
	
	 @IdUsuario			INT
	,@IdEncuesta		INT
	,@FechaFin			DATETIME
	,@UsuarioAutenticado VARCHAR(255)

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
						
						--======================================================
						-- Obtiene el ID del usuario que realiza la transacción
						--======================================================
						DECLARE @IdUsuarioTramite INT
						SELECT @IdUsuarioTramite = [Id] FROM [dbo].[Usuario] WHERE [IdUser] = (SELECT [Id] FROM [dbo].[AspNetUsers] WHERE [UserName] = @UsuarioAutenticado)

						DECLARE @FechaFinEncuesta DATETIME
						SELECT @FechaFinEncuesta = FechaFin FROM Encuesta WHERE Id = @IdEncuesta

						IF(@IdUsuarioTramite IS NOT NULL AND LEN(@IdUsuarioTramite) > 0)
							BEGIN
								--============================================================================
								-- SI LA FECHA QUE SE QUIERE COLOCAR ES MENOR A LA FECHA FINAL DE LA ENCUESTA
								--============================================================================
								IF(CAST(@FechaFinEncuesta AS DATE) > CAST(@FechaFin AS DATE))
									BEGIN
										SELECT @respuesta = 'La fecha de fin propuesta, debe ser superior a la fecha de fin (' + CONVERT(VARCHAR, @FechaFinEncuesta, 105) + ') de la encuesta'
									END
								ELSE IF ((SELECT COUNT(*) FROM [dbo].[PermisoUsuarioEncuesta] WHERE [IdUsuario] = @IdUsuario AND [IdEncuesta] = @IdEncuesta) > 0)
									BEGIN
										--==========================================================
										-- OBTIENE LA FECHA QUE TIENE LA ULTIMA EXTENSION DE TIEMPO
										--==========================================================
										SELECT TOP 1 @FechaFinEncuesta = PUE.FechaFin
										FROM PermisoUsuarioEncuesta PUE
										WHERE IdUsuario = @IdUsuario AND IdEncuesta = @IdEncuesta
										ORDER BY PUE.FechaFin DESC

										--===========================================================================
										-- VALIDA QUE LA FECHA PROPUESTA SEA SUPERIOR A LA FECHA DE EXTENSION ACTUAL
										--===========================================================================
										IF(CAST(@FechaFinEncuesta AS DATE) >= CAST(GETDATE() AS DATE))
											BEGIN
												SELECT @respuesta = 'Se encontró una Extensión de Tiempo con fecha vigente (' + CONVERT(VARCHAR, @FechaFinEncuesta, 105) + '). Para extender el plazo, esta fecha debe estar vencida.'
											END

										ELSE IF(CAST(@FechaFinEncuesta AS DATE) < CAST(GETDATE() AS DATE) AND CAST(@FechaFinEncuesta AS DATE) > CAST(@FechaFin AS DATE))
											BEGIN
												SELECT @respuesta = 'La fecha de fin propuesta, debe ser superior a la fecha de extensión de tiempo (' + CONVERT(VARCHAR, @FechaFinEncuesta, 105) + ') de la encuesta'
											END

										ELSE
											BEGIN
												INSERT INTO [dbo].[PermisoUsuarioEncuesta]([IdUsuario],[IdEncuesta],[FechaFin],[IdUsuarioTramite],[FechaTramite])
												SELECT @IdUsuario, @IdEncuesta, @FechaFin, @IdUsuarioTramite, GETDATE()

												SELECT @respuesta = 'Se ha insertado el registro'
												SELECT @estadoRespuesta = 1
											END
									END
								ELSE
									BEGIN
										INSERT INTO [dbo].[PermisoUsuarioEncuesta]([IdUsuario],[IdEncuesta],[FechaFin],[IdUsuarioTramite],[FechaTramite])
										SELECT @IdUsuario, @IdEncuesta, @FechaFin, @IdUsuarioTramite, GETDATE()

										SELECT @respuesta = 'Se ha insertado el registro'
										SELECT @estadoRespuesta = 1
									END
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

	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestasXUsuarioNoCompletadas]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_EncuestasXUsuarioNoCompletadas] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 03/05/2017
-- Description:	Selecciona la información de encuesta NO completadas por usuario
-- ============================================================================
ALTER PROCEDURE [dbo].[C_EncuestasXUsuarioNoCompletadas]
	
	@IdTipoUsuario	INT,
	@IdUsuario		INT

AS

	BEGIN

		DECLARE @TabUsuarios table
		(
			IdEncuesta	INT
		)
	
		INSERT INTO @TabUsuarios

		SELECT 
			 [RE].[IdEncuesta]
		FROM 
			[dbo].[AspNetUserRoles] R
			INNER JOIN [dbo].[AspNetUsers] AspU ON [R].[UserId] = [AspU].[Id]
			INNER JOIN [dbo].[Usuario] U ON [AspU].[Id] = [U].[IdUser]
			INNER JOIN [Roles].[RolEncuesta] RE on [RE].[IdRol] = [R].[RoleId]
		WHERE 
			[U].[Id] = @IdUsuario OR @IdTipoUsuario = (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE [Tipo] = 'ADMIN')
	
		SELECT 
			DISTINCT top 1000 [Id]
			,[Titulo]  
			,[FechaFin]
			,[Ayuda]
		FROM 
			[dbo].[Encuesta] a
			INNER JOIN @TabUsuarios b on [b].[IdEncuesta] = [a].[Id]
		WHERE 
			([a].[FechaInicio] < GETDATE() AND [a].[FechaFin] > GETDATE())
			OR EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = [a].[Id] 
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()) 
		ORDER BY
			[Titulo]	
	END
		
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestasXUsuarioCompletadas]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_EncuestasXUsuarioCompletadas] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 03/05/2017
-- Description:	Selecciona la información de encuesta completadas por usuario
-- ============================================================================
ALTER PROCEDURE [dbo].[C_EncuestasXUsuarioCompletadas]

	@IdTipoUsuario	INT,
	@IdUsuario		INT

AS

	BEGIN

		DECLARE @TabUsuarios TABLE
		(
			IdEncuesta	INT
		)
	
		INSERT INTO @TabUsuarios

		SELECT 
			 [RE].[IdEncuesta]
		FROM 
			[dbo].[AspNetUserRoles] R
			INNER JOIN [dbo].[AspNetUsers] AspU ON [R].[UserId] = [AspU].[Id]
			INNER JOIN [dbo].[Usuario] U ON [AspU].[Id] = [U].[IdUser]
			INNER JOIN [Roles].[RolEncuesta] RE on [RE].[IdRol] = [R].[RoleId]
		WHERE 
			[U].[Id] = @IdUsuario OR @IdTipoUsuario = (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE [Tipo] = 'ADMIN')
	
		SELECT 
			DISTINCT TOP 1000 [Id]
			,[Titulo]  
			,[FechaFin]
			,[Ayuda]
		FROM 
			[dbo].[Encuesta] a
			INNER JOIN @TabUsuarios b on [b].[IdEncuesta] = [a].[Id]
		WHERE 
			[a].[FechaFin] < GETDATE()
			AND NOT EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
							WHERE [p].[IdEncuesta] = [a].[Id] 
							AND [p].[IdUsuario] = @IdUsuario
							AND [p].[FechaFin] > GETDATE()) 
		ORDER BY
			[Titulo]	
	END


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ExtensionesTiempo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ExtensionesTiempo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-08																			 
-- Descripcion: Consulta la informacion de la rejilla de Extensiones de tiempo concedidas												
-- ***************************************************************************************************
ALTER PROC [dbo].[C_ExtensionesTiempo]

AS

	SELECT 
		 [PUE].[FechaFin] AS Fecha
		,[U].[UserName] AS Usuario
		,[E].[Titulo] AS Reporte
		,[UTramite].[UserName] AS Autoriza
		,[PUE].[FechaTramite]
	FROM 
		[dbo].[PermisoUsuarioEncuesta] AS PUE
		INNER JOIN [dbo].[Usuario] U ON [PUE].[IdUsuario] = [U].[Id]
		INNER JOIN [dbo].[Usuario] UTramite ON [PUE].[IdUsuarioTramite] = [UTramite].[Id]
		INNER JOIN [dbo].[Encuesta] AS E ON [PUE].IdEncuesta= [E].Id
	ORDER BY  
		[E].[Titulo], [PUE].[FechaFin] DESC

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DibujarPreguntasSeccion2]') AND type in (N'P', N'PC')) 
DROP PROCEDURE C_DibujarPreguntasSeccion2

GO

--==============================================
-- CAMBIO DE NOMBRE A LOS CONTRAINT POR DEFAULT
--==============================================
IF (EXISTS(SELECT OBJECT_NAME(OBJECT_ID) AS NameofConstraint,OBJECT_NAME(parent_object_id) AS TableName,type_desc AS Type FROM sys.objects WHERE type_desc LIKE '%CONSTRAINT' AND OBJECT_NAME(OBJECT_ID)='DF__Pregunta__EsMult__6477ECF3'))
	BEGIN
		EXEC sp_rename 'DF__Pregunta__EsMult__6477ECF3', 'DF_PreguntaEsMultiple'
	END	
	
GO

IF (EXISTS(SELECT OBJECT_NAME(OBJECT_ID) AS NameofConstraint,OBJECT_NAME(parent_object_id) AS TableName,type_desc AS Type FROM sys.objects WHERE type_desc LIKE '%CONSTRAINT' AND OBJECT_NAME(OBJECT_ID)='DF__Pregunta__EsMult__6477ECF3'))
	BEGIN
		EXEC sp_rename 'DF__Pregunta__EsObli__6383C8BA', 'DF_PreguntaEsObligatoria'
	END		

GO

IF (EXISTS(SELECT OBJECT_NAME(OBJECT_ID) AS NameofConstraint,OBJECT_NAME(parent_object_id) AS TableName,type_desc AS Type FROM sys.objects WHERE type_desc LIKE '%CONSTRAINT' AND OBJECT_NAME(OBJECT_ID)='DF__Respuesta__Fecha__72C60C4A'))
	BEGIN
		EXEC sp_rename 'DF__Respuesta__Fecha__72C60C4A', 'DF_RespuestaFecha'
	END	

GO


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ReportesXEntidadesTerritoriales]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ReportesXEntidadesTerritoriales] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--============================================================================================================
-- Autor: Robinson Moscoso																			 
-- Fecha creacion: 2017-01-25																			 
-- Descripcion: Consulta la informacion de las encuestas por entidad territorial, si se consulta gobernación, 
--				debe enciarse el municipio en cero 
-- Retorna: Result set de encuesta	
-- prueba c_ReportesXEntidadesTerritoriales 5						 
--============================================================================================================
ALTER PROC [dbo].[C_ReportesXEntidadesTerritoriales]

	@IdDepartamento INT = NULL,
	@IdMunicipio	INT = NULL  

AS

	DECLARE @IdUsuario INT

	IF(@IdMunicipio IS NULL)
		BEGIN
			SELECT TOP 1 @IdUsuario = Id FROM Usuario WHERE IdDepartamento = @IdDepartamento AND IdTipoUsuario = (SELECT Id FROM TipoUsuario WHERE Tipo = 'GOBERNACION')
		END
	ELSE 
		BEGIN
			SELECT TOP 1 @IdUsuario = Id FROM Usuario WHERE IdMunicipio = @IdMunicipio AND IdTipoUsuario = (SELECT Id FROM TipoUsuario WHERE Tipo = 'ALCALDIA')
		END

	SELECT 
		DISTINCT [e].[titulo]
		,[e].[id]
		,[e].[FechaFin]
		,[e].[Ayuda]
	FROM 
		[dbo].[Respuesta] r 
		INNER JOIN [dbo].[Pregunta] p ON [r].[IdPregunta] = [p].[Id] 
		INNER JOIN [dbo].[Usuario] u ON [r].[IdUsuario] = [u].[Id] 
		INNER JOIN [dbo].[Seccion] s ON [p].[Idseccion] = [s].[Id] 
		INNER JOIN [dbo].[Encuesta] e ON [s].[IdEncuesta]=[e].[Id]
	WHERE 
		[u].[Id] = @IdUsuario

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DibujarSeccion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarSeccion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Rafael Alba																	 
-- Fecha creacion: 2017-06-27																			 
-- Descripcion: Trae el diseño de ña encuesta por idseccion
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DibujarSeccion]
	 @IdSeccion	INT
AS
BEGIN
	/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Id]
      ,[IdSeccion]
      ,[Texto]
      ,[ColumnSpan]
      ,[RowSpan]
      ,[RowIndex]
      ,[ColumnIndex]
  FROM [dbo].[Diseno]
  WHERE IdSeccion = @IdSeccion
	ORDER BY 
		ID
  END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DibujarGlosario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarGlosario] AS'

GO
SET QUOTED_IDENTIFIER ON
GO
--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Rafael Alba																	 
-- Fecha creacion: 2017-07-10																			 
-- Descripcion: Trae el glosario a dibujar 
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DibujarGlosario]

AS

BEGIN

	SELECT 
		[Clave]
		,[Termino]
		,[Descripcion]
		,[Id]
	FROM 
		[dbo].[Glosario]
	ORDER BY Id

END
  
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_OpcionesXPregunta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_OpcionesXPregunta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 23/02/2017
-- Description:	Selecciona la información de Tipos de Usuario
-- =============================================
ALTER PROCEDURE [dbo].[C_OpcionesXPregunta] 

	@IdPregunta	 INT

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			 [Id]
			,[Valor]
			,[Texto]
			,[Orden]
		FROM
			[dbo].[Opciones]
		WHERE
			[IdPregunta] = @IdPregunta
		ORDER BY Orden

END	


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[C_DibujarEncuestaSeccionesSubsecciones]') AND TYPE in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarEncuestaSeccionesSubsecciones] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Rafael Alba																	 
-- Fecha creacion: 2017-06-16																			 
-- Descripcion: Trae el listado de secciones Y subsecciones de una encuesta para ser pintado									
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DibujarEncuestaSeccionesSubsecciones]

	 @IdEncuesta	INT

AS

BEGIN

	SELECT 
		  [Id]
		 ,[Titulo]
		 ,[SuperSeccion]
		 ,[OcultaTitulo]
		 ,[Estilos]
	FROM 
		[dbo].[Seccion] AS s
	WHERE 
		s.IdEncuesta = @IdEncuesta 
	ORDER BY 
		[SuperSeccion], Titulo

END

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[C_Salida_Departamental]') AND TYPE in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_Salida_Departamental] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[C_Salida_Departamental] 

  @departamento int,
  @encuesta     int

AS
BEGIN

	SELECT 
		DISTINCT 
		i.Divipola codigodepartamento,
		i.Nombre nombredepartamento,
		j.Divipola codigomunicipio,
		j.Nombre nombremunicipio,
		e.Id codigoencuesta,
		e.Titulo nombreencuesta,
		f.Valor respuesta,
		a.CodigoPregunta codigopregunta,
		a.NombrePregunta descripcionpregunta
	FROM
		BancoPreguntas.Preguntas a WITH (NOLOCK)
		INNER JOIN BancoPreguntas.PreguntaModeloAnterior b WITH (NOLOCK) ON a.IdPregunta = b.IdPregunta
		INNER JOIN Pregunta c WITH (NOLOCK) ON b.IdPreguntaAnterior = c.Id
		INNER JOIN Seccion d WITH (NOLOCK) ON c.IdSeccion = d.Id
		INNER JOIN Encuesta e WITH (NOLOCK) ON d.IdEncuesta = e.Id
		INNER JOIN Respuesta f WITH (NOLOCK) ON c.Id = f.IdPregunta 
		INNER JOIN Usuario g WITH (NOLOCK) ON f.IdUsuario = g.Id
		INNER JOIN Departamento i WITH (NOLOCK) ON g.IdDepartamento = i.Id
		INNER JOIN Municipio j WITH (NOLOCK) ON g.IdMunicipio = j.Id
	WHERE
		e.Id = @encuesta
		AND i.Id = @departamento
		AND e.IdTipoEncuesta = 3
		
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[C_Salida_Municipal]') AND TYPE in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_Salida_Municipal] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[C_Salida_Municipal] 

  @municipio int,
  @departamento int,
  @encuesta     int

AS
BEGIN

	SELECT 
		DISTINCT 
		i.Divipola codigodepartamento,
		i.Nombre nombredepartamento,
		j.Divipola codigomunicipio,
		j.Nombre nombremunicipio,
		e.Id codigoencuesta,
		e.Titulo nombreencuesta,
		(CASE 
			WHEN a.IdTipoPregunta = 8 THEN
			(
				CASE
					WHEN ISNUMERIC(f.Valor) = 1
						THEN f.Valor
					ELSE
						'0'
				END
			)
			ELSE f.Valor
		END) respuesta,
		k.Nombre codigotipopregunta,
		a.CodigoPregunta codigopregunta,
		a.NombrePregunta descripcionpregunta
	FROM
		BancoPreguntas.Preguntas a WITH (NOLOCK)
		INNER JOIN BancoPreguntas.PreguntaModeloAnterior b WITH (NOLOCK) ON a.IdPregunta = b.IdPregunta
		INNER JOIN Pregunta c WITH (NOLOCK) ON b.IdPreguntaAnterior = c.Id
		INNER JOIN Seccion d WITH (NOLOCK) ON c.IdSeccion = d.Id
		INNER JOIN Encuesta e WITH (NOLOCK) ON d.IdEncuesta = e.Id
		INNER JOIN Respuesta f WITH (NOLOCK) ON c.Id = f.IdPregunta 
		INNER JOIN Usuario g WITH (NOLOCK) ON f.IdUsuario = g.Id
		INNER JOIN Departamento i WITH (NOLOCK) ON g.IdDepartamento = i.Id
		INNER JOIN Municipio j WITH (NOLOCK) ON g.IdMunicipio = j.Id
		INNER JOIN TipoPregunta k WITH (NOLOCK) ON a.IdTipoPregunta = k.Id
	WHERE
		e.Id = @encuesta
		AND i.Id = @departamento
		AND j.Id = @municipio
		
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[C_Salida_Gobernacion]') AND TYPE in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_Salida_Gobernacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[C_Salida_Gobernacion] 

  @departamento int,
  @encuesta     int

AS
BEGIN

	SELECT 
		DISTINCT 
		i.Divipola codigodepartamento,
		i.Nombre nombredepartamento,
		e.Id codigoencuesta,
		e.Titulo nombreencuesta,
		(CASE 
			WHEN a.IdTipoPregunta = 8 THEN
			(
				CASE
					WHEN ISNUMERIC(f.Valor) = 1
						THEN f.Valor
					ELSE
						'0'
				END
			)
			ELSE f.Valor
		END) respuesta,
		a.CodigoPregunta codigopregunta,
		a.NombrePregunta descripcionpregunta
	FROM
		BancoPreguntas.Preguntas a WITH (NOLOCK)
		INNER JOIN BancoPreguntas.PreguntaModeloAnterior b WITH (NOLOCK) ON a.IdPregunta = b.IdPregunta
		INNER JOIN Pregunta c WITH (NOLOCK) ON b.IdPreguntaAnterior = c.Id
		INNER JOIN Seccion d WITH (NOLOCK) ON c.IdSeccion = d.Id
		INNER JOIN Encuesta e WITH (NOLOCK) ON d.IdEncuesta = e.Id
		INNER JOIN Respuesta f WITH (NOLOCK) ON c.Id = f.IdPregunta 
		INNER JOIN Usuario g WITH (NOLOCK) ON f.IdUsuario = g.Id
		INNER JOIN Departamento i WITH (NOLOCK) ON g.IdDepartamento = i.Id
		INNER JOIN Municipio j WITH (NOLOCK) ON g.IdMunicipio = j.Id
		INNER JOIN TipoPregunta k WITH (NOLOCK) ON a.IdTipoPregunta = k.Id
	WHERE
		e.Id = @encuesta
		AND i.Id = @departamento
		
END
