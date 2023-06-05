IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'PreguntaPATReparacionColectiva' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'Activo')
	ALTER TABLE PAT.PreguntaPATReparacionColectiva ADD 	Activo bit NULL
go
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = 'PreguntaPATRetornosReubicaciones' AND TABLE_SCHEMA='PAT' AND COLUMN_NAME = 'Activo')
	ALTER TABLE [PAT].[PreguntaPATRetornosReubicaciones] ADD 	Activo bit NULL
go
update  pat.PreguntaPATReparacionColectiva set Activo = 1
update pat.PreguntaPATRetornosReubicaciones set Activo = 1
update SubRecurso set Nombre='Consulta Preguntas', IdRecurso = 3  where Id = 62
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_PreguntaRRPatInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_PreguntaRRPatInsert] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-10-01																			  
/Descripcion: Inserta la información del tablero municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_PreguntaRRPatInsert] 
				   @Hogares int,
				   @Personas int,
				   @Sector nvarchar(max),
				   @Componente nvarchar(max),
				   @Comunidad nvarchar(max),
				   @Ubicacion nvarchar(max),
				   @MedidaRetornoReubicacion nvarchar(max),
				   @IndicadorRetornoReubicacion nvarchar(max),
				   @EntidadResponsable nvarchar(max),
				   @IdDepartamento int,
				   @IdMunicipio int,
				   @IdTablero tinyint,
				   @Activo bit
			
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY
	
		INSERT INTO [PAT].[PreguntaPATRetornosReubicaciones]
				   ([Hogares]
				   ,[Personas]
				   ,[Sector]
				   ,[Componente]
				   ,[Comunidad]
				   ,[Ubicacion]
				   ,[MedidaRetornoReubicacion]
				   ,[IndicadorRetornoReubicacion]
				   ,[EntidadResponsable]
				   ,[IdDepartamento]
				   ,[IdMunicipio]
				   ,[IdTablero]
				   ,Activo)
			 VALUES
				  (@Hogares ,
				   @Personas ,
				   @Sector ,
				   @Componente ,
				   @Comunidad ,
				   @Ubicacion ,
				   @MedidaRetornoReubicacion ,
				   @IndicadorRetornoReubicacion ,
				   @EntidadResponsable ,
				   @IdDepartamento ,
				   @IdMunicipio ,
				   @IdTablero,
				   @Activo )


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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_PreguntaRCPatInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_PreguntaRCPatInsert] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-10-01																			  
/Descripcion: Inserta la información del tablero municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_PreguntaRCPatInsert] 
					   @IdMedida int,
					   @Sujeto nvarchar(300),
					   @MedidaReparacionColectiva nvarchar(2000),
					   @IdDepartamento int,
					   @IdMunicipio int,
					   @IdTablero tinyint,
					    @Activo bit
			
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY

			INSERT INTO [PAT].[PreguntaPATReparacionColectiva]
					   ([IdMedida]
					   ,[Sujeto]
					   ,[MedidaReparacionColectiva]
					   ,[IdDepartamento]
					   ,[IdMunicipio]
					   ,[IdTablero]
					   ,Activo)
				 VALUES
					   ( @IdMedida ,
					   @Sujeto ,
					   @MedidaReparacionColectiva ,
					   @IdDepartamento ,
					   @IdMunicipio ,
					   @IdTablero,
					   @Activo )



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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_PreguntaRRPatUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_PreguntaRRPatUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM - Vilma Rodriguez																			  
/Fecha creacion: 2017-10-01																			  
/Descripcion: Actualiza la información de las preguntas 
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_PreguntaRRPatUpdate] 
				   @Id int,
				   @Hogares int,
				   @Personas int,
				   @Sector nvarchar(max),
				   @Componente nvarchar(max),
				   @Comunidad nvarchar(max),
				   @Ubicacion nvarchar(max),
				   @MedidaRetornoReubicacion nvarchar(max),
				   @IndicadorRetornoReubicacion nvarchar(max),
				   @EntidadResponsable nvarchar(max),
				   @IdDepartamento int,
				   @IdMunicipio int,
				   @IdTablero tinyint,
				    @Activo bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	declare @idPregunta int

	select @idPregunta = r.ID from [PAT].PreguntaPATRetornosReubicaciones as r
	where r.Id = @Id 
	order by r.ID
	if (@idPregunta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end
	declare @IdTableroActual int
	declare @IdRespuesta int	
	select top 1 @IdRespuesta = Id from [PAT].RespuestaPATAccionRetornosReubicaciones where IdRespuestaPATRetornoReubicacion =@Id  
			
	if (@IdRespuesta >0 )
	begin
		set @esValido = 0
		set @respuesta += 'Ya se se encuentran respuestas asociadas.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
			update [PAT].PreguntaPATRetornosReubicaciones
				   set [Hogares] =@Hogares
				   ,[Personas] =@Personas
				   ,[Sector]=@Sector
				   ,[Componente]=@Componente
				   ,[Comunidad]=@Comunidad
				   ,[Ubicacion]=@Ubicacion
				   ,[MedidaRetornoReubicacion]=@MedidaRetornoReubicacion
				   ,[IndicadorRetornoReubicacion]=@IndicadorRetornoReubicacion
				   ,[EntidadResponsable]=@EntidadResponsable
				   ,[IdDepartamento]=@IdDepartamento
				   ,[IdMunicipio]=	@IdMunicipio
				   ,Activo=@Activo			   							  
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



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_PreguntaRCPatUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_PreguntaRCPatUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM - Vilma Rodriguez																			  
/Fecha creacion: 2017-10-01																			  
/Descripcion: Actualiza la información de las preguntas 
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_PreguntaRCPatUpdate] 
				       @Id int,
				       @IdMedida int,
					   @Sujeto nvarchar(300),
					   @MedidaReparacionColectiva nvarchar(2000),
					   @IdDepartamento int,
					   @IdMunicipio int,
					   @IdTablero tinyint,
					    @Activo bit
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	declare @idPregunta int

	select @idPregunta = r.ID from [PAT].PreguntaPATReparacionColectiva as r
	where r.Id = @Id 
	order by r.ID
	if (@idPregunta is null)
	begin
		set @esValido = 0
		set @respuesta += 'No se encontro la respuesta.\n'
	end
	declare @IdTableroActual int
	declare @IdRespuesta int		
	select top 1 @IdRespuesta = Id from [PAT].RespuestaPATAccionReparacionColectiva where IdRespuestaPATReparacionColectiva =@Id  
			
	if (@IdRespuesta >0 )
	begin
		set @esValido = 0
		set @respuesta += 'Ya se se encuentran respuestas asociadas.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
			update [PAT].[PreguntaPATReparacionColectiva]
				   set [IdMedida]=@IdMedida
					   ,[Sujeto]=@Sujeto
					   ,[MedidaReparacionColectiva]=@MedidaReparacionColectiva
					   ,[IdDepartamento]=@IdDepartamento
					   ,[IdMunicipio]=@IdMunicipio	
					   ,Activo =@Activo				   				     	   							  
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_PreguntasRCPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_PreguntasRCPat] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		01/10/2017
-- Modified date:	01/10/2017
-- Description:		Obtiene las preguntas de reparacion colectiva del PAT para la rejilla
-- =============================================
ALTER PROCEDURE [PAT].[C_PreguntasRCPat] 
			  @IdTablero int 
