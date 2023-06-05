if not exists (select * from sys.columns where name='RequiereAdjunto' and Object_id in (select object_id from sys.tables where name ='PreguntaPAT'))
begin 
	ALTER TABLE [PAT].[PreguntaPAT] ADD RequiereAdjunto bit null
	ALTER TABLE [PAT].[PreguntaPAT] ADD MensajeAdjunto varchar(max) null
	ALTER TABLE [PAT].[PreguntaPAT] ADD ExplicacionPregunta varchar(max) null
end

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_PreguntaPatInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_PreguntaPatInsert] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-29																			  
/Descripcion: Inserta la información del tablero municipal												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_PreguntaPatInsert] 

		@IdDerecho			SMALLINT,
		@IdComponente		INT,
		@IdMedida			INT,
		@Nivel				TINYINT,
		@PreguntaIndicativa NVARCHAR(500),
		@IdUnidadMedida		TINYINT,
		@PreguntaCompromiso NVARCHAR(500),
		@ApoyoDepartamental BIT,
		@ApoyoEntidadNacional BIT,
		@Activo				BIT,
		@IdTablero			TINYINT,
		@IdsNivel			NVARCHAR(MAX),
		@RequiereAdjunto	BIT,
		@MensajeAdjunto     NVARCHAR(MAX),
		@ExplicacionPregunta     NVARCHAR(MAX)
			
AS 	
	
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	DECLARE @esValido AS BIT = 1	
	DECLARE @id INT	
	
	IF(@esValido = 1) 
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
			INSERT INTO [PAT].[PreguntaPAT]
					   ([IdDerecho]
					   ,[IdComponente]
					   ,[IdMedida]
					   ,[Nivel]
					   ,[PreguntaIndicativa]
					   ,[IdUnidadMedida]
					   ,[PreguntaCompromiso]
					   ,[ApoyoDepartamental]
					   ,[ApoyoEntidadNacional]
					   ,[Activo]
					   ,[IdTablero]
					   ,RequiereAdjunto
					   ,MensajeAdjunto
					   ,ExplicacionPregunta)
				 VALUES
					   (@IdDerecho ,
					   @IdComponente ,
					   @IdMedida ,
					   @Nivel ,
					   @PreguntaIndicativa ,
					   @IdUnidadMedida ,
					   @PreguntaCompromiso,
					   @ApoyoDepartamental ,
					   @ApoyoEntidadNacional ,
					   @Activo ,
					   @IdTablero,
					   @RequiereAdjunto,
					   @MensajeAdjunto,
					   @ExplicacionPregunta )

			SELECT @id = SCOPE_IDENTITY()

			--============================================================================================================
			-- Nivel 1 = Nacional, Nivel 2 = Departamentos, Nivel 3 = Municipios

			-- De acuerdo al nivel ejecuta el cursor que hace lo siguiente:

			-- Hace un rompimiento en la variable @IdsNivel tipo varchar y la separa de acuerdo a las comas (,). trae
			-- los municipios o los departamentos de acuerdo al nivel de la pregunta, realiza la inserción de los Id's en 
			-- la tabla departamentos-pregunta o municipios-pregunta. En caso que el nivel sea 3, no hace nada.
			--=============================================================================================================

			DECLARE @IdNivel INT
			DECLARE Nivel_Cursor CURSOR FOR  

				SELECT 
					splitdata 
				FROM 
					[dbo].[Split](@IdsNivel, ',')

			OPEN Nivel_Cursor 

			FETCH NEXT FROM Nivel_Cursor 
			INTO @IdNivel 

			WHILE @@FETCH_STATUS = 0  
				BEGIN  
					--========================================
					-- Inserta los departamentos relacionados
					--========================================
					IF(@Nivel = 2)
						BEGIN
							INSERT INTO [PAT].[C_DepartamentosXPregunta]([IdPreguntaPAT],[IdDepartamento])
							VALUES (@id, @IdNivel)
						END
					--========================================
					-- Inserta los municipios relacionados
					--========================================
					ELSE IF(@Nivel = 3)	
						BEGIN
							INSERT INTO [PAT].[PreguntaPATMunicipio]([IdPreguntaPAT],[IdMunicipio])
							VALUES (@id, @IdNivel)
						END
						
					FETCH NEXT FROM Nivel_Cursor 
					INTO @IdNivel 

				END; 
					    
			CLOSE Nivel_Cursor;  
			DEALLOCATE Nivel_Cursor; 
			
			--===================================================================
			COMMIT TRANSACTION
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1
			
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado, @id AS id

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_PreguntaPatUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_PreguntaPatUpdate] AS'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************
/Autor: Equipo OIM																			  
/Fecha creacion: 2017-07-29																			  
/Descripcion: Actualiza la información de las preguntas 
/Retorna: SELECT @respuesta AS respuesta, @estadoRespuesta AS estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_PreguntaPatUpdate] 

		@Id						INT,
		@IdDerecho				SMALLINT,
		@IdComponente			INT,
		@IdMedida				INT,
		@Nivel					TINYINT,
		@PreguntaIndicativa		NVARCHAR(500),
		@IdUnidadMedida			TINYINT,
		@PreguntaCompromiso		NVARCHAR(500),
		@ApoyoDepartamental		BIT,
		@ApoyoEntidadNacional	BIT,
		@Activo					BIT,
		@IdTablero				TINYINT,
		@IdsNivel				NVARCHAR(MAX),
		@Incluir				BIT,
		@RequiereAdjunto		BIT,
		@MensajeAdjunto			NVARCHAR(MAX),
		@ExplicacionPregunta    NVARCHAR(MAX)

AS 	
	
	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	DECLARE @esValido AS BIT = 1
	DECLARE @idPregunta INT

	SELECT @idPregunta = r.ID FROM [PAT].[PreguntaPAT] AS r
	WHERE r.Id = @Id 
	ORDER BY r.ID

	if (@idPregunta IS NULL)
		BEGIN
			SET @esValido = 0
			SET @respuesta += 'No se encontro la respuesta.\n'
		END

	DECLARE @IdTableroActual INT
	DECLARE @IdRespuesta INT
	DECLARE @IdRespuestaDept INT

	SELECT @IdTableroActual =IdTablero FROM [PAT].PreguntaPAT WHERE Id = @Id  

	if ( @IdTablero <> @IdTableroActual)
		BEGIN
			SELECT TOP 1 @IdRespuesta = Id FROM [PAT].[RespuestaPAT] WHERE [IdPreguntaPAT] =@Id  
			SELECT TOP 1 @IdRespuestaDept = Id FROM [PAT].[RespuestaPATDepartamento] WHERE [IdPreguntaPAT] =@Id  
		
			IF (@IdRespuesta >0 or @IdRespuestaDept >0)
			BEGIN
				SET @esValido = 0
				SET @respuesta += 'No se puede cambiar el tablero ya se se encuentran respuestas asociadas.\n'
			END
		END

	IF(@esValido = 1) 
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION
					UPDATE 
						[PAT].[PreguntaPAT]
					SET 
						IdDerecho			= @IdDerecho,
						IdComponente		= @IdComponente,
						IdMedida			= @IdMedida,
						Nivel				= @Nivel,
						PreguntaIndicativa	= @PreguntaIndicativa,
						IdUnidadMedida		= @IdUnidadMedida,
						PreguntaCompromiso	= @PreguntaCompromiso,
						ApoyoDepartamental	= @ApoyoDepartamental,
						ApoyoEntidadNacional = @ApoyoEntidadNacional,
						Activo				= @Activo,
						IdTablero			= @IdTablero,
						RequiereAdjunto	    = @RequiereAdjunto,
						MensajeAdjunto		= @MensajeAdjunto,
						ExplicacionPregunta	= @ExplicacionPregunta
					WHERE  
						ID = @Id 

					--============================================================================================================
					-- Nivel 1 = Nacional, Nivel 2 = Departamentos, Nivel 3 = Municipios

					-- De acuerdo al nivel ejecuta el cursor que hace lo siguiente:

					-- Hace un rompimiento en la variable @IdsNivel tipo varchar y la separa de acuerdo a las comas (,). trae
					-- los municipios o los departamentos de acuerdo al nivel de la pregunta, realiza la inserción de los Id's en 
					-- la tabla departamentos-pregunta o municipios-pregunta. En caso que el nivel sea 3, no hace nada.
					-- Si la variable @Incluir viene en falso lo que hace es retirar los items de la tabla
					--=============================================================================================================

					DECLARE @IdNivel INT
					DECLARE Nivel_Cursor CURSOR FOR  

						SELECT 
							splitdata 
						FROM 
							[dbo].[Split](@IdsNivel, ',')

					OPEN Nivel_Cursor 

					FETCH NEXT FROM Nivel_Cursor 
					INTO @IdNivel 

					WHILE @@FETCH_STATUS = 0  
						BEGIN  
							--========================================
							-- Inserta los departamentos relacionados
							--========================================
							IF(@Incluir = 1 AND @Nivel = 2)
								BEGIN
									INSERT INTO [PAT].[PreguntaPATDepartamento]([IdPreguntaPAT],[IdDepartamento])
									VALUES (@id, @IdNivel)
								END
							--========================================
							-- Inserta los municipios relacionados
							--========================================
							ELSE IF(@Incluir = 1 AND @Nivel = 3)	
								BEGIN
									INSERT INTO [PAT].[PreguntaPATMunicipio]([IdPreguntaPAT],[IdMunicipio])
									VALUES (@id, @IdNivel)
								END

							--========================================
							-- Retira los departamentos relacionados
							--========================================
							ELSE IF(@Incluir = 0 AND @Nivel = 2)
								BEGIN
									DELETE [PAT].[PreguntaPATDepartamento]
									WHERE [IdDepartamento] = @IdNivel
									AND [IdPreguntaPAT] = @Id
								END
							--========================================
							-- Retira los municipios relacionados
							--========================================
							ELSE IF(@Incluir = 0 AND @Nivel = 3)	
								BEGIN
									DELETE [PAT].[PreguntaPATMunicipio]
									WHERE [IdMunicipio] = @IdNivel
									AND [IdPreguntaPAT] = @Id
								END
						
							FETCH NEXT FROM Nivel_Cursor 
							INTO @IdNivel 

						END; 
					    
					CLOSE Nivel_Cursor;  
					DEALLOCATE Nivel_Cursor; 
			
					--================================================================================
					-- Valida que la pregunta haya quedado relacionada con municipios o departamentos
					-- de lo contrario hace el rollback y muestra el mensaje al usuario.
					--================================================================================
					IF(((SELECT COUNT(Id) FROM [PAT].[PreguntaPATDepartamento] WHERE [IdPreguntaPAT] = @idPregunta) = 0) 
					   AND ((SELECT COUNT(Id) FROM [PAT].[PreguntaPATMunicipio] WHERE [IdPreguntaPAT] = @idPregunta) = 0))
						BEGIN
							ROLLBACK TRANSACTION
							SELECT @respuesta = 'Es necesario dejar relacionado como mínimo un '+(SELECT CASE @Nivel WHEN 2 THEN 'Departamento' WHEN 3 THEN 'Municipio' END)+' a la pregunta'
							SELECT @estadoRespuesta = 0
						END
					ELSE
						BEGIN
							COMMIT TRANSACTION
							SELECT @respuesta = 'Se ha modificado el registro'
							SELECT @estadoRespuesta = 2
						END									
			END TRY
			BEGIN CATCH
				ROLLBACK TRANSACTION
				SELECT @respuesta = ERROR_MESSAGE()
				SELECT @estadoRespuesta = 0
			END CATCH
		END

	SELECT @respuesta AS respuesta, @estadoRespuesta AS estado			

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_PreguntasPat]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_PreguntasPat] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	12/11/2017
-- Description:		Obtiene las preguntas del PAT para la rejilla
-- =============================================
ALTER PROCEDURE [PAT].[C_PreguntasPat] --[PAT].[C_PreguntasPat] 4,3
			  @IdTablero int ,
			  @Nivel tinyint 
