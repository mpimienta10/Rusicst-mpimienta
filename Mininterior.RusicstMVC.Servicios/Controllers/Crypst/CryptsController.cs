// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Servicios
// Author           : Equipo de desarrollo OIM
// Created          : 05-01-2017
//
// Last Modified By : Equipo de desarrollo OIM
// Last Modified On : 05-01-2017
// ***********************************************************************
// <copyright file="GestionAuditoriaEventosController.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary></summary>
// ***********************************************************************

/// <summary>
/// The Sistema namespace.
/// </summary>
namespace Mininterior.RusicstMVC.Servicios.Controllers.Sistema
{
    using Aplicacion.Seguridad;
    using ClosedXML.Excel;
    using Entidades;
    using Mininterior.RusicstMVC.Servicios.Entities;
    using Mininterior.RusicstMVC.Servicios.Helpers;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Net.Http.Headers;
    using System.Threading.Tasks;
    using System.Web.Http;
    using Utilidades;

    /// <summary>
    /// Class GestionAuditoriaEventosController.
    /// </summary>
    [AllowAnonymous]
    public class CryptsController : ApiController
    {
        /// <summary>
        /// Obtiene toda la auditoría filtrada por categoría y usuario
        /// </summary>
        /// <returns>Lista de solicitudes</returns>
        [HttpGet]
        [Route("api/crypts/keys/")]
        public IHttpActionResult GetKey()
        {
            DataCrypts resultado = new DataCrypts();
            try
            {
                var keys = Encrypt.GenerateKey();
                var publicKey = keys.FirstOrDefault(f => f.Key == "42f46a59-6875-4904-96fb-1ff6ca469312");
                var privateKey = keys.FirstOrDefault(f => f.Key == "143ef900-5f7d-4428-890b-5808ba8c2fbf");
                const string HeaderKeyName = "X-CLIENT";
                bool isValueExist = Request.Headers.TryGetValues(HeaderKeyName, out var values);
                if(!isValueExist || values.FirstOrDefault() is null || !values.FirstOrDefault().Equals("21bc4a10-951a-4a16-b9c8-bfc448f346d9"))
                {
                    return Unauthorized();
                }

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 120;
                    BD.I_CrearCryps(publicKey.Value, privateKey.Value);
                }
                return Ok(publicKey);
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
                return BadRequest();
            }
        }

    }
}