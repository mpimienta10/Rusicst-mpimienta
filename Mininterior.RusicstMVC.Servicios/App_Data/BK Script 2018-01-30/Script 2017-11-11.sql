
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DepartamentosXPregunta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DepartamentosXPregunta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date:	03/07/2017
-- Description:	Procedimiento que retorna la información de todos los departamentos relacionados y los que 
--				no con la pregunta PAT.
-- ====================================================================================================
ALTER PROCEDURE [PAT].[C_DepartamentosXPregunta] 

	@IdPregunta INT,
	@Incluidos BIT

AS
	BEGIN
		
		IF(@Incluidos = 1)
			BEGIN
				SELECT 
					[Id],
					[Divipola],
					UPPER([Nombre]) Departamento
				FROM 
					[dbo].[Departamento]
				WHERE [Id] IN (	SELECT [D].[Id] 
								FROM [dbo].[Departamento] D
								INNER JOIN [PAT].[PreguntaPATDepartamento] PPD ON [PPD].[IdDepartamento] = [D].[Id]
								WHERE [PPD].[IdPreguntaPAT] = @IdPregunta)
				ORDER BY 1
			END
		ELSE
			BEGIN
				SELECT 
					[Id],
					[Divipola],
					UPPER([Nombre]) Departamento
				FROM 
					[dbo].[Departamento]
				WHERE [Id] NOT IN (	SELECT [D].[Id] 
									FROM [dbo].[Departamento] D
									INNER JOIN [PAT].[PreguntaPATDepartamento] PPD ON [PPD].[IdDepartamento] = [D].[Id]
									WHERE [PPD].[IdPreguntaPAT] = @IdPregunta)
				ORDER BY 1
			END
	
	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_MunicipiosXPregunta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_MunicipiosXPregunta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date:	11/11/2017
-- Description:	Procedimiento que retorna la información de todos los municipios relacionados y los que 
--				no con la pregunta PAT.
-- ====================================================================================================
ALTER PROCEDURE [PAT].[C_MunicipiosXPregunta]

	@IdPregunta INT,
	@Incluidos BIT

AS
	BEGIN
		
		IF(@Incluidos = 1)
			BEGIN
				SELECT 
					[Id],
					[Divipola],
					UPPER([Nombre]) Municipio
				FROM 
					[dbo].[Municipio]
				WHERE [Id] IN (	SELECT [M].[Id] 
								FROM [dbo].[Municipio] M
								INNER JOIN [PAT].[PreguntaPATMunicipio] PPM ON [PPM].[IdMunicipio] = [M].[Id]
								WHERE [PPM].[IdPreguntaPAT] = @IdPregunta)
				ORDER BY 1
			END
		ELSE
			BEGIN
				SELECT 
					[Id],
					[Divipola],
					UPPER([Nombre]) Municipio
				FROM 
					[dbo].[Municipio]
				WHERE [Id] NOT IN (	SELECT [M].[Id] 
								FROM [dbo].[Municipio] M
								INNER JOIN [PAT].[PreguntaPATMunicipio] PPM ON [PPM].[IdMunicipio] = [M].[Id]
								WHERE [PPM].[IdPreguntaPAT] = @IdPregunta)
				ORDER BY 1
			END
	
	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_PreguntaPatInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_PreguntaPatInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-29																			  
/Descripcion: Inserta la información del tablero municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_PreguntaPatInsert] 

		@IdDerecho			SMALLINT,
		@IdComponente		INT,
		@IdMedida			INT,
		@Nivel				TINYINT,
		@PreguntaIndicativa NVARCHAR(500),
		@IdUnidadMedida		TINYINT,
		@PreguntaCompromiso NVARCHAR(500),
		@ApoyoDepartamental BIT,
		@ApoyoEntidadNacional BIT,
		@Activo				BIT,
		@IdTablero			TINYINT,
		@IdsNivel			NVARCHAR(MAX)
			
