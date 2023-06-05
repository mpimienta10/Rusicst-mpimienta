-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	17/01/2018
-- Description:		Trae el listado de todas las preguntas municipales del tablero, derecho y municipio indicado  
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroMunicipio] --[PAT].[C_TableroMunicipio] null, 1, 20, 411 , 1,3
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
		RequiereAdjunto bit,MensajeAdjunto NVARCHAR(max),ExplicacionPregunta NVARCHAR(max),NombreAdjunto NVARCHAR(200), ObservacionPresupuesto NVARCHAR(max)
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
		RequiereAdjunto,MensajeAdjunto,ExplicacionPregunta,NombreAdjunto,ObservacionPresupuesto
		FROM (
		SELECT DISTINCT TOP (@TOP) LINEA,
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO,
		RequiereAdjunto,MensajeAdjunto,ExplicacionPregunta,NombreAdjunto,ObservacionPresupuesto
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
						R.ObservacionPresupuesto
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
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		25/07/2017
-- Modified date:	17/01/2018
-- Description:		Obtiene el tablero para la gestión departamental de reparación colectiva
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroDepartamentoReparacionColectiva] --[PAT].[C_TableroDepartamentoReparacionColectiva] 1, 20,11001,1
	(@page SMALLINT, @pageSize SMALLINT, @IdMunicipio INT, @idTablero tinyint)	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RESULTADO TABLE (
		Medida NVARCHAR(255),
		Sujeto NVARCHAR(300),
		MedidaReparacionColectiva NVARCHAR(2000),
		Id INT,
		IdTablero TINYINT,
		IdMunicipioRespuesta INT,
		IdDepartamento INT,
		IdPreguntaReparacionColectiva SMALLINT,
		Accion NVARCHAR(2000),
		Presupuesto MONEY,
		AccionDepartamento NVARCHAR(4000),
		PresupuestoDepartamento MONEY,
		Municipio  NVARCHAR(255)
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	
	DECLARE @PAGINA INT
	SET @PAGINA = (@page - 1) * @pageSize

	

	SET @SQL = '
	SELECT DISTINCT TOP (@TOP) 
					Medida,Sujeto,MedidaReparacionColectiva,Id,IdTablero,IdMunicipioRespuesta,IdDepartamento,IdPreguntaReparacionColectiva,
					Accion,Presupuesto,AccionDepartamento,PresupuestoDepartamento,Municipio
					FROM ( 
						SELECT DISTINCT row_number() OVER (ORDER BY p.SUJETO) AS LINEA, 
							MEDIDA.Descripcion as Medida,
							p.Sujeto,
							p.MedidaReparacionColectiva,
							rcd.Id,
							p.IdTablero,
							p.IdMunicipio as IdMunicipioRespuesta,
							d.IdDepartamento, 
							p.Id as IdPreguntaReparacionColectiva,
							rc.Accion,
							rc.Presupuesto,
							rcd.AccionDepartamento,  
							rcd.PresupuestoDepartamento,
							d.Nombre as Municipio
						FROM PAT.PreguntaPATReparacionColectiva p
						INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
						INNER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id		
						INNER join Municipio as d on p.IdMunicipio =d.Id and d.Id =@IdMunicipio
						LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc on p.Id = rc.IdPreguntaPATReparacionColectiva and rc.IdMunicipio= d.Id
						LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON rcd.IdMunicipioRespuesta= d.Id and rcd.IdPreguntaPATReparacionColectiva=p.Id
						where TABLERO.Id = @idTablero and p.Activo = 1
					) AS P WHERE LINEA >@PAGINA 
					--and IdPreguntaReparacionColectiva > 2242 
					ORDER BY p.Sujeto'

		SET @PARAMETROS = '@TOP SMALLINT, @PAGINA SMALLINT, @IdMunicipio INT,@idTablero tinyint'

		PRINT @SQL
		PRINT @IdMunicipio
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @IdMunicipio= @IdMunicipio,@idTablero=@idTablero
		SELECT * from @RESULTADO
END

GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		25/07/2017
-- Modified date:	17/01/2018
-- Description:		Obtiene el tablero para la gestión departamental de retornos y reubicaciones
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroDepartamentoRetornosReubicaciones] --[PAT].[C_TableroDepartamentoRetornosReubicaciones] 1, 20,5051,3
	(@page SMALLINT, @pageSize SMALLINT, @IdMunicipio INT, @idTablero tinyint)	
