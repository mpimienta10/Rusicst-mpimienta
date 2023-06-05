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


-------------------------------------------------------------------------------------------------
--DESPUES DE LA PUBLICACION DE LA MAÑANA
-------------------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[EnvioTableroPat]'))
BEGIN 
		CREATE TABLE [PAT].[EnvioTableroPat](
			[IdEnvio] [int] IDENTITY(1,1) NOT NULL,
			[IdTablero] [tinyint] NOT NULL,
			[IdUsuario] [int] NOT NULL,
			[IdMunicipio] [int] NOT NULL,
			[IdDepartamento] [int] NOT NULL,
			[TipoEnvio] [varchar](3) NOT NULL,
			[FechaEnvio] [datetime] NOT NULL,
		 CONSTRAINT [PK_EnvioPlan] PRIMARY KEY CLUSTERED 
		(
			[IdEnvio] ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		) ON [PRIMARY]


		ALTER TABLE [PAT].[EnvioTableroPat]  WITH CHECK ADD  CONSTRAINT [FK_EnvioTableroPat_Departamento] FOREIGN KEY([IdDepartamento])
		REFERENCES [dbo].[Departamento] ([Id])

		ALTER TABLE [PAT].[EnvioTableroPat] CHECK CONSTRAINT [FK_EnvioTableroPat_Departamento]

		ALTER TABLE [PAT].[EnvioTableroPat]  WITH CHECK ADD  CONSTRAINT [FK_EnvioTableroPat_Municipio] FOREIGN KEY([IdMunicipio])
		REFERENCES [dbo].[Municipio] ([Id])

		ALTER TABLE [PAT].[EnvioTableroPat] CHECK CONSTRAINT [FK_EnvioTableroPat_Municipio]

		ALTER TABLE [PAT].[EnvioTableroPat]  WITH CHECK ADD  CONSTRAINT [FK_EnvioTableroPat_Tablero] FOREIGN KEY([IdTablero])
		REFERENCES [PAT].[Tablero] ([Id])

		ALTER TABLE [PAT].[EnvioTableroPat] CHECK CONSTRAINT [FK_EnvioTableroPat_Tablero]

		ALTER TABLE [PAT].[EnvioTableroPat]  WITH CHECK ADD  CONSTRAINT [FK_EnvioTableroPat_Usuario] FOREIGN KEY([IdUsuario])
		REFERENCES [dbo].[Usuario] ([Id])

		ALTER TABLE [PAT].[EnvioTableroPat] CHECK CONSTRAINT [FK_EnvioTableroPat_Usuario]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_EnvioTableroPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_EnvioTableroPat] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez																		  
/Fecha creacion:     2017-12-11	
/Fecha modificacion :2017-12-11
/Descripcion: Inserta los datos de envio de los tres tipos de tablero: Planeacion Municipal "PM", Planeacion Departamental "PD"
/, Primer Seguimiento Municpal "SM1", Segundo Seguimiento Municpal "SM2"						  
/, Primer Seguimiento Departamental "SD1", Segundo Seguimiento Departamental "SD2"						  
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
	
	if (@id is not null)
	begin
		set @esValido = 0
		set @respuesta += 'El tablero ya ha sido enviado con aterioridad.\n'
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

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_EnvioTableroPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_EnvioTableroPat] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		14/11/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene todos los envios del tablero Pat
-- =============================================
ALTER PROCEDURE [PAT].[C_EnvioTableroPat] -- [PAT].[C_EnvioTableroPat] 		
AS
BEGIN
	SET NOCOUNT ON	
					  
	SELECT E.[IdTablero], year(T.VigenciaInicio) AnoPlaneacion, E.[IdUsuario],E.[IdMunicipio],E.[IdDepartamento],E.[FechaEnvio]
	, D.Nombre AS Departamento, M.Nombre as Municipio, 
	case when E.[TipoEnvio]  = 'PM' then 'Planeación Municipal'
		 when E.[TipoEnvio]  = 'PD' then 'Planeación Departamental'
		 when E.[TipoEnvio]  = 'SM1' then 'Primer Seguimiento Municpal'
		 when E.[TipoEnvio]  = 'SM2' then 'Segundo Seguimiento Municpal'
		 when E.[TipoEnvio]  = 'SD1' then 'Primer Seguimiento Departamental'
		 when E.[TipoEnvio]  = 'SD2' then 'Segundo Seguimiento Departamental'
		 else '' end as TipoEnvio
	, U.UserName AS	Usuario
	FROM [PAT].[EnvioTableroPat] AS E
	JOIN PAT.Tablero as T on  E.[IdTablero] = T.Id
	JOIN Departamento AS D ON E.IdDepartamento = D.Id
	JOIN Municipio AS M ON M.Id = E.IdMunicipio
	JOIN Usuario AS U ON U.Id = E.IdUsuario
	order by E.IdEnvio desc
				   
