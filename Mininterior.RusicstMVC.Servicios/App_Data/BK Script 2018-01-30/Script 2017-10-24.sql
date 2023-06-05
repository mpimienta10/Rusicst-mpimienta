IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Evaluación Tablero PAT' AND IdRecurso = 14)
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON	
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso]) VALUES (65, 'Evaluación Tablero PAT', NULL, 14)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END
go
IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Evaluación Consolidado' AND IdRecurso = 14)
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON	
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso]) VALUES (66, 'Evaluación Consolidado', NULL, 14)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_EvaluacionSeguimiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_EvaluacionSeguimiento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez 
-- Create date:		17/10/2017
-- Modified date:	24/10/2017
-- Description:		Obtiene informacion para la evaluacion de un seguimiento
-- =============================================
ALTER PROC  [PAT].[C_EvaluacionSeguimiento] -- [PAT].[C_EvaluacionSeguimiento] 1, 11,11001,1, 375
(	@IdTablero INT , @IdDepartamento int, @IdMunicipio int,@IdDerecho int , @IdUsuario int)
AS
BEGIN			
		if (@IdMunicipio = 0)
		BEGIN 
		--Si es para todos los municipios:
		--Seguimiento Primer Semestre:(∑Avance Compromisos Primer Semestre de todos los municipios/ ∑ Compromisos  de todos los municipios)
		--Seguimiento Acumulado Anual: Lo mismo de arriba pero acumulado anual					
		select A.Id as IdPregunta, A.PreguntaIndicativa--, R.RespuestaCompromiso, R.Presupuesto, SG.CantidadPrimer, SG.PresupuestoPrimer
		--datos de alcaldias--		
		,isnull(CONVERT(DECIMAL(10,2),SUM(case when R.RespuestaCompromiso is null then 0 else SA.CantidadPrimer end) /SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end)),0) as AvancePrimerSemestreAlcaldias 		
		,isnull(CONVERT(DECIMAL(10,2),SUM(case when R.RespuestaCompromiso is null then 0 else SA.CantidadPrimer + SA.CantidadSegundo end) /SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end)),0) as AvanceSegundoSemestreAlcaldias 
		,isnull(SUM(case when R.Presupuesto is null then 0 else SA.PresupuestoPrimer end) /SUM(case when R.Presupuesto is null then 0 else R.Presupuesto end),0) as AvancePresupuestoPrimerSemestreAlcaldias 		
		,isnull(SUM(case when R.Presupuesto is null then 0 else SA.PresupuestoPrimer + SA.PresupuestoSegundo end) /SUM(case when R.Presupuesto is null then 0 else R.Presupuesto end),0) as AvancePresupuestoSegundoSemestreAlcaldias 		
		--datos de gobernaciones--
		,isnull(CONVERT(DECIMAL(10,2),SUM(case when R.RespuestaCompromiso is null then 0 else SG.CantidadPrimer end) /SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end)),0) as AvancePrimerSemestreGobernaciones 		
		,isnull(CONVERT(DECIMAL(10,2),SUM(case when R.RespuestaCompromiso is null then 0 else SG.CantidadPrimer + SG.CantidadSegundo end) /SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end)),0) as AvanceSegundoSemestreGobernaciones 
		,isnull(SUM(case when R.Presupuesto is null then 0 else SG.PresupuestoPrimer end) /SUM(case when R.Presupuesto is null then 0 else R.Presupuesto end),0) as AvancePresupuestoPrimerSemestreGobernaciones 		
		,isnull(SUM(case when R.Presupuesto is null then 0 else SG.PresupuestoPrimer + SG.PresupuestoSegundo end) /SUM(case when R.Presupuesto is null then 0 else R.Presupuesto end),0) as AvancePresupuestoSegundoSemestreGobernaciones 		
		FROM [PAT].PreguntaPAT as A		
		left outer join PAT.RespuestaPAT as R on A.Id = R.IdPreguntaPAT  and R.IdDepartamento = @IdDepartamento
		left outer join PAT.SeguimientoGobernacion as SG on A.Id = SG.IdPregunta and SG.IdUsuario = @IdUsuario	--usuario gobernacion			
		left outer join PAT.Seguimiento as SA on A.Id = SA.IdPregunta  and SA.IdUsuario = R.IdUsuario --usuario alcaldia 
		where A.Nivel = 3  and A.IdTablero = @IdTablero and A.IdDerecho = @IdDerecho
		group by A.Id,A.PreguntaIndicativa
		--order by A.Id,A.PreguntaIndicativa

		end
		else	
		BEGIN
			--Si es un muunicipio del departamento:
			--Seguimiento Primer Semestre:(Avance Presupuesto Primer Semestre/ Presupuesto)
			--Seguimiento Acumulado Anual:(Avance Compromisos Acumulado Anual/ Compromisos)

			select A.Id as IdPregunta, A.PreguntaIndicativa, R.RespuestaCompromiso, R.Presupuesto, SG.CantidadPrimer, SG.PresupuestoPrimer
			--datos de alcaldias--
			,CASE WHEN R.RespuestaCompromiso >0 THEN ISNULL( CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),SA.CantidadPrimer)/R.RespuestaCompromiso),0) ELSE 0 END as AvancePrimerSemestreAlcaldias 
			,CASE WHEN R.Presupuesto >0 THEN ISNULL(SA.PresupuestoPrimer/R.Presupuesto,0) ELSE 0 END as AvancePresupuestoPrimerSemestreAlcaldias
			,CASE WHEN R.RespuestaCompromiso >0 THEN ISNULL(CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),(SA.CantidadPrimer + SA.CantidadSegundo))/R.RespuestaCompromiso),0) ELSE 0 END as AvanceSegundoSemestreAlcaldias
			,CASE WHEN R.Presupuesto >0 THEN ISNULL((SA.PresupuestoPrimer + SA.PresupuestoSegundo)/R.Presupuesto,0) ELSE 0 END as AvancePresupuestoSegundoSemestreAlcaldias
			--datos de gobernaciones--
			,CASE WHEN R.RespuestaCompromiso >0 THEN ISNULL( CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),SG.CantidadPrimer)/R.RespuestaCompromiso),0) ELSE 0 END as AvancePrimerSemestreGobernaciones 
			,CASE WHEN R.Presupuesto >0 THEN ISNULL(SG.PresupuestoPrimer/R.Presupuesto,0) ELSE 0 END as AvancePresupuestoPrimerSemestreGobernaciones
			,CASE WHEN R.RespuestaCompromiso >0 THEN ISNULL(CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),(SG.CantidadPrimer + SG.CantidadSegundo))/R.RespuestaCompromiso),0) ELSE 0 END as AvanceSegundoSemestreGobernaciones 
			,CASE WHEN R.Presupuesto >0 THEN ISNULL((SG.PresupuestoPrimer + SG.PresupuestoSegundo)/R.Presupuesto,0) ELSE 0 END as AvancePresupuestoSegundoSemestreGobernaciones
			FROM [PAT].PreguntaPAT as A		
			left outer join PAT.RespuestaPAT as R on A.Id = R.IdPreguntaPAT  and R.IdDepartamento = 5 AND R.IdMunicipio = 5172
			left outer join PAT.SeguimientoGobernacion as SG on A.Id = SG.IdPregunta and SG.IdUsuario = 375	--usuario gobernacion			
			left outer join PAT.Seguimiento as SA on A.Id = SA.IdPregunta  and SA.IdUsuario = R.IdUsuario --usuario alcaldia 
			where A.Nivel = 3  and A.IdTablero = 1 and A.IdDerecho = 1
			order by A.PreguntaIndicativa			
		end
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_EvaluacionConsolidado]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_EvaluacionConsolidado] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez 
-- Create date:		24/10/2017
-- Modified date:	24/10/2017
-- Description:		Obtiene informacion para la evaluacion de un seguimiento de las preguntas del departamento 
-- Seguimiento Primer Semestre:(Avance Compromisos Primer Semestre/ Compromisos)  ----  (Avance Presupuesto Primer Semestre/ Presupuesto)
-- Seguimiento Acumulado Anual:(Avance Compromisos Acumulado Anual/ Compromisos)  ----  (Avance Presupuesto Acumulado Anual/ Presupuesto)		
-- =============================================
ALTER PROC  [PAT].[C_EvaluacionConsolidado] -- [PAT].[C_EvaluacionConsolidado] 1,50,1121
(	@IdTablero INT , @IdDepartamento int, @IdUsuario int)
AS
BEGIN			
	
		select A.Id as IdPregunta, A.PreguntaIndicativa, R.RespuestaCompromiso, R.Presupuesto, SG.CantidadPrimer, SG.PresupuestoPrimer
		,CASE WHEN R.RespuestaCompromiso >0 THEN ISNULL( CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),SG.CantidadPrimer)/R.RespuestaCompromiso),0) ELSE 0 END as AvancePrimerSemestreGobernaciones 
		,CASE WHEN R.Presupuesto >0 THEN ISNULL(SG.PresupuestoPrimer/R.Presupuesto,0) ELSE 0 END as AvancePresupuestoPrimerSemestreGobernaciones

		,CASE WHEN R.RespuestaCompromiso >0 THEN ISNULL(CONVERT(DECIMAL(10,2),CONVERT(DECIMAL(10,2),(SG.CantidadPrimer + SG.CantidadSegundo))/R.RespuestaCompromiso),0) ELSE 0 END as AvanceSegundoSemestreGobernaciones 
		,CASE WHEN R.Presupuesto >0 THEN ISNULL((SG.PresupuestoPrimer + SG.PresupuestoSegundo)/R.Presupuesto,0) ELSE 0 END as AvancePresupuestoSegundoSemestreGobernaciones

		FROM [PAT].PreguntaPAT as A		
		left outer join PAT.RespuestaPAT as R on A.Id = R.IdPreguntaPAT  and R.IdDepartamento = @IdDepartamento
		left outer join PAT.SeguimientoGobernacion as SG on A.Id = SG.IdPregunta and SG.IdUsuario = @IdUsuario
		left outer join Usuario as U on SG.IdUsuario = U.Id and R.IdDepartamento = U.IdDepartamento
		where A.Nivel = 2  and A.IdTablero = @IdTablero
	
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Usuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_Usuario] AS'
go
--==============================================================================================================
-- Autor : Christian Ospina
-- Fecha : 2017-04-05																			 
-- Descripción: Consulta la información de los usuarios para la rejilla de usuarios de acuerdo a los criterios
--				de filtro. Retira los usuarios que se encuentran retirados y rechazados																 
--==============================================================================================================
ALTER PROC [dbo].[C_Usuario]

	 @Id			INT = NULL
	,@Token			UNIQUEIDENTIFIER = NULL
	,@IdTipoUsuario	INT = NULL
	,@IdDepartamento INT = NULL
	,@IdMunicipio	INT = NULL
	,@UserName		VARCHAR(128) = NULL
	,@IdEstado		INT = NULL

