IF  NOT EXISTS (select 1 from sys.columns where Name = N'IdUsuarioHistorico' and Object_ID = Object_ID(N'dbo.Usuario'))
BEGIN
	BEGIN TRANSACTION
	   ALTER TABLE [dbo].[Usuario] ADD
	    IdUsuarioHistorico int NULL
	COMMIT
END

GO

IF NOT EXISTS (SELECT * FROM [SubRecurso] WHERE Nombre = 'Histórico Usuario')
	INSERT INTO [dbo].[SubRecurso] ([Nombre],[Url],[IdRecurso]) VALUES ('Histórico Usuario', null, (SELECT Id FROM [Recurso] WHERE Nombre = 'Usuarios'))

GO

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[U_UsuarioUpdate]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[U_UsuarioUpdate] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================  
-- Author:  Equipo de desarrollo OIM - Christian Ospina  
-- Create date: 21/02/2017  
-- Description: Actualiza un registro en Usuarios  
--    Retorna: select @respuesta as respuesta, @estadoRespuesta as estado            
--    @estadoRespuesta int = 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado            
--    respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'   
-- MOodifica:  John betancourt OIM 07/02/2018
-- ================================================================================================  
ALTER PROCEDURE [dbo].[U_UsuarioUpdate]   
   
  @Id     INT = NULL  
 ,@IdUser    VARCHAR(128) = NULL  
 ,@IdTipoUsuario   INT = NULL  
 ,@IdDepartamento  INT = NULL   
 ,@IdMunicipio   INT = NULL   
 ,@IdEstado    INT = NULL  
 ,@IdUsuarioTramite  INT = NULL  
 ,@UserName    VARCHAR(255) = NULL   
 ,@Nombres    VARCHAR(255) = NULL  
 ,@Cargo     VARCHAR(255) = NULL   
 ,@TelefonoFijo   VARCHAR(255) = NULL   
 ,@TelefonoFijoIndicativo VARCHAR(255) = NULL  
 ,@TelefonoFijoExtension VARCHAR(255) = NULL    
 ,@TelefonoCelular  VARCHAR(255) = NULL   
 ,@Email     VARCHAR(255) = NULL   
 ,@EmailAlternativo  VARCHAR(255) = NULL   
 ,@Enviado    BIT = NULL  
 ,@DatosActualizados  BIT = NULL  
 ,@Token     UNIQUEIDENTIFIER = NULL  
 ,@Activo    BIT = NULL  
 ,@DocumentoSolicitud VARCHAR(60)  
 ,@FechaSolicitud  DATETIME = NULL  
 ,@FechaNoRepudio  DATETIME = NULL  
 ,@FechaTramite   DATETIME = NULL  
 ,@FechaRetiro   DATETIME = NULL  
 ,@FechaConfirmacion  DATETIME = NULL  
 ,@NombreGrupo   VARCHAR(50) = NULL  
 ,@NombreParametro  VARCHAR(50) = NULL  
 ,@IdUsuarioHistorico  INT = NULL  
  
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
      [dbo].[Usuario]   
     SET   
       [IdUser] = CASE WHEN @FechaRetiro IS NOT NULL THEN NULL ELSE ISNULL(@IdUser, [IdUser]) END  
      ,[IdDepartamento] = ISNULL(@IdDepartamento, [IdDepartamento])  
      ,[IdMunicipio] = ISNULL(@IdMunicipio, [IdMunicipio])  
      ,[IdEstado] = ISNULL(@IdEstado, [IdEstado])  
       --=================================================================================  
       -- EL CASE ES UTILIZADO PARA VALIDAR SI LA ACTUALIZACION OBEDECE A UNA REVERSION.   
       -- SE DEBE HACER SI AL MOMENTO DE REMITIR, EL CORREO NO ES ENVIADO AL DESTINATARIO  
       --=================================================================================  
      ,[IdUsuarioTramite] = CASE WHEN @IdEstado = 2 THEN NULL ELSE ISNULL(@IdUsuarioTramite, [IdUsuarioTramite]) END  
      ,[IdTipoUsuario] = CASE WHEN @IdEstado = 2 THEN NULL ELSE ISNULL(@IdTipoUsuario, [IdTipoUsuario]) END  
      ,[FechaTramite] = CASE WHEN @IdEstado = 2 THEN NULL ELSE ISNULL(@FechaTramite, [FechaTramite]) END  
      --==================================================================================  
      ,[UserName] = ISNULL(@UserName, [UserName])  
      ,[Nombres] = ISNULL(@Nombres, [Nombres])  
      ,[Cargo] = ISNULL(@Cargo, [Cargo])  
      ,[TelefonoFijo] = ISNULL(@TelefonoFijo, [TelefonoFijo])  
      ,[TelefonoFijoIndicativo] = ISNULL(@TelefonoFijoIndicativo, [TelefonoFijoIndicativo])  
      ,[TelefonoFijoExtension] = ISNULL(@TelefonoFijoExtension, [TelefonoFijoExtension])  
      ,[TelefonoCelular] = ISNULL(@TelefonoCelular, [TelefonoCelular])  
      ,[Email] = ISNULL(@Email, [Email])  
      ,[EmailAlternativo] = ISNULL(@EmailAlternativo, [EmailAlternativo])  
      ,[Enviado] = ISNULL(@Enviado, [Enviado])  
      ,[DatosActualizados] = ISNULL(@DatosActualizados, [DatosActualizados])  
      ,[Token] = ISNULL(@Token, [Token])  
      ,[Activo] = ISNULL(@Activo, [Activo])  
      ,[DocumentoSolicitud] = ISNULL(@DocumentoSolicitud, [DocumentoSolicitud])  
      ,[FechaSolicitud] = ISNULL(@FechaSolicitud, [FechaSolicitud])  
      ,[FechaNoRepudio] = ISNULL(@FechaNoRepudio, [FechaNoRepudio])  
      ,[FechaConfirmacion] = ISNULL(@FechaConfirmacion, [FechaConfirmacion])  
      ,[FechaRetiro] = ISNULL(@FechaRetiro, [FechaRetiro])  
	  ,[IdUsuarioHistorico] = ISNULL(@IdUsuarioHistorico, [IdUsuarioHistorico])  
     WHERE   
      [Id] = @Id  
       
     --===============================================================================  
     -- Obtiene el mensaje que esta configurado en la tabla de parámetros del sistema  
     --===============================================================================  
     IF(@NombreGrupo IS NOT NULL AND @NombreParametro IS NOT NULL)  
      BEGIN  
       SELECT @respuesta = [PS].[ParametroValor]  
       FROM [ParametrizacionSistema].[ParametrosSistema] PS  
       INNER JOIN [ParametrizacionSistema].[ParametrosSistemaGrupos] PSG ON [PS].[IdGrupo] = [PSG].[Id]  
       WHERE [PSG].[NombreGrupo] = @NombreGrupo  
       AND [NombreParametro] = @NombreParametro  
      END  
     ELSE  
      BEGIN  
       SELECT @respuesta = 'Se ha actualizado el registro'  
      END  
  
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

 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_UsuariosHistoricoUsuarioSolicitudes]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_UsuariosHistoricoUsuarioSolicitudes] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================  
