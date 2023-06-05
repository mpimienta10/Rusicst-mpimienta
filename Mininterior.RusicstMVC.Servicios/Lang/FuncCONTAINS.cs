using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI.WebControls;
using Mininterior.RusicstMVC.Entidades;
using Mininterior.RusicstMVC.Servicios.Models;


namespace Mininterior.RusicstMVC.Servicios.Lang
{
    public class FuncCONTAINS : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke(FuncContext fctx)
        {
            if (Arguments.Length != 2)
                throw new Exception(string.Format("La función CONTAINS se debe usar con dos argumentos, tiene {0}", Arguments.Length));

            var left = Arguments[0].Trim();
            var right = Arguments[1].Trim();

            var leftVal = IFuncFactory.CreateFunc(left).Invoke(fctx);
            var rightVal = IFuncFactory.CreateFunc(right).Invoke(fctx);

            if (leftVal == null && rightVal == null)
                return true;

            if (leftVal == null && rightVal != null)
                return false;

            if (leftVal != null && rightVal == null)
                return false;

            left = leftVal.ToString();
            right = rightVal.ToString();

            return left.Contains(right);
        }
    }
}
