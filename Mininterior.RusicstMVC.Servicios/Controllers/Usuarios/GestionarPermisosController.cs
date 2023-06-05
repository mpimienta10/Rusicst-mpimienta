// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 11-06-2017
// ***********************************************************************
// <copyright file="GestionarPermisosController.cs" company="Ministerio del Interior">
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
    using Mininterior.RusicstMVC.Servicios.Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class GestionarPermisosController.
    /// </summary>
    [Authorize]
    public class GestionarPermisosController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="audUserName">Name of the aud user.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <returns>IEnumerable&lt;C_PermisosUsuario_Result&gt;.</returns>
        [Route("api/Usuarios/GestionarPermisos/")]
        public IEnumerable<C_PermisosUsuario_Result> Get(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_PermisosUsuario_Result> resultado = Enumerable.Empty<C_PermisosUsuario_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_PermisosUsuario(null).Cast<C_PermisosUsuario_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="audUserName">Name of the aud user.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <returns>IEnumerable&lt;C_PermisosUsuario_Result&gt;.</returns>
        [Route("api/Usuarios/GestionarPermisosPorUsuarioyRol/")]
        public IEnumerable<C_PermisosUsuarioPorRecurso_Result> GetSubRecursoPorRolRecurso(string audUserName, string userNameAddIdent, int idRecurso, int idTipoUsuario)
        {
            IEnumerable<C_PermisosUsuarioPorRecurso_Result> resultado = Enumerable.Empty<C_PermisosUsuarioPorRecurso_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_PermisosUsuarioPorRecurso(idTipoUsuario, idRecurso).Cast<C_PermisosUsuarioPorRecurso_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Permisoses the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>IEnumerable&lt;C_PermisosUsuario_Result&gt;.</returns>
        [Route("api/Usuarios/GestionarPermisos/Permisos")]
        public IEnumerable<C_PermisosUsuario_Result> Permisos(LoginModel model)
        {
            IEnumerable<C_PermisosUsuario_Result> resultado = Enumerable.Empty<C_PermisosUsuario_Result>();

            try
            {
                //// Obtiene el usuario y extrae el tipo de usuario para saber que menús se habilitan
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    List<C_Usuario_Result> Usuario = BD.C_Usuario(null, null, null, null, null, model.UserName, null).ToList();

                    if (Usuario.Count() > 0)
                    {
                        resultado = BD.C_PermisosUsuario(Usuario.First().IdTipoUsuario).Cast<C_PermisosUsuario_Result>().ToList();
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.UserName, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Insertars the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.CrearPermiso)]
        [Route("api/Usuarios/GestionarPermisos/Insertar")]
        public C_AccionesResultado Insertar(TipoUsuarioRecursosModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.I_TipoUsuarioRecursoInsert(model.IdTipoUsuario, model.IdRecurso, model.ListaIdSubRecurso).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Eliminars the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.EliminarPermiso)]
        [Route("api/Usuarios/GestionarPermisos/Eliminar")]
        public C_AccionesResultado Eliminar(TipoUsuarioRecursosModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_TipoUsuarioRecursoDelete(model.IdTipoUsuario, model.IdRecurso, model.IdSubRecurso).FirstOrDefault();
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