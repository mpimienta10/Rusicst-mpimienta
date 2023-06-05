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
			SELECT  D.Descripcion as Derecho
			,SUM(case when RD.RespuestaCompromiso is null then 0 else RD.RespuestaCompromiso end) as ri
			,SUM(case when RD.Presupuesto is null then 0 else RD.Presupuesto end) as pres
			,(SUM(case when SG.CantidadPrimer is null or SG.CantidadPrimer = -1 then 0 else SG.CantidadPrimer end) + SUM(case when SG.CantidadSegundo is null or SG.CantidadSegundo = -1 then 0 else SG.CantidadSegundo end)) as sumc1c2
			,(SUM(case when SG.PresupuestoPrimer is null or SG.PresupuestoPrimer = -1 then 0 else SG.PresupuestoPrimer end) + SUM(case when SG.PresupuestoSegundo is null or SG.PresupuestoSegundo = -1 then 0 else SG.PresupuestoSegundo end)) as sump1p2
			FROM    PAT.PreguntaPAT AS P
			LEFT OUTER JOIN [PAT].RespuestaPAT RM ON P.Id =RM.IdPreguntaPAT and RM.IdDepartamento = @IdDepartamento and IdMunicipio is not null --para que tome las respuestas de alcaldias
			LEFT OUTER JOIN Municipio AS M ON RM.IdMunicipio = M.ID	
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id	 
			LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON P.Id=RD.IdPreguntaPAT  AND RD.IdUsuario = @IdUsuario and RD.IdMunicipioRespuesta = RM.IdMunicipio 
			LEFT OUTER JOIN [PAT].seguimiento SM ON P.ID =SM.IdPregunta AND SM.IdTablero = P.IdTablero AND  SM.IdUsuario = RM.IdUsuario
			LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  P.ID =SG.IdPregunta  AND P.IdTablero=SG.IdTablero  AND RM.IdUsuario =SG.IdUsuarioAlcaldia			
			WHERE	P.NIVEL = 3 
			and P.IdTablero = @IdTablero  and p.Activo = 1
			group by D.Descripcion		
	) AS A
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	29/01/2018
-- Description:		Obtiene informacion para el seguimiento para el detalle del consolidado para los municipios que respondieron la pregunta indicada
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] --pat.C_TableroSeguimientoDetalleConsolidadoDepartamento 1,558,37
( @IdTablero INT ,@IdUsuario INT ,@IdPregunta INT )
AS
BEGIN
	declare @IdDepartamento int
	select  @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	SELECT DISTINCT 
	B.Descripcion AS Componente
	,C.Descripcion AS Medida
	,E.Descripcion AS Derecho
	,A.PreguntaIndicativa 
	,D.Descripcion AS Unidad
	,RM.IdMunicipio
	,M.Nombre AS Municipio 
	,RM.RespuestaIndicativa AS  NecesidadIdentificada 
	,RM.RespuestaCompromiso 
	,RD.RespuestaCompromiso AS CompromisoGobernacion
	,ISNULL(SM.CantidadPrimer, -1) AS CantidadPrimerSemestre
	,ISNULL(SM.CantidadSegundo, -1) AS CantidadSegundoSemestre
	,A.Id AS IdPRegunta
	,E.Id AS IdDerecho
	,RM.IdUsuario AS IdUsuarioAlcaldia
	,ISNULL(SG.IdSeguimiento, 0) AS IdSeguimiento
	,ISNULL(SM.IdSeguimiento, 0) AS IdSeguimientoMunicipio
	,(SELECT TOP 1 XX.Id FROM [PAT].RespuestaPAT XX  
							join pat.PreguntaPAT as p on XX.IdPreguntaPAT = p.Id
							WHERE XX.IdMunicipio = RD.IdMunicipioRespuesta and XX.IdPreguntaPAT = @IdPregunta and p.IdTablero = @IdTablero) AS IdRespuestaDepartamentoMunicipio
	,ISNULL(SG.CantidadPrimer, -1) AS CantidadPrimerSemestreGobernaciones
	,ISNULL(SG.CantidadSegundo, -1) AS CantidadSegundoSemestreGobernaciones
	,RD.Presupuesto
	FROM [PAT].PreguntaPAT A
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	LEFT OUTER JOIN [PAT].RespuestaPAT RM ON A.Id =RM.IdPreguntaPAT and RM.IdDepartamento = @IdDepartamento and IdMunicipio is not null --para que tome las respuestas de alcaldias
	LEFT OUTER JOIN Municipio AS M ON RM.IdMunicipio = M.ID
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON A.Id=RD.IdPreguntaPAT  AND RD.IdUsuario = @IdUsuario and RD.IdMunicipioRespuesta = RM.IdMunicipio 
	LEFT OUTER JOIN [PAT].seguimiento SM ON A.ID =SM.IdPregunta AND SM.IdTablero = A.IdTablero AND  SM.IdUsuario = RM.IdUsuario
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  A.ID =SG.IdPregunta  AND A.IdTablero=SG.IdTablero  AND RM.IdUsuario =SG.IdUsuarioAlcaldia --[PAT].[fn_GetIdUsuario](RM.ID_ENTIDAD)
	WHERE   a.IdTablero= @IdTablero and A.ID = @IdPregunta
	order by M.Nombre asc

