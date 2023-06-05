-- =============================================
-- Author:			vilma.rodriguez
-- Create date:		08/08/2016
-- Modified date:	16/01/2018
-- Description:		Obtiene las necesidades identificadas del municipio acorde con la pregunta del PAT
-- =============================================
ALTER procedure [PAT].[C_NecesidadesIdentificadas] --103, 180
	@USUARIO INT,
	@PREGUNTA SMALLINT
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @Cant INT
    DECLARE @Cantidad INT
    DECLARE @CantidadDef NVARCHAR(100)

	DECLARE  @SQL NVARCHAR(MAX)
	-----------------------------------------------------------
	---------------------------nuevo---------------------------
	-----------------------------------------------------------

	Declare @IdMunicipio int, @IdPregunta int, @idTablero int,@IdentificadorMedida int,@IdentificadorNecesidad int
	set @IdPregunta = @PREGUNTA
	select @idTablero =IdTablero from pat.PreguntaPAT where Id = @IdPregunta
	Select @IdMunicipio = IdMunicipio from Usuario where Id = @USUARIO

	if (@idTablero >= 3)
	begin
		if (@IdPregunta = 180)--Víctimas del conflicto armado a quienes no se les ha expedido el documento de identidad acorde a su edad. 5-1
		begin
			set @IdentificadorMedida  = 5
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 181)--Víctimas del conflicto armado que no se encuentran afiliadas al Sistema General de Seguridad Social en Salud.. 1-1
		begin
			set @IdentificadorMedida  = 1
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 182)--Víctimas del conflicto armado que no se encuentran afiliadas al Sistema General de Seguridad Social en Salud. 3-1
		begin
			set @IdentificadorMedida  = 3
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 185)--Víctimas del conflicto armado que requieren alfabetización.3-2
		begin
			set @IdentificadorMedida  = 3
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 186)--Hogares que requieren acceso a vivienda en la zona urbana. 10-1
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 187)--Hogares que requieren mejoramiento de vivienda en la zona urbana. --10-2
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 188)--Hogares que requieren acceso a vivienda en la zona rural.--10-1
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 189)--Hogares que requieren mejoramiento de vivienda en la zona rural.10-2
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 190)--Víctimas del conflicto armado que requieren fortalecimiento de negocios. 4- 4
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 4
		end		
		if (@IdPregunta = 191)--Víctimas del conflicto armado que requieren apoyo a nuevos emprendimientos.--4-5
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 5
		end		
		if (@IdPregunta = 192)--Víctimas del conflicto armado que requieren empleabilidad.--4-3
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 3
		end
		if (@IdPregunta = 193)--Víctimas del conflicto armado que requieren capacitación u orientación para el trabajo (excluye educación superior).--4-2
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 199)--Víctimas del conflicto armado que han solicitado atención o acompañamiento psicosocial y no lo han recibido.--1-7
		begin
			set @IdentificadorMedida  = 1
			set @IdentificadorNecesidad = 7
		end
		if (@IdPregunta = 200)--Hombres entre 18 y 49 años, víctimas del conflicto armado, que no tienen definida su situación militar. --5-2
		begin
			set @IdentificadorMedida  = 5
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 201)--Víctimas del conflicto armado que requieren apoyo en Asistencia Funeraria.--11-1
		begin
			set @IdentificadorMedida  = 11
			set @IdentificadorNecesidad = 1		
		end
		
		select @Cantidad = COUNT(1) from pat.PrecargueSIGO 
		where CodigoDane = @IdMunicipio and IdTablero = @idTablero and IdentificadorMedida = @IdentificadorMedida and IdentificadorNecesidad = @IdentificadorNecesidad	 

		select @Cantidad Cantidad
	end
	else
	begin 
		-----------------------------------------------------------
		---------------------------anterior---------------------------
		-----------------------------------------------------------
		DECLARE @Divipola  varchar(5)
		SELECT @Divipola =  M.Divipola 	FROM [dbo].[Usuario] (NOLOCK) U JOIN Municipio AS M ON U.IdMunicipio = M.Id	WHERE U.ID = @USUARIO
		SET @SQL = 'SELECT
					@Cantidad = COUNT(1)
					FROM
						(
							SELECT DISTINCT
								A.*
							FROM
								[PAT].[PrecargueSIGO] A
							WHERE
								A.[CodigoDane] = @Divipola
						'
		IF @PREGUNTA = 108
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Solicita asistencia funeraria'''
		ELSE IF @PREGUNTA IN (111, 112)
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere acceso a educaciÃ³n bÃ¡sica o media'''
		ELSE IF @PREGUNTA = 113
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto requiere acceso a educaciÃ³n bÃ¡sica o media'''
		ELSE IF @PREGUNTA IN (110, 163)
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere cuidado inicial'''
		ELSE IF @PREGUNTA = 170
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Mejoramiento vivienda'''
		ELSE IF @PREGUNTA = 171
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Vivienda nueva'''
		ELSE IF @PREGUNTA = 146
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Requiere acceso a EducaciÃ³n Gitano Rom - IndÃ­gena'''
		ELSE IF @PREGUNTA = 148
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Documento de identidad'''
		ELSE IF @PREGUNTA = 149
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Libreta militar'''
		ELSE IF @PREGUNTA = 141
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere acceso a programas regulares de alimentaciÃ³n'''
		ELSE IF @PREGUNTA IN (140, 142)
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto requiere acceso a programas regulares de alimentaciÃ³n'''
		ELSE IF @PREGUNTA IN (144, 145)
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Madre gestante o lactante requiere apoyo alimentario'''
		ELSE IF @PREGUNTA = 127
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto solicita reunificaciÃ³n familiar'''
		ELSE IF @PREGUNTA = 128
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''AfiliaciÃ³n al SGSSS'''
		ELSE IF @PREGUNTA = 139
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Requiere acceso a programa jÃ³venes en acciÃ³n'''
		ELSE IF @PREGUNTA IN (120, 121)
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Apoyo a nuevos emprendimientos'''
		ELSE IF @PREGUNTA IN (122, 123)
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Fortalecimiento de negocios'''
		ELSE IF @PREGUNTA IN (124, 125)
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Empleabilidad'''
		ELSE IF @PREGUNTA = 126
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor solicita reunificaciÃ³n familiar'''
		ELSE IF @PREGUNTA = 152
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''AtenciÃ³n psicosocial'''
		ELSE IF @PREGUNTA IN (116, 117)
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''OrientaciÃ³n ocupacional'''
		ELSE IF @PREGUNTA IN (118, 119)
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''EducaciÃ³n y/o orientaciÃ³n para el trabajo'''
		ELSE
			SET @SQL = @SQL + ' AND	NombreNecesidad = ''ninguna'''
		--SET @SQL = 'SELECT
		--				@Cantidad = COUNT(1)
		--			FROM
		--				(
		--				SELECT
		--						DISTINCT C.TIPO_DOCUMENTO,C.NUMERO_DOCUMENTO,C.ID_MEDIDA,C.ID_NECESIDAD
		--				from	DBO.TB_CARGUE C 
		--				INNER JOIN	DBO.TB_LOTE L ON C.ID_LOTE = L.ID
		--				INNER JOIN	DBO.Entidad E ON C.DANE_MUNICIPIO = E.ID_MUNICIPIO
		--				INNER JOIN	PAT.Pregunta P ON P.ID_MEDIDA = C.ID_MEDIDA
		--				WHERE	L.ID_ESTADO = 3	
		--				AND		E.ID = PAT.GetIdEntidad(@USUARIO)
		--				AND		P.ID  = @PREGUNTA '

		---- MEDIDA IDENTIFICACIÓN
		--IF @PREGUNTA = 1
		--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 6'
		--IF @PREGUNTA = 2
		--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 7 AND 17'
		--IF @PREGUNTA = 3
		--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >= 18'

		---- MEDIDA SALUD
		--IF @PREGUNTA = 5
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'

		---- MEDIDA REHABILITACIÓN PSICOSOCIAL


		---- MEDIDA EDUCACIÓN
		--IF @PREGUNTA = 7
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 6 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 5'
		--IF @PREGUNTA = 8
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
		--IF @PREGUNTA = 9
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
		--IF @PREGUNTA = 10
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'

		---- MEDIDA GENERACION DE INGRESOS
		--IF @PREGUNTA = 11
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
		--IF @PREGUNTA = 12
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
		--IF @PREGUNTA = 13
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
		--IF @PREGUNTA = 14
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
		--IF @PREGUNTA = 15
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 5'
		--IF @PREGUNTA = 16
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 5'
		--IF @PREGUNTA = 17
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 4'
		--IF @PREGUNTA = 18
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 4'
		--IF @PREGUNTA = 19
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD in (3,8)'
		--IF @PREGUNTA = 20
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD in (3,8)'

		---- MEDIDA SEGURIDAD ALIMENTARIA
		--IF @PREGUNTA = 21
		--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 5'
		--IF @PREGUNTA = 22
		--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
		--IF @PREGUNTA = 23
		--	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'
		--IF @PREGUNTA = 24 
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
		--IF @PREGUNTA = 25
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'

		---- MEDIDA REUNIFICACIÓN FAMILIAR
		--IF @PREGUNTA = 26
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 17'
		--IF @PREGUNTA = 27
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'

		---- MEDIDA VIVIENDA
		--IF @PREGUNTA = 28
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
		--IF @PREGUNTA = 29
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
		--IF @PREGUNTA = 30
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
		--IF @PREGUNTA = 31
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
		--IF @PREGUNTA = 32
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
		--IF @PREGUNTA = 33
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
		--IF @PREGUNTA = 34
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
		--IF @PREGUNTA = 35
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
		--IF @PREGUNTA = 36
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	
		---- MEDIDA ASISTENCIA FUNERARIA
		--IF @PREGUNTA = 37
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
		--IF @PREGUNTA = 38
		--	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'

		SET @SQL = @SQL + ')P' 
	
		SET @CantidadDef = N'@Cantidad INT OUTPUT,@USUARIO INT,@Divipola  varchar(5)'
		SET @Cant = 0 

		print @SQL
  
		EXECUTE sp_executesql @Sql, @CantidadDef, @Cantidad = @Cant OUTPUT, @USUARIO = @USUARIO ,@Divipola=@Divipola    
		SELECT @Cant Cantidad
	end
END 

go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		20/11/2017
-- Modified date:	16/01/2018
-- Description:		Retorna las fuentes de financiacion para el diligenciamiento municipal de un municipio
-- ==========================================================================================
ALTER PROCEDURE [PAT].[C_UnoaUnoPrecargueSIGO] --[PAT].[C_UnoaUnoPrecargueSIGO] 180 , 374
( @IdPregunta as INT, @IdUsuario int)
AS
BEGIN
	SET NOCOUNT ON;		
	
	Declare @IdMunicipio int,  @idTablero int,@IdentificadorMedida int,@IdentificadorNecesidad int
	
	select @idTablero =IdTablero from pat.PreguntaPAT where Id = @IdPregunta
	Select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

		if (@IdPregunta = 180)--Víctimas del conflicto armado a quienes no se les ha expedido el documento de identidad acorde a su edad. 5-1
		begin
			set @IdentificadorMedida  = 5
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 181)--Víctimas del conflicto armado que no se encuentran afiliadas al Sistema General de Seguridad Social en Salud.. 1-1
		begin
			set @IdentificadorMedida  = 1
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 182)--Víctimas del conflicto armado que no se encuentran afiliadas al Sistema General de Seguridad Social en Salud. 3-1
		begin
			set @IdentificadorMedida  = 3
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 185)--Víctimas del conflicto armado que requieren alfabetización.3-2
		begin
			set @IdentificadorMedida  = 3
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 186)--Hogares que requieren acceso a vivienda en la zona urbana. 10-1
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 187)--Hogares que requieren mejoramiento de vivienda en la zona urbana. --10-2
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 188)--Hogares que requieren acceso a vivienda en la zona rural.--10-1
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 189)--Hogares que requieren mejoramiento de vivienda en la zona rural.10-2
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 190)--Víctimas del conflicto armado que requieren fortalecimiento de negocios. 4- 4
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 4
		end		
		if (@IdPregunta = 191)--Víctimas del conflicto armado que requieren apoyo a nuevos emprendimientos.--4-5
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 5
		end		
		if (@IdPregunta = 192)--Víctimas del conflicto armado que requieren empleabilidad.--4-3
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 3
		end
		if (@IdPregunta = 193)--Víctimas del conflicto armado que requieren capacitación u orientación para el trabajo (excluye educación superior).--4-2
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 199)--Víctimas del conflicto armado que han solicitado atención o acompañamiento psicosocial y no lo han recibido.--1-7
		begin
			set @IdentificadorMedida  = 1
			set @IdentificadorNecesidad = 7
		end
		if (@IdPregunta = 200)--Hombres entre 18 y 49 años, víctimas del conflicto armado, que no tienen definida su situación militar. --5-2
		begin
			set @IdentificadorMedida  = 5
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 201)--Víctimas del conflicto armado que requieren apoyo en Asistencia Funeraria.--11-1
		begin
			set @IdentificadorMedida  = 11
			set @IdentificadorNecesidad = 1		
		end
		
		select [TipoDocumento],[NumeroDocumento],[NombreVictima]  from pat.PrecargueSIGO 
		where CodigoDane = @IdMunicipio and IdTablero = @idTablero and IdentificadorMedida = @IdentificadorMedida and IdentificadorNecesidad = @IdentificadorNecesidad	 		