AS
BEGIN
	SET NOCOUNT ON;	

	select P.Id, P.IdMedida,M.Descripcion as Medida, P.Sujeto, P.MedidaReparacionColectiva, 
	P.IdDepartamento,D.Nombre as Departamento, P.IdMunicipio, Mun.Nombre as Municipio, P.IdTablero, P.Activo  
	from pat.PreguntaPATReparacionColectiva as P
	join PAT.Medida as M on P.IdMedida = M.Id
	join Departamento as D on P.IdDepartamento = D.id
	join Municipio as Mun on P.IdMunicipio  = Mun.Id 
	where P.IdTablero = @IdTablero
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_PreguntasRRPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_PreguntasRRPat] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		01/10/2017
-- Modified date:	01/10/2017
-- Description:		Obtiene las preguntas de reparacion colectiva del PAT para la rejilla
-- =============================================
ALTER PROCEDURE [PAT].[C_PreguntasRRPat] 
			  @IdTablero int 
AS
BEGIN
	SET NOCOUNT ON;	

select P.Id, P.Hogares, P.Personas, P.Sector, P.Componente, P.Comunidad, P.Ubicacion, P.MedidaRetornoReubicacion, P.IndicadorRetornoReubicacion, P.EntidadResponsable,
P.IdDepartamento,D.Nombre as Departamento, P.IdMunicipio, Mun.Nombre as Municipio, P.IdTablero, P.Activo  
from PAT.PreguntaPATRetornosReubicaciones as P
join Departamento as D on P.IdDepartamento = D.id
join Municipio as Mun on P.IdMunicipio  = Mun.Id 
where P.IdTablero = @IdTablero
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ListadoTableros]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ListadoTableros] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		06/10/2017
-- Modified date:	01/11/2017
-- Description:		Procedimiento que trae el listado de tableros 
-- =============================================
ALTER PROCEDURE [PAT].[C_ListadoTableros]	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT Id, VigenciaInicio, VigenciaFin, YEAR(VigenciaInicio)+1  as AnoTablero
	FROM [PAT].Tablero		 
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ListadoTablerosSeguimiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ListadoTablerosSeguimiento] AS'
go

