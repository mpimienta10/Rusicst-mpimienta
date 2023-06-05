GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroAnalisisRecomendacion]')) 
BEGIN
	-- =============================================
	-- Author:		Equipo de desarrollo OIM - John Betancourt
	-- Create date: 1/08/2017
	-- Description:	crear tabla RetroHistorialRusicst
	-- =============================================
	
CREATE TABLE [dbo].RetroAnalisisRecomendacion(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Titulo] varchar(400) NOT NULL,
	[ObjetivoGeneral] varchar(4000) NOT NULL,
	[Recomendacion] varchar(2000) NOT NULL,
	[Accion] varchar(2000) NOT NULL,
	[FechaCumplimiento] datetime NULL,
	[IdEncuesta] int NOT NULL,
	[AccionPermite] int NOT NULL,
	[AccionCumplio] int NOT NULL,
	[Observacion] varchar(2000) NULL,
	[alcaldiaRespuesta] int NOT NULL,
	[Usuario] varchar(100) NOT NULL
 CONSTRAINT [PK_RetroAnalisisRecomendacion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroAnaRecomendacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroAnaRecomendacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 25/09/2017
-- Modify date: 24/03/2018 -- Cambio por las nuevas tablas de plan de mejoramiento
-- Description:	obtiene la informacion de las recomendaciones x encuesta y usuario
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroAnaRecomendacion] 

	@IdEncuesta 				INT,
	@UserName					VARCHAR(50)
AS

DECLARE @IdUser	INT
select @IdUser = id from Usuario where UserName = @UserName

IF NOT EXISTS (select 1 from RetroAnalisisRecomendacion where IdEncuesta = @IdEncuesta AND Usuario = @UserName  )
BEGIN
	insert into RetroAnalisisRecomendacion
	select spm.Titulo, og.ObjetivoGeneral, REPLACE(E.Estrategia, N'/', '/ ') Recomendacion, T.Tarea Accion, tp.FechaFinEjecucion FechaCumplimiento,
	@IdEncuesta as IdEncuesta, 0 as AccionPermite, 0 as AccionCumplio, '' AS Observacion,
	0 AS alcaldiaRespuesta, @UserName AS usuario
	from [PlanesMejoramiento].[TareasPlan] TP
	inner join [PlanesMejoramiento].[Tareas] T on T.IdTarea = TP.IdTarea
	inner join [PlanesMejoramiento].[Estrategias] E on E.IdEstrategia = T.IdEstrategia
	inner join [PlanesMejoramiento].[ObjetivosGenerales] OG on E.IdObjetivoGeneral = OG.IdObjetivoGeneral
	inner join [PlanesMejoramiento].[SeccionPlanMejoramiento] spm on OG.IdSeccionPlan = spm.IdSeccionPlanMejoramiento
	inner join [PlanesMejoramiento].[PlanMejoramiento] pm on pm.IdPlanMejoramiento = spm.IdPlanMejoramiento
	inner join [PlanesMejoramiento].[PlanMejoramientoEncuesta] pme on pm.IdPlanMejoramiento = pme.IdPlanMejoriamiento
	inner join Encuesta En on En.Id = pme.IdEncuesta
	where en.Id = @IdEncuesta AND IdUsuario = @IdUser
	--group by spm.Titulo, og.ObjetivoGeneral, Recomendacion, ac.Accion, ac.FechaCumplimiento
END

Select Id, Titulo, ObjetivoGeneral, Recomendacion, Accion, FechaCumplimiento, AccionPermite, AccionCumplio, Observacion, 
		alcaldiaRespuesta, usuario
		FROM RetroAnalisisRecomendacion
		where IdEncuesta = @IdEncuesta AND Usuario = @UserName

GO
-------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------pat-------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------
------------------------actualizo con la informacion que se tenia de seguimiento 1---------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
---update de datos de seguimiento 2 en la tabla de Seguimiento con base en la de SeguimientoGobernacion
update pat.Seguimiento set CantidadSegundo = SG.CantidadSegundo, PresupuestoSegundo = SG.PresupuestoSegundo, ObservacionesSegundo = SG.ObservacionesSegundo, NombreAdjuntoSegundo = SG.NombreAdjuntoSegundo, FechaSeguimientoSegundo = SG.FechaSeguimientoSegundo, FechaUltimaModificacion = SG.FechaUltimaModificacion, FechaUltimaModificacionSegundo	 = SG.FechaUltimaModificacionSegundo
from pat.Seguimiento as S
join pat.PreguntaPAT as P on S.IdPregunta = P.Id
join Usuario as U on S.IdUsuario = U.Id
join pat.SeguimientoGobernacion as SG on  S.IdPregunta = SG.IdPregunta and S.IdUsuario = SG.IdUsuario  and SG.IdUsuarioAlcaldia = 0
where P.IdTablero = 1 and P.Nivel = 2
and U.IdTipoUsuario = 7 and U.Activo = 1 and U.IdEstado = 5
---------insert de los programas que se tenian en SeguimientoGobernacionProgramas a  SeguimientoProgramas
INSERT INTO [PAT].[SeguimientoProgramas]([IdSeguimiento],[Programa],[NumeroSeguimiento])
select S.IdSeguimiento,pro.Programa, pro.NumeroSeguimiento 
from pat.Seguimiento as S
join pat.PreguntaPAT as P on S.IdPregunta = P.Id
join Usuario as U on S.IdUsuario = U.Id
join pat.SeguimientoGobernacion as SG on  S.IdPregunta = SG.IdPregunta and S.IdUsuario = SG.IdUsuario  and SG.IdUsuarioAlcaldia = 0
join pat.SeguimientoGobernacionProgramas as pro on SG.IdSeguimiento = pro.IdSeguimiento
where P.IdTablero = 1 and P.Nivel = 2
and U.IdTipoUsuario = 7 and U.Activo = 1 and U.IdEstado = 5
-------------------------------------------------------------------------------------------------------------------------------------
------------------------inserto la informacion que No tenia de seguimiento 1 pero si tiene seguimiento 2-----------------------------
-------------------------------------correr todo el bloque completo hasta el go------------------------------------------------------
DECLARE @SeguimientosG TABLE ( IdSeguimiento INT) 