-- Autor: Equipo de desarrollo OIM - John Betancourt A. 
-- Fecha creacion: 2018-02-07
-- Descripcion: Obtiene el historico de usuarios con su nombre y datos                     
--====================================================================================================  
ALTER PROC [dbo].[C_UsuariosHistoricoUsuarioSolicitudes]  
  @IdDepartamento INT = null,
  @IdMunicipio INT = null,
  @IdTipoUsuario INT = null
AS  
 BEGIN  
  SELECT  
--======================================================================================  
-- ORDEN DE LA CONSULTA NECESARIA PARA QUE SE MUESTRE EN ESTE MISMO ORDEN EN LA REJILLA  
--=======================================================================================  
    [U].[UserName]  
   ,[U].[Nombres]  
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
   ,[UTramite].[UserName] UsuarioTramite    
   ,[U].[TelefonoFijoIndicativo]  
   ,[U].[TelefonoFijoExtension]  
   ,[U].[EmailAlternativo]  
   ,[U].[Activo]  
   ,[U].[FechaNoRepudio]  
   ,[U].[FechaTramite]  
   ,[U].[FechaConfirmacion]   
   ,[U].IdUsuarioHistorico
  FROM   
   [dbo].[Usuario] U  
   LEFT JOIN [dbo].[TipoUsuario] T ON [U].[IdTipoUsuario] = [T].[Id]  
   LEFT JOIN [dbo].[Estado] E ON [U].[IdEstado] = [E].[Id]   
   LEFT JOIN [dbo].[Departamento] D ON [D].[Id] = [U].[IdDepartamento]  
   LEFT JOIN [dbo].[Municipio] M ON [M].[Id] = [U].[IdMunicipio]  
   LEFT JOIN [dbo].[Usuario] UTramite ON [UTramite].[Id] = [U].[IdUsuarioTramite]
   WHERE U.UserName is not null
	AND (@IdDepartamento IS NULL OR [U].[IdDepartamento] = @IdDepartamento)  
	AND (@IdMunicipio IS NULL OR [U].[IdMunicipio] = @IdMunicipio)  
	AND (@IdTipoUsuario IS NULL OR [U].[IdTipoUsuario] = @IdTipoUsuario)  
  ORDER BY   
   [U].[FechaConfirmacion] DESC  
 END  
  
 GO

  IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_HistoricoXUsuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_HistoricoXUsuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================  
