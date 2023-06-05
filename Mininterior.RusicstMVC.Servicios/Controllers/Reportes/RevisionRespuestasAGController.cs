// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-03-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-18-2017
// ***********************************************************************
// <copyright file="RevisionRespuestasAGController.cs" company="Ministerio del Interior">
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
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class RevisionRespuestasAGController.
    /// </summary>
    [Authorize]
    public class RevisionRespuestasAGController : ApiController
    {
        /// <summary>
        /// Gets the specified username.
        /// </summary>
        /// <param name="username">nombre del usuario.</param>
        /// <returns>Lista C_RespuestasEncuestaXUsuario_Result</returns>
        [Route("api/Reportes/RevisionRespuestasAG/")]
        public IEnumerable<C_RespuestasEncuesta_Result> Get(int idmunicipio)
        {
            IEnumerable<C_RespuestasEncuesta_Result> resultado = Enumerable.Empty<C_RespuestasEncuesta_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_RespuestasEncuesta(idMunicipio: idmunicipio).Cast<C_RespuestasEncuesta_Result>().ToList();
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