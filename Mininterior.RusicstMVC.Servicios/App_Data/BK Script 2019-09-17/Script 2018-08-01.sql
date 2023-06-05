IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_ConsultaRetroGraficaNivel]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ConsultaRetroGraficaNivel] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 15/08/2017
-- Description:		obtiene los datos de la grafica de Nivel
-- =============================================
ALTER PROC [dbo].[C_ConsultaRetroGraficaNivel] 

	@IdRetroAdmin 				INT
AS

SELECT [Id]
      ,[IdRetroAdmin]
      ,[TipoGrafica]
      ,[Color1serie]
      ,''[Color2serie]
      ,''[Color3serie]
      ,[TituloGraf]
      ,''[NombreEje1]
      ,''[NombreEje2]
      ,[NombreSerie1]
      ,''[NombreSerie2]
      ,''[NombreSerie3]
  FROM [dbo].[RetroGraficaNivel]
  WHERE [IdRetroAdmin] = @IdRetroAdmin

GO

--C_ConsultaRetroGraficaNivel 2
