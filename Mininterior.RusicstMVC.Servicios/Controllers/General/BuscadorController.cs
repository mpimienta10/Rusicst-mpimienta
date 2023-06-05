// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM - Mauricio Ospina
// Created          : 12-02-2017
//
// Last Modified By : Equipo de desarrollo OIM - Mauricio Ospina
// Last Modified On : 12-02-2017
// ***********************************************************************
// <copyright file="BuscadorController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************
/// <summary>
/// The General namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.General
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
    /// Class UsuariosEnSistemaController.
    /// </summary>
    [Authorize]
    public class BuscadorController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Lista con los resultados de la búsqueda</returns>
        [Route("api/General/Buscador/")]
        public IEnumerable<C_Buscador_Result> Get(string textoBusqueda, string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_Buscador_Result> resultado = Enumerable.Empty<C_Buscador_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 3600;
                    resultado = BD.C_BuscadorBI(textoBusqueda, audUserName).Cast<C_Buscador_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }
    }
}