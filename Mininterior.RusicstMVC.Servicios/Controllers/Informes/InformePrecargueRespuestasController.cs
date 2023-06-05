namespace Mininterior.RusicstMVC.Servicios.Controllers.Reportes
{
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Entidades;
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

    /// <summary>
    /// Class DisenoReporteController.
    /// </summary>
    [Authorize]
    public class InformePrecargueRespuestasController : ApiController
    {
        [HttpGet]
        [Route("api/Informes/InformePrecargueRespuestas/DatosRejilla")]
        public IEnumerable<C_InformePrecargueRespuestas_Result> DatosRejilla(int idEncuesta = 0 )
        {
            IEnumerable<C_InformePrecargueRespuestas_Result> resultado = Enumerable.Empty<C_InformePrecargueRespuestas_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    BD.Database.CommandTimeout = 3600;
                    resultado = BD.C_InformePrecargueRespuestas(idEncuesta: idEncuesta).ToList();
                }
            }
            catch (System.Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

    }
}