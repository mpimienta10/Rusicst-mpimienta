--==================================
-- Elimina la tabla de migración
--==================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[__MigrationHistory]') AND type in (N'U')) 
DROP TABLE [dbo].[__MigrationHistory]

--====================================================================================================================================
-- Actualiza la información de las plantillas para justificar el texto e inserta dos plantillas nuevas para el manejo de la seguridad
--====================================================================================================================================
UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET ParametroValor = '<p>Buenas tardes, <br/><br/>Se reporto un error con la siguiente información.</p><p>Id del Error: <b>{0}</b></p><p>Descripción: {1}</p><p><b><br>Grupo de Apoyo a la Coordinación Territorial en<br/>Materia de Política de Víctimas del Conflicto Armado</b></p>'
WHERE ParametroID = 'PlantillaError' AND IDGrupo = 9

UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET ParametroValor = '<p>Buenas tardes,<br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la Atención y Reparación Integral a las Víctimas</b>.<br><br>Su solicitud de Usuario ha sido confirmada por parte del Ministerio. Por favor ingrese al siguiente <strong><a href="{0}"><singleline label="Title">Vinculo de Confirmación </singleline></a></strong>  para confirmar su registro.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención,<br><br><br><b>Grupo de Apoyo a la Coordinación Territorial en<br>Materia de Política de Víctimas del Conflicto Armado</b></p>'
WHERE ParametroID = 'PlantillaConfirmacionSolicitud' AND IDGrupo = 9

UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET ParametroValor = '<p>Buenas tardes,<br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la  Atención y Reparación Integral a las Víctimas</b>.<br><br>Su usuario ha sido creado o actualizado correctamente en el sistema, con las siguientes credenciales:<br><br><b>Usuario:</b>{0}<br><b>Contraseña:</b> {1}<br><br>Diríjase al siguiente Vínculo, para ingresar al sistema <strong><a href="{2}">RUSICST.</a></strong><br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se  requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br>Agradecemos su atención,<br><br><b>Grupo de Apoyo a la Coordinación Territorial en<br>  Materia de Política de Víctimas del Conflicto Armado</b></p>'
WHERE ParametroID = 'PlantillaCreacionUsuario' AND IDGrupo = 9

UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET ParametroValor = '<p>Buenas tardes,<br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la Atención y Reparación Integral a las Víctimas</b>.<br><br>Su solicitud de Usuario ha sido enviada con éxito al Ministerio. Por favor ingrese al siguiente <strong><a href="{0}"><singleline label="Title">Vinculo de Confirmación </singleline></a></strong>  para confirmar su solicitud.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención,<br><br><br><b>Grupo de Apoyo a la Coordinación Territorial en<br>Materia de Política de Víctimas del Conflicto Armado</b></p>'
WHERE ParametroID = 'PlantillaSolicitudUsuario' AND IDGrupo = 9

UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET ParametroValor = '<p>Buenas tardes,<br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la  Atención y Reparación Integral a las Víctimas</b>.<br><br>Su solicitud de Usuario ha sido rechazada, por favor comuniquese al correo <b>reporteunificado@mininterior.gov.co</b>, para tener un mayor detalle de esta decisión.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se  requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención,<br><br><br><b>Grupo de Apoyo a la Coordinación Territorial en<br>Materia de Política de Víctimas del Conflicto Armado</b></p>'
WHERE ParametroID = 'PlantillaRechazoSolicitud' AND IDGrupo = 9

UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET ParametroValor = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Documento sin título</title></head><body><table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#f4f4f4"><tr><td valign="middle" align="center"><table style="color: #424242; font: 12px/16px Tahoma, Arial, Helvetica, sans-serif;" width="560" border="0" cellspacing="0" cellpadding="0"><tr><td style="color: #0055a6; line-height: 30px; text-align: center">Este es un correo Automático. Favor no responder.<br /><br /></td></tr><tr><td><img src="http://rusicst.mininterior.gov.co/Administracion/General/ImageHandler.ashx?id=ImageHandler4.png" alt="" /><br/><br/><br/></td></tr><tr><td valign="middle" align="center" bgcolor="#ffffff"><table style="color: #424242; font: 14px/18px Tahoma, Arial, Helvetica, sans-serif;" width="520" border="0" cellspacing="0" cellpadding="0"><tr><td style="color: #651C32; font: 24px/30px Tahoma, Arial, Helvetica, sans-serif;"><br /><singleline label="Title">{TITULO}</singleline><br /></td></tr><tr><td><br /><div style="text-align: justify">{CONTENIDO}</div><br /></td></tr><tr><td><br /><br /></td></tr></table></td></tr><tr><td style="color: #424242; font-size: 11px; line-height: 18px; text-align: center"><br />Correo generado por el Sistema de información RUSICST ©<br />Ministerio del Interior	<br /></td></tr></table></td></tr></table></body></html>'
WHERE ParametroID = 'PlantillaGeneral' AND IDGrupo = 9

IF (NOT EXISTS (SELECT * FROM [ParametrizacionSistema].[ParametrosSistema] WHERE [IDGrupo] = 9 AND [ParametroID]='PlantillaRecuperarClave'))
INSERT INTO [ParametrizacionSistema].[ParametrosSistema]([IDGrupo],[ParametroID],[ParametroValor])
VALUES(9,'PlantillaRecuperarClave','<p>Buenas tardes,<br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la Atención y Reparación Integral a las Víctimas</b>.<br><br>Su solicitud de Recuperación de Contraseña ha sido confirmada por parte del Ministerio.<br><br>Clave: <b>{0}</b><br><br>Por favor ingrese al siguiente vínculo <strong><a href="{1}" target="_blank"><singleline label="Title">RUSICST </singleline></a></strong> para ingresar al Sistema de Información.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención,<br><br><br><b>Grupo de Apoyo a la Coordinación Territorial en<br>Materia de Política de Víctimas del Conflicto Armado</b></p>')
ELSE
UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET ParametroValor = '<p>Buenas tardes,<br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la Atención y Reparación Integral a las Víctimas</b>.<br><br>Su solicitud de Recuperación de Contraseña ha sido confirmada por parte del Ministerio.<br><br>Clave: <b>{0}</b><br><br>Por favor ingrese al siguiente vínculo <strong><a href="{1}" target="_blank"><singleline label="Title">RUSICST </singleline></a></strong> para ingresar al Sistema de Información.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención,<br><br><br><b>Grupo de Apoyo a la Coordinación Territorial en<br>Materia de Política de Víctimas del Conflicto Armado</b></p>'
WHERE ParametroID = 'PlantillaRecuperarClave' AND IDGrupo = 9
GO

