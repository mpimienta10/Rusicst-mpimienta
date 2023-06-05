// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-29-2017
// ***********************************************************************
// <copyright file="ConsolidadoDiligenciamientoController.cs" company="Ministerio del Interior">
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
    using Mininterior.RusicstMVC.Servicios.Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class ConsolidadoDiligenciamientoController.
    /// </summary>
    [Authorize]
    public class ConsolidadoDiligenciamientoController : ApiController
    {
        /// <summary>
        /// Gets the specified identifier encuesta.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>LIsta de C_ReporteConsolidadoDetalle_Result</returns>
        [Route("api/Informes/ConsolidadoDiligenciamientoDetalle/")]
        public IEnumerable<C_ReporteConsolidadoDetalle_Result> ConsolidadoDiligenciamientoDetalle(BuscarEncuestaModels model)
        {
            IEnumerable<C_ReporteConsolidadoDetalle_Result> resultado = Enumerable.Empty<C_ReporteConsolidadoDetalle_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 3600;
                    resultado = BD.C_ReporteConsolidadoDetalle(model.idDepartamento, model.idEncuesta).Cast<C_ReporteConsolidadoDetalle_Result>().ToList();
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