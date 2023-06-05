IF  NOT EXISTS (select 1 from sys.columns where Name = N'CompromisoDefinitivo' and Object_ID = Object_ID(N'PAT.Seguimiento'))
begin
	ALTER TABLE PAT.Seguimiento ADD
	CompromisoDefinitivo int NULL,
	PresupuestoDefinitivo money NULL,
	ObservacionesDefinitivo varchar(max) NULL
end
GO
IF  NOT EXISTS (select 1 from sys.columns where Name = N'CompromisoDefinitivo' and Object_ID = Object_ID(N'PAT.SeguimientoGobernacion'))
begin
ALTER TABLE [PAT].[SeguimientoGobernacion] ADD
	CompromisoDefinitivo int NULL,
	PresupuestoDefinitivo money NULL,
	ObservacionesDefinitivo varchar(max) NULL
end
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosRespuestaSeguimientoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosRespuestaSeguimientoDepartamento] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	01/06/2018
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
	,f.CompromisoDefinitivo,f.PresupuestoDefinitivo ,f.ObservacionesDefinitivo 
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_datosRespuestaSeguimientoMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_datosRespuestaSeguimientoMunicipio] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/08/2017
-- Modified date:	01/06/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero que respondio el usuario y el municipio
-- =============================================
ALTER PROC  [PAT].[C_datosRespuestaSeguimientoMunicipio] -- [PAT].[C_datosRespuestaSeguimientoMunicipio] 21, 411 
(@IdPregunta INT,@IdUsuario INT)
AS 
BEGIN
	
	declare @IdMunicipio int
	select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

--	select TOP 1	
--	e.Descripcion as Derecho
--	,b.Descripcion as Componente
--	,c.Descripcion as Medida
--	,a.PreguntaIndicativa
--	,d.Descripcion as Unidad
--	,a.PreguntaCompromiso
--	,ISNULL(f.IdSeguimiento, 0) as IdSeguimiento
--	,ISNULL(f.CantidadPrimer, -1) as CompromisoPrimerSemestre
--	,ISNULL(f.CantidadSegundo, -1) as CompromisoSegundoSemestre
--	,ISNULL(f.CantidadPrimer + REPLACE(f.CantidadSegundo, -1, 0), -1) as CompromisoTotal
--	,ISNULL(f.PresupuestoPrimer, -1) as PresupuestoPrimerSemestre
--	,ISNULL(f.PresupuestoSegundo, -1) as PresupuestoSegundoSemestre
--	,ISNULL(f.PresupuestoPrimer + REPLACE(f.PresupuestoSegundo, -1, 0), -1) as PresupuestoTotal
--	,ISNULL(f.Observaciones, '') as ObservacionesSeguimiento
--	,ISNULL(f.NombreAdjunto, '') as AdjuntoSeguimiento
--	,R.Id AS IdRespuesta
--	,R.IdMunicipio 
--	,A.IdTablero
--	,R.RespuestaCompromiso
--	,R.RespuestaIndicativa
--	,R.Presupuesto
--	,R.ObservacionNecesidad
--	,R.NecesidadIdentificada
--	,R.AccionCompromiso
--	,a.Id AS IdPregunta
--	,a.IdComponente
--	,a.IdDerecho
--	,a.IdMedida 
--	,a.IdUnidadMedida
--	from [PAT].PreguntaPAT AS a
--	inner join [PAT].Componente b on b.Id = a.IdComponente
--	inner join [PAT].Medida  AS c on c.Id = a.IdMedida
--	inner join [PAT].UnidadMedida AS d on d.Id = a.IdUnidadMedida
--	inner join [PAT].Derecho AS e on e.Id = a.IdDerecho
--	LEFT OUTER JOIN [PAT].RespuestaPAT AS R on R.IdPreguntaPAT = a.Id
--	LEFT OUTER JOIN Municipio AS  U on U.Id = R.IdMunicipio
--	LEFT OUTER JOIN [PAT].Seguimiento as f on f.IdPregunta = a.Id and f.IdUsuario =R.IdMunicipio
--	where 	a.ID = @IdPregunta  and r.IdMunicipio = @IdMunicipio	--and r.IdUsuario = 1513	
--UNION ALL	
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
	,isnull (R.Id, 0) AS IdRespuesta
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
	,f.CompromisoDefinitivo,f.PresupuestoDefinitivo ,f.ObservacionesDefinitivo  
	from [PAT].PreguntaPAT as a
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida as d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on R.IdPreguntaPAT = a.Id and R.IdMunicipio = @IdMunicipio
	LEFT OUTER JOIN [PAT].Seguimiento as f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
	where a.ID = @IdPregunta
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDepartamento] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez -Vilma rodriguez
-- Create date:		29/08/2017
-- Modified date:	01/06/2018
-- Description:		Obtiene informacion de las preguntas por departamento para el seguimiento de un tablero departamental
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDepartamento] -- [PAT].[C_TableroSeguimientoDepartamento] 2, 1598
(	@IdTablero INT ,@IdUsuario INT )
AS
BEGIN		
		DECLARE  @IdDepartamento INT,@NumeroSeguimiento int	
		select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

		declare @date datetime
		set @date = getdate()
		select @NumeroSeguimiento =
			case when (@date between [Seguimiento1Inicio] and [Seguimiento1Fin]) then 1
				 when (@date between [Seguimiento2Inicio] and [Seguimiento2Fin]) then 2 end	
		from pat.TableroFecha
		where IdTablero = @IdTablero  and nivel = 3

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
		,[PAT].[C_ValidacionEnvioSeguimientoGobernacion] (@IdUsuario,a.Id, @IdDepartamento,@NumeroSeguimiento )   as ValidacionEnvio	
		,f.CompromisoDefinitivo,f.PresupuestoDefinitivo  
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoMunicipio] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/08/2017
-- Modified date:	01/06/2018
-- Description:		Retorna el numero de seguimiento de acuerdo al momento en el que se llame el procedimiento
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoMunicipio] --[PAT].[C_TableroSeguimientoMunicipio] 1, 1, 430
(	@IdDerecho INT
	,@IdTablero INT
	,@IdUsuario INT
)
AS
BEGIN

		declare @IdMunicipio int,@NumeroSeguimiento int
		select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario
				
		declare @date datetime
		set @date = getdate()
		select @NumeroSeguimiento =
			case when (@date between [Seguimiento1Inicio] and [Seguimiento1Fin]) then 1
				 when (@date between [Seguimiento2Inicio] and [Seguimiento2Fin]) then 2 end	
		from pat.TableroFecha
		where IdTablero = @IdTablero  and nivel = 3
		
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
		,a.ID 
		,a.IdComponente 
		,a.IdDerecho 
		,a.IdMedida 
		,a.IdUnidadMedida
		,ISNULL(R.RespuestaCompromiso, 0) AS RespuestaIndicativa
		,ISNULL(R.Presupuesto, 0) AS Presupuesto, r.RespuestaIndicativa as NecesidadIdentificada,ExplicacionPregunta
		,[PAT].[C_ValidacionEnvioSeguimiento] (@IdMunicipio, a.Id, @IdUsuario,@NumeroSeguimiento )   as ValidacionEnvio	
		,f.CompromisoDefinitivo,f.PresupuestoDefinitivo  
		from [PAT].PreguntaPAT AS a
		join [PAT].[PreguntaPATMunicipio] as PM on a.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		inner join [PAT].Componente AS b on b.ID = a.IdComponente
		inner join [PAT].Medida AS c on c.ID = a.IdMedida
		inner join [PAT].UnidadMedida AS d on d.ID = a.IdUnidadMedida
		inner join [PAT].Derecho AS e on e.ID = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT as R on R.IdPreguntaPAT = a.ID and r.IdMunicipio = @IdMunicipio
		LEFT OUTER JOIN [PAT].Seguimiento as f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
		where a.ACTIVO = 1
		and e.ID = @IdDerecho
		and a.IdTablero = @IdTablero
		order by a.ID  asc
