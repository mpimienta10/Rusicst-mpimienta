IF  NOT EXISTS (select 1 from sys.columns where Name = N'IdEncuesta' and Object_ID = Object_ID(N'[PlanesMejoramiento].[PlanMejoramientoSeguimiento]'))
BEGIN
	BEGIN TRANSACTION
	   alter table [PlanesMejoramiento].[PlanMejoramientoSeguimiento]
		add IdEncuesta INT NOT NULL DEFAULT(0)
	COMMIT
END

GO

---Tablas Nuevas
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[SeguimientoArchivoUsuario]')) 
BEGIN
	CREATE TABLE [PlanesMejoramiento].[SeguimientoArchivoUsuario](
		[IdSeguimientoArchivoUsuario] [int] IDENTITY(1,1) NOT NULL,
		[IdSeguimiento] [int] NOT NULL,
		[IdUsuario] [int] NOT NULL,
		[RutaArchivo] [varchar](500) NULL,
		[FechaCargue] [datetime] NULL,
	 CONSTRAINT [PK_SeguimientoArchivoUsuario] PRIMARY KEY CLUSTERED 
	(
		[IdSeguimientoArchivoUsuario] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoSeguimientoInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoSeguimientoInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	,@IdEncuesta INT
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

			INSERT INTO [PlanesMejoramiento].[PlanMejoramientoSeguimiento] ([IdPlanMejoramiento],[NumeroSeguimiento],[MensajeSeguimiento],[FechaInicio],[FechaFin],[Activo],[IdEncuesta])
			VALUES (@IdPlan, @NumeroSeguimiento, @MensajeSeguimiento, CONVERT(DATE, @FechaInicio), DATEADD(MINUTE, -1, DATEADD(DAY, 1, CONVERT(DATETIME, CONVERT(DATE, @FechaFin)))), @Activo, @IdEncuesta)

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[U_PlanMejoramientoSeguimientoUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[U_PlanMejoramientoSeguimientoUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	,@IdEncuesta INT
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
				[Activo] = @Activo,
				[IdEncuesta] = @IdEncuesta
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoSeguimientoArchivoInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoSeguimientoArchivoInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla		
-- Fecha creacion: 2018-08-02																			  
-- Descripcion: Inserta o Actualiza la información del Archivo del Seguimiento del PLan de Mejoramiento de Un Usuario
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoSeguimientoArchivoInsert]
(
	@IdSeguimiento INT
	,@IdUsuario INT
	,@Ruta VARCHAR(500)
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (LEN(@Ruta) <= 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'La ruta del archivo no puede ir vacía.'
	END

	IF EXISTS (SELECT 1 FROM [PlanesMejoramiento].[SeguimientoArchivoUsuario] WHERE IdSeguimiento = @IdSeguimiento AND IdUsuario = @IdUsuario)
	BEGIN
		IF(@esValido = 1) 
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY

				UPDATE
					[PlanesMejoramiento].[SeguimientoArchivoUsuario]
				SET
					[RutaArchivo] = @Ruta
					,[FechaCargue] = GETDATE()
				WHERE
					[IdSeguimiento] = @IdSeguimiento
					AND
					[IdUsuario] = @IdUsuario

			SELECT @respuesta = 'Se ha editado el archivo del seguimiento del plan de mejoramiento.'
			SELECT @estadoRespuesta = 1
	
			COMMIT  TRANSACTION
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
				SELECT @respuesta = ERROR_MESSAGE()
				SELECT @estadoRespuesta = 0
			END CATCH
		END		
	END
	ELSE
	BEGIN		
		IF(@esValido = 1) 
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY

				INSERT INTO [PlanesMejoramiento].[SeguimientoArchivoUsuario] ([IdSeguimiento], [IdUsuario], [RutaArchivo], [FechaCargue])
				VALUES (@IdSeguimiento, @IdUsuario, @Ruta, GETDATE())

				SELECT @respuesta = 'Se ha guardado el archivo del seguimiento del plan de mejoramiento.'
				SELECT @estadoRespuesta = 1

			COMMIT  TRANSACTION
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
				SELECT @respuesta = ERROR_MESSAGE()
				SELECT @estadoRespuesta = 0
			END CATCH
		END
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionSeguimientosPlanMejoramiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionSeguimientosPlanMejoramiento] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
		,A.[FechaInicio]
		,A.[FechaFin]
		,[Activo]
		,A.[IdEncuesta]
		,C.Titulo AS Encuesta
	FROM 
		[PlanesMejoramiento].[PlanMejoramientoSeguimiento] A
		INNER JOIN
			PlanesMejoramiento.PlanMejoramiento B 
				ON A.IdPlanMejoramiento = B.IdPlanMejoramiento
		INNER JOIN 
			dbo.Encuesta C
				ON C.Id = A.IdEncuesta
	WHERE
		A.IdPlanMejoramiento = @IdPlan

END


GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerRutaSeguimientoPlan]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerRutaSeguimientoPlan] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla				
-- Fecha creacion: 2018-08-02
-- Descripcion: Consulta la informacion de la ruta del archivo cargado en seguimiento plan v3
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerRutaSeguimientoPlan]
(
	@IdSeguimiento INT
	,@IdUsuario INT
)

AS

BEGIN

	SELECT
	*
	FROM
		[PlanesMejoramiento].[SeguimientoArchivoUsuario]
	WHERE
		IdSeguimiento = @IdSeguimiento
		AND
		IdUsuario = @IdUsuario

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ValidarEnvioPlanV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ValidarEnvioPlanV3] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla																			 
-- Modifica: Grupo Desarrollo OIM - Andrés Bonilla																			 
-- Fecha creacion: 2018-02-05																			 
-- Fecha modificacion: 2018-04-10
-- Fecha modificacion: 2018-08-02
-- Descripcion: Retorna el resultado (BIT) de la validacion del usuario permitido para enviar
--				el plan de mejoramiento, bajo la condición de que debe haber respondido al menos
--				una acción por cada estrategia presentada en pantalla al momento de diligenciar
-- Modificacion: Se agrega el parametro tipoEnvio para validar los diferentes tipos de planes de mejoramiento
--				 P - Planeacion, SP - Seguimiento Plan
-- Modificacion: Se agregan las validaciones para el envio de seguimiento, siendo estas que cada accion
--				 presentada en pantalla tenga su correspondiente estado, autoevaluación y observación
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
	ELSE IF(@tipoEnvio = 'SP') ---Seguimiento Plan de Mejoramiento
	BEGIN		
		DECLARE @tabAccionesPorUsuario TABLE
		(
			IdAccionPlaneacion INT
		)

		DECLARE @tabAccionesDiligenciadasUsuario TABLE
		(
			IdAccionPlaneacion INT
			,Diligenciada BIT
		)

		INSERT INTO @tabAccionesPorUsuario
		SELECT 
			a.IdTareaPlan
		FROM PlanesMejoramiento.TareasPlan a
		INNER JOIN 
			PlanesMejoramiento.Tareas b ON b.IdTarea = a.IdTarea
		INNER JOIN 
			PlanesMejoramiento.Estrategias c ON c.IdEstrategia = b.IdEstrategia
		INNER JOIN 
			PlanesMejoramiento.ObjetivosGenerales d ON d.IdObjetivoGeneral = c.IdObjetivoGeneral
		INNER JOIN 
			PlanesMejoramiento.SeccionPlanMejoramiento e ON e.IdSeccionPlanMejoramiento = d.IdSeccionPlan
		INNER JOIN
			PlanesMejoramiento.PlanMejoramientoSeguimiento f ON e.IdPlanMejoramiento = f.IdPlanMejoramiento 
		WHERE 
			a.IdUsuario = @idUsuario
			AND
			f.IdPlanSeguimiento = @idPlan
		
		INSERT INTO @tabAccionesDiligenciadasUsuario
		SELECT 
		a.IdAccionPlaneacion
		,CASE WHEN b.IdSeguimientoAccion IS NULL THEN 0 ELSE 1 END AS Diligenciada
		FROM @tabAccionesPorUsuario a
		LEFT OUTER JOIN PlanesMejoramiento.SeguimientoPlanMejoramiento b ON a.IdAccionPlaneacion = b.IdAccionPlan AND b.IdPlanSeguimiento = @idPlan --and b.IdUsuario = 726

		--Si alguna accion no fue diligenciada no se deja enviar
		IF EXISTS (SELECT TOP 1 * FROM @tabAccionesDiligenciadasUsuario WHERE Diligenciada = 0)
		BEGIN
			SET @puedeEnviar = 0
		END
		ELSE
		BEGIN
			SET @puedeEnviar = 1
		END
	END
	

	SELECT @puedeEnviar AS Envia


