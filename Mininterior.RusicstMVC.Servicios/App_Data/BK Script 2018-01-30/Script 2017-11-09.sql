GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerDatosActivacionPlanMejoramiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerDatosActivacionPlanMejoramiento] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Andrés Bonilla																	 
-- Fecha creacion: 2017-11-09																			 
-- Descripcion: Trae los datos de activación de un plan de mejoramiento o los datos por defecto en caso
--				de que el Plan no haya sido activado por primera vez.
--=====================================================================================================
ALTER PROC [PlanesMejoramiento].[C_ObtenerDatosActivacionPlanMejoramiento]
(
	@IdPlan INT
)

AS

BEGIN

	IF EXISTS(SELECT 1 FROM [PlanesMejoramiento].[PlanActivacionFecha] WHERE IdPlanMejoramiento = @IdPlan)
	BEGIN

		SELECT 
			[IdActivacionPlanFecha]
			,[IdPlanMejoramiento]
			,[bitShowPorcentaje]
			,[FechaInicio]
			,[FechaFin]
		FROM 
			[PlanesMejoramiento].[PlanActivacionFecha]
		WHERE
			IdPlanMejoramiento = @IdPlan

	END
	ELSE
	BEGIN

		SELECT 
			0 AS [IdActivacionPlanFecha]
			,@IdPlan AS [IdPlanMejoramiento]
			,CONVERT(bit, 0) AS [bitShowPorcentaje]
			,GETDATE() AS [FechaInicio]
			,GETDATE() AS [FechaFin]
	END

	
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DibujarAutoEvaluacionV1]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarAutoEvaluacionV1] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Andrés Bonilla																	 
-- Fecha creacion: 2017-11-09																			 
-- Descripcion: Trae el diseño de la Autoevaluacion de la V1 de la Autoevaluacion 
--				(Plan de Mejoramiento Viejo) de Rusicst por IdEncuesta e IdUsuario
--=====================================================================================================
ALTER PROC [dbo].[C_DibujarAutoEvaluacionV1]
(
	@IdEncuesta INT
	,@IdUsuario INT
)

AS

BEGIN

SELECT a.id                                       AS IdAutoevaluacion, 
       a.idencuesta, 
       a.idusuario, 
       a.calificacion, 
       a.recomendacion, 
       a.autoevaluacion, 
       a.acciones, 
       a.recursos, 
       CONVERT(VARCHAR, a.fechacumplimiento, 101) AS FechaCumplimiento, 
       a.responsable, 
       a.avance, 
       b.id                                       AS IdObjetivo, 
       b.texto                                    AS TextoObjetivo, 
       c.id                                       AS IdCategoria, 
       c.nombre                                   AS NombreCategoria, 
       d.id                                       AS IdProceso, 
       d.nombre                                   AS NombreProceso, 
       d.orden                                    AS OrdenProceso, 
       (SELECT Count(x.id) 
        FROM   [dbo].[autoevaluacion2] au
		 inner join [dbo].[objetivo] x 
		 on x.Id = au.IdObjetivo
               INNER JOIN [dbo].[categoria] xx 
                       ON xx.id = x.idcategoria 
        WHERE  xx.idproceso = d.id and x.Activo = 1 and xx.Activo = 1 and au.IdUsuario = a.IdUsuario and au.IdEncuesta = a.IdEncuesta)               AS CantidadObjetivosProceso, 
       (SELECT Count(x.id) 
        FROM   [dbo].[autoevaluacion2] au
		 inner join [dbo].[objetivo] x 
		 on x.Id = au.IdObjetivo 
        WHERE  x.idcategoria = c.id and x.Activo = 1 and au.IdUsuario = a.IdUsuario and au.IdEncuesta = a.IdEncuesta)              AS CantidadObjetivosCategoria 
FROM   [dbo].[autoevaluacion2] a 
       INNER JOIN [dbo].[objetivo] b 
               ON b.id = a.idobjetivo 
                  AND b.activo = 1 
       INNER JOIN [dbo].[categoria] c 
               ON c.id = b.idcategoria 
                  AND c.activo = 1 
       INNER JOIN [dbo].[proceso] d 
               ON d.id = c.idproceso 
                  AND d.activo = 1 
WHERE  a.idencuesta = @IdEncuesta 
       AND a.idusuario = @IdUsuario
ORDER  BY d.orden ASC 

END

GO