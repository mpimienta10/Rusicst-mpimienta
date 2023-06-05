IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaInicioSesion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaInicioSesion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Andres Bonilla y John Betancourt A. - OIM
-- Create date: 19-01-2017
-- Description:	Procedimiento que consulta el inicio de sesion de los usuarios
-- =============================================
ALTER PROCEDURE [dbo].[C_ConsultaInicioSesion] 

	@idEncuesta INT

AS
BEGIN
	declare @fechaIni datetime
	declare @fechaFin datetime
	DECLARE @RolEncuesta varchar(100)
	declare @idEvento int

	declare @usuarios table
	(
	username varchar(200)
	)

	declare @usuariosLog table
	(
	Username varchar(200)
	,PrimerFecha datetime
	,UltimaFecha datetime
	,Cantidad int
	)

	select 
	@fechaIni = FechaInicio
	,@fechaFin = FechaFin
	from dbo.Encuesta where Id = @idEncuesta

	Select @RolEncuesta = b.Name
	from [Roles].[RolEncuesta] a
	inner join dbo.AspNetRoles b ON b.Id = a.IdRol
	where a.IdEncuesta = @IdEncuesta

	INSERT INTO @usuarios
	Select c.username
	from [Roles].[RolEncuesta] a
	inner join [dbo].[AspNetUserRoles] b on b.[RoleId] = a.IdRol
	inner join dbo.Usuario c ON c.IdUser = b.[UserId]
	where a.IdEncuesta = @idEncuesta
	AND c.IdTipoUsuario = (CASE @RolEncuesta WHEN 'ALCALDIA' THEN 2 WHEN 'GOBERNACION' THEN 7 END )
	AND c.IdEstado = 5

	select @idEvento = [CategoryID]
	from [rusicst_log].[dbo].[Category]
	where [CategoryName] = 'Inicio Sesión'

	select 
	d.Nombre as Departamento
	,m.Nombre as Municipio
	,u.UserName as Username
	,ISNULL(COUNT(LOG2.Title), 0) as Cantidad
	from 
	dbo.Usuario u 
	left outer join 
	(
	select a.*
	from [rusicst_log].[dbo].[Log] a
	inner join [rusicst_log].[dbo].[CategoryLog] b on b.LogId = a.LogId and b.CategoryId = @idEvento
	where a.Timestamp between @fechaIni and @fechaFin
	) as LOG2 on u.UserName = LOG2.Title
	inner join dbo.Departamento D ON u.IdDepartamento = D.Id
	inner join dbo.Municipio M ON u.IdMunicipio = M.Id
	where 
	u.IdTipoUsuario = (CASE @RolEncuesta WHEN 'ALCALDIA' THEN 2 WHEN 'GOBERNACION' THEN 7 END )
	AND u.IdEstado = 5	
	group by u.UserName, m.Nombre, d.Nombre

END

GO

IF NOT EXISTS (SELECT * FROM [SubRecurso] WHERE Nombre = 'Usuarios Que Iniciaron Sesión' AND idrecurso IN (SELECT Id FROM [Recurso] WHERE Nombre = 'Informes'))
			INSERT INTO [dbo].[SubRecurso] ([Nombre],[Url],[IdRecurso]) VALUES ('Usuarios Que Iniciaron Sesión', null, (SELECT Id FROM [Recurso] WHERE Nombre = 'Informes'))

GO