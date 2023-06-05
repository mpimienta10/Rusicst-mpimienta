if( (select count (1) from [PAT].[FuentePresupuesto]) = 0)
begin 
	INSERT INTO [PAT].[FuentePresupuesto] ([Id] ,[Descripcion],[Activo])VALUES(1,'Recursos Propios',1)
	INSERT INTO [PAT].[FuentePresupuesto] ([Id] ,[Descripcion],[Activo])VALUES(2,'Sistema General de Participaciones (SGP)',1)
	INSERT INTO [PAT].[FuentePresupuesto] ([Id] ,[Descripcion],[Activo])VALUES(3,'Regalías',1)
	INSERT INTO [PAT].[FuentePresupuesto] ([Id] ,[Descripcion],[Activo])VALUES(4,'Crédito',1)
	INSERT INTO [PAT].[FuentePresupuesto] ([Id] ,[Descripcion],[Activo])VALUES(5,'Cofinanciación',1)
	INSERT INTO [PAT].[FuentePresupuesto] ([Id] ,[Descripcion],[Activo])VALUES(6,'Otros (Donaciones, Cooperación Internacional)',1)
end

go

if not exists (select * from sys.columns where name='IdTablero'  and Object_id in (select object_id from sys.tables where name ='PrecargueSIGO'))
begin 	
	ALTER TABLE [PAT].[PrecargueSIGO] ADD IdTablero  tinyint
	ALTER TABLE [PAT].[PrecargueSIGO] ADD TipoDocumento  varchar(100)
	ALTER TABLE [PAT].[PrecargueSIGO] ADD NumeroDocumento varchar(100)
	ALTER TABLE [PAT].[PrecargueSIGO] ADD NombreVictima varchar(255)
end
go

update  [PAT].[PrecargueSIGO] set IdTablero = 2

go
-----------------------------------------------------------------------------------------
---------ESTO ES PARA CORRER DESPUES DE IMPORTAR LA TABLA QUE NOS DE LA UNIDAD-----------
-----------------------------------------------------------------------------------------
--INSERT INTO [PAT].[PrecargueSIGO]([FechaNacimiento],[FechaIngreso],[IdentificadorMedida],[NombreMedida],[IdentificadorNecesidad]
--,[NombreNecesidad],[CodigoDane],[Municipio],[IdTablero],[TipoDocumento],[NumeroDocumento],[NombreVictima])
--select  [FECHA_NACIMIENTO],[FECHA_INGRESO], [IDENTIFICADOR_MEDIDA],[NOMBRE_MEDIDA], [IDENTIFICADOR_NECESIDAD], [NOMBRE_NECESIDAD],
--[CODIGO_DANE], [MUNICIPIO], 3, [TIPO_DOCUMETO], [NUMERO_DOCUMENTO], [NOMBRE_VICTIMA]
--from [dbo].['PRECARGUE DILIGENCIAMIENTO$']

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_UnoaUnoPrecargueSIGO]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_UnoaUnoPrecargueSIGO] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		20/11/2017
-- Modified date:	24/11/2017
-- Description:		Retorna las fuentes de financiacion para el diligenciamiento municipal de un municipio
-- ==========================================================================================
alter PROCEDURE [PAT].[C_UnoaUnoPrecargueSIGO]
( @IdPregunta as INT, @IdUsuario int)
AS
BEGIN
	SET NOCOUNT ON;		
	declare @IdTablero int
	set @IdTablero = 3
	select top 1000 [TipoDocumento],[NumeroDocumento],[NombreVictima] from [PAT].[PrecargueSIGO]
	where IdTablero = @IdTablero

END
go

