
/*****************************************************************************************************
* esto es para correr en la base de datos donde se tiene el log
*****************************************************************************************************/
SET IDENTITY_INSERT [dbo].[Category] ON 
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (319, N'Envío planeación municipal del Tablero PAT', 187)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (320, N'Envío planeación departamental del Tablero PAT', 188)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (321, N'Envío primer seguimiento municipal del Tablero PAT', 189)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (322, N'Envío segundo seguimiento municipal del Tablero PAT', 190)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (323, N'Envío primer seguimiento departamental del Tablero PAT', 191)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (324, N'Envío segundo seguimiento departamental del Tablero PAT', 192)
SET IDENTITY_INSERT [dbo].[Category] OFF

go

/*****************************************************************************************************
* De aqui en adelante es para correr en el ambiente de produccion normal
*****************************************************************************************************/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosMunicipiosCompletos]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosMunicipiosCompletos] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	20/11/2017
-- Description:		Retorna los tableros de nivel 3 que hacen referencia a la gestion MUNICIPAL que ya no estan vigentes
-- ==========================================================================================

ALTER PROC [PAT].[C_TodosTablerosMunicipiosCompletos]
AS
BEGIN
	select
	A.[Id],
	B.[VigenciaInicio],
	B.[VigenciaFin], 
	YEAR(B.[VigenciaInicio])+1 AS Planeacion
	from
	[PAT].[Tablero] A,
	[PAT].[TableroFecha] B
	where
	A.[Id]=B.[IdTablero]
	and B.[Nivel]=3
	and B.[Activo]=1
	and GETDATE() > B.[VigenciaFin] --B.[VigenciaFin] < GETDATE()
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosMunicipiosPorCompletar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosMunicipiosPorCompletar] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	20/11/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que estan vigentes
-- ==========================================================================================
ALTER PROC [PAT].[C_TodosTablerosMunicipiosPorCompletar]
AS
BEGIN
	select  A.Id,  B.Vigenciainicio, B.VigenciaFin , 	YEAR(B.[VigenciaInicio])+1 AS Planeacion
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=3
	and B.[Activo]=1
	and GETDATE() between B.Vigenciainicio and B.[VigenciaFin]--GETDATE() >= B.Vigenciainicio and GETDATE() <= B.[VigenciaFin]
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_TableroPatUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_TableroPatUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-10-28																			  
/Descripcion: Actualiza la información de las preguntas 
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_TableroPatUpdate]
			  @Id int,
			  @IdTablero int,
			  @Nivel tinyint,
			  @VigenciaInicio smalldatetime,
			  @VigenciaFin smalldatetime,
			  @Activo bit,
			  @Seguimiento1Inicio datetime,
			  @Seguimiento1Fin datetime,
			  @Seguimiento2Inicio datetime,
			  @Seguimiento2Fin datetime
		AS 	
	SET DATEFORMAT YMD

	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado

	if (@VigenciaInicio <> '')
		set @VigenciaInicio = CAST( convert(char(10),@VigenciaInicio,121)+' 00:00:00' as datetime)
	if (@VigenciaFin <> '')
		set @VigenciaFin = CAST( convert(char(10),@VigenciaFin,121)+' 23:59:00' as datetime)
	if (@Seguimiento1Inicio <> '')
		set @Seguimiento1Inicio = CAST( convert(char(10),@Seguimiento1Inicio,121)+' 00:00:00' as datetime)
	if (@Seguimiento2Inicio <> '')
		set @Seguimiento2Inicio = CAST( convert(char(10),@Seguimiento2Inicio,121)+' 00:00:00' as datetime)
	if (@Seguimiento1Fin <>'')
		set @Seguimiento1Fin = CAST( convert(char(10),@Seguimiento1Fin,121)+' 23:59:00' as datetime)
	if (@Seguimiento2Fin <> '')
		set @Seguimiento2Fin = CAST( convert(char(10),@Seguimiento2Fin,121)+' 23:59:00' as datetime)

	BEGIN TRY		
		UPDATE [PAT].[TableroFecha]
		SET [IdTablero] = @IdTablero 
			,[Nivel] = @Nivel
			,[VigenciaInicio] = @VigenciaInicio
			,[VigenciaFin] = @VigenciaFin
			,[Activo] = @Activo
			,[Seguimiento1Inicio] = @Seguimiento1Inicio
			,[Seguimiento1Fin] = @Seguimiento1Fin
			,[Seguimiento2Inicio] = @Seguimiento2Inicio
			,[Seguimiento2Fin] = @Seguimiento2Fin
		WHERE  Id = @id
		--si por lo menos se tiene un nivel activo se debe activar el tablero
		if ((select COUNT(1) from PAT.[TableroFecha] where Activo = 1  and  IdTablero = @IdTablero )>0)
			update PAT.Tablero set Activo = 1 where Id = @IdTablero
		--si todas estan inactivas de debe inactivar el tablero
		if ((select COUNT(1) from PAT.[TableroFecha] where Activo = 0 and  IdTablero = @IdTablero )=3)
			update PAT.Tablero set Activo = @Activo where Id = @IdTablero
		SELECT @respuesta = 'Se ha modificado el registro'
		SELECT @estadoRespuesta = 2
	
	END TRY
	BEGIN CATCH
		SELECT @respuesta = ERROR_MESSAGE()
		SELECT @estadoRespuesta = 0
	END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado			
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------CONSUMO DE SERVICIOS WEB-------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PAT.AuditoriaConsumoWS')) 
begin
	CREATE TABLE PAT.AuditoriaConsumoWS
		(
		Id  int identity (1,1)  ,		
		Metodo varchar(500) NULL,
		NumeroRegistros int null,
		Inicio datetime,
		Termino datetime null
		)  ON [PRIMARY]
