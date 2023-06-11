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
        [AllowAnonymous]
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
                    if (keyPrivada.Any())
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
            JObject Token = new JObject();
            string userName = "", userNameAspNetUsers = "";

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
                }

                const string HeaderIdentifyName = "X-IDENTIFY";
                bool isValueExist = Request.Headers.TryGetValues(HeaderIdentifyName, out var values);
                if (isValueExist && values.FirstOrDefault() != null)
                {
                    decryptIdentify = Utilidades.Encrypt.Decrypt(keyPrivada, values.FirstOrDefault());
                    XIdentify xidentify = new XIdentify();
                    //var json = JsonConvert.SerializeObject(decryptIdentify);
                    var obj = JsonConvert.DeserializeObject<XIdentify>(decryptIdentify);
                    externalAccess.role = obj.role.Replace(" ", "_");
                    externalAccess.departamento = obj.departamento.Replace(" ", "_");
                    externalAccess.municipio = obj.municipio.Replace(" ", "_");

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
                                Resultado = BD.U_UsuarioUpdate(null, null, model.IdTipoUsuario, null, null, null, null, model.UserName, model.Nombres, null, null, null,
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
                                    Resultado = BD.I_UsuarioInsert(8, 5001, (int)EstadoSolicitud.Solicitada, model.Nombres, model.Cargo, model.TelefonoFijo,
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
                            }
                            catch (Exception ex)
                            {
                                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                            }
                        }
                    }
                    // se genera el Token para X-IDENTIFY
                    Token = GenerateLocalAccessTokenResponse(values.FirstOrDefault());
                    //crear SPs a partir de la tabla AspNetUsers y actualizar o crear la data en la tabla [dbo].[Usuario]
                    //Enviar el token con la data encriptada de X-IDENTIFY y url de rusicst
                    //Crear endpoint de validacion de token donde se llama el endpoint de GenerateLocalAccessTokenResponse
                    //GrantResourceOwnerCredentials - ObtainLocalAccessToken

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

        /// <summary>
        /// Generates the local access token response for X-IDENTIFY.
        /// </summary>
        /// <param name="xidentify">Encript of X-IDENTIFY.</param>
        /// <returns>JObject.</returns>
        private JObject GenerateLocalAccessTokenResponse(string xidentify)
        {
            var tokenExpiration = TimeSpan.FromDays(1);

            ClaimsIdentity identity = new ClaimsIdentity(OAuthDefaults.AuthenticationType);

            identity.AddClaim(new Claim(ClaimTypes.Name, xidentify));
            identity.AddClaim(new Claim("role", "user"));

            var props = new AuthenticationProperties()
            {
                IssuedUtc = DateTime.UtcNow,
                ExpiresUtc = DateTime.UtcNow.Add(tokenExpiration),
            };

            var ticket = new AuthenticationTicket(identity, props);

            var accessToken = Startup.OAuthBearerOptions.AccessTokenFormat.Protect(ticket);

            JObject tokenResponse = new JObject(
                                        new JProperty("X-IDENTIFY", xidentify),
                                        new JProperty("access_token", accessToken),
                                        new JProperty("token_type", "bearer"),
                                        new JProperty("expires_in", tokenExpiration.TotalSeconds.ToString()),
                                        new JProperty(".issued", ticket.Properties.IssuedUtc.ToString()),
                                        new JProperty(".expires", ticket.Properties.ExpiresUtc.ToString())
            );

            return tokenResponse;
        }
    }
}