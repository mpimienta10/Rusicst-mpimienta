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
		WHERE RM.Id = ACCION.IdRespuestaPAT AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Accion,	
		STUFF((SELECT CAST( PROGRAMA.Programa  AS VARCHAR(MAX)) + ' / ' 
		FROM [PAT].RespuestaPATPrograma AS PROGRAMA
		WHERE RM.Id = PROGRAMA.IdRespuestaPAT AND PROGRAMA.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS Programa	
					
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[PrecargueProgramasSIGOSeguimiento]') ) 
CREATE  TABLE [PAT].[PrecargueProgramasSIGOSeguimiento](
	IdPrecargue  INT IDENTITY(1,1) NOT NULL,
	Tipo [nvarchar](255) not NULL,
	ANO INT NOT NULL,
	NumeroSeguimiento  INT NOT NULL,
	IdTablero int not null,
	NumeroPrograma [int] NULL,
	NombrePrograma [nvarchar](max) NULL,
	DescripcionPrograma [nvarchar](max) NULL,
	Vigencia [nvarchar](255) NULL,
	Acreditado bit NULL,
	NumeroBeneficiaios [int] NULL,
	NumeroVictimas [int] NULL,
	EstaEnTableroPAT bit NULL,
	CodigoDane [int] NULL,
	IdPregunta int NULL,
	IdRespuesta int NULL,
	IdRespuestaPrograma int NULL,
	IdDerecho int NULL,
	Nivel int NULL,
	FechaUltimaModificacion datetime not null
) ON [PRIMARY]

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ProgramasSeguimientoSIGO]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ProgramasSeguimientoSIGO] AS'
GO
alter PROCEDURE [PAT].[C_ProgramasSeguimientoSIGO](  --[PAT].[C_ProgramasSeguimientoSIGO] 2,1,3,73026,13
	@IdTablero as INT	,
	@NumeroSeguimiento as int,
	@Nivel as int,
	@Divipola as int,
	@IdDerecho as int,
	@IdPregunta as smallint
)
AS
BEGIN
	SET NOCOUNT ON;	
	if (@Nivel = 3)
	begin
		select distinct Tipo, NumeroPrograma, NombrePrograma, DescripcionPrograma, Vigencia, Acreditado, NumeroBeneficiaios, NumeroVictimas, EstaEnTableroPAT, IdPregunta, IdRespuesta, IdRespuestaPrograma 
		from [PAT].[PrecargueProgramasSIGOSeguimiento] as P
		JOIN Municipio AS M ON P.CodigoDane = M.Id
		left outer join PAT.RespuestaPATPrograma as RP on P.IdRespuesta = RP.IdRespuestaPAT
		where Nivel = @Nivel and IdTablero = @IdTablero and NumeroSeguimiento = @NumeroSeguimiento  and P.CodigoDane = @Divipola and P.IdDerecho = @IdDerecho
		and ( P.IdPregunta = @IdPregunta or P.IdPregunta is null)
		order by NombrePrograma
	end
	else		
	begin
		select distinct Tipo, NumeroPrograma, NombrePrograma, DescripcionPrograma, Vigencia, Acreditado, NumeroBeneficiaios, NumeroVictimas, EstaEnTableroPAT, IdPregunta, IdRespuesta, IdRespuestaPrograma 
		from [PAT].[PrecargueProgramasSIGOSeguimiento] as P
		JOIN Departamento AS D ON P.CodigoDane = D.Id
		left outer join PAT.RespuestaPATPrograma as RP on P.IdRespuesta = RP.IdRespuestaPAT
		where Nivel = @Nivel and IdTablero = @IdTablero and NumeroSeguimiento = @NumeroSeguimiento  and P.CodigoDane = @Divipola
		and ( P.IdPregunta = @IdPregunta or P.IdPregunta is null)
		order by NombrePrograma
	end
END

go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_ProgramasSeguimientoSIGOInsertUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_ProgramasSeguimientoSIGOInsertUpdate] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-06-15																			  
/Descripcion: Inserta  o actualiza la informacion de los programas de SIGO que provienen del WS de la Unidad De Victimas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_ProgramasSeguimientoSIGOInsertUpdate] 
	@Tipo [nvarchar](255)  ,
	@ANO INT ,
	@NumeroSeguimiento  INT,
	@IdTablero int ,
	@NumeroPrograma [int] ,
	@NombrePrograma [nvarchar](max) ,
	@DescripcionPrograma [nvarchar](max) ,
	@Vigencia [nvarchar](255) ,
	@Acreditado bit ,
	@NumeroBeneficiaios [int] ,
	@NumeroVictimas [int] ,
	@EstaEnTableroPAT bit ,
	@CodigoDane [int] ,
	@IdPregunta int ,
	@IdRespuesta int ,
	@IdRespuestaPrograma int ,
	@IdDerecho int ,
	@Nivel int 
