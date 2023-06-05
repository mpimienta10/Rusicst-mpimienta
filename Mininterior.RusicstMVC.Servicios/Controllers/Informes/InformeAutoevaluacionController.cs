// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-18-2017
// ***********************************************************************
// <copyright file="InformeAutoevaluacionController.cs" company="Ministerio del Interior">
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
    /// Class InformeAutoevaluacionController.
    /// </summary>
    [Authorize]
    public class InformeAutoevaluacionController : ApiController
    {
        /// <summary>
        /// Gets the specified identifier encuesta.
        /// </summary>
        /// <param name="idEncuesta">The identifier encuesta.</param>
        /// <param name="idDepartamento">The identifier departamento.</param>
        /// <param name="idMunicipio">The identifier municipio.</param>
        /// <returns>IEnumerable&lt;C_InformesAutoevaluacion_Result&gt;.</returns>
        [Route("api/Informes/InformeAutoevaluacion/")]
        public IEnumerable<C_InformesAutoevaluacion_Result> Get(int? idEncuesta, int? idDepartamento, int? idMunicipio)
        {
            IEnumerable<C_InformesAutoevaluacion_Result> resultado = Enumerable.Empty<C_InformesAutoevaluacion_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_InformesAutoevaluacion(idEncuesta, idDepartamento, idMunicipio).Cast<C_InformesAutoevaluacion_Result>().ToList();
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