insert into @SeguimientosG (IdSeguimiento)
select SG.IdSeguimiento
from  pat.SeguimientoGobernacion as SG 
join pat.PreguntaPAT as P on SG.IdPregunta = P.Id
join Usuario as U on SG.IdUsuario = U.Id
left outer join pat.Seguimiento as S  on SG.IdUsuario = S.IdUsuario and SG.IdPregunta = S.IdPregunta
where P.IdTablero = 1 
and P.Nivel = 2			
and S.IdSeguimiento is null
and SG.IdUsuarioAlcaldia = 0 
and U.IdTipoUsuario = 7 and U.Activo = 1 and U.IdEstado = 5
---------insert en seguimiento
INSERT INTO [PAT].[Seguimiento]([IdTablero],[IdPregunta],[IdUsuario],[FechaSeguimiento],[CantidadPrimer],[PresupuestoPrimer],[CantidadSegundo],[PresupuestoSegundo],[Observaciones],[NombreAdjunto],[ObservacionesSegundo],[NombreAdjuntoSegundo],[FechaSeguimientoSegundo], FechaUltimaModificacion, FechaUltimaModificacionSegundo)
select P.[IdTablero],P.[Id],SG.[IdUsuario],SG.[FechaSeguimiento],SG.[CantidadPrimer],SG.[PresupuestoPrimer],SG.[CantidadSegundo],SG.[PresupuestoSegundo],SG.[Observaciones],SG.[NombreAdjunto],SG.[ObservacionesSegundo],SG.[NombreAdjuntoSegundo],SG.[FechaSeguimientoSegundo],SG.FechaUltimaModificacion, SG.FechaUltimaModificacionSegundo  
from  pat.SeguimientoGobernacion as SG 
join pat.PreguntaPAT as P on SG.IdPregunta = P.Id
join Usuario as U on SG.IdUsuario = U.Id
left outer join pat.Seguimiento as S  on SG.IdUsuario = S.IdUsuario and SG.IdPregunta = S.IdPregunta
where P.IdTablero = 1 
and P.Nivel = 2			
and S.IdSeguimiento is null
and SG.IdUsuarioAlcaldia = 0 
and U.IdTipoUsuario = 7 and U.Activo = 1 and U.IdEstado = 5
---------insert de los programas 
INSERT INTO [PAT].[SeguimientoProgramas]([IdSeguimiento],[Programa],[NumeroSeguimiento])
select S.IdSeguimiento,pro.Programa, pro.NumeroSeguimiento 
from pat.SeguimientoGobernacion as SG 
join pat.SeguimientoGobernacionProgramas as pro on SG.IdSeguimiento = pro.IdSeguimiento
join pat.PreguntaPAT as P on SG.IdPregunta = P.Id
join Usuario as U on SG.IdUsuario = U.Id
join @SeguimientosG as LL on SG.IdSeguimiento = LL.IdSeguimiento
join pat.Seguimiento as S  on SG.IdUsuario = S.IdUsuario and SG.IdPregunta = S.IdPregunta
where P.IdTablero = 1 
and P.Nivel = 2			
and SG.IdUsuarioAlcaldia = 0 
and U.IdTipoUsuario = 7 and U.Activo = 1 and U.IdEstado = 5

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_SeguimientoMunicipalInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_SeguimientoMunicipalInsert] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Fecha modificacion: 2018-20-02																			  
/Descripcion: Inserta la información del seguimeinto municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_SeguimientoMunicipalInsert]
				@IdTablero tinyint
			   ,@IdPregunta smallint
			   ,@IdUsuario int			   
			   ,@CantidadPrimer bigint
			   ,@PresupuestoPrimer money
			   ,@CantidadSegundo bigint
			   ,@PresupuestoSegundo money
			   ,@Observaciones varchar(max)
			   ,@NombreAdjunto varchar(200)
			   ,@ObservacionesSegundo varchar(max)
			   ,@NombreAdjuntoSegundo varchar(200)
		AS 	

	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	

	-- desde aqui se ingresan los campios para auditoria de fechas
	declare @numSeguimiento int
	declare @date datetime, @FechaSeguimiento datetime, @FechaSeguimientoSegundo datetime, @FechaUltimaModificacion datetime, @FechaUltimaModificacionSegundo datetime
	set @date = getdate()
	select @numSeguimiento = case when (@date between [Seguimiento1Inicio] and [Seguimiento1Fin]) then 1
								  when (@date between [Seguimiento2Inicio] and [Seguimiento2Fin]) then 2 end 	
	from pat.TableroFecha where IdTablero = @IdTablero  and nivel = 3
		
	if (@numSeguimiento = 1)
	begin
		set @FechaSeguimiento = getdate()
		set @FechaSeguimientoSegundo = null
	end
	else
	begin
		set @FechaSeguimientoSegundo = getdate()
		set @FechaSeguimiento = null
	end
	--
	if @ObservacionesSegundo is null
		set @ObservacionesSegundo = ''

	---validar que no se duplique un registro
	declare @idActual int
	select @idActual =IdSeguimiento from PAT.Seguimiento WHERE IdPregunta = @IdPregunta and IdTablero = @IdTablero and IdUsuario = @IdUsuario
	if  (@idActual >0)
	begin	
		UPDATE [PAT].[Seguimiento]
		   SET [CantidadPrimer] = @CantidadPrimer
			  ,[PresupuestoPrimer] = @PresupuestoPrimer
			  ,[CantidadSegundo] = @CantidadSegundo
			  ,[PresupuestoSegundo] = @PresupuestoSegundo
			  ,[Observaciones] = @Observaciones
			  ,[NombreAdjunto] =@NombreAdjunto
			  ,[ObservacionesSegundo] = @ObservacionesSegundo
			  ,[NombreAdjuntoSegundo] = @NombreAdjuntoSegundo
			  ,[FechaSeguimientoSegundo] = @FechaSeguimientoSegundo
			  ,[FechaUltimaModificacion] = @FechaSeguimientoSegundo
			  ,[FechaUltimaModificacionSegundo] = getdate()
		 WHERE IdSeguimiento =@idActual
		 select @id = @idActual
		 SELECT @respuesta = 'Se ha actualizado el registro'
		 SELECT @estadoRespuesta = 1
	end
	else
	begin
		BEGIN TRY				
			INSERT INTO [PAT].[Seguimiento]
				   ([IdTablero]
				   ,[IdPregunta]
				   ,[IdUsuario]
				   ,[FechaSeguimiento]
				   ,[CantidadPrimer]
				   ,[PresupuestoPrimer]
				   ,[CantidadSegundo]
				   ,[PresupuestoSegundo]
				   ,[Observaciones]
				   ,[NombreAdjunto]
				   ,[ObservacionesSegundo]
				   ,[NombreAdjuntoSegundo]
				   ,[FechaSeguimientoSegundo])
			 VALUES
				   (@IdTablero 
				   ,@IdPregunta 
				   ,@IdUsuario 
				   ,@FechaSeguimiento 
				   ,@CantidadPrimer 
				   ,@PresupuestoPrimer 
				   ,@CantidadSegundo 
				   ,@PresupuestoSegundo 
				   ,@Observaciones 
				   ,@NombreAdjunto 
				   ,@ObservacionesSegundo				
				   ,@NombreAdjuntoSegundo
				   ,@FechaSeguimientoSegundo)
		
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDepartamento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez -Vilma rodriguez
-- Create date:		29/08/2017
-- Modified date:	26/03/2018
-- Description:		Obtiene informacion de las preguntas por departamento para el seguimiento de un tablero departamental
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDepartamento] -- [PAT].[C_TableroSeguimientoDepartamento] 4, 375
(	@IdTablero INT ,@IdUsuario INT )
AS
BEGIN		
		DECLARE  @IdDepartamento INT	
		select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

		select distinct
		e.Descripcion as Derecho
		,b.Descripcion as Componente
		,c.Descripcion as Medida
		,a.PreguntaIndicativa
		,d.Descripcion as Unidad
		,a.PreguntaCompromiso
		,ISNULL(f.IdSeguimiento, 0) as IdSeguimiento
		,ISNULL(f.CantidadPrimer, -1) as CompromisoPrimerSemestre
		,ISNULL(f.CantidadSegundo, -1) as CompromisoSegundoSemestre
		,ISNULL(f.CantidadPrimer + REPLACE(f.CantidadSegundo, -1, 0), -1) as CompromisoTotal
		,ISNULL(f.PresupuestoPrimer, -1) as PresupuestoPrimerSemestre
		,ISNULL(f.PresupuestoSegundo, -1) as PresupuestoSegundoSemestre
		,ISNULL(f.PresupuestoPrimer + REPLACE(f.PresupuestoSegundo, -1, 0), -1) as PresupuestoTotal
		,a.Id 
		,a.IdComponente 
		,a.IdDerecho
		,a.IdMedida 
		,a.IdUnidadMedida
		,ISNULL(R.RespuestaCompromiso, 0) AS RespuestaIndicativa
		,ISNULL(R.Presupuesto, 0) AS Presupuesto
		, R.RespuestaIndicativa as NecesidadIdentificada
		from [PAT].PreguntaPAT AS a
		join pat.PreguntaPATDepartamento as PD on a.Id = PD.IdPreguntaPAT and PD.IdDepartamento = @IdDepartamento
		inner join [PAT].Componente b on b.Id = a.IdComponente
		inner join [PAT].[Medida] c on c.Id = a.IdMedida
		inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
		inner join [PAT].Derecho e on e.Id = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT R on R.IdPreguntaPAT = a.ID and R.IdDepartamento= @IdDepartamento
		--LEFT OUTER JOIN [PAT].SeguimientoGobernacion f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
		LEFT OUTER JOIN [PAT].Seguimiento f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
		left outer join Usuario as U on f.IdUsuario = U.Id and U.IdTipoUsuario = 7 and U.Activo = 1 and U.IdEstado = 5
		where a.IdTablero = @IdTablero
		and a.NIVEL = 2
		order by a.Id  asc
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosRespuestaSeguimientoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosRespuestaSeguimientoDepartamento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	26/03/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC  [PAT].[C_DatosRespuestaSeguimientoDepartamento] --[PAT].[C_DatosRespuestaSeguimientoDepartamento] 101, 1013,2
(	@IdPregunta INT, @IdUsuario INT ,@IdTablero INT)
AS 
BEGIN
	declare @IdDepartamento int
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	select TOP 1	
	e.Descripcion as Derecho
	,b.Descripcion as Componente
	,c.Descripcion as Medida
	,a.PreguntaIndicativa 
	,d.Descripcion as Unidad
	,a.PreguntaCompromiso
	,ISNULL(f.IdSeguimiento, 0) as IdSeguimiento
	,ISNULL(f.CantidadPrimer, -1) as CompromisoPrimerSemestre
	,ISNULL(f.CantidadSegundo, -1) as CompromisoSegundoSemestre
	,ISNULL(f.CantidadPrimer + REPLACE(f.CantidadSegundo, -1, 0), -1) as CompromisoTotal
	,ISNULL(f.PresupuestoPrimer, -1) as PresupuestoPrimerSemestre
	,ISNULL(f.PresupuestoSegundo, -1) as PresupuestoSegundoSemestre
	,ISNULL(f.PresupuestoPrimer + REPLACE(f.PresupuestoSegundo, -1, 0), -1) as PresupuestoTotal
	,ISNULL(f.Observaciones, '') as ObservacionesSeguimiento
	,ISNULL(f.NombreAdjunto, '') as AdjuntoSeguimiento
	,R.Id AS IdRespuesta
	,R.IdMunicipio
	,a.IdTablero
		,R.RespuestaCompromiso
	,R.RespuestaIndicativa
	,R.Presupuesto
	,R.ObservacionNecesidad
	,R.NecesidadIdentificada
	,R.AccionCompromiso
	,a.Id AS IdPregunta
	,a.IdComponente
	,a.IdDerecho 
	,a.IdMedida 
	,a.IdUnidadMedida
	,ObservacionesSegundo
	,NombreAdjuntoSegundo
	from [PAT].PreguntaPAT as a
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida as d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on R.IdPreguntaPAT = a.Id and R.IdDepartamento = @IdDepartamento
	--LEFT OUTER JOIN [PAT].SeguimientoGobernacion as f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
	LEFT OUTER JOIN [PAT].Seguimiento as f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
	left outer join Usuario as U on f.IdUsuario = U.Id and U.IdTipoUsuario = 7 and U.Activo = 1 and U.IdEstado = 5
	where a.ID = @IdPregunta
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoGobernaciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoGobernaciones] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		30/08/2017
-- Modified date:	26/03/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental de las preguntas del departamento
-- =============================================
ALTER PROC  [PAT].[C_DatosExcelSeguimientoGobernaciones] --[PAT].[C_DatosExcelSeguimientoGobernaciones]  375, 3
(@IdUsuario INT,@IdTablero INT)
AS
BEGIN

	declare  @IdDepartamento int, @Departamento varchar(150)
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	select @Departamento = Nombre from Departamento where Id = @IdDepartamento
	SELECT IdPregunta,IdAccion,IdPrograma,Derecho,Componente,Medida,Pregunta,PreguntaCompromiso,UnidadNecesidad, RespuestaNecesidad,ObservacionNecesidad,
			RespuestaCompromiso,ObservacionCompromiso,RespuestaPresupuesto,Accion,Programa,CantidadPrimerSeguimientoGobernacion,CantidadSegundoSeguimientoGobernacion,
			PresupuestoPrimerSeguimientoGobernacion,PresupuestoSegundoSeguimientoGobernacion,AvanceCantidadGobernacion,AvancePresupuestoGobernacion,
			ObservacionesSeguimientoGobernacion,ObservacionesSegundoSeguimientoGobernacion,ProgramasPrimeroSeguimientoGobernacion,ProgramasSegundoSeguimientoGobernacion FROM (
		SELECT distinct
		A.Id AS IdPregunta
		,0 AS IdAccion
		,0 AS IdPrograma
		,B.Descripcion AS Derecho
		,C.Descripcion AS Componente
		,D.Descripcion AS Medida
		,A.PreguntaIndicativa AS Pregunta
		,A.PreguntaCompromiso
		,E.Descripcion AS UnidadNecesidad
		,RM.RespuestaIndicativa AS RespuestaNecesidad
		,RM.ObservacionNecesidad
		,RM.RespuestaCompromiso
		,RM.AccionCompromiso AS ObservacionCompromiso
		,RM.Presupuesto AS RespuestaPresupuesto
		--,RMA.Accion
		--,RMP.Programa
		,STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATAccion AS ACCION
		WHERE RM.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Accion				
		,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		WHERE RM.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Programa	

		,SG.CantidadPrimer  AS CantidadPrimerSeguimientoGobernacion
		,REPLACE(SG.CantidadSegundo, -1, 0) AS CantidadSegundoSeguimientoGobernacion
		,SG.PresupuestoPrimer AS PresupuestoPrimerSeguimientoGobernacion
		,REPLACE(SG.PresupuestoSegundo, -1, 0) AS PresupuestoSegundoSeguimientoGobernacion

		,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
		,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
		,SG.Observaciones AS ObservacionesSeguimientoGobernacion
		,SG.ObservacionesSegundo AS ObservacionesSegundoSeguimientoGobernacion

		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoProgramas AS SMP
		WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoProgramas AS SMP
		WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			
		
		FROM [PAT].PreguntaPAT A
		INNER JOIN [PAT].Derecho B ON B.Id = A.IdDerecho
		INNER JOIN [PAT].Componente C ON C.Id = A.IdComponente
		INNER JOIN [PAT].Medida D ON D.Id = A.IdMedida
		INNER JOIN [PAT].UnidadMedida E ON E.Id = A.IdUnidadMedida
		JOIN [PAT].RespuestaPAT RM ON RM.IdPreguntaPAT = A.Id and RM.IdDepartamento =@IdDepartamento	
		--LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA ON RM.Id =RMA.IdRespuestaPAT 
		--LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP ON RM.Id = RMP.IdRespuestaPAT
		--LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  A.ID =SG.IdPregunta  AND SG.IdUsuario = @IdUsuario 
		LEFT OUTER JOIN [PAT].Seguimiento SG ON  A.ID =SG.IdPregunta  AND SG.IdUsuario = @IdUsuario 
		WHERE A.IdTablero = @IdTablero and  A.Activo = 1
		AND A.NIVEL = 2
		) AS A
	ORDER BY A.Derecho ASC, A.IdPregunta ASC
