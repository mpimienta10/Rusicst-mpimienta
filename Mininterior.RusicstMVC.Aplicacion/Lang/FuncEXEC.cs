using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public class FuncEXEC : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke()
        {
            object lastReturn = null;
            foreach (var x in Arguments)
            {
                lastReturn = IFuncFactory.CreateFunc(x.Trim()).Invoke();
            }
            return lastReturn;
        }
    }
}
