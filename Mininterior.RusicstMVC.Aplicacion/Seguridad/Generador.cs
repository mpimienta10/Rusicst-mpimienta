// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Aplicacion
// Author           : Equipo de desarrollo OIM
// Created          : 05-06-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-06-2017
// ***********************************************************************
// <copyright file="Generador.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

namespace Mininterior.RusicstMVC.Aplicacion.Seguridad
{
    using System;
    using System.Security.Cryptography;

    /// <summary>
    /// Clase Generador.
    /// </summary>
    public class Generador
    {
        /// <summary>
        /// Generates the token.
        /// </summary>
        /// <param name="length">The length.</param>
        /// <returns>System.String.</returns>
        public static string GenerateToken(int length)
        {
            RNGCryptoServiceProvider cryptRNG = new RNGCryptoServiceProvider();
            byte[] tokenBuffer = new byte[length];
            cryptRNG.GetBytes(tokenBuffer);
            return Convert.ToBase64String(tokenBuffer);
        }
    }
}
