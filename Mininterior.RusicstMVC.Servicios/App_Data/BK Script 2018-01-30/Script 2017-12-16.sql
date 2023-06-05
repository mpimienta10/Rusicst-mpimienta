INSERT INTO [dbo].[Category] ([CategoryName] ,[Ordinal]) VALUES ('Crear Tablero Pat', 177)
INSERT INTO [dbo].[Category] ([CategoryName] ,[Ordinal]) VALUES ('Modificar Tablero Pat', 178)
INSERT INTO [dbo].[Category] ([CategoryName] ,[Ordinal]) VALUES ('Crear Preguntas PAT Reparación Colectiva', 179)
INSERT INTO [dbo].[Category] ([CategoryName] ,[Ordinal]) VALUES ('Modificar Preguntas PAT Reparación Colectiva', 180)
INSERT INTO [dbo].[Category] ([CategoryName] ,[Ordinal]) VALUES ('Crear Preguntas PAT Retornos y Reubicaciones', 181)
INSERT INTO [dbo].[Category] ([CategoryName] ,[Ordinal]) VALUES ('Modificar Preguntas PAT Retornos y Reubicaciones', 182)

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_UsuarioInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_UsuarioInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Description:	Inserta un registro en Usuarios, valida si la solicitud de usuario es para la misma ubicación
--				geográfica. De ser así, la rechaza, de lo contrario permite registrar la solicitud. 
--				Esto quiere decir que se podrán registrar varios usuarios con el mismo correo electrónico, 
--				siempre y cuando sean usuarios de diferentes ubicaciones geográficas.
--
-- Update date: 16-12-2017
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Description:	Se coloca la instrucción que setea el IdMunicio dentro del ELSE (habia quedado por fuera y producía la excepción) 
--				que valida si la variable @IdMunicipio viene nula.
--
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ===========================================================================================================
ALTER PROCEDURE [dbo].[I_UsuarioInsert] 
		
	 @IdDepartamento		INT
	,@IdMunicipio			INT
	,@IdEstado				INT
	,@Nombres				VARCHAR(255)
	,@Cargo					VARCHAR(255) 
	,@TelefonoFijo			VARCHAR(255) 
	,@TelefonoFijoIndicativo VARCHAR(255) 
	,@TelefonoFijoExtension	VARCHAR(255)  
	,@TelefonoCelular		VARCHAR(255) 
	,@Email					VARCHAR(255) 
	,@EmailAlternativo		VARCHAR(255) 
	,@Token					UNIQUEIDENTIFIER
	,@FechaSolicitud		DATETIME
	,@DocumentoSolicitud	VARCHAR(60)

AS
	BEGIN
		
		SET NOCOUNT ON;

		IF(@IdMunicipio = 0)
			SET @IdMunicipio = NULL

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		--=======================================================================================================================================================================
		-- Ajuste realizado para controlar el registro de los usuarios tipo gobernación y tipo alcaldía. El tipo gobernación no va a seleccionar municipio y el tipo alcaldía sí
		--=======================================================================================================================================================================
		IF(@IdMunicipio IS NOT NULL)
			BEGIN
				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 1 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] = @IdMunicipio))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail.'
					END

				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 2 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] = @IdMunicipio))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Confirmada por el Solicitante.'
					END

				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 3 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] = @IdMunicipio))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Confirmada por el Ministerio.'
					END

				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 5 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] = @IdMunicipio))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Aprobada por el Ministerio. Debe intentar la opción recuperar contraseña. De lo contrario comuniquese con el Administrador del Sistema.'
					END
				END
		ELSE 
			BEGIN
				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 1 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] IS NULL))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail.'
					END

				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 2 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] IS NULL))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Confirmada por el Solicitante.'
					END

				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 3 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] IS NULL))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Confirmada por el Ministerio.'
					END

				IF (EXISTS(SELECT * FROM [dbo].[Usuario]  WHERE [Email] = @Email AND [IdEstado] = 5 AND [IdDepartamento] = @IdDepartamento AND [IdMunicipio] IS NULL))
					BEGIN
						SET @esValido = 0
						SET @respuesta += 'Ya se encuentra una solicitud relacionada con éste e-mail y está Aprobada por el Ministerio. Debe intentar la opción recuperar contraseña. De lo contrario comuniquese con el Administrador del Sistema.'
					END

				SELECT @IdMunicipio = m.Id FROM Departamento AS d
				JOIN Municipio AS  m ON d.Id = m.IdDepartamento
				WHERE d.Id = @IdDepartamento AND m.Divipola LIKE '%001'

			END

		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY
					INSERT INTO [dbo].[Usuario] 
					(
						[IdDepartamento], [IdMunicipio], [IdEstado], [Nombres],
						[Cargo], [TelefonoFijo], [TelefonoFijoIndicativo], [TelefonoFijoExtension],
						[TelefonoCelular], [Email], [EmailAlternativo], [Token], [FechaSolicitud], [DocumentoSolicitud],[DatosActualizados]
					)
					
					SELECT 
						@IdDepartamento, @IdMunicipio, @IdEstado, @Nombres, 
						@Cargo, @TelefonoFijo, @TelefonoFijoIndicativo,  @TelefonoFijoExtension, 
						@TelefonoCelular, @Email, @EmailAlternativo, @Token, @FechaSolicitud, @DocumentoSolicitud,1

					SELECT @respuesta += 'La solicitud fue creada satisfactoriamente, pronto recibirá una confirmación al correo electrónico'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_PreguntaPatUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_PreguntaPatUpdate] AS'

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


