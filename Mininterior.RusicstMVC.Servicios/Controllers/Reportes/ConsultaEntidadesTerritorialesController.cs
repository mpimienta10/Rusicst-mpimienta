// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-03-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 06-20-2017
// ***********************************************************************
// <copyright file="ConsultaEntidadesTerritorialesController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Reportes namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Reportes
{
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class ConsultaEntidadesTerritorialesController.
    /// </summary>
    [Authorize]
    public class ConsultaEntidadesTerritorialesController : ApiController
    {
        /// <summary>
        /// Gets the filtered.
        /// </summary>
        /// <param name="model">entidad model.</param>
        /// <returns>Lista C_ReportesXEntidadesTerritoriales_Result</returns>
        [HttpPost]
        [Route("api/Reportes/ConsultaEntidadesTerritoriales/GetFiltered")]
        public IEnumerable<C_ReportesXEntidadesTerritoriales_Result> GetFiltered([FromBody] FiltroDepartamentoMunicipio model)
        {
            IEnumerable<C_ReportesXEntidadesTerritoriales_Result> resultado = Enumerable.Empty<C_ReportesXEntidadesTerritoriales_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ReportesXEntidadesTerritoriales(idDepartamento: model.idDepartamento, idMunicipio: model.idMunicipio == 0 ? new Nullable<int>() : model.idMunicipio).Cast<C_ReportesXEntidadesTerritoriales_Result>().ToList();
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
