

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroAdmin]')) 
BEGIN
	-- =============================================
	-- Author:		Equipo de desarrollo OIM - John Betancourt
	-- Create date: 1/08/2017
	-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
	-- =============================================

CREATE TABLE [dbo].[RetroAdmin](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[IdEncuesta] [int] NOT NULL,
 CONSTRAINT [PK_RetroAdmin] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
))

ALTER TABLE [dbo].[RetroAdmin]  WITH CHECK ADD  CONSTRAINT [FK_RetroAdmin_Encuesta] FOREIGN KEY([IdEncuesta])
REFERENCES [dbo].[Encuesta] ([Id])

ALTER TABLE [dbo].[RetroAdmin] CHECK CONSTRAINT [FK_RetroAdmin_Encuesta]

END

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroConsultaEncuesta]')) 
	drop table RetroConsultaEncuesta


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroConsultaEncuesta]')) 
BEGIN
	-- =============================================
	-- Author:		Equipo de desarrollo OIM - John Betancourt
	-- Create date: 1/08/2017
	-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
	-- =============================================

CREATE TABLE [dbo].[RetroConsultaEncuesta](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdRetroAdmin] [int] NOT NULL,
	[Presentacion] [varchar](50) NOT NULL,
	[PresTexto] [varchar](max) NOT NULL,
	[Nivel] [varchar](50) NOT NULL,
	[NivTexto] [varchar](max) NOT NULL,
	[Nivel2] [varchar](50) NOT NULL,
	[Niv2Texto] [varchar](max) NOT NULL,
	[NivIdGrafica] [int] NULL,
	[Desarrollo] [varchar](50) NOT NULL,
	[DesTexto] [varchar](max) NOT NULL,
	[Desarrollo2] [varchar](50) NOT NULL,
	[Des2Texto] [varchar](max) NOT NULL,
	[DesIdGrafica] [int] NULL,
	[Analisis] [varchar](50) NOT NULL,
	[AnaTexto] [varchar](max) NOT NULL,
	[Revision] [varchar](50) NOT NULL,
	[RevTexto] [varchar](max) NOT NULL,
	[Historial] [varchar](50) NOT NULL,
	[HisTexto] [varchar](max) NOT NULL,
	[Observa] [varchar](50) NOT NULL,
	[ObsTexto] [varchar](max) NOT NULL,
 CONSTRAINT [PK_RetroConsultaEncuesta] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


ALTER TABLE [dbo].[RetroConsultaEncuesta]  WITH CHECK ADD  CONSTRAINT [FK_RetroConsultaEncuesta_RetroAdmin] FOREIGN KEY([IdRetroAdmin])
REFERENCES [dbo].[RetroAdmin] ([Id])


ALTER TABLE [dbo].[RetroConsultaEncuesta] CHECK CONSTRAINT [FK_RetroConsultaEncuesta_RetroAdmin]
END

GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroArcPreguntasXEncuesta]')) 
BEGIN
	-- =============================================
	-- Author:		Equipo de desarrollo OIM - John Betancourt
	-- Create date: 1/08/2017
	-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
	-- =============================================
	
CREATE TABLE [dbo].RetroArcPreguntasXEncuesta(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdRetroAdmin] [int] NOT NULL,
	[IdEncuesta] [int] NOT NULL,
	[CodigoPregunta] [varchar](8) NOT NULL,
	[Documento] [varchar](100) NOT NULL,
	[Check] bit NOT NULL,
	[Sumariza] bit NOT NULL,
	[Pertenece] int NOT NULL,
	[Observacion] [varchar](500) NULL,
	[Valor] [varchar](500) NOT NULL,
 CONSTRAINT [PK_RetroArcPreguntasXEncuesta] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RetroArcPreguntasXEncuesta]  WITH CHECK ADD  CONSTRAINT [FK_RetroArcPreguntasXEncuesta_RetroAdmin] FOREIGN KEY([IdRetroAdmin])
REFERENCES [dbo].[RetroAdmin] ([Id])


ALTER TABLE [dbo].[RetroArcPreguntasXEncuesta] CHECK CONSTRAINT [FK_RetroArcPreguntasXEncuesta_RetroAdmin]

END
GO

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroArcPreguntasXEncuestaXMunicipio]')) 
BEGIN
	-- =============================================
	-- Author:		Equipo de desarrollo OIM - John Betancourt
	-- Create date: 1/08/2017
	-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
	-- =============================================
	
CREATE TABLE [dbo].RetroArcPreguntasXEncuestaXMunicipio(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdRetroAdmin] [int] NOT NULL,
	[IdMunicipio] [int] NOT NULL,
	[CodigoPregunta] [varchar](8) NOT NULL,
	[Documento] [varchar](100) NOT NULL,
	[Check] bit NOT NULL,
	[Sumariza] bit NOT NULL,
	[Pertenece] int NOT NULL,
	[Observacion] [varchar](500) NULL,
	[Valor] [varchar](500) NOT NULL,
	[UltimoUsuario] [varchar](500) NOT NULL,
 CONSTRAINT [PK_RetroArcPreguntasXEncuestaXMunicipio] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RetroArcPreguntasXEncuestaXMunicipio]  WITH CHECK ADD  CONSTRAINT [FK_RetroArcPreguntasXEncuestaXMunicipio_RetroAdmin] FOREIGN KEY([IdRetroAdmin])
REFERENCES [dbo].[RetroAdmin] ([Id])


ALTER TABLE [dbo].[RetroArcPreguntasXEncuestaXMunicipio] CHECK CONSTRAINT [FK_RetroArcPreguntasXEncuestaXMunicipio_RetroAdmin]

END


GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroDesPreguntasXEncuestas]')) 
BEGIN
	-- =============================================
	-- Author:		Equipo de desarrollo OIM - John Betancourt
	-- Create date: 1/08/2017
	-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
	-- =============================================

