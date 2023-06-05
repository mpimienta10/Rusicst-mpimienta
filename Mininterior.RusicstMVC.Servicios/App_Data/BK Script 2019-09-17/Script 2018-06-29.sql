IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ProgramasPlaneacionWebService]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ProgramasPlaneacionWebService] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/06/2018
-- Description:		Retorna informacion de los programas de planeacion de un tablero para el precargue de SIGO
-- =============================================
ALTER PROC  [PAT].[C_ProgramasPlaneacionWebService] --[PAT].[C_ProgramasPlaneacionWebService]  2
	@IdTablero INT	
AS
BEGIN
		select  AnoPlaneacion,IdPregunta,PreguntaCompromiso,IdRespuesta,IdRespuestaPrograma,IdDerecho,Programa,Compromiso,IdMunicipio,IdDepartamento,Departamento,Municipio, Nivel
		from (
			SELECT DISTINCT
			YEAR(T.VigenciaInicio)+1 AS AnoPlaneacion,
			P.ID AS IdPregunta, 
			P.PreguntaCompromiso,
			P.IDDERECHO AS IdDerecho, 
			R.ID AS IDTABLERO,						
			R.IdMunicipio,
			R.ID as IdRespuesta,		
			R.RESPUESTACOMPROMISO AS Compromiso, 
			R.PRESUPUESTO,
			Dep.Divipola as IdDepartamento, Dep.Nombre as Departamento,
			Mun.Nombre as Municipio
			,AP.Id AS IdRespuestaPrograma
			,(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE( AP.PROGRAMA,char(0x000B) ,'') , '"', '''') , CHAR(10), ' '),CHAR(13), ' '),CHAR(9), ' '),';','.')) AS Programa, 3 as Nivel
			FROM    [PAT].[PreguntaPAT] AS P
			INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
			INNER JOIN PAT.Tablero as T ON P.IdTablero = T.Id
			JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] --and  R.IdMunicipio = @IdMunicipio 	
			JOIN Municipio AS Mun ON R.IdMunicipio = Mun.Id
			JOIN Departamento as Dep on R.IdDepartamento = Dep.Id 	 							
			JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
			WHERE  P.IdTablero = @IdTablero
			AND P.Activo = 1
			and	P.NIVEL = 3 					
		) AS A 	
		union all
		select  AnoPlaneacion,IdPregunta,PreguntaCompromiso,IdRespuesta,IdRespuestaPrograma,IdDerecho,Programa,Compromiso,IdMunicipio,IdDepartamento,Departamento,Municipio, Nivel
		from (
			SELECT DISTINCT
			YEAR(T.VigenciaInicio)+1 AS AnoPlaneacion,
			P.ID AS IdPregunta, 
			P.PreguntaCompromiso,
			P.IDDERECHO AS IdDerecho, 
			R.ID AS IDTABLERO,						
			R.IdDepartamento ,
			R.ID as IdRespuesta,		
			R.RESPUESTACOMPROMISO AS Compromiso, 
			R.PRESUPUESTO,
			null as IdMunicipio, Dep.Nombre as Departamento, null as Municipio		
			,AP.Id AS IdRespuestaPrograma
			,(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( REPLACE( AP.PROGRAMA,char(0x000B) ,'') , '"', '''') , CHAR(10), ' '),CHAR(13), ' '),CHAR(9), ' '),';','.')) AS Programa, 2 as Nivel
			FROM    [PAT].[PreguntaPAT] AS P
			INNER JOIN PAT.Tablero as T ON P.IdTablero = T.Id
			JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] 			
			JOIN Departamento as Dep on R.IdDepartamento = Dep.Id 	 							
			LEFT OUTER JOIN [PAT].[RespuestaPATAccion] AS AA ON AA.[IdRespuestaPAT] = R.ID and AA.Activo = 1
			LEFT OUTER JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
			WHERE  P.IdTablero = @IdTablero
			AND P.Activo = 1
			and	P.NIVEL = 2 					
		) AS A 	
		ORDER BY Departamento,IdPregunta
