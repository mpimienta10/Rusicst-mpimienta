/*****************************************************************************************************
* esto es para correr en la base de datos donde se tiene el log
*****************************************************************************************************/
SET IDENTITY_INSERT [dbo].[Category] ON 
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (315, N'Crear Respuesta Acciones consolidado PAT', 183)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (316, N'Editar Respuesta Acciones consolidado PAT', 184)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (317, N'Crear Respuesta Programa consolidado PAT', 185)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (318, N'Editar Respuesta Programa consolidado PAT', 186)
SET IDENTITY_INSERT [dbo].[Category] OFF

go

/*****************************************************************************************************
* De aqui en adelante es para correr en el ambiente de produccion normal
*****************************************************************************************************/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[RespuestaPATAccionDepartamento]')) 
begin 
		CREATE TABLE [PAT].[RespuestaPATAccionDepartamento](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[IdRespuestaPAT] [int] NOT NULL,
			[Accion] [nvarchar](500) NOT NULL,
			[Activo] [bit] NULL,
		 CONSTRAINT [PK_RespuestaPATAccionDepartamento] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]

		ALTER TABLE [PAT].[RespuestaPATAccionDepartamento]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATAccionDepartamento_RespuestaPATDepartamento] FOREIGN KEY([IdRespuestaPAT])
		REFERENCES [PAT].[RespuestaPATDepartamento] ([Id])

		ALTER TABLE [PAT].[RespuestaPATAccionDepartamento] CHECK CONSTRAINT [FK_RespuestaPATAccionDepartamento_RespuestaPATDepartamento]
end

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_RespuestaAccionesDepartamentoInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_RespuestaAccionesDepartamentoInsert] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-02-20																			  
/Descripcion: Ingresa las acciones de la respuesta que da el departamento por cada uno de sus municipios
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_RespuestaAccionesDepartamentoInsert] 
           @IDPATRESPUESTA int,
           @ACCION nvarchar(500),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATAccionDepartamento]
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
		
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_RespuestaAccionesDepartamentoUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_RespuestaAccionesDepartamentoUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-02-20																			  
/Descripcion: Actualiza las acciones de la respuesta que da el departamento por cada uno de sus municipios										  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_RespuestaAccionesDepartamentoUpdate] 
		@ID int,
		@IDPATRESPUESTA int,
        @ACCION nvarchar(500),
        @ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATAccionDepartamento]
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
		
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_AccionesPAT]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_AccionesPAT] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma Rodriguez
-- Create date:		08/08/2016
-- Modified date:	20/02/2018
-- Description:		Obtiene las acciones compromisos de la gestión municipal 
-- '' cuando son preguntas del municipio
-- RC cuando son acciones de preguntas Reparacion colectiva
-- RR cuando son acciones de preguntas Retornos y reubicaciones
-- DM cuando son acciones de preguntas de municipios pero son respuestas de las gobernaciones.
-- =============================================
ALTER PROCEDURE [PAT].[C_AccionesPAT]--,'RC'--1,'RR'--1,''
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
	IF @OPCION = 'DM' 
	BEGIN	
		SELECT	A.ACCION ,A.ID
		FROM	[PAT].[RespuestaPATDepartamento] (NOLOCK) AS R
		JOIN	[PAT].[RespuestaPATAccionDepartamento] (NOLOCK) AS A ON R.ID = A.[IdRespuestaPAT]
		WHERE	A.ACTIVO = 1 AND R.ID = @ID
	END
END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[RespuestaPATProgramaDepartamento]')) 
begin
		CREATE TABLE [PAT].[RespuestaPATProgramaDepartamento](
			[Id] [int] IDENTITY(1,1) NOT NULL,
			[IdRespuestaPAT] [int] NOT NULL,
			[Programa] [nvarchar](1000) NOT NULL,
			[Activo] [bit] NULL,
		 CONSTRAINT [PK_RespuestaPATProgramaDepartamento] PRIMARY KEY CLUSTERED 
		(
			[Id] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]

		ALTER TABLE [PAT].[RespuestaPATProgramaDepartamento]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATProgramaDepartamento_RespuestaPATDepartamento] FOREIGN KEY([IdRespuestaPAT])
		REFERENCES [PAT].[RespuestaPATDepartamento] ([Id])

		ALTER TABLE [PAT].[RespuestaPATProgramaDepartamento] CHECK CONSTRAINT [FK_RespuestaPATProgramaDepartamento_RespuestaPATDepartamento]
