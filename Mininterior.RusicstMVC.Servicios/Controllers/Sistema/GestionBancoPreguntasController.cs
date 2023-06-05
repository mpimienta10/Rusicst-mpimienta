// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 08-01-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-09-2017
// ***********************************************************************
// <copyright file="GestionBancoPreguntasController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Sistema namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Sistema
{
    using Aplicacion.Seguridad;
    using ClosedXML.Excel;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Web.Http;

    /// <summary>
    /// Class ConfigurarHomeController.
    /// </summary>
    public class GestionBancoPreguntasController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/BancoPreguntas/")]
        public IEnumerable<C_PreguntasBancoPreguntas_Result> Get(int? idTipoPregunta, string codigoPregunta, bool isExportable)
        {
            IEnumerable<C_PreguntasBancoPreguntas_Result> resultado = Enumerable.Empty<C_PreguntasBancoPreguntas_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_PreguntasBancoPreguntas(idTipoPregunta, (string.IsNullOrEmpty(codigoPregunta) || string.IsNullOrWhiteSpace(codigoPregunta) ? null : codigoPregunta), isExportable).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Obtiene toda la auditoría filtrada por categoría y usuario
        /// </summary>
        /// <returns>Lista de solicitudes</returns>
        [HttpGet]
        [AllowAnonymous]
        [Route("api/Sistema/BancoPreguntas/ExportarBanco/")]
        public HttpResponseMessage ExportarBanco(int? idTipoPregunta, string codigoPregunta, bool isExportable)
        {
            IEnumerable<C_PreguntasBancoPreguntas_Result> resultado = Enumerable.Empty<C_PreguntasBancoPreguntas_Result>();

            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);
            // Create the workbook
            var workbook = new XLWorkbook(XLEventTracking.Disabled);
            var ws = workbook.Worksheets.Add("Banco de Preguntas");

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 240;
                    resultado = BD.C_PreguntasBancoPreguntas(idTipoPregunta, (string.IsNullOrEmpty(codigoPregunta) || string.IsNullOrWhiteSpace(codigoPregunta) ? null : codigoPregunta), isExportable).ToList();
                }

                #region Header Log Auditoria
                ws.Cell(1, 1).Style.Font.Bold = true;
                ws.Cell(1, 1).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(1, 1).Value = "Código de Pregunta";
                ws.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 2).Style.Font.Bold = true;
                ws.Cell(1, 2).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(1, 2).Value = "Nombre Pregunta";
                ws.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 3).Style.Font.Bold = true;
                ws.Cell(1, 3).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(1, 3).Value = "Tipo Pregunta";
                ws.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                #endregion

                int fila = 2;

                foreach (var item in resultado)
                {
                    ws.Cell(fila, 1).Value = item.CodigoPregunta;
                    ws.Cell(fila, 2).Value = item.NombrePregunta;
                    ws.Cell(fila, 3).Value = item.Nombre;

                    fila++;
                }

                ws.Column(1).AdjustToContents();
                ws.Column(2).AdjustToContents();
                ws.Column(3).AdjustToContents();

                //ws.Range(1, 1, fila, 3).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                //ws.Range(1, 1, fila, 3).Style.Border.OutsideBorderColor = XLColor.Black;

                //ws.Range(1, 1, fila, 3).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                //ws.Range(1, 1, fila, 3).Style.Border.InsideBorderColor = XLColor.Black;

                var finalfilename = Path.Combine(@"c:\Temp", "Reporte_BancoPreguntas");
                var filename = "Reporte_BancoPreguntas.xlsx";
                workbook.SaveAs(finalfilename + ".xlsx");

                GC.Collect();
                GC.WaitForPendingFinalizers();
                GC.Collect();

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

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/BancoPreguntas/CodigoPregunta")]
        public string GetCodigo()
        {
            string resultado = string.Empty;

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_BateriaCodigosPregunta_BancoPreguntas().FirstOrDefault();
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
        [Route("api/Sistema/BancoPreguntas/ListaTiposPregunta")]
        public IEnumerable<C_TiposPregunta_Result> GetTiposPregunta()
        {
            IEnumerable<C_TiposPregunta_Result> resultado = Enumerable.Empty<C_TiposPregunta_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_TiposPregunta().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modifica la información de la Pregunta del Banco de Preguntas.
        /// </summary>
        /// <param name="model">Entidad con los datos a actualizar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EditarBancoPregunta)]
        [Route("api/Sistema/BancoPreguntas/Modificar")]
        public C_AccionesResultado Modificar(BancoPreguntasModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.U_BancoPreguntas_PreguntaUpdatae(model.idPregunta, model.codigoPregunta, model.nombrePregunta, model.tipoPregunta).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Inserta una nueva pregunta del Banco de Preguntas.
        /// </summary>
        /// <param name="model">Entidad con los datos a insertar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.CrearBancoPregunta)]
        [Route("api/Sistema/BancoPreguntas/Insertar")]
        public C_AccionesResultado Insertar(BancoPreguntasModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.I_BancoPreguntas_PreguntaInsert(model.codigoPregunta, model.nombrePregunta, model.tipoPregunta).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Elimina la pregunta del Banco de Preguntas. En caso de estar asociada a alguna encuesta, lanza un mensaje al usuario indicando que debe eliminarla de la encuesta primero
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EliminarBancoPregunta)]
        [Route("api/Sistema/BancoPreguntas/Eliminar")]
        public C_AccionesResultado Eliminar(BancoPreguntasModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_PreguntaBancoPreguntasDelete(model.idPregunta).FirstOrDefault();
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
        /// <returns>Lista con los datos de los clasificadores de una pregunta del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/ClasificadoresPreguntas")]
        public IEnumerable<C_ClasificadoresPreguntasBancoPreguntas_Result> GetClasificadoresPreguntas(int idPregunta)
        {
            IEnumerable<C_ClasificadoresPreguntasBancoPreguntas_Result> resultado = Enumerable.Empty<C_ClasificadoresPreguntasBancoPreguntas_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ClasificadoresPreguntasBancoPreguntas(idPregunta).ToList();
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
        /// <param name="idClasificador">The identifier clasificador.</param>
        /// <returns>Lista con los datos de los clasificadores de una pregunta del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/ClasificadoresPreguntas/DetallesClasificadores")]
        public IEnumerable<C_DetallesClasificadoresPreguntasBancoPreguntas_Result> GetDetallesClasificadoresPreguntas(int idClasificador)
        {
            IEnumerable<C_DetallesClasificadoresPreguntasBancoPreguntas_Result> resultado = Enumerable.Empty<C_DetallesClasificadoresPreguntasBancoPreguntas_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_DetallesClasificadoresPreguntasBancoPreguntas(idClasificador).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modifica la información del detalle del clasificador de la Pregunta del Banco de Preguntas.
        /// </summary>
        /// <param name="model">Entidad con los datos a actualizar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EditarDetalledeClasificadoresdePregunta)]
        [Route("api/Sistema/ClasificadoresPreguntas/ModificarDetalleClasificador")]
        public C_AccionesResultado ModificarDetalleClasificador(DetalleClasificador model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.U_BancoPreguntas_PreguntaUpdateClasificador(model.idPregunta, model.idDetalle, model.idDetalleClasificador).FirstOrDefault();
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
        /// <returns>Lista con los datos de los clasificadores del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/Clasificadores")]
        public IEnumerable<C_ClasificadoresBancoPreguntas_Result> GetClasificadores()
        {
            IEnumerable<C_ClasificadoresBancoPreguntas_Result> resultado = Enumerable.Empty<C_ClasificadoresBancoPreguntas_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ClasificadoresBancoPreguntas().ToList();
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
        /// <param name="idClasificador">The identifier clasificador.</param>
        /// <returns>Lista con los datos de los clasificadores de una pregunta del Banco de Preguntas</returns>
        [HttpGet]
        [Route("api/Sistema/Clasificadores/DetallesClasificadores")]
        public IEnumerable<C_DetallesClasificadoresPreguntasBancoPreguntas_Result> GetDetallesClasificadores(int idClasificador)
        {
            IEnumerable<C_DetallesClasificadoresPreguntasBancoPreguntas_Result> resultado = Enumerable.Empty<C_DetallesClasificadoresPreguntasBancoPreguntas_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_DetallesClasificadoresPreguntasBancoPreguntas(idClasificador).Where(x => !x.ValorDefecto).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Inserta un nuevo detalle en un clasificador del Banco de Preguntas.
        /// </summary>
        /// <param name="model">Entidad con los datos a insertar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.CrearDetalledeClasificadoraPregunta)]
        [Route("api/Sistema/Clasificadores/Insertar")]
        public C_AccionesResultado InsertarDetalle(DetalleClasificador model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.I_BancoPreguntas_DetalleClasificadorInsert(model.idClasificador, model.nombreDetalle).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modifica la información del detalle del clasificador del Banco de Preguntas.
        /// </summary>
        /// <param name="model">Entidad con los datos a actualizar.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EditarDetalledeClasificadoresdePregunta)]
        [Route("api/Sistema/Clasificadores/Modificar")]
        public C_AccionesResultado ModificarDetalle(DetalleClasificador model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.U_BancoPreguntas_ClasificadorUpdateDetalle(model.idClasificador, model.idDetalle, model.nombreDetalle).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Elimina el detalle del clasificador del Banco de Preguntas.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>Estado y respuesta.</returns>
        [HttpPost, AuditExecuted(Category.EliminarDetalledeClasificadordePregunta)]
        [Route("api/Sistema/Clasificadores/Eliminar")]
        public C_AccionesResultado EliminarDetalle(DetalleClasificador model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.D_DetalleClasificadorBancoPreguntasDelete(model.idClasificador, model.idDetalle).FirstOrDefault();

                    if (resultado.respuesta.Contains("FK_PreguntaDetalleClasificador_DetalleClasificador"))
                    {
                        resultado.respuesta = "No se puede eliminar el Detalle del Clasificador, éste se encuentra asignado a alguna(s) pregunta(s).";
                    }
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