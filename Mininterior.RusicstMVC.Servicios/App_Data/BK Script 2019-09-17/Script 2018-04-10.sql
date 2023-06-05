/*****************************************************************************************************
* esto es para correr en la base de datos donde se tiene el log
*****************************************************************************************************/
SET IDENTITY_INSERT [dbo].[Category] ON 
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (332, N'Crear Seguimiento Plan Mejoramiento', 200)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (333, N'Editar Seguimiento Plan Mejoramiento', 201)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (334, N'Eliminar Seguimiento Plan Mejoramiento', 202)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (335, N'Crear Estado Accion Seguimiento Plan', 203)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (336, N'Editar Estado Accion Seguimiento Plan', 204)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (337, N'Eliminar Estado Accion Seguimiento Plan', 205)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (338, N'Crear Respuesta Seguimiento Plan', 206)
SET IDENTITY_INSERT [dbo].[Category] OFF


/*****************************************************************************************************
* esto es para correr en la base de datos normal
*****************************************************************************************************/
---Tablas Nuevas
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[EstadosAcciones]')) 
BEGIN
	CREATE TABLE [PlanesMejoramiento].[EstadosAcciones](
		[IdEstadoAccion] [int] IDENTITY(1,1) NOT NULL,
		[EstadoAccion] [varchar](100) NOT NULL,
		[Activo] [bit] NOT NULL,
	 CONSTRAINT [PK_EstadosAcciones] PRIMARY KEY CLUSTERED 
	(
		[IdEstadoAccion] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[PlanMejoramientoSeguimiento]')) 
BEGIN

	CREATE TABLE [PlanesMejoramiento].[PlanMejoramientoSeguimiento](
		[IdPlanSeguimiento] [int] IDENTITY(1,1) NOT NULL,
		[IdPlanMejoramiento] [int] NOT NULL,
		[NumeroSeguimiento] [int] NOT NULL,
		[MensajeSeguimiento] [varchar](2000) NULL,
		[FechaInicio] [datetime] NOT NULL,
		[FechaFin] [datetime] NOT NULL,
		[Activo] [bit] NOT NULL,
	 CONSTRAINT [PK_PlanMejoramientoSeguimiento] PRIMARY KEY CLUSTERED 
	(
		[IdPlanSeguimiento] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [PlanesMejoramiento].[PlanMejoramientoSeguimiento]  WITH CHECK ADD  CONSTRAINT [FK_PlanMejoramientoSeguimiento_PlanMejoramiento] FOREIGN KEY([IdPlanMejoramiento])
	REFERENCES [PlanesMejoramiento].[PlanMejoramiento] ([IdPlanMejoramiento])
	
	ALTER TABLE [PlanesMejoramiento].[PlanMejoramientoSeguimiento] CHECK CONSTRAINT [FK_PlanMejoramientoSeguimiento_PlanMejoramiento]

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[SeguimientoPlanMejoramiento]')) 
BEGIN

	CREATE TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento](
		[IdSeguimientoAccion] [int] IDENTITY(1,1) NOT NULL,
		[IdPlanSeguimiento] [int] NOT NULL,
		[IdAccion] [int] NOT NULL,
		[IdAccionPlan] [int] NOT NULL,
		[IdUsuario] [int] NOT NULL,
		[IdEstadoAccion] [int] NOT NULL,
		[DescripcionEstado] [varchar](500) NULL,
		[IdAutoevaluacion] [int] NOT NULL,
		[CoincideRusicst] [bit] NOT NULL,
		[FechaSeguimiento] [datetime] NOT NULL,
	 CONSTRAINT [PK_SeguimientoPlanMejoramiento] PRIMARY KEY CLUSTERED 
	(
		[IdSeguimientoAccion] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	 CONSTRAINT [IX_SeguimientoPlanMejoramiento] UNIQUE NONCLUSTERED 
	(
		[IdAccionPlan] ASC,
		[IdUsuario] ASC,
		[IdPlanSeguimiento] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	
	ALTER TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento]  WITH CHECK ADD  CONSTRAINT [FK_SeguimientoPlanMejoramiento_Autoevaluacion] FOREIGN KEY([IdAutoevaluacion])
	REFERENCES [PlanesMejoramiento].[Autoevaluacion] ([IdAutoevaluacion])
	
	ALTER TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento] CHECK CONSTRAINT [FK_SeguimientoPlanMejoramiento_Autoevaluacion]
	
	ALTER TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento]  WITH CHECK ADD  CONSTRAINT [FK_SeguimientoPlanMejoramiento_EstadosAcciones] FOREIGN KEY([IdEstadoAccion])
	REFERENCES [PlanesMejoramiento].[EstadosAcciones] ([IdEstadoAccion])
	
	ALTER TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento] CHECK CONSTRAINT [FK_SeguimientoPlanMejoramiento_EstadosAcciones]
	
	ALTER TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento]  WITH CHECK ADD  CONSTRAINT [FK_SeguimientoPlanMejoramiento_PlanMejoramientoSeguimiento] FOREIGN KEY([IdPlanSeguimiento])
	REFERENCES [PlanesMejoramiento].[PlanMejoramientoSeguimiento] ([IdPlanSeguimiento])
	
	ALTER TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento] CHECK CONSTRAINT [FK_SeguimientoPlanMejoramiento_PlanMejoramientoSeguimiento]
	
	ALTER TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento]  WITH CHECK ADD  CONSTRAINT [FK_SeguimientoPlanMejoramiento_Tareas] FOREIGN KEY([IdAccion])
	REFERENCES [PlanesMejoramiento].[Tareas] ([IdTarea])
	
	ALTER TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento] CHECK CONSTRAINT [FK_SeguimientoPlanMejoramiento_Tareas]
	
	ALTER TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento]  WITH CHECK ADD  CONSTRAINT [FK_SeguimientoPlanMejoramiento_TareasPlan] FOREIGN KEY([IdAccionPlan])
	REFERENCES [PlanesMejoramiento].[TareasPlan] ([IdTareaPlan])
	
	ALTER TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento] CHECK CONSTRAINT [FK_SeguimientoPlanMejoramiento_TareasPlan]
	
	ALTER TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento]  WITH CHECK ADD  CONSTRAINT [FK_SeguimientoPlanMejoramiento_Usuario] FOREIGN KEY([IdUsuario])
	REFERENCES [dbo].[Usuario] ([Id])
	
	ALTER TABLE [PlanesMejoramiento].[SeguimientoPlanMejoramiento] CHECK CONSTRAINT [FK_SeguimientoPlanMejoramiento_Usuario]
	
