IF  NOT EXISTS (select 1 from sys.columns where Name = N'IdRespuestaRC' and Object_ID = Object_ID(N'[PAT].[SeguimientoReparacionColectiva]'))
BEGIN
	BEGIN TRANSACTION
	   alter table [PAT].[SeguimientoReparacionColectiva]
		add IdRespuestaRC int not null default(1)

		ALTER TABLE [PAT].[SeguimientoReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_SeguimientoReparacionColectiva_RespuestaPATReparacionColectiva] FOREIGN KEY([IdRespuestaRC])
		REFERENCES [PAT].[RespuestaPATReparacionColectiva] ([Id])

		ALTER TABLE [PAT].[SeguimientoReparacionColectiva] CHECK CONSTRAINT [FK_SeguimientoReparacionColectiva_RespuestaPATReparacionColectiva]
	COMMIT
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoMunicipioReparacionColectiva]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoMunicipioReparacionColectiva] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Andrés Bonilla
-- Create date:		28/08/2017
-- Modified date:	25/01/2018
-- Modified date:	05/09/2018
-- Description:		Retorna el numero de seguimiento de acuerdo al momento en el que se llame el procedimiento
-- Modificacion:	Se agrega la columna IdRespuestaRC a la tabla SeguimientoReparacionColectiva para amarrar las respuestas a cada accion respondida y no por pregunta
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoMunicipioReparacionColectiva]--[PAT].[C_TableroSeguimientoMunicipioReparacionColectiva] 1 , 360
(
	@IdTablero INT
	,@IdUsuario INT
)
AS
BEGIN
	declare @IdMunicipio int
	select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

	SELECT 	DISTINCT 
	A.Sujeto
	, B.DESCRIPCION AS Medida
	,C.ACCION AS AccionMunicipio
	,C.PRESUPUESTO AS PresupuestoMunicipio
	,D.AccionDepartamento
	,D.PresupuestoDepartamento
	,A.ID AS IdPregunta
	,A.IdMunicipio
	,A.IdMedida
	,C.ID AS IdRespuesta
	,A.IdTablero
	,D.ID AS IdRespuestaDepartamento
	,A.IdDepartamento--,D.ID_ENTIDAD AS ID_ENTIDAD_DPTO	
	,SMRC.IdSeguimientoRC as IdSeguimiento
	,SMRC.AvancePrimer AS AvancePrimerSemestreAlcaldia
	,SMRC.AvanceSegundo AS AvanceSegundoSemestreAlcaldia
	,SGRC.AvancePrimer AS AvancePrimerSemestreGobernacion
	,SGRC.AvanceSegundo AS AvanceSegundoSemestreGobernacion
	,SMRC.NombreAdjunto AS NombreAdjunto
	FROM [PAT].PreguntaPATReparacionColectiva AS A
	INNER JOIN [PAT].Medida B ON B.ID = A.IdMedida
	LEFT OUTER JOIN [PAT].RespuestaPATReparacionColectiva AS C ON A.Id = C.IdPreguntaPATReparacionColectiva
	LEFT OUTER JOIN [PAT].[RespuestaPATDepartamentoReparacionColectiva] AS D ON D.IdPreguntaPATReparacionColectiva = A.Id  AND D.IdMunicipioRespuesta = C.IdMunicipio
	--LEFT OUTER JOIN [PAT].SeguimientoGobernacionReparacionColectiva as f on a.Id = f.IdPregunta and f.IdUsuario = @IdUsuario
	LEFT OUTER JOIN [PAT].SeguimientoReparacionColectiva SMRC ON SMRC.IdTablero = A.IdTablero AND SMRC.IdUsuario = @IdUsuario AND SMRC.IdRespuestaRC = C.Id --AND SMRC.IdPregunta = A.Id
	LEFT OUTER JOIN [PAT].SeguimientoGobernacionReparacionColectiva SGRC ON SGRC.IdTablero = A.IdTablero AND SGRC.IdPregunta = C.IdPreguntaPATReparacionColectiva AND SGRC.IdUsuarioAlcaldia = C.IdUsuario
	WHERE A.IdTablero = @IdTablero
	and A.IdMunicipio = @IdMunicipio
	AND A.Activo = 1
	order by a.Id	 
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_SeguimientoMunicipalRCInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_SeguimientoMunicipalRCInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez	- Andrés Bonilla																	  
/Fecha creacion: 2017-03-29																			  
/Fecha modificacion: 2018-09-05								
/Descripcion: Inserta la información del seguimeinto municipal de reparacion colectiva	
/Modificacion: Se agrega el parametro IdRespuestaRC para insertar la nueva columna											  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_SeguimientoMunicipalRCInsert] 
						@IdTablero tinyint
					   ,@IdPregunta smallint
					   ,@IdUsuario int
					   ,@AvancePrimer varchar(max)
					   ,@AvanceSegundo varchar(max)
					   ,@NombreAdjunto varchar(200)
					   ,@IdRespuestaRC int
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	
		
	if(@esValido = 1) 
	begin
		BEGIN TRY		
		
			INSERT INTO [PAT].[SeguimientoReparacionColectiva]
					   ([IdTablero]
					   ,[IdPregunta]
					   ,[IdUsuario]
					   ,[FechaSeguimiento]
					   ,[AvancePrimer]
					   ,[AvanceSegundo]
					   ,[NombreAdjunto]
					   ,[IdRespuestaRC])
				 VALUES
					   (@IdTablero
					   ,@IdPregunta 
					   ,@IdUsuario
					   ,GETDATE() 
					   ,@AvancePrimer 
					   ,@AvanceSegundo 
					   ,@NombreAdjunto
					   ,@IdRespuestaRC) 									
		
			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_SeguimientoMunicipalRCUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_SeguimientoMunicipalRCUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez		- Andrés Bonilla																  
