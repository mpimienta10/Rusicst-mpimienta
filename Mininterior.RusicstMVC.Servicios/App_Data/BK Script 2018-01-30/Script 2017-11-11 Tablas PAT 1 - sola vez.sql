
GO

/****** Object:  Table [PAT].[PreguntaPATDepartamento]    Script Date: 11/11/2017 6:37:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PAT].[PreguntaPATDepartamento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPreguntaPAT] [smallint] NOT NULL,
	[IdDepartamento] [int] NOT NULL,
 CONSTRAINT [PK_PreguntaPATDepartamento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [PAT].[PreguntaPATDepartamento]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATDepartamento_Departamento] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamento] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPATDepartamento] CHECK CONSTRAINT [FK_PreguntaPATDepartamento_Departamento]
GO

ALTER TABLE [PAT].[PreguntaPATDepartamento]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATDepartamento_PreguntaPAT] FOREIGN KEY([IdPreguntaPAT])
REFERENCES [PAT].[PreguntaPAT] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPATDepartamento] CHECK CONSTRAINT [FK_PreguntaPATDepartamento_PreguntaPAT]
GO

/****** Object:  Table [PAT].[PreguntaPATMunicipio]    Script Date: 11/11/2017 6:44:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [PAT].[PreguntaPATMunicipio](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPreguntaPAT] [smallint] NOT NULL,
	[IdMunicipio] [int] NOT NULL,
 CONSTRAINT [PK_PreguntaPATMunicipio] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [PAT].[PreguntaPATMunicipio]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATMunicipio_Municipio] FOREIGN KEY([IdMunicipio])
REFERENCES [dbo].[Municipio] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPATMunicipio] CHECK CONSTRAINT [FK_PreguntaPATMunicipio_Municipio]
GO

ALTER TABLE [PAT].[PreguntaPATMunicipio]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATMunicipio_PreguntaPATMunicipio] FOREIGN KEY([IdPreguntaPAT])
REFERENCES [PAT].[PreguntaPAT] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPATMunicipio] CHECK CONSTRAINT [FK_PreguntaPATMunicipio_PreguntaPATMunicipio]
GO


