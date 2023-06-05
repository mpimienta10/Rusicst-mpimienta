IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListaEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaEncuesta] AS'
GO
--****************************************************************************************************
-- Autor: Equipo de desarrollo OIM - Christian Ospina		
-- Modifica:	Equipo de desarrollo OIM - Liliana Rodriguez
-- Fecha creacion: 2017-01-25	
-- Fecha Modificacion: 2018-05-04																		 
-- Descripcion: Consulta la informacion de las encuestas para ser utilizada en combos de encuestas												
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--****************************************************************************************************
ALTER PROC [dbo].[C_ListaEncuesta]

	@IdTipoEncuesta INT = NULL

AS
	IF (@IdTipoEncuesta = NULL)
		SELECT [Id],UPPER([Titulo]) Titulo
		FROM [Encuesta]
		WHERE[IsDeleted] = 'false'AND (@IdTipoEncuesta IS NULL  OR [IdTipoEncuesta] = @IdTipoEncuesta)
		ORDER BY FechaInicio desc
	ELSE
	BEGIN 
		IF (@IdTipoEncuesta = 1)
			SELECT e.Id,UPPER(e.Titulo) Titulo
			FROM [Encuesta] as e
			join Roles.RolEncuesta as re on e.Id = re.IdEncuesta
			join AspNetRoles as r on re.IdRol = r.Id		
			WHERE e.[IsDeleted] = 'false' and r.Name = 'ALCALDIA'
			ORDER BY e.FechaInicio desc
		ELSE
			SELECT e.Id,UPPER(e.Titulo) Titulo
			FROM [Encuesta] as e
			join Roles.RolEncuesta as re on e.Id = re.IdEncuesta
			join AspNetRoles as r on re.IdRol = r.Id		
			WHERE e.[IsDeleted] = 'false' and r.Name <> 'ALCALDIA'
			ORDER BY e.FechaInicio desc
	END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ValidarPermisosGuardado]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ValidarPermisosGuardado] AS'
GO
--****************************************************************************************************
-- Autor:		Equipo de desarrollo OIM - Andrés Bonilla
-- Modifica:	Equipo de desarrollo OIM - Andrés Bonilla																		 																			 
-- Modifica:	Equipo de desarrollo OIM - Liliana Rodriguez	
-- Fecha creacion: 2017-10-26	
-- Fecha Modificacion: 2018-03-08																		 
-- Fecha Modificacion: 2018-05-04																		 
-- Descripcion: Retorna un bit resultado de la validacion de extension de tiempo de un usuario especifico
--				para una encuesta, plan o tablero pat
-- Modificacion: Se modifica para que tenga en cuenta la última hora del día que se extiende el plazo
-- ***************************************************************************************************
ALTER PROC [dbo].[C_ValidarPermisosGuardado]
(
	@idUsuario INT
	,@idEncuesta INT
	,@idTipoExtension INT
)

AS

BEGIN

SET NOCOUNT ON;

	DECLARE @fecha DATETIME
	DECLARE @valido BIT

	SET @fecha = GETDATE()
	SET @valido = 0

	if(@idTipoExtension in (3,4,5))
	begin
		SELECT 
			@valido = 1 
		FROM 
			[dbo].[PermisoUsuarioEncuesta] 
		WHERE 
			IdUsuario = @idUsuario 
			AND 
				IdEncuesta = @idEncuesta 
			AND
				FechaFin > @fecha
			AND
				IdTipoExtension = @idTipoExtension
	end
	else
	begin
		SELECT 
			@valido = 1 
		FROM 
			[dbo].[PermisoUsuarioEncuesta] 
		WHERE 
			IdUsuario = @idUsuario 
			AND 
				IdEncuesta = @idEncuesta 
			AND
				dateadd(minute, -1, convert(datetime, dateadd(day, 1, convert(date, fechafin)))) > @fecha
			AND
				IdTipoExtension = @idTipoExtension
	end	
	SELECT 	@valido AS UsuarioHabilitado
END

go
	
IF  NOT EXISTS (select 1 from sys.columns where Name = N'ActivoEnvioPATPlaneacion' and Object_ID = Object_ID(N'PAT.TableroFecha'))
begin
	ALTER TABLE PAT.TableroFecha ADD
	ActivoEnvioPATPlaneacion bit NULL,
	ActivoEnvioPATSeguimiento bit NULL
