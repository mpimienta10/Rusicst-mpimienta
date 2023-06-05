IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[PAT].[C_NecesidadesIdentificadasSeguimiento]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [PAT].[C_NecesidadesIdentificadasSeguimiento] AS'
GO
-- =============================================
-- Author:   Grupo OIM de Ministerio del Interior - Vilma Rodriguez
-- Create date:		27/06/2018
-- Description:		Retorna el numero de seguimiento de acuerdo al momento en el que se llame el procedimiento
-- =============================================
ALTER PROC  [PAT].[C_NecesidadesIdentificadasSeguimiento] --[PAT].[C_NecesidadesIdentificadasSeguimiento]  1276, 124
	@IdUsuario INT,
	@IdPregunta SMALLINT
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

	Declare @IdMunicipio int,  @idTablero int,@IdentificadorMedida int,@IdentificadorNecesidad int
	select @idTablero =IdTablero from pat.PreguntaPAT where Id = @IdPregunta
	Select @IdMunicipio = IdMunicipio from Usuario where Id = @IdUsuario

	if (@idTablero >= 2)
	begin
		if (@IdPregunta = 108 )--Solicita asistencia funeraria
		begin
			set @IdentificadorMedida  = 11
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 111 or @IdPregunta = 112  )--Menor requiere acceso a educaci贸n b谩sica o media
		begin
			set @IdentificadorMedida  = 3
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 113  )--Adulto requiere acceso a educaci贸n b谩sica o media
		begin
			set @IdentificadorMedida  = 3
			set @IdentificadorNecesidad = 2		
		end
		if (@IdPregunta = 110 or @IdPregunta = 163  )--Menor requiere cuidado inicial
		begin
			set @IdentificadorMedida  = 3
			set @IdentificadorNecesidad = 6
		end
		if (@IdPregunta = 170   )-- Mejoramiento vivienda
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 2		
		end	
		if (@IdPregunta = 171   )-- Vivienda nueva
		begin
			set @IdentificadorMedida  = 10
			set @IdentificadorNecesidad = 1		
		end	
		if (@IdPregunta = 146   )-- Requiere acceso a Educaci贸n Gitano Rom - Ind铆gena
		begin
			set @IdentificadorMedida  = 3
			set @IdentificadorNecesidad = 5		
		end	
		if (@IdPregunta = 148    )--  Documento de identidad
		begin
			set @IdentificadorMedida  = 5
			set @IdentificadorNecesidad = 1		
		end	
		if (@IdPregunta = 149    )--  Libreta militar
		begin
			set @IdentificadorMedida  = 5
			set @IdentificadorNecesidad = 2		
		end			
		if (@IdPregunta = 141     )--   Menor requiere acceso a programas regulares de alimentaci贸n
		begin
			set @IdentificadorMedida  = 2
			set @IdentificadorNecesidad = 1		
		end	
		if (@IdPregunta = 140 or @IdPregunta = 142  )--Adulto requiere acceso a programas regulares de alimentaci贸n
		begin
			set @IdentificadorMedida  = 2
			set @IdentificadorNecesidad = 4		
		end
		if (@IdPregunta = 144 or @IdPregunta = 145  )--Madre gestante o lactante requiere apoyo alimentario
		begin
			set @IdentificadorMedida  = 2
			set @IdentificadorNecesidad = 2
		end
		if (@IdPregunta = 127     )--   Adulto solicita reunificaci贸n familiar
		begin
			set @IdentificadorMedida  = 7
			set @IdentificadorNecesidad = 2		
		end	
		if (@IdPregunta = 128     )--   Afiliaci贸n al SGSSS
		begin
			set @IdentificadorMedida  = 1
			set @IdentificadorNecesidad = 1		
		end	
		if (@IdPregunta = 139     )--   Requiere acceso a programa j贸venes en acci贸n
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 7
		end	
		if (@IdPregunta = 120 or @IdPregunta = 121  )--Apoyo a nuevos emprendimientos
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 5
		end
		if (@IdPregunta = 122 or @IdPregunta = 123  )--Fortalecimiento de negocios
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 4
		end
		if (@IdPregunta = 124 or @IdPregunta = 125  )--Empleabilidad
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 3
		end
		if (@IdPregunta = 126     )--  Menor solicita reunificaci贸n familiar
		begin
			set @IdentificadorMedida  = 7
			set @IdentificadorNecesidad = 1		
		end	
		if (@IdPregunta = 152     )--    Atenci贸n psicosocial
		begin
			set @IdentificadorMedida  = 1
			set @IdentificadorNecesidad = 7
		end	
		if (@IdPregunta = 116 or @IdPregunta = 117  )--Orientaci贸n ocupacional
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 1		
		end
		if (@IdPregunta = 118 or @IdPregunta = 119  )--Educaci贸n y/o orientaci贸n para el trabajo
		begin
			set @IdentificadorMedida  = 4
			set @IdentificadorNecesidad = 2
		end

		select @Cantidad = COUNT(1) from pat.PreCargueSeguimiento 
		where CodigoDane = @IdMunicipio and IdTablero = @idTablero and IdMedida = @IdentificadorMedida and IdNecesidad = @IdentificadorNecesidad	 

		select @Cantidad Cantidad
	end
	else
	begin 
		-----------------------------------------------------------
		---------------------------anterior---------------------------
		-----------------------------------------------------------
	--	SET @SQL = 'SELECT @Cantidad = COUNT(1)
	--			FROM (
	--					SELECT DISTINCT   A.* 
	--					FROM [PAT].[PreCargueSeguimiento] A
	--					WHERE  A.CodigoDane = @codigoDane	'
	--IF @IdPregunta = 108
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Solicita asistencia funeraria'''
	--ELSE IF @IdPregunta IN (111, 112)
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere acceso a educaci贸n b谩sica o media'''
	--ELSE IF @IdPregunta = 113
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto requiere acceso a educaci贸n b谩sica o media'''
	--ELSE IF @IdPregunta IN (110, 163)
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere cuidado inicial'''
	--ELSE IF @IdPregunta = 170
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Mejoramiento vivienda'''
	--ELSE IF @IdPregunta = 171
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Vivienda nueva'''
	--ELSE IF @IdPregunta = 146
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Requiere acceso a Educaci贸n Gitano Rom - Ind铆gena'''
	--ELSE IF @IdPregunta = 148
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Documento de identidad'''
	--ELSE IF @IdPregunta = 149
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Libreta militar'''
	--ELSE IF @IdPregunta = 141
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor requiere acceso a programas regulares de alimentaci贸n'''
	--ELSE IF @IdPregunta IN (140, 142)
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto requiere acceso a programas regulares de alimentaci贸n'''
	--ELSE IF @IdPregunta IN (144, 145)
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Madre gestante o lactante requiere apoyo alimentario'''
	--ELSE IF @IdPregunta = 127
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Adulto solicita reunificaci贸n familiar'''
	--ELSE IF @IdPregunta = 128
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Afiliaci贸n al SGSSS'''
	--ELSE IF @IdPregunta = 139
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Requiere acceso a programa j贸venes en acci贸n'''
	--ELSE IF @IdPregunta IN (120, 121)
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Apoyo a nuevos emprendimientos'''
	--ELSE IF @IdPregunta IN (122, 123)
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Fortalecimiento de negocios'''
	--ELSE IF @IdPregunta IN (124, 125)
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Empleabilidad'''
	--ELSE IF @IdPregunta = 126
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Menor solicita reunificaci贸n familiar'''
	--ELSE IF @IdPregunta = 152
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Atenci贸n psicosocial'''
	--ELSE IF @IdPregunta IN (116, 117)
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Orientaci贸n ocupacional'''
	--ELSE IF @IdPregunta IN (118, 119)
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''Educaci贸n y/o orientaci贸n para el trabajo'''
	--ELSE
	--	SET @SQL = @SQL + ' AND	NombreNecesidad = ''ninguna'''
	----SET @SQL = 'SELECT
	----				@Cantidad = COUNT(1)
	----			FROM
	----				(
	----				SELECT
	----						DISTINCT C.TIPO_DOCUMENTO,C.NUMERO_DOCUMENTO,C.ID_MEDIDA,C.ID_NECESIDAD
	----				from	DBO.TB_CARGUE C 
	----				INNER JOIN	DBO.TB_LOTE L ON C.ID_LOTE = L.ID
	----				INNER JOIN	DBO.TB_ENTIDAD E ON C.DANE_MUNICIPIO = E.ID_MUNICIPIO
	----				INNER JOIN	PAT.TB_PREGUNTA P ON P.ID_MEDIDA = C.ID_MEDIDA
	----				WHERE	L.ID_ESTADO = 3	
	----				AND		E.ID = PAT.fn_GetIdEntidad(@IdUsuario)
	----				AND		P.ID  = @IdPregunta '

	------ MEDIDA IDENTIFICACI覰
	----IF @IdPregunta = 1
	----	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 6'
	----IF @IdPregunta = 2
	----	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 7 AND 17'
	----IF @IdPregunta = 3
	----	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >= 18'

	------ MEDIDA SALUD
	----IF @IdPregunta = 5
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'

	------ MEDIDA REHABILITACI覰 PSICOSOCIAL


	------ MEDIDA EDUCACI覰
	----IF @IdPregunta = 7
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 6 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 5'
	----IF @IdPregunta = 8
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
	----IF @IdPregunta = 9
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
	----IF @IdPregunta = 10
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'

	------ MEDIDA GENERACION DE INGRESOS
	----IF @IdPregunta = 11
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	----IF @IdPregunta = 12
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	----IF @IdPregunta = 13
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	----IF @IdPregunta = 14
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	----IF @IdPregunta = 15
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 5'
	----IF @IdPregunta = 16
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 5'
	----IF @IdPregunta = 17
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 4'
	----IF @IdPregunta = 18
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 4'
	----IF @IdPregunta = 19
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD in (3,8)'
	----IF @IdPregunta = 20
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD in (3,8)'

	------ MEDIDA SEGURIDAD ALIMENTARIA
	----IF @IdPregunta = 21
	----	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 5'
	----IF @IdPregunta = 22
	----	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 6 AND 17'
	----IF @IdPregunta = 23
	----	SET @SQL = @SQL + ' AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'
	----IF @IdPregunta = 24 
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	----IF @IdPregunta = 25
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'

	------ MEDIDA REUNIFICACI覰 FAMILIAR
	----IF @IdPregunta = 26
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) BETWEEN 0 AND 17'
	----IF @IdPregunta = 27
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2 AND	DATEDIFF(yy,C.FECHA_NACIMIENTO,C.FECHA_INGRESO) >=18'

	------ MEDIDA VIVIENDA
	----IF @IdPregunta = 28
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	----IF @IdPregunta = 29
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'
	----IF @IdPregunta = 30
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	----IF @IdPregunta = 31
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	----IF @IdPregunta = 32
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	----IF @IdPregunta = 33
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	----IF @IdPregunta = 34
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	----IF @IdPregunta = 35
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	----IF @IdPregunta = 36
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	
	------ MEDIDA ASISTENCIA FUNERARIA
	----IF @IdPregunta = 37
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 1'
	----IF @IdPregunta = 38
	----	SET @SQL = @SQL + ' AND	C.ID_NECESIDAD = 2'

		--SET @SQL = @SQL + ')P' 	
		--SET @CantidadDef = N'@Cantidad INT OUTPUT,@USUARIO INT,@Divipola  varchar(5)'
		--SET @Cant = 0 
		--print @SQL
		--EXECUTE sp_executesql @Sql, @CantidadDef, @Cantidad = @Cant OUTPUT, @USUARIO = @USUARIO ,@Divipola=@Divipola    
		SELECT @Cant Cantidad
	end
END 

