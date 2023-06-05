// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 10-06-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-13-2017
// ***********************************************************************
// <copyright file="TableroMunicipioController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The TableroPat namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.TableroPat
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
    using System.Net.Http;
    using System.Web;
    using System.Web.Http;
    using RusicstMVC.Servicios.Controllers.Usuarios;
    using Helpers;
    using System.Net.Http.Headers;
    using System.Net;
    using System.Threading.Tasks;
    using Aplicacion.Adjuntos;

    /// <summary>
    /// Class GestionMunicipalController.
    /// </summary>
    public class GestionMunicipalController : ApiController
    {
        #region APIS PARA LA PANTALLA DE LOS TABLEROS    

        /// <summary>
        /// Listas the tableros municipio completados.
        /// </summary>
        /// <returns>IEnumerable&lt;C_TodosTablerosMunicipiosCompletos_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/TablerosMunicipio/ListaTablerosMunicipioCompletados/{Usuario}")]
        public IEnumerable<C_TodosTablerosMunicipiosCompletos_Result> ListaTablerosMunicipioCompletados(string Usuario = "")
        {
            IEnumerable<C_TodosTablerosMunicipiosCompletos_Result> resultado = Enumerable.Empty<C_TodosTablerosMunicipiosCompletos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    IEnumerable<C_Usuario_Result> ListaUsuarios = BD.C_Usuario(null, null, null, null, null, Usuario, null).Cast<C_Usuario_Result>().ToList();
                    C_Usuario_Result model = ListaUsuarios.FirstOrDefault();
                    resultado = BD.C_TodosTablerosMunicipiosCompletos(idUsuario: model.Id).Cast<C_TodosTablerosMunicipiosCompletos_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Listas the tableros municipio por completar.
        /// </summary>
        /// <returns>IEnumerable&lt;C_TodosTablerosMunicipiosPorCompletar_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/TablerosMunicipio/ListaTablerosMunicipioPorCompletar/{Usuario}")]
        public IEnumerable<C_TodosTablerosMunicipiosPorCompletar_Result> ListaTablerosMunicipioPorCompletar(string Usuario = "")
        {
            IEnumerable<C_TodosTablerosMunicipiosPorCompletar_Result> resultado = Enumerable.Empty<C_TodosTablerosMunicipiosPorCompletar_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    IEnumerable<C_Usuario_Result> ListaUsuarios = BD.C_Usuario(null, null, null, null, null, Usuario, null).Cast<C_Usuario_Result>().ToList();
                    C_Usuario_Result model = ListaUsuarios.FirstOrDefault();
                    resultado = BD.C_TodosTablerosMunicipiosPorCompletar(idUsuario: model.Id).Cast<C_TodosTablerosMunicipiosPorCompletar_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion

        #region APIS PARA PANTALLA DE MUNICIPIOS

        /// <summary>
        /// Derechoses the specified identifier tablero.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_Derechos_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/Derechos/{idTablero}")]
        public IEnumerable<C_Derechos_Result> Derechos(byte idTablero, int idUsuario, bool gestionDepartamental)
        {
            IEnumerable<C_Derechos_Result> resultado = Enumerable.Empty<C_Derechos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_Derechos(idTablero: idTablero, idUsuario: idUsuario, gestionDepartamental: gestionDepartamental).Cast<C_Derechos_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Tableroes the municipio.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="pageSize">Size of the page.</param>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroMunicipio_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/TableroMunicipio/{sortOrder},{page},{pageSize},{idUsuario},{busqueda},{idTablero}")]
        public IEnumerable<C_TableroMunicipio_Result> TableroMunicipio(string sortOrder, Int16 page, Int16 pageSize, int idUsuario, int idDerecho, byte idTablero)
        {
            IEnumerable<C_TableroMunicipio_Result> resultado = Enumerable.Empty<C_TableroMunicipio_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroMunicipio(sortOrder: sortOrder, page: page, pageSize: pageSize, idUsuario: idUsuario, idDerecho: idDerecho, idTablero: idTablero).Cast<C_TableroMunicipio_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Tableroes the municipio rc.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="pageSize">Size of the page.</param>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroMunicipioRC_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/Municipios/TableroMunicipioRC/")]
        public IEnumerable<C_TableroMunicipioRC_Result> TableroMunicipioRC(string sortOrder, Int16 page, Int16 pageSize, int idUsuario, int idDerecho, byte idTablero)
        {
            IEnumerable<C_TableroMunicipioRC_Result> resultado = Enumerable.Empty<C_TableroMunicipioRC_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroMunicipioRC(sortOrder: sortOrder, page: page, pageSize: pageSize, idUsuario: idUsuario, idDerecho: idDerecho, idTablero: idTablero).Cast<C_TableroMunicipioRC_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Tableroes the municipio rr.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="pageSize">Size of the page.</param>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroMunicipioRR_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/Municipios/TableroMunicipioRR/")]
        public IEnumerable<C_TableroMunicipioRR_Result> TableroMunicipioRR(string sortOrder, Int16 page, Int16 pageSize, int idUsuario, int idDerecho, byte idTablero)
        {
            IEnumerable<C_TableroMunicipioRR_Result> resultado = Enumerable.Empty<C_TableroMunicipioRR_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroMunicipioRR(sortOrder: sortOrder, page: page, pageSize: pageSize, idUsuario: idUsuario, idDerecho: idDerecho, idTablero: idTablero).Cast<C_TableroMunicipioRR_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Tableroes the fecha activo.
        /// </summary>
        /// <param name="nivel">The nivel.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Int32.</returns>
        [HttpGet]
        [Route("api/TableroPat/TableroFechaActivo/")]
        public int TableroFechaActivo(byte nivel, byte idTablero)
        {
            int resultado = 0;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroFechaActivo(nIVEL: nivel, iDTABLERO: idTablero).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Contars the tablero municipio.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Int32.</returns>
        [HttpGet]
        [Route("api/TableroPat/ContarTableroMunicipio/{idUsuario},{busqueda},{idTablero}")]
        public int ContarTableroMunicipio(int idUsuario, int idDerecho, byte idTablero)
        {
            int resultado = 0;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ContarTableroMunicipio(idUsuario: idUsuario, idDerecho: idDerecho, idTablero: idTablero).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Contars the tablero municipio rc.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Int32.</returns>
        [HttpGet]
        [Route("api/TableroPat/Municipios/ContarTableroMunicipioRC/")]
        public int ContarTableroMunicipioRC(int idUsuario, byte idTablero)
        {
            int resultado = 0;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ContarTableroMunicipioRC(idUsuario: idUsuario, idTablero: idTablero).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Contars the tablero municipio rr.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Int32.</returns>
        [HttpGet]
        [Route("api/TableroPat/Municipios/ContarTableroMunicipioRR/")]
        public int ContarTableroMunicipioRR(int idUsuario, byte idTablero)
        {
            int resultado = 0;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ContarTableroMunicipioRR(idUsuario: idUsuario, idTablero: idTablero).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Tableroes the municipio avance.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroMunicipioAvance_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/Municipios/TableroMunicipioAvance/")]
        public IEnumerable<C_TableroMunicipioAvance_Result> TableroMunicipioAvance(int idUsuario, byte idTablero)
        {
            IEnumerable<C_TableroMunicipioAvance_Result> resultado = Enumerable.Empty<C_TableroMunicipioAvance_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroMunicipioAvance(idUsuario: idUsuario, idTablero: idTablero).Cast<C_TableroMunicipioAvance_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Tableroes the vigencia.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroVigencia_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/Municipios/TableroVigencia/")]
        public IEnumerable<C_TableroVigencia_Result> TableroVigencia(byte idTablero)
        {
            IEnumerable<C_TableroVigencia_Result> resultado = Enumerable.Empty<C_TableroVigencia_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroVigencia(idTablero: idTablero).Cast<C_TableroVigencia_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Cargars the tablero.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="numMostrar">The number mostrar.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="Usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarTablero/{sortOrder},{page},{numMostrar},{idDerecho},{Usuario},{idTablero}")]
        public object CargarTablero(string sortOrder, Int16 page = 1, Int16 numMostrar = 10, int idDerecho = 0, string Usuario = "", byte idTablero = 0)
        {
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            AdministracionController clsAdmin = new AdministracionController();
            Sistema.ConfiguracionDerechosPATController clsConfDerechos = new Sistema.ConfiguracionDerechosPATController();
            var modelUsuario = new UsuariosModels { UserName = Usuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
            int IdUsuario = datosUsuario.FirstOrDefault().Id;

            HabilitarReportesController clsHabilitar = new HabilitarReportesController();
            PermisoUsuarioEncuestaModels modelHabilitarExtension = new PermisoUsuarioEncuestaModels();
            modelHabilitarExtension.IdUsuario = IdUsuario;
            modelHabilitarExtension.IdEncuesta = idTablero;
            modelHabilitarExtension.IdTipoTramite = 3;

            bool activo = TableroFechaActivo(3, idTablero) > 0 || clsHabilitar.ValidarExtensiones(modelHabilitarExtension);

            //Si se envio el tablero se debe inactivar para guardar informacion
            //bool tableroEnviado = ValidarEnvioTableroPat(IdUsuario, idTablero, "PM");
            //if (activo == true && tableroEnviado == true)
            //{
            //    activo = false;
            //}

            int totalItems = ContarTableroMunicipio(IdUsuario, idDerecho, idTablero);
            int totalItemsRC = ContarTableroMunicipioRC(IdUsuario, idTablero);
            int totalItemsRR = ContarTableroMunicipioRR(IdUsuario, idTablero);
            var TotalPages = (int)Math.Ceiling(totalItems / (double)numMostrar);
            var TotalPagesRC = (int)Math.Ceiling(totalItemsRC / (double)numMostrar);
            var TotalPagesRR = (int)Math.Ceiling(totalItemsRR / (double)numMostrar);

            string userPat = Usuario;

            string canFill = TableroFechaActivo(3, idTablero) > 0 ? "true" : "false";

            var avance = TableroMunicipioAvance(IdUsuario, idTablero);
            var datos = TableroMunicipio(sortOrder, page, numMostrar, IdUsuario, idDerecho, idTablero);
            var derechos = Derechos(idTablero, IdUsuario, false);
            var vigencia = TableroVigencia(idTablero);
            var datosRC = TableroMunicipioRC(sortOrder, page, numMostrar, IdUsuario, idDerecho, idTablero);
            var datosRR = TableroMunicipioRR(sortOrder, page, numMostrar, IdUsuario, idDerecho, idTablero);
            var urlDerechos = clsConfDerechos.CargarParametros((byte)idDerecho);

            //validacion del envio tablero PAT planeacion
            Boolean ActivoEnvioPATPlaneacion = false;
            if (activo)
            {
                var tablero = clsAdmin.ListaTodosTableros().Where(s => s.IdTablero == idTablero && s.Nivel == 3).FirstOrDefault();               
                if (tablero != null)
                {
                    ActivoEnvioPATPlaneacion = tablero.ActivoEnvioPATPlaneacion == null ? false : Convert.ToBoolean(tablero.ActivoEnvioPATPlaneacion);
                }
            }
            var objeto = new
            {
                activo = activo,
                avance = avance,
                datos = datos,
                derechos = derechos,
                vigencia = vigencia,
                datosUsuario = datosUsuario,
                datosRC = datosRC,
                datosRR = datosRR,
                totalItems = totalItems,
                TotalPages = TotalPages,
                totalItemsRC = totalItemsRC,
                TotalPagesRC = TotalPagesRC,
                totalItemsRR = totalItemsRR,
                TotalPagesRR = TotalPagesRR,
                userPat = userPat,
                canFil = canFill,
                urlDerechos = urlDerechos,
                ActivoEnvioPATPlaneacion = ActivoEnvioPATPlaneacion
            };

            return objeto;
        }

        /// <summary>
        /// Cargars the tablero rr.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="numMostrar">The number mostrar.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="Usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarTableroRR/{sortOrder},{page},{numMostrar},{idDerecho},{Usuario},{idTablero}")]
        public object CargarTableroRR(string sortOrder, Int16 page = 1, Int16 numMostrar = 10, int idDerecho = 0, string Usuario = "", byte idTablero = 0)
        {
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            var modelUsuario = new UsuariosModels { UserName = Usuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
            int IdUsuario = datosUsuario.FirstOrDefault().Id;
            int totalItemsRR = ContarTableroMunicipioRR(IdUsuario, idTablero);
            var TotalPagesRR = (int)Math.Ceiling(totalItemsRR / (double)numMostrar);
            var datosRR = TableroMunicipioRR(sortOrder, page, numMostrar, IdUsuario, idDerecho, idTablero);

            var objeto = new
            {
                datosRR = datosRR,
                totalItemsRR = totalItemsRR,
                TotalPagesRR = TotalPagesRR,
            };

            return objeto;
        }

        /// <summary>
        /// Cargars the tablero rc.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="numMostrar">The number mostrar.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="Usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarTableroRC/{sortOrder},{page},{numMostrar},{idDerecho},{Usuario},{idTablero}")]
        public object CargarTableroRC(string sortOrder, Int16 page = 1, Int16 numMostrar = 10, int idDerecho = 0, string Usuario = "", byte idTablero = 0)
        {
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            var modelUsuario = new UsuariosModels { UserName = Usuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
            int IdUsuario = datosUsuario.FirstOrDefault().Id;
            int totalItemsRC = ContarTableroMunicipioRC(IdUsuario, idTablero);
            var TotalPagesRC = (int)Math.Ceiling(totalItemsRC / (double)numMostrar);
            var datosRC = TableroMunicipioRC(sortOrder, page, numMostrar, IdUsuario, idDerecho, idTablero);

            var objeto = new
            {
                datosRC = datosRC,
                totalItemsRC = totalItemsRC,
                TotalPagesRC = TotalPagesRC,
            };

            return objeto;
        }

        /// <summary>
        /// Datoses the excel.
        /// </summary>
        /// <param name="idMunicipio">The identifier municipio.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>HttpResponseMessage.</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/TableroPat/Municipios/DatosExcel/")]
        public HttpResponseMessage DatosExcel(int idMunicipio, byte idTablero)
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

            IEnumerable<C_DatosExcel_Municipios_Result> dataMunicipios = Enumerable.Empty<C_DatosExcel_Municipios_Result>();
            IEnumerable<C_DatosExcel_MunicipiosReparacionColectiva_Result> dataMunicipiosRC = Enumerable.Empty<C_DatosExcel_MunicipiosReparacionColectiva_Result>();
            IEnumerable<C_DatosExcel_MunicipiosRetornosReubicaciones_Result> dataMunicipiosRR = Enumerable.Empty<C_DatosExcel_MunicipiosRetornosReubicaciones_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    dataMunicipios = BD.C_DatosExcel_Municipios(idMunicipio: idMunicipio, idTablero: idTablero).Cast<C_DatosExcel_Municipios_Result>().ToList();
                    dataMunicipiosRC = BD.C_DatosExcel_MunicipiosReparacionColectiva(idMunicipio, idTablero).Cast<C_DatosExcel_MunicipiosReparacionColectiva_Result>().ToList();
                    dataMunicipiosRR = BD.C_DatosExcel_MunicipiosRetornosReubicaciones(idMunicipio, idTablero).Cast<C_DatosExcel_MunicipiosRetornosReubicaciones_Result>().ToList();
                }

                // Create the workbook
                var workbook = new XLWorkbook();
                var ws = workbook.Worksheets.Add("Reporte Tablero PAT");

                #region Encabezado columnas Reporte Tablero PAT

                ws.Cell(1, 1).Value = "Derecho";
                ws.Column(1).AdjustToContents();
                ws.Range(1, 1, 2, 1).Merge();
                ws.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 2).Value = "Componente";
                ws.Column(2).AdjustToContents();
                ws.Range(1, 2, 2, 2).Merge();
                ws.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 3).Value = "Medida";
                ws.Column(3).AdjustToContents();
                ws.Range(1, 3, 2, 3).Merge();
                ws.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 4).Value = "Pregunta";
                ws.Column(4).AdjustToContents();
                ws.Range(1, 4, 2, 4).Merge();
                ws.Cell(1, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 5).Value = "Necesidad";
                ws.Column(5).AdjustToContents();
                ws.Range(1, 5, 1, 7).Merge();
                ws.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 5).Value = "Unidad";
                ws.Column(5).AdjustToContents();
                ws.Cell(2, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 6).Value = "Respuesta";
                ws.Column(6).AdjustToContents();
                ws.Cell(2, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 7).Value = "Observación";
                ws.Column(7).AdjustToContents();
                ws.Cell(2, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 8).Value = "Compromiso";
                ws.Column(8).AdjustToContents();
                ws.Range(1, 8, 1, 11).Merge();
                ws.Cell(1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 8).Value = "Unidad";
                ws.Column(8).AdjustToContents();
                ws.Cell(2, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 9).Value = "Respuesta";
                ws.Column(9).AdjustToContents();
                ws.Cell(2, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 9).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 10).Value = "Observación";
                ws.Column(10).AdjustToContents();
                ws.Cell(2, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 10).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 11).Value = "Presupuesto";
                ws.Column(11).AdjustToContents();
                ws.Cell(2, 11).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 11).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 12).Value = "Acciones";
                ws.Column(12).AdjustToContents();
                ws.Range(1, 12, 2, 12).Merge();
                ws.Cell(1, 12).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 12).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 13).Value = "Programas";
                ws.Column(13).AdjustToContents();
                ws.Range(1, 13, 2, 13).Merge();
                ws.Cell(1, 13).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 13).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;


                ws.Range(1, 1, 1, 13).Style.Font.Bold = true;
                ws.Range(2, 1, 2, 13).Style.Font.Bold = true;

                #endregion

                #region Data Excel

                int fila = 3;

                foreach (var item in dataMunicipios)
                {
                    ws.Cell(fila, 1).Value = item.DERECHO;
                    ws.Cell(fila, 2).Value = item.COMPONENTE;
                    ws.Cell(fila, 3).Value = item.MEDIDA;
                    ws.Cell(fila, 4).Value = item.PREGUNTAINDICATIVA;
                    //ws.Cell(fila, 5).Value = item.PREGUNTACOMPROMISO;
                    ws.Cell(fila, 5).Value = item.UNIDADMEDIDA;
                    ws.Cell(fila, 6).Value = item.RESPUESTAINDICATIVA;
                    ws.Cell(fila, 7).Value = item.OBSERVACIONNECESIDAD;
                    ws.Cell(fila, 8).Value = item.UNIDADMEDIDA;
                    ws.Cell(fila, 9).Value = item.RESPUESTACOMPROMISO;
                    ws.Cell(fila, 10).Value = item.OBSERVACIONCOMPROMISO;

                    ws.Cell(fila, 11).Value = item.PRESUPUESTO;
                    ws.Cell(fila, 11).Style.NumberFormat.Format = "$ #,##0";
                    ws.Cell(fila, 11).DataType = XLCellValues.Number;

                    ws.Cell(fila, 12).Value = item.ACCION;
                    ws.Cell(fila, 13).Value = item.PROGRAMA;

                    fila++;
                }

                ws.Range(1, 1, fila, 13).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws.Range(1, 1, fila, 13).Style.Border.OutsideBorderColor = XLColor.Black;

                ws.Range(1, 1, fila, 13).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws.Range(1, 1, fila, 13).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion

                ////==========================
                //// Reparación Colectiva
                ////==========================
                var ws2 = workbook.Worksheets.Add("Reparaciones Colectivas");

                #region Encabezado columnas Reparación Colectiva

                ws2.Cell(1, 1).Value = "Código Dane";
                ws2.Column(1).AdjustToContents();
                ws2.Range(1, 1, 2, 1).Merge();
                ws2.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 2).Value = "Municipio";
                ws2.Column(2).AdjustToContents();
                ws2.Range(1, 2, 2, 2).Merge();
                ws2.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 3).Value = "Sujeto";
                ws2.Column(3).AdjustToContents();
                ws2.Range(1, 3, 2, 3).Merge();
                ws2.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 4).Value = "Medida Reparación Colectiva";
                ws2.Column(4).AdjustToContents();
                ws2.Range(1, 4, 2, 4).Merge();
                ws2.Cell(1, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 5).Value = "Medida";
                ws2.Column(5).AdjustToContents();
                ws2.Range(1, 5, 2, 5).Merge();
                ws2.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 6).Value = "Acción";
                ws2.Column(6).AdjustToContents();
                ws2.Range(1, 6, 2, 6).Merge();
                ws2.Cell(1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 7).Value = "Presupuesto";
                ws2.Column(7).AdjustToContents();
                ws2.Range(1, 7, 2, 7).Merge();
                ws2.Cell(1, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 8).Value = "Detalle Acciones";
                ws2.Column(8).AdjustToContents();
                ws2.Range(1, 8, 2, 8).Merge();
                ws2.Cell(1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Range(1, 1, 1, 8).Style.Font.Bold = true;

                #endregion

                #region Data Excel

                int fila2 = 3;

                foreach (var item in dataMunicipiosRC)
                {
                    ws2.Cell(fila2, 1).Value = item.DaneMunicipio;
                    ws2.Cell(fila2, 2).Value = item.Municipio;
                    ws2.Cell(fila2, 3).Value = item.Sujeto;
                    ws2.Cell(fila2, 4).Value = item.MedidaReparacionColectiva;
                    ws2.Cell(fila2, 5).Value = item.Medida;
                    ws2.Cell(fila2, 6).Value = item.Accion;
                    ws2.Cell(fila2, 7).Value = item.Presupuesto;

                    ws2.Cell(fila2, 7).Style.NumberFormat.Format = "$ #,##0";
                    ws2.Cell(fila2, 7).DataType = XLCellValues.Number;
                    ws2.Cell(fila2, 8).Value = item.DetalleAcciones;
                    fila2++;
                }

                ws2.Range(1, 1, fila2, 8).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws2.Range(1, 1, fila2, 8).Style.Border.OutsideBorderColor = XLColor.Black;

                ws2.Range(1, 1, fila2, 8).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws2.Range(1, 1, fila2, 8).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion

                ////===========================
                //// Retornos y Reubicaciones
                ////===========================
                var ws3 = workbook.Worksheets.Add("Retornos y Reubicaciones");

                #region Encabezado columnas Retornos y Reubicación

                ws3.Cell(1, 1).Value = "Código Dane";
                ws3.Column(1).AdjustToContents();
                ws3.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 2).Value = "Municipio";
                ws3.Column(2).AdjustToContents();
                ws3.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 3).Value = "Hogares";
                ws3.Column(3).AdjustToContents();
                ws3.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 4).Value = "Personas";
                ws3.Column(4).AdjustToContents();
                ws3.Cell(1, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 5).Value = "Sector";
                ws3.Column(5).AdjustToContents();
                ws3.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 6).Value = "Componente";
                ws3.Column(6).AdjustToContents();
                ws3.Cell(1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 7).Value = "Comunidad";
                ws3.Column(7).AdjustToContents();
                ws3.Cell(1, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 8).Value = "Ubicación";
                ws3.Column(8).AdjustToContents();
                ws3.Cell(1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 9).Value = "Medida Retorno Reubicación";
                ws3.Column(9).AdjustToContents();
                ws3.Cell(1, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 9).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 10).Value = "Indicador Retorno Reubicación";
                ws3.Column(10).AdjustToContents();
                ws3.Cell(1, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 10).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 11).Value = "Entidad Responsable";
                ws3.Column(11).AdjustToContents();
                ws3.Cell(1, 11).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 11).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 12).Value = "Acción";
                ws3.Column(12).AdjustToContents();
                ws3.Cell(1, 12).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 12).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 13).Value = "Presupuesto";
                ws3.Column(13).AdjustToContents();
                ws3.Cell(1, 13).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 13).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 14).Value = "Detalle Acciones";
                ws3.Column(14).AdjustToContents();
                ws3.Range(1, 14, 1, 14).Merge();
                ws3.Cell(1, 14).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 14).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Range(1, 1, 1, 14).Style.Font.Bold = true;

                #endregion

                #region Data Excel Hoja 4

                int fila3 = 2;

                foreach (var item in dataMunicipiosRR)
                {
                    ws3.Cell(fila3, 1).Value = item.DaneMunicipio;
                    ws3.Cell(fila3, 2).Value = item.Municipio;
                    ws3.Cell(fila3, 3).Value = item.Hogares;
                    ws3.Cell(fila3, 4).Value = item.Personas;
                    ws3.Cell(fila3, 5).Value = item.Sector;
                    ws3.Cell(fila3, 6).Value = item.Componente;
                    ws3.Cell(fila3, 7).Value = item.Comunidad;
                    ws3.Cell(fila3, 8).Value = item.Ubicacion;
                    ws3.Cell(fila3, 9).Value = item.MedidaRetornoReubicacion;
                    ws3.Cell(fila3, 10).Value = item.IndicadorRetornoReubicacion;
                    ws3.Cell(fila3, 11).Value = item.EntidadResponsable;
                    ws3.Cell(fila3, 12).Value = item.Accion;
                    ws3.Cell(fila3, 13).Value = item.Presupuesto;
                    ws3.Cell(fila3, 13).Style.NumberFormat.Format = "$ #,##0";
                    ws3.Cell(fila3, 14).Value = item.DetalleAcciones;
                    fila3++;
                }

                ws3.Range(1, 1, fila3, 14).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws3.Range(1, 1, fila3, 14).Style.Border.OutsideBorderColor = XLColor.Black;

                ws3.Range(1, 1, fila3, 14).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws3.Range(1, 1, fila3, 14).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion


                var finalfilename = Path.Combine(@"c:\Temp", "Reporte_Municipal_Tablero_PAT");
                var filename = "Reporte_Municipal_Tablero_PAT.xlsx";
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

        #endregion

        #region APIS PARA EL ENVIO DE TABLERO PAT
        [HttpGet]
        [Route("api/TableroPat/ValidarEnvioTableroPat")]
        public bool ValidarEnvioTableroPat(int idUsuario, byte idTablero, string tipoEnvio)
        {
            bool resultado = false;
            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_ValidarEnvioTableroPat(idUsuario: idUsuario, idTablero: idTablero, tipoEnvio: tipoEnvio).Any();
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            return resultado;
        }

        [HttpPost]
        [Route("api/TableroPat/EnvioTablero")]
        public C_AccionesResultado EnvioTablero(EnvioTablero model)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            try
            {

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    Resultado = BD.I_EnvioTableroPat(idUsuario: model.idUsuario, idTablero: model.idTablero, tipoEnvio: model.tipoEnvio).FirstOrDefault();

                    if (Resultado.estado == 1)
                    {
                        C_DatosSistema_Result datosSistema = BD.C_DatosSistema().First();

                        var modelUsuario = new UsuariosModels { UserName = model.Usuario };
                        var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario).FirstOrDefault();

                        Helpers.Utilitarios.EnviarCorreoFinalizacionTableroPat(ref Resultado, new string[] { datosUsuario.Email != null && !string.IsNullOrEmpty(datosUsuario.Email) ? datosUsuario.Email : (datosUsuario.EmailAlternativo != null && !String.IsNullOrEmpty(datosUsuario.EmailAlternativo)) ? datosUsuario.EmailAlternativo : datosSistema.FromEmail }, model, datosSistema, model.tipoEnvio);
                        if (Resultado.estado != 1)
                        {
                            Resultado.estado = 0;
                            Resultado.respuesta = "Ocurrió un error finalizando el Tablero PAT. Por favor intente de nuevo";
                        }
                        else
                        {
                            Resultado.estado = 1;
                            Resultado.respuesta = "El Tablero PAT ha sido Enviado";

                            //  Auditoria del envio del tablero pat
                            model.AudUserName = model.AudUserName;
                            model.AddIdent = model.AddIdent;
                            model.UserNameAddIdent = model.UserNameAddIdent;
                            switch (model.tipoEnvio)
                            {
                                case "PM": //planeacion municipal
                                    (new AuditExecuted(Category.EnvioPlaneacionMunicipalPAT)).ActionExecutedManual(model);
                                    break;
                                case "PD": //planeacion departamental
                                    (new AuditExecuted(Category.EnvioPlaneacionDepartamentalPAT)).ActionExecutedManual(model);
                                    break;
                                case "SM1"://primer seguimiento municipal
                                    (new AuditExecuted(Category.EnvioPrimerSeguimientoMunicipalPAT)).ActionExecutedManual(model);
                                    break;
                                case "SM2"://segundo seguimiento municipal
                                    (new AuditExecuted(Category.EnvioSegundoSeguimientoMunicipalPAT)).ActionExecutedManual(model);
                                    break;
                                case "SD1"://primer seguimiento departamental
                                    (new AuditExecuted(Category.EnvioPrimerSeguimientoDepartamentalPAT)).ActionExecutedManual(model);
                                    break;
                                case "SD2"://segundo seguimiento departamental
                                    (new AuditExecuted(Category.EnvioSegundoSeguimientoDepartamentalPAT)).ActionExecutedManual(model);
                                    break;
                                default:
                                    break;
                            }

                        }
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                Resultado.estado = 0;
                Resultado.respuesta = "Ocurrió un error finalizando el Tablero PAT. Por favor intente de nuevo";
            }
            finally
            {
            }
            return Resultado;
        }

        [HttpGet]
        [Route("api/TableroPat/ListaEnvioTablero/")]
        public IEnumerable<C_EnvioTableroPat_Result> ListaEnvioTablero()
        {
            IEnumerable<C_EnvioTableroPat_Result> resultado = Enumerable.Empty<C_EnvioTableroPat_Result>();
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_EnvioTableroPat().Cast<C_EnvioTableroPat_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                //(new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            return resultado;
        }


        #endregion

        #region APIS PARA EDICION DE MUNICIPIOS

        /// <summary>
        /// Necesidadeses the identificadas.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="pregunta">The pregunta.</param>
        /// <returns>System.Int32.</returns>
        [HttpGet]
        [Route("api/TableroPat/Municipios/NecesidadesIdentificadasSIGO/")]
        public int NecesidadesIdentificadasSIGO(int idUsuario, short pregunta)
        {
            int resultado = 0;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_NecesidadesIdentificadas(uSUARIO: idUsuario, pREGUNTA: pregunta).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Accioneses the pat.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <param name="opcion">The opcion.</param>
        /// <returns>IEnumerable&lt;C_AccionesPAT_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/Municipios/AccionesPAT/")]
        public IEnumerable<C_AccionesPAT_Result> AccionesPAT(int id, string opcion)
        {
            IEnumerable<C_AccionesPAT_Result> resultado = Enumerable.Empty<C_AccionesPAT_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_AccionesPAT(iD: id, oPCION: opcion).Cast<C_AccionesPAT_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Programases the pat.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>IEnumerable&lt;C_ProgramasPAT_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/Municipios/ProgramasPAT/")]
        public IEnumerable<C_ProgramasPAT_Result> ProgramasPAT(int id)
        {
            IEnumerable<C_ProgramasPAT_Result> resultado = Enumerable.Empty<C_ProgramasPAT_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ProgramasPAT(iD: id).Cast<C_ProgramasPAT_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        [HttpGet]
        [Route("api/TableroPat/Municipios/FuentesPresupuestoRespuestaPAT/")]
        public IEnumerable<C_FuentePresupuestoPATDiligenciamiento_Result> FuentesPresupuestoRespuestaPAT(int idRespuesta)
        {
            IEnumerable<C_FuentePresupuestoPATDiligenciamiento_Result> resultado = Enumerable.Empty<C_FuentePresupuestoPATDiligenciamiento_Result>();
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_FuentePresupuestoPATDiligenciamiento(idRespuesta: idRespuesta).Cast<C_FuentePresupuestoPATDiligenciamiento_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            return resultado;
        }


        [HttpGet]
        [Route("api/TableroPat/PrecargueUnoaUno/")]
        public IEnumerable<C_UnoaUnoPrecargueSIGO_Result> PrecargueUnoaUno(int IdUsuario, int IdPregunta)
        {
            IEnumerable<C_UnoaUnoPrecargueSIGO_Result> resultado = Enumerable.Empty<C_UnoaUnoPrecargueSIGO_Result>();
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_UnoaUnoPrecargueSIGO(idPregunta: IdPregunta, idUsuario: IdUsuario).Cast<C_UnoaUnoPrecargueSIGO_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            return resultado;
        }


        [HttpGet]
        [Route("api/TableroPat/Municipios/FuentesPresupuestoPAT/")]
        public IEnumerable<C_FuentePresupuesto_Result> FuentesPresupuestoPAT()
        {
            IEnumerable<C_FuentePresupuesto_Result> resultado = Enumerable.Empty<C_FuentePresupuesto_Result>();
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_FuentePresupuesto().Cast<C_FuentePresupuesto_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            return resultado;
        }
        /// <summary>
        /// Datoses the iniciales edicion municipio.
        /// </summary>
        /// <param name="pregunta">The pregunta.</param>
        /// <param name="id">The identifier.</param>
        /// <param name="IdUsuario">The identifier usuario.</param>
        /// <param name="Usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosInicialesEdicionMunicipio/")]
        public object DatosInicialesEdicionMunicipio(short pregunta, int id, int IdUsuario, string Usuario = "", byte idTablero = 0)
        {

            HabilitarReportesController clsHabilitar = new HabilitarReportesController();
            PermisoUsuarioEncuestaModels modelHabilitarExtension = new PermisoUsuarioEncuestaModels();
            modelHabilitarExtension.IdUsuario = IdUsuario;
            modelHabilitarExtension.IdEncuesta = idTablero;
            modelHabilitarExtension.IdTipoTramite = 3;

            bool activo = TableroFechaActivo(3, idTablero) > 0 || clsHabilitar.ValidarExtensiones(modelHabilitarExtension);

            //Si se envio el tablero se debe inactivar para guardar informacion
            //bool tableroEnviado = ValidarEnvioTableroPat(IdUsuario, idTablero, "PM");
            //if (activo == true && tableroEnviado == true)
            //{
            //    activo = false;
            //}

            int totalNecesidades = NecesidadesIdentificadasSIGO(IdUsuario, pregunta);
            var FuentesPresupuestoRespuesta = FuentesPresupuestoRespuestaPAT(id);
            var listadoFuentesPresupuestoPAT = FuentesPresupuestoPAT();
            var datosAcciones = AccionesPAT(id, "");
            var datosProgramas = ProgramasPAT(id);

            var objeto = new
            {
                activo = activo,
                totalNecesidades = totalNecesidades,
                datosAcciones = datosAcciones,
                datosProgramas = datosProgramas,
                FuentesPresupuestoRespuesta = FuentesPresupuestoRespuesta,
                listadoFuentesPresupuestoPAT = listadoFuentesPresupuestoPAT
            };

            return objeto;
        }

        /// <summary>
        /// Modificars the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/ModificarMunicipio/")]
        public C_AccionesResultado Modificar(RespuestaPat model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            bool Insertando = false;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                using (var dbContextTransaction = BD.Database.BeginTransaction())
                {
                    try
                    {
                        if (model.ID > 0)
                        {
                            resultado = BD.U_RespuestaUpdate(iD: model.ID, iDPREGUNTA: model.IDPREGUNTA, nECESIDADIDENTIFICADA: model.NECESIDADIDENTIFICADA, rESPUESTAINDICATIVA: model.RESPUESTAINDICATIVA, rESPUESTACOMPROMISO: model.RESPUESTACOMPROMISO, pRESUPUESTO: model.PRESUPUESTO, oBSERVACIONNECESIDAD: model.OBSERVACIONNECESIDAD, aCCIONCOMPROMISO: model.ACCIONCOMPROMISO, iDUSUARIO: model.IDUSUARIO, nOMBREADJUNTO: model.NombreAdjunto, oBSERVACIONPRESUPUESTO: model.ObservacionPresupuesto).FirstOrDefault();
                            Insertando = false;
                        }
                        else
                        {
                            var datosInsert = BD.I_RespuestaInsert(iDUSUARIO: model.IDUSUARIO, iDPREGUNTA: model.IDPREGUNTA, nECESIDADIDENTIFICADA: model.NECESIDADIDENTIFICADA, rESPUESTAINDICATIVA: model.RESPUESTAINDICATIVA, rESPUESTACOMPROMISO: model.RESPUESTACOMPROMISO, pRESUPUESTO: model.PRESUPUESTO, oBSERVACIONNECESIDAD: model.OBSERVACIONNECESIDAD, aCCIONCOMPROMISO: model.ACCIONCOMPROMISO, nOMBREADJUNTO: model.NombreAdjunto, oBSERVACIONPRESUPUESTO: model.ObservacionPresupuesto).FirstOrDefault();
                            model.ID = datosInsert.id.Value;
                            resultado.estado = datosInsert.estado;
                            resultado.respuesta = datosInsert.respuesta;
                            Insertando = true;
                        }
                        if (resultado.estado == 1 || resultado.estado == 2)
                        {
                            if (model.RespuestaPatAccion != null)
                            {
                                if (model.RespuestaPatAccion.Count() > 0)
                                {
                                    foreach (var item in model.RespuestaPatAccion)
                                    {
                                        item.ID_PAT_RESPUESTA = model.ID;

                                        if (item.ID > 0)
                                        {
                                            resultado = BD.U_RespuestaAccionesUpdate(iD: item.ID, iDPATRESPUESTA: item.ID_PAT_RESPUESTA, aCCION: item.ACCION, aCTIVO: item.ACTIVO).FirstOrDefault();
                                            item.Insertado = false;
                                        }
                                        else
                                        {
                                            resultado = BD.I_RespuestaAccionesInsert(iDPATRESPUESTA: item.ID_PAT_RESPUESTA, aCCION: item.ACCION, aCTIVO: item.ACTIVO).FirstOrDefault();
                                            item.Insertado = true;
                                        }
                                        if (resultado.estado == 0)
                                        {
                                            break;
                                        }
                                    }
                                }
                            }
                            if (model.RespuestaPatPrograma != null)
                            {
                                if (model.RespuestaPatPrograma.Count() > 0)
                                {
                                    foreach (var item in model.RespuestaPatPrograma)
                                    {
                                        item.ID_PAT_RESPUESTA = model.ID;
                                        if (item.ID > 0)
                                        {
                                            resultado = BD.U_RespuestaProgramaUpdate(iD: item.ID, iD_PAT_RESPUESTA: item.ID_PAT_RESPUESTA, pROGRAMA: item.PROGRAMA, aCTIVO: item.ACTIVO).FirstOrDefault();
                                            item.Insertado = false;
                                        }
                                        else
                                        {
                                            resultado = BD.I_RespuestaProgramaInsert(iD_PAT_RESPUESTA: item.ID_PAT_RESPUESTA, pROGRAMA: item.PROGRAMA, aCTIVO: item.ACTIVO).FirstOrDefault();
                                            item.Insertado = true;
                                        }
                                        if (resultado.estado == 0)
                                        {
                                            break;
                                        }
                                    }
                                }
                            }
                            if (model.RespuestaPatFuente != null)
                            {
                                if (model.RespuestaPatFuente.Count > 0)
                                {
                                    foreach (var item in model.RespuestaPatFuente)
                                    {
                                        if (item.insertar)
                                        {
                                            resultado = BD.I_RespuestaFuentePresupuestoInsert(idRespuesta: model.ID, idFuentePresupuesto: item.Id).FirstOrDefault();
                                        }
                                        else
                                        {
                                            resultado = BD.D_RespuestaPATFuentePresupuesto(idFuente: item.Id, idRespuesta: model.ID).FirstOrDefault();
                                            if (resultado.estado == 3)
                                            {
                                                resultado.estado = 1;
                                            }
                                        }
                                    }
                                }
                            }
                            if (resultado.estado == 1 || resultado.estado == 2)
                            {
                                dbContextTransaction.Commit();

                                //// Audita la creación o actualización de la respuesta PAT
                                (new AuditExecuted(Insertando ? Category.CrearRespuestaPAT : Category.EditarRespuestaPAT)).ActionExecutedManual(model);

                                //// Audita la creación o actualización de la respuesta PAT acción
                                if (model.RespuestaPatAccion != null)
                                {
                                    if (model.RespuestaPatAccion.Count() > 0)
                                    {
                                        foreach (var item in model.RespuestaPatAccion)
                                        {
                                            item.AudUserName = model.AudUserName;
                                            item.AddIdent = model.AddIdent;
                                            item.UserNameAddIdent = model.UserNameAddIdent;
                                            (new AuditExecuted(item.Insertado ? Category.CrearRespuestaAccionesPAT : Category.EditarRespuestaAccionesPAT)).ActionExecutedManual(item);
                                        }
                                    }
                                }

                                //// Audita la creación o actualización de la respuesta PAT programa
                                if (model.RespuestaPatPrograma != null)
                                {
                                    if (model.RespuestaPatPrograma.Count() > 0)
                                    {
                                        foreach (var item in model.RespuestaPatPrograma)
                                        {
                                            item.AudUserName = model.AudUserName;
                                            item.AddIdent = model.AddIdent;
                                            item.UserNameAddIdent = model.UserNameAddIdent;
                                            (new AuditExecuted(item.Insertado ? Category.CrearRespuestaProgramaPAT : Category.EditarRespuestaProgramaPAT)).ActionExecutedManual(item);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        dbContextTransaction.Rollback();
                        (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                    }
                }
            }

            return resultado;
        }



        /// <summary>
        /// Adjutars the archivo seguimiento.
        /// </summary>
        /// <returns>Task&lt;HttpResponseMessage&gt;.</returns>
        [HttpPost]
        [Route("api/TableroPat/AdjutarArchivo/")]
        public async Task<HttpResponseMessage> AdjutarArchivo()
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                if (!this.Request.Content.IsMimeMultipartContent())
                {
                    this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
                }
                //// Obtener archivo multi-part
                var provider = Helpers.Utilitarios.GetMultipartProvider();
                var result = await this.Request.Content.ReadAsMultipartAsync(provider);

                if (result.FileData.Count > 0)
                {
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        AdjuntoPat model = (AdjuntoPat)Helpers.Utilitarios.GetFormData<AdjuntoPat>(result);
                        var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
                        var arc = new FileInfo(result.FileData.First().LocalFileName);
                        var archivo = File.ReadAllBytes(result.FileData.First().LocalFileName);
                        OriginalFileName = OriginalFileName.Replace('ñ', 'n').Replace('Ñ', 'N');

                        C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();
                        var path = Archivo.GuardarArchivoTableroPatShared(archivo, OriginalFileName, sistema.UploadDirectory, model.usuario, model.tablero, model.pregunta, model.type, Archivo.pathPATFilesDiligenciamiento);
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return this.Request.CreateResponse(HttpStatusCode.OK, new
            {
                resultado.estado,
                resultado.respuesta
            });
        }

        /// <summary>
        /// Descargars the specified archivo.
        /// </summary>
        /// <param name="archivo">The archivo.</param>
        /// <param name="nombreArchivo">The nombre archivo.</param>
        /// <param name="type">The type.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <returns>HttpResponseMessage.</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/TableroPat/DownloadDiligenciamiento/")]
        public HttpResponseMessage DownloadDiligenciamiento(string archivo, string nombreArchivo, string type, int idTablero, int idPregunta, int idUsuario)
        {
            try
            {
                string directorio = "";
                string dirSeguimiento = Archivo.pathPATFilesDiligenciamiento;
                directorio = Path.Combine(idUsuario.ToString(), idTablero.ToString(), type, idPregunta.ToString(), archivo);
                return Archivo.DescargarEncuestaShared(Archivo.pathPATFilesDiligenciamiento, directorio);
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return null;
            }
        }

        #endregion

        #region APIS PARA EDICION DE MUNICIPIOS RC REPARACION COLECTIVA

        /// <summary>
        /// Datoses the iniciales edicion municipio rc.
        /// </summary>
        /// <param name="pregunta">The pregunta.</param>
        /// <param name="id">The identifier.</param>
        /// <param name="IdUsuario">The identifier usuario.</param>
        /// <param name="Usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosInicialesEdicionMunicipioRC/")]
        public object DatosInicialesEdicionMunicipioRC(short pregunta, int id, int IdUsuario, string Usuario = "", byte idTablero = 0)
        {
            var datosAccionesRC = AccionesPAT(id, "RC");

            HabilitarReportesController clsHabilitar = new HabilitarReportesController();
            PermisoUsuarioEncuestaModels modelHabilitarExtension = new PermisoUsuarioEncuestaModels();
            modelHabilitarExtension.IdUsuario = IdUsuario;
            modelHabilitarExtension.IdEncuesta = idTablero;
            modelHabilitarExtension.IdTipoTramite = 3;

            bool activo = TableroFechaActivo(3, idTablero) > 0 || clsHabilitar.ValidarExtensiones(modelHabilitarExtension);

            //Si se envio el tablero se debe inactivar para guardar informacion
            //bool tableroEnviado = ValidarEnvioTableroPat(IdUsuario, idTablero, "PM");
            //if (activo == true && tableroEnviado == true)
            //{
            //    activo = false;
            //}

            var objeto = new
            {
                activo = activo,
                datosAccionesRC = datosAccionesRC
            };

            return objeto;
        }

        /// <summary>
        /// Modificars the rc.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/ModificarMunicipioRC/")]
        public C_AccionesResultado ModificarRC(RespuestaRCPat model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            bool Insertando = false;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                using (var dbContextTransaction = BD.Database.BeginTransaction())
                {
                    try
                    {
                        if (model.ID > 0)
                        {
                            resultado = BD.U_RespuestaRCUpdate(iD: model.ID, iDPREGUNTARC: model.IDPREGUNTARC, aCCION: model.ACCION, pRESUPUESTO: model.PRESUPUESTO).FirstOrDefault();
                            Insertando = false;
                        }
                        else
                        {
                            var datosInsert = BD.I_RespuestaRCInsert(iDUSUARIO: model.IDUSUARIO, iDENTIDAD: model.IDENTIDAD, iDPREGUNTARC: model.IDPREGUNTARC, aCCION: model.ACCION, pRESUPUESTO: model.PRESUPUESTO).FirstOrDefault();
                            model.ID = datosInsert.id.Value;
                            resultado.estado = datosInsert.estado;
                            resultado.respuesta = datosInsert.respuesta;
                            Insertando = true;
                        }
                        if (resultado.estado == 1 || resultado.estado == 2)
                        {
                            if (model.RespuestaRCPatAccion != null)
                            {
                                if (model.RespuestaRCPatAccion.Count() > 0)
                                {
                                    foreach (var item in model.RespuestaRCPatAccion)
                                    {
                                        item.ID_PAT_RESPUESTA_RC = model.ID;

                                        if (item.ID > 0)
                                        {
                                            resultado = BD.U_RespuestaAccionesRCUpdate(iD: item.ID, iDPATRESPUESTA: item.ID_PAT_RESPUESTA_RC, aCCION: item.ACCION, aCTIVO: item.ACTIVO).FirstOrDefault();
                                            item.Insertado = false;
                                        }
                                        else
                                        {
                                            resultado = BD.I_RespuestaAccionesRCInsert(iDPATRESPUESTA: item.ID_PAT_RESPUESTA_RC, aCCION: item.ACCION, aCTIVO: item.ACTIVO).FirstOrDefault();
                                            item.Insertado = true;
                                        }
                                        if (resultado.estado == 0)
                                        {
                                            break;
                                        }
                                    }
                                }
                            }
                            if (resultado.estado == 1 || resultado.estado == 2)
                            {
                                dbContextTransaction.Commit();

                                //// Audita la creación o actualización de la respuesta PAT RC
                                (new AuditExecuted(Insertando ? Category.CrearRespuestaRCPAT : Category.EditarRespuestaRCPAT)).ActionExecutedManual(model);

                                //// Audita cada una de las acciones de la respuesta RC PAT
                                if (model.RespuestaRCPatAccion != null)
                                {
                                    if (model.RespuestaRCPatAccion.Count() > 0)
                                    {
                                        foreach (var item in model.RespuestaRCPatAccion)
                                        {
                                            item.AudUserName = model.AudUserName;
                                            item.AddIdent = model.AddIdent;
                                            item.UserNameAddIdent = model.UserNameAddIdent;
                                            (new AuditExecuted(item.Insertado ? Category.CrearRespuestaRCAccionesPAT : Category.EditarRespuestaRCAccionesPAT)).ActionExecutedManual(item);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        dbContextTransaction.Rollback();
                        (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                    }
                }
            }

            return resultado;
        }

        #endregion

        #region APIS PARA EDICION DE MUNICIPIOS RR RETORNOS

        /// <summary>
        /// Datoses the iniciales edicion municipio rr.
        /// </summary>
        /// <param name="pregunta">The pregunta.</param>
        /// <param name="id">The identifier.</param>
        /// <param name="IdUsuario">The identifier usuario.</param>
        /// <param name="Usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosInicialesEdicionMunicipioRR/")]
        public object DatosInicialesEdicionMunicipioRR(short pregunta, int id, int IdUsuario, string Usuario = "", byte idTablero = 0)
        {
            var datosAccionesRR = AccionesPAT(id, "RR");
            HabilitarReportesController clsHabilitar = new HabilitarReportesController();
            PermisoUsuarioEncuestaModels modelHabilitarExtension = new PermisoUsuarioEncuestaModels();
            modelHabilitarExtension.IdUsuario = IdUsuario;
            modelHabilitarExtension.IdEncuesta = idTablero;
            modelHabilitarExtension.IdTipoTramite = 3;

            bool activo = TableroFechaActivo(3, idTablero) > 0 || clsHabilitar.ValidarExtensiones(modelHabilitarExtension);

            //Si se envio el tablero se debe inactivar para guardar informacion
            //bool tableroEnviado = ValidarEnvioTableroPat(IdUsuario, idTablero, "PM");
            //if (activo == true && tableroEnviado == true)
            //{
            //    activo = false;
            //}

            var objeto = new
            {
                activo = activo,
                datosAccionesRR = datosAccionesRR
            };

            return objeto;
        }

        /// <summary>
        /// Modificars the rr.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/ModificarMunicipioRR/")]
        public C_AccionesResultado ModificarRR(RespuestaRRPat model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            bool Insertando = false;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                using (var dbContextTransaction = BD.Database.BeginTransaction())
                {
                    try
                    {
                        if (model.ID > 0)
                        {
                            resultado = BD.U_RespuestaRRUpdate(iD: model.ID, iDPREGUNTARR: model.ID_PREGUNTA_RR, aCCION: model.ACCION, pRESUPUESTO: model.PRESUPUESTO).FirstOrDefault();
                            Insertando = false;
                        }
                        else
                        {
                            var datosInsert = BD.I_RespuestaRRInsert(iDUSUARIO: model.IDUSUARIO, iDPREGUNTARR: model.ID_PREGUNTA_RR, aCCION: model.ACCION, pRESUPUESTO: model.PRESUPUESTO).FirstOrDefault();
                            model.ID = datosInsert.id.Value;
                            resultado.estado = datosInsert.estado;
                            resultado.respuesta = datosInsert.respuesta;
                            Insertando = true;
                        }
                        if (resultado.estado == 1 || resultado.estado == 2)
                        {
                            if (model.RespuestaRRPatAccion != null)
                            {
                                if (model.RespuestaRRPatAccion.Count() > 0)
                                {
                                    foreach (var item in model.RespuestaRRPatAccion)
                                    {
                                        item.ID_PAT_RESPUESTA_RR = model.ID;

                                        if (item.ID > 0)
                                        {
                                            resultado = BD.U_RespuestaAccionesRRUpdate(iD: item.ID, iDPATRESPUESTA: item.ID_PAT_RESPUESTA_RR, aCCION: item.ACCION, aCTIVO: item.ACTIVO).FirstOrDefault();
                                            item.Insertado = false;
                                        }
                                        else
                                        {
                                            resultado = BD.I_RespuestaAccionesRRInsert(iDPATRESPUESTA: item.ID_PAT_RESPUESTA_RR, aCCION: item.ACCION, aCTIVO: item.ACTIVO).FirstOrDefault();
                                            item.Insertado = true;
                                        }
                                        if (resultado.estado == 0)
                                        {
                                            break;
                                        }
                                    }
                                }
                            }
                            if (resultado.estado == 1 || resultado.estado == 2)
                            {
                                dbContextTransaction.Commit();

                                //// Audita la creación o actualización de la respuesta RR PAT
                                (new AuditExecuted(Insertando ? Category.CrearRespuestaRRPAT : Category.EditarRespuestaRRPAT)).ActionExecutedManual(model);

                                //// Audita cada una de las acciones de la respuesta RR PAT
                                if (model.RespuestaRRPatAccion != null)
                                {
                                    if (model.RespuestaRRPatAccion.Count() > 0)
                                    {
                                        foreach (var item in model.RespuestaRRPatAccion)
                                        {
                                            item.AudUserName = model.AudUserName;
                                            item.AddIdent = model.AddIdent;
                                            item.UserNameAddIdent = model.UserNameAddIdent;
                                            (new AuditExecuted(item.Insertado ? Category.CrearRespuestaRRAccionesPAT : Category.EditarRespuestaRRAccionesPAT)).ActionExecutedManual(item);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        dbContextTransaction.Rollback();
                        (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                    }
                }
            }
            return resultado;
        }

        #endregion

        #region APIS PARA LA PANTALLA DE CONSULTA DE LISTADO DE ENTIDADES QUE DILIGENCIARON    

        /// <summary>
        /// Datoses the consulta diligenciamiento.
        /// </summary>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosConsultaDiligenciamiento/")]
        public object DatosConsultaDiligenciamiento()
        {
            var datos = ListaEntidadesConDiligenciamiento();
            var tableros = ListaTablerosConsultar();

            var objeto = new
            {
                datos = datos,
                tableros = tableros
            };

            return objeto;
        }

        /// <summary>
        /// Listas the entidades con diligenciamiento.
        /// </summary>
        /// <returns>IEnumerable&lt;C_EntidadesConRespuestaMunicipal_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/ListaEntidadesConDiligenciamiento/")]
        public IEnumerable<C_EntidadesConRespuestaMunicipal_Result> ListaEntidadesConDiligenciamiento()
        {
            IEnumerable<C_EntidadesConRespuestaMunicipal_Result> resultado = Enumerable.Empty<C_EntidadesConRespuestaMunicipal_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_EntidadesConRespuestaMunicipal().Cast<C_EntidadesConRespuestaMunicipal_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Listas the tableros consultar.
        /// </summary>
        /// <returns>IEnumerable&lt;C_ListadoTableros_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/ListaTablerosConsultar/")]
        public IEnumerable<C_ListadoTableros_Result> ListaTablerosConsultar()
        {
            IEnumerable<C_ListadoTableros_Result> resultado = Enumerable.Empty<C_ListadoTableros_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListadoTableros().Cast<C_ListadoTableros_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion
    }
}