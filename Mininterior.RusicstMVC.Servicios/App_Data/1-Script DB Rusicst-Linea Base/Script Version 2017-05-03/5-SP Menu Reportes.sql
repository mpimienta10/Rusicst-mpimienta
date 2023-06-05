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
		(@idDepartamento IS NULL OR [u].[IdDepartamento] = @IdDepartamento) 
		AND (@idMunicipio IS NULL OR [u].[Idmunicipio] = @IdMunicipio)

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Roles].[ListadoEncuestasPorUsuarioCompletadas]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [Roles].[ListadoEncuestasPorUsuario_Completadas]
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
			IdRol		INT,
			IdEncuesta	INT,
			IdUsuario	INT
		)
	
		INSERT INTO @TabUsuarios

		SELECT 
			 [a].[IdRol]
			,[b].[IdEncuesta]
			,[a].[IdUsuario]
		FROM 
			[Roles].[UsuarioRol] a
			INNER JOIN [Roles].[RolEncuesta] b on [b].[IdRol] = [a].[IdRol]
		WHERE 
			[a].[IdUsuario] = @IdUsuario OR @IdTipoUsuario = (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE [Nombre] = 'ADMIN')
	
		SELECT 
			DISTINCT top 1000 [Id]
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
	END

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[Roles].[ListadoEncuestasPorUsuario_NoCompletadas]') AND type in (N'P', N'PC'))
BEGIN
	DROP PROCEDURE [Roles].[ListadoEncuestasPorUsuario_NoCompletadas]
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
			IdRol		INT,
			IdEncuesta	INT,
			IdUsuario	INT
		)
	
		INSERT INTO @TabUsuarios

		SELECT 
			 [a].[IdRol]
			,[b].[IdEncuesta]
			,[a].[IdUsuario]
		FROM 
			[Roles].[UsuarioRol] a
			INNER JOIN [Roles].[RolEncuesta] b on [b].[IdRol] = [a].[IdRol]
		WHERE 
			[a].[IdUsuario] = @IdUsuario OR @IdTipoUsuario = (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE [Nombre] = 'ADMIN')
	
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
	END
		

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_GlosarioConsultar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_GlosarioConsultar] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Robinson Moscoso																			 
-- Fecha creacion: 2017-01-25																			 
-- Descripcion: Consulta la informacion del glosario												
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--****************************************************************************************************
ALTER PROC [dbo].[C_GlosarioConsultar]

		 @Clave VARCHAR(511) = NULL
		,@Termino VARCHAR(511) = NULL
		,@Descripcion VARCHAR(MAX) = NULL

AS
	SELECT
		[Clave], 
		[Termino], 
		[Descripcion]
	FROM 
		Glosario
	WHERE
		(@Clave	IS NULL	OR Clave = @Clave)
		AND (@Termino IS NULL OR Termino LIKE '%'+@Termino+'%')
		AND (@Descripcion IS NULL OR Descripcion LIKE '%'+@Descripcion+'%')
				