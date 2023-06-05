// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-01-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 08-15-2017
// ***********************************************************************
// <copyright file="ParametrosSistemaController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Sistema namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Sistema
{
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class ParametrosSistemaController.
    /// </summary>
    [Authorize]
    public class ParametrosSistemaController : ApiController
    {
        /// <summary>
        /// Obtiene los datos de parámetros sistema
        /// </summary>
        /// <returns>Entidad con los datos del sistema</returns>
        [Route("api/Sistema/ParametrosSistema/")]
        public C_DatosSistema_Result Get()
        {
            C_DatosSistema_Result resultado = new C_DatosSistema_Result();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modifica los parámetros del sistema
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Resultado de la actualización.</returns>
        [HttpPost, AuditExecuted(Category.EditarDatosdelSistema)]
        [Route("api/Sistema/ParametrosSistema/Modificar")]
        public C_AccionesResultado Modificar(ParametrosSistemaModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Valida si la contraseña se esta intentando cambiar. Si no vienen datos, no la cambia
                    model.SmtpPassword = string.IsNullOrEmpty(model.SmtpPassword) ? BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault().SmtpPassword : model.SmtpPassword;

                    resultado = BD.U_SistemaUpdate(model.Id, model.FromEmail, model.SmtpHost, model.SmtpPort, model.SmtpEnableSsl, model.SmtpUsername,
                                                   model.SmtpPassword, model.TextoBienvenida, model.FormatoFecha, model.PlantillaEmailConfirmacion,
                                                   model.UploadDirectory, model.PlantillaEmailConfirmacion, model.SaveMessageConfirmPopup, model.PlantillaEmailConfirmacionPlaneacionPat, model.PlantillaEmailConfirmacionSeguimiento1Pat, model.PlantillaEmailConfirmacionSeguimiento2Pat,
                                                   model.AsuntoEnvioR, model.AsuntoEnvioPT, model.AsuntoEnvioSeguimientoT1, model.AsuntoEnvioSeguimientoT2
                                                   ,model.AsuntoEnvioSP, model.PlantillaEmailConfirmacionSeguimientoPlan).FirstOrDefault();
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