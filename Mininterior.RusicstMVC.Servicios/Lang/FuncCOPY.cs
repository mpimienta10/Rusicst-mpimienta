using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using reactive.commons;
using System.Web.UI.WebControls;
using System.Globalization;
using Mininterior.RusicstMVC.Servicios.Models;
using Mininterior.RusicstMVC.Entidades;
using System.IO;
using Mininterior.RusicstMVC.Aplicacion.Adjuntos;

namespace Mininterior.RusicstMVC.Servicios.Lang
{
    public class FuncCOPY : IFunc
    {
        public string[] Arguments { get; set; }

        public object Invoke(FuncContext fctx)
        {
            var arg = Arguments[0];

            if (StringUtils.IsBlank(arg))
                return null;

            if (arg.StartsWith("@") == false)
                throw new Exception(string.Format("La función COPY requiere que su argumento sea una referencia que empieza por @: {0}", arg));
            
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
                         var obj1 = BD.C_PreguntaXCodigo(qName, fctx.Pregunta.IdSeccion).FirstOrDefault();

                        //No la encontro por idseccion, buscamos por idencuesta
                        if (obj1 != null)
                        {
                            idPregunta = obj1.IdPregunta;
                        } else
                        {
                            idPregunta = BD.C_PreguntaXCodigoNuevo(qName, fctx.Pregunta.IdEncuesta).FirstOrDefault();
                        }

                        //Si no la encuentra ni en la seccion, ni en la encuesta, retorno null y pailas
                        //de lo contrario retornamos el valor de la respuesta almacenada en la BD si no hay 
                        //respuesta digitada en el control
                        if (idPregunta.HasValue)
                        {
                            valor = string.IsNullOrEmpty(fctx.Pregunta.Respuesta) ? BD.C_RespuestaXIdPreguntaUsuario(idPregunta, fctx.IdUsuario).First().Valor : fctx.Pregunta.Respuesta;

                            if (fctx.Pregunta.TipoPregunta == "ARCHIVO" && !string.IsNullOrEmpty(valor))
                            {
                                //dtos nuevo archivo
                                C_ObtenerDatosGuardadoArchivosEncuesta_Result datosFile = BD.C_ObtenerDatosGuardadoArchivosEncuesta(fctx.IdUsuario, fctx.Pregunta.IdSeccion).First();

                                //datos archivo viejo
                                C_DatosPregunta_Result datosOld = BD.C_DatosPregunta(idPregunta).FirstOrDefault();

                                //Datos sistema
                                //C_DatosSistema_Result sistema = BD.C_DatosSistema().Cast<C_DatosSistema_Result>().FirstOrDefault();

                                string filenamecopy = Path.GetFileName(valor);

                                //path archivo a copiar
                                string PathFinal = Path.Combine(datosFile.Usuario, datosFile.Encuesta.ToString(), datosOld.IdSeccion.ToString(), filenamecopy);

                                //archivo a copiar
                                var archivo = Archivo.GetFilesBytesFromShared(PathFinal);

                                string filenamefinal = fctx.Pregunta.Id.ToString() + "-" + filenamecopy;

                                valor = filenamefinal;

                                //// Guardar archivo en carpeta compartida -- network share
                                Archivo.GuardarArchivoEncuestaShared(archivo, "", datosFile.Usuario, datosFile.Encuesta.ToString(), fctx.Pregunta.IdSeccion.ToString(), filenamefinal);
                            }
                        }                        

                        valor = Path.GetFileName(valor);

                        //Guardamos el valor de la respuesta copiada en la bd por si se requiere a futuro
                        //BD.I_RespuestaEncuestaInsert(fctx.Pregunta.Id, valor, fctx.IdUsuario);
                        PostCargadoControlesModel pregModel = new PostCargadoControlesModel();
                        pregModel.Id = fctx.Pregunta.Id;
                        pregModel.Valor = valor;
                        pregModel.aDelete = true;

                        fctx.datosPreControles.Add(pregModel);

                        //Si el copyenc viene de un exec, guardamos el valor de la respuesta y el idpregunta de manera temporal, mientras tanto
                        if (fctx.isExec)
                        {
                            fctx.execValor = valor;
                        }

                        return new
                        {
                            Valor = valor,
                            Func = "copy"
                        };
                    }
                    catch (Exception ex)
                    {
                        return new
                        {
                            Valor = valor,
                            Func = "copy"
                        };
                    }                    
                }
                //Buscamos por Nombre pregunta viejo
                else
                {
                    try
                    {
                        idPregunta = BD.C_PreguntaXNombrePasada(qName).First();

                        //Si no la encuentra retorno null y pailas
                        //de lo contrario retornamos el valor de la respuesta almacenada en la BD si no hay 
                        //respuesta digitada en el control
                        if (idPregunta.HasValue)
                        {
                            valor = string.IsNullOrEmpty(fctx.Pregunta.Respuesta) ? BD.C_RespuestaXIdPreguntaUsuario(idPregunta, fctx.IdUsuario).First().Valor : fctx.Pregunta.Respuesta;
                        }

                        return new
                        {
                            Valor = valor,
                            Func = "copy"
                        };
                    }
                    catch(Exception )
                    {
                        return new
                        {
                            Valor = valor,
                            Func = "copy"
                        };
                    }                    
                }
            }
        }
    }
}
