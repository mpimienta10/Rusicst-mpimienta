IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroEncuestaNivel]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroEncuestaNivel] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 15/08/2017
-- Description:	obtiene la informacion Retroalimentacion de la grafica Nivel x encuesta
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroEncuestaNivel] 

	@IdRetroAdmin 				INT,
	@IdUser						VARCHAR(50)
	--@idDepartamento				INT,
	--@idMunicipo					INT


AS

Declare 
@IdEncuesta int,
@idDepartamento int,
@idMunicipo int,
@TotalPreguntas int,
@idUsuarioXMunicipoDep	int,
@TotalRespuestasXMunicipio int,
@TotalRespuestasXDepartamento int,
@NumUsuarioXDep int,
@PromedioDepartamental int,
@TotalRespuestasNacional int,
@NumUsuariosXAlcal int,
@PromedioNacional int,
@IdTipoUsuario int

SELECT @IdEncuesta = IdEncuesta from RetroAdmin where Id = @IdRetroAdmin
SELECT @idMunicipo = IdMunicipio from Usuario where UserName = @IdUser
SELECT @idDepartamento = IdDepartamento from Usuario where UserName = @IdUser
select @IdTipoUsuario = id from TipoUsuario where Tipo = 'ALCALDIA'

--Esta encuesta tiene @TotalPreguntas WHERE
select @TotalPreguntas = count(1) FROM Pregunta WHERE IdSeccion in( select id FROM Seccion where IdEncuesta = @IdEncuesta )

select @idUsuarioXMunicipoDep = id FROM Usuario WHERE UserName = @IdUser

--Este municipio responido a @TotalRespuestasXMunicipio preguntas de las TotalPreguntas
select @TotalRespuestasXMunicipio = count(1) FROM Respuesta WHERE IdPregunta in (
		select id FROM Pregunta WHERE IdSeccion in(select id FROM Seccion WHERE IdEncuesta = @IdEncuesta)) 
	AND IdUsuario = @idUsuarioXMunicipoDep  --Buscar usuario en base a municipio y gobernacion

--Este departamento responido a @TotalRespuestasXDepartamento preguntas de las TotalPreguntas
select @TotalRespuestasXDepartamento = count(1) FROM 
(select IdUsuario FROM Respuesta WHERE IdPregunta in ( select id from Pregunta WHERE IdSeccion in(
								select id from Seccion WHERE IdEncuesta = @IdEncuesta))) res
inner join Usuario U on res.IdUsuario = U.id
where IdDepartamento = @idDepartamento and IdTipoUsuario = @IdTipoUsuario

--Obtengo Numero de Usuarios x Departamento
select @NumUsuarioXDep = count(1) from Usuario
where IdDepartamento = @idDepartamento and IdTipoUsuario = @IdTipoUsuario

--select @TotalPreguntas
--select @TotalRespuestasXMunicipio
--select @TotalRespuestasXDepartamento

select @PromedioDepartamental = (@TotalRespuestasXDepartamento/@NumUsuarioXDep)
--select @PromedioDepartamental

--Promedio nacional 
select @TotalRespuestasNacional = count(1) from (select IdUsuario from Respuesta where IdPregunta in (
							select id from Pregunta where IdSeccion in(
								select id from Seccion where IdEncuesta = @IdEncuesta))) res
						inner join Usuario U on res.IdUsuario = U.id
						where IdTipoUsuario = @IdTipoUsuario

--total usuario alcaldias
select @NumUsuariosXAlcal = count(1) from Usuario where IdTipoUsuario = @IdTipoUsuario


SELECT @PromedioNacional = (@TotalRespuestasNacional/ @NumUsuariosXAlcal) -- PROMEDIO NACIONAL

IF (@TotalPreguntas != 0)
BEGIN
	Select	
		(@TotalRespuestasXMunicipio * 100)/ @TotalPreguntas as Municipio, 
		(@PromedioDepartamental * 100)/ @TotalPreguntas as PromedioDep, 
		(@PromedioNacional * 100)/ @TotalPreguntas as PromedioNac,
		@TotalPreguntas as TotalPreguntas,
		@TotalRespuestasXMunicipio as RespuestasMunicipio
END
ELSE
BEGIN
	Select	
		0 as Municipio, 
		0 as PromedioDep, 
		0 as PromedioNac,
		@TotalPreguntas as TotalPreguntas,
		@TotalRespuestasXMunicipio as RespuestasMunicipio
END

