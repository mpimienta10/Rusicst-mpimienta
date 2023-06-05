ALTER TABLE PAT.PrecargueSIGO ADD Id INT IDENTITY(1,1)
GO

ALTER TABLE PAT.PrecargueSIGO ADD CONSTRAINT PK_PrecargueSIGO PRIMARY KEY CLUSTERED (Id)
GO

EXEC sp_RENAME '[PAT].[PrecargueSIGO].[FECHA_NACIMIENTO]', 'FechaNacimiento', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PrecargueSIGO].[FECHA_INGRESO]', 'FechaIngreso', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PrecargueSIGO].[IDENTIFICADOR_MEDIDA]', 'IdentificadorMedida', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PrecargueSIGO].[NOMBRE_MEDIDA]', 'NombreMedida', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PrecargueSIGO].[IDENTIFICADOR_NECESIDAD]', 'IdentificadorNecesidad', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PrecargueSIGO].[NOMBRE_NECESIDAD]', 'NombreNecesidad', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PrecargueSIGO].[CODIGO_DANE]', 'CodigoDane', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PrecargueSIGO].[MUNICIPIO]', 'Municipio', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[TB_COMPONENTE]', 'Componente'
GO

EXEC sp_RENAME '[PAT].[Componente].[ID]', 'Temporal', 'COLUMN'
GO

ALTER TABLE PAT.Componente ADD Id INT IDENTITY(1,1)
GO

ALTER TABLE PAT.Componente ADD CONSTRAINT PK_Componente PRIMARY KEY CLUSTERED (Id)
GO

ALTER TABLE PAT.Componente DROP COLUMN Temporal
GO

EXEC sp_RENAME '[PAT].[Componente].[DESCRIPCION]', 'Descripcion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Componente].[ACTIVO]', 'Activo', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Componente].[INDIVIDUAL]', 'Individual', 'COLUMN'
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_DERECHO' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_DERECHO].' + QUOTENAME(c.name) + ''',''PK_Derecho'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_DERECHO' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_DERECHO]', 'Derecho'
GO

EXEC sp_RENAME '[PAT].[Derecho].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Derecho].[DESCRIPCION]', 'Descripcion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[TB_ENTIDAD]', 'Entidad'
GO

EXEC sp_RENAME '[PAT].[Entidad].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Entidad].[DESCRIPCION]', 'Descripcion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Entidad].[ID_DEPARTAMENTO]', 'IdDepartamento', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Entidad].[ID_MUNICIPIO]', 'IdMunicipio', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Entidad].[ACTIVO]', 'Activo', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Entidad].[ID_ORDEN_CLASIFICACION]', 'OrdenClasificacion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Entidad].[OFERTA]', 'Oferta', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Entidad].[REMISION]', 'Remision', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Entidad].[PK_ID]', 'PK_Entidad'
GO

UPDATE PAT.TB_DANE
SET Id = 33
WHERE Id = 333 AND ID_DANE = 95
GO

INSERT INTO [PAT].[TB_DANE]
           ([ID_DANE]
           ,[ID]
           ,[DESCRIPCION])
     VALUES
           (19300
		   ,410
		   ,'GUACHENE')
GO


UPDATE PAT.Entidad
SET IdMunicipio = 8638 WHERE IdMunicipio = 178
GO

UPDATE 
	a
SET 
	a.IdDepartamento = b.ID_DANE
FROM 
	PAT.Entidad a
	INNER JOIN PAT.TB_DANE b ON a.IdDepartamento = b.ID
WHERE 
	a.IdDepartamento IS NOT NULL
GO

UPDATE 
	a
SET 
	a.IdMunicipio = b.ID_DANE
FROM 
	PAT.Entidad a
	INNER JOIN PAT.TB_DANE b ON a.IdMunicipio = b.ID
WHERE 
	a.IdMunicipio IS NOT NULL
GO

ALTER TABLE [PAT].[Entidad]  WITH CHECK ADD  CONSTRAINT [FK_Entidad_Departamento] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamento] ([Id])
GO

ALTER TABLE [PAT].[Entidad] CHECK CONSTRAINT [FK_Entidad_Departamento]
GO

ALTER TABLE [PAT].[Entidad]  WITH CHECK ADD  CONSTRAINT [FK_Entidad_Municipio] FOREIGN KEY([IdMunicipio])
REFERENCES [dbo].[Municipio] ([Id])
GO

ALTER TABLE [PAT].[Entidad] CHECK CONSTRAINT [FK_Entidad_Municipio]
GO

CREATE NONCLUSTERED INDEX [IDX_Entidad_Departamento] ON [PAT].[Entidad] ([IdDepartamento])
GO

CREATE NONCLUSTERED INDEX [IDX_Entidad_Municipio] ON [PAT].[Entidad] ([IdMunicipio])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_ENTIDAD_CONTROL].' + QUOTENAME(c.name) + ''',''PK_EntidadControl'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_ENTIDAD_CONTROL' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_ENTIDAD_CONTROL]', 'EntidadControl'
GO

EXEC sp_RENAME '[PAT].[EntidadControl].[ID]', 'Id', 'COLUMN'
GO

ALTER TABLE [PAT].[EntidadControl] ADD IdDepartamento INT
GO

