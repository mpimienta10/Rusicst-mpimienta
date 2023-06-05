
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_CalculoEvaluacionSeguimientoPorMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_CalculoEvaluacionSeguimientoPorMunicipio] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez 
-- Create date:		17/10/2017
-- Modified date:	17/01/2018
-- Description:		Obtiene informacion para la evaluacion de un seguimiento
-- =============================================
alter PROC  [PAT].[C_CalculoEvaluacionSeguimientoPorMunicipio]
(	@IdTablero INT , @IdDepartamento int, @IdMunicipio int,@IdDerecho int)
AS
BEGIN			
			select @IdMunicipio as IdMunicipio ,IdPregunta, PreguntaIndicativa,
			--datos de alcaldias--
			case when AvancePrimerSemestreAlcaldias >100 then 100 else AvancePrimerSemestreAlcaldias end AvancePrimerSemestreAlcaldias,
			case when AvancePresupuestoPrimerSemestreAlcaldias >100 then 100 else AvancePresupuestoPrimerSemestreAlcaldias end AvancePresupuestoPrimerSemestreAlcaldias,
			case when AvanceAcumuladoAlcaldias >100 then 100 else AvanceAcumuladoAlcaldias end AvanceAcumuladoAlcaldias,
			case when AvancePresupuestoAcumuladoAlcaldias >100 then 100 else AvancePresupuestoAcumuladoAlcaldias end AvancePresupuestoAcumuladoAlcaldias,
			--datos de gobernaciones--			
			case when AvancePrimerSemestreGobernaciones >100 then 100 else AvancePrimerSemestreGobernaciones end AvancePrimerSemestreGobernaciones,
			case when AvancePresupuestoPrimerSemestreGobernaciones >100 then 100 else AvancePresupuestoPrimerSemestreGobernaciones end AvancePresupuestoPrimerSemestreGobernaciones,
			case when AvanceAcumuladoGobernaciones >100 then 100 else AvanceAcumuladoGobernaciones end AvanceAcumuladoGobernaciones,
			case when AvancePresupuestoGobernaciones >100 then 100 else AvancePresupuestoGobernaciones end AvancePresupuestoGobernaciones			
			from (
				select A.Id as IdPregunta, A.PreguntaIndicativa, 
				--datos de alcaldias--
				CASE WHEN SUM(ISNULL(R.RespuestaCompromiso,0)) >0 THEN  CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),SUM(ISNULL(SA.CantidadPrimer,0)))/ SUM(ISNULL(R.RespuestaCompromiso,0)))*100 ELSE 0 END as AvancePrimerSemestreAlcaldias 
				,CASE WHEN SUM(ISNULL(R.Presupuesto,0)) >0 THEN SUM(ISNULL(SA.PresupuestoPrimer,0)) / SUM(ISNULL(R.Presupuesto,0))*100  ELSE 0 END as AvancePresupuestoPrimerSemestreAlcaldias
				,CASE WHEN SUM(ISNULL(R.RespuestaCompromiso,0)) >0 THEN CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2), SUM( ISNULL( SA.CantidadPrimer,0) + ISNULL(SA.CantidadSegundo,0))) / SUM(ISNULL(R.RespuestaCompromiso,0)))*100 ELSE 0 END as AvanceAcumuladoAlcaldias
				,CASE WHEN SUM(ISNULL(R.Presupuesto,0)) >0 THEN SUM(ISNULL(SA.PresupuestoPrimer,0) + ISNULL(SA.PresupuestoSegundo,0)) / SUM(ISNULL(R.Presupuesto,0))*100 ELSE 0 END as AvancePresupuestoAcumuladoAlcaldias
				--datos de gobernaciones--
				,CASE WHEN SUM(ISNULL(RG.RespuestaCompromiso,0)) >0 THEN  CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),SUM(ISNULL(SG.CantidadPrimer,0)))/ SUM(ISNULL(RG.RespuestaCompromiso,0)))*100 ELSE 0 END as AvancePrimerSemestreGobernaciones 
				,CASE WHEN SUM(ISNULL(RG.Presupuesto,0)) >0 THEN SUM(ISNULL(SG.PresupuestoPrimer,0)) / SUM(ISNULL(RG.Presupuesto,0))*100 ELSE 0 END as AvancePresupuestoPrimerSemestreGobernaciones
				,CASE WHEN SUM(ISNULL(RG.RespuestaCompromiso,0)) >0 THEN CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2), SUM( ISNULL( SG.CantidadPrimer,0) + ISNULL(SG.CantidadSegundo,0))) / SUM(ISNULL(RG.RespuestaCompromiso,0)))*100 ELSE 0 END as AvanceAcumuladoGobernaciones
				,CASE WHEN SUM(ISNULL(RG.Presupuesto,0)) >0 THEN SUM(ISNULL(SG.PresupuestoPrimer,0) + ISNULL(SG.PresupuestoSegundo,0)) / SUM(ISNULL(RG.Presupuesto,0))*100 ELSE 0 END as AvancePresupuestoGobernaciones
				FROM [PAT].PreguntaPAT as A		
				left outer join PAT.RespuestaPAT as R on A.Id = R.IdPreguntaPAT 
				left outer join PAT.RespuestaPATDepartamento as RG on A.Id = RG.IdPreguntaPAT AND RG.IdMunicipioRespuesta = R.IdMunicipio 
				left outer join PAT.Seguimiento as SA on A.Id = SA.IdPregunta  and SA.IdUsuario = R.IdUsuario --usuario alcaldia 
				LEFT OUTER JOIN PAT.SeguimientoGobernacion as SG on A.Id = SG.IdPregunta and SG.IdUsuarioAlcaldia = SA.IdUsuario					
				where A.Nivel = 3  and A.IdTablero = @IdTablero and A.IdDerecho = @IdDerecho and R.IdMunicipio = @IdMunicipio and  R.IdDepartamento = @IdDepartamento
				group by A.Id, A.PreguntaIndicativa			
			) as A
			order by A.PreguntaIndicativa			
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_EvaluacionSeguimiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_EvaluacionSeguimiento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez 
-- Create date:		17/10/2017
-- Modified date:	18/01/2018
-- Description:		Obtiene informacion para la evaluacion de un seguimiento
-- =============================================
ALTER PROC  [PAT].[C_EvaluacionSeguimiento] 
(	@IdTablero INT , @IdDepartamento int, @IdMunicipio int,@IdDerecho int )
AS
BEGIN			
	
		declare @cantidadMunicipios int
		declare @IdMun int		

		declare @MunicipiosDepartamento table (
					IdMunicipio int,
					procesado bit
		)
		declare @ResultadosMunicipio table (
			IdMunicipio int,
			IdPregunta int,
			PreguntaIndicativa varchar(500),
			AvancePrimerSemestreAlcaldias decimal,
			AvancePresupuestoPrimerSemestreAlcaldias money,
			AvanceAcumuladoAlcaldias decimal,
			AvancePresupuestoAcumuladoAlcaldias money,
			AvancePrimerSemestreGobernaciones decimal,
			AvancePresupuestoPrimerSemestreGobernaciones money,
			AvanceAcumuladoGobernaciones decimal,
			AvancePresupuestoGobernaciones money
		)

		if (@IdMunicipio > 0)
		BEGIN 
			--Si es un municipio:
			--Seguimiento Primer Semestre:(Avance Presupuesto Primer Semestre/ Presupuesto)
			--Seguimiento Acumulado Anual:(Avance Compromisos Acumulado Anual/ Compromisos)	
			insert into @ResultadosMunicipio
			EXEC  [PAT].[C_CalculoEvaluacionSeguimientoPorMunicipio] @IdTablero =@IdTablero , @IdDepartamento =@IdDepartamento, @IdMunicipio =@IdMunicipio,@IdDerecho =@IdDerecho
			select IdPregunta ,PreguntaIndicativa ,AvancePrimerSemestreAlcaldias ,AvancePresupuestoPrimerSemestreAlcaldias ,AvanceAcumuladoAlcaldias ,AvancePresupuestoAcumuladoAlcaldias ,
			AvancePrimerSemestreGobernaciones ,AvancePresupuestoPrimerSemestreGobernaciones ,AvanceAcumuladoGobernaciones ,AvancePresupuestoGobernaciones 
			from @ResultadosMunicipio
		end
		else	
		BEGIN
			if (@IdDepartamento > 0)
			BEGIN 
				--Si es para un departamento:
				--Seguimiento Primer Semestre:(Promedio de los promedios S1) Sumatoria de los %S1 / cantidad de municipios
				--Seguimiento Acumulado Anual:(Promedio de los promedios S1 + S2) Sumatoria de los %Acumulados +  / cantidad de municipios
				
				select @cantidadMunicipios = COUNT(1) from Municipio where IdDepartamento = @IdDepartamento
				
				insert into @MunicipiosDepartamento
				select Id,0 from Municipio where IdDepartamento = @IdDepartamento

				while (select COUNT (1) from @MunicipiosDepartamento where procesado = 0 ) > 0
				begin 
					-- se toma uno a uno los municipios para calcuar los porcentajes e insertarlos a la tabla temporal
					select top 1 @IdMun = IdMunicipio from @MunicipiosDepartamento where procesado = 0
					
					insert into @ResultadosMunicipio
					EXEC  [PAT].[C_CalculoEvaluacionSeguimientoPorMunicipio] @IdTablero =@IdTablero , @IdDepartamento =@IdDepartamento, @IdMunicipio =@IdMun,@IdDerecho =@IdDerecho 
										
					update @MunicipiosDepartamento set procesado = 1 where IdMunicipio = @IdMun
				end

				--datos de alcaldias--
				select IdPregunta, PreguntaIndicativa, 
				sum(AvancePrimerSemestreAlcaldias)/@cantidadMunicipios as  AvancePrimerSemestreAlcaldias,
				sum(AvancePresupuestoPrimerSemestreAlcaldias)/@cantidadMunicipios as  AvancePresupuestoPrimerSemestreAlcaldias,
				sum(AvanceAcumuladoAlcaldias)/@cantidadMunicipios as  AvanceAcumuladoAlcaldias,
				sum(AvancePresupuestoAcumuladoAlcaldias)/@cantidadMunicipios as  AvancePresupuestoAcumuladoAlcaldias,
				--datos de gobernaciones--
				sum(AvancePrimerSemestreGobernaciones)/@cantidadMunicipios as  AvancePrimerSemestreGobernaciones,
				sum(AvancePresupuestoPrimerSemestreGobernaciones)/@cantidadMunicipios as  AvancePresupuestoPrimerSemestreGobernaciones,
				sum(AvanceAcumuladoGobernaciones)/@cantidadMunicipios as  AvanceAcumuladoGobernaciones,
				sum(AvancePresupuestoGobernaciones)/@cantidadMunicipios as  AvancePresupuestoGobernaciones
				from @ResultadosMunicipio		
				group by IdPregunta, PreguntaIndicativa		
				order by PreguntaIndicativa			
			end
			else	
			BEGIN
				--nacion
				--Si es para todo el pais :
				--Seguimiento Primer Semestre:(Promedio de los promedios S1) Sumatoria de los %S1 / cantidad de municipios
				--Seguimiento Acumulado Anual:(Promedio de los promedios S1 + S2) Sumatoria de los %Acumulados +  / cantidad de municipios
						
				select @cantidadMunicipios = COUNT(1) from Municipio 
				
				insert into @MunicipiosDepartamento
				select Id,0 from Municipio

				while (select COUNT (1) from @MunicipiosDepartamento where procesado = 0 ) > 0
				begin 
					-- se toma uno a uno los municipios para calcuar los porcentajes e insertarlos a la tabla temporal
					select top 1 @IdMun = IdMunicipio from @MunicipiosDepartamento where procesado = 0
					declare @IdDep int
					select @IdDep = IdDepartamento from Municipio where Id = @IdMun
					insert into @ResultadosMunicipio
					EXEC  [PAT].[C_CalculoEvaluacionSeguimientoPorMunicipio] @IdTablero =@IdTablero , @IdDepartamento =@IdDep, @IdMunicipio =@IdMun,@IdDerecho =@IdDerecho 
					update @MunicipiosDepartamento set procesado = 1 where IdMunicipio = @IdMun
				end

				--datos de alcaldias--
				select IdPregunta, PreguntaIndicativa, 
				sum(AvancePrimerSemestreAlcaldias)/@cantidadMunicipios as  AvancePrimerSemestreAlcaldias,
				sum(AvancePresupuestoPrimerSemestreAlcaldias)/@cantidadMunicipios as  AvancePresupuestoPrimerSemestreAlcaldias,
				sum(AvanceAcumuladoAlcaldias)/@cantidadMunicipios as  AvanceAcumuladoAlcaldias,
				sum(AvancePresupuestoAcumuladoAlcaldias)/@cantidadMunicipios as  AvancePresupuestoAcumuladoAlcaldias,
				--datos de gobernaciones--
				sum(AvancePrimerSemestreGobernaciones)/@cantidadMunicipios as  AvancePrimerSemestreGobernaciones,
				sum(AvancePresupuestoPrimerSemestreGobernaciones)/@cantidadMunicipios as  AvancePresupuestoPrimerSemestreGobernaciones,
				sum(AvanceAcumuladoGobernaciones)/@cantidadMunicipios as  AvanceAcumuladoGobernaciones,
				sum(AvancePresupuestoGobernaciones)/@cantidadMunicipios as  AvancePresupuestoGobernaciones
				from @ResultadosMunicipio		
				group by IdPregunta, PreguntaIndicativa		
				order by PreguntaIndicativa			
			end	
		end
