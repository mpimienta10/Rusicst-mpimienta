--====================================================================================================
-- Autor: Equipo de desarrollo OIM - vilma rodriguez																	  
-- Fecha creacion: 2017-11-20																			  
-- Descripcion: elimina un registro de la tabla de RespuestaPATFuentePresupuesto PAT
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--====================================================================================================
ALTER PROCEDURE [PAT].[D_RespuestaPATFuentePresupuesto] 
	@IdFuente	 INT,
	@IdRespuesta int
AS 
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF(@esValido = 1) 
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY
				DELETE FROM PAT.RespuestaPATFuentePresupuesto
					WHERE IdFuentePresupuesto = @IdFuente		and IdRespuestaPAT = @IdRespuesta
		
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

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/07/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene toda la informacion correspondiente a la gobernbacion para retornos y reubicaciones  para el tablero indicando en cuento a las respuestas que estos diligenciaron
-- ==========================================================================================

ALTER PROC [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones] --  [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones] 1513 , 2
(	@IdUsuario INT, @IdTablero INT)
AS
BEGIN

	Declare @IdDepartamento int, @Departamento VARCHAR(100)
	
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario		

	SELECT DISTINCT 
		P.Id AS IdPregunta
		,d.Nombre as Municipio
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
		INNER join Municipio as d on p.IdMunicipio =d.Id and d.IdDepartamento =@IdDepartamento
		LEFT OUTER JOIN PAT.RespuestaPATRetornosReubicaciones AS R  ON P.Id = R.IdPreguntaPATRetornoReubicacion AND R.IdMunicipio = P.IdMunicipio
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoRetornosReubicaciones AS RD ON R.IdMunicipio = RD.IdMunicipioRespuesta
		where T.Id = @idTablero 
		order by P.Id

END

go

ALTER TABLE pat.PrecargueSIGO ALTER COLUMN NumeroDocumento float;

go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		20/11/2017
-- Modified date:	24/11/2017
-- Description:		Retorna las fuentes de financiacion para el diligenciamiento municipal de un municipio
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_UnoaUnoPrecargueSIGO] --[PAT].[C_UnoaUnoPrecargueSIGO] 1 , 1
( @IdPregunta as INT, @IdUsuario int)
AS
BEGIN
	SET NOCOUNT ON;		
	declare @IdTablero int
	set @IdTablero = 8
	select top 1000 [TipoDocumento],[NumeroDocumento],[NombreVictima] from [PAT].[PrecargueSIGO]	
	where IdTablero = 8
END

go

