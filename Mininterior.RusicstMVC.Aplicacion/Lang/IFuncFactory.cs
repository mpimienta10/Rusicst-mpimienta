using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using reactive.commons;

namespace Mininterior.RusicstMVC.Aplicacion.Lang
{
    public class IFuncFactory
    {
        private static Regex funcRegex = new Regex(@"([a-zA-Z]+)\((.*)\)");

        public static IFunc CreateFunc(string expression)
        {
            var match = funcRegex.Match(expression);
            IFunc func = null;
            if (match.Success)
            {
                var funcName = match.Groups[1];
                var funcObject = ReflectionUtils.Initialize(typeof(IFuncFactory).Assembly.FullName, "Mininterior.RusicstMVC.Aplicacion.Lang.Func" + funcName);
                if (funcObject == null || (funcObject is IFunc) == false)
                    throw new Exception(string.Format("La función Func{0} no se encuentra o no es una función válida", funcName));
                func = (IFunc)funcObject;
                func.Arguments = _ParseArguments(match.Groups[2].Value);
            }
            else if (expression.Contains('(') == false)
            {
                func = new FuncEval();
                func.Arguments = new string[] { expression };
            }
            else
            {
                throw new Exception(string.Format("La expresión '{0}' no puede ser interpretada", expression));
            }
            return func;
        }

        public static string[] Dependencies(string expression)
        {
            var deps = new List<string>();
            var b = new StringBuilder();
            var isReading = false;
            foreach (var c in expression)
            {
                if (c == '@')
                {
                    isReading = true;
                    continue;
                }

                if (isReading)
                {
                    if (c == ';' || c == ' ' || c == ')' || c == '(')
                    {
                        deps.Add(b.ToString());
                        b = new StringBuilder();
                        isReading = false;
                    }
                    else
                    {
                        b.Append(c);
                    }
                }
            }
            if (isReading)
                deps.Add(b.ToString());
            return deps.ToArray();
        }

        private static string[] _ParseArguments(string expression)
        {
            var stack = new Stack<char>();
            var expBuilder = new StringBuilder();
            var args = new List<string>();
            foreach (var c in expression)
            {
                if (c == ';' && stack.Count == 0)
                {
                    args.Add(expBuilder.ToString());
                    expBuilder = new StringBuilder();
                    continue;
                }
                else if (c == '(')
                {
                    stack.Push(c);
                }
                else if (c == ')')
                {
                    stack.Pop();
                }
                expBuilder.Append(c);
            }
            args.Add(expBuilder.ToString());
            return args.ToArray();
        }
    }
}