/Fecha creacion: 2017-03-29
/Fecha modificacion: 2018-09-05																				  
/Descripcion: Inserta la información del seguimeinto municipal de reparacion colectiva											  
/Modificacion: Se agrega el parametro IdRespuestaRC para insertar la nueva columna											  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_SeguimientoMunicipalRCUpdate] 
				@IdSeguimiento int			   
			   ,@IdTablero tinyint
			   ,@IdPregunta smallint
			   ,@IdUsuario int			   
			   ,@AvancePrimer  varchar(max)
			   ,@AvanceSegundo varchar(max)
		       ,@NombreAdjunto varchar(200)
			   ,@IdRespuestaRC int
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	
		
	if(@esValido = 1) 
	begin
		BEGIN TRY			
			UPDATE [PAT].[SeguimientoReparacionColectiva]
			   SET [AvancePrimer] = @AvancePrimer
				  ,[AvanceSegundo] = @AvanceSegundo
				  ,[NombreAdjunto] = @NombreAdjunto
			where  IdSeguimientoRC = @IdSeguimiento
					
			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end
	select @respuesta as respuesta, @estadoRespuesta as estado			

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoAlcaldiasReparacionColectiva]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoAlcaldiasReparacionColectiva] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez - Andrés Bonilla
-- Create date:		14/11/2017
-- Modified date:	16/01/2018
-- Modified date:	05/09/2018
-- Description:		Obtiene las respuestas de las pregutnas de reparacion colectiva del diligenciamiento municipal
-- =============================================
ALTER PROCEDURE [PAT].[C_DatosExcelSeguimientoAlcaldiasReparacionColectiva] -- [PAT].[C_DatosExcelSeguimientoAlcaldiasReparacionColectiva] 411, 1
 (@IdUsuario INT, @IdTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON	
	
	declare @IdMunicipio int, @IdDepartamento int
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	
	SELECT DISTINCT 
	P.ID AS IdPregunta, 
	MUN.Divipola AS DaneMunicipio,
	MUN.Nombre AS Municipio,
	MUN.IdDepartamento,
	P.IdMedida, 
	P.Sujeto, 
	P.MedidaReparacionColectiva, 
	M.Descripcion AS Medida, 
	T.ID AS IdTablero,
	R.ID as IdRespuesta,
	SEGRC.AvancePrimer,
	SEGRC.AvanceSegundo		
	FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
	JOIN Municipio AS MUN ON P.IdMunicipio = MUN.Id
	LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] AS R ON P.ID= R.[IdPreguntaPATReparacionColectiva] AND R.[IdMunicipio] = @IdMunicipio
	LEFT OUTER JOIN PAT.SeguimientoReparacionColectiva AS SEGRC ON R.Id  = SEGRC.IdRespuestaRC AND SEGRC.IdUsuario =  @IdUsuario ,
	[PAT].[Medida] M,
	[PAT].[Tablero] T
	WHERE	P.IDMEDIDA = M.ID 
	AND P.[IdMunicipio] = @IdMunicipio
	AND P.IDTABLERO = T.ID
	AND T.ID = @IdTablero
	and P.Activo = 1
