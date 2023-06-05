using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Mininterior.RusicstMVC.Servicios.Models;
using Mininterior.RusicstMVC.Entidades;

namespace Mininterior.RusicstMVC.Servicios.Lang
{
    public class FuncSUM : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke(FuncContext fctx)
        {
            List<int> idsPreguntas = new List<int>();

            for (int i = 0; i < Arguments.Length; i++)
            {
                var item = Arguments[i];

                if (item.StartsWith("@"))
                {
                    var qName = item.Substring(1);
                    int codigoPregunta;

                    int? idPregunta = null;

                    using (EntitiesRusicst BD = new EntitiesRusicst())
                    {
                        //Buscamos por Codigo banco preguntas
                        if (int.TryParse(qName, out codigoPregunta))
                        {
                            try
                            {
                                //buscamos por codigo + idseccion
                                idPregunta = BD.C_PreguntaXCodigo(qName, fctx.Pregunta.IdSeccion).First().IdPregunta;
                            }
                            catch (Exception )
                            {
                                try
                                {
                                    //No la encontro por idseccion, buscamos por idencuesta
                                    idPregunta = BD.C_PreguntaXCodigoNuevo(qName, fctx.Pregunta.IdEncuesta).First();
                                }
                                catch (Exception )
                                {
                                    //No deberia entrar acá, sin embargo confirmar con andrey
                                    idPregunta = 0;
                                }
                            }

                            idsPreguntas.Add(idPregunta.Value);
                        }
                        //Buscamos por Nombre pregunta viejo
                        else
                        {
                            //Esto no deberia pasar, confirmar con andrey, no encuentra la pregunta
                            try
                            {
                                idPregunta = BD.C_PreguntaXNombrePasada(qName).First();
                            }
                            catch (Exception )
                            {
                                idPregunta = 0;
                            }

                            idsPreguntas.Add(idPregunta.Value);
                        }
                    }
                }
            }

            return new
            {
                IdPreguntaSUM = fctx.Pregunta.Id,
                Valor = idsPreguntas,
                Func = "sum"
            };

            //var Istrue = "";
            //foreach (var item in Arguments)
            //{
            //    //var deps = IFuncFactory.Dependencies(item.ToString());
            //    //using (EntitiesRusicst BD = new EntitiesRusicst())
            //    //{
            //    //    Id = BD.C_PreguntaXNombrePasada(deps[0].ToString()).First().Value;
            //    //    _Postcargados.f2 = "EQ";
            //    //    _Postcargados.Id = Id;
            //    //    _Postcargados.Accion = "enabled";
            //    //    var Ret = IFuncFactory.ReturnValue(Arguments[1].ToString());
            //    //    _Postcargados.Val1 = Ret[0].ToString();
            //    //    //'"\"Si\"" ? "Si": "No";
            //    //    _Postcargados.Valor = "True";
            //    //}
            //    var func = IFuncFactory.CreateFunc(item);
            //    var valObj = func.Invoke(fctx);
            //    if (valObj != null)
            //    {
            //        Istrue = "";
            //    }
            //    else
            //    {
            //        Istrue = null;
            //    }
            //}
            //return Istrue;
        }
    }
}
