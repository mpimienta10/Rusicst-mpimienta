// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 08-15-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-16-2017
// ***********************************************************************
// <copyright file="EncuestaController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Reportes namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Reportes
{
    using Aplicacion.Adjuntos;
    using Aplicacion.Seguridad;
    using ClosedXML.Excel;
    using Helpers;
    using Mininterior.RusicstMVC.Entidades;
    using Mininterior.RusicstMVC.Servicios.Lang;
    using Mininterior.RusicstMVC.Servicios.Models;
    using Providers;
    using reactive.commons;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text.RegularExpressions;
    using System.Threading.Tasks;
    using System.Web.Http;

    /// <summary>
    /// Class EncuestaController.
    /// </summary>
    [Authorize]
    public class EncuestaController : ApiController
    {
        /// <summary>
        /// Gets the diseño .
        /// </summary>
        /// <param name="model">entidad model.</param>
        /// <returns>C_EncuestaDiseno_Result</returns>
        [HttpPost]
        [Route("api/Reportes/Encuesta/ConsultaDisenoEncuesta")]
        public DibujarDisenoPreguntas ConsultaDisenoEncuesta(SeccionModels model)
        {
            //Implementar obtener usuario logeado por defecto
            int idUsuario = model.IdUsuario.HasValue ? model.IdUsuario.Value : 374;//ObtenerIdUsuarioLogeado(User.Identity.Name);

            IEnumerable<C_DibujarSeccion_Result> secciones = Enumerable.Empty<C_DibujarSeccion_Result>();
            IEnumerable<C_DibujarPreguntasSeccion_Result> preguntas = Enumerable.Empty<C_DibujarPreguntasSeccion_Result>();
            DibujarDisenoPreguntas _DibujarDP = new Models.DibujarDisenoPreguntas();
            IEnumerable<C_OpcionesXPregunta_Result> _OpcionPregunta = Enumerable.Empty<C_OpcionesXPregunta_Result>();
            IEnumerable<C_DibujarGlosario_Result> glosario = Enumerable.Empty<C_DibujarGlosario_Result>();
            PostCargado _Postcargados = new Models.PostCargado();
            PreguntaDesencadenantes _PregDes = new PreguntaDesencadenantes();

            List<PostCargadoControlesModel> preguntasControles = new List<PostCargadoControlesModel>();

            bool isConsulta = false;
            bool hasRespuesta = false;

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    secciones = BD.C_DibujarSeccion(idSeccion: model.Id, idUsuario: model.IdUsuario).Cast<C_DibujarSeccion_Result>().ToList();
                    glosario = BD.C_DibujarGlosario().Cast<C_DibujarGlosario_Result>().ToList();
                    preguntas = BD.C_DibujarPreguntasSeccion(idSeccion: model.Id, idUsuario: model.IdUsuario).Cast<C_DibujarPreguntasSeccion_Result>().ToList();
                    _DibujarDP._Secciones = secciones;
                    _DibujarDP._Glosario = glosario;

                    var validacion = BD.C_ValidarPermisoGuardadoSeccion(model.IdUsuario, model.Id).FirstOrDefault();
                    var hayRespuestas = BD.C_ValidarRespuestasXSeccion(model.Id, model.IdUsuario).FirstOrDefault();

                    if (validacion != null)
                    {
                        isConsulta = !validacion.UsuarioHabilitado.Value;
                    }

                    if (hayRespuestas.HasValue)
                    {
                        hasRespuesta = hayRespuestas.Value;
                    }

                    _DibujarDP.isConsulta = isConsulta;

                    for (int i = 0; i < preguntas.Count(); i++)
                    {
                        var _Pregunta = preguntas.ElementAt(i);

                        int _IdPregunta = _Pregunta.Id;
                        PreguntasOpciones _PreguntaOpciones = new PreguntasOpciones();
                        _PreguntaOpciones.Id = _Pregunta.Id;
                        _PreguntaOpciones.IdSeccion = _Pregunta.IdSeccion;
                        _PreguntaOpciones.Nombre = _Pregunta.Nombre;
                        _PreguntaOpciones.RowIndex = _Pregunta.RowIndex;
                        _PreguntaOpciones.ColumnIndex = _Pregunta.ColumnIndex;
                        _PreguntaOpciones.TipoPregunta = _Pregunta.TipoPregunta;
                        _PreguntaOpciones.Ayuda = _Pregunta.Ayuda;
                        _PreguntaOpciones.EsObligatoria = _Pregunta.EsObligatoria;
                        _PreguntaOpciones.EsMultiple = _Pregunta.EsMultiple;
                        _PreguntaOpciones.SoloSi = _Pregunta.SoloSi;
                        _PreguntaOpciones.Texto = _Pregunta.Texto;
                        _PreguntaOpciones.IdEncuesta = _Pregunta.IdEncuesta;
                        _PreguntaOpciones.TienePrecargue = _Pregunta.TienePrecargue;
                        _PreguntaOpciones.ValorPrecargue = _Pregunta.ValorPrecargue;


                        if (_Pregunta.TipoPregunta == "FECHA")
                        {
                            string parsedDate = "";

                            if (!string.IsNullOrEmpty(_Pregunta.Respuesta))
                            {
                                parsedDate = _Pregunta.Respuesta;
                            }

                            _PreguntaOpciones.Respuesta = parsedDate;
                        }
                        else if (_Pregunta.TipoPregunta == "ARCHIVO" && !string.IsNullOrEmpty(_Pregunta.Respuesta))
                        {
                            //Verificamos que exista el archivo en el fileserver de lo contrario no mostramos 
                            //ningun enlace de descarga
                            if (Archivo.ExisteArchivoShared(_Pregunta.Respuesta))
                                _PreguntaOpciones.Respuesta = Path.GetFileName(_Pregunta.Respuesta);
                            else
                                _PreguntaOpciones.Respuesta = "";
                        }
                        else
                        {
                            _PreguntaOpciones.Respuesta = _Pregunta.Respuesta;
                        }


                        if (!string.IsNullOrEmpty(_Pregunta.SoloSi) && !isConsulta)
                        {
                            var funcPreParsed = IFuncFactory.CreateFunc(_PreguntaOpciones.SoloSi);

                            var fctx = new FuncContext()
                            {
                                Username = User.Identity.Name
                                ,
                                IdUsuario = idUsuario
                                ,
                                Pregunta = _PreguntaOpciones
                                ,
                                isCallback = false
                                ,
                                callbackValue = ""
                                ,
                                idPreguntaCallback = 0
                                ,
                                hasAnswers = hasRespuesta
                                ,
                                isExec = _Pregunta.SoloSi.Contains("EXEC")
                                ,
                                execIdPregunta = _Pregunta.SoloSi.Contains("EXEC") ? _Pregunta.Id : 0
                                ,
                                datosPreControles = preguntasControles
                            };

                            var retVal = funcPreParsed.Invoke(fctx);

                            //resultado de validar el solosi
                            _PreguntaOpciones.Funciones = retVal;

                            preguntasControles = fctx.datosPreControles;
                        }

                        _OpcionPregunta = BD.C_OpcionesXPregunta(idPregunta: _IdPregunta).ToList();
                        _PreguntaOpciones.LOpciones = _OpcionPregunta;
                        _DibujarDP._Preguntas.Add(_PreguntaOpciones);                        
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return _DibujarDP;
        }

        /// <summary>
        /// Obteners the identifier usuario logeado.
        /// </summary>
        /// <param name="name">The name.</param>
        /// <returns>System.Int32.</returns>
        private int ObtenerIdUsuarioLogeado(string name)
        {
            int idUsuario = 0;

            using (EntitiesRusicst db = new EntitiesRusicst())
            {
                idUsuario = db.C_Usuario(null, null, null, null, null, name, null).First().Id;
            }

            return idUsuario;
        }

        /// <summary>
        /// _s the pregunta opciones1.
        /// </summary>
        /// <param name="_PregOpc">The _ preg opc.</param>
        /// <param name="_BD">The _ bd.</param>
        /// <param name="_SoloSi">The _ solo si.</param>
        /// <returns>PreguntasOpciones.</returns>
        private PreguntasOpciones _PreguntaOpciones1(PreguntasOpciones _PregOpc, EntitiesRusicst _BD, String _SoloSi)
        {
            PostCargado _Postcargados = new Models.PostCargado();
            PreguntaDesencadenantes _PregDes = new PreguntaDesencadenantes();

            try
            {
                var funcPreParsed = IFuncFactory.CreateFunc(_SoloSi);
                return _PregOpc;
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return _PregOpc;
        }

        /// <summary>
        /// Postcargadoes the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>PostCargados.</returns>
        [HttpPost]
        [Route("api/Reportes/Encuesta/Postcargado")]
        public PostCargados Postcargado(PostCargadoModels model)
        {
            PostCargados _PostCargados = new Models.PostCargados();
            List<PostCargado> listPost = new List<PostCargado>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    var preguntas = BD.C_ListadoPreguntasSoloSiXIdPregunta(model.Id).ToList();

                    for (int i = 0; i < preguntas.Count; i++)
                    {
                        var _Pregunta = preguntas.ElementAt(i);

                        int _IdPregunta = _Pregunta.Id;
                        PreguntasOpciones _PreguntaOpciones = new PreguntasOpciones();
                        _PreguntaOpciones.Id = _Pregunta.Id;
                        _PreguntaOpciones.IdSeccion = _Pregunta.IdSeccion;
                        _PreguntaOpciones.Nombre = _Pregunta.Nombre;
                        _PreguntaOpciones.RowIndex = _Pregunta.RowIndex;
                        _PreguntaOpciones.ColumnIndex = _Pregunta.ColumnIndex;
                        _PreguntaOpciones.TipoPregunta = _Pregunta.TipoPregunta;
                        _PreguntaOpciones.Ayuda = _Pregunta.Ayuda;
                        _PreguntaOpciones.EsObligatoria = _Pregunta.EsObligatoria;
                        _PreguntaOpciones.EsMultiple = _Pregunta.EsMultiple;
                        _PreguntaOpciones.SoloSi = _Pregunta.SoloSi;
                        _PreguntaOpciones.Texto = _Pregunta.Texto;
                        _PreguntaOpciones.IdEncuesta = _Pregunta.IdEncuesta;

                        _PreguntaOpciones.Respuesta = _Pregunta.Respuesta;

                        if (!string.IsNullOrEmpty(_Pregunta.SoloSi))
                        {
                            var funcPreParsed = IFuncFactory.CreateFunc(_PreguntaOpciones.SoloSi);

                            var fctx = new FuncContext()
                            {
                                Username = User.Identity.Name
                                ,
                                IdUsuario = model.IdUsuario
                                ,
                                Pregunta = _PreguntaOpciones
                                ,
                                isCallback = true
                                ,
                                callbackValue = model.Valor
                                ,
                                idPreguntaCallback = model.Id
                                ,
                                datosControles = model.datosControles
                            };

                            var retVal = funcPreParsed.Invoke(fctx);

                            //resultado de validar el solosi
                            _PreguntaOpciones.Funciones = retVal;
                        }


                        listPost.Add(new PostCargado { IdPregunta = _PreguntaOpciones.Id, Func = _PreguntaOpciones.Funciones.GetType().GetProperty("Func").GetValue(_PreguntaOpciones.Funciones, null).ToString(), Valor = _PreguntaOpciones.Funciones.GetType().GetProperty("Valor").GetValue(_PreguntaOpciones.Funciones, null) });
                    }

                    _PostCargados.LPostCargado = listPost;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return _PostCargados;
        }

        /// <summary>
        /// _s the pregunta opciones2.
        /// </summary>
        /// <param name="_PregDes">The _ preg DES.</param>
        /// <param name="_PostCargado">The _ post cargado.</param>
        /// <param name="_BD">The _ bd.</param>
        /// <param name="_SoloSi">The _ solo si.</param>
        /// <returns>PostCargados.</returns>
        private PostCargados _PreguntaOpciones2(PreguntaDesencadenantes _PregDes, PostCargado _PostCargado, EntitiesRusicst _BD, String _SoloSi)
        {
            PostCargados _PostCargados = new Models.PostCargados();

            try
            {
                var funcPreParsed = IFuncFactory.CreateFunc(_SoloSi);
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return _PostCargados;
        }

        /// <summary>
        /// Insertar una solicitud de usuario
        /// </summary>
        /// <returns>Estado y respuesta de la transacción.</returns>
        [AllowAnonymous]
        [HttpPost]
        [Route("api/Reportes/Encuesta/GuardarEncuesta")]
        public async Task<HttpResponseMessage> GuardarEncuesta()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            try
            {
                if (!this.Request.Content.IsMimeMultipartContent())
                {
                    this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
                }

                //// Obtener archivo multi-part
                var provider = Helpers.Utilitarios.GetMultipartProvider();
                var result = await this.Request.Content.ReadAsMultipartAsync(provider);

                var keysVal = result.FormData.Keys;
                int idUsuario = Convert.ToInt32(result.FormData.GetValues(keysVal[0].ToString()).FirstOrDefault());
                int idSeccion = Convert.ToInt32(result.FormData.GetValues(keysVal[1].ToString()).FirstOrDefault());

                string AudUserName = result.FormData.GetValues(keysVal[2].ToString()).FirstOrDefault();
                bool AddIdent = Convert.ToBoolean(result.FormData.GetValues(keysVal[3].ToString()).FirstOrDefault());
                string UserNameAddIdent = result.FormData.GetValues(keysVal[4].ToString()).FirstOrDefault();
                List<C_DatosPregunta_Result> preguntas = new List<C_DatosPregunta_Result>();

                bool isValid = false;

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    var validacion = BD.C_ValidarPermisoGuardadoSeccion(idUsuario, idSeccion).FirstOrDefault();

                    if (validacion != null)
                    {
                        isValid = validacion.UsuarioHabilitado.Value;
                    }
                }

                //// No debe permitir guardar
                if (isValid)
                {
                    //Nuevo - almacenar guardado de página (así no tenga respuestas)
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        C_AccionesResultado resultPagina = new C_AccionesResultado();
                        resultPagina = BD.I_RespuestaSeccionInsert(idUsuario, idSeccion).FirstOrDefault();

                        if(resultPagina.estado == 1)
                        {
                            //Auditar el guardado de la página (así no tenga respuestas)
                            GuardadoSeccionModel respPagina = new GuardadoSeccionModel() { IdSeccion = idSeccion, IdUsuario = idUsuario };
                            (new AuditExecuted(Category.GuardarPaginaEncuesta)).ActionExecutedManual(respPagina);
                        }                        
                    }

                    for (int i = 5; i < result.Contents.Count - result.FileData.Count; i += 3)
                    {
                        if (result.FormData.HasKeys())
                        {
                            var keys = result.FormData.Keys;
                            int Id;
                            String Valor;
                            bool aDelete;

                            using (EntitiesRusicst BD = new EntitiesRusicst())
                            {
                                Id = Convert.ToInt32(result.FormData.GetValues(keys[i].ToString()).FirstOrDefault());
                                Valor = result.FormData.GetValues(keys[i + 1].ToString()).FirstOrDefault();
                                aDelete = bool.Parse(result.FormData.GetValues(keys[i + 2].ToString()).FirstOrDefault());

                                //datos pregunta para validar tipo archivo
                                C_DatosPregunta_Result datosPreg = BD.C_DatosPregunta(Id).FirstOrDefault();
                                C_ObtenerDatosGuardadoArchivosEncuesta_Result datosFile = BD.C_ObtenerDatosGuardadoArchivosEncuesta(idUsuario, idSeccion).First();

                                //Concatenar idpregunta con el nombre de archivo
                                if (datosPreg.TipoPregunta == "ARCHIVO" && !aDelete)
                                {
                                    if(string.IsNullOrEmpty(datosPreg.SoloSi))
                                    {
                                        preguntas.Add(datosPreg);

                                        if (Valor.StartsWith(datosPreg.Id.ToString()))
                                        {
                                            Valor = Path.Combine(datosFile.Usuario, datosFile.Encuesta.ToString(), idSeccion.ToString(), Valor);
                                        }
                                        else
                                        {
                                            Valor = Path.Combine(datosFile.Usuario, datosFile.Encuesta.ToString(), idSeccion.ToString(), datosPreg.Id.ToString() + "-" + Valor);
                                        }
                                    } else
                                    {
                                        if(datosPreg.SoloSi.Contains("COPY"))
                                        {
                                            if (Valor.StartsWith(datosPreg.Id.ToString()))
                                            {
                                                Valor = Path.Combine(datosFile.Usuario, datosFile.Encuesta.ToString(), idSeccion.ToString(), Valor);
                                            }
                                            else
                                            {
                                                Valor = Path.Combine(datosFile.Usuario, datosFile.Encuesta.ToString(), idSeccion.ToString(), datosPreg.Id.ToString() + "-" + Valor);
                                            }

                                            preguntas.Add(datosPreg);

                                            BD.I_RespuestaEncuestaInsert(Id, Valor, idUsuario);
                                            RespuestaEncuestaModels respuesta = new RespuestaEncuestaModels() { Id = Id, Valor = Valor, IdUsuario = idUsuario, AudUserName = AudUserName, AddIdent = AddIdent, UserNameAddIdent = UserNameAddIdent };
                                            (new AuditExecuted(Category.CrearRespuestaEncuesta)).ActionExecutedManual(respuesta);
                                        } else
                                        {
                                            preguntas.Add(datosPreg);

                                            if (Valor.StartsWith(datosPreg.Id.ToString()))
                                            {
                                                Valor = Path.Combine(datosFile.Usuario, datosFile.Encuesta.ToString(), idSeccion.ToString(), Valor);
                                            }
                                            else
                                            {
                                                Valor = Path.Combine(datosFile.Usuario, datosFile.Encuesta.ToString(), idSeccion.ToString(), datosPreg.Id.ToString() + "-" + Valor);
                                            }
                                        }
                                    }                                                                     
                                }

                                //if(aDelete)
                                //{
                                //    Valor = "";
                                //}

                                if (!aDelete && datosPreg.IdTipoPregunta != 1)
                                {
                                    BD.I_RespuestaEncuestaInsert(Id, Valor, idUsuario);

                                    //// auditar el resultado de la inserción
                                    RespuestaEncuestaModels respuesta = new RespuestaEncuestaModels() { Id = Id, Valor = Valor, IdUsuario = idUsuario, AudUserName = AudUserName, AddIdent = AddIdent, UserNameAddIdent = UserNameAddIdent };
                                    (new AuditExecuted(Category.CrearRespuestaEncuesta)).ActionExecutedManual(respuesta);
                                }
                                else if (aDelete)
                                {
                                    //Se eliminan las respuestas vacias
                                    BD.D_RespuestaDelete(Id, idUsuario);
                                }
                            }

                        }                       

                        Resultado.estado = 1;
                        Resultado.respuesta = "La información del formulario se ha guardado correctamente.";
                    }

                    //adjuntar archivos despues de guardar respuestas
                    for (int j = 0; j < result.FileData.Count; j++)
                    {
                        var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData[j]);
                        var arc = new FileInfo(result.FileData[j].LocalFileName);
                        var archivo = File.ReadAllBytes(result.FileData[j].LocalFileName);

                        using (EntitiesRusicst BD = new EntitiesRusicst())
                        {
                            try
                            {
                                //// Carpeta Compartida en Sistema
                                C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();
                                C_ObtenerDatosGuardadoArchivosEncuesta_Result datosFile = BD.C_ObtenerDatosGuardadoArchivosEncuesta(idUsuario, idSeccion).First();

                                //Concatenar idpregunta con el nombre de archivo
                                OriginalFileName = preguntas.ElementAt(j).Id.ToString() + "-" + OriginalFileName;

                                string[] arrFileName = OriginalFileName.Split('-');

                                if(arrFileName[0].Equals(arrFileName[1]))
                                {
                                    OriginalFileName = string.Join("-", arrFileName.Skip(1));
                                }

                                string valRespuesta = Path.Combine(datosFile.Usuario, datosFile.Encuesta.ToString(), idSeccion.ToString(), OriginalFileName);

                                //// Guardar archivo en carpeta compartida
                                //Archivo.GuardarArchivoEncuesta(archivo, sistema.UploadDirectory, datosFile.Usuario, datosFile.Encuesta.ToString(), idSeccion.ToString(), OriginalFileName);

                                //Guardar respuesta de preguntas archivo solo despues de cargar el archivo -- 28032018

                                //// Guardar archivo en carpeta compartida -- network share
                                Archivo.GuardarArchivoEncuestaShared(archivo, sistema.UploadDirectory, datosFile.Usuario, datosFile.Encuesta.ToString(), idSeccion.ToString(), OriginalFileName);
                                
                                BD.I_RespuestaEncuestaInsert(preguntas.ElementAt(j).Id, valRespuesta, idUsuario);

                                //// auditar el resultado de la inserción
                                RespuestaEncuestaModels respuesta = new RespuestaEncuestaModels() { Id = preguntas.ElementAt(j).Id, Valor = valRespuesta, IdUsuario = idUsuario, AudUserName = AudUserName, AddIdent = AddIdent, UserNameAddIdent = UserNameAddIdent };
                                (new AuditExecuted(Category.CrearRespuestaEncuesta)).ActionExecutedManual(respuesta);

                            } catch(Exception ex)
                            {
                                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                            }
                            
                        }
                    }
                }
                else
                {
                    Resultado.estado = 0;
                    Resultado.respuesta = "La información del formulario no se ha guardado, debido a que la encuesta está vencida.";
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }



        [AllowAnonymous]
        [HttpGet]
        [Route("api/Reportes/Encuesta/EncuestaDownload/")]
        public HttpResponseMessage Descargar(string nombreArchivo, int idUsuario, int idSeccion, int idPregunta)
        {
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Carpeta Compartida en Sistema
                    C_ObtenerDatosGuardadoArchivosEncuesta_Result datosFile = BD.C_ObtenerDatosGuardadoArchivosEncuesta(idUsuario, idSeccion).First();

                    //string PathFinal = Path.Combine(datosFile.Usuario, datosFile.Encuesta.ToString(), idSeccion.ToString());
                    //string PathFinal = Path.GetFileName(nombreArchivo);
                    //return Archivo.DescargarEncuesta(nombreArchivo, PathFinal);
                    string PathFinal = Path.Combine(datosFile.Usuario, datosFile.Encuesta.ToString(), idSeccion.ToString());

                    if(datosFile.Encuesta < 77 || datosFile.Encuesta == 79 || datosFile.Encuesta == 80 || datosFile.Encuesta == 81)
                    {
                        var respuestaOld = BD.C_RespuestaXIdPreguntaUsuario(idPregunta, idUsuario).First();

                        if(respuestaOld != null)
                        {
                            PathFinal = Path.Combine(respuestaOld.Valor);
                        }

                        return Archivo.DescargarEncuestaSharedOld(PathFinal, nombreArchivo);
                    }

                    HttpResponseMessage responseArchivo = Archivo.DescargarEncuestaShared(PathFinal + '\\', nombreArchivo);

                    //No encontró el archivo (posible error de la ruta o de los 665 del copy mal)
                    if(responseArchivo.StatusCode == HttpStatusCode.BadRequest)
                    {
                        var respuestaOld = BD.C_RespuestaXIdPreguntaUsuario(idPregunta, idUsuario).First();

                        if (respuestaOld != null)
                        {
                            PathFinal = Path.Combine(respuestaOld.Valor);
                        }

                        responseArchivo = Archivo.DescargarEncuestaSharedOld(PathFinal, nombreArchivo);
                    }

                    return responseArchivo;
                    //return Archivo.Descargar(nombreArchivo, nombreArchivo, PathFinal + '\\');
                }                
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return null;
            }
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("api/Reportes/Encuesta/ConsultarRespuestaFile/")]
        public IEnumerable<C_ConsultarRespuestasArchivoFileServer_Result> ConsultarRespuestaFile()
        {
            IEnumerable<C_ConsultarRespuestasArchivoFileServer_Result> resultado = Enumerable.Empty<C_ConsultarRespuestasArchivoFileServer_Result>();
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Carpeta Compartida en Sistema
                    List<C_ConsultarRespuestasArchivoFileServer_Result> datosFile = BD.C_ConsultarRespuestasArchivoFileServer().ToList();

                    IEnumerable<C_ConsultarRespuestasArchivoFileServer_Result> NoEstan = Archivo.ConsultarArchivoFileServer(datosFile);

                    //foreach (var item in datosFile)
                    //{
                    //    string PathFinal = Path.Combine(item.Valor);
                    //    if (!Archivo.ConsultarArchivoFileServer(datosFile))
                    //        NoEstan.Add(item);
                    //}
                    //Prueba grilla local
                    //for (int i = 0; i < 10; i++)
                    //{
                    //    NoEstan.Add(datosFile[i]);
                    //} 

                    return NoEstan.Cast<C_ConsultarRespuestasArchivoFileServer_Result>().ToList();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return null;
            }
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("api/Reportes/Encuesta/DescargarExcelEncuesta/")]
        public HttpResponseMessage DescargarExcelEncuesta(int idUsuario, int idSeccion)
        {
            try
            {
                HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

                string tituloEncuesta = null;
                int index = 0;

                string folderPath = @"c:\temp";

                FileUtils.CreateDirectory(folderPath);
                var name = Guid.NewGuid().ToString();

                C_DatosSeccionDescarga_Result datosSeccion = new C_DatosSeccionDescarga_Result();
                IEnumerable<C_DibujarPreguntasSeccionExcel_Result> datosPreguntas = Enumerable.Empty<C_DibujarPreguntasSeccionExcel_Result>();
                C_ObtenerDatosGuardadoArchivosEncuesta_Result datosFile = new C_ObtenerDatosGuardadoArchivosEncuesta_Result();

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    datosSeccion = BD.C_DatosSeccionDescarga(idSeccion).FirstOrDefault();
                    datosPreguntas = BD.C_DibujarPreguntasSeccionExcel(idSeccion, idUsuario).ToList();
                    datosFile = BD.C_ObtenerDatosGuardadoArchivosEncuesta(idUsuario, idSeccion).First();
                }

                var finalfilename = Path.Combine(@"c:\temp", datosFile.Usuario + "-seccion" + idSeccion.ToString() + "-" + DateTime.Now.ToString("yyyy_MM_dd"));
                var filename = datosFile.Usuario + "-seccion" + idSeccion.ToString() + "-" + DateTime.Now.ToString("yyyy_MM_dd") + ".xlsx";

                tituloEncuesta = datosSeccion.Titulo;
                tituloEncuesta = _CleanTitle(tituloEncuesta);

                //ClosedXML Approach

                var wsName = _CleanTitle(datosSeccion.Titulo);
                wsName = wsName.Substring(0, wsName.Length < 31 ? wsName.Length : 31);

                //Workbook from seccion file
                var sourceWB = new XLWorkbook(_SaveBytesToTempFile(datosSeccion.Archivo.ToArray(), folderPath));

                //Final Workbook to download
                var finalWB = new XLWorkbook();

                //Copy worksheet 1 (Diseño) from source to final Workbook
                sourceWB.Worksheet(1).CopyTo(finalWB, wsName, 1);

                //Worksheet to work on
                var finalWS = finalWB.Worksheet(1);

                //Cell range used by Diseño
                var usableRange = finalWS.RangeUsed();
                var usableRows = usableRange.RowCount();
                var usableCols = usableRange.ColumnCount();


                //Clean Data from diseño worksheet
                for (int r = 1; r <= usableRows; r++)
                {
                    for (int c = 1; c <= usableCols; c++)
                    {
                        var texto = GetStringValue(finalWS, r, c);
                        if (Helpers.StringUtils.IsNotBlank(texto))
                        {
                            texto = texto.Trim();
                        }
                        else
                        {
                            texto = " ";
                        }

                        if (texto.StartsWith("%"))
                        {
                            texto = texto.Substring(texto.LastIndexOf('%') + 1);
                        }

                        texto = texto.Replace("[[", "");
                        texto = texto.Replace("]]", "");

                        if (Helpers.StringUtils.IsNotBlank(texto))
                        {
                            SetStringValue(finalWS, r, c, texto);
                        }
                        else
                        {
                            var cellValue = GetStringValue(finalWS, r, c);
                            if (Helpers.StringUtils.IsBlank(cellValue))
                                cellValue = "";
                            if (cellValue.Contains('%'))
                            {
                                SetStringValue(finalWS, r, c, " ");
                            }
                        }
                    }
                }

                //Put data from Answers
                foreach (var y in datosPreguntas)
                {
                    SetStringValue(
                        finalWS,
                        y.RowIndex.Value + 1,
                        y.ColumnIndex.Value + 1,
                        Helpers.StringUtils.IsNotBlank(y.Respuesta) ? y.Respuesta : " "
                    );
                }

                //Clean excess style 

                finalWS.Range(usableRows + 1, 1, usableRows + 50, usableCols + 50).Style.Fill.BackgroundColor = XLColor.NoColor;

                finalWS.Range(usableRows + 1, 1, usableRows + 50, usableCols + 50).Style.Border.OutsideBorder = XLBorderStyleValues.None;
                finalWS.Range(usableRows + 1, 1, usableRows + 50, usableCols + 50).Style.Border.OutsideBorderColor = XLColor.NoColor;

                finalWS.Range(usableRows + 1, 1, usableRows + 50, usableCols + 50).Style.Border.InsideBorder = XLBorderStyleValues.None;
                finalWS.Range(usableRows + 1, 1, usableRows + 50, usableCols + 50).Style.Border.InsideBorderColor = XLColor.NoColor;


                finalWS.Range(1, usableCols + 1, usableRows, usableCols + 50).Style.Fill.BackgroundColor = XLColor.NoColor;

                finalWS.Range(1, usableCols + 1, usableRows, usableCols + 50).Style.Border.OutsideBorder = XLBorderStyleValues.None;
                finalWS.Range(1, usableCols + 1, usableRows, usableCols + 50).Style.Border.OutsideBorderColor = XLColor.NoColor;

                finalWS.Range(1, usableCols + 1, usableRows, usableCols + 50).Style.Border.InsideBorder = XLBorderStyleValues.None;
                finalWS.Range(1, usableCols + 1, usableRows, usableCols + 50).Style.Border.InsideBorderColor = XLColor.NoColor;
                

                sourceWB = null;
                finalWB.SaveAs(finalfilename + ".xlsx");
                
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

        [AllowAnonymous]
        [HttpGet]
        [Route("api/Reportes/Encuesta/DescargarExcelEncuestaEtapa/")]
        public HttpResponseMessage DescargarExcelEncuestaEtapa(int idUsuario, int idEtapa, int idEncuesta)
        {
            try
            {
                HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

                string tituloEncuesta = null;
                int index = 0;

                string folderPath = @"c:\temp";

                FileUtils.CreateDirectory(folderPath);
                var name = Guid.NewGuid().ToString();

                C_DatosSeccionDescarga_Result datosSeccion = new C_DatosSeccionDescarga_Result();
                IEnumerable<C_DibujarPreguntasSeccionExcel_Result> datosPreguntas = Enumerable.Empty<C_DibujarPreguntasSeccionExcel_Result>();
                C_ObtenerDatosGuardadoArchivosEncuesta_Result datosFile = new C_ObtenerDatosGuardadoArchivosEncuesta_Result();
                IEnumerable<C_ListaSeccion_Result> seccionesEtapa = Enumerable.Empty<C_ListaSeccion_Result>();

                using (EntitiesRusicst db = new EntitiesRusicst())
                {
                    datosFile = db.C_ObtenerDatosGuardadoArchivosEncuesta(idUsuario, idEtapa).First();
                }

                var finalfilename = Path.Combine(@"c:\temp", datosFile.Usuario + "-etapa" + idEtapa.ToString() + "-" + DateTime.Now.ToString("yyyy_MM_dd"));
                var filename = datosFile.Usuario + "-etapa" + idEtapa.ToString() + "-" + DateTime.Now.ToString("yyyy_MM_dd") + ".xlsx";

                //Final Workbook to download
                var finalWB = new XLWorkbook();

                int indexWS = 1;

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    seccionesEtapa = BD.C_ListaSeccion(idEncuesta, idEtapa).ToList();

                    for(int i = 0; i < seccionesEtapa.Count(); i++)
                    {
                        var seccion = seccionesEtapa.ElementAt(i);

                        datosSeccion = BD.C_DatosSeccionDescarga(seccion.Id).FirstOrDefault();
                        datosPreguntas = BD.C_DibujarPreguntasSeccionExcel(seccion.Id, idUsuario).ToList();
                        
                        
                        tituloEncuesta = datosSeccion.Titulo;
                        tituloEncuesta = _CleanTitle(tituloEncuesta);

                        //ClosedXML Approach
                        var wsName = _CleanTitle(datosSeccion.Titulo);
                        wsName = wsName.Substring(0, wsName.Length < 31 ? wsName.Length : 31);


                        string sourceWBFilename = _SaveBytesToTempFile(datosSeccion.Archivo.ToArray(), folderPath);

                        //Workbook from seccion file
                        var sourceWB = new XLWorkbook(sourceWBFilename);
                        
                        //Copy worksheet 1 (Diseño) from source to final Workbook
                        sourceWB.Worksheet(1).CopyTo(finalWB, wsName, indexWS);

                        //Worksheet to work on
                        var finalWS = finalWB.Worksheet(indexWS);

                        //Cell range used by Diseño
                        var usableRange = finalWS.RangeUsed();
                        var usableRows = usableRange.RowCount();
                        var usableCols = usableRange.ColumnCount();


                        //Clean Data from diseño worksheet
                        for (int r = 1; r <= usableRows; r++)
                        {
                            for (int c = 1; c <= usableCols; c++)
                            {
                                var texto = GetStringValue(finalWS, r, c);
                                if (Helpers.StringUtils.IsNotBlank(texto))
                                {
                                    texto = texto.Trim();
                                }
                                else
                                {
                                    texto = " ";
                                }

                                if (texto.StartsWith("%"))
                                {
                                    texto = texto.Substring(texto.LastIndexOf('%') + 1);
                                }

                                texto = texto.Replace("[[", "");
                                texto = texto.Replace("]]", "");

                                if (Helpers.StringUtils.IsNotBlank(texto))
                                {
                                    SetStringValue(finalWS, r, c, texto);
                                }
                                else
                                {
                                    var cellValue = GetStringValue(finalWS, r, c);
                                    if (Helpers.StringUtils.IsBlank(cellValue))
                                        cellValue = "";
                                    if (cellValue.Contains('%'))
                                    {
                                        SetStringValue(finalWS, r, c, " ");
                                    }
                                }
                            }
                        }

                        //Put data from Answers
                        foreach (var y in datosPreguntas)
                        {
                            SetStringValue(
                                finalWS,
                                y.RowIndex.Value + 1,
                                y.ColumnIndex.Value + 1,
                                Helpers.StringUtils.IsNotBlank(y.Respuesta) ? y.Respuesta : " "
                            );
                        }
                        
                        sourceWB = null;

                        //delete temp file
                        File.Delete(sourceWBFilename);

                        indexWS++;

                        //Clean excess style 
                        finalWS.Range(usableRows + 1, 1, usableRows + 50, usableCols + 50).Style.Fill.BackgroundColor = XLColor.NoColor;

                        finalWS.Range(usableRows + 1, 1, usableRows + 50, usableCols + 50).Style.Border.OutsideBorder = XLBorderStyleValues.None;
                        finalWS.Range(usableRows + 1, 1, usableRows + 50, usableCols + 50).Style.Border.OutsideBorderColor = XLColor.NoColor;

                        finalWS.Range(usableRows + 1, 1, usableRows + 50, usableCols + 50).Style.Border.InsideBorder = XLBorderStyleValues.None;
                        finalWS.Range(usableRows + 1, 1, usableRows + 50, usableCols + 50).Style.Border.InsideBorderColor = XLColor.NoColor;


                        finalWS.Range(1, usableCols + 1, usableRows, usableCols + 50).Style.Fill.BackgroundColor = XLColor.NoColor;

                        finalWS.Range(1, usableCols + 1, usableRows, usableCols + 50).Style.Border.OutsideBorder = XLBorderStyleValues.None;
                        finalWS.Range(1, usableCols + 1, usableRows, usableCols + 50).Style.Border.OutsideBorderColor = XLColor.NoColor;

                        finalWS.Range(1, usableCols + 1, usableRows, usableCols + 50).Style.Border.InsideBorder = XLBorderStyleValues.None;
                        finalWS.Range(1, usableCols + 1, usableRows, usableCols + 50).Style.Border.InsideBorderColor = XLColor.NoColor;
                    }                    
                }
                
                finalWB.SaveAs(finalfilename + ".xlsx");

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


        private string _CleanTitle(string tituloEncuesta)
        {
            if (Helpers.StringUtils.IsBlank(tituloEncuesta))
                return "Sin nombre " + Guid.NewGuid().ToString();
            var str = Regex.Replace(tituloEncuesta, "[^a-zA-Z0-9áéíóúñÁÉÍÓÚÑ]", "");
            return str;
        }

        private static string _SaveBytesToTempFile(byte[] bytes, string folderPath)
        {
            string path = Path.Combine(folderPath, String.Format("{0}.xlsx", Guid.NewGuid().ToString()));
            File.WriteAllBytes(path, bytes);
            return path;
        }

        private string GetStringValue(IXLWorksheet WS, int row, int col)
        {
            string result = string.Empty;

            var value = WS.Cell(row, col).Value;

            if(value != null)
            {
                if(value is string)
                {
                    result = value.ToString();
                }
            }

            return result;
        }

        private void SetStringValue(IXLWorksheet WS, int row, int col, string value)
        {
            WS.Cell(row, col).Value = value;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con las secciones del plan de mejoramiento para diligenciar</returns>
        [HttpGet]
        [Route("api/Reportes/Encuesta/AutoevaluacionV1/DatosAutoevaluacion")]
        public IEnumerable<C_DibujarAutoEvaluacionV1_Result> GetAutoevaluacionV1(int idEncuesta, int idUsuario)
        {
            IEnumerable<C_DibujarAutoEvaluacionV1_Result> resultado = Enumerable.Empty<C_DibujarAutoEvaluacionV1_Result>();

            try
            {
                using (EntitiesRusicst bd = new EntitiesRusicst())
                {
                    resultado = bd.C_DibujarAutoEvaluacionV1(idEncuesta, idUsuario).ToList();
                }
            }
            catch (Exception ex)
            {
            }

            return resultado;
        }
    }
}