END
GO


IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Precargue Respuestas Seguimiento PAT' AND IdRecurso = 4)
BEGIN
	--SET IDENTITY_INSERT [dbo].[SubRecurso] ON	
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso]) VALUES (105, 'Precargue Respuestas Seguimiento PAT', NULL, 4)
	--SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[D_PrecargueSegxPreguntaMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[D_PrecargueSegxPreguntaMunicipio] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:   John Betancourt OIM
-- Modifica: 
-- Create date:		28/06/2018
-- Description:		Elimina todos los datos de la tabla
-- ==========================================================================================
ALTER PROC [PAT].[D_PrecargueSegxPreguntaMunicipio] 
		@IdEncuesta int
AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
	BEGIN TRY		
		if exists(select top 1 1  from  [PAT].[PreguntaPATPrecargueEntidadesNacionales])
		begin
			DECLARE @NumReg varchar(3)
			SELECT @NumReg = count(1) from [PAT].[PreguntaPATPrecargueEntidadesNacionales]
			SELECT @respuesta = 'Se han eliminado ' + @NumReg + ' registros'
			delete [PAT].[PreguntaPATPrecargueEntidadesNacionales]
			SELECT @estadoRespuesta = 3	
		end
		else	
		begin
			SELECT @respuesta = 'No se encontro ningun registro para eliminar'
			SELECT @estadoRespuesta = 0	
		end				
	END TRY
	BEGIN CATCH
		SELECT @respuesta = ERROR_MESSAGE()
		SELECT @estadoRespuesta = 0
	END CATCH	

select @respuesta as respuesta, @estadoRespuesta as estado

GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[PreguntaPATPrecargueEntidadesNacionales]')) 
BEGIN
	drop table [PAT].[PreguntaPATPrecargueEntidadesNacionales]
END
CREATE TABLE [PAT].[PreguntaPATPrecargueEntidadesNacionales](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdPreguntaPat] [smallint] NOT NULL,
	[IdMunicipio] [int] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[Presupuesto] [money] NOT NULL,
	[NumSeguimiento] [int] NOT NULL,
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
	@Cantidad INT,
	@Presupuesto MONEY,
	@NumSeguimiento INT	
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
           ,[Cantidad]
           ,[Presupuesto]
           ,[NumSeguimiento])
     VALUES
           (@IdPregunta
           ,@IdMunicipio
           ,@Cantidad
           ,@Presupuesto
           ,@NumSeguimiento)
		
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


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[PrecargueArchivosSeg]')) 
BEGIN
CREATE TABLE [PAT].[PrecargueArchivosSeg](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Titulo] [varchar](255) NOT NULL,
	[Archivo] [image] NULL,
 CONSTRAINT [PK_PrecargueArchivosSeg] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_PrecargueArchivosSegInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_PrecargueArchivosSegInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Author:   John Betancourt OIM
-- Modifica: 
-- Create date:		04/07/2018
-- Description:		Elimina todos los datos de la tabla
-- ==========================================================================================
ALTER  PROC [PAT].[I_PrecargueArchivosSegInsert]   
 @Titulo      VARCHAR(MAX),  
 @Archivo     IMAGE = NULL
 AS   
  
 BEGIN  
  -- Parámetros para el manejo de la respuesta  
  DECLARE @respuesta AS NVARCHAR(2000) = ''  
  DECLARE @estadoRespuesta  AS INT = 0  
  DECLARE @esValido AS BIT = 1  
  
  --Preguntar si una seccion puede repetir el nombre  
  IF(@esValido = 1)   
  BEGIN  
   BEGIN TRANSACTION  
   BEGIN TRY  
    -- Inserta la seccion  
    INSERT INTO [PAT].[PrecargueArchivosSeg]   
		([Titulo],[Archivo])  
    SELECT   
		@Titulo, @Archivo 
  
  
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