end

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_RespuestaProgramaDepartamentoInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_RespuestaProgramaDepartamentoInsert] AS'
go
/*****************************************************************************************************
/ Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma Rodriguez
/ Create date:		20/02/2018
/ Modified date:	20/02/2018
/Descripcion: Inserta la información del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_RespuestaProgramaDepartamentoInsert] 
           @ID_PAT_RESPUESTA int,
           @PROGRAMA nvarchar(1000),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATProgramaDepartamento]
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
		
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_RespuestaProgramaDepartamentoUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_RespuestaProgramaDepartamentoUpdate] AS'
go
/*****************************************************************************************************
/Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma Rodriguez
/Create date:	20/02/2018
/Modified date:	20/02/2018
/Descripcion: Actualiza la información de los programas de las preguntas del municipio que responde la gobernacion												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_RespuestaProgramaDepartamentoUpdate] 
		@ID int,
		@ID_PAT_RESPUESTA int,
		@PROGRAMA nvarchar(1000),
		@ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATProgramaDepartamento]
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
		
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ProgramasDepartamentoPAT]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ProgramasDepartamentoPAT] AS'
go
/*****************************************************************************************************
/Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma Rodriguez
/Create date:	20/02/2018
/Modified date:	20/02/2018
/Descripcion: trae información de los programas de las preguntas del municipio que responde la gobernacion												  
******************************************************************************************************/
ALTER PROCEDURE [PAT].[C_ProgramasDepartamentoPAT]( 
	@ID as INT	
)
AS
BEGIN
	SET NOCOUNT ON;	

	SELECT	P.PROGRAMA,P.ID
	FROM	[PAT].[RespuestaPATDepartamento] (NOLOCK) AS R,
			[PAT].[RespuestaPATProgramaDepartamento] (NOLOCK) AS P
	WHERE	R.ID = P.[IdRespuestaPAT] AND P.ACTIVO = 1 AND R.ID = @ID
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_NumeroSeguimiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_NumeroSeguimiento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/08/2017
-- Modified date:	20/02/2018
-- Description:		Retorna el numero de seguimiento de acuerdo al momento en el que se llame el procedimiento
-- =============================================
ALTER PROC  [PAT].[C_NumeroSeguimiento]  --[PAT].[C_NumeroSeguimiento] 1,2
(
	@IdTablero INT
	,@Nivel INT
)
AS
BEGIN
	declare @date datetime
	set @date = getdate()
	select 
		case when (@date between [Seguimiento1Inicio] and [Seguimiento1Fin]) then 1
			 when (@date between [Seguimiento2Inicio] and [Seguimiento2Fin]) then 2 end as NumeroSeguimiento,
	Id, IdTablero, Nivel, VigenciaInicio, Vigenciafin, Activo
	from pat.TableroFecha
	where IdTablero = @IdTablero  and nivel = @Nivel


END
go
IF  NOT EXISTS (select 1 from sys.columns where Name = N'FechaSeguimientoSegundo' and Object_ID = Object_ID(N'PAT.Seguimiento'))
BEGIN
	ALTER TABLE PAT.Seguimiento ADD
	FechaSeguimientoSegundo datetime NULL,
	FechaUltimaModificacion datetime NULL,
	FechaUltimaModificacionSegundo datetime NULL
end
GO
IF  NOT EXISTS (select 1 from sys.columns where Name = N'FechaSeguimientoSegundo' and Object_ID = Object_ID(N'PAT.SeguimientoGobernacion'))
BEGIN
ALTER TABLE PAT.SeguimientoGobernacion ADD
	FechaSeguimientoSegundo datetime NULL,
	FechaUltimaModificacion datetime NULL,
	FechaUltimaModificacionSegundo datetime NULL
end
GO

