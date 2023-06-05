ALTER TABLE [AdministracionUsuarios].[SolicitudesUsuario]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesUsuario_Departamento] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamento] ([Id])
GO

ALTER TABLE [AdministracionUsuarios].[SolicitudesUsuario] CHECK CONSTRAINT [FK_SolicitudesUsuario_Departamento]
GO

ALTER TABLE [AdministracionUsuarios].[SolicitudesUsuario]  WITH CHECK ADD  CONSTRAINT [FK_SolicitudesUsuario_Municipio] FOREIGN KEY([IdMunicipio])
REFERENCES [dbo].[Municipio] ([Id])
GO

ALTER TABLE [AdministracionUsuarios].[SolicitudesUsuario] CHECK CONSTRAINT [FK_SolicitudesUsuario_Municipio]
GO

CREATE NONCLUSTERED INDEX [IDX_SolicitudesUsuario_Departamento] ON [AdministracionUsuarios].[SolicitudesUsuario] ([IdDepartamento])
GO

CREATE NONCLUSTERED INDEX [IDX_SolicitudesUsuario_Municipio] ON [AdministracionUsuarios].[SolicitudesUsuario] ([IdMunicipio])
GO

ALTER TABLE [dbo].[Autoevaluacion2] DROP CONSTRAINT [fk_Autoevaluacion2_IdObjetivo]
GO

ALTER TABLE [dbo].[Autoevaluacion2] DROP CONSTRAINT [fk_Autoevaluacion2_IdEncuesta]
GO

ALTER TABLE [dbo].[Autoevaluacion2]  WITH CHECK ADD  CONSTRAINT [FK_Autoevaluacion2_IdEncuesta] FOREIGN KEY([IdEncuesta])
REFERENCES [dbo].[Encuesta] ([Id])
GO

ALTER TABLE [dbo].[Autoevaluacion2] CHECK CONSTRAINT [FK_Autoevaluacion2_IdEncuesta]
GO

ALTER TABLE [dbo].[Autoevaluacion2]  WITH CHECK ADD  CONSTRAINT [FK_Autoevaluacion2_IdObjetivo] FOREIGN KEY([IdObjetivo])
REFERENCES [dbo].[Objetivo] ([Id])
GO

ALTER TABLE [dbo].[Autoevaluacion2] CHECK CONSTRAINT [FK_Autoevaluacion2_IdObjetivo]
GO

CREATE NONCLUSTERED INDEX [IDX_Autoevaluacion2_IdEncuesta] ON [dbo].[Autoevaluacion2] ([IdEncuesta])
GO

CREATE NONCLUSTERED INDEX [IDX_Autoevaluacion2_IdObjetivo] ON [dbo].[Autoevaluacion2] ([IdObjetivo])
GO

ALTER TABLE [dbo].[Bitacora] DROP CONSTRAINT [PK__Bitacora__3214EC0703F0984C]
GO

ALTER TABLE [dbo].[Bitacora] ADD CONSTRAINT PK_Bitacora PRIMARY KEY CLUSTERED (Id)
GO

ALTER TABLE [dbo].[Bitacora] DROP CONSTRAINT [DF__Bitacora__Fecha__05D8E0BE]
GO

ALTER TABLE [dbo].[Bitacora] ADD CONSTRAINT [DF_Bitacora_Fecha] DEFAULT (getdate()) FOR [Fecha]
GO

CREATE NONCLUSTERED INDEX [IDX_CampanaEmail_TipoUsuario] ON [dbo].[CampanaEmail] ([IdTipoUsuario])
GO

CREATE NONCLUSTERED INDEX [IDX_CampanaEmail_Usuario] ON [dbo].[CampanaEmail] ([IdUsuario])
GO

ALTER TABLE [dbo].[Objetivo] DROP CONSTRAINT [fk_Objetivo_Categoria_IdCategoria]
GO

ALTER TABLE [dbo].[Categoria] DROP CONSTRAINT [PK__Categori__3214EC07151B244E]
GO

ALTER TABLE [dbo].[Categoria] ADD CONSTRAINT PK_Categoria PRIMARY KEY CLUSTERED (Id)
GO

