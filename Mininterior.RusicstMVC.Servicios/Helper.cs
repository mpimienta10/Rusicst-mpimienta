// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo - OIM
// Created          : 05-18-2017
//
// Last Modified By : MAURO
// Last Modified On : 05-18-2017
// ***********************************************************************
// <copyright file="Helper.cs" company="">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************


/// <summary>
/// The Servicios namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios
{
    using System;
    using System.Security.Cryptography;

    /// <summary>
    /// Class Helper.
    /// </summary>
    public class Helper
    {
        /// <summary>
        /// Gets the hash.
        /// </summary>
        /// <param name="input">The input.</param>
        /// <returns>System.String.</returns>
        public static string GetHash(string input)
        {
            HashAlgorithm hashAlgorithm = new SHA256CryptoServiceProvider();

            byte[] byteValue = System.Text.Encoding.UTF8.GetBytes(input);

            byte[] byteHash = hashAlgorithm.ComputeHash(byteValue);

            return Convert.ToBase64String(byteHash);
        }
    }
}