AS
BEGIN
	SET NOCOUNT ON;	
	if @IdTablero =0
		SELECT P.Id,
		P.IdDerecho, P.IdComponente, P.IdMedida, 
		M.Descripcion as Medida,
		P.PreguntaIndicativa, 
		UM.Descripcion as UnidadMedida,
		P.PreguntaCompromiso, 
		d.Descripcion as Derecho, 
		C.Descripcion as Componente,
		P.Nivel, 
		P.IdTablero,
		P.Activo,				
		P.IdUnidadMedida, 
		P.ApoyoDepartamental, 
		P.ApoyoEntidadNacional,
		P.RequiereAdjunto,
		P.MensajeAdjunto,
		P.ExplicacionPregunta		
		FROM    [PAT].[PreguntaPAT] as P, 
		[PAT].[Derecho] D,
		[PAT].[Componente] C,
		[PAT].[Medida] M,
		[PAT].[UnidadMedida] UM
		WHERE P.IDDERECHO = D.ID 
		AND P.IDCOMPONENTE = C.ID 
		AND P.IDMEDIDA = M.ID 
		AND P.IDUNIDADMEDIDA = UM.ID	
	else
		SELECT P.Id,
		P.IdDerecho, P.IdComponente, P.IdMedida, 
		M.Descripcion as Medida,
		P.PreguntaIndicativa, 
		UM.Descripcion as UnidadMedida,
		P.PreguntaCompromiso, 
		d.Descripcion as Derecho, 
		C.Descripcion as Componente,
		P.Nivel, 
		P.IdTablero,
		P.Activo,				
		P.IdUnidadMedida, 
		P.ApoyoDepartamental, 
		P.ApoyoEntidadNacional,
		P.RequiereAdjunto,
		P.MensajeAdjunto,
		P.ExplicacionPregunta		
		FROM    [PAT].[PreguntaPAT] as P, 
		[PAT].[Derecho] D,
		[PAT].[Componente] C,
		[PAT].[Medida] M,
		[PAT].[UnidadMedida] UM
		WHERE P.IDDERECHO = D.ID 
		AND P.IDCOMPONENTE = C.ID 
		AND P.IDMEDIDA = M.ID 
		AND P.IDUNIDADMEDIDA = UM.ID 	
		and P.IdTablero = @IdTablero and P.Nivel = @Nivel
END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ListadoAdministracionTableros]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ListadoAdministracionTableros] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	13/11/2017
-- Description:		Procedimiento que trae el listado de todos los tableros para su administracion 
-- =============================================
ALTER PROCEDURE [PAT].[C_ListadoAdministracionTableros]	
AS
BEGIN
	SET NOCOUNT ON;
	SELECT tf.Id, tf.IdTablero, YEAR(tf.VigenciaInicio)+1 as anoTablero, tf.Nivel, case when tf.Nivel =1 then 'Nacional'  when tf.Nivel =2 then 'Departamental' else 'Municipal' end as NombreNivel ,
	tf.VigenciaInicio, tf.VigenciaFin, Activo, tf.Seguimiento1Inicio, tf.Seguimiento1Fin, tf.Seguimiento2Inicio, tf.Seguimiento2Fin
	FROM PAT.TableroFecha as tf 	
	order by tf.IdTablero, tf.Nivel desc
END

go
---preguntas nivel municipio---
INSERT INTO [PAT].[PreguntaPATMunicipio]([IdPreguntaPAT],[IdMunicipio])
select P.Id, m.Id from [PAT].[PreguntaPAT] as P
join Municipio as m on 1 = 1
where P.Activo = 1 and P.IdTablero in (1,2)

go
---preguntas nivel departamento---
INSERT INTO [PAT].[PreguntaPATDepartamento]([IdPreguntaPAT],[IdDepartamento])
select P.Id, m.Id from [PAT].[PreguntaPAT] as P
join Departamento as m on 1 = 1
where P.Activo = 1 and P.IdTablero in (1,2)

