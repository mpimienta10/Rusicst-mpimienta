
namespace Mininterior.RusicstMVC.Servicios.Controllers.TableroPat
{
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.ServiceModel;
    using System.Web.Http;

    public class ConsumoServiciosExternosController : ApiController
    {
        #region APIS PARA EL CONSUMO DE LOS SERVICIOS WEB EXPUESTOS POR LA UNIDAD DE VICTIMAS DE LA GESTION Y SEGUIMIENTO DE LAS ENTIADES NACIONALES

        [HttpGet]
        [Route("api/TableroPat/IngresoEntidadesNacionales/")]
        public C_AccionesResultado IngresoEntidadesNacionales()
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            C_AccionesResultado resultadoAuditoriaError = new C_AccionesResultado();
            C_AccionesResultadoInsert resultadoAuditoria = new C_AccionesResultadoInsert();
            try
            {

                if (DateTime.Now.Hour >= 18)
                {
                    var binding = new WSHttpBinding();
                    binding.MaxReceivedMessageSize = int.MaxValue;
                    binding.MaxBufferPoolSize = int.MaxValue;

                    //ServiciosESigna.TableroPatWSClient clsws = new ServiciosESigna.TableroPatWSClient();
                    ServiciosESignaProduccion.TableroPatWSClient clsws = new ServiciosESignaProduccion.TableroPatWSClient();
                    var datosEntidades = clsws.obtenerEntidadesNacionales();
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 3600;
                        //ingreso de auditoria
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: 0, metodo: "obtenerEntidadesNacionales", numeroRegistros: datosEntidades.entidades.Count()).FirstOrDefault();
                        if (datosEntidades != null)
                        {
                            if (datosEntidades.entidades.Count() > 0)
                            {
                                foreach (var item in datosEntidades.entidades)
                                {
                                    try
                                    {
                                        resultado = BD.I_EntidadNacionalInsertUpdate(idEntidadNacional: item.idEntidadNacional, nombreEntidadNacional: item.nombreEntidadNacional, codigoEntidadNacional: item.codigoEntidadNacional).FirstOrDefault();
                                        if (resultado.estado != 1 && resultado.estado != 2)
                                        {
                                            //ingresa en tabla de auditoria para saber que registro falla
                                            resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: resultado.respuesta, datos: item.nombreEntidadNacional).FirstOrDefault();
                                        }
                                    }
                                    catch (Exception ex)
                                    {
                                        //ingresa en tabla de auditoria para saber que registro falla
                                        resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: ex.Message, datos: item.nombreEntidadNacional).FirstOrDefault();
                                    }

                                }
                            }
                        }
                        //actualizacion de fecha finalizacion en auditorial
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: resultadoAuditoria.id, metodo: "obtenerEntidadesNacionales", numeroRegistros: datosEntidades.entidades.Count()).FirstOrDefault();
                    }
                }
                else
                {
                    resultado.estado = 0;
                    resultado.respuesta = "Los servicios no se pueden consumir antes de las 6:00 pm por temas de rendimiento de Rusicst";
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                resultado.estado = 0;
                resultado.respuesta = ex.Message;
            }

            return resultado;
        }

        [HttpGet]
        [Route("api/TableroPat/IngresoCompromisosEntidades/")]
        public C_AccionesResultado IngresoCompromisosEntidades(int idTablero = 1)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            C_AccionesResultado resultadoAuditoriaError = new C_AccionesResultado();
            C_AccionesResultadoInsert resultadoAuditoria = new C_AccionesResultadoInsert();
            int numeroRegistros = 0;
            try
            {
                if (DateTime.Now.Hour >= 18)
                {
                    ServiciosESignaProduccion.TableroPatWSClient clsws = new ServiciosESignaProduccion.TableroPatWSClient();

                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 3600;
                        //ingreso de auditoria
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: 0, metodo: String.Format("obtenerCompromisosEntidades( {0} )", idTablero), numeroRegistros: numeroRegistros).FirstOrDefault();

                        //se obtienen los departamentos
                        IEnumerable<C_ListaDeptosYMunicipios_Result> departamentos = Enumerable.Empty<C_ListaDeptosYMunicipios_Result>();
                        departamentos = BD.C_ListaDeptosYMunicipios().Cast<C_ListaDeptosYMunicipios_Result>().ToList().Distinct();
                        var listaDepartamentos = departamentos.Select(a => a.IdDepartamento).ToList().Distinct();

                        foreach (var dep in listaDepartamentos)
                        {
                            var binding = new WSHttpBinding();
                            binding.MaxReceivedMessageSize = int.MaxValue;
                            binding.MaxBufferPoolSize = int.MaxValue;

                            var datosCompromisos = clsws.obtenerCompromisosEntidades(idTablero, dep);
                            if (datosCompromisos != null)
                            {
                                if (datosCompromisos.compromisos != null)
                                {
                                    if (datosCompromisos.compromisos.Count() > 0)
                                    {
                                        numeroRegistros = numeroRegistros + datosCompromisos.compromisos.Count();
                                        foreach (var item in datosCompromisos.compromisos)
                                        {
                                            try
                                            {
                                                resultado = BD.I_CompromisoEntidadNacionalInsertUpdate(idTablero: item.idTablero, vigencia: item.vigencia, idPregunta: item.idPregunta, daneDepartamento: item.daneDepartamento, daneMunicipio: item.daneMunicipio, idEntidadNacional: item.idEntidadNacional, nombreEntidadNacional: item.nombreEntidadNacional, compromisoNivelNacional: item.compromisoNivelNacional, reporteCompromisos: item.reporteCompromisos, presupuestoNivelNacional: item.presupuestoNivelNacional, nombreProyectoInversion: item.nombreProyectoInversion, codBPINProyecto: item.codBPINProyecto, observaciones: item.observaciones).FirstOrDefault();
                                                if (resultado.estado != 1 && resultado.estado != 2)
                                                {
                                                    //ingresa en tabla de auditoria para saber que registro falla
                                                    string contenidoError = String.Format("Tablero: {0} - idPregunta: {1}- daneDepartamento: {2}- daneMunicipio: {3} - idEntidadNacional: {4} - compromisoNivelNacional:{5} - reporteCompromisos: {6} - PresupuestoNivelNacional: {7}- NombreProyectoInversion: {8} - CodBPINProyecto: {9}- Observaciones:{10}- nombreEntidadNacional:{11}", item.idTablero, item.idPregunta, item.daneDepartamento, item.daneMunicipio, item.idEntidadNacional, item.compromisoNivelNacional, item.reporteCompromisos, item.presupuestoNivelNacional, item.nombreProyectoInversion, item.codBPINProyecto, item.observaciones, item.nombreEntidadNacional);
                                                    resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: resultado.respuesta, datos: contenidoError).FirstOrDefault();
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                //ingresa en tabla de auditoria para saber que registro falla
                                                string contenidoError = String.Format("Tablero: {0} - idPregunta: {1}- daneDepartamento: {2}- daneMunicipio: {3} - idEntidadNacional: {4} - compromisoNivelNacional:{5} - reporteCompromisos: {6} - PresupuestoNivelNacional: {7}- NombreProyectoInversion: {8} - CodBPINProyecto: {9}- Observaciones:{10}- nombreEntidadNacional:{11}", item.idTablero, item.idPregunta, item.daneDepartamento, item.daneMunicipio, item.idEntidadNacional, item.compromisoNivelNacional, item.reporteCompromisos, item.presupuestoNivelNacional, item.nombreProyectoInversion, item.codBPINProyecto, item.observaciones, item.nombreEntidadNacional);
                                                resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: ex.Message, datos: contenidoError).FirstOrDefault();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //actualizacion de fecha finalizacion en auditorial
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: resultadoAuditoria.id, metodo: "obtenerCompromisosEntidades", numeroRegistros: numeroRegistros).FirstOrDefault();
                    }
                }
                else
                {
                    resultado.estado = 0;
                    resultado.respuesta = "Los servicios no se pueden consumir antes de las 6:00 pm por temas de rendimiento de Rusicst";
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                resultado.estado = 0;
                resultado.respuesta = ex.Message;
            }

            return resultado;
        }


        [HttpGet]
        [Route("api/TableroPat/IngresoSeguimientoEntidades/")]
        public C_AccionesResultado IngresoSeguimientoEntidades(int idTablero, int semestre = 1)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            C_AccionesResultado resultadoAuditoriaError = new C_AccionesResultado();
            C_AccionesResultadoInsert resultadoAuditoria = new C_AccionesResultadoInsert();
            int numeroRegistros = 0;
            try
            {
                if (DateTime.Now.Hour >= 18)
                {
                    ServiciosESignaProduccion.TableroPatWSClient clsws = new ServiciosESignaProduccion.TableroPatWSClient();

                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 3600;
                        //ingreso de auditoria
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: 0, metodo: String.Format("obtenerSeguimientoEntidades({0},{1})", idTablero, semestre), numeroRegistros: numeroRegistros).FirstOrDefault();

                        //se obtienen los departamentos
                        IEnumerable<C_ListaDeptosYMunicipios_Result> departamentos = Enumerable.Empty<C_ListaDeptosYMunicipios_Result>();
                        departamentos = BD.C_ListaDeptosYMunicipios().Cast<C_ListaDeptosYMunicipios_Result>().ToList().Distinct();
                        var listaDepartamentos = departamentos.Select(a => a.IdDepartamento).ToList().Distinct();
                        foreach (var dep in listaDepartamentos)
                        {
                            var datosseguimiento = clsws.obtenerSeguimientoEntidades(idTablero, dep, semestre);
                            var binding = new WSHttpBinding();
                            binding.MaxReceivedMessageSize = int.MaxValue;
                            binding.MaxBufferPoolSize = int.MaxValue;


                            if (datosseguimiento != null)
                            {
                                if (datosseguimiento.seguimientos != null)
                                {
                                    if (datosseguimiento.seguimientos.Count() > 0)
                                    {
                                        numeroRegistros = numeroRegistros + datosseguimiento.seguimientos.Count();
                                        foreach (var item in datosseguimiento.seguimientos)
                                        {
                                            try
                                            {
                                                resultado = BD.I_SeguimientoEntidadNacionalInsertUpdate(idTablero: item.idTablero, vigencia: item.vigencia, idPregunta: item.idPregunta, daneDepartamento: item.daneDepartamento, daneMunicipio: item.daneMunicipio, idEntidadNacional: item.idEntidadNacional, nombreEntidadNacional: item.nombreEntidadNacional, cantidadEjecutada: item.cantidadEjecutada, compromisoCumplido: item.compromisoCumplido, dificultadesEncontradas: item.dificultadesEncontradas, accionesParaSuperarDificultades: item.accionesParaSuperarDificultades, soporte: item.soporte, presupuestoEjecutado: item.presupuestoEjecutado, observaciones: item.observaciones, semestre: semestre).FirstOrDefault();
                                                if (resultado.estado != 1 && resultado.estado != 2)
                                                {
                                                    //ingresa en tabla de auditoria para saber que registro falla
                                                    string contenidoError = String.Format("Tablero: {0} - idPregunta: {1}- daneDepartamento: {2}- daneMunicipio: {3} - idEntidadNacional: {4} - CantidadEjecutada:{5} - CompromisoCumplido: {6} - DificultadesEncontradas: {7}- AccionesParaSuperarDificultades: {8} - Soporte: {9}- PresupuestoEjecutado: {10} -Observaciones: {11}- Semestre: {12}- nombreEntidadNacional {13} ", item.idTablero, item.idPregunta, item.daneDepartamento, item.daneMunicipio, item.idEntidadNacional, item.cantidadEjecutada, item.compromisoCumplido, item.dificultadesEncontradas, item.accionesParaSuperarDificultades, item.soporte, item.presupuestoEjecutado, item.observaciones, semestre, item.nombreEntidadNacional);
                                                    resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: resultado.respuesta, datos: contenidoError).FirstOrDefault();
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                //ingresa en tabla de auditoria para saber que registro falla
                                                string contenidoError = String.Format("Tablero: {0} - idPregunta: {1}- daneDepartamento: {2}- daneMunicipio: {3} - idEntidadNacional: {4} - CantidadEjecutada:{5} - CompromisoCumplido: {6} - DificultadesEncontradas: {7}- AccionesParaSuperarDificultades: {8} - Soporte: {9}- PresupuestoEjecutado: {10} -Observaciones: {11}- Semestre: {12}- nombreEntidadNacional {13} ", item.idTablero, item.idPregunta, item.daneDepartamento, item.daneMunicipio, item.idEntidadNacional, item.cantidadEjecutada, item.compromisoCumplido, item.dificultadesEncontradas, item.accionesParaSuperarDificultades, item.soporte, item.presupuestoEjecutado, item.observaciones, semestre, item.nombreEntidadNacional);
                                                resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: ex.Message, datos: contenidoError).FirstOrDefault();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //actualizacion de fecha finalizacion en auditorial
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: resultadoAuditoria.id, metodo: "obtenerSeguimientoEntidades", numeroRegistros: numeroRegistros).FirstOrDefault();
                    }
                }
                else
                {
                    resultado.estado = 0;
                    resultado.respuesta = "Los servicios no se pueden consumir antes de las 6:00 pm por temas de rendimiento de Rusicst";
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                resultado.estado = 0;
                resultado.respuesta = ex.Message;
            }

            return resultado;
        }
        #endregion

        #region APIS PARA EL CONSUMO DE LOS SERVICIOS WEB EXPUESTOS POR LA UNIDAD DE VICTIMAS DE LA GESTION Y SEGUIMIENTO DE LAS ENTIADES NACIONALES PARA REPARACION COLECTIVA Y RETORNOS Y REUBICACIONES
        [HttpGet]
        [Route("api/TableroPat/IngresoCompromisosRCEntidades/")]
        public C_AccionesResultado IngresoCompromisosRCEntidades(int idTablero = 1)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            C_AccionesResultado resultadoAuditoriaError = new C_AccionesResultado();
            C_AccionesResultadoInsert resultadoAuditoria = new C_AccionesResultadoInsert();
            int numeroRegistros = 0;
            try
            {
                if (DateTime.Now.Hour >= 18)
                {
                    var binding = new WSHttpBinding();
                    binding.MaxReceivedMessageSize = int.MaxValue;
                    binding.MaxBufferPoolSize = int.MaxValue;
                    ServiciosESignaProduccion.TableroPatWSClient clsws = new ServiciosESignaProduccion.TableroPatWSClient();

                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 3600;
                        //ingreso de auditoria
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: 0, metodo: String.Format("obtenerCompromisosEntidadesRC( {0} )", idTablero), numeroRegistros: numeroRegistros).FirstOrDefault();

                        //se obtienen los departamentos
                        IEnumerable<C_ListaDeptosYMunicipios_Result> departamentos = Enumerable.Empty<C_ListaDeptosYMunicipios_Result>();
                        departamentos = BD.C_ListaDeptosYMunicipios().Cast<C_ListaDeptosYMunicipios_Result>().ToList().Distinct();
                        var listaDepartamentos = departamentos.Select(a => a.IdDepartamento).ToList().Distinct();

                        foreach (var dep in listaDepartamentos)
                        {
                            var datosCompromisos = clsws.obtenerCompromisosEntidadesRC(idTablero, dep);
                            if (datosCompromisos != null)
                            {
                                if (datosCompromisos.compromisos != null)
                                {
                                    if (datosCompromisos.compromisos.Count() > 0)
                                    {
                                        numeroRegistros = numeroRegistros + datosCompromisos.compromisos.Count();
                                        foreach (var item in datosCompromisos.compromisos)
                                        {
                                            try
                                            {
                                                resultado = BD.I_CompromisoEntidadNacionalRCInsertUpdate(idTablero: item.idTablero, vigencia: item.vigencia, idPregunta: item.idPregunta, daneDepartamento: item.daneDepartamento, daneMunicipio: item.daneMunicipio, idEntidadNacional: item.idEntidadNacional, nombreEntidadNacional: item.nombreEntidadNacional, accionEntidadNacional: item.accionEntidadNacional, presupuestoNivelNacional: item.presupuestoNivelNacional).FirstOrDefault();
                                                if (resultado.estado != 1 && resultado.estado != 2)
                                                {
                                                    //ingresa en tabla de auditoria para saber que registro falla
                                                    string contenidoError = String.Format("Tablero: {0} - idPregunta: {1}- daneDepartamento: {2}- daneMunicipio: {3} - idEntidadNacional: {4} - accionEntidadNacional: {5} - PresupuestoNivelNacional: {6}- NombreProyectoInversion: {7} - nombreEntidadNacional:{8}", item.idTablero, item.idPregunta, item.daneDepartamento, item.daneMunicipio, item.idEntidadNacional, item.accionEntidadNacional, item.presupuestoNivelNacional, item.nombreEntidadNacional);
                                                    resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: resultado.respuesta, datos: contenidoError).FirstOrDefault();
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                //ingresa en tabla de auditoria para saber que registro falla
                                                string contenidoError = String.Format("Tablero: {0} - idPregunta: {1}- daneDepartamento: {2}- daneMunicipio: {3} - idEntidadNacional: {4} - accionEntidadNacional: {5} - PresupuestoNivelNacional: {6}- NombreProyectoInversion: {7} - nombreEntidadNacional:{8}", item.idTablero, item.idPregunta, item.daneDepartamento, item.daneMunicipio, item.idEntidadNacional, item.accionEntidadNacional, item.presupuestoNivelNacional, item.nombreEntidadNacional);
                                                resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: ex.Message, datos: contenidoError).FirstOrDefault();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //actualizacion de fecha finalizacion en auditorial
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: resultadoAuditoria.id, metodo: "obtenerCompromisosEntidadesRC", numeroRegistros: numeroRegistros).FirstOrDefault();
                    }
                }
                else
                {
                    resultado.estado = 0;
                    resultado.respuesta = "Los servicios no se pueden consumir antes de las 6:00 pm por temas de rendimiento de Rusicst";
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                resultado.estado = 0;
                resultado.respuesta = ex.Message;
            }

            return resultado;
        }

        [HttpGet]
        [Route("api/TableroPat/IngresoCompromisosRREntidades/")]
        public C_AccionesResultado IngresoCompromisosRREntidades(int idTablero = 1)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            C_AccionesResultado resultadoAuditoriaError = new C_AccionesResultado();
            C_AccionesResultadoInsert resultadoAuditoria = new C_AccionesResultadoInsert();
            int numeroRegistros = 0;
            try
            {
                if (DateTime.Now.Hour >= 18)
                {
                    ServiciosESignaProduccion.TableroPatWSClient clsws = new ServiciosESignaProduccion.TableroPatWSClient();
                    var binding = new WSHttpBinding();
                    binding.MaxReceivedMessageSize = int.MaxValue;
                    binding.MaxBufferPoolSize = int.MaxValue;

                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 3600;
                        //ingreso de auditoria
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: 0, metodo: String.Format("obtenerCompromisosEntidadesRR( {0} )", idTablero), numeroRegistros: numeroRegistros).FirstOrDefault();

                        //se obtienen los departamentos
                        IEnumerable<C_ListaDeptosYMunicipios_Result> departamentos = Enumerable.Empty<C_ListaDeptosYMunicipios_Result>();
                        departamentos = BD.C_ListaDeptosYMunicipios().Cast<C_ListaDeptosYMunicipios_Result>().ToList().Distinct();
                        var listaDepartamentos = departamentos.Select(a => a.IdDepartamento).ToList().Distinct();

                        foreach (var dep in listaDepartamentos)
                        {
                            var datosCompromisos = clsws.obtenerCompromisosEntidadesRR(idTablero, dep);
                            if (datosCompromisos != null)
                            {
                                if (datosCompromisos.compromisos != null)
                                {
                                    if (datosCompromisos.compromisos.Count() > 0)
                                    {
                                        numeroRegistros = numeroRegistros + datosCompromisos.compromisos.Count();
                                        foreach (var item in datosCompromisos.compromisos)
                                        {
                                            try
                                            {
                                                resultado = BD.I_CompromisoEntidadNacionalRRInsertUpdate(idTablero: item.idTablero, vigencia: item.vigencia, idPregunta: item.idPregunta, daneDepartamento: item.daneDepartamento, daneMunicipio: item.daneMunicipio, idEntidadNacional: item.idEntidadNacional, nombreEntidadNacional: item.nombreEntidadNacional, accionEntidadNacional: item.accionEntidadNacional, presupuestoNivelNacional: item.presupuestoNivelNacional).FirstOrDefault();
                                                if (resultado.estado != 1 && resultado.estado != 2)
                                                {
                                                    //ingresa en tabla de auditoria para saber que registro falla
                                                    string contenidoError = String.Format("Tablero: {0} - idPregunta: {1}- daneDepartamento: {2}- daneMunicipio: {3} - idEntidadNacional: {4} - accionEntidadNacional: {5} - PresupuestoNivelNacional: {6}- NombreProyectoInversion: {7} - nombreEntidadNacional:{8}", item.idTablero, item.idPregunta, item.daneDepartamento, item.daneMunicipio, item.idEntidadNacional, item.accionEntidadNacional, item.presupuestoNivelNacional, item.nombreEntidadNacional);
                                                    resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: resultado.respuesta, datos: contenidoError).FirstOrDefault();
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                //ingresa en tabla de auditoria para saber que registro falla
                                                string contenidoError = String.Format("Tablero: {0} - idPregunta: {1}- daneDepartamento: {2}- daneMunicipio: {3} - idEntidadNacional: {4} - accionEntidadNacional: {5} - PresupuestoNivelNacional: {6}- NombreProyectoInversion: {7} - nombreEntidadNacional:{8}", item.idTablero, item.idPregunta, item.daneDepartamento, item.daneMunicipio, item.idEntidadNacional, item.accionEntidadNacional, item.presupuestoNivelNacional, item.nombreEntidadNacional);
                                                resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: ex.Message, datos: contenidoError).FirstOrDefault();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //actualizacion de fecha finalizacion en auditorial
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: resultadoAuditoria.id, metodo: "obtenerCompromisosEntidadesRR", numeroRegistros: numeroRegistros).FirstOrDefault();
                    }
                }
                else
                {
                    resultado.estado = 0;
                    resultado.respuesta = "Los servicios no se pueden consumir antes de las 6:00 pm por temas de rendimiento de Rusicst";
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                resultado.estado = 0;
                resultado.respuesta = ex.Message;
            }

            return resultado;
        }


        [HttpGet]
        [Route("api/TableroPat/IngresoSeguimientoRCEntidades/")]
        public C_AccionesResultado IngresoSeguimientoRCEntidades(int idTablero, int semestre = 1)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            C_AccionesResultado resultadoAuditoriaError = new C_AccionesResultado();
            C_AccionesResultadoInsert resultadoAuditoria = new C_AccionesResultadoInsert();
            int numeroRegistros = 0;
            try
            {
                if (DateTime.Now.Hour >= 18)
                {
                    ServiciosESignaProduccion.TableroPatWSClient clsws = new ServiciosESignaProduccion.TableroPatWSClient();
                    var binding = new WSHttpBinding();
                    binding.MaxReceivedMessageSize = int.MaxValue;
                    binding.MaxBufferPoolSize = int.MaxValue;

                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 3600;
                        //ingreso de auditoria
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: 0, metodo: String.Format("obtenerSeguimientoEntidadesRC({0},{1})", idTablero, semestre), numeroRegistros: numeroRegistros).FirstOrDefault();

                        //se obtienen los departamentos
                        IEnumerable<C_ListaDeptosYMunicipios_Result> departamentos = Enumerable.Empty<C_ListaDeptosYMunicipios_Result>();
                        departamentos = BD.C_ListaDeptosYMunicipios().Cast<C_ListaDeptosYMunicipios_Result>().ToList().Distinct();
                        var listaDepartamentos = departamentos.Select(a => a.IdDepartamento).ToList().Distinct();
                        foreach (var dep in listaDepartamentos)
                        {
                            var datosseguimiento = clsws.obtenerSeguimientoEntidadesRC(idTablero, dep, semestre);
                            if (datosseguimiento != null)
                            {
                                if (datosseguimiento.seguimientos != null)
                                {
                                    if (datosseguimiento.seguimientos.Count() > 0)
                                    {
                                        numeroRegistros = numeroRegistros + datosseguimiento.seguimientos.Count();
                                        foreach (var item in datosseguimiento.seguimientos)
                                        {
                                            try
                                            {
                                                resultado = BD.I_SeguimientoRCEntidadNacionalInsertUpdate(idTablero: item.idTablero, vigencia: item.vigencia, idPregunta: item.idPregunta, daneDepartamento: item.daneDepartamento, daneMunicipio: item.daneMunicipio, idEntidadNacional: item.idEntidadNacional, nombreEntidadNacional: item.nombreEntidadNacional, avanceAccionEntidadNacional: item.avanceAccionEntidadNacional, compromisoCumplido: item.compromisoCumplido, dificultadesEncontradas: item.dificultadesEncontradas, accionesParaSuperarDificultades: item.accionesParaSuperarDificultades, soporte: item.soporte, presupuestoEjecutado: item.presupuestoEjecutado, observaciones: item.observaciones, semestre: semestre).FirstOrDefault();
                                                if (resultado.estado != 1 && resultado.estado != 2)
                                                {
                                                    //ingresa en tabla de auditoria para saber que registro falla
                                                    string contenidoError = String.Format("Tablero: {0} - idPregunta: {1}- daneDepartamento: {2}- daneMunicipio: {3} - idEntidadNacional: {4} - avanceAccionEntidadNacional {5} - CompromisoCumplido: {6} - DificultadesEncontradas: {7}- AccionesParaSuperarDificultades: {8} - Soporte: {9}- PresupuestoEjecutado: {10} -Observaciones: {11}- Semestre: {12}- nombreEntidadNacional {13} ", item.idTablero, item.idPregunta, item.daneDepartamento, item.daneMunicipio, item.idEntidadNacional, item.avanceAccionEntidadNacional, item.compromisoCumplido, item.dificultadesEncontradas, item.accionesParaSuperarDificultades, item.soporte, item.presupuestoEjecutado, item.observaciones, semestre, item.nombreEntidadNacional);
                                                    resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: resultado.respuesta, datos: item.nombreEntidadNacional).FirstOrDefault();
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                //ingresa en tabla de auditoria para saber que registro falla
                                                string contenidoError = String.Format("Tablero: {0} - idPregunta: {1}- daneDepartamento: {2}- daneMunicipio: {3} - idEntidadNacional: {4} - avanceAccionEntidadNacional {5} - CompromisoCumplido: {6} - DificultadesEncontradas: {7}- AccionesParaSuperarDificultades: {8} - Soporte: {9}- PresupuestoEjecutado: {10} -Observaciones: {11}- Semestre: {12}- nombreEntidadNacional {13} ", item.idTablero, item.idPregunta, item.daneDepartamento, item.daneMunicipio, item.idEntidadNacional, item.avanceAccionEntidadNacional, item.compromisoCumplido, item.dificultadesEncontradas, item.accionesParaSuperarDificultades, item.soporte, item.presupuestoEjecutado, item.observaciones, semestre, item.nombreEntidadNacional);
                                                resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: ex.Message, datos: contenidoError).FirstOrDefault();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //actualizacion de fecha finalizacion en auditorial
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: resultadoAuditoria.id, metodo: "obtenerSeguimientoEntidadesRC", numeroRegistros: numeroRegistros).FirstOrDefault();
                    }
                }
                else
                {
                    resultado.estado = 0;
                    resultado.respuesta = "Los servicios no se pueden consumir antes de las 6:00 pm por temas de rendimiento de Rusicst";
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                resultado.estado = 0;
                resultado.respuesta = ex.Message;
            }

            return resultado;
        }

        [HttpGet]
        [Route("api/TableroPat/IngresoSeguimientoRREntidades/")]
        public C_AccionesResultado IngresoSeguimientoRREntidades(int idTablero, int semestre = 1)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();
            C_AccionesResultado resultadoAuditoriaError = new C_AccionesResultado();
            C_AccionesResultadoInsert resultadoAuditoria = new C_AccionesResultadoInsert();
            int numeroRegistros = 0;
            try
            {
                if (DateTime.Now.Hour >= 18)
                {
                    ServiciosESignaProduccion.TableroPatWSClient clsws = new ServiciosESignaProduccion.TableroPatWSClient();
                    var binding = new WSHttpBinding();
                    binding.MaxReceivedMessageSize = int.MaxValue;
                    binding.MaxBufferPoolSize = int.MaxValue;
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 3600;
                        //ingreso de auditoria
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: 0, metodo: String.Format("obtenerSeguimientoEntidadesRR({0},{1})", idTablero, semestre), numeroRegistros: numeroRegistros).FirstOrDefault();

                        //se obtienen los departamentos
                        IEnumerable<C_ListaDeptosYMunicipios_Result> departamentos = Enumerable.Empty<C_ListaDeptosYMunicipios_Result>();
                        departamentos = BD.C_ListaDeptosYMunicipios().Cast<C_ListaDeptosYMunicipios_Result>().ToList().Distinct();
                        var listaDepartamentos = departamentos.Select(a => a.IdDepartamento).ToList().Distinct();
                        foreach (var dep in listaDepartamentos)
                        {
                            var datosseguimiento = clsws.obtenerSeguimientoEntidadesRR(idTablero, dep, semestre);
                            if (datosseguimiento != null)
                            {
                                if (datosseguimiento.seguimientos != null)
                                {
                                    if (datosseguimiento.seguimientos.Count() > 0)
                                    {
                                        numeroRegistros = numeroRegistros + datosseguimiento.seguimientos.Count();
                                        foreach (var item in datosseguimiento.seguimientos)
                                        {
                                            try
                                            {
                                                resultado = BD.I_SeguimientoRREntidadNacionalInsertUpdate(idTablero: item.idTablero, vigencia: item.vigencia, idPregunta: item.idPregunta, daneDepartamento: item.daneDepartamento, daneMunicipio: item.daneMunicipio, idEntidadNacional: item.idEntidadNacional, nombreEntidadNacional: item.nombreEntidadNacional, avanceAccionEntidadNacional: item.avanceAccionEntidadNacional, compromisoCumplido: item.compromisoCumplido, dificultadesEncontradas: item.dificultadesEncontradas, accionesParaSuperarDificultades: item.accionesParaSuperarDificultades, soporte: item.soporte, presupuestoEjecutado: item.presupuestoEjecutado, observaciones: item.observaciones, semestre: semestre).FirstOrDefault();
                                                if (resultado.estado != 1 && resultado.estado != 2)
                                                {
                                                    //ingresa en tabla de auditoria para saber que registro falla
                                                    string contenidoError = String.Format("Tablero: {0} - idPregunta: {1}- daneDepartamento: {2}- daneMunicipio: {3} - idEntidadNacional: {4} - avanceAccionEntidadNacional {5} - CompromisoCumplido: {6} - DificultadesEncontradas: {7}- AccionesParaSuperarDificultades: {8} - Soporte: {9}- PresupuestoEjecutado: {10} -Observaciones: {11}- Semestre: {12}- nombreEntidadNacional {13} ", item.idTablero, item.idPregunta, item.daneDepartamento, item.daneMunicipio, item.idEntidadNacional, item.avanceAccionEntidadNacional, item.compromisoCumplido, item.dificultadesEncontradas, item.accionesParaSuperarDificultades, item.soporte, item.presupuestoEjecutado, item.observaciones, semestre, item.nombreEntidadNacional);
                                                    resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: resultado.respuesta, datos: item.nombreEntidadNacional).FirstOrDefault();
                                                }
                                            }
                                            catch (Exception ex)
                                            {
                                                //ingresa en tabla de auditoria para saber que registro falla
                                                string contenidoError = String.Format("Tablero: {0} - idPregunta: {1}- daneDepartamento: {2}- daneMunicipio: {3} - idEntidadNacional: {4} - avanceAccionEntidadNacional {5} - CompromisoCumplido: {6} - DificultadesEncontradas: {7}- AccionesParaSuperarDificultades: {8} - Soporte: {9}- PresupuestoEjecutado: {10} -Observaciones: {11}- Semestre: {12}- nombreEntidadNacional {13} ", item.idTablero, item.idPregunta, item.daneDepartamento, item.daneMunicipio, item.idEntidadNacional, item.avanceAccionEntidadNacional, item.compromisoCumplido, item.dificultadesEncontradas, item.accionesParaSuperarDificultades, item.soporte, item.presupuestoEjecutado, item.observaciones, semestre, item.nombreEntidadNacional);
                                                resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: ex.Message, datos: contenidoError).FirstOrDefault();
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //actualizacion de fecha finalizacion en auditorial
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: resultadoAuditoria.id, metodo: "obtenerSeguimientoEntidadesRR", numeroRegistros: numeroRegistros).FirstOrDefault();
                    }
                }
                else
                {
                    resultado.estado = 0;
                    resultado.respuesta = "Los servicios no se pueden consumir antes de las 6:00 pm por temas de rendimiento de Rusicst";
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                resultado.estado = 0;
                resultado.respuesta = ex.Message;
            }

            return resultado;
        }

        #endregion

        #region APIS PARA EL CONSUMO DE LOS SERVICIOS WEB EXPUESTOS POR SIGO
        [HttpPost]
        [Route("api/TableroPat/ObtenerSeguimientoProgramas/")]
        public C_AccionesResultado ObtenerSeguimientoProgramas(ConsumoServiciosPAT model)
        {
            int ano = model.ano;
            int semestre = model.semestre;
            int idTablero = model.idTablero;

            C_AccionesResultado resultado = new C_AccionesResultado();
            C_AccionesResultado resultadoAuditoriaError = new C_AccionesResultado();
            C_AccionesResultadoInsert resultadoAuditoria = new C_AccionesResultadoInsert();
            int numeroRegistros = 0;
            try
            {
                //if (DateTime.Now.Hour >= 18)
                if (DateTime.Now.Hour >= 1)
                {
                    ServiciosSigo.OfertaServiceClient clsws = new ServiciosSigo.OfertaServiceClient();
                    var binding = new WSHttpBinding();
                    binding.MaxReceivedMessageSize = int.MaxValue;
                    binding.MaxBufferPoolSize = int.MaxValue;
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 3600;
                        //ingreso de auditoria
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: 0, metodo: String.Format("ObtenerSeguimientoProgramas({0},{1})", ano, semestre), numeroRegistros: numeroRegistros).FirstOrDefault();

                        var datosseguimiento = clsws.GetSeguimientoProgramasCaracterizados("Rusicst", "Rusicstvictimas2018", ano, semestre, 2);//2 porque es informacion territorial
                        if (datosseguimiento != null)
                        {
                            if (datosseguimiento != null)
                            {
                                if (datosseguimiento.Count() > 0)
                                {
                                    numeroRegistros = numeroRegistros + datosseguimiento.Count();
                                    foreach (var item in datosseguimiento)
                                    {
                                        try
                                        {
                                            bool acreditado = (item.ACREDITADO.Equals("SI")) ? true : false;
                                            resultado = BD.I_ProgramasSeguimientoSIGOInsertUpdate(tipo: item.TIPO, aNO: ano, numeroSeguimiento: semestre, idTablero: idTablero, numeroPrograma: item.NUMERO_PROGRAMA, nombrePrograma: item.NOMBRE_PROGRAMA, descripcionPrograma: item.DESCRIPCION_PROGRAMA, vigencia: item.VIGENCIA, acreditado: acreditado, numeroBeneficiaios: item.NUMEROBENEFICIARIOS, numeroVictimas: item.NUMEROVICTIMAS, estaEnTableroPAT: Convert.ToBoolean(item.ESTA_EN_TABLEROPAT), codigoDane: item.CODIGO_DANE, idPregunta: item.ID_PREGUNTA, idRespuesta: item.ID_RESPUESTA, idRespuestaPrograma: item.ID_RESPUESTA_PROGRAMA, idDerecho: item.ID_DERECHO, nivel: item.NIVEL).FirstOrDefault();
                                            if (resultado.estado != 1 && resultado.estado != 2)
                                            {
                                                //ingresa en tabla de auditoria para saber que registro falla
                                                string contenidoError = String.Format("TIPO: {0} - numeroPrograma: {1} - dane: {2}-  ", item.TIPO, item.NUMERO_PROGRAMA, item.CODIGO_DANE);
                                                resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: resultado.respuesta, datos: contenidoError).FirstOrDefault();
                                            }
                                        }
                                        catch (Exception ex)
                                        {
                                            //ingresa en tabla de auditoria para saber que registro falla
                                            string contenidoError = String.Format("TIPO: {0} - numeroPrograma: {1} - dane: {2}-  ", item.TIPO, item.NUMERO_PROGRAMA, item.CODIGO_DANE);
                                            resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: ex.Message, datos: contenidoError).FirstOrDefault();
                                        }
                                    }
                                }
                            }
                        }
                        //actualizacion de fecha finalizacion en auditorial
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: resultadoAuditoria.id, metodo: "ObtenerSeguimientoProgramas", numeroRegistros: numeroRegistros).FirstOrDefault();
                    }
                }
                else
                {
                    resultado.estado = 0;
                    resultado.respuesta = "Los servicios no se pueden consumir antes de las 6:00 pm por temas de rendimiento de Rusicst";
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                resultado.estado = 0;
                resultado.respuesta = ex.Message;
            }

            return resultado;
        }

        [HttpPost]
        [Route("api/TableroPat/ObtenerPrecargueAccesosEfectivoNecesidades/")]
        public C_AccionesResultado ObtenerPrecargueAccesosEfectivoNecesidades(ConsumoServiciosPAT model)
        {
            int ano = model.ano;
            int semestre = model.semestre;
            int idTablero = model.idTablero;

            C_AccionesResultado resultado = new C_AccionesResultado();
            C_AccionesResultado resultadoAuditoriaError = new C_AccionesResultado();
            C_AccionesResultadoInsert resultadoAuditoria = new C_AccionesResultadoInsert();
            int numeroRegistros = 0;
            try
            {
                //if (DateTime.Now.Hour >= 18)
                if (DateTime.Now.Hour >= 1)
                {
                    ServiciosSigo.OfertaServiceClient clsws = new ServiciosSigo.OfertaServiceClient();
                    var binding = new WSHttpBinding();
                    binding.MaxReceivedMessageSize = int.MaxValue;
                    binding.MaxBufferPoolSize = int.MaxValue;
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 3600;
                        //ingreso de auditoria
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: 0, metodo: String.Format("ObtenerPrecargueAccesosEfectivoNecesidades({0},{1})", ano, semestre), numeroRegistros: numeroRegistros).FirstOrDefault();
                        //borro todo lo de ese tablero
                        resultado = BD.D_AccesosEfectivosSeguimientoSIGODelete(idTablero: idTablero).FirstOrDefault();
                        if (resultado.estado == 3)
                        {
                            int mesInicial = (semestre == 1) ? 1 : 7;
                            int cantidadMeses = (semestre == 1) ? 7 : 12;


                            for (int mes = mesInicial; mes < cantidadMeses; mes++)
                            {
                                var datosseguimiento = clsws.GetAccesosEfectivosSegumiento("Rusicst", "Rusicstvictimas2018", ano, mes);
                                if (datosseguimiento != null)
                                {
                                    if (datosseguimiento != null)
                                    {
                                        if (datosseguimiento.Count() > 0)
                                        {
                                            numeroRegistros = numeroRegistros + datosseguimiento.Count();
                                            foreach (var item in datosseguimiento)
                                            {
                                                try
                                                {
                                                    resultado = BD.I_AccesosEfectivosSeguimientoSIGOInsert(fechaIngreso: item.FECHA_INGRESO, tipoDocumento: item.TIPO_DOCUMETO, numeroDocumento: Convert.ToDouble(item.NUMERO_DOCUMENTO), primerNombre: item.PRIMER_NOMBRE, segundoNombre: item.SEGUNDO_NOMBRE, primerApellido: item.PRIMER_APELLIDO, segundoApellido: item.SEGUNDO_APELLIDO, fechaNacimiento: item.FECHA_NACIMIENTO, idMedida: item.IDENTIFICADOR_MEDIDA, nombreMedida: item.NOMBRE_MEDIDA, idNecesidad: item.IDENTIFICADOR_NECESIDAD, nombreNecesidad: item.NOMBRE_NECESIDAD, codigoDane: item.CODIGO_DANE, municipio: item.MUNICIPIO, respuestaRetroalimentacion: item.RESPUESTA_RETROALIMENTACION, fechaAtencion: item.FECHA_ATENCION, idTablero: idTablero).FirstOrDefault();
                                                    if (resultado.estado != 1 && resultado.estado != 2)
                                                    {
                                                        //ingresa en tabla de auditoria para saber que registro falla
                                                        string contenidoError = String.Format("Tipo Documento: {0} - documento: {1} - dane: {2}- medida: {3} - necesidad: {4}-  ", item.TIPO_DOCUMETO, item.NUMERO_DOCUMENTO, item.CODIGO_DANE, item.NOMBRE_MEDIDA, item.NOMBRE_NECESIDAD);
                                                        resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: resultado.respuesta, datos: contenidoError).FirstOrDefault();
                                                    }
                                                }
                                                catch (Exception ex)
                                                {
                                                    //ingresa en tabla de auditoria para saber que registro falla
                                                    string contenidoError = String.Format("Tipo Documento: {0} - documento: {1} - dane: {2}- medida: {3} - necesidad: {4}-  ", item.TIPO_DOCUMETO, item.NUMERO_DOCUMENTO, item.CODIGO_DANE, item.NOMBRE_MEDIDA, item.NOMBRE_NECESIDAD);
                                                    resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: ex.Message, datos: contenidoError).FirstOrDefault();
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        //actualizacion de fecha finalizacion en auditorial
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: resultadoAuditoria.id, metodo: "ObtenerPrecargueAccesosEfectivoNecesidades", numeroRegistros: numeroRegistros).FirstOrDefault();
                    }
                }
                else
                {
                    resultado.estado = 0;
                    resultado.respuesta = "Los servicios no se pueden consumir antes de las 6:00 pm por temas de rendimiento de Rusicst";
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                resultado.estado = 0;
                resultado.respuesta = ex.Message;
            }

            return resultado;
        }

        [HttpPost]
        [Route("api/TableroPat/ObtenerPrecargueNecesidades/")]
        public C_AccionesResultado ObtenerPrecargueNecesidades(ConsumoServiciosPAT model)
        {
            int ano = model.ano;
            int idTablero = model.idTablero;
            DateTime fechaIni = model.fechaIni;
            DateTime fechaFin = model.fechaFin;

            C_AccionesResultado resultado = new C_AccionesResultado();
            C_AccionesResultado resultadoAuditoriaError = new C_AccionesResultado();
            C_AccionesResultadoInsert resultadoAuditoria = new C_AccionesResultadoInsert();
            int numeroRegistros = 0;
            try
            {
                //if (DateTime.Now.Hour >= 18)
                if (DateTime.Now.Hour >= 1)
                {
                    ServiciosSigo.OfertaServiceClient clsws = new ServiciosSigo.OfertaServiceClient();
                    var binding = new WSHttpBinding();
                    binding.MaxReceivedMessageSize = int.MaxValue;
                    binding.MaxBufferPoolSize = int.MaxValue;
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        BD.Database.CommandTimeout = 3600;
                        //ingreso de auditoria
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: 0, metodo: String.Format("ObtenerPrecargueNecesidades({0},{1},{2})", ano, fechaIni, fechaFin), numeroRegistros: numeroRegistros).FirstOrDefault();
                        //borro todo lo de ese tablero
                        resultado = BD.D_NecesidadesSIGODelete(idTablero: idTablero).FirstOrDefault();
                        if (resultado.estado == 3)
                        {
                            var datosseguimiento = clsws.GetNecesidadesPlaneacion("Rusicst", "Rusicstvictimas2018", ano, fechaIni, fechaFin);
                            if (datosseguimiento != null)
                            {
                                resultado.estado = 1;
                                if (datosseguimiento.Count() > 0)
                                {
                                    numeroRegistros = numeroRegistros + datosseguimiento.Count();
                                    foreach (var item in datosseguimiento)
                                    {
                                        try
                                        {
                                            resultado = BD.I_NecesdadesPlaneacionSIGOInsert(fechaNacimiento: Convert.ToString(item.FECHA_NACIMIENTO), fechaIngreso: Convert.ToString(item.FECHA_INGRESO), identificadorMedida: item.IDENTIFICADOR_MEDIDA, nombreMedida: item.NOMBRE_MEDIDA, identificadorNecesidad: item.IDENTIFICADOR_NECESIDAD, nombreNecesidad: item.NOMBRE_NECESIDAD, codigoDane: item.CODIGO_DANE, municipio: item.MUNICIPIO, idTablero: Convert.ToByte(idTablero), tipoDocumento: item.TIPO_DOCUMETO, numeroDocumento: Convert.ToDouble(item.NUMERO_DOCUMENTO), nombreVictima: item.NOMBRE_VICTIMA).FirstOrDefault();
                                            if (resultado.estado != 1 && resultado.estado != 2)
                                            {
                                                //ingresa en tabla de auditoria para saber que registro falla
                                                string contenidoError = String.Format("Tipo Documento: {0} - documento: {1} - dane: {2}- medida: {3} - necesidad: {4}-  ", item.TIPO_DOCUMETO, item.NUMERO_DOCUMENTO, item.CODIGO_DANE, item.NOMBRE_MEDIDA, item.NOMBRE_NECESIDAD);
                                                resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: resultado.respuesta, datos: contenidoError).FirstOrDefault();
                                            }
                                        }
                                        catch (Exception ex)
                                        {
                                            //ingresa en tabla de auditoria para saber que registro falla
                                            string contenidoError = String.Format("Tipo Documento: {0} - documento: {1} - dane: {2}- medida: {3} - necesidad: {4}-  ", item.TIPO_DOCUMETO, item.NUMERO_DOCUMENTO, item.CODIGO_DANE, item.NOMBRE_MEDIDA, item.NOMBRE_NECESIDAD);
                                            resultadoAuditoriaError = BD.I_AuditoriaConsumoErrorWSInsert(idAuditoria: resultadoAuditoria.id, error: ex.Message, datos: contenidoError).FirstOrDefault();
                                        }
                                    }

                                }
                            }
                        }
                        //actualizacion de fecha finalizacion en auditorial
                        resultadoAuditoria = BD.I_AuditoriaConsumoWSInsertUpdate(id: resultadoAuditoria.id, metodo: "ObtenerPrecargueNecesidades", numeroRegistros: numeroRegistros).FirstOrDefault();
                    }
                }
                else
                {
                    resultado.estado = 0;
                    resultado.respuesta = "Los servicios no se pueden consumir antes de las 6:00 pm por temas de rendimiento de Rusicst";
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                resultado.estado = 0;
                resultado.respuesta = ex.Message;
            }

            return resultado;
        }
        #endregion
    }
}