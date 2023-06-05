/*****************************************************************************************************
* esto es para correr en la base de datos donde se tiene el log
*****************************************************************************************************/
SET IDENTITY_INSERT [dbo].[Category] ON 
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (340, N'Borra precargue de respuesta de encuestas', 208)
	INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Ordinal]) VALUES (341, N'Inserta precargue de respuesta de encuestas', 209)	
SET IDENTITY_INSERT [dbo].[Category] OFF

/*****************************************************************************************************
* esto es para correr en la base de datos normal
*****************************************************************************************************/


IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Precargue Respuestas' AND IdRecurso = 4)
BEGIN
	--SET IDENTITY_INSERT [dbo].[SubRecurso] ON	
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso]) VALUES (103, 'Precargue Respuestas', NULL, 4)
	--SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END
go
CREATE TABLE dbo.PrecargueRespuestaEncuesta
	(
	IdEncuesta int NOT NULL,
	IdPregunta int NOT NULL,
	IdUsuario int NOT NULL,
	Valor varchar(1000) NOT NULL,
	FechaIngreso datetime NOT NULL,
	IdUsuarioIngreso int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.PrecargueRespuestaEncuesta ADD CONSTRAINT
	PK_PrecargueRespuestaEncuesta PRIMARY KEY CLUSTERED 
	(
	IdEncuesta,
	IdPregunta,
	IdUsuario
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.PrecargueRespuestaEncuesta ADD CONSTRAINT
	FK_PrecargueRespuestaEncuesta_Pregunta FOREIGN KEY
	(
	IdPregunta
	) REFERENCES dbo.Pregunta
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.PrecargueRespuestaEncuesta ADD CONSTRAINT
	FK_PrecargueRespuestaEncuesta_Encuesta FOREIGN KEY
	(
	IdEncuesta
	) REFERENCES dbo.Encuesta
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.PrecargueRespuestaEncuesta ADD CONSTRAINT
	FK_PrecargueRespuestaEncuesta_Usuario FOREIGN KEY
	(
	IdUsuario
	) REFERENCES dbo.Usuario
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.PrecargueRespuestaEncuesta ADD CONSTRAINT
	FK_PrecargueRespuestaEncuesta_Usuario1 FOREIGN KEY
	(
	IdUsuarioIngreso
	) REFERENCES dbo.Usuario
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dbo].[C_ListaEncuesta]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_ListaEncuesta] AS'
GO

--****************************************************************************************************
-- Autor: Equipo de desarrollo OIM - Christian Ospina		
-- Modifica:	Equipo de desarrollo OIM - Liliana Rodriguez
-- Fecha creacion: 2017-01-25	
-- Fecha Modificacion: 2018-05-04																		 
-- Descripcion: Consulta la informacion de las encuestas para ser utilizada en combos de encuestas												
-- Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								 
-- Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								 
-- respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					 
--****************************************************************************************************
ALTER PROC [dbo].[C_ListaEncuesta]

	@IdTipoEncuesta INT = NULL

AS
	IF (@IdTipoEncuesta = NULL or (@IdTipoEncuesta <> 1 and @IdTipoEncuesta <> 2) )
		SELECT [Id],UPPER([Titulo]) Titulo
		FROM [Encuesta]
		WHERE[IsDeleted] = 'false' --AND (@IdTipoEncuesta IS NULL  OR [IdTipoEncuesta] = @IdTipoEncuesta)
		ORDER BY FechaInicio desc
	ELSE
	BEGIN 
		IF (@IdTipoEncuesta = 1)
			SELECT e.Id,UPPER(e.Titulo) Titulo
			FROM [Encuesta] as e
			join Roles.RolEncuesta as re on e.Id = re.IdEncuesta
			join AspNetRoles as r on re.IdRol = r.Id		
			WHERE e.[IsDeleted] = 'false' and r.Name = 'ALCALDIA'
			ORDER BY e.FechaInicio desc
		ELSE
			begin 
				IF (@IdTipoEncuesta = 2)
					SELECT e.Id,UPPER(e.Titulo) Titulo
					FROM [Encuesta] as e
					join Roles.RolEncuesta as re on e.Id = re.IdEncuesta
					join AspNetRoles as r on re.IdRol = r.Id		
					WHERE e.[IsDeleted] = 'false' and r.Name <> 'ALCALDIA'
					ORDER BY e.FechaInicio desc
				ELSE
					SELECT [Id],UPPER([Titulo]) Titulo
					FROM [Encuesta]
					WHERE[IsDeleted] = 'false' --AND (@IdTipoEncuesta IS NULL  OR [IdTipoEncuesta] = @IdTipoEncuesta)
					ORDER BY FechaInicio desc
			end
	END
