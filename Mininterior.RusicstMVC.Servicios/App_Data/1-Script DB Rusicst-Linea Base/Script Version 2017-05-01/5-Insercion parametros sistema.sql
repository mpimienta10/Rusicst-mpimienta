--===========================================================
-- Actualización de parámetros cambiando el correo de salida
--===========================================================
UPDATE 
	[dbo].[Sistema] 
SET 
	 [FromEmail] = 'reporteunificado@gmail.com'
	,[SmtpUsername] = 'reporteunificado@gmail.com'
	,[SmtpPassword] = 'ru51c5t2017*'
WHERE 
	[Id] = 1

--==================================================================================
-- Inserción de los datos en la tabla parámetros sistema
--==================================================================================
DELETE FROM [ParametrizacionSistema].[ParametrosSistema]
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (10, N'MsjSolicitudEnTramite', N'Usted ya Realizó la Validación correspondiente. Esté atento a la respuesta de su solicitud.')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (9, N'PlantillaGeneral', N'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Documento sin título</title>
</head>
<body>
    <table border="0" cellspacing="0" cellpadding="0" width="100%" bgcolor="#f4f4f4">
        <tr>
            <td valign="middle" align="center">
                <table style="color: #424242; font: 12px/16px Tahoma, Arial, Helvetica, sans-serif;" width="560" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td style="color: #0055a6; line-height: 30px; text-align: center">Este es un correo Automático. Favor no responder.<br />
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <img src="http://rusicst.mininterior.gov.co/Administracion/General/ImageHandler.ashx?id=ImageHandler4.png" alt="" /><br/><br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td valign="middle" align="center" bgcolor="#ffffff">
                            <table style="color: #424242; font: 14px/18px Tahoma, Arial, Helvetica, sans-serif;" width="520" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td style="color: #651C32; font: 24px/30px Tahoma, Arial, Helvetica, sans-serif;">
                                        <br />
                                        <singleline label="Title">{TITULO}</singleline>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                        <multiline label="Description" style="text-align: justify">{CONTENIDO}</multiline>
                                        <br />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                        <br />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="color: #424242; font-size: 11px; line-height: 18px; text-align: center">
                            <br />
                            Correo generado por el Sistema de información RUSICST ©
                            <br />
                            Ministerio del Interior	<br />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.URL8', N'http://www.google.com')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Name8', N'Google')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Color8', N'#ff0000')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (1, N'HeaderGobierno.ImagesFolder', N'/images/HeaderGobierno')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (1, N'HeaderGobierno.LogoMin', N'log-minint.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (1, N'HeaderGobierno.LogoMin.Height', N'66')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (1, N'HeaderGobierno.LogoMin.Width', N'292')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (1, N'HeaderGobierno.LogoPais', N'log-pais.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (1, N'HeaderGobierno.LogoPais.Height', N'139')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (1, N'HeaderGobierno.LogoPais.Width', N'313')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (1, N'HeaderGobierno.LogoVict', N'log-unidad-2.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (1, N'HeaderGobierno.LogoVict.Height', N'64')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (1, N'HeaderGobierno.LogoVict.Width', N'256')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (2, N'HeaderApp.ImagesFolder', N'/images/HeaderApp')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (2, N'HeaderApp.Logo', N'log-rusicst.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (2, N'HeaderApp.Logo.Height', N'53')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (2, N'HeaderApp.Logo.Width', N'731')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.AllowCustomSlider', N'true')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.HTMLCode', N'
  <!-- FlexSlider -->
  <script defer src="../../scripts/jquery.flexslider.js"></script>

  <script type="text/javascript">
    $(function(){
      SyntaxHighlighter.all();
    });
    $(window).load(function(){

      // Vimeo API nonsense
      var player = document.getElementById(''player_1'');
      $f(player).addEvent(''ready'', ready);

      function addEvent(element, eventName, callback) {
        (element.addEventListener) ? element.addEventListener(eventName, callback, false) : element.attachEvent(eventName, callback, false);
      }

      function ready(player_id) {
        var froogaloop = $f(player_id);

        froogaloop.addEvent(''play'', function(data) {
          $(''.flexslider'').flexslider("pause");
        });

        froogaloop.addEvent(''pause'', function(data) {
          $(''.flexslider'').flexslider("play");
        });
      }


      // Call fitVid before FlexSlider initializes, so the proper initial height can be retrieved.
      $(".flexslider")
        .fitVids()
        .flexslider({
          animation: "slide",
          useCSS: false,
          animationLoop: false,
          smoothHeight: true,
          start: function(slider){
            $(''body'').removeClass(''loading'');
          },
          before: function(slider){
            $f(player).api(''pause'');
          }
      });
    });
  </script>
  
    <!-- Optional FlexSlider Additions -->
    <script src="../../scripts/froogaloop.js"></script>
	<script src="../../scripts/jquery.fitvid.js"></script>

<link rel="stylesheet" href="../../styles/flexslider.css" type="text/css" media="screen" />

<div class="flexslider">
      <ul class="slides">
        <li>
          <img src="../../images/prueba.jpg" />
        </li>
        <li>
          <img src="../../images/prueba2.jpg" />
        </li>
        <li>
          <img src="../../images/prueba3.jpg" />
        </li>
        <li>
          <iframe id="player_1" src="http://www.youtube.com/embed/-luGsoGP8CI?api=1&player_id=player_1" width="960" height="463" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>
        </li>
      </ul>
    </div>')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.ImageCount', N'7')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.ImagesFolder', N'/images/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide1.Content', N'prueba.jpg')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide1.Type', N'I')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide2.Content', N'prueba2.jpg')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide2.Type', N'I')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide3.Content', N'prueba3.jpg')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide3.Type', N'I')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide4.Content', N'prueba4.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide4.Type', N'I')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide5.Content', N'prueba5.jpg')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide5.Type', N'I')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide6.Content', N'prueba6.jpg')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide6.Type', N'I')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide7.Content', N'prueba7.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.Slide7.Type', N'I')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (3, N'BodySlider.tinyMCE.ContentCSS', N'http://flexslider.woothemes.com/css/flexslider.css')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (4, N'Login.BodyText.AllowHTML', N'true')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (4, N'Login.BodyText.HTMLCode', N'<p class="p-text-login" style="text-align: justify; background: white;" data-mce-style="text-align: justify; background: white;"><span style="font-size: 9.5pt;" data-mce-style="font-size: 9.5pt;"><strong><span style="color: #c0c0c0;" data-mce-style="color: #c0c0c0;">De acuerdo</span> </strong><span style="color: #9a9a9a;" data-mce-style="color: #9a9a9a;">con el Numeral 1, Artículo 260 del Decreto 4800 de 2011, el Reporte Unificado del sistema de Información, Coordinación y Seguimiento Territorial de la Política Pública de Víctimas del Conflicto Armado Interno – RUSICST es un “...mecanismo de información, seguimiento y evaluación al desempeño de las entidades territoriales, en relación con la implementación de las Políticas Públicas y Planes de Acción de Prevención, Asistencia, atención y Reparación Integral”.</span></span></p><p class="p-text-login" style="text-align: justify;" data-mce-style="text-align: justify;"><span style="font-size: 9.5pt; color: #9a9a9a;" data-mce-style="font-size: 9.5pt; color: #9a9a9a;">En este sentido, el RUSICST permite fortalecer la capacidad institucional de su entidad territorial mediante la divulgación de la política pública, la identificación de las falencias instituc<span style="color: rgb(255, 0, 0);" data-mce-style="color: #ff0000;">ionales y la propuesta e implementación de un plan de mejoramiento que le permita avanzar gradualmente hacia la garantía de derechos de la población víctima. Adicionalmente, es el insumo para el proceso de certificación de las entidades territoriales, la aplicación de los principios de subsidiariedad, concurrencia y coordinación y la medición de la coordinación entre los diferentes niveles de gobierno. </span></span></p><p><span style="font-size: 12pt;" data-mce-style="font-size: 12pt;"><a href="http://apps.unidadvictimas.gov.co/pat/" target="_blank" rel="noopener noreferrer" data-mce-href="http://apps.unidadvictimas.gov.co/pat/">&gt; Ingrese aquí para dirigirse al Tablero PAT</a> </span></p><p><br></p><p><br></p>')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (4, N'Login.BodyText.ImagesFolder', N'/images/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.ImagesFolder', N'/images/CreditosGobierno')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Color1', N'#64002C')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Color2', N'#3C9900')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Color3', N'#163A92')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Color4', N'#6D1000')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Color5', N'#63002D')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Color6', N'#993366')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Color7', N'#000000')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Count', N'7')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Name1', N'Vicepresidencia')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Name2', N'MinAmbiente')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Name3', N'MinJusticia')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Name4', N'MinEducacion')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Name5', N'MinInterior')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Name6', N'MinTic')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.Name7', N'Tablero PAT')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.URL1', N'http://www.vicepresidencia.gov.co/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.URL2', N'www.minambiente.gov.co')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.URL3', N'http://www.minjusticia.gov.co')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.URL4', N'http://www.mineducacion.gov.co')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.URL5', N'www.mininterior.gov.co')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.URL6', N'http://www.mintic.gov.co/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.Links.URL7', N'http://apps.unidadvictimas.gov.co/pat/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.LogoGobierno', N'log-gobern.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.LogoGobierno.Height', N'25')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (5, N'CreditosGobierno.LogoGobierno.Width', N'220')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (6, N'Footer.AllowHTML', N'true')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (6, N'Footer.HTMLCode', N'<p style="text-align: center;" data-mce-style="text-align: center;"><span style="color: #6f1200;" data-mce-style="color: #6f1200;">Grupo de Articulación Interna para la Política de Víctimas del Conflicto Armado</span></p><p style="text-align: center;" data-mce-style="text-align: center;"><span style="color: #000000; font-size: 10px;" data-mce-style="color: #000000; font-size: 10px;"><span style="color: #000000;" data-mce-style="color: #000000;"><span style="color: #000000;" data-mce-style="color: #000000;"><span style="color: #000000;" data-mce-style="color: #000000;"><span style="color: #000000;" data-mce-style="color: #000000;"><span style="color: #6f1200;" data-mce-style="color: #6f1200;">Edificio Bancol <span style="color: #000000;" data-mce-style="color: #000000;">Carrera</span> 8 No 1<span style="color: #000000;" data-mce-style="color: #000000;">2B</span> - 31, Bogotá - <span style="color: rgb(255, 0, 255);" data-mce-style="color: #ff00ff;">Colombia</span> Línea de atención en Bogotá (57)(1) 2427400 ext 2723 - 2725</span></span></span></span></span></span></p>')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (6, N'Footer.ImagesFolder', N'/images/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (7, N'Index.BodyText.AllowHTML', N'true')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name22', N'Carta Conocimiento Información ')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File23', N'Matrices PAT - Evaluacion.xls')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name23', N'Matrices PAT - Evaluación')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File24', N'Administrar_tipos_Usuario.pdf')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name24', N'prueba 16082016')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File25', N'Administrar_tipos_Usuario.xlsx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name25', N'prueba2 16082016')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (7, N'Index.BodyText.HTMLCode', N'<p><strong><span style="font-size: 19px; display: block;" data-mce-style="font-size: 19px; display: block;"><span style="color: #0000ff;" data-mce-style="color: #0000ff;">¿Qué es RUSICST?</span></span></strong></p><p><span style="font-size: 12pt;" data-mce-style="font-size: 12pt;"><span style="color: #808080;" data-mce-style="color: #808080;">De acuerdo con el Numeral 1, Artículo 260 del Decreto 4800 de 2011, el Reporte Unificado del sistema de Información, Coordinación y Seguimiento Territorial de la Política Pública de Víctimas del Conflicto Armado Interno – RUSICST es un “...mecanismo de información, seguimiento y evaluación al desempeño de las entidades territoriales, en relación con la implementación de las Políticas Públicas y Planes de Acción de Prevención, Asistencia, atención y Reparación Integral”.</span></span></p><p><strong><span style="color: #6f1200; font-size: 18px; display: block;" data-mce-style="color: #6f1200; font-size: 18px; display: block;">¿Quiénes son los responsables del RUSICST?</span></strong>&nbsp;<br></p><p style="margin: 10px 40px; text-align: justify; font-size: 10px;" data-mce-style="margin: 10px 40px; text-align: justify; font-size: 10px;"><span style="font-size: 12pt;" data-mce-style="font-size: 12pt;"><span style="color: #808080;" data-mce-style="color: #808080;">El RUSICST, entró en funcionamiento desde el año 2009 con el objetivo de tener información sobre la capacidad administrativa y presupuestal de las entidades territoriales en la ejecución de las acciones encaminadas al goce efectivo<span style="background-color: rgb(255, 0, 255); color: rgb(51, 102, 255);" data-mce-style="background-color: #ff00ff; color: #3366ff;"> de los derechos de la población víctima del desplazamiento forzado. Con el envío de esta información al Ministerio del Interior así como a Acció</span>n Social, su entidad territorial daba cumplimiento a lo establecido en la Ley 1190 de 2008, el Decreto 1997 de 2009, el Auto 007 de 2009 y el Auto 383 de 2010. De esta forma, su entidad territorial debía reportar información, específicamente, sobre los avances y obstáculos de los compromisos administrativos y presupuestales, adquiridos, para atender a la población víctima del desplazamiento forzado.</span></span></p><p style="font-size: 10px; margin: 10px 40px; text-align: justify;" data-mce-style="font-size: 10px; margin: 10px 40px; text-align: justify;"><span style="font-size: 12pt;" data-mce-style="font-size: 12pt;"><span style="color: #808080;" data-mce-style="color: #808080;">Actualmente, con la expedición de la Ley de víctimas y restitución de tierras, la información que recaba el RUSICST abarca no solo a las ví<span style="color: rgb(153, 51, 0);" data-mce-style="color: #993300;">ctimas del desplazamiento forzado sino a todo el universo de víctimas. Es decir, al desplazamiento forzado se suman trece hechos victimizantes a saber: i) actos terroristas, atentados, combates, enfrentamientos, hostigamientos ii) amenazas iii) delitos contra la libertad e integridad sexual iv) desaparición forzada v) homicidios vi) masacres vii) minas antipersonal, munición sin explotar y artefactos explosivos improvisados viii)secuestro vi) tortura x) vinculación de niños, niñas y adolescente a actividades relacionadas con grupos ar</span>mados xii) despojo forzado de tierras xii) abandono forzado de tierras y xiii) confinamiento; todos ellos ocurridos en el marco del conflicto armado interno.</span></span></p><p style="color: #9a9a9a; font-size: 10px; margin: 10px 40px; text-align: justify; text-justify: inter-word;" data-mce-style="color: #9a9a9a; font-size: 10px; margin: 10px 40px; text-align: justify; text-justify: inter-word;"><span style="font-size: 12pt;" data-mce-style="font-size: 12pt;"><br></span></p><p><strong><span style="color: #6f1200; font-size: 18px; display: block;" data-mce-style="color: #6f1200; font-size: 18px; display: block;">¿Cuáles son los antecedentes del RUSICST?</span></strong>&nbsp;</p><p style="margin: 10px 40px; font-size: 10px;" data-mce-style="margin: 10px 40px; font-size: 10px;"><span style="font-size: 12pt;" data-mce-style="font-size: 12pt;"><span style="color: #808080;" data-mce-style="color: #808080;">De conformidad con el Artículo 260 del Decreto 4800 de 2011:</span></span></p><p style="margin: 10px 40px; text-align: justify; font-size: 10px;" data-mce-style="margin: 10px 40px; text-align: justify; font-size: 10px;"><span style="font-size: 12pt;" data-mce-style="font-size: 12pt;"><span style="color: #808080;" data-mce-style="color: #808080;">En el nivel territorial “...será responsa<span style="color: rgb(255, 0, 255);" data-mce-style="color: #ff00ff;">bilidad de los gobernadores y de los alcaldes, garantizar el personal y los equipos que permitan el suministro adecuado y oportuno de la información requerida mediante el [RUSICST]”. Igualmente, “para la operación del RUS</span>ICST, las autoridades de las alcaldías y gobernaciones, designarán un enlace que se encargue de reportar la información actualizada por semestres...”</span></span></p><p style="font-size: 10px; margin: 10px 40px; text-align: justify;" data-mce-style="font-size: 10px; margin: 10px 40px; text-align: justify;"><span style="color: rgb(255, 255, 0); font-size: 12pt;" data-mce-style="color: #ffff00; font-size: 12pt;"><span style="color: rgb(255, 255, 0);" data-mce-style="color: #ffff00;"><span style="color: #808080;" data-mce-style="color: #808080;">En el nivel nacional “el Ministerio del Interior en conjunto co<span style="color: rgb(255, 204, 0);" data-mce-style="color: #ffcc00;">n la Unidad Administrativa Especial para la Atención y Reparación Integral a las Víctimas, diseñará y operará el RUSICST</span>...”</span></span></span></p><p>&nbsp;<br></p><p><strong><span style="color: #6f1200; font-size: 18px; display: block;" data-mce-style="color: #6f1200; font-size: 18px; display: block;">¿Cuál es la estructura del RUSICST?</span></strong>&nbsp;<br></p><p style="color: #9a9a9a; font-size: 10px; margin: 10px 40px; text-align: justify; text-justify: inter-word;" data-mce-style="color: #9a9a9a; font-size: 10px; margin: 10px 40px; text-align: justify; text-justify: inter-word;"><span style="font-size: 12pt;" data-mce-style="font-size: 12pt;"><br></span></p><p style="font-size: 10px; margin: 10px 40px; text-align: justify;" data-mce-style="font-size: 10px; margin: 10px 40px; text-align: justify;"><span style="font-size: 12pt;" data-mce-style="font-size: 12pt;"><span style="color: #808080;" data-mce-style="color: #808080;">El RUSICST fue diseñado teniendo en cuenta tres etapas del ciclo de política pública con el fin que su entidad territorial pueda agrupar las acciones realizadas en el diseño, la implementación y el seguimiento y la evaluación de la Política Pública de Víctimas del Conflicto Armado Interno:</span></span></p><p style="color: #9a9a9a; font-size: 10px; margin: 10px 40px;" data-mce-style="color: #9a9a9a; font-size: 10px; margin: 10px 40px;"><br></p><table cellspacing="0" cellpadding="0" style="border-collapse: collapse; width: 100%; background-color: #f0e7e5;" data-mce-style="border-collapse: collapse; width: 100%; background-color: #f0e7e5;" class="mce-item-table"><tbody><tr><td style="width: 33.3333333333333%;" data-mce-style="width: 33.3333333333333%;"><ul><li style="margin-bottom: 10px; color: #6f1200; font-size: 18px; text-decoration: underline; list-style: none;" data-mce-style="margin-bottom: 10px; color: #6f1200; font-size: 18px; text-decoration: underline; list-style: none;">Diseño</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Dinámica del Conflicto Armado</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Comité&nbsp;de Justicia Transicional</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Plan de Acción Territorial</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Participación de las Víctimas</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Articulación Institucional</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Retorno y Reubicación</li></ul></td><td style="width: 33.3333333333333%;" data-mce-style="width: 33.3333333333333%;"><ul><li style="margin-bottom: 10px; color: #6f1200; font-size: 18px; text-decoration: underline; list-style: none;" data-mce-style="margin-bottom: 10px; color: #6f1200; font-size: 18px; text-decoration: underline; list-style: none;">Implementación</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Comité&nbsp;de Justicia Transicional</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Plan de Acción Territorial</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Participación de las Víctimas</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Articulación Institucional</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Retorno y Reubicación</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Adecuación Institucional</li></ul></td><td style="width: 33.3333333333333%;" data-mce-style="width: 33.3333333333333%;"><ul><li style="margin-bottom: 10px; color: #6f1200; font-size: 18px; text-decoration: underline; list-style: none;" data-mce-style="margin-bottom: 10px; color: #6f1200; font-size: 18px; text-decoration: underline; list-style: none;">Evaluación y seguimiento</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Comité de Justicia Transicional</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Plan de Acción Territorial</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Participación de las Víctimas</li><li style="color: #9a9a9a; font-size: 12px; list-style: inside;" data-mce-style="color: #9a9a9a; font-size: 12px; list-style: inside;">Retorno y Reubicación</li></ul><div><span style="color: #9a9a9a;" data-mce-style="color: #9a9a9a;"><span style="font-size: 11.9999990463257px;" data-mce-style="font-size: 11.9999990463257px;"><br></span></span></div></td></tr></tbody></table>')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (7, N'Index.BodyText.ImagesFolder', N'/images/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.Facebook.Image', N'rs-4.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.Facebook.URL', N'www.faceboo.com')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.Flicker.Image', N'rs-6.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.Flicker.URL', N'www.flick.com')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.GooglePlus.Image', N'rs-2.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.GooglePlus.URL', N'www.google.com')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.ImagesFolder', N'/images/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.Position', N'Top')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.RSS.Image', N'rs-3.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.RSS.URL', N'www.rss.com')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.SoundCloud.Image', N'rs-1.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.SoundCloud.URL', N'www.google.com')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.Twitter.Image', N'rs-5.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.Twitter.URL', N'www.twitter.com')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.Youtube.Image', N'rs-7.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (8, N'SocialNetworks.Youtube.URL', N'www.yotube.com')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (9, N'PlantillaConfirmacionSolicitud', N'Buenas tardes,<br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la Atención y Reparación Integral a las Víctimas</b>.<br><br>