GO
-- ============================================= GESTION MUNICIPAL =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroMunicipio] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	13/11/2017
-- Description:		Trae el listado de todas las preguntas municipales del tablero, derecho y municipio indicado  
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroMunicipio] --[PAT].[C_TableroMunicipio] null, 1, 20, 411 , 1,3
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		IDPREGUNTA SMALLINT,IDDERECHO SMALLINT,IDCOMPONENTE TINYINT,IDMEDIDA SMALLINT,NIVEL TINYINT,
		PREGUNTAINDICATIVA NVARCHAR(500),IDUNIDADMEDIDA TINYINT,PREGUNTACOMPROMISO NVARCHAR(500),APOYODEPARTAMENTAL BIT,
		APOYOENTIDADNACIONAL BIT,ACTIVO BIT,DERECHO NVARCHAR(50),COMPONENTE NVARCHAR(100),MEDIDA NVARCHAR(50),
		UNIDADMEDIDA NVARCHAR(100),IDTABLERO TINYINT,IDENTIDAD INT,ID INT,RESPUESTAINDICATIVA INT,
		RESPUESTACOMPROMISO INT,PRESUPUESTO MONEY,OBSERVACIONNECESIDAD NVARCHAR(1000),ACCIONCOMPROMISO NVARCHAR(1000), 
		RequiereAdjunto bit,MensajeAdjunto NVARCHAR(max),ExplicacionPregunta NVARCHAR(max)
		)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize 

	SET @ORDEN = @sortOrder
	SET @ORDEN = 'P.ID'
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	Declare @IdMunicipio int
	SELECT @IdMunicipio =  U.[IdMunicipio] FROM [dbo].[Usuario] (NOLOCK) U WHERE U.ID = @IdUsuario
	
	SET @SQL = 'SELECT 	
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO,
		RequiereAdjunto,MensajeAdjunto,ExplicacionPregunta
		FROM (
		SELECT DISTINCT TOP (@TOP) LINEA,
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO,
		RequiereAdjunto,MensajeAdjunto,ExplicacionPregunta
	FROM ( 
    SELECT DISTINCT row_number() OVER (ORDER BY '+ @ORDEN +') AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID ,
						R.RespuestaIndicativa, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO,
						P.RequiereAdjunto,
						P.MensajeAdjunto,
						P.ExplicacionPregunta
				FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdMunicipio =  @IdMunicipio ,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T,
						[PAT].[PreguntaPATMunicipio] as PM
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND P.ID = PM.IdPreguntaPAT and PM.IdMunicipio = @IdMunicipio
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 					
					AND D.ID = @IdDerecho'	
	SET @SQL =@SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY LINEA ) AS T'
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IdMunicipio INT,@IdDerecho INT'
		
	--PRINT @SQL
	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IdMunicipio=@IdMunicipio, @IdDerecho=@IdDerecho
	SELECT * from @RESULTADO
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ContarTableroMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ContarTableroMunicipio] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	13/11/2017
-- Description:		Trae el conteo para la paginacion del listado de todas las preguntas municipales del tablero, derecho y municipio indicado  
-- =============================================
ALTER PROCEDURE [PAT].[C_ContarTableroMunicipio] --[PAT].[C_ContarTableroMunicipio] 411, 1,2
(@IdUsuario INT, @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
    DECLARE @Cantidad INT, @ID_ENTIDAD INT

	Declare @IdMunicipio int
	SELECT @IdMunicipio =  U.[IdMunicipio] FROM [dbo].[Usuario] (NOLOCK) U WHERE U.ID = @IdUsuario

	SELECT @Cantidad = COUNT(1)
	FROM ( 
		       SELECT DISTINCT
						P.ID AS IDPREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID ,
						R.RespuestaIndicativa, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO
				FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdMunicipio =  @IdMunicipio ,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T,
						[PAT].[PreguntaPATMunicipio] as PM
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND P.ID = PM.IdPreguntaPAT and PM.IdMunicipio = @IdMunicipio
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 					
					AND D.ID = @IdDerecho
					) as P
	
	SELECT @Cantidad
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ContarTableroMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_ContarTableroMunicipio] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene los porcentajes de avance de la gestión del tablero PAT por municipio
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroMunicipioAvance] --[PAT].[C_TableroMunicipioAvance] 411,2
		@IdUsuario INT, @idTablero tinyint
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		DERECHO NVARCHAR(50),
		PINDICATIVA INT,
		PCOMPROMISO INT
		)
	
	Declare @IdMunicipio int
	SELECT @IdMunicipio =  U.[IdMunicipio] FROM [dbo].[Usuario] (NOLOCK) U WHERE U.ID = @IdUsuario


	SELECT	D.DESCRIPCION AS DERECHO, 
			SUM(case when R.RESPUESTAINDICATIVA IS NULL or R.RESPUESTAINDICATIVA=0 then 0 else 1 end)*100/count(*) PINDICATIVA,
			SUM(case when R.RESPUESTACOMPROMISO IS NULL or R.RESPUESTACOMPROMISO=0 then 0 else 1 end)*100/count(*) PCOMPROMISO
	FROM    [PAT].[PreguntaPAT] (NOLOCK) AS P
	join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
	INNER JOIN [PAT].[Derecho] (NOLOCK) D ON P.IDDERECHO = D.ID 
	INNER JOIN PAT.Tablero (NOLOCK) AS T ON P.IDTABLERO = T.ID				
	LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON R.IdMunicipio = @IdMunicipio  and P.ID = R.[IdPreguntaPAT]
	WHERE	P.NIVEL = @NIVEL 
	AND T.ID = @idTablero
	and P.ACTIVO = 1	
	group by D.DESCRIPCION
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_Derechos]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_Derechos] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene los derechos de un tablero que tienen preguntas activas asociadas
-- =============================================
ALTER PROC [PAT].[C_Derechos] ( @idTablero tinyint,@IdUsuario INT)--[PAT].[C_Derechos] 2,411
AS
BEGIN
	Declare @IdMunicipio int
	SELECT @IdMunicipio =  U.[IdMunicipio] FROM [dbo].[Usuario] (NOLOCK) U WHERE U.ID = @IdUsuario

	IF (@IdUsuario = 0) --DEBE TRAER TODOS LOS DERECHOS QUE ESTEN ASOCIADOS A PREGUNTAS DEL TABLERO INDICADO
	BEGIN
		SELECT DISTINCT D.ID, D.DESCRIPCION
		FROM [PAT].[Derecho] D
		JOIN PAT.PreguntaPAT AS P ON D.Id = P.IdDerecho
		WHERE P.IdTablero = @idTablero and p.Activo = 1			
		ORDER BY D.Descripcion
	END
	ELSE --TRAE SOLO LOS DERECHOS DE PREGUNTAS ASOCIADAS AL MUNICIPIO DEL TABLERO INDICADO
	BEGIN
		SELECT DISTINCT D.ID, D.DESCRIPCION
		FROM [PAT].[Derecho] D
		JOIN PAT.PreguntaPAT AS P ON D.Id = P.IdDerecho
		join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		WHERE P.IdTablero = @idTablero and p.Activo = 1			
		ORDER BY D.Descripcion
	END
END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcel_Municipios]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcel_Municipios] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene los datos a exportar de la gestion municipal del los derechos para las preguntas del municipio indicado
-- =============================================
ALTER PROC [PAT].[C_DatosExcel_Municipios] --[PAT].[C_DatosExcel_Municipios] 5172, 2
	(@IdMunicipio INT, @IdTablero INT)
AS
BEGIN
	SELECT 
	DISTINCT  
	LINEA
	,IDPREGUNTA AS ID
	, '' AS ENTIDAD
	,DERECHO
	,COMPONENTE
	,MEDIDA
	,PREGUNTAINDICATIVA
	,PREGUNTACOMPROMISO
	,UNIDADMEDIDA
	,RESPUESTAINDICATIVA
	,OBSERVACIONNECESIDAD
	,RESPUESTACOMPROMISO
	,ACCIONCOMPROMISO AS OBSERVACIONCOMPROMISO
	,CONVERT(FLOAT, PRESUPUESTO) AS PRESUPUESTO
	,ACCION
	,PROGRAMA
		FROM ( 
			SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
							P.ID AS IDPREGUNTA, 
							P.IDDERECHO, 
							P.IDCOMPONENTE, 
							P.IDMEDIDA, 
							P.NIVEL, 
							P.PREGUNTAINDICATIVA, 
							P.IDUNIDADMEDIDA, 
							P.PREGUNTACOMPROMISO, 
							P.APOYODEPARTAMENTAL, 
							P.APOYOENTIDADNACIONAL, 
							P.ACTIVO, 
							D.DESCRIPCION AS DERECHO, 
							C.DESCRIPCION AS COMPONENTE, 
							M.DESCRIPCION AS MEDIDA, 
							UM.DESCRIPCION AS UNIDADMEDIDA,	
							R.ID AS IDTABLERO,						
							CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
							R.ID as id_respuesta,
							R.RESPUESTAINDICATIVA, 
							R.RESPUESTACOMPROMISO, 
							R.PRESUPUESTO,
							R.OBSERVACIONNECESIDAD,
							R.ACCIONCOMPROMISO
							,AA.ACCION
							,AP.PROGRAMA
					FROM    [PAT].[PreguntaPAT] AS P
					join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
					INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
					INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
					INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
					INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
					INNER JOIN PAT.Tablero AS T ON P.IDTABLERO = T.ID
					LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] and  R.IdMunicipio = @IdMunicipio 									
					LEFT OUTER JOIN [PAT].[RespuestaPATAccion] AS AA ON AA.[IdRespuestaPAT] = R.ID and AA.Activo = 1
					LEFT OUTER JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
					INNER JOIN Usuario AS U ON R.IdUsuario = U.Id  AND U.IdMunicipio = @IdMunicipio
					WHERE  T.ID = @IdTablero 
					and	P.NIVEL = 3 					
				) AS A 
				WHERE A.ACTIVO = 1  
				ORDER BY IDPREGUNTA

