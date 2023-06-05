/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez																		  
/Fecha creacion:     2017-12-11	
/Fecha modificacion :2017-12-19
/Descripcion: Inserta los datos de envio de los tres tipos de tablero: Planeacion Municipal "PM", Planeacion Departamental "PD"
/, Primer Seguimiento Municpal "SM1", Segundo Seguimiento Municpal "SM2"						  
/, Primer Seguimiento Departamental "SD1", Segundo Seguimiento Departamental "SD2"						  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_EnvioTableroPat] 
		@IdUsuario int,
		@IdTablero tinyint,
		@TipoEnvio varchar(3)
		AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	

	declare @id int, @IdDepartamento int,@IdMunicipio  int	
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	select @id = r.IdEnvio from [PAT].[EnvioTableroPat] as r
	where  r.IdMunicipio = @IdMunicipio and r.IdDepartamento = @IdDepartamento and TipoEnvio = @TipoEnvio  and r.IdTablero =@IdTablero
	
	if (@id is not null)
	begin
		set @esValido = 0
		set @respuesta += 'El tablero ya ha sido enviado con anterioridad.'
	end
	if(@esValido = 1) 
	begin
		BEGIN TRY
	
		INSERT INTO [PAT].[EnvioTableroPat]
				   ([IdTablero]
				   ,[IdUsuario]
				   ,[IdMunicipio]
				   ,[IdDepartamento]
				   ,[TipoEnvio]
				   ,[FechaEnvio])
			 VALUES
				   (@IdTablero,@IdUsuario,@IdMunicipio,@IdDepartamento,@TipoEnvio, getdate())
	 			
		
			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id


	go

	
ALTER PROC [PAT].[C_TodosTableros] 
AS
BEGIN
	select	A.[Id],	A.VigenciaInicio, A.VigenciaFin, A.Activo,YEAR(A.VigenciaInicio)+1 as Año	from	[PAT].[Tablero] A	
	where A.Activo = 1
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

	go