end
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PAT.AuditoriaConsumoWSError')) 
begin
	CREATE TABLE PAT.AuditoriaConsumoWSError
		(
		Id  int identity (1,1)  ,
		IdAuditoria  int ,
		Hora datetime,
		Error varchar(max) NULL,
		Datos varchar(max) NULL		
		)  ON [PRIMARY]
end
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PAT.EntidadNacional')) 
begin
	CREATE  TABLE PAT.EntidadNacional
		(
		IdEntidadNacional int ,
		NombreEntidadNacional varchar(500),
		CodigoEntidadNacional varchar(500) NULL,
		FechaUltimaModificacion datetime
		)  ON [PRIMARY]
end
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PAT.CompromisosEntidadNacional')) 
begin
CREATE  TABLE PAT.CompromisosEntidadNacional
	(
	IdTablero int,
	Vigencia int,
	IdPregunta int,
	DaneDepartamento int,
	DaneMunicipio int,
	IdEntidadNacional int ,
	NombreEntidadNacional varchar(500) NULL,
	CompromisoNivelNacional int NULL,
	ReporteCompromisos varchar(MAX) NULL,
	PresupuestoNivelNacional int NULL,
	NombreProyectoInversion varchar(MAX) NULL,
	CodBPINProyecto varchar(500) NULL,
	Observaciones varchar(MAX) NULL,
	FechaUltimaModificacion datetime
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
end
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PAT.SeguimientoEntidadNacional')) 
begin
CREATE  TABLE PAT.SeguimientoEntidadNacional
	(
	IdTablero int ,
	Vigencia int ,
	IdPregunta int ,
	DaneDepartamento int ,
	DaneMunicipio int ,
	IdEntidadNacional int ,
	NombreEntidadNacional varchar(500) NULL,
	CantidadEjecutada int NULL,
	CompromisoCumplido bit NULL,
	DificultadesEncontradas varchar(MAX) NULL,
	AccionesParaSuperarDificultades varchar(MAX) NULL,
	Soporte varchar(MAX) NULL,
	PresupuestoEjecutado int NULL,
	Observaciones varchar(MAX) NULL,
	Semestre int ,
	FechaUltimaModificacion datetime
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
end
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_AuditoriaConsumoWSInsertUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_AuditoriaConsumoWSInsertUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-02-26																			  
/Descripcion: Inserta  o actualiza la informacion de las entidades nacionales que provienen del WS de la Unidad De Victimas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_AuditoriaConsumoWSInsertUpdate] 
		@Id		INT,
		@Metodo	NVARCHAR(500),
		@NumeroRegistros int
AS 		
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
		
	IF(@Id>0)
	BEGIN
		update [PAT].AuditoriaConsumoWS set  Termino = GETDATE(),NumeroRegistros=@NumeroRegistros
		where [Id] = @Id
		SELECT @respuesta = 'Se ha modificado el registro'
		SELECT @estadoRespuesta = 1			
	END
	else	
	BEGIN
		INSERT INTO [PAT].AuditoriaConsumoWS (Metodo,Inicio,NumeroRegistros)
		VALUES(@Metodo, GETDATE(),@NumeroRegistros)
  		
		select @id = SCOPE_IDENTITY()	
		SELECT @respuesta = 'Se ha ingresado el registro'
		SELECT @estadoRespuesta = 1			
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado, @id as id
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_AuditoriaConsumoErrorWSInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_AuditoriaConsumoErrorWSInsert] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-02-26																			  
/Descripcion: Inserta  o actualiza la informacion de las entidades nacionales que provienen del WS de la Unidad De Victimas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_AuditoriaConsumoErrorWSInsert] 
		@IdAuditoria INT,
		@Error	NVARCHAR(max),
		@Datos	NVARCHAR(max)
