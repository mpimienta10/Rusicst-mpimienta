if not exists (select * from sys.columns where name='ObservacionesSegundo'  and Object_id in (select object_id from sys.tables where name ='Seguimiento'))
begin 	
	ALTER TABLE [PAT].[Seguimiento] ADD [ObservacionesSegundo] varchar(max) null
	ALTER TABLE [PAT].[Seguimiento] ADD [NombreAdjuntoSegundo] varchar(200) null
end
go

if not exists (select * from sys.columns where name='NumeroSeguimiento'  and Object_id in (select object_id from sys.tables where name ='SeguimientoProgramas'))
begin 	
	ALTER TABLE [PAT].[SeguimientoProgramas] ADD [NumeroSeguimiento] tinyint  null	
end
go

update [PAT].[SeguimientoProgramas] set NumeroSeguimiento = 1 where NumeroSeguimiento is null

go

/*****************************************************************************************************
/Autor: Equipo OIM	 - Vilma Rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Descripcion: Inserta la información del seguimiento municipal de los programas relacionados												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_SeguimientoMunicipalProgramaInsert] 
		@IdSeguimiento int
		,@Programa varchar(200)
		,@NumeroSeguimiento tinyint
AS 	
	
		declare @respuesta as nvarchar(2000) = ''
		declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
		BEGIN TRY		

			INSERT INTO [PAT].[SeguimientoProgramas]
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
		
	if(@esValido = 1) 
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
				   ,[NombreAdjuntoSegundo])
			 VALUES
				   (@IdTablero 
				   ,@IdPregunta 
				   ,@IdUsuario 
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
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	
		
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
-- Create date:		28/08/2017
-- Modified date:	28/08/2017
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
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma Rodriguez 
-- Create date:		28/08/2017
-- Modified date:	28/08/2017
-- Description:		Retorna los programas de un seguimiento
-- =============================================
ALTER PROC  [PAT].[C_ProgramasSeguimiento]--[PAT].[C_ProgramasSeguimiento] 1
(@IdSeguimiento int)
as
begin 
	select IdSeguimientoPrograma, IdSeguimiento, Programa , NumeroSeguimiento
	from pat.SeguimientoProgramas where IdSeguimiento = @IdSeguimiento
end
go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero municipal 
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoAlcaldias] --[PAT].[C_DatosExcelSeguimientoAlcaldias] 411, 3
( @IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare @IdMunicipio int, @IdDepartamento int
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

		SELECT
		A.Id AS IdPregunta
		,RMA.Id AS IdAccion
		,RMP.Id AS IdPrograma
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
		,RMA.Accion
		,RMP.Programa
		,(SM.CantidadPrimer + REPLACE(SM.CantidadSegundo, -1, 0)) AS AvanceCantidadAlcaldia
		,(SM.PresupuestoPrimer + REPLACE(SM.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoAlcaldia
		,SM.Observaciones AS ObservacionesSeguimientoAlcaldia
		,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
		,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
		,SG.Observaciones AS ObservacionesSeguimientoGobernacion
		,ObservacionesSegundo
		,NombreAdjuntoSegundo
		FROM [PAT].PreguntaPAT A
		join [PAT].[PreguntaPATMunicipio] as PM on A.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		inner join [PAT].Componente b on b.Id = a.IdComponente
		inner join [PAT].Medida c on c.Id = a.IdMedida
		inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
		inner join [PAT].Derecho e on e.Id = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT RM ON RM.IdPreguntaPAT = A.Id  and RM.IdMunicipio = @IdMunicipio--AND RM.ID_ENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
		LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA ON RMA.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP ON RMP.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].Seguimiento SM ON SM.IdPregunta = A.ID AND SM.IdUsuario = @IdUsuario AND SM.IdTablero = @IdTablero
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON SG.IdPregunta = A.ID AND SG.IdUsuarioAlcaldia = @IdUsuario AND SG.IdTablero = @IdTablero
		WHERE  a.IdTablero= @IdTablero 
		AND A.NIVEL = 3
		ORDER BY B.ID ASC, A.ID ASC
END
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		14/11/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene las respuestas de las pregutnas de reparacion colectiva del diligenciamiento municipal
-- =============================================
ALTER PROCEDURE [PAT].[C_DatosExcel_MunicipiosReparacionColectiva] -- [PAT].[C_DatosExcel_MunicipiosReparacionColectiva] 5172, 1
 (@IdMunicipio INT, @IdTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON	
	
	SELECT DISTINCT 
	P.ID AS IdPregunta, 
	MUN.Divipola AS DaneMunicipio,
	MUN.Nombre AS Municipio,
	MUN.IdDepartamento,
	P.IdMedida, 
	P.Sujeto, 
	P.MedidaReparacionColectiva, 
	M.Descripcion AS Medida, 
	T.ID AS IdTablero,
	R.ID as IdRespuesta,
	R.Accion, 
	R.Presupuesto,
	
	STUFF((SELECT CAST( ACCION.AccionReparacionColectiva AS VARCHAR(MAX)) + ' / ' 
	FROM [PAT].RespuestaPATAccionReparacionColectiva AS ACCION
	WHERE R.Id = ACCION.IdRespuestaPATReparacionColectiva AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS DetalleAcciones
	
	FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
	JOIN Municipio AS MUN ON P.IdMunicipio = MUN.Id
	LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] AS R ON P.ID= R.[IdPreguntaPATReparacionColectiva] AND R.[IdMunicipio] = @IdMunicipio,
	[PAT].[Medida] M,
	[PAT].[Tablero] T
	WHERE	P.IDMEDIDA = M.ID 
	AND P.[IdMunicipio] = @IdMunicipio
	AND P.IDTABLERO = T.ID
	AND T.ID = @IdTablero
END

go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		14/11/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene las respuestas de las pregutnas de retornos y reubicaciones del diligenciamiento municipal
-- =============================================
ALTER PROCEDURE [PAT].[C_DatosExcel_MunicipiosRetornosReubicaciones] -- [PAT].[C_DatosExcel_MunicipiosRetornosReubicaciones] 5172, 2
 (@IdMunicipio INT, @IdTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT DISTINCT  P.ID AS IdPregunta,
	M.Divipola AS DaneMunicipio,
	M.Nombre AS Municipio,
	M.IdDepartamento,
	P.Hogares,
	P.Personas,
	P.Sector,
	P.Componente,
	P.Comunidad,
	P.Ubicacion,
	P.MedidaRetornoReubicacion,
	P.IndicadorRetornoReubicacion,
	P.EntidadResponsable, 
	T.ID AS IdTablero,
	R.Id as IdRespuesta,
	R.Accion , 	
	R.Presupuesto,
	
	STUFF((SELECT CAST( ACCION.AccionRetornoReubicacion AS VARCHAR(MAX)) + ' / ' 
	FROM [PAT].RespuestaPATAccionRetornosReubicaciones AS ACCION
	WHERE R.Id = ACCION.IdRespuestaPATRetornoReubicacion AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS DetalleAcciones
	

	FROM   [PAT].[PreguntaPATRetornosReubicaciones] P
	JOIN Municipio AS M ON P.IdMunicipio = M.Id
	INNER JOIN [PAT].[Tablero] T ON P.[IdTablero] = T.ID
	LEFT OUTER JOIN [PAT].[RespuestaPATRetornosReubicaciones] R ON R.IdMunicipio = @IdMunicipio and p.ID = R.[IdPreguntaPATRetornoReubicacion]	
	WHERE  T.ID = @IdTablero 
	and P.[IdMunicipio] = @IdMunicipio
END

go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero municipal 
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoAlcaldias] --[PAT].[C_DatosExcelSeguimientoAlcaldias] 411, 1
( @IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare @IdMunicipio int, @IdDepartamento int
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	select distinct IdPregunta,IdAccion,IdPrograma,Derecho,Componente,Medida,Pregunta,PreguntaCompromiso,UnidadNecesidad,RespuestaNecesidad
		,ObservacionNecesidad,RespuestaCompromiso,ObservacionCompromiso,PrespuestaPresupuesto,Accion,Programa,AvanceCantidadAlcaldia,AvancePresupuestoAlcaldia
		,ObservacionesSeguimientoAlcaldia,AvanceCantidadGobernacion,AvancePresupuestoGobernacion,ObservacionesSeguimientoGobernacion,ObservacionesSegundo,NombreAdjuntoSegundo
	from (
		SELECT 
		A.Id AS IdPregunta
		,RMA.Id AS IdAccion
		,RMP.Id AS IdPrograma
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
		,RMA.Accion
		,RMP.Programa
		,(SM.CantidadPrimer + REPLACE(SM.CantidadSegundo, -1, 0)) AS AvanceCantidadAlcaldia
		,(SM.PresupuestoPrimer + REPLACE(SM.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoAlcaldia
		,SM.Observaciones AS ObservacionesSeguimientoAlcaldia
		,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
		,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
		,SG.Observaciones AS ObservacionesSeguimientoGobernacion
		,ObservacionesSegundo
		,NombreAdjuntoSegundo
		FROM [PAT].PreguntaPAT A (nolock)
		join [PAT].[PreguntaPATMunicipio] as PM (nolock) on A.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		inner join [PAT].Componente b (nolock) on b.Id = a.IdComponente
		inner join [PAT].Medida c (nolock) on c.Id = a.IdMedida
		inner join [PAT].UnidadMedida d (nolock) on d.Id = a.IdUnidadMedida
		inner join [PAT].Derecho e (nolock) on e.Id = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT RM (nolock) ON RM.IdPreguntaPAT = A.Id  and RM.IdMunicipio = @IdMunicipio--AND RM.ID_ENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
		LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA  (nolock)ON RMA.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP  (nolock) ON RMP.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = A.ID AND SM.IdUsuario = @IdUsuario AND SM.IdTablero = @IdTablero
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG (nolock) ON SG.IdPregunta = A.ID AND SG.IdUsuarioAlcaldia = @IdUsuario AND SG.IdTablero = @IdTablero
		WHERE  a.IdTablero= @IdTablero 
		AND A.NIVEL = 3		
		) as A
		ORDER BY Derecho ASC, IdPregunta ASC 
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoAlcaldiasReparacionColectiva]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoAlcaldiasReparacionColectiva] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		14/11/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene las respuestas de las pregutnas de reparacion colectiva del diligenciamiento municipal
-- =============================================
ALTER PROCEDURE [PAT].[C_DatosExcelSeguimientoAlcaldiasReparacionColectiva] -- [PAT].[C_DatosExcelSeguimientoAlcaldiasReparacionColectiva] 411, 1
 (@IdUsuario INT, @IdTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON	
	
	declare @IdMunicipio int, @IdDepartamento int
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	
	SELECT DISTINCT 
	P.ID AS IdPregunta, 
	MUN.Divipola AS DaneMunicipio,
	MUN.Nombre AS Municipio,
	MUN.IdDepartamento,
	P.IdMedida, 
	P.Sujeto, 
	P.MedidaReparacionColectiva, 
	M.Descripcion AS Medida, 
	T.ID AS IdTablero,
	R.ID as IdRespuesta,
	SEGRC.AvancePrimer,
	SEGRC.AvanceSegundo		
	FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
	JOIN Municipio AS MUN ON P.IdMunicipio = MUN.Id
	LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] AS R ON P.ID= R.[IdPreguntaPATReparacionColectiva] AND R.[IdMunicipio] = @IdMunicipio
	LEFT OUTER JOIN PAT.SeguimientoReparacionColectiva AS SEGRC ON P.Id  = SEGRC.IdPregunta AND SEGRC.IdUsuario =  @IdUsuario ,
	[PAT].[Medida] M,
	[PAT].[Tablero] T
	WHERE	P.IDMEDIDA = M.ID 
	AND P.[IdMunicipio] = @IdMunicipio
	AND P.IDTABLERO = T.ID
	AND T.ID = @IdTablero
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoAlcaldiasRetornosReubicaciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoAlcaldiasRetornosReubicaciones] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		14/11/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene las respuestas de las pregutnas de reparacion colectiva del diligenciamiento municipal
-- =============================================
ALTER PROCEDURE [PAT].C_DatosExcelSeguimientoAlcaldiasRetornosReubicaciones -- [PAT].C_DatosExcelSeguimientoAlcaldiasRetornosReubicaciones 411, 2
 (@IdUsuario INT, @IdTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON	
	
	declare @IdMunicipio int, @IdDepartamento int
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	
	SELECT DISTINCT 
	MUN.Divipola AS DaneMunicipio,
	MUN.Nombre AS Municipio,
	MUN.IdDepartamento,
	P.Hogares,
	P.Personas,
	P.Sector,
	P.Componente,
	P.Comunidad,
	P.Ubicacion,
	P.MedidaRetornoReubicacion,
	P.IndicadorRetornoReubicacion,
	P.EntidadResponsable, 
	T.ID AS IdTablero,
	R.Id as IdRespuesta,
	SEGRC.AvancePrimer,
	SEGRC.AvanceSegundo		
	FROM    [PAT].[PreguntaPATRetornosReubicaciones] AS P
	JOIN Municipio AS MUN ON P.IdMunicipio = MUN.Id
	LEFT OUTER JOIN [PAT].[RespuestaPATRetornosReubicaciones] AS R ON P.ID= R.[IdPreguntaPATRetornoReubicacion] AND R.[IdMunicipio] = @IdMunicipio
	LEFT OUTER JOIN PAT.SeguimientoRetornosReubicaciones AS SEGRC ON P.Id  = SEGRC.IdPregunta AND SEGRC.IdUsuario =  @IdUsuario ,
	[PAT].[Medida] M,
	[PAT].[Tablero] T
	WHERE P.[IdMunicipio] = @IdMunicipio
	AND P.IDTABLERO = T.ID
	AND T.ID = @IdTablero
END

GO

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - liliana Rodriguez
-- Create date:		10/07/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados, con las respuestas dadas por el gobernador 
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroMunicipioTotales] -- [PAT].[C_TableroMunicipioTotales]  null, 1,100,375,6,1
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT,  @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @RESULTADO TABLE (
		ID_PREGUNTA SMALLINT,
		PREGUNTAINDICATIVA NVARCHAR(500),
		PREGUNTACOMPROMISO NVARCHAR(500),
		DERECHO NVARCHAR(50),
		COMPONENTE NVARCHAR(100),
		MEDIDA NVARCHAR(50),
		UNIDADMEDIDA NVARCHAR(100),
		IDTABLERO TINYINT,
		IDENTIDAD INT,
		TOTALNECESIDADES INT,
		TOTALCOMPROMISOS INT,
		ID INT
		)
	
	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize

	SET @ORDEN = @sortOrder
	IF @ORDEN = ''
			SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE  @IdMunicipio INT, @IDDEPARTAMENTO INT

	SELECT @IDDEPARTAMENTO = IdDepartamento , @IdMunicipio = IdMunicipio FROM USUARIO WHERE Id = @IdUsuario

	SET @SQL = 'SELECT DISTINCT TOP (@TOP) 
					IDPREGUNTA,PREGUNTAINDICATIVA,PREGUNTACOMPROMISO,
					DERECHO,COMPONENTE,MEDIDA,UNIDADMEDIDA,IDTABLERO,IDENTIDAD,TOTALNECESIDADES,TOTALCOMPROMISOS,ID
				FROM ( 
				 SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.PREGUNTAINDICATIVA, 
						P.PREGUNTACOMPROMISO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						(SELECT SUM(R1.RespuestaIndicativa) 
							FROM  [PAT].[RespuestaPAT] R1	
							join Municipio MUN ON R1.IdMunicipio = MUN.Id
							WHERE R1.[IdPreguntaPAT]=P.Id  AND MUN.IdDepartamento = @IDDEPARTAMENTO							
						) TOTALNECESIDADES,
						(SELECT SUM(R1.RESPUESTACOMPROMISO) 
							FROM  [PAT].[RespuestaPAT] R1
							join Municipio MUN ON R1.IdMunicipio = MUN.Id
							WHERE R1.IdPreguntaPAT=P.Id AND MUN.IdDepartamento = @IDDEPARTAMENTO								
						) TOTALCOMPROMISOS,
						(SELECT TOP 1 RR.ID FROM [PAT].[RespuestaPAT] RR WHERE P.Id = RR.IdPreguntaPAT and RR.IdDepartamento =  @IDDEPARTAMENTO and RR.IdMunicipio is null	) AS ID
				FROM    [PAT].[PreguntaPAT] as P 
						--join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT
						--join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = IDDEPARTAMENTO
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdDepartamento =  @IDDEPARTAMENTO and R.IdMunicipio is null,						
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 					
					AND D.ID = @IdDerecho'		
	SET @SQL = @SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY P.ID'--+ @ORDEN 	
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IdMunicipio INT,@IdDerecho INT, @IDDEPARTAMENTO int'
		
	PRINT @SQL

	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IdMunicipio=@IdMunicipio, @IdDerecho=@IdDerecho, @IDDEPARTAMENTO=@IDDEPARTAMENTO
	SELECT * from @RESULTADO
END

go
  -- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/07/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene toda la informacion del municipio y gobernacion del tablero indicando en cuento a lo diligenciado
-- ==========================================================================================
ALTER PROC [PAT].[C_DatosExcel_Gobernaciones_municipios] -- [PAT].[C_DatosExcel_Gobernaciones_municipios] 375,1
(
	@IdUsuario INT, @IdTablero INT
)
AS
BEGIN

	Declare @IdMunicipio int, @IdDepartamento int, @Departamento VARCHAR(100)
	
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	select @Departamento = Nombre from Departamento where  Id = @IdDepartamento

	SELECT DISTINCT
	P.ID AS IDPREGUNTA, 
	P.IDDERECHO, 
	P.IDCOMPONENTE, 
	P.IDMEDIDA, 
	P.NIVEL, 
	P.PREGUNTAINDICATIVA, 
	P.IDUNIDADMEDIDA, 
	P.PREGUNTACOMPROMISO, 
	P.APOYODEPARTAMENTAL, 
	P.APOYOENTIDADNACIONAL, 
	P.ACTIVO, 
	D.DESCRIPCION AS DERECHO, 
	C.DESCRIPCION AS COMPONENTE, 
	M.DESCRIPCION AS MEDIDA, 
	UM.DESCRIPCION AS UNIDADMEDIDA,	
	T.Id AS IDTABLERO,						
	MR.Id  AS IDMUNICIPIO,
	R.ID as IDRESPUESTA,
	R.RESPUESTAINDICATIVA, 
	R.RESPUESTACOMPROMISO, 
	R.PRESUPUESTO,
	R.OBSERVACIONNECESIDAD,
	R.ACCIONCOMPROMISO					

	,STUFF((SELECT CAST( ACCION.Accion  AS VARCHAR(MAX)) + ' / ' 
	FROM PAT.RespuestaPATAccion AS ACCION
	WHERE R.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ACCION	
					
	,STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
	FROM [PAT].[RespuestaPATPrograma] AS PROGRAMA
	WHERE R.Id =PROGRAMA.IdRespuestaPAT  AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS PROGRAMA							
	,@Departamento AS DEPTO
	,MR.Nombre AS MPIO
	,1 AS IDRESPUESTADEP--,DEP.Id AS IDRESPUESTADEP
	,DEP.RespuestaCompromiso AS RESPUESTA_DEP_COMPROMISO
	,DEP.ObservacionCompromiso as  RESPUESTA_DEP_OBSERVACION 
	,DEP.Presupuesto AS RESPUESTA_DEP_PRESUPUESTO
					
	,'' as ACCION_DEPTO, '' as PROGRAMA_DEPTO

	--,STUFF((SELECT CAST(   REPLACE(ACCIONDEP.Accion,char(0x000B), ' ')  AS VARCHAR(MAX)) + ' / ' 
	--FROM PAT.RespuestaPATAccion AS ACCIONDEP
	--WHERE RDEP.Id = ACCIONDEP.IdRespuestaPAT AND ACCIONDEP.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ACCION_DEPTO
	
	--,STUFF((SELECT CAST(  REPLACE( PROGRAMADEP.Programa ,char(0x000B), ' ') AS VARCHAR(MAX)) + ' / ' 
	--FROM [PAT].[RespuestaPATPrograma] AS PROGRAMADEP
	--WHERE RDEP.Id = PROGRAMADEP.IdRespuestaPAT AND PROGRAMADEP.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS PROGRAMA_DEPTO	
	
	FROM    [PAT].[PreguntaPAT] AS P
	--join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT
	--join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = @IdDepartamento		
	INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
	INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
	INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
	INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
	INNER JOIN [PAT].Tablero AS T ON P.IDTABLERO = T.ID
	LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT]  
	LEFT OUTER JOIN Municipio AS MR ON R.IdMunicipio = MR.Id AND MR.IdDepartamento = @IdDepartamento													
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento DEP ON R.IdPreguntaPAT = DEP.IdPreguntaPAT and R.IdMunicipio = DEP.IdMunicipioRespuesta 	--trae varias respuestas
	LEFT OUTER JOIN Municipio AS MRDEP ON DEP.IdMunicipioRespuesta = MRDEP.Id AND MRDEP.IdDepartamento = @IdDepartamento																																
	LEFT OUTER JOIN [PAT].[RespuestaPAT] as RDEP on P.ID = RDEP.[IdPreguntaPAT] and  R.IdMunicipio = @IdMunicipio 										
	WHERE  T.ID = @IdTablero 
	and  P.NIVEL = 3 
	and MR.IdDepartamento = @IdDepartamento
	and P.ACTIVO = 1  
	ORDER BY DEPTO, MPIO, IDPREGUNTA
END

go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/07/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene toda la informacion correspondiente a la gobernbacion para reparacion colectiva  y tablero indicando en cuento a las respuestas que estos diligenciaron
-- ==========================================================================================

ALTER PROC [PAT].[C_DatosExcel_GobernacionesReparacionColectiva] --[PAT].[C_DatosExcel_GobernacionesReparacionColectiva] 375, 1
(	@IdUsuario INT, @IdTablero INT)
AS
BEGIN	

	Declare  @IdDepartamento int, @Departamento VARCHAR(100)
	
	select  @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario				
	
	select distinct MEDIDA.Descripcion as Medida,
			p.Sujeto,
			p.MedidaReparacionColectiva,
			rcd.Id,
			p.IdTablero,
			p.IdMunicipio as IdMunicipioRespuesta,
			@IdDepartamento as IdDepartamento, 
			p.Id as IdPreguntaReparacionColectiva,
			rc.Accion,
			rc.Presupuesto,
			rcd.AccionDepartamento,  
			rcd.PresupuestoDepartamento,
			d.Id as IdDane,
			d.Nombre as Municipio
		FROM PAT.PreguntaPATReparacionColectiva p
		INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
		INNER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id		
		INNER join Municipio as d on p.IdMunicipio =d.Id and d.IdDepartamento =@IdDepartamento
		LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc on p.Id = rc.IdPreguntaPATReparacionColectiva and rc.IdMunicipio= d.Id
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON rcd.IdMunicipioRespuesta= d.Id and rcd.IdPreguntaPATReparacionColectiva=p.Id
		where TABLERO.Id = @IdTablero 
		order by Sujeto																

END

go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/07/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene toda la informacion correspondiente a la gobernbacion para retornos y reubicaciones  para el tablero indicando en cuento a las respuestas que estos diligenciaron
-- ==========================================================================================

ALTER PROC [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones] --  [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones] 375 , 1
(	@IdUsuario INT, @IdTablero INT)
AS
BEGIN

	Declare @IdDepartamento int, @Departamento VARCHAR(100)
	
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario		

	SELECT DISTINCT 
		P.Id AS IdPregunta
		,P.IdMunicipio
		,P.Hogares
		,P.Personas
		,P.Sector
		,P.Componente
		,P.Comunidad
		,P.Ubicacion
		,P.MedidaRetornoReubicacion	
		,P.IndicadorRetornoReubicacion
		,p.IdDepartamento	
		,P.IdTablero	
		,R.ID
		,R.Accion
		,R.Presupuesto
		,RD.AccionDepartamento
		,RD.PresupuestoDepartamento
		,RD.Id as IdRespuestaDepartamento
		,P.EntidadResponsable
		FROM pat.PreguntaPATRetornosReubicaciones AS P
		JOIN PAT.Tablero AS T ON P.IdTablero =T.Id
		INNER join Municipio as d on p.IdMunicipio =d.Id and d.IdDepartamento =@IdDepartamento
		LEFT OUTER JOIN PAT.RespuestaPATRetornosReubicaciones AS R  ON P.Id = R.IdPreguntaPATRetornoReubicacion AND R.IdMunicipio = P.IdMunicipio
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoRetornosReubicaciones AS RD ON R.IdMunicipio = RD.IdMunicipioRespuesta
		where T.Id = @idTablero 
		order by P.Id

END

go


-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero municipal 
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoAlcaldias] --[PAT].[C_DatosExcelSeguimientoAlcaldias] 411, 1
( @IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare @IdMunicipio int, @IdDepartamento int
	select  @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	select distinct IdPregunta,IdAccion,IdPrograma,Derecho,Componente,Medida,Pregunta,PreguntaCompromiso,UnidadNecesidad,RespuestaNecesidad
		,ObservacionNecesidad,RespuestaCompromiso,ObservacionCompromiso,PrespuestaPresupuesto,Accion,Programa,AvanceCantidadAlcaldia,AvancePresupuestoAlcaldia
		,ObservacionesSeguimientoAlcaldia,AvanceCantidadGobernacion,AvancePresupuestoGobernacion,ObservacionesSeguimientoGobernacion,ObservacionesSegundo,NombreAdjuntoSegundo
		,ProgramasPrimero,ProgramasSegundo
	from (
		SELECT 
		A.Id AS IdPregunta
		,RMA.Id AS IdAccion
		,RMP.Id AS IdPrograma
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
		,RMA.Accion
		,RMP.Programa
		,(SM.CantidadPrimer + REPLACE(SM.CantidadSegundo, -1, 0)) AS AvanceCantidadAlcaldia
		,(SM.PresupuestoPrimer + REPLACE(SM.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoAlcaldia
		,SM.Observaciones AS ObservacionesSeguimientoAlcaldia
		,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
		,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
		,SG.Observaciones AS ObservacionesSeguimientoGobernacion
		,ObservacionesSegundo
		,NombreAdjuntoSegundo

		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoProgramas AS SMP
		WHERE SMP.IdSeguimiento =SM.IdSeguimiento AND SMP.NumeroSeguimiento = 1 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasPrimero			
		,STUFF((SELECT CAST( SMP.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].SeguimientoProgramas AS SMP
		WHERE SMP.IdSeguimiento =SM.IdSeguimiento AND SMP.NumeroSeguimiento = 2 FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS ProgramasSegundo			
		
		FROM [PAT].PreguntaPAT A (nolock)
		join [PAT].[PreguntaPATMunicipio] as PM (nolock) on A.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		inner join [PAT].Componente b (nolock) on b.Id = a.IdComponente
		inner join [PAT].Medida c (nolock) on c.Id = a.IdMedida
		inner join [PAT].UnidadMedida d (nolock) on d.Id = a.IdUnidadMedida
		inner join [PAT].Derecho e (nolock) on e.Id = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT RM (nolock) ON RM.IdPreguntaPAT = A.Id  and RM.IdMunicipio = @IdMunicipio--AND RM.ID_ENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
		LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA  (nolock)ON RMA.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP  (nolock) ON RMP.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].Seguimiento SM (nolock) ON SM.IdPregunta = A.ID AND SM.IdUsuario = @IdUsuario AND SM.IdTablero = @IdTablero
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG (nolock) ON SG.IdPregunta = A.ID AND SG.IdUsuarioAlcaldia = @IdUsuario AND SG.IdTablero = @IdTablero
		WHERE  a.IdTablero= @IdTablero 
		AND A.NIVEL = 3		
		) as A
		ORDER BY Derecho ASC, IdPregunta ASC 
END
go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] --[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldias] 375, 1
(@IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare  @IdDepartamento int, @Departamento varchar(150)
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	select @Departamento = Nombre from Departamento where Id = @IdDepartamento

	SELECT TOP 1000	P.*	FROM
	(
			SELECT DISTINCT
			A.Id AS IdPregunta
			,RMA.Id AS IdAccion
			,RMP.Id AS IdPrograma
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
			,RMA.Accion
			,RMP.Programa
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

			,(SM.CantidadPrimer + REPLACE(SM.CantidadSegundo, -1, 0)) AS AvanceCantidadAlcaldia
			,(SM.PresupuestoPrimer + REPLACE(SM.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoAlcaldia
			,SM.Observaciones AS ObservacionesSeguimientoAlcaldia
			,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
			,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
			,SG.Observaciones AS ObservacionesSeguimientoGobernacion
			FROM [PAT].PreguntaPAT A
			INNER JOIN [PAT].Derecho B ON B.Id = A.IdDerecho
			INNER JOIN [PAT].Componente C ON C.Id = A.IdComponente
			INNER JOIN [PAT].Medida D ON D.ID = A.IdMedida
			INNER JOIN [PAT].UnidadMedida E ON E.Id = A.IdUnidadMedida
			JOIN [PAT].RespuestaPAT RM ON RM.IdPreguntaPAT = A.Id and RM.IdDepartamento =@IdDepartamento
			JOIN Municipio AS M ON RM.IdMunicipio = M.Id			
			LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA ON RMA.IdRespuestaPAT = RM.Id
			LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP ON RMP.IdRespuestaPAT = RM.Id
			LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RDM ON  RM.IdMunicipio =RDM.IdMunicipioRespuesta AND  A.Id =RDM.IdPreguntaPAT  and RDM.IdUsuario =@IdUsuario
			LEFT OUTER JOIN [PAT].Seguimiento SM ON SM.IdPregunta = A.ID AND SM.IdTablero = @IdTablero AND SM.IdUsuario = RM.IdUsuario
			LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON A.ID =SG.IdPregunta AND SM.IdUsuario =SG.IdUsuarioAlcaldia  AND SG.IdUsuario = @IdUsuario
			--LEFT OUTER JOIN [PAT].RespuestaPAT RD  ON RD.IdPreguntaPAT = A.Id AND RD.IdDepartamento =@IdDepartamento
			--LEFT OUTER JOIN [PAT].RespuestaPATAccion RDA ON RDA.IdRespuestaPAT = RD.ID
			--LEFT OUTER JOIN [PAT].RespuestaPATPrograma RDP ON RDP.IdRespuestaPAT = RD.ID
			WHERE A.IdTablero = @IdTablero
			AND A.Activo = 1
			AND A.NIVEL = 3
			AND M.IdDepartamento =@IdDepartamento
	) AS P
	ORDER BY P.Departamento, P.Municipio
END

GO


-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		30/08/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental
-- =============================================
ALTER PROC  [PAT].[C_DatosExcelSeguimientoGobernaciones] --[PAT].[C_DatosExcelSeguimientoGobernaciones]  375, 1
(@IdUsuario INT,@IdTablero INT)
AS
BEGIN

	declare  @IdDepartamento int, @Departamento varchar(150)
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	select @Departamento = Nombre from Departamento where Id = @IdDepartamento

	SELECT
	A.Id AS IdPregunta
	,RMA.Id AS IdAccion
	,RMP.Id AS IdPrograma
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
	,RMA.Accion
	,RMP.Programa
	,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
	,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
	,SG.Observaciones AS ObservacionesSeguimientoGobernacion
	FROM [PAT].PreguntaPAT A
	INNER JOIN [PAT].Derecho B ON B.Id = A.IdDerecho
	INNER JOIN [PAT].Componente C ON C.Id = A.IdComponente
	INNER JOIN [PAT].Medida D ON D.Id = A.IdMedida
	INNER JOIN [PAT].UnidadMedida E ON E.Id = A.IdUnidadMedida
	JOIN [PAT].RespuestaPAT RM ON RM.IdPreguntaPAT = A.Id and RM.IdDepartamento =@IdDepartamento	
	LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA ON RM.Id =RMA.IdRespuestaPAT 
	LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP ON RM.Id = RMP.IdRespuestaPAT
	LEFT OUTER JOIN [PAT].Seguimiento SG ON  A.ID =SG.IdPregunta  AND SG.IdUsuario = @IdUsuario 
	WHERE A.IdTablero = @IdTablero and  A.Activo = 1
	AND A.NIVEL = 2
	ORDER BY B.Id ASC, A.Id ASC
END


GO

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC  [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldiasRC] --[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldiasRC] 5 , 1
(@IdDepartamento INT,@IdTablero INT)
AS
BEGIN	
		SELECT DISTINCT 		
		m.Descripcion Medida,
		p.Sujeto,
		p.MedidaReparacionColectiva,
		rcd.Id,
		p.IdTablero,
		rcd.IdMunicipioRespuesta,		
		p.Id as IdPreguntaRC,
		rc.Accion,
		rc.Presupuesto,
		rcd.AccionDepartamento,
		rcd.PresupuestoDepartamento
		,p.IdMunicipio
		,e.Nombre as Municipio
		,SMRC.AvancePrimer AS AvancePrimerSemestreAlcaldia
		,SMRC.AvanceSegundo AS AvanceSegundoSemestreAlcaldia
		,SGRC.AvancePrimer AS AvancePrimerSemestreGobernacion
		,SGRC.AvanceSegundo AS AvanceSegundoSemestreGobernacion
		FROM PAT.PreguntaPATReparacionColectiva p
		INNER JOIN PAT.Medida m ON p.IdMedida = m.Id
		INNER JOIN Municipio  e on e.Id = p.IdMunicipio and e.IdDepartamento = @IdDepartamento
		LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc ON rc.IdMunicipio = e.Id and rc.IdPreguntaPATReparacionColectiva=p.Id
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON rcd.IdMunicipioRespuesta = e.Id and rcd.IdPreguntaPATReparacionColectiva=p.Id
		LEFT OUTER JOIN [PAT].SeguimientoReparacionColectiva SMRC ON SMRC.IdTablero = p.IdTablero AND SMRC.IdUsuario = rc.IdUsuario AND SMRC.IdPregunta = rc.IdPreguntaPATReparacionColectiva
		LEFT OUTER JOIN [PAT].SeguimientoGobernacionReparacionColectiva SGRC ON SGRC.IdTablero = p.IdTablero AND SGRC.IdPregunta = RC.IdPreguntaPATReparacionColectiva AND SGRC.IdUsuarioAlcaldia = rc.IdUsuario
		where p.IdTablero = @IdTablero 							
		ORDER BY p.Sujeto 	
END
go
