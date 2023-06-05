// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-05-2017
// ***********************************************************************
// <copyright file="MenuUsuarios.cs" company="Ministerio del Interior">
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
    using System.ComponentModel.DataAnnotations;
    using System.Web;

    /// <summary>
    /// Class TipoUsuariosModels.
    /// </summary>
    public class TipoUsuariosModels
    {
        /// <summary>
        /// Gets or sets the ID.
        /// </summary>
        /// <value>The ID.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the tipo.
        /// </summary>
        /// <value>The tipo.</value>
        public string Tipo { get; set; }

        /// <summary>
        /// Gets or sets the nombre.
        /// </summary>
        /// <value>The nombre.</value>
        public string Nombre { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="TipoUsuariosModels" /> is activo.
        /// </summary>
        /// <value><c>true</c> if activo; otherwise, <c>false</c>.</value>
        public bool Activo { get; set; }

        #region datos de auditoria

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

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class UsuariosModels.
    /// </summary>
    public class UsuariosModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the identifier user.
        /// </summary>
        /// <value>The identifier user.</value>
        public string IdUser { get; set; }

        /// <summary>
        /// Gets or sets the identifier tipo usuario.
        /// </summary>
        /// <value>The identifier tipo usuario.</value>
        public int IdTipoUsuario { get; set; }

        /// <summary>
        /// Gets or sets the tipo usuario.
        /// </summary>
        /// <value>The tipo usuario.</value>
        public string TipoUsuario { get; set; }

        /// <summary>
        /// Gets or sets the identifier departamento.
        /// </summary>
        /// <value>The identifier departamento.</value>
        public int IdDepartamento { get; set; }

        /// <summary>
        /// Gets or sets the departamento.
        /// </summary>
        /// <value>The departamento.</value>
        public string Departamento { get; set; }

        /// <summary>
        /// Gets or sets the identifier municipio.
        /// </summary>
        /// <value>The identifier municipio.</value>
        public int IdMunicipio { get; set; }

        /// <summary>
        /// Gets or sets the municipio.
        /// </summary>
        /// <value>The municipio.</value>
        public string Municipio { get; set; }

        /// <summary>
        /// Gets or sets the identifier estado.
        /// </summary>
        /// <value>The identifier estado.</value>
        public int IdEstado { get; set; }

        /// <summary>
        /// Gets or sets the estado.
        /// </summary>
        /// <value>The estado.</value>
        public string Estado { get; set; }

        /// <summary>
        /// Gets or sets the identifier usuario tramite.
        /// </summary>
        /// <value>The identifier usuario tramite.</value>
        public string IdUsuarioTramite { get; set; }

        /// <summary>
        /// Gets or sets the username.
        /// </summary>
        /// <value>The username.</value>
        public string UserName { get; set; }

        /// <summary>
        /// Gets or sets the nombre.
        /// </summary>
        /// <value>The nombre.</value>
        public string Nombres { get; set; }

        /// <summary>
        /// Gets or sets the cargo.
        /// </summary>
        /// <value>The cargo.</value>
        public string Cargo { get; set; }

        /// <summary>
        /// Gets or sets the telefono fijo.
        /// </summary>
        /// <value>The telefono fijo.</value>
        public string TelefonoFijo { get; set; }

        /// <summary>
        /// Gets or sets the telefono fijo indicativo.
        /// </summary>
        /// <value>The telefono fijo indicativo.</value>
        public string TelefonoFijoIndicativo { get; set; }

        /// <summary>
        /// Gets or sets the telefono fijo extension.
        /// </summary>
        /// <value>The telefono fijo extension.</value>
        public string TelefonoFijoExtension { get; set; }

        /// <summary>
        /// Gets or sets the telefono celular.
        /// </summary>
        /// <value>The telefono celular.</value>
        public string TelefonoCelular { get; set; }

        /// <summary>
        /// Gets or sets the email.
        /// </summary>
        /// <value>The email.</value>
        public string Email { get; set; }

        /// <summary>
        /// Gets or sets the email alt.
        /// </summary>
        /// <value>The email alt.</value>
        public string EmailAlternativo { get; set; }

        /// <summary>
        /// Gets or sets the enviado.
        /// </summary>
        /// <value>The enviado.</value>
        public bool Enviado { get; set; }

        /// <summary>
        /// Gets or sets the datos actualizados.
        /// </summary>
        /// <value>The datos actualizados.</value>
        public bool DatosActualizados { get; set; }

        /// <summary>
        /// Gets or sets the token.
        /// </summary>
        /// <value>The token.</value>
        public Guid Token { get; set; }

        /// <summary>
        /// Gets or sets the activo.
        /// </summary>
        /// <value>The activo.</value>
        public bool Activo { get; set; }

        /// <summary>
        /// Gets or sets the documento solicitud.
        /// </summary>
        /// <value>The documento solicitud.</value>
        public string DocumentoSolicitud { get; set; }

        /// <summary>
        /// Gets or sets the fecha solicitud.
        /// </summary>
        /// <value>The fecha solicitud.</value>
        public DateTime FechaSolicitud { get; set; }

        /// <summary>
        /// Gets or sets the fecha no repudio.
        /// </summary>
        /// <value>The fecha no repudio.</value>
        public DateTime FechaNoRepudio { get; set; }

        /// <summary>
        /// Gets or sets the fecha tramite.
        /// </summary>
        /// <value>The fecha tramite.</value>
        public DateTime FechaTramite { get; set; }

        /// <summary>
        /// Gets or sets the fecha confirmacion.
        /// </summary>
        /// <value>The fecha confirmacion.</value>
        public DateTime FechaConfirmacion { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="UsuariosModels" /> is acepta.
        /// </summary>
        /// <value><c>true</c> if acepta; otherwise, <c>false</c>.</value>
        public bool Acepta { get; set; }

        /// <summary>
        /// Gets or sets the password.
        /// </summary>
        /// <value>The password.</value>
        public string Password { get; set; }

        /// <summary>
        /// Gets or sets the new password.
        /// </summary>
        /// <value>The new password.</value>
        public string NewPassword { get; set; }

        /// <summary>
        /// Gets or sets the URL.
        /// </summary>
        /// <value>The URL.</value>
        public string Url { get; set; }

        /// <summary>
        /// Nombre Archivo Adjunto usado para rechazos
        /// </summary>
        public string NombreArchivo { get; set; }

        #region datos de auditoria

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

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class CampanaEmailModels.
    /// </summary>
    public class CampanaEmailModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the asunto.
        /// </summary>
        /// <value>The asunto.</value>
        public string Asunto { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// </summary>
        /// <value>The mensaje.</value>
        public string Mensaje { get; set; }

        /// <summary>
        /// Gets or sets the Id usuario.
        /// </summary>
        /// <value>The Id usuario.</value>
        public int IdUsuario { get; set; }

        /// <summary>
        /// Gets or sets the usuario.
        /// </summary>
        /// <value>The usuario.</value>
        public string Usuario { get; set; }

        /// <summary>
        /// Gets or sets the tipo usuario.
        /// </summary>
        /// <value>The tipo usuario.</value>
        public int IdTipoUsuario { get; set; }

        /// <summary>
        /// Gets or sets the total.
        /// </summary>
        /// <value>The total.</value>
        public int Total { get; set; }

        /// <summary>
        /// Gets or sets the enviados.
        /// </summary>
        /// <value>The enviados.</value>
        public int Enviados { get; set; }

        /// <summary>
        /// Gets or sets the correo prueba.
        /// </summary>
        /// <value>The correo prueba.</value>
        public string CorreoUsuarioContactenos { get; set; }

        /// <summary>
        /// Gets or sets the correo prueba.
        /// </summary>
        /// <value>The correo prueba.</value>
        public string CorreoPrueba { get; set; }

        /// <summary>
        /// Gets or sets the adjunto.
        /// </summary>
        /// <value>The adjunto.</value>
        public HttpPostedFileBase Adjunto { get; set; }

        #region datos de auditoria

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

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class RolRecursosModels.
    /// </summary>
    public class TipoUsuarioRecursosModels
    {
        /// <summary>
        /// Gets or sets the identifier rol.
        /// </summary>
        /// <value>The identifier rol.</value>
        public int IdTipoUsuario { get; set; }

        /// <summary>
        /// Gets or sets the identifier recurso.
        /// </summary>
        /// <value>The identifier recurso.</value>
        public int IdRecurso { get; set; }

        /// <summary>
        /// Gets or sets the identifier sub recurso.
        /// </summary>
        /// <value>The identifier sub recurso.</value>
        public int IdSubRecurso { get; set; }

        /// <summary>
        /// Gets or sets the lista identifier sub recurso.
        /// </summary>
        /// <value>The lista identifier sub recurso.</value>
        public string ListaIdSubRecurso { get; set; }

        #region datos de auditoria

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

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class PermisoUsuarioEncuestaModels.
    /// </summary>
    public class PermisoUsuarioEncuestaModels
    {
        /// <summary>
        /// Gets or sets the username.
        /// </summary>
        /// <value>The username.</value>
        public int IdUsuario { get; set; }

        /// <summary>
        /// Gets or sets the identifier encuesta.
        /// </summary>
        /// <value>The identifier encuesta.</value>
        public int IdEncuesta { get; set; }

        /// <summary>
        /// Gets or sets the fecha fin.
        /// </summary>
        /// <value>The fecha fin.</value>
        public DateTime FechaFin { get; set; }

        /// <summary>
        /// Gets or sets the when action.
        /// </summary>
        /// <value>The when action.</value>
        public DateTime FechaTramite { get; set; }

        public int IdTipoTramite { get; set; }

        #region datos de auditoria

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

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class UserModel.
    /// </summary>
    public class UserModel
    {
        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        [Required]
        [Display(Name = "User name")]
        public string UserName { get; set; }

        /// <summary>
        /// Gets or sets the password.
        /// </summary>
        /// <value>The password.</value>
        [Required]
        [StringLength(100, ErrorMessage = "El {0} debe tener al menos {2} caracteres.", MinimumLength = 6)]
        [DataType(DataType.Password)]
        [Display(Name = "Clave")]
        public string Password { get; set; }

        /// <summary>
        /// Gets or sets the confirm password.
        /// </summary>
        /// <value>The confirm password.</value>
        [DataType(DataType.Password)]
        [Display(Name = "Confirmación clave")]
        [Compare("Clave", ErrorMessage = "La clave y la confirmación de clave no coinciden.")]
        public string ConfirmPassword { get; set; }
    }

    /// <summary>
    /// Class RolModel.
    /// </summary>
    public class RolModel
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public string Id { get; set; }

        /// <summary>
        /// Gets or sets the name.
        /// </summary>
        /// <value>The name.</value>
        public string Nombre { get; set; }

        #region datos de auditoria

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

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    /// <summary>
    /// Class RolIncluirModel.
    /// </summary>
    public class RolIncluirModel
    {
        /// <summary>
        /// Gets or sets the identifier rol.
        /// </summary>
        /// <value>The identifier rol.</value>
        public string IdRol { get; set; }

        /// <summary>
        /// Gets or sets the ids usuarios.
        /// </summary>
        /// <value>The ids usuarios.</value>
        public string IdsUsuarios { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="RolIncluirModel" /> is incluir.
        /// </summary>
        /// <value><c>true</c> if incluir; otherwise, <c>false</c>.</value>
        public bool Incluir { get; set; }

        #region datos de auditoria

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

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    public class TiposExtensiones
    {
        public int idTipo { get; set; }
        public string tipoExtension { get; set; }
    }
}