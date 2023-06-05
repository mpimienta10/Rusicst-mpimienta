
---Stored Procs Plan V3

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoEstrategiaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoEstrategiaInsert] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-11-20																			  
-- Descripcion: Inserta la información de una nueva Estrategia Plan V3
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoEstrategiaInsert]
(
	@Estrategia varchar(1024)
	,@IdSeccion int
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	declare @id int

	IF (EXISTS(SELECT * FROM [PlanesMejoramiento].[Estrategias] WHERE [Estrategia]  = @Estrategia AND [IdSeccionPlanMejoramiento] = @IdSeccion))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'La estrategia ya existe en el Sistema.'
	END

	IF (LEN(@Estrategia) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'Debe escribir la estrategia.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[Estrategias] ([IdSeccionPlanMejoramiento], [Estrategia], [Activo])
			VALUES (@IdSeccion, @Estrategia, 1)			

			SELECT @respuesta = 'Se ha guardado la estrategia.'
			SELECT @estadoRespuesta = 1
			select @id = SCOPE_IDENTITY()

		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado, @id as id
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoTareaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoTareaInsert] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-11-20																			  
-- Descripcion: Inserta la información de una nueva tarea por estrategia												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoTareaInsert]
(
	@Tarea varchar(4000)
	,@IdEstrategia int
	,@Opcion varchar(100)
	,@IdPregunta int
	,@IdEtapa int
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (LEN(@Tarea) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'Debe escribir la tarea.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[Tareas] ([IdEstrategia], [IdPregunta], [IdEtapa], [Tarea], [Opcion])
			VALUES (@IdEstrategia, @IdPregunta, @IdEtapa, @Tarea, @Opcion)			

			SELECT @respuesta = 'Se ha guardado la tarea.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoTareasPlanInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoTareasPlanInsert] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-11-20																			  
-- Descripcion: Inserta la información de la tarea, responsable, fechas de ejecucion y autoevaluacion por usuario												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoTareasPlanInsert]
(
	@IdTarea INT
	,@IdUsuario INT
	,@Responsable VARCHAR(500)
	,@FechaIni DATETIME
	,@FechaFin DATETIME
	,@IdAutoEvaluacion INT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[TareasPlan] ([IdTarea], [FechaInicioEjecucion], [FechaFinEjecucion], [Responsable], [IdAutoevaluacion], [IdUsuario], [FechaDiligenciamiento])
			VALUES (@IdTarea, @FechaIni, @FechaFin, @Responsable, @IdAutoEvaluacion, @IdUsuario, GETDATE())

			SELECT @respuesta = 'Se han guardado los datos.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[D_PlanMejoramientoRespuestasV3Delete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[D_PlanMejoramientoRespuestasV3Delete] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-11-20																		 
/Descripcion: Elimina las respuestas previas de un usuario en el diligenciamiento del plan de mejoramiento v3
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[D_PlanMejoramientoRespuestasV3Delete]
(
	@IdTarea INT
	,@IdUsuario INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [PlanesMejoramiento].[TareasPlan]
				WHERE IdUsuario = @IdUsuario
				AND IdTarea IN (
					Select a.IdTarea
					FROM PlanesMejoramiento.Tareas a
					INNER JOIN PlanesMejoramiento.Estrategias b ON a.IdEstrategia = b.IdEstrategia
					INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
					WHERE c.IdPlanMejoramiento = @IdTarea
				)
		
			SELECT @respuesta = 'Se han eliminado las Respuestas.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoEnvioPlanInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoEnvioPlanInsert] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-11-20																			  
-- Descripcion: Inserta la información de la finalizacion del plan y ruta archivo por usuario												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoEnvioPlanInsert]
(
	@IdPlan INT
	,@IdUsuario INT
	,@RutaArchivo VARCHAR(500)
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF (EXISTS(SELECT * 
			FROM [PlanesMejoramiento].[EnvioPlan] 
			WHERE [IdPlan]  = @IdPlan AND [IdUsuario] = @IdUsuario))
	BEGIN

		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE
				[PlanesMejoramiento].[EnvioPlan]
			SET
				[FechaActualizacionEnvio] = GETDATE()
				,[RutaArchivo] = @RutaArchivo
			WHERE
				[IdPlan]  = @IdPlan
				AND [IdUsuario] = @IdUsuario

			SELECT @respuesta = 'Se ha Actualizado la ruta del archivo.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	END

	ELSE
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[EnvioPlan] ([IdPlan], [IdUsuario], [FechaEnvio], [FechaActualizacionEnvio], [RutaArchivo])
			VALUES (@IdPlan, @IdUsuario, GETDATE(), null, @RutaArchivo)			

			SELECT @respuesta = 'Se ha guardado el Archivo.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[D_PlanMejoramientoTareaDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[D_PlanMejoramientoTareaDelete] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-11-20																		 
/Descripcion: Elimina los datos de una tarea
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[D_PlanMejoramientoTareaDelete]
(
	@IdTarea INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[TareasPlan] a
				WHERE a.IdTarea = @IdTarea)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'Ha ocurrido un error eliminando la tarea seleccionada. La tarea ha sido seleccionada como respuesta por algún usuario.'
	END
		
	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [PlanesMejoramiento].[Tareas]
				WHERE [IdTarea] = @IdTarea		
		
			SELECT @respuesta = 'Se ha eliminado la tarea.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[D_PlanMejoramientoEstrategiaDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[D_PlanMejoramientoEstrategiaDelete] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-11-20																		 
/Descripcion: Elimina los datos de una Estrategia
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[D_PlanMejoramientoEstrategiaDelete]
(
	@IdEstrategia INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[Tareas] a
				WHERE a.[IdEstrategia] = @IdEstrategia)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'Ha ocurrido un error eliminando la Estrategia. Aún tiene tareas asociadas.'
	END

	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [PlanesMejoramiento].[Estrategias]
				WHERE [IdEstrategia] = @IdEstrategia		
		
			SELECT @respuesta = 'Se ha eliminado la estrategia.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[D_PlanMejoramientoSeccionV3Delete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[D_PlanMejoramientoSeccionV3Delete] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-11-20																		 
/Descripcion: Elimina los datos de una Seccion de un Plan de Mejoramiento
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[D_PlanMejoramientoSeccionV3Delete]
(
	@IdSeccion INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[Estrategias] a
				WHERE a.[IdSeccionPlanMejoramiento] = @IdSeccion)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'La sección no se puede eliminar. Por favor verifique que no tenga estrategias y/o tareas creadas.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ValidarActivarPlanMejoramientoV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ValidarActivarPlanMejoramientoV3] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-11-20																			 
-- Descripcion: Verifica que un plan de mejoramiento cumpla con las condiciones para ser activado
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ValidarActivarPlanMejoramientoV3]
(
	@IdPlanMejoramiento INT
)
AS
BEGIN

	DECLARE @CantidadSecciones INT
	DECLARE @CantidadSeccionesRecomendacion INT
	DECLARE @Validacion BIT 

	SELECT @CantidadSecciones = COUNT(b.IdSeccionPlanMejoramiento)
	FROM PlanesMejoramiento.PlanMejoramiento a
	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento b ON a.IdPlanMejoramiento = b.IdPlanMejoramiento
	WHERE a.IdPlanMejoramiento = @IdPlanMejoramiento
	
	SELECT @CantidadSeccionesRecomendacion = COUNT(1)
	FROM (	
			SELECT DISTINCT b.IdSeccionPlanMejoramiento
			FROM PlanesMejoramiento.PlanMejoramiento a
			INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento b ON a.IdPlanMejoramiento = b.IdPlanMejoramiento
			INNER JOIN PlanesMejoramiento.Estrategias c ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
			INNER JOIN PlanesMejoramiento.Tareas d ON c.IdEstrategia = d.IdEstrategia
			WHERE a.IdPlanMejoramiento = @IdPlanMejoramiento
		) Secciones
	
	IF (@CantidadSecciones != 0 AND @CantidadSecciones = @CantidadSeccionesRecomendacion)
		BEGIN
			SET @Validacion = 1
		END
	ELSE
		BEGIN
			SET @Validacion = 0
		END
	
	SELECT @Validacion as Validacion

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionTareasPlanMejoramiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionTareasPlanMejoramiento] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-11-20																			 
-- Descripcion: Consulta la informacion de las Tareas asignadas a una Seccion de un Plan de Mejoramiento
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerInformacionTareasPlanMejoramiento] --7
  (
	@IdSeccion int
  )
  
  as
  
  BEGIN	
		SELECT b.[IdEstrategia], d.IdPregunta, a.[IdTarea], c.IdSeccionPlanMejoramiento, 
		b.[Estrategia], c.ObjetivoGeneral, a.Opcion,
		d.NombrePregunta, a.[Tarea], c.Titulo
		FROM [PlanesMejoramiento].[Tareas] a
		inner join [PlanesMejoramiento].[Estrategias] b on a.[IdEstrategia] = b.[IdEstrategia]
		inner join [PlanesMejoramiento].[SeccionPlanMejoramiento] c on b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
		inner join [BancoPreguntas].[PreguntaModeloAnterior] e on e.IdPreguntaAnterior = a.IdPregunta
		inner join [BancoPreguntas].[Preguntas] d on d.IdPregunta = e.IdPregunta
		where c.IdSeccionPlanMejoramiento = @IdSeccion
  END


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionEstrategiasPlanes]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionEstrategiasPlanes] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-11-20																			 
-- Descripcion: Consulta la informacion de las estrategias de todos los planes de mejoramiento
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerInformacionEstrategiasPlanes]

  as
  
  BEGIN	
		SELECT d.Nombre as NombrePlan, d.FechaLimite, c.Titulo as NombreSeccion, b.[Estrategia], b.[IdEstrategia]
		FROM [PlanesMejoramiento].[Estrategias] b
		inner join [PlanesMejoramiento].[SeccionPlanMejoramiento] c on b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
		inner join [PlanesMejoramiento].[PlanMejoramiento] d on c.IdPlanMejoramiento = d.IdPlanMejoramiento
  END


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionTareasPlanes]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionTareasPlanes] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-11-20																			 
-- Descripcion: Consulta la informacion de las tareas creadas por pregunta
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionTareasPlanes] --1270980
(
	@IdPregunta INT
)
AS
BEGIN

	SELECT a.[IdTarea], a.Opcion, a.[Tarea], 
	b.[IdEstrategia], b.[Estrategia], 
	c.ObjetivoGeneral, c.IdSeccionPlanMejoramiento, 
	c.Titulo, c.Ayuda, d.IdPlanMejoramiento, d.Nombre, d.FechaLimite, 
	d.CondicionesAplicacion, e.CodigoPregunta, e.NombrePregunta, e.IdTipoPregunta
	FROM PlanesMejoramiento.[Tareas] a
	INNER JOIN PlanesMejoramiento.[Estrategias] b ON a.[IdEstrategia] = b.[IdEstrategia]
	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramiento d ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
	left outer JOIN BancoPreguntas.PreguntaModeloAnterior f ON f.IdPreguntaAnterior = a.IdPregunta
	left outer JOIN BancoPreguntas.Preguntas e ON e.IdPregunta = f.IdPregunta	
	WHERE a.[IdPregunta] = @IdPregunta
	
