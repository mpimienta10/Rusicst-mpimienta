
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Usuario]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[C_Usuario]
go
--==============================================================================================================
-- Autor : Christian Ospina
-- Fecha : 2017-04-05																			 
-- Descripción: Consulta la información de los usuarios para la rejilla de usuarios de acuerdo a los criterios
--				de filtro. Retira los usuarios que se encuentran retirados y rechazados																 
--==============================================================================================================
create PROC [dbo].[C_Usuario]

	 @Id			INT = NULL
	,@Token			UNIQUEIDENTIFIER = NULL
	,@IdTipoUsuario	INT = NULL
	,@IdDepartamento INT = NULL
	,@IdMunicipio	INT = NULL
	,@UserName		VARCHAR(128) = NULL
	,@IdEstado		INT = NULL

AS
	BEGIN
		SELECT
			 [UserName]
--======================================================================================
-- ORDEN DE LA CONSULTA NECESARIA PARA QUE SE MUESTRE EN ESTE MISMO ORDEN EN LA REJILLA
--=======================================================================================
			,[Nombres]
			,[FechaSolicitud]
			,[Cargo]
			,[TelefonoFijo]
			,[T].[Nombre] TipoUsuario
			,[TelefonoCelular]
			,[Email]
			,[M].[Nombre] Municipio
			,[D].[Nombre] Departamento
			,[DocumentoSolicitud]
--=======================================================================================
			,[U].[Id]
			,[IdUser]
			,[IdTipoUsuario]
			,[U].[IdDepartamento]
			,[U].[IdMunicipio]
			,[U].[IdEstado]
			,[E].[Nombre] Estado
			,[IdUsuarioTramite]			
			,[TelefonoFijoIndicativo]
			,[TelefonoFijoExtension]
			,[EmailAlternativo]
			,[Enviado]
			,[DatosActualizados]
			,[Token]
			,[U].[Activo]
			,[FechaNoRepudio]
			,[FechaTramite]
			,[FechaConfirmacion]	
		FROM 
			[dbo].[Usuario] U
			LEFT JOIN [dbo].[TipoUsuario] T ON [U].[IdTipoUsuario] = [T].[Id]
			LEFT JOIN [dbo].[Estado] E ON [U].[IdEstado] = [E].[Id]	
			LEFT JOIN [dbo].[Departamento] D on [D].[Id] = [U].[IdDepartamento]
			LEFT JOIN [dbo].[Municipio] M on [M].[Id] = [U].[IdMunicipio]
		WHERE 
			(@Id IS NULL OR [U].[Id] = @Id) 
			AND (@Token IS NULL OR [U].[Token] = @Token) 
			AND (@IdTipoUsuario IS NULL OR [U].[IdTipoUsuario] = @IdTipoUsuario) 
			AND (@IdDepartamento IS NULL OR [U].[IdDepartamento]  = @IdDepartamento )
			AND (@IdMunicipio IS NULL OR [U].[IdMunicipio] = @IdMunicipio)
			AND (@UserName IS NULL OR [U].[UserName] = @UserName)
			AND (@IdEstado IS NULL OR [U].[IdEstado] = @IdEstado)
			AND ([U].[IdEstado] <> 6) -- RETIRADO
			AND ([U].[IdEstado] <> 4) -- RECHAZADO
			AND (@Token IS NOT NULL OR [U].[IdEstado] <> 1) -- SOLICITADA

		ORDER BY 
			U.Nombres 
	END


go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_UsuarioInsert]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[I_UsuarioInsert]
go
-- ===========================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Description:	Inserta un registro en Usuarios, valida si la solicitud de usuario es para la misma ubicación
--				geográfica. De ser así, la rechaza, de lo contrario permite registrar la solicitud. 
--				Esto quiere decir que se podrán registrar varios usuarios con el mismo correo electrónico, 
--				siempre y cuando sean usuarios de diferentes ubicaciones geográficas.
--
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ===========================================================================================================
create PROCEDURE [dbo].[I_UsuarioInsert] 
		
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

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntaXNombrePasada]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PreguntaXNombrePasada] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author: Equipo de desarrollo OIM - Rafael Alba
-- Create date: 25/07/2017
-- Description: Selecciona la pregunta por nombre de pregunta 
-- ============================================================
ALTER PROCEDURE [dbo].[C_PreguntaXNombrePasada] 

