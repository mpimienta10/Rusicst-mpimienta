// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Aplicacion
// Author           : Equipo de desarrollo OIM
// Created          : 09-16-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-31-2017
// ***********************************************************************
// <copyright file="UtilAuditoria.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Seguridad namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Aplicacion.Seguridad
{
    using System;
    using System.Collections;
    using System.Collections.Specialized;
    using System.Reflection;
    using System.Text;
    using System.Web;
    using System.Web.Configuration;

    /// <summary>
    /// Class UtilAuditoria.
    /// </summary>
    public class UtilAuditoria
    {
        /// <summary>
        /// Applications the name of the domain.
        /// </summary>
        /// <returns>System.String.</returns>
        public static string AppDomainName()
        {
            return AppDomain.CurrentDomain.FriendlyName;
        }

        /// <summary>
        /// Processes the identifier.
        /// </summary>
        /// <returns>System.Int32.</returns>
        public static int ProcessID()
        {
            return System.Diagnostics.Process.GetCurrentProcess().Id;
        }

        /// <summary>
        /// Processes the name.
        /// </summary>
        /// <returns>System.String.</returns>
        public static string ProcessName()
        {

            return System.Diagnostics.Process.GetCurrentProcess().ProcessName;
        }

        /// <summary>
        /// Browsers this instance.
        /// </summary>
        /// <returns>System.String.</returns>
        public static string Browser()
        {
            var userAgent = HttpContext.Current.Request.UserAgent;
            var userBrowser = new HttpBrowserCapabilities { Capabilities = new Hashtable { { string.Empty, userAgent } } };
            var factory = new BrowserCapabilitiesFactory();
            factory.ConfigureBrowserCapabilities(new NameValueCollection(), userBrowser);

            //Set User browser Properties
            return userBrowser.Browser + " Versión: " + userBrowser.Version;
        }

        /// <summary>
        /// Names the machine.
        /// </summary>
        /// <returns>System.String.</returns>
        public static string NameMachine()
        {
            return null == HttpContext.Current.Request.UrlReferrer.Host ? string.Empty : HttpContext.Current.Request.UrlReferrer.Host;
        }

        /// <summary>
        /// Threads the name.
        /// </summary>
        /// <returns>System.String.</returns>
        public static string ThreadName()
        {
            return System.Threading.Thread.CurrentThread.Name;
        }

        /// <summary>
        /// Threads the identifier.
        /// </summary>
        /// <returns>System.Int32.</returns>
        public static int ThreadId()
        {
            return System.Threading.Thread.CurrentThread.ManagedThreadId;
        }

        /// <summary>
        /// Addresses the ip.
        /// </summary>
        /// <returns>System.String.</returns>
        public static string AddressIP()
        {
            string direccionIP = string.Empty;

            if (System.Web.HttpContext.Current != null)
            {
                string cadenaDireccionesIPs = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

                if (!string.IsNullOrEmpty(cadenaDireccionesIPs))
                {
                    direccionIP = "IP del usuario : " + cadenaDireccionesIPs.Split(',')[0];
                }

                direccionIP = string.IsNullOrEmpty(direccionIP) ? System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"] : direccionIP + " - " + System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            }

            return direccionIP;
        }

        /// <summary>
        /// Messages this instance.
        /// </summary>
        /// <returns>System.String.</returns>
        public static string Message()
        {
            string parametros = string.Empty;

            NameValueCollection query = HttpContext.Current.Request.QueryString;

            StringBuilder result = new StringBuilder();

            result.Append(string.Format("{0}|", HttpContext.Current.Request.Url.AbsoluteUri));
            result.Append(string.Format("{0}|", HttpContext.Current.Request.Browser.Browser));
            result.Append(string.Format("{0}|", HttpContext.Current.Request.Browser.Version));
            result.Append(string.Format("{0}|", HttpContext.Current.Request.UserHostAddress));

            foreach (string item in query.Keys)
            {
                result.AppendLine(string.Format("{0}-{1}", item, query[item].ToString()));
            }

            return result.ToString();
        }

        /// <summary>
        /// Loads the message.
        /// </summary>
        /// <param name="categoria">The categoria.</param>
        /// <param name="userName">Name of the user.</param>
        /// <param name="datosEntidad">The datos entidad.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <returns>System.String.</returns>
        public static string LoadMessage(Category categoria, string userName, string datosEntidad, string userNameAddIdent, string detalleMensaje = "")
        {
            StringBuilder sb = new StringBuilder();

            sb.AppendLine("Proceso auditado : " + categoria.ToString());
            sb.AppendLine("Reporte generado el : " + DateTime.Now.ToString());
            sb.AppendLine("Usuario que realiza : " + userName);

            if (categoria == Category.AdquirirIdentidad)
            {
                sb.AppendLine("Usuario adquirido : " + userNameAddIdent);
            }

            sb.AppendLine("IP que ejecuta el proceso : " + AddressIP());
            sb.AppendLine();

            if (categoria != Category.InicioSesion && categoria != Category.AdquirirIdentidad)
            {
                sb.AppendLine("Datos de la entidad auditada : ");
                sb.AppendLine();
            }
            if (categoria == Category.IngresoPrecargueRespuestasEncuestas)
            {                
                sb.AppendLine(detalleMensaje);
                sb.AppendLine();
            }
            if (categoria == Category.BorroPrecargueRespuestasEncuestas)
            {
                sb.AppendLine("Al realizar el precargue de respuestas de encuestas se borro la información de la siguientes encuesta ");
                sb.AppendLine();
            }
            sb.AppendLine(datosEntidad);

            return sb.ToString();
        }

        /// <summary>
        /// Loads the message exception.
        /// </summary>
        /// <param name="excepcion">The excepcion.</param>
        /// <returns>System.String.</returns>
        public static string LoadMessageException(string userNameAddIdent, string excepcion)
        {
            StringBuilder sb = new StringBuilder();

            sb.AppendLine("Proceso auditado : Excepciones");
            sb.AppendLine("Reporte generado el : " + DateTime.Now.ToString());

            if (!string.IsNullOrEmpty(userNameAddIdent))
                sb.AppendLine("Usuario que adquirio Identidad : " + userNameAddIdent);

            sb.AppendLine("IP que ejecuta el proceso : " + AddressIP());
            sb.AppendLine();
            sb.AppendLine();

            sb.AppendLine(excepcion);

            return sb.ToString();
        }

        /// <summary>
        /// Retorna los valores de las propiedades de una  entidad
        /// </summary>
        /// <typeparam name="T">Tipo entidad generica</typeparam>
        /// <param name="clase">Entidad o clase</param>
        /// <param name="excepcion">if set to <c>true</c> [excepcion].</param>
        /// <returns>Una cadena con los valores del objeto</returns>
        public static string RetornarPropiedades<T>(T clase, bool excepcion = false)
        {
            string Cadena = string.Empty;
            string Propiedad = string.Empty;
            bool adquirioIdentidad = false;

            foreach (PropertyInfo propertyInfo in clase.GetType().GetProperties())
            {
                if (propertyInfo.Name.ToLower() != ("Password").ToLower())
                {
                    if (propertyInfo.Name.ToLower() == ("AddIdent").ToLower())
                    {
                        adquirioIdentidad = Convert.ToBoolean(propertyInfo.GetValue(clase, null).ToString());

                        if (adquirioIdentidad)
                            Cadena = Cadena + "Adquirió identidad : " + propertyInfo.GetValue(clase, null).ToString() + Environment.NewLine;
                    }

                    else if (propertyInfo.Name.ToLower() == ("Excepcion").ToLower())
                    {
                        if (excepcion)
                            Cadena = Cadena + propertyInfo.Name + " : " + propertyInfo.GetValue(clase, null).ToString() + Environment.NewLine;
                    }

                    else if (propertyInfo.Name.ToLower() == ("ExcepcionMensaje").ToLower())
                    {
                        if (excepcion)
                            Cadena = Cadena + propertyInfo.Name + " : " + propertyInfo.GetValue(clase, null).ToString() + Environment.NewLine;
                    }

                    else
                    {
                        if (propertyInfo.Name.ToLower() == ("UserNameAddIdent").ToLower())
                        {
                            if (adquirioIdentidad)
                                Cadena = Cadena + "Usuario que Adquirió identidad : " + propertyInfo.GetValue(clase, null).ToString() + Environment.NewLine;
                        }
                        else
                        {
                            //// Retira de la auditoría los datos que vienen en NULL ó que vienen en cero ó las fechas que vienen con la fecha mínima
                            if (null != propertyInfo.GetValue(clase, null) && propertyInfo.GetValue(clase, null).ToString().Trim() != "0" && propertyInfo.GetValue(clase, null).ToString().Trim() != "1/1/0001 12:00:00 AM")
                            {
                                Propiedad = (propertyInfo.Name == "AudUserName" ? "Usuario que realiza" : propertyInfo.Name) + " : " + propertyInfo.GetValue(clase, null).ToString();
                                Cadena = Cadena + Propiedad + Environment.NewLine;
                            }
                        }
                    }
                }
            }

            return Cadena;
        }

        /// <summary>
        /// Retornars the username.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="clase">The clase.</param>
        /// <param name="parametro">The parametro.</param>
        /// <returns>System.String.</returns>
        public static string RetornarParametro<T>(T clase, string parametro)
        {
            string cadena = string.Empty;

            foreach (PropertyInfo propertyInfo in clase.GetType().GetProperties())
            {
                if (propertyInfo.Name.ToLower() == parametro.ToLower())
                    cadena = propertyInfo.GetValue(clase, null).ToString();
            }

            return cadena;
        }
    }
}
