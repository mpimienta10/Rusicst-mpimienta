// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Aplicacion
// Author           : Equipo de desarrollo OIM
// Created          : 03-18-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 04-29-2017
// ***********************************************************************
// <copyright file="Utilitarios.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Mininterior.RusicstMVC.Aplicacion namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Aplicacion
{
    using System.Web;

    /// <summary>
    /// Clase Utilitarios.
    /// </summary>
    public class UtilGeneral
    {
        /// <summary>
        /// The ur l_ pag e_ confirmacion
        /// </summary>
        public const string URL_PAGE_CONFIRMACION = "Home/ConfirmarSolicitud";

        /// <summary>
        /// The ur l_ pag e_ login
        /// </summary>
        public const string URL_PAGE_LOGIN = "Home/Login";

        /// <summary>
        /// The ur l_ pag e_ establece r_ contrasena
        /// </summary>
        public const string URL_PAGE_ESTABLECER_CONTRASENA = "Home/EstablecerContrasena";

        /// <summary>
        /// Url de verificación
        /// </summary>
        /// <value>The URL verificacion.</value>
        public static string UrlLogin
        {
            get
            {
                return URL_PAGE_LOGIN.ToLower();
            }
        }

        /// <summary>
        /// Url de verificación
        /// </summary>
        /// <value>The URL verificacion.</value>
        public static string UrlVerificacion
        {
            get
            {
                return URL_PAGE_CONFIRMACION.ToLower() + "?Id=";
            }
        }

        /// <summary>
        /// URL para establecer contraseña.
        /// </summary>
        /// <value>URL establecer contraseña.</value>
        public static string UrlEstablecerContrasena
        {
            get
            {
                return URL_PAGE_ESTABLECER_CONTRASENA.ToLower() + "?Id=";
            }
        }

        /// <summary>
        /// Url Actual
        /// </summary>
        /// <value>Url del sitio</value>
        public static string Url
        {
            get
            {
                return HttpContext.Current.Request.Url.Scheme + System.Uri.SchemeDelimiter + HttpContext.Current.Request.Url.Host;
            }
        }

        /// <summary>
        /// Gets the schema URL.
        /// </summary>
        /// <value>The schema URL.</value>
        public static string SchemaUrl
        {
            get
            {
                return HttpContext.Current.Request.Url.Scheme + System.Uri.SchemeDelimiter;
            }
        }
    }
}
