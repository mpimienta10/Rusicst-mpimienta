using Mininterior.RusicstMVC.Aplicacion.Seguridad;
using Mininterior.RusicstMVC.Entidades;
using Mininterior.RusicstMVC.Servicios.Helpers;
using Mininterior.RusicstMVC.Servicios.Models;
using Mininterior.RusicstMVC.Servicios.Providers;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Http;

namespace Mininterior.RusicstMVC.Servicios.Controllers.Reportes
{
    [Authorize]
    public class PrecargueSeguimientoPATController : ApiController
    {
        [HttpPost]
        [Route("api/Reportes/PrecargueSeguimientoPAT/CargarArchivo")]
        public async Task<HttpResponseMessage> CargarArchivo()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();
            FileInfo FileAdjunto = null;
            string OriginalFileName = string.Empty;
            int EstadoResultado = 0;
            int cantidadPrecargue = 0;
            List<PreguntaSegActualizar> listaIdEncuestasActualizadas = new List<PreguntaSegActualizar>();
            listaIdEncuestasActualizadas.Add(new PreguntaSegActualizar());

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
                    List<DatosPrecargueSeguimientoPAT> listaprecargue = EncuestaExcelUtils.ParseExcelPrecargueSeguimientoPAT(model);
                    //var listaIdEncuestas = listaprecargue.Select(s => s.IdPreguntaPat).Distinct().ToList();

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
                                    if (listaprecargue.Count() > 0)
                                    {
                                        Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
                                        var modelUsuario = new UsuariosModels { UserName = model.AudUserName };
                                        var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);
                                        model.IdUsuarioGuardo = datosUsuario.FirstOrDefault().Id;

                                        //se borra toda la informacion de cada una de las encuestas relacionadas en el archivo
                                        Resultado = BD.D_PrecargueSegxPreguntaMunicipio(0).FirstOrDefault();
                                        if (Resultado.estado == 3)
                                        {
                                            listaIdEncuestasActualizadas[0].AudUserName = model.AudUserName;
                                            listaIdEncuestasActualizadas[0].AddIdent = model.AddIdent;
                                            listaIdEncuestasActualizadas[0].UserNameAddIdent = model.UserNameAddIdent;
                                            (new AuditExecuted(Category.EliminoPrecargueSeguimientoPreguntasXmunicipio)).ActionExecutedManual(listaIdEncuestasActualizadas[0]);
                                        }      
                                        if (Resultado.estado == 0 || Resultado.estado == 3)
                                        {
                                            dbContextTransaction.Commit();
                                            cantidadPrecargue = listaprecargue.Count();
                                            model.DetalleMensaje = "Se precargaron " + cantidadPrecargue.ToString() + " registros de las siguientes preguntas por medio del archivo de Excel:";
                                            string eliminados = Resultado.respuesta;
                                            foreach (var item in listaprecargue)
                                            {
                                                Resultado = BD.I_PrecargueSegxPreguntaMunicipio(item.IdPreguntaPat, item.IdMunicipio, item.EntidadNacional, item.PlanCompromiso, item.PlanPresupuesto, item.SegCompromiso1, item.SegPresupuesto1, item.SegCompromiso2, item.SegPresupuesto2, item.Observaciones, item.Programas).FirstOrDefault();
                                                model.DetalleMensaje = model.DetalleMensaje + item.IdPreguntaPat + ',';
                                            }

                                            Resultado = BD.I_PrecargueArchivosSegInsert(OriginalFileName, model.Archivo).FirstOrDefault();
                                            Resultado.respuesta = model.DetalleMensaje + ' ' + eliminados;

                                            (new AuditExecuted(Category.IngresoPrecargueSeguimientoPreguntasXmunicipio)).ActionExecutedManual(model);
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
                Resultado.estado = 0;
                Resultado.respuesta = model.ExcepcionMensaje = ex.Message;
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado , Resultado.respuesta });
            }
            finally
            {
            }

            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta, cantidadPrecargue, listaIdEncuestasActualizadas });
        }
    }
}