END

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_EnvioTableroPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_EnvioTableroPat] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez
/Modifica: Equipo OIM	- Andrés Bonilla																	  
/Modifica: Equipo OIM	- vilma rodriguez																	  
/Fecha creacion:     2017-12-11	
/Fecha modificacion :2018-02-14
/Fecha modificacion :2018-03-09
/Fecha modificacion :2018-04-30
/Modified date:	01/06/2018
/Descripcion: Inserta los datos de envio de los tres tipos de tablero: Planeacion Municipal "PM", Planeacion Departamental "PD"
/, Primer Seguimiento Municpal "SM1", Segundo Seguimiento Municpal "SM2"						  
/, Primer Seguimiento Departamental "SD1", Segundo Seguimiento Departamental "SD2"	
/Modificacion: Se cambia la validación de envío de SM2					  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_EnvioTableroPat] --1460, 2, 'PD'
		@IdUsuario int,
		@IdTablero tinyint,
		@TipoEnvio varchar(3)
		AS 				
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	

	declare @id int, @IdDepartamento int,@IdMunicipio  int	
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	select @id = r.IdEnvio from [PAT].[EnvioTableroPat] as r
	where  r.IdMunicipio = @IdMunicipio and r.IdDepartamento = @IdDepartamento and TipoEnvio = @TipoEnvio  and r.IdTablero =@IdTablero
	
	--Usuarios que no diligenciaron planeacion pueden enviar SM1 o SM2 sin problemas
	DECLARE @UsuariosSinPlaneacion TABLE
	(         
		IdUsuario INT
	)

	IF @TipoEnvio = 'SM1' OR @TipoEnvio = 'SM2'
	BEGIN
		INSERT INTO @UsuariosSinPlaneacion	
		select 
		distinct a.idusuario
		from pat.RespuestaPAT a
		inner join pat.PreguntaPAT b on a.IdPreguntaPAT = b.Id
		where
		b.IdTablero = @IdTablero
		and b.Activo = 1  
		and b.Nivel = 3
	END
	IF @TipoEnvio = 'SD1' OR @TipoEnvio = 'SD2'
	BEGIN
		INSERT INTO @UsuariosSinPlaneacion	
		select 
		distinct a.idusuario
		from pat.RespuestaPAT a
		inner join pat.PreguntaPAT b on a.IdPreguntaPAT = b.Id
		where
		b.IdTablero = @IdTablero
		and b.Activo = 1
		and b.Nivel = 2
	END
	--if (@id is not null)
	--begin
	--	set @esValido = 0
	--	set @respuesta += 'El tablero ya ha sido enviado con anterioridad.'
	--end
	------------------------------------------------------------------------------
	--validacion de que halla guardado las preguntas del municipio correspondiente	
	------------------------------------------------------------------------------
	declare @guardoPreguntas bit
	declare @guardoPreguntasConsolidado bit
	set @guardoPreguntas = 0
	set @guardoPreguntasConsolidado = 0
	-------------------------------------
	-------MUNICIPIOS--------------------
	-------------------------------------
	if (@TipoEnvio = 'PM')--planeacion municipal
	begin 
		SELECT @guardoPreguntas =CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		FROM (
			SELECT 
			COUNT(P.Id) AS NUM_PREGUNTAS_CONTESTAR, 
			count(R.Id) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
			FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
			join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
			JOIN Municipio AS M ON PM.IdMunicipio = M.Id
			LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >=0 and R.RespuestaIndicativa >=0 and R.NecesidadIdentificada >=0 AND R.Presupuesto >=0
			WHERE	P.NIVEL = 3 --municipios
			AND P.IdTablero = @idTablero
			and P.ACTIVO = 1	
			and M.Id = @IdMunicipio
		) AS T 
	end
	if (@TipoEnvio = 'SM1' )--seguimiento municipal
	begin 
		set @guardoPreguntas = 0
		--SELECT @guardoPreguntas = CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		--FROM (
		--	SELECT 
		--	COUNT(P.Id) AS NUM_PREGUNTAS_CONTESTAR, 
		--	count(SM.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		--	FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
		--	join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
		--	JOIN Municipio AS M ON PM.IdMunicipio = M.Id
		--	LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >=0
		--	LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = P.ID AND SM.IdUsuario = R.IdUsuario and SM.CantidadPrimer >= 0 	
		--	WHERE	P.NIVEL = 3 --municipios
		--	AND P.IdTablero = @idTablero
		--	and P.ACTIVO = 1	
		--	and M.Id = @IdMunicipio
		--) AS T 
		IF NOT EXISTS (Select 1 from @UsuariosSinPlaneacion WHERE IdUsuario = @IdUsuario)
		BEGIN
			--Usuarios que no diligenciaron planeacion pueden enviar SM1 o SM2 sin problemas
			SET @guardoPreguntas = 1
		END
		ELSE
		BEGIN
			
			declare @cantPreguntas1 int

			select @cantPreguntas1 = count(a.Id)
			from pat.PreguntaPAT a
			where a.IdTablero = @IdTablero and a.Activo = 1 and a.Nivel = 3

			IF EXISTS (
			select 1
			from pat.PreguntaPAT b 
			left outer join pat.RespuestaPAT a on a.IdPreguntaPAT = b.Id
			inner join dbo.Usuario u on u.Id = a.IdUsuario
			where
			b.IdTablero = @IdTablero
			and b.Activo = 1 and b.Nivel = 3
			and u.Activo = 1 and u.IdEstado = 5 and u.IdTipoUsuario = 2
			and u.Id = @IdUsuario
			group by a.IdUsuario, u.UserName
			having (@cantPreguntas1 - SUM(case when a.RespuestaCompromiso is null then 0 when a.RespuestaCompromiso = 0 then 0 else 1 end)) = 100
			)
			BEGIN
				--Usuarios que llenaron todo en 0 pueden enviar SM1 y SM2 sin problema
				SET @guardoPreguntas = 1
			END
			ELSE
			BEGIN
				
				DECLARE @CantPreguntasSeguimiento1 INT

				--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
				DECLARE @PreguntasPlaneacion1 TABLE
				(
					IdPreguntaPAT INT				
				)

				INSERT INTO @PreguntasPlaneacion1
				SELECT a.IdPreguntaPAT
				FROM PAT.RespuestaPAT a
				INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
				WHERE
				b.IdTablero = @IdTablero
				AND a.IdUsuario = @IdUsuario
				AND b.Activo = 1 and b.Nivel = 3
				AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)


				SELECT @CantPreguntasSeguimiento1 = COUNT(DISTINCT IdPregunta)
				FROM PAT.Seguimiento
				WHERE IdPregunta IN (
					SELECT IdPreguntaPAT
					FROM @PreguntasPlaneacion1
				) 
				AND IdUsuario = @IdUsuario
				AND IdTablero = @IdTablero
				AND (CantidadPrimer >= 0 OR PresupuestoPrimer >= 0)	
				and CompromisoDefinitivo >=0 and PresupuestoDefinitivo >= 0			

				SELECT @guardoPreguntas = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimiento1 THEN 1 ELSE 0 END
				FROM @PreguntasPlaneacion1
			END
		END
	end
	if ( @TipoEnvio= 'SM2')--seguimiento municipal
	begin 
		--SELECT @guardoPreguntas = CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		--FROM (
		--	SELECT 
		--	COUNT(distinct R.Id) AS NUM_PREGUNTAS_CONTESTAR, 
		--	count(distinct SM.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		--	FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
		--	join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
		--	JOIN Municipio AS M ON PM.IdMunicipio = M.Id
		--	JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >=0
		--	LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = P.ID AND SM.IdUsuario = R.IdUsuario and SM.CantidadSegundo >= 0 and SM.PresupuestoSegundo >=0	and SM.ObservacionesSegundo is not null
		--	WHERE	P.NIVEL = 3 --municipios
		--	AND P.IdTablero = @idTablero
		--	and P.ACTIVO = 1	
		--	and M.Id = @IdMunicipio
		--) AS T 

		IF NOT EXISTS (Select 1 from @UsuariosSinPlaneacion WHERE IdUsuario = @IdUsuario)
		BEGIN
			--Usuarios que no diligenciaron planeacion pueden enviar SM1 o SM2 sin problemas
			SET @guardoPreguntas = 1
		END
		ELSE
		BEGIN
			
			declare @cantPreguntas int

			select @cantPreguntas = count(a.Id)
			from pat.PreguntaPAT a
			where a.IdTablero = @IdTablero and a.Activo = 1 and a.Nivel = 3

			IF EXISTS (
			select 1
			from pat.PreguntaPAT b 
			left outer join pat.RespuestaPAT a on a.IdPreguntaPAT = b.Id
			inner join dbo.Usuario u on u.Id = a.IdUsuario
			where
			b.IdTablero = @IdTablero
			and b.Activo = 1 and b.Nivel = 3
			and u.Activo = 1 and u.IdEstado = 5 and u.IdTipoUsuario = 2
			and u.Id = @IdUsuario
			group by a.IdUsuario, u.UserName
			having (@cantPreguntas - SUM(case when a.RespuestaCompromiso is null then 0 when a.RespuestaCompromiso = 0 then 0 else 1 end)) = 100
			)
			BEGIN
				--Usuarios que llenaron todo en 0 pueden enviar SM1 y SM2 sin problema
				SET @guardoPreguntas = 1
			END
			ELSE
			BEGIN
				
				DECLARE @CantPreguntasSeguimiento INT

				--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
				DECLARE @PreguntasPlaneacion TABLE
				(
					IdPreguntaPAT INT				
				)

				INSERT INTO @PreguntasPlaneacion
				SELECT a.IdPreguntaPAT
				FROM PAT.RespuestaPAT a
				INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
				WHERE
				b.IdTablero = @IdTablero
				AND a.IdUsuario = @IdUsuario
				AND b.Activo = 1 and b.Nivel = 3
				AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)


				SELECT @CantPreguntasSeguimiento = COUNT(DISTINCT IdPregunta)
				FROM PAT.Seguimiento
				WHERE IdPregunta IN (
					SELECT IdPreguntaPAT
					FROM @PreguntasPlaneacion
				) 
				AND IdUsuario = @IdUsuario
				AND IdTablero = @IdTablero
				AND (CantidadSegundo >= 0 OR PresupuestoSegundo >= 0)
				AND ObservacionesSegundo IS NOT NULL				

				SELECT @guardoPreguntas = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimiento THEN 1 ELSE 0 END
				FROM @PreguntasPlaneacion
			END
		END

	end
	-------------------------------------
	-------DEPARTAMENTOS--------------------
	-------------------------------------
	if (@TipoEnvio = 'PD')--planeacion departamental
	begin 
		----PREGUNTAS GOBERNACION
		SELECT @guardoPreguntas =CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		FROM (
			SELECT 
			COUNT(P.Id) AS NUM_PREGUNTAS_CONTESTAR, 
			count(R.Id) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
			FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
			join [PAT].[PreguntaPATDepartamento] as PM on P.Id = PM.IdPreguntaPAT 
			JOIN Departamento AS D ON PM.IdDepartamento = D.Id
			LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdDepartamento = R.IdDepartamento and R.RespuestaCompromiso >=0 and R.RespuestaIndicativa >=0  AND R.Presupuesto >=0
			WHERE	P.NIVEL = 2 --departamentos
			AND P.IdTablero = @idTablero
			and P.ACTIVO = 1	
			and D.Id = @IdDepartamento
		) AS T 
		----PREGUTNAS CONSOLIDADO ALCALDIAS
		SELECT @guardoPreguntasConsolidado =CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		FROM (
			SELECT 
			COUNT(R.Id) AS NUM_PREGUNTAS_CONTESTAR, --Respuestas alcaldia
			count(DEP.Id) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO --respuestas del departamento
			FROM [PAT].[PreguntaPAT] AS P
			JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT]  and (R.NecesidadIdentificada >0 or R.RespuestaCompromiso >0)
			JOIN Municipio AS MR ON R.IdMunicipio = MR.Id AND MR.IdDepartamento = @IdDepartamento													
			LEFT OUTER JOIN [PAT].RespuestaPATDepartamento DEP ON R.IdPreguntaPAT = DEP.IdPreguntaPAT and R.IdMunicipio = DEP.IdMunicipioRespuesta and DEP.RespuestaCompromiso>=0 and DEP.Presupuesto >=0
			LEFT OUTER JOIN Municipio AS MRDEP ON DEP.IdMunicipioRespuesta = MRDEP.Id AND MRDEP.IdDepartamento = @IdDepartamento																																			
			WHERE  P.IdTablero = @IdTablero 
			and  P.NIVEL = 3 
			and P.ApoyoDepartamental =1
			and R.IdDepartamento= @IdDepartamento
			and P.ACTIVO = 1  			
		) AS T 		
	end
	if (@TipoEnvio = 'SD1' )--seguimiento departamental
	begin 
		-------------------------------------
		----PREGUNTAS GOBERNACION
		-------------------------------------
		IF NOT EXISTS (Select 1 from @UsuariosSinPlaneacion WHERE IdUsuario = @IdUsuario)--deberia llamarse con planeacion
		BEGIN				
			----Usuarios que no diligenciaron planeacion pueden enviar
			SET @guardoPreguntas = 1						
		END
		ELSE
		BEGIN			
			declare @cantPreguntasGob1 int

			select @cantPreguntasGob1 = count(a.Id)
			from pat.PreguntaPAT a
			where a.IdTablero = @IdTablero and a.Activo = 1 and a.Nivel = 2

			DECLARE @CantPreguntasSeguimientoGob1 INT
			--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
			DECLARE @PreguntasPlaneacionGob1 TABLE (IdPreguntaPAT INT)

			INSERT INTO @PreguntasPlaneacionGob1--inserta las preguntas con respuestas  de la planeacion que dio ese usuario con compromiso >0
			SELECT a.IdPreguntaPAT
			FROM PAT.RespuestaPAT a
			INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
			WHERE b.IdTablero = @IdTablero
			AND a.IdUsuario = @IdUsuario
			AND b.Activo = 1 and b.Nivel = 2
			AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)

			SELECT @CantPreguntasSeguimientoGob1 = COUNT(DISTINCT IdPregunta)
			--FROM PAT.SeguimientoGobernacion as SG
			FROM PAT.Seguimiento as SG
			join @PreguntasPlaneacionGob1 as PG on SG.IdPregunta = PG.IdPreguntaPAT 
			where SG.IdUsuario = @IdUsuario
			AND SG.IdTablero = @IdTablero
			AND (SG.CantidadPrimer >= 0 or SG.PresupuestoPrimer >= 0)			
			and CompromisoDefinitivo >=0 and PresupuestoDefinitivo >= 0

			SELECT @guardoPreguntas = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimientoGob1 THEN 1 ELSE 0 END
			FROM @PreguntasPlaneacionGob1	
		end		
		-------------------------------------
		----PREGUNTAS CONSOLIDADO ALCALDIAS	
		-------------------------------------								
		DECLARE @CantPreguntasSeguimientoGobConsolidado1 INT
		DECLARE @PreguntasPlaneacionGobConsolidado1 TABLE (IdPreguntaPAT INT,IdUsuario int, IdDepartamento int, IdMunicipio int, IdUsuarioAlcaldia INT)--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento

		INSERT INTO @PreguntasPlaneacionGobConsolidado1--inserta las preguntas con respuestas que dio ese usuario con compromiso >0 or OR a.Presupuesto > 0
		SELECT a.IdPreguntaPAT, a.IdUsuario, m.IdDepartamento , a.IdMunicipioRespuesta
		,(select id from dbo.Usuario where IdMunicipio = a.IdMunicipioRespuesta and idestado = 5 and activo = 1 and IdTipoUsuario = 2)
		--, a.RespuestaCompromiso, a.Presupuesto
		FROM PAT.RespuestaPATDepartamento a
		join Municipio as m on a.IdMunicipioRespuesta = m.Id
		INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
		WHERE	b.IdTablero = @IdTablero AND b.Activo = 1 and b.Nivel = 3 And b.ApoyoDepartamental =1 AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0) 

		SELECT 
		@CantPreguntasSeguimientoGobConsolidado1 = COUNT(distinct P.Id)
		--D.Nombre as Departamento, M.Nombre as Municipio, Der.Descripcion as Derecho,P.Id as IdPregunta, P.PreguntaIndicativa , SEG.CantidadSegundo, SEG.PresupuestoSegundo
		--,SEG.IdSeguimiento
		-- count(PPG.IdPreguntaPAT)AS NUM_PREGUNTAS_CONTESTAR, COUNT(SEG.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		FROM @PreguntasPlaneacionGobConsolidado1 as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadPrimer >= 0 or SEG.PresupuestoPrimer >= 0)
		join Departamento as D on PPG.IdDepartamento = D.Id	
		JOIN Municipio AS M ON PPG.IdMunicipio = M.Id		
		WHERE P.IdTablero = 1 and SEG.IdSeguimiento is null	and PPG.IdDepartamento = @IdDepartamento
		--order by D.Nombre, M.Nombre


		SELECT @guardoPreguntasConsolidado = CASE WHEN @CantPreguntasSeguimientoGobConsolidado1 = 0 THEN 1 ELSE 0 END
	
	end
	if ( @TipoEnvio= 'SD2')--seguimiento departamental
	begin 
		-------------------------------------
		----PREGUNTAS GOBERNACION
		-------------------------------------
		IF NOT EXISTS (Select 1 from @UsuariosSinPlaneacion WHERE IdUsuario = @IdUsuario)--deberia llamarse con planeacion
		BEGIN				
			----Usuarios que no diligenciaron planeacion pueden enviar
			SET @guardoPreguntas = 1						
		END
		ELSE
		BEGIN			
			declare @cantPreguntasGob int

			select @cantPreguntasGob = count(a.Id)
			from pat.PreguntaPAT a
			where a.IdTablero = @IdTablero and a.Activo = 1 and a.Nivel = 2

			DECLARE @CantPreguntasSeguimientoGob INT
			--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
			DECLARE @PreguntasPlaneacionGob TABLE (IdPreguntaPAT INT)

			INSERT INTO @PreguntasPlaneacionGob--inserta las preguntas con respuestas  de la planeacion que dio ese usuario con compromiso >0
			SELECT a.IdPreguntaPAT
			FROM PAT.RespuestaPAT a
			INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
			WHERE b.IdTablero = @IdTablero
			AND a.IdUsuario = @IdUsuario
			AND b.Activo = 1 and b.Nivel = 2
			AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)

			SELECT @CantPreguntasSeguimientoGob = COUNT(DISTINCT IdPregunta)
			--FROM PAT.SeguimientoGobernacion as SG
			FROM PAT.Seguimiento as SG
			join @PreguntasPlaneacionGob as PG on SG.IdPregunta = PG.IdPreguntaPAT 
			where SG.IdUsuario = @IdUsuario
			AND SG.IdTablero = @IdTablero
			AND (SG.CantidadSegundo >= 0 or SG.PresupuestoSegundo >= 0)
			AND ObservacionesSegundo IS NOT NULL
			

			SELECT @guardoPreguntas = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimientoGob THEN 1 ELSE 0 END
			FROM @PreguntasPlaneacionGob	
		end		
		-------------------------------------
		----PREGUNTAS CONSOLIDADO ALCALDIAS	
		-------------------------------------						
		--DECLARE @CantPreguntasSeguimientoGobConsolidado INT
		----Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
		--DECLARE @PreguntasPlaneacionGobConsolidado TABLE (IdPreguntaPAT INT,IdUsuarioAlcaldia int)

		--INSERT INTO @PreguntasPlaneacionGobConsolidado--inserta las preguntas con respuestas que dio ese usuario con compromiso >0
		--SELECT a.IdPreguntaPAT, a.IdUsuario
		--FROM PAT.RespuestaPAT a
		--INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
		--WHERE	b.IdTablero = @IdTablero
		--and a.IdDepartamento= @IdDepartamento
		--AND b.Activo = 1 and b.Nivel = 3
		--And b.ApoyoDepartamental =1
		--AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)

		--SELECT @CantPreguntasSeguimientoGobConsolidado = COUNT(IdPregunta)
		--FROM PAT.SeguimientoGobernacion as SEG
		--join @PreguntasPlaneacionGobConsolidado as PPG on SEG.IdPregunta = PPG.IdPreguntaPAT and SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia				
		--WHERE SEG.IdUsuario = @IdUsuario AND SEG.IdUsuarioAlcaldia <> 0 
		--AND IdTablero = @IdTablero
		--AND (CantidadSegundo >= 0 or PresupuestoSegundo >= 0)
		--AND ObservacionesSegundo IS NOT NULL


		DECLARE @CantPreguntasSeguimientoGobConsolidado INT
		DECLARE @PreguntasPlaneacionGobConsolidado TABLE (IdPreguntaPAT INT,IdUsuario int, IdDepartamento int, IdMunicipio int, IdUsuarioAlcaldia INT)--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento

		INSERT INTO @PreguntasPlaneacionGobConsolidado--inserta las preguntas con respuestas que dio ese usuario con compromiso >0 or OR a.Presupuesto > 0
		SELECT a.IdPreguntaPAT, a.IdUsuario, m.IdDepartamento , a.IdMunicipioRespuesta
		,(select id from dbo.Usuario where IdMunicipio = a.IdMunicipioRespuesta and idestado = 5 and activo = 1 and IdTipoUsuario = 2)
		--, a.RespuestaCompromiso, a.Presupuesto
		FROM PAT.RespuestaPATDepartamento a
		join Municipio as m on a.IdMunicipioRespuesta = m.Id
		INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
		WHERE	b.IdTablero = @IdTablero AND b.Activo = 1 and b.Nivel = 3 And b.ApoyoDepartamental =1 AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0) 

		SELECT 
		@CantPreguntasSeguimientoGobConsolidado = COUNT(distinct P.Id)
		--D.Nombre as Departamento, M.Nombre as Municipio, Der.Descripcion as Derecho,P.Id as IdPregunta, P.PreguntaIndicativa , SEG.CantidadSegundo, SEG.PresupuestoSegundo
		--,SEG.IdSeguimiento
		-- count(PPG.IdPreguntaPAT)AS NUM_PREGUNTAS_CONTESTAR, COUNT(SEG.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		FROM @PreguntasPlaneacionGobConsolidado as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadSegundo >= 0 or SEG.PresupuestoSegundo >= 0) AND SEG.ObservacionesSegundo IS NOT NULL and CompromisoDefinitivo >=0 and PresupuestoDefinitivo >= 0
		join Departamento as D on PPG.IdDepartamento = D.Id	
		JOIN Municipio AS M ON PPG.IdMunicipio = M.Id		
		WHERE P.IdTablero = 1 and SEG.IdSeguimiento is null	and PPG.IdDepartamento = @IdDepartamento
		--order by D.Nombre, M.Nombre


		SELECT @guardoPreguntasConsolidado = CASE WHEN @CantPreguntasSeguimientoGobConsolidado = 0 THEN 1 ELSE 0 END
	
	end
		
	-------validaciones de mensajes de error
	IF @TipoEnvio = 'PM'
	begin
		if (@guardoPreguntas = 0)
		begin
			set @esValido = 0
			IF @TipoEnvio = 'PM' AND @IdTablero < 3
			BEGIN
				set @respuesta += 'El Tablero PAT no se puede enviar ya que es de una vigencia anterior.'
			END
			ELSE
			BEGIN
				set @respuesta += 'El Tablero PAT no se puede enviar ya que aún tiene información pendiente por diligenciar.'
			END		
		end
	end
	IF @TipoEnvio = 'PD' or @TipoEnvio = 'SD1' or @TipoEnvio = 'SD2'
	begin
		if (@guardoPreguntas = 0 and @guardoPreguntasConsolidado = 0)
		begin
			set @esValido = 0
			set @respuesta += 'El Tablero PAT no se puede enviar ya que aún tiene información propia y del consolidado de sus municipios pendiente por diligenciar.'
		end
		if (@guardoPreguntas = 0 and @guardoPreguntasConsolidado = 1)
		begin
			set @esValido = 0
			set @respuesta += 'El Tablero PAT no se puede enviar ya que aún tiene información de las preguntas de la gobernación pendiente por diligenciar.'
		end
		if (@guardoPreguntas = 1 and @guardoPreguntasConsolidado = 0)
		begin
			set @esValido = 0
			set @respuesta += 'El Tablero PAT no se puede enviar ya que aún tiene información del consolidado de sus municipios pendiente por diligenciar.'
		end
		if (@guardoPreguntas = 1 and @guardoPreguntasConsolidado = 1)
		begin
			set @esValido = 1			
		end
	end
	IF @TipoEnvio = 'PM' or @TipoEnvio = 'SM1' or @TipoEnvio = 'SM2'
	begin
		if (@guardoPreguntas = 0)
		begin
			set @esValido = 0
			set @respuesta += 'El Tablero PAT no se puede enviar ya que aún tiene información pendiente por diligenciar.'
		end

	end
	if(@esValido = 1) 
	begin
		BEGIN TRY
	
		INSERT INTO [PAT].[EnvioTableroPat]
				   ([IdTablero]
				   ,[IdUsuario]
				   ,[IdMunicipio]
				   ,[IdDepartamento]
				   ,[TipoEnvio]
				   ,[FechaEnvio])
			 VALUES
				   (@IdTablero,@IdUsuario,@IdMunicipio,@IdDepartamento,@TipoEnvio, getdate())
	 			
		
			select @id = SCOPE_IDENTITY()			
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ValidacionEnvioSeguimiento]') ) 
EXEC dbo.sp_executesql @statement = N'CREATE function [PAT].[C_ValidacionEnvioSeguimiento] AS'
go
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		24/04/2018
-- Modified date:	01/06/2018
-- Description:		Obtiene la validacion para el envio del tablero para una pregunta de un municipip.
-- =============================================
ALTER function [PAT].[C_ValidacionEnvioSeguimiento] 
	(@IdMunicipio int,
	@IdPregunta int,@IdUsuario INT, @NumeroSeguimiento int)