-- Autor: Equipo de desarrollo OIM - John Betancourt A. 
-- Fecha creacion: 2018-02-07
-- Descripcion: Obtiene el historico de usuarios con su nombre y datos                     
--====================================================================================================  
ALTER PROC [dbo].[C_HistoricoXUsuario]  
  @IdUsername varchar(50)
AS  
 BEGIN  
  SELECT  
--======================================================================================  
-- ORDEN DE LA CONSULTA NECESARIA PARA QUE SE MUESTRE EN ESTE MISMO ORDEN EN LA REJILLA  
--=======================================================================================  
    [U].[UserName]  
   ,[U].[Nombres]  
   ,[U].[FechaSolicitud]  
   ,[U].[Cargo]  
   ,[U].[TelefonoFijo]  
   ,[T].[Nombre] TipoUsuario  
   ,[U].[TelefonoCelular]  
   ,[U].[Email]  
   ,[M].[Nombre] Municipio  
   ,[D].[Nombre] Departamento    
--=======================================================================================  
   ,[U].[Id]  
   ,[E].[Nombre] Estado  
   ,[UTramite].[UserName] UsuarioTramite    
   ,[U].[TelefonoFijoIndicativo]  
   ,[U].[TelefonoFijoExtension]  
   ,[U].[EmailAlternativo]  
   ,[U].[Activo]  
   ,[U].[FechaNoRepudio]  
   ,[U].[FechaTramite]  
   ,[U].[FechaConfirmacion]   
   ,[U].IdUsuarioHistorico
  FROM   
   [dbo].[Usuario] U  
   LEFT JOIN [dbo].[TipoUsuario] T ON [U].[IdTipoUsuario] = [T].[Id]  
   LEFT JOIN [dbo].[Estado] E ON [U].[IdEstado] = [E].[Id]   
   LEFT JOIN [dbo].[Departamento] D ON [D].[Id] = [U].[IdDepartamento]  
   LEFT JOIN [dbo].[Municipio] M ON [M].[Id] = [U].[IdMunicipio]  
   LEFT JOIN [dbo].[Usuario] UTramite ON [UTramite].[Id] = [U].[IdUsuarioTramite]
   WHERE U.UserName = @IdUsername
  ORDER BY   
   [U].[FechaConfirmacion] DESC  
 END  
  
 GO


   IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_Usuario]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_Usuario] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 --==============================================================================================================
-- Autor : Christian Ospina
-- Fecha : 2017-04-05																			 
-- Descripción: Consulta la información de los usuarios para la rejilla de usuarios de acuerdo a los criterios
--				de filtro. Retira los usuarios que se encuentran retirados y rechazados			
-- Modifica: Equipo de desarrollo OIM - John Betancourt A. 
-- Fecha modificacion: 2018-02-07
-- Descripcion: Obtiene el historico de usuarios con su nombre y datos   													 
--==============================================================================================================
ALTER PROC [dbo].[C_Usuario]

	 @Id			INT = NULL
	,@Token			UNIQUEIDENTIFIER = NULL
	,@IdTipoUsuario	INT = NULL
	,@IdDepartamento INT = NULL
	,@IdMunicipio	INT = NULL
	,@UserName		VARCHAR(128) = NULL
	,@IdEstado		INT = NULL

AS
	BEGIN
		SELECT
			 [UserName]
--======================================================================================
-- ORDEN DE LA CONSULTA NECESARIA PARA QUE SE MUESTRE EN ESTE MISMO ORDEN EN LA REJILLA
--=======================================================================================
			,[Nombres]
			,[FechaSolicitud]
			,[Cargo]
			,[TelefonoFijo]
			,[T].[Nombre] TipoUsuario
			,[TelefonoCelular]
			,[Email]
			,[M].[Nombre] Municipio
			,[D].[Nombre] Departamento
			,[DocumentoSolicitud]
