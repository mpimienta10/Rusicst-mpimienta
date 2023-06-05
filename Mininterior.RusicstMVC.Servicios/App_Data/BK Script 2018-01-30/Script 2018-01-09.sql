
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_EncuestaUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_EncuestaUpdate] AS'

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--====================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																			  
-- Fecha creacion: 2017-03-10																			  
-- Descripcion: Actualiza un registro en la encuesta e inserta todos los tipos de reporte 																  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'
-- Modifica:  John Betancourt A. OIM				  
-- Descripción: Adicionar campo de Prueba							  
--====================================================================================================
ALTER PROC [dbo].[U_EncuestaUpdate] 

	@IdEncuesta					INT,
	@Titulo						VARCHAR(255),
	@Ayuda						VARCHAR(MAX) = NULL,
	@FechaInicio				DATETIME,
	@FechaFin					DATETIME,
	@IsDeleted					BIT = 0,
	@TipoEncuesta				VARCHAR(255),
	@EncuestaRelacionada		INT = NULL,
	@AutoevaluacionHabilitada	BIT,
	@TipoReporte				VARCHAR(128),
	@IsPrueba					INT = 0

AS 

	-- Parámetros para el manejo de la respuesta
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	-- Obtener Id del tipo de encuesta
	DECLARE @IdTipoEncuesta INT

	SELECT @IdTipoEncuesta = Id
	FROM TipoEncuesta
	WHERE Nombre = @TipoEncuesta

	SET @IdTipoEncuesta = ISNULL(@IdTipoEncuesta, 0)

	IF (EXISTS(SELECT * FROM encuesta WHERE [titulo]  = @Titulo AND [id] <> @IdEncuesta) OR @IdTipoEncuesta = 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Título ya se encuentra asignado a otra Encuesta o el tipo de encuesta no existe.'
	END

	IF(@IsPrueba = 1)
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM [dbo].[Encuesta] WHERE [Id] = @IdEncuesta AND [IsPrueba] = 1)
			BEGIN
				IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)))
				BEGIN
					SET @esValido = 0
					SET @respuesta += 'No es posible cambiar el tipo de encuesta a prueba. Se encontraron respuestas asociadas.'
				END
			END
	END

	-- Parámetros para el manejo de los Tipos de Reporte
	DECLARE @i INT
	DECLARE @idTipoReporte INT
	DECLARE @numrows INT

	-- Inserta en la tabla temporal los diferentes Ids de Tipos de Reporte
	DECLARE @Temp TABLE (Id INT,splitdata VARCHAR(128))
	INSERT @Temp SELECT ROW_NUMBER() OVER(ORDER BY splitdata) Id, splitdata FROM dbo.Split(@TipoReporte, ','); 

	SET @i = 1
	SET @numrows = (SELECT COUNT(*) FROM @Temp)	

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			-- Inserta la encuesta
			UPDATE 
				[dbo].[Encuesta]
			SET    
				[Titulo] = @Titulo, [Ayuda] = @Ayuda, [FechaInicio] =  @FechaInicio , [FechaFin] = @FechaFin, [IsDeleted] = @IsDeleted, [IdTipoEncuesta] = @IdTipoEncuesta, [EncuestaRelacionada] = @EncuestaRelacionada, [AutoevaluacionHabilitada] = @AutoevaluacionHabilitada, [IsPrueba] = @IsPrueba
			WHERE  
				[Id] = @IdEncuesta	

			-- Elimina los roles relacionados a la encuesta
			DELETE [Roles].[RolEncuesta]
			WHERE [IdEncuesta] = @IdEncuesta
			
			-- Inserta los tipos de reporte
			IF @numrows > 0
				WHILE (@i <= (SELECT MAX(Id) FROM @Temp))
				BEGIN

					INSERT INTO [Roles].[RolEncuesta] ([IdEncuesta], [IdRol])
					SELECT @IdEncuesta, (SELECT splitdata FROM @Temp WHERE Id = @i)

					SET @i = @i + 1
				END

		SELECT @respuesta = 'Se ha actualizado el registro'
		SELECT @estadoRespuesta = 2
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado			

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_SeccionDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_SeccionDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--*****************************************************************************************************
-- Autor: John Betancourt A. OIM																		  
-- Fecha creacion: 2017-06-27
-- Descripcion: Actualiza la información de la Seccion												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--*****************************************************************************************************

