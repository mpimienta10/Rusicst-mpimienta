// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 10-10-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-14-2017
// ***********************************************************************
// <copyright file="Encuesta.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************
using Mininterior.RusicstMVC.Entidades;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Mininterior.RusicstMVC.Servicios.Lang;


/// <summary>
/// The Models namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Models
{
    /// <summary>
    /// Clase EncuestaId
    /// </summary>
    public class EncuestaId
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the identifier encuesta.
        /// </summary>
        /// <value>The identifier encuesta.</value>
        public int IdEncuesta { get; set; }

        /// <summary>
        /// Gets or sets the titulo.
        /// </summary>
        /// <value>The titulo.</value>
        public string Titulo { get; set; }
    }

    /// <summary>
    /// Clase EncuestaDraw
    /// </summary>
    public class EncuestaDraw
    { public int Id { get; set; }

        /// <summary>
        /// Gets or sets the identifier encuesta.
        /// </summary>
        /// <value>The identifier encuesta.</value>
        public int IdEncuesta { get; set; }

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
        /// Gets or sets the super seccion.
        /// </summary>
        /// <value>The super seccion.</value>
        public int? SuperSeccion { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this <see cref="EncuestaDraw" /> is eliminado.
        /// </summary>
        /// <value><c>true</c> if eliminado; otherwise, <c>false</c>.</value>
        public bool Eliminado { get; set; }

        /// <summary>
        /// Gets or sets the archivo.
        /// </summary>
        /// <value>The archivo.</value>
        public byte?[] Archivo { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [oculta titulo].
        /// </summary>
        /// <value><c>true</c> if [oculta titulo]; otherwise, <c>false</c>.</value>
        public bool OcultaTitulo { get; set; }

        /// <summary>
        /// Gets or sets the estilos.
        /// </summary>
        /// <value>The estilos.</value>
        public string Estilos { get; set; }

        /// <summary>
        /// The l sub secciones
        /// </summary>
        public List<SubSeccionesDraw> LSubSecciones = new List<SubSeccionesDraw>();
    }

    /// <summary>
    /// Clase SubSecciones
    /// </summary>
    public class SubSeccionesDraw
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
        /// Gets or sets the super seccion.
        /// </summary>
        /// <value>The super seccion.</value>
        public int? SuperSeccion { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [oculta titulo].
        /// </summary>
        /// <value><c>true</c> if [oculta titulo]; otherwise, <c>false</c>.</value>
        public bool OcultaTitulo { get; set; }

        /// <summary>
        /// Gets or sets the estilos.
        /// </summary>
        /// <value>The estilos.</value>
        public string Estilos { get; set; }

        /// <summary>
        /// Gets or sets the identifier pagina.
        /// </summary>
        /// <value>The identifier pagina.</value>
        public int IdPagina { get; set; }
    }

    /// <summary>
    /// Class DibujarDisenoPreguntas.
    /// </summary>
    public class DibujarDisenoPreguntas
    {
        /// <summary>
        /// The _ secciones
        /// </summary>
        public IEnumerable<C_DibujarSeccion_Result> _Secciones = new List<C_DibujarSeccion_Result>();

        /// <summary>
        /// The _ preguntas
        /// </summary>
        public List<PreguntasOpciones> _Preguntas = new List<PreguntasOpciones>();

        /// <summary>
        /// The _ glosario
        /// </summary>
        public IEnumerable<C_DibujarGlosario_Result> _Glosario = new List<C_DibujarGlosario_Result>();

        /// <summary>
        /// Gets or sets a value indicating whether this instance is consulta.
        /// </summary>
        /// <value><c>true</c> if this instance is consulta; otherwise, <c>false</c>.</value>
        public bool isConsulta { get; set; }
    }

    /// <summary>
    /// Clase Opciones
    /// </summary>
    public class Opciones
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the valor.
        /// </summary>
        /// <value>The valor.</value>
        public string Valor { get; set; }

        /// <summary>
        /// Gets or sets the texto.
        /// </summary>
        /// <value>The texto.</value>
        public string Texto { get; set; }

        /// <summary>
        /// Gets or sets the orden.
        /// </summary>
        /// <value>The orden.</value>
        public int Orden { get; set; }
    }

    /// <summary>
    /// Clase PreCargado
    /// </summary>
    public class PreCargado
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the accion.
        /// </summary>
        /// <value>The accion.</value>
        public string Accion { get; set; }

        /// <summary>
        /// Gets or sets the valor.
        /// </summary>
        /// <value>The valor.</value>
        public string Valor { get; set; }
    }

    /// <summary>
    /// Clase Preguntas-Opciones
    /// </summary>
    public partial class PreguntasOpciones
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
        /// Gets or sets the identifier encuesta.
        /// </summary>
        /// <value>The identifier encuesta.</value>
        public int IdEncuesta { get; set; }

        /// <summary>
        /// Gets or sets the nombre.
        /// </summary>
        /// <value>The nombre.</value>
        public string Nombre { get; set; }

        /// <summary>
        /// Gets or sets the index of the row.
        /// </summary>
        /// <value>The index of the row.</value>
        public Nullable<int> RowIndex { get; set; }

        /// <summary>
        /// Gets or sets the index of the column.
        /// </summary>
        /// <value>The index of the column.</value>
        public Nullable<int> ColumnIndex { get; set; }

        /// <summary>
        /// Gets or sets the tipo pregunta.
        /// </summary>
        /// <value>The tipo pregunta.</value>
        public string TipoPregunta { get; set; }

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
        /// The l opciones
        /// </summary>
        public IEnumerable<C_OpcionesXPregunta_Result> LOpciones = Enumerable.Empty<C_OpcionesXPregunta_Result>();

        /// <summary>
        /// The l pre cargado
        /// </summary>
        public List<PreCargado> LPreCargado = new List<PreCargado>();

        /// <summary>
        /// Gets or sets the funciones.
        /// </summary>
        /// <value>The funciones.</value>
        public object Funciones { get; set; }

        /// <summary>
        /// Gets or sets the respuesta.
        /// </summary>
        /// <value>The respuesta.</value>
        public string Respuesta { get; set; }
        public int TienePrecargue { get; set; }
        public string ValorPrecargue { get; set; }
    }

    /// <summary>
    /// Clase Preguntas-Desencadenantes
    /// </summary>
    public partial class PreguntaDesencadenantes
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the solo si.
        /// </summary>
        /// <value>The solo si.</value>
        public string SoloSi { get; set; }
    }

    /// <summary>
    /// Clase PostCargado
    /// </summary>
    public class PostCargado
    {
        /// <summary>
        /// Gets or sets the identifier pregunta.
        /// </summary>
        /// <value>The identifier pregunta.</value>
        public int IdPregunta { get; set; }

        /// <summary>
        /// Gets or sets the function.
        /// </summary>
        /// <value>The function.</value>
        public string Func { get; set; }

        /// <summary>
        /// Gets or sets the valor.
        /// </summary>
        /// <value>The valor.</value>
        public object Valor { get; set; }
    }


    /// <summary>
    /// Clase PostCargados
    /// </summary>
    public class PostCargados
    {
        /// <summary>
        /// The l post cargado
        /// </summary>
        public List<PostCargado> LPostCargado = new List<PostCargado>();
    }

    /// <summary>
    /// Class RespuestaEncuestaModels.
    /// </summary>
    public class RespuestaEncuestaModels
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the valor.
        /// </summary>
        /// <value>The valor.</value>
        public string Valor { get; set; }

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

    public class GuardadoSeccionModel
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int IdSeccion { get; set; }

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

    public class AdjuntoArchivoPlanModel
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int IdPlan { get; set; }

        /// <summary>
        /// Gets or sets the valor.
        /// </summary>
        /// <value>The valor.</value>
        public string Valor { get; set; }

        public string Username { get; set; }

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

    public class AdjuntoArchivoSeguimientoPlanModel
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>The identifier.</value>
        public int IdSeguimiento { get; set; }
        /// <summary>
        /// Gets or sets the valor.
        /// </summary>
        /// <value>The valor.</value>
        public string Tipo { get; set; }
        /// <summary>
        /// Gets or sets the valor.
        /// </summary>
        /// <value>The valor.</value>
        public string Valor { get; set; }

        public string Username { get; set; }

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

}