END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ValidarEnvioTableroPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ValidarEnvioTableroPat] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		14/11/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene todos los envios del tablero Pat
-- =============================================
ALTER PROCEDURE [PAT].[C_ValidarEnvioTableroPat] -- [PAT].[C_ValidarEnvioTableroPat] 
		@IdUsuario int,
		@IdTablero tinyint,
		@TipoEnvio varchar(3)
AS

BEGIN
	SET NOCOUNT ON	
					  
	declare @IdDepartamento int,@IdMunicipio  int	
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	select E.IdEnvio, E.[IdTablero],E.[IdUsuario],E.[IdMunicipio],E.[IdDepartamento],E.[FechaEnvio]
	from [PAT].[EnvioTableroPat] as E
	where  E.IdMunicipio = @IdMunicipio and E.IdDepartamento = @IdDepartamento and E.TipoEnvio = @TipoEnvio and E.IdTablero =@IdTablero
					   
END
go

IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Consulta Tableros PAT Enviados' AND IdRecurso = 8)
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON	
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso]) VALUES (68, 'Consulta Tableros PAT Enviados', NULL, 8)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END
go

if not exists (select * from sys.columns where name='PlantillaEmailConfirmacionPlaneacionPat'  and Object_id in (select object_id from sys.tables where name ='Sistema'))
begin 	
	ALTER TABLE [dbo].[Sistema] ADD [PlantillaEmailConfirmacionPlaneacionPat] varchar(max) null
	ALTER TABLE [dbo].[Sistema] ADD [PlantillaEmailConfirmacionSeguimiento1Pat] varchar(max) null
	ALTER TABLE [dbo].[Sistema] ADD [PlantillaEmailConfirmacionSeguimiento2Pat] varchar(max) null
end
go
--=====================================================================================================
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-09																			 
-- Descripcion: Carga los datos de los parámetros del sistema						
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DatosSistema]

AS

SELECT 
	 [Id]
	,[FromEmail]
	,[SmtpHost]
	,[SmtpPort]
	,[SmtpEnableSsl]
	,[SmtpUsername]
	,[SmtpPassword]
	,[TextoBienvenida]
	,[FormatoFecha]
	,[PlantillaEmailPassword]
	,[UploadDirectory]
	,[PlantillaEmailConfirmacion]
	,[SaveMessageConfirmPopup]
	,[PlantillaEmailConfirmacionPlaneacionPat]
	,[PlantillaEmailConfirmacionSeguimiento1Pat]
	,[PlantillaEmailConfirmacionSeguimiento2Pat]
FROM 
	[dbo].[Sistema]

go

-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 13/03/2017
-- Description:	Actualiza un registro en la tabla SISTEMA 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 2 actualizado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[U_SistemaUpdate] 
	
	 @Id							INT
	,@FromEmail						VARCHAR(255)
	,@SmtpHost						VARCHAR(255)
	,@SmtpPort						INT
	,@SmtpEnableSsl					BIT
	,@SmtpUsername					VARCHAR(255)
	,@SmtpPassword					VARCHAR(255)
	,@TextoBienvenida				VARCHAR(MAX)
	,@FormatoFecha					VARCHAR(255)
	,@PlantillaEmailPassword		VARCHAR(MAX)
	,@UploadDirectory				VARCHAR(1000)
	,@PlantillaEmailConfirmacion	VARCHAR(MAX)
	,@SaveMessageConfirmPopup		VARCHAR(255)
	,@PlantillaEmailConfirmacionPlaneacionPat VARCHAR(MAX)
	,@PlantillaEmailConfirmacionSeguimiento1Pat VARCHAR(MAX)
	,@PlantillaEmailConfirmacionSeguimiento2Pat VARCHAR(MAX)
	