GO

--exec C_ConsultaRetroEncuestaNivel 1, 'alcaldia_abejorral_antioquia'
--exec C_ConsultaRetroEncuestaNivel 2, 'alcaldia_abejorral_antioquia'


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
 
 IF NOT EXISTS (select 1 from RetroGraficaNivel where IdRetroAdmin = @IdRetro)
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

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Rafael Alba																	 
-- Fecha creacion: 2017-07-03																			 
-- Descripcion: Trae las preguntas a dibujar por idseccion
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DibujarPreguntasSeccion] --521, 347

	 @IdSeccion	INT
	 ,@IdUsuario INT

AS
BEGIN

if @IdUsuario IS NULL
begin

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
		,'' AS Respuesta
		,S.IdEncuesta
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC
end
else
begin

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
		,ISNULL(r.Valor, '') as Respuesta
		,S.IdEncuesta
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
	LEFT OUTER JOIN [dbo].Respuesta r ON r.IdPregunta = p.Id and r.IdUsuario = @IdUsuario
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC

end
END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 03/05/2017
-- Description:	Selecciona la información de encuesta completadas por usuario
-- ============================================================================
ALTER PROCEDURE [dbo].[C_EncuestasXUsuarioCompletadas] --1, 1513

	@IdTipoUsuario	INT,
	@IdUsuario		INT

AS

	BEGIN


	if @IdTipoUsuario = (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE [Tipo] = 'ADMIN')
	begin

	SELECT 
			DISTINCT TOP 1000 [Id]
			,[Titulo]  
			,[FechaFin]
			,[Ayuda]
		FROM 
			[dbo].[Encuesta] a
		WHERE 
			[a].[FechaFin] < GETDATE()
			AND NOT EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
							WHERE [p].[IdEncuesta] = [a].[Id] 
							AND [p].[IdUsuario] = @IdUsuario
							AND [p].[FechaFin] > GETDATE()) 
		ORDER BY
			[Titulo]

	end
	else
	begin


		DECLARE @TabUsuarios TABLE
		(
			IdEncuesta	INT
		)
	
		INSERT INTO @TabUsuarios

		SELECT 
			 [RE].[IdEncuesta]
		FROM 
			[dbo].[AspNetUserRoles] R
			INNER JOIN [dbo].[AspNetUsers] AspU ON [R].[UserId] = [AspU].[Id]
			INNER JOIN [dbo].[Usuario] U ON [AspU].[Id] = [U].[IdUser]
			INNER JOIN [Roles].[RolEncuesta] RE on [RE].[IdRol] = [R].[RoleId]
		WHERE 
			[U].[Id] = @IdUsuario --OR @IdTipoUsuario = (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE [Tipo] = 'ADMIN')
	
		SELECT 
			DISTINCT TOP 1000 [Id]
			,[Titulo]  
			,[FechaFin]
			,[Ayuda]
		FROM 
			[dbo].[Encuesta] a
			INNER JOIN @TabUsuarios b on [b].[IdEncuesta] = [a].[Id]
		WHERE 
			[a].[FechaFin] < GETDATE()
			AND NOT EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
							WHERE [p].[IdEncuesta] = [a].[Id] 
							AND [p].[IdUsuario] = @IdUsuario
							AND [p].[FechaFin] > GETDATE()) 
		ORDER BY
			[Titulo]
			
			end
				
	END


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 03/05/2017
-- Description:	Selecciona la información de encuesta NO completadas por usuario
-- ============================================================================
ALTER PROCEDURE [dbo].[C_EncuestasXUsuarioNoCompletadas] --1, 1513
	
	@IdTipoUsuario	INT,
	@IdUsuario		INT