ALTER TABLE [PAT].[EntidadControl] ADD IdMunicipio INT
GO

UPDATE a
SET a.IdDepartamento = b.Id
FROM 
	[PAT].[EntidadControl] a
	INNER JOIN Departamento b ON a.ID_DANE = b.Id
GO

UPDATE a
SET a.IdMunicipio = b.Id
FROM 
	[PAT].[EntidadControl] a
	INNER JOIN Municipio b ON a.ID_DANE = b.Id
GO

ALTER TABLE [PAT].[EntidadControl] DROP COLUMN ID_DANE
GO

EXEC sp_RENAME '[PAT].[EntidadControl].[DESCRIPCION]', 'Descripcion', 'COLUMN'
GO

ALTER TABLE [PAT].[EntidadControl]  WITH CHECK ADD  CONSTRAINT [FK_EntidadControl_Departamento] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamento] ([Id])
GO

ALTER TABLE [PAT].[EntidadControl] CHECK CONSTRAINT [FK_EntidadControl_Departamento]
GO

ALTER TABLE [PAT].[EntidadControl]  WITH CHECK ADD  CONSTRAINT [FK_EntidadControl_Municipio] FOREIGN KEY([IdMunicipio])
REFERENCES [dbo].[Municipio] ([Id])
GO

ALTER TABLE [PAT].[EntidadControl] CHECK CONSTRAINT [FK_EntidadControl_Municipio]
GO

CREATE NONCLUSTERED INDEX [IDX_EntidadControl_Departamento] ON [PAT].[EntidadControl] ([IdDepartamento])
GO

CREATE NONCLUSTERED INDEX [IDX_EntidadControl_Municipio] ON [PAT].[EntidadControl] ([IdMunicipio])
GO

EXEC sp_RENAME '[PAT].[TB_MEDIDA]', 'Medida'
GO

EXEC sp_RENAME '[PAT].[Medida].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Medida].[DESCRIPCION]', 'Descripcion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Medida].[PK_IDMedida]', 'PK_Medida'
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_TABLERO].' + QUOTENAME(c.name) + ''',''PK_Tablero'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_TABLERO' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_TABLERO]', 'Tablero'
GO

EXEC sp_RENAME '[PAT].[Tablero].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Tablero].[VIGENCIA_INICIO]', 'VigenciaInicio', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Tablero].[VIGENCIA_FIN]', 'VigenciaFin', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[Tablero].[ACTIVO]', 'Activo', 'COLUMN'
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_TABLERO_FECHA' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_TABLERO_FECHA].' + QUOTENAME(c.name) + ''',''PK_TableroFecha'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_TABLERO_FECHA' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_TABLERO_FECHA]', 'TableroFecha'
GO

EXEC sp_RENAME '[PAT].[TableroFecha].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[TableroFecha].[ID_TABLERO]', 'IdTablero', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[TableroFecha].[NIVEL]', 'Nivel', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[TableroFecha].[VIGENCIA_INICIO]', 'VigenciaInicio', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[TableroFecha].[VIGENCIA_FIN]', 'VigenciaFin', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[TableroFecha].[ACTIVO]', 'Activo', 'COLUMN'
GO

ALTER TABLE [PAT].[TableroFecha]  WITH CHECK ADD  CONSTRAINT [FK_TableroFecha_Tablero] FOREIGN KEY([IdTablero])
REFERENCES [PAT].[Tablero] ([Id])
GO

ALTER TABLE [PAT].[TableroFecha] CHECK CONSTRAINT [FK_TableroFecha_Tablero]
GO

CREATE NONCLUSTERED INDEX [IDX_TableroFecha_Tablero] ON [PAT].[TableroFecha] ([IdTablero])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_UNIDAD_MEDIDA].' + QUOTENAME(c.name) + ''',''PK_UnidadMedida'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_UNIDAD_MEDIDA' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_UNIDAD_MEDIDA]', 'UnidadMedida'
GO