@NombrePregunta
VARCHAR(512)

AS
BEGIN
SET NOCOUNT ON;

SELECT 
[Id]
FROM [dbo].[Pregunta]
WHERE [Nombre] =  @NombrePregunta 

END 

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntaXNombre]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PreguntaXNombre] AS'


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author: Equipo de desarrollo OIM - Rafael Alba
-- Create date: 25/07/2017
-- Description: Selecciona la pregunta por nombre de pregunta
-- ============================================================
ALTER PROCEDURE [dbo].[C_PreguntaXNombre] 

@NombrePregunta
VARCHAR(512), 
@IDSeccion Int

AS
BEGIN
SET NOCOUNT ON;

SELECT 
[Id]
FROM [dbo].[Pregunta]
WHERE [Nombre] =  @NombrePregunta 
AND [IdSeccion] = @IdSeccion

END 

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_RespuestaXIdPreguntaUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_RespuestaXIdPreguntaUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author: Equipo de desarrollo OIM - Rafael Alba
-- Create date: 25/07/2017
-- Description: Selecciona la respuesta por IdPregunta y Usuario de encuesta
-- ============================================================
ALTER PROCEDURE [dbo].[C_RespuestaXIdPreguntaUsuario] 

@IdPregunta
Int, 
@IdUsuario Int

AS
BEGIN
SET NOCOUNT ON;

SELECT [Id]
,[Fecha]
,[Valor]
FROM [dbo].[Respuesta]
WHERE [IdPregunta] = @IdPregunta
AND [IdUsuario] = @IdUsuario 
END

go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_BateriaCodigosPregunta_BancoPreguntas]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[C_BateriaCodigosPregunta_BancoPreguntas]
go
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-01																			 
-- Descripcion: Retorna el siguiente Código de Pregunta disponible en el Banco de Preguntas
-- ***************************************************************************************************
CREATE PROC [dbo].[C_BateriaCodigosPregunta_BancoPreguntas]
AS
BEGIN
SET NOCOUNT ON;

	SELECT 
		RIGHT('01000000' + CONVERT(VARCHAR, ISNULL(case WHEN MAX(ISNULL([CodigoPregunta], 0)) < '10000000' then '-1' else MAX(ISNULL([CodigoPregunta],0)) end, -1)  + 1), 8) AS SigCodigo
	FROM [BancoPreguntas].[Preguntas]

END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ClasificadoresBancoPreguntas]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[C_ClasificadoresBancoPreguntas]
go
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-01																			 
-- Descripcion: Consulta la informacion de la rejilla de Clasificadores del Banco de Preguntas												
-- ***************************************************************************************************
CREATE PROC [dbo].[C_ClasificadoresBancoPreguntas]
AS
BEGIN

SELECT 
	[IdClasificador]
	,[CodigoClasificador]
	,[NombreClasificador]
FROM 
	[BancoPreguntas].[Clasificadores]
END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ClasificadoresPreguntasBancoPreguntas]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[C_ClasificadoresPreguntasBancoPreguntas]
go
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-01																			 
-- Descripcion: Consulta la informacion de los clasificadores de las Preguntas del Banco de Preguntas												
-- ***************************************************************************************************
CREATE PROC [dbo].[C_ClasificadoresPreguntasBancoPreguntas]
(
	@IdPregunta INT
)
AS
BEGIN

	SELECT 
		C.NombreClasificador
		,A.IdPregunta
		,A.IdDetalleClasificador
		,A.IdPreguntaDetalleClasificador
		,B.IdClasificador
		,B.NombreDetalleClasificador
	FROM 
		[BancoPreguntas].[PreguntaDetalleClasificador] A
		INNER JOIN 
			[BancoPreguntas].[DetalleClasificador] B 
				ON B.IdDetalleClasificador = A.IdDetalleClasificador
		INNER JOIN 
			[BancoPreguntas].[Clasificadores] C 
				ON C.IdClasificador = B.IdClasificador
	WHERE 
		A.IdPregunta = @IdPregunta


