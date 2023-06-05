IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetAccionesPAT]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetAccionesPAT]
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetAccionesRCPAT]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetAccionesRCPAT]
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetAccionesRRPAT]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetAccionesRRPAT]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetAllTablerosDepCompletos]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetAllTablerosDepCompletos]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetAllTablerosDepPorCompletar]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetAllTablerosDepPorCompletar]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetAllTablerosMunCompletos]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetAllTablerosMunCompletos]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetAllTablerosMunPorCompletar]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetAllTablerosMunPorCompletar]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetConsolidadosMunicipio]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetConsolidadosMunicipio]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetConsolidadosMunicipio_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetConsolidadosMunicipio_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarConsolidadosMunicipio]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarConsolidadosMunicipio]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarConsolidadosMunicipio_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarConsolidadosMunicipio_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarPreguntas]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarPreguntas]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarTableroDepartamentoRC]]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarTableroDepartamentoRC]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarTableroDepartamentoRC_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarTableroDepartamentoRC_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarTableroDepartamentoRR]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarTableroDepartamentoRR]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarTableroMunicipio]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarTableroMunicipio]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarTableroMunicipio_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarTableroMunicipio_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarTableroMunicipioRC]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarTableroMunicipioRC]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarTableroMunicipioRC_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarTableroMunicipioRC_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarTableroMunicipioRR]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarTableroMunicipioRR]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarTableroMunicipioTotales]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarTableroMunicipioTotales]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarTableroMunicipioTotales_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarTableroMunicipioTotales_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetDatosExcel]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetDatosExcel]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetDatosExcel_A]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetDatosExcel_A]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetDatosExcel_Gob]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetDatosExcel_Gob]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetDatosExcel_Gob_Mpios]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetDatosExcel_Gob_Mpios]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetDatosExcel_Gob_Mpios17]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetDatosExcel_Gob_Mpios17]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetDatosExcel_Gob_RC]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetDatosExcel_Gob_RC]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetDatosExcel_Gob_RC17]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetDatosExcel_Gob_RC17]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetDatosExcel_Gob_RR]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetDatosExcel_Gob_RR]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetDatosExcel_Gob_RR17]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetDatosExcel_Gob_RR17]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetDatosExcel_Gob17]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetDatosExcel_Gob17]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetDerechos]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetDerechos]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetEntidadByUsuario]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetEntidadByUsuario]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetMunicipiosRC]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetMunicipiosRC]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetMunicipiosRR]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetMunicipiosRR]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetNecesidadesIdentificadas]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetNecesidadesIdentificadas]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetPreguntas]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetPreguntas]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetProgramasOferta]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetProgramasOferta]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetProgramasPAT]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetProgramasPAT]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroDepartamento]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroDepartamento]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroDepartamento_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroDepartamento_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroDepartamentoRC]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroDepartamentoRC]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroDepartamentoRC_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroDepartamentoRC_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroDepartamentoRR]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroDepartamentoRR]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroDepartamentoTotales]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroDepartamentoTotales]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroDepartamentoTotales_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroDepartamentoTotales_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroFechaActivo]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroFechaActivo]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroMunicipio]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroMunicipio]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroMunicipio_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroMunicipio_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroMunicipioAvance]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroMunicipioAvance]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroMunicipioAvance_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroMunicipioAvance_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroMunicipioRC]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroMunicipioRC]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroMunicipioRC_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroMunicipioRC_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroMunicipioRR]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroMunicipioRR]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroMunicipioTotales]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroMunicipioTotales]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroMunicipioTotales_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroMunicipioTotales_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroVigencia]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroVigencia]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetTableroVigencia_C]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetTableroVigencia_C]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[spGetAllEntidadesConRespuesta]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[spGetAllEntidadesConRespuesta]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[SP_GetContarTableroDepartamentoRC]') AND type in (N'P', N'PC')) 
drop procedure [PAT].[SP_GetContarTableroDepartamentoRC]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[GetNombreMunicipioEntidad]') AND type in (N'P', N'FN')) 
drop FUNCTION [PAT].[GetNombreMunicipioEntidad]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[GetNombreDepartamentoEntidad]') AND type in (N'P', N'FN')) 
drop FUNCTION [PAT].[GetNombreDepartamentoEntidad]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[fn_ValidarMunicipioDepartamento]') AND type in (N'P', N'FN')) 
drop FUNCTION [PAT].[fn_ValidarMunicipioDepartamento]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[fn_GetDaneDepartamentoEntidad]') AND type in (N'P', N'FN')) 
drop FUNCTION [PAT].[fn_GetDaneDepartamentoEntidad]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[fn_GetDaneDepartamentoEntidad]') AND type in (N'P', N'FN')) 
drop FUNCTION [PAT].[fn_GetDaneDepartamentoEntidad]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[GetDANE_Entidades_ByDepto]') ) 
drop FUNCTION [PAT].[GetDANE_Entidades_ByDepto]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[GetDANE_Entidades_ByDepto]') ) 
drop FUNCTION [PAT].[GetDANE_Entidades_ByDepto]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[GetEntidadesByDepto]') ) 
drop FUNCTION [PAT].[GetEntidadesByDepto]
go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_UsuarioInsert] ') AND type in (N'P', N'FN')) 
drop FUNCTION [dbo].[I_UsuarioInsert] 
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
				END

				select @IdMunicipio= m.Id from Departamento as d
				join Municipio as  m on d.Id = m.IdDepartamento
				where d.Id = @IdDepartamento and m.Divipola like '%001'

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

go

update Usuario  set IdMunicipio = m.Id 
from Usuario as u
join Departamento as d on u.IdDepartamento = d.Id
join Municipio as  m on d.Id = m.IdDepartamento
where u.IdMunicipio is null and m.Divipola like '%001'

