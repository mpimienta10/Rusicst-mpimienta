--------Liliana------------------------

update SubRecurso set  Nombre='Planeación Municipal' where IdRecurso = 14 and Id = 60
update SubRecurso set  Nombre='Planeación Departamental' where IdRecurso = 14 and Id = 57
update SubRecurso set  Nombre='Seguimiento Semestral Municipal' where IdRecurso = 14 and Id = 58
update SubRecurso set  Nombre='Seguimiento Semestral Departamental' where IdRecurso = 14 and Id = 59
go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	20/11/2017
-- Description:		Retorna los tableros de nivel 3 que hacen referencia a la gestion MUNICIPAL que ya no estan vigentes
-- ==========================================================================================

ALTER PROC [PAT].[C_TodosTablerosMunicipiosCompletos]
AS
BEGIN
	select
	A.[Id],
	B.[VigenciaInicio],
	B.[VigenciaFin], 
	YEAR(B.[VigenciaInicio])+1 AS Planeacion
	from
	[PAT].[Tablero] A,
	[PAT].[TableroFecha] B
	where
	A.[Id]=B.[IdTablero]
	and B.[Nivel]=3
	and B.[Activo]=1
	and  B.[VigenciaFin] < GETDATE()
END

go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	20/11/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que estan vigentes
-- ==========================================================================================
ALTER PROC [PAT].[C_TodosTablerosMunicipiosPorCompletar]
AS
BEGIN
	select  A.Id,  B.Vigenciainicio, B.VigenciaFin , 	YEAR(B.[VigenciaInicio])+1 AS Planeacion
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=3
	and B.[Activo]=1
	and GETDATE() >= B.Vigenciainicio and GETDATE() <= B.[VigenciaFin]
END

go


CREATE TABLE [PAT].[FuentePresupuesto](
	[Id] [int] NOT NULL,
	[Descripcion] [nvarchar](255) not NULL,
	Activo bit not null
 CONSTRAINT [PK_FuentePresupuesto] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
---otra---
CREATE TABLE [PAT].[RespuestaPATFuentePresupuesto](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdRespuestaPAT] [int] NOT NULL,
	[IdFuentePresupuesto] [int] NOT NULL,	
 CONSTRAINT [PK_RespuestaPATFuentePresupuesto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
------otrta

ALTER TABLE PAT.RespuestaPATFuentePresupuesto ADD CONSTRAINT
	FK_RespuestaPATFuentePresupuesto_RespuestaPAT FOREIGN KEY
	(
	IdRespuestaPAT
	) REFERENCES PAT.RespuestaPAT
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
go	
ALTER TABLE PAT.RespuestaPATFuentePresupuesto ADD CONSTRAINT
	FK_RespuestaPATFuentePresupuesto_FuentePresupuesto FOREIGN KEY
	(
	IdFuentePresupuesto
	) REFERENCES PAT.FuentePresupuesto
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_FuentePresupuesto]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_FuentePresupuesto] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		20/07/2017
-- Modified date:	20/11/2017
-- Description:		Retorna las fuentes de financiacion para el diligenciamiento municipal
-- ==========================================================================================

ALTER procedure [PAT].[C_FuentePresupuesto] 
AS
BEGIN
	SELECT  M.Id, M.Descripcion, Activo
	FROM  [PAT].FuentePresupuesto as M
	where Activo = 1
	ORDER BY M.Descripcion	
END
go
if not exists (select * from sys.columns where name='ObservacionPresupuesto' and Object_id in (select object_id from sys.tables where name ='RespuestaPAT'))
begin 
	ALTER TABLE [PAT].[RespuestaPAT] ADD ObservacionPresupuesto varchar(max) null