AS 		
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
			
	INSERT INTO [PAT].AuditoriaConsumoWSError (IdAuditoria,Hora,Error,Datos)
	VALUES(@IdAuditoria,GETDATE(),@Error,@Datos)
  		
	SELECT @respuesta = 'Se ha ingresado el registro'
	SELECT @estadoRespuesta = 1			
	
	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_EntidadNacionalInsertUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_EntidadNacionalInsertUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-02-26																			  
/Descripcion: Inserta  o actualiza la informacion de las entidades nacionales que provienen del WS de la Unidad De Victimas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_EntidadNacionalInsertUpdate] 
		@IdEntidadNacional		INT,
		@NombreEntidadNacional	NVARCHAR(500),
		@CodigoEntidadNacional	NVARCHAR(500)	
AS 	
	
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
		
	IF(select top 1 1 from  PAT.EntidadNacional where IdEntidadNacional = @IdEntidadNacional) >=1
	BEGIN
		update [PAT].[EntidadNacional] set [NombreEntidadNacional] = @NombreEntidadNacional, [CodigoEntidadNacional] = @CodigoEntidadNacional, [FechaUltimaModificacion] = GETDATE() 
		where [IdEntidadNacional] = @IdEntidadNacional
		SELECT @respuesta = 'Se ha modificado el registro'
		SELECT @estadoRespuesta = 1			
	END
	else	
	BEGIN
		INSERT INTO [PAT].[EntidadNacional]
           ([IdEntidadNacional]
           ,[NombreEntidadNacional]
           ,[CodigoEntidadNacional]
		   ,[FechaUltimaModificacion])
		VALUES(@IdEntidadNacional,@NombreEntidadNacional,@CodigoEntidadNacional, GETDATE())
  
		SELECT @respuesta = 'Se ha ingresado el registro'
		SELECT @estadoRespuesta = 1			
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_CompromisoEntidadNacionalInsertUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_CompromisoEntidadNacionalInsertUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-02-26																			  
/Descripcion: Inserta  o actualiza la informacion de las entidades nacionales que provienen del WS de la Unidad De Victimas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_CompromisoEntidadNacionalInsertUpdate] 
		@IdTablero int,
		@Vigencia int,
		@IdPregunta int,
		@DaneDepartamento int,
		@DaneMunicipio int,
		@IdEntidadNacional int ,
		@NombreEntidadNacional varchar(500) NULL,
		@CompromisoNivelNacional int NULL,
		@ReporteCompromisos varchar(MAX) NULL,
		@PresupuestoNivelNacional int NULL,
		@NombreProyectoInversion varchar(MAX) NULL,
		@CodBPINProyecto varchar(500) NULL,
		@Observaciones varchar(MAX) NULL