END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoMunicipioAvance]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoMunicipioAvance] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Liliana Rodriguez
-- Create date:		28/08/2017
-- Modified date:	01/06/2018
-- Description:		Obtiene los porcentajes de avance del seguimiento de la gestión del tablero PAT por municipio 
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoMunicipioAvance]--[PAT].[C_TableroSeguimientoMunicipioAvance] 411, 1
( @IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare @IdMunicipio int
	select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

	SELECT 	A.Derecho
	,ISNULL(CONVERT(INT, CASE WHEN ROUND(CASE A.rc WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.rc)) * 100) END, 0) > 100 THEN 100 ELSE ROUND(CASE A.rc WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.rc)) * 100) END, 0) END),0) AS AvanceCompromiso
	,ISNULL(CONVERT(INT, CASE WHEN ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0) > 100 THEN 100 ELSE ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0) END),0) AS AvancePresupuesto
	FROM
	(
		SELECT	D.Descripcion AS Derecho
		,SUM(C.PresupuestoPrimer) as p1
		,SUM(C.PresupuestoSegundo) as p2
		,SUM(case when R.RespuestaIndicativa is null then 0 else r.RespuestaIndicativa end) as ri
		--,SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end) as rc
		--,SUM(case when R.Presupuesto is null then 0 else r.Presupuesto end) as pres
		,SUM(case when C.CompromisoDefinitivo is null then 0 else C.CompromisoDefinitivo end) as rc
		,SUM(case when C.PresupuestoDefinitivo is null then 0 else C.PresupuestoDefinitivo end) as pres
		,(SUM(case when C.CantidadPrimer is null or C.CantidadPrimer = -1 then 0 else C.CantidadPrimer end) + SUM(case when C.CantidadSegundo is null or C.CantidadSegundo = -1 then 0 else C.CantidadSegundo end)) as sumc1c2
		,(SUM(case when C.PresupuestoPrimer is null or C.PresupuestoPrimer = -1 then 0 else C.PresupuestoPrimer end) + SUM(case when C.PresupuestoSegundo is null or C.PresupuestoSegundo = -1 then 0 else C.PresupuestoSegundo end)) as sump1p2
		FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
		join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		INNER JOIN [PAT].[Derecho] (NOLOCK) D ON P.IDDERECHO = D.ID 
		INNER JOIN PAT.Tablero (NOLOCK) AS T ON P.IDTABLERO = T.ID				
		LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON R.IdMunicipio = @IdMunicipio  and P.ID = R.[IdPreguntaPAT]	
		LEFT OUTER JOIN [PAT].Seguimiento as C ON C.IdPregunta = P.Id and C.IdUsuario = @IdUsuario
		WHERE	P.NIVEL = 3 
		AND T.ID = @idTablero
		and P.ACTIVO = 1		
		group by D.Descripcion
	) AS A
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_SeguimientoMunicipalInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_SeguimientoMunicipalInsert] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Modified date:	01/06/2018
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
			   ,@CompromisoDefinitivo bigint
			   ,@PresupuestoDefinitivo money
			   ,@ObservacionesDefinitivo  varchar(max)
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
			  ,CompromisoDefinitivo=@CompromisoDefinitivo 
			  ,PresupuestoDefinitivo =@PresupuestoDefinitivo 
			  ,ObservacionesDefinitivo  = @ObservacionesDefinitivo 
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
				   ,[FechaSeguimientoSegundo]
				   ,CompromisoDefinitivo
				   ,PresupuestoDefinitivo
				   ,ObservacionesDefinitivo)
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
				   ,@FechaSeguimientoSegundo
				   ,@CompromisoDefinitivo 
				   ,@PresupuestoDefinitivo 
				   ,@ObservacionesDefinitivo
)
		
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_SeguimientoGobernacionInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_SeguimientoGobernacionInsert] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Modified date:	01/06/2018
/Descripcion: Inserta la información del seguimeinto municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_SeguimientoGobernacionInsert]
				@IdTablero tinyint
			   ,@IdPregunta smallint
			   ,@IdUsuario int	
			   ,@IdUsuarioAlcaldia int		   
			   ,@CantidadPrimer bigint
			   ,@PresupuestoPrimer money
			   ,@CantidadSegundo bigint
			   ,@PresupuestoSegundo money
			   ,@Observaciones varchar(max)
			   ,@NombreAdjunto varchar(200)
			   ,@ObservacionesSegundo varchar(max)
			   ,@NombreAdjuntoSegundo varchar(200)
			   ,@CompromisoDefinitivo bigint
			   ,@PresupuestoDefinitivo money
			   ,@ObservacionesDefinitivo varchar(max)
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
	from pat.TableroFecha where IdTablero = @IdTablero  and nivel = 2
		
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
	if (@CantidadSegundo = -1)
		set @CantidadSegundo = 0
		
	if (@PresupuestoSegundo = -1)
		set @PresupuestoSegundo = 0

	if @ObservacionesSegundo is null
		set @ObservacionesSegundo = ''
	
	---validar que no se duplique un registro
	declare @idActual int
	select @idActual =IdSeguimiento from PAT.[SeguimientoGobernacion] WHERE IdPregunta = @IdPregunta and IdTablero = @IdTablero and IdUsuario = @IdUsuario and IdUsuarioAlcaldia = @IdUsuarioAlcaldia order by IdSeguimiento
	if  (@idActual >0)
	begin	
		UPDATE [PAT].[SeguimientoGobernacion]
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
			  ,CompromisoDefinitivo=@CompromisoDefinitivo 
			  ,PresupuestoDefinitivo =@PresupuestoDefinitivo 
			  ,ObservacionesDefinitivo = @ObservacionesDefinitivo
		 WHERE IdSeguimiento =@idActual

		 select @id = @idActual
		 SELECT @respuesta = 'Se ha actualizado el registro'
		 SELECT @estadoRespuesta = 1			
	end
	else
	begin	
		BEGIN TRY				
			INSERT INTO [PAT].[SeguimientoGobernacion]
				   ([IdTablero]
				   ,[IdPregunta]
				   ,[IdUsuario]
				   ,[IdUsuarioAlcaldia]
				   ,[FechaSeguimiento]
				   ,[CantidadPrimer]
				   ,[PresupuestoPrimer]
				   ,[CantidadSegundo]
				   ,[PresupuestoSegundo]
				   ,[Observaciones]
				   ,[NombreAdjunto]
				   ,[ObservacionesSegundo]
				   ,[NombreAdjuntoSegundo]
				   ,[FechaSeguimientoSegundo]
				   ,CompromisoDefinitivo
				   ,PresupuestoDefinitivo
				   ,ObservacionesDefinitivo)
			 VALUES
				   (@IdTablero 
				   ,@IdPregunta 
				   ,@IdUsuario 
				   ,@IdUsuarioAlcaldia
				   ,getdate() 
				   ,@CantidadPrimer 
				   ,@PresupuestoPrimer 
				   ,@CantidadSegundo 
				   ,@PresupuestoSegundo 
				   ,@Observaciones 
				   ,@NombreAdjunto  
				   ,@ObservacionesSegundo				
				   ,@NombreAdjuntoSegundo
				   ,@FechaSeguimientoSegundo
				   ,@CompromisoDefinitivo 
				   ,@PresupuestoDefinitivo 
				   ,@ObservacionesDefinitivo)						
		
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_SeguimientoMunicipalUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_SeguimientoMunicipalUpdate] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29	
/Modified date:	01/06/2018
/Descripcion: Inserta la información del seguimeinto municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_SeguimientoMunicipalUpdate] 
				@IdSeguimiento int			   
			   ,@IdTablero tinyint
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
			   ,@CompromisoDefinitivo bigint
			   ,@PresupuestoDefinitivo money
			   ,@ObservacionesDefinitivo varchar(max)
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
		set @FechaUltimaModificacion = @date
		set @FechaSeguimientoSegundo = null
		set @FechaUltimaModificacionSegundo = null
	end
	else
	begin
		set @FechaUltimaModificacionSegundo =@date
		select 
		@FechaSeguimientoSegundo = case when FechaSeguimientoSegundo is null then @date else FechaSeguimientoSegundo end ,
		@FechaUltimaModificacionSegundo = case when FechaUltimaModificacionSegundo is null then @date else FechaUltimaModificacionSegundo end 
		from PAT.Seguimiento
		where IdSeguimiento = @IdSeguimiento
	end
	--
	if @ObservacionesSegundo is null
		set @ObservacionesSegundo = ''
			
	if(@esValido = 1) 
	begin
		BEGIN TRY				
			update [PAT].[Seguimiento] set 
				   [CantidadPrimer] = @CantidadPrimer
				   ,[PresupuestoPrimer] = @PresupuestoPrimer
				   ,[CantidadSegundo] = @CantidadSegundo
				   ,[PresupuestoSegundo] = @PresupuestoSegundo
				   ,[Observaciones] = @Observaciones
				   ,[NombreAdjunto] = @NombreAdjunto
				   ,[ObservacionesSegundo]=@ObservacionesSegundo
				   ,[NombreAdjuntoSegundo]=@NombreAdjuntoSegundo
				   ,FechaUltimaModificacion =@FechaUltimaModificacion
				   ,FechaSeguimientoSegundo = @FechaSeguimientoSegundo
				   ,FechaUltimaModificacionSegundo = @FechaUltimaModificacionSegundo
				   ,CompromisoDefinitivo=@CompromisoDefinitivo 
			       ,PresupuestoDefinitivo =@PresupuestoDefinitivo 
				   ,ObservacionesDefinitivo = @ObservacionesDefinitivo
			where  IdSeguimiento = @IdSeguimiento
					
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_SeguimientoGobernacionUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_SeguimientoGobernacionUpdate] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Modified date:	01/06/2018
/Descripcion: Inserta la información del seguimeinto municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_SeguimientoGobernacionUpdate] 
				@IdSeguimiento int			   
			   ,@IdTablero tinyint
			   ,@IdPregunta smallint
			   ,@IdUsuario int		
			   ,@IdUsuarioAlcaldia int		   	   
			   ,@CantidadPrimer bigint
			   ,@PresupuestoPrimer money
			   ,@CantidadSegundo bigint
			   ,@PresupuestoSegundo money
			   ,@Observaciones varchar(max)
			   ,@NombreAdjunto varchar(200)
			   ,@ObservacionesSegundo varchar(max)
			   ,@NombreAdjuntoSegundo varchar(200)
			   ,@CompromisoDefinitivo bigint
			   ,@PresupuestoDefinitivo money
			   ,@ObservacionesDefinitivo varchar(max)
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
	from pat.TableroFecha where IdTablero = @IdTablero  and nivel = 2
		
	if (@numSeguimiento = 1)
	begin		
		set @FechaUltimaModificacion = @date
		set @FechaSeguimientoSegundo = null
		set @FechaUltimaModificacionSegundo = null
	end
	else
	begin
		set @FechaUltimaModificacionSegundo =@date
		select 
		@FechaSeguimientoSegundo = case when FechaSeguimientoSegundo is null then @date else FechaSeguimientoSegundo end ,
		@FechaUltimaModificacionSegundo = case when FechaUltimaModificacionSegundo is null then @date else FechaUltimaModificacionSegundo end 
		from PAT.[SeguimientoGobernacion]
		where IdSeguimiento = @IdSeguimiento
	end
	--
	if @ObservacionesSegundo is null
		set @ObservacionesSegundo = ''
			
	if(@esValido = 1) 
	begin
		BEGIN TRY				
			update [PAT].[SeguimientoGobernacion] set 
				   [CantidadPrimer] = @CantidadPrimer
				   ,[PresupuestoPrimer] = @PresupuestoPrimer
				   ,[CantidadSegundo] = @CantidadSegundo
				   ,[PresupuestoSegundo] = @PresupuestoSegundo
				   ,[Observaciones] = @Observaciones
				   ,[NombreAdjunto] = @NombreAdjunto
				   ,[ObservacionesSegundo]=@ObservacionesSegundo
				   ,[NombreAdjuntoSegundo]=@NombreAdjuntoSegundo
				   ,FechaUltimaModificacion =@FechaUltimaModificacion
				   ,FechaSeguimientoSegundo = @FechaSeguimientoSegundo
				   ,FechaUltimaModificacionSegundo = @FechaUltimaModificacionSegundo
				   ,CompromisoDefinitivo=@CompromisoDefinitivo 
			       ,PresupuestoDefinitivo =@PresupuestoDefinitivo 
				   ,ObservacionesDefinitivo = @ObservacionesDefinitivo
			where  IdSeguimiento = @IdSeguimiento
					
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
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ValidacionEnvioSeguimiento]')) 
EXEC dbo.sp_executesql @statement = N'CREATE function [PAT].[C_ValidacionEnvioSeguimiento] AS'
GO
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		24/04/2018
-- Modified date:	01/06/2018
-- Description:		Obtiene la validacion para el envio del tablero para una pregunta de un municipip.
-- =============================================
ALTER function [PAT].[C_ValidacionEnvioSeguimiento] 
	(@IdMunicipio int,
	@IdPregunta int,@IdUsuario INT, @NumeroSeguimiento int)