AS

	BEGIN


	if @IdTipoUsuario = (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE [Tipo] = 'ADMIN')
	begin

		SELECT 
			DISTINCT top 1000 [Id]
			,[Titulo]  
			,[FechaFin]
			,[Ayuda]
		FROM 
			[dbo].[Encuesta] a
		WHERE 
			([a].[FechaInicio] < GETDATE() AND [a].[FechaFin] > GETDATE())
			OR EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = [a].[Id] 
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()) 
		ORDER BY
			[Titulo]

	end
	else
	begin

		DECLARE @TabUsuarios table
		(
			IdEncuesta	INT
		)
	
		INSERT INTO @TabUsuarios

		SELECT 
			 [RE].[IdEncuesta]
		FROM 
			[dbo].[AspNetUserRoles] R
			INNER JOIN [dbo].[AspNetUsers] AspU ON [R].[UserId] = [AspU].[Id]
			INNER JOIN [dbo].[Usuario] U ON [AspU].[Id] = [U].[IdUser]
			INNER JOIN [Roles].[RolEncuesta] RE on [RE].[IdRol] = [R].[RoleId]
		WHERE 
			[U].[Id] = @IdUsuario --OR @IdTipoUsuario = (SELECT [Id] FROM [dbo].[TipoUsuario] WHERE [Tipo] = 'ADMIN')
	
		SELECT 
			DISTINCT top 1000 [Id]
			,[Titulo]  
			,[FechaFin]
			,[Ayuda]
		FROM 
			[dbo].[Encuesta] a
			INNER JOIN @TabUsuarios b on [b].[IdEncuesta] = [a].[Id]
		WHERE 
			([a].[FechaInicio] < GETDATE() AND [a].[FechaFin] > GETDATE())
			OR EXISTS(	SELECT 1 FROM [dbo].[PermisoUsuarioEncuesta] p 
						WHERE [p].[IdEncuesta] = [a].[Id] 
						AND [p].[IdUsuario] = @IdUsuario
						AND [p].[FechaFin] > GETDATE()) 
		ORDER BY
			[Titulo]	

	end

		
	END
		
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 17/06/2017
-- Description:	Selecciona la pregunta por código de pregunta
-- ============================================================
ALTER PROCEDURE [dbo].[C_PreguntaXCodigo] 

	@CodigoPregunta	 VARCHAR(8)
	,@IdSeccion INT

AS
	BEGIN
	
		SET NOCOUNT ON;
		
		if @IdSeccion is null
		begin

			SELECT 
				 a.IdPregunta
				 ,a.CodigoPregunta
				 ,a.NombrePregunta
				 ,a.IdTipoPregunta
			FROM 
				[BancoPreguntas].[Preguntas] a
			WHERE 
				a.[CodigoPregunta] =  @CodigoPregunta

		end
		else
		begin

			SELECT 
				 c.Id AS IdPregunta
				 ,a.CodigoPregunta
				 ,a.NombrePregunta
				 ,a.IdTipoPregunta
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
					d.Id = @IdSeccion


		end		

	END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		Equipo de desarrollo OIM - Rafael Alba
-- Create date: 17/06/2017
-- Description:	Selecciona la pregunta por código de pregunta
-- ============================================================
ALTER PROCEDURE [dbo].[C_PreguntaXCodigoNuevo] 

	@CodigoPregunta	 VARCHAR(8)
	,@IdEncuesta int

AS
	BEGIN
	
		SET NOCOUNT ON;
		SELECT 
			 c.Id AS IdPregunta
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

	END	

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ListadoPreguntasSoloSiXIdPregunta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListadoPreguntasSoloSiXIdPregunta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================
-- Author:		Equipo de desarrollo OIM - Andrés Bonilla
-- Create date: 29/09/2017
-- Description:	Retorna el Listado de Preguntas que dependen del parametro enviado
--				para poder determinar cuales deben ser recalculadas al momento del
--				evento onchange de los controles de la encuesta
-- ============================================================
ALTER PROCEDURE [dbo].[C_ListadoPreguntasSoloSiXIdPregunta] --
(
	@IdPregunta INT
)

AS

BEGIN

	SET NOCOUNT ON;

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
			,'' AS Respuesta
			,S.IdEncuesta
		FROM 
			[dbo].[Pregunta] p
			INNER JOIN 
				TipoPregunta TP 
					ON P.IdTipoPregunta = TP.Id
			INNER JOIN 
				dbo.Seccion S 				
					ON S.Id = p.IdSeccion
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
			,'' AS Respuesta
			,S.IdEncuesta
		FROM 
			[dbo].[Pregunta] p
			INNER JOIN 
				TipoPregunta TP 
					ON P.IdTipoPregunta = TP.Id
			INNER JOIN 
				dbo.Seccion S 				
					ON S.Id = p.IdSeccion
		WHERE 
			CHARINDEX(@NombrePregunta, SoloSi, 0) > 0
			AND
				IdSeccion = @IdSeccion
		ORDER BY
			p.Id 
				ASC

	END

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
-- Description:	obtiene la informacion de las recomendaciones x encuesta y usuario
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroAnaRecomendacion] 

	@IdEncuesta 				INT,
	@UserName					VARCHAR(50)
