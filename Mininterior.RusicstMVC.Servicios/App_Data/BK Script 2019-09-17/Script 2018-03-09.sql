/*****************************************************************************************************
* esto es para correr en la base de datos donde se tiene el log
*****************************************************************************************************/
SET IDENTITY_INSERT [dbo].[Category] ON 
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (325, N'Crear Objetivo General Plan de Mejoramiento', 193)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (326, N'Editar Objetivo General Plan de Mejoramiento', 194)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (327, N'Eliminar Objetivo General Plan de Mejoramiento', 195)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (328, N'Crear Respuesta Plan de Mejoramiento', 196)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (329, N'Adjuntar Archivo en Plan de Mejoramiento', 197)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (330, N'Envío de Plan de Mejoramiento', 198)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (331, N'Guardar página encuesta', 199)
SET IDENTITY_INSERT [dbo].[Category] OFF


/*****************************************************************************************************
* esto es para correr en la base de datos normal
*****************************************************************************************************/

---Tablas Nuevas

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[ObjetivosGenerales]'))
BEGIN
	CREATE TABLE [PlanesMejoramiento].[ObjetivosGenerales](
	[IdObjetivoGeneral] [int] IDENTITY(1,1) NOT NULL,
	[IdSeccionPlan] [int] NOT NULL,
	[ObjetivoGeneral] [varchar](4000) NOT NULL,
	 CONSTRAINT [PK_ObjetivosGenerales] PRIMARY KEY CLUSTERED 
	(
		[IdObjetivoGeneral] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [PlanesMejoramiento].[ObjetivosGenerales]  WITH CHECK ADD  CONSTRAINT [FK_ObjetivosGenerales_SeccionPlanMejoramiento] FOREIGN KEY([IdSeccionPlan])
	REFERENCES [PlanesMejoramiento].[SeccionPlanMejoramiento] ([IdSeccionPlanMejoramiento])

	ALTER TABLE [PlanesMejoramiento].[ObjetivosGenerales] CHECK CONSTRAINT [FK_ObjetivosGenerales_SeccionPlanMejoramiento]
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RespuestaSeccion]'))
BEGIN

	CREATE TABLE [dbo].[RespuestaSeccion](
		[IdRespuestaSeccion] [int] IDENTITY(1,1) NOT NULL,
		[IdSeccion] [int] NOT NULL,
		[IdUsuario] [int] NOT NULL,
		[FechaGuardado] [datetime] NOT NULL,
	 CONSTRAINT [PK_RespuestaSeccion] PRIMARY KEY CLUSTERED 
	(
		[IdRespuestaSeccion] ASC,
		[IdSeccion] ASC,
		[IdUsuario] ASC,
		[FechaGuardado] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	 CONSTRAINT [IX_RespuestaSeccion] UNIQUE NONCLUSTERED 
	(
		[IdUsuario] ASC,
		[IdSeccion] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	
	ALTER TABLE [dbo].[RespuestaSeccion]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaSeccion_Seccion] FOREIGN KEY([IdSeccion])
	REFERENCES [dbo].[Seccion] ([Id])

	ALTER TABLE [dbo].[RespuestaSeccion] CHECK CONSTRAINT [FK_RespuestaSeccion_Seccion]

	ALTER TABLE [dbo].[RespuestaSeccion]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaSeccion_Usuario] FOREIGN KEY([IdUsuario])
	REFERENCES [dbo].[Usuario] ([Id])

	ALTER TABLE [dbo].[RespuestaSeccion] CHECK CONSTRAINT [FK_RespuestaSeccion_Usuario]

END

GO

---ALTER TABLE ESTRATEGIAS, QUITAR REFERENCIAS A SECCION Y CAMBIAR POR OBJETIVO GENERAL
ALTER TABLE PlanesMejoramiento.Estrategias
	DROP CONSTRAINT FK_Estrategias_SeccionPlanMejoramiento

ALTER TABLE PlanesMejoramiento.Estrategias
	ADD IdObjetivoGeneral INT NOT NULL

ALTER TABLE PlanesMejoramiento.Estrategias 
	ADD CONSTRAINT FK_Estrategias_ObjetivosGenerales FOREIGN KEY
		(
		IdObjetivoGeneral
		) 
	REFERENCES PlanesMejoramiento.ObjetivosGenerales
		(
		IdObjetivoGeneral
		)

ALTER TABLE PlanesMejoramiento.Estrategias
	DROP COLUMN [IdSeccionPlanMejoramiento]

----SPS

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoEstrategiaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoEstrategiaInsert] AS'
GO
--*****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla		
-- Modifica: Grupo Desarrollo OIM - Andrés Bonilla
-- Fecha creacion: 2017-11-20	
-- Fecha Modificacion: 2018-02-27																		  
-- Descripcion: Inserta la información de una nueva Estrategia Plan V3
-- Modificacion: Se cambia el esquema para que se reciba IdObjetivoGeneral en lugar de IdSeccion
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoEstrategiaInsert]
(
	@Estrategia varchar(1024)
	,@IdObjetivo int
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	declare @id int

	IF (EXISTS(SELECT * FROM [PlanesMejoramiento].[Estrategias] WHERE [Estrategia]  = @Estrategia AND IdObjetivoGeneral = @IdObjetivo))
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

			INSERT INTO [PlanesMejoramiento].[Estrategias] ([Estrategia], [Activo], [IdObjetivoGeneral])
			VALUES (@Estrategia, 1, @IdObjetivo)			

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoObjetivoGeneralInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoObjetivoGeneralInsert] AS'
GO

