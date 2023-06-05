namespace Mininterior.RusicstMVC.Servicios.Controllers.Reportes
{
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Entidades;
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
        
    public class PrecargueRespuestasController : ApiController
    {
        [HttpPost]
        [Authorize]
        [Route("api/Reportes/PrecargueRespuestas/CargarArchivo")]
        public async Task<HttpResponseMessage> CargarArchivo()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();
            FileInfo FileAdjunto = null;
            string OriginalFileName = string.Empty;
            int EstadoResultado = 0;
            int cantidadPrecargue = 0;
            List<EncuestasBorrar> listaIdEncuestasBorradas = new List<EncuestasBorrar>();

            if (!Request.Content.IsMimeMultipartContent())
            {
                Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Utilitarios.GetMultipartProvider();
            var result = await Request.Content.ReadAsMultipartAsync(provider);

            PrecargueRespuestasModels model = (PrecargueRespuestasModels)Utilitarios.GetFormData<PrecargueRespuestasModels>(result);

            if (result.FileData.Count() > 0)
            {
                OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
                FileAdjunto = new FileInfo(result.FileData.First().LocalFileName);
                model.Archivo = File.ReadAllBytes(result.FileData.First().LocalFileName);
            }
            try
            {
                if (model.Archivo != null)
                {
                    List<DatosPrecargue> listaprecargue = EncuestaExcelUtils.ParseExcelPrecargueRespuestas(model);
                    var listaIdEncuestas = listaprecargue.Select(s => s.IdEncuesta).Distinct().ToList();

                    //var prueba = CargarListaPrecargueRespuestas(listaprecargue, model.AudUserName);

                    //SE BORRA TODO LO RELACIONADO A ESA ENCUESTA Y SE HACE EL GUARDADO DE DATOS EN LA BD
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        if (listaprecargue.Count() > 0)
                        {
                            using (var dbContextTransaction = BD.Database.BeginTransaction())
                            {
                                try
                                {
                                    if (listaIdEncuestas.Count() > 0)
                                    {
                                        Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
                                        var modelUsuario = new UsuariosModels { UserName = model.AudUserName };
                                        var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
                                        model.IdUsuarioGuardo = datosUsuario.FirstOrDefault().Id;

                                        //se borra toda la informacion de cada una de las encuestas relacionadas en el archivo
                                        foreach (var item in listaIdEncuestas)
                                        {
                                            Resultado = BD.D_PrecargueRespuestasDelete(idEncuesta: item).FirstOrDefault();
                                            if (Resultado.estado == 3)
                                            {
                                                EncuestasBorrar id = new EncuestasBorrar();
                                                id.IdEncuesta = item;
                                                listaIdEncuestasBorradas.Add(id);
                                            }
                                        }
                                        //si el proceso anterior es exitoso se insertan las respuetas que se quieren precargar
                                        if (Resultado.estado == 3 || Resultado.estado == 0)
                                        {
                                            foreach (var item in listaprecargue)
                                            {
                                                Resultado = BD.I_PrecargueRespuestaInsert(idUsuarioGuardo: model.IdUsuarioGuardo, idEncuesta: item.IdEncuesta, codigoHomologacion: item.CodigoHomologado, divipola: item.Divipola, valor: item.Valor, isHGL: false, userHGL: "").FirstOrDefault();
                                                if (Resultado.estado == 0)
                                                {
                                                    break;
                                                }
                                            }
                                        }
                                        if (Resultado.estado > 0)
                                        {
                                            dbContextTransaction.Commit();
                                            cantidadPrecargue = listaprecargue.Count();
                                            if (listaIdEncuestasBorradas.Count() > 0)
                                            {
                                                foreach (var item in listaIdEncuestasBorradas)
                                                {
                                                    item.AudUserName = model.AudUserName;
                                                    item.AddIdent = model.AddIdent;
                                                    item.UserNameAddIdent = model.UserNameAddIdent;
                                                    (new AuditExecuted(Category.BorroPrecargueRespuestasEncuestas)).ActionExecutedManual(item);
                                                }
                                            }
                                            model.DetalleMensaje = "Se ingresaron " + cantidadPrecargue.ToString() + " respuestas de las siguientes encuestas por medio del archivo de Excel:";
                                            foreach (var item in listaIdEncuestas)
                                            {
                                                model.DetalleMensaje = model.DetalleMensaje + item + ',';
                                            }

                                            (new AuditExecuted(Category.IngresoPrecargueRespuestasEncuestas)).ActionExecutedManual(model);
                                        }
                                        else
                                        {
                                            dbContextTransaction.Rollback();
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
                    }
                }
            }
            catch (Exception ex)
            {
                model.Excepcion = true;
                EstadoResultado = 0;
                Resultado.respuesta = model.ExcepcionMensaje = ex.Message;
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return this.Request.CreateResponse(HttpStatusCode.OK, new { EstadoResultado, Resultado.respuesta });
            }
            finally
            {
            }

            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta, cantidadPrecargue, listaIdEncuestasBorradas });
        }

        [AllowAnonymous]
        [HttpPost]
        [Route("api/Reportes/PrecargueRespuestas/CargarPrecargueHGL")]
        public C_AccionesResultado CargarPrecargueHGL(List<DatosPrecargue> listaprecargue, string userName)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();
            Resultado.estado = 0;
            Resultado.respuesta = "No se realizo ningun proceso";              
            int cantidadPrecargue = 0;
            PrecargueRespuestasModels model = new PrecargueRespuestasModels();
            model.AudUserName = userName;
            model.AddIdent = false;
            model.UserNameAddIdent = "";

            try
            {
                if (listaprecargue != null)
                {
                    var listaIdEncuestas = listaprecargue.Select(s => s.IdEncuesta).Distinct().ToList();
                    //SE BORRA TODO LO RELACIONADO A ESA ENCUESTA Y SE HACE EL GUARDADO DE DATOS EN LA BD
                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        if (listaprecargue.Count() > 0)
                        {
                            using (var dbContextTransaction = BD.Database.BeginTransaction())
                            {
                                try
                                {
                                    if (listaIdEncuestas.Count() > 0)
                                    {
                                        model.IdUsuarioGuardo = 0;

                                        foreach (var item in listaprecargue)
                                        {
                                            Resultado = BD.I_PrecargueRespuestaInsert(idUsuarioGuardo: null, idEncuesta: item.IdEncuesta, codigoHomologacion: item.CodigoHomologado, divipola: item.Divipola, valor: item.Valor, isHGL: true, userHGL: userName).FirstOrDefault();
                                            if (Resultado.estado == 0)
                                            {
                                                break;
                                            }
                                        }

                                        if (Resultado.estado > 0)
                                        {
                                            dbContextTransaction.Commit();
                                            cantidadPrecargue = listaprecargue.Count();

                                            model.DetalleMensaje = "Se ingresaron " + cantidadPrecargue.ToString() + " respuestas de las siguientes encuestas: ";
                                            foreach (var item in listaIdEncuestas)
                                            {
                                                model.DetalleMensaje = model.DetalleMensaje + item + ',';
                                            }

                                            (new AuditExecuted(Category.IngresoPrecargueRespuestasEncuestas)).ActionExecutedManual(model);
                                        }
                                        else
                                        {
                                            dbContextTransaction.Rollback();
                                        }
                                    }
                                    Resultado.estado = 1;
                                    Resultado.respuesta = "Proceso realizado exitosamente";
                                }
                                catch (Exception ex)
                                {
                                    dbContextTransaction.Rollback();
                                    (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                                    Resultado.estado = 0;
                                    Resultado.respuesta = ex.Message;
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                model.Excepcion = true;
                Resultado.respuesta = model.ExcepcionMensaje = ex.Message;
                Resultado.estado = 0;
                Resultado.respuesta = ex.Message;
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return Resultado;
            }
            return Resultado;
        }

        [AllowAnonymous]
        [HttpGet]
        [Route("api/Reportes/PrecargueRespuestas/TestHGL")]
        public C_AccionesResultado TestHGL(List<DatosPrecargue> listaprecargue, string userName)
        {
            C_AccionesResultado result = new C_AccionesResultado();

            result.estado = 1;
            result.respuesta = "cantidad: " + listaprecargue.Count.ToString() + " - Username: " + userName;

            return result;
        }
    }
}