/****** Object:  Table [PAT].[PrecargueSIGO]    Script Date: 23/03/2017 8:41:10 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PAT].[PrecargueSIGO](
	[FECHA_NACIMIENTO] [varchar](50) NULL,
	[FECHA_INGRESO] [varchar](50) NULL,
	[IDENTIFICADOR_MEDIDA] [bigint] NULL,
	[NOMBRE_MEDIDA] [varchar](8000) NULL,
	[IDENTIFICADOR_NECESIDAD] [bigint] NULL,
	[NOMBRE_NECESIDAD] [varchar](8000) NULL,
	[CODIGO_DANE] [bigint] NULL,
	[MUNICIPIO] [varchar](8000) NULL
) ON [PRIMARY]

GO
