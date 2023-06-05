IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PreguntaDesencadenantes]')) 
	drop table [dbo].[PreguntaDesencadenantes]

/****** Object:  Table [dbo].[PreguntaDesencadenantes]    Script Date: 11/09/2017 12:16:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PreguntaDesencadenantes](
	[IdPregunta] [int] NOT NULL,
	[IdDesencadenante] [int] NOT NULL
 CONSTRAINT [PK_PreguntaDesencadenantes] PRIMARY KEY CLUSTERED 
(
	[IdPregunta] ASC,
	[IdDesencadenante] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DibujarEncuestaSeccionesSubsecciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarEncuestaSeccionesSubsecciones] AS'


GO
/****** Object:  StoredProcedure [dbo].[C_DibujarEncuestaSeccionesSubsecciones]    Script Date: 12/09/2017 17:13:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Rafael Alba																	 
-- Fecha creacion: 2017-06-16																			 
-- Descripcion: Trae el listado de secciones Y subsecciones de una encuesta para ser pintado									
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DibujarEncuestaSeccionesSubsecciones]

	 @IdEncuesta	INT

AS

BEGIN

	SELECT 
		  [Id]
		 ,[Titulo]
		 ,[SuperSeccion]
		 ,[OcultaTitulo]
		 ,[Estilos]
		 ,[Archivo]
	FROM 
		[dbo].[Seccion] AS s
	WHERE 
		s.IdEncuesta = @IdEncuesta 
	ORDER BY 
		[SuperSeccion], Titulo

END


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_RespuestaEncuestaInsert]') AND type in (N'P', N'PC'))
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_RespuestaEncuestaInsert] AS'


GO
/****** Object:  StoredProcedure [dbo].[I_RespuestaEncuestaInsert]    Script Date: 12/09/2017 12:36:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================
-- Autor: Equipo de desarrollo OIM - Rafael Alba																		  
-- Fecha creacion: 2017-09-12																			  
-- Descripcion: Ingresa o actualiza una respuesta 
-- Retorna: 
-- Estado:
-- 
--====================================================================================================
ALTER PROCEDURE [dbo].[I_RespuestaEncuestaInsert] 

	@IdPregunta   INT,
	@Valor        VARCHAR(1000),
	@IdUsuario    INT

AS 
	BEGIN
		SET NOCOUNT ON;
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY
				IF NOT EXISTS(SELECT * FROM [dbo].[Respuesta] WHERE [IdPregunta] = @IdPregunta AND [IdUsuario] = @IdUsuario)
				BEGIN
					INSERT INTO [dbo].[Respuesta] ([IdPregunta], [Valor], [IdUsuario]) VALUES (@IdPregunta, @Valor, @IdUsuario);
				END;
				ELSE
				BEGIN
					UPDATE [dbo].[Respuesta] SET [IdPregunta] = @IdPregunta, [Fecha] = getdate(), [Valor] = @Valor, [IdUsuario] = @IdUsuario WHERE [IdPregunta] = @IdPregunta AND [IdUsuario] = @IdUsuario;
				END; 

			COMMIT  TRANSACTION
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
			END CATCH
		END
	END 

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntaXCodigoNuevo]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PreguntaXCodigoNuevo] AS'


/****** Object:  StoredProcedure [dbo].[C_PreguntaXCodigo]    Script Date: 13/09/2017 7:42:08 ******/
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

AS
	BEGIN
	
		SET NOCOUNT ON;
		SELECT 
			 [IdPregunta]
		FROM [BancoPreguntas].[Preguntas]
		WHERE [CodigoPregunta] =  @CodigoPregunta
	END	

	