AS
	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		IF(@esValido = 1) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY
					UPDATE 
						[dbo].[Sistema]
					SET 
						[FromEmail] = @FromEmail, [SmtpHost] = @SmtpHost, [SmtpPort] = @SmtpPort, [SmtpEnableSsl] = @SmtpEnableSsl, 
						[SmtpUsername] = @SmtpUsername, [SmtpPassword] = @SmtpPassword, [TextoBienvenida] = @TextoBienvenida, 
						[FormatoFecha] = @FormatoFecha, [PlantillaEmailPassword] = @PlantillaEmailPassword, [UploadDirectory] = @UploadDirectory, 
						[PlantillaEmailConfirmacion] = @PlantillaEmailConfirmacion, [SaveMessageConfirmPopup] = @SaveMessageConfirmPopup
						,PlantillaEmailConfirmacionPlaneacionPat =@PlantillaEmailConfirmacionPlaneacionPat 
						,PlantillaEmailConfirmacionSeguimiento1Pat=@PlantillaEmailConfirmacionSeguimiento1Pat 
						,PlantillaEmailConfirmacionSeguimiento2Pat=@PlantillaEmailConfirmacionSeguimiento2Pat 
					WHERE [Id] = @Id

					SELECT @respuesta = 'Se ha actualizado el registro'
					SELECT @estadoRespuesta = 2
	
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

	go


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntasDependientesXIdPregunta]') AND type in (N'F', N'TF')) 
begin
	drop FUNCTION [dbo].[C_PreguntasDependientesXIdPregunta]
end

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- Author:		Equipo de desarrollo OIM - Andrés Bonilla
-- Create date: 06/12/2017
-- Description:	Retorna el Listado de Preguntas, campo Obligatoria y SoloSi que dependen del parametro enviado
--				para poder determinar cuales deben ser contadas en el punto 1 de la retroalimentacion
-- ============================================================
CREATE FUNCTION [dbo].[C_PreguntasDependientesXIdPregunta]
(
	@IdPregunta INT
)

RETURNS @TABLA TABLE
(
	IdPregunta INT
	,CodigoPregunta varchar(10)
	,SoloSi varchar(MAX)
	,Obligatoria bit
)
AS