end
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_FuentePresupuestoPATDiligenciamiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_FuentePresupuestoPATDiligenciamiento] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		20/11/2017
-- Modified date:	20/11/2017
-- Description:		Retorna las fuentes de financiacion para el diligenciamiento municipal de un municipio
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_FuentePresupuestoPATDiligenciamiento]
( @IdRespuesta as INT)
AS
BEGIN
	SET NOCOUNT ON;		
	SELECT	R.Id, R.IdRespuestaPAT, R.IdFuentePresupuesto,A.Descripcion
	FROM	[PAT].RespuestaPATFuentePresupuesto (NOLOCK) AS R
	JOIN	[PAT].[FuentePresupuesto] (NOLOCK) AS A ON R.IdFuentePresupuesto = A.Id
	WHERE	R.IdRespuestaPAT = @IdRespuesta
END
go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_RespuestaFuentePresupuestoInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_RespuestaFuentePresupuestoInsert] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-11-20																			  
/Descripcion: Inserta inforamcio de las fuentes del presupuesto en el diligenciamiento												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_RespuestaFuentePresupuestoInsert] 
           @IdRespuesta int,
           @IdFuentePresupuesto int
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].RespuestaPATFuentePresupuesto
           ([IdRespuestaPAT]
           ,[IdFuentePresupuesto])
			VALUES
           (@IdRespuesta,
            @IdFuentePresupuesto)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[D_RespuestaPATFuentePresupuesto]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[D_RespuestaPATFuentePresupuesto] AS'
go
--====================================================================================================
-- Autor: Equipo de desarrollo OIM - vilma rodriguez																	  
-- Fecha creacion: 2017-11-20																			  
-- Descripcion: elimina un registro de la tabla de RespuestaPATFuentePresupuesto PAT
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--====================================================================================================
ALTER PROCEDURE [PAT].[D_RespuestaPATFuentePresupuesto] 
	@Id	 INT
AS 
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF(@esValido = 1) 
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY
				DELETE FROM PAT.RespuestaPATFuentePresupuesto
					WHERE Id = @Id		
		
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
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	20/11/2017
-- Description:		Trae el listado de todas las preguntas municipales del tablero, derecho y municipio indicado  
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroMunicipio] --[PAT].[C_TableroMunicipio] null, 1, 20, 411 , 1,3
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		IDPREGUNTA SMALLINT,IDDERECHO SMALLINT,IDCOMPONENTE TINYINT,IDMEDIDA SMALLINT,NIVEL TINYINT,
		PREGUNTAINDICATIVA NVARCHAR(500),IDUNIDADMEDIDA TINYINT,PREGUNTACOMPROMISO NVARCHAR(500),APOYODEPARTAMENTAL BIT,
		APOYOENTIDADNACIONAL BIT,ACTIVO BIT,DERECHO NVARCHAR(50),COMPONENTE NVARCHAR(100),MEDIDA NVARCHAR(50),
		UNIDADMEDIDA NVARCHAR(100),IDTABLERO TINYINT,IDENTIDAD INT,ID INT,RESPUESTAINDICATIVA INT,
		RESPUESTACOMPROMISO INT,PRESUPUESTO MONEY,OBSERVACIONNECESIDAD NVARCHAR(1000),ACCIONCOMPROMISO NVARCHAR(1000), 
		RequiereAdjunto bit,MensajeAdjunto NVARCHAR(max),ExplicacionPregunta NVARCHAR(max),NombreAdjunto NVARCHAR(200), ObservacionPresupuesto NVARCHAR(max)
		)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize 

	SET @ORDEN = @sortOrder
	SET @ORDEN = 'P.ID'
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	Declare @IdMunicipio int
	SELECT @IdMunicipio =  U.[IdMunicipio] FROM [dbo].[Usuario] (NOLOCK) U WHERE U.ID = @IdUsuario
	
	SET @SQL = 'SELECT 	DISTINCT
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO,
		RequiereAdjunto,MensajeAdjunto,ExplicacionPregunta,NombreAdjunto,ObservacionPresupuesto
		FROM (
		SELECT DISTINCT TOP (@TOP) LINEA,
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO,
		RequiereAdjunto,MensajeAdjunto,ExplicacionPregunta,NombreAdjunto,ObservacionPresupuesto
	FROM ( 
    SELECT DISTINCT row_number() OVER (ORDER BY '+ @ORDEN +') AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID ,
						R.RespuestaIndicativa, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO,
						P.RequiereAdjunto,
						P.MensajeAdjunto,
						P.ExplicacionPregunta,
						R.NombreAdjunto,
						R.ObservacionPresupuesto
				FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdMunicipio =  @IdMunicipio ,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T,
						[PAT].[PreguntaPATMunicipio] as PM
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND P.ID = PM.IdPreguntaPAT and PM.IdMunicipio = @IdMunicipio
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 					
					AND D.ID = @IdDerecho'	
	SET @SQL =@SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY LINEA ) AS T'
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IdMunicipio INT,@IdDerecho INT'
		
	--PRINT @SQL
	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IdMunicipio=@IdMunicipio, @IdDerecho=@IdDerecho
	SELECT * from @RESULTADO
END
go
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-29																			  
/Descripcion: Inserta la información del tablero municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_PreguntaPatInsert] 

		@IdDerecho				SMALLINT,
		@IdComponente			INT,
		@IdMedida				INT,
		@Nivel					TINYINT,
		@PreguntaIndicativa		NVARCHAR(500),
		@IdUnidadMedida			TINYINT,
		@PreguntaCompromiso		NVARCHAR(500),
		@ApoyoDepartamental		BIT,
		@ApoyoEntidadNacional	BIT,
		@Activo					BIT,
		@IdTablero				TINYINT,
		@IdsNivel				NVARCHAR(MAX),
		@RequiereAdjunto		BIT,
		@MensajeAdjunto			NVARCHAR(MAX),
		@ExplicacionPregunta	NVARCHAR(MAX),
		@CodigosDane			NVARCHAR(MAX)	
