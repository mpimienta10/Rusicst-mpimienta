
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	12/01/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDepartamentoRetornosReubicaciones] --[PAT].[C_TableroSeguimientoDepartamentoRetornosReubicaciones]  2, 181
(	@IdTablero INT,@IdMunicipio INT)
AS
BEGIN

	
	SELECT distinct A.[Id]
		  ,[Hogares]
		  ,[Personas]
		  ,[Sector]
		  ,[Componente]
		  ,[Comunidad]
		  ,[Ubicacion]
		  ,[MedidaRetornoReubicacion]
		  ,[IndicadorRetornoReubicacion]
		  ,[EntidadResponsable]
		  ,A.[IdDepartamento]
		  ,[IdMunicipio]
		  ,M.Nombre AS Municipio
		  ,[IdTablero]
		FROM [PAT].PreguntaPATRetornosReubicaciones as A
		JOIN Municipio AS M ON A.IdMunicipio = M.Id
		WHERE A.IdMunicipio= @IdMunicipio 	AND IdTablero = @IdTablero and A.Activo = 1
END


go



/*****************************************************************************************************
/Autor: Equipo OIM - Vilma Rodriguez																			  
/Fecha creacion: 2017-10-01																			  
/Descripcion: Actualiza la información de las preguntas 
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_PreguntaRCPatUpdate] 
				       @Id int,
				       @IdMedida int,
					   @Sujeto nvarchar(300),
					   @MedidaReparacionColectiva nvarchar(2000),
					   @IdDepartamento int,
					   @IdMunicipio int,
					   @IdTablero tinyint,
					    @Activo bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	declare @idPregunta int

	select @idPregunta = r.ID from [PAT].PreguntaPATReparacionColectiva as r
	where r.Id = @Id 
	order by r.ID
	if (@idPregunta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.'
	end
	declare @IdTableroActual int
	declare @IdRespuesta int		
	select top 1 @IdRespuesta = Id from [PAT].RespuestaPATAccionReparacionColectiva where IdRespuestaPATReparacionColectiva =@Id  
			
	if (@IdRespuesta >0 )
	begin
		set @esValido = 0
		set @respuesta += 'Ya se se encuentran respuestas asociadas'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
			update [PAT].[PreguntaPATReparacionColectiva]
				   set [IdMedida]=@IdMedida
					   ,[Sujeto]=@Sujeto
					   ,[MedidaReparacionColectiva]=@MedidaReparacionColectiva
					   ,[IdDepartamento]=@IdDepartamento
					   ,[IdMunicipio]=@IdMunicipio	
					   ,Activo =@Activo				   				     	   							  
			WHERE  ID = @Id 

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

	/*****************************************************************************************************
/Autor: Equipo OIM - Vilma Rodriguez																			  
/Fecha creacion: 2017-10-01																			  
/Descripcion: Actualiza la información de las preguntas 
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_PreguntaRRPatUpdate] 
				   @Id int,
				   @Hogares int,
				   @Personas int,
				   @Sector nvarchar(max),
				   @Componente nvarchar(max),
				   @Comunidad nvarchar(max),
				   @Ubicacion nvarchar(max),
				   @MedidaRetornoReubicacion nvarchar(max),
				   @IndicadorRetornoReubicacion nvarchar(max),
				   @EntidadResponsable nvarchar(max),
				   @IdDepartamento int,
				   @IdMunicipio int,
				   @IdTablero tinyint,
				    @Activo bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	declare @idPregunta int

	select @idPregunta = r.ID from [PAT].PreguntaPATRetornosReubicaciones as r
	where r.Id = @Id 
	order by r.ID
	if (@idPregunta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.'
	end
	declare @IdTableroActual int
	declare @IdRespuesta int	
	select top 1 @IdRespuesta = Id from [PAT].RespuestaPATAccionRetornosReubicaciones where IdRespuestaPATRetornoReubicacion =@Id  
			
	if (@IdRespuesta >0 )
	begin
		set @esValido = 0
		set @respuesta += 'Ya se se encuentran respuestas asociadas.'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
			update [PAT].PreguntaPATRetornosReubicaciones
				   set [Hogares] =@Hogares
				   ,[Personas] =@Personas
				   ,[Sector]=@Sector
				   ,[Componente]=@Componente
				   ,[Comunidad]=@Comunidad
				   ,[Ubicacion]=@Ubicacion
				   ,[MedidaRetornoReubicacion]=@MedidaRetornoReubicacion
				   ,[IndicadorRetornoReubicacion]=@IndicadorRetornoReubicacion
				   ,[EntidadResponsable]=@EntidadResponsable
				   ,[IdDepartamento]=@IdDepartamento
				   ,[IdMunicipio]=	@IdMunicipio
				   ,Activo=@Activo			   							  
			WHERE  ID = @Id 

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