-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		09/10/2017
-- Modified date:	
-- Description:		Procedimiento que trae el listado de tableros 
-- =============================================
ALTER PROCEDURE [PAT].[C_ListadoTablerosSeguimiento]	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT distinct t.Id, t.VigenciaInicio, t.VigenciaFin, YEAR(t.VigenciaInicio)+1  as AnoTablero
	FROM [PAT].Tablero	 as t
	join PAT.TableroFecha as tf on t.Id = tf.IdTablero
	where  getdate() >=tf.Seguimiento1Inicio or 	 getdate() >=tf.Seguimiento2Inicio
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ListadoAdministracionTableros]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ListadoAdministracionTableros] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	28/10/2017
-- Description:		Procedimiento que trae el listado de todos los tableros para su administracion 
-- =============================================
ALTER PROCEDURE [PAT].[C_ListadoAdministracionTableros]	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT tf.Id, tf.IdTablero, YEAR(tf.VigenciaInicio)+1 as anoTablero, tf.Nivel, case when tf.Nivel =1 then 'Nacional'  when tf.Nivel =2 then 'Departamental' else 'Municipal' end as NombreNivel ,
	tf.VigenciaInicio, tf.VigenciaFin, Activo, tf.Seguimiento1Inicio, tf.Seguimiento1Fin, tf.Seguimiento2Inicio, tf.Seguimiento2Fin
	FROM PAT.TableroFecha as tf 	
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_RespuestaDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_RespuestaDelete] AS'
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--====================================================================================================
-- Autor: Equipo de desarrollo OIM - Andres Bonilla																			  
-- Fecha creacion: 2017-10-02																			  
-- Descripcion: elimina un registro de la tabla de respuestas
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--====================================================================================================
ALTER PROC [dbo].[D_RespuestaDelete] 
(
	@IdPregunta INT
	,@IdUsuario INT
)
AS 
	
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF(@esValido = 1) 
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY
				DELETE FROM [dbo].[Respuesta]
					WHERE [IdPregunta] = @IdPregunta
					AND [IdUsuario] = @IdUsuario
		
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

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_RespuestaXIdPreguntaUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_RespuestaXIdPreguntaUsuario] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author: Equipo de desarrollo OIM - Rafael Alba
-- Create date: 25/07/2017
-- Description: Selecciona la respuesta por IdPregunta y Usuario de encuesta
-- ============================================================
ALTER PROCEDURE [dbo].[C_RespuestaXIdPreguntaUsuario] 

@IdPregunta
Int, 
@IdUsuario Int

AS
BEGIN
SET NOCOUNT ON;


DECLARE @TipoPregunta VARCHAR(20)

SELECT @TipoPregunta = TP.Nombre
FROM 
[dbo].[Pregunta] p
INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
WHERE p.Id = @IdPregunta


SELECT [Id]
,[Fecha]
,CASE WHEN @TipoPregunta = 'FECHA' THEN dbo.[ParseDateRespuesta](replace(LEFT(Valor, 10), '/', '-')) ELSE Valor END  as Valor
FROM [dbo].[Respuesta]
WHERE [IdPregunta] = @IdPregunta
AND [IdUsuario] = @IdUsuario 
END


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosSeccionDescarga]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosSeccionDescarga] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Andrés Bonilla
-- Fecha creacion: 2017-10-30
-- Descripcion: Trae los datos de la encuesta a descargar
--=====================================================================================================
ALTER PROC [dbo].[C_DatosSeccionDescarga]
(
	@IdSeccion INT
)

AS

BEGIN

SELECT [Id]
      ,[IdEncuesta]
      ,[Titulo]
      ,[Ayuda]
      ,[SuperSeccion]
      ,[Eliminado]
      ,[OcultaTitulo]
      ,[Estilos]
	  ,[Archivo]
  FROM [dbo].[Seccion]
  where Id = @IdSeccion

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DibujarPreguntasSeccionExcel]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarPreguntasSeccionExcel] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Andrés Bonilla																	 
-- Fecha creacion: 2017-10-30																			 
-- Descripcion: Trae las preguntas y respuestas a dibujar por idseccion e idusuario para descargar excel
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DibujarPreguntasSeccionExcel] --3846, 331

	 @IdSeccion	INT
	 ,@IdUsuario INT

