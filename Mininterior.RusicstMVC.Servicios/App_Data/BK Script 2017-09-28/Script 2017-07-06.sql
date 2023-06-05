GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosXRol]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosXRol] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date:	03/07/2017
-- Description:	Procedimiento que retorna la información de todos los usuario relacionados con un rol
--				aplica solo para usuarios alcaldias y gobernaciones. Quedan por fuera los usuarios 
--				analista, consulta y todos los que no tienen que ver con el proceso de cargue de info
-- ====================================================================================================
ALTER PROCEDURE [dbo].[C_UsuariosXRol]

	@IdRol VARCHAR(128),
	@Incluidos BIT

AS
	BEGIN
		
		IF(@Incluidos = 1)
			BEGIN
				SELECT
					 [U].[Id]
					,[U].[IdUser]
					,UPPER([U].[Username]) AS Usuario
					,UPPER([U].[Nombres]) Nombres
					,UPPER([TU].[Nombre]) TipoUsuario
					,UPPER([D].[Nombre]) Departamento
					,UPPER([M].[Nombre]) Municipio
				FROM
					[dbo].[Usuario] U
					INNER JOIN [dbo].[TipoUsuario] TU ON [U].[IdTipoUsuario] = [TU].[Id]
					LEFT OUTER JOIN [dbo].[Municipio] M ON [U].[IdMunicipio] = [M].[Id] 
					LEFT OUTER JOIN [dbo].[Departamento] D ON [U].[IdDepartamento] = [D].[Id]
				WHERE 
					([U].[IdEstado] <> 6)
					AND ([U].[IdEstado] <> 4)
					AND [U].[Activo] = 1
					AND [U].[IdUser] IN (SELECT [UserId] 
										 FROM [dbo].[AspNetUserRoles] 
										 WHERE [RoleId] = @IdRol)
				ORDER BY 
					[U].[UserName]
			END
		ELSE
			BEGIN
				SELECT
					 [U].[Id]
					,[U].[IdUser]
					,UPPER([U].[Username]) AS Usuario
					,UPPER([U].[Nombres]) Nombres
					,UPPER([TU].[Nombre]) TipoUsuario
					,UPPER([D].[Nombre]) Departamento
					,UPPER([M].[Nombre]) Municipio
				FROM
					[dbo].[Usuario] U
					INNER JOIN [dbo].[TipoUsuario] TU ON [U].[IdTipoUsuario] = [TU].[Id]
					LEFT OUTER JOIN [dbo].[Municipio] M ON [U].[IdMunicipio] = [M].[Id] 
					LEFT OUTER JOIN [dbo].[Departamento] D ON [U].[IdDepartamento] = [D].[Id]
				WHERE 
					([U].[IdEstado] <> 6)
					AND ([U].[IdEstado] <> 4)
					AND [U].[Activo] = 1
					AND [U].[IdUser] NOT IN (SELECT [UserId] 
											 FROM [dbo].[AspNetUserRoles] 
											 WHERE [RoleId] = @IdRol)
				ORDER BY 
					[U].[UserName]
			END
	
	END

GO

GO
BEGIN TRANSACTION
GO

if exists (select * from sys.columns where name='IdTablero' and Object_id in (select object_id from sys.tables where name ='RespuestaPAT'))
begin
	if exists (SELECT * FROM SYS.foreign_keys where name = 'FK_RespuestaPAT_Tablero')
	begin
		alter table pat.RespuestaPAT drop constraint FK_RespuestaPAT_Tablero
	end
	if exists (SELECT * FROM SYS.indexes where name = 'IDX_RespuestaPAT_Tablero')
	begin
		drop index IDX_RespuestaPAT_Tablero on PAT.RespuestaPAT
	end
		alter table PAT.RespuestaPAT drop column IdTablero
end
	
GO
ALTER TABLE PAT.RespuestaPAT SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_Derechos]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'drop PROCEDURE [PAT].[C_Derechos]'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [PAT].[C_Derechos] ( @idTablero tinyint)

AS

BEGIN

	SELECT 
		D.ID, D.DESCRIPCION
	FROM 
		[PAT].[Derecho] D
	WHERE
		D.ID 
			IN
			(
				SELECT DISTINCT PP.IDDERECHO
				FROM [PAT].[PreguntaPAT] pp
				WHERE PP.IDTABLERO = @idTablero				
			)
	ORDER BY D.Descripcion