END

GO

---Columnas Nuevas
IF  NOT EXISTS (select 1 from sys.columns where Name = N'IdSeguimiento' and Object_ID = Object_ID(N'[PlanesMejoramiento].[EnvioPlan]'))
BEGIN
	ALTER TABLE [PlanesMejoramiento].[EnvioPlan]
	ADD IdSeguimiento INT NULL
END

GO

IF  NOT EXISTS (select 1 from sys.columns where Name = N'TipoEnvio' and Object_ID = Object_ID(N'[PlanesMejoramiento].[EnvioPlan]'))
BEGIN
	ALTER TABLE [PlanesMejoramiento].[EnvioPlan]
	ADD TipoEnvio VARCHAR(5) NOT NULL DEFAULT('P')
END

GO

IF  NOT EXISTS (select 1 from sys.columns where Name = N'AsuntoEnvioSP' and Object_ID = Object_ID(N'dbo.Sistema'))
BEGIN
	ALTER TABLE [dbo].[Sistema] ADD
	AsuntoEnvioSP varchar(255) NULL
END

GO

IF  NOT EXISTS (select 1 from sys.columns where Name = N'PlantillaEmailConfirmacionSeguimientoPlan' and Object_ID = Object_ID(N'dbo.Sistema'))
BEGIN
	ALTER TABLE [dbo].[Sistema] ADD
	PlantillaEmailConfirmacionSeguimientoPlan varchar(MAX) NULL
END

GO

