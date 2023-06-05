
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Municipio SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RespuestaPATDepartamento' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'IdMunicipioRespuesta')
ALTER TABLE PAT.RespuestaPATDepartamento ADD IdMunicipioRespuesta int NULL
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RespuestaPATDepartamento' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'IdMunicipioInsercion')
ALTER TABLE PAT.RespuestaPATDepartamento ADD IdMunicipioInsercion int NULL
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = 'PAT' AND CONSTRAINT_NAME ='FK_RespuestaPATDepartamento_Municipio')
ALTER TABLE PAT.RespuestaPATDepartamento ADD CONSTRAINT FK_RespuestaPATDepartamento_Municipio FOREIGN KEY (IdMunicipioRespuesta) REFERENCES dbo.Municipio (Id) ON UPDATE  NO ACTION ON DELETE  NO ACTION 	
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = 'PAT' AND CONSTRAINT_NAME ='FK_RespuestaPATDepartamento_MunicipioInsercion')
ALTER TABLE PAT.RespuestaPATDepartamento ADD CONSTRAINT FK_RespuestaPATDepartamento_MunicipioInsercion FOREIGN KEY (IdMunicipioInsercion) REFERENCES dbo.Municipio (Id) ON UPDATE NO ACTION ON DELETE NO ACTION 	
GO

ALTER TABLE PAT.RespuestaPATDepartamento SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

go
--------------------------

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE PAT.RespuestaPATDepartamento
	DROP CONSTRAINT FK_RespuestaPATDepartamento_MunicipioInsercion
GO
ALTER TABLE dbo.Municipio SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RespuestaPATDepartamento' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'IdUsuario')
ALTER TABLE PAT.RespuestaPATDepartamento ADD IdUsuario int NULL
GO

ALTER TABLE PAT.RespuestaPATDepartamento
	DROP COLUMN IdMunicipioInsercion
GO
ALTER TABLE PAT.RespuestaPATDepartamento SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

go

UPDATE [PAT].[RespuestaPATDepartamento]  SET [IdMunicipioRespuesta] =E.IdMunicipio 
FROM [PAT].[RespuestaPATDepartamento] as D
JOIN  PAT.Entidad AS E ON D.IdEntidadMunicipio = E.Id 

UPDATE [PAT].[RespuestaPATDepartamento]  SET [IdUsuario] =u.Id
FROM [PAT].[RespuestaPATDepartamento] as D
JOIN  PAT.Entidad AS E ON D.IdEntidadMunicipio = E.Id 
join Municipio as m on E.IdMunicipio = m.Id
join Usuario as u on m.IdDepartamento = u.IdDepartamento and u.IdEstado in ( 3,5) and u.IdTipoUsuario = 8 AND u.Activo = 1


/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RespuestaPATDepartamento' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'FechaInsercion')
ALTER TABLE PAT.RespuestaPATDepartamento ADD FechaInsercion date NULL

GO
ALTER TABLE PAT.RespuestaPATDepartamento SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


GO

------

ALTER TABLE [PAT].[RespuestaPATDepartamento] ALTER COLUMN IdEntidad INT NULL
GO
ALTER TABLE [PAT].[RespuestaPATDepartamento] ALTER COLUMN IdEntidadMunicipio INT NULL
GO
------------------------------------
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Municipio SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RespuestaPATDepartamentoReparacionColectiva' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'IdMunicipioRespuesta')
ALTER TABLE PAT.RespuestaPATDepartamentoReparacionColectiva ADD IdMunicipioRespuesta int NULL
GO	
	
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RespuestaPATDepartamentoReparacionColectiva' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'IdUsuario')
ALTER TABLE PAT.RespuestaPATDepartamentoReparacionColectiva ADD IdUsuario int NULL
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RespuestaPATDepartamentoReparacionColectiva' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'FechaInsercion')
ALTER TABLE PAT.RespuestaPATDepartamentoReparacionColectiva ADD FechaInsercion DATE NULL
GO


IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = 'PAT' AND CONSTRAINT_NAME ='FK_RespuestaPATDepartamentoReparacionColectiva_Municipio')
ALTER TABLE PAT.RespuestaPATDepartamentoReparacionColectiva ADD CONSTRAINT FK_RespuestaPATDepartamentoReparacionColectiva_Municipio FOREIGN KEY (IdMunicipioRespuesta) REFERENCES dbo.Municipio (Id) ON UPDATE NO ACTION ON DELETE NO ACTION 	
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = 'PAT' AND CONSTRAINT_NAME ='FK_RespuestaPATDepartamentoReparacionColectiva_RespuestaPATDepartamentoReparacionColectiva')
ALTER TABLE PAT.RespuestaPATDepartamentoReparacionColectiva ADD CONSTRAINT FK_RespuestaPATDepartamentoReparacionColectiva_RespuestaPATDepartamentoReparacionColectiva FOREIGN KEY (Id) REFERENCES PAT.RespuestaPATDepartamentoReparacionColectiva (Id) ON UPDATE  NO ACTION ON DELETE  NO ACTION 
GO

UPDATE [PAT].[RespuestaPATDepartamentoReparacionColectiva]  SET [IdUsuario] =u.Id
FROM [PAT].[RespuestaPATDepartamentoReparacionColectiva] as D
JOIN  PAT.Entidad AS E ON D.IdEntidadMunicipio = E.Id 
join Municipio as m on E.IdMunicipio = m.Id
join Usuario as u on m.IdDepartamento = u.IdDepartamento and u.IdEstado in ( 3,5) and u.IdTipoUsuario = 8 AND u.Activo = 1

go

----------------------------------

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Municipio SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RespuestaPATDepartamentoRetornosReubicaciones' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'IdMunicipioRespuesta')
ALTER TABLE PAT.RespuestaPATDepartamentoRetornosReubicaciones ADD IdMunicipioRespuesta int NULL
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RespuestaPATDepartamentoRetornosReubicaciones' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'IdUsuario')
ALTER TABLE PAT.RespuestaPATDepartamentoRetornosReubicaciones ADD IdUsuario int NULL
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RespuestaPATDepartamentoRetornosReubicaciones' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'FechaInsercion')
ALTER TABLE PAT.RespuestaPATDepartamentoRetornosReubicaciones ADD FechaInsercion date NULL
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS WHERE CONSTRAINT_SCHEMA = 'PAT' AND CONSTRAINT_NAME ='FK_RespuestaPATDepartamentoRetornosReubicaciones_Municipio')
ALTER TABLE PAT.RespuestaPATDepartamentoRetornosReubicaciones ADD CONSTRAINT FK_RespuestaPATDepartamentoRetornosReubicaciones_Municipio FOREIGN KEY (IdMunicipioRespuesta) REFERENCES dbo.Municipio (Id) ON UPDATE  NO ACTION ON DELETE  NO ACTION 	
GO

ALTER TABLE PAT.RespuestaPATDepartamentoRetornosReubicaciones SET (LOCK_ESCALATION = TABLE)
GO

COMMIT

go

update pat.RespuestaPATReparacionColectiva  set IdMunicipio = p.IdMunicipio
from pat.PreguntaPATReparacionColectiva as p
join  pat.RespuestaPATReparacionColectiva as r on p.Id = r.IdPreguntaPATReparacionColectiva where r.IdMunicipio is null
go
update pat.RespuestaPATRetornosReubicaciones  set IdMunicipio = p.IdMunicipio
from pat.PreguntaPATRetornosReubicaciones as p
join  pat.RespuestaPATRetornosReubicaciones as r on p.Id = r.IdPreguntaPATRetornoReubicacion where r.IdMunicipio is null
go
ALTER TABLE PAT.RespuestaPATDepartamentoRetornosReubicaciones alter column [IdEntidad]int NULL
go
ALTER TABLE PAT.RespuestaPATDepartamentoRetornosReubicaciones alter column [IdEntidadMunicipio] int NULL

go

/****** Object:  StoredProcedure [PAT].[U_RespuestaUpdate]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='U_RespuestaUpdate')
DROP PROCEDURE [PAT].[U_RespuestaUpdate]
GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaRRUpdate]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='U_RespuestaRRUpdate')
DROP PROCEDURE [PAT].[U_RespuestaRRUpdate]
GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaRCUpdate]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='U_RespuestaRCUpdate')
DROP PROCEDURE [PAT].[U_RespuestaRCUpdate]
GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaProgramaUpdate]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='U_RespuestaProgramaUpdate')
DROP PROCEDURE [PAT].[U_RespuestaProgramaUpdate]
GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaDepartamentoUpdate]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='U_RespuestaDepartamentoUpdate')
DROP PROCEDURE [PAT].[U_RespuestaDepartamentoUpdate]
GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaDepartamentoRRUpdate]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='U_RespuestaDepartamentoRRUpdate')
DROP PROCEDURE [PAT].[U_RespuestaDepartamentoRRUpdate]
GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaDepartamentoRCUpdate]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='U_RespuestaDepartamentoRCUpdate')
DROP PROCEDURE [PAT].[U_RespuestaDepartamentoRCUpdate]
GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaAccionesUpdate]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='U_RespuestaAccionesUpdate')
DROP PROCEDURE [PAT].[U_RespuestaAccionesUpdate]
GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaAccionesRRUpdate]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='U_RespuestaAccionesRRUpdate')
DROP PROCEDURE [PAT].[U_RespuestaAccionesRRUpdate]
GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaAccionesRCUpdate]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='U_RespuestaAccionesRCUpdate')
DROP PROCEDURE [PAT].[U_RespuestaAccionesRCUpdate]
GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaRRInsert]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='I_RespuestaRRInsert')
DROP PROCEDURE [PAT].[I_RespuestaRRInsert]
GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaRCInsert]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='I_RespuestaRCInsert')
DROP PROCEDURE [PAT].[I_RespuestaRCInsert]
GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaProgramaInsert]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='I_RespuestaProgramaInsert')
DROP PROCEDURE [PAT].[I_RespuestaProgramaInsert]
GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaInsert]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='I_RespuestaInsert')
DROP PROCEDURE [PAT].[I_RespuestaInsert]
GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaDepartamentoRRInsert]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='I_RespuestaDepartamentoRRInsert')
DROP PROCEDURE [PAT].[I_RespuestaDepartamentoRRInsert]
GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaDepartamentoRCInsert]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='I_RespuestaDepartamentoRCInsert')
DROP PROCEDURE [PAT].[I_RespuestaDepartamentoRCInsert]
GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaDepartamentoInsert]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='I_RespuestaDepartamentoInsert')
DROP PROCEDURE [PAT].[I_RespuestaDepartamentoInsert]
GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaAccionesRRInsert]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='I_RespuestaAccionesRRInsert')
DROP PROCEDURE [PAT].[I_RespuestaAccionesRRInsert]
GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaAccionesRCInsert]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='I_RespuestaAccionesRCInsert')
DROP PROCEDURE [PAT].[I_RespuestaAccionesRCInsert]
GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaAccionesInsert]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='I_RespuestaAccionesInsert')
DROP PROCEDURE [PAT].[I_RespuestaAccionesInsert]
GO
/****** Object:  StoredProcedure [PAT].[C_TodosTablerosMunicipiosPorCompletar]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TodosTablerosMunicipiosPorCompletar')
DROP PROCEDURE [PAT].[C_TodosTablerosMunicipiosPorCompletar]
GO
/****** Object:  StoredProcedure [PAT].[C_TodosTablerosMunicipiosCompletos]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TodosTablerosMunicipiosCompletos')
DROP PROCEDURE [PAT].[C_TodosTablerosMunicipiosCompletos]
GO
/****** Object:  StoredProcedure [PAT].[C_TodosTablerosDepartamentosPorCompletar]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TodosTablerosDepartamentosPorCompletar')
DROP PROCEDURE [PAT].[C_TodosTablerosDepartamentosPorCompletar]
GO
/****** Object:  StoredProcedure [PAT].[C_TodosTablerosDepartamentosCompletos]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TodosTablerosDepartamentosCompletos')
DROP PROCEDURE [PAT].[C_TodosTablerosDepartamentosCompletos]
GO
/****** Object:  StoredProcedure [PAT].[C_TableroVigencia]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TableroVigencia')
DROP PROCEDURE [PAT].[C_TableroVigencia]
GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioTotales]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TableroMunicipioTotales')
DROP PROCEDURE [PAT].[C_TableroMunicipioTotales]
GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioRR]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TableroMunicipioRR')
DROP PROCEDURE [PAT].[C_TableroMunicipioRR]
GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioRC]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TableroMunicipioRC')
DROP PROCEDURE [PAT].[C_TableroMunicipioRC]
GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioAvance]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TableroMunicipioAvance')
DROP PROCEDURE [PAT].[C_TableroMunicipioAvance]
GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipio]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TableroMunicipio')
DROP PROCEDURE [PAT].[C_TableroMunicipio]
GO
/****** Object:  StoredProcedure [PAT].[C_TableroFechaActivo]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TableroFechaActivo')
DROP PROCEDURE [PAT].[C_TableroFechaActivo]
GO
/****** Object:  StoredProcedure [PAT].[C_TableroDepartamentoRetornosReubicaciones]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TableroDepartamentoRetornosReubicaciones')
DROP PROCEDURE [PAT].[C_TableroDepartamentoRetornosReubicaciones]
GO
/****** Object:  StoredProcedure [PAT].[C_TableroDepartamentoReparacionColectiva]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TableroDepartamentoReparacionColectiva')
DROP PROCEDURE [PAT].[C_TableroDepartamentoReparacionColectiva]
GO
/****** Object:  StoredProcedure [PAT].[C_TableroDepartamentoAvance]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TableroDepartamentoAvance')
DROP PROCEDURE [PAT].[C_TableroDepartamentoAvance]
GO
/****** Object:  StoredProcedure [PAT].[C_TableroDepartamento]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_TableroDepartamento')
DROP PROCEDURE [PAT].[C_TableroDepartamento]
GO
/****** Object:  StoredProcedure [PAT].[C_ProgramasPAT]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_ProgramasPAT')
DROP PROCEDURE [PAT].[C_ProgramasPAT]
GO
/****** Object:  StoredProcedure [PAT].[C_NecesidadesIdentificadas]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_NecesidadesIdentificadas')
DROP PROCEDURE [PAT].[C_NecesidadesIdentificadas]
GO
/****** Object:  StoredProcedure [PAT].[C_MunicipiosRetornosReubicaciones]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_MunicipiosRetornosReubicaciones')
DROP PROCEDURE [PAT].[C_MunicipiosRetornosReubicaciones]
GO
/****** Object:  StoredProcedure [PAT].[C_MunicipiosReparacionColectiva]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_MunicipiosReparacionColectiva')
DROP PROCEDURE [PAT].[C_MunicipiosReparacionColectiva]
GO
/****** Object:  StoredProcedure [PAT].[C_Derechos]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_Derechos')
DROP PROCEDURE [PAT].[C_Derechos]
GO
/****** Object:  StoredProcedure [PAT].[C_DatosExcel_Municipios]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_DatosExcel_Municipios')
DROP PROCEDURE [PAT].[C_DatosExcel_Municipios]
GO
/****** Object:  StoredProcedure [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_DatosExcel_GobernacionesRetornosReubicaciones')
DROP PROCEDURE [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones]
GO
/****** Object:  StoredProcedure [PAT].[C_DatosExcel_GobernacionesReparacionColectiva]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_DatosExcel_GobernacionesReparacionColectiva')
DROP PROCEDURE [PAT].[C_DatosExcel_GobernacionesReparacionColectiva]
GO
/****** Object:  StoredProcedure [PAT].[C_DatosExcel_Gobernaciones_municipios]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_DatosExcel_Gobernaciones_municipios')
DROP PROCEDURE [PAT].[C_DatosExcel_Gobernaciones_municipios]
GO
/****** Object:  StoredProcedure [PAT].[C_DatosExcel_Gobernaciones]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_DatosExcel_Gobernaciones')
DROP PROCEDURE [PAT].[C_DatosExcel_Gobernaciones]
GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroMunicipioTotales]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_ContarTableroMunicipioTotales')
DROP PROCEDURE [PAT].[C_ContarTableroMunicipioTotales]
GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroMunicipioRR]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_ContarTableroMunicipioRR')
DROP PROCEDURE [PAT].[C_ContarTableroMunicipioRR]
GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroMunicipioRC]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_ContarTableroMunicipioRC')
DROP PROCEDURE [PAT].[C_ContarTableroMunicipioRC]
GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroMunicipio]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_ContarTableroMunicipio')
DROP PROCEDURE [PAT].[C_ContarTableroMunicipio]
GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroDepartamentoRetornosReubicaciones]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_ContarTableroDepartamentoRetornosReubicaciones')
DROP PROCEDURE [PAT].[C_ContarTableroDepartamentoRetornosReubicaciones]
GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroDepartamentoReparacionColectiva]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_ContarTableroDepartamentoReparacionColectiva')
DROP PROCEDURE [PAT].[C_ContarTableroDepartamentoReparacionColectiva]
GO
/****** Object:  StoredProcedure [PAT].[C_ConsolidadosMunicipio]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_ConsolidadosMunicipio')
DROP PROCEDURE [PAT].[C_ConsolidadosMunicipio]
GO
/****** Object:  StoredProcedure [PAT].[C_AccionesPAT]    Script Date: 28/07/2017 17:56:19 ******/
if exists (select object_id from sys.all_objects where name ='C_AccionesPAT')
DROP PROCEDURE [PAT].[C_AccionesPAT]
GO
-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las acciones compromisos de la gestión municipal del PAT en Responsbilidad Colectiva
-- =============================================
CREATE PROCEDURE [PAT].[C_AccionesPAT]--,'RC'--1,'RR'--1,''
( 
	@ID as INT	, @OPCION VARCHAR(2)
)
AS
BEGIN
	SET NOCOUNT ON;	

	IF @OPCION = '' OR @OPCION IS NULL
	BEGIN	
	SELECT	A.ACCION ,A.ID
		FROM	[PAT].[RespuestaPAT] (NOLOCK) AS R
		JOIN	[PAT].[RespuestaPATAccion] (NOLOCK) AS A ON R.ID = A.[IdRespuestaPAT]
		WHERE	A.ACTIVO = 1 AND R.ID = @ID
	END
	IF @OPCION = 'RC' 
	BEGIN		
		SELECT	A.[AccionReparacionColectiva] AS ACCION ,A.ID
		FROM	[PAT].[RespuestaPATReparacionColectiva] (NOLOCK) AS R
		JOIN	[PAT].[RespuestaPATAccionReparacionColectiva] (NOLOCK) AS A ON R.ID = A.[IdRespuestaPATReparacionColectiva]
		WHERE	A.ACTIVO = 1 AND R.ID = @ID
	END
	IF @OPCION = 'RR' 
	BEGIN	
		SELECT	A.[AccionRetornoReubicacion] AS ACCION ,A.ID
		FROM	[PAT].[RespuestaPATRetornosReubicaciones] (NOLOCK) AS R
		JOIN	[PAT].[RespuestaPATAccionRetornosReubicaciones] (NOLOCK) AS A ON R.ID = A.[IdRespuestaPATRetornoReubicacion]
		WHERE	A.ACTIVO = 1 AND R.ID = @ID
	END