AS 		
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
		
	IF(select top 1 1 from  [PAT].[PrecargueProgramasSIGOSeguimiento] where Tipo=@Tipo and ANO=@ANO and  NumeroSeguimiento =@NumeroSeguimiento and IdTablero=@IdTablero and NumeroPrograma=@NumeroPrograma ) >=1
	BEGIN
		update [PAT].[PrecargueProgramasSIGOSeguimiento]
					set Tipo=@Tipo,
						ANO=@ANO ,
						NumeroSeguimiento =@NumeroSeguimiento ,
						IdTablero=@IdTablero ,
						NumeroPrograma=@NumeroPrograma ,
						NombrePrograma=@NombrePrograma ,
						DescripcionPrograma= @DescripcionPrograma ,
						Vigencia=@Vigencia,
						Acreditado=@Acreditado,
						NumeroBeneficiaios=@NumeroBeneficiaios ,
						NumeroVictimas=@NumeroVictimas,
						EstaEnTableroPAT=@EstaEnTableroPAT,
						CodigoDane=@CodigoDane,
						IdPregunta=@IdPregunta ,
						IdRespuesta=@IdRespuesta ,
						IdRespuestaPrograma =@IdRespuestaPrograma ,
						IdDerecho=@IdDerecho ,
						Nivel=@Nivel ,
						FechaUltimaModificacion = GETDATE()
		where  Tipo=@Tipo and ANO=@ANO and  NumeroSeguimiento =@NumeroSeguimiento and IdTablero=@IdTablero and NumeroPrograma=@NumeroPrograma 

		SELECT @respuesta = 'Se ha modificado el registro'
		SELECT @estadoRespuesta = 1			
	END
	else	
	BEGIN
			INSERT INTO [PAT].[PrecargueProgramasSIGOSeguimiento]
					   (Tipo,
						ANO,
						NumeroSeguimiento,
						IdTablero ,
						NumeroPrograma,
						NombrePrograma,
						DescripcionPrograma,
						Vigencia,
						Acreditado,
						NumeroBeneficiaios,
						NumeroVictimas,
						EstaEnTableroPAT,
						CodigoDane,
						IdPregunta,
						IdRespuesta,
						IdRespuestaPrograma,
						IdDerecho ,
						Nivel ,
						FechaUltimaModificacion)
				 VALUES
					   (@Tipo,
						@ANO,
						@NumeroSeguimiento,
						@IdTablero ,
						@NumeroPrograma,
						@NombrePrograma,
						@DescripcionPrograma,
						@Vigencia,
						@Acreditado,
						@NumeroBeneficiaios,
						@NumeroVictimas,
						@EstaEnTableroPAT,
						@CodigoDane,
						@IdPregunta,
						@IdRespuesta,
						@IdRespuestaPrograma,
						@IdDerecho ,
						@Nivel ,
						GETDATE())

		SELECT @respuesta = 'Se ha ingresado el registro'
		SELECT @estadoRespuesta = 1			
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

go
IF  NOT EXISTS (select 1 from sys.columns where Name = N'IdTablero' and Object_ID = Object_ID(N'PAT.PreCargueSeguimiento'))
begin
	ALTER TABLE PAT.PreCargueSeguimiento ADD	
	IdTablero int NULL,
	FechaUltimaModificacion datetime NULL
end
go
update [PAT].[PreCargueSeguimiento] set IdTablero = 1 where IdTablero is null
go
IF  NOT EXISTS (select 1 from sys.columns where Name = N'FechaUltimaModificacion' and Object_ID = Object_ID(N'PAT.PrecargueSIGO'))
begin
	ALTER TABLE PAT.[PrecargueSIGO] ADD	
	FechaUltimaModificacion datetime NULL
end
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[D_AccesosEfectivosSeguimientoSIGODelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[D_AccesosEfectivosSeguimientoSIGODelete] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	 - Vilma Rodriguez																		  
/Fecha creacion:     2018-05-08																			  
/Descripcion: Borra todos los registros guardados de accesos para el tablero indicado
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[D_AccesosEfectivosSeguimientoSIGODelete] 
		@IdTablero int
AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
	BEGIN TRY		
		if exists(select top 1 1  from  [PAT].[PreCargueSeguimiento] where IdTablero =@IdTablero)
		begin
			delete [PAT].[PreCargueSeguimiento] where IdTablero =@IdTablero
			SELECT @respuesta = 'Se han eliminado los registros'
			SELECT @estadoRespuesta = 3	
		end
		else	
		begin
			SELECT @respuesta = 'No se encontro ningun registro para eliminar'
			SELECT @estadoRespuesta = 3	
		end				
	END TRY
	BEGIN CATCH
		SELECT @respuesta = ERROR_MESSAGE()
		SELECT @estadoRespuesta = 0
	END CATCH	

select @respuesta as respuesta, @estadoRespuesta as estado

go


	

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_AccesosEfectivosSeguimientoSIGOInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_AccesosEfectivosSeguimientoSIGOInsert] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-06-21																			  
/Descripcion: Inserta la informacion de los accesos efectivos de las necesidades de SIGO que provienen del WS de la Unidad De Victimas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_AccesosEfectivosSeguimientoSIGOInsert] 
	@FechaIngreso datetime
	,@TipoDocumento nvarchar(255)
	,@NumeroDocumento float
	,@PrimerNombre nvarchar(255)
	,@SegundoNombre nvarchar(255)
	,@PrimerApellido nvarchar(255)
	,@SegundoApellido nvarchar(255)
	,@FechaNacimiento datetime
	,@IdMedida float
	,@NombreMedida nvarchar(255)
	,@IdNecesidad float
	,@NombreNecesidad nvarchar(255)
	,@CodigoDane float
	,@Municipio nvarchar(255)
	,@RespuestaRetroalimentacion nvarchar(255)
	,@FechaAtencion datetime
	,@IdTablero int 	
