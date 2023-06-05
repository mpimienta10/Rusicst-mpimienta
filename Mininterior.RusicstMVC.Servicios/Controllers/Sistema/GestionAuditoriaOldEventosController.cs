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
    public class GestionAuditoriaOldEventosController : ApiController
    {
        /// <summary>
        /// Obtiene toda la auditoría filtrada por categoría y usuario
        /// </summary>
        /// <returns>Lista de solicitudes</returns>
        [HttpPost]
        [Route("api/Sistema/LogXCategoriaOld/")]
        public IEnumerable<C_LogXCategoriaOld_Result> GetAll(LogFiltroModels model)
        {
            IEnumerable<C_LogXCategoriaOld_Result> resultado = Enumerable.Empty<C_LogXCategoriaOld_Result>();

            DateTime FechaInicio = model.FechaInicio.AddDays(-1).Date;
            DateTime FechaFin = model.FechaFin.AddDays(-1).Date.Add(DateTime.MaxValue.TimeOfDay);

            try
            {
                using (EntitiesRusicstLogOld BD = new EntitiesRusicstLogOld())
                {
                    BD.Database.CommandTimeout = 6000;
                    resultado = BD.C_LogXCategoriaOld(model.CategoryId, model.UserName, FechaInicio, FechaFin).Cast<C_LogXCategoriaOld_Result>().ToList();
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
        [Route("api/Sistema/LogXCategoriaExportarOld/")]
        public HttpResponseMessage LogXCategoriaExportarOld(int pCategoria, string pUserName, string pFechaIni, string pFechaFin)
        {
            List<C_LogXCategoriaExportarOld_Result> resultado = new List<C_LogXCategoriaExportarOld_Result>();

            DateTime FechaInicio = DateTime.Parse(pFechaIni).AddDays(-1).Date;
            DateTime FechaFin = DateTime.Parse(pFechaFin).AddDays(-1).Date.Add(DateTime.MaxValue.TimeOfDay);

            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);
            // Create the workbook
            var workbook = new XLWorkbook();
            var ws = workbook.Worksheets.Add("Log de Auditoria");

            try
            {
                using (EntitiesRusicstLogOld BD = new EntitiesRusicstLogOld())
                {
                    if (pUserName != "null")
                        resultado = BD.C_LogXCategoriaExportarOld(pCategoria, pUserName, FechaInicio, FechaFin).Cast<C_LogXCategoriaExportarOld_Result>().ToList();
                    else
                        resultado = BD.C_LogXCategoriaExportarOld(pCategoria, null, FechaInicio, FechaFin).Cast<C_LogXCategoriaExportarOld_Result>().ToList();
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
        [Route("api/Sistema/LogOld/")]
        public C_LogOld_Result Get(int logId)
        {
            C_LogOld_Result resultado = new C_LogOld_Result();

            try
            {
                using (EntitiesRusicstLogOld BD = new EntitiesRusicstLogOld())
                {
                    IEnumerable<C_LogOld_Result> list = BD.C_LogOld(logId).Cast<C_LogOld_Result>().ToList();
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