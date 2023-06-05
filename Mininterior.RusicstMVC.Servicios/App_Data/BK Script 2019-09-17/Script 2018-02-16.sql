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
			COUNT(R.Id) AS NUM_PREGUNTAS_CONTESTAR, 
			count(SM.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
			FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
			join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
			JOIN Municipio AS M ON PM.IdMunicipio = M.Id
			JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >0
			LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = P.ID AND SM.IdUsuario = R.IdUsuario and SM.CantidadSegundo >= 0 and SM.PresupuestoSegundo >=0	
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


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_IdEntidad]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_IdEntidad] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		16/02/2018
-- Modified date:	16/02/2018
-- Description:		Procedimiento que trae el identidad  en caso de ser un el seguimiento numero 1 del tablero 1
-- =============================================
ALTER PROCEDURE [PAT].[C_IdEntidad]	@IdUsuario int
AS
BEGIN
	SET NOCOUNT ON;

	declare @IdMunicipio int, @IdDepartamento int, @TipoUsuario varchar(100), @IdEntidad int
	set @IdEntidad = 0

	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento , @TipoUsuario = T.Tipo
	from Usuario as U 
	join TipoUsuario as T on U.IdTipoUsuario = T.Id
	where U.Id =@IdUsuario

	if (@TipoUsuario = 'ALCALDIA')
	begin
		select @IdEntidad = E.Id from [PAT].[Entidad] AS E
		JOIN Municipio as M on E.IdMunicipio = M.Id 
		where M.Id =   @IdMunicipio and E.Activo = 1
	end
	else	
	begin
		select @IdEntidad = E.Id from [PAT].[Entidad] AS E
		JOIN Departamento as D on E.IdDepartamento = D.Id 
		where D.Id =   @IdDepartamento and E.Activo = 1
	end
	select @IdEntidad as IdEntidad
END


GO

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_HistoricoXUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_HistoricoXUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================  
-- Autor: Equipo de desarrollo OIM - John Betancourt A. 
-- Fecha creacion: 2018-02-07
-- Descripcion: Obtiene el historico de usuarios con su nombre y datos                     
--====================================================================================================  
ALTER PROC [dbo].[C_HistoricoXUsuario]  
  @IdUsername varchar(50)
AS  
 BEGIN  

 Declare @IdHistorico INT
 select @IdHistorico  = id from Usuario where UserName = @IdUsername

  SELECT  
--======================================================================================  
-- ORDEN DE LA CONSULTA NECESARIA PARA QUE SE MUESTRE EN ESTE MISMO ORDEN EN LA REJILLA  
--=======================================================================================  
    [U].[UserName]  
   ,[U].[Nombres]  
   ,[U].[FechaSolicitud]  
   ,[U].[Cargo]  
   ,[U].[TelefonoFijo]  
   ,[T].[Nombre] TipoUsuario  
   ,[U].[TelefonoCelular]  
   ,[U].[Email]  
   ,[M].[Nombre] Municipio  
   ,[D].[Nombre] Departamento    
--=======================================================================================  
   ,[U].[Id]  
   ,[E].[Nombre] Estado  
   ,[UTramite].[UserName] UsuarioTramite    
   ,[U].[TelefonoFijoIndicativo]  
   ,[U].[TelefonoFijoExtension]  
   ,[U].[EmailAlternativo]  
   ,[U].[Activo]  
   ,[U].[FechaNoRepudio]  
   ,[U].[FechaTramite]  
   ,[U].[FechaConfirmacion]   
   ,[U].IdUsuarioHistorico
  FROM   
   [dbo].[Usuario] U  
   LEFT JOIN [dbo].[TipoUsuario] T ON [U].[IdTipoUsuario] = [T].[Id]  
   LEFT JOIN [dbo].[Estado] E ON [U].[IdEstado] = [E].[Id]   
   LEFT JOIN [dbo].[Departamento] D ON [D].[Id] = [U].[IdDepartamento]  
   LEFT JOIN [dbo].[Municipio] M ON [M].[Id] = [U].[IdMunicipio]  
   LEFT JOIN [dbo].[Usuario] UTramite ON [UTramite].[Id] = [U].[IdUsuarioTramite]
   WHERE U.UserName = @IdUsername --AND U.IdUsuarioHistorico = U.Id
  --ORDER BY   
   --[U].[FechaConfirmacion] DESC  

   Union all

   SELECT  
--======================================================================================  
-- ORDEN DE LA CONSULTA NECESARIA PARA QUE SE MUESTRE EN ESTE MISMO ORDEN EN LA REJILLA  
--=======================================================================================  
    [U].[UserName]  
   ,[U].[Nombres]  
   ,[U].[FechaSolicitud]  
   ,[U].[Cargo]  
   ,[U].[TelefonoFijo]  
   ,[T].[Nombre] TipoUsuario  
   ,[U].[TelefonoCelular]  
   ,[U].[Email]  
   ,[M].[Nombre] Municipio  
   ,[D].[Nombre] Departamento    
--=======================================================================================  
   ,[U].[Id]  
   ,[E].[Nombre] Estado  
   ,[UTramite].[UserName] UsuarioTramite    
   ,[U].[TelefonoFijoIndicativo]  
   ,[U].[TelefonoFijoExtension]  
   ,[U].[EmailAlternativo]  
   ,[U].[Activo]  
   ,[U].[FechaNoRepudio]  
   ,[U].[FechaTramite]  
   ,[U].FechaRetiro   
   ,[U].IdUsuarioHistorico
  FROM   
   [dbo].[Usuario] U  
   LEFT JOIN [dbo].[TipoUsuario] T ON [U].[IdTipoUsuario] = [T].[Id]  
   LEFT JOIN [dbo].[Estado] E ON [U].[IdEstado] = [E].[Id]   
   LEFT JOIN [dbo].[Departamento] D ON [D].[Id] = [U].[IdDepartamento]  
   LEFT JOIN [dbo].[Municipio] M ON [M].[Id] = [U].[IdMunicipio]  
   LEFT JOIN [dbo].[Usuario] UTramite ON [UTramite].[Id] = [U].[IdUsuarioTramite]
   WHERE U.IdUsuarioHistorico = @IdHistorico
  ORDER BY   
   [Estado] ASC  


 END  
  
  