AS
	BEGIN
		SELECT
			 [UserName]
--======================================================================================
-- ORDEN DE LA CONSULTA NECESARIA PARA QUE SE MUESTRE EN ESTE MISMO ORDEN EN LA REJILLA
--=======================================================================================
			,[Nombres]
			,[FechaSolicitud]
			,[Cargo]
			,[TelefonoFijo]
			,[T].[Nombre] TipoUsuario
			,[TelefonoCelular]
			,[Email]
			,[M].[Nombre] Municipio
			,[D].[Nombre] Departamento
			,[DocumentoSolicitud]
--=======================================================================================
			,[U].[Id]
			,[IdUser]
			,[IdTipoUsuario]
			,[U].[IdDepartamento]
			,[U].[IdMunicipio]
			,[U].[IdEstado]
			,[E].[Nombre] Estado
			,[IdUsuarioTramite]			
			,[TelefonoFijoIndicativo]
			,[TelefonoFijoExtension]
			,[EmailAlternativo]
			,[Enviado]
			,[DatosActualizados]
			,[Token]
			,[U].[Activo]
			,[FechaNoRepudio]
			,[FechaTramite]
			,[FechaConfirmacion]
			,T.Tipo AS TipoTipoUsuario	
		FROM 
			[dbo].[Usuario] U
			LEFT JOIN [dbo].[TipoUsuario] T ON [U].[IdTipoUsuario] = [T].[Id]
			LEFT JOIN [dbo].[Estado] E ON [U].[IdEstado] = [E].[Id]	
			LEFT JOIN [dbo].[Departamento] D on [D].[Id] = [U].[IdDepartamento]
			LEFT JOIN [dbo].[Municipio] M on [M].[Id] = [U].[IdMunicipio]
		WHERE 
			(@Id IS NULL OR [U].[Id] = @Id) 
			AND (@Token IS NULL OR [U].[Token] = @Token) 
			AND (@IdTipoUsuario IS NULL OR [U].[IdTipoUsuario] = @IdTipoUsuario) 
			AND (@IdDepartamento IS NULL OR [U].[IdDepartamento]  = @IdDepartamento )
			AND (@IdMunicipio IS NULL OR [U].[IdMunicipio] = @IdMunicipio)
			AND (@UserName IS NULL OR [U].[UserName] = @UserName)
			AND (@IdEstado IS NULL OR [U].[IdEstado] = @IdEstado)
			AND ([U].[IdEstado] <> 6) -- RETIRADO
			AND ([U].[IdEstado] <> 4) -- RECHAZADO
			AND (@Token IS NOT NULL OR [U].[IdEstado] <> 1) -- SOLICITADA

		ORDER BY 
			U.Nombres 
	END

