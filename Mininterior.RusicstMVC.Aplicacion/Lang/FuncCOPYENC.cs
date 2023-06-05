using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using reactive.commons;
using System.Web.UI.WebControls;
using System.IO;

namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public class FuncCOPYENC : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke()
        {
            //Modelo anterior de preguntas
            if (Arguments.Length == 1)
            {
                var arg = Arguments[0];

                if (StringUtils.IsBlank(arg))
                    return null;

                if (arg.StartsWith("@") == false)
                    throw new Exception(string.Format("La función COPYENC requiere que su argumento sea una referencia que empieza por @: {0}", arg));
                return true;
            }
            else
            {
                if (Arguments.Length != 2)
                    throw new Exception(string.Format("La función COPYENC necesita máximo 2 argumentos pero se encontraron {0}", Arguments.Length));

                var arg = Arguments[0];
                var argenc = Arguments[1];

                if (StringUtils.IsBlank(arg))
                    return null;

                if (arg.StartsWith("@") == false)
                    throw new Exception(string.Format("La función COPYENC requiere que su argumento sea una referencia que empieza por @: {0}", arg));
                return true;
            }
        }
    }
}