END

GO

IF  NOT EXISTS (select 1 from sys.columns where Name = N'IdRespuestaRC' and Object_ID = Object_ID(N'[PAT].[SeguimientoGobernacionReparacionColectiva]'))
BEGIN
	BEGIN TRANSACTION

	alter table [PAT].[SeguimientoGobernacionReparacionColectiva]
	add IdRespuestaRC int not null default(1)

	ALTER TABLE [PAT].[SeguimientoGobernacionReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_SeguimientoGobernacionReparacionColectiva_RespuestaPATDepartamentoReparacionColectiva] FOREIGN KEY([IdRespuestaRC])
	REFERENCES [PAT].[RespuestaPATDepartamentoReparacionColectiva] ([Id])

	ALTER TABLE [PAT].[SeguimientoGobernacionReparacionColectiva] CHECK CONSTRAINT [FK_SeguimientoGobernacionReparacionColectiva_RespuestaPATDepartamentoReparacionColectiva]

	COMMIT
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_SeguimientoDepartamentalRCInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_SeguimientoDepartamentalRCInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez	- Andrés Bonilla																	  
/Fecha creacion: 2017-03-29								
/Fecha modificacion: 2018-09-06								
/Descripcion: Inserta la información del seguimeinto departamental de reparacion colectiva												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_SeguimientoDepartamentalRCInsert] 
						@IdTablero tinyint
					   ,@IdPregunta smallint
					   ,@IdUsuario int
					   ,@IdUsuarioAlcaldia int
					   ,@AvancePrimer varchar(max)
					   ,@AvanceSegundo varchar(max)
					   ,@NombreAdjunto varchar(200)
					   ,@IdRespuestaRC int
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	
		
	if(@esValido = 1) 
	begin
		BEGIN TRY		
		
			INSERT INTO [PAT].[SeguimientoGobernacionReparacionColectiva]
					   ([IdTablero]
					   ,[IdPregunta]
					   ,[IdUsuario]
					   ,[IdUsuarioAlcaldia]
					   ,[FechaSeguimiento]
					   ,[AvancePrimer]
					   ,[AvanceSegundo]
					   ,[NombreAdjunto]
					   ,[IdRespuestaRC])
				 VALUES
					   (@IdTablero
					   ,@IdPregunta 
					   ,@IdUsuario
					   ,@IdUsuarioAlcaldia
					   ,GETDATE() 
					   ,@AvancePrimer 
					   ,@AvanceSegundo 
					   ,@NombreAdjunto
					   ,@IdRespuestaRC) 									
		
			select @id = SCOPE_IDENTITY()
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_SeguimientoGobernacionRCUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_SeguimientoGobernacionRCUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez - Andrés Bonilla																  
/Fecha creacion: 2017-03-29		
/Fecha modificacion: 2018-09-06																		  
/Descripcion: Inserta la información del seguimeinto municipal de retornos y reubicaciones											  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_SeguimientoGobernacionRCUpdate] 
				@IdSeguimiento int			   
			   ,@IdTablero tinyint
			   ,@IdPregunta smallint
			   ,@IdUsuario int			   
			   ,@AvancePrimer  varchar(max)
			   ,@AvanceSegundo varchar(max)
		       ,@NombreAdjunto varchar(200)
			   ,@IdRespuestaRC int
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1		
	declare @id int	
		
	if(@esValido = 1) 
	begin
		BEGIN TRY			
			UPDATE [PAT].[SeguimientoGobernacionReparacionColectiva]
			   SET [AvancePrimer] = @AvancePrimer
				  ,[AvanceSegundo] = @AvanceSegundo
				  ,[NombreAdjunto] = @NombreAdjunto
			where  IdSeguimientoRC = @IdSeguimiento
					
			SELECT @respuesta = 'Se ha modificado el registro'
			SELECT @estadoRespuesta = 2
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end
	select @respuesta as respuesta, @estadoRespuesta as estado			

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosSeguimientoDepartamentoReparacionColectiva]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosSeguimientoDepartamentoReparacionColectiva] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Andrés Bonilla
-- Create date:		25/09/2017
-- Modified date:	25/09/2017
-- Modified date:	06/09/2018
-- Description:		Obtiene informacion de una pregunta para un municipio de reparacion colectiva
-- =============================================
ALTER PROC  [PAT].[C_DatosSeguimientoDepartamentoReparacionColectiva]
( @IdUsuarioAlcaldia INT ,@idPregunta INT, @IdRespuestaRC INT )
AS
BEGIN	
		select  IdSeguimientoRC, IdTablero, IdPregunta, IdUsuario, IdUsuarioAlcaldia, FechaSeguimiento, AvancePrimer, AvanceSegundo,NombreAdjunto
		from PAT.SeguimientoGobernacionReparacionColectiva as A
		WHERE 	A.IdUsuarioAlcaldia = @IdUsuarioAlcaldia and IdPregunta = @idPregunta	and IdRespuestaRC = @IdRespuestaRC	
