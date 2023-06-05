// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 01-19-2017
//
// ***********************************************************************
// <copyright file="UsuariosGuardaronInformacionSistemaController.cs" company="Ministerio del Interior">
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
    /// Class UsuariosGuardaronInformacionSistemaController.
    /// </summary>
    [Authorize]
    public class UsuariosIniciarionSesionController : ApiController
    {
        /// <summary>
        /// Gets the specified identifier.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>IEnumerable&lt;C_UsuariosGuardaronInformacionSistema_Result&gt;.</returns>
        [Route("api/Informes/UsuariosIniciaronSesionSistema/{id}")]
        public IEnumerable<C_ConsultaInicioSesion_Result> Get(int id)
        {
            IEnumerable<C_ConsultaInicioSesion_Result> resultado = Enumerable.Empty<C_ConsultaInicioSesion_Result>(); ;
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 3600;
                    resultado = BD.C_ConsultaInicioSesion(id).Cast<C_ConsultaInicioSesion_Result>().ToList(); ;
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