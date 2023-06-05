
ALTER TABLE [PAT].[RespuestaPAT] ALTER COLUMN [FechaInsercion] datetime null
ALTER TABLE [PAT].[RespuestaPAT] ALTER COLUMN [FechaModificacion] datetime null

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_NumeroNecesidadesSIGO]') AND type in (N'FN')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_NumeroNecesidadesSIGO] AS'
go
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		01/03/2018
-- Modified date:	01/03/2018
-- Description:		Obtiene las necesidades identificadas del municipio acorde con la pregunta del PAT
-- =============================================
alter function [PAT].[C_NumeroNecesidadesSIGO] 
	(@IdMunicipio INT,
	@PREGUNTA SMALLINT)
RETURNS INT
AS
BEGIN
	
	DECLARE @Cant INT
    DECLARE @Cantidad INT
    DECLARE @CantidadDef NVARCHAR(100)

	DECLARE  @SQL NVARCHAR(MAX)
	-----------------------------------------------------------
	---------------------------nuevo---------------------------
	-----------------------------------------------------------

	Declare @IdPregunta int, @idTablero int,@IdentificadorMedida int,@IdentificadorNecesidad int
	set @IdPregunta = @PREGUNTA
	select @idTablero =IdTablero from pat.PreguntaPAT where Id = @IdPregunta

		if (@IdPregunta = 180)--Víctimas del conflicto armado a quienes no se les ha expedido el documento de identidad acorde a su edad. 5-1
		begin
			set @IdentificadorMedida  = 5
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 181)--Víctimas del conflicto armado que no se encuentran afiliadas al Sistema General de Seguridad Social en Salud.. 1-1
		begin
			set @IdentificadorMedida  = 1
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 182)--Víctimas del conflicto armado que no se encuentran afiliadas al Sistema General de Seguridad Social en Salud. 3-1
		begin
			set @IdentificadorMedida  = 3
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 185)--Víctimas del conflicto armado que requieren alfabetización.3-2
		begin
			set @IdentificadorMedida  = 3
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 186)--Hogares que requieren acceso a vivienda en la zona urbana. 10-1
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 187)--Hogares que requieren mejoramiento de vivienda en la zona urbana. --10-2
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 188)--Hogares que requieren acceso a vivienda en la zona rural.--10-1
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 189)--Hogares que requieren mejoramiento de vivienda en la zona rural.10-2
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 190)--Víctimas del conflicto armado que requieren fortalecimiento de negocios. 4- 4
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 4
		end		
		if (@IdPregunta = 191)--Víctimas del conflicto armado que requieren apoyo a nuevos emprendimientos.--4-5
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 5
		end		
		if (@IdPregunta = 192)--Víctimas del conflicto armado que requieren empleabilidad.--4-3
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 3
		end
		if (@IdPregunta = 193)--Víctimas del conflicto armado que requieren capacitación u orientación para el trabajo (excluye educación superior).--4-2
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 199)--Víctimas del conflicto armado que han solicitado atención o acompañamiento psicosocial y no lo han recibido.--1-7
		begin
			set @IdentificadorMedida  = 1
			set @IdentificadorNecesidad = 7
		end
		if (@IdPregunta = 200)--Hombres entre 18 y 49 años, víctimas del conflicto armado, que no tienen definida su situación militar. --5-2
		begin
			set @IdentificadorMedida  = 5
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 201)--Víctimas del conflicto armado que requieren apoyo en Asistencia Funeraria.--11-1
		begin
			set @IdentificadorMedida  = 11
			set @IdentificadorNecesidad = 1		
		end
		
		select @Cantidad = COUNT(1) from pat.PrecargueSIGO 
		where CodigoDane = @IdMunicipio and IdTablero = @idTablero and IdentificadorMedida = @IdentificadorMedida and IdentificadorNecesidad = @IdentificadorNecesidad	 


	return @Cantidad
