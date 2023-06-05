------------------------------planeacion municipal------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroMunicipio] AS'
GO
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	24/04/2018
-- Description:		Trae el listado de todas las preguntas municipales del tablero, derecho y municipio indicado  
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroMunicipio] --[PAT].[C_TableroMunicipio] null, 1, 20, 430 , 13,3
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		IDPREGUNTA SMALLINT,IDDERECHO SMALLINT,IDCOMPONENTE TINYINT,IDMEDIDA SMALLINT,NIVEL TINYINT,
		PREGUNTAINDICATIVA NVARCHAR(500),IDUNIDADMEDIDA TINYINT,PREGUNTACOMPROMISO NVARCHAR(500),APOYODEPARTAMENTAL BIT,
		APOYOENTIDADNACIONAL BIT,ACTIVO BIT,DERECHO NVARCHAR(50),COMPONENTE NVARCHAR(255),MEDIDA NVARCHAR(255),
		UNIDADMEDIDA NVARCHAR(100),IDTABLERO TINYINT,IDENTIDAD INT,ID INT,RESPUESTAINDICATIVA INT,
		RESPUESTACOMPROMISO INT,PRESUPUESTO MONEY,OBSERVACIONNECESIDAD NVARCHAR(1000),ACCIONCOMPROMISO NVARCHAR(1000), 
		RequiereAdjunto bit,MensajeAdjunto NVARCHAR(max),ExplicacionPregunta NVARCHAR(max),NombreAdjunto NVARCHAR(200), ObservacionPresupuesto NVARCHAR(max), ValidacionEnvio bit
		)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize 

	SET @ORDEN = @sortOrder
	SET @ORDEN = 'P.ID'
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	Declare @IdMunicipio int
	SELECT @IdMunicipio =  U.[IdMunicipio] FROM [dbo].[Usuario] (NOLOCK) U WHERE U.ID = @IdUsuario
	
	SET @SQL = 'SELECT 	DISTINCT
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO,
		RequiereAdjunto,MensajeAdjunto,ExplicacionPregunta,NombreAdjunto,ObservacionPresupuesto,ValidacionEnvio
		FROM (
		SELECT DISTINCT TOP (@TOP) LINEA,
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO,
		RequiereAdjunto,MensajeAdjunto,ExplicacionPregunta,NombreAdjunto,ObservacionPresupuesto, ValidacionEnvio
	FROM ( 
    SELECT DISTINCT row_number() OVER (ORDER BY '+ @ORDEN +') AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID ,
						R.RespuestaIndicativa, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO,
						P.RequiereAdjunto,
						P.MensajeAdjunto,
						P.ExplicacionPregunta,
						R.NombreAdjunto,
						R.ObservacionPresupuesto,
						CONVERT(bit, case when (R.RespuestaCompromiso >=0 and R.RespuestaIndicativa >=0 and R.NecesidadIdentificada >=0 AND R.Presupuesto >=0) then 1 else 0 end) AS ValidacionEnvio
				FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdMunicipio =  @IdMunicipio ,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T,
						[PAT].[PreguntaPATMunicipio] as PM
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND P.ID = PM.IdPreguntaPAT and PM.IdMunicipio = @IdMunicipio
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 					
					AND D.ID = @IdDerecho'	
	SET @SQL =@SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY LINEA ) AS T'
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IdMunicipio INT,@IdDerecho INT'
		
	PRINT @SQL
	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IdMunicipio=@IdMunicipio, @IdDerecho=@IdDerecho
	SELECT * from @RESULTADO
END

------------------------------planeacion departamental------------------------------
go
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ValidacionEnvioConsolidado]') ) 
	drop function [PAT].[C_ValidacionEnvioConsolidado]
GO
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		24/04/2018
-- Modified date:	24/04/2018
-- Description:		Obtiene la validacion para el envio del tablero para una pregunta de un departamento.
-- =============================================
create function [PAT].[C_ValidacionEnvioConsolidado] 
	(@IdDepartamento int,
	@IdPregunta int)
RETURNS bit
AS
BEGIN	
    DECLARE @Valido bit, @NUM_PREGUNTAS_CONTESTAR int, @NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO int
	set @Valido = 0

	SELECT 	@NUM_PREGUNTAS_CONTESTAR =COUNT(R.Id) , --Respuestas alcaldia
		@NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO =count(DEP.Id) --respuestas del departamento
		FROM [PAT].[PreguntaPAT] AS P
		JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT]  and (R.NecesidadIdentificada >0 or R.RespuestaCompromiso >0)
		JOIN Municipio AS MR ON R.IdMunicipio = MR.Id AND MR.IdDepartamento = @IdDepartamento													
		LEFT OUTER JOIN [PAT].RespuestaPATDepartamento DEP ON R.IdPreguntaPAT = DEP.IdPreguntaPAT and R.IdMunicipio = DEP.IdMunicipioRespuesta and DEP.RespuestaCompromiso>=0 and DEP.Presupuesto >=0
		LEFT OUTER JOIN Municipio AS MRDEP ON DEP.IdMunicipioRespuesta = MRDEP.Id AND MRDEP.IdDepartamento = @IdDepartamento																																			
		WHERE   P.NIVEL = 3 
		and P.ApoyoDepartamental =1
		and R.IdDepartamento= @IdDepartamento
		and P.Id =@IdPregunta
		and P.ACTIVO = 1  	
		if (@NUM_PREGUNTAS_CONTESTAR = @NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO)
			set @Valido = 1
		
	return @Valido
