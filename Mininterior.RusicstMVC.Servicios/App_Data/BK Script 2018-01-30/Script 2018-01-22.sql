/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez																		  
/Fecha creacion:     2017-12-11	
/Fecha modificacion :2018-01-22
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
	
	--if (@id is not null)
	--begin
	--	set @esValido = 0
	--	set @respuesta += 'El tablero ya ha sido enviado con anterioridad.'
	--end
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


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PermisosUsuarioPorRecurso]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PermisosUsuarioPorRecurso] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Equipo de desarrollo OIM - Andrés Bonilla
-- Fecha creacion: 2017-01-22																			 
-- Descripcion: Consulta la información de los permisos asociados a un usuario por recurso
--****************************************************************************************************
ALTER PROC [dbo].[C_PermisosUsuarioPorRecurso] 
(
	@IdTipoUsuario INT
	,@IdRecurso INT
)
AS

	BEGIN

	SET NOCOUNT ON;

		SELECT DISTINCT  
			 [R].Id AS [IdRecurso]
			,[R].[Nombre] AS NombreRecurso
			,SR.Id AS [IdSubRecurso] 
			,[SR].[Nombre] AS NombreSubRecurso
			,
			CONVERT(BIT, ISNULL((
			SELECT 1
			FROM dbo.TipoUsuarioRecurso xx
			WHERE xx.IdRecurso = R.Id AND xx.IdSubRecurso = SR.Id
			AND xx.IdTipoUsuario = @IdTipoUsuario
			), 0)) as AsignadoRol	 
		FROM 			
			[dbo].[Recurso] AS R 
			INNER JOIN [dbo].[SubRecurso] AS SR ON SR.IdRecurso = R.Id
		WHERE
			R.Id = @IdRecurso
		ORDER BY
			SR.Id ASC

END


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DibujarPreguntasSeccion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarPreguntasSeccion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Andrés Bonilla																	 
-- Fecha creacion: 25/07/2017																			 
-- Fecha modificacion: 2018-01-22
-- Descripcion: Trae las preguntas y respuestas a dibujar por idseccion e idusuario para pintar el diseño
-- Modificación: Se cambia el funcionamiento de la funcion [ParseDateRespuesta] para que se formateen las 
--				 fechas guardadas en las respuestas de las encuestas viejas
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DibujarPreguntasSeccion]

	 @IdSeccion	INT
	 ,@IdUsuario INT

AS
BEGIN

if @IdUsuario IS NULL
begin

	SELECT 
		P.[Id]	
		,[IdSeccion]
		,P.[Nombre]
		,[RowIndex]
		,[ColumnIndex]
		,TP.[Nombre] AS TipoPregunta
		,p.[Ayuda]
		,[EsObligatoria]
		,[EsMultiple]
		,[SoloSi]
		,[Texto]
		,'' AS Respuesta
		,S.IdEncuesta
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC
end
else
begin

	SELECT 
		P.[Id]	
		,[IdSeccion]
		,P.[Nombre]
		,[RowIndex]
		,[ColumnIndex]
		,TP.[Nombre] AS TipoPregunta
		,p.[Ayuda]
		,[EsObligatoria]
		,[EsMultiple]
		,[SoloSi]
		,[Texto]
		,CASE WHEN TP.[Nombre] = 'FECHA' THEN dbo.[ParseDateRespuesta](replace(LEFT(r.Valor, 10), '/', '-'), (case when (S.IdEncuesta < 77 AND S.IdEncuesta <> 24) then 1 else 0 end)) ELSE r.Valor END  as Respuesta
		,S.IdEncuesta
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
	LEFT OUTER JOIN [dbo].Respuesta r ON r.IdPregunta = p.Id and r.IdUsuario = @IdUsuario
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC

end
END

GO

ALTER FUNCTION [dbo].[ParseDateRespuesta]
(
	@fecha VARCHAR(20)
	,@isOld bit
)

returns VARCHAR(20)

AS

