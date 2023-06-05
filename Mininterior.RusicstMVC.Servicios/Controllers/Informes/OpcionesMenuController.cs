// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo - OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo - OIM
// Last Modified On : 05-18-2017
// ***********************************************************************
// <copyright file="OpcionesMenuController.cs" company="Ministerio del Interior">
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
    /// Class OpcionesMenuController.
    /// </summary>
    [Authorize]
    public class OpcionesMenuController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con las opciones del menú</returns>
        [Route("api/Informes/OpcionesMenu/")]
        public IEnumerable<C_OpcionesMenu_Result> Get()
        {
            IEnumerable<C_OpcionesMenu_Result> resultado = Enumerable.Empty<C_OpcionesMenu_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_OpcionesMenu().Cast<C_OpcionesMenu_Result>().ToList();
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