END 

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroMunicipioTotales]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroMunicipioTotales] AS'
GO
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - liliana Rodriguez
-- Create date:		10/07/2017
-- Modified date:	24/04/2018
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados, con las respuestas dadas por el gobernador 
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroMunicipioTotales] -- [PAT].[C_TableroMunicipioTotales]  null, 1,20,843,3,3
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT,  @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @RESULTADO TABLE (
		ID_PREGUNTA INT,
		PREGUNTAINDICATIVA NVARCHAR(500),
		DERECHO NVARCHAR(50),
		COMPONENTE NVARCHAR(255),
		MEDIDA NVARCHAR(255),
		UNIDADMEDIDA NVARCHAR(100),
		IDTABLERO TINYINT,
		TOTALNECESIDADES INT,
		TOTALCOMPROMISOS INT,
		TOTALPRESUPUESTO MONEY,
		TOTALCOMPROMISOGOBERNACION INT,
		TOTALPRESUPUESTOGOBERNACION MONEY,
		ID INT,
		ValidacionEnvio bit
		)
	
	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize

	SET @ORDEN = @sortOrder
	IF @ORDEN = ''
			SET @ORDEN = 'P.ID_PREGUNTA'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE  @IdMunicipio INT, @IDDEPARTAMENTO INT

	SELECT @IDDEPARTAMENTO = IdDepartamento , @IdMunicipio = IdMunicipio FROM USUARIO WHERE Id = @IdUsuario

	SET @SQL = '
SELECT DISTINCT TOP (@TOP)  ID_PREGUNTA,PREGUNTAINDICATIVA,DERECHO, COMPONENTE, MEDIDA, UNIDADMEDIDA,	IDTABLERO,
TOTALNECESIDADES,TOTALCOMPROMISOS,TOTALPRESUPUESTO,TOTALCOMPROMISOGOBERNACION,TOTALPRESUPUESTOGOBERNACION  ,IDRESPUESTA,ValidacionEnvio
FROM (
	SELECT LINEA,ID_PREGUNTA,PREGUNTAINDICATIVA,
	D.DESCRIPCION AS DERECHO, 
	C.DESCRIPCION AS COMPONENTE, 
	M.DESCRIPCION AS MEDIDA, 
	UM.DESCRIPCION AS UNIDADMEDIDA,	
	T.ID AS IDTABLERO,
	TOTALNECESIDADES,TOTALCOMPROMISOS,TOTALPRESUPUESTO,TOTALCOMPROMISOGOBERNACION,TOTALPRESUPUESTOGOBERNACION ,IDRESPUESTA , ValidacionEnvio
	FROM (
		SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
		P.ID AS ID_PREGUNTA,
		--alcaldias 											
		(SELECT SUM(R1.RespuestaIndicativa) 
		FROM  [PAT].[RespuestaPAT] R1	
		join Municipio MUN ON R1.IdMunicipio = MUN.Id
		WHERE R1.[IdPreguntaPAT]=P.Id  AND MUN.IdDepartamento = @IDDEPARTAMENTO							
		) TOTALNECESIDADES,
		(SELECT SUM(R1.RESPUESTACOMPROMISO) 
		FROM  [PAT].[RespuestaPAT] R1
		join Municipio MUN ON R1.IdMunicipio = MUN.Id
		WHERE R1.IdPreguntaPAT=P.Id AND MUN.IdDepartamento = @IDDEPARTAMENTO								
		) TOTALCOMPROMISOS,
		(SELECT SUM(R1.PRESUPUESTO) 
		FROM  [PAT].[RespuestaPAT] R1
		join Municipio MUN ON R1.IdMunicipio = MUN.Id
		WHERE R1.IdPreguntaPAT=P.Id AND MUN.IdDepartamento = @IDDEPARTAMENTO								
		) TOTALPRESUPUESTO,
		--gobernaciones						
		(SELECT SUM(R1.RespuestaCompromiso) 
		FROM  [PAT].RespuestaPATDepartamento R1
		join Usuario as U on R1.IdUsuario = U.Id
		WHERE R1.IdPreguntaPAT=P.Id AND U.IdDepartamento = @IDDEPARTAMENTO								
		) as TOTALCOMPROMISOGOBERNACION,						
		(SELECT SUM(R1.Presupuesto) 
		FROM  [PAT].RespuestaPATDepartamento R1
		join Usuario as U on R1.IdUsuario = U.Id
		WHERE R1.IdPreguntaPAT=P.Id AND U.IdDepartamento = @IDDEPARTAMENTO								
		) as TOTALPRESUPUESTOGOBERNACION,
		(SELECT TOP 1 RR.ID FROM [PAT].[RespuestaPATDepartamento] RR 
		join Usuario as U on RR.IdUsuario = U.Id		
		WHERE P.Id = RR.IdPreguntaPAT  AND U.IdDepartamento = @IDDEPARTAMENTO	) AS IDRESPUESTA
		--, 1 as ValidacionEnvio
		,[PAT].[C_ValidacionEnvioConsolidado](@IDDEPARTAMENTO, P.Id )   as ValidacionEnvio		
		FROM    [PAT].[PreguntaPAT] as P 
		join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT
		join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = @IDDEPARTAMENTO
		LEFT OUTER JOIN [PAT].[RespuestaPAT] RA  on P.Id = RA.IdPreguntaPAT and RA.IdDepartamento =  @IDDEPARTAMENTO and RA.IdMunicipio is not null																		
		WHERE   P.NIVEL = 3 
		AND P.ACTIVO = 1
		AND P.ApoyoDepartamental = 1 					
		AND P.IdDerecho = @IdDerecho
		AND P.IdTablero = @idTablero	
		GROUP BY P.ID
	) AS A
	JOIN [PAT].[PreguntaPAT] as P on A.ID_PREGUNTA = P.Id,
	[PAT].[Derecho] D,
	[PAT].[Componente] C,
	[PAT].[Medida] M,
	[PAT].[UnidadMedida] UM,
	[PAT].[Tablero] T
	where
	P.IDDERECHO = D.ID 
	AND P.IDCOMPONENTE = C.ID 
	AND P.IDMEDIDA = M.ID 
	AND P.IDUNIDADMEDIDA = UM.ID 
	AND P.IDTABLERO = T.ID						
'		
	SET @SQL = @SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY P.ID_PREGUNTA'--+ @ORDEN 	
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IdMunicipio INT,@IdDerecho INT, @IDDEPARTAMENTO int'
		
	PRINT @SQL

	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IdMunicipio=@IdMunicipio, @IdDerecho=@IdDerecho, @IDDEPARTAMENTO=@IDDEPARTAMENTO
	SELECT * from @RESULTADO
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroDepartamento] AS'
GO
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		10/07/2017
-- Modified date:	24/04/2018
-- Description:		Obtiene las preguntas para la gestión del tablero PAT departamental
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroDepartamento]  --[PAT].[C_TableroDepartamento] 431,3
 (@IdUsuario INT, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE  @IdDepartamento INT	
	select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

	SELECT distinct	P.Id AS ID_PREGUNTA, 
			P.IdDerecho, 
			P.IdComponente, 
			P.IdMedida, 
			P.NIVEL as Nivel, 
			P.PreguntaIndicativa, 
			P.IdUnidadMedida, 
			P.PreguntaCompromiso, 
			P.ApoyoDepartamental, 
			P.ApoyoEntidadNacional, 
			P.ACTIVO as Activo, 
			DERECHO.Descripcion AS Derecho, 
			COMPONENTE.Descripcion AS Componente, 
			MEDIDA.Descripcion AS Medida, 
			UNIDAD_MEDIDA.Descripcion AS UnidadMedida,	
			@idTablero AS IdTablero,			
			@IdDepartamento AS IdEntidad,						
			R.Id as IdRespuesta,
			R.RespuestaIndicativa,  
			R.RespuestaCompromiso, 
			R.Presupuesto,
			R.ObservacionNecesidad, 
			R.AccionCompromiso,
			P.RequiereAdjunto,
			P.MensajeAdjunto,
			P.ExplicacionPregunta,
			R.NombreAdjunto ,
			R.ObservacionPresupuesto,			
			CONVERT(bit, case when (R.RespuestaCompromiso >=0 and R.RespuestaIndicativa >=0  AND R.Presupuesto >=0) then 1 else 0 end) AS ValidacionEnvio
	FROM  PAT.PreguntaPAT AS P
	JOIN PAT.PreguntaPATDepartamento AS PD ON P.Id = PD.IdPreguntaPAT AND PD.IdDepartamento =@IdDepartamento
	INNER JOIN PAT.Derecho DERECHO ON P.IdDerecho = DERECHO.Id 
	INNER JOIN PAT.Componente COMPONENTE ON P.IdComponente= COMPONENTE.Id
	INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
	INNER JOIN PAT.UnidadMedida UNIDAD_MEDIDA ON P.IdUnidadMedida = UNIDAD_MEDIDA.Id
	LEFT OUTER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id	
	LEFT OUTER JOIN [PAT].[RespuestaPAT] AS R ON P.Id = R.IdPreguntaPAT AND R.IdDepartamento =  @IdDepartamento 	
	WHERE TABLERO.Id = @idTablero
	AND	P.NIVEL = 2 and P.ACTIVO = 1
END

go
--------------------------SEGUIMENTO MUNICIPAL--------------------------------------

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ValidacionEnvioSeguimiento]') ) 
	DROP function [PAT].[C_ValidacionEnvioSeguimiento] 
