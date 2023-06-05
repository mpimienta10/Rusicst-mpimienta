IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultarRespuestasArchivoFileServer]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultarRespuestasArchivoFileServer] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--****************************************************************************************************
-- Autor: Andres Bonilla - John Betancourt 
-- Fecha creacion: 2018-03-27																			
-- Descripcion: Retorno las respuestas con las rutas de los archivos
--****************************************************************************************************
ALTER PROC [dbo].[C_ConsultarRespuestasArchivoFileServer]

AS
select R.Id IdRespuesta, R.IdPregunta, R.Fecha, R.Valor, U.UserName, M.Nombre Municipio, D.Nombre Departamento
from dbo.Respuesta R
INNER JOIN Usuario U ON R.IdUsuario = U.Id
INNER JOIN Municipio M ON M.Id = U.IdMunicipio
INNER JOIN Departamento D ON D.ID = U.IdDepartamento
where 
IdPregunta in (
select a.id 
from dbo.Pregunta a 
inner join (select id, idencuesta from dbo.Seccion) b on b.id = a.IdSeccion
where b.IdEncuesta = 78 and a.IdTipoPregunta = 1
) and idusuario in (
select id from dbo.Usuario where IdTipoUsuario = 2 and Activo = 1 and IdEstado = 5
)
order by Fecha asc

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
			CASE 
			  WHEN (RDP.ValorCalculo = '*' AND DATALENGTH(R.Valor)>0) THEN 1
			  WHEN (RDP.ValorCalculo = '' AND DATALENGTH(R.Valor)=0) THEN 1
			  WHEN (LOWER(RDP.ValorCalculo) = LOWER(R.Valor)) THEN 1
			  ELSE 0
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
			CASE 
			  WHEN (RDP.ValorCalculo = '*' AND DATALENGTH(R.Valor)>0) THEN 1
			  WHEN (RDP.ValorCalculo = '' AND DATALENGTH(R.Valor)=0) THEN 1
			  WHEN (LOWER(RDP.ValorCalculo) = LOWER(R.Valor)) THEN 1
			  ELSE 0
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
			CASE 
			  WHEN (RDP.ValorCalculo = '*' AND DATALENGTH(R.Valor)>0) THEN 1
			  WHEN (RDP.ValorCalculo = '' AND DATALENGTH(R.Valor)=0) THEN 1
			  WHEN (LOWER(RDP.ValorCalculo) = LOWER(R.Valor)) THEN 1
			  ELSE 0
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
			CASE 
			  WHEN (RDP.ValorCalculo = '*' AND DATALENGTH(R.Valor)>0) THEN 1
			  WHEN (RDP.ValorCalculo = '' AND DATALENGTH(R.Valor)=0) THEN 1
			  WHEN (LOWER(RDP.ValorCalculo) = LOWER(R.Valor)) THEN 1
			  ELSE 0
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
			CASE 
			  WHEN (RDP.ValorCalculo = '*' AND DATALENGTH(R.Valor)>0) THEN 1
			  WHEN (RDP.ValorCalculo = '' AND DATALENGTH(R.Valor)=0) THEN 1
			  WHEN (LOWER(RDP.ValorCalculo) = LOWER(R.Valor)) THEN 1
			  ELSE 0
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
			CASE 
			  WHEN (RDP.ValorCalculo = '*' AND DATALENGTH(R.Valor)>0) THEN 1
			  WHEN (RDP.ValorCalculo = '' AND DATALENGTH(R.Valor)=0) THEN 1
			  WHEN (LOWER(RDP.ValorCalculo) = LOWER(R.Valor)) THEN 1
			  ELSE 0
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
			CASE 
			  WHEN (RDP.ValorCalculo = '*' AND DATALENGTH(R.Valor)>0) THEN 1
			  WHEN (RDP.ValorCalculo = '' AND DATALENGTH(R.Valor)=0) THEN 1
			  WHEN (LOWER(RDP.ValorCalculo) = LOWER(R.Valor)) THEN 1
			  ELSE 0
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
-- Create date: 18/09/2017
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
			CASE 
			  WHEN (RDP.ValorCalculo = '*' AND DATALENGTH(R.Valor)>0) THEN 1
			  WHEN (RDP.ValorCalculo = '' AND DATALENGTH(R.Valor)=0) THEN 1
			  WHEN (LOWER(RDP.ValorCalculo) = LOWER(R.Valor)) THEN 1
			  ELSE 0
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