ALTER TABLE [dbo].[Objetivo]  WITH CHECK ADD  CONSTRAINT [FK_Objetivo_Categoria_IdCategoria] FOREIGN KEY([IdCategoria])
REFERENCES [dbo].[Categoria] ([Id])
GO

ALTER TABLE [dbo].[Objetivo] CHECK CONSTRAINT [FK_Objetivo_Categoria_IdCategoria]
GO

ALTER TABLE [dbo].[Categoria] DROP CONSTRAINT [fk_Categoria_Proceso_IdProceso]
GO

ALTER TABLE [dbo].[Categoria]  WITH CHECK ADD  CONSTRAINT [FK_Categoria_Proceso_IdProceso] FOREIGN KEY([IdProceso])
REFERENCES [dbo].[Proceso] ([Id])
GO

ALTER TABLE [dbo].[Categoria] CHECK CONSTRAINT [FK_Categoria_Proceso_IdProceso]
GO

CREATE NONCLUSTERED INDEX [IDX_Categoria_Proceso_IdProceso] ON [dbo].[Categoria] ([IdProceso])
GO

sp_rename @objname = N'[Departamento].[PK__Departam__3214EC077B5B524B]', @newname = N'PK_Departamento'
GO

sp_rename @objname = N'[Diseno].[PK__Diseno__3214EC075AEE82B9]', @newname = N'PK_Diseno'
GO

ALTER TABLE [dbo].[Diseno] DROP CONSTRAINT [fk_Diseno_IdSeccion]
GO

ALTER TABLE [dbo].[Diseno]  WITH CHECK ADD  CONSTRAINT [FK_Diseno_IdSeccion] FOREIGN KEY([IdSeccion])
REFERENCES [dbo].[Seccion] ([Id])
GO

ALTER TABLE [dbo].[Diseno] CHECK CONSTRAINT [FK_Diseno_IdSeccion]
GO

CREATE NONCLUSTERED INDEX [IDX_Diseno_IdSeccion] ON [dbo].[Diseno] ([IdSeccion])
GO

ALTER TABLE [dbo].[Encuesta] DROP CONSTRAINT [fk_Encuesta_TipoEncuesta]
GO

ALTER TABLE [dbo].[TipoEncuesta] DROP CONSTRAINT [PK__TipoEncu__3214EC0775A278F5]
GO

EXEC sp_RENAME '[dbo].[TipoEncuesta].[Nombre]', 'Descripcion', 'COLUMN'
GO

EXEC sp_RENAME '[dbo].[TipoEncuesta].[Id]', 'Nombre', 'COLUMN'
GO

ALTER TABLE dbo.TipoEncuesta ADD Id INT IDENTITY(1,1)
GO

ALTER TABLE [dbo].[TipoEncuesta] ADD CONSTRAINT PK_TipoEncuesta PRIMARY KEY CLUSTERED (Id)
GO

UPDATE EN 
SET EN.TipoEncuesta = TI.Id
FROM Encuesta EN, TipoEncuesta TI
WHERE EN.TipoEncuesta = TI.Nombre
GO

EXEC sp_RENAME '[dbo].[Encuesta].[TipoEncuesta]', 'IdTipoEncuesta', 'COLUMN'
GO

ALTER TABLE [dbo].[Encuesta] DROP CONSTRAINT [DF__Encuesta__TipoEn__778AC167]
GO

ALTER TABLE dbo.Encuesta ALTER COLUMN IdTipoEncuesta INT
GO

ALTER TABLE [dbo].[Encuesta] ADD  DEFAULT (1) FOR [IdTipoEncuesta]
GO

ALTER TABLE [dbo].[Encuesta]  WITH CHECK ADD  CONSTRAINT [FK_Encuesta_TipoEncuesta] FOREIGN KEY([IdTipoEncuesta])
REFERENCES [dbo].[TipoEncuesta] ([Id])
GO

ALTER TABLE [dbo].[Encuesta] CHECK CONSTRAINT [FK_Encuesta_TipoEncuesta]
GO