RETURNS bit
AS
BEGIN	
    DECLARE @Valido bit
	set @Valido = 1
		
	IF EXISTS (SELECT TOP 1 1 	FROM PAT.RespuestaPAT a
	INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id	
	WHERE a.IdMunicipio = @IdMunicipio AND b.Id = @IdPregunta AND (a.RespuestaCompromiso > 0 OR a.Presupuesto> 0))--TIENE PLANEACION DEBE TENER SEGUIMIENTO
	BEGIN 
		if (@NumeroSeguimiento = 1)
		begin 
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadPrimer >= 0 OR PresupuestoPrimer >= 0))
			BEGIN
				set @Valido = 0
			END
		END
		else		
		begin 
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadSegundo >= 0 OR PresupuestoSegundo >= 0) AND ObservacionesSegundo IS NOT NULL AND CompromisoDefinitivo >= 0 and PresupuestoDefinitivo >= 0)
			BEGIN
				set @Valido = 0
			END
		END
	END
		
	return @Valido
END 

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ValidacionEnvioSeguimiento]') ) 
EXEC dbo.sp_executesql @statement = N'CREATE function [PAT].[C_ValidacionEnvioSeguimiento] AS'
go
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		24/04/2018
-- Modified date:	01/06/2018
-- Description:		Obtiene la validacion para el envio del tablero para una pregunta de un municipip.
-- =============================================
ALTER function [PAT].[C_ValidacionEnvioSeguimiento] 
	(@IdMunicipio int,
	@IdPregunta int,@IdUsuario INT, @NumeroSeguimiento int)