END

go


-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez 
-- Create date:		24/10/2017
-- Modified date:	18/01/2018
-- Description:		Obtiene informacion para la evaluacion de un seguimiento de las preguntas del departamento 
-- Seguimiento Primer Semestre:(Avance Compromisos Primer Semestre/ Compromisos)  ----  (Avance Presupuesto Primer Semestre/ Presupuesto)
-- Seguimiento Acumulado Anual:(Avance Compromisos Acumulado Anual/ Compromisos)  ----  (Avance Presupuesto Acumulado Anual/ Presupuesto)		
-- =============================================
ALTER PROC  [PAT].[C_EvaluacionConsolidado] 
(	@IdTablero INT , @IdDepartamento int)
AS
BEGIN	
	declare @cantidadDepartamentos int
	declare @IdDep int		

	declare @Departamento table (
				IdDepartamento int,
				procesado bit
	)
	declare @ResultadosDepartamento table (
		IdDepartamento int,
		IdPregunta smallint,
		PreguntaIndicativa varchar(500),			
		AvancePrimerSemestreGobernaciones decimal,
		AvancePresupuestoPrimerSemestreGobernaciones money,
		AvanceAcumuladoGobernaciones decimal,
		AvancePresupuestoAcumuladoGobernaciones money
	)
	if (@IdDepartamento >0)
	begin
		select IdPregunta, PreguntaIndicativa,
		case when AvancePrimerSemestreGobernaciones >100 then 100 else AvancePrimerSemestreGobernaciones end AvancePrimerSemestreGobernaciones,
		case when AvancePresupuestoPrimerSemestreGobernaciones >100 then 100 else AvancePresupuestoPrimerSemestreGobernaciones end AvancePresupuestoPrimerSemestreGobernaciones,
		case when AvanceAcumuladoGobernaciones >100 then 100 else AvanceAcumuladoGobernaciones end AvanceAcumuladoGobernaciones,
		case when AvancePresupuestoAcumuladoGobernaciones >100 then 100 else AvancePresupuestoAcumuladoGobernaciones end AvancePresupuestoAcumuladoGobernaciones
		from (
			select A.Id as IdPregunta, A.PreguntaIndicativa, 
			CASE WHEN SUM(ISNULL(R.RespuestaCompromiso,0)) >0 THEN  CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),SUM(ISNULL(SA.CantidadPrimer,0)))/ SUM(ISNULL(R.RespuestaCompromiso,0)))*100 ELSE 0 END as AvancePrimerSemestreGobernaciones 
			,CASE WHEN SUM(ISNULL(R.Presupuesto,0)) >0 THEN SUM(ISNULL(SA.PresupuestoPrimer,0)) / SUM(ISNULL(R.Presupuesto,0))*100  ELSE 0 END as AvancePresupuestoPrimerSemestreGobernaciones
			,CASE WHEN SUM(ISNULL(R.RespuestaCompromiso,0)) >0 THEN CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2), SUM( ISNULL( SA.CantidadPrimer,0) + ISNULL(SA.CantidadSegundo,0))) / SUM(ISNULL(R.RespuestaCompromiso,0)))*100 ELSE 0 END as AvanceAcumuladoGobernaciones
			,CASE WHEN SUM(ISNULL(R.Presupuesto,0)) >0 THEN SUM(ISNULL(SA.PresupuestoPrimer,0) + ISNULL(SA.PresupuestoSegundo,0)) / SUM(ISNULL(R.Presupuesto,0))*100 ELSE 0 END as AvancePresupuestoAcumuladoGobernaciones
			FROM [PAT].PreguntaPAT as A		
			left outer join PAT.RespuestaPAT as R on A.Id = R.IdPreguntaPAT   and R.IdDepartamento = @IdDepartamento
			left outer join PAT.SeguimientoGobernacion as SA on A.Id = SA.IdPregunta  
			LEFT OUTER JOIN Usuario AS U ON SA.IdUsuario = U.Id and U.IdDepartamento = @IdDepartamento
			where A.Nivel = 2  and A.IdTablero = @IdTablero  
			group by A.Id, A.PreguntaIndicativa			
		) as A
		order by A.PreguntaIndicativa			
	end
	else
	begin
		select @cantidadDepartamentos = COUNT(1) from Departamento 
				
		insert into @Departamento
		select Id,0 from Departamento

		while (select COUNT (1) from @Departamento where procesado = 0 ) > 0
		begin 
			-- se toma uno a uno los departamentos para calcuar los porcentajes e insertarlos a la tabla temporal
			select top 1 @IdDep = IdDepartamento from @Departamento where procesado = 0
					
			insert into @ResultadosDepartamento												
			select @IdDep,IdPregunta, PreguntaIndicativa,
			case when AvancePrimerSemestreGobernaciones >100 then 100 else AvancePrimerSemestreGobernaciones end AvancePrimerSemestreGobernaciones,
			case when AvancePresupuestoPrimerSemestreGobernaciones >100 then 100 else AvancePresupuestoPrimerSemestreGobernaciones end AvancePresupuestoPrimerSemestreGobernaciones,
			case when AvanceAcumuladoGobernaciones >100 then 100 else AvanceAcumuladoGobernaciones end AvanceAcumuladoGobernaciones,
			case when AvancePresupuestoAcumuladoGobernaciones >100 then 100 else AvancePresupuestoAcumuladoGobernaciones end AvancePresupuestoAcumuladoGobernaciones
			from (
				select A.Id as IdPregunta, A.PreguntaIndicativa, 
				CASE WHEN SUM(ISNULL(R.RespuestaCompromiso,0)) >0 THEN  CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),SUM(ISNULL(SA.CantidadPrimer,0)))/ SUM(ISNULL(R.RespuestaCompromiso,0)))*100 ELSE 0 END as AvancePrimerSemestreGobernaciones 
				,CASE WHEN SUM(ISNULL(R.Presupuesto,0)) >0 THEN SUM(ISNULL(SA.PresupuestoPrimer,0)) / SUM(ISNULL(R.Presupuesto,0))*100  ELSE 0 END as AvancePresupuestoPrimerSemestreGobernaciones
				,CASE WHEN SUM(ISNULL(R.RespuestaCompromiso,0)) >0 THEN CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2), SUM( ISNULL( SA.CantidadPrimer,0) + ISNULL(SA.CantidadSegundo,0))) / SUM(ISNULL(R.RespuestaCompromiso,0)))*100 ELSE 0 END as AvanceAcumuladoGobernaciones
				,CASE WHEN SUM(ISNULL(R.Presupuesto,0)) >0 THEN SUM(ISNULL(SA.PresupuestoPrimer,0) + ISNULL(SA.PresupuestoSegundo,0)) / SUM(ISNULL(R.Presupuesto,0))*100 ELSE 0 END as AvancePresupuestoAcumuladoGobernaciones
				FROM [PAT].PreguntaPAT as A		
				left outer join PAT.RespuestaPAT as R on A.Id = R.IdPreguntaPAT   and R.IdDepartamento = @IdDep
				left outer join PAT.SeguimientoGobernacion as SA on A.Id = SA.IdPregunta  
				LEFT OUTER JOIN Usuario AS U ON SA.IdUsuario = U.Id and U.IdDepartamento = @IdDep
				where A.Nivel = 2  and A.IdTablero = @IdTablero  
				group by A.Id, A.PreguntaIndicativa			
			) as A
			order by A.PreguntaIndicativa		

			update @Departamento set procesado = 1 where IdDepartamento = @IdDep
		end	

		select IdPregunta, PreguntaIndicativa,
		sum (AvancePrimerSemestreGobernaciones)/@cantidadDepartamentos as AvancePrimerSemestreGobernaciones ,
		sum (AvancePresupuestoPrimerSemestreGobernaciones)/@cantidadDepartamentos as AvancePresupuestoPrimerSemestreGobernaciones ,
		sum (AvanceAcumuladoGobernaciones)/@cantidadDepartamentos as AvanceAcumuladoGobernaciones ,
		sum (AvancePresupuestoAcumuladoGobernaciones)/@cantidadDepartamentos as AvancePresupuestoAcumuladoGobernaciones 
		from @ResultadosDepartamento		
		group by IdPregunta, PreguntaIndicativa		
		order by PreguntaIndicativa		
	end
