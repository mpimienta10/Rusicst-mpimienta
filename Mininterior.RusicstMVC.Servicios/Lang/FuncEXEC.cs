using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mininterior.RusicstMVC.Servicios.Models;

namespace Mininterior.RusicstMVC.Servicios.Lang
{
    public class FuncEXEC : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke(FuncContext fctx)
        {
            object lastReturn = null;

            List<object> listObjs = new List<object>();

            foreach (var x in Arguments)
            {
                lastReturn = IFuncFactory.CreateFunc(x.Trim()).Invoke(fctx);

                listObjs.Add(lastReturn);
            }

            return new
            {
                Valor = listObjs,
                Func = "exec"
            };
        }
    }
}