CREATE TABLE [dbo].[RetroDesPreguntasXEncuestas](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdRetroAdmin] [int] NOT NULL,
	[IdsEncuestas] [varchar](50) NOT NULL,
	[CodigoPregunta] [varchar](8) NOT NULL,
	[ValorCalculo] [varchar](500) NOT NULL,
 CONSTRAINT [PK_RetroDesPreguntasXEncuestas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[RetroDesPreguntasXEncuestas]  WITH CHECK ADD  CONSTRAINT [FK_RetroDesPreguntasXEncuestas_RetroAdmin] FOREIGN KEY([IdRetroAdmin])
REFERENCES [dbo].[RetroAdmin] ([Id])

ALTER TABLE [dbo].[RetroDesPreguntasXEncuestas] CHECK CONSTRAINT [FK_RetroDesPreguntasXEncuestas_RetroAdmin]
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroGraficaDesarrollo]')) 
BEGIN
	-- =============================================
	-- Author:		Equipo de desarrollo OIM - John Betancourt
	-- Create date: 1/08/2017
	-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
	-- =============================================
	CREATE TABLE [RetroGraficaDesarrollo](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[IdRetroAdmin] [int] NOT NULL,
		[ColorDis] [varchar](50) NOT NULL,
		[ColorImp] [varchar](50) NOT NULL,
		[ColorEval] [varchar](50) NOT NULL,
		--[TituloGraf] [varchar](50) NOT NULL,
		[NombreSerie1] [varchar](50) NOT NULL,
		[NombreSerie2] [varchar](50) NOT NULL,
		[NombreSerie3] [varchar](50) NOT NULL,
		[NombreSerie4] [varchar](50) NOT NULL,
		[NombreSerie5] [varchar](50) NOT NULL,
		[NombreSerie6] [varchar](50) NOT NULL,
		[NombreSerie7] [varchar](50) NOT NULL,
		[NombreSerie8] [varchar](50) NOT NULL,
		[NombreSerie9] [varchar](50) NOT NULL
	 CONSTRAINT [PK_RetroGraficaDesarrollo] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

END
GO

--drop table [RetroGraficaNivel]
--  select * from [RetroGraficaNivel]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroGraficaNivel]')) 
BEGIN
	-- =============================================
	-- Author:		Equipo de desarrollo OIM - John Betancourt
	-- Create date: 1/08/2017
	-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
	-- =============================================
	CREATE TABLE [RetroGraficaNivel](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[IdRetroAdmin] [int] NOT NULL,
		[TipoGrafica] [int] NOT NULL,
		[Color1serie] [varchar](50) NOT NULL,
		[Color2serie] [varchar](50) NOT NULL,
		[Color3serie] [varchar](50) NOT NULL,
		[TituloGraf] [varchar](50) NOT NULL,
		[NombreEje1] [varchar](50) NULL,
		[NombreEje2] [varchar](50) NULL,
		[NombreSerie1] [varchar](50) NOT NULL,
		[NombreSerie2] [varchar](50) NOT NULL,
		[NombreSerie3] [varchar](50) NOT NULL
	 CONSTRAINT [PK_RetroGraficaNivel] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY] 

END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_PreguntaEncuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_PreguntaEncuestaInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================
-- Autor: Equipo de desarrollo OIM - John Betancourt A.																		  
-- Fecha creacion: 2017-06-20																			  
-- Descripcion: Ingresa una pregunta cargada por el archivo excel y devuelve su ID
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int = 0 no hace nada, otro valor = ID de la pregunta insertada
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--====================================================================================================
ALTER PROC [dbo].[I_PreguntaEncuestaInsert] 

	@IdSeccion		INT,
	@Nombre			VARCHAR(512),
	@RowIndex		INT,
	@ColumnIndex	INT,
	@TipoPregunta	VARCHAR(255),
	@Ayuda			VARCHAR(MAX),
	@EsObligatoria	BIT,
	@EsMultiple		BIT,
	@SoloSi			VARCHAR(MAX),
	@Texto			VARCHAR(MAX)

AS 
	BEGIN
		
		SET NOCOUNT ON;

	-- Obtener Id del tipo de encuesta
		DECLARE @IdTipoPregunta INT = @TipoPregunta

		--SELECT @IdTipoPregunta = Id
		--FROM TipoPregunta
		--WHERE Nombre = @TipoPregunta

		SET @IdTipoPregunta = ISNULL(@IdTipoPregunta, 0)

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0
		DECLARE @esValido AS BIT = 1
	
		IF(@esValido = 1 AND @IdTipoPregunta != 0) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY

					INSERT INTO [dbo].[Pregunta] ([IdSeccion], [Nombre], [RowIndex], [ColumnIndex], [IdTipoPregunta], [Ayuda], [EsObligatoria], [EsMultiple], [SoloSi], [Texto])
					SELECT @IdSeccion, @Nombre, @RowIndex, @ColumnIndex, @IdTipoPregunta, @Ayuda, @EsObligatoria, @EsMultiple, @SoloSi, @Texto
					
					SELECT @respuesta = 'Se ha insertado el registro'
					
					-- Recupera el Identity registrado
					SET @estadoRespuesta = SCOPE_IDENTITY()

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

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_EncuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_EncuestaInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--====================================================================================================
-- Autor: Equipo de desarrollo OIM - Christian Ospina																			  
-- Fecha creacion: 2017-03-10																			  
-- Descripcion: inserta un registro en la encuesta e inserta todos los tipos de reporte 																  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- Modifica:  John Betancourt A. OIM				  
-- Descripción: Adicionar campo de Prueba				  
--====================================================================================================
ALTER PROC [dbo].[I_EncuestaInsert] 

	@Titulo						VARCHAR(255),
	@Ayuda						VARCHAR(MAX) = NULL,
	@FechaInicio				DATETIME,
	@FechaFin					DATETIME,
	@IsDeleted					BIT = 0,
	@TipoEncuesta				VARCHAR(255),
	@EncuestaRelacionada		INT = NULL,
	@AutoevaluacionHabilitada	BIT,
	@TipoReporte				VARCHAR(128),
	@IsPrueba					INT = 0

AS 

	-- Parámetros para el manejo de la respuesta
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	-- Obtener Id del tipo de encuesta
	DECLARE @IdTipoEncuesta INT

	SELECT @IdTipoEncuesta = Id
	FROM TipoEncuesta
	WHERE Nombre = @TipoEncuesta

	SET @IdTipoEncuesta = ISNULL(@IdTipoEncuesta, 0)

	IF (EXISTS(SELECT * FROM encuesta WHERE titulo  = @Titulo) OR @IdTipoEncuesta = 0)
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'El Título ya se encuentra asignado a otra Encuesta o el tipo de encuesta no existe.'
	END

	-- Parámetros para el manejo de los Tipos de Reporte
	DECLARE @i INT
	DECLARE @idTipoReporte INT
	DECLARE @numrows INT
	DECLARE @IdEncuesta INT

	-- Inserta en la tabla temporal los diferentes Ids de Tipos de Reporte
	DECLARE @Temp TABLE (Id INT,splitdata VARCHAR(128))
	INSERT @Temp SELECT ROW_NUMBER() OVER(ORDER BY splitdata) Id, splitdata FROM dbo.Split(@TipoReporte, ','); 

	SET @i = 1
	SET @numrows = (SELECT COUNT(*) FROM @Temp)	

	IF(@esValido = 1) BEGIN
		BEGIN TRANSACTION
		BEGIN TRY

			-- Inserta la encuesta
			INSERT INTO [dbo].[Encuesta] 
				([Titulo], [Ayuda], [FechaInicio], [FechaFin], [IsDeleted], [IdTipoEncuesta], [EncuestaRelacionada], [AutoevaluacionHabilitada], [IsPrueba])
			SELECT 
				@Titulo, @Ayuda, @FechaInicio, @FechaFin, @IsDeleted, @IdTipoEncuesta, @EncuestaRelacionada, @AutoevaluacionHabilitada, @IsPrueba

			-- Recupera el Identity registrado
			SET @IdEncuesta = SCOPE_IDENTITY()

			-- Inserta los tipos de reporte
			IF @numrows > 0
				WHILE (@i <= (SELECT MAX(Id) FROM @Temp))
				BEGIN

					INSERT INTO [Roles].[RolEncuesta] ([IdEncuesta], [IdRol])
					SELECT @IdEncuesta, (SELECT splitdata FROM @Temp WHERE Id = @i)

					SET @i = @i + 1
				END

		SELECT @respuesta = 'Se ha insertado el registro'
		SELECT @estadoRespuesta = 1
	
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

