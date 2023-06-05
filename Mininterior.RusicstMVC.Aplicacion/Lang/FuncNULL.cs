using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public class FuncNULL : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke()
        {
            return null;
        }
    }
}
