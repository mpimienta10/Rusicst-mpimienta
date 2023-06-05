GO

if not exists (select * from sys.columns where name='TextoExplicativoALC' OR name='TextoExplicativoALC')
begin 
	ALTER TABLE [PAT].Derecho ADD [TextoExplicativoALC] varchar(max) null
	ALTER TABLE [PAT].Derecho ADD [TextoExplicativoGOB] varchar(max) null
end

GO

/****** Object:  Table [PAT].[ConfiguracionDerechosPAT]    Script Date: 15/11/2017 23:35:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [PAT].[ConfiguracionDerechosPAT](
	[IdDerecho] [smallint] NOT NULL,
	[Papel] [varchar](50) NOT NULL,
	[Tipo] [varchar](50) NOT NULL,
	[NombreParametro] [varchar](50) NULL,
	[ParametroValor] [varchar](max) NULL,
	[Texto] [varchar](max) NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_ParametrosSistema] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [PAT].[ConfiguracionDerechosPAT]  WITH CHECK ADD  CONSTRAINT [FK_ConfiguracionDerechosPAT_Derecho] FOREIGN KEY([IdDerecho])
REFERENCES [PAT].[Derecho] ([Id])
GO

ALTER TABLE [PAT].[ConfiguracionDerechosPAT] CHECK CONSTRAINT [FK_ConfiguracionDerechosPAT_Derecho]
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ConfiguracionDerechosPAT]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ConfiguracionDerechosPAT] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Sergio Zúñiga
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Obtiene todos las configuraciones de acuerdo al derecho seleccionado
-- =============================================
ALTER PROC [PAT].[C_ConfiguracionDerechosPAT] 

( @IdDerecho tinyint)

AS
BEGIN
	SELECT C.Id, C.IdDerecho, C.Papel, C.Tipo, C.NombreParametro, C.ParametroValor, C.Texto
	FROM  [PAT].ConfiguracionDerechosPAT C
	WHERE C.IdDerecho = @IdDerecho
	ORDER BY C.IdDerecho
END




GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_ConfiguracionDerechoPAT]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_ConfiguracionDerechoPAT] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=================================================================================================
-- Autor: Equipo de desarrollo OIM - Sergio Zúniga																	 
-- Fecha creacion: 2017-03-08																		 
-- Descripcion: Inserta los datos en la tabla Configuración de Derechos PAT
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--=================================================================================================
 ALTER PROCEDURE [PAT].[I_ConfiguracionDerechoPAT] 

	@IdDerecho			INT,
	@Papel				VARCHAR(50),
	@Tipo				VARCHAR(50),
	@NombreParametro	VARCHAR(50),
	@ParametroValor		VARCHAR(MAX),
	@Texto				VARCHAR(MAX)

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
					
					INSERT INTO PAT.ConfiguracionDerechosPAT (IdDerecho, Papel, Tipo, NombreParametro, ParametroValor, Texto)
					SELECT @IdDerecho, @Papel, @Tipo, @NombreParametro, @ParametroValor, @Texto
					
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

	END 


GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_ConfiguracionDerechosPAT]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_ConfiguracionDerechosPAT]   AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Sergio Zúniga
-- Create date: 21/02/2017
-- Description:	Actualiza la información de la tabla de Configuracion de Derechos PAT
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [PAT].[U_ConfiguracionDerechosPAT] 
	
	 @Id			        INT
	,@NombreParametro		VARCHAR(50) = NULL
    ,@ParametroValor		VARCHAR(MAX) = NULL
	,@Texto					VARCHAR(MAX) = NULL

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
						PAT.ConfiguracionDerechosPAT
					SET 
						[NombreParametro] = @NombreParametro
					   ,[ParametroValor] =  @ParametroValor	
					   ,[Texto] =  @Texto						
					WHERE 
						PAT.ConfiguracionDerechosPAT.Id = @Id
					
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

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[D_ConfiguracionDerechosPAT]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[D_ConfiguracionDerechosPAT] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--====================================================================================================
-- Autor: Equipo de desarrollo OIM - Sergio Zúñiga																	  
-- Fecha creacion: 2017-03-08																			  
-- Descripcion: elimina un registro de la tabla de Configuración de Derechos PAT
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--====================================================================================================
ALTER PROCEDURE [PAT].[D_ConfiguracionDerechosPAT] 

	@Id	 INT

AS 
	
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0
	DECLARE @esValido AS BIT = 1

	IF(@esValido = 1) 
		BEGIN
			BEGIN TRANSACTION
			BEGIN TRY
				DELETE FROM PAT.ConfiguracionDerechosPAT
					WHERE Id = @Id		
		
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

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_DerechosPAT]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_DerechosPAT] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Sergio Zúniga
-- Create date: 21/02/2017
-- Description:	Actualiza la información de la tabla de Configuracion de Derechos PAT
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [PAT].[U_DerechosPAT] 
	
	 @IdDerecho					INT
	,@TextoExplicativoGOB		VARCHAR(MAX) = NULL
	,@TextoExplicativoALC		VARCHAR(MAX) = NULL
  
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
						PAT.Derecho
					SET 
						TextoExplicativoGOB = @TextoExplicativoGOB
					   ,TextoExplicativoALC = @TextoExplicativoALC	
					WHERE 
						Id = @IdDerecho
					
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

GO
/****** Object:  StoredProcedure [PAT].[C_TodosDerechos]    Script Date: 15/11/2017 13:45:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		25/07/2017
-- Modified date:	25/07/2017
-- Description:		Obtiene todos los derechos activos
-- =============================================
ALTER PROC [PAT].[C_TodosDerechos] 
AS
BEGIN
	SELECT  D.Id, D.Descripcion, D.TextoExplicativoGOB, D.TextoExplicativoALC
	FROM  [PAT].[Derecho] D
	ORDER BY D.Descripcion
END

go