CREATE NONCLUSTERED INDEX [IDX_Encuesta_TipoEncuesta] ON [dbo].[Encuesta] ([IdTipoEncuesta])
GO

EXEC sp_RENAME '[dbo].[Encuesta].[PK__Encuesta__3214EC075070F446]', 'PK_Encuesta'
GO

EXEC sp_RENAME '[DF__Encuesta__Autoev__7908F585]', 'DF_Encuesta_Autoevaluacion', 'OBJECT'
GO

EXEC sp_RENAME '[DF__Encuesta__IsDele__52593CB8]', 'DF_Encuesta_Eliminar', 'OBJECT'
GO

UPDATE EN
SET EN.Usuario = US.Id
FROM Envio EN, Usuario US
WHERE EN.Usuario = US.UserName
GO

EXEC sp_RENAME '[dbo].[Envio].[Usuario]', 'IdUsuario', 'COLUMN'
GO

ALTER TABLE dbo.Envio ALTER COLUMN IdUsuario INT
GO

ALTER TABLE [dbo].[Envio]  WITH CHECK ADD  CONSTRAINT [FK_Envio_Usuario] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuario] ([Id])
GO

ALTER TABLE [dbo].[Envio] CHECK CONSTRAINT [FK_Envio_Usuario]
GO

CREATE NONCLUSTERED INDEX [IDX_Envio_Encuesta] ON [dbo].[Envio] ([IdEncuesta])
GO

CREATE NONCLUSTERED INDEX [IDX_Envio_Usuario] ON [dbo].[Envio] ([IdUsuario])
GO

ALTER TABLE [dbo].[Glosario] DROP CONSTRAINT [PK__Glosario__E8181E100C85DE4D]
GO

ALTER TABLE dbo.Glosario ADD Id INT IDENTITY(1,1)
GO

ALTER TABLE [dbo].[Glosario] ADD CONSTRAINT PK_Glosario PRIMARY KEY CLUSTERED (Id)
GO

DROP TABLE HostDepartamento
GO

CREATE TABLE [dbo].[ServidorDepartamento](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdDepartamento] [int] NOT NULL,
	[Host] [varchar](255) NOT NULL,
 CONSTRAINT [PK_ServidorDepartamento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[ServidorDepartamento]  WITH CHECK ADD  CONSTRAINT [FK_ServidorDepartamento_Departamento] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamento] ([Id])
GO

ALTER TABLE [dbo].[ServidorDepartamento] CHECK CONSTRAINT [FK_ServidorDepartamento_Departamento]
GO

/****** Object:  Index [PK__Migracio__E816D0E67CD98669]    Script Date: 06/05/2017 8:57:22 a. m. ******/
ALTER TABLE [dbo].[Migracion] DROP CONSTRAINT [PK__Migracio__E816D0E67CD98669]
GO

EXEC sp_RENAME '[dbo].[Migracion].[idpregunta]', 'IdPregunta', 'COLUMN'
GO

ALTER TABLE dbo.Migracion ADD Id INT IDENTITY(1,1)
GO

ALTER TABLE [dbo].[Migracion] ADD CONSTRAINT PK_Migracion PRIMARY KEY CLUSTERED (Id)
GO

EXEC sp_RENAME '[dbo].[Migracion].[nombre]', 'Nombre', 'COLUMN'
GO

CREATE NONCLUSTERED INDEX [IDX_Migracion_Pregunta] ON [dbo].[Migracion] ([IdPregunta])
GO

EXEC sp_RENAME '[dbo].[Municipio].[PK__Municipi__3214EC077F2BE32F]', 'PK_Municipio'
GO

EXEC sp_RENAME '[fk_iddep]', 'FK_Municipio_Departamento'
GO

CREATE NONCLUSTERED INDEX [IDX_Municipio_Departamento] ON [dbo].[Municipio] ([IdDepartamento])
GO

EXEC sp_RENAME '[dbo].[Objetivo].[PK__Objetivo__3214EC071AD3FDA4]', 'PK_Objetivo'
GO

