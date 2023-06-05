// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 11-06-2017
// ***********************************************************************
// <copyright file="UsuariosController.cs" company="Ministerio del Interior">
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
    using Microsoft.AspNet.Identity;
    using Mininterior.RusicstMVC.Aplicacion;
    using Mininterior.RusicstMVC.Entidades;
    using Mininterior.RusicstMVC.Servicios.Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class UsuariosController.
    /// </summary>
    [Authorize]
    public class UsuariosController : ApiController
    {
        /// <summary>
        /// Obtiene el listado de usuarios
        /// </summary>
        /// <param name="audUserName">Name of the aud user.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <returns>Lista de usuarios</returns>
        [Route("api/Usuarios/Usuarios/")]
        public IEnumerable<C_Usuario_Result> Get(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_Usuario_Result> resultado = Enumerable.Empty<C_Usuario_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_Usuario(null, null, null, null, null, null, (int)EstadoSolicitud.Aprobada).Cast<C_Usuario_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtiene el listado de usuarios
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Lista de usuarios</returns>
        [HttpPost]
        [Route("api/Usuarios/Usuarios/BuscarXUsuario")]
        public IEnumerable<C_Usuario_Result> BuscarXUsuario(UsuariosModels model)
        {
            IEnumerable<C_Usuario_Result> resultado = Enumerable.Empty<C_Usuario_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_Usuario(null, null, null, null, null, model.UserName, null).Cast<C_Usuario_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtiene el listado de usuarios
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Lista de usuarios</returns>
        [HttpPost]
        [Route("api/Usuarios/Usuarios/BuscarXDepYMun")]
        public IEnumerable<C_Usuario_Result> BuscarXDepYMun(UsuariosModels model)
        {
            IEnumerable<C_Usuario_Result> resultado = Enumerable.Empty<C_Usuario_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    if (model.IdMunicipio == 0)
                    {
                        resultado = BD.C_Usuario(null, null, null, model.IdDepartamento, null, null, null).Cast<C_Usuario_Result>().ToList();
                    }
                    else if (model.IdDepartamento == 0)
                    {
                        resultado = BD.C_Usuario(null, null, null, null, model.IdMunicipio, null, null).Cast<C_Usuario_Result>().ToList();
                    }
                    else
                    {
                        resultado = BD.C_Usuario(null, null, null, model.IdDepartamento, model.IdMunicipio, null, null).Cast<C_Usuario_Result>().ToList();
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtiene el listado de usuarios
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Lista de usuarios</returns>
        [HttpPost, AuditExecuting]
        [Route("api/Usuarios/Usuarios/UsuarioAutenticado")]
        public IEnumerable<C_Usuario_Result> UsuarioAutenticado(UsuariosModels model)
        {
            IEnumerable<C_Usuario_Result> resultado = Enumerable.Empty<C_Usuario_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_Usuario(null, null, null, null, null, model.AudUserName, null).Cast<C_Usuario_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modifica la información de los usuarios.
        /// </summary>
        /// <param name="model">Entidad con los datos a actualizar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EditarUsuario)]
        [Route("api/Usuarios/Usuarios/Modificar")]
        public C_AccionesResultado Modificar(UsuariosModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// En el model.AudUserName llega el UserName, con éste, pregunta en la consulta y a esa variable se le 
                    //// asigna el id del usuario que esta tramitando para colocarlo en el Update que finaliza el proceso
                    C_Usuario_Result usuarioTramite = BD.C_Usuario(null, null, null, null, null, model.AudUserName, null).First();
                    model.IdUsuarioTramite = usuarioTramite.Id.ToString();

                    if (!string.IsNullOrEmpty(model.NewPassword))
                    {
                        //// Mecanismo de seguridad para contener las modificaciones desde el browser
                        if (usuarioTramite.IdTipoUsuario != (int)TipoUsuario.administrador)
                            if (string.IsNullOrEmpty(model.Password))
                                model.Password = Mininterior.RusicstMVC.Aplicacion.Seguridad.Generador.GenerateToken(8).Replace("+", "=");

                        //// Actualiza la contraseña en el RUSICST
                        using (AuthRepository AuthBD = new AuthRepository())
                        {
                            IdentityResult result = AuthBD.ChangePassword(model.UserName, model.Password, model.NewPassword);

                            if (!result.Succeeded)
                            {
                                resultado.estado = (int)EstadoRespuesta.Excepcion;
                                resultado.respuesta = result.Errors.Count() > 0 ? result.Errors.First() : Mensajes.ClaveErrada;
                                return resultado;
                            }
                        }
                    }

                    //// Valida si el email fue cambiado
                    C_Usuario_Result usuario = BD.C_Usuario(model.Id, null, null, null, null, null, null).First();
                    string email = usuario.Email;

                    if (email != model.Email)
                    {
                        using (AuthRepository AuthBD = new AuthRepository())
                        {
                            IdentityResult result = AuthBD.ChangeEmail(model.UserName, model.Email);

                            if (!result.Succeeded)
                            {
                                resultado.estado = (int)EstadoRespuesta.Excepcion;
                                resultado.respuesta = result.Errors.First();
                                return resultado;
                            }
                        }
                    }

                    //// Actualiza los datos del usuario
                    resultado = BD.U_UsuarioUpdate(model.Id, null, model.IdTipoUsuario, model.IdDepartamento, model.IdMunicipio, null, int.Parse(model.IdUsuarioTramite), null, model.Nombres, model.Cargo,
                                                   model.TelefonoFijo, model.TelefonoFijoIndicativo, model.TelefonoFijoExtension, model.TelefonoCelular, model.Email, model.EmailAlternativo,
                                                   null, true, null, model.Activo, null, null, null, null, null, null, null, null, null).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(model.AudUserName, model.UserNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Elimina el usuario. En caso de tener información relacionada, lo Inhabilita colocando la columna activo en false
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EliminarUsuario)]
        [Route("api/Usuarios/Usuarios/Eliminar")]
        public C_AccionesResultado Eliminar(UsuariosModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// En el model.IdUsuarioTramite llega el UserName, con éste, ejecuta la consulta  
                    //// y a esa misma variable se le asigna el id para colocarlo en el Update
                    C_Usuario_Result usuarioTramite = BD.C_Usuario(null, null, null, null, null, model.AudUserName, null).First();
                    model.IdUsuarioTramite = usuarioTramite.Id.ToString();

                    resultado = BD.D_UsuarioDelete(model.Id, int.Parse(model.IdUsuarioTramite)).FirstOrDefault();
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