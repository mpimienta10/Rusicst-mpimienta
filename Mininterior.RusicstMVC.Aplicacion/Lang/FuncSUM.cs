using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;

namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public class FuncSUM : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke()
        {
            decimal ans = 0;
            foreach (var item in Arguments)
            {
                var func = IFuncFactory.CreateFunc(item);
                var valObj = func.Invoke();
                if (valObj != null)
                {
                    var valStr = valObj.ToString();
                    decimal tmp = 0;
                    if (decimal.TryParse(valStr, out tmp) == false)
                    {
                        ans = decimal.MaxValue;
                    }
                    else
                    {
                        ans += tmp;
                    }
                }
            }
            //if (fctx.Control is TextBox)
            //    ((TextBox)fctx.Control).Text = ans.ToString();
            return ans;
        }
    }
}