GO
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		24/04/2018
-- Modified date:	24/04/2018
-- Description:		Obtiene la validacion para el envio del tablero para una pregunta de un municipip.
-- =============================================
CREATE function [PAT].[C_ValidacionEnvioSeguimiento] 
	(@IdMunicipio int,
	@IdPregunta int,@IdUsuario INT, @NumeroSeguimiento int)
RETURNS bit
AS
BEGIN	
    DECLARE @Valido bit
	set @Valido = 1
		
	IF EXISTS (SELECT TOP 1 1 	FROM PAT.RespuestaPAT a
	INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
	WHERE a.IdMunicipio = @IdMunicipio AND b.Id = @IdPregunta AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0))--TIENE PLANEACION DEBE TENER SEGUIMIENTO
	BEGIN 
		if (@NumeroSeguimiento = 1)
		begin 
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadPrimer >= 0 OR PresupuestoPrimer >= 0))
			BEGIN
				set @Valido = 0
			END
		END
		else		
		begin 
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadSegundo >= 0 OR PresupuestoSegundo >= 0) AND ObservacionesSegundo IS NOT NULL)
			BEGIN
				set @Valido = 0
			END
		END
	END
		
	return @Valido
END 

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoMunicipio] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/08/2017
-- Modified date:	26/04/2018
-- Description:		Retorna el numero de seguimiento de acuerdo al momento en el que se llame el procedimiento
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoMunicipio] --[PAT].[C_TableroSeguimientoMunicipio] 1, 1, 430
(	@IdDerecho INT
	,@IdTablero INT
	,@IdUsuario INT
)
AS
BEGIN

		declare @IdMunicipio int,@NumeroSeguimiento int
		select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario
				
		declare @date datetime
		set @date = getdate()
		select @NumeroSeguimiento =
			case when (@date between [Seguimiento1Inicio] and [Seguimiento1Fin]) then 1
				 when (@date between [Seguimiento2Inicio] and [Seguimiento2Fin]) then 2 end	
		from pat.TableroFecha
		where IdTablero = @IdTablero  and nivel = 3
		
		select distinct
		e.Descripcion as Derecho
		,b.Descripcion as Componente
		,c.Descripcion as Medida
		,a.PreguntaIndicativa
		,d.Descripcion as Unidad
		,a.PreguntaCompromiso
		,ISNULL(f.IdSeguimiento, 0) as IdSeguimiento
		,ISNULL(f.CantidadPrimer, -1) as CompromisoPrimerSemestre
		,ISNULL(f.CantidadSegundo, -1) as CompromisoSegundoSemestre
		,ISNULL(f.CantidadPrimer + REPLACE(f.CantidadSegundo, -1, 0), -1) as CompromisoTotal
		,ISNULL(f.PresupuestoPrimer, -1) as PresupuestoPrimerSemestre
		,ISNULL(f.PresupuestoSegundo, -1) as PresupuestoSegundoSemestre
		,ISNULL(f.PresupuestoPrimer + REPLACE(f.PresupuestoSegundo, -1, 0), -1) as PresupuestoTotal
		,a.ID 
		,a.IdComponente 
		,a.IdDerecho 
		,a.IdMedida 
		,a.IdUnidadMedida
		,ISNULL(R.RespuestaCompromiso, 0) AS RespuestaIndicativa
		,ISNULL(R.Presupuesto, 0) AS Presupuesto, r.RespuestaIndicativa as NecesidadIdentificada,ExplicacionPregunta
		,[PAT].[C_ValidacionEnvioSeguimiento] (@IdMunicipio, a.Id, @IdUsuario,@NumeroSeguimiento )   as ValidacionEnvio	
		from [PAT].PreguntaPAT AS a
		join [PAT].[PreguntaPATMunicipio] as PM on a.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		inner join [PAT].Componente AS b on b.ID = a.IdComponente
		inner join [PAT].Medida AS c on c.ID = a.IdMedida
		inner join [PAT].UnidadMedida AS d on d.ID = a.IdUnidadMedida
		inner join [PAT].Derecho AS e on e.ID = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT as R on R.IdPreguntaPAT = a.ID and r.IdMunicipio = @IdMunicipio
		LEFT OUTER JOIN [PAT].Seguimiento as f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
		where a.ACTIVO = 1
		and e.ID = @IdDerecho
		and a.IdTablero = @IdTablero
		order by a.ID  asc