BEGIN

	DECLARE @IdEncuesta INT
	DECLARE @IdSeccion INT
	DECLARE @NombrePregunta VARCHAR(512)
	DECLARE @CodigoPregunta VARCHAR(10)

	SELECT 
		@IdEncuesta = b.IdEncuesta
		,@IdSeccion = a.IdSeccion
		,@NombrePregunta = a.Nombre
	FROM 
		dbo.Pregunta a
		INNER JOIN 
			dbo.Seccion b 
				ON b.Id = a.IdSeccion
	WHERE 
		a.Id = @IdPregunta


	--PRINT @IdPregunta
	--PRINT @IdEncuesta
	--PRINT @IdSeccion
	--PRINT @NombrePregunta

	IF @IdEncuesta > 76 --Codigo de Pregunta Banco
	BEGIN

		SELECT 
			@CodigoPregunta = b.CodigoPregunta
		FROM
			dbo.Pregunta p
			INNER JOIN 
				BancoPreguntas.PreguntaModeloAnterior pma
					ON pma.IdPreguntaAnterior = p.Id
			INNER JOIN
				BancoPreguntas.Preguntas b 
					ON b.IdPregunta = pma.IdPregunta
		WHERE
			p.Id = @IdPregunta


		INSERT INTO @TABLA
		SELECT 
			P.[Id]	
			,BP.CodigoPregunta
			,P.SoloSi
			,P.EsObligatoria
		FROM 
			[dbo].[Pregunta] p
			INNER JOIN 
				dbo.Seccion S 				
					ON S.Id = p.IdSeccion
			INNER JOIN
				BancoPreguntas.PreguntaModeloAnterior PMA
					ON p.Id = PMA.IdPreguntaAnterior
			INNER JOIN
				BancoPreguntas.Preguntas BP
					ON PMA.IdPregunta = BP.IdPregunta
		WHERE 
			CHARINDEX(@CodigoPregunta, SoloSi, 0) > 0
			AND
				IdSeccion = @IdSeccion
		ORDER BY
			p.Id 
				ASC


	END
	ELSE -- Nombre de Pregunta vieja
	BEGIN

		INSERT INTO @TABLA
		SELECT 
			P.[Id]	
			,BP.CodigoPregunta
			,P.SoloSi
			,P.EsObligatoria
		FROM 
			[dbo].[Pregunta] p
			INNER JOIN 
				dbo.Seccion S 				
					ON S.Id = p.IdSeccion
			INNER JOIN
				BancoPreguntas.PreguntaModeloAnterior PMA
					ON p.Id = PMA.IdPreguntaAnterior
			INNER JOIN
				BancoPreguntas.Preguntas BP
					ON PMA.IdPregunta = BP.IdPregunta
		WHERE 
			CHARINDEX(@NombrePregunta, SoloSi, 0) > 0
			AND
				IdSeccion = @IdSeccion
		ORDER BY
			p.Id 
				ASC

	END


	RETURN

END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetIdPreguntaPorCodigoYEncuesta]') AND type in (N'F', N'FN')) 
BEGIN
	DROP FUNCTION [dbo].[GetIdPreguntaPorCodigoYEncuesta]
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - Andrés Bonilla
-- Create date: 14/12/2017
-- Description:	Funcion para obtener el ID pregunta x codigo y encuesta
-- =============================================
CREATE FUNCTION [dbo].[GetIdPreguntaPorCodigoYEncuesta]
(
	@CodigoPregunta varchar(10), 
	@IdEncuesta INT
) 

RETURNS INT

AS
BEGIN

   DECLARE @IdPregunta INT

   SELECT 
		@IdPregunta = c.Id
	FROM 
		[BancoPreguntas].[Preguntas] a
		INNER JOIN 
			[BancoPreguntas].PreguntaModeloAnterior b ON b.IdPregunta = a.IdPregunta
		INNER JOIN 
			[dbo].Pregunta c ON c.Id = b.IdPreguntaAnterior 
		INNER JOIN 
			[dbo].Seccion d ON d.Id = c.IdSeccion
	WHERE 
		a.[CodigoPregunta] =  @CodigoPregunta
		AND
			d.IdEncuesta = @IdEncuesta

   RETURN @IdPregunta
   
END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ValidarSoloSiConteoRetro]') AND type in (N'F', N'FN')) 
BEGIN
	drop FUNCTION [dbo].[ValidarSoloSiConteoRetro]
END

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 14/12/2017
-- Description:	Funcion para validar si la pregunta, es obligatoria por el EQ
-- =============================================
CREATE FUNCTION [dbo].[ValidarSoloSiConteoRetro]
(
	@SoloSi varchar(MAX),
	@IdEncuesta INT
) 

