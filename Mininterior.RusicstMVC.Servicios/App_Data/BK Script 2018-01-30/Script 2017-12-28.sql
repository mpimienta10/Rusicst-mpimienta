-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC  [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldiasRC] --[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldiasRC] 5 , 1
(@IdDepartamento INT,@IdTablero INT)
AS
BEGIN	
		SELECT DISTINCT 		
		m.Descripcion Medida,
		p.Sujeto,
		p.MedidaReparacionColectiva,
		rcd.Id,
		p.IdTablero,
		rcd.IdMunicipioRespuesta,		
		p.Id as IdPreguntaRC,
		rc.Accion,
		rc.Presupuesto,
		rcd.AccionDepartamento,
		rcd.PresupuestoDepartamento
		,p.IdMunicipio
		,e.Nombre as Municipio
		,SMRC.AvancePrimer AS AvancePrimerSemestreAlcaldia
		,SMRC.AvanceSegundo AS AvanceSegundoSemestreAlcaldia
		,SGRC.AvancePrimer AS AvancePrimerSemestreGobernacion
		,SGRC.AvanceSegundo AS AvanceSegundoSemestreGobernacion
		FROM PAT.PreguntaPATReparacionColectiva p
		INNER JOIN PAT.Medida m ON p.IdMedida = m.Id
		INNER JOIN Municipio  e on e.Id = p.IdMunicipio and e.IdDepartamento = @IdDepartamento
		LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc ON rc.IdMunicipio = e.Id and rc.IdPreguntaPATReparacionColectiva=p.Id
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON rcd.IdMunicipioRespuesta = e.Id and rcd.IdPreguntaPATReparacionColectiva=p.Id
		LEFT OUTER JOIN [PAT].SeguimientoReparacionColectiva SMRC ON SMRC.IdTablero = p.IdTablero AND SMRC.IdUsuario = rc.IdUsuario AND SMRC.IdPregunta = rc.IdPreguntaPATReparacionColectiva
		LEFT OUTER JOIN [PAT].SeguimientoGobernacionReparacionColectiva SGRC ON SGRC.IdTablero = p.IdTablero AND SGRC.IdPregunta = RC.IdPreguntaPATReparacionColectiva AND SGRC.IdUsuarioAlcaldia = rc.IdUsuario
		where p.IdTablero = @IdTablero 		and p.Activo  = 1					
		ORDER BY p.Sujeto 	
END

go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	29/08/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC  [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldiasRR] --[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldiasRR] 1013, 1
( @IdDepartamento INT ,@IdTablero INT )
AS
BEGIN
	SELECT DISTINCT  P.Id AS IdPregunta
	,P.IdMunicipio
	,m.Nombre as Municipio
	,P.Hogares
	,P.Personas
	,P.Sector
	,P.Componente
	,P.Comunidad
	,P.Ubicacion
	,P.MedidaRetornoReubicacion
	,P.IndicadorRetornoReubicacion
	,P.EntidadResponsable
	,P.IdTablero
	,R.Id
	,R.Accion
	,R.Presupuesto
	,R.Accion as AccionDepartamento
	,R.Presupuesto as PresupuestoDepartamento
	,SM.AvancePrimer AS AvancePrimerSemestreAlcaldia
	,SM.AvanceSegundo AS AvanceSegundoSemestreAlcaldia
	,SG.AvancePrimer AS AvancePrimerSemestreGobernacion
	,SG.AvanceSegundo AS AvanceSegundoSemestreGobernacion
	FROM    PAT.PreguntaPATRetornosReubicaciones AS P
	left outer join pat.RespuestaPATRetornosReubicaciones as R on P.Id = R.IdPreguntaPATRetornoReubicacion 
	left outer join Municipio as M on R.IdMunicipio = M.Id and M.IdDepartamento = @IdDepartamento
	LEFT OUTER JOIN [PAT].[RespuestaPATDepartamentoRetornosReubicaciones] AS RD ON RD.IdMunicipioRespuesta = R.IdMunicipio AND RD.IdPreguntaPATRetornoReubicacion = R.IdPreguntaPATRetornoReubicacion 
	LEFT OUTER JOIN [PAT].SeguimientoRetornosReubicaciones SM ON SM.IdPregunta = R.IdPreguntaPATRetornoReubicacion AND SM.IdUsuario =r.IdUsuario
	LEFT OUTER JOIN [PAT].SeguimientoGobernacionRetornosReubicaciones SG ON SG.IdPregunta = SM.IdPregunta AND SG.IdUsuarioAlcaldia = SM.IdUsuario
	WHERE P.IdTablero = @IdTablero  and M.IdDepartamento = @IdDepartamento
	and p.Activo  = 1		
	ORDER BY P.Id
