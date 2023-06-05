// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 12-12-2017
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
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Net.Http;
    using System.Web;

    /// <summary>
    /// Class Utilitarios.
    /// </summary>
    public static class Utilitarios
    {
        /// <summary>
        /// Obtiene la plantilla HTML, inserta el mensaje y envía el correo tramitando la solicitud.
        /// </summary>
        /// <param name="resultado">Esado y respuesta de la transacción.</param>
        /// <param name="para">Cuentas de correo de salida</param>
        /// <param name="datosSistema">datos del sistema.</param>
        /// <param name="model">The model.</param>
        /// <param name="estado">estado de la solicitud.</param>
        /// <param name="url">The URL.</param>
        public static void EnviarCorreoSolicitud(ref C_AccionesResultado resultado, string[] para, C_DatosSistema_Result datosSistema, UsuariosModels model, EstadoSolicitud estado, string url, string motivoRechazo, FileInfo adjunto, string fileName)
        {
            //// Completa la url
            string UrlModificada = null != url ? (url.Contains("http") ? url : UtilGeneral.SchemaUrl + url) : UtilGeneral.SchemaUrl + url;

            //// Obtiene la plantilla para el correo
            string Plantilla = Helpers.Utilitarios.ObtenerPlantillaGeneral();

            //// Coloca el título que va en el cuerpo del correo
            Plantilla = Plantilla.Replace("{TITULO}", estado == EstadoSolicitud.Solicitada ? Mensajes.SolicitudUsuario : estado == EstadoSolicitud.Aprobada ? Mensajes.SolicitudAprobacion : estado == EstadoSolicitud.RecuperarContraseña ? Mensajes.RecuperarClave : estado == EstadoSolicitud.Rechazada ? Mensajes.RechazoSolicitud : Mensajes.SolicitudConfirmacion);

            //// Coloca el asunto del correo
            string Asunto = Correo.ObtenerAsunto(estado);

            //// Coloca el contenido en el cuerpo del correo
            List<AdjuntoCorreo> Adjuntos = null;
            string Contenido;
            if (estado != EstadoSolicitud.Rechazada)
                Contenido = ObtenerPlantilla(estado, model, UrlModificada);
            else
                Contenido = string.Format("<p><br><br>Reciba un cordial saludo por parte del <b>Ministerio del Interior y la Unidad para las Víctimas</b>.<br><br>La solicitud de Usuario para el Reporte RUSICST <b>ha sido rechazada</b>. A continuación le explicamos el motivo de tal decisión: <br><br> <b> {0} </b> <br><br>Si tiene alguna inquietud adicional frente a esta decisión, por favor responda directamente a este correo.<br><br>No olvide que estamos atentos a resolver cualquier inquietud o a prestar el respectivo soporte que se  requiera. Para un mejor rendimiento sugerimos utilizar el explorador Google Chrome.<br><br><br>Agradecemos su atención.<br><br>Cordialmente,<br><br><b>Ministerio del Interior</b><br><b>Grupo de Articulación Interna para la Política de Víctimas del Conflicto Armado</b></p>", motivoRechazo);

            //// Integra el contenido
            string Mensaje = Plantilla.Replace("{CONTENIDO}", Contenido);

            string retorno;
            //// Envía el correo
            if (null != adjunto)
            {
                Adjuntos = new List<AdjuntoCorreo>();
                Adjuntos.Add(new AdjuntoCorreo() { Nombre = fileName, Contenido = File.ReadAllBytes(adjunto.FullName) });
                retorno = Correo.EnviarXSmtp(para, null, null, Adjuntos.ToArray(), Asunto, Mensaje, datosSistema.SmtpUsername, datosSistema.SmtpPassword, datosSistema.SmtpHost, datosSistema.SmtpPort.Value);
            }
            else
                retorno = Correo.EnviarXSmtp(para, null, null, null, Asunto, Mensaje, datosSistema.SmtpUsername, datosSistema.SmtpPassword, datosSistema.SmtpHost, datosSistema.SmtpPort.Value);

            //// Obtiene la respuesta final de la transacción
            resultado.respuesta = string.IsNullOrEmpty(retorno) ? resultado.respuesta : retorno;
            resultado.estado = string.IsNullOrEmpty(retorno) ? resultado.estado : (int)EstadoRespuesta.Excepcion;
        }

        /// <summary>
        /// Obtiene la plantilla HTML, inserta el mensaje y envía el correo tramitando la solicitud.
        /// </summary>
        /// <param name="resultado">Esado y respuesta de la transacción.</param>
        /// <param name="para">Cuentas de correo de salida</param>
        /// <param name="datosPlan">The datos plan.</param>
        /// <param name="usuario">The usuario.</param>
        /// <param name="datosSistema">datos del sistema.</param>
        public static void EnviarCorreoFinalizacionPlan(ref C_AccionesResultado resultado, string[] para, C_ObtenerDatosPlanMejoramiento_Result datosPlan, string usuario, C_DatosSistema_Result datosSistema)
        {
            //// Obtiene la plantilla para el correo
            string Plantilla = Helpers.Utilitarios.ObtenerPlantillaGeneral();

            //// Coloca el título que va en el cuerpo del correo
            Plantilla = Plantilla.Replace("{TITULO}", "Confirmación Finalización Encuesta y Plan de Mejoramiento");

            //// Coloca el asunto del correo
            string Asunto = ObtenerAsuntoxTipo(1);

            //// Coloca el contenido en el cuerpo del correo
            string Contenido = ObtenerPlantillaPlan(datosPlan, usuario);

            //// Integra el contenido
            string Mensaje = Plantilla.Replace("{CONTENIDO}", Contenido);

            //// Envía el correo
            string retorno = Correo.EnviarXSmtp(para, null, null, null, Asunto, Mensaje, datosSistema.SmtpUsername, datosSistema.SmtpPassword, datosSistema.SmtpHost, datosSistema.SmtpPort.Value);

            //// Obtiene la respuesta final de la transacción
            resultado.respuesta = string.IsNullOrEmpty(retorno) ? resultado.respuesta : retorno;
            resultado.estado = string.IsNullOrEmpty(retorno) ? resultado.estado : (int)EstadoRespuesta.Excepcion;
        }

        /// <summary>
        /// Obtiene la plantilla HTML, inserta el mensaje y envía el correo tramitando la solicitud.
        /// </summary>
        /// <param name="resultado">Esado y respuesta de la transacción.</param>
        /// <param name="para">Cuentas de correo de salida</param>
        /// <param name="datosPlan">The datos plan.</param>
        /// <param name="usuario">The usuario.</param>
        /// <param name="datosSistema">datos del sistema.</param>
        public static void EnviarCorreoFinalizacionSeguimientoPlan(ref C_AccionesResultado resultado, string[] para, C_ObtenerDatosSeguimientoPlanMejoramiento_Result datosPlan, string usuario, C_DatosSistema_Result datosSistema)
        {
            //// Obtiene la plantilla para el correo
            string Plantilla = Helpers.Utilitarios.ObtenerPlantillaGeneral();

            //// Coloca el título que va en el cuerpo del correo
            Plantilla = Plantilla.Replace("{TITULO}", "Confirmación Finalización Encuesta y Seguimiento Plan de Mejoramiento");

            //// Coloca el asunto del correo
            string Asunto = ObtenerAsuntoxTipo(5);

            //// Coloca el contenido en el cuerpo del correo
            string Contenido = ObtenerPlantillaSeguimientoPlan(datosPlan, usuario);

            //// Integra el contenido
            string Mensaje = Plantilla.Replace("{CONTENIDO}", Contenido);

            //// Envía el correo
            string retorno = Correo.EnviarXSmtp(para, null, null, null, Asunto, Mensaje, datosSistema.SmtpUsername, datosSistema.SmtpPassword, datosSistema.SmtpHost, datosSistema.SmtpPort.Value);

            //// Obtiene la respuesta final de la transacción
            resultado.respuesta = string.IsNullOrEmpty(retorno) ? resultado.respuesta : retorno;
            resultado.estado = string.IsNullOrEmpty(retorno) ? resultado.estado : (int)EstadoRespuesta.Excepcion;
        }

        /// <summary>
        /// Enviars the correo finalizacion tablero pat.
        /// </summary>
        /// <param name="resultado">The resultado.</param>
        /// <param name="para">The para.</param>
        /// <param name="datos">The datos.</param>
        /// <param name="datosSistema">The datos sistema.</param>
        /// <param name="tipoEnvio">The tipo envio.</param>
        public static void EnviarCorreoFinalizacionTableroPat(ref C_AccionesResultado resultado, string[] para, EnvioTablero datos, C_DatosSistema_Result datosSistema,string tipoEnvio)
        {
            //// Obtiene la plantilla para el correo
            string Plantilla = Helpers.Utilitarios.ObtenerPlantillaGeneral();

            //// Coloca el asunto del correo
            string Asunto = "";

            //// Coloca el título que va en el cuerpo del correo
            if (tipoEnvio == "PM" || tipoEnvio == "PD") {
                Asunto = ObtenerAsuntoxTipo(2);
                Plantilla = Plantilla.Replace("{TITULO}", "Confirmación Envio de la planeación tablero Pat  ");
            }
            if (tipoEnvio == "SM1" || tipoEnvio == "SD1")
            {
                Asunto = ObtenerAsuntoxTipo(3);
                Plantilla = Plantilla.Replace("{TITULO}", "Confirmación Envio del primer seguimiento tablero Pat  ");
            }
            if (tipoEnvio == "SM2" || tipoEnvio == "SD2")
            {
                Asunto = ObtenerAsuntoxTipo(4);
                Plantilla = Plantilla.Replace("{TITULO}", "Confirmación Envio del segundo seguimiento tablero Pat  ");
            }

            //// Coloca el contenido en el cuerpo del correo
            string Contenido = ObtenerPlantillaTableroPat(datos);

            //// Integra el contenido
            string Mensaje = Plantilla.Replace("{CONTENIDO}", Contenido);

            //// Envía el correo
            string retorno = Correo.EnviarXSmtp(para, null, null, null, Asunto, Mensaje, datosSistema.SmtpUsername, datosSistema.SmtpPassword, datosSistema.SmtpHost, datosSistema.SmtpPort.Value);

            //// Obtiene la respuesta final de la transacción
            resultado.respuesta = string.IsNullOrEmpty(retorno) ? resultado.respuesta : retorno;
            resultado.estado = string.IsNullOrEmpty(retorno) ? resultado.estado : (int)EstadoRespuesta.Excepcion;
        }

        /// <summary>
        /// Obteners the plantilla tablero pat.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>System.String.</returns>
        private static string ObtenerAsuntoxTipo(int pTipo)
        {
            string Plantilla = string.Empty;
            string Retorno = string.Empty;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                C_DatosSistema_Result datosSistema = BD.C_DatosSistema().First();
                switch (pTipo)
                {
                    case 1:
                        Retorno = datosSistema.AsuntoEnvioR;
                        break;
                    case 2:
                        Retorno = datosSistema.AsuntoEnvioPT;
                        break;
                    case 3:
                        Retorno = datosSistema.AsuntoEnvioSeguimientoT1;
                        break;
                    case 4:
                        Retorno = datosSistema.AsuntoEnvioSeguimientoT2;
                        break;
                    case 5:
                        Retorno = datosSistema.AsuntoEnvioSP;
                        break;
                }
            }

            return Retorno;
        }

        /// <summary>
        /// Obteners the plantilla tablero pat.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>System.String.</returns>
        private static string ObtenerPlantillaTableroPat(EnvioTablero model)
        {
            string Plantilla = string.Empty;
            string Retorno = string.Empty;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                C_DatosSistema_Result datosSistema = BD.C_DatosSistema().First();
                if (model.tipoEnvio == "PM" || model.tipoEnvio == "PD")
                {
                    Plantilla = datosSistema.PlantillaEmailConfirmacionPlaneacionPat;
                }
                if (model.tipoEnvio == "SM1" || model.tipoEnvio == "SD1")
                {
                    Plantilla = datosSistema.PlantillaEmailConfirmacionSeguimiento1Pat;
                }
                if (model.tipoEnvio == "SM2" || model.tipoEnvio == "SD2")
                {
                    Plantilla = datosSistema.PlantillaEmailConfirmacionSeguimiento2Pat;
                }              
                Retorno = string.Format(Plantilla, model.Usuario, model.anoTablero);
            }

            return Retorno;
        }

        /// <summary>
        /// Obtiene la plantilla para enviar el correo.
        /// </summary>
        /// <param name="estado">The estado.</param>
        /// <param name="model">The model.</param>
        /// <param name="url">The URL.</param>
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
        /// Obtiene la plantilla del Plan de Mejoramiento para enviar el correo.
        /// </summary>
        /// <param name="datosPlan">The datos plan.</param>
        /// <param name="usuario">The usuario.</param>
        /// <returns>System.String.</returns>
        private static string ObtenerPlantillaPlan(C_ObtenerDatosPlanMejoramiento_Result datosPlan, string usuario)
        {
            string Plantilla = string.Empty;
            string Retorno = string.Empty;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                C_DatosSistema_Result datosSistema = BD.C_DatosSistema().First();
                //Plantilla = BD.C_ParametrosSistema(SistemaGrupo.PlantillasCorreo, UtilMensajeria.PlantillaFinalizacionPlan).FirstOrDefault().ParametroValor;
                Plantilla = datosSistema.PlantillaEmailConfirmacion;
                Retorno = string.Format(Plantilla, usuario, datosPlan.NombreEncuesta);
            }

            return Retorno;
        }

        /// <summary>
        /// Obtiene la plantilla del Seguimiento del Plan de Mejoramiento para enviar el correo.
        /// </summary>
        /// <param name="datosPlan">The datos plan.</param>
        /// <param name="usuario">The usuario.</param>
        /// <returns>System.String.</returns>
        private static string ObtenerPlantillaSeguimientoPlan(C_ObtenerDatosSeguimientoPlanMejoramiento_Result datosPlan, string usuario)
        {
            string Plantilla = string.Empty;
            string Retorno = string.Empty;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                C_DatosSistema_Result datosSistema = BD.C_DatosSistema().First();
                Plantilla = datosSistema.PlantillaEmailConfirmacionSeguimientoPlan;
                Retorno = string.Format(Plantilla, usuario, datosPlan.NombrenEncuesta);
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
                        return JsonConvert.DeserializeObject<T>(datos.Replace(@"\", @"|"));
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