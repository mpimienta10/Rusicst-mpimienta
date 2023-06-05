// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 08-15-2017
// ***********************************************************************
// <copyright file="HabilitarReportesController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Usuarios namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Usuarios
{
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Entidades;
    using Mininterior.RusicstMVC.Aplicacion;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class HabilitarReportesController.
    /// </summary>
    [Authorize]
    public class HabilitarReportesController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>IEnumerable&lt;C_ObtenerExtensionesTiempo_Result&gt;.</returns>
        [Route("api/Usuarios/HabilitarReportes/")]
        public IEnumerable<C_ExtensionesTiempo_Result> Get(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_ExtensionesTiempo_Result> resultado = Enumerable.Empty<C_ExtensionesTiempo_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ExtensionesTiempo().Cast<C_ExtensionesTiempo_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Extiende el plazo de la encuesta.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [Route("api/Usuarios/HabilitarReportes/ExtenderPlazo/")]
        [AuditExecuted(Category.ExtenderPlazo)]
        public C_AccionesResultado ExtenderPlazo(PermisoUsuarioEncuestaModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            model.FechaTramite = DateTime.Now;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.I_PermisoUsuarioEncuestaInsert(model.IdUsuario, model.IdEncuesta, model.FechaFin, model.AudUserName, model.IdTipoTramite).FirstOrDefault();

                    if (resultado.estado == 0)
                    {
                        model.Excepcion = true;
                        model.ExcepcionMensaje = resultado.respuesta;
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>IEnumerable&lt;C_ObtenerExtensionesTiempo_Result&gt;.</returns>
        [Route("api/Usuarios/HabilitarReportes/TiposExtensiones")]
        public List<TiposExtensiones> GetTiposExtensiones(string audUserName, string userNameAddIdent)
        {
            List<TiposExtensiones> resultado = new List<TiposExtensiones>();

            try
            {
                resultado.Add(new TiposExtensiones() { idTipo = (int)TipoExtension.Encuesta, tipoExtension = "Encuesta" });
                resultado.Add(new TiposExtensiones() { idTipo = (int)TipoExtension.PlanMejoramiento, tipoExtension = "Plan de Mejoramiento" });
                resultado.Add(new TiposExtensiones() { idTipo = (int)TipoExtension.TableroPAT, tipoExtension = "Tablero PAT - Diligenciamiento" });
                resultado.Add(new TiposExtensiones() { idTipo = (int)TipoExtension.TableroPATSeguimiento1, tipoExtension = "Tablero PAT - Seguimiento 1" });
                resultado.Add(new TiposExtensiones() { idTipo = (int)TipoExtension.TableroPATSeguimiento2, tipoExtension = "Tablero PAT - Seguimiento 2" });
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>IEnumerable&lt;C_ObtenerExtensionesTiempo_Result&gt;.</returns>
        [Route("api/Usuarios/HabilitarReportes/ValidarExtensionTiempo")]
        public bool ValidarExtensiones(PermisoUsuarioEncuestaModels model)
        {
            bool resultado = false;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ValidarPermisosGuardado(model.IdUsuario, model.IdEncuesta, model.IdTipoTramite).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                //// queda pendiente para la implementación del módulo PAT
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, string.Empty, Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }
    }
}