--=======================================================================================
			,[U].[Id]
			,[IdUser]
			,[IdTipoUsuario]
			,[U].[IdDepartamento]
			,[U].[IdMunicipio]
			,[U].[IdEstado]
			,[E].[Nombre] Estado
			,[IdUsuarioTramite]			
			,[TelefonoFijoIndicativo]
			,[TelefonoFijoExtension]
			,[EmailAlternativo]
			,[Enviado]
			,[DatosActualizados]
			,[Token]
			,[U].[Activo]
			,[FechaNoRepudio]
			,[FechaTramite]
			,[FechaConfirmacion]
			,T.Tipo AS TipoTipoUsuario	
			,U.IdUsuarioHistorico
		FROM 
			[dbo].[Usuario] U
			LEFT JOIN [dbo].[TipoUsuario] T ON [U].[IdTipoUsuario] = [T].[Id]
			LEFT JOIN [dbo].[Estado] E ON [U].[IdEstado] = [E].[Id]	
			LEFT JOIN [dbo].[Departamento] D on [D].[Id] = [U].[IdDepartamento]
			LEFT JOIN [dbo].[Municipio] M on [M].[Id] = [U].[IdMunicipio]
		WHERE 
			(@Id IS NULL OR [U].[Id] = @Id) 
			AND (@Token IS NULL OR [U].[Token] = @Token) 
			AND (@IdTipoUsuario IS NULL OR [U].[IdTipoUsuario] = @IdTipoUsuario) 
			AND (@IdDepartamento IS NULL OR [U].[IdDepartamento]  = @IdDepartamento )
			AND (@IdMunicipio IS NULL OR [U].[IdMunicipio] = @IdMunicipio)
			AND (@UserName IS NULL OR [U].[UserName] = @UserName)
			AND (@IdEstado IS NULL OR [U].[IdEstado] = @IdEstado)
			AND ([U].[IdEstado] <> 6) -- RETIRADO
			AND ([U].[IdEstado] <> 4) -- RECHAZADO
			AND (@Token IS NOT NULL OR [U].[IdEstado] <> 1) -- SOLICITADA

		ORDER BY 
			U.Nombres 
	END


	GO


 IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_PreguntasSeccionEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_PreguntasSeccionEncuesta] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--====================================================================================================  
-- Autor: Equipo de desarrollo OIM - John Betancourt A. 
-- Fecha creacion: 2018-02-09
-- Descripcion: Obtiene las preguntas segun los filtros dados
--====================================================================================================  
ALTER PROCEDURE [dbo].[C_PreguntasSeccionEncuesta]   
 @idEncuesta  INT = NULL,  
 @idGrupo  INT = NULL,   
 @idseccion  INT = NULL,  
 @idSubseccion INT = NULL,  
 @nombrePregunta VARCHAR(400) = NULL,  
 @idPregunta INT = NULL,  
 @codigoBanco varchar(20) = NULL  
  
AS  
  
 SET NOCOUNT ON;   
BEGIN
   SELECT 
     a.Id  
    ,ISNULL(CONVERT(INT, e.CodigoPregunta), 0) AS IdPregunta  
    ,a.Texto   
    ,f.Nombre TipoPregunta  
    ,CASE WHEN a.EsObligatoria = 1 THEN 'Si' ELSE 'No' END  Obligatoria  
    ,a.SoloSi AS Validacion  
    ,a.Nombre
	,c.Titulo Pagina
	,ss.Titulo Seccion
	,et.Titulo Etapa
   FROM   
    dbo.Pregunta a   
    INNER JOIN dbo.TipoPregunta f ON a.IdTipoPregunta = f.Id  
    INNER JOIN dbo.Seccion c ON c.Id = a.IdSeccion  
	LEFT JOIN dbo.Seccion SS ON SS.Id = c.SuperSeccion
	LEFT JOIN dbo.Seccion et ON et.Id = SS.SuperSeccion
    LEFT OUTER JOIN BancoPreguntas.PreguntaModeloAnterior b ON b.IdPreguntaAnterior = a.Id  
    INNER JOIN BancoPreguntas.Preguntas e ON e.IdPregunta = b.IdPregunta  
   WHERE 
   (@idEncuesta IS NULL OR c.IdEncuesta = @idEncuesta)  
	AND (@idGrupo IS NULL OR C.SuperSeccion IN (SELECT Id FROM Seccion WHERE IdEncuesta = @idEncuesta AND SuperSeccion IN (SELECT Id FROM Seccion WHERE IdEncuesta = @idEncuesta AND Id = @idGrupo)))
	AND (@idseccion IS NULL OR c.SuperSeccion = @idseccion)  
	AND (@idSubseccion IS NULL OR c.Id = @idSubseccion)  
	AND (@idPregunta IS NULL OR a.Id = @idPregunta)  
	AND (@codigoBanco IS NULL OR e.CodigoPregunta = @codigoBanco)  
END  

  GO