// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM - Mauricio Ospina
// Created          : 11-06-2017
//
// Last Modified By : Equipo de desarrollo OIM - Mauricio Ospina
// Last Modified On : 11-11-2017
// ***********************************************************************
// <copyright file="AdministracionController.cs" company="Ministerio del Interior">
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
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;
    using RusicstMVC.Servicios.Controllers.General;

    /// <summary>
    /// Class AdministracionController.
    /// </summary>
    public class AdministracionController : ApiController
    {
        #region APIS PARA LA PANTALLA DE ADMINISTRACION DE TABLEROS
        /// <summary>
        /// Listas the todos tableros.
        /// </summary>
        /// <returns>IEnumerable&lt;C_ListadoAdministracionTableros_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/ListaTodosTableros/")]
        public IEnumerable<C_ListadoAdministracionTableros_Result> ListaTodosTableros()
        {
            IEnumerable<C_ListadoAdministracionTableros_Result> resultado = Enumerable.Empty<C_ListadoAdministracionTableros_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ListadoAdministracionTableros().Cast<C_ListadoAdministracionTableros_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        [HttpGet]
        [Route("api/TableroPat/ListaTodosTablerosPlaneacionActivos/")]
        public IEnumerable<C_TodosTablerosPlaneacionActivos_Result> ListaTodosTablerosPlaneacionActivos()
        {
            IEnumerable<C_TodosTablerosPlaneacionActivos_Result> resultado = Enumerable.Empty<C_TodosTablerosPlaneacionActivos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TodosTablerosPlaneacionActivos().Cast<C_TodosTablerosPlaneacionActivos_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        [HttpGet]
        [Route("api/TableroPat/ListaTodosTablerosSeguimientosActivos/{Id}")]
        public IEnumerable<C_TodosTablerosSeguimientosActivos_Result> ListaTodosTablerosSeguimientosActivos(int Id)
        {
            IEnumerable<C_TodosTablerosSeguimientosActivos_Result> resultado = Enumerable.Empty<C_TodosTablerosSeguimientosActivos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TodosTablerosSeguimientosActivos(Id).Cast<C_TodosTablerosSeguimientosActivos_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Ingresars the tablero.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultadoInsert.</returns>
        [HttpPost]
        [Route("api/TableroPat/IngresarTablero/")]
        public C_AccionesResultadoInsert IngresarTablero(TableroPAT model)
        {
            C_AccionesResultadoInsert resultado = new C_AccionesResultadoInsert();
            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                try
                {
                    var datosInsert = BD.I_TableroPatInsert().FirstOrDefault();
                    resultado.estado = datosInsert.estado;
                    resultado.respuesta = datosInsert.respuesta;
                    resultado.id = datosInsert.id;
                    if (resultado.estado == 1 || resultado.estado == 2)
                    {
                        //// Audita la creación o actualización de los tableros PAT
                        //(new AuditExecuted(Category.CrearTableroPAT).ActionExecutedManual(model);
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
        /// Preguntases the por tablero.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <param name="nivel">The nivel.</param>
        /// <returns>IEnumerable&lt;C_PreguntasPat_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/PreguntasPorTablero/{idTablero},{nivel}")]
        public IEnumerable<C_PreguntasPat_Result> PreguntasPorTablero(byte idTablero, byte nivel)
        {
            IEnumerable<C_PreguntasPat_Result> resultado = Enumerable.Empty<C_PreguntasPat_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_PreguntasPat(idTablero: idTablero, nivel: nivel).Cast<C_PreguntasPat_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modificars the nivel tablero.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/ModificarNivelTablero/")]
        public C_AccionesResultado ModificarNivelTablero(TableroPAT model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                try
                {
                    resultado = BD.U_TableroPatUpdate(id: model.Id, idTablero: model.IdTablero, nivel: model.Nivel, vigenciaInicio: model.VigenciaInicio, vigenciaFin: model.VigenciaFin, activo: model.Activo, seguimiento1Inicio: model.Seguimiento1Inicio, seguimiento1Fin: model.Seguimiento1Fin, seguimiento2Inicio: model.Seguimiento2Inicio, seguimiento2Fin: model.Seguimiento2Fin, activoEnvioPATPlaneacion: model.activoEnvioPATPlaneacion, activoEnvioPATSeguimiento: model.activoEnvioPATSeguimiento).FirstOrDefault();
                    if (resultado.estado == 1 || resultado.estado == 2)
                    {
                        //// Audita la creación o actualización de los niveles del tablero PAT
                        (new AuditExecuted(Category.EditarNivelTAbleroPAT)).ActionExecutedManual(model);
                    }
                }
                catch (Exception ex)
                {
                    (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                }
            }
            return resultado;
        }

        #endregion

        #region APIS PARA LA PANTALLA DE ADMINISTRACION DE PREGUNTAS   

        /// <summary>
        /// Componenteses this instance.
        /// </summary>
        /// <returns>IEnumerable&lt;C_TodosComponentes_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/Componentes/")]
        public IEnumerable<C_TodosComponentes_Result> Componentes()
        {
            IEnumerable<C_TodosComponentes_Result> resultado = Enumerable.Empty<C_TodosComponentes_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TodosComponentes().Cast<C_TodosComponentes_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Medidases this instance.
        /// </summary>
        /// <returns>IEnumerable&lt;C_TodasMedidas_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/Medidas/")]
        public IEnumerable<C_TodasMedidas_Result> Medidas()
        {
            IEnumerable<C_TodasMedidas_Result> resultado = Enumerable.Empty<C_TodasMedidas_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TodasMedidas().Cast<C_TodasMedidas_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Todoses the derechos.
        /// </summary>
        /// <returns>IEnumerable&lt;C_TodosDerechos_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/TodosDerechos/")]
        public IEnumerable<C_TodosDerechos_Result> TodosDerechos()
        {
            IEnumerable<C_TodosDerechos_Result> resultado = Enumerable.Empty<C_TodosDerechos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TodosDerechos().Cast<C_TodosDerechos_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Unidadeses the medida.
        /// </summary>
        /// <returns>IEnumerable&lt;C_TodasUnidadesMedida_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/UnidadesMedida/")]
        public IEnumerable<C_TodasUnidadesMedida_Result> UnidadesMedida()
        {
            IEnumerable<C_TodasUnidadesMedida_Result> resultado = Enumerable.Empty<C_TodasUnidadesMedida_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TodasUnidadesMedida().Cast<C_TodasUnidadesMedida_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Todoses the tableros.
        /// </summary>
        /// <returns>IEnumerable&lt;C_TodosTableros_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/TodosTableros/")]
        public IEnumerable<C_TodosTableros_Result> TodosTableros()
        {
            IEnumerable<C_TodosTableros_Result> resultado = Enumerable.Empty<C_TodosTableros_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TodosTableros().Cast<C_TodosTableros_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Cargars the edicion preguntas.
        /// </summary>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarEdicionPreguntas/")]
        public object CargarEdicionPreguntas()
        {
            var derechos = TodosDerechos().ToList();
            var componentes = Componentes().ToList();
            var medidas = Medidas().ToList();
            var unidadesMedida = UnidadesMedida().ToList();
            var tableros = TodosTableros().ToList();

            var objeto = new
            {
                derechos = derechos,
                componentes = componentes,
                medidas = medidas,
                unidadesMedida = unidadesMedida,
                tableros = tableros
            };

            return objeto;
        }

        /// <summary>
        /// Items de acuerdo al nivel que llega como parámetro. Puede ser Municipio o Departamentos
        /// </summary>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <param name="incluidos">if set to <c>true</c> [incluidos].</param>
        /// <returns>IEnumerable&lt;C_UsuariosXRol_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarEdicionDepartamentosXPreguntaPAT/")]
        public IEnumerable<C_DepartamentosXPregunta_Result> DepartamentosXPreguntaPAT(int idPregunta, bool incluidos)
        {
            IEnumerable<C_DepartamentosXPregunta_Result> resultado = Enumerable.Empty<C_DepartamentosXPregunta_Result>();

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                resultado = BD.C_DepartamentosXPregunta(idPregunta, incluidos).Cast<C_DepartamentosXPregunta_Result>().ToList();
            }

            return resultado;
        }

        /// <summary>
        /// Municipioses the x pregunta pat.
        /// </summary>
        /// <param name="idPregunta">The identifier pregunta.</param>
        /// <param name="incluidos">if set to <c>true</c> [incluidos].</param>
        /// <returns>IEnumerable&lt;C_MunicipiosXPregunta_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarEdicionMunicipiosXPreguntaPAT/")]
        public IEnumerable<C_MunicipiosXPregunta_Result> MunicipiosXPreguntaPAT(int idPregunta, bool incluidos)
        {
            IEnumerable<C_MunicipiosXPregunta_Result> resultado = Enumerable.Empty<C_MunicipiosXPregunta_Result>();

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                resultado = BD.C_MunicipiosXPregunta(idPregunta, incluidos).Cast<C_MunicipiosXPregunta_Result>().ToList();
            }

            return resultado;
        }

        /// <summary>
        /// Preguntases this instance.
        /// </summary>
        /// <returns>IEnumerable&lt;C_PreguntasPat_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/Preguntas/")]
        public IEnumerable<C_PreguntasPat_Result> Preguntas()
        {
            IEnumerable<C_PreguntasPat_Result> resultado = Enumerable.Empty<C_PreguntasPat_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_PreguntasPat(0, 0).Cast<C_PreguntasPat_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modificars the preguntas.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/ModificarPreguntas/")]
        public C_AccionesResultado ModificarPreguntas(PreguntasPAT model)
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
                            resultado = BD.U_PreguntaPatUpdate(model.Id, model.IdDerecho, model.IdComponente, model.IdMedida, model.Nivel, model.PreguntaIndicativa, model.IdUnidadMedida, model.PreguntaCompromiso, model.ApoyoDepartamental, model.ApoyoEntidadNacional, model.Activo, model.IdTablero, model.IdsNivel, model.Incluir, model.RequiereAdjunto, model.MensajeAdjunto, model.ExplicacionPregunta, codigosDane: model.IdsDane).FirstOrDefault();
                            Insertando = false;
                        }
                        else
                        {
                            var datosInsert = BD.I_PreguntaPatInsert(model.IdDerecho, model.IdComponente, model.IdMedida, model.Nivel, model.PreguntaIndicativa, model.IdUnidadMedida, model.PreguntaCompromiso, model.ApoyoDepartamental, model.ApoyoEntidadNacional, model.Activo, model.IdTablero, model.IdsNivel, model.RequiereAdjunto, model.MensajeAdjunto, model.ExplicacionPregunta, codigosDane: model.IdsDane).FirstOrDefault();
                            model.Id = datosInsert.id.Value;
                            resultado.estado = datosInsert.estado;
                            resultado.respuesta = datosInsert.respuesta;
                            Insertando = true;
                        }
                        if (resultado.estado == 1 || resultado.estado == 2)
                        {
                            dbContextTransaction.Commit();

                            //// Audita la creación o actualización de las preguntas PAT
                            (new AuditExecuted(Insertando ? Category.CrearPreguntasPAT : Category.EditarPreguntasPAT)).ActionExecutedManual(model);
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

        #region APIS PARA LA PANTALLA DE ADMINISTRACION DE PREGUNTAS DE REPARACION COLECTIVA   

        /// <summary>
        /// Cargars the edicion preguntas rc.
        /// </summary>
        /// <param name="audUserName">Name of the aud user.</param>
        /// <param name="userNameAddIdent">The user name add ident.</param>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarEdicionPreguntasRC/")]
        public object CargarEdicionPreguntasRC(string audUserName, string userNameAddIdent)
        {
            ListasController clsGeneral = new ListasController();
            var medidas = Medidas().ToList();
            var departamentos = clsGeneral.DepartamentosMunicipios(audUserName, userNameAddIdent);
            var tableros = TodosTableros().ToList();

            var objeto = new
            {
                medidas = medidas,
                departamentos = departamentos,
                tableros = tableros
            };

            return objeto;
        }

        /// <summary>
        /// Preguntases this instance.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_PreguntasPat_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/PreguntasRC/")]
        public IEnumerable<C_PreguntasRCPat_Result> PreguntasRC(byte idTablero)
        {
            IEnumerable<C_PreguntasRCPat_Result> resultado = Enumerable.Empty<C_PreguntasRCPat_Result>();
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_PreguntasRCPat(idTablero: idTablero).Cast<C_PreguntasRCPat_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modificars the preguntas.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/ModificarPreguntasRC/")]
        public C_AccionesResultado ModificarPreguntasRC(PreguntasRCPAT model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            bool Insertando = false;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                try
                {
                    if (model.Id > 0)
                    {
                        resultado = BD.U_PreguntaRCPatUpdate(id: model.Id, idMedida: model.IdMedida, sujeto: model.Sujeto, medidaReparacionColectiva: model.MedidaReparacionColectiva, idDepartamento: model.IdDepartamento, idMunicipio: model.IdMunicipio, idTablero: model.IdTablero, activo: model.Activo).FirstOrDefault();
                        Insertando = false;
                    }
                    else
                    {
                        var datosInsert = BD.I_PreguntaRCPatInsert(idMedida: model.IdMedida, sujeto: model.Sujeto, medidaReparacionColectiva: model.MedidaReparacionColectiva, idDepartamento: model.IdDepartamento, idMunicipio: model.IdMunicipio, idTablero: model.IdTablero, activo: model.Activo).FirstOrDefault();
                        model.Id = datosInsert.id.Value;
                        resultado.estado = datosInsert.estado;
                        resultado.respuesta = datosInsert.respuesta;
                        Insertando = true;
                    }
                    if (resultado.estado == 1 || resultado.estado == 2)
                    {
                        //// Audita la creación o actualización de las preguntas PAT
                        (new AuditExecuted(Insertando ? Category.CrearPreguntasRCPAT : Category.EditarPreguntasRCPAT)).ActionExecutedManual(model);
                    }
                }
                catch (Exception ex)
                {
                    (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                }
            }
            return resultado;
        }
        #endregion

        #region APIS PARA LA PANTALLA DE ADMINISTRACION DE PREGUNTAS DE RETORNOS Y REUBICACIONES   

        //[HttpGet]
        //[Route("api/TableroPat/CargarEdicionPreguntasRR/")]
        //public object CargarEdicionPreguntasRR()
        //{
        //    ListasController clsGeneral = new ListasController();
        //    var departamentos = clsGeneral.DepartamentosMunicipios();

        //    var objeto = new
        //    {
        //        departamentos = departamentos
        //    };

        //    return objeto;
        //}

        /// <summary>
        /// Preguntases this instance.
        /// </summary>
        /// <param name="idTablero">The identifier tablero.</param>
        /// <returns>IEnumerable&lt;C_PreguntasPat_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/PreguntasRR/")]
        public IEnumerable<C_PreguntasRRPat_Result> PreguntasRR(byte idTablero)
        {
            IEnumerable<C_PreguntasRRPat_Result> resultado = Enumerable.Empty<C_PreguntasRRPat_Result>();
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_PreguntasRRPat(idTablero: idTablero).Cast<C_PreguntasRRPat_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modificars the preguntas.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/TableroPat/ModificarPreguntasRR/")]
        public C_AccionesResultado ModificarPreguntasRR(PreguntasRRPAT model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            bool Insertando = false;

            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                try
                {
                    if (model.Id > 0)
                    {
                        resultado = BD.U_PreguntaRRPatUpdate(id: model.Id, hogares: model.Hogares, personas: model.Personas, sector: model.Sector, componente: model.Componente, comunidad: model.Comunidad, ubicacion: model.Ubicacion, medidaRetornoReubicacion: model.MedidaRetornoReubicacion, indicadorRetornoReubicacion: model.IndicadorRetornoReubicacion, entidadResponsable: model.EntidadResponsable, idDepartamento: model.IdDepartamento, idMunicipio: model.IdMunicipio, idTablero: model.IdTablero, activo: model.Activo).FirstOrDefault();
                        Insertando = false;
                    }
                    else
                    {
                        var datosInsert = BD.I_PreguntaRRPatInsert(hogares: model.Hogares, personas: model.Personas, sector: model.Sector, componente: model.Componente, comunidad: model.Comunidad, ubicacion: model.Ubicacion, medidaRetornoReubicacion: model.MedidaRetornoReubicacion, indicadorRetornoReubicacion: model.IndicadorRetornoReubicacion, entidadResponsable: model.EntidadResponsable, idDepartamento: model.IdDepartamento, idMunicipio: model.IdMunicipio, idTablero: model.IdTablero, activo: model.Activo).FirstOrDefault();
                        model.Id = datosInsert.id.Value;
                        resultado.estado = datosInsert.estado;
                        resultado.respuesta = datosInsert.respuesta;
                        Insertando = true;
                    }
                    if (resultado.estado == 1 || resultado.estado == 2)
                    {
                        //// Audita la creación o actualización de las preguntas PAT
                        (new AuditExecuted(Insertando ? Category.CrearPreguntasRRPAT : Category.EditarPreguntasRRPAT)).ActionExecutedManual(model);
                    }
                }
                catch (Exception ex)
                {
                    (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                }
            }
            return resultado;
        }
        #endregion      
    }
}