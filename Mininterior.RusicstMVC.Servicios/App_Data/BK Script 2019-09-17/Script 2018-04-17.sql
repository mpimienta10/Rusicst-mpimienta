IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosConsolidadoMunicipiosGobernacionesWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosConsolidadoMunicipiosGobernacionesWebService] AS'
GO
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Modificado por   Grupo Desarrollo - Vilma Rodriguez el 12-04-2018
-- Description:		Retorna las preguntas de la gestion departamental
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosConsolidadoMunicipiosGobernacionesWebService] 
(
	@IdTablero int, 
	@DivipolaDepartamento int
) 
AS

BEGIN
			SELECT 
			DISTINCT IdPregunta
			,IdRespuesta
			,DivipolaMunicipio
			,RespuestaIndicativa
			,ObservacionNecesidad
			,RespuestaCompromiso
			,AccionCompromiso
			,CONVERT(FLOAT, PRESUPUESTO) AS Presupuesto
			,AccionesMunicipio
			,ProgramasMunicipio
			,RespuestaCompromisoDepartamento 
			,RespuestaObservacionDepartamento 
			,RespuestaPresupuestoDepartamento
			,AccionesDepartamento
			,ProgramasDepartamento
				FROM ( 
				SELECT DISTINCT 	P.ID AS IdPregunta, 
						P.ACTIVO, 
						P.IdTablero,
						MUN.Divipola AS DivipolaMunicipio,
						R.Id as IdRespuesta,
						R.RespuestaIndicativa AS RespuestaIndicativa, 
						R.RespuestaCompromiso AS RespuestaCompromiso, 
						R.Presupuesto,
						R.ObservacionNecesidad AS ObservacionNecesidad,
						R.AccionCompromiso AS AccionCompromiso
						
						,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
						FROM [PAT].RespuestaPATAccion AS ACCION
						WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesMunicipio,	
						
						STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
						FROM [PAT].RespuestaPATPrograma AS PROGRAMA
						WHERE R.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasMunicipio	
						
						,DEP.RespuestaCompromiso AS RespuestaCompromisoDepartamento 
						
						,DEP.ObservacionCompromiso AS RespuestaObservacionDepartamento
						
						,DEP.Presupuesto AS RespuestaPresupuestoDepartamento
						
						,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
						FROM [PAT].RespuestaPATAccion AS ACCION
						WHERE DEP.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesDepartamento,
							
						STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
						FROM [PAT].RespuestaPATPrograma AS PROGRAMA
						WHERE DEP.ID = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasDepartamento	

				FROM    PAT.PreguntaPAT AS P
				LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT]  
				LEFT OUTER JOIN Municipio AS MUN ON R.IdMunicipio = MUN.Id AND MUN.IdDepartamento = @DivipolaDepartamento													
				LEFT OUTER JOIN [PAT].RespuestaPATDepartamento DEP ON R.IdPreguntaPAT = DEP.IdPreguntaPAT and R.IdMunicipio = DEP.IdMunicipioRespuesta 	--trae varias respuestas
				LEFT OUTER JOIN Municipio AS MRDEP ON DEP.IdMunicipioRespuesta = MRDEP.Id AND MRDEP.IdDepartamento = @DivipolaDepartamento	
				--LEFT OUTER JOIN (SELECT	
				--						RESPUESTA.Id, 
				--						RESPUESTA.IdMunicipio,										
				--						RESPUESTA.IdPreguntaPAT,
				--						RESPUESTA.RespuestaIndicativa, 
				--						RESPUESTA.RespuestaCompromiso, 
				--						RESPUESTA.Presupuesto,
				--						RESPUESTA.ObservacionNecesidad,
				--						RESPUESTA.AccionCompromiso
				--				FROM    PAT.RespuestaPAT AS RESPUESTA
				--				INNER JOIN dbo.Departamento D ON RESPUESTA.IdDepartamento = D.Id
				--				WHERE D.Divipola = @DivipolaDepartamento
				--				) AS R ON P.ID = R.IdPreguntaPAT
				--	LEFT OUTER JOIN dbo.Municipio MUN ON R.IdMunicipio = MUN.Id
				--	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento DEP ON R.IdPreguntaPAT = DEP.IdPreguntaPAT AND R.IdMunicipio = DEP.IdMunicipioRespuesta --AND DEP.ID_ENTIDAD = PAT.fn_GetIdEntidad(@ID_ENTIDAD)
				--	LEFT OUTER JOIN PAT.RespuestaPAT RD ON P.ID = RD.IdPreguntaPAT AND RD.IdDepartamento = (Select xx.Id FROM dbo.Departamento xx WHERE xx.Divipola = @DivipolaDepartamento)
				WHERE	P.NIVEL = 3  
				and  P.NIVEL = 3 
				and MUN.IdDepartamento = @DivipolaDepartamento
				and P.ACTIVO = 1  
				--AND R.IdMunicipio IN ( SELECT xx.Id FROM dbo.Municipio xx WHERE xx.IdDepartamento = (Select xx.Id FROM dbo.Departamento xx WHERE xx.Divipola = @DivipolaDepartamento))
			) AS P 
			WHERE P.Activo = 1 AND P.IdTablero = @IdTablero ORDER BY 3,2,1		

END

