// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 11-20-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 11-20-2017
// ***********************************************************************
// <copyright file="GestionPlanesMejoramientoV3Controller.cs" company="Ministerio del Interior">
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
    using ClosedXML.Excel;
    using System.Net.Http.Headers;

    /// <summary>
    /// Class GestionPlanesMejoramientoV3Controller.
    /// </summary>
    [Authorize]
    public class GestionPlanesMejoramientoV3Controller : ApiController
    {
        #region Configuración Plan de Mejoramiento


        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/ListadoPlanes")]
        public IEnumerable<C_ObtenerListadoPlanes_Result> Get()
        {
            IEnumerable<C_ObtenerListadoPlanes_Result> resultado = Enumerable.Empty<C_ObtenerListadoPlanes_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerListadoPlanes(3).ToList();
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
        [Route("api/Sistema/PlanesMejoramientoV3/ListadoEncuestasSinResponder")]
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
        [Route("api/Sistema/PlanesMejoramientoV3/ListadoEncuestasPlan")]
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
        [Route("api/Sistema/PlanesMejoramientoV3/InsertarPlanMejoramiento")]
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
                        var plan = bd.C_ObtenerListadoPlanes(3).Where(x => x.Nombre.Equals(model.nombrePlan)).First();

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
        [Route("api/Sistema/PlanesMejoramientoV3/DatosActivacionPlan")]
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
        [Route("api/Sistema/PlanesMejoramientoV3/ActivarPlan")]
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
        [Route("api/Sistema/PlanesMejoramientoV3/ActualizarPlanMejoramiento")]
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
        /// <returns>Resultado de la validacion previo a la activacion de un plan de mejoramiento</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/ValidarActivacionPlan")]
        public bool ValidarActivacionPlan(int idPlan)
        {
            bool resultado = false;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    var porc = bd.C_ValidarActivarPlanMejoramientoV3(idPlan).FirstOrDefault();

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
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/SeccionesPlan/ListadoSecciones")]
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
        [Route("api/Sistema/PlanesMejoramientoV3/SeccionesPlan/InsertarSeccion")]
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
        [Route("api/Sistema/PlanesMejoramientoV3/SeccionesPlan/ActualizarSeccion")]
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
        [Route("api/Sistema/PlanesMejoramientoV3/SeccionesPlan/SeccionesEncuestas")]
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
        [HttpPost, AuditExecuted(Category.EliminarObjetivoGeneralPlan)]
        [Route("api/Sistema/PlanesMejoramientoV3/SeccionesPlan/EliminarSeccion")]
        public C_AccionesResultado EliminarSeccion(SeccionPlanMejoramientoModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.D_PlanMejoramientoSeccionV3Delete(model.idSeccion).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        //Objetivos generales //
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="idSeccion">The identifier seccion.</param>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/ObjetivosGenerales/ListadoObjetivos")]
        public IEnumerable<C_ObtenerInformacionObjetivosGeneralesPlanMejoramiento_Result> GetListadoObjetivosGenerales(int idSeccion)
        {
            IEnumerable<C_ObtenerInformacionObjetivosGeneralesPlanMejoramiento_Result> resultado = Enumerable.Empty<C_ObtenerInformacionObjetivosGeneralesPlanMejoramiento_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionObjetivosGeneralesPlanMejoramiento(idSeccion).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Inserta un nuevo objetivo a una seccion de un Plan de Mejoramiento.
        /// </summary>
        /// <param name="model">Entidad con los datos a insertar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.CrearObjetivoGeneralPlan)]
        [Route("api/Sistema/PlanesMejoramientoV3/ObjetivosGenerales/InsertarObjetivo")]
        public C_AccionesResultadoInsert InsertarObjetivoGeneral(ObjetivoGeneralPlanMejoramientoModel model)
        {
            C_AccionesResultadoInsert resultado = new C_AccionesResultadoInsert();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.I_PlanMejoramientoObjetivoGeneralInsert(model.objetivoGeneral, model.idSeccion).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Actualiza un objetivo general de una sección de un Plan de Mejoramiento.
        /// </summary>
        /// <param name="model">Entidad con los datos a insertar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EditarObjetivoGeneralPlan)]
        [Route("api/Sistema/PlanesMejoramientoV3/ObjetivosGenerales/ActualizarObjetivo")]
        public C_AccionesResultado ActualizarObjetivoGeneral(ObjetivoGeneralPlanMejoramientoModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.U_ObjetivoGeneralPlanMejoramientoUpdate(model.idObjetivoGeneral, model.objetivoGeneral).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Elimina un objetivo general.
        /// </summary>
        /// <param name="model">datos de la entidad del objetivo general a Eliminar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EliminarseccióndePlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramientoV3/ObjetivosGenerales/EliminarObjetivo")]
        public C_AccionesResultado EliminarObjetivoGeneral(ObjetivoGeneralPlanMejoramientoModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.D_PlanMejoramientoObjetivoGeneralDelete(model.idObjetivoGeneral).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        //Estrategias y acciones
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="idSeccion">The identifier seccion.</param>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/TareasPlan/ListadoTareas")]
        public IEnumerable<C_ObtenerInformacionTareasPlanMejoramiento_Result> GetListadoRecomendaciones(int idObjetivoGeneral)
        {
            IEnumerable<C_ObtenerInformacionTareasPlanMejoramiento_Result> resultado = Enumerable.Empty<C_ObtenerInformacionTareasPlanMejoramiento_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionTareasPlanMejoramiento(idObjetivoGeneral).ToList();
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
        [Route("api/Sistema/PlanesMejoramientoV3/TareasPlan/ListadoPreguntasPlan")]
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
        [Route("api/Sistema/PlanesMejoramientoV3/TareasPlan/ListadoOpcionesPreguntaAsociada")]
        public IEnumerable<OpcionesPreguntaRecomendacionPlan> GetListaOpcionesPregunta(int idPregunta)
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
                else
                {
                    for (int i = 0; i < opcionesBD.Count; i++)
                    {
                        if(opcionesBD.ElementAt(i).Orden != -1)
                        {
                            OpcionesPreguntaRecomendacionPlan opcion = new OpcionesPreguntaRecomendacionPlan();

                            opcion.Valor = opcionesBD.ElementAt(i).Valor;
                            opcion.Texto = opcionesBD.ElementAt(i).Texto;

                            resultado.Add(opcion);
                        }
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
        [Route("api/Sistema/PlanesMejoramientoV3/TareasPlan/ListadoBusquedaEstrategias")]
        public IEnumerable<C_ObtenerInformacionEstrategiasPlanes_Result> GetListaEstrategiasBusqueda()
        {
            List<C_ObtenerInformacionEstrategiasPlanes_Result> resultado = new List<C_ObtenerInformacionEstrategiasPlanes_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionEstrategiasPlanes().ToList();
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
        [Route("api/Sistema/PlanesMejoramientoV3/TareasPlan/ListadoBusquedaTareas")]
        public IEnumerable<C_ObtenerInformacionTareasPlanes_Result> GetListadoBusquedaTareas(int idPregunta)
        {
            List<C_ObtenerInformacionTareasPlanes_Result> resultado = new List<C_ObtenerInformacionTareasPlanes_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionTareasPlanes(idPregunta).ToList();
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
        [Route("api/Sistema/PlanesMejoramientoV3/TareasPlan/EliminarTareas")]
        public C_AccionesResultado EliminarTareas(TareasPlanModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.D_PlanMejoramientoTareaDelete(model.IdTarea).FirstOrDefault();

                    int cantTareas = bd.C_ObtenerCantidadTareasEstrategia(model.IdEstrategia).FirstOrDefault().Value;

                    //Se elimina también el objetivo especifico
                    if (cantTareas == 0)
                    {
                        resultado = bd.D_PlanMejoramientoEstrategiaDelete(model.IdEstrategia).FirstOrDefault();
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
        [Route("api/Sistema/PlanesMejoramientoV3/TareasPlan/InsertarEstrategiaTareas")]
        public C_AccionesResultado InsertarTareas(EstrategiaPlan model)
        {
            C_AccionesResultadoInsert resultadoEstrategia = new C_AccionesResultadoInsert();
            C_AccionesResultado resultadoTarea = new C_AccionesResultado();
            C_AccionesResultado resultadoGeneral = new C_AccionesResultado();
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    //Insertamos el objetivo especifico
                    resultadoEstrategia = bd.I_PlanMejoramientoEstrategiaInsert(model.estrategia, model.idObjetivoGeneral).FirstOrDefault();

                    //Obtenemos el id del objetivo especifico
                    int idEstrategia = resultadoEstrategia.id.Value;

                    //Insertamos las recomendaciones
                    for (int i = 0; i < model.tareas.Count(); i++)
                    {
                        var tarea = model.tareas.ElementAt(i);
                        
                        if(tarea.aplica)
                        {
                            int? idEtapa = bd.C_ObtenerIdPadrePregunta(tarea.idPregunta).FirstOrDefault();

                            for(int j = 0; j < tarea.tareas.Count; j++)
                            {
                                resultadoTarea = bd.I_PlanMejoramientoTareaInsert(tarea.tareas[j], idEstrategia, tarea.opcion, tarea.idPregunta, idEtapa.HasValue ? idEtapa.Value : 0).FirstOrDefault();
                            }                            
                        }
                    }

                    //verificamos si se guardaron datos basura (estrategia sin tareas)
                    int cantTareas = bd.C_ObtenerCantidadTareasEstrategia(idEstrategia).FirstOrDefault().Value;

                    //Se elimina también la estrategia
                    if (cantTareas == 0)
                    {
                        resultado = bd.D_PlanMejoramientoEstrategiaDelete(idEstrategia).FirstOrDefault();
                    }
                }

                if (resultado.estado == 3)
                {
                    resultadoGeneral.estado = 2;
                    resultadoGeneral.respuesta = "No se ha guardado la estrategia debido a que no se cargaron acciones.";
                }
                else
                {
                    if (resultadoEstrategia.estado == 1 && resultadoTarea.estado == 1)
                    {
                        resultadoGeneral.estado = 1;
                        resultadoGeneral.respuesta = "Se ha(n) guardado la(s) acción(es)";
                    }
                    else
                    {
                        if (resultadoEstrategia.estado == 0)
                        {
                            resultadoGeneral.estado = resultadoEstrategia.estado;
                            resultadoGeneral.respuesta = resultadoEstrategia.respuesta;
                        }
                        if (resultadoTarea.estado == 0)
                        {
                            resultadoGeneral = resultadoTarea;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                resultadoGeneral.estado = 0;
                resultadoGeneral.respuesta = "Ha ocurrido un error guardando las acciones. Por favor intente de nuevo.";
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultadoGeneral;
        }

        #endregion

        #region Diligenciamiento Plan

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con las secciones del plan de mejoramiento para diligenciar</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoSeccionesPlan")]
        public IEnumerable<C_ObtenerInformacionSeccionesPlanMejoramientoV3_Result> GetListadoSeccionesPlan(int idPlan)
        {
            IEnumerable<C_ObtenerInformacionSeccionesPlanMejoramientoV3_Result> resultado = Enumerable.Empty<C_ObtenerInformacionSeccionesPlanMejoramientoV3_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionSeccionesPlanMejoramientoV3(idPlan).ToList();
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
        /// <returns>Lista con los datos de las estrategias por seccion del plan de mejoramiento </returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoEstrategiasDiligenciamientoPlan")]
        public IEnumerable<C_ObtenerInformacionPlanMejoramientoV3_Result> GetListadoEstrategiasDiligenciamientoPlan(int idPlan, int idUsuario, int idSeccion)
        {
            IEnumerable<C_ObtenerInformacionPlanMejoramientoV3_Result> resultado = Enumerable.Empty<C_ObtenerInformacionPlanMejoramientoV3_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionPlanMejoramientoV3(idPlan, idSeccion, idUsuario).ToList();
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
        /// <returns>Lista con los datos de las tareas seleccionadas por seccion del plan de mejoramiento </returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoTareasDiligenciamientoPlan")]
        public IEnumerable<C_ObtenerInformacionTareasDiligenciadasPlanMejoramientoV3_Result> GetListadoTareasDiligenciamientoPlan(int idEstrategia, int idUsuario)
        {
            IEnumerable<C_ObtenerInformacionTareasDiligenciadasPlanMejoramientoV3_Result> resultado = Enumerable.Empty<C_ObtenerInformacionTareasDiligenciadasPlanMejoramientoV3_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionTareasDiligenciadasPlanMejoramientoV3(idEstrategia, idUsuario).ToList();
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
        /// <returns>Lista con los datos de las tareas a diligenciar por seccion del plan de mejoramiento </returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoTareasDiligenciarPlan")]
        public IEnumerable<C_ObtenerInformacionTareasPlanMejoramientoV3_Result> GetListadoTareasDiligenciarPlan(int idEstrategia, int idUsuario, string opcion)
        {
            IEnumerable<C_ObtenerInformacionTareasPlanMejoramientoV3_Result> resultado = Enumerable.Empty<C_ObtenerInformacionTareasPlanMejoramientoV3_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ObtenerInformacionTareasPlanMejoramientoV3(idEstrategia, idUsuario, opcion).ToList();
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
        /// <returns>Validacion del diligenciamiento del plan, para el usuario especifido</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ValidarDiligenciamientoPlan")]
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
        /// <returns>Validacion del diligenciamiento del plan, para el usuario especifido</returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ArchivoFinalizacionPlan")]
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
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/MensajeEnvioPlan")]
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
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ObtenerDatosPlan")]
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
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ObtenerPlanEncuesta")]
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
        /// <returns>Lista con los datos del listado de avances </returns>
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoAutoevaluacion")]
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
        /// Guarda las respuestas del plan de mejoramiento.
        /// </summary>
        /// <returns>Task&lt;HttpResponseMessage&gt;.</returns>
        [HttpPost, AuditExecuted(Category.CrearRespuestaPlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/GuardarDiligenciamientoPlan")]
        public C_AccionesResultado GuardarDiligenciamientoPlan(PlanMejoramientoV3Diligenciamiento model)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            try
            {
                int cantidadTareas = model.tareas.Count();

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Eliminamos respuestas anteriores
                    BD.D_PlanMejoramientoRespuestasV3Delete(model.IdPlan, model.IdUsuario);

                    for(int i = 0; i < cantidadTareas; i++)
                    {
                        var tarea = model.tareas.ElementAt(i);

                        BD.I_PlanMejoramientoTareasPlanInsert(tarea.IdTarea, model.IdUsuario, tarea.Responsable, tarea.FechaInicioEjecucion, tarea.FechaFinEjecucion, tarea.IdAutoevaluacion);
                    }
                }

                Resultado.estado = 1;
                Resultado.respuesta = "La información diligenciada ha sido guardada satisfactoriamente";
            }
            catch (Exception ex)
            {
                Resultado.estado = 0;
                Resultado.respuesta = "Ocurrió un error guardando la información del Plan de Mejoramiento. Por favor intente nuevamente.";

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
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/GuardarArchivoDiligenciamientoPlan")]
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
            PlanMejoramientoDiligenciamientoFile model = (PlanMejoramientoDiligenciamientoFile)Helpers.Utilitarios.GetFormData<PlanMejoramientoDiligenciamientoFile>(result);

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
                    //Archivo.GuardarArchivoPlanMejoramientoV3(archivo, sistema.UploadDirectory, OriginalFileName, model.userName, model.IdPlan.ToString());

                    //Guardar archivo en carpeta compartida -- File Server
                    Archivo.GuardarArchivoPlanMejoramientoV3Shared(archivo, sistema.UploadDirectory, OriginalFileName, model.userName, model.IdPlan.ToString());

                    Resultado = BD.I_PlanMejoramientoFinalizacionPlanInsert(model.IdPlan, model.IdUsuario, OriginalFileName).FirstOrDefault();

                    AdjuntoArchivoPlanModel adjunto = new AdjuntoArchivoPlanModel() { IdPlan = model.IdPlan, Valor = OriginalFileName, IdUsuario = model.IdUsuario, Username = model.userName };

                    (new AuditExecuted(Category.AdjuntarArchivoenPlandeMejoramiento)).ActionExecutedManual(adjunto);
                }

                //Resultado.estado = 1;
                //Resultado.respuesta = "Se ha guardado la información del Diligenciamiento del Plan de Mejoramiento";
            }
            catch (Exception ex)
            {
                Resultado.estado = 0;
                Resultado.respuesta = "Ocurrió un error guardando la información del Diligenciamiento del Plan de Mejoramiento";

                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
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
        [HttpPost, AuditExecuted(Category.EnviodePlandeMejoramiento)]
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/EnviarPlan")]
        public C_AccionesResultado EnviarPlan(PlanMejoramientoDiligenciamiento model)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Validamos primero si el usuario está habilitado para enviar el plan
                    bool habilitado = false;

                    var validacion = BD.C_ValidarEnvioPlanV3(model.IdPlan, model.IdUsuario, "P").First();

                    if(validacion != null)
                    {
                        habilitado = validacion.Value;

                        if(habilitado)
                        {
                            var finalizacion = BD.C_ObtenerFinalizacionPlan(model.IdPlan, model.IdUsuario).FirstOrDefault();

                            //Resultado = BD.U_PlanMejoramientoFinalizacionUpdate(model.IdPlan, model.IdUsuario).FirstOrDefault();
                            Resultado = BD.I_PlanMejoramientoEnvioPlanInsert(model.IdPlan, model.IdUsuario, finalizacion == null ? "" : finalizacion.RutaArchivo, "P", null).FirstOrDefault();

                            if (Resultado.estado == (int)EstadoRespuesta.Insertado)
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
                                    BD.I_GuardarEnvioPlanMejoramientoEncuesta(model.IdPlan, model.IdUsuario);

                                    Resultado.estado = 1;
                                    Resultado.respuesta = "El Reporte RUSICST junto con el Plan de Mejoramiento han sido enviados de manera exitosa. En los próximos minutos recibirá un mensaje de confirmación en el correo electrónico registrado en el Sistema.";
                                }
                            }
                        } else
                        {
                            Resultado.estado = 0;
                            Resultado.respuesta = "El Plan de Mejoramiento está incompleto y no se puede enviar. Por favor, verifique que exista al menos una Acción en cada Estrategia.";
                        }
                    } else
                    {
                        Resultado.estado = 0;
                        Resultado.respuesta = "Ocurrió un error validando el envío del Plan de Mejoramiento. Por favor intente de nuevo";
                    }                                       
                }
            }
            catch (Exception ex)
            {
                Resultado.estado = 0;
                Resultado.respuesta = "Ocurrió un error enviando el Plan de Mejoramiento. Por favor intente nuevamente.";
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
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/PlanMejoramientoDownload/")]
        public HttpResponseMessage Descargar(string nombreArchivo, string usuario, string idPlan)
        {
            try
            {
                string directorio = "";
                string dirSeguimiento = Archivo.pathPlanMejoraFiles;
                directorio = Path.Combine(dirSeguimiento, usuario, idPlan);
                //return Archivo.Descargar(directorio, directorio, Archivo.pathPlanMejoraFiles);
                return Archivo.DescargarEncuestaShared(directorio + '\\', nombreArchivo);
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return null;
            }
        }


        /// <summary>
        /// Descargars the specified archivo.
        /// </summary>
        /// <param name="nombreArchivo">The nombre archivo.</param>
        /// <param name="usuario">The usuario.</param>
        /// <returns>HttpResponseMessage.</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/Sistema/PlanesMejoramientoV3/Diligenciamiento/PlanMejoramientoDownloadExcel/")]
        public HttpResponseMessage DescargarExcel(int idUsuario, int idPlan)
        {
            try
            {
                HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

                // Create the workbook
                var workbook = new XLWorkbook();
                var ws = workbook.Worksheets.Add("Plan de Mejoramiento");

                //var img = Convert.FromBase64String("iVBORw0KGgoAAAANSUhEUgAAAtsAAAA1CAYAAACQoSdzAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2hpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDowODgwMTE3NDA3MjA2ODExODIyQUZFQTUxMjkyRjQyNSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo5QzM0RDlBNjZDRjcxMUU0QkNFMUJFMzg3MjU2NUU0NiIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo5QzJENzJBNjZDRjcxMUU0QkNFMUJFMzg3MjU2NUU0NiIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChNYWNpbnRvc2gpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MDI4MDExNzQwNzIwNjgxMThDMTRCNjY2RTJEQjAzOUMiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MDg4MDExNzQwNzIwNjgxMTgyMkFGRUE1MTI5MkY0MjUiLz4gPC9yZGY6RGVzY3Jp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");
                //var imgMin = Convert.FromBase64String("iVBORw0KGgoAAAANSUhEUgAAASQAAABCCAYAAAD+I6sfAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2hpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDowODgwMTE3NDA3MjA2ODExODIyQUZFQTUxMjkyRjQyNSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo5QzJENzI5RjZDRjcxMUU0QkNFMUJFMzg3MjU2NUU0NiIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo5QzJENzI5RTZDRjcxMUU0QkNFMUJFMzg3MjU2NUU0NiIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChNYWNpbnRvc2gpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MDI4MDExNzQwNzIwNjgxMThDMTRCNjY2RTJEQjAzOUMiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MDg4MDExNzQwNzIwNjgxMTgyMkFGRUE1MTI5MkY0MjUiLz4gPC9yZGY6RGVzY3Jp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");
                //var imgPais = Convert.FromBase64String("iVBORw0KGgoAAAANSUhEUgAAATkAAACLCAYAAAAalO47AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2hpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDowODgwMTE3NDA3MjA2ODExODIyQUZFQTUxMjkyRjQyNSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo5QzI1MTM0MDZDRjcxMUU0QkNFMUJFMzg3MjU2NUU0NiIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo5QzI1MTMzRjZDRjcxMUU0QkNFMUJFMzg3MjU2NUU0NiIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChNYWNpbnRvc2gpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MDI4MDExNzQwNzIwNjgxMThDMTRCNjY2RTJEQjAzOUMiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MDg4MDExNzQwNzIwNjgxMTgyMkFGRUE1MTI5MkY0MjUiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz6Y1bN1AAA89UlEQVR42uxdCZwU1dGvPuba+2IRhAVFUA7FSEQ5BLzwBlTUaDSaaDTxSvTTqPFOjLnUYKImJiYajcYTBS88QEC8jXIjKArLvey9O/d091c18wZnh75mpmd3Fl79fkUv092vX79+/e+qenUImqaBIAjAKXNSlrvduBmKPAi5jm37I9cwrkbui1yCPF46JPIBHzVOnLqP4vjGQc4WmHlxMxL5YOTRyMORD2TAJtpo4nEEuAv5SHLixEGuEABNYiA2Hnks8jgGaFKWTbYjD0OQ28FHlxMnDnI9BWrfQT4W+WjkCUy9dIquQYCbxacbJ04c5LoT2AbgZhryVOTJyBV5utQq5EMR5GJ8unHixEEu38B2KG6mI5+GPKabLns0AtxCPtU4ceIgly9gI9vaBcjnIg/u5ss/gwD3PT7NOHHiIOc0sPVjoHY+JGxtPUF+5AMR5LbwacaJEwc5J4CNboDsa5cjnwr23DrySTchwP2OTzFOnDjI5USRxRXDQBVmiSXhkYI7Vlcg3VqLfAiCXIRPMU6cOMhlB25LyqdqUWmWFpGGC24F5OrOQureSQhw8/j04sSJg1zm4PZuxQ+0qPhbLSL3j/+A3Zb7tIMgq4XSxRcR4M7gU4sTJw5ymUpu56LUdh+C2z6pv6OaClJZsFC6GUIejiC3gU8tTpwKB+TkAge3o1Et/bfaKQ9M3ydIKkiloULq7m85wHHiVHhUkJJc5L2y/RHcZmth12jQ9I+RKgMg+grGtv8N8ggEuRCfUpw4cXXVDNxkUMTH1JDrPFCNOyV4YoW22DAdAW4un1KcOHGQM1NNL9BC8t+0mFRkdaxc2wGCrBTKOL6GAHcKn06cOHGQ06Xo+6U1WkR+HaW379o5vsAWG0hfHoUg9yWfTpw4FSbI9WhkQOTd8qtVv2erXYADUSu0xYZ7OMBx4lTY1COSXPSD0hItLL+F4HZkJudJFQEQiwpmsWEzJOJTA3waceLE1dVvpbclZcdpYdccLWpte+uCxu4YyDUFtdhwNgLcc3waceLEQe5bgFtc8Wc16LoStMwvKPfpAMFVMIsN8xHgjuNTiBMnDnIJ9fTDEq8Wcn2I6unobM4Xi8MglRfMYgNl+R2NILeaTyFOnDjI0erpEAS3T7SIXJlVA6IGrtr2+LZAiBYbrufThxMnDnIEcMerAc+rWkx0ZdtGgS02bIfEYkM7nz6cOO3lIBd9r+wHit/9GKhi1o2TDY5scQVE5yPAPcmnDidOeznIRd4ru0Lt9DwAWm7tyjUdQPniCoSWIE9CkNP41OHEaS8GucgScvB1358rwJGKSqpqgRAh7RgEuGV82nDitBeDHALcJQhw/8gV4ApwseEBBLir+JThxGkvBrnIu+WnqgH33Gx84NKJ3EXIbaRAaCckFhta+JThxGkvBTkEuMPUoOtjUEUp104V4GLDxQhw/+LThROnvRTkIosrKItIvRYTfU50ikK3KISrQOhj5HEIciqfLpw47YUgF5pXKyAgbUSQG+hEhyjTL2X8LZTxQR6LAPcpnyqcOPVekMsp1ZLgjb7kFMAh3IJYVlBplP7JAY4Tp95PWUtykUUVP1SDbsdsVZQIkxJiFgjRIsMwBLlGPkU4cdoL1dXIoso+aljaAmr24VpdkFZW4/VToXDq6VyBAPcQnyKcOPV+kMuqJKGmCPOdAri4FFce6BGA02IiaAEZVGQtjBySyBDX5urn/3siszknTpx6O2UMcijFXaYG5YOd6oDojcarb+WdFAHUTjeyC1S/KwFskd09XuS+gZtcEztjfGpw4rRnUEbqanhBlQ8UsVlTRK9DV09U3pKc99DQoiKoHW7GBGq7C56CSw0JbqUeJI3CtRZoQfn14gs3b+TTghOnvVVdFbVHtYhDAEdqaknYOYBTBVAI0NqIPYDS5m5wLniVbYKs0orpPJTmXkJA28anASdOXJJLqKkLK/upYXkzaIIjFb4I3EiKI2kuF2lNafWC2uoBBcGNgC4N1DahtLYQYsIzKMm9XXJJPTe0ceLEJTmjg4UnnAK4uBRH6cyzADiUJOPApjQjuLW709XPTsETW4L9fBQltbnF398a4o+ZEycuyVlKcuF3qmq1iLTdieD7+EW9UZCr/JmpoghqsSZfXB3t2payXZCVV7Sw/GdUP1fwR8qJE6eMJTlB0P6mOQRw5CpCjr+2sK3TBbGGojjApaqioi9WDy71v1pAvr/4/C3crsaJE6fsJbnQvFoRJDUEijN+cWJJCEHORItUhLjEpiC4kZvHro56lFbBrczWQvKdKLHV80fHiRMnRyQ50Re5Rg26nYlskFSQSvVDt8hnLba9CGI7i+JAFz9eVhWhKLYIVLij6Hvb3+WPjBMnTo5LcuEFVeu1iLy/ExeTKv0ImtGuKmkAVdJtxQmVlK1DCN5Ys+hVHlZaPXeWXFIf5o/JOfJNu9+DmwOR+yGTOxDF6TYjrw/O/VmwwPpKH+GDkPsj49cPWpGbkL/GvvqzbHMwbiipRBUkauhSexuxvW0F+KzK2P33gURMED2nRvasFD6b7UlypiAXfqeqBCWsdicWHCiqQa7u7ApuW0pAafGwA0iVjXwhuNTrfGc0vLoXg9AG3AzKsZlKfAlaU9qk53cG8o+Rj0Z26xkKkN9Dfgz5CTw/ptO3n+PmTzau38IA6WvW5vPY3ooMxuBE3FyOfBz9V+cQcq78BPlx5H9h2yGL9kbh5go2BrUGhxF4fI68GJm0hnexXdWgvTtwc7vFbdC5VLqSyliSs/kbyM9agTO2Tfd7CfKFyIeBfsAjtfEm8l+xvbcM2nkJN9NtDDflNmtDXsPu+z/Y5lc5ztU2bKNC5/gZuHnRoLmj8ZyFeMyh7DnoEUlIB+Bx9WntTsHNOzrHbwzMuXqwqUuIIKrXOrWiGncZiYObDJEvKyG8sjoBcCKlWIp8IlWFvlN0zvbhezPA5Qk098XNIgIa5BMMAC7+iJAnEWjQS4nnDc8FZJH3Qz4W+Tbk5dje68hDLfpajUzP/3Xk0wwALm5FQT4C+UHkVXjOWIP2XMh/wD+XIv/EBOCIapCPR/418n+NAC4Doj5WMEnsHDaum7A/55nc/zjcrEb+M/IYMI7oLkY+nYAOz5mDXJVDP4uYVH8MA+512N6fkd0FOJ3JbPbLbB6EiagnnOhEz+IplFBijHxTjuBWswvcpIrwJ3LfwEFFZ28f6zu9YSmHpLwA3IfIR2V46giSaPD8EQ52h+bS59jmCUYAh5uFyCdn2C6ZUhYygIA06fUZ5OsZgGdCC/L0SAj8n8S+XaFz/ySNzEcenGGb0+gjhueXOmXCQqaiTf8p0Gn9I7zXfo6BHCjigbkjnAZapwShZX1A2elLqKXlkZVybWCMb+aOsd5TmtZyOMoLwNGzfQ55QJZNkGTzvMNfdJJAXsQ2v6Ozj1TPUdneLutrWcpvVzBpJxtamOfHcx/2dUjKs+rHJO1sSwjQuDmdGuws7Nf0ApzaJM3d4AjIhebVSlpMrMztm6CB2uiC6OaSuJ+bWBJtlPv6Tyg6a/vB3lObPuNQlFcim864HNsYztQ8R/EX+VEGwsmX/LQsJLh06s+ktuSCxS9zaCvfIEcfjp+m/P8u5Ooc2zwf7/u7eZhDhUiXZSLNGbqQiL7oZDXoys4eh+CmBUVQGhOx/IJHiUrl4d97pzXeyrHHkmYxW04qEdD01TmWVp5/p/eNQr7O5BpkH/onJAzO1O7NzCajR1cxG5EVkX3sqxS17CTkww2OHQ0Jo3jSCP1/Ju0+x67fyoDgWqaiGU3+O9h1jV4CWgS4j40dAeNI5PGQsJ3RfN9i1/BuQNS/byCxIkqLJ4eaqO/XYX/JTniBkS7FwHoBe6bUx98zFV2PCDgvtuhfZ4r5ws0+LkaLKFMK9B3xMmnu5zmBHGjZivoaxLZ5AGJiIrqhIvQuSnCneU5oaeP4ZU34gs3SUT1nGIBcCI+/Q+d4Ul+M7GkkQV+C5yUDh8lwT1XJ6hk4pdMB1B4ev9Ki67SCujClD9Svp5C/ZyIlkOpKQDPJ4BgCi/NSV3rx+A9w8yVync7xBCwTIbHoYUQ3YHtv6IwZfVhoMaMkx0f4Dra/lLVJ47HO4LiRTJo9nalgevQQtvWHlP+vxHPoOX1kcPzpuP/HFosmSrJ/jD7Gc042+CBV4j6v1ep1D0pzv7fj+mOormqacGRm0hueExQgttkXBzjRFwvK+/jP9Z3ZMGlPAbjKqb8aVjn1zrNwe0vFCb/+K/59U4F29ViTfa+kAFwSWOnr/rrJOZkuXAC7xq9NDjkOJyktCBwNxquI89JdWfD/lElmjkm7kyxsW4cY9LeVwA/5BQc/WF8yidGISDI9zuxZ6bSZ/CDpTlEmmWZKGy2kpkKW5nKQ5BRxaCbqqdLgAS2cwEypKvSeVBE+wX1Mmx96EVUdfzuOhzBBE8RjkA9WRXGIJkj9VFEuV0XJHUp7F72h1h8U6K18x2SfkWSxyuScEVm+5KsRyJoM7E3FTO0y6+uXBr+b+dzRS/6syf4/MMmYVg9fwD425Fs4R/YY7HObqLNm97/SQJJN3n+miSqMXFBiTL0tVIpLc1mBXGherU+LQbmty6iknvri0QqCW1WkquA13lOb/lLogFZz7C0HKJLrbASx8QhgByGQ9QuJriK7boGuaGBty5u3P1Ggt2fmTNxs8LvZy94/h75sAGOjOoHcYJNzjaql7TA5Zx/kDyz6NJ7xA0ylfJKp2+1OPgS2AFJhckhTnu4/kz4SWBppbSv0nMILTJoj2/PLGYOc4IkdS4VdrEgLCbsWF8SSaLNUGZqIqumaQhuJPsfcVKtInnMRyI5HPkSRUJEWXVnH4wqaqsmx0LQCfvgVFpKFHpmZFMpy6IuZJFBp0XaHwe9mYFRBdhp8eWnin2bDXHMMY3KA/SNu78bzow49h5MtVETRTJvCfmR1/1a4hvc5K+W5ngoJh2A9eraA5jTZZ7dAwuaaShQd8loW6qpmPjlQ2FHbJFDbXUn19EPBF5uMAFcQmXdrjr15oCK5L0IJ7RRVdI/0S+4SpzJFxXWMSOdzzW/dua6AQa48i3OiPQBy3iz7Cjb6eg0k7HN22yf1+Q7kEymsDAEmWzvy9Xj+TtySc+5Mk+Pm5+He7TwrUpF/ZqOdrch/LaA5Tf1+VQfk6H7HZQ5ymjjWRIwBtckNakCKg53cJ/Cod1rjj3ry7vtOub4k6ir6CamfcVCTPUX5upakRIKiGrugwLXxbDI4m30FPDmqFGAiPcr5uHcEqfUINlMh4aaSibpNqtvDYLwqbEXn2TzukTzce7bPXk9SnJkD0OeDaNX735BYzEoft4szHxBF2N8I4GiBIQ5wkqbJff3X9xTA1Rx7yyGVU+98rOyk327tKO3fHvRV/THiLj08lkeAI3JFA9ehFFfotSLaLb6ImUp/uUx2sxe51aKvRlKJ2TOOpKh7tBJJ7jRknG7JoM/nIECOyePzeQr79oHFvUNaBEeXXXbuP0uipApHsv4VFDF3kSd1dg3OaAKG5tV6NUVncqWsoAqyqkl9ghd5T2l6vDtvcsCEKwdF3CXXBoqqLvZLnuLuHmQEuK9b3rz9ISh8Mnt5ijIEP6LmHPpiFjXTYAGgchZ93Zn2YhC43YiAQQ6vJNnRyurpFv0Cdsz/8vBsCDwuY31rw35l84Hw2L3/bBSjHJ93vomiQ86HDOKRd5PkBHdskp4ioza6kwCnSjXBmd0FcAhsVciXIy/B/24I+iqvVnoA4NhiwxnQO8hspbQ0C0kul1q0Rl9Z8ub/0qKvVVkA53oDKSCM/DLyxexFJsAzC8Qf6fAzIXcqik45mvkl2nlWRvdfYSGJmRE59pK9cq7Bfnq3brN5T60mqmWmposOm9IcRaNklDxgd3VV1E5J/0ltkUENJlRUqTZ4rvfUptndAG5HIZOLBhlAKWRoQthTBjG5Z3wT3RH/y6imLuslILfaZJ9R0oUDTM5Znk0nUEoZbaJyfsQce836atQnMx/OVezaYmp8bNqLEmV52E4xUe+yjdumBSmaJxRVQDnOyPZGJp3+eM2bCGwzeFbZ3L9VZEqYRdVQyJnRYtOlVmmxLIBJwvP1NIYak7YyMSf8Bnal2M3GXqIKXVYqKIpB7ZQTiwzVwau9Jzc9m0dgIwQjoz7FpHVxQKVqiIGimh5BDEmJhkU1eg70HjJLFT+dVLfUzLIUugMJVwIjWpQFwHmYamFEc2z09ZT0sCIWJWEWcpiUzkgjeYblpyOp5e00CSpugTBRe5qyHPtz0sKmrIg0lCkG+85Enpc2riPA2Dl7K17bVlYfPG4LtvUYJBKp6uEC2TGtNBeSGica7CP3mefTntvZJtLlJrsDRpEk2B7h0DlZgpw45Nu/NVCaEpKT3CfwgHda4wN5AjdCLwouvhIMEhsGiqqxa1KPIIYr6r8ZpbjeVMN1ISTscnpSFBnin8ZJ8ihuyZBLOeeuBuMVyP/RSqWNa17JIgnoIZHzL4WCDTCZ1I+yvymWlsKU9Dz46XxKCknO5eQj1Y+9lAeZqNWfsr9PZHPph4wVbIdy633MXk5aTT7PBOS6S2qn1d9bDPZdzCJGKOQuwCS4O03aej7Da/+BSZl6Y0BxsDQ/ZuHzN4oqoPE0ivp5HM8nFxrKjOxm82GUyRzL1DfxVww0hYxALjSvVtYUJqYLLJKBRqAy/CkC3FV5ArfrGLgZ2tkUyQ0hb0UPAVxwc8ubt9/biwAubn/CCfYPMM7uMRPMfbhSaZbN487MoIv3YR93sr5q2Ffyx/qtwbFTGdvqa0pcbnrCV3qRJzC2Q7O76Vl9xsBXL+qAXuAbwF6MJknmf8nw2l/htZ83kYgoesJsJXcuu6YeSPrsSlpgHots1PfVdqW5LjYLwRMbi5puHBnJF460XrE45hdLI5OcBjdkMsJuYA/QdCHBX1zbI2AhUDmzWHAm9E66G3JfaaP6DE853K9P2Vc4lSiV0jc5tku2uIeYakRS6egc2nraRtYVJ4k+RrmmW78vyxRRd2Vi30pXeSH3DMIUuvaPLM/9lZ2+dwU5QUtkAlW0uC+c4FFBqg13eqa2OFLFCYGtMhNwIwp7SiHq8vUISrgjnW+imvpRb0Q4nIDNTFrL9tmRinq2A7UOUolUxZPTje/4/wCTBLONHSUwP4MtZOhJcZkQgdvl3fys3gfz/H9WRHbIm7O8Nt3vkzlc+zowzopiRTS3LkwtupSpNAc2Qs+6gJymCePjauoOpqb2DYEWE2spS3CO4CYjX8FsIbbALd6fHlxsENVoFPks6MWEk4AqT1Eqo0y/8G+TDQXP3+pQV/zMljQ5qabq9JUqNE0E69XBdCK/s7F4fnqYXTYlBkl1m8R867r7WVEVtIsgM8drkmLITn5SjvG212QrSeN1SRKbDJn7FNJ50/D81xzQWOyDHKjCMMroS/iKEhwtQhDSCGJxOOuXHcFtAhsAehgZGdaCvirsgtwjAOGO+O9CKa69QPCKbB//1uGnbExCkkTJ54v8w+abSHb0YlMWXorbPN4gGWGYvYRmTF/ljeyZ/4dddwAl97RKvsjKFlLqJVoQIGO7UdxrO7Pj0CrrBDxvQ1o7lPmYFi0oVxt52y41UQdJ5aIsyUfgeWfZBLiQyf0rOQAdPVNyG6FswJ+ZtEXjS3bM0XjOVSkSbPqHxaiPekA1gT2vQJqkFbLRbxr/I5h9jHLgdZiMG32UfoE8FM/Tq8yn2O03u/ZyJs3pHd/OzE6JuqsorQkovoRjm4pcuAW5P1XYSixciN7oW+4pLVMzBDcv0/cpHXTG0fG02NBaUZfNqTmTHAvu6Hjtxn1gDyS2lE+rlMkMIPHi0jhZthdgX8WUvpaziUurjdvTE3/aaItW+OrYh5Y0CVLnd3RDPrlc7p/ccPqz+/ewPjfkU9JkY55MjdWY6TintEMfGVLDStnHij5+mx3M8GJP1E0tLh1+p2q02ikvVXZ4EeDwYy9+Cy6CrAY9xzUWZQBwtMT/NORg/G0v2xeirqJun1i02OANtU5ufuuOxcCJE6deTYRvYsr/zlRoRZV+SbPAaTHRF1lSbquaEgIcLV58kgvARdwlPQJwRK6o/10OcJw47Tm0C+S0oHQk1WaQqr9VU7tQTLzFBsCRrv0S5FAMhPK++Yv79MxgqLGYpERm8GnBidOeQ7us+qrfFS/wIfoU0NTdQ/7UiHwESnOl7oltHTrgRqhIZd5+nmuHenix4U/Nb93ZzKcFJ057GMh1PlInq51aLcl1mmaQc08VROR7gKWJSSPyer4i186oogtC3sqeGYhYqKnlzdt+wacEJ07Ok2/a/RQuapZxfJ0D7iTGICeVh6cqbR5BqoiY+g9rEfnCyKLKy92TW5QUKe4uJwCOiNRUJ9OU21JRY2HkoOZSYxfyqciJU14AjiQnSs023uCQLSb7HFJXJS1eV1PwEXYZg4wWEz2CJ0Yxhr9gAEcZQ252oiMRd3Gc8wpm0QAIkU6AUDtyG160E0RBCkqy59Wm5c+9yqcjJ055octMQIx82ciZuT5fF4+7kIRm931VafGeLA8MUH0H8xNkNSIWhSv2u/7C4ZBw7HPn2gmS3trKB4EiuRy5KVGJgIgAJhCQBZqQm1ETF6KCKO8QRGmtIIifIL+txEKLW1bNifI5yIlT3qQ4ynJDFfz0krWSc/lUFpmTFyJ8i0tymiLadnxFac7tD3gomeVwJwCOiOxw2QOcBlIkAGKwBQQENM3fhMgdi4mSa4soyp8jmL0BntLnG5c+3cinHCdO3U5/NgA4iqb4fj4Brqu6uiudij172ANvjT7TqQ7QSiqtqGYMaqFWEDp3IqjtBEmU2lFKW41S2lsgu59qWj7nCz63OHEqCPov6Bd/rkeAW9AdHcjYV2NLWxE8+uEwxzpgZ7FBVKMgBVBS69wBWsd2EAUxgJLaCgS1FwV30T8blz27x0hpKN5TpIiZZE3hMWfoZQfBc8k/8RWTcx/D8x5jx1LIzSiL7nxoFG+K59O5ZtkTvsJzN7NjKcTnAIeGiJ412XH2z7bvKfdApTfNvM43YhvfGJxLYVYU7zmG9aWCCQvkYkVuSJTFhdJKfZSahTmL+UDP9LsZnkbhbw0sFVKm16NrDbB5eBNe412LY7Yb4QxeawpQ3Za02GOd4+h9GM/GmuZcFSSWSDtY+/SMKMnpSmwraARyth/CXxaPhHDMmQy9FNVA0Q16JEWDIPobcDpvBSHcoUqS52sEtrmCt+xvOz9/6ss9+MtHyRMHWRxDGVGfNvhoTTY5b2HK35Tx40WL6+wHibRYekSr6tNNzqXMFsmEm5Ty6U8OjQ8F5v8LrBMtHg+JbCpGL47MxsMsj9c5kJadA88jQKOFt3PBXtHtFjyHAu/vyQZ02MfhnSwBkj4IlKDhGWKDQP50orE92OYl6N5qLNJx0UfXrEgSZae5w6D/5JhPse9H2ewPZX9eyp7rO8kEAPFVBkHUbOWzbw54YM6KQQ7N1d0jG6RoAFwtG8D19SKQNiyJyS0bP3ODcIWnqNrbvHL20MZlz/zfHg5wduk2oyItewnRSx+z8bEwo8MsAI4khfkpL5yATMktKYfZZTYBjogcP8lJfi2ef2k3jxNJPVSsh9w31uD1J1uAYt8MAC55b4fkQZvph/w2+wgflcGpEpP26Dn9ZpcmmPhXs/WFeX7pfhBVnHm3KJ05ZRqhlVBX22ZwbVgC0jfvanLrxpVu2X2p21vmaV7xwpjGpf99qOF/j/MV0K40HIyLguzxhF9oUlOsih9b+V1ZgSDVHWhKAhxu/k7SGJjXPDUj8o96GNv6XQ8NG0mgC/D63zM55rgs2j3GYYAbzKTPY3NsamE6yCWy38bMbWNvrd3XkRtRUYqLCAK4t34O0lfzQWpc1+QShHtdntKy5hWzD25c+vQ/UGJTgROX5kymo8X+Ixg4GdG4DNqnwtSXONTvG7BfP+qhMaP58iir+FVwIMeqxtEixUAHmksDOVWIlz3TosbvTHvIBcu2VOV0VVWJQsjfCP6m9SBs/lSTwu2fuL3lR7esmlPTtOzZ61Ad7eTYxaU5h0COJuuwXEEOX7zDwX6xZbs0i1SyHho3ApI/OAhyR7EchU4QqfWjHGiHBKTFXUDOd0bDOsGtRNRO476u2FYFqpZdyJUSi0CwYwd0tmyEaLgjJruLXpA9Jf1QahuLwLaQ4xWX5rIgSudlVRtggoHEQIkozYzLlB33PfY3AYLTsYbkN9aTcdJUz7YubUzoozkgi7bINvndXDvE5vHVDt3f56zGSZx2Le0KXmWd2uEeZVRUu7Ez88r1qhJBya0JYhE/CKIUdXlK/iMI4pWNy54NcHxyVJp7eg+4l3/bPI7SgpNdjlbSyM/KrAAy2d3+pfO7lb1uIa1EYvuUin2KxbFUW4LSlVONCvLgJ+P99yGxKmhGP8L2b7Jyc7FJdK1vmNAynAGo1cIIrT7/06YUR4IIlcwzUnOpjkiuBZ9orK2k2xcgkaI/zPpDkjrlraTFhko9VbUryHmUZ6EdRUVNo7Jdu7XekAHIqWoMwoFmiIbasSlRRXCjl/CSpuXPBzku5UWae9bhqlrdTtj/i7I47U0LkBtvAn5mlHQ9Od/iOFqBPTmt+DYt4n3G/NsutZCAqKrYSw4MH7lLLE2RiralAZgejc5AVd2BbBaSRHa5XBdUrFZp6Z4Mq8fhPR8IiZVYco16RRfkICreC5J2p9opC2Lp7m5zzX57IBcJtkAIAY4ev+wufg9B7sym5c/t4FjEpbk8kJVdbgRO/jJ8MdozlOTeZNsTLI57Lw3gUulhC5ADJiW+lIdxednGMfumAIRsIbFS8LyZ3W0i1dCw6YdnROUW+5vMPuS4by1uiB9J37fLnuObuSMglkSXqh36QRBWkhwtKvhbN8fV04piEZ69en379gfnn8oBrlvoVouVxD2ScGJTicuvTQ4R0qU2VtDmMJNztmK7q/A4imAYaWX7MdlHHvhWmst38zQudoqKp/oIjrVQb9cwtdysrbG5dtti/yh8JnfSRyvThrsYrUVf7AZQBd34hya/sXsQ2dz8rZtAiYXg5ENDsOrXn8KUIa1lWkRaH36nsg/HoLwT2UqmQ5aV0Hs5vWGxP30Vlew3HhvS4Qgb195oAjT0FlnVMh3eg+MWsamqElEtXKt48ONy7M9mO6YZUp0R6J5DPhPZVtX5LmKb99TGtwJP99uqNHr6S327FDmHRgN1lWxvxC5ZhPvP2wwzx3xb4U2LSVUCCAh0VYd5jm7+imNRzkR2l0MN9t2IL9ZL+OB75Y1hv+0AdBveY3rtXrKf/dTknPEWoGcEcoNt9McqVb6VRFVFvmEOLT6kjmV/G4e12ASoIJNYrWoQT8mx27SaraYLXjpEQDSTsR/vlcL7qP7wGziOMUtJLv5DcfQKLSpAfAEiFeR2U1e1uFsIAVx5sQCLbljdBeC+BTqxVItKqxDoJhX6i/Zh3QipwLs430Q6IOfXw2xMxj2NFoBx4ejkuKTOc6tFhyTI9csQKPSo1UYbNXkYk8k2jlnHALHEYkw+ZOCxzgLUj7QrWRlIvjRWL2Z4GkWRUCFyWmjYiNf/GbLLEuS8pzW+JJZF1ik7PSlwhk8z4OkCcIH27eTzBrXlAJ/euhQOqDXxClEFN6qu74QXVF3e02/Ee3Uj+i+pG37JB3Uj/vVJ3cgPP6sbuXlF3ajA8rpR/k5QvQX+QlPGDLMMxtP3NpBjL4eZ+wIZtA8ykey6SMopxaZLu+kWnJhz/SkcijFJZb+3cc77KYBotnK6hI2zZjHOyawsudCtyNlKtSS9UkKI91jWG311dRfyeWPTlYC8GhQQaE2l2e8BJcURmCQ4ssPtU6HBhzcvgyK3De8FTRC1iPxgeH71eJTsLvSe2KDke/Ysqhs+WQZhmguEI5CHekCowq3uPe+A6I3H1X/h7wUgR/GTVxrsv6gbX85Corcs1FACttU4+SlcyCw28W2H+2UngqfEgetkmrq/IQleYG1Ley8NGE+yUFmzHkMEUkoi8EP880kbaqsRUYTKQmxnXHIBRrch77TGL8SK8IOxHV5KkA7NgW8/NhSWFQ13QqlPgMU3LrcHcKlYF5W+L0jq2tC8WkfDWhbWDR+GUtqdH9eNfHdp3aida+oOVvuDa2EtyNdWgjShBMRaI4BrB2XLxPo1v+8FL3M5PjgyAhsZ2+vAeil+TwU5MxpnQ4ojetPhftkBsJ5wjP9TSo67402OU1MkvrjqatFurkH1BHTkCnU6WNs7zYgqg/3dUF1Nkm/GzqvEouhmrV2GHR0JkCNwiwRbycEXfnZiO1T4shPGNEUcguD5TfitmvOyNsTUHXQUgtojqHJ+ubLu4Mi+4FqLgHYbAtrEYhBrZLBX9kuNf27V3hIDmrynu4ETpL18HRaSHFhIe6QmpSaAVLqp76FuHqu1TK0DFj9r5iazCXkMJbdkCS6tbG6HMxtfrkA3FzcHsn62ZdnMDOzLaLASCRHkjlRDYqTZ7wZNVVCKSywWeUv6wIsrh+WWdkkTPAh2TyLQvYxSXYXV4e/UDd9/Sd2Ie1FSW4OgFh0I7sUIahdXgHQAqqFZV8Bpgdjbk+vXvN/L7FAUfLxoDwOqjTa43mA8yDBulljyIPbymfnHvZu2ymkn27SVz5adtEw7u3GM6Z5mpNynlao6iI1rkudaHE8Ld5McmuONyJR4lbIC00rqU5C5vfks+sc0/TmqrVtCc2vO2PF52cvhQLNAQCe7i8HlKYVNLQCPfjQMLh2fWzkFBLpTQdQ2hd7s80Pv1J3Pp+57om4IxabNQCidUQ3SOB84G4seRuXZD+rMXgoKd0CWGWMZdeS5f+EMJ/XgHK9HquY0k/3DmHRgV+XdbuOaVh9nq0rprXrpuvNEFPN7dlqExnF5uA6FeDlWJJoBMsWsvsBSzpNKfCYDMCv781hLSY4B3avvbK78MBJKgKi3uHrXvlkLR8H6Rgfs3KpQgvwcSnXvf3zJwGMQ3G5DXsNE69/vAy7HAS4+wyB297H1X7RBLyR8+AtzlObCOb7EVg++o5uHxMouR7GRtRYgmUp2MlDXWey3yuqxphvGhXwryZg/VicELR8gNyWPcz6M/BryxZBIzf+5xSn9LCW5JC1e53aTfdTlKQFR+rYKYQTV1evnHAFPX7QA3FL28eHRkAD1H8qw4QPXuOZvpPmp+9wgwL7gcnzAOkBpmFi/5o5eruLlIs1ts/kSLzVSAS3Obehm0F+HX/p6E+AZatHX5Tq2q6CFHcrIMZvsXSQNWGWZ/cyh238qRe2NQMJ/j/pPPm5bDfpHER398/AovoNtV6WmOsqE8Fx6Tl8xlxWz592Ex1IlsO+YHOayDXJKNBTPveXy7G6CWL61Cm56+XC4Z8ZHGSfdatsswlcL3VD/kQyxsGDwlrlR0Xc2LFONg5z6vd5uxCJpDh80SXOTszi9nr0QbgubxlydiXiijRdkbQ8MCUljRhl8rzKTAtNfKvx/FO/zIwvJZDJVksJj9VRbO4tq8x267z+mZiGxScfl6RmQykV2uYwTD+BYkosUeQ/sxL/JwZcSDcw3iQixkpQbbYOcqkbjbgmSS99vkYrbDK7qgKsmrbZ1M01fS/DF627Yusz88mUIbzWZV020o6YumVy/5h3YM+i32YAce4mXgnlg9fl4TCmTFtuYVEPSyw+spERsf2OGE9yuVB3Ftn+TBciVZqHqzrYAOZqcs7Hv5OS+jICSvainQqKamRmRT+a8Hpw3x+Wx7aMhu+wqx7CPLknAlzEO45h+wObgcvg2I8p4tt+MltsGOdA0iTwyyHXEiO5fNApcqLL+ZILxQkT7NhGWPeuB7ausL0uy22BTISM7ioAWC4B2+h4CcARWbzCJ44gsTn8FrLNHTAfz0oNG7WZKt2cAiL81SLtDIV4aZJ7J1wjkSB2izMBmUQnjmG2IPhrk82bXT/HRblx0SB8/q9RKwD6c9Qb7KE35z0zOzdZf7kSd3zysr1OyaO9V2yCH4KZomrW/yD0LDoGIIqFEt6rLLCOb2+q5bvhyAbmi2OtdLarTRXlYbGgB5U9H16/ZY4pRMyIp6PUsznuMgYvTMbsP5fl+y0EnbpTZaf4HmaUwWmlktyI3BmzvQUiUuLMiVwYAR5EQPel8fqSFZNvI3JSMQHK+BciNxGP62Ez5lEonO3iPXyUlZVsoIohSBwXsa5p1oog/LxoJN8wdu8uHbuc6Cd64vRjWvW0f4FwIkQNzXGygS+1UYrAqEobFQT/M9bfDG8HOzRPrV/8C9jDCyUQP86MsziNnzwcd7s6TWdiHsgE5MFFZMyGrMKRfgXXKpEzpehyjzT04ZaxUVatyjx/bVD0zkS7JvWc/B+/xymRUh02Qk+PL6apiz/Vp9rLB8IP/TIbPXiuCRfcWQbAlM+1hIKqpcgYaR6eqwloEs4UIZrM72+G/Ha2hpzpat74V7FyyMhr8a4MWu1ARtYFX7vx6IOy5dEeW590EiQSPThAZZa/shnutyEL1zOp4llX4NLDnHGxLysU2/9bDcyUnkMP+7zBRZZN0dIZ9OsHB+6OPyK7QR1vqqijKtER9hBINgSTbS5ogrQ7C+pbMtaBixN1ak27FUJrcHItBfSwSl9RUtwrkujdwqAqHjVK2Dhyu3lVWDY96T2wIwV5EJM1lY5vD8wJ4HsUvksPlUTl0gdSbmSwrSE+CHEWvkG2syEY7tLq80MYYUaZgqh1ARVQOzrLPVCGKCtfc25PzhC0kWaWbes9GUzTX6hwEOVpsyMaemkq0mPNTHOMnUn+0BXKapjyI0ty90XCn7PZZRmDBwEgrnNq6Oqte7pcWCRNCUPsmGomDWiso4CpTYcBwDQ4Zo8KBRyjg7oq5/eP2IEG7Pzy/egGowu81RVyIgNebMuZSdSmjArcrLM69DhIhMEb0ocFLTEv2NCmp6DGp8wdk0N8vmH3p8W4splNuAkhUZWuhTfsO1WiwFSBPNQSwXbL10YoeGd73zwDcnkH+NfnyFcD8mgLmNlhS8T610Q6VhDzLZP+w9JRHFuNLRbcp4ytFM5zDgFjKANyo2ttv9OyrAtnZBBux7NWHzHwWQe6s4oqBKM0Zh+SJCMY/274EaqOZ14kmCa5Oc8N6BLQNCGyNWgw8pRoMHoGgNkmF/UcrNsPuUzukBQRZfQMB7z4tJr7XywCvJ770NMLkYEmrhiPY15q+/hT7SaobuZKQurKKpDecVMtstEntjHWwm4tZfQej61GM6iE22lmN7XycwxhNYpLdvmx8itgYNSGvZx8V8vNqy+F50AdvmsVhc+0632J7NC5mMbwd2NYLNtoh04/VKiqZAmiV1sxNYqmeDZfFGk9kYEe2OgJMAh4Sa1oY00f/YzYfgvoCmmYf5GpGn10eiwQaRdkjF5UZZ0kaHdgG32vKzO7sj6nQFlXBH8W+oPpZNzQBaiMmKAioDr4aohYSZOUT3D6qhVxPIuBFOKxx4rTnUkYgx4Du9kio/Y6i8n1BdulHu8xsXg5j/FusxVNFg8awAs0RBUoQs0cepsG46TGoGdhNghbeueBSNguSuhhB7xnV73mFS3mcOO3lIEdUdfAZK9VYZGRxZZ2uc/AFjZ/BiKB+FUJCkGYEtoaQAkEVIFZTCeNQAz/9uO3Q4/X0RE1F0NuBoLcUt6+IxeHZ0iGR7XyacOK0l4FcXG2NhTaJoqtUT229tOEj2C/cvBu4kdS2NRgDFYFxS81+8FHfERATEnbF4X1b4ScT1sBJIzaDKPS8MCVVBkD0xTVZQmvKFLGaMcVjki1oEwJglE8hTpz2QJBLAN05w2IR/wrZU+L2FnctNnTFjvdhQORbO2t7VIUN/ijENAG21e4H7+8zClQD97whNe3w43FrYfrBG+MhYj1BgjsGco3logl1jhxpaSWngYEh+VFtY1saADKE0qpPEgy/QmDs5NOOE6deAHIM6EYj0H3s8pS6PSk55q7dvhj6RP1x6W0jghuppmppBbw9eBz4JXs+dtVFYTjvu+vh3MPWQ21p94b3ybUdIMh5yXx9NILcQj7tOHHqJSAXB6NDzjpQiYU/kV2+UkqJTnTj1negJBaCte0RCCgqbOp3EHxcm12hcAlV16OHboVzx3wNRw3ZnndVViwOg1SeN1DlIMeJUw+AXE4R8E3Ln1srSvIARQl/FWjbGq8D4VZjcYDzI8ANK3VDtTv7S1AZxLfX7QsX//coOOYvJ8NflwyHrW1F+RkNUQOpNMRnBSdOexjlJMklqezAEwXZXfw3VYlcfN2OZdIOVFEHFbugrzexsPC/4gEwp3IERAVnkl2M2bcRTjm4Hk48aItj6qxUEQCxKK9uc1yS48QpC/JNu59UQcrPd72ZE3he1NV0GnnQSdOO3bR8jlsU4JBKTxe3kO2uUphdNQo2uSscu3lqf3T/ZpiMKu2Uodth5D4tWam0NhcbOMhx4tT9AEfhAFQq8jEEuIezUVcdBbnf1Qyq2BKMtVR7JBhSsnuqJIKfT4sHwoLyIdAq+RwfkCpfGMbt1wBHDG6Aw+sa4YA+bbb87+Q+HSC48l5m0xbI4UO9Bzc1KUNGsaGPUK40nWMpxo8qms/B/S/q7KcQnmt1LlOPx9/mwASkft6js+spbP/NtGOpBibFfFIOfwp9osSaD6cUOU4eR5l969L7h78/xNpdkvIbhf3Q8ZenxqDi7zdC1xoU5O/4HB7zP4P7oGlC7dOk/LlekgHWr4kpP1GutJfN8q5lOaZXw+5pihrwOpemHENZUS5O2U+r+gvZPapp7dFxo1h5v+RvxZCoUk/JRz9KO55C8K6HRD1WSjtEYXt/1Mv0jMc+AIlwq58ZZYLGYyiL9LnIfdlzeBuPvS9lP5UhOCb1/lL2TWP3SeUXyJuB4qOf0zmOCknHcN/lKb+NIukvMOfqGY5mpbyxcWMrSnGKUdo5mkmH+zfBddsWwYyWlfFVWCepOeiBV1cPhNteGwMn/e0EGHvPdLjsmYnw0JLhsHj9PtAa3D2ETiyOdAfAZUIz2Qu6ARLJFSlh4/v40PSWpmkynsrAQ4/IlaU1jWniTHWorxRfeCHbpl4jnDYJKTMKpe+h1SmapJSWmoL6H9VpcyLox2pSzYT0xAEHsOunP1jKMHskG0Ny6aFYzU+xH9cY3Aftp5eMMiAbBfZTv6awNrezZ0Q1NpxOfkl9oRTzS1M4PdsFVYg/gQEbjStJFP9Efh77k/5OU2xtekYQF7vXfmnPaQhrjwCCKtlTuqLhoJMZhAXfXwGJNOSnGwDcjewZ05g9BokKaOllIQ/Sm48MnOnDTerpLHbu0/i73kebzv8p7ktNTlHD7tH5Ago+SfiqLaocGNNkkA0kRAlR8IjOTXH+0lsDn6B0t8ZXCzHB2UzALQh689f1j3OSBlT4YUBNGNqkKhhesxOOPOhrGD9kI/6OUp9QMFFdVGXpDvawn4VEGqPJbNIlJwEFSI9hYHE9VYdKl/bY1/XnKedQ1gjK6Hqrw/19gJVINKI/QiJY/bRkwRjsC0kIT+H2vjwl2fwiOYbsenfTWOH2OZ2ElTMgUUBlC/v7KYM2N6S1SWP7J9w+ZSdRQQbU5ToGROX5ZqX0hTKdkPRMUt6cLK/7C/ZhnZwiGRvVqqBxIj/R1xmYzEoDKZKKbyZJnzKMZKGiUh2PP+G516X8Tj6nt5FUr1Pc5mv2fClZQRfjuvMgJ4vXtEfV1zb5Y7BfiXV236GhxjiHRBlW+PrBal9f+Mpb7TjgJWlzazGsUYZCxF0MSxqHwj++GM+kTA2KpRBU+zqgf2kb7FfdBAf1bYAR/RpgWJ8m6FfWBj5XjwQ5JItm9En7fTpTmX7DgIwkun+bTJxappLRBHmruzrP8pdNZCpl6leEisTEkI8H47KHTtJfIZEglKS8R3Re2Lnspf0tFTGmGp822nyYAfg0cC7xaFZEzxT7vSlpvsiyGcqq8rrN9FPJMXuDSZDpZQjHMAl/dhb9GMXU2/RKcS8yIP4O7J7Ykz5MVJGNkrbel1eQu7lx4+u/qqp7aGdYudwjCdDfZ+8SXjUWV2WJI4IUl/DWIOB94esDftG5gjZRV1Ec4Ha3FwrQqfigs9MHGztr4YNtQxPf9tTBEhSUVENQ7glChScQB77a4k7oW9YR39aWdeJvHdCvvAOK3WH83e+Eb19SdVulM8lewYnVwXLuTzcDOaS/M1Xyhjy8YydiHwan/H9eSpm+QUzdqU97KakK0za2vztAYBNeL5R+PaaijWK2H+rPA0wtfcNGm0E8n4CxzuHuDk6rXkZS6dM2zvsarMv0mRGpr5Zp2bFvlUyzuI+pzPT1PwX5ibS2gEnHmVJyPDel/Z5sS6+ebROTOm/F/j2WV5Ajuq25/oq7qut2bg8qt4YUTSR3EimDtQ23psDI4I44E0TQyuzXKN197amCDcgBMdv6DwL4i/tkfV8xTYKOWHGcN/sRA22WzxU1FSb1X4WT4JGFdu1y+KDILkNL0WSw/wdO8s91JlnSBkFf7vtIRdDLq4W/X8DUmCm4Px/LyDOZmpOklcxulTrH9JwQyUjug+4jehklnY8F9fUTVlLwc/bBeMNmm0oe3qMS6Fq4OtxN42PXx+sU1qf57GP1NhuzJ9LsfsCk9UxJ3CV77P78UttOp78wO+HtTOrLH8gR3dJUf8fdNYOeCCrqC6vawocMKJKFKreUBSzhJyHaEecJHRvid73TVQL17grY7C6Pu6TsQBBUbKwQB30VoEhu6G6ipAQffjMwky8aJVykupUEoytSAY7RqezZkWp1J1DW+ARTEsNX0gBuX/bwyfb1bp5u8RITm1wS/GoMXuadDr+ARtIHjU+pzvVmsH58jsckpYha/PsKqyrujKqZBOgkUQWxGVlKYgtzuC4tVFXaVFXp47SDjRn9HU1T85tTnnum2XySldgoYeiGlN+Tc6jRQLImwCVN5T+QoofJ+Xy5f9m4kV7WQ39TPWhYc1h9YGdImVjjkXxVHinr1Ep0HmUdJv6uPyFZE8A1yCVxiW+7uyz+d4OrGFpkX1wNjQONKCHIVUEvoc9TjcoGk+xTZo9L0r3sa/pKyostMPsTAeytPXQvVOmKXEYodfizKX0bzADiM50JXpoGUCUMiHIJSZnCtovS7JRklKVFiaR7yQHMzjYGLNKAs3ToZZCoK9GjxKpdDSP5Im2Xn40z6IBFOuB/xuxyZtfxMrvmr+HbAtL7QGIBgj6yr7HfljJJbBLsZvixpGVMApyUNj8mMsn5M5NzafWeVtEv7xaQ22Wna9pIue2n3ls72OWPaTe1RqPne0RhfwQ8ySvl7qNHq7VJaQ8C36Z49woy7A8e6BBlaJM80NK4EhpdRbDDXQrbkDd7KlAqLEIw9EIrcm/ImMlWrch94BYEwpdSfp+AmwvIhSDFV4pqNlBlpnE6q1HdQuQHx2wkl9JKMf7/UwZaBMpbYfdC1OS39XPyBcNjX2Yrbdezyf1+FuNFEuDhyH9m6lXqC3Iaa/eeZIpydr2bUz4kem2KSTMCeyHnOa2uMnPFLksJ9i8dKKSUYwazD97/YPfK9VR5/pd47C/YPpo/dzBpKB0saCHlFTyWCmo/zvCBXGoW4PWT9UGOY1rDI6mr1HjOWvaRfY099+34G5lR7mS2V+o/pTE/EfddazFnWvEc8uO7Bbcr2XOgxQbynXxSz2c05VwyOdCK7JJuBbkk/V/DBtKpqY7lr35dXTdkcyB2syjAOJ8k7F/hltw+ydnUmUM0OS4SlCkx2BcZIsZ+eQRwYVQrA6IIftEFnQiMnZILOhAc21DFbUMQJMmQwLBZLoJmlw+a8P8N7pJdefG6iZKTLH0FjcCCHm7SJ43oKPaMP2FqRZLI/uRkzYV30tr/HbZ/U8r/6e8BrB8NTCUiNWSazkre85AoZjIXjw2z/hNoX4vH1mfQp+l4vpZiF6J2f6IjES9MrcGAf8fwPJJKpulIRZNT2lSZ3Y5U9ZjDz5ikyFQTRUjHdlnCjokxdZBWIm/GvkTTXvq3sc+/ZMCd9OmjFfsz0u23+P9X8difMhC8nv28DrquHM9gmkb6AsXLyN/H83+SouZfBIkFr2eYHY36Op9MB3iMlZPs5cw2R/Paw2yA1M5PbXxY3yNXIWCFdhyNeMjaflcxsFYWhcvwjiZ6JOEABLvBpS5RlHPoVzW+G0PB0y3915g4EBXoKQq4JRZ3AaeG/3+zdMATf1z64g9sSB7kcd6GD2qLwX5aWq/F/St0JBZy/NyU/NLhb3WgX/krSNWnHJAqycA5QmfXTr3+M/sgvRw3MOlJNWn7AKZ+0eReahDxUcVsaCtSIyfYuSUpALFZb8GFjXVreoUnNsb9Uv330saS+rQ1lwI1PaABEGCQeh6yKhvJzByk0oZZ3dlcr00vIi2iNaeDsM1z6aPYYtOtp+u76XRYl1N0e2XdfijhnesWhZEuUTjAJcIwnyRW2JX06GkeCkXghsK5r5Uuz6zT139yDezlxHy53mfqY3F6+BcnTo4KIIhvciF27M6WejJW3538/1XF+4p9PNJRiMVTEPgGIfDVyQIMRkmvzicLrnSJrz/CWyEBXNwyG/U38SmXENwh4V91BiQKWnOQ45RXKkhJLgM1twwB7xiU+g5G8OuLf/f1CsLAIYLnMI8gukpFEUqQxQLoayPEbh1Xv/ouPuU4cepeSa5Xg5wZofQnD/O5J7oFYaxXFAf5BGEfSRD6uQCqcVsuoarkAsEjgyjjMQLuBwRIkPI0FhzkOHHiINdz6nFVXTFKfcN8gjgCAW+QRxBqXMioBlejFFiGXILSolcC0YvDRl5+bmSXlHBQRc0ZcLcgxk2GLNuyB3+Jqlp8YLEt8Ivqr6ZsWnM7n3acOHUvyP2/AAMAGPxE0D9Uk0EAAAAASUVORK5CYII=");
                //var imgVict = Convert.FromBase64String("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");

                ////rusicst logo
                //MemoryStream logoStream = new MemoryStream(img);
                //var image = ws.AddPicture(logoStream);
                //image.MoveTo(ws.Cell(7, 3).Address);
                //image.Scale(.7); // optional: resize picture

                ////min logo
                //logoStream = new MemoryStream(imgMin);
                //image = ws.AddPicture(logoStream);
                //image.MoveTo(ws.Cell(3, 2).Address);
                //image.Scale(.7);

                ////pais logo
                //logoStream = new MemoryStream(imgPais);
                //image = ws.AddPicture(logoStream);
                //image.MoveTo(ws.Cell(2, 6).Address);
                //image.Scale(.5);

                ////vict logo
                //logoStream = new MemoryStream(imgVict);
                //image = ws.AddPicture(logoStream);
                //image.MoveTo(ws.Cell(3, 9).Address);
                //image.Scale(.7);

                List<C_ObtenerInformacionSeccionesPlanMejoramientoV3_Result> secciones = new List<C_ObtenerInformacionSeccionesPlanMejoramientoV3_Result>();
                C_Usuario_Result usuario = new C_Usuario_Result();

                using (var db = new EntitiesRusicst())
                {
                    secciones = db.C_ObtenerInformacionSeccionesPlanMejoramientoV3(idPlan).ToList();
                    usuario = db.C_Usuario(idUsuario, null, null, null, null, null, null).First();
                }

                var dataPlan = ObtenerDatosPlan(idPlan);

                #region Header Plan
                ws.Cell(2, 1).Style.Font.Bold = true;
                ws.Cell(2, 1).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(2, 1).Value = "Plan de Mejoramiento: " + dataPlan.Nombre;
                ws.Range(2, 1, 2, 2).Merge();
                ws.Cell(2, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(2, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 3).Style.Font.Bold = true;
                ws.Cell(2, 3).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(2, 3).Value = "Usuario: " + usuario.UserName;
                ws.Cell(2, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(2, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 4).Style.Font.Bold = true;
                ws.Cell(2, 4).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(2, 4).Value = "Departamento: " + usuario.Departamento;                
                ws.Range(2, 4, 2, 5).Merge();
                ws.Cell(2, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(2, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 6).Style.Font.Bold = true;
                ws.Cell(2, 6).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(2, 6).Value = "Municipio: " + usuario.Municipio;                
                ws.Range(2, 6, 2, 7).Merge();
                ws.Cell(2, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(2, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                #endregion

                int fila = 3;
                int colm = 1;

                int filaIni = 6;
                int colIni = 1;
                int filaFinHeader = 8;
                int colFinHeader = 7;
                int filaFinData = 8;

                string nomSeccion = "";

                for(int i = 0; i < secciones.Count; i++)
                {
                    var seccion = secciones.ElementAt(i);

                    if (string.IsNullOrEmpty(nomSeccion) || nomSeccion != seccion.Titulo)
                    {
                        fila++;

                        #region Datos Seccion

                        //Titulo Seccion
                        ws.Cell(fila, 1).Style.Fill.BackgroundColor = XLColor.FromHtml("#63002D");
                        ws.Cell(fila, 1).Style.Font.Bold = true;
                        ws.Cell(fila, 1).Style.Font.FontColor = XLColor.White;
                        ws.Cell(fila, 1).Value = seccion.Titulo;
                        ws.Column(1).AdjustToContents();
                        ws.Range(fila, 1, fila, 7).Merge();
                        ws.Cell(fila, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                        ws.Cell(fila, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                        fila++;

                        //Ayuda Seccion
                        ws.Cell(fila, 1).Value = seccion.Ayuda;
                        ws.Column(1).AdjustToContents();
                        ws.Range(fila, 1, fila + 1, 7).Merge();
                        ws.Cell(fila, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                        ws.Cell(fila, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                        fila += 2;
                        filaIni = fila;

                        #endregion

                        #region Header Columnas Datos Estrategias y Acciones
                        //Columnas por seccion
                        ws.Cell(fila, colm).Value = "Objetivo";
                        ws.Column(colm).AdjustToContents();
                        ws.Range(fila, colm, fila + 1, colm).Merge();
                        ws.Cell(fila, colm).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                        ws.Cell(fila, colm).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                        //fila++;
                        colm++;

                        ws.Cell(fila, colm).Value = "Estrategia";
                        ws.Column(colm).AdjustToContents();
                        ws.Range(fila, colm, fila + 1, colm).Merge();
                        ws.Cell(fila, colm).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                        ws.Cell(fila, colm).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                        colm++;

                        ws.Cell(fila, colm).Value = "Acciones a Realizar";
                        ws.Column(colm).AdjustToContents();
                        ws.Range(fila, colm, fila + 1, colm).Merge();
                        ws.Cell(fila, colm).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                        ws.Cell(fila, colm).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                        colm++;

                        ws.Cell(fila, colm).Value = "Tiempos de Ejecución";
                        ws.Column(colm).AdjustToContents();
                        ws.Range(fila, colm, fila, colm + 1).Merge();
                        ws.Cell(fila, colm).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                        ws.Cell(fila, colm).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                        ws.Cell(fila + 1, colm).Value = "Fecha Inicio";
                        ws.Column(colm).AdjustToContents();
                        ws.Cell(fila + 1, colm).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                        ws.Cell(fila + 1, colm).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                        colm++;

                        ws.Cell(fila + 1, colm).Value = "Fecha Final";
                        ws.Column(colm).AdjustToContents();
                        ws.Cell(fila + 1, colm).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                        ws.Cell(fila + 1, colm).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                        colm++;

                        ws.Cell(fila, colm).Value = "Responsables";
                        ws.Column(colm).AdjustToContents();
                        ws.Range(fila, colm, fila + 1, colm).Merge();
                        ws.Cell(fila, colm).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                        ws.Cell(fila, colm).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                        colm++;

                        ws.Cell(fila, colm).Value = "Autoevaluación";
                        ws.Column(colm).AdjustToContents();
                        ws.Range(fila, colm, fila + 1, colm).Merge();
                        ws.Cell(fila, colm).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                        ws.Cell(fila, colm).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                        filaFinHeader = fila + 1;

                        fila += 2;
                        #endregion

                        nomSeccion = seccion.Titulo;
                    }

                    #region Datos Estrategias y Acciones
                    //Inicio data seccion
                    List<C_ObtenerInformacionPlanMejoramientoV3_Result> dataSeccion = GetListadoEstrategiasDiligenciamientoPlan(idPlan, idUsuario, seccion.IdSeccionPlanMejoramiento).ToList();

                    for (int j = 0; j < dataSeccion.Count; j++)
                    {
                        var estrategia = dataSeccion.ElementAt(j);

                        List<C_ObtenerInformacionTareasDiligenciadasPlanMejoramientoV3_Result> dataTareas = GetListadoTareasDiligenciamientoPlan(estrategia.IdEstrategia, idUsuario).ToList();
                        int cantFilasMerge = dataTareas.Count == 0 ? 0 : dataTareas.Count - 1;

                        ws.Cell(fila, 1).Value = estrategia.ObjetivoGeneral;
                        ws.Column(1).Width = 40;
                        ws.Range(fila, 1, fila + cantFilasMerge, 1).Merge();
                        ws.Cell(fila, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                        ws.Cell(fila, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                        ws.Cell(fila, 2).Value = estrategia.Estrategia;
                        ws.Column(2).Width = 40;
                        ws.Range(fila, 2, fila + cantFilasMerge, 2).Merge();
                        ws.Cell(fila, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                        ws.Cell(fila, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;


                        for(int k = 0; k < dataTareas.Count; k++)
                        {
                            var tarea = dataTareas.ElementAt(k);

                            ws.Cell(fila, 3).Value = tarea.Tarea;
                            ws.Column(3).Width = 45;
                            ws.Cell(fila, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                            ws.Cell(fila, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                            ws.Cell(fila, 4).Value = tarea.FechaInicioEjecucion.ToShortDateString();
                            ws.Cell(fila, 5).Value = tarea.FechaFinEjecucion.ToShortDateString();

                            ws.Cell(fila, 6).Value = tarea.Responsable;
                            ws.Column(6).Width = 40;
                            ws.Cell(fila, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                            ws.Cell(fila, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                            ws.Cell(fila, 7).Value = (tarea.IdAutoevaluacion - 1);
                            ws.Cell(fila, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                            ws.Cell(fila, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                            fila++;
                        }

                        //fila += cantFilasMerge;
                        //fila++;
                    }

                    filaFinData = fila - 1;

                    //Siguiente sección
                    //fila++;
                    #endregion

                    #region Estilos Headers y Celdas datos
                    //Estilos finales
                    ws.Range(filaIni, colIni, filaFinHeader, colFinHeader).Style.Fill.BackgroundColor = XLColor.FromHtml("#cccccc");
                    ws.Range(filaIni, colIni, filaFinHeader, colFinHeader).Style.Font.Bold = true;

                    ws.Range(filaIni, colIni, filaFinData, colFinHeader).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                    ws.Range(filaIni, colIni, filaFinData, colFinHeader).Style.Border.OutsideBorderColor = XLColor.Black;

                    ws.Range(filaIni, colIni, filaFinData, colFinHeader).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                    ws.Range(filaIni, colIni, filaFinData, colFinHeader).Style.Border.InsideBorderColor = XLColor.Black;

                    colm = 1;
                    #endregion
                }

                var finalfilename = Path.Combine(@"c:\Temp", "Plan_Mejoramiento");
                var filename = "Plan_Mejoramiento.xlsx";
                workbook.SaveAs(finalfilename + ".xlsx");

                Byte[] bytes = File.ReadAllBytes(finalfilename + ".xlsx");

                response.Content = new ByteArrayContent(bytes);
                response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
                response.Content.Headers.ContentDisposition.FileName = filename;

                return response;
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