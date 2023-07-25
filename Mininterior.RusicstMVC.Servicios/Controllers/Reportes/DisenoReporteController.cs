// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-03-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 07-27-2017
// ***********************************************************************
// <copyright file="DisenoReporteController.cs" company="Ministerio del Interior">
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
    using Mininterior.RusicstMVC.Servicios.Helpers;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using System.Web.Http;

    /// <summary>
    /// Class DisenoReporteController.
    /// </summary>
    [Authorize]
    public class DisenoReporteController : ApiController
    {
        /// <summary>
        /// Obtiene todas las encuestas
        /// </summary>
        /// <returns>Lista de encuestas</returns>
        [Route("api/Reportes/DisenoReporte/")]
        public IEnumerable<C_EncuestaGrid_Result> Get()
        {
            IEnumerable<C_EncuestaGrid_Result> resultado = Enumerable.Empty<C_EncuestaGrid_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_EncuestaGrid().Cast<C_EncuestaGrid_Result>().ToList();

                    List<C_EncuestaGrid_Result> listaResultado = new List<C_EncuestaGrid_Result>();
                    foreach (var item in resultado)
                    {
                        item.FechaFin=item.FechaFin.AddDays(-1);
                        listaResultado.Add(item);
                    }
                    return listaResultado;
                }

            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtiene la encuesta.
        /// </summary>
        /// <param name="id">Identificador de la encuesta</param>
        /// <returns>Lista de encuestas</returns>
        [HttpGet]
        [Route("api/Reportes/DisenoReporte/{id}")]
        public C_EncuestaConsultar_Result Get(int id)
        {
            C_EncuestaConsultar_Result resultado = new C_EncuestaConsultar_Result();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_EncuestaConsultar(id, null, null, null, null, false, null, null, null).Cast<C_EncuestaConsultar_Result>().FirstOrDefault();
                    resultado.FechaFin = resultado.FechaFin.AddDays(-1);
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtiene la encuesta.
        /// </summary>
        /// <param name="id">Identificador de la encuesta</param>
        /// <returns>Lista de encuestas</returns>
        [HttpGet]
        [Route("api/Reportes/DisenoReporte/RolxEncuesta/{id}")]
        public IEnumerable<C_RolXEncuesta_Result> ObtenerRolesxEncuesta(int id)
        {
            IEnumerable<C_RolXEncuesta_Result> resultado = Enumerable.Empty<C_RolXEncuesta_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_RolXEncuesta(id).Cast<C_RolXEncuesta_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modifica una encuesta
        /// </summary>
        /// <param name="model">Entidad Encuesta.</param>
        /// <returns>resultado de la transacción.</returns>
        [HttpPost, AuditExecuted(Category.EditarEncuesta)]
        [Route("api/Reportes/DisenoReporte/Modificar/")]
        public C_AccionesResultado Modificar(EncuestaModels model)
        {
            //DateTime FechaActual = DateTime.Today;
            C_AccionesResultado resultado = new C_AccionesResultado();

            /*if (DateTime.Parse(model.FechaInicio.ToString("yyyy-MM-dd")) < DateTime.Parse(FechaActual.ToString("yyyy-MM-dd")))
            {
                resultado.estado = 0;
                resultado.respuesta = "El registro no puede ser modificado despues de la fecha de inicio de la encuesta (comuníquese con el administrador)";
                return resultado;
            }*/

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.U_EncuestaUpdate(model.Id, model.Titulo, model.Ayuda, DateTime.Parse(model.FechaInicio.ToString("yyyy-MM-dd")), DateTime.Parse(model.FechaFin.ToString("yyyy-MM-dd")).AddDays(1).AddSeconds(1), model.IsDeleted, model.TipoEncuesta, model.EncuestaRelacionada, model.AutoevaluacionHabilitada, model.ObtenerTiposReporte(model.TipoReporte), model.IsPrueba).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Insertar una encuesta
        /// </summary>
        /// <param name="model">Entidad Encuesta.</param>
        /// <returns>resultado de la transacción.</returns>
        [HttpPost, AuditExecuted(Category.CrearEncuesta)]
        [Route("api/Reportes/DisenoReporte/Insertar/")]
        public C_AccionesResultado Insertar(EncuestaModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.I_EncuestaInsert(model.Titulo, model.Ayuda, DateTime.Parse(model.FechaInicio.ToString("yyyy-MM-dd")), DateTime.Parse(model.FechaFin.ToString("yyyy-MM-dd")).AddDays(1).AddSeconds(1), model.IsDeleted, model.TipoEncuesta, model.EncuestaRelacionada, model.AutoevaluacionHabilitada, model.ObtenerTiposReporte(model.TipoReporte), model.IsPrueba).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Elimina la encuesta.
        /// </summary>
        /// <param name="id">Identificador de la encuesta.</param>
        /// <returns>resultado de la transacción.</returns>
        [HttpPost, AuditExecuted(Category.EliminarEncuesta)]
        [Route("api/Reportes/DisenoReporte/Eliminar/")]
        public C_AccionesResultado Eliminar(EncuestaModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_EncuestaDelete(id: model.Id).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Elimina la seccion.
        /// </summary>
        /// <param name="id">Identificador de la encuesta.</param>
        /// <returns>resultado de la transacción.</returns>
        [HttpPost, AuditExecuted(Category.EliminarSeccionEncuesta)]
        [Route("api/Reportes/DisenoReporte/EliminarSeccion/")]
        public C_AccionesResultado EliminarSeccion(SeccionModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_SeccionDelete(id: model.Id).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Insertar una encuesta
        /// </summary>
        /// <param name="model">Entidad Encuesta.</param>
        /// <returns>resultado de la transacción.</returns>
        [HttpPost, AuditExecuted(Category.CrearSeccionEncuesta)]
        [Route("api/Reportes/DisenoReporte/InsertarSeccion")]
        public C_AccionesResultado InsertarSeccion(SeccionModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.I_SeccionInsert(model.IdEncuesta, model.Titulo, model.Ayuda, model.SuperSeccion, model.IsDeleted, model.Archivo, model.OcultaTitulo, model.Estilos).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modificar Seccion
        /// </summary>
        /// <returns>Task&lt;HttpResponseMessage&gt;.</returns>
        [HttpPost]
        [Route("api/Reportes/DisenoReporte/ModificarSeccion")]
        public async Task<HttpResponseMessage> ModificarSeccion()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();
            FileInfo FileAdjunto = null;
            string OriginalFileName = string.Empty;
            int EstadoResultado = 0;

            if (!Request.Content.IsMimeMultipartContent())
            {
                Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Utilitarios.GetMultipartProvider();
            var result = await Request.Content.ReadAsMultipartAsync(provider);

            SeccionModels model = (SeccionModels)Utilitarios.GetFormData<SeccionModels>(result);

            if (model.SuperSeccion == 0)
                model.SuperSeccion = null;

            if (result.FileData.Count() > 0)
            {
                OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
                FileAdjunto = new FileInfo(result.FileData.First().LocalFileName);
                model.Archivo = File.ReadAllBytes(result.FileData.First().LocalFileName);
            }

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    if (model.Id == null) // INSERTAR NUEVO
                    {
                        Resultado = BD.I_SeccionInsert(model.IdEncuesta, model.Titulo, model.Ayuda, model.SuperSeccion, model.IsDeleted, model.Archivo, model.OcultaTitulo, model.Estilos).FirstOrDefault();
                        model.Id = Resultado.estado.Value;
                        EstadoResultado = 1;
                        if (model.Archivo != null)
                            EncuestaExcelUtils.ParseExcel(model);
                    }
                    else // ACTUALIZAR REGISTRO
                    {
                        if (model.Archivo.Length <= 5)
                            model.Archivo = null;
                        if (model.Archivo != null)
                            EncuestaExcelUtils.ParseExcel(model);
                        Resultado = BD.U_SeccionUpdate(model.Id, model.IdEncuesta, model.Titulo, model.Ayuda, model.SuperSeccion, model.IsDeleted, model.Archivo, model.OcultaTitulo, model.Estilos).FirstOrDefault();
                        EstadoResultado = 2;
                    }
                }


            }
            catch (Exception ex)
            {
                model.Excepcion = true;
                EstadoResultado = 0;
                Resultado.respuesta = model.ExcepcionMensaje = ex.Message;
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return this.Request.CreateResponse(HttpStatusCode.OK, new { EstadoResultado, Resultado.respuesta });
            }
            finally
            {
                (new Providers.AuditExecuted(EstadoResultado == 1 ? Category.CrearSeccionEncuesta : Category.EditarSeccionEncuesta)).ActionExecutedManual(model);
            }

            return this.Request.CreateResponse(HttpStatusCode.OK, new { EstadoResultado, Resultado.respuesta });
        }

        /// <summary>
        /// Obtener Secciones por Id Encuesta
        /// </summary>
        /// <param name="idSeccion">The identifier seccion.</param>
        /// <returns>List&lt;SeccionModels&gt;.</returns>
        [HttpPost]
        [Route("api/Reportes/DisenoReporte/DescargarExcelSeccion/{idSeccion}")]
        public HttpResponseMessage DescargarExcelSeccion(int idSeccion)
        {
            HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.InternalServerError);

            try
            {
                byte[] archivo;

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    archivo = BD.C_SeccionExcelEncuesta(idSeccion).FirstOrDefault();
                }
                if (archivo == null)
                    result = new HttpResponseMessage(HttpStatusCode.InternalServerError);
                else
                {
                    result = new HttpResponseMessage(HttpStatusCode.OK);
                    var stream = new MemoryStream(archivo);
                    result.Content = new StreamContent(stream);
                    result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return result;
        }

        /// <summary>
        /// Obtener Secciones por Id Encuesta
        /// </summary>
        /// <param name="idEncuesta">The identifier encuesta.</param>
        /// <returns>List&lt;SeccionModels&gt;.</returns>
        [HttpGet]
        [Route("api/Reportes/DisenoReporte/ObtenerSecciones/{idEncuesta}")]
        public List<SeccionModels> ObtenerSecciones(int idEncuesta)
        {
            IEnumerable<C_SeccionEncuesta_Result> resultado = Enumerable.Empty<C_SeccionEncuesta_Result>();
            var list = new List<SeccionModels>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_SeccionEncuesta(idEncuesta).Cast<C_SeccionEncuesta_Result>().ToList();
                }

                foreach (var s in resultado)
                {
                    var sup = s.SuperSeccion;
                    var prefix = "";
                    while (sup != null)
                    {
                        var supSec = resultado.Where(x => x.Id == sup.Value).FirstOrDefault();
                        prefix = supSec.Titulo + " > " + prefix;
                        sup = supSec.SuperSeccion;
                    }

                    SeccionModels ssss = new SeccionModels();
                    ssss.Id = s.Id;
                    ssss.TituloSS = prefix;
                    ssss.Titulo = s.Titulo;
                    ssss.Ayuda = s.Ayuda;
                    ssss.Estilos = s.Estilos;
                    ssss.SuperSeccion = s.SuperSeccion;
                    ssss.OcultaTitulo = s.OcultaTitulo;

                    list.Add(ssss);
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return list.OrderBy(o => o.TituloSS).ToList();
        }

        /// <summary>
        /// Obtener las Sub Secciones x
        /// </summary>
        /// <param name="idEncuesta">The identifier encuesta.</param>
        /// <returns>List&lt;SubSeccionModels&gt;.</returns>
        [HttpGet]
        [Route("api/Reportes/DisenoReporte/ObtenerSubSecciones/{idEncuesta}")]
        public List<SubSeccionModels> ObtenerSubSecciones(int idEncuesta)
        {
            List<SubSeccionModels> secciones = new List<SubSeccionModels>();

            try
            {
                secciones.AddRange(GetSubsecciones(idEncuesta, null, 0));

            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return secciones;
        }

        /// <summary>
        /// Gets the subsecciones.
        /// </summary>
        /// <param name="idEncuesta">The identifier encuesta.</param>
        /// <param name="superSeccion">The super seccion.</param>
        /// <param name="nivel">The nivel.</param>
        /// <returns>List&lt;SubSeccionModels&gt;.</returns>
        private List<SubSeccionModels> GetSubsecciones(int idEncuesta, int? superSeccion, int nivel)
        {
            IEnumerable<C_SeccionEncuesta_Result> resultado = Enumerable.Empty<C_SeccionEncuesta_Result>();
            var list = new List<SubSeccionModels>();

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                resultado = BD.C_SeccionEncuesta(idEncuesta).Cast<C_SeccionEncuesta_Result>().ToList();
            }
            var q = resultado;
            if (superSeccion.HasValue)
                q = q.Where(x => x.SuperSeccion == superSeccion);
            else
                q = q.Where(x => x.SuperSeccion.HasValue == false);
            var subs = q
                .OrderBy(x => x.Titulo)
                .ToList();

            foreach (var item in subs)
            {
                list.Add(new SubSeccionModels { Id = item.Id, SuperSeccion = item.SuperSeccion, Titulo = item.Titulo.PadLeft(item.Titulo.Length + nivel, '»').Replace("»", "» ") });
                var subList = GetSubsecciones(idEncuesta, item.Id, nivel + 1);
                list.AddRange(subList);
            }

            return list;
        }
    }
}