RETURNS bit
AS
BEGIN	
    DECLARE @Valido bit
	set @Valido = 1
		
	IF EXISTS (SELECT TOP 1 1 	FROM PAT.RespuestaPAT a
	INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id	
	WHERE a.IdMunicipio = @IdMunicipio AND b.Id = @IdPregunta AND (a.RespuestaCompromiso > 0 OR a.Presupuesto> 0))--TIENE PLANEACION DEBE TENER SEGUIMIENTO
	BEGIN 
		if (@NumeroSeguimiento = 1)
		begin 
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadPrimer >= 0 OR PresupuestoPrimer >= 0))
			BEGIN
				set @Valido = 0
			END
		END
		else		
		begin 
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadSegundo >= 0 OR PresupuestoSegundo >= 0) AND ObservacionesSegundo IS NOT NULL AND CompromisoDefinitivo > 0 and PresupuestoDefinitivo > 0)
			BEGIN
				set @Valido = 0
			END
		END
	END
		
	return @Valido
END 

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ValidacionEnvioSeguimientoGobernacion]')) 
EXEC dbo.sp_executesql @statement = N'CREATE function [PAT].[C_ValidacionEnvioSeguimientoGobernacion] AS'
GO
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		24/04/2018
-- Modified date:	01/06/2018
-- Description:		Obtiene la validacion para el envio del tablero para una pregunta de un departamento.
-- =============================================
ALTER function [PAT].[C_ValidacionEnvioSeguimientoGobernacion] (@IdUsuario int , @IdPregunta int,@IdDepartamento INT, @NumeroSeguimiento int)
RETURNS bit
AS
BEGIN	
    DECLARE @Valido bit
	set @Valido = 1
		
	IF EXISTS (SELECT top 1 1 FROM PAT.RespuestaPAT a
			INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
			WHERE a.IdDepartamento = @IdDepartamento AND b.Activo = 1 and b.Nivel = 2 and b.Id = @IdPregunta	AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0))--TIENE PLANEACION DEBE TENER SEGUIMIENTO
	BEGIN 
		if (@NumeroSeguimiento = 1)
		begin 		
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadPrimer >= 0 OR PresupuestoPrimer >= 0))
			BEGIN
				set @Valido = 0
			END
		END
		else		
		begin 
			IF NOT EXISTS (SELECT TOP 1 1 FROM PAT.Seguimiento 	WHERE IdPregunta = @IdPregunta	AND IdUsuario = @IdUsuario
			AND (CantidadSegundo >= 0 OR PresupuestoSegundo >= 0) AND ObservacionesSegundo IS NOT NULL AND CompromisoDefinitivo > 0 and PresupuestoDefinitivo > 0)
			BEGIN
				set @Valido = 0
			END
		END
	END
		
	return @Valido
END 


go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ValidacionEnvioSeguimientoGobernacionConsolidado]')) 
EXEC dbo.sp_executesql @statement = N'CREATE function [PAT].[C_ValidacionEnvioSeguimientoGobernacionConsolidado] AS'
GO
-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		24/04/2018
-- Modified date:	01/06/2018
-- Description:		Obtiene la validacion para el envio del tablero para una pregunta del consolidado de un departamento.
-- =============================================
ALTER function   [PAT].[C_ValidacionEnvioSeguimientoGobernacionConsolidado] (@IdUsuario int , @IdPregunta int,@IdDepartamento INT, @NumeroSeguimiento int)
RETURNS bit
AS
BEGIN	
    DECLARE @Valido bit
	set @Valido = 1

	DECLARE @CantPreguntasSeguimientoGobConsolidado INT
	DECLARE @PreguntasPlaneacionGobConsolidado TABLE (IdPreguntaPAT INT,IdUsuario int, IdDepartamento int, IdMunicipio int, IdUsuarioAlcaldia INT)--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento

	INSERT INTO @PreguntasPlaneacionGobConsolidado--inserta las preguntas con respuestas que dio ese usuario con compromiso >0 or OR a.Presupuesto > 0
	SELECT a.IdPreguntaPAT, a.IdUsuario, m.IdDepartamento , a.IdMunicipioRespuesta
	,(select id from dbo.Usuario where IdMunicipio = a.IdMunicipioRespuesta and idestado = 5 and activo = 1 and IdTipoUsuario = 2)
	FROM PAT.RespuestaPATDepartamento a
	join Municipio as m on a.IdMunicipioRespuesta = m.Id
	INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
	WHERE b.Id = @IdPregunta and	a.IdUsuario =@IdUsuario  AND b.Activo = 1 and b.Nivel = 3 And b.ApoyoDepartamental =1 AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0) 
	
	if (@NumeroSeguimiento = 1)
	begin 		
		
		SELECT @CantPreguntasSeguimientoGobConsolidado = COUNT(distinct P.Id)
		FROM @PreguntasPlaneacionGobConsolidado as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadPrimer >= 0 or SEG.PresupuestoPrimer >= 0) 
		join Departamento as D on PPG.IdDepartamento = D.Id	
		JOIN Municipio AS M ON PPG.IdMunicipio = M.Id		
		WHERE SEG.IdSeguimiento is null	and PPG.IdDepartamento = @IdDepartamento and P.Id = @IdPregunta
		
		Set @Valido = CONVERT(bit,  CASE WHEN @CantPreguntasSeguimientoGobConsolidado = 0 THEN 1 ELSE 0 END)
	END
	else		
	begin 
		
		SELECT @CantPreguntasSeguimientoGobConsolidado = COUNT(distinct P.Id)
		FROM @PreguntasPlaneacionGobConsolidado as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadSegundo >= 0 or SEG.PresupuestoSegundo >= 0) AND SEG.ObservacionesSegundo IS NOT NULL AND CompromisoDefinitivo > 0 and PresupuestoDefinitivo > 0
		join Departamento as D on PPG.IdDepartamento = D.Id	
		JOIN Municipio AS M ON PPG.IdMunicipio = M.Id		
		WHERE SEG.IdSeguimiento is null	and PPG.IdDepartamento = @IdDepartamento and P.Id = @IdPregunta
		
		Set @Valido = CONVERT(bit,  CASE WHEN @CantPreguntasSeguimientoGobConsolidado = 0 THEN 1 ELSE 0 END)
	END

	return @Valido
