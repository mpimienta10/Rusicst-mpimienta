// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 06-28-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 11-06-2017
// ***********************************************************************
// <copyright file="GestionarRolesController.cs" company="Ministerio del Interior">
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
    using Entidades;
    using Microsoft.AspNet.Identity;
    using Mininterior.RusicstMVC.Servicios.Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using System.Web.Http;

    /// <summary>
    /// Class GestionarRolesController.
    /// </summary>
    [Authorize]
    public class GestionarRolesController : ApiController
    {
        #region Métodos relacionados con el Rol

        /// <summary>
        /// Obtiene todos los roles existentes
        /// </summary>
        /// <param name="audUserName">Name of the aud user.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <returns>Lista de solicitudes</returns>
        [Route("api/Usuarios/GestionarRoles/")]
        public IEnumerable<RolModel> Get(string audUserName, string userNameAddIdent)
        {
            IEnumerable<RolModel> resultado = Enumerable.Empty<RolModel>();

            try
            {
                using (AuthRepository BD = new AuthRepository())
                {
                    resultado = BD.GetAllRoles().Cast<RolModel>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Insertar el rol que se está creando
        /// </summary>
        /// <param name="model">entidad tipo rol</param>
        /// <returns>Task IHttpActionResult</returns>
        [HttpPost, AuditExecuted(Category.CrearRol)]
        [Route("api/Usuarios/GestionarRoles/Insertar")]
        public async Task<IHttpActionResult> Insertar(RolModel model)
        {
            using (AuthRepository BD = new AuthRepository())
            {
                try
                {
                    IdentityResult result = await BD.RegisterRole(model);
                    string errorResult = GetErrorResult(result);

                    if (!string.IsNullOrEmpty(errorResult))
                    {
                        model.Excepcion = true;
                        model.ExcepcionMensaje = errorResult;
                        //(new AuditExecuted(Category.CrearRol)).ActionExecutedManual(model);
                        return Ok(errorResult);
                    }

                    //(new AuditExecuted(Category.CrearRol)).ActionExecutedManual(model);
                }
                catch (Exception ex)
                {
                    (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                }

                return Ok((await BD.FindRole(model.Nombre)).Id);
            }
        }

        /// <summary>
        /// Modifica el nombre del rol
        /// </summary>
        /// <param name="model">entidad tipo rol</param>
        /// <returns>Task IHttpActionResult</returns>
        [HttpPost, AuditExecuted(Category.EditarRol)]
        [Route("api/Usuarios/GestionarRoles/Modificar")]
        public async Task<IHttpActionResult> Modificar(RolModel model)
        {
            using (AuthRepository BD = new AuthRepository())
            {
                try
                {
                    IdentityResult result = await BD.ModifyRole(model);
                    string errorResult = GetErrorResult(result);

                    if (!string.IsNullOrEmpty(errorResult))
                    {
                        model.Excepcion = true;
                        model.ExcepcionMensaje = errorResult;
                        //(new AuditExecuted(Category.EditarRol)).ActionExecutedManual(model);
                        return Ok(errorResult);
                    }

                    //(new AuditExecuted(Category.EditarRol)).ActionExecutedManual(model);
                }
                catch (Exception ex)
                {
                    (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                }

                return Ok((await BD.FindRole(model.Nombre)).Id);
            }
        }

        /// <summary>
        /// Elimina el rol creado validando que los usuarios relacionados no esten atados a ninguna encuesta
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Task IHttpActionResult</returns>
        [HttpPost, AuditExecuted(Category.EliminarRol)]
        [Route("api/Usuarios/GestionarRoles/Eliminar")]
        public async Task<IHttpActionResult> Eliminar(RolModel model)
        {
            try
            {
                using (AuthRepository BD = new AuthRepository())
                {
                    IdentityResult result = await BD.RemoveRol(model.Id);
                    string errorResult = GetErrorResult(result);

                    if (!string.IsNullOrEmpty(errorResult))
                    {
                        model.Excepcion = true;
                        model.ExcepcionMensaje = errorResult;
                        //(new AuditExecuted(Category.EliminarRol)).ActionExecutedManual(model);
                        return Ok(errorResult);
                    }
                }

                //(new AuditExecuted(Category.EliminarRol)).ActionExecutedManual(model);
                return Ok();
            }
            catch (Exception ex)
            {
                string Mensaje = string.Empty;
                if (ex.InnerException.InnerException.Message.Contains("FK_RolEncuesta_Rol")) Mensaje = Mensajes.NoSePuedeBorrar;
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return Ok(Mensaje);
            }
        }

        #endregion

        #region Métodos de los usuarios relacionados con el Rol

        /// <summary>
        /// Obtiene todos los usuarios relacionados con el rol
        /// </summary>
        /// <param name="audUserName">Name of the aud user.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <param name="idRol">Identificador del rol.</param>
        /// <param name="incluidos">true muestra los incluidos, false los no incluidos</param>
        /// <returns>Lista de usuarios</returns>
        [HttpGet]
        [Route("api/Usuarios/GestionarRoles/TraerUsuariosRelacionados")]
        public IEnumerable<C_UsuariosXRol_Result> TraerUsuariosRelacionados(string audUserName, string userNameAddIdent, string idRol, bool incluidos)
        {
            IEnumerable<C_UsuariosXRol_Result> resultado = Enumerable.Empty<C_UsuariosXRol_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_UsuariosXRol(idRol, incluidos).Cast<C_UsuariosXRol_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Inserta los usuarios que se van a relacionar con este rol
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Task IHttpActionResult.</returns>
        [HttpPost]
        [Route("api/Usuarios/GestionarRoles/GestionarUsuariosAlRol")]
        public async Task<IHttpActionResult> GestionarUsuariosAlRol(RolIncluirModel model)
        {
            try
            {
                using (AuthRepository BD = new AuthRepository())
                {
                    IdentityResult result = await BD.RegisterUsersRole(model.IdRol, model.IdsUsuarios, model.Incluir);
                    string errorResult = GetErrorResult(result);

                    if (null != errorResult && !string.IsNullOrEmpty(errorResult))
                    {
                        model.Excepcion = true;
                        model.ExcepcionMensaje = errorResult;
                        (new AuditExecuted(model.Incluir ? Category.AgregarUsuarioaRol : Category.RemoverUsuariodeRol)).ActionExecutedManual(model);
                        return Ok(errorResult);
                    }
                }

                (new AuditExecuted(model.Incluir ? Category.AgregarUsuarioaRol : Category.RemoverUsuariodeRol)).ActionExecutedManual(model);
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return Ok();
        }

        #endregion

        #region Utilitarios

        /// <summary>
        /// Gets the error result.
        /// </summary>
        /// <param name="result">The result.</param>
        /// <returns>IHttpActionResult.</returns>
        private string GetErrorResult(IdentityResult result)
        {
            string retorno = string.Empty;

            if (result == null)
            {
                return InternalServerError().ToString();
            }

            if (!result.Succeeded)
            {
                if (result.Errors != null)
                {
                    foreach (string error in result.Errors)
                    {
                        retorno += error + Environment.NewLine;
                    }
                }

                if (ModelState.IsValid)
                {
                    // No ModelState errors are available to send, so just return an empty BadRequest.
                    return string.Empty;
                }

                return retorno += "Sin errores pero con excepción";
            }

            return retorno;
        }

        #endregion
    }
}