--=====================================================================================
-- Creación de la tabla que va a guardar el log de transacciones generados por RUSICST
--=====================================================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Log](
	[LogID] [int] IDENTITY(1,1) NOT NULL,
	[EventID] [int] NULL,
	[Priority] [int] NOT NULL,
	[Severity] [nvarchar](32) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Timestamp] [datetime] NOT NULL,
	[MachineName] [nvarchar](32) NOT NULL,
	[AppDomainName] [nvarchar](512) NOT NULL,
	[ProcessID] [nvarchar](256) NOT NULL,
	[ProcessName] [nvarchar](512) NOT NULL,
	[ThreadName] [nvarchar](512) NULL,
	[Win32ThreadId] [nvarchar](128) NULL,
	[Message] [nvarchar](1500) NULL,
	[FormattedMessage] [ntext] NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

--=====================================================================================
-- Creación de la tabla Category
--=====================================================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](64) NOT NULL,
	[Ordinal] [int] NOT NULL
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--=====================================================================================
-- Creación de la tabla Category Log
--=====================================================================================
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CategoryLog](
	[CategoryLogID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[LogID] [int] NOT NULL,
 CONSTRAINT [PK_CategoryLog] PRIMARY KEY CLUSTERED 
(
	[CategoryLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CategoryLog]  WITH CHECK ADD  CONSTRAINT [FK_CategoryLog_Category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO

ALTER TABLE [dbo].[CategoryLog] CHECK CONSTRAINT [FK_CategoryLog_Category]
GO

ALTER TABLE [dbo].[CategoryLog]  WITH CHECK ADD  CONSTRAINT [FK_CategoryLog_Log] FOREIGN KEY([LogID])
REFERENCES [dbo].[Log] ([LogID])
GO

ALTER TABLE [dbo].[CategoryLog] CHECK CONSTRAINT [FK_CategoryLog_Log]
GO

--=====================================================================================
-- Script de inserción para la tabla categoría
--=====================================================================================
SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (98, N'Excepciones', 1)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (99, N'Cerrar Sesión', 2)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (100, N'Inicio Sesión', 3)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (101, N'Inicio Página', 4)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (137, N'Actualizar Datos', 5)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (138, N'Adquirir Identidad', 6)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (139, N'Salvar Sección', 7)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (140, N'Eliminar Usuario', 8)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (141, N'Cambiar Contraseña', 9)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (142, N'Modificar Pregunta', 10)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (143, N'Guardar Rol', 11)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (144, N'Eliminar Rol del Recurso', 12)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (145, N'Eliminar Sección', 13)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (146, N'Crear Tipo de Usuario', 14)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (147, N'Resetiar Contraseña', 15)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (148, N'Resetiar Contraseña Error', 16)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (149, N'Inicio Sesión Error', 17)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (150, N'Eliminar Proceso', 18)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (151, N'Eliminar Categoría', 19)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (152, N'Eliminar Objetivo', 20)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (153, N'Eliminar Recomendación', 21)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (154, N'Salvar Opción Respuesta', 22)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (155, N'Eliminar Encuesta', 23)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (156, N'Eliminar Tipo de Usuario', 24)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (157, N'Actualizar Datos del Sistema', 25)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (158, N'Encuesta Duplicada', 26)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (159, N'Encuesta Duplicada Full', 27)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (160, N'Actualización Orden Proceso', 28)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (161, N'Eliminar Glosario', 29)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (162, N'Guardar Encuesta', 30)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (163, N'Migración Bitácora', 31)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (164, N'Crear Pregunta', 32)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (165, N'Editar Pregunta', 33)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (166, N'Eliminar Pregunta', 34)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (167, N'Editar Detalle de Clasificadores de Pregunta', 35)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (168, N'Asignar Detalle de Clasificadores a Pregunta', 36)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (169, N'Eliminar Detalle de Clasificador de Pregunta', 37)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (170, N'Agregar Detalle de Clasificador a Pregunta', 38)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (171, N'Cargar Excel', 39)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (172, N'Asociar Pregunta a Encuesta', 40)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (173, N'Crear Rol', 41)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (174, N'Editar Rol', 42)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (175, N'Eliminar Rol', 43)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (176, N'Verificar Eliminación de Rol', 44)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (177, N'Verificar Eliminación de Pregunta', 45)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (178, N'Agregar Usuario a Rol', 46)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (179, N'Remover Usuario de Rol', 47)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (180, N'Verificar eliminación de Usuario de Rol', 48)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (181, N'Asociar Encuesta a Rol', 49)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (182, N'Desasociar Encuesta de Rol', 50)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (183, N'Crear Plan de Mejoramiento', 51)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (184, N'Editar Plan de Mejoramiento', 52)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (185, N'Eliminar Plan de Mejoramiento', 53)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (186, N'Crear sección en Plan de Mejoramiento', 54)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (187, N'Editar sección en Plan de Mejoramiento', 55)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (188, N'Eliminar sección de Plan de Mejoramiento', 56)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (189, N'Activar Plan de Mejoramiento', 57)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (190, N'Re-Activar Plan de Mejoramiento', 58)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (191, N'Asociar Encuesta a Plan de Mejoramiento', 59)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (192, N'Desasociar Encuesta de Plan de Mejoramiento', 60)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (193, N'Crear Objetivo Especifico en Plan de Mejoramiento', 61)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (194, N'Editar Objetivo Especifico en Plan de Mejoramiento', 62)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (195, N'Eliminar Objetivo Especifico de Plan de Mejoramiento', 63)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (196, N'Crear Recomendación en Plan de Mejoramiento', 64)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (197, N'Eliminar Recomendación de Plan de Mejoramiento', 65)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (198, N'Diligenciamiento de Plan de Mejoramiento', 67)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (199, N'Finalización de Plan de Mejoramiento', 68)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (200, N'Envío de Plan de Mejoramiento', 69)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (202, N'Modificar Tipo de Usuario', 70)
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (203, N'Modificar Usuario', 71)

SET IDENTITY_INSERT [dbo].[Category] OFF

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_LogInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_LogInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ===============================================================
-- Author:		Equipo de desarrollo de la OIM - Christian Ospina
-- Create date: 19-09-2017
-- Description:	Procedimiento que inserta la auditoría
-- ===============================================================
ALTER PROCEDURE I_LogInsert 

	@CategoryId			INT,
	@EventID			INT, 
	@Priority			INT, 
	@Severity			NVARCHAR(32),
	@Title				NVARCHAR(256),
	@Timestamp			DATETIME, 
	@MachineName		NVARCHAR(32),
	@AppDomainName		NVARCHAR(512),
	@ProcessID			NVARCHAR(256), 
	@ProcessName		NVARCHAR(512), 
	@ThreadName			NVARCHAR(512),
	@Win32ThreadId		NVARCHAR(128),
	@Message			NVARCHAR(1500),
	@FormattedMessage	NTEXT

AS
BEGIN
	
	SET NOCOUNT ON;

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	DECLARE @logId INT

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			INSERT INTO [dbo].[Log]
			(
				[EventID],[Priority],[Severity],[Title],[Timestamp],[MachineName],[AppDomainName],
				[ProcessID],[ProcessName],[ThreadName],[Win32ThreadId],[Message],[FormattedMessage]
			)
			 VALUES
			(
				@EventID,@Priority,@Severity,@Title,@Timestamp,@MachineName,@AppDomainName,@ProcessID,
				@ProcessName,@ThreadName,@Win32ThreadId,@Message,@FormattedMessage
			)

			SET @logId = @@IDENTITY

			IF (@@IDENTITY > 0)
			BEGIN
				SET @CategoryId = (SELECT CategoryID FROM [dbo].[Category] WHERE [Ordinal] = @CategoryId)
				INSERT INTO [dbo].[CategoryLog]
				(
					[CategoryID],[LogID]
				)
				VALUES
				(
					@CategoryId,@logId
				)
			END

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
---------------------------

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
			CASE R.Valor
			  WHEN RDP.ValorCalculo THEN 1
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

			go
CREATE TABLE [dbo].[RetroEtapaPreguntas](
	[Nombre] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'DISENO2015')
GO
INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'DISENO2016')
GO
INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'DISENO2017')
GO
INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'IMPLEMENTACION2015')
GO
INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'IMPLEMENTACION2016')
GO
INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'IMPLEMENTACION2017')
GO
INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'EVALUACION2015')
GO
INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'EVALUACION2016')
GO
INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'EVALUACION2017')
GO