END



go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	14/11/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para una pregunta en especial
-- =============================================
ALTER PROC [PAT].[C_TableroSeguimientoConsolidadoDepartamento] --[PAT].[C_TableroSeguimientoConsolidadoDepartamento]  3, 375, 1
(	@IdTablero INT ,@IdUsuario INT ,@IdDerecho INT )
AS
BEGIN
	DECLARE  @IdDepartamento INT	
	select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

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
	FROM [PAT].PreguntaPAT as A
	--join [PAT].[PreguntaPATMunicipio] as PM on A.Id = PM.IdPreguntaPAT
	--join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = IDDEPARTAMENTO
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	join [PAT].[PreguntaPATMunicipio] as PM on a.Id = PM.IdPreguntaPAT
	LEFT OUTER JOIN [PAT].RespuestaPAT as RM on RM.IdPreguntaPAT = A.ID and RM.IdMunicipio = PM.IdMunicipio
	LEFT OUTER JOIN [PAT].Seguimiento as SM on SM.IdPregunta = a.ID and SM.IdUsuario = RM.IdUsuario 
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON RD.IdPreguntaPAT =A.Id  AND RD.IdUsuario = @IdUsuario and RD.IdMunicipioRespuesta = RM.IdMunicipio 	
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion as SG ON SG.IdPregunta=A.ID   AND SG.IdUsuarioAlcaldia = SM.IdUsuario
	WHERE  A.IdTablero = @IdTablero
	and A.Nivel = 3
	and E.ID = @IdDerecho
	AND A.ACTIVO = 1		
	GROUP BY
	B.Descripcion, C.Descripcion, A.PreguntaIndicativa, D.Descripcion, E.Descripcion, A.Id, E.Id

END



go

/*****************************************************************************************************
/Autor: Equipo OIM	 - Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Borra todos los derechos indicados en la gestion municipal de Otros Derechos											  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[D_SeguimientoDepartamentalOtrosDerechosMedidasDelete] 
		@IdSeguimientoMedida int
AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @IdSeguimiento int, @cantidadRegistros int
	
	BEGIN TRY		

		
		select top 1 @IdSeguimiento = IdSeguimiento from [PAT].[SeguimientoGobernacionOtrosDerechosMedidas] where IdSeguimientoMedidas = @IdSeguimientoMedida
		select @cantidadRegistros = count(1) from [PAT].[SeguimientoGobernacionOtrosDerechosMedidas] where IdSeguimiento = @IdSeguimiento
--		select @cantidadRegistros = count(1) from [PAT].[SeguimientoGobernacionOtrosDerechos] where IdSeguimiento = @IdSeguimiento
		

		if @cantidadRegistros >1
		begin
			delete [PAT].[SeguimientoGobernacionOtrosDerechosMedidas] where IdSeguimientoMedidas = @IdSeguimientoMedida
		end
		else	
		begin
			delete [PAT].[SeguimientoGobernacionOtrosDerechosMedidas] where IdSeguimiento = @IdSeguimiento
			delete [PAT].[SeguimientoGobernacionOtrosDerechos] where IdSeguimiento = @IdSeguimiento
		end				

		SELECT @respuesta = 'Se ha eliminado el registro'
		SELECT @estadoRespuesta = 3	
	END TRY
	BEGIN CATCH
		SELECT @respuesta = ERROR_MESSAGE()
		SELECT @estadoRespuesta = 0
	END CATCH	

select @respuesta as respuesta, @estadoRespuesta as estado




go


USE [rusicst_produccionPat]
GO
/****** Object:  StoredProcedure [PAT].[C_TableroSeguimientoDepartamentoRetornosReubicaciones]    Script Date: 28/12/2017 23:52:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	29/08/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDepartamentoRetornosReubicaciones] --[PAT].[C_TableroSeguimientoDepartamentoRetornosReubicaciones]  2, 181
(	@IdTablero INT,@IdMunicipio INT)
AS
BEGIN

	
	SELECT distinct A.[Id]
		  ,[Hogares]
		  ,[Personas]
		  ,[Sector]
		  ,[Componente]
		  ,[Comunidad]
		  ,[Ubicacion]
		  ,[MedidaRetornoReubicacion]
		  ,[IndicadorRetornoReubicacion]
		  ,[EntidadResponsable]
		  ,A.[IdDepartamento]
		  ,[IdMunicipio]
		  ,M.Nombre AS Municipio
		  ,[IdTablero]
		FROM [PAT].PreguntaPATRetornosReubicaciones as A
		JOIN Municipio AS M ON A.IdMunicipio = M.Id
		WHERE A.IdMunicipio= @IdMunicipio 	AND @IdTablero = @IdTablero
END



GO