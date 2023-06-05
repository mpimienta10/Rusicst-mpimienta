IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_EntidadesConRespuestaMunicipal]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_EntidadesConRespuestaMunicipal] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/07/2017
-- Modified date:	16/10/2017
-- Description:		Obtiene toda la informacion que tiene diligenciamiento municipal y departamental
-- ==========================================================================================
ALTER PROC [PAT].[C_EntidadesConRespuestaMunicipal]
AS
BEGIN

select  distinct Entidad,TipoUsuario,Departamento,Municipio,IdMunicipio,TipoTipoUsuario  from  (
	SELECT distinct 
	U.UserName as Entidad,
	TU.Nombre as TipoUsuario, 
	D.Nombre as Departamento, M.Nombre as Municipio, A.IdMunicipio   ,TU.Tipo as  TipoTipoUsuario 
	FROM PAT.RespuestaPAT AS A
	INNER JOIN dbo.Municipio as M on A.IdMunicipio = M.id
	INNER JOIN dbo.Departamento as D on A.IdDepartamento = D.Id
	JOIN dbo.Usuario as U on  A.IdUsuario = U.Id--M.Id  = U.IdMunicipio --
	JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
	where (TU.Tipo = 'ALCALDIA')
	union
	SELECT distinct 
	U.UserName as Entidad,
	TU.Nombre as TipoUsuario, 
	D.Nombre as Departamento, M.Nombre as Municipio, U.IdMunicipio ,TU.Tipo as  TipoTipoUsuario
	FROM PAT.RespuestaPAT AS A	
	INNER JOIN dbo.Departamento as D on A.IdDepartamento = D.Id	
	JOIN dbo.Usuario as U on D.Id  = U.IdDepartamento -- A.IdUsuario = U.Id
	JOIN dbo.TipoUsuario as TU on U.IdTipoUsuario = TU.Id
	INNER JOIN dbo.Municipio as M on U.IdMunicipio = M.id
	where (TU.Tipo = 'GOBERNACION')
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
-- Modified date:	16/10/2017
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
			D.Nombre as Departamento, M.Nombre as Municipio, U.IdMunicipio,TU.Tipo as  TipoTipoUsuario
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
			D.Nombre as Departamento, M.Nombre as Municipio, U.IdMunicipio  ,TU.Tipo as  TipoTipoUsuario  
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
------------------despues del despliegue de esta mañana------------------------

IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Consulta Seguimientos' AND IdRecurso = 14)
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON	
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso]) VALUES (64, 'Consultas Seguimiento', '', 14)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END
go
UPDATE SubRecurso set Nombre= 'Diligenciamiento Departamental' where Nombre= 'Gestión Departamental' and IdRecurso = 14
UPDATE SubRecurso set Nombre= 'Diligenciamiento Municipal' where Nombre= 'Gestión Municipal' and IdRecurso = 14
UPDATE SubRecurso set Nombre= 'Consultas Diligenciamiento' where Nombre= 'Consultas Tablero PAT' and IdRecurso = 14
UPDATE SubRecurso set Nombre= 'Consultas Seguimiento' where Nombre= 'Consulta Seguimiento' and IdRecurso = 14
go

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SplitWId]') AND type in (N'TF', N'FN')) 

	DROP FUNCTION [dbo].[SplitWId]
go

CREATE FUNCTION [dbo].[SplitWId] 
( 
    @string NVARCHAR(MAX), 
    @delimiter CHAR(1) 
) 
RETURNS @output TABLE(idrow int identity(1,1), splitdata NVARCHAR(MAX) 
) 
BEGIN 
    DECLARE @start INT, @end INT 
    SELECT @start = 1, @end = CHARINDEX(@delimiter, @string) 
    WHILE @start < LEN(@string) + 1 BEGIN 
        IF @end = 0  
            SET @end = LEN(@string) + 1
       
        INSERT INTO @output (splitdata)  
        VALUES(SUBSTRING(@string, @start, @end - @start)) 
        SET @start = @end + 1 
        SET @end = CHARINDEX(@delimiter, @string, @start)
        
    END 
    RETURN 
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ParseDateRespuesta]') AND type in (N'TF', N'FN')) 
	DROP FUNCTION [dbo].[ParseDateRespuesta]
go

CREATE FUNCTION [dbo].[ParseDateRespuesta]
(
	@fecha VARCHAR(20)
)

returns VARCHAR(20)

AS

BEGIN
	
	DECLARE @Retorno VARCHAR(20)

	SELECT @Retorno = COALESCE(@Retorno + '-', '') + splitdata 
	from dbo.[SplitWId](@fecha, '-') order by idrow desc


	RETURN @Retorno
END

GO

ALTER PROCEDURE [dbo].[C_DibujarPreguntasSeccion] 

	 @IdSeccion	INT
	 ,@IdUsuario INT

AS
BEGIN

if @IdUsuario IS NULL
begin

	SELECT 
		P.[Id]	
		,[IdSeccion]
		,P.[Nombre]
		,[RowIndex]
		,[ColumnIndex]
		,TP.[Nombre] AS TipoPregunta
		,p.[Ayuda]
		,[EsObligatoria]
		,[EsMultiple]
		,[SoloSi]
		,[Texto]
		,'' AS Respuesta
		,S.IdEncuesta
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC
end
else
begin

	SELECT 
		P.[Id]	
		,[IdSeccion]
		,P.[Nombre]
		,[RowIndex]
		,[ColumnIndex]
		,TP.[Nombre] AS TipoPregunta
		,p.[Ayuda]
		,[EsObligatoria]
		,[EsMultiple]
		,[SoloSi]
		,[Texto]
		,CASE WHEN TP.[Nombre] = 'FECHA' THEN dbo.[ParseDateRespuesta](replace(r.Valor, '/', '-')) ELSE r.Valor END  as Respuesta
		,S.IdEncuesta
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
	LEFT OUTER JOIN [dbo].Respuesta r ON r.IdPregunta = p.Id and r.IdUsuario = @IdUsuario
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC

end
END

GO