END
GO
--------------------------SEGUIMENTO gob--------------------------------------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ValidacionEnvioSeguimientoGobernacion]') ) 
	drop function [PAT].[C_ValidacionEnvioSeguimientoGobernacion]
GO
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		24/04/2018
-- Modified date:	24/04/2018
-- Description:		Obtiene la validacion para el envio del tablero para una pregunta de un departamento.
-- =============================================
create function [PAT].[C_ValidacionEnvioSeguimientoGobernacion] (@IdUsuario int , @IdPregunta int,@IdDepartamento INT, @NumeroSeguimiento int)
RETURNS bit
AS
BEGIN	
    DECLARE @Valido bit
	set @Valido = 1
		
	IF EXISTS (SELECT top 1 1 FROM PAT.RespuestaPAT a
			INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
			WHERE a.IdDepartamento = @IdDepartamento AND b.Activo = 1 and b.Nivel = 2 and b.Id = @IdPregunta	AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0))--TIENE PLANEACION DEBE TENER SEGUIMIENTO
	BEGIN 
		if (@NumeroSeguimiento = 1)
		begin 		
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadPrimer >= 0 OR PresupuestoPrimer >= 0))
			BEGIN
				set @Valido = 0
			END
		END
		else		
		begin 
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadSegundo >= 0 OR PresupuestoSegundo >= 0) AND ObservacionesSegundo IS NOT NULL)
			BEGIN
				set @Valido = 0
			END
		END
	END
		
	return @Valido
