using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;

namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public class FuncDISABLEANDCLEAR : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke()
        {
            if (Arguments.Length != 1)
                throw new Exception("La función DISABLEANDCLEAR requiere un solo parámetro");

            var qName = Arguments[0];
            if (qName.StartsWith("@") == false)
                throw new Exception("La función DISABLEANDCLEAR requiere un solo parámetro de tipo referencia, que comience por @");
            qName = qName.Substring(1);

            if (qName == "this")
            {
                //fctx.Control.Enabled = false;
                //_Clear(fctx.Control);
            }
            else
            {
                //BancoPreguntasFac bpf = new BancoPreguntasFac();

                //var preg = bpf.ObtenerPreguntaValidacionEncuestaIDNewPreg(qName, fctx.Seccion.Encuesta.Id);

                //var cp = new ControlPregunta();

                //if(preg == null)
                //{
                //    cp = fctx.ControlPreguntas.FirstOrDefault(x => x.Pregunta.Nombre == qName);
                //}
                //else
                //{
                //    cp = fctx.ControlPreguntas.FirstOrDefault(x => x.Pregunta == preg);
                //}

                //if (cp != null)
                //{
                //    var wc = (WebControl)cp.Control;
                //    wc.Enabled = false;
                //    _Clear(wc);
                //}
            }

            return null;
        }

        private void _Clear(WebControl c)
        {
            if (c is TextBox)
            {
                ((TextBox)c).Text = "";
            }
            else if (c is DropDownList)
            {
                ((DropDownList)c).SelectedIndex = 0;
            }
            else if (c is CheckBoxList)
            {
                foreach (ListItem item in ((CheckBoxList)c).Items)
                {
                    item.Selected = false;
                }
            }
        }
    }
}