END 

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PAT.SeguimientoReparacionColectivaEntidadNacional')) 
begin
CREATE  TABLE PAT.SeguimientoReparacionColectivaEntidadNacional
	(
	IdTablero int ,
	Vigencia int ,
	IdPregunta int ,
	DaneDepartamento int ,
	DaneMunicipio int ,
	IdEntidadNacional int ,
	NombreEntidadNacional varchar(500) NULL,	
	AvanceAccionEntidadNacional varchar(MAX) NULL,
	CompromisoCumplido bit NULL,
	DificultadesEncontradas varchar(MAX) NULL,
	AccionesParaSuperarDificultades varchar(MAX) NULL,
	Soporte varchar(MAX) NULL,
	PresupuestoEjecutado int ,
	Observaciones varchar(MAX) NULL,
	Semestre int ,
	FechaUltimaModificacion datetime
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
end
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PAT.SeguimientoRetornosReubicacionesEntidadNacional')) 
begin
CREATE  TABLE PAT.SeguimientoRetornosReubicacionesEntidadNacional
	(
	IdTablero int ,
	Vigencia int ,
	IdPregunta int ,
	DaneDepartamento int ,
	DaneMunicipio int ,
	IdEntidadNacional int ,
	NombreEntidadNacional varchar(500) NULL,	
	AvanceAccionEntidadNacional varchar(MAX) NULL,
	CompromisoCumplido bit NULL,
	DificultadesEncontradas varchar(MAX) NULL,
	AccionesParaSuperarDificultades varchar(MAX) NULL,
	Soporte varchar(MAX) NULL,
	PresupuestoEjecutado int ,
	Observaciones varchar(MAX) NULL,
	Semestre int ,
	FechaUltimaModificacion datetime
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
end
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_SeguimientoRCEntidadNacionalInsertUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_SeguimientoRCEntidadNacionalInsertUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-02-26																			  
/Descripcion: Inserta  o actualiza la informacion de las entidades nacionales que provienen del WS de la Unidad De Victimas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_SeguimientoRCEntidadNacionalInsertUpdate] 
		@IdTablero int ,
		@Vigencia int ,
		@IdPregunta int ,
		@DaneDepartamento int ,
		@DaneMunicipio int ,
		@IdEntidadNacional int ,
		@NombreEntidadNacional varchar(500) NULL,
		@AvanceAccionEntidadNacional varchar(MAX) NULL,
		@CompromisoCumplido bit NULL,
		@DificultadesEncontradas varchar(MAX) NULL,
		@AccionesParaSuperarDificultades varchar(MAX) NULL,
		@Soporte varchar(MAX) NULL,
		@PresupuestoEjecutado int ,
		@Observaciones varchar(max) null,
		@Semestre int 	
AS 	
	
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
		
	IF(select top 1 1 from  PAT.SeguimientoReparacionColectivaEntidadNacional where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional) >=1
	BEGIN
		update [PAT].SeguimientoReparacionColectivaEntidadNacional 
					set NombreEntidadNacional=@NombreEntidadNacional ,
						@AvanceAccionEntidadNacional =@AvanceAccionEntidadNacional,
						@CompromisoCumplido =@CompromisoCumplido,
						@DificultadesEncontradas =@DificultadesEncontradas,
						@AccionesParaSuperarDificultades =@AccionesParaSuperarDificultades,
						@Soporte =@Soporte,
						@PresupuestoEjecutado =@PresupuestoEjecutado ,
						@Observaciones=@Observaciones,
						Semestre=@Semestre,
						FechaUltimaModificacion = GETDATE()
		where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional
		SELECT @respuesta = 'Se ha modificado el registro'
		SELECT @estadoRespuesta = 1			
	END
	else	
	BEGIN
			INSERT INTO [PAT].SeguimientoReparacionColectivaEntidadNacional
					   (IdTablero ,
						Vigencia ,
						IdPregunta  ,
						DaneDepartamento  ,
						DaneMunicipio  ,
						IdEntidadNacional  ,
						NombreEntidadNacional ,
						AvanceAccionEntidadNacional ,
						CompromisoCumplido,
						DificultadesEncontradas,
						AccionesParaSuperarDificultades ,
						Soporte ,
						PresupuestoEjecutado ,
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
						@AvanceAccionEntidadNacional ,
						@CompromisoCumplido,
						@DificultadesEncontradas,
						@AccionesParaSuperarDificultades ,
						@Soporte ,
						@PresupuestoEjecutado,
						@Semestre, 
					   GETDATE())

		SELECT @respuesta = 'Se ha ingresado el registro'
		SELECT @estadoRespuesta = 1			
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_SeguimientoRREntidadNacionalInsertUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_SeguimientoRREntidadNacionalInsertUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-02-26																			  
/Descripcion: Inserta  o actualiza la informacion de las entidades nacionales que provienen del WS de la Unidad De Victimas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_SeguimientoRREntidadNacionalInsertUpdate] 
		@IdTablero int ,
		@Vigencia int ,
		@IdPregunta int ,
		@DaneDepartamento int ,
		@DaneMunicipio int ,
		@IdEntidadNacional int ,
		@NombreEntidadNacional varchar(500) NULL,
		@AvanceAccionEntidadNacional varchar(MAX) NULL,
		@CompromisoCumplido bit NULL,
		@DificultadesEncontradas varchar(MAX) NULL,
		@AccionesParaSuperarDificultades varchar(MAX) NULL,
		@Soporte varchar(MAX) NULL,
		@PresupuestoEjecutado int ,
		@Observaciones varchar(max) null,
		@Semestre int 	