END

go


-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/07/2017
-- Modified date:	16/01/2018
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
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoReparacionColectiva rcd ON rcd.IdMunicipioRespuesta= d.Id and rcd.IdPreguntaPATReparacionColectiva=p.Id
		where TABLERO.Id = @IdTablero and p.Activo = 1
		order by Sujeto																

END

go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		21/07/2017
-- Modified date:	16/01/2018
-- Description:		Obtiene toda la informacion correspondiente a la gobernbacion para retornos y reubicaciones  para el tablero indicando en cuento a las respuestas que estos diligenciaron
-- ==========================================================================================

ALTER PROC [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones] --  [PAT].[C_DatosExcel_GobernacionesRetornosReubicaciones] 1513 , 2
(	@IdUsuario INT, @IdTablero INT)
AS
BEGIN

	Declare @IdDepartamento int, @Departamento VARCHAR(100)
	
	select @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario		

	SELECT DISTINCT 
		P.Id AS IdPregunta
		,d.Nombre as Municipio
		,P.IdMunicipio
		,P.Hogares
		,P.Personas
		,P.Sector
		,P.Componente
		,P.Comunidad
		,P.Ubicacion
		,P.MedidaRetornoReubicacion	
		,P.IndicadorRetornoReubicacion
		,p.IdDepartamento	
		,P.IdTablero	
		,R.ID
		,R.Accion
		,R.Presupuesto
		,RD.AccionDepartamento
		,RD.PresupuestoDepartamento
		,RD.Id as IdRespuestaDepartamento
		,P.EntidadResponsable
		FROM pat.PreguntaPATRetornosReubicaciones AS P
		JOIN PAT.Tablero AS T ON P.IdTablero =T.Id
		INNER join Municipio as d on p.IdMunicipio =d.Id and d.IdDepartamento =@IdDepartamento
		LEFT OUTER JOIN PAT.RespuestaPATRetornosReubicaciones AS R  ON P.Id = R.IdPreguntaPATRetornoReubicacion AND R.IdMunicipio = P.IdMunicipio
		LEFT OUTER JOIN PAT.RespuestaPATDepartamentoRetornosReubicaciones AS RD ON R.IdMunicipio = RD.IdMunicipioRespuesta
		where T.Id = @idTablero  and P.Activo = 1
		order by P.Id