END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DetallesClasificadoresPreguntasBancoPreguntas]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[C_DetallesClasificadoresPreguntasBancoPreguntas]
go
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-01																			 
-- Descripcion: Consulta la informacion de los detalles de los clasificadores de las Preguntas del Banco de Preguntas												
-- ***************************************************************************************************
CREATE PROC [dbo].[C_DetallesClasificadoresPreguntasBancoPreguntas]
(
	@IdClasificador INT
)
AS
BEGIN

	SELECT 
		[IdDetalleClasificador]
		,[NombreDetalleClasificador]
		,[ValorDefecto]
		,[IdClasificador]
  FROM 
	[BancoPreguntas].[DetalleClasificador]
  WHERE 
	IdClasificador = @IdClasificador
	ORDER BY
	ValorDefecto asc, NombreDetalleClasificador ASC

END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntasBancoPreguntas]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[C_PreguntasBancoPreguntas]
go
--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-08-01																			 
-- Descripcion: Consulta la informacion de la rejilla de Preguntas del Banco de Preguntas												
-- ***************************************************************************************************
CREATE PROC [dbo].[C_PreguntasBancoPreguntas]
AS
BEGIN
	SELECT top 100
		A.IdPregunta
		,A.CodigoPregunta
		,A.NombrePregunta
		,A.IdTipoPregunta
		,B.Descripcion
		,B.Nombre
	FROM 
		[BancoPreguntas].[Preguntas] A
		INNER JOIN 
			[dbo].[TipoPregunta] B ON B.Id = A.IdTipoPregunta
	ORDER BY
		A.CodigoPregunta asc