EXEC sp_RENAME '[FK_Objetivo_Categoria_IdCategoria]', 'FK_Objetivo_Categoria'
GO

CREATE NONCLUSTERED INDEX [IDX_Objetivo_Categoria] ON [dbo].[Objetivo] ([IdCategoria])
GO

EXEC sp_RENAME '[dbo].[Opciones].[PK__Opciones__3214EC0768487DD7]', 'PK_Opciones'
GO

EXEC sp_RENAME '[fk_Opciones_IdPregunta]', 'FK_Opciones_Pregunta'
GO

CREATE NONCLUSTERED INDEX [IDX_Opciones_Pregunta] ON [dbo].[Opciones] ([IdPregunta])
GO

CREATE NONCLUSTERED INDEX [IDX_PermisoUsuarioEncuesta_Encuesta] ON [dbo].[PermisoUsuarioEncuesta] ([IdEncuesta])
GO

CREATE NONCLUSTERED INDEX [IDX_PermisoUsuarioEncuesta_Usuario] ON [dbo].[PermisoUsuarioEncuesta] ([IdUsuario])
GO

CREATE NONCLUSTERED INDEX [IDX_PermisoUsuarioEncuesta_UsuarioTramite] ON [dbo].[PermisoUsuarioEncuesta] ([IdUsuarioTramite])
GO

ALTER TABLE [BancoPreguntas].[Preguntas] DROP CONSTRAINT [FK_Preguntas_TipoPregunta]
GO

ALTER TABLE [dbo].[TipoPregunta] DROP CONSTRAINT [PK__TipoPreg__3214EC076D0D32F4]
GO

EXEC sp_RENAME '[dbo].[TipoPregunta].[Nombre]', 'Descripcion', 'COLUMN'
GO

EXEC sp_RENAME '[dbo].[TipoPregunta].[Id]', 'Nombre', 'COLUMN'
GO

ALTER TABLE dbo.TipoPregunta ADD Id INT IDENTITY(1,1)
GO

ALTER TABLE [dbo].[TipoPregunta] ADD CONSTRAINT PK_TipoPregunta PRIMARY KEY CLUSTERED (Id)
GO

UPDATE PR
SET PR.TipoPregunta = TP.Id
FROM Pregunta PR, TipoPregunta TP 
WHERE PR.TipoPregunta = TP.Nombre 
GO

UPDATE PR
SET PR.TipoPregunta = TP.Id
FROM BancoPreguntas.Preguntas PR, TipoPregunta TP 
WHERE PR.TipoPregunta = TP.Nombre 
GO

EXEC sp_RENAME '[dbo].[Pregunta].[TipoPregunta]', 'IdTipoPregunta', 'COLUMN'
GO

EXEC sp_RENAME '[BancoPreguntas].[Preguntas].[TipoPregunta]', 'IdTipoPregunta', 'COLUMN'
GO

ALTER TABLE dbo.Pregunta ALTER COLUMN IdTipoPregunta INT
GO

ALTER TABLE BancoPreguntas.Preguntas ALTER COLUMN IdTipoPregunta INT
GO

ALTER TABLE [dbo].[Pregunta]  WITH CHECK ADD  CONSTRAINT [FK_Pregunta_TipoPregunta] FOREIGN KEY([IdTipoPregunta])
REFERENCES [dbo].[TipoPregunta] ([Id])
GO

ALTER TABLE [dbo].[Pregunta] CHECK CONSTRAINT [FK_Pregunta_TipoPregunta]
GO

ALTER TABLE [BancoPreguntas].[Preguntas]  WITH CHECK ADD  CONSTRAINT [FK_Preguntas_TipoPregunta] FOREIGN KEY([IdTipoPregunta])
REFERENCES [dbo].[TipoPregunta] ([Id])
GO

ALTER TABLE [BancoPreguntas].[Preguntas] CHECK CONSTRAINT [FK_Preguntas_TipoPregunta]
GO

CREATE NONCLUSTERED INDEX [IDX_Pregunta_TipoPregunta] ON [dbo].[Pregunta] ([IdTipoPregunta])
GO