END
go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_SeguimientoNacionalPorMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_SeguimientoNacionalPorMunicipio] AS'
go

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/11/2017
-- Modified date:	28/11/2017
-- Description:		Obtiene informacion del seguimiento municipal de la informacion de entidades nacionales.(esta pendiente de implementar dado que no se tiene informacion)
-- =============================================
ALTER PROC  [PAT].[C_SeguimientoNacionalPorMunicipio] --pat.[C_SeguimientoNacionalPorMunicipio] 5172,21
( @IdMunicipio INT ,@IdPregunta INT )
AS
BEGIN
		
	declare @CompromisoN int, @PresupuestoN int, @CantidadPrimerSemestreN int,@CantidadSegundoSemestreN int,@PresupuestoPrimerSemestreN int,@PresupuestoSegundoSemestreN int, @CompromisoTotalN INT,@PresupuestoTotalN INT			
	select   @CompromisoN =0, @PresupuestoN = 0,@CantidadPrimerSemestreN = 0,@CantidadSegundoSemestreN = 0, @PresupuestoPrimerSemestreN = 0, @PresupuestoSegundoSemestreN = 0, @CompromisoTotalN = 0,@PresupuestoTotalN = 0				
	
	select   @CompromisoN as CompromisoN  , @PresupuestoN as PresupuestoN ,@CantidadPrimerSemestreN as CantidadPrimerSemestreN,@CantidadSegundoSemestreN as CantidadSegundoSemestreN , @PresupuestoPrimerSemestreN as PresupuestoPrimerSemestreN , @PresupuestoSegundoSemestreN as PresupuestoSegundoSemestreN , @CompromisoTotalN as CompromisoTotalN  ,@PresupuestoTotalN as PresupuestoTotalN
	
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DibujarSeccion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarSeccion] AS'
go


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Rafael Alba																	 
-- Modifica: Equipo de desarrollo OIM - Andrés Bonilla
-- Fecha creacion: 2017-06-27																			 
-- Fecha modificacion: 2018-01-18
-- Descripcion: Trae el diseño de ña encuesta por idseccion
-- Modificacion: Se quitan los sh-no cuando ya hay respuesta, se agrega idusuario para validar respuestas.
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DibujarSeccion] --4869, 331
	 @IdSeccion	INT
	 ,@IdUsuario INT