AS 	
	
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
		
	IF(select top 1 1 from  PAT.CompromisosEntidadNacional where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional) >=1
	BEGIN
		update [PAT].[CompromisosEntidadNacional] 
					set NombreEntidadNacional =@NombreEntidadNacional, 
					    CompromisoNivelNacional = @CompromisoNivelNacional, 
					    ReporteCompromisos=@ReporteCompromisos, 
					    PresupuestoNivelNacional=@PresupuestoNivelNacional, 
					    NombreProyectoInversion= @NombreProyectoInversion, 
					    CodBPINProyecto=@CodBPINProyecto, 
					    Observaciones=@Observaciones,
						[FechaUltimaModificacion] = GETDATE()
		where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional
		SELECT @respuesta = 'Se ha modificado el registro'
		SELECT @estadoRespuesta = 1			
	END
	else	
	BEGIN
			INSERT INTO [PAT].[CompromisosEntidadNacional]
					   ([IdTablero]
					   ,[Vigencia]
					   ,[IdPregunta]
					   ,[DaneDepartamento]
					   ,[DaneMunicipio]
					   ,[IdEntidadNacional]
					   ,[NombreEntidadNacional]
					   ,[CompromisoNivelNacional]
					   ,[ReporteCompromisos]
					   ,[PresupuestoNivelNacional]
					   ,[NombreProyectoInversion]
					   ,[CodBPINProyecto]
					   ,[Observaciones]
					   ,[FechaUltimaModificacion])
				 VALUES
					   (@IdTablero,
					   @Vigencia, 
					   @IdPregunta,
					   @DaneDepartamento,
					   @DaneMunicipio, 
					   @IdEntidadNacional, 
					   @NombreEntidadNacional, 
					   @CompromisoNivelNacional, 
					   @ReporteCompromisos, 
					   @PresupuestoNivelNacional, 
					   @NombreProyectoInversion, 
					   @CodBPINProyecto, 
					   @Observaciones
					   ,GETDATE())

		SELECT @respuesta = 'Se ha ingresado el registro'
		SELECT @estadoRespuesta = 1			
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

	
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_SeguimientoEntidadNacionalInsertUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_SeguimientoEntidadNacionalInsertUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-02-26																			  
/Descripcion: Inserta  o actualiza la informacion de las entidades nacionales que provienen del WS de la Unidad De Victimas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_SeguimientoEntidadNacionalInsertUpdate] 
		@IdTablero int ,
		@Vigencia int ,
		@IdPregunta int ,
		@DaneDepartamento int ,
		@DaneMunicipio int ,
		@IdEntidadNacional int ,
		@NombreEntidadNacional varchar(500) NULL,
		@CantidadEjecutada int NULL,
		@CompromisoCumplido bit NULL,
		@DificultadesEncontradas varchar(MAX) NULL,
		@AccionesParaSuperarDificultades varchar(MAX) NULL,
		@Soporte varchar(MAX) NULL,
		@PresupuestoEjecutado int NULL,
		@Observaciones varchar(MAX) NULL,
		@Semestre int 	
AS 	
	
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
		
	IF(select top 1 1 from  PAT.SeguimientoEntidadNacional where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional) >=1
	BEGIN
		update [PAT].SeguimientoEntidadNacional 
					set NombreEntidadNacional=@NombreEntidadNacional ,
						CantidadEjecutada=@CantidadEjecutada ,
						CompromisoCumplido=@CompromisoCumplido,
						DificultadesEncontradas=@DificultadesEncontradas ,
						AccionesParaSuperarDificultades=@AccionesParaSuperarDificultades ,
						Soporte=@Soporte,
						PresupuestoEjecutado=@PresupuestoEjecutado,
						Observaciones=@Observaciones,
						Semestre=@Semestre,
						FechaUltimaModificacion = GETDATE()
		where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional
		SELECT @respuesta = 'Se ha modificado el registro'
		SELECT @estadoRespuesta = 1			
	END
	else	
	BEGIN
			INSERT INTO [PAT].SeguimientoEntidadNacional
					   (IdTablero ,
						Vigencia ,
						IdPregunta  ,
						DaneDepartamento  ,
						DaneMunicipio  ,
						IdEntidadNacional  ,
						NombreEntidadNacional ,
						CantidadEjecutada ,
						CompromisoCumplido,
						DificultadesEncontradas ,
						AccionesParaSuperarDificultades ,
						Soporte,
						PresupuestoEjecutado,
						Observaciones,
						Semestre ,
						FechaUltimaModificacion	)
				 VALUES
					   (@IdTablero ,
						@Vigencia ,
						@IdPregunta  ,
						@DaneDepartamento  ,
						@DaneMunicipio  ,
						@IdEntidadNacional  ,
						@NombreEntidadNacional ,
						@CantidadEjecutada ,
						@CompromisoCumplido,
						@DificultadesEncontradas ,
						@AccionesParaSuperarDificultades ,
						@Soporte,
						@PresupuestoEjecutado,
						@Observaciones,
						@Semestre, 
					   GETDATE())

		SELECT @respuesta = 'Se ha ingresado el registro'
		SELECT @estadoRespuesta = 1			
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

go