END

GO

IF  NOT EXISTS (select 1 from sys.columns where Name = N'IdRespuestaRCMunicipio' and Object_ID = Object_ID(N'[PAT].[RespuestaPATDepartamentoReparacionColectiva]'))
BEGIN
	BEGIN TRANSACTION

	alter table [PAT].[RespuestaPATDepartamentoReparacionColectiva]
	Add IdRespuestaRCMunicipio int not null default(1)

	ALTER TABLE [PAT].[RespuestaPATDepartamentoReparacionColectiva]  WITH CHECK ADD  CONSTRAINT [FK_RespuestaPATDepartamentoReparacionColectiva_RespuestaPATReparacionColectiva] FOREIGN KEY([IdRespuestaRCMunicipio])
	REFERENCES [PAT].[RespuestaPATReparacionColectiva] ([Id])

	ALTER TABLE [PAT].[RespuestaPATDepartamentoReparacionColectiva] CHECK CONSTRAINT [FK_RespuestaPATDepartamentoReparacionColectiva_RespuestaPATReparacionColectiva]

	COMMIT
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroDepartamentoReparacionColectiva]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroDepartamentoReparacionColectiva] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Andrés Bonilla
-- Create date:		25/07/2017
-- Modified date:	17/01/2018
-- Modified date:	06/09/2018
-- Description:		Obtiene el tablero para la gestión departamental de reparación colectiva
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroDepartamentoReparacionColectiva] --1, 20, 85279, 2
--[PAT].[C_TableroDepartamentoReparacionColectiva] 1, 20,11001,1
	(@page SMALLINT, @pageSize SMALLINT, @IdMunicipio INT, @idTablero tinyint)	
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @RESULTADO TABLE (
		Medida NVARCHAR(255),
		Sujeto NVARCHAR(300),
		MedidaReparacionColectiva NVARCHAR(2000),
		Id INT,
		IdTablero TINYINT,
		IdMunicipioRespuesta INT,
		IdDepartamento INT,
		IdPreguntaReparacionColectiva SMALLINT,
		Accion NVARCHAR(2000),
		Presupuesto MONEY,
		AccionDepartamento NVARCHAR(4000),
		PresupuestoDepartamento MONEY,
		Municipio  NVARCHAR(255),
		IdRespuestaMunicipioRC INT
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	
	DECLARE @PAGINA INT
	SET @PAGINA = (@page - 1) * @pageSize

	

	SET @SQL = '
	SELECT DISTINCT TOP (@TOP) 
					Medida,Sujeto,MedidaReparacionColectiva,Id,IdTablero,IdMunicipioRespuesta,IdDepartamento,IdPreguntaReparacionColectiva,
					Accion,Presupuesto,AccionDepartamento,PresupuestoDepartamento,Municipio,IdRespuestaMunicipioRC
					FROM ( 
						SELECT DISTINCT row_number() OVER (ORDER BY p.SUJETO) AS LINEA, 
							MEDIDA.Descripcion as Medida,
							p.Sujeto,
							p.MedidaReparacionColectiva,
							rcd.Id,
							p.IdTablero,
							p.IdMunicipio as IdMunicipioRespuesta,
							d.IdDepartamento, 
							p.Id as IdPreguntaReparacionColectiva,
							rc.Accion,
							rc.Presupuesto,
							rcd.AccionDepartamento,  
							rcd.PresupuestoDepartamento,
							d.Nombre as Municipio,
							rc.Id as IdRespuestaMunicipioRC
						FROM PAT.PreguntaPATReparacionColectiva p
						INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
						INNER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id		
						INNER join Municipio as d on p.IdMunicipio =d.Id and d.Id =@IdMunicipio
						LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc on p.Id = rc.IdPreguntaPATReparacionColectiva and rc.IdMunicipio= d.Id
						LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON rcd.IdMunicipioRespuesta= d.Id and rcd.IdPreguntaPATReparacionColectiva=p.Id and rcd.IdRespuestaRCMunicipio = rc.Id
						where TABLERO.Id = @idTablero and p.Activo = 1
					) AS P WHERE LINEA >@PAGINA 
					--and IdPreguntaReparacionColectiva > 2242 
					ORDER BY p.Sujeto'

		SET @PARAMETROS = '@TOP SMALLINT, @PAGINA SMALLINT, @IdMunicipio INT,@idTablero tinyint'

		PRINT @SQL
		PRINT @IdMunicipio
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @IdMunicipio= @IdMunicipio,@idTablero=@idTablero
		SELECT * from @RESULTADO
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_RespuestaDepartamentoRCInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_RespuestaDepartamentoRCInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- Vilma Rodriguez - Andrés Bonilla															  
/Fecha creacion: 2017-07-25																			  
/Fecha modificacion: 2018-09-06
/Descripcion: Inserta la información del tablero municipal para Reparacion colectiva												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_RespuestaDepartamentoRCInsert] 
				   @IdTablero tinyint,
				   @IdPreguntaPATReparacionColectiva smallint,
				   @AccionDepartamento nvarchar(1000),
				   @PresupuestoDepartamento money,
				   @IdMunicipioRespuesta int,
				   @IdUsuario int	
				   ,@IdRespuestaRCMunicipio int		
AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	
	
	declare @id int	
	
	if(@esValido = 1) 
	begin
		BEGIN TRY
			INSERT INTO [PAT].[RespuestaPATDepartamentoReparacionColectiva]
			   ([IdTablero]
			   ,[IdPreguntaPATReparacionColectiva]
			   ,[AccionDepartamento]
			   ,[PresupuestoDepartamento]
			   ,[IdMunicipioRespuesta]
			   ,[IdUsuario]
			   ,[FechaInsercion]
			   ,[IdRespuestaRCMunicipio])
			 VALUES (
				@IdTablero 
				,@IdPreguntaPATReparacionColectiva 
				,@AccionDepartamento 
				,@PresupuestoDepartamento 
				,@IdMunicipioRespuesta
				,@IdUsuario
				,getdate()
				,@IdRespuestaRCMunicipio
				)

				select @id = SCOPE_IDENTITY()
				SELECT @respuesta = 'Se ha ingresado el registro'
				SELECT @estadoRespuesta = 1
	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado, @id as id

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDepartamentoReparacionColectiva]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDepartamentoReparacionColectiva] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Andrés Bonilla
-- Create date:		29/08/2017
-- Modified date:	29/08/2017
-- Modified date:	06/09/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDepartamentoReparacionColectiva] --[PAT].[C_TableroSeguimientoDepartamentoReparacionColectiva] 1, 181
( @IdTablero INT ,@IdMunicipio INT )
AS
BEGIN	
		SELECT 
		DISTINCT 
		A.Sujeto
		, B.Descripcion AS Medida
		,C.Accion AS AccionMunicipio
		,C.Presupuesto AS PresupuestoMunicipio
		,D.AccionDepartamento
		,D.PresupuestoDepartamento
		,A.Id AS IdPregunta
		,A.IdMunicipio
		,A.IdMedida
		,C.Id AS IdRespuesta		
		,A.IdTablero
		,D.Id AS IdRespuestaDepartamento
		,U.IdDepartamento--,D.ID_ENTIDAD AS ID_ENTIDAD_DPTO
		FROM [PAT].PreguntaPATReparacionColectiva as A
		INNER JOIN [PAT].Medida as B ON B.Id = A.IdMedida
		LEFT OUTER JOIN [PAT].RespuestaPATReparacionColectiva as C ON C.IdPreguntaPATReparacionColectiva = A.Id
		LEFT OUTER JOIN [PAT].[RespuestaPATDepartamentoReparacionColectiva] as D ON D.IdPreguntaPATReparacionColectiva = A.Id AND C.Id = D.IdRespuestaRCMunicipio--AND D.ID_ENTIDAD_MUNICIPIO = C.ID_ENTIDAD
		left outer join Usuario as U on D.IdUsuario = U.Id
		WHERE A.IdTablero = @IdTablero
		and A.IdMunicipio = @IdMunicipio		
		and A.Activo = 1
		order by a.ID
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcel_GobernacionesReparacionColectiva]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcel_GobernacionesReparacionColectiva] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Andrés Bonilla
-- Create date:		21/07/2017
-- Modified date:	16/01/2018
-- Modified date:	06/09/2018
-- Description:		Obtiene toda la informacion correspondiente a la gobernbacion para reparacion colectiva  y tablero indicando en cuento a las respuestas que estos diligenciaron
-- ==========================================================================================

