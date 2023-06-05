// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 09-15-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-24-2017
// ***********************************************************************
// <copyright file="Audit.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Providers namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Providers
{
    using Aplicacion.Seguridad;
    using Models;
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Collections.Specialized;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Web;
    using System.Web.Configuration;
    using System.Web.Http.Controllers;
    using System.Web.Http.Filters;

    /// <summary>
    /// Clase que audita el inicio de la ejecución.
    /// </summary>
    public class AuditExecuting : ActionFilterAttribute
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="AuditExecuting" /> class.
        /// </summary>
        public AuditExecuting() { }

        /// <summary>
        /// Initializes a new instance of the <see cref="AuditExecuting" /> class.
        /// </summary>
        /// <param name="key">The key.</param>
        public AuditExecuting(Category key) { KeyLog = key; }

        /// <summary>
        /// Gets or sets the key log.
        /// </summary>
        /// <value>The key log.</value>
        public Category KeyLog { get; set; }

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public String UserName { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public String UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets the datos entidad.
        /// </summary>
        /// <value>The datos entidad.</value>
        public String DatosEntidad { get; set; }

        /// <summary>
        /// Gets or sets the severity tipe.
        /// </summary>
        /// <value>The severity tipe.</value>
        public Severity SeverityType { get; set; }

        /// <summary>
        /// Gets the object auditoria.
        /// </summary>
        /// <value>The object auditoria.</value>
        public AuditoriaModels objAuditoria
        {
            get
            {
                AuditoriaModels audit = new AuditoriaModels();

                audit.CategoryId = (int)KeyLog;
                audit.EventID = -1;
                audit.Priority = -1;
                audit.Severity = SeverityType.ToString();
                audit.Title = UserName;
                audit.Timestamp = DateTime.Now;
                audit.MachineName = UtilAuditoria.NameMachine();
                audit.AppDomainName = UtilAuditoria.AppDomainName();
                audit.ProcessID = UtilAuditoria.ProcessID().ToString();
                audit.ProcessName = UtilAuditoria.ProcessName();
                audit.ThreadName = UtilAuditoria.ThreadName();
                audit.Win32ThreadId = UtilAuditoria.ThreadId().ToString();
                audit.Message = UtilAuditoria.Message();
                audit.FormattedMessage = UtilAuditoria.LoadMessage(KeyLog, UserName, DatosEntidad, this.UserNameAddIdent);

                return audit;
            }
        }

        /// <summary>
        /// Occurs before the action method is invoked.
        /// </summary>
        /// <param name="actionContext">The action context.</param>
        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            if (actionContext.Request.Method == HttpMethod.Post)
            {
                var postData = actionContext.ActionArguments;

                using (AuditRepository conect = new Providers.AuditRepository())
                {
                    string Excepcion = UtilAuditoria.RetornarParametro(postData.First().Value, "Excepcion");
                    this.SeverityType = Convert.ToBoolean(Excepcion) ? Severity.Error : Severity.Information;

                    //// Valida si está adquiriendo identidad validando el parámetro que viene en la entidad.
                    bool AdquirioIdentidad = Convert.ToBoolean(UtilAuditoria.RetornarParametro(postData.First().Value, "AddIdent"));
                    this.KeyLog = (this.KeyLog == Category.InicioSesion && AdquirioIdentidad) ? Category.AdquirirIdentidad : Category.InicioSesion;

                    this.DatosEntidad = (this.KeyLog != Category.InicioSesion && this.KeyLog != Category.AdquirirIdentidad) ? UtilAuditoria.RetornarPropiedades(postData.First().Value, Convert.ToBoolean(Excepcion)) : string.Empty;
                    this.UserName = AdquirioIdentidad ? UtilAuditoria.RetornarParametro(postData.First().Value, "UserNameAddIdent") : UtilAuditoria.RetornarParametro(postData.First().Value, "AudUserName");
                    this.UserNameAddIdent = AdquirioIdentidad ? UtilAuditoria.RetornarParametro(postData.First().Value, "AudUserName") : string.Empty;

                    conect.Auditar(this.objAuditoria);
                }
            }
        }
    }

    /// <summary>
    /// Clase que audita cuando ya se ejecutó.
    /// </summary>
    public class AuditExecuted : ActionFilterAttribute
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="AuditExecuted" /> class.
        /// </summary>
        public AuditExecuted() { }

        /// <summary>
        /// Initializes a new instance of the <see cref="AuditExecuted" /> class.
        /// </summary>
        /// <param name="key">The key.</param>
        public AuditExecuted(Category key) { KeyLog = key; }

        /// <summary>
        /// Gets or sets the key log.
        /// </summary>
        /// <value>The key log.</value>
        public Category KeyLog { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public String UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public String UserName { get; set; }

        /// <summary>
        /// Gets or sets the datos entidad.
        /// </summary>
        /// <value>The datos entidad.</value>
        public String DatosEntidad { get; set; }

        /// <summary>
        /// Gets or sets the severity tipe.
        /// </summary>
        /// <value>The severity tipe.</value>
        public Severity SeverityType { get; set; }

        /// <summary>
        /// Gets or sets the audit entity.
        /// </summary>
        /// <value>The audit entity.</value>
        public string AuditEntity { get; set; }

        /// <summary>
        /// Gets or sets the excepcion.
        /// </summary>
        /// <value>The excepcion.</value>
        public string Excepcion { get; set; }

        /// <summary>
        /// Gets the object auditoria.
        /// </summary>
        /// <value>The object auditoria.</value>
        public AuditoriaModels objAuditoria
        {
            get
            {
                AuditoriaModels audit = new AuditoriaModels();

                audit.CategoryId = (int)KeyLog;
                audit.EventID = -1;
                audit.Priority = -1;
                audit.Severity = SeverityType.ToString();
                audit.Title = UserName;
                audit.Timestamp = DateTime.Now;
                audit.MachineName = UtilAuditoria.NameMachine();
                audit.AppDomainName = UtilAuditoria.AppDomainName();
                audit.ProcessID = UtilAuditoria.ProcessID().ToString();
                audit.ProcessName = UtilAuditoria.ProcessName();
                audit.ThreadName = UtilAuditoria.ThreadName();
                audit.Win32ThreadId = UtilAuditoria.ThreadId().ToString();
                audit.Message = UtilAuditoria.Message();
                audit.FormattedMessage = UtilAuditoria.LoadMessage(KeyLog, UserName, DatosEntidad, string.Empty);

                return audit;
            }
        }

        /// <summary>
        /// Gets the object exception.
        /// </summary>
        /// <value>The object exception.</value>
        public AuditoriaModels objException
        {
            get
            {
                AuditoriaModels audit = new AuditoriaModels();

                audit.CategoryId = (int)KeyLog;
                audit.EventID = -1;
                audit.Priority = -1;
                audit.Severity = SeverityType.ToString();
                audit.Title = this.UserName;
                audit.Timestamp = DateTime.Now;
                audit.MachineName = UtilAuditoria.NameMachine();
                audit.AppDomainName = UtilAuditoria.AppDomainName();
                audit.ProcessID = UtilAuditoria.ProcessID().ToString();
                audit.ProcessName = UtilAuditoria.ProcessName();
                audit.ThreadName = UtilAuditoria.ThreadName();
                audit.Win32ThreadId = UtilAuditoria.ThreadId().ToString();
                audit.Message = UtilAuditoria.Message();
                audit.FormattedMessage = UtilAuditoria.LoadMessageException(this.UserNameAddIdent, Excepcion);

                return audit;
            }
        }

        /// <summary>
        /// Occurs after the action method is invoked.
        /// </summary>
        /// <param name="actionExecutedContext">The action executed context.</param>
        public override void OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
        {
            string Excepcion = UtilAuditoria.RetornarParametro(actionExecutedContext.ActionContext.ActionArguments.First().Value, "Excepcion");
            this.SeverityType = Convert.ToBoolean(Excepcion) ? Severity.Error : Severity.Information;

            if (this.KeyLog == Category.ResetiarContraseña)
            {
                string Usuario = "Usuario : " + UtilAuditoria.RetornarParametro(actionExecutedContext.ActionContext.ActionArguments.First().Value, "UserName");
                string Email = "Email : " + UtilAuditoria.RetornarParametro(actionExecutedContext.ActionContext.ActionArguments.First().Value, "Email");

                this.KeyLog = Convert.ToBoolean(Excepcion) ? Category.ResetiarContraseñaError : Category.ResetiarContraseña;

                this.DatosEntidad = Usuario + Environment.NewLine + Email;
            }
            else if (this.KeyLog == Category.EstablecerContraseña)
            {
                string Usuario = "Usuario : " + UtilAuditoria.RetornarParametro(actionExecutedContext.ActionContext.ActionArguments.First().Value, "UserName");
                this.DatosEntidad = Usuario;
            }
            else
            {
                this.DatosEntidad = UtilAuditoria.RetornarPropiedades(actionExecutedContext.ActionContext.ActionArguments.First().Value, Convert.ToBoolean(Excepcion));
            }

            this.UserName = (this.KeyLog == Category.ResetiarContraseñaError || this.KeyLog == Category.ResetiarContraseña || this.KeyLog == Category.CrearSolicitud || this.KeyLog == Category.ConfirmarSolicitud || this.KeyLog == Category.EstablecerContraseña) ?
                "Desconocido" : this.KeyLog == Category.InicioSesionAD ? UtilAuditoria.RetornarParametro(actionExecutedContext.ActionContext.ActionArguments.First().Value, "UserName") : UtilAuditoria.RetornarParametro(actionExecutedContext.ActionContext.ActionArguments.First().Value, "AudUserName");

            using (AuditRepository conect = new Providers.AuditRepository())
            {
                conect.Auditar(this.objAuditoria);
            }
        }

        /// <summary>
        /// Actions the executed manual.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="entidad">The entidad.</param>
        public void ActionExecutedManual<T>(T entidad)
        {
            ////-------------------------------------
            string capturaResultado = string.Empty;

            try
            {
                string Excepcion = UtilAuditoria.RetornarParametro(entidad, "Excepcion");

                ////----------------------------------------------------------------------------------
                capturaResultado = capturaResultado + "Excepcion: " + Excepcion + Environment.NewLine;

                this.SeverityType = !String.IsNullOrEmpty(Excepcion) ? Convert.ToBoolean(String.IsNullOrEmpty(Excepcion)) ? Severity.Error : Severity.Information : Severity.Information;

                ////----------------------------------------------------------------------------------
                capturaResultado = capturaResultado + "SevertityType: " + this.SeverityType + Environment.NewLine;
                capturaResultado = capturaResultado + "KeyLog: " + this.KeyLog + Environment.NewLine;

                if (this.KeyLog == Category.ResetiarContraseña)
                {
                    string Usuario = "Usuario : " + UtilAuditoria.RetornarParametro(entidad, "UserName");
                    string Email = "Email : " + UtilAuditoria.RetornarParametro(entidad, "Email");

                    this.KeyLog = Convert.ToBoolean(Excepcion) ? Category.ResetiarContraseñaError : Category.ResetiarContraseña;

                    this.DatosEntidad = Usuario + Environment.NewLine + Email;
                }
                else if (this.KeyLog == Category.EstablecerContraseña)
                {
                    string Usuario = "Usuario : " + UtilAuditoria.RetornarParametro(entidad, "UserName");
                    this.DatosEntidad = Usuario;
                }
                else
                {
                    capturaResultado = capturaResultado + "Dastos Entidad Inició: " + Environment.NewLine;
                    this.DatosEntidad = UtilAuditoria.RetornarPropiedades(entidad, !String.IsNullOrEmpty(Excepcion) ? Convert.ToBoolean(Excepcion) : false);
                    capturaResultado = capturaResultado + "Dastos Entidad Terminó: " + Environment.NewLine;
                }

                capturaResultado = capturaResultado + "UserName Inició: " + Environment.NewLine;
                this.UserName = (this.KeyLog == Category.ResetiarContraseñaError || this.KeyLog == Category.ResetiarContraseña || this.KeyLog == Category.CrearSolicitud || this.KeyLog == Category.ConfirmarSolicitud || this.KeyLog == Category.EstablecerContraseña) ?
                    "Desconocido" : (this.KeyLog == Category.InicioSesionAD || this.KeyLog == Category.InicioSesiónErrorAD) ? UtilAuditoria.RetornarParametro(entidad, "UserName") : UtilAuditoria.RetornarParametro(entidad, "AudUserName");
                capturaResultado = capturaResultado + "UserName Terminó: " + Environment.NewLine;

                capturaResultado = capturaResultado + "Inicia inserción: " + Environment.NewLine;
                using (AuditRepository conect = new Providers.AuditRepository())
                {
                    conect.Auditar(this.objAuditoria);
                }
                capturaResultado = capturaResultado + "Termina inserción: " + Environment.NewLine;
            }
            catch (Exception ex)
            {
                capturaResultado = capturaResultado + ex.Message + Environment.NewLine; ;
            }
            finally
            {
                //Aplicacion.Excepciones.ManagerException.RegistraErrorBlockNotas(new Exception(capturaResultado));
            }
        }

        /// <summary>
        /// Actions the execute exception.
        /// </summary>
        /// <param name="excepcion">The excepcion.</param>
        public void ActionExecutedException(string audUserName, string userNameAddIdent, string excepcion)
        {
            this.Excepcion = excepcion;
            this.UserName = audUserName;
            this.UserNameAddIdent = userNameAddIdent;

            using (AuditRepository conect = new Providers.AuditRepository())
            {
                conect.Auditar(this.objException);
            }
        }
    }

    /// <summary>
    /// Clase que audita el ingreso y ejecución.
    /// </summary>
    public class AuditAll : ActionFilterAttribute
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="AuditAll" /> class.
        /// </summary>
        public AuditAll() { }

        /// <summary>
        /// Initializes a new instance of the <see cref="AuditAll" /> class.
        /// </summary>
        /// <param name="key">The key.</param>
        public AuditAll(Category key) { KeyLog = key; }

        /// <summary>
        /// Gets or sets the key log.
        /// </summary>
        /// <value>The key log.</value>
        public Category KeyLog { get; set; }

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public String UserName { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public String UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets the datos entidad.
        /// </summary>
        /// <value>The datos entidad.</value>
        public String DatosEntidad { get; set; }
        public String DetalleMensaje { get; set; }

        /// <summary>
        /// Gets or sets the severity tipe.
        /// </summary>
        /// <value>The severity tipe.</value>
        public Severity SeverityType { get; set; }

        /// <summary>
        /// Gets the object auditoria.
        /// </summary>
        /// <value>The object auditoria.</value>
        public AuditoriaModels objAuditoria
        {
            get
            {
                AuditoriaModels audit = new AuditoriaModels();

                audit.CategoryId = (int)KeyLog;
                audit.EventID = -1;
                audit.Priority = -1;
                audit.Severity = SeverityType.ToString();
                audit.Title = UserName;
                audit.Timestamp = DateTime.Now;
                audit.MachineName = UtilAuditoria.NameMachine();
                audit.AppDomainName = UtilAuditoria.AppDomainName();
                audit.ProcessID = UtilAuditoria.ProcessID().ToString();
                audit.ProcessName = UtilAuditoria.ProcessName();
                audit.ThreadName = UtilAuditoria.ThreadName();
                audit.Win32ThreadId = UtilAuditoria.ThreadId().ToString();
                audit.Message = UtilAuditoria.Message();
                audit.DetalleMessage = DetalleMensaje;
                audit.FormattedMessage = UtilAuditoria.LoadMessage(KeyLog, UserName, DatosEntidad, string.Empty, audit.DetalleMessage);

                return audit;
            }
        }

        /// <summary>
        /// Occurs before the action method is invoked.
        /// </summary>
        /// <param name="actionContext">The action context.</param>
        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            if (actionContext.Request.Method == HttpMethod.Post)
            {
                var postData = actionContext.ActionArguments;

                using (AuditRepository conect = new Providers.AuditRepository())
                {
                    string Excepcion = UtilAuditoria.RetornarParametro(postData.First().Value, "Excepcion");
                    this.SeverityType = Convert.ToBoolean(Excepcion) ? Severity.Error : Severity.Information;

                    //// Valida si está adquiriendo identidad validando el parámetro que viene en la entidad.
                    bool AdquirioIdentidad = Convert.ToBoolean(UtilAuditoria.RetornarParametro(postData.First().Value, "AddIdent"));
                    this.KeyLog = (this.KeyLog == Category.InicioSesion && AdquirioIdentidad) ? Category.AdquirirIdentidad : Category.InicioSesion;

                    this.DatosEntidad = (this.KeyLog != Category.InicioSesion && this.KeyLog != Category.AdquirirIdentidad) ? UtilAuditoria.RetornarPropiedades(postData.First().Value, Convert.ToBoolean(Excepcion)) : string.Empty;
                    this.UserName = AdquirioIdentidad ? UtilAuditoria.RetornarParametro(postData.First().Value, "UserNameAddIdent") : UtilAuditoria.RetornarParametro(postData.First().Value, "AudUserName");
                    this.UserNameAddIdent = AdquirioIdentidad ? UtilAuditoria.RetornarParametro(postData.First().Value, "AudUserName") : string.Empty;

                    conect.Auditar(this.objAuditoria);
                }
            }
        }

        /// <summary>
        /// Occurs after the action method is invoked.
        /// </summary>
        /// <param name="actionExecutedContext">The action executed context.</param>
        public override void OnActionExecuted(HttpActionExecutedContext actionExecutedContext)
        {
            using (AuditRepository conect = new Providers.AuditRepository())
            {
                string Excepcion = UtilAuditoria.RetornarParametro(actionExecutedContext.ActionContext.ActionArguments.First().Value, "Excepcion");
                this.SeverityType = Convert.ToBoolean(Excepcion) ? Severity.Error : Severity.Information;

                if (this.KeyLog == Category.ResetiarContraseña)
                {
                    string Usuario = "Usuario : " + UtilAuditoria.RetornarParametro(actionExecutedContext.ActionContext.ActionArguments.First().Value, "UserName");
                    string Email = "Email : " + UtilAuditoria.RetornarParametro(actionExecutedContext.ActionContext.ActionArguments.First().Value, "Email");

                    this.KeyLog = Convert.ToBoolean(Excepcion) ? Category.ResetiarContraseñaError : Category.ResetiarContraseña;

                    this.DatosEntidad = Usuario + Environment.NewLine + Email;
                }
                else
                {
                    this.DatosEntidad = UtilAuditoria.RetornarPropiedades(actionExecutedContext.ActionContext.ActionArguments.First().Value, Convert.ToBoolean(Excepcion));
                }

                this.UserName = (this.KeyLog == Category.ResetiarContraseñaError || this.KeyLog == Category.ResetiarContraseña) ? "Desconocido" : UtilAuditoria.RetornarParametro(actionExecutedContext.ActionContext.ActionArguments.First().Value, "AudUserName");
                conect.Auditar(this.objAuditoria);
            }
        }
    }
}