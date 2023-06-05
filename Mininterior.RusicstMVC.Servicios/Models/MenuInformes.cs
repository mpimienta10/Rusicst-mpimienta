// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 04-27-2017
// ***********************************************************************
// <copyright file="MenuInformes.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Models namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Models
{
    using System.Collections.Generic;

    /// <summary>
    /// Clase Secciones y Subsecciones Encuesta.
    /// </summary>
    public class SeccionSubseccionModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the titulo.
        /// </summary>
        /// <value>The titulo.</value>
        public string Titulo { get; set; }

        /// <summary>
        /// Gets or sets the lista subsecciones.
        /// </summary>
        /// <value>The lista subsecciones.</value>
        public List<SeccionSubseccionModels> ListaSubsecciones { get; set; }
    }

   
    /// <summary>
    /// Clase para buscar reporte consolidado por departamento y encuesta
    /// </summary>
    public class BuscarEncuestaModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int idDepartamento { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int idMunicipio { get; set; }

        /// <summary>
        /// Gets or sets the titulo.
        /// </summary>
        /// <value>The titulo.</value>
        public int idEncuesta { get; set; }
    }
}