go
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_RespuestasEncuestaXUsuario]') AND type in (N'P', N'PC')) 
	drop proc [dbo].[C_RespuestasEncuestaXUsuario]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_RespuestasEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_RespuestasEncuesta] AS'
go
--****************************************************************************************************
-- Autor: Liliana Rodriguez																			 
-- Fecha creacion: 2017-02-08																			 
-- Descripcion: Carga el listado de respuestas por encuesta en la rejilla por usuario.										
--****************************************************************************************************
ALTER PROCEDURE [dbo].[C_RespuestasEncuesta]
	@idMunicipio int
AS
	SELECT distinct
	 x.Id
		,x.Titulo
		,x.FechaFin
		,x.Ayuda
		,x.FechaInicio
	FROM 
		[dbo].[Encuesta] AS x
		INNER JOIN  [dbo].[Envio]  e ON x.Id = e.IdEncuesta
		INNER JOIN dbo.Usuario f ON e.IdUsuario = f.Id
	WHERE 
		f.IdMunicipio = @idMunicipio

go
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosEnSistema] ') AND type in (N'P', N'PC')) 
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosEnSistema]  AS'

GO
-- ===========================================================================================
-- Author:			Robinson Moscoso
-- Create date:	31/01/2017
-- Description:	Procedimiento que retorna la información de todos los usuario en el sistema
--				Esto quiere decir que coloca solo los usuarios que se encuentran aprobados
-- ===========================================================================================
ALTER PROCEDURE [dbo].[C_UsuariosEnSistema] 