RETURNS BIT
AS
BEGIN

	DECLARE @Cuenta BIT
	DECLARE @indexIniEQ INT
	DECLARE @indexFinEQ INT
	DECLARE @codigopregunta VARCHAR(10)
	DECLARE @respuestaactiva VARCHAR(max)
	DECLARE @respuestaPregunta VARCHAR(max)
	DECLARE @idPreguntaActiva INT
	DECLARE @eqCuenta BIT

	IF CHARINDEX('EQ', @SoloSi) > 0
	BEGIN

	SET @indexIniEQ = CHARINDEX('EQ(', @SoloSi, 0)
	SET @indexFinEQ = CHARINDEX(')', @SoloSi, @indexIniEQ)

	DECLARE @substrEQ varchar(max)
	SELECT @substrEQ = SUBSTRING(@SoloSi, (@indexIniEQ + 3), (@indexFinEQ - (@indexIniEQ + 3)))

	DECLARE @splitTable TABLE
	(
		Id INT
		,Col varchar(max)
	)

	INSERT INTO @splitTable
	SELECT * FROM [dbo].[SplitWId](@substrEQ, ';')
	SELECT @codigoPregunta = SUBSTRING(Col , 2, LEN(Col)) FROM @splitTable WHERE Id = 1
	SELECT @respuestaActiva = REPLACE(Col, '"', '') FROM @splitTable WHERE Id = 2
	SELECT @eqCuenta = Col FROM @splitTable WHERE Id = 3
	SELECT @idPreguntaActiva = [dbo].[GetIdPreguntaPorCodigoYEncuesta](@codigoPregunta, @idEncuesta)
	
	IF @idPreguntaActiva IS NOT NULL
	BEGIN
		IF (@eqCuenta = 1)
			Set @Cuenta = 1
	END
	ELSE 
	BEGIN
		Set @Cuenta = 0
	END
	
	END
	ELSE
	BEGIN
		Set @Cuenta = 0
	END

	RETURN @Cuenta

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroEncuestaNivel]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroEncuestaNivel] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 12/12/2017
-- Description:	obtiene la informacion Retroalimentacion de la grafica Nivel x encuesta
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroEncuestaNivel] 

	@IdRetroAdmin 				INT,
	@IdUser						VARCHAR(50)
AS

Declare 
@IdEncuesta int,
@cantPregObligatorias int,
@cantRespObligatorias int,
@IdUsuario INT

SELECT @IdEncuesta = IdEncuesta from RetroAdmin where Id = @IdRetroAdmin
SELECT @IdUsuario = id FROM Usuario WHERE UserName = @IdUser

declare @preguntasObligatorias table (
	IdPregunta INT
	,CodigoPregunta varchar(10)
)

declare @preguntasTotal table (
	IdPregunta INT
)

insert into @preguntasObligatorias 
select b.Id, d.CodigoPregunta
from dbo.Seccion a 
inner join dbo.Pregunta b on b.IdSeccion = a.Id
inner join BancoPreguntas.PreguntaModeloAnterior c on b.Id = c.IdPreguntaAnterior
inner join BancoPreguntas.Preguntas d on c.IdPregunta = d.IdPregunta
where
a.IdEncuesta = @IdEncuesta and SoloSi is null
and b.EsObligatoria = 1

--Agregamos las preguntas obligatorias a la tabla del total de preguntas que se debieron responder
insert into @preguntasTotal
select IdPregunta from @preguntasObligatorias

--Recorremos las obligatorias y verificamos las dependencias
DECLARE @IdPreguntaObligatoria INT

--Tabla temporal para almacenar las preguntas que dependen de la pregunta obligatoria
DECLARE @TablaTemp table (
	IdPregunta INT
	,CodigoPregunta varchar(10)
	,SoloSi varchar(MAX)
	,Obligatoria bit
)

DECLARE obligatorias_cursor CURSOR FOR  
SELECT IdPregunta 
FROM @preguntasObligatorias 

OPEN obligatorias_cursor   
FETCH NEXT FROM obligatorias_cursor INTO @IdPreguntaObligatoria   

WHILE @@FETCH_STATUS = 0   
BEGIN   

	--Borramos datos... por si acaso
	delete from @TablaTemp
	
	insert into @TablaTemp
	select *	
	from [dbo].[C_PreguntasDependientesXIdPregunta](@IdPreguntaObligatoria)

	--Agregamos las preguntas obligatorias que dependen de @IdPreguntaObligatoria, si no existe previamente
	--en las que ya existen
	INSERT INTO @preguntasTotal
	Select IdPregunta
	FROM @TablaTemp
	WHERE Obligatoria = 1
	AND IdPregunta NOT IN (
		Select DISTINCT IdPregunta 
		FROM @preguntasTotal
	)

	--Agregamos las preguntas que dependen de @IdPreguntaObligatoria, que tienen EQ(@pregunta;algo;1)
	--solo se verifica el primer EQ con fines de optimizar el proceso, si no tiene tercer param = 0
	INSERT INTO @preguntasTotal
	Select IdPregunta
	FROM @TablaTemp
	WHERE Obligatoria = 0
	AND IdPregunta NOT IN (
		Select DISTINCT IdPregunta 
		FROM @preguntasTotal
	)
	AND [dbo].[ValidarSoloSiConteoRetro](SoloSi, @IdEncuesta) = 1

	FETCH NEXT FROM obligatorias_cursor INTO @IdPreguntaObligatoria   