CREATE NONCLUSTERED INDEX [IDX_Pregunta_TipoPregunta] ON [BancoPreguntas].[Preguntas] ([IdTipoPregunta])
GO

EXEC sp_RENAME '[dbo].[Pregunta].[PK__Pregunta__3214EC07619B8048]', 'PK_Pregunta'
GO

EXEC sp_RENAME 'fk_Pregunta_IdSeccion', 'FK_Pregunta_Seccion'
GO

EXEC sp_RENAME '[dbo].[Pregunta].[idx_ideccion]', 'IDX_Seccion'
GO

EXEC sp_RENAME '[dbo].[Pregunta].[idx_nombre]', 'IDX_Nombre'
GO

EXEC sp_RENAME '[dbo].[Proceso].[PK__Proceso__3214EC0710566F31]', 'PK_Proceso'
GO

EXEC sp_RENAME 'fk_Encuesta_Proceso', 'FK_Proceso_Encuesta'
GO

CREATE NONCLUSTERED INDEX [IDX_Proceso_Encuesta] ON [dbo].[Proceso] ([IdEncuesta])
GO

EXEC sp_RENAME '[dbo].[Recomendacion].[PK__Recomend__3214EC07395884C4]', 'PK_Recomendacion'
GO

EXEC sp_RENAME 'fk_Recomendacion_IdObjetivo', 'FK_Recomendacion_Objetivo'
GO

EXEC sp_RENAME 'fk_Recomendacion_IdOpcion', 'FK_Recomendacion_Opcion'
GO

CREATE NONCLUSTERED INDEX [IDX_Recomendacion_Objetivo] ON [dbo].[Recomendacion] ([IdObjetivo])
GO

CREATE NONCLUSTERED INDEX [FK_Recomendacion_Opcion] ON [dbo].[Recomendacion] ([IdOpcion])
GO

EXEC sp_RENAME '[dbo].[Recurso].[PK__Recurso__B91948E96BAEFA67]', 'PK_Recurso'
GO

EXEC sp_RENAME '[dbo].[Recurso].[IdRecurso]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[dbo].[Respuesta].[PK__Respuest__3214EC0770DDC3D8]', 'PK_Respuesta'
GO

EXEC sp_RENAME '[dbo].[SearchCatalog].[PK__SearchCa__3214EC0739E294A9]', 'PK_SearchCatalog'
GO

EXEC sp_RENAME '[dbo].[Seccion].[PK__Seccion__3214EC075535A963]', 'PK_Seccion'
GO

EXEC sp_RENAME '[fk_Seccion_IdEncuesta]', 'FK_Seccion_Encuesta'
GO

EXEC sp_RENAME '[dbo].[Seccion].[IsDeleted]', 'Eliminado', 'COLUMN'
GO

EXEC sp_RENAME '[dbo].[Seccion].[idx_idencuesta]', 'IDX_Encuesta'
GO

EXEC sp_RENAME '[Settings]', 'Configuraciones', 'OBJECT'
GO

EXEC sp_RENAME '[dbo].[Configuraciones].[Key]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[dbo].[Configuraciones].[RawSettings]', 'Configuracion', 'COLUMN'
GO

EXEC sp_RENAME '[dbo].[Configuraciones].[PK_dbo.Settings]', 'PK_Configuraciones'
GO

EXEC sp_RENAME '[ParametrizacionSistema].[ParametrosSistema].[IDGrupo]', 'IdGrupo', 'COLUMN'
GO

EXEC sp_RENAME '[ParametrizacionSistema].[ParametrosSistema].[ParametroID]', 'NombreParametro', 'COLUMN'
GO

EXEC sp_RENAME '[ParametrizacionSistema].[ParametrosSistema].[ParametroValor]', 'ParametroValor', 'COLUMN'
GO

ALTER TABLE [ParametrizacionSistema].[ParametrosSistema] ADD Id INT IDENTITY(1,1)
GO

ALTER TABLE [ParametrizacionSistema].[ParametrosSistema] ADD CONSTRAINT PK_ParametrosSistema PRIMARY KEY CLUSTERED (Id)
GO

