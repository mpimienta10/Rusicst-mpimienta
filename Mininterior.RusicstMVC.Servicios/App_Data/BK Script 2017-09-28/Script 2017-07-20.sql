if exists (select object_id from sys.all_objects where name ='C_TableroFechaActivo')
 drop proc [PAT].C_TableroFechaActivo
go
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
if exists (select object_id from sys.all_objects where name ='C_TodosTablerosMunicipiosPorCompletar')
 drop proc [PAT].C_TodosTablerosMunicipiosPorCompletar
go
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
go
if exists (select object_id from sys.all_objects where name ='C_TodosTablerosDepartamentosCompletos')
 drop proc [PAT].C_TodosTablerosDepartamentosCompletos
go
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
go
if exists (select object_id from sys.all_objects where name ='C_TodosTablerosDepartamentosPorCompletar')
 drop proc [PAT].C_TodosTablerosDepartamentosPorCompletar
go
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
go

if exists (select object_id from sys.all_objects where name ='C_TableroDepartamento')
 drop proc [PAT].C_TableroDepartamento
go
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
	WHERE TABLERO.Id = @idTablero
	AND	P.NIVEL = 2 and P.ACTIVO = 1
END
go
if exists (select object_id from sys.all_objects where name ='C_TableroDepartamentoAvance')
 drop proc [PAT].C_TableroDepartamentoAvance
go
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
-- Description:		Obtiene los totales de necesidades y compromisos departamentales del tablero PAT
-- ==========================================================================================
create PROCEDURE [PAT].[C_TableroDepartamentoAvance] -- 506,2
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
go
if exists (select object_id from sys.all_objects where name ='C_TableroMunicipioTotales')
 drop proc [PAT].C_TableroMunicipioTotales
go
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
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
	DECLARE  @IDENTIDAD INT

	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)

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
					AND D.ID = @IdDerecho'		
	SET @SQL = @SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY P.ID'+ @ORDEN 	
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IDENTIDAD INT,@IdDerecho INT'
		
	PRINT @SQL

	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IDENTIDAD=@IDENTIDAD, @IdDerecho=@IdDerecho
	SELECT * from @RESULTADO
END

go
if exists (select object_id from sys.all_objects where name ='C_ContarTableroMunicipioTotales')
 drop proc [PAT].C_ContarTableroMunicipioTotales

go
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados 
-- ==========================================================================================
create PROCEDURE [PAT].C_ContarTableroMunicipioTotales 
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
							WHERE R1.[IdPreguntaPAT]=P.Id 
						) TOTALNECESIDADES,
						(SELECT SUM(R1.RESPUESTACOMPROMISO) 
							FROM  [PAT].[RespuestaPAT] R1
							WHERE R1.IdPreguntaPAT=P.Id
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

go

-------------------------------------------------------------------------------
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
ALTER TABLE PAT.RespuestaPATDepartamento DROP CONSTRAINT FK_RespuestaPATDepartamento_MunicipioInsercion
GO
ALTER TABLE dbo.Municipio SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'RespuestaPATDepartamento' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'IdUsuario')
ALTER TABLE PAT.RespuestaPATDepartamento ADD IdUsuario int NULL
GO

ALTER TABLE PAT.RespuestaPATDepartamento DROP COLUMN IdMunicipioInsercion
GO
ALTER TABLE PAT.RespuestaPATDepartamento SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

go

UPDATE [PAT].[RespuestaPATDepartamento]  SET [IdMunicipioRespuesta] =E.IdMunicipio 
FROM [PAT].[RespuestaPATDepartamento] as D
JOIN  PAT.Entidad AS E ON D.IdEntidadMunicipio = E.Id 

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