BEGIN
	
	DECLARE @Retorno VARCHAR(20)

	if @isOld = 1
	begin
		
		SELECT @Retorno = COALESCE(@Retorno + '-', '') + splitdata 
		from dbo.[SplitWId](@fecha, '-') order by idrow asc

	end
	else
	begin

		SELECT @Retorno = COALESCE(@Retorno + '-', '') + splitdata 
		from dbo.[SplitWId](@fecha, '-') order by idrow desc

	end


	RETURN @Retorno
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DibujarPreguntasSeccionExcel]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarPreguntasSeccionExcel] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Andrés Bonilla																	 
-- Fecha creacion: 2017-10-30																			 
-- Fecha modificacion: 2018-01-22
-- Descripcion: Trae las preguntas y respuestas a dibujar por idseccion e idusuario para descargar excel
-- Modificación: Se cambia el funcionamiento de la funcion [ParseDateRespuesta] para que se formateen las 
--				 fechas guardadas en las respuestas de las encuestas viejas
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DibujarPreguntasSeccionExcel] --3846, 331

	 @IdSeccion	INT
	 ,@IdUsuario INT

AS
BEGIN

	SELECT 
		P.[Id]	
		,[IdSeccion]
		,P.[Nombre]
		,[RowIndex]
		,[ColumnIndex]
		,TP.[Nombre] AS TipoPregunta
		,p.[Ayuda]
		,[EsObligatoria]
		,[EsMultiple]
		,[SoloSi]
		,[Texto]
		,CASE WHEN TP.[Nombre] = 'FECHA' THEN dbo.[ParseDateRespuesta](replace(LEFT(r.Valor, 10), '/', '-'), (case when (S.IdEncuesta < 77 AND S.IdEncuesta <> 24) then 1 else 0 end)) ELSE r.Valor END  as Respuesta
		,S.IdEncuesta
		,[dbo].[ObtenerTextoPreguntaClean]([Texto]) AS TextoClean
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
	LEFT OUTER JOIN [dbo].Respuesta r ON r.IdPregunta = p.Id and r.IdUsuario = @IdUsuario
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC

END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_RespuestaXIdPreguntaUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_RespuestaXIdPreguntaUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Andrés Bonilla																	 
-- Fecha creacion: 25/07/2017																			 
-- Fecha modificacion: 2018-01-22
-- Descripcion: Trae las preguntas y respuestas a dibujar por idseccion e idusuario para descargar excel
-- Modificación: Se cambia el funcionamiento de la funcion [ParseDateRespuesta] para que se formateen las 
--				 fechas guardadas en las respuestas de las encuestas viejas
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_RespuestaXIdPreguntaUsuario] 

@IdPregunta
Int, 
@IdUsuario Int

AS
BEGIN
SET NOCOUNT ON;


DECLARE @TipoPregunta VARCHAR(20)
DECLARE @IdEncuesta INT

SELECT @TipoPregunta = TP.Nombre, @IdEncuesta = SS.IdEncuesta
FROM 
[dbo].[Pregunta] p
INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
INNER JOIN dbo.Seccion  SS ON SS.Id = p.IdSeccion
WHERE p.Id = @IdPregunta


