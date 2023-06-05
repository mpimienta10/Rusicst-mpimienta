// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM 
// Created          : 28-07-2017
//
// Last Modified By : Equipo de desarrollo OIM 
// Last Modified On : 08-10-2017
// ***********************************************************************
// <copyright file="ReAlimentacionController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The ReAlimentacion namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.ReAlimentacion
{
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Aplicacion.Adjuntos;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.SqlClient;
    using System.Linq;
    using System.Net.Http;
    using System.Web.Http;

    /// <summary>
    /// Class DisenoReporteController.
    /// </summary>
    [Authorize]
    public class ReAlimentacionController : ApiController
    {
        #region Admin Realimentación

        /// <summary>
        /// Obtener Adminatracion de Retroalimentacion
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerAdminRetro/")]
        public IEnumerable<C_ConsultaRetroalimentacion_Result> ObtenerAdminRetro()
        {
            IEnumerable<C_ConsultaRetroalimentacion_Result> resultado = Enumerable.Empty<C_ConsultaRetroalimentacion_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroalimentacion().Cast<C_ConsultaRetroalimentacion_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// ActualizarRetro
        /// </summary>
        /// <param name="model"></param>
        /// <returns>Acciones Resultado</returns>
        [HttpPost, AuditExecuted(Category.CrearRealimentacion)]
        [Route("api/ReAlimentacion/InsertarAdminRetro/")]
        public C_AccionesResultado InsertarAdminRetro(AdminRetroModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.I_RetroalimentacionInsert(model.Titulo, model.IdEncuesta).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// ActualizarRetro
        /// </summary>
        /// <param name="model"></param>
        /// <returns>Acciones Resultado</returns>
        [HttpPost, AuditExecuted(Category.EditarRealimentacion)]
        [Route("api/ReAlimentacion/ModificarAdminRetro/")]
        public C_AccionesResultado ModificarAdminRetro(AdminRetroModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.U_RetroalimentacionUpdate(model.Titulo, model.Id).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// ActualizarRetro
        /// </summary>
        /// <param name="model"></param>
        /// <returns>Acciones Resultado</returns>
        [HttpPost, AuditExecuted(Category.EliminarRealimentacion)]
        [Route("api/ReAlimentacion/EliminarAdminRetro/")]
        public C_AccionesResultado EliminarAdminRetro(AdminRetroModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_RetroalimentacionDelete(model.Id).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                model.Excepcion = true;
                model.ExcepcionMensaje = ex.Message;
            }

            return resultado;
        }

        /// <summary>
        /// Obtiene la encuesta.
        /// </summary>
        /// <param name="id">Identificador de la encuesta</param>
        /// <returns>Lista de encuestas</returns>
        [HttpPost]
        [Route("api/ReAlimentacion/ReAlimentacion/")]
        public C_ConsultaRetroEncuesta_Result Get(EncuestaRetroModels model)
        {
            C_ConsultaRetroEncuesta_Result resultado = new C_ConsultaRetroEncuesta_Result();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroEncuesta(model.IdRetroAdmin, model.Municipio).Cast<C_ConsultaRetroEncuesta_Result>().FirstOrDefault();
                    // sino existe deberia de crearse una en blanco, para comenzar a trabajar con ella
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// ActualizarRetro
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Acciones Resultado</returns>
        [HttpPost, AuditExecuted(Category.EditarEncuestaRealimentacion)]
        [Route("api/ReAlimentacion/ReAlimentacion/ActualizarRetro/")]
        public C_AccionesResultado ActualizarRetro(EncuestaRetroModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    if (model.IdTipoGuardado == 1)
                        resultado = BD.U_EncuestaRetroUpdate(model.IdRetroAdmin, model.Presentacion, model.PresTexto, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, model.IdTipoGuardado, model.Municipio).FirstOrDefault();
                    if (model.IdTipoGuardado == 2)
                        resultado = BD.U_EncuestaRetroUpdate(model.IdRetroAdmin, null, null, model.Nivel, model.NivTexto, model.Nivel2, model.Niv2Texto, null, null, null, null, null, null, null, null, null, null, null, null, null, null, model.IdTipoGuardado, model.Municipio).FirstOrDefault();
                    if (model.IdTipoGuardado == 3)
                        resultado = BD.U_EncuestaRetroUpdate(model.IdRetroAdmin, null, null, null, null, null, null, null, model.Desarrollo, model.DesTexto, model.Desarrollo2, model.Des2Texto, null, null, null, null, null, null, null, null, null, model.IdTipoGuardado, model.Municipio).FirstOrDefault();
                    if (model.IdTipoGuardado == 4)
                        resultado = BD.U_EncuestaRetroUpdate(model.IdRetroAdmin, null, null, null, null, null, null, null, null, null, null, null, null, model.Analisis, model.AnaTexto, null, null, null, null, null, null, model.IdTipoGuardado, model.Municipio).FirstOrDefault();
                    if (model.IdTipoGuardado == 5)
                        resultado = BD.U_EncuestaRetroUpdate(model.IdRetroAdmin, null, null, null, null, null, null, null, null, null, null, null, null, null, null, model.Revision, model.RevTexto, null, null, null, null, model.IdTipoGuardado, model.Municipio).FirstOrDefault();
                    if (model.IdTipoGuardado == 6)
                        resultado = BD.U_EncuestaRetroUpdate(model.IdRetroAdmin, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, model.Historial, model.HisTexto, null, null, model.IdTipoGuardado, model.Municipio).FirstOrDefault();
                    if (model.IdTipoGuardado == 7)
                        resultado = BD.U_EncuestaRetroUpdate(model.IdRetroAdmin, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, model.Observa, model.ObsTexto, model.IdTipoGuardado, model.Municipio).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion

        /// <summary>
        /// ObtenerDatosNivelAdmin
        /// </summary>
        /// <param name="pIdEncuesta"></param>
        /// <param name="pIdDepartamento"></param>
        /// <param name="pIdMunicipio"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerDatosNivelAdmin/")]
        public C_ConsultaRetroEncuestaNivel_Result ObtenerDatosNivelAdmin(int pIdRetroAdmin, string pIdUser)
        {
            C_ConsultaRetroEncuestaNivel_Result resultado = new C_ConsultaRetroEncuestaNivel_Result();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 6000;
                    resultado = BD.C_ConsultaRetroEncuestaNivel(pIdRetroAdmin, pIdUser).Cast<C_ConsultaRetroEncuestaNivel_Result>().FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// ObtenerDatosNivelAdmin
        /// </summary>
        /// <param name="pIdEncuesta"></param>
        /// <param name="pIdDepartamento"></param>
        /// <param name="pIdMunicipio"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerPreguntaXcodigo/")]
        public IEnumerable<C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo_Result> ObtenerPreguntaXcodigo(string pCodigoPregunta, string pIdsEncuestao)
        {
            IEnumerable<C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo_Result> resultado = Enumerable.Empty<C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo(pCodigoPregunta, pIdsEncuestao).Cast<C_ConsultaRetroEncuestaPreguntaXCodigoDesarrollo_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Pregunta Xcodigo Archivo
        /// </summary>
        /// <param name="pCodigoPregunta"></param>
        /// <param name="pIdEncuesta"></param>
        /// <param name="pIdDepartamento"></param>
        /// <param name="pIdMunicipio"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerPreguntaXcodigoArchivoAdmin/")]
        public IEnumerable<C_ConsultaRetroEncuestaPreguntaXCodigoArchivoAdmin_Result> ObtenerPreguntaXcodigoArchivoAdmin(string pCodigoPregunta, int pIdEncuesta)
        {
            IEnumerable<C_ConsultaRetroEncuestaPreguntaXCodigoArchivoAdmin_Result> resultado = Enumerable.Empty<C_ConsultaRetroEncuestaPreguntaXCodigoArchivoAdmin_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroEncuestaPreguntaXCodigoArchivoAdmin(pCodigoPregunta, pIdEncuesta).Cast<C_ConsultaRetroEncuestaPreguntaXCodigoArchivoAdmin_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Pregunta Xcodigo Archivo
        /// </summary>
        /// <param name="pCodigoPregunta"></param>
        /// <param name="pIdEncuesta"></param>
        /// <param name="pIdDepartamento"></param>
        /// <param name="pIdMunicipio"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerPreguntaXcodigoArchivo/")]
        public IEnumerable<C_ConsultaRetroEncuestaPreguntaXCodigoArchivo_Result> ObtenerPreguntaXcodigoArchivo(string pCodigoPregunta, int pIdEncuesta, int pIdDepartamento, int pIdMunicipio)
        {
            IEnumerable<C_ConsultaRetroEncuestaPreguntaXCodigoArchivo_Result> resultado = Enumerable.Empty<C_ConsultaRetroEncuestaPreguntaXCodigoArchivo_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroEncuestaPreguntaXCodigoArchivo(pCodigoPregunta, pIdEncuesta, pIdDepartamento, pIdMunicipio).Cast<C_ConsultaRetroEncuestaPreguntaXCodigoArchivo_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Descargar Adjuntos.
        /// </summary>
        /// <param name="archivo">The archivo.</param>
        /// <param name="nombreArchivo">The nombre archivo.</param>
        /// <returns>FileResult.</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/Sistema/DescargarRetro/")]
        public HttpResponseMessage DescargarRetro(string path, string nombreArchivo)
        {
            try
            {                
                string[] parts = path.Split('\\');
                nombreArchivo = parts[parts.Length - 1];                
                return Archivo.DescargarRetroShared(path,nombreArchivo);
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return null;
            }
        }

        #region Nivel Diligenciamiento

        /// <summary>
        /// ActualizarRetro
        /// </summary>
        /// <param name="model"></param>
        /// <returns>Acciones Resultado</returns>
        [HttpPost, AuditExecuted(Category.EditarGraficaNivelRealimentacion)]
        [Route("api/ReAlimentacion/ReAlimentacion/ActualizarGrafNivel/")]
        public C_AccionesResultado ActualizarGrafNivel(RetroGraficaNivelModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.U_EncuestaRetroGrafNivelUpdate(model.IdRetroAdmin, model.IdNivelGraf, model.Color1Niv, model.Titulo, model.Nombre1Niv).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Grafica Retro Nivel
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerGraficaRetroNivel/")]
        public IEnumerable<C_ConsultaRetroGraficaNivel_Result> ObtenerGraficaRetroNivel(int pIdRetroAdmin)
        {
            IEnumerable<C_ConsultaRetroGraficaNivel_Result> resultado = Enumerable.Empty<C_ConsultaRetroGraficaNivel_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroGraficaNivel(pIdRetroAdmin).Cast<C_ConsultaRetroGraficaNivel_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion

        #region Análisis Recomendaciones

        /// <summary>
        /// Obtener recomendacion de  analisis
        /// </summary>
        /// <param name="pIdEncuesta"></param>
        /// <param name="pUsername"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerAnaRecomendacion/")]
        public IEnumerable<C_ConsultaRetroAnaRecomendacion_Result> ObtenerAnaRecomendacion(int pIdEncuesta, string pUsername)
        {
            IEnumerable<C_ConsultaRetroAnaRecomendacion_Result> resultado = Enumerable.Empty<C_ConsultaRetroAnaRecomendacion_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroAnaRecomendacion(pIdEncuesta, pUsername).Cast<C_ConsultaRetroAnaRecomendacion_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Actualizar Ana Recomendacion
        /// </summary>
        /// <param name="pIdRetroAna"></param>
        /// <param name="pAccionPer"></param>
        /// <param name="pAccionCum"></param>
        /// <param name="pObservacion"></param>
        /// <param name="pAlcRes"></param>
        /// <returns></returns>
        [HttpPost, AuditExecuted(Category.EditarAnalisisRecomendacionRealimentacion)]
        [Route("api/ReAlimentacion/ReAlimentacion/ActualizarAnaRecomendacion/")]
        public C_AccionesResultado ActualizarAnaRecomendacion(RetroAnalisisRecModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.U_RetroAnaRecomendacionUpdate(model.Id, model.AccionPermite, model.AccionCumplio, model.Observacion, model.alcaldiaRespuesta).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion

        #region Preguntas Desarrollo

        /// <summary>
        /// Obtener Adminatracion de Retroalimentacion
        /// </summary>
        /// <returns></returns>
        //[HttpGet]
        //[Route("api/ReAlimentacion/ObtenerRetroDesPreguntas/")]
        //public IEnumerable<C_ConsultaRetroDesPreguntas_Result> ObtenerRetroDesPreguntas(int pIdRetroEncuesta)
        //{
        //    IEnumerable<C_ConsultaRetroDesPreguntas_Result> resultado = Enumerable.Empty<C_ConsultaRetroDesPreguntas_Result>();

        //    using (EntitiesRusicst BD = new EntitiesRusicst())
        //    {

        //    }

        //    return resultado;
        //}

        /// <summary>
        /// Actualizar Retro
        /// </summary>
        /// <param name="model"></param>
        /// <returns>Acciones Resultado</returns>
        [HttpPost, AuditExecuted(Category.EliminarRetroDesPregunta)]
        [Route("api/ReAlimentacion/EliminarRetroDesPreguntas/")]
        public C_AccionesResultado EliminarRetroDesPreguntas(RetroDesPreguntasModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_RetroDesPreguntasDelete(model.IdRetroAdmin).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// ActualizarRetro
        /// </summary>
        /// <param name="model"></param>
        /// <returns>Acciones Resultado</returns>
        [HttpPost, AuditExecuted(Category.EliminarRetroDesPregunta)]
        [Route("api/ReAlimentacion/EliminarRetroDesPreguntaXId/")]
        public C_AccionesResultado EliminarRetroDesPreguntaXId(RetroDesPreguntasModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_RetroDesPreguntaXIdDelete(model.IdPregunta).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Actualizar Retro
        /// </summary>
        /// <param name="model"></param>
        /// <returns>Acciones Resultado</returns>
        [HttpPost]
        [Route("api/ReAlimentacion/InsertarRetroDesPreguntas/")]
        public C_AccionesResultado InsertarRetroDesPreguntas(IEnumerable<RetroPreguntasDesModels> pListaPreguntas)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_RetroDesPreguntasDelete(pListaPreguntas.FirstOrDefault().IdRetroConsulta).FirstOrDefault();

                    foreach (var item in pListaPreguntas)
                    {
                        resultado = BD.I_RetroDesPreguntasInsert(item.IdRetroConsulta, item.IdsEncuestas, item.CodigoPregunta, item.Valor).FirstOrDefault();
                        (new AuditExecuted(Category.CrearRetroPreguntasDes)).ActionExecutedManual(item);
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
        /// Obtener Datos Grafica Desarrollo Participacion
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerPreguntasDesXIdRetro/")]
        public IEnumerable<C_ConsultaRetroDesPreguntasXIdRetro_Result> ObtenerPreguntasDesXIdRetro(int pIdRetroAdmin)
        {
            IEnumerable<C_ConsultaRetroDesPreguntasXIdRetro_Result> resultado = Enumerable.Empty<C_ConsultaRetroDesPreguntasXIdRetro_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroDesPreguntasXIdRetro(pIdRetroAdmin).Cast<C_ConsultaRetroDesPreguntasXIdRetro_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion

        #region cargar GraficasDesarrollo

        /// <summary>
        /// Obtener Grafica Retro Desarrollo
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerGraficaRetroDesarrollo/")]
        public IEnumerable<C_ConsultaRetroGraficaDesarrollo_Result> ObtenerGraficaRetroDesarrollo(int pIdRetroAdmin)
        {
            IEnumerable<C_ConsultaRetroGraficaDesarrollo_Result> resultado = Enumerable.Empty<C_ConsultaRetroGraficaDesarrollo_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroGraficaDesarrollo(pIdRetroAdmin).Cast<C_ConsultaRetroGraficaDesarrollo_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// ActualizarRetro
        /// </summary>
        /// <param name="model"></param>
        /// <returns>Acciones Resultado</returns>
        [HttpPost, AuditExecuted(Category.EditarRetroGraficaDesarrollo)]
        [Route("api/ReAlimentacion/ReAlimentacion/ActualizarGrafDesarrollo/")]
        public C_AccionesResultado ActualizarGrafDesarrollo(RetroGraficaDesarrolloModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.U_EncuestaRetroGrafDesarrolloUpdate(model.IdRetroAdmin, model.ColorDesDis, model.ColorDesImp, model.ColorDesEval, model.Nombre1Des, model.Nombre2Des, model.Nombre3Des, model.Nombre4Des, model.Nombre5Des, model.Nombre6Des, model.Nombre7Des, model.Nombre8Des, model.Nombre9Des, model.Titulo).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Datos Grafica Desarrollo Dinamica
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerRetroUsuarioDesarrollo/")]
        public IEnumerable<C_ConsultaRetroUsuarioDesarrollo_Result> ObtenerRetroUsuarioDesarrollo(int pIdDepartamento)
        {
            IEnumerable<C_ConsultaRetroUsuarioDesarrollo_Result> resultado = Enumerable.Empty<C_ConsultaRetroUsuarioDesarrollo_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroUsuarioDesarrollo(pIdDepartamento).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Datos Grafica Acumulada
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerDatosGraficaDesAcumulada/")]
        public IEnumerable<C_DatosGraficaDesTodo_Result> ObtenerDatosGraficaDesAcumulada(int pIdRetroAdmin, string pUserName)
        {
            IEnumerable<C_DatosGraficaDesTodo_Result> resultado = Enumerable.Empty<C_DatosGraficaDesTodo_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DatosGraficaDesTodo(pIdRetroAdmin, pUserName).Cast<C_DatosGraficaDesTodo_Result>().ToList();
                }

            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Datos Grafica Desarrollo Dinamica
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerDatosGraficaDesDinamica/")]
        public IEnumerable<C_DatosGraficaDesDinamica_Result> ObtenerDatosGraficaDesDinamica(int pIdRetroAdmin, string pUserName)
        {
            IEnumerable<C_DatosGraficaDesDinamica_Result> resultado = Enumerable.Empty<C_DatosGraficaDesDinamica_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DatosGraficaDesDinamica(pIdRetroAdmin, pUserName).Cast<C_DatosGraficaDesDinamica_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Datos Grafica Desarrollo Comite
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerDatosGraficaDesComite/")]
        public IEnumerable<C_DatosGraficaDesComite_Result> ObtenerDatosGraficaDesComite(int pIdRetroAdmin, string pUserName)
        {
            IEnumerable<C_DatosGraficaDesComite_Result> resultado = Enumerable.Empty<C_DatosGraficaDesComite_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DatosGraficaDesComite(pIdRetroAdmin, pUserName).Cast<C_DatosGraficaDesComite_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Datos Grafica Desarrollo Territorial
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerDatosGraficaDesTerritorial/")]
        public IEnumerable<C_DatosGraficaDesTerritorial_Result> ObtenerDatosGraficaDesTerritorial(int pIdRetroAdmin, string pUserName)
        {
            IEnumerable<C_DatosGraficaDesTerritorial_Result> resultado = Enumerable.Empty<C_DatosGraficaDesTerritorial_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DatosGraficaDesTerritorial(pIdRetroAdmin, pUserName).Cast<C_DatosGraficaDesTerritorial_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Datos Grafica Desarrollo Participacion
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerDatosGraficaDesParticipacion/")]
        public IEnumerable<C_DatosGraficaDesParticipacion_Result> ObtenerDatosGraficaDesParticipacion(int pIdRetroAdmin, string pUserName)
        {
            IEnumerable<C_DatosGraficaDesParticipacion_Result> resultado = Enumerable.Empty<C_DatosGraficaDesParticipacion_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DatosGraficaDesParticipacion(pIdRetroAdmin, pUserName).Cast<C_DatosGraficaDesParticipacion_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Datos Grafica Desarrollo Articulacion
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerDatosGraficaDesArticulacion/")]
        public IEnumerable<C_DatosGraficaDesArticulacion_Result> ObtenerDatosGraficaDesArticulacion(int pIdRetroAdmin, string pUserName)
        {
            IEnumerable<C_DatosGraficaDesArticulacion_Result> resultado = Enumerable.Empty<C_DatosGraficaDesArticulacion_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DatosGraficaDesArticulacion(pIdRetroAdmin, pUserName).Cast<C_DatosGraficaDesArticulacion_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Datos Grafica Desarrollo Retorno
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerDatosGraficaDesRetorno/")]
        public IEnumerable<C_DatosGraficaDesRetorno_Result> ObtenerDatosGraficaDesRetorno(int pIdRetroAdmin, string pUserName)
        {
            IEnumerable<C_DatosGraficaDesRetorno_Result> resultado = Enumerable.Empty<C_DatosGraficaDesRetorno_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DatosGraficaDesRetorno(pIdRetroAdmin, pUserName).Cast<C_DatosGraficaDesRetorno_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Datos Grafica Desarrollo Adecuacion
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerDatosGraficaDesAdecuacion/")]
        public IEnumerable<C_DatosGraficaDesAdecuacion_Result> ObtenerDatosGraficaDesAdecuacion(int pIdRetroAdmin, string pUserName)
        {
            IEnumerable<C_DatosGraficaDesAdecuacion_Result> resultado = Enumerable.Empty<C_DatosGraficaDesAdecuacion_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DatosGraficaDesAdecuacion(pIdRetroAdmin, pUserName).Cast<C_DatosGraficaDesAdecuacion_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion

        #region Preguntas Archivos

        /// <summary>
        /// ActualizarRetro
        /// </summary>
        /// <param name="model"></param>
        /// <returns>Acciones Resultado</returns>
        [HttpPost]
        [Route("api/ReAlimentacion/InsertarRetroArcPreguntas/")]
        public C_AccionesResultado InsertarRetroArcPreguntas(IEnumerable<RetroPreguntasArcModels> pListaPreguntas)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    foreach (var item in pListaPreguntas)
                    {
                        if (item.Id == 0)
                        {
                            resultado = BD.I_RetroArcPreguntasInsert(item.IdRetroAdmin, item.IdEncuesta, item.CodigoPregunta, item.Documento, item.Check, item.Sumatoria, item.Pertenece, item.Observacion, item.Observacion2, item.Valor).FirstOrDefault();
                            (new AuditExecuted(Category.CrearRetroPreguntasArc)).ActionExecutedManual(item);
                        }
                        else
                        {
                            resultado = BD.U_RetroArcPreguntasUpdate(item.Id, item.CodigoPregunta, item.Documento, item.Check, item.Sumatoria, item.Pertenece, item.Observacion, item.Observacion2, item.Valor, item.Usuario).FirstOrDefault();
                            (new AuditExecuted(Category.EditarRetroPreguntasArc)).ActionExecutedManual(item);
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

        /// ActualizarRetro
        /// </summary>
        /// <param name="model"></param>
        /// <returns>Acciones Resultado</returns>
        [HttpPost, AuditExecuted(Category.EliminarRetroPreguntasArc)]
        [Route("api/ReAlimentacion/EliminarRetroArcPreguntas/")]
        public C_AccionesResultado EliminarRetroArcPreguntas(RetroPreguntasArcModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_RetroArcPreguntasDelete(model.Id).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Preguntas Rev X IdRetro x Admin
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerPreguntasRevXIdRetroAdmin/")]
        public IEnumerable<C_ConsultaRetroRevPreguntasXIdRetro_Result> ObtenerPreguntasRevXIdRetroAdmin(int pIdRetroAdmin)
        {
            IEnumerable<C_ConsultaRetroRevPreguntasXIdRetro_Result> resultado = Enumerable.Empty<C_ConsultaRetroRevPreguntasXIdRetro_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroRevPreguntasXIdRetro(pIdRetroAdmin).Cast<C_ConsultaRetroRevPreguntasXIdRetro_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Preguntas Rev X IdRetro x Municipio
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerPreguntasRevXIdRetroMunicipio/")]
        public IEnumerable<C_ConsultaRetroRevPreguntasXIdRetroMunicipio_Result> ObtenerPreguntasRevXIdRetroMunicipio(int pIdRetroAdmin, int pIdMunicipio, int pIdEncuesta)
        {
            IEnumerable<C_ConsultaRetroRevPreguntasXIdRetroMunicipio_Result> resultado = Enumerable.Empty<C_ConsultaRetroRevPreguntasXIdRetroMunicipio_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroRevPreguntasXIdRetroMunicipio(pIdRetroAdmin, pIdMunicipio, pIdEncuesta).Cast<C_ConsultaRetroRevPreguntasXIdRetroMunicipio_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtener Preguntas Rev X IdRetro x usuario
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerPreguntasRevXIdRetroXUsuario/")]
        public IEnumerable<C_ConsultaRetroRevPreguntasXIdRetroxUsuario_Result> ObtenerPreguntasRevXIdRetroXUsuario(int pIdRetroAdmin, string pUserName, int pIdEncuesta)
        {
            IEnumerable<C_ConsultaRetroRevPreguntasXIdRetroxUsuario_Result> resultado = Enumerable.Empty<C_ConsultaRetroRevPreguntasXIdRetroxUsuario_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroRevPreguntasXIdRetroxUsuario(pIdRetroAdmin, pUserName, pIdEncuesta).Cast<C_ConsultaRetroRevPreguntasXIdRetroxUsuario_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        [HttpPost]
        [Route("api/ReAlimentacion/ActualizarRetroArcPreguntasXUsuario/")]
        public C_AccionesResultado ActualizarRetroArcPreguntasXUsuario(IEnumerable<RetroPreguntasArcModels> pListaPreguntas)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    foreach (var item in pListaPreguntas)
                    {
                        resultado = BD.U_RetroArcPreguntasUpdateXUsuario(item.Id, item.Check, item.Pertenece, item.Observacion, item.Observacion2, item.Valor, item.Usuario).FirstOrDefault();
                        (new AuditExecuted(Category.EditarRetroPreguntasArc)).ActionExecutedManual(item);
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion

        /// <summary>
        /// Obtener Preguntas Rev X IdRetro x Municipio
        /// </summary>
        /// <param name="pIdRetroAdmin"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReAlimentacion/ObtenerHistoricoMunicipio/")]
        public IEnumerable<C_ConsultaRetroHistoricoXMunicipio_Result> ObtenerHistoricoMunicipio(string pIdMunicipio)
        {
            IEnumerable<C_ConsultaRetroHistoricoXMunicipio_Result> resultado = Enumerable.Empty<C_ConsultaRetroHistoricoXMunicipio_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsultaRetroHistoricoXMunicipio(pIdMunicipio).Cast<C_ConsultaRetroHistoricoXMunicipio_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Insertar Retro Historico X Encuesta
        /// </summary>
        /// <param name="model"></param>
        /// <returns>Acciones Resultado</returns>
        [HttpPost, AuditExecuted(Category.CrearRetroHistorialEncuesta)]
        [Route("api/ReAlimentacion/InsertarRetroHistoricoXEncuesta/")]
        public C_AccionesResultado InsertarRetroHistoricoXEncuesta(RetroHistoricoEncuestaModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 6000;
                    resultado = BD.I_RetroHistorialTodosInsert(model.IdEncuesta, model.IdPregunta, model.IdNombre).FirstOrDefault();
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