ALTER PROC [PAT].[C_DatosExcel_GobernacionesReparacionColectiva] --[PAT].[C_DatosExcel_GobernacionesReparacionColectiva] 375, 1
(	@IdUsuario INT, @IdTablero INT)
AS
BEGIN	

	Declare  @IdDepartamento int, @Departamento VARCHAR(100)
	
	select  @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario				
	
	select distinct MEDIDA.Descripcion as Medida,
			p.Sujeto,
			p.MedidaReparacionColectiva,
			rcd.Id,
			p.IdTablero,
			p.IdMunicipio as IdMunicipioRespuesta,
			@IdDepartamento as IdDepartamento, 
			p.Id as IdPreguntaReparacionColectiva,
			rc.Accion,
			rc.Presupuesto,
			rcd.AccionDepartamento,  
			rcd.PresupuestoDepartamento,
			d.Id as IdDane,
			d.Nombre as Municipio
		FROM PAT.PreguntaPATReparacionColectiva p
		INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
		INNER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id		
		INNER join Municipio as d on p.IdMunicipio =d.Id and d.IdDepartamento =@IdDepartamento
		LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc on p.Id = rc.IdPreguntaPATReparacionColectiva and rc.IdMunicipio= d.Id
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON rcd.IdMunicipioRespuesta= d.Id and rcd.IdPreguntaPATReparacionColectiva=p.Id and rcd.IdRespuestaRCMunicipio = rc.Id
		where TABLERO.Id = @IdTablero and p.Activo = 1
		order by Sujeto																

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldiasRC]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldiasRC] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Andrés Bonilla
-- Create date:		29/08/2017
-- Modified date:	10/12/2017
-- Modified date:	06/09/2018
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC  [PAT].[C_DatosExcelSeguimientoGobernacionAlcaldiasRC] --[PAT].[C_DatosExcelSeguimientoGobernacionAlcaldiasRC] 5 , 1
(@IdDepartamento INT,@IdTablero INT)
AS
BEGIN	
		SELECT DISTINCT 		
		m.Descripcion Medida,
		p.Sujeto,
		p.MedidaReparacionColectiva,
		rcd.Id,
		p.IdTablero,
		rcd.IdMunicipioRespuesta,		
		p.Id as IdPreguntaRC,
		rc.Accion,
		rc.Presupuesto,
		rcd.AccionDepartamento,
		rcd.PresupuestoDepartamento
		,p.IdMunicipio
		,e.Nombre as Municipio
		,SMRC.AvancePrimer AS AvancePrimerSemestreAlcaldia
		,SMRC.AvanceSegundo AS AvanceSegundoSemestreAlcaldia
		,SGRC.AvancePrimer AS AvancePrimerSemestreGobernacion
		,SGRC.AvanceSegundo AS AvanceSegundoSemestreGobernacion
		FROM PAT.PreguntaPATReparacionColectiva p
		INNER JOIN PAT.Medida m ON p.IdMedida = m.Id
		INNER JOIN Municipio  e on e.Id = p.IdMunicipio and e.IdDepartamento = @IdDepartamento
		LEFT OUTER JOIN PAT.RespuestaPATReparacionColectiva rc ON rc.IdMunicipio = e.Id and rc.IdPreguntaPATReparacionColectiva=p.Id
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON rcd.IdMunicipioRespuesta = e.Id and rcd.IdPreguntaPATReparacionColectiva=p.Id
		LEFT OUTER JOIN [PAT].SeguimientoReparacionColectiva SMRC ON SMRC.IdTablero = p.IdTablero AND SMRC.IdUsuario = rc.IdUsuario AND SMRC.IdPregunta = rc.IdPreguntaPATReparacionColectiva
		LEFT OUTER JOIN [PAT].SeguimientoGobernacionReparacionColectiva SGRC ON SGRC.IdTablero = p.IdTablero AND SGRC.IdPregunta = RC.IdPreguntaPATReparacionColectiva AND SGRC.IdUsuarioAlcaldia = rc.IdUsuario and SGRC.IdRespuestaRC = rcd.Id
		where p.IdTablero = @IdTablero 		and p.Activo  = 1					
		ORDER BY p.Sujeto 	
END

GO