Su solicitud de Usuario ha sido confirmada por parte del Ministerio. Por favor ingrese al siguiente <strong><a href="{0}"><singleline label="Title">Vinculo de Confirmación </singleline></a></strong>  para confirmar su registro.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención,<br><br><br><b>Grupo de Apoyo a la Coordinación Territorial en<br>
Materia de Política de Víctimas del Conflicto Armado</b>')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (9, N'PlantillaCreacionUsuario', N'Buenas tardes,<br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la  Atención y Reparación Integral a las Víctimas</b>.<br><br>
Su usuario ha sido creado o actualizado correctamente en el sistema, con las siguientes credenciales:<br><br><b>Usuario:</b>{0}<br><b>Contraseña:</b> {1}<br><br>Diríjase al siguiente Vínculo, 
para ingresar al sistema <a href="{2}">Login.</a>.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se  requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br>Agradecemos su atención,<br><br><b>Grupo de Apoyo a la Coordinación Territorial en<br>  Materia de Política de Víctimas del Conflicto Armado</b>')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (9, N'PlantillaError', N'<html>
<head>
</head>
<body>


<p style="margin: 20px 0 0 0">Buenas tardes, <br/>Se reporto un error con la siguiente informaci&oacute;n.</p>


<p>id del Error: {id}</p>

