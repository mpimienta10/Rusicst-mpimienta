// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 08-15-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 08-15-2017
// ***********************************************************************
// <copyright file="ConfiguracionArchivosAyudaController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Sistema namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Sistema
{
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Aplicacion;
    using Mininterior.RusicstMVC.Aplicacion.Adjuntos;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Threading.Tasks;
    using System.Web.Http;

    /// <summary>
    /// Class ConfiguracionArchivosAyudaController.
    /// </summary>
    [Authorize]
    public class ConfiguracionArchivosAyudaController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los archivos de ayuda</returns>
        [Route("api/Sistema/ConfiguracionArchivosAyuda/")]
        public IEnumerable<AyudaModels> Get()
        {
            IEnumerable<AyudaModels> resultado = Enumerable.Empty<AyudaModels>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    List<C_ParametrosSistema_Result> datos = BD.C_ParametrosSistema("FilesAyuda", null).Cast<C_ParametrosSistema_Result>().ToList();

                    resultado = this.CargarDatos(datos);
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Inserta el archivo
        /// </summary>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/Sistema/ConfiguracionArchivosAyuda/Insertar")]
        public async Task<HttpResponseMessage> Insertar()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            if (!this.Request.Content.IsMimeMultipartContent())
            {
                this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Helpers.Utilitarios.GetMultipartProvider();
            var result = await this.Request.Content.ReadAsMultipartAsync(provider);

            AyudaModels model = (AyudaModels)Helpers.Utilitarios.GetFormData<AyudaModels>(result);

            string NombreArchivo = model.nombre;

            model.Id = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
            var File = new FileInfo(result.FileData.First().LocalFileName);

            //// Valida si tiene nombre el archivo, de lo contrario coloca el nombre del que se esta cargando
            NombreArchivo = null == NombreArchivo || string.IsNullOrEmpty(NombreArchivo) ? Path.GetFileNameWithoutExtension(model.Id) : NombreArchivo;
            Archivo.GuardarArchivoRepositorio(File, Archivo.pathHelpFiles, model.Id);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Carga del archivo que contiene el contador
                    List<C_ParametrosSistema_Result> Datos = BD.C_ParametrosSistema(SistemaGrupo.FilesAyuda, null).Cast<C_ParametrosSistema_Result>().ToList();
                    C_ParametrosSistema_Result Item = Datos.First(e => e.NombreParametro == SistemaGrupo.FilesAyuda + "." + Tipo.Count);
                    int Count = int.Parse(Item.ParametroValor);
                    Count++;

                    //// Obtiene en un string el FilesAyuda.File y el FilesAyuda.Name
                    string IdFile = SistemaGrupo.FilesAyuda + "." + Tipo.File + Count;
                    string IdName = SistemaGrupo.FilesAyuda + "." + Tipo.Name + Count;
                    string ParametroNombreCount = SistemaGrupo.FilesAyuda + "." + Tipo.Count;

                    //// Guarda el archivo
                    Resultado = BD.I_ParametrosSistemaInsert(idGrupo: Item.IdGrupo, nombreParametro: IdFile, parametroValor: model.Id).FirstOrDefault();

                    //// Valida si la inserción fué exitosa
                    if (Resultado.estado == (int)EstadoRespuesta.Insertado)
                    {
                        //// Guarda el nombre del archivo
                        Resultado = BD.I_ParametrosSistemaInsert(idGrupo: Item.IdGrupo, nombreParametro: IdName, parametroValor: NombreArchivo).FirstOrDefault();

                        //// Valida si la inserción fué exitosa
                        if (Resultado.estado == (int)EstadoRespuesta.Insertado)
                        {
                            //// actualiza el contador del archivo
                            Resultado = BD.U_ParametrosSistemaUpdate(idGrupo: Item.IdGrupo, nombreParametro: ParametroNombreCount, nombreParametroNuevo: null, parametroValor: (Count - 1).ToString(), parametroValorNuevo: Count.ToString()).FirstOrDefault();

                        }
                        else if (Resultado.estado == (int)EstadoRespuesta.Excepcion)
                        {
                            model.Excepcion = true;
                            model.ExcepcionMensaje = Resultado.respuesta;
                        }
                    }
                    else if (Resultado.estado == (int)EstadoRespuesta.Excepcion)
                    {
                        model.Excepcion = true;
                        model.ExcepcionMensaje = Resultado.respuesta;
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            finally
            {
                (new Providers.AuditExecuted(Category.CrearArchivoAyuda)).ActionExecutedManual(model);
            }

            //// Retorna la respuesta de la transacción
            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        /// <summary>
        /// Modifica el archivo
        /// </summary>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost]
        [Route("api/Sistema/ConfiguracionArchivosAyuda/Modificar")]
        public async Task<HttpResponseMessage> Modificar()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            if (!this.Request.Content.IsMimeMultipartContent())
            {
                this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Helpers.Utilitarios.GetMultipartProvider();
            var result = await this.Request.Content.ReadAsMultipartAsync(provider);
            AyudaModels model = (AyudaModels)Helpers.Utilitarios.GetFormData<AyudaModels>(result);

            string NombreArchivoActual = model.Titulo;
            string NombreArchivoNuevo = model.nombre;
            string Id = model.Id;

            var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
            var File = new FileInfo(result.FileData.First().LocalFileName);

            //// Valida si tiene nombre el archivo, de lo contrario coloca el nombre del que se esta cargando
            NombreArchivoNuevo = (null == NombreArchivoNuevo || string.IsNullOrEmpty(NombreArchivoNuevo)) ? Path.GetFileNameWithoutExtension(OriginalFileName) : NombreArchivoNuevo;
            Archivo.GuardarArchivoRepositorio(File, Archivo.pathHelpFiles, OriginalFileName);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Carga del archivo que contiene el contador
                    List<C_ParametrosSistema_Result> Datos = BD.C_ParametrosSistema(SistemaGrupo.FilesAyuda, null).Cast<C_ParametrosSistema_Result>().ToList();
                    C_ParametrosSistema_Result Item = Datos.First(e => e.NombreParametro == SistemaGrupo.FilesAyuda + "." + Tipo.Count);

                    //// Obtiene en un string el FilesAyuda.File y el FilesAyuda.Name
                    string IdFile = Datos.First(e => e.ParametroValor == Id).NombreParametro;
                    string IdName = Datos.First(e => e.ParametroValor == NombreArchivoActual).NombreParametro;

                    //// actualiza el archivo
                    Resultado = BD.U_ParametrosSistemaUpdate(idGrupo: Item.IdGrupo, nombreParametro: IdFile, nombreParametroNuevo: null, parametroValor: Id, parametroValorNuevo: OriginalFileName).FirstOrDefault();

                    //// Valida si la actualización fué exitosa
                    if (Resultado.estado == (int)EstadoRespuesta.Actualizado)
                    {
                        //// actualiza el nombre del archivo
                        Resultado = BD.U_ParametrosSistemaUpdate(idGrupo: Item.IdGrupo, nombreParametro: IdName, nombreParametroNuevo: null, parametroValor: NombreArchivoActual, parametroValorNuevo: NombreArchivoNuevo).FirstOrDefault();
                    }
                    else if (Resultado.estado == (int)EstadoRespuesta.Excepcion)
                    {
                        model.Excepcion = true;
                        model.ExcepcionMensaje = Resultado.respuesta;
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            finally
            {
                (new Providers.AuditExecuted(Category.EditarArchivoAyuda)).ActionExecutedManual(model);
            }

            //// Retorna la respuesta de la transacción
            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        [HttpPost]
        [Route("api/Sistema/ConfiguracionArchivosAyuda/ModificarNombre/")]
        public HttpResponseMessage ModificarNombre(AyudaModels ayuda)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Carga del archivo que contiene el contador
                    List<C_ParametrosSistema_Result> Datos = BD.C_ParametrosSistema(SistemaGrupo.FilesAyuda, null).Cast<C_ParametrosSistema_Result>().ToList();
                    C_ParametrosSistema_Result Item = Datos.First(e => e.NombreParametro == SistemaGrupo.FilesAyuda + "." + Tipo.Count);

                    //// Obtiene en un string el FilesAyuda.File y el FilesAyuda.Name
                    string IdFile = Datos.First(e => e.ParametroValor == ayuda.Id).NombreParametro;
                    string IdName = Datos.First(e => e.ParametroValor == ayuda.Titulo).NombreParametro;

                    //// actualiza el nombre del archivo
                    Resultado = BD.U_ParametrosSistemaUpdate(idGrupo: Item.IdGrupo, nombreParametro: IdName, nombreParametroNuevo: null, parametroValor: ayuda.Titulo, parametroValorNuevo: ayuda.nombre).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            //// Retorna la respuesta de la transacción
            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        /// <summary>
        /// Elimina el archivo
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost, AuditExecuted(Category.EliminarArchivoAyuda)]
        [Route("api/Sistema/ConfiguracionArchivosAyuda/Eliminar")]
        public C_AccionesResultado Eliminar(AyudaModels model)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //// Carga del archivo que contiene el contador
                    List<C_ParametrosSistema_Result> Datos = BD.C_ParametrosSistema(SistemaGrupo.FilesAyuda, null).Cast<C_ParametrosSistema_Result>().ToList();
                    C_ParametrosSistema_Result Item = Datos.First(e => e.NombreParametro == SistemaGrupo.FilesAyuda + "." + Tipo.Count);
                    int Count = int.Parse(Item.ParametroValor);

                    //// Carga el archivo que se quiere eliminar
                    C_ParametrosSistema_Result itemEliminar = Datos.First(e => e.ParametroValor == model.Id);
                    string strId = itemEliminar.NombreParametro.Substring((SistemaGrupo.FilesAyuda + "." + Tipo.File).Length, itemEliminar.NombreParametro.Length - (SistemaGrupo.FilesAyuda + "." + Tipo.File).Length);
                    int intId = int.Parse(strId);

                    //// Obtiene en un string el FilesAyuda.File y el FilesAyuda.Name
                    string IdFile = SistemaGrupo.FilesAyuda + "." + Tipo.File + strId;
                    string IdName = SistemaGrupo.FilesAyuda + "." + Tipo.Name + strId;
                    string ParametroNombreCount = SistemaGrupo.FilesAyuda + "." + Tipo.Count;

                    //// Elimina el archivo
                    Resultado = BD.D_ParametrosSistemaDelete(idGrupo: Item.IdGrupo, nombreParametro: IdFile).FirstOrDefault();

                    //// Elimina de la lista los dos ítems
                    Datos.RemoveAll(e => e.IdGrupo == Item.IdGrupo && (e.NombreParametro == IdFile || e.NombreParametro == IdName));

                    //// Valida si la eliminación fué exitosa
                    if (Resultado.estado == (int)EstadoRespuesta.Eliminado)
                    {
                        //// Elimina el nombre del archivo
                        Resultado = BD.D_ParametrosSistemaDelete(idGrupo: Item.IdGrupo, nombreParametro: IdName).FirstOrDefault();

                        //// Valida si la eliminación fué exitosa
                        if (Resultado.estado == (int)EstadoRespuesta.Eliminado)
                        {
                            if (intId < Count)
                            {
                                //// Recorre el ciclo y actualiza todos los archivos
                                for (int i = intId; i < Count; i++)
                                {
                                    C_ParametrosSistema_Result itemFileActual = Datos.First(e => e.NombreParametro == SistemaGrupo.FilesAyuda + "." + Tipo.File + (i + 1));
                                    C_ParametrosSistema_Result itemNameActual = Datos.First(e => e.NombreParametro == SistemaGrupo.FilesAyuda + "." + Tipo.Name + (i + 1));

                                    string itemFile = SistemaGrupo.FilesAyuda + "." + Tipo.File + (i);
                                    string itemName = SistemaGrupo.FilesAyuda + "." + Tipo.Name + (i);

                                    BD.U_ParametrosSistemaUpdate(idGrupo: Item.IdGrupo, nombreParametro: itemFileActual.NombreParametro, nombreParametroNuevo: itemFile, parametroValor: itemFileActual.ParametroValor, parametroValorNuevo: null);
                                    BD.U_ParametrosSistemaUpdate(idGrupo: Item.IdGrupo, nombreParametro: itemNameActual.NombreParametro, nombreParametroNuevo: itemName, parametroValor: itemNameActual.ParametroValor, parametroValorNuevo: null);
                                }
                            }

                            //// actualiza el parámetro count
                            BD.U_ParametrosSistemaUpdate(idGrupo: Item.IdGrupo, nombreParametro: ParametroNombreCount, nombreParametroNuevo: null, parametroValor: Count.ToString(), parametroValorNuevo: (Count - 1).ToString()).FirstOrDefault();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return Resultado;
        }

        /// <summary>
        /// Descargar Adjuntos.
        /// </summary>
        /// <param name="archivo">The archivo.</param>
        /// <param name="nombreArchivo">The nombre archivo.</param>
        /// <returns>FileResult.</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/Sistema/Download/")]
        public HttpResponseMessage Descargar(string archivo, string nombreArchivo)
        {
            try
            {
                return Archivo.Descargar(archivo, nombreArchivo, Archivo.pathHelpFiles);
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return null;
            }
        }

        /// <summary>
        /// Carga de datos.
        /// </summary>
        /// <param name="datos">Lista con los datos de parámetros.</param>
        /// <returns>Lista de datos</returns>
        private IEnumerable<AyudaModels> CargarDatos(List<C_ParametrosSistema_Result> datos)
        {
            List<AyudaModels> resultado = new List<Models.AyudaModels>();
            int Count = int.Parse(datos.First(e => e.NombreParametro == SistemaGrupo.FilesAyuda + "." + Tipo.Count).ParametroValor);
            datos = datos.Where(e => e.NombreParametro != SistemaGrupo.FilesAyuda + "." + Tipo.Count).ToList();

            for (int i = 1; i <= Count; i++)
            {
                AyudaModels item = new AyudaModels()
                {
                    Id = datos.First(e => e.NombreParametro == SistemaGrupo.FilesAyuda + "." + Tipo.File + i).ParametroValor,
                    Titulo = datos.First(e => e.NombreParametro == SistemaGrupo.FilesAyuda + "." + Tipo.Name + i).ParametroValor
                };

                resultado.Add(item);
            }

            resultado = resultado.OrderBy(e => e.Titulo).ToList();

            return resultado;
        }
    }
}