AS
BEGIN

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
		,CASE WHEN TP.[Nombre] = 'FECHA' THEN dbo.[ParseDateRespuesta](replace(LEFT(r.Valor, 10), '/', '-')) ELSE r.Valor END  as Respuesta
		,S.IdEncuesta
		,[dbo].[ObtenerTextoPreguntaClean]([Texto]) AS TextoClean
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
	LEFT OUTER JOIN [dbo].Respuesta r ON r.IdPregunta = p.Id and r.IdUsuario = @IdUsuario
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_PlanMejoramientoEncuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_PlanMejoramientoEncuestaInsert] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*****************************************************************************************************
-- Autor: Andrés Bonilla																			  
-- Fecha creacion: 2017-08-23																			  
-- Descripcion: Inserta la información de una Encuesta asociada a un Plan de Mejoramiento												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
-- ****************************************************************************************************
ALTER PROC [PlanesMejoramiento].[I_PlanMejoramientoEncuestaInsert]
(
	@IdPlan INT
	,@IdEncuesta INT
)

AS

BEGIN

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF (NOT EXISTS(SELECT * FROM [PlanesMejoramiento].[PlanMejoramiento] WHERE IdPlanMejoramiento  = @IdPlan))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Plan de Mejoramiento no existe en el Sistema.'
	END

	IF (EXISTS(SELECT * FROM [PlanesMejoramiento].[PlanMejoramientoEncuesta] WHERE [IdPlanMejoriamiento]  = @IdPlan and [IdEncuesta]= @IdEncuesta))
	BEGIN
		SET @esValido = 0
		
		SELECT @respuesta = 'Se ha asociado la Encuesta al Plan de Mejoramiento.'
		SELECT @estadoRespuesta = 1
	END

	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			
			DELETE FROM [PlanesMejoramiento].[PlanMejoramientoEncuesta]
			WHERE IdPlanMejoriamiento = @IdPlan

			INSERT INTO [PlanesMejoramiento].[PlanMejoramientoEncuesta] ([IdPlanMejoriamiento], [IdEncuesta])		
			VALUES (@IdPlan, @IdEncuesta)

			SELECT @respuesta = 'Se ha asociado la Encuesta al Plan de Mejoramiento.'
			SELECT @estadoRespuesta = 1
	
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


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosPregunta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosPregunta] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--****************************************************************************************************
-- Autor: Vilma Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-14																			 
-- Descripcion: Consulta la informacion de modificar pregunta
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--*****************************************************************************************************
ALTER PROC [dbo].[C_DatosPregunta]

	@Id INT 

AS

	SELECT 
		 a.[Id]
		,a.[Nombre]
		,b.[Nombre] TipoPregunta
		,b.[Id] IdTipoPregunta
		,a.[Ayuda]
		,a.[EsObligatoria]
		,a.[SoloSi]
		,a.[Texto]	
		,a.IdSeccion
	FROM 
		Pregunta a
		INNER JOIN TipoPregunta b ON a.IdTipoPregunta = b.Id
	WHERE 
		a.[Id]= @Id

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[I_GuardarEnvioPlanMejoramientoEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[I_GuardarEnvioPlanMejoramientoEncuesta] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [PlanesMejoramiento].[I_GuardarEnvioPlanMejoramientoEncuesta]
  (
    @IdPlan INT,
	@IdUsuario INT
  )
  
  AS
  
  BEGIN
	
	DECLARE @IdEncuesta INT

	SELECT 
		@IdEncuesta = IdEncuesta
	FROM 
		[PlanesMejoramiento].[PlanMejoramientoEncuesta]
	WHERE 
		IdPlanMejoriamiento = @IdPlan



	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			INSERT INTO [dbo].[Envio] ([IdEncuesta], [IdUsuario], [Fecha])
			VALUES (@IdEncuesta, @IdUsuario, GETDATE())			

			SELECT @respuesta = 'Se ha guardado el Envío de la Encuesta.'
			SELECT @estadoRespuesta = 1
	
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


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PlanesMejoramiento].[C_ObtenerIdPlanEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PlanesMejoramiento].[C_ObtenerIdPlanEncuesta] AS'

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [PlanesMejoramiento].[C_ObtenerIdPlanEncuesta]
(
	@IdEncuesta INT
)

AS

BEGIN

SELECT
A.*
FROM [PlanesMejoramiento].[PlanMejoramiento] A
INNER JOIN [PlanesMejoramiento].[PlanMejoramientoEncuesta] B ON B.IdPlanMejoriamiento = A.IdPlanMejoramiento
WHERE
B.IdEncuesta = @IdEncuesta

END

GO