IF NOT EXISTS (SELECT * FROM TipoEncuesta WHERE Nombre = 'TIPO_ANTIGUO') 
	insert into TipoEncuesta (Nombre,Descripcion) values ('TIPO_ANTIGUO','TIPO_ANTIGUO')

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 15/08/2017
-- Description:	obtiene la informacion de las preguntas consultadas sobre las encuestas
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo] 

	@IdPregunta					VARCHAR(8),
	@idsEncuesta				varchar(max)
AS

select Palabra, IdEncuesta, CodigoPregunta, NombrePregunta, Nombre, 'Valor' Valor
	FROM(
	select distinct S.IdEncuesta, P.CodigoPregunta, p.NombrePregunta, TP.Nombre--, R.Valor
	from [BancoPreguntas].[Preguntas] P
	INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
	INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
	INNER JOIN Seccion S on PO.IdSeccion = S.Id
	INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
	LEFT JOIN Respuesta R ON R.IdPregunta = PO.Id
	inner join fnSplit(@idsEncuesta,',') on Palabra =  S.IdEncuesta
	where CodigoPregunta = @IdPregunta ) temp
right join fnSplit(@idsEncuesta,',') on Palabra = temp.IdEncuesta	

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroUsuarioDesarrollo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroUsuarioDesarrollo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Territorial
-- =============================================
ALTER  PROC [dbo].[C_ConsultaRetroUsuarioDesarrollo] 
	@IdDepartamento INT
AS
	select Id, UserName 
	from Usuario 
	where IdTipoUsuario = (select Id from TipoUsuario where Tipo = 'ALCALDIA') AND Activo =1 AND IdEstado = 5 AND IdDepartamento = @IdDepartamento


GO

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_EncuestaRetroGrafDesarrolloUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_EncuestaRetroGrafDesarrolloUpdate] AS'

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
ALTER PROC [dbo].[U_EncuestaRetroGrafDesarrolloUpdate]   
	
	@IdRetroAdmin int,
	@ColorDis varchar(50),
    @ColorImp varchar(50),
	@ColorEval varchar(50),
    @NombreSerie1 varchar(50),
	@NombreSerie2 varchar(50),
	@NombreSerie3 varchar(50),
	@NombreSerie4 varchar(50),
	@NombreSerie5 varchar(50),
	@NombreSerie6 varchar(50),
	@NombreSerie7 varchar(50),
	@NombreSerie8 varchar(50),
	@NombreSerie9 varchar(50)

AS   
  
 -- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0  
 BEGIN  
  BEGIN TRANSACTION  
  BEGIN TRY  

 
 IF EXISTS (select 1 from RetroGraficaDesarrollo where IdRetroAdmin = @IdRetroAdmin)  
	BEGIN
		UPDATE   
		[dbo].[RetroGraficaDesarrollo]  
		SET      
			ColorDis = @ColorDis,
			ColorImp = @ColorImp,
			ColorEval = @ColorEval,
			NombreSerie1 = @NombreSerie1,
			NombreSerie2 = @NombreSerie2,
			NombreSerie3 = @NombreSerie3,
			NombreSerie4 = @NombreSerie4,
			NombreSerie5 = @NombreSerie5,
			NombreSerie6 = @NombreSerie6,
			NombreSerie7 = @NombreSerie7,
			NombreSerie8 = @NombreSerie8,
			NombreSerie9 = @NombreSerie9
		WHERE    
		IdRetroAdmin = @IdRetroAdmin

		SELECT @respuesta = 'Se ha actualizado el registro'  
		SELECT @estadoRespuesta = 2 
	END 
ELSE 
	BEGIN
		INSERT INTO [dbo].[RetroGraficaDesarrollo]
           (IdRetroAdmin, ColorDis, ColorImp, ColorEval, NombreSerie1, NombreSerie2, NombreSerie3,
			NombreSerie4, NombreSerie5, NombreSerie6, NombreSerie7, NombreSerie8, NombreSerie9)
		   VALUES
		   (@IdRetroAdmin, @ColorDis, @ColorImp, @ColorEval, @NombreSerie1, @NombreSerie2, @NombreSerie3,
			@NombreSerie4, @NombreSerie5, @NombreSerie6, @NombreSerie7, @NombreSerie8, @NombreSerie9)

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesTerritorial]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesTerritorial] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Territorial
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesTerritorial] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

---Datos Grafica DINAMICA

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE R.Valor
			  WHEN RDP.ValorCalculo THEN 1
			  ELSE 0
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.Id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%Territorial%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre
			

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesAdecuacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesAdecuacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Adecuación Institucional
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesAdecuacion] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE R.Valor
			  WHEN RDP.ValorCalculo THEN 1
			  ELSE 0
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.Id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%Adecua%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesArticulacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesArticulacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo 05 Articulación Institucional
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesArticulacion] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (

SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE R.Valor
			  WHEN RDP.ValorCalculo THEN 1
			  ELSE 0
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta	
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%Articula%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

--C_DatosGraficaDesArticulacion 3, 'alcaldia_la estrella_antioquia'

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesComite]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesComite] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Comité de Justicia Transicional
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesComite] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE R.Valor
			  WHEN RDP.ValorCalculo THEN 1
			  ELSE 0
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta		
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%justicia%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

--C_DatosGraficaDesComite 3, 
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesDinamica]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesDinamica] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Dinámica del Conflicto Armado
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesDinamica] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE R.Valor
			  WHEN RDP.ValorCalculo THEN 1
			  ELSE 0
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta		
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%conflicto%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

--C_DatosGraficaDesDinamica 3

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesParticipacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesParticipacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Participación de las Víctimas
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesParticipacion] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE R.Valor
			  WHEN RDP.ValorCalculo THEN 1
			  ELSE 0
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta			
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%ctimas%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

--C_DatosGraficaDesParticipacion 3
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesRetorno]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesRetorno] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Retorno y Reubicación
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesRetorno] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE R.Valor
			  WHEN RDP.ValorCalculo THEN 1
			  ELSE 0
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta			
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%Retorno%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre

--C_DatosGraficaDesRetorno 2, 'alcaldia_toribio_cauca'

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DatosGraficaDesTerritorial]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DatosGraficaDesTerritorial] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 26/08/2017
-- Description:	obtiene los datos de la Grafica Desarrollo Territorial
-- =============================================
ALTER PROC [dbo].[C_DatosGraficaDesTerritorial] 
	@IdRetroConsultaEncuesta	INT,
	@IdUserName					VARCHAR(50)
AS

---Datos Grafica DINAMICA

DECLARE @IdsEncuestas varchar(50),
		@Year int = year(getdate()),
		@IdUser INT

SELECT @IdsEncuestas = IdsEncuestas from [RetroDesPreguntasXEncuestas] where IdRetroAdmin = @IdRetroConsultaEncuesta
select @IdUser = id FROM Usuario WHERE UserName = @IdUserName