go
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[D_PrecargueRespuestasDelete]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[D_PrecargueRespuestasDelete] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	 - Vilma Rodriguez																		  
/Fecha creacion:     2018-05-08																			  
/Descripcion: Borra tadas las respuestas precargadas de esta encuesta
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [dbo].[D_PrecargueRespuestasDelete] 
		@IdEncuesta int
AS 		
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	
	BEGIN TRY		
		if exists(select top 1 1  from  dbo.PrecargueRespuestaEncuesta where IdEncuesta =@IdEncuesta)
		begin
			delete dbo.PrecargueRespuestaEncuesta where IdEncuesta =@IdEncuesta
			SELECT @respuesta = 'Se ha eliminado el registro'
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

go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[I_PrecargueRespuestaInsert]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[I_PrecargueRespuestaInsert] AS'
GO
/*****************************************************************************************************
/Autor: Equipo OIM	- vilma rodriguez																		  
/Fecha creacion:     2018-05-08																			  
/Descripcion: Inserta la información del precargue de respuestas de preguntas de encuestas					  
/Retorna: select @respuesta as respuesta, @estadoRespuesta as estado								  
/Estado int= 0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado								  
/respuesta nvarchar(2000)  = 'Mensaje resultado de la validacion y/ acción exitosa'					  
******************************************************************************************************/
ALTER PROC [dbo].[I_PrecargueRespuestaInsert] 
		@IdUsuarioGuardo int,
		@IdEncuesta int,
		@CodigoHomologacion VARCHAR(10),
		@Divipola	int,
		@valor varchar(1000)
		
	AS 	
	
	declare @respuesta as nvarchar(2000) = ''
	declare @estadoRespuesta  as int = 0 --0 no hace nada, 1 insertado, 2 actualizado, 3 Eliminado
	declare @esValido as bit = 1	

	declare @idUsuario int,@IdPregunta int, @idMunicipio int, @idDepartamento int
	
	select @idMunicipio = Id, @idDepartamento = IdDepartamento from Municipio where Id = @Divipola
	if  (@idMunicipio >0)
	begin
		--si es municipio debe buscar el usuario que tenga asignado ese municipuio y sea alcaldia		
		select @idUsuario = Id from Usuario where IdMunicipio =  @idMunicipio  and IdDepartamento =@idDepartamento and Activo = 1 and IdEstado = 5 and IdTipoUsuario = 2		
	end
	else	
	begin
		--si NO es municipio debe buscar el departamento  y el usuario que tenga asignado ese departamento y sea gobernacion
		select @idDepartamento = Id from Departamento where Id = @Divipola		
		select @idUsuario = Id from Usuario where IdDepartamento =@idDepartamento and Activo = 1 and IdEstado = 5 and IdTipoUsuario = 7
	end
	
	select top 1  @IdPregunta = c.Id
	FROM  BancoPreguntas.PreguntaModeloAnterior b 
	join BancoPreguntas.Preguntas a on b.IdPregunta = a.IdPregunta
	JOIN Pregunta c WITH (NOLOCK) ON b.IdPreguntaAnterior = c.Id
	JOIN Seccion AS s on c.IdSeccion = s.Id
	where  a.CodigoPregunta = @CodigoHomologacion and s.IdEncuesta = @IdEncuesta

	if exists(select top 1 1 from dbo.PrecargueRespuestaEncuesta where IdEncuesta =@IdEncuesta and IdPregunta = @IdPregunta and IdUsuario = @idUsuario )
	begin
		set @esValido = 0
		set @respuesta += 'La respuesta ya se encuentra precargada.\n'
	end

	if(@esValido = 1) 
	begin
		BEGIN TRY
			INSERT INTO [dbo].[PrecargueRespuestaEncuesta]
					   ([IdEncuesta]
					   ,[IdPregunta]
					   ,[IdUsuario]
					   ,[Valor]
					   ,[FechaIngreso]
					   ,[IdUsuarioIngreso])
				 VALUES (@IdEncuesta,@IdPregunta,@idUsuario,@valor,GETDATE(),@IdUsuarioGuardo)
		
			SELECT @respuesta = 'Se ha ingresado el registro'
			SELECT @estadoRespuesta = 1	
		END TRY
		BEGIN CATCH
			SELECT @respuesta = ERROR_MESSAGE()
			SELECT @estadoRespuesta = 0
		END CATCH
	end

	select @respuesta as respuesta, @estadoRespuesta as estado

