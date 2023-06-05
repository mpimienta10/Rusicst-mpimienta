// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-29-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-06-2017
// ***********************************************************************
// <copyright file="SimpleAuthorizationServerProvider.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

namespace Mininterior.RusicstMVC.Servicios.Providers
{
    using Microsoft.AspNet.Identity.EntityFramework;
    using Microsoft.Owin.Security;
    using Microsoft.Owin.Security.OAuth;
    using System.Collections.Generic;
    using System.Linq;
    using System.Security.Claims;
    using System.Threading.Tasks;
    using Entidades;
    using Aplicacion;

    /// <summary>
    /// Clase SimpleAuthorizationServerProvider.
    /// </summary>
    public class SimpleAuthorizationServerProvider : OAuthAuthorizationServerProvider
    {
        /// <summary>
        /// Se llama para validar que el origen de la solicitud es un "client_id" registrado y que las credenciales correctas para ese cliente estan
        /// presentes en la solicitud. Si la aplicación web acepta credenciales de autenticación básica,
        /// context.TryGetBasicCredentials (out clientId, out clientSecret) puede ser llamado para adquirir esos valores si están presentes en el encabezado
        /// de la solicitud. Si la aplicación web acepta "client_id" y "client_secret" como forma de codificación POST parámetros,
        /// context.TryGetFormCredentials (out clientId, out clientSecret) puede ser llamado para adquirir esos valores si están presentes en el cuerpo de la solicitud.
        /// Si context.Validated no se llama, la petición no continuará.
        /// </summary>
        /// <param name="context">El contexto del evento transmite información y resultados.</param>
        /// <returns>Tarea para habilitar la ejecución asíncrona</returns>
        public override Task ValidateClientAuthentication(OAuthValidateClientAuthenticationContext context)
        {
            string clientId = string.Empty;
            string clientSecret = string.Empty;

            if (!context.TryGetBasicCredentials(out clientId, out clientSecret))
            {
                context.TryGetFormCredentials(out clientId, out clientSecret);
            }

            if (context.ClientId == null)
            {
                context.Validated();
                return Task.FromResult<object>(null);
            }

            return Task.FromResult<object>(null);
        }

        /// <summary>
        /// Se llama cuando una solicitud llega al end point Token con un "grant_type" de "password". Esto ocurre cuando el usuario ha proporcionado nombre y contraseña
        /// directamente en la interfaz de usuario de la aplicación cliente, y la aplicación cliente está utilizandolas para adquirir un "access_token" y
        /// opcional "refresh_token". Si la aplicación web admite las credenciales de propietario de recurso tipo de subvención que debe validar el contexto.Usuario y
        /// context.Password según corresponda. Emitir un token de acceso el context.
        /// Validated debe ser llamado con un nuevo ticket que contiene las afirmaciones sobre el propietario del recurso que debe ser asociado
        /// con el token de acceso. La aplicación debe tomar las medidas adecuadas para garantizar que el punto final no es abusado por los llamantes maliciosos.
        /// El comportamiento predeterminado es rechazar este tipo de subvención.
        /// Véase también http://tools.ietf.org/html/rfc6749#section-4.3.2
        /// </summary>
        /// <param name="context">El contexto del evento transmite información y resultados.</param>
        /// <returns>Tarea para habilitar la ejecución asíncrona</returns>
        public override async Task GrantResourceOwnerCredentials(OAuthGrantResourceOwnerCredentialsContext context)
        {
            var allowedOrigin = context.OwinContext.Get<string>("as:clientAllowedOrigin");

            if (allowedOrigin == null) allowedOrigin = "*";

            context.OwinContext.Response.Headers.Add("Access-Control-Allow-Origin", new[] { allowedOrigin });

            using (AuthRepository _repo = new AuthRepository())
            {
                //// Se realiza el ajuste al pass porque cuando va el caracter especial "+" el sistema lo interpreta como un espacio
                IdentityUser user = await _repo.FindUser(context.UserName, context.Password.Replace(' ', '+'));

                if (null != user)
                {
                    //// Valida que el usuario que se intenta autenticar esté aprobado
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        List<C_Usuario_Result> ListaUsuarios = BD.C_Usuario(null, null, null, null, null, user.UserName, null).ToList();

                        if (ListaUsuarios.Count() > 0)
                        {
                            C_Usuario_Result Usuario = BD.C_Usuario(null, null, null, null, null, user.UserName, null).First();
                            if (Usuario.IdEstado.Value != (int)EstadoSolicitud.Aprobada || !Usuario.Activo) return;
                        }
                        else return;
                    }
                }
                else
                {
                    context.SetError("invalid_grant", "The user name or password is incorrect.");
                    return;
                }
            }