EXEC sp_RENAME '[PAT].[UnidadMedida].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[UnidadMedida].[DESCRIPCION]', 'Descripcion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[UnidadMedida].[ID_BENEFICIARIO_UNIDAD]', 'BeneficiarioUnidad', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[UnidadMedida].[ACTIVO]', 'Activo', 'COLUMN'
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PREGUNTA' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PREGUNTA].' + QUOTENAME(c.name) + ''',''PK_PreguntaPAT'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PREGUNTA' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PREGUNTA]', 'PreguntaPAT'
GO

EXEC sp_RENAME '[PAT].[PreguntaPAT].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPAT].[ID_DERECHO]', 'IdDerecho', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPAT].[ID_COMPONENTE]', 'IdComponente', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPAT].[ID_MEDIDA]', 'IdMedida', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPAT].[NIVEL]', 'Nivel', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPAT].[PREGUNTA_INDICATIVA]', 'PreguntaIndicativa', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPAT].[ID_UNIDAD_MEDIDA]', 'IdUnidadMedida', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPAT].[PREGUNTA_COMPROMISO]', 'PreguntaCompromiso', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPAT].[APOYO_DEPARTAMENTAL]', 'ApoyoDepartamental', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPAT].[APOYO_ENTIDAD_NACIONAL]', 'ApoyoEntidadNacional', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPAT].[ACTIVO]', 'Activo', 'COLUMN'
GO

ALTER TABLE [PAT].[PreguntaPAT] ALTER COLUMN IdComponente INT NOT NULL
GO

ALTER TABLE [PAT].[PreguntaPAT] ALTER COLUMN IdMedida INT NOT NULL
GO

INSERT INTO PAT.Medida
(
	Id
	,Descripcion
)
SELECT DISTINCT IdMedida, 'Sin Medida' 
FROM PAT.PreguntaPAT 
WHERE IdMedida
NOT IN (Select Id from PAT.Medida)
GO

ALTER TABLE [PAT].[PreguntaPAT]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPAT_Componente] FOREIGN KEY([IdComponente])
REFERENCES [PAT].[Componente] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPAT] CHECK CONSTRAINT [FK_PreguntaPAT_Componente]
GO

ALTER TABLE [PAT].[PreguntaPAT]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPAT_Derecho] FOREIGN KEY([IdDerecho])
REFERENCES [PAT].[Derecho] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPAT] CHECK CONSTRAINT [FK_PreguntaPAT_Derecho]
GO

ALTER TABLE [PAT].[PreguntaPAT]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPAT_Medida] FOREIGN KEY([IdMedida])
REFERENCES [PAT].[Medida] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPAT] CHECK CONSTRAINT [FK_PreguntaPAT_Medida]
GO

ALTER TABLE [PAT].[PreguntaPAT]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPAT_UnidadMedida] FOREIGN KEY([IdUnidadMedida])
REFERENCES [PAT].[UnidadMedida] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPAT] CHECK CONSTRAINT [FK_PreguntaPAT_UnidadMedida]
GO

CREATE NONCLUSTERED INDEX [IDX_PreguntaPAT_Componente] ON [PAT].[PreguntaPAT] ([IdComponente])
GO

CREATE NONCLUSTERED INDEX [IDX_PreguntaPAT_Derecho] ON [PAT].[PreguntaPAT] ([IdDerecho])
GO

CREATE NONCLUSTERED INDEX [IDX_PreguntaPAT_Medida] ON [PAT].[PreguntaPAT] ([IdMedida])
GO

CREATE NONCLUSTERED INDEX [IDX_PreguntaPAT_UnidadMedida] ON [PAT].[PreguntaPAT] ([IdUnidadMedida])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PREGUNTA_RC].' + QUOTENAME(c.name) + ''',''PK_PreguntaPATReparacionColectiva'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PREGUNTA_RC' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PREGUNTA_RC]', 'PreguntaPATReparacionColectiva'
GO

EXEC sp_RENAME '[PAT].[PreguntaPATReparacionColectiva].[ID]', 'Id', 'COLUMN'
GO

ALTER TABLE [PAT].PreguntaPATReparacionColectiva ADD IdDepartamento INT
GO

ALTER TABLE [PAT].PreguntaPATReparacionColectiva ADD IdMunicipio INT
GO

UPDATE a
SET a.IdDepartamento = b.Id
FROM 
	[PAT].[PreguntaPATReparacionColectiva] a
	INNER JOIN Departamento b ON a.ID_DANE = b.Id
GO

UPDATE a
SET a.IdMunicipio = b.Id
FROM 
	[PAT].[PreguntaPATReparacionColectiva] a
	INNER JOIN Municipio b ON a.ID_DANE = b.Id
GO

ALTER TABLE [PAT].[PreguntaPATReparacionColectiva] DROP COLUMN ID_DANE
GO

EXEC sp_RENAME '[PAT].[PreguntaPATReparacionColectiva].[ID_MEDIDA]', 'IdMedida', 'COLUMN'
GO

ALTER TABLE [PAT].[PreguntaPATReparacionColectiva] ALTER COLUMN IdMedida INT NOT NULL
GO

EXEC sp_RENAME '[PAT].[PreguntaPATReparacionColectiva].[SUJETO]', 'Sujeto', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPATReparacionColectiva].[MEDIDA_RC]', 'MedidaReparacionColectiva', 'COLUMN'
GO

ALTER TABLE [PAT].[PreguntaPATReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATReparacionColectiva_Departamento] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamento] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPATReparacionColectiva] CHECK CONSTRAINT [FK_PreguntaPATReparacionColectiva_Departamento]
GO

ALTER TABLE [PAT].[PreguntaPATReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATReparacionColectiva_Municipio] FOREIGN KEY([IdMunicipio])
REFERENCES [dbo].[Municipio] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPATReparacionColectiva] CHECK CONSTRAINT [FK_PreguntaPATReparacionColectiva_Municipio]
GO

ALTER TABLE [PAT].[PreguntaPATReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATReparacionColectiva_Medida] FOREIGN KEY([IdMedida])
REFERENCES [PAT].[Medida] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPATReparacionColectiva] CHECK CONSTRAINT [FK_PreguntaPATReparacionColectiva_Medida]
GO

CREATE NONCLUSTERED INDEX [IDX_PreguntaPATReparacionColectiva_Departamento] ON [PAT].[PreguntaPATReparacionColectiva] ([IdDepartamento])
GO

