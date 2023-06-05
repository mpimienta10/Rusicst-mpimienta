// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-18-2017
// ***********************************************************************
// <copyright file="InformeRespuestasController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Informes namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Informes
{
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class InformeRespuestasController.
    /// </summary>
    [Authorize]
    public class InformeRespuestasController : ApiController
    {
        /// <summary>
        /// Obtiene todas las secciones de la encuesta.
        /// </summary>
        /// <param name="idEncuesta">Identificador de la encuesta.</param>
        /// <returns>Lista de secciones con sus subsecciones</returns>
        [HttpGet]
        [Route("api/Informes/InformeRespuestas/ObtenerSecciones/{idEncuesta}")]
        public IEnumerable<SeccionSubseccionModels> ObtenerSecciones(int idEncuesta)
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
            catch (System.Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Datos para la carga de la rejilla.
        /// </summary>
        /// <param name="idEncuesta">identificador de la encuesta.</param>
        /// <param name="listaIdSubsecciones">lista con los identificadores de las subsecciones.</param>
        /// <param name="idDepartamento">Identificador del departamento.</param>
        /// <param name="idMunicipio">Identificador del municipio.</param>
        /// <param name="usuario">usuario autenticado.</param>
        /// <returns>Lista con los datos de la rejilla</returns>
        [HttpGet]
        [Route("api/Informes/InformeRespuestas/DatosRejilla")]
        public IEnumerable<C_InformeRespuesta_Result> DatosRejilla(int idEncuesta, string listaIdSubsecciones, int? idDepartamento, int? idMunicipio, string usuario)
        {
            IEnumerable<C_InformeRespuesta_Result> resultado = Enumerable.Empty<C_InformeRespuesta_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 3600;
                    resultado = BD.C_InformeRespuesta(idEncuesta, listaIdSubsecciones, idDepartamento, idMunicipio, usuario).ToList();
                }
            }
            catch (System.Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

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
    }
}