AS 	
	
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	DECLARE @esValido AS BIT = 1	
	DECLARE @id INT	
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRY
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
					   ,[IdTablero])
				 VALUES
					   (@IdDerecho ,
					   @IdComponente ,
					   @IdMedida ,
					   @Nivel ,
					   @PreguntaIndicativa ,
					   @IdUnidadMedida ,
					   @PreguntaCompromiso,
					   @ApoyoDepartamental ,
					   @ApoyoEntidadNacional ,
					   @Activo ,
					   @IdTablero )

			SELECT @id = SCOPE_IDENTITY()

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
					--========================================
					-- Inserta los departamentos relacionados
					--========================================
					IF(@Nivel = 2)
						BEGIN
							INSERT INTO [PAT].[C_DepartamentosXPregunta]([IdPreguntaPAT],[IdDepartamento])
							VALUES (@id, @IdNivel)
						END
					--========================================
					-- Inserta los municipios relacionados
					--========================================
					ELSE IF(@Nivel = 3)	
						BEGIN
							INSERT INTO [PAT].[PreguntaPATMunicipio]([IdPreguntaPAT],[IdMunicipio])
							VALUES (@id, @IdNivel)
						END
						
					FETCH NEXT FROM Nivel_Cursor 
					INTO @IdNivel 

				END; 
					    
			CLOSE Nivel_Cursor;  
			DEALLOCATE Nivel_Cursor; 
			
			--===================================================================

			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
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
		@Incluir				BIT

AS 	
	
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	DECLARE @esValido AS BIT = 1
	DECLARE @idPregunta INT

	SELECT @idPregunta = r.ID FROM [PAT].[PreguntaPAT] AS r
	WHERE r.Id = @Id 
	ORDER BY r.ID

	if (@idPregunta IS NULL)
		BEGIN
			SET @esValido = 0
			SET @respuesta += 'No se encontro la respuesta.\n'
		END

	DECLARE @IdTableroActual INT
	DECLARE @IdRespuesta INT
	DECLARE @IdRespuestaDept INT

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

				UPDATE 
					[PAT].[PreguntaPAT]
				SET 
					IdDerecho			= @IdDerecho,
					IdComponente		= @IdComponente,
					IdMedida			= @IdMedida,
					Nivel				= @Nivel,
					PreguntaIndicativa	= @PreguntaIndicativa,
					IdUnidadMedida		= @IdUnidadMedida,
					PreguntaCompromiso	= @PreguntaCompromiso,
					ApoyoDepartamental	= @ApoyoDepartamental,
					ApoyoEntidadNacional = @ApoyoEntidadNacional,
					Activo				= @Activo,
					IdTablero			= @IdTablero
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
						--========================================
						-- Inserta los departamentos relacionados
						--========================================
						IF(@Incluir = 1 AND @Nivel = 2)
							BEGIN
								INSERT INTO [PAT].[PreguntaPATDepartamento]([IdPreguntaPAT],[IdDepartamento])
								VALUES (@id, @IdNivel)
							END
						--========================================
						-- Inserta los municipios relacionados
						--========================================
						ELSE IF(@Incluir = 1 AND @Nivel = 3)	
							BEGIN
								INSERT INTO [PAT].[PreguntaPATMunicipio]([IdPreguntaPAT],[IdMunicipio])
								VALUES (@id, @IdNivel)
							END

						--========================================
						-- Retira los departamentos relacionados
						--========================================
						ELSE IF(@Incluir = 0 AND @Nivel = 2)
							BEGIN
								DELETE [PAT].[PreguntaPATDepartamento]
								WHERE [IdDepartamento] = @IdNivel
								AND [IdPreguntaPAT] = @Id
							END
						--========================================
						-- Retira los municipios relacionados
						--========================================
						ELSE IF(@Incluir = 0 AND @Nivel = 3)	
							BEGIN
								DELETE [PAT].[PreguntaPATMunicipio]
								WHERE [IdMunicipio] = @IdNivel
								AND [IdPreguntaPAT] = @Id
							END
						
						FETCH NEXT FROM Nivel_Cursor 
						INTO @IdNivel 

					END; 
					    
				CLOSE Nivel_Cursor;  
				DEALLOCATE Nivel_Cursor; 
			
				--===================================================================

				SELECT @respuesta = 'Se ha modificado el registro'
				SELECT @estadoRespuesta = 2
	
			END TRY
			BEGIN CATCH
				SELECT @respuesta = ERROR_MESSAGE()
				SELECT @estadoRespuesta = 0
			END CATCH
		END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado			