RETURNS bit
AS
BEGIN	
    DECLARE @Valido bit
	set @Valido = 1
		
	IF EXISTS (SELECT TOP 1 1 	FROM PAT.RespuestaPAT a
	INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id	
	WHERE a.IdMunicipio = @IdMunicipio AND b.Id = @IdPregunta AND (a.RespuestaCompromiso > 0 OR a.Presupuesto> 0))--TIENE PLANEACION DEBE TENER SEGUIMIENTO
	BEGIN 
		if (@NumeroSeguimiento = 1)
		begin 
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadPrimer >= 0 OR PresupuestoPrimer >= 0) AND CompromisoDefinitivo >= 0 and PresupuestoDefinitivo >= 0)
			BEGIN
				set @Valido = 0
			END
		END
		else		
		begin 
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadSegundo >= 0 OR PresupuestoSegundo >= 0) AND ObservacionesSegundo IS NOT NULL)
			BEGIN
				set @Valido = 0
			END
		END
	END
		
	return @Valido
END 

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ValidacionEnvioSeguimientoGobernacion]') ) 
EXEC dbo.sp_executesql @statement = N'CREATE function [PAT].[C_ValidacionEnvioSeguimientoGobernacion] AS'
go
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		24/04/2018
-- Modified date:	01/06/2018
-- Description:		Obtiene la validacion para el envio del tablero para una pregunta de un departamento.
-- =============================================
ALTER function [PAT].[C_ValidacionEnvioSeguimientoGobernacion] (@IdUsuario int , @IdPregunta int,@IdDepartamento INT, @NumeroSeguimiento int)
RETURNS bit
AS
BEGIN	
    DECLARE @Valido bit
	set @Valido = 1
		
	IF EXISTS (SELECT top 1 1 FROM PAT.RespuestaPAT a
			INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
			WHERE a.IdDepartamento = @IdDepartamento AND b.Activo = 1 and b.Nivel = 2 and b.Id = @IdPregunta	AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0))--TIENE PLANEACION DEBE TENER SEGUIMIENTO
	BEGIN 
		if (@NumeroSeguimiento = 1)
		begin 		
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadPrimer >= 0 OR PresupuestoPrimer >= 0) AND CompromisoDefinitivo >= 0 and PresupuestoDefinitivo >= 0 )
			BEGIN
				set @Valido = 0
			END
		END
		else		
		begin 
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadSegundo >= 0 OR PresupuestoSegundo >= 0) AND ObservacionesSegundo IS NOT NULL )
			BEGIN
				set @Valido = 0
			END
		END
	END
		
	return @Valido