go
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosPregunta]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[C_DatosPregunta]
go

--****************************************************************************************************
-- Autor: Vilma Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-14																			 
-- Descripcion: Consulta la informacion de modificar pregunta
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--*****************************************************************************************************
create PROC [dbo].[C_DatosPregunta]

	@Id INT 

AS

	SELECT 
		 a.[Id]
		,a.[Nombre]
		,b.[Nombre] TipoPregunta
		,b.[Id] IdTipoPregunta
		,a.[Ayuda]
		,a.[EsObligatoria]
		,a.[SoloSi]
		,a.[Texto]	
	FROM 
		Pregunta a
		INNER JOIN TipoPregunta b ON a.IdTipoPregunta = b.Id
	WHERE 
		a.[Id]= @Id

		GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaEncuesta]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[C_ListaEncuesta]
go

--****************************************************************************************************
-- Autor: Equipo de desarrollo OIM - Christian Ospina																		 
-- Fecha creacion: 2017-01-25																			 
-- Descripcion: Consulta la informacion de las encuestas para ser utilizada en combos de encuestas												
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--****************************************************************************************************
CREATE PROC [dbo].[C_ListaEncuesta]

	@IdTipoEncuesta INT = NULL

AS
	SELECT 
		 [Id]
		,UPPER([Titulo]) Titulo
	FROM 
		[Encuesta]
	WHERE
		[IsDeleted] = 'false'
		AND (@IdTipoEncuesta IS NULL  OR [IdTipoEncuesta] = @IdTipoEncuesta)
	ORDER BY 
		Id desc--[Titulo]				

go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ReportesXEntidadesTerritoriales]') AND type in (N'P', N'PC')) 
drop procedure [dbo].[C_ReportesXEntidadesTerritoriales]
go
--============================================================================================================
-- Autor: Robinson Moscoso																			 
-- Fecha creacion: 2017-01-25																			 
-- Descripcion: Consulta la informacion de las encuestas por entidad territorial, si se consulta gobernación, 
--				debe enciarse el municipio en cero 
-- Retorna: Result set de encuesta	
-- prueba c_ReportesXEntidadesTerritoriales 5						 
--============================================================================================================
create PROC [dbo].[C_ReportesXEntidadesTerritoriales]

	@IdDepartamento INT = NULL,
	@IdMunicipio	INT = NULL  

AS

	DECLARE @IdUsuario INT

	IF(@IdMunicipio IS NULL)
		BEGIN
			SELECT TOP 1 @IdUsuario = Id FROM Usuario WHERE IdDepartamento = @IdDepartamento AND IdTipoUsuario = (SELECT Id FROM TipoUsuario WHERE Tipo = 'GOBERNACION')
		END
	ELSE 
		BEGIN
			SELECT TOP 1 @IdUsuario = Id FROM Usuario WHERE IdMunicipio = @IdMunicipio AND IdTipoUsuario = (SELECT Id FROM TipoUsuario WHERE Tipo = 'ALCALDIA')
		END

	SELECT 
		DISTINCT [e].[titulo]
		,[e].[id]
		,[e].[FechaFin]
		,[e].[Ayuda]
	FROM 
		[dbo].[Respuesta] r 
		INNER JOIN [dbo].[Pregunta] p ON [r].[IdPregunta] = [p].[Id] 
		INNER JOIN [dbo].[Usuario] u ON [r].[IdUsuario] = [u].[Id] 
		INNER JOIN [dbo].[Seccion] s ON [p].[Idseccion] = [s].[Id] 
		INNER JOIN [dbo].[Encuesta] e ON [s].[IdEncuesta]=[e].[Id]
	WHERE 
		[u].[Id] = @IdUsuario

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_PreguntaEncuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_PreguntaEncuestaInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================
-- Autor: Equipo de desarrollo OIM - John Betancourt A.																		  
-- Fecha creacion: 2017-06-20																			  
-- Descripcion: Ingresa una pregunta cargada por el archivo excel y devuelve su ID
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int = 0 no hace nada, otro valor = ID de la pregunta insertada
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--====================================================================================================
ALTER PROC [dbo].[I_PreguntaEncuestaInsert] 

	@IdSeccion		INT,
	@Nombre			VARCHAR(512),
	@TipoPregunta	VARCHAR(255),
	@Ayuda			VARCHAR(MAX),
	@EsObligatoria	BIT,
	@EsMultiple		BIT,
	@SoloSi			VARCHAR(MAX),
	@Texto			VARCHAR(MAX)

AS 
	BEGIN
		
		SET NOCOUNT ON;

	-- Obtener Id del tipo de encuesta
		DECLARE @IdTipoPregunta INT = @TipoPregunta

		--SELECT @IdTipoPregunta = Id
		--FROM TipoPregunta
		--WHERE Nombre = @TipoPregunta

		SET @IdTipoPregunta = ISNULL(@IdTipoPregunta, 0)

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0
		DECLARE @esValido AS BIT = 1
	
		IF(@esValido = 1 AND @IdTipoPregunta != 0) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY

					INSERT INTO [dbo].[Pregunta] ([IdSeccion], [Nombre], [IdTipoPregunta], [Ayuda], [EsObligatoria], [EsMultiple], [SoloSi], [Texto])
					SELECT @IdSeccion, @Nombre, @IdTipoPregunta, @Ayuda, @EsObligatoria, @EsMultiple, @SoloSi, @Texto
					
					SELECT @respuesta = 'Se ha insertado el registro'
					
					-- Recupera el Identity registrado
					SET @estadoRespuesta = @@IDENTITY

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