/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Fecha modificacion :2017-11-20																		  
/Descripcion: Actualiza la información del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_RespuestaUpdate] 
		@ID int,
		@IDPREGUNTA smallint,
		@NECESIDADIDENTIFICADA int,
		@RESPUESTAINDICATIVA int,
		@RESPUESTACOMPROMISO int,
		@PRESUPUESTO money,
		@OBSERVACIONNECESIDAD nvarchar(1000),
		@ACCIONCOMPROMISO nvarchar(1000),
		@IDUSUARIO int,		
		@NOMBREADJUNTO nvarchar(200),
		@OBSERVACIONPRESUPUESTO nvarchar(1000)			
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	declare @IDMUNICIPIO int
	
	SELECT @IDMUNICIPIO = [PAT].[fn_GetIdEntidad](@IDUSUARIO)

	--declare @idRespuesta int
	--select @idRespuesta = r.ID from [PAT].[RespuestaPAT] as r
	--where r.[IdPreguntaPAT] = @IDPREGUNTA and r.IdMunicipio = @IDMUNICIPIO
	--order by r.ID
	--if (@idRespuesta is null)
	--begin
	--	set @esValido = 0
	--	set @respuesta += 'No se encontro la respuesta.\n'
	--end

	if(@esValido = 1) 
	begin
		BEGIN TRY

		UPDATE [PAT].[RespuestaPAT]
		   SET [IdPreguntaPAT] = @IDPREGUNTA
			  ,[NECESIDADIDENTIFICADA] = @NECESIDADIDENTIFICADA
			  ,[RESPUESTAINDICATIVA] = @RESPUESTAINDICATIVA
			  ,[RESPUESTACOMPROMISO] = @RESPUESTACOMPROMISO
			  ,[PRESUPUESTO] = @PRESUPUESTO
			  ,[OBSERVACIONNECESIDAD] = @OBSERVACIONNECESIDAD
			  ,[ACCIONCOMPROMISO] = @ACCIONCOMPROMISO
			  ,[FechaModificacion] = GETDATE()
			  ,NombreAdjunto= @NOMBREADJUNTO
			  ,ObservacionPresupuesto=@OBSERVACIONPRESUPUESTO
		 WHERE  ID = @ID 

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
/Autor: Equipo OIM	- vilma rodriguez																		  
/Fecha creacion:     2017-03-29	
/Fecha modificacion :2017-11-14																		  
/Descripcion: Inserta la información del tablero municipal y del tablero departamental cuando se ingresa
/la respuesta por el tab de "Consolidado municipal". Cuando es de la gestion municipal se guardan todos los datos
/Cuando es desde el tab de consolidado de la gestion departamental se guarda el registro sin los datos del resultado y sin municipio
/Se guarda el registro para poder tener el id y guardar las acciones y programas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_RespuestaInsert] 
		@IDUSUARIO int,
		@IDPREGUNTA smallint,
		@NECESIDADIDENTIFICADA int,
		@RESPUESTAINDICATIVA int,
		@RESPUESTACOMPROMISO int,
		@PRESUPUESTO money,
		@OBSERVACIONNECESIDAD nvarchar(1000),
		@ACCIONCOMPROMISO nvarchar(1000),		
		@NOMBREADJUNTO nvarchar(200)	,
		@OBSERVACIONPRESUPUESTO	 nvarchar(1000)
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	

	declare @id int, @IdDepartamento int,@IdMunicipio int, @IdTipoUsuario int
	--select  @IdDepartamento = IdDepartamento, @IdMunicipio = case when IdTipoUsuario = 7 then null else  IdMunicipio end from Usuario where Id = @IDUSUARIO
	select  @IdDepartamento = IdDepartamento, @IdMunicipio =IdMunicipio,  @IdTipoUsuario = IdTipoUsuario from Usuario where Id = @IDUSUARIO
	if (@IdTipoUsuario = 7)
		set @IdMunicipio = null

	select @id = r.ID from [PAT].[RespuestaPAT] as r
	where r.IdPreguntaPAT = @IDPREGUNTA AND  r.IdMunicipio = @IdMunicipio
	order by r.ID
	if (@id is not null)
	begin
		set @esValido = 0
		set @respuesta += 'La respuesta ya se encuentra ingresada.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
	
		
		INSERT INTO [PAT].[RespuestaPAT]
		([IdPreguntaPAT]
		,[NECESIDADIDENTIFICADA]
		,[RESPUESTAINDICATIVA]
		,[RESPUESTACOMPROMISO]
		,[PRESUPUESTO]
		,[OBSERVACIONNECESIDAD]
		,[ACCIONCOMPROMISO]
		,[IDUSUARIO]
		,[FECHAINSERCION]
		,[IdMunicipio]
		,[IdDepartamento]
		,NombreAdjunto,
		ObservacionPresupuesto)
		VALUES
		(@IDPREGUNTA,
		 @NECESIDADIDENTIFICADA, 
		 @RESPUESTAINDICATIVA, 
		 @RESPUESTACOMPROMISO,
		 @PRESUPUESTO, 
		 @OBSERVACIONNECESIDAD,
		 @ACCIONCOMPROMISO,
		 @IDUSUARIO,
		 GETDATE(),
		 @IdMunicipio,
		 @IdDepartamento,
		 @NOMBREADJUNTO,
		 @OBSERVACIONPRESUPUESTO)    			
		
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