CREATE NONCLUSTERED INDEX [IDX_PreguntaPATReparacionColectiva_Municipio] ON [PAT].[PreguntaPATReparacionColectiva] ([IdMunicipio])
GO

CREATE NONCLUSTERED INDEX [IDX_PreguntaPATReparacionColectiva_Medida] ON [PAT].[PreguntaPATReparacionColectiva] ([IdMedida])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PREGUNTA_RR].' + QUOTENAME(c.name) + ''',''PK_PreguntaPATRetornosReubicaciones'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PREGUNTA_RR' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PREGUNTA_RR]', 'PreguntaPATRetornosReubicaciones'
GO

EXEC sp_RENAME '[PAT].[PreguntaPATRetornosReubicaciones].[ID]', 'Id', 'COLUMN'
GO

ALTER TABLE [PAT].PreguntaPATRetornosReubicaciones ADD IdDepartamento INT
GO

ALTER TABLE [PAT].PreguntaPATRetornosReubicaciones ADD IdMunicipio INT
GO

UPDATE a
SET a.IdDepartamento = b.Id
FROM 
	[PAT].[PreguntaPATRetornosReubicaciones] a
	INNER JOIN Departamento b ON a.ID_DANE = b.Id
GO

UPDATE a
SET a.IdMunicipio = b.Id
FROM 
	[PAT].[PreguntaPATRetornosReubicaciones] a
	INNER JOIN Municipio b ON a.ID_DANE = b.Id
GO

ALTER TABLE [PAT].[PreguntaPATRetornosReubicaciones] DROP COLUMN ID_DANE
GO

EXEC sp_RENAME '[PAT].[PreguntaPATRetornosReubicaciones].[HOGARES]', 'Hogares', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPATRetornosReubicaciones].[PERSONAS]', 'Personas', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPATRetornosReubicaciones].[SECTOR]', 'Sector', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPATRetornosReubicaciones].[COMPONENTE]', 'Componente', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPATRetornosReubicaciones].[COMUNIDAD]', 'Comunidad', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPATRetornosReubicaciones].[UBICACION]', 'Ubicacion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPATRetornosReubicaciones].[MEDIDA_RR]', 'MedidaRetornoReubicacion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPATRetornosReubicaciones].[INDICADOR_RR]', 'IndicadorRetornoReubicacion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[PreguntaPATRetornosReubicaciones].[ENTIDAD_RESPONSABLE]', 'EntidadResponsable', 'COLUMN'
GO

ALTER TABLE [PAT].[PreguntaPATRetornosReubicaciones]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATRetornosReubicaciones_Departamento] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamento] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPATRetornosReubicaciones] CHECK CONSTRAINT [FK_PreguntaPATRetornosReubicaciones_Departamento]
GO

ALTER TABLE [PAT].[PreguntaPATRetornosReubicaciones]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATRetornosReubicaciones_Municipio] FOREIGN KEY([IdMunicipio])
REFERENCES [dbo].[Municipio] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPATRetornosReubicaciones] CHECK CONSTRAINT [FK_PreguntaPATRetornosReubicaciones_Municipio]
GO

CREATE NONCLUSTERED INDEX [IDX_PreguntaPATRetornosReubicaciones_Departamento] ON [PAT].[PreguntaPATRetornosReubicaciones] ([IdDepartamento])
GO

CREATE NONCLUSTERED INDEX [IDX_PreguntaPATRetornosReubicaciones_Municipio] ON [PAT].[PreguntaPATRetornosReubicaciones] ([IdMunicipio])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PAT_RESPUESTA].' + QUOTENAME(c.name) + ''',''PK_RespuestaPAT'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PAT_RESPUESTA]', 'RespuestaPAT'
GO

EXEC sp_RENAME '[PAT].[RespuestaPAT].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPAT].[ID_TABLERO]', 'IdTablero', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPAT].[ID_ENTIDAD]', 'IdEntidad', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPAT].[ID_PREGUNTA]', 'IdPreguntaPAT', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPAT].[NECESIDAD_IDENTIFICADA]', 'NecesidadIdentificada', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPAT].[RESPUESTA_INDICATIVA]', 'RespuestaIndicativa', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPAT].[RESPUESTA_COMPROMISO]', 'RespuestaCompromiso', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPAT].[PRESUPUESTO]', 'Presupuesto', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPAT].[OBSERVACION_NECESIDAD]', 'ObservacionNecesidad', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPAT].[ACCION_COMPROMISO]', 'AccionCompromiso', 'COLUMN'
GO

INSERT INTO [PAT].[Entidad]
           ([Id]
           ,[Descripcion]
           ,[IdDepartamento]
           ,[IdMunicipio]
           ,[Activo]
           ,[OrdenClasificacion]
           ,[Oferta]
           ,[Remision])

SELECT DISTINCT IdEntidad, 'Sin Entidad', NULL, NULL, NULL, NULL, NULL, NULL FROM PAT.RespuestaPAT 
WHERE IdEntidad NOT IN
(
SELECT Id from PAT.Entidad
)
GO

ALTER TABLE [PAT].[RespuestaPAT]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPAT_Entidad] FOREIGN KEY([IdEntidad])
REFERENCES [PAT].[Entidad] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPAT] CHECK CONSTRAINT [FK_RespuestaPAT_Entidad]
GO