SELECT IdEncuesta, Anio, nombre Etapa, ISNULL(Datos.porcentaje,0) porcentaje
FROM RetroEtapaPreguntas REP
LEFT JOIN (
SELECT 
	CASE tmp.IdEncuesta
		WHEN (select MIN(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year-2)
		WHEN (select MAX(Palabra) from fnSplit(@IdsEncuestas,',')) THEN (@Year)
		ELSE (@Year-1)
			END as Anio,
	tmp.IdEncuesta, 
	CASE 
		WHEN tmp.Etapa like'%DIS%' THEN 'DISENO'
		WHEN tmp.Etapa like'%imp%' THEN 'IMPLEMENTACION'
		WHEN tmp.Etapa like'%eval%' THEN 'EVALUACION'
			END as Etapa, 
	--SUM(tmp.Valor) sumatoria , 
	((SUM(tmp.Valor)*100)/COUNT(tmp.IdEncuesta)) porcentaje
	FROM (
SELECT      Seccion_2.Titulo AS Etapa, 
			Seccion_1.Titulo AS Seccion,
			CASE R.Valor
			  WHEN RDP.ValorCalculo THEN 1
			  ELSE 0
			END as Valor, S.IdEncuesta--,R.Valor--
			from [RetroDesPreguntasXEncuestas] RDP
			INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = p.CodigoPregunta
			INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Respuesta R ON R.IdPregunta = PO.Id AND IdUsuario = @IdUser	
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%Territorial%'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre
			

--C_DatosGraficaDesTerritorial 2 , 'alcaldia_la estrella_antioquia'
GO

IF NOT EXISTS (SELECT * FROM [Recurso] WHERE Nombre = 'Retroalimentación')
BEGIN
	SET IDENTITY_INSERT [dbo].[Recurso] ON 
	INSERT INTO [dbo].[Recurso] ([Id],[Nombre],[Url]) VALUES (15 ,'Retroalimentación',null)
	SET IDENTITY_INSERT [dbo].[Recurso] OFF
END
GO
IF NOT EXISTS (SELECT * FROM [SubRecurso] WHERE Nombre = 'RUSICST')
BEGIN
	SET IDENTITY_INSERT [dbo].[SubRecurso] ON 
	INSERT INTO [dbo].[SubRecurso] ([Id],[Nombre],[Url],[IdRecurso]) VALUES (97, 'RUSICST', null, 15)
	SET IDENTITY_INSERT [dbo].[SubRecurso] OFF 
END
GO
IF NOT EXISTS (SELECT * FROM [TipoUsuarioRecurso] WHERE [IdTipoUsuario] = (select Id from TipoUsuario where Tipo = 'ADMIN') AND [IdRecurso] = 15 AND [IdSubRecurso] = 97)
	INSERT INTO [dbo].[TipoUsuarioRecurso] ([IdTipoUsuario] ,[IdRecurso] ,[IdSubRecurso]) VALUES ((select Id from TipoUsuario where Tipo = 'ADMIN') ,15 ,97)
GO
IF NOT EXISTS (SELECT * FROM [TipoUsuarioRecurso] WHERE [IdTipoUsuario] = (select Id from TipoUsuario where Tipo = 'ALCALDIA') AND [IdRecurso] = 15 AND [IdSubRecurso] = 97)
	INSERT INTO [dbo].[TipoUsuarioRecurso] ([IdTipoUsuario] ,[IdRecurso] ,[IdSubRecurso]) VALUES ((select Id from TipoUsuario where Tipo = 'ALCALDIA') ,15 ,97)
GO
IF NOT EXISTS (SELECT * FROM [TipoUsuarioRecurso] WHERE [IdTipoUsuario] = (select Id from TipoUsuario where Tipo = 'ANALISTA') AND [IdRecurso] = 15 AND [IdSubRecurso] = 97)
	INSERT INTO [dbo].[TipoUsuarioRecurso] ([IdTipoUsuario] ,[IdRecurso] ,[IdSubRecurso]) VALUES ((select Id from TipoUsuario where Tipo = 'ANALISTA') ,15 ,97)
GO
IF NOT EXISTS (SELECT * FROM [TipoUsuarioRecurso] WHERE [IdTipoUsuario] = (select Id from TipoUsuario where Tipo = 'GOBERNACION') AND [IdRecurso] = 15 AND [IdSubRecurso] = 97)
	INSERT INTO [dbo].[TipoUsuarioRecurso] ([IdTipoUsuario] ,[IdRecurso] ,[IdSubRecurso]) VALUES ((select Id from TipoUsuario where Tipo = 'GOBERNACION') ,15 ,97)
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroDesPreguntasXIdRetro]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroDesPreguntasXIdRetro] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 15/08/2017
-- Description:	obtiene la informacion Retroalimentacion de la grafica Nivel x encuesta
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroDesPreguntasXIdRetro] 

	@IdRetroAdmin 				INT

AS

SELECT 
      [IdRetroAdmin] Palabra
      ,[IdsEncuestas] IdEncuesta
      ,RDP.[CodigoPregunta]
	  ,[NombrePregunta]
	  ,TP.Nombre
      ,[ValorCalculo] Valor
  FROM [dbo].[RetroDesPreguntasXEncuestas] RDP
  INNER JOIN [BancoPreguntas].[Preguntas] P on RDP.CodigoPregunta = P.CodigoPregunta
  INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
  WHERE [IdRetroAdmin] = @IdRetroAdmin


--C_ConsultaRetroDesPreguntasXIdRetro 3
--C_ConsultaRetroDesPreguntasXIdRetro 2

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 1/08/2017
-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroEncuesta] 

	@IdRetroAdmin					INT

AS

IF NOT EXISTS(SELECT 1 FROM [dbo].[RetroConsultaEncuesta] Where [IdRetroAdmin] = @IdRetroAdmin)
	BEGIN
		EXEC I_DatosPrincipalesRetroEncuesta @IdRetroAdmin
	END

BEGIN
	SELECT [Id]
		  ,[IdRetroAdmin]
		  ,[Presentacion]
		  ,[PresTexto]
		  ,[Nivel]
		  ,[NivTexto]
		  ,[Nivel2]
		  ,[Niv2Texto]
		  ,[NivIdGrafica]
		  ,[Desarrollo]
		  ,[DesTexto]
		  ,[Desarrollo2]
		  ,[Des2Texto]
		  ,[DesIdGrafica]
		  ,[Analisis]
		  ,[AnaTexto]
		  ,[Revision]
		  ,[RevTexto]
		  ,[Historial]
		  ,[HisTexto]
		  ,[Observa]
		  ,[ObsTexto]
	  FROM [dbo].[RetroConsultaEncuesta]
	  Where [IdRetroAdmin] = @IdRetroAdmin
END


-- exec [C_ConsultaRetroEncuesta] 3

GO

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


--exec C_ConsultaRetroEncuestaNivel 2, 'alcaldia_abejorral_antioquia'

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoArchivo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoArchivo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 15/08/2017
-- Description:	obtiene la informacion de las preguntas consultadas sobre las encuestas
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoArchivo] 

	@IdPregunta					VARCHAR(8),
	@IdEncuesta					INT,
	@IdDepartamento				INT,
	@IdAlcaldia					INT
AS
Declare @IdUser int