go


	ALTER TABLE [PlanesMejoramiento].[SeccionPlanMejoramiento] ALTER COLUMN [Ayuda] varchar(4000) not null

	go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_DibujarPreguntasSeccion]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_DibujarPreguntasSeccion] AS'
GO
--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Andrés Bonilla																	 
-- Fecha creacion: 25/07/2017																			 
-- Fecha modificacion: 2018-01-22
-- Fecha modificacion: 2018-05-15 Equipo de desarrollo OIM - Vilma Rodriguez	
-- Descripcion: Trae las preguntas y respuestas a dibujar por idseccion e idusuario para pintar el diseño
-- Modificación: Se cambia el funcionamiento de la funcion [ParseDateRespuesta] para que se formateen las 
--				 fechas guardadas en las respuestas de las encuestas viejas
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_DibujarPreguntasSeccion]

	 @IdSeccion	INT
	 ,@IdUsuario INT

AS
BEGIN

if @IdUsuario IS NULL
begin

	SELECT 
		P.[Id]	
		,[IdSeccion]
		,P.[Nombre]
		,[RowIndex]
		,[ColumnIndex]
		,TP.[Nombre] AS TipoPregunta
		,p.[Ayuda]
		,[EsObligatoria]
		,[EsMultiple]
		,[SoloSi]
		,[Texto]
		,'' AS Respuesta
		,S.IdEncuesta
		,0 as TienePrecargue
		,'' as ValorPrecargue
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC
end
else
begin

	SELECT 
		P.[Id]	
		,[IdSeccion]
		,P.[Nombre]
		,[RowIndex]
		,[ColumnIndex]
		,TP.[Nombre] AS TipoPregunta
		,p.[Ayuda]
		,[EsObligatoria]
		,[EsMultiple]
		,[SoloSi]
		,[Texto]
		,CASE WHEN TP.[Nombre] = 'FECHA' THEN dbo.[ParseDateRespuesta](replace(LEFT(r.Valor, 10), '/', '-'), (case when (S.IdEncuesta < 77 AND S.IdEncuesta <> 24) then 1 else 0 end)) ELSE r.Valor END  as Respuesta
		,S.IdEncuesta
		,case when pre.IdEncuesta is null then 0 else 1 end as TienePrecargue,
		pre.Valor as ValorPrecargue
  FROM 
	[dbo].[Pregunta] p
	INNER JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
	INNER JOIN dbo.Seccion S ON S.Id = p.IdSeccion
	LEFT OUTER JOIN [dbo].Respuesta r ON r.IdPregunta = p.Id and r.IdUsuario = @IdUsuario
	left outer join [dbo].[PrecargueRespuestaEncuesta] as pre on p.Id = pre.IdPregunta and S.IdEncuesta = pre.IdEncuesta and pre.IdUsuario = @IdUsuario
  WHERE 
	IdSeccion = @IdSeccion
  ORDER BY
	p.Id ASC

