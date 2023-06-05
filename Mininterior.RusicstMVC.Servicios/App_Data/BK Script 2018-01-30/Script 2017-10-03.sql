IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroDepartamentoReparacionColectiva]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroDepartamentoReparacionColectiva] AS'
go
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
						where TABLERO.Id = @idTablero
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroDepartamentoRetornosReubicaciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroDepartamentoRetornosReubicaciones] AS'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroHistoricoXMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroHistoricoXMunicipio] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 14/09/2017
-- Description:	obtiene la informacion historica por municipio
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroHistoricoXMunicipio]

	@IdMunicipio				VARCHAR(100)
AS
BEGIN
SELECT Periodo, Guardo, Completo, Diligencio, Adjunto, Envio
		FROM
		RetroHistorialRusicst
  WHERE Usuario = @IdMunicipio
  ORDER BY Periodo
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesAdecuacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesAdecuacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Adecuación Institucional
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesAdecuacion] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE RDP.ValorCalculo
			  WHEN '*' THEN 1
			  ELSE (CASE R.Valor
					WHEN RDP.ValorCalculo THEN 1
					ELSE 0 END
			)
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.Id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%Adecua%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesArticulacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesArticulacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo 05 Articulación Institucional
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesArticulacion] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (

SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE RDP.ValorCalculo
			  WHEN '*' THEN 1
			  ELSE (CASE R.Valor
					WHEN RDP.ValorCalculo THEN 1
					ELSE 0 END
			)
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta	
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%Articula%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesComite]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesComite] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Comité de Justicia Transicional
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesComite] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE RDP.ValorCalculo
			  WHEN '*' THEN 1
			  ELSE (CASE R.Valor
					WHEN RDP.ValorCalculo THEN 1
					ELSE 0 END
			)
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta		
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%justicia%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesDinamica]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesDinamica] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Dinámica del Conflicto Armado
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesDinamica] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE RDP.ValorCalculo
			  WHEN '*' THEN 1
			  ELSE (CASE R.Valor
					WHEN RDP.ValorCalculo THEN 1
					ELSE 0 END
			)
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta		
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%conflicto%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesParticipacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesParticipacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Participación de las Víctimas
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesParticipacion] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE RDP.ValorCalculo
			  WHEN '*' THEN 1
			  ELSE (CASE R.Valor
					WHEN RDP.ValorCalculo THEN 1
					ELSE 0 END
			)
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta			
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%ctimas%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesRetorno]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesRetorno] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Retorno y Reubicación
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesRetorno] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE RDP.ValorCalculo
			  WHEN '*' THEN 1
			  ELSE (CASE R.Valor
					WHEN RDP.ValorCalculo THEN 1
					ELSE 0 END
			)
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta			
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%Retorno%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesTerritorial]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesTerritorial] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Territorial
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesTerritorial] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

---Datos Grafica DINAMICA

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE RDP.ValorCalculo
			  WHEN '*' THEN 1
			  ELSE (CASE R.Valor
					WHEN RDP.ValorCalculo THEN 1
					ELSE 0 END
			)
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.Id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%Territorial%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre
			

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesTodo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesTodo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 18/098/2017
-- Description:	obtiene los datos totales para la grafica acumuladora
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesTodo] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE RDP.ValorCalculo
			  WHEN '*' THEN 1
			  ELSE (CASE R.Valor
					WHEN RDP.ValorCalculo THEN 1
					ELSE 0 END
			)
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.Id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			--where Seccion_1.Titulo like '%Adecua%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

GO

IF ((select COUNT(1) from RetroHistorialRusicst where Periodo = '2012-a')>0)
BEGIN
INSERT  INTO RetroHistorialRusicst
select Usuario,	'2012-2',
	CASE SUM(convert(int,Guardo))
	WHEN 2 THEN 1
	ELSE 0
	END sumGuardo,
	CASE SUM(convert(int,Completo))
	WHEN 2 THEN 1
	ELSE 0
	END sumCompleto,
	CASE SUM(convert(int,Diligencio))
	WHEN 2 THEN 1
	ELSE 0
	END sumDiligencio,
	CASE SUM(convert(int,Adjunto))
	WHEN 2 THEN 1
	ELSE 0
	END sumAdjunto,
	CASE SUM(convert(int,Envio))
	WHEN 2 THEN 1
	ELSE 0
	END sumEnvio, null,null,null
