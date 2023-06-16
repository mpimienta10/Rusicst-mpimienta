// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-01-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-01-2017
// ***********************************************************************
// <copyright file="GestionAuditoriaEventosController.cs" company="Ministerio del Interior">
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
    using Entidades;
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
    /// Class GestionAuditoriaEventosController.
    /// </summary>
    [Authorize]
    public class GestionAuditoriaEventosController : ApiController
    {
        /// <summary>
        /// Obtiene toda la auditoría filtrada por categoría y usuario
        /// </summary>
        /// <returns>Lista de solicitudes</returns>
        [HttpPost]
        [Route("api/Sistema/LogXCategoria/")]
        public IEnumerable<C_LogXCategoria_Result> GetAll(LogFiltroModels model)
        {
            IEnumerable<C_LogXCategoria_Result> resultado = Enumerable.Empty<C_LogXCategoria_Result>();

            DateTime FechaInicio = model.FechaInicio.AddDays(-1).Date.Add(DateTime.MaxValue.TimeOfDay);
            DateTime FechaFin = model.FechaFin.Date.Add(DateTime.MaxValue.TimeOfDay);

            try
            {
                using (EntitiesRusicstLog BD = new EntitiesRusicstLog())
                {
                    BD.Database.CommandTimeout = 6000;
                    resultado = BD.C_LogXCategoria(model.CategoryId, model.UserName, FechaInicio, FechaFin).Cast<C_LogXCategoria_Result>().ToList();
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
        [Route("api/Sistema/LogXCategoriaExportar/")]
        public HttpResponseMessage LogXCategoriaExportar(int pCategoria, string pUserName, DateTime pFechaIni, DateTime pFechaFin)
        {
            List<C_LogXCategoriaExportar_Result> resultado = new List<C_LogXCategoriaExportar_Result>();

            DateTime FechaInicio = pFechaIni.AddDays(-1).Date.Add(DateTime.MaxValue.TimeOfDay);
            DateTime FechaFin = pFechaFin.Date.Add(DateTime.MaxValue.TimeOfDay);

            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);
            // Create the workbook
            var workbook = new XLWorkbook();
            var ws = workbook.Worksheets.Add("Log de Auditoria");

            try
            {
                using (EntitiesRusicstLog BD = new EntitiesRusicstLog())
                {
                    if (pUserName != "null" && pCategoria != 0)
                        resultado = BD.C_LogXCategoriaExportar(pCategoria, pUserName, FechaInicio, FechaFin).Cast<C_LogXCategoriaExportar_Result>().ToList();
                    else if (pUserName != "null" && pCategoria == 0)
                        resultado = BD.C_LogXCategoriaExportar(null, pUserName, FechaInicio, FechaFin).Cast<C_LogXCategoriaExportar_Result>().ToList();
                    else if (pUserName == "null" && pCategoria != 0)
                        resultado = BD.C_LogXCategoriaExportar(pCategoria, null, FechaInicio, FechaFin).Cast<C_LogXCategoriaExportar_Result>().ToList();
                    else
                        resultado = BD.C_LogXCategoriaExportar(null, null, FechaInicio, FechaFin).Cast<C_LogXCategoriaExportar_Result>().ToList();
                }

                #region Header Log Auditoria
                ws.Cell(2, 1).Style.Font.Bold = true;
                ws.Cell(2, 1).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(2, 1).Value = "Usuario";
                ws.Cell(2, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(2, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 2).Style.Font.Bold = true;
                ws.Cell(2, 2).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(2, 2).Value = "Fecha";
                ws.Cell(2, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(2, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 3).Style.Font.Bold = true;
                ws.Cell(2, 3).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(2, 3).Value = "Categoría";
                ws.Cell(2, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(2, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 4).Style.Font.Bold = true;
                ws.Cell(2, 4).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(2, 4).Value = "Url";
                ws.Cell(2, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(2, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 5).Style.Font.Bold = true;
                ws.Cell(2, 5).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(2, 5).Value = "Navegador";
                ws.Cell(2, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(2, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 6).Style.Font.Bold = true;
                ws.Cell(2, 6).Style.Font.FontColor = XLColor.FromHtml("#63002D");
                ws.Cell(2, 6).Value = "Mensaje";
                ws.Cell(2, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Justify;
                ws.Cell(2, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;
                #endregion


                int fila = 3;

                foreach (var item in resultado)
                {
                    ws.Cell(fila, 1).Value = item.Usuario;
                    ws.Cell(fila, 2).Value = item.Fecha;
                    ws.Cell(fila, 3).Value = item.Categoria;
                    int val = item.UrlYBrowser.IndexOf('|');
                    int fin = item.UrlYBrowser.Length - val;
                    ws.Cell(fila, 4).Value = item.UrlYBrowser.Substring(0, val);
                    ws.Cell(fila, 5).Value = item.UrlYBrowser.Substring(val, fin);
                    ws.Cell(fila, 6).Value = item.Mensaje;

                    fila++;
                }

                //ws.Range(1, 1, fila, 13).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                //ws.Range(1, 1, fila, 13).Style.Border.OutsideBorderColor = XLColor.Black;

                //ws.Range(1, 1, fila, 13).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                //ws.Range(1, 1, fila, 13).Style.Border.InsideBorderColor = XLColor.Black;
                var finalfilename = Path.Combine(@"c:\Temp", "Reporte_Auditoria");
                var filename = "Reporte_Auditoria.xlsx";
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
            }

            return null;
        }

        /// <summary>
        /// Selecciona la auditoría.
        /// </summary>
        /// <returns>Lista de Category</returns>
        [HttpGet]
        [Route("api/Sistema/Log/")]
        public C_Log_Result Get(int logId)
        {
            C_Log_Result resultado = new C_Log_Result();

            try
            {
                using (EntitiesRusicstLog BD = new EntitiesRusicstLog())
                {
                    IEnumerable<C_Log_Result> list = BD.C_Log(logId).Cast<C_Log_Result>().ToList();
                    resultado = list.Count() > 0 ? list.First() : resultado;
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