END
GO
-- =============================================SEGUIMIENTO GESTION MUNICIPAL =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoMunicipioAvance]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoMunicipioAvance] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Liliana Rodriguez
-- Create date:		28/08/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene los porcentajes de avance del seguimiento de la gestión del tablero PAT por municipio 
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoMunicipioAvance]--[PAT].[C_TableroSeguimientoMunicipioAvance] 411, 1
( @IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare @IdMunicipio int
	select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

	SELECT 	A.Derecho
	,ISNULL(CONVERT(INT, CASE WHEN ROUND(CASE A.rc WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.rc)) * 100) END, 0) > 100 THEN 100 ELSE ROUND(CASE A.rc WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.rc)) * 100) END, 0) END),0) AS AvanceCompromiso
	,ISNULL(CONVERT(INT, CASE WHEN ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0) > 100 THEN 100 ELSE ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0) END),0) AS AvancePresupuesto
	FROM
	(
		SELECT	D.Descripcion AS Derecho
		,SUM(C.PresupuestoPrimer) as p1
		,SUM(C.PresupuestoSegundo) as p2
		,SUM(case when R.RespuestaIndicativa is null then 0 else r.RespuestaIndicativa end) as ri
		,SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end) as rc
		,SUM(case when R.Presupuesto is null then 0 else r.Presupuesto end) as pres
		,(SUM(case when C.CantidadPrimer is null or C.CantidadPrimer = -1 then 0 else C.CantidadPrimer end) + SUM(case when C.CantidadSegundo is null or C.CantidadSegundo = -1 then 0 else C.CantidadSegundo end)) as sumc1c2
		,(SUM(case when C.PresupuestoPrimer is null or C.PresupuestoPrimer = -1 then 0 else C.PresupuestoPrimer end) + SUM(case when C.PresupuestoSegundo is null or C.PresupuestoSegundo = -1 then 0 else C.PresupuestoSegundo end)) as sump1p2
		FROM [PAT].[PreguntaPAT] (NOLOCK) AS P
		join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		INNER JOIN [PAT].[Derecho] (NOLOCK) D ON P.IDDERECHO = D.ID 
		INNER JOIN PAT.Tablero (NOLOCK) AS T ON P.IDTABLERO = T.ID				
		LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON R.IdMunicipio = @IdMunicipio  and P.ID = R.[IdPreguntaPAT]	
		LEFT OUTER JOIN [PAT].Seguimiento as C ON C.IdPregunta = P.Id and C.IdUsuario = @IdUsuario
		WHERE	P.NIVEL = 3 
		AND T.ID = @idTablero
		and P.ACTIVO = 1		
		group by D.Descripcion
	) AS A
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoMunicipio] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		28/08/2017
-- Modified date:	13/11/2017
-- Description:		Retorna el numero de seguimiento de acuerdo al momento en el que se llame el procedimiento
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoMunicipio] --[PAT].[C_TableroSeguimientoMunicipio] 1, 1, 411
(	@IdDerecho INT
	,@IdTablero INT
	,@IdUsuario INT
)
AS
BEGIN

		declare @IdMunicipio int
		select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

		select 
		e.Descripcion as Derecho
		,b.Descripcion as Componente
		,c.Descripcion as Medida
		,a.PreguntaIndicativa
		,d.Descripcion as Unidad
		,a.PreguntaCompromiso
		,ISNULL(f.IdSeguimiento, 0) as IdSeguimiento
		,ISNULL(f.CantidadPrimer, -1) as CompromisoPrimerSemestre
		,ISNULL(f.CantidadSegundo, -1) as CompromisoSegundoSemestre
		,ISNULL(f.CantidadPrimer + REPLACE(f.CantidadSegundo, -1, 0), -1) as CompromisoTotal
		,ISNULL(f.PresupuestoPrimer, -1) as PresupuestoPrimerSemestre
		,ISNULL(f.PresupuestoSegundo, -1) as PresupuestoSegundoSemestre
		,ISNULL(f.PresupuestoPrimer + REPLACE(f.PresupuestoSegundo, -1, 0), -1) as PresupuestoTotal
		,a.ID 
		,a.IdComponente 
		,a.IdDerecho 
		,a.IdMedida 
		,a.IdUnidadMedida
		,ISNULL(R.RespuestaCompromiso, 0) AS RespuestaIndicativa
		,ISNULL(R.Presupuesto, 0) AS Presupuesto
		from [PAT].PreguntaPAT AS a
		join [PAT].[PreguntaPATMunicipio] as PM on a.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		inner join [PAT].Componente AS b on b.ID = a.IdComponente
		inner join [PAT].Medida AS c on c.ID = a.IdMedida
		inner join [PAT].UnidadMedida AS d on d.ID = a.IdUnidadMedida
		inner join [PAT].Derecho AS e on e.ID = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT as R on R.IdPreguntaPAT = a.ID and r.IdMunicipio = @IdMunicipio
		LEFT OUTER JOIN [PAT].Seguimiento as f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
		where a.ACTIVO = 1
		and e.ID = @IdDerecho
		and a.IdTablero = @IdTablero
		order by a.ID  asc
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcelSeguimientoAlcaldias]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcelSeguimientoAlcaldias] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero municipal 
-- =============================================
ALTER PROC [PAT].[C_DatosExcelSeguimientoAlcaldias] --[PAT].[C_DatosExcelSeguimientoAlcaldias] 411, 3
( @IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare @IdMunicipio int, @IdDepartamento int
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

		SELECT
		A.Id AS IdPregunta
		,RMA.Id AS IdAccion
		,RMP.Id AS IdPrograma
		,B.Descripcion AS Derecho
		,C.Descripcion AS Componente
		,D.Descripcion AS Medida
		,A.PreguntaIndicativa AS Pregunta
		,A.PreguntaCompromiso
		,E.Descripcion AS UnidadNecesidad
		,RM.RespuestaIndicativa AS RespuestaNecesidad
		,RM.ObservacionNecesidad
		,RM.RespuestaCompromiso
		,RM.AccionCompromiso AS ObservacionCompromiso
		,RM.Presupuesto AS PrespuestaPresupuesto
		,RMA.Accion
		,RMP.Programa
		,(SM.CantidadPrimer + REPLACE(SM.CantidadSegundo, -1, 0)) AS AvanceCantidadAlcaldia
		,(SM.PresupuestoPrimer + REPLACE(SM.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoAlcaldia
		,SM.Observaciones AS ObservacionesSeguimientoAlcaldia
		,(SG.CantidadPrimer + REPLACE(SG.CantidadSegundo, -1, 0)) AS AvanceCantidadGobernacion
		,(SG.PresupuestoPrimer + REPLACE(SG.PresupuestoSegundo, -1, 0)) AS AvancePresupuestoGobernacion
		,SG.Observaciones AS ObservacionesSeguimientoGobernacion
		FROM [PAT].PreguntaPAT A
		join [PAT].[PreguntaPATMunicipio] as PM on A.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		inner join [PAT].Componente b on b.Id = a.IdComponente
		inner join [PAT].Medida c on c.Id = a.IdMedida
		inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
		inner join [PAT].Derecho e on e.Id = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT RM ON RM.IdPreguntaPAT = A.Id  and RM.IdMunicipio = @IdMunicipio--AND RM.ID_ENTIDAD = [PAT].[fn_GetIdEntidad](@IdUsuario)
		LEFT OUTER JOIN [PAT].RespuestaPATAccion RMA ON RMA.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].RespuestaPATPrograma RMP ON RMP.IdRespuestaPAT = RM.Id
		LEFT OUTER JOIN [PAT].Seguimiento SM ON SM.IdPregunta = A.ID AND SM.IdUsuario = @IdUsuario AND SM.IdTablero = @IdTablero
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion SG ON SG.IdPregunta = A.ID AND SG.IdUsuarioAlcaldia = @IdUsuario AND SG.IdTablero = @IdTablero
		WHERE  a.IdTablero= @IdTablero 
		AND A.NIVEL = 3
		ORDER BY B.ID ASC, A.ID ASC
END
GO
-- ============================================= GESTION DEPARTAMENTAL =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroDepartamento] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		10/07/2017
-- Modified date:	14/11/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT departamental
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroDepartamento]  --[PAT].[C_TableroDepartamento] 375,1
 (@IdUsuario INT, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE  @IdDepartamento INT	
	select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

	SELECT 	P.Id AS ID_PREGUNTA, 
			P.IdDerecho, 
			P.IdComponente, 
			P.IdMedida, 
			P.NIVEL as Nivel, 
			P.PreguntaIndicativa, 
			P.IdUnidadMedida, 
			P.PreguntaCompromiso, 
			P.ApoyoDepartamental, 
			P.ApoyoEntidadNacional, 
			P.ACTIVO as Activo, 
			DERECHO.Descripcion AS Derecho, 
			COMPONENTE.Descripcion AS Componente, 
			MEDIDA.Descripcion AS Medida, 
			UNIDAD_MEDIDA.Descripcion AS UnidadMedida,	
			@idTablero AS IdTablero,			
			@IdDepartamento AS IdEntidad,						
			R.Id as IdRespuesta,
			R.RespuestaIndicativa,  
			R.RespuestaCompromiso, 
			R.Presupuesto,
			R.ObservacionNecesidad, 
			R.AccionCompromiso,
			P.RequiereAdjunto,
			P.MensajeAdjunto,
			P.ExplicacionPregunta 
	FROM  PAT.PreguntaPAT AS P
	JOIN PAT.PreguntaPATDepartamento AS PD ON P.Id = PD.IdPreguntaPAT AND PD.IdDepartamento =@IdDepartamento
	INNER JOIN PAT.Derecho DERECHO ON P.IdDerecho = DERECHO.Id 
	INNER JOIN PAT.Componente COMPONENTE ON P.IdComponente= COMPONENTE.Id
	INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
	INNER JOIN PAT.UnidadMedida UNIDAD_MEDIDA ON P.IdUnidadMedida = UNIDAD_MEDIDA.Id
	LEFT OUTER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id	
	LEFT OUTER JOIN [PAT].[RespuestaPAT] AS R ON P.Id = R.IdPreguntaPAT AND R.IdDepartamento =  @IdDepartamento 	
	WHERE TABLERO.Id = @idTablero
	AND	P.NIVEL = 2 and P.ACTIVO = 1
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroMunicipioTotales]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroMunicipioTotales] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - liliana Rodriguez
-- Create date:		10/07/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de totales consolidados, con las respuestas dadas por el gobernador 
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroMunicipioTotales] -- [PAT].[C_TableroMunicipioTotales]  null, 1,100,375,6,1
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT,  @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
DECLARE @RESULTADO TABLE (
		ID_PREGUNTA SMALLINT,
		PREGUNTAINDICATIVA NVARCHAR(500),
		PREGUNTACOMPROMISO NVARCHAR(500),
		DERECHO NVARCHAR(50),
		COMPONENTE NVARCHAR(100),
		MEDIDA NVARCHAR(50),
		UNIDADMEDIDA NVARCHAR(100),
		IDTABLERO TINYINT,
		IDENTIDAD INT,
		TOTALNECESIDADES INT,
		TOTALCOMPROMISOS INT,
		ID INT
		)
	
	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize

	SET @ORDEN = @sortOrder
	IF @ORDEN = ''
			SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE  @IdMunicipio INT, @IDDEPARTAMENTO INT

	SELECT @IDDEPARTAMENTO = IdDepartamento , @IdMunicipio = IdMunicipio FROM USUARIO WHERE Id = @IdUsuario

	SET @SQL = 'SELECT DISTINCT TOP (@TOP) 
					IDPREGUNTA,PREGUNTAINDICATIVA,PREGUNTACOMPROMISO,
					DERECHO,COMPONENTE,MEDIDA,UNIDADMEDIDA,IDTABLERO,IDENTIDAD,TOTALNECESIDADES,TOTALCOMPROMISOS,ID
				FROM ( 
				 SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.PREGUNTAINDICATIVA, 
						P.PREGUNTACOMPROMISO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						(SELECT SUM(R1.RespuestaIndicativa) 
							FROM  [PAT].[RespuestaPAT] R1	
							join Municipio MUN ON R1.IdMunicipio = MUN.Id
							WHERE R1.[IdPreguntaPAT]=P.Id  AND MUN.IdDepartamento = @IDDEPARTAMENTO							
						) TOTALNECESIDADES,
						(SELECT SUM(R1.RESPUESTACOMPROMISO) 
							FROM  [PAT].[RespuestaPAT] R1
							join Municipio MUN ON R1.IdMunicipio = MUN.Id
							WHERE R1.IdPreguntaPAT=P.Id AND MUN.IdDepartamento = @IDDEPARTAMENTO								
						) TOTALCOMPROMISOS,
						(SELECT TOP 1 RR.ID FROM [PAT].[RespuestaPAT] RR WHERE P.Id = RR.IdPreguntaPAT and RR.IdDepartamento =  @IDDEPARTAMENTO and RR.IdMunicipio is null	) AS ID
				FROM    [PAT].[PreguntaPAT] as P 
						join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT
						join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = IDDEPARTAMENTO
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdDepartamento =  @IDDEPARTAMENTO and R.IdMunicipio is null,						
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 					
					AND D.ID = @IdDerecho'		
	SET @SQL = @SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY P.ID'--+ @ORDEN 	
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IdMunicipio INT,@IdDerecho INT, @IDDEPARTAMENTO int'
		
	PRINT @SQL

	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IdMunicipio=@IdMunicipio, @IdDerecho=@IdDerecho, @IDDEPARTAMENTO=@IDDEPARTAMENTO
	SELECT * from @RESULTADO
END
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroDepartamentoAvance]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroDepartamentoAvance] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene los totales de necesidades y compromisos departamentales del tablero PAT
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroDepartamentoAvance]--  [PAT].[C_TableroDepartamentoAvance] 375,3
		@IdUsuario INT, @idTablero tinyint
