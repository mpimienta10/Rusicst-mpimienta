// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-01-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-26-2017
// ***********************************************************************
// <copyright file="GestionPlanesMejoramientoController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Sistema namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Sistema
{
    using Aplicacion;
    using Aplicacion.Adjuntos;
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Threading.Tasks;
    using System.Web.Http;

    /// <summary>
    /// Class GestionPlanesMejoramientoController.
    /// </summary>
    [Authorize]
    public class GestionPlanesMejoramientoController : ApiController
    {
        #region Configuración Plan de Mejoramiento


        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/ListadoPlanes")]
        public IEnumerable<C_ObtenerListadoPlanes_Result> Get()
        {
            IEnumerable<C_ObtenerListadoPlanes_Result> resultado = Enumerable.Empty<C_ObtenerListadoPlanes_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerListadoPlanes(2).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/ListadoEncuestasSinResponder")]
        public IEnumerable<C_ObtenerListadoEncuestasSinResponder_Result> GetEncuestasSinResponder(int? idPlan)
        {
            IEnumerable<C_ObtenerListadoEncuestasSinResponder_Result> resultado = Enumerable.Empty<C_ObtenerListadoEncuestasSinResponder_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerListadoEncuestasSinResponder(idPlan).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="idPlan">The identifier plan.</param>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/ListadoEncuestasPlan")]
        public C_ObtenerListadoEncuestasPlan_Result GetEncuestasPlan(int idPlan)
        {
            C_ObtenerListadoEncuestasPlan_Result resultado = new C_ObtenerListadoEncuestasPlan_Result();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerListadoEncuestasPlan(idPlan).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Inserta un nuevo Plan de Mejoramiento.
        /// </summary>
        /// <param name="model">Entidad con los datos a insertar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.CrearPlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramiento/InsertarPlanMejoramiento")]
        public C_AccionesResultado InsertarPlan(PlanMejoramientoModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.I_PlanMejoramientoInsert(model.nombrePlan, model.fechaLimite).FirstOrDefault();

                    if (resultado.estado == 1)
                    {
                        var plan = bd.C_ObtenerListadoPlanes(2).Where(x => x.Nombre.Equals(model.nombrePlan)).First();

                        resultado = bd.I_PlanMejoramientoEncuestaInsert(plan.IdPlanMejoramiento, model.idEncuesta).FirstOrDefault();
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
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/DatosActivacionPlan")]
        public C_ObtenerDatosActivacionPlanMejoramiento_Result GetDatosActivacionPlan(int idPlan)
        {
            C_ObtenerDatosActivacionPlanMejoramiento_Result resultado = new C_ObtenerDatosActivacionPlanMejoramiento_Result();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerDatosActivacionPlanMejoramiento(idPlan).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Inserta o Actualiza la Activación de un Plan de Mejoramiento.
        /// </summary>
        /// <param name="model">Entidad con los datos a insertar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.ActivarPlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramiento/ActivarPlan")]
        public C_AccionesResultado ActivarPlan(ActivacionPlan model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.I_PlanMejoramientoActivacionInsert(model.idPlan, model.fechaIni, model.fechaFin, model.muestraPorc).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Actualiza los datos de un Plan de Mejoramiento.
        /// </summary>
        /// <param name="model">Entidad con los datos a insertar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EditarPlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramiento/ActualizarPlanMejoramiento")]
        public C_AccionesResultado ActualizarPlan(PlanMejoramientoModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.U_PlanMejoramientoUpdate(model.idPlan, model.nombrePlan, model.fechaLimite).FirstOrDefault();

                    if (resultado.estado == 1)
                    {
                        resultado = bd.I_PlanMejoramientoEncuestaInsert(model.idPlan, model.idEncuesta).FirstOrDefault();
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
        /// Gets this instance.
        /// </summary>
        /// <param name="idPlan">The identifier plan.</param>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/SeccionesPlan/ListadoSecciones")]
        public IEnumerable<C_ObtenerListadoSeccionesPlan_Result> GetListadoSecciones(int idPlan)
        {
            IEnumerable<C_ObtenerListadoSeccionesPlan_Result> resultado = Enumerable.Empty<C_ObtenerListadoSeccionesPlan_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerListadoSeccionesPlan(idPlan).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Inserta una nueva sección a un Plan de Mejoramiento.
        /// </summary>
        /// <param name="model">Entidad con los datos a insertar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.CrearsecciónenPlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramiento/SeccionesPlan/InsertarSeccion")]
        public C_AccionesResultado InsertarSeccion(SeccionPlanMejoramientoModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.I_SeccionPlanMejoramientoInsert(model.titulo, model.ayuda, model.idSeccionPadre, model.idPlan).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Actualiza una sección de un Plan de Mejoramiento.
        /// </summary>
        /// <param name="model">Entidad con los datos a insertar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EditarsecciónenPlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramiento/SeccionesPlan/ActualizarSeccion")]
        public C_AccionesResultado ActualizarSeccion(SeccionPlanMejoramientoModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.U_SeccionPlanMejoramientoUpdate(model.titulo, model.ayuda, model.idSeccionPadre, model.idPlan, model.idSeccion).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="idPlan">The identifier plan.</param>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/SeccionesPlan/SeccionesEncuestas")]
        public IEnumerable<C_ObtenerSeccionesEncuestasPlanMejoramiento_Result> GetListadoSeccionesEncuestas(int idPlan)
        {
            IEnumerable<C_ObtenerSeccionesEncuestasPlanMejoramiento_Result> resultado = Enumerable.Empty<C_ObtenerSeccionesEncuestasPlanMejoramiento_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerSeccionesEncuestasPlanMejoramiento(idPlan).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Elimina una Recomendación.
        /// </summary>
        /// <param name="idSeccion">Id de la Seccion a Eliminar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EliminarseccióndePlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramiento/SeccionesPlan/EliminarSeccion")]
        public C_AccionesResultado EliminarSeccion(SeccionPlanMejoramientoModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.D_PlanMejoramientoSeccionDelete(model.idSeccion).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="idSeccion">The identifier seccion.</param>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ListadoRecomendaciones")]
        public IEnumerable<C_ObtenerInformacionRecomendacionesPlan_Result> GetListadoRecomendaciones(int idSeccion)
        {
            IEnumerable<C_ObtenerInformacionRecomendacionesPlan_Result> resultado = Enumerable.Empty<C_ObtenerInformacionRecomendacionesPlan_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionRecomendacionesPlan(idSeccion).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="idPlan">The identifier plan.</param>
        /// <param name="idSeccion">The identifier seccion.</param>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ValidarCreacionRecomendaciones")]
        public bool ValidarCreacionRecomendacion(int idPlan, int idSeccion)
        {
            bool resultado = false;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    var porc = bd.C_ObtenerPorcentajeTotalObjetivosPM(idPlan, idSeccion).First();

                    if (porc.HasValue)
                    {
                        resultado = (100 - Decimal.ToInt32(porc.Value)) > 0;
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
        /// Gets this instance.
        /// </summary>
        /// <param name="idPlan">The identifier plan.</param>
        /// <returns>Resultado de la validacion previo a la activacion de un plan de mejoramiento</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/ValidarActivacionPlan")]
        public bool ValidarActivacionPlan(int idPlan)
        {
            bool resultado = false;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    var porc = bd.C_ValidarActivarPlanMejoramiento(idPlan).FirstOrDefault();

                    if (porc.HasValue)
                    {
                        resultado = porc.Value;
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
        /// Gets this instance.
        /// </summary>
        /// <param name="idPlan">The identifier plan.</param>
        /// <param name="idSeccion">The identifier seccion.</param>
        /// <returns>Porcentaje total de la suma de las recomendaciones de una seccion de un plan de mejoramiento</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/RecomendacionesPlan/PorcentajeRecomendacionesSeccion")]
        public int PorcentajeRecomendacionesSeccion(int idPlan, int idSeccion)
        {
            int resultado = 0;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    var porc = bd.C_ObtenerPorcentajeTotalObjetivosPM(idPlan, idSeccion).First();

                    if (porc.HasValue)
                    {
                        resultado = Decimal.ToInt32(porc.Value);
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
        /// Gets this instance.
        /// </summary>
        /// <param name="idPlan">The identifier plan.</param>
        /// <returns>Lista con las preguntas de la(s) encuesta(s) asociada(s) a un plan de mejoramiento</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ListadoPreguntasPlan")]
        public IEnumerable<C_ObtenerPreguntasPlanMejoramiento_Result> GetListadoPreguntasPlan(int idPlan)
        {
            IEnumerable<C_ObtenerPreguntasPlanMejoramiento_Result> resultado = Enumerable.Empty<C_ObtenerPreguntasPlanMejoramiento_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerPreguntasPlanMejoramiento(idPlan).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ListadoOpcionesPreguntaAsociada")]
        public IEnumerable<OpcionesPreguntaRecomendacionPlan> GetListaOpcionesPreguta(int idPregunta)
        {
            List<OpcionesPreguntaRecomendacionPlan> resultado = new List<OpcionesPreguntaRecomendacionPlan>();
            List<C_OpcionesXPregunta_Result> opcionesBD;
            C_DatosPregunta_Result pregunta;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    opcionesBD = bd.C_OpcionesXPregunta(idPregunta).ToList();
                    pregunta = bd.C_DatosPregunta(idPregunta).FirstOrDefault();
                }

                if (pregunta.IdTipoPregunta != 11)
                {
                    resultado.Add(new OpcionesPreguntaRecomendacionPlan() { Valor = "Vacío", Texto = "Vacío" });
                    resultado.Add(new OpcionesPreguntaRecomendacionPlan() { Valor = "No Vacío", Texto = "No Vacío" });
                }

                for (int i = 0; i < opcionesBD.Count; i++)
                {
                    OpcionesPreguntaRecomendacionPlan opcion = new OpcionesPreguntaRecomendacionPlan();

                    opcion.Valor = opcionesBD.ElementAt(i).Valor;
                    opcion.Texto = opcionesBD.ElementAt(i).Texto;

                    resultado.Add(opcion);
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ListadoBusquedaObjetivos")]
        public IEnumerable<C_ObtenerInformacionObjetivosPlanes_Result> GetListaObjetivosBusqueda()
        {
            List<C_ObtenerInformacionObjetivosPlanes_Result> resultado = new List<C_ObtenerInformacionObjetivosPlanes_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionObjetivosPlanes().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ListadoBusquedaRecomendaciones")]
        public IEnumerable<C_ObtenerInformacionRecomendaciones_Result> GetListaRecomendacionesBusqueda(int idPregunta)
        {
            List<C_ObtenerInformacionRecomendaciones_Result> resultado = new List<C_ObtenerInformacionRecomendaciones_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionRecomendaciones(idPregunta).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Elimina una Recomendación.
        /// </summary>
        /// <param name="idRecomendacion">Id de la recomendacion a Eliminar.</param>
        /// <param name="idObjetivoEspecifico">Id del Objetivo especifico de la Recomendacion.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EliminarRecomendacióndePlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramiento/RecomendacionesPlan/EliminarRecomendacion")]
        public C_AccionesResultado EliminarRecomendacion(RecomendacionPlanModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.D_PlanMejoramientoRecomendacionDelete(model.IdRecomendacion).FirstOrDefault();

                    int cantRecomendaciones = bd.C_ObtenerCantidadRecomendacionesObjetivo(model.IdObjetivoEspecifico).FirstOrDefault().Value;

                    //Se elimina también el objetivo especifico
                    if (cantRecomendaciones == 0)
                    {
                        resultado = bd.D_PlanMejoramientoObjetivoEspecificoDelete(model.IdObjetivoEspecifico).FirstOrDefault();
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
        /// Inserta un nuevo Objetivo Específico y recomendaciones.
        /// </summary>
        /// <param name="model">Entidad con los datos a insertar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.CrearObjetivoEspecificoenPlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramiento/RecomendacionesPlan/InsertarObjetivoRecomendaciones")]
        public C_AccionesResultado InsertarRecomendaciones(ObjetivoEspecificoPlan model)
        {
            C_AccionesResultado resultadoObjetivo = new C_AccionesResultado();
            C_AccionesResultado resultadoRecomendaciones = new C_AccionesResultado();
            C_AccionesResultado resultadoGeneral = new C_AccionesResultado();
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    //Insertamos el objetivo especifico
                    resultadoObjetivo = bd.I_PlanMejoramientoObjetivoEspecificoInsert(model.objetivoEspecifico, model.porcObjetivo, model.idSeccion).FirstOrDefault();

                    //Obtenemos el id del objetivo especifico
                    int idObjetivo = int.Parse(resultadoObjetivo.respuesta.Split('|')[1].ToString());

                    //Insertamos las recomendaciones
                    for (int i = 0; i < model.recomendaciones.Count(); i++)
                    {
                        var recomendacion = model.recomendaciones.ElementAt(i);

                        if (recomendacion.aplica)
                        {
                            int? idEtapa = bd.C_ObtenerIdPadrePregunta(recomendacion.idPregunta).FirstOrDefault();

                            resultadoRecomendaciones = bd.I_PlanMejoramientoRecomendacionInsert(recomendacion.texto, recomendacion.calificacion, idObjetivo, recomendacion.opcion, recomendacion.idPregunta, idEtapa.HasValue ? idEtapa.Value : 0).FirstOrDefault();
                        }
                    }

                    //verificamos si se guardaron datos basura (objetivo sin recomendacion)
                    int cantRecomendaciones = bd.C_ObtenerCantidadRecomendacionesObjetivo(idObjetivo).FirstOrDefault().Value;

                    //Se elimina también el objetivo especifico
                    if (cantRecomendaciones == 0)
                    {
                        resultado = bd.D_PlanMejoramientoObjetivoEspecificoDelete(idObjetivo).FirstOrDefault();
                    }
                }

                if (resultado.estado == 3)
                {
                    resultadoGeneral.estado = 2;
                    resultadoGeneral.respuesta = "No se ha guardado el objetivo específico debido a que no se cargaron recomendaciones.";
                }
                else
                {
                    if (resultadoObjetivo.estado == 1 && resultadoRecomendaciones.estado == 1)
                    {
                        resultadoGeneral.estado = 1;
                        resultadoGeneral.respuesta = "Se ha(n) guardado la(s) recomendación(es)";
                    }
                    else
                    {
                        if (resultadoObjetivo.estado == 0)
                        {
                            resultadoGeneral = resultadoObjetivo;
                        }
                        if (resultadoRecomendaciones.estado == 0)
                        {
                            resultadoGeneral = resultadoRecomendaciones;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                resultadoGeneral.estado = 0;
                resultadoGeneral.respuesta = "Ha ocurrido un error guardando las recomendaciones. Por favor intente de nuevo.";
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultadoGeneral;
        }

        #endregion

        #region Tipos de Recurso Plan de Mejoramiento

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos de los tipos de recurso</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/RecursosPlan")]
        public IEnumerable<C_ObtenerTiposRecurso_Result> GetListadoRecursos()
        {
            IEnumerable<C_ObtenerTiposRecurso_Result> resultado = Enumerable.Empty<C_ObtenerTiposRecurso_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerTiposRecurso().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Inserta un nuevo tipo de recurso.
        /// </summary>
        /// <param name="model">Entidad con los datos a insertar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.CrearRecursoPlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramiento/RecursosPlan/InsertarRecurso")]
        public C_AccionesResultado InsertarRecurso(TipoRecurso model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.I_PlanMejoramientoRecursoInsert(model.nombreTipo, model.clase).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Actualiza los datos de un tipo de recurso.
        /// </summary>
        /// <param name="model">Entidad con los datos a actualizar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EditarRecursoPlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramiento/RecursosPlan/ActualizarRecurso")]
        public C_AccionesResultado ActualizarRecurso(TipoRecurso model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.U_PlanMejoramientoRecursoUpdate(model.idTipo, model.nombreTipo, model.clase).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Elimina un tipo de recurso.
        /// </summary>
        /// <param name="idTipo">Entidad con los datos a actualizar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EliminarRecursoPlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramiento/RecursosPlan/EliminarRecurso")]
        public C_AccionesResultado EliminarRecurso(TipoRecurso model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.D_PlanMejoramientoRecursoDelete(model.idTipo).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        #endregion

        #region Diligenciamiento Plan

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con las secciones del plan de mejoramiento para diligenciar</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/ListadoSeccionesPlan")]
        public IEnumerable<C_ObtenerInformacionSeccionesPlanMejoramiento_Result> GetListadoSeccionesPlan(int idPlan, int idUsuario)
        {
            IEnumerable<C_ObtenerInformacionSeccionesPlanMejoramiento_Result> resultado = Enumerable.Empty<C_ObtenerInformacionSeccionesPlanMejoramiento_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionSeccionesPlanMejoramiento(idPlan, idUsuario).ToList();
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos de las recomendaciones por seccion del plan de mejoramiento </returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/ListadoRecomendacionesDiligenciamientoPlan")]
        public IEnumerable<C_ObtenerInformacionPlanMejoramiento_Result> GetListadoRecomendacionesDiligenciamientoPlan(int idPlan, int idUsuario, int idSeccion)
        {
            IEnumerable<C_ObtenerInformacionPlanMejoramiento_Result> resultado = Enumerable.Empty<C_ObtenerInformacionPlanMejoramiento_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionPlanMejoramiento(idPlan, idSeccion, idUsuario).ToList();
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Validacion del diligenciamiento del plan, para el usuario especifido</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/ValidarDiligenciamientoPlan")]
        public bool ValidarDiligenciamientoPlan(int idPlan, int idUsuario)
        {
            bool resultado = false;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ValidarPermisoGuardadoPlan(idUsuario, idPlan).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Validacion de envio del plan, para el usuario especifido</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/ValidarEnvioPlan")]
        public bool ValidarEnvioPlan(int idPlan, int idUsuario)
        {
            bool resultado = false;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    var result = bd.C_ObtenerTotalesParaEnviar(idPlan, idUsuario).FirstOrDefault();

                    resultado = result.TotalDiligenciado == result.Total_a_Diligenciar;
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Validacion del diligenciamiento del plan, para el usuario especifido</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/PorcentajePlanMejoramiento")]
        public decimal PorcentajePlanMejoramiento(int idPlan, int idUsuario)
        {
            decimal resultado = Decimal.Zero;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = decimal.Parse(bd.C_ObtenerInformacionPorcentajeCumplimientoPlan(idPlan, idUsuario).FirstOrDefault().TotalGral.ToString());
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Validacion del diligenciamiento del plan, para el usuario especifido</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/ArchivoFinalizacionPlan")]
        public string ArchivoFinalizacionPlan(int idPlan, int idUsuario)
        {
            string resultado = string.Empty;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerFinalizacionPlan(idPlan, idUsuario).FirstOrDefault().RutaArchivo;
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }
        
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Validacion del diligenciamiento del plan, para el usuario especifido</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/MensajeEnvioPlan")]
        public string MensajeEnvioPlan()
        {
            string resultado = string.Empty;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    C_DatosSistema_Result sistema = bd.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                    resultado = sistema.SaveMessageConfirmPopup;
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Validacion del diligenciamiento del plan, para el usuario especifido</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/ObtenerDatosPlan")]
        public C_ObtenerDatosPlanMejoramiento_Result ObtenerDatosPlan(int idPlan)
        {
            C_ObtenerDatosPlanMejoramiento_Result resultado = new C_ObtenerDatosPlanMejoramiento_Result();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerDatosPlanMejoramiento(idPlan).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Validacion del diligenciamiento del plan, para el usuario especifido</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/ObtenerPlanEncuesta")]
        public int ObtenerPlanEncuesta(int idEncuesta)
        {
            int resultado = 0;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerIdPlanByEncuestaID(idEncuesta).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Validacion del diligenciamiento del plan, para el usuario especifido</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/ObtenerTipoPlanEncuesta")]
        public int ObtenerTipoPlanEncuesta(int idEncuesta)
        {
            int resultado = 0;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerTipoPlanEncuesta(idEncuesta).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Validacion del diligenciamiento del plan, para el usuario especifido</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/ValidarPreguntasObligatorias")]
        public IEnumerable<c_ValidarRespuestasPreguntasObligatorias_Result> ValidarPreguntasObligatorias(int idEncuesta, int idUsuario)
        {
            IEnumerable<c_ValidarRespuestasPreguntasObligatorias_Result> resultado = Enumerable.Empty<c_ValidarRespuestasPreguntasObligatorias_Result>(); 

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.c_ValidarRespuestasPreguntasObligatorias(idEncuesta, idUsuario).ToList();
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos del listado de avances </returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/ListadoAvances")]
        public IEnumerable<C_ObtenerTiposAvance_Result> GetListadoAvancesDiligenciamientoPlan()
        {
            IEnumerable<C_ObtenerTiposAvance_Result> resultado = Enumerable.Empty<C_ObtenerTiposAvance_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerTiposAvance().ToList();
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos del listado de avances </returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/ListadoAutoevaluacion")]
        public IEnumerable<C_ObtenerTiposAutoEvaluacion_Result> GetListadoAutoevaluacionDiligenciamientoPlan()
        {
            IEnumerable<C_ObtenerTiposAutoEvaluacion_Result> resultado = Enumerable.Empty<C_ObtenerTiposAutoEvaluacion_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerTiposAutoEvaluacion().ToList();
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos del listado de avances </returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramiento/Diligenciamiento/RecursosRecomendacion")]
        public IEnumerable<C_ObtenerRecursosRecomendacion_Result> GetRecursosRecomendacionDiligenciamientoPlan(int idRecomendacion, int idUsuario)
        {
            IEnumerable<C_ObtenerRecursosRecomendacion_Result> resultado = Enumerable.Empty<C_ObtenerRecursosRecomendacion_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerRecursosRecomendacion(idRecomendacion, idUsuario).ToList();
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        /// <summary>
        /// Guarda las respuestas del plan de mejoramiento.
        /// </summary>
        /// <returns>Task&lt;HttpResponseMessage&gt;.</returns>
        [HttpPost]
        [Route("api/Sistema/Diligenciamiento/GuardarDiligenciamientoPlan")]
        public C_AccionesResultado GuardarDiligenciamientoPlan(IEnumerable<SeccionesDiligenciamientoPlan> model)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            try
            {
                int cantidadSecciones = model.Count();
                int idUsuario = model.First().IdUsuario;
                int idPlan = model.First().IdPlan;

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    for(int i = 0; i < cantidadSecciones; i++)
                    {
                        var seccion = model.ElementAt(i);

                        int cantRecomendaciones = seccion.recomendaciones.Count();

                        for(int j = 0; j < cantRecomendaciones; j++)
                        {
                            var recomendacion = seccion.recomendaciones.ElementAt(j);

                            //Se eliminan las respuestas anteriores por recomendacion
                            BD.D_PlanMejoramientoRespuestasDelete(recomendacion.IdRecomendacion, idUsuario);

                            //Agregar Accion
                            BD.I_PlanMejoramientoAccionesPlanInsert(recomendacion.IdRecomendacion, idUsuario, recomendacion.Accion, recomendacion.AccionResponsable, recomendacion.AccionFecha);

                            //Agregar Avance
                            BD.I_PlanMejoramientoAvancesPlanInsert(recomendacion.IdRecomendacion, idUsuario, recomendacion.IdAvance);

                            //Agregar Autoevaluacion
                            BD.I_PlanMejoramientoAutoEvaluacionPlanInsert(recomendacion.IdRecomendacion, idUsuario, recomendacion.IdAutoEv);

                            //Agregar recursos, solo si estan checkeados
                            int cantRecursos = recomendacion.recursos.Count();

                            for (int k = 0; k < cantRecursos; k++)
                            {
                                var recurso = recomendacion.recursos.ElementAt(k);

                                if(recurso.Seleccionado)
                                {
                                    BD.I_PlanMejoramientoRecursoPlanInsert(recomendacion.IdRecomendacion, recurso.IdTipoRecurso, recurso.ValorRecurso, idUsuario);
                                }
                            }
                        }
                    }
                }

                Resultado.estado = 1;
                Resultado.respuesta = "Se ha guardado la información del Diligenciamiento del Plan de Mejoramiento";
            }
            catch (Exception ex)
            {
                Resultado.estado = 0;
                Resultado.respuesta = "Ocurrió un error guardando la información del Diligenciamiento del Plan de Mejoramiento";

                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            finally
            {
                //(new AuditExecuted(Category.EditarHomeMint)).ActionExecutedManual(model);
            }

            //// Retorna la respuesta de la transacción
            return Resultado;
        }


        /// <summary>
        /// Guarda las respuestas del plan de mejoramiento.
        /// </summary>
        /// <returns>Task&lt;HttpResponseMessage&gt;.</returns>
        [HttpPost]
        [Route("api/Sistema/Diligenciamiento/GuardarArchivoDiligenciamientoPlan")]
        public async Task<HttpResponseMessage> GuardarDiligenciamientoPlan()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            if (!this.Request.Content.IsMimeMultipartContent())
            {
                this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Helpers.Utilitarios.GetMultipartProvider();
            var result = await this.Request.Content.ReadAsMultipartAsync(provider);
            PlanMejoramientoDiligenciamiento model = (PlanMejoramientoDiligenciamiento)Helpers.Utilitarios.GetFormData<PlanMejoramientoDiligenciamiento>(result);

            var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
            var arc = new FileInfo(result.FileData.First().LocalFileName);

            var archivo = File.ReadAllBytes(result.FileData.First().LocalFileName);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Carpeta Compartida en Sistema
                    C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                    //Guardar archivo en carpeta compartida
                    Archivo.GuardarArchivoPlanMejoramiento(archivo, sistema.UploadDirectory, OriginalFileName, model.userName);

                    Resultado = BD.I_PlanMejoramientoFinalizacionPlanInsert(model.IdPlan, model.IdUsuario, OriginalFileName).FirstOrDefault();
                }

                //Resultado.estado = 1;
                //Resultado.respuesta = "Se ha guardado la información del Diligenciamiento del Plan de Mejoramiento";
            }
            catch (Exception ex)
            {
                Resultado.estado = 0;
                Resultado.respuesta = "Ocurrió un error guardando la información del Diligenciamiento del Plan de Mejoramiento";

                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            finally
            {
                //(new AuditExecuted(Category.EditarHomeMint)).ActionExecutedManual(model);
            }

            //// Retorna la respuesta de la transacción
            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }


        /// <summary>
        /// Guarda las respuestas del plan de mejoramiento.
        /// </summary>
        /// <returns>Task&lt;HttpResponseMessage&gt;.</returns>
        [HttpPost]
        [Route("api/Sistema/Diligenciamiento/EnviarPlan")]
        public C_AccionesResultado EnviarPlan(PlanMejoramientoDiligenciamiento model)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    Resultado = BD.U_PlanMejoramientoFinalizacionUpdate(model.IdPlan, model.IdUsuario).FirstOrDefault();

                    if(Resultado.estado == (int)EstadoRespuesta.Insertado)
                    {
                        var usuario = BD.C_Usuario(model.IdUsuario, null, null, null, null, null, null).Cast<C_Usuario_Result>().FirstOrDefault();
                        var datosPlan = BD.C_ObtenerDatosPlanMejoramiento(model.IdPlan).FirstOrDefault();

                        C_DatosSistema_Result datosSistema = BD.C_DatosSistema().First();
                        Helpers.Utilitarios.EnviarCorreoFinalizacionPlan(ref Resultado, new string[] { usuario.Email != null && !string.IsNullOrEmpty(usuario.Email) ? usuario.Email : (usuario.EmailAlternativo != null && !String.IsNullOrEmpty(usuario.EmailAlternativo)) ? usuario.EmailAlternativo : datosSistema.FromEmail }, datosPlan, usuario.UserName, datosSistema);

                        //// Valida si envió el correo, de lo contrario, elimina el usuario 
                        if (Resultado.estado == (int)EstadoRespuesta.Excepcion)
                        {
                            Resultado.estado = 0;
                            Resultado.respuesta = "Ocurrió un error finalizando el Plan de Mejoramiento. Por favor intente de nuevo";
                        }
                        else
                        {
                            Resultado.estado = 1;
                            Resultado.respuesta = "El Plan de Mejoramiento ha sido Enviado";
                        }
                    }                    
                }
            }
            catch (Exception ex)
            {
                Resultado.estado = 0;
                Resultado.respuesta = "Ocurrió un error guardando la información del Diligenciamiento del Plan de Mejoramiento";
            }
            finally
            {
            }

            //// Retorna la respuesta de la transacción
            return Resultado;
        }


        /// <summary>
        /// Descargars the specified archivo.
        /// </summary>
        /// <param name="nombreArchivo">The nombre archivo.</param>
        /// <param name="usuario">The usuario.</param>
        /// <returns>HttpResponseMessage.</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/Sistema/Diligenciamiento/PlanMejoramientoDownload/")]
        public HttpResponseMessage Descargar(string nombreArchivo, string usuario)
        {
            try
            {
                string directorio = "";
                string dirSeguimiento = Archivo.pathPlanMejoraFiles;
                directorio = Path.Combine(usuario, nombreArchivo);
                return Archivo.Descargar(directorio, directorio, Archivo.pathPlanMejoraFiles);
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return null;
            }
        }

        #endregion
    }
}