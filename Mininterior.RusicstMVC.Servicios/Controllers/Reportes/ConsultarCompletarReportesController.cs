// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-03-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 06-14-2017
// ***********************************************************************
// <copyright file="ConsultarCompletarReportesController.cs" company="Ministerio del Interior">
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
    /// Class ConsultarCompletarReportesController.
    /// </summary>
    [Authorize]
    public class ConsultarCompletarReportesController : ApiController
    {
        /// <summary>
        /// Listas the encuestas completadas.
        /// </summary>
        /// <param name="Usuario">The usuario.</param>
        /// <returns>Lista de encuestas</returns>
        [HttpPost]
        [Route("api/Reportes/ConsultarCompletarReportes/ListaEncuestasCompletadas/")]
        public IEnumerable<C_EncuestasXUsuarioCompletadas_Result> ListaEncuestasCompletadas(LoginModel Usuario)
        {
            IEnumerable<C_EncuestasXUsuarioCompletadas_Result> resultado = Enumerable.Empty<C_EncuestasXUsuarioCompletadas_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    IEnumerable<C_Usuario_Result> ListaUsuarios = BD.C_Usuario(null, null, null, null, null, Usuario.UserName, null).Cast<C_Usuario_Result>().ToList();

                    if (ListaUsuarios.Count() > 0)
                    {
                        C_Usuario_Result model = ListaUsuarios.FirstOrDefault();
                        resultado = BD.C_EncuestasXUsuarioCompletadas(idTipoUsuario: model.IdTipoUsuario, idUsuario: model.Id).Cast<C_EncuestasXUsuarioCompletadas_Result>().ToList(); ;

                    }
                }

            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Listas the encuestas no completadas.
        /// </summary>
        /// <param name="Usuario">The usuario.</param>
        /// <returns>Lista de encuestas</returns>
        [HttpPost]
        [Route("api/Reportes/ConsultarCompletarReportes/ListaEncuestasNoCompletadas/")]
        public IEnumerable<C_EncuestasXUsuarioNoCompletadas_Result> ListaEncuestasNoCompletadas(LoginModel Usuario)
        {
            IEnumerable<C_EncuestasXUsuarioNoCompletadas_Result> resultado = Enumerable.Empty<C_EncuestasXUsuarioNoCompletadas_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    IEnumerable<C_Usuario_Result> ListaUsuarios = BD.C_Usuario(null, null, null, null, null, Usuario.UserName, null).Cast<C_Usuario_Result>().ToList();

                    if (ListaUsuarios.Count() > 0)
                    {
                        C_Usuario_Result model = ListaUsuarios.FirstOrDefault();
                        resultado = BD.C_EncuestasXUsuarioNoCompletadas(idTipoUsuario: model.IdTipoUsuario, idUsuario: model.Id).Cast<C_EncuestasXUsuarioNoCompletadas_Result>().ToList(); ;

                    }
                }
              
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtiene todas las secciones de la encuesta.
        /// </summary>
        /// <param name="idEncuesta">Identificador de la encuesta.</param>
        /// <returns>Lista de secciones con sus subsecciones</returns>
        [HttpGet]
        [Route("api/Reportes/ConsultarCompletarReportes/ObtenerSeccionesXEncuesta/{idEncuesta}")]
        public IEnumerable<SeccionSubseccionModels> ObtenerSeccionesXEncuesta(int idEncuesta)
        {
            IEnumerable<SeccionSubseccionModels> resultado = Enumerable.Empty<SeccionSubseccionModels>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    IEnumerable<C_SeccionEncuesta_Result> Lista = BD.C_SeccionEncuesta(idEncuesta).ToList();
                    resultado = AgruparSecciones(Lista);
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #region Funciones Privadas

        /// <summary>
        /// Agrupa las secciones con las subsecciones.
        /// </summary>
        /// <param name="lista">lista de secciones.</param>
        /// <returns>Lista agrupada</returns>
        private IEnumerable<SeccionSubseccionModels> AgruparSecciones(IEnumerable<C_SeccionEncuesta_Result> lista)
        {
            List<SeccionSubseccionModels> resultado = new List<SeccionSubseccionModels>();

            List<C_SeccionEncuesta_Result> ListaSecciones = lista.Where(e => null == e.SuperSeccion).OrderBy(e => e.Titulo).ToList();

            ListaSecciones.ForEach(delegate (C_SeccionEncuesta_Result item)
            {
                SeccionSubseccionModels itemList = new Models.SeccionSubseccionModels()
                {
                    Id = item.Id,
                    Titulo = item.Titulo,
                    ListaSubsecciones = AdicionarSubsecciones(lista.Where(e => e.SuperSeccion == item.Id).OrderBy(e => e.Titulo), lista)
                };

                resultado.Add(itemList);
            });

            return resultado;
        }

        /// <summary>
        /// Adiciona las subsecciones a las secciones.
        /// </summary>
        /// <param name="listaFiltrada">The lista filtrada.</param>
        /// <param name="listaCompleta">The lista completa.</param>
        /// <returns>Lista de subsecciones</returns>
        private List<SeccionSubseccionModels> AdicionarSubsecciones(IEnumerable<C_SeccionEncuesta_Result> listaFiltrada, IEnumerable<C_SeccionEncuesta_Result> listaCompleta)
        {
            List<SeccionSubseccionModels> listaResultado = new List<SeccionSubseccionModels>();

            listaFiltrada.ToList().ForEach(delegate (C_SeccionEncuesta_Result item)
            {
                SeccionSubseccionModels itemList = new Models.SeccionSubseccionModels()
                {
                    Id = item.Id,
                    Titulo = item.Titulo,
                    ListaSubsecciones = AdicionarSubsecciones(listaCompleta.Where(e => e.SuperSeccion == item.Id).OrderBy(e => e.Titulo), listaCompleta)
                };

                listaResultado.Add(itemList);
            });

            return listaResultado;
        }
        
        #endregion
    }
}