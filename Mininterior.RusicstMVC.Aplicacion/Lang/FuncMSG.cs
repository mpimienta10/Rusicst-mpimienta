using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public class FuncMSG : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke()
        {
            if(Arguments.Length != 1)
                throw new Exception(string.Format("La función MSG se debe usar con un solo argumento, tiene {0}", Arguments.Length));

            var message = Arguments[0].Trim();
            //fctx.ErrorMessage = message;

            return null;
        }
    }
}