EXEC sp_RENAME '[ParametrizacionSistema].[ParametrosSistemaGrupos].[IDGrupo]', 'Id', 'COLUMN'
GO

ALTER TABLE [ParametrizacionSistema].[ParametrosSistema]  WITH CHECK ADD  CONSTRAINT [FK_ParametrosSistema_ParametrosSistemaGrupos] FOREIGN KEY([IdGrupo])
REFERENCES [ParametrizacionSistema].[ParametrosSistemaGrupos] ([Id])
GO

ALTER TABLE [ParametrizacionSistema].[ParametrosSistema] CHECK CONSTRAINT [FK_ParametrosSistema_ParametrosSistemaGrupos]
GO

CREATE NONCLUSTERED INDEX [IDX_ParametrosSistema_ParametrosSistemaGrupos] ON [ParametrizacionSistema].[ParametrosSistema] ([IdGrupo])
GO

ALTER TABLE [PlanesMejoramiento].[AccionesPlan] DROP CONSTRAINT [FK_PlanesMejoramiento.AccionesPlan_PlanesMejoramiento.AccionesPlan]
GO

ALTER TABLE [PlanesMejoramiento].[AccionesPlan]  WITH CHECK ADD  CONSTRAINT [FK_PlanesMejoramiento_AccionesPlan_PlanesMejoramiento_AccionesPlan] FOREIGN KEY([IdRecomendacion])
REFERENCES [PlanesMejoramiento].[Recomendacion] ([IdRecomendacion])
GO

ALTER TABLE [PlanesMejoramiento].[AccionesPlan] CHECK CONSTRAINT [FK_PlanesMejoramiento_AccionesPlan_PlanesMejoramiento_AccionesPlan]
GO

GO
EXEC sp_RENAME '[PlanesMejoramiento].[FinalizacionPlan].[IdPlan]', 'IdPlanMejoramiento', 'COLUMN'

GO
ALTER TABLE [PlanesMejoramiento].[FinalizacionPlan]  WITH CHECK ADD  CONSTRAINT [FK_PlanesMejoramiento_FinalizacionPlan_PlanesMejoramiento_PlanMejoramiento] FOREIGN KEY([IdPlanMejoramiento])
REFERENCES [PlanesMejoramiento].[PlanMejoramiento] ([IdPlanMejoramiento])
GO

ALTER TABLE [PlanesMejoramiento].[FinalizacionPlan] CHECK CONSTRAINT [FK_PlanesMejoramiento_FinalizacionPlan_PlanesMejoramiento_PlanMejoramiento]
GO

