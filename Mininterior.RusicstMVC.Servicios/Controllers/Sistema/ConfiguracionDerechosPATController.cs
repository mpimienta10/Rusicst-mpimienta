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
    public class ConfiguracionDerechosPATController : ApiController
    {
        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los archivos de ayuda</returns>
        [HttpGet]
        [Route("api/Sistema/ConfiguracionDerechosPAT/TodosDerechos")]
        public IEnumerable<C_TodosDerechos_Result> TodosDerechos()
        {
            IEnumerable<C_TodosDerechos_Result> resultado = Enumerable.Empty<C_TodosDerechos_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_TodosDerechos().Cast<C_TodosDerechos_Result>().ToList();

                    //resultado = this.CargarDatos(datos);
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los archivos de ayuda</returns>
        [HttpGet]
        [Route("api/Sistema/ConfiguracionDerechosPAT/CargarParametros")]
        public IEnumerable<C_ConfiguracionDerechosPAT_Result> CargarParametros(byte Id)
        {
            IEnumerable<C_ConfiguracionDerechosPAT_Result> resultado = Enumerable.Empty<C_ConfiguracionDerechosPAT_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_ConfiguracionDerechosPAT(Id).Cast<C_ConfiguracionDerechosPAT_Result>().ToList();

                    //resultado = this.CargarDatos(datos);
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
        [Route("api/Sistema/ConfiguracionDerechosPAT/Insertar")]
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

            ConfigurarDerechosModel model = (ConfigurarDerechosModel)Helpers.Utilitarios.GetFormData<ConfigurarDerechosModel>(result);

            if (result.FileData.Count > 0)
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {                   
                    var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
                    var arc = new FileInfo(result.FileData.First().LocalFileName);
                    var archivo = File.ReadAllBytes(result.FileData.First().LocalFileName);
                    OriginalFileName = OriginalFileName.Replace('ñ', 'n').Replace('Ñ', 'N');

                    C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();
                    Archivo.GuardarArchivoConfiguracionPatShared(archivo, OriginalFileName, sistema.UploadDirectory, Archivo.pathConfigurarDerechosFiles);
                }
            }            
            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {

                    string sistemaGrupo = "";
                    //Se elige el Sistema Grupo
                    if (model.Papel == "gobernacion" && model.Tipo == "archivo")
                    {
                        sistemaGrupo = SistemaGrupo.FilesGobernacionDerechos;
                    }
                    else if (model.Papel == "gobernacion" && model.Tipo == "url")
                    {
                        sistemaGrupo = SistemaGrupo.UrlGobernacionDerechos;
                    }
                    else if (model.Papel == "alcaldia" && model.Tipo == "archivo")
                    {
                        sistemaGrupo = SistemaGrupo.FilesAlcaldiasDerechos;
                    }
                    else if (model.Papel == "alcaldia" && model.Tipo == "url")
                    {
                        sistemaGrupo = SistemaGrupo.UrlAlcaldiasDerechos;
                    }

                    //// Carga del archivo que contiene el contador
                    //List<C_ParametrosSistema_Result> Datos = BD.C_ParametrosSistema(sistemaGrupo, null).Cast<C_ParametrosSistema_Result>().ToList();
                    //C_ParametrosSistema_Result Item = Datos.First(e => e.NombreParametro == sistemaGrupo + "." + Tipo.Count);
                    //int Count = int.Parse(Item.ParametroValor);
                    //Count++;



                    //// Obtiene en un string el FilesAyuda.File y el FilesAyuda.Name
                    //string IdFile = sistemaGrupo + "." + Tipo.File + Count;
                    //string IdName = sistemaGrupo + "." + Tipo.Name + Count;
                    //string ParametroNombreCount = sistemaGrupo + "." + Tipo.Count;

                    //// Guarda el archivo
                    if (!model.EsModificar)
                    {
                        Resultado = BD.I_ConfiguracionDerechoPAT(idDerecho: model.IdDerecho, papel: model.Papel, tipo: model.Tipo, nombreParametro: sistemaGrupo, parametroValor: model.NombreParametro, texto: model.Texto, descripcion: model.Descripcion).FirstOrDefault();
                    }
                    else
                    {
                        Resultado = BD.U_ConfiguracionDerechosPAT(id: model.Id, nombreParametro: sistemaGrupo, parametroValor: model.NombreParametro, texto: model.Texto, descripcion: model.Descripcion).FirstOrDefault();

                    }



                    //// Valida si la inserción fué exitosa
                    //if (Resultado.estado == (int)EstadoRespuesta.Insertado)
                    //{
                    //    //// Guarda el nombre del archivo
                    //    Resultado = BD.(idGrupo: model.IdGrupo, papel: model.Papel, Tipo:  nombreParametro: IdName, parametroValor: NombreArchivo).FirstOrDefault();

                    //    //// Valida si la inserción fué exitosa
                    //    if (Resultado.estado == (int)EstadoRespuesta.Insertado)
                    //    {
                    //        //// actualiza el contador del archivo
                    //        Resultado = BD.U_ParametrosSistemaUpdate(idGrupo: Item.IdGrupo, nombreParametro: ParametroNombreCount, nombreParametroNuevo: null, parametroValor: (Count - 1).ToString(), parametroValorNuevo: Count.ToString()).FirstOrDefault();

                    //    }
                    //    else if (Resultado.estado == (int)EstadoRespuesta.Excepcion)
                    //    {
                    //        model.Excepcion = true;
                    //        model.ExcepcionMensaje = Resultado.respuesta;
                    //    }
                    //}
                    //else if (Resultado.estado == (int)EstadoRespuesta.Excepcion)
                    //{
                    //    model.Excepcion = true;
                    //    model.ExcepcionMensaje = Resultado.respuesta;
                    //}
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            finally
            {
                //(new Providers.AuditExecuted(Category.CrearArchivoAyuda)).ActionExecutedManual(model);
            }

            //// Retorna la respuesta de la transacción
            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los archivos de ayuda</returns>
        [HttpPost]
        [Route("api/Sistema/ConfiguracionDerechosPAT/InsertarModificarUrl")]
        public C_AccionesResultado InsertarModificarUrl(ConfigurarDerechosModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    string sistemaGrupo = "";
                    //Se elige el Sistema Grupo
                    if (model.Papel == "gobernacion" && model.Tipo == "archivo")
                    {
                        sistemaGrupo = SistemaGrupo.FilesGobernacionDerechos;
                    }
                    else if (model.Papel == "gobernacion" && model.Tipo == "url")
                    {
                        sistemaGrupo = SistemaGrupo.UrlGobernacionDerechos;
                    }
                    else if (model.Papel == "alcaldia" && model.Tipo == "archivo")
                    {
                        sistemaGrupo = SistemaGrupo.FilesAlcaldiasDerechos;
                    }
                    else if (model.Papel == "alcaldia" && model.Tipo == "url")
                    {
                        sistemaGrupo = SistemaGrupo.UrlAlcaldiasDerechos;
                    }
                    //// Guarda el archivo
                    if (!model.EsModificar)
                    {
                        resultado = BD.I_ConfiguracionDerechoPAT(idDerecho: model.IdDerecho, papel: model.Papel, tipo: model.Tipo, nombreParametro: sistemaGrupo, parametroValor: model.ParametroValor, texto: model.Texto, descripcion: model.Descripcion).FirstOrDefault();
                    }
                    else
                    {
                        resultado = BD.U_ConfiguracionDerechosPAT(id: model.Id, nombreParametro: sistemaGrupo, parametroValor: model.ParametroValor, texto: model.Texto, descripcion: model.Descripcion).FirstOrDefault();

                    }


                    //  resultado = this.CargarDatos(datos);
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los archivos de ayuda</returns>
        [HttpPost]
        [Route("api/Sistema/ConfiguracionDerechosPAT/ModificarTexto")]
        public C_AccionesResultado ModificarTexto(ConfigurarDerechosModel model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.U_DerechosPAT(idDerecho: model.IdDerecho, textoExplicativoGOB: model.TextoExplicativoGOB, textoExplicativoALC: model.TextoExplicativoALC, descripcionDetallada: model.DescripcionDetallada).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Elimina el archivo
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>C_AccionesResultado.</returns>
        [HttpPost] //, AuditExecuted(Category.EliminarArchivoAyuda)]
        [Route("api/Sistema/ConfiguracionDerechosPAT/Eliminar")]
        public C_AccionesResultado Eliminar(C_ConfiguracionDerechosPAT_Result model)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {

                    //// Elimina el archivo
                    Resultado = BD.D_ConfiguracionDerechosPAT(model.Id).FirstOrDefault();

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
        [Route("api/Sistema/ConfiguracionDerechosPAT/Descargar")]
        public HttpResponseMessage Descargar(string archivo)
        {
            try
            {
                return Archivo.DescargarEncuestaShared(Archivo.pathConfigurarDerechosFiles, archivo);
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