ALTER TABLE PAT.Seguimiento ALTER COLUMN FechaSeguimiento datetime null
ALTER TABLE PAT.SeguimientoGobernacion ALTER COLUMN FechaSeguimiento datetime null
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_SeguimientoMunicipalInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_SeguimientoMunicipalInsert] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Fecha modificacion: 2018-20-02																			  
/Descripcion: Inserta la información del seguimeinto municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_SeguimientoMunicipalInsert]
				@IdTablero tinyint
			   ,@IdPregunta smallint
			   ,@IdUsuario int			   
			   ,@CantidadPrimer bigint
			   ,@PresupuestoPrimer money
			   ,@CantidadSegundo bigint
			   ,@PresupuestoSegundo money
			   ,@Observaciones varchar(max)
			   ,@NombreAdjunto varchar(200)
			   ,@ObservacionesSegundo varchar(max)
			   ,@NombreAdjuntoSegundo varchar(200)
		AS 	

	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	

	-- desde aqui se ingresan los campios para auditoria de fechas
	declare @numSeguimiento int
	declare @date datetime, @FechaSeguimiento datetime, @FechaSeguimientoSegundo datetime, @FechaUltimaModificacion datetime, @FechaUltimaModificacionSegundo datetime
	set @date = getdate()
	select @numSeguimiento = case when (@date between [Seguimiento1Inicio] and [Seguimiento1Fin]) then 1
								  when (@date between [Seguimiento2Inicio] and [Seguimiento2Fin]) then 2 end 	
	from pat.TableroFecha where IdTablero = @IdTablero  and nivel = 3
		
	if (@numSeguimiento = 1)
	begin
		set @FechaSeguimiento = getdate()
		set @FechaSeguimientoSegundo = null
	end
	else
	begin
		set @FechaSeguimientoSegundo = getdate()
		set @FechaSeguimiento = null
	end
	--
	if @ObservacionesSegundo is null
		set @ObservacionesSegundo = ''
	
	if(@esValido = 1) 
	begin
		BEGIN TRY				
			INSERT INTO [PAT].[Seguimiento]
				   ([IdTablero]
				   ,[IdPregunta]
				   ,[IdUsuario]
				   ,[FechaSeguimiento]
				   ,[CantidadPrimer]
				   ,[PresupuestoPrimer]
				   ,[CantidadSegundo]
				   ,[PresupuestoSegundo]
				   ,[Observaciones]
				   ,[NombreAdjunto]
				   ,[ObservacionesSegundo]
				   ,[NombreAdjuntoSegundo]
				   ,[FechaSeguimientoSegundo])
			 VALUES
				   (@IdTablero 
				   ,@IdPregunta 
				   ,@IdUsuario 
				   ,@FechaSeguimiento 
				   ,@CantidadPrimer 
				   ,@PresupuestoPrimer 
				   ,@CantidadSegundo 
				   ,@PresupuestoSegundo 
				   ,@Observaciones 
				   ,@NombreAdjunto 
				   ,@ObservacionesSegundo				
				   ,@NombreAdjuntoSegundo
				   ,@FechaSeguimientoSegundo)
		
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


	go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_SeguimientoGobernacionInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_SeguimientoGobernacionInsert]   AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Fecha modificacion: 2018-20-02
/Descripcion: Inserta la información del seguimeinto municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_SeguimientoGobernacionInsert]
				@IdTablero tinyint
			   ,@IdPregunta smallint
			   ,@IdUsuario int	
			   ,@IdUsuarioAlcaldia int		   
			   ,@CantidadPrimer bigint
			   ,@PresupuestoPrimer money
			   ,@CantidadSegundo bigint
			   ,@PresupuestoSegundo money
			   ,@Observaciones varchar(max)
			   ,@NombreAdjunto varchar(200)
			   ,@ObservacionesSegundo varchar(max)
			   ,@NombreAdjuntoSegundo varchar(200)
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	
	-- desde aqui se ingresan los campios para auditoria de fechas
	declare @numSeguimiento int
	declare @date datetime, @FechaSeguimiento datetime, @FechaSeguimientoSegundo datetime, @FechaUltimaModificacion datetime, @FechaUltimaModificacionSegundo datetime
	set @date = getdate()
	select @numSeguimiento = case when (@date between [Seguimiento1Inicio] and [Seguimiento1Fin]) then 1
								  when (@date between [Seguimiento2Inicio] and [Seguimiento2Fin]) then 2 end 	
	from pat.TableroFecha where IdTablero = @IdTablero  and nivel = 2
		
	if (@numSeguimiento = 1)
	begin
		set @FechaSeguimiento = getdate()
		set @FechaSeguimientoSegundo = null
	end
	else
	begin
		set @FechaSeguimientoSegundo = getdate()
		set @FechaSeguimiento = null
	end
	--
	if (@CantidadSegundo = -1)
		set @CantidadSegundo = 0
		
	if (@PresupuestoSegundo = -1)
		set @PresupuestoSegundo = 0

	if @ObservacionesSegundo is null
		set @ObservacionesSegundo = ''
							
	if(@esValido = 1) 
	begin
		BEGIN TRY				
			INSERT INTO [PAT].[SeguimientoGobernacion]
				   ([IdTablero]
				   ,[IdPregunta]
				   ,[IdUsuario]
				   ,[IdUsuarioAlcaldia]
				   ,[FechaSeguimiento]
				   ,[CantidadPrimer]
				   ,[PresupuestoPrimer]
				   ,[CantidadSegundo]
				   ,[PresupuestoSegundo]
				   ,[Observaciones]
				   ,[NombreAdjunto]
				   ,[ObservacionesSegundo]
				   ,[NombreAdjuntoSegundo]
				   ,[FechaSeguimientoSegundo])
			 VALUES
				   (@IdTablero 
				   ,@IdPregunta 
				   ,@IdUsuario 
				   ,@IdUsuarioAlcaldia
				   ,getdate() 
				   ,@CantidadPrimer 
				   ,@PresupuestoPrimer 
				   ,@CantidadSegundo 
				   ,@PresupuestoSegundo 
				   ,@Observaciones 
				   ,@NombreAdjunto  
				   ,@ObservacionesSegundo				
				   ,@NombreAdjuntoSegundo
				   ,@FechaSeguimientoSegundo)						
		
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


