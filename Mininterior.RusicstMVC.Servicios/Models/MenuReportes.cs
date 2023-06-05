// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 04-27-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-16-2017
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
    using System.Collections.Generic;

    /// <summary>
    /// Class GlosarioFilteredParams.
    /// </summary>
    public class GlosarioFilteredParams
    {
        /// <summary>
        /// Gets or sets the clave.
        /// </summary>
        /// <value>The clave.</value>
        public string Clave { get; set; }

        /// <summary>
        /// Gets or sets the termino.
        /// </summary>
        /// <value>The termino.</value>
        public string Termino { get; set; }

        /// <summary>
        /// Gets or sets the descripcion.
        /// </summary>
        /// <value>The descripcion.</value>
        public string Descripcion { get; set; }

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
    /// Clase FiltroModificarPregunta.
    /// </summary>
    public class FiltroModificarPregunta
    {
        /// <summary>
        /// Gets or sets the identifier encuesta.
        /// </summary>
        /// <value>The identifier encuesta.</value>
        public int? idEncuesta { get; set; }

        /// <summary>
        /// Gets or sets the identifier grupo.
        /// </summary>
        /// <value>The identifier grupo.</value>
        public int? idGrupo { get; set; }

        /// <summary>
        /// Gets or sets the identifier seccion.
        /// </summary>
        /// <value>The identifier seccion.</value>
        public int? idSeccion { get; set; }

        /// <summary>
        /// Gets or sets the identifier subseccion.
        /// </summary>
        /// <value>The identifier subseccion.</value>
        public int? idSubseccion { get; set; }

        /// <summary>
        /// Gets or sets the nombre pregunta.
        /// </summary>
        /// <value>The nombre pregunta.</value>
        public string nombrePregunta { get; set; }

        public int? idPreguntaAnterior { get; set; }
        public string codigoPreguntaBanco { get; set; }
    }

    /// <summary>
    /// Clase FiltroDepartamentoMunicipio.
    /// </summary>
    public class FiltroDepartamentoMunicipio
    {
        /// <summary>
        /// Gets or sets the identifier departamento.
        /// </summary>
        /// <value>The identifier departamento.</value>
        public int idDepartamento { get; set; }

        /// <summary>
        /// Gets or sets the identifier municipio.
        /// </summary>
        /// <value>The identifier municipio.</value>
        public int idMunicipio { get; set; }
    }

    /// <summary>
    /// Clase Pregunta Models.
    /// </summary>
    public class PreguntaModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the identifier seccion.
        /// </summary>
        /// <value>The identifier seccion.</value>
        public int IdSeccion { get; set; }

        /// <summary>
        /// Gets or sets the nombre.
        /// </summary>
        /// <value>The nombre.</value>
        public string Nombre { get; set; }

        /// <summary>
        /// Gets or sets the RowIndex.
        /// </summary>
        /// <value>The RowIndex.</value>
        public int? RowIndex { get; set; }

        /// <summary>
        /// Gets or sets the ColumnIndex.
        /// </summary>
        /// <value>The ColumnIndex.</value>
        public int? ColumnIndex { get; set; }

        /// <summary>
        /// Gets or sets the tipo pregunta.
        /// </summary>
        /// <value>The tipo pregunta.</value>
        public string TipoPregunta { get; set; }

        /// <summary>
        /// Gets or sets the tipo pregunta.
        /// </summary>
        /// <value>The tipo pregunta.</value>
        public int IdTipoPregunta { get; set; }

        /// <summary>
        /// Gets or sets the ayuda.
        /// </summary>
        /// <value>The ayuda.</value>
        public string Ayuda { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [es obligatoria].
        /// </summary>
        /// <value><c>true</c> if [es obligatoria]; otherwise, <c>false</c>.</value>
        public bool EsObligatoria { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [es multiple].
        /// </summary>
        /// <value><c>true</c> if [es multiple]; otherwise, <c>false</c>.</value>
        public bool EsMultiple { get; set; }

        /// <summary>
        /// Gets or sets the solo si.
        /// </summary>
        /// <value>The solo si.</value>
        public string SoloSi { get; set; }

        /// <summary>
        /// Gets or sets the texto.
        /// </summary>
        /// <value>The texto.</value>
        public string Texto { get; set; }

        /// <summary>
        /// Gets or sets the opcion pregunta.
        /// </summary>
        /// <value>The opcion pregunta.</value>
        public List<OpcionPreguntaModels> OpcionPregunta { get; set; }

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
    /// Class PreguntaOpcionModels.
    /// </summary>
    public class PreguntaOpcionModels
    {
        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public int IdPregunta { get; set; }

        /// <summary>
        /// Gets or sets the identifier opcion.
        /// </summary>
        /// <value>The identifier opcion.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the valor.
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
    /// Clase Opcion Pregunta Models
    /// </summary>
    public class OpcionPreguntaModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the Texto.
        /// </summary>
        /// <value>The Texto.</value>
        public string Texto { get; set; }

        /// <summary>
        /// Gets or sets the Valor.
        /// </summary>
        /// <value>The Valor.</value>
        public string Valor { get; set; }
    }

    /// <summary>
    /// Clase Postcargado Models
    /// </summary>
    public class PostCargadoModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the Texto.
        /// </summary>
        /// <value>The Texto.</value>
        public string Valor { get; set; }

        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public int IdUsuario { get; set; }

        public List<PostCargadoControlesModel> datosControles { get; set; }
    }


    /// <summary>
    /// Clase Postcargado Models
    /// </summary>
    public class PostCargadoControlesModel
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the Texto.
        /// </summary>
        /// <value>The Texto.</value>
        public string Valor { get; set; }

        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public bool aDelete { get; set; }
    }

    /// <summary>
    /// Clase Banco Pregunta Models.
    /// </summary>
    public class BancoPreguntaModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int IdPregunta { get; set; }

        /// <summary>
        /// Gets or sets the identifier seccion.
        /// </summary>
        /// <value>The identifier seccion.</value>
        public int CodigoPregunta { get; set; }

        /// <summary>
        /// Gets or sets the nombre.
        /// </summary>
        /// <value>The nombre.</value>
        public string NombrePregunta { get; set; }

        /// <summary>
        /// Gets or sets the RowIndex.
        /// </summary>
        /// <value>The RowIndex.</value>
        public int? IdTipoPregunta { get; set; }

    }

    /// <summary>
    /// Clase Encuesta Models.
    /// </summary>
    public class EncuestaModels
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
        /// Gets or sets the ayuda.
        /// </summary>
        /// <value>The ayuda.</value>
        public string Ayuda { get; set; }

        /// <summary>
        /// Gets or sets the fecha inicio.
        /// </summary>
        /// <value>The fecha inicio.</value>
        public DateTime FechaInicio { get; set; }

        /// <summary>
        /// Gets or sets the fecha fin.
        /// </summary>
        /// <value>The fecha fin.</value>
        public DateTime FechaFin { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is deleted.
        /// </summary>
        /// <value><c>true</c> if this instance is deleted; otherwise, <c>false</c>.</value>
        public bool IsDeleted { get; set; }

        /// <summary>
        /// Gets or sets the tipo encuesta.
        /// </summary>
        /// <value>The tipo encuesta.</value>
        public string TipoEncuesta { get; set; }

        /// <summary>
        /// Gets or sets the encuesta relacionada.
        /// </summary>
        /// <value>The encuesta relacionada.</value>
        public int EncuestaRelacionada { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [autoevaluacion habilitada].
        /// </summary>
        /// <value><c>true</c> if [autoevaluacion habilitada]; otherwise, <c>false</c>.</value>
        public bool AutoevaluacionHabilitada { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is prueba.
        /// </summary>
        /// <value><c>true</c> if this instance is prueba; otherwise, <c>false</c>.</value>
        public int IsPrueba { get; set; }

        /// <summary>
        /// Gets or sets the tipo reporte.
        /// </summary>
        /// <value>The tipo reporte.</value>
        public List<TipoReporteModels> TipoReporte { get; set; }

        /// <summary>
        /// Obtener Tipos Reporte
        /// </summary>
        /// <param name="TipoReporte">The tipo reporte.</param>
        /// <returns>System.String.</returns>
        public string ObtenerTiposReporte(List<TipoReporteModels> TipoReporte)
        {
            if (TipoReporte.Count > 1)
            {
                string cadena = "";
                foreach (var item in TipoReporte)
                {
                    cadena = cadena + ',' + item.IdRol;
                }
                return cadena.Substring(1);
            }
            else
                return TipoReporte[0].IdRol;
        }

        #region Datos de Auditoría

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
    /// Tipo Reporte Models
    /// </summary>
    public class TipoReporteModels
    {
        /// <summary>
        /// Gets or sets the identifier rol.
        /// </summary>
        /// <value>The identifier rol.</value>
        public string IdRol { get; set; }
    }

    /// <summary>
    /// Clase Seccion Models
    /// </summary>
    public class SeccionModels
    {
        /// <summary>
        /// Gets Id.
        /// </summary>
        /// <value>The Id.</value>
        public int? Id { get; set; }

        /// <summary>
        /// Gets or sets the identifier usuario.
        /// </summary>
        /// <value>The identifier usuario.</value>
        public int? IdUsuario { get; set; }

        /// <summary>
        /// Gets or sets IdEncuesta.
        /// </summary>
        /// <value>The IdEncuesta.</value>
        public int IdEncuesta { get; set; }

        /// <summary>
        /// Gets or sets the SuperSeccion.
        /// </summary>
        /// <value>The SuperSeccion.</value>
        public int? SuperSeccion { get; set; }

        /// <summary>
        /// Gets or sets the TituloSS.
        /// </summary>
        /// <value>The TituloSS.</value>
        public string TituloSS { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The Titulo.</value>
        public string Titulo { get; set; }

        /// <summary>
        /// Gets or sets the Ayuda.
        /// </summary>
        /// <value>The Ayuda.</value>
        public string Ayuda { get; set; }

        /// <summary>
        /// Gets or sets the IsDeleted.
        /// </summary>
        /// <value>The IsDeleted.</value>
        public bool IsDeleted { get; set; }

        /// <summary>
        /// Gets or sets the Archivo.
        /// </summary>
        /// <value>The Archivo.</value>
        public byte[] Archivo { get; set; }

        /// <summary>
        /// Gets or sets the OcultaTitulo.
        /// </summary>
        /// <value>The OcultaTitulo.</value>
        public bool OcultaTitulo { get; set; }

        /// <summary>
        /// Gets or sets the Estilos.
        /// </summary>
        /// <value>The Estilos.</value>
        public string Estilos { get; set; }

        /// <summary>
        /// Gets or sets the Disenos.
        /// </summary>
        /// <value>The Disenos.</value>
        public List<DisenoModels> Disenos = new List<DisenoModels>();

        /// <summary>
        /// Gets or sets the Preguntas.
        /// </summary>
        /// <value>The Preguntas.</value>
        public List<PreguntaModels> Preguntas = new List<PreguntaModels>();

        #region Datos de Auditoría

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
    /// Clase SubSeccion Models
    /// </summary>
    public class SubSeccionModels
    {
        /// <summary>
        /// Gets or sets Id.
        /// </summary>
        /// <value>The Id.</value>
        public int? Id { get; set; }

        /// <summary>
        /// Gets or sets SuperSeccion.
        /// </summary>
        /// <value>The SuperSeccion.</value>
        public int? SuperSeccion { get; set; }

        /// <summary>
        /// Gets or sets the Titulo.
        /// </summary>
        /// <value>The Titulo.</value>
        public string Titulo { get; set; }
    }

    /// <summary>
    /// Clase Diseno Models
    /// </summary>
    public class DisenoModels
    {
        /// <summary>
        /// Gets or sets the Id.
        /// </summary>
        /// <value>The Id.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the IdSeccion.
        /// </summary>
        /// <value>The IdSeccion.</value>
        public int IdSeccion { get; set; }

        /// <summary>
        /// Gets or sets the Texto.
        /// </summary>
        /// <value>The Texto.</value>
        public string Texto { get; set; }

        /// <summary>
        /// Gets or sets the ColumnSpan.
        /// </summary>
        /// <value>The ColumnSpan.</value>
        public int? ColumnSpan { get; set; }

        /// <summary>
        /// Gets or sets the RowSpan.
        /// </summary>
        /// <value>The RowSpan.</value>
        public int? RowSpan { get; set; }

        /// <summary>
        /// Gets or sets the RowIndex.
        /// </summary>
        /// <value>The RowIndex.</value>
        public int RowIndex { get; set; }

        /// <summary>
        /// Gets or sets the ColumnIndex.
        /// </summary>
        /// <value>The ColumnIndex.</value>
        public int ColumnIndex { get; set; }
    }


    /// <summary>
    /// Class FiltroUsuario.
    /// </summary>
    public class FiltroUsuario
    {
        /// <summary>
        /// Gets or sets the tipo usuario.
        /// </summary>
        /// <value>The tipo usuario.</value>
        public int IdTipoUsuario { get; set; }

        /// <summary>
        /// Gets or sets the usuario.
        /// </summary>
        /// <value>The usuario.</value>
        public int IdUsuario { get; set; }
    }

    /// <summary>
    /// Class TipoPregunta.
    /// </summary>
    public class TipoPregunta
    {
        /// <summary>
        /// Gets or sets the Id.
        /// </summary>
        /// <value>The Id.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the Nombre.
        /// </summary>
        /// <value>The Nombre.</value>
        public int Nombre { get; set; }
    }

    public class PrecargueRespuestasModels
    {

        public int IdUsuarioGuardo { get; set; }
        public byte[] Archivo { get; set; }      

        #region Datos de Auditoría

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
        public string DetalleMensaje { get; set; }

        #endregion
    }
}