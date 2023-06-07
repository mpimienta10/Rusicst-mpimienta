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
    public class VivantoController : ApiController
    {
        /// <summary>
        /// The _repo
        /// </summary>
        private AuthRepository _repo = null;

        /// <summary>
        /// Initializes a new instance of the <see cref="VivantoController" /> class.
        /// </summary>
        public VivantoController()
        {
            _repo = new AuthRepository();
        }
    }
}