---SPS

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionEstadosAcciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionEstadosAcciones] AS'
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla				
-- Fecha creacion: 2018-03-15
-- Descripcion: Consulta la informacion de los estados de acciones para el seguimiento de un plan de mejoramiento
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerInformacionEstadosAcciones]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		[IdEstadoAccion]
		,[EstadoAccion]
		,[Activo]
	FROM 
		[PlanesMejoramiento].[EstadosAcciones]

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionSeguimientosPlanMejoramiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionSeguimientosPlanMejoramiento] AS'
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla				
-- Fecha creacion: 2018-03-15
-- Descripcion: Consulta la informacion de los seguimientos que tiene un plan de mejoramiento creados
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerInformacionSeguimientosPlanMejoramiento]
(
	@IdPlan INT
)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		[IdPlanSeguimiento]
		,B.[IdPlanMejoramiento]
		,B.Nombre AS NombrePlan
		,[NumeroSeguimiento]
		,[MensajeSeguimiento]
		,[FechaInicio]
		,[FechaFin]
		,[Activo]
	FROM 
		[PlanesMejoramiento].[PlanMejoramientoSeguimiento] A
		INNER JOIN
			PlanesMejoramiento.PlanMejoramiento B 
				ON A.IdPlanMejoramiento = B.IdPlanMejoramiento
	WHERE
		A.IdPlanMejoramiento = @IdPlan

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[D_PlanMejoramientoEstadoAccionDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[D_PlanMejoramientoEstadoAccionDelete] AS'
GO
/****************************************************************************************************
/Autor: Grupo Desarrollo OIM - Andrés Bonilla																			 
/Fecha creacion: 2018-03-15																 
/Descripcion: Elimina los datos de un estado acción
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[D_PlanMejoramientoEstadoAccionDelete]
(
	@IdEstadoAccion INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[SeguimientoPlanMejoramiento] a
				WHERE a.IdEstadoAccion = @IdEstadoAccion)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'Ha ocurrido un error eliminando el estado de la acción. Ya existen respuestas asociadas.'
	END

	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [PlanesMejoramiento].[EstadosAcciones]
				WHERE [IdEstadoAccion] = @IdEstadoAccion		
		
			SELECT @respuesta = 'Se ha eliminado el nombre del estado de la acción.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[U_PlanMejoramientoEstadoAccionUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[U_PlanMejoramientoEstadoAccionUpdate] AS'
GO

/****************************************************************************************************
/Autor: Grupo Desarrollo OIM - Andrés Bonilla
/Fecha creacion: 2018-02-15																 
/Descripcion: Actualiza los datos de un seguimiento del plan de mejoramiento
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[U_PlanMejoramientoEstadoAccionUpdate]
(
	@IdEstadoAccion INT
	,@EstadoAccion VARCHAR(200)
	,@Activo BIT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (NOT EXISTS(SELECT * FROM [PlanesMejoramiento].[EstadosAcciones] WHERE [IdEstadoAccion] = @IdEstadoAccion))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El estado de la acción a actualizar no existe.'
	END

	IF (LEN(@EstadoAccion) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El nombre del estado de la acción no puede ir vacío.'
	END
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE 
				[PlanesMejoramiento].[EstadosAcciones]
			SET
				[EstadoAccion] = @EstadoAccion,
				[Activo] = @Activo 
			WHERE
				[IdEstadoAccion] = @IdEstadoAccion

		SELECT @respuesta = 'Se ha editado el nombre del estado de la acción.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoEstadoAccionInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoEstadoAccionInsert] AS'
GO

--*****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla		
-- Fecha creacion: 2018-03-15																			  
-- Descripcion: Inserta la información de un nuevo Estado de seguimiento de Plan de Mejoramiento
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoEstadoAccionInsert]
(
	@EstadoAccion VARCHAR(2000)
	,@Activo BIT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	declare @id int

	IF (EXISTS(SELECT * FROM [PlanesMejoramiento].[EstadosAcciones] WHERE [EstadoAccion] = @EstadoAccion AND [Activo] = 1))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El estado acción indicado ya existe en el Sistema.'
	END

	IF (LEN(@EstadoAccion) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'Debe escribir el nombre del estado de la acción.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[EstadosAcciones] ([EstadoAccion],[Activo])
			VALUES (@EstadoAccion, @Activo)

			SELECT @respuesta = 'Se ha guardado el estado de la acción.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[D_PlanMejoramientoSeguimientoDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[D_PlanMejoramientoSeguimientoDelete] AS'
GO
/****************************************************************************************************
/Autor: Grupo Desarrollo OIM - Andrés Bonilla																			 
/Fecha creacion: 2018-03-15																 
/Descripcion: Elimina los datos de un seguimiento de plan de mejoramiento
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[D_PlanMejoramientoSeguimientoDelete]
(
	@IdPlanSeguimiento INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[SeguimientoPlanMejoramiento] a
				WHERE a.IdPlanSeguimiento = @IdPlanSeguimiento)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'Ha ocurrido un error eliminando el seguimiento de plan de mejoramiento. Ya existen respuestas asociadas a dicho seguimiento.'
	END

	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [PlanesMejoramiento].[PlanMejoramientoSeguimiento]
				WHERE [IdPlanSeguimiento] = @IdPlanSeguimiento		
		
			SELECT @respuesta = 'Se ha eliminado el seguimiento del plan de mejoramiento.'
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[U_PlanMejoramientoSeguimientoUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[U_PlanMejoramientoSeguimientoUpdate] AS'
GO
/****************************************************************************************************
/Autor: Grupo Desarrollo OIM - Andrés Bonilla
/Fecha creacion: 2018-02-15																 
/Descripcion: Actualiza los datos de un seguimiento del plan de mejoramiento
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[U_PlanMejoramientoSeguimientoUpdate]
(
	@IdSeguimientoPlan INT
	,@NumeroSeguimiento INT
	,@MensajeSeguimiento VARCHAR(2000)
	,@FechaInicio DATETIME
	,@FechaFin DATETIME
	,@Activo BIT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (NOT EXISTS(SELECT * FROM [PlanesMejoramiento].[PlanMejoramientoSeguimiento] WHERE [IdPlanSeguimiento] = @IdSeguimientoPlan))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El seguimiento del plan de mejoramiento a actualizar no existe.'
	END

	IF (LEN(@MensajeSeguimiento) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El mensaje del seguimiento no puede ir vacío.'
	END
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE 
				[PlanesMejoramiento].[PlanMejoramientoSeguimiento]
			SET
				[NumeroSeguimiento] = @NumeroSeguimiento,
				[MensajeSeguimiento] = @MensajeSeguimiento,
				[FechaInicio] = CONVERT(DATE, @FechaInicio),
				[FechaFin] = DATEADD(MINUTE, -1, DATEADD(DAY, 1, CONVERT(DATETIME, CONVERT(DATE, @FechaFin)))),
				[Activo] = @Activo 
			WHERE
				[IdPlanSeguimiento] = @IdSeguimientoPlan

		SELECT @respuesta = 'Se ha editado el seguimiento del plan de mejoramiento.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoSeguimientoInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoSeguimientoInsert] AS'
GO
--*****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla		
-- Fecha creacion: 2018-03-15																			  
-- Descripcion: Inserta la información de un nuevo Seguimiento a un Plan de Mejoramiento
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoSeguimientoInsert]
(
	@IdPlan INT
	,@NumeroSeguimiento INT
	,@MensajeSeguimiento VARCHAR(2000)
	,@FechaInicio DATETIME
	,@FechaFin DATETIME
	,@Activo BIT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	declare @id int

	IF (EXISTS(SELECT * FROM [PlanesMejoramiento].[PlanMejoramientoSeguimiento] WHERE [IdPlanMejoramiento]  = @IdPlan AND [NumeroSeguimiento] = @NumeroSeguimiento AND [Activo] = 1))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El seguimiento indicado ya existe en el Sistema.'
	END

	IF (LEN(@MensajeSeguimiento) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'Debe escribir el mensaje para el seguimiento.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[PlanMejoramientoSeguimiento] ([IdPlanMejoramiento],[NumeroSeguimiento],[MensajeSeguimiento],[FechaInicio],[FechaFin],[Activo])
			VALUES (@IdPlan, @NumeroSeguimiento, @MensajeSeguimiento, CONVERT(DATE, @FechaInicio), DATEADD(MINUTE, -1, DATEADD(DAY, 1, CONVERT(DATETIME, CONVERT(DATE, @FechaFin)))), @Activo)

			SELECT @respuesta = 'Se ha guardado el seguimiento del plan de mejoramiento.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ValidarPermisoGuardadoSeguimientoPlan]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ValidarPermisoGuardadoSeguimientoPlan] AS'
GO
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2018-04-10																			 
-- Descripcion: Retorna el resultado (BIT) de la validacion del usuario permitido para contestar
--				el seguimiento de plan de mejoramiento indicado en el parametro
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ValidarPermisoGuardadoSeguimientoPlan]
(
	@idUsuario INT
	,@idPlan INT
	,@idSeguimiento INT
)

AS

BEGIN

SET NOCOUNT ON;

	DECLARE @fecha DATETIME
	DECLARE @valido BIT

	SET @fecha = GETDATE()

	SET @valido = 0

	---Verificamos si el Plan aún está habilitado para contestar
	SELECT 
		@valido = 1 
	FROM 
		PlanesMejoramiento.PlanMejoramientoSeguimiento 
	WHERE 
		IdPlanSeguimiento = @idSeguimiento
		AND 
			CONVERT(VARCHAR, [FechaInicio], 101) <= CONVERT(VARCHAR, @fecha , 101)
		AND 
			CONVERT(VARCHAR, [FechaFin] , 101) >= CONVERT(VARCHAR, @fecha , 101)

	--Si no está habilitado verificamos las Extensiones de tiempo del Usuario
	IF @valido = 0
	BEGIN

	SELECT 
		@valido = 1 
	FROM 
		[dbo].[PermisoUsuarioEncuesta] 
	WHERE 
		IdUsuario = @idUsuario 
		AND 
			IdEncuesta = @idSeguimiento 
		AND
			CONVERT(VARCHAR, FechaFin, 101) >= CONVERT(VARCHAR, @fecha , 101)
		AND
			IdTipoExtension = 6

	END


	SELECT 
		@valido AS UsuarioHabilitado

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerDatosObjetivosSeguimientoPlanV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerDatosObjetivosSeguimientoPlanV3] AS'
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla				
-- Fecha creacion: 2018-04-05
-- Descripcion: Consulta la informacion de los objetivos grales a pintar en el seguimiento de una seccion
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerDatosObjetivosSeguimientoPlanV3]
(
	@IdSeccion INT
	,@IdUsuario INT
)
AS
BEGIN

	SELECT DISTINCT
		d.IdObjetivoGeneral
		,d.ObjetivoGeneral
		,c.IdEstrategia
		,c.Estrategia	

	FROM PlanesMejoramiento.TareasPlan a
	INNER JOIN 
		PlanesMejoramiento.Tareas b ON b.IdTarea = a.IdTarea
	INNER JOIN 
		PlanesMejoramiento.Estrategias c ON c.IdEstrategia = b.IdEstrategia
	INNER JOIN 
		PlanesMejoramiento.ObjetivosGenerales d ON d.IdObjetivoGeneral = c.IdObjetivoGeneral
	INNER JOIN 
		PlanesMejoramiento.SeccionPlanMejoramiento e ON e.IdSeccionPlanMejoramiento = d.IdSeccionPlan
	WHERE 
		a.IdUsuario = @IdUsuario
		AND
		e.IdSeccionPlanMejoramiento = @IdSeccion

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionSeguimientoPlanV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionSeguimientoPlanV3] AS'
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla				
-- Fecha creacion: 2018-04-05
-- Descripcion: Consulta la informacion del seguimiento (mensaje, fechas, etc..) de un plan de mejoramiento
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerInformacionSeguimientoPlanV3]
(
	@IdSeguimiento INT
)

AS
BEGIN
	
	SELECT
		IdPlanSeguimiento AS IdSeguimiento
		,a.IdPlanMejoramiento AS IdPlan
		,NumeroSeguimiento
		,MensajeSeguimiento
		,FechaInicio
		,FechaFin
		,CONVERT(VARCHAR, FechaInicio, 101) + ' - ' + CONVERT(VARCHAR, FechaFin, 101) AS FechaSeguimiento
		,b.Nombre
	FROM 
		PlanesMejoramiento.PlanMejoramientoSeguimiento a
	INNER JOIN
		PlanesMejoramiento.PlanMejoramiento b on b.IdPlanMejoramiento = a.IdPlanMejoramiento
	WHERE
		IdPlanSeguimiento = @IdSeguimiento
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoSeguimientoAccionInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoSeguimientoAccionInsert] AS'
GO

--*****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla		
-- Fecha creacion: 2018-04-09																		  
-- Descripcion: Inserta O actualiza la información de la respuesta del seguimiento de una accion del plan de mejoramiento
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoSeguimientoAccionInsert]
(
	@IdSeguimiento INT
	,@IdAccion INT
	,@IdAccionPlan INT
	,@IdUsuario INT
	,@IdEstadoAccion INT
	,@DescripcionEstado VARCHAR(2000)
	,@IdAutoevaluacion INT
	,@CoincideRusicst BIT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF (NOT EXISTS(SELECT * FROM [PlanesMejoramiento].[PlanMejoramientoSeguimiento] WHERE [IdPlanSeguimiento] = @IdSeguimiento AND [Activo] = 1))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El seguimiento indicado NO existe en el Sistema.'
	END
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			
			IF(EXISTS(SELECT TOP 1 * FROM [PlanesMejoramiento].[SeguimientoPlanMejoramiento] WHERE IdPlanSeguimiento = @IdSeguimiento AND IdAccionPlan = @IdAccionPlan AND IdUsuario = @IdUsuario))
			BEGIN

				UPDATE 
					[PlanesMejoramiento].[SeguimientoPlanMejoramiento]
				SET
					IdEstadoAccion = @IdEstadoAccion
					,DescripcionEstado = @DescripcionEstado
					,IdAutoevaluacion = @IdAutoevaluacion
					,FechaSeguimiento = GETDATE()
					,CoincideRusicst = @CoincideRusicst
				WHERE
					IdPlanSeguimiento = @IdSeguimiento 
					AND 
						IdAccionPlan = @IdAccionPlan 
					AND 
						IdUsuario = @IdUsuario

			END
			ELSE
			BEGIN
				INSERT INTO [PlanesMejoramiento].[SeguimientoPlanMejoramiento] ([IdPlanSeguimiento], [IdAccion], [IdAccionPlan], [IdUsuario], [IdEstadoAccion], [DescripcionEstado], [IdAutoevaluacion], [CoincideRusicst], [FechaSeguimiento])
				VALUES (@IdSeguimiento, @IdAccion, @IdAccionPlan, @IdUsuario, @IdEstadoAccion, @DescripcionEstado, @IdAutoevaluacion, @CoincideRusicst, GETDATE())
			END		

			SELECT @respuesta = 'Se ha guardado el seguimiento de la accion indicada'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerDatosAccionesSeguimientoPlanV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerDatosAccionesSeguimientoPlanV3] AS'
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla				
-- Fecha creacion: 2018-04-05
-- Descripcion: Consulta la informacion de las acciones a pintar en el seguimiento de una seccion
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerDatosAccionesSeguimientoPlanV3]
(
	@IdObjetivo INT
	,@IdUsuario INT
	,@IdSeguimiento INT
)
AS
BEGIN

	SELECT 
		d.IdObjetivoGeneral
		,d.ObjetivoGeneral
		,c.IdEstrategia
		,c.Estrategia 
		,b.IdTarea
		,b.Tarea AS Accion
		,a.FechaInicioEjecucion
		,a.FechaFinEjecucion
		,a.IdTareaPlan
		,e.IdSeccionPlanMejoramiento
		,e.IdPlanMejoramiento
		,e.Titulo

		,f.IdSeguimientoAccion
		,f.IdPlanSeguimiento
		,f.IdAutoevaluacion
		,f.IdEstadoAccion
		,g.EstadoAccion
		,f.DescripcionEstado
		,f.CoincideRusicst
	FROM PlanesMejoramiento.TareasPlan a
	INNER JOIN 
		PlanesMejoramiento.Tareas b ON b.IdTarea = a.IdTarea
	INNER JOIN 
		PlanesMejoramiento.Estrategias c ON c.IdEstrategia = b.IdEstrategia
	INNER JOIN 
		PlanesMejoramiento.ObjetivosGenerales d ON d.IdObjetivoGeneral = c.IdObjetivoGeneral
	INNER JOIN 
		PlanesMejoramiento.SeccionPlanMejoramiento e ON e.IdSeccionPlanMejoramiento = d.IdSeccionPlan

	LEFT OUTER JOIN PlanesMejoramiento.SeguimientoPlanMejoramiento f ON f.IdUsuario = a.IdUsuario AND f.IdAccionPlan = a.IdTareaPlan AND f.IdPlanSeguimiento = @IdSeguimiento
	LEFT OUTER JOIN PlanesMejoramiento.EstadosAcciones g ON g.IdEstadoAccion = f.IdEstadoAccion
	WHERE 
		a.IdUsuario = @IdUsuario
		AND
		d.IdObjetivoGeneral = @IdObjetivo

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionSeccionesSeguimientoPlanV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionSeccionesSeguimientoPlanV3] AS'
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla				
-- Fecha creacion: 2018-04-05
-- Descripcion: Consulta la informacion de las secciones a pintar de un usuario en un plan especifico
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerInformacionSeccionesSeguimientoPlanV3]
(
	@IdPlan INT
	,@IdUsuario INT
)

AS
BEGIN


	SELECT DISTINCT
		e.IdSeccionPlanMejoramiento
		,e.IdPlanMejoramiento
		,e.Titulo
	FROM PlanesMejoramiento.TareasPlan a
	INNER JOIN 
		PlanesMejoramiento.Tareas b ON b.IdTarea = a.IdTarea
	INNER JOIN 
		PlanesMejoramiento.Estrategias c ON c.IdEstrategia = b.IdEstrategia
	INNER JOIN 
		PlanesMejoramiento.ObjetivosGenerales d ON d.IdObjetivoGeneral = c.IdObjetivoGeneral
	INNER JOIN 
		PlanesMejoramiento.SeccionPlanMejoramiento e ON e.IdSeccionPlanMejoramiento = d.IdSeccionPlan
	WHERE 
		a.IdUsuario = @IdUsuario
		AND
		e.IdPlanMejoramiento = @IdPlan
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoEnvioPlanInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoEnvioPlanInsert] AS'
GO
--*****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla																			  
-- Modifica: Grupo Desarrollo OIM - Andrés Bonilla																			  
-- Fecha creacion: 2017-11-20																			  
-- Fecha Modificacion: 2018-04-10	
-- Descripcion: Inserta la información de la finalizacion del plan y ruta archivo por usuario		
-- Modificacion: Se incluyen las nuevas columnas para identificar el envio del seguimiento del plan										  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoEnvioPlanInsert]
(
	@IdPlan INT
	,@IdUsuario INT
	,@RutaArchivo VARCHAR(500)
	,@TipoEnvio VARCHAR(5)
	,@IdSeguimiento INT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF (EXISTS(SELECT * 
			FROM [PlanesMejoramiento].[EnvioPlan] 
			WHERE [IdPlan]  = @IdPlan AND [IdUsuario] = @IdUsuario AND TipoEnvio = @TipoEnvio))
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
				AND TipoEnvio = @TipoEnvio

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

			INSERT INTO [PlanesMejoramiento].[EnvioPlan] ([IdPlan], [IdUsuario], [FechaEnvio], [FechaActualizacionEnvio], [RutaArchivo], TipoEnvio, IdSeguimiento)
			VALUES (@IdPlan, @IdUsuario, GETDATE(), null, @RutaArchivo, @TipoEnvio, @IdSeguimiento)			

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosSistema]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosSistema] AS'
GO
--=====================================================================================================  
-- Autor: Liliana Rodriguez      
-- Modificacion: Equipo de desarrollo OIM - John Betancourt A.    - Adicionar los campos de asuntos nuevos, a la consulta               
-- Modificacion: Equipo de desarrollo OIM - Andres Bonilla.    - Adicionar los campos de asunto y plantilla seguimiento plan, a la consulta               
-- Fecha creacion: 2017-02-09                      
-- Fecha modificacion: 2018-02-26                      
-- Fecha modificacion: 2018-04-10                 
-- Descripcion: Carga los datos de los parámetros del sistema        
--=====================================================================================================  
ALTER PROCEDURE [dbo].[C_DatosSistema]  
  
AS  
  
SELECT   
  [Id]  
 ,[FromEmail]  
 ,[SmtpHost]  
 ,[SmtpPort]  
 ,[SmtpEnableSsl]  
 ,[SmtpUsername]  
 ,[SmtpPassword]  
 ,[TextoBienvenida]  
 ,[FormatoFecha]  
 ,[PlantillaEmailPassword]  
 ,[UploadDirectory]  
 ,[PlantillaEmailConfirmacion]  
 ,[SaveMessageConfirmPopup]  
 ,[PlantillaEmailConfirmacionPlaneacionPat]  
 ,[PlantillaEmailConfirmacionSeguimiento1Pat]  
 ,[PlantillaEmailConfirmacionSeguimiento2Pat]  
 ,[AsuntoEnvioR]
 ,[AsuntoEnvioPT]
 ,[AsuntoEnvioSeguimientoT1]
 ,[AsuntoEnvioSeguimientoT2]
 ,[AsuntoEnvioSP]
 ,[PlantillaEmailConfirmacionSeguimientoPlan]
FROM   
 [dbo].[Sistema]  
  

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_SistemaUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_SistemaUpdate] AS'
GO
-- ================================================================================================  
-- Author:  Equipo de desarrollo OIM - Christian Ospina  
-- Modificacion: Equipo de desarrollo OIM - John Betancourt A.   -- Actualizar la informacion de los 4 campos nuevos de asusntos
-- Modificacion: Equipo de desarrollo OIM - Andres Bonilla.   -- Actualizar la informacion de los campos de asunto y plantilla seguimiento plan
-- Create date: 13/03/2017  
-- Fecha creacion: 2017-02-09                      
-- Description: Actualiza un registro en la tabla SISTEMA   
--    Retorna: select @respuesta as respuesta, @estadoRespuesta as estado            
--    @estadoRespuesta int = 0 no hace nada, 2 actualizado            
--    respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'   
-- ================================================================================================  
ALTER PROCEDURE [dbo].[U_SistemaUpdate]   
   
  @Id       INT  
 ,@FromEmail      VARCHAR(255)  
 ,@SmtpHost      VARCHAR(255)  
 ,@SmtpPort      INT  
 ,@SmtpEnableSsl     BIT  
 ,@SmtpUsername     VARCHAR(255)  
 ,@SmtpPassword     VARCHAR(255)  
 ,@TextoBienvenida    VARCHAR(MAX)  
 ,@FormatoFecha     VARCHAR(255)  
 ,@PlantillaEmailPassword  VARCHAR(MAX)  
 ,@UploadDirectory    VARCHAR(1000)  
 ,@PlantillaEmailConfirmacion VARCHAR(MAX)  
 ,@SaveMessageConfirmPopup  VARCHAR(255)  
 ,@PlantillaEmailConfirmacionPlaneacionPat VARCHAR(MAX)  
 ,@PlantillaEmailConfirmacionSeguimiento1Pat VARCHAR(MAX)  
 ,@PlantillaEmailConfirmacionSeguimiento2Pat VARCHAR(MAX)  
 ,@AsuntoEnvioR    VARCHAR(1000)  
 ,@AsuntoEnvioPT    VARCHAR(1000)  
 ,@AsuntoEnvioSeguimientoT1    VARCHAR(1000)  
 ,@AsuntoEnvioSeguimientoT2    VARCHAR(1000)  
 ,@AsuntoEnvioSP VARCHAR(255)
 ,@PlantillaEmailConfirmacionSeguimientoPlan VARCHAR(MAX)
  
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
     UPDATE   
      [dbo].[Sistema]  
     SET   
      [FromEmail] = @FromEmail, [SmtpHost] = @SmtpHost, [SmtpPort] = @SmtpPort, [SmtpEnableSsl] = @SmtpEnableSsl,   
      [SmtpUsername] = @SmtpUsername, [SmtpPassword] = @SmtpPassword, [TextoBienvenida] = @TextoBienvenida,   
      [FormatoFecha] = @FormatoFecha, [PlantillaEmailPassword] = @PlantillaEmailPassword, [UploadDirectory] = @UploadDirectory,   
      [PlantillaEmailConfirmacion] = @PlantillaEmailConfirmacion, [SaveMessageConfirmPopup] = @SaveMessageConfirmPopup  
      ,PlantillaEmailConfirmacionPlaneacionPat =@PlantillaEmailConfirmacionPlaneacionPat   
      ,PlantillaEmailConfirmacionSeguimiento1Pat=@PlantillaEmailConfirmacionSeguimiento1Pat   
      ,PlantillaEmailConfirmacionSeguimiento2Pat=@PlantillaEmailConfirmacionSeguimiento2Pat 
	  ,AsuntoEnvioR = @AsuntoEnvioR  
	  ,AsuntoEnvioPT = @AsuntoEnvioPT
	  ,AsuntoEnvioSeguimientoT1 = @AsuntoEnvioSeguimientoT1
	  ,AsuntoEnvioSeguimientoT2 = @AsuntoEnvioSeguimientoT2
	  ,AsuntoEnvioSP = @AsuntoEnvioSP
	  ,PlantillaEmailConfirmacionSeguimientoPlan = @PlantillaEmailConfirmacionSeguimientoPlan
     WHERE [Id] = @Id  
  
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
  
 END  

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ValidarEnvioPlanV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ValidarEnvioPlanV3] AS'
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla																			 
-- Modifica: Grupo Desarrollo OIM - Andrés Bonilla																			 
-- Fecha creacion: 2018-02-05																			 
-- Fecha modificacion: 2018-04-10
-- Descripcion: Retorna el resultado (BIT) de la validacion del usuario permitido para enviar
--				el plan de mejoramiento, bajo la condición de que debe haber respondido al menos
--				una acción por cada estrategia presentada en pantalla al momento de diligenciar
-- Modificacion: Se agrega el parametro tipoEnvio para validar los diferentes tipos de planes de mejoramiento
--				 P - Planeacion, SP - Seguimiento Plan -- TODO: Faltan las reglas de la validacion de SP
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ValidarEnvioPlanV3]
(
	@idPlan INT
	,@idUsuario INT
	,@tipoEnvio varchar(5)
)

AS

BEGIN

	DECLARE @idEncuesta INT
	DECLARE @puedeEnviar BIT

	--Diligenciamineto (planeacion) plan de mejoramiento
	IF(@tipoEnvio = 'P')
	BEGIN

		DECLARE @tabEstrategiasPorUsuario TABLE
		(
			IdEstrategia INT
		)

		DECLARE @tabEstrategiasTareasPorUsuario TABLE
		(
			IdEstrategia INT
			,CantTareasSelecc INT
		)

		SELECT 
			@idEncuesta = xx.IdEncuesta 
		FROM 
			PlanesMejoramiento.PlanMejoramientoEncuesta xx
		WHERE 
			xx.IdPlanMejoriamiento = @idPlan

		--Estrategias que el usuario debio diligenciar
		INSERT INTO @tabEstrategiasPorUsuario
		SELECT DISTINCT
		b.IdEstrategia
		FROM PlanesMejoramiento.Tareas a (NOLOCK)
		INNER JOIN PlanesMejoramiento.Estrategias b (NOLOCK) ON a.[IdEstrategia] = b.[IdEstrategia]
		INNER JOIN PlanesMejoramiento.ObjetivosGenerales OG (NOLOCK) ON b.IdObjetivoGeneral = OG.IdObjetivoGeneral
 		INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c (NOLOCK) ON OG.IdSeccionPlan = c.IdSeccionPlanMejoramiento
		INNER JOIN PlanesMejoramiento.PlanMejoramiento d (NOLOCK) ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
		INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta k (NOLOCK) ON k.IdPlanMejoriamiento = d.IdPlanMejoramiento 
		INNER JOIN dbo.Pregunta g (NOLOCK) ON g.Id = a.IdPregunta
		INNER JOIN dbo.TipoPregunta tp (NOLOCK) ON tp.Id = g.IdTipoPregunta
		INNER JOIN dbo.Seccion h (NOLOCK) ON h.Id = g.IdSeccion and h.IdEncuesta = k.IdEncuesta 	
		LEFT OUTER JOIN dbo.Respuesta rr (NOLOCK) ON rr.IdPregunta = g.Id AND rr.Valor = CASE tp.Id WHEN 11 THEN a.Opcion ELSE CASE a.Opcion WHEN 'Vacío' THEN NULL ELSE rr.Valor END END AND rr.IdUsuario = @idUsuario --Traer respuestas vacias y no vacias (tipos de pregunta diferentes a unico)
		INNER JOIN PlanesMejoramiento.PlanActivacionFecha i (NOLOCK) ON i.IdPlanMejoramiento = d.IdPlanMejoramiento
		WHERE d.IdPlanMejoramiento = @idPlan
		AND 
		(

			(tp.Id <> 11 AND (
			(a.Opcion = 'Vacío' AND (NOT EXISTS(SELECT TOP 1 1 FROM dbo.Respuesta xx WHERE xx.IdPregunta = g.Id AND xx.IdUsuario = @idUsuario))) 
			OR
			(a.Opcion <> 'Vacío' AND (EXISTS(SELECT TOP 1 1 FROM dbo.Respuesta xx WHERE xx.IdPregunta = g.Id AND xx.IdUsuario = @idUsuario)))
			)) OR (tp.Id = 11 AND rr.Valor = a.Opcion)
		)

		--Cantidad de tareas seleccionadas por estrategia y por usuario
		INSERT INTO @tabEstrategiasTareasPorUsuario
		SELECT
		a.IdEstrategia
		,COUNT(c.IdTareaPlan)
		FROM 
			@tabEstrategiasPorUsuario a
		INNER JOIN 
			PlanesMejoramiento.Tareas b 
				ON b.IdEstrategia = a.IdEstrategia
		LEFT OUTER JOIN 
			PlanesMejoramiento.TareasPlan c 
				ON c.IdTarea = b.IdTarea AND c.IdUsuario = @idUsuario
		GROUP BY a.IdEstrategia

		--Si alguna estrategia no tiene al menos 1 tarea seleccionada, no se deja enviar
		IF EXISTS (SELECT TOP 1 * FROM @tabEstrategiasTareasPorUsuario WHERE CantTareasSelecc = 0)
		BEGIN
			SET @puedeEnviar = 0
		END
		ELSE
		BEGIN
			SET @puedeEnviar = 1
		END

	END
	ELSE IF(@tipoEnvio = 'SP')
	BEGIN
		---TODO: Implementar las validaciones correctas de acuerdo a lo que informen los funcionales
		--		 mientras tanto se retorna true siempre
		SET @puedeEnviar = 1
	END
	

	SELECT @puedeEnviar AS Envia


END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerIdTipoPlanEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerIdTipoPlanEncuesta]AS'
GO
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2018-04-10																			 
-- Descripcion: Retorna los datos de tipo envio, idseguimiento, idplan necesarios para poder verificar
--				Si se debe remitir el usuario a la planeacion (diligenciamiento) o al seguimiento
--				del plan de mejoramiento
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerIdTipoPlanEncuesta] --1083
(
	@IdEncuesta INT
)

AS

BEGIN


DECLARE @IdEncuestaSeguimiento INT
DECLARE @TipoPlan varchar(5)
DECLARE @IdPlan INT
DECLARE @IdSeguimiento INT



--TIENE PLAN DE MEJORAMIENTO PROPIO
IF EXISTS(SELECT 1 FROM PlanesMejoramiento.PlanMejoramientoEncuesta WHERE IdEncuesta = @IdEncuesta)
BEGIN

	SET @TipoPlan = 'P'

	SELECT 
		@IdPlan = IdPlanMejoriamiento 
	FROM 
		PlanesMejoramiento.PlanMejoramientoEncuesta 
	WHERE 
		IdEncuesta = @IdEncuesta

END
ELSE
BEGIN
	
	DECLARE @RolEncuesta UNIQUEIDENTIFIER

	SELECT 
		@RolEncuesta = IdRol
	FROM
		Roles.RolEncuesta 
	WHERE
		IdEncuesta = @IdEncuesta



	SELECT TOP 1
		@IdEncuestaSeguimiento = IdEncuesta
	FROM
		Roles.RolEncuesta
	WHERE
		IdRol = @RolEncuesta
		AND
		IdEncuesta < @IdEncuesta
	ORDER BY
		IdEncuesta DESC


	IF EXISTS(SELECT 1 FROM PlanesMejoramiento.PlanMejoramientoEncuesta WHERE IdEncuesta = @IdEncuestaSeguimiento)
	BEGIN

		SET @TipoPlan = 'SP'

		SELECT 
			@IdPlan = IdPlanMejoriamiento 
		FROM 
			PlanesMejoramiento.PlanMejoramientoEncuesta 
		WHERE 
			IdEncuesta = @IdEncuestaSeguimiento

		---SI NO TIENE PROPIO, TIENE SEGUIMIENTO
		IF EXISTS(SELECT 1 FROM PlanesMejoramiento.PlanMejoramientoSeguimiento WHERE IdPlanMejoramiento = @IdPlan AND GETDATE() BETWEEN FechaInicio AND FechaFin)
		BEGIN
			SELECT 
				@IdSeguimiento = IdPlanSeguimiento
			FROM 
				PlanesMejoramiento.PlanMejoramientoSeguimiento 
			WHERE 
				IdPlanMejoramiento = @IdPlan 
				AND 
				GETDATE() BETWEEN FechaInicio AND FechaFin
		END
		ELSE
		BEGIN
			
			SET @TipoPlan = 'ND'
			SET @IdPlan = -1
		END

	END		
	ELSE
	BEGIN
			
		SET @TipoPlan = 'ND'
		SET @IdPlan = -1
	END

END


SELECT @IdEncuesta as IdEncuesta, @IdEncuestaSeguimiento as IdEncuestaSeguimiento, @IdPlan as IdPlan, @TipoPlan as TipoPlan, @IdSeguimiento AS IdSeguimiento

END

GO