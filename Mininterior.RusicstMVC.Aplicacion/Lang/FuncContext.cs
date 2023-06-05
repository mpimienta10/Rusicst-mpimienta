using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
//using rusicst_data;
using System.Web.UI.WebControls;

namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public class FuncContext
    {
        //public List<Respuesta> Respuestas { get; set; }
        //public Seccion Seccion { get; set; }
        //public Pregunta Pregunta { get; set; }
        public WebControl Control { get; set; }
        //public List<ControlPregunta> ControlPreguntas { get; set; }
        public string Username { get; set; }
        public string ErrorMessage { get; set; }
        public string InfoMessage { get; set; }
    }
}