AS
BEGIN
	SET NOCOUNT ON;	
	DECLARE @NIVEL INT = 3
	DECLARE  @IdDepartamento INT
	SELECT  @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	SELECT	D.Descripcion AS DERECHO, 
			--SUM(case when R.RespuestaIndicativa IS NULL or R.RespuestaIndicativa=0 then 0 else 1 end)*100/count(*) PINDICATIVA,
			--SUM(case when R.RespuestaCompromiso IS NULL or R.RespuestaCompromiso=0 then 0 else 1 end)*100/count(*) PCOMPROMISO
			SUM(case when R.RespuestaIndicativa IS NULL or R.RespuestaIndicativa=0 then 0 else R.RespuestaIndicativa end) PINDICATIVA,
			SUM(case when R.RespuestaCompromiso IS NULL or R.RespuestaCompromiso=0 then 0 else RespuestaCompromiso end) PCOMPROMISO
	FROM    [PAT].[PreguntaPAT] (NOLOCK) AS P
	--join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT
	--join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = @IdDepartamento						
	INNER JOIN [PAT].[Derecho] (NOLOCK) D ON P.IDDERECHO = D.ID 
	INNER JOIN PAT.Tablero (NOLOCK) AS T ON P.IDTABLERO = T.ID				
	LEFT OUTER JOIN [PAT].[RespuestaPAT] (NOLOCK) AS R ON R.IdDepartamento = @IdDepartamento  and P.ID = R.[IdPreguntaPAT]
	WHERE	P.NIVEL = @NIVEL 
	AND T.ID = @idTablero
	and P.ACTIVO = 1	
	group by D.DESCRIPCION
END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcel_Gobernaciones]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_DatosExcel_Gobernaciones] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/07/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene toda la informacion correspondiente a las preguntas de la  gobernacion  del tablero indicando en cuento a las respuestas que estos diligenciaron
-- ==========================================================================================

ALTER PROC [PAT].[C_DatosExcel_Gobernaciones] -- [PAT].[C_DatosExcel_Gobernaciones] 11001,3
(
	@IdUsuario INT, @IdTablero INT
)
AS
BEGIN

	declare @IdDepartamento int
	select  @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	SELECT DISTINCT  
	IDPREGUNTA AS ID
	, '' AS ENTIDAD
	,DERECHO
	,COMPONENTE
	,MEDIDA
	,PREGUNTAINDICATIVA
	,PREGUNTACOMPROMISO
	,UNIDADMEDIDA
	,RESPUESTAINDICATIVA
	,OBSERVACIONNECESIDAD
	,RESPUESTACOMPROMISO
	,ACCIONCOMPROMISO AS OBSERVACIONCOMPROMISO
	,CONVERT(FLOAT, PRESUPUESTO) AS PRESUPUESTO
	,ACCION
	,PROGRAMA
	FROM ( 
		SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
		P.ID AS IDPREGUNTA, 
		P.IDDERECHO, 
		P.IDCOMPONENTE, 
		P.IDMEDIDA, 
		P.NIVEL, 
		P.PREGUNTAINDICATIVA, 
		P.IDUNIDADMEDIDA, 
		P.PREGUNTACOMPROMISO, 
		P.APOYODEPARTAMENTAL, 
		P.APOYOENTIDADNACIONAL, 
		P.ACTIVO, 
		D.DESCRIPCION AS DERECHO, 
		C.DESCRIPCION AS COMPONENTE, 
		M.DESCRIPCION AS MEDIDA, 
		UM.DESCRIPCION AS UNIDADMEDIDA,	
		R.ID AS IDTABLERO,						
		CASE WHEN R.IdMunicipio IS NULL THEN 0 ELSE R.IdMunicipio END AS IDENTIDAD,
		R.ID as id_respuesta,
		R.RESPUESTAINDICATIVA, 
		R.RESPUESTACOMPROMISO, 
		R.PRESUPUESTO,
		R.OBSERVACIONNECESIDAD,
		R.ACCIONCOMPROMISO
		,AA.ACCION
		,AP.PROGRAMA
		FROM    [PAT].[PreguntaPAT] AS P
		INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
		INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
		INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
		INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
		INNER JOIN PAT.Tablero AS T ON P.IDTABLERO = T.ID
		LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] and R.IdDepartamento = @IdDepartamento and R.IdMunicipio is null
		LEFT OUTER JOIN [PAT].[RespuestaPATAccion] AS AA ON AA.[IdRespuestaPAT] = R.ID and AA.Activo = 1
		LEFT OUTER JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
		INNER JOIN Usuario AS U ON R.IdUsuario = U.Id and U.IdDepartamento = @IdDepartamento
		WHERE  T.ID = @IdTablero 
		and	P.NIVEL = 2					 
	) AS A 
	WHERE A.ACTIVO = 1  
	ORDER BY IDPREGUNTA
END


GO

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_MunicipiosXPregunta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_MunicipiosXPregunta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date:	11/11/2017
-- Description:	Procedimiento que retorna la información de todos los municipios relacionados y los que 
--				no con la pregunta PAT.
-- ====================================================================================================
ALTER PROCEDURE [PAT].[C_MunicipiosXPregunta]

	@IdPregunta INT,
	@Incluidos BIT

AS
	BEGIN
		
		IF(@Incluidos = 1)
			BEGIN
				SELECT 
					[M].[Id],
					[M].[Divipola],
					UPPER([D].[Nombre]) Departamento,
					UPPER([M].[Nombre]) Municipio
				FROM 
					[dbo].[Municipio] M
				INNER JOIN [dbo].[Departamento] D ON M.IdDepartamento = D.Id
				WHERE [M].[Id] IN (	SELECT [M].[Id] 
								FROM [dbo].[Municipio] M
								INNER JOIN [PAT].[PreguntaPATMunicipio] PPM ON [PPM].[IdMunicipio] = [M].[Id]
								WHERE [PPM].[IdPreguntaPAT] = @IdPregunta)
				ORDER BY 1
			END
		ELSE
			BEGIN
				SELECT 
					[M].[Id],
					[M].[Divipola],
					UPPER([D].[Nombre]) Departamento,
					UPPER([M].[Nombre]) Municipio
				FROM 
					[dbo].[Municipio]  M
				INNER JOIN [dbo].[Departamento] D ON M.IdDepartamento = D.Id
				WHERE [M].[Id] NOT IN (	SELECT [M].[Id] 
								FROM [dbo].[Municipio] M
								INNER JOIN [PAT].[PreguntaPATMunicipio] PPM ON [PPM].[IdMunicipio] = [M].[Id]
								WHERE [PPM].[IdPreguntaPAT] = @IdPregunta)
				ORDER BY 1
			END
	
	END

GO

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_RetroArcPreguntasUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_RetroArcPreguntasUpdate] AS'
GO
-- =============================================  
-- Author:  Equipo de desarrollo OIM - John Betancourt  
-- Create date: 05/09/2017  
-- Description: ingresa una nueva pregunta tipo archivo   
-- =============================================  
ALTER PROC [dbo].[U_RetroArcPreguntasUpdate]   
	@IdRetroArc			INT,
	@CodigoPregunta		VARCHAR(8),  
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
   
   UPDATE [dbo].[RetroArcPreguntasXEncuestaXmunicipio] 
	SET [Documento] = @Documento
	  ,[Sumariza] = @Sumar
      ,[Pertenece] = @Pertenece
      ,[Observacion] = @Observacion
      WHERE CodigoPregunta = @CodigoPregunta 
   
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



