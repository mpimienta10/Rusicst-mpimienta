IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	29/01/2018
-- Description:		Obtiene informacion para el seguimiento para el detalle del consolidado para los municipios que respondieron la pregunta indicada
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] --pat.C_TableroSeguimientoDetalleConsolidadoDepartamento 1,558,37
( @IdTablero INT ,@IdUsuario INT ,@IdPregunta INT )
AS
BEGIN
	declare @IdDepartamento int
	select  @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	SELECT DISTINCT 
	B.Descripcion AS Componente
	,C.Descripcion AS Medida
	,E.Descripcion AS Derecho
	,A.PreguntaIndicativa 
	,D.Descripcion AS Unidad
	,RM.IdMunicipio
	,M.Nombre AS Municipio 
	,RM.RespuestaIndicativa AS  NecesidadIdentificada 
	,RM.RespuestaCompromiso 
	,RD.RespuestaCompromiso AS CompromisoGobernacion
	,ISNULL(SM.CantidadPrimer, -1) AS CantidadPrimerSemestre
	,ISNULL(SM.CantidadSegundo, -1) AS CantidadSegundoSemestre
	,A.Id AS IdPRegunta
	,E.Id AS IdDerecho
	,RM.IdUsuario AS IdUsuarioAlcaldia
	,ISNULL(SG.IdSeguimiento, 0) AS IdSeguimiento
	,ISNULL(SM.IdSeguimiento, 0) AS IdSeguimientoMunicipio
	,(SELECT TOP 1 XX.Id FROM [PAT].RespuestaPAT XX  
							join pat.PreguntaPAT as p on XX.IdPreguntaPAT = p.Id
							WHERE XX.IdMunicipio = RD.IdMunicipioRespuesta and XX.IdPreguntaPAT = @IdPregunta and p.IdTablero = @IdTablero) AS IdRespuestaDepartamentoMunicipio
	,ISNULL(SG.CantidadPrimer, -1) AS CantidadPrimerSemestreGobernaciones
	,ISNULL(SG.CantidadSegundo, -1) AS CantidadSegundoSemestreGobernaciones
	,RD.Presupuesto
	FROM [PAT].PreguntaPAT A
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	LEFT OUTER JOIN [PAT].RespuestaPAT RM ON A.Id =RM.IdPreguntaPAT and RM.IdDepartamento = @IdDepartamento and IdMunicipio is not null --para que tome las respuestas de alcaldias
	LEFT OUTER JOIN Municipio AS M ON RM.IdMunicipio = M.ID
	LEFT OUTER join Departamento as DEP ON M.IdDepartamento = DEP.Id
	LEFT OUTER join dbo.Usuario usu on usu.IdMunicipio = m.Id and usu.IdDepartamento = dep.Id and usu.IdTipoUsuario = 2 and usu.Activo = 1 and usu.IdEstado = 5	
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON A.Id=RD.IdPreguntaPAT  AND RD.IdUsuario = @IdUsuario and RD.IdMunicipioRespuesta = RM.IdMunicipio 
	LEFT OUTER JOIN [PAT].seguimiento SM ON A.ID =SM.IdPregunta AND SM.IdTablero = A.IdTablero AND  SM.IdUsuario = usu.Id--RM.IdUsuario
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  A.ID =SG.IdPregunta  AND A.IdTablero=SG.IdTablero  AND RM.IdUsuario =SG.IdUsuarioAlcaldia --[PAT].[fn_GetIdUsuario](RM.ID_ENTIDAD)
	WHERE   a.IdTablero= @IdTablero and A.ID = @IdPregunta
	union all	
	--los municipios que no tienen planeaacion
	select DISTINCT 
	B.Descripcion AS Componente
	,C.Descripcion AS Medida
	,E.Descripcion AS Derecho
	,A.PreguntaIndicativa 
	,D.Descripcion AS Unidad
	,M.Id as  IdMunicipio
	,M.Nombre AS Municipio 
	,0 AS  NecesidadIdentificada 
	,0
	,0 AS CompromisoGobernacion
	,-1 AS CantidadPrimerSemestre
	,-1 AS CantidadSegundoSemestre
	,A.Id AS IdPRegunta
	,E.Id AS IdDerecho
	,UA.Id AS IdUsuarioAlcaldia 
	,ISNULL(SG.IdSeguimiento, 0) AS IdSeguimiento
	,0 AS IdSeguimientoMunicipio
	,0 AS IdRespuestaDepartamentoMunicipio
	,ISNULL(SG.CantidadPrimer, -1) AS CantidadPrimerSemestreGobernaciones
	,ISNULL(SG.CantidadSegundo, -1) AS CantidadSegundoSemestreGobernaciones
	,0 as Presupuesto
	FROM [PAT].[PreguntaPAT] AS a
	join [PAT].[PreguntaPATMunicipio] as PM on a.Id = PM.IdPreguntaPAT 
	join Municipio as M on PM.IdMunicipio = M.Id
	Join Usuario as UA on M.Id = UA.IdMunicipio and UA.Activo =1 and UA.IdTipoUsuario = 2 and UA.IdEstado = 5
	join [PAT].Componente b on b.Id = a.IdComponente
	join [PAT].Medida c on c.Id = a.IdMedida
	join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	join [PAT].Derecho e on e.Id = a.IdDerecho
	LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on a.ID = R.[IdPreguntaPAT] and  R.IdMunicipio = PM.IdMunicipio 			
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  A.ID =SG.IdPregunta  AND A.IdTablero=SG.IdTablero AND SG.IdUsuario  = @IdUsuario and SG.IdUsuarioAlcaldia = UA.Id
	WHERE  a.IdTablero = 1 
	and a.Activo = 1
	and	a.NIVEL = 3 
	and M.IdDepartamento =@IdDepartamento
	and R.Id is  null	
	and a.Id = @IdPregunta
	order by M.Nombre asc
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	13/03/2018
-- Modified date:	01/06/2018
-- Description:		Obtiene informacion para el excel del seguimiento departamental para la hoja "Información Municipios"
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] --[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] 431, 1
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

			, SM.CompromisoDefinitivo,SM.PresupuestoDefinitivo ,SM.ObservacionesDefinitivo
			, SG.CompromisoDefinitivo CompromisoDefinitivoGobernacion,SG.PresupuestoDefinitivo PresupuestoDefinitivoGobernacion ,SG.ObservacionesDefinitivo ObservacionesDefinitivoGobernacion

			FROM [PAT].PreguntaPAT A (nolock)
			INNER JOIN [PAT].Derecho B ON B.Id = A.IdDerecho
			INNER JOIN [PAT].Componente C ON C.Id = A.IdComponente
			INNER JOIN [PAT].Medida D ON D.ID = A.IdMedida
			INNER JOIN [PAT].UnidadMedida E ON E.Id = A.IdUnidadMedida
			JOIN [PAT].RespuestaPAT RM (nolock) ON RM.IdPreguntaPAT = A.Id and RM.IdDepartamento =@IdDepartamento
			JOIN Municipio AS M ON RM.IdMunicipio = M.Id	
			join Departamento as DEP ON M.IdDepartamento = DEP.Id
			inner join dbo.Usuario usu on usu.IdMunicipio = m.Id and usu.IdDepartamento = dep.Id and usu.IdTipoUsuario = 2 and usu.Activo = 1 and usu.IdEstado = 5		
			--LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA (nolock) ON RMA.IdRespuestaPAT = RM.Id
			--LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP (nolock) ON RMP.IdRespuestaPAT = RM.Id
			LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RDM (nolock) ON  RM.IdMunicipio =RDM.IdMunicipioRespuesta AND  A.Id =RDM.IdPreguntaPAT  and RDM.IdUsuario =@IdUsuario			
			LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = A.ID AND SM.IdUsuario =usu.Id--RM.IdUsuario
			LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG (nolock) ON SG.IdPregunta = A.ID AND SG.IdUsuario = @IdUsuario AND SG.IdUsuarioAlcaldia = (select Id from Usuario where IdMunicipio = M.Id and Activo = 1 and IdEstado = 5 and IdTipoUsuario = 2) 			
			WHERE A.IdTablero = @IdTablero
			AND A.Activo = 1
			AND A.NIVEL = 3
			AND M.IdDepartamento =@IdDepartamento
	) AS P
	ORDER BY P.Departamento, P.Municipio
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService] AS'
GO
-- =============================================
-- Author:			Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Vilma Rodriguez
-- Create date:		14/11/2017
-- Modified date:	06/02/2018
-- Modify Date:		22/02/2018
-- Modified date:	01/06/2018
-- Description:		Retorna los datos del consolidado del seguimiento departamental 
--					del tablero PAT Indicado, por derecho y Divipola
-- Modificacion:	Se modifica para hacer opcional el parámetro IdDerecho
-- Modificacion:	Se modifica para agregar los campos de ajuste de planeacion
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService] --1, null, 5172
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaDepartamento int
)
AS
BEGIN
	SET NOCOUNT ON;	

	IF @IdDerecho IS NULL OR @IdDerecho = 0 OR @IdDerecho = -1
	BEGIN

	SELECT DISTINCT
		a.Id as IdPregunta
		,a.IdDerecho
		,b.Descripcion AS Derecho
		,rm.IdMunicipio AS DivipolaMunicipio
		,rm.IdDepartamento AS DivipolaDepartamento

		,rm.RespuestaIndicativa AS RespuestaIndicativaMunicipio
		,rm.RespuestaCompromiso AS RespuestaCompromisoMunicipio
		,CONVERT(FLOAT, rm.Presupuesto) AS PresupuestoMunicipio
		,rm.ObservacionNecesidad AS ObservacionMunicipio
		,rm.AccionCompromiso AS AccionCompromisoMunicipio

		--,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATAccion AS ACCION
		--WHERE rm.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesMunicipio,	
						
		--STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		--WHERE rm.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasMunicipio	

		,rd.RespuestaCompromiso AS RespuestaCompromisoGobernacion
		,CONVERT(FLOAT, rd.Presupuesto) AS PresupuestoGobernacion
		,rd.ObservacionCompromiso AS ObservacionCompromisoGobernacion

		--,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATAccion AS ACCION
		--WHERE rdd.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesDepartamento,
							
		--STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		--WHERE rdd.ID = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasDepartamento	

		,sm.CantidadPrimer AS SeguimientoPrimerSemestreMunicipio
		,sm.CantidadSegundo AS SeguimientoSegundoSemestreMunicipio
		,CONVERT(FLOAT, sm.PresupuestoPrimer) AS SeguimientoPresupuestoPrimerSemestreMunicipio
		,CONVERT(FLOAT, sm.PresupuestoSegundo) AS SeguimientoPresupuestoSegundoSemestreMunicipio

		,sd.CantidadPrimer AS SeguimientoPrimerSemestreGobernacion
		,sd.CantidadSegundo AS SeguimientoSegundoSemestreGobernacion
		,CONVERT(FLOAT, sd.PresupuestoPrimer) AS SeguimientoPresupuestoPrimerSemestreGobernacion
		,CONVERT(FLOAT, sd.PresupuestoSegundo) AS SeguimientoPresupuestoSegundoSemestreGobernacion

		--adicionales
		,sd.Observaciones AS ObservacionesPrimerSeguimientoGobernacion
		,sd.ObservacionesSegundo AS ObservacionesSegundoSeguimientoGobernacion

		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =sd.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =sd.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			
		--, CONVERT(FLOAT, REPLACE(isnull(sd.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(sd.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimientoGobernacion
		--, CONVERT(FLOAT,  REPLACE(isnull(sd.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(sd.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimientoGobernacion
		--, CONVERT(FLOAT, REPLACE(isnull(sm.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(sm.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimientoMunicipio
		--, CONVERT(FLOAT,  REPLACE(isnull(sm.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(sm.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimientoMunicipio
		,sd.CantidadPrimer +  sd.CantidadSegundo as CantidadTotalSeguimientoGobernacion
		,sd.PresupuestoPrimer + sd.PresupuestoSegundo as PresupuestoTotalSeguimientoGobernacion
		,sm.CantidadPrimer +  sm.CantidadSegundo as CantidadTotalSeguimientoMunicipio
		,sm.PresupuestoPrimer + sm.PresupuestoSegundo as PresupuestoTotalSeguimientoMunicipio
		
		, sm.CompromisoDefinitivo,sm.PresupuestoDefinitivo ,sm.ObservacionesDefinitivo
		, sd.CompromisoDefinitivo CompromisoDefinitivoGobernacion,sd.PresupuestoDefinitivo PresupuestoDefinitivoGobernacion ,sd.ObservacionesDefinitivo ObservacionesDefinitivoGobernacion

	FROM [PAT].[PreguntaPAT] a
		INNER JOIN [PAT].[Derecho] b ON a.IdDerecho = b.Id
		LEFT OUTER JOIN [PAT].[RespuestaPAT] rm ON a.Id = rm.IdPreguntaPAT AND rm.IdMunicipio IN (select xx.Id FROM dbo.Municipio xx WHERE xx.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento))
		LEFT OUTER JOIN [PAT].[RespuestaPATDepartamento] rd ON a.Id = rd.IdPreguntaPAT AND rd.IdMunicipioRespuesta = rm.IdMunicipio
		--LEFT OUTER JOIN [PAT].[RespuestaPAT] rdd ON a.Id = rd.IdPreguntaPAT AND rdd.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento)
		JOIN Municipio AS M ON RM.IdMunicipio = M.Id	
		join Departamento as DEP ON M.IdDepartamento = DEP.Id
		inner join dbo.Usuario usu on usu.IdMunicipio = m.Id and usu.IdDepartamento = dep.Id and usu.IdTipoUsuario = 2 and usu.Activo = 1 and usu.IdEstado = 5	
		LEFT OUTER JOIN [PAT].[Seguimiento] sm ON a.Id = sm.IdPregunta AND sm.IdUsuario = usu.Id
		LEFT OUTER JOIN [PAT].[SeguimientoGobernacion] sd ON a.Id = sd.IdPregunta AND sd.IdUsuarioAlcaldia = [PAT].[fn_GetIdUsuarioMunicipio](rm.IdMunicipio) AND sd.IdUsuario = [PAT].[fn_GetIdUsuarioDepartamento](rm.IdDepartamento)
	WHERE 
		a.IdTablero = @IdTablero
		AND a.Nivel = 3
		AND a.Activo = 1
	ORDER BY 
		a.Id ASC, rm.IdMunicipio ASC

	END
	ELSE
	BEGIN

	SELECT DISTINCT
		a.Id as IdPregunta
		,a.IdDerecho
		,b.Descripcion AS Derecho
		,rm.IdMunicipio AS DivipolaMunicipio
		,rm.IdDepartamento AS DivipolaDepartamento

		,rm.RespuestaIndicativa AS RespuestaIndicativaMunicipio
		,rm.RespuestaCompromiso AS RespuestaCompromisoMunicipio
		,CONVERT(FLOAT, rm.Presupuesto) AS PresupuestoMunicipio
		,rm.ObservacionNecesidad AS ObservacionMunicipio
		,rm.AccionCompromiso AS AccionCompromisoMunicipio

		--,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATAccion AS ACCION
		--WHERE rm.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesMunicipio,	
						
		--STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		--WHERE rm.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasMunicipio	

		,rd.RespuestaCompromiso AS RespuestaCompromisoGobernacion
		,CONVERT(FLOAT, rd.Presupuesto) AS PresupuestoGobernacion
		,rd.ObservacionCompromiso AS ObservacionCompromisoGobernacion

		--,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATAccion AS ACCION
		--WHERE rdd.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesDepartamento,
							
		--STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		--WHERE rdd.ID = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasDepartamento	

		,sm.CantidadPrimer AS SeguimientoPrimerSemestreMunicipio
		,sm.CantidadSegundo AS SeguimientoSegundoSemestreMunicipio
		,CONVERT(FLOAT, sm.PresupuestoPrimer) AS SeguimientoPresupuestoPrimerSemestreMunicipio
		,CONVERT(FLOAT, sm.PresupuestoSegundo) AS SeguimientoPresupuestoSegundoSemestreMunicipio

		,sd.CantidadPrimer AS SeguimientoPrimerSemestreGobernacion
		,sd.CantidadSegundo AS SeguimientoSegundoSemestreGobernacion
		,CONVERT(FLOAT, sd.PresupuestoPrimer) AS SeguimientoPresupuestoPrimerSemestreGobernacion
		,CONVERT(FLOAT, sd.PresupuestoSegundo) AS SeguimientoPresupuestoSegundoSemestreGobernacion

		--adicionales
		,sd.Observaciones AS ObservacionesPrimerSeguimientoGobernacion
		,sd.ObservacionesSegundo AS ObservacionesSegundoSeguimientoGobernacion

		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =sd.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =sd.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			
		--, CONVERT(FLOAT, REPLACE(isnull(sd.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(sd.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimientoGobernacion
		--, CONVERT(FLOAT,  REPLACE(isnull(sd.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(sd.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimientoGobernacion
		--, CONVERT(FLOAT, REPLACE(isnull(sm.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(sm.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimientoMunicipio
		--, CONVERT(FLOAT,  REPLACE(isnull(sm.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(sm.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimientoMunicipio
		,sd.CantidadPrimer +  sd.CantidadSegundo as CantidadTotalSeguimientoGobernacion
		,sd.PresupuestoPrimer + sd.PresupuestoSegundo as PresupuestoTotalSeguimientoGobernacion
		,sm.CantidadPrimer +  sm.CantidadSegundo as CantidadTotalSeguimientoMunicipio
		,sm.PresupuestoPrimer + sm.PresupuestoSegundo as PresupuestoTotalSeguimientoMunicipio

		, sm.CompromisoDefinitivo,sm.PresupuestoDefinitivo ,sm.ObservacionesDefinitivo
		, sd.CompromisoDefinitivo CompromisoDefinitivoGobernacion,sd.PresupuestoDefinitivo PresupuestoDefinitivoGobernacion ,sd.ObservacionesDefinitivo ObservacionesDefinitivoGobernacion

	FROM [PAT].[PreguntaPAT] a
		INNER JOIN [PAT].[Derecho] b ON a.IdDerecho = b.Id
		LEFT OUTER JOIN [PAT].[RespuestaPAT] rm ON a.Id = rm.IdPreguntaPAT AND rm.IdMunicipio IN (select xx.Id FROM dbo.Municipio xx WHERE xx.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento))
		LEFT OUTER JOIN [PAT].[RespuestaPATDepartamento] rd ON a.Id = rd.IdPreguntaPAT AND rd.IdMunicipioRespuesta = rm.IdMunicipio
		--LEFT OUTER JOIN [PAT].[RespuestaPAT] rdd ON a.Id = rd.IdPreguntaPAT AND rdd.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento)
		JOIN Municipio AS M ON RM.IdMunicipio = M.Id	
		join Departamento as DEP ON M.IdDepartamento = DEP.Id
		inner join dbo.Usuario usu on usu.IdMunicipio = m.Id and usu.IdDepartamento = dep.Id and usu.IdTipoUsuario = 2 and usu.Activo = 1 and usu.IdEstado = 5	
		LEFT OUTER JOIN [PAT].[Seguimiento] sm ON a.Id = sm.IdPregunta AND sm.IdUsuario =usu.Id
		LEFT OUTER JOIN [PAT].[SeguimientoGobernacion] sd ON a.Id = sd.IdPregunta AND sd.IdUsuarioAlcaldia = [PAT].[fn_GetIdUsuarioMunicipio](rm.IdMunicipio) AND sd.IdUsuario = [PAT].[fn_GetIdUsuarioDepartamento](rm.IdDepartamento)
	WHERE 
		a.IdTablero = @IdTablero
		AND b.Id = @IdDerecho
		AND a.Nivel = 3
		AND a.Activo = 1
	ORDER BY 
		a.Id ASC, rm.IdMunicipio ASC

	END

END