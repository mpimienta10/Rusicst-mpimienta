IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ListadoTableros]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ListadoTableros] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		06/10/2017
-- Modified date:	
-- Description:		Procedimiento que trae el listado de tableros 
-- =============================================
alter PROCEDURE [PAT].[C_ListadoTableros]	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Id, VigenciaInicio, VigenciaFin, YEAR(VigenciaInicio)  as AnoTablero
	FROM [PAT].Tablero		 
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ListadoSeguimientoConRespuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ListadoSeguimientoConRespuesta] AS'
go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		05/09/2017
-- Modified date:	06/10/2017
-- Description:		Retorna los usuarios que diligenciaron respuetas 
-- ==========================================================================================
ALTER PROC [PAT].[C_ListadoSeguimientoConRespuesta] 
 @IdDept INT
AS
BEGIN
	if @IdDept IS NULL or @IdDept = 0
	begin
	--SELECT distinct 
	--		U.UserName as Entidad,
	--		TU.Nombre as TipoUsuario, 
	--		D.Nombre as Departamento, M.Nombre as Municipio, A.IdMunicipio    
	--		FROM PAT.RespuestaPAT AS A
	--		JOIN PAT.PreguntaPAT AS P ON A.IdPreguntaPAT = P.Id
	--		INNER JOIN dbo.Municipio as M on A.IdMunicipio = M.id
	--		INNER JOIN dbo.Departamento as D on M.IdDepartamento = D.Id
	--		JOIN dbo.Usuario as U on A.IdUsuario = U.Id
	--		JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
	--		order by 3,1
		SELECT distinct 
			U.UserName as Entidad,
			TU.Nombre as TipoUsuario, 
			D.Nombre as Departamento, M.Nombre as Municipio, U.IdMunicipio    
			FROM dbo.Usuario as U 
			JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
			JOIN dbo.Municipio as M on U.IdMunicipio = M.id
			INNER JOIN dbo.Departamento as D on M.IdDepartamento = D.Id				
			where TU.Nombre in ('Alcaldía', 'Gobernación')			
			order by 3,1

	end
	else
	begin
			SELECT distinct 
			U.UserName as Entidad,
			TU.Nombre as TipoUsuario, 
			D.Nombre as Departamento, M.Nombre as Municipio, U.IdMunicipio    
			FROM dbo.Usuario as U 
			JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
			JOIN dbo.Municipio as M on U.IdMunicipio = M.id
			INNER JOIN dbo.Departamento as D on M.IdDepartamento = D.Id				
			where TU.Nombre in ('Alcaldía', 'Gobernación') and U.IdDepartamento = @IdDept
			 -- P.IdTablero = @IdTablero
			order by 3,1			
			
	end
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ListadoTablerosSeguimiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ListadoTablerosSeguimiento] AS'
go

-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		06/10/2017
-- Modified date:	
-- Description:		Procedimiento que trae el listado de tableros 
-- =============================================
ALTER PROCEDURE [PAT].[C_ListadoTablerosSeguimiento]	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Id, VigenciaInicio, VigenciaFin, YEAR(VigenciaInicio)  as AnoTablero
	FROM [PAT].Tablero		 	
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXCategoria]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_LogXCategoria] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo - OIM (Christian Ospina)
-- Create date: 18-09-2017
-- Description:	Procedimiento que consulta la información del Log
-- =============================================
ALTER PROCEDURE C_LogXCategoria
	
	@IdCategoria INT,
	@UserName VARCHAR(255)

AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		 TOP 1000 [L].[LogID]
		,CONVERT(VARCHAR, [L].[Timestamp], 103) Fecha
		,[Message] UrlYBrowser
	FROM 
		[dbo].[CategoryLog] CL
		INNER JOIN [dbo].[Log] L ON [CL].[LogID] = [L].[LogID]
		INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
	WHERE 
		(@UserName IS NULL OR ([L].[Title] = @UserName))
		AND [CL].[CategoryID] = @IdCategoria

END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaCategory]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaCategory] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 07/10/2017
-- Description:	Selecciona la información de categoría o acciones relacionadas con la auditoría
-- =============================================
ALTER PROCEDURE [dbo].[C_ListaCategory] 

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			 [CategoryID]
			,[CategoryName]
		FROM
			[dbo].[Category]
		ORDER BY 
			[CategoryName]

	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Log]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_Log] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 07/10/2017
-- Description:	Selecciona la información de la auditoría por ID
-- =============================================
ALTER PROCEDURE [dbo].[C_Log] 

	@LogID INT

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			  [LogID]
			 ,[EventID]
			 ,[Priority]
			 ,[Severity]
			 ,[Title]
			 ,[Timestamp]
			 ,[MachineName]
			 ,[AppDomainName]
			 ,[ProcessID]
			 ,[ProcessName]
			 ,[ThreadName]
			 ,[Win32ThreadId]
			 ,[Message]
			 ,[FormattedMessage]			 
		FROM
			[dbo].[Log]
		WHERE
			[LogID] = @LogID

	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ValidarRespuestasXSeccion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ValidarRespuestasXSeccion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Andrés Bonilla																			 
