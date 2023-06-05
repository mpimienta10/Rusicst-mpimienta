-----------------------UNIQUE para seguimiento municipios -----------------------
BEGIN TRANSACTION
ALTER TABLE PAT.SeguimientoProgramas
	DROP CONSTRAINT FK_TB_SEGUIMIENTO_PROGRAMAS_TB_SEGUIMIENTO
ALTER TABLE PAT.Seguimiento ADD CONSTRAINT
	IX_Seguimiento UNIQUE NONCLUSTERED 
	(
	IdTablero,
	IdPregunta,
	IdUsuario
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE PAT.Seguimiento SET (LOCK_ESCALATION = TABLE)
COMMIT

go

BEGIN TRANSACTION
	ALTER TABLE PAT.SeguimientoProgramas ADD CONSTRAINT
	FK_TB_SEGUIMIENTO_PROGRAMAS_TB_SEGUIMIENTO FOREIGN KEY
	(
	IdSeguimiento
	) REFERENCES PAT.Seguimiento
	(
	IdSeguimiento
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
	ALTER TABLE PAT.SeguimientoProgramas SET (LOCK_ESCALATION = TABLE)
COMMIT

go
-----------------------UNIQUE para seguimiento departamentos  -----------------------
CREATE UNIQUE NONCLUSTERED INDEX IX_SeguimientoGobernacion_varias_llaves ON PAT.SeguimientoGobernacion
	(
	IdPregunta,
	IdTablero,
	IdUsuario,
	IdUsuarioAlcaldia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
ALTER TABLE PAT.SeguimientoGobernacion SET (LOCK_ESCALATION = TABLE)
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_SeguimientoMunicipalInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_SeguimientoMunicipalInsert] AS'
GO
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

	---validar que no se duplique un registro
	declare @idActual int
	select @idActual =IdSeguimiento from PAT.Seguimiento WHERE IdPregunta = @IdPregunta and IdTablero = @IdTablero and IdUsuario = [IdUsuario]
	if  (@idActual >0)
	begin	
		UPDATE [PAT].[Seguimiento]
		   SET [CantidadPrimer] = @CantidadPrimer
			  ,[PresupuestoPrimer] = @PresupuestoPrimer
			  ,[CantidadSegundo] = @CantidadSegundo
			  ,[PresupuestoSegundo] = @PresupuestoSegundo
			  ,[Observaciones] = @Observaciones
			  ,[NombreAdjunto] =@NombreAdjunto
			  ,[ObservacionesSegundo] = @ObservacionesSegundo
			  ,[NombreAdjuntoSegundo] = @NombreAdjuntoSegundo
			  ,[FechaSeguimientoSegundo] = @FechaSeguimientoSegundo
			  ,[FechaUltimaModificacion] = @FechaSeguimientoSegundo
			  ,[FechaUltimaModificacionSegundo] = getdate()
		 WHERE IdSeguimiento =@idActual
		 select @id = @idActual
		 SELECT @respuesta = 'Se ha actualizado el registro'
		 SELECT @estadoRespuesta = 1
	end
	else
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

	GO

	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_SeguimientoGobernacionInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_SeguimientoGobernacionInsert] AS'
GO
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
	
	---validar que no se duplique un registro
	declare @idActual int
	select @idActual =IdSeguimiento from PAT.[SeguimientoGobernacion] WHERE IdPregunta = @IdPregunta and IdTablero = @IdTablero and IdUsuario = [IdUsuario] and IdUsuarioAlcaldia = @IdUsuarioAlcaldia order by IdSeguimiento
	if  (@idActual >0)
	begin	
		UPDATE [PAT].[SeguimientoGobernacion]
		   SET [CantidadPrimer] = @CantidadPrimer
			  ,[PresupuestoPrimer] = @PresupuestoPrimer
			  ,[CantidadSegundo] = @CantidadSegundo
			  ,[PresupuestoSegundo] = @PresupuestoSegundo
			  ,[Observaciones] = @Observaciones
			  ,[NombreAdjunto] =@NombreAdjunto
			  ,[ObservacionesSegundo] = @ObservacionesSegundo
			  ,[NombreAdjuntoSegundo] = @NombreAdjuntoSegundo
			  ,[FechaSeguimientoSegundo] = @FechaSeguimientoSegundo
			  ,[FechaUltimaModificacion] = @FechaSeguimientoSegundo
			  ,[FechaUltimaModificacionSegundo] = getdate()
		 WHERE IdSeguimiento =@idActual

		 select @id = @idActual
		 SELECT @respuesta = 'Se ha actualizado el registro'
		 SELECT @estadoRespuesta = 1			
	end
	else
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


GO