END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_DatosExcel_Municipios]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'drop PROCEDURE [PAT].[C_DatosExcel_Municipios]'
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROC [PAT].[C_DatosExcel_Municipios] --506, 1
(
	@IdMunicipio INT, @IdTablero INT
)

AS
BEGIN

SELECT 
DISTINCT  
		--ID_PREGUNTA,ID_DERECHO,ID_COMPONENTE,ID_MEDIDA,NIVEL,PREGUNTA_INDICATIVA,ID_UNIDAD_MEDIDA,PREGUNTA_COMPROMISO,APOYO_DEPARTAMENTAL,APOYO_ENTIDAD_NACIONAL,ACTIVO,
		--DERECHO, COMPONENTE,MEDIDA,UNIDAD_MEDIDA,ID_TABLERO,ID_ENTIDAD,id_respuesta,RESPUESTA_INDICATIVA,RESPUESTA_COMPROMISO,PRESUPUESTO,OBSERVACION_NECESIDAD,ACCION_COMPROMISO
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
				INNER JOIN [PAT].[Derecho] D ON P.IDDERECHO = D.ID 
				INNER JOIN [PAT].[Componente] C ON P.IDCOMPONENTE = C.ID 
				INNER JOIN [PAT].[Medida] M ON P.IDMEDIDA = M.ID 
				INNER JOIN [PAT].[UnidadMedida] UM ON P.IDUNIDADMEDIDA = UM.ID 
				INNER JOIN PAT.Tablero AS T ON P.IDTABLERO = T.ID
				LEFT OUTER JOIN [PAT].[RespuestaPAT] as R on P.ID = R.[IdPreguntaPAT] and  R.IdMunicipio = @IdMunicipio 									
				LEFT OUTER JOIN [PAT].[RespuestaPATAccion] AS AA ON AA.[IdRespuestaPAT] = R.ID and AA.Activo = 1
				LEFT OUTER JOIN [PAT].[RespuestaPATPrograma] AS AP ON AP.[IdRespuestaPAT] = R.ID and AP.Activo = 1
				INNER JOIN Usuario AS U ON R.IdUsuario = U.Id  AND U.IdMunicipio = @IdMunicipio
				WHERE  T.ID = @IdTablero and
				P.NIVEL = 3 AND 1=pat.ValidarPreguntaRyR(P.IDMEDIDA,@IdMunicipio) ) AS A WHERE A.ACTIVO = 1  ORDER BY IDPREGUNTA

END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_ContarTableroMunicipioRC]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'drop PROCEDURE [PAT].[C_ContarTableroMunicipioRC]'
GO

-- =============================================
-- Author:			Cristhian.Navarrete
-- Create date:		22/08/2016
-- Modified date:	
-- Description:		Cuenta todas las preguntas del Tablero para paginacion de reparación colectiva
-- =============================================
CREATE PROCEDURE [PAT].[C_ContarTableroMunicipioRC] --46, ''
(@IdUsuario INT, @idTablero tinyint)

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @Cantidad INT, @IDENTIDAD INT, @ID_DANE INT
	
	SELECT @IDENTIDAD =[PAT].[fn_GetIdEntidad](@IdUsuario)
	SELECT @Cantidad = COUNT(1)
			FROM ( 		
				SELECT DISTINCT 
					P.ID AS IDPREGUNTA, 
					P.[IdMunicipio] AS IDDANE, 
					P.IDMEDIDA, 
					P.SUJETO, 
					P.[MedidaReparacionColectiva] AS MEDIDARC, 
					M.DESCRIPCION AS MEDIDA, 
					T.ID AS IDTABLERO,
					CASE WHEN R.IdMunicipio IS NULL THEN @IDENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
					R.ID,
					R.ACCION, 
					R.PRESUPUESTO
				FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
					LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] AS R ON P.ID= R.[IdPreguntaPATReparacionColectiva] AND R.[IdMunicipio] = @IDENTIDAD,
					[PAT].[Medida] M,
					[PAT].[Tablero] T
				WHERE	P.IDMEDIDA = M.ID 
					AND P.[IdMunicipio] = @IDENTIDAD
					AND P.IDTABLERO = T.ID
					AND T.ID = @idTablero
				AND P.Id > 2242
			) as a
	SELECT @Cantidad
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroMunicipioRC]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'drop PROCEDURE [PAT].[C_TableroMunicipioRC]'
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene las preguntas para la gestión del tablero PAT de responsabilidad Colectiva	
-- =============================================

