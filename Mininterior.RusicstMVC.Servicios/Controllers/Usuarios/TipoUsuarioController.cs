// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 11-06-2017
// ***********************************************************************
// <copyright file="TipoUsuarioController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Usuarios namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Usuarios
{
    using Aplicacion;
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class TipoUsuarioController.
    /// </summary>
    [Authorize]
    public class TipoUsuarioController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="audUserName">Name of the aud user.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <returns>IEnumerable&lt;C_TipoUsuario_Result&gt;.</returns>
        [Route("api/Usuarios/TipoUsuario/")]
        public IEnumerable<C_TipoUsuario_Result> Get(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_TipoUsuario_Result> resultado = Enumerable.Empty<C_TipoUsuario_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TipoUsuario(null, null, null, null).Cast<C_TipoUsuario_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Insertars the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.CrearTipodeUsuario)]
        [Route("api/Usuarios/TipoUsuario/Insertar")]
        public C_AccionesResultado Insertar(TipoUsuariosModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.I_TipoUsuarioInsert(model.Tipo, model.Nombre, model.Activo).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modificars the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.EditarTipodeUsuario)]
        [Route("api/Usuarios/TipoUsuario/Modificar")]
        public C_AccionesResultado Modificar(TipoUsuariosModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.U_TipoUsuarioUpdate(model.Id, model.Tipo, model.Nombre, model.Activo).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Eliminars the specified tipo.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.EliminarTipodeUsuario)]
        [Route("api/Usuarios/TipoUsuario/Eliminar")]
        public C_AccionesResultado Eliminar(TipoUsuariosModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_TipoUsuarioDelete(model.Id).FirstOrDefault();

                    if (resultado.respuesta.Contains("FK_TipoUsuarioRecurso_TipoUsuario") || resultado.respuesta.Contains("FK_Usuario_TipoUsuario"))
                    {
                        resultado.respuesta = Mensajes.NoSePuedeBorrar;
                        model.Excepcion = true;
                        model.ExcepcionMensaje = Mensajes.NoSePuedeBorrar;
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }
    }
}