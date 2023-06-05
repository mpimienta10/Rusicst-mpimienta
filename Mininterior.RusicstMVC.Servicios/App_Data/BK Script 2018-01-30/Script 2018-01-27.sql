IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestaGrid]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_EncuestaGrid] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																			 
-- Modifica: Equipo de desarrollo OIM - Andrés Bonilla			
-- Fecha creacion: 2017-02-24																			 
-- Fecha modificacion: 2018-01-23										
-- Descripcion: Carga las encuestas que NO han sido borradas									
-- Modificacion: Se modifica el orden de la rejilla
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_EncuestaGrid]

AS

	SELECT 
		 [Id]
		,[Titulo]
		,[FechaInicio]
		,[FechaFin]
		,[Ayuda]
	FROM 
		[Encuesta] 
	WHERE 
		[isDeleted] = 0
	ORDER BY
		Id Desc

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Equipo de desarrollo OIM - Christian Ospina																		 
-- Modifica: Equipo de desarrollo OIM - Andrés Bonilla			
-- Fecha creacion: 2017-01-25							
-- Fecha modificacion: 2018-01-23												 
-- Descripcion: Consulta la informacion de las encuestas para ser utilizada en combos de encuestas												
-- Modificacion: Se modifica el orden de la rejilla
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--****************************************************************************************************
ALTER PROC [dbo].[C_ListaEncuesta]

	@IdTipoEncuesta INT = NULL

AS
	SELECT 
		 [Id]
		,UPPER([Titulo]) Titulo
	FROM 
		[Encuesta]
	WHERE
		[IsDeleted] = 'false'
		AND (@IdTipoEncuesta IS NULL  OR [IdTipoEncuesta] = @IdTipoEncuesta)
	ORDER BY 
		FechaInicio desc
		--Id desc--[Titulo]				


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestasXUsuarioCompletadas]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_EncuestasXUsuarioCompletadas] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Modifica: Equipo de desarrollo OIM - Andrés Bonilla			
-- Create date: 03/05/2017
-- Fecha modificacion: 2018-01-23												 
-- Description:	Selecciona la información de encuesta completadas por usuario
-- Modificacion: Se modifica el orden de la rejilla
-- ============================================================================
ALTER PROCEDURE [dbo].[C_EncuestasXUsuarioCompletadas] --3, 1

	@IdTipoUsuario	INT,
	@IdUsuario		INT

AS

	BEGIN


	if @IdTipoUsuario IN (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE ([Tipo] = 'ADMIN' OR [Tipo] = 'ANALISTA'))
	begin

	SELECT 
			DISTINCT TOP 1000 [Id]
			,[Titulo]  
			,[FechaFin]
			,[Ayuda]
		FROM 
			[dbo].[Encuesta] a
		WHERE 
			[a].[FechaFin] < GETDATE()
			AND NOT EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
							WHERE [p].[IdEncuesta] = [a].[Id] 
							AND [p].[IdUsuario] = @IdUsuario
							AND [p].[FechaFin] > GETDATE()) 
		ORDER BY
			[FechaFin] DESC

	end
	else
	begin


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
			[U].[Id] = @IdUsuario --OR @IdTipoUsuario = (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE [Tipo] = 'ADMIN')
	
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
			[FechaFin] DESC
			
			end
				
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
-- Modifica: Equipo de desarrollo OIM - Andrés Bonilla			
-- Create date: 03/05/2017
-- Fecha modificacion: 2018-01-23												 
-- Description:	Selecciona la información de encuesta NO completadas por usuario
-- Modificacion: Se modifica el orden de la rejilla
-- ============================================================================
ALTER PROCEDURE [dbo].[C_EncuestasXUsuarioNoCompletadas] --3, 1
	
	@IdTipoUsuario	INT,
	@IdUsuario		INT

AS

	BEGIN


	if @IdTipoUsuario IN (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE ([Tipo] = 'ADMIN' OR [Tipo] = 'ANALISTA'))
	begin

		SELECT 
			DISTINCT top 1000 [Id]
			,[Titulo]  
			,[FechaFin]
			,[Ayuda]
		FROM 
			[dbo].[Encuesta] a
		WHERE 
			([a].[FechaInicio] < GETDATE() AND [a].[FechaFin] > GETDATE())
			OR EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = [a].[Id] 
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()) 
		ORDER BY
			[FechaFin] DESC

	end
	else
	begin

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
			[U].[Id] = @IdUsuario --OR @IdTipoUsuario = (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE [Tipo] = 'ADMIN')
	
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
			[FechaFin] DESC	

	end

		
	END
		
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramientoV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramientoV3] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-11-20
-- Fecha modificacion: 2018-01-22
-- Descripcion: Consulta la informacion de las Estrategias de un Plan de Mejoramiento por Usuario
-- Modificación: Se modifica el procedimiento para tener en cuenta el nuevo funcionamiento de las opciones vacio y no vacio
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramientoV3]
(
	@IdPlanMejoramiento INT,
	@IdSeccionPlan INT,
	@IdUsuario INT
)
AS
BEGIN

