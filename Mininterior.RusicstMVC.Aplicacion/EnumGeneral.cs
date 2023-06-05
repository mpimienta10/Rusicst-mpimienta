// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Aplicacion
// Author           : Equipo de desarrollo OIM
// Created          : 03-08-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 04-03-2017
// ***********************************************************************
// <copyright file="Enumeradores.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Mininterior.RusicstMVC.Aplicacion namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Aplicacion
{
    /// <summary>
    /// Enumerador EstadoRespuesta
    /// </summary>
    public enum EstadoRespuesta
    {
        /// <summary>
        /// The excepcion
        /// </summary>
        Excepcion = 0,

        /// <summary>
        /// The insertado
        /// </summary>
        Insertado = 1,

        /// <summary>
        /// The actualizado
        /// </summary>
        Actualizado = 2,

        /// <summary>
        /// The eliminado
        /// </summary>
        Eliminado = 3,

        /// <summary>
        /// Estado que establece que se debe redireccionar a otro formulario
        /// </summary>
        Redireccionar = 4,

        /// <summary>
        /// Determina que el usuario no es valido para continuar
        /// </summary>
        UsuarioInvalido = 5
    }

    /// <summary>
    /// Enumerador EstadoSolicitud
    /// </summary>
    public enum EstadoSolicitud
    {
        /// <summary>
        /// Solicitud en su estado de registro
        /// </summary>
        Solicitada = 1,

        /// <summary>
        /// Solicitud confirmada por el usuario
        /// </summary>
        Confirmada = 2,

        /// <summary>
        /// Solicitud confirmada por Mininterior
        /// </summary>
        MinConfirmada = 3,

        /// <summary>
        /// Solicitud rechazada
        /// </summary>
        Rechazada = 4,

        /// <summary>
        /// Solicitud aprobada
        /// </summary>
        Aprobada = 5,

        /// <summary>
        /// Retiro del usuario del RUSICST
        /// </summary>
        Retiro = 6,

        /// <summary>
        /// Recuperar contraseña de usuario
        /// </summary>
        RecuperarContraseña = 7
    }

    /// <summary>
    /// Enumerador del Tipo de Usuario
    /// </summary>
    public enum TipoUsuario
    {
        /// <summary>
        /// Tipo de usuario administrador
        /// </summary>
        administrador = 1,

        /// <summary>
        /// Tipo de usuario alcaldía
        /// </summary>
        alcaldia = 2,

        /// <summary>
        /// Tipo de usuario gobernación
        /// </summary>
        gobernacion = 7
    }

    public enum TipoExtension
    {
        Encuesta = 1,

        PlanMejoramiento = 2,

        TableroPAT = 3,

        TableroPATSeguimiento1 = 4,

        TableroPATSeguimiento2 = 5
    }
}
