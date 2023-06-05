-------------------------------------pendiente de aprovar con Andrey--------------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[PreguntaPATPrecargueEntidadesNacionales]') ) 
begin 
	CREATE TABLE [PAT].[PreguntaPATPrecargueEntidadesNacionales](
		[IdPreguntaPat] [smallint] NOT NULL,
		[IdMunicipio] [int] NOT NULL,
		[Dato1] [varchar](max) NULL,
		[Dato2] [varchar](max) NULL,
		[Dato3] [varchar](max) NULL
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

	ALTER TABLE [PAT].[PreguntaPATPrecargueEntidadesNacionales]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATPrecargueEntidadesNacionales_Municipio] FOREIGN KEY([IdMunicipio])
	REFERENCES [dbo].[Municipio] ([Id])

	ALTER TABLE [PAT].[PreguntaPATPrecargueEntidadesNacionales] CHECK CONSTRAINT [FK_PreguntaPATPrecargueEntidadesNacionales_Municipio]

	ALTER TABLE [PAT].[PreguntaPATPrecargueEntidadesNacionales]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATPrecargueEntidadesNacionales_PreguntaPAT] FOREIGN KEY([IdPreguntaPat])
	REFERENCES [PAT].[PreguntaPAT] ([Id])

	ALTER TABLE [PAT].[PreguntaPATPrecargueEntidadesNacionales] CHECK CONSTRAINT [FK_PreguntaPATPrecargueEntidadesNacionales_PreguntaPAT]

end
GO

------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	02/02/2018
-- Description:		Obtiene informacion para el excel del seguimiento departamental para la hoja "Información Municipios"
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] --[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] 375, 4
(@IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare  @IdDepartamento int, @Departamento varchar(150)
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	select @Departamento = Nombre from Departamento where Id = @IdDepartamento

	SELECT TOP 1000	P.*	FROM
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

			,(SM.CantidadPrimer + REPLACE(SM.CantidadSegundo, -1, 0)) AS AvanceCantidadAlcaldia
			,(SM.PresupuestoPrimer + REPLACE(SM.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoAlcaldia
			,SM.Observaciones AS ObservacionesSeguimientoAlcaldia

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

			FROM [PAT].PreguntaPAT A
			INNER JOIN [PAT].Derecho B ON B.Id = A.IdDerecho
			INNER JOIN [PAT].Componente C ON C.Id = A.IdComponente
			INNER JOIN [PAT].Medida D ON D.ID = A.IdMedida
			INNER JOIN [PAT].UnidadMedida E ON E.Id = A.IdUnidadMedida
			JOIN [PAT].RespuestaPAT RM ON RM.IdPreguntaPAT = A.Id and RM.IdDepartamento =@IdDepartamento
			JOIN Municipio AS M ON RM.IdMunicipio = M.Id			
			LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA ON RMA.IdRespuestaPAT = RM.Id
			LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP ON RMP.IdRespuestaPAT = RM.Id
			LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RDM ON  RM.IdMunicipio =RDM.IdMunicipioRespuesta AND  A.Id =RDM.IdPreguntaPAT  and RDM.IdUsuario =@IdUsuario
			
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoAlcaldias]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoAlcaldias] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	0/02/2018
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
		,RMA.Id AS IdAccion
		,RMP.Id AS IdPrograma
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
		,RMA.Accion
		,RMP.Programa					

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
		LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA  (nolock)ON RMA.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP  (nolock) ON RMP.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = A.ID AND SM.IdUsuario = @IdUsuario AND SM.IdTablero = @IdTablero
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG (nolock) ON SG.IdPregunta = A.ID AND SG.IdUsuarioAlcaldia = @IdUsuario AND SG.IdTablero = @IdTablero
		WHERE  a.IdTablero= @IdTablero 
		AND A.NIVEL = 3		
		and a.ACTIVO = 1
		) as A
		ORDER BY Derecho ASC, IdPregunta ASC 
