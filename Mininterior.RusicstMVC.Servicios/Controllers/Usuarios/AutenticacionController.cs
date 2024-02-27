// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 11-06-2017
// ***********************************************************************
// <copyright file="AutenticacionController.cs" company="Ministerio del Interior">
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
    using Microsoft.AspNet.Identity;
    using Microsoft.Owin.Security;
    using Microsoft.Owin.Security.OAuth;
    using Mininterior.RusicstMVC.Aplicacion;
    using Mininterior.RusicstMVC.Entidades;
    using Mininterior.RusicstMVC.Servicios.Models;
    using Newtonsoft.Json.Linq;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.DirectoryServices;
    using System.DirectoryServices.AccountManagement;
    using System.Linq;
    using System.Security.Claims;
    using System.Text.RegularExpressions;
    using System.Threading.Tasks;
    using System.Web.Http;

    /// <summary>
    /// Class AutenticacionController.
    /// </summary>
    public class AutenticacionController : ApiController
    {
        /// <summary>
        /// The _repo
        /// </summary>
        private AuthRepository _repo = null;

        /// <summary>
        /// Initializes a new instance of the <see cref="AutenticacionController" /> class.
        /// </summary>
        public AutenticacionController()
        {
            _repo = new AuthRepository();
        }

        /// <summary>
        /// Establecers the contrasena.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [AllowAnonymous]
        [HttpPost, AuditExecuted(Category.EstablecerContraseña)]
        [Route("api/Usuarios/Autenticacion/EstablecerContrasena")]
        public async Task<IHttpActionResult> EstablecerContrasena(UsuariosModels model)
        {
            Guid Token;

            //// Valida que el Token tenga la estructura
            if (Guid.TryParse(model.Token.ToString(), out Token))
            {
                try
                {
                    C_Usuario_Result Solicitud = this.ObtenerSolicitud(Token);
                    LoginModel loginModel = new Models.LoginModel() { Token = model.Token, Password = model.Password, UserName = model.UserName, Email = Solicitud.Email, Telefono = Solicitud.TelefonoFijo };

                    //// Si el token no trajo ninguna solicitud
                    if (null == Solicitud)
                    {
                        //// Sucede cuando el Token fue alterado por el usuario - Reenviar al usuario a la página login
                        ModelState.AddModelError("estado", new Exception(((int)EstadoRespuesta.UsuarioInvalido).ToString()));
                        return BadRequest(ModelState);
                    }

                    C_Usuario_Result Usuario = new C_Usuario_Result();

                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        //// Trae el usuario que esta registrandose
                        Usuario = BD.C_Usuario(null, null, null, null, null, loginModel.UserName, null).FirstOrDefault();
                    }
                    if((Usuario != null && Usuario.FechaConfirmacion != null) && (Usuario.IdTipoUsuario != 2 && Usuario.IdTipoUsuario != 7))
                    {
                        ModelState.AddModelError("estado", new Exception(((int)EstadoRespuesta.Excepcion).ToString()));
                        return BadRequest(ModelState);
                    }

                    IdentityResult result = await _repo.RegisterUser(loginModel);
                    IHttpActionResult errorResult = GetErrorResult(result);

                    if (errorResult != null)
                    {
                        return errorResult;
                    }

                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        C_AccionesResultado Resultado = new C_AccionesResultado();
                        model.Email = loginModel.Email; model.UserName = model.UserName; model.Password = model.Password;

                        C_DatosSistema_Result datosSistema = BD.C_DatosSistema().First();
                        Helpers.Utilitarios.EnviarCorreoSolicitud(ref Resultado, new string[] { model.Email }, datosSistema, model, EstadoSolicitud.Aprobada, model.Url,"",null,null);

                        if (Resultado.estado != (int)EstadoRespuesta.Excepcion)
                        {
                            //// Actualiza la información del usuario y lo deja en enviado
                            BD.U_UsuarioUpdate(Solicitud.Id, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, null, null, null, null, null, null, null, null, null, null, null, null);
                        }
                    }
                }
                catch (Exception ex)
                {
                    (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.UserName, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                }

                return Ok();
            }
            else
            {
                ModelState.AddModelError("estado", new Exception(((int)EstadoRespuesta.UsuarioInvalido).ToString()));
                return BadRequest(ModelState);
            }
        }

        /// <summary>
        /// Recuperar the contrasena.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [AllowAnonymous]
        [HttpPost, AuditExecuted(Category.ResetiarContraseña)]
        [Route("api/Usuarios/Autenticacion/RecuperarContrasena")]
        public async Task<IHttpActionResult> RecuperarContrasena(UsuariosModels model)
        {
            try
            {
                ////==========================================================================================================================
                //// Este ajuste se hace necesario porque al pasar el signo mas (+) por url es interpretado diferente y llega como un espacio
                ////==========================================================================================================================
                string Contrasena = Mininterior.RusicstMVC.Aplicacion.Seguridad.Generador.GenerateToken(8).Replace("+", "=");

                using (AuthRepository _repo = new AuthRepository())
                {
                    IdentityResult result = await _repo.RecoveryPassword(model.UserName, model.Email, Contrasena);

                    IHttpActionResult errorResult = GetErrorResult(result);

                    if (errorResult != null)
                    {
                        model.Excepcion = true;

                        if (result.Errors.Count() == 0)
                        {
                            model.ExcepcionMensaje = Mensajes.UsuarioYCorreoDiferentes;
                            return Ok(Mensajes.UsuarioYCorreoDiferentes);
                        }
                        else
                        {
                            result.Errors.ToList().ForEach(e => model.ExcepcionMensaje += e.ToString());
                            return errorResult;
                        }
                    }
                }

                model.Password = Contrasena;
                C_DatosSistema_Result datosSistema = new C_DatosSistema_Result();
                List<string> ListaCorreos = new List<string>() { model.Email };

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    datosSistema = BD.C_DatosSistema().First();
                }

                C_AccionesResultado Resultado = new C_AccionesResultado();
                Helpers.Utilitarios.EnviarCorreoSolicitud(ref Resultado, ListaCorreos.ToArray(), datosSistema, model, EstadoSolicitud.RecuperarContraseña, model.Url,"",null,null);
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.UserName, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return Ok();
        }

        /// <summary>
        /// Modificars the contrasena.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [AllowAnonymous]
        [HttpPost, AuditExecuted(Category.CambiarContraseña)]
        [Route("api/Usuarios/Autenticacion/ModificarContrasena")]
        public C_AccionesResultado ModificarContrasena(UsuariosModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (AuthRepository _repo = new AuthRepository())
                {
                    IdentityResult result = _repo.ChangePassword(model.UserName, model.Password, model.NewPassword);

                    resultado.estado = !result.Succeeded ? (int)EstadoRespuesta.Excepcion : (int)EstadoRespuesta.Actualizado;
                    resultado.respuesta = result.Errors.Count() > 0 ? result.Errors.First() : !result.Succeeded ? Mensajes.ClaveErrada : string.Empty;

                    //// Datos importantes para la auditoría.
                    model.DatosActualizados = result.Succeeded;
                    model.NewPassword = null;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.UserName, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                resultado.estado = (int)EstadoRespuesta.Excepcion;
                resultado.respuesta = ex.Message;
                return resultado;
            }

            return resultado;
        }

        /// <summary>
        /// Registreses the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [AllowAnonymous]
        [HttpPost]
        [Route("api/Usuarios/Autenticacion/Registrese")]
        public C_AccionesResultado Registrese(LoginModel model)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            try
            {
                Guid Token;

                //// Valida que el Token tenga la estructura
                if (Guid.TryParse(model.Token.ToString(), out Token))
                {
                    C_Usuario_Result Solicitud = this.ObtenerSolicitud(Token);

                    //// Si el token no trajo ninguna solicitud
                    if (null != Solicitud && (Solicitud.IdTipoUsuario == (int)Aplicacion.TipoUsuario.alcaldia || Solicitud.IdTipoUsuario == (int)Aplicacion.TipoUsuario.gobernacion))
                    {
                        string Usuario = "";

                        using (EntitiesRusicst db = new EntitiesRusicst())
                        {

                            if(Solicitud.IdTipoUsuario == (int)Aplicacion.TipoUsuario.alcaldia)
                            {
                                var userdb = db.C_Usuario(null, null, Solicitud.IdTipoUsuario, Solicitud.IdDepartamento, Solicitud.IdMunicipio, null, (int)EstadoSolicitud.Aprobada).First();

                                if(userdb != null)
                                {
                                    Usuario = userdb.UserName;
                                } else
                                {
                                    Usuario = (Aplicacion.TipoUsuario.alcaldia.ToString() + "_" + Solicitud.Municipio.Replace(' ', '_') + "_" + Solicitud.Departamento.Replace(' ', '_'));
                                }
                            } else if (Solicitud.IdTipoUsuario == (int)Aplicacion.TipoUsuario.gobernacion)
                            {
                                var userdb = db.C_Usuario(null, null, Solicitud.IdTipoUsuario, Solicitud.IdDepartamento, null, null, (int)EstadoSolicitud.Aprobada).First();

                                if (userdb != null)
                                {
                                    Usuario = userdb.UserName;
                                }
                                else
                                {
                                    Usuario = (Aplicacion.TipoUsuario.gobernacion.ToString() + "_" + Solicitud.Departamento.Replace(' ', '_'));
                                }
                            }
                            
                        }

                        //Usuario = Usuario.Normalize(System.Text.NormalizationForm.FormD).ToLower();

                        //string Usuario = (Solicitud.IdTipoUsuario == (int)Aplicacion.TipoUsuario.alcaldia ? (Aplicacion.TipoUsuario.alcaldia.ToString() + "_" + Solicitud.Municipio.Replace(' ', '_') + "_" + Solicitud.Departamento.Replace(' ', '_')) : Aplicacion.TipoUsuario.gobernacion.ToString() + "_" + Solicitud.Departamento.Replace(' ', '_')).Normalize(System.Text.NormalizationForm.FormD).ToLower();

                        Resultado.estado = 5;
                        //Resultado.respuesta = Regex.Replace(Usuario, @"[^a-zA-z0-9 ]+", "");
                        Resultado.respuesta = Usuario;
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.UserName, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return Resultado;
        }

        /// <summary>
        /// Registreses the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [AllowAnonymous]
        [HttpPost, AuditExecuted(Category.CerrarSesion)]
        [Route("api/Usuarios/Autenticacion/LogOut")]
        public void LogOut(LogOutModels model)
        { }

        /// <summary>
        /// Valida que el usuario se encuentre en el directorio activo.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>IHttpActionResult.</returns>
        [AllowAnonymous]
        [HttpPost]
        [Route("api/Usuarios/Autenticacion/ValidarUsuariosInternos")]
        public IHttpActionResult ValidarUsuariosInternos(LoginModel model)
        {
            //-------------------------------
            ////string resultado = string.Empty;
            //-------------------------------

            try
            {
                //--------------------------------------------------------------------
                ////resultado = "entro" + Environment.NewLine;
                //--------------------------------------------------------------------

                ////==================================================================================
                //// Se retira la validación del dominio de acuerdo a la reunión del 02-11-2017. Se 
                //// afirma que en la aplicación de referencia al momento de digitar el usuario no
                //// pide el nombre del dominio si no que se coloca el nombre de usuario directamente
                ////==================================================================================

                //// Valida que se haya colocado el dominio en el usuario
                //// if (!model.UserName.Contains("\\")) return Ok("-2");

                //--------------------------------------------------------------------
                // resultado = resultado + "validacion realizada " + Environment.NewLine;
                //--------------------------------------------------------------------

                //// string strServer = model.UserName.Split('\\')[0];
                string strServer = ConfigurationManager.AppSettings.Get("Domain").ToLower();

                //-----------------------------------------------------------------------
                ////resultado = resultado + "Servidor : " + strServer + Environment.NewLine;
                //-----------------------------------------------------------------------

                //// Valida que la solicitud sea al servidor del ministerio
                //// if (strServer.ToLower() != ConfigurationManager.AppSettings.Get("Domain").ToLower()) return Ok(string.Empty);

                //----------------------------------------------------------------------------------------
                // resultado = resultado + "Valido el servidor con el del webconfig " + Environment.NewLine;
                //----------------------------------------------------------------------------------------

                //// Obtiene el usuario y el password
                string strPass = model.Password;
                ////string strUser = model.UserName.Split('\\')[1];
                string strUser = model.UserName;

                //--------------------------------------------------------------------------------------------------------------------
                ////resultado = resultado + "Usuario : " + strUser + Environment.NewLine + "Password : " + "***********" + Environment.NewLine;
                ////Aplicacion.Excepciones.ManagerException.RegistraErrorBlockNotas(new Exception(resultado));
                //--------------------------------------------------------------------------------------------------------------------

                //// Valida la autenticación
                if (IsAuthenticated(strServer, strUser, strPass))
                {
                    //------------------------------------------------------------------------------------
                    ////resultado = resultado + "Está autenticado : " + true.ToString() + Environment.NewLine;
                    //------------------------------------------------------------------------------------

                    IEnumerable<C_Usuario_Result> result = Enumerable.Empty<C_Usuario_Result>();

                    //// Valida si el usuario esta en la base de datos
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        result = BD.C_Usuario(null, null, null, null, null, strUser, null).Cast<C_Usuario_Result>().ToList();
                    }

                    //--------------------------------------------------------------------------------------------
                    ////resultado = resultado + "Consulta de BD a Usuarios : " + result.Count() + Environment.NewLine;
                    //--------------------------------------------------------------------------------------------

                    if (result.Count() > 0)
                    {
                        var accessTokenResponse = GenerateLocalAccessTokenResponse(result.First().UserName);
                        (new AuditExecuted(Category.InicioSesionAD)).ActionExecutedManual(model);
                        return Ok(accessTokenResponse);
                    }
                    else
                    {
                        //-----------------------------------------------------------------------------------------
                        ////resultado = resultado + Environment.NewLine + "No encontró al usuario en el RUSICST";
                        ////Aplicacion.Excepciones.ManagerException.RegistraErrorBlockNotas(new Exception(resultado));
                        //-----------------------------------------------------------------------------------------

                        ////-------------------------------------------------------------------
                        //// Este error corresponde a que no encontró al usuario en el RUSICST
                        ////-------------------------------------------------------------------
                        (new AuditExecuted(Category.InicioSesiónErrorAD)).ActionExecutedManual(model);
                        return Ok("-1");
                    }
                }
                else
                {
                    //-------------------------------------------------------------------------------------
                    ////resultado = resultado + "Está autenticado : " + false.ToString() + Environment.NewLine;
                    ////resultado = resultado + Environment.NewLine + "No encontró al usuario en el DOMINIO";
                    ////Aplicacion.Excepciones.ManagerException.RegistraErrorBlockNotas(new Exception(resultado));
                    //-------------------------------------------------------------------------------------

                    ////-------------------------------------------------------------------
                    //// Este error corresponde a que no encontró al usuario en el DOMINIO
                    ////-------------------------------------------------------------------
                    (new AuditExecuted(Category.InicioSesiónErrorAD)).ActionExecutedManual(model);
                    return Ok("-2");
                }
            }
            catch (DirectoryServicesCOMException cex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.UserName, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(cex));
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.UserName, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return Ok(string.Empty);
        }

        #region Utilitarios

        /// <summary>
        /// Gets the error result.
        /// </summary>
        /// <param name="result">The result.</param>
        /// <returns>IHttpActionResult.</returns>
        private IHttpActionResult GetErrorResult(IdentityResult result)
        {
            if (result == null)
            {
                return InternalServerError();
            }

            if (!result.Succeeded)
            {
                if (result.Errors != null)
                {
                    foreach (string error in result.Errors)
                    {
                        ModelState.AddModelError("", error);
                    }
                }

                if (ModelState.IsValid)
                {
                    // No ModelState errors are available to send, so just return an empty BadRequest.
                    return BadRequest();
                }

                return BadRequest(ModelState);
            }

            return null;
        }

        /// <summary>
        /// Obteners the solicitud.
        /// </summary>
        /// <param name="Token">The token.</param>
        /// <returns>C_Usuario_Result.</returns>
        private C_Usuario_Result ObtenerSolicitud(Guid Token)
        {
            C_Usuario_Result retorno = null;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                List<C_Usuario_Result> listaSolicitudes = BD.C_Usuario(null, Token, null, null, null, null, null).ToList();

                if (listaSolicitudes.Count() > 0)
                {
                    retorno = listaSolicitudes.FirstOrDefault();
                }
            }

            return retorno;
        }

        public JObject TokenResponse(string userName)
        {
            return GenerateLocalAccessTokenResponse(userName);
        }

        /// <summary>
        /// Generates the local access token response.
        /// </summary>
        /// <param name="userName">Name of the user.</param>
        /// <returns>JObject.</returns>
        private JObject GenerateLocalAccessTokenResponse(string userName)
        {
            var tokenExpiration = TimeSpan.FromDays(1);

            ClaimsIdentity identity = new ClaimsIdentity(OAuthDefaults.AuthenticationType);

            identity.AddClaim(new Claim(ClaimTypes.Name, userName));
            identity.AddClaim(new Claim("role", "user"));

            var props = new AuthenticationProperties()
            {
                IssuedUtc = DateTime.UtcNow,
                ExpiresUtc = DateTime.UtcNow.Add(tokenExpiration),
            };

            var ticket = new AuthenticationTicket(identity, props);

            var accessToken = Startup.OAuthBearerOptions.AccessTokenFormat.Protect(ticket);

            JObject tokenResponse = new JObject(
                                        new JProperty("userName", userName),
                                        new JProperty("access_token", accessToken),
                                        new JProperty("token_type", "bearer"),
                                        new JProperty("expires_in", tokenExpiration.TotalSeconds.ToString()),
                                        new JProperty(".issued", ticket.Properties.IssuedUtc.ToString()),
                                        new JProperty(".expires", ticket.Properties.ExpiresUtc.ToString())
            );

            return tokenResponse;
        }

        /// <summary>
        /// Determines whether the specified SRVR is authenticated.
        /// </summary>
        /// <param name="srvr">The SRVR.</param>
        /// <param name="usr">The usr.</param>
        /// <param name="pwd">The password.</param>
        /// <returns><c>true</c> if the specified SRVR is authenticated; otherwise, <c>false</c>.</returns>
        private bool IsAuthenticated(string srvr, string usr, string pwd)
        {
            bool authenticated = false;

            //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            string resultado = "Validando el método IsAuthenticate" + Environment.NewLine + "Servidor : " + srvr + Environment.NewLine + "Usuario : " + usr + Environment.NewLine + "Password : " + pwd;
            //-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            using (var pc = new PrincipalContext(ContextType.Domain, srvr))
            {
                authenticated = pc.ValidateCredentials(usr, pwd);
            }

            //-----------------------------------------------------------------------------------------------------
            resultado = resultado + Environment.NewLine + "Autenticado : " + authenticated;
            resultado = resultado + Environment.NewLine + "Terminó el método IsAuthenticate: ";
            RusicstMVC.Aplicacion.Excepciones.ManagerException.RegistraErrorBlockNotas(new Exception(resultado));
            //-----------------------------------------------------------------------------------------------------

            return authenticated;
        }

        #endregion
    }
}