create PROCEDURE [PAT].[C_TableroMunicipioRC]-- NULL, 1, 20, 46, 'Reparación Integral',1
 (@sortOrder VARCHAR(30),  @page SMALLINT,  @pageSize SMALLINT,  @IdUsuario INT, @IdDerecho INT, @idTablero tinyint)

AS
BEGIN

	SET NOCOUNT ON;
	
	DECLARE @NIVEL INT = 3

	DECLARE @RESULTADO TABLE (
		LINEA INT,
		IDPREGUNTARC SMALLINT,
		IDDANE INT,
		IDMEDIDA SMALLINT,
		SUJETO NVARCHAR(3000),
		MEDIDARC NVARCHAR(2000),
		MEDIDA NVARCHAR(500),
		IDTABLERO TINYINT,
		IDENTIDAD INT,
		ID INT,
		ACCION NVARCHAR(4000),
		PRESUPUESTO MONEY
		)
	
	DECLARE  @SQL NVARCHAR(MAX)
	DECLARE  @PARAMETROS NVARCHAR(MAX)
	DECLARE @IDDANE INT, @IDENTIDAD INT
	
	--SELECT @IDDANE= [PAT].[fn_GetDaneMunicipioEntidad](@IdUsuario)
	SELECT @IDENTIDAD =[PAT].[fn_GetIdEntidad](@IdUsuario)

	DECLARE @PAGINA INT, @ORDEN VARCHAR(100)
	SET @PAGINA = (@page - 1) * @pageSize


	SET @ORDEN = @sortOrder
	IF @ORDEN = '' or @ORDEN is NULL
		SET @ORDEN = 'IDPREGUNTA'

	IF  @IdDerecho = 6
	BEGIN
		SET @SQL = 'SELECT  TOP (@TOP) A.LINEA,
				A.IDPREGUNTA, 
				A.IDDANE,
				A.IDMEDIDA,
				A.SUJETO,
				A.MEDIDARC,
				A.MEDIDA,
				A.IDTABLERO,
				A.IDENTIDAD,
				A.ID,
				A.ACCION,
				A.PRESUPUESTO 
					FROM (SELECT DISTINCT row_number() OVER (ORDER BY P.ID) AS LINEA, 
							P.ID AS IDPREGUNTA, 
							P.[IdMunicipio] AS IDDANE, 
							P.IDMEDIDA, 
							P.SUJETO, 
							P.[MedidaReparacionColectiva] AS MEDIDARC, 
							M.DESCRIPCION AS MEDIDA, 
							T.ID AS IDTABLERO,
							CASE WHEN R.IdMunicipio IS NULL THEN @IDENTIDAD ELSE R.IdMunicipio END AS IDENTIDAD,
							R.ID,
							R.ACCION, 
							R.PRESUPUESTO
						FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
							LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] AS R ON P.ID= R.[IdPreguntaPATReparacionColectiva] AND R.[IdMunicipio] = @IDENTIDAD,
							[PAT].[Medida] M,
							[PAT].[Tablero] T
						WHERE	P.IDMEDIDA = M.ID 
							AND P.[IdMunicipio] = @IDENTIDAD
							AND P.IDTABLERO = T.ID
							AND T.ID = @idTablero'
		SET @SQL =@SQL +') AS A WHERE A.LINEA >@PAGINA  AND A.IDPREGUNTA > 2242 ORDER BY A.LINEA ASC'-- AND IDPREGUNTA > 2242
		SET @PARAMETROS = '@TOP INT, @PAGINA INT,@idTablero tinyint,@IDENTIDAD INT'		
		PRINT @SQL
		INSERT INTO @RESULTADO
		EXECUTE sp_executesql @SQL, @PARAMETROS, @TOP = @pageSize, @PAGINA= @PAGINA, @idTablero=@idTablero, @IDENTIDAD=@IDENTIDAD
	END
	SELECT * from @RESULTADO
END

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_TableroVigencia]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'drop PROCEDURE [PAT].[C_TableroVigencia]'
GO

-- =============================================
-- Author:			cristhian.navarrete
-- Create date:		08/08/2016
-- Modified date:	22/08/2016
-- Description:		Obtiene el tablero vigente
-- =============================================
CREATE PROCEDURE [PAT].[C_TableroVigencia] 
 (@idTablero tinyint)
