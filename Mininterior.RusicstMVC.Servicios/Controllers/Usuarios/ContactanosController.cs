// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 11-06-2017
// ***********************************************************************
// <copyright file="ContactanosController.cs" company="Ministerio del Interior">
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
    using Mininterior.RusicstMVC.Aplicacion.Mensajeria;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class ContactanosController.
    /// </summary>
    public class ContactanosController : ApiController
    {
        /// <summary>
        /// Enviars the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [AllowAnonymous]
        [HttpPost]
        [Route("api/Usuarios/Contactenos/Enviar")]
        public C_AccionesResultado Enviar(CampanaEmailModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            C_DatosSistema_Result datosSistema = new C_DatosSistema_Result();

            List<string> ListaCorreos = new List<string>() { "reporteunificado@mininterior.gov.co" };
            List<string> ListaCorreosCopias = new List<string>() { model.CorreoUsuarioContactenos };

            //// Coloca el correo como usuario para que sea auditado
            model.AudUserName = model.CorreoUsuarioContactenos;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    datosSistema = BD.C_DatosSistema().First();
                }

                string mensaje = Correo.EnviarXSmtp(ListaCorreos.ToArray(), ListaCorreosCopias.ToArray(), null, null, model.Asunto, model.Mensaje, datosSistema.FromEmail, datosSistema.SmtpPassword, datosSistema.SmtpHost, datosSistema.SmtpPort.Value);

                if (!string.IsNullOrEmpty(mensaje))
                {
                    resultado.estado = 0;
                    resultado.respuesta = mensaje;
                    model.Excepcion = true;
                    model.ExcepcionMensaje = mensaje;
                    (new AuditExecuted(Category.EnvioMailContactenosError)).ActionExecutedManual(model);
                }
                else
                {
                    resultado.estado = 5;
                    resultado.respuesta = "Correo enviado satisfactoriamente";
                    (new AuditExecuted(Category.EnvioMailContactenos)).ActionExecutedManual(model);
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }
    }
}