END 

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDepartamento] AS'
GO

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez -Vilma rodriguez
-- Create date:		29/08/2017
-- Modified date:	26/04/2018
-- Description:		Obtiene informacion de las preguntas por departamento para el seguimiento de un tablero departamental
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDepartamento] -- [PAT].[C_TableroSeguimientoDepartamento] 2, 1598
(	@IdTablero INT ,@IdUsuario INT )
AS
BEGIN		
		DECLARE  @IdDepartamento INT,@NumeroSeguimiento int	
		select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

		declare @date datetime
		set @date = getdate()
		select @NumeroSeguimiento =
			case when (@date between [Seguimiento1Inicio] and [Seguimiento1Fin]) then 1
				 when (@date between [Seguimiento2Inicio] and [Seguimiento2Fin]) then 2 end	
		from pat.TableroFecha
		where IdTablero = @IdTablero  and nivel = 3

		select distinct
		e.Descripcion as Derecho
		,b.Descripcion as Componente
		,c.Descripcion as Medida
		,a.PreguntaIndicativa
		,d.Descripcion as Unidad
		,a.PreguntaCompromiso
		,ISNULL(f.IdSeguimiento, 0) as IdSeguimiento
		,ISNULL(f.CantidadPrimer, -1) as CompromisoPrimerSemestre
		,ISNULL(f.CantidadSegundo, -1) as CompromisoSegundoSemestre
		,ISNULL(f.CantidadPrimer + REPLACE(f.CantidadSegundo, -1, 0), -1) as CompromisoTotal
		,ISNULL(f.PresupuestoPrimer, -1) as PresupuestoPrimerSemestre
		,ISNULL(f.PresupuestoSegundo, -1) as PresupuestoSegundoSemestre
		,ISNULL(f.PresupuestoPrimer + REPLACE(f.PresupuestoSegundo, -1, 0), -1) as PresupuestoTotal
		,a.Id 
		,a.IdComponente 
		,a.IdDerecho
		,a.IdMedida 
		,a.IdUnidadMedida
		,ISNULL(R.RespuestaCompromiso, 0) AS RespuestaIndicativa
		,ISNULL(R.Presupuesto, 0) AS Presupuesto
		, R.RespuestaIndicativa as NecesidadIdentificada
		,[PAT].[C_ValidacionEnvioSeguimientoGobernacion] (@IdUsuario,a.Id, @IdDepartamento,@NumeroSeguimiento )   as ValidacionEnvio	
		from [PAT].PreguntaPAT AS a
		join pat.PreguntaPATDepartamento as PD on a.Id = PD.IdPreguntaPAT and PD.IdDepartamento = @IdDepartamento
		inner join [PAT].Componente b on b.Id = a.IdComponente
		inner join [PAT].[Medida] c on c.Id = a.IdMedida
		inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
		inner join [PAT].Derecho e on e.Id = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT R on R.IdPreguntaPAT = a.ID and R.IdDepartamento= @IdDepartamento
		--LEFT OUTER JOIN [PAT].SeguimientoGobernacion f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
		LEFT OUTER JOIN [PAT].Seguimiento f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
		left outer join Usuario as U on f.IdUsuario = U.Id and U.IdTipoUsuario = 7 and U.Activo = 1 and U.IdEstado = 5
		where a.IdTablero = @IdTablero
		and a.NIVEL = 2
		order by a.Id  asc
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ValidacionEnvioSeguimientoGobernacionConsolidado]') ) 
	drop function [PAT].[C_ValidacionEnvioSeguimientoGobernacionConsolidado]
GO
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		24/04/2018
-- Modified date:	24/04/2018
-- Description:		Obtiene la validacion para el envio del tablero para una pregunta del consolidado de un departamento.
-- =============================================
create function   [PAT].[C_ValidacionEnvioSeguimientoGobernacionConsolidado] (@IdUsuario int , @IdPregunta int,@IdDepartamento INT, @NumeroSeguimiento int)
RETURNS bit
AS
BEGIN	
    DECLARE @Valido bit
	set @Valido = 1

	DECLARE @CantPreguntasSeguimientoGobConsolidado INT
	DECLARE @PreguntasPlaneacionGobConsolidado TABLE (IdPreguntaPAT INT,IdUsuario int, IdDepartamento int, IdMunicipio int, IdUsuarioAlcaldia INT)--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento

	INSERT INTO @PreguntasPlaneacionGobConsolidado--inserta las preguntas con respuestas que dio ese usuario con compromiso >0 or OR a.Presupuesto > 0
	SELECT a.IdPreguntaPAT, a.IdUsuario, m.IdDepartamento , a.IdMunicipioRespuesta
	,(select id from dbo.Usuario where IdMunicipio = a.IdMunicipioRespuesta and idestado = 5 and activo = 1 and IdTipoUsuario = 2)
	FROM PAT.RespuestaPATDepartamento a
	join Municipio as m on a.IdMunicipioRespuesta = m.Id
	INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
	WHERE b.Id = @IdPregunta and	a.IdUsuario =@IdUsuario  AND b.Activo = 1 and b.Nivel = 3 And b.ApoyoDepartamental =1 AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0) 
	
	if (@NumeroSeguimiento = 1)
	begin 		
		
		SELECT @CantPreguntasSeguimientoGobConsolidado = COUNT(distinct P.Id)
		FROM @PreguntasPlaneacionGobConsolidado as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadPrimer >= 0 or SEG.PresupuestoPrimer >= 0) 
		join Departamento as D on PPG.IdDepartamento = D.Id	
		JOIN Municipio AS M ON PPG.IdMunicipio = M.Id		
		WHERE SEG.IdSeguimiento is null	and PPG.IdDepartamento = @IdDepartamento and P.Id = @IdPregunta
		
		Set @Valido = CONVERT(bit,  CASE WHEN @CantPreguntasSeguimientoGobConsolidado = 0 THEN 1 ELSE 0 END)
	END
	else		
	begin 
		
		SELECT @CantPreguntasSeguimientoGobConsolidado = COUNT(distinct P.Id)
		FROM @PreguntasPlaneacionGobConsolidado as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadSegundo >= 0 or SEG.PresupuestoSegundo >= 0) AND SEG.ObservacionesSegundo IS NOT NULL
		join Departamento as D on PPG.IdDepartamento = D.Id	
		JOIN Municipio AS M ON PPG.IdMunicipio = M.Id		
		WHERE SEG.IdSeguimiento is null	and PPG.IdDepartamento = @IdDepartamento and P.Id = @IdPregunta
		
		Set @Valido = CONVERT(bit,  CASE WHEN @CantPreguntasSeguimientoGobConsolidado = 0 THEN 1 ELSE 0 END)
	END

	return @Valido