AS
BEGIN
	SELECT	YEAR(P.VIGENCIAINICIO) ANNO,
			(CONVERT(VARCHAR(10), P.VIGENCIAINICIO, 103) + ' AL ' + CONVERT(VARCHAR(10), P.VIGENCIAFIN, 103)) VIGENCIA
	FROM [PAT].[Tablero] P
	WHERE	 P.Id=@idTablero
END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[C_RolXEncuesta]') AND TYPE in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_RolXEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Equipo de desarrollo OIM - John Betancourt
-- Create date: 14/06/2017
-- Description:	Obtiene los roles de la encuesta permitidos por encuesta
-- =============================================
ALTER PROCEDURE [dbo].[C_RolXEncuesta] 

	@IdEncuesta	 INT

AS
	BEGIN
	
		SET NOCOUNT ON;

		SELECT 
			A.Id IdRol, A.Name Nombre
		FROM Roles.RolEncuesta R
		INNER JOIN AspNetRoles A ON A.Id = R.IdRol

		WHERE
			IdEncuesta = @IdEncuesta

	END	

GO 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[C_SeccionExcelEncuesta]') AND TYPE in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_SeccionExcelEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - John Betancourt A.																	 
-- Fecha creacion: 2017-07-04
-- Descripcion: Trae el excel a descargar
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_SeccionExcelEncuesta]

	 @IdSeccion	INT
	
AS

	SELECT 
		  Archivo
	FROM 
		[dbo].[Seccion] AS s
	WHERE 
		s.Id = @IdSeccion

GO

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[C_DibujarPreguntasSeccion]') AND TYPE in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarPreguntasSeccion] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Rafael Alba																	 
-- Fecha creacion: 2017-07-03																			 
-- Descripcion: Trae las preguntas a dibujar por idseccion
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DibujarPreguntasSeccion]

	 @IdSeccion	INT

AS
BEGIN

	SELECT 
		P.[Id]	
		,[IdSeccion]
		,P.[Nombre]
		,[RowIndex]
		,[ColumnIndex]
		,TP.[Nombre] AS TipoPregunta
		,[Ayuda]
		,[EsObligatoria]
		,[EsMultiple]
		,[SoloSi]
		,[Texto]
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
  WHERE 
	IdSeccion = @IdSeccion

END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosHistoricoSolicitudes]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosHistoricoSolicitudes] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==============================================================================================================
-- Autor : Equipo de desarrollo OIM - Christian Ospina
-- Fecha : 2017-04-05																			 
-- Descripción: Consulta la información de los usuarios que tienen algún 																 
--==============================================================================================================
ALTER PROC [dbo].[C_UsuariosHistoricoSolicitudes]

AS
	BEGIN
		SELECT
--======================================================================================
-- ORDEN DE LA CONSULTA NECESARIA PARA QUE SE MUESTRE EN ESTE MISMO ORDEN EN LA REJILLA
--=======================================================================================
			 [U].[Nombres]
			,[U].[FechaSolicitud]
			,[U].[Cargo]
			,[U].[TelefonoFijo]
			,[T].[Nombre] TipoUsuario
			,[U].[TelefonoCelular]
			,[U].[Email]
			,[M].[Nombre] Municipio
			,[D].[Nombre] Departamento
			,[U].[DocumentoSolicitud]
--=======================================================================================
			,[U].[Id]
			,[E].[Nombre] Estado
			,[UTramite].[UserName]	UsuarioTramite		
			,[U].[TelefonoFijoIndicativo]
			,[U].[TelefonoFijoExtension]
			,[U].[EmailAlternativo]
			,[U].[Activo]
			,[U].[FechaNoRepudio]
			,[U].[FechaTramite]
			,[U].[FechaConfirmacion]	
		FROM 
			[dbo].[Usuario] U
			LEFT JOIN [dbo].[TipoUsuario] T ON [U].[IdTipoUsuario] = [T].[Id]
			LEFT JOIN [dbo].[Estado] E ON [U].[IdEstado] = [E].[Id]	
			LEFT JOIN [dbo].[Departamento] D ON [D].[Id] = [U].[IdDepartamento]
			LEFT JOIN [dbo].[Municipio] M ON [M].[Id] = [U].[IdMunicipio]
			LEFT JOIN [dbo].[Usuario] UTramite ON [UTramite].[Id] = [U].[IdUsuarioTramite] 
		ORDER BY 
			U.Nombres 
	END

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosEnSistema]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosEnSistema] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Robinson Moscoso
-- Create date:	31/01/2017
-- Description:	Procedimiento que retorna la información de todos los usuario en el sistema
-- =============================================
ALTER PROCEDURE [dbo].[C_UsuariosEnSistema] 