END


go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosDepartamentalesSeguimientoWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosDepartamentalesSeguimientoWebService] AS'
go
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla - Vilma Rodriguez
-- Create date:		10/11/2017
-- Modified date:	26/03/2018
-- Description:		Retorna los datos del seguimiento del tablero PAT Departamental Indicado, por Divipola
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosDepartamentalesSeguimientoWebService] --1, 25
(
	@IdTablero int, 
	@DivipolaDepartamento int
)
AS
BEGIN
	SET NOCOUNT ON;	

		SELECT DISTINCT 
				P.Id AS IdPregunta, 
				P.IdTablero AS IdTablero,					
				R.Id as IdRespuesta,
				@DivipolaDepartamento as DivipolaDepartamento, 
				R.RespuestaIndicativa as RespuestaIndicativa, 
				R.RespuestaCompromiso as RespuestaCompromiso, 
				R.Presupuesto as Presupuesto,
				R.ObservacionNecesidad as ObservacionNecesidad,
				R.AccionCompromiso as AccionCompromiso,

				STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].RespuestaPATAccion AS ACCION
				WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Acciones,	
				
				STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].RespuestaPATPrograma AS PROGRAMA
				WHERE R.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Programas	

				,SM.IdSeguimiento
				,SM.CantidadPrimer AS CantidadSeguimientoPrimerSemestre
				,SM.CantidadSegundo AS CantidadSeguimientoSegundoSemestre
				,SM.PresupuestoPrimer AS PresupuestoSeguimientoPrimerSemestre
				,SM.PresupuestoSegundo AS PresupuestoSeguimientoSegundoSemestre
				,SM.Observaciones AS ObservacionesSeguimiento
				,SM.FechaSeguimiento

				,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].SeguimientoProgramas AS PROGRAMA
				WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento and PROGRAMA.NumeroSeguimiento =1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSeguimiento
				
				--adicionales
				,SM.Observaciones AS ObservacionesSegundoSeguimiento
				,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
				FROM [PAT].SeguimientoGobernacionProgramas AS PROGRAMA
				WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento and PROGRAMA.NumeroSeguimiento =2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimiento
				--, CONVERT(FLOAT, REPLACE(isnull(SM.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(SM.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimiento
				--, CONVERT(FLOAT,  REPLACE(isnull(SM.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(SM.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimiento
				,SM.CantidadPrimer +  SM.CantidadSegundo as CantidadTotalSeguimiento
				,SM.PresupuestoPrimer + SM.PresupuestoSegundo as PresupuestoTotalSeguimiento

			FROM  [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id
			LEFT OUTER JOIN PAT.RespuestaPAT AS R on P.Id = R.IdPreguntaPAT AND R.IdDepartamento = [PAT].[fn_GetIdDepartamento](@DivipolaDepartamento)
			LEFT OUTER JOIN 
			(
				SELECT DISTINCT
				   [IdSeguimiento]
				  ,[IdTablero]
				  ,[IdPregunta]
				  ,[IdUsuario]
				  ,[FechaSeguimiento]
				  ,[CantidadPrimer]
				  ,[PresupuestoPrimer]
				  ,[CantidadSegundo]
				  ,[PresupuestoSegundo]
				  ,[Observaciones]
				  ,USU.IdDepartamento
				  ,USU.IdMunicipio
				  ,SEG.ObservacionesSegundo
			  FROM [PAT].Seguimiento SEG
			  INNER JOIN dbo.Usuario USU ON SEG.IdUsuario = USU.Id and USU.IdTipoUsuario = 7 and USU.Activo = 1 and USU.IdEstado = 5
			  WHERE USU.IdDepartamento = [PAT].[fn_GetIdDepartamento](@DivipolaDepartamento)
			) AS SM ON SM.IdTablero = P.IdTablero AND SM.IdPregunta = P.Id
			WHERE	P.Nivel = 2 
			AND P.IdTablero	= @IdTablero	
			AND P.Activo = 1
			ORDER BY P.ID	
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDepartamentoAvance]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDepartamentoAvance] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	14/11/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDepartamentoAvance]-- [PAT].[C_TableroSeguimientoDepartamentoAvance] 1209, 1
( @IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare  @IdDepartamento int
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

		---TRAE LA INFORMACION DEL LA GESTION DE LA GOBERNACION
		SELECT A.Derecho
		--,CONVERT(INT, ROUND(CASE A.ri WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.ri)) * 100) END, 0)) AS AvanceCompromiso
		--,CONVERT(INT, ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0)) AS AvancePresupuesto
		,ISNULL(CONVERT(INT, CASE WHEN ROUND(CASE A.ri WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.ri)) * 100) END, 0) > 100 THEN 100 ELSE ROUND(CASE A.ri WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.ri)) * 100) END, 0) END),0) AS AvanceCompromiso
		,ISNULL(CONVERT(INT, CASE WHEN ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0) > 100 THEN 100 ELSE ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0) END),0) AS AvancePresupuesto
		FROM (
			SELECT
			'Gestión Gobernación' as Derecho
			,SUM(case when R.RespuestaIndicativa is null then 0 else r.RespuestaIndicativa end) as ri
			,SUM(case when R.Presupuesto is null then 0 else r.Presupuesto end) as pres
			,(SUM(case when C.CantidadPrimer is null or C.CantidadPrimer = -1 then 0 else C.CantidadPrimer end) + SUM(case when C.CantidadSegundo is null or C.CantidadSegundo = -1 then 0 else C.CantidadSegundo end)) as sumc1c2
			,(SUM(case when C.PresupuestoPrimer is null or C.PresupuestoPrimer = -1 then 0 else C.PresupuestoPrimer end) + SUM(case when C.PresupuestoSegundo is null or C.PresupuestoSegundo = -1 then 0 else C.PresupuestoSegundo end)) as sump1p2
			FROM    PAT.PreguntaPAT AS P
			join pat.PreguntaPATDepartamento as PD on P.Id = PD.IdPreguntaPAT and PD.IdDepartamento = @IdDepartamento
			INNER JOIN PAT.Derecho as DERECHO ON P.IdDerecho = DERECHO.Id
			LEFT OUTER JOIN PAT.RespuestaPAT as R ON P.Id = R.IdPreguntaPAT and R.IdDepartamento = @IdDepartamento
			--LEFT OUTER JOIN pat.SeguimientoGobernacion AS C ON C.IdPregunta = P.Id AND C.IdUsuario = @IdUsuario and C.IdUsuarioAlcaldia = 0
			LEFT OUTER JOIN pat.Seguimiento AS C ON C.IdPregunta = P.Id AND C.IdUsuario = @IdUsuario
			LEFT OUTER JOIN Usuario as U on C.IdUsuario = U.Id and  U.IdTipoUsuario = 7 and U.Activo = 1 and U.IdEstado = 5
			WHERE P.IdTablero = @IdTablero 
			AND P.Nivel = 2 
			AND P.Activo= 1		
		UNION ALL
		--TRAE LA GESION DE LA GESTION DE LOS DERECHOS DE LAS PREGUNTAS DE LOS MUNICIPIOS		
			SELECT  
			D.Descripcion as Derecho
			,SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end) as ri
			,SUM(case when R.Presupuesto is null then 0 else r.Presupuesto end) as pres
			,(SUM(case when C.CantidadPrimer is null or C.CantidadPrimer = -1 then 0 else C.CantidadPrimer end) + SUM(case when C.CantidadSegundo is null or C.CantidadSegundo = -1 then 0 else C.CantidadSegundo end)) as sumc1c2
			,(SUM(case when C.PresupuestoPrimer is null or C.PresupuestoPrimer = -1 then 0 else C.PresupuestoPrimer end) + SUM(case when C.PresupuestoSegundo is null or C.PresupuestoSegundo = -1 then 0 else C.PresupuestoSegundo end)) as sump1p2
			FROM    PAT.PreguntaPAT AS P
			join pat.PreguntaPATMunicipio as M on P.Id = M.IdPreguntaPAT 
			join Municipio as u on M.IdMunicipio  = u.Id and u.IdDepartamento =  @IdDepartamento
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id	 
			LEFT OUTER JOIN [PAT].[RespuestaPATDepartamento] as R on P.Id = R.IdPreguntaPAT and R.IdMunicipioRespuesta = m.IdMunicipio AND R.IdUsuario = 	@IdUsuario	
			LEFT OUTER JOIN [PAT].SeguimientoGobernacion as C ON C.IdPregunta = P.ID AND C.IdTablero = @IdTablero AND C.IdUsuario = @IdUsuario --AND C.IdUsuarioAlcaldia = R.IdUsuario
			WHERE	P.NIVEL = 3 
			and P.IdTablero = @IdTablero  
			group by D.Descripcion		
	) AS A
