IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_RetroHistorialTodosInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_RetroHistorialTodosInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 18/09/2017
-- Description:	obtiene la informacion Retroalimentacion de la grafica Nivel x encuesta
-- Modificacion: 14/03/2018 - Se incluye validacion para tipo de encuestas TIPO_ANTIGUO
-- =============================================
ALTER PROCEDURE [I_RetroHistorialTodosInsert] 
	@Encuesta			INT, --30
	@IdPregunta			VARCHAR(8), --10007189
	@Nombre				VARCHAR(8)

AS

DECLARE @respuesta AS NVARCHAR(2000) = ''    
DECLARE @estadoRespuesta  AS INT = 0   


IF EXISTS (select 1 from RetroHistorialRusicst where IdEncuesta = @Encuesta) 
BEGIN
	SELECT @respuesta = 'Ya existe un historial para esta encuesta'    
	SELECT @estadoRespuesta = 0 
END
ELSE
BEGIN

--INSERT INTO [dbo].[RetroHistorialRusicst]
--           ([Usuario], [Periodo], [Guardo], [Completo], [Diligencio], [Adjunto], [Envio], [CodigoPregunta], [IdEncuesta], [Nombre])
--     VALUES
--           ('Admin','nop',0,0,0,0,0, @IdPregunta, @Encuesta, @Nombre)

	DECLARE @Envio TABLE (UserName VARCHAR(50), ENVIO varchar(2) )
	DECLARE @Diligencio TABLE (UserName VARCHAR(50), Diligencio varchar(2) )
	DECLARE @Completo TABLE (UserName VARCHAR(50), Completo varchar(2) )
	DECLARE @Guardo TABLE (UserName VARCHAR(50), Guardo varchar(2) )
	DECLARE @Carta TABLE (UserName VARCHAR(50), Carta varchar(2) )
	DECLARE @RolEncuesta varchar(100)
	DECLARE @tipoRol INT = 0

	IF (@Encuesta > 81 OR @Encuesta IN (77, 78))
		BEGIN 
			select @tipoRol = 1
			Select @RolEncuesta = b.Name
			from [Roles].[RolEncuesta] a
			inner join dbo.AspNetRoles b ON b.Id = a.IdRol
			where a.IdEncuesta = @Encuesta
		END


	DECLARE @TipoEncuesta varchar(20)
	select @TipoEncuesta = Nombre from TipoEncuesta where Id = (select IdTipoEncuesta from Encuesta where id=@Encuesta)

	--ENVIO -- C_ConsultaRetroUsariosEnviaronReporte
	if (@Encuesta<58)
	BEGIN
	INSERT INTO @Envio 
	SELECT Username, [ENVIO] from(
	SELECT usuario.Username, 1 AS [ENVIO]
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  )
					AND (dbo.Usuario.Id IN (SELECT DISTINCT IdUsuario
												  FROM dbo.Envio
												  WHERE (IdEncuesta = @Encuesta)))
	UNION ALL
	SELECT usuario.Username, 0 AS ENVIO
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) as tipo  )
					AND (dbo.Usuario.Id not IN (SELECT DISTINCT IdUsuario
												  FROM dbo.Envio
												  WHERE (IdEncuesta = @Encuesta)) )                                            
	) as env1                                              
	END
	ELSE
	BEGIN
	INSERT INTO @Envio 
	SELECT Username, [ENVIO] from(
	SELECT usuario.Username, 1 AS [ENVIO]
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo = CASE WHEN @tipoRol = 0 THEN (select  substring(@TipoEncuesta,6,11) as tipo  ) ELSE @RolEncuesta END
					AND (dbo.Usuario.Id IN (SELECT DISTINCT PlanesMejoramiento.FinalizacionPlan.IdUsuario
	FROM         PlanesMejoramiento.FinalizacionPlan INNER JOIN
						  PlanesMejoramiento.PlanMejoramiento ON PlanesMejoramiento.FinalizacionPlan.IdPlan = PlanesMejoramiento.PlanMejoramiento.IdPlanMejoramiento INNER JOIN
						  PlanesMejoramiento.PlanMejoramientoEncuesta ON 
						  PlanesMejoramiento.PlanMejoramiento.IdPlanMejoramiento = PlanesMejoramiento.PlanMejoramientoEncuesta.IdPlanMejoriamiento INNER JOIN
						  dbo.Encuesta ON PlanesMejoramiento.PlanMejoramientoEncuesta.IdEncuesta = dbo.Encuesta.Id AND 
						  PlanesMejoramiento.PlanMejoramientoEncuesta.IdEncuesta = dbo.Encuesta.Id
	WHERE     (dbo.Encuesta.Id = @Encuesta))) 

	UNION ALL

	SELECT usuario.Username,0 AS ENVIO
	FROM   dbo.Usuario LEFT OUTER JOIN
		   dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
		   dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo = CASE WHEN @tipoRol = 0 THEN (select  substring(@TipoEncuesta,6,11) as tipo  ) ELSE @RolEncuesta END
				  AND (dbo.Usuario.Id  NOT IN (SELECT DISTINCT PlanesMejoramiento.FinalizacionPlan.IdUsuario
	FROM         PlanesMejoramiento.FinalizacionPlan INNER JOIN
						  PlanesMejoramiento.PlanMejoramiento ON PlanesMejoramiento.FinalizacionPlan.IdPlan = PlanesMejoramiento.PlanMejoramiento.IdPlanMejoramiento INNER JOIN
						  PlanesMejoramiento.PlanMejoramientoEncuesta ON 
						  PlanesMejoramiento.PlanMejoramiento.IdPlanMejoramiento = PlanesMejoramiento.PlanMejoramientoEncuesta.IdPlanMejoriamiento INNER JOIN
						  dbo.Encuesta ON PlanesMejoramiento.PlanMejoramientoEncuesta.IdEncuesta = dbo.Encuesta.Id AND 
						  PlanesMejoramiento.PlanMejoramientoEncuesta.IdEncuesta = dbo.Encuesta.Id
	WHERE     (dbo.Encuesta.Id = @Encuesta))) 
	) env

	end

	--DILIGENCIO  --C_ConsultaRetroUsariosGuardaronInformacionAutoevaluacion
	if @Encuesta<58
	BEGIN
	INSERT INTO @Diligencio
	SELECT Username, [INFORMACION EN AUTOEVALUACION] from(
	SELECT    usuario.Username , 1 AS [INFORMACION EN AUTOEVALUACION]
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11)) 
									  AND (dbo.Usuario.Id 
										  IN (SELECT DISTINCT IdUsuario 
											  FROM dbo.Autoevaluacion2 
											   WHERE (IdEncuesta = @Encuesta)
														AND Recomendacion IS NOT NULL 
														AND LEN(Acciones)>0))
	UNION ALL
	SELECT    usuario.Username, 0 AS  [INFORMACION EN AUTOEVALUACION]
	FROM         dbo.Usuario LEFT OUTER JOIN
						  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
						  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo in (select  substring(@TipoEncuesta,6,11) ) 
									  AND (dbo.Usuario.Id NOT IN (SELECT DISTINCT IdUsuario 
																		 FROM dbo.Autoevaluacion2 
																		 WHERE (IdEncuesta = @Encuesta)
													   AND Recomendacion IS NOT NULL 
													   AND LEN(Acciones)>0))
	) dil1
	END
	else
	begin
	INSERT INTO @Diligencio
	SELECT Username, [INFORMACION EN AUTOEVALUACION] from(
	SELECT    usuario.Username, 1 AS [INFORMACION EN AUTOEVALUACION]
	FROM      dbo.Usuario LEFT OUTER JOIN
			  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
			  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo = CASE WHEN @tipoRol = 0 THEN (select  substring(@TipoEncuesta,6,11) as tipo  ) ELSE @RolEncuesta END
									  AND (dbo.Usuario.Id 
									  IN (SELECT DISTINCT PlanesMejoramiento.AccionesPlan.IdUsuario
	FROM         PlanesMejoramiento.AccionesPlan INNER JOIN
						  PlanesMejoramiento.Recomendacion ON PlanesMejoramiento.AccionesPlan.IdRecomendacion = PlanesMejoramiento.Recomendacion.IdRecomendacion INNER JOIN
						  dbo.Pregunta ON PlanesMejoramiento.Recomendacion.IdPregunta = dbo.Pregunta.Id INNER JOIN
						  dbo.Seccion ON dbo.Pregunta.IdSeccion = dbo.Seccion.Id AND dbo.Pregunta.IdSeccion = dbo.Seccion.Id
	WHERE     (dbo.Seccion.IdEncuesta = @Encuesta) AND (PlanesMejoramiento.AccionesPlan.Accion IS NOT NULL)))
	UNION ALL
	SELECT    usuario.Username, 0 AS  [INFORMACION EN AUTOEVALUACION]
	FROM      dbo.Usuario LEFT OUTER JOIN
						  dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
						  dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
			  dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo = CASE WHEN @tipoRol = 0 THEN (select  substring(@TipoEncuesta,6,11) as tipo  ) ELSE @RolEncuesta END
									  AND (dbo.Usuario.Id  NOT IN (SELECT DISTINCT PlanesMejoramiento.AccionesPlan.IdUsuario
	FROM         PlanesMejoramiento.AccionesPlan INNER JOIN
						  PlanesMejoramiento.Recomendacion ON PlanesMejoramiento.AccionesPlan.IdRecomendacion = PlanesMejoramiento.Recomendacion.IdRecomendacion INNER JOIN
						  dbo.Pregunta ON PlanesMejoramiento.Recomendacion.IdPregunta = dbo.Pregunta.Id INNER JOIN
						  dbo.Seccion ON dbo.Pregunta.IdSeccion = dbo.Seccion.Id AND dbo.Pregunta.IdSeccion = dbo.Seccion.Id
	WHERE     (dbo.Seccion.IdEncuesta = @Encuesta) AND (PlanesMejoramiento.AccionesPlan.Accion IS NOT NULL)))
	)dil2
	END
	---COMPLETO --C_ConsultaRetroUsuariosPasaronAutoevaluación
	BEGIN
	INSERT INTO @Completo
	SELECT Username, [PASO A AUTOEVALUACION] from(
	SELECT usuario.Username,1 AS [PASO A AUTOEVALUACION]
	FROM dbo.Usuario LEFT OUTER JOIN
	dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
	dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
	dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id

	WHERE     TU.Tipo = CASE WHEN @tipoRol = 0 THEN (select  substring(@TipoEncuesta,6,11) as tipo  ) ELSE @RolEncuesta END
	AND (dbo.Usuario.Id IN 
	(select a.IdUsuario from 
	(SELECT   IdUsuario
	FROM Respuesta 
	WHERE IdPregunta IN ((SELECT dbo.Pregunta.Id
	FROM dbo.Seccion INNER JOIN dbo.Pregunta ON dbo.Seccion.Id = dbo.Pregunta.IdSeccion
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta) 
	AND (dbo.Pregunta.EsObligatoria = 1)) )and valor!='-' 
	GROUP BY convert(char,IdUsuario)+'_'+convert(char,IdPregunta), IdUsuario) a
	GROUP BY  IdUsuario
	having (SELECT COUNT (*)
	FROM dbo.Seccion INNER JOIN dbo.Pregunta ON dbo.Seccion.Id = dbo.Pregunta.IdSeccion
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta) 
	AND (dbo.Pregunta.EsObligatoria = 1)) - COUNT(*)<1))

	UNION ALL

	SELECT usuario.Username, 0 AS [PASO A AUTOEVALUACION]
	FROM dbo.Usuario LEFT OUTER JOIN
	dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
	dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
	dbo.TipoUsuario TU ON  Usuario.IdTipoUsuario = TU.Id
	WHERE     TU.Tipo = CASE WHEN @tipoRol = 0 THEN (select  substring(@TipoEncuesta,6,11) as tipo  ) ELSE @RolEncuesta END
	AND (dbo.Usuario.Id not IN
	(select a.IdUsuario from 
	(SELECT   IdUsuario
	FROM Respuesta 
	WHERE IdPregunta IN ((SELECT dbo.Pregunta.Id
	FROM dbo.Seccion INNER JOIN dbo.Pregunta ON dbo.Seccion.Id = dbo.Pregunta.IdSeccion
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta) 
	AND (dbo.Pregunta.EsObligatoria = 1)) )and valor!='-' 
	GROUP BY convert(char,IdUsuario)+'_'+convert(char,IdPregunta), IdUsuario) a
	GROUP BY  IdUsuario
	having (SELECT COUNT (*)
	FROM dbo.Seccion INNER JOIN dbo.Pregunta ON dbo.Seccion.Id = dbo.Pregunta.IdSeccion
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta) 
	AND (dbo.Pregunta.EsObligatoria = 1)) - COUNT(*)<1))
	) comp
	END

	--GUARDO --C_ConsultaRetroUsuariosGuardaronInformacionSistema
	declare @temp table (IdUser int)
	insert into @temp 
	SELECT DISTINCT dbo.Respuesta.IdUsuario
		FROM dbo.Respuesta INNER JOIN
			dbo.Pregunta ON dbo.Respuesta.IdPregunta = dbo.Pregunta.Id INNER JOIN
			dbo.Seccion ON dbo.Pregunta.IdSeccion = dbo.Seccion.Id INNER JOIN
			dbo.Usuario ON dbo.Respuesta.IdUsuario = dbo.Usuario.Id 
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta)
	
	INSERT INTO @Guardo
	SELECT Username, [GUARDO] from(
	SELECT usuario.Username, 1 AS [GUARDO]
	FROM dbo.Usuario LEFT OUTER JOIN
		dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
		dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
		dbo.TipoUsuario TU ON Usuario.IdTipoUsuario = TU.Id
		WHERE     TU.Tipo = CASE WHEN @tipoRol = 0 THEN (select  substring(@TipoEncuesta,6,11) as tipo  ) ELSE @RolEncuesta END
		AND dbo.Usuario.Id   IN
	(SELECT DISTINCT dbo.Respuesta.IdUsuario
		FROM dbo.Respuesta INNER JOIN
			dbo.Pregunta ON dbo.Respuesta.IdPregunta = dbo.Pregunta.Id INNER JOIN
			dbo.Seccion ON dbo.Pregunta.IdSeccion = dbo.Seccion.Id INNER JOIN
			dbo.Usuario ON dbo.Respuesta.IdUsuario = dbo.Usuario.Id
	WHERE (dbo.Seccion.IdEncuesta = @Encuesta)) 
	UNION ALL
	
	SELECT usuario.Username, 0 AS [GUARDO]
	FROM dbo.Usuario LEFT OUTER JOIN
		dbo.Municipio ON dbo.Usuario.IdMunicipio = dbo.Municipio.Id LEFT OUTER JOIN
		dbo.Departamento ON dbo.Usuario.IdDepartamento = dbo.Departamento.Id INNER JOIN
		dbo.TipoUsuario TU ON Usuario.IdTipoUsuario = TU.Id
		WHERE     TU.Tipo = CASE WHEN @tipoRol = 0 THEN (select  substring(@TipoEncuesta,6,11) as tipo  ) ELSE @RolEncuesta END
		AND dbo.Usuario.Id   NOT IN (select IdUser from @temp)
	) gua

	--CARTA AVAL
	INSERT INTO @Carta
	SELECT Username, CartaAval from(
	SELECT U.UserName,
		 r.Valor
		  ,CAST(CASE r.Valor
			WHEN ISNULL(r.Valor,0) THEN 1
			ELSE 0 END as bit) CartaAval
	  FROM [BancoPreguntas].[Preguntas] P
	  INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
	  INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
	  INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
	  INNER JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @Encuesta
	  LEFT JOIN Respuesta r ON PO.Id = r.IdPregunta --AND r.IdUsuario = @IdUser
	  INNER JOIN Usuario U ON r.IdUsuario = U.Id
	  WHERE CodigoPregunta = @IdPregunta
	  ) car


	INSERT INTO [dbo].[RetroHistorialRusicst]
	SELECT	E.UserName AS Usuario, @Nombre AS Periodo, 
			convert(Bit, G.Guardo) AS Guardo, convert(Bit, C.Completo) AS Completo, convert(Bit, D.Diligencio) AS Diligencio, 
			convert(Bit, E.ENVIO) AS Adjunto, convert(Bit, ISNULL(CA.Carta,0)) AS Envio , @IdPregunta AS CodigoPregunta, 
			@Encuesta IdEncuesta, @Nombre Nombre
	FROM @Diligencio D 
	INNER JOIN @Envio E on D.UserName = E.UserName
	INNER JOIN @Completo C on D.UserName = C.UserName
	INNER JOIN @Guardo G on D.UserName = G.UserName
	LEFT  JOIN @Carta CA on D.UserName = CA.UserName
	ORDER BY E.UserName

	SELECT @respuesta = 'Historial creado con exito'    
	SELECT @estadoRespuesta = 1

END

SELECT @respuesta AS respuesta, @estadoRespuesta AS estado       

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
	@IdEncuesta INT,
	@IdUsuario INT
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
			IF exists (select * from Respuesta r
				where r.IdPregunta = @idPreguntaActiva AND IdUsuario = @IdUsuario AND r.Valor = @respuestaActiva)
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
	AND [dbo].[ValidarSoloSiConteoRetro](SoloSi, @IdEncuesta, @IdUsuario) = 1

	FETCH NEXT FROM obligatorias_cursor INTO @IdPreguntaObligatoria   
END   

CLOSE obligatorias_cursor   
DEALLOCATE obligatorias_cursor

--select * from @preguntasTotal

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
AND [dbo].[ValidarSoloSiConteoRetro](b.SoloSi, @IdEncuesta, @IdUsuario) = 1


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

