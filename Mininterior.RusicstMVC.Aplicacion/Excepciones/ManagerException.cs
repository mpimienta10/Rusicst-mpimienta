// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Aplicacion
// Author           : Equipo de desarrollo OIM - Mauricio Ospina
// Created          : 09-08-2017
//
// Last Modified By : Equipo de desarrollo OIM - Mauricio Ospina
// Last Modified On : 10-23-2017
// ***********************************************************************
// <copyright file="ManagerException.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

/// <summary>
/// The Excepciones namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Aplicacion.Excepciones
{
    /// <summary>
    /// Class ManagerException.
    /// </summary>
    public static class ManagerException
    {
        /// <summary>
        /// Metodo para almacenar error en block de notas
        /// </summary>
        /// <param name="infoError">Objeto con detalle del error</param>
        public static void RegistraErrorBlockNotas(Exception infoError)
        {
            Mininterior.RusicstMVC.Aplicacion.Adjuntos.Archivo.CrearArchivoFisico("rusicst.log", string.Empty);

            using (StreamWriter writer = new StreamWriter(ConfigurationManager.AppSettings["logError"], true))
            {
                writer.WriteLine();
                writer.WriteLine("****************************************************************************");
                writer.WriteLine();
                writer.WriteLine(DateTime.Now.ToLongDateString());
                writer.WriteLine();
                writer.WriteLine("El detalle del error es: " + (null != infoError.Message ? infoError.Message : (string.Empty + Environment.NewLine))
                    + (null != infoError.InnerException ? infoError.InnerException.Message : (string.Empty + Environment.NewLine))
                    + (null != infoError.InnerException && null != infoError.InnerException.InnerException ? infoError.InnerException.InnerException.Message : string.Empty));
                writer.WriteLine();
            }
        }

        /// <summary>
        /// Retornars the error.
        /// </summary>
        /// <param name="infoError">The information error.</param>
        /// <returns>System.String.</returns>
        public static string RetornarError(Exception infoError)
        {
            string retorno = string.Empty;

            retorno = "El detalle del error es : " + Environment.NewLine + (null != infoError.Message ? infoError.Message : (string.Empty + Environment.NewLine))
                    + (null != infoError.InnerException ? infoError.InnerException.Message : (string.Empty + Environment.NewLine))
                    + (null != infoError.InnerException && null != infoError.InnerException.InnerException ? infoError.InnerException.InnerException.Message : (string.Empty + Environment.NewLine))
                    + "Rastro de la Pila : " + Environment.NewLine + infoError.StackTrace + Environment.NewLine;

            return retorno;
        }
    }
}
