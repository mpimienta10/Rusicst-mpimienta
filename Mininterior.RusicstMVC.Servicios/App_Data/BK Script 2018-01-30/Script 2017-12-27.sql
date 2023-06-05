-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		06/10/2017
-- Modified date:	01/11/2017
-- Description:		Procedimiento que trae el listado de tableros 
-- =============================================
ALTER PROCEDURE [PAT].[C_ListadoTableros]	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Id, VigenciaInicio, VigenciaFin, YEAR(VigenciaInicio)+1  as AnoTablero
	FROM [PAT].Tablero	
	where Activo = 1	 
END

go

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
						
							IF(LEN(@IdsNivel) > 0)
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

go

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de responsabilidad Colectiva	
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroMunicipioRR] --'', 1, 20, 394, 1
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho INT, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		LINEA INT,
		ID_PREGUNTA_RR SMALLINT,
		ID_DANE INT,
		HOGARES SMALLINT,
		PERSONAS SMALLINT,
		SECTOR NVARCHAR(MAX),
		COMPONENTE NVARCHAR(MAX),
		COMUNIDAD NVARCHAR(MAX),
		UBICACION NVARCHAR(MAX),
		MEDIDA_RR NVARCHAR(MAX),
		INDICADOR_RR NVARCHAR(MAX),
		ENTIDAD_RESPONSABLE NVARCHAR(MAX),
		ID_TABLERO TINYINT,
		ID_ENTIDAD INT,
		ID INT,
		ACCION NVARCHAR(1000),
		PRESUPUESTO MONEY
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE @ID_ENTIDAD INT
	--DECLARE @ID_DANE INT
		
	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize

	SET @ORDEN = @sortOrder
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'ID_PREGUNTA'

	SELECT @ID_ENTIDAD=PAT.fn_GetIdEntidad(@IdUsuario)
	--SELECT @ID_DANE=[PAT].[fn_GetDaneMunicipioEntidad](@IdUsuario)
	IF  @IdDerecho = 6
	BEGIN
		SET @SQL = 'SELECT	LINEA,IDPREGUNTA,IDDANE,HOGARES,PERSONAS,SECTOR, 
							COMPONENTE, COMUNIDAD, UBICACION, MEDIDARR, INDICADORRR, 
							ENTIDADRESPONSABLE, IDTABLERO,IDENTIDAD,ID,ACCION,PRESUPUESTO 
					FROM (
							SELECT DISTINCT TOP (@TOP) LINEA,IDPREGUNTA,IDDANE,HOGARES,PERSONAS,SECTOR, 
							COMPONENTE,COMUNIDAD,UBICACION,MEDIDARR,INDICADORRR, 
							ENTIDADRESPONSABLE,IDTABLERO,IDENTIDAD,ID,ACCION,PRESUPUESTO
					FROM ( 
							SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
							P.ID AS IDPREGUNTA,
							P.[IdMunicipio] AS IDDANE,
							P.[HOGARES],
							P.[PERSONAS],
							P.[SECTOR],
							P.[COMPONENTE],
							P.[COMUNIDAD],
							P.[UBICACION],
							P.[MedidaRetornoReubicacion] AS MEDIDARR,
							P.[IndicadorRetornoReubicacion] AS INDICADORRR,
							P.[ENTIDADRESPONSABLE], 
							T.ID AS IDTABLERO,
							CASE WHEN R.IdMunicipio IS NULL THEN @ID_ENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
							R.ID,
							R.ACCION, 
							R.PRESUPUESTO
					FROM   [PAT].[PreguntaPATRetornosReubicaciones] P
					INNER JOIN [PAT].[Tablero] T ON P.[IdTablero] = T.ID
					LEFT OUTER JOIN [PAT].[RespuestaPATRetornosReubicaciones] R ON R.IdMunicipio = @ID_ENTIDAD and p.ID = R.[IdPreguntaPATRetornoReubicacion]
					WHERE  P.Activo = 1 and  T.ID = @idTablero and P.[IdMunicipio] = @ID_ENTIDAD'
		SET @SQL =@SQL +' ) AS A WHERE A.LINEA >@PAGINA ORDER BY A.LINEA ) as F'
		SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT,@idTablero tinyint,  @ID_ENTIDAD INT'

--		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero,@ID_ENTIDAD= @ID_ENTIDAD
	END
	SELECT * from @RESULTADO
END

go


-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de responsabilidad Colectiva	
-- =============================================

ALTER PROCEDURE [PAT].[C_TableroMunicipioRC]-- NULL, 1, 20, 46, 'Reparación Integral',1
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho INT, @idTablero tinyint)

AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		LINEA INT,
		IDPREGUNTARC SMALLINT,
		IDDANE INT,
		IDMEDIDA SMALLINT,
		SUJETO NVARCHAR(3000),
		MEDIDARC NVARCHAR(2000),
		MEDIDA NVARCHAR(500),
		IDTABLERO TINYINT,
		IDENTIDAD INT,
		ID INT,
		ACCION NVARCHAR(4000),
		PRESUPUESTO MONEY
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE @IDDANE INT, @IDENTIDAD INT
	
	--SELECT @IDDANE= [PAT].[fn_GetDaneMunicipioEntidad](@IdUsuario)
	SELECT @IDENTIDAD =[PAT].[fn_GetIdEntidad](@IdUsuario)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize


	SET @ORDEN = @sortOrder
	IF @ORDEN = '' or @ORDEN is NULL
		SET @ORDEN = 'IDPREGUNTA'

	IF  @IdDerecho = 6
	BEGIN
		SET @SQL = 'SELECT  TOP (@TOP) A.LINEA,
				A.IDPREGUNTA, 
				A.IDDANE,
				A.IDMEDIDA,
				A.SUJETO,
				A.MEDIDARC,
				A.MEDIDA,
				A.IDTABLERO,
				A.IDENTIDAD,
				A.ID,
				A.ACCION,
				A.PRESUPUESTO 
					FROM (SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
							P.ID AS IDPREGUNTA, 
							P.[IdMunicipio] AS IDDANE, 
							P.IDMEDIDA, 
							P.SUJETO, 
							P.[MedidaReparacionColectiva] AS MEDIDARC, 
							M.DESCRIPCION AS MEDIDA, 
							T.ID AS IDTABLERO,
							CASE WHEN R.IdMunicipio IS NULL THEN @IDENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
							R.ID,
							R.ACCION, 
							R.PRESUPUESTO
						FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
							LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] AS R ON P.ID= R.[IdPreguntaPATReparacionColectiva] AND R.[IdMunicipio] = @IDENTIDAD,
							[PAT].[Medida] M,
							[PAT].[Tablero] T
						WHERE P.ACTIVO = 1 AND	P.IDMEDIDA = M.ID 
							AND P.[IdMunicipio] = @IDENTIDAD
							AND P.IDTABLERO = T.ID
							AND T.ID = @idTablero'
		SET @SQL =@SQL +') AS A WHERE A.LINEA >@PAGINA  ORDER BY A.LINEA ASC'-- AND IDPREGUNTA > 2242
		SET @PARAMETROS = '@TOP INT, @PAGINA INT,@idTablero tinyint,@IDENTIDAD INT'		
		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @idTablero=@idTablero, @IDENTIDAD=@IDENTIDAD
	END
	SELECT * from @RESULTADO
END

GO

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/08/2017
-- Modified date:	28/08/2017
-- Description:		Retorna datos de la pregunta de retornos y reubivaciones para el tablero y municipio indicado
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoMunicipioRetornosReubicaciones] --[PAT].[C_TableroSeguimientoMunicipioRetornosReubicaciones]  2, 1513
(	@IdTablero INT	,@IdUsuario INT)
AS
BEGIN
	declare @IdMunicipio int
	select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

	SELECT 	A.Id, A.Hogares, A.Personas, A.Sector, A.Componente, A.Comunidad, A.Ubicacion, A.MedidaRetornoReubicacion, A.IndicadorRetornoReubicacion, A.EntidadResponsable, A.IdDepartamento, A.IdMunicipio, A.IdTablero
	,SMRC.IdSeguimientoRR as IdSeguimiento
	,SMRC.AvancePrimer AS AvancePrimerSemestreAlcaldia
	,SMRC.AvanceSegundo AS AvanceSegundoSemestreAlcaldia
	,SMRC.NombreAdjunto AS NombreAdjunto, M.Nombre AS Municipio
	FROM [PAT].PreguntaPATRetornosReubicaciones as A
	JOIN Municipio AS M ON A.IdMunicipio = M.Id
	LEFT OUTER JOIN [PAT].RespuestaPATRetornosReubicaciones AS C ON A.Id = C.IdPreguntaPATRetornoReubicacion
	LEFT OUTER JOIN [PAT].SeguimientoRetornosReubicaciones SMRC ON SMRC.IdTablero = A.IdTablero AND SMRC.IdUsuario = C.IdUsuario AND SMRC.IdPregunta = C.IdPreguntaPATRetornoReubicacion
	WHERE A.IdMunicipio = @IdMunicipio
	AND A.IdTablero = @IdTablero
	and A.Activo = 1