from RetroHistorialRusicst
where Periodo in ('2012','2012-a')
group by Usuario

DELETE FROM RetroHistorialRusicst
where Periodo in ('2012','2012-a')

update RetroHistorialRusicst
SET Periodo = '2012'
WHERE Periodo = '2012-2'

END
ELSE
select 'Los registros ya han sido actualizados'

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ValidarPermisoGuardadoSeccion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ValidarPermisoGuardadoSeccion] AS'
go

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-10-03																			 
-- Descripcion: Retorna IdEncuesta y el resultado (BIT) de la validacion del usuario permitido para contestar
--				La seccion indicada en el parametro
-- ***************************************************************************************************
ALTER PROC [dbo].[C_ValidarPermisoGuardadoSeccion] --331, 452
(
	@idUsuario INT
	,@idSeccion INT
)

AS

BEGIN

SET NOCOUNT ON;

--declare @idUsuario int
--declare @idSeccion int

--set @idUsuario = 331
--set @idSeccion = 3836


	DECLARE @idEncuesta INT
	DECLARE @fecha DATETIME
	DECLARE @valido BIT

	SELECT 
		@idEncuesta = IdEncuesta
	FROM 
		dbo.Seccion 
	WHERE 
		Id = @idSeccion 

	SET @fecha = GETDATE()

	SET @valido = 0

	---Verificamos si la Encuesta aún está habilitada para contestar
	SELECT 
		@valido = 1 
	FROM 
		dbo.Encuesta 
	WHERE 
		Id = @idEncuesta 
		AND 
			[FechaInicio] <= @fecha 
		AND 
			[FechaFin] >= @fecha

	--Si no está habilitada verificamos las Extensiones de tiempo del Usuario
	IF @valido = 0
	BEGIN

	SELECT 
		@valido = 1 
	FROM 
		[dbo].[PermisoUsuarioEncuesta] 
	WHERE 
		IdUsuario = @idUsuario 
		AND 
			IdEncuesta = @idEncuesta 
		AND
			FechaFin >= @fecha

	END


	SELECT 
		@idEncuesta AS IdEncuesta
		,@valido AS UsuarioHabilitado

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ObtenerDatosGuardadoArchivosEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ObtenerDatosGuardadoArchivosEncuesta] AS'
go

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-10-03																			 
-- Descripcion: Retorna Los valores de nombre de usuario e idEncuesta para el guardado de los archivos
-- ***************************************************************************************************
ALTER PROC [dbo].[C_ObtenerDatosGuardadoArchivosEncuesta] --331, 3839
(
	@idUsuario INT
	,@idSeccion INT
)

AS

BEGIN

SET NOCOUNT ON;

--declare @idUsuario int
--declare @idSeccion int

--set @idUsuario = 331
--set @idSeccion = 3836


	DECLARE @idEncuesta INT

	SELECT 
		@idEncuesta = IdEncuesta
	FROM 
		dbo.Seccion 
	WHERE 
		Id = @idSeccion 

	
	SELECT
		u.Username AS Usuario
		,@idEncuesta AS Encuesta
	FROM 
		dbo.Usuario u
	WHERE
		u.Id = @idUsuario

END

GO

--==================================================================================================
-- CATEGORIAS UTILIZADAS PARA LA AUDITORIA
--==================================================================================================
IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Extender Plazo'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Extender Plazo', 77)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Archivo de Ayuda'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Archivo de Ayuda', 78)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Archivo de Ayuda'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Archivo de Ayuda', 79)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Archivo de Ayuda'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Archivo de Ayuda', 80)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home RS'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home RS', 81)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home Mint'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home Mint', 82)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home App'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home App', 83)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home Gob'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home Gob', 84)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home SL'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home SL', 85)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home Texto Footer'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home Texto Footer', 86)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home Parámetros Gobierno'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home Parámetros Gobierno', 87)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Home Parámetros Gobierno'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Home Parámetros Gobierno', 88)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema RS'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema RS', 89)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema Mint'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema Mint', 90)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema App'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema App', 91)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema Gob'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema Gob', 92)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema SL'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema SL', 93)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema Texto Footer'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema Texto Footer', 94)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema Parámetros Gobierno'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema Parámetros Gobierno', 95)

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Sistema Parámetros Gobierno'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Sistema Parámetros Gobierno', 96)

GO