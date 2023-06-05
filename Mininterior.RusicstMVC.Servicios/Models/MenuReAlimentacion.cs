// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM John Betancourt A.
// Created          : 08-01-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-23-2017
// ***********************************************************************
// <copyright file="MenuReportes.cs" company="Ministerio del Interior">
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
    /// Class AdminRetroModels.
    /// </summary>
    public class AdminRetroModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The titulo.</value>
        public string Titulo { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int IdEncuesta { get; set; }

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
    /// Clase Encuesta Models.
    /// </summary>
    public class EncuestaRetroModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the IdEncuesta.
        /// </summary>
        /// <value>The identifier retro admin.</value>
        public int IdRetroAdmin { get; set; }

        /// <summary>
        /// Gets or sets the IdEncuesta.
        /// </summary>
        /// <value>The identifier encuesta.</value>
        public int IdEncuesta { get; set; }

        /// <summary>
        /// Gets or sets the Municipio.
        /// </summary>
        /// <value>The identifier municipio.</value>
        public string Municipio { get; set; }

        /// <summary>
        /// Gets or sets the IdEncuesta.
        /// </summary>
        /// <value>The identifier tipo guardado.</value>
        public int IdTipoGuardado { get; set; }

        /// <summary>
        /// Gets or sets the Presentacion.
        /// </summary>
        /// <value>The Presentacion.</value>
        public string Presentacion { get; set; }

        /// <summary>
        /// Gets or sets the PresTexto.
        /// </summary>
        /// <value>The PresTexto.</value>
        public string PresTexto { get; set; }

        /// <summary>
        /// Gets or sets the Nivel.
        /// </summary>
        /// <value>The Nivel.</value>
        public string Nivel { get; set; }

        /// <summary>
        /// Gets or sets the NivTexto.
        /// </summary>
        /// <value>The NivTexto.</value>
        public string NivTexto { get; set; }

        /// <summary>
        /// Gets or sets the Nivel2.
        /// </summary>
        /// <value>The Nivel2.</value>
        public string Nivel2 { get; set; }

        /// <summary>
        /// Gets or sets the Niv2Texto.
        /// </summary>
        /// <value>The Niv2Texto.</value>
        public string Niv2Texto { get; set; }

        /// <summary>
        /// Gets or sets the NivIdGrafica.
        /// </summary>
        /// <value>The niv identifier grafica.</value>
        public int NivIdGrafica { get; set; }

        /// <summary>
        /// Gets or sets the Desarrollo.
        /// </summary>
        /// <value>The Desarrollo.</value>
        public string Desarrollo { get; set; }

        /// <summary>
        /// Gets or sets the DesTexto.
        /// </summary>
        /// <value>The DesTexto.</value>
        public string DesTexto { get; set; }

        /// <summary>
        /// Gets or sets the Desarrollo2.
        /// </summary>
        /// <value>The Desarrollo2.</value>
        public string Desarrollo2 { get; set; }

        /// <summary>
        /// Gets or sets the Des2Texto.
        /// </summary>
        /// <value>The Des2Texto.</value>
        public string Des2Texto { get; set; }

        /// <summary>
        /// Gets or sets the DesIdGrafica.
        /// </summary>
        /// <value>The DES identifier grafica.</value>
        public int DesIdGrafica { get; set; }

        /// <summary>
        /// Gets or sets the Analisis.
        /// </summary>
        /// <value>The Analisis.</value>
        public string Analisis { get; set; }

        /// <summary>
        /// Gets or sets the AnaTexto.
        /// </summary>
        /// <value>The AnaTexto.</value>
        public string AnaTexto { get; set; }

        /// <summary>
        /// Gets or sets the Revision.
        /// </summary>
        /// <value>The Revision.</value>
        public string Revision { get; set; }

        /// <summary>
        /// Gets or sets the RevTexto.
        /// </summary>
        /// <value>The RevTexto.</value>
        public string RevTexto { get; set; }

        /// <summary>
        /// Gets or sets the Historial.
        /// </summary>
        /// <value>The Historial.</value>
        public string Historial { get; set; }

        /// <summary>
        /// Gets or sets the HisTexto.
        /// </summary>
        /// <value>The HisTexto.</value>
        public string HisTexto { get; set; }

        /// <summary>
        /// Gets or sets the Observa.
        /// </summary>
        /// <value>The Observa.</value>
        public string Observa { get; set; }

        /// <summary>
        /// Gets or sets the ObsTexto.
        /// </summary>
        /// <value>The ObsTexto.</value>
        public string ObsTexto { get; set; }

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
    /// Class RetroGraficaNivelModel.
    /// </summary>
    public class RetroGraficaNivelModel
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the IdEncuesta.
        /// </summary>
        /// <value>The identifier retro admin.</value>
        public int IdRetroAdmin { get; set; }

        /// <summary>
        /// Gets or sets the IdEncuesta.
        /// </summary>
        /// <value>The identifier nivel graf.</value>
        public int IdNivelGraf { get; set; }

        /// <summary>
        /// Gets or sets the Presentacion.
        /// </summary>
        /// <value>The Presentacion.</value>
        public string Color1Niv { get; set; }

        /// <summary>
        /// Gets or sets the NivTexto.
        /// </summary>
        /// <value>The NivTexto.</value>
        public string Titulo { get; set; }

        /// <summary>
        /// Gets or sets the Nivel2.
        /// </summary>
        /// <value>The Nivel2.</value>
        public string Nombre1Niv { get; set; }

        /// <summary>
        /// Gets or sets the text grafica.
        /// </summary>
        /// <value>The text grafica.</value>
        public string TxtGrafica { get; set; }

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
    /// Class RetroGraficaDesarrolloModel.
    /// </summary>
    public class RetroGraficaDesarrolloModel
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the IdEncuesta.
        /// </summary>
        /// <value>The identifier retro admin.</value>
        public int IdRetroAdmin { get; set; }

        /// <summary>
        /// Gets or sets the Presentacion.
        /// </summary>
        /// <value>The Presentacion.</value>
        public string ColorDesDis { get; set; }

        /// <summary>
        /// Gets or sets the PresTexto.
        /// </summary>
        /// <value>The PresTexto.</value>
        public string ColorDesImp { get; set; }

        /// <summary>
        /// Gets or sets the Nivel.
        /// </summary>
        /// <value>The Nivel.</value>
        public string ColorDesEval { get; set; }

        /// <summary>
        /// Gets or sets the NombreSerie.
        /// </summary>
        /// <value>The Nivel2.</value>
        public string Nombre1Des { get; set; }

        /// <summary>
        /// Gets or sets the NombreSerie1.
        /// </summary>
        /// <value>The Niv2Texto.</value>
        public string Nombre2Des { get; set; }

        /// <summary>
        /// Gets or sets the NombreSerie1.
        /// </summary>
        /// <value>The nombre3 DES.</value>
        public string Nombre3Des { get; set; }

        /// <summary>
        /// Gets or sets the NombreSerie.
        /// </summary>
        /// <value>The Nivel2.</value>
        public string Nombre4Des { get; set; }

        /// <summary>
        /// Gets or sets the NombreSerie1.
        /// </summary>
        /// <value>The Niv2Texto.</value>
        public string Nombre5Des { get; set; }

        /// <summary>
        /// Gets or sets the NombreSerie1.
        /// </summary>
        /// <value>The nombre6 DES.</value>
        public string Nombre6Des { get; set; }

        /// <summary>
        /// Gets or sets the NombreSerie.
        /// </summary>
        /// <value>The Nivel2.</value>
        public string Nombre7Des { get; set; }

        /// <summary>
        /// Gets or sets the NombreSerie1.
        /// </summary>
        /// <value>The Niv2Texto.</value>
        public string Nombre8Des { get; set; }

        /// <summary>
        /// Gets or sets the NombreSerie1.
        /// </summary>
        /// <value>The nombre9 DES.</value>
        public string Nombre9Des { get; set; }

        /// <summary>
        /// Gets or sets the NombreSerie1.
        /// </summary>
        /// <value>The titulo.</value>
        public string Titulo { get; set; }

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
    /// Class RetroPreguntasDesModels.
    /// </summary>
    public class RetroPreguntasDesModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int IdRetroConsulta { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The ids encuestas.</value>
        public string IdsEncuestas { get; set; }

        /// <summary>
        /// Gets or sets the identifier encuesta.
        /// </summary>
        /// <value>The identifier encuesta.</value>
        public string IdEncuesta { get; set; }

        /// <summary>
        /// Gets or sets the nombre.
        /// </summary>
        /// <value>The nombre.</value>
        public string Nombre { get; set; }

        /// <summary>
        /// Gets or sets the nombre pregunta.
        /// </summary>
        /// <value>The nombre pregunta.</value>
        public string NombrePregunta { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The codigo pregunta.</value>
        public string CodigoPregunta { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The valor.</value>
        public string Valor { get; set; }

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
    /// Class RetroPreguntasArcModels.
    /// </summary>
    public class RetroPreguntasArcModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int IdRetroAdmin { get; set; }

        /// <summary>
        /// Gets or sets the identifier municipio.
        /// </summary>
        /// <value>The identifier municipio.</value>
        public int IdMunicipio { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The identifier encuesta.</value>
        public int IdEncuesta { get; set; }

        /// <summary>
        /// Gets or sets the documento.
        /// </summary>
        /// <value>The documento.</value>
        public string Documento { get; set; }
        /// <summary>
        /// Gets or sets the nombre pregunta.
        /// </summary>
        /// <value>The nombre pregunta.</value>
        public string NombrePregunta { get; set; }
        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The codigo pregunta.</value>
        public string CodigoPregunta { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The valor.</value>
        public string Valor { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The check.</value>
        public Boolean Check { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The sumatoria.</value>
        public Boolean Sumatoria { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The pertenece.</value>
        public int Pertenece { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The observacion.</value>
        public string Observacion { get; set; }

        /// <summary>
        /// Gets or sets the Observacion2.
        /// </summary>
        /// <value>The observacion.</value>
        public string Observacion2 { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The usuario.</value>
        public string Usuario { get; set; }

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
    /// Class RetroArchivo.
    /// </summary>
    public class RetroArchivo
    {
        /// <summary>
        /// Gets or sets the valor.
        /// </summary>
        /// <value>The valor.</value>
        public string Valor { get; set; }
        /// <summary>
        /// Gets or sets the nombre.
        /// </summary>
        /// <value>The nombre.</value>
        public string Nombre { get; set; }
    }

    /// <summary>
    /// Class RetroExportarPDFModels.
    /// </summary>
    public class RetroExportarPDFModels
    {
        /// <summary>
        /// Cadena
        /// </summary>
        /// <value>The cadena.</value>
        public string Cadena { get; set; }
    }

    /// <summary>
    /// Class RetroAnalisisRecModels.
    /// </summary>
    public class RetroAnalisisRecModels
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
        /// Gets or sets the objetivo general.
        /// </summary>
        /// <value>The objetivo general.</value>
        public string ObjetivoGeneral { get; set; }
        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The recomendacion.</value>
        public string Recomendacion { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The accion.</value>
        public string Accion { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The accion permite.</value>
        public int AccionPermite { get; set; }

        /// <summary>
        /// Observacion
        /// </summary>
        /// <value>The observacion.</value>
        public string Observacion { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The fecha cumplimiento.</value>
        public DateTime FechaCumplimiento { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The accion cumplio.</value>
        public int AccionCumplio { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The alcaldia respuesta.</value>
        public int alcaldiaRespuesta { get; set; }

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
    /// Class RetroDesPreguntasModels.
    /// </summary>
    public class RetroDesPreguntasModels
    {
        /// <summary>
        /// Gets or sets the identifier retro admin.
        /// </summary>
        /// <value>The identifier retro admin.</value>
        public int IdRetroAdmin { get; set; }

        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public int IdPregunta { get; set; }

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
    /// Class RetroHistoricoEncuestaModels.
    /// </summary>
    public class RetroHistoricoEncuestaModels
    {
        /// <summary>
        /// Gets or sets the identifier encuesta.
        /// </summary>
        /// <value>The identifier encuesta.</value>
        public int IdEncuesta { get; set; }

        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public string IdPregunta { get; set; }

        /// <summary>
        /// Gets or sets the identifier nombre.
        /// </summary>
        /// <value>The identifier nombre.</value>
        public string IdNombre { get; set; }

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
}
