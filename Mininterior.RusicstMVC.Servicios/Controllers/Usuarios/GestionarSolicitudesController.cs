// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 11-06-2017
// ***********************************************************************
// <copyright file="GestionarSolicitudesController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Usuarios namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Usuarios
{
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Aplicacion;
    using Mininterior.RusicstMVC.Aplicacion.Adjuntos;
    using Mininterior.RusicstMVC.Aplicacion.Mensajeria;
    using Mininterior.RusicstMVC.Entidades;
    using Mininterior.RusicstMVC.Servicios.Helpers;
    using Mininterior.RusicstMVC.Servicios.Models;
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
    /// Class GestionarSolicitudesController.
    /// </summary>
    public class GestionarSolicitudesController : ApiController
    {
        /// <summary>
        /// Obtiene las solicitudes de usuario
        /// </summary>
        /// <param name="audUserName">Name of the aud user.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <returns>Lista de solicitudes</returns>
        [Authorize]
        [Route("api/Usuarios/GestionarSolicitudes/")]
        public IEnumerable<C_Usuario_Result> Get(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_Usuario_Result> resultado = Enumerable.Empty<C_Usuario_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_Usuario(null, null, null, null, null, null, (int)EstadoSolicitud.Confirmada).Cast<C_Usuario_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtiene el histórico de las solicitudes de usuarios.
        /// </summary>
        /// <param name="audUserName">Name of the aud user.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <returns>IEnumerable C_UsuariosHistoricoSolicitudes_Resul</returns>
        [Authorize]
        [Route("api/Usuarios/GestionarSolicitudes/Historico/")]
        public IEnumerable<C_UsuariosHistoricoSolicitudes_Result> GetHistorico(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_UsuariosHistoricoSolicitudes_Result> resultado = Enumerable.Empty<C_UsuariosHistoricoSolicitudes_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_UsuariosHistoricoSolicitudes().Cast<C_UsuariosHistoricoSolicitudes_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtiene el histórico de las solicitudes de usuarios.
        /// </summary>
        /// <param name="audUserName">Name of the aud user.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <returns>IEnumerable C_UsuariosHistoricoUsuarioSolicitudes_Result</returns>
        [Authorize]
        [HttpGet]
        [Route("api/Usuarios/GestionarSolicitudes/HistoricoUsuario/")]
        public IEnumerable<C_UsuariosHistoricoUsuarioSolicitudes_Result> GetHistoricoUsuario(string audUserName, string userNameAddIdent, int? pIdDepto, int? pIdMun, int? pIdTipoUsuario)
        {
            IEnumerable<C_UsuariosHistoricoUsuarioSolicitudes_Result> resultado = Enumerable.Empty<C_UsuariosHistoricoUsuarioSolicitudes_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_UsuariosHistoricoUsuarioSolicitudes(pIdDepto, pIdMun, pIdTipoUsuario) .Cast<C_UsuariosHistoricoUsuarioSolicitudes_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtiene el histórico de las solicitudes de usuarios.
        /// </summary>
        /// <param name="audUserName">Name of the aud user.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <returns>IEnumerable C_UsuariosHistoricoUsuarioSolicitudes_Result</returns>
        [Authorize]
        [HttpGet]
        [Route("api/Usuarios/GestionarSolicitudes/UsuarioHistorico/")]
        public IEnumerable<C_HistoricoXUsuario_Result> GetUsuarioHistorico(string audUserName, string userNameAddIdent, string pUsername)
        {
            IEnumerable<C_HistoricoXUsuario_Result> resultado = Enumerable.Empty<C_HistoricoXUsuario_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_HistoricoXUsuario(pUsername).Cast<C_HistoricoXUsuario_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Insertar una solicitud de usuario
        /// </summary>
        /// <returns>Estado y respuesta de la transacción.</returns>
        [AllowAnonymous]
        [HttpPost]
        [Route("api/Usuarios/GestionarSolicitudes/InsertarSolicitud")]
        public async Task<HttpResponseMessage> InsertarSolicitud()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            if (!this.Request.Content.IsMimeMultipartContent())
            {
                this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Helpers.Utilitarios.GetMultipartProvider();
            var result = await this.Request.Content.ReadAsMultipartAsync(provider);

            UsuariosModels model = (UsuariosModels)Helpers.Utilitarios.GetFormData<UsuariosModels>(result);
            model.Token = Guid.NewGuid();

            var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
            var File = new FileInfo(result.FileData.First().LocalFileName);

            //// Obtiene el documento de solicitud
            model.DocumentoSolicitud = DateTime.Now.Year + "_" + DateTime.Now.Month + "_" + DateTime.Now.Day + "_" + model.IdDepartamento + "_" + model.IdMunicipio + "_" + model.Token + Path.GetExtension(OriginalFileName);

            try
            {
                //// Guardar los datos de solicitud de usuario
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    Resultado = BD.I_UsuarioInsert(model.IdDepartamento, model.IdMunicipio, (int)EstadoSolicitud.Solicitada, model.Nombres, model.Cargo, model.TelefonoFijo,
                                                   model.TelefonoFijoIndicativo, model.TelefonoFijoExtension, model.TelefonoCelular, model.Email,
                                                   model.EmailAlternativo, model.Token, DateTime.Now, model.DocumentoSolicitud).FirstOrDefault();

                    if (Resultado.estado > 0)
                    {
                        C_DatosSistema_Result datosSistema = BD.C_DatosSistema().First();
                        Helpers.Utilitarios.EnviarCorreoSolicitud(ref Resultado, new string[] { model.Email, (model.EmailAlternativo != null && !String.IsNullOrEmpty(model.EmailAlternativo)) ? model.EmailAlternativo : null }, datosSistema, model, EstadoSolicitud.Solicitada, model.Url,"",null,null);

                        //// Valida si envió el correo, de lo contrario, elimina el usuario 
                        if (Resultado.estado == (int)EstadoRespuesta.Excepcion)
                        {
                            BD.D_UsuarioDelete(BD.C_Usuario(null, model.Token, null, null, null, null, null).First().Id, null);
                            model.Excepcion = true;
                            model.ExcepcionMensaje = Mensajes.SolicitudCreacionError;
                        }
                        else
                        {
                            Archivo.GuardarArchivoRepositorio(File, Archivo.pathSolicitudesUsuario, model.DocumentoSolicitud);
                        }

                        (new AuditExecuted(Category.CrearSolicitud)).ActionExecutedManual(model);
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        /// <summary>
        /// Confirmar la solicitud de usuario.
        /// </summary>
        /// <param name="model">el model.</param>
        /// <returns>Estado y respuesta de la transacción</returns>
        /// Confirmar la solicitud que se envió por correo.
        [AllowAnonymous]
        [HttpPost]
        [Route("api/Usuarios/GestionarSolicitudes/ConfirmarSolicitud")]
        public C_AccionesResultado ConfirmarSolicitud(UsuariosModels model)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Valida si el token es real
                    List<C_Usuario_Result> listaSolicitudes = BD.C_Usuario(null, model.Token, null, null, null, null, null).ToList();

                    if (listaSolicitudes.Count() == 0)
                    {
                        //// Sucede cuando el Token fue alterado por el usuario - Reenviar al usuario a la página login
                        Resultado.estado = (int)EstadoRespuesta.Redireccionar;
                        Resultado.respuesta = UtilGeneral.UrlLogin;
                    }
                    else
                    {
                        C_Usuario_Result Solicitud = listaSolicitudes.FirstOrDefault();
                        int EstadoActual = Solicitud.IdEstado.Value;

                        //// Si el estado es una solicitud o es una confirmación genera una respuesta y finaliza
                        if (EstadoActual == (int)EstadoSolicitud.Solicitada)
                        {
                            Solicitud.IdEstado = (int)EstadoSolicitud.Confirmada;
                            Solicitud.Estado = EstadoSolicitud.Confirmada.ToString();
                            Solicitud.FechaNoRepudio = DateTime.Now;
                            Resultado = BD.U_UsuarioUpdate(Solicitud.Id, null, null, null, null, Solicitud.IdEstado, null, null, null, null, null, null,
                                                           null, null, null, null, null, null, null, null, null, null, Solicitud.FechaNoRepudio, null, null, null,
                                                           SistemaGrupo.MensajesSistema, UtilMensajeria.MsjConfirmacionNoRepudio, null).FirstOrDefault();

                            ////============================================================================
                            //// Se coloca la auditoría a esta altura porque el los otros condicionales 
                            //// no realizan operaciones de actualziación en la base de datos
                            ////============================================================================
                            (new AuditExecuted(Category.ConfirmarSolicitud)).ActionExecutedManual(Solicitud);
                        }

                        //// Si el estado ya fué confirmado por el Ministerio
                        else if (EstadoActual == (int)EstadoSolicitud.MinConfirmada)
                        {
                            //// redirecciona al usuario para que cree su correspondiente contraseña
                            Resultado.estado = (int)EstadoRespuesta.Redireccionar;
                            Resultado.respuesta = UtilGeneral.UrlEstablecerContrasena + model.Token;
                        }
                        else if (EstadoActual == (int)EstadoSolicitud.Confirmada)
                        {
                            Resultado.estado = (int)EstadoRespuesta.Actualizado;
                            Resultado.respuesta = BD.C_ParametrosSistema(SistemaGrupo.MensajesSistema, UtilMensajeria.MsjSolicitudEnTramite).FirstOrDefault().ParametroValor;
                        }
                        else if (EstadoActual == (int)EstadoSolicitud.Rechazada)
                        {
                            Resultado.estado = (int)EstadoRespuesta.Actualizado;
                            Resultado.respuesta = BD.C_ParametrosSistema(SistemaGrupo.MensajesSistema, UtilMensajeria.MsjSolicitudRechazada).FirstOrDefault().ParametroValor;
                        }
                        else
                        {
                            //// redirecciona al login
                            Resultado.estado = (int)EstadoRespuesta.Redireccionar;
                            Resultado.respuesta = UtilGeneral.UrlLogin;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, string.Empty, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return Resultado;
        }

        /// <summary>
        /// Remitirs the specified identifier solicitud.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [Authorize]
        [HttpPost]
        [Route("api/Usuarios/GestionarSolicitudes/Remitir")]
        public async Task<HttpResponseMessage> Remitir()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();
            FileInfo FileAdjunto = null;

            if (!Request.Content.IsMimeMultipartContent())
            {
                Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Utilitarios.GetMultipartProvider();
            var result = await Request.Content.ReadAsMultipartAsync(provider);

            UsuariosModels model = (UsuariosModels)Utilitarios.GetFormData<UsuariosModels>(result);

            if (result.FileData.Count() > 0)
            {
                model.NombreArchivo = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
                FileAdjunto = new FileInfo(result.FileData.First().LocalFileName);
            }

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Obtiene la solicitud de usuario y lo actualiza
                    C_Usuario_Result Solicitud = BD.C_Usuario(model.Id, null, null, null, null, null, null).FirstOrDefault();

                    //// Validación: Si el tipo de usuario es ALCALDIA, revisa que tenga relacionado un municipio. 
                    //// Si no, retorna una excepción avisando que no puede ser direccionado a este tipo de usuario
                    if (model.IdTipoUsuario == (int)TipoUsuario.alcaldia && Solicitud.IdMunicipio == 0)
                    {
                        Resultado.estado = (int)EstadoRespuesta.Excepcion;
                        Resultado.respuesta = "No es posible asignar el Tipo de Usuario ALCALDIA porque el USUARIO no tiene un Municipio asociado.";
                        model.Excepcion = true;
                        model.ExcepcionMensaje = Resultado.respuesta;
                        return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
                    }

                    model.Token = Solicitud.Token;
                    model.IdEstado = model.Acepta ? (int)EstadoSolicitud.MinConfirmada : (int)EstadoSolicitud.Rechazada;

                    //// En el model.IdUsuarioTramite llega el UserName, con éste pregunta en la consulta  
                    //// y a esa misma variable se le asigna el id para colocarlo en el Update
                    C_Usuario_Result usuarioTramite = BD.C_Usuario(null, null, null, null, null, model.AudUserName, null).First();
                    model.IdUsuarioTramite = usuarioTramite.Id.ToString();
                    model.FechaTramite = DateTime.Now;

                    ///// Actualiza los datos del usuario colocando el nuevo estado
                    if (model.IdTipoUsuario != 0)
                        Resultado = BD.U_UsuarioUpdate(model.Id, null, model.IdTipoUsuario, null, null, model.IdEstado, int.Parse(model.IdUsuarioTramite), null, null, null, null, null,
                                                       null, null, null, null, null, null, null, null, null, null, null, model.FechaTramite, null, null, null, null, null).FirstOrDefault();
                    else
                        Resultado = BD.U_UsuarioUpdate(model.Id, null, null, null, null, model.IdEstado, int.Parse(model.IdUsuarioTramite), null, null, null, null, null,
                                                           null, null, null, null, null, null, null, null, null, null, null, model.FechaTramite, null, null, null, null, null).FirstOrDefault();


                    //// Valida que la transacción haya sido exitosa y envía el correo
                    if (Resultado.estado > 0)
                    {
                        C_DatosSistema_Result datosSistema = BD.C_DatosSistema().First();
                        Helpers.Utilitarios.EnviarCorreoSolicitud(ref Resultado, new string[] { Solicitud.Email, (Solicitud.EmailAlternativo != null && !String.IsNullOrEmpty(Solicitud.EmailAlternativo)) ? Solicitud.EmailAlternativo : null },
                                                   datosSistema, model, model.Acepta ? EstadoSolicitud.MinConfirmada : EstadoSolicitud.Rechazada, model.Url, model.ExcepcionMensaje, FileAdjunto, model.NombreArchivo);

                        //// Valida si envió el correo, de lo contrario, elimina el usuario 
                        if (Resultado.estado == (int)EstadoRespuesta.Excepcion)
                        {
                            model.IdEstado = (int)EstadoSolicitud.Confirmada;
                            model.ExcepcionMensaje = Resultado.respuesta;
                            BD.U_UsuarioUpdate(model.Id, null, null, null, null, model.IdEstado, null, null, null, null, null, null,
                                                       null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            finally
            {
                (new AuditExecuted(Resultado.estado == 1 ? Category.RemitirSolicitud : Category.RemitirSolicitud)).ActionExecutedManual(model);
            }
            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        /// <summary>
        /// Descargars the specified archivo.
        /// </summary>
        /// <param name="audUserName">Name of the aud user.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <param name="archivo">The archivo.</param>
        /// <param name="nombreArchivo">The nombre archivo.</param>
        /// <returns>HttpResponseMessage.</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/Usuarios/GestionarSolicitudes/Download/")]
        public HttpResponseMessage Descargar(string audUserName, string userNameAddIdent, string archivo, string nombreArchivo)
        {
            try
            {
                return Archivo.Descargar(archivo, nombreArchivo, Archivo.pathSolicitudesUsuario);
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return null;
            }
        }
    }
}