---------por la tarde-------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosSeguimientoMunicipiosCompletados]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosSeguimientoMunicipiosCompletados] AS'
go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		01/09/2017
-- Modified date:	02/11/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que NO estan activos
-- ==========================================================================================
ALTER PROC  [PAT].[C_TodosTablerosSeguimientoMunicipiosCompletados]
AS
BEGIN
	select A.Id,  B.Vigenciainicio, B.VigenciaFin, year(B.VigenciaInicio)+1 as Ano, Seguimiento1Inicio, Seguimiento1Fin,Seguimiento2Inicio, Seguimiento2Fin 
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=3
	and B.[Activo]=1
	and ( GETDATE() > Seguimiento1Fin)	
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosSeguimientoDepartamentosCompletados]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosSeguimientoDepartamentosCompletados] AS'
go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		01/09/2017
-- Modified date:	02/11/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que NO estan activos
-- ==========================================================================================
ALTER PROC  [PAT].[C_TodosTablerosSeguimientoDepartamentosCompletados]
AS
BEGIN
	select A.Id,  B.Vigenciainicio, B.VigenciaFin, year(B.VigenciaInicio)+1 as Ano, Seguimiento1Inicio, Seguimiento1Fin,Seguimiento2Inicio, Seguimiento2Fin 
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=2
	and B.[Activo]=1
	and ( GETDATE() > Seguimiento1Fin )
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosDepartamentosCompletos]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosDepartamentosCompletos] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	02/11/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental  que ya no estan vigentes
-- ==========================================================================================
ALTER PROC [PAT].[C_TodosTablerosDepartamentosCompletos]
AS
BEGIN
	select
	A.[Id], B.[VigenciaInicio], B.[VigenciaFin]
	from
	[PAT].[Tablero] A,
	[PAT].[TableroFecha] B
	where A.[Id]=B.[IdTablero]
	and B.[Nivel]=2
	and B.[Activo]=1
	and  B.[VigenciaFin] < GETDATE()
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosMunicipiosCompletos]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosMunicipiosCompletos] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	02/11/2017
-- Description:		Retorna los tableros de nivel 3 que hacen referencia a la gestion MUNICIPAL que ya no estan vigentes
-- ==========================================================================================

ALTER PROC [PAT].[C_TodosTablerosMunicipiosCompletos]
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
	and B.[Activo]=1
	and  B.[VigenciaFin] < GETDATE()
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosMunicipiosPorCompletar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosMunicipiosPorCompletar] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	02/11/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que estan vigentes
-- ==========================================================================================
ALTER PROC [PAT].[C_TodosTablerosMunicipiosPorCompletar]
AS
BEGIN
	select  A.Id,  B.Vigenciainicio, B.VigenciaFin 
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=3
	and B.[Activo]=1
	and GETDATE() >= B.Vigenciainicio and GETDATE() <= B.[VigenciaFin]
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TodosTablerosDepartamentosPorCompletar]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TodosTablerosDepartamentosPorCompletar] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	02/11/2017
-- Description:		Retorna los tableros de nivel 2 que hacen referencia a la gestion departamental que estan vigentes
-- ==========================================================================================
ALTER PROC [PAT].[C_TodosTablerosDepartamentosPorCompletar]
AS
BEGIN
	select  A.Id, B.Vigenciainicio, B.VigenciaFin 
	from  [PAT].[Tablero] A, 
	[PAT].[TableroFecha] B
	Where A.Id=B.IdTablero
	and B.Nivel=2
	and B.[Activo]=1
	and GETDATE() >= B.Vigenciainicio and GETDATE() <= B.[VigenciaFin]
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_RetroHistorialTodosInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_RetroHistorialTodosInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 18/09/2017
-- Description:	obtiene la informacion Retroalimentacion de la grafica Nivel x encuesta
-- =============================================
ALTER PROCEDURE [I_RetroHistorialTodosInsert] 
	@Encuesta			INT, --30
	@IdPregunta			VARCHAR(8), --10007189
	@Nombre				VARCHAR(8)

AS

DECLARE @respuesta AS NVARCHAR(2000) = ''    
DECLARE @estadoRespuesta  AS INT = 0   


IF EXISTS (select 1 from RetroHistorialRusicst where IdEncuesta = @Encuesta) 
BEGIN
	SELECT @respuesta = 'Ya existe un historial para esta encuesta'    
	SELECT @estadoRespuesta = 0 
END
ELSE
BEGIN

