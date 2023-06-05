using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mininterior.RusicstMVC.Servicios.Models;

namespace Mininterior.RusicstMVC.Servicios.Lang
{
    public interface IFunc
    {
        string[] Arguments { get; set; }
        object Invoke(FuncContext fctx);
    }
}
