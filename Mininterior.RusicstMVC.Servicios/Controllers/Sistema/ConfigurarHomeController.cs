// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-01-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 08-15-2017
// ***********************************************************************
// <copyright file="ConfigurarHomeController.cs" company="Ministerio del Interior">
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
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using System.Web;
    using System.Web.Http;

    /// <summary>
    /// Class ConfigurarHomeController.
    /// </summary>
    public class ConfigurarHomeController : ApiController
    {
        /// <summary>
        /// Images the application string.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>System.String.</returns>
        private string ImageAppString(string id)
        {
            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                //Carpeta de donde se cargan las Imagenes
                C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(SistemaGrupo.HeaderApp, "HeaderApp.ImagesFolder").First();

                //Carpeta Compartida en Sistema
                C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                var path = Path.Combine(sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), id);

                string mimeType = MimeMapping.GetMimeMapping(id);

                var ext = Path.GetExtension(path);

                var contents = File.ReadAllBytes(path);

                return System.Convert.ToBase64String(contents);
            }
        }

        /// <summary>
        /// Images the header string.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>System.String.</returns>
        private string ImageHeaderString(string id)
        {
            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                //Carpeta de donde se cargan las Imagenes
                C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(SistemaGrupo.HeaderGobierno, "HeaderGobierno.ImagesFolder").First();

                //Carpeta Compartida en Sistema
                C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                var path = Path.Combine(sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), id);

                string mimeType = MimeMapping.GetMimeMapping(id);

                var ext = Path.GetExtension(path);

                var contents = File.ReadAllBytes(path);

                return System.Convert.ToBase64String(contents);
            }
        }

        /// <summary>
        /// Images the rs string.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>System.String.</returns>
        private string ImageRSString(string id)
        {
            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                //Carpeta de donde se cargan las Imagenes
                C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(SistemaGrupo.SocialNetworks, "SocialNetworks.ImagesFolder").First();

                //Carpeta Compartida en Sistema
                C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                var path = Path.Combine(sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), id);

                string mimeType = MimeMapping.GetMimeMapping(id);

                var ext = Path.GetExtension(path);

                var contents = File.ReadAllBytes(path);

                return System.Convert.ToBase64String(contents);
            }
        }

        /// <summary>
        /// Images the gob string.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <returns>System.String.</returns>
        private string ImageGobString(string id)
        {
            using (EntitiesRusicst BD = new EntitiesRusicst())
            {
                //Carpeta de donde se cargan las Imagenes
                C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(SistemaGrupo.CreditosGobierno, "CreditosGobierno.ImagesFolder").First();

                //Carpeta Compartida en Sistema
                C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                var path = Path.Combine(sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), id);

                string mimeType = MimeMapping.GetMimeMapping(id);

                var ext = Path.GetExtension(path);

                var contents = File.ReadAllBytes(path);

                return System.Convert.ToBase64String(contents);
            }
        }

        /// <summary>
        /// Gets this instance.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <param name="type">The type.</param>
        /// <returns>Lista con los datos de configuracion del Home</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/Sistema/ImagenMint/")]
        public HttpResponseMessage GetImageMint(string id, int type)
        {
            var resultado = new HttpResponseMessage(HttpStatusCode.OK);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Imagen de acuerdo al parametro de llamada
                    C_ParametrosSistema_Result result = BD.C_ParametrosSistema(type == 1 ? SistemaGrupo.HeaderGobierno : SistemaGrupo.HeaderGobiernoLogin, id).First();

                    //Carpeta de donde se cargan las Imagenes
                    C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(type == 1 ? SistemaGrupo.HeaderGobierno : SistemaGrupo.HeaderGobiernoLogin, "HeaderGobierno.ImagesFolder").First();

                    //Carpeta Compartida en Sistema
                    C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                    var path = Path.Combine(sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), result.ParametroValor);

                    string mimeType = MimeMapping.GetMimeMapping(result.ParametroValor);

                    var ext = Path.GetExtension(path);

                    var contents = File.ReadAllBytes(path);

                    MemoryStream memoryStream = new MemoryStream(contents);
                    resultado.Content = new StreamContent(memoryStream);
                    resultado.Content.Headers.ContentType = new MediaTypeHeaderValue("image/" + ext);
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Gets the image rs.
        /// </summary>
        /// <param name="id">The identifier.</param>
        /// <param name="type">The type.</param>
        /// <returns>HttpResponseMessage.</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/Sistema/ImagenRS/")]
        public HttpResponseMessage GetImageRS(string id, int type)
        {
            var resultado = new HttpResponseMessage(HttpStatusCode.OK);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Imagen de acuerdo al parametro de llamada
                    C_ParametrosSistema_Result result = BD.C_ParametrosSistema(type == 1 ? SistemaGrupo.SocialNetworks : SistemaGrupo.SocialNetworksLogin, id).First();

                    //Carpeta de donde se cargan las Imagenes
                    C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(type == 1 ? SistemaGrupo.SocialNetworks : SistemaGrupo.SocialNetworksLogin, "SocialNetworks.ImagesFolder").First();

                    //Carpeta Compartida en Sistema
                    C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                    var path = Path.Combine(sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), result.ParametroValor);

                    string mimeType = MimeMapping.GetMimeMapping(result.ParametroValor);

                    var ext = Path.GetExtension(path);

                    var contents = File.ReadAllBytes(path);

                    MemoryStream memoryStream = new MemoryStream(contents);
                    resultado.Content = new StreamContent(memoryStream);
                    resultado.Content.Headers.ContentType = new MediaTypeHeaderValue("image/" + ext);
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
        /// <param name="id">The identifier.</param>
        /// <param name="type">The type.</param>
        /// <returns>Lista con los datos de configuracion del Home</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/Sistema/ImagenApp/")]
        public HttpResponseMessage GetImageApp(string id, int type)
        {
            var resultado = new HttpResponseMessage(HttpStatusCode.OK);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Imagen de acuerdo al parametro de llamada
                    C_ParametrosSistema_Result result = BD.C_ParametrosSistema(type == 1 ? SistemaGrupo.HeaderApp : SistemaGrupo.HeaderAppLogin, id).First();

                    //Carpeta de donde se cargan las Imagenes
                    C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(type == 1 ? SistemaGrupo.HeaderApp : SistemaGrupo.HeaderAppLogin, "HeaderApp.ImagesFolder").First();

                    //Carpeta Compartida en Sistema
                    C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                    var path = Path.Combine(sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), result.ParametroValor);

                    string mimeType = MimeMapping.GetMimeMapping(result.ParametroValor);

                    var ext = Path.GetExtension(path);

                    var contents = File.ReadAllBytes(path);

                    MemoryStream memoryStream = new MemoryStream(contents);
                    resultado.Content = new StreamContent(memoryStream);
                    resultado.Content.Headers.ContentType = new MediaTypeHeaderValue("image/" + ext);
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
        /// <param name="id">The identifier.</param>
        /// <param name="type">The type.</param>
        /// <returns>Lista con los datos de configuracion del Home</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/Sistema/ImagenGob/")]
        public HttpResponseMessage GetImageGob(string id, int type)
        {
            var resultado = new HttpResponseMessage(HttpStatusCode.OK);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Imagen de acuerdo al parametro de llamada
                    C_ParametrosSistema_Result result = BD.C_ParametrosSistema(type == 1 ? SistemaGrupo.CreditosGobierno : SistemaGrupo.CreditosGobiernoLogin, id).First();

                    //Carpeta de donde se cargan las Imagenes
                    C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(type == 1 ? SistemaGrupo.CreditosGobierno : SistemaGrupo.CreditosGobiernoLogin, "CreditosGobierno.ImagesFolder").First();

                    //Carpeta Compartida en Sistema
                    C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                    var path = Path.Combine(sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), result.ParametroValor);

                    string mimeType = MimeMapping.GetMimeMapping(result.ParametroValor);

                    var ext = Path.GetExtension(path);

                    var contents = File.ReadAllBytes(path);

                    MemoryStream memoryStream = new MemoryStream(contents);
                    resultado.Content = new StreamContent(memoryStream);
                    resultado.Content.Headers.ContentType = new MediaTypeHeaderValue("image/" + ext);
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
        /// <param name="id">The identifier.</param>
        /// <param name="type">The type.</param>
        /// <returns>Lista con los datos de configuracion del Home</returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/Sistema/ImagenSL/")]
        public HttpResponseMessage GetImageSL(string id, int type)
        {
            var resultado = new HttpResponseMessage(HttpStatusCode.OK);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Imagen de acuerdo al parametro de llamada
                    C_ParametrosSistema_Result result = BD.C_ParametrosSistema(type == 1 ? SistemaGrupo.BodySlider : SistemaGrupo.BodySliderLogin, id).First();

                    //Carpeta de donde se cargan las Imagenes
                    C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(type == 1 ? SistemaGrupo.BodySlider : SistemaGrupo.BodySliderLogin, "BodySlider.ImagesFolder").First();

                    //Carpeta Compartida en Sistema
                    C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                    var path = Path.Combine(sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), result.ParametroValor);

                    string mimeType = MimeMapping.GetMimeMapping(result.ParametroValor);

                    var ext = Path.GetExtension(path);

                    var contents = File.ReadAllBytes(path);

                    MemoryStream memoryStream = new MemoryStream(contents);
                    resultado.Content = new StreamContent(memoryStream);

                    if (ext.Contains("mp4"))
                    {
                        resultado.Content.Headers.ContentType = new MediaTypeHeaderValue("video/" + ext);
                        resultado.Content.Headers.ContentRange = new ContentRangeHeaderValue(0, memoryStream.Length);
                    }
                    else
                    {
                        resultado.Content.Headers.ContentType = new MediaTypeHeaderValue("image/" + ext);
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
        /// Gets this instance.
        /// </summary>
        /// <returns>Lista con los datos de configuracion del Home</returns>
        [HttpGet]
        [Route("api/Sistema/ConfiguracionHome/")]
        public ConfigurarHomeModel Get()
        {
            ConfigurarHomeModel resultado = new ConfigurarHomeModel();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Imagenes Header
                    resultado.ImageApp = BD.C_ParametrosSistema(SistemaGrupo.HeaderApp, "HeaderApp.Logo").First().ParametroValor;
                    resultado.ImageAppContent = ImageAppString(resultado.ImageApp);

                    resultado.ImageGob = BD.C_ParametrosSistema(SistemaGrupo.CreditosGobierno, "CreditosGobierno.LogoGobierno").First().ParametroValor;
                    resultado.ImageGobContent = ImageGobString(resultado.ImageGob);

                    resultado.ImageMint = BD.C_ParametrosSistema(SistemaGrupo.HeaderGobierno, "HeaderGobierno.LogoMin").First().ParametroValor;
                    resultado.ImageMintContent = ImageHeaderString(resultado.ImageMint);

                    resultado.ImagePais = BD.C_ParametrosSistema(SistemaGrupo.HeaderGobierno, "HeaderGobierno.LogoPais").First().ParametroValor;
                    resultado.ImagePaisContent = ImageHeaderString(resultado.ImagePais);

                    resultado.ImageVict = BD.C_ParametrosSistema(SistemaGrupo.HeaderGobierno, "HeaderGobierno.LogoVict").First().ParametroValor;
                    resultado.ImageVictContent = ImageHeaderString(resultado.ImageVict);

                    //Redes Sociales + Nombres
                    resultado.listRS = FetchSocialNetworks(BD.C_ParametrosSistema(SistemaGrupo.SocialNetworksList, null).ToList(), BD, 1);

                    //Texto Body
                    resultado.TextHome = BD.C_ParametrosSistema(SistemaGrupo.IndexBodyText, "Index.BodyText.HTMLCode").First().ParametroValor;

                    //Texto Footer
                    resultado.TextFooter = BD.C_ParametrosSistema(SistemaGrupo.Footer, "Footer.HTMLCode").First().ParametroValor;

                    //Enlaces Gobierno
                    resultado.CantidadEnlaces = int.Parse(BD.C_ParametrosSistema(SistemaGrupo.CreditosGobierno, "CreditosGobierno.Links.Count").First().ParametroValor);
                    resultado.listLinks = FetchEnlacesGobierno(resultado.CantidadEnlaces, BD, 1);

                    //Slider
                    resultado.cantidadSlides = int.Parse(BD.C_ParametrosSistema(SistemaGrupo.BodySlider, "BodySlider.ImageCount").First().ParametroValor);
                    resultado.listSlider = FetchSlider(resultado.cantidadSlides, BD, 1);
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        /// <summary>
        /// Modifica el archivo
        /// </summary>
        /// <returns>C_AccionesResultado.</returns>
        [Authorize]
        [HttpPost]
        [Route("api/Sistema/ConfiguracionHome/ModificarRS")]
        public async Task<HttpResponseMessage> ModificarRS()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            if (!this.Request.Content.IsMimeMultipartContent())
            {
                this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Helpers.Utilitarios.GetMultipartProvider();
            var result = await this.Request.Content.ReadAsMultipartAsync(provider);
            SocialNetwork model = (SocialNetwork)Helpers.Utilitarios.GetFormData<SocialNetwork>(result);

            var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
            var arc = new FileInfo(result.FileData.First().LocalFileName);

            var archivo = File.ReadAllBytes(result.FileData.First().LocalFileName);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //URL a actualizar
                    C_ParametrosSistema_Result urlParam = BD.C_ParametrosSistema(model.contentGroup, model.Url).First();

                    //Imagen a actualizar
                    C_ParametrosSistema_Result imgParam = BD.C_ParametrosSistema(model.contentGroup, model.Imagen).First();

                    //Carpeta a Guardar Imagen (Carpeta images por defecto)
                    C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(model.contentGroup, "SocialNetworks.ImagesFolder").First();

                    //Carpeta Compartida en Sistema
                    C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                    //Guardar archivo en carpeta compartida
                    Archivo.GuardarArchivoParametros(archivo, sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), model.imgID);

                    //Actualizar registro en tabla (url)
                    Resultado = BD.U_ParametrosSistemaUpdate(urlParam.IdGrupo, urlParam.NombreParametro, null, parametroValor: urlParam.ParametroValor, parametroValorNuevo: model.contentUrl).FirstOrDefault();

                    //// Valida si la inserción fué exitosa
                    if (Resultado.estado == (int)EstadoRespuesta.Actualizado)
                    {
                        //Actualizar registro en tabla (imagen)
                        Resultado = BD.U_ParametrosSistemaUpdate(imgParam.IdGrupo, imgParam.NombreParametro, null, parametroValor: imgParam.ParametroValor, parametroValorNuevo: model.imgID).FirstOrDefault();
                    }
                    else
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
                (new AuditExecuted(Category.EditarHomeRS)).ActionExecutedManual(model);
            }

            //// Retorna la respuesta de la transacción
            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        /// <summary>
        /// Modificars the mint.
        /// </summary>
        /// <returns>Task&lt;HttpResponseMessage&gt;.</returns>
        [Authorize]
        [HttpPost]
        [Route("api/Sistema/ConfiguracionHome/ModificarMint")]
        public async Task<HttpResponseMessage> ModificarMint()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            if (!this.Request.Content.IsMimeMultipartContent())
            {
                this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Helpers.Utilitarios.GetMultipartProvider();
            var result = await this.Request.Content.ReadAsMultipartAsync(provider);
            ConfigImagesModel model = (ConfigImagesModel)Helpers.Utilitarios.GetFormData<ConfigImagesModel>(result);

            var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
            var arc = new FileInfo(result.FileData.First().LocalFileName);

            var archivo = File.ReadAllBytes(result.FileData.First().LocalFileName);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Imagen a actualizar
                    C_ParametrosSistema_Result imgParam = BD.C_ParametrosSistema(model.group, model.key).First();

                    //Carpeta a Guardar Imagen (Carpeta images por defecto)
                    C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(model.group, "HeaderGobierno.ImagesFolder").First();

                    //Carpeta Compartida en Sistema
                    C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                    //Guardar archivo en carpeta compartida
                    Archivo.GuardarArchivoParametros(archivo, sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), model.value);

                    //Actualizar registro en tabla (imagen)
                    Resultado = BD.U_ParametrosSistemaUpdate(imgParam.IdGrupo, imgParam.NombreParametro, null, parametroValor: imgParam.ParametroValor, parametroValorNuevo: model.value).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            finally
            {
                (new AuditExecuted(Category.EditarHomeMint)).ActionExecutedManual(model);
            }

            //// Retorna la respuesta de la transacción
            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        /// <summary>
        /// Modificars the application.
        /// </summary>
        /// <returns>Task&lt;HttpResponseMessage&gt;.</returns>
        [Authorize]
        [HttpPost]
        [Route("api/Sistema/ConfiguracionHome/ModificarApp")]
        public async Task<HttpResponseMessage> ModificarApp()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            if (!this.Request.Content.IsMimeMultipartContent())
            {
                this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Helpers.Utilitarios.GetMultipartProvider();
            var result = await this.Request.Content.ReadAsMultipartAsync(provider);
            ConfigImagesModel model = (ConfigImagesModel)Helpers.Utilitarios.GetFormData<ConfigImagesModel>(result);

            var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
            var arc = new FileInfo(result.FileData.First().LocalFileName);

            var archivo = File.ReadAllBytes(result.FileData.First().LocalFileName);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Imagen a actualizar
                    C_ParametrosSistema_Result imgParam = BD.C_ParametrosSistema(model.group, model.key).First();

                    //Carpeta a Guardar Imagen (Carpeta images por defecto)
                    C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(model.group, "HeaderApp.ImagesFolder").First();

                    //Carpeta Compartida en Sistema
                    C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                    //Guardar archivo en carpeta compartida
                    Archivo.GuardarArchivoParametros(archivo, sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), model.value);

                    //Actualizar registro en tabla (imagen)
                    Resultado = BD.U_ParametrosSistemaUpdate(imgParam.IdGrupo, imgParam.NombreParametro, null, parametroValor: imgParam.ParametroValor, parametroValorNuevo: model.value).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            finally
            {
                (new AuditExecuted(Category.EditarHomeApp)).ActionExecutedManual(model);
            }

            //// Retorna la respuesta de la transacción
            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        /// <summary>
        /// Modificars the gob.
        /// </summary>
        /// <returns>Task&lt;HttpResponseMessage&gt;.</returns>
        [Authorize]
        [HttpPost]
        [Route("api/Sistema/ConfiguracionHome/ModificarGob")]
        public async Task<HttpResponseMessage> ModificarGob()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            if (!this.Request.Content.IsMimeMultipartContent())
            {
                this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Helpers.Utilitarios.GetMultipartProvider();
            var result = await this.Request.Content.ReadAsMultipartAsync(provider);
            ConfigImagesModel model = (ConfigImagesModel)Helpers.Utilitarios.GetFormData<ConfigImagesModel>(result);

            var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
            var arc = new FileInfo(result.FileData.First().LocalFileName);

            var archivo = File.ReadAllBytes(result.FileData.First().LocalFileName);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Imagen a actualizar
                    C_ParametrosSistema_Result imgParam = BD.C_ParametrosSistema(model.group, model.key).First();

                    //Carpeta a Guardar Imagen (Carpeta images por defecto)
                    C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(model.group, "CreditosGobierno.ImagesFolder").First();

                    //Carpeta Compartida en Sistema
                    C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                    //Guardar archivo en carpeta compartida
                    Archivo.GuardarArchivoParametros(archivo, sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), model.value);

                    //Actualizar registro en tabla (imagen)
                    Resultado = BD.U_ParametrosSistemaUpdate(imgParam.IdGrupo, imgParam.NombreParametro, null, parametroValor: imgParam.ParametroValor, parametroValorNuevo: model.value).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }
            finally
            {
                (new AuditExecuted(Category.EditarHomeGob)).ActionExecutedManual(model);
            }

            //// Retorna la respuesta de la transacción
            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        /// <summary>
        /// Modifica el archivo
        /// </summary>
        /// <returns>C_AccionesResultado.</returns>
        [Authorize]
        [HttpPost]
        [Route("api/Sistema/ConfiguracionHome/ModificarSL")]
        public async Task<HttpResponseMessage> ModificarSL()
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            if (!this.Request.Content.IsMimeMultipartContent())
            {
                this.Request.CreateResponse(HttpStatusCode.UnsupportedMediaType);
            }

            //// Obtener archivo multi-part
            var provider = Helpers.Utilitarios.GetMultipartProvider();
            var result = await this.Request.Content.ReadAsMultipartAsync(provider);
            Slider model = (Slider)Helpers.Utilitarios.GetFormData<Slider>(result);

            var OriginalFileName = Helpers.Utilitarios.GetDeserializedFileName(result.FileData.First());
            var arc = new FileInfo(result.FileData.First().LocalFileName);

            var archivo = File.ReadAllBytes(result.FileData.First().LocalFileName);

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //URL a actualizar
                    C_ParametrosSistema_Result urlParam = BD.C_ParametrosSistema(model.contentGroup, model.keyType).First();

                    //Imagen a actualizar
                    C_ParametrosSistema_Result imgParam = BD.C_ParametrosSistema(model.contentGroup, model.keyContent).First();

                    //Carpeta a Guardar Imagen (Carpeta images por defecto)
                    C_ParametrosSistema_Result folder = BD.C_ParametrosSistema(model.contentGroup, "BodySlider.ImagesFolder").First();

                    //Carpeta Compartida en Sistema
                    C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                    //Guardar archivo en carpeta compartida
                    Archivo.GuardarArchivoParametros(archivo, sistema.UploadDirectory, folder.ParametroValor.TrimStart(Path.DirectorySeparatorChar).TrimStart(Path.AltDirectorySeparatorChar), model.content);

                    //Actualizar registro en tabla (url)
                    Resultado = BD.U_ParametrosSistemaUpdate(urlParam.IdGrupo, urlParam.NombreParametro, null, parametroValor: urlParam.ParametroValor, parametroValorNuevo: model.type).FirstOrDefault();

                    //// Valida si la inserción fué exitosa
                    if (Resultado.estado == (int)EstadoRespuesta.Actualizado)
                    {
                        //Actualizar registro en tabla (imagen)
                        Resultado = BD.U_ParametrosSistemaUpdate(imgParam.IdGrupo, imgParam.NombreParametro, null, parametroValor: imgParam.ParametroValor, parametroValorNuevo: model.content).FirstOrDefault();
                    }
                    else
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
                (new AuditExecuted(Category.EditarHomeSl)).ActionExecutedManual(model);
            }

            //// Retorna la respuesta de la transacción
            return this.Request.CreateResponse(HttpStatusCode.OK, new { Resultado.estado, Resultado.respuesta });
        }

        /// <summary>
        /// Modifica el archivo
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [Authorize]
        [HttpPost, AuditExecuted(Category.EditarHomeTextoFooter)]
        [Route("api/Sistema/ConfiguracionHome/GuardarTextoFooterBody")]
        public C_AccionesResultado GuardarTextoFooterBody(ConfigBodyFooterText model)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Texto a actualizar
                    C_ParametrosSistema_Result param = BD.C_ParametrosSistema(model.group, model.key).First();

                    //Actualizar registro en tabla (url)
                    Resultado = BD.U_ParametrosSistemaUpdate(param.IdGrupo, param.NombreParametro, null, parametroValor: param.ParametroValor, parametroValorNuevo: model.value).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            //// Retorna la respuesta de la transacción
            return Resultado;
        }

        /// <summary>
        /// Modifica el archivo
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [Authorize]
        [HttpPost, AuditExecuted(Category.EditarHomeParametrosGobierno)]
        [Route("api/Sistema/ConfiguracionHome/GuardarParametroGobierno")]
        public C_AccionesResultado GuardarParametroGobierno(LinkGobierno model)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            int cantidad = 0;
            IEnumerable<EnlacesGobierno> listEnlaces = new List<EnlacesGobierno>();

            var keyUrl = "CreditosGobierno.Links.URL";
            var keyNombre = "CreditosGobierno.Links.Name";
            var keyColor = "CreditosGobierno.Links.Color";

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Cantidad de Enlaces previo Eliminación
                    var param = BD.C_ParametrosSistema(model.group, "CreditosGobierno.Links.Count").First();

                    cantidad = int.Parse(param.ParametroValor);
                    int newCount = cantidad + 1;

                    //Actualizamos valores de las llaves a crear
                    keyUrl = "CreditosGobierno.Links.URL" + newCount.ToString();
                    keyNombre = "CreditosGobierno.Links.Name" + newCount.ToString();
                    keyColor = "CreditosGobierno.Links.Color" + newCount.ToString();

                    //Insertar URL
                    BD.I_ParametrosSistemaInsert(param.IdGrupo, keyUrl, model.keyUrl);

                    //Insertar Nombre
                    BD.I_ParametrosSistemaInsert(param.IdGrupo, keyNombre, model.keyNombre);

                    //Insertar Color
                    BD.I_ParametrosSistemaInsert(param.IdGrupo, keyColor, model.keyColor);


                    //Actualizamos registro de cantidad
                    Resultado = BD.U_ParametrosSistemaUpdate(param.IdGrupo, param.NombreParametro, null, cantidad.ToString(), newCount.ToString()).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            //// Retorna la respuesta de la transacción
            return Resultado;
        }

        /// <summary>
        /// Modifica el archivo
        /// </summary>
        /// <param name="model">The model.</param>
        /// <returns>C_AccionesResultado.</returns>
        [Authorize]
        [HttpPost, AuditExecuted(Category.EliminarHomeParametrosGobierno)]
        [Route("api/Sistema/ConfiguracionHome/EliminarParametroGobierno")]
        public C_AccionesResultado EliminarParametroGobierno(LinkGobierno model)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();

            int cantidad = 0;
            IEnumerable<EnlacesGobierno> listEnlaces = new List<EnlacesGobierno>();

            var keyUrl = "CreditosGobierno.Links.URL";
            var keyNombre = "CreditosGobierno.Links.Name";
            var keyColor = "CreditosGobierno.Links.Color";

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Cantidad de Enlaces previo Eliminación
                    var param = BD.C_ParametrosSistema(model.group, "CreditosGobierno.Links.Count").First();

                    cantidad = int.Parse(param.ParametroValor);
                    int newCount = cantidad - 1;
                    int idNum = int.Parse(model.idNum);

                    //Actualizamos valores de las llaves a eliminar
                    keyUrl = "CreditosGobierno.Links.URL" + cantidad.ToString();
                    keyNombre = "CreditosGobierno.Links.Name" + cantidad.ToString();
                    keyColor = "CreditosGobierno.Links.Color" + cantidad.ToString();

                    //ReDO All Keys if Necessary
                    if (cantidad > idNum)
                    {
                        for (int i = 0; i < (cantidad - idNum); i++)
                        {
                            string val1 = BD.C_ParametrosSistema(model.group, "CreditosGobierno.Links.URL" + (i + (idNum + 1)).ToString()).First().ParametroValor;
                            string val2 = BD.C_ParametrosSistema(model.group, "CreditosGobierno.Links.Name" + (i + (idNum + 1)).ToString()).First().ParametroValor;
                            string val3 = BD.C_ParametrosSistema(model.group, "CreditosGobierno.Links.Color" + (i + (idNum + 1)).ToString()).First().ParametroValor;

                            BD.U_ParametrosSistemaUpdate(param.IdGrupo, "CreditosGobierno.Links.URL" + (i + idNum).ToString(), null, null, val1);
                            BD.U_ParametrosSistemaUpdate(param.IdGrupo, "CreditosGobierno.Links.Name" + (i + idNum).ToString(), null, null, val2);
                            BD.U_ParametrosSistemaUpdate(param.IdGrupo, "CreditosGobierno.Links.Color" + (i + idNum).ToString(), null, null, val3);
                        }
                    }

                    //Eliminar Ultimo Registro -- Ya se movieron todos los otros de lugar
                    BD.D_ParametrosSistemaDelete(param.IdGrupo, keyUrl);
                    BD.D_ParametrosSistemaDelete(param.IdGrupo, keyNombre);
                    BD.D_ParametrosSistemaDelete(param.IdGrupo, keyColor);

                    //Actualizar conteo de Enlaces
                    Resultado = BD.U_ParametrosSistemaUpdate(param.IdGrupo, param.NombreParametro, null, cantidad.ToString(), newCount.ToString()).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            //// Retorna la respuesta de la transacción
            return Resultado;
        }

        /// <summary>
        /// Fetches the enlaces gobierno.
        /// </summary>
        /// <param name="count">The count.</param>
        /// <param name="bD">The b d.</param>
        /// <param name="type">The type.</param>
        /// <returns>IEnumerable&lt;EnlacesGobierno&gt;.</returns>
        private IEnumerable<EnlacesGobierno> FetchEnlacesGobierno(int count, EntitiesRusicst bD, int type)
        {
            List<EnlacesGobierno> listEnlaces = new List<EnlacesGobierno>();

            for (int i = 1; i <= count; i++)
            {
                EnlacesGobierno gob = new EnlacesGobierno();

                gob.KeyColor = "CreditosGobierno.Links.Color" + i.ToString();
                gob.KeyNombre = "CreditosGobierno.Links.Name" + i.ToString(); ;
                gob.KeyUrl = "CreditosGobierno.Links.URL" + i.ToString(); ;

                gob.Color = bD.C_ParametrosSistema(type == 1 ? SistemaGrupo.CreditosGobierno : SistemaGrupo.CreditosGobiernoLogin, gob.KeyColor).First().ParametroValor;
                gob.Nombre = bD.C_ParametrosSistema(type == 1 ? SistemaGrupo.CreditosGobierno : SistemaGrupo.CreditosGobiernoLogin, gob.KeyNombre).First().ParametroValor;
                gob.Url = bD.C_ParametrosSistema(type == 1 ? SistemaGrupo.CreditosGobierno : SistemaGrupo.CreditosGobiernoLogin, gob.KeyUrl).First().ParametroValor;

                gob.idNum = i;

                listEnlaces.Add(gob);
            }

            return listEnlaces;
        }

        /// <summary>
        /// Fetches the social networks.
        /// </summary>
        /// <param name="list1">The list1.</param>
        /// <param name="bD">The b d.</param>
        /// <param name="type">The type.</param>
        /// <returns>IEnumerable&lt;SocialNetwork&gt;.</returns>
        private IEnumerable<SocialNetwork> FetchSocialNetworks(List<C_ParametrosSistema_Result> list1, EntitiesRusicst bD, int type)
        {
            List<SocialNetwork> listRS = new List<SocialNetwork>();

            foreach (var item in list1)
            {
                SocialNetwork rs = new SocialNetwork();

                rs.Nombre = item.ParametroValor;
                rs.Url = "SocialNetworks." + item.ParametroValor.Replace("+", "Plus") + ".URL";
                rs.Imagen = "SocialNetworks." + item.ParametroValor.Replace("+", "Plus") + ".Image";
                rs.imgID = "img" + item.ParametroValor.Replace("+", "Plus");
                rs.contentGroup = type == 1 ? SistemaGrupo.SocialNetworks : SistemaGrupo.SocialNetworksLogin;

                rs.ImageContent = ImageRSString(bD.C_ParametrosSistema(type == 1 ? SistemaGrupo.SocialNetworks : SistemaGrupo.SocialNetworksLogin, rs.Imagen).First().ParametroValor);

                rs.contentUrl = bD.C_ParametrosSistema(type == 1 ? SistemaGrupo.SocialNetworks : SistemaGrupo.SocialNetworksLogin, rs.Url).First().ParametroValor;

                if (!rs.contentUrl.StartsWith("http"))
                {
                    rs.contentUrl = "http://" + rs.contentUrl;
                }

                listRS.Add(rs);
            }

            return listRS;
        }

        /// <summary>
        /// Fetches the slider.
        /// </summary>
        /// <param name="count">The count.</param>
        /// <param name="bD">The b d.</param>
        /// <param name="type">The type.</param>
        /// <returns>IEnumerable&lt;Slider&gt;.</returns>
        private IEnumerable<Slider> FetchSlider(int count, EntitiesRusicst bD, int type)
        {
            List<Slider> listSL = new List<Slider>();

            for (int i = 1; i <= count; i++)
            {
                Slider slide = new Slider();

                slide.keyContent = "BodySlider.Slide" + i.ToString() + ".Content";
                slide.keyType = "BodySlider.Slide" + i.ToString() + ".Type";
                slide.contentGroup = type == 1 ? SistemaGrupo.BodySlider : SistemaGrupo.BodySliderLogin;

                slide.content = bD.C_ParametrosSistema(type == 1 ? SistemaGrupo.BodySlider : SistemaGrupo.BodySliderLogin, slide.keyContent).First().ParametroValor;
                slide.type = bD.C_ParametrosSistema(type == 1 ? SistemaGrupo.BodySlider : SistemaGrupo.BodySliderLogin, slide.keyType).First().ParametroValor;

                slide.idNum = i;

                if (i == 1)
                {
                    slide.cssClass = "item active";
                }
                else
                {
                    slide.cssClass = "item";
                }

                listSL.Add(slide);
            }

            return listSL;
        }
    }
}