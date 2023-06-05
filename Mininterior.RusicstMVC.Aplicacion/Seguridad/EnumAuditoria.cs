// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Aplicacion
// Author           : Equipo de desarrollo OIM
// Created          : 09-14-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 10-23-2017
// ***********************************************************************
// <copyright file="EnumAuditoria.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************
/// <summary>
/// The Seguridad namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Aplicacion.Seguridad
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    /// <summary>
    /// Enum Severity
    /// </summary>
    public enum Severity
    {
        /// <summary>
        /// The error
        /// </summary>
        Error = 0,

        /// <summary>
        /// The information
        /// </summary>
        Information = 1
    }

    /// <summary>
    /// Enum Category
    /// </summary>
    public enum Category
    {
        /// <summary>
        /// The excepciones
        /// </summary>
        Excepciones = 1,

        #region Manejo de Sesión y seguridad

        /// <summary>
        /// Inicio sesión
        /// </summary>
        InicioSesion = 3,

        /// <summary>
        /// Cerrar sesión
        /// </summary>
        CerrarSesion = 2,

        /// <summary>
        /// Adquirir identidad
        /// </summary>
        AdquirirIdentidad = 6,

        /// <summary>
        /// Cambiar contraseña
        /// </summary>
        CambiarContraseña = 9,

        /// <summary>
        /// The establecer contraseña
        /// </summary>
        EstablecerContraseña = 172,

        /// <summary>
        /// The resetiar contraseña
        /// </summary>
        ResetiarContraseña = 15,

        /// <summary>
        /// The resetiar contraseña error
        /// </summary>
        ResetiarContraseñaError = 16,

        #endregion

        #region Menú de Usuario

        #region Tipo de Usuario

        /// <summary>
        /// Crear tipo de usuario
        /// </summary>
        CrearTipodeUsuario = 14,

        /// <summary>
        /// Modificar tipo de usuario
        /// </summary>
        EditarTipodeUsuario = 70,

        /// <summary>
        /// Eliminar tipo de usuario
        /// </summary>
        EliminarTipodeUsuario = 24,

        #endregion

        #region Administrar Usuarios

        /// <summary>
        /// Modificar usuario
        /// </summary>
        EditarUsuario = 71,

        /// <summary>
        /// Eliminar usuario
        /// </summary>
        EliminarUsuario = 8,

        #endregion

        #region Email Masivos

        /// <summary>
        /// The envio email masivo
        /// </summary>
        EnvioEmailMasivo = 72,

        /// <summary>
        /// The envio email prueba
        /// </summary>
        EnvioEmailPrueba = 73,

        /// <summary>
        /// The envio mail contactenos
        /// </summary>
        EnvioMailContactenos = 173,

        /// <summary>
        /// The envio mail contactenos error
        /// </summary>
        EnvioMailContactenosError = 174,

        #endregion

        #region Gestionar Solicitudes de Usuario

        /// <summary>
        /// The crear solicitud
        /// </summary>
        CrearSolicitud = 176,

        /// <summary>
        /// The gestionar solicitud
        /// </summary>
        ConfirmarSolicitud = 74,

        /// <summary>
        /// The remitir solicitud
        /// </summary>
        RemitirSolicitud = 175,

        #endregion

        #region Gestionar Permisos

        /// <summary>
        /// The gestionar permiso Eliminar
        /// </summary>
        EliminarPermiso = 75,

        /// <summary>
        /// The crear permiso
        /// </summary>
        CrearPermiso = 76,

        #endregion

        #region Habilitar Reportes Usuarios

        /// <summary>
        /// The extender plazo
        /// </summary>
        ExtenderPlazo = 77,

        #endregion

        #endregion

        #region Menú de Sistema

        #region Configuración Archivos de Ayuda

        /// <summary>
        /// The crear archivo ayuda
        /// </summary>
        CrearArchivoAyuda = 79,

        /// <summary>
        /// The modificar archivo ayuda
        /// </summary>
        EditarArchivoAyuda = 80,

        /// <summary>
        /// The eliminar archivo ayuda
        /// </summary>
        EliminarArchivoAyuda = 78,

        #endregion

        #region Configuración Home

        /// <summary>
        /// The modificar home rs
        /// </summary>
        EditarHomeRS = 81,

        /// <summary>
        /// The modificar home mint
        /// </summary>
        EditarHomeMint = 82,

        /// <summary>
        /// The modificar home application
        /// </summary>
        EditarHomeApp = 83,

        /// <summary>
        /// The modificar home gob
        /// </summary>
        EditarHomeGob = 84,

        /// <summary>
        /// The modificar home sl
        /// </summary>
        EditarHomeSl = 85,

        /// <summary>
        /// The modificar home texto footer
        /// </summary>
        EditarHomeTextoFooter = 86,

        /// <summary>
        /// The modificar home parametros gobierno
        /// </summary>
        EditarHomeParametrosGobierno = 87,

        /// <summary>
        /// The eliminar home parametros gobierno
        /// </summary>
        EliminarHomeParametrosGobierno = 88,

        #endregion

        #region Configuración Sistema

        /// <summary>
        /// The modificar sistema rs
        /// </summary>
        EditarSistemaRS = 89,

        /// <summary>
        /// The modificar sistema mint
        /// </summary>
        EditarSistemaMint = 90,

        /// <summary>
        /// The modificar sistema application
        /// </summary>
        EditarSistemaApp = 91,

        /// <summary>
        /// The modificar sistema gob
        /// </summary>
        EditarSistemaGob = 92,

        /// <summary>
        /// The modificar sistema sl
        /// </summary>
        EditarSistemaSl = 93,

        /// <summary>
        /// The modificar sistema texto footer
        /// </summary>
        EditarSistemaTextoFooter = 94,

        /// <summary>
        /// The modificar sistema parametros gobierno
        /// </summary>
        EditarSistemaParametrosGobierno = 95,

        /// <summary>
        /// The eliminar sistema parametros gobierno
        /// </summary>
        EliminarSistemaParametrosGobierno = 96,

        #endregion Gestionar Roles

        #region Gestión de Roles

        /// <summary>
        /// The crear rol
        /// </summary>
        CrearRol = 41,

        /// <summary>
        /// The editar rol
        /// </summary>
        EditarRol = 42,

        /// <summary>
        /// The eliminar rol
        /// </summary>
        EliminarRol = 43,

        /// <summary>
        /// Agregar usuario a rol
        /// </summary>
        AgregarUsuarioaRol = 46,

        /// <summary>
        /// Remover usuario de rol
        /// </summary>
        RemoverUsuariodeRol = 47,

        #endregion

        #region Banco de Preguntas

        /// <summary>
        /// The crear pregunta
        /// </summary>
        CrearBancoPregunta = 32,

        /// <summary>
        /// The editar pregunta
        /// </summary>
        EditarBancoPregunta = 33,

        /// <summary>
        /// The eliminar pregunta
        /// </summary>
        EliminarBancoPregunta = 34,

        /// <summary>
        /// The editar detalle de clasificadores de pregunta
        /// </summary>
        EditarDetalledeClasificadoresdePregunta = 35,

        /// <summary>
        /// The agregar detalle de clasificadora pregunta
        /// </summary>
        CrearDetalledeClasificadoraPregunta = 38,

        /// <summary>
        /// The eliminar detalle de clasificador de pregunta
        /// </summary>
        EliminarDetalledeClasificadordePregunta = 37,

        #endregion

        #region Plan de Mejoramiento

        /// <summary>
        /// The crear plande mejoramiento
        /// </summary>
        CrearPlandeMejoramiento = 51,

        /// <summary>
        /// The editar plande mejoramiento
        /// </summary>
        EditarPlandeMejoramiento = 52,

        /// <summary>
        /// The eliminar plande mejoramiento
        /// </summary>
        EliminarPlandeMejoramiento = 53,

        /// <summary>
        /// The crearsecciónen plande mejoramiento
        /// </summary>
        CrearsecciónenPlandeMejoramiento = 54,

        /// <summary>
        /// The editarsecciónen plande mejoramiento
        /// </summary>
        EditarsecciónenPlandeMejoramiento = 55,

        /// <summary>
        /// The eliminarsecciónde plande mejoramiento
        /// </summary>
        EliminarseccióndePlandeMejoramiento = 56,

        /// <summary>
        /// The activar plande mejoramiento
        /// </summary>
        ActivarPlandeMejoramiento = 57,

        /// <summary>
        /// The re activar plande mejoramiento
        /// </summary>
        ReActivarPlandeMejoramiento = 58,

        /// <summary>
        /// The asociar encuestaa plande mejoramiento
        /// </summary>
        AsociarEncuestaaPlandeMejoramiento = 59,

        /// <summary>
        /// The desasociar encuestade plande mejoramiento
        /// </summary>
        DesasociarEncuestadePlandeMejoramiento = 60,

        /// <summary>
        /// The crear objetivo especificoen plande mejoramiento
        /// </summary>
        CrearObjetivoEspecificoenPlandeMejoramiento = 61,

        /// <summary>
        /// The editar objetivo especificoen plande mejoramiento
        /// </summary>
        EditarObjetivoEspecificoenPlandeMejoramiento = 62,

        /// <summary>
        /// The eliminar objetivo especificode plande mejoramiento
        /// </summary>
        EliminarObjetivoEspecificodePlandeMejoramiento = 63,

        /// <summary>
        /// The crear recomendaciónen plande mejoramiento
        /// </summary>
        CrearRecomendaciónenPlandeMejoramiento = 64,

        /// <summary>
        /// The eliminar recomendaciónde plande mejoramiento
        /// </summary>
        EliminarRecomendacióndePlandeMejoramiento = 65,

        /// <summary>
        /// The diligenciamientode plande mejoramiento
        /// </summary>
        DiligenciamientodePlandeMejoramiento = 67,

        /// <summary>
        /// The finalizaciónde plande mejoramiento
        /// </summary>
        FinalizacióndePlandeMejoramiento = 68,

        /// <summary>
        /// The envíode plande mejoramiento
        /// </summary>
        EnvíodePlandeMejoramiento = 69,

        /// <summary>
        /// The crear recurso plande mejoramiento
        /// </summary>
        CrearRecursoPlandeMejoramiento = 169,

        /// <summary>
        /// The editar recurso plande mejoramiento
        /// </summary>
        EditarRecursoPlandeMejoramiento = 170,

        /// <summary>
        /// The eliminar recurso plande mejoramiento
        /// </summary>
        EliminarRecursoPlandeMejoramiento = 171,

        #endregion

        #region Parámetros del Sistema

        /// <summary>
        /// The actualizar datosdel sistema
        /// </summary>
        EditarDatosdelSistema = 25,

        #endregion

        #region Administrar Glosario

        /// <summary>
        /// The crear glosario
        /// </summary>
        CrearGlosario = 98,

        /// <summary>
        /// The editar glosario
        /// </summary>
        EditarGlosario = 97,

        /// <summary>
        /// The eliminar glosario
        /// </summary>
        EliminarGlosario = 29,

        #endregion

        #region Administrar Retro-Alimentación

        /// <summary>
        /// The crear realimentación
        /// </summary>
        CrearRealimentacion = 99,

        /// <summary>
        /// The editar realimentación
        /// </summary>
        EditarRealimentacion = 100,

        /// <summary>
        /// The eliminar realimentación
        /// </summary>
        EliminarRealimentacion = 101,

        /// <summary>
        /// The editar encuesta realimentacion
        /// </summary>
        EditarEncuestaRealimentacion = 102,

        /// <summary>
        /// The editar grafica realimentacion
        /// </summary>
        EditarGraficaNivelRealimentacion = 103,

        /// <summary>
        /// The editar analisis recomendacion
        /// </summary>
        EditarAnalisisRecomendacionRealimentacion = 104,

        #endregion

        #endregion

        #region Menú Reportes

        #region Completar / Consultar Reportes

        /// <summary>
        /// The crear respuesta encuesta
        /// </summary>
        CrearRespuestaEncuesta = 122,

        #endregion

        #region Diseño Reportes

        /// <summary>
        /// The guardar encuesta
        /// </summary>
        CrearEncuesta = 30,

        /// <summary>
        /// The editar encuesta
        /// </summary>
        EditarEncuesta = 106,

        /// <summary>
        /// The eliminar encuesta
        /// </summary>
        EliminarEncuesta = 23,

        /// <summary>
        /// The crear sección encuesta
        /// </summary>
        CrearSeccionEncuesta = 7,

        /// <summary>
        /// The editar sección encuesta
        /// </summary>
        EditarSeccionEncuesta = 107,

        /// <summary>
        /// The eliminar sección encuesta
        /// </summary>
        EliminarSeccionEncuesta = 13,

        #endregion

        #region Modificar Pregunta

        /// <summary>
        /// The modificar pregunta
        /// </summary>
        ModificarPregunta = 10,

        /// <summary>
        /// The editar pregunta opción
        /// </summary>
        EditarPreguntaOpcion = 123,

        /// <summary>
        /// The crear pregunta opción
        /// </summary>
        CrearPreguntaOpcion = 124,

        /// <summary>
        /// The eliminar pregunta opción
        /// </summary>
        EliminarPreguntaOpcion = 125,

        #endregion

        #endregion

        #region Tablero PAT

        #region Gestión Municipal

        /// <summary>
        /// The editar respuesta pat
        /// </summary>
        EditarRespuestaPAT = 108,

        /// <summary>
        /// The crear respuesta pat
        /// </summary>
        CrearRespuestaPAT = 109,

        /// <summary>
        /// The crear respuesta acciones pat
        /// </summary>
        CrearRespuestaAccionesPAT = 110,

        /// <summary>
        /// The editar respuesta acciones pat
        /// </summary>
        EditarRespuestaAccionesPAT = 111,

        /// <summary>
        /// The crear respuesta programa pat
        /// </summary>
        CrearRespuestaProgramaPAT = 112,

        /// <summary>
        /// The editar respuesta programa pat
        /// </summary>
        EditarRespuestaProgramaPAT = 113,

        /// <summary>
        /// The crear respuesta rcpat
        /// </summary>
        CrearRespuestaRCPAT = 114,

        /// <summary>
        /// The editar respuesta rcpat
        /// </summary>
        EditarRespuestaRCPAT = 115,

        /// <summary>
        /// The crear respuesta rc acciones pat
        /// </summary>
        CrearRespuestaRCAccionesPAT = 116,

        /// <summary>
        /// The editar respuesta rc acciones pat
        /// </summary>
        EditarRespuestaRCAccionesPAT = 117,

        /// <summary>
        /// The crear respuesta rrpat
        /// </summary>
        CrearRespuestaRRPAT = 118,

        /// <summary>
        /// The editar respuesta rrpat
        /// </summary>
        EditarRespuestaRRPAT = 119,

        /// <summary>
        /// The crear respuesta rr acciones pat
        /// </summary>
        CrearRespuestaRRAccionesPAT = 120,

        /// <summary>
        /// The editar respuesta rr acciones pat
        /// </summary>
        EditarRespuestaRRAccionesPAT = 121,

        #endregion

        #region Gestión Departamental

        /// <summary>
        /// The crear respuesta departamento rrpat
        /// </summary>
        CrearRespuestaDepartamentoRRPAT = 126,

        /// <summary>
        /// The editar respuesta departamento rrpat
        /// </summary>
        EditarRespuestaDepartamentoRRPAT = 127,

        /// <summary>
        /// The crear respuesta departamento rcpat
        /// </summary>
        CrearRespuestaDepartamentoRCPAT = 128,

        /// <summary>
        /// The editar respuesta departamento rcpat
        /// </summary>
        EditarRespuestaDepartamentoRCPAT = 129,

        /// <summary>
        /// The crear respuesta departamento pat
        /// </summary>
        CrearRespuestaDepartamentoPAT = 130,

        /// <summary>
        /// The editar respuesta departamento pat
        /// </summary>
        EditarRespuestaDepartamentoPAT = 131,

        #endregion

        #region Preguntas

        /// <summary>
        /// The crear preguntas pat
        /// </summary>
        CrearPreguntasPAT = 132,

        /// <summary>
        /// The editar preguntas pat
        /// </summary>
        EditarPreguntasPAT = 133,

        #endregion

        #region Preguntas de Reparacion Colectiva

        /// <summary>
        /// The crear preguntas pat
        /// </summary>
        CrearPreguntasRCPAT = 179,

        /// <summary>
        /// The editar preguntas pat
        /// </summary>
        EditarPreguntasRCPAT = 180,

        #endregion

        #region Preguntas de Retornos y Reubicaciones

        /// <summary>
        /// The crear preguntas pat
        /// </summary>
        CrearPreguntasRRPAT = 181,

        /// <summary>
        /// The editar preguntas pat
        /// </summary>
        EditarPreguntasRRPAT = 182,

        #endregion

        #region Administracion de Tableros

        /// <summary>
        /// The crear preguntas pat
        /// </summary>
        CrearTableroPAT = 177,

        /// <summary>
        /// The editar preguntas pat
        /// </summary>
        EditarNivelTAbleroPAT = 178,

        #endregion

        #region Seguimiento Departamental

        /// <summary>
        /// The crear seguimiento reparacion colectiva depto
        /// </summary>
        CrearSeguimientoReparacionColectivaDepto = 134,

        /// <summary>
        /// The editar seguimiento reparacion colectiva depto
        /// </summary>
        EditarSeguimientoReparacionColectivaDepto = 135,

        /// <summary>
        /// The crear seguimiento retornos reubicaciones depto
        /// </summary>
        CrearSeguimientoRetornosReubicacionesDepto = 136,

        /// <summary>
        /// The editar seguimiento retornos reubicaciones depto
        /// </summary>
        EditarSeguimientoRetornosReubicacionesDepto = 137,

        /// <summary>
        /// The crear seguimiento gobernacion otros derechos
        /// </summary>
        CrearSeguimientoGobernacionOtrosDerechos = 138,

        /// <summary>
        /// The editar seguimiento gobernacion otros derechos
        /// </summary>
        EditarSeguimientoGobernacionOtrosDerechos = 139,

        /// <summary>
        /// The crear seguimiento gobernacion otros derechos medidas
        /// </summary>
        CrearSeguimientoGobernacionOtrosDerechosMedidas = 140,

        /// <summary>
        /// The editar seguimiento gobernacion otros derechos medidas
        /// </summary>
        EditarSeguimientoGobernacionOtrosDerechosMedidas = 141,

        /// <summary>
        /// The crear seguimiento pat gobernacion
        /// </summary>
        CrearSeguimientoPATGobernacion = 142,

        /// <summary>
        /// The editar seguimiento pat gobernacion
        /// </summary>
        EditarSeguimientoPATGobernacion = 143,

        /// <summary>
        /// The e liminar programas seguimiento pat gobernacion
        /// </summary>
        ELiminarProgramasSeguimientoPATGobernacion = 144,

        /// <summary>
        /// The crear programa seguimiento pat gobernacion
        /// </summary>
        CrearProgramaSeguimientoPATGobernacion = 145,

        /// <summary>
        /// The editar programa respuesta acciones pat
        /// </summary>
        EditarProgramaRespuestaAccionesPAT = 146,

        /// <summary>
        /// The eliminar seguimiento gobernacion otros derechos medidas
        /// </summary>
        EliminarSeguimientoGobernacionOtrosDerechosMedidas = 147,

        /// <summary>
        /// The editar programa seguimiento pat gobernacion
        /// </summary>
        EditarProgramaSeguimientoPATGobernacion = 160,

        #endregion

        #region Seguimiento Municipal

        /// <summary>
        /// The crear seguimiento retornos reubicaciones mpio
        /// </summary>
        CrearSeguimientoRetornosReubicacionesMpio = 148,

        /// <summary>
        /// The editar seguimiento retornos reubicaciones mpio
        /// </summary>
        EditarSeguimientoRetornosReubicacionesMpio = 149,

        /// <summary>
        /// The crear seguimiento reparacion colectiva mpio
        /// </summary>
        CrearSeguimientoReparacionColectivaMpio = 150,

        /// <summary>
        /// The editar seguimiento reparacion colectiva mpio
        /// </summary>
        EditarSeguimientoReparacionColectivaMpio = 151,

        /// <summary>
        /// The eliminar seguimiento otros derechos medidas mpio
        /// </summary>
        EliminarSeguimientoOtrosDerechosMedidasMpio = 152,

        /// <summary>
        /// The crear seguimiento otros derechos mpio
        /// </summary>
        CrearSeguimientoOtrosDerechosMpio = 153,

        /// <summary>
        /// The editar seguimiento otros derechos mpio
        /// </summary>
        EditarSeguimientoOtrosDerechosMpio = 154,

        /// <summary>
        /// The crear seguimiento otros derechos medidas mpio
        /// </summary>
        CrearSeguimientoOtrosDerechosMedidasMpio = 155,

        /// <summary>
        /// The editar seguimiento otros derechos medidas mpio
        /// </summary>
        EditarSeguimientoOtrosDerechosMedidasMpio = 156,

        /// <summary>
        /// The crear seguimiento pat mpio
        /// </summary>
        CrearSeguimientoPATMpio = 157,

        /// <summary>
        /// The editar seguimiento pat mpio
        /// </summary>
        EditarSeguimientoPATMpio = 158,

        /// <summary>
        /// The e liminar programas seguimiento pat mpio
        /// </summary>
        ELiminarProgramasSeguimientoPATMpio = 159,

        /// <summary>
        /// The crear programa seguimiento pat mpio
        /// </summary>
        CrearProgramaSeguimientoPATMpio = 161,

        /// <summary>
        /// The editar programa seguimiento pat mpio
        /// </summary>
        EditarProgramaSeguimientoPATMpio = 162,

        #endregion

        #endregion

        #region RetroAlimentacion

        /// <summary>
        /// The eliminar retro DES pregunta
        /// </summary>
        EliminarRetroDesPregunta = 105,

        /// <summary>
        /// The crear retro preguntas DES
        /// </summary>
        CrearRetroPreguntasDes = 163,

        /// <summary>
        /// The editar retro grafica desarrollo
        /// </summary>
        EditarRetroGraficaDesarrollo = 164,

        /// <summary>
        /// The crear retro preguntas arc
        /// </summary>
        CrearRetroPreguntasArc = 165,

        /// <summary>
        /// The editar retro preguntas arc
        /// </summary>
        EditarRetroPreguntasArc = 166,

        /// <summary>
        /// The eliminar retro preguntas arc
        /// </summary>
        EliminarRetroPreguntasArc = 167,

        /// <summary>
        /// The crear retro historial encuesta
        /// </summary>
        CrearRetroHistorialEncuesta = 168,

        #endregion

        /// <summary>
        /// Verificar eliminaciónde usuario de rol
        /// </summary>
        VerificareliminacióndeUsuariodeRol = 48,

        /// <summary>
        /// The inicio página
        /// </summary>
        InicioPágina = 4,

        /// <summary>
        /// The actualizar datos
        /// </summary>
        ActualizarDatos = 5,

        /// <summary>
        /// The guardar rol
        /// </summary>
        GuardarRol = 11,

        /// <summary>
        /// The eliminar roldel recurso
        /// </summary>
        EliminarRoldelRecurso = 12,

        /// <summary>
        /// The inicio sesión error
        /// </summary>
        InicioSesiónError = 17,

        /// <summary>
        /// The eliminar proceso
        /// </summary>
        EliminarProceso = 18,

        /// <summary>
        /// The eliminar categoría
        /// </summary>
        EliminarCategoría = 19,

        /// <summary>
        /// The eliminar objetivo
        /// </summary>
        EliminarObjetivo = 20,

        /// <summary>
        /// The eliminar recomendación
        /// </summary>
        EliminarRecomendación = 21,

        /// <summary>
        /// The salvar opción respuesta
        /// </summary>
        SalvarOpciónRespuesta = 22,

        /// <summary>
        /// The encuesta duplicada
        /// </summary>
        EncuestaDuplicada = 26,

        /// <summary>
        /// The encuesta duplicada full
        /// </summary>
        EncuestaDuplicadaFull = 27,

        /// <summary>
        /// The actualización orden proceso
        /// </summary>
        ActualizaciónOrdenProceso = 28,

        /// <summary>
        /// The migración bitácora
        /// </summary>
        MigraciónBitácora = 31,

        /// <summary>
        /// The asignar detallede clasificadoresa pregunta
        /// </summary>
        AsignarDetalledeClasificadoresaPregunta = 36,

        /// <summary>
        /// The cargar excel
        /// </summary>
        CargarExcel = 39,

        /// <summary>
        /// The asociar preguntaa encuesta
        /// </summary>
        AsociarPreguntaaEncuesta = 40,

        /// <summary>
        /// The verificar eliminaciónde rol
        /// </summary>
        VerificarEliminacióndeRol = 44,

        /// <summary>
        /// The verificar eliminaciónde pregunta
        /// </summary>
        VerificarEliminacióndePregunta = 45,

        /// <summary>
        /// The asociar encuestaa rol
        /// </summary>
        AsociarEncuestaaRol = 49,

        /// <summary>
        /// The desasociar encuestade rol
        /// </summary>
        DesasociarEncuestadeRol = 50,
        InicioSesionAD = 177,
        InicioSesiónErrorAD = 178,

        CrearRespuestaDepartamentoAccionesPAT = 183,
        EditarRespuestaDepartamentoAccionesPAT = 184,
        CrearRespuestaDepartamentoProgramaPAT = 185,
        EditarRespuestaDepartamentoProgramaPAT = 186,
        EnvioPlaneacionMunicipalPAT= 187,
        EnvioPlaneacionDepartamentalPAT= 188,
        EnvioPrimerSeguimientoMunicipalPAT = 189,
        EnvioSegundoSeguimientoMunicipalPAT = 190,
        EnvioPrimerSeguimientoDepartamentalPAT = 191,
        EnvioSegundoSeguimientoDepartamentalPAT = 192,

        CrearObjetivoGeneralPlan = 193,
        EditarObjetivoGeneralPlan = 194,
        EliminarObjetivoGeneralPlan = 195,

        CrearRespuestaPlandeMejoramiento = 196,
        AdjuntarArchivoenPlandeMejoramiento = 197,
        EnviodePlandeMejoramiento = 198,

        GuardarPaginaEncuesta = 199,       


        #region Seguimiento Plan Mejoramiento

        CrearSeguimientoPlanMejoramiento = 200,
        EditarSeguimientoPlanMejoramiento = 201,
        EliminarSeguimientoPlanMejoramiento = 202,

        CrearEstadoAccionSeguimientoPlan = 203,
        EditarEstadoAccionSeguimientoPlan = 204,
        EliminarEstadoAccionSeguimientoPlan = 205,

        CrearRespuestaSeguimientoPlan = 206,
        EnviodeSeguimientoPlandeMejoramiento = 207,


        BorroPrecargueRespuestasEncuestas = 208,
        IngresoPrecargueRespuestasEncuestas = 209,
        IngresoPrecargueSeguimientoPreguntasXmunicipio = 210,
        EliminoPrecargueSeguimientoPreguntasXmunicipio = 211,
        #endregion
    }
}