END


go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosSeguimientoMunicipiosPorCompletar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosSeguimientoMunicipiosPorCompletar] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		01/09/2017
-- Modified date:	02/02/2018
-- Description:		Retorna los tableros de nivel 3 que hacen referencia a la seguimiento municipal que estan activos
-- ==========================================================================================
ALTER PROC  [PAT].[C_TodosTablerosSeguimientoMunicipiosPorCompletar]
AS
BEGIN
	select A.Id,  B.Vigenciainicio, B.VigenciaFin, year(B.VigenciaInicio)+1 as Ano, Seguimiento1Inicio, Seguimiento1Fin,Seguimiento2Inicio, Seguimiento2Fin 
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=3	
	and B.[Activo]=1
	and ( GETDATE() between Seguimiento1Inicio and Seguimiento1Fin or  GETDATE() between Seguimiento2Inicio and Seguimiento2Fin)
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosSeguimientoDepartamentosPorCompletar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosSeguimientoDepartamentosPorCompletar] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		01/09/2017
-- Modified date:	02/02/2018
-- Description:		Retorna los tableros de nivel 3 que hacen referencia a la seguimiento departamental que estan activos
-- ==========================================================================================
ALTER PROC  [PAT].[C_TodosTablerosSeguimientoDepartamentosPorCompletar]
AS
BEGIN
	select A.Id,  B.Vigenciainicio, B.VigenciaFin, year(B.VigenciaInicio)+1 as Ano, Seguimiento1Inicio, Seguimiento1Fin,Seguimiento2Inicio, Seguimiento2Fin 
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.[Activo]=1
	and B.Nivel=2
	and ( GETDATE() between Seguimiento1Inicio and Seguimiento1Fin or  GETDATE() between Seguimiento2Inicio and Seguimiento2Fin)
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoGobernaciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoGobernaciones] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		30/08/2017
-- Modified date:	06/02/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental de las preguntas del departamento
-- =============================================
ALTER PROC  [PAT].[C_DatosExcelSeguimientoGobernaciones] --[PAT].[C_DatosExcelSeguimientoGobernaciones]  375, 4
(@IdUsuario INT,@IdTablero INT)
AS
BEGIN

	declare  @IdDepartamento int, @Departamento varchar(150)
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	select @Departamento = Nombre from Departamento where Id = @IdDepartamento

	SELECT
	A.Id AS IdPregunta
	,RMA.Id AS IdAccion
	,RMP.Id AS IdPrograma
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
	LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA ON RM.Id =RMA.IdRespuestaPAT 
	LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP ON RM.Id = RMP.IdRespuestaPAT
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  A.ID =SG.IdPregunta  AND SG.IdUsuario = @IdUsuario 
	WHERE A.IdTablero = @IdTablero and  A.Activo = 1
	AND A.NIVEL = 2
	ORDER BY B.Id ASC, A.Id ASC
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoGobernaciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	06/02/2018
-- Description:		Obtiene informacion para el excel del seguimiento departamental para la hoja "Información Municipios"
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] --[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] 375, 4
(@IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare  @IdDepartamento int, @Departamento varchar(150)
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	select @Departamento = Nombre from Departamento where Id = @IdDepartamento

	SELECT TOP 1000	P.*	FROM
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

			FROM [PAT].PreguntaPAT A
			INNER JOIN [PAT].Derecho B ON B.Id = A.IdDerecho
			INNER JOIN [PAT].Componente C ON C.Id = A.IdComponente
			INNER JOIN [PAT].Medida D ON D.ID = A.IdMedida
			INNER JOIN [PAT].UnidadMedida E ON E.Id = A.IdUnidadMedida
			JOIN [PAT].RespuestaPAT RM ON RM.IdPreguntaPAT = A.Id and RM.IdDepartamento =@IdDepartamento
			JOIN Municipio AS M ON RM.IdMunicipio = M.Id			
			LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA ON RMA.IdRespuestaPAT = RM.Id
			LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP ON RMP.IdRespuestaPAT = RM.Id
			LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RDM ON  RM.IdMunicipio =RDM.IdMunicipioRespuesta AND  A.Id =RDM.IdPreguntaPAT  and RDM.IdUsuario =@IdUsuario
			
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ContarTableroMunicipioTotales]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ContarTableroMunicipioTotales] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	0/07/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados 
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_ContarTableroMunicipioTotales] 
 (@IdUsuario INT,  @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Cantidad INT, @ID_ENTIDAD INT

	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE  @IdMunicipio INT, @IDDEPARTAMENTO INT

	SELECT @IDDEPARTAMENTO = IdDepartamento , @IdMunicipio = IdMunicipio FROM USUARIO WHERE Id = @IdUsuario

	SELECT DISTINCT @Cantidad = COUNT(1)
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
						--join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT
						--join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = IDDEPARTAMENTO
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
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 	
					AND P.ApoyoDepartamental = 1 			
					AND D.ID = @IdDerecho
	 ) AS P 
		
		SELECT @Cantidad
