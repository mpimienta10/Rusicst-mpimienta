// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-29-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-18-2017
// ***********************************************************************
// <copyright file="UsuariosEnSistemaController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************
/// <summary>
/// The Informes namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Informes
{
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Entidades;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class UsuariosEnSistemaController.
    /// </summary>
    [Authorize]
    public class UsuariosEnSistemaController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>IEnumerable&lt;C_UsuariosEnSistema_Result&gt;.</returns>
        [Route("api/Informes/UsariosEnSistema/")]
        public IEnumerable<C_UsuariosEnSistema_Result> Get()
        {
            IEnumerable<C_UsuariosEnSistema_Result> resultado = Enumerable.Empty<C_UsuariosEnSistema_Result>(); 

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_UsuariosEnSistema().Cast<C_UsuariosEnSistema_Result>().ToList();
                }

            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }
    }
}