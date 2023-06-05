if not exists (select * from sys.columns where name='TipoPlan'  and Object_id in (select object_id from sys.tables where name ='PlanMejoramiento'))
begin 	
print 'No hay columna'
	ALTER TABLE [PlanesMejoramiento].[PlanMejoramiento] ADD TipoPlan tinyint not null default(2)
end
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerListadoPlanes]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerListadoPlanes] AS'
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-23		
-- Fecha Modificacion: 2017-12-02																	 
-- Descripcion: Consulta la informacion del Listado de Planes de Mejoramiento
-- Modificacion: Se agrega parámetro TipoPlan para identificar el tipo de plan (v2 - 2, v3 - 3) y no romper
--				 Compatibilidad con planes viejos
-- ***************************************************************************************************
ALTER PROC [PlanesMejoramiento].[C_ObtenerListadoPlanes]
(
	@TipoPlan int
)
AS

BEGIN


SELECT A.IdPlanMejoramiento, A.Nombre, A.FechaLimite,
	STUFF(
         (SELECT DISTINCT ', ' + C.Titulo
          FROM PlanesMejoramiento.PlanMejoramiento AA
			INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta BB ON AA.IdPlanMejoramiento = BB.IdPlanMejoriamiento
			INNER JOIN dbo.Encuesta C ON C.Id = BB.IdEncuesta
			WHERE AA.IdPlanMejoramiento = A.IdPlanMejoramiento
          FOR XML PATH (''))
          , 1, 1, '')  AS URLList
	FROM PlanesMejoramiento.PlanMejoramiento A
	INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta B ON A.IdPlanMejoramiento = B.IdPlanMejoriamiento
	INNER JOIN dbo.Encuesta C ON C.Id = B.IdEncuesta
	WHERE
	A.TipoPlan = @TipoPlan
	GROUP BY A.IdPlanMejoramiento, A.Nombre, A.FechaLimite
	
	UNION ALL
	
	SELECT A.IdPlanMejoramiento, A.Nombre, A.FechaLimite, '' as URLList
	FROM PlanesMejoramiento.PlanMejoramiento A
	WHERE A.IdPlanMejoramiento NOT IN (
		SELECT XX.IdPlanMejoriamiento FROM PlanesMejoramiento.PlanMejoramientoEncuesta XX 
		WHERE XX.IdPlanMejoriamiento = A.IdPlanMejoramiento
	)
	AND A.TipoPlan = @TipoPlan

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerTipoPlanEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerTipoPlanEncuesta] AS'
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [PlanesMejoramiento].[C_ObtenerTipoPlanEncuesta]
(
	@IdEncuesta INT
)

AS

BEGIN

SELECT
A.TipoPlan
FROM [PlanesMejoramiento].[PlanMejoramiento] A
INNER JOIN [PlanesMejoramiento].[PlanMejoramientoEncuesta] B ON B.IdPlanMejoriamiento = A.IdPlanMejoramiento
WHERE
B.IdEncuesta = @IdEncuesta

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoActivacionInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoActivacionInsert] AS'
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-10-24																			  
-- Descripcion: Inserta la información de la activacion del plan												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoActivacionInsert]
(
	@IdPlanMejoramiento int,
	@FechaIni datetime,
	@FechaFin datetime,
	@MuestraPorc bit
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (EXISTS(SELECT * 
			FROM [PlanesMejoramiento].[PlanActivacionFecha] 
			WHERE [IdPlanMejoramiento]  = @IdPlanMejoramiento))
	BEGIN

		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE
				[PlanesMejoramiento].[PlanActivacionFecha]
			SET
				FechaInicio = @FechaIni
				,FechaFin = @FechaFin
				,bitShowPorcentaje = @MuestraPorc
			WHERE
				[IdPlanMejoramiento]  = @IdPlanMejoramiento

			SELECT @respuesta = 'Se ha re-activado el Plan de Mejoramiento.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = 'El Plan de Mejoramiento no se puede re-activar!'
			SELECT @estadoRespuesta = 0
		END CATCH

	END

	ELSE
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [PlanesMejoramiento].[PlanActivacionFecha] ([IdPlanMejoramiento], [bitShowPorcentaje], [FechaInicio], [FechaFin])
			VALUES (@IdPlanMejoramiento, @MuestraPorc, @FechaIni, @FechaFin)			

			SELECT @respuesta = 'Se ha activado el Plan de Mejoramiento.'
			SELECT @estadoRespuesta = 1
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = 'El Plan de Mejoramiento no se puede activar!'
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado
END

