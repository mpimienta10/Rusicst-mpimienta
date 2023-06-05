IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDepartamentoAvance]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDepartamentoAvance] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	14/11/2017
-- Modified date:	01/06/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos y los datos de ajuste de planeacion
-- =============================================
alter PROC  [PAT].[C_TableroSeguimientoDepartamentoAvance]-- [PAT].[C_TableroSeguimientoDepartamentoAvance] 431, 1
( @IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare  @IdDepartamento int
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

		---TRAE LA INFORMACION DEL LA GESTION DE LA GOBERNACION
		SELECT A.Derecho
		--,CONVERT(INT, ROUND(CASE A.ri WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.ri)) * 100) END, 0)) AS AvanceCompromiso
		--,CONVERT(INT, ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0)) AS AvancePresupuesto
		,ISNULL(CONVERT(INT, CASE WHEN ROUND(CASE A.ri WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.ri)) * 100) END, 0) > 100 THEN 100 ELSE ROUND(CASE A.ri WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.ri)) * 100) END, 0) END),0) AS AvanceCompromiso
		,ISNULL(CONVERT(INT, CASE WHEN ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0) > 100 THEN 100 ELSE ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0) END),0) AS AvancePresupuesto
		FROM (
			SELECT
			' Gestión Gobernación' as Derecho
			,SUM(case when R.RespuestaIndicativa is null then 0 else r.RespuestaIndicativa end) as ri
			--,SUM(case when R.Presupuesto is null then 0 else r.Presupuesto end) as pres
			,SUM(case when C.PresupuestoDefinitivo is null then 0 else C.PresupuestoDefinitivo end) as pres
			,(SUM(case when C.CantidadPrimer is null or C.CantidadPrimer = -1 then 0 else C.CantidadPrimer end) + SUM(case when C.CantidadSegundo is null or C.CantidadSegundo = -1 then 0 else C.CantidadSegundo end)) as sumc1c2
			,(SUM(case when C.PresupuestoPrimer is null or C.PresupuestoPrimer = -1 then 0 else C.PresupuestoPrimer end) + SUM(case when C.PresupuestoSegundo is null or C.PresupuestoSegundo = -1 then 0 else C.PresupuestoSegundo end)) as sump1p2
			FROM    PAT.PreguntaPAT AS P
			join pat.PreguntaPATDepartamento as PD on P.Id = PD.IdPreguntaPAT and PD.IdDepartamento = @IdDepartamento
			INNER JOIN PAT.Derecho as DERECHO ON P.IdDerecho = DERECHO.Id
			LEFT OUTER JOIN PAT.RespuestaPAT as R ON P.Id = R.IdPreguntaPAT and R.IdDepartamento = @IdDepartamento
			--LEFT OUTER JOIN pat.SeguimientoGobernacion AS C ON C.IdPregunta = P.Id AND C.IdUsuario = @IdUsuario and C.IdUsuarioAlcaldia = 0
			LEFT OUTER JOIN pat.Seguimiento AS C ON C.IdPregunta = P.Id AND C.IdUsuario = @IdUsuario
			LEFT OUTER JOIN Usuario as U on C.IdUsuario = U.Id and  U.IdTipoUsuario = 7 and U.Activo = 1 and U.IdEstado = 5
			WHERE P.IdTablero = @IdTablero 
			AND P.Nivel = 2 
			AND P.Activo= 1		
		UNION ALL
		--TRAE LA GESION DE LA GESTION DE LOS DERECHOS DE LAS PREGUNTAS DE LOS MUNICIPIOS		
			SELECT  D.Descripcion as Derecho
			--,SUM(case when RD.RespuestaCompromiso is null then 0 else RD.RespuestaCompromiso end) as ri
			--,SUM(case when RD.Presupuesto is null then 0 else RD.Presupuesto end) as pres
			,SUM(case when SG.CompromisoDefinitivo is null then 0 else SG.CompromisoDefinitivo end) as ri
			,SUM(case when SG.PresupuestoDefinitivo is null then 0 else SG.PresupuestoDefinitivo end) as pres
			,(SUM(case when SG.CantidadPrimer is null or SG.CantidadPrimer = -1 then 0 else SG.CantidadPrimer end) + SUM(case when SG.CantidadSegundo is null or SG.CantidadSegundo = -1 then 0 else SG.CantidadSegundo end)) as sumc1c2
			,(SUM(case when SG.PresupuestoPrimer is null or SG.PresupuestoPrimer = -1 then 0 else SG.PresupuestoPrimer end) + SUM(case when SG.PresupuestoSegundo is null or SG.PresupuestoSegundo = -1 then 0 else SG.PresupuestoSegundo end)) as sump1p2
			FROM    PAT.PreguntaPAT AS P
			LEFT OUTER JOIN [PAT].RespuestaPAT RM ON P.Id =RM.IdPreguntaPAT and RM.IdDepartamento = @IdDepartamento and IdMunicipio is not null --para que tome las respuestas de alcaldias
			LEFT OUTER JOIN Municipio AS M ON RM.IdMunicipio = M.ID	
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id	 
			LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON P.Id=RD.IdPreguntaPAT  AND RD.IdUsuario = @IdUsuario and RD.IdMunicipioRespuesta = RM.IdMunicipio 
			LEFT OUTER JOIN [PAT].seguimiento SM ON P.ID =SM.IdPregunta AND SM.IdTablero = P.IdTablero AND  SM.IdUsuario = RM.IdUsuario
			LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  P.ID =SG.IdPregunta  AND P.IdTablero=SG.IdTablero  AND RM.IdUsuario =SG.IdUsuarioAlcaldia			
			WHERE	P.NIVEL = 3 
			and P.IdTablero = @IdTablero  and p.Activo = 1
			group by D.Descripcion	
							
	) AS A
	order by Derecho