select @IdUser = Id from Usuario where IdDepartamento = @IdDepartamento AND IdMunicipio = @IdAlcaldia

	select S.IdEncuesta, P.CodigoPregunta, p.NombrePregunta, TP.Nombre, R.Valor--, R.*	
	from [BancoPreguntas].[Preguntas] P
	INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
	INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
	INNER JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @IdEncuesta
	INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
	INNER JOIN Respuesta R ON R.IdPregunta = PO.Id AND R.IdUsuario = @IdUser
	WHERE P.IdTipoPregunta = 1
	AND CodigoPregunta = @IdPregunta 

GO

--exec [C_ConsultaRetroEncuestaPreguntaXCodigoArchivo] 10007732, 58 , 5,5002

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoArchivoAdmin]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoArchivoAdmin] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 15/08/2017
-- Description:	obtiene la informacion de las preguntas consultadas sobre las encuestas
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoArchivoAdmin] 

	@IdPregunta					VARCHAR(8),
	@IdEncuesta					INT
AS


	select top 1 S.IdEncuesta, P.CodigoPregunta, p.NombrePregunta, TP.Nombre, R.Valor--, R.*	
	from [BancoPreguntas].[Preguntas] P
	INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
	INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
	INNER JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @IdEncuesta
	INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
	INNER JOIN Respuesta R ON R.IdPregunta = PO.Id
	WHERE P.IdTipoPregunta = 1
	AND CodigoPregunta = @IdPregunta 

GO

--exec [C_ConsultaRetroEncuestaPreguntaXCodigoArchivoAdmin] 10007732, 58

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 15/08/2017
-- Description:	obtiene la informacion de las preguntas consultadas sobre las encuestas
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo] 

	@IdPregunta					VARCHAR(8),
	@idsEncuesta				varchar(max)
AS

select Palabra, IdEncuesta, CodigoPregunta, NombrePregunta, Nombre, 'Valor' Valor
	FROM(
	select distinct S.IdEncuesta, P.CodigoPregunta, p.NombrePregunta, TP.Nombre--, R.Valor
	from [BancoPreguntas].[Preguntas] P
	INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
	INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
	INNER JOIN Seccion S on PO.IdSeccion = S.Id
	INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
	LEFT JOIN Respuesta R ON R.IdPregunta = PO.Id
	inner join fnSplit(@idsEncuesta,',') on Palabra =  S.IdEncuesta
	where CodigoPregunta = @IdPregunta ) temp
right join fnSplit(@idsEncuesta,',') on Palabra = temp.IdEncuesta	

GO

--exec [C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo] 10008233, '28,43,58'

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroRevPreguntasXIdRetro]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroRevPreguntasXIdRetro] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 07/09/2017
-- Description:	obtiene la informacion de las pregntas de revision en realimentacion
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroRevPreguntasXIdRetro] 

	@IdRetroAdmin 				INT

AS

SELECT 
		RAP.Id
      ,RAP.IdEncuesta 
      ,RAP.[CodigoPregunta]
	  ,RAP.Documento Nombre
      ,RAP.Valor
	  ,RAP.[Check] Envio
	  ,RAP.Sumariza Sumatoria
	  ,RAP.Pertenece Corresponde
	  ,RAP.Observacion Observaciones
  FROM [dbo].[RetroArcPreguntasXEncuesta] RAP
  INNER JOIN [BancoPreguntas].[Preguntas] P on RAP.CodigoPregunta = P.CodigoPregunta
  INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
  WHERE [IdRetroAdmin] = @IdRetroAdmin


--C_ConsultaRetroRevPreguntasXIdRetro 2
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroRevPreguntasXIdRetroMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroRevPreguntasXIdRetroMunicipio] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 07/09/2017
-- Description:	obtiene la informacion de las pregntas de revision en realimentacion
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroRevPreguntasXIdRetroMunicipio] 

	@IdRetroAdmin 				INT,
	@IdMunicipio				INT,
	@IdEncuesta					INT

AS

DECLARE @IdUser varchar(100)
select @IdUser = Id from Usuario where IdMunicipio = @IdMunicipio

SELECT 
		RAP.Id
      ,RAP.[CodigoPregunta]
	  ,RAP.Documento Nombre
      ,r.Valor
	  , CAST(CASE r.Valor
		WHEN ISNULL(r.Valor,0) THEN 1
		ELSE 0 END as bit) Envio
	  ,RAP.Sumariza Sumatoria
	  ,RAP.Pertenece Corresponde
	  ,RAP.Observacion Observaciones
  FROM [dbo].[RetroArcPreguntasXEncuestaXMunicipio] RAP
  INNER JOIN [BancoPreguntas].[Preguntas] P on RAP.CodigoPregunta = P.CodigoPregunta
  INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
  INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
  INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
  INNER JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @IdEncuesta
  LEFT JOIN Respuesta r ON PO.Id = r.IdPregunta AND r.IdUsuario = @IdUser
  WHERE [IdRetroAdmin] = @IdRetroAdmin AND IdMunicipio = @IdMunicipio 


--C_ConsultaRetroRevPreguntasXIdRetroMunicipio 2, 5002
--C_ConsultaRetroRevPreguntasXIdRetroMunicipio 2, 91001, 58
--C_ConsultaRetroRevPreguntasXIdRetroMunicipio 2, 5002, 58

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroRevPreguntasXIdRetroxUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroRevPreguntasXIdRetroxUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 07/09/2017
-- Description:	obtiene la informacion de las pregntas de revision en realimentacion
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroRevPreguntasXIdRetroxUsuario] 

	@IdRetroAdmin 				INT,
	@UserName					VARCHAR(50),
	@IdEncuesta					INT

AS

DECLARE @IdUser varchar(100)
DECLARE @IdMunicipio INT
select @IdUser = Id, @IdMunicipio = IdMunicipio from Usuario where UserName = @UserName

SELECT 
		RAP.Id
      ,RAP.[CodigoPregunta]
	  ,RAP.Documento Nombre
      ,r.Valor
	  ,CAST(CASE r.Valor
		WHEN ISNULL(r.Valor,0) THEN 1
		ELSE 0 END as bit) Envio
	  ,RAP.Sumariza Sumatoria
	  ,RAP.Pertenece Corresponde
	  ,RAP.Observacion Observaciones
  FROM [dbo].[RetroArcPreguntasXEncuestaXMunicipio] RAP
  INNER JOIN [BancoPreguntas].[Preguntas] P on RAP.CodigoPregunta = P.CodigoPregunta
  INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
  INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
  INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
  INNER JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @IdEncuesta
  LEFT JOIN Respuesta r ON PO.Id = r.IdPregunta AND r.IdUsuario = @IdUser
  WHERE [IdRetroAdmin] = @IdRetroAdmin AND IdMunicipio = @IdMunicipio 


--C_ConsultaRetroRevPreguntasXIdRetroxUsuario 2, 'alcaldia_ulloa_valle_del_cauca', 58
--C_ConsultaRetroRevPreguntasXIdRetroxUsuario 2, 'alcaldia_chaparral_tolima', 58
--C_ConsultaRetroRevPreguntasXIdRetroxUsuario 2, 'alcaldia_abejorral_antioquia', 58

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroalimentacion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroalimentacion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 19/08/2017
-- Description:	obtiene la informacion Retroalimentaciones existentes
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroalimentacion] 
AS

	SELECT ra.[Id]
		  ,ra.IdEncuesta
		  ,[Nombre]
		  ,E.Titulo
	  FROM [dbo].[RetroAdmin] ra
	  INNER JOIN Encuesta E on ra.IdEncuesta = E.Id
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_RetroalimentacionInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_RetroalimentacionInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 19/08/2017
-- Description:	ingresa una nueva realimentacion
-- =============================================
ALTER PROC [dbo].[I_RetroalimentacionInsert] 
	@NombreRealimentacion					varchar(50),
	@IdEncuesta			INT