end
GO	
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_TableroPatUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_TableroPatUpdate] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	
/Modifica:	Equipo de desarrollo OIM - Liliana Rodriguez																		  
/Fecha creacion: 2017-10-28																			  
/Fecha Modificacion: 2018-05-04		
/Descripcion: Actualiza la información de las preguntas 
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_TableroPatUpdate]
			  @Id int,
			  @IdTablero int,
			  @Nivel tinyint,
			  @VigenciaInicio smalldatetime,
			  @VigenciaFin smalldatetime,
			  @Activo bit,
			  @Seguimiento1Inicio datetime,
			  @Seguimiento1Fin datetime,
			  @Seguimiento2Inicio datetime,
			  @Seguimiento2Fin datetime,
			  @ActivoEnvioPATPlaneacion bit,
			  @ActivoEnvioPATSeguimiento bit
		AS 	
	SET DATEFORMAT YMD

	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado

	if (@VigenciaInicio <> '')
		set @VigenciaInicio = CAST( convert(char(10),@VigenciaInicio,121)+' 00:00:00' as datetime)
	if (@VigenciaFin <> '')
		set @VigenciaFin = CAST( convert(char(10),@VigenciaFin,121)+' 23:59:00' as datetime)
	if (@Seguimiento1Inicio <> '')
		set @Seguimiento1Inicio = CAST( convert(char(10),@Seguimiento1Inicio,121)+' 00:00:00' as datetime)
	if (@Seguimiento2Inicio <> '')
		set @Seguimiento2Inicio = CAST( convert(char(10),@Seguimiento2Inicio,121)+' 00:00:00' as datetime)
	if (@Seguimiento1Fin <>'')
		set @Seguimiento1Fin = CAST( convert(char(10),@Seguimiento1Fin,121)+' 23:59:00' as datetime)
	if (@Seguimiento2Fin <> '')
		set @Seguimiento2Fin = CAST( convert(char(10),@Seguimiento2Fin,121)+' 23:59:00' as datetime)

	BEGIN TRY		
		UPDATE [PAT].[TableroFecha]
		SET [IdTablero] = @IdTablero 
			,[Nivel] = @Nivel
			,[VigenciaInicio] = @VigenciaInicio
			,[VigenciaFin] = @VigenciaFin
			,[Activo] = @Activo
			,[Seguimiento1Inicio] = @Seguimiento1Inicio
			,[Seguimiento1Fin] = @Seguimiento1Fin
			,[Seguimiento2Inicio] = @Seguimiento2Inicio
			,[Seguimiento2Fin] = @Seguimiento2Fin
			,ActivoEnvioPATPlaneacion =@ActivoEnvioPATPlaneacion
			,ActivoEnvioPATSeguimiento =@ActivoEnvioPATSeguimiento
		WHERE  Id = @id
		--si por lo menos se tiene un nivel activo se debe activar el tablero
		if ((select COUNT(1) from PAT.[TableroFecha] where Activo = 1  and  IdTablero = @IdTablero )>0)
			update PAT.Tablero set Activo = 1 where Id = @IdTablero
		--si todas estan inactivas de debe inactivar el tablero
		if ((select COUNT(1) from PAT.[TableroFecha] where Activo = 0 and  IdTablero = @IdTablero )=3)
			update PAT.Tablero set Activo = @Activo where Id = @IdTablero
		SELECT @respuesta = 'Se ha modificado el registro'
		SELECT @estadoRespuesta = 2
	
	END TRY
	BEGIN CATCH
		SELECT @respuesta = ERROR_MESSAGE()
		SELECT @estadoRespuesta = 0
	END CATCH

	select @respuesta as respuesta, @estadoRespuesta as estado			

	go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ListadoAdministracionTableros]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ListadoAdministracionTableros] AS'
GO
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	04/05/2018
-- Description:		Procedimiento que trae el listado de todos los tableros para su administracion 
-- =============================================
ALTER PROCEDURE [PAT].[C_ListadoAdministracionTableros]	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT tf.Id, tf.IdTablero, YEAR(tf.VigenciaInicio)+1 as anoTablero, tf.Nivel, case when tf.Nivel =1 then 'Nacional'  when tf.Nivel =2 then 'Departamental' else 'Municipal' end as NombreNivel ,
	tf.VigenciaInicio, tf.VigenciaFin, Activo, tf.Seguimiento1Inicio, tf.Seguimiento1Fin, tf.Seguimiento2Inicio, tf.Seguimiento2Fin,
	tf.ActivoEnvioPATPlaneacion, tf.ActivoEnvioPATSeguimiento
	FROM PAT.TableroFecha as tf 	
	order by tf.IdTablero, tf.Nivel desc
END

go