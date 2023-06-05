using System;
using System.Collections.Generic;
using System.Text;
using Mininterior.RusicstMVC.Servicios.Models;
// ***********************************************************************
// Assembly         : Mininterior.RusicstMVC.Aplicacion
// Author           : Equipo de desarrollo OIM - 
// Created          : 02-25-2017
//
// Last Modified By : Equipo de desarrollo OIM - Rafael Alba
// Last Modified On : 07-25-2017
// ***********************************************************************
// <copyright file="Correo.cs" company="Ministerio del Interior">
//     Copyright © Ministerio del Interior 2017
// </copyright>
// <summary>Clase de funcion IF</summary>
// ***********************************************************************
namespace Mininterior.RusicstMVC.Servicios.Lang
{
    public class FuncIF : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke(FuncContext fctx)
        {
            if (Arguments.Length != 3)
                throw new Exception(string.Format("La función IF necesita 3 argumentos pero se encontraron {0}", Arguments.Length));

            var cond = IFuncFactory.CreateFunc(Arguments[0]);
            object condValueObject = cond.Invoke(fctx);
            bool condValue = false;
            if (condValueObject == null || condValueObject is bool == false)
            {
                condValue = (condValueObject != null);
            }
            else
            {
                condValue = (bool)condValueObject;
            }

            if (condValue)
                return IFuncFactory.CreateFunc(Arguments[1]).Invoke(fctx);
            return IFuncFactory.CreateFunc(Arguments[2]).Invoke(fctx);
        }
    }
}
