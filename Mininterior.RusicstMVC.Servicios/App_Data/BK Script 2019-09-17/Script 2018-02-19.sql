IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_IdEntidad]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_IdEntidad] AS'
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Modifica:		Grupo OIM - Andres Bonilla
-- Create date:		16/02/2018
-- Modified date:	20/02/2018
-- Description:		Procedimiento que trae el username en caso de ser un el seguimiento numero 1 del tablero 1
-- Modificacion:	Se cambia el retorno del sp para que sea el username en vez de identidad
-- =============================================
ALTER PROCEDURE [PAT].[C_IdEntidad]	@IdUsuario int
AS
BEGIN
	SET NOCOUNT ON;

	--declare @IdMunicipio int, @IdDepartamento int, @TipoUsuario varchar(100), @IdEntidad int
	--set @IdEntidad = 0

	--select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento , @TipoUsuario = T.Tipo
	--from Usuario as U 
	--join TipoUsuario as T on U.IdTipoUsuario = T.Id
	--where U.Id =@IdUsuario

	--if (@TipoUsuario = 'ALCALDIA')
	--begin
	--	select @IdEntidad = E.Id from [PAT].[Entidad] AS E
	--	JOIN Municipio as M on E.IdMunicipio = M.Id 
	--	where M.Id =   @IdMunicipio and E.Activo = 1
	--end
	--else	
	--begin
	--	select @IdEntidad = E.Id from [PAT].[Entidad] AS E
	--	JOIN Departamento as D on E.IdDepartamento = D.Id 
	--	where D.Id =   @IdDepartamento and E.Activo = 1
	--end
	--select @IdEntidad as IdEntidad

	select username as IdEntidad
	from dbo.Usuario 
	where Id = @IdUsuario
END