--*****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla		
-- Fecha creacion: 2018-02-27																			  
-- Descripcion: Inserta la información de un nuevo Objetivo General Plan V3
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoObjetivoGeneralInsert]
(
	@ObjetivoGeneral varchar(4000)
	,@IdSeccion int
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	declare @id int

	IF (EXISTS(SELECT * FROM [PlanesMejoramiento].[ObjetivosGenerales] WHERE [ObjetivoGeneral]  = @ObjetivoGeneral AND IdSeccionPlan = @IdSeccion))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El objetivo general ya existe en el Sistema.'
	END

	IF (LEN(@ObjetivoGeneral) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'Debe escribir el objetivo general.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[ObjetivosGenerales] ([IdSeccionPlan], [ObjetivoGeneral])
			VALUES (@IdSeccion, @ObjetivoGeneral)			

			SELECT @respuesta = 'Se ha guardado el objetivo general.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[D_PlanMejoramientoObjetivoGeneralDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[D_PlanMejoramientoObjetivoGeneralDelete] AS'
GO

/****************************************************************************************************
/Autor: Grupo Desarrollo OIM - Andrés Bonilla																			 
/Fecha creacion: 2018-02-27																		 
/Descripcion: Elimina los datos de un objetivo general
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[D_PlanMejoramientoObjetivoGeneralDelete]
(
	@IdObjetivoGeneral INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF EXISTS (SELECT 1
				FROM [PlanesMejoramiento].[Estrategias] a
				WHERE a.[IdObjetivoGeneral] = @IdObjetivoGeneral)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'Ha ocurrido un error eliminando el objetivo general. Aún tiene estrategias asociadas.'
	END

	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [PlanesMejoramiento].[ObjetivosGenerales]
				WHERE [IdObjetivoGeneral] = @IdObjetivoGeneral		
		
			SELECT @respuesta = 'Se ha eliminado el objetivo general.'
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
--5
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[U_SeccionPlanMejoramientoUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[U_SeccionPlanMejoramientoUpdate] AS'
GO
/****************************************************************************************************
/Autor: Grupo Desarrollo OIM - Andrés Bonilla
/Modifica: Grupo Desarrollo OIM - Andrés Bonilla
/Fecha creacion: 2017-08-28		
/Fecha modificacion: 2018-02-27																	 
/Descripcion: Actualiza los datos de una Sección de un Plan de Mejoramiento
/Modificacion: Se quita el parámetro objetivo general, en el nuevo esquema va por aparte
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[U_SeccionPlanMejoramientoUpdate]
(
	@Titulo VARCHAR(200)
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
		SET @respuesta += 'La Sección a actualizar en el Plan de Mejoramiento no existe.'
	END

	--IF (LEN(@ObjetivoGeneral) <= 0)
	--BEGIN
	--	SET @esValido = 0
	--	SET @respuesta += 'El Objetivo General no Puede ir vacío.'
	--END

	IF (LEN(@Titulo) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El nombre de la sección no Puede ir vacío.'
	END
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE 
				[PlanesMejoramiento].[SeccionPlanMejoramiento]
			SET
				--ObjetivoGeneral = @ObjetivoGeneral 
				Titulo = @Titulo
				,Ayuda = @Ayuda
				,IdSeccionPlanMejoramientoPadre = @IdSeccionPadre
			WHERE
				IdSeccionPlanMejoramiento = @IdSeccionPlan

		SELECT @respuesta = 'Se ha editado la Sección en el Plan de Mejoramiento.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[U_ObjetivoGeneralPlanMejoramientoUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[U_ObjetivoGeneralPlanMejoramientoUpdate] AS'
GO
/****************************************************************************************************
/Autor: Grupo Desarrollo OIM - Andrés Bonilla
/Fecha creacion: 2018-02-27																		 
/Descripcion: Actualiza los datos de un objetivo general de un Plan de Mejoramiento
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PlanesMejoramiento].[U_ObjetivoGeneralPlanMejoramientoUpdate]
(
	@IdObjetivoGeneral INT
	,@ObjetivoGeneral VARCHAR(4000)
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (NOT EXISTS(SELECT * FROM [PlanesMejoramiento].[ObjetivosGenerales] WHERE IdObjetivoGeneral = @IdObjetivoGeneral))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El objetivo general a actualizar no existe.'
	END

	IF (LEN(@ObjetivoGeneral) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El objetivo general no puede ir vacío.'
	END
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE 
				[PlanesMejoramiento].[ObjetivosGenerales]
			SET
				ObjetivoGeneral = @ObjetivoGeneral 
			WHERE
				IdObjetivoGeneral = @IdObjetivoGeneral

		SELECT @respuesta = 'Se ha editado el objetivo general.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionTareasPlanMejoramiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionTareasPlanMejoramiento] AS'
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica: Grupo Desarrollo OIM - Andrés Bonilla
-- Fecha creacion: 2017-11-20
-- Fecha modificacion: 2018-02-27
-- Descripcion: Consulta la informacion de las Tareas asignadas a una Seccion de un Plan de Mejoramiento
-- Modificacion: Se cambia el parámetro para que reciba idobjetivogeneral de acuerdo al cambio de esquema
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerInformacionTareasPlanMejoramiento] --7
  (
	@IdObjetivoGeneral int
  )
  
  as
  
  BEGIN	
		SELECT b.[IdEstrategia], d.IdPregunta, a.[IdTarea], c.IdSeccionPlanMejoramiento, 
		b.[Estrategia], f.ObjetivoGeneral, a.Opcion,
		d.NombrePregunta, a.[Tarea], c.Titulo
		FROM [PlanesMejoramiento].[Tareas] a
		inner join [PlanesMejoramiento].[Estrategias] b on a.[IdEstrategia] = b.[IdEstrategia]
		inner join [PlanesMejoramiento].[ObjetivosGenerales] f on f.IdObjetivoGeneral = b.IdObjetivoGeneral
		inner join [PlanesMejoramiento].[SeccionPlanMejoramiento] c on f.IdSeccionPlan = c.IdSeccionPlanMejoramiento
		inner join [BancoPreguntas].[PreguntaModeloAnterior] e on e.IdPreguntaAnterior = a.IdPregunta
		inner join [BancoPreguntas].[Preguntas] d on d.IdPregunta = e.IdPregunta
		where 
		f.IdObjetivoGeneral = @IdObjetivoGeneral
  END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionObjetivosGeneralesPlanMejoramiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionObjetivosGeneralesPlanMejoramiento] AS'
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla
-- Fecha creacion: 2018-02-27
-- Descripcion: Consulta la informacion de los objetivos generales asignados a una Seccion de un Plan de Mejoramiento
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerInformacionObjetivosGeneralesPlanMejoramiento] --1--7
  (
	@IdSeccionPlan int
  )
  
  as
  
  BEGIN	
		SELECT 
		a.IdObjetivoGeneral, a.ObjetivoGeneral, b.Titulo, b.IdSeccionPlanMejoramiento, b.Ayuda, b.IdPlanMejoramiento
		FROM [PlanesMejoramiento].[ObjetivosGenerales] a
		inner join [PlanesMejoramiento].[SeccionPlanMejoramiento] b on a.IdSeccionPlan = b.IdSeccionPlanMejoramiento
		where 
		b.IdSeccionPlanMejoramiento = @IdSeccionPlan
  END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_SeccionPlanMejoramientoInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_SeccionPlanMejoramientoInsert] AS'
GO
--*****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica: Grupo Desarrollo OIM - Andrés Bonilla																		  
-- Fecha creacion: 2017-08-28																		  
-- Fecha modificacion: 2018-03-05	
-- Descripcion: Inserta la información de una Nueva Sección de un Plan de Mejoramiento												  
-- Modificacion: Se quita el parámetro objetivo general, en el nuevo esquema va por aparte
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_SeccionPlanMejoramientoInsert]
(
	@Titulo VARCHAR(200)
	,@Ayuda VARCHAR(2000)
	,@IdSeccionPadre INT
	,@IdPlan INT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
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
			VALUES ('', @Titulo, @Ayuda, @IdSeccionPadre, @IdPlan)			

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramientoV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramientoV3] AS'
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla																			 
-- Modifica: Grupo Desarrollo OIM - Andrés Bonilla
-- Fecha creacion: 2017-11-20
-- Fecha modificacion: 2018-01-22
-- Fecha modificacion: 2018-03-05
-- Descripcion: Consulta la informacion de las Estrategias de un Plan de Mejoramiento por Usuario
-- Modificación: Se modifica el procedimiento para tener en cuenta el nuevo funcionamiento de las opciones vacio y no vacio
-- Modificación: Se modifica el procedimiento para tener en cuenta el nuevo esquema de objetivos generales
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
	OG.ObjetivoGeneral, c.IdSeccionPlanMejoramiento, c.Titulo, c.Ayuda, 
	d.IdPlanMejoramiento, d.Nombre, d.FechaLimite, d.CondicionesAplicacion, 
	CONVERT(VARCHAR, g.Id) AS CodigoPregunta, g.Texto AS NombrePregunta, tp.Nombre AS TipoPregunta, 
	
	ISNULL((select top 1 xx.Titulo from dbo.Seccion xx where xx.Id = a.IdEtapa), '') as EtapaNombre,
	a.IdEtapa as IdEtapa

	FROM PlanesMejoramiento.Tareas a (NOLOCK)
	INNER JOIN PlanesMejoramiento.Estrategias b (NOLOCK) ON a.[IdEstrategia] = b.[IdEstrategia]
	INNER JOIN PlanesMejoramiento.ObjetivosGenerales OG (NOLOCK) ON b.IdObjetivoGeneral = OG.IdObjetivoGeneral
 	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c (NOLOCK) ON OG.IdSeccionPlan = c.IdSeccionPlanMejoramiento
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

		--(a.Opcion = 'Vacío' AND (NOT EXISTS(select top 1 1 from dbo.Respuesta xx where xx.IdPregunta = g.Id AND xx.IdUsuario = @IdUsuario))) 
		--OR
		--(a.Opcion <> 'Vacío' AND (EXISTS(select top 1 1 from dbo.Respuesta xx where xx.IdPregunta = g.Id AND xx.IdUsuario = @IdUsuario)))
	)
	--FROM PlanesMejoramiento.Tareas a (NOLOCK)
	--INNER JOIN PlanesMejoramiento.Estrategias b (NOLOCK) ON a.[IdEstrategia] = b.[IdEstrategia]
	--INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c (NOLOCK) ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
	--INNER JOIN PlanesMejoramiento.PlanMejoramiento d (NOLOCK) ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
	--INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta k (NOLOCK) ON k.IdPlanMejoriamiento = d.IdPlanMejoramiento 
	--INNER JOIN dbo.Pregunta g (NOLOCK) ON g.Id = a.IdPregunta
	--INNER JOIN dbo.TipoPregunta tp (NOLOCK) ON tp.Id = g.IdTipoPregunta
	--INNER JOIN dbo.Seccion h (NOLOCK) ON h.Id = g.IdSeccion and h.IdEncuesta = k.IdEncuesta 
	--INNER JOIN dbo.Respuesta rr (NOLOCK) ON rr.IdPregunta = g.Id and RTRIM(ISNULL(rr.Valor, '')) = CASE a.Opcion WHEN 'Vacío' THEN '' WHEN 'No Vacío' THEN RTRIM(rr.Valor) ELSE RTRIM(a.Opcion) END AND rr.IdUsuario = @IdUsuario --Traer respuestas vacias y no vacias (tipos de pregunta diferentes a unico)
	----INNER JOIN dbo.Usuario usu (NOLOCK) ON usu.Id = 
	--INNER JOIN PlanesMejoramiento.PlanActivacionFecha i (NOLOCK) ON i.IdPlanMejoramiento = d.IdPlanMejoramiento
	--WHERE d.IdPlanMejoramiento = @IdPlanMejoramiento
	--AND c.IdSeccionPlanMejoramiento = @IdSeccionPlan
	--AND usu.Id = @IdUsuario
	ORDER BY b.[IdEstrategia] ASC
	
	END
	ELSE
	BEGIN

		SELECT DISTINCT	

	b.[IdEstrategia], b.[Estrategia], 
	a.Opcion,
	OG.ObjetivoGeneral, c.IdSeccionPlanMejoramiento, c.Titulo, c.Ayuda, 
	d.IdPlanMejoramiento, d.Nombre, d.FechaLimite, d.CondicionesAplicacion, 
	CONVERT(VARCHAR, g.Id) AS CodigoPregunta, g.Texto AS NombrePregunta, tp.Nombre AS TipoPregunta, 
	
	ISNULL((select top 1 xx.Titulo from dbo.Seccion xx where xx.Id = a.IdEtapa), '') as EtapaNombre,
	a.IdEtapa as IdEtapa

	FROM PlanesMejoramiento.Tareas a (NOLOCK)
	INNER JOIN PlanesMejoramiento.Estrategias b (NOLOCK) ON a.[IdEstrategia] = b.[IdEstrategia]
	INNER JOIN PlanesMejoramiento.ObjetivosGenerales OG (NOLOCK) ON b.IdObjetivoGeneral = OG.IdObjetivoGeneral
 	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c (NOLOCK) ON OG.IdSeccionPlan = c.IdSeccionPlanMejoramiento
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
	--FROM PlanesMejoramiento.Tareas a (NOLOCK)
	--INNER JOIN PlanesMejoramiento.Estrategias b (NOLOCK) ON a.[IdEstrategia] = b.[IdEstrategia]
	--INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c (NOLOCK) ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
	--INNER JOIN PlanesMejoramiento.PlanMejoramiento d (NOLOCK) ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
	--INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta k (NOLOCK) ON k.IdPlanMejoriamiento = d.IdPlanMejoramiento 
	--INNER JOIN dbo.Pregunta g (NOLOCK) ON g.Id = a.IdPregunta
	--INNER JOIN dbo.TipoPregunta tp (NOLOCK) ON tp.Id = g.IdTipoPregunta
	--INNER JOIN dbo.Seccion h (NOLOCK) ON h.Id = g.IdSeccion and h.IdEncuesta = k.IdEncuesta 
	--INNER JOIN dbo.Respuesta rr (NOLOCK) ON rr.IdPregunta = g.Id and RTRIM(ISNULL(rr.Valor, '')) = CASE a.Opcion WHEN 'Vacío' THEN '' WHEN 'No Vacío' THEN RTRIM(rr.Valor) ELSE RTRIM(a.Opcion) END AND rr.IdUsuario = @IdUsuario --Traer respuestas vacias y no vacias (tipos de pregunta diferentes a unico)
	----INNER JOIN dbo.Usuario usu (NOLOCK) ON usu.Id = 
	--INNER JOIN PlanesMejoramiento.PlanActivacionFecha i (NOLOCK) ON i.IdPlanMejoramiento = d.IdPlanMejoramiento
	--WHERE d.IdPlanMejoramiento = @IdPlanMejoramiento
	--AND c.IdSeccionPlanMejoramiento = @IdSeccionPlan
	--AND usu.Id = @IdUsuario
	ORDER BY b.[IdEstrategia] ASC

	END
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ValidarActivarPlanMejoramientoV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ValidarActivarPlanMejoramientoV3] AS'
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla																			 
-- Modifica: Grupo Desarrollo OIM - Andrés Bonilla																	 
-- Fecha creacion: 2017-11-20
-- Fecha modificacion: 2018-03-05																			 
-- Descripcion: Verifica que un plan de mejoramiento cumpla con las condiciones para ser activado
-- Modificación: Se modifica el procedimiento para tener en cuenta el nuevo esquema de objetivos generales
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ValidarActivarPlanMejoramientoV3] --1019
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
			INNER JOIN PlanesMejoramiento.ObjetivosGenerales OG ON b.IdSeccionPlanMejoramiento = OG.IdSeccionPlan
			INNER JOIN PlanesMejoramiento.Estrategias c ON OG.IdObjetivoGeneral = c.IdObjetivoGeneral
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[D_PlanMejoramientoRespuestasV3Delete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[D_PlanMejoramientoRespuestasV3Delete] AS'
GO
/****************************************************************************************************
/Autor: Grupo Desarrollo OIM - Andrés Bonilla																			 
/Modifica: Grupo Desarrollo OIM - Andrés Bonilla																	 
/Fecha creacion: 2017-11-20	
/Fecha modificacion: 2018-03-05																			 																	 
/Descripcion: Elimina las respuestas previas de un usuario en el diligenciamiento del plan de mejoramiento v3
/Modificación: Se modifica el procedimiento para tener en cuenta el nuevo esquema de objetivos generales
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
					INNER JOIN PlanesMejoramiento.ObjetivosGenerales OG ON OG.IdObjetivoGeneral = b.IdObjetivoGeneral
					INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c ON OG.IdSeccionPlan = c.IdSeccionPlanMejoramiento
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_RespuestaSeccionInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_RespuestaSeccionInsert] AS'
GO
/****************************************************************************************************
/Autor: Grupo Desarrollo OIM - Andrés Bonilla																		 
/Fecha creacion: 2018-03-08																			 																	 
/Descripcion: Inserta un registro en la tabla dbo.RespuestaSeccion para validar que un usuario ya dió click
/			  al botón guardar dentro de una página de la encuesta, para posteriormente validar la ejecución
/			  de los copyenc dentro de la misma página, previamente se validaba si existian respuestas de esa
/			  misma página.
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [dbo].[I_RespuestaSeccionInsert]
(
	@IdUsuario INT
	,@IdSeccion INT
)

AS

BEGIN
	SET NOCOUNT ON;

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	--Update registro existente
	IF EXISTS(SELECT 1 FROM [dbo].[RespuestaSeccion] WHERE IdSeccion = @IdSeccion AND IdUsuario = @IdUsuario)
	BEGIN
		SET @esValido = 0

		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE 
				[dbo].[RespuestaSeccion]
			SET 
				FechaGuardado = GETDATE()
			WHERE
				IdSeccion = @IdSeccion
				AND
				IdUsuario = @IdUsuario

			SELECT @respuesta = 'Se ha actualizado la información correctamente.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	--Insertar registro nuevamente
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [dbo].[RespuestaSeccion] ([IdSeccion], [IdUsuario], [FechaGuardado])
			VALUES (@IdSeccion, @IdUsuario, GETDATE())

			SELECT @respuesta = 'Se ha guardado la información correctamente.'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ValidarRespuestasXSeccion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ValidarRespuestasXSeccion] AS'
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla																			 
-- Modifica: Grupo Desarrollo OIM - Andrés Bonilla																	 																	 
-- Fecha creacion: 2017-10-09		
-- Fecha modificacion: 2018-03-08																		 
-- Descripcion: Valida si hay respuestas en una seccion especifica para un usuario determinado
-- Modificacion: se cambia la validacion para verificar contra la nueva tabla RespuestaSeccion si el usuario
--				 guardó la página (aún sin respuestas)
-- ***************************************************************************************************
ALTER PROC [dbo].[C_ValidarRespuestasXSeccion] --4870, 331
(
	@IdSeccion INT,
	@IdUsuario INT
)

AS

BEGIN


	DECLARE @HayRespuestas BIT

	--SELECT
	--	@HayRespuestas = 1
	--FROM
	--	dbo.Respuesta 
	--WHERE
	--	IdUsuario = @IdUsuario
	--	AND
	--		IdPregunta IN 
	--		(
	--			SELECT
	--				XX.Id
	--			FROM
	--				dbo.Pregunta XX
	--			WHERE
	--				XX.IdSeccion = @IdSeccion
	--		)

	SELECT
		@HayRespuestas = 1
	FROM
		dbo.RespuestaSeccion 
	WHERE
		IdSeccion = @IdSeccion
		AND
		IdUsuario = @IdUsuario


	SELECT ISNULL(@HayRespuestas, 0) AS Resultado


END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestasXUsuarioCompletadas]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_EncuestasXUsuarioCompletadas] AS'
GO
-- ============================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Modifica:	Equipo de desarrollo OIM - Andrés Bonilla
-- Create date: 03/05/2017
-- Modify date: 08/03/2018
-- Description:	Selecciona la información de encuesta completadas por usuario
-- Modificacion: Se modifica para que tenga en cuenta la última hora del día que se extiende el plazo
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
							AND dateadd(minute, -1, convert(datetime, dateadd(day, 1, convert(date, fechafin)))) >= GETDATE()) 
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
			([a].[FechaFin] < GETDATE()
			AND NOT EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
							WHERE [p].[IdEncuesta] = [a].[Id] 
							AND [p].[IdUsuario] = @IdUsuario
							AND dateadd(minute, -1, convert(datetime, dateadd(day, 1, convert(date, fechafin)))) >= GETDATE()) )
			AND
			a.IsPrueba = 0
		ORDER BY
			[FechaFin] DESC
			
			end
				
	END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_EncuestasXUsuarioNoCompletadas]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_EncuestasXUsuarioNoCompletadas] AS'
GO
-- ============================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Modifica:	Equipo de desarrollo OIM - Andrés Bonilla
-- Create date: 03/05/2017
-- Modify date: 08/03/2018
-- Description:	Selecciona la información de encuesta NO completadas por usuario
-- Modificacion: Se modifica para que tenga en cuenta la última hora del día que se extiende el plazo
-- ============================================================================
ALTER PROCEDURE [dbo].[C_EncuestasXUsuarioNoCompletadas] --7, 849
	
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
						AND p.IdTipoExtension = 1
						AND dateadd(minute, -1, convert(datetime, dateadd(day, 1, convert(date, fechafin)))) > GETDATE()) 
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
			(([a].[FechaInicio] < GETDATE() AND [a].[FechaFin] > GETDATE())
			OR EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = [a].[Id] 
						AND [p].[IdUsuario] = @IdUsuario
						AND p.IdTipoExtension = 1
						AND dateadd(minute, -1, convert(datetime, dateadd(day, 1, convert(date, fechafin)))) > GETDATE()))
			AND
			a.IsPrueba = 0
		ORDER BY
			[FechaFin] DESC	

	end

		
	END
		
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ValidarPermisoGuardadoSeccion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ValidarPermisoGuardadoSeccion] AS'
GO
--****************************************************************************************************
-- Autor:		Equipo de desarrollo OIM - Andrés Bonilla
-- Modifica:	Equipo de desarrollo OIM - Andrés Bonilla																		 
-- Fecha creacion: 2017-10-03	
-- Fecha Modificacion: 2018-03-08
-- Descripcion: Retorna IdEncuesta y el resultado (BIT) de la validacion del usuario permitido para contestar
--				La seccion indicada en el parametro
-- Modificacion: Se modifica para que tenga en cuenta la última hora del día que se extiende el plazo
-- ***************************************************************************************************
ALTER PROC [dbo].[C_ValidarPermisoGuardadoSeccion] --331, 452
(
	@idUsuario INT
	,@idSeccion INT
)

AS

BEGIN

SET NOCOUNT ON;

--declare @idUsuario int
--declare @idSeccion int

--set @idUsuario = 331
--set @idSeccion = 3836


	DECLARE @idEncuesta INT
	DECLARE @fecha DATETIME
	DECLARE @valido BIT

	SELECT 
		@idEncuesta = IdEncuesta
	FROM 
		dbo.Seccion 
	WHERE 
		Id = @idSeccion 

	SET @fecha = GETDATE()

	SET @valido = 0

	---Verificamos si la Encuesta aún está habilitada para contestar
	SELECT 
		@valido = 1 
	FROM 
		dbo.Encuesta 
	WHERE 
		Id = @idEncuesta 
		AND 
			[FechaInicio] <= @fecha 
		AND 
			[FechaFin] >= @fecha

	--Si no está habilitada verificamos las Extensiones de tiempo del Usuario
	IF @valido = 0
	BEGIN

	SELECT 
		@valido = 1 
	FROM 
		[dbo].[PermisoUsuarioEncuesta] 
	WHERE 
		IdUsuario = @idUsuario 
		AND 
			IdEncuesta = @idEncuesta 
		AND
			IdTipoExtension = 1
		AND
			dateadd(minute, -1, convert(datetime, dateadd(day, 1, convert(date, fechafin)))) > @fecha

	END


	SELECT 
		@idEncuesta AS IdEncuesta
		,@valido AS UsuarioHabilitado

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ValidarPermisosGuardado]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ValidarPermisosGuardado] AS'
GO
--****************************************************************************************************
-- Autor:		Equipo de desarrollo OIM - Andrés Bonilla
-- Modifica:	Equipo de desarrollo OIM - Andrés Bonilla																		 																			 
-- Fecha creacion: 2017-10-26	
-- Fecha Modificacion: 2018-03-08																		 
-- Descripcion: Retorna un bit resultado de la validacion de extension de tiempo de un usuario especifico
--				para una encuesta, plan o tablero pat
-- Modificacion: Se modifica para que tenga en cuenta la última hora del día que se extiende el plazo
-- ***************************************************************************************************
ALTER PROC [dbo].[C_ValidarPermisosGuardado]
(
	@idUsuario INT
	,@idEncuesta INT
	,@idTipoExtension INT
)

AS

BEGIN

SET NOCOUNT ON;

	DECLARE @fecha DATETIME
	DECLARE @valido BIT

	SET @fecha = GETDATE()

	SET @valido = 0

	SELECT 
		@valido = 1 
	FROM 
		[dbo].[PermisoUsuarioEncuesta] 
	WHERE 
		IdUsuario = @idUsuario 
		AND 
			IdEncuesta = @idEncuesta 
		AND
			dateadd(minute, -1, convert(datetime, dateadd(day, 1, convert(date, fechafin)))) > @fecha
		AND
			IdTipoExtension = @idTipoExtension


	SELECT 
		@valido AS UsuarioHabilitado

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_Derechos]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_Derechos] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Modifica: Grupo OIM de Ministerio del Interior - Andrés Bonilla
-- Create date:		10/07/2017
-- Modified date:	13/11/2017
-- Modified date 2:	08/03/2018
-- Description:		Obtiene los derechos de un tablero que tienen preguntas activas asociadas
-- Modification:	Se agrega el ApoyoDepartamental = 1 para el listado de derechos del consolidado municipal
-- =============================================
ALTER PROC [PAT].[C_Derechos] --3, 1344, 1
( @idTablero tinyint,@IdUsuario INT, @GestionDepartamental bit)--[PAT].[C_Derechos] 2,411
AS
BEGIN
	Declare @IdMunicipio int, @IdDepartamento int
	SELECT @IdMunicipio =  U.[IdMunicipio] , @IdDepartamento = IdDepartamento FROM [dbo].[Usuario] (NOLOCK) U WHERE U.ID = @IdUsuario

	IF (@GestionDepartamental =1) --DEBE TRAER TODOS LOS DERECHOS QUE ESTEN ASOCIADOS A PREGUNTAS DEL TABLERO INDICADO
	BEGIN
		SELECT DISTINCT D.ID, D.DESCRIPCION
		FROM [PAT].[Derecho] D
		JOIN PAT.PreguntaPAT AS P ON D.Id = P.IdDerecho
		join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
		join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = @IdDepartamento										
		WHERE P.IdTablero = @idTablero and p.Activo = 1	and p.Nivel = 3 and p.ApoyoDepartamental = 1
		ORDER BY D.Descripcion
	END
	ELSE --TRAE SOLO LOS DERECHOS DE PREGUNTAS ASOCIADAS AL MUNICIPIO DEL TABLERO INDICADO
	BEGIN
		SELECT DISTINCT D.ID, D.DESCRIPCION
		FROM [PAT].[Derecho] D
		JOIN PAT.PreguntaPAT AS P ON D.Id = P.IdDerecho
		join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		WHERE P.IdTablero = @idTablero and p.Activo = 1	and p.Nivel = 3		
		ORDER BY D.Descripcion
	END
END

GO