AS 	
	
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
		
	IF(select top 1 1 from  PAT.SeguimientoRetornosReubicacionesEntidadNacional where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional) >=1
	BEGIN
		update [PAT].SeguimientoRetornosReubicacionesEntidadNacional 
					set NombreEntidadNacional=@NombreEntidadNacional ,
						@AvanceAccionEntidadNacional =@AvanceAccionEntidadNacional,
						@CompromisoCumplido =@CompromisoCumplido,
						@DificultadesEncontradas =@DificultadesEncontradas,
						@AccionesParaSuperarDificultades =@AccionesParaSuperarDificultades,
						@Soporte =@Soporte,
						@PresupuestoEjecutado =@PresupuestoEjecutado ,
						@Observaciones=@Observaciones,
						Semestre=@Semestre,
						FechaUltimaModificacion = GETDATE()
		where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional
		SELECT @respuesta = 'Se ha modificado el registro'
		SELECT @estadoRespuesta = 1			
	END
	else	
	BEGIN
			INSERT INTO [PAT].SeguimientoRetornosReubicacionesEntidadNacional
					   (IdTablero ,
						Vigencia ,
						IdPregunta  ,
						DaneDepartamento  ,
						DaneMunicipio  ,
						IdEntidadNacional  ,
						NombreEntidadNacional ,
						AvanceAccionEntidadNacional ,
						CompromisoCumplido,
						DificultadesEncontradas,
						AccionesParaSuperarDificultades ,
						Soporte ,
						PresupuestoEjecutado ,
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
						@AvanceAccionEntidadNacional ,
						@CompromisoCumplido,
						@DificultadesEncontradas,
						@AccionesParaSuperarDificultades ,
						@Soporte ,
						@PresupuestoEjecutado,
						@Semestre, 
					   GETDATE())

		SELECT @respuesta = 'Se ha ingresado el registro'
		SELECT @estadoRespuesta = 1			
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

go





IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_CompromisoEntidadNacionalRCInsertUpdate]') AND type in (N'FN')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_CompromisoEntidadNacionalRCInsertUpdate] AS'
go

/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-02-26																			  
/Descripcion: Inserta  o actualiza la informacion de las entidades nacionales que provienen del WS de la Unidad De Victimas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_CompromisoEntidadNacionalRCInsertUpdate] 
		@IdTablero int,
		@Vigencia int,
		@IdPregunta int,
		@DaneDepartamento int,
		@DaneMunicipio int,
		@IdEntidadNacional int ,
		@NombreEntidadNacional varchar(500) NULL,		
		@AccionEntidadNacional varchar(MAX) NULL,
		@PresupuestoNivelNacional int NULL
		
