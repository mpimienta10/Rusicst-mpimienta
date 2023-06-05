----------------------------------------------------------------------------------------------------------------------------------------------------------------
---mejoras en seguimiento departamental
----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez -Vilma rodriguez
-- Create date:		29/08/2017
-- Modified date:	24/01/2018
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
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
		where a.IdTablero = @IdTablero
		and a.NIVEL = 2
		order by a.Id  asc
END

go	

if not exists (select * from sys.columns where name='ObservacionesSegundo'  and Object_id in (select object_id from sys.tables where name ='SeguimientoGobernacion'))
begin 	
	ALTER TABLE [PAT].[SeguimientoGobernacion] ADD [ObservacionesSegundo] varchar(max) null
	ALTER TABLE [PAT].[SeguimientoGobernacion] ADD [NombreAdjuntoSegundo] varchar(200) null
end
go
if not exists (select * from sys.columns where name='NumeroSeguimiento'  and Object_id in (select object_id from sys.tables where name ='SeguimientoGobernacionProgramas'))
begin 	
	ALTER TABLE [PAT].[SeguimientoGobernacionProgramas] ADD [NumeroSeguimiento] tinyint  null	
end
go

update [PAT].[SeguimientoGobernacionProgramas] set NumeroSeguimiento = 1 where NumeroSeguimiento is null

go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/08/2017
-- Modified date:	24/01/2018
-- Description:		Retorna los programas de un seguimiento
-- =============================================
ALTER PROC  [PAT].[C_ProgramasSeguimientoDepartamento]
(@IdSeguimiento int)
as
begin 
	select IdSeguimientoPrograma, IdSeguimiento, Programa , NumeroSeguimiento
	from pat.SeguimientoGobernacionProgramas 
	where IdSeguimiento = @IdSeguimiento
end

GO

