if exists (select object_id from sys.all_objects where name ='C_DatosExcel_Gobernaciones')
DROP PROCEDURE [PAT].[C_DatosExcel_Gobernaciones]
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		21/07/2017
-- Modified date:	21/07/2017
-- Description:		Obtiene toda la informacion correspondiente a la gobernbacion  y tablero indicando en cuento a las respuestas que estos diligenciaron
-- ==========================================================================================

CREATE PROC [PAT].[C_DatosExcel_Gobernaciones] -- [PAT].[SP_GetDatosExcel_Gob] --506 --[PAT].[C_DatosExcel_Gobernaciones] 11001,1
(
	@IdMunicipio INT, @IdTablero INT
)
AS
BEGIN

SELECT 
DISTINCT  
IDPREGUNTA AS ID
, '' AS ENTIDAD
,DERECHO
,COMPONENTE
,MEDIDA
,PREGUNTAINDICATIVA
,PREGUNTACOMPROMISO
,UNIDADMEDIDA
,RESPUESTAINDICATIVA
,OBSERVACIONNECESIDAD
,RESPUESTACOMPROMISO
,ACCIONCOMPROMISO AS OBSERVACIONCOMPROMISO
,CONVERT(FLOAT, PRESUPUESTO) AS PRESUPUESTO
,ACCION
,PROGRAMA

	FROM ( 
    SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
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
						R.ID AS IDTABLERO,						
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID as id_respuesta,
						R.RESPUESTAINDICATIVA, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO
						,AA.ACCION
						,AP.PROGRAMA
				FROM    [PAT].[PreguntaPAT] AS P
				INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
				INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
				INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
				INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
				INNER JOIN PAT.Tablero AS T ON P.IDTABLERO = T.ID
				LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] and  R.IdMunicipio = @IdMunicipio 									
				LEFT OUTER JOIN [PAT].[RespuestaPATAccion] AS AA ON AA.[IdRespuestaPAT] = R.ID and AA.Activo = 1
				LEFT OUTER JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
				INNER JOIN Usuario AS U ON R.IdUsuario = U.Id  AND U.IdMunicipio = @IdMunicipio
				WHERE  T.ID = @IdTablero and
				P.NIVEL = 2 AND 1=pat.ValidarPreguntaRyR(P.IDMEDIDA,@IdMunicipio) ) AS A WHERE A.ACTIVO = 1  ORDER BY IDPREGUNTA


END

GO
if exists (select object_id from sys.all_objects where name ='C_DatosExcel_Gobernaciones_municipios')
DROP PROCEDURE [PAT].[C_DatosExcel_Gobernaciones_municipios]
go

-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		21/07/2017
-- Modified date:	21/07/2017
-- Description:		Obtiene toda la informacion del municipio y gobernacion del tablero indicando en cuento a lo diligenciado
-- ==========================================================================================

