// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 07-15-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 07-15-2017
// ***********************************************************************
// <copyright file="SalidaInformacionGobernacionController.cs" company="Ministerio del Interior">
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
    /// Class SalidaInformacionGobernacionController.
    /// </summary>
    [Authorize]
    public class SalidaInformacionGobernacionController : ApiController
    {

        /// <summary>
        /// Gets the specified identifier encuesta.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>LIsta de C_ReporteConsolidadoDetalle_Result</returns>
        [HttpPost]
        [Route("api/Informes/SalidaInformacionGobernacion/")]
        public IEnumerable<C_Salida_Gobernacion_Result> getSalidaInformacionGobernacion(BuscarEncuestaModels model)
        {
            IEnumerable<C_Salida_Gobernacion_Result> resultado = Enumerable.Empty<C_Salida_Gobernacion_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 3600;
                    resultado = BD.C_Salida_Gobernacion(model.idDepartamento, model.idEncuesta).Cast<C_Salida_Gobernacion_Result>().ToList();
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