AS

DECLARE @idUser INT
SELECT @idUser = Id from Usuario where UserName = @UserName

IF NOT EXISTS (select 1 from RetroAnalisisRecomendacion where IdEncuesta = @IdEncuesta AND Usuario = @UserName  )
BEGIN
	insert into RetroAnalisisRecomendacion
	select spm.Titulo, ObjetivoGeneral, Recomendacion, ac.Accion, ac.FechaCumplimiento, 
	@IdEncuesta as IdEncuesta, 0 as AccionPermite, 0 as AccionCumplio, '' AS Observacion, 
	0 AS alcaldiaRespuesta, @UserName AS usuario
	from Encuesta E
	inner join [PlanesMejoramiento].[PlanMejoramientoEncuesta] pme on e.Id = pme.IdEncuesta
	inner join [PlanesMejoramiento].[PlanMejoramiento] pm on pm.IdPlanMejoramiento = pme.IdPlanMejoriamiento
	inner join [PlanesMejoramiento].[SeccionPlanMejoramiento] spm on pm.IdPlanMejoramiento = spm.IdPlanMejoramiento
	inner join [PlanesMejoramiento].[ObjetivoEspecifico] oe on spm.IdSeccionPlanMejoramiento = oe.IdSeccionPlanMejoramiento
	inner join [PlanesMejoramiento].[Recomendacion] r on oe.IdObjetivoEspecifico = r.IdObjetivoEspecifico
	inner join [PlanesMejoramiento].[AccionesPlan] ac on ac.IdRecomendacion = r.IdRecomendacion
	where e.Id = @IdEncuesta AND ac.IdUsuario = @idUser
	group by spm.Titulo, ObjetivoGeneral, Recomendacion, ac.Accion, ac.FechaCumplimiento
END

Select Id, Titulo, ObjetivoGeneral, Recomendacion, Accion, FechaCumplimiento, AccionPermite, AccionCumplio, Observacion, 
		alcaldiaRespuesta, usuario
		FROM RetroAnalisisRecomendacion
		where IdEncuesta = @IdEncuesta AND Usuario = @UserName

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_RetroAnaRecomendacionUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_RetroAnaRecomendacionUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 25/09/2017
-- Description:	actualiza el analisis de una recomendacion
-- =============================================
ALTER PROC [dbo].[U_RetroAnaRecomendacionUpdate] 

	@IdRetroAna 				INT,
	@AccionPermite				INT,
	@AccionCumplio				INT,
	@Observacion				VARCHAR(500),
	@alcaldiaRespuesta			INT
AS

-- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0 

 BEGIN  
  BEGIN TRANSACTION  
  BEGIN TRY  
	UPDATE [dbo].[RetroAnalisisRecomendacion]
	   SET [AccionPermite] = @AccionPermite
		  ,[AccionCumplio] = @AccionCumplio
		  ,[Observacion] = @Observacion
		  ,alcaldiaRespuesta = @alcaldiaRespuesta
	 WHERE Id = @IdRetroAna
      
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

 GO

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_RetroalimentacionUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_RetroalimentacionUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 28/09/2017
-- Description:	actualiza nombre realimentacion
-- =============================================
ALTER PROC [dbo].[U_RetroalimentacionUpdate] 
	@Nombre				varchar(50),
	@IdRetroAdmin		INT
AS

-- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0  

 BEGIN  
  BEGIN TRANSACTION  
  BEGIN TRY  
		UPDATE [dbo].[RetroAdmin]
			SET [Nombre] = @Nombre
			WHERE Id = @IdRetroAdmin
		SELECT @respuesta = 'Se ha Actualizado el registro'  
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
 
GO

--===========================================================================================
-- Insert de las categorías que no existen en la BD del rusicst
--===========================================================================================
IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Envío Email Masivo'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Envío Email Masivo', 72)
GO
IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Envío Email Prueba'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Envío Email Prueba', 73)
GO
IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Gestionar Solicitud de Usuario'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Gestionar Solicitud de Usuario', 74)
GO
IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Gestionar Permisos - Eliminar'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Gestionar Permisos - Eliminar', 75)
GO
IF(NOT EXISTS (SELECT * FROM [dbo].[Category] WHERE [CategoryName] = 'Gestionar Permisos - Adicionar'))
INSERT INTO [dbo].[Category]([CategoryName],[Ordinal]) VALUES ('Gestionar Permisos - Adicionar', 76)
GO