AS

-- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0  

 BEGIN  
  BEGIN TRANSACTION  
  BEGIN TRY  

	IF NOT EXISTS (select 1 from [RetroAdmin] where IdEncuesta = @IdEncuesta )
		BEGIN
			INSERT INTO [dbo].[RetroAdmin]
					   ([Nombre], IdEncuesta)
				 VALUES
					   (@NombreRealimentacion, @IdEncuesta)
			SELECT @respuesta = 'Se ha Ingresado el registro'  
			SELECT @estadoRespuesta = 1
		END
	ELSE
		BEGIN
			SELECT @respuesta = 'Esta Encuesta ya tiene una Realimentación'  
			SELECT @estadoRespuesta = 0
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

 SELECT @respuesta AS respuesta, @estadoRespuesta AS estado     

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroDesPreguntas]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroDesPreguntas] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 25/08/2017
-- Description:	obtiene la informacion Retroalimentaciones existentes
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroDesPreguntas] 
	@IdRetroAdmin	INT
AS

	SELECT P.CodigoPregunta, p.NombrePregunta, TP.Nombre, isnull(Valor,'Vacio') Valor
	  FROM [dbo].[RetroDesPreguntasXEncuestas] rdp
	  INNER JOIN [BancoPreguntas].[Preguntas] P on rdp.CodigoPregunta = p.CodigoPregunta
	  INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
	  INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
	  LEFT JOIN Respuesta R ON R.Id = PA.IdPregunta
	  WHERE IdRetroAdmin = @IdRetroAdmin
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_RetroDesPreguntasInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_RetroDesPreguntasInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 25/08/2017
-- Description:	ingresa una nueva realimentacion
-- =============================================
ALTER PROC [dbo].[I_RetroDesPreguntasInsert] 
	@IdRetroAdmin				INT,
    @IdsEncuestas				VARCHAR(50),
    @CodigoPregunta				VARCHAR(8),
    @ValorCalculo				VARCHAR(500)	
AS

-- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0  

 BEGIN  
  BEGIN TRANSACTION  
  BEGIN TRY  	
	BEGIN
		INSERT INTO [dbo].[RetroDesPreguntasXEncuestas]
           ([IdRetroAdmin]
           ,[IdsEncuestas]
           ,[CodigoPregunta]
           ,[ValorCalculo])
     VALUES
           (@IdRetroAdmin
           ,@IdsEncuestas
           ,@CodigoPregunta
           ,@ValorCalculo)
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_RetroDesPreguntasDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_RetroDesPreguntasDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt A.
-- Create date: 25/08/2017
-- Description:	elimina una realimentacion
-- =============================================
ALTER PROC [dbo].[D_RetroDesPreguntasDelete] 
	@IdRetroAdmin	INT
AS

 -- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0  
 BEGIN  
  BEGIN TRANSACTION  
  BEGIN TRY 

	DELETE FROM [dbo].[RetroDesPreguntasXEncuestas]
		  WHERE IdRetroAdmin = @IdRetroAdmin
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

 SELECT @respuesta AS respuesta, @estadoRespuesta AS estado     

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_RetroArcPreguntasDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_RetroArcPreguntasDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Equipo de desarrollo OIM - John Betancourt A.  
-- Create date: 25/08/2017  
-- Description: elimina una realimentacion  
-- =============================================  
ALTER PROC [dbo].[D_RetroArcPreguntasDelete]   
	@IdRetroArc		INT
AS  
  
 -- Parámetros para el manejo de la respuesta    
 DECLARE @respuesta AS NVARCHAR(2000) = ''    
 DECLARE @estadoRespuesta  AS INT = 0    
 BEGIN    
  BEGIN TRANSACTION    
  BEGIN TRY   
  
 DELETE FROM [dbo].[RetroArcPreguntasXEncuesta]  
    WHERE Id = @IdRetroArc 
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
  
 SELECT @respuesta AS respuesta, @estadoRespuesta AS estado       
  
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_RetroDesPreguntasDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_RetroDesPreguntasDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Equipo de desarrollo OIM - John Betancourt A.  
-- Create date: 25/08/2017  
-- Description: elimina una realimentacion  
-- =============================================  
ALTER PROC [dbo].[D_RetroDesPreguntasDelete]   
 @IdRetroAdmin INT  
AS  
  
 -- Parámetros para el manejo de la respuesta    
 DECLARE @respuesta AS NVARCHAR(2000) = ''    
 DECLARE @estadoRespuesta  AS INT = 0    
 BEGIN    
  BEGIN TRANSACTION    
  BEGIN TRY   
  
 DELETE FROM [dbo].[RetroDesPreguntasXEncuestas]  
    WHERE IdRetroAdmin = @IdRetroAdmin  
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
  
 SELECT @respuesta AS respuesta, @estadoRespuesta AS estado       
  
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_DatosPrincipalesRetroEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_DatosPrincipalesRetroEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 22/08/2017
-- Description:	obtiene la informacion Retroalimentacion de la Encuesta
-- =============================================
ALTER PROC [dbo].[I_DatosPrincipalesRetroEncuesta] 

	--@IdMunicipio INT,
	--@IdDepartamento INT,
	@IdRetroAdminEncuesta INT

AS

INSERT [dbo].[RetroConsultaEncuesta] 
			([IdRetroAdmin], --[IdMunicipio], [IdDepartamento], 
			[Presentacion], [PresTexto], 
			[Nivel], [NivTexto], [Nivel2], [Niv2Texto], [NivIdGrafica], 
			[Desarrollo], [DesTexto], [Desarrollo2], [Des2Texto], [DesIdGrafica], 
			[Analisis], [AnaTexto], 
			[Revision], [RevTexto], 
			[Historial], [HisTexto], 
			[Observa], [ObsTexto]) 
			VALUES (@IdRetroAdminEncuesta,-- @IdMunicipio, @IdDepartamento, 
			N'Presentación', '',
			N'1. Nivel de Diligenciamiento', '', N'1.1. Porcentaje de diligenciamiento', '',NULL, 
			N'2. Desarrollo de la politica pública de Atención', '', N'2.1 Nivel de avance por fases', '', NULL, 
			N'3. Analisis del Plan de Mejoramiento Municipal', '',
			N'4. Revision de Archivos adjuntos', '',
			N'5. Historial de Envio Rusicts', '',
			N'6. Observaciones Generales', '')

GO

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_RetroArcPreguntasInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_RetroArcPreguntasInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Equipo de desarrollo OIM - John Betancourt  
-- Create date: 05/09/2017  
-- Description: ingresa una nueva pregunta tipo archivo   
-- =============================================  
ALTER PROC [dbo].[I_RetroArcPreguntasInsert]   
	@IdRetroAdmin		 INT,  
    @IdEncuesta			INT, 
    @CodigoPregunta		VARCHAR(8),  
    @Documento			VARCHAR(50),  
    @Check				bit,
	@Sumar				bit,
    @Pertenece			INT,
    @Observacion		VARCHAR(500) = NULL,
    @Valor				VARCHAR(500)
	  