END

go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_EnvioTableroPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_EnvioTableroPat] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez
/Modifica: Equipo OIM	- Andrés Bonilla																	  
/Modifica: Equipo OIM	- vilma rodriguez																	  
/Fecha creacion:     2017-12-11	
/Fecha modificacion :2018-02-14
/Fecha modificacion :2018-03-09
/Fecha modificacion :2018-03-26
/Descripcion: Inserta los datos de envio de los tres tipos de tablero: Planeacion Municipal "PM", Planeacion Departamental "PD"
/, Primer Seguimiento Municpal "SM1", Segundo Seguimiento Municpal "SM2"						  
/, Primer Seguimiento Departamental "SD1", Segundo Seguimiento Departamental "SD2"	
/Modificacion: Se cambia la validación de envío de SM2					  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_EnvioTableroPat] 
		@IdUsuario int,
		@IdTablero tinyint,
		@TipoEnvio varchar(3)
		AS 				
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	

	declare @id int, @IdDepartamento int,@IdMunicipio  int	
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	select @id = r.IdEnvio from [PAT].[EnvioTableroPat] as r
	where  r.IdMunicipio = @IdMunicipio and r.IdDepartamento = @IdDepartamento and TipoEnvio = @TipoEnvio  and r.IdTablero =@IdTablero
	
	--Usuarios que no diligenciaron planeacion pueden enviar SM1 o SM2 sin problemas
	DECLARE @UsuariosSinPlaneacion TABLE
	(         
		IdUsuario INT
	)

	IF @TipoEnvio = 'SM1' OR @TipoEnvio = 'SM2'
	BEGIN
		INSERT INTO @UsuariosSinPlaneacion	
		select 
		distinct a.idusuario
		from pat.RespuestaPAT a
		inner join pat.PreguntaPAT b on a.IdPreguntaPAT = b.Id
		where
		b.IdTablero = @IdTablero
		and b.Activo = 1  
		and b.Nivel = 3
	END
	IF @TipoEnvio = 'SD1' OR @TipoEnvio = 'SD2'
	BEGIN
		INSERT INTO @UsuariosSinPlaneacion	
		select 
		distinct a.idusuario
		from pat.RespuestaPAT a
		inner join pat.PreguntaPAT b on a.IdPreguntaPAT = b.Id
		where
		b.IdTablero = @IdTablero
		and b.Activo = 1
		and b.Nivel = 2
	END
	--if (@id is not null)
	--begin
	--	set @esValido = 0
	--	set @respuesta += 'El tablero ya ha sido enviado con anterioridad.'
	--end
	------------------------------------------------------------------------------
	--validacion de que halla guardado las preguntas del municipio correspondiente	
	------------------------------------------------------------------------------
	declare @guardoPreguntas bit
	declare @guardoPreguntasConsolidado bit
	set @guardoPreguntas = 0
	set @guardoPreguntasConsolidado = 0
	-------------------------------------
	-------MUNICIPIOS--------------------
	-------------------------------------
	if (@TipoEnvio = 'PM')--planeacion municipal
	begin 
		SELECT @guardoPreguntas =CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		FROM (
			SELECT 
			COUNT(P.Id) AS NUM_PREGUNTAS_CONTESTAR, 
			count(R.Id) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
			FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
			join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
			JOIN Municipio AS M ON PM.IdMunicipio = M.Id
			LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >=0 and R.RespuestaIndicativa >=0 and R.NecesidadIdentificada >=0 AND R.Presupuesto >=0
			WHERE	P.NIVEL = 3 --municipios
			AND P.IdTablero = @idTablero
			and P.ACTIVO = 1	
			and M.Id = @IdMunicipio
		) AS T 
	end
	if (@TipoEnvio = 'SM1' )--seguimiento municipal
	begin 
		set @guardoPreguntas = 0
		--SELECT @guardoPreguntas = CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		--FROM (
		--	SELECT 
		--	COUNT(P.Id) AS NUM_PREGUNTAS_CONTESTAR, 
		--	count(SM.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		--	FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
		--	join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
		--	JOIN Municipio AS M ON PM.IdMunicipio = M.Id
		--	LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >=0
		--	LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = P.ID AND SM.IdUsuario = R.IdUsuario and SM.CantidadPrimer >= 0 	
		--	WHERE	P.NIVEL = 3 --municipios
		--	AND P.IdTablero = @idTablero
		--	and P.ACTIVO = 1	
		--	and M.Id = @IdMunicipio
		--) AS T 
	end
	if ( @TipoEnvio= 'SM2')--seguimiento municipal
	begin 
		--SELECT @guardoPreguntas = CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		--FROM (
		--	SELECT 
		--	COUNT(distinct R.Id) AS NUM_PREGUNTAS_CONTESTAR, 
		--	count(distinct SM.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		--	FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
		--	join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
		--	JOIN Municipio AS M ON PM.IdMunicipio = M.Id
		--	JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdMunicipio = R.IdMunicipio and R.RespuestaCompromiso >=0
		--	LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = P.ID AND SM.IdUsuario = R.IdUsuario and SM.CantidadSegundo >= 0 and SM.PresupuestoSegundo >=0	and SM.ObservacionesSegundo is not null
		--	WHERE	P.NIVEL = 3 --municipios
		--	AND P.IdTablero = @idTablero
		--	and P.ACTIVO = 1	
		--	and M.Id = @IdMunicipio
		--) AS T 

		IF NOT EXISTS (Select 1 from @UsuariosSinPlaneacion WHERE IdUsuario = @IdUsuario)
		BEGIN
			--Usuarios que no diligenciaron planeacion pueden enviar SM1 o SM2 sin problemas
			SET @guardoPreguntas = 1
		END
		ELSE
		BEGIN
			
			declare @cantPreguntas int

			select @cantPreguntas = count(a.Id)
			from pat.PreguntaPAT a
			where a.IdTablero = @IdTablero and a.Activo = 1 and a.Nivel = 3

			IF EXISTS (
			select 1
			from pat.PreguntaPAT b 
			left outer join pat.RespuestaPAT a on a.IdPreguntaPAT = b.Id
			inner join dbo.Usuario u on u.Id = a.IdUsuario
			where
			b.IdTablero = @IdTablero
			and b.Activo = 1 and b.Nivel = 3
			and u.Activo = 1 and u.IdEstado = 5 and u.IdTipoUsuario = 2
			and u.Id = @IdUsuario
			group by a.IdUsuario, u.UserName
			having (@cantPreguntas - SUM(case when a.RespuestaCompromiso is null then 0 when a.RespuestaCompromiso = 0 then 0 else 1 end)) = @cantPreguntas
			)
			BEGIN
				--Usuarios que llenaron todo en 0 pueden enviar SM1 y SM2 sin problema
				SET @guardoPreguntas = 1
			END
			ELSE
			BEGIN
				
				DECLARE @CantPreguntasSeguimiento INT

				--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
				DECLARE @PreguntasPlaneacion TABLE
				(
					IdPreguntaPAT INT				
				)

				INSERT INTO @PreguntasPlaneacion
				SELECT a.IdPreguntaPAT
				FROM PAT.RespuestaPAT a
				INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
				WHERE
				b.IdTablero = @IdTablero
				AND a.IdUsuario = @IdUsuario
				AND b.Activo = 1 and b.Nivel = 3
				AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)


				SELECT @CantPreguntasSeguimiento = COUNT(DISTINCT IdPregunta)
				FROM PAT.Seguimiento
				WHERE IdPregunta IN (
					SELECT IdPreguntaPAT
					FROM @PreguntasPlaneacion
				) 
				AND IdUsuario = @IdUsuario
				AND IdTablero = @IdTablero
				AND (CantidadSegundo >= 0 OR PresupuestoSegundo >= 0)
				AND ObservacionesSegundo IS NOT NULL

				SELECT @guardoPreguntas = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimiento THEN 1 ELSE 0 END
				FROM @PreguntasPlaneacion
			END
		END

	end
	-------------------------------------
	-------DEPARTAMENTOS--------------------
	-------------------------------------
	if (@TipoEnvio = 'PD')--planeacion departamental
	begin 
		----PREGUNTAS GOBERNACION
		SELECT @guardoPreguntas =CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		FROM (
			SELECT 
			COUNT(P.Id) AS NUM_PREGUNTAS_CONTESTAR, 
			count(R.Id) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
			FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
			join [PAT].[PreguntaPATDepartamento] as PM on P.Id = PM.IdPreguntaPAT 
			JOIN Departamento AS D ON PM.IdDepartamento = D.Id
			LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON P.ID = R.[IdPreguntaPAT] and PM.IdDepartamento = R.IdDepartamento and R.RespuestaCompromiso >=0 and R.RespuestaIndicativa >=0  AND R.Presupuesto >=0
			WHERE	P.NIVEL = 2 --departamentos
			AND P.IdTablero = @idTablero
			and P.ACTIVO = 1	
			and D.Id = @IdDepartamento
		) AS T 
		----PREGUTNAS CONSOLIDADO ALCALDIAS
		SELECT @guardoPreguntasConsolidado =CASE WHEN NUM_PREGUNTAS_CONTESTAR = NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO THEN 1 ELSE 0 END 
		FROM (
			SELECT 
			COUNT(R.Id) AS NUM_PREGUNTAS_CONTESTAR, --Respuestas alcaldia
			count(DEP.Id) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO --respuestas del departamento
			FROM [PAT].[PreguntaPAT] AS P
			JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT]  and (R.NecesidadIdentificada >0 or R.RespuestaCompromiso >0)
			JOIN Municipio AS MR ON R.IdMunicipio = MR.Id AND MR.IdDepartamento = @IdDepartamento													
			LEFT OUTER JOIN [PAT].RespuestaPATDepartamento DEP ON R.IdPreguntaPAT = DEP.IdPreguntaPAT and R.IdMunicipio = DEP.IdMunicipioRespuesta and DEP.RespuestaCompromiso>=0 and DEP.Presupuesto >=0
			LEFT OUTER JOIN Municipio AS MRDEP ON DEP.IdMunicipioRespuesta = MRDEP.Id AND MRDEP.IdDepartamento = @IdDepartamento																																			
			WHERE  P.IdTablero = @IdTablero 
			and  P.NIVEL = 3 
			and P.ApoyoDepartamental =1
			and R.IdDepartamento= @IdDepartamento
			and P.ACTIVO = 1  			
		) AS T 		
	end
	if (@TipoEnvio = 'SD1' )--seguimiento departamental
	begin 
		set @guardoPreguntas = 0
		--pendiente		
	end
	if ( @TipoEnvio= 'SD2')--seguimiento departamental
	begin 
		-------------------------------------
		----PREGUNTAS GOBERNACION
		-------------------------------------
		IF NOT EXISTS (Select 1 from @UsuariosSinPlaneacion WHERE IdUsuario = @IdUsuario)--deberia llamarse con planeacion
		BEGIN				
			----Usuarios que no diligenciaron planeacion pueden enviar
			SET @guardoPreguntas = 1						
		END
		ELSE
		BEGIN			
			declare @cantPreguntasGob int

			select @cantPreguntasGob = count(a.Id)
			from pat.PreguntaPAT a
			where a.IdTablero = @IdTablero and a.Activo = 1 and a.Nivel = 2

			DECLARE @CantPreguntasSeguimientoGob INT
			--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
			DECLARE @PreguntasPlaneacionGob TABLE (IdPreguntaPAT INT)

			INSERT INTO @PreguntasPlaneacionGob--inserta las preguntas con respuestas  de la planeacion que dio ese usuario con compromiso >0
			SELECT a.IdPreguntaPAT
			FROM PAT.RespuestaPAT a
			INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
			WHERE b.IdTablero = @IdTablero
			AND a.IdUsuario = @IdUsuario
			AND b.Activo = 1 and b.Nivel = 2
			AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)

			SELECT @CantPreguntasSeguimientoGob = COUNT(DISTINCT IdPregunta)
			FROM PAT.Seguimiento as SG
			join @PreguntasPlaneacionGob as PG on SG.IdPregunta = PG.IdPreguntaPAT 
			where SG.IdUsuario = @IdUsuario
			AND SG.IdTablero = @IdTablero
			AND (SG.CantidadSegundo >= 0 or SG.PresupuestoSegundo >= 0)
			AND ObservacionesSegundo IS NOT NULL

			SELECT @guardoPreguntas = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimientoGob THEN 1 ELSE 0 END
			FROM @PreguntasPlaneacionGob	
		end		
		-------------------------------------
		----PREGUNTAS CONSOLIDADO ALCALDIAS	
		-------------------------------------						
		DECLARE @CantPreguntasSeguimientoGobConsolidado INT
		--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
		DECLARE @PreguntasPlaneacionGobConsolidado TABLE (IdPreguntaPAT INT,IdUsuarioAlcaldia int)

		INSERT INTO @PreguntasPlaneacionGobConsolidado--inserta las preguntas con respuestas que dio ese usuario con compromiso >0
		SELECT a.IdPreguntaPAT, a.IdUsuario
		FROM PAT.RespuestaPAT a
		INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
		WHERE	b.IdTablero = @IdTablero
		and a.IdDepartamento= @IdDepartamento
		AND b.Activo = 1 and b.Nivel = 3
		And b.ApoyoDepartamental =1
		AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)

		SELECT @CantPreguntasSeguimientoGobConsolidado = COUNT(IdPregunta)
		FROM PAT.SeguimientoGobernacion as SEG
		join @PreguntasPlaneacionGobConsolidado as PPG on SEG.IdPregunta = PPG.IdPreguntaPAT and SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia				
		WHERE SEG.IdUsuario = @IdUsuario AND SEG.IdUsuarioAlcaldia <> 0 
		AND IdTablero = @IdTablero
		AND (CantidadSegundo >= 0 or PresupuestoSegundo >= 0)
		AND ObservacionesSegundo IS NOT NULL

		SELECT @guardoPreguntasConsolidado = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimientoGobConsolidado THEN 1 ELSE 0 END
		FROM @PreguntasPlaneacionGobConsolidado		
	end
		
	-------validaciones de mensajes de error
	IF @TipoEnvio = 'PM'
	begin
		if (@guardoPreguntas = 0)
		begin
			set @esValido = 0
			IF @TipoEnvio = 'PM' AND @IdTablero < 3
			BEGIN
				set @respuesta += 'El Tablero PAT no se puede enviar ya que es de una vigencia anterior.'
			END
			ELSE
			BEGIN
				set @respuesta += 'El Tablero PAT no se puede enviar ya que aún tiene información pendiente por diligenciar.'
			END		
		end
	end
	IF @TipoEnvio = 'PD' or @TipoEnvio = 'SD1' or @TipoEnvio = 'SD2'
	begin
		if (@guardoPreguntas = 0 and @guardoPreguntasConsolidado = 0)
		begin
			set @esValido = 0
			set @respuesta += 'El Tablero PAT no se puede enviar ya que aún tiene información propia y del consolidado de sus municipios pendiente por diligenciar.'
		end
		if (@guardoPreguntas = 0 and @guardoPreguntasConsolidado = 1)
		begin
			set @esValido = 0
			set @respuesta += 'El Tablero PAT no se puede enviar ya que aún tiene información de las preguntas de la gobernación pendiente por diligenciar.'
		end
		if (@guardoPreguntas = 1 and @guardoPreguntasConsolidado = 0)
		begin
			set @esValido = 0
			set @respuesta += 'El Tablero PAT no se puede enviar ya que aún tiene información del consolidado de sus municipios pendiente por diligenciar.'
		end
		if (@guardoPreguntas = 1 and @guardoPreguntasConsolidado = 1)
		begin
			set @esValido = 1			
		end
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
	
		INSERT INTO [PAT].[EnvioTableroPat]
				   ([IdTablero]
				   ,[IdUsuario]
				   ,[IdMunicipio]
				   ,[IdDepartamento]
				   ,[TipoEnvio]
				   ,[FechaEnvio])
			 VALUES
				   (@IdTablero,@IdUsuario,@IdMunicipio,@IdDepartamento,@TipoEnvio, getdate())
	 			
		
			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado
go