CREATE PROC [PAT].[C_DatosExcel_Gobernaciones_municipios] -- [PAT].[SP_GetDatosExcel_Gob_Mpios] --1013 --[PAT].[C_DatosExcel_Gobernaciones_municipios] 1513,2
(
	@IdUsuario INT, @IdTablero INT
)
AS
BEGIN

	Declare @IdMunicipio int, @IdDepartamento int, @Departamento VARCHAR(100)
	
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	select @Departamento = Nombre from Departamento where  Id = @IdDepartamento

    SELECT DISTINCT
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
					T.Id AS IDTABLERO,						
					MR.Id  AS IDMUNICIPIO,
					R.ID as IDRESPUESTA,
					R.RESPUESTAINDICATIVA, 
					R.RESPUESTACOMPROMISO, 
					R.PRESUPUESTO,
					R.OBSERVACIONNECESIDAD,
					R.ACCIONCOMPROMISO					
					,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
					FROM PAT.RespuestaPATAccion AS ACCION
					WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ACCION					
					,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
					FROM [PAT].[RespuestaPATPrograma] AS PROGRAMA
					WHERE R.Id =PROGRAMA.IdRespuestaPAT  AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS PROGRAMA							
					,@Departamento AS DEPTO
					,MR.Nombre AS MPIO
					,DEP.Id AS IDRESPUESTADEP
					,DEP.RespuestaCompromiso AS RESPUESTA_DEP_COMPROMISO
					,DEP.ObservacionCompromiso as  RESPUESTA_DEP_OBSERVACION 
					,DEP.Presupuesto AS RESPUESTA_DEP_PRESUPUESTO				
					,STUFF((SELECT CAST( ACCIONDEP.Accion  AS VARCHAR(MAX)) + ' / ' 
					FROM PAT.RespuestaPATAccion AS ACCIONDEP
					WHERE DEP.Id = ACCIONDEP.IdRespuestaPAT AND ACCIONDEP.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ACCION_DEPTO
					,STUFF((SELECT CAST( PROGRAMADEP.Programa  AS VARCHAR(MAX)) + ' / ' 
					FROM [PAT].[RespuestaPATPrograma] AS PROGRAMADEP
					WHERE DEP.Id = PROGRAMADEP.IdRespuestaPAT AND PROGRAMADEP.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS PROGRAMA_DEPTO	
				FROM    [PAT].[PreguntaPAT] AS P
				INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
				INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
				INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
				INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
				INNER JOIN [PAT].Tablero AS T ON P.IDTABLERO = T.ID
				LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT]  
				LEFT OUTER JOIN Municipio AS MR ON R.IdMunicipio = MR.Id AND MR.IdDepartamento = @IdDepartamento											
				LEFT OUTER JOIN [PAT].RespuestaPATDepartamento DEP ON R.IdPreguntaPAT = DEP.IdPreguntaPAT and R.IdMunicipio = DEP.IdMunicipioRespuesta 	
				LEFT OUTER JOIN Municipio AS MRDEP ON DEP.IdMunicipioRespuesta = MRDEP.Id AND MRDEP.IdDepartamento = @IdDepartamento																																
				LEFT OUTER JOIN [PAT].[RespuestaPAT] as RDEP on P.ID = RDEP.[IdPreguntaPAT] and  R.IdMunicipio = @IdMunicipio 									
				WHERE  T.ID = @IdTablero and  P.NIVEL = 3 and MR.IdDepartamento = @IdDepartamento
				and P.ACTIVO = 1  ORDER BY DEPTO, MPIO, IDPREGUNTA
END

GO
if exists (select object_id from sys.all_objects where name ='C_DatosExcel_GobernacionesReparacionColectiva')
DROP PROCEDURE [PAT].[C_DatosExcel_GobernacionesReparacionColectiva]
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		21/07/2017
-- Modified date:	21/07/2017
-- Description:		Obtiene toda la informacion correspondiente a la gobernbacion para reparacion colectiva  y tablero indicando en cuento a las respuestas que estos diligenciaron
-- ==========================================================================================

CREATE PROC [PAT].[C_DatosExcel_GobernacionesReparacionColectiva] --[PAT].[C_DatosExcel_GobernacionesReparacionColectiva] 1513, 2
(	@IdUsuario INT, @IdTablero INT)
AS
BEGIN	

	Declare @IdMunicipio int, @IdDepartamento int, @Departamento VARCHAR(100)
	
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario				
	
	select distinct MEDIDA.Descripcion as Medida,
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
			d.Id as IdDane,
			d.Nombre as Municipio
		FROM PAT.PreguntaPATReparacionColectiva p
		INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
		INNER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id		
		INNER join Municipio as d on p.IdMunicipio =d.Id and d.Id =@IdMunicipio
		LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc on p.Id = rc.IdPreguntaPATReparacionColectiva and rc.IdMunicipio= p.IdMunicipio
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON rcd.IdMunicipioRespuesta= d.Id and rcd.IdPreguntaPATReparacionColectiva=p.Id
		where TABLERO.Id = @IdTablero
		order by Sujeto																

END

GO
if exists (select object_id from sys.all_objects where name ='C_DatosExcel_GobernacionesRetornosReubicaciones')
DROP PROCEDURE [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones]
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		21/07/2017
-- Modified date:	21/07/2017
-- Description:		Obtiene toda la informacion correspondiente a la gobernbacion para retornos y reubicaciones  para el tablero indicando en cuento a las respuestas que estos diligenciaron
-- ==========================================================================================

CREATE PROC [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones] --  [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones] 1513 , 2
(	@IdUsuario INT, @IdTablero INT)
AS
BEGIN

	Declare @IdMunicipio int, @IdDepartamento int, @Departamento VARCHAR(100)
	
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario		

	SELECT DISTINCT 
		P.Id AS IdPregunta
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
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoRetornosReubicaciones AS RD ON R.IdMunicipio = RD.IdMunicipioRespuesta
		where T.Id = @idTablero 
		AND P.IdMunicipio =@IdMunicipio
		order by P.Id

END


GO
if exists (select object_id from sys.all_objects where name ='C_EntidadesConRespuestaMunicipal')
DROP PROCEDURE [PAT].[C_EntidadesConRespuestaMunicipal]
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		21/07/2017
-- Modified date:	21/07/2017
-- Description:		Obtiene toda la informacion que tiene diligenciamiento municipal y departamental
-- ==========================================================================================
CREATE PROC [PAT].[C_EntidadesConRespuestaMunicipal]
AS
BEGIN

	SELECT distinct 
	U.UserName as Entidad,
	TU.Nombre as TipoUsuario, 
	D.Nombre as Departamento, M.Nombre as Municipio, A.IdMunicipio    
	FROM PAT.RespuestaPAT AS A
	INNER JOIN dbo.Municipio as M on A.IdMunicipio = M.id
	INNER JOIN dbo.Departamento as D on M.IdDepartamento = D.Id
	JOIN dbo.Usuario as U on A.IdUsuario = U.Id
	JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
	order by 3,1
END



GO
if exists (select object_id from sys.all_objects where name ='C_MunicipiosReparacionColectiva')
DROP PROCEDURE [PAT].[C_MunicipiosReparacionColectiva]
GO

-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Procedimiento que retorna los municipios de reparación colectiva  de acuerdo al departamento del usuario y tablero indicado.
-- =============================================
CREATE PROCEDURE [PAT].[C_MunicipiosReparacionColectiva]--[PAT].[C_MunicipiosReparacionColectiva] 1315 
	@IdUsuario INT,  @idTablero tinyint
AS
BEGIN

	declare @IdDepartamento int
	select @IdDepartamento = IdDepartamento	 from Usuario where Id = @IdUsuario	
	SELECT distinct
	m.Id,
	m.Nombre as Municipio
	FROM  pat.PreguntaPATReparacionColectiva as p
	INNER JOIN Municipio as m on p.IdMunicipio = m.id
	WHERE m.IdDepartamento = @IdDepartamento and p.IdTablero = @idTablero
	order by m.Nombre	
END



GO
if exists (select object_id from sys.all_objects where name ='C_MunicipiosRetornosReubicaciones')
DROP PROCEDURE [PAT].[C_MunicipiosRetornosReubicaciones]
GO


-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Procedimiento que retorna los municipios de retornos y reubicaciones de acuerdo al departamento del usuario y tablero indicado.
-- =============================================
CREATE PROCEDURE [PAT].[C_MunicipiosRetornosReubicaciones]--[PAT].[C_MunicipiosRetornosReubicaciones] 1315 
	@IdUsuario INT ,@idTablero tinyint
AS
BEGIN

	declare @IdDepartamento int
	select @IdDepartamento = IdDepartamento	 from Usuario where Id = @IdUsuario	
	SELECT distinct
	m.Id,
	m.Nombre as Municipio
	FROM  pat.PreguntaPATRetornosReubicaciones as p
	INNER JOIN Municipio as m on p.IdMunicipio = m.id
	WHERE m.IdDepartamento = @IdDepartamento and p.IdTablero = @idTablero
	order by m.Nombre	
END


GO
if exists (select object_id from sys.all_objects where name ='C_PreguntasPat')
DROP PROCEDURE [PAT].[C_PreguntasPat]
GO
-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	21/07/2017
-- Description:		Obtiene las preguntas del PAT para la rejilla
-- =============================================
create PROCEDURE [PAT].[C_PreguntasPat] 
AS
BEGIN
	SET NOCOUNT ON;	
		SELECT P.Id,
		P.IdDerecho, P.IdComponente, P.IdMedida, 
		M.Descripcion as Medida,
		P.PreguntaIndicativa, 
		UM.Descripcion as UnidadMedida,
		P.PreguntaCompromiso, 
		d.Descripcion as Derecho, 
		C.Descripcion as Componente,
		P.Nivel, 
		P.IdTablero,
		P.Activo,				
		P.IdUnidadMedida, 
		P.ApoyoDepartamental, 
		P.ApoyoEntidadNacional		
		FROM    [PAT].[PreguntaPAT] as P, 
		[PAT].[Derecho] D,
		[PAT].[Componente] C,
		[PAT].[Medida] M,
		[PAT].[UnidadMedida] UM
		WHERE P.IDDERECHO = D.ID 
		AND P.IDCOMPONENTE = C.ID 
		AND P.IDMEDIDA = M.ID 
		AND P.IDUNIDADMEDIDA = UM.ID 	
END

GO
if exists (select object_id from sys.all_objects where name ='C_TableroDepartamentoReparacionColectiva')
DROP PROCEDURE [PAT].[C_TableroDepartamentoReparacionColectiva]
GO

-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Obtiene el tablero para la gestión departamental de reparación colectiva
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroDepartamentoReparacionColectiva] --[PAT].[C_TableroDepartamentoReparacionColectiva] 1, 20,11001,1
	(@page SMALLINT, @pageSize SMALLINT, @IdMunicipio INT, @idTablero tinyint)	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RESULTADO TABLE (
		Medida NVARCHAR(50),
		Sujeto NVARCHAR(300),
		MedidaReparacionColectiva NVARCHAR(2000),
		Id INT,
		IdTablero TINYINT,
		IdMunicipioRespuesta INT,
		IdDepartamento INT,
		IdPreguntaReparacionColectiva SMALLINT,
		Accion NVARCHAR(1000),
		Presupuesto MONEY,
		AccionDepartamento NVARCHAR(1000),
		PresupuestoDepartamento MONEY,
		Municipio  NVARCHAR(100)
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
						where TABLERO.Id = @idTablero
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
if exists (select object_id from sys.all_objects where name ='C_TableroDepartamentoRetornosReubicaciones')
DROP PROCEDURE [PAT].[C_TableroDepartamentoRetornosReubicaciones]
GO
-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Obtiene el tablero para la gestión departamental de retornos y reubicaciones
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroDepartamentoRetornosReubicaciones] --[PAT].[C_TableroDepartamentoRetornosReubicaciones] 1, 20,11001,2
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
			Accion NVARCHAR(1000),
			Presupuesto MONEY,
			IdRespuestaDepartamento INT,
			AccionDepartamento NVARCHAR(1000),
			PresupuestoDepartamento MONEY,
			EntidadResponsable nvarchar(1000)
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	
	DECLARE @PAGINA INT
	SET @PAGINA = (@page - 1) * @pageSize

	SET @SQL = 'SELECT DISTINCT TOP (20) 
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
	LEFT OUTER JOIN PAT.RespuestaPATDepartamentoRetornosReubicaciones AS RD ON R.IdMunicipio = RD.IdMunicipioRespuesta
	where T.Id = @idTablero 
	AND P.IdMunicipio =@IdMunicipio
	) AS P 
	--WHERE LINEA >@PAGINA 
	ORDER BY P.IdPregunta  
	'

		SET @PARAMETROS = '@TOP SMALLINT, @PAGINA SMALLINT,@idTablero tinyint, @IdMunicipio INT'

		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @idTablero= @idTablero,@IdMunicipio=@IdMunicipio
		SELECT * from @RESULTADO
END




GO
if exists (select object_id from sys.all_objects where name ='C_TodasUnidadesMedida')
DROP PROCEDURE [PAT].[C_TodasUnidadesMedida]
GO
-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Obtiene todas las unidades de medida activas
-- =============================================

create PROC [PAT].[C_TodasUnidadesMedida] 
AS
BEGIN
	SELECT u.Id, u.Descripcion
	FROM  [PAT].UnidadMedida u
	where u.Activo = 1
	ORDER BY u.Descripcion
END


go
if exists (select object_id from sys.all_objects where name ='C_TodosComponentes')
DROP PROCEDURE [PAT].[C_TodosComponentes]
go
-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Obtiene todos los componentes activos
-- =============================================
create PROC [PAT].[C_TodosComponentes] 
AS
BEGIN
	SELECT  C.Id, C.Descripcion
	FROM  [PAT].Componente as C
	WHERE Activo = 1
	ORDER BY C.Descripcion	
END
go
if exists (select object_id from sys.all_objects where name ='C_TodosDerechos')
DROP PROCEDURE [PAT].[C_TodosDerechos]
go
-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Obtiene todos los derechos activos
-- =============================================
create PROC [PAT].[C_TodosDerechos] 
AS
BEGIN
	SELECT  D.Id, D.Descripcion
	FROM  [PAT].[Derecho] D
	ORDER BY D.Descripcion
END
go
if exists (select object_id from sys.all_objects where name ='U_RespuestaDepartamentoRRUpdate')
DROP PROCEDURE [PAT].[U_RespuestaDepartamentoRRUpdate]
go
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-27																			  
/Descripcion: Actualiza la información del tablero para Retornos y reubicaciones												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[U_RespuestaDepartamentoRRUpdate] 
		@Id int,
	    @AccionDepartamento nvarchar(1000),
		@PresupuestoDepartamento money
	AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
	declare @idRespuesta int
	select @idRespuesta = r.ID from [PAT].RespuestaPATDepartamentoRetornosReubicaciones as r
	where r.Id =  @Id
		
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY	
			UPDATE [PAT].[RespuestaPATDepartamentoRetornosReubicaciones]
			SET [AccionDepartamento] = @AccionDepartamento ,[PresupuestoDepartamento] = @PresupuestoDepartamento      
			WHERE  Id = @Id

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end
	select @respuesta as respuesta, @estadoRespuesta as estado		
GO
if exists (select object_id from sys.all_objects where name ='U_RespuestaDepartamentoRCUpdate')
DROP PROCEDURE [PAT].[U_RespuestaDepartamentoRCUpdate]
go
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-27																			  
/Descripcion: Actualiza la información del tablero para Reparacion colectiva												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[U_RespuestaDepartamentoRCUpdate] 
		@Id int,
		@AccionDepartamento nvarchar(1000),
		@PresupuestoDepartamento money
	AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
	declare @idRespuesta int
	select @idRespuesta = r.ID from [PAT].[RespuestaPATDepartamentoReparacionColectiva] as r
	where r.Id =  @Id
		
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
		
		UPDATE [PAT].[RespuestaPATDepartamentoReparacionColectiva]
		SET AccionDepartamento= @AccionDepartamento,PresupuestoDepartamento=@PresupuestoDepartamento
		WHERE  Id = @Id

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end
	select @respuesta as respuesta, @estadoRespuesta as estado			
GO
if exists (select object_id from sys.all_objects where name ='I_RespuestaDepartamentoRRInsert')
DROP PROCEDURE [PAT].[I_RespuestaDepartamentoRRInsert]
go

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-25																			  
/Descripcion: Inserta la información del tablero municipal para Retornos y reubicaciones												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[I_RespuestaDepartamentoRRInsert] 
			   @IdTablero tinyint,			
			   @IdPreguntaPATRetornoReubicacion smallint,
			   @AccionDepartamento nvarchar(1000),
			   @PresupuestoDepartamento money,
			   @IdMunicipioRespuesta int,
			   @IdUsuario int			   				 
AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	
	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY

		INSERT INTO [PAT].[RespuestaPATDepartamentoRetornosReubicaciones]
			   ([IdTablero]			  
			   ,[IdPreguntaPATRetornoReubicacion]
			   ,[AccionDepartamento]
			   ,[PresupuestoDepartamento]
			   ,[IdMunicipioRespuesta]
			   ,[IdUsuario]
			   ,[FechaInsercion])
		 VALUES ( 
			   @IdTablero ,			  
			   @IdPreguntaPATRetornoReubicacion ,
			   @AccionDepartamento ,
			   @PresupuestoDepartamento ,
			   @IdMunicipioRespuesta ,
			   @IdUsuario ,
			   getdate())

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

if exists (select object_id from sys.all_objects where name ='I_RespuestaDepartamentoRCInsert')
DROP PROCEDURE [PAT].[I_RespuestaDepartamentoRCInsert]
go
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-25																			  
/Descripcion: Inserta la información del tablero municipal para Reparacion colectiva												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaDepartamentoRCInsert] 
				   @IdTablero tinyint,
				   @IdPreguntaPATReparacionColectiva smallint,
				   @AccionDepartamento nvarchar(1000),
				   @PresupuestoDepartamento money,
				   @IdMunicipioRespuesta int,
				   @IdUsuario int			
AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	
	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY
			INSERT INTO [PAT].[RespuestaPATDepartamentoReparacionColectiva]
			   ([IdTablero]
			   ,[IdPreguntaPATReparacionColectiva]
			   ,[AccionDepartamento]
			   ,[PresupuestoDepartamento]
			   ,[IdMunicipioRespuesta]
			   ,[IdUsuario]
			   ,[FechaInsercion])
			 VALUES (
				@IdTablero 
				,@IdPreguntaPATReparacionColectiva 
				,@AccionDepartamento 
				,@PresupuestoDepartamento 
				,@IdMunicipioRespuesta
				,@IdUsuario
				,getdate()
				)

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

if exists (select object_id from sys.all_objects where name ='I_PreguntaPatInsert')
DROP PROCEDURE [PAT].[I_PreguntaPatInsert]
go
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-29																			  
/Descripcion: Inserta la información del tablero municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[I_PreguntaPatInsert] 
					   @IdDerecho smallint,
					   @IdComponente int,
					   @IdMedida int,
					   @Nivel tinyint,
					   @PreguntaIndicativa nvarchar(500),
					   @IdUnidadMedida tinyint,
					   @PreguntaCompromiso nvarchar(500),
					   @ApoyoDepartamental bit,
					   @ApoyoEntidadNacional bit,
					   @Activo bit,
					   @IdTablero tinyint
			
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY
			INSERT INTO [PAT].[PreguntaPAT]
					   ([IdDerecho]
					   ,[IdComponente]
					   ,[IdMedida]
					   ,[Nivel]
					   ,[PreguntaIndicativa]
					   ,[IdUnidadMedida]
					   ,[PreguntaCompromiso]
					   ,[ApoyoDepartamental]
					   ,[ApoyoEntidadNacional]
					   ,[Activo]
					   ,[IdTablero])
				 VALUES
					   (@IdDerecho ,
					   @IdComponente ,
					   @IdMedida ,
					   @Nivel ,
					   @PreguntaIndicativa ,
					   @IdUnidadMedida ,
					   @PreguntaCompromiso,
					   @ApoyoDepartamental ,
					   @ApoyoEntidadNacional ,
					   @Activo ,
					   @IdTablero )

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

