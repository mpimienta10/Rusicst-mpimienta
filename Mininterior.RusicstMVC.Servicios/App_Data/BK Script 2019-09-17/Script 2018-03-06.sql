ALTER TABLE [PAT].RespuestaPATDepartamento ALTER COLUMN [FechaInsercion] datetime null
go
IF  NOT EXISTS (select 1 from sys.columns where Name = N'FechaModificacion' and Object_ID = Object_ID(N'[PAT].RespuestaPATDepartamento'))
BEGIN
	ALTER TABLE [PAT].RespuestaPATDepartamento ADD  FechaModificacion datetime null
end
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_RespuestaDepartamentoUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_RespuestaDepartamentoUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM			- vilma Rodriguez																	  
/Fecha creacion: 2017-07-17		
/Fecha Modificacion: 2018-03-16																		  
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
			,FechaModificacion = GETDATE()		
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosPlaneacionActivos]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosPlaneacionActivos]  AS'
go
ALTER PROC [PAT].[C_TodosTablerosPlaneacionActivos] 
AS
BEGIN
	select  A.Id,  B.Vigenciainicio, B.VigenciaFin , 	YEAR(B.[VigenciaInicio])+1 AS Planeacion, 'Diligenciamiento Municipios' as Tipo
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=3
	and B.[Activo]=1
	union
	select  A.Id,  B.Vigenciainicio, B.VigenciaFin , 	YEAR(B.[VigenciaInicio])+1 AS Planeacion, 'Diligenciamiento Departamentos' as Tipo
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=2
	and B.[Activo]=1
	order by Tipo
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosMunicipiosPorCompletar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosMunicipiosPorCompletar] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	06//03/2018
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que estan vigentes
-- ==========================================================================================
ALTER PROC [PAT].[C_TodosTablerosMunicipiosPorCompletar] (@IdUsuario INT )
AS
BEGIN
	select  A.Id,  B.Vigenciainicio, B.VigenciaFin , 	YEAR(B.[VigenciaInicio])+1 AS Planeacion
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=3
	and B.[Activo]=1
	and ((GETDATE() between B.Vigenciainicio and B.[VigenciaFin])
	OR EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = B.IdTablero
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()
						and p.IdTipoExtension =3 ) )

END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosMunicipiosCompletos]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosMunicipiosCompletos] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	06//03/2018
-- Description:		Retorna los tableros de nivel 3 que hacen referencia a la gestion MUNICIPAL que ya no estan vigentes
-- ==========================================================================================

ALTER PROC [PAT].[C_TodosTablerosMunicipiosCompletos] (@IdUsuario INT )
AS
BEGIN
	select
	A.[Id],
	B.[VigenciaInicio],
	B.[VigenciaFin], 
	YEAR(B.[VigenciaInicio])+1 AS Planeacion
	from
	[PAT].[Tablero] A,
	[PAT].[TableroFecha] B
	where
	A.[Id]=B.[IdTablero]
	and B.[Nivel]=3
	and B.[Activo]=1
	and (GETDATE() > B.[VigenciaFin] --B.[VigenciaFin] < GETDATE()
	and not EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = B.IdTablero
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()
						and p.IdTipoExtension =3 ) )
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosDepartamentosCompletos]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosDepartamentosCompletos] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	06//03/2018
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental  que ya no estan vigentes
-- ==========================================================================================
ALTER PROC [PAT].[C_TodosTablerosDepartamentosCompletos](@IdUsuario INT )
AS
BEGIN
	select
	A.[Id], B.[VigenciaInicio], B.[VigenciaFin],YEAR(B.[VigenciaInicio])+1 AS Planeacion	
	from
	[PAT].[Tablero] A,
	[PAT].[TableroFecha] B
	where A.[Id]=B.[IdTablero]
	and B.[Nivel]=2
	and B.[Activo]=1
	and  (B.[VigenciaFin] < GETDATE()
	and not EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = B.IdTablero
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()
						and p.IdTipoExtension =3 ) )
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosDepartamentosPorCompletar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosDepartamentosPorCompletar] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	06//03/2018
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que estan vigentes
-- ==========================================================================================
ALTER PROC [PAT].[C_TodosTablerosDepartamentosPorCompletar](@IdUsuario INT )
AS
BEGIN
	select  A.Id, B.Vigenciainicio, B.VigenciaFin ,YEAR(B.[VigenciaInicio])+1 AS Planeacion	
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=2
	and B.[Activo]=1
	and (GETDATE() >= B.Vigenciainicio and GETDATE() <= B.[VigenciaFin]
	OR EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = B.IdTablero
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()
						and p.IdTipoExtension =3 ) )
END

go