GO

--Actualización de la letra del copyright del footer de la plantilla
update [ParametrizacionSistema].[ParametrosSistema]
  set ParametroValor = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Documento sin título</title></head><body><table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#f4f4f4"><tr><td valign="middle" align="center"><table style="color: #424242; font: 12px/16px Tahoma, Arial, Helvetica, sans-serif;" width="560" border="0" cellspacing="0" cellpadding="0"><tr><td style="color: #0055a6; line-height: 30px; text-align: center">Este es un correo Automático. Favor no responder.<br /><br /></td></tr><tr><td><img src="http://rusicst.mininterior.gov.co/Administracion/General/ImageHandler.ashx?id=ImageHandler4.png" alt="" /><br/><br/><br/></td></tr><tr><td valign="middle" align="center" bgcolor="#ffffff"><table style="color: #424242; font: 14px/18px Tahoma, Arial, Helvetica, sans-serif;" width="520" border="0" cellspacing="0" cellpadding="0"><tr><td style="color: #651C32; font: 24px/30px Tahoma, Arial, Helvetica, sans-serif;"><br /><singleline label="Title">{TITULO}</singleline><br /></td></tr><tr><td><br /><div style="text-align: justify">{CONTENIDO}</div><br /></td></tr><tr><td><br /><br /></td></tr></table></td></tr><tr><td style="color: #424242; font-size: 11px; line-height: 18px; text-align: center"><br />Correo generado por el Sistema de información RUSICST<br />Ministerio del Interior	<br /></td></tr></table></td></tr></table></body></html>'
  where IdGrupo = 9 and NombreParametro = 'PlantillaGeneral'


  go

  IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_EnvioTableroPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_EnvioTableroPat] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  /*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez																		  
/Fecha creacion:     2017-12-11	
/Fecha modificacion :2017-12-11
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
		set @respuesta += 'El tablero ya ha sido enviado con aterioridad.'
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 15/08/2017
-- Description:	obtiene la informacion de las preguntas consultadas sobre las encuestas
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo] 

	@IdPregunta					VARCHAR(8),
	@idsEncuesta				varchar(max)
AS

select Palabra, IdEncuesta, CodigoPregunta, NombrePregunta, Nombre, 'Valor' Valor
	FROM(
	select distinct S.IdEncuesta, P.CodigoPregunta, p.NombrePregunta, TP.Nombre--, R.Valor
	from [BancoPreguntas].[Preguntas] P
	INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
	INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
	INNER JOIN Seccion S on PO.IdSeccion = S.Id
	INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
	LEFT JOIN Respuesta R ON R.IdPregunta = PO.Id
	inner join fnSplit(@idsEncuesta,',') on Palabra =  S.IdEncuesta
	where CodigoPregunta = @IdPregunta AND tp.Id != 1) temp
right join fnSplit(@idsEncuesta,',') on Palabra = temp.IdEncuesta	

GO



