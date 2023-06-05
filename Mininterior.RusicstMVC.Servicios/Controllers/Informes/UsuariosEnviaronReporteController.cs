// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-29-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-18-2017
// ***********************************************************************
// <copyright file="UsuariosEnviaronReporteController.cs" company="Ministerio del Interior">
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
    /// Class UsuariosEnviaronReporteController.
    /// </summary>
    [Authorize]
    public class UsuariosEnviaronReporteController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>System.String.</returns>
        public string Get()
        {
            return "Debe especificar una encuesta para poder obtener el resultado";
        }

        /// <summary>
        /// Gets the specified identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>IEnumerable&lt;C_UsuariosEnviaronReporte_Result&gt;.</returns>
        [Route("api/Informes/UsariosEnviaronReporte/{id}")]
        public IEnumerable<C_UsuariosEnviaronReporte_Result> Get(int id)
        {
            IEnumerable<C_UsuariosEnviaronReporte_Result> resultado = Enumerable.Empty<C_UsuariosEnviaronReporte_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_UsuariosEnviaronReporte(id).Cast<C_UsuariosEnviaronReporte_Result>().ToList();
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