AS
	BEGIN
		
		SELECT
			 [c].[Nombre] Departamento
			,[b].[Nombre] Municipio
			,[a].[Nombres] Nombre 
			,[a].[UserName] NombreDeUsuario
			,[a].[Email]
			,[a].[TelefonoCelular]
			,[d].[Nombre] TipoUsuario
			,[a].[Activo]
		FROM
			[dbo].[Usuario] a
			INNER JOIN [dbo].[TipoUsuario] d ON [a].[IdTipoUsuario] = [d].[Id]
			INNER JOIN [dbo].[AspNetUsers] u ON [a].[IdUser] = [u].[Id]
			LEFT OUTER JOIN [dbo].[Municipio] b ON [a].[IdMunicipio] = [b].[Id] 
			LEFT OUTER JOIN [dbo].[Departamento] c ON [a].[IdDepartamento] = [c].[Id]

		--WHERE 			([a].[IdEstado] = 5)
		ORDER BY 
			 [Departamento]
			,[Municipio]
			,[a].[Username]
	
	END	
		
	go
	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroMunicipioTotales]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroMunicipioTotales] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - liliana Rodriguez
-- Create date:		10/07/2017
-- Modified date:	24/10/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados, con las respuestas dadas por el gobernador 
-- Para traer el id de la respuesta se debe hacer el select del top 1 ya que se tienen varias respuesrtas repetidas
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
	DECLARE  @IDENTIDAD INT, @IDDEPARTAMENTO INT

	SELECT  @IDENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
	SELECT @IDDEPARTAMENTO = IdDepartamento FROM USUARIO WHERE Id = @IdUsuario

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
						CASE WHEN R.IdMunicipio IS NULL THEN @IDENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
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
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IDENTIDAD INT,@IdDerecho INT, @IDDEPARTAMENTO int'
		
	PRINT @SQL

	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IDENTIDAD=@IDENTIDAD, @IdDerecho=@IdDerecho, @IDDEPARTAMENTO=@IDDEPARTAMENTO
	SELECT * from @RESULTADO