END


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerCantidadTareasEstrategia]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerCantidadTareasEstrategia] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-11-20																			
-- Descripcion: Consulta La cantidad de tareas que tiene una estrategia indicada
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerCantidadTareasEstrategia]
(
	@IdEstrategia INT
)

AS

BEGIN

	SELECT 
		ISNULL(COUNT(A.[IdTarea]), 0)
	FROM 
		[PlanesMejoramiento].[Tareas] A
	WHERE
		A.[IdEstrategia] = @IdEstrategia

END


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramientoV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramientoV3] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-11-20
-- Descripcion: Consulta la informacion de las Estrategias de un Plan de Mejoramiento por Usuario
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramientoV3] --8, 37, 'pruebasInterior'
(
	@IdPlanMejoramiento INT,
	@IdSeccionPlan INT,
	@IdUsuario INT
)
AS
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
	INNER JOIN dbo.Respuesta rr (NOLOCK) ON rr.IdPregunta = g.Id and RTRIM(ISNULL(rr.Valor, '')) = CASE a.Opcion WHEN 'Vacío' THEN '' WHEN 'No Vacío' THEN RTRIM(rr.Valor) ELSE RTRIM(a.Opcion) END AND rr.IdUsuario = @IdUsuario --Traer respuestas vacias y no vacias (tipos de pregunta diferentes a unico)
	--INNER JOIN dbo.Usuario usu (NOLOCK) ON usu.Id = 
	INNER JOIN PlanesMejoramiento.PlanActivacionFecha i (NOLOCK) ON i.IdPlanMejoramiento = d.IdPlanMejoramiento
	WHERE d.IdPlanMejoramiento = @IdPlanMejoramiento
	AND c.IdSeccionPlanMejoramiento = @IdSeccionPlan
	--AND usu.Id = @IdUsuario
	ORDER BY b.[IdEstrategia] ASC
	
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionTareasPlanMejoramientoV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionTareasPlanMejoramientoV3] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-11-20
-- Descripcion: Consulta la informacion de las Tareas por dilgenciar de un usuario en un plan de mejoramiento
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionTareasPlanMejoramientoV3] --1, 331, 'Unidad para las Víctimas (RUV - RNI)'
(
	@IdEstrategia INT,
	@IdUsuario INT,
	@Opcion VARCHAR(50)
)
AS
BEGIN

