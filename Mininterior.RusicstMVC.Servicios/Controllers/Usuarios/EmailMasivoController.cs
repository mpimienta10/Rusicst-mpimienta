// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 08-15-2017
// ***********************************************************************
// <copyright file="EmailMasivoController.cs" company="Ministerio del Interior">
//     Copyright ©  Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Usuarios namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Usuarios
{
    using Aplicacion.Adjuntos;
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Aplicacion;
    using Mininterior.RusicstMVC.Aplicacion.Mensajeria;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Threading.Tasks;
    using System.Web.Http;

    /// <summary>
    /// Class EmailMasivoController.
    /// </summary>
    [Authorize]
    public class EmailMasivoController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>IEnumerable&lt;C_CampanaEmail_Result&gt;.</returns>
        [Route("api/Usuarios/EmailMasivo/")]
        public IEnumerable<C_CampanaEmail_Result> Get(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_CampanaEmail_Result> resultado = Enumerable.Empty<C_CampanaEmail_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_CampanaEmail().Cast<C_CampanaEmail_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Insertar el correo masivo y envía a todos los usuarios que se quiere enviar.
        /// </summary>
        /// <returns>resultado de la operación</returns>
        [HttpPost]
        [Route("api/Usuarios/EmailMasivo/Insertar")]
        public async Task<HttpResponseMessage> Insertar()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();
            List<string> ListaCorreos = new List<string>();
            C_DatosSistema_Result DatosSistema = new C_DatosSistema_Result();
            FileInfo FileAdjunto = null;
            string OriginalFileName = string.Empty;

            if (!this.Request.Content.IsMimeMultipartContent())
            {
                this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Helpers.Utilitarios.GetMultipartProvider();
            var result = await this.Request.Content.ReadAsMultipartAsync(provider);

            CampanaEmailModels model = (CampanaEmailModels)Helpers.Utilitarios.GetFormData<CampanaEmailModels>(result);

            if (result.FileData.Count() > 0)
            {
                OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
                FileAdjunto = new FileInfo(result.FileData.First().LocalFileName);
            }

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Lista de correos filtrada por el tipo de usuario
                    ListaCorreos = BD.C_Usuario(null, null, model.IdTipoUsuario, null, null, null, (int)EstadoSolicitud.Aprobada).Select(e => e.Email).ToList();

                    //// Valida si hay cuentas de correo para enviar la campaña
                    if (ListaCorreos.Count() > 0)
                    {
                        DatosSistema = BD.C_DatosSistema().First();

                        //// Determina si tiene o no adjunto
                        AlistarYEnviarCorreos(DatosSistema, model, ListaCorreos, FileAdjunto, OriginalFileName, ref Resultado);

                        if (string.IsNullOrEmpty(Resultado.respuesta))
                        {
                            //// Selecciona el usuario que esta enviando la campaña por correo
                            C_Usuario_Result usuarioTramite = BD.C_Usuario(null, null, null, null, null, model.Usuario, null).First();
                            model.IdUsuario = usuarioTramite.Id;

                            ////=================================================================================                          
                            //// El último parámetro debe validar cuales se pudieron enviar y cuales no
                            ////=================================================================================
                            model.Total = model.Enviados = ListaCorreos.Count();
                            Resultado = BD.I_CampanaEmailInsert(model.IdUsuario, model.IdTipoUsuario, model.Asunto, model.Mensaje, model.Total, model.Enviados).FirstOrDefault();
                        }
                    }
                }

                (new Providers.AuditExecuted(Category.EnvioEmailMasivo)).ActionExecutedManual(model);
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        /// <summary>
        /// Envia un correo de prueba
        /// </summary>
        /// <returns>resultado de la operación</returns>
        [HttpPost]
        [Route("api/Usuarios/EmailMasivo/EnviarCorreoPrueba")]
        public async Task<HttpResponseMessage> EnviarCorreoPrueba()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();
            C_DatosSistema_Result DatosSistema = new C_DatosSistema_Result();
            FileInfo FileAdjunto = null;
            string OriginalFileName = string.Empty;

            if (!this.Request.Content.IsMimeMultipartContent())
            {
                this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Helpers.Utilitarios.GetMultipartProvider();
            var result = await this.Request.Content.ReadAsMultipartAsync(provider);

            CampanaEmailModels model = (CampanaEmailModels)Helpers.Utilitarios.GetFormData<CampanaEmailModels>(result);

            if (result.FileData.Count() > 0)
            {
                OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
                FileAdjunto = new FileInfo(result.FileData.First().LocalFileName);
            }

            List<string> ListaCorreos = new List<string>() { model.CorreoPrueba };

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    DatosSistema = BD.C_DatosSistema().First();
                }

                //// Determina si tiene o no adjunto
                AlistarYEnviarCorreos(DatosSistema, model, ListaCorreos, FileAdjunto, OriginalFileName, ref Resultado);

                (new Providers.AuditExecuted(Category.EnvioEmailPrueba)).ActionExecutedManual(model);
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        /// <summary>
        /// Alistars the y enviar correos.
        /// </summary>
        /// <param name="datosSistema">The datos sistema.</param>
        /// <param name="campana">The campana.</param>
        /// <param name="listaCorreos">The lista correos.</param>
        /// <param name="adjunto">The adjunto.</param>
        /// <param name="fileName">Name of the file.</param>
        /// <param name="resultado">The resultado.</param>
        private void AlistarYEnviarCorreos(C_DatosSistema_Result datosSistema, CampanaEmailModels campana, List<string> listaCorreos, FileInfo adjunto, string fileName, ref C_AccionesResultado resultado)
        {
            //// Carga el archivo adjunto para ser enviado en el correo
            List<AdjuntoCorreo> Adjuntos = new List<AdjuntoCorreo>();

            if (null != adjunto)
            {
                Adjuntos.Add(new AdjuntoCorreo() { Nombre = fileName, Contenido = System.IO.File.ReadAllBytes(adjunto.FullName) });
            }

            if (listaCorreos.Count > 499)
            {
                List<List<string>> misListas = Split(listaCorreos, 499);
                foreach (var item in misListas)
                {
                    resultado.respuesta = Correo.EnviarXSmtp(null, null, item.ToArray(), Adjuntos.ToArray(), campana.Asunto, campana.Mensaje, datosSistema.FromEmail, datosSistema.SmtpPassword, datosSistema.SmtpHost, datosSistema.SmtpPort.Value);
                    resultado.estado = !string.IsNullOrEmpty(resultado.respuesta) ? (int)EstadoRespuesta.Excepcion : (int)EstadoRespuesta.Insertado;

                }
            }
            else
            {
                resultado.respuesta = Correo.EnviarXSmtp(null, null, listaCorreos.ToArray(), Adjuntos.ToArray(), campana.Asunto, campana.Mensaje, datosSistema.FromEmail, datosSistema.SmtpPassword, datosSistema.SmtpHost, datosSistema.SmtpPort.Value);
                resultado.estado = !string.IsNullOrEmpty(resultado.respuesta) ? (int)EstadoRespuesta.Excepcion : (int)EstadoRespuesta.Insertado;
            }
        }

        public static List<List<string>> Split(List<string> source, int maxSubItems)
        {
            return source
                .Select((x, i) => new { Index = i, Value = x })
                .GroupBy(x => x.Index / maxSubItems)
                .Select(x => x.Select(v => v.Value).ToList())
                .ToList();
        }
    }
}