<p>Descripci&oacute; {id}</p>


<p><b>Grupo de Apoyo a la Coordinación Territorial en<br/>
Materia de Política de Víctimas del Conflicto Armado</b></p>

</body>
</html>
')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (9, N'PlantillaRechazoSolicitud', N'Buenas tardes,<br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la  Atención y Reparación Integral a las Víctimas</b>.<br><br>
Su solicitud de Usuario ha sido rechazada, por favor comuniquese al correo <b>reporteunificado@mininterior.gov.co</b>, para tener un mayor detalle de esta decisión.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se  requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención,<br><br><br><b>Grupo de Apoyo a la Coordinación Territorial en<br>
Materia de Política de Víctimas del Conflicto Armado</b>')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (9, N'PlantillaSolicitudUsuario', N'Buenas tardes,<br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad Administrativa para la Atención y Reparación Integral a las Víctimas</b>.<br><br>
Su solicitud de Usuario ha sido enviada con éxito al Ministerio. Por favor ingrese al siguiente <strong><a href="{0}"><singleline label="Title">Vinculo de Confirmación </singleline></a></strong>  para confirmar su solicitud.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención,<br><br><br><b>Grupo de Apoyo a la Coordinación Territorial en<br>
Materia de Política de Víctimas del Conflicto Armado</b>')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (10, N'MsjConfirmacionActualizacionUsuario', N'El usuario fue actualizado con exíto, por favor diríjase al Login e ingrese con sus credenciales')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (10, N'MsjConfirmacionCreacionUsuario', N'El usuario fue creado con exíto, por favor diríjase al Login e ingrese con sus credenciales')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (10, N'MsjConfirmacionNoRepudio', N'Gracias por realizar la confirmación de no repudio, el Ministerio del Interior le comunicará cuando su solicitud sea aceptada.')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (10, N'MsjInstruccionesGeo', N'Debe seleccionar las Filas y Columnas necesarias para poder desplegar la información.')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (10, N'MsjTitulosGeo', N'Mapa Geográfico')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (11, N'SocialNetworksList', N'SoundCloud')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (11, N'SocialNetworksList2', N'Google+')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (11, N'SocialNetworksList3', N'RSS')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (11, N'SocialNetworksList4', N'Facebook')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (11, N'SocialNetworksList5', N'Twitter')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (11, N'SocialNetworksList6', N'Flicker')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (11, N'SocialNetworksList7', N'Youtube')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Count', N'25')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File1', N'C:\rusicst-files\Ayuda\\Ficha Recoleccion de Informacion RUSICST - Alcaldias.pdf')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File10', N'Ficha Recoleccion de Informacion RUSICST - Gobernaciones.pdf')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File11', N'¡NUEVO! Cifras Declaración Enero-Junio 2015.xlsx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File12', N'Cartila_Victimas.pdf')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File13', N'Brochure_candidatos.pdf')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File14', N'Encuesta Criterio Restitución de Tierras.docx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File15', N'Cifras Declaración Julio-Noviembre 2015.xlsx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File16', N'Modelo Carta Aval RUSICST - Alcaldías 2015.docx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File17', N'Modelo Carta Aval RUSICST - Gobernaciones 2015.docx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File18', N'Modelo Designacion Enlace RUSICST - Alcaldias y Gobernaciones 2016.docx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File19', N'Cartilla Planes de Desarrollo 2016-2019.pdf')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File2', N'Guía Metodológica - Alcaldías.pdf')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File20', N'Check List Archivos Adjuntos - alcaldias.xlsx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File21', N'Check List_ Adjuntos -  RUSICST_Gobernaciones.xlsx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name21', N'CheckList - Archivo adjunto - Gobernaciones')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File3', N'Guía Metodológica - Gobernaciones.pdf')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File4', N'C:\rusicst-files\Ayuda\\Modelo Decreto RUSICST - Alcaldias y Gobernaciones.docx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File5', N'C:\rusicst-files\Ayuda\\Presentacion Fichas de Informacion Municipal y Departamental.pdf')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File6', N'C:\rusicst-files\Ayuda\\Proceso Construccion - RUSICST.pdf')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File7', N'C:\rusicst-files\Ayuda\\Propuesta Plan de Trabajo Comites.pdf')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File8', N'C:\rusicst-files\Ayuda\\Salida de Informacion - Gobernaciones.xlsx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File9', N'Salida de Informacion - Municipios.xlsx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name1', N'Ficha Recoleccion de Informacion RUSICST - Alcaldias')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name10', N'Ficha Recoleccion de Informacion RUSICST - Gobernaciones')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name11', N'¡NUEVO! Cifras Declaración Enero-Junio 2015')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name12', N'Cartilla Víctimas')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name13', N'Brochure Candidatos')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name14', N'Encuesta Criterio Restitución de Tierras')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name15', N'Cifras Declaración Julio-Noviembre 2015')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name16', N'Modelo Carta Aval RUSICST - Alcaldías')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name17', N'Modelo Carta Aval RUSICST - Gobernaciones')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name18', N'Modelo Designación Enlace RUSICST - Alcaldías y Gobernaciones')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name19', N'Cartilla Planes de Desarrollo 2016-2019')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name2', N'Guía Metodológica - Alcaldías')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name20', N'Check List - Archivos adjuntos - Alcaldías')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.File22', N'Modelo Carta - Conocmiento de Informacion - RUSICST.docx')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name3', N'Guía Metodológica - Gobernaciones')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name4', N'Modelo Decreto RUSICST - Alcaldias y Gobernaciones')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name5', N'Presentacion Fichas de Informacion Municipal y Departamental')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name6', N'Proceso Construccion - RUSICST')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name7', N'Propuesta Plan de Trabajo Comites')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name8', N'Salida de Informacion - Gobernaciones')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (12, N'FilesAyuda.Name9', N'Salida de Información - Municipios')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (13, N'HeaderGobierno.ImagesFolder', N'/images/HeaderGobierno')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (13, N'HeaderGobierno.LogoMin', N'log-minint.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (13, N'HeaderGobierno.LogoMin.Height', N'66')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (13, N'HeaderGobierno.LogoMin.Width', N'292')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (13, N'HeaderGobierno.LogoPais', N'log-pais.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (13, N'HeaderGobierno.LogoPais.Height', N'139')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (13, N'HeaderGobierno.LogoPais.Width', N'313')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (13, N'HeaderGobierno.LogoVict', N'log-unidad-2.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (13, N'HeaderGobierno.LogoVict.Height', N'64')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (13, N'HeaderGobierno.LogoVict.Width', N'256')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (14, N'HeaderApp.ImagesFolder', N'/images/HeaderApp')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (14, N'HeaderApp.Logo', N'log-rusicst.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (14, N'HeaderApp.Logo.Height', N'53')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (14, N'HeaderApp.Logo.Width', N'731')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (15, N'BodySlider.AllowCustomSlider', N'true')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (15, N'BodySlider.HTMLCode', N'
  <!-- FlexSlider -->
  <script defer src="../../scripts/jquery.flexslider.js"></script>

  <script type="text/javascript">
    $(function(){
      SyntaxHighlighter.all();
    });
    $(window).load(function(){

      // Vimeo API nonsense
      var player = document.getElementById(''player_1'');
      $f(player).addEvent(''ready'', ready);

      function addEvent(element, eventName, callback) {
        (element.addEventListener) ? element.addEventListener(eventName, callback, false) : element.attachEvent(eventName, callback, false);
      }

      function ready(player_id) {
        var froogaloop = $f(player_id);

        froogaloop.addEvent(''play'', function(data) {
          $(''.flexslider'').flexslider("pause");
        });

        froogaloop.addEvent(''pause'', function(data) {
          $(''.flexslider'').flexslider("play");
        });
      }


      // Call fitVid before FlexSlider initializes, so the proper initial height can be retrieved.
      $(".flexslider")
        .fitVids()
        .flexslider({
          animation: "slide",
          useCSS: false,
          animationLoop: false,
          smoothHeight: true,
          start: function(slider){
            $(''body'').removeClass(''loading'');
          },
          before: function(slider){
            $f(player).api(''pause'');
          }
      });
    });
  </script>
  
    <!-- Optional FlexSlider Additions -->
    <script src="../../scripts/froogaloop.js"></script>
	<script src="../../scripts/jquery.fitvid.js"></script>

<link rel="stylesheet" href="../../styles/flexslider.css" type="text/css" media="screen" />

<div class="flexslider">
      <ul class="slides">
        <li>
          <img src="../../images/prueba.jpg" />
        </li>
        <li>
          <img src="../../images/prueba2.jpg" />
        </li>
        <li>
          <img src="../../images/prueba3.jpg" />
        </li>
        <li>
          <iframe id="player_1" src="http://www.youtube.com/embed/-luGsoGP8CI?api=1&player_id=player_1" width="960" height="463" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>
        </li>
      </ul>
    </div>')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (15, N'BodySlider.ImageCount', N'3')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (15, N'BodySlider.ImagesFolder', N'/images/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (15, N'BodySlider.Slide1.Content', N'prueba.jpg')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (15, N'BodySlider.Slide1.Type', N'I')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (15, N'BodySlider.Slide2.Content', N'prueba2.jpg')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (15, N'BodySlider.Slide2.Type', N'I')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (15, N'BodySlider.Slide3.Content', N'prueba3.jpg')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (15, N'BodySlider.Slide3.Type', N'I')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (15, N'BodySlider.tinyMCE.ContentCSS', N'http://flexslider.woothemes.com/css/flexslider.css')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.ImagesFolder', N'/images/CreditosGobierno')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Color1', N'#64002C')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Color2', N'#3C9900')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Color3', N'#163A92')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Color4', N'#6D1000')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Color5', N'#63002D')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Color6', N'#800080')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Color7', N'#000000')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Count', N'8')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Name1', N'Vicepresidencia')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Name2', N'MinAmbiente')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Name3', N'MinJusticia')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Name4', N'MinEducacion')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Name5', N'MinInterior')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Name6', N'MinTic')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.Name7', N'Tablero Pat')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.URL1', N'http://www.vicepresidencia.gov.co/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.URL2', N'www.minambiente.gov.co')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.URL3', N'http://www.minjusticia.gov.co')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.URL4', N'http://www.mineducacion.gov.co')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.URL5', N'www.mininterior.gov.co')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.URL6', N'http://www.mintic.gov.co/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.Links.URL7', N'http://apps.unidadvictimas.gov.co/pat/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.LogoGobierno', N'log-gobern.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.LogoGobierno.Height', N'25')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (16, N'CreditosGobierno.LogoGobierno.Width', N'220')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (17, N'Footer.AllowHTML', N'true')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (17, N'Footer.HTMLCode', N'<p style="text-align: center;" data-mce-style="text-align: center;"><span style="color: #6f1200;" data-mce-style="color: #6f1200;">Grupo de Articulación Interna para la <span style="background-color: rgb(255, 153, 0);" data-mce-style="background-color: #ff9900;">Política de Víctimas del Conflicto Armado</span></span></p><p style="text-align: center;" data-mce-style="text-align: center;"><span style="font-size: 10px; background-color: rgb(255, 153, 0);" data-mce-style="font-size: 10px; background-color: #ff9900;"><span style="color: #6f1200;" data-mce-style="color: #6f1200;"><span style="background-color: rgb(255, 153, 0);" data-mce-style="background-color: #ff9900;">Edificio Bancol Carrera 8 No 12B - 31, Bogotá - Colombia Línea de atención en Bogotá (57)(1) 24274</span>00 ext 2723 - 2725.</span></span></p>')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (17, N'Footer.ImagesFolder', N'/images/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.Facebook.Image', N'rs-4.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.Facebook.URL', N'https://www.facebook.com/MinInterior')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.Flicker.Image', N'rs-6.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.Flicker.URL', N'www.flicker.com')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.GooglePlus.Image', N'rs-2.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.GooglePlus.URL', N'http://plus.google.com')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.ImagesFolder', N'/images/')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.Position', N'Top')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.RSS.Image', N'rs-3.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.RSS.URL', N'http://www.mininterior.gov.co/principalesnoticias-rss')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.SoundCloud.Image', N'rs-1.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.SoundCloud.URL', N'www.soundcloud.com')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.Twitter.Image', N'rs-5.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.Twitter.URL', N'https://twitter.com/MININTERIOR')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.Youtube.Image', N'rs-7.png')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (18, N'SocialNetworks.Youtube.URL', N'www.youtube.com')
GO
INSERT [ParametrizacionSistema].[ParametrosSistema] ([IDGrupo], [ParametroID], [ParametroValor]) VALUES (19, N'URLChat.URL', N'http://192.168.17.45:81/account/login')
GO

