// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-29-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-18-2017
// ***********************************************************************
// <copyright file="UsuariosGuardaronInformacionAutoevaluacionController.cs" company="Ministerio del Interior">
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
    /// Class UsuariosGuardaronInformacionAutoevaluacionController.
    /// </summary>
    [Authorize]
    public class UsuariosGuardaronInformacionAutoevaluacionController : ApiController
    {
        /// <summary>
        /// Gets the specified identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>IEnumerable&lt;C_UsuariosGuardaronInformacionAutoevaluacion_Result&gt;.</returns>
        [Route("api/Informes/UsariosGuardaronInformacionAutoevaluacion/{id}")]
        public IEnumerable<C_UsuariosGuardaronInformacionAutoevaluacion_Result> Get(int id)
        {
            IEnumerable<C_UsuariosGuardaronInformacionAutoevaluacion_Result> resultado = Enumerable.Empty<C_UsuariosGuardaronInformacionAutoevaluacion_Result>(); ;
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 3600;
                    resultado = BD.C_UsuariosGuardaronInformacionAutoevaluacion(id).Cast<C_UsuariosGuardaronInformacionAutoevaluacion_Result>().ToList(); ;
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