END



GO

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/08/2017
-- Modified date:	28/08/2017
-- Description:		Retorna el numero de seguimiento de acuerdo al momento en el que se llame el procedimiento
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoMunicipioReparacionColectiva]--[PAT].[C_TableroSeguimientoMunicipioReparacionColectiva] 1 , 360
(
	@IdTablero INT
	,@IdUsuario INT
)
AS
BEGIN
	declare @IdMunicipio int
	select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

	SELECT 	DISTINCT 
	A.Sujeto
	, B.DESCRIPCION AS Medida
	,C.ACCION AS AccionMunicipio
	,C.PRESUPUESTO AS PresupuestoMunicipio
	,D.AccionDepartamento
	,D.PresupuestoDepartamento
	,A.ID AS IdPregunta
	,A.IdMunicipio
	,A.IdMedida
	,C.ID AS IdRespuesta
	,A.IdTablero
	,D.ID AS IdRespuestaDepartamento
	,A.IdDepartamento--,D.ID_ENTIDAD AS ID_ENTIDAD_DPTO	
	,SMRC.IdSeguimientoRC as IdSeguimiento
	,SMRC.AvancePrimer AS AvancePrimerSemestreAlcaldia
	,SMRC.AvanceSegundo AS AvanceSegundoSemestreAlcaldia
	,SGRC.AvancePrimer AS AvancePrimerSemestreGobernacion
	,SGRC.AvanceSegundo AS AvanceSegundoSemestreGobernacion
	,SMRC.NombreAdjunto AS NombreAdjunto
	FROM [PAT].PreguntaPATReparacionColectiva AS A
	INNER JOIN [PAT].Medida B ON B.ID = A.IdMedida
	LEFT OUTER JOIN [PAT].RespuestaPATReparacionColectiva AS C ON A.Id = C.IdPreguntaPATReparacionColectiva
	LEFT OUTER JOIN [PAT].[RespuestaPATDepartamentoReparacionColectiva] AS D ON D.IdPreguntaPATReparacionColectiva = A.Id  AND D.IdMunicipioRespuesta = C.IdMunicipio
	--LEFT OUTER JOIN [PAT].SeguimientoGobernacionReparacionColectiva as f on a.Id = f.IdPregunta and f.IdUsuario = @IdUsuario
	LEFT OUTER JOIN [PAT].SeguimientoReparacionColectiva SMRC ON SMRC.IdTablero = A.IdTablero AND SMRC.IdUsuario = C.IdUsuario AND SMRC.IdPregunta = C.IdPreguntaPATReparacionColectiva
	LEFT OUTER JOIN [PAT].SeguimientoGobernacionReparacionColectiva SGRC ON SGRC.IdTablero = A.IdTablero AND SGRC.IdPregunta = C.IdPreguntaPATReparacionColectiva AND SGRC.IdUsuarioAlcaldia = C.IdUsuario
	WHERE A.IdTablero = @IdTablero
	and A.IdMunicipio = @IdMunicipio
	AND A.Activo = 1
	order by a.Id	 
