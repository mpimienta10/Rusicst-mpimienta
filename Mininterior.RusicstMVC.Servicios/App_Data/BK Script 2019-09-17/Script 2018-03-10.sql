IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosSeguimientoDepartamentosCompletados]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosSeguimientoDepartamentosCompletados] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Modifica: John Betancourt OIM
-- Create date:		01/09/2017
-- Modified date:	02/11/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que NO estan activos
-- Modified date:	10/03/2018
-- Description:		Incluir el usuario para la consulta
-- ==========================================================================================
ALTER PROC  [PAT].[C_TodosTablerosSeguimientoDepartamentosCompletados]
(@IdUsuario INT)
AS
BEGIN
	select A.Id,  B.Vigenciainicio, B.VigenciaFin, year(B.VigenciaInicio)+1 as Ano, Seguimiento1Inicio, Seguimiento1Fin,Seguimiento2Inicio, Seguimiento2Fin 
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=2
	and B.[Activo]=1
	and (( GETDATE() > Seguimiento1Fin )
	and not EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = B.IdTablero
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()
						and p.IdTipoExtension in(4,5) ) )
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosSeguimientoDepartamentosPorCompletar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosSeguimientoDepartamentosPorCompletar] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Modifica: John Betancourt OIM
-- Create date:		01/09/2017
-- Modified date:	02/02/2018
-- Description:		Retorna los tableros de nivel 3 que hacen referencia a la seguimiento departamental que estan activos
-- Modified date:	10/03/2018
-- Description:		Incluir el usuario para la consulta
-- ==========================================================================================
ALTER PROC  [PAT].[C_TodosTablerosSeguimientoDepartamentosPorCompletar]
(@IdUsuario INT )
AS
BEGIN
	select A.Id,  B.Vigenciainicio, B.VigenciaFin, year(B.VigenciaInicio)+1 as Ano, Seguimiento1Inicio, Seguimiento1Fin,Seguimiento2Inicio, Seguimiento2Fin 
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.[Activo]=1
	and B.Nivel=2
	and (( GETDATE() between Seguimiento1Inicio and Seguimiento1Fin or  GETDATE() between Seguimiento2Inicio and Seguimiento2Fin)
	OR EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = B.IdTablero
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()
						and p.IdTipoExtension in (4,5) ))	
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosSeguimientoMunicipiosCompletados]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosSeguimientoMunicipiosCompletados] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Modifica: John Betancourt OIM
-- Create date:		01/09/2017
-- Modified date:	02/11/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que NO estan activos
-- Modified date:	10/03/2018
-- Description:		Incluir el usuario para la consulta
-- ==========================================================================================
ALTER PROC  [PAT].[C_TodosTablerosSeguimientoMunicipiosCompletados]
(@IdUsuario INT)
AS
BEGIN
	select A.Id,  B.Vigenciainicio, B.VigenciaFin, year(B.VigenciaInicio)+1 as Ano, Seguimiento1Inicio, Seguimiento1Fin,Seguimiento2Inicio, Seguimiento2Fin 
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=3
	and B.[Activo]=1
	and (( GETDATE() > Seguimiento1Fin)	
	and not EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = B.IdTablero
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()
						and p.IdTipoExtension in (4,5) ) )
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosSeguimientoMunicipiosPorCompletar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosSeguimientoMunicipiosPorCompletar] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Modifica: John Betancourt OIM
-- Create date:		01/09/2017
-- Modified date:	02/02/2018
-- Description:		Retorna los tableros de nivel 3 que hacen referencia a la seguimiento municipal que estan activos
-- Modified date:	10/03/2018
-- Description:		Incluir el usuario para la consulta
-- ==========================================================================================
ALTER PROC  [PAT].[C_TodosTablerosSeguimientoMunicipiosPorCompletar]
(@IdUsuario INT)
AS
BEGIN
	select A.Id,  B.Vigenciainicio, B.VigenciaFin, year(B.VigenciaInicio)+1 as Ano, Seguimiento1Inicio, Seguimiento1Fin,Seguimiento2Inicio, Seguimiento2Fin 
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=3	
	and B.[Activo]=1
	and (( GETDATE() between Seguimiento1Inicio and Seguimiento1Fin or  GETDATE() between Seguimiento2Inicio and Seguimiento2Fin)
		and not EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = B.IdTablero
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()
						and p.IdTipoExtension in(4,5) ) )
END

GO