AS 	
	
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1	
	DECLARE @id INT	
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
			INSERT INTO [PAT].[PreguntaPAT]
					   ([IdDerecho]
					   ,[IdComponente]
					   ,[IdMedida]
					   ,[Nivel]
					   ,[PreguntaIndicativa]
					   ,[IdUnidadMedida]
					   ,[PreguntaCompromiso]
					   ,[ApoyoDepartamental]
					   ,[ApoyoEntidadNacional]
					   ,[Activo]
					   ,[IdTablero]
					   ,RequiereAdjunto
					   ,MensajeAdjunto
					   ,ExplicacionPregunta)
				 VALUES
					   (@IdDerecho
					   ,@IdComponente
					   ,@IdMedida
					   ,@Nivel
					   ,@PreguntaIndicativa
					   ,@IdUnidadMedida
					   ,@PreguntaCompromiso
					   ,@ApoyoDepartamental
					   ,@ApoyoEntidadNacional
					   ,@Activo
					   ,@IdTablero
					   ,@RequiereAdjunto
					   ,@MensajeAdjunto
					   ,@ExplicacionPregunta )

			SELECT @id = SCOPE_IDENTITY()
			DECLARE @IsNumeric INT

			--=========================================================
			-- Para los casos que vengan los ID's que se seleccionaron
			--=========================================================
			IF(LEN(@IdsNivel) > 0)
				BEGIN
					--============================================================================================================
					-- Nivel 1 = Nacional, Nivel 2 = Departamentos, Nivel 3 = Municipios

					-- De acuerdo al nivel ejecuta el cursor que hace lo siguiente:

					-- Hace un rompimiento en la variable @IdsNivel tipo varchar y la separa de acuerdo a las comas (,). trae
					-- los municipios o los departamentos de acuerdo al nivel de la pregunta, realiza la inserción de los Id's en 
					-- la tabla departamentos-pregunta o municipios-pregunta. En caso que el nivel sea 3, no hace nada.
					--=============================================================================================================
					DECLARE @IdNivel INT
					DECLARE Nivel_Cursor CURSOR FOR  

						SELECT 
							splitdata 
						FROM 
							[dbo].[Split](@IdsNivel, ',')

					OPEN Nivel_Cursor 

					FETCH NEXT FROM Nivel_Cursor 
					INTO @IdNivel 

					WHILE @@FETCH_STATUS = 0  
						BEGIN  
							--========================================================================
							-- Valida si el ID es un número colocando 1 para verdadero y 0 para falso
							--========================================================================
							SET @IsNumeric = [dbo].[isReallyNumeric](@IdNivel)

							IF(@IsNumeric = 1)
								BEGIN
									--========================================
									-- Inserta los departamentos relacionados
									--========================================
									IF(@Nivel = 2)
										BEGIN
											IF(NOT EXISTS (SELECT [Id] FROM [PAT].[PreguntaPATDepartamento] WHERE [IdPreguntaPAT] = @id AND [IdDepartamento] = @IdNivel))
												BEGIN
													IF(EXISTS (SELECT * FROM [dbo].[Departamento] WHERE [Id] = @IdNivel))
														INSERT INTO [PAT].[PreguntaPATDepartamento]([IdPreguntaPAT],[IdDepartamento]) VALUES (@id, @IdNivel)
												END
										END
									--========================================
									-- Inserta los municipios relacionados
									--========================================
									ELSE IF(@Nivel = 3)	
										BEGIN
											IF(NOT EXISTS (SELECT [Id] FROM [PAT].[PreguntaPATMunicipio] WHERE [IdPreguntaPAT] = @id AND [IdMunicipio] = @IdNivel))
												BEGIN
													IF(EXISTS (SELECT * FROM [dbo].[Municipio] WHERE [Id] = @IdNivel))
														INSERT INTO [PAT].[PreguntaPATMunicipio]([IdPreguntaPAT],[IdMunicipio]) VALUES (@id, @IdNivel)
												END
										END
								END
							
							FETCH NEXT FROM Nivel_Cursor 
							INTO @IdNivel 

						END; 
					    
					CLOSE Nivel_Cursor;  
					DEALLOCATE Nivel_Cursor; 
				
					--===================================================================
				END

			IF (LEN(@CodigosDane) > 0)
				BEGIN
					DECLARE @IdCodDane VARCHAR(100), @IdUbicacionGeografica INT
					DECLARE Dane_Cursor CURSOR FOR  

						SELECT 
							splitdata 
						FROM 
							[dbo].[Split](@CodigosDane, ',')

					OPEN Dane_Cursor 

					FETCH NEXT FROM Dane_Cursor 
					INTO @IdCodDane 

					WHILE @@FETCH_STATUS = 0  
						BEGIN  
									
							-- Revisa que exista la ubicación geográfica en los departamentos
							IF(@Nivel = 2)
								SET @IdUbicacionGeografica = (SELECT [Id] FROM [dbo].[Departamento] WHERE [Divipola] = LTRIM(RTRIM(@IdCodDane)))

							-- Revisa que exista la ubicación geográfica en los municipios
							ELSE IF(@Nivel = 3)	
								SET @IdUbicacionGeografica = (SELECT [Id] FROM [dbo].[Municipio] WHERE [Divipola] = LTRIM(RTRIM(@IdCodDane)))

							IF(@IdUbicacionGeografica IS NOT NULL)
								BEGIN
									--========================================
									-- Inserta los departamentos relacionados
									--========================================
									IF(@Nivel = 2)
										BEGIN
											IF(NOT EXISTS (SELECT [Id] FROM [PAT].[PreguntaPATDepartamento] WHERE [IdPreguntaPAT] = @id AND [IdDepartamento] = @IdUbicacionGeografica))
												BEGIN
													INSERT INTO [PAT].[PreguntaPATDepartamento]([IdPreguntaPAT],[IdDepartamento]) VALUES (@id, @IdUbicacionGeografica)
												END
										END
									--========================================
									-- Inserta los municipios relacionados
									--========================================
									ELSE IF(@Nivel = 3)	
										BEGIN
											IF(NOT EXISTS (SELECT [Id] FROM [PAT].[PreguntaPATMunicipio] WHERE [IdPreguntaPAT] = @id AND [IdMunicipio] = @IdUbicacionGeografica))
												BEGIN
													INSERT INTO [PAT].[PreguntaPATMunicipio]([IdPreguntaPAT],[IdMunicipio]) VALUES (@id, @IdUbicacionGeografica)
												END
										END	
								END
						
							FETCH NEXT FROM Dane_Cursor 
							INTO @IdCodDane 
						END

						CLOSE Dane_Cursor;  
						DEALLOCATE Dane_Cursor; 

				END

			COMMIT TRANSACTION
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
			
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado, @id AS id

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_PreguntaPatUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_PreguntaPatUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-29																			  
/Descripcion: Actualiza la información de las preguntas 
/Retorna: SELECT @respuesta AS respuesta, @estadoRespuesta AS estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_PreguntaPatUpdate] 

		@Id						INT,
		@IdDerecho				SMALLINT,
		@IdComponente			INT,
		@IdMedida				INT,
		@Nivel					TINYINT,
		@PreguntaIndicativa		NVARCHAR(500),
		@IdUnidadMedida			TINYINT,
		@PreguntaCompromiso		NVARCHAR(500),
		@ApoyoDepartamental		BIT,
		@ApoyoEntidadNacional	BIT,
		@Activo					BIT,
		@IdTablero				TINYINT,
		@IdsNivel				NVARCHAR(MAX),
		@Incluir				BIT,
		@RequiereAdjunto		BIT,
		@MensajeAdjunto			NVARCHAR(MAX),
		@ExplicacionPregunta    NVARCHAR(MAX),
		@CodigosDane			NVARCHAR(MAX)

