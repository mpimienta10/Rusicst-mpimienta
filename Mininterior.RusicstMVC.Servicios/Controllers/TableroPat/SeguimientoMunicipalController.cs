// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 10-10-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-16-2017
// ***********************************************************************
// <copyright file="SeguimientoMunicipalController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************
/// <summary>
/// The TableroPat namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.TableroPat
{
    using Aplicacion.Adjuntos;
    using Aplicacion.Seguridad;
    using ClosedXML.Excel;
    using Mininterior.RusicstMVC.Entidades;
    using RusicstMVC.Servicios.Controllers.Usuarios;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Threading.Tasks;
    using System.Web;
    using System.Web.Http;
    using System.Net.Http.Headers;

    /// <summary>
    /// Class SeguimientoMunicipalController.
    /// </summary>
    public class SeguimientoMunicipalController : ApiController
    {
        #region APIS PARA LA PANTALLA DE LOS TABLEROS DE SEGUIMIENTO COMPLETADOS Y POR COMPLETAR  

        /// <summary>
        /// Listas the tableros seguimiento municipio completados.
        /// </summary>
        /// <returns>IEnumerable&lt;C_TodosTablerosSeguimientoMunicipiosCompletados_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/ListaTablerosSeguimientoMunicipioCompletados/{Usuario}")]
        public IEnumerable<C_TodosTablerosSeguimientoMunicipiosCompletados_Result> ListaTablerosSeguimientoMunicipioCompletados(string Usuario = "")
        {
            IEnumerable<C_TodosTablerosSeguimientoMunicipiosCompletados_Result> resultado = Enumerable.Empty<C_TodosTablerosSeguimientoMunicipiosCompletados_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    IEnumerable<C_Usuario_Result> ListaUsuarios = BD.C_Usuario(null, null, null, null, null, Usuario, null).Cast<C_Usuario_Result>().ToList();
                    C_Usuario_Result model = ListaUsuarios.FirstOrDefault();
                    resultado = BD.C_TodosTablerosSeguimientoMunicipiosCompletados(idUsuario: model.Id).Cast<C_TodosTablerosSeguimientoMunicipiosCompletados_Result>().ToList();
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
        /// <returns>IEnumerable&lt;C_TodosTablerosSeguimientoMunicipiosPorCompletar_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/ListaTablerosSeguimientoMunicipioPorCompletar/{Usuario}")]
        public IEnumerable<C_TodosTablerosSeguimientoMunicipiosPorCompletar_Result> ListaTablerosSeguimientoMunicipioPorCompletar(string Usuario = "")
        {
            IEnumerable<C_TodosTablerosSeguimientoMunicipiosPorCompletar_Result> resultado = Enumerable.Empty<C_TodosTablerosSeguimientoMunicipiosPorCompletar_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    IEnumerable<C_Usuario_Result> ListaUsuarios = BD.C_Usuario(null, null, null, null, null, Usuario, null).Cast<C_Usuario_Result>().ToList();
                    C_Usuario_Result model = ListaUsuarios.FirstOrDefault();
                    resultado = BD.C_TodosTablerosSeguimientoMunicipiosPorCompletar(idUsuario: model.Id).Cast<C_TodosTablerosSeguimientoMunicipiosPorCompletar_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion

        #region APIS PARA PANTALLA INICIAL DE SEGUIMIENTO MUNICIPIOS

        /// <summary>
        /// Gets the number seguimiento tablero.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="nivel">The nivel.</param>
        /// <returns>IEnumerable&lt;C_NumeroSeguimiento_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/SeguimientoMunicipios/GetNumSeguimientoTablero/")]
        public IEnumerable<C_NumeroSeguimiento_Result> GetNumSeguimientoTablero(byte idTablero, int nivel)
        {
            IEnumerable<C_NumeroSeguimiento_Result> resultado = Enumerable.Empty<C_NumeroSeguimiento_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_NumeroSeguimiento(idTablero: idTablero, nivel: nivel).Cast<C_NumeroSeguimiento_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the tablero seguimiento vigencia.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="nivel">The nivel.</param>
        /// <returns>IEnumerable&lt;C_TableroSeguimientoVigencia_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/SeguimientoMunicipios/GetTableroSeguimientoVigencia/")]
        public IEnumerable<C_TableroSeguimientoVigencia_Result> GetTableroSeguimientoVigencia(byte idTablero, int nivel)
        {
            IEnumerable<C_TableroSeguimientoVigencia_Result> resultado = Enumerable.Empty<C_TableroSeguimientoVigencia_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroSeguimientoVigencia(idTablero: idTablero, nivel: nivel).Cast<C_TableroSeguimientoVigencia_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the tablero seguimiento avance.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroSeguimientoMunicipioAvance_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/SeguimientoMunicipios/GetTableroSeguimientoAvance/")]
        public IEnumerable<C_TableroSeguimientoMunicipioAvance_Result> GetTableroSeguimientoAvance(int idUsuario, byte idTablero)
        {
            IEnumerable<C_TableroSeguimientoMunicipioAvance_Result> resultado = Enumerable.Empty<C_TableroSeguimientoMunicipioAvance_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroSeguimientoMunicipioAvance(idUsuario: idUsuario, idTablero: idTablero).Cast<C_TableroSeguimientoMunicipioAvance_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the tablero seguimiento.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <returns>IEnumerable&lt;C_TableroSeguimientoMunicipio_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/SeguimientoMunicipios/GetTableroSeguimiento/")]
        public IEnumerable<C_TableroSeguimientoMunicipio_Result> GetTableroSeguimiento(int idUsuario, byte idTablero, int idDerecho)
        {
            IEnumerable<C_TableroSeguimientoMunicipio_Result> resultado = Enumerable.Empty<C_TableroSeguimientoMunicipio_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroSeguimientoMunicipio(idDerecho: idDerecho, idTablero: idTablero, idUsuario: idUsuario).Cast<C_TableroSeguimientoMunicipio_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the tablero seguimiento rc.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <returns>IEnumerable&lt;C_TableroSeguimientoMunicipioReparacionColectiva_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/SeguimientoMunicipios/GetTableroSeguimientoRC/")]
        public IEnumerable<C_TableroSeguimientoMunicipioReparacionColectiva_Result> GetTableroSeguimientoRC(int idUsuario, byte idTablero, int idDerecho)
        {
            IEnumerable<C_TableroSeguimientoMunicipioReparacionColectiva_Result> resultado = Enumerable.Empty<C_TableroSeguimientoMunicipioReparacionColectiva_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    if (idDerecho == 6)//Reparación Integral
                    {
                        resultado = BD.C_TableroSeguimientoMunicipioReparacionColectiva(idTablero: idTablero, idUsuario: idUsuario).Cast<C_TableroSeguimientoMunicipioReparacionColectiva_Result>().ToList();
                        
                        string directorio = "";
                        
                        foreach (var item in resultado)
                        {
                            if(!string.IsNullOrEmpty(item.NombreAdjunto))
                            {
                                directorio = Path.Combine(Archivo.pathPATFiles, idUsuario.ToString(), item.IdTablero.ToString(), "RC", item.IdPregunta.ToString(), item.NombreAdjunto);

                                if (!Archivo.ExisteArchivoShared(directorio))
                                {
                                    item.NombreAdjunto = "";
                                }
                            }                            
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
        /// Gets the tablero seguimiento rr.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <returns>IEnumerable&lt;C_TableroSeguimientoMunicipioRetornosReubicaciones_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/SeguimientoMunicipios/GetTableroSeguimientoRR/")]
        public IEnumerable<C_TableroSeguimientoMunicipioRetornosReubicaciones_Result> GetTableroSeguimientoRR(int idUsuario, byte idTablero, int idDerecho)
        {
            IEnumerable<C_TableroSeguimientoMunicipioRetornosReubicaciones_Result> resultado = Enumerable.Empty<C_TableroSeguimientoMunicipioRetornosReubicaciones_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    if (idDerecho == 6)//Reparación Integral
                    {
                        resultado = BD.C_TableroSeguimientoMunicipioRetornosReubicaciones(idTablero: idTablero, idUsuario: idUsuario).Cast<C_TableroSeguimientoMunicipioRetornosReubicaciones_Result>().ToList();

                        string directorio = "";

                        foreach (var item in resultado)
                        {
                            if (!string.IsNullOrEmpty(item.NombreAdjunto))
                            {
                                directorio = Path.Combine(Archivo.pathPATFiles, idUsuario.ToString(), item.IdTablero.ToString(), "RR", item.Id.ToString(), item.NombreAdjunto);

                                if (!Archivo.ExisteArchivoShared(directorio))
                                {
                                    item.NombreAdjunto = "";
                                }
                            }
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
        /// Gets the tablero seguimiento od.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_TableroSeguimientoMunicipioOtrosDerechos_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/SeguimientoMunicipios/GetTableroSeguimientoOD/")]
        public IEnumerable<C_TableroSeguimientoMunicipioOtrosDerechos_Result> GetTableroSeguimientoOD(int idUsuario, byte idTablero)
        {
            IEnumerable<C_TableroSeguimientoMunicipioOtrosDerechos_Result> resultado = Enumerable.Empty<C_TableroSeguimientoMunicipioOtrosDerechos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TableroSeguimientoMunicipioOtrosDerechos(idTablero: idTablero, idUsuario: idUsuario).Cast<C_TableroSeguimientoMunicipioOtrosDerechos_Result>().ToList();

                    string directorio = "";

                    foreach (var item in resultado)
                    {
                        if (!string.IsNullOrEmpty(item.NombreAdjunto))
                        {
                            directorio = Path.Combine(Archivo.pathPATFiles, idUsuario.ToString(), item.IdTablero.ToString(), "OD", item.IdSeguimiento.ToString(), item.NombreAdjunto);

                            if (!Archivo.ExisteArchivoShared(directorio))
                            {
                                item.NombreAdjunto = "";
                            }
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

        [HttpGet]
        [Route("api/TableroPat/SeguimientoMunicipios/GetPrecargueEntidadesNacionales/")]
        public IEnumerable<C_PrecargueEntidadesNacionales_Result> GetPrecargueEntidadesNacionales(int idDerecho, byte idTablero, int idMunicipio)
        {
            IEnumerable<C_PrecargueEntidadesNacionales_Result> resultado = Enumerable.Empty<C_PrecargueEntidadesNacionales_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_PrecargueEntidadesNacionales(idDerecho: idDerecho, idTablero: idTablero, idMunicipio: idMunicipio).Cast<C_PrecargueEntidadesNacionales_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        [HttpGet]
        [Route("api/TableroPat/SeguimientoMunicipios/DatosSeguimientoDepartamentoPorMunicipio/")]
        public C_SeguimientoDepartamentoPorMunicipio_Result DatosSeguimientoDepartamentoPorMunicipio(int idPregunta, int idMunicipio)
        {
            C_SeguimientoDepartamentoPorMunicipio_Result resultado = new C_SeguimientoDepartamentoPorMunicipio_Result();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_SeguimientoDepartamentoPorMunicipio(idMunicipio: idMunicipio, idPregunta: idPregunta).Cast<C_SeguimientoDepartamentoPorMunicipio_Result>().FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        [HttpGet]
        [Route("api/TableroPat/SeguimientoMunicipios/DatosSeguimientoNacionalPorMunicipio/")]
        public C_SeguimientoNacionalPorMunicipio_Result DatosSeguimientoNacionalPorMunicipio(int idPregunta, int idMunicipio)
        {
            C_SeguimientoNacionalPorMunicipio_Result resultado = new C_SeguimientoNacionalPorMunicipio_Result();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_SeguimientoNacionalPorMunicipio(idMunicipio: idMunicipio, idPregunta: idPregunta).Cast<C_SeguimientoNacionalPorMunicipio_Result>().FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        [HttpGet]
        [Route("api/TableroPat/SeguimientoMunicipios/DatosPreguntaPATPrecargueEntidadesNacionales/")]
        public List<C_PreguntaPATPrecargueEntidadesNacionales_Result> DatosPreguntaPATPrecargueEntidadesNacionales(short idPregunta, int idMunicipio)
        {
            List<C_PreguntaPATPrecargueEntidadesNacionales_Result> resultado = new List<C_PreguntaPATPrecargueEntidadesNacionales_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_PreguntaPATPrecargueEntidadesNacionales(idMunicipio: idMunicipio, idPregunta: idPregunta).Cast<C_PreguntaPATPrecargueEntidadesNacionales_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Cargars the tablero seguimiento.
        /// </summary>
        /// <param name="sortOrder">The sort order.</param>
        /// <param name="page">The page.</param>
        /// <param name="numMostrar">The number mostrar.</param>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <param name="Usuario">The usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarTableroSeguimiento/{sortOrder},{page},{numMostrar},{idDerecho},{Usuario},{idTablero}")]
        public object CargarTableroSeguimiento(string sortOrder, Int16 page = 1, Int16 numMostrar = 10, int idDerecho = 0, string Usuario = "", byte idTablero = 0)
        {
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            GestionMunicipalController clsuMunicipios = new GestionMunicipalController();
            HabilitarReportesController clsHabilitar = new HabilitarReportesController();
            AdministracionController clsAdmin = new AdministracionController();

            var modelUsuario = new UsuariosModels { UserName = Usuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
            int IdUsuario = datosUsuario.FirstOrDefault().Id;
            int totalItems = 50;
            int totalItemsRC = 50;
            int totalItemsRR = 50;
            var TotalPages = (int)Math.Ceiling(totalItems / (double)numMostrar);
            var TotalPagesRC = (int)Math.Ceiling(totalItemsRC / (double)numMostrar);
            var TotalPagesRR = (int)Math.Ceiling(totalItemsRR / (double)numMostrar);

            PermisoUsuarioEncuestaModels modelHabilitarExtension = new PermisoUsuarioEncuestaModels();
            modelHabilitarExtension.IdUsuario = IdUsuario;
            modelHabilitarExtension.IdEncuesta = idTablero;
            modelHabilitarExtension.IdTipoTramite = 4; // 4 para el seguimiento 1 

            int? numSeguimiento = GetNumSeguimientoTablero(idTablero, 3).Select(a => a.NumeroSeguimiento).FirstOrDefault();
            bool activo = numSeguimiento.HasValue;

            //Si se envio el tablero se debe inactivar para guardar informacion
            //bool tableroEnviado = clsuMunicipios.ValidarEnvioTableroPat(IdUsuario, idTablero, "SM" + numSeguimiento);
            //if (activo == true && tableroEnviado == true)
            //{
            //    activo = false;
            //}
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


            var avance = GetTableroSeguimientoAvance(IdUsuario, idTablero);
            var datos1 = GetTableroSeguimiento(IdUsuario, idTablero, idDerecho);
            var derechos = clsuMunicipios.Derechos(idTablero, IdUsuario, false);
            var vigencia = GetTableroSeguimientoVigencia(idTablero, 3);
            var datos4 = datosUsuario;
            var datosRC = GetTableroSeguimientoRC(IdUsuario, idTablero, idDerecho);
            var datosRR = GetTableroSeguimientoRR(IdUsuario, idTablero, idDerecho);
            var datosOD = GetTableroSeguimientoOD(IdUsuario, idTablero);
            var InformacionNacional = GetPrecargueEntidadesNacionales(idDerecho, idTablero, (int)(datosUsuario.FirstOrDefault().IdMunicipio));

            //validacion del envio tablero PAT seguimiento
            Boolean ActivoEnvioPATSeguimiento = false;
            if (activo)
            {
                var datostablero = clsAdmin.ListaTodosTableros().Where(s => s.IdTablero == idTablero && s.Nivel == 3).FirstOrDefault();
                if (datostablero != null)
                {
                    ActivoEnvioPATSeguimiento = datostablero.ActivoEnvioPATSeguimiento == null ? false : Convert.ToBoolean(datostablero.ActivoEnvioPATSeguimiento);
                }
            }
            var objeto = new
            {
                activo = activo,
                numSeguimiento = numSeguimiento,
                datos = avance, //derechos
                datos1 = datos1,
                derechos = derechos,
                vigencia = vigencia,
                datos4 = datos4,
                datosRC = datosRC,
                datoRR = datosRR,
                datosOD = datosOD,
                idTablero = idTablero,
                totalItems = totalItems,
                TotalPages = TotalPages,
                totalItemsRC = totalItemsRC,
                TotalPagesRC = TotalPagesRC,
                totalItemsRR = totalItemsRR,
                TotalPagesRR = TotalPagesRR,
                InformacionNacional = InformacionNacional,
                ActivoEnvioPATSeguimiento = ActivoEnvioPATSeguimiento
            };

            return objeto;
        }

        /// <summary>
        /// Datoses the excel.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>HttpResponseMessage.</returns>
        [HttpGet]
        [Route("api/TableroPat/SeguimientoMunicipios/DatosExcel/")]
        public HttpResponseMessage DatosExcel(int idUsuario, byte idTablero)
        {
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            var modelUsuario = new UsuariosModels { Id = idUsuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
            int idMunicipio = (int)datosUsuario.FirstOrDefault().IdMunicipio;

            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);
            IEnumerable<C_DatosExcelSeguimientoAlcaldias_Result> data = Enumerable.Empty<C_DatosExcelSeguimientoAlcaldias_Result>();
            IEnumerable<C_TableroSeguimientoMunicipioOtrosDerechos_Result> data2 = Enumerable.Empty<C_TableroSeguimientoMunicipioOtrosDerechos_Result>();
            IEnumerable<C_DatosExcel_PrecargueEntidadesNacionales_Result> dataMuniciposPrecargue = Enumerable.Empty<C_DatosExcel_PrecargueEntidadesNacionales_Result>();
            IEnumerable<C_DatosExcelSeguimientoAlcaldiasReparacionColectiva_Result> dataMunicipiosRC = Enumerable.Empty<C_DatosExcelSeguimientoAlcaldiasReparacionColectiva_Result>();
            IEnumerable<C_DatosExcelSeguimientoAlcaldiasRetornosReubicaciones_Result> dataMunicipiosRR = Enumerable.Empty<C_DatosExcelSeguimientoAlcaldiasRetornosReubicaciones_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    data = BD.C_DatosExcelSeguimientoAlcaldias(idUsuario: idUsuario, idTablero: idTablero).Cast<C_DatosExcelSeguimientoAlcaldias_Result>().ToList();
                    data2 = GetTableroSeguimientoOD(idUsuario, idTablero);
                    dataMunicipiosRC = BD.C_DatosExcelSeguimientoAlcaldiasReparacionColectiva(idUsuario, idTablero).Cast<C_DatosExcelSeguimientoAlcaldiasReparacionColectiva_Result>().ToList();
                    dataMunicipiosRR = BD.C_DatosExcelSeguimientoAlcaldiasRetornosReubicaciones(idUsuario, idTablero).Cast<C_DatosExcelSeguimientoAlcaldiasRetornosReubicaciones_Result>().ToList();
                    dataMuniciposPrecargue = BD.C_DatosExcel_PrecargueEntidadesNacionales(idTablero, idMunicipio).Cast<C_DatosExcel_PrecargueEntidadesNacionales_Result>().ToList();
                }

                // Create the workbook
                var workbook = new XLWorkbook();
                var ws = workbook.Worksheets.Add("Reporte Seguimiento Tablero PAT");

                //Crear libro
                #region Encabezado columnas

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

                //ws.Cell(1, 5).Value = "Pregunta Compromiso";
                //ws.Column(5).AdjustToContents();
                //ws.Range(1, 5, 2, 5).Merge();
                //ws.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                //ws.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

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

                ws.Cell(1, 14).Value = "Seguimiento Alcaldía";
                ws.Column(14).AdjustToContents();
                ws.Range(1, 14, 1, 23).Merge();
                ws.Cell(1, 14).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 14).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                //seguimiento cantidad alcaldias
                ws.Cell(2, 14).Value = "Compromiso 1º semestre";
                ws.Column(14).AdjustToContents();
                ws.Cell(2, 14).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 14).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 15).Value = "Compromiso 2º semestre";
                ws.Column(15).AdjustToContents();
                ws.Cell(2, 15).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 15).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 16).Value = "Avance Cantidad";
                ws.Column(16).AdjustToContents();
                ws.Cell(2, 16).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 16).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                //seguimiento presupuesto alcaldias
                ws.Cell(2, 17).Value = "Presupuesto 1º semestre";
                ws.Column(17).AdjustToContents();
                ws.Cell(2, 17).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 17).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 18).Value = "Presupuesto 2º semestre";
                ws.Column(18).AdjustToContents();
                ws.Cell(2, 18).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 18).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 19).Value = "Avance Presupuesto";
                ws.Column(19).AdjustToContents();
                ws.Cell(2, 19).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 19).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 20).Value = "Observaciones 1º";
                ws.Column(20).AdjustToContents();
                ws.Cell(2, 20).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 20).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 21).Value = "Observaciones 2º";
                ws.Column(21).AdjustToContents();
                ws.Cell(2, 21).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 21).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 22).Value = "Programas 1º";
                ws.Column(22).AdjustToContents();
                ws.Cell(2, 22).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 22).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 23).Value = "Programas 2º";
                ws.Column(23).AdjustToContents();
                ws.Cell(2, 23).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 23).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                //-----------------
                ws.Cell(1, 24).Value = "Seguimiento Gobernación";
                ws.Column(24).AdjustToContents();
                ws.Range(1, 24, 1, 33).Merge();
                ws.Cell(1, 24).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 24).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 24).Value = "Compromiso 1º semestre";
                ws.Column(24).AdjustToContents();
                ws.Cell(2, 24).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 24).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 25).Value = "Compromiso 2º semestre";
                ws.Column(25).AdjustToContents();
                ws.Cell(2, 25).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 25).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 26).Value = "Avance Cantidad";
                ws.Column(26).AdjustToContents();
                ws.Cell(2, 26).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 26).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 27).Value = "Presupuesto 1º semestre";
                ws.Column(27).AdjustToContents();
                ws.Cell(2, 27).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 27).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 28).Value = "Presupuesto 2º semestre";
                ws.Column(28).AdjustToContents();
                ws.Cell(2, 28).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 28).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 29).Value = "Avance Presupuesto";
                ws.Column(29).AdjustToContents();
                ws.Cell(2, 29).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 29).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 30).Value = "Observaciones 1º";
                ws.Column(30).AdjustToContents();
                ws.Cell(2, 30).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 30).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 31).Value = "Observaciones 2º";
                ws.Column(31).AdjustToContents();
                ws.Cell(2, 31).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 31).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 32).Value = "Programas 1º";
                ws.Column(32).AdjustToContents();
                ws.Cell(2, 32).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 32).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 33).Value = "Programas 2º";
                ws.Column(33).AdjustToContents();
                ws.Cell(2, 33).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 33).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(1, 34).Value = "Planeación Definitivo";
                ws.Column(3).AdjustToContents();
                ws.Range(1, 34, 1, 36).Merge();
                ws.Cell(1, 34).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(1, 34).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 34).Value = "Compromiso Definitivo";
                ws.Column(34).AdjustToContents();
                ws.Cell(2, 34).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 34).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Cell(2, 35).Value = "Presupuesto Definitivo";
                ws.Column(35).AdjustToContents();
                ws.Cell(2, 35).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 35).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;


                ws.Cell(2, 36).Value = "Observación Ajuste";
                ws.Column(36).AdjustToContents();
                ws.Cell(2, 36).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws.Cell(2, 36).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws.Range(1, 1, 1, 36).Style.Font.Bold = true;
                ws.Range(2, 1, 2, 36).Style.Font.Bold = true;

                #endregion

                #region Data Excel

                int fila = 3;

                foreach (var item in data)
                {
                    ws.Cell(fila, 1).Value = item.Derecho;
                    ws.Cell(fila, 2).Value = item.Componente;
                    ws.Cell(fila, 3).Value = item.Medida;
                    ws.Cell(fila, 4).Value = item.Pregunta;
                    ws.Cell(fila, 5).Value = item.UnidadNecesidad;
                    ws.Cell(fila, 6).Value = item.RespuestaNecesidad;
                    ws.Cell(fila, 7).Value = item.ObservacionNecesidad;
                    ws.Cell(fila, 8).Value = item.UnidadNecesidad;
                    ws.Cell(fila, 9).Value = item.RespuestaCompromiso;
                    ws.Cell(fila, 10).Value = item.ObservacionCompromiso;

                    ws.Cell(fila, 11).Value = item.PrespuestaPresupuesto;
                    ws.Cell(fila, 11).Style.NumberFormat.Format = "$ #,##0";

                    ws.Cell(fila, 12).Value = item.Accion;
                    ws.Cell(fila, 13).Value = item.Programa;

                    ws.Cell(fila, 14).Value = item.CantidadPrimerSeguimientoAlcaldia;
                    ws.Cell(fila, 15).Value = item.CantidadSegundoSeguimientoAlcaldia;
                    ws.Cell(fila, 16).Value = item.AvanceCantidadAlcaldia;
                    ws.Cell(fila, 17).Value = item.PresupuestoPrimerSeguimientoAlcaldia;
                    ws.Cell(fila, 17).Style.NumberFormat.Format = "$ #,##0";
                    ws.Cell(fila, 18).Value = item.PresupuestoSegundoSeguimientoAlcaldia;
                    ws.Cell(fila, 18).Style.NumberFormat.Format = "$ #,##0";
                    ws.Cell(fila, 19).Value = item.AvancePresupuestoAlcaldia;
                    ws.Cell(fila, 19).Style.NumberFormat.Format = "$ #,##0";
                    ws.Cell(fila, 20).Value = item.ObservacionesSeguimientoAlcaldia;
                    ws.Cell(fila, 21).Value = item.ObservacionesSegundo;
                    ws.Cell(fila, 22).Value = item.ProgramasPrimero;
                    ws.Cell(fila, 23).Value = item.ProgramasSegundo;

                    ws.Cell(fila, 24).Value = item.CantidadPrimerSeguimientoGobernacion;
                    ws.Cell(fila, 25).Value = item.CantidadSegundoSeguimientoGobernacion;
                    ws.Cell(fila, 26).Value = item.AvanceCantidadGobernacion;
                    ws.Cell(fila, 27).Value = item.PresupuestoPrimerSeguimientoGobernacion;
                    ws.Cell(fila, 27).Style.NumberFormat.Format = "$ #,##0";
                    ws.Cell(fila, 28).Value = item.PresupuestoSegundoSeguimientoGobernacion;
                    ws.Cell(fila, 28).Style.NumberFormat.Format = "$ #,##0";
                    ws.Cell(fila, 29).Value = item.AvancePresupuestoGobernacion;
                    ws.Cell(fila, 29).Style.NumberFormat.Format = "$ #,##0";
                    ws.Cell(fila, 30).Value = item.ObservacionesSeguimientoGobernacion;
                    ws.Cell(fila, 31).Value = item.ObservacionesSegundoSeguimientoGobernacion;
                    ws.Cell(fila, 32).Value = item.ProgramasPrimeroSeguimientoGobernacion;
                    ws.Cell(fila, 33).Value = item.ProgramasSegundoSeguimientoGobernacion;
                    ws.Cell(fila, 34).Value = item.CompromisoDefinitivo;
                    ws.Cell(fila, 35).Value = item.PresupuestoDefinitivo;
                    ws.Cell(fila, 35).Style.NumberFormat.Format = "$ #,##0";
                    ws.Cell(fila, 36).Value = item.ObservacionesDefinitivo;

                    fila++;
                }

                ws.Range(1, 1, fila, 36).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws.Range(1, 1, fila, 36).Style.Border.OutsideBorderColor = XLColor.Black;

                ws.Range(1, 1, fila, 36).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws.Range(1, 1, fila, 36).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion

                //HOja 2 - Otros derechos

                var ws2 = workbook.Worksheets.Add("Seguimiento Otros Derechos");

                #region Encabezado Columnas Hoja 2

                ws2.Cell(1, 1).Value = "Derecho";
                ws2.Column(1).AdjustToContents();
                ws2.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 2).Value = "Componente";
                ws2.Column(2).AdjustToContents();
                ws2.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 3).Value = "Medida";
                ws2.Column(3).AdjustToContents();
                ws2.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 4).Value = "Cantidad";
                ws2.Column(4).AdjustToContents();
                ws2.Cell(1, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 5).Value = "Programa";
                ws2.Column(5).AdjustToContents();
                ws2.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 6).Value = "Acción";
                ws2.Column(6).AdjustToContents();
                ws2.Cell(1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 7).Value = "Unidad";
                ws2.Column(7).AdjustToContents();
                ws2.Cell(1, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 8).Value = "Valor";
                ws2.Column(8).AdjustToContents();
                ws2.Cell(1, 8).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 8).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws2.Cell(1, 9).Value = "Observaciones";
                ws2.Column(9).AdjustToContents();
                ws2.Cell(1, 9).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws2.Cell(1, 9).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                #endregion

                #region data hoja 2

                int fila2 = 2;

                foreach (var item in data2)
                {
                    ws2.Cell(fila2, 1).Value = item.Derecho;
                    ws2.Cell(fila2, 2).Value = item.Componente;
                    ws2.Cell(fila2, 3).Value = item.Medida;
                    ws2.Cell(fila2, 4).Value = item.NumSeguimiento;
                    ws2.Cell(fila2, 5).Value = item.Programa;
                    ws2.Cell(fila2, 6).Value = item.Accion;
                    ws2.Cell(fila2, 7).Value = item.Unidad;

                    ws2.Cell(fila2, 8).Value = item.Presupuesto;
                    ws2.Cell(fila2, 8).Style.NumberFormat.Format = "$ #,##0";

                    ws2.Cell(fila2, 9).Value = item.Observaciones;

                    fila2++;
                }

                ws2.Range(1, 1, fila2, 9).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws2.Range(1, 1, fila2, 9).Style.Border.OutsideBorderColor = XLColor.Black;

                ws2.Range(1, 1, fila2, 9).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws2.Range(1, 1, fila2, 9).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion



                ////==========================
                //// Reparación Colectiva
                ////==========================
                var wsrc = workbook.Worksheets.Add("Reparaciones Colectivas");

                #region Encabezado columnas Reparación Colectiva

                wsrc.Cell(1, 1).Value = "Código Dane";
                wsrc.Column(1).AdjustToContents();
                wsrc.Range(1, 1, 2, 1).Merge();
                wsrc.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                wsrc.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                wsrc.Cell(1, 2).Value = "Municipio";
                wsrc.Column(2).AdjustToContents();
                wsrc.Range(1, 2, 2, 2).Merge();
                wsrc.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                wsrc.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                wsrc.Cell(1, 3).Value = "Sujeto";
                wsrc.Column(3).AdjustToContents();
                wsrc.Range(1, 3, 2, 3).Merge();
                wsrc.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                wsrc.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                wsrc.Cell(1, 4).Value = "Medida Reparacion Colectiva";
                wsrc.Column(4).AdjustToContents();
                wsrc.Range(1, 4, 2, 4).Merge();
                wsrc.Cell(1, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                wsrc.Cell(1, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                wsrc.Cell(1, 5).Value = "Medida";
                wsrc.Column(5).AdjustToContents();
                wsrc.Range(1, 5, 2, 5).Merge();
                wsrc.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                wsrc.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                wsrc.Cell(1, 6).Value = "Avance 1º Semestre";
                wsrc.Column(6).AdjustToContents();
                wsrc.Range(1, 6, 2, 6).Merge();
                wsrc.Cell(1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                wsrc.Cell(1, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                wsrc.Cell(1, 7).Value = "Avance 2º Semestre";
                wsrc.Column(7).AdjustToContents();
                wsrc.Range(1, 7, 2, 7).Merge();
                wsrc.Cell(1, 7).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                wsrc.Cell(1, 7).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                wsrc.Range(1, 1, 1, 7).Style.Font.Bold = true;

                #endregion

                #region Data Excel

                int filarc = 3;

                foreach (var item in dataMunicipiosRC)
                {
                    wsrc.Cell(filarc, 1).Value = item.DaneMunicipio;
                    wsrc.Cell(filarc, 2).Value = item.Municipio;
                    wsrc.Cell(filarc, 3).Value = item.Sujeto;
                    wsrc.Cell(filarc, 4).Value = item.MedidaReparacionColectiva;
                    wsrc.Cell(filarc, 5).Value = item.Medida;
                    wsrc.Cell(filarc, 6).Value = item.AvancePrimer;
                    wsrc.Cell(filarc, 7).Value = item.AvanceSegundo;
                    filarc++;
                }

                wsrc.Range(1, 1, filarc, 7).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                wsrc.Range(1, 1, filarc, 7).Style.Border.OutsideBorderColor = XLColor.Black;

                wsrc.Range(1, 1, filarc, 7).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                wsrc.Range(1, 1, filarc, 7).Style.Border.InsideBorderColor = XLColor.Black;

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

                ws3.Cell(1, 8).Value = "Ubicacion";
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

                ws3.Cell(1, 12).Value = "Avance 1º Semestre";
                ws3.Column(12).AdjustToContents();
                ws3.Cell(1, 12).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 12).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Cell(1, 13).Value = "Avance 2º Semestre";
                ws3.Column(13).AdjustToContents();
                ws3.Cell(1, 13).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws3.Cell(1, 13).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws3.Range(1, 1, 1, 13).Style.Font.Bold = true;

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
                    ws3.Cell(fila3, 12).Value = item.AvancePrimer;
                    ws3.Cell(fila3, 13).Value = item.AvanceSegundo;
                    fila3++;
                }

                ws3.Range(1, 1, fila3, 13).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws3.Range(1, 1, fila3, 13).Style.Border.OutsideBorderColor = XLColor.Black;

                ws3.Range(1, 1, fila3, 13).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws3.Range(1, 1, fila3, 13).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion




                ////===========================
                //// Informacion de entidades nacioanles
                ////===========================
                var ws4 = workbook.Worksheets.Add("Info. Entidades Nacionales");

                #region Encabezado columnas Informacion Entidades Nacionales

                ws4.Cell(1, 1).Value = "Derecho";
                ws4.Column(1).AdjustToContents();
                ws4.Cell(1, 1).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 1).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 2).Value = "Componente";
                ws4.Column(2).AdjustToContents();
                ws4.Cell(1, 2).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 2).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 3).Value = "Medida";
                ws4.Column(3).AdjustToContents();
                ws4.Cell(1, 3).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 3).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 4).Value = "Necesidad/Programa";
                ws4.Column(4).AdjustToContents();
                ws4.Cell(1, 4).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 4).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 5).Value = "Entidad del Orden Nacional";
                ws4.Column(5).AdjustToContents();
                ws4.Cell(1, 5).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 5).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Cell(1, 6).Value = "Cantidad Ejecutada";
                ws4.Column(6).AdjustToContents();
                ws4.Cell(1, 6).Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
                ws4.Cell(1, 6).Style.Alignment.Vertical = XLAlignmentVerticalValues.Center;

                ws4.Range(1, 1, 1, 6).Style.Font.Bold = true;

                #endregion

                #region Data Excel Hoja 4

                int fila4 = 2;

                foreach (var item in dataMuniciposPrecargue)
                {
                    ws4.Cell(fila4, 1).Value = item.Derecho;
                    ws4.Cell(fila4, 2).Value = item.Componente;
                    ws4.Cell(fila4, 3).Value = item.Medida;
                    ws4.Cell(fila4, 4).Value = item.Programa;
                    ws4.Cell(fila4, 5).Value = item.EntidadNacional;
                    ws4.Cell(fila4, 6).Value = item.CantidadEjecutada;
                    ws4.Cell(fila4, 6).Style.NumberFormat.Format = " #,##0";

                    fila4++;
                }

                ws4.Range(1, 1, fila4, 6).Style.Border.OutsideBorder = XLBorderStyleValues.Thin;
                ws4.Range(1, 1, fila4, 6).Style.Border.OutsideBorderColor = XLColor.Black;

                ws4.Range(1, 1, fila4, 6).Style.Border.InsideBorder = XLBorderStyleValues.Thin;
                ws4.Range(1, 1, fila4, 6).Style.Border.InsideBorderColor = XLColor.Black;

                #endregion
                var finalfilename = Path.Combine(@"c:\Temp", "Reporte_Municipal_Seguimiento_Tablero_PAT");
                var filename = "Reporte_Municipal_Seguimiento_Tablero_PAT.xlsx";
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

        #region APIS PARA EL MODAL DE DERECHOS DE MUNICIPIOS

        /// <summary>
        /// Contars the necesidades identificadas seguimiento.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <returns>System.Int32.</returns>
        [HttpGet]
        [Route("api/TableroPat/ContarNecesidadesIdentificadasSeguimiento/")]
        public int ContarNecesidadesIdentificadasSeguimiento(int idUsuario, short idPregunta)
        {
            int resultado = 0;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_NecesidadesIdentificadasSeguimiento(idUsuario: idUsuario, idPregunta: idPregunta).FirstOrDefault().Value;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the tablero seguimiento detalle.
        /// </summary>
        /// <param name="idUsuario">The identifier usuario.</param>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <returns>IEnumerable&lt;C_datosRespuestaSeguimientoMunicipio_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetTableroSeguimientoDetalle/")]
        public IEnumerable<C_datosRespuestaSeguimientoMunicipio_Result> GetTableroSeguimientoDetalle(int idUsuario, short idPregunta, int numseguimiento)
        {
            IEnumerable<C_datosRespuestaSeguimientoMunicipio_Result> resultado = Enumerable.Empty<C_datosRespuestaSeguimientoMunicipio_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    string directorio = "";

                    resultado = BD.C_datosRespuestaSeguimientoMunicipio(idPregunta: idPregunta, idUsuario: idUsuario).Cast<C_datosRespuestaSeguimientoMunicipio_Result>().ToList();

                    foreach(var item in resultado)
                    {
                        directorio = Path.Combine(Archivo.pathPATFiles, idUsuario.ToString(), item.IdTablero.ToString(), numseguimiento == 1 ? "D" : "D2", idPregunta.ToString(), numseguimiento == 1 ? item.AdjuntoSeguimiento : item.NombreAdjuntoSegundo);

                        if(!Archivo.ExisteArchivoShared(directorio))
                        {
                            if(numseguimiento == 1)
                            {
                                item.AdjuntoSeguimiento = "";
                            } else
                            {
                                item.NombreAdjuntoSegundo = "";
                            }
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


        [HttpGet]
        [Route("api/TableroPat/GetProgramasSeguimientoSIGO/")]
        public List<C_ProgramasSeguimientoSIGO_Result> GetProgramasSeguimientoSIGO(int idTablero, int numeroSeguimiento, int nivel, int divipola, int idDerecho, short idPregunta)
        {
            List<C_ProgramasSeguimientoSIGO_Result> programasSIGO = new List<C_ProgramasSeguimientoSIGO_Result>();
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    programasSIGO = BD.C_ProgramasSeguimientoSIGO(idTablero: idTablero, numeroSeguimiento: numeroSeguimiento, nivel: nivel, divipola: divipola, idDerecho: idDerecho, idPregunta: idPregunta).ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return programasSIGO;
        }

        /// <summary>
        /// Gets the programas seguimiento.
        /// </summary>
        /// <param name="idRespuesta">The identifier respuesta.</param>
        /// <param name="idSeguimiento">The identifier seguimiento.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetProgramasSeguimiento/")]
        public object GetProgramasSeguimiento(int idRespuesta, int idSeguimiento, int numSeguimiento)
        {
            try
            {
                GestionMunicipalController gestionMunicipal = new GestionMunicipalController();
                IEnumerable<C_ProgramasPATSeguimiento> programasPat;
                if (idSeguimiento == 0)
                {
                    //Si no tiene seguimiento debe traer:En casi de primer seguimiento los programas de planeacion y si es del segundo seguimiento debe traer los programas del primer seguimiento.
                    if (numSeguimiento == 1)
                    {
                        var programasplaneacionPat = gestionMunicipal.ProgramasPAT(idRespuesta).ToList();
                        programasPat = programasplaneacionPat.Select(d => new C_ProgramasPATSeguimiento
                        {
                            PROGRAMA = d.PROGRAMA,
                            ID = d.ID
                        });
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
                        IEnumerable<C_ProgramasSeguimiento_Result> programasSeguimiento = BD.C_ProgramasSeguimiento(idSeguimiento).Cast<C_ProgramasSeguimiento_Result>().ToList();

                        programasPat = programasSeguimiento.Select(a => new C_ProgramasPATSeguimiento
                        {
                            ID = a.IdSeguimiento,
                            PROGRAMA = a.Programa,
                            NumeroSeguimiento = a.NumeroSeguimiento
                        }).ToList();

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
        /// Datoses the iniciales seguimiento municipio.
        /// </summary>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <param name="IdUsuario">The identifier usuario.</param>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosInicialesSeguimientoMunicipio/")]
        public object DatosInicialesSeguimientoMunicipio(short idPregunta, int IdUsuario, short idTablero, int idMunicipio, int numSeguimiento, int idDerecho)
        {
            int totalNecesidades = ContarNecesidadesIdentificadasSeguimiento(IdUsuario, idPregunta);
            var datosRespuesta = GetTableroSeguimientoDetalle(IdUsuario, idPregunta, numSeguimiento);
            var datosSegGobernaciones = DatosSeguimientoDepartamentoPorMunicipio(idPregunta, idMunicipio);
            var datosSegNacional = DatosSeguimientoNacionalPorMunicipio(idPregunta, idMunicipio);
            var datosPrecargueNacional = DatosPreguntaPATPrecargueEntidadesNacionales(idPregunta, idMunicipio);

            //Sin datos
            if (datosRespuesta.FirstOrDefault().IdRespuesta > 0)
            {
                datosRespuesta.FirstOrDefault().IdTablero = byte.Parse(idTablero.ToString());
            }

            var datosProgramas = GetProgramasSeguimiento(datosRespuesta.FirstOrDefault().IdRespuesta, datosRespuesta.FirstOrDefault().IdSeguimiento, numSeguimiento);

            List<C_ProgramasSeguimientoSIGO_Result> programasSIGO = GetProgramasSeguimientoSIGO(idTablero, numSeguimiento, 3, idMunicipio, idDerecho, idPregunta);

            var objeto = new
            {
                totalNecesidades = totalNecesidades,
                datosRespuesta = datosRespuesta,
                datosProgramas = datosProgramas,
                datosSegGobernaciones = datosSegGobernaciones,
                datosSegNacional = datosSegNacional,
                datosPrecargueNacional = datosPrecargueNacional,
                programasSIGO = programasSIGO
            };

            return objeto;
        }

        /// <summary>
        /// Adjutars the archivo seguimiento.
        /// </summary>
        /// <returns>Task&lt;HttpResponseMessage&gt;.</returns>
        [HttpPost]
        [Route("api/TableroPat/AdjutarArchivoSeguimiento/")]
        public async Task<HttpResponseMessage> AdjutarArchivoSeguimiento()
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

                        try
                        {                            
                            var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
                            var arc = new FileInfo(result.FileData.First().LocalFileName);
                            var archivo = File.ReadAllBytes(result.FileData.First().LocalFileName);
                            OriginalFileName = OriginalFileName.Replace('ñ', 'n').Replace('Ñ', 'N');

                            C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();
                            var path = Archivo.GuardarArchivoTableroPatShared(archivo, OriginalFileName, sistema.UploadDirectory, model.usuario, model.tablero, model.pregunta, model.type, Archivo.pathPATFiles);
                        } catch(Exception ex)
                        {
                            BD.U_UndoArchivoSeguimiento(int.Parse(model.pregunta), int.Parse(model.tablero), int.Parse(model.usuario), model.type);
                        }
                        
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
        [Route("api/TableroPat/Download/")]
        public HttpResponseMessage Descargar(string archivo, string nombreArchivo, string type, int idTablero, int idPregunta, int idUsuario, int NumSeguimiento = 1)
        {
            try
            {
                string directorio = "";
                string directorioEntidad = "";
                string usuario = "";
                string dirSeguimiento = Archivo.pathPATFiles;
                switch (type)
                {
                    case "OD":
                        //busca con el idusuario y si no encuentra busca con el username                                            
                        directorio = Path.Combine(idUsuario.ToString(), idTablero.ToString(), type, idPregunta.ToString(), archivo);
                        usuario = GetIdEntidad(idUsuario);
                        directorioEntidad = Path.Combine(usuario, idTablero.ToString(), type, idPregunta.ToString(), archivo);
                        return Archivo.DescargarEncuestaSharedOtrosDerechos(Archivo.pathPATFiles, directorio, directorioEntidad);
                    case "RC":
                        //busca con el idusuario y si no encuentra busca con el username                                            
                        directorio = Path.Combine(idUsuario.ToString(), idTablero.ToString(), type, idPregunta.ToString(), archivo);
                        usuario = GetIdEntidad(idUsuario);
                        directorioEntidad = Path.Combine(usuario, idTablero.ToString(), type, idPregunta.ToString(), archivo);
                        return Archivo.DescargarEncuestaSharedOtrosDerechos(Archivo.pathPATFiles, directorio, directorioEntidad);
                    default:
                        if (NumSeguimiento == 1 && idTablero == 1)
                        {
                            //Se debe armar el directorio con el username
                            usuario = GetIdEntidad(idUsuario);
                            directorio = Path.Combine(usuario, idTablero.ToString(), type, idPregunta.ToString(), archivo);
                        }
                        else
                        {
                            //Si numero de seguiento es 2 toma el idusuario que llega
                            directorio = Path.Combine(idUsuario.ToString(), idTablero.ToString(), type, idPregunta.ToString(), archivo);
                        }
                        return Archivo.DescargarEncuestaShared(Archivo.pathPATFiles, directorio);
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return null;
            }
        }

        [HttpGet]
        [Route("api/TableroPat/GetIdEntidad/")]
        public string GetIdEntidad(int idUsuario)
        {
            string resultado = "";
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_IdEntidad(idUsuario: idUsuario).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Registrars the seguimiento.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/RegistrarSeguimiento/")]
        public C_AccionesResultado RegistrarSeguimiento(SeguimientoPAT model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            bool Insertando = false;
            model.NombreAdjunto = model.NombreAdjunto.Replace('ñ', 'n').Replace('Ñ', 'N');
            model.Observaciones = quitarAcentos(model.Observaciones);
            model.ObservacionesDefinitivo = quitarAcentos(model.ObservacionesDefinitivo);
            model.ObservacionesSegundo = quitarAcentos(model.ObservacionesSegundo);

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                using (var dbContextTransaction = BD.Database.BeginTransaction())
                {
                    try
                    {
                        if (model.IdSeguimiento > 0)
                        {
                            resultado = BD.U_SeguimientoMunicipalUpdate(idSeguimiento: model.IdSeguimiento, idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, cantidadPrimer: model.CantidadPrimer, presupuestoPrimer: model.PresupuestoPrimer, cantidadSegundo: model.CantidadSegundo, presupuestoSegundo: model.PresupuestoSegundo, observaciones: model.Observaciones, nombreAdjunto: model.NombreAdjunto, observacionesSegundo: model.ObservacionesSegundo, nombreAdjuntoSegundo: model.NombreAdjuntoSegundo, compromisoDefinitivo: model.CompromisoDefinitivo, presupuestoDefinitivo: model.PresupuestoDefinitivo, observacionesDefinitivo: model.ObservacionesDefinitivo).FirstOrDefault();
                            Insertando = false;
                        }
                        else
                        {
                            var datosInsert = BD.I_SeguimientoMunicipalInsert(idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, cantidadPrimer: model.CantidadPrimer, presupuestoPrimer: model.PresupuestoPrimer, cantidadSegundo: model.CantidadSegundo, presupuestoSegundo: model.PresupuestoSegundo, observaciones: model.Observaciones, nombreAdjunto: model.NombreAdjunto, observacionesSegundo: model.ObservacionesSegundo, nombreAdjuntoSegundo: model.NombreAdjuntoSegundo, compromisoDefinitivo: model.CompromisoDefinitivo, presupuestoDefinitivo: model.PresupuestoDefinitivo, observacionesDefinitivo: model.ObservacionesDefinitivo).FirstOrDefault();
                            model.IdSeguimiento = datosInsert.id.Value;
                            resultado.estado = datosInsert.estado;
                            resultado.respuesta = datosInsert.respuesta;
                            Insertando = true;
                        }

                        //// se borran los programas
                        if (resultado.estado == 1 || resultado.estado == 2)
                        {
                            resultado = BD.D_SeguimientoMunicipalProgramaDelete(idSeguimiento: model.IdSeguimiento).FirstOrDefault();
                        }

                        if (resultado.estado == 3)
                        {
                            if (model.SeguimientoProgramas != null)
                            {
                                if (model.SeguimientoProgramas.Count() > 0)
                                {
                                    foreach (var item in model.SeguimientoProgramas)
                                    {
                                        item.IdSeguimiento = model.IdSeguimiento;
                                        var datosInsert = BD.I_SeguimientoMunicipalProgramaInsert(idSeguimiento: model.IdSeguimiento, programa: item.PROGRAMA, numeroSeguimiento: item.NumeroSeguimiento).FirstOrDefault();
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

                                //// Audita la creación o actualización del seguimiento municipio PAT
                                (new AuditExecuted(Insertando ? Category.CrearSeguimientoPATMpio : Category.EditarSeguimientoPATMpio)).ActionExecutedManual(model);

                                //// Audita la eliminación de todos los programas del seguimiento municipio PAT
                                (new AuditExecuted(Category.ELiminarProgramasSeguimientoPATMpio)).ActionExecutedManual(model);

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
                                            (new AuditExecuted(item.Insertado ? Category.CrearProgramaSeguimientoPATMpio : Category.EditarProgramaSeguimientoPATMpio)).ActionExecutedManual(item);
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

        #region APIS PARA EL MODAL DE MUNICIPIOS OTROS DERECHOS    

        /// <summary>
        /// Gets the derechos od.
        /// </summary>
        /// <param name="IdTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_DerechosSeguimientoOtrosDerechos_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetTableroSeguimientoDetalle/")]
        public IEnumerable<C_DerechosSeguimientoOtrosDerechos_Result> GetDerechosOD(short IdTablero)
        {
            IEnumerable<C_DerechosSeguimientoOtrosDerechos_Result> resultado = Enumerable.Empty<C_DerechosSeguimientoOtrosDerechos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_DerechosSeguimientoOtrosDerechos(idTablero: IdTablero).Cast<C_DerechosSeguimientoOtrosDerechos_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the componentes derecho od.
        /// </summary>
        /// <param name="idDerecho">The identifier derecho.</param>
        /// <returns>IEnumerable&lt;C_ComponentesSeguimientoOtrosDerechos_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetComponentesDerechoOD/")]
        public IEnumerable<C_ComponentesSeguimientoOtrosDerechos_Result> GetComponentesDerechoOD(short idDerecho)
        {
            IEnumerable<C_ComponentesSeguimientoOtrosDerechos_Result> resultado = Enumerable.Empty<C_ComponentesSeguimientoOtrosDerechos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ComponentesSeguimientoOtrosDerechos(idDerecho: idDerecho).Cast<C_ComponentesSeguimientoOtrosDerechos_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the medidas by componente od.
        /// </summary>
        /// <param name="idComponente">The identifier componente.</param>
        /// <returns>IEnumerable&lt;C_MedidasSeguimientoOtrosDerechos_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/GetMedidasByComponenteOD/")]
        public IEnumerable<C_MedidasSeguimientoOtrosDerechos_Result> GetMedidasByComponenteOD(short idComponente)
        {
            IEnumerable<C_MedidasSeguimientoOtrosDerechos_Result> resultado = Enumerable.Empty<C_MedidasSeguimientoOtrosDerechos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_MedidasSeguimientoOtrosDerechos(idComponente: idComponente).Cast<C_MedidasSeguimientoOtrosDerechos_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Datoses the iniciales edicion seguimiento municipio od.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosInicialesEdicionSeguimientoMunicipioOD/")]
        public object DatosInicialesEdicionSeguimientoMunicipioOD(byte idTablero = 0)
        {
            AdministracionController clsPreguntas = new AdministracionController();

            var listaDerechos = GetDerechosOD(idTablero);
            var listaUnidades = clsPreguntas.UnidadesMedida();

            var objeto = new
            {
                listaDerechos = listaDerechos,
                listaUnidades = listaUnidades
            };

            return objeto;
        }

        /// <summary>
        /// Adjuntars the seguimiento.
        /// </summary>
        /// <returns>Task&lt;HttpResponseMessage&gt;.</returns>
        [HttpPost]
        [Route("api/TableroPat/AdjuntarSeguimiento/")]
        public async Task<HttpResponseMessage> AdjuntarSeguimiento()
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

                //si adjunto archivo
                if (result.FileData.Count > 0)
                {
                    var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
                    var File = new FileInfo(result.FileData.First().LocalFileName);
                    Archivo.GuardarArchivoRepositorio(File, Archivo.pathPATFiles, OriginalFileName);
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return this.Request.CreateResponse(HttpStatusCode.OK, new { resultado.estado, resultado.respuesta });
        }

        /// <summary>
        /// Registrars the seguimiento od.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultadoInsert.</returns>
        [HttpPost]
        [Route("api/TableroPat/RegistrarSeguimientoOD/")]
        public C_AccionesResultadoInsert RegistrarSeguimientoOD(SeguimientoOtrosDerechos model)
        {
            C_AccionesResultadoInsert resultado = new C_AccionesResultadoInsert();
            model.NombreAdjunto = model.NombreAdjunto.Replace('ñ', 'n').Replace('Ñ', 'N');
            model.Accion = quitarAcentos(model.Accion);
            model.Observaciones = quitarAcentos(model.Observaciones);
            model.Programa = quitarAcentos(model.Programa);

            bool Insertando = false;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                using (var dbContextTransaction = BD.Database.BeginTransaction())
                {
                    try
                    {
                        if (model.IdSeguimiento > 0)
                        {
                            //resultado = BD.U_SeguimientoMunicipalRCUpdate(idSeguimiento: model.IdSeguimiento, idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, avancePrimer: model.AvancePrimer, avanceSegundo: model.AvanceSegundo, nombreAdjunto: model.NombreAdjunto).FirstOrDefault();
                            Insertando = false;
                        }
                        else
                        {
                            var datosInsert = BD.I_SeguimientoMunicipalOtrosDerechosInsert(idTablero: model.IdTablero, idUsuario: model.IdUsuario, accion: model.Accion, numSeguimiento: model.NumSeguimiento, idUnidad: model.IdUnidad, presupuesto: model.Presupuesto, observaciones: model.Observaciones, nombreAdjunto: model.NombreAdjunto, programa: model.Programa).FirstOrDefault();
                            model.IdSeguimiento = datosInsert.id.Value;
                            resultado.id = datosInsert.id;
                            resultado.estado = datosInsert.estado;
                            resultado.respuesta = datosInsert.respuesta;
                            Insertando = true;

                            if (resultado.estado == 1 || resultado.estado == 2)
                            {
                                if (model.SeguimientoOtrosDerechosMedidas != null)
                                {
                                    if (model.SeguimientoOtrosDerechosMedidas.Count() > 0)
                                    {
                                        foreach (var item in model.SeguimientoOtrosDerechosMedidas)
                                        {
                                            item.IdSeguimiento = model.IdSeguimiento;
                                            var datosInsertM = BD.I_SeguimientoMunicipalOtrosDerechosMedidasInsert(idSeguimiento: model.IdSeguimiento, idMedida: item.IdMedida, idComponente: item.IdComponente, idDerecho: item.IdDerecho).FirstOrDefault();
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
                            (new AuditExecuted(Insertando ? Category.CrearSeguimientoOtrosDerechosMpio : Category.EditarSeguimientoOtrosDerechosMpio)).ActionExecutedManual(model);

                            if (model.SeguimientoOtrosDerechosMedidas != null)
                            {
                                if (model.SeguimientoOtrosDerechosMedidas.Count() > 0)
                                {
                                    foreach (var item in model.SeguimientoOtrosDerechosMedidas)
                                    {
                                        item.AudUserName = model.AudUserName;
                                        item.AddIdent = model.AddIdent;
                                        item.UserNameAddIdent = model.UserNameAddIdent;
                                        (new AuditExecuted(item.Insertado ? Category.CrearSeguimientoOtrosDerechosMedidasMpio : Category.EditarSeguimientoOtrosDerechosMedidasMpio)).ActionExecutedManual(item);
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
        /// Eliminars the medida od.
        /// </summary>
        /// <param name="idSeguimientoMedida">The identifier seguimiento medida.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.EliminarSeguimientoOtrosDerechosMedidasMpio)]
        [Route("api/TableroPat/EliminarMedidaOD/")]
        public C_AccionesResultado EliminarMedidaOD(SeguimientoOtrosDerechosMedidas model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                try
                {
                    resultado = BD.D_SeguimientoMunicipalOtrosDerechosMedidasDelete(idSeguimientoMedida: model.IdSeguimientoMedidas).FirstOrDefault();
                }
                catch (Exception ex)
                {
                    (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                }
            }

            return resultado;
        }

        #endregion

        #region APIS PARA EL MODAL MUNICIPIOS REPARACION COLECTIVA        

        /// <summary>
        /// Registrars the seguimiento rc.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/RegistrarSeguimientoRC/")]
        public C_AccionesResultado RegistrarSeguimientoRC(SeguimientoReparacionColectiva model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            model.NombreAdjunto = model.NombreAdjunto.Replace('ñ', 'n').Replace('Ñ', 'N');
            model.AvancePrimer = quitarAcentos(model.AvancePrimer);
            model.AvanceSegundo = quitarAcentos(model.AvanceSegundo);

            bool Insertando = false;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                try
                {
                    if (model.IdSeguimientoRC > 0)
                    {
                        resultado = BD.U_SeguimientoMunicipalRCUpdate(idSeguimiento: model.IdSeguimientoRC, idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, avancePrimer: model.AvancePrimer, avanceSegundo: model.AvanceSegundo, nombreAdjunto: model.NombreAdjunto, idRespuestaRC: model.IdRespuestaRC).FirstOrDefault();
                        Insertando = false;
                    }
                    else
                    {
                        var datosInsert = BD.I_SeguimientoMunicipalRCInsert(idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, avancePrimer: model.AvancePrimer, avanceSegundo: model.AvanceSegundo, nombreAdjunto: model.NombreAdjunto, idRespuestaRC: model.IdRespuestaRC).FirstOrDefault();
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
                    //// Audita la creación o actualización del seguimiento de reparación colectiva por municipio
                    (new AuditExecuted(Insertando ? Category.CrearSeguimientoReparacionColectivaMpio : Category.EditarSeguimientoReparacionColectivaMpio)).ActionExecutedManual(model);
                }
            }

            return resultado;
        }

        #endregion

        #region APIS PARA EL MODAL MUNICIPIOS RETORNOS Y REUBICACIONES     

        /// <summary>
        /// Registrars the seguimiento rr.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/RegistrarSeguimientoRR/")]
        public C_AccionesResultado RegistrarSeguimientoRR(SeguimientoRetornosReubicaciones model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            model.NombreAdjunto = model.NombreAdjunto.Replace('ñ', 'n').Replace('Ñ', 'N');
            model.AvancePrimer = quitarAcentos(model.AvancePrimer);
            model.AvanceSegundo = quitarAcentos(model.AvanceSegundo);

            bool Insertando = false;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                try
                {
                    if (model.IdSeguimientoRR > 0)
                    {
                        resultado = BD.U_SeguimientoMunicipalRRUpdate(idSeguimiento: model.IdSeguimientoRR, idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, avancePrimer: model.AvancePrimer, avanceSegundo: model.AvanceSegundo, nombreAdjunto: model.NombreAdjunto).FirstOrDefault();
                        Insertando = false;
                    }
                    else
                    {
                        var datosInsert = BD.I_SeguimientoMunicipalRRInsert(idTablero: model.IdTablero, idPregunta: model.IdPregunta, idUsuario: model.IdUsuario, avancePrimer: model.AvancePrimer, avanceSegundo: model.AvanceSegundo, nombreAdjunto: model.NombreAdjunto).FirstOrDefault();
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
                    //// Audita la creación o actualización del seguimiento de retornos de reubicación por municipio
                    (new AuditExecuted(Insertando ? Category.CrearSeguimientoRetornosReubicacionesMpio : Category.EditarSeguimientoRetornosReubicacionesMpio)).ActionExecutedManual(model);
                }
            }

            return resultado;
        }

        #endregion

        #region APIS PARA LA PANTALLA DE CONSULTA DE LISTADO DE USUARIOS QUE HICIERON SEGUIMIENTO

        /// <summary>
        /// Datoses the consulta diligenciamiento.
        /// </summary>
        /// <param name="Usuario">The usuario.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/DatosConsultaSeguimiento/")]

        public object DatosConsultaDiligenciamiento(string Usuario)
        {
            var datos = ListaUsuariosSeguimiento(Usuario);
            var tableros = ListaTablerosConsultarSeguimiento();

            var objeto = new
            {
                datos = datos,
                tableros = tableros
            };

            return objeto;

        }

        /// <summary>
        /// Listas the usuarios seguimiento.
        /// </summary>
        /// <param name="Usuario">The usuario.</param>
        /// <returns>IEnumerable&lt;C_ListadoSeguimientoConRespuesta_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/ListaUsuariosSeguimiento/")]
        public IEnumerable<C_ListadoSeguimientoConRespuesta_Result> ListaUsuariosSeguimiento(string Usuario)
        {
            IEnumerable<C_ListadoSeguimientoConRespuesta_Result> resultado = Enumerable.Empty<C_ListadoSeguimientoConRespuesta_Result>();

            try
            {
                int idDept = 0;
                Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
                var modelUsuario = new UsuariosModels { UserName = Usuario };
                var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
                string TipoUsuario = datosUsuario.FirstOrDefault().TipoUsuario;
                if (TipoUsuario == "Gobernación")
                {
                    idDept = Convert.ToInt32(datosUsuario.FirstOrDefault().IdDepartamento);
                }
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListadoSeguimientoConRespuesta(idDept: idDept).Cast<C_ListadoSeguimientoConRespuesta_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Listas the tableros consultar seguimiento.
        /// </summary>
        /// <returns>IEnumerable&lt;C_ListadoTablerosSeguimiento_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/ListaTablerosConsultarSeguimiento/")]
        public IEnumerable<C_ListadoTablerosSeguimiento_Result> ListaTablerosConsultarSeguimiento()
        {
            IEnumerable<C_ListadoTablerosSeguimiento_Result> resultado = Enumerable.Empty<C_ListadoTablerosSeguimiento_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListadoTablerosSeguimiento().Cast<C_ListadoTablerosSeguimiento_Result>().ToList(); ;
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
        /// Eliminar Caracteres especiales
        /// </summary>
        /// <param name="valor"></param>
        /// <returns></returns>
        private string quitarAcentos(string valor)
        {
            if (valor != null)
                return valor.Replace("\"", " ").Replace("#", " ").Replace("-", " ").Replace("\n", " ").Replace("\t", " ");
            else
                return valor;
        }
    }
}