go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_SeguimientoMunicipalUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_SeguimientoMunicipalUpdate]   AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29	
/Fecha modificacion: 2018-20-02																		  
/Descripcion: Inserta la información del seguimeinto municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_SeguimientoMunicipalUpdate] 
				@IdSeguimiento int			   
			   ,@IdTablero tinyint
			   ,@IdPregunta smallint
			   ,@IdUsuario int			   
			   ,@CantidadPrimer bigint
			   ,@PresupuestoPrimer money
			   ,@CantidadSegundo bigint
			   ,@PresupuestoSegundo money
			   ,@Observaciones varchar(max)
			   ,@NombreAdjunto varchar(200)
			   ,@ObservacionesSegundo varchar(max)
			   ,@NombreAdjuntoSegundo varchar(200)
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	
	-- desde aqui se ingresan los campios para auditoria de fechas
	declare @numSeguimiento int
	declare @date datetime, @FechaSeguimiento datetime, @FechaSeguimientoSegundo datetime, @FechaUltimaModificacion datetime, @FechaUltimaModificacionSegundo datetime
	set @date = getdate()
	select @numSeguimiento = case when (@date between [Seguimiento1Inicio] and [Seguimiento1Fin]) then 1
								  when (@date between [Seguimiento2Inicio] and [Seguimiento2Fin]) then 2 end 	
	from pat.TableroFecha where IdTablero = @IdTablero  and nivel = 3
		
	if (@numSeguimiento = 1)
	begin		
		set @FechaUltimaModificacion = @date
		set @FechaSeguimientoSegundo = null
		set @FechaUltimaModificacionSegundo = null
	end
	else
	begin
		set @FechaUltimaModificacionSegundo =@date
		select 
		@FechaSeguimientoSegundo = case when FechaSeguimientoSegundo is null then @date else FechaSeguimientoSegundo end ,
		@FechaUltimaModificacionSegundo = case when FechaUltimaModificacionSegundo is null then @date else FechaUltimaModificacionSegundo end 
		from PAT.Seguimiento
		where IdSeguimiento = @IdSeguimiento
	end
	--
	if @ObservacionesSegundo is null
		set @ObservacionesSegundo = ''
			
	if(@esValido = 1) 
	begin
		BEGIN TRY				
			update [PAT].[Seguimiento] set 
				   [CantidadPrimer] = @CantidadPrimer
				   ,[PresupuestoPrimer] = @PresupuestoPrimer
				   ,[CantidadSegundo] = @CantidadSegundo
				   ,[PresupuestoSegundo] = @PresupuestoSegundo
				   ,[Observaciones] = @Observaciones
				   ,[NombreAdjunto] = @NombreAdjunto
				   ,[ObservacionesSegundo]=@ObservacionesSegundo
				   ,[NombreAdjuntoSegundo]=@NombreAdjuntoSegundo
				   ,FechaUltimaModificacion =@FechaUltimaModificacion
				   ,FechaSeguimientoSegundo = @FechaSeguimientoSegundo
				   ,FechaUltimaModificacionSegundo = @FechaUltimaModificacionSegundo
			where  IdSeguimiento = @IdSeguimiento
					
			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end
	select @respuesta as respuesta, @estadoRespuesta as estado			