IF (NOT EXISTS (SELECT * FROM [ParametrizacionSistema].[ParametrosSistema] WHERE [IDGrupo] = 9 AND [ParametroID]='PlantillaBienvenida'))
INSERT INTO [ParametrizacionSistema].[ParametrosSistema]([IDGrupo],[ParametroID],[ParametroValor])
VALUES(9,'PlantillaBienvenida','<p>Buenas tardes,<br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la  Atención y Reparación Integral a las Víctimas</b>.<br></p><p>Siendo la construcción de paz un compromiso nacional y la garantía de los derechos de las víctimas una responsabilidad del Estado en su conjunto, el <b>Reporte Unificado del Sistema de Información, Coordinación y Seguimiento Territorial de la Política Pública de Víctimas –RUSICST</b>, herramienta de seguimiento a la implementación de la política pública de víctimas, como es de su conocimiento es responsabilidad del <b>Ministerio del Interior</b> y <b>La UARIV</b> el diseño y puesta en funcionamiento, así como es de las entidades territoriales el reporte periódico.</p><p>Nos permitimos informarle que la plataforma para el reporte ha sido diseñada de tal manera que sea más efectivo el proceso y se encuentra alojado en el link:</p><div style="text-align: center;"><b><a href="{0}">RUSICST</a></b></div><p>Cada entidad territorial cuenta con la responsabilidad de suministrar la información, para lo cual se le asigna un usuario y contraseña personal y confidencial por lo tanto es responsabilidad del enlace designado por la Autoridad territorial el uso y manejo de la misma.</p><p><b>El Ministerio del Interior</b> y <b>La UARIV</b> en el proceso de implementación ha venido desarrollando capacitaciones programadas para el mes de febrero, en los diferentes departamentos, con el fin de aumentar la capacidad de los enlaces en el proceso de reporte.</p><p>Es un gusto darle la bienvenida al <b>RUSICST</b> y asignarle su respectivo usuario y contraseña:</p><div style="text-align: center;">Usuario: <b>{1}</b><br>Contraseña: <b>{2}</b></div><p>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.</p><p>Agradecemos su atención,<br/><br/></p><p><b>Grupo de Apoyo a la Coordinación Territorial en<br>Materia de Política de Víctimas del Conflicto Armado</b></p>')
ELSE
UPDATE [ParametrizacionSistema].[ParametrosSistema] 
SET ParametroValor = '<p>Buenas tardes,<br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la  Atención y Reparación Integral a las Víctimas</b>.<br></p><p>Siendo la construcción de paz un compromiso nacional y la garantía de los derechos de las víctimas una responsabilidad del Estado en su conjunto, el <b>Reporte Unificado del Sistema de Información, Coordinación y Seguimiento Territorial de la Política Pública de Víctimas –RUSICST</b>, herramienta de seguimiento a la implementación de la política pública de víctimas, como es de su conocimiento es responsabilidad del <b>Ministerio del Interior</b> y <b>La UARIV</b> el diseño y puesta en funcionamiento, así como es de las entidades territoriales el reporte periódico.</p><p>Nos permitimos informarle que la plataforma para el reporte ha sido diseñada de tal manera que sea más efectivo el proceso y se encuentra alojado en el link:</p><div style="text-align: center;"><b><a href="{0}">RUSICST</a></b></div><p>Cada entidad territorial cuenta con la responsabilidad de suministrar la información, para lo cual se le asigna un usuario y contraseña personal y confidencial por lo tanto es responsabilidad del enlace designado por la Autoridad territorial el uso y manejo de la misma.</p><p><b>El Ministerio del Interior</b> y <b>La UARIV</b> en el proceso de implementación ha venido desarrollando capacitaciones programadas para el mes de febrero, en los diferentes departamentos, con el fin de aumentar la capacidad de los enlaces en el proceso de reporte.</p><p>Es un gusto darle la bienvenida al <b>RUSICST</b> y asignarle su respectivo usuario y contraseña:</p><div style="text-align: center;">Usuario: <b>{1}</b><br>Contraseña: <b>{2}</b></div><p>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.</p><p>Agradecemos su atención,<br/><br/></p><p><b>Grupo de Apoyo a la Coordinación Territorial en<br>Materia de Política de Víctimas del Conflicto Armado</b></p>'
WHERE ParametroID = 'PlantillaBienvenida' AND IDGrupo = 9
GO

IF (NOT EXISTS (SELECT * FROM [ParametrizacionSistema].[ParametrosSistema] WHERE [IDGrupo] = 10 AND [ParametroID]='MsjConfirmacionClave'))
INSERT INTO [ParametrizacionSistema].[ParametrosSistema]([IDGrupo],[ParametroID],[ParametroValor])
VALUES(10, 'MsjConfirmacionClave', 'La contraseña se ha cambiado satisfactoriamente.')
GO

IF (NOT EXISTS (SELECT * FROM [ParametrizacionSistema].[ParametrosSistema] WHERE [IDGrupo] = 10 AND [ParametroID]='MsjCorreoInvalido'))
INSERT INTO [ParametrizacionSistema].[ParametrosSistema]([IDGrupo],[ParametroID],[ParametroValor])
VALUES(10, 'MsjCorreoInvalido', 'El correo electrónico no es válido.')
GO