AS 		
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	
	INSERT INTO [PAT].[PreCargueSeguimiento]
			([FechaIngreso]
			,[TipoDocumento]
			,[NumeroDocumento]
			,[PrimerNombre]
			,[SegundoNombre]
			,[PrimerApellido]
			,[SegundoApellido]
			,[FechaNacimiento]
			,[IdMedida]
			,[NombreMedida]
			,[IdNecesidad]
			,[NombreNecesidad]
			,[CodigoDane]
			,[Municipio]
			,[RespuestaRetroalimentacion]
			,[FechaAtencion]
			,IdTablero 
			,FechaUltimaModificacion
)
		VALUES
			(@FechaIngreso 
			,@TipoDocumento 
			,@NumeroDocumento 
			,@PrimerNombre
			,@SegundoNombre 
			,@PrimerApellido 
			,@SegundoApellido 
			,@FechaNacimiento 
			,@IdMedida 
			,@NombreMedida 
			,@IdNecesidad 
			,@NombreNecesidad 
			,@CodigoDane 
			,@Municipio 
			,@RespuestaRetroalimentacion
			,@FechaAtencion
			,@IdTablero 
			,GETDATE()
			)

SELECT @respuesta = 'Se ha ingresado el registro'
SELECT @estadoRespuesta = 1			
	
	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[D_NecesidadesSIGODelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[D_NecesidadesSIGODelete] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	 - Vilma Rodriguez																		  
/Fecha creacion:     2018-05-08																			  
/Descripcion: Borra todos los registros guardados de accesos para el tablero indicado
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[D_NecesidadesSIGODelete] 
		@IdTablero int
AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
	BEGIN TRY		
		if exists(select top 1 1  from  [PAT].[PrecargueSIGO] where IdTablero =@IdTablero)
		begin
			delete [PAT].[PrecargueSIGO] where IdTablero =@IdTablero
			SELECT @respuesta = 'Se han eliminado los registros'
			SELECT @estadoRespuesta = 3	
		end
		else	
		begin
			SELECT @respuesta = 'No se encontro ningun registro para eliminar'
			SELECT @estadoRespuesta = 3	
		end				
	END TRY
	BEGIN CATCH
		SELECT @respuesta = ERROR_MESSAGE()
		SELECT @estadoRespuesta = 0
	END CATCH	

select @respuesta as respuesta, @estadoRespuesta as estado

go


	

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_NecesdadesPlaneacionSIGOInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_NecesdadesPlaneacionSIGOInsert] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez																		  
/Fecha creacion: 2018-06-21																			  
/Descripcion: Inserta la informacion de los accesos efectivos de las necesidades de SIGO que provienen del WS de la Unidad De Victimas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_NecesdadesPlaneacionSIGOInsert] 
	@FechaNacimiento varchar(50)
	,@FechaIngreso varchar(50)
	,@IdentificadorMedida bigint
	,@NombreMedida varchar(8000)
	,@IdentificadorNecesidad bigint
	,@NombreNecesidad varchar(8000)
	,@CodigoDane bigint
	,@Municipio varchar(8000)
	,@IdTablero tinyint
	,@TipoDocumento varchar(100)
	,@NumeroDocumento float
	,@NombreVictima varchar(255)
AS 		
	DECLARE @respuesta AS NVARCHAR(MAX) = ''
	DECLARE @estadoRespuesta  AS INT = 0

	INSERT INTO [PAT].[PrecargueSIGO]
				([FechaNacimiento]
				,[FechaIngreso]
				,[IdentificadorMedida]
				,[NombreMedida]
				,[IdentificadorNecesidad]
				,[NombreNecesidad]
				,[CodigoDane]
				,[Municipio]
				,[IdTablero]
				,[TipoDocumento]
				,[NumeroDocumento]
				,[NombreVictima]
				,[FechaUltimaModificacion])
			VALUES
				(@FechaNacimiento
				,@FechaIngreso
				,@IdentificadorMedida
				,@NombreMedida
				,@IdentificadorNecesidad
				,@NombreNecesidad
				,@CodigoDane
				,@Municipio
				,@IdTablero
				,@TipoDocumento
				,@NumeroDocumento
				,@NombreVictima
				,GETDATE())


SELECT @respuesta = 'Se ha ingresado el registro'
SELECT @estadoRespuesta = 1			
	
	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado

go








