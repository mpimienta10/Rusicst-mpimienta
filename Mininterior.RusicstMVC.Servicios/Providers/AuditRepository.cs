// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 09-19-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 09-19-2017
// ***********************************************************************
// <copyright file="AuditRepository.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************


/// <summary>
/// The Providers namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Providers
{
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;

    /// <summary>
    /// Class AuditRepository.
    /// </summary>
    public class AuditRepository : IDisposable
    {
        /// <summary>
        /// Auditars the specified model.
        /// </summary>
        /// <param name="model">The model.</param>
        public void Auditar(AuditoriaModels model)
        {
            C_AccionesResultado resultado = new C_AccionesResultado();

            using (EntitiesRusicstLog BD = new EntitiesRusicstLog())
            {
                resultado = BD.I_LogInsert(model.CategoryId, model.EventID, model.Priority, model.Severity, model.Title, model.Timestamp, model.MachineName, model.AppDomainName, model.ProcessID, model.ProcessName, model.ThreadName, model.Win32ThreadId, model.Message, model.FormattedMessage).Cast<C_AccionesResultado>().First();
            }
        }

        /// <summary>
        /// Performs application-defined tasks associated with freeing, releasing, or resetting unmanaged resources.
        /// </summary>
        public void Dispose()
        {
            
        }
    }
}