AS 	
	
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
		
	IF(select top 1 1 from  PAT.CompromisosEntidadNacionalReparacionColectiva where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional) >=1
	BEGIN
		update [PAT].CompromisosEntidadNacionalReparacionColectiva 
						set AccionEntidadNacional =@AccionEntidadNacional, 					   
					    PresupuestoNivelNacional=@PresupuestoNivelNacional, 					   
						[FechaUltimaModificacion] = GETDATE()
		where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional
		SELECT @respuesta = 'Se ha modificado el registro'
		SELECT @estadoRespuesta = 1			
	END
	else	
	BEGIN
			INSERT INTO [PAT].CompromisosEntidadNacionalReparacionColectiva
					   ([IdTablero]
					   ,[Vigencia]
					   ,[IdPregunta]
					   ,[DaneDepartamento]
					   ,[DaneMunicipio]
					   ,[IdEntidadNacional]
					   ,[NombreEntidadNacional]
					   ,AccionEntidadNacional					  
					   ,[PresupuestoNivelNacional]					   
					   ,[FechaUltimaModificacion])
				 VALUES
					   (@IdTablero,
					   @Vigencia, 
					   @IdPregunta,
					   @DaneDepartamento,
					   @DaneMunicipio, 
					   @IdEntidadNacional, 
					   @NombreEntidadNacional, 
					   @AccionEntidadNacional, 
					   @PresupuestoNivelNacional, 
					   GETDATE())

		SELECT @respuesta = 'Se ha ingresado el registro'
		SELECT @estadoRespuesta = 1			
	END
	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado	
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_CompromisoEntidadNacionalRRInsertUpdate]') AND type in (N'FN')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_CompromisoEntidadNacionalRRInsertUpdate] AS'
go

/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-02-26																			  
/Descripcion: Inserta  o actualiza la informacion de las entidades nacionales que provienen del WS de la Unidad De Victimas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_CompromisoEntidadNacionalRRInsertUpdate] 
		@IdTablero int,
		@Vigencia int,
		@IdPregunta int,
		@DaneDepartamento int,
		@DaneMunicipio int,
		@IdEntidadNacional int ,
		@NombreEntidadNacional varchar(500) NULL,		
		@AccionEntidadNacional varchar(MAX) NULL,
		@PresupuestoNivelNacional int NULL
		
AS 	
	
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
		
	IF(select top 1 1 from  PAT.CompromisosEntidadNacionalRetornosReubicaciones where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional) >=1
	BEGIN
		update [PAT].CompromisosEntidadNacionalRetornosReubicaciones 
						set AccionEntidadNacional =@AccionEntidadNacional, 					   
					    PresupuestoNivelNacional=@PresupuestoNivelNacional, 					   
						[FechaUltimaModificacion] = GETDATE()
		where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional
		SELECT @respuesta = 'Se ha modificado el registro'
		SELECT @estadoRespuesta = 1			
	END
	else	
	BEGIN
			INSERT INTO [PAT].CompromisosEntidadNacionalRetornosReubicaciones
					   ([IdTablero]
					   ,[Vigencia]
					   ,[IdPregunta]
					   ,[DaneDepartamento]
					   ,[DaneMunicipio]
					   ,[IdEntidadNacional]
					   ,[NombreEntidadNacional]
					   ,AccionEntidadNacional					  
					   ,[PresupuestoNivelNacional]					   
					   ,[FechaUltimaModificacion])
				 VALUES
					   (@IdTablero,
					   @Vigencia, 
					   @IdPregunta,
					   @DaneDepartamento,
					   @DaneMunicipio, 
					   @IdEntidadNacional, 
					   @NombreEntidadNacional, 
					   @AccionEntidadNacional, 
					   @PresupuestoNivelNacional, 
					   GETDATE())

		SELECT @respuesta = 'Se ha ingresado el registro'
		SELECT @estadoRespuesta = 1			
	END
	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado	

