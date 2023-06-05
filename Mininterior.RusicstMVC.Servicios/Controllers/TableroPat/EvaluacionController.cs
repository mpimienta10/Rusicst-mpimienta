namespace Mininterior.RusicstMVC.Servicios.Controllers.TableroPat
{
    using Aplicacion.Seguridad;
    using Mininterior.RusicstMVC.Entidades;
    using Models;
    using Providers;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http;

    /// <summary>
    /// Class PreguntasController.
    /// </summary>
    public class EvaluacionController : ApiController
    {
        #region APIS PARA LA PANTALLA DE EVALUACION DE TABLERO PAT   

        /// <summary>
        /// Cargars the edicion preguntas.
        /// </summary>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarEvaluacion/{Usuario}")]
        public object CargarEvaluacion(string Usuario = "")
        {
            AdministracionController clspreguntas = new AdministracionController();
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();

            var derechos = clspreguntas.TodosDerechos().ToList();
            var tableros = clspreguntas.TodosTableros().ToList();
            var modelUsuario = new UsuariosModels { UserName = Usuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);

            var objeto = new
            {
                derechos = derechos,
                tableros = tableros,
                datosUsuario = datosUsuario
            };

            return objeto;
        }

        /// <summary>
        /// Preguntases this instance.
        /// </summary>
        /// <returns>IEnumerable&lt;C_PreguntasPat_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/Evaluacion/{idTablero},{idDepartamento},{idMunicipio},{idDerecho}")]
        public IEnumerable<C_EvaluacionSeguimiento_Result> Evaluacion(byte idTablero = 0, int idDepartamento = 0, int idMunicipio = 0, int idDerecho = 0)
        {
            IEnumerable<C_EvaluacionSeguimiento_Result> resultado = Enumerable.Empty<C_EvaluacionSeguimiento_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_EvaluacionSeguimiento(idTablero: idTablero, idDepartamento: idDepartamento, idMunicipio: idMunicipio, idDerecho: idDerecho).Cast<C_EvaluacionSeguimiento_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion

        #region APIS PARA LA PANTALLA DE EVALUACION DE TABLERO PAT PARA EL CONSOLIDADO  

        /// <summary>
        /// Cargars the edicion preguntas.
        /// </summary>
        /// <returns>System.Object.</returns>
        [HttpGet]
        [Route("api/TableroPat/CargarEvaluacionConsolidado/{Usuario}")]
        public object CargarEvaluacionConsolidado(string Usuario = "")
        {
            AdministracionController clspreguntas = new AdministracionController();
            Usuarios.UsuariosController clsusuario = new Usuarios.UsuariosController();
            var tableros = clspreguntas.TodosTableros().ToList();
            var modelUsuario = new UsuariosModels { UserName = Usuario };
            var datosUsuario = clsusuario.BuscarXUsuario(modelUsuario);

            var objeto = new
            {
                tableros = tableros,
                datosUsuario = datosUsuario
            };

            return objeto;
        }

        /// <summary>
        /// Preguntases this instance.
        /// </summary>
        /// <returns>IEnumerable&lt;C_PreguntasPat_Result&gt;.</returns>
        [HttpGet]
        [Route("api/TableroPat/EvaluacionConsolidado/{idTablero},{idDepartamento}")]
        public IEnumerable<C_EvaluacionConsolidado_Result> EvaluacionConsolidado(byte idTablero = 0, int idDepartamento = 0)
        {
            IEnumerable<C_EvaluacionConsolidado_Result> resultado = Enumerable.Empty<C_EvaluacionConsolidado_Result>();

            try
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    resultado = BD.C_EvaluacionConsolidado(idTablero: idTablero, idDepartamento: idDepartamento).Cast<C_EvaluacionConsolidado_Result>().ToList(); ;
                }
            }
            catch (Exception ex)
            {
                (new AuditExecuted(Category.Excepciones)).ActionExecutedException(string.Empty, string.Empty, Mininterior.RusicstMVC.Aplicacion.Excepciones.ManagerException.RetornarError(ex));
            }

            return resultado;
        }

        #endregion      
    }
}