END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_DetalleClasificadorBancoPreguntasDelete]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[D_DetalleClasificadorBancoPreguntasDelete]
go
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-08-10																			  
-- Descripcion: Elimina un detalle de un clasificador del Banco de Preguntas												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
CREATE PROC [dbo].[D_DetalleClasificadorBancoPreguntasDelete]
(
	@IdClasificador INT
	,@IdDetalle INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
				DELETE FROM 
					[BancoPreguntas].[DetalleClasificador]
				WHERE 
					IdClasificador = @IdClasificador
					AND
						IdDetalleClasificador = @IdDetalle
		
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

END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_PreguntaBancoPreguntasDelete]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[D_PreguntaBancoPreguntasDelete]
go
CREATE PROC [dbo].[D_PreguntaBancoPreguntasDelete]
(
	@IdPregunta INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF EXISTS (SELECT 1
				FROM Encuesta a
					INNER JOIN Seccion b ON a.Id = b.IdEncuesta
					INNER JOIN Pregunta c ON b.Id = c.IdSeccion
					INNER JOIN BancoPreguntas.PreguntaModeloAnterior d ON c.Id = d.IdPreguntaAnterior
				WHERE d.IdPregunta = @IdPregunta)
	BEGIN
		SET @esValido = 0
		SET @respuesta = 'Si desea eliminar la pregunta, debe ir a la encuesta y suprimirla'
	END

	IF @esValido = 1
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [BancoPreguntas].Preguntas
				WHERE [IdPregunta] = @IdPregunta		
		
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

END
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_BancoPreguntas_DetalleClasificadorInsert]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[I_BancoPreguntas_DetalleClasificadorInsert]
go
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-08-10																			  
-- Descripcion: Inserta la información de un nuevo detalle de un clasificador del banco de preguntas												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
CREATE PROC [dbo].[I_BancoPreguntas_DetalleClasificadorInsert]
(
	@IdClasificador INT
	,@NombreDetalle VARCHAR(MAX)
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
		

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO [BancoPreguntas].[DetalleClasificador]([NombreDetalleClasificador], [ValorDefecto], [IdClasificador])
			SELECT @NombreDetalle, 0, @IdClasificador	
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
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_BancoPreguntas_PreguntaInsert]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[I_BancoPreguntas_PreguntaInsert]
go
--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-08-10																			  
-- Descripcion: Inserta la información de la Pregunta												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
CREATE PROC [dbo].[I_BancoPreguntas_PreguntaInsert]
(
	@CodigoPregunta VARCHAR(8)
	,@NombrePregunta VARCHAR(1024)
	,@TipoPregunta INT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF (EXISTS(SELECT * FROM [BancoPreguntas].[Preguntas] WHERE NombrePregunta  = @NombrePregunta))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Nombre de Pregunta ya existe en el Banco de Preguntas.'
	END

	IF (EXISTS(SELECT * FROM [BancoPreguntas].[Preguntas] WHERE CodigoPregunta  = @CodigoPregunta))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Código de la Pregunta se encuentra Duplicado.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO [BancoPreguntas].[Preguntas] ([CodigoPregunta], [NombrePregunta], [IdTipoPregunta])
			SELECT @CodigoPregunta, @NombrePregunta, @TipoPregunta	
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
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_BancoPreguntas_ClasificadorUpdateDetalle]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[U_BancoPreguntas_ClasificadorUpdateDetalle]
go
/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-08-10																			 
/Descripcion: Actualiza los datos de un detalle de clasificador en el Banco de Preguntas
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [dbo].[U_BancoPreguntas_ClasificadorUpdateDetalle]
(
	@IdClasificador INT
	,@IdDetalle INT
	,@NombreDetalle VARCHAR(MAX)
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE 
				[BancoPreguntas].[DetalleClasificador]
			SET
				NombreDetalleClasificador = @NombreDetalle
			WHERE
				IdDetalleClasificador = @IdDetalle
				AND
					IdClasificador = @IdClasificador

		SELECT @respuesta = 'Se ha Actualizado el registro'
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
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_BancoPreguntas_PreguntaUpdatae]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[U_BancoPreguntas_PreguntaUpdatae]
go
/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-08-10																			 
/Descripcion: Actualiza los datos de una pregunta en el Banco de Preguntas
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [dbo].[U_BancoPreguntas_PreguntaUpdatae]
(
	@IdPregunta INT
	,@CodigoPregunta VARCHAR(8)
	,@NombrePregunta VARCHAR(1024)
	,@TipoPregunta INT
)
AS
BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF (NOT EXISTS(SELECT * FROM [BancoPreguntas].[Preguntas] WHERE CodigoPregunta  = @CodigoPregunta))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Código de la Pregunta No Existe.'
	END

	IF (NOT EXISTS(SELECT * FROM [BancoPreguntas].[Preguntas] WHERE IdPregunta  = @IdPregunta))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Código de la Pregunta No Existe.'
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE 
				[BancoPreguntas].[Preguntas]
			SET
				NombrePregunta = @NombrePregunta
				,IdTipoPregunta = @TipoPregunta
			WHERE
				IdPregunta = @IdPregunta

		SELECT @respuesta = 'Se ha Actualizado el registro'
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
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_BancoPreguntas_PreguntaUpdateClasificador]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[U_BancoPreguntas_PreguntaUpdateClasificador]
go
/****************************************************************************************************
/Autor: Andrés Bonilla																			 
/Fecha creacion: 2017-08-10																			 
/Descripcion: Actualiza los datos de un clasificador de una pregunta en el Banco de Preguntas
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
*****************************************************************************************************/
CREATE PROC [dbo].[U_BancoPreguntas_PreguntaUpdateClasificador]
(
	@IdPregunta INT
	,@IdDetalle INT
	,@IdDetalleClasificador INT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	--IF EXISTS (SELECT 1
	--			FROM Encuesta a
	--				INNER JOIN Seccion b ON a.Id = b.IdEncuesta
	--				INNER JOIN Pregunta c ON b.Id = c.IdSeccion
	--				INNER JOIN BancoPreguntas.PreguntaModeloAnterior d ON c.Id = d.IdPreguntaAnterior
	--			WHERE d.IdPregunta = @IdPregunta)
	--BEGIN
	--	SET @esValido = 0
	--	SET @respuesta = 'La pregunta no puede ser modificada'
	--END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			UPDATE 
				[BancoPreguntas].[PreguntaDetalleClasificador]
			SET
				IdDetalleClasificador = @IdDetalle
			WHERE
				IdPregunta = @IdPregunta
				AND
					IdPreguntaDetalleClasificador = @IdDetalleClasificador

		SELECT @respuesta = 'Se ha Actualizado el registro'
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
