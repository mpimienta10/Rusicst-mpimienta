// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo - OIM
// Created          : 04-29-2017
//
// Last Modified By : Equipo de desarrollo - OIM
// Last Modified On : 06-17-2017
// ***********************************************************************
// <copyright file="OpcionesRolController.cs" company="Ministerio del Interior">
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
    /// Class OpcionesRolController.
    /// </summary>
    [Authorize]
    public class OpcionesRolController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>IEnumerable C_OpcionesRol_Result.</returns>
        [Route("api/Informes/OpcionesRol/")]
        public IEnumerable<C_OpcionesTipoUsuario_Result> Get()
        {
            IEnumerable<C_OpcionesTipoUsuario_Result> resultado = Enumerable.Empty<C_OpcionesTipoUsuario_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_OpcionesTipoUsuario().Cast<C_OpcionesTipoUsuario_Result>().ToList();
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