// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Entidades
// Author           : Equipo de desarrollo OIM
// Created          : 10-16-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-16-2017
// ***********************************************************************
// <copyright file="C_LogXCategoria_Result.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************
/// <summary>
/// The Entidades namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Entidades
{
    /// <summary>
    /// Class C_LogXCategoria_Result.
    /// </summary>
    public partial class C_LogXCategoria_Result
    {
        /// <summary>
        /// Gets the URL.
        /// </summary>
        /// <value>The URL.</value>
        public string Url { get { return UrlYBrowser.Split('|')[0]; } }

        /// <summary>
        /// Gets the navegador.
        /// </summary>
        /// <value>The navegador.</value>
        public string Navegador { get { return UrlYBrowser.Split('|')[1] + " " + UrlYBrowser.Split('|')[2]; } }
    }
}
