using System;
using System.Collections.Generic;
using System.Text;
using reactive.commons;
using System.Web.UI.WebControls;
using Mininterior.RusicstMVC.Entidades;



namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public class FuncCOPY : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke()
        {
            var arg = Arguments[0];

            if (StringUtils.IsBlank(arg))
                return null;

            if (arg.StartsWith("@") == false)
                throw new Exception(string.Format("La función COPY requiere que su argumento sea una referencia que empieza por @: {0}", arg));

            return null;
        }
    }
}