go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_SeguimientoGobernacionUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_SeguimientoGobernacionUpdate]   AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Fecha modificacion: 2018-20-02																			  
/Descripcion: Inserta la información del seguimeinto municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_SeguimientoGobernacionUpdate] 
				@IdSeguimiento int			   
			   ,@IdTablero tinyint
			   ,@IdPregunta smallint
			   ,@IdUsuario int		
			   ,@IdUsuarioAlcaldia int		   	   
			   ,@CantidadPrimer bigint
			   ,@PresupuestoPrimer money
			   ,@CantidadSegundo bigint
			   ,@PresupuestoSegundo money
			   ,@Observaciones varchar(max)
			   ,@NombreAdjunto varchar(200)
			   ,@ObservacionesSegundo varchar(max)
			   ,@NombreAdjuntoSegundo varchar(200)
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	
	
	-- desde aqui se ingresan los campios para auditoria de fechas
	declare @numSeguimiento int
	declare @date datetime, @FechaSeguimiento datetime, @FechaSeguimientoSegundo datetime, @FechaUltimaModificacion datetime, @FechaUltimaModificacionSegundo datetime
	set @date = getdate()
	select @numSeguimiento = case when (@date between [Seguimiento1Inicio] and [Seguimiento1Fin]) then 1
								  when (@date between [Seguimiento2Inicio] and [Seguimiento2Fin]) then 2 end 	
	from pat.TableroFecha where IdTablero = @IdTablero  and nivel = 2
		
	if (@numSeguimiento = 1)
	begin		
		set @FechaUltimaModificacion = @date
		set @FechaSeguimientoSegundo = null
		set @FechaUltimaModificacionSegundo = null
	end
	else
	begin
		set @FechaUltimaModificacionSegundo =@date
		select 
		@FechaSeguimientoSegundo = case when FechaSeguimientoSegundo is null then @date else FechaSeguimientoSegundo end ,
		@FechaUltimaModificacionSegundo = case when FechaUltimaModificacionSegundo is null then @date else FechaUltimaModificacionSegundo end 
		from PAT.[SeguimientoGobernacion]
		where IdSeguimiento = @IdSeguimiento
	end
	--
	if @ObservacionesSegundo is null
		set @ObservacionesSegundo = ''
			
	if(@esValido = 1) 
	begin
		BEGIN TRY				
			update [PAT].[SeguimientoGobernacion] set 
				   [CantidadPrimer] = @CantidadPrimer
				   ,[PresupuestoPrimer] = @PresupuestoPrimer
				   ,[CantidadSegundo] = @CantidadSegundo
				   ,[PresupuestoSegundo] = @PresupuestoSegundo
				   ,[Observaciones] = @Observaciones
				   ,[NombreAdjunto] = @NombreAdjunto
				   ,[ObservacionesSegundo]=@ObservacionesSegundo
				   ,[NombreAdjuntoSegundo]=@NombreAdjuntoSegundo
				   ,FechaUltimaModificacion =@FechaUltimaModificacion
				   ,FechaSeguimientoSegundo = @FechaSeguimientoSegundo
				   ,FechaUltimaModificacionSegundo = @FechaUltimaModificacionSegundo
			where  IdSeguimiento = @IdSeguimiento
					
			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end
	select @respuesta as respuesta, @estadoRespuesta as estado			

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_EnvioTableroPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_EnvioTableroPat]   AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez																		  
/Fecha creacion:     2017-12-11	
/Fecha modificacion :2018-02-14
/Descripcion: Inserta los datos de envio de los tres tipos de tablero: Planeacion Municipal "PM", Planeacion Departamental "PD"
/, Primer Seguimiento Municpal "SM1", Segundo Seguimiento Municpal "SM2"						  
/, Primer Seguimiento Departamental "SD1", Segundo Seguimiento Departamental "SD2"						  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_EnvioTableroPat] 
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
	
	--if (@id is not null)
	--begin
	--	set @esValido = 0
	--	set @respuesta += 'El tablero ya ha sido enviado con anterioridad.'
	--end
	------------------------------------------------------------------------------
	--validacion de que halla guardado las preguntas del municipio correspondiente	
	------------------------------------------------------------------------------
	declare @guardoPreguntas bit
	set @guardoPreguntas = 0
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
	end
	if ( @TipoEnvio= 'SM2')--seguimiento municipal
	begin 
		SELECT @guardoPreguntas = CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		FROM (
			SELECT 
			COUNT(distinct R.Id) AS NUM_PREGUNTAS_CONTESTAR, 
			count(distinct SM.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
			FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
			join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
			JOIN Municipio AS M ON PM.IdMunicipio = M.Id
			JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >=0
			LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = P.ID AND SM.IdUsuario = R.IdUsuario and SM.CantidadSegundo >= 0 and SM.PresupuestoSegundo >=0	and SM.ObservacionesSegundo is not null
			WHERE	P.NIVEL = 3 --municipios
			AND P.IdTablero = @idTablero
			and P.ACTIVO = 1	
			and M.Id = @IdMunicipio
		) AS T 
	end

	if (@guardoPreguntas = 0)
	begin
		set @esValido = 0
		set @respuesta += 'El Tablero PAT no se puede enviar ya que aún tiene información pendiente por diligenciar.'
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








