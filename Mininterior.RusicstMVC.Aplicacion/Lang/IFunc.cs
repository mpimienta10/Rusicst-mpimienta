using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public interface IFunc
    {
        string[] Arguments { get; set; }
        object Invoke();
    }
}