END 


go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ValidacionEnvioSeguimientoGobernacionConsolidado]') ) 
EXEC dbo.sp_executesql @statement = N'CREATE function [PAT].[C_ValidacionEnvioSeguimientoGobernacionConsolidado] AS'
go
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		24/04/2018
-- Modified date:	01/06/2018
-- Description:		Obtiene la validacion para el envio del tablero para una pregunta del consolidado de un departamento.
-- =============================================
ALTER function   [PAT].[C_ValidacionEnvioSeguimientoGobernacionConsolidado] (@IdUsuario int , @IdPregunta int,@IdDepartamento INT, @NumeroSeguimiento int)
RETURNS bit
AS
BEGIN	
    DECLARE @Valido bit
	set @Valido = 1

	DECLARE @CantPreguntasSeguimientoGobConsolidado INT
	DECLARE @PreguntasPlaneacionGobConsolidado TABLE (IdPreguntaPAT INT,IdUsuario int, IdDepartamento int, IdMunicipio int, IdUsuarioAlcaldia INT)--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento

	INSERT INTO @PreguntasPlaneacionGobConsolidado--inserta las preguntas con respuestas que dio ese usuario con compromiso >0 or OR a.Presupuesto > 0
	SELECT a.IdPreguntaPAT, a.IdUsuario, m.IdDepartamento , a.IdMunicipioRespuesta
	,(select id from dbo.Usuario where IdMunicipio = a.IdMunicipioRespuesta and idestado = 5 and activo = 1 and IdTipoUsuario = 2)
	FROM PAT.RespuestaPATDepartamento a
	join Municipio as m on a.IdMunicipioRespuesta = m.Id
	INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
	WHERE b.Id = @IdPregunta and	a.IdUsuario =@IdUsuario  AND b.Activo = 1 and b.Nivel = 3 And b.ApoyoDepartamental =1 AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0) 
	
	if (@NumeroSeguimiento = 1)
	begin 		
		
		SELECT @CantPreguntasSeguimientoGobConsolidado = COUNT(distinct P.Id)
		FROM @PreguntasPlaneacionGobConsolidado as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadPrimer >= 0 or SEG.PresupuestoPrimer >= 0) AND CompromisoDefinitivo >= 0 and PresupuestoDefinitivo >= 0
		join Departamento as D on PPG.IdDepartamento = D.Id	
		JOIN Municipio AS M ON PPG.IdMunicipio = M.Id		
		WHERE SEG.IdSeguimiento is null	and PPG.IdDepartamento = @IdDepartamento and P.Id = @IdPregunta
		
		Set @Valido = CONVERT(bit,  CASE WHEN @CantPreguntasSeguimientoGobConsolidado = 0 THEN 1 ELSE 0 END)
	END
	else		
	begin 
		
		SELECT @CantPreguntasSeguimientoGobConsolidado = COUNT(distinct P.Id)
		FROM @PreguntasPlaneacionGobConsolidado as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadSegundo >= 0 or SEG.PresupuestoSegundo >= 0) AND SEG.ObservacionesSegundo IS NOT NULL 
		join Departamento as D on PPG.IdDepartamento = D.Id	
		JOIN Municipio AS M ON PPG.IdMunicipio = M.Id		
		WHERE SEG.IdSeguimiento is null	and PPG.IdDepartamento = @IdDepartamento and P.Id = @IdPregunta
		
		Set @Valido = CONVERT(bit,  CASE WHEN @CantPreguntasSeguimientoGobConsolidado = 0 THEN 1 ELSE 0 END)
	END

	return @Valido
END 

go