/*****************************************************************************************************
/Autor: Equipo OIM	 - Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Fecha modificacion: 2018-01-24																			  
/Descripcion: Inserta la información del seguimiento municipal de los programas relacionados												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_SeguimientoDepartamentoProgramaInsert] 
		@IdSeguimiento int
		,@Programa varchar(200)
		,@NumeroSeguimiento tinyint
AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		

			INSERT INTO [PAT].SeguimientoGobernacionProgramas
					   ([IdSeguimiento]
					   ,[Programa]
					   ,[NumeroSeguimiento])
				 VALUES
					   (@IdSeguimiento,@Programa,@NumeroSeguimiento)
			
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH	

	select @respuesta as respuesta, @estadoRespuesta as estado
go		

/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Fecha modificacion: 2018-01-24																			  
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
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	
	
	if (@CantidadSegundo = -1)
		set @CantidadSegundo = 0
		
	if (@PresupuestoSegundo = -1)
		set @PresupuestoSegundo = 0
					
	if(@esValido = 1) 
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
				   ,[NombreAdjuntoSegundo])
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
				   ,@NombreAdjuntoSegundo)						
		
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


/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Fecha modificacion: 2018-01-24																			  
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
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	
		
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



-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	24/01/2018
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
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion as f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
	where a.ID = @IdPregunta
END

go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	25/01/2018
-- Description:		Obtiene informacion para el seguimiento para el detalle del consolidado para los municipios que respondieron la pregunta indicada
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] --pat.C_TableroSeguimientoDetalleConsolidadoDepartamento 4,375,21
( @IdTablero INT ,@IdUsuario INT ,@IdPregunta INT )
AS
BEGIN
	declare @IdMunicipio int, @IdDepartamento int
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

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
	,(SELECT TOP 1 XX.Id FROM [PAT].RespuestaPAT XX  
							join pat.PreguntaPAT as p on XX.IdPreguntaPAT = p.Id
							WHERE XX.IdMunicipio = @IdMunicipio and XX.IdPreguntaPAT = @IdPregunta and p.IdTablero = @IdTablero) AS IdRespuestaDepartamentoMunicipio
	,ISNULL(SG.CantidadPrimer, -1) AS CantidadPrimerSemestreGobernaciones
	,ISNULL(SG.CantidadSegundo, -1) AS CantidadSegundoSemestreGobernaciones
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

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/08/2017
-- Modified date:	25/01/2018
-- Description:		Retorna el numero de seguimiento de acuerdo al momento en el que se llame el procedimiento
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoMunicipioReparacionColectiva]--[PAT].[C_TableroSeguimientoMunicipioReparacionColectiva] 1 , 360
(
	@IdTablero INT
	,@IdUsuario INT
)
AS
BEGIN
	declare @IdMunicipio int
	select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

	SELECT 	DISTINCT 
	A.Sujeto
	, B.DESCRIPCION AS Medida
	,C.ACCION AS AccionMunicipio
	,C.PRESUPUESTO AS PresupuestoMunicipio
	,D.AccionDepartamento
	,D.PresupuestoDepartamento
	,A.ID AS IdPregunta
	,A.IdMunicipio
	,A.IdMedida
	,C.ID AS IdRespuesta
	,A.IdTablero
	,D.ID AS IdRespuestaDepartamento
	,A.IdDepartamento--,D.ID_ENTIDAD AS ID_ENTIDAD_DPTO	
	,SMRC.IdSeguimientoRC as IdSeguimiento
	,SMRC.AvancePrimer AS AvancePrimerSemestreAlcaldia
	,SMRC.AvanceSegundo AS AvanceSegundoSemestreAlcaldia
	,SGRC.AvancePrimer AS AvancePrimerSemestreGobernacion
	,SGRC.AvanceSegundo AS AvanceSegundoSemestreGobernacion
	,SMRC.NombreAdjunto AS NombreAdjunto
	FROM [PAT].PreguntaPATReparacionColectiva AS A
	INNER JOIN [PAT].Medida B ON B.ID = A.IdMedida
	LEFT OUTER JOIN [PAT].RespuestaPATReparacionColectiva AS C ON A.Id = C.IdPreguntaPATReparacionColectiva
	LEFT OUTER JOIN [PAT].[RespuestaPATDepartamentoReparacionColectiva] AS D ON D.IdPreguntaPATReparacionColectiva = A.Id  AND D.IdMunicipioRespuesta = C.IdMunicipio
	--LEFT OUTER JOIN [PAT].SeguimientoGobernacionReparacionColectiva as f on a.Id = f.IdPregunta and f.IdUsuario = @IdUsuario
	LEFT OUTER JOIN [PAT].SeguimientoReparacionColectiva SMRC ON SMRC.IdTablero = A.IdTablero AND SMRC.IdUsuario = @IdUsuario AND SMRC.IdPregunta = A.Id
	LEFT OUTER JOIN [PAT].SeguimientoGobernacionReparacionColectiva SGRC ON SGRC.IdTablero = A.IdTablero AND SGRC.IdPregunta = C.IdPreguntaPATReparacionColectiva AND SGRC.IdUsuarioAlcaldia = C.IdUsuario
	WHERE A.IdTablero = @IdTablero
	and A.IdMunicipio = @IdMunicipio
	AND A.Activo = 1
	order by a.Id	 
END




go


-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/08/2017
-- Modified date:	25/01/2018
-- Description:		Retorna datos de la pregunta de retornos y reubivaciones para el tablero y municipio indicado
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoMunicipioRetornosReubicaciones] --[PAT].[C_TableroSeguimientoMunicipioRetornosReubicaciones]  2, 1513
(	@IdTablero INT	,@IdUsuario INT)
AS
BEGIN
	declare @IdMunicipio int
	select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

	SELECT 	A.Id, A.Hogares, A.Personas, A.Sector, A.Componente, A.Comunidad, A.Ubicacion, A.MedidaRetornoReubicacion, A.IndicadorRetornoReubicacion, A.EntidadResponsable, A.IdDepartamento, A.IdMunicipio, A.IdTablero
	,SMRC.IdSeguimientoRR as IdSeguimiento
	,SMRC.AvancePrimer AS AvancePrimerSemestreAlcaldia
	,SMRC.AvanceSegundo AS AvanceSegundoSemestreAlcaldia
	,SMRC.NombreAdjunto AS NombreAdjunto, M.Nombre AS Municipio
	FROM [PAT].PreguntaPATRetornosReubicaciones as A
	JOIN Municipio AS M ON A.IdMunicipio = M.Id
	LEFT OUTER JOIN [PAT].RespuestaPATRetornosReubicaciones AS C ON A.Id = C.IdPreguntaPATRetornoReubicacion
	LEFT OUTER JOIN [PAT].SeguimientoRetornosReubicaciones SMRC ON SMRC.IdTablero = A.IdTablero AND SMRC.IdUsuario = @IdUsuario AND SMRC.IdPregunta = A.Id
	WHERE A.IdMunicipio = @IdMunicipio
	AND A.IdTablero = @IdTablero
	and A.Activo = 1
END



go


-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	25/01/2018
-- Description:		Obtiene informacion para el seguimiento para el detalle del consolidado para los municipios que respondieron la pregunta indicada
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDetalleConsolidadoDepartamento] --pat.C_TableroSeguimientoDetalleConsolidadoDepartamento 4,375,21
( @IdTablero INT ,@IdUsuario INT ,@IdPregunta INT )
AS
BEGIN
	declare @IdMunicipio int, @IdDepartamento int
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

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
	,(SELECT TOP 1 XX.Id FROM [PAT].RespuestaPAT XX  
							join pat.PreguntaPAT as p on XX.IdPreguntaPAT = p.Id
							WHERE XX.IdMunicipio = @IdMunicipio and XX.IdPreguntaPAT = @IdPregunta and p.IdTablero = @IdTablero) AS IdRespuestaDepartamentoMunicipio
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
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez -Vilma rodriguez
-- Create date:		29/08/2017
-- Modified date:	26/01/2018
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
		from pat.SeguimientoGobernacion as S
		where S.IdSeguimiento = @idSeguimiento
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_SeguimientoNacionalPorDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_SeguimientoNacionalPorDepartamento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/11/2017
-- Modified date:	28/11/2017
-- Description:		Obtiene informacion del seguimiento municipal de la informacion de entidades nacionales.(esta pendiente de implementar dado que no se tiene informacion)
-- =============================================
ALTER PROC  [PAT].[C_SeguimientoNacionalPorDepartamento] 
( @IdDepartamento INT ,@IdPregunta INT )
AS
BEGIN
		
	declare @CompromisoN int, @PresupuestoN int, @CantidadPrimerSemestreN int,@CantidadSegundoSemestreN int,@PresupuestoPrimerSemestreN int,@PresupuestoSegundoSemestreN int, @CompromisoTotalN INT,@PresupuestoTotalN INT			
	select   @CompromisoN =0, @PresupuestoN = 0,@CantidadPrimerSemestreN = 0,@CantidadSegundoSemestreN = 0, @PresupuestoPrimerSemestreN = 0, @PresupuestoSegundoSemestreN = 0, @CompromisoTotalN = 0,@PresupuestoTotalN = 0				
	
	select   @CompromisoN as CompromisoN  , @PresupuestoN as PresupuestoN ,@CantidadPrimerSemestreN as CantidadPrimerSemestreN,@CantidadSegundoSemestreN as CantidadSegundoSemestreN , @PresupuestoPrimerSemestreN as PresupuestoPrimerSemestreN , @PresupuestoSegundoSemestreN as PresupuestoSegundoSemestreN , @CompromisoTotalN as CompromisoTotalN  ,@PresupuestoTotalN as PresupuestoTotalN
	
END

go