END   

CLOSE obligatorias_cursor   
DEALLOCATE obligatorias_cursor

--Ahora validamos las preguntas no obligatorias pero que tienen EQ(@pregunta;algo;1)
INSERT INTO @preguntasTotal
select b.Id
from dbo.Seccion a 
inner join dbo.Pregunta b on b.IdSeccion = a.Id
where
a.IdEncuesta = @IdEncuesta
and b.Id not in (
	select IdPregunta from @preguntasTotal
) and SoloSi is not null
AND [dbo].[ValidarSoloSiConteoRetro](b.SoloSi, @IdEncuesta) = 1


---Total preguntas que debió responder el usuario
select @cantPregObligatorias = COUNT(1) from @preguntasTotal 

select @cantRespObligatorias = COUNT(1)
from dbo.Respuesta r
inner join @preguntasTotal p on r.IdPregunta = p.IdPregunta
where  IdUsuario = @idUsuario

IF (@cantPregObligatorias != 0)
BEGIN
	Select	
		(@cantRespObligatorias * 100)/ @cantPregObligatorias as Municipio, 
		@cantPregObligatorias as TotalPreguntas,
		@cantRespObligatorias as RespuestasMunicipio
END
ELSE
BEGIN
	Select	
		0 as Municipio, 
		@cantPregObligatorias as TotalPreguntas,
		@cantRespObligatorias as RespuestasMunicipio
END

GO

--exec C_ConsultaRetroEncuestaNivel 8, 'alcaldia_abejorral_antioquia'

GO

IF EXISTS(SELECT * FROM information_schema.[columns] WHERE table_name='RetroGraficaNivel' AND column_name='Color2serie')
BEGIN
	ALTER TABLE RetroGraficaNivel DROP COLUMN Color2serie 
	PRINT 'Columna Color2serie Eliminada'
END
ELSE
BEGIN
	PRINT 'No Existe Color2serie'
END 

GO

IF EXISTS(SELECT * FROM information_schema.[columns] WHERE table_name='RetroGraficaNivel' AND column_name='Color3serie')
BEGIN
	ALTER TABLE RetroGraficaNivel DROP COLUMN Color3serie 
	PRINT 'Columna Color3serie Eliminada'
END
ELSE
BEGIN
	PRINT 'No Existe Color3serie'
END 

GO

IF EXISTS(SELECT * FROM information_schema.[columns] WHERE table_name='RetroGraficaNivel' AND column_name='NombreSerie2')
BEGIN
	ALTER TABLE RetroGraficaNivel DROP COLUMN NombreSerie2 
	PRINT 'Columna NombreSerie2 Eliminada'
END
ELSE
BEGIN
	PRINT 'No Existe NombreSerie2'
END 

GO

IF EXISTS(SELECT * FROM information_schema.[columns] WHERE table_name='RetroGraficaNivel' AND column_name='NombreSerie3')
BEGIN
	ALTER TABLE RetroGraficaNivel DROP COLUMN NombreSerie3 
	PRINT 'Columna NombreSerie3 Eliminada'
END
ELSE
BEGIN
	PRINT 'No Existe NombreSerie3'
END 

GO

IF EXISTS(SELECT * FROM information_schema.[columns] WHERE table_name='RetroGraficaNivel' AND column_name='NombreEje1')
BEGIN
	ALTER TABLE RetroGraficaNivel DROP COLUMN NombreEje1 
	PRINT 'Columna NombreEje1 Eliminada'