END

go


----solo seguimiiento de alacaldias tablero 1
update PAT.Seguimiento set CompromisoDefinitivo = R.RespuestaCompromiso, PresupuestoDefinitivo = R.Presupuesto
--select P.IdDerecho, P.PreguntaIndicativa, R.RespuestaCompromiso, R.Presupuesto, U.UserName  
from PAT.Seguimiento  as S
join PAT.RespuestaPAT as R on S.IdPregunta = R.IdPreguntaPAT and  S.IdUsuario = R.IdUsuario 
join PAT.PreguntaPAT as P on R.IdPreguntaPAT = P.Id
join Usuario as U on S.IdUsuario = U.Id and U.IdTipoUsuario = 2 and U.Activo = 1 and U.IdEstado = 5
where P.IdTablero = 1 and Nivel = 3

----solo seguimiiento de gobernaciones preguntas propias tablero 1
update PAT.Seguimiento set CompromisoDefinitivo = RM.RespuestaCompromiso, PresupuestoDefinitivo = RM.Presupuesto
FROM [PAT].PreguntaPAT A		
LEFT OUTER JOIN [PAT].RespuestaPAT RM ON A.Id =RM.IdPreguntaPAT
join Departamento as Dep on RM.IdDepartamento= Dep.Id
LEFT OUTER JOIN [PAT].Seguimiento SG ON  A.ID =SG.IdPregunta and SG.IdUsuario = (select Id from Usuario as U where  U.IdTipoUsuario = 7 and U.Activo = 1 and U.IdEstado = 5  and RM.IdDepartamento = U.IdDepartamento)		
WHERE A.IdTablero = 1 and  A.Activo = 1 AND A.NIVEL = 2 


----solo seguimiiento de gobernaciones de consolidado tablero 1
update [PAT].SeguimientoGobernacion set CompromisoDefinitivo = RD.RespuestaCompromiso, PresupuestoDefinitivo = RD.Presupuesto
--select * 
from [PAT].SeguimientoGobernacion as S
join PAT.PreguntaPAT as P on S.IdPregunta = P.Id
join PAT.RespuestaPATDepartamento as RD on S.IdPregunta = RD.IdPreguntaPAT and S.IdUsuario = RD.IdUsuario and S.IdUsuarioAlcaldia =  (select Id from Usuario where IdMunicipio = RD.IdMunicipioRespuesta and Activo = 1 and IdEstado = 5 and IdTipoUsuario = 2) 
join Usuario as U on RD.IdUsuario = U.Id
where P.Activo = 1 and P.Nivel = 3 and P.IdTablero =1 	

go