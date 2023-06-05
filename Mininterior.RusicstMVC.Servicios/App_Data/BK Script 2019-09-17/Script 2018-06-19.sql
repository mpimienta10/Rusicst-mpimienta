IF  NOT EXISTS (select 1 from sys.columns where Name = N'IsHGL' and Object_ID = Object_ID(N'dbo.PrecargueRespuestaEncuesta'))
begin
	alter table [dbo].[PrecargueRespuestaEncuesta] ADD 
  IsHGL BIT NOT NULL DEFAULT(0)
  ,UserHGL VARCHAR(100) NOT NULL DEFAULT('')
end

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_PrecargueRespuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_PrecargueRespuestaInsert] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez																		  
/Modifica: Equipo OIM	- Andrés Bonilla
/Fecha creacion:     2018-05-08																			  
/Fecha modificacion:     2018-06-19
/Descripcion: Inserta la información del precargue de respuestas de preguntas de encuestas					  
/Modificacion: Se incluyen parámetros y lógica para insertar y/o actualizar precargue enviado desde HGL
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [dbo].[I_PrecargueRespuestaInsert] 
		@IdUsuarioGuardo int = null,
		@IdEncuesta int,
		@CodigoHomologacion VARCHAR(10),
		@Divipola	int,
		@valor varchar(1000),
		@isHGL bit,
		@userHGL varchar(100)
		
	AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	

	declare @idUsuario int,@IdPregunta int, @idMunicipio int, @idDepartamento int
	
	select @idMunicipio = Id, @idDepartamento = IdDepartamento from Municipio where Id = @Divipola
	if  (@idMunicipio >0)
	begin
		--si es municipio debe buscar el usuario que tenga asignado ese municipuio y sea alcaldia		
		select @idUsuario = Id from Usuario where IdMunicipio =  @idMunicipio  and IdDepartamento =@idDepartamento and Activo = 1 and IdEstado = 5 and IdTipoUsuario = 2		
	end
	else	
	begin
		--si NO es municipio debe buscar el departamento  y el usuario que tenga asignado ese departamento y sea gobernacion
		select @idDepartamento = Id from Departamento where Id = @Divipola		
		select @idUsuario = Id from Usuario where IdDepartamento =@idDepartamento and Activo = 1 and IdEstado = 5 and IdTipoUsuario = 7
	end
	
	select top 1  @IdPregunta = c.Id
	FROM  BancoPreguntas.PreguntaModeloAnterior b 
	join BancoPreguntas.Preguntas a on b.IdPregunta = a.IdPregunta
	JOIN Pregunta c WITH (NOLOCK) ON b.IdPreguntaAnterior = c.Id
	JOIN (select Id, IdEncuesta from dbo.Seccion) AS s on c.IdSeccion = s.Id
	where  a.CodigoPregunta = @CodigoHomologacion and s.IdEncuesta = @IdEncuesta

	--Si viene de HGL el @IdUsuarioGuardo es NULO siempre, se setea con el idusuario de la alcaldia o gobernacion (depende de la encuesta)
	if @IdUsuarioGuardo IS NULL
	BEGIN
		SET @IdUsuarioGuardo = @idUsuario
	END

	if exists(select top 1 1 from dbo.PrecargueRespuestaEncuesta where IdEncuesta =@IdEncuesta and IdPregunta = @IdPregunta and IdUsuario = @idUsuario and isHGL = 0)
	begin
		set @esValido = 0
		set @respuesta += 'La respuesta ya se encuentra precargada.\n'
	end

	if exists(select top 1 1 from dbo.PrecargueRespuestaEncuesta where IdEncuesta =@IdEncuesta and IdPregunta = @IdPregunta and IdUsuario = @idUsuario and isHGL = 1)
	begin
		set @esValido = 0
		
		UPDATE [dbo].[PrecargueRespuestaEncuesta]
		SET Valor = @valor
		WHERE IdEncuesta =@IdEncuesta and IdPregunta = @IdPregunta and IdUsuario = @idUsuario and isHGL = 1
			
		SELECT @respuesta = 'Se ha actualizado el registro'
		SELECT @estadoRespuesta = 2

	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
			INSERT INTO [dbo].[PrecargueRespuestaEncuesta]
					   ([IdEncuesta]
					   ,[IdPregunta]
					   ,[IdUsuario]
					   ,[Valor]
					   ,[FechaIngreso]
					   ,[IdUsuarioIngreso]
					   ,IsHGL
					   ,UserHGL)
				 VALUES (@IdEncuesta,@IdPregunta,@idUsuario,@valor,GETDATE(),@IdUsuarioGuardo, @isHGL, @userHGL)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado



GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_PrecargueRespuestasDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_PrecargueRespuestasDelete] AS'
GO

/*****************************************************************************************************
/Autor: Equipo OIM	 - Vilma Rodriguez		
/Modifica: Equipo OIM	- Andrés Bonilla																  
/Fecha creacion:     2018-05-08				
/Fecha modificacion:     2018-06-19															  
/Descripcion: Borra tadas las respuestas precargadas de esta encuesta
/Modificacion: Solo se deben borrar precargues de encuestas que no fueron enviadas desde HGL isHGL = 0
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [dbo].[D_PrecargueRespuestasDelete] 
		@IdEncuesta int
AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
	BEGIN TRY		
		if exists(select top 1 1  from  dbo.PrecargueRespuestaEncuesta where IdEncuesta =@IdEncuesta and isHGL = 0)
		begin
			delete dbo.PrecargueRespuestaEncuesta where IdEncuesta =@IdEncuesta and isHGL = 0
			SELECT @respuesta = 'Se ha eliminado el registro'
			SELECT @estadoRespuesta = 3	
		end
		else	
		begin
			SELECT @respuesta = 'No se encontro ningun registro para eliminar'
			SELECT @estadoRespuesta = 0	
		end				
	END TRY
	BEGIN CATCH
		SELECT @respuesta = ERROR_MESSAGE()
		SELECT @estadoRespuesta = 0
	END CATCH	

select @respuesta as respuesta, @estadoRespuesta as estado

GO