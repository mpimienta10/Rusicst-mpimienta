
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[C_BuscadorBI]') AND type in (N'P', N'PC')) 
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[C_BuscadorBI] AS'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==========================================================================
-- Author:		Equipo de desarrollo OIM - Nelson Restrepo
-- Create date: Desconocida
-- Update date: 01-12-2017
-- Update Author: Christian Ospina
-- Description:	Procedimiento que se activa al ejecutar el buscador. 
--				ejecuta filtros por palabra clave, departamento y municipio
--				de acuerdo al tipo de usuario que realiza la búsqueda
-- ===========================================================================

ALTER PROCEDURE [dbo].[C_BuscadorBI] 

    @SearchTerms varchar(2000),
    @UserName varchar(200)

AS
BEGIN
    SET FMTONLY OFF;
    
    DECLARE @parsedPhrase NVARCHAR(MAX)
    DECLARE @usertype VARCHAR(20)
    DECLARE @dep VARCHAR(2)
    DECLARE @mun VARCHAR(5)
    DECLARE @palabras NVARCHAR(MAX)
    
	--=============================================================
	-- Selecciona el tipo de usuario que esta haciendo la petición
	--=============================================================
	SELECT @usertype = [Nombre] FROM [dbo].[TipoUsuario] WHERE [Id] = (SELECT TOP 1 [IdTipoUsuario] FROM [dbo].[Usuario] WHERE [UserName] = @UserName)

	--============================================================================
	-- Selecciona el departamento relacionado con el usuario que hace la petición
	--============================================================================
	SELECT @dep = (CASE WHEN Divipola < 10 THEN '0' ELSE '' END) + Divipola FROM [dbo].[Departamento] WHERE [Id] = (SELECT TOP 1 IdDepartamento FROM [dbo].[Usuario] WHERE [UserName] = @UserName)

	--=========================================================================
	-- Selecciona el municipio relacionado con el usuario que hace la petición
	--=========================================================================
	SELECT @mun = (CASE WHEN Divipola < 10000 THEN '0' ELSE '' END) + Divipola FROM [dbo].[Municipio] WHERE [Id] = (SELECT TOP 1 IdMunicipio FROM [dbo].[Usuario] WHERE [UserName] = @UserName)

    SET @parsedPhrase = REPLACE(@SearchTerms, ' ', ';')
    SET @parsedPhrase = 'CONTAINS(*, ''"' + REPLACE(@parsedPhrase, ';', '*"'') AND CONTAINS(*, ''"') + '*"'')'   
    
    IF (@usertype = 'ALCALDIA')
		BEGIN
			SET @parsedPhrase = '
									SELECT TOP 1000
										 Departamento
										,Municipio
										,Nombre Pregunta
										,Valor Respuesta
										,titulo_encuesta
										,titulo_etapa Etapa
										,titulo_seccion Seccion
										,titulo_pagina Pagina
										,id_encuesta
										,id_etapa
										,id_seccion
										,id_pagina
										,id_pregunta
										,Usuario
										,div_depto
										,div_muni 
									FROM 
										SearchCatalog (NOLOCK)
									WHERE 
										(' + @parsedPhrase + ')
										AND div_depto = @dep AND div_muni = @mun
									ORDER BY 1 DESC'

			PRINT @parsedPhrase

			EXECUTE sp_executesql @parsedPhrase, N'@dep VARCHAR(2), @mun varchar(5)', @dep = @dep, @mun = @mun
		END
    ELSE IF (@usertype = 'GOBERNACION')
		BEGIN
			SET @parsedPhrase = '
									SELECT TOP 1000
										 Departamento
										,Municipio
										,Nombre Pregunta
										,Valor Respuesta
										,titulo_encuesta
										,titulo_etapa Etapa
										,titulo_seccion Seccion
										,titulo_pagina Pagina
										,id_encuesta
										,id_etapa
										,id_seccion
										,id_pagina
										,id_pregunta
										,Usuario
										,div_depto
										,div_muni 
									FROM SearchCatalog (NOLOCK)
									WHERE (' + @parsedPhrase + ')
									AND div_depto = @dep
									ORDER BY 1 DESC'

			PRINT @parsedPhrase

			EXECUTE sp_executesql @parsedPhrase, N'@dep VARCHAR(2)', @dep = @dep
		END
    ELSE
		BEGIN
			SET @parsedPhrase = '
									SELECT TOP 1000
										 Departamento
										,Municipio
										,Nombre Pregunta
										,Valor Respuesta
										,titulo_encuesta
										,titulo_etapa Etapa
										,titulo_seccion Seccion
										,titulo_pagina Pagina
										,id_encuesta
										,id_etapa
										,id_seccion
										,id_pagina
										,id_pregunta
										,Usuario
										,div_depto
										,div_muni 
									FROM SearchCatalog (NOLOCK)
									WHERE (' + @parsedPhrase + ')
									ORDER BY 1 DESC'

			PRINT @parsedPhrase

			EXECUTE sp_executesql @parsedPhrase
		END    
END