ALTER TABLE [PAT].[RespuestaPAT]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPAT_PreguntaPAT] FOREIGN KEY([IdPreguntaPAT])
REFERENCES [PAT].[PreguntaPAT] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPAT] CHECK CONSTRAINT [FK_RespuestaPAT_PreguntaPAT]
GO

ALTER TABLE [PAT].[RespuestaPAT]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPAT_Tablero] FOREIGN KEY([IdTablero])
REFERENCES [PAT].[Tablero] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPAT] CHECK CONSTRAINT [FK_RespuestaPAT_Tablero]
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPAT_Entidad] ON [PAT].[RespuestaPAT] ([IdEntidad])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPAT_PreguntaPAT] ON [PAT].[RespuestaPAT] ([IdPreguntaPAT])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPAT_Tablero] ON [PAT].[RespuestaPAT] ([IdTablero])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_ACCION' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PAT_RESPUESTA_ACCION].' + QUOTENAME(c.name) + ''',''PK_RespuestaPATAccion'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_ACCION' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PAT_RESPUESTA_ACCION]', 'RespuestaPATAccion'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATAccion].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATAccion].[ID_PAT_RESPUESTA]', 'IdRespuestaPAT', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATAccion].[ACCION]', 'Accion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATAccion].[ACTIVO]', 'Activo', 'COLUMN'
GO

ALTER TABLE [PAT].[RespuestaPATAccion]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATAccion_RespuestaPAT] FOREIGN KEY([IdRespuestaPAT])
REFERENCES [PAT].[RespuestaPAT] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATAccion] CHECK CONSTRAINT [FK_RespuestaPATAccion_RespuestaPAT]
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATAccion_RespuestaPAT] ON [PAT].[RespuestaPATAccion] ([IdRespuestaPAT])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_DEPARTAMENTO' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PAT_RESPUESTA_DEPARTAMENTO].' + QUOTENAME(c.name) + ''',''PK_RespuestaPATDepartamento'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_DEPARTAMENTO' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PAT_RESPUESTA_DEPARTAMENTO]', 'RespuestaPATDepartamento'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamento].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamento].[ID_TABLERO]', 'IdTablero', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamento].[ID_ENTIDAD]', 'IdEntidad', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamento].[ID_ENTIDAD_MUNICIPIO]', 'IdEntidadMunicipio', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamento].[ID_PREGUNTA]', 'IdPreguntaPAT', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamento].[RESPUESTA_COMPROMISO]', 'RespuestaCompromiso', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamento].[PRESUPUESTO]', 'Presupuesto', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamento].[OBSERVACION_COMPROMISO]', 'ObservacionCompromiso', 'COLUMN'
GO

ALTER TABLE [PAT].[RespuestaPATDepartamento]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATDepartamento_Entidad] FOREIGN KEY([IdEntidad])
REFERENCES [PAT].[Entidad] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATDepartamento] CHECK CONSTRAINT [FK_RespuestaPATDepartamento_Entidad]
GO

ALTER TABLE [PAT].[RespuestaPATDepartamento]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATDepartamento_EntidadMunicipio] FOREIGN KEY([IdEntidadMunicipio])
REFERENCES [PAT].[Entidad] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATDepartamento] CHECK CONSTRAINT [FK_RespuestaPATDepartamento_EntidadMunicipio]
GO