END
ELSE
BEGIN
	PRINT 'No Existe NombreEje1'
END 

GO

IF EXISTS(SELECT * FROM information_schema.[columns] WHERE table_name='RetroGraficaNivel' AND column_name='NombreEje2')
BEGIN
	ALTER TABLE RetroGraficaNivel DROP COLUMN NombreEje2 
	PRINT 'Columna NombreEje2 Eliminada'
END
ELSE
BEGIN
	PRINT 'No Existe NombreEje2'
END 

GO

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_EncuestaRetroGrafNivelUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_EncuestaRetroGrafNivelUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================  
-- Autor: Equipo de desarrollo OIM - John Betancourt A. 
-- Fecha creacion: 2017-08-15
-- Descripcion: Actualiza un registro en la realiemntacion                     
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado            
-- Estado int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado            
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'      
--====================================================================================================  
ALTER PROC [dbo].[U_EncuestaRetroGrafNivelUpdate]   
	
	@IdRetroAdmin int,
	@TipoGrafica int,
	@Color1serie varchar(50),
    @TituloGraf varchar(50),
    @NombreSerie1 varchar(50)

AS   
  
 -- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0  
 BEGIN  
  BEGIN TRANSACTION  
  BEGIN TRY  

 
 IF EXISTS (select 1 from RetroGraficaNivel where IdRetroAdmin = @IdRetroAdmin)  
	BEGIN
		UPDATE   
		[dbo].[RetroGraficaNivel]  
		SET      
			TipoGrafica = @TipoGrafica,
			Color1serie = @Color1serie,
			TituloGraf = @TituloGraf,
			NombreSerie1 = @NombreSerie1
		WHERE    
		IdRetroAdmin = @IdRetroAdmin

		SELECT @respuesta = 'Se ha actualizado el registro'  
		SELECT @estadoRespuesta = 2 
	END 
ELSE 
	BEGIN
		INSERT INTO [dbo].[RetroGraficaNivel]
           (IdRetroAdmin,[TipoGrafica],[Color1serie],[TituloGraf]
           ,[NombreSerie1])
		   VALUES
		   (@IdRetroAdmin, @TipoGrafica, @Color1serie, @TituloGraf,
			@NombreSerie1)

			SELECT @respuesta = 'Se ha Ingresado el registro'  
			SELECT @estadoRespuesta = 1
	END
	
       
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


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_RetroalimentacionDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_RetroalimentacionDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 19/08/2017
-- Description:	elimina una realimentacion
-- =============================================
ALTER PROC [dbo].[D_RetroalimentacionDelete] 
	@IdRetro					INT
AS

 -- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0  
 
 IF NOT EXISTS (select 1 from RetroConsultaEncuesta where IdRetroAdmin = @IdRetro)
 BEGIN  
  BEGIN TRANSACTION  
  BEGIN TRY 

	DELETE FROM [dbo].[RetroAdmin]
		  WHERE Id = @IdRetro
	SELECT @respuesta = 'Se ha Eliminado el registro'  
	SELECT @estadoRespuesta = 3
	COMMIT  TRANSACTION  
  END TRY  
  BEGIN CATCH  
   ROLLBACK TRANSACTION  
   SELECT @respuesta = ERROR_MESSAGE()  
   SELECT @estadoRespuesta = 0  
  END CATCH  
 END
 ELSE
 BEGIN
	SELECT @respuesta = 'Existen Datos Asociados a la Retroalimentación'  
	SELECT @estadoRespuesta = 0
 END
 
 SELECT @respuesta AS respuesta, @estadoRespuesta AS estado     

GO

--========================================================
-- Elimina el SubRecurso DILIGENCIAR PLAN DE MEJORAMIENTO
--========================================================
DELETE [dbo].[TipoUsuarioRecurso] WHERE IdSubRecurso = (SELECT [Id] FROM [dbo].[SubRecurso] WHERE [Nombre] = 'Diligenciar Plan de Mejoramiento')
DELETE [dbo].[SubRecurso] WHERE [Nombre] = 'Diligenciar Plan de Mejoramiento'

GO