END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	29/01/2018
-- Description:		Obtiene informacion para el seguimiento para el detalle del consolidado para los municipios que respondieron la pregunta indicada
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] --pat.C_TableroSeguimientoDetalleConsolidadoDepartamento 1,558,37
( @IdTablero INT ,@IdUsuario INT ,@IdPregunta INT )
AS
BEGIN
	declare @IdDepartamento int
	select  @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	SELECT DISTINCT 
	B.Descripcion AS Componente
	,C.Descripcion AS Medida
	,E.Descripcion AS Derecho
	,A.PreguntaIndicativa 
	,D.Descripcion AS Unidad
	,RM.IdMunicipio
	,M.Nombre AS Municipio 
	,RM.RespuestaIndicativa AS  NecesidadIdentificada 
	,RM.RespuestaCompromiso 
	,RD.RespuestaCompromiso AS CompromisoGobernacion
	,ISNULL(SM.CantidadPrimer, -1) AS CantidadPrimerSemestre
	,ISNULL(SM.CantidadSegundo, -1) AS CantidadSegundoSemestre
	,A.Id AS IdPRegunta
	,E.Id AS IdDerecho
	,RM.IdUsuario AS IdUsuarioAlcaldia
	,ISNULL(SG.IdSeguimiento, 0) AS IdSeguimiento
	,ISNULL(SM.IdSeguimiento, 0) AS IdSeguimientoMunicipio
	,(SELECT TOP 1 XX.Id FROM [PAT].RespuestaPAT XX  
							join pat.PreguntaPAT as p on XX.IdPreguntaPAT = p.Id
							WHERE XX.IdMunicipio = RD.IdMunicipioRespuesta and XX.IdPreguntaPAT = @IdPregunta and p.IdTablero = @IdTablero) AS IdRespuestaDepartamentoMunicipio
	,ISNULL(SG.CantidadPrimer, -1) AS CantidadPrimerSemestreGobernaciones
	,ISNULL(SG.CantidadSegundo, -1) AS CantidadSegundoSemestreGobernaciones
	,RD.Presupuesto
	FROM [PAT].PreguntaPAT A
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	LEFT OUTER JOIN [PAT].RespuestaPAT RM ON A.Id =RM.IdPreguntaPAT and RM.IdDepartamento = @IdDepartamento and IdMunicipio is not null --para que tome las respuestas de alcaldias
	LEFT OUTER JOIN Municipio AS M ON RM.IdMunicipio = M.ID
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON A.Id=RD.IdPreguntaPAT  AND RD.IdUsuario = @IdUsuario and RD.IdMunicipioRespuesta = RM.IdMunicipio 
	LEFT OUTER JOIN [PAT].seguimiento SM ON A.ID =SM.IdPregunta AND SM.IdTablero = A.IdTablero AND  SM.IdUsuario = RM.IdUsuario
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  A.ID =SG.IdPregunta  AND A.IdTablero=SG.IdTablero  AND RM.IdUsuario =SG.IdUsuarioAlcaldia --[PAT].[fn_GetIdUsuario](RM.ID_ENTIDAD)
	WHERE   a.IdTablero= @IdTablero and A.ID = @IdPregunta
	union all	
	--los municipios que no tienen planeaacion
	select DISTINCT 
	B.Descripcion AS Componente
	,C.Descripcion AS Medida
	,E.Descripcion AS Derecho
	,A.PreguntaIndicativa 
	,D.Descripcion AS Unidad
	,M.Id as  IdMunicipio
	,M.Nombre AS Municipio 
	,0 AS  NecesidadIdentificada 
	,0
	,0 AS CompromisoGobernacion
	,-1 AS CantidadPrimerSemestre
	,-1 AS CantidadSegundoSemestre
	,A.Id AS IdPRegunta
	,E.Id AS IdDerecho
	,UA.Id AS IdUsuarioAlcaldia 
	,ISNULL(SG.IdSeguimiento, 0) AS IdSeguimiento
	,0 AS IdSeguimientoMunicipio
	,0 AS IdRespuestaDepartamentoMunicipio
	,ISNULL(SG.CantidadPrimer, -1) AS CantidadPrimerSemestreGobernaciones
	,ISNULL(SG.CantidadSegundo, -1) AS CantidadSegundoSemestreGobernaciones
	,0 as Presupuesto
	FROM [PAT].[PreguntaPAT] AS a
	join [PAT].[PreguntaPATMunicipio] as PM on a.Id = PM.IdPreguntaPAT 
	join Municipio as M on PM.IdMunicipio = M.Id
	Join Usuario as UA on M.Id = UA.IdMunicipio and UA.Activo =1 and UA.IdTipoUsuario = 2 and UA.IdEstado = 5
	join [PAT].Componente b on b.Id = a.IdComponente
	join [PAT].Medida c on c.Id = a.IdMedida
	join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	join [PAT].Derecho e on e.Id = a.IdDerecho
	LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on a.ID = R.[IdPreguntaPAT] and  R.IdMunicipio = PM.IdMunicipio 			
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON  A.ID =SG.IdPregunta  AND A.IdTablero=SG.IdTablero AND SG.IdUsuario  = @IdUsuario and SG.IdUsuarioAlcaldia = UA.Id
	WHERE  a.IdTablero = 1 
	and a.Activo = 1
	and	a.NIVEL = 3 
	and M.IdDepartamento =@IdDepartamento
	and R.Id is  null	
	and a.Id = @IdPregunta
	order by M.Nombre asc
	
	

END


