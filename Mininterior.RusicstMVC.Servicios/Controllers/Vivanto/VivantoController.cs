// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo
// Created          : 07-06-2023
// ***********************************************************************
// <copyright file="VivantoController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Vivanto namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Vivanto
{
    using Aplicacion.Seguridad;
    using Microsoft.AspNet.Identity;
    using Microsoft.Owin.Security;
    using Microsoft.Owin.Security.OAuth;
    using Mininterior.RusicstMVC.Aplicacion;
    using Mininterior.RusicstMVC.Entidades;
    using Mininterior.RusicstMVC.Servicios.Entities.DTO;
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
    using Newtonsoft.Json;
    using Microsoft.AspNet.Identity.EntityFramework;
    using System.Net.Http;
    using Mininterior.RusicstMVC.Servicios.Controllers.Usuarios;
    using System.Text;
    using System.Net;

    public class VivantoController : ApiController
    {
        /// <summary>
        /// The _repo
        /// </summary>
        private AuthRepository _repo = null;
        private string keyPrivada = "";

        /// <summary>
        /// Initializes a new instance of the <see cref="VivantoController" /> class.
        /// </summary>
        public VivantoController()
        {
            _repo = new AuthRepository();
        }


        /// <summary>
        /// Obtener usuarios activos
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_GetUserActives.</returns>
        [JwtAuthentication]
        [HttpGet]
        [Route("api/v1/active-users")]
        public async Task<IHttpActionResult> UserActives()
        {
            try
            {
                const string HeaderKeyName = "X-KEY";
                bool isValueExistKey = Request.Headers.TryGetValues(HeaderKeyName, out var value);
                if (isValueExistKey && value.FirstOrDefault() != null)
                {
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 120;
                        keyPrivada = BD.C_LeerCrypts(value.FirstOrDefault()).FirstOrDefault().keyPrivate;
                    }
                    if (!keyPrivada.Any())
                        return Ok("No se encontro key valida en el header.");
                    List<ActiveUserVIvanto> result = await _repo.GetAllUserActives();
                    return Ok(result);
                }
                else
                {
                    return Ok("No se encontro key valida en el header.");
                }
            }
            catch (Exception ex)
            {
                return Ok(ex);
            }
        }

        /// <summary>
        /// Verificar token jwt y retornar token rusicts
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>JObject</returns>
        [JwtAuthentication]
        [HttpPost]
        [Route("api/v1/verify-access/")]
        public async Task<HttpResponseMessage> ExternalVerifyAsync()
        {
            HttpResponseMessage response;

            try
            {

                var user = this.User.Identity.Name;
                var auth = new AutenticacionController();

                response = Request.CreateResponse(HttpStatusCode.OK);

                response.Content = new StringContent(new JObject(
                     new JProperty("estado", true),
                     new JProperty("token", auth.TokenResponse(user))
                ).ToString(), Encoding.UTF8, "application/json");

                return response;
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                response = Request.CreateResponse(HttpStatusCode.InternalServerError);
                response.Content = new StringContent(new JObject(
                     new JProperty("estado", false),
                     new JProperty("message", "Error")
                ).ToString(), Encoding.UTF8, "application/json");

                return response;
            }
        }


        /// <summary>
        /// Obtener usuarios activos
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>JObject</returns>
        [AllowAnonymous]
        [HttpPost]
        [Route("api/v1/token-jwt/")]
        public async Task<HttpResponseMessage> GenerateTokenJwtAsync()
        {
            HttpResponseMessage response;
            var decryptIdentify = "";
            JObject Token = new JObject();
            string userNameAspNetUsers = "";

            try
            {

                const string HeaderKeyName = "X-KEY";
                bool isValueExistKey = Request.Headers.TryGetValues(HeaderKeyName, out var value);
                if (isValueExistKey && value.FirstOrDefault() != null)
                {
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 120;
                        keyPrivada = BD.C_LeerCrypts(value.FirstOrDefault()).FirstOrDefault().keyPrivate;
                    }
                    if (String.IsNullOrEmpty(keyPrivada))
                    {

                        response = Request.CreateResponse(HttpStatusCode.OK);

                        response.Content = new StringContent(new JObject(
                             new JProperty("estado", true),
                             new JProperty("token", "No se encontro key valida en el header.")
                        ).ToString(), Encoding.UTF8, "application/json");

                        return response;
                    }
                }

                const string HeaderIdentifyName = "X-IDENTIFY";
                bool isValueExist = Request.Headers.TryGetValues(HeaderIdentifyName, out var values);
                if (isValueExist && values.FirstOrDefault() != null)
                {
                    decryptIdentify = Utilidades.Encrypt.Decrypt(keyPrivada, values.FirstOrDefault());
                    XIdentify xidentify = new XIdentify();
                    //var json = JsonConvert.SerializeObject(decryptIdentify);
                    var obj = JsonConvert.DeserializeObject<XIdentify>(decryptIdentify);
                    var role = obj.role.Replace(" ", "_").ToLower();
                    var departamento = obj.departamento.Replace(" ", "_").ToLower();
                    var municipio = obj.municipio.Replace(" ", "_").ToLower();

                    userNameAspNetUsers = $"{role}_{municipio}_{departamento}";
                    using (AuthRepository _repo = new AuthRepository())
                    {
                        IdentityUser user = await _repo.FindByName(userNameAspNetUsers);

                        if (user != null)
                        {

                            response = Request.CreateResponse(HttpStatusCode.OK);

                            response.Content = new StringContent(new JObject(
                                 new JProperty("estado", true),
                                 new JProperty("token", JwtManager.GenerateToken(userNameAspNetUsers))
                            ).ToString(), Encoding.UTF8, "application/json");

                            return response;
                        }


                        response = Request.CreateResponse(HttpStatusCode.NotFound);

                        response.Content = new StringContent(new JObject(
                             new JProperty("estado", false),
                             new JProperty("message", "Usuario no encontrado")
                        ).ToString(), Encoding.UTF8, "application/json");

                        return response;

                    }

                }

                response = Request.CreateResponse(HttpStatusCode.Unauthorized);

                response.Content = new StringContent(new JObject(
                     new JProperty("estado", false),
                     new JProperty("message", "Unauthorized")
                ).ToString(), Encoding.UTF8, "application/json");

                return response;

            }
            catch (Exception ex)
            {

                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                response = Request.CreateResponse(HttpStatusCode.InternalServerError);
                response.Content = new StringContent(new JObject(
                     new JProperty("estado", false),
                     new JProperty("message", "Error")
                ).ToString(), Encoding.UTF8, "application/json");

                return response;
            }
        }


        /// <summary>
        /// Obtener acceso externo con usuario de VIVANTO
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>JObject</returns>
        [AllowAnonymous]
        [HttpPost]
        [Route("api/v1/external-access/")]
        public async Task<JObject> ExternalAccessAsync([FromBody] ExternalAccess externalAccess)
        {
            var decryptIdentify = "";
            string Token = "";
            string userNameAspNetUsers = "";

            try
            {
                const string HeaderKeyName = "X-KEY";
                bool isValueExistKey = Request.Headers.TryGetValues(HeaderKeyName, out var value);
                if (isValueExistKey && value.FirstOrDefault() != null)
                {
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 120;
                        keyPrivada = BD.C_LeerCrypts(value.FirstOrDefault()).FirstOrDefault().keyPrivate;
                    }
                    if (String.IsNullOrEmpty(keyPrivada))
                    {
                        JObject jsonError = new JObject(
                                                new JProperty("estado", false),
                                                new JProperty("message", "No se encontro key valida en el header.")
                           );
                        return jsonError;
                    }
                }

                const string HeaderIdentifyName = "X-IDENTIFY";
                bool isValueExist = Request.Headers.TryGetValues(HeaderIdentifyName, out var values);
                if (isValueExist && values.FirstOrDefault() != null)
                {
                    decryptIdentify = Utilidades.Encrypt.Decrypt(keyPrivada, values.FirstOrDefault());
                    XIdentify xidentify = new XIdentify();
                    //var json = JsonConvert.SerializeObject(decryptIdentify);
                    var obj = JsonConvert.DeserializeObject<XIdentify>(decryptIdentify);
                    externalAccess.role = obj.role.Replace(" ", "_").ToLower();
                    externalAccess.departamento = obj.departamento.Replace(" ", "_").ToLower();
                    externalAccess.municipio = obj.municipio.Replace(" ", "_").ToLower();

                    //Se eliminan las tildes y caracteres especiales
                    externalAccess.departamento = Regex.Replace(externalAccess.departamento.Normalize(NormalizationForm.FormD), @"[^a-zA-z0-9 ]+", "");
                    externalAccess.municipio = Regex.Replace(externalAccess.municipio.Normalize(NormalizationForm.FormD), @"[^a-zA-z0-9 ]+", "");

                    userNameAspNetUsers = $"{externalAccess.role}_{externalAccess.municipio}_{externalAccess.departamento}";
                    using (AuthRepository _repo = new AuthRepository())
                    {
                        IdentityUser user = await _repo.FindByName(userNameAspNetUsers);

                        C_AccionesResultado Resultado = new C_AccionesResultado();
                        UsuariosModels model = new UsuariosModels();
                        model.UserName = userNameAspNetUsers;
                        model.Cargo = externalAccess.cargo;
                        model.Email = externalAccess.correo;
                        if (externalAccess.segundoNombre != null && externalAccess.segundoApellido != null)
                        {
                            model.Nombres = $"{externalAccess.primerNombre} {externalAccess.segundoNombre} {externalAccess.primerApellido} {externalAccess.segundoApellido}";
                        }
                        else if (externalAccess.segundoNombre != null && externalAccess.segundoApellido == null)
                        {
                            model.Nombres = $"{externalAccess.primerNombre} {externalAccess.segundoNombre} {externalAccess.primerApellido}";
                        }
                        else if (externalAccess.segundoNombre == null && externalAccess.segundoApellido != null)
                        {
                            model.Nombres = $"{externalAccess.primerNombre} {externalAccess.primerApellido} {externalAccess.segundoApellido}";
                        }
                        else
                        {
                            model.Nombres = $"{externalAccess.primerNombre} {externalAccess.primerApellido}";
                        }
                        model.Password = Guid.NewGuid().ToString();
                        model.Token = Guid.NewGuid();

                        if (user != null)
                        {
                            //actualizar el usuario
                            using (EntitiesRusicst BD = new EntitiesRusicst())
                            {
                                model.IdTipoUsuario = BD.C_ObtenerIdTipoUsuario("ENTIDAD").FirstOrDefault();
                                //// Trae el usuario al que se va actualizar
                                C_Usuario_Result Usuario = BD.C_Usuario(null, null, null, null, null, model.UserName, null).FirstOrDefault();
                                Resultado = BD.U_UsuarioUpdate(Usuario.Id, null, model.IdTipoUsuario, null, null, null, null, model.UserName, model.Nombres, model.Cargo, null, null,
                                                           null, null, model.Email, null, null, true, null, true, null, null, null, null, null, null,
                                                           null, null, null).FirstOrDefault();
                            }
                        }
                        else
                        {
                            //Crear el usuario en la tabla dbo.Usuario
                            try
                            {
                                //// Guardar los datos de solicitud de usuario
                                using (EntitiesRusicst BD = new EntitiesRusicst())
                                {
                                    int IdDepartamento = BD.C_ObtenerIdDepartamento("Bogotá").FirstOrDefault();
                                    int IdMunicipio = BD.C_ObtenerIdMunicipio("Bogotá").FirstOrDefault(); //obj.municipio
                                    Resultado = BD.I_UsuarioInsert(IdDepartamento, IdMunicipio, (int)EstadoSolicitud.Solicitada, model.Nombres, model.Cargo, model.TelefonoFijo,
                                                                   model.TelefonoFijoIndicativo, model.TelefonoFijoExtension, model.TelefonoCelular, model.Email,
                                                                   model.EmailAlternativo, model.Token, DateTime.Now, model.DocumentoSolicitud).FirstOrDefault();

                                    if (Resultado.estado > 0)
                                    {
                                        var resultController = new GestionarSolicitudesController().ConfirmarSolicitud(model);
                                        (new AuditExecuted(Category.CrearSolicitud)).ActionExecutedManual(model);
                                    }
                                    else
                                    {
                                        JObject jsonError = new JObject(
                                                                new JProperty("estado", false),
                                                                new JProperty("message", Resultado.respuesta)
                                           );
                                        return jsonError;
                                    }
                                }

                                //Crear el usuario en la tabla AspNetUsers
                                LoginModel loginModel = new Models.LoginModel() { Token = model.Token, Password = model.Password, UserName = model.UserName, Email = model.Email, Telefono = model.TelefonoFijo };
                                IdentityResult result = await _repo.RegisterUser(loginModel);

                                using (EntitiesRusicst BD = new EntitiesRusicst())
                                {
                                    model.IdTipoUsuario = BD.C_ObtenerIdTipoUsuario("ALCALDIA").FirstOrDefault();
                                    //// Trae el usuario al que se le va actualizar el IdTipoUsuario
                                    C_Usuario_Result Usuario = BD.C_Usuario(null, null, null, null, null, model.UserName, null).FirstOrDefault();
                                    BD.U_UsuarioUpdate(Usuario.Id, null, model.IdTipoUsuario, null, null, null, null, model.UserName, model.Nombres, model.Cargo, null, null,
                                                       null, null, model.Email, null, null, true, null, true, null, null, null, null, null, null,
                                                       null, null, null).FirstOrDefault();
                                }
                            }
                            catch (Exception ex)
                            {
                                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                            }
                        }
                    }
                    // se genera el Token para X-IDENTIFY
                    Token = JwtManager.GenerateToken(userNameAspNetUsers);
                }

                JObject jsonData = new JObject(
                                       new JProperty("estado", true),
                                       new JProperty("url", UtilGeneral.UrlLogin),
                                       new JProperty("token", Token)
                );

                return jsonData;
            }
            catch (Exception ex)
            {
                JObject jsonError = new JObject(
                                        new JProperty("estado", false),
                                        new JProperty("message", ex.Message)
                   );
                return jsonError;
            }
        }

    }
}