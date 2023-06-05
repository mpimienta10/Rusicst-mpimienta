// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-03-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 08-15-2017
// ***********************************************************************
// <copyright file="GlosarioController.cs" company="Ministerio del Interior">
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
    /// Class GlosarioController.
    /// </summary>
    [Authorize]
    public class GlosarioController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>IEnumerable&lt;C_GlosarioConsultar_Result&gt;.</returns>
        [Route("api/Reportes/Glosario/")]
        public IEnumerable<C_GlosarioConsultar_Result> Get()
        {
            IEnumerable<C_GlosarioConsultar_Result> resultado = Enumerable.Empty<C_GlosarioConsultar_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_GlosarioConsultar(clave: null, termino: null, descripcion: null).Cast<C_GlosarioConsultar_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the specified clave.
        /// </summary>
        /// <param name="clave">The clave.</param>
        /// <returns>IEnumerable&lt;C_GlosarioConsultar_Result&gt;.</returns>
        [Route("api/Reportes/Glosario/{clave}")]
        public IEnumerable<C_GlosarioConsultar_Result> Get(string clave)
        {
            IEnumerable<C_GlosarioConsultar_Result> resultado = Enumerable.Empty<C_GlosarioConsultar_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_GlosarioConsultar(clave: clave, termino: null, descripcion: null).Cast<C_GlosarioConsultar_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modificars the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.EditarGlosario)]
        [Route("api/Reportes/Glosario/Modificar/")]
        public C_AccionesResultado Modificar(GlosarioFilteredParams model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.U_GlosarioUpdate(clave: model.Clave, termino: model.Termino, descripcion: model.Descripcion).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Insertars the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.CrearGlosario)]
        [Route("api/Reportes/Glosario/Insertar/")]
        public C_AccionesResultado Insertar(GlosarioFilteredParams model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.I_GlosarioInsert(clave: model.Clave, termino: model.Termino, descripcion: model.Descripcion).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Eliminars the specified clave.
        /// </summary>
        /// <param name="Clave">The clave.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.EliminarGlosario)]
        [Route("api/Reportes/Glosario/Eliminar/")]
        public C_AccionesResultado Eliminar(GlosarioFilteredParams model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_GlosarioDelete(model.Clave).FirstOrDefault();
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