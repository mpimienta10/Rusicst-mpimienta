IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Retro.ConsultaEncuesta]')) 
	drop table [Retro.ConsultaEncuesta]
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroConsultaEncuesta]')) 
	drop table RetroConsultaEncuesta

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroAdmin]')) 
BEGIN

	CREATE TABLE [dbo].[RetroAdmin](
		[Id] [int] IDENTITY(1,1) NOT NULL,
		[Nombre] [varchar](50) NOT NULL,
		[IdEncuesta] [int] NOT NULL,
	 CONSTRAINT [PK_RetroAdmin] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[RetroAdmin]  WITH CHECK ADD  CONSTRAINT [FK_RetroAdmin_Encuesta] FOREIGN KEY([IdEncuesta])
	REFERENCES [dbo].[Encuesta] ([Id])

	ALTER TABLE [dbo].[RetroAdmin] CHECK CONSTRAINT [FK_RetroAdmin_Encuesta]
END




/****** Object:  Table [dbo].[PreguntaDesencadenantes]    Script Date: 05/09/2017 10:39:13 ******/
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PreguntaDesencadenantes]')) 
BEGIN

	CREATE TABLE [dbo].[PreguntaDesencadenantes](
		[IdPregunta] [int] NOT NULL,
		[IdDesencadenante] [int] NOT NULL,
		[TotalDesencadenantes] [int] NULL,
		[TotalIds] [int] NULL,
		[IdInterno] [int] NULL,
	 CONSTRAINT [PK_PreguntaDesencadenantes] PRIMARY KEY CLUSTERED 
	(
		[IdPregunta] ASC,
		[IdDesencadenante] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
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

/****** Object:  Table [dbo].[RetroEtapaPreguntas]    Script Date: 5/09/2017 11:03:04 a. m. ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RetroEtapaPreguntas]')) 
BEGIN

	CREATE TABLE [dbo].[RetroEtapaPreguntas](
		[Nombre] [varchar](50) NOT NULL
	) ON [PRIMARY]

	INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'DISENO2015')

	INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'DISENO2016')

	INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'DISENO2017')

	INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'IMPLEMENTACION2015')

	INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'IMPLEMENTACION2016')

	INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'IMPLEMENTACION2017')

	INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'EVALUACION2015')

	INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'EVALUACION2016')

	INSERT [dbo].[RetroEtapaPreguntas] ([Nombre]) VALUES (N'EVALUACION2017')

END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntaXCodigoSeccion]')) 
drop procedure [dbo].[C_PreguntaXCodigoSeccion]
go
GO
/****** Object:  StoredProcedure [dbo].[C_PreguntaXCodigoSeccion]    Script Date: 05/09/2017 10:27:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		Equipo de desarrollo OIM - Rafael Alba
-- Create date: 02/08/2017
-- Description:	Selecciona la pregunta por código y Seccion 
-- ============================================================
CREATE PROCEDURE [dbo].[C_PreguntaXCodigoSeccion] 

	@CodigoPregunta	 VARCHAR(8000),
	@IdSeccion int

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT a.*
		  FROM dbo.Pregunta a
		  inner join dbo.Seccion b on b.Id = a.IdSeccion
		  inner join BancoPreguntas.PreguntaModeloAnterior c on c.IdPreguntaAnterior = a.Id
		  inner join BancoPreguntas.Preguntas d on d.IdPregunta = c.IdPregunta 
		  where d.CodigoPregunta = @CodigoPregunta and b.Id = @IdSeccion
  
		UNION ALL
  
		  SELECT a.*
		  FROM dbo.Pregunta a
		  inner join dbo.Seccion b on b.Id = a.IdSeccion
		  where a.Nombre = @CodigoPregunta and b.Id = @IdSeccion

	END	

	go


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntaXDesencadenante]')) 
drop procedure [dbo].[C_PreguntaXDesencadenante]
go

GO
/****** Object:  StoredProcedure [dbo].[C_PreguntaXDesencadenante]    Script Date: 05/09/2017 10:29:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		Equipo de desarrollo OIM - Rafael Alba
-- Create date: 28/08/2017
-- Description:	Selecciona las preguntas por desencadenante
-- ============================================================
create PROCEDURE [dbo].[C_PreguntaXDesencadenante] 

	@IdPregunta	 INT

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT [IdPregunta], P.SoloSi
		FROM [dbo].[PreguntaDesencadenantes] PD
		INNER JOIN Pregunta P
		ON PD.IdPregunta = P.Id
		WHERE IdDesencadenante = @IdPregunta

	END	

	GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntaXNombre]')) 
drop procedure [dbo].[C_PreguntaXNombre]
go

GO
/****** Object:  StoredProcedure [dbo].[C_PreguntaXNombre]    Script Date: 05/09/2017 10:30:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		Equipo de desarrollo OIM - Rafael Alba
-- Create date: 25/07/2017
-- Description:	Selecciona la pregunta por nombre de pregunta
-- ============================================================
create PROCEDURE [dbo].[C_PreguntaXNombre] 

	@NombrePregunta	 VARCHAR(512), 
	@IDSeccion Int

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			[Id]
		FROM [dbo].[Pregunta]
		WHERE [Nombre] =  @NombrePregunta 
		AND [IdSeccion] = @IdSeccion

	END	

	go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntaXNombrePasada]')) 
drop procedure [dbo].[C_PreguntaXNombrePasada]
go

/****** Object:  StoredProcedure [dbo].[C_PreguntaXNombrePasada]    Script Date: 05/09/2017 10:35:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		Equipo de desarrollo OIM - Rafael Alba
-- Create date: 25/07/2017
-- Description:	Selecciona la pregunta por nombre de pregunta 
-- ============================================================
CREATE PROCEDURE [dbo].[C_PreguntaXNombrePasada] 

	@NombrePregunta	 VARCHAR(512)

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			[Id]
		FROM [dbo].[Pregunta]
		WHERE [Nombre] =  @NombrePregunta 

	END	

	GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_RespuestaXIdPreguntaUsuario]')) 
drop procedure [dbo].[C_RespuestaXIdPreguntaUsuario]
go


GO
/****** Object:  StoredProcedure [dbo].[C_RespuestaXIdPreguntaUsuario]    Script Date: 05/09/2017 10:37:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================
-- Author:		Equipo de desarrollo OIM - Rafael Alba
-- Create date: 25/07/2017
-- Description:	Selecciona la respuesta por IdPregunta y Usuario de encuesta
-- ============================================================
create PROCEDURE [dbo].[C_RespuestaXIdPreguntaUsuario] 

	@IdPregunta	Int, 
	@IdUsuario Int

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT [Id]
		,[Fecha]
		,[Valor]
		FROM [dbo].[Respuesta]
		WHERE [IdPregunta] = @IdPregunta
		AND [IdUsuario] = @IdUsuario 
	END	

	go

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
	--@IdMunicipio				INT,
	--@IdDepartamento				INT

AS

IF NOT EXISTS(SELECT 1 FROM [dbo].[RetroConsultaEncuesta] Where [IdRetroAdmin] = @IdRetroAdmin) --AND IdMunicipio = @IdMunicipio AND IdDepartamento = @IdDepartamento)
	BEGIN
		EXEC I_DatosPrincipalesRetroEncuesta @IdRetroAdmin
	END

BEGIN
	SELECT [Id]
		  ,[IdRetroAdmin]
		  --,[IdMunicipio]
		  --,[IdDepartamento]
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


GO

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
	@IdEncuesta				INT
AS

	select S.IdEncuesta, P.CodigoPregunta, p.NombrePregunta, TP.Nombre, R.Valor, R.*
	from [BancoPreguntas].[Preguntas] P
	INNER JOIN [BancoPreguntas].[PreguntaModeloAnterior] PA on P.IdPregunta = PA.IdPregunta
	INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id AND PO.IdTipoPregunta = 1
	INNER JOIN Seccion S on PO.IdSeccion = S.Id AND S.IdEncuesta = @IdEncuesta
	INNER JOIN TipoPregunta tp on P.IdTipoPregunta = tp.Id
	LEFT JOIN Respuesta R ON R.Id = PA.IdPregunta
	where CodigoPregunta = @IdPregunta 
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
			INNER JOIN Respuesta R ON R.Id = PA.IdPregunta AND IdUsuario = @IdUser	
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
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
			INNER JOIN Respuesta R ON R.Id = PA.IdPregunta AND IdUsuario = @IdUser		
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
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
			INNER JOIN Respuesta R ON R.Id = PA.IdPregunta AND IdUsuario = @IdUser			
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
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
			INNER JOIN Respuesta R ON R.Id = PA.IdPregunta AND IdUsuario = @IdUser			
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
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
			INNER JOIN Respuesta R ON R.Id = PA.IdPregunta AND IdUsuario = @IdUser				
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
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
			INNER JOIN Respuesta R ON R.Id = PA.IdPregunta AND IdUsuario = @IdUser			
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
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
			INNER JOIN Respuesta R ON R.Id = PA.IdPregunta AND IdUsuario = @IdUser	
			--LEFT JOIN Respuesta R ON R.Id = PA.IdPregunta AND IdUsuario = @IdUser	
			INNER JOIN Pregunta PO on  PA.IdPreguntaAnterior = PO.Id
			INNER JOIN Seccion S on PO.IdSeccion = S.Id
            INNER JOIN Seccion AS Seccion_1 ON S.SuperSeccion = Seccion_1.Id 
            FULL OUTER JOIN Seccion AS Seccion_2 ON Seccion_1.SuperSeccion = Seccion_2.Id			
			inner join fnSplit(@IdsEncuestas,',') on Palabra =  S.IdEncuesta
			where Seccion_1.Titulo like '%Territorial'
			--order by R.id
			) tmp
			group by tmp.IdEncuesta, tmp.Etapa
			--order by tmp.IdEncuesta
			) Datos
			ON (Datos.Etapa + CONVERT(varchar(10), Datos.Anio)) = REP.Nombre
			

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_EncuestaPruebaContenidoDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_EncuestaPruebaContenidoDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================  
-- Author:  John Betancourt A. - OIM  
-- Create date: 17/06/2017  
-- Description: Procedimiento que elimina la encuesta de prueba en cascada  
-- =================================================================  
ALTER PROC [dbo].[D_EncuestaPruebaContenidoDelete]  
(  
 @IdEncuesta INT  
)  
  
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
     IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)))  
     BEGIN  
      DELETE FROM [dbo].[Respuesta]  
      WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta))  
     END  
   
     IF EXISTS(SELECT 1 FROM [BancoPreguntas].[PreguntaModeloAnterior] WHERE IdPreguntaAnterior IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)))  
     BEGIN  
      DELETE FROM [BancoPreguntas].[PreguntaModeloAnterior]  
      WHERE [IdPreguntaAnterior] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta))  
     END  
   
	 IF EXISTS(SELECT 1 FROM [dbo].[Opciones] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)))  
     BEGIN  
      DELETE FROM [dbo].[Recomendacion]  
      WHERE [IdOpcion] IN (SELECT [Id] FROM [dbo].[Opciones] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)))
     END

     IF EXISTS(SELECT 1 FROM [dbo].[Opciones] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)))  
     BEGIN  
      DELETE FROM [dbo].[Opciones]  
      WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta))  
     END  
   
     DELETE FROM [dbo].[Diseno]  
     WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)

     DELETE FROM [dbo].[Pregunta]  
     WHERE [IdSeccion] IN (SELECT [Id] FROM [dbo].[Seccion] WHERE [IdEncuesta] = @IdEncuesta)
	 
	 DELETE FROM [dbo].[Seccion]  
	 WHERE [IdEncuesta] = @IdEncuesta

	 DELETE FROM Roles.RolEncuesta
	 WHERE [IdEncuesta] = @IdEncuesta

	 DELETE FROM Autoevaluacion2
	 WHERE [IdEncuesta] = @IdEncuesta

	 DELETE FROM Envio
	 WHERE [IdEncuesta] = @IdEncuesta

	 DELETE FROM PermisoUsuarioEncuesta
	 WHERE [IdEncuesta] = @IdEncuesta

	 DELETE FROM [dbo].[Encuesta]  
	 WHERE [Id] = @IdEncuesta
  
     SELECT @respuesta = 'Se ha eliminado la encuesta de Prueba y todo su contenido'  
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
 END   
  
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_ContenidoSeccionDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_ContenidoSeccionDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================  
-- Author:  Equipo de desarrollo - OIM  
-- Create date: 17/06/2017  
-- Description: Procedimiento que elimina las secciones en cascada  
-- Modificacion: John Betancourt Devolver el valor de los parametros  
-- =================================================================  
ALTER PROC [dbo].[D_ContenidoSeccionDelete]  
(  
 @IdSeccion INT  
)  
  
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
     IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion))  
     BEGIN  
      DELETE FROM [dbo].[Respuesta]  
      WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion)  
     END  
   
     IF EXISTS(SELECT 1 FROM [BancoPreguntas].[PreguntaModeloAnterior] WHERE IdPreguntaAnterior IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion))  
     BEGIN  
      DELETE FROM [BancoPreguntas].[PreguntaModeloAnterior]  
      WHERE [IdPreguntaAnterior] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion)  
     END  
   
     IF EXISTS(SELECT 1 FROM [dbo].[Opciones] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion))  
     BEGIN  
      DELETE FROM [dbo].[Opciones]  
      WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @IdSeccion)  
     END  
   
     DELETE FROM [dbo].[Diseno]  
     WHERE [IdSeccion] = @IdSeccion  
   
     DELETE FROM [dbo].[Pregunta]  
     WHERE [IdSeccion] = @IdSeccion  
  
     SELECT @respuesta = 'Se ha eliminado el registro'  
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
 END   
  
GO