if @IdUsuario not in (1618, 331)
BEGIN

	SELECT DISTINCT	

	b.[IdEstrategia], b.[Estrategia], 
	a.Opcion,
	c.ObjetivoGeneral, c.IdSeccionPlanMejoramiento, c.Titulo, c.Ayuda, 
	d.IdPlanMejoramiento, d.Nombre, d.FechaLimite, d.CondicionesAplicacion, 
	CONVERT(VARCHAR, g.Id) AS CodigoPregunta, g.Texto AS NombrePregunta, tp.Nombre AS TipoPregunta, 
	
	ISNULL((select top 1 xx.Titulo from dbo.Seccion xx where xx.Id = a.IdEtapa), '') as EtapaNombre,
	a.IdEtapa as IdEtapa

	FROM PlanesMejoramiento.Tareas a (NOLOCK)
	INNER JOIN PlanesMejoramiento.Estrategias b (NOLOCK) ON a.[IdEstrategia] = b.[IdEstrategia]
	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c (NOLOCK) ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramiento d (NOLOCK) ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta k (NOLOCK) ON k.IdPlanMejoriamiento = d.IdPlanMejoramiento 
	INNER JOIN dbo.Pregunta g (NOLOCK) ON g.Id = a.IdPregunta
	INNER JOIN dbo.TipoPregunta tp (NOLOCK) ON tp.Id = g.IdTipoPregunta
	INNER JOIN dbo.Seccion h (NOLOCK) ON h.Id = g.IdSeccion and h.IdEncuesta = k.IdEncuesta 	
	
	left outer JOIN dbo.Respuesta rr (NOLOCK) ON rr.IdPregunta = g.Id and rr.Valor = CASE tp.Id WHEN 11 THEN a.Opcion ELSE CASE a.Opcion WHEN 'Vacío' THEN NULL ELSE rr.Valor END END AND rr.IdUsuario = @IdUsuario --Traer respuestas vacias y no vacias (tipos de pregunta diferentes a unico)
	INNER JOIN PlanesMejoramiento.PlanActivacionFecha i (NOLOCK) ON i.IdPlanMejoramiento = d.IdPlanMejoramiento
	WHERE d.IdPlanMejoramiento = @IdPlanMejoramiento
	AND c.IdSeccionPlanMejoramiento = @IdSeccionPlan
	AND 
	(

		(tp.Id <> 11 AND (
		(a.Opcion = 'Vacío' AND (NOT EXISTS(select top 1 1 from dbo.Respuesta xx where xx.IdPregunta = g.Id AND xx.IdUsuario = @IdUsuario))) 
		OR
		(a.Opcion <> 'Vacío' AND (EXISTS(select top 1 1 from dbo.Respuesta xx where xx.IdPregunta = g.Id AND xx.IdUsuario = @IdUsuario)))
		)) OR (tp.Id = 11 AND rr.Valor = a.Opcion)
	)
	ORDER BY b.[IdEstrategia] ASC
	
	END
	ELSE
	BEGIN

		SELECT DISTINCT	

	b.[IdEstrategia], b.[Estrategia], 
	a.Opcion,
	c.ObjetivoGeneral, c.IdSeccionPlanMejoramiento, c.Titulo, c.Ayuda, 
	d.IdPlanMejoramiento, d.Nombre, d.FechaLimite, d.CondicionesAplicacion, 
	CONVERT(VARCHAR, g.Id) AS CodigoPregunta, g.Texto AS NombrePregunta, tp.Nombre AS TipoPregunta, 
	
	ISNULL((select top 1 xx.Titulo from dbo.Seccion xx where xx.Id = a.IdEtapa), '') as EtapaNombre,
	a.IdEtapa as IdEtapa

	FROM PlanesMejoramiento.Tareas a (NOLOCK)
	INNER JOIN PlanesMejoramiento.Estrategias b (NOLOCK) ON a.[IdEstrategia] = b.[IdEstrategia]
	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c (NOLOCK) ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramiento d (NOLOCK) ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta k (NOLOCK) ON k.IdPlanMejoriamiento = d.IdPlanMejoramiento 
	INNER JOIN dbo.Pregunta g (NOLOCK) ON g.Id = a.IdPregunta
	INNER JOIN dbo.TipoPregunta tp (NOLOCK) ON tp.Id = g.IdTipoPregunta
	INNER JOIN dbo.Seccion h (NOLOCK) ON h.Id = g.IdSeccion and h.IdEncuesta = k.IdEncuesta 	
	
	left outer JOIN dbo.Respuesta rr (NOLOCK) ON rr.IdPregunta = g.Id and rr.Valor = CASE tp.Id WHEN 11 THEN a.Opcion ELSE CASE a.Opcion WHEN 'Vacío' THEN NULL ELSE rr.Valor END END AND rr.IdUsuario = @IdUsuario --Traer respuestas vacias y no vacias (tipos de pregunta diferentes a unico)
	--INNER JOIN PlanesMejoramiento.PlanActivacionFecha i (NOLOCK) ON i.IdPlanMejoramiento = d.IdPlanMejoramiento
	WHERE d.IdPlanMejoramiento = @IdPlanMejoramiento
	AND c.IdSeccionPlanMejoramiento = @IdSeccionPlan
	AND 
	(
		(tp.Id <> 11 AND (
		(a.Opcion = 'Vacío' AND (NOT EXISTS(select top 1 1 from dbo.Respuesta xx where xx.IdPregunta = g.Id AND xx.IdUsuario = @IdUsuario))) 
		OR
		(a.Opcion <> 'Vacío' AND (EXISTS(select top 1 1 from dbo.Respuesta xx where xx.IdPregunta = g.Id AND xx.IdUsuario = @IdUsuario)))
		)) OR (tp.Id = 11 AND rr.Valor = a.Opcion)
	)

	ORDER BY b.[IdEstrategia] ASC

	END
END