END


GO

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		25/07/2017
-- Modified date:	03/10/2017
-- Description:		Obtiene el tablero para la gestión departamental de reparación colectiva
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroDepartamentoReparacionColectiva] --[PAT].[C_TableroDepartamentoReparacionColectiva] 1, 20,11001,1
	(@page SMALLINT, @pageSize SMALLINT, @IdMunicipio INT, @idTablero tinyint)	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RESULTADO TABLE (
		Medida NVARCHAR(50),
		Sujeto NVARCHAR(300),
		MedidaReparacionColectiva NVARCHAR(2000),
		Id INT,
		IdTablero TINYINT,
		IdMunicipioRespuesta INT,
		IdDepartamento INT,
		IdPreguntaReparacionColectiva SMALLINT,
		Accion NVARCHAR(1000),
		Presupuesto MONEY,
		AccionDepartamento NVARCHAR(1000),
		PresupuestoDepartamento MONEY,
		Municipio  NVARCHAR(100)
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	
	DECLARE @PAGINA INT
	SET @PAGINA = (@page - 1) * @pageSize

	

	SET @SQL = '
	SELECT DISTINCT TOP (@TOP) 
					Medida,Sujeto,MedidaReparacionColectiva,Id,IdTablero,IdMunicipioRespuesta,IdDepartamento,IdPreguntaReparacionColectiva,
					Accion,Presupuesto,AccionDepartamento,PresupuestoDepartamento,Municipio
					FROM ( 
						SELECT DISTINCT row_number() OVER (ORDER BY p.SUJETO) AS LINEA, 
							MEDIDA.Descripcion as Medida,
							p.Sujeto,
							p.MedidaReparacionColectiva,
							rcd.Id,
							p.IdTablero,
							p.IdMunicipio as IdMunicipioRespuesta,
							d.IdDepartamento, 
							p.Id as IdPreguntaReparacionColectiva,
							rc.Accion,
							rc.Presupuesto,
							rcd.AccionDepartamento,  
							rcd.PresupuestoDepartamento,
							d.Nombre as Municipio
						FROM PAT.PreguntaPATReparacionColectiva p
						INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
						INNER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id		
						INNER join Municipio as d on p.IdMunicipio =d.Id and d.Id =@IdMunicipio
						LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc on p.Id = rc.IdPreguntaPATReparacionColectiva and rc.IdMunicipio= d.Id
						LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON rcd.IdMunicipioRespuesta= d.Id and rcd.IdPreguntaPATReparacionColectiva=p.Id
						where TABLERO.Id = @idTablero and p.Activo = 1
					) AS P WHERE LINEA >@PAGINA 
					--and IdPreguntaReparacionColectiva > 2242 
					ORDER BY p.Sujeto'

		SET @PARAMETROS = '@TOP SMALLINT, @PAGINA SMALLINT, @IdMunicipio INT,@idTablero tinyint'

		PRINT @SQL
		PRINT @IdMunicipio
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @IdMunicipio= @IdMunicipio,@idTablero=@idTablero
		SELECT * from @RESULTADO
END


go


-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		25/07/2017
-- Modified date:	03/10/2017
-- Description:		Obtiene el tablero para la gestión departamental de retornos y reubicaciones
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroDepartamentoRetornosReubicaciones] --[PAT].[C_TableroDepartamentoRetornosReubicaciones] 1, 20,5051,3
	(@page SMALLINT, @pageSize SMALLINT, @IdMunicipio INT, @idTablero tinyint)	
