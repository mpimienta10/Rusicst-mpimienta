// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 04-27-2017
// ***********************************************************************
// <copyright file="Utilitarios.cs" company="Ministerio del Interior">
//     Copyright ©  Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Helpers namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Helpers
{
    using Mininterior.RusicstMVC.Aplicacion;
    using Mininterior.RusicstMVC.Aplicacion.Adjuntos;
    using Mininterior.RusicstMVC.Aplicacion.Mensajeria;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Newtonsoft.Json;
    using System;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Net.Http;
    using System.Web;
    using System.Web.Hosting;

    public static class Utilitarios
    {
        /// <summary>
        /// Obtiene la plantilla HTML, inserta el mensaje y envía el correo tramitando la solicitud.
        /// </summary>
        /// <param name="resultado">Esado y respuesta de la transacción.</param>
        /// <param name="para">Cuentas de correo de salida</param>
        /// <param name="datosSistema">datos del sistema.</param>
        /// <param name="Token">Identificador tipo Guid identificador de la solicitud.</param>
        /// <param name="estado">estado de la solicitud.</param>
        public static void EnviarCorreoSolicitud(ref C_AccionesResultado resultado, string[] para, C_DatosSistema_Result datosSistema, UsuariosModels model, EstadoSolicitud estado, string url)
        {
            //// Completa la url
            string UrlModificada = null != url ? (url.Contains("http") ? url : UtilGeneral.SchemaUrl + url) : UtilGeneral.SchemaUrl + url;

            //// Obtiene la plantilla para el correo
            string Plantilla = Helpers.Utilitarios.ObtenerPlantillaGeneral();

            //// Coloca el título que va en el cuerpo del correo
            Plantilla = Plantilla.Replace("{TITULO}", estado == EstadoSolicitud.Solicitada ? Mensajes.SolicitudUsuario : estado == EstadoSolicitud.Aprobada ? Mensajes.SolicitudAprobacion : estado == EstadoSolicitud.RecuperarContraseña ? Mensajes.RecuperarClave : Mensajes.SolicitudConfirmacion);

            //// Coloca el asunto del correo
            string Asunto = Correo.ObtenerAsunto(estado);

            //// Coloca el contenido en el cuerpo del correo
            string Contenido = ObtenerPlantilla(estado, model, UrlModificada);

            //// Integra el contenido
            string Mensaje = Plantilla.Replace("{CONTENIDO}", Contenido);

            //// Envía el correo
            string retorno = Correo.EnviarXSmtp(para, null, null, null, Asunto, Mensaje, datosSistema.SmtpUsername, datosSistema.SmtpPassword, datosSistema.SmtpHost, datosSistema.SmtpPort.Value);

            //// Obtiene la respuesta final de la transacción
            resultado.respuesta = string.IsNullOrEmpty(retorno) ? resultado.respuesta : retorno;
        }

        /// <summary>
        /// Obtiene la plantilla para enviar el correo.
        /// </summary>
        /// <param name="estado">The estado.</param>
        /// <param name="Token">The token.</param>
        /// <returns>System.String.</returns>
        private static string ObtenerPlantilla(EstadoSolicitud estado, UsuariosModels model, string url)
        {
            string Plantilla = string.Empty;
            string Retorno = string.Empty;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                switch (estado)
                {
                    case EstadoSolicitud.Solicitada:
                        Plantilla = BD.C_ParametrosSistema(SistemaGrupo.PlantillasCorreo, UtilMensajeria.PlantillaSolicitudUsuario).FirstOrDefault().ParametroValor;
                        Retorno = string.Format(Plantilla, url + UtilGeneral.UrlVerificacion + model.Token);
                        break;
                    case EstadoSolicitud.MinConfirmada:
                        Plantilla = BD.C_ParametrosSistema(SistemaGrupo.PlantillasCorreo, UtilMensajeria.PlantillaConfirmacionSolicitud).FirstOrDefault().ParametroValor;
                        Retorno = string.Format(Plantilla, url + UtilGeneral.UrlVerificacion + model.Token);
                        break;
                    case EstadoSolicitud.Rechazada:
                        Retorno = BD.C_ParametrosSistema(SistemaGrupo.PlantillasCorreo, UtilMensajeria.PlantillaRechazoSolicitud).FirstOrDefault().ParametroValor;
                        break;
                    case EstadoSolicitud.Aprobada:
                        Plantilla = BD.C_ParametrosSistema(SistemaGrupo.PlantillasCorreo, UtilMensajeria.PlantillaBienvenida).FirstOrDefault().ParametroValor;
                        Retorno = string.Format(Plantilla, url + UtilGeneral.URL_PAGE_LOGIN, model.UserName, model.Password);
                        break;
                    case EstadoSolicitud.RecuperarContraseña:
                        Plantilla = BD.C_ParametrosSistema(SistemaGrupo.PlantillasCorreo, UtilMensajeria.PlantillaRecuperarClave).FirstOrDefault().ParametroValor;
                        Retorno = string.Format(Plantilla, model.Password, url + UtilGeneral.URL_PAGE_LOGIN);
                        break;
                }
            }

            return Retorno;
        }

        /// <summary>
        /// Obtiene la plantilla general con logos para los correos.
        /// </summary>
        /// <returns>System.String.</returns>
        public static string ObtenerPlantillaGeneral()
        {
            string Retorno = string.Empty;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                Retorno = BD.C_ParametrosSistema(SistemaGrupo.PlantillasCorreo, UtilMensajeria.PlantillaGeneral).FirstOrDefault().ParametroValor;
            }

            return Retorno;
        }

        /// <summary>
        /// Obtiene el proveedor.
        /// </summary>
        /// <returns>MultipartFormDataStreamProvider.</returns>
        public static MultipartFormDataStreamProvider GetMultipartProvider()
        {
            var root = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings.Get("FilesTemp"));
            Directory.CreateDirectory(root);
            return new MultipartFormDataStreamProvider(root);
        }

        /// <summary>
        /// Extrae los datos
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="result">The result.</param>
        /// <returns>System.Object.</returns>
        public static object GetFormData<T>(MultipartFormDataStreamProvider result)
        {
            try
            {
                if (result.FormData.HasKeys())
                {
                    var keys = result.FormData.Keys;

                    string datos = "{";

                    foreach (string property in keys)
                    {
                        datos += '"' + property + '"' + ':';

                        string value = result.FormData.GetValues(property).FirstOrDefault();
                        datos += '"' + value + '"' + ',';
                    }

                    datos += '}';

                    if (!String.IsNullOrEmpty(datos))
                    {
                        return JsonConvert.DeserializeObject<T>(datos);
                    }
                }

                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Gets the name of the deserialized file.
        /// </summary>
        /// <param name="fileData">The file data.</param>
        /// <returns>System.String.</returns>
        public static string GetDeserializedFileName(MultipartFileData fileData)
        {
            var fileName = GetFileName(fileData);
            return JsonConvert.DeserializeObject(fileName).ToString();
        }

        /// <summary>
        /// Obtiene el nombre del archivo original.
        /// </summary>
        /// <param name="fileData">The file data.</param>
        /// <returns>System.String.</returns>
        public static string GetFileName(MultipartFileData fileData)
        {
            return fileData.Headers.ContentDisposition.FileName;
        }
    }
}