go


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
/Descripcion: Inserta los datos de envio de los tres tipos de tablero: Planeacion Municipal "PM", Planeacion Departamental "PD"
/, Primer Seguimiento Municpal "SM1", Segundo Seguimiento Municpal "SM2"						  
/, Primer Seguimiento Departamental "SD1", Segundo Seguimiento Departamental "SD2"	
/Modificacion: Se cambia la validación de envío de SM2					  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_EnvioTableroPat] --1460, 1, 'SD2'
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
		set @guardoPreguntas = 0
		--pendiente		
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
			AND (SG.CantidadSegundo >= 0 or SG.PresupuestoSegundo >= 0)--en municipios tenia un or
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
		AND EXISTS (
			SELECT XX.* FROM PAT.RespuestaPAT XX where XX.IdPreguntaPAT = a.IdPreguntaPAT AND xx.IdMunicipio = a.IdMunicipioRespuesta
		)

		SELECT 
		@CantPreguntasSeguimientoGobConsolidado = COUNT(distinct P.Id)
		--D.Nombre as Departamento, M.Nombre as Municipio, Der.Descripcion as Derecho,P.Id as IdPregunta, P.PreguntaIndicativa , SEG.CantidadSegundo, SEG.PresupuestoSegundo
		--,SEG.IdSeguimiento
		-- count(PPG.IdPreguntaPAT)AS NUM_PREGUNTAS_CONTESTAR, COUNT(SEG.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		FROM @PreguntasPlaneacionGobConsolidado as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadSegundo >= 0 or SEG.PresupuestoSegundo >= 0) AND SEG.ObservacionesSegundo IS NOT NULL
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


/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez
/Modifica: Equipo OIM	- Andrés Bonilla																	  
/Modifica: Equipo OIM	- vilma rodriguez																	  
/Fecha creacion:     2017-12-11	
/Fecha modificacion :2018-02-14
/Fecha modificacion :2018-03-09
/Descripcion: Inserta los datos de envio de los tres tipos de tablero: Planeacion Municipal "PM", Planeacion Departamental "PD"
/, Primer Seguimiento Municpal "SM1", Segundo Seguimiento Municpal "SM2"						  
/, Primer Seguimiento Departamental "SD1", Segundo Seguimiento Departamental "SD2"	
/Modificacion: Se cambia la validación de envío de SM2					  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_EnvioTableroPat_Test] --1460, 1, 'SD2'
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
		set @guardoPreguntas = 0
		--pendiente		
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
			AND (SG.CantidadSegundo >= 0 or SG.PresupuestoSegundo >= 0)--en municipios tenia un or
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
		AND EXISTS (
			SELECT XX.* FROM PAT.RespuestaPAT XX where XX.IdPreguntaPAT = a.IdPreguntaPAT AND xx.IdMunicipio = a.IdMunicipioRespuesta
			)

		SELECT 
		@CantPreguntasSeguimientoGobConsolidado = COUNT(distinct P.Id)
		--D.Nombre as Departamento, M.Nombre as Municipio, Der.Descripcion as Derecho,P.Id as IdPregunta, P.PreguntaIndicativa , SEG.CantidadSegundo, SEG.PresupuestoSegundo
		--,SEG.IdSeguimiento
		-- count(PPG.IdPreguntaPAT)AS NUM_PREGUNTAS_CONTESTAR, COUNT(SEG.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		FROM @PreguntasPlaneacionGobConsolidado as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadSegundo >= 0 or SEG.PresupuestoSegundo >= 0) AND SEG.ObservacionesSegundo IS NOT NULL
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

	if(@esValido = 1) 
	begin
		BEGIN TRY
	
		--INSERT INTO [PAT].[EnvioTableroPat]
		--		   ([IdTablero]
		--		   ,[IdUsuario]
		--		   ,[IdMunicipio]
		--		   ,[IdDepartamento]
		--		   ,[TipoEnvio]
		--		   ,[FechaEnvio])
		--	 VALUES
		--		   (@IdTablero,@IdUsuario,@IdMunicipio,@IdDepartamento,@TipoEnvio, getdate())
	 			
		
			select @id = 0
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
---------------------------servicios web---------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PAT.CompromisosEntidadNacionalReparacionColectiva')) 
begin
CREATE TABLE [PAT].[CompromisosEntidadNacionalReparacionColectiva](
	[IdTablero] [int] NULL,
	[Vigencia] [int] NULL,
	[IdPregunta] [int] NULL,
	[DaneDepartamento] [int] NULL,
	[DaneMunicipio] [int] NULL,
	[IdEntidadNacional] [int] NULL,
	[NombreEntidadNacional] [varchar](500) NULL,
	[AccionEntidadNacional] [varchar](max) NULL,
	[PresupuestoNivelNacional] [int] NULL,
	[FechaUltimaModificacion] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
end

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PAT.CompromisosEntidadNacionalRetornosReubicaciones')) 
begin
CREATE TABLE [PAT].[CompromisosEntidadNacionalRetornosReubicaciones](
	[IdTablero] [int] NULL,
	[Vigencia] [int] NULL,
	[IdPregunta] [int] NULL,
	[DaneDepartamento] [int] NULL,
	[DaneMunicipio] [int] NULL,
	[IdEntidadNacional] [int] NULL,
	[NombreEntidadNacional] [varchar](500) NULL,
	[AccionEntidadNacional] [varchar](max) NULL,
	[PresupuestoNivelNacional] [int] NULL,
	[FechaUltimaModificacion] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
end
GO


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
		
	IF(select top 1 1 from  PAT.SeguimientoEntidadNacional where IdTablero =@IdTablero and Vigencia =@Vigencia and IdPregunta =@IdPregunta and DaneDepartamento= @DaneDepartamento and DaneMunicipio = @DaneMunicipio and 	IdEntidadNacional = @IdEntidadNacional and Semestre =@Semestre) >=1
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

IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Administración Servicios Web' AND IdRecurso = 3)
BEGIN
	--SET IDENTITY_INSERT [dbo].[SubRecurso] ON	
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso]) VALUES (102, 'Administración Servicios Web', NULL, 3)
	--SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END
go

