// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Aplicacion
// Author           : Equipo de desarrollo OIM
// Created          : 03-08-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 03-08-2017
// ***********************************************************************
// <copyright file="Archivo.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// Adjuntos namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Aplicacion.Adjuntos
{
    using Entidades;
    using Seguridad;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Text;
    using System.Web;

    /// <summary>
    /// Clase Archivo.
    /// </summary>
    public class Archivo
    {
        /// <summary>
        /// The path help files
        /// </summary>
        public static string pathConfigurarDerechosFiles = @"ConfigurarDerechos\";

        /// <summary>
        /// The path solicitud temporary
        /// </summary>
        public static string pathSolicitudTemp = @"SolicitudesUsuario\Temp\";

        /// <summary>
        /// The path solicitudes usuario
        /// </summary>
        public static string pathSolicitudesUsuario = @"SolicitudesUsuario\";

        /// <summary>
        /// The path chat files
        /// </summary>
        public static string pathChatFiles = @"ChatFiles\";

        /// <summary>
        /// The path help files
        /// </summary>
        public static string pathHelpFiles = @"Ayuda\";

        /// <summary>
        /// The path images files
        /// </summary>
        public static string pathImagesFiles = @"Images\";

        /// <summary>
        /// The path video files
        /// </summary>
        public static string pathVideoFiles = @"Videos\";

        /// <summary>
        /// The path automatic ev files
        /// </summary>
        public static string pathAutoEvFiles = @"AutoEvaluacion\";

        /// <summary>
        /// The path plan mejora files
        /// </summary>
        public static string pathPlanMejoraFiles = @"AutoEvaluacion\";

        /// <summary>
        /// The path plan mejora seguimiento files
        /// </summary>
        public static string pathPlanMejoraSeguimientoFiles = @"AutoEvaluacion\Seguimiento\";

        /// <summary>
        /// The path Seguimiento del tablero PAT files
        /// </summary>
        public static string pathPATFiles = @"Tablero PAT\Seguimiento\";

        /// <summary>
        /// The path Seguimiento del tablero PAT files
        /// </summary>
        public static string pathPATFilesDiligenciamiento = @"Tablero PAT\Diligenciamiento\";

        /// <summary>
        /// Elimina el archivo de la carpeta temporal
        /// </summary>
        /// <param name="nombreArchivo">The nombre archivo.</param>
        /// <param name="pathDestino">The path destino.</param>
        public static void EliminarArchivoTemp(string nombreArchivo, string pathDestino)
        {
            string Folder = HttpContext.Current.Server.MapPath(ConfigurationManager.AppSettings.Get("FilesTemp"));
            string PathFinal = Path.Combine(Folder, pathDestino);

            string path = string.Format(@"{0}\{1}", PathFinal, nombreArchivo);

            if (File.Exists(path)) File.Delete(path);
        }

        /// <summary>
        /// Crea the archivo físico.
        /// </summary>
        /// <param name="nombreArchivo">The nombre archivo.</param>
        /// <param name="pathDestino">The path destino.</param>
        public static void CrearArchivoFisico(string nombreArchivo, string pathDestino)
        {
            string Folder = ConfigurationManager.AppSettings.Get("FilesFolder");
            string PathFinal = Path.Combine(Folder, pathDestino);
            string path = string.Format(@"{0}\{1}", PathFinal, nombreArchivo);

            if (!File.Exists(path)) { File.Create(path).Dispose(); }
        }

        /// <summary>
        /// Elimina the archivo físico.
        /// </summary>
        /// <param name="nombreArchivo">The nombre archivo.</param>
        /// <param name="pathDestino">The path destino.</param>
        public static void EliminarArchivoFisico(string nombreArchivo, string pathDestino)
        {
            string Folder = ConfigurationManager.AppSettings.Get("FilesFolder");
            string PathFinal = Path.Combine(Folder, pathDestino);
            string path = string.Format(@"{0}\{1}", PathFinal, nombreArchivo);

            if (File.Exists(path)) File.Delete(path);
        }

        /// <summary>
        /// Downloads the specified archivo.
        /// </summary>
        /// <param name="archivo">The archivo.</param>
        /// <param name="nombreArchivo">The nombre archivo.</param>
        /// <param name="path">The path.</param>
        /// <returns>HttpResponseMessage.</returns>
        public static HttpResponseMessage Descargar(string archivo, string nombreArchivo, string path)
        {
            string Folder = ConfigurationManager.AppSettings.Get("FilesFolder");
            string PathFinal = Path.Combine(Folder, path + archivo);

            if (!File.Exists(PathFinal))
                return new HttpResponseMessage(HttpStatusCode.BadRequest);

            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

            Byte[] bytes = File.ReadAllBytes(PathFinal);

            response.Content = new ByteArrayContent(bytes);
            response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
            response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
            response.Content.Headers.ContentDisposition.FileName = archivo;

            return response;
        }

        /// <summary>
        /// Downloads the specified archivo.
        /// </summary>
        /// <param name="archivo">The archivo.</param>
        /// <param name="path">The path.</param>
        /// <returns>HttpResponseMessage.</returns>
        public static HttpResponseMessage DescargarEncuesta(string path, string archivo)
        {
            string Folder = ConfigurationManager.AppSettings.Get("FilesFolder");
            string PathFinal = Path.Combine(Folder, path);

            if (!File.Exists(PathFinal))
                return new HttpResponseMessage(HttpStatusCode.BadRequest);

            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

            Byte[] bytes = File.ReadAllBytes(PathFinal);

            response.Content = new ByteArrayContent(bytes);
            response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
            response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
            response.Content.Headers.ContentDisposition.FileName = archivo;

            return response;
        }

        /// <summary>
        /// Descargar archivo Retroalimentacion
        /// </summary>
        /// <param name="nombreArchivo"></param>
        /// <param name="path"></param>
        /// <returns></returns>
        public static HttpResponseMessage DescargarRetro(string nombreArchivo, string path)
        {
            string Folder = ConfigurationManager.AppSettings.Get("FilesFolder");
            string PathFinal = Path.Combine(Folder, path);

            if (!File.Exists(PathFinal))
                return new HttpResponseMessage(HttpStatusCode.BadRequest);

            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

            Byte[] bytes = File.ReadAllBytes(PathFinal);

            response.Content = new ByteArrayContent(bytes);
            response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
            response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
            response.Content.Headers.ContentDisposition.FileName = nombreArchivo;

            return response;
        }
        public static HttpResponseMessage DescargarRetroShared(string path, string archivo)
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {
                var Folder = sharedFolder;
                Folder = Folder.Replace(@"\", @"\\");

                string PathFinal = Path.Combine(Folder, path);

                if (!File.Exists(PathFinal))
                {
                    response = new HttpResponseMessage(HttpStatusCode.BadRequest);
                }
                else
                {
                    Byte[] bytes = File.ReadAllBytes(PathFinal);

                    response.Content = new ByteArrayContent(bytes);
                    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    response.Content.Headers.ContentDisposition.FileName = archivo;
                }
            }

            pers.Undo();

            return response;
        }
        /// <summary>
        /// Descargar archivo Retroalimentacion
        /// </summary>
        /// <param name="nombreArchivo"></param>
        /// <param name="path"></param>
        /// <returns></returns>
        public static HttpResponseMessage DescargarRetroShared(string nombreArchivo, string path, string archivo)
        {
            //string Folder = ConfigurationManager.AppSettings.Get("FilesFolder");
            //string PathFinal = Path.Combine(Folder, path);

            //if (!File.Exists(PathFinal))
            //    return new HttpResponseMessage(HttpStatusCode.BadRequest);

            //HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

            //Byte[] bytes = File.ReadAllBytes(PathFinal);

            //response.Content = new ByteArrayContent(bytes);
            //response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
            //response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
            //response.Content.Headers.ContentDisposition.FileName = nombreArchivo;

            //return response;

            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {
                var Folder = sharedFolder;
                Folder = Folder.Replace(@"\", @"\\");

                string PathFinal = Path.Combine(Folder, path, archivo);

                if (!File.Exists(PathFinal))
                {
                    response = new HttpResponseMessage(HttpStatusCode.BadRequest);
                }
                else
                {
                    Byte[] bytes = File.ReadAllBytes(PathFinal);

                    response.Content = new ByteArrayContent(bytes);
                    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    response.Content.Headers.ContentDisposition.FileName = archivo;
                }
            }

            pers.Undo();

            return response;
        }


        /// <summary>
        /// Enviar el archivo al repositorio.
        /// </summary>
        /// <param name="postedFile">The posted file.</param>
        /// <param name="pathDestino">The path destino.</param>
        public static void GuardarArchivoRepositorio(HttpPostedFile postedFile, string pathDestino, string nombreArchivo)
        {
            string Folder = ConfigurationManager.AppSettings.Get("FilesFolder");
            string PathFinal = Path.Combine(Folder, pathDestino);
            DirectoryInfo infoDir = new DirectoryInfo(PathFinal);

            // Si el archivo existe lo almacena en el repositorio y lo elimina de la carpeta temporal
            if (infoDir.Exists)
            {
                //// Envía el archivo
                postedFile.SaveAs(PathFinal + nombreArchivo);
            }
            else
            {
                //// Crea el subfolder
                System.IO.Directory.CreateDirectory(PathFinal);

                //// Envía el PathFinal
                postedFile.SaveAs(PathFinal + nombreArchivo);
            }
        }
        public static string GuardarArchivoTableroPat(byte[] archivo, string nombreArchivo, string directorio, string usuario, string tablero, string pregunta, string type, string pathTableroPat)
        {
            string nombreDocumentoResult = string.Empty;
            directorio = Path.Combine(directorio, pathTableroPat, usuario, tablero, type, pregunta);
            if (!Directory.Exists(directorio))
                Directory.CreateDirectory(directorio);
            string path = string.Format(@"{0}\{1}", directorio, nombreArchivo);
            if (File.Exists(path)) File.Delete(path);
            System.IO.File.WriteAllBytes(path, archivo);
            nombreDocumentoResult = path;
            return nombreDocumentoResult;
        }

        public static string GuardarArchivoTableroPatShared(byte[] archivo, string nombreArchivo, string directorio, string usuario, string tablero, string pregunta, string type, string pathTableroPat)
        {           
            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            string nombreDocumentoResult = string.Empty;

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {               
                var path = sharedFolder;
                path = path.Replace("\\", "\\\\");                
                string PathFinal = Path.Combine(path, pathTableroPat, usuario, tablero, type, pregunta);
                DirectoryInfo infoDir = new DirectoryInfo(PathFinal);
            
                // Si el archivo existe lo almacena en el repositorio y lo elimina de la carpeta temporal
                if (infoDir.Exists)
                {
                    //Borra informacion anterior
                    if (File.Exists(PathFinal)) File.Delete(path);
                    //// Guarda el archivo
                    System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), archivo);                   
                }
                else
                {
                    //// Crea el subfolder
                    System.IO.Directory.CreateDirectory(PathFinal);
                    //// Guarda el PathFinal
                    System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), archivo);
                }
            }
            pers.Undo();            
            nombreDocumentoResult = string.Format(@"{0}\{1}", directorio, nombreArchivo); ;
            return nombreDocumentoResult;
        }

        public static string GuardarArchivoConfiguracionPatShared(byte[] archivo, string nombreArchivo, string directorio,string pathTableroPat)
        {
            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            string nombreDocumentoResult = string.Empty;

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {
                var path = sharedFolder;
                path = path.Replace("\\", "\\\\");
                string PathFinal = Path.Combine(path, pathTableroPat);
                DirectoryInfo infoDir = new DirectoryInfo(PathFinal);

                // Si el archivo existe lo almacena en el repositorio y lo elimina de la carpeta temporal
                if (infoDir.Exists)
                {
                    //Borra informacion anterior
                    if (File.Exists(PathFinal)) File.Delete(path);
                    //// Guarda el archivo
                    System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), archivo);
                }
                else
                {
                    //// Crea el subfolder
                    System.IO.Directory.CreateDirectory(PathFinal);
                    //// Guarda el PathFinal
                    System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), archivo);
                }
            }
            pers.Undo();
            nombreDocumentoResult = string.Format(@"{0}\{1}", directorio, nombreArchivo); ;
            return nombreDocumentoResult;
        }

        /// <summary>
        /// Enviar el archivo al repositorio.
        /// </summary>
        /// <param name="postedFile">The posted file.</param>
        /// <param name="pathDestino">The path destino.</param>
        public static void GuardarArchivoRepositorio(FileInfo postedFile, string pathDestino, string nombreArchivo)
        {
            string Folder = ConfigurationManager.AppSettings.Get("FilesFolder");
            string PathFinal = Path.Combine(Folder, pathDestino);
            DirectoryInfo infoDir = new DirectoryInfo(PathFinal);
            FileInfo file = new FileInfo(PathFinal + nombreArchivo);

            // Si el archivo existe lo almacena en el repositorio y lo elimina de la carpeta temporal
            if (infoDir.Exists)
            {
                //// Envía el archivo
                if (!file.Exists)
                {
                    postedFile.CopyTo(file.FullName);
                }
                else
                {
                    postedFile.CopyTo(file.FullName, true);
                }
            }
            else
            {
                //// Crea el subfolder
                System.IO.Directory.CreateDirectory(PathFinal);

                //// Envía el PathFinal
                if (!file.Exists)
                {
                    postedFile.CopyTo(file.FullName);
                }
                else
                {
                    postedFile.CopyTo(file.FullName, true);
                }
            }
        }

        /// <summary>
        /// Guarda el archivo de los parámetros en la carpeta compartida.
        /// </summary>
        /// <param name="fileBytes">The posted file bytes for binaryWrite.</param>
        /// <param name="folder">The Shared folder to save files.</param>
        /// <param name="pathDestino">The path to save file.</param>
        /// /// <param name="nombreArchivo">The File Name to save.</param>
        public static void GuardarArchivoParametros(byte[] fileBytes, string folder, string pathDestino, string nombreArchivo)
        {
            string PathFinal = Path.Combine(folder, pathDestino);
            DirectoryInfo infoDir = new DirectoryInfo(PathFinal);

            // Si el archivo existe lo almacena en el repositorio y lo elimina de la carpeta temporal
            if (infoDir.Exists)
            {
                //// Guarda el archivo
                System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
            }
            else
            {
                //// Crea el subfolder
                System.IO.Directory.CreateDirectory(PathFinal);

                //// Guarda el PathFinal
                System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
            }
        }

        /// <summary>
        /// Guarda el archivo de los parámetros en la carpeta compartida.
        /// </summary>
        /// <param name="fileBytes">The posted file bytes for binaryWrite.</param>
        /// <param name="folder">The Shared folder to save files.</param>
        /// <param name="pathDestino">The path to save file.</param>
        /// /// <param name="nombreArchivo">The File Name to save.</param>
        public static void GuardarArchivoEncuesta(byte[] fileBytes, string folder, string usuario, string idEncuesta, string idSeccion, string nombreArchivo)
        {
            string PathFinal = Path.Combine(folder, usuario, idEncuesta, idSeccion);
            DirectoryInfo infoDir = new DirectoryInfo(PathFinal);

            // Si el archivo existe lo almacena en el repositorio y lo elimina de la carpeta temporal
            if (infoDir.Exists)
            {
                //// Guarda el archivo
                System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
            }
            else
            {
                //// Crea el subfolder
                System.IO.Directory.CreateDirectory(PathFinal);

                //// Guarda el PathFinal
                System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
            }
        }

        /// <summary>
        /// Guarda el archivo de los parámetros en la carpeta compartida.
        /// </summary>
        /// <param name="fileBytes">The posted file bytes for binaryWrite.</param>
        /// <param name="folder">The Shared folder to save files.</param>
        /// <param name="pathDestino">The path to save file.</param>
        /// /// <param name="nombreArchivo">The File Name to save.</param>
        public static void GuardarArchivoEncuestaShared(byte[] fileBytes, string folder, string usuario, string idEncuesta, string idSeccion, string nombreArchivo)
        {
            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {
                var path = sharedFolder;
                path = path.Replace("\\", "\\\\");
                string PathFinal = Path.Combine(path, usuario, idEncuesta, idSeccion);
                DirectoryInfo infoDir = new DirectoryInfo(PathFinal);

                try
                {
                    // Si el archivo existe lo almacena en el repositorio y lo elimina de la carpeta temporal
                    if (infoDir.Exists)
                    {
                        //// Guarda el archivo
                        System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
                    }
                    else
                    {
                        //// Crea el subfolder
                        System.IO.Directory.CreateDirectory(PathFinal);

                        //// Guarda el PathFinal
                        System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
                    }
                } catch(Exception exx)
                {
                    pers.Undo();
                    throw exx;
                }                
            }

            pers.Undo();
        }


        /// <summary>
        /// Downloads the specified archivo.
        /// </summary>
        /// <param name="archivo">The archivo.</param>
        /// <param name="path">The path.</param>
        /// <returns>HttpResponseMessage.</returns>
        public static HttpResponseMessage DescargarEncuestaShared(string path, string archivo)
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {
                var Folder = sharedFolder;
                Folder = Folder.Replace(@"\", @"\\");

                string PathFinal = Path.Combine(Folder, path, archivo);

                if (!File.Exists(PathFinal))
                {
                    response = new HttpResponseMessage(HttpStatusCode.BadRequest);
                }
                else
                {
                    Byte[] bytes = File.ReadAllBytes(PathFinal);

                    response.Content = new ByteArrayContent(bytes);
                    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    response.Content.Headers.ContentDisposition.FileName = archivo;
                }                
            }

            pers.Undo();
            
            return response;
        }

        /// <summary>
        /// ConsultarArchivoFileServer
        /// </summary>
        /// <param name="archivo">The archivo.</param>
        /// <param name="path">The path.</param>
        /// <returns>HttpResponseMessage.</returns>
        public static IEnumerable<C_ConsultarRespuestasArchivoFileServer_Result> ConsultarArchivoFileServer(List<C_ConsultarRespuestasArchivoFileServer_Result> files)
        {
            List<C_ConsultarRespuestasArchivoFileServer_Result> result = new List<C_ConsultarRespuestasArchivoFileServer_Result>();

            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {
                var Folder = sharedFolder;
                Folder = Folder.Replace(@"\", @"\\");

                foreach(var item in files)
                {
                    string fileName = Path.GetFileName(item.Valor);

                    string[] arrFileName = fileName.Split('-');

                    if(arrFileName.Length >= 2)
                    {
                        if (arrFileName[0].Equals(arrFileName[1]))
                        {
                            fileName = string.Join("-", arrFileName.Skip(1));
                        }

                        string[] finalFileName = item.Valor.Split(Path.DirectorySeparatorChar);
                        string strFinal = "";

                        for (int i = 0; i < finalFileName.Length - 1; i++)
                        {
                            strFinal += finalFileName[i] + Path.DirectorySeparatorChar;
                        }

                        item.Valor = strFinal + fileName;
                    }                   

                    string PathFinal = Path.Combine(Folder, item.Valor);

                    if (!File.Exists(PathFinal))
                        result.Add(item);
                }
            }

            pers.Undo();

            return result;
        }

        public static HttpResponseMessage DescargarEncuestaSharedOtrosDerechos(string path, string archivo, string archivoEntidad )
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {
                var Folder = sharedFolder;
                Folder = Folder.Replace(@"\", @"\\");

                string PathFinal = Path.Combine(Folder, path, archivo);
                string PathFinalEntidad = Path.Combine(Folder, path, archivoEntidad);

                if (!File.Exists(PathFinal))
                {
                    if (!File.Exists(PathFinalEntidad ))
                    {
                        response = new HttpResponseMessage(HttpStatusCode.BadRequest);
                    }
                    else
                    {
                        Byte[] bytes = File.ReadAllBytes(PathFinalEntidad);

                        response.Content = new ByteArrayContent(bytes);
                        response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
                        response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                        response.Content.Headers.ContentDisposition.FileName = archivoEntidad;
                    }
                }
                else
                {
                    Byte[] bytes = File.ReadAllBytes(PathFinal);

                    response.Content = new ByteArrayContent(bytes);
                    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    response.Content.Headers.ContentDisposition.FileName = archivo;
                }
            }

            pers.Undo();

            return response;
        }
        public static byte[] GetFilesBytesFromShared(string path)
        {
            Byte[] bytes = new byte[0];

            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {
                var Folder = sharedFolder;
                Folder = Folder.Replace(@"\", @"\\");

                string PathFinal = Path.Combine(Folder, path);

                if (!File.Exists(PathFinal))
                {
                    bytes = new byte[0];
                }
                else
                {
                    bytes = File.ReadAllBytes(PathFinal);
                }
            }

            pers.Undo();

            return bytes;
        }

        public static bool ExisteArchivoShared(string path)
        {
            bool result = false;

            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {
                var Folder = sharedFolder;
                Folder = Folder.Replace(@"\", @"\\");

                string PathFinal = Path.Combine(Folder, path);

                result = File.Exists(PathFinal);
            }

            pers.Undo();

            return result;
        }

        public static HttpResponseMessage DescargarEncuestaSharedOld(string path, string archivo)
        {
            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);

            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {
                var Folder = sharedFolder;
                Folder = Folder.Replace(@"\", @"\\");

                string PathFinal = Path.Combine(Folder, path);

                if (!File.Exists(PathFinal))
                {
                    response = new HttpResponseMessage(HttpStatusCode.BadRequest);
                }
                else
                {
                    Byte[] bytes = File.ReadAllBytes(PathFinal);

                    response.Content = new ByteArrayContent(bytes);
                    response.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
                    response.Content.Headers.ContentType = new MediaTypeHeaderValue("application/pdf");
                    response.Content.Headers.ContentDisposition.FileName = archivo;
                }
            }

            pers.Undo();

            return response;
        }


        /// <summary>
        /// Guarda el archivo del Plan de Mejoramiento en la carpeta compartida.
        /// </summary>
        /// <param name="fileBytes">The posted file bytes for binaryWrite.</param>
        /// <param name="folder">The Shared folder to save files.</param>
        /// <param name="pathDestino">The path to save file.</param>
        /// /// <param name="nombreArchivo">The File Name to save.</param>
        public static void GuardarArchivoPlanMejoramiento(byte[] fileBytes, string folder, string nombreArchivo, string usuario)
        {
            string PathFinal = Path.Combine(folder, pathPlanMejoraFiles, usuario);
            DirectoryInfo infoDir = new DirectoryInfo(PathFinal);

            // Si el archivo existe lo almacena en el repositorio y lo elimina de la carpeta temporal
            if (infoDir.Exists)
            {
                string path = string.Format(@"{0}\{1}", PathFinal, nombreArchivo);

                if (System.IO.File.Exists(path)) System.IO.File.Delete(path);

                //// Guarda el archivo
                System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
            }
            else
            {
                //// Crea el subfolder
                System.IO.Directory.CreateDirectory(PathFinal);

                //// Guarda el PathFinal
                System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
            }
        }

        /// <summary>
        /// Guarda el archivo del Plan de Mejoramiento V3 en la carpeta compartida, separado por usuario e idplan.
        /// </summary>
        /// <param name="fileBytes">The posted file bytes for binaryWrite.</param>
        /// <param name="folder">The Shared folder to save files.</param>
        /// <param name="pathDestino">The path to save file.</param>
        /// /// <param name="nombreArchivo">The File Name to save.</param>
        public static void GuardarArchivoPlanMejoramientoV3(byte[] fileBytes, string folder, string nombreArchivo, string usuario, string idPlan)
        {
            string PathFinal = Path.Combine(folder, pathPlanMejoraFiles, usuario, idPlan);
            DirectoryInfo infoDir = new DirectoryInfo(PathFinal);

            // Si el archivo existe lo almacena en el repositorio y lo elimina de la carpeta temporal
            if (infoDir.Exists)
            {
                string path = string.Format(@"{0}\{1}", PathFinal, nombreArchivo);

                if (System.IO.File.Exists(path)) System.IO.File.Delete(path);

                //// Guarda el archivo
                System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
            }
            else
            {
                //// Crea el subfolder
                System.IO.Directory.CreateDirectory(PathFinal);

                //// Guarda el PathFinal
                System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
            }
        }

        /// <summary>
        /// Guarda el archivo del Plan de Mejoramiento V3 en la carpeta compartida, separado por usuario e idplan.
        /// </summary>
        /// <param name="fileBytes">The posted file bytes for binaryWrite.</param>
        /// <param name="folder">The Shared folder to save files.</param>
        /// <param name="pathDestino">The path to save file.</param>
        /// /// <param name="nombreArchivo">The File Name to save.</param>
        public static void GuardarArchivoPlanMejoramientoV3Shared(byte[] fileBytes, string folder, string nombreArchivo, string usuario, string idPlan)
        {
            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {
                var path = sharedFolder;
                path = path.Replace("\\", "\\\\");
                string PathFinal = Path.Combine(path, pathPlanMejoraFiles, usuario, idPlan);
                DirectoryInfo infoDir = new DirectoryInfo(PathFinal);

                // Si el archivo existe lo almacena en el repositorio y lo elimina de la carpeta temporal
                if (infoDir.Exists)
                {
                    string path2 = string.Format(@"{0}\{1}", PathFinal, nombreArchivo);

                    if (System.IO.File.Exists(path2)) System.IO.File.Delete(path2);

                    //// Guarda el archivo
                    System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
                }
                else
                {
                    //// Crea el subfolder
                    System.IO.Directory.CreateDirectory(PathFinal);

                    //// Guarda el PathFinal
                    System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
                }
            }

            pers.Undo();
        }

        /// <summary>
        /// Guarda el archivo del Seguimiento del Plan de Mejoramiento V3 en la carpeta compartida, separado por usuario e idSeguimiento.
        /// </summary>
        /// <param name="fileBytes">The posted file bytes for binaryWrite.</param>
        /// <param name="folder">The Shared folder to save files.</param>
        /// <param name="pathDestino">The path to save file.</param>
        /// /// <param name="nombreArchivo">The File Name to save.</param>
        public static void GuardarArchivoSeguimientoPlanMejoramientoV3Shared(byte[] fileBytes, string folder, string nombreArchivo, string usuario, string idSeguimiento)
        {
            string sharedFolder = ConfigurationManager.AppSettings.Get("FileFolderEncuesta");
            var username = ConfigurationManager.AppSettings.Get("UserFileFolderEncuesta");
            var password = ConfigurationManager.AppSettings.Get("PassFileFolderEncuesta");
            var domain = ConfigurationManager.AppSettings.Get("DomainFileFolderEncuesta");

            var pers = new Impersonation();
            pers.Impersonate(username, password, domain);
            var credential = new NetworkCredential(username, password, domain);
            using (new NetworkConnection(sharedFolder, credential))
            {
                var path = sharedFolder;
                path = path.Replace("\\", "\\\\");
                string PathFinal = Path.Combine(path, pathPlanMejoraSeguimientoFiles, usuario, idSeguimiento);
                DirectoryInfo infoDir = new DirectoryInfo(PathFinal);

                // Si el archivo existe lo almacena en el repositorio y lo elimina de la carpeta temporal
                if (infoDir.Exists)
                {
                    string path2 = string.Format(@"{0}\{1}", PathFinal, nombreArchivo);

                    if (System.IO.File.Exists(path2)) System.IO.File.Delete(path2);

                    //// Guarda el archivo
                    System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
                }
                else
                {
                    //// Crea el subfolder
                    System.IO.Directory.CreateDirectory(PathFinal);

                    //// Guarda el PathFinal
                    System.IO.File.WriteAllBytes(Path.Combine(PathFinal, nombreArchivo), fileBytes);
                }
            }

            pers.Undo();
        }
    }
}


