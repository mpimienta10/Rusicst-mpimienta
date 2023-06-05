IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ProgramasPlaneacionWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ProgramasPlaneacionWebService] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/06/2018
-- Modificado :		19/02/2019 - UARIV -GGO -VR. Se incluyen los programas del consolidado municipal
-- Description:		Retorna informacion de los programas de planeacion de un tablero para el precargue de SIGO
-- =============================================
alter PROC  [PAT].[C_ProgramasPlaneacionWebService] --[PAT].[C_ProgramasPlaneacionWebService]  27
	@IdTablero INT	
AS
BEGIN
		select  AnoPlaneacion,IdPregunta,PreguntaCompromiso,IdRespuesta,IdRespuestaPrograma,IdDerecho,Programa,Compromiso,IdMunicipio,IdDepartamento,Departamento,Municipio, Nivel
		from (
			SELECT DISTINCT
			YEAR(T.VigenciaInicio)+1 AS AnoPlaneacion,
			P.ID AS IdPregunta, 
			P.PreguntaCompromiso,
			P.IDDERECHO AS IdDerecho, 
			R.ID AS IDTABLERO,						
			R.IdMunicipio,
			R.ID as IdRespuesta,		
			R.RESPUESTACOMPROMISO AS Compromiso, 
			R.PRESUPUESTO,
			Dep.Divipola as IdDepartamento, Dep.Nombre as Departamento,
			Mun.Nombre as Municipio
			,AP.Id AS IdRespuestaPrograma
			,(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE( AP.PROGRAMA,char(0x000B) ,'') , '"', '''') , CHAR(10), ' '),CHAR(13), ' '),CHAR(9), ' '),';','.')) AS Programa, 3 as Nivel
			FROM    [PAT].[PreguntaPAT] AS P
			INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
			INNER JOIN PAT.Tablero as T ON P.IdTablero = T.Id
			JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] --and  R.IdMunicipio = @IdMunicipio 	
			JOIN Municipio AS Mun ON R.IdMunicipio = Mun.Id
			JOIN Departamento as Dep on R.IdDepartamento = Dep.Id 	 							
			JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
			WHERE  P.IdTablero = @IdTablero
			AND P.Activo = 1
			and	P.NIVEL = 3 					
		) AS A 	
		union all
		select  AnoPlaneacion,IdPregunta,PreguntaCompromiso,IdRespuesta,IdRespuestaPrograma,IdDerecho,Programa,Compromiso,IdMunicipio,IdDepartamento,Departamento,Municipio, Nivel
		from (
			SELECT DISTINCT
			YEAR(T.VigenciaInicio)+1 AS AnoPlaneacion,
			P.ID AS IdPregunta, 
			P.PreguntaCompromiso,
			P.IDDERECHO AS IdDerecho, 
			R.ID AS IDTABLERO,						
			R.IdDepartamento ,
			R.ID as IdRespuesta,		
			R.RESPUESTACOMPROMISO AS Compromiso, 
			R.PRESUPUESTO,
			null as IdMunicipio, Dep.Nombre as Departamento, null as Municipio		
			,AP.Id AS IdRespuestaPrograma
			,(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE( AP.PROGRAMA,char(0x000B) ,'') , '"', '''') , CHAR(10), ' '),CHAR(13), ' '),CHAR(9), ' '),';','.')) AS Programa, 2 as Nivel
			FROM    [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Tablero as T ON P.IdTablero = T.Id
			JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] 			
			JOIN Departamento as Dep on R.IdDepartamento = Dep.Id 	 							
			LEFT OUTER JOIN [PAT].[RespuestaPATAccion] AS AA ON AA.[IdRespuestaPAT] = R.ID and AA.Activo = 1
			LEFT OUTER JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
			WHERE  P.IdTablero = @IdTablero
			AND P.Activo = 1
			and	P.NIVEL = 2 					
		) AS A 	
		union all
		select  AnoPlaneacion,IdPregunta,PreguntaCompromiso,IdRespuesta,IdRespuestaPrograma,IdDerecho,Programa,Compromiso,IdMunicipio,IdDepartamento,Departamento,Municipio, Nivel
		from (
			SELECT DISTINCT
			YEAR(T.VigenciaInicio)+1 AS AnoPlaneacion,
			P.ID AS IdPregunta, 
			P.PreguntaCompromiso,
			P.IDDERECHO AS IdDerecho, 
			t.ID AS IDTABLERO,						
			Usu.IdDepartamento ,
			R.ID as IdRespuesta,		
			R.RESPUESTACOMPROMISO AS Compromiso, 
			R.PRESUPUESTO,
			R.IdMunicipioRespuesta as IdMunicipio, Dep.Nombre as Departamento, Mun.Nombre as Municipio		
			,AP.Id AS IdRespuestaPrograma
			,(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE( AP.PROGRAMA,char(0x000B) ,'') , '"', '''') , CHAR(10), ' '),CHAR(13), ' '),CHAR(9), ' '),';','.')) AS Programa, 2 as Nivel
			FROM    [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Tablero as T ON P.IdTablero = T.Id
			JOIN [PAT].[RespuestaPATDepartamento] (NOLOCK) AS R on P.ID = R.[IdPreguntaPAT] 
			join Usuario as Usu on R.IdUsuario = Usu.Id			
			JOIN Departamento as Dep on Usu.IdDepartamento = Dep.Id 	 							
			JOIN Municipio AS Mun ON R.IdMunicipioRespuesta = Mun.Id
			JOIN [PAT].[RespuestaPATProgramaDepartamento] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
			WHERE  P.IdTablero = @IdTablero
			AND P.Activo = 1
			and	P.NIVEL = 3--proque son las preguntas de los municipios en el consolidado 				
		) AS A 	
		ORDER BY Departamento,IdPregunta
END
