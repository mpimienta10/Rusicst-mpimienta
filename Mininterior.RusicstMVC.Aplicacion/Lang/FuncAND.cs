using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public class FuncAND : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke()
        {
            foreach (var item in Arguments)
            {
                var func = IFuncFactory.CreateFunc(item);
                var valObj = func.Invoke();
                if (valObj != null)
                {
                    if (valObj is bool)
                    {
                        if (((bool)valObj) == false)
                            return false;
                    }
                }
                else
                {
                    return false;
                }
            }
            return true;
        }
    }
}
