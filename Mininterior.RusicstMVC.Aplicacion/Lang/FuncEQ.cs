using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public class FuncEQ : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke()
        {
            if(Arguments.Length != 2)
                throw new Exception(string.Format("La función EQ se debe usar con dos argumentos, tiene {0}", Arguments.Length));

            var left = Arguments[0].Trim();
            var right = Arguments[1].Trim();

            var leftVal = IFuncFactory.CreateFunc(left).Invoke();
            var rightVal = IFuncFactory.CreateFunc(right).Invoke();

            if(leftVal == null && rightVal == null)
                return true;

            if(leftVal == null && rightVal != null)
                return false;

            if(leftVal != null && rightVal == null)
                return false;

            left = leftVal.ToString();
            right = rightVal.ToString();

            return left == right;
        }
    }
}
