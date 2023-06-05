IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] AS'
go
-- =============================================  
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma Rodriguez - Andrés Bonilla - Andrés Bonilla  - John Betancourt A.
-- Create date:  29/08/2017  
-- Modified date: 29/01/2018  
-- Modified date: 29/08/2018  
-- Modified date: 30/08/2018
-- Modified date: 17/09/2019   
-- Description:  Obtiene informacion para el seguimiento para el detalle del consolidado para los municipios que respondieron la pregunta indicada  
-- =============================================  
ALTER PROC  [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] --2, 1600, 143  
--pat.C_TableroSeguimientoDetalleConsolidadoDepartamento 1,558,37  
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
 ,ISNULL(SG.CompromisoDefinitivo, -1) AS CompromisoDefinitivo  
 ,ISNULL(SG.PresupuestoDefinitivo, -1) AS PresupuestoDefinitivo  
 ,ISNULL(RD.Id, 0) AS IdRespuestaDept  
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
 WHERE   a.IdTablero= @IdTablero and A.ID = @IdPregunta and RM.Id IS NOT NULL  
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
 ,ISNULL(SG.CompromisoDefinitivo, -1) AS CompromisoDefinitivo  
 ,ISNULL(SG.PresupuestoDefinitivo, -1) AS PresupuestoDefinitivo  
 ,0 AS IdRespuestaDept  
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
 WHERE  a.IdTablero = @IdTablero  
 and a.Activo = 1  
 and a.NIVEL = 3   
 and M.IdDepartamento = @IdDepartamento  
 and R.Id is  null   
 and a.Id = @IdPregunta  
 order by M.Nombre asc  
END