-- ============================================= SEGUIMIENTO DEPARTAMENTAL =============================================
update SubRecurso set IdRecurso = 3 where Id =67
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDepartamento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez -Vilma rodriguez
-- Create date:		29/08/2017
-- Modified date:	14/11/2017
-- Description:		Obtiene informacion de las preguntas por departamento para el seguimiento de un tablero departamental
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDepartamento] -- [PAT].[C_TableroSeguimientoDepartamento] 1, 1013
(	@IdTablero INT ,@IdUsuario INT )
AS
BEGIN		
		DECLARE  @IdDepartamento INT	
		select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

		select 
		e.Descripcion as Derecho
		,b.Descripcion as Componente
		,c.Descripcion as Medida
		,a.PreguntaIndicativa
		,d.Descripcion as Unidad
		,a.PreguntaCompromiso
		,ISNULL(f.IdSeguimiento, 0) as IdSeguimiento
		,ISNULL(f.CantidadPrimer, -1) as CompromisoPrimerSemestre
		,ISNULL(f.CantidadSegundo, -1) as CompromisoSegundoSemestre
		,ISNULL(f.CantidadPrimer + REPLACE(f.CantidadSegundo, -1, 0), -1) as CompromisoTotal
		,ISNULL(f.PresupuestoPrimer, -1) as PresupuestoPrimerSemestre
		,ISNULL(f.PresupuestoSegundo, -1) as PresupuestoSegundoSemestre
		,ISNULL(f.PresupuestoPrimer + REPLACE(f.PresupuestoSegundo, -1, 0), -1) as PresupuestoTotal
		,a.Id 
		,a.IdComponente 
		,a.IdDerecho
		,a.IdMedida 
		,a.IdUnidadMedida
		,ISNULL(R.RespuestaCompromiso, 0) AS RespuestaIndicativa
		,ISNULL(R.Presupuesto, 0) AS Presupuesto
		from [PAT].PreguntaPAT AS a
		join pat.PreguntaPATDepartamento as PD on a.Id = PD.IdPreguntaPAT and PD.IdDepartamento = @IdDepartamento
		inner join [PAT].Componente b on b.Id = a.IdComponente
		inner join [PAT].[Medida] c on c.Id = a.IdMedida
		inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
		inner join [PAT].Derecho e on e.Id = a.IdDerecho
		LEFT OUTER JOIN [PAT].RespuestaPAT R on R.IdPreguntaPAT = a.ID and R.IdDepartamento= @IdDepartamento
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion f on f.IdPregunta = a.ID and f.IdUsuario = @IdUsuario
		where a.IdTablero = @IdTablero
		and a.NIVEL = 2
		order by a.Id  asc
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoDepartamentoAvance]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoDepartamentoAvance] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	14/11/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para otros derechos
-- =============================================
ALTER PROC  [PAT].[C_TableroSeguimientoDepartamentoAvance]-- [PAT].[C_TableroSeguimientoDepartamentoAvance] 506, 1
( @IdUsuario INT ,@IdTablero INT )
AS
BEGIN
	declare @IdMunicipio int, @IdDepartamento int
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario

	SELECT
	A.Derecho
	,CONVERT(INT, ROUND(CASE A.ri WHEN 0 THEN 0 ELSE ((( A.sumc1c2 ) / CONVERT(DECIMAL(12,6), A.ri)) * 100) END, 0)) AS AvanceCompromiso
	,CONVERT(INT, ROUND(CASE A.pres WHEN 0 THEN 0 ELSE ((( A.sump1p2 ) / A.pres) * 100) END, 0)) AS AvancePresupuesto
	FROM
	(
		---TRAE LA INFORMACION DEL LA GESTION DE LA GOBERNACION
		SELECT
		'Gestión Gobernación' as Derecho
		,SUM(case when R.RespuestaIndicativa is null then 0 else r.RespuestaIndicativa end) as ri
		,SUM(case when R.Presupuesto is null then 0 else r.Presupuesto end) as pres
		,(SUM(case when C.CantidadPrimer is null or C.CantidadPrimer = -1 then 0 else C.CantidadPrimer end) + SUM(case when C.CantidadSegundo is null or C.CantidadSegundo = -1 then 0 else C.CantidadSegundo end)) as sumc1c2
		,(SUM(case when C.PresupuestoPrimer is null or C.PresupuestoPrimer = -1 then 0 else C.PresupuestoPrimer end) + SUM(case when C.PresupuestoSegundo is null or C.PresupuestoSegundo = -1 then 0 else C.PresupuestoSegundo end)) as sump1p2
		FROM    PAT.PreguntaPAT AS P
		join pat.PreguntaPATDepartamento as PD on P.Id = PD.IdPreguntaPAT and PD.IdDepartamento = @IdDepartamento
		INNER JOIN PAT.Derecho as DERECHO ON P.IdDerecho = DERECHO.Id
		LEFT OUTER JOIN PAT.RespuestaPAT as R ON P.Id = R.IdPreguntaPAT
		LEFT OUTER JOIN Seguimiento AS C ON C.IdPregunta = P.Id AND C.IdUsuario = @IdUsuario
		WHERE P.IdTablero = @IdTablero 
		AND P.Nivel = 2 
		AND P.Activo= 1

		UNION ALL
		--TRAE LA GESION DE LA GESTION DE LOS DERECHOS DE LAS PREGUNTAS DE LOS MUNICIPIOS
		SELECT  
		D.Descripcion as Derecho
		,SUM(case when R.RespuestaCompromiso is null then 0 else r.RespuestaCompromiso end) as ri
		,SUM(case when R.Presupuesto is null then 0 else r.Presupuesto end) as pres
		,(SUM(case when C.CantidadPrimer is null or C.CantidadPrimer = -1 then 0 else C.CantidadPrimer end) + SUM(case when C.CantidadSegundo is null or C.CantidadSegundo = -1 then 0 else C.CantidadSegundo end)) as sumc1c2
		,(SUM(case when C.PresupuestoPrimer is null or C.PresupuestoPrimer = -1 then 0 else C.PresupuestoPrimer end) + SUM(case when C.PresupuestoSegundo is null or C.PresupuestoSegundo = -1 then 0 else C.PresupuestoSegundo end)) as sump1p2
		FROM    PAT.PreguntaPAT AS P
		join pat.PreguntaPATMunicipio as M on P.Id = M.IdPreguntaPAT 
		join Municipio as u on M.IdMunicipio  = u.Id and u.IdDepartamento =  @IdDepartamento
		INNER JOIN PAT.Derecho D ON P.IdDerecho = D.Id	 
		LEFT OUTER JOIN [PAT].[RespuestaPATDepartamento] as R on P.Id = R.IdPreguntaPAT and R.IdMunicipioRespuesta = @IdMunicipio		
		LEFT OUTER JOIN [PAT].SeguimientoGobernacion as C ON C.IdPregunta = P.ID AND C.IdTablero = @IdTablero AND C.IdUsuario = @IdUsuario AND C.IdUsuarioAlcaldia = @IdMunicipio
		WHERE	P.NIVEL = 3 
		and P.IdTablero = @IdTablero  
		group by D.Descripcion
	) AS A
END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroSeguimientoConsolidadoDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroSeguimientoConsolidadoDepartamento] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		29/08/2017
-- Modified date:	14/11/2017
-- Description:		Obtiene informacion para el seguimiento de un tablero departamental para una pregunta en especial
-- =============================================
ALTER PROC [PAT].[C_TableroSeguimientoConsolidadoDepartamento] --[PAT].[C_TableroSeguimientoConsolidadoDepartamento]  1, 375, 6
(	@IdTablero INT ,@IdUsuario INT ,@IdDerecho INT )
AS
BEGIN
	DECLARE  @IdDepartamento INT	
	select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

