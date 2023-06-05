// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-29-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-18-2017
// ***********************************************************************
// <copyright file="UsuariosPasaronAutoevaluacionController.cs" company="Ministerio del Interior">
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
    /// Class UsuariosPasaronAutoevaluacionController.
    /// </summary>
    [Authorize]
    public class UsuariosPasaronAutoevaluacionController : ApiController
    {
        /// <summary>
        /// Gets the specified identifier encuesta.
        /// </summary>
        /// <param name="idEncuesta">The identifier encuesta.</param>
        /// <returns>Lista de UsuariosPasaronAutoevaluacion</returns>
        [Route("api/Informes/UsuariosPasaronAutoevaluacion/")]
        public IEnumerable<C_UsuariosPasaronAutoevaluacion_Result> Get(int idEncuesta)
        {
            IEnumerable<C_UsuariosPasaronAutoevaluacion_Result> resultado = Enumerable.Empty<C_UsuariosPasaronAutoevaluacion_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 3600;
                    resultado = BD.C_UsuariosPasaronAutoevaluacion(idEncuesta).Cast<C_UsuariosPasaronAutoevaluacion_Result>().ToList();
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