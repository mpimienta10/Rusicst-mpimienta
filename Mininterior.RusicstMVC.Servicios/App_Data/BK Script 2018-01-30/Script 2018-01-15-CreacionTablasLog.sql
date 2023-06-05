--=====================================================================================
-- Creación de la tabla que va a guardar el log de transacciones generados por RUSICST
--=====================================================================================
IF(NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA ='dbo' AND TABLE_NAME='Log'))
	BEGIN
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
	END
GO

--=====================================================================================
-- Creación de la tabla Category
--=====================================================================================
IF(NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA ='dbo' AND TABLE_NAME='Category'))
	BEGIN
		CREATE TABLE [dbo].[Category](
			[CategoryID] [int] IDENTITY(1,1) NOT NULL,
			[CategoryName] [nvarchar](64) NOT NULL,
			[Ordinal] [int] NOT NULL
		 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
		(
			[CategoryID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END
GO

--=====================================================================================
-- Creación de la tabla Category Log
--=====================================================================================
IF(NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA ='dbo' AND TABLE_NAME='CategoryLog'))
	BEGIN
		CREATE TABLE [dbo].[CategoryLog](
			[CategoryLogID] [int] IDENTITY(1,1) NOT NULL,
			[CategoryID] [int] NOT NULL,
			[LogID] [int] NOT NULL,
		 CONSTRAINT [PK_CategoryLog] PRIMARY KEY CLUSTERED 
		(
			[CategoryLogID] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]
	END
GO

IF(NOT EXISTS(SELECT 1 FROM sys.objects
WHERE type_desc LIKE '%CONSTRAINT' AND OBJECT_NAME(OBJECT_ID) = 'FK_CategoryLog_Category' 
AND OBJECT_NAME(parent_object_id) = 'CategoryLog'))
	BEGIN
		ALTER TABLE [dbo].[CategoryLog]  WITH CHECK ADD  CONSTRAINT [FK_CategoryLog_Category] FOREIGN KEY([CategoryID])
		REFERENCES [dbo].[Category] ([CategoryID])
	END
GO

ALTER TABLE [dbo].[CategoryLog] CHECK CONSTRAINT [FK_CategoryLog_Category]
GO

IF(NOT EXISTS(SELECT 1 FROM sys.objects
WHERE type_desc LIKE '%CONSTRAINT' AND OBJECT_NAME(OBJECT_ID) = 'FK_CategoryLog_Log' 
AND OBJECT_NAME(parent_object_id) = 'CategoryLog'))
	BEGIN
		ALTER TABLE [dbo].[CategoryLog]  WITH CHECK ADD  CONSTRAINT [FK_CategoryLog_Log] FOREIGN KEY([LogID])
		REFERENCES [dbo].[Log] ([LogID])
	END
GO

ALTER TABLE [dbo].[CategoryLog] CHECK CONSTRAINT [FK_CategoryLog_Log]
GO

--=====================================================================================
-- Script de inserción para la tabla categoría
--=====================================================================================
SET IDENTITY_INSERT [dbo].[Category] ON 

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Excepciones')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (98, N'Excepciones', 1)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Cerrar Sesión')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (99, N'Cerrar Sesión', 2)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Inicio Sesión')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (100, N'Inicio Sesión', 3)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Inicio Página')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (101, N'Inicio Página', 4)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Actualizar Datos')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (137, N'Actualizar Datos', 5)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Adquirir Identidad')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (138, N'Adquirir Identidad', 6)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Salvar Sección')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (139, N'Salvar Sección', 7)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Usuario')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (140, N'Eliminar Usuario', 8)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Cambiar Contraseña')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (141, N'Cambiar Contraseña', 9)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Pregunta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (142, N'Modificar Pregunta', 10)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Guardar Rol')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (143, N'Guardar Rol', 11)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Rol del Recurso')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (144, N'Eliminar Rol del Recurso', 12)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Sección')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (145, N'Eliminar Sección', 13)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Tipo de Usuario')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (146, N'Crear Tipo de Usuario', 14)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Resetiar Contraseña')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (147, N'Resetiar Contraseña', 15)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Resetiar Contraseña Error')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (148, N'Resetiar Contraseña Error', 16)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Inicio Sesión Error')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (149, N'Inicio Sesión Error', 17)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Proceso')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (150, N'Eliminar Proceso', 18)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Categoría')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (151, N'Eliminar Categoría', 19)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Objetivo')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (152, N'Eliminar Objetivo', 20)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Recomendación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (153, N'Eliminar Recomendación', 21)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Salvar Opción Respuesta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (154, N'Salvar Opción Respuesta', 22)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Encuesta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (155, N'Eliminar Encuesta', 23)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Tipo de Usuario')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (156, N'Eliminar Tipo de Usuario', 24)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Actualizar Datos del Sistema')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (157, N'Actualizar Datos del Sistema', 25)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Encuesta Duplicada')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (158, N'Encuesta Duplicada', 26)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Encuesta Duplicada Full')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (159, N'Encuesta Duplicada Full', 27)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Actualización Orden Proceso')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (160, N'Actualización Orden Proceso', 28)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Glosario')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (161, N'Eliminar Glosario', 29)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Guardar Encuesta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (162, N'Guardar Encuesta', 30)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Migración Bitácora')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (163, N'Migración Bitácora', 31)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Pregunta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (164, N'Crear Pregunta', 32)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Pregunta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (165, N'Editar Pregunta', 33)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Pregunta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (166, N'Eliminar Pregunta', 34)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Detalle de Clasificadores de Pregunta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (167, N'Editar Detalle de Clasificadores de Pregunta', 35)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Asignar Detalle de Clasificadores a Pregunta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (168, N'Asignar Detalle de Clasificadores a Pregunta', 36)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Detalle de Clasificador de Pregunta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (169, N'Eliminar Detalle de Clasificador de Pregunta', 37)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Agregar Detalle de Clasificador a Pregunta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (170, N'Agregar Detalle de Clasificador a Pregunta', 38)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Cargar Excel')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (171, N'Cargar Excel', 39)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Asociar Pregunta a Encuesta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (172, N'Asociar Pregunta a Encuesta', 40)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Rol')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (173, N'Crear Rol', 41)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Rol')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (174, N'Editar Rol', 42)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Rol')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (175, N'Eliminar Rol', 43)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Verificar Eliminación de Rol')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (176, N'Verificar Eliminación de Rol', 44)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Verificar Eliminación de Pregunta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (177, N'Verificar Eliminación de Pregunta', 45)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Agregar Usuario a Rol')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (178, N'Agregar Usuario a Rol', 46)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Remover Usuario de Rol')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (179, N'Remover Usuario de Rol', 47)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Verificar eliminación de Usuario de Rol')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (180, N'Verificar eliminación de Usuario de Rol', 48)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Asociar Encuesta a Rol')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (181, N'Asociar Encuesta a Rol', 49)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Desasociar Encuesta de Rol')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (182, N'Desasociar Encuesta de Rol', 50)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (183, N'Crear Plan de Mejoramiento', 51)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (184, N'Editar Plan de Mejoramiento', 52)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (185, N'Eliminar Plan de Mejoramiento', 53)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear sección en Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (186, N'Crear sección en Plan de Mejoramiento', 54)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar sección en Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (187, N'Editar sección en Plan de Mejoramiento', 55)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar sección de Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (188, N'Eliminar sección de Plan de Mejoramiento', 56)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Activar Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (189, N'Activar Plan de Mejoramiento', 57)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Re-Activar Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (190, N'Re-Activar Plan de Mejoramiento', 58)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Asociar Encuesta a Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (191, N'Asociar Encuesta a Plan de Mejoramiento', 59)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Desasociar Encuesta de Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (192, N'Desasociar Encuesta de Plan de Mejoramiento', 60)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Objetivo Especifico en Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (193, N'Crear Objetivo Especifico en Plan de Mejoramiento', 61)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Objetivo Especifico en Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (194, N'Editar Objetivo Especifico en Plan de Mejoramiento', 62)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Objetivo Especifico de Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (195, N'Eliminar Objetivo Especifico de Plan de Mejoramiento', 63)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Recomendación en Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (196, N'Crear Recomendación en Plan de Mejoramiento', 64)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Recomendación de Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (197, N'Eliminar Recomendación de Plan de Mejoramiento', 65)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Diligenciamiento de Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (198, N'Diligenciamiento de Plan de Mejoramiento', 67)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Finalización de Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (199, N'Finalización de Plan de Mejoramiento', 68)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Envío de Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (200, N'Envío de Plan de Mejoramiento', 69)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Tipo de Usuario')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (202, N'Modificar Tipo de Usuario', 70)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Usuario')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (203, N'Modificar Usuario', 71)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Envío Email Masivo')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (204, N'Envío Email Masivo', 72)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Envío Email Prueba')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (205, N'Envío Email Prueba', 73)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Confirmación Solicitud de Usuario')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (206, N'Confirmación Solicitud de Usuario', 74)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Gestionar Permisos - Eliminar')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (207, N'Gestionar Permisos - Eliminar', 75)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Gestionar Permisos - Adicionar')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (208, N'Gestionar Permisos - Adicionar', 76)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Extender Plazo')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (209, N'Extender Plazo', 77)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Archivo de Ayuda')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (210, N'Eliminar Archivo de Ayuda', 78)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Archivo de Ayuda')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (211, N'Crear Archivo de Ayuda', 79)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Archivo de Ayuda')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (212, N'Modificar Archivo de Ayuda', 80)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home RS')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (213, N'Modificar Home RS', 81)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home Mint')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (214, N'Modificar Home Mint', 82)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home App')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (215, N'Modificar Home App', 83)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home Gob')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (216, N'Modificar Home Gob', 84)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home SL')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (217, N'Modificar Home SL', 85)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home Texto Footer')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (218, N'Modificar Home Texto Footer', 86)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Home Parámetros Gobierno')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (219, N'Modificar Home Parámetros Gobierno', 87)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Home Parámetros Gobierno')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (220, N'Eliminar Home Parámetros Gobierno', 88)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema RS')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (221, N'Modificar Sistema RS', 89)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema Mint')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (222, N'Modificar Sistema Mint', 90)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema App')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (223, N'Modificar Sistema App', 91)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema Gob')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (224, N'Modificar Sistema Gob', 92)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema SL')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (225, N'Modificar Sistema SL', 93)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema Texto Footer')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (226, N'Modificar Sistema Texto Footer', 94)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Sistema Parámetros Gobierno')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (227, N'Modificar Sistema Parámetros Gobierno', 95)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Sistema Parámetros Gobierno')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (228, N'Eliminar Sistema Parámetros Gobierno', 96)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Glosario')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (229, N'Crear Glosario', 98)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Glosario')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (230, N'Editar Glosario', 97)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Realimentación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (231, N'Crear Realimentación', 99)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Realimentación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (232, N'Editar Realimentación', 100)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Realimentación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (233, N'Eliminar Realimentación', 101)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Encuesta Realimentación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (234, N'Editar Encuesta Realimentación', 102)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Gráfica Nivel Realimentación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (235, N'Editar Gráfica Nivel Realimentación', 103)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Análisis Recomendación Realimentación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (236, N'Editar Análisis Recomendación Realimentación', 104)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Retroalimentación Desarrollo Pregunta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (237, N'Eliminar Retroalimentación Desarrollo Pregunta', 105)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Encuesta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (238, N'Editar Encuesta', 106)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Sección Encuesta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (239, N'Editar Sección Encuesta', 107)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (240, N'Editar Respuesta PAT', 108)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (241, N'Crear Respuesta PAT', 109)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta Acciones PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (242, N'Crear Respuesta Acciones PAT', 110)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta Acciones PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (243, N'Editar Respuesta Acciones PAT', 111)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta Programa PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (244, N'Crear Respuesta Programa PAT', 112)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta Programa PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (245, N'Editar Respuesta Programa PAT', 113)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta RC PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (246, N'Crear Respuesta RC PAT', 114)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta RC PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (247, N'Editar Respuesta RC PAT', 115)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta RC Acciones PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (248, N'Crear Respuesta RC Acciones PAT', 116)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta RC Acciones PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (249, N'Editar Respuesta RC Acciones PAT', 117)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta RR PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (250, N'Crear Respuesta RR PAT', 118)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta RR PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (251, N'Editar Respuesta RR PAT', 119)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta RR Acciones PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (252, N'Crear Respuesta RR Acciones PAT', 120)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta RR Acciones PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (253, N'Editar Respuesta RR Acciones PAT', 121)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta Encuesta')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (254, N'Crear Respuesta Encuesta', 122)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Pregunta Opción')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (255, N'Editar Pregunta Opción', 123)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Pregunta Opción')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (256, N'Crear Pregunta Opción', 124)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Pregunta Opción')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (257, N'Eliminar Pregunta Opción', 125)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta Departamento RR PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (258, N'Crear Respuesta Departamento RR PAT', 126)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta Departamento RR PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (259, N'Editar Respuesta Departamento RR PAT', 127)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta Departamento RC PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (260, N'Crear Respuesta Departamento RC PAT', 128)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta Departamento RC PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (261, N'Editar Respuesta Departamento RC PAT', 129)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Respuesta Departamento PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (262, N'Crear Respuesta Departamento PAT', 130)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Respuesta Departamento PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (263, N'Editar Respuesta Departamento PAT', 131)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Preguntas PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (264, N'Crear Preguntas PAT', 132)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Preguntas PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (265, N'Editar Preguntas PAT', 133)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Reparación Colectiva Departamento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (266, N'Crear Seguimiento Reparación Colectiva Departamento', 134)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Reparación Colectiva Departamento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (267, N'Editar Seguimiento Reparación Colectiva Departamento', 135)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Retornos Reubicaciones Departamento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (268, N'Crear Seguimiento Retornos Reubicaciones Departamento', 136)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Retornos Reubicaciones Departamento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (269, N'Editar Seguimiento Retornos Reubicaciones Departamento', 137)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Gobernación Otros Derechos')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (270, N'Crear Seguimiento Gobernación Otros Derechos', 138)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Gobernación Otros Derechos')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (271, N'Editar Seguimiento Gobernación Otros Derechos', 139)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Gobernación Otros Derechos Medidas')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (272, N'Crear Seguimiento Gobernación Otros Derechos Medidas', 140)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Gobernación Otros Derechos Medidas')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (273, N'Editar Seguimiento Gobernación Otros Derechos Medidas', 141)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento PAT Gobernación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (274, N'Crear Seguimiento PAT Gobernación', 142)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento PAT Gobernación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (275, N'Editar Seguimiento PAT Gobernación', 143)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Programas Seguimiento PAT Gobernación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (276, N'Eliminar Programas Seguimiento PAT Gobernación', 144)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Programa Seguimiento PAT Gobernación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (277, N'Crear Programa Seguimiento PAT Gobernación', 145)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Programa Respuesta Acciones PAT')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (278, N'Editar Programa Respuesta Acciones PAT', 146)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Seguimiento Gobernación Otros Derechos Medidas')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (279, N'Eliminar Seguimiento Gobernación Otros Derechos Medidas', 147)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Retornos Reubicaciones Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (280, N'Crear Seguimiento Retornos Reubicaciones Municipio', 148)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Retornos Reubicaciones Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (281, N'Editar Seguimiento Retornos Reubicaciones Municipio', 149)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Seguimiento Reparacion Colectiva Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (282, N'Crear Seguimiento Seguimiento Reparacion Colectiva Municipio', 150)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Reparacion Colectiva Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (283, N'Editar Seguimiento Reparacion Colectiva Municipio', 151)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Seguimiento Otros Derechos Medidas Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (284, N'Eliminar Seguimiento Otros Derechos Medidas Municipio', 152)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Otros Derechos Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (285, N'Crear Seguimiento Otros Derechos Municipio', 153)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Otros Derechos Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (286, N'Editar Seguimiento Otros Derechos Municipio', 154)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento Otros Derechos Medidas Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (287, N'Crear Seguimiento Otros Derechos Medidas Municipio', 155)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento Otros Derechos Medidas Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (288, N'Editar Seguimiento Otros Derechos Medidas Municipio', 156)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Seguimiento PAT Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (289, N'Crear Seguimiento PAT Municipio', 157)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Seguimiento PAT Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (290, N'Editar Seguimiento PAT Municipio', 158)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'ELiminar Programas Seguimiento PAT Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (291, N'ELiminar Programas Seguimiento PAT Municipio', 159)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Programa Seguimiento PAT Gobernación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (292, N'Editar Programa Seguimiento PAT Gobernación', 160)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Programa Seguimiento PAT Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (293, N'Crear Programa Seguimiento PAT Municipio', 161)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Programa Seguimiento PAT Municipio')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (294, N'Editar Programa Seguimiento PAT Municipio', 162)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Preguntas Desarrollo Realimentación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (295, N'Crear Preguntas Desarrollo Realimentación', 163)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Grafica Desarrollo Realimentación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (296, N'Editar Grafica Desarrollo Realimentación', 164)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Preguntas Arc Realimentación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (297, N'Crear Preguntas Arc Realimentación', 165)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Preguntas Arc Realimentación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (298, N'Editar Preguntas Arc Realimentación', 166)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Preguntas Arc Realimentación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (299, N'Eliminar Preguntas Arc Realimentación', 167)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Historial Encuesta Realimentación')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (300, N'Crear Historial Encuesta Realimentación', 168)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Recurso Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (301, N'Crear Recurso Plan de Mejoramiento', 169)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Editar Recurso Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (302, N'Editar Recurso Plan de Mejoramiento', 170)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Eliminar Recurso Plan de Mejoramiento')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (303, N'Eliminar Recurso Plan de Mejoramiento', 171)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Establecer Contraseña')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (304, N'Establecer Contraseña', 172)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Envío Mail Contactenos')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (305, N'Envío Mail Contactenos', 173)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Envío Mail Contactenos Error')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (306, N'Envío Mail Contactenos Error', 174)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Remitir Solicitud de Usuario')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (307, N'Remitir Solicitud de Usuario', 175)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Solicitud de Usuario')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (308, N'Crear Solicitud de Usuario', 176)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Tablero Pat')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (309, N'Crear Tablero Pat', 177)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Tablero Pat')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (310, N'Modificar Tablero Pat', 178)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Preguntas PAT Reparación Colectiva')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (311, N'Crear Preguntas PAT Reparación Colectiva', 179)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Preguntas PAT Reparación Colectiva')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (312, N'Modificar Preguntas PAT Reparación Colectiva', 180)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Crear Preguntas PAT Retornos y Reubicaciones')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (313, N'Crear Preguntas PAT Retornos y Reubicaciones', 181)