-- Fecha creacion: 2017-10-09																			 
-- Descripcion: Valida si hay respuestas en una seccion especifica para un usuario determinado
-- ***************************************************************************************************
ALTER PROC [dbo].[C_ValidarRespuestasXSeccion]
(
	@IdSeccion INT,
	@IdUsuario INT
)

AS

BEGIN


	DECLARE @HayRespuestas BIT

	SELECT
		@HayRespuestas = 1
	FROM
		dbo.Respuesta 
	WHERE
		IdUsuario = @IdUsuario
		AND
			IdPregunta IN 
			(
				SELECT
					XX.Id
				FROM
					dbo.Pregunta XX
				WHERE
					XX.IdSeccion = @IdSeccion
			)


	SELECT ISNULL(@HayRespuestas, 0) AS Resultado


END


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_SeccionEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_SeccionEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																	 
-- Fecha creacion: 2017-03-13																			 
-- Descripcion: Trae el listado de secciones de una encuesta	
-- Modificacion: 2017-06-17 John Betancourt  -- Adicionar campo Estilos y campo OcultaTitulo								
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_SeccionEncuesta]

	 @IdEncuesta	INT
	
AS

	SELECT 
		  [Id]
		 ,[SuperSeccion]
		 ,[Titulo] 
		 ,[Ayuda]
		 ,[Estilos]
		 ,[OcultaTitulo]
	FROM 
		[dbo].[Seccion] AS s
	WHERE 
		s.IdEncuesta = @IdEncuesta
	ORDER BY 
		Titulo

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
			  WHEN (RDP.ValorCalculo = R.Valor) THEN 1
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
			  WHEN (RDP.ValorCalculo = R.Valor) THEN 1
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
			  WHEN (RDP.ValorCalculo = R.Valor) THEN 1
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
			  WHEN (RDP.ValorCalculo = R.Valor) THEN 1
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
			  WHEN (RDP.ValorCalculo = R.Valor) THEN 1
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
			  WHEN (RDP.ValorCalculo = R.Valor) THEN 1
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
			CASE 
			  WHEN (RDP.ValorCalculo = '*' AND DATALENGTH(R.Valor)>0) THEN 1
			  WHEN (RDP.ValorCalculo = '' AND DATALENGTH(R.Valor)=0) THEN 1
			  WHEN (RDP.ValorCalculo = R.Valor) THEN 1
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
			  WHEN (RDP.ValorCalculo = R.Valor) THEN 1
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
----------------
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_EntidadesConRespuestaMunicipal]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_EntidadesConRespuestaMunicipal] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/07/2017
-- Modified date:	09/10/2017
-- Description:		Obtiene toda la informacion que tiene diligenciamiento municipal y departamental
-- ==========================================================================================
ALTER PROC [PAT].[C_EntidadesConRespuestaMunicipal]
AS
BEGIN

select  distinct Entidad,TipoUsuario,Departamento,Municipio,IdMunicipio  from  (
	SELECT distinct 
	U.UserName as Entidad,
	TU.Nombre as TipoUsuario, 
	D.Nombre as Departamento, M.Nombre as Municipio, A.IdMunicipio    
	FROM PAT.RespuestaPAT AS A
	INNER JOIN dbo.Municipio as M on A.IdMunicipio = M.id
	INNER JOIN dbo.Departamento as D on A.IdDepartamento = D.Id
	JOIN dbo.Usuario as U on  A.IdUsuario = U.Id--M.Id  = U.IdMunicipio --
	JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
	where TU.Nombre in ('Alcaldía','Alcaldia', 'ALCALDIA')
	union
	SELECT distinct 
	U.UserName as Entidad,
	TU.Nombre as TipoUsuario, 
	D.Nombre as Departamento, M.Nombre as Municipio, U.IdMunicipio 
	FROM PAT.RespuestaPAT AS A	
	INNER JOIN dbo.Departamento as D on A.IdDepartamento = D.Id	
	JOIN dbo.Usuario as U on D.Id  = U.IdDepartamento -- A.IdUsuario = U.Id
	JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
	INNER JOIN dbo.Municipio as M on U.IdMunicipio = M.id
	where TU.Nombre in ('Gobernación')
	 )as a
	order by 2,1
	
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ListadoSeguimientoConRespuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ListadoSeguimientoConRespuesta] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		05/09/2017
-- Modified date:	09/10/2017
-- Description:		Retorna los usuarios que diligenciaron respuetas 
-- ==========================================================================================
ALTER PROC [PAT].[C_ListadoSeguimientoConRespuesta] 
 @IdDept INT