AS
	BEGIN
		
		SELECT
			 [c].[Nombre] AS Departamento
			,[b].[Nombre] AS Municipio
			,[a].[Nombres] AS NombreDeUsuario
			,[a].[UserName] Nombre 
			,[a].[Email]
			,[a].[TelefonoCelular]
			,[d].[Nombre] TipoUsuario
			,[a].[Activo]
		FROM
			[dbo].[Usuario] a
			INNER JOIN [dbo].[TipoUsuario] d ON [a].[IdTipoUsuario] = [d].[Id]
			LEFT OUTER JOIN [dbo].[Municipio] b ON [a].[IdMunicipio] = [b].[Id] 
			LEFT OUTER JOIN [dbo].[Departamento] c ON [a].[IdDepartamento] = [c].[Id]
		WHERE 
			([a].[IdEstado] <> 6)
			AND ([a].[IdEstado] <> 4)
		ORDER BY 
			 [Departamento]
			,[Municipio]
			,[a].[Username]
	
	END
		

GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_UsuarioDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_UsuarioDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Update Author: Equipo de desarrollo OIM - Christian Ospina
-- Update date: 30/03/2017
-- Description:	En la primera sentencia, elimina el usuario porque no fué posible enviar el correo
--				En la segunda sentencia, cambia de estado al registro a estado RETIRADO. Lo inactiva
--				y coloca el usuario que realizó la operación en el RUSICST
-- ================================================================================================
ALTER PROCEDURE [dbo].[D_UsuarioDelete]
	
	 @Id INT
	,@IdUsuarioTramite INT = NULL

AS
	BEGIN
		
		SET NOCOUNT ON;

		DECLARE @respuesta AS NVARCHAR(2000) = ''
		DECLARE @estadoRespuesta  AS INT = 0 
		DECLARE @esValido AS BIT = 1
	
		--======================================================================================
		-- ESTA ELIMINACION ES UTILIZADA PARA REVERSAR EL PROCESO DE REGISTRO. SE EJECUTA SI EL
		-- CORREO ELECTRONICO QUE SE LE ENVIA AL USUARIO NO FUE ENVIADO POR EL SISTEMA
		--======================================================================================
		IF(@esValido = 1 AND @IdUsuarioTramite IS NULL) 
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY
					DELETE [dbo].[Usuario] 
					WHERE [Id] = @Id

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
		
		--======================================================== 
		-- Realiza la inactivación del usuario colocandolo como   
		-- retirado y coloca el usuario que realiza la operación.
		--========================================================
		IF(@estadoRespuesta = 0)
			BEGIN
				BEGIN TRANSACTION
				BEGIN TRY
					UPDATE [dbo].[Usuario] 
					SET 
						 [Activo] = 0
						,[IdEstado] = (SELECT TOP 1 Id FROM [Estado] WHERE [Nombre] = 'Retiro')
						,[FechaRetiro] = GETDATE()
						,[IdUsuarioTramite] = @IdUsuarioTramite
					WHERE [Id] = @Id

					SELECT @respuesta = 'Se ha retirado el registro'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_CampanaEmailInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_CampanaEmailInsert] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date: 21/02/2017
-- Description:	Inserta un registro en Campaña Email 
--				Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
--				@estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
--				respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'	
-- ================================================================================================
ALTER PROCEDURE [dbo].[I_CampanaEmailInsert] 
	
	 @IdUsuario		INT
	,@IdTipoUsuario	INT
	,@Asunto		VARCHAR(255)
	,@Mensaje		TEXT
	,@Total			INT
	,@Enviados		INT

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

					INSERT INTO [dbo].[CampanaEmail] ([IdUsuario], [IdTipoUsuario], [Asunto], [Mensaje], [Fecha], [Total], [Enviados])
					SELECT @IdUsuario, @IdTipoUsuario, @Asunto, @Mensaje, GETDATE(), @Total, @Enviados

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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosXRol]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosXRol] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================================================================
-- Author:		Equipo de desarrollo OIM - Christian Ospina
-- Create date:	03/07/2017
-- Description:	Procedimiento que retorna la información de todos los usuario relacionados con un rol
--				aplica solo para usuarios alcaldias y gobernaciones. Quedan por fuera los usuarios 
--				analista, consulta y todos los que no tienen que ver con el proceso de cargue de info
-- ====================================================================================================
ALTER PROCEDURE [dbo].[C_UsuariosXRol]

	@IdRol VARCHAR(128),
	@Incluidos BIT