AS
BEGIN
	/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [Id]
      ,[IdSeccion]
      ,(
			CASE 
				WHEN CHARINDEX('sh-no-', [Texto]) > 0 
					THEN 
						(
							CASE WHEN 
							dbo.NuevaFilaRespuestas(@IdUsuario, @IdSeccion, [RowIndex]) = 1
							THEN ''
							ELSE Texto
							END
						) 
				ELSE 
					[Texto] 
			END 
		)AS Texto
      ,[ColumnSpan]
      ,[RowSpan]
      ,[RowIndex]
      ,[ColumnIndex]
  FROM [dbo].[Diseno]
  WHERE IdSeccion = @IdSeccion
	ORDER BY 
		ID
  END

  GO

  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.NuevaFilaRespuestas') AND type in (N'F', N'TF')) 
begin
	drop FUNCTION dbo.NuevaFilaRespuestas
end

GO

  CREATE FUNCTION dbo.NuevaFilaRespuestas
(
	@IdUsuario INT
	,@IdSeccion INT
	,@RowIndex INT

)
returns BIT
begin

declare @ret bit

IF EXISTS (SELECT top 1 * FROM dbo.Respuesta xx WHERE xx.IdUsuario = @IdUsuario AND xx.IdPregunta in (select xxxx.Id from dbo.Pregunta xxxx where xxxx.RowIndex = @RowIndex and IdSeccion = @IdSeccion))
BEGIN
set @ret = 1
END 
ELSE
BEGIN
set @ret = 0
END

return @ret

end

GO