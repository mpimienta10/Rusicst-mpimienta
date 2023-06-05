
/****** Object:  Table [PlanesMejoramiento].[EnvioPlan]    Script Date: 27/11/2017 10:37:16 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PlanesMejoramiento].[EnvioPlan](
	[IdEnvioPlan] [int] IDENTITY(1,1) NOT NULL,
	[IdPlan] [int] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaEnvio] [datetime] NOT NULL,
	[FechaActualizacionEnvio] [datetime] NULL,
	[RutaArchivo] [varchar](500) NULL,
 CONSTRAINT [PK_EnvioPlan] PRIMARY KEY CLUSTERED 
(
	[IdEnvioPlan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [PlanesMejoramiento].[Estrategias]    Script Date: 27/11/2017 10:37:16 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PlanesMejoramiento].[Estrategias](
	[IdEstrategia] [int] IDENTITY(1,1) NOT NULL,
	[IdSeccionPlanMejoramiento] [int] NOT NULL,
	[Estrategia] [varchar](1024) NULL,
	[Activo] [bit] NOT NULL,
 CONSTRAINT [PK_Estrategias] PRIMARY KEY CLUSTERED 
(
	[IdEstrategia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [PlanesMejoramiento].[Tareas]    Script Date: 27/11/2017 10:37:16 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PlanesMejoramiento].[Tareas](
	[IdTarea] [int] IDENTITY(1,1) NOT NULL,
	[IdEstrategia] [int] NOT NULL,
	[IdPregunta] [int] NOT NULL,
	[IdEtapa] [int] NOT NULL,
	[Tarea] [varchar](1024) NULL,
	[Opcion] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Tareas] PRIMARY KEY CLUSTERED 
(
	[IdTarea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [PlanesMejoramiento].[TareasPlan]    Script Date: 27/11/2017 10:37:16 a.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PlanesMejoramiento].[TareasPlan](
	[IdTareaPlan] [int] IDENTITY(1,1) NOT NULL,
	[IdTarea] [int] NOT NULL,
	[FechaInicioEjecucion] [datetime] NOT NULL,
	[FechaFinEjecucion] [datetime] NOT NULL,
	[Responsable] [varchar](500) NULL,
	[IdAutoevaluacion] [int] NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaDiligenciamiento] [datetime] NOT NULL,
 CONSTRAINT [PK_TareasPlan] PRIMARY KEY CLUSTERED 
(
	[IdTareaPlan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [PlanesMejoramiento].[EnvioPlan]  WITH CHECK ADD  CONSTRAINT [FK_EnvioPlan_PlanMejoramiento] FOREIGN KEY([IdPlan])
REFERENCES [PlanesMejoramiento].[PlanMejoramiento] ([IdPlanMejoramiento])
GO
ALTER TABLE [PlanesMejoramiento].[EnvioPlan] CHECK CONSTRAINT [FK_EnvioPlan_PlanMejoramiento]
GO
ALTER TABLE [PlanesMejoramiento].[Estrategias]  WITH CHECK ADD  CONSTRAINT [FK_Estrategias_SeccionPlanMejoramiento] FOREIGN KEY([IdSeccionPlanMejoramiento])
REFERENCES [PlanesMejoramiento].[SeccionPlanMejoramiento] ([IdSeccionPlanMejoramiento])
GO
ALTER TABLE [PlanesMejoramiento].[Estrategias] CHECK CONSTRAINT [FK_Estrategias_SeccionPlanMejoramiento]
GO
ALTER TABLE [PlanesMejoramiento].[Tareas]  WITH CHECK ADD  CONSTRAINT [FK_Tareas_Estrategias] FOREIGN KEY([IdEstrategia])
REFERENCES [PlanesMejoramiento].[Estrategias] ([IdEstrategia])
GO
ALTER TABLE [PlanesMejoramiento].[Tareas] CHECK CONSTRAINT [FK_Tareas_Estrategias]
GO
ALTER TABLE [PlanesMejoramiento].[TareasPlan]  WITH CHECK ADD  CONSTRAINT [FK_TareasPlan_Autoevaluacion] FOREIGN KEY([IdAutoevaluacion])
REFERENCES [PlanesMejoramiento].[Autoevaluacion] ([IdAutoevaluacion])
GO
ALTER TABLE [PlanesMejoramiento].[TareasPlan] CHECK CONSTRAINT [FK_TareasPlan_Autoevaluacion]
GO
ALTER TABLE [PlanesMejoramiento].[TareasPlan]  WITH CHECK ADD  CONSTRAINT [FK_TareasPlan_Tareas] FOREIGN KEY([IdTarea])
REFERENCES [PlanesMejoramiento].[Tareas] ([IdTarea])
GO
ALTER TABLE [PlanesMejoramiento].[TareasPlan] CHECK CONSTRAINT [FK_TareasPlan_Tareas]
GO
