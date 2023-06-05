// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-26-2017
// ***********************************************************************
// <copyright file="MenuSistema.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Models namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Models
{
    using System;
    using System.Collections.Generic;
    using System.Web.Mvc;

    /// <summary>
    /// Class ParametrosSistemaModels.
    /// </summary>
    public class ParametrosSistemaModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets from email.
        /// </summary>
        /// <value>From email.</value>
        public string FromEmail { get; set; }

        /// <summary>
        /// Gets or sets the SMTP host.
        /// </summary>
        /// <value>The SMTP host.</value>
        public string SmtpHost { get; set; }

        /// <summary>
        /// Gets or sets the SMTP port.
        /// </summary>
        /// <value>The SMTP port.</value>
        public int SmtpPort { get; set; }

        /// <summary>
        /// Gets or sets the SMTP enable SSL.
        /// </summary>
        /// <value>The SMTP enable SSL.</value>
        public bool SmtpEnableSsl { get; set; }

        /// <summary>
        /// Gets or sets the SMTP username.
        /// </summary>
        /// <value>The SMTP username.</value>
        public string SmtpUsername { get; set; }

        /// <summary>
        /// Gets or sets the SMTP password.
        /// </summary>
        /// <value>The SMTP password.</value>
        public string SmtpPassword { get; set; }

        /// <summary>
        /// Gets or sets the texto bienvenida.
        /// </summary>
        /// <value>The texto bienvenida.</value>
        public string TextoBienvenida { get; set; }

        /// <summary>
        /// Gets or sets the formato fecha.
        /// </summary>
        /// <value>The formato fecha.</value>
        public string FormatoFecha { get; set; }

        /// <summary>
        /// Gets or sets the plantilla email password.
        /// </summary>
        /// <value>The plantilla email password.</value>
        public string PlantillaEmailPassword { get; set; }

        /// <summary>
        /// Gets or sets the upload directory.
        /// </summary>
        /// <value>The upload directory.</value>
        public string UploadDirectory { get; set; }

        /// <summary>
        /// Gets or sets the plantilla email confirmacion.
        /// </summary>
        /// <value>The plantilla email confirmacion.</value>
        public string PlantillaEmailConfirmacion { get; set; }
        public string PlantillaEmailConfirmacionPlaneacionPat { get; set; }
        public string PlantillaEmailConfirmacionSeguimiento1Pat { get; set; }
        public string PlantillaEmailConfirmacionSeguimiento2Pat { get; set; }

        /// <summary>
        /// Gets or sets the save message confirm popup.
        /// </summary>
        /// <value>The save message confirm popup.</value>
        public string SaveMessageConfirmPopup { get; set; }

        public string AsuntoEnvioR { get; set; }
        public string AsuntoEnvioPT { get; set; }
        public string AsuntoEnvioSeguimientoT1 { get; set; }
        public string AsuntoEnvioSeguimientoT2 { get; set; }


        public string AsuntoEnvioSP { get; set; }
        public string PlantillaEmailConfirmacionSeguimientoPlan { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Clase Ayuda.
    /// </summary>
    public class AyudaModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public string Id { get; set; }

        /// <summary>
        /// Gets or sets the titulo.
        /// </summary>
        /// <value>The titulo.</value>
        public string Titulo { get; set; }

        /// <summary>
        /// Gets or sets
        /// nombre del archivo que se quiere modificar.
        /// </summary>
        /// <value>The nombre.</value>
        public string nombre { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Clase Ayuda.
    /// </summary>
    public class ConfigurarDerechosModel
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the titulo.
        /// </summary>
        /// <value>The titulo.</value>
        public string Titulo { get; set; }

        /// <summary>
        /// Gets or sets
        /// nombre del archivo que se quiere modificar.
        /// </summary>
        /// <value>The nombre.</value>
        public string Nombre { get; set; }

        public string Tipo { get; set; }

        public string Papel { get; set; }

        public string NombreParametro { get; set; }

        public string ParametroValor { get; set; }

        public string Texto { get; set; }

        public bool   EsModificar { get; set; }

        public int    IdDerecho { get; set; }

        public string TextoExplicativoGOB { get; set; }

        public string TextoExplicativoALC { get; set; }

        public string DescripcionDetallada { get; set; }

        public string Descripcion { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class ConfigurarHomeModel.
    /// </summary>
    public class ConfigurarHomeModel
    {
        /// <summary>
        /// Gets or sets the list rs.
        /// </summary>
        /// <value>The list rs.</value>
        public IEnumerable<SocialNetwork> listRS { get; set; }

        /// <summary>
        /// Gets or sets the cantidad slides.
        /// </summary>
        /// <value>The cantidad slides.</value>
        public int cantidadSlides { get; set; }

        /// <summary>
        /// Gets or sets the list slider.
        /// </summary>
        /// <value>The list slider.</value>
        public IEnumerable<Slider> listSlider { get; set; }

        /// <summary>
        /// Gets or sets the text home.
        /// </summary>
        /// <value>The text home.</value>
        [AllowHtml]
        public string TextHome { get; set; }

        /// <summary>
        /// Gets or sets the list links.
        /// </summary>
        /// <value>The list links.</value>
        public IEnumerable<EnlacesGobierno> listLinks { get; set; }

        /// <summary>
        /// Gets or sets the cantidad enlaces.
        /// </summary>
        /// <value>The cantidad enlaces.</value>
        public int CantidadEnlaces { get; set; }

        /// <summary>
        /// Gets or sets the text footer.
        /// </summary>
        /// <value>The text footer.</value>
        [AllowHtml]
        public string TextFooter { get; set; }

        /// <summary>
        /// Gets or sets the image application.
        /// </summary>
        /// <value>The image application.</value>
        public string ImageApp { get; set; }
        /// <summary>
        /// Gets or sets the content of the image application.
        /// </summary>
        /// <value>The content of the image application.</value>
        public string ImageAppContent { get; set; }

        /// <summary>
        /// Gets or sets the image mint.
        /// </summary>
        /// <value>The image mint.</value>
        public string ImageMint { get; set; }
        /// <summary>
        /// Gets or sets the content of the image mint.
        /// </summary>
        /// <value>The content of the image mint.</value>
        public string ImageMintContent { get; set; }

        /// <summary>
        /// Gets or sets the image gob.
        /// </summary>
        /// <value>The image gob.</value>
        public string ImageGob { get; set; }
        /// <summary>
        /// Gets or sets the content of the image gob.
        /// </summary>
        /// <value>The content of the image gob.</value>
        public string ImageGobContent { get; set; }

        /// <summary>
        /// Gets or sets the image pais.
        /// </summary>
        /// <value>The image pais.</value>
        public string ImagePais { get; set; }
        /// <summary>
        /// Gets or sets the content of the image pais.
        /// </summary>
        /// <value>The content of the image pais.</value>
        public string ImagePaisContent { get; set; }

        /// <summary>
        /// Gets or sets the image vict.
        /// </summary>
        /// <value>The image vict.</value>
        public string ImageVict { get; set; }
        /// <summary>
        /// Gets or sets the content of the image vict.
        /// </summary>
        /// <value>The content of the image vict.</value>
        public string ImageVictContent { get; set; }
    }

    /// <summary>
    /// Class ConfigurarLoginModel.
    /// </summary>
    public class ConfigurarLoginModel
    {
        /// <summary>
        /// Gets or sets the list rs.
        /// </summary>
        /// <value>The list rs.</value>
        public IEnumerable<SocialNetwork> listRS { get; set; }

        /// <summary>
        /// Gets or sets the cantidad slides.
        /// </summary>
        /// <value>The cantidad slides.</value>
        public int cantidadSlides { get; set; }

        /// <summary>
        /// Gets or sets the list slider.
        /// </summary>
        /// <value>The list slider.</value>
        public IEnumerable<Slider> listSlider { get; set; }

        /// <summary>
        /// Gets or sets the text home.
        /// </summary>
        /// <value>The text home.</value>
        [AllowHtml]
        public string TextHome { get; set; }

        /// <summary>
        /// Gets or sets the list links.
        /// </summary>
        /// <value>The list links.</value>
        public IEnumerable<EnlacesGobierno> listLinks { get; set; }

        /// <summary>
        /// Gets or sets the cantidad enlaces.
        /// </summary>
        /// <value>The cantidad enlaces.</value>
        public int CantidadEnlaces { get; set; }

        /// <summary>
        /// Gets or sets the text footer.
        /// </summary>
        /// <value>The text footer.</value>
        [AllowHtml]
        public string TextFooter { get; set; }

        /// <summary>
        /// Gets or sets the image application.
        /// </summary>
        /// <value>The image application.</value>
        public string ImageApp { get; set; }
        /// <summary>
        /// Gets or sets the content of the image application.
        /// </summary>
        /// <value>The content of the image application.</value>
        public string ImageAppContent { get; set; }

        /// <summary>
        /// Gets or sets the image mint.
        /// </summary>
        /// <value>The image mint.</value>
        public string ImageMint { get; set; }
        /// <summary>
        /// Gets or sets the content of the image mint.
        /// </summary>
        /// <value>The content of the image mint.</value>
        public string ImageMintContent { get; set; }

        /// <summary>
        /// Gets or sets the image gob.
        /// </summary>
        /// <value>The image gob.</value>
        public string ImageGob { get; set; }
        /// <summary>
        /// Gets or sets the content of the image gob.
        /// </summary>
        /// <value>The content of the image gob.</value>
        public string ImageGobContent { get; set; }

        /// <summary>
        /// Gets or sets the image pais.
        /// </summary>
        /// <value>The image pais.</value>
        public string ImagePais { get; set; }
        /// <summary>
        /// Gets or sets the content of the image pais.
        /// </summary>
        /// <value>The content of the image pais.</value>
        public string ImagePaisContent { get; set; }

        /// <summary>
        /// Gets or sets the image vict.
        /// </summary>
        /// <value>The image vict.</value>
        public string ImageVict { get; set; }
        /// <summary>
        /// Gets or sets the content of the image vict.
        /// </summary>
        /// <value>The content of the image vict.</value>
        public string ImageVictContent { get; set; }
    }

    /// <summary>
    /// Class SocialNetwork.
    /// </summary>
    public class SocialNetwork
    {
        /// <summary>
        /// Gets or sets the nombre.
        /// </summary>
        /// <value>The nombre.</value>
        public string Nombre { get; set; }

        /// <summary>
        /// Gets or sets the URL.
        /// </summary>
        /// <value>The URL.</value>
        public string Url { get; set; }

        /// <summary>
        /// Gets or sets the imagen.
        /// </summary>
        /// <value>The imagen.</value>
        public string Imagen { get; set; }

        /// <summary>
        /// Gets or sets the content of the image.
        /// </summary>
        /// <value>The content of the image.</value>
        public string ImageContent { get; set; }

        /// <summary>
        /// Gets or sets the img identifier.
        /// </summary>
        /// <value>The img identifier.</value>
        public string imgID { get; set; }

        /// <summary>
        /// Gets or sets the content URL.
        /// </summary>
        /// <value>The content URL.</value>
        public string contentUrl { get; set; }

        /// <summary>
        /// Gets or sets the content group.
        /// </summary>
        /// <value>The content group.</value>
        public string contentGroup { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class EnlacesGobierno.
    /// </summary>
    public class EnlacesGobierno
    {
        /// <summary>
        /// Gets or sets the nombre.
        /// </summary>
        /// <value>The nombre.</value>
        public string Nombre { get; set; }

        /// <summary>
        /// Gets or sets the key nombre.
        /// </summary>
        /// <value>The key nombre.</value>
        public string KeyNombre { get; set; }

        /// <summary>
        /// Gets or sets the URL.
        /// </summary>
        /// <value>The URL.</value>
        public string Url { get; set; }

        /// <summary>
        /// Gets or sets the key URL.
        /// </summary>
        /// <value>The key URL.</value>
        public string KeyUrl { get; set; }

        /// <summary>
        /// Gets or sets the color.
        /// </summary>
        /// <value>The color.</value>
        public string Color { get; set; }

        /// <summary>
        /// Gets or sets the color of the key.
        /// </summary>
        /// <value>The color of the key.</value>
        public string KeyColor { get; set; }

        /// <summary>
        /// Gets or sets the identifier number.
        /// </summary>
        /// <value>The identifier number.</value>
        public int idNum { get; set; }
    }

    /// <summary>
    /// Class Slider.
    /// </summary>
    public class Slider
    {
        /// <summary>
        /// Gets or sets the content.
        /// </summary>
        /// <value>The content.</value>
        public string content { get; set; }

        /// <summary>
        /// Gets or sets the content of the key.
        /// </summary>
        /// <value>The content of the key.</value>
        public string keyContent { get; set; }

        /// <summary>
        /// Gets or sets the type.
        /// </summary>
        /// <value>The type.</value>
        public string type { get; set; }

        /// <summary>
        /// Gets or sets the type of the key.
        /// </summary>
        /// <value>The type of the key.</value>
        public string keyType { get; set; }

        /// <summary>
        /// Gets or sets the identifier number.
        /// </summary>
        /// <value>The identifier number.</value>
        public int idNum { get; set; }

        /// <summary>
        /// Gets or sets the CSS class.
        /// </summary>
        /// <value>The CSS class.</value>
        public string cssClass { get; set; }

        /// <summary>
        /// Gets or sets the content group.
        /// </summary>
        /// <value>The content group.</value>
        public string contentGroup { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }


    /// <summary>
    /// Class ConfigImagesModel.
    /// </summary>
    public class ConfigImagesModel
    {
        /// <summary>
        /// Gets or sets the key.
        /// </summary>
        /// <value>The key.</value>
        public string key { get; set; }
        /// <summary>
        /// Gets or sets the value.
        /// </summary>
        /// <value>The value.</value>
        public string value { get; set; }
        /// <summary>
        /// Gets or sets the group.
        /// </summary>
        /// <value>The group.</value>
        public string group { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class ConfigBodyFooterText.
    /// </summary>
    public class ConfigBodyFooterText
    {
        /// <summary>
        /// Gets or sets the key.
        /// </summary>
        /// <value>The key.</value>
        public string key { get; set; }
        /// <summary>
        /// Gets or sets the value.
        /// </summary>
        /// <value>The value.</value>
        public string value { get; set; }
        /// <summary>
        /// Gets or sets the group.
        /// </summary>
        /// <value>The group.</value>
        public string group { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class LinkGobierno.
    /// </summary>
    public class LinkGobierno
    {
        /// <summary>
        /// Gets or sets the key URL.
        /// </summary>
        /// <value>The key URL.</value>
        public string keyUrl { get; set; }
        /// <summary>
        /// Gets or sets the key nombre.
        /// </summary>
        /// <value>The key nombre.</value>
        public string keyNombre { get; set; }
        /// <summary>
        /// Gets or sets the color of the key.
        /// </summary>
        /// <value>The color of the key.</value>
        public string keyColor { get; set; }
        /// <summary>
        /// Gets or sets the identifier number.
        /// </summary>
        /// <value>The identifier number.</value>
        public string idNum { get; set; }
        /// <summary>
        /// Gets or sets the group.
        /// </summary>
        /// <value>The group.</value>
        public string group { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class BancoPreguntasModel.
    /// </summary>
    public class BancoPreguntasModel
    {
        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public int idPregunta { get; set; }
        /// <summary>
        /// Gets or sets the codigo pregunta.
        /// </summary>
        /// <value>The codigo pregunta.</value>
        public string codigoPregunta { get; set; }
        /// <summary>
        /// Gets or sets the nombre pregunta.
        /// </summary>
        /// <value>The nombre pregunta.</value>
        public string nombrePregunta { get; set; }
        /// <summary>
        /// Gets or sets the tipo pregunta.
        /// </summary>
        /// <value>The tipo pregunta.</value>
        public int tipoPregunta { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }


    /// <summary>
    /// Class DetalleClasificador.
    /// </summary>
    public class DetalleClasificador
    {
        /// <summary>
        /// Gets or sets the identifier clasificador.
        /// </summary>
        /// <value>The identifier clasificador.</value>
        public int idClasificador { get; set; }
        /// <summary>
        /// Gets or sets the identifier detalle.
        /// </summary>
        /// <value>The identifier detalle.</value>
        public int idDetalle { get; set; }
        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public int idPregunta { get; set; }
        /// <summary>
        /// Gets or sets the identifier detalle clasificador.
        /// </summary>
        /// <value>The identifier detalle clasificador.</value>
        public int idDetalleClasificador { get; set; }
        /// <summary>
        /// Gets or sets the nombre detalle.
        /// </summary>
        /// <value>The nombre detalle.</value>
        public string nombreDetalle { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class LogFiltroModels.
    /// </summary>
    public class LogFiltroModels
    {
        /// <summary>
        /// Gets or sets the identifier categoria.
        /// </summary>
        /// <value>The identifier categoria.</value>
        public int? CategoryId { get; set; }

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string UserName { get; set; }

        /// <summary>
        /// Gets or sets the fecha inicio.
        /// </summary>
        /// <value>The fecha inicio.</value>
        public DateTime FechaInicio { get; set; }

        /// <summary>
        /// Gets or sets the fecha fin.
        /// </summary>
        /// <value>The fecha fin.</value>
        public DateTime FechaFin { get; set; }
    }

    /// <summary>
    /// Class PlanMejoramientoModel.
    /// </summary>
    public class PlanMejoramientoModel
    {
        /// <summary>
        /// Gets or sets the identifier plan.
        /// </summary>
        /// <value>The identifier plan.</value>
        public int idPlan { get; set; }
        /// <summary>
        /// Gets or sets the nombre plan.
        /// </summary>
        /// <value>The nombre plan.</value>
        public string nombrePlan { get; set; }
        /// <summary>
        /// Gets or sets the fecha limite.
        /// </summary>
        /// <value>The fecha limite.</value>
        public DateTime fechaLimite { get; set; }
        /// <summary>
        /// Gets or sets the encuestas asociadas.
        /// </summary>
        /// <value>The encuestas asociadas.</value>
        ///public IEnumerable<PlanMejoramientoEncuestaModel> encuestasAsociadas { get; set; }
        ///
        public int idEncuesta { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class PlanMejoramientoEncuestaModel.
    /// </summary>
    public class PlanMejoramientoEncuestaModel
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }
    }

    /// <summary>
    /// Class SeccionPlanMejoramientoModel.
    /// </summary>
    public class SeccionPlanMejoramientoModel
    {
        /// <summary>
        /// Gets or sets the identifier seccion.
        /// </summary>
        /// <value>The identifier seccion.</value>
        public int idSeccion { get; set; }
        /// <summary>
        /// Gets or sets the identifier plan.
        /// </summary>
        /// <value>The identifier plan.</value>
        public int idPlan { get; set; }
        /// <summary>
        /// Gets or sets the objetivo general.
        /// </summary>
        /// <value>The objetivo general.</value>
        public string objetivoGeneral { get; set; }
        /// <summary>
        /// Gets or sets the titulo.
        /// </summary>
        /// <value>The titulo.</value>
        public string titulo { get; set; }
        /// <summary>
        /// Gets or sets the ayuda.
        /// </summary>
        /// <value>The ayuda.</value>
        public string ayuda { get; set; }
        /// <summary>
        /// Gets or sets the identifier seccion padre.
        /// </summary>
        /// <value>The identifier seccion padre.</value>
        public int idSeccionPadre { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    public class ObjetivoGeneralPlanMejoramientoModel
    {
        /// <summary>
        /// Gets or sets the identifier seccion.
        /// </summary>
        /// <value>The identifier seccion.</value>
        public int idSeccion { get; set; }

        /// <summary>
        /// Gets or sets the identifier objetivo general.
        /// </summary>
        /// <value>The identifier objetivo general.</value>
        public int idObjetivoGeneral { get; set; }

        /// <summary>
        /// Gets or sets the objetivo general.
        /// </summary>
        /// <value>The objetivo general.</value>
        public string objetivoGeneral { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class TipoRecurso.
    /// </summary>
    public class TipoRecurso
    {
        /// <summary>
        /// Gets or sets the identifier tipo.
        /// </summary>
        /// <value>The identifier tipo.</value>
        public int idTipo { get; set; }
        /// <summary>
        /// Gets or sets the nombre tipo.
        /// </summary>
        /// <value>The nombre tipo.</value>
        public string nombreTipo { get; set; }
        /// <summary>
        /// Gets or sets the clase.
        /// </summary>
        /// <value>The clase.</value>
        public string clase { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class OpcionesPreguntaRecomendacionPlan.
    /// </summary>
    public class OpcionesPreguntaRecomendacionPlan
    {
        /// <summary>
        /// Gets or sets the valor.
        /// </summary>
        /// <value>The valor.</value>
        public string Valor { get; set; }
        /// <summary>
        /// Gets or sets the texto.
        /// </summary>
        /// <value>The texto.</value>
        public string Texto { get; set; }
    }

    /// <summary>
    /// Class RecomendacionesPlan.
    /// </summary>
    public class RecomendacionesPlan
    {
        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="RecomendacionesPlan" /> is aplica.
        /// </summary>
        /// <value><c>true</c> if aplica; otherwise, <c>false</c>.</value>
        public bool aplica { get; set; }
        /// <summary>
        /// Gets or sets the opcion.
        /// </summary>
        /// <value>The opcion.</value>
        public string opcion { get; set; }
        /// <summary>
        /// Gets or sets the texto.
        /// </summary>
        /// <value>The texto.</value>
        public string texto { get; set; }
        /// <summary>
        /// Gets or sets the calificacion.
        /// </summary>
        /// <value>The calificacion.</value>
        public int? calificacion { get; set; }
        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public int idPregunta { get; set; }
    }

    /// <summary>
    /// Class TareasPlan.
    /// </summary>
    public class TareasPlan
    {
        public bool aplica { get; set; }
        /// <summary>
        /// Gets or sets the opcion.
        /// </summary>
        /// <value>The opcion.</value>
        public string opcion { get; set; }
        /// <summary>
        /// Gets or sets the tarea.
        /// </summary>
        /// <value>The tarea.</value>
        public List<string> tareas { get; set; }
        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public int idPregunta { get; set; }
    }

    /// <summary>
    /// Class ObjetivoEspecificoPlan.
    /// </summary>
    public class ObjetivoEspecificoPlan
    {
        /// <summary>
        /// Gets or sets the objetivo especifico.
        /// </summary>
        /// <value>The objetivo especifico.</value>
        public string objetivoEspecifico { get; set; }
        /// <summary>
        /// Gets or sets the porc objetivo.
        /// </summary>
        /// <value>The porc objetivo.</value>
        public int porcObjetivo { get; set; }
        /// <summary>
        /// Gets or sets the identifier seccion.
        /// </summary>
        /// <value>The identifier seccion.</value>
        public int idSeccion { get; set; }
        /// <summary>
        /// Gets or sets the recomendaciones.
        /// </summary>
        /// <value>The recomendaciones.</value>
        public IEnumerable<RecomendacionesPlan> recomendaciones { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class EstrategiaPlan.
    /// </summary>
    public class EstrategiaPlan
    {
        /// <summary>
        /// Gets or sets the estrategia.
        /// </summary>
        /// <value>The estrategia.</value>
        public string estrategia { get; set; }
        /// <summary>
        /// Gets or sets the identifier seccion.
        /// </summary>
        /// <value>The identifier seccion.</value>
        public int idObjetivoGeneral { get; set; }
        /// <summary>
        /// Gets or sets the recomendaciones.
        /// </summary>
        /// <value>The recomendaciones.</value>
        public IEnumerable<TareasPlan> tareas { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class ActivacionPlan.
    /// </summary>
    public class ActivacionPlan
    {
        /// <summary>
        /// Gets or sets the identifier plan.
        /// </summary>
        /// <value>The identifier plan.</value>
        public int idPlan { get; set; }
        /// <summary>
        /// Gets or sets the fecha ini.
        /// </summary>
        /// <value>The fecha ini.</value>
        public DateTime fechaIni { get; set; }
        /// <summary>
        /// Gets or sets the fecha fin.
        /// </summary>
        /// <value>The fecha fin.</value>
        public DateTime fechaFin { get; set; }
        /// <summary>
        /// Gets or sets a value indicating whether [muestra porc].
        /// </summary>
        /// <value><c>true</c> if [muestra porc]; otherwise, <c>false</c>.</value>
        public bool muestraPorc { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class RecomendacionPlanModel.
    /// </summary>
    public class RecomendacionPlanModel
    {
        /// <summary>
        /// Gets or sets the identifier objetivo especifico.
        /// </summary>
        /// <value>The identifier objetivo especifico.</value>
        public int IdObjetivoEspecifico { get; set; }

        /// <summary>
        /// Gets or sets the identifier recomendacion.
        /// </summary>
        /// <value>The identifier recomendacion.</value>
        public int IdRecomendacion { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class RecomendacionPlanModel.
    /// </summary>
    public class TareasPlanModel
    {
        /// <summary>
        /// Gets or sets the identifier objetivo especifico.
        /// </summary>
        /// <value>The identifier objetivo especifico.</value>
        public int IdEstrategia { get; set; }

        /// <summary>
        /// Gets or sets the identifier recomendacion.
        /// </summary>
        /// <value>The identifier recomendacion.</value>
        public int IdTarea { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }


    public class RecursosDiligenciamientoPlan
    {
        public string Clase { get; set; }
        public int IdTipoRecurso { get; set; }
        public bool Seleccionado { get; set; }
        public string ValorRecurso { get; set; }
    }

    public class RecomendacionesDiligenciamientoPlan
    {
        public string Accion { get; set; }
        public DateTime AccionFecha { get; set; }
        public string AccionResponsable { get; set; }
        public int IdAutoEv { get; set; }
        public int IdAvance { get; set; }
        public int IdRecomendacion { get; set; }
        public IEnumerable<RecursosDiligenciamientoPlan> recursos { get; set; }
    }
    public class SeccionesDiligenciamientoPlan
    {
        public int IdSeccionPlanMejoramiento { get; set; }
        public int IdUsuario { get; set; }
        public int IdPlan { get; set; }
        public IEnumerable<RecomendacionesDiligenciamientoPlan> recomendaciones { get; set; }
    }
    public class PlanMejoramientoDiligenciamiento
    {
        public int IdPlan { get; set; }
        public int IdUsuario { get; set; }
        public string userName { get; set; }
        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    public class PlanMejoramientoSeguimiento
    {
        public int IdPlan { get; set; }
        public int IdSeguimiento { get; set; }
        public int IdUsuario { get; set; }
        public string Username { get; set; }
        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    public class PlanMejoramientoDiligenciamientoFile
    {
        public int IdPlan { get; set; }
        public int IdUsuario { get; set; }
        public string userName { get; set; }
        public bool deleteFile { get; set; }
    }

    public class PlanMejoramientoSeguimientoFile
    {
        public int IdSeguimiento { get; set; }
        public int IdUsuario { get; set; }
        public string userName { get; set; }
        public bool deleteFile { get; set; }
    }

    public class PlanMejoramientoV3Diligenciamiento
    {
        public int IdUsuario { get; set; }
        public int IdPlan { get; set; }
        public IEnumerable<PlanMejoramientoTareasDiligenciamiento> tareas { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    public class PlanMejoramientoV3Seguimiento
    {
        public int IdUsuario { get; set; }
        public string Username { get; set; }
        public int IdPlan { get; set; }
        public int IdSeguimiento { get; set; }
        public IEnumerable<PlanMejoramientoTareasSeguimiento> tareas { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    public class PlanMejoramientoTareasDiligenciamiento
    {
        public int IdTarea { get; set; }
        public string Responsable { get; set; }
        public DateTime FechaInicioEjecucion { get; set; }
        public DateTime FechaFinEjecucion { get; set; }
        public int IdAutoevaluacion { get; set; }
    }

    public class PlanMejoramientoTareasSeguimiento
    {
        public int IdTarea { get; set; }
        public int IdTareaPlan { get; set; }
        public int IdSeguimientoAccion { get; set; }
        public int IdEstadoAccion { get; set; }
        public int IdAutoevaluacion { get; set; }
        public int IdPlanSeguimiento { get; set; }
        public int IdUsuario { get; set; }
        public string Username { get; set; }
        public string DescripcionEstado { get; set; }
    }

    public class GestionBancoPreguntasModel
    {
        public int? idTipoPregunta { get; set; }
        public string codigoPregunta { get; set; }
        public bool isExportable { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }


    #region Seguimiento planes de mejoramiento
    /// <summary>
    /// Class PlanMejoramientoSeguimientoModel.
    /// </summary>
    public class PlanMejoramientoSeguimientoModel
    {
        /// <summary>
        /// Gets or sets the identifier sguimiento.
        /// </summary>
        /// <value>The identifier sguimiento.</value>
        public int idSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the identifier plan.
        /// </summary>
        /// <value>The identifier plan.</value>
        public int idPlan { get; set; }

        /// <summary>
        /// Gets or sets the identifier encuesta.
        /// </summary>
        /// <value>The identifier encuesta.</value>
        public int idEncuesta { get; set; }
        /// <summary>
        /// Gets or sets the numero seguimiento.
        /// </summary>
        /// <value>The numero seguimiento.</value>
        public int numeroSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the mensaje seguimiento.
        /// </summary>
        /// <value>The mensaje seguimiento.</value>
        public string mensajeSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the fecha inicio.
        /// </summary>
        /// <value>The fecha inicio.</value>
        public DateTime fechaInicio { get; set; }
        /// <summary>
        /// Gets or sets the fecha fin.
        /// </summary>
        /// <value>The fecha fin.</value>
        public DateTime fechaFin { get; set; }
        
        public bool activo { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class EstadosAccionesPlanModel.
    /// </summary>
    public class EstadosAccionesPlanModel
    {
        public int idEstadoAccion { get; set; }
        public string estadoAccion { get; set; }
        public bool activo { get; set; }

        #region datos de auditoria

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    #endregion

}