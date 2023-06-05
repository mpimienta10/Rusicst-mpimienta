-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - liliana Rodriguez
-- Create date:		10/07/2017
-- Modified date:	22/01/2018
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados, con las respuestas dadas por el gobernador 
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroMunicipioTotales] -- [PAT].[C_TableroMunicipioTotales]  null, 1,100,375,1,4
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
		ID INT
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
TOTALNECESIDADES,TOTALCOMPROMISOS,TOTALPRESUPUESTO,TOTALCOMPROMISOGOBERNACION,TOTALPRESUPUESTOGOBERNACION  ,IDRESPUESTA
FROM (
	SELECT LINEA,ID_PREGUNTA,PREGUNTAINDICATIVA,
	D.DESCRIPCION AS DERECHO, 
	C.DESCRIPCION AS COMPONENTE, 
	M.DESCRIPCION AS MEDIDA, 
	UM.DESCRIPCION AS UNIDADMEDIDA,	
	T.ID AS IDTABLERO,
	TOTALNECESIDADES,TOTALCOMPROMISOS,TOTALPRESUPUESTO,TOTALCOMPROMISOGOBERNACION,TOTALPRESUPUESTOGOBERNACION ,IDRESPUESTA 
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


-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene los porcentajes de avance de la gestión del tablero PAT por municipio
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroMunicipioAvance] --[PAT].[C_TableroMunicipioAvance] 411,2
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
			SUM(case when R.RESPUESTACOMPROMISO IS NULL then 0 else 1 end)*100/count(*) PCOMPROMISO
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

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene los totales de necesidades y compromisos departamentales del tablero PAT
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroDepartamentoAvance]--  [PAT].[C_TableroDepartamentoAvance] 375,3
		@IdUsuario INT, @idTablero tinyint
AS
BEGIN
	SET NOCOUNT ON;	
	DECLARE @NIVEL INT = 3
	DECLARE  @IdDepartamento INT
	SELECT  @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	SELECT	D.Descripcion AS DERECHO, 
			--SUM(case when R.RespuestaIndicativa IS NULL or R.RespuestaIndicativa=0 then 0 else 1 end)*100/count(*) PINDICATIVA,
			--SUM(case when R.RespuestaCompromiso IS NULL or R.RespuestaCompromiso=0 then 0 else 1 end)*100/count(*) PCOMPROMISO
			SUM(case when R.RespuestaIndicativa IS NULL then 0 else R.RespuestaIndicativa end) PINDICATIVA,
			SUM(case when R.RespuestaCompromiso IS NULL then 0 else RespuestaCompromiso end) PCOMPROMISO
	FROM    [PAT].[PreguntaPAT] (NOLOCK) AS P
	--join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT
	--join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = @IdDepartamento						
	INNER JOIN [PAT].[Derecho] (NOLOCK) D ON P.IDDERECHO = D.ID 
	INNER JOIN PAT.Tablero (NOLOCK) AS T ON P.IDTABLERO = T.ID				
	LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON R.IdDepartamento = @IdDepartamento  and P.ID = R.[IdPreguntaPAT]
	WHERE	P.NIVEL = @NIVEL 
	AND T.ID = @idTablero
	and P.ACTIVO = 1	
	group by D.DESCRIPCION
END

go