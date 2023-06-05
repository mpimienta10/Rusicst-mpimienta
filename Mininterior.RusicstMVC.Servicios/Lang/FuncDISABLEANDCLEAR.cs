using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Mininterior.RusicstMVC.Servicios.Models;
using Mininterior.RusicstMVC.Entidades;

namespace Mininterior.RusicstMVC.Servicios.Lang
{
    public class FuncDISABLEANDCLEAR : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke(FuncContext fctx)
        {
            if (Arguments.Length != 1)
                throw new Exception("La función DISABLEANDCLEAR requiere un solo parámetro");

            var qName = Arguments[0];
            if (qName.StartsWith("@") == false)
                throw new Exception("La función DISABLEANDCLEAR requiere un solo parámetro de tipo referencia, que comience por @");
            qName = qName.Substring(1);

            string valor = null;
            int codigoPregunta;
            int? idPregunta = null;

            if (qName == "this")
            {
                valor = fctx.Pregunta.Id.ToString();
            }
            else
            {
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    //Buscamos por Codigo banco preguntas Nuevo
                    if (int.TryParse(qName, out codigoPregunta))
                    {
                        //buscamos por codigo + idseccion
                        idPregunta = BD.C_PreguntaXCodigo(qName, fctx.Pregunta.IdSeccion).First().IdPregunta;
                    }
                    //Buscamos por Nombre de Pregunta viejo
                    else
                    {
                        idPregunta = BD.C_PreguntaXNombrePasada(qName).First();
                    }
                }

                valor = idPregunta.ToString();
            }

            return new
            {
                Valor = valor
                ,Func = "disableclear"
            };
        }
    }
}