END 

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoAlcaldias]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoAlcaldias] AS'
GO	
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	01/06/2018
-- Description:		Obtiene informacion requerida para la hoja "Reporte Seguimiento Tablero PAT" del excel que se exporta en seguimiento municipal
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoAlcaldias] --[PAT].[C_DatosExcelSeguimientoAlcaldias] 411, 4
( @IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare @IdMunicipio int, @IdDepartamento int
	select  @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	select distinct IdPregunta,IdAccion,IdPrograma,Derecho,Componente,Medida,Pregunta,PreguntaCompromiso,UnidadNecesidad,RespuestaNecesidad
		,ObservacionNecesidad,RespuestaCompromiso,ObservacionCompromiso,PrespuestaPresupuesto,Accion,Programa
		,CantidadPrimerSeguimientoAlcaldia, CantidadSegundoSeguimientoAlcaldia,AvanceCantidadAlcaldia
		,PresupuestoPrimerSeguimientoAlcaldia,PresupuestoSegundoSeguimientoAlcaldia,AvancePresupuestoAlcaldia
		,ObservacionesSeguimientoAlcaldia
		,CantidadPrimerSeguimientoGobernacion ,CantidadSegundoSeguimientoGobernacion  ,AvanceCantidadGobernacion
		,PresupuestoPrimerSeguimientoGobernacion,PresupuestoSegundoSeguimientoGobernacion ,AvancePresupuestoGobernacion
		,ObservacionesSeguimientoGobernacion,ObservacionesSegundo,NombreAdjuntoSegundo
		,ProgramasPrimero,ProgramasSegundo,ProgramasPrimeroSeguimientoGobernacion,ProgramasSegundoSeguimientoGobernacion,ObservacionesSegundoSeguimientoGobernacion
		,CompromisoDefinitivo,PresupuestoDefinitivo ,ObservacionesDefinitivo
		,CompromisoDefinitivoGobernacion,PresupuestoDefinitivoGobernacion ,ObservacionesDefinitivoGobernacion
	from (
		SELECT 
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
		,RM.Presupuesto AS PrespuestaPresupuesto
		--,RMA.Accion
		--,RMP.Programa					
		,STUFF((SELECT CAST( ACCION.Accion AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATAccion AS ACCION
		WHERE A.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Accion,	
		STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		WHERE A.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Programa	

		,SM.CantidadPrimer AS CantidadPrimerSeguimientoAlcaldia
		,REPLACE(SM.CantidadSegundo, -1, 0) AS CantidadSegundoSeguimientoAlcaldia
		,SM.PresupuestoPrimer AS PresupuestoPrimerSeguimientoAlcaldia
		,REPLACE(SM.PresupuestoSegundo, -1, 0) AS PresupuestoSegundoSeguimientoAlcaldia

		,(SM.CantidadPrimer + REPLACE(SM.CantidadSegundo, -1, 0)) AS AvanceCantidadAlcaldia
		,(SM.PresupuestoPrimer + REPLACE(SM.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoAlcaldia
		,SM.Observaciones AS ObservacionesSeguimientoAlcaldia

		,SG.CantidadPrimer AS CantidadPrimerSeguimientoGobernacion
		,REPLACE(SG.CantidadSegundo, -1, 0) AS CantidadSegundoSeguimientoGobernacion
		,SG.PresupuestoPrimer AS PresupuestoPrimerSeguimientoGobernacion
		,REPLACE(SG.PresupuestoSegundo, -1, 0) AS PresupuestoSegundoSeguimientoGobernacion

		,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
		,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
		
		,SG.Observaciones AS ObservacionesSeguimientoGobernacion
		,SG.ObservacionesSegundo AS ObservacionesSegundoSeguimientoGobernacion
		
		,SM.ObservacionesSegundo
		,SM.NombreAdjuntoSegundo		

		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoProgramas AS SMP
		WHERE SMP.IdSeguimiento =SM.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimero			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoProgramas AS SMP
		WHERE SMP.IdSeguimiento =SM.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundo			


		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			
		
		, SM.CompromisoDefinitivo,SM.PresupuestoDefinitivo ,SM.ObservacionesDefinitivo
		, SG.CompromisoDefinitivo CompromisoDefinitivoGobernacion,SG.PresupuestoDefinitivo PresupuestoDefinitivoGobernacion ,SG.ObservacionesDefinitivo ObservacionesDefinitivoGobernacion
		FROM [PAT].PreguntaPAT A (nolock)
		join [PAT].[PreguntaPATMunicipio] as PM (nolock) on A.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		inner join [PAT].Componente b (nolock) on b.Id = a.IdComponente
		inner join [PAT].Medida c (nolock) on c.Id = a.IdMedida
		inner join [PAT].UnidadMedida d (nolock) on d.Id = a.IdUnidadMedida
		inner join [PAT].Derecho e (nolock) on e.Id = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT RM (nolock) ON RM.IdPreguntaPAT = A.Id  and RM.IdMunicipio = @IdMunicipio--AND RM.ID_ENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
		--LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA  (nolock)ON RMA.IdRespuestaPAT = RM.Id
		--LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP  (nolock) ON RMP.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = A.ID AND SM.IdUsuario = @IdUsuario AND SM.IdTablero = @IdTablero
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG (nolock) ON SG.IdPregunta = A.ID AND SG.IdUsuarioAlcaldia = @IdUsuario AND SG.IdTablero = @IdTablero
		WHERE  a.IdTablero= @IdTablero 
		AND A.NIVEL = 3		
		and a.ACTIVO = 1
		) as A
		ORDER BY Derecho ASC, IdPregunta ASC 
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoGobernaciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoGobernaciones] AS'
GO	
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		30/08/2017
-- Modified date:	01/06/2018
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
			ObservacionesSeguimientoGobernacion,ObservacionesSegundoSeguimientoGobernacion,ProgramasPrimeroSeguimientoGobernacion,ProgramasSegundoSeguimientoGobernacion 
			,CompromisoDefinitivo,PresupuestoDefinitivo ,ObservacionesDefinitivo
			FROM (
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
	
		, SG.CompromisoDefinitivo,SG.PresupuestoDefinitivo ,SG.ObservacionesDefinitivo

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosMunicipalesSeguimientoWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosMunicipalesSeguimientoWebService] AS'
GO	
-- =============================================
-- Author:			Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Vilma Rodriguez
-- Create date:		10/11/2017
-- Modify Date:		22/02/2018
-- Modified date:	01/06/2018
-- Description:		Retorna los datos del seguimiento del tablero PAT Indicado, por derecho y Divipola
-- Modificacion:	Se modifica para hacer opcional el parámetro IdDerecho
-- Modificacion:	Se modifica para agregar los campos de ajuste de planeacion
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosMunicipalesSeguimientoWebService] -- [PAT].[C_DatosMunicipalesSeguimientoWebService] 1, 1, 5001
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaMunicipio int
)
AS
BEGIN
	SET NOCOUNT ON;	

	IF @IdDerecho IS NULL OR @IdDerecho = 0 OR @IdDerecho = -1
	BEGIN

	SELECT DISTINCT 
			P.Id AS IdPregunta, 
			P.IdTablero AS IdTablero,					
			R.Id as IdRespuesta,
			@DivipolaMunicipio as DivipolaMunicipio, 
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
			FROM [PAT].[SeguimientoProgramas] AS PROGRAMA
			WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento  and NumeroSeguimiento =1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSeguimiento
			
			--adicionales
			,SM.ObservacionesSegundo AS ObservacionesSegundoSeguimiento
			,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].[SeguimientoProgramas] AS PROGRAMA
			WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento  and NumeroSeguimiento =2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimiento
			--,CONVERT(decimal, ISNULL( REPLACE(isnull(SM.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(SM.CantidadSegundo,0), -1, 0),0)) as CantidadTotalSeguimiento
			--,CONVERT(decimal,  ISNULL( REPLACE(isnull(SM.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(SM.PresupuestoSegundo,0), -1, 0),0)) as PresupuestoTotalSeguimiento
			,SM.CantidadPrimer +  SM.CantidadSegundo as CantidadTotalSeguimiento
			,SM.PresupuestoPrimer + SM.PresupuestoSegundo as PresupuestoTotalSeguimiento
			,SM.CompromisoDefinitivo,SM.PresupuestoDefinitivo ,SM.ObservacionesDefinitivo
			FROM  [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id
			LEFT OUTER JOIN PAT.RespuestaPAT AS R on P.Id = R.IdPreguntaPAT AND R.IdMunicipio = [PAT].[fn_GetIdMunicipio](@DivipolaMunicipio)
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
				  ,SEG.CompromisoDefinitivo,SEG.PresupuestoDefinitivo ,SEG.ObservacionesDefinitivo
			  FROM [PAT].[Seguimiento] SEG
			  INNER JOIN dbo.Usuario USU ON SEG.IdUsuario = USU.Id
			  WHERE USU.IdMunicipio = [PAT].[fn_GetIdMunicipio](@DivipolaMunicipio)
			) AS SM ON SM.IdTablero = P.IdTablero AND SM.IdPregunta = P.Id
			WHERE	P.Nivel = 3 
			AND P.IdTablero	= @IdTablero	
			AND P.Activo = 1
			ORDER BY P.ID

	END
	ELSE
	BEGIN

	SELECT DISTINCT 
			P.Id AS IdPregunta, 
			P.IdTablero AS IdTablero,					
			R.Id as IdRespuesta,
			@DivipolaMunicipio as DivipolaMunicipio, 
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
			FROM [PAT].[SeguimientoProgramas] AS PROGRAMA
			WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento  and NumeroSeguimiento =1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSeguimiento
			
			--adicionales
			,SM.ObservacionesSegundo AS ObservacionesSegundoSeguimiento
			,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].[SeguimientoProgramas] AS PROGRAMA
			WHERE SM.[IdSeguimiento] = PROGRAMA.IdSeguimiento  and NumeroSeguimiento =2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimiento
			--,CONVERT(decimal, ISNULL( REPLACE(isnull(SM.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(SM.CantidadSegundo,0), -1, 0),0)) as CantidadTotalSeguimiento
			--,CONVERT(decimal,  ISNULL( REPLACE(isnull(SM.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(SM.PresupuestoSegundo,0), -1, 0),0)) as PresupuestoTotalSeguimiento
			,SM.CantidadPrimer +  SM.CantidadSegundo as CantidadTotalSeguimiento
			,SM.PresupuestoPrimer + SM.PresupuestoSegundo as PresupuestoTotalSeguimiento
			,SM.CompromisoDefinitivo,SM.PresupuestoDefinitivo ,SM.ObservacionesDefinitivo
			FROM  [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id
			LEFT OUTER JOIN PAT.RespuestaPAT AS R on P.Id = R.IdPreguntaPAT AND R.IdMunicipio = [PAT].[fn_GetIdMunicipio](@DivipolaMunicipio)
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
				  ,SEG.CompromisoDefinitivo,SEG.PresupuestoDefinitivo ,SEG.ObservacionesDefinitivo
			  FROM [PAT].[Seguimiento] SEG
			  INNER JOIN dbo.Usuario USU ON SEG.IdUsuario = USU.Id
			  WHERE USU.IdMunicipio = [PAT].[fn_GetIdMunicipio](@DivipolaMunicipio)
			) AS SM ON SM.IdTablero = P.IdTablero AND SM.IdPregunta = P.Id
			WHERE	P.Nivel = 3 
			AND D.Id = @IdDerecho	
			AND P.IdTablero	= @IdTablero	
			AND P.Activo = 1
			ORDER BY P.ID

	END

			
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService] AS'
GO
-- =============================================
-- Author:			Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Andrés Bonilla
-- Modifica:		Grupo Desarrollo OIM - Vilma Rodriguez
-- Create date:		14/11/2017
-- Modified date:	06/02/2018
-- Modify Date:		22/02/2018
-- Modified date:	01/06/2018
-- Description:		Retorna los datos del consolidado del seguimiento departamental 
--					del tablero PAT Indicado, por derecho y Divipola
-- Modificacion:	Se modifica para hacer opcional el parámetro IdDerecho
-- Modificacion:	Se modifica para agregar los campos de ajuste de planeacion
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosConsolidadoMunicipiosSeguimientoGobernacionesWebService] --1, null, 5172
(
	@IdTablero int, 
	@IdDerecho int, 
	@DivipolaDepartamento int
)
AS
BEGIN
	SET NOCOUNT ON;	

	IF @IdDerecho IS NULL OR @IdDerecho = 0 OR @IdDerecho = -1
	BEGIN

	SELECT DISTINCT
		a.Id as IdPregunta
		,a.IdDerecho
		,b.Descripcion AS Derecho
		,rm.IdMunicipio AS DivipolaMunicipio
		,rm.IdDepartamento AS DivipolaDepartamento

		,rm.RespuestaIndicativa AS RespuestaIndicativaMunicipio
		,rm.RespuestaCompromiso AS RespuestaCompromisoMunicipio
		,CONVERT(FLOAT, rm.Presupuesto) AS PresupuestoMunicipio
		,rm.ObservacionNecesidad AS ObservacionMunicipio
		,rm.AccionCompromiso AS AccionCompromisoMunicipio

		--,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATAccion AS ACCION
		--WHERE rm.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesMunicipio,	
						
		--STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		--WHERE rm.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasMunicipio	

		,rd.RespuestaCompromiso AS RespuestaCompromisoGobernacion
		,CONVERT(FLOAT, rd.Presupuesto) AS PresupuestoGobernacion
		,rd.ObservacionCompromiso AS ObservacionCompromisoGobernacion

		--,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATAccion AS ACCION
		--WHERE rdd.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesDepartamento,
							
		--STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		--WHERE rdd.ID = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasDepartamento	

		,sm.CantidadPrimer AS SeguimientoPrimerSemestreMunicipio
		,sm.CantidadSegundo AS SeguimientoSegundoSemestreMunicipio
		,CONVERT(FLOAT, sm.PresupuestoPrimer) AS SeguimientoPresupuestoPrimerSemestreMunicipio
		,CONVERT(FLOAT, sm.PresupuestoSegundo) AS SeguimientoPresupuestoSegundoSemestreMunicipio

		,sd.CantidadPrimer AS SeguimientoPrimerSemestreGobernacion
		,sd.CantidadSegundo AS SeguimientoSegundoSemestreGobernacion
		,CONVERT(FLOAT, sd.PresupuestoPrimer) AS SeguimientoPresupuestoPrimerSemestreGobernacion
		,CONVERT(FLOAT, sd.PresupuestoSegundo) AS SeguimientoPresupuestoSegundoSemestreGobernacion

		--adicionales
		,sd.Observaciones AS ObservacionesPrimerSeguimientoGobernacion
		,sd.ObservacionesSegundo AS ObservacionesSegundoSeguimientoGobernacion

		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =sd.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =sd.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			
		--, CONVERT(FLOAT, REPLACE(isnull(sd.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(sd.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimientoGobernacion
		--, CONVERT(FLOAT,  REPLACE(isnull(sd.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(sd.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimientoGobernacion
		--, CONVERT(FLOAT, REPLACE(isnull(sm.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(sm.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimientoMunicipio
		--, CONVERT(FLOAT,  REPLACE(isnull(sm.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(sm.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimientoMunicipio
		,sd.CantidadPrimer +  sd.CantidadSegundo as CantidadTotalSeguimientoGobernacion
		,sd.PresupuestoPrimer + sd.PresupuestoSegundo as PresupuestoTotalSeguimientoGobernacion
		,sm.CantidadPrimer +  sm.CantidadSegundo as CantidadTotalSeguimientoMunicipio
		,sm.PresupuestoPrimer + sm.PresupuestoSegundo as PresupuestoTotalSeguimientoMunicipio
		
		, sm.CompromisoDefinitivo,sm.PresupuestoDefinitivo ,sm.ObservacionesDefinitivo
		, sd.CompromisoDefinitivo CompromisoDefinitivoGobernacion,sd.PresupuestoDefinitivo PresupuestoDefinitivoGobernacion ,sd.ObservacionesDefinitivo ObservacionesDefinitivoGobernacion

	FROM [PAT].[PreguntaPAT] a
		INNER JOIN [PAT].[Derecho] b ON a.IdDerecho = b.Id
		LEFT OUTER JOIN [PAT].[RespuestaPAT] rm ON a.Id = rm.IdPreguntaPAT AND rm.IdMunicipio IN (select xx.Id FROM dbo.Municipio xx WHERE xx.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento))
		LEFT OUTER JOIN [PAT].[RespuestaPATDepartamento] rd ON a.Id = rd.IdPreguntaPAT AND rd.IdMunicipioRespuesta = rm.IdMunicipio
		--LEFT OUTER JOIN [PAT].[RespuestaPAT] rdd ON a.Id = rd.IdPreguntaPAT AND rdd.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento)
		LEFT OUTER JOIN [PAT].[Seguimiento] sm ON a.Id = sm.IdPregunta AND sm.IdUsuario = [PAT].[fn_GetIdUsuarioMunicipio](rm.IdMunicipio)
		LEFT OUTER JOIN [PAT].[SeguimientoGobernacion] sd ON a.Id = sd.IdPregunta AND sd.IdUsuarioAlcaldia = [PAT].[fn_GetIdUsuarioMunicipio](rm.IdMunicipio) AND sd.IdUsuario = [PAT].[fn_GetIdUsuarioDepartamento](rm.IdDepartamento)
	WHERE 
		a.IdTablero = @IdTablero
		AND a.Nivel = 3
		AND a.Activo = 1
	ORDER BY 
		a.Id ASC, rm.IdMunicipio ASC

	END
	ELSE
	BEGIN

	SELECT DISTINCT
		a.Id as IdPregunta
		,a.IdDerecho
		,b.Descripcion AS Derecho
		,rm.IdMunicipio AS DivipolaMunicipio
		,rm.IdDepartamento AS DivipolaDepartamento

		,rm.RespuestaIndicativa AS RespuestaIndicativaMunicipio
		,rm.RespuestaCompromiso AS RespuestaCompromisoMunicipio
		,CONVERT(FLOAT, rm.Presupuesto) AS PresupuestoMunicipio
		,rm.ObservacionNecesidad AS ObservacionMunicipio
		,rm.AccionCompromiso AS AccionCompromisoMunicipio

		--,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATAccion AS ACCION
		--WHERE rm.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesMunicipio,	
						
		--STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		--WHERE rm.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasMunicipio	

		,rd.RespuestaCompromiso AS RespuestaCompromisoGobernacion
		,CONVERT(FLOAT, rd.Presupuesto) AS PresupuestoGobernacion
		,rd.ObservacionCompromiso AS ObservacionCompromisoGobernacion

		--,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATAccion AS ACCION
		--WHERE rdd.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionesDepartamento,
							
		--STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		--FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		--WHERE rdd.ID = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasDepartamento	

		,sm.CantidadPrimer AS SeguimientoPrimerSemestreMunicipio
		,sm.CantidadSegundo AS SeguimientoSegundoSemestreMunicipio
		,CONVERT(FLOAT, sm.PresupuestoPrimer) AS SeguimientoPresupuestoPrimerSemestreMunicipio
		,CONVERT(FLOAT, sm.PresupuestoSegundo) AS SeguimientoPresupuestoSegundoSemestreMunicipio

		,sd.CantidadPrimer AS SeguimientoPrimerSemestreGobernacion
		,sd.CantidadSegundo AS SeguimientoSegundoSemestreGobernacion
		,CONVERT(FLOAT, sd.PresupuestoPrimer) AS SeguimientoPresupuestoPrimerSemestreGobernacion
		,CONVERT(FLOAT, sd.PresupuestoSegundo) AS SeguimientoPresupuestoSegundoSemestreGobernacion

		--adicionales
		,sd.Observaciones AS ObservacionesPrimerSeguimientoGobernacion
		,sd.ObservacionesSegundo AS ObservacionesSegundoSeguimientoGobernacion

		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =sd.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoGobernacionProgramas AS SMP
		WHERE SMP.IdSeguimiento =sd.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			
		--, CONVERT(FLOAT, REPLACE(isnull(sd.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(sd.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimientoGobernacion
		--, CONVERT(FLOAT,  REPLACE(isnull(sd.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(sd.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimientoGobernacion
		--, CONVERT(FLOAT, REPLACE(isnull(sm.CantidadPrimer,0), -1, 0)  +   REPLACE(isnull(sm.CantidadSegundo,0), -1, 0) ) as CantidadTotalSeguimientoMunicipio
		--, CONVERT(FLOAT,  REPLACE(isnull(sm.PresupuestoPrimer,0), -1, 0)  +   REPLACE(isnull(sm.PresupuestoSegundo,0), -1, 0))  as PresupuestoTotalSeguimientoMunicipio
		,sd.CantidadPrimer +  sd.CantidadSegundo as CantidadTotalSeguimientoGobernacion
		,sd.PresupuestoPrimer + sd.PresupuestoSegundo as PresupuestoTotalSeguimientoGobernacion
		,sm.CantidadPrimer +  sm.CantidadSegundo as CantidadTotalSeguimientoMunicipio
		,sm.PresupuestoPrimer + sm.PresupuestoSegundo as PresupuestoTotalSeguimientoMunicipio

		, sm.CompromisoDefinitivo,sm.PresupuestoDefinitivo ,sm.ObservacionesDefinitivo
		, sd.CompromisoDefinitivo CompromisoDefinitivoGobernacion,sd.PresupuestoDefinitivo PresupuestoDefinitivoGobernacion ,sd.ObservacionesDefinitivo ObservacionesDefinitivoGobernacion

	FROM [PAT].[PreguntaPAT] a
		INNER JOIN [PAT].[Derecho] b ON a.IdDerecho = b.Id
		LEFT OUTER JOIN [PAT].[RespuestaPAT] rm ON a.Id = rm.IdPreguntaPAT AND rm.IdMunicipio IN (select xx.Id FROM dbo.Municipio xx WHERE xx.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento))
		LEFT OUTER JOIN [PAT].[RespuestaPATDepartamento] rd ON a.Id = rd.IdPreguntaPAT AND rd.IdMunicipioRespuesta = rm.IdMunicipio
		--LEFT OUTER JOIN [PAT].[RespuestaPAT] rdd ON a.Id = rd.IdPreguntaPAT AND rdd.IdDepartamento = PAT.fn_GetIdDepartamento(@DivipolaDepartamento)
		LEFT OUTER JOIN [PAT].[Seguimiento] sm ON a.Id = sm.IdPregunta AND sm.IdUsuario = [PAT].[fn_GetIdUsuarioMunicipio](rm.IdMunicipio)
		LEFT OUTER JOIN [PAT].[SeguimientoGobernacion] sd ON a.Id = sd.IdPregunta AND sd.IdUsuarioAlcaldia = [PAT].[fn_GetIdUsuarioMunicipio](rm.IdMunicipio) AND sd.IdUsuario = [PAT].[fn_GetIdUsuarioDepartamento](rm.IdDepartamento)
	WHERE 
		a.IdTablero = @IdTablero
		AND b.Id = @IdDerecho
		AND a.Nivel = 3
		AND a.Activo = 1
	ORDER BY 
		a.Id ASC, rm.IdMunicipio ASC

	END

END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_AvanceTableroSeguimientoMunicipioWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_AvanceTableroSeguimientoMunicipioWebService] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Andrés Bonilla
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		14/11/2017
-- Modified date:	01/06/2018
-- Description:		Obtiene los porcentajes de avance del seguimiento de la gestión del tablero PAT por municipio 
-- =============================================
ALTER PROC  [PAT].[C_AvanceTableroSeguimientoMunicipioWebService]
( @DivipolaMunicipio INT ,@IdTablero INT )
AS
BEGIN
	declare @IdMunicipio int
	declare @IdUsuario int

	select @IdUsuario = PAT.fn_GetIdUsuarioMunicipio(@DivipolaMunicipio)
	select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

	SELECT 	A.Derecho
	,ISNULL(CONVERT(INT, CASE WHEN ROUND(CASE A.rc WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.rc)) * 100) END, 0) > 100 THEN 100 ELSE ROUND(CASE A.rc WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.rc)) * 100) END, 0) END),0) AS AvanceCompromiso
	,ISNULL(CONVERT(INT, CASE WHEN ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0) > 100 THEN 100 ELSE ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0) END),0) AS AvancePresupuesto
	FROM
	(
		SELECT	D.Descripcion AS Derecho
		,SUM(C.PresupuestoPrimer) as p1
		,SUM(C.PresupuestoSegundo) as p2
		,SUM(case when R.RespuestaIndicativa is null then 0 else r.RespuestaIndicativa end) as ri
		--,SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end) as rc
		--,SUM(case when R.Presupuesto is null then 0 else r.Presupuesto end) as pres
		,SUM(case when C.CompromisoDefinitivo is null then 0 else C.CompromisoDefinitivo end) as rc
		,SUM(case when C.PresupuestoDefinitivo is null then 0 else C.PresupuestoDefinitivo end) as pres
		,(SUM(case when C.CantidadPrimer is null or C.CantidadPrimer = -1 then 0 else C.CantidadPrimer end) + SUM(case when C.CantidadSegundo is null or C.CantidadSegundo = -1 then 0 else C.CantidadSegundo end)) as sumc1c2
		,(SUM(case when C.PresupuestoPrimer is null or C.PresupuestoPrimer = -1 then 0 else C.PresupuestoPrimer end) + SUM(case when C.PresupuestoSegundo is null or C.PresupuestoSegundo = -1 then 0 else C.PresupuestoSegundo end)) as sump1p2
		FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
		join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		INNER JOIN [PAT].[Derecho] (NOLOCK) D ON P.IDDERECHO = D.ID 
		INNER JOIN PAT.Tablero (NOLOCK) AS T ON P.IDTABLERO = T.ID				
		LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON R.IdMunicipio = @IdMunicipio  and P.ID = R.[IdPreguntaPAT]	
		LEFT OUTER JOIN [PAT].Seguimiento as C ON C.IdPregunta = P.Id and C.IdUsuario = @IdUsuario
		WHERE	P.NIVEL = 3 
		AND T.ID = @idTablero
		and P.ACTIVO = 1		
		group by D.Descripcion
	) AS A
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDepartamentoAvance]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDepartamentoAvance] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	14/11/2017
-- Modified date:	01/06/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos y los datos de ajuste de planeacion
-- =============================================
alter PROC  [PAT].[C_TableroSeguimientoDepartamentoAvance]-- [PAT].[C_TableroSeguimientoDepartamentoAvance] 431, 1
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
			--,SUM(case when R.Presupuesto is null then 0 else r.Presupuesto end) as pres
			,SUM(case when C.PresupuestoDefinitivo is null then 0 else C.PresupuestoDefinitivo end) as pres
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
			--,SUM(case when RD.RespuestaCompromiso is null then 0 else RD.RespuestaCompromiso end) as ri
			--,SUM(case when RD.Presupuesto is null then 0 else RD.Presupuesto end) as pres
			,SUM(case when SG.CompromisoDefinitivo is null then 0 else SG.CompromisoDefinitivo end) as ri
			,SUM(case when SG.PresupuestoDefinitivo is null then 0 else SG.PresupuestoDefinitivo end) as pres
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosSeguimientoDepartamentoPorId]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosSeguimientoDepartamentoPorId] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	26/01/2018
-- Modified date:	01/06/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental
-- =============================================
ALTER PROC  [PAT].[C_DatosSeguimientoDepartamentoPorId] -- [PAT].[C_DatosSeguimientoDepartamento] 1, 1013
( @idSeguimiento int)
AS
BEGIN				
		select IdSeguimiento, IdUsuarioAlcaldia, 
		CantidadPrimer, CantidadSegundo, FechaSeguimiento,IdPregunta,  
		IdTablero, IdUsuario, NombreAdjunto, Observaciones, PresupuestoPrimer,PresupuestoSegundo,
		ObservacionesSegundo, NombreAdjuntoSegundo
		,CompromisoDefinitivo,PresupuestoDefinitivo ,ObservacionesDefinitivo 
		from pat.SeguimientoGobernacion as S
		where S.IdSeguimiento = @idSeguimiento
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] AS'
GO	
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	13/03/2018
-- Modified date:	01/06/2018
-- Description:		Obtiene informacion para el excel del seguimiento departamental para la hoja "Información Municipios"
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] --[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] 431, 1
(@IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare  @IdDepartamento int, @Departamento varchar(150)
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	select @Departamento = Nombre from Departamento where Id = @IdDepartamento

	SELECT 	P.*	FROM
	(
			SELECT DISTINCT
			A.Id AS IdPregunta
			,0 AS IdAccion
			,0 AS IdPrograma
			,RM.IdMunicipio
			,@Departamento AS Departamento
			,m.Nombre as Municipio
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
			,RDM.RespuestaCompromiso AS RespuestaCompromisoDepartamento
			,RDM.Presupuesto AS PresupuestoDepartamento
			,RDM.ObservacionCompromiso AS ObservacionDepartamento
			--,RDA.Accion AS AccionDepartamento
			--,RDP.Programa AS ProgramaDepartamento
			,STUFF((SELECT CAST( RDA.Accion  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].RespuestaPATAccion AS RDA
			WHERE RDA.IdRespuestaPAT = RDM.Id FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS AccionDepartamento	

			,STUFF((SELECT CAST( RDP.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].RespuestaPATPrograma AS RDP
			WHERE RDP.IdRespuestaPAT = RDM.Id FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramaDepartamento	

			,SM.CantidadPrimer  AS CantidadPrimerSeguimientoAlcaldia
			,REPLACE(SM.CantidadSegundo, -1, 0) AS CantidadSegundoSeguimientoAlcaldia
			,SM.PresupuestoPrimer AS PresupuestoPrimerSeguimientoAlcaldia
			,REPLACE(SM.PresupuestoSegundo, -1, 0) AS PresupuestoSegundoSeguimientoAlcaldia

			,(SM.CantidadPrimer + REPLACE(SM.CantidadSegundo, -1, 0)) AS AvanceCantidadAlcaldia
			,(SM.PresupuestoPrimer + REPLACE(SM.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoAlcaldia
			,SM.Observaciones AS ObservacionesSeguimientoAlcaldia

			,SG.CantidadPrimer  AS CantidadPrimerSeguimientoGobernacion
			,REPLACE(SG.CantidadSegundo, -1, 0) AS CantidadSegundoSeguimientoGobernacion
			,SG.PresupuestoPrimer AS PresupuestoPrimerSeguimientoGobernacion
			,REPLACE(SG.PresupuestoSegundo, -1, 0) AS PresupuestoSegundoSeguimientoGobernacion


			,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
			,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
			,SG.Observaciones AS ObservacionesSeguimientoGobernacion

			,SG.ObservacionesSegundo AS ObservacionesSegundoSeguimientoGobernacion
			,SM.ObservacionesSegundo AS ObservacionesSegundoSeguimientoAlcaldia

			,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].SeguimientoProgramas AS SMP
			WHERE SMP.IdSeguimiento =SM.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimero			
			,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].SeguimientoProgramas AS SMP
			WHERE SMP.IdSeguimiento =SM.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundo			

			,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].SeguimientoGobernacionProgramas AS SMP
			WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimeroSeguimientoGobernacion			
			,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
			FROM [PAT].SeguimientoGobernacionProgramas AS SMP
			WHERE SMP.IdSeguimiento =SG.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundoSeguimientoGobernacion			

			, SM.CompromisoDefinitivo,SM.PresupuestoDefinitivo ,SM.ObservacionesDefinitivo
			, SG.CompromisoDefinitivo CompromisoDefinitivoGobernacion,SG.PresupuestoDefinitivo PresupuestoDefinitivoGobernacion ,SG.ObservacionesDefinitivo ObservacionesDefinitivoGobernacion

			FROM [PAT].PreguntaPAT A (nolock)
			INNER JOIN [PAT].Derecho B ON B.Id = A.IdDerecho
			INNER JOIN [PAT].Componente C ON C.Id = A.IdComponente
			INNER JOIN [PAT].Medida D ON D.ID = A.IdMedida
			INNER JOIN [PAT].UnidadMedida E ON E.Id = A.IdUnidadMedida
			JOIN [PAT].RespuestaPAT RM (nolock) ON RM.IdPreguntaPAT = A.Id and RM.IdDepartamento =@IdDepartamento
			JOIN Municipio AS M ON RM.IdMunicipio = M.Id			
			--LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA (nolock) ON RMA.IdRespuestaPAT = RM.Id
			--LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP (nolock) ON RMP.IdRespuestaPAT = RM.Id
			LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RDM (nolock) ON  RM.IdMunicipio =RDM.IdMunicipioRespuesta AND  A.Id =RDM.IdPreguntaPAT  and RDM.IdUsuario =@IdUsuario			
			LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = A.ID AND SM.IdUsuario =RM.IdUsuario
			LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG (nolock) ON SG.IdPregunta = A.ID AND SG.IdUsuario = @IdUsuario AND SG.IdUsuarioAlcaldia = RM.IdUsuario			
			WHERE A.IdTablero = @IdTablero
			AND A.Activo = 1
			AND A.NIVEL = 3
			AND M.IdDepartamento =@IdDepartamento
	) AS P
	ORDER BY P.Departamento, P.Municipio
END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosDepartamentalesSeguimientoWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosDepartamentalesSeguimientoWebService] AS'
GO	
-- =============================================
-- Author:			Grupo Desarrollo - Andrés Bonilla - Vilma Rodriguez
-- Create date:		10/11/2017
-- Modified date:	26/03/2018
-- Modified date:	01/06/2018
-- Description:		Retorna los datos del seguimiento del tablero PAT Departamental Indicado, por Divipola
-- =============================================	
ALTER PROCEDURE [PAT].[C_DatosDepartamentalesSeguimientoWebService] --[PAT].[C_DatosDepartamentalesSeguimientoWebService] 1, 5
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
				,SM.CompromisoDefinitivo,SM.PresupuestoDefinitivo ,SM.ObservacionesDefinitivo
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
				  ,SEG.CompromisoDefinitivo,SEG.PresupuestoDefinitivo ,SEG.ObservacionesDefinitivo
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_EnvioTableroPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_EnvioTableroPat] AS'
GO	
/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez
/Modifica: Equipo OIM	- Andrés Bonilla																	  
/Modifica: Equipo OIM	- vilma rodriguez																	  
/Fecha creacion:     2017-12-11	
/Fecha modificacion :2018-02-14
/Fecha modificacion :2018-03-09
/Fecha modificacion :2018-04-30
/Modified date:	01/06/2018
/Descripcion: Inserta los datos de envio de los tres tipos de tablero: Planeacion Municipal "PM", Planeacion Departamental "PD"
/, Primer Seguimiento Municpal "SM1", Segundo Seguimiento Municpal "SM2"						  
/, Primer Seguimiento Departamental "SD1", Segundo Seguimiento Departamental "SD2"	
/Modificacion: Se cambia la validación de envío de SM2					  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_EnvioTableroPat] --1460, 2, 'PD'
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
		IF NOT EXISTS (Select 1 from @UsuariosSinPlaneacion WHERE IdUsuario = @IdUsuario)
		BEGIN
			--Usuarios que no diligenciaron planeacion pueden enviar SM1 o SM2 sin problemas
			SET @guardoPreguntas = 1
		END
		ELSE
		BEGIN
			
			declare @cantPreguntas1 int

			select @cantPreguntas1 = count(a.Id)
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
			having (@cantPreguntas1 - SUM(case when a.RespuestaCompromiso is null then 0 when a.RespuestaCompromiso = 0 then 0 else 1 end)) = 100
			)
			BEGIN
				--Usuarios que llenaron todo en 0 pueden enviar SM1 y SM2 sin problema
				SET @guardoPreguntas = 1
			END
			ELSE
			BEGIN
				
				DECLARE @CantPreguntasSeguimiento1 INT

				--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
				DECLARE @PreguntasPlaneacion1 TABLE
				(
					IdPreguntaPAT INT				
				)

				INSERT INTO @PreguntasPlaneacion1
				SELECT a.IdPreguntaPAT
				FROM PAT.RespuestaPAT a
				INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
				WHERE
				b.IdTablero = @IdTablero
				AND a.IdUsuario = @IdUsuario
				AND b.Activo = 1 and b.Nivel = 3
				AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)


				SELECT @CantPreguntasSeguimiento1 = COUNT(DISTINCT IdPregunta)
				FROM PAT.Seguimiento
				WHERE IdPregunta IN (
					SELECT IdPreguntaPAT
					FROM @PreguntasPlaneacion1
				) 
				AND IdUsuario = @IdUsuario
				AND IdTablero = @IdTablero
				AND (CantidadPrimer >= 0 OR PresupuestoPrimer >= 0)				

				SELECT @guardoPreguntas = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimiento1 THEN 1 ELSE 0 END
				FROM @PreguntasPlaneacion1
			END
		END
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
			having (@cantPreguntas - SUM(case when a.RespuestaCompromiso is null then 0 when a.RespuestaCompromiso = 0 then 0 else 1 end)) = 100
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
				and CompromisoDefinitivo >0 and PresupuestoDefinitivo > 0

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
			declare @cantPreguntasGob1 int

			select @cantPreguntasGob1 = count(a.Id)
			from pat.PreguntaPAT a
			where a.IdTablero = @IdTablero and a.Activo = 1 and a.Nivel = 2

			DECLARE @CantPreguntasSeguimientoGob1 INT
			--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
			DECLARE @PreguntasPlaneacionGob1 TABLE (IdPreguntaPAT INT)

			INSERT INTO @PreguntasPlaneacionGob1--inserta las preguntas con respuestas  de la planeacion que dio ese usuario con compromiso >0
			SELECT a.IdPreguntaPAT
			FROM PAT.RespuestaPAT a
			INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
			WHERE b.IdTablero = @IdTablero
			AND a.IdUsuario = @IdUsuario
			AND b.Activo = 1 and b.Nivel = 2
			AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)

			SELECT @CantPreguntasSeguimientoGob1 = COUNT(DISTINCT IdPregunta)
			--FROM PAT.SeguimientoGobernacion as SG
			FROM PAT.Seguimiento as SG
			join @PreguntasPlaneacionGob1 as PG on SG.IdPregunta = PG.IdPreguntaPAT 
			where SG.IdUsuario = @IdUsuario
			AND SG.IdTablero = @IdTablero
			AND (SG.CantidadPrimer >= 0 or SG.PresupuestoPrimer >= 0)			

			SELECT @guardoPreguntas = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimientoGob1 THEN 1 ELSE 0 END
			FROM @PreguntasPlaneacionGob1	
		end		
		-------------------------------------
		----PREGUNTAS CONSOLIDADO ALCALDIAS	
		-------------------------------------								
		DECLARE @CantPreguntasSeguimientoGobConsolidado1 INT
		DECLARE @PreguntasPlaneacionGobConsolidado1 TABLE (IdPreguntaPAT INT,IdUsuario int, IdDepartamento int, IdMunicipio int, IdUsuarioAlcaldia INT)--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento

		INSERT INTO @PreguntasPlaneacionGobConsolidado1--inserta las preguntas con respuestas que dio ese usuario con compromiso >0 or OR a.Presupuesto > 0
		SELECT a.IdPreguntaPAT, a.IdUsuario, m.IdDepartamento , a.IdMunicipioRespuesta
		,(select id from dbo.Usuario where IdMunicipio = a.IdMunicipioRespuesta and idestado = 5 and activo = 1 and IdTipoUsuario = 2)
		--, a.RespuestaCompromiso, a.Presupuesto
		FROM PAT.RespuestaPATDepartamento a
		join Municipio as m on a.IdMunicipioRespuesta = m.Id
		INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
		WHERE	b.IdTablero = @IdTablero AND b.Activo = 1 and b.Nivel = 3 And b.ApoyoDepartamental =1 AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0) 

		SELECT 
		@CantPreguntasSeguimientoGobConsolidado1 = COUNT(distinct P.Id)
		--D.Nombre as Departamento, M.Nombre as Municipio, Der.Descripcion as Derecho,P.Id as IdPregunta, P.PreguntaIndicativa , SEG.CantidadSegundo, SEG.PresupuestoSegundo
		--,SEG.IdSeguimiento
		-- count(PPG.IdPreguntaPAT)AS NUM_PREGUNTAS_CONTESTAR, COUNT(SEG.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		FROM @PreguntasPlaneacionGobConsolidado1 as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadPrimer >= 0 or SEG.PresupuestoPrimer >= 0)
		join Departamento as D on PPG.IdDepartamento = D.Id	
		JOIN Municipio AS M ON PPG.IdMunicipio = M.Id		
		WHERE P.IdTablero = 1 and SEG.IdSeguimiento is null	and PPG.IdDepartamento = @IdDepartamento
		--order by D.Nombre, M.Nombre


		SELECT @guardoPreguntasConsolidado = CASE WHEN @CantPreguntasSeguimientoGobConsolidado1 = 0 THEN 1 ELSE 0 END
	
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
			--FROM PAT.SeguimientoGobernacion as SG
			FROM PAT.Seguimiento as SG
			join @PreguntasPlaneacionGob as PG on SG.IdPregunta = PG.IdPreguntaPAT 
			where SG.IdUsuario = @IdUsuario
			AND SG.IdTablero = @IdTablero
			AND (SG.CantidadSegundo >= 0 or SG.PresupuestoSegundo >= 0)
			AND ObservacionesSegundo IS NOT NULL
			and CompromisoDefinitivo >0 and PresupuestoDefinitivo > 0

			SELECT @guardoPreguntas = CASE WHEN COUNT(IdPreguntaPAT) = @CantPreguntasSeguimientoGob THEN 1 ELSE 0 END
			FROM @PreguntasPlaneacionGob	
		end		
		-------------------------------------
		----PREGUNTAS CONSOLIDADO ALCALDIAS	
		-------------------------------------						
		--DECLARE @CantPreguntasSeguimientoGobConsolidado INT
		----Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento
		--DECLARE @PreguntasPlaneacionGobConsolidado TABLE (IdPreguntaPAT INT,IdUsuarioAlcaldia int)

		--INSERT INTO @PreguntasPlaneacionGobConsolidado--inserta las preguntas con respuestas que dio ese usuario con compromiso >0
		--SELECT a.IdPreguntaPAT, a.IdUsuario
		--FROM PAT.RespuestaPAT a
		--INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
		--WHERE	b.IdTablero = @IdTablero
		--and a.IdDepartamento= @IdDepartamento
		--AND b.Activo = 1 and b.Nivel = 3
		--And b.ApoyoDepartamental =1
		--AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0)

		--SELECT @CantPreguntasSeguimientoGobConsolidado = COUNT(IdPregunta)
		--FROM PAT.SeguimientoGobernacion as SEG
		--join @PreguntasPlaneacionGobConsolidado as PPG on SEG.IdPregunta = PPG.IdPreguntaPAT and SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia				
		--WHERE SEG.IdUsuario = @IdUsuario AND SEG.IdUsuarioAlcaldia <> 0 
		--AND IdTablero = @IdTablero
		--AND (CantidadSegundo >= 0 or PresupuestoSegundo >= 0)
		--AND ObservacionesSegundo IS NOT NULL


		DECLARE @CantPreguntasSeguimientoGobConsolidado INT
		DECLARE @PreguntasPlaneacionGobConsolidado TABLE (IdPreguntaPAT INT,IdUsuario int, IdDepartamento int, IdMunicipio int, IdUsuarioAlcaldia INT)--Acá se valida que si escribió planeación para X tantas preguntas, esas mismas tengan Seguimiento

		INSERT INTO @PreguntasPlaneacionGobConsolidado--inserta las preguntas con respuestas que dio ese usuario con compromiso >0 or OR a.Presupuesto > 0
		SELECT a.IdPreguntaPAT, a.IdUsuario, m.IdDepartamento , a.IdMunicipioRespuesta
		,(select id from dbo.Usuario where IdMunicipio = a.IdMunicipioRespuesta and idestado = 5 and activo = 1 and IdTipoUsuario = 2)
		--, a.RespuestaCompromiso, a.Presupuesto
		FROM PAT.RespuestaPATDepartamento a
		join Municipio as m on a.IdMunicipioRespuesta = m.Id
		INNER JOIN PAT.PreguntaPAT b ON a.IdPreguntaPAT = b.Id
		WHERE	b.IdTablero = @IdTablero AND b.Activo = 1 and b.Nivel = 3 And b.ApoyoDepartamental =1 AND (a.RespuestaCompromiso > 0 OR a.Presupuesto > 0) 

		SELECT 
		@CantPreguntasSeguimientoGobConsolidado = COUNT(distinct P.Id)
		--D.Nombre as Departamento, M.Nombre as Municipio, Der.Descripcion as Derecho,P.Id as IdPregunta, P.PreguntaIndicativa , SEG.CantidadSegundo, SEG.PresupuestoSegundo
		--,SEG.IdSeguimiento
		-- count(PPG.IdPreguntaPAT)AS NUM_PREGUNTAS_CONTESTAR, COUNT(SEG.IdSeguimiento) AS NUM_PREGUNTAS_RESPONDIDAS_COMPROMISO
		FROM @PreguntasPlaneacionGobConsolidado as PPG 
		join [PAT].[PreguntaPAT] AS P on PPG.IdPreguntaPAT = p.Id
		JOIN [PAT].[Derecho] Der ON P.IdDerecho = Der.Id
		left outer join PAT.SeguimientoGobernacion as SEG on PPG.IdPreguntaPAT =SEG.IdPregunta  and  SEG.IdUsuarioAlcaldia = PPG.IdUsuarioAlcaldia AND SEG.IdUsuarioAlcaldia <> 0 AND (SEG.CantidadSegundo >= 0 or SEG.PresupuestoSegundo >= 0) AND SEG.ObservacionesSegundo IS NOT NULL and CompromisoDefinitivo >0 and PresupuestoDefinitivo > 0
		join Departamento as D on PPG.IdDepartamento = D.Id	
		JOIN Municipio AS M ON PPG.IdMunicipio = M.Id		
		WHERE P.IdTablero = 1 and SEG.IdSeguimiento is null	and PPG.IdDepartamento = @IdDepartamento
		--order by D.Nombre, M.Nombre


		SELECT @guardoPreguntasConsolidado = CASE WHEN @CantPreguntasSeguimientoGobConsolidado = 0 THEN 1 ELSE 0 END
	
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