END

go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		14/11/2017
-- Modified date:	10/12/2017
-- Description:		Obtiene las respuestas de las pregutnas de reparacion colectiva del diligenciamiento municipal
-- =============================================
ALTER PROCEDURE [PAT].[C_DatosExcel_MunicipiosReparacionColectiva] -- [PAT].[C_DatosExcel_MunicipiosReparacionColectiva] 5172, 1
 (@IdMunicipio INT, @IdTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON	
	
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
	R.Accion, 
	R.Presupuesto,
	
	STUFF((SELECT CAST( ACCION.AccionReparacionColectiva AS VARCHAR(MAX)) + ' / ' 
	FROM [PAT].RespuestaPATAccionReparacionColectiva AS ACCION
	WHERE R.Id = ACCION.IdRespuestaPATReparacionColectiva AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS DetalleAcciones
	
	FROM    [PAT].[PreguntaPATReparacionColectiva] AS P
	JOIN Municipio AS MUN ON P.IdMunicipio = MUN.Id
	LEFT OUTER JOIN [PAT].[RespuestaPATReparacionColectiva] AS R ON P.ID= R.[IdPreguntaPATReparacionColectiva] AND R.[IdMunicipio] = @IdMunicipio,
	[PAT].[Medida] M,
	[PAT].[Tablero] T
	WHERE	P.IDMEDIDA = M.ID 
	AND P.[IdMunicipio] = @IdMunicipio
	AND P.IDTABLERO = T.ID
	AND T.ID = @IdTablero
	and P.Activo = 1
END

go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		14/11/2017
-- Modified date:	16/01/2018
-- Description:		Obtiene las respuestas de las pregutnas de retornos y reubicaciones del diligenciamiento municipal
-- =============================================
ALTER PROCEDURE [PAT].[C_DatosExcel_MunicipiosRetornosReubicaciones] -- [PAT].[C_DatosExcel_MunicipiosRetornosReubicaciones] 5172, 2
 (@IdMunicipio INT, @IdTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON
	
	SELECT DISTINCT  P.ID AS IdPregunta,
	M.Divipola AS DaneMunicipio,
	M.Nombre AS Municipio,
	M.IdDepartamento,
	P.Hogares,
	P.Personas,
	P.Sector,
	P.Componente,
	P.Comunidad,
	P.Ubicacion,
	P.MedidaRetornoReubicacion,
	P.IndicadorRetornoReubicacion,
	P.EntidadResponsable, 
	T.ID AS IdTablero,
	R.Id as IdRespuesta,
	R.Accion , 	
	R.Presupuesto,
	
	STUFF((SELECT CAST( ACCION.AccionRetornoReubicacion AS VARCHAR(MAX)) + ' / ' 
	FROM [PAT].RespuestaPATAccionRetornosReubicaciones AS ACCION
	WHERE R.Id = ACCION.IdRespuestaPATRetornoReubicacion AND ACCION.Activo = 1  FOR XML PATH(''),TYPE).value('.','VARCHAR(MAX)'),1,0,'') AS DetalleAcciones
	

	FROM   [PAT].[PreguntaPATRetornosReubicaciones] P
	JOIN Municipio AS M ON P.IdMunicipio = M.Id
	INNER JOIN [PAT].[Tablero] T ON P.[IdTablero] = T.ID
	LEFT OUTER JOIN [PAT].[RespuestaPATRetornosReubicaciones] R ON R.IdMunicipio = @IdMunicipio and p.ID = R.[IdPreguntaPATRetornoReubicacion]	
	WHERE  T.ID = @IdTablero 
	and P.[IdMunicipio] = @IdMunicipio
	and P.Activo = 1
END

go

-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		14/11/2017
-- Modified date:	16/01/2018
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
	LEFT OUTER JOIN PAT.SeguimientoReparacionColectiva AS SEGRC ON P.Id  = SEGRC.IdPregunta AND SEGRC.IdUsuario =  @IdUsuario ,
	[PAT].[Medida] M,
	[PAT].[Tablero] T
	WHERE	P.IDMEDIDA = M.ID 
	AND P.[IdMunicipio] = @IdMunicipio
	AND P.IDTABLERO = T.ID
	AND T.ID = @IdTablero
	and P.Activo = 1
END

go
-- ==========================================================================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez - Vilma rodriguez
-- Create date:		14/11/2017
-- Modified date:	16/01/2018
-- Description:		Obtiene las respuestas de las pregutnas de retornos y reubicaciones del seguimiento municipal
-- =============================================
ALTER PROCEDURE [PAT].[C_DatosExcelSeguimientoAlcaldiasRetornosReubicaciones] -- [PAT].C_DatosExcelSeguimientoAlcaldiasRetornosReubicaciones 411, 2
 (@IdUsuario INT, @IdTablero tinyint)
AS
BEGIN
	SET NOCOUNT ON	
	
	declare @IdMunicipio int, @IdDepartamento int
	select @IdMunicipio = IdMunicipio, @IdDepartamento = IdDepartamento from Usuario where Id = @IdUsuario
	
	SELECT DISTINCT 
	MUN.Divipola AS DaneMunicipio,
	MUN.Nombre AS Municipio,
	MUN.IdDepartamento,
	P.Hogares,
	P.Personas,
	P.Sector,
	P.Componente,
	P.Comunidad,
	P.Ubicacion,
	P.MedidaRetornoReubicacion,
	P.IndicadorRetornoReubicacion,
	P.EntidadResponsable, 
	T.ID AS IdTablero,
	R.Id as IdRespuesta,
	SEGRC.AvancePrimer,
	SEGRC.AvanceSegundo		
	FROM    [PAT].[PreguntaPATRetornosReubicaciones] AS P
	JOIN Municipio AS MUN ON P.IdMunicipio = MUN.Id
	LEFT OUTER JOIN [PAT].[RespuestaPATRetornosReubicaciones] AS R ON P.ID= R.[IdPreguntaPATRetornoReubicacion] AND R.[IdMunicipio] = @IdMunicipio
	LEFT OUTER JOIN PAT.SeguimientoRetornosReubicaciones AS SEGRC ON P.Id  = SEGRC.IdPregunta AND SEGRC.IdUsuario =  @IdUsuario ,
	[PAT].[Medida] M,
	[PAT].[Tablero] T
	WHERE P.[IdMunicipio] = @IdMunicipio
	AND P.IDTABLERO = T.ID
	AND T.ID = @IdTablero
	and P.Activo = 1
END

go



	update [PAT].[Seguimiento] set CantidadSegundo = 0 where CantidadSegundo = -1
	update [PAT].[Seguimiento] set PresupuestoSegundo = 0 where PresupuestoSegundo = -1