            var identity = new ClaimsIdentity(context.Options.AuthenticationType);

            identity.AddClaim(new Claim(ClaimTypes.Name, context.UserName));
            identity.AddClaim(new Claim(ClaimTypes.Role, "user"));
            identity.AddClaim(new Claim("sub", context.UserName));

            var props = new AuthenticationProperties(new Dictionary<string, string>
                {
                    {
                        "as:client_id", (context.ClientId == null) ? string.Empty : context.ClientId
                    },
                    {
                        "userName", context.UserName
                    }
                });

            var ticket = new AuthenticationTicket(identity, props);

            context.Validated(ticket);
        }

        /// <summary>
        /// Se llama cuando una solicitud al punto final Token llega con un "grant_type" de "refresh_token". Esto ocurre si su aplicación ha emitido un "refresh_token"
        /// junto con el "access_token", y el cliente está intentando utilizar el "refresh_token" para adquirir un nuevo "access_token", y posiblemente un nuevo "refresh_token".
        /// Para emitir un token de actualización, se debe asignar un Options.RefreshTokenProvider para crear el valor devuelto. Las reivindicaciones y propiedades
        /// asociado con el token de actualización están presentes en el context.Ticket. La aplicación debe llamar a context.Validated para instruir a la
        /// Servidor de autorización de middleware para emitir un token de acceso basado en esas afirmaciones y propiedades. La llamada a context.Validated puede
        /// se le dará un AuthenticationTicket o ClaimsIdentity diferente para controlar qué información fluye desde el token de actualización a
        /// el token de acceso. El comportamiento predeterminado al utilizar el OAuthAuthorizationServerProvider es fluir información desde el token de actualización a
        /// el token de acceso no modificado.
        /// Véase también http://tools.ietf.org/html/rfc6749#section-6
        /// </summary>
        /// <param name="context">El contexto del evento transmite información y resultados.</param>
        /// <returns>Tarea para habilitar la ejecución asíncrona</returns>
        public override Task GrantRefreshToken(OAuthGrantRefreshTokenContext context)
        {
            var originalClient = context.Ticket.Properties.Dictionary["as:client_id"];
            var currentClient = context.ClientId;

            if (originalClient != currentClient)
            {
                context.SetError("invalid_clientId", "Refresh token is issued to a different clientId.");
                return Task.FromResult<object>(null);
            }

            //// Cambiar ticket de autenticación para las solicitudes de token de renovación
            var newIdentity = new ClaimsIdentity(context.Ticket.Identity);

            var newClaim = newIdentity.Claims.Where(c => c.Type == "newClaim").FirstOrDefault();
            if (newClaim != null)
            {
                newIdentity.RemoveClaim(newClaim);
            }
            newIdentity.AddClaim(new Claim("newClaim", "newValue"));

            var newTicket = new AuthenticationTicket(newIdentity, context.Ticket.Properties);
            context.Validated(newTicket);

            return Task.FromResult<object>(null);
        }

        /// <summary>
        /// Se llama en la etapa final de una solicitud de punto final de Token exitosa. Una aplicación puede implementar esta llamada para realizar cualquier
        /// modificación de las reivindicaciones que se utilizan para emitir tokens de acceso o actualización. Esta llamada también puede utilizarse para añadir
        /// parámetros de respuesta al cuerpo de respuesta json del punto final de Token.
        /// </summary>
        /// <param name="context">El contexto del evento transmite información y resultados.</param>
        /// <returns>Tarea para habilitar la ejecución asíncrona</returns>
        public override Task TokenEndpoint(OAuthTokenEndpointContext context)
        {
            foreach (KeyValuePair<string, string> property in context.Properties.Dictionary)
            {
                context.AdditionalResponseParameters.Add(property.Key, property.Value);
            }

            return Task.FromResult<object>(null);
        }
    }
}