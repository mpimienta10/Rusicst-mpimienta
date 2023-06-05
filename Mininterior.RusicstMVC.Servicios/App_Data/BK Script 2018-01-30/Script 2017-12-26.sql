SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Modify:		Equipo de desarrollo OIM - Andrés Bonilla
-- Create date: 23/02/2017
-- Modify date: 26/12/2017
-- Description:	Selecciona la información de Tipos de Usuario
-- =============================================
ALTER PROCEDURE [dbo].[C_OpcionesXPregunta] --1441905

	@IdPregunta	 INT

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
		-1 AS Id
		,'' AS Valor
		,'' AS Texto
		,-1 AS Orden

		UNION ALL

		SELECT 
			 [Id]
			,[Valor]
			,[Texto]
			,[Orden]
		FROM
			[dbo].[Opciones]
		WHERE
			[IdPregunta] = @IdPregunta
		ORDER BY Orden

END	


GO

-- ============================================================
-- Author:		Equipo de desarrollo OIM - Andrés Bonilla
-- Create date: 29/09/2017
-- Description:	Retorna el Listado de Preguntas que dependen del parametro enviado
--				para poder determinar cuales deben ser recalculadas al momento del
--				evento onchange de los controles de la encuesta
-- ============================================================
ALTER PROCEDURE [dbo].[C_ListadoPreguntasSoloSiXIdPregunta] --
(
	@IdPregunta INT
)

AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @IdEncuesta INT
	DECLARE @IdSeccion INT
	DECLARE @NombrePregunta VARCHAR(512)
	DECLARE @CodigoPregunta VARCHAR(10)

	SELECT 
		@IdEncuesta = b.IdEncuesta
		,@IdSeccion = a.IdSeccion
		,@NombrePregunta = a.Nombre
	FROM 
		dbo.Pregunta a
		INNER JOIN 
			dbo.Seccion b 
				ON b.Id = a.IdSeccion
	WHERE 
		a.Id = @IdPregunta


	--PRINT @IdPregunta
	--PRINT @IdEncuesta
	--PRINT @IdSeccion
	--PRINT @NombrePregunta

	IF @IdEncuesta > 76 --Codigo de Pregunta Banco
	BEGIN

		SELECT 
			@CodigoPregunta = b.CodigoPregunta
		FROM
			dbo.Pregunta p
			INNER JOIN 
				BancoPreguntas.PreguntaModeloAnterior pma
					ON pma.IdPreguntaAnterior = p.Id
			INNER JOIN
				BancoPreguntas.Preguntas b 
					ON b.IdPregunta = pma.IdPregunta
		WHERE
			p.Id = @IdPregunta


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
			INNER JOIN 
				TipoPregunta TP 
					ON P.IdTipoPregunta = TP.Id
			INNER JOIN 
				dbo.Seccion S 				
					ON S.Id = p.IdSeccion
		WHERE 
			CHARINDEX(@CodigoPregunta, SoloSi, 0) > 0
			AND
				IdSeccion = @IdSeccion
			AND
				p.Id <> @IdPregunta
		ORDER BY
			p.Id 
				ASC


	END
	ELSE -- Nombre de Pregunta vieja
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
			,'' AS Respuesta
			,S.IdEncuesta
		FROM 
			[dbo].[Pregunta] p
			INNER JOIN 
				TipoPregunta TP 
					ON P.IdTipoPregunta = TP.Id
			INNER JOIN 
				dbo.Seccion S 				
					ON S.Id = p.IdSeccion
		WHERE 
			CHARINDEX(@NombrePregunta, SoloSi, 0) > 0
			AND
				IdSeccion = @IdSeccion
			AND
				p.Id <> @IdPregunta
		ORDER BY
			p.Id 
				ASC

	END

END

GO

