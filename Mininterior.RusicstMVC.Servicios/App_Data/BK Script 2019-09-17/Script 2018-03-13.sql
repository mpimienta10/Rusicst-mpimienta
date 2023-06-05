IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoGobernaciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoGobernaciones] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		30/08/2017
-- Modified date:	13/06/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental de las preguntas del departamento
-- =============================================
ALTER PROC  [PAT].[C_DatosExcelSeguimientoGobernaciones] --[PAT].[C_DatosExcelSeguimientoGobernaciones]  375, 3
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
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			
		
		FROM [PAT].PreguntaPAT A
		INNER JOIN [PAT].Derecho B ON B.Id = A.IdDerecho
		INNER JOIN [PAT].Componente C ON C.Id = A.IdComponente
		INNER JOIN [PAT].Medida D ON D.Id = A.IdMedida
		INNER JOIN [PAT].UnidadMedida E ON E.Id = A.IdUnidadMedida
		JOIN [PAT].RespuestaPAT RM ON RM.IdPreguntaPAT = A.Id and RM.IdDepartamento =@IdDepartamento	
		--LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA ON RM.Id =RMA.IdRespuestaPAT 
		--LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP ON RM.Id = RMP.IdRespuestaPAT
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  A.ID =SG.IdPregunta  AND SG.IdUsuario = @IdUsuario 
		WHERE A.IdTablero = @IdTablero and  A.Activo = 1
		AND A.NIVEL = 2
		) AS A
	ORDER BY A.Derecho ASC, A.IdPregunta ASC
END


