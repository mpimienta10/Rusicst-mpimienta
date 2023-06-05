IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	08/03/2018
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
			,RMA.Id AS IdAccion
			,RMP.Id AS IdPrograma
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
			,RMA.Accion
			,RMP.Programa
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
			LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA (nolock) ON RMA.IdRespuestaPAT = RM.Id
			LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP (nolock) ON RMP.IdRespuestaPAT = RM.Id
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
