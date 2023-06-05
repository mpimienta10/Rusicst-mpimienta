using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using reactive.commons;
using System.Web.UI.WebControls;
using System.Globalization;
using Mininterior.RusicstMVC.Servicios.Models;
using Mininterior.RusicstMVC.Entidades;

namespace Mininterior.RusicstMVC.Servicios.Lang
{
    public class FuncEval : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke(FuncContext fctx)
        {
            if (Arguments.Length != 1)
                throw new Exception(string.Format("La función Eval solo puede ser aplicada a un parámetro, se encontraron {0}", Arguments.Length));

            var arg = Arguments[0].Trim();

            //BancoPreguntasFac bpf = new BancoPreguntasFac();

            if (arg.StartsWith("@"))
            {
                var qName = arg.Substring(1);
                int codigoPregunta;
                string valor = null;

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
                            catch(Exception )
                            {
                                //No deberia entrar acá, sin embargo confirmar con andrey
                            }
                        }

                        //Si no la encuentra ni en la seccion, ni en la encuesta, retorno null y pailas
                        //de lo contrario retornamos el valor de la respuesta almacenada en la BD si no hay 
                        //respuesta digitada en el control
                        if (idPregunta.HasValue)
                        {
                            //solo en los callbacks al cambiar de valores en los combos, etc..
                            if (fctx.isCallback && fctx.idPreguntaCallback == idPregunta)
                            {
                                valor = fctx.callbackValue;
                            }
                            else
                            {
                                string val = "";

                                try
                                {
                                    val = BD.C_RespuestaXIdPreguntaUsuario(idPregunta, fctx.IdUsuario).First().Valor;
                                }
                                catch (Exception )
                                {
                                    //Solo en exec
                                    if(!fctx.isCallback && fctx.isExec)
                                    {
                                        if(idPregunta == fctx.execIdPregunta)
                                        {
                                            val = fctx.execValor;
                                        }
                                    }

                                    //Solo en callback
                                    if(fctx.datosControles != null)
                                    {
                                        //Si el valor del control es vacío, es decir estamos evaluando otra pregunta
                                        //diferente a la que lanzó el callback, miramos en la lista de respuestas de 
                                        //los otros controles

                                        if (string.IsNullOrEmpty(valor))
                                        {
                                            for (int i = 0; i < fctx.datosControles.Count; i++)
                                            {
                                                var controlPregunta = fctx.datosControles.ElementAt(i);

                                                if (controlPregunta.Id == idPregunta)
                                                {
                                                    val = controlPregunta.Valor;
                                                    break;
                                                }
                                            }
                                        }
                                    }

                                    //Solo en callback
                                    if (fctx.datosPreControles != null)
                                    {
                                        //Si el valor del control es vacío, es decir estamos evaluando otra pregunta
                                        //diferente a la que lanzó el callback, miramos en la lista de respuestas de 
                                        //los otros controles

                                        if (string.IsNullOrEmpty(valor))
                                        {
                                            for (int i = 0; i < fctx.datosPreControles.Count; i++)
                                            {
                                                var controlPregunta = fctx.datosPreControles.ElementAt(i);

                                                if (controlPregunta.Id == idPregunta)
                                                {
                                                    val = controlPregunta.Valor;
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }

                                //valor = string.IsNullOrEmpty(fctx.Pregunta.Respuesta) ? val : fctx.Pregunta.Respuesta;
                                valor = val;
                            }

                            

                            //switch (fctx.Pregunta.TipoPregunta)
                            //{
                            //    case "DECIMAL":
                            //    case "NUMERO":
                            //    case "MONEDA":
                            //    case "PORCENTAJE":
                            //        {
                            //            valor = valor.Replace(',', Convert.ToChar(CultureInfo.CurrentCulture.NumberFormat.NumberGroupSeparator));
                            //            return decimal.Parse(valor);
                            //        }
                            //    default:
                            //        return valor;
                            //}

                            return valor;
                        }

                        return valor;
                    }
                    //Buscamos por Nombre pregunta viejo
                    else
                    {
                        //Esto no deberia pasar, confirmar con andrey, no encuentra la pregunta
                        try
                        {
                            idPregunta = BD.C_PreguntaXNombrePasada(qName).First();
                        }
                        catch(Exception )
                        {
                        }                        

                        //Si no la encuentra retorno null y pailas
                        //de lo contrario retornamos el valor de la respuesta almacenada en la BD si no hay 
                        //respuesta digitada en el control
                        if (idPregunta.HasValue)
                        {
                            //solo en los callbacks al cambiar de valores en los combos, etc..
                            if (fctx.isCallback && fctx.idPreguntaCallback == idPregunta)
                            {
                                valor = fctx.callbackValue;
                            }
                            else
                            {
                                string val = "";

                                try
                                {
                                    val = BD.C_RespuestaXIdPreguntaUsuario(idPregunta, fctx.IdUsuario).First().Valor;
                                }
                                catch (Exception )
                                {
                                }

                                //valor = string.IsNullOrEmpty(fctx.Pregunta.Respuesta) ? val : fctx.Pregunta.Respuesta;
                                valor = val;
                            }

                            //switch (fctx.Pregunta.TipoPregunta)
                            //{
                            //    case "DECIMAL":
                            //    case "NUMERO":
                            //    case "MONEDA":
                            //    case "PORCENTAJE":
                            //        {
                            //            valor = valor.Replace(',', Convert.ToChar(CultureInfo.CurrentCulture.NumberFormat.NumberGroupSeparator));
                            //            return decimal.Parse(valor);
                            //        }
                            //    default:
                            //        return valor;
                            //}

                            return valor;
                        }

                        return valor;
                    }
                }
            }
            else if (arg.StartsWith("\""))
            {
                return arg.Substring(1, arg.Length - 2);
            }

            return null;
        }
    }
}
