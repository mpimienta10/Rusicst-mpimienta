IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntasBancoPreguntas]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PreguntasBancoPreguntas] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Grupo Desarrollo OIM - Andrés Bonilla	
-- Modifica: Grupo Desarrollo OIM - Andrés Bonilla											 
-- Fecha creacion: 2017-08-01																			 
-- Fecha modificacion: 2018-01-30
-- Descripcion: Consulta la informacion de la rejilla de Preguntas del Banco de Preguntas												
-- Modificacion: Se agregan parametros de tipo y codigo de pregunta para filtrar previamente por tipo
--				 o por el texto del codigo de pregunta, buscando en alguna parte del codigo el texto
--				 pasado como parámetro.
-- ***************************************************************************************************
ALTER PROC [dbo].[C_PreguntasBancoPreguntas] --7, '1010'
(
	@IdTipoPregunta INT
	,@CodigoPregunta VARCHAR(10)
	,@Exportable BIT
)
AS
BEGIN

IF @Exportable = 0
BEGIN

IF @CodigoPregunta IS NULL OR @CodigoPregunta = '' OR LEN(@CodigoPregunta) = 0
BEGIN

	SELECT TOP 10000
		A.IdPregunta
		,A.CodigoPregunta
		,A.NombrePregunta
		,A.IdTipoPregunta
		,'' as Descripcion
		,B.Nombre as Nombre
	FROM 
		[BancoPreguntas].[Preguntas] A
	INNER JOIN
		[dbo].[TipoPregunta] B 
			ON B.Id = A.IdTipoPregunta
	WHERE
		B.Id = CASE WHEN @IdTipoPregunta IS NULL THEN B.Id ELSE @IdTipoPregunta END
	ORDER BY
		A.CodigoPregunta DESC
END
ELSE
BEGIN

	SELECT TOP 10000
		A.IdPregunta
		,A.CodigoPregunta
		,A.NombrePregunta
		,A.IdTipoPregunta
		,'' as Descripcion
		,B.Nombre as Nombre
	FROM 
		[BancoPreguntas].[Preguntas] A
	INNER JOIN
		[dbo].[TipoPregunta] B 
			ON B.Id = A.IdTipoPregunta
	WHERE
		B.Id = CASE WHEN @IdTipoPregunta IS NULL THEN B.Id ELSE @IdTipoPregunta END
		AND
			A.CodigoPregunta like '%' + @CodigoPregunta + '%'
	ORDER BY
		A.CodigoPregunta DESC

END
	
END
ELSE
BEGIN

	SELECT 
		A.IdPregunta
		,A.CodigoPregunta
		,A.NombrePregunta
		,A.IdTipoPregunta
		,'' as Descripcion
		,B.Nombre as Nombre
	FROM 
		[BancoPreguntas].[Preguntas] A
	INNER JOIN
		[dbo].[TipoPregunta] B 
			ON B.Id = A.IdTipoPregunta
	ORDER BY
		A.CodigoPregunta DESC

END

END