IF NOT EXISTS(SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Modificar Preguntas PAT Retornos y Reubicaciones')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (314, N'Modificar Preguntas PAT Retornos y Reubicaciones', 182)

GO


SET IDENTITY_INSERT [dbo].[Category] OFF

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
ALTER PROCEDURE [dbo].[C_LogXCategoria] 
	
	@IdCategoria INT = NULL,
	@UserName VARCHAR(255),
	@FechaInicio DATETIME,
	@FechaFin DATETIME

AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		 TOP 1000 [L].[LogID]
		,[L].[Title] Usuario
		,CAST([L].[Timestamp] as VARCHAR) Fecha
		,[C].[CategoryName] Categoria
		,[Message] UrlYBrowser		
	FROM 
		[dbo].[CategoryLog] CL
		INNER JOIN [dbo].[Log] L ON [CL].[LogID] = [L].[LogID]
		INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
	WHERE 
		(@UserName IS NULL OR ([L].[Title] = @UserName))
		AND (@IdCategoria IS NULL OR ([CL].[CategoryID] = @IdCategoria) AND [C].[Ordinal] <> 1)
		AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
	ORDER BY [L].[Timestamp] DESC
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_LogXExcepcion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_LogXExcepcion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo - OIM (Christian Ospina)
-- Create date: 25-10-2017
-- Description:	Procedimiento que consulta la información del Log filtrado por las excepciones
--				Organiza la información desde la fecha más reciente a la más antigua
-- =============================================
ALTER PROCEDURE [dbo].[C_LogXExcepcion] 
	
	@FechaInicio DATETIME,
	@FechaFin DATETIME

AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		 TOP 1000 [L].[LogID]
		,CAST([L].[Timestamp] as VARCHAR) Fecha
		,[Message] UrlYBrowser		
	FROM 
		[dbo].[CategoryLog] CL
		INNER JOIN [dbo].[Log] L ON [CL].[LogID] = [L].[LogID]
		INNER JOIN [dbo].[Category] C on [CL].[CategoryID] = [C].[CategoryID]
	WHERE 
		[C].[Ordinal] = 1 -- CORRESPONDE A LA CATEGORIA EXCEPCIONES
		AND [L].[Timestamp] BETWEEN @FechaInicio AND @FechaFin
	ORDER BY 2 DESC

END

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
ALTER PROCEDURE [dbo].[I_LogInsert] 

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
		WHERE
			[Ordinal] <> 1
		ORDER BY 
			[CategoryName]

	END