END 

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoConsolidadoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoConsolidadoDepartamento] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	26/04/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para una pregunta en especial
-- =============================================
ALTER PROC [PAT].[C_TableroSeguimientoConsolidadoDepartamento] --[PAT].[C_TableroSeguimientoConsolidadoDepartamento]  3, 375, 1
(	@IdTablero INT ,@IdUsuario INT ,@IdDerecho INT )
AS
BEGIN
	DECLARE  @IdDepartamento INT	,@NumeroSeguimiento int
	select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario


	declare @date datetime
		set @date = getdate()
		select @NumeroSeguimiento =
			case when (@date between [Seguimiento1Inicio] and [Seguimiento1Fin]) then 1
				 when (@date between [Seguimiento2Inicio] and [Seguimiento2Fin]) then 2 end	
		from pat.TableroFecha
		where IdTablero = @IdTablero  and nivel = 2

--SELECT
--B.DESCRIPCION AS COMPONENTE
--,C.DESCRIPCION AS MEDIDA
--,E.DESCRIPCION AS DERECHO
--,A.PREGUNTA_INDICATIVA 
--,D.DESCRIPCION AS UNIDAD
--,SUM(ISNULL(RD.RESPUESTA_COMPROMISO, 0)) AS TOTALCOMPROMISO
--,SUM(ISNULL(RD.PRESUPUESTO, 0)) AS TOTALPRESUPUESTO
--,ISNULL(SUM(SM.CantidadPrimer), -1) AS AVANCEPRIMERALCALDIAS
--,ISNULL(SUM(SM.CantidadSegundo), -1) AS AVANCESEGUNDOALCALDIAS
--,ISNULL(SUM(SG.CantidadPrimer), -1) AS AVANCEPRIMERGOBERNA
--,ISNULL(SUM(SG.CantidadSegundo), -1) AS AVANCESEGUNDOGOBERNA
--,A.ID AS ID_PREGUNTA
--,E.ID AS ID_DERECHO
--FROM [PAT].[TB_PREGUNTA] A
--inner join [PAT].[TB_COMPONENTE] b on b.ID = a.[ID_COMPONENTE]
--inner join [PAT].[TB_MEDIDA] c on c.ID = a.ID_MEDIDA
--inner join [PAT].[TB_UNIDAD_MEDIDA] d on d.ID = a.ID_UNIDAD_MEDIDA
--inner join [PAT].[TB_DERECHO] e on e.ID = a.ID_DERECHO
--LEFT OUTER JOIN [PAT].[TB_PAT_RESPUESTA_DEPARTAMENTO] RD ON RD.ID_PREGUNTA = A.ID AND RD.ID_ENTIDAD = PAT.fn_GetIdEntidad(@IdUsuario) AND RD.ID_TABLERO = @IdTablero
--LEFT OUTER JOIN [PAT].[TB_SEGUIMIENTO] SM ON SM.IdPregunta = A.ID AND SM.IdTablero = RD.ID_TABLERO AND SM.IdUsuario = [PAT].[fn_GetIdUsuario](RD.ID_ENTIDAD_MUNICIPIO)
--LEFT OUTER JOIN [PAT].[TB_SEGUIMIENTO_GOBERNACION] SG ON SG.IdPregunta = A.ID AND SG.IdTablero = SM.IdTablero AND SG.IdUsuarioAlcaldia = SM.IdUsuario
--WHERE E.ID = @IdDerecho AND A.ACTIVO = @Activo AND A.ID >= @IdPreguntaIni AND A.ID <= @IdPreguntaFin
--GROUP BY B.DESCRIPCION, C.DESCRIPCION, A.PREGUNTA_INDICATIVA, D.DESCRIPCION, E.DESCRIPCION, A.ID, E.ID

	SELECT DISTINCT
	B.Descripcion AS Componente
	,C.Descripcion AS Medida
	,E.Descripcion AS Derecho
	,A.PreguntaIndicativa 
	,D.DESCRIPCION AS UNIDAD
	
	,SUM(ISNULL(RD.RespuestaCompromiso, 0)) AS TotalCompromiso
	,SUM(ISNULL(RD.Presupuesto, 0)) AS TotalPresupuesto
	
	,ISNULL(SUM(isnull(SM.CantidadPrimer,0)), -1) AS AvancePrimerSemestreAlcladias
	,ISNULL(SUM(isnull(SM.CantidadSegundo,0)), -1) AS AvanceSegundoSemestreAlcladias

	,ISNULL(SUM( ISNULL(SG.CantidadPrimer,0)), -1) AS AvancePrimerSemestreGobernaciones
	,ISNULL(SUM(isnull(SG.CantidadSegundo,0)), -1) AS AvanceSegundoSemestreGobernaciones
	,A.Id AS IdPregunta
	,E.Id AS IdDerecho
	,[PAT].[C_ValidacionEnvioSeguimientoGobernacionConsolidado] (@IdUsuario,a.Id, @IdDepartamento,@NumeroSeguimiento )   as ValidacionEnvio	
	FROM [PAT].PreguntaPAT as A
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	join [PAT].[PreguntaPATMunicipio] as PM on a.Id = PM.IdPreguntaPAT
	join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = @IdDepartamento
	LEFT OUTER JOIN [PAT].RespuestaPAT as RM on RM.IdPreguntaPAT = A.ID and RM.IdMunicipio = PM.IdMunicipio AND RM.IdDepartamento = @IdDepartamento
	LEFT OUTER JOIN [PAT].Seguimiento as SM on SM.IdPregunta = a.ID and SM.IdUsuario = RM.IdUsuario
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON RD.IdPreguntaPAT =A.Id  AND RD.IdUsuario = @IdUsuario and RD.IdMunicipioRespuesta = RM.IdMunicipio 	
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion as SG ON SG.IdPregunta=A.ID   AND SG.IdUsuarioAlcaldia = SM.IdUsuario
	WHERE  A.IdTablero = @IdTablero
	and A.Nivel = 3
	and E.ID = @IdDerecho
	AND A.ACTIVO = 1		
	AND A.ApoyoDepartamental = 1 	
	GROUP BY
	B.Descripcion, C.Descripcion, A.PreguntaIndicativa, D.Descripcion, E.Descripcion, A.Id, E.Id

