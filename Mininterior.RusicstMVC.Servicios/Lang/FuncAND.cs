using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Mininterior.RusicstMVC.Servicios.Models;

namespace Mininterior.RusicstMVC.Servicios.Lang
{
    public class FuncAND : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke(FuncContext fctx)
        {
            foreach (var item in Arguments)
            {
                var func = IFuncFactory.CreateFunc(item);
                var valObj = func.Invoke(fctx);
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