ALTER TABLE [PAT].[RespuestaPATDepartamento]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATDepartamento_Tablero] FOREIGN KEY([IdTablero])
REFERENCES [PAT].[Tablero] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATDepartamento] CHECK CONSTRAINT [FK_RespuestaPATDepartamento_Tablero]
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATDepartamento_Entidad] ON [PAT].[RespuestaPATDepartamento] ([IdEntidad])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATDepartamento_EntidadMunicipio] ON [PAT].[RespuestaPATDepartamento] ([IdEntidadMunicipio])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATDepartamento_Tablero] ON [PAT].[RespuestaPATDepartamento] ([IdTablero])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_DEPARTAMENTO_RC' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PAT_RESPUESTA_DEPARTAMENTO_RC].' + QUOTENAME(c.name) + ''',''PK_RespuestaPATDepartamentoReparacionColectiva'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_DEPARTAMENTO_RC' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PAT_RESPUESTA_DEPARTAMENTO_RC]', 'RespuestaPATDepartamentoReparacionColectiva'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoReparacionColectiva].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoReparacionColectiva].[ID_TABLERO]', 'IdTablero', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoReparacionColectiva].[ID_ENTIDAD]', 'IdEntidad', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoReparacionColectiva].[ID_ENTIDAD_MUNICIPIO]', 'IdEntidadMunicipio', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoReparacionColectiva].[ID_PREGUNTA_RC]', 'IdPreguntaPATReparacionColectiva', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoReparacionColectiva].[ACCION_DEPARTAMENTO]', 'AccionDepartamento', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoReparacionColectiva].[PRESUPUESTO_DEPARTAMENTO]', 'PresupuestoDepartamento', 'COLUMN'
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATDepartamentoReparacionColectiva_Entidad] FOREIGN KEY([IdEntidad])
REFERENCES [PAT].[Entidad] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoReparacionColectiva] CHECK CONSTRAINT [FK_RespuestaPATDepartamentoReparacionColectiva_Entidad]
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATDepartamentoReparacionColectiva_EntidadMunicipio] FOREIGN KEY([IdEntidadMunicipio])
REFERENCES [PAT].[Entidad] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoReparacionColectiva] CHECK CONSTRAINT [FK_RespuestaPATDepartamentoReparacionColectiva_EntidadMunicipio]
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATDepartamentoReparacionColectiva_Tablero] FOREIGN KEY([IdTablero])
REFERENCES [PAT].[Tablero] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoReparacionColectiva] CHECK CONSTRAINT [FK_RespuestaPATDepartamentoReparacionColectiva_Tablero]
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATDepartamentoReparacionColectiva_PreguntaPATReparacionColectiva] FOREIGN KEY([IdPreguntaPATReparacionColectiva])
REFERENCES [PAT].[PreguntaPATReparacionColectiva] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoReparacionColectiva] CHECK CONSTRAINT [FK_RespuestaPATDepartamentoReparacionColectiva_PreguntaPATReparacionColectiva]
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATDepartamentoReparacionColectiva_Entidad] ON [PAT].[RespuestaPATDepartamentoReparacionColectiva] ([IdEntidad])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATDepartamentoReparacionColectiva_EntidadMunicipio] ON [PAT].[RespuestaPATDepartamentoReparacionColectiva] ([IdEntidadMunicipio])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATDepartamentoReparacionColectiva_Tablero] ON [PAT].[RespuestaPATDepartamentoReparacionColectiva] ([IdTablero])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATDepartamentoReparacionColectiva_PreguntaPATReparacionColectiva] ON [PAT].[RespuestaPATDepartamentoReparacionColectiva] ([IdPreguntaPATReparacionColectiva])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_DEPARTAMENTO_RR' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PAT_RESPUESTA_DEPARTAMENTO_RR].' + QUOTENAME(c.name) + ''',''PK_RespuestaPATDepartamentoRetornosReubicaciones'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_DEPARTAMENTO_RR' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PAT_RESPUESTA_DEPARTAMENTO_RR]', 'RespuestaPATDepartamentoRetornosReubicaciones'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoRetornosReubicaciones].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoRetornosReubicaciones].[ID_TABLERO]', 'IdTablero', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoRetornosReubicaciones].[ID_ENTIDAD]', 'IdEntidad', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoRetornosReubicaciones].[ID_ENTIDAD_MUNICIPIO]', 'IdEntidadMunicipio', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoRetornosReubicaciones].[ID_PREGUNTA_RR]', 'IdPreguntaPATRetornoReubicacion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoRetornosReubicaciones].[ACCION_DEPARTAMENTO]', 'AccionDepartamento', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATDepartamentoRetornosReubicaciones].[PRESUPUESTO_DEPARTAMENTO]', 'PresupuestoDepartamento', 'COLUMN'
GO

INSERT INTO [PAT].[Entidad]
           ([Id]
           ,[Descripcion]
           ,[IdDepartamento]
           ,[IdMunicipio]
           ,[Activo]
           ,[OrdenClasificacion]
           ,[Oferta]
           ,[Remision])