END



GO
/****** Object:  StoredProcedure [PAT].[C_ConsolidadosMunicipio]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	21/07/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados 
-- ==========================================================================================
CREATE PROCEDURE [PAT].[C_ConsolidadosMunicipio]   ( @IdUsuario INT, @idPregunta INT, @idTablero tinyint)--1513,7,1
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE  @IDENTIDAD INT, @NOMBREMUNICIPIO VARCHAR(100), @IdDepartamento int
	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
	SELECT @NOMBREMUNICIPIO = Nombre FROM Municipio WHERE Id = 	@IDENTIDAD	
	select @IdDepartamento = IdDepartamento from Municipio where Id =@IDENTIDAD 			
	print @IdDepartamento

	select distinct D.Descripcion AS DERECHO, 	
	C.Descripcion AS COMPONENTE,
	M.Descripcion AS MEDIDA,
	P.Id AS ID_PREGUNTA,
	P.PreguntaIndicativa,
	Mun.Id as ID_MUNICIPIO_RESPUESTA,
	Mun.Nombre as ENTIDAD,
	R.RespuestaIndicativa AS INDICATIVA_MUNICIPIO,
	R.RespuestaCompromiso AS COMPROMISO_MUNICIPIO,
	R.Presupuesto AS PRESUPUESTO_MUNICIPIO,
	P.IdTablero AS ID_TABLERO,
	RESPUESTA.Id,
	RESPUESTA.RespuestaCompromiso, 
	RESPUESTA.Presupuesto,
	RESPUESTA.ObservacionCompromiso 
	FROM [PAT].[RespuestaPAT] R
	INNER JOIN [PAT].[PreguntaPAT] AS P ON R.IdPreguntaPAT = P.Id AND P.Nivel = 3
	join Municipio as Mun on R.IdMunicipio = Mun.Id
	LEFT OUTER JOIN [PAT].[RespuestaPATDepartamento] AS RESPUESTA ON P.Id = RESPUESTA.IdPreguntaPAT and R.IdMunicipio = RESPUESTA.IdMunicipioRespuesta,	
	[PAT].[Derecho] D,
	[PAT].[Componente] C,
	[PAT].[Medida] M,
	[PAT].[Tablero] T
	WHERE P.IDDERECHO = D.ID 
	AND P.IDCOMPONENTE = C.ID 
	AND P.IDMEDIDA = M.ID 
	AND P.IDTABLERO = T.ID
	AND T.ID = @idTablero 
	AND P.ACTIVO = 1 
	AND P.Id = @idPregunta
	and Mun.IdDepartamento = @IdDepartamento	
	order by 8

END


GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroDepartamentoReparacionColectiva]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Obtiene el numero de preguntas del tablero para la gestión departamental de reparación colectiva
-- =============================================
create PROCEDURE [PAT].[C_ContarTableroDepartamentoReparacionColectiva] --[PAT].[C_ContarTableroDepartamentoReparacionColectiva] 11001,1
	( @IdMunicipio INT, @idTablero tinyint)	
AS
BEGIN
	SET NOCOUNT ON;

	declare @cantidad int
	set @cantidad = 0
	
	SELECT @cantidad = COUNT(1)
	FROM ( 
		SELECT DISTINCT row_number() OVER (ORDER BY p.SUJETO) AS LINEA, 
		MEDIDA.Descripcion as Medida,
		p.Sujeto,
		p.MedidaReparacionColectiva,
		rcd.Id,
		p.IdTablero,
		rcd.IdMunicipioRespuesta,
		d.IdDepartamento, 
		p.Id as IdPreguntaReparacionColectiva,
		rc.Accion,
		rc.Presupuesto,
		rcd.AccionDepartamento,  
		rcd.PresupuestoDepartamento
		FROM PAT.PreguntaPATReparacionColectiva p
		INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
		INNER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id		
		INNER join Municipio as d on p.IdMunicipio =d.Id and d.Id =@IdMunicipio
		LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc on p.Id = rc.IdPreguntaPATReparacionColectiva and rc.IdMunicipio= d.Id
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON rcd.IdMunicipioRespuesta= d.Id and rcd.IdPreguntaPATReparacionColectiva=p.Id
		where TABLERO.Id = @idTablero
	) as a
								
	SELECT @cantidad	
END



GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroDepartamentoRetornosReubicaciones]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Obtiene el conteo tablero para la gestión departamental de retornos y reubicaciones
-- =============================================
create PROCEDURE [PAT].[C_ContarTableroDepartamentoRetornosReubicaciones] --[PAT].[C_ContarTableroDepartamentoRetornosReubicaciones] 11001,2
	( @IdMunicipio INT, @idTablero tinyint)	
AS
BEGIN
	SET NOCOUNT ON;
	declare @Cantidad int
	set @Cantidad = 0

	SELECT @Cantidad= COUNT (1)
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
	,R.Accion as AccionDepartamento
	,R.Presupuesto as PresupuestoDepartamento
	,R.Id as IdRespuestaDepartamento
	,P.EntidadResponsable
	FROM pat.PreguntaPATRetornosReubicaciones AS P
	JOIN PAT.Tablero AS T ON P.IdTablero =T.Id
	LEFT OUTER JOIN PAT.RespuestaPATRetornosReubicaciones AS R  ON P.Id = R.IdPreguntaPATRetornoReubicacion AND R.IdMunicipio = P.IdMunicipio
	LEFT OUTER JOIN PAT.RespuestaPATDepartamentoRetornosReubicaciones AS RD ON R.IdMunicipio = RD.IdMunicipioRespuesta
	where T.Id = @idTablero 
	AND P.IdMunicipio =@IdMunicipio
	) AS P 
	SELECT @Cantidad
	
END





GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroMunicipio]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		22/08/2016
-- Modified date:	
-- Description:		Cuenta todas las preguntas del Tablero para paginacion
-- =============================================
-- =============================================
-- Author:			Iván Capera
-- Modified date:	08-07-2017
-- Description:		Ajuste de consulta para contemplar mejoras para SQL Server 2016.
-- =============================================
CREATE PROCEDURE [PAT].[C_ContarTableroMunicipio] --506, 'Salud',2
(@IdUsuario INT, @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @Cantidad INT, @ID_ENTIDAD INT

	SELECT @ID_ENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)

	SELECT @Cantidad = COUNT(1)
	FROM ( 
		     SELECT DISTINCT  
						P.ID AS ID_PREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDAD_MEDIDA,	
						T.ID AS ID_TABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @ID_ENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID ,
						R.RESPUESTAINDICATIVA, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO
		FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdMunicipio =  @ID_ENTIDAD ,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T
		WHERE 
			P.IDDERECHO = D.ID 
			AND P.IDCOMPONENTE = C.ID 
			AND P.IDMEDIDA = M.ID 
			AND P.IDUNIDADMEDIDA = UM.ID 
			AND P.IDTABLERO = T.ID
			AND T.ID = @idTablero 
			AND P.NIVEL = 3 
			AND P.ACTIVO = 1 
			--AND 1=PAT.ValidarPreguntaRyR(P.IDMEDIDA,@ID_ENTIDAD) 
			AND D.Id = @IdDerecho) as P 
	
	SELECT @Cantidad
END


GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroMunicipioRC]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		22/08/2016
-- Modified date:	
-- Description:		Cuenta todas las preguntas del Tablero para paginacion de reparación colectiva
-- =============================================
CREATE PROCEDURE [PAT].[C_ContarTableroMunicipioRC] --46, ''
(@IdUsuario INT, @idTablero tinyint)

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Cantidad INT, @IDENTIDAD INT, @ID_DANE INT
	
	SELECT @IDENTIDAD =[PAT].[fn_GetIdEntidad](@IdUsuario)
	SELECT @Cantidad = COUNT(1)
			FROM ( 		
				SELECT DISTINCT 
					P.ID AS IDPREGUNTA, 
					P.[IdMunicipio] AS IDDANE, 
					P.IDMEDIDA, 
					P.SUJETO, 
					P.[MedidaReparacionColectiva] AS MEDIDARC, 
					M.DESCRIPCION AS MEDIDA, 
					T.ID AS IDTABLERO,
					CASE WHEN R.IdMunicipio IS NULL THEN @IDENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
					R.ID,
					R.ACCION, 
					R.PRESUPUESTO
				FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
					LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] AS R ON P.ID= R.[IdPreguntaPATReparacionColectiva] AND R.[IdMunicipio] = @IDENTIDAD,
					[PAT].[Medida] M,
					[PAT].[Tablero] T
				WHERE	P.IDMEDIDA = M.ID 
					AND P.[IdMunicipio] = @IDENTIDAD
					AND P.IDTABLERO = T.ID
					AND T.ID = @idTablero
				AND P.Id > 2242
			) as a
	SELECT @Cantidad
END


GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroMunicipioRR]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		22/08/2016
-- Modified date:	
-- Description:		Cuenta todas las preguntas del Tablero para paginacion de reparación colectiva
-- =============================================
CREATE PROCEDURE [PAT].[C_ContarTableroMunicipioRR] --506, '', 2
(@IdUsuario INT, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Cantidad INT, @ID_ENTIDAD INT--, @ID_DANE INT

	SELECT @ID_ENTIDAD = pat.fn_GetIdEntidad(@IdUsuario)--, @ID_DANE = PAT.fn_GetDaneMunicipioEntidad(@IdUsuario)

	SELECT @Cantidad = COUNT(1)
	FROM (
	SELECT  
	P.ID AS ID_PREGUNTA
	,P.[IdMunicipio] AS IDDANE
	,P.[HOGARES]
	,P.[PERSONAS]
	,P.[SECTOR]
	,P.[COMPONENTE]
	,P.[COMUNIDAD]
	,P.[UBICACION]
	,P.[MedidaRetornoReubicacion] AS MEDIDARR
	,P.[IndicadorRetornoReubicacion] AS INDICADORRR
	,P.[ENTIDADRESPONSABLE] 
	,T.ID AS ID_TABLERO
	,CASE WHEN R.IdMunicipio IS NULL THEN @ID_ENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
	R.ID,
	R.ACCION, 
	R.PRESUPUESTO
	FROM    [PAT].[PreguntaPATRetornosReubicaciones] P
	INNER JOIN [PAT].[Tablero] T ON P.[IdTablero] = T.ID
	LEFT OUTER JOIN [PAT].[RespuestaPATRetornosReubicaciones] R ON R.IdMunicipio = @ID_ENTIDAD and p.ID = R.[IdPreguntaPATRetornoReubicacion]
	WHERE  T.ID = @idTablero 
	and P.[IdMunicipio] = @ID_ENTIDAD
	) as A
			
	SELECT @Cantidad
END





GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroMunicipioTotales]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados 
-- ==========================================================================================
create PROCEDURE [PAT].[C_ContarTableroMunicipioTotales] 
 (@IdUsuario INT,  @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Cantidad INT, @ID_ENTIDAD INT

	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE  @IDENTIDAD INT

	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)

	SELECT DISTINCT @Cantidad = COUNT(1)
				FROM ( 
				 SELECT DISTINCT 
						P.ID AS IDPREGUNTA, 
						P.PREGUNTAINDICATIVA, 
						P.PREGUNTACOMPROMISO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IDENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
						(SELECT SUM(R1.RespuestaIndicativa) 
							FROM  [PAT].[RespuestaPAT] R1	
							--INNER JOIN PAT.TB_ENTIDAD E1 ON R1.ID_ENTIDAD = E1.ID						
							WHERE R1.[IdPreguntaPAT]=P.Id 
							--AND E1.ID_DEPARTAMENTO = (SELECT ID_DEPARTAMENTO FROM PAT.TB_ENTIDAD WHERE ID = PAT.fn_GetIdEntidad(@USUARIO))
						) TOTALNECESIDADES,
						(SELECT SUM(R1.RESPUESTACOMPROMISO) 
							FROM  [PAT].[RespuestaPAT] R1
							--INNER JOIN PAT.TB_ENTIDAD E1 ON R1.ID_ENTIDAD = E1.ID
							WHERE R1.IdPreguntaPAT=P.Id
							--AND E1.ID_DEPARTAMENTO = (SELECT ID_DEPARTAMENTO FROM PAT.TB_ENTIDAD WHERE ID = PAT.fn_GetIdEntidad(@USUARIO))
						) TOTALCOMPROMISOS,
						R.ID
				FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdMunicipio =  @IDENTIDAD ,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 					
					AND D.ID = @IdDerecho
	 ) AS P 
		
		SELECT @Cantidad
END











GO
/****** Object:  StoredProcedure [PAT].[C_DatosExcel_Gobernaciones]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		21/07/2017
-- Modified date:	21/07/2017
-- Description:		Obtiene toda la informacion del municipio y tablero indicando en cuento a las respuestas que estos diligenciaron
-- ==========================================================================================

CREATE PROC [PAT].[C_DatosExcel_Gobernaciones] -- [PAT].[SP_GetDatosExcel_Gob] --506 --[PAT].[C_DatosExcel_Gobernaciones] 11001,1
(
	@IdMunicipio INT, @IdTablero INT
)
AS
BEGIN

SELECT 
DISTINCT  
IDPREGUNTA AS ID
, '' AS ENTIDAD
,DERECHO
,COMPONENTE
,MEDIDA
,PREGUNTAINDICATIVA
,PREGUNTACOMPROMISO
,UNIDADMEDIDA
,RESPUESTAINDICATIVA
,OBSERVACIONNECESIDAD
,RESPUESTACOMPROMISO
,ACCIONCOMPROMISO AS OBSERVACIONCOMPROMISO
,CONVERT(FLOAT, PRESUPUESTO) AS PRESUPUESTO
,ACCION
,PROGRAMA

	FROM ( 
    SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						R.ID AS IDTABLERO,						
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID as id_respuesta,
						R.RESPUESTAINDICATIVA, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO
						,AA.ACCION
						,AP.PROGRAMA
				FROM    [PAT].[PreguntaPAT] AS P
				INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
				INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
				INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
				INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
				INNER JOIN PAT.Tablero AS T ON P.IDTABLERO = T.ID
				LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] and  R.IdMunicipio = @IdMunicipio 									
				LEFT OUTER JOIN [PAT].[RespuestaPATAccion] AS AA ON AA.[IdRespuestaPAT] = R.ID and AA.Activo = 1
				LEFT OUTER JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
				INNER JOIN Usuario AS U ON R.IdUsuario = U.Id  AND U.IdMunicipio = @IdMunicipio
				WHERE  T.ID = @IdTablero and
				P.NIVEL = 2 AND 1=pat.ValidarPreguntaRyR(P.IDMEDIDA,@IdMunicipio) ) AS A WHERE A.ACTIVO = 1  ORDER BY IDPREGUNTA


END
GO
/****** Object:  StoredProcedure [PAT].[C_DatosExcel_Gobernaciones_municipios]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		21/07/2017
-- Modified date:	21/07/2017
-- Description:		Obtiene toda la informacion del municipio y tablero indicando en cuento a las respuestas que estos diligenciaron
-- ==========================================================================================

CREATE PROC [PAT].[C_DatosExcel_Gobernaciones_municipios] -- [PAT].[SP_GetDatosExcel_Gob_Mpios] --1013 --[PAT].[C_DatosExcel_Gobernaciones_municipios] 1513,2
(
	@IdUsuario INT, @IdTablero INT
)
AS
BEGIN

	Declare @IdMunicipio int, @IdDepartamento int, @Departamento VARCHAR(100)
	
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	select @Departamento = Nombre from Departamento where  Id = @IdDepartamento

    SELECT DISTINCT
					P.ID AS IDPREGUNTA, 
					P.IDDERECHO, 
					P.IDCOMPONENTE, 
					P.IDMEDIDA, 
					P.NIVEL, 
					P.PREGUNTAINDICATIVA, 
					P.IDUNIDADMEDIDA, 
					P.PREGUNTACOMPROMISO, 
					P.APOYODEPARTAMENTAL, 
					P.APOYOENTIDADNACIONAL, 
					P.ACTIVO, 
					D.DESCRIPCION AS DERECHO, 
					C.DESCRIPCION AS COMPONENTE, 
					M.DESCRIPCION AS MEDIDA, 
					UM.DESCRIPCION AS UNIDADMEDIDA,	
					T.Id AS IDTABLERO,						
					MR.Id  AS IDMUNICIPIO,
					R.ID as IDRESPUESTA,
					R.RESPUESTAINDICATIVA, 
					R.RESPUESTACOMPROMISO, 
					R.PRESUPUESTO,
					R.OBSERVACIONNECESIDAD,
					R.ACCIONCOMPROMISO					
					,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
					FROM PAT.RespuestaPATAccion AS ACCION
					WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ACCION					
					,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
					FROM [PAT].[RespuestaPATPrograma] AS PROGRAMA
					WHERE R.Id =PROGRAMA.IdRespuestaPAT  AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS PROGRAMA							
					,@Departamento AS DEPTO
					,MR.Nombre AS MPIO
					,DEP.Id AS IDRESPUESTADEP
					,DEP.RespuestaCompromiso AS RESPUESTA_DEP_COMPROMISO
					,DEP.ObservacionCompromiso as  RESPUESTA_DEP_OBSERVACION 
					,DEP.Presupuesto AS RESPUESTA_DEP_PRESUPUESTO				
					,STUFF((SELECT CAST( ACCIONDEP.Accion  AS VARCHAR(MAX)) + ' / ' 
					FROM PAT.RespuestaPATAccion AS ACCIONDEP
					WHERE DEP.Id = ACCIONDEP.IdRespuestaPAT AND ACCIONDEP.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ACCION_DEPTO
					,STUFF((SELECT CAST( PROGRAMADEP.Programa  AS VARCHAR(MAX)) + ' / ' 
					FROM [PAT].[RespuestaPATPrograma] AS PROGRAMADEP
					WHERE DEP.Id = PROGRAMADEP.IdRespuestaPAT AND PROGRAMADEP.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS PROGRAMA_DEPTO	
				FROM    [PAT].[PreguntaPAT] AS P
				INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
				INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
				INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
				INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
				INNER JOIN [PAT].Tablero AS T ON P.IDTABLERO = T.ID
				LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT]  
				LEFT OUTER JOIN Municipio AS MR ON R.IdMunicipio = MR.Id AND MR.IdDepartamento = @IdDepartamento											
				LEFT OUTER JOIN [PAT].RespuestaPATDepartamento DEP ON R.IdPreguntaPAT = DEP.IdPreguntaPAT and R.IdMunicipio = DEP.IdMunicipioRespuesta 	
				LEFT OUTER JOIN Municipio AS MRDEP ON DEP.IdMunicipioRespuesta = MRDEP.Id AND MRDEP.IdDepartamento = @IdDepartamento																																
				LEFT OUTER JOIN [PAT].[RespuestaPAT] as RDEP on P.ID = RDEP.[IdPreguntaPAT] and  R.IdMunicipio = @IdMunicipio 									
				WHERE  T.ID = @IdTablero and  P.NIVEL = 3 and MR.IdDepartamento = @IdDepartamento
				and P.ACTIVO = 1  ORDER BY DEPTO, MPIO, IDPREGUNTA
END
GO
/****** Object:  StoredProcedure [PAT].[C_DatosExcel_GobernacionesReparacionColectiva]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [PAT].[C_DatosExcel_GobernacionesReparacionColectiva] --[PAT].[C_DatosExcel_GobernacionesReparacionColectiva] 1513, 2
(	@IdUsuario INT, @IdTablero INT)
AS
BEGIN	

	Declare @IdMunicipio int, @IdDepartamento int, @Departamento VARCHAR(100)
	
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario				
	
	select distinct MEDIDA.Descripcion as Medida,
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
			d.Id as IdDane,
			d.Nombre as Municipio
		FROM PAT.PreguntaPATReparacionColectiva p
		INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
		INNER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id		
		INNER join Municipio as d on p.IdMunicipio =d.Id and d.Id =@IdMunicipio
		LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc on p.Id = rc.IdPreguntaPATReparacionColectiva and rc.IdMunicipio= p.IdMunicipio
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON rcd.IdMunicipioRespuesta= d.Id and rcd.IdPreguntaPATReparacionColectiva=p.Id
		where TABLERO.Id = @IdTablero
		order by Sujeto																

END

GO
/****** Object:  StoredProcedure [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones] --  [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones] 1513 , 2
(	@IdUsuario INT, @IdTablero INT)
AS
BEGIN

	Declare @IdMunicipio int, @IdDepartamento int, @Departamento VARCHAR(100)
	
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario		

	SELECT DISTINCT 
		P.Id AS IdPregunta
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
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoRetornosReubicaciones AS RD ON R.IdMunicipio = RD.IdMunicipioRespuesta
		where T.Id = @idTablero 
		AND P.IdMunicipio =@IdMunicipio
		order by P.Id

END

GO
/****** Object:  StoredProcedure [PAT].[C_DatosExcel_Municipios]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROC [PAT].[C_DatosExcel_Municipios] --506, 1
(
	@IdMunicipio INT, @IdTablero INT
)

AS
BEGIN

SELECT 
DISTINCT  
		--ID_PREGUNTA,ID_DERECHO,ID_COMPONENTE,ID_MEDIDA,NIVEL,PREGUNTA_INDICATIVA,ID_UNIDAD_MEDIDA,PREGUNTA_COMPROMISO,APOYO_DEPARTAMENTAL,APOYO_ENTIDAD_NACIONAL,ACTIVO,
		--DERECHO, COMPONENTE,MEDIDA,UNIDAD_MEDIDA,ID_TABLERO,ID_ENTIDAD,id_respuesta,RESPUESTA_INDICATIVA,RESPUESTA_COMPROMISO,PRESUPUESTO,OBSERVACION_NECESIDAD,ACCION_COMPROMISO
LINEA
,IDPREGUNTA AS ID
, '' AS ENTIDAD
,DERECHO
,COMPONENTE
,MEDIDA
,PREGUNTAINDICATIVA
,PREGUNTACOMPROMISO
,UNIDADMEDIDA
,RESPUESTAINDICATIVA
,OBSERVACIONNECESIDAD
,RESPUESTACOMPROMISO
,ACCIONCOMPROMISO AS OBSERVACIONCOMPROMISO
,CONVERT(FLOAT, PRESUPUESTO) AS PRESUPUESTO
,ACCION
,PROGRAMA

	FROM ( 
    SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						R.ID AS IDTABLERO,						
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID as id_respuesta,
						R.RESPUESTAINDICATIVA, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO
						,AA.ACCION
						,AP.PROGRAMA
				FROM    [PAT].[PreguntaPAT] AS P
				INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
				INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
				INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
				INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
				INNER JOIN PAT.Tablero AS T ON P.IDTABLERO = T.ID
				LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] and  R.IdMunicipio = @IdMunicipio 									
				LEFT OUTER JOIN [PAT].[RespuestaPATAccion] AS AA ON AA.[IdRespuestaPAT] = R.ID and AA.Activo = 1
				LEFT OUTER JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
				INNER JOIN Usuario AS U ON R.IdUsuario = U.Id  AND U.IdMunicipio = @IdMunicipio
				WHERE  T.ID = @IdTablero and
				P.NIVEL = 3 AND 1=pat.ValidarPreguntaRyR(P.IDMEDIDA,@IdMunicipio) ) AS A WHERE A.ACTIVO = 1  ORDER BY IDPREGUNTA

END


GO
/****** Object:  StoredProcedure [PAT].[C_Derechos]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [PAT].[C_Derechos] ( @idTablero tinyint)

AS

BEGIN

	SELECT 
		D.ID, D.DESCRIPCION
	FROM 
		[PAT].[Derecho] D
	WHERE
		D.ID 
			IN
			(
				SELECT DISTINCT PP.IDDERECHO
				FROM [PAT].[PreguntaPAT] pp
				WHERE PP.IDTABLERO = @idTablero				
			)
	ORDER BY D.Descripcion

END



GO
/****** Object:  StoredProcedure [PAT].[C_MunicipiosReparacionColectiva]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Procedimiento que retorna los municipios de reparación colectiva.
-- =============================================
CREATE PROCEDURE [PAT].[C_MunicipiosReparacionColectiva]--[PAT].[C_MunicipiosReparacionColectiva] 1315 
	@IdUsuario INT,  @idTablero tinyint
AS
BEGIN

	declare @IdDepartamento int
	select @IdDepartamento = IdDepartamento	 from Usuario where Id = @IdUsuario	
	SELECT distinct
	m.Id,
	m.Nombre as Municipio
	FROM  pat.PreguntaPATReparacionColectiva as p
	INNER JOIN Municipio as m on p.IdMunicipio = m.id
	WHERE m.IdDepartamento = @IdDepartamento and p.IdTablero = @idTablero
	order by m.Nombre	
END


GO
/****** Object:  StoredProcedure [PAT].[C_MunicipiosRetornosReubicaciones]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Procedimiento que retorna los municipios de retornos y reubicaciones.
-- =============================================
CREATE PROCEDURE [PAT].[C_MunicipiosRetornosReubicaciones]--[PAT].[C_MunicipiosRetornosReubicaciones] 1315 
	@IdUsuario INT ,@idTablero tinyint
AS
BEGIN

	declare @IdDepartamento int
	select @IdDepartamento = IdDepartamento	 from Usuario where Id = @IdUsuario	
	SELECT distinct
	m.Id,
	m.Nombre as Municipio
	FROM  pat.PreguntaPATRetornosReubicaciones as p
	INNER JOIN Municipio as m on p.IdMunicipio = m.id
	WHERE m.IdDepartamento = @IdDepartamento and p.IdTablero = @idTablero
	order by m.Nombre	
END

GO
/****** Object:  StoredProcedure [PAT].[C_NecesidadesIdentificadas]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las necesidades identificadas del municipio acorde con la pregunta del PAT
-- =============================================
CREATE procedure [PAT].[C_NecesidadesIdentificadas] --103, 109
	@USUARIO INT,
	@PREGUNTA SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Cant INT
    DECLARE @Cantidad INT
    DECLARE @CantidadDef NVARCHAR(100)

	DECLARE  @SQL NVARCHAR(MAX)

	DECLARE @Divipola  varchar(5)
	SELECT @Divipola =  M.Divipola
	FROM [dbo].[Usuario] (NOLOCK) U
	JOIN Municipio AS M ON U.IdMunicipio = M.Id
	WHERE U.ID = @USUARIO

	SET @SQL = 'SELECT
				@Cantidad = COUNT(1)
				FROM
					(
						SELECT DISTINCT
							A.*
						FROM
							[PAT].[PrecargueSIGO] A
						WHERE
							A.[CodigoDane] = @Divipola
					'
	IF @PREGUNTA = 108
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Solicita asistencia funeraria'''
	ELSE IF @PREGUNTA IN (111, 112)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere acceso a educaciÃ³n bÃ¡sica o media'''
	ELSE IF @PREGUNTA = 113
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto requiere acceso a educaciÃ³n bÃ¡sica o media'''
	ELSE IF @PREGUNTA IN (110, 163)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere cuidado inicial'''
	ELSE IF @PREGUNTA = 170
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Mejoramiento vivienda'''
	ELSE IF @PREGUNTA = 171
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Vivienda nueva'''
	ELSE IF @PREGUNTA = 146
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Requiere acceso a EducaciÃ³n Gitano Rom - IndÃ­gena'''
	ELSE IF @PREGUNTA = 148
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Documento de identidad'''
	ELSE IF @PREGUNTA = 149
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Libreta militar'''
	ELSE IF @PREGUNTA = 141
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere acceso a programas regulares de alimentaciÃ³n'''
	ELSE IF @PREGUNTA IN (140, 142)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto requiere acceso a programas regulares de alimentaciÃ³n'''
	ELSE IF @PREGUNTA IN (144, 145)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Madre gestante o lactante requiere apoyo alimentario'''
	ELSE IF @PREGUNTA = 127
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto solicita reunificaciÃ³n familiar'''
	ELSE IF @PREGUNTA = 128
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''AfiliaciÃ³n al SGSSS'''
	ELSE IF @PREGUNTA = 139
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Requiere acceso a programa jÃ³venes en acciÃ³n'''
	ELSE IF @PREGUNTA IN (120, 121)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Apoyo a nuevos emprendimientos'''
	ELSE IF @PREGUNTA IN (122, 123)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Fortalecimiento de negocios'''
	ELSE IF @PREGUNTA IN (124, 125)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Empleabilidad'''
	ELSE IF @PREGUNTA = 126
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor solicita reunificaciÃ³n familiar'''
	ELSE IF @PREGUNTA = 152
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''AtenciÃ³n psicosocial'''
	ELSE IF @PREGUNTA IN (116, 117)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''OrientaciÃ³n ocupacional'''
	ELSE IF @PREGUNTA IN (118, 119)
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''EducaciÃ³n y/o orientaciÃ³n para el trabajo'''
	ELSE
		SET @SQL = @SQL + ' AND	NombreNecesidad = ''ninguna'''
	--SET @SQL = 'SELECT
	--				@Cantidad = COUNT(1)
	--			FROM
	--				(
	--				SELECT
	--						DISTINCT C.TIPO_DOCUMENTO,C.NUMERO_DOCUMENTO,C.ID_MEDIDA,C.ID_NECESIDAD
	--				from	DBO.TB_CARGUE C 
	--				INNER JOIN	DBO.TB_LOTE L ON C.ID_LOTE = L.ID
	--				INNER JOIN	DBO.Entidad E ON C.DANE_MUNICIPIO = E.ID_MUNICIPIO
	--				INNER JOIN	PAT.Pregunta P ON P.ID_MEDIDA = C.ID_MEDIDA
	--				WHERE	L.ID_ESTADO = 3	
	--				AND		E.ID = PAT.GetIdEntidad(@USUARIO)
	--				AND		P.ID  = @PREGUNTA '

	---- MEDIDA IDENTIFICACIÓN
	--IF @PREGUNTA = 1
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 6'
	--IF @PREGUNTA = 2
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 7 AND 17'
	--IF @PREGUNTA = 3
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >= 18'

	---- MEDIDA SALUD
	--IF @PREGUNTA = 5
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'

	---- MEDIDA REHABILITACIÓN PSICOSOCIAL


	---- MEDIDA EDUCACIÓN
	--IF @PREGUNTA = 7
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 6 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 5'
	--IF @PREGUNTA = 8
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
	--IF @PREGUNTA = 9
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
	--IF @PREGUNTA = 10
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'

	---- MEDIDA GENERACION DE INGRESOS
	--IF @PREGUNTA = 11
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 12
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 13
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 14
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 15
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 5'
	--IF @PREGUNTA = 16
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 5'
	--IF @PREGUNTA = 17
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 4'
	--IF @PREGUNTA = 18
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 4'
	--IF @PREGUNTA = 19
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD in (3,8)'
	--IF @PREGUNTA = 20
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD in (3,8)'

	---- MEDIDA SEGURIDAD ALIMENTARIA
	--IF @PREGUNTA = 21
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 5'
	--IF @PREGUNTA = 22
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
	--IF @PREGUNTA = 23
	--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'
	--IF @PREGUNTA = 24 
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 25
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'

	---- MEDIDA REUNIFICACIÓN FAMILIAR
	--IF @PREGUNTA = 26
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 17'
	--IF @PREGUNTA = 27
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'

	---- MEDIDA VIVIENDA
	--IF @PREGUNTA = 28
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 29
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	--IF @PREGUNTA = 30
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 31
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 32
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 33
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 34
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 35
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 36
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	
	---- MEDIDA ASISTENCIA FUNERARIA
	--IF @PREGUNTA = 37
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	--IF @PREGUNTA = 38
	--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'

	SET @SQL = @SQL + ')P' 
	
	SET @CantidadDef = N'@Cantidad INT OUTPUT,@USUARIO INT,@Divipola  varchar(5)'
    SET @Cant = 0 

	print @SQL
  
    EXECUTE sp_executesql @Sql, @CantidadDef, @Cantidad = @Cant OUTPUT, @USUARIO = @USUARIO ,@Divipola=@Divipola    
    SELECT @Cant Cantidad
END 





GO
/****** Object:  StoredProcedure [PAT].[C_ProgramasPAT]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [PAT].[C_ProgramasPAT]( 
	@ID as INT	
)
AS
BEGIN
	SET NOCOUNT ON;	

	SELECT	P.PROGRAMA,P.ID
	FROM	[PAT].[RespuestaPAT] (NOLOCK) AS R,
			[PAT].[RespuestaPATPrograma] (NOLOCK) AS P
	WHERE	R.ID = P.[IdRespuestaPAT] AND P.ACTIVO = 1 AND R.ID = @ID
END





GO
/****** Object:  StoredProcedure [PAT].[C_TableroDepartamento]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT departamental
-- ==========================================================================================
CREATE PROCEDURE [PAT].[C_TableroDepartamento]  --1013
 (@IdUsuario INT, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 2

	DECLARE  @IDENTIDAD INT
	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)

	SELECT 	P.Id AS ID_PREGUNTA, 
			P.IdDerecho, 
			P.IdComponente, 
			P.IdMedida, 
			P.NIVEL as Nivel, 
			P.PreguntaIndicativa, 
			P.IdUnidadMedida, 
			P.PreguntaCompromiso, 
			P.ApoyoDepartamental, 
			P.ApoyoEntidadNacional, 
			P.ACTIVO as Activo, 
			DERECHO.Descripcion AS Derecho, 
			COMPONENTE.Descripcion AS Componente, 
			MEDIDA.Descripcion AS Medida, 
			UNIDAD_MEDIDA.Descripcion AS UnidadMedida,	
			@idTablero AS IdTablero,			
			@IDENTIDAD AS IdEntidad,						
			R.Id as IdRespuesta,
			R.RespuestaIndicativa,  
			R.RespuestaCompromiso, 
			R.Presupuesto,
			R.ObservacionNecesidad, 
			R.AccionCompromiso 
	FROM  PAT.PreguntaPAT AS P
	INNER JOIN PAT.Derecho DERECHO ON P.IdDerecho = DERECHO.Id 
	INNER JOIN PAT.Componente COMPONENTE ON P.IdComponente= COMPONENTE.Id
	INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
	INNER JOIN PAT.UnidadMedida UNIDAD_MEDIDA ON P.IdUnidadMedida = UNIDAD_MEDIDA.Id
	LEFT OUTER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id	
	LEFT OUTER JOIN [PAT].[RespuestaPAT] AS R ON P.Id = R.IdPreguntaPAT AND R.IdMunicipio =  @IDENTIDAD 
	--LEFT OUTER JOIN PAT.TB_PAT_RESPUESTA AS RESPUESTA ON TABLERO.ID = RESPUESTA.ID_TABLERO AND RESPUESTA.ID_ENTIDAD = PAT.fn_GetIdEntidad(@USUARIO)
	WHERE TABLERO.Id = @idTablero
	AND	P.NIVEL = 2 and P.ACTIVO = 1
END

GO
/****** Object:  StoredProcedure [PAT].[C_TableroDepartamentoAvance]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
-- Description:		Obtiene los totales de necesidades y compromisos departamentales del tablero PAT
-- ==========================================================================================
CREATE PROCEDURE [PAT].[C_TableroDepartamentoAvance]--  1513,1
		@IdUsuario INT, @idTablero tinyint
AS
BEGIN
	SET NOCOUNT ON;	
	DECLARE @NIVEL INT = 3
	DECLARE  @ID_ENTIDAD INT
	SELECT  @ID_ENTIDAD  =  [PAT].[fn_GetIdEntidad](@IdUsuario) 

	SELECT	D.Descripcion AS DERECHO, 
			SUM(case when R.RespuestaIndicativa IS NULL or R.RespuestaIndicativa=0 then 0 else 1 end)*100/count(*) PINDICATIVA,
			SUM(case when R.RespuestaCompromiso IS NULL or R.RespuestaCompromiso=0 then 0 else 1 end)*100/count(*) PCOMPROMISO
	FROM    [PAT].[PreguntaPAT] (NOLOCK) AS P
	INNER JOIN [PAT].[Derecho] (NOLOCK) D ON P.IDDERECHO = D.ID 
	INNER JOIN PAT.Tablero (NOLOCK) AS T ON P.IDTABLERO = T.ID				
	LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON R.IdMunicipio = @ID_ENTIDAD  and P.ID = R.[IdPreguntaPAT]
	WHERE	P.NIVEL = @NIVEL 
	AND 1=pat.ValidarPreguntaRyR(P.IDMEDIDA,@ID_ENTIDAD )  
	AND T.ID = @idTablero
	and P.ACTIVO = 1	
	group by D.DESCRIPCION
END

GO
/****** Object:  StoredProcedure [PAT].[C_TableroDepartamentoReparacionColectiva]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Obtiene el tablero para la gestión departamental de reparación colectiva
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroDepartamentoReparacionColectiva] --[PAT].[C_TableroDepartamentoReparacionColectiva] 1, 20,11001,1
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


GO
/****** Object:  StoredProcedure [PAT].[C_TableroDepartamentoRetornosReubicaciones]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Obtiene el tablero para la gestión departamental de retornos y reubicaciones
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroDepartamentoRetornosReubicaciones] --[PAT].[C_TableroDepartamentoRetornosReubicaciones] 1, 20,11001,2
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

	SET @SQL = 'SELECT DISTINCT TOP (20) 
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
	LEFT OUTER JOIN PAT.RespuestaPATDepartamentoRetornosReubicaciones AS RD ON R.IdMunicipio = RD.IdMunicipioRespuesta
	where T.Id = @idTablero 
	AND P.IdMunicipio =@IdMunicipio
	) AS P 
	--WHERE LINEA >@PAGINA 
	ORDER BY P.IdPregunta  
	'

		SET @PARAMETROS = '@TOP SMALLINT, @PAGINA SMALLINT,@idTablero tinyint, @IdMunicipio INT'

		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @idTablero= @idTablero,@IdMunicipio=@IdMunicipio
		SELECT * from @RESULTADO
END



GO
/****** Object:  StoredProcedure [PAT].[C_TableroFechaActivo]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		23/09/2016
-- Modified date:	
-- Description:		Procedimiento que valida activación del tablero por fechas
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroFechaActivo]
	@NIVEL TINYINT,
	@IDTABLERO tinyint
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Cant INT
    	DECLARE @Cantidad INT
    	DECLARE @CantidadDef NVARCHAR(100)

	SELECT @Cantidad = COUNT(*)
	FROM [PAT].[TableroFecha] 
	WHERE GETDATE() BETWEEN VIGENCIAINICIO AND VIGENCIAFIN
	AND IDTABLERO = @IDTABLERO
	AND NIVEL = @NIVEL AND ACTIVO = 1 
	
	 
    SELECT @Cantidad
END




GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipio]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [PAT].[C_TableroMunicipio] --null, 1, 20, 506, 'salud'

 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		IDPREGUNTA SMALLINT,IDDERECHO SMALLINT,IDCOMPONENTE TINYINT,IDMEDIDA SMALLINT,NIVEL TINYINT,
		PREGUNTAINDICATIVA NVARCHAR(500),IDUNIDADMEDIDA TINYINT,PREGUNTACOMPROMISO NVARCHAR(500),APOYODEPARTAMENTAL BIT,
		APOYOENTIDADNACIONAL BIT,ACTIVO BIT,DERECHO NVARCHAR(50),COMPONENTE NVARCHAR(100),MEDIDA NVARCHAR(50),
		UNIDADMEDIDA NVARCHAR(100),IDTABLERO TINYINT,IDENTIDAD INT,ID INT,RESPUESTAINDICATIVA INT,
		RESPUESTACOMPROMISO INT,PRESUPUESTO MONEY,OBSERVACIONNECESIDAD NVARCHAR(1000),ACCIONCOMPROMISO NVARCHAR(1000)
		)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize 

	SET @ORDEN = @sortOrder
	SET @ORDEN = 'P.ID'
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE  @IDENTIDAD INT

	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
	SET @SQL = 'SELECT 	
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO
		FROM (
		SELECT DISTINCT TOP (@TOP) LINEA,
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO
	FROM ( 
    SELECT DISTINCT row_number() OVER (ORDER BY '+ @ORDEN +') AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IDENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID ,
						R.RespuestaIndicativa, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO
				FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdMunicipio =  @IDENTIDAD ,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 
					AND 1=pat.ValidarPreguntaRyR(P.IDMEDIDA,@IDENTIDAD) 
					AND D.ID = @IdDerecho'	
	SET @SQL =@SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY LINEA ) AS T'
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IDENTIDAD INT,@IdDerecho INT'
		
	PRINT @SQL

	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IDENTIDAD=@IDENTIDAD, @IdDerecho=@IdDerecho
	SELECT * from @RESULTADO
END





GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioAvance]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene los porcentajes de avance de la gestión del tablero PAT por municipio
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroMunicipioAvance] -- 506,2
		@IdUsuario INT, @idTablero tinyint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		DERECHO NVARCHAR(50),
		PINDICATIVA INT,
		PCOMPROMISO INT
		)
	
	DECLARE  @ID_ENTIDAD INT
	SELECT  @ID_ENTIDAD  =  [PAT].[fn_GetIdEntidad](@IdUsuario) 

	SELECT	D.DESCRIPCION AS DERECHO, 
			SUM(case when R.RESPUESTAINDICATIVA IS NULL or R.RESPUESTAINDICATIVA=0 then 0 else 1 end)*100/count(*) PINDICATIVA,
			SUM(case when R.RESPUESTACOMPROMISO IS NULL or R.RESPUESTACOMPROMISO=0 then 0 else 1 end)*100/count(*) PCOMPROMISO
	FROM    [PAT].[PreguntaPAT] (NOLOCK) AS P
	INNER JOIN [PAT].[Derecho] (NOLOCK) D ON P.IDDERECHO = D.ID 
	INNER JOIN PAT.Tablero (NOLOCK) AS T ON P.IDTABLERO = T.ID				
	LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON R.IdMunicipio = @ID_ENTIDAD  and P.ID = R.[IdPreguntaPAT]
	WHERE	P.NIVEL = @NIVEL 
	AND 1=pat.ValidarPreguntaRyR(P.IDMEDIDA,@ID_ENTIDAD )  
	AND T.ID = @idTablero
	and P.ACTIVO = 1	
	group by D.DESCRIPCION
END



GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioRC]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de responsabilidad Colectiva	
-- =============================================

create PROCEDURE [PAT].[C_TableroMunicipioRC]-- NULL, 1, 20, 46, 'Reparación Integral',1
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho INT, @idTablero tinyint)

AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		LINEA INT,
		IDPREGUNTARC SMALLINT,
		IDDANE INT,
		IDMEDIDA SMALLINT,
		SUJETO NVARCHAR(3000),
		MEDIDARC NVARCHAR(2000),
		MEDIDA NVARCHAR(500),
		IDTABLERO TINYINT,
		IDENTIDAD INT,
		ID INT,
		ACCION NVARCHAR(4000),
		PRESUPUESTO MONEY
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE @IDDANE INT, @IDENTIDAD INT
	
	--SELECT @IDDANE= [PAT].[fn_GetDaneMunicipioEntidad](@IdUsuario)
	SELECT @IDENTIDAD =[PAT].[fn_GetIdEntidad](@IdUsuario)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize


	SET @ORDEN = @sortOrder
	IF @ORDEN = '' or @ORDEN is NULL
		SET @ORDEN = 'IDPREGUNTA'

	IF  @IdDerecho = 6
	BEGIN
		SET @SQL = 'SELECT  TOP (@TOP) A.LINEA,
				A.IDPREGUNTA, 
				A.IDDANE,
				A.IDMEDIDA,
				A.SUJETO,
				A.MEDIDARC,
				A.MEDIDA,
				A.IDTABLERO,
				A.IDENTIDAD,
				A.ID,
				A.ACCION,
				A.PRESUPUESTO 
					FROM (SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
							P.ID AS IDPREGUNTA, 
							P.[IdMunicipio] AS IDDANE, 
							P.IDMEDIDA, 
							P.SUJETO, 
							P.[MedidaReparacionColectiva] AS MEDIDARC, 
							M.DESCRIPCION AS MEDIDA, 
							T.ID AS IDTABLERO,
							CASE WHEN R.IdMunicipio IS NULL THEN @IDENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
							R.ID,
							R.ACCION, 
							R.PRESUPUESTO
						FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
							LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] AS R ON P.ID= R.[IdPreguntaPATReparacionColectiva] AND R.[IdMunicipio] = @IDENTIDAD,
							[PAT].[Medida] M,
							[PAT].[Tablero] T
						WHERE	P.IDMEDIDA = M.ID 
							AND P.[IdMunicipio] = @IDENTIDAD
							AND P.IDTABLERO = T.ID
							AND T.ID = @idTablero'
		SET @SQL =@SQL +') AS A WHERE A.LINEA >@PAGINA  AND A.IDPREGUNTA > 2242 ORDER BY A.LINEA ASC'-- AND IDPREGUNTA > 2242
		SET @PARAMETROS = '@TOP INT, @PAGINA INT,@idTablero tinyint,@IDENTIDAD INT'		
		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @idTablero=@idTablero, @IDENTIDAD=@IDENTIDAD
	END
	SELECT * from @RESULTADO
END


GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioRR]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de responsabilidad Colectiva	
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroMunicipioRR] --'', 1, 20, 394, 'Reparación Integral'
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho INT, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		LINEA INT,
		ID_PREGUNTA_RR SMALLINT,
		ID_DANE INT,
		HOGARES SMALLINT,
		PERSONAS SMALLINT,
		SECTOR NVARCHAR(MAX),
		COMPONENTE NVARCHAR(MAX),
		COMUNIDAD NVARCHAR(MAX),
		UBICACION NVARCHAR(MAX),
		MEDIDA_RR NVARCHAR(MAX),
		INDICADOR_RR NVARCHAR(MAX),
		ENTIDAD_RESPONSABLE NVARCHAR(MAX),
		ID_TABLERO TINYINT,
		ID_ENTIDAD INT,
		ID INT,
		ACCION NVARCHAR(1000),
		PRESUPUESTO MONEY
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE @ID_ENTIDAD INT
	--DECLARE @ID_DANE INT
		
	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize

	SET @ORDEN = @sortOrder
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'ID_PREGUNTA'

	SELECT @ID_ENTIDAD=PAT.fn_GetIdEntidad(@IdUsuario)
	--SELECT @ID_DANE=[PAT].[fn_GetDaneMunicipioEntidad](@IdUsuario)
	IF  @IdDerecho = 6
	BEGIN
		SET @SQL = 'SELECT	LINEA,IDPREGUNTA,IDDANE,HOGARES,PERSONAS,SECTOR, 
							COMPONENTE, COMUNIDAD, UBICACION, MEDIDARR, INDICADORRR, 
							ENTIDADRESPONSABLE, IDTABLERO,IDENTIDAD,ID,ACCION,PRESUPUESTO 
					FROM (
							SELECT DISTINCT TOP (@TOP) LINEA,IDPREGUNTA,IDDANE,HOGARES,PERSONAS,SECTOR, 
							COMPONENTE,COMUNIDAD,UBICACION,MEDIDARR,INDICADORRR, 
							ENTIDADRESPONSABLE,IDTABLERO,IDENTIDAD,ID,ACCION,PRESUPUESTO
					FROM ( 
							SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
							P.ID AS IDPREGUNTA,
							P.[IdMunicipio] AS IDDANE,
							P.[HOGARES],
							P.[PERSONAS],
							P.[SECTOR],
							P.[COMPONENTE],
							P.[COMUNIDAD],
							P.[UBICACION],
							P.[MedidaRetornoReubicacion] AS MEDIDARR,
							P.[IndicadorRetornoReubicacion] AS INDICADORRR,
							P.[ENTIDADRESPONSABLE], 
							T.ID AS IDTABLERO,
							CASE WHEN R.IdMunicipio IS NULL THEN @ID_ENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
							R.ID,
							R.ACCION, 
							R.PRESUPUESTO
					FROM   [PAT].[PreguntaPATRetornosReubicaciones] P
					INNER JOIN [PAT].[Tablero] T ON P.[IdTablero] = T.ID
					LEFT OUTER JOIN [PAT].[RespuestaPATRetornosReubicaciones] R ON R.IdMunicipio = @ID_ENTIDAD and p.ID = R.[IdPreguntaPATRetornoReubicacion]
					WHERE  T.ID = @idTablero and P.[IdMunicipio] = @ID_ENTIDAD'
		SET @SQL =@SQL +' ) AS A WHERE A.LINEA >@PAGINA ORDER BY A.LINEA ) as F'
		SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT,@idTablero tinyint,  @ID_ENTIDAD INT'

--		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero,@ID_ENTIDAD= @ID_ENTIDAD
	END
	SELECT * from @RESULTADO
END





GO
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioTotales]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	21/07/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados 
-- ==========================================================================================
create PROCEDURE [PAT].[C_TableroMunicipioTotales]  
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT,  @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @RESULTADO TABLE (
		ID_PREGUNTA SMALLINT,
		PREGUNTAINDICATIVA NVARCHAR(500),
		PREGUNTACOMPROMISO NVARCHAR(500),
		DERECHO NVARCHAR(50),
		COMPONENTE NVARCHAR(100),
		MEDIDA NVARCHAR(50),
		UNIDADMEDIDA NVARCHAR(100),
		IDTABLERO TINYINT,
		IDENTIDAD INT,
		TOTALNECESIDADES INT,
		TOTALCOMPROMISOS INT,
		ID INT
		)
	
	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize

	SET @ORDEN = @sortOrder
	IF @ORDEN = ''
			SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE  @IDENTIDAD INT, @IDDEPARTAMENTO INT

	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
	SELECT @IDDEPARTAMENTO = IdDepartamento FROM USUARIO WHERE Id = @IdUsuario

	SET @SQL = 'SELECT DISTINCT TOP (@TOP) 
					IDPREGUNTA,PREGUNTAINDICATIVA,PREGUNTACOMPROMISO,
					DERECHO,COMPONENTE,MEDIDA,UNIDADMEDIDA,IDTABLERO,IDENTIDAD,TOTALNECESIDADES,TOTALCOMPROMISOS,ID
				FROM ( 
				 SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.PREGUNTAINDICATIVA, 
						P.PREGUNTACOMPROMISO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IDENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
						(SELECT SUM(R1.RespuestaIndicativa) 
							FROM  [PAT].[RespuestaPAT] R1	
							join Municipio MUN ON R1.IdMunicipio = MUN.Id
							WHERE R1.[IdPreguntaPAT]=P.Id  AND MUN.IdDepartamento = @IDDEPARTAMENTO							
						) TOTALNECESIDADES,
						(SELECT SUM(R1.RESPUESTACOMPROMISO) 
							FROM  [PAT].[RespuestaPAT] R1
							join Municipio MUN ON R1.IdMunicipio = MUN.Id
							WHERE R1.IdPreguntaPAT=P.Id AND MUN.IdDepartamento = @IDDEPARTAMENTO								
						) TOTALCOMPROMISOS,
						R.ID
				FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdMunicipio =  @IDENTIDAD ,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 					
					AND D.ID = @IdDerecho'		
	SET @SQL = @SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY P.ID'--+ @ORDEN 	
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IDENTIDAD INT,@IdDerecho INT, @IDDEPARTAMENTO int'
		
	PRINT @SQL

	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IDENTIDAD=@IDENTIDAD, @IdDerecho=@IdDerecho, @IDDEPARTAMENTO=@IDDEPARTAMENTO
	SELECT * from @RESULTADO
END

GO
/****** Object:  StoredProcedure [PAT].[C_TableroVigencia]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene el tablero vigente
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroVigencia] 
 (@idTablero tinyint)
AS
BEGIN
	SELECT	YEAR(P.VIGENCIAINICIO) ANNO,
			(CONVERT(VARCHAR(10), P.VIGENCIAINICIO, 103) + ' AL ' + CONVERT(VARCHAR(10), P.VIGENCIAFIN, 103)) VIGENCIA
	FROM [PAT].[Tablero] P
	WHERE	 P.Id=@idTablero
END


GO
/****** Object:  StoredProcedure [PAT].[C_TodosTablerosDepartamentosCompletos]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que NO estan activos
-- ==========================================================================================
create PROC [PAT].[C_TodosTablerosDepartamentosCompletos]
AS
BEGIN
	select
	A.[Id], B.[VigenciaInicio], B.[VigenciaFin]
	from
	[PAT].[Tablero] A,
	[PAT].[TableroFecha] B
	where A.[Id]=B.[IdTablero]
	and B.[Nivel]=2
	and A.[Activo]=0
END

GO
/****** Object:  StoredProcedure [PAT].[C_TodosTablerosDepartamentosPorCompletar]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que esten activos
-- ==========================================================================================
create PROC [PAT].[C_TodosTablerosDepartamentosPorCompletar]
AS
BEGIN
	select  A.Id, B.Vigenciainicio, B.VigenciaFin 
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=2
	and A.Activo=1
END

GO
/****** Object:  StoredProcedure [PAT].[C_TodosTablerosMunicipiosCompletos]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [PAT].[C_TodosTablerosMunicipiosCompletos]

AS

BEGIN

select
A.[Id],
B.[VigenciaInicio],
B.[VigenciaFin]
from
[PAT].[Tablero] A,
[PAT].[TableroFecha] B
where
A.[Id]=B.[IdTablero]
and B.[Nivel]=3
and A.[Activo]=0

END


GO
/****** Object:  StoredProcedure [PAT].[C_TodosTablerosMunicipiosPorCompletar]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que NO estan activos
-- ==========================================================================================
create PROC [PAT].[C_TodosTablerosMunicipiosPorCompletar]
AS
BEGIN
	select  A.Id,  B.Vigenciainicio, B.VigenciaFin 
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=3
	and A.Activo=1
END

GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaAccionesInsert]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la información del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaAccionesInsert] 
           @IDPATRESPUESTA int,
           @ACCION nvarchar(500),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATAccion]
           ([IdRespuestaPAT]
           ,[ACCION]
           ,[ACTIVO])
			VALUES
           (@IDPATRESPUESTA,
            @ACCION, 
            @ACTIVO)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		


GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaAccionesRCInsert]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la información del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaAccionesRCInsert] 
           @IDPATRESPUESTA int,
           @ACCION nvarchar(500),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATAccionReparacionColectiva]
           ([IdRespuestaPATReparacionColectiva]
           ,[AccionReparacionColectiva]
           ,[ACTIVO])
			VALUES
           (@IDPATRESPUESTA,
            @ACCION, 
            @ACTIVO)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		


GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaAccionesRRInsert]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la información del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaAccionesRRInsert] 
           @IDPATRESPUESTA int,
           @ACCION nvarchar(500),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATAccionRetornosReubicaciones]
           ([IdRespuestaPATRetornoReubicacion]
           ,[AccionRetornoReubicacion]
           ,[ACTIVO])
			VALUES
           (@IDPATRESPUESTA,
            @ACCION, 
            @ACTIVO)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		


GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaDepartamentoInsert]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-17																			  
/Descripcion: Inserta la información del consolidado municipal
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[I_RespuestaDepartamentoInsert] 
	@IdTablero tinyint
	,@IdPreguntaPAT smallint
	,@RespuestaCompromiso int
	,@Presupuesto money
	,@ObservacionCompromiso nvarchar(1000)
	,@IdMunicipioRespuesta int
	,@IdUsuario int

	AS 	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	declare @id int	
	
	select @id = r.ID from [PAT].RespuestaPATDepartamento as r
	where r.IdPreguntaPAT = @IdPreguntaPAT AND  r.[IdMunicipioRespuesta] = @IdMunicipioRespuesta and r.IdTablero = @IdTablero
	order by r.ID
	if (@id is not null)
	begin
		set @esValido = 0
		set @respuesta += 'La respuesta ya se encuentra ingresada.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
	
		INSERT INTO [PAT].[RespuestaPATDepartamento]
           ([IdTablero]           
           ,[IdPreguntaPAT]
           ,[RespuestaCompromiso]
           ,[Presupuesto]
           ,[ObservacionCompromiso]
           ,[IdMunicipioRespuesta]
           ,[IdUsuario]
		   ,[FechaInsercion])
		VALUES
			( @IdTablero 			
			,@IdPreguntaPAT 
			,@RespuestaCompromiso 
			,@Presupuesto 
			,@ObservacionCompromiso
			,@IdMunicipioRespuesta 
			,@IdUsuario
			, getdate())

			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id



GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaDepartamentoRCInsert]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-25																			  
/Descripcion: Inserta la información del tablero municipal para Reparacion colectiva												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaDepartamentoRCInsert] 
				   @IdTablero tinyint,
				   @IdPreguntaPATReparacionColectiva smallint,
				   @AccionDepartamento nvarchar(1000),
				   @PresupuestoDepartamento money,
				   @IdMunicipioRespuesta int,
				   @IdUsuario int			
AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	
	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY
			INSERT INTO [PAT].[RespuestaPATDepartamentoReparacionColectiva]
			   ([IdTablero]
			   ,[IdPreguntaPATReparacionColectiva]
			   ,[AccionDepartamento]
			   ,[PresupuestoDepartamento]
			   ,[IdMunicipioRespuesta]
			   ,[IdUsuario]
			   ,[FechaInsercion])
			 VALUES (
				@IdTablero 
				,@IdPreguntaPATReparacionColectiva 
				,@AccionDepartamento 
				,@PresupuestoDepartamento 
				,@IdMunicipioRespuesta
				,@IdUsuario
				,getdate()
				)

				select @id = SCOPE_IDENTITY()
				SELECT @respuesta = 'Se ha ingresado el registro'
				SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id


GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaDepartamentoRRInsert]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-25																			  
/Descripcion: Inserta la información del tablero municipal para Retornos y reubicaciones												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[I_RespuestaDepartamentoRRInsert] 
			   @IdTablero tinyint,			
			   @IdPreguntaPATRetornoReubicacion smallint,
			   @AccionDepartamento nvarchar(1000),
			   @PresupuestoDepartamento money,
			   @IdMunicipioRespuesta int,
			   @IdUsuario int			   				 
AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	
	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY

		INSERT INTO [PAT].[RespuestaPATDepartamentoRetornosReubicaciones]
			   ([IdTablero]			  
			   ,[IdPreguntaPATRetornoReubicacion]
			   ,[AccionDepartamento]
			   ,[PresupuestoDepartamento]
			   ,[IdMunicipioRespuesta]
			   ,[IdUsuario]
			   ,[FechaInsercion])
		 VALUES ( 
			   @IdTablero ,			  
			   @IdPreguntaPATRetornoReubicacion ,
			   @AccionDepartamento ,
			   @PresupuestoDepartamento ,
			   @IdMunicipioRespuesta ,
			   @IdUsuario ,
			   getdate())

				select @id = SCOPE_IDENTITY()
				SELECT @respuesta = 'Se ha ingresado el registro'
				SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id


GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaInsert]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la información del tablero municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaInsert] 
		@IDUSUARIO int,
		@IDPREGUNTA smallint,
		@NECESIDADIDENTIFICADA int,
		@RESPUESTAINDICATIVA int,
		@RESPUESTACOMPROMISO int,
		@PRESUPUESTO money,
		@OBSERVACIONNECESIDAD nvarchar(1000),
		@ACCIONCOMPROMISO nvarchar(1000)		
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	DECLARE  @IDENTIDAD INT

	declare @id int	
	
	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)

	select @id = r.ID from [PAT].[RespuestaPAT] as r
	where r.IdPreguntaPAT = @IDPREGUNTA AND  r.IdMunicipio = @IDENTIDAD
	order by r.ID
	if (@id is not null)
	begin
		set @esValido = 0
		set @respuesta += 'La respuesta ya se encuentra ingresada.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
		
		INSERT INTO [PAT].[RespuestaPAT]
		([IdPreguntaPAT]
		,[NECESIDADIDENTIFICADA]
		,[RESPUESTAINDICATIVA]
		,[RESPUESTACOMPROMISO]
		,[PRESUPUESTO]
		,[OBSERVACIONNECESIDAD]
		,[ACCIONCOMPROMISO]
		,[IDUSUARIO]
		,[FECHAINSERCION]
		,[IdMunicipio])
		VALUES
		(@IDPREGUNTA,
		 @NECESIDADIDENTIFICADA, 
		 @RESPUESTAINDICATIVA, 
		 @RESPUESTACOMPROMISO,
		 @PRESUPUESTO, 
		 @OBSERVACIONNECESIDAD,
		 @ACCIONCOMPROMISO,
		 @IDUSUARIO,
		 GETDATE(),
		 @IDENTIDAD)    			
		
			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id



GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaProgramaInsert]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la información del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaProgramaInsert] 
           @ID_PAT_RESPUESTA int,
           @PROGRAMA nvarchar(1000),
           @ACTIVO bit
		AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		
			INSERT INTO [PAT].[RespuestaPATPrograma]
           ([IdRespuestaPAT]
           ,[PROGRAMA]
           ,[ACTIVO])
			VALUES
           (@ID_PAT_RESPUESTA,
            @PROGRAMA, 
            @ACTIVO)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
		


GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaRCInsert]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la información del tablero municipal para Reparacion colectiva												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaRCInsert] 
					@IDUSUARIO int
				   ,@IDENTIDAD  int
				   ,@IDPREGUNTARC smallint
				   ,@ACCION varchar(max)
				   ,@PRESUPUESTO money
AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	
	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY
			INSERT INTO [PAT].[RespuestaPATReparacionColectiva]
				   ([IdPreguntaPATReparacionColectiva]
				   ,[ACCION]
				   ,[PRESUPUESTO]
				   ,[IdUsuario]
				   ,[FechaInsercion]
				   ,[IdMunicipio])
			 VALUES
				   (@IDPREGUNTARC
				   ,@ACCION
				   ,@PRESUPUESTO
				   ,@IDUSUARIO
				   ,GETDATE()
				   ,@IDENTIDAD)


			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id



GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaRRInsert]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la información del tablero municipal para retornos y reubicaciones												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[I_RespuestaRRInsert] 
					@IDUSUARIO int
				   ,@IDPREGUNTARR smallint
				   ,@ACCION varchar(max)
				   ,@PRESUPUESTO money
AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	DECLARE  @IDENTIDAD INT

	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)

	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY
			INSERT INTO [PAT].[RespuestaPATRetornosReubicaciones]
				   ([IdPreguntaPATRetornoReubicacion]
				   ,[ACCION]
				   ,[PRESUPUESTO]
				   ,[IdUsuario]
				   ,[FechaInsercion]
				   ,[IdMunicipio])

			 VALUES
				   (@IDPREGUNTARR
				   ,@ACCION
				   ,@PRESUPUESTO
			  	   ,@IDUSUARIO
				   ,GETDATE()
				   ,@IDENTIDAD)    			



			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id


GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaAccionesRCUpdate]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la información del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaAccionesRCUpdate] 
		@ID int,
		@IDPATRESPUESTA int,
        @ACCION nvarchar(500),
        @ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATAccionReparacionColectiva]
			SET [IdRespuestaPATReparacionColectiva] = @IDPATRESPUESTA
			,[AccionReparacionColectiva] = @ACCION
			,[ACTIVO] = @ACTIVO
			 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado
		
	


GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaAccionesRRUpdate]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la información del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaAccionesRRUpdate] 
		@ID int,
		@IDPATRESPUESTA int,
        @ACCION nvarchar(500),
        @ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATAccionRetornosReubicaciones]
			SET [IdRespuestaPATRetornoReubicacion] = @IDPATRESPUESTA
			,[AccionRetornoReubicacion] = @ACCION
			,[ACTIVO] = @ACTIVO
			 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado
		


GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaAccionesUpdate]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la información del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaAccionesUpdate] 
		@ID int,
		@IDPATRESPUESTA int,
        @ACCION nvarchar(500),
        @ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATAccion]
			SET [IdRespuestaPAT] = @IDPATRESPUESTA
			,[ACCION] = @ACCION
			,[ACTIVO] = @ACTIVO
			 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado
		


GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaDepartamentoRCUpdate]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-27																			  
/Descripcion: Actualiza la información del tablero para Reparacion colectiva												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[U_RespuestaDepartamentoRCUpdate] 
		@Id int,
		@AccionDepartamento nvarchar(1000),
		@PresupuestoDepartamento money
	AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
	declare @idRespuesta int
	select @idRespuesta = r.ID from [PAT].[RespuestaPATDepartamentoReparacionColectiva] as r
	where r.Id =  @Id
		
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
		
		UPDATE [PAT].[RespuestaPATDepartamentoReparacionColectiva]
		SET AccionDepartamento= @AccionDepartamento,PresupuestoDepartamento=@PresupuestoDepartamento
		WHERE  Id = @Id

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end
	select @respuesta as respuesta, @estadoRespuesta as estado
			



GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaDepartamentoRRUpdate]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-27																			  
/Descripcion: Actualiza la información del tablero para Retornos y reubicaciones												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[U_RespuestaDepartamentoRRUpdate] 
		@Id int,
	    @AccionDepartamento nvarchar(1000),
		@PresupuestoDepartamento money
	AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
	declare @idRespuesta int
	select @idRespuesta = r.ID from [PAT].RespuestaPATDepartamentoRetornosReubicaciones as r
	where r.Id =  @Id
		
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY	
			UPDATE [PAT].[RespuestaPATDepartamentoRetornosReubicaciones]
			SET [AccionDepartamento] = @AccionDepartamento ,[PresupuestoDepartamento] = @PresupuestoDepartamento      
			WHERE  Id = @Id

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end
	select @respuesta as respuesta, @estadoRespuesta as estado
			



GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaDepartamentoUpdate]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-17																			  
/Descripcion: Actualiza la información del consolidado muncipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaDepartamentoUpdate] 
		@Id int
		,@IdTablero tinyint
		,@IdPreguntaPAT smallint
		,@RespuestaCompromiso int
		,@Presupuesto money
		,@ObservacionCompromiso nvarchar(1000)
		,@IdMunicipioRespuesta int
		,@IdUsuario int

	AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
	declare @idRespuesta int
	select @idRespuesta = r.ID from [PAT].[RespuestaPATDepartamento] as r
	where r.[IdPreguntaPAT] = @IdPreguntaPAT and Id = @Id
	order by r.ID
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATDepartamento]
			SET [IdTablero] = @IdTablero
			,[IdPreguntaPAT] = @IdPreguntaPAT
			,[RespuestaCompromiso] = @RespuestaCompromiso
			,[Presupuesto] = @Presupuesto
			,[ObservacionCompromiso] = @ObservacionCompromiso
			,[IdMunicipioRespuesta] = @IdMunicipioRespuesta
			,[IdUsuario] = @IdUsuario			
			WHERE  ID = @ID 
		
			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado			


GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaProgramaUpdate]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la información del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaProgramaUpdate] 
		@ID int,
		@ID_PAT_RESPUESTA int,
		@PROGRAMA nvarchar(1000),
		@ACTIVO bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
		BEGIN TRY
			UPDATE [PAT].[RespuestaPATPrograma]
			SET [IdRespuestaPAT] = @ID_PAT_RESPUESTA,
			    [PROGRAMA] = @PROGRAMA,
			    [ACTIVO] = @ACTIVO
			WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado
		


GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaRCUpdate]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la información del tablero para Reparacion colectiva												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaRCUpdate] 
		@ID int,
		@IDPREGUNTARC smallint
		,@ACCION varchar(max)
		,@PRESUPUESTO money
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
	declare @idRespuesta int
	select @idRespuesta = r.ID from [PAT].[RespuestaPATReparacionColectiva] as r
	where r.ID =  @ID
		
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
		
		UPDATE [PAT].[RespuestaPATReparacionColectiva]
		   SET [IdPreguntaPATReparacionColectiva] = @IDPREGUNTARC
			  ,[ACCION] = @ACCION
			  ,[PRESUPUESTO] = @PRESUPUESTO
			  ,[FECHAMODIFICACION]= GETDATE()
		 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado
			


GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaRRUpdate]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la información del tablero para retornos y reubicaciones				 								  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
CREATE PROC [PAT].[U_RespuestaRRUpdate] 
		@ID int
		,@IDPREGUNTARR smallint
		,@ACCION varchar(max)
		,@PRESUPUESTO money
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	
	declare @idRespuesta int
	select @idRespuesta = r.ID from [PAT].[RespuestaPATRetornosReubicaciones] as r
	where r.ID =  @ID
		
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
		
		UPDATE [PAT].[RespuestaPATRetornosReubicaciones]
		   SET [IdPreguntaPATRetornoReubicacion] = @IDPREGUNTARR
			  ,[ACCION] = @ACCION
			  ,[PRESUPUESTO] = @PRESUPUESTO
			  ,[FECHAMODIFICACION]= GETDATE()
		 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado
	


GO
/****** Object:  StoredProcedure [PAT].[U_RespuestaUpdate]    Script Date: 28/07/2017 17:56:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Actualiza la información del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[U_RespuestaUpdate] 
		@ID int,
		@IDPREGUNTA smallint,
		@NECESIDADIDENTIFICADA int,
		@RESPUESTAINDICATIVA int,
		@RESPUESTACOMPROMISO int,
		@PRESUPUESTO money,
		@OBSERVACIONNECESIDAD nvarchar(1000),
		@ACCIONCOMPROMISO nvarchar(1000),
		@IDUSUARIO int		
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	declare @IDMUNICIPIO int
	
	SELECT @IDMUNICIPIO = [PAT].[fn_GetIdEntidad](@IDUSUARIO)

	declare @idRespuesta int
	select @idRespuesta = r.ID from [PAT].[RespuestaPAT] as r
	where r.[IdPreguntaPAT] = @IDPREGUNTA and r.IdMunicipio = @IDMUNICIPIO
	order by r.ID
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY

		UPDATE [PAT].[RespuestaPAT]
		   SET [IdPreguntaPAT] = @IDPREGUNTA
			  ,[NECESIDADIDENTIFICADA] = @NECESIDADIDENTIFICADA
			  ,[RESPUESTAINDICATIVA] = @RESPUESTAINDICATIVA
			  ,[RESPUESTACOMPROMISO] = @RESPUESTACOMPROMISO
			  ,[PRESUPUESTO] = @PRESUPUESTO
			  ,[OBSERVACIONNECESIDAD] = @OBSERVACIONNECESIDAD
			  ,[ACCIONCOMPROMISO] = @ACCIONCOMPROMISO
			  ,[FechaModificacion] = GETDATE()
		 WHERE  ID = @ID 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado			
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_PermisoUsuarioEncuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_PermisoUsuarioEncuestaInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 04/04/2017
-- Description:	Inserta un registro en la tabla Permiso Usuario Encuesta 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[I_PermisoUsuarioEncuestaInsert]
	
	 @IdUsuario			INT
	,@IdEncuesta		INT
	,@FechaFin			DATETIME
	,@UsuarioAutenticado VARCHAR(255)

AS
	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
					BEGIN TRY
						
						--======================================================
						-- Obtiene el ID del usuario que realiza la transacción
						--======================================================
						DECLARE @IdUsuarioTramite INT
						SELECT @IdUsuarioTramite = [Id] FROM [dbo].[Usuario] WHERE [IdUser] = (SELECT [Id] FROM [dbo].[AspNetUsers] WHERE [UserName] = @UsuarioAutenticado)

						DECLARE @FechaFinEncuesta DATETIME
						SELECT @FechaFinEncuesta = FechaFin FROM Encuesta WHERE Id = @IdEncuesta

						IF(@IdUsuarioTramite IS NOT NULL AND LEN(@IdUsuarioTramite) > 0)
							BEGIN
								--============================================================================
								-- SI LA FECHA QUE SE QUIERE COLOCAR ES MENOR A LA FECHA FINAL DE LA ENCUESTA
								--============================================================================
								IF(CAST(@FechaFinEncuesta AS DATE) > CAST(@FechaFin AS DATE))
									BEGIN
										SELECT @respuesta = 'La fecha de fin propuesta, debe ser superior a la fecha de fin (' + CONVERT(VARCHAR, @FechaFinEncuesta, 105) + ') de la encuesta'
									END
								ELSE IF ((SELECT COUNT(*) FROM [dbo].[PermisoUsuarioEncuesta] WHERE [IdUsuario] = @IdUsuario AND [IdEncuesta] = @IdEncuesta) > 0)
									BEGIN
										--==========================================================
										-- OBTIENE LA FECHA QUE TIENE LA ULTIMA EXTENSION DE TIEMPO
										--==========================================================
										SELECT TOP 1 @FechaFinEncuesta = PUE.FechaFin
										FROM PermisoUsuarioEncuesta PUE
										WHERE IdUsuario = @IdUsuario AND IdEncuesta = @IdEncuesta
										ORDER BY PUE.FechaFin DESC

										--===========================================================================
										-- VALIDA QUE LA FECHA PROPUESTA SEA SUPERIOR A LA FECHA DE EXTENSION ACTUAL
										--===========================================================================
										IF(CAST(@FechaFinEncuesta AS DATE) >= CAST(GETDATE() AS DATE))
											BEGIN
												SELECT @respuesta = 'Se encontró una Extensión de Tiempo con fecha vigente (' + CONVERT(VARCHAR, @FechaFinEncuesta, 105) + '). Para extender el plazo, esta fecha debe estar vencida.'
											END

										ELSE IF(CAST(@FechaFinEncuesta AS DATE) < CAST(GETDATE() AS DATE) AND CAST(@FechaFinEncuesta AS DATE) > CAST(@FechaFin AS DATE))
											BEGIN
												SELECT @respuesta = 'La fecha de fin propuesta, debe ser superior a la fecha de extensión de tiempo (' + CONVERT(VARCHAR, @FechaFinEncuesta, 105) + ') de la encuesta'
											END

										ELSE
											BEGIN
												INSERT INTO [dbo].[PermisoUsuarioEncuesta]([IdUsuario],[IdEncuesta],[FechaFin],[IdUsuarioTramite],[FechaTramite])
												SELECT @IdUsuario, @IdEncuesta, @FechaFin, @IdUsuarioTramite, GETDATE()

												SELECT @respuesta = 'El plazo ha sido extendido'
												SELECT @estadoRespuesta = 1
											END
									END
								ELSE
									BEGIN
										INSERT INTO [dbo].[PermisoUsuarioEncuesta]([IdUsuario],[IdEncuesta],[FechaFin],[IdUsuarioTramite],[FechaTramite])
										SELECT @IdUsuario, @IdEncuesta, @FechaFin, @IdUsuarioTramite, GETDATE()

										SELECT @respuesta = 'El plazo ha sido extendido'
										SELECT @estadoRespuesta = 1
									END
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Usuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_Usuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==============================================================================================================
-- Autor : Christian Ospina
-- Fecha : 2017-04-05																			 
-- Descripción: Consulta la información de los usuarios para la rejilla de usuarios de acuerdo a los criterios
--				de filtro. Retira los usuarios que se encuentran retirados y rechazados																 
--==============================================================================================================
ALTER PROC [dbo].[C_Usuario]

	 @Id			INT = NULL
	,@Token			UNIQUEIDENTIFIER = NULL
	,@IdTipoUsuario	INT = NULL
	,@IdDepartamento INT = NULL
	,@IdMunicipio	INT = NULL
	,@UserName		VARCHAR(128) = NULL
	,@IdEstado		INT = NULL

AS
	BEGIN
		SELECT
			 [UserName]
--======================================================================================
-- ORDEN DE LA CONSULTA NECESARIA PARA QUE SE MUESTRE EN ESTE MISMO ORDEN EN LA REJILLA
--=======================================================================================
			,[Nombres]
			,[FechaSolicitud]
			,[Cargo]
			,[TelefonoFijo]
			,[T].[Nombre] TipoUsuario
			,[TelefonoCelular]
			,[Email]
			,[M].[Nombre] Municipio
			,[D].[Nombre] Departamento
			,[DocumentoSolicitud]
--=======================================================================================
			,[U].[Id]
			,[IdUser]
			,[IdTipoUsuario]
			,[U].[IdDepartamento]
			,[U].[IdMunicipio]
			,[U].[IdEstado]
			,[E].[Nombre] Estado
			,[IdUsuarioTramite]			
			,[TelefonoFijoIndicativo]
			,[TelefonoFijoExtension]
			,[EmailAlternativo]
			,[Enviado]
			,[DatosActualizados]
			,[Token]
			,[U].[Activo]
			,[FechaNoRepudio]
			,[FechaTramite]
			,[FechaConfirmacion]	
		FROM 
			[dbo].[Usuario] U
			LEFT JOIN [dbo].[TipoUsuario] T ON [U].[IdTipoUsuario] = [T].[Id]
			LEFT JOIN [dbo].[Estado] E ON [U].[IdEstado] = [E].[Id]	
			LEFT JOIN [dbo].[Departamento] D on [D].[Id] = [U].[IdDepartamento]
			LEFT JOIN [dbo].[Municipio] M on [M].[Id] = [U].[IdMunicipio]
		WHERE 
			(@Id IS NULL OR [U].[Id] = @Id) 
			AND (@Token IS NULL OR [U].[Token] = @Token) 
			AND (@IdTipoUsuario IS NULL OR [U].[IdTipoUsuario] = @IdTipoUsuario) 
			AND (@IdDepartamento IS NULL OR [U].[IdDepartamento]  = @IdDepartamento )
			AND (@IdMunicipio IS NULL OR [U].[IdMunicipio] = @IdMunicipio)
			AND (@UserName IS NULL OR [U].[UserName] = @UserName)
			AND (@IdEstado IS NULL OR [U].[IdEstado] = @IdEstado)
			AND ([U].[IdEstado] <> 6) -- RETIRADO
			AND ([U].[IdEstado] <> 4) -- RECHAZADO
			AND ([U].[IdEstado] <> 1) -- SOLICITADA

		ORDER BY 
			U.Nombres 
	END

go
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_PreguntasPat]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [PAT].[C_PreguntasPat]
GO
-- =============================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	21/07/2017
-- Description:		Obtiene las preguntas del PAT para la rejilla
-- =============================================
create PROCEDURE [PAT].[C_PreguntasPat] 
AS
BEGIN
	SET NOCOUNT ON;	
		SELECT P.Id,
		P.IdDerecho, P.IdComponente, P.IdMedida, 
		M.Descripcion as Medida,
		P.PreguntaIndicativa, 
		UM.Descripcion as UnidadMedida,
		P.PreguntaCompromiso, 
		d.Descripcion as Derecho, 
		C.Descripcion as Componente,
		P.Nivel, 
		P.IdTablero,
		P.Activo,				
		P.IdUnidadMedida, 
		P.ApoyoDepartamental, 
		P.ApoyoEntidadNacional		
		FROM    [PAT].[PreguntaPAT] as P, 
		[PAT].[Derecho] D,
		[PAT].[Componente] C,
		[PAT].[Medida] M,
		[PAT].[UnidadMedida] UM
		WHERE P.IDDERECHO = D.ID 
		AND P.IDCOMPONENTE = C.ID 
		AND P.IDMEDIDA = M.ID 
		AND P.IDUNIDADMEDIDA = UM.ID 	
END
go
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_PreguntaPatInsert]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [PAT].[I_PreguntaPatInsert]
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-29																			  
/Descripcion: Inserta la información del tablero municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[I_PreguntaPatInsert] 
					   @IdDerecho smallint,
					   @IdComponente int,
					   @IdMedida int,
					   @Nivel tinyint,
					   @PreguntaIndicativa nvarchar(500),
					   @IdUnidadMedida tinyint,
					   @PreguntaCompromiso nvarchar(500),
					   @ApoyoDepartamental bit,
					   @ApoyoEntidadNacional bit,
					   @Activo bit,
					   @IdTablero tinyint
			
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY
			INSERT INTO [PAT].[PreguntaPAT]
					   ([IdDerecho]
					   ,[IdComponente]
					   ,[IdMedida]
					   ,[Nivel]
					   ,[PreguntaIndicativa]
					   ,[IdUnidadMedida]
					   ,[PreguntaCompromiso]
					   ,[ApoyoDepartamental]
					   ,[ApoyoEntidadNacional]
					   ,[Activo]
					   ,[IdTablero])
				 VALUES
					   (@IdDerecho ,
					   @IdComponente ,
					   @IdMedida ,
					   @Nivel ,
					   @PreguntaIndicativa ,
					   @IdUnidadMedida ,
					   @PreguntaCompromiso,
					   @ApoyoDepartamental ,
					   @ApoyoEntidadNacional ,
					   @Activo ,
					   @IdTablero )

			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end
	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id

go

if exists (select object_id from sys.all_objects where name ='U_PreguntaPatUpdate')
	DROP PROCEDURE [PAT].[U_PreguntaPatUpdate]
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-29																			  
/Descripcion: Actualiza la información de las preguntas 
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[U_PreguntaPatUpdate] 
		@Id int,
		@IdDerecho smallint,
		@IdComponente int,
		@IdMedida int,
		@Nivel tinyint,
		@PreguntaIndicativa nvarchar(500),
		@IdUnidadMedida tinyint,
		@PreguntaCompromiso nvarchar(500),
		@ApoyoDepartamental bit,
		@ApoyoEntidadNacional bit,
		@Activo bit,
		@IdTablero tinyint
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	declare @idRespuesta int

	select @idRespuesta = r.ID from [PAT].PreguntaPAT as r
	where r.Id = @Id 
	order by r.ID
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY

		UPDATE [PAT].PreguntaPAT
		    SET 
			IdDerecho =@IdDerecho,
			IdComponente =@IdComponente,
			IdMedida =@IdMedida,
			Nivel= @Nivel,
			PreguntaIndicativa =@PreguntaIndicativa,
			IdUnidadMedida =@IdUnidadMedida,
			PreguntaCompromiso= @PreguntaCompromiso,
			ApoyoDepartamental =@ApoyoDepartamental,
			ApoyoEntidadNacional= @ApoyoEntidadNacional,
			Activo= @Activo,
			IdTablero= @IdTablero
			WHERE  ID = @Id 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado			
go
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_PreguntaPatInsert]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [PAT].[I_PreguntaPatInsert]
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-29																			  
/Descripcion: Inserta la información del tablero municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[I_PreguntaPatInsert] 
					   @IdDerecho smallint,
					   @IdComponente int,
					   @IdMedida int,
					   @Nivel tinyint,
					   @PreguntaIndicativa nvarchar(500),
					   @IdUnidadMedida tinyint,
					   @PreguntaCompromiso nvarchar(500),
					   @ApoyoDepartamental bit,
					   @ApoyoEntidadNacional bit,
					   @Activo bit,
					   @IdTablero tinyint
			
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY
			INSERT INTO [PAT].[PreguntaPAT]
					   ([IdDerecho]
					   ,[IdComponente]
					   ,[IdMedida]
					   ,[Nivel]
					   ,[PreguntaIndicativa]
					   ,[IdUnidadMedida]
					   ,[PreguntaCompromiso]
					   ,[ApoyoDepartamental]
					   ,[ApoyoEntidadNacional]
					   ,[Activo]
					   ,[IdTablero])
				 VALUES
					   (@IdDerecho ,
					   @IdComponente ,
					   @IdMedida ,
					   @Nivel ,
					   @PreguntaIndicativa ,
					   @IdUnidadMedida ,
					   @PreguntaCompromiso,
					   @ApoyoDepartamental ,
					   @ApoyoEntidadNacional ,
					   @Activo ,
					   @IdTablero )

			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end
	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id

go

if exists (select object_id from sys.all_objects where name ='U_PreguntaPatUpdate')
	DROP PROCEDURE [PAT].[U_PreguntaPatUpdate]
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-29																			  
/Descripcion: Actualiza la información de las preguntas 
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
create PROC [PAT].[U_PreguntaPatUpdate] 
		@Id int,
		@IdDerecho smallint,
		@IdComponente int,
		@IdMedida int,
		@Nivel tinyint,
		@PreguntaIndicativa nvarchar(500),
		@IdUnidadMedida tinyint,
		@PreguntaCompromiso nvarchar(500),
		@ApoyoDepartamental bit,
		@ApoyoEntidadNacional bit,
		@Activo bit,
		@IdTablero tinyint
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	declare @idRespuesta int

	select @idRespuesta = r.ID from [PAT].PreguntaPAT as r
	where r.Id = @Id 
	order by r.ID
	if (@idRespuesta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY

		UPDATE [PAT].PreguntaPAT
		    SET 
			IdDerecho =@IdDerecho,
			IdComponente =@IdComponente,
			IdMedida =@IdMedida,
			Nivel= @Nivel,
			PreguntaIndicativa =@PreguntaIndicativa,
			IdUnidadMedida =@IdUnidadMedida,
			PreguntaCompromiso= @PreguntaCompromiso,
			ApoyoDepartamental =@ApoyoDepartamental,
			ApoyoEntidadNacional= @ApoyoEntidadNacional,
			Activo= @Activo,
			IdTablero= @IdTablero
			WHERE  ID = @Id 

			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado			

go

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosDerechos]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [PAT].[C_TodosDerechos]
GO
create PROC [PAT].[C_TodosDerechos] 
AS
BEGIN
	SELECT  D.Id, D.Descripcion
	FROM  [PAT].[Derecho] D
	ORDER BY D.Descripcion
END
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosComponentes]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [PAT].[C_TodosComponentes]
GO
create PROC [PAT].[C_TodosComponentes] 
AS
BEGIN
	SELECT  C.Id, C.Descripcion
	FROM  [PAT].Componente as C
	WHERE Activo = 1
	ORDER BY C.Descripcion	
END
GO

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Usuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_Usuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==============================================================================================================
-- Autor : Christian Ospina
-- Fecha : 2017-04-05																			 
-- Descripción: Consulta la información de los usuarios para la rejilla de usuarios de acuerdo a los criterios
--				de filtro. Retira los usuarios que se encuentran retirados y rechazados																 
--==============================================================================================================
ALTER PROC [dbo].[C_Usuario]

	 @Id			INT = NULL
	,@Token			UNIQUEIDENTIFIER = NULL
	,@IdTipoUsuario	INT = NULL
	,@IdDepartamento INT = NULL
	,@IdMunicipio	INT = NULL
	,@UserName		VARCHAR(128) = NULL
	,@IdEstado		INT = NULL

AS
	BEGIN
		SELECT
			 [UserName]
--======================================================================================
-- ORDEN DE LA CONSULTA NECESARIA PARA QUE SE MUESTRE EN ESTE MISMO ORDEN EN LA REJILLA
--=======================================================================================
			,[Nombres]
			,[FechaSolicitud]
			,[Cargo]
			,[TelefonoFijo]
			,[T].[Nombre] TipoUsuario
			,[TelefonoCelular]
			,[Email]
			,[M].[Nombre] Municipio
			,[D].[Nombre] Departamento
			,[DocumentoSolicitud]
--=======================================================================================
			,[U].[Id]
			,[IdUser]
			,[IdTipoUsuario]
			,[U].[IdDepartamento]
			,[U].[IdMunicipio]
			,[U].[IdEstado]
			,[E].[Nombre] Estado
			,[IdUsuarioTramite]			
			,[TelefonoFijoIndicativo]
			,[TelefonoFijoExtension]
			,[EmailAlternativo]
			,[Enviado]
			,[DatosActualizados]
			,[Token]
			,[U].[Activo]
			,[FechaNoRepudio]
			,[FechaTramite]
			,[FechaConfirmacion]	
		FROM 
			[dbo].[Usuario] U
			LEFT JOIN [dbo].[TipoUsuario] T ON [U].[IdTipoUsuario] = [T].[Id]
			LEFT JOIN [dbo].[Estado] E ON [U].[IdEstado] = [E].[Id]	
			LEFT JOIN [dbo].[Departamento] D on [D].[Id] = [U].[IdDepartamento]
			LEFT JOIN [dbo].[Municipio] M on [M].[Id] = [U].[IdMunicipio]
		WHERE 
			(@Id IS NULL OR [U].[Id] = @Id) 
			AND (@Token IS NULL OR [U].[Token] = @Token) 
			AND (@IdTipoUsuario IS NULL OR [U].[IdTipoUsuario] = @IdTipoUsuario) 
			AND (@IdDepartamento IS NULL OR [U].[IdDepartamento]  = @IdDepartamento )
			AND (@IdMunicipio IS NULL OR [U].[IdMunicipio] = @IdMunicipio)
			AND (@UserName IS NULL OR [U].[UserName] = @UserName)
			AND (@IdEstado IS NULL OR [U].[IdEstado] = @IdEstado)
			AND ([U].[IdEstado] <> 6) -- RETIRADO
			AND ([U].[IdEstado] <> 4) -- RECHAZADO
			AND (@Token IS NOT NULL OR [U].[IdEstado] <> 1) -- SOLICITADA

		ORDER BY 
			U.Nombres 
	END


	go

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_EntidadesConRespuestaMunicipal]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [PAT].[C_EntidadesConRespuestaMunicipal]
GO
CREATE PROC [PAT].[C_EntidadesConRespuestaMunicipal]
AS
BEGIN

	SELECT distinct 
	U.UserName as Entidad,
	TU.Nombre as TipoUsuario, 
	D.Nombre as Departamento, M.Nombre as Municipio, A.IdMunicipio    
	FROM PAT.RespuestaPAT AS A
	INNER JOIN dbo.Municipio as M on A.IdMunicipio = M.id
	INNER JOIN dbo.Departamento as D on M.IdDepartamento = D.Id
	JOIN dbo.Usuario as U on A.IdUsuario = U.Id
	JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
	order by 3,1
END