SELECT [Id]
,[Fecha]
,CASE WHEN @TipoPregunta = 'FECHA' THEN dbo.[ParseDateRespuesta](replace(LEFT(Valor, 10), '/', '-'), (case when (@IdEncuesta < 77 AND @IdEncuesta <> 24) then 1 else 0 end)) ELSE Valor END  as Valor
FROM [dbo].[Respuesta]
WHERE [IdPregunta] = @IdPregunta
AND [IdUsuario] = @IdUsuario 
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramientoV3]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramientoV3] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-11-20
-- Fecha modificacion: 2018-01-22
-- Descripcion: Consulta la informacion de las Estrategias de un Plan de Mejoramiento por Usuario
-- Modificación: Se modifica el procedimiento para tener en cuenta el nuevo funcionamiento de las opciones vacio y no vacio
-- ***************************************************************************************************
ALTER PROCEDURE [PlanesMejoramiento].[C_ObtenerInformacionPlanMejoramientoV3]
(
	@IdPlanMejoramiento INT,
	@IdSeccionPlan INT,
	@IdUsuario INT
)
AS
BEGIN

	SELECT DISTINCT	

	b.[IdEstrategia], b.[Estrategia], 
	a.Opcion,
	c.ObjetivoGeneral, c.IdSeccionPlanMejoramiento, c.Titulo, c.Ayuda, 
	d.IdPlanMejoramiento, d.Nombre, d.FechaLimite, d.CondicionesAplicacion, 
	CONVERT(VARCHAR, g.Id) AS CodigoPregunta, g.Texto AS NombrePregunta, tp.Nombre AS TipoPregunta, 
	
	ISNULL((select top 1 xx.Titulo from dbo.Seccion xx where xx.Id = a.IdEtapa), '') as EtapaNombre,
	a.IdEtapa as IdEtapa

	FROM PlanesMejoramiento.Tareas a (NOLOCK)
	INNER JOIN PlanesMejoramiento.Estrategias b (NOLOCK) ON a.[IdEstrategia] = b.[IdEstrategia]
	INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c (NOLOCK) ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramiento d (NOLOCK) ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
	INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta k (NOLOCK) ON k.IdPlanMejoriamiento = d.IdPlanMejoramiento 
	INNER JOIN dbo.Pregunta g (NOLOCK) ON g.Id = a.IdPregunta
	INNER JOIN dbo.TipoPregunta tp (NOLOCK) ON tp.Id = g.IdTipoPregunta
	INNER JOIN dbo.Seccion h (NOLOCK) ON h.Id = g.IdSeccion and h.IdEncuesta = k.IdEncuesta 	
	
	left outer JOIN dbo.Respuesta rr (NOLOCK) ON rr.IdPregunta = g.Id and rr.Valor = CASE tp.Id WHEN 11 THEN a.Opcion ELSE CASE a.Opcion WHEN 'Vacío' THEN NULL ELSE rr.Valor END END AND rr.IdUsuario = @IdUsuario --Traer respuestas vacias y no vacias (tipos de pregunta diferentes a unico)
	INNER JOIN PlanesMejoramiento.PlanActivacionFecha i (NOLOCK) ON i.IdPlanMejoramiento = d.IdPlanMejoramiento
	WHERE d.IdPlanMejoramiento = @IdPlanMejoramiento
	AND c.IdSeccionPlanMejoramiento = @IdSeccionPlan
	AND 
	(
		(a.Opcion = 'Vacío' AND (NOT EXISTS(select top 1 1 from dbo.Respuesta xx where xx.IdPregunta = g.Id AND xx.IdUsuario = @IdUsuario))) 
		OR
		(a.Opcion <> 'Vacío' AND (EXISTS(select top 1 1 from dbo.Respuesta xx where xx.IdPregunta = g.Id AND xx.IdUsuario = @IdUsuario)))
	)
	--FROM PlanesMejoramiento.Tareas a (NOLOCK)
	--INNER JOIN PlanesMejoramiento.Estrategias b (NOLOCK) ON a.[IdEstrategia] = b.[IdEstrategia]
	--INNER JOIN PlanesMejoramiento.SeccionPlanMejoramiento c (NOLOCK) ON b.IdSeccionPlanMejoramiento = c.IdSeccionPlanMejoramiento
	--INNER JOIN PlanesMejoramiento.PlanMejoramiento d (NOLOCK) ON c.IdPlanMejoramiento = d.IdPlanMejoramiento
	--INNER JOIN PlanesMejoramiento.PlanMejoramientoEncuesta k (NOLOCK) ON k.IdPlanMejoriamiento = d.IdPlanMejoramiento 
	--INNER JOIN dbo.Pregunta g (NOLOCK) ON g.Id = a.IdPregunta
	--INNER JOIN dbo.TipoPregunta tp (NOLOCK) ON tp.Id = g.IdTipoPregunta
	--INNER JOIN dbo.Seccion h (NOLOCK) ON h.Id = g.IdSeccion and h.IdEncuesta = k.IdEncuesta 
	--INNER JOIN dbo.Respuesta rr (NOLOCK) ON rr.IdPregunta = g.Id and RTRIM(ISNULL(rr.Valor, '')) = CASE a.Opcion WHEN 'Vacío' THEN '' WHEN 'No Vacío' THEN RTRIM(rr.Valor) ELSE RTRIM(a.Opcion) END AND rr.IdUsuario = @IdUsuario --Traer respuestas vacias y no vacias (tipos de pregunta diferentes a unico)
	----INNER JOIN dbo.Usuario usu (NOLOCK) ON usu.Id = 
	--INNER JOIN PlanesMejoramiento.PlanActivacionFecha i (NOLOCK) ON i.IdPlanMejoramiento = d.IdPlanMejoramiento
	--WHERE d.IdPlanMejoramiento = @IdPlanMejoramiento
	--AND c.IdSeccionPlanMejoramiento = @IdSeccionPlan
	--AND usu.Id = @IdUsuario
	ORDER BY b.[IdEstrategia] ASC
	
END