AS
BEGIN
	if @IdDept IS NULL or @IdDept = 0
	begin
	--SELECT distinct 
	--		U.UserName as Entidad,
	--		TU.Nombre as TipoUsuario, 
	--		D.Nombre as Departamento, M.Nombre as Municipio, A.IdMunicipio    
	--		FROM PAT.RespuestaPAT AS A
	--		JOIN PAT.PreguntaPAT AS P ON A.IdPreguntaPAT = P.Id
	--		INNER JOIN dbo.Municipio as M on A.IdMunicipio = M.id
	--		INNER JOIN dbo.Departamento as D on M.IdDepartamento = D.Id
	--		JOIN dbo.Usuario as U on A.IdUsuario = U.Id
	--		JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
	--		order by 3,1
		SELECT distinct 
			U.UserName as Entidad,
			TU.Nombre as TipoUsuario, 
			D.Nombre as Departamento, M.Nombre as Municipio, U.IdMunicipio    
			FROM dbo.Usuario as U 
			JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
			JOIN dbo.Municipio as M on U.IdMunicipio = M.id
			INNER JOIN dbo.Departamento as D on M.IdDepartamento = D.Id				
			--where TU.Nombre in ('Alcaldía', 'Gobernación')			
			where (TU.Tipo = 'ALCALDIA' or TU.Tipo = 'GOBERNACION')
			order by 3,1

	end
	else
	begin
			SELECT distinct 
			U.UserName as Entidad,
			TU.Nombre as TipoUsuario, 
			D.Nombre as Departamento, M.Nombre as Municipio, U.IdMunicipio    
			FROM dbo.Usuario as U 
			JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
			JOIN dbo.Municipio as M on U.IdMunicipio = M.id
			INNER JOIN dbo.Departamento as D on M.IdDepartamento = D.Id				
			--where TU.Nombre in ('Alcaldía','Alcaldia', 'ALCALDIA', 'Gobernación') 
			where (TU.Tipo = 'ALCALDIA' or TU.Tipo = 'GOBERNACION')
			and U.IdDepartamento = @IdDept			
			order by 3,1			
			
	end
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ListadoTablerosSeguimiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ListadoTablerosSeguimiento] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		09/10/2017
-- Modified date:	
-- Description:		Procedimiento que trae el listado de tableros 
-- =============================================
ALTER PROCEDURE [PAT].[C_ListadoTablerosSeguimiento]	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT distinct t.Id, t.VigenciaInicio, t.VigenciaFin, YEAR(t.VigenciaInicio)  as AnoTablero
	FROM [PAT].Tablero	 as t
	join PAT.TableroFecha as tf on t.Id = tf.IdTablero
	where  getdate() >=tf.Seguimiento1Inicio or 	 getdate() >=tf.Seguimiento2Inicio
END
go

--=========================================================================================================
-- ITEMS UTILIZADOS PARA LA AUDITORIA
--=========================================================================================================

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Extender Plazo'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Extender Plazo', 77)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Archivo de Ayuda'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Archivo de Ayuda', 78)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Archivo de Ayuda'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Archivo de Ayuda', 79)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Archivo de Ayuda'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Archivo de Ayuda', 80)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home RS'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home RS', 81)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home Mint'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home Mint', 82)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home App'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home App', 83)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home Gob'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home Gob', 84)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home SL'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home SL', 85)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home Texto Footer'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home Texto Footer', 86)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home Parámetros Gobierno'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Home Parámetros Gobierno', 87)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Home Parámetros Gobierno'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Home Parámetros Gobierno', 88)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema RS'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema RS', 89)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema Mint'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema Mint', 90)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema App'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema App', 91)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema Gob'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema Gob', 92)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema SL'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema SL', 93)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema Texto Footer'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema Texto Footer', 94)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema Parámetros Gobierno'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Modificar Sistema Parámetros Gobierno', 95)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Sistema Parámetros Gobierno'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Sistema Parámetros Gobierno', 96)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Glosario'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Glosario', 98)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Glosario'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Glosario', 97)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Realimentación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Crear Realimentación', 99)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Realimentación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Realimentación', 100)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Realimentación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Realimentación', 101)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Encuesta Realimentación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Encuesta Realimentación', 102)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Gráfica Nivel Realimentación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Gráfica Nivel Realimentación', 103)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Análisis Recomendación'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Análisis Recomendación', 104)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Retroalimentación Desarrollo Pregunta'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Eliminar Retroalimentación Desarrollo Pregunta', 105)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Encuesta'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Encuesta', 106)
GO

IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Sección Encuesta'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Editar Sección Encuesta', 107)
GO
--===========================================================================================================================