end
END

go




IF NOT EXISTS (SELECT * FROM [dbo].[SubRecurso] WHERE Nombre = 'Informe de Precargue Respuestas' AND IdRecurso = 8)
BEGIN
	--SET IDENTITY_INSERT [dbo].[SubRecurso] ON	
	INSERT INTO [dbo].[SubRecurso]([Id],[Nombre],[Url],[IdRecurso]) VALUES (104, 'Informe de Precargue Respuestas', NULL, 8)
	--SET IDENTITY_INSERT [dbo].[SubRecurso] OFF
END
go

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_InformePrecargueRespuestas]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_InformePrecargueRespuestas] AS'
GO
--=====================================================================================================
-- Autor: Equipo de desarrollo OIM - Vilma Liliana Rodriguez																	 
-- Fecha creacion: 17/05/2018																			 
-- Descripcion: Trae la informacion de las preguntas, encuestas y precargue de respuestas
--=====================================================================================================
ALTER PROCEDURE [dbo].[C_InformePrecargueRespuestas]
	@IdEncuesta int
AS
BEGIN
	if (@IdEncuesta = 0) 
	begin 
		select 	pre.IdEncuesta, E.Titulo, TE.Descripcion AS TipoEncuesta, pre.IdPregunta, P.Nombre as Pregunta, TP.Descripcion as TipoPregunta, S.Titulo as Seccion,pre.Valor as ValorPrecargue, pre.FechaIngreso as FechaPrecargue , U.UserName as Usuario, UI.UserName as UsuarioIngreso,a.CodigoPregunta  as Codigohomologado
		FROM  [dbo].[PrecargueRespuestaEncuesta] as pre 
		join  [dbo].[Pregunta] P ON pre.IdPregunta = P.Id	
		JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
		JOIN dbo.Seccion S ON S.Id = P.IdSeccion
		JOIN Encuesta AS E ON  S.IdEncuesta = E.Id AND pre.IdEncuesta = E.Id
		JOIN TipoEncuesta AS TE ON E.IdTipoEncuesta = TE.Id
		join Usuario as UI on pre.IdUsuarioIngreso = UI.Id
		join Usuario as U on pre.IdUsuario = U.Id
		join BancoPreguntas.PreguntaModeloAnterior b ON P.Id = b.IdPreguntaAnterior
		join BancoPreguntas.Preguntas a on b.IdPregunta = a.IdPregunta		
	end
	else
	begin
		select 	pre.IdEncuesta, E.Titulo, TE.Descripcion AS TipoEncuesta, pre.IdPregunta, P.Nombre as Pregunta, TP.Descripcion as TipoPregunta, S.Titulo as Seccion,pre.Valor as ValorPrecargue, pre.FechaIngreso as FechaPrecargue , U.UserName as Usuario, UI.UserName as UsuarioIngreso,a.CodigoPregunta  as Codigohomologado
		FROM  [dbo].[PrecargueRespuestaEncuesta] as pre 
		join  [dbo].[Pregunta] P ON pre.IdPregunta = P.Id	
		JOIN TipoPregunta TP ON P.IdTipoPregunta = TP.Id
		JOIN dbo.Seccion S ON S.Id = P.IdSeccion
		JOIN Encuesta AS E ON  S.IdEncuesta = E.Id AND pre.IdEncuesta = E.Id
		JOIN TipoEncuesta AS TE ON E.IdTipoEncuesta = TE.Id
		join Usuario as UI on pre.IdUsuarioIngreso = UI.Id
		join Usuario as U on pre.IdUsuario = U.Id
		join BancoPreguntas.PreguntaModeloAnterior b ON P.Id = b.IdPreguntaAnterior
		join BancoPreguntas.Preguntas a on b.IdPregunta = a.IdPregunta		
		where pre.IdEncuesta = @IdEncuesta
	end	
end
go