CREATE NONCLUSTERED INDEX [IDX_PlanesMejoramiento_AccionesPlan_PlanesMejoramiento_AccionesPlan] ON [PlanesMejoramiento].[AccionesPlan] ([IdRecomendacion])
GO
CREATE NONCLUSTERED INDEX [IDX_AsignacionPlanMejoramientoRol_PlanMejoramiento] ON [PlanesMejoramiento].[AsignacionPlanMejoramientoRol] ([IdPlanMejoramiento])
GO
CREATE NONCLUSTERED INDEX [IDX_AsignacionPlanMejoramientoRol_Rol] ON [PlanesMejoramiento].[AsignacionPlanMejoramientoRol] ([IdRol])
GO
CREATE NONCLUSTERED INDEX [IDX_AsignacionPlanMejoramientoUsuario_PlanMejoramiento] ON [PlanesMejoramiento].[AsignacionPlanMejoramientoUsuario] ([IdPlanMejoramiento])
GO
CREATE NONCLUSTERED INDEX [IDX_AvancesPlan_Avance] ON [PlanesMejoramiento].[AvancesPlan] ([IdAvance])
GO
CREATE NONCLUSTERED INDEX [IDX_AvancesPlan_Recomendacion] ON [PlanesMejoramiento].[AvancesPlan] ([IdRecomendacion])
GO
CREATE NONCLUSTERED INDEX [IDX_Diligenciamiento_Autoevaluacion] ON [PlanesMejoramiento].[Diligenciamiento] ([IdAutoevaluacion])
GO
CREATE NONCLUSTERED INDEX [IDX_Diligenciamiento_Avance] ON [PlanesMejoramiento].[Diligenciamiento] ([IdAvance])
GO
CREATE NONCLUSTERED INDEX [IDX_Diligenciamiento_TipoRecurso] ON [PlanesMejoramiento].[Diligenciamiento] ([IdTipoRecurso])
GO
CREATE NONCLUSTERED INDEX [IDX_DiligenciamientoPlan_Autoevaluacion] ON [PlanesMejoramiento].[DiligenciamientoPlan] ([IdAutoevaluacion])
GO
CREATE NONCLUSTERED INDEX [IDX_DiligenciamientoPlan_Recomendacion] ON [PlanesMejoramiento].[DiligenciamientoPlan] ([IdRecomendacion])
GO
CREATE NONCLUSTERED INDEX [IDX_PlanesMejoramiento_FinalizacionPlan_PlanesMejoramiento_PlanMejoramiento] ON [PlanesMejoramiento].[FinalizacionPlan] ([IdPlanMejoramiento])
GO
CREATE NONCLUSTERED INDEX [IDX_ObjetivoEspecifico_SeccionPlanMejoramiento] ON [PlanesMejoramiento].[ObjetivoEspecifico] ([IdSeccionPlanMejoramiento])
GO
CREATE NONCLUSTERED INDEX [IDX_PlanActivacionFecha_PlanMejoramiento] ON [PlanesMejoramiento].[PlanActivacionFecha] ([IdPlanMejoramiento])
GO
CREATE NONCLUSTERED INDEX [IDX_PlanMejoramientoEncuesta_Encuesta] ON [PlanesMejoramiento].[PlanMejoramientoEncuesta] ([IdEncuesta])
GO
CREATE NONCLUSTERED INDEX [IDX_PlanMejoramientoEncuesta_PlanMejoramiento] ON [PlanesMejoramiento].[PlanMejoramientoEncuesta] ([IdPlanMejoriamiento])
GO
CREATE NONCLUSTERED INDEX [IDX_Recomendacion_ObjetivoEspecifico] ON [PlanesMejoramiento].[Recomendacion] ([IdObjetivoEspecifico])
GO
CREATE NONCLUSTERED INDEX [IDX_Recomendacion_Preguntas] ON [PlanesMejoramiento].[Recomendacion] ([IdPregunta])
GO
CREATE NONCLUSTERED INDEX [IDX_RecursosPlan_Recomendacion] ON [PlanesMejoramiento].[RecursosPlan] ([IdRecomendacion])
GO
CREATE NONCLUSTERED INDEX [IDX_RecursosPlan_TipoRecurso] ON [PlanesMejoramiento].[RecursosPlan] ([IdTipoRecurso])
GO
CREATE NONCLUSTERED INDEX [IDX_SeccionPlanMejoramiento_PlanMejoramiento] ON [PlanesMejoramiento].[SeccionPlanMejoramiento] ([IdPlanMejoramiento])
GO
CREATE NONCLUSTERED INDEX [IDX_DetalleClasificador_Clasificador] ON [BancoPreguntas].[DetalleClasificador] ([IdClasificador])
GO
CREATE NONCLUSTERED INDEX [IDX_PreguntaDetalleClasificador_DetalleClasificador] ON [BancoPreguntas].[PreguntaDetalleClasificador] ([IdDetalleClasificador])
GO
CREATE NONCLUSTERED INDEX [IDX_PreguntaDetalleClasificador_Preguntas] ON [BancoPreguntas].[PreguntaDetalleClasificador] ([IdPregunta])
GO
CREATE NONCLUSTERED INDEX [IDX_PreguntaModeloAnterior_PreguntaAnterior] ON [BancoPreguntas].[PreguntaModeloAnterior] ([IdPreguntaAnterior])
GO
CREATE NONCLUSTERED INDEX [IDX_PreguntaModeloAnterior_PreguntaBanco] ON [BancoPreguntas].[PreguntaModeloAnterior] ([IdPregunta])
GO