END

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoGobernaciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoGobernaciones] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		30/08/2017
-- Modified date:	26/03/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental de las preguntas del departamento
-- =============================================
ALTER PROC  [PAT].[C_DatosExcelSeguimientoGobernaciones] --[PAT].[C_DatosExcelSeguimientoGobernaciones]  1180, 2
(@IdUsuario INT,@IdTablero INT)
AS
BEGIN

	declare  @IdDepartamento int, @Departamento varchar(150)
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	select @Departamento = Nombre from Departamento where Id = @IdDepartamento
	SELECT IdPregunta,IdAccion,IdPrograma,Derecho,Componente,Medida,Pregunta,PreguntaCompromiso,UnidadNecesidad, RespuestaNecesidad,ObservacionNecesidad,
			RespuestaCompromiso,ObservacionCompromiso,RespuestaPresupuesto,Accion,Programa,CantidadPrimerSeguimientoGobernacion,CantidadSegundoSeguimientoGobernacion,
			PresupuestoPrimerSeguimientoGobernacion,PresupuestoSegundoSeguimientoGobernacion,AvanceCantidadGobernacion,AvancePresupuestoGobernacion,
			ObservacionesSeguimientoGobernacion,ObservacionesSegundoSeguimientoGobernacion,ProgramasPrimeroSeguimientoGobernacion,ProgramasSegundoSeguimientoGobernacion FROM (
		SELECT distinct
		A.Id AS IdPregunta
		,0 AS IdAccion
		,0 AS IdPrograma
		,B.Descripcion AS Derecho
		,C.Descripcion AS Componente
		,D.Descripcion AS Medida
		,A.PreguntaIndicativa AS Pregunta
		,A.PreguntaCompromiso
		,E.Descripcion AS UnidadNecesidad
		,RM.RespuestaIndicativa AS RespuestaNecesidad
		,RM.ObservacionNecesidad
		,RM.RespuestaCompromiso
		,RM.AccionCompromiso AS ObservacionCompromiso
		,RM.Presupuesto AS RespuestaPresupuesto
		--,RMA.Accion
		--,RMP.Programa
		,STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATAccion AS ACCION
		WHERE RM.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Accion				
		,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		WHERE RM.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Programa	

		,SG.CantidadPrimer  AS CantidadPrimerSeguimientoGobernacion
		,REPLACE(SG.CantidadSegundo, -1, 0) AS CantidadSegundoSeguimientoGobernacion
		,SG.PresupuestoPrimer AS PresupuestoPrimerSeguimientoGobernacion
		,REPLACE(SG.PresupuestoSegundo, -1, 0) AS PresupuestoSegundoSeguimientoGobernacion

		,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
		,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
		,SG.Observaciones AS ObservacionesSeguimientoGobernacion
		,SG.ObservacionesSegundo AS ObservacionesSegundoSeguimientoGobernacion

		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoProgramas AS SMP
		WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoProgramas AS SMP
		WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			
		
		FROM [PAT].PreguntaPAT A
		INNER JOIN [PAT].Derecho B ON B.Id = A.IdDerecho
		INNER JOIN [PAT].Componente C ON C.Id = A.IdComponente
		INNER JOIN [PAT].Medida D ON D.Id = A.IdMedida
		INNER JOIN [PAT].UnidadMedida E ON E.Id = A.IdUnidadMedida
		left outer JOIN [PAT].RespuestaPAT RM ON RM.IdPreguntaPAT = A.Id and RM.IdDepartamento =@IdDepartamento	
		--LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA ON RM.Id =RMA.IdRespuestaPAT 
		--LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP ON RM.Id = RMP.IdRespuestaPAT
		--LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  A.ID =SG.IdPregunta  AND SG.IdUsuario = @IdUsuario 
		LEFT OUTER JOIN [PAT].Seguimiento SG ON  A.ID =SG.IdPregunta  AND SG.IdUsuario = @IdUsuario 
		WHERE A.IdTablero = @IdTablero and  A.Activo = 1
		AND A.NIVEL = 2
		) AS A
	ORDER BY A.Derecho ASC, A.IdPregunta ASC
END


