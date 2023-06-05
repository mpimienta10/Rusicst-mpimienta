using Mininterior.RusicstMVC.Servicios.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
//using rusicst_data;
using System.Web.UI.WebControls;

namespace Mininterior.RusicstMVC.Servicios.Lang
{
    public class FuncContext
    {
        //public List<Respuesta> Respuestas { get; set; }
        //public Seccion Seccion { get; set; }
        //public Pregunta Pregunta { get; set; }
        public WebControl Control { get; set; }
        //public List<ControlPregunta> ControlPreguntas { get; set; }
        public string Username { get; set; }
        public int IdUsuario { get; set; }
        public string ErrorMessage { get; set; }
        public string InfoMessage { get; set; }
        public PreguntasOpciones Pregunta { get; set; }
        public bool isCallback { get; set; }
        public string callbackValue { get; set; }
        public int idPreguntaCallback { get; set; }
        public bool hasAnswers { get; set; }
        public List<PostCargadoControlesModel> datosControles { get; set; }
        public List<PostCargadoControlesModel> datosPreControles { get; set; }
        public bool isExec { get; set; }
        public int execIdPregunta { get; set; }
        public string execValor { get; set; }
    }
}
