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
    using System.Net;
    using System.Net.Http.Headers;

    /// <summary>
    /// Class SeguimientoDepartamentalController.
    /// </summary>
    public class SeguimientoDepartamentalController : ApiController
    {
        #region APIS PARA LA PANTALLA DE LOS TABLEROS DE SEGUIMIENTO COMPLETADOS Y POR COMPLETAR  

        /// <summary>
        /// Listas the tableros seguimiento municipio completados.
        /// </summary>
        /// <returns>IEnumerable&lt;C_TodosTablerosSeguimientoDepartamentosCompletados_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/ListaTablerosSeguimientoDepartamentoCompletados/{Usuario}")]
        public IEnumerable<C_TodosTablerosSeguimientoDepartamentosCompletados_Result> ListaTablerosSeguimientoMunicipioCompletados(string Usuario = "")
        {
            IEnumerable<C_TodosTablerosSeguimientoDepartamentosCompletados_Result> resultado = Enumerable.Empty<C_TodosTablerosSeguimientoDepartamentosCompletados_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    IEnumerable<C_Usuario_Result> ListaUsuarios = BD.C_Usuario(null, null, null, null, null, Usuario, null).Cast<C_Usuario_Result>().ToList();
                    C_Usuario_Result model = ListaUsuarios.FirstOrDefault();
                    resultado = BD.C_TodosTablerosSeguimientoDepartamentosCompletados(idUsuario: model.Id).Cast<C_TodosTablerosSeguimientoDepartamentosCompletados_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Listas the tableros seguimiento municipio por completar.
        /// </summary>
        /// <returns>IEnumerable&lt;C_TodosTablerosSeguimientoDepartamentosPorCompletar_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/ListaTablerosSeguimientoDepartamentoPorCompletar/{Usuario}")]
        public IEnumerable<C_TodosTablerosSeguimientoDepartamentosPorCompletar_Result> ListaTablerosSeguimientoMunicipioPorCompletar(string Usuario = "")
        {
            IEnumerable<C_TodosTablerosSeguimientoDepartamentosPorCompletar_Result> resultado = Enumerable.Empty<C_TodosTablerosSeguimientoDepartamentosPorCompletar_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    IEnumerable<C_Usuario_Result> ListaUsuarios = BD.C_Usuario(null, null, null, null, null, Usuario, null).Cast<C_Usuario_Result>().ToList();
                    C_Usuario_Result model = ListaUsuarios.FirstOrDefault();
                    resultado = BD.C_TodosTablerosSeguimientoDepartamentosPorCompletar(idUsuario: model.Id).Cast<C_TodosTablerosSeguimientoDepartamentosPorCompletar_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion

        #region APIS PARA PANTALLA INICIAL DE SEGUIMIENTO DEPARTAMENTOS

        /// <summary>
        /// Gets the tablero seguimiento departamento avance.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroSeguimientoDepartamentoAvance_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetTableroSeguimientoDepartamentoAvance/")]
        public IEnumerable<C_TableroSeguimientoDepartamentoAvance_Result> GetTableroSeguimientoDepartamentoAvance(int idUsuario, byte idTablero)
        {
            IEnumerable<C_TableroSeguimientoDepartamentoAvance_Result> resultado = Enumerable.Empty<C_TableroSeguimientoDepartamentoAvance_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroSeguimientoDepartamentoAvance(idUsuario: idUsuario, idTablero: idTablero).Cast<C_TableroSeguimientoDepartamentoAvance_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the tablero seguimiento departamento.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroSeguimientoDepartamento_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetTableroSeguimientoDepartamento/")]
        public IEnumerable<C_TableroSeguimientoDepartamento_Result> GetTableroSeguimientoDepartamento(int idUsuario, byte idTablero)
        {
            IEnumerable<C_TableroSeguimientoDepartamento_Result> resultado = Enumerable.Empty<C_TableroSeguimientoDepartamento_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroSeguimientoDepartamento(idTablero: idTablero, idUsuario: idUsuario).Cast<C_TableroSeguimientoDepartamento_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// carga los datos del tablero cuando se ingresa a seguimiento departamental
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="numMostrar">The number mostrar.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="Usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarTableroSeguimientoDepartamental/{sortOrder},{page},{numMostrar},{idDerecho},{Usuario},{idTablero}")]
        public object CargarTableroSeguimientoDepartamental(string sortOrder, Int16 page = 1, Int16 numMostrar = 10, int idDerecho = 0, string Usuario = "", byte idTablero = 0)
        {
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            GestionMunicipalController clsuMunicipios = new GestionMunicipalController();
            SeguimientoMunicipalController clsSegMunicipios = new SeguimientoMunicipalController();
            AdministracionController clsAdmin = new AdministracionController();

            var modelUsuario = new UsuariosModels { UserName = Usuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
            int IdUsuario = datosUsuario.FirstOrDefault().Id;



            HabilitarReportesController clsHabilitar = new HabilitarReportesController();
            PermisoUsuarioEncuestaModels modelHabilitarExtension = new PermisoUsuarioEncuestaModels();
            modelHabilitarExtension.IdUsuario = IdUsuario;
            modelHabilitarExtension.IdEncuesta = idTablero;
            modelHabilitarExtension.IdTipoTramite = 4;// 4 para el seguimiento 1 

            int? numSeguimiento = clsSegMunicipios.GetNumSeguimientoTablero(idTablero, 2).Select(a => a.NumeroSeguimiento).FirstOrDefault();
            bool activo = numSeguimiento.HasValue;
            if (!activo)
            {
                if (clsHabilitar.ValidarExtensiones(modelHabilitarExtension))
                {
                    numSeguimiento = 1;
                    activo = true;
                }
                else
                {
                    modelHabilitarExtension.IdTipoTramite = 5; // 5 para el seguimiento 2 
                    if (clsHabilitar.ValidarExtensiones(modelHabilitarExtension))
                    {
                        numSeguimiento = 2;
                        activo = true;
                    }
                }
            }
            //Si se envio el tablero se debe inactivar para guardar informacion
            //bool tableroEnviado = clsuMunicipios.ValidarEnvioTableroPat(IdUsuario, idTablero, "SD" + numSeguimiento);
            //if (activo == true && tableroEnviado == true)
            //{
            //    activo = false;
            //}

            int totalItems = 50;
            int totalItemsRC = 50;
            int totalItemsRR = 50;
            var TotalPages = (int)Math.Ceiling(totalItems / (double)numMostrar);
            var TotalPagesRC = (int)Math.Ceiling(totalItemsRC / (double)numMostrar);
            var TotalPagesRR = (int)Math.Ceiling(totalItemsRR / (double)numMostrar);
            var avance = GetTableroSeguimientoDepartamentoAvance(IdUsuario, idTablero);
            var tablero = GetTableroSeguimientoDepartamento(IdUsuario, idTablero);
            var derechos = clsuMunicipios.Derechos(idTablero, IdUsuario, true);
            var vigencia = clsSegMunicipios.GetTableroSeguimientoVigencia(idTablero, 2);
            var datosOD = GetTableroSeguimientoDepartamentoOtrosDerechos(idTablero, IdUsuario);

            //validacion del envio tablero PAT seguimiento
            Boolean ActivoEnvioPATSeguimiento = false;
            if (activo)
            {
                var datostablero = clsAdmin.ListaTodosTableros().Where(s => s.IdTablero == idTablero && s.Nivel == 2).FirstOrDefault();               
                if (datostablero != null)
                {
                    ActivoEnvioPATSeguimiento = datostablero.ActivoEnvioPATSeguimiento == null ? false : Convert.ToBoolean(datostablero.ActivoEnvioPATSeguimiento);
                }
            }

            var objeto = new
            {
                activo = activo,
                numSeguimiento = numSeguimiento,
                avance = avance,
                tablero = tablero,
                derechos = derechos,
                datosUsuario = datosUsuario,
                datosOD = datosOD,
                vigencia = vigencia,
                idTablero = idTablero,
                totalItems = totalItems,
                TotalPages = TotalPages,
                totalItemsRC = totalItemsRC,
                TotalPagesRC = TotalPagesRC,
                totalItemsRR = totalItemsRR,
                TotalPagesRR = TotalPagesRR,
                ActivoEnvioPATSeguimiento = ActivoEnvioPATSeguimiento
            };

            return objeto;
        }

        /// <summary>
        /// Gets the tablero seguimiento consolidad departamento.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <returns>IEnumerable&lt;C_TableroSeguimientoConsolidadoDepartamento_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetTableroSeguimientoConsolidadDepartamento/")]
        public IEnumerable<C_TableroSeguimientoConsolidadoDepartamento_Result> GetTableroSeguimientoConsolidadDepartamento(byte idTablero, int idUsuario, int idDerecho)
        {
            IEnumerable<C_TableroSeguimientoConsolidadoDepartamento_Result> resultado = Enumerable.Empty<C_TableroSeguimientoConsolidadoDepartamento_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroSeguimientoConsolidadoDepartamento(idTablero: idTablero, idUsuario: idUsuario, idDerecho: idDerecho).Cast<C_TableroSeguimientoConsolidadoDepartamento_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the tablero seguimiento departamento otros derechos.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <returns>IEnumerable&lt;C_TableroSeguimientoDepartamentoOtrosDerechos_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetTableroSeguimientoDepartamentoOtrosDerechos/")]
        public IEnumerable<C_TableroSeguimientoDepartamentoOtrosDerechos_Result> GetTableroSeguimientoDepartamentoOtrosDerechos(byte idTablero, int idUsuario)
        {
            IEnumerable<C_TableroSeguimientoDepartamentoOtrosDerechos_Result> resultado = Enumerable.Empty<C_TableroSeguimientoDepartamentoOtrosDerechos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroSeguimientoDepartamentoOtrosDerechos(idTablero: idTablero, idUsuario: idUsuario).Cast<C_TableroSeguimientoDepartamentoOtrosDerechos_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the municipio rc.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <returns>IEnumerable&lt;C_MunicipiosReparacionColectiva_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetMunicipioRC/")]
        public IEnumerable<C_MunicipiosReparacionColectiva_Result> GetMunicipioRC(byte idTablero, int idUsuario)
        {
            IEnumerable<C_MunicipiosReparacionColectiva_Result> resultado = Enumerable.Empty<C_MunicipiosReparacionColectiva_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_MunicipiosReparacionColectiva(idUsuario: idUsuario, idTablero: idTablero).Cast<C_MunicipiosReparacionColectiva_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the municipio rr.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <returns>IEnumerable&lt;C_MunicipiosRetornosReubicaciones_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetMunicipioRR/")]
        public IEnumerable<C_MunicipiosRetornosReubicaciones_Result> GetMunicipioRR(byte idTablero, int idUsuario)
        {
            IEnumerable<C_MunicipiosRetornosReubicaciones_Result> resultado = Enumerable.Empty<C_MunicipiosRetornosReubicaciones_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_MunicipiosRetornosReubicaciones(idUsuario: idUsuario, idTablero: idTablero).Cast<C_MunicipiosRetornosReubicaciones_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// carga los datos del consolidado cuando se selecciona el derecho
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="numMostrar">The number mostrar.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="Usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarTableroSeguimientoConsolidado/{sortOrder},{page},{numMostrar},{idDerecho},{Usuario},{idTablero}")]
        public object CargarTableroSeguimientoConsolidado(string sortOrder, Int16 page = 1, Int16 numMostrar = 10, int idDerecho = 0, string Usuario = "", byte idTablero = 0)
        {
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            GestionMunicipalController clsuMunicipios = new GestionMunicipalController();
            SeguimientoMunicipalController clsSegMunicipios = new SeguimientoMunicipalController();

            var modelUsuario = new UsuariosModels { UserName = Usuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
            int IdUsuario = datosUsuario.FirstOrDefault().Id;

            //Tablero Consolidado
            var datos = GetTableroSeguimientoConsolidadDepartamento(idTablero, IdUsuario, idDerecho);

            //Lista Municipios con RC
            var datosMunicipioRC = GetMunicipioRC(idTablero, IdUsuario);

            //Lista Municipios con RR
            var datosMunicipioRR = GetMunicipioRR(idTablero, IdUsuario);

            var objeto = new
            {
                datos = datos,
                datosUsuario = datosUsuario,
                datosMunicipioRC = datosMunicipioRC,
                datosMunicipioRR = datosMunicipioRR,
            };

            return objeto;
        }

        private int ObtenerIdUsuario(string usuario)
        {
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            var modelUsuario = new UsuariosModels { UserName = usuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
            return datosUsuario.FirstOrDefault().Id;
        }

        [HttpGet]
        [Route("api/TableroPat/Departamentos/DatosExcelSeguimientoDepartamental/")]
        public HttpResponseMessage DatosExcelSeguimientoDepartamental(int idDepartamento, string usuario, byte idTablero)
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);
            int IdUsuario = ObtenerIdUsuario(usuario);

            IEnumerable<C_DatosExcelSeguimientoGobernaciones_Result> data;
            IEnumerable<C_DatosExcelSeguimientoGobernacionAlcaldias_Result> data2;
            IEnumerable<C_DatosExcelSeguimientoGobernacionAlcaldiasRC_Result> data3;
            IEnumerable<C_DatosExcelSeguimientoGobernacionAlcaldiasRR_Result> data4;
            IEnumerable<C_TableroSeguimientoDepartamentoOtrosDerechos_Result> data5;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 3600;
                    data = BD.C_DatosExcelSeguimientoGobernaciones(IdUsuario, idTablero).ToList();
                    data2 = BD.C_DatosExcelSeguimientoGobernacionAlcaldias(idUsuario: IdUsuario, idTablero: idTablero).ToList();
                    data3 = BD.C_DatosExcelSeguimientoGobernacionAlcaldiasRC(idDepartamento: idDepartamento, idTablero: idTablero).ToList();
                    data4 = BD.C_DatosExcelSeguimientoGobernacionAlcaldiasRR(idDepartamento: idDepartamento, idTablero: idTablero).ToList();
                    data5 = BD.C_TableroSeguimientoDepartamentoOtrosDerechos(idTablero: idTablero, idUsuario: IdUsuario).ToList();
                }

                // Create the workbook
                var workbook = new XLWorkbook();
                var ws = workbook.Worksheets.Add("Información Departamento");

                #region Encabezado columnas Hoja 1

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

                ws.Cell(1, 5).Value = "Pregunta Compromiso";
                ws.Column(5).AdjustToContents();
                ws.Range(1, 5, 2, 5).Merge();
                ws.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 6).Value = "Necesidad";
                ws.Column(6).AdjustToContents();
                ws.Range(1, 6, 1, 8).Merge();
                ws.Cell(1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 6).Value = "Unidad";
                ws.Column(6).AdjustToContents();
                ws.Cell(2, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 7).Value = "Respuesta";
                ws.Column(7).AdjustToContents();
                ws.Cell(2, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 8).Value = "Observación";
                ws.Column(8).AdjustToContents();
                ws.Cell(2, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 9).Value = "Compromiso";
                ws.Column(9).AdjustToContents();
                ws.Range(1, 9, 1, 12).Merge();
                ws.Cell(1, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 9).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 9).Value = "Unidad";
                ws.Column(9).AdjustToContents();
                ws.Cell(2, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 9).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 10).Value = "Respuesta";
                ws.Column(10).AdjustToContents();
                ws.Cell(2, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 10).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 11).Value = "Observación";
                ws.Column(11).AdjustToContents();
                ws.Cell(2, 11).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 11).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 12).Value = "Presupuesto";
                ws.Column(12).AdjustToContents();
                ws.Cell(2, 12).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 12).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 13).Value = "Acciones";
                ws.Column(13).AdjustToContents();
                ws.Range(1, 13, 2, 13).Merge();
                ws.Cell(1, 13).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 13).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 14).Value = "Programas";
                ws.Column(14).AdjustToContents();
                ws.Range(1, 14, 2, 14).Merge();
                ws.Cell(1, 14).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 14).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 15).Value = "Seguimiento Gobernación";
                ws.Column(15).AdjustToContents();
                ws.Range(1, 15, 1, 24).Merge();
                ws.Cell(1, 15).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 15).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;


                ws.Cell(2, 15).Value = "Compromiso 1º semestren";
                ws.Column(15).AdjustToContents();
                ws.Cell(2, 15).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 15).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 16).Value = "Compromiso 2º semestre";
                ws.Column(16).AdjustToContents();
                ws.Cell(2, 16).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 16).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 17).Value = "Avance Cantidad Gobernación";
                ws.Column(17).AdjustToContents();
                ws.Cell(2, 17).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 17).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 18).Value = "Presupuesto 1º semestre";
                ws.Column(18).AdjustToContents();
                ws.Cell(2, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 18).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 19).Value = "Presupuesto 2º semestre";
                ws.Column(19).AdjustToContents();
                ws.Cell(2, 19).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 19).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 20).Value = "Avance Presupuesto Gobernación";
                ws.Column(20).AdjustToContents();
                ws.Cell(2, 20).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 20).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 21).Value = "Observaciones Gob. 1º";
                ws.Column(21).AdjustToContents();
                ws.Cell(2, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 21).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 22).Value = "Observaciones Gob. 2º";
                ws.Column(22).AdjustToContents();
                ws.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 22).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 23).Value = "Programas Gob. 1º";
                ws.Column(23).AdjustToContents();
                ws.Cell(2, 23).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 23).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 24).Value = "Programas Gob. 2º";
                ws.Column(24).AdjustToContents();
                ws.Cell(2, 24).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 24).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 25).Value = "Planeación Definitivo";
                ws.Column(3).AdjustToContents();
                ws.Range(1, 25, 1, 27).Merge();
                ws.Cell(1, 25).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 25).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 25).Value = "Compromiso Definitivo";
                ws.Column(25).AdjustToContents();
                ws.Cell(2, 25).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 25).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;               

                ws.Cell(2, 26).Value = "Presupuesto Definitivo";
                ws.Column(26).AdjustToContents();
                ws.Cell(2, 26).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 26).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 27).Value = "Observación Ajuste";
                ws.Column(27).AdjustToContents();
                ws.Cell(2, 27).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 27).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;


                ws.Range(1, 1, 1, 27).Style.Font.Bold = true;
                ws.Range(2, 1, 2, 27).Style.Font.Bold = true;

                #endregion

                #region Data Excel Hoja 1

                int fila = 3;
                //int columna = 1;

                foreach (var item in data)
                {
                    ws.Cell(fila, 1).Value = item.Derecho;
                    ws.Cell(fila, 2).Value = item.Componente;
                    ws.Cell(fila, 3).Value = item.Medida;
                    ws.Cell(fila, 4).Value = item.Pregunta;
                    ws.Cell(fila, 5).Value = item.PreguntaCompromiso;
                    ws.Cell(fila, 6).Value = item.UnidadNecesidad;
                    ws.Cell(fila, 7).Value = item.RespuestaNecesidad;
                    ws.Cell(fila, 8).Value = item.ObservacionNecesidad;
                    ws.Cell(fila, 9).Value = item.UnidadNecesidad;
                    ws.Cell(fila, 10).Value = item.RespuestaCompromiso;
                    ws.Cell(fila, 11).Value = item.ObservacionCompromiso;

                    ws.Cell(fila, 12).Value = item.RespuestaPresupuesto;
                    ws.Cell(fila, 12).Style.NumberFormat.Format = "$ #,##0";
                    //ws.Cell(fila, 12).DataType = XLCellValues.Number;

                    ws.Cell(fila, 13).Value = item.Accion;
                    ws.Cell(fila, 14).Value = item.Programa;

                    ws.Cell(fila, 15).Value = item.CantidadPrimerSeguimientoGobernacion;
                    ws.Cell(fila, 16).Value = item.CantidadSegundoSeguimientoGobernacion;
                    ws.Cell(fila, 17).Value = item.AvanceCantidadGobernacion;

                    ws.Cell(fila, 18).Value = item.PresupuestoPrimerSeguimientoGobernacion;
                    ws.Cell(fila, 18).Style.NumberFormat.Format = "$ #,##0";
                    ws.Cell(fila, 19).Value = item.PresupuestoSegundoSeguimientoGobernacion;
                    ws.Cell(fila, 19).Style.NumberFormat.Format = "$ #,##0";
                    ws.Cell(fila, 20).Value = item.AvancePresupuestoGobernacion;
                    ws.Cell(fila, 20).Style.NumberFormat.Format = "$ #,##0";
                    ws.Cell(fila, 21).Value = item.ObservacionesSeguimientoGobernacion;
                    ws.Cell(fila, 22).Value = item.ObservacionesSegundoSeguimientoGobernacion;
                    ws.Cell(fila, 23).Value = item.ProgramasPrimeroSeguimientoGobernacion;
                    ws.Cell(fila, 24).Value = item.ProgramasSegundoSeguimientoGobernacion;
                    ws.Cell(fila, 25).Value = item.CompromisoDefinitivo;
                    ws.Cell(fila, 26).Value = item.PresupuestoDefinitivo;
                    ws.Cell(fila, 26).Style.NumberFormat.Format = "$ #,##0";
                    ws.Cell(fila, 27).Value = item.ObservacionesDefinitivo;
                    fila++;
                }

                ws.Range(1, 1, fila, 27).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws.Range(1, 1, fila, 27).Style.Border.OutsideBorderColor = XLColor.Black;

                ws.Range(1, 1, fila, 27).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws.Range(1, 1, fila, 27).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion


                //Hoja 2

                var ws2 = workbook.Worksheets.Add("Información Municipios");

                #region Encabezado columnas Hoja 2

                ws2.Cell(1, 1).Value = "Departamento";
                ws2.Column(1).AdjustToContents();
                ws2.Range(1, 1, 2, 1).Merge();
                ws2.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 2).Value = "Municipio";
                ws2.Column(2).AdjustToContents();
                ws2.Range(1, 2, 2, 2).Merge();
                ws2.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 3).Value = "Derecho";
                ws2.Column(3).AdjustToContents();
                ws2.Range(1, 3, 2, 3).Merge();
                ws2.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 4).Value = "Componente";
                ws2.Column(4).AdjustToContents();
                ws2.Range(1, 4, 2, 4).Merge();
                ws2.Cell(1, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 5).Value = "Medida";
                ws2.Column(5).AdjustToContents();
                ws2.Range(1, 5, 2, 5).Merge();
                ws2.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 6).Value = "Pregunta";
                ws2.Column(6).AdjustToContents();
                ws2.Range(1, 6, 2, 6).Merge();
                ws2.Cell(1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 7).Value = "Pregunta Compromiso";
                ws2.Column(7).AdjustToContents();
                ws2.Range(1, 7, 2, 7).Merge();
                ws2.Cell(1, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 8).Value = "Necesidad";
                ws2.Column(8).AdjustToContents();
                ws2.Range(1, 8, 1, 10).Merge();
                ws2.Cell(1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 8).Value = "Unidad";
                ws2.Column(8).AdjustToContents();
                ws2.Cell(2, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 9).Value = "Respuesta";
                ws2.Column(9).AdjustToContents();
                ws2.Cell(2, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 9).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 10).Value = "Observación";
                ws2.Column(10).AdjustToContents();
                ws2.Cell(2, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 10).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 11).Value = "Compromiso";
                ws2.Column(11).AdjustToContents();
                ws2.Range(1, 11, 1, 14).Merge();
                ws2.Cell(1, 11).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 11).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 11).Value = "Unidad";
                ws2.Column(11).AdjustToContents();
                ws2.Cell(2, 11).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 11).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 12).Value = "Respuesta";
                ws2.Column(12).AdjustToContents();
                ws2.Cell(2, 12).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 12).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 13).Value = "Observación";
                ws2.Column(13).AdjustToContents();
                ws2.Cell(2, 13).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 13).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 14).Value = "Presupuesto";
                ws2.Column(14).AdjustToContents();
                ws2.Cell(2, 14).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 14).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 15).Value = "Acciones";
                ws2.Column(15).AdjustToContents();
                ws2.Range(1, 15, 2, 15).Merge();
                ws2.Cell(1, 15).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 15).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 16).Value = "Programas";
                ws2.Column(16).AdjustToContents();
                ws2.Range(1, 16, 2, 16).Merge();
                ws2.Cell(1, 16).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 16).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 17).Value = "Respuesta Departamento";
                ws2.Column(17).AdjustToContents();
                ws2.Range(1, 17, 1, 21).Merge();
                ws2.Cell(1, 17).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 17).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 17).Value = "Compromiso";
                ws2.Column(17).AdjustToContents();
                ws2.Range(2, 17, 2, 17).Merge();
                ws2.Cell(2, 17).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 17).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 18).Value = "Presupuesto";
                ws2.Column(18).AdjustToContents();
                ws2.Range(2, 18, 2, 18).Merge();
                ws2.Cell(2, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 18).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 19).Value = "Observacion";
                ws2.Column(19).AdjustToContents();
                ws2.Range(2, 19, 2, 19).Merge();
                ws2.Cell(2, 19).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 19).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 20).Value = "Acción";
                ws2.Column(20).AdjustToContents();
                ws2.Range(2, 20, 2, 20).Merge();
                ws2.Cell(2, 20).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 20).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 21).Value = "Programa";
                ws2.Column(21).AdjustToContents();
                ws2.Range(2, 21, 2, 21).Merge();
                ws2.Cell(2, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 21).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                //seguimiento alcaldias 
                ws2.Cell(1, 22).Value = "Seguimiento Alcaldía";
                ws2.Column(22).AdjustToContents();
                ws2.Range(1, 22, 1, 31).Merge();
                ws2.Cell(1, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 22).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 22).Value = "Compromiso 1º semestre";
                ws2.Column(22).AdjustToContents();
                ws2.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 22).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 23).Value = "Compromiso 2º semestre";
                ws2.Column(23).AdjustToContents();
                ws2.Cell(2, 23).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 23).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 24).Value = "Avance Cantidad";
                ws2.Column(24).AdjustToContents();
                ws2.Cell(2, 24).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 24).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;


                ws2.Cell(2, 25).Value = "Presupuesto 1º semestre";
                ws2.Column(25).AdjustToContents();
                ws2.Cell(2, 25).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 25).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 26).Value = "Presupuesto 2º semestre";
                ws2.Column(26).AdjustToContents();
                ws2.Cell(2, 26).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 26).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 27).Value = "Avance Presupuesto";
                ws2.Column(27).AdjustToContents();
                ws2.Cell(2, 27).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 27).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 28).Value = "Observaciones Alcaldía 1º";
                ws2.Column(28).AdjustToContents();
                ws2.Cell(2, 28).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 28).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 29).Value = "Observaciones Alcaldía 2º";
                ws2.Column(29).AdjustToContents();
                ws2.Cell(2, 29).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 29).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 30).Value = "Programas Alcaldía 1º";
                ws2.Column(30).AdjustToContents();
                ws2.Cell(2, 30).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 30).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 31).Value = "Programas Alcaldía 2º";
                ws2.Column(31).AdjustToContents();
                ws2.Cell(2, 31).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 31).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                //seguimiento gobernacion
                ws2.Cell(1, 32).Value = "Seguimiento Gobernación";
                ws2.Column(32).AdjustToContents();
                ws2.Range(1, 32, 1, 41).Merge();
                ws2.Cell(1, 32).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 32).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 32).Value = "Compromiso 1º semestre";
                ws2.Column(32).AdjustToContents();
                ws2.Cell(2, 32).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 32).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 33).Value = "Compromiso 2º semestre";
                ws2.Column(33).AdjustToContents();
                ws2.Cell(2, 33).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 33).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 34).Value = "Avance Cantidad";
                ws2.Column(34).AdjustToContents();
                ws2.Cell(2, 34).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 34).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 35).Value = "Presupuesto 1º semestre";
                ws2.Column(35).AdjustToContents();
                ws2.Cell(2, 35).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 35).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 36).Value = "Presupuesto 2º semestre";
                ws2.Column(36).AdjustToContents();
                ws2.Cell(2, 36).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 36).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 37).Value = "Avance Presupuesto";
                ws2.Column(37).AdjustToContents();
                ws2.Cell(2, 37).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 37).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 38).Value = "Observaciones Gob. 1º";
                ws2.Column(38).AdjustToContents();
                ws2.Cell(2, 38).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 38).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 39).Value = "Observaciones Gob. 2º";
                ws2.Column(39).AdjustToContents();
                ws2.Cell(2, 39).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 39).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 40).Value = "Programas Gob. 1º";
                ws2.Column(40).AdjustToContents();
                ws2.Cell(2, 40).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 40).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 41).Value = "Programas Gob. 2º";
                ws2.Column(41).AdjustToContents();
                ws2.Cell(2, 41).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 41).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 42).Value = "Planeación Definitivo";
                ws2.Column(3).AdjustToContents();
                ws2.Range(1, 42, 1, 47).Merge();
                ws2.Cell(1, 42).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 42).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 42).Value = "Compromiso Definitivo Mun";
                ws2.Column(42).AdjustToContents();
                ws2.Cell(2, 42).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 42).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 43).Value = "Presupuesto Definitivo Mun";
                ws2.Column(43).AdjustToContents();
                ws2.Cell(2, 43).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 43).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 44).Value = "Observación Ajuste Mun";
                ws2.Column(44).AdjustToContents();
                ws2.Cell(2, 44).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 44).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 45).Value = "Compromiso Definitivo Gob";
                ws2.Column(45).AdjustToContents();
                ws2.Cell(2, 45).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 45).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 46).Value = "Presupuesto Definitivo Gob";
                ws2.Column(46).AdjustToContents();
                ws2.Cell(2, 46).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 46).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;


                ws2.Cell(2, 47).Value = "Observación Ajuste Gob";
                ws2.Column(47).AdjustToContents();
                ws2.Cell(2, 47).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 47).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;


                ws2.Range(1, 1, 1, 47).Style.Font.Bold = true;
                ws2.Range(2, 1, 2, 47).Style.Font.Bold = true;

                #endregion

                #region Data Excel Hoja 2

                int fila2 = 3;
                //int columna2 = 1;

                foreach (var item in data2)
                {
                    ws2.Cell(fila2, 1).Value = item.Departamento;
                    ws2.Cell(fila2, 2).Value = item.Municipio;
                    ws2.Cell(fila2, 3).Value = item.Derecho;
                    ws2.Cell(fila2, 4).Value = item.Componente;
                    ws2.Cell(fila2, 5).Value = item.Medida;
                    ws2.Cell(fila2, 6).Value = item.Pregunta;
                    ws2.Cell(fila2, 7).Value = item.PreguntaCompromiso;
                    ws2.Cell(fila2, 8).Value = item.UnidadNecesidad;
                    ws2.Cell(fila2, 9).Value = item.RespuestaNecesidad;
                    ws2.Cell(fila2, 10).Value = item.ObservacionNecesidad;
                    ws2.Cell(fila2, 11).Value = item.UnidadNecesidad;
                    ws2.Cell(fila2, 12).Value = item.RespuestaCompromiso;
                    ws2.Cell(fila2, 13).Value = item.ObservacionCompromiso;

                    ws2.Cell(fila2, 14).Value = item.RespuestaPresupuesto;
                    ws2.Cell(fila2, 14).Style.NumberFormat.Format = "$ #,##0";
                    //ws2.Cell(fila2, 14).DataType = XLCellValues.Number;

                    ws2.Cell(fila2, 15).Value = item.Accion;
                    ws2.Cell(fila2, 16).Value = item.Programa;

                    ws2.Cell(fila2, 17).Value = item.RespuestaCompromisoDepartamento;

                    ws2.Cell(fila2, 18).Value = item.PresupuestoDepartamento;
                    ws2.Cell(fila2, 18).Style.NumberFormat.Format = "$ #,##0";

                    ws2.Cell(fila2, 19).Value = item.ObservacionDepartamento;
                    ws2.Cell(fila2, 20).Value = item.AccionDepartamento;
                    ws2.Cell(fila2, 21).Value = item.ProgramaDepartamento;

                    ws2.Cell(fila2, 22).Value = item.CantidadPrimerSeguimientoAlcaldia;
                    ws2.Cell(fila2, 23).Value = item.CantidadSegundoSeguimientoAlcaldia;
                    ws2.Cell(fila2, 24).Value = item.AvanceCantidadAlcaldia;
                    ws2.Cell(fila2, 25).Value = item.PresupuestoPrimerSeguimientoAlcaldia;
                    ws2.Cell(fila2, 25).Style.NumberFormat.Format = "$ #,##0";
                    ws2.Cell(fila2, 26).Value = item.PresupuestoSegundoSeguimientoAlcaldia;
                    ws2.Cell(fila2, 26).Style.NumberFormat.Format = "$ #,##0";
                    ws2.Cell(fila2, 27).Value = item.AvancePresupuestoAlcaldia;
                    ws2.Cell(fila2, 27).Style.NumberFormat.Format = "$ #,##0";

                    ws2.Cell(fila2, 28).Value = item.ObservacionesSeguimientoAlcaldia;
                    ws2.Cell(fila2, 29).Value = item.ObservacionesSegundoSeguimientoAlcaldia;
                    ws2.Cell(fila2, 30).Value = item.ProgramasPrimero;
                    ws2.Cell(fila2, 31).Value = item.ProgramasSegundo;

                    ws2.Cell(fila2, 32).Value = item.CantidadPrimerSeguimientoGobernacion;
                    ws2.Cell(fila2, 33).Value = item.CantidadSegundoSeguimientoGobernacion;
                    ws2.Cell(fila2, 34).Value = item.AvanceCantidadGobernacion;
                    ws2.Cell(fila2, 35).Value = item.PresupuestoPrimerSeguimientoGobernacion;
                    ws2.Cell(fila2, 35).Style.NumberFormat.Format = "$ #,##0";
                    ws2.Cell(fila2, 36).Value = item.PresupuestoSegundoSeguimientoGobernacion;
                    ws2.Cell(fila2, 36).Style.NumberFormat.Format = "$ #,##0";
                    ws2.Cell(fila2, 37).Value = item.AvancePresupuestoGobernacion;
                    ws2.Cell(fila2, 37).Style.NumberFormat.Format = "$ #,##0";
                    ws2.Cell(fila2, 38).Value = item.ObservacionesSeguimientoGobernacion;
                    ws2.Cell(fila2, 39).Value = item.ObservacionesSegundoSeguimientoGobernacion;
                    ws2.Cell(fila2, 40).Value = item.ProgramasPrimeroSeguimientoGobernacion;
                    ws2.Cell(fila2, 41).Value = item.ProgramasSegundoSeguimientoGobernacion;

                    ws2.Cell(fila2, 42).Value = item.CompromisoDefinitivo;
                    ws2.Cell(fila2, 43).Value = item.PresupuestoDefinitivo;
                    ws2.Cell(fila2, 43).Style.NumberFormat.Format = "$ #,##0";
                    ws2.Cell(fila2, 44).Value = item.ObservacionesDefinitivo;
                    ws2.Cell(fila2, 45).Value = item.CompromisoDefinitivoGobernacion;
                    ws2.Cell(fila2, 46).Value = item.PresupuestoDefinitivoGobernacion;
                    ws2.Cell(fila2, 46).Style.NumberFormat.Format = "$ #,##0";
                    ws2.Cell(fila2, 47).Value = item.ObservacionesDefinitivoGobernacion;

                    fila2++;
                }

                //ws2.Range(1, 1, fila2, 41).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                //ws2.Range(1, 1, fila2, 41).Style.Border.OutsideBorderColor = XLColor.Black;

                //ws2.Range(1, 1, fila2, 41).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                //ws2.Range(1, 1, fila2, 41).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion


                //Hoja 3

                var ws3 = workbook.Worksheets.Add("Reparaciones Colectivas");

                #region Encabezado columnas Hoja 3

                ws3.Cell(1, 1).Value = "Municipio";
                ws3.Column(1).AdjustToContents();
                ws3.Range(1, 1, 2, 1).Merge();
                ws3.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 2).Value = "Sujeto";
                ws3.Column(2).AdjustToContents();
                ws3.Range(1, 2, 2, 2).Merge();
                ws3.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 3).Value = "Tipo Medida";
                ws3.Column(3).AdjustToContents();
                ws3.Range(1, 3, 2, 3).Merge();
                ws3.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 4).Value = "Medida";
                ws3.Column(4).AdjustToContents();
                ws3.Range(1, 4, 2, 4).Merge();
                ws3.Cell(1, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 5).Value = "Acción Municipio";
                ws3.Column(5).AdjustToContents();
                ws3.Range(1, 5, 2, 5).Merge();
                ws3.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 6).Value = "Presupuesto Municipio";
                ws3.Column(6).AdjustToContents();
                ws3.Range(1, 6, 2, 6).Merge();
                ws3.Cell(1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 7).Value = "Acción Departamento";
                ws3.Column(7).AdjustToContents();
                ws3.Range(1, 7, 2, 7).Merge();
                ws3.Cell(1, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 8).Value = "Presupuesto Departamento";
                ws3.Column(8).AdjustToContents();
                ws3.Range(1, 8, 2, 8).Merge();
                ws3.Cell(1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 9).Value = "Seguimiento Alcaldía";
                ws3.Column(9).AdjustToContents();
                ws3.Range(1, 9, 1, 10).Merge();
                ws3.Cell(1, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 9).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(2, 9).Value = "Avance Primer Semestre Alcaldía";
                ws3.Column(9).AdjustToContents();
                ws3.Cell(2, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(2, 9).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(2, 10).Value = "Avance Segundo Semestre Alcaldía";
                ws3.Column(10).AdjustToContents();
                ws3.Cell(2, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(2, 10).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 11).Value = "Seguimiento Gobernación";
                ws3.Column(11).AdjustToContents();
                ws3.Range(1, 11, 1, 12).Merge();
                ws3.Cell(1, 11).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 11).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(2, 11).Value = "Avance Primer Semestre Gobernación";
                ws3.Column(11).AdjustToContents();
                ws3.Cell(2, 11).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(2, 11).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(2, 12).Value = "Avance Segundo Semestre Gobernación";
                ws3.Column(12).AdjustToContents();
                ws3.Cell(2, 12).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(2, 12).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Range(1, 1, 1, 12).Style.Font.Bold = true;
                ws3.Range(2, 1, 2, 12).Style.Font.Bold = true;

                #endregion

                #region Data Excel Hoja 3

                int fila3 = 3;
                //int columna3 = 1;

                foreach (var item in data3)
                {
                    ws3.Cell(fila3, 1).Value = item.Municipio;
                    ws3.Cell(fila3, 2).Value = item.Sujeto;
                    ws3.Cell(fila3, 3).Value = item.Medida;
                    ws3.Cell(fila3, 4).Value = item.MedidaReparacionColectiva;
                    ws3.Cell(fila3, 5).Value = item.Accion;

                    ws3.Cell(fila3, 6).Value = item.Presupuesto;
                    ws3.Cell(fila3, 6).Style.NumberFormat.Format = "$ #,##0";
                    //ws3.Cell(fila3, 6).DataType = XLCellValues.Number;

                    ws3.Cell(fila3, 7).Value = item.AccionDepartamento;

                    ws3.Cell(fila3, 8).Value = item.PresupuestoDepartamento;
                    ws3.Cell(fila3, 8).Style.NumberFormat.Format = "$ #,##0";
                    //ws3.Cell(fila3, 8).DataType = XLCellValues.Number;

                    ws3.Cell(fila3, 9).Value = item.AvancePrimerSemestreAlcaldia;
                    ws3.Cell(fila3, 10).Value = item.AvanceSegundoSemestreAlcaldia;
                    ws3.Cell(fila3, 11).Value = item.AvancePrimerSemestreGobernacion;
                    ws3.Cell(fila3, 12).Value = item.AvanceSegundoSemestreGobernacion;

                    fila3++;
                }

                ws3.Range(1, 1, fila3, 12).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws3.Range(1, 1, fila3, 12).Style.Border.OutsideBorderColor = XLColor.Black;

                ws3.Range(1, 1, fila3, 12).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws3.Range(1, 1, fila3, 12).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion


                //Hoja 4

                var ws4 = workbook.Worksheets.Add("Retornos y Reubicaciones");

                #region Encabezado columnas Hoja 4

                ws4.Cell(1, 1).Value = "Municipio";
                ws4.Column(1).AdjustToContents();
                ws4.Range(1, 1, 2, 1).Merge();
                ws4.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 2).Value = "Comunidad";
                ws4.Column(2).AdjustToContents();
                ws4.Range(1, 2, 2, 2).Merge();
                ws4.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 3).Value = "Ubicación";
                ws4.Column(3).AdjustToContents();
                ws4.Range(1, 3, 2, 3).Merge();
                ws4.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 4).Value = "Personas";
                ws4.Column(4).AdjustToContents();
                ws4.Range(1, 4, 2, 4).Merge();
                ws4.Cell(1, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 5).Value = "Hogares";
                ws4.Column(5).AdjustToContents();
                ws4.Range(1, 5, 2, 5).Merge();
                ws4.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 6).Value = "Medida";
                ws4.Column(6).AdjustToContents();
                ws4.Range(1, 6, 2, 6).Merge();
                ws4.Cell(1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 7).Value = "Indicador";
                ws4.Column(7).AdjustToContents();
                ws4.Range(1, 7, 2, 7).Merge();
                ws4.Cell(1, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 8).Value = "Sector";
                ws4.Column(8).AdjustToContents();
                ws4.Range(1, 8, 2, 8).Merge();
                ws4.Cell(1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 9).Value = "Componente";
                ws4.Column(9).AdjustToContents();
                ws4.Range(1, 9, 2, 9).Merge();
                ws4.Cell(1, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 9).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 10).Value = "Entidad Responsable";
                ws4.Column(10).AdjustToContents();
                ws4.Range(1, 10, 2, 10).Merge();
                ws4.Cell(1, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 10).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 11).Value = "Acción";
                ws4.Column(11).AdjustToContents();
                ws4.Range(1, 11, 2, 11).Merge();
                ws4.Cell(1, 11).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 11).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 12).Value = "Presupuesto";
                ws4.Column(12).AdjustToContents();
                ws4.Range(1, 12, 2, 12).Merge();
                ws4.Cell(1, 12).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 12).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 13).Value = "Acción Departamento";
                ws4.Column(13).AdjustToContents();
                ws4.Range(1, 13, 2, 13).Merge();
                ws4.Cell(1, 13).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 13).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 14).Value = "Presupuesto Departamento";
                ws4.Column(14).AdjustToContents();
                ws4.Range(1, 14, 2, 14).Merge();
                ws4.Cell(1, 14).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 14).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 15).Value = "Seguimiento Alcaldía";
                ws4.Column(15).AdjustToContents();
                ws4.Range(1, 15, 1, 16).Merge();
                ws4.Cell(1, 15).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 15).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(2, 15).Value = "Avance Primer Semestre Alcaldía";
                ws4.Column(15).AdjustToContents();
                ws4.Cell(2, 15).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(2, 15).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(2, 16).Value = "Avance Segundo Semestre Alcaldía";
                ws4.Column(16).AdjustToContents();
                ws4.Cell(2, 16).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(2, 16).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 17).Value = "Seguimiento Gobernación";
                ws4.Column(17).AdjustToContents();
                ws4.Range(1, 17, 1, 18).Merge();
                ws4.Cell(1, 17).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 17).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(2, 17).Value = "Avance Primer Semestre Gobernación";
                ws4.Column(17).AdjustToContents();
                ws4.Cell(2, 17).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(2, 17).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(2, 18).Value = "Avance Segundo Semestre Gobernación";
                ws4.Column(18).AdjustToContents();
                ws4.Cell(2, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(2, 18).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Range(1, 1, 1, 18).Style.Font.Bold = true;
                ws4.Range(2, 1, 2, 18).Style.Font.Bold = true;

                #endregion

                #region Data Excel Hoja 4

                int fila4 = 3;
                //int columna4 = 1;

                foreach (var item in data4)
                {
                    ws4.Cell(fila4, 1).Value = item.Municipio;
                    ws4.Cell(fila4, 2).Value = item.Comunidad;
                    ws4.Cell(fila4, 3).Value = item.Ubicacion;
                    ws4.Cell(fila4, 4).Value = item.Personas;
                    ws4.Cell(fila4, 5).Value = item.Hogares;
                    ws4.Cell(fila4, 6).Value = item.MedidaRetornoReubicacion;
                    ws4.Cell(fila4, 7).Value = item.IndicadorRetornoReubicacion;
                    ws4.Cell(fila4, 8).Value = item.Sector;
                    ws4.Cell(fila4, 9).Value = item.Componente;
                    ws4.Cell(fila4, 10).Value = item.EntidadResponsable;
                    ws4.Cell(fila4, 11).Value = item.Accion;

                    ws4.Cell(fila4, 12).Value = item.Presupuesto;
                    ws4.Cell(fila4, 12).Style.NumberFormat.Format = "$ #,##0";

                    ws4.Cell(fila4, 13).Value = item.AccionDepartamento;

                    ws4.Cell(fila4, 14).Value = item.PresupuestoDepartamento;
                    ws4.Cell(fila4, 14).Style.NumberFormat.Format = "$ #,##0";

                    //ws4.Cell(fila4, 12).DataType = XLCellValues.Number;

                    ws4.Cell(fila4, 15).Value = item.AvancePrimerSemestreAlcaldia;
                    ws4.Cell(fila4, 16).Value = item.AvanceSegundoSemestreAlcaldia;
                    ws4.Cell(fila4, 17).Value = item.AvancePrimerSemestreGobernacion;
                    ws4.Cell(fila4, 18).Value = item.AvanceSegundoSemestreGobernacion;

                    fila4++;
                }

                ws4.Range(1, 1, fila4, 18).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws4.Range(1, 1, fila4, 18).Style.Border.OutsideBorderColor = XLColor.Black;

                ws4.Range(1, 1, fila4, 18).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws4.Range(1, 1, fila4, 18).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion


                //Hoja 5 - Otros derechos
                var ws5 = workbook.Worksheets.Add("Información Otros Derechos");

                #region Encabezado Columnas Hoja 5

                ws5.Cell(1, 1).Value = "Derecho";
                ws5.Column(1).AdjustToContents();
                ws5.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws5.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws5.Cell(1, 2).Value = "Componente";
                ws5.Column(2).AdjustToContents();
                ws5.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws5.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws5.Cell(1, 3).Value = "Medida";
                ws5.Column(3).AdjustToContents();
                ws5.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws5.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws5.Cell(1, 4).Value = "Cantidad";
                ws5.Column(4).AdjustToContents();
                ws5.Cell(1, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws5.Cell(1, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws5.Cell(1, 5).Value = "Programa";
                ws5.Column(5).AdjustToContents();
                ws5.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws5.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws5.Cell(1, 6).Value = "Acción";
                ws5.Column(6).AdjustToContents();
                ws5.Cell(1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws5.Cell(1, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws5.Cell(1, 7).Value = "Unidad";
                ws5.Column(7).AdjustToContents();
                ws5.Cell(1, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws5.Cell(1, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws5.Cell(1, 8).Value = "Valor";
                ws5.Column(8).AdjustToContents();
                ws5.Cell(1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws5.Cell(1, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws5.Cell(1, 9).Value = "Observaciones";
                ws5.Column(9).AdjustToContents();
                ws5.Cell(1, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws5.Cell(1, 9).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                #endregion

                #region data hoja 5

                int fila5 = 2;
                //int columna5 = 1;

                foreach (var item in data5)
                {
                    ws5.Cell(fila5, 1).Value = item.Derecho;
                    ws5.Cell(fila5, 2).Value = item.Componente;
                    ws5.Cell(fila5, 3).Value = item.Medida;
                    ws5.Cell(fila5, 4).Value = item.Cantidad;
                    ws5.Cell(fila5, 5).Value = item.Programa;
                    ws5.Cell(fila5, 6).Value = item.Accion;
                    ws5.Cell(fila5, 7).Value = item.Unidad;

                    ws5.Cell(fila5, 8).Value = item.Presupuesto;
                    ws5.Cell(fila5, 8).Style.NumberFormat.Format = "$ #,##0";

                    ws5.Cell(fila5, 9).Value = item.Observaciones;

                    fila5++;
                }

                ws5.Range(1, 1, fila5, 9).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws5.Range(1, 1, fila5, 9).Style.Border.OutsideBorderColor = XLColor.Black;

                ws5.Range(1, 1, fila5, 9).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws5.Range(1, 1, fila5, 9).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion

                var finalfilename = Path.Combine(@"c:\Temp", "Reporte_Tablero_PAT-Departamental.xlsx");
                var filename = "Reporte Seguimiento Tablero PAT-Departamental.xlsx";
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

        #region APIS PARA EL POP UP DE PREGUNTAS DEPARTAMENTO  

        /// <summary>
        /// Gets the tablero seguimiento departamento detalle.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <param name="idtablero">The idtablero.</param>
        /// <returns>C_DatosRespuestaSeguimientoDepartamento_Result.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetTableroSeguimientoDepartamentoDetalle/")]
        public C_DatosRespuestaSeguimientoDepartamento_Result GetTableroSeguimientoDepartamentoDetalle(int idUsuario, short idPregunta, short idtablero)
        {
            C_DatosRespuestaSeguimientoDepartamento_Result resultado = new C_DatosRespuestaSeguimientoDepartamento_Result();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DatosRespuestaSeguimientoDepartamento(idPregunta: idPregunta, idUsuario: idUsuario, idTablero: idtablero).Cast<C_DatosRespuestaSeguimientoDepartamento_Result>().FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        [HttpGet]
        [Route("api/TableroPat/DatosSeguimientoNacionalPorDepartamento/")]
        public C_SeguimientoNacionalPorDepartamento_Result DatosSeguimientoNacionalPorDepartamento(int idPregunta, int idDepartamento)
        {
            C_SeguimientoNacionalPorDepartamento_Result resultado = new C_SeguimientoNacionalPorDepartamento_Result();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_SeguimientoNacionalPorDepartamento(idDepartamento: idDepartamento, idPregunta: idPregunta).Cast<C_SeguimientoNacionalPorDepartamento_Result>().FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Datoses the iniciales seguimiento departamento.
        /// </summary>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <param name="IdUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosInicialesSeguimientoDepartamento/")]
        public object DatosInicialesSeguimientoDepartamento(short idPregunta, int IdUsuario, short idTablero, int idDepartamento, int numSeguimiento)
        {
            var datosRespuesta = GetTableroSeguimientoDepartamentoDetalle(IdUsuario, idPregunta, idTablero);
            var datosSegNacional = DatosSeguimientoNacionalPorDepartamento(idPregunta, idDepartamento);

            if (!datosRespuesta.IdRespuesta.HasValue)
            {
                datosRespuesta.IdTablero = byte.Parse(idTablero.ToString());
            }

            SeguimientoMunicipalController seguimientoMunicipal = new SeguimientoMunicipalController();

            var datosProgramas = GetProgramasSeguimientoDepto(Convert.ToInt32(datosRespuesta.IdRespuesta), datosRespuesta.IdSeguimiento, numSeguimiento, false, 0, 0, 0);
            List<C_ProgramasSeguimientoSIGO_Result> programasSIGO = seguimientoMunicipal.GetProgramasSeguimientoSIGO(idTablero, numSeguimiento, 2, idDepartamento, 0, idPregunta);

            var objeto = new
            {
                datosRespuesta = datosRespuesta,
                datosProgramas = datosProgramas,
                datosSegNacional = datosSegNacional,
                programasSIGO = programasSIGO
            };

            return objeto;
        }

        /// <summary>
        /// Registrars the seguimiento departamento.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/RegistrarSeguimientoDepartamento/")]
        public C_AccionesResultado RegistrarSeguimientoDepartamento(SeguimientoPATGobernacion model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            bool Insertando = false;
            model.NombreAdjunto = model.NombreAdjunto.Replace('ñ', 'n').Replace('Ñ', 'N');
            model.ObservacionesDefinitivo = quitarAcentos(model.ObservacionesDefinitivo);
            model.Observaciones = quitarAcentos(model.Observaciones);
            model.ObservacionesSegundo = quitarAcentos(model.ObservacionesSegundo);

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                using (var dbContextTransaction = BD.Database.BeginTransaction())
                {
                    try
                    {
                        if (model.IdSeguimiento > 0)
                        {
                            resultado = BD.U_SeguimientoGobernacionUpdate(idSeguimiento: model.IdSeguimiento, idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, idUsuarioAlcaldia: model.IdUsuarioAlcaldia, cantidadPrimer: model.CantidadPrimer, presupuestoPrimer: model.PresupuestoPrimer, cantidadSegundo: model.CantidadSegundo, presupuestoSegundo: model.PresupuestoSegundo, observaciones: model.Observaciones, nombreAdjunto: model.NombreAdjunto, observacionesSegundo: model.ObservacionesSegundo, nombreAdjuntoSegundo: model.NombreAdjuntoSegundo, compromisoDefinitivo: model.CompromisoDefinitivo, presupuestoDefinitivo: model.PresupuestoDefinitivo, observacionesDefinitivo: model.ObservacionesDefinitivo).FirstOrDefault();
                            Insertando = false;
                        }
                        else
                        {
                            var datosInsert = BD.I_SeguimientoGobernacionInsert(idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, idUsuarioAlcaldia: model.IdUsuarioAlcaldia, cantidadPrimer: model.CantidadPrimer, presupuestoPrimer: model.PresupuestoPrimer, cantidadSegundo: model.CantidadSegundo, presupuestoSegundo: model.PresupuestoSegundo, observaciones: model.Observaciones, nombreAdjunto: model.NombreAdjunto, observacionesSegundo: model.ObservacionesSegundo, nombreAdjuntoSegundo: model.NombreAdjuntoSegundo, compromisoDefinitivo: model.CompromisoDefinitivo, presupuestoDefinitivo: model.PresupuestoDefinitivo, observacionesDefinitivo: model.ObservacionesDefinitivo).FirstOrDefault();
                            model.IdSeguimiento = datosInsert.id.Value;
                            resultado.estado = datosInsert.estado;
                            resultado.respuesta = datosInsert.respuesta;
                            Insertando = true;
                        }

                        //// se borran los programas
                        if (resultado.estado == 1 || resultado.estado == 2)
                        {
                            resultado = BD.D_SeguimientoDepartamentoProgramaDelete(idSeguimiento: model.IdSeguimiento).FirstOrDefault();
                        }

                        if (resultado.estado == 3)
                        {
                            resultado.estado = 1;
                            if (model.SeguimientoProgramas != null)
                            {
                                if (model.SeguimientoProgramas.Count() > 0)
                                {
                                    foreach (var item in model.SeguimientoProgramas)
                                    {
                                        item.IdSeguimiento = model.IdSeguimiento;
                                        item.PROGRAMA = quitarAcentos(item.PROGRAMA);
                                        var datosInsert = BD.I_SeguimientoDepartamentoProgramaInsert(idSeguimiento: model.IdSeguimiento, programa: item.PROGRAMA, numeroSeguimiento: item.NumeroSeguimiento).FirstOrDefault();
                                        item.Insertado = true;
                                        resultado.estado = datosInsert.estado;
                                        resultado.respuesta = datosInsert.respuesta;

                                        if (resultado.estado == 0)
                                        {
                                            break;
                                        }
                                    }
                                }
                            }
                            if (resultado.estado > 0)
                            {
                                dbContextTransaction.Commit();

                                //// Audita la creación o actualización del seguimiento gobernación PAT
                                (new AuditExecuted(Insertando ? Category.CrearSeguimientoPATGobernacion : Category.EditarSeguimientoPATGobernacion)).ActionExecutedManual(model);

                                //// Audita la eliminación de todos los programas del seguimiento gobernación PAT
                                (new AuditExecuted(Category.ELiminarProgramasSeguimientoPATGobernacion)).ActionExecutedManual(model);

                                //// Audita la creación o la actualización de cdada uno de los programas
                                if (model.SeguimientoProgramas != null)
                                {
                                    if (model.SeguimientoProgramas.Count() > 0)
                                    {
                                        foreach (var item in model.SeguimientoProgramas)
                                        {
                                            item.AudUserName = model.AudUserName;
                                            item.AddIdent = model.AddIdent;
                                            item.UserNameAddIdent = model.UserNameAddIdent;
                                            (new AuditExecuted(item.Insertado ? Category.CrearProgramaSeguimientoPATGobernacion : Category.EditarProgramaSeguimientoPATGobernacion)).ActionExecutedManual(item);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        dbContextTransaction.Rollback();
                        model.Excepcion = true;
                        model.ExcepcionMensaje = ex.Message;

                        //// Audita la creación o actualización de la respuesta PAT
                        (new AuditExecuted(Insertando ? Category.CrearSeguimientoPATGobernacion : Category.EditarSeguimientoPATGobernacion)).ActionExecutedManual(model);
                    }
                }
            }
            return resultado;
        }

        #endregion

        #region APIS PARA EL PRIMER POPUP DE CONSOLIDADO MUNICIPAL DEL SEGUIMIENTO

        /// <summary>
        /// Gets the tablero seguimiento detalle consolidad departamento.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <param name="idtablero">The idtablero.</param>
        /// <returns>IEnumerable&lt;C_TableroSeguimientoDetalleConsolidadoDepartamento_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetTableroSeguimientoDetalleConsolidadDepartamento/")]
        public IEnumerable<C_TableroSeguimientoDetalleConsolidadoDepartamento_Result> GetTableroSeguimientoDetalleConsolidadDepartamento(int idUsuario, short idPregunta, short idtablero)
        {
            IEnumerable<C_TableroSeguimientoDetalleConsolidadoDepartamento_Result> resultado = Enumerable.Empty<C_TableroSeguimientoDetalleConsolidadoDepartamento_Result>();
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroSeguimientoDetalleConsolidadoDepartamento(idPregunta: idPregunta, idUsuario: idUsuario, idTablero: idtablero).Cast<C_TableroSeguimientoDetalleConsolidadoDepartamento_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return resultado;
        }

        //Carga la informacion del popup del consolidado de los municipios
        /// <summary>
        /// Datoses the iniciales consolidado seguimiento depto.
        /// </summary>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <param name="IdUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosInicialesConsolidadoSeguimientoDepto/")]
        public object DatosInicialesConsolidadoSeguimientoDepto(short idPregunta = 0, int IdUsuario = 0, short idTablero = 0)
        {
            var datosRespuesta = GetTableroSeguimientoDetalleConsolidadDepartamento(IdUsuario, idPregunta, idTablero);
            var objeto = new
            {
                datosRespuesta = datosRespuesta,
            };
            return objeto;
        }

        #endregion

        #region APIS PARA EL MODAL DE LA EDICION DEL CONSOLIDADO MUNICIPAL EN EL SEGUIMIENTO

        /// <summary>
        /// Gets the seguimiento gobernacion.
        /// </summary>
        /// <param name="idSeguimiento">The identifier seguimiento.</param>
        /// <returns>C_DatosSeguimientoDepartamentoPorId_Result.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetSeguimientoGobernacion/")]
        public C_DatosSeguimientoDepartamentoPorId_Result GetSeguimientoGobernacion(int idSeguimiento)
        {
            C_DatosSeguimientoDepartamentoPorId_Result resultado = new C_DatosSeguimientoDepartamentoPorId_Result();

            if (idSeguimiento == 0)
            {
                resultado.IdSeguimiento = 0;
                resultado.CantidadPrimer = -1;
                resultado.CantidadSegundo = -1;
                resultado.NombreAdjunto = "";
                resultado.Observaciones = "";
                resultado.PresupuestoPrimer = -1;
                resultado.PresupuestoSegundo = -1;                
            }
            else
            {
                try
                {
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        resultado = BD.C_DatosSeguimientoDepartamentoPorId(idSeguimiento: idSeguimiento).Cast<C_DatosSeguimientoDepartamentoPorId_Result>().FirstOrDefault();
                    }
                }
                catch (Exception ex)
                {
                    (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                }
            }

            return resultado;
        }

        /// <summary>
        /// Gets the programas seguimiento depto.
        /// </summary>
        /// <param name="idRespuesta">The identifier respuesta.</param>
        /// <param name="idSeguimiento">The identifier seguimiento.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetProgramasSeguimientoDepto/")]
        public object GetProgramasSeguimientoDepto(int idRespuesta, int idSeguimiento, int numSeguimiento, bool consolidado, int idRespuestaDpto, short idPregunta, int idUsuario)
        {
            try
            {
                GestionMunicipalController gestionMunicipal = new GestionMunicipalController();
                GestionDepartamentalController gestionDeptal = new GestionDepartamentalController();
                IEnumerable<C_ProgramasPATSeguimiento> programasPat;
                if (idSeguimiento == 0)
                {
                    //Si no tiene seguimiento debe traer:En casi de primer seguimiento los programas de planeacion y si es del segundo seguimiento debe traer los programas del primer seguimiento.
                    if (numSeguimiento == 1)
                    {
                        //Agosto - 30 - 2018: Andrés López solicita que si es seguimiento 1 y no tiene programas ya guardados, traiga los de planeacion depto no municipio
                        if (consolidado)
                        {
                            using (EntitiesRusicst BD = new EntitiesRusicst())
                            {
                                if (idRespuestaDpto == 0)
                                {
                                    IEnumerable<C_ProgramasDepartamentoPAT_IDS_Result> programasSeguimiento = BD.C_ProgramasDepartamentoPAT_IDS(idPregunta, idUsuario).Cast<C_ProgramasDepartamentoPAT_IDS_Result>().ToList();
                                    programasPat = programasSeguimiento.Select(d => new C_ProgramasPATSeguimiento
                                    {
                                        PROGRAMA = d.PROGRAMA,
                                        ID = 0
                                    });
                                }
                                else
                                {
                                    programasPat = gestionDeptal.ProgramasDepartamentoPAT(idRespuestaDpto).Select(d => new C_ProgramasPATSeguimiento
                                    {
                                        PROGRAMA = d.PROGRAMA,
                                        ID = 0
                                    });
                                }
                            }
                        } else
                        {
                            programasPat = gestionMunicipal.ProgramasPAT(idRespuesta).Select(d => new C_ProgramasPATSeguimiento
                            {
                                PROGRAMA = d.PROGRAMA,
                                ID = 0
                            });
                        }
                    }
                    else
                    {
                        using (EntitiesRusicst BD = new EntitiesRusicst())
                        {
                            IEnumerable<C_ProgramasSeguimiento_Result> programasSeguimiento = BD.C_ProgramasSeguimiento(idSeguimiento).Cast<C_ProgramasSeguimiento_Result>().ToList();

                            programasPat = programasSeguimiento.Where(a => a.NumeroSeguimiento == 1).Select(a => new C_ProgramasPATSeguimiento
                            {
                                ID = a.IdSeguimiento,
                                PROGRAMA = a.Programa,
                                NumeroSeguimiento = a.NumeroSeguimiento
                            }).ToList();

                        }
                    }
                    return programasPat;
                }
                else
                {
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        if (consolidado)
                        {
                            IEnumerable<C_ProgramasSeguimientoDepartamento_Result> programasSeguimiento = BD.C_ProgramasSeguimientoDepartamento(idSeguimiento).Cast<C_ProgramasSeguimientoDepartamento_Result>().ToList();

                            programasPat = programasSeguimiento.Select(a => new C_ProgramasPATSeguimiento
                            {
                                ID = a.IdSeguimiento,
                                PROGRAMA = a.Programa,
                                NumeroSeguimiento = a.NumeroSeguimiento
                            }).ToList();
                        }
                        else
                        {

                            IEnumerable<C_ProgramasSeguimiento_Result> programasSeguimiento = BD.C_ProgramasSeguimiento(idSeguimiento).Cast<C_ProgramasSeguimiento_Result>().ToList();

                            programasPat = programasSeguimiento.Select(a => new C_ProgramasPATSeguimiento
                            {
                                ID = a.IdSeguimiento,
                                PROGRAMA = a.Programa,
                                NumeroSeguimiento = a.NumeroSeguimiento
                            }).ToList();
                        }



                        return programasPat;
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return null;
            }
        }

        /// <summary>
        /// Datoses the iniciales consolidado x mpio seguimiento depto.
        /// </summary>
        /// <param name="idRespuesta">The identifier respuesta.</param>
        /// <param name="idSeguimiento">The identifier seguimiento.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosInicialesConsolidadoXMpioSeguimientoDepto/")]
        public object DatosInicialesConsolidadoXMpioSeguimientoDepto(int idRespuesta = 0, int idSeguimiento = 0, short idPregunta = 0, int idUsuarioAlcaldia = 0, int idDepartamento = 0, int idMunicipio = 0, int idSeguimientoMun = 0, int numSeguimiento = 1, int idRespuestaDpto = 0, int idUsuarioGob = 0)
        {
            SeguimientoMunicipalController clsSegMunicipios = new SeguimientoMunicipalController();
            var datosSeguimiento = GetSeguimientoGobernacion(idSeguimiento);
            var datosSegNacional = clsSegMunicipios.DatosSeguimientoNacionalPorMunicipio(idPregunta, idMunicipio);
            var datosPrecargueNacional = clsSegMunicipios.DatosPreguntaPATPrecargueEntidadesNacionales(idPregunta, idMunicipio);
            var datosProgramas = GetProgramasSeguimientoDepto(idRespuesta, idSeguimiento, numSeguimiento, true, idRespuestaDpto, idPregunta, idUsuarioGob);
            var datosSegAlcaldia = clsSegMunicipios.GetTableroSeguimientoDetalle(idUsuarioAlcaldia, idPregunta, numSeguimiento);
            var datosSegGobernaciones = clsSegMunicipios.DatosSeguimientoDepartamentoPorMunicipio(idPregunta, idMunicipio);
            var datosProgramasAlcaldia = clsSegMunicipios.GetProgramasSeguimiento(idRespuesta, idSeguimientoMun, 2);
            var objeto = new
            {
                datosProgramas = datosProgramas,
                datosSeguimiento = datosSeguimiento,
                datosSegNacional = datosSegNacional,
                datosPrecargueNacional = datosPrecargueNacional,
                datosSegAlcaldia = datosSegAlcaldia,
                datosProgramasAlcaldia = datosProgramasAlcaldia
            };

            return objeto;
        }

        private object clsSegMunicipiosDatosSeguimientoNacionalPorMunicipio(object idPregunta, object idMunicipio)
        {
            throw new NotImplementedException();
        }

        #endregion

        #region APIS PARA EL MODAL DE DEPAERTAMENTOS OTROS DERECHOS 

        /// <summary>
        /// Gets the lista municipios od.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <returns>IEnumerable&lt;C_MunicipiosOtrosDerechos_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetListaMunicipiosOD/")]
        public IEnumerable<C_MunicipiosOtrosDerechos_Result> GetListaMunicipiosOD(int idUsuario)
        {
            IEnumerable<C_MunicipiosOtrosDerechos_Result> resultado = Enumerable.Empty<C_MunicipiosOtrosDerechos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_MunicipiosOtrosDerechos(idUsuario: idUsuario).Cast<C_MunicipiosOtrosDerechos_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Datoses the iniciales edicion seguimiento departamento od.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosInicialesEdicionSeguimientoDepartamentoOD/")]
        public object DatosInicialesEdicionSeguimientoDepartamentoOD(byte idTablero = 0, int idUsuario = 0)
        {
            AdministracionController clsPreguntas = new AdministracionController();
            SeguimientoMunicipalController clsSegMuni = new SeguimientoMunicipalController();
            var listaDerechos = clsSegMuni.GetDerechosOD(idTablero);
            var listaUnidades = clsPreguntas.UnidadesMedida();
            var listaMunicipios = GetListaMunicipiosOD(idUsuario);

            var objeto = new
            {
                listaDerechos = listaDerechos,
                listaUnidades = listaUnidades,
                listaMunicipios = listaMunicipios
            };

            return objeto;
        }

        /// <summary>
        /// Registrars the seguimiento departamental od.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/RegistrarSeguimientoDepartamentalOD/")]
        public C_AccionesResultadoInsert RegistrarSeguimientoDepartamentalOD(SeguimientoGobernacionOtrosDerechos model)
        {
            C_AccionesResultadoInsert resultado = new C_AccionesResultadoInsert();
            bool Insertando = false;
            model.NombreAdjunto = model.NombreAdjunto.Replace('ñ', 'n').Replace('Ñ', 'N');
            model.Accion = quitarAcentos(model.Accion);
            model.Observaciones = quitarAcentos(model.Observaciones);
            model.Programa = quitarAcentos(model.Programa);

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                using (var dbContextTransaction = BD.Database.BeginTransaction())
                {
                    try
                    {
                        if (model.IdSeguimiento > 0)
                        {
                            Insertando = false;
                        }
                        else
                        {
                            var datosInsert = BD.I_SeguimientoDepartamentalOtrosDerechosInsert(idTablero: model.IdTablero, idUsuario: model.IdUsuario, idUsuarioAlcaldia: model.IdUsuarioAlcaldia, accion: model.Accion, cantidad: model.Cantidad, idUnidad: model.IdUnidad, presupuesto: model.Presupuesto, observaciones: model.Observaciones, nombreAdjunto: model.NombreAdjunto, programa: model.Programa).FirstOrDefault();
                            model.IdSeguimiento = datosInsert.id.Value;
                            resultado.id = datosInsert.id;
                            resultado.estado = datosInsert.estado;
                            resultado.respuesta = datosInsert.respuesta;
                            Insertando = true;

                            if (resultado.estado == 1 || resultado.estado == 2)
                            {
                                if (model.SeguimientoGobernacionOtrosDerechosMedidas != null)
                                {
                                    if (model.SeguimientoGobernacionOtrosDerechosMedidas.Count() > 0)
                                    {
                                        foreach (var item in model.SeguimientoGobernacionOtrosDerechosMedidas)
                                        {
                                            item.IdSeguimiento = model.IdSeguimiento;
                                            var datosInsertM = BD.I_SeguimientoDepartamentalOtrosDerechosMedidasInsert(idSeguimiento: model.IdSeguimiento, idMedida: item.IdMedida, idComponente: item.IdComponente, idDerecho: item.IdDerecho).FirstOrDefault();
                                            item.Insertado = true;
                                            resultado.estado = datosInsertM.estado;
                                            resultado.respuesta = datosInsertM.respuesta;

                                            if (resultado.estado == 0)
                                            {
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        if (resultado.estado == 1 || resultado.estado == 2)
                        {
                            dbContextTransaction.Commit();

                            //// Audita la creación o actualización de la respuesta PAT
                            (new AuditExecuted(Insertando ? Category.CrearSeguimientoGobernacionOtrosDerechos : Category.EditarSeguimientoGobernacionOtrosDerechos)).ActionExecutedManual(model);

                            if (model.SeguimientoGobernacionOtrosDerechosMedidas != null)
                            {
                                if (model.SeguimientoGobernacionOtrosDerechosMedidas.Count() > 0)
                                {
                                    foreach (var item in model.SeguimientoGobernacionOtrosDerechosMedidas)
                                    {
                                        item.AudUserName = model.AudUserName;
                                        item.AddIdent = model.AddIdent;
                                        item.UserNameAddIdent = model.UserNameAddIdent;
                                        (new AuditExecuted(item.Insertado ? Category.CrearSeguimientoGobernacionOtrosDerechosMedidas : Category.EditarSeguimientoGobernacionOtrosDerechosMedidas)).ActionExecutedManual(item);
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
        /// Eliminars the medida departamento od.
        /// </summary>
        /// <param name="idSeguimientoMedida">The identifier seguimiento medida.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.EliminarSeguimientoGobernacionOtrosDerechosMedidas)]
        [Route("api/TableroPat/EliminarMedidaDepartamentoOD/")]
        public C_AccionesResultado EliminarMedidaDepartamentoOD(SeguimientoGobernacionOtrosDerechosMedidas model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                try
                {
                    resultado = BD.D_SeguimientoDepartamentalOtrosDerechosMedidasDelete(idSeguimientoMedida: model.IdSeguimientoMedidas).FirstOrDefault();
                }
                catch (Exception ex)
                {
                    (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                }
            }

            return resultado;
        }

        #endregion

        #region APIS PARA EL MODAL DEPARTAMENTOS RETORNOS Y REUBICACIONES

        /// <summary>
        /// Gets the tablero seguimiento departamento rr.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="idMunicipio">The identifier municipio.</param>
        /// <returns>IEnumerable&lt;C_TableroSeguimientoDepartamentoRetornosReubicaciones_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetTableroSeguimientoDepartamentoRR/")]
        public IEnumerable<C_TableroSeguimientoDepartamentoRetornosReubicaciones_Result> GetTableroSeguimientoDepartamentoRR(int idTablero = 0, int idMunicipio = 0)
        {
            IEnumerable<C_TableroSeguimientoDepartamentoRetornosReubicaciones_Result> resultado = Enumerable.Empty<C_TableroSeguimientoDepartamentoRetornosReubicaciones_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroSeguimientoDepartamentoRetornosReubicaciones(idTablero: idTablero, idMunicipio: idMunicipio).Cast<C_TableroSeguimientoDepartamentoRetornosReubicaciones_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        /// <summary>
        /// Datoses the iniciales seguimiento departamento rc.
        /// </summary>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <param name="idUsuarioAlcaldia">The identifier usuario alcaldia.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosInicialesSeguimientoDepartamentoRR/")]
        public object DatosInicialesSeguimientoDepartamentoRR(int idPregunta, int idUsuarioAlcaldia)
        {
            C_DatosSeguimientoDepartamentoRetornosReubicaciones_Result resultado = new C_DatosSeguimientoDepartamentoRetornosReubicaciones_Result();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    var seguimiento = BD.C_DatosSeguimientoDepartamentoRetornosReubicaciones(idUsuarioAlcaldia: idUsuarioAlcaldia, idPregunta: idPregunta).Cast<C_DatosSeguimientoDepartamentoRetornosReubicaciones_Result>().ToList(); ;
                    if (seguimiento.Any())
                    {
                        var segu = seguimiento.First();
                        resultado.IdPregunta = segu.IdPregunta;
                        resultado.IdUsuario = segu.IdUsuario;
                        resultado.IdSeguimientoRR = segu.IdSeguimientoRR;
                        resultado.AvancePrimer = segu.AvancePrimer;
                        resultado.AvanceSegundo = segu.AvanceSegundo;
                        resultado.NombreAdjunto = segu.NombreAdjunto;
                        resultado.IdTablero = segu.IdTablero;
                        resultado.FechaSeguimiento = segu.FechaSeguimiento;
                    }
                    else
                    {
                        resultado.IdPregunta = Convert.ToInt16(idPregunta);
                        resultado.IdUsuario = idUsuarioAlcaldia;
                        resultado.IdSeguimientoRR = 0;
                        resultado.AvancePrimer = "";
                        resultado.AvanceSegundo = "";
                        resultado.NombreAdjunto = "";
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
        /// Registrars the seguimiento departamento rr.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/RegistrarSeguimientoDepartamentoRR/")]
        public C_AccionesResultado RegistrarSeguimientoDepartamentoRR(SeguimientoRetornosReubicacionesDepto model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            bool Insertando = false;
            model.NombreAdjunto = model.NombreAdjunto.Replace('ñ', 'n').Replace('Ñ', 'N');
            model.AvancePrimer = quitarAcentos(model.AvancePrimer);
            model.AvanceSegundo = quitarAcentos(model.AvanceSegundo);

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                try
                {
                    if (model.IdSeguimientoRR > 0)
                    {
                        resultado = BD.U_SeguimientoGobernacionRRUpdate(idSeguimiento: model.IdSeguimientoRR, idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, avancePrimer: model.AvancePrimer, avanceSegundo: model.AvanceSegundo, nombreAdjunto: model.NombreAdjunto).FirstOrDefault();
                        Insertando = false;
                    }
                    else
                    {
                        var datosInsert = BD.I_SeguimientoDepartamentalRRInsert(idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, idUsuarioAlcaldia: model.IdUsuarioAlcaldia, avancePrimer: model.AvancePrimer, avanceSegundo: model.AvanceSegundo, nombreAdjunto: model.NombreAdjunto).FirstOrDefault();
                        model.IdSeguimientoRR = datosInsert.id.Value;
                        resultado.estado = datosInsert.estado;
                        resultado.respuesta = datosInsert.respuesta;
                        Insertando = true;
                    }
                }
                catch (Exception ex)
                {
                    (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                }
                finally
                {
                    //// Audita la creación o actualización del seguimiento de retornos de reubicación por departamento
                    (new AuditExecuted(Insertando ? Category.CrearSeguimientoRetornosReubicacionesDepto : Category.EditarSeguimientoRetornosReubicacionesDepto)).ActionExecutedManual(model);
                }

                return resultado;
            }
        }

        #endregion

        #region APIS PARA EL MODAL DEPARTAMENTOS REPARACION COLECTIVA        

        /// <summary>
        /// Gets the tablero seguimiento departamento rc.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="idMunicipio">The identifier municipio.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetTableroSeguimientoDepartamentoRC/")]
        public object GetTableroSeguimientoDepartamentoRC(int idTablero, int idMunicipio)
        {
            IEnumerable<C_TableroSeguimientoDepartamentoReparacionColectiva_Result> resultado = Enumerable.Empty<C_TableroSeguimientoDepartamentoReparacionColectiva_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroSeguimientoDepartamentoReparacionColectiva(idTablero: idTablero, idMunicipio: idMunicipio).Cast<C_TableroSeguimientoDepartamentoReparacionColectiva_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Datoses the iniciales seguimiento departamento rc.
        /// </summary>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <param name="idUsuarioAlcaldia">The identifier usuario alcaldia.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosInicialesSeguimientoDepartamentoRC/")]
        public object DatosInicialesSeguimientoDepartamentoRC(int idPregunta, int idUsuarioAlcaldia, int idRespuestaRC)
        {
            C_DatosSeguimientoDepartamentoReparacionColectiva_Result resultado = new C_DatosSeguimientoDepartamentoReparacionColectiva_Result();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    var seguimiento = BD.C_DatosSeguimientoDepartamentoReparacionColectiva(idUsuarioAlcaldia: idUsuarioAlcaldia, idPregunta: idPregunta, idRespuestaRC: idRespuestaRC).Cast<C_DatosSeguimientoDepartamentoReparacionColectiva_Result>().ToList(); ;
                    if (seguimiento.Any())
                    {
                        var segu = seguimiento.First();
                        resultado.IdPregunta = segu.IdPregunta;
                        resultado.IdUsuario = segu.IdUsuario;
                        resultado.IdSeguimientoRC = segu.IdSeguimientoRC;
                        resultado.AvancePrimer = segu.AvancePrimer;
                        resultado.AvanceSegundo = segu.AvanceSegundo;
                        resultado.NombreAdjunto = segu.NombreAdjunto;
                        resultado.IdTablero = segu.IdTablero;
                        resultado.FechaSeguimiento = segu.FechaSeguimiento;
                    }
                    else
                    {
                        resultado.IdPregunta = Convert.ToInt16(idPregunta);
                        resultado.IdUsuario = idUsuarioAlcaldia;
                        resultado.IdSeguimientoRC = 0;
                        resultado.AvancePrimer = "";
                        resultado.AvanceSegundo = "";
                        resultado.NombreAdjunto = "";
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
        /// Registrars the seguimiento departamento rc.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/RegistrarSeguimientoDepartamentoRC/")]
        public C_AccionesResultado RegistrarSeguimientoDepartamentoRC(SeguimientoReparacionColectivaDepto model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            bool Insertando = false;
            model.NombreAdjunto = model.NombreAdjunto.Replace('ñ', 'n').Replace('Ñ', 'N');
            model.AvancePrimer = quitarAcentos(model.AvancePrimer);
            model.AvanceSegundo = quitarAcentos(model.AvanceSegundo);

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                try
                {
                    if (model.IdSeguimientoRC > 0)
                    {
                        resultado = BD.U_SeguimientoGobernacionRCUpdate(idSeguimiento: model.IdSeguimientoRC, idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, avancePrimer: model.AvancePrimer, avanceSegundo: model.AvanceSegundo, nombreAdjunto: model.NombreAdjunto, idRespuestaRC: model.IdRespuestaRC).FirstOrDefault();
                        Insertando = false;
                    }
                    else
                    {
                        var datosInsert = BD.I_SeguimientoDepartamentalRCInsert(idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, idUsuarioAlcaldia: model.IdUsuarioAlcaldia, avancePrimer: model.AvancePrimer, avanceSegundo: model.AvanceSegundo, nombreAdjunto: model.NombreAdjunto, idRespuestaRC: model.IdRespuestaRC).FirstOrDefault();
                        model.IdSeguimientoRC = datosInsert.id.Value;
                        resultado.estado = datosInsert.estado;
                        resultado.respuesta = datosInsert.respuesta;
                        Insertando = true;
                    }
                }
                catch (Exception ex)
                {
                    (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                }
                finally
                {
                    //// Audita la creación o actualización del seguimiento de la reparación colectiva por departamento
                    (new AuditExecuted(Insertando ? Category.CrearSeguimientoReparacionColectivaDepto : Category.EditarSeguimientoReparacionColectivaDepto)).ActionExecutedManual(model);
                }
            }

            return resultado;
        }

        #endregion

        /// <summary>
        /// Eliminar Caracteres especiales
        /// </summary>
        /// <param name="valor"></param>
        /// <returns></returns>
        private string quitarAcentos(string valor)
        {
            if (valor != null)
                return valor.Replace("\"", " ").Replace("#", " ").Replace("-", " ").Replace("\n", " ").Replace("\t", " ").Replace("“", " ").Replace("”", " ").Replace("$", " ").Replace("%", " ").Replace("°", " ");
            else
                return valor;
        }
    }
}