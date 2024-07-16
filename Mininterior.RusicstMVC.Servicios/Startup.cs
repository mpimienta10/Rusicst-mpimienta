// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-06-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-06-2017
// ***********************************************************************
// <copyright file="Startup.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

using Microsoft.Owin;
[assembly: OwinStartup(typeof(Mininterior.RusicstMVC.Servicios.Startup))]
namespace Mininterior.RusicstMVC.Servicios
{
    using Mininterior.RusicstMVC.Servicios.Providers;
    using Microsoft.Owin.Security.OAuth;
    using Owin;
    using System;
    using System.Web.Http;

    /// <summary>
    /// Clase Startup.
    /// </summary>
    public class Startup
    {
        /// <summary>
        /// Gets the o authentication bearer options.
        /// </summary>
        /// <value>The o authentication bearer options.</value>
        public static OAuthBearerAuthenticationOptions OAuthBearerOptions { get; private set; }

        /// <summary>
        /// Configurations the specified application.
        /// </summary>
        /// <param name="app">The application.</param>
        public void Configuration(IAppBuilder app)
        {
            HttpConfiguration config = new HttpConfiguration();

            ConfigureOAuth(app);

            WebApiConfig.Register(config);

            var corsPolicy = new System.Web.Cors.CorsPolicy
            {
                AllowAnyMethod = true,
                AllowAnyHeader = true
            };

            corsPolicy.AllowAnyOrigin = true;

            var corsOptions = new Microsoft.Owin.Cors.CorsOptions
            {
                PolicyProvider = new Microsoft.Owin.Cors.CorsPolicyProvider
                {
                    PolicyResolver = context => System.Threading.Tasks.Task.FromResult(corsPolicy)
                }
            };

            app.UseCors(corsOptions);
            app.UseWebApi(config);
        }

        /// <summary>
        /// Configures the o authentication.
        /// </summary>
        /// <param name="app">The application.</param>
        public void ConfigureOAuth(IAppBuilder app)
        {
            //// Utilice una cookie para almacenar temporalmente información acerca de un usuario que 
            //// inicie sesión con un proveedor de acceso de terceros
            app.UseExternalSignInCookie(Microsoft.AspNet.Identity.DefaultAuthenticationTypes.ExternalCookie);
            OAuthBearerOptions = new OAuthBearerAuthenticationOptions();

            OAuthAuthorizationServerOptions oAuthServerOptions = new OAuthAuthorizationServerOptions()
            {
                AllowInsecureHttp = true,
                TokenEndpointPath = new PathString("/token"),
                AccessTokenExpireTimeSpan = TimeSpan.FromMinutes(300),
                Provider = new SimpleAuthorizationServerProvider()
            };

            //// Generacion de Token
            app.UseOAuthAuthorizationServer(oAuthServerOptions);
            app.UseOAuthBearerAuthentication(OAuthBearerOptions);
        }
    }
}