GO
/****** Object:  StoredProcedure [PAT].[C_ConsolidadosMunicipio]    Script Date: 18/07/2017 12:38:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ConsolidadosMunicipio]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ConsolidadosMunicipio] AS' 
END
GO
ALTER PROCEDURE [PAT].[C_ConsolidadosMunicipio]   ( @IdUsuario INT, @idPregunta INT, @idTablero tinyint)--1513,7,1
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE  @IDENTIDAD INT, @NOMBREMUNICIPIO VARCHAR(100)
	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
	SELECT @NOMBREMUNICIPIO = Nombre FROM Municipio WHERE Id = 	@IDENTIDAD	
			
	select D.Descripcion AS DERECHO, 	
	C.Descripcion AS COMPONENTE,
	M.Descripcion AS MEDIDA,
	P.Id AS ID_PREGUNTA,
	P.PreguntaIndicativa,
	@IDENTIDAD AS ID_ENTIDAD,
	RESPUESTA.IdMunicipioRespuesta	AS ID_ENTIDAD_MUNICIPIO,
	@NOMBREMUNICIPIO ENTIDAD,
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
	LEFT OUTER JOIN [PAT].[RespuestaPATDepartamento] AS RESPUESTA ON P.Id = RESPUESTA.IdPreguntaPAT,	
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
	order by 8

END


GO
/****** Object:  StoredProcedure [PAT].[C_ContarTableroMunicipioTotales]    Script Date: 18/07/2017 12:38:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ContarTableroMunicipioTotales]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ContarTableroMunicipioTotales] AS' 
END
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados 
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_ContarTableroMunicipioTotales] 
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
							WHERE R1.[IdPreguntaPAT]=P.Id 
						) TOTALNECESIDADES,
						(SELECT SUM(R1.RESPUESTACOMPROMISO) 
							FROM  [PAT].[RespuestaPAT] R1
							WHERE R1.IdPreguntaPAT=P.Id
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
/****** Object:  StoredProcedure [PAT].[C_TableroDepartamento]    Script Date: 18/07/2017 12:38:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroDepartamento]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroDepartamento] AS' 
END
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT departamental
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroDepartamento] 
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
	WHERE TABLERO.Id = @idTablero
	AND	P.NIVEL = 2 and P.ACTIVO = 1
END

GO
/****** Object:  StoredProcedure [PAT].[C_TableroDepartamentoAvance]    Script Date: 18/07/2017 12:38:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroDepartamentoAvance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroDepartamentoAvance] AS' 
END
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
-- Description:		Obtiene los totales de necesidades y compromisos departamentales del tablero PAT
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroDepartamentoAvance]--  1513,1
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
/****** Object:  StoredProcedure [PAT].[C_TableroFechaActivo]    Script Date: 18/07/2017 12:38:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroFechaActivo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroFechaActivo] AS' 
END
GO

-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		23/09/2016
-- Modified date:	
-- Description:		Procedimiento que valida activación del tablero por fechas
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroFechaActivo]
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
/****** Object:  StoredProcedure [PAT].[C_TableroMunicipioTotales]    Script Date: 18/07/2017 12:38:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroMunicipioTotales]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroMunicipioTotales] AS' 
END
GO
-- ==========================================================================================
-- Author:			Grupo OIM de Ministerio del Interior
-- Create date:		10/07/2017
-- Modified date:	10/07/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados 
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroMunicipioTotales]  
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
	DECLARE  @IDENTIDAD INT

	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)

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
					AND D.ID = @IdDerecho'		
	SET @SQL = @SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY P.ID'--+ @ORDEN 	
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IDENTIDAD INT,@IdDerecho INT'
		
	PRINT @SQL

	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IDENTIDAD=@IDENTIDAD, @IdDerecho=@IdDerecho
	SELECT * from @RESULTADO
END

GO
/****** Object:  StoredProcedure [PAT].[I_RespuestaDepartamentoInsert]    Script Date: 18/07/2017 12:38:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_RespuestaDepartamentoInsert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_RespuestaDepartamentoInsert] AS' 
END
GO

/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-17																			  
/Descripcion: Inserta la información del consolidado municipal
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_RespuestaDepartamentoInsert] 
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
/****** Object:  StoredProcedure [PAT].[U_RespuestaDepartamentoUpdate]    Script Date: 18/07/2017 12:38:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_RespuestaDepartamentoUpdate]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_RespuestaDepartamentoUpdate] AS' 
END
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-17																			  
/Descripcion: Actualiza la información del consolidado muncipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_RespuestaDepartamentoUpdate] 
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
	declare @estadoRespuesta  as int = 0 
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Salida_Departamental]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_Salida_Departamental] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[C_Salida_Departamental] 
(
  @departamento int,
  @encuesta     int
)
AS
BEGIN

	SELECT 
		DISTINCT 
		i.Divipola codigodepartamento,
		i.Nombre nombredepartamento,
		j.Divipola codigomunicipio,
		j.Nombre nombremunicipio,
		e.Id codigoencuesta,
		e.Titulo nombreencuesta,
		f.Valor respuesta,
		a.CodigoPregunta codigopregunta,
		a.NombrePregunta descripcionpregunta
	FROM
		BancoPreguntas.Preguntas a WITH (NOLOCK)
		INNER JOIN BancoPreguntas.PreguntaModeloAnterior b WITH (NOLOCK) ON a.IdPregunta = b.IdPregunta
		INNER JOIN Pregunta c WITH (NOLOCK) ON b.IdPreguntaAnterior = c.Id
		INNER JOIN Seccion d WITH (NOLOCK) ON c.IdSeccion = d.Id
		INNER JOIN Encuesta e WITH (NOLOCK) ON d.IdEncuesta = e.Id
		INNER JOIN Respuesta f WITH (NOLOCK) ON c.Id = f.IdPregunta 
		INNER JOIN Usuario g WITH (NOLOCK) ON f.IdUsuario = g.Id
		INNER JOIN Departamento i WITH (NOLOCK) ON g.IdDepartamento = i.Id
		INNER JOIN Municipio j WITH (NOLOCK) ON g.IdMunicipio = j.Id
	WHERE
		e.Id = @encuesta
		AND i.Id = @departamento
		AND e.IdTipoEncuesta = 3
		
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Salida_Municipal]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_Salida_Municipal] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[C_Salida_Municipal] 
(
  @municipio int,
  @departamento int,
  @encuesta     int
)
AS
BEGIN

	SELECT 
		DISTINCT 
		i.Divipola codigodepartamento,
		i.Nombre nombredepartamento,
		j.Divipola codigomunicipio,
		j.Nombre nombremunicipio,
		e.Id codigoencuesta,
		e.Titulo nombreencuesta,
		(CASE 
			WHEN a.IdTipoPregunta = 8 THEN
			(
				CASE
					WHEN ISNUMERIC(f.Valor) = 1
						THEN f.Valor
					ELSE
						'0'
				END
			)
			ELSE f.Valor
		END) respuesta,
		k.Nombre codigotipopregunta,
		a.CodigoPregunta codigopregunta,
		a.NombrePregunta descripcionpregunta
	FROM
		BancoPreguntas.Preguntas a WITH (NOLOCK)
		INNER JOIN BancoPreguntas.PreguntaModeloAnterior b WITH (NOLOCK) ON a.IdPregunta = b.IdPregunta
		INNER JOIN Pregunta c WITH (NOLOCK) ON b.IdPreguntaAnterior = c.Id
		INNER JOIN Seccion d WITH (NOLOCK) ON c.IdSeccion = d.Id
		INNER JOIN Encuesta e WITH (NOLOCK) ON d.IdEncuesta = e.Id
		INNER JOIN Respuesta f WITH (NOLOCK) ON c.Id = f.IdPregunta 
		INNER JOIN Usuario g WITH (NOLOCK) ON f.IdUsuario = g.Id
		INNER JOIN Departamento i WITH (NOLOCK) ON g.IdDepartamento = i.Id
		INNER JOIN Municipio j WITH (NOLOCK) ON g.IdMunicipio = j.Id
		INNER JOIN TipoPregunta k WITH (NOLOCK) ON a.IdTipoPregunta = k.Id
	WHERE
		e.Id = @encuesta
		AND i.Id = @departamento
		AND j.Id = @municipio
		
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Salida_Gobernacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_Salida_Gobernacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[C_Salida_Gobernacion] 
(
  @departamento int,
  @encuesta     int
)
AS
BEGIN

	SELECT 
		DISTINCT 
		i.Divipola codigodepartamento,
		i.Nombre nombredepartamento,
		e.Id codigoencuesta,
		e.Titulo nombreencuesta,
		(CASE 
			WHEN a.IdTipoPregunta = 8 THEN
			(
				CASE
					WHEN ISNUMERIC(f.Valor) = 1
						THEN f.Valor
					ELSE
						'0'
				END
			)
			ELSE f.Valor
		END) respuesta,
		a.CodigoPregunta codigopregunta,
		a.NombrePregunta descripcionpregunta
	FROM
		BancoPreguntas.Preguntas a WITH (NOLOCK)
		INNER JOIN BancoPreguntas.PreguntaModeloAnterior b WITH (NOLOCK) ON a.IdPregunta = b.IdPregunta
		INNER JOIN Pregunta c WITH (NOLOCK) ON b.IdPreguntaAnterior = c.Id
		INNER JOIN Seccion d WITH (NOLOCK) ON c.IdSeccion = d.Id
		INNER JOIN Encuesta e WITH (NOLOCK) ON d.IdEncuesta = e.Id
		INNER JOIN Respuesta f WITH (NOLOCK) ON c.Id = f.IdPregunta 
		INNER JOIN Usuario g WITH (NOLOCK) ON f.IdUsuario = g.Id
		INNER JOIN Departamento i WITH (NOLOCK) ON g.IdDepartamento = i.Id
		INNER JOIN Municipio j WITH (NOLOCK) ON g.IdMunicipio = j.Id
		INNER JOIN TipoPregunta k WITH (NOLOCK) ON a.IdTipoPregunta = k.Id
	WHERE
		e.Id = @encuesta
		AND i.Id = @departamento
		
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_EncuestaDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_EncuestaDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*****************************************************************************************************
-- Autor: Robinson Moscoso																			  
-- Fecha creacion: 2017-01-25																			  
-- Descripcion: Actualiza la información de la encueta												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- Modifica:  John Betancourt A. OIM				  
-- Descripción: Validar que no tenga datos asociados antes de realizar la eliminación
--*****************************************************************************************************

ALTER PROC [dbo].[D_EncuestaDelete] 

	@Id INT

AS 

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0 
	DECLARE @esValido AS BIT = 1
	
	IF ((SELECT TOP 1 IsDeleted FROM encuesta WHERE id  = @Id)='true')
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'La encuesta ya se encuentra deshabilitada'
	END

	IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @Id)))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'No es posible eliminar el registro. Se encontraron datos asociados.'
	END


	IF(@esValido = 1) BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			UPDATE  Encuesta
			SET  [IsDeleted] = 'true'
			WHERE  [Id] = @Id

			SELECT @respuesta = 'Se ha eliminado el registro'
			SELECT @estadoRespuesta = 3
	
		COMMIT  TRANSACTION
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado






