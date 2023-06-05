// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-03-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 07-27-2017
// ***********************************************************************
// <copyright file="ModificarPreguntasController.cs" company="Ministerio del Interior">
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
    /// Class ModificarPreguntasController.
    /// </summary>
    [Authorize]
    public class ModificarPreguntasController : ApiController
    {
        /// <summary>
        /// Listas the encuestas.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Lista con C_PreguntasSeccionEncuesta.</returns>
        [HttpPost]
        [Route("api/Reportes/ModificarPreguntas/")]
        public IEnumerable<C_PreguntasSeccionEncuesta_Result> ListaEncuestas(FiltroModificarPregunta model)
        {
            IEnumerable<C_PreguntasSeccionEncuesta_Result> resultado = Enumerable.Empty<C_PreguntasSeccionEncuesta_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_PreguntasSeccionEncuesta(model.idEncuesta, model.idGrupo, model.idSeccion, model.idSubseccion, model.nombrePregunta, model.idPreguntaAnterior, (model.codigoPreguntaBanco != string.Empty && model.codigoPreguntaBanco != null) ? model.codigoPreguntaBanco : null).Cast<C_PreguntasSeccionEncuesta_Result>().ToList();
                    resultado.ToList().ForEach(e => e.Texto = System.Text.RegularExpressions.Regex.Replace(e.Texto, "^%.+%", ""));
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obteners the tipos pregunta.
        /// </summary>
        /// <returns>Lista con los tipos de pregunta</returns>
        [HttpGet]
        [Route("api/Reportes/ModificarPreguntas/ObtenerTiposPregunta")]
        public IEnumerable<C_TiposPregunta_Result> ObtenerTiposPregunta()
        {
            IEnumerable<C_TiposPregunta_Result> resultado = Enumerable.Empty<C_TiposPregunta_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TiposPregunta().Cast<C_TiposPregunta_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obteners the datos pregunta.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>C_DatosPregunta_Result.</returns>
        [HttpGet]
        [Route("api/Reportes/ModificarPreguntas/ObtenerDatosPregunta/{id}")]
        public C_DatosPregunta_Result ObtenerDatosPregunta(int id)
        {
            C_DatosPregunta_Result resultado = new C_DatosPregunta_Result();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DatosPregunta(id).Cast<C_DatosPregunta_Result>().FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modificars the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.ModificarPregunta)]
        [Route("api/Reportes/ModificarPreguntas/Modificar/")]
        public C_AccionesResultado Modificar(PreguntaModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.U_PreguntaUpdate(model.Id, model.Nombre, model.IdTipoPregunta, model.Ayuda, model.EsObligatoria, model.SoloSi, model.Texto).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obteners the opciones.
        /// </summary>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <returns>C_OpcionesXPregunta_Result.</returns>
        [HttpGet]
        [Route("api/Reportes/ModificarPreguntas/ObtenerOpciones/{idPregunta}")]
        public IEnumerable<C_OpcionesXPregunta_Result> ObtenerOpciones(int idPregunta)
        {
            IEnumerable<C_OpcionesXPregunta_Result> resultado = Enumerable.Empty<C_OpcionesXPregunta_Result>();
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_OpcionesXPregunta(idPregunta).Cast<C_OpcionesXPregunta_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modificars the opcion.
        /// </summary>
        /// <param name="idOpcion">The identifier opcion.</param>
        /// <param name="valor">The valor.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.EditarPreguntaOpcion)]
        [Route("api/Reportes/ModificarPreguntas/ModificarOpcion/")]
        public C_AccionesResultado ModificarOpcion(PreguntaOpcionModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.U_OpcionesUpdate(model.Id, model.Valor).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Insertars the opcion.
        /// </summary>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <param name="valor">The valor.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.CrearPreguntaOpcion)]
        [Route("api/Reportes/ModificarPreguntas/InsertarOpcion/")]
        public C_AccionesResultado InsertarOpcion(PreguntaOpcionModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.I_OpcionesInsert(model.IdPregunta, model.Valor).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Eliminars the opcion.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.EliminarPreguntaOpcion)]
        [Route("api/Reportes/ModificarPreguntas/EliminarOpcion/")]
        public C_AccionesResultado EliminarOpcion(PreguntaOpcionModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_OpcionesDelete(model.Id).FirstOrDefault();
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