END
go
	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoConsolidadoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoConsolidadoDepartamento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	29/08/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC [PAT].[C_TableroSeguimientoConsolidadoDepartamento] --[PAT].[C_TableroSeguimientoConsolidadoDepartamento]  1, 375, 6
(	@IdTablero INT ,@IdUsuario INT ,@IdDerecho INT )
AS
BEGIN
		
	DECLARE  @IdDepartamento INT	
	select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

--SELECT
--B.DESCRIPCION AS COMPONENTE
--,C.DESCRIPCION AS MEDIDA
--,E.DESCRIPCION AS DERECHO
--,A.PREGUNTA_INDICATIVA 
--,D.DESCRIPCION AS UNIDAD
--,SUM(ISNULL(RD.RESPUESTA_COMPROMISO, 0)) AS TOTALCOMPROMISO
--,SUM(ISNULL(RD.PRESUPUESTO, 0)) AS TOTALPRESUPUESTO
--,ISNULL(SUM(SM.CantidadPrimer), -1) AS AVANCEPRIMERALCALDIAS
--,ISNULL(SUM(SM.CantidadSegundo), -1) AS AVANCESEGUNDOALCALDIAS
--,ISNULL(SUM(SG.CantidadPrimer), -1) AS AVANCEPRIMERGOBERNA
--,ISNULL(SUM(SG.CantidadSegundo), -1) AS AVANCESEGUNDOGOBERNA
--,A.ID AS ID_PREGUNTA
--,E.ID AS ID_DERECHO
--FROM [PAT].[TB_PREGUNTA] A
--inner join [PAT].[TB_COMPONENTE] b on b.ID = a.[ID_COMPONENTE]
--inner join [PAT].[TB_MEDIDA] c on c.ID = a.ID_MEDIDA
--inner join [PAT].[TB_UNIDAD_MEDIDA] d on d.ID = a.ID_UNIDAD_MEDIDA
--inner join [PAT].[TB_DERECHO] e on e.ID = a.ID_DERECHO
--LEFT OUTER JOIN [PAT].[TB_PAT_RESPUESTA_DEPARTAMENTO] RD ON RD.ID_PREGUNTA = A.ID AND RD.ID_ENTIDAD = PAT.fn_GetIdEntidad(@IdUsuario) AND RD.ID_TABLERO = @IdTablero
--LEFT OUTER JOIN [PAT].[TB_SEGUIMIENTO] SM ON SM.IdPregunta = A.ID AND SM.IdTablero = RD.ID_TABLERO AND SM.IdUsuario = [PAT].[fn_GetIdUsuario](RD.ID_ENTIDAD_MUNICIPIO)
--LEFT OUTER JOIN [PAT].[TB_SEGUIMIENTO_GOBERNACION] SG ON SG.IdPregunta = A.ID AND SG.IdTablero = SM.IdTablero AND SG.IdUsuarioAlcaldia = SM.IdUsuario
--WHERE
--E.ID = @IdDerecho
--AND A.ACTIVO = @Activo
--AND A.ID >= @IdPreguntaIni AND A.ID <= @IdPreguntaFin
--GROUP BY
--B.DESCRIPCION, C.DESCRIPCION, A.PREGUNTA_INDICATIVA, D.DESCRIPCION, E.DESCRIPCION, A.ID, E.ID

	SELECT DISTINCT
	B.Descripcion AS Componente
	,C.Descripcion AS Medida
	,E.Descripcion AS Derecho
	,A.PreguntaIndicativa 
	,D.DESCRIPCION AS UNIDAD
	
	,SUM(ISNULL(RD.RespuestaCompromiso, 0)) AS TotalCompromiso
	,SUM(ISNULL(RD.Presupuesto, 0)) AS TotalPresupuesto
	
	,ISNULL(SUM(SM.CantidadPrimer), -1) AS AvancePrimerSemestreAlcladias
	,ISNULL(SUM(SM.CantidadSegundo), -1) AS AvanceSegundoSemestreAlcladias

	,ISNULL(SUM(SG.CantidadPrimer), -1) AS AvancePrimerSemestreGobernaciones
	,ISNULL(SUM(SG.CantidadSegundo), -1) AS AvanceSegundoSemestreGobernaciones
	,A.Id AS IdPregunta
	,E.Id AS IdDerecho
	FROM [PAT].PreguntaPAT as A
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	JOIN [PAT].RespuestaPATDepartamento as RD ON RD.IdPreguntaPAT = A.Id 
	join Usuario as URD on RD.IdUsuario = URD.Id and URD.IdDepartamento = @IdDepartamento	
	LEFT OUTER JOIN [PAT].Seguimiento as SM ON SM.IdPregunta = A.ID AND SM.IdTablero =a.IdTablero AND  SM.IdUsuario = RD.IdUsuario
	LEFT OUTER join Usuario as URS on SM.IdUsuario = URS.Id and  RD.IdMunicipioRespuesta  =URS.IdMunicipio
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion as SG ON SG.IdPregunta = A.ID AND SG.IdTablero = SM.IdTablero AND SG.IdUsuarioAlcaldia = SM.IdUsuario
	WHERE  URD.IdDepartamento = @IdDepartamento
	AND A.IdTablero = @IdTablero
	and E.ID = @IdDerecho
	AND A.ACTIVO = 1	
	and e.Id = @IdDerecho
	GROUP BY
	B.Descripcion, C.Descripcion, A.PreguntaIndicativa, D.Descripcion, E.Descripcion, A.Id, E.Id

