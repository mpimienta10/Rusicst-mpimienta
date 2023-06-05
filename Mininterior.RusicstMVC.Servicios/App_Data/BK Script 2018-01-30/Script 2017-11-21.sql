GO

if not exists (select * from sys.columns where name='DescripcionDetallada' and Object_id in (select object_id from sys.tables where name ='Derecho'))
begin 
	ALTER TABLE [PAT].Derecho ADD DescripcionDetallada varchar(max) null
end

GO

if not exists (select * from sys.columns where name='Descripcion'  and Object_id in (select object_id from sys.tables where name ='ConfiguracionDerechosPAT'))
begin 
	ALTER TABLE [PAT].[ConfiguracionDerechosPAT] ADD Descripcion varchar(max) null
end

GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		25/07/2017
-- Modified date:	25/07/2017 - Sergio Zúñiga
-- Description:		Obtiene todos los derechos activos
-- =============================================
ALTER PROC [PAT].[C_TodosDerechos] 
AS
BEGIN
	SELECT  D.Id, D.Descripcion, D.TextoExplicativoGOB, D.TextoExplicativoALC, D.DescripcionDetallada
	FROM  [PAT].[Derecho] D
	ORDER BY D.Descripcion
END

GO


-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Sergio Zúniga
-- Create date: 21/02/2017
-- Description:	Actualiza la información de la tabla de Configuracion de Derechos PAT
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [PAT].[U_DerechosPAT] 
	
	 @IdDerecho					INT
	,@TextoExplicativoGOB		VARCHAR(MAX) = NULL
	,@TextoExplicativoALC		VARCHAR(MAX) = NULL
	,@DescripcionDetallada   	VARCHAR(MAX) = NULL
  
AS

	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY
					UPDATE 
						PAT.Derecho
					SET 
						TextoExplicativoGOB = @TextoExplicativoGOB
					   ,TextoExplicativoALC = @TextoExplicativoALC
					   ,DescripcionDetallada = @DescripcionDetallada	
					WHERE 
						Id = @IdDerecho
					
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

	END

	GO

	-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Sergio Zúñiga
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Obtiene todos las configuraciones de acuerdo al derecho seleccionado
-- =============================================
ALTER PROC [PAT].[C_ConfiguracionDerechosPAT] 

( @IdDerecho tinyint)

AS
BEGIN
	SELECT C.Id, C.IdDerecho, C.Papel, C.Tipo, C.NombreParametro, C.ParametroValor, C.Texto, C.Descripcion
	FROM  [PAT].ConfiguracionDerechosPAT C
	WHERE C.IdDerecho = @IdDerecho
	ORDER BY C.IdDerecho
END