AS 	
	
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	DECLARE @idPregunta INT

	SELECT @idPregunta = r.ID FROM [PAT].[PreguntaPAT] AS r
	WHERE r.Id = @Id 
	ORDER BY r.ID

	if (@idPregunta IS NULL)
		BEGIN
			SET @esValido = 0
			SET @respuesta += 'No se encontró la respuesta.\n'
		END

	DECLARE @IdTableroActual INT, @IdRespuesta INT, @IdRespuestaDept INT, @IsNumeric INT

	SELECT @IdTableroActual =IdTablero FROM [PAT].PreguntaPAT WHERE Id = @Id  

	if ( @IdTablero <> @IdTableroActual)
		BEGIN
			SELECT TOP 1 @IdRespuesta = Id FROM [PAT].[RespuestaPAT] WHERE [IdPreguntaPAT] =@Id  
			SELECT TOP 1 @IdRespuestaDept = Id FROM [PAT].[RespuestaPATDepartamento] WHERE [IdPreguntaPAT] =@Id  
		
			IF (@IdRespuesta >0 or @IdRespuestaDept >0)
			BEGIN
				SET @esValido = 0
				SET @respuesta += 'No se puede cambiar el tablero ya se se encuentran respuestas asociadas.\n'
			END
		END

	IF(@esValido = 1) 
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION
					UPDATE 
						[PAT].[PreguntaPAT]
					SET 
						 IdDerecho			= @IdDerecho
						,IdComponente		= @IdComponente
						,IdMedida			= @IdMedida
						,Nivel				= @Nivel
						,PreguntaIndicativa	= @PreguntaIndicativa
						,IdUnidadMedida		= @IdUnidadMedida
						,PreguntaCompromiso	= @PreguntaCompromiso
						,ApoyoDepartamental	= @ApoyoDepartamental
						,ApoyoEntidadNacional = @ApoyoEntidadNacional
						,Activo				= @Activo
						,IdTablero			= @IdTablero
						,RequiereAdjunto	= @RequiereAdjunto
						,MensajeAdjunto		= @MensajeAdjunto
						,ExplicacionPregunta = @ExplicacionPregunta
					WHERE  
						ID = @Id 

					--============================================================================================================
					-- Nivel 1 = Nacional, Nivel 2 = Departamentos, Nivel 3 = Municipios

					-- De acuerdo al nivel ejecuta el cursor que hace lo siguiente:

					-- Hace un rompimiento en la variable @IdsNivel tipo varchar y la separa de acuerdo a las comas (,). trae
					-- los municipios o los departamentos de acuerdo al nivel de la pregunta, realiza la inserción de los Id's en 
					-- la tabla departamentos-pregunta o municipios-pregunta. En caso que el nivel sea 3, no hace nada.
					-- Si la variable @Incluir viene en falso lo que hace es retirar los items de la tabla
					--=============================================================================================================

					IF(@Incluir = 1)
						BEGIN
							IF(LEN(@IdsNivel) > 0)
								BEGIN
									DECLARE @IdNivel INT
									DECLARE Nivel_Cursor CURSOR FOR  

										SELECT 
											splitdata 
										FROM 
											[dbo].[Split](@IdsNivel, ',')

									OPEN Nivel_Cursor 

									FETCH NEXT FROM Nivel_Cursor 
									INTO @IdNivel 

									WHILE @@FETCH_STATUS = 0  
										BEGIN  
									
											--========================================================================
											-- Valida si el ID es un número colocando 1 para verdadero y 0 para falso
											--========================================================================
											SET @IsNumeric = [dbo].[isReallyNumeric](@IdNivel)
									
											IF(@IsNumeric = 1)
												BEGIN
													--========================================
													-- Inserta los departamentos relacionados
													--========================================
													IF(@Nivel = 2)
														BEGIN
															IF(NOT EXISTS (SELECT [Id] FROM [PAT].[PreguntaPATDepartamento] WHERE [IdPreguntaPAT] = @id AND [IdDepartamento] = @IdNivel))
																BEGIN
																	IF(EXISTS (SELECT * FROM [dbo].[Departamento] WHERE [Id] = @IdNivel))
																	INSERT INTO [PAT].[PreguntaPATDepartamento]([IdPreguntaPAT],[IdDepartamento])
																	VALUES (@id, @IdNivel)
																END
														END
													--========================================
													-- Inserta los municipios relacionados
													--========================================
													ELSE IF(@Nivel = 3)	
														BEGIN
															IF(NOT EXISTS (SELECT [Id] FROM [PAT].[PreguntaPATMunicipio] WHERE [IdPreguntaPAT] = @id AND [IdMunicipio] = @IdNivel))
																BEGIN
																	IF(EXISTS (SELECT * FROM [dbo].[Municipio] WHERE [Id] = @IdNivel))
																	INSERT INTO [PAT].[PreguntaPATMunicipio]([IdPreguntaPAT],[IdMunicipio])
																	VALUES (@id, @IdNivel)
																END
														END	
												END								
						
											FETCH NEXT FROM Nivel_Cursor 
											INTO @IdNivel 

										END; 
					    
									CLOSE Nivel_Cursor;  
									DEALLOCATE Nivel_Cursor; 
								END

							IF (LEN(@CodigosDane) > 0)
								BEGIN
									DECLARE @IdCodDane VARCHAR(100), @IdUbicacionGeografica INT
									DECLARE Dane_Cursor CURSOR FOR  

										SELECT 
											splitdata 
										FROM 
											[dbo].[Split](@CodigosDane, ',')

									OPEN Dane_Cursor 

									FETCH NEXT FROM Dane_Cursor 
									INTO @IdCodDane 

									WHILE @@FETCH_STATUS = 0  
										BEGIN  
									
											-- Revisa que exista la ubicación geográfica en los departamentos
											IF(@Nivel = 2)
												SET @IdUbicacionGeografica = (SELECT [Id] FROM [dbo].[Departamento] WHERE [Divipola] = LTRIM(RTRIM(@IdCodDane)))

											-- Revisa que exista la ubicación geográfica en los municipios
											ELSE IF(@Nivel = 3)	
												SET @IdUbicacionGeografica = (SELECT [Id] FROM [dbo].[Municipio] WHERE [Divipola] = LTRIM(RTRIM(@IdCodDane)))

											IF(@IdUbicacionGeografica IS NOT NULL)
												BEGIN
													--========================================
													-- Inserta los departamentos relacionados
													--========================================
													IF(@Nivel = 2)
														BEGIN
															IF(NOT EXISTS (SELECT [Id] FROM [PAT].[PreguntaPATDepartamento] WHERE [IdPreguntaPAT] = @id AND [IdDepartamento] = @IdUbicacionGeografica))
																BEGIN
																	INSERT INTO [PAT].[PreguntaPATDepartamento]([IdPreguntaPAT],[IdDepartamento]) VALUES (@id, @IdUbicacionGeografica)
																END
														END
													--========================================
													-- Inserta los municipios relacionados
													--========================================
													ELSE IF(@Nivel = 3)	
														BEGIN
															IF(NOT EXISTS (SELECT [Id] FROM [PAT].[PreguntaPATMunicipio] WHERE [IdPreguntaPAT] = @id AND [IdMunicipio] = @IdUbicacionGeografica))
																BEGIN
																	INSERT INTO [PAT].[PreguntaPATMunicipio]([IdPreguntaPAT],[IdMunicipio]) VALUES (@id, @IdUbicacionGeografica)
																END
														END	
												END
						
											FETCH NEXT FROM Dane_Cursor 
											INTO @IdCodDane 
										END

										CLOSE Dane_Cursor;  
										DEALLOCATE Dane_Cursor; 
							END
						END
					ELSE
						BEGIN
							DECLARE @SQL NVARCHAR(MAX)
							
							----========================================
							---- Retira los departamentos relacionados
							----========================================
							IF(@Nivel = 2)
								BEGIN
									SET @SQL = 'DELETE [PAT].[PreguntaPATDepartamento]
									WHERE [IdDepartamento] IN ('+(SELECT @IdsNivel)+')
									AND [IdPreguntaPAT] = '+ CAST(@Id AS VARCHAR) 
									EXEC (@SQL)
								END
							----========================================
							---- Retira los municipios relacionados
							----========================================
							ELSE IF(@Nivel = 3)	
								BEGIN
									SET @SQL = 'DELETE [PAT].[PreguntaPATMunicipio]
									WHERE [IdMunicipio] IN ('+(SELECT @IdsNivel)+')
									AND [IdPreguntaPAT] = '+ CAST(@Id AS VARCHAR)
									EXEC (@SQL)
								END
						END
						
					--================================================================================
					-- Valida que la pregunta haya quedado relacionada con municipios o departamentos
					-- de lo contrario hace el rollback y muestra el mensaje al usuario.
					--================================================================================
					IF(((SELECT COUNT(Id) FROM [PAT].[PreguntaPATDepartamento] WHERE [IdPreguntaPAT] = @idPregunta) = 0) 
					   AND ((SELECT COUNT(Id) FROM [PAT].[PreguntaPATMunicipio] WHERE [IdPreguntaPAT] = @idPregunta) = 0))
						BEGIN
							ROLLBACK TRANSACTION
							SELECT @respuesta = 'Es necesario dejar relacionado como mínimo un '+(SELECT CASE @Nivel WHEN 2 THEN 'Departamento' WHEN 3 THEN 'Municipio' END)+' a la pregunta'
							SELECT @estadoRespuesta = 0
						END
					ELSE
						BEGIN
							COMMIT TRANSACTION
							SELECT @respuesta = 'Se ha modificado el registro'
							SELECT @estadoRespuesta = 2
						END									
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
				SELECT @respuesta = ERROR_MESSAGE()
				SELECT @estadoRespuesta = 0
			END CATCH
		END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado			