AS  
  
-- Parámetros para el manejo de la respuesta    
 DECLARE @respuesta AS NVARCHAR(2000) = ''    
 DECLARE @estadoRespuesta  AS INT = 0    
  
 BEGIN    
  BEGIN TRANSACTION    
  BEGIN TRY     
 BEGIN  
  INSERT INTO [dbo].[RetroArcPreguntasXEncuesta]
           ([IdRetroAdmin]
           ,[IdEncuesta]
           ,[CodigoPregunta]
           ,[Documento]
           ,[Check]
		   ,[Sumariza]
           ,[Pertenece]
           ,[Observacion]
           ,[Valor])
     VALUES 
           (@IdRetroAdmin,
           @IdEncuesta,
           @CodigoPregunta,
           @Documento,
           @Check,
		   @Sumar,
           @Pertenece,
           @Observacion,
           @Valor)  
      SELECT @respuesta = 'Se ha Ingresado el registro'    
	  SELECT @estadoRespuesta = 1  

	  INSERT INTO RetroArcPreguntasXEncuestaXmunicipio
	  SELECT @IdRetroAdmin, M.Id, @CodigoPregunta, @Documento, @Check, @Sumar, @Pertenece, @Observacion, @Valor, 'Admin'
	  From Municipio M

	 -- from [BancoPreguntas].[Preguntas] P
		--INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
		--INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
		--INNER JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @IdEncuesta
		--INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
		--RIGHT JOIN Respuesta R ON R.IdPregunta = PO.Id --AND R.IdUsuario = @IdUser
		--INNER JOIN Usuario U ON R.IdUsuario = U.Id
		--INNER JOIN Municipio M on M.Id = U.IdMunicipio
		
	 -- from Municipio M
		--INNER JOIN Usuario U ON M.Id = U.IdMunicipio
		--LEFT JOIN Respuesta R ON R.IdUsuario = U.Id
		--LEFT JOIN Pregunta PO ON R.IdPregunta = PO.Id
		--LEFT JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on  PA.IdPreguntaAnterior = PO.Id
		--LEFT JOIN [BancoPreguntas].[Preguntas] P on P.IdPregunta = PA.IdPregunta
		--LEFT JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @IdEncuesta
		--LEFT JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id		  
		--WHERE P.IdTipoPregunta = 1 AND UserName like 'alcaldi%'
		--AND CodigoPregunta = @CodigoPregunta 

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

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_RetroDesPreguntasInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_RetroDesPreguntasInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Equipo de desarrollo OIM - John Betancourt  
-- Create date: 25/08/2017  
-- Description: ingresa una nueva realimentacion  
-- =============================================  
ALTER PROC [dbo].[I_RetroDesPreguntasInsert]   
 @IdRetroAdmin    INT,  
    @IdsEncuestas    VARCHAR(50),  
    @CodigoPregunta    VARCHAR(8),  
    @ValorCalculo    VARCHAR(500)   
AS  
  
-- Parámetros para el manejo de la respuesta    
 DECLARE @respuesta AS NVARCHAR(2000) = ''    
 DECLARE @estadoRespuesta  AS INT = 0    
  
 BEGIN    
  BEGIN TRANSACTION    
  BEGIN TRY     
 BEGIN  
  INSERT INTO [dbo].[RetroDesPreguntasXEncuestas]  
           ([IdRetroAdmin]  
           ,[IdsEncuestas]  
           ,[CodigoPregunta]  
           ,[ValorCalculo])  
     VALUES  
           (@IdRetroAdmin  
           ,@IdsEncuestas  
           ,@CodigoPregunta  
           ,@ValorCalculo)  
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

  IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_EncuestaRetroGrafDesarrolloUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_EncuestaRetroGrafDesarrolloUpdate] AS'

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
ALTER PROC [dbo].[U_EncuestaRetroGrafDesarrolloUpdate]   
	
	@IdRetroAdmin int,
	@ColorDis varchar(50),
    @ColorImp varchar(50),
	@ColorEval varchar(50),
    @NombreSerie1 varchar(50),
	@NombreSerie2 varchar(50),
	@NombreSerie3 varchar(50),
	@NombreSerie4 varchar(50),
	@NombreSerie5 varchar(50),
	@NombreSerie6 varchar(50),
	@NombreSerie7 varchar(50),
	@NombreSerie8 varchar(50),
	@NombreSerie9 varchar(50)

AS   
  
 -- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0  
 BEGIN  
  BEGIN TRANSACTION  
  BEGIN TRY  

 
 IF EXISTS (select 1 from RetroGraficaDesarrollo where IdRetroAdmin = @IdRetroAdmin)  
	BEGIN
		UPDATE   
		[dbo].[RetroGraficaDesarrollo]  
		SET      
			ColorDis = @ColorDis,
			ColorImp = @ColorImp,
			ColorEval = @ColorEval,
			NombreSerie1 = @NombreSerie1,
			NombreSerie2 = @NombreSerie2,
			NombreSerie3 = @NombreSerie3,
			NombreSerie4 = @NombreSerie4,
			NombreSerie5 = @NombreSerie5,
			NombreSerie6 = @NombreSerie6,
			NombreSerie7 = @NombreSerie7,
			NombreSerie8 = @NombreSerie8,
			NombreSerie9 = @NombreSerie9
		WHERE    
		IdRetroAdmin = @IdRetroAdmin

		SELECT @respuesta = 'Se ha actualizado el registro'  
		SELECT @estadoRespuesta = 2 
	END 
ELSE 
	BEGIN
		INSERT INTO [dbo].[RetroGraficaDesarrollo]
           (IdRetroAdmin, ColorDis, ColorImp, ColorEval, NombreSerie1, NombreSerie2, NombreSerie3,
			NombreSerie4, NombreSerie5, NombreSerie6, NombreSerie7, NombreSerie8, NombreSerie9)
		   VALUES
		   (@IdRetroAdmin, @ColorDis, @ColorImp, @ColorEval, @NombreSerie1, @NombreSerie2, @NombreSerie3,
			@NombreSerie4, @NombreSerie5, @NombreSerie6, @NombreSerie7, @NombreSerie8, @NombreSerie9)

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
    @Color2serie varchar(50),
	@Color3serie varchar(50),
    @TituloGraf varchar(50),
    @NombreSerie1 varchar(50),
	@NombreSerie2 varchar(50),
	@NombreSerie3 varchar(50)

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
			Color2serie = @Color2serie,
			Color3serie = @Color3serie,
			TituloGraf = @TituloGraf,
			NombreSerie1 = @NombreSerie1,
			NombreSerie2 = @NombreSerie2,
			NombreSerie3 = @NombreSerie3
		WHERE    
		IdRetroAdmin = @IdRetroAdmin

		SELECT @respuesta = 'Se ha actualizado el registro'  
		SELECT @estadoRespuesta = 2 
	END 