go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	13/03/2018
-- Description:		Obtiene informacion para el excel del seguimiento departamental para la hoja "Información Municipios"
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] --[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] 375, 4
(@IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare  @IdDepartamento int, @Departamento varchar(150)
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	select @Departamento = Nombre from Departamento where Id = @IdDepartamento

	SELECT 	P.*	FROM
	(
			SELECT DISTINCT
			A.Id AS IdPregunta
			,0 AS IdAccion
			,0 AS IdPrograma
			,RM.IdMunicipio
			,@Departamento AS Departamento
			,m.Nombre as Municipio
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
			,RDM.RespuestaCompromiso AS RespuestaCompromisoDepartamento
			,RDM.Presupuesto AS PresupuestoDepartamento
			,RDM.ObservacionCompromiso AS ObservacionDepartamento
			--,RDA.Accion AS AccionDepartamento
			--,RDP.Programa AS ProgramaDepartamento
			,STUFF((SELECT CAST( RDA.Accion  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].RespuestaPATAccion AS RDA
			WHERE RDA.IdRespuestaPAT = RDM.Id FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionDepartamento	

			,STUFF((SELECT CAST( RDP.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].RespuestaPATPrograma AS RDP
			WHERE RDP.IdRespuestaPAT = RDM.Id FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramaDepartamento	

			,SM.CantidadPrimer  AS CantidadPrimerSeguimientoAlcaldia
			,REPLACE(SM.CantidadSegundo, -1, 0) AS CantidadSegundoSeguimientoAlcaldia
			,SM.PresupuestoPrimer AS PresupuestoPrimerSeguimientoAlcaldia
			,REPLACE(SM.PresupuestoSegundo, -1, 0) AS PresupuestoSegundoSeguimientoAlcaldia

			,(SM.CantidadPrimer + REPLACE(SM.CantidadSegundo, -1, 0)) AS AvanceCantidadAlcaldia
			,(SM.PresupuestoPrimer + REPLACE(SM.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoAlcaldia
			,SM.Observaciones AS ObservacionesSeguimientoAlcaldia

			,SG.CantidadPrimer  AS CantidadPrimerSeguimientoGobernacion
			,REPLACE(SG.CantidadSegundo, -1, 0) AS CantidadSegundoSeguimientoGobernacion
			,SG.PresupuestoPrimer AS PresupuestoPrimerSeguimientoGobernacion
			,REPLACE(SG.PresupuestoSegundo, -1, 0) AS PresupuestoSegundoSeguimientoGobernacion


			,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
			,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
			,SG.Observaciones AS ObservacionesSeguimientoGobernacion

			,SG.ObservacionesSegundo AS ObservacionesSegundoSeguimientoGobernacion
			,SM.ObservacionesSegundo AS ObservacionesSegundoSeguimientoAlcaldia

			,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].SeguimientoProgramas AS SMP
			WHERE SMP.IdSeguimiento =SM.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimero			
			,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].SeguimientoProgramas AS SMP
			WHERE SMP.IdSeguimiento =SM.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundo			

			,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].SeguimientoGobernacionProgramas AS SMP
			WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
			,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].SeguimientoGobernacionProgramas AS SMP
			WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			

			FROM [PAT].PreguntaPAT A (nolock)
			INNER JOIN [PAT].Derecho B ON B.Id = A.IdDerecho
			INNER JOIN [PAT].Componente C ON C.Id = A.IdComponente
			INNER JOIN [PAT].Medida D ON D.ID = A.IdMedida
			INNER JOIN [PAT].UnidadMedida E ON E.Id = A.IdUnidadMedida
			JOIN [PAT].RespuestaPAT RM (nolock) ON RM.IdPreguntaPAT = A.Id and RM.IdDepartamento =@IdDepartamento
			JOIN Municipio AS M ON RM.IdMunicipio = M.Id			
			--LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA (nolock) ON RMA.IdRespuestaPAT = RM.Id
			--LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP (nolock) ON RMP.IdRespuestaPAT = RM.Id
			LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RDM (nolock) ON  RM.IdMunicipio =RDM.IdMunicipioRespuesta AND  A.Id =RDM.IdPreguntaPAT  and RDM.IdUsuario =@IdUsuario			
			LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = A.ID AND SM.IdUsuario =RM.IdUsuario
			LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG (nolock) ON SG.IdPregunta = A.ID AND SG.IdUsuario = @IdUsuario AND SG.IdUsuarioAlcaldia = RM.IdUsuario			
			WHERE A.IdTablero = @IdTablero
			AND A.Activo = 1
			AND A.NIVEL = 3
			AND M.IdDepartamento =@IdDepartamento
	) AS P
	ORDER BY P.Departamento, P.Municipio
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcel_Gobernaciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcel_Gobernaciones] AS'
GO
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/07/2017
-- Modified date:	13/03/2018
-- Description:		Obtiene toda la informacion correspondiente a las preguntas de la  gobernacion  del tablero indicando en cuento a las respuestas que estos diligenciaron
-- ==========================================================================================
ALTER PROC [PAT].[C_DatosExcel_Gobernaciones] -- [PAT].[C_DatosExcel_Gobernaciones] 11001,3
(
	@IdUsuario INT, @IdTablero INT
)
AS
BEGIN

	declare @IdDepartamento int
	select  @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	SELECT DISTINCT  
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
		CASE WHEN R.IdMunicipio IS NULL THEN 0 ELSE R.IdMunicipio END AS IDENTIDAD,
		R.ID as id_respuesta,
		R.RESPUESTAINDICATIVA, 
		R.RESPUESTACOMPROMISO, 
		R.PRESUPUESTO,
		R.OBSERVACIONNECESIDAD,
		R.ACCIONCOMPROMISO
		--,AA.ACCION
		--,AP.PROGRAMA
		,STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATAccion AS ACCION
		WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ACCION				
		,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		WHERE R.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS PROGRAMA	
		FROM    [PAT].[PreguntaPAT] AS P
		INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
		INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
		INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
		INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
		INNER JOIN PAT.Tablero AS T ON P.IDTABLERO = T.ID
		LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] and R.IdDepartamento = @IdDepartamento and R.IdMunicipio is null
		--LEFT OUTER JOIN [PAT].[RespuestaPATAccion] AS AA ON AA.[IdRespuestaPAT] = R.ID and AA.Activo = 1
		--LEFT OUTER JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
		INNER JOIN Usuario AS U ON R.IdUsuario = U.Id and U.IdDepartamento = @IdDepartamento
		WHERE  T.ID = @IdTablero 
		and	P.NIVEL = 2					 
	) AS A 
	WHERE A.ACTIVO = 1  
	ORDER BY IDPREGUNTA
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcel_Gobernaciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcel_Gobernaciones] AS'
GO
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/07/2017
-- Modified date:	13/03/2018
-- Description:		Obtiene toda la informacion del municipio y gobernacion del tablero indicando en cuento a lo diligenciado
-- ==========================================================================================
ALTER PROC [PAT].[C_DatosExcel_Gobernaciones_municipios] -- [PAT].[C_DatosExcel_Gobernaciones_municipios] 375,3
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
	,1 AS IDRESPUESTADEP--,DEP.Id AS IDRESPUESTADEP
	,DEP.RespuestaCompromiso AS RESPUESTA_DEP_COMPROMISO
	,DEP.ObservacionCompromiso as  RESPUESTA_DEP_OBSERVACION 
	,DEP.Presupuesto AS RESPUESTA_DEP_PRESUPUESTO					
	--,'' as ACCION_DEPTO, '' as PROGRAMA_DEPTO
	,STUFF((SELECT CAST(   REPLACE(ACCIONDEP.Accion,char(0x000B), ' ')  AS VARCHAR(MAX)) + ' / ' 
	FROM PAT.RespuestaPATAccionDepartamento AS ACCIONDEP
	WHERE DEP.Id = ACCIONDEP.IdRespuestaPAT AND ACCIONDEP.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ACCION_DEPTO	
	,STUFF((SELECT CAST(  REPLACE( PROGRAMADEP.Programa ,char(0x000B), ' ') AS VARCHAR(MAX)) + ' / ' 
	FROM [PAT].[RespuestaPATProgramaDepartamento] AS PROGRAMADEP
	WHERE DEP.Id = PROGRAMADEP.IdRespuestaPAT AND PROGRAMADEP.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS PROGRAMA_DEPTO		
	FROM    [PAT].[PreguntaPAT] AS P
	--join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT
	--join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = @IdDepartamento		
	INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
	INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
	INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
	INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
	INNER JOIN [PAT].Tablero AS T ON P.IDTABLERO = T.ID
	LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT]  
	LEFT OUTER JOIN Municipio AS MR ON R.IdMunicipio = MR.Id AND MR.IdDepartamento = @IdDepartamento													
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento DEP ON R.IdPreguntaPAT = DEP.IdPreguntaPAT and R.IdMunicipio = DEP.IdMunicipioRespuesta 	--trae varias respuestas
	LEFT OUTER JOIN Municipio AS MRDEP ON DEP.IdMunicipioRespuesta = MRDEP.Id AND MRDEP.IdDepartamento = @IdDepartamento																																
	--LEFT OUTER JOIN [PAT].[RespuestaPAT] as RDEP on P.ID = RDEP.[IdPreguntaPAT] and  R.IdMunicipio = @IdMunicipio 										
	WHERE  T.ID = @IdTablero 
	and  P.NIVEL = 3 
	and MR.IdDepartamento = @IdDepartamento
	and P.ACTIVO = 1  
	ORDER BY DEPTO, MPIO, IDPREGUNTA
END

go
-------------municipios------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcel_Municipios]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcel_Municipios] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	13/03/2018
-- Description:		Obtiene los datos a exportar de la gestion municipal del los derechos para las preguntas del municipio indicado
-- =============================================
ALTER PROC [PAT].[C_DatosExcel_Municipios] --[PAT].[C_DatosExcel_Municipios] 5172, 1
	(@IdMunicipio INT, @IdTablero INT)
AS
BEGIN
	SELECT 	  
	IDPREGUNTA AS ID
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
		R.ID AS IDTABLERO,						
		CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
		R.ID as id_respuesta,
		R.RESPUESTAINDICATIVA, 
		R.RESPUESTACOMPROMISO, 
		R.PRESUPUESTO,
		R.OBSERVACIONNECESIDAD,
		R.ACCIONCOMPROMISO
		--,AA.ACCION
		--,AP.PROGRAMA
		,STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATAccion AS ACCION
		WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ACCION,	
		STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		WHERE R.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS PROGRAMA	
		FROM    [PAT].[PreguntaPAT] AS P
		join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
		INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
		INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
		INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
		INNER JOIN PAT.Tablero AS T ON P.IDTABLERO = T.ID
		LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] and  R.IdMunicipio = @IdMunicipio 									
		--LEFT OUTER JOIN [PAT].[RespuestaPATAccion] AS AA ON AA.[IdRespuestaPAT] = R.ID and AA.Activo = 1
		--LEFT OUTER JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
		INNER JOIN Usuario AS U ON R.IdUsuario = U.Id  AND U.IdMunicipio = @IdMunicipio
		WHERE  T.ID = @IdTablero 
		and	P.NIVEL = 3 					
	) AS A 
	WHERE A.ACTIVO = 1  
	ORDER BY IDPREGUNTA