--INSERT INTO [dbo].[RetroHistorialRusicst]
--           ([Usuario], [Periodo], [Guardo], [Completo], [Diligencio], [Adjunto], [Envio], [CodigoPregunta], [IdEncuesta], [Nombre])
--     VALUES
--           ('Admin','nop',0,0,0,0,0, @IdPregunta, @Encuesta, @Nombre)

	DECLARE @Envio TABLE (UserName VARCHAR(50), ENVIO varchar(2) )
	DECLARE @Diligencio TABLE (UserName VARCHAR(50), Diligencio varchar(2) )
	DECLARE @Completo TABLE (UserName VARCHAR(50), Completo varchar(2) )
	DECLARE @Guardo TABLE (UserName VARCHAR(50), Guardo varchar(2) )
	DECLARE @Carta TABLE (UserName VARCHAR(50), Carta varchar(2) )


	DECLARE @TipoEncuesta varchar(20)
	select @TipoEncuesta = Nombre from TipoEncuesta where Id = (select IdTipoEncuesta from Encuesta where id=@Encuesta)

	--ENVIO -- C_ConsultaRetroUsariosEnviaronReporte
	if (@Encuesta<58)
	BEGIN
	INSERT INTO @Envio 
	SELECT Username, [ENVIO] from(
	SELECT usuario.Username, 1 AS [ENVIO]
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  )
					AND (dbo.Usuario.Id IN (SELECT DISTINCT IdUsuario
												  FROM dbo.Envio
												  WHERE (IdEncuesta = @Encuesta)))
	UNION ALL
	SELECT usuario.Username, 0 AS ENVIO
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  )
					AND (dbo.Usuario.Id not IN (SELECT DISTINCT IdUsuario
												  FROM dbo.Envio
												  WHERE (IdEncuesta = @Encuesta)) )                                            
	) as env1                                              
	END
	else
	begin
	INSERT INTO @Envio 
	SELECT Username, [ENVIO] from(
	SELECT usuario.Username, 1 AS [ENVIO]
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  ) 
					AND (dbo.Usuario.Id IN (SELECT DISTINCT PlanesMejoramiento.FinalizacionPlan.IdUsuario
	FROM         PlanesMejoramiento.FinalizacionPlan INNER JOIN
						  PlanesMejoramiento.PlanMejoramiento ON PlanesMejoramiento.FinalizacionPlan.IdPlan = PlanesMejoramiento.PlanMejoramiento.IdPlanMejoramiento INNER JOIN
						  PlanesMejoramiento.PlanMejoramientoEncuesta ON 
						  PlanesMejoramiento.PlanMejoramiento.IdPlanMejoramiento = PlanesMejoramiento.PlanMejoramientoEncuesta.IdPlanMejoriamiento INNER JOIN
						  dbo.Encuesta ON PlanesMejoramiento.PlanMejoramientoEncuesta.IdEncuesta = dbo.Encuesta.Id AND 
						  PlanesMejoramiento.PlanMejoramientoEncuesta.IdEncuesta = dbo.Encuesta.Id
	WHERE     (dbo.Encuesta.Id = @Encuesta))) 

	UNION ALL

	SELECT usuario.Username,0 AS ENVIO
	FROM   dbo.Usuario LEFT OUTER JOIN
		   dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
		   dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  )
			  
				  AND (dbo.Usuario.Id  NOT IN (SELECT DISTINCT PlanesMejoramiento.FinalizacionPlan.IdUsuario
	FROM         PlanesMejoramiento.FinalizacionPlan INNER JOIN
						  PlanesMejoramiento.PlanMejoramiento ON PlanesMejoramiento.FinalizacionPlan.IdPlan = PlanesMejoramiento.PlanMejoramiento.IdPlanMejoramiento INNER JOIN
						  PlanesMejoramiento.PlanMejoramientoEncuesta ON 
						  PlanesMejoramiento.PlanMejoramiento.IdPlanMejoramiento = PlanesMejoramiento.PlanMejoramientoEncuesta.IdPlanMejoriamiento INNER JOIN
						  dbo.Encuesta ON PlanesMejoramiento.PlanMejoramientoEncuesta.IdEncuesta = dbo.Encuesta.Id AND 
						  PlanesMejoramiento.PlanMejoramientoEncuesta.IdEncuesta = dbo.Encuesta.Id
	WHERE     (dbo.Encuesta.Id = @Encuesta))) 
	) env

	end

	--DILIGENCIO  --C_ConsultaRetroUsariosGuardaronInformacionAutoevaluacion
	if @Encuesta<58
	BEGIN
	INSERT INTO @Diligencio
	SELECT Username, [INFORMACION EN AUTOEVALUACION] from(
	SELECT    usuario.Username , 1 AS [INFORMACION EN AUTOEVALUACION]
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11)) 
									  AND (dbo.Usuario.Id 
										  IN (SELECT DISTINCT IdUsuario 
											  FROM dbo.Autoevaluacion2 
											   WHERE (IdEncuesta = @Encuesta)
														AND Recomendacion IS NOT NULL 
														AND LEN(Acciones)>0))
	UNION ALL
	SELECT    usuario.Username, 0 AS  [INFORMACION EN AUTOEVALUACION]
	FROM         dbo.Usuario LEFT OUTER JOIN
						  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
						  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) ) 
									  AND (dbo.Usuario.Id NOT IN (SELECT DISTINCT IdUsuario 
																		 FROM dbo.Autoevaluacion2 
																		 WHERE (IdEncuesta = @Encuesta)
													   AND Recomendacion IS NOT NULL 
													   AND LEN(Acciones)>0))
	) dil1
	END
	else
	begin
	INSERT INTO @Diligencio
	SELECT Username, [INFORMACION EN AUTOEVALUACION] from(
	SELECT    usuario.Username, 1 AS [INFORMACION EN AUTOEVALUACION]
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11))
									  AND (dbo.Usuario.Id 
									  IN (SELECT DISTINCT PlanesMejoramiento.AccionesPlan.IdUsuario
	FROM         PlanesMejoramiento.AccionesPlan INNER JOIN
						  PlanesMejoramiento.Recomendacion ON PlanesMejoramiento.AccionesPlan.IdRecomendacion = PlanesMejoramiento.Recomendacion.IdRecomendacion INNER JOIN
						  dbo.Pregunta ON PlanesMejoramiento.Recomendacion.IdPregunta = dbo.Pregunta.Id INNER JOIN
						  dbo.Seccion ON dbo.Pregunta.IdSeccion = dbo.Seccion.Id AND dbo.Pregunta.IdSeccion = dbo.Seccion.Id
	WHERE     (dbo.Seccion.IdEncuesta = @Encuesta) AND (PlanesMejoramiento.AccionesPlan.Accion IS NOT NULL)))
	UNION ALL
	SELECT    usuario.Username, 0 AS  [INFORMACION EN AUTOEVALUACION]
	FROM      dbo.Usuario LEFT OUTER JOIN
						  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
						  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select substring(@TipoEncuesta,6,11))
									  AND (dbo.Usuario.Id  NOT IN (SELECT DISTINCT PlanesMejoramiento.AccionesPlan.IdUsuario
	FROM         PlanesMejoramiento.AccionesPlan INNER JOIN
						  PlanesMejoramiento.Recomendacion ON PlanesMejoramiento.AccionesPlan.IdRecomendacion = PlanesMejoramiento.Recomendacion.IdRecomendacion INNER JOIN
						  dbo.Pregunta ON PlanesMejoramiento.Recomendacion.IdPregunta = dbo.Pregunta.Id INNER JOIN
						  dbo.Seccion ON dbo.Pregunta.IdSeccion = dbo.Seccion.Id AND dbo.Pregunta.IdSeccion = dbo.Seccion.Id
	WHERE     (dbo.Seccion.IdEncuesta = @Encuesta) AND (PlanesMejoramiento.AccionesPlan.Accion IS NOT NULL)))
	)dil2
	END
	---COMPLETO --C_ConsultaRetroUsuariosPasaronAutoevaluación
	BEGIN
	INSERT INTO @Completo
	SELECT Username, [PASO A AUTOEVALUACION] from(
	SELECT usuario.Username,1 AS [PASO A AUTOEVALUACION]
	FROM dbo.Usuario LEFT OUTER JOIN
	dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
	dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
	dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id

	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  )
	AND (dbo.Usuario.Id IN 
	(select a.IdUsuario from 
	(SELECT   IdUsuario
	FROM Respuesta 
	WHERE IdPregunta IN ((SELECT dbo.Pregunta.Id
	FROM dbo.Seccion INNER JOIN dbo.Pregunta ON dbo.Seccion.Id = dbo.Pregunta.IdSeccion
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta) 
	AND (dbo.Pregunta.EsObligatoria = 1)) )and valor!='-' 
	GROUP BY convert(char,IdUsuario)+'_'+convert(char,IdPregunta), IdUsuario) a
	GROUP BY  IdUsuario
	having (SELECT COUNT (*)
	FROM dbo.Seccion INNER JOIN dbo.Pregunta ON dbo.Seccion.Id = dbo.Pregunta.IdSeccion
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta) 
	AND (dbo.Pregunta.EsObligatoria = 1)) - COUNT(*)<1))

	UNION ALL

	SELECT usuario.Username, 0 AS [PASO A AUTOEVALUACION]
	FROM dbo.Usuario LEFT OUTER JOIN
	dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
	dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
	dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  )
	AND (dbo.Usuario.Id not IN
	(select a.IdUsuario from 
	(SELECT   IdUsuario
	FROM Respuesta 
	WHERE IdPregunta IN ((SELECT dbo.Pregunta.Id
	FROM dbo.Seccion INNER JOIN dbo.Pregunta ON dbo.Seccion.Id = dbo.Pregunta.IdSeccion
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta) 
	AND (dbo.Pregunta.EsObligatoria = 1)) )and valor!='-' 
	GROUP BY convert(char,IdUsuario)+'_'+convert(char,IdPregunta), IdUsuario) a
	GROUP BY  IdUsuario
	having (SELECT COUNT (*)
	FROM dbo.Seccion INNER JOIN dbo.Pregunta ON dbo.Seccion.Id = dbo.Pregunta.IdSeccion
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta) 
	AND (dbo.Pregunta.EsObligatoria = 1)) - COUNT(*)<1))
	) comp
	END

	--GUARDO --C_ConsultaRetroUsuariosGuardaronInformacionSistema
	declare @temp table (IdUser int)
	insert into @temp 
	SELECT DISTINCT dbo.Respuesta.IdUsuario
		FROM dbo.Respuesta INNER JOIN
			dbo.Pregunta ON dbo.Respuesta.IdPregunta = dbo.Pregunta.Id INNER JOIN
			dbo.Seccion ON dbo.Pregunta.IdSeccion = dbo.Seccion.Id INNER JOIN
			dbo.Usuario ON dbo.Respuesta.IdUsuario = dbo.Usuario.Id 
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta)
	
	INSERT INTO @Guardo
	SELECT Username, [GUARDO] from(
	SELECT usuario.Username, 1 AS [GUARDO]
	FROM dbo.Usuario LEFT OUTER JOIN
		dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
		dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
		dbo.TipoUsuario TU ON Usuario.IdTipoUsuario = TU.Id
		WHERE TU.Tipo IN (SELECT substring(@TipoEncuesta,6,11) as tipo)	
		AND dbo.Usuario.Id   IN
	(SELECT DISTINCT dbo.Respuesta.IdUsuario
		FROM dbo.Respuesta INNER JOIN
			dbo.Pregunta ON dbo.Respuesta.IdPregunta = dbo.Pregunta.Id INNER JOIN
			dbo.Seccion ON dbo.Pregunta.IdSeccion = dbo.Seccion.Id INNER JOIN
			dbo.Usuario ON dbo.Respuesta.IdUsuario = dbo.Usuario.Id
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta)) 
	UNION ALL
	
	SELECT usuario.Username, 0 AS [GUARDO]
	FROM dbo.Usuario LEFT OUTER JOIN
		dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
		dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
		dbo.TipoUsuario TU ON Usuario.IdTipoUsuario = TU.Id
		WHERE TU.Tipo IN (SELECT substring(@TipoEncuesta,6,11) as tipo)
		AND dbo.Usuario.Id   NOT IN (select IdUser from @temp)
	) gua

	--CARTA AVAL
	INSERT INTO @Carta
	SELECT Username, CartaAval from(
	SELECT U.UserName,
		 r.Valor
		  ,CAST(CASE r.Valor
			WHEN ISNULL(r.Valor,0) THEN 1
			ELSE 0 END as bit) CartaAval
	  FROM [BancoPreguntas].[Preguntas] P
	  INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
	  INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
	  INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
	  INNER JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @Encuesta
	  LEFT JOIN Respuesta r ON PO.Id = r.IdPregunta --AND r.IdUsuario = @IdUser
	  INNER JOIN Usuario U ON r.IdUsuario = U.Id
	  WHERE CodigoPregunta = @IdPregunta
	  ) car


	INSERT INTO [dbo].[RetroHistorialRusicst]
	SELECT	E.UserName AS Usuario, @Nombre AS Periodo, 
			convert(Bit, G.Guardo) AS Guardo, convert(Bit, C.Completo) AS Completo, convert(Bit, D.Diligencio) AS Diligencio, 
			convert(Bit, E.ENVIO) AS Adjunto, convert(Bit, ISNULL(CA.Carta,0)) AS Envio , @IdPregunta AS CodigoPregunta, 
			@Encuesta IdEncuesta, @Nombre Nombre
	FROM @Diligencio D 
	INNER JOIN @Envio E on D.UserName = E.UserName
	INNER JOIN @Completo C on D.UserName = C.UserName
	INNER JOIN @Guardo G on D.UserName = G.UserName
	LEFT  JOIN @Carta CA on D.UserName = CA.UserName
	ORDER BY E.UserName

	SELECT @respuesta = 'Historial creado con exito'    
	SELECT @estadoRespuesta = 1

END

SELECT @respuesta AS respuesta, @estadoRespuesta AS estado       
--I_RetroHistorialTodosInsert 58, '10035265', 'Gokusin' 