END


--------------------------------------------------------------------------------------------------------------------------------
--------------------------------correr solo una vez de aqui para abajo.. son los sps viejos de pat------------------------------
--------------------------------------------------------------------------------------------------------------------------------

/****** Object:  StoredProcedure [PAT].[spGetAllEntidadesConRespuesta]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[spGetAllEntidadesConRespuesta]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroVigencia_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroVigencia_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroVigencia]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroVigencia]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroMunicipioTotales_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroMunicipioTotales_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroMunicipioTotales]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroMunicipioTotales]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroMunicipioRR]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroMunicipioRR]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroMunicipioRC_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroMunicipioRC_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroMunicipioRC]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroMunicipioRC]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroMunicipioAvance_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroMunicipioAvance_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroMunicipioAvance]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroMunicipioAvance]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroMunicipio_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroMunicipio_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroMunicipio]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroMunicipio]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroFechaActivo]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroFechaActivo]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroDepartamentoTotales_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroDepartamentoTotales_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroDepartamentoTotales]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroDepartamentoTotales]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroDepartamentoRR]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroDepartamentoRR]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroDepartamentoRC_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroDepartamentoRC_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroDepartamentoRC]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroDepartamentoRC]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroDepartamento_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroDepartamento_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetTableroDepartamento]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetTableroDepartamento]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetProgramasPAT]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetProgramasPAT]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetProgramasOferta]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetProgramasOferta]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetPreguntas]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetPreguntas]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetNecesidadesIdentificadas]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetNecesidadesIdentificadas]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetMunicipiosRR]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetMunicipiosRR]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetMunicipiosRC]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetMunicipiosRC]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetEntidadByUsuario]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetEntidadByUsuario]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetDerechos]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetDerechos]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetDatosExcel_Gob17]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetDatosExcel_Gob17]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetDatosExcel_Gob_RR17]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetDatosExcel_Gob_RR17]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetDatosExcel_Gob_RR]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetDatosExcel_Gob_RR]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetDatosExcel_Gob_RC17]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetDatosExcel_Gob_RC17]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetDatosExcel_Gob_RC]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetDatosExcel_Gob_RC]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetDatosExcel_Gob_Mpios17]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetDatosExcel_Gob_Mpios17]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetDatosExcel_Gob_Mpios]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetDatosExcel_Gob_Mpios]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetDatosExcel_Gob]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetDatosExcel_Gob]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetDatosExcel_A]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetDatosExcel_A]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetDatosExcel]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetDatosExcel]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarTableroMunicipioTotales_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarTableroMunicipioTotales_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarTableroMunicipioTotales]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarTableroMunicipioTotales]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarTableroMunicipioRR]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarTableroMunicipioRR]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarTableroMunicipioRC_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarTableroMunicipioRC_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarTableroMunicipioRC]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarTableroMunicipioRC]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarTableroMunicipio_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarTableroMunicipio_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarTableroMunicipio]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarTableroMunicipio]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarTableroDepartamentoRR]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarTableroDepartamentoRR]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarTableroDepartamentoRC_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarTableroDepartamentoRC_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarTableroDepartamentoRC]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarTableroDepartamentoRC]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarPreguntas]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarPreguntas]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarConsolidadosMunicipio_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarConsolidadosMunicipio_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetContarConsolidadosMunicipio]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetContarConsolidadosMunicipio]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetConsolidadosMunicipio_C]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetConsolidadosMunicipio_C]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetConsolidadosMunicipio]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetConsolidadosMunicipio]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetAllTablerosMunPorCompletar]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetAllTablerosMunPorCompletar]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetAllTablerosMunCompletos]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetAllTablerosMunCompletos]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetAllTablerosDepPorCompletar]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetAllTablerosDepPorCompletar]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetAllTablerosDepCompletos]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetAllTablerosDepCompletos]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetAccionesRRPAT]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetAccionesRRPAT]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetAccionesRCPAT]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetAccionesRCPAT]
GO
/****** Object:  StoredProcedure [PAT].[SP_GetAccionesPAT]    Script Date: 23/10/2017 17:05:09 ******/
DROP PROCEDURE [PAT].[SP_GetAccionesPAT]
GO