AS
	BEGIN
		
		IF(@Incluidos = 1)
			BEGIN
				SELECT
					 [U].[Id]
					,[U].[IdUser]
					,UPPER([U].[Username]) AS Usuario
					,UPPER([U].[Nombres]) Nombres
					,UPPER([TU].[Nombre]) TipoUsuario
					,UPPER([D].[Nombre]) Departamento
					,UPPER([M].[Nombre]) Municipio
				FROM
					[dbo].[Usuario] U
					INNER JOIN [dbo].[TipoUsuario] TU ON [U].[IdTipoUsuario] = [TU].[Id]
					LEFT OUTER JOIN [dbo].[Municipio] M ON [U].[IdMunicipio] = [M].[Id] 
					LEFT OUTER JOIN [dbo].[Departamento] D ON [U].[IdDepartamento] = [D].[Id]
				WHERE 
					([U].[IdEstado] <> 6)
					AND ([U].[IdEstado] <> 4)
					AND [U].[Activo] = 1
					AND [U].[IdUser] IN (SELECT [UserId] 
										 FROM [dbo].[AspNetUserRoles] 
										 WHERE [RoleId] = @IdRol)
					AND [U].[IdUser] IS NOT NULL
				ORDER BY 
					[U].[UserName]
			END
		ELSE
			BEGIN
				SELECT
					 [U].[Id]
					,[U].[IdUser]
					,UPPER([U].[Username]) AS Usuario
					,UPPER([U].[Nombres]) Nombres
					,UPPER([TU].[Nombre]) TipoUsuario
					,UPPER([D].[Nombre]) Departamento
					,UPPER([M].[Nombre]) Municipio
				FROM
					[dbo].[Usuario] U
					INNER JOIN [dbo].[TipoUsuario] TU ON [U].[IdTipoUsuario] = [TU].[Id]
					LEFT OUTER JOIN [dbo].[Municipio] M ON [U].[IdMunicipio] = [M].[Id] 
					LEFT OUTER JOIN [dbo].[Departamento] D ON [U].[IdDepartamento] = [D].[Id]
				WHERE 
					([U].[IdEstado] <> 6)
					AND ([U].[IdEstado] <> 4)
					AND [U].[Activo] = 1
					AND [U].[IdUser] NOT IN (SELECT [UserId] 
											 FROM [dbo].[AspNetUserRoles] 
											 WHERE [RoleId] = @IdRol)
					AND [U].[IdUser] IS NOT NULL
				ORDER BY 
					[U].[UserName]
			END
	
	END

GO

	

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_SeccionDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_SeccionDelete] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--*****************************************************************************************************
-- Autor: John Betancourt A. OIM																		  
-- Fecha creacion: 2017-06-27
-- Descripcion: Actualiza la información de la Seccion												  
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
--*****************************************************************************************************

ALTER PROCEDURE [dbo].[D_SeccionDelete] 

	@Id INT

AS 

	DECLARE @respuesta AS NVARCHAR(2000) = ''
	DECLARE @estadoRespuesta  AS INT = 0 
	DECLARE @esValido AS BIT = 1
	
	IF EXISTS(SELECT 1 FROM [dbo].[Respuesta] WHERE [IdPregunta] IN (SELECT [Id] FROM [dbo].[Pregunta] WHERE [IdSeccion] = @Id))
	BEGIN
		SET @esValido = 0
		SET @respuesta += 'No es posible eliminar el registro. Se encontraron datos asociados.'
	END
	ELSE
	BEGIN
		EXEC D_ContenidoSeccionDelete @Id
	END

	IF(@esValido = 1) BEGIN
		BEGIN TRANSACTION
		BEGIN TRY
			DELETE FROM [dbo].Seccion
						WHERE [Id] = @Id

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