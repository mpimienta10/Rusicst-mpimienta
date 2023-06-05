// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 09-14-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 09-14-2017
// ***********************************************************************
// <copyright file="AuditoriaModels.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************


/// <summary>
/// The Models namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Models
{
    using System;

    /// <summary>
    /// Class AuditoriaModels.
    /// </summary>
    public class AuditoriaModels
    {
        /// <summary>
        /// Gets or sets the category identifier.
        /// </summary>
        /// <value>The category identifier.</value>
        public int CategoryId { get; set; }

        /// <summary>
        /// Gets or sets the fecha.
        /// </summary>
        /// <value>The fecha.</value>
        public int EventID { get; set; }

        /// <summary>
        /// Gets or sets the usuario.
        /// </summary>
        /// <value>The usuario.</value>
        public int Priority { get; set; }

        /// <summary>
        /// Gets or sets the actividad.
        /// </summary>
        /// <value>The actividad.</value>
        public string Severity { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>The title.</value>
        public string Title { get; set; }

        /// <summary>
        /// Gets or sets the timestamp.
        /// </summary>
        /// <value>The timestamp.</value>
        public DateTime Timestamp { get; set; }

        /// <summary>
        /// Gets or sets the name of the machine.
        /// </summary>
        /// <value>The name of the machine.</value>
        public string MachineName { get; set; }

        /// <summary>
        /// Gets or sets the name of the application domain.
        /// </summary>
        /// <value>The name of the application domain.</value>
        public string AppDomainName { get; set; }

        /// <summary>
        /// Gets or sets the process identifier.
        /// </summary>
        /// <value>The process identifier.</value>
        public string ProcessID { get; set; }

        /// <summary>
        /// Gets or sets the name of the process.
        /// </summary>
        /// <value>The name of the process.</value>
        public string ProcessName { get; set; }

        /// <summary>
        /// Gets or sets the name of the thread.
        /// </summary>
        /// <value>The name of the thread.</value>
        public string ThreadName { get; set; }

        /// <summary>
        /// Gets or sets the win32 thread identifier.
        /// </summary>
        /// <value>The win32 thread identifier.</value>
        public string Win32ThreadId { get; set; }

        /// <summary>
        /// Gets or sets the message.
        /// </summary>
        /// <value>The message.</value>
        public string Message { get; set; }

        /// <summary>
        /// Gets or sets the formatted message.
        /// </summary>
        /// <value>The formatted message.</value>
        public string FormattedMessage { get; set; }
        public string DetalleMessage { get; set; }
    }

    public class AuditData
    {
        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }
    }
}