SELECT DISTINCT IdEntidadMunicipio, 'Sin Entidad', NULL, NULL, NULL, NULL, NULL, NULL FROM PAT.RespuestaPATDepartamentoRetornosReubicaciones 
WHERE IdEntidadMunicipio NOT IN
(
SELECT Id from PAT.Entidad
)
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoRetornosReubicaciones]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATDepartamentoRetornosReubicaciones_Entidad] FOREIGN KEY([IdEntidad])
REFERENCES [PAT].[Entidad] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoRetornosReubicaciones] CHECK CONSTRAINT [FK_RespuestaPATDepartamentoRetornosReubicaciones_Entidad]
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoRetornosReubicaciones]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATDepartamentoRetornosReubicaciones_EntidadMunicipio] FOREIGN KEY([IdEntidadMunicipio])
REFERENCES [PAT].[Entidad] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoRetornosReubicaciones] CHECK CONSTRAINT [FK_RespuestaPATDepartamentoRetornosReubicaciones_EntidadMunicipio]
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoRetornosReubicaciones]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATDepartamentoRetornosReubicaciones_PreguntaPATRetornosReubicaciones] FOREIGN KEY([IdPreguntaPATRetornoReubicacion])
REFERENCES [PAT].[PreguntaPATRetornosReubicaciones] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoRetornosReubicaciones] CHECK CONSTRAINT [FK_RespuestaPATDepartamentoRetornosReubicaciones_PreguntaPATRetornosReubicaciones]
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoRetornosReubicaciones]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATDepartamentoRetornosReubicaciones_Tablero] FOREIGN KEY([IdTablero])
REFERENCES [PAT].[Tablero] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATDepartamentoRetornosReubicaciones] CHECK CONSTRAINT [FK_RespuestaPATDepartamentoRetornosReubicaciones_Tablero]
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATDepartamentoRetornosReubicaciones_Entidad] ON [PAT].[RespuestaPATDepartamentoRetornosReubicaciones] ([IdEntidad])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATDepartamentoRetornosReubicaciones_EntidadMunicipio] ON [PAT].[RespuestaPATDepartamentoRetornosReubicaciones] ([IdEntidadMunicipio])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATDepartamentoRetornosReubicaciones_PreguntaPATRetornosReubicaciones] ON [PAT].[RespuestaPATDepartamentoRetornosReubicaciones] ([IdPreguntaPATRetornoReubicacion])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATDepartamentoRetornosReubicaciones_Tablero] ON [PAT].[RespuestaPATDepartamentoRetornosReubicaciones] ([IdTablero])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_PROGRAMA' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PAT_RESPUESTA_PROGRAMA].' + QUOTENAME(c.name) + ''',''PK_RespuestaPATPrograma'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_PROGRAMA' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PAT_RESPUESTA_PROGRAMA]', 'RespuestaPATPrograma'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATPrograma].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATPrograma].[ID_PAT_RESPUESTA]', 'IdRespuestaPAT', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATPrograma].[PROGRAMA]', 'Programa', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATPrograma].[ACTIVO]', 'Activo', 'COLUMN'
GO

ALTER TABLE [PAT].[RespuestaPATPrograma]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATPrograma_RespuestaPAT] FOREIGN KEY([IdRespuestaPAT])
REFERENCES [PAT].[RespuestaPAT] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATPrograma] CHECK CONSTRAINT [FK_RespuestaPATPrograma_RespuestaPAT]
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATPrograma_RespuestaPAT] ON [PAT].[RespuestaPATPrograma] ([IdRespuestaPAT])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_RC' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PAT_RESPUESTA_RC].' + QUOTENAME(c.name) + ''',''PK_RespuestaPATReparacionColectiva'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_RC' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PAT_RESPUESTA_RC]', 'RespuestaPATReparacionColectiva'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATReparacionColectiva].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATReparacionColectiva].[ID_TABLERO]', 'IdTablero', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATReparacionColectiva].[ID_ENTIDAD]', 'IdEntidad', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATReparacionColectiva].[ID_PREGUNTA_RC]', 'IdPreguntaPATReparacionColectiva', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATReparacionColectiva].[ACCION]', 'Accion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATReparacionColectiva].[PRESUPUESTO]', 'Presupuesto', 'COLUMN'
GO

ALTER TABLE [PAT].[RespuestaPATReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATReparacionColectiva_Entidad] FOREIGN KEY([IdEntidad])
REFERENCES [PAT].[Entidad] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATReparacionColectiva] CHECK CONSTRAINT [FK_RespuestaPATReparacionColectiva_Entidad]
GO

ALTER TABLE [PAT].[RespuestaPATReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATReparacionColectiva_PreguntaPATReparacionColectiva] FOREIGN KEY([IdPreguntaPATReparacionColectiva])
REFERENCES [PAT].[PreguntaPATReparacionColectiva] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATReparacionColectiva] CHECK CONSTRAINT [FK_RespuestaPATReparacionColectiva_PreguntaPATReparacionColectiva]
GO

ALTER TABLE [PAT].[RespuestaPATReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATReparacionColectiva_Tablero] FOREIGN KEY([IdTablero])
REFERENCES [PAT].[Tablero] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATReparacionColectiva] CHECK CONSTRAINT [FK_RespuestaPATReparacionColectiva_Tablero]
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATReparacionColectiva_Entidad] ON [PAT].[RespuestaPATReparacionColectiva] ([IdEntidad])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATReparacionColectiva_PreguntaPATReparacionColectiva] ON [PAT].[RespuestaPATReparacionColectiva] ([IdPreguntaPATReparacionColectiva])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATReparacionColectiva_Tablero] ON [PAT].[RespuestaPATReparacionColectiva] ([IdTablero])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_RC_ACCION' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PAT_RESPUESTA_RC_ACCION].' + QUOTENAME(c.name) + ''',''PK_RespuestaPATAccionReparacionColectiva'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_RC_ACCION' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PAT_RESPUESTA_RC_ACCION]', 'RespuestaPATAccionReparacionColectiva'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATAccionReparacionColectiva].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATAccionReparacionColectiva].[ID_PAT_RESPUESTA_RC]', 'IdRespuestaPATReparacionColectiva', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATAccionReparacionColectiva].[ACCION_RC]', 'AccionReparacionColectiva', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATAccionReparacionColectiva].[ACTIVO]', 'Activo', 'COLUMN'
GO

ALTER TABLE [PAT].[RespuestaPATAccionReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATAccionReparacionColectiva_RespuestaPATReparacionColectiva] FOREIGN KEY([IdRespuestaPATReparacionColectiva])
REFERENCES [PAT].[RespuestaPATReparacionColectiva] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATAccionReparacionColectiva] CHECK CONSTRAINT [FK_RespuestaPATAccionReparacionColectiva_RespuestaPATReparacionColectiva]
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATAccionReparacionColectiva_RespuestaPATReparacionColectiva] ON [PAT].[RespuestaPATAccionReparacionColectiva] ([IdRespuestaPATReparacionColectiva])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_RR' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PAT_RESPUESTA_RR].' + QUOTENAME(c.name) + ''',''PK_RespuestaPATRetornosReubicaciones'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_RR' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PAT_RESPUESTA_RR]', 'RespuestaPATRetornosReubicaciones'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATRetornosReubicaciones].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATRetornosReubicaciones].[ID_TABLERO]', 'IdTablero', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATRetornosReubicaciones].[ID_ENTIDAD]', 'IdEntidad', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATRetornosReubicaciones].[ID_PREGUNTA_RR]', 'IdPreguntaPATRetornoReubicacion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATRetornosReubicaciones].[ACCION]', 'Accion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATRetornosReubicaciones].[PRESUPUESTO]', 'Presupuesto', 'COLUMN'
GO

