using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mininterior.RusicstMVC.Servicios.Models;

namespace Mininterior.RusicstMVC.Servicios.Lang
{
    public class FuncNULL : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke(FuncContext fctx)
        {
            return null;
        }
    }
}