SELECT [IdTarea]
      ,[Tarea]
  FROM [PlanesMejoramiento].[Tareas] a
  WHERE a.IdEstrategia = @IdEstrategia
  AND a.Opcion = @Opcion
  AND a.IdTarea NOT IN (
	  
	  SELECT a.IdTarea
	  FROM [PlanesMejoramiento].[TareasPlan] a
	  INNER JOIN [PlanesMejoramiento].[Tareas] b ON a.[IdTarea] = a.[IdTarea]
	  INNER JOIN [PlanesMejoramiento].[Estrategias] c ON b.[IdEstrategia] = c.[IdEstrategia]
	  WHERE
	  b.[IdEstrategia] = @IdEstrategia
	  AND a.IdUsuario = @IdUsuario
  )

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionSeccionesPlanMejoramientoV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionSeccionesPlanMejoramientoV3] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-11-20
-- Descripcion: Consulta la informacion de las Secciones por dilgenciar en un plan de mejoramiento
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionSeccionesPlanMejoramientoV3] --11, 374
(
	@IdPlanMejoramiento INT
)
AS
BEGIN

SELECT 
	c.IdSeccionPlanMejoramiento, c.Titulo, c.Ayuda, c.ObjetivoGeneral
	FROM PlanesMejoramiento.SeccionPlanMejoramiento c  
	INNER JOIN PlanesMejoramiento.PlanMejoramiento d ON c.IdPlanMejoramiento = d.IdPlanMejoramiento

	WHERE d.IdPlanMejoramiento = @IdPlanMejoramiento
	GROUP BY c.IdSeccionPlanMejoramiento, c.Titulo, c.ObjetivoGeneral, c.Ayuda

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionTareasDiligenciadasPlanMejoramientoV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionTareasDiligenciadasPlanMejoramientoV3] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-11-20
-- Descripcion: Consulta la informacion de las Tareas diligenciadas por un usuario en un plan de mejoramiento
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionTareasDiligenciadasPlanMejoramientoV3] --8, 37, 'pruebasInterior'
(
	@IdEstrategia INT,
	@IdUsuario INT
)
AS
BEGIN

	SELECT 
      a.[IdTarea]
	  ,b.Tarea
      ,a.[FechaInicioEjecucion]
      ,a.[FechaFinEjecucion]
      ,a.[Responsable]
      ,a.[IdAutoevaluacion]
  FROM [PlanesMejoramiento].[TareasPlan] a
  INNER JOIN [PlanesMejoramiento].[Tareas] b ON a.[IdTarea] = b.[IdTarea]
  WHERE
  b.[IdEstrategia] = @IdEstrategia
  AND a.IdUsuario = @IdUsuario
	
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerEnvioPlanMejoramientoV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerEnvioPlanMejoramientoV3] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [PlanesMejoramiento].[C_ObtenerEnvioPlanMejoramientoV3] --7, 374
(
	@IdPlan INT
	,@IdUsuario INT
)

AS

BEGIN

	SELECT TOP 1
		[IdEnvioPlan]
      ,[IdPlan]
      ,[IdUsuario]
      ,[FechaEnvio]
      ,[FechaActualizacionEnvio]
      ,[RutaArchivo]
	FROM 
		[PlanesMejoramiento].[EnvioPlan]
	WHERE
		[IdPlan] = @IdPlan
		AND
		[IdUsuario] = @IdUsuario
	ORDER BY
		[IdEnvioPlan] DESC

END

GO