ALTER TABLE [PAT].[RespuestaPATRetornosReubicaciones]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATRetornosReubicaciones_Entidad] FOREIGN KEY([IdEntidad])
REFERENCES [PAT].[Entidad] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATRetornosReubicaciones] CHECK CONSTRAINT [FK_RespuestaPATRetornosReubicaciones_Entidad]
GO

ALTER TABLE [PAT].[RespuestaPATRetornosReubicaciones]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATRetornosReubicaciones_PreguntaPATRetornosReubicaciones] FOREIGN KEY([IdPreguntaPATRetornoReubicacion])
REFERENCES [PAT].[PreguntaPATRetornosReubicaciones] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATRetornosReubicaciones] CHECK CONSTRAINT [FK_RespuestaPATRetornosReubicaciones_PreguntaPATRetornosReubicaciones]
GO

ALTER TABLE [PAT].[RespuestaPATRetornosReubicaciones]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATRetornosReubicaciones_Tablero] FOREIGN KEY([IdTablero])
REFERENCES [PAT].[Tablero] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATRetornosReubicaciones] CHECK CONSTRAINT [FK_RespuestaPATRetornosReubicaciones_Tablero]
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATRetornosReubicaciones_Entidad] ON [PAT].[RespuestaPATRetornosReubicaciones] ([IdEntidad])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATRetornosReubicaciones_PreguntaPATRetornosReubicaciones] ON [PAT].[RespuestaPATRetornosReubicaciones] ([IdPreguntaPATRetornoReubicacion])
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATRetornosReubicaciones_Tablero] ON [PAT].[RespuestaPATRetornosReubicaciones] ([IdTablero])
GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'ALTER TABLE ' + QUOTENAME(s.name) + N'.'  + QUOTENAME(t.name) + N' DROP CONSTRAINT ' + QUOTENAME(c.name) + ';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_RR_ACCION' 
	AND s.name = 'PAT'
	and c.[type] IN ('D','C','F','UQ')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

DECLARE @sql NVARCHAR(MAX);
SET @sql = N'';

SELECT 
	@sql = @sql + N'EXEC SP_RENAME ''[PAT].[TB_PAT_RESPUESTA_RR_ACCION].' + QUOTENAME(c.name) + ''',''PK_RespuestaPATAccionRetornosReubicaciones'';'
FROM 
	sys.objects AS c
	INNER JOIN sys.tables AS t ON c.parent_object_id = t.[object_id]
	INNER JOIN sys.schemas AS s ON t.[schema_id] = s.[schema_id]
WHERE
	t.name = 'TB_PAT_RESPUESTA_RR_ACCION' 
	AND s.name = 'PAT'
	and c.[type] IN ('PK')
ORDER BY 
	c.[type];

EXEC SP_EXECUTESQL @sql

GO

EXEC sp_RENAME '[PAT].[TB_PAT_RESPUESTA_RR_ACCION]', 'RespuestaPATAccionRetornosReubicaciones'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATAccionRetornosReubicaciones].[ID]', 'Id', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATAccionRetornosReubicaciones].[ID_PAT_RESPUESTA_RR]', 'IdRespuestaPATRetornoReubicacion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATAccionRetornosReubicaciones].[ACCION_RR]', 'AccionRetornoReubicacion', 'COLUMN'
GO

EXEC sp_RENAME '[PAT].[RespuestaPATAccionRetornosReubicaciones].[ACTIVO]', 'Activo', 'COLUMN'
GO

ALTER TABLE [PAT].[RespuestaPATAccionRetornosReubicaciones]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATAccionRetornosReubicaciones_RespuestaPATRetornosReubicaciones] FOREIGN KEY([IdRespuestaPATRetornoReubicacion])
REFERENCES [PAT].[RespuestaPATRetornosReubicaciones] ([Id])
GO

ALTER TABLE [PAT].[RespuestaPATAccionRetornosReubicaciones] CHECK CONSTRAINT [FK_RespuestaPATAccionRetornosReubicaciones_RespuestaPATRetornosReubicaciones]
GO

CREATE NONCLUSTERED INDEX [IDX_RespuestaPATAccionRetornosReubicaciones_RespuestaPATRetornosReubicaciones] ON [PAT].[RespuestaPATAccionRetornosReubicaciones] ([IdRespuestaPATRetornoReubicacion])
GO

DROP TABLE [PAT].[TB_DANE]
GO

DROP TABLE [PAT].[TB_USUARIO]
GO