END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoAlcaldias]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoAlcaldias] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	13/03/2018
-- Description:		Obtiene informacion requerida para la hoja "Reporte Seguimiento Tablero PAT" del excel que se exporta en seguimiento municipal
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoAlcaldias] --[PAT].[C_DatosExcelSeguimientoAlcaldias] 411, 4
( @IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare @IdMunicipio int, @IdDepartamento int
	select  @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	select distinct IdPregunta,IdAccion,IdPrograma,Derecho,Componente,Medida,Pregunta,PreguntaCompromiso,UnidadNecesidad,RespuestaNecesidad
		,ObservacionNecesidad,RespuestaCompromiso,ObservacionCompromiso,PrespuestaPresupuesto,Accion,Programa
		,CantidadPrimerSeguimientoAlcaldia, CantidadSegundoSeguimientoAlcaldia,AvanceCantidadAlcaldia
		,PresupuestoPrimerSeguimientoAlcaldia,PresupuestoSegundoSeguimientoAlcaldia,AvancePresupuestoAlcaldia
		,ObservacionesSeguimientoAlcaldia
		,CantidadPrimerSeguimientoGobernacion ,CantidadSegundoSeguimientoGobernacion  ,AvanceCantidadGobernacion
		,PresupuestoPrimerSeguimientoGobernacion,PresupuestoSegundoSeguimientoGobernacion ,AvancePresupuestoGobernacion
		,ObservacionesSeguimientoGobernacion,ObservacionesSegundo,NombreAdjuntoSegundo
		,ProgramasPrimero,ProgramasSegundo,ProgramasPrimeroSeguimientoGobernacion,ProgramasSegundoSeguimientoGobernacion,ObservacionesSegundoSeguimientoGobernacion
	from (
		SELECT 
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
		,RM.Presupuesto AS PrespuestaPresupuesto
		--,RMA.Accion
		--,RMP.Programa					
		,STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATAccion AS ACCION
		WHERE A.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Accion,	
		STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		WHERE A.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Programa	

		,SM.CantidadPrimer AS CantidadPrimerSeguimientoAlcaldia
		,REPLACE(SM.CantidadSegundo, -1, 0) AS CantidadSegundoSeguimientoAlcaldia
		,SM.PresupuestoPrimer AS PresupuestoPrimerSeguimientoAlcaldia
		,REPLACE(SM.PresupuestoSegundo, -1, 0) AS PresupuestoSegundoSeguimientoAlcaldia

		,(SM.CantidadPrimer + REPLACE(SM.CantidadSegundo, -1, 0)) AS AvanceCantidadAlcaldia
		,(SM.PresupuestoPrimer + REPLACE(SM.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoAlcaldia
		,SM.Observaciones AS ObservacionesSeguimientoAlcaldia

		,SG.CantidadPrimer AS CantidadPrimerSeguimientoGobernacion
		,REPLACE(SG.CantidadSegundo, -1, 0) AS CantidadSegundoSeguimientoGobernacion
		,SG.PresupuestoPrimer AS PresupuestoPrimerSeguimientoGobernacion
		,REPLACE(SG.PresupuestoSegundo, -1, 0) AS PresupuestoSegundoSeguimientoGobernacion

		,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
		,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
		
		,SG.Observaciones AS ObservacionesSeguimientoGobernacion
		,SG.ObservacionesSegundo AS ObservacionesSegundoSeguimientoGobernacion
		
		,SM.ObservacionesSegundo
		,SM.NombreAdjuntoSegundo		

		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoProgramas AS SMP
		WHERE SMP.IdSeguimiento =SM.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimero			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoProgramas AS SMP
		WHERE SMP.IdSeguimiento =SM.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundo			


		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			
		
		FROM [PAT].PreguntaPAT A (nolock)
		join [PAT].[PreguntaPATMunicipio] as PM (nolock) on A.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		inner join [PAT].Componente b (nolock) on b.Id = a.IdComponente
		inner join [PAT].Medida c (nolock) on c.Id = a.IdMedida
		inner join [PAT].UnidadMedida d (nolock) on d.Id = a.IdUnidadMedida
		inner join [PAT].Derecho e (nolock) on e.Id = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT RM (nolock) ON RM.IdPreguntaPAT = A.Id  and RM.IdMunicipio = @IdMunicipio--AND RM.ID_ENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
		--LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA  (nolock)ON RMA.IdRespuestaPAT = RM.Id
		--LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP  (nolock) ON RMP.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = A.ID AND SM.IdUsuario = @IdUsuario AND SM.IdTablero = @IdTablero
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG (nolock) ON SG.IdPregunta = A.ID AND SG.IdUsuarioAlcaldia = @IdUsuario AND SG.IdTablero = @IdTablero
		WHERE  a.IdTablero= @IdTablero 
		AND A.NIVEL = 3		
		and a.ACTIVO = 1
		) as A
		ORDER BY Derecho ASC, IdPregunta ASC 
END

go

/****** Object:  StoredProcedure [PAT].[C_TodosTablerosPlaneacionActivos]    Script Date: 12/03/2018 7:03:10 p. m. ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosSeguimientosActivos]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosSeguimientosActivos] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Modifica: John Betancourt OIM
-- Create date:		01/09/2017
-- Modified date:	02/11/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que NO estan activos
-- Modified date:	10/03/2018
-- Description:		Todos los tableros de seguimiento 1
-- ==========================================================================================
ALTER PROC [PAT].[C_TodosTablerosSeguimientosActivos] 
(@IdSeguimiento INT)
AS
BEGIN
	IF(@IdSeguimiento = 1)
	BEGIN
		select A.Id,  B.Vigenciainicio, B.VigenciaFin, year(B.VigenciaInicio)+1 as Ano, 'Diligenciamiento Municipios' as Tipo, Seguimiento1Inicio, Seguimiento1Fin,Seguimiento2Inicio, Seguimiento2Fin 
		from  [PAT].[Tablero] A, 
		[PAT].[TableroFecha] B
		Where A.Id=B.IdTablero
		and B.Nivel=3 --- Mnucipio
		and B.[Activo]=1
		and ( GETDATE() > Seguimiento1Fin)	
		union
		select A.Id,  B.Vigenciainicio, B.VigenciaFin, year(B.VigenciaInicio)+1 as Ano, 'Diligenciamiento Departamentos' as Tipo, Seguimiento1Inicio, Seguimiento1Fin,Seguimiento2Inicio, Seguimiento2Fin 
		from  [PAT].[Tablero] A, 
		[PAT].[TableroFecha] B
		Where A.Id=B.IdTablero
		and B.Nivel=2  --Dptos
		and B.[Activo]=1
		and ( GETDATE() > Seguimiento1Fin )
	END
	ELSE IF(@IdSeguimiento = 2)
	BEGIN
		select A.Id,  B.Vigenciainicio, B.VigenciaFin, year(B.VigenciaInicio)+1 as Ano, 'Diligenciamiento Municipios' as Tipo, Seguimiento1Inicio, Seguimiento1Fin,Seguimiento2Inicio, Seguimiento2Fin 
		from  [PAT].[Tablero] A, 
		[PAT].[TableroFecha] B
		Where A.Id=B.IdTablero
		and B.Nivel=3 --- Mnucipio
		and B.[Activo]=1
		and ( GETDATE() > Seguimiento2Fin)	
		union
		select A.Id,  B.Vigenciainicio, B.VigenciaFin, year(B.VigenciaInicio)+1 as Ano, 'Diligenciamiento Departamentos' as Tipo, Seguimiento1Inicio, Seguimiento1Fin,Seguimiento2Inicio, Seguimiento2Fin 
		from  [PAT].[Tablero] A, 
		[PAT].[TableroFecha] B
		Where A.Id=B.IdTablero
		and B.Nivel=2  --Dptos
		and B.[Activo]=1
		and ( GETDATE() > Seguimiento2Fin )
	END
END

GO

/****** Object:  StoredProcedure [PAT].[C_TodosTablerosPlaneacionActivos]    Script Date: 12/03/2018 7:03:10 p. m. ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ExtensionesTiempo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ExtensionesTiempo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************  
-- Autor: Liliana Rodriguez                      
-- Fecha creacion: 2017-02-08   
-- Fecha Modificacion: 2017-10-26  
-- Modifica: Andrés Bonilla                     
-- Descripcion: Consulta la informacion de la rejilla de Extensiones de tiempo concedidas              
-- Descripcion Modificacion: Se agrega la Columna de Tipo de Extension  
-- ***************************************************************************************************  
ALTER PROC [dbo].[C_ExtensionesTiempo]  
  
AS  
  
 SELECT   
   [PUE].[FechaFin] AS Fecha  
  ,[U].[UserName] AS Usuario  
  ,CASE PUE.[IdTipoExtension]  
   WHEN 1  
    THEN  
     (Select top 1 xx.Titulo FROM dbo.Encuesta xx WHERE xx.Id = PUE.IdEncuesta)  
   WHEN 2  
    THEN   
     (Select top 1 xx.Nombre FROM [PlanesMejoramiento].[PlanMejoramiento] xx WHERE xx.IdPlanMejoramiento = PUE.IdEncuesta)  
   WHEN 3  
    THEN   
     (Select top 1 CONVERT(VARCHAR, DATEPART(YEAR, xx.[VigenciaInicio])) + (CASE U.IdTipoUsuario WHEN 2 THEN ' - Municipios' WHEN 7 THEN ' - Departamentos' ELSE '' END)  FROM [PAT].[Tablero] xx WHERE xx.Id = PUE.IdEncuesta)  
   WHEN 4  
    THEN   
     (Select top 1 CONVERT(VARCHAR, DATEPART(YEAR, xx.[VigenciaInicio])) + (CASE U.IdTipoUsuario WHEN 2 THEN ' - Municipios' WHEN 7 THEN ' - Departamentos' ELSE '' END)  FROM [PAT].[Tablero] xx WHERE xx.Id = PUE.IdEncuesta)  
  END AS Reporte  
  ,[UTramite].[UserName] AS Autoriza  
  ,[PUE].[FechaTramite]  
  ,CASE PUE.[IdTipoExtension] WHEN 1 THEN 'Encuesta' WHEN 2 THEN 'Plan de Mejoramiento' WHEN 3 THEN 'Tablero PAT - Diligenciamiento' WHEN 4 THEN 'Tablero PAT - Seguimiento 1' WHEN 5 THEN 'Tablero PAT - Seguimiento 2' END AS TipoExtension  
 FROM   
  [dbo].[PermisoUsuarioEncuesta] AS PUE  
  INNER JOIN [dbo].[Usuario] U ON [PUE].[IdUsuario] = [U].[Id]  
  INNER JOIN [dbo].[Usuario] UTramite ON [PUE].[IdUsuarioTramite] = [UTramite].[Id]  
  --INNER JOIN [dbo].[Encuesta] AS E ON [PUE].IdEncuesta= [E].Id  
 ORDER BY    
  PUE.[IdTipoExtension], [PUE].[FechaFin] DESC  
  
GO