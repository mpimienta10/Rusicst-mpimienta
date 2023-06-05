// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 08-15-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-10-2017
// ***********************************************************************
// <copyright file="IndiceEncuestasController.cs" company="Ministerio del Interior">
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
    using Mininterior.RusicstMVC.Servicios.Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class IndiceEncuestasController.
    /// </summary>
    [Authorize]
    public class IndiceEncuestasController : ApiController
    {
        /// <summary>
        /// Gets the sections.
        /// </summary>
        /// <param name="model">entidad model.</param>
        /// <returns>Lista C_EncuestaSeccionesDraw</returns>
        [HttpPost]
        [Route("api/Reportes/IndiceEncuestas/ConsultarSecciones_Pintar")]
        public List<EncuestaDraw> ConsultarSecciones_Pintar(EncuestaId model)
        {
            IEnumerable<C_DibujarEncuestaSeccionesSubsecciones_Result> resultado = Enumerable.Empty<C_DibujarEncuestaSeccionesSubsecciones_Result>();
            var ListEncuesta = new List<EncuestaDraw>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DibujarEncuestaSeccionesSubsecciones(idEncuesta: model.IdEncuesta).Cast<C_DibujarEncuestaSeccionesSubsecciones_Result>().ToList();
                }
                var Secciones = resultado.Where(x => x.SuperSeccion == null).ToList();

                foreach (var seccion in Secciones)
                {
                    var IdS = seccion.Id;
                    var SubSecciones = resultado.Where(x => x.SuperSeccion == IdS).OrderBy(o => o.Titulo).ToList();

                    EncuestaDraw SD = new EncuestaDraw();
                    SD.Id = seccion.Id;
                    SD.Titulo = seccion.Titulo;
                    SD.SuperSeccion = seccion.SuperSeccion;
                    SD.OcultaTitulo = seccion.OcultaTitulo;
                    SD.Estilos = seccion.Estilos;
                    SD.Ayuda = seccion.Archivo == null ? "No tiene archivo" : "Si tiene archivo";
                    if (SubSecciones.Count > 0)
                    {
                        foreach (var SubSeccion in SubSecciones)
                        {
                            int _IdSub = SubSeccion.Id;
                            SubSeccionesDraw SSD = new Models.SubSeccionesDraw();
                            var paginas = resultado.Where(x => x.SuperSeccion == _IdSub).OrderBy(o => o.Titulo).ToList();

                            SSD.Id = SubSeccion.Id;
                            SSD.Titulo = SubSeccion.Titulo;
                            SSD.SuperSeccion = SubSeccion.SuperSeccion;
                            SSD.OcultaTitulo = SubSeccion.OcultaTitulo;
                            SSD.Estilos = SubSeccion.Estilos;

                            SD.LSubSecciones.Add(SSD);

                            foreach (var pagina in paginas)
                            {
                                SubSeccionesDraw SSD1 = new Models.SubSeccionesDraw();
                                SSD1.Id = pagina.Id;
                                SSD1.Titulo = pagina.Titulo;
                                SSD1.SuperSeccion = pagina.SuperSeccion;
                                SSD1.OcultaTitulo = pagina.OcultaTitulo;
                                SSD1.Estilos = pagina.Estilos;

                                if (paginas != null)
                                {
                                    SSD1.IdPagina = pagina.Id;
                                }
                                else
                                {
                                    SSD1.IdPagina = SubSeccion.Id;
                                }

                                SD.LSubSecciones.Add(SSD1);
                            }
                        }

                        ListEncuesta.Add(SD);
                    }
                    else
                    {
                        ListEncuesta.Add(SD);
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return ListEncuesta.OrderBy(o => o.Titulo).ToList();
        }
        /// <summary>
        /// Strings to byte array.
        /// </summary>
        /// <param name="str">if set to <c>true</c> [string].</param>
        /// <returns>System.Byte[].</returns>
        public static byte[] StrToByteArray(bool str)
        {
            return BitConverter.GetBytes(str);
        }
    }
}