--SELECT
--B.DESCRIPCION AS COMPONENTE
--,C.DESCRIPCION AS MEDIDA
--,E.DESCRIPCION AS DERECHO
--,A.PREGUNTA_INDICATIVA 
--,D.DESCRIPCION AS UNIDAD
--,SUM(ISNULL(RD.RESPUESTA_COMPROMISO, 0)) AS TOTALCOMPROMISO
--,SUM(ISNULL(RD.PRESUPUESTO, 0)) AS TOTALPRESUPUESTO
--,ISNULL(SUM(SM.CantidadPrimer), -1) AS AVANCEPRIMERALCALDIAS
--,ISNULL(SUM(SM.CantidadSegundo), -1) AS AVANCESEGUNDOALCALDIAS
--,ISNULL(SUM(SG.CantidadPrimer), -1) AS AVANCEPRIMERGOBERNA
--,ISNULL(SUM(SG.CantidadSegundo), -1) AS AVANCESEGUNDOGOBERNA
--,A.ID AS ID_PREGUNTA
--,E.ID AS ID_DERECHO
--FROM [PAT].[TB_PREGUNTA] A
--inner join [PAT].[TB_COMPONENTE] b on b.ID = a.[ID_COMPONENTE]
--inner join [PAT].[TB_MEDIDA] c on c.ID = a.ID_MEDIDA
--inner join [PAT].[TB_UNIDAD_MEDIDA] d on d.ID = a.ID_UNIDAD_MEDIDA
--inner join [PAT].[TB_DERECHO] e on e.ID = a.ID_DERECHO
--LEFT OUTER JOIN [PAT].[TB_PAT_RESPUESTA_DEPARTAMENTO] RD ON RD.ID_PREGUNTA = A.ID AND RD.ID_ENTIDAD = PAT.fn_GetIdEntidad(@IdUsuario) AND RD.ID_TABLERO = @IdTablero
--LEFT OUTER JOIN [PAT].[TB_SEGUIMIENTO] SM ON SM.IdPregunta = A.ID AND SM.IdTablero = RD.ID_TABLERO AND SM.IdUsuario = [PAT].[fn_GetIdUsuario](RD.ID_ENTIDAD_MUNICIPIO)
--LEFT OUTER JOIN [PAT].[TB_SEGUIMIENTO_GOBERNACION] SG ON SG.IdPregunta = A.ID AND SG.IdTablero = SM.IdTablero AND SG.IdUsuarioAlcaldia = SM.IdUsuario
--WHERE
--E.ID = @IdDerecho
--AND A.ACTIVO = @Activo
--AND A.ID >= @IdPreguntaIni AND A.ID <= @IdPreguntaFin
--GROUP BY
--B.DESCRIPCION, C.DESCRIPCION, A.PREGUNTA_INDICATIVA, D.DESCRIPCION, E.DESCRIPCION, A.ID, E.ID

	SELECT DISTINCT
	B.Descripcion AS Componente
	,C.Descripcion AS Medida
	,E.Descripcion AS Derecho
	,A.PreguntaIndicativa 
	,D.DESCRIPCION AS UNIDAD
	
	,SUM(ISNULL(RD.RespuestaCompromiso, 0)) AS TotalCompromiso
	,SUM(ISNULL(RD.Presupuesto, 0)) AS TotalPresupuesto
	
	,ISNULL(SUM(SM.CantidadPrimer), -1) AS AvancePrimerSemestreAlcladias
	,ISNULL(SUM(SM.CantidadSegundo), -1) AS AvanceSegundoSemestreAlcladias

	,ISNULL(SUM(SG.CantidadPrimer), -1) AS AvancePrimerSemestreGobernaciones
	,ISNULL(SUM(SG.CantidadSegundo), -1) AS AvanceSegundoSemestreGobernaciones
	,A.Id AS IdPregunta
	,E.Id AS IdDerecho
	FROM [PAT].PreguntaPAT as A
	join [PAT].[PreguntaPATMunicipio] as PM on A.Id = PM.IdPreguntaPAT
	join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = IDDEPARTAMENTO
	inner join [PAT].Componente b on b.Id = a.IdComponente
	inner join [PAT].Medida c on c.Id = a.IdMedida
	inner join [PAT].UnidadMedida d on d.Id = a.IdUnidadMedida
	inner join [PAT].Derecho e on e.Id = a.IdDerecho
	LEFT OUTER JOIN [PAT].RespuestaPAT RM ON A.Id =RM.IdPreguntaPAT and RM.IdDepartamento = @IdDepartamento and RM.IdMunicipio is not null --para que tome las respuestas de alcaldias
	LEFT OUTER JOIN Municipio AS M ON RM.IdMunicipio = M.ID
	LEFT OUTER JOIN [PAT].RespuestaPATDepartamento RD ON A.Id=RD.IdPreguntaPAT  AND RD.IdUsuario = @IdUsuario and RD.IdMunicipioRespuesta = RM.IdMunicipio 	
	LEFT OUTER JOIN [PAT].Seguimiento as SM ON A.ID= SM.IdPregunta AND a.IdTablero =SM.IdTablero AND  RD.IdUsuario = SM.IdUsuario 
	LEFT OUTER join Usuario as URS on SM.IdUsuario = URS.Id and  RD.IdMunicipioRespuesta  =URS.IdMunicipio
	LEFT OUTER JOIN [PAT].SeguimientoGobernacion as SG ON A.ID =SG.IdPregunta AND SG.IdTablero = SM.IdTablero AND SG.IdUsuarioAlcaldia = SM.IdUsuario
	WHERE  A.IdTablero = @IdTablero
	and A.Nivel = 3
	and E.ID = @IdDerecho
	AND A.ACTIVO = 1		
	GROUP BY
	B.Descripcion, C.Descripcion, A.PreguntaIndicativa, D.Descripcion, E.Descripcion, A.Id, E.Id

END

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_Derechos]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_Derechos] AS'
go
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		10/07/2017
-- Modified date:	13/11/2017
-- Description:		Obtiene los derechos de un tablero que tienen preguntas activas asociadas
-- =============================================
ALTER PROC [PAT].[C_Derechos] ( @idTablero tinyint,@IdUsuario INT, @GestionDepartamental bit)--[PAT].[C_Derechos] 2,411
AS
BEGIN
	Declare @IdMunicipio int, @IdDepartamento int
	SELECT @IdMunicipio =  U.[IdMunicipio] , @IdDepartamento = IdDepartamento FROM [dbo].[Usuario] (NOLOCK) U WHERE U.ID = @IdUsuario

	IF (@GestionDepartamental =1) --DEBE TRAER TODOS LOS DERECHOS QUE ESTEN ASOCIADOS A PREGUNTAS DEL TABLERO INDICADO
	BEGIN
		SELECT DISTINCT D.ID, D.DESCRIPCION
		FROM [PAT].[Derecho] D
		JOIN PAT.PreguntaPAT AS P ON D.Id = P.IdDerecho
		join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT 
		join Municipio as Mun on PM.IdMunicipio = Mun.Id and Mun.IdDepartamento = @IdDepartamento										
		WHERE P.IdTablero = @idTablero and p.Activo = 1	and p.Nivel = 3		
		ORDER BY D.Descripcion
	END
	ELSE --TRAE SOLO LOS DERECHOS DE PREGUNTAS ASOCIADAS AL MUNICIPIO DEL TABLERO INDICADO
	BEGIN
		SELECT DISTINCT D.ID, D.DESCRIPCION
		FROM [PAT].[Derecho] D
		JOIN PAT.PreguntaPAT AS P ON D.Id = P.IdDerecho
		join [PAT].[PreguntaPATMunicipio] as PM on P.Id = PM.IdPreguntaPAT AND PM.IdMunicipio = @IdMunicipio
		WHERE P.IdTablero = @idTablero and p.Activo = 1	and p.Nivel = 3		
		ORDER BY D.Descripcion
	END
END

GO 
-- ============================================= ADJUNTO EN EL DILIGENCIAMIENTO =============================================
if not exists (select * from sys.columns where name='NombreAdjunto' and Object_id in (select object_id from sys.tables where name ='RespuestaPAT'))
begin 
	ALTER TABLE [PAT].RespuestaPAT ADD NombreAdjunto varchar(200) null	
end
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[I_RespuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[I_RespuestaInsert] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez																		  
/Fecha creacion:     2017-03-29	
/Fecha modificacion :2017-11-14																		  
/Descripcion: Inserta la información del tablero municipal y del tablero departamental cuando se ingresa
/la respuesta por el tab de "Consolidado municipal". Cuando es de la gestion municipal se guardan todos los datos
/Cuando es desde el tab de consolidado de la gestion departamental se guarda el registro sin los datos del resultado y sin municipio
/Se guarda el registro para poder tener el id y guardar las acciones y programas												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[I_RespuestaInsert] 
		@IDUSUARIO int,
		@IDPREGUNTA smallint,
		@NECESIDADIDENTIFICADA int,
		@RESPUESTAINDICATIVA int,
		@RESPUESTACOMPROMISO int,
		@PRESUPUESTO money,
		@OBSERVACIONNECESIDAD nvarchar(1000),
		@ACCIONCOMPROMISO nvarchar(1000),		
		@NOMBREADJUNTO nvarchar(200)		
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	

	declare @id int, @IdDepartamento int,@IdMunicipio int, @IdTipoUsuario int
	--select  @IdDepartamento = IdDepartamento, @IdMunicipio = case when IdTipoUsuario = 7 then null else  IdMunicipio end from Usuario where Id = @IDUSUARIO
	select  @IdDepartamento = IdDepartamento, @IdMunicipio =IdMunicipio,  @IdTipoUsuario = IdTipoUsuario from Usuario where Id = @IDUSUARIO
	if (@IdTipoUsuario = 7)
		set @IdMunicipio = null

	select @id = r.ID from [PAT].[RespuestaPAT] as r
	where r.IdPreguntaPAT = @IDPREGUNTA AND  r.IdMunicipio = @IdMunicipio
	order by r.ID
	if (@id is not null)
	begin
		set @esValido = 0
		set @respuesta += 'La respuesta ya se encuentra ingresada.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
	
		
		INSERT INTO [PAT].[RespuestaPAT]
		([IdPreguntaPAT]
		,[NECESIDADIDENTIFICADA]
		,[RESPUESTAINDICATIVA]
		,[RESPUESTACOMPROMISO]
		,[PRESUPUESTO]
		,[OBSERVACIONNECESIDAD]
		,[ACCIONCOMPROMISO]
		,[IDUSUARIO]
		,[FECHAINSERCION]
		,[IdMunicipio]
		,[IdDepartamento]
		,NombreAdjunto)
		VALUES
		(@IDPREGUNTA,
		 @NECESIDADIDENTIFICADA, 
		 @RESPUESTAINDICATIVA, 
		 @RESPUESTACOMPROMISO,
		 @PRESUPUESTO, 
		 @OBSERVACIONNECESIDAD,
		 @ACCIONCOMPROMISO,
		 @IDUSUARIO,
		 GETDATE(),
		 @IdMunicipio,
		 @IdDepartamento,
		 @NOMBREADJUNTO)    			
		
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
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[U_RespuestaUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[U_RespuestaUpdate] AS'
go
/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez																		  
/Fecha creacion: 2017-03-29																			  
/Fecha modificacion :2017-11-14																		  
/Descripcion: Actualiza la información del tablero												  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [PAT].[U_RespuestaUpdate] 
		@ID int,
		@IDPREGUNTA smallint,
		@NECESIDADIDENTIFICADA int,
		@RESPUESTAINDICATIVA int,
		@RESPUESTACOMPROMISO int,
		@PRESUPUESTO money,
		@OBSERVACIONNECESIDAD nvarchar(1000),
		@ACCIONCOMPROMISO nvarchar(1000),
		@IDUSUARIO int,		
		@NOMBREADJUNTO nvarchar(200)			
		AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1
	declare @IDMUNICIPIO int
	
	SELECT @IDMUNICIPIO = [PAT].[fn_GetIdEntidad](@IDUSUARIO)

	--declare @idRespuesta int
	--select @idRespuesta = r.ID from [PAT].[RespuestaPAT] as r
	--where r.[IdPreguntaPAT] = @IDPREGUNTA and r.IdMunicipio = @IDMUNICIPIO
	--order by r.ID
	--if (@idRespuesta is null)
	--begin
	--	set @esValido = 0
	--	set @respuesta += 'No se encontro la respuesta.\n'
	--end

	if(@esValido = 1) 
	begin
		BEGIN TRY

		UPDATE [PAT].[RespuestaPAT]
		   SET [IdPreguntaPAT] = @IDPREGUNTA
			  ,[NECESIDADIDENTIFICADA] = @NECESIDADIDENTIFICADA
			  ,[RESPUESTAINDICATIVA] = @RESPUESTAINDICATIVA
			  ,[RESPUESTACOMPROMISO] = @RESPUESTACOMPROMISO
			  ,[PRESUPUESTO] = @PRESUPUESTO
			  ,[OBSERVACIONNECESIDAD] = @OBSERVACIONNECESIDAD
			  ,[ACCIONCOMPROMISO] = @ACCIONCOMPROMISO
			  ,[FechaModificacion] = GETDATE()
			  ,NombreAdjunto= @NOMBREADJUNTO
		 WHERE  ID = @ID 

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
	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroMunicipio]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroMunicipio] AS'
