// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 13-06-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-20-2017
// ***********************************************************************
// <copyright file="RespuestaPat.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************
using System;
using System.Collections.Generic;

/// <summary>
/// The Models namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Models
{
    /// <summary>
    /// Class RespuestaPat.
    /// </summary>
    public class RespuestaPat
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int ID { get; set; }
        /// <summary>
        /// Gets or sets the identidad.
        /// </summary>
        /// <value>The identidad.</value>
        public int IDENTIDAD { get; set; }
        /// <summary>
        /// Gets or sets the idusuario.
        /// </summary>
        /// <value>The idusuario.</value>
        public int IDUSUARIO { get; set; }
        /// <summary>
        /// Gets or sets the idpregunta.
        /// </summary>
        /// <value>The idpregunta.</value>
        public short IDPREGUNTA { get; set; }
        /// <summary>
        /// Gets or sets the necesidadidentificada.
        /// </summary>
        /// <value>The necesidadidentificada.</value>
        public Nullable<int> NECESIDADIDENTIFICADA { get; set; }
        /// <summary>
        /// Gets or sets the respuestaindicativa.
        /// </summary>
        /// <value>The respuestaindicativa.</value>
        public Nullable<int> RESPUESTAINDICATIVA { get; set; }
        /// <summary>
        /// Gets or sets the respuestacompromiso.
        /// </summary>
        /// <value>The respuestacompromiso.</value>
        public Nullable<int> RESPUESTACOMPROMISO { get; set; }
        /// <summary>
        /// Gets or sets the presupuesto.
        /// </summary>
        /// <value>The presupuesto.</value>
        public Nullable<decimal> PRESUPUESTO { get; set; }
        /// <summary>
        /// Gets or sets the observacionnecesidad.
        /// </summary>
        /// <value>The observacionnecesidad.</value>
        public string OBSERVACIONNECESIDAD { get; set; }
        /// <summary>
        /// Gets or sets the accioncompromiso.
        /// </summary>
        /// <value>The accioncompromiso.</value>
        public string ACCIONCOMPROMISO { get; set; }
        /// <summary>
        /// Gets or sets the NombreAdjunto.
        /// </summary>
        /// <value>The NombreAdjunto.</value>
        public string NombreAdjunto { get; set; }

        public string ObservacionPresupuesto { get; set; }
        /// <summary>
        /// Gets or sets the respuesta pat accion.
        /// </summary>
        /// <value>The respuesta pat accion.</value>
        public virtual ICollection<RespuestaPatAccion> RespuestaPatAccion { get; set; }
        /// <summary>
        /// Gets or sets the respuesta pat programa.
        /// </summary>
        /// <value>The respuesta pat programa.</value>
        public virtual ICollection<RespuestaPatPrograma> RespuestaPatPrograma { get; set; }
        public virtual ICollection<FuentePresupuesto> RespuestaPatFuente { get; set; }

        #region datos de auditoría

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

    public class EnvioTablero
    {
        public int idUsuario { get; set; }
        public string Usuario { get; set; }
        public byte idTablero { get; set; }
        public int anoTablero { get; set; }
        public string tipoEnvio { get; set; }

        #region datos de auditoría

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

    public class FuentePresupuesto
    {
        public int Id { get; set; }
        public bool insertar { get; set; }
    }

    /// <summary>
    /// Class RespuestaPatAccion.
    /// </summary>
    public class RespuestaPatAccion
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int ID { get; set; }
        /// <summary>
        /// Gets or sets the i d_ pa t_ respuesta.
        /// </summary>
        /// <value>The i d_ pa t_ respuesta.</value>
        public int ID_PAT_RESPUESTA { get; set; }
        /// <summary>
        /// Gets or sets the accion.
        /// </summary>
        /// <value>The accion.</value>
        public string ACCION { get; set; }
        /// <summary>
        /// Gets or sets the activo.
        /// </summary>
        /// <value>The activo.</value>
        public Nullable<bool> ACTIVO { get; set; }
        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="RespuestaPatAccion" /> is insertado.
        /// </summary>
        /// <value><c>true</c> if insertado; otherwise, <c>false</c>.</value>
        public bool Insertado { get; set; }

        #region datos de auditoría

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
    /// Class RespuestaPatPrograma.
    /// </summary>
    public class RespuestaPatPrograma
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int ID { get; set; }
        /// <summary>
        /// Gets or sets the i d_ pa t_ respuesta.
        /// </summary>
        /// <value>The i d_ pa t_ respuesta.</value>
        public int ID_PAT_RESPUESTA { get; set; }
        /// <summary>
        /// Gets or sets the programa.
        /// </summary>
        /// <value>The programa.</value>
        public string PROGRAMA { get; set; }
        /// <summary>
        /// Gets or sets the activo.
        /// </summary>
        /// <value>The activo.</value>
        public Nullable<bool> ACTIVO { get; set; }
        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="RespuestaPatPrograma" /> is insertado.
        /// </summary>
        /// <value><c>true</c> if insertado; otherwise, <c>false</c>.</value>
        public bool Insertado { get; set; }

        #region datos de auditoría

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
    /// Class RespuestaRCPat.
    /// </summary>
    public class RespuestaRCPat
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int ID { get; set; }
        /// <summary>
        /// Gets or sets the idtablero.
        /// </summary>
        /// <value>The idtablero.</value>
        public byte IDTABLERO { get; set; }
        /// <summary>
        /// Gets or sets the idusuario.
        /// </summary>
        /// <value>The idusuario.</value>
        public int IDUSUARIO { get; set; }
        /// <summary>
        /// Gets or sets the identidad.
        /// </summary>
        /// <value>The identidad.</value>
        public int IDENTIDAD { get; set; }
        /// <summary>
        /// Gets or sets the idpreguntarc.
        /// </summary>
        /// <value>The idpreguntarc.</value>
        public short IDPREGUNTARC { get; set; }
        /// <summary>
        /// Gets or sets the accion.
        /// </summary>
        /// <value>The accion.</value>
        public string ACCION { get; set; }
        /// <summary>
        /// Gets or sets the presupuesto.
        /// </summary>
        /// <value>The presupuesto.</value>
        public Nullable<decimal> PRESUPUESTO { get; set; }
        /// <summary>
        /// Gets or sets the respuesta rc pat accion.
        /// </summary>
        /// <value>The respuesta rc pat accion.</value>
        public virtual ICollection<RespuestaRCPatAccion> RespuestaRCPatAccion { get; set; }

        #region datos de auditoría

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
    /// Class RespuestaRCPatAccion.
    /// </summary>
    public class RespuestaRCPatAccion
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int ID { get; set; }
        /// <summary>
        /// Gets or sets the i d_ pa t_ respuest a_ rc.
        /// </summary>
        /// <value>The i d_ pa t_ respuest a_ rc.</value>
        public int ID_PAT_RESPUESTA_RC { get; set; }
        /// <summary>
        /// Gets or sets the accion.
        /// </summary>
        /// <value>The accion.</value>
        public string ACCION { get; set; }
        /// <summary>
        /// Gets or sets the activo.
        /// </summary>
        /// <value>The activo.</value>
        public Nullable<bool> ACTIVO { get; set; }
        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="RespuestaRCPatAccion" /> is insertado.
        /// </summary>
        /// <value><c>true</c> if insertado; otherwise, <c>false</c>.</value>
        public bool Insertado { get; set; }

        #region datos de auditoría

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
    /// Class RespuestaRRPat.
    /// </summary>
    public class RespuestaRRPat
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int ID { get; set; }
        /// <summary>
        /// Gets or sets the idusuario.
        /// </summary>
        /// <value>The idusuario.</value>
        public int IDUSUARIO { get; set; }
        /// <summary>
        /// Gets or sets the i d_ tablero.
        /// </summary>
        /// <value>The i d_ tablero.</value>
        public byte ID_TABLERO { get; set; }
        /// <summary>
        /// Gets or sets the i d_ entidad.
        /// </summary>
        /// <value>The i d_ entidad.</value>
        public int ID_ENTIDAD { get; set; }
        /// <summary>
        /// Gets or sets the i d_ pregunt a_ rr.
        /// </summary>
        /// <value>The i d_ pregunt a_ rr.</value>
        public short ID_PREGUNTA_RR { get; set; }
        /// <summary>
        /// Gets or sets the accion.
        /// </summary>
        /// <value>The accion.</value>
        public string ACCION { get; set; }
        /// <summary>
        /// Gets or sets the presupuesto.
        /// </summary>
        /// <value>The presupuesto.</value>
        public Nullable<decimal> PRESUPUESTO { get; set; }
        /// <summary>
        /// Gets or sets the respuesta rr pat accion.
        /// </summary>
        /// <value>The respuesta rr pat accion.</value>
        public virtual ICollection<RespuestaRRPatAccion> RespuestaRRPatAccion { get; set; }

        #region datos de auditoría

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
    /// Class RespuestaRRPatAccion.
    /// </summary>
    public class RespuestaRRPatAccion
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int ID { get; set; }
        /// <summary>
        /// Gets or sets the i d_ pa t_ respuest a_ rr.
        /// </summary>
        /// <value>The i d_ pa t_ respuest a_ rr.</value>
        public int ID_PAT_RESPUESTA_RR { get; set; }
        /// <summary>
        /// Gets or sets the accion.
        /// </summary>
        /// <value>The accion.</value>
        public string ACCION { get; set; }
        /// <summary>
        /// Gets or sets the activo.
        /// </summary>
        /// <value>The activo.</value>
        public Nullable<bool> ACTIVO { get; set; }
        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="RespuestaRRPatAccion" /> is insertado.
        /// </summary>
        /// <value><c>true</c> if insertado; otherwise, <c>false</c>.</value>
        public bool Insertado { get; set; }

        #region datos de auditoría

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
    /// Class RespuestaPatDepartamentos.
    /// </summary>
    public class RespuestaPatDepartamentos
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int ID { get; set; }
        /// <summary>
        /// Gets or sets the idtablero.
        /// </summary>
        /// <value>The idtablero.</value>
        public byte IDTABLERO { get; set; }
        /// <summary>
        /// Gets or sets the idmunicipio.
        /// </summary>
        /// <value>The idmunicipio.</value>
        public int IDMUNICIPIO { get; set; }
        /// <summary>
        /// Gets or sets the idpregunta.
        /// </summary>
        /// <value>The idpregunta.</value>
        public short IDPREGUNTA { get; set; }
        /// <summary>
        /// Gets or sets the respuestacompromiso.
        /// </summary>
        /// <value>The respuestacompromiso.</value>
        public Nullable<int> RESPUESTACOMPROMISO { get; set; }
        /// <summary>
        /// Gets or sets the presupuesto.
        /// </summary>
        /// <value>The presupuesto.</value>
        public Nullable<decimal> PRESUPUESTO { get; set; }
        /// <summary>
        /// Gets or sets the observacioncompromiso.
        /// </summary>
        /// <value>The observacioncompromiso.</value>
        public string OBSERVACIONCOMPROMISO { get; set; }
        /// <summary>
        /// Gets or sets the idmunicipiorespuesta.
        /// </summary>
        /// <value>The idmunicipiorespuesta.</value>
        public int IDMUNICIPIORESPUESTA { get; set; }
        /// <summary>
        /// Gets or sets the idusuario.
        /// </summary>
        /// <value>The idusuario.</value>
        public int IDUSUARIO { get; set; }

        public virtual ICollection<RespuestaPatAccion> RespuestaPatAccion { get; set; }
        public virtual ICollection<RespuestaPatPrograma> RespuestaPatPrograma { get; set; }

        #region datos de auditoría

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
    /// Class RespuestaPatDepartamentosRC.
    /// </summary>
    public class RespuestaPatDepartamentosRC
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }
        /// <summary>
        /// Gets or sets the identifier tablero.
        /// </summary>
        /// <value>The identifier tablero.</value>
        public byte IdTablero { get; set; }
        /// <summary>
        /// Gets or sets the identifier pregunta reparacion colectiva.
        /// </summary>
        /// <value>The identifier pregunta reparacion colectiva.</value>
        public short IdPreguntaReparacionColectiva { get; set; }
        /// <summary>
        /// Gets or sets the presupuesto departamento.
        /// </summary>
        /// <value>The presupuesto departamento.</value>
        public Nullable<decimal> PresupuestoDepartamento { get; set; }
        /// <summary>
        /// Gets or sets the accion departamento.
        /// </summary>
        /// <value>The accion departamento.</value>
        public string AccionDepartamento { get; set; }
        /// <summary>
        /// Gets or sets the identifier municipio respuesta.
        /// </summary>
        /// <value>The identifier municipio respuesta.</value>
        public int IdMunicipioRespuesta { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public int IdUsuario { get; set; }
        /// <summary>
        /// Gets or sets the identifier Respuesta Municipio RC.
        /// </summary>
        /// <value>The identifier Respuesta Municipio RC.</value>
        public byte IdRespuestaMunicipioRC { get; set; }

        #region datos de auditoría

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
    /// Class RespuestaPatDepartamentosRR.
    /// </summary>
    public class RespuestaPatDepartamentosRR
    {
        /// <summary>
        /// Gets or sets the identifier respuesta departamento.
        /// </summary>
        /// <value>The identifier respuesta departamento.</value>
        public int IdRespuestaDepartamento { get; set; }
        /// <summary>
        /// Gets or sets the identifier tablero.
        /// </summary>
        /// <value>The identifier tablero.</value>
        public byte IdTablero { get; set; }
        /// <summary>
        /// Gets or sets the identifier pregunta rr.
        /// </summary>
        /// <value>The identifier pregunta rr.</value>
        public short IdPreguntaRR { get; set; }
        /// <summary>
        /// Gets or sets the presupuesto departamento.
        /// </summary>
        /// <value>The presupuesto departamento.</value>
        public Nullable<decimal> PresupuestoDepartamento { get; set; }
        /// <summary>
        /// Gets or sets the accion departamento.
        /// </summary>
        /// <value>The accion departamento.</value>
        public string AccionDepartamento { get; set; }
        /// <summary>
        /// Gets or sets the identifier municipio respuesta.
        /// </summary>
        /// <value>The identifier municipio respuesta.</value>
        public int IdMunicipioRespuesta { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public int IdUsuario { get; set; }

        #region datos de auditoría

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
    /// Class PreguntasPAT.
    /// </summary>
    public class PreguntasPAT
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the identifier derecho.
        /// </summary>
        /// <value>The identifier derecho.</value>
        public short IdDerecho { get; set; }

        /// <summary>
        /// Gets or sets the identifier componente.
        /// </summary>
        /// <value>The identifier componente.</value>
        public int IdComponente { get; set; }

        /// <summary>
        /// Gets or sets the identifier medida.
        /// </summary>
        /// <value>The identifier medida.</value>
        public int IdMedida { get; set; }

        /// <summary>
        /// Gets or sets the nivel.
        /// </summary>
        /// <value>The nivel.</value>
        public byte Nivel { get; set; }

        /// <summary>
        /// Gets or sets the pregunta indicativa.
        /// </summary>
        /// <value>The pregunta indicativa.</value>
        public string PreguntaIndicativa { get; set; }

        /// <summary>
        /// Gets or sets the identifier unidad medida.
        /// </summary>
        /// <value>The identifier unidad medida.</value>
        public byte IdUnidadMedida { get; set; }

        /// <summary>
        /// Gets or sets the pregunta compromiso.
        /// </summary>
        /// <value>The pregunta compromiso.</value>
        public string PreguntaCompromiso { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [apoyo departamental].
        /// </summary>
        /// <value><c>true</c> if [apoyo departamental]; otherwise, <c>false</c>.</value>
        public bool ApoyoDepartamental { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [apoyo entidad nacional].
        /// </summary>
        /// <value><c>true</c> if [apoyo entidad nacional]; otherwise, <c>false</c>.</value>
        public bool ApoyoEntidadNacional { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="PreguntasPAT" /> is activo.
        /// </summary>
        /// <value><c>true</c> if activo; otherwise, <c>false</c>.</value>
        public bool Activo { get; set; }

        /// <summary>
        /// Gets or sets the identifier tablero.
        /// </summary>
        /// <value>The identifier tablero.</value>
        public byte IdTablero { get; set; }

        /// <summary>
        /// Gets or sets the ids nivel.
        /// Corresponde a los departamentos o municipios de acuerdo al nivel seleccionado en
        /// el tablero. Estos vienen concatenados y separados por comas y de acuerdo al parámetro 
        /// incluir los retira o los relaciona a la pregunta.
        /// </summary>
        /// <value>The ids Nivel.</value>
        public string IdsNivel { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="PreguntasPAT" /> is incluir.
        /// Determina si se relacionan los departamentos o municipios a la pregunta
        /// </summary>
        /// <value><c>true</c> if incluir; otherwise, <c>false</c>.</value>
        public bool Incluir { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="PreguntasPAT" /> is incluir.
        /// Determina la pregunta en su diligenciamiento requiere o no que se adjunte un documento
        /// </summary>
        /// <value><c>true</c> if incluir; otherwise, <c>false</c>.</value>
        public bool RequiereAdjunto { get; set; }

        /// <summary>
        /// Gets or sets the mensaje a mostrar en el diligenciamiento en caso de requerir adjutno.
        /// </summary>
        /// <value>Mensaje del Adjunto</value>
        public string MensajeAdjunto { get; set; }

        /// <summary>
        /// Gets or sets the explicacion de la pregunta.
        /// </summary>
        /// <value>Explicacion de la Pregunta.</value>
        public string ExplicacionPregunta { get; set; }

        /// <summary>
        /// Gets or sets the ids dane.
        /// </summary>
        /// <value>The ids dane.</value>
        public string IdsDane { get; set; }

        #region datos de auditoría

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

    public class PreguntasRCPAT
    {
        public int Id { get; set; }
        public int IdMedida { get; set; }
        public string Sujeto { get; set; }
        public string MedidaReparacionColectiva { get; set; }
        public int IdDepartamento { get; set; }
        public int IdMunicipio { get; set; }
        public byte IdTablero { get; set; }
        public bool Activo { get; set; }

        #region datos de auditoría

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

    public class PreguntasRRPAT
    {
        public int Id { get; set; }
        public int Hogares { get; set; }
        public int Personas { get; set; }
        public string Sector { get; set; }
        public string Componente { get; set; }
        public string Comunidad { get; set; }
        public string Ubicacion { get; set; }
        public string MedidaRetornoReubicacion { get; set; }
        public string IndicadorRetornoReubicacion { get; set; }
        public string EntidadResponsable { get; set; }
        public int IdDepartamento { get; set; }
        public int IdMunicipio { get; set; }
        public byte IdTablero { get; set; }
        public bool Activo { get; set; }

        #region datos de auditoría

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
    /// Class SeguimientoPAT.
    /// </summary>
    public class SeguimientoPAT
    {
        /// <summary>
        /// Gets or sets the identifier seguimiento.
        /// </summary>
        /// <value>The identifier seguimiento.</value>
        public int IdSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the identifier tablero.
        /// </summary>
        /// <value>The identifier tablero.</value>
        public byte IdTablero { get; set; }
        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public short IdPregunta { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public int IdUsuario { get; set; }
        /// <summary>
        /// Gets or sets the fecha seguimiento.
        /// </summary>
        /// <value>The fecha seguimiento.</value>
        public System.DateTime FechaSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the cantidad primer.
        /// </summary>
        /// <value>The cantidad primer.</value>
        public long CantidadPrimer { get; set; }
        /// <summary>
        /// Gets or sets the presupuesto primer.
        /// </summary>
        /// <value>The presupuesto primer.</value>
        public decimal PresupuestoPrimer { get; set; }
        /// <summary>
        /// Gets or sets the cantidad segundo.
        /// </summary>
        /// <value>The cantidad segundo.</value>
        public long CantidadSegundo { get; set; }
        /// <summary>
        /// Gets or sets the presupuesto segundo.
        /// </summary>
        /// <value>The presupuesto segundo.</value>
        public decimal PresupuestoSegundo { get; set; }
        /// <summary>
        /// Gets or sets the observaciones.
        /// </summary>
        /// <value>The observaciones.</value>
        public string Observaciones { get; set; }
        /// <summary>
        /// Gets or sets the nombre adjunto.
        /// </summary>
        /// <value>The nombre adjunto.</value>
        public string NombreAdjunto { get; set; }

        public string ObservacionesSegundo { get; set; }
        public string NombreAdjuntoSegundo { get; set; }

        public int CompromisoDefinitivo { get; set; }
        public decimal PresupuestoDefinitivo { get; set; }

        public string ObservacionesDefinitivo { get; set; }

        /// <summary>
        /// Gets or sets the seguimiento programas.
        /// </summary>
        /// <value>The seguimiento programas.</value>
        public virtual ICollection<SeguimientoProgramas> SeguimientoProgramas { get; set; }

        #region datos de auditoría

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
    /// Class SeguimientoProgramas.
    /// </summary>
    public class SeguimientoProgramas
    {
        /// <summary>
        /// Gets or sets the identifier seguimiento programa.
        /// </summary>
        /// <value>The identifier seguimiento programa.</value>
        public int IdSeguimientoPrograma { get; set; }

        /// <summary>
        /// Gets or sets the identifier seguimiento.
        /// </summary>
        /// <value>The identifier seguimiento.</value>
        public int IdSeguimiento { get; set; }

        /// <summary>
        /// Gets or sets the programa.
        /// </summary>
        /// <value>The programa.</value>
        public string PROGRAMA { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="SeguimientoProgramas" /> is insertado.
        /// </summary>
        /// <value><c>true</c> if insertado; otherwise, <c>false</c>.</value>
        public bool Insertado { get; set; }

        public byte NumeroSeguimiento { get; set; }

        #region datos de auditoría

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
    /// Class SeguimientoPATGobernacion.
    /// </summary>
    public class SeguimientoPATGobernacion
    {
        /// <summary>
        /// Gets or sets the identifier seguimiento.
        /// </summary>
        /// <value>The identifier seguimiento.</value>
        public int IdSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the identifier tablero.
        /// </summary>
        /// <value>The identifier tablero.</value>
        public byte IdTablero { get; set; }
        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public short IdPregunta { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public int IdUsuario { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario alcaldia.
        /// </summary>
        /// <value>The identifier usuario alcaldia.</value>
        public int IdUsuarioAlcaldia { get; set; }
        /// <summary>
        /// Gets or sets the fecha seguimiento.
        /// </summary>
        /// <value>The fecha seguimiento.</value>
        public System.DateTime FechaSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the cantidad primer.
        /// </summary>
        /// <value>The cantidad primer.</value>
        public long CantidadPrimer { get; set; }
        /// <summary>
        /// Gets or sets the presupuesto primer.
        /// </summary>
        /// <value>The presupuesto primer.</value>
        public decimal PresupuestoPrimer { get; set; }
        /// <summary>
        /// Gets or sets the cantidad segundo.
        /// </summary>
        /// <value>The cantidad segundo.</value>
        public long CantidadSegundo { get; set; }
        /// <summary>
        /// Gets or sets the presupuesto segundo.
        /// </summary>
        /// <value>The presupuesto segundo.</value>
        public decimal PresupuestoSegundo { get; set; }
        /// <summary>
        /// Gets or sets the observaciones.
        /// </summary>
        /// <value>The observaciones.</value>
        public string Observaciones { get; set; }
        /// <summary>
        /// Gets or sets the nombre adjunto.
        /// </summary>
        /// <value>The nombre adjunto.</value>
        public string NombreAdjunto { get; set; }

        public string ObservacionesSegundo { get; set; }
        public string NombreAdjuntoSegundo { get; set; }

        public int CompromisoDefinitivo { get; set; }
        public decimal PresupuestoDefinitivo { get; set; }
        public string ObservacionesDefinitivo { get; set; }

        /// <summary>
        /// Gets or sets the seguimiento programas.
        /// </summary>
        /// <value>The seguimiento programas.</value>
        public virtual ICollection<SeguimientoProgramas> SeguimientoProgramas { get; set; }

        #region datos de auditoría

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
    /// Class SeguimientoRetornosReubicaciones.
    /// </summary>
    public partial class SeguimientoRetornosReubicaciones
    {
        /// <summary>
        /// Gets or sets the identifier seguimiento rr.
        /// </summary>
        /// <value>The identifier seguimiento rr.</value>
        public int IdSeguimientoRR { get; set; }
        /// <summary>
        /// Gets or sets the identifier tablero.
        /// </summary>
        /// <value>The identifier tablero.</value>
        public byte IdTablero { get; set; }
        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public short IdPregunta { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public int IdUsuario { get; set; }
        /// <summary>
        /// Gets or sets the fecha seguimiento.
        /// </summary>
        /// <value>The fecha seguimiento.</value>
        public System.DateTime FechaSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the avance primer.
        /// </summary>
        /// <value>The avance primer.</value>
        public string AvancePrimer { get; set; }
        /// <summary>
        /// Gets or sets the avance segundo.
        /// </summary>
        /// <value>The avance segundo.</value>
        public string AvanceSegundo { get; set; }
        /// <summary>
        /// Gets or sets the nombre adjunto.
        /// </summary>
        /// <value>The nombre adjunto.</value>
        public string NombreAdjunto { get; set; }

        #region datos de auditoría

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
    /// Class SeguimientoRetornosReubicacionesDepto.
    /// </summary>
    public partial class SeguimientoRetornosReubicacionesDepto
    {
        /// <summary>
        /// Gets or sets the identifier seguimiento rr.
        /// </summary>
        /// <value>The identifier seguimiento rr.</value>
        public int IdSeguimientoRR { get; set; }
        /// <summary>
        /// Gets or sets the identifier tablero.
        /// </summary>
        /// <value>The identifier tablero.</value>
        public byte IdTablero { get; set; }
        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public short IdPregunta { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public int IdUsuario { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario alcaldia.
        /// </summary>
        /// <value>The identifier usuario alcaldia.</value>
        public int IdUsuarioAlcaldia { get; set; }
        /// <summary>
        /// Gets or sets the fecha seguimiento.
        /// </summary>
        /// <value>The fecha seguimiento.</value>
        public System.DateTime FechaSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the avance primer.
        /// </summary>
        /// <value>The avance primer.</value>
        public string AvancePrimer { get; set; }
        /// <summary>
        /// Gets or sets the avance segundo.
        /// </summary>
        /// <value>The avance segundo.</value>
        public string AvanceSegundo { get; set; }
        /// <summary>
        /// Gets or sets the nombre adjunto.
        /// </summary>
        /// <value>The nombre adjunto.</value>
        public string NombreAdjunto { get; set; }

        #region datos de auditoría

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
    /// Class SeguimientoReparacionColectiva.
    /// </summary>
    public partial class SeguimientoReparacionColectiva
    {
        /// <summary>
        /// Gets or sets the identifier seguimiento rc.
        /// </summary>
        /// <value>The identifier seguimiento rc.</value>
        public int IdSeguimientoRC { get; set; }
        /// <summary>
        /// Gets or sets the identifier tablero.
        /// </summary>
        /// <value>The identifier tablero.</value>
        public byte IdTablero { get; set; }
        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public short IdPregunta { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public int IdUsuario { get; set; }
        /// <summary>
        /// Gets or sets the fecha seguimiento.
        /// </summary>
        /// <value>The fecha seguimiento.</value>
        public System.DateTime FechaSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the avance primer.
        /// </summary>
        /// <value>The avance primer.</value>
        public string AvancePrimer { get; set; }
        /// <summary>
        /// Gets or sets the avance segundo.
        /// </summary>
        /// <value>The avance segundo.</value>
        public string AvanceSegundo { get; set; }
        /// <summary>
        /// Gets or sets the nombre adjunto.
        /// </summary>
        /// <value>The nombre adjunto.</value>
        public string NombreAdjunto { get; set; }
        /// <summary>
        /// Gets or sets the identifier respuesta rc.
        /// </summary>
        /// <value>The identifier respuesta rc.</value>
        public int IdRespuestaRC { get; set; }

        #region datos de auditoría

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
    /// Class SeguimientoReparacionColectivaDepto.
    /// </summary>
    public partial class SeguimientoReparacionColectivaDepto
    {
        /// <summary>
        /// Gets or sets the identifier seguimiento rc.
        /// </summary>
        /// <value>The identifier seguimiento rc.</value>
        public int IdSeguimientoRC { get; set; }
        /// <summary>
        /// Gets or sets the identifier tablero.
        /// </summary>
        /// <value>The identifier tablero.</value>
        public byte IdTablero { get; set; }
        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public short IdPregunta { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public int IdUsuario { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario alcaldia.
        /// </summary>
        /// <value>The identifier usuario alcaldia.</value>
        public int IdUsuarioAlcaldia { get; set; }
        /// <summary>
        /// Gets or sets the fecha seguimiento.
        /// </summary>
        /// <value>The fecha seguimiento.</value>
        public System.DateTime FechaSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the avance primer.
        /// </summary>
        /// <value>The avance primer.</value>
        public string AvancePrimer { get; set; }
        /// <summary>
        /// Gets or sets the avance segundo.
        /// </summary>
        /// <value>The avance segundo.</value>
        public string AvanceSegundo { get; set; }
        /// <summary>
        /// Gets or sets the nombre adjunto.
        /// </summary>
        /// <value>The nombre adjunto.</value>
        public string NombreAdjunto { get; set; }
        /// <summary>
        /// Gets or sets the identifier respuesta rc.
        /// </summary>
        /// <value>The identifier respuesta rc.</value>
        public int IdRespuestaRC { get; set; }

        #region datos de auditoría

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
    /// Class SeguimientoOtrosDerechos.
    /// </summary>
    public partial class SeguimientoOtrosDerechos
    {
        /// <summary>
        /// Gets or sets the identifier seguimiento.
        /// </summary>
        /// <value>The identifier seguimiento.</value>
        public int IdSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the identifier tablero.
        /// </summary>
        /// <value>The identifier tablero.</value>
        public byte IdTablero { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public int IdUsuario { get; set; }
        /// <summary>
        /// Gets or sets the fecha seguimiento.
        /// </summary>
        /// <value>The fecha seguimiento.</value>
        public System.DateTime FechaSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the accion.
        /// </summary>
        /// <value>The accion.</value>
        public string Accion { get; set; }
        /// <summary>
        /// Gets or sets the number seguimiento.
        /// </summary>
        /// <value>The number seguimiento.</value>
        public int NumSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the identifier unidad.
        /// </summary>
        /// <value>The identifier unidad.</value>
        public byte IdUnidad { get; set; }
        /// <summary>
        /// Gets or sets the presupuesto.
        /// </summary>
        /// <value>The presupuesto.</value>
        public decimal Presupuesto { get; set; }
        /// <summary>
        /// Gets or sets the observaciones.
        /// </summary>
        /// <value>The observaciones.</value>
        public string Observaciones { get; set; }
        /// <summary>
        /// Gets or sets the nombre adjunto.
        /// </summary>
        /// <value>The nombre adjunto.</value>
        public string NombreAdjunto { get; set; }
        /// <summary>
        /// Gets or sets the programa.
        /// </summary>
        /// <value>The programa.</value>
        public string Programa { get; set; }

        /// <summary>
        /// Gets or sets the seguimiento otros derechos medidas.
        /// </summary>
        /// <value>The seguimiento otros derechos medidas.</value>
        public virtual ICollection<SeguimientoOtrosDerechosMedidas> SeguimientoOtrosDerechosMedidas { get; set; }

        #region datos de auditoría

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
    /// Class SeguimientoOtrosDerechosMedidas.
    /// </summary>
    public partial class SeguimientoOtrosDerechosMedidas
    {
        /// <summary>
        /// Gets or sets the identifier seguimiento medidas.
        /// </summary>
        /// <value>The identifier seguimiento medidas.</value>
        public int IdSeguimientoMedidas { get; set; }
        /// <summary>
        /// Gets or sets the identifier seguimiento.
        /// </summary>
        /// <value>The identifier seguimiento.</value>
        public int IdSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the identifier medida.
        /// </summary>
        /// <value>The identifier medida.</value>
        public int IdMedida { get; set; }
        /// <summary>
        /// Gets or sets the identifier componente.
        /// </summary>
        /// <value>The identifier componente.</value>
        public int IdComponente { get; set; }
        /// <summary>
        /// Gets or sets the identifier derecho.
        /// </summary>
        /// <value>The identifier derecho.</value>
        public int IdDerecho { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="SeguimientoOtrosDerechosMedidas"/> is insertado.
        /// </summary>
        /// <value><c>true</c> if insertado; otherwise, <c>false</c>.</value>
        public bool Insertado { get; set; }

        #region datos de auditoría

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
    /// Class SeguimientoGobernacionOtrosDerechos.
    /// </summary>
    public partial class SeguimientoGobernacionOtrosDerechos
    {
        /// <summary>
        /// Gets or sets the identifier seguimiento.
        /// </summary>
        /// <value>The identifier seguimiento.</value>
        public int IdSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the identifier tablero.
        /// </summary>
        /// <value>The identifier tablero.</value>
        public byte IdTablero { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public int IdUsuario { get; set; }
        /// <summary>
        /// Gets or sets the identifier usuario alcaldia.
        /// </summary>
        /// <value>The identifier usuario alcaldia.</value>
        public int IdUsuarioAlcaldia { get; set; }
        /// <summary>
        /// Gets or sets the fecha seguimiento.
        /// </summary>
        /// <value>The fecha seguimiento.</value>
        public System.DateTime FechaSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the accion.
        /// </summary>
        /// <value>The accion.</value>
        public string Accion { get; set; }
        /// <summary>
        /// Gets or sets the cantidad.
        /// </summary>
        /// <value>The cantidad.</value>
        public int Cantidad { get; set; }
        /// <summary>
        /// Gets or sets the identifier unidad.
        /// </summary>
        /// <value>The identifier unidad.</value>
        public byte IdUnidad { get; set; }
        /// <summary>
        /// Gets or sets the presupuesto.
        /// </summary>
        /// <value>The presupuesto.</value>
        public decimal Presupuesto { get; set; }
        /// <summary>
        /// Gets or sets the observaciones.
        /// </summary>
        /// <value>The observaciones.</value>
        public string Observaciones { get; set; }
        /// <summary>
        /// Gets or sets the nombre adjunto.
        /// </summary>
        /// <value>The nombre adjunto.</value>
        public string NombreAdjunto { get; set; }
        /// <summary>
        /// Gets or sets the programa.
        /// </summary>
        /// <value>The programa.</value>
        public string Programa { get; set; }

        /// <summary>
        /// Gets or sets the seguimiento gobernacion otros derechos medidas.
        /// </summary>
        /// <value>The seguimiento gobernacion otros derechos medidas.</value>
        public virtual ICollection<SeguimientoGobernacionOtrosDerechosMedidas> SeguimientoGobernacionOtrosDerechosMedidas { get; set; }

        #region datos de auditoría

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
    /// Class SeguimientoGobernacionOtrosDerechosMedidas.
    /// </summary>
    public partial class SeguimientoGobernacionOtrosDerechosMedidas
    {
        /// <summary>
        /// Gets or sets the identifier seguimiento medidas.
        /// </summary>
        /// <value>The identifier seguimiento medidas.</value>
        public int IdSeguimientoMedidas { get; set; }
        /// <summary>
        /// Gets or sets the identifier seguimiento.
        /// </summary>
        /// <value>The identifier seguimiento.</value>
        public int IdSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the identifier medida.
        /// </summary>
        /// <value>The identifier medida.</value>
        public int IdMedida { get; set; }
        /// <summary>
        /// Gets or sets the identifier componente.
        /// </summary>
        /// <value>The identifier componente.</value>
        public int IdComponente { get; set; }
        /// <summary>
        /// Gets or sets the identifier derecho.
        /// </summary>
        /// <value>The identifier derecho.</value>
        public int IdDerecho { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="SeguimientoGobernacionOtrosDerechosMedidas" /> is insertado.
        /// </summary>
        /// <value><c>true</c> if insertado; otherwise, <c>false</c>.</value>
        public bool Insertado { get; set; }

        #region datos de auditoría

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
    /// Class TableroPAT.
    /// </summary>
    public class TableroPAT
    {
        public int Id { get; set; }
        public byte IdTablero { get; set; }
        public byte Nivel { get; set; }
        public DateTime VigenciaInicio { get; set; }
        public DateTime VigenciaFin { get; set; }
        public bool Activo { get; set; }
        public DateTime? Seguimiento1Inicio { get; set; }
        public DateTime? Seguimiento1Fin { get; set; }
        public DateTime? Seguimiento2Inicio { get; set; }
        public DateTime? Seguimiento2Fin { get; set; }
        public bool activoEnvioPATPlaneacion { get; set; }
        public bool activoEnvioPATSeguimiento { get; set; }

        #region datos de auditoría

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
    public class ConsumoServiciosPAT
    {
        public int ano { get; set; }
        public int semestre { get; set; }
        public int idTablero { get; set; }
        public DateTime fechaIni { get; set; }
        public DateTime fechaFin { get; set; }
        #region datos de auditoría

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
    public partial class C_ProgramasPATSeguimiento
    {
        public string PROGRAMA { get; set; }
        public int ID { get; set; }
        public byte? NumeroSeguimiento { get; set; }
    }
}