AS
BEGIN
	SET NOCOUNT ON;

		DECLARE @RESULTADO TABLE (
			IdPreguntaRR SMALLINT,
			IdMunicipio INT,
			Hogares INT,
			Personas INT,
			Sector NVARCHAR(MAX),
			Componente NVARCHAR(MAX),
			Comunidad NVARCHAR(MAX),
			Ubicacion NVARCHAR(MAX),
			MedidaRetornoReubicacion NVARCHAR(MAX),
			IndicadorRetornoReubicacion NVARCHAR(MAX),
			IdDepartamento INT,
			IdTablero TINYINT,
			Accion NVARCHAR(3000),
			Presupuesto MONEY,
			IdRespuestaDepartamento INT,
			AccionDepartamento NVARCHAR(3000),
			PresupuestoDepartamento MONEY,
			EntidadResponsable nvarchar(3000)
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	
	DECLARE @PAGINA INT
	SET @PAGINA = (@page - 1) * @pageSize

	SET @SQL = 'SELECT DISTINCT TOP (@TOP) 
	IdPregunta, 	IdMunicipio,	Hogares,Personas,	Sector,Componente,Comunidad,Ubicacion,MedidaRetornoReubicacion,
	IndicadorRetornoReubicacion,	IdDepartamento,	IdTablero,	Accion,Presupuesto,	IdRespuestaDepartamento,	AccionDepartamento,PresupuestoDepartamento,EntidadResponsable
	FROM ( 
	SELECT DISTINCT row_number() OVER (ORDER BY P.Id) AS LINEA 
	,P.Id AS IdPregunta
	,P.IdMunicipio
	,P.Hogares
	,P.Personas
	,P.Sector
	,P.Componente
	,P.Comunidad
	,P.Ubicacion
	,P.MedidaRetornoReubicacion	
	,P.IndicadorRetornoReubicacion
	,p.IdDepartamento	
	,P.IdTablero	
	,R.ID
	,R.Accion
	,R.Presupuesto
	,RD.AccionDepartamento
	,RD.PresupuestoDepartamento
	,RD.Id as IdRespuestaDepartamento
	,P.EntidadResponsable
	FROM pat.PreguntaPATRetornosReubicaciones AS P
	JOIN PAT.Tablero AS T ON P.IdTablero =T.Id
	LEFT OUTER JOIN PAT.RespuestaPATRetornosReubicaciones AS R  ON P.Id = R.IdPreguntaPATRetornoReubicacion AND R.IdMunicipio = P.IdMunicipio
	LEFT OUTER JOIN PAT.RespuestaPATDepartamentoRetornosReubicaciones AS RD ON R.IdMunicipio = RD.IdMunicipioRespuesta and P.Id = RD.IdPreguntaPATRetornoReubicacion
	where T.Id = @idTablero 
	AND P.IdMunicipio =@IdMunicipio
	and P.Activo= 1
	) AS P 
	WHERE LINEA >@PAGINA 
	ORDER BY P.IdPregunta  
	'

		SET @PARAMETROS = '@TOP SMALLINT, @PAGINA SMALLINT,@idTablero tinyint, @IdMunicipio INT'

		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @idTablero= @idTablero,@IdMunicipio=@IdMunicipio
		SELECT * from @RESULTADO
END

GO
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		08/08/2016
-- Modified date:	17/01/2018
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de responsabilidad Colectiva	
-- =============================================
alter PROCEDURE [PAT].[C_TableroMunicipioRR] --'', 1, 20, 394, 'Reparación Integral'
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho INT, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		LINEA INT,
		ID_PREGUNTA_RR SMALLINT,
		ID_DANE INT,
		HOGARES SMALLINT,
		PERSONAS SMALLINT,
		SECTOR NVARCHAR(MAX),
		COMPONENTE NVARCHAR(MAX),
		COMUNIDAD NVARCHAR(MAX),
		UBICACION NVARCHAR(MAX),
		MEDIDA_RR NVARCHAR(MAX),
		INDICADOR_RR NVARCHAR(MAX),
		ENTIDAD_RESPONSABLE NVARCHAR(MAX),
		ID_TABLERO TINYINT,
		ID_ENTIDAD INT,
		ID INT,
		ACCION NVARCHAR(3000),
		PRESUPUESTO MONEY
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE @ID_ENTIDAD INT
	--DECLARE @ID_DANE INT
		
	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize

	SET @ORDEN = @sortOrder
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'ID_PREGUNTA'

	SELECT @ID_ENTIDAD=PAT.fn_GetIdEntidad(@IdUsuario)
	--SELECT @ID_DANE=[PAT].[fn_GetDaneMunicipioEntidad](@IdUsuario)
	IF  @IdDerecho = 6
	BEGIN
		SET @SQL = 'SELECT	LINEA,IDPREGUNTA,IDDANE,HOGARES,PERSONAS,SECTOR, 
							COMPONENTE, COMUNIDAD, UBICACION, MEDIDARR, INDICADORRR, 
							ENTIDADRESPONSABLE, IDTABLERO,IDENTIDAD,ID,ACCION,PRESUPUESTO 
					FROM (
							SELECT DISTINCT TOP (@TOP) LINEA,IDPREGUNTA,IDDANE,HOGARES,PERSONAS,SECTOR, 
							COMPONENTE,COMUNIDAD,UBICACION,MEDIDARR,INDICADORRR, 
							ENTIDADRESPONSABLE,IDTABLERO,IDENTIDAD,ID,ACCION,PRESUPUESTO
					FROM ( 
							SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
							P.ID AS IDPREGUNTA,
							P.[IdMunicipio] AS IDDANE,
							P.[HOGARES],
							P.[PERSONAS],
							P.[SECTOR],
							P.[COMPONENTE],
							P.[COMUNIDAD],
							P.[UBICACION],
							P.[MedidaRetornoReubicacion] AS MEDIDARR,
							P.[IndicadorRetornoReubicacion] AS INDICADORRR,
							P.[ENTIDADRESPONSABLE], 
							T.ID AS IDTABLERO,
							CASE WHEN R.IdMunicipio IS NULL THEN @ID_ENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
							R.ID,
							R.ACCION, 
							R.PRESUPUESTO
					FROM   [PAT].[PreguntaPATRetornosReubicaciones] P
					INNER JOIN [PAT].[Tablero] T ON P.[IdTablero] = T.ID
					LEFT OUTER JOIN [PAT].[RespuestaPATRetornosReubicaciones] R ON R.IdMunicipio = @ID_ENTIDAD and p.ID = R.[IdPreguntaPATRetornoReubicacion]
					WHERE  P.Activo = 1 and  T.ID = @idTablero and P.[IdMunicipio] = @ID_ENTIDAD'
		SET @SQL =@SQL +' ) AS A WHERE A.LINEA >@PAGINA ORDER BY A.LINEA ) as F'
		SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT,@idTablero tinyint,  @ID_ENTIDAD INT'

--		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero,@ID_ENTIDAD= @ID_ENTIDAD
	END
	SELECT * from @RESULTADO
END



go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - liliana Rodriguez
-- Create date:		10/07/2017
-- Modified date:	17/01/2018
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados, con las respuestas dadas por el gobernador 
-- ==========================================================================================
alter PROCEDURE [PAT].[C_TableroMunicipioTotales] -- [PAT].[C_TableroMunicipioTotales]  null, 1,100,375,6,1
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT,  @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @RESULTADO TABLE (
		ID_PREGUNTA SMALLINT,
		PREGUNTAINDICATIVA NVARCHAR(500),
		PREGUNTACOMPROMISO NVARCHAR(500),
		DERECHO NVARCHAR(50),
		COMPONENTE NVARCHAR(255),
		MEDIDA NVARCHAR(255),
		UNIDADMEDIDA NVARCHAR(100),
		IDTABLERO TINYINT,
		IDENTIDAD INT,
		TOTALNECESIDADES INT,
		TOTALCOMPROMISOS INT,
		ID INT
		)
	
	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize

	SET @ORDEN = @sortOrder
	IF @ORDEN = ''
			SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE  @IdMunicipio INT, @IDDEPARTAMENTO INT

	SELECT @IDDEPARTAMENTO = IdDepartamento , @IdMunicipio = IdMunicipio FROM USUARIO WHERE Id = @IdUsuario

	SET @SQL = 'SELECT DISTINCT TOP (@TOP) 
					IDPREGUNTA,PREGUNTAINDICATIVA,PREGUNTACOMPROMISO,
					DERECHO,COMPONENTE,MEDIDA,UNIDADMEDIDA,IDTABLERO,IDENTIDAD,TOTALNECESIDADES,TOTALCOMPROMISOS,ID
				FROM ( 
				 SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.PREGUNTAINDICATIVA, 
						P.PREGUNTACOMPROMISO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
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
						(SELECT TOP 1 RR.ID FROM [PAT].[RespuestaPAT] RR WHERE P.Id = RR.IdPreguntaPAT and RR.IdDepartamento =  @IDDEPARTAMENTO and RR.IdMunicipio is null	) AS ID
				FROM    [PAT].[PreguntaPAT] as P 
						join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT
						join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = @IDDEPARTAMENTO
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdDepartamento =  @IDDEPARTAMENTO and R.IdMunicipio is null,						
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND P.IdTablero = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1
					AND P.ApoyoDepartamental = 1 					
					AND D.ID = @IdDerecho'		
	SET @SQL = @SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY P.ID'--+ @ORDEN 	
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IdMunicipio INT,@IdDerecho INT, @IDDEPARTAMENTO int'
		
	PRINT @SQL

	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IdMunicipio=@IdMunicipio, @IdDerecho=@IdDerecho, @IDDEPARTAMENTO=@IDDEPARTAMENTO
	SELECT * from @RESULTADO
END

go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_CalculoEvaluacionSeguimientoPorMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_CalculoEvaluacionSeguimientoPorMunicipio] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez 
-- Create date:		17/10/2017
-- Modified date:	17/01/2018
-- Description:		Obtiene informacion para la evaluacion de un seguimiento
-- =============================================
alter PROC  [PAT].[C_CalculoEvaluacionSeguimientoPorMunicipio]
(	@IdTablero INT , @IdDepartamento int, @IdMunicipio int,@IdDerecho int , @IdUsuario int)
AS
BEGIN			
			select @IdMunicipio as IdMunicipio ,IdPregunta, PreguntaIndicativa,
			--datos de alcaldias--
			case when AvancePrimerSemestreAlcaldias >100 then 100 else AvancePrimerSemestreAlcaldias end AvancePrimerSemestreAlcaldias,
			case when AvancePresupuestoPrimerSemestreAlcaldias >100 then 100 else AvancePresupuestoPrimerSemestreAlcaldias end AvancePresupuestoPrimerSemestreAlcaldias,
			case when AvanceAcumuladoAlcaldias >100 then 100 else AvanceAcumuladoAlcaldias end AvanceAcumuladoAlcaldias,
			case when AvancePresupuestoAcumuladoAlcaldias >100 then 100 else AvancePresupuestoAcumuladoAlcaldias end AvancePresupuestoAcumuladoAlcaldias,
			--datos de gobernaciones--			
			case when AvancePrimerSemestreGobernaciones >100 then 100 else AvancePrimerSemestreGobernaciones end AvancePrimerSemestreGobernaciones,
			case when AvancePresupuestoPrimerSemestreGobernaciones >100 then 100 else AvancePresupuestoPrimerSemestreGobernaciones end AvancePresupuestoPrimerSemestreGobernaciones,
			case when AvanceAcumuladoGobernaciones >100 then 100 else AvanceAcumuladoGobernaciones end AvanceAcumuladoGobernaciones,
			case when AvancePresupuestoGobernaciones >100 then 100 else AvancePresupuestoGobernaciones end AvancePresupuestoGobernaciones			
			from (
				select A.Id as IdPregunta, A.PreguntaIndicativa, 
				--datos de alcaldias--
				CASE WHEN SUM(ISNULL(R.RespuestaCompromiso,0)) >0 THEN  CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),SUM(ISNULL(SA.CantidadPrimer,0)))/ SUM(ISNULL(R.RespuestaCompromiso,0)))*100 ELSE 0 END as AvancePrimerSemestreAlcaldias 
				,CASE WHEN SUM(ISNULL(R.Presupuesto,0)) >0 THEN SUM(ISNULL(SA.PresupuestoPrimer,0)) / SUM(ISNULL(R.Presupuesto,0))*100  ELSE 0 END as AvancePresupuestoPrimerSemestreAlcaldias
				,CASE WHEN SUM(ISNULL(R.RespuestaCompromiso,0)) >0 THEN CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2), SUM( ISNULL( SA.CantidadPrimer,0) + ISNULL(SA.CantidadSegundo,0))) / SUM(ISNULL(R.RespuestaCompromiso,0)))*100 ELSE 0 END as AvanceAcumuladoAlcaldias
				,CASE WHEN SUM(ISNULL(R.Presupuesto,0)) >0 THEN SUM(ISNULL(SA.PresupuestoPrimer,0) + ISNULL(SA.PresupuestoSegundo,0)) / SUM(ISNULL(R.Presupuesto,0))*100 ELSE 0 END as AvancePresupuestoAcumuladoAlcaldias
				--datos de gobernaciones--
				,CASE WHEN SUM(ISNULL(RG.RespuestaCompromiso,0)) >0 THEN  CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),SUM(ISNULL(SG.CantidadPrimer,0)))/ SUM(ISNULL(RG.RespuestaCompromiso,0)))*100 ELSE 0 END as AvancePrimerSemestreGobernaciones 
				,CASE WHEN SUM(ISNULL(RG.Presupuesto,0)) >0 THEN SUM(ISNULL(SG.PresupuestoPrimer,0)) / SUM(ISNULL(RG.Presupuesto,0))*100 ELSE 0 END as AvancePresupuestoPrimerSemestreGobernaciones
				,CASE WHEN SUM(ISNULL(RG.RespuestaCompromiso,0)) >0 THEN CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2), SUM( ISNULL( SG.CantidadPrimer,0) + ISNULL(SG.CantidadSegundo,0))) / SUM(ISNULL(RG.RespuestaCompromiso,0)))*100 ELSE 0 END as AvanceAcumuladoGobernaciones
				,CASE WHEN SUM(ISNULL(RG.Presupuesto,0)) >0 THEN SUM(ISNULL(SG.PresupuestoPrimer,0) + ISNULL(SG.PresupuestoSegundo,0)) / SUM(ISNULL(RG.Presupuesto,0))*100 ELSE 0 END as AvancePresupuestoGobernaciones
				FROM [PAT].PreguntaPAT as A		
				left outer join PAT.RespuestaPAT as R on A.Id = R.IdPreguntaPAT 
				left outer join PAT.RespuestaPATDepartamento as RG on A.Id = RG.IdPreguntaPAT AND RG.IdMunicipioRespuesta = R.IdMunicipio 
				left outer join PAT.Seguimiento as SA on A.Id = SA.IdPregunta  and SA.IdUsuario = R.IdUsuario --usuario alcaldia 
				LEFT OUTER JOIN PAT.SeguimientoGobernacion as SG on A.Id = SG.IdPregunta and SG.IdUsuarioAlcaldia = SA.IdUsuario					
				where A.Nivel = 3  and A.IdTablero = @IdTablero and A.IdDerecho = @IdDerecho and R.IdMunicipio = @IdMunicipio and  R.IdDepartamento = @IdDepartamento
				group by A.Id, A.PreguntaIndicativa			
			) as A
			order by A.PreguntaIndicativa			
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_EvaluacionSeguimiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_EvaluacionSeguimiento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez 
-- Create date:		17/10/2017
-- Modified date:	17/01/2018
-- Description:		Obtiene informacion para la evaluacion de un seguimiento
-- =============================================
ALTER PROC  [PAT].[C_EvaluacionSeguimiento] -- [PAT].[C_EvaluacionSeguimiento] 1, 11,11001,1, 375
(	@IdTablero INT , @IdDepartamento int, @IdMunicipio int,@IdDerecho int , @IdUsuario int)
AS
BEGIN			
	
		declare @cantidadMunicipios int
		declare @IdMun int		

		declare @MunicipiosDepartamento table (
					IdMunicipio int,
					procesado bit
		)
		declare @ResultadosMunicipio table (
			IdMunicipio int,
			IdPregunta int,
			PreguntaIndicativa varchar(500),
			AvancePrimerSemestreAlcaldias decimal,
			AvancePresupuestoPrimerSemestreAlcaldias money,
			AvanceAcumuladoAlcaldias decimal,
			AvancePresupuestoAcumuladoAlcaldias money,
			AvancePrimerSemestreGobernaciones decimal,
			AvancePresupuestoPrimerSemestreGobernaciones money,
			AvanceAcumuladoGobernaciones decimal,
			AvancePresupuestoGobernaciones money
		)

		if (@IdMunicipio > 0)
		BEGIN 
			--Si es un municipio:
			--Seguimiento Primer Semestre:(Avance Presupuesto Primer Semestre/ Presupuesto)
			--Seguimiento Acumulado Anual:(Avance Compromisos Acumulado Anual/ Compromisos)	

			EXEC  [PAT].[C_CalculoEvaluacionSeguimientoPorMunicipio] @IdTablero =@IdTablero , @IdDepartamento =@IdDepartamento, @IdMunicipio =@IdMunicipio,@IdDerecho =@IdDerecho , @IdUsuario =@IdUsuario
		end
		else	
		BEGIN
			if (@IdDepartamento > 0)
			BEGIN 
				--Si es para un departamento:
				--Seguimiento Primer Semestre:(Promedio de los promedios S1) Sumatoria de los %S1 / cantidad de municipios
				--Seguimiento Acumulado Anual:(Promedio de los promedios S1 + S2) Sumatoria de los %Acumulados +  / cantidad de municipios
				
				select @cantidadMunicipios = COUNT(1) from Municipio where IdDepartamento = @IdDepartamento
				
				insert into @MunicipiosDepartamento
				select Id,0 from Municipio where IdDepartamento = @IdDepartamento

				while (select COUNT (1) from @MunicipiosDepartamento where procesado = 0 ) > 0
				begin 
					-- se toma uno a uno los municipios para calcuar los porcentajes e insertarlos a la tabla temporal
					select top 1 @IdMun = IdMunicipio from @MunicipiosDepartamento where procesado = 0
					
					insert into @ResultadosMunicipio
					EXEC  [PAT].[C_CalculoEvaluacionSeguimientoPorMunicipio] @IdTablero =@IdTablero , @IdDepartamento =@IdDepartamento, @IdMunicipio =@IdMun,@IdDerecho =@IdDerecho , @IdUsuario =@IdUsuario
										
					update @MunicipiosDepartamento set procesado = 1 where IdMunicipio = @IdMun
				end

				--datos de alcaldias--
				select IdPregunta, PreguntaIndicativa, 
				sum(AvancePrimerSemestreAlcaldias)/@cantidadMunicipios as  AvancePrimerSemestreAlcaldias,
				sum(AvancePresupuestoPrimerSemestreAlcaldias)/@cantidadMunicipios as  AvancePresupuestoPrimerSemestreAlcaldias,
				sum(AvanceAcumuladoAlcaldias)/@cantidadMunicipios as  AvanceAcumuladoAlcaldias,
				sum(AvancePresupuestoAcumuladoAlcaldias)/@cantidadMunicipios as  AvancePresupuestoAcumuladoAlcaldias,
				--datos de gobernaciones--
				sum(AvancePrimerSemestreGobernaciones)/@cantidadMunicipios as  AvancePrimerSemestreGobernaciones,
				sum(AvancePresupuestoPrimerSemestreGobernaciones)/@cantidadMunicipios as  AvancePresupuestoPrimerSemestreGobernaciones,
				sum(AvanceAcumuladoGobernaciones)/@cantidadMunicipios as  AvanceAcumuladoGobernaciones,
				sum(AvancePresupuestoGobernaciones)/@cantidadMunicipios as  AvancePresupuestoGobernaciones
				from @ResultadosMunicipio		
				group by IdPregunta, PreguntaIndicativa		
				order by PreguntaIndicativa			
			end
			else	
			BEGIN
				--nacion
				--Si es para todo el pais :
				--Seguimiento Primer Semestre:(Promedio de los promedios S1) Sumatoria de los %S1 / cantidad de municipios
				--Seguimiento Acumulado Anual:(Promedio de los promedios S1 + S2) Sumatoria de los %Acumulados +  / cantidad de municipios
						
				select @cantidadMunicipios = COUNT(1) from Municipio 
				
				insert into @MunicipiosDepartamento
				select Id,0 from Municipio

				while (select COUNT (1) from @MunicipiosDepartamento where procesado = 0 ) > 0
				begin 
					-- se toma uno a uno los municipios para calcuar los porcentajes e insertarlos a la tabla temporal
					select top 1 @IdMun = IdMunicipio from @MunicipiosDepartamento where procesado = 0
					declare @IdDep int
					select @IdDep = IdDepartamento from Municipio where Id = @IdMun
					insert into @ResultadosMunicipio
					EXEC  [PAT].[C_CalculoEvaluacionSeguimientoPorMunicipio] @IdTablero =@IdTablero , @IdDepartamento =@IdDep, @IdMunicipio =@IdMun,@IdDerecho =@IdDerecho , @IdUsuario =@IdUsuario
					update @MunicipiosDepartamento set procesado = 1 where IdMunicipio = @IdMun
				end

				--datos de alcaldias--
				select IdPregunta, PreguntaIndicativa, 
				sum(AvancePrimerSemestreAlcaldias)/@cantidadMunicipios as  AvancePrimerSemestreAlcaldias,
				sum(AvancePresupuestoPrimerSemestreAlcaldias)/@cantidadMunicipios as  AvancePresupuestoPrimerSemestreAlcaldias,
				sum(AvanceAcumuladoAlcaldias)/@cantidadMunicipios as  AvanceAcumuladoAlcaldias,
				sum(AvancePresupuestoAcumuladoAlcaldias)/@cantidadMunicipios as  AvancePresupuestoAcumuladoAlcaldias,
				--datos de gobernaciones--
				sum(AvancePrimerSemestreGobernaciones)/@cantidadMunicipios as  AvancePrimerSemestreGobernaciones,
				sum(AvancePresupuestoPrimerSemestreGobernaciones)/@cantidadMunicipios as  AvancePresupuestoPrimerSemestreGobernaciones,
				sum(AvanceAcumuladoGobernaciones)/@cantidadMunicipios as  AvanceAcumuladoGobernaciones,
				sum(AvancePresupuestoGobernaciones)/@cantidadMunicipios as  AvancePresupuestoGobernaciones
				from @ResultadosMunicipio		
				group by IdPregunta, PreguntaIndicativa		
				order by PreguntaIndicativa			
			end	
		end
END

go