go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_EnvioTableroPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_EnvioTableroPat] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez
/Modifica: Equipo OIM	- Andrés Bonilla																	  
/Modifica: Equipo OIM	- vilma rodriguez																	  
/Fecha creacion:     2017-12-11	
/Fecha modificacion :2018-02-14
/Fecha modificacion :2018-03-09
/Fecha modificacion :2018-04-30
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
		IF NOT EXISTS (Select 1 from @UsuariosSinPlaneacion WHERE IdUsuario = @IdUsuario)
		BEGIN
			--Usuarios que no diligenciaron planeacion pueden enviar SM1 o SM2 sin problemas
			SET @guardoPreguntas = 1
		END
		ELSE
		BEGIN
			
			declare @cantPreguntas1 int

			select @cantPreguntas1 = count(a.Id)
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
			having (@cantPreguntas1 - SUM(case when a.RespuestaCompromiso is null then 0 when a.RespuestaCompromiso = 0 then 0 else 1 end)) = 100
			)
			BEGIN
				--Usuarios que llenaron todo en 0 pueden enviar SM1 y SM2 sin problema
				SET @guardoPreguntas = 1
			END
			ELSE
			BEGIN
				
				DECLARE @CantPreguntasSeguimiento1 INT

				--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
				DECLARE @PreguntasPlaneacion1 TABLE
				(
					IdPreguntaPAT INT				
				)

				INSERT INTO @PreguntasPlaneacion1
				SELECT a.IdPreguntaPAT
				FROM PAT.RespuestaPAT a
				INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
				WHERE
				b.IdTablero = @IdTablero
				AND a.IdUsuario = @IdUsuario
				AND b.Activo = 1 and b.Nivel = 3
				AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)


				SELECT @CantPreguntasSeguimiento1 = COUNT(DISTINCT IdPregunta)
				FROM PAT.Seguimiento
				WHERE IdPregunta IN (
					SELECT IdPreguntaPAT
					FROM @PreguntasPlaneacion1
				) 
				AND IdUsuario = @IdUsuario
				AND IdTablero = @IdTablero
				AND (CantidadPrimer >= 0 OR PresupuestoPrimer >= 0)				

				SELECT @guardoPreguntas = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimiento1 THEN 1 ELSE 0 END
				FROM @PreguntasPlaneacion1
			END
		END
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
			declare @cantPreguntasGob1 int

			select @cantPreguntasGob1 = count(a.Id)
			from pat.PreguntaPAT a
			where a.IdTablero = @IdTablero and a.Activo = 1 and a.Nivel = 2

			DECLARE @CantPreguntasSeguimientoGob1 INT
			--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
			DECLARE @PreguntasPlaneacionGob1 TABLE (IdPreguntaPAT INT)

			INSERT INTO @PreguntasPlaneacionGob1--inserta las preguntas con respuestas  de la planeacion que dio ese usuario con compromiso >0
			SELECT a.IdPreguntaPAT
			FROM PAT.RespuestaPAT a
			INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
			WHERE b.IdTablero = @IdTablero
			AND a.IdUsuario = @IdUsuario
			AND b.Activo = 1 and b.Nivel = 2
			AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)

			SELECT @CantPreguntasSeguimientoGob1 = COUNT(DISTINCT IdPregunta)
			--FROM PAT.SeguimientoGobernacion as SG
			FROM PAT.Seguimiento as SG
			join @PreguntasPlaneacionGob1 as PG on SG.IdPregunta = PG.IdPreguntaPAT 
			where SG.IdUsuario = @IdUsuario
			AND SG.IdTablero = @IdTablero
			AND (SG.CantidadPrimer >= 0 or SG.PresupuestoPrimer >= 0)			

			SELECT @guardoPreguntas = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimientoGob1 THEN 1 ELSE 0 END
			FROM @PreguntasPlaneacionGob1	
		end		
		-------------------------------------
		----PREGUNTAS CONSOLIDADO ALCALDIAS	
		-------------------------------------								
		DECLARE @CantPreguntasSeguimientoGobConsolidado1 INT
		DECLARE @PreguntasPlaneacionGobConsolidado1 TABLE (IdPreguntaPAT INT,IdUsuario int, IdDepartamento int, IdMunicipio int, IdUsuarioAlcaldia INT)--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento

		INSERT INTO @PreguntasPlaneacionGobConsolidado1--inserta las preguntas con respuestas que dio ese usuario con compromiso >0 or OR a.Presupuesto > 0
		SELECT a.IdPreguntaPAT, a.IdUsuario, m.IdDepartamento , a.IdMunicipioRespuesta
		,(select id from dbo.Usuario where IdMunicipio = a.IdMunicipioRespuesta and idestado = 5 and activo = 1 and IdTipoUsuario = 2)
		--, a.RespuestaCompromiso, a.Presupuesto
		FROM PAT.RespuestaPATDepartamento a
		join Municipio as m on a.IdMunicipioRespuesta = m.Id
		INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
		WHERE	b.IdTablero = @IdTablero AND b.Activo = 1 and b.Nivel = 3 And b.ApoyoDepartamental =1 AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0) 

		SELECT 
		@CantPreguntasSeguimientoGobConsolidado1 = COUNT(distinct P.Id)
		--D.Nombre as Departamento, M.Nombre as Municipio, Der.Descripcion as Derecho,P.Id as IdPregunta, P.PreguntaIndicativa , SEG.CantidadSegundo, SEG.PresupuestoSegundo
		--,SEG.IdSeguimiento
		-- count(PPG.IdPreguntaPAT)AS NUM_PREGUNTAS_CONTESTAR, COUNT(SEG.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		FROM @PreguntasPlaneacionGobConsolidado1 as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadPrimer >= 0 or SEG.PresupuestoPrimer >= 0)
		join Departamento as D on PPG.IdDepartamento = D.Id	
		JOIN Municipio AS M ON PPG.IdMunicipio = M.Id		
		WHERE P.IdTablero = 1 and SEG.IdSeguimiento is null	and PPG.IdDepartamento = @IdDepartamento
		--order by D.Nombre, M.Nombre


		SELECT @guardoPreguntasConsolidado = CASE WHEN @CantPreguntasSeguimientoGobConsolidado1 = 0 THEN 1 ELSE 0 END
	
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