GO
/****** Object:  StoredProcedure [PAT].[U_ConfiguracionDerechosPAT]    Script Date: 20/11/2017 7:59:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Sergio Zúniga
-- Create date: 21/02/2017
-- Description:	Actualiza la información de la tabla de Configuracion de Derechos PAT
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [PAT].[U_ConfiguracionDerechosPAT] 
	
	 @Id			        INT
	,@NombreParametro		VARCHAR(50) = NULL
    ,@ParametroValor		VARCHAR(MAX) = NULL
	,@Texto					VARCHAR(MAX) = NULL
	,@Descripcion			VARCHAR(MAX) = NULL

AS

	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY
					UPDATE 
						PAT.ConfiguracionDerechosPAT
					SET 
						[NombreParametro] = @NombreParametro
					   ,[ParametroValor] =  @ParametroValor	
					   ,[Texto] =  @Texto
					   ,[Descripcion] = @Descripcion						
					WHERE 
						PAT.ConfiguracionDerechosPAT.Id = @Id
					
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

	END

	GO
/****** Object:  StoredProcedure [PAT].[I_ConfiguracionDerechoPAT]    Script Date: 20/11/2017 8:05:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================================
-- Autor: Equipo de desarrollo OIM - Sergio Zúniga																	 
-- Fecha creacion: 2017-03-08																		 
-- Descripcion: Inserta los datos en la tabla Configuración de Derechos PAT
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--=================================================================================================
 ALTER PROCEDURE [PAT].[I_ConfiguracionDerechoPAT] 

	@IdDerecho			INT,
	@Papel				VARCHAR(50),
	@Tipo				VARCHAR(50),
	@NombreParametro	VARCHAR(50),
	@ParametroValor		VARCHAR(MAX),
	@Texto				VARCHAR(MAX),
	@Descripcion		VARCHAR(MAX)

AS 
	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0
		DECLARE @esValido AS BIT = 1
	
		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY
					
					INSERT INTO PAT.ConfiguracionDerechosPAT (IdDerecho, Papel, Tipo, NombreParametro, ParametroValor, Texto, Descripcion)
					SELECT @IdDerecho, @Papel, @Tipo, @NombreParametro, @ParametroValor, @Texto, @Descripcion
					
					SELECT @respuesta = 'Se ha insertado el registro'
					SELECT @estadoRespuesta = 1

				COMMIT  TRANSACTION
				END TRY
				BEGIN CATCH
					ROLLBACK TRANSACTION
					SELECT @respuesta = ERROR_MESSAGE()
					SELECT @estadoRespuesta = 0
				END CATCH
			END

			SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

	END 

GO

UPDATE [dbo].[Category] SET [CategoryName] = 'Confirmación Solicitud de Usuario' WHERE Ordinal = 74

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXCategoria]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_LogXCategoria] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo - OIM (Christian Ospina)
-- Create date: 18-09-2017
-- Description:	Procedimiento que consulta la información del Log
-- =============================================
ALTER PROCEDURE [dbo].[C_LogXCategoria] 
	
	@IdCategoria INT = NULL,
	@UserName VARCHAR(255),
	@FechaInicio DATETIME,
	@FechaFin DATETIME

AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		 TOP 1000 [L].[LogID]
		,[L].[Title] Usuario
		,CAST([L].[Timestamp] as VARCHAR) Fecha
		,[C].[CategoryName] Categoria
		,[Message] UrlYBrowser		
	FROM 
		[dbo].[CategoryLog] CL
		INNER JOIN [dbo].[Log] L ON [CL].[LogID] = [L].[LogID]
		INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
	WHERE 
		(@UserName IS NULL OR ([L].[Title] = @UserName))
		AND (@IdCategoria IS NULL OR ([CL].[CategoryID] = @IdCategoria) AND [C].[Ordinal] <> 1)
		AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
	ORDER BY [L].[Timestamp] DESC
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcel_MunicipiosRetornosReubicaciones]') AND TYPE in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcel_MunicipiosRetornosReubicaciones] AS'

GO
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		14/11/2017
-- Modified date:	14/11/2017
-- Description:		Obtiene las respuestas de las pregutnas de retornos y reubicaciones del diligenciamiento municipal
-- =============================================
ALTER PROCEDURE [PAT].[C_DatosExcel_MunicipiosRetornosReubicaciones] -- [PAT].[C_DatosExcel_MunicipiosRetornosReubicaciones] 5172, 2
 (@IdMunicipio INT, @IdTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT DISTINCT  P.ID AS IdPregunta,
	M.Divipola AS DaneMunicipio,
	M.Nombre AS Municipio,
	M.IdDepartamento,
	P.Hogares,
	P.Personas,
	P.Sector,
	P.Componente,
	P.Comunidad,
	P.Ubicacion,
	P.MedidaRetornoReubicacion,
	P.IndicadorRetornoReubicacion,
	P.EntidadResponsable, 
	T.ID AS IdTablero,
	R.Id as IdRespuesta,
	R.Accion , 	
	R.Presupuesto
	FROM   [PAT].[PreguntaPATRetornosReubicaciones] P
	JOIN Municipio AS M ON P.IdMunicipio = M.Id
	INNER JOIN [PAT].[Tablero] T ON P.[IdTablero] = T.ID
	LEFT OUTER JOIN [PAT].[RespuestaPATRetornosReubicaciones] R ON R.IdMunicipio = @IdMunicipio and p.ID = R.[IdPreguntaPATRetornoReubicacion]	
	WHERE  T.ID = @IdTablero 
	and P.[IdMunicipio] = @IdMunicipio
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcel_MunicipiosReparacionColectiva]') AND TYPE in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcel_MunicipiosReparacionColectiva] AS'

GO
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		14/11/2017
-- Modified date:	14/11/2017
-- Description:		Obtiene las respuestas de las pregutnas de reparacion colectiva del diligenciamiento municipal
-- =============================================
ALTER PROCEDURE [PAT].[C_DatosExcel_MunicipiosReparacionColectiva] -- [PAT].[C_DatosExcel_MunicipiosReparacionColectiva] 411, 2
 (@IdMunicipio INT, @IdTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON	
	
	SELECT DISTINCT 
	P.ID AS IdPregunta, 
	MUN.Divipola AS DaneMunicipio,
	MUN.Nombre AS Municipio,
	MUN.IdDepartamento,
	P.IdMedida, 
	P.Sujeto, 
	P.MedidaReparacionColectiva, 
	M.Descripcion AS Medida, 
	T.ID AS IdTablero,
	R.ID as IdRespuesta,
	R.Accion, 
	R.Presupuesto
	FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
	JOIN Municipio AS MUN ON P.IdMunicipio = MUN.Id
	LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] AS R ON P.ID= R.[IdPreguntaPATReparacionColectiva] AND R.[IdMunicipio] = @IdMunicipio,
	[PAT].[Medida] M,
	[PAT].[Tablero] T
	WHERE	P.IDMEDIDA = M.ID 
	AND P.[IdMunicipio] = @IdMunicipio
	AND P.IDTABLERO = T.ID
	AND T.ID = @IdTablero
END

GO

