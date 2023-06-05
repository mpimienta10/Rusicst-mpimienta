
IF NOT EXISTS (SELECT * FROM [SubRecurso] WHERE Nombre = 'Histórico de Auditoría y Eventos')
	INSERT INTO [dbo].[SubRecurso] ([Nombre],[Url],[IdRecurso]) VALUES ('Histórico de Auditoría y Eventos', null, (SELECT Id FROM [Recurso] WHERE Nombre = 'Sistema'))

	GO


	
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_EnvioTableroPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_EnvioTableroPat] AS'
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
			LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >=0 and R.RespuestaIndicativa >0 and R.NecesidadIdentificada >0
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
			COUNT(P.Id) AS NUM_PREGUNTAS_CONTESTAR, 
			count(R.Id) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
			FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
			join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
			JOIN Municipio AS M ON PM.IdMunicipio = M.Id
			LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >=0
			LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = P.ID AND SM.IdUsuario = R.IdUsuario and SM.CantidadSegundo >= 0 	
			WHERE	P.NIVEL = 3 --municipios
			AND P.IdTablero = @idTablero
			and P.ACTIVO = 1	
			and M.Id = @IdMunicipio
		) AS T 
	end

	if (@guardoPreguntas = 0)
	begin
		set @esValido = 0
		set @respuesta += 'El Tablero PAT no se puede enviar, ya que aún tiene información diligenciar.'
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

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_EnvioTableroPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_EnvioTableroPat] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	14/02/2018
-- Description:		Obtiene los porcentajes de avance de la gestión del tablero PAT por municipio
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroMunicipioAvance] --[PAT].[C_TableroMunicipioAvance] 411,4
		@IdUsuario INT, @idTablero tinyint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		DERECHO NVARCHAR(50),
		PINDICATIVA INT,
		PCOMPROMISO INT
		)
	
	Declare @IdMunicipio int
	SELECT @IdMunicipio =  U.[IdMunicipio] FROM [dbo].[Usuario] (NOLOCK) U WHERE U.ID = @IdUsuario


	SELECT	D.DESCRIPCION AS DERECHO, 
			--SUM(case when R.RESPUESTAINDICATIVA IS NULL or R.RESPUESTAINDICATIVA=0 then 0 else 1 end)*100/count(*) PINDICATIVA,
			--SUM(case when R.RESPUESTACOMPROMISO IS NULL or R.RESPUESTACOMPROMISO=0 then 0 else 1 end)*100/count(*) PCOMPROMISO
			SUM(case when R.RESPUESTAINDICATIVA IS NULL then 0 else 1 end)*100/count(*) PINDICATIVA,
			(SUM(case when R.RESPUESTACOMPROMISO IS NULL then 0 else 1 end)+SUM(case when R.Presupuesto IS NULL then 0 else 1 end)) *100/(count(*)*2) PCOMPROMISO
			--SUM(case when R.RESPUESTACOMPROMISO IS NULL then 0 else 1 end)*100/count(*) PCOMPROMISO
	FROM    [PAT].[PreguntaPAT] (NOLOCK) AS P
	join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
	INNER JOIN [PAT].[Derecho] (NOLOCK) D ON P.IDDERECHO = D.ID 
	INNER JOIN PAT.Tablero (NOLOCK) AS T ON P.IDTABLERO = T.ID				
	LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON R.IdMunicipio = @IdMunicipio  and P.ID = R.[IdPreguntaPAT]
	WHERE	P.NIVEL = @NIVEL 
	AND T.ID = @idTablero
	and P.ACTIVO = 1	
	group by D.DESCRIPCION
END



GO