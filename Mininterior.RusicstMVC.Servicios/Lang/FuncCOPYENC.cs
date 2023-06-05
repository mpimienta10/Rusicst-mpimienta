using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using reactive.commons;
using System.Web.UI.WebControls;
using System.IO;
using Mininterior.RusicstMVC.Servicios.Models;
using Mininterior.RusicstMVC.Entidades;
using Mininterior.RusicstMVC.Aplicacion.Adjuntos;

namespace Mininterior.RusicstMVC.Servicios.Lang
{
    public class FuncCOPYENC : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke(FuncContext fctx)
        {
            //Modelo anterior de preguntas
            if (Arguments.Length == 1)
            {
                var arg = Arguments[0];

                if (StringUtils.IsBlank(arg))
                    return null;

                if (arg.StartsWith("@") == false)
                    throw new Exception(string.Format("La función COPYENC requiere que su argumento sea una referencia que empieza por @: {0}", arg));

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    string returnVal = string.Empty;

                    try
                    {
                        if(!fctx.hasAnswers)
                        {
                            int idPreguntaCopied = BD.C_PreguntaXNombrePasada(arg.Substring(1)).First().Value;

                            returnVal = BD.C_RespuestaXIdPreguntaUsuario(idPreguntaCopied, fctx.IdUsuario).First().Valor;
                        }                        

                        return new
                        {
                            Valor = returnVal,
                            Func = "copyenc"
                        };
                    }
                    catch (Exception )
                    {
                        return new
                        {
                            Valor = returnVal,
                            Func = "copyenc"
                        };
                    }                   
                }
            }
            else
            {
                if (Arguments.Length != 2)
                    throw new Exception(string.Format("La función COPYENC necesita máximo 2 argumentos pero se encontraron {0}", Arguments.Length));

                var arg = Arguments[0];
                var argenc = Arguments[1];

                if (StringUtils.IsBlank(arg))
                    return null;

                if (arg.StartsWith("@") == false)
                    throw new Exception(string.Format("La función COPYENC requiere que su argumento sea una referencia que empieza por @: {0}", arg));


                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    string returnVal = null;

                    try
                    {
                        if(!fctx.hasAnswers)
                        {
                            int idPreguntaCopied = BD.C_PreguntaXCodigoNuevo(arg.Substring(1), int.Parse(argenc)).First().Value;

                            returnVal = BD.C_RespuestaXIdPreguntaUsuario(idPreguntaCopied, fctx.IdUsuario).First().Valor;

                            //Se cpian los archivos también, indiferentemente de si se mantienen o no
                            if (fctx.Pregunta.TipoPregunta == "ARCHIVO" && !string.IsNullOrEmpty(returnVal))
                            {
                                //dtos nuevo archivo
                                C_ObtenerDatosGuardadoArchivosEncuesta_Result datosFile = BD.C_ObtenerDatosGuardadoArchivosEncuesta(fctx.IdUsuario, fctx.Pregunta.IdSeccion).First();

                                //datos archivo viejo
                                C_DatosPregunta_Result datosOld = BD.C_DatosPregunta(idPreguntaCopied).FirstOrDefault();

                                //Datos sistema
                                //C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                                string filenamecopy = Path.GetFileName(returnVal);

                                //path archivo a copiar
                                string PathFinal = Path.Combine(datosFile.Usuario, argenc, datosOld.IdSeccion.ToString(), filenamecopy);

                                //archivo a copiar
                                var archivo = Archivo.GetFilesBytesFromShared(PathFinal);

                                string filenamefinal = fctx.Pregunta.Id.ToString() + "-" + filenamecopy;

                                returnVal = filenamefinal;

                                //// Guardar archivo en carpeta compartida
                                //Archivo.GuardarArchivoEncuesta(archivo, sistema.UploadDirectory, datosFile.Usuario, datosFile.Encuesta.ToString(), fctx.Pregunta.IdSeccion.ToString(), filenamefinal);

                                //// Guardar archivo en carpeta compartida -- network share
                                Archivo.GuardarArchivoEncuestaShared(archivo, "", datosFile.Usuario, datosFile.Encuesta.ToString(), fctx.Pregunta.IdSeccion.ToString(), filenamefinal);
                            }

                            returnVal = Path.GetFileName(returnVal);

                            PostCargadoControlesModel pregModel = new PostCargadoControlesModel();
                            pregModel.Id = fctx.Pregunta.Id;
                            pregModel.Valor = returnVal;
                            pregModel.aDelete = true;

                            fctx.datosPreControles.Add(pregModel);

                            //Guardamos el valor de la respuesta copiada en la bd por si se requiere a futuro
                            //BD.I_RespuestaEncuestaInsert(fctx.Pregunta.Id, returnVal, fctx.IdUsuario);

                            //Si el copyenc viene de un exec, guardamos el valor de la respuesta y el idpregunta de manera temporal, mientras tanto
                            if (fctx.isExec)
                            {
                                fctx.execValor = returnVal;
                            }                            
                        }                      

                        return new
                        {
                            Valor = returnVal,
                            Func = "copyenc"
                        };
                    }
                    catch (Exception )
                    {
                        return new
                        {
                            Valor = returnVal,
                            Func = "copyenc"
                        };
                    }
                }
            }
        }
    }
}
