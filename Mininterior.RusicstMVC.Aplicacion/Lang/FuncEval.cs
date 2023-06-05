using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using reactive.commons;
using System.Web.UI.WebControls;
using System.Globalization;

namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public class FuncEval : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke()
        {
            if (Arguments.Length != 1)
                throw new Exception(string.Format("La función Eval solo puede ser aplicada a un parámetro, se encontraron {0}", Arguments.Length));

            var arg = Arguments[0].Trim();

            //BancoPreguntasFac bpf = new BancoPreguntasFac();

            if (arg.StartsWith("@"))
            {
                var qName = arg.Substring(1);
                //string valor = null;
                //var p = fctx.Seccion.Preguntas.FirstOrDefault(x => x.Nombre == qName);
                //var p = bpf.ObtenerPreguntaValidacion(qName, fctx.Seccion.Preguntas.ToList());
                //var p = bpf.ObtenerPreguntaValidacionNewPreg(arg.Substring(1), fctx.Seccion.Id);

                //if(p == null)
                //{
                //    p = fctx.Seccion.Preguntas.FirstOrDefault(x => x.Nombre == qName);
                //}

            //    if (p != null)
            //    {
            //        //var rs = fctx.Respuestas.Where(x => x.IdPregunta == p.Id);
            //        //valor = StringUtils.Implode(rs.Select(x => x.Valor).ToArray());
            //        var cp = fctx.ControlPreguntas.First(x => x.Pregunta.Id == p.Id);
            //        if (cp.Control is TextBox)
            //        {
            //            valor = ((TextBox)cp.Control).Text;
            //        }
            //        else if (cp.Control is DropDownList)
            //        {
            //            valor = ((DropDownList)cp.Control).SelectedValue;
            //        }
            //        else if (cp.Control is CheckBoxList)
            //        {
            //            valor = WebControlUtils.GetSelectedItems((CheckBoxList)cp.Control).Implode();
            //        }
            //        else if (cp.Control is Label)
            //        {
            //            valor = ((Label)cp.Control).Text;
            //        }
            //    }
            //    else
            //    {
            //        var ctx = RusicstFacade.Instance.GetDataContext();
            //        //p = ctx.Preguntas.FirstOrDefault(x => x.Nombre == qName && x.Seccion.IdEncuesta == fctx.Seccion.IdEncuesta);
            //        p = bpf.ObtenerPreguntaValidacionEncuestaIDNewPreg(qName, fctx.Seccion.IdEncuesta);

            //        if (p == null)
            //        {
            //            p = ctx.Preguntas.FirstOrDefault(x => x.Nombre == qName && x.Seccion.IdEncuesta == fctx.Seccion.IdEncuesta);
            //        }

            //        if (p == null)
            //            return null;
            //        var rs = ctx.Respuestas.Where(x => x.IdPregunta == p.Id && x.Usuario == fctx.Username);
            //        valor = StringUtils.Implode(rs.Select(x => x.Valor).ToArray());
            //    }
            //    if (StringUtils.IsBlank(valor))
            //        return null;

            //    switch (p.TipoPregunta)
            //    {
            //        case "DECIMAL":
            //        case "NUMERO":
            //        case "MONEDA":
            //        case "PORCENTAJE":
            //            {
            //                valor = valor.Replace(',', Convert.ToChar(CultureInfo.CurrentCulture.NumberFormat.NumberGroupSeparator));
            //                return decimal.Parse(valor);
            //            }
            //        default:
            //            return valor;
            //    }
            //}
            //else if (arg.StartsWith("\""))
            //{
            //    return arg.Substring(1, arg.Length - 2);
            }

            return null;
        }
    }
}