ELSE 
	BEGIN
		INSERT INTO [dbo].[RetroGraficaNivel]
           (IdRetroAdmin,[TipoGrafica],[Color1serie],[Color2serie],[Color3serie],[TituloGraf]
           ,[NombreSerie1],[NombreSerie2],[NombreSerie3])
		   VALUES
		   (@IdRetroAdmin, @TipoGrafica, @Color1serie, @Color2serie, @Color3serie, @TituloGraf,
			@NombreSerie1, @NombreSerie2, @NombreSerie3)

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

  IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_EncuestaRetroUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_EncuestaRetroUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================  
-- Autor: Equipo de desarrollo OIM - John Betancourt A. 
-- Fecha creacion: 2017-08-04
-- Descripcion: Actualiza un registro en la realiemntacion                     
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado            
-- Estado int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado            
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'      
--====================================================================================================  
ALTER PROC [dbo].[U_EncuestaRetroUpdate]   
 
	@IdRetroAdmin int NULL,
	@Presentacion  varchar(50) = NULL,
	@PresTexto varchar(max) = NULL,
	@Nivel varchar(50) = NULL,
	@NivTexto varchar(max) NULL,
	@Nivel2 varchar(50) = NULL,
	@Niv2Texto varchar(max) = NULL,
	@NivIdGrafica int = NULL,
	@Desarrollo varchar(50) = NULL,
	@DesTexto varchar(max) = NULL,
	@Desarrollo2 varchar(50) = NULL,
	@Des2Texto varchar(max) = NULL,
	@DesIdGrafica int = NULL,
	@Analisis varchar(50) = NULL,
	@AnaTexto varchar(max) = NULL,
	@Revision varchar(50) = NULL,
	@RevTexto varchar(max) = NULL,
	@Historial varchar(50) = NULL,
	@HisTexto varchar(max) = NULL,
	@Observa varchar(50) = NULL,
	@ObsTexto varchar(max) = NULL,
	@IdTipoGuardado int = NULL
AS   
  
 -- Parámetros para el manejo de la respuesta  
 DECLARE @respuesta AS NVARCHAR(2000) = ''  
 DECLARE @estadoRespuesta  AS INT = 0  
 DECLARE @esValido AS BIT = 1  
  
   
 IF(@esValido = 1)   
 BEGIN  
  BEGIN TRANSACTION  
  BEGIN TRY  

	IF(@IdTipoGuardado = 1)
		BEGIN
		   UPDATE   
			[dbo].[RetroConsultaEncuesta]  
		   SET      
			Presentacion = @Presentacion,
			PresTexto  = @PresTexto  
		   WHERE    
			IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
		END 
	ELSE IF(@IdTipoGuardado = 2)
		BEGIN
		   UPDATE   
			[dbo].[RetroConsultaEncuesta]  
		   SET      
			Nivel = @Nivel,
			NivTexto = @NivTexto,
			Nivel2 = @Nivel2,
			Niv2Texto = @Niv2Texto,
			NivIdGrafica = @NivIdGrafica
		   WHERE    
			IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
		END
	ELSE IF(@IdTipoGuardado = 3)
		BEGIN
		   UPDATE   
			[dbo].[RetroConsultaEncuesta]  
		   SET
		   	Desarrollo = @Desarrollo,
			DesTexto = @DesTexto,
			Desarrollo2 = @Desarrollo2,
			Des2Texto = @Des2Texto,
			DesIdGrafica = @DesIdGrafica
         WHERE    
			IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
		END
	ELSE IF(@IdTipoGuardado = 4)
		BEGIN
		   UPDATE   
			[dbo].[RetroConsultaEncuesta]  
		   SET
		   	Analisis = @Analisis,
			AnaTexto = @AnaTexto
         WHERE    
			IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
		END    
	ELSE IF(@IdTipoGuardado = 5)
		BEGIN
		   UPDATE   
			[dbo].[RetroConsultaEncuesta]  
		   SET
			Revision = @Revision,
			RevTexto = @RevTexto
         WHERE    
			IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
		END
	ELSE IF(@IdTipoGuardado = 6)
		BEGIN
		   UPDATE   
			[dbo].[RetroConsultaEncuesta]  
		   SET
			Historial = @Historial,
			HisTexto = @HisTexto
         WHERE    
			IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
		END
	ELSE IF(@IdTipoGuardado = 7)
		BEGIN
		   UPDATE   
			[dbo].[RetroConsultaEncuesta]  
		   SET
			Observa = @Observa,
			ObsTexto = @ObsTexto
         WHERE    
			IdRetroAdmin = @IdRetroAdmin --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento
		END      
	
       
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

  IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_RetroArcPreguntasUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_RetroArcPreguntasUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Equipo de desarrollo OIM - John Betancourt  
-- Create date: 05/09/2017  
-- Description: ingresa una nueva pregunta tipo archivo   
-- =============================================  
ALTER PROC [dbo].[U_RetroArcPreguntasUpdate]   
	@IdRetroArc			INT,
    @Documento			VARCHAR(50),  
    @Check				bit,
	@Sumar				bit,
    @Pertenece			INT,
    @Observacion		VARCHAR(500),
    @Valor				VARCHAR(500),
    @UltimoUsuario		VARCHAR(50)
	  
AS  
  
-- Parámetros para el manejo de la respuesta    
 DECLARE @respuesta AS NVARCHAR(2000) = ''    
 DECLARE @estadoRespuesta  AS INT = 0    
  
 BEGIN    
  BEGIN TRANSACTION    
  BEGIN TRY     
 BEGIN  
  UPDATE [dbo].[RetroArcPreguntasXEncuesta]
   SET [Documento] = @Documento
      ,[Check] = @Check
	  ,[Sumariza] = @Sumar
      ,[Pertenece] = @Pertenece
      ,[Observacion] = @Observacion
      ,[Valor] = @Valor
      WHERE Id = @IdRetroArc  
      SELECT @respuesta = 'Se ha Actualizado el registro'    
   SELECT @estadoRespuesta = 2
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

  IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_RetroArcPreguntasUpdateXUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_RetroArcPreguntasUpdateXUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Equipo de desarrollo OIM - John Betancourt  
-- Create date: 05/09/2017  
-- Description: ingresa una nueva pregunta tipo archivo   
-- =============================================  
ALTER PROC [dbo].[U_RetroArcPreguntasUpdateXUsuario]   
	@IdRetroArc			INT,
    @Check				bit,
    @Pertenece			INT,
    @Observacion		VARCHAR(500),
    @Valor				VARCHAR(500),
    @UltimoUsuario		VARCHAR(50)
	  
AS  
  
-- Parámetros para el manejo de la respuesta    
 DECLARE @respuesta AS NVARCHAR(2000) = ''    
 DECLARE @estadoRespuesta  AS INT = 0    
  
 BEGIN    
  BEGIN TRANSACTION    
  BEGIN TRY     
 BEGIN  
  UPDATE [dbo].[RetroArcPreguntasXEncuestaXmunicipio]
   SET [Check] = @Check
      ,[Pertenece] = @Pertenece
      ,[Observacion] = @Observacion
      ,[Valor] = @Valor
      WHERE Id = @IdRetroArc  
      SELECT @respuesta = 'Se ha Actualizado el registro'    
   SELECT @estadoRespuesta = 2
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