AS
BEGIN
	SET NOCOUNT ON;

		DECLARE @RESULTADO TABLE (
			IdPreguntaRR SMALLINT,
			IdMunicipio INT,
			Hogares INT,
			Personas INT,
			Sector NVARCHAR(MAX),
			Componente NVARCHAR(MAX),
			Comunidad NVARCHAR(MAX),
			Ubicacion NVARCHAR(MAX),
			MedidaRetornoReubicacion NVARCHAR(MAX),
			IndicadorRetornoReubicacion NVARCHAR(MAX),
			IdDepartamento INT,
			IdTablero TINYINT,
			Accion NVARCHAR(1000),
			Presupuesto MONEY,
			IdRespuestaDepartamento INT,
			AccionDepartamento NVARCHAR(1000),
			PresupuestoDepartamento MONEY,
			EntidadResponsable nvarchar(1000)
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	
	DECLARE @PAGINA INT
	SET @PAGINA = (@page - 1) * @pageSize

	SET @SQL = 'SELECT DISTINCT TOP (@TOP) 
	IdPregunta, 	IdMunicipio,	Hogares,Personas,	Sector,Componente,Comunidad,Ubicacion,MedidaRetornoReubicacion,
	IndicadorRetornoReubicacion,	IdDepartamento,	IdTablero,	Accion,Presupuesto,	IdRespuestaDepartamento,	AccionDepartamento,PresupuestoDepartamento,EntidadResponsable
	FROM ( 
	SELECT DISTINCT row_number() OVER (ORDER BY P.Id) AS LINEA 
	,P.Id AS IdPregunta
	,P.IdMunicipio
	,P.Hogares
	,P.Personas
	,P.Sector
	,P.Componente
	,P.Comunidad
	,P.Ubicacion
	,P.MedidaRetornoReubicacion	
	,P.IndicadorRetornoReubicacion
	,p.IdDepartamento	
	,P.IdTablero	
	,R.ID
	,R.Accion
	,R.Presupuesto
	,RD.AccionDepartamento
	,RD.PresupuestoDepartamento
	,RD.Id as IdRespuestaDepartamento
	,P.EntidadResponsable
	FROM pat.PreguntaPATRetornosReubicaciones AS P
	JOIN PAT.Tablero AS T ON P.IdTablero =T.Id
	LEFT OUTER JOIN PAT.RespuestaPATRetornosReubicaciones AS R  ON P.Id = R.IdPreguntaPATRetornoReubicacion AND R.IdMunicipio = P.IdMunicipio
	LEFT OUTER JOIN PAT.RespuestaPATDepartamentoRetornosReubicaciones AS RD ON R.IdMunicipio = RD.IdMunicipioRespuesta and P.Id = RD.IdPreguntaPATRetornoReubicacion
	where T.Id = @idTablero 
	AND P.IdMunicipio =@IdMunicipio
	and P.Activo= 1
	) AS P 
	WHERE LINEA >@PAGINA 
	ORDER BY P.IdPregunta  
	'

		SET @PARAMETROS = '@TOP SMALLINT, @PAGINA SMALLINT,@idTablero tinyint, @IdMunicipio INT'

		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @idTablero= @idTablero,@IdMunicipio=@IdMunicipio
		SELECT * from @RESULTADO
END

go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	29/08/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDepartamentoReparacionColectiva] --[PAT].[C_TableroSeguimientoDepartamentoReparacionColectiva] 1, 181
( @IdTablero INT ,@IdMunicipio INT )
AS
BEGIN	
		SELECT 
		DISTINCT 
		A.Sujeto
		, B.Descripcion AS Medida
		,C.Accion AS AccionMunicipio
		,C.Presupuesto AS PresupuestoMunicipio
		,D.AccionDepartamento
		,D.PresupuestoDepartamento
		,A.Id AS IdPregunta
		,A.IdMunicipio
		,A.IdMedida
		,C.Id AS IdRespuesta		
		,A.IdTablero
		,D.Id AS IdRespuestaDepartamento
		,U.IdDepartamento--,D.ID_ENTIDAD AS ID_ENTIDAD_DPTO
		FROM [PAT].PreguntaPATReparacionColectiva as A
		INNER JOIN [PAT].Medida as B ON B.Id = A.IdMedida
		LEFT OUTER JOIN [PAT].RespuestaPATReparacionColectiva as C ON C.IdPreguntaPATReparacionColectiva = A.Id
		LEFT OUTER JOIN [PAT].[RespuestaPATDepartamentoReparacionColectiva] as D ON D.IdPreguntaPATReparacionColectiva = A.Id --AND D.ID_ENTIDAD_MUNICIPIO = C.ID_ENTIDAD
		left outer join Usuario as U on D.IdUsuario = U.Id
		WHERE A.IdTablero = @IdTablero
		and A.IdMunicipio = @IdMunicipio		
		and A.Activo = 1
		order by a.ID
END


