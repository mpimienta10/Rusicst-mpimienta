IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[PreguntaPATPrecargueEntidadesNacionales]')) 
BEGIN
	drop table [PAT].[PreguntaPATPrecargueEntidadesNacionales]
END
CREATE TABLE [PAT].[PreguntaPATPrecargueEntidadesNacionales](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPreguntaPat] [smallint] NOT NULL,
	[IdMunicipio] [int] NOT NULL,
	[EntidadNacional] [varchar](MAX) NULL,
	[PlanCompromiso] [bigint] NOT NULL,
	[PlanPresupuesto] [money] NOT NULL,
	[SegCompromiso1] [bigint] NOT NULL,
	[SegPresupuesto1] [money] NOT NULL,
	[SegCompromiso2] [bigint] NOT NULL,
	[SegPresupuesto2] [money] NOT NULL,
	[Observaciones] [varchar](MAX) NULL,
	[Programas] [varchar](MAX) NULL,
CONSTRAINT [PK_PreguntaPATPrecargueEntidadesNacionales] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) 

ALTER TABLE [PAT].[PreguntaPATPrecargueEntidadesNacionales]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATPrecargueEntidadesNacionales_Municipio] FOREIGN KEY([IdMunicipio])
REFERENCES [dbo].[Municipio] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPATPrecargueEntidadesNacionales] CHECK CONSTRAINT [FK_PreguntaPATPrecargueEntidadesNacionales_Municipio]
GO

ALTER TABLE [PAT].[PreguntaPATPrecargueEntidadesNacionales]  WITH CHECK ADD  CONSTRAINT [FK_PreguntaPATPrecargueEntidadesNacionales_PreguntaPAT] FOREIGN KEY([IdPreguntaPat])
REFERENCES [PAT].[PreguntaPAT] ([Id])
GO

ALTER TABLE [PAT].[PreguntaPATPrecargueEntidadesNacionales] CHECK CONSTRAINT [FK_PreguntaPATPrecargueEntidadesNacionales_PreguntaPAT]
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_PrecargueSegxPreguntaMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_PrecargueSegxPreguntaMunicipio] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:   John Betancourt OIM
-- Modifica: 
-- Create date:		27/06/2018
-- Description:		Consulta si la combinacion de por preguunta y municipio existe, si existe la actualiza, sino la ingresa
-- ==========================================================================================
ALTER PROC [PAT].[I_PrecargueSegxPreguntaMunicipio] 
(
	@IdPregunta INT,
	@IdMunicipio INT,
	@EntidadNacional VARCHAR(MAX),
	@PlanCompromiso BIGINT,
	@PlanPresupuesto MONEY,
	@SegCompromiso1 BIGINT,
	@SegPresupuesto1 MONEY,
	@SegCompromiso2 BIGINT,
	@SegPresupuesto2 MONEY,
	@Observaciones VARCHAR(MAX),
	@Programas VARCHAR(MAX) 
	)
AS

-- Parámetros para el manejo de la respuesta    
DECLARE @respuesta AS NVARCHAR(2000) = ''    
DECLARE @estadoRespuesta  AS INT = 0    

BEGIN    
  BEGIN TRANSACTION    
  BEGIN TRY  

BEGIN
	BEGIN
		INSERT INTO [PAT].[PreguntaPATPrecargueEntidadesNacionales]
           ([IdPreguntaPat]
			,[IdMunicipio]
			,[EntidadNacional]
			,[PlanCompromiso]
			,[PlanPresupuesto]
			,[SegCompromiso1]
			,[SegPresupuesto1]
			,[SegCompromiso2]
			,[SegPresupuesto2]
			,[Observaciones]
			,[Programas])
     VALUES
           (@IdPregunta
			,@IdMunicipio
			,@EntidadNacional
			,@PlanCompromiso
			,@PlanPresupuesto
			,@SegCompromiso1
			,@SegPresupuesto1
			,@SegCompromiso2
			,@SegPresupuesto2
			,@Observaciones
			,@Programas)
		
		SELECT @respuesta = 'Se ha Ingresado el registro'    
		SELECT @estadoRespuesta = 1 
	END
END
 COMMIT  TRANSACTION    
  END TRY    
  BEGIN CATCH    
   ROLLBACK TRANSACTION    
   SELECT @respuesta = ERROR_MESSAGE()    
   SELECT @estadoRespuesta = 0    
  END CATCH    
 END 

 select @respuesta as respuesta, @estadoRespuesta as estado

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_PreguntaPATPrecargueEntidadesNacionales]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_PreguntaPATPrecargueEntidadesNacionales] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/11/2017
-- Modified date:	21/11/2017
-- Modified date:	05/07/2018 John Betancourt A. OIM - se cambia el nombre de los parametros de la tabla
-- Description:		Obtiene los datos del precargue de entidades nacionales por el derecho
-- =============================================
ALTER PROC [PAT].[C_PreguntaPATPrecargueEntidadesNacionales] ( @IdPregunta smallint, @IdMunicipio int)
AS
BEGIN
	select E.IdPreguntaPat,    M.Nombre AS Municipio , D.Nombre as Departamento,
		E.EntidadNacional,E.PlanCompromiso, E.PlanPresupuesto, E.SegCompromiso1, E.SegPresupuesto1,
		E.SegCompromiso2, E.SegPresupuesto2, E.Observaciones, E.Programas
	from  [PAT].[PreguntaPATPrecargueEntidadesNacionales] as E
	join Municipio as M on E.IdMunicipio =M.Id
	join Departamento as D on M.IdDepartamento = D.Id
	where E.IdPreguntaPat =  @IdPregunta 
	and E.IdMunicipio =@IdMunicipio
END

GO


