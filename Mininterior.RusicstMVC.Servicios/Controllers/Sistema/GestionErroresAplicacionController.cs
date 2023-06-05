// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-01-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-25-2017
// ***********************************************************************
// <copyright file="GestionErroresAplicacionController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Sistema namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Sistema
{
    using Entidades;
    using Models;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class GestionErroresAplicacionController.
    /// </summary>
    [Authorize]
    public class GestionErroresAplicacionController : ApiController
    {
        /// <summary>
        /// Gets all.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>IEnumerable&lt;C_LogXExcepcion_Result&gt;.</returns>
        [HttpPost]
        [Route("api/Sistema/LogXExcepcion/")]
        public IEnumerable<C_LogXExcepcion_Result> GetAll(LogFiltroModels model)
        {
            IEnumerable<C_LogXExcepcion_Result> resultado = Enumerable.Empty<C_LogXExcepcion_Result>();

            try
            {
                using (EntitiesRusicstLog BD = new EntitiesRusicstLog())
                {
                    resultado = BD.C_LogXExcepcion(model.FechaInicio.Date, model.FechaFin.Add(DateTime.MaxValue.TimeOfDay)).Cast<C_LogXExcepcion_Result>().ToList();
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

            return resultado;
        }
    }
}