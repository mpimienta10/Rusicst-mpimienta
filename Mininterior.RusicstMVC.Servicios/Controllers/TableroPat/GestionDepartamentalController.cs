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
    /// Class GestionDepartamentalController.
    /// </summary>
    public class GestionDepartamentalController : ApiController
    {
        #region APIS PARA LA PANTALLA DE LOS TABLEROS    

        /// <summary>
        /// Listas the tableros municipio completados.
        /// </summary>
        /// <returns>IEnumerable&lt;C_TodosTablerosDepartamentosCompletos_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/TablerosDepartamento/ListaTablerosDepartamentosCompletados/{Usuario}")]
        public IEnumerable<C_TodosTablerosDepartamentosCompletos_Result> ListaTablerosMunicipioCompletados(string Usuario = "")
        {
            IEnumerable<C_TodosTablerosDepartamentosCompletos_Result> resultado = Enumerable.Empty<C_TodosTablerosDepartamentosCompletos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    IEnumerable<C_Usuario_Result> ListaUsuarios = BD.C_Usuario(null, null, null, null, null, Usuario, null).Cast<C_Usuario_Result>().ToList();
                    C_Usuario_Result model = ListaUsuarios.FirstOrDefault();
                    resultado = BD.C_TodosTablerosDepartamentosCompletos(idUsuario: model.Id).Cast<C_TodosTablerosDepartamentosCompletos_Result>().ToList(); ;
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
        /// <returns>IEnumerable&lt;C_TodosTablerosDepartamentosPorCompletar_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/TablerosDepartamento/ListaTablerosDepartamentoPorCompletar/{Usuario}")]
        public IEnumerable<C_TodosTablerosDepartamentosPorCompletar_Result> ListaTablerosMunicipioPorCompletar(string Usuario = "")
        {
            IEnumerable<C_TodosTablerosDepartamentosPorCompletar_Result> resultado = Enumerable.Empty<C_TodosTablerosDepartamentosPorCompletar_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    IEnumerable<C_Usuario_Result> ListaUsuarios = BD.C_Usuario(null, null, null, null, null, Usuario, null).Cast<C_Usuario_Result>().ToList();
                    C_Usuario_Result model = ListaUsuarios.FirstOrDefault();
                    resultado = BD.C_TodosTablerosDepartamentosPorCompletar(idUsuario: model.Id).Cast<C_TodosTablerosDepartamentosPorCompletar_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion

        #region APIS PARA PANTALLA DE PREGUNTAS DEPARTAMENTO

        /// <summary>
        /// Tableroes the departamento.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroDepartamento_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/TableroDepartamento/{sortOrder},{page},{pageSize},{idUsuario},{busqueda},{idTablero}")]
        public IEnumerable<C_TableroDepartamento_Result> TableroDepartamento(int idUsuario, byte idTablero)
        {
            IEnumerable<C_TableroDepartamento_Result> resultado = Enumerable.Empty<C_TableroDepartamento_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroDepartamento(idUsuario: idUsuario, idTablero: idTablero).Cast<C_TableroDepartamento_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Tableroes the departamento avance.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroDepartamentoAvance_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/Departamento/TableroDepartamentoAvance/")]
        public IEnumerable<C_TableroDepartamentoAvance_Result> TableroDepartamentoAvance(int idUsuario, byte idTablero)
        {
            IEnumerable<C_TableroDepartamentoAvance_Result> resultado = Enumerable.Empty<C_TableroDepartamentoAvance_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroDepartamentoAvance(idUsuario: idUsuario, idTablero: idTablero).Cast<C_TableroDepartamentoAvance_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Cargars the tablero departamentos.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="numMostrar">The number mostrar.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="Usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarTableroDepartamentos/{sortOrder},{page},{numMostrar},{idDerecho},{Usuario},{idTablero}")]
        public object CargarTableroDepartamentos(string sortOrder, Int16 page = 1, Int16 numMostrar = 10, int idDerecho = 0, string Usuario = "", byte idTablero = 0)
        {
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            GestionMunicipalController clsuMunicipios = new GestionMunicipalController();
            AdministracionController clsAdmin = new AdministracionController();

            var modelUsuario = new UsuariosModels { UserName = Usuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
            int IdUsuario = datosUsuario.FirstOrDefault().Id;

            HabilitarReportesController clsHabilitar = new HabilitarReportesController();

            PermisoUsuarioEncuestaModels modelHabilitarExtension = new PermisoUsuarioEncuestaModels();
            modelHabilitarExtension.IdUsuario = IdUsuario;
            modelHabilitarExtension.IdEncuesta = idTablero;
            modelHabilitarExtension.IdTipoTramite = 3;
            //modelHabilitarExtension.AudUserName = modelUsuario.UserName;

            bool activo = clsuMunicipios.TableroFechaActivo(2, idTablero) > 0 || clsHabilitar.ValidarExtensiones(modelHabilitarExtension);
            //Si se envio el tablero se debe inactivar para guardar informacion
            //bool tableroEnviado = clsuMunicipios.ValidarEnvioTableroPat(IdUsuario, idTablero, "PD");
            //if (activo == true && tableroEnviado == true)
            //{
            //    activo = false;
            //}
            var avance = TableroDepartamentoAvance(IdUsuario, idTablero);
            var datos = TableroDepartamento(IdUsuario, idTablero);

            var derechos = clsuMunicipios.Derechos(idTablero, IdUsuario, true);
            var vigencia = clsuMunicipios.TableroVigencia(idTablero);

            //validacion del envio tablero PAT planeacion
            Boolean ActivoEnvioPATPlaneacion = false;
            if (activo)
            {
                var tablero = clsAdmin.ListaTodosTableros().Where(s => s.IdTablero == idTablero && s.Nivel == 2).FirstOrDefault();
               
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
                ActivoEnvioPATPlaneacion = ActivoEnvioPATPlaneacion
            };

            return objeto;
        }

        [HttpGet]
        [Route("api/TableroPat/FuentesPresupuestoRespuestaPATDepartamento/")]
        public IEnumerable<C_FuentePresupuestoPATDiligenciamientoDepartamentos_Result> FuentesPresupuestoRespuestaPATDepartamento(int idRespuesta)
        {
            IEnumerable<C_FuentePresupuestoPATDiligenciamientoDepartamentos_Result> resultado = Enumerable.Empty<C_FuentePresupuestoPATDiligenciamientoDepartamentos_Result>();
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_FuentePresupuestoPATDiligenciamientoDepartamentos(idRespuesta: idRespuesta).Cast<C_FuentePresupuestoPATDiligenciamientoDepartamentos_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            return resultado;
        }



        /// <summary>
        /// Datoses the iniciales edicion departamento.
        /// </summary>
        /// <param name="pregunta">The pregunta.</param>
        /// <param name="id">The identifier.</param>
        /// <param name="IdUsuario">The identifier usuario.</param>
        /// <param name="Usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosInicialesEdicionDepartamento/")]
        public object DatosInicialesEdicionDepartamento(short pregunta, int id, int IdUsuario, string Usuario = "", byte idTablero = 0)
        {
            GestionMunicipalController clsuMunicipios = new GestionMunicipalController();

            var datosAcciones = clsuMunicipios.AccionesPAT(id, "");
            var datosProgramas = clsuMunicipios.ProgramasPAT(id);

            var FuentesPresupuestoRespuesta = clsuMunicipios.FuentesPresupuestoRespuestaPAT(id);
            var listadoFuentesPresupuestoPAT = clsuMunicipios.FuentesPresupuestoPAT();

            HabilitarReportesController clsHabilitar = new HabilitarReportesController();

            PermisoUsuarioEncuestaModels modelHabilitarExtension = new PermisoUsuarioEncuestaModels();
            modelHabilitarExtension.IdUsuario = IdUsuario;
            modelHabilitarExtension.IdEncuesta = idTablero;
            modelHabilitarExtension.IdTipoTramite = 3;
            //modelHabilitarExtension.AudUserName = Usuario;

            bool activo = clsuMunicipios.TableroFechaActivo(2, idTablero) > 0 || clsHabilitar.ValidarExtensiones(modelHabilitarExtension);

            var objeto = new
            {
                FuentesPresupuestoRespuesta = FuentesPresupuestoRespuesta,
                listadoFuentesPresupuestoPAT = listadoFuentesPresupuestoPAT,
                datosAcciones = datosAcciones,
                datosProgramas = datosProgramas,
                activo = activo,
            };

            return objeto;
        }

        /// <summary>
        /// Modificars the departamento.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/ModificarDepartamento/")]
        public C_AccionesResultado ModificarDepartamento(RespuestaPat model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            GestionMunicipalController clsuMunicipios = new GestionMunicipalController();
            resultado = clsuMunicipios.Modificar(model);
            return resultado;
        }

        #endregion

        #region APIS PARA TAB DE CONSOLIDADO MUNICIPAL

        /// <summary>
        /// Cargars the tablero consolidado municipal.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="numMostrar">The number mostrar.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="Usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarTableroConsolidadoMunicipal/{sortOrder},{page},{numMostrar},{idDerecho},{Usuario},{idTablero}")]
        public object CargarTableroConsolidadoMunicipal(string sortOrder, Int16 page = 1, Int16 numMostrar = 10, int idDerecho = 0, string Usuario = "", byte idTablero = 0)
        {
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            GestionMunicipalController clsuMunicipios = new GestionMunicipalController();
            Sistema.ConfiguracionDerechosPATController clsConfDerechos = new Sistema.ConfiguracionDerechosPATController();

            var modelUsuario = new UsuariosModels { UserName = Usuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
            int IdUsuario = datosUsuario.FirstOrDefault().Id;

            var datosTotales = TotalesMunicipio(sortOrder, page, numMostrar, IdUsuario, idDerecho, idTablero);
            var totalTotales = ContarTotalesMunicipio(IdUsuario, idDerecho, idTablero);
            var TotalPagesTotales = (int)Math.Ceiling(totalTotales / (double)numMostrar);

            //Reparacion colectiva
            var municipiosRC = CargarMunicipiosRC(IdUsuario, idTablero);
            //Retornos y reubicaciones
            var municipiosRR = CargarMunicipiosRR(IdUsuario, idTablero);

            var urlDerechos = clsConfDerechos.CargarParametros((byte)idDerecho);

            var objeto = new
            {
                TotalPagesTotales = TotalPagesTotales,
                totalTotales = totalTotales,
                datosTotales = datosTotales,
                municipiosRC = municipiosRC,
                municipiosRR = municipiosRR,
                urlDerechos = urlDerechos
            };
            return objeto;
        }

        /// <summary>
        /// Totaleses the municipio.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="pageSize">Size of the page.</param>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroMunicipioTotales_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/TotalesMunicipio/{sortOrder},{page},{pageSize},{idUsuario},{busqueda},{idTablero}")]
        public IEnumerable<C_TableroMunicipioTotales_Result> TotalesMunicipio(string sortOrder, Int16 page, Int16 pageSize, int idUsuario, int idDerecho, byte idTablero)
        {
            IEnumerable<C_TableroMunicipioTotales_Result> resultado = Enumerable.Empty<C_TableroMunicipioTotales_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroMunicipioTotales(sortOrder: sortOrder, page: page, pageSize: pageSize, idUsuario: idUsuario, idDerecho: idDerecho, idTablero: idTablero).Cast<C_TableroMunicipioTotales_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Contars the totales municipio.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Int32.</returns>
        [HttpGet]
        [Route("api/TableroPat/ContarTotalesMunicipio/{idUsuario},{busqueda},{idTablero}")]
        public int ContarTotalesMunicipio(int idUsuario, int idDerecho, byte idTablero)
        {
            int resultado = 0;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ContarTableroMunicipioTotales(idUsuario: idUsuario, idDerecho: idDerecho, idTablero: idTablero).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Datoses the excel departamental.
        /// </summary>
        /// <param name="idMunicipio">The identifier municipio.</param>
        /// <param name="usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>HttpResponseMessage.</returns>
        [HttpGet]
        [Route("api/TableroPat/Departamentos/DatosExcelDepartamental/")]
        public HttpResponseMessage DatosExcelDepartamental(int idMunicipio, string usuario, byte idTablero)
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);
            int IdUsuario = ObtenerIdUsuario(usuario);

            IEnumerable<C_DatosExcel_Gobernaciones_Result> dataGobernaciones = Enumerable.Empty<C_DatosExcel_Gobernaciones_Result>();
            IEnumerable<C_DatosExcel_Gobernaciones_municipios_Result> dataGobernacionesMunicio = Enumerable.Empty<C_DatosExcel_Gobernaciones_municipios_Result>();
            IEnumerable<C_DatosExcel_GobernacionesReparacionColectiva_Result> dataGobernacionesRC = Enumerable.Empty<C_DatosExcel_GobernacionesReparacionColectiva_Result>();
            IEnumerable<C_DatosExcel_GobernacionesRetornosReubicaciones_Result> dataGobernacionesRR = Enumerable.Empty<C_DatosExcel_GobernacionesRetornosReubicaciones_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 3600;
                    dataGobernaciones = BD.C_DatosExcel_Gobernaciones(idUsuario: IdUsuario, idTablero: idTablero).Cast<C_DatosExcel_Gobernaciones_Result>().ToList();
                    dataGobernacionesMunicio = BD.C_DatosExcel_Gobernaciones_municipios(idUsuario: IdUsuario, idTablero: idTablero).Cast<C_DatosExcel_Gobernaciones_municipios_Result>().ToList();
                    dataGobernacionesRC = BD.C_DatosExcel_GobernacionesReparacionColectiva(idUsuario: IdUsuario, idTablero: idTablero).Cast<C_DatosExcel_GobernacionesReparacionColectiva_Result>().ToList();
                    dataGobernacionesRR = BD.C_DatosExcel_GobernacionesRetornosReubicaciones(idUsuario: IdUsuario, idTablero: idTablero).Cast<C_DatosExcel_GobernacionesRetornosReubicaciones_Result>().ToList();
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

                #region Data Excel Hoja 1

                int fila = 3;

                foreach (var item in dataGobernaciones)
                {
                    ws.Cell(fila, 1).Value = item.DERECHO;
                    ws.Cell(fila, 2).Value = item.COMPONENTE;
                    ws.Cell(fila, 3).Value = item.MEDIDA;
                    ws.Cell(fila, 4).Value = item.PREGUNTAINDICATIVA;
                    ws.Cell(fila, 5).Value = item.UNIDADMEDIDA;
                    ws.Cell(fila, 6).Value = item.RESPUESTAINDICATIVA;
                    ws.Cell(fila, 7).Value = item.OBSERVACIONNECESIDAD;
                    ws.Cell(fila, 8).Value = item.UNIDADMEDIDA;
                    ws.Cell(fila, 9).Value = item.RESPUESTACOMPROMISO;
                    ws.Cell(fila, 10).Value = item.OBSERVACIONCOMPROMISO;

                    ws.Cell(fila, 11).Value = item.PRESUPUESTO;
                    ws.Cell(fila, 11).Style.NumberFormat.Format = "$ #,##0";

                    ws.Cell(fila, 12).Value = item.ACCION;
                    ws.Cell(fila, 13).Value = item.PROGRAMA;

                    fila++;
                }

                ws.Range(1, 1, fila, 13).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws.Range(1, 1, fila, 13).Style.Border.OutsideBorderColor = XLColor.Black;

                ws.Range(1, 1, fila, 13).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws.Range(1, 1, fila, 13).Style.Border.InsideBorderColor = XLColor.Black;

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

                ws2.Cell(1, 7).Value = "Necesidad";
                ws2.Column(7).AdjustToContents();
                ws2.Range(1, 7, 1, 9).Merge();
                ws2.Cell(1, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 7).Value = "Unidad";
                ws2.Column(7).AdjustToContents();
                ws2.Cell(2, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 8).Value = "Respuesta";
                ws2.Column(8).AdjustToContents();
                ws2.Cell(2, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 9).Value = "Observación";
                ws2.Column(9).AdjustToContents();
                ws2.Cell(2, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 9).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 10).Value = "Compromiso";
                ws2.Column(10).AdjustToContents();
                ws2.Range(1, 10, 1, 13).Merge();
                ws2.Cell(1, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 10).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 10).Value = "Unidad";
                ws2.Column(10).AdjustToContents();
                ws2.Cell(2, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 10).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 11).Value = "Respuesta";
                ws2.Column(11).AdjustToContents();
                ws2.Cell(2, 11).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 11).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 12).Value = "Observación";
                ws2.Column(12).AdjustToContents();
                ws2.Cell(2, 12).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 12).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 13).Value = "Presupuesto";
                ws2.Column(13).AdjustToContents();
                ws2.Cell(2, 13).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 13).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 14).Value = "Acciones";
                ws2.Column(14).AdjustToContents();
                ws2.Range(1, 14, 2, 14).Merge();
                ws2.Cell(1, 14).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 14).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 15).Value = "Programas";
                ws2.Column(15).AdjustToContents();
                ws2.Range(1, 15, 2, 15).Merge();
                ws2.Cell(1, 15).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 15).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                //adicionales

                ws2.Cell(1, 16).Value = "Respuesta departamento";
                ws2.Column(16).AdjustToContents();
                ws2.Range(1, 16, 1, 20).Merge();
                ws2.Cell(1, 16).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 16).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 16).Value = "Compromiso";
                ws2.Column(16).AdjustToContents();
                ws2.Cell(2, 16).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 16).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 17).Value = "Presupuesto";
                ws2.Column(17).AdjustToContents();
                ws2.Cell(2, 17).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 17).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 18).Value = "Observación";
                ws2.Column(18).AdjustToContents();
                ws2.Cell(2, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 18).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 19).Value = "Acción";
                ws2.Column(19).AdjustToContents();
                ws2.Cell(2, 19).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 19).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(2, 20).Value = "Programa";
                ws2.Column(20).AdjustToContents();
                ws2.Cell(2, 20).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(2, 20).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Range(1, 1, 1, 20).Style.Font.Bold = true;
                ws2.Range(2, 1, 2, 20).Style.Font.Bold = true;

                #endregion

                #region Data Excel Hoja 2

                int fila2 = 3;

                foreach (var item in dataGobernacionesMunicio)
                {
                    ws2.Cell(fila2, 1).Value = item.DEPTO;
                    ws2.Cell(fila2, 2).Value = item.MPIO;
                    ws2.Cell(fila2, 3).Value = item.DERECHO;
                    ws2.Cell(fila2, 4).Value = item.COMPONENTE;
                    ws2.Cell(fila2, 5).Value = item.MEDIDA;
                    ws2.Cell(fila2, 6).Value = item.PREGUNTAINDICATIVA;
                    ws2.Cell(fila2, 7).Value = item.UNIDADMEDIDA;
                    ws2.Cell(fila2, 8).Value = item.RESPUESTAINDICATIVA;
                    ws2.Cell(fila2, 9).Value = item.OBSERVACIONNECESIDAD;
                    ws2.Cell(fila2, 10).Value = item.UNIDADMEDIDA;
                    ws2.Cell(fila2, 11).Value = item.RESPUESTACOMPROMISO;

                    ws2.Cell(fila2, 13).Value = item.PRESUPUESTO;
                    ws2.Cell(fila2, 13).Style.NumberFormat.Format = "$ #,##0";

                    ws2.Cell(fila2, 14).Value = item.ACCION;
                    ws2.Cell(fila2, 15).Value = item.PROGRAMA;

                    ws2.Cell(fila2, 16).Value = item.RESPUESTA_DEP_COMPROMISO;
                    ws2.Cell(fila2, 17).Value = item.RESPUESTA_DEP_PRESUPUESTO;
                    ws2.Cell(fila2, 17).Style.NumberFormat.Format = "$ #,##0";

                    ws2.Cell(fila2, 18).Value = item.RESPUESTA_DEP_OBSERVACION;
                    ws2.Cell(fila2, 19).Value = item.ACCION_DEPTO;
                    ws2.Cell(fila2, 20).Value = item.PROGRAMA_DEPTO;

                    fila2++;
                }

                //ws2.Range(1, 1, fila2, 20).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                //ws2.Range(1, 1, fila2, 20).Style.Border.OutsideBorderColor = XLColor.Black;

                //ws2.Range(1, 1, fila2, 20).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                //ws2.Range(1, 1, fila2, 20).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion

                //Hoja 3
                var ws3 = workbook.Worksheets.Add("Reparaciones Colectivas");

                #region Encabezado columnas Hoja 3

                ws3.Cell(1, 1).Value = "Municipio";
                ws3.Column(1).AdjustToContents();
                ws3.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 2).Value = "Sujeto";
                ws3.Column(2).AdjustToContents();
                ws3.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 3).Value = "Tipo Medida";
                ws3.Column(3).AdjustToContents();
                ws3.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 4).Value = "Medida";
                ws3.Column(4).AdjustToContents();
                ws3.Cell(1, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 5).Value = "Acción Municipio";
                ws3.Column(5).AdjustToContents();
                ws3.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 6).Value = "Presupuesto Municipio";
                ws3.Column(6).AdjustToContents();
                ws3.Cell(1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 7).Value = "Acción Departamento";
                ws3.Column(7).AdjustToContents();
                ws3.Cell(1, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 8).Value = "Presupuesto Departamento";
                ws3.Column(8).AdjustToContents();
                ws3.Cell(1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Range(1, 1, 1, 8).Style.Font.Bold = true;

                #endregion

                #region Data Excel Hoja 3

                int fila3 = 2;

                foreach (var item in dataGobernacionesRC)
                {
                    ws3.Cell(fila3, 1).Value = item.Municipio;
                    ws3.Cell(fila3, 2).Value = item.Sujeto;
                    ws3.Cell(fila3, 3).Value = item.Medida;
                    ws3.Cell(fila3, 4).Value = item.MedidaReparacionColectiva;
                    ws3.Cell(fila3, 5).Value = item.Accion;

                    ws3.Cell(fila3, 6).Value = item.Presupuesto;
                    ws3.Cell(fila3, 6).Style.NumberFormat.Format = "$ #,##0";

                    ws3.Cell(fila3, 7).Value = item.AccionDepartamento;

                    ws3.Cell(fila3, 8).Value = item.PresupuestoDepartamento;
                    ws3.Cell(fila3, 8).Style.NumberFormat.Format = "$ #,##0";

                    fila3++;
                }

                ws3.Range(1, 1, fila3, 8).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws3.Range(1, 1, fila3, 8).Style.Border.OutsideBorderColor = XLColor.Black;

                ws3.Range(1, 1, fila3, 8).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws3.Range(1, 1, fila3, 8).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion

                //Hoja 4

                var ws4 = workbook.Worksheets.Add("Retornos y Reubicaciones");

                #region Encabezado columnas Hoja 4

                ws4.Cell(1, 1).Value = "Municipio";
                ws4.Column(1).AdjustToContents();
                ws4.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 2).Value = "Comunidad";
                ws4.Column(2).AdjustToContents();
                ws4.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 3).Value = "Ubicación";
                ws4.Column(3).AdjustToContents();
                ws4.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 4).Value = "Personas";
                ws4.Column(4).AdjustToContents();
                ws4.Cell(1, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 5).Value = "Hogares";
                ws4.Column(5).AdjustToContents();
                ws4.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 6).Value = "Medida";
                ws4.Column(6).AdjustToContents();
                ws4.Cell(1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 7).Value = "Indicador";
                ws4.Column(7).AdjustToContents();
                ws4.Cell(1, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 8).Value = "Sector";
                ws4.Column(8).AdjustToContents();
                ws4.Cell(1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 9).Value = "Componente";
                ws4.Column(9).AdjustToContents();
                ws4.Cell(1, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 9).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 10).Value = "Entidad Responsable";
                ws4.Column(10).AdjustToContents();
                ws4.Cell(1, 10).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 10).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 11).Value = "Acción";
                ws4.Column(11).AdjustToContents();
                ws4.Cell(1, 11).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 11).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 12).Value = "Presupuesto";
                ws4.Column(12).AdjustToContents();
                ws4.Cell(1, 12).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 12).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 13).Value = "Acción Departamento";
                ws4.Column(13).AdjustToContents();
                ws4.Cell(1, 13).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 13).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 14).Value = "Presupuesto Departamento";
                ws4.Column(14).AdjustToContents();
                ws4.Cell(1, 14).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 14).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Range(1, 1, 1, 14).Style.Font.Bold = true;

                #endregion

                #region Data Excel Hoja 4

                int fila4 = 2;

                foreach (var item in dataGobernacionesRR)
                {
                    ws4.Cell(fila4, 1).Value = item.Municipio;//municipio
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

                    fila4++;
                }

                ws4.Range(1, 1, fila4, 14).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws4.Range(1, 1, fila4, 14).Style.Border.OutsideBorderColor = XLColor.Black;

                ws4.Range(1, 1, fila4, 14).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws4.Range(1, 1, fila4, 14).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion

                var finalfilename = Path.Combine(@"c:\Temp", "Reporte_Tablero_PAT-Departamental.xlsx");
                var filename = "Reporte_Tablero_PAT_-_Departamental.xlsx";
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

        #region APIS PARA EDICION DE CONSOLIDADO MUNICIPAL- MODAL INGRESAR

        /// <summary>
        /// Datoses the consolidado.
        /// </summary>
        /// <param name="pregunta">The pregunta.</param>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosConsolidado/")]
        public object DatosConsolidado(short pregunta = 0, int idUsuario = 0, byte idTablero = 0)
        {
            GestionMunicipalController clsuMunicipios = new GestionMunicipalController();

            HabilitarReportesController clsHabilitar = new HabilitarReportesController();
            PermisoUsuarioEncuestaModels modelHabilitarExtension = new PermisoUsuarioEncuestaModels();
            modelHabilitarExtension.IdUsuario = idUsuario;
            modelHabilitarExtension.IdEncuesta = idTablero;
            modelHabilitarExtension.IdTipoTramite = 3;
            bool activo = clsuMunicipios.TableroFechaActivo(2, idTablero) > 0 || clsHabilitar.ValidarExtensiones(modelHabilitarExtension);
            IEnumerable<C_ConsolidadosMunicipio_Result> resultado = Enumerable.Empty<C_ConsolidadosMunicipio_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConsolidadosMunicipio(idUsuario: idUsuario, idPregunta: pregunta, idTablero: idTablero).Cast<C_ConsolidadosMunicipio_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            var objeto = new
            {
                datos = resultado,
                activo = activo
            };

            return objeto;
        }

        #endregion

        #region APIS PARA EDICION RESPUESTAS DE LOS DEPARTAMENTOS EN EL CONSOLIDADO MUNICIPAL- MODAL INGRESAR RESPUESTAS A MUNICIPIOS

        [HttpGet]
        [Route("api/TableroPat/ProgramasDepartamentoPAT/")]
        public IEnumerable<C_ProgramasDepartamentoPAT_Result> ProgramasDepartamentoPAT(int id)
        {
            IEnumerable<C_ProgramasDepartamentoPAT_Result> resultado = Enumerable.Empty<C_ProgramasDepartamentoPAT_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ProgramasDepartamentoPAT(iD: id).Cast<C_ProgramasDepartamentoPAT_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        [HttpGet]
        [Route("api/TableroPat/DatosInicialesRespuestaConsolidadoAccionesProgramas/")]
        public object DatosInicialesRespuestaConsolidadoAccionesProgramas(short pregunta = 0, int id = 0, int idUsuario = 0, byte idTablero = 0)
        {
            GestionMunicipalController clsuMunicipios = new GestionMunicipalController();

            var datosAcciones = clsuMunicipios.AccionesPAT(id, "DM");
            var datosProgramas = ProgramasDepartamentoPAT(id);

            var objeto = new
            {
                datosAcciones = datosAcciones,
                datosProgramas = datosProgramas
            };

            return objeto;
        }

        /// <summary>
        /// Modificars the respuesta departamento.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/ModificarRespuestaDepartamento/")]
        public C_AccionesResultado ModificarRespuestaDepartamento(RespuestaPatDepartamentos model)
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
                            resultado = BD.U_RespuestaDepartamentoUpdate(id: model.ID, idTablero: model.IDTABLERO, idPreguntaPAT: model.IDPREGUNTA, respuestaCompromiso: model.RESPUESTACOMPROMISO, presupuesto: model.PRESUPUESTO, observacionCompromiso: model.OBSERVACIONCOMPROMISO, idMunicipioRespuesta: model.IDMUNICIPIORESPUESTA, idUsuario: model.IDUSUARIO).FirstOrDefault();
                            Insertando = false;
                        }
                        else
                        {
                            var datosInsert = BD.I_RespuestaDepartamentoInsert(idTablero: model.IDTABLERO, idPreguntaPAT: model.IDPREGUNTA, respuestaCompromiso: model.RESPUESTACOMPROMISO, presupuesto: model.PRESUPUESTO, observacionCompromiso: model.OBSERVACIONCOMPROMISO, idMunicipioRespuesta: model.IDMUNICIPIORESPUESTA, idUsuario: model.IDUSUARIO).FirstOrDefault();
                            model.ID = datosInsert.id.Value;
                            resultado.estado = datosInsert.estado;
                            resultado.respuesta = datosInsert.respuesta;
                            Insertando = true;
                        }
                        //desde aqui es nuevo
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
                                            resultado = BD.U_RespuestaAccionesDepartamentoUpdate(iD: item.ID, iDPATRESPUESTA: item.ID_PAT_RESPUESTA, aCCION: item.ACCION, aCTIVO: item.ACTIVO).FirstOrDefault();
                                            item.Insertado = false;
                                        }
                                        else
                                        {
                                            resultado = BD.I_RespuestaAccionesDepartamentoInsert(iDPATRESPUESTA: item.ID_PAT_RESPUESTA, aCCION: item.ACCION, aCTIVO: item.ACTIVO).FirstOrDefault();
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
                                            resultado = BD.U_RespuestaProgramaDepartamentoUpdate(iD: item.ID, iD_PAT_RESPUESTA: item.ID_PAT_RESPUESTA, pROGRAMA: item.PROGRAMA, aCTIVO: item.ACTIVO).FirstOrDefault();
                                            item.Insertado = false;
                                        }
                                        else
                                        {
                                            resultado = BD.I_RespuestaProgramaDepartamentoInsert(iD_PAT_RESPUESTA: item.ID_PAT_RESPUESTA, pROGRAMA: item.PROGRAMA, aCTIVO: item.ACTIVO).FirstOrDefault();
                                            item.Insertado = true;
                                        }
                                        if (resultado.estado == 0)
                                        {
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                        if (resultado.estado == 1 || resultado.estado == 2)
                        {
                            dbContextTransaction.Commit();

                            //// Audita la creación o actualización de la respuesta Departamento PAT
                            (new AuditExecuted(Insertando ? Category.CrearRespuestaDepartamentoPAT : Category.EditarRespuestaDepartamentoPAT)).ActionExecutedManual(model);

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
                                        (new AuditExecuted(item.Insertado ? Category.CrearRespuestaDepartamentoAccionesPAT : Category.EditarRespuestaDepartamentoAccionesPAT)).ActionExecutedManual(item);
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
                                        (new AuditExecuted(item.Insertado ? Category.CrearRespuestaDepartamentoProgramaPAT : Category.EditarRespuestaDepartamentoProgramaPAT)).ActionExecutedManual(item);
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

        #region APIS PARA EDICION DE CONSOLIDADO MUNICIPAL- MODAL ACCIONES Y PROGRAMAS

        /// <summary>
        /// Datoses the consolidado acciones programas.
        /// </summary>
        /// <param name="pregunta">The pregunta.</param>
        /// <param name="id">The identifier.</param>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosConsolidadoAccionesProgramas/")]
        public object DatosConsolidadoAccionesProgramas(short pregunta = 0, int id = 0, int idUsuario = 0, byte idTablero = 0)
        {
            GestionMunicipalController clsuMunicipios = new GestionMunicipalController();

            int totalNecesidades = clsuMunicipios.NecesidadesIdentificadasSIGO(idUsuario, pregunta);
            var datosAcciones = clsuMunicipios.AccionesPAT(id, "");
            var datosProgramas = clsuMunicipios.ProgramasPAT(id);

            var objeto = new
            {
                datosAcciones = datosAcciones,
                datosProgramas = datosProgramas
            };

            return objeto;
        }

        #endregion

        #region APIS PARA REPARACION COLECTIVA

        /// <summary>
        /// Cargars the municipios rc.
        /// </summary>
        /// <param name="IdUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_MunicipiosReparacionColectiva_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarMunicipiosRC/")]
        public IEnumerable<C_MunicipiosReparacionColectiva_Result> CargarMunicipiosRC(int IdUsuario = 0, byte idTablero = 0)
        {
            IEnumerable<C_MunicipiosReparacionColectiva_Result> resultado = Enumerable.Empty<C_MunicipiosReparacionColectiva_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_MunicipiosReparacionColectiva(idUsuario: IdUsuario, idTablero: idTablero).Cast<C_MunicipiosReparacionColectiva_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Contars the municipios rc.
        /// </summary>
        /// <param name="idMunicipio">The identifier municipio.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Int32.</returns>
        [HttpGet]
        [Route("api/TableroPat/ContarMunicipiosRC/{idMunicipio},{idTablero}")]
        public int ContarMunicipiosRC(int idMunicipio, byte idTablero)
        {
            int resultado = 0;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ContarTableroDepartamentoReparacionColectiva(idMunicipio: idMunicipio, idTablero: idTablero).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Cargars the tablero departamentos rc.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="numMostrar">The number mostrar.</param>
        /// <param name="idMunicipio">The identifier municipio.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarTableroDepartamentosRC/")]
        public object CargarTableroDepartamentosRC(string sortOrder, Int16 page = 1, Int16 numMostrar = 10, int idMunicipio = 0, byte idTablero = 0)
        {
            var datosRC = TableroDepartamentalRC(sortOrder, page, numMostrar, idMunicipio, idTablero);
            var total = ContarMunicipiosRC(idMunicipio, idTablero);
            var TotalPages = (int)Math.Ceiling(total / (double)numMostrar);
            var objeto = new
            {
                TotalPages = TotalPages,
                total = total,
                datosRC = datosRC,
            };

            return objeto;
        }

        /// <summary>
        /// Tableroes the departamental rc.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="numMostrar">The number mostrar.</param>
        /// <param name="idMunicipio">The identifier municipio.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroDepartamentoReparacionColectiva_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/TableroDepartamentalRC/{sortOrder},{page},{numMostrar},{idMunicipio},{Usuario},{idTablero}")]
        public IEnumerable<C_TableroDepartamentoReparacionColectiva_Result> TableroDepartamentalRC(string sortOrder, Int16 page = 1, Int16 numMostrar = 10, int idMunicipio = 0, byte idTablero = 0)
        {
            IEnumerable<C_TableroDepartamentoReparacionColectiva_Result> resultado = Enumerable.Empty<C_TableroDepartamentoReparacionColectiva_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroDepartamentoReparacionColectiva(page: page, pageSize: numMostrar, idMunicipio: idMunicipio, idTablero: idTablero).Cast<C_TableroDepartamentoReparacionColectiva_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modificars the respuesta departamento rc.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/ModificarRespuestaDepartamentoRC/")]
        public C_AccionesResultado ModificarRespuestaDepartamentoRC(RespuestaPatDepartamentosRC model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            bool Insertando = false;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                using (var dbContextTransaction = BD.Database.BeginTransaction())
                {
                    try
                    {
                        if (model.Id > 0)
                        {
                            resultado = BD.U_RespuestaDepartamentoRCUpdate(id: model.Id, accionDepartamento: model.AccionDepartamento, presupuestoDepartamento: model.PresupuestoDepartamento).FirstOrDefault();
                            Insertando = false;
                        }
                        else
                        {
                            var datosInsert = BD.I_RespuestaDepartamentoRCInsert(idTablero: model.IdTablero, idPreguntaPATReparacionColectiva: model.IdPreguntaReparacionColectiva, accionDepartamento: model.AccionDepartamento, presupuestoDepartamento: model.PresupuestoDepartamento, idMunicipioRespuesta: model.IdMunicipioRespuesta, idUsuario: model.IdUsuario, idRespuestaRCMunicipio: model.IdRespuestaMunicipioRC).FirstOrDefault();
                            model.Id = datosInsert.id.Value;
                            resultado.estado = datosInsert.estado;
                            resultado.respuesta = datosInsert.respuesta;
                            Insertando = true;
                        }
                        if (resultado.estado == 1 || resultado.estado == 2)
                        {
                            dbContextTransaction.Commit();

                            //// Audita la creación o actualización de la respuesta RC Departamento PAT
                            (new AuditExecuted(Insertando ? Category.CrearRespuestaDepartamentoRCPAT : Category.EditarRespuestaDepartamentoRCPAT)).ActionExecutedManual(model);
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

        #region APIS PARA RETORNOS Y REUBICACIONES

        /// <summary>
        /// Cargars the municipios rr.
        /// </summary>
        /// <param name="IdUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_MunicipiosRetornosReubicaciones_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarMunicipiosRR/")]
        public IEnumerable<C_MunicipiosRetornosReubicaciones_Result> CargarMunicipiosRR(int IdUsuario = 0, byte idTablero = 0)
        {
            IEnumerable<C_MunicipiosRetornosReubicaciones_Result> resultado = Enumerable.Empty<C_MunicipiosRetornosReubicaciones_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_MunicipiosRetornosReubicaciones(idUsuario: IdUsuario, idTablero: idTablero).Cast<C_MunicipiosRetornosReubicaciones_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Contars the municipios rr.
        /// </summary>
        /// <param name="idMunicipio">The identifier municipio.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Int32.</returns>
        [HttpGet]
        [Route("api/TableroPat/ContarMunicipiosRR/{idMunicipio},{idTablero}")]
        public int ContarMunicipiosRR(int idMunicipio, byte idTablero)
        {
            int resultado = 0;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ContarTableroDepartamentoRetornosReubicaciones(idMunicipio: idMunicipio, idTablero: idTablero).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }


        /// <summary>
        /// Tableroes the departamental rr.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="numMostrar">The number mostrar.</param>
        /// <param name="idMunicipio">The identifier municipio.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroDepartamentoRetornosReubicaciones_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/TableroDepartamentalRR/{sortOrder},{page},{numMostrar},{idMunicipio},{Usuario},{idTablero}")]
        public IEnumerable<C_TableroDepartamentoRetornosReubicaciones_Result> TableroDepartamentalRR(string sortOrder, Int16 page = 1, Int16 numMostrar = 10, int idMunicipio = 0, byte idTablero = 0)
        {
            IEnumerable<C_TableroDepartamentoRetornosReubicaciones_Result> resultado = Enumerable.Empty<C_TableroDepartamentoRetornosReubicaciones_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroDepartamentoRetornosReubicaciones(page: page, pageSize: numMostrar, idMunicipio: idMunicipio, idTablero: idTablero).Cast<C_TableroDepartamentoRetornosReubicaciones_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Cargars the tablero departamentos rr.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="numMostrar">The number mostrar.</param>
        /// <param name="idMunicipio">The identifier municipio.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarTableroDepartamentosRR/")]
        public object CargarTableroDepartamentosRR(string sortOrder, Int16 page = 1, Int16 numMostrar = 10, int idMunicipio = 0, byte idTablero = 0)
        {
            var datosRR = TableroDepartamentalRR(sortOrder, page, numMostrar, idMunicipio, idTablero);
            var total = ContarMunicipiosRR(idMunicipio, idTablero);
            var TotalPages = (int)Math.Ceiling(total / (double)numMostrar);

            var objeto = new
            {
                TotalPages = TotalPages,
                total = total,
                datosRR = datosRR,
            };

            return objeto;
        }

        /// <summary>
        /// Modificars the respuesta departamento rr.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/ModificarRespuestaDepartamentoRR/")]
        public C_AccionesResultado ModificarRespuestaDepartamentoRR(RespuestaPatDepartamentosRR model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            bool Insertando = false;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                using (var dbContextTransaction = BD.Database.BeginTransaction())
                {
                    try
                    {
                        if (model.IdRespuestaDepartamento > 0)
                        {
                            resultado = BD.U_RespuestaDepartamentoRRUpdate(id: model.IdRespuestaDepartamento, accionDepartamento: model.AccionDepartamento, presupuestoDepartamento: model.PresupuestoDepartamento).FirstOrDefault();
                            Insertando = false;
                        }
                        else
                        {
                            var datosInsert = BD.I_RespuestaDepartamentoRRInsert(idTablero: model.IdTablero, idPreguntaPATRetornoReubicacion: model.IdPreguntaRR, accionDepartamento: model.AccionDepartamento, presupuestoDepartamento: model.PresupuestoDepartamento, idMunicipioRespuesta: model.IdMunicipioRespuesta, idUsuario: model.IdUsuario).FirstOrDefault();
                            model.IdRespuestaDepartamento = datosInsert.id.Value;
                            resultado.estado = datosInsert.estado;
                            resultado.respuesta = datosInsert.respuesta;
                            Insertando = true;
                        }
                        if (resultado.estado == 1 || resultado.estado == 2)
                        {
                            dbContextTransaction.Commit();

                            //// Audita la creación o actualización de la respuesta RR Departamento PAT
                            (new AuditExecuted(Insertando ? Category.CrearRespuestaDepartamentoRRPAT : Category.EditarRespuestaDepartamentoRRPAT)).ActionExecutedManual(model);
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

        /// <summary>
        /// Obteners the identifier usuario.
        /// </summary>
        /// <param name="usuario">The usuario.</param>
        /// <returns>System.Int32.</returns>
        private int ObtenerIdUsuario(string usuario)
        {
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            var modelUsuario = new UsuariosModels { UserName = usuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
            return datosUsuario.FirstOrDefault().Id;
        }
    }
}