END


go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_PreguntaPATPrecargueEntidadesNacionales]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_PreguntaPATPrecargueEntidadesNacionales] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/11/2017
-- Modified date:	21/11/2017
-- Description:		Obtiene los datos del precargue de entidades nacionales por el derecho
-- =============================================
ALTER PROC [PAT].[C_PreguntaPATPrecargueEntidadesNacionales] ( @IdPregunta smallint, @IdMunicipio int)
AS
BEGIN
	select E.IdPreguntaPat,    M.Nombre AS Municipio , D.Nombre as Departamento,
	E.Dato1,E.Dato2,E.Dato3
	from  [PAT].[PreguntaPATPrecargueEntidadesNacionales] as E
	join Municipio as M on E.IdMunicipio =M.Id
	join Departamento as D on M.IdDepartamento = D.Id
	where E.IdPreguntaPat =  @IdPregunta 
	and E.IdMunicipio =@IdMunicipio
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosMunicipalesSeguimientoWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosMunicipalesSeguimientoWebService] AS'
go
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Modified date:	06/02/2018
-- Description:		Retorna los datos del seguimiento del tablero PAT Indicado, por derecho y Divipola
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosMunicipalesSeguimientoWebService] --1, 6, 5172
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaMunicipio int
)
AS
BEGIN
	SET NOCOUNT ON;	

		SELECT DISTINCT 
			P.Id AS IdPregunta, 
			P.IdTablero AS IdTablero,					
			R.Id as IdRespuesta,
			@DivipolaMunicipio as DivipolaMunicipio, 
			R.RespuestaIndicativa as RespuestaIndicativa, 
			R.RespuestaCompromiso as RespuestaCompromiso, 
			R.Presupuesto as Presupuesto,
			R.ObservacionNecesidad as ObservacionNecesidad,
			R.AccionCompromiso as AccionCompromiso,

			STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].RespuestaPATAccion AS ACCION
			WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Acciones,	
				
			STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].RespuestaPATPrograma AS PROGRAMA
			WHERE R.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Programas	

			,SM.IdSeguimiento
			,SM.CantidadPrimer AS CantidadSeguimientoPrimerSemestre
			,SM.CantidadSegundo AS CantidadSeguimientoSegundoSemestre
			,SM.PresupuestoPrimer AS PresupuestoSeguimientoPrimerSemestre
			,SM.PresupuestoSegundo AS PresupuestoSeguimientoSegundoSemestre
			,SM.Observaciones AS ObservacionesSeguimiento
			,SM.FechaSeguimiento

			,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].[SeguimientoProgramas] AS PROGRAMA
			WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento  and NumeroSeguimiento =1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSeguimiento
			
			--adicionales
			,SM.ObservacionesSegundo AS ObservacionesSegundoSeguimiento
			,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].[SeguimientoProgramas] AS PROGRAMA
			WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento  and NumeroSeguimiento =2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimiento
			--,CONVERT(decimal, ISNULL( REPLACE(isnull(SM.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(SM.CantidadSegundo,0), -1, 0),0)) as CantidadTotalSeguimiento
			--,CONVERT(decimal,  ISNULL( REPLACE(isnull(SM.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(SM.PresupuestoSegundo,0), -1, 0),0)) as PresupuestoTotalSeguimiento
			,SM.CantidadPrimer +  SM.CantidadSegundo as CantidadTotalSeguimiento
			,SM.PresupuestoPrimer + SM.PresupuestoSegundo as PresupuestoTotalSeguimiento
			FROM  [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id
			LEFT OUTER JOIN PAT.RespuestaPAT AS R on P.Id = R.IdPreguntaPAT AND R.IdMunicipio = [PAT].[fn_GetIdMunicipio](@DivipolaMunicipio)
			LEFT OUTER JOIN 
			(
				SELECT DISTINCT
				   [IdSeguimiento]
				  ,[IdTablero]
				  ,[IdPregunta]
				  ,[IdUsuario]
				  ,[FechaSeguimiento]
				  ,[CantidadPrimer]
				  ,[PresupuestoPrimer]
				  ,[CantidadSegundo]
				  ,[PresupuestoSegundo]
				  ,[Observaciones]
				  ,USU.IdDepartamento
				  ,USU.IdMunicipio
				  ,SEG.ObservacionesSegundo
			  FROM [PAT].[Seguimiento] SEG
			  INNER JOIN dbo.Usuario USU ON SEG.IdUsuario = USU.Id
			  WHERE USU.IdMunicipio = [PAT].[fn_GetIdMunicipio](@DivipolaMunicipio)
			) AS SM ON SM.IdTablero = P.IdTablero AND SM.IdPregunta = P.Id
			WHERE	P.Nivel = 3 
			AND D.Id = @IdDerecho	
			AND P.IdTablero	= @IdTablero	
			AND P.Activo = 1
			ORDER BY P.ID	
END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosDepartamentalesSeguimientoWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosDepartamentalesSeguimientoWebService] AS'
go
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		10/11/2017
-- Modified date:	06/02/2018
-- Description:		Retorna los datos del seguimiento del tablero PAT Departamental Indicado, por Divipola
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosDepartamentalesSeguimientoWebService] --1, 25
(
	@IdTablero int, 
	@DivipolaDepartamento int
)
AS
BEGIN
	SET NOCOUNT ON;	

		SELECT DISTINCT 
				P.Id AS IdPregunta, 
				P.IdTablero AS IdTablero,					
				R.Id as IdRespuesta,
				@DivipolaDepartamento as DivipolaDepartamento, 
				R.RespuestaIndicativa as RespuestaIndicativa, 
				R.RespuestaCompromiso as RespuestaCompromiso, 
				R.Presupuesto as Presupuesto,
				R.ObservacionNecesidad as ObservacionNecesidad,
				R.AccionCompromiso as AccionCompromiso,

				STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].RespuestaPATAccion AS ACCION
				WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Acciones,	
				
				STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].RespuestaPATPrograma AS PROGRAMA
				WHERE R.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Programas	

				,SM.IdSeguimiento
				,SM.CantidadPrimer AS CantidadSeguimientoPrimerSemestre
				,SM.CantidadSegundo AS CantidadSeguimientoSegundoSemestre
				,SM.PresupuestoPrimer AS PresupuestoSeguimientoPrimerSemestre
				,SM.PresupuestoSegundo AS PresupuestoSeguimientoSegundoSemestre
				,SM.Observaciones AS ObservacionesSeguimiento
				,SM.FechaSeguimiento

				,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].SeguimientoGobernacionProgramas AS PROGRAMA
				WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento and PROGRAMA.NumeroSeguimiento =1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSeguimiento
				
				--adicionales
				,SM.Observaciones AS ObservacionesSegundoSeguimiento
				,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].SeguimientoGobernacionProgramas AS PROGRAMA
				WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento and PROGRAMA.NumeroSeguimiento =2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimiento
				--, CONVERT(FLOAT, REPLACE(isnull(SM.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(SM.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimiento
				--, CONVERT(FLOAT,  REPLACE(isnull(SM.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(SM.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimiento
				,SM.CantidadPrimer +  SM.CantidadSegundo as CantidadTotalSeguimiento
				,SM.PresupuestoPrimer + SM.PresupuestoSegundo as PresupuestoTotalSeguimiento

			FROM  [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id
			LEFT OUTER JOIN PAT.RespuestaPAT AS R on P.Id = R.IdPreguntaPAT AND R.IdDepartamento = [PAT].[fn_GetIdDepartamento](@DivipolaDepartamento)
			LEFT OUTER JOIN 
			(
				SELECT DISTINCT
				   [IdSeguimiento]
				  ,[IdTablero]
				  ,[IdPregunta]
				  ,[IdUsuario]
				  ,[FechaSeguimiento]
				  ,[CantidadPrimer]
				  ,[PresupuestoPrimer]
				  ,[CantidadSegundo]
				  ,[PresupuestoSegundo]
				  ,[Observaciones]
				  ,USU.IdDepartamento
				  ,USU.IdMunicipio
				  ,SEG.ObservacionesSegundo
			  FROM [PAT].SeguimientoGobernacion SEG
			  INNER JOIN dbo.Usuario USU ON SEG.IdUsuario = USU.Id
			  WHERE USU.IdDepartamento = [PAT].[fn_GetIdDepartamento](@DivipolaDepartamento)
			) AS SM ON SM.IdTablero = P.IdTablero AND SM.IdPregunta = P.Id
			WHERE	P.Nivel = 2 
			AND P.IdTablero	= @IdTablero	
			AND P.Activo = 1
			ORDER BY P.ID	
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService] AS'
go
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla
-- Create date:		14/11/2017
-- Modified date:	06/02/2018
-- Description:		Retorna los datos del consolidado del seguimiento departamental 
--					del tablero PAT Indicado, por derecho y Divipola
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

	FROM [PAT].[PreguntaPAT] a
		INNER JOIN [PAT].[Derecho] b ON a.IdDerecho = b.Id
		LEFT OUTER JOIN [PAT].[RespuestaPAT] rm ON a.Id = rm.IdPreguntaPAT AND rm.IdMunicipio IN (select xx.Id FROM dbo.Municipio xx WHERE xx.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento))
		LEFT OUTER JOIN [PAT].[RespuestaPATDepartamento] rd ON a.Id = rd.IdPreguntaPAT AND rd.IdMunicipioRespuesta = rm.IdMunicipio
		--LEFT OUTER JOIN [PAT].[RespuestaPAT] rdd ON a.Id = rd.IdPreguntaPAT AND rdd.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento)
		LEFT OUTER JOIN [PAT].[Seguimiento] sm ON a.Id = sm.IdPregunta AND sm.IdUsuario = [PAT].[fn_GetIdUsuarioMunicipio](rm.IdMunicipio)
		LEFT OUTER JOIN [PAT].[SeguimientoGobernacion] sd ON a.Id = sd.IdPregunta AND sd.IdUsuarioAlcaldia = [PAT].[fn_GetIdUsuarioMunicipio](rm.IdMunicipio) AND sd.IdUsuario = [PAT].[fn_GetIdUsuarioDepartamento](rm.IdDepartamento)
	WHERE 
		a.IdTablero = @IdTablero
		AND b.Id = @IdDerecho
		AND a.Nivel = 3
		AND a.Activo = 1
	ORDER BY 
		a.Id ASC, rm.IdMunicipio ASC

END
go