if exists (select object_id from sys.all_objects where name ='U_PreguntaPatUpdate')
DROP PROCEDURE [PAT].[U_PreguntaPatUpdate]
go
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-29																			  
/Descripcion: Actualiza la información de las preguntas 
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[U_PreguntaPatUpdate] 
		@Id int,
		@IdDerecho smallint,
		@IdComponente int,
		@IdMedida int,
		@Nivel tinyint,
		@PreguntaIndicativa nvarchar(500),
		@IdUnidadMedida tinyint,
		@PreguntaCompromiso nvarchar(500),
		@ApoyoDepartamental bit,
		@ApoyoEntidadNacional bit,
		@Activo bit,
		@IdTablero tinyint
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	declare @idPregunta int

	select @idPregunta = r.ID from [PAT].PreguntaPAT as r
	where r.Id = @Id 
	order by r.ID
	if (@idPregunta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end
	declare @IdTableroActual int
	declare @IdRespuesta int
	declare @IdRespuestaDept int

	select @IdTableroActual =IdTablero from [PAT].PreguntaPAT where Id = @Id  

	if ( @IdTablero <> @IdTableroActual)
	begin
		select top 1 @IdRespuesta = Id from [PAT].[RespuestaPAT] where [IdPreguntaPAT] =@Id  
		select top 1 @IdRespuestaDept = Id from [PAT].[RespuestaPATDepartamento] where [IdPreguntaPAT] =@Id  
		
		if (@IdRespuesta >0 or @IdRespuestaDept >0)
		begin
			set @esValido = 0
			set @respuesta += 'No se puede cambiar el tablero ya se se encuentran respuestas asociadas.\n'
		end
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY

		UPDATE [PAT].PreguntaPAT
		    SET 
			IdDerecho =@IdDerecho,
			IdComponente =@IdComponente,
			IdMedida =@IdMedida,
			Nivel= @Nivel,
			PreguntaIndicativa =@PreguntaIndicativa,
			IdUnidadMedida =@IdUnidadMedida,
			PreguntaCompromiso= @PreguntaCompromiso,
			ApoyoDepartamental =@ApoyoDepartamental,
			ApoyoEntidadNacional= @ApoyoEntidadNacional,
			Activo= @Activo,
			IdTablero= @IdTablero
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
if exists (select object_id from sys.all_objects where name ='C_TodosTableros')
DROP PROCEDURE [PAT].[C_TodosTableros]
go
create PROC [PAT].[C_TodosTableros] 
AS
BEGIN
	select	A.[Id],	A.VigenciaInicio, A.VigenciaFin, A.Activo,YEAR(A.VigenciaInicio)+1 as Año	from	[PAT].[Tablero] A	
END
go