ALTER PROCEDURE [dbo].[D_SeccionDelete] 

	@Id INT

AS 

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0 
	DECLARE @esValido AS BIT = 1
	

	IF EXISTS(SELECT 1 FROM [dbo].[Encuesta] WHERE [Id] = (select idEncuesta from Seccion where Id = @Id ) AND [IsPrueba] = 0)
		BEGIN
			IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @Id))
				BEGIN
					SET @esValido = 0
					SET @respuesta += 'No es posible eliminar el registro. Se encontraron datos asociados.'
				END
			ELSE
				EXEC D_ContenidoSeccionDelete @Id		
		END
	ELSE
	BEGIN
		EXEC D_ContenidoSeccionDelete @Id
	END

	IF(@esValido = 1) BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [dbo].Seccion
						WHERE [Id] = @Id

			SELECT @respuesta = 'Se ha eliminado el registro'
			SELECT @estadoRespuesta = 3
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/11/2017
-- Modified date:	28/11/2017
-- Description:		Obtiene informacion para el seguimiento para el detalle del consolidado para los municipios que respondieron la pregunta indicada
-- =============================================
ALTER PROC  [PAT].[C_SeguimientoDepartamentoPorMunicipio] --pat.C_SeguimientoDepartamentoPorMunicipio 5172 ,246
( @IdMunicipio INT ,@IdPregunta INT )
AS
BEGIN
	declare @idDepartamento int
	select @idDepartamento = IdDepartamento from Municipio where Id =@IdMunicipio
	SELECT DISTINCT 
	 A.Id AS IdPRegunta
	,A.PreguntaIndicativa 
	,RM.IdMunicipio
	,M.Nombre AS Municipio 	
	,RD.RespuestaCompromiso AS CompromisoG
	,RD.Presupuesto as PresupuestoG
	,ISNULL(SG.CantidadPrimer, 0) AS CantidadPrimerSemestreG
	,ISNULL(SG.CantidadSegundo, 0) AS CantidadSegundoSemestreG	
	,ISNULL(SG.PresupuestoPrimer, 0) AS PresupuestoPrimerSemestreG
	,ISNULL(SG.PresupuestoSegundo, 0) AS PresupuestoSegundoSemestreG	
	,ISNULL(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, 0, 0), 0) as CompromisoTotalG
	,ISNULL(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, 0, 0), 0) as PresupuestoTotalG
	FROM [PAT].PreguntaPAT A
	LEFT OUTER JOIN [PAT].RespuestaPAT RM ON A.Id =RM.IdPreguntaPAT and RM.IdDepartamento = @IdDepartamento and IdMunicipio is not null --para que tome las respuestas de alcaldias
	LEFT OUTER JOIN Municipio AS M ON RM.IdMunicipio = M.ID
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON A.Id=RD.IdPreguntaPAT   and RD.IdMunicipioRespuesta = RM.IdMunicipio --AND RD.IdUsuario = @IdUsuario
	LEFT OUTER JOIN [PAT].seguimiento SM ON A.ID =SM.IdPregunta AND SM.IdTablero = A.IdTablero AND  SM.IdUsuario = RM.IdUsuario
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  A.ID =SG.IdPregunta  AND A.IdTablero=SG.IdTablero  AND RM.IdUsuario =SG.IdUsuarioAlcaldia --[PAT].[fn_GetIdUsuario](RM.ID_ENTIDAD)
	WHERE A.ID = @IdPregunta and RM.IdMunicipio = 	@IdMunicipio

END
GO
