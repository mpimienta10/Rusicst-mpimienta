// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 06-27-2017
// ***********************************************************************
// <copyright file="ListasController.cs" company="Ministerio del Interior">
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
    /// Class ListasController.
    /// </summary>
    [AllowAnonymous]
    public class ListasController : ApiController
    {
        /// <summary>
        /// Lista desplegable de Tipos de Encuesta
        /// </summary>
        /// <returns>Lista de Tipos de Encuesta.</returns>
        [HttpGet]
        [Route("api/General/Listas/TiposEncuesta/")]
        public IEnumerable<C_ListaTipoEncuesta_Result> TiposEncuesta(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_ListaTipoEncuesta_Result> resultado = Enumerable.Empty<C_ListaTipoEncuesta_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListaTipoEncuesta().Cast<C_ListaTipoEncuesta_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Lista desplegable de Tipos de Usuario
        /// </summary>
        /// <returns>Lista de Tipos de usuario.</returns>
        [HttpGet]
        [Route("api/General/Listas/TipoUsuarios/")]
        public IEnumerable<C_ListaTipoUsuario_Result> TipoUsuarios(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_ListaTipoUsuario_Result> resultado = Enumerable.Empty<C_ListaTipoUsuario_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListaTipoUsuario().Cast<C_ListaTipoUsuario_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Lista desplegable de encuestas.
        /// </summary>
        /// <returns>Lista de Encuestas</returns>
        [HttpGet]
        [Route("api/General/Listas/Encuestas/")]
        public IEnumerable<C_ListaEncuesta_Result> Encuestas(string audUserName, string userNameAddIdent, int? idTipoEncuesta = null)
        {
            IEnumerable<C_ListaEncuesta_Result> resultado = Enumerable.Empty<C_ListaEncuesta_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListaEncuesta(idTipoEncuesta).Cast<C_ListaEncuesta_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Lista desplegable de Roles
        /// </summary>
        /// <returns>Lista de roles</returns>
        [HttpGet]
        [Route("api/General/Listas/Roles/")]
        public IEnumerable<C_ListaRoles_Result> Roles(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_ListaRoles_Result> resultado = Enumerable.Empty<C_ListaRoles_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = resultado.Union(BD.C_ListaRoles().Cast<C_ListaRoles_Result>()).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Lista desplegable de sección x encuesta.
        /// </summary>
        /// <param name="idEncuesta">Identificador de la encuesta.</param>
        /// <returns>Lista de grupos</returns>
        [HttpGet]
        [Route("api/General/Listas/SeccionXEncuesta/")]
        public IEnumerable<C_ListaGrupo_Result> GrupoXEncuesta(string audUserName, string userNameAddIdent, int idEncuesta)
        {
            IEnumerable<C_ListaGrupo_Result> resultado = Enumerable.Empty<C_ListaGrupo_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListaGrupo(idEncuesta: idEncuesta).Cast<C_ListaGrupo_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Lista desplegagle de Secciones por grupo.
        /// </summary>
        /// <param name="idGrupo">Identificador del grupo.</param>
        /// <param name="idEncuesta">Identificador de la encuesta.</param>
        /// <returns>Lista de Secciones</returns>
        [HttpGet]
        [Route("api/General/Listas/SeccionXGrupo/")]
        public IEnumerable<C_ListaSeccion_Result> SeccionXGrupo(string audUserName, string userNameAddIdent, int idGrupo, int idEncuesta)
        {
            IEnumerable<C_ListaSeccion_Result> resultado = Enumerable.Empty<C_ListaSeccion_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListaSeccion(idEncuesta, idGrupo).Cast<C_ListaSeccion_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Subs sección x sección.
        /// </summary>
        /// <param name="idSeccion">Identificador de la sección.</param>
        /// <param name="idEncuesta">Identificador de la encuesta.</param>
        /// <returns>Lista de Subsecciones</returns>
        [HttpGet]
        [Route("api/General/Listas/SubSeccionXSeccion/")]
        public IEnumerable<C_ListaSubSeccion_Result> SubSeccionXSeccion(string audUserName, string userNameAddIdent, int idSeccion, int idEncuesta)
        {
            IEnumerable<C_ListaSubSeccion_Result> resultado = Enumerable.Empty<C_ListaSubSeccion_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListaSubSeccion(idEncuesta, idSeccion).Cast<C_ListaSubSeccion_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Lista desplegable de departamentos y municipios
        /// </summary>
        /// <returns>Lista de departamentos con sus municipios</returns>
        [HttpGet]
        [Route("api/General/Listas/DepartamentosMunicipios/")]
        public IEnumerable<C_ListaDeptosYMunicipios_Result> DepartamentosMunicipios(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_ListaDeptosYMunicipios_Result> resultado = Enumerable.Empty<C_ListaDeptosYMunicipios_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListaDeptosYMunicipios().Cast<C_ListaDeptosYMunicipios_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Lista desplegable de municipios x usuario.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTipoUsuario">The identifier tipo usuario.</param>
        /// <returns>Lista de Municipios</returns>
        [Route("api/General/ObtenerMunicipiosPorUsuario/")]
        public IEnumerable<C_ListaMunicipiosXUsuario_Result> GetMunicipiosXUsuario(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_ListaMunicipiosXUsuario_Result> resultado = Enumerable.Empty<C_ListaMunicipiosXUsuario_Result>();
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            var modelUsuario = new UsuariosModels { UserName = audUserName };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
            int idUsuario = datosUsuario.FirstOrDefault().Id;
            int idTipoUsuario = Convert.ToInt16(datosUsuario.FirstOrDefault().IdTipoUsuario);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListaMunicipiosXUsuario(idUsuario, idTipoUsuario).Cast<C_ListaMunicipiosXUsuario_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Lista desplegable de recursos. Se relaciona con los menus
        /// </summary>
        /// <returns>Lista de roles</returns>
        [HttpGet]
        [Route("api/General/Listas/Recursos/")]
        public IEnumerable<C_ListaRecurso_Result> Recursos(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_ListaRecurso_Result> resultado = Enumerable.Empty<C_ListaRecurso_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListaRecurso().Cast<C_ListaRecurso_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Subs the recursos.
        /// </summary>
        /// <param name="idRecurso">The identifier recurso.</param>
        /// <returns>IEnumerable&lt;C_Recurso_Result&gt;.</returns>
        [HttpGet]
        [Route("api/General/Listas/SubRecursos/")]
        public IEnumerable<C_ListaSubRecurso_Result> SubRecursos(string audUserName, string userNameAddIdent, int? idRecurso)
        {
            IEnumerable<C_ListaSubRecurso_Result> resultado = Enumerable.Empty<C_ListaSubRecurso_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListaSubRecurso(idRecurso).Cast<C_ListaSubRecurso_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Lista desplegable de categorías o acciones de auditoría.
        /// </summary>
        /// <returns>Lista de Category</returns>
        [HttpGet]
        [Route("api/General/Listas/Category/")]
        public IEnumerable<C_ListaCategory_Result> Categorias(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_ListaCategory_Result> resultado = Enumerable.Empty<C_ListaCategory_Result>();

            try
            {
                using (EntitiesRusicstLog BD = new EntitiesRusicstLog())
                {
                    resultado = BD.C_ListaCategory().Cast<C_ListaCategory_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(audUserName, userNameAddIdent, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Lista desplegable de categorías o acciones de auditoría.
        /// </summary>
        /// <returns>Lista de Category</returns>
        [HttpGet]
        [Route("api/General/Listas/CategoryOld/")]
        public IEnumerable<C_ListaCategoryLogOld_Result> CategoriasOld(string audUserName, string userNameAddIdent)
        {
            IEnumerable<C_ListaCategoryLogOld_Result> resultado = Enumerable.Empty<C_ListaCategoryLogOld_Result>();

            try
            {
                using (EntitiesRusicstLogOld BD = new EntitiesRusicstLogOld())
                {
                    resultado = BD.C_ListaCategoryLogOld().Cast<C_ListaCategoryLogOld_Result>().ToList();
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