go
-- =============================================
-- Author:			Grupo OIM - Vilma Rodriguez
-- Create date:		28/10/2017
-- Modified date:	13/11/2017
-- Description:		Trae el listado de todas las preguntas municipales del tablero, derecho y municipio indicado  
-- =============================================
ALTER PROCEDURE [PAT].[C_TableroMunicipio] --[PAT].[C_TableroMunicipio] null, 1, 20, 411 , 1,3
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho int, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		IDPREGUNTA SMALLINT,IDDERECHO SMALLINT,IDCOMPONENTE TINYINT,IDMEDIDA SMALLINT,NIVEL TINYINT,
		PREGUNTAINDICATIVA NVARCHAR(500),IDUNIDADMEDIDA TINYINT,PREGUNTACOMPROMISO NVARCHAR(500),APOYODEPARTAMENTAL BIT,
		APOYOENTIDADNACIONAL BIT,ACTIVO BIT,DERECHO NVARCHAR(50),COMPONENTE NVARCHAR(100),MEDIDA NVARCHAR(50),
		UNIDADMEDIDA NVARCHAR(100),IDTABLERO TINYINT,IDENTIDAD INT,ID INT,RESPUESTAINDICATIVA INT,
		RESPUESTACOMPROMISO INT,PRESUPUESTO MONEY,OBSERVACIONNECESIDAD NVARCHAR(1000),ACCIONCOMPROMISO NVARCHAR(1000), 
		RequiereAdjunto bit,MensajeAdjunto NVARCHAR(max),ExplicacionPregunta NVARCHAR(max),NombreAdjunto NVARCHAR(200)
		)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize 

	SET @ORDEN = @sortOrder
	SET @ORDEN = 'P.ID'
	IF @ORDEN = '' or @ORDEN is null
		SET @ORDEN = 'P.ID'
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	Declare @IdMunicipio int
	SELECT @IdMunicipio =  U.[IdMunicipio] FROM [dbo].[Usuario] (NOLOCK) U WHERE U.ID = @IdUsuario
	
	SET @SQL = 'SELECT 	
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO,
		RequiereAdjunto,MensajeAdjunto,ExplicacionPregunta,NombreAdjunto
		FROM (
		SELECT DISTINCT TOP (@TOP) LINEA,
		IDPREGUNTA,IDDERECHO,IDCOMPONENTE,IDMEDIDA,NIVEL,
		PREGUNTAINDICATIVA,IDUNIDADMEDIDA,PREGUNTACOMPROMISO,APOYODEPARTAMENTAL,
		APOYOENTIDADNACIONAL,ACTIVO,DERECHO,COMPONENTE,MEDIDA,
		UNIDADMEDIDA,IDTABLERO,IDENTIDAD,ID,RESPUESTAINDICATIVA,
		RESPUESTACOMPROMISO,PRESUPUESTO,OBSERVACIONNECESIDAD,ACCIONCOMPROMISO,
		RequiereAdjunto,MensajeAdjunto,ExplicacionPregunta,NombreAdjunto
	FROM ( 
    SELECT DISTINCT row_number() OVER (ORDER BY '+ @ORDEN +') AS LINEA, 
						P.ID AS IDPREGUNTA, 
						P.IDDERECHO, 
						P.IDCOMPONENTE, 
						P.IDMEDIDA, 
						P.NIVEL, 
						P.PREGUNTAINDICATIVA, 
						P.IDUNIDADMEDIDA, 
						P.PREGUNTACOMPROMISO, 
						P.APOYODEPARTAMENTAL, 
						P.APOYOENTIDADNACIONAL, 
						P.ACTIVO, 
						D.DESCRIPCION AS DERECHO, 
						C.DESCRIPCION AS COMPONENTE, 
						M.DESCRIPCION AS MEDIDA, 
						UM.DESCRIPCION AS UNIDADMEDIDA,	
						T.ID AS IDTABLERO,
						CASE WHEN R.IdMunicipio IS NULL THEN @IdMunicipio ELSE R.IdMunicipio END AS IDENTIDAD,
						R.ID ,
						R.RespuestaIndicativa, 
						R.RESPUESTACOMPROMISO, 
						R.PRESUPUESTO,
						R.OBSERVACIONNECESIDAD,
						R.ACCIONCOMPROMISO,
						P.RequiereAdjunto,
						P.MensajeAdjunto,
						P.ExplicacionPregunta,
						R.NombreAdjunto
				FROM    [PAT].[PreguntaPAT] as P 
						LEFT OUTER JOIN [PAT].[RespuestaPAT] R on P.Id = R.IdPreguntaPAT and R.IdMunicipio =  @IdMunicipio ,
						[PAT].[Derecho] D,
						[PAT].[Componente] C,
						[PAT].[Medida] M,
						[PAT].[UnidadMedida] UM,
						[PAT].[Tablero] T,
						[PAT].[PreguntaPATMunicipio] as PM
				WHERE P.IDDERECHO = D.ID 
					AND P.IDCOMPONENTE = C.ID 
					AND P.IDMEDIDA = M.ID 
					AND P.IDUNIDADMEDIDA = UM.ID 
					AND P.IDTABLERO = T.ID
					AND P.ID = PM.IdPreguntaPAT and PM.IdMunicipio = @IdMunicipio
					AND T.ID = @idTablero 
					AND P.NIVEL = 3 
					AND P.ACTIVO = 1 					
					AND D.ID = @IdDerecho'	
	SET @SQL =@SQL +' ) AS P WHERE LINEA >@PAGINA  ORDER BY LINEA ) AS T'
	SET @PARAMETROS = '@TOP INT, @PAGINA INT,@USUARIO INT, @idTablero tinyint,@IdMunicipio INT,@IdDerecho INT'
		
	--PRINT @SQL
	INSERT INTO @RESULTADO
	EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @USUARIO = @IdUsuario, @idTablero=@idTablero, @IdMunicipio=@IdMunicipio, @IdDerecho=@IdDerecho
	SELECT * from @RESULTADO
END

go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroDepartamento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_TableroDepartamento] AS'
go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		10/07/2017
-- Modified date:	14/11/2017
-- Description:		Obtiene las preguntas para la gestión del tablero PAT departamental
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_TableroDepartamento]  --[PAT].[C_TableroDepartamento] 375,1
 (@IdUsuario INT, @idTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE  @IdDepartamento INT	
	select @IdDepartamento = IdDepartamento from Usuario where Id= @IdUsuario

	SELECT 	P.Id AS ID_PREGUNTA, 
			P.IdDerecho, 
			P.IdComponente, 
			P.IdMedida, 
			P.NIVEL as Nivel, 
			P.PreguntaIndicativa, 
			P.IdUnidadMedida, 
			P.PreguntaCompromiso, 
			P.ApoyoDepartamental, 
			P.ApoyoEntidadNacional, 
			P.ACTIVO as Activo, 
			DERECHO.Descripcion AS Derecho, 
			COMPONENTE.Descripcion AS Componente, 
			MEDIDA.Descripcion AS Medida, 
			UNIDAD_MEDIDA.Descripcion AS UnidadMedida,	
			@idTablero AS IdTablero,			
			@IdDepartamento AS IdEntidad,						
			R.Id as IdRespuesta,
			R.RespuestaIndicativa,  
			R.RespuestaCompromiso, 
			R.Presupuesto,
			R.ObservacionNecesidad, 
			R.AccionCompromiso,
			P.RequiereAdjunto,
			P.MensajeAdjunto,
			P.ExplicacionPregunta,
			R.NombreAdjunto 
	FROM  PAT.PreguntaPAT AS P
	JOIN PAT.PreguntaPATDepartamento AS PD ON P.Id = PD.IdPreguntaPAT AND PD.IdDepartamento =@IdDepartamento
	INNER JOIN PAT.Derecho DERECHO ON P.IdDerecho = DERECHO.Id 
	INNER JOIN PAT.Componente COMPONENTE ON P.IdComponente= COMPONENTE.Id
	INNER JOIN PAT.Medida MEDIDA ON P.IdMedida = MEDIDA.Id 
	INNER JOIN PAT.UnidadMedida UNIDAD_MEDIDA ON P.IdUnidadMedida = UNIDAD_MEDIDA.Id
	LEFT OUTER JOIN PAT.Tablero AS  TABLERO ON P.IdTablero = TABLERO.Id	
	LEFT OUTER JOIN [PAT].[RespuestaPAT] AS R ON P.Id = R.IdPreguntaPAT AND R.IdDepartamento =  @IdDepartamento 	
	WHERE TABLERO.Id = @idTablero
	AND	P.NIVEL = 2 and P.ACTIVO = 1
END
go










