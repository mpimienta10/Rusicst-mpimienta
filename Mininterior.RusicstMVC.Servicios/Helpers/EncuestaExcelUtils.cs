using DocumentFormat.OpenXml.Drawing.Diagrams;
using Microsoft.Office.Interop.Excel;
using Mininterior.RusicstMVC.Entidades;
using Mininterior.RusicstMVC.Servicios.Models;
using Mininterior.RusicstMVC.Servicios.Providers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Mininterior.RusicstMVC.Servicios.Helpers
{
    public class EncuestaExcelUtils
    {
        public static void ParseExcel(SeccionModels seccion)
        {
            var name = Guid.NewGuid().ToString();
            try
            {
                Workbook wb = ExcelAppFacade.Load(seccion.Archivo.ToArray(), name);
                C_AccionesResultado Resultado = new C_AccionesResultado();

                if (wb.Worksheets.Count < 3)
                    throw new Exception("El archivo cargado debe tener por lo menos tres hojas, la primera para el diseño, la segunda con las definiciones de los campos de pregunta y la tercera para definir las opciones de las preguntas de selección múltiple.");

                var sLayout = (Worksheet)wb.Worksheets[1];
                var sDef = (Worksheet)wb.Worksheets[2];
                var sOpc = (Worksheet)wb.Worksheets[3];

                var startCell = ExcelAppFacade.GetStringValue(sDef, 1, 1);
                var endCell = ExcelAppFacade.GetStringValue(sDef, 1, 2);
                if (StringUtils.IsBlank(startCell) || StringUtils.IsBlank(endCell))
                    throw new Exception("No se ha definido la posición inicial o final del diseño");

                var startC = new Coordinate(startCell);
                if (startC.R == -1 && startC.R == -1)
                {
                    throw new Exception("Error al obtener la celda inicial");
                }
                var endC = new Coordinate(endCell);
                if (endC.R == -1 && endC.R == -1)
                {
                    throw new Exception("Error al obtener la celda final");
                }

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    Resultado = BD.D_ContenidoSeccionDelete(seccion.Id).FirstOrDefault();
                    if (Resultado.estado == 0)
                        throw new Exception(Resultado.respuesta);
                }

                var mergeAreas = new Dictionary<string, object>();

                for (int r = startC.R; r <= endC.R; r++)
                {
                    for (int c = startC.C; c <= endC.C; c++)
                    {
                        var range = ExcelAppFacade.GetRange(sLayout, r + 1, c + 1);
                        var mergedRows = range.MergeArea.Rows.Count;
                        var mergedCols = range.MergeArea.Columns.Count;
                        if (mergedRows > 1 || mergedCols > 1)
                        {
                            var mergedStart = ((Range)range.MergeArea.Cells[1, 1]).Address;
                            var mergedEnd = ((Range)range.MergeArea.Cells[range.MergeArea.Rows.Count, range.MergeArea.Columns.Count]).Address;
                            var mergedString = string.Format("{0}-{1}", mergedStart, mergedEnd);
                            mergeAreas[mergedString] = new object();
                        }
                        var text = ExcelAppFacade.GetStringValue(sLayout, r + 1, c + 1);
                        if (StringUtils.IsBlank(text) && !(mergedRows > 1 || mergedCols > 1))
                            continue;
                        if (StringUtils.IsBlank(text))
                        {
                            text = " ";
                        }
                        var item = new DisenoModels()
                        {
                            IdSeccion = seccion.Id.Value,
                            RowIndex = r,
                            ColumnIndex = c,
                            Texto = text
                        };
                        seccion.Disenos.Add(item);
                    }
                }
                if (seccion.Disenos.Any(x => x.ColumnIndex == endC.C && x.RowIndex == endC.R) == false)
                    seccion.Disenos.Add(new DisenoModels()
                    {
                        IdSeccion = seccion.Id.Value,
                        ColumnIndex = endC.C,
                        RowIndex = endC.R,
                        Texto = ""
                    });

                // Combina las celdas poniendo los estilos correspondientes
                foreach (var area in mergeAreas.Keys)
                {
                    var addresses = area.Split('-');
                    var first = new Coordinate(addresses[0]);
                    if (first.R == -1 && first.R == -1)
                    {
                        throw new Exception("Error al obtener la celda inicial de la combinación");
                    }
                    var last = new Coordinate(addresses[1]);
                    if (last.R == -1 && last.R == -1)
                    {
                        throw new Exception("Error al obtener la celda inicial");
                    }
                    var diseno = seccion.Disenos.FirstOrDefault(x => x.ColumnIndex == first.C && x.RowIndex == first.R);
                    if (null != diseno)
                    {
                        if (diseno.Texto.StartsWith("%"))
                        {
                            var format = diseno.Texto.Substring(1, diseno.Texto.Substring(1).IndexOf('%'));
                            var text = diseno.Texto.Substring(diseno.Texto.Substring(1).IndexOf('%') + 2);
                            format = format + ";CS=" + (last.C - first.C + 1).ToString() + ";RS=" + (last.R - first.R + 1).ToString();
                            diseno.Texto = "%" + format + "%" + text;
                        }
                        else
                        {
                            diseno.Texto = "%" + ";CS=" + (last.C - first.C + 1).ToString() + ";RS=" + (last.R - first.R + 1).ToString() + "%" + diseno.Texto;
                        }
                    }
                }

                var pregList = new List<PreguntaModels>();

                var defStart = new Coordinate("A3");

                List<C_TiposPregunta_Result> types = new List<C_TiposPregunta_Result>();

                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    types = BD.C_TiposPregunta().ToList();
                }

                for (int r = defStart.R; ; r++)
                {
                    var cellIdInicio = ExcelAppFacade.GetStringValue(sDef, r + 1, defStart.C + 1);
                    if (StringUtils.IsBlank(cellIdInicio))
                        break;
                    var cellIdFin = ExcelAppFacade.GetStringValue(sDef, r + 1, defStart.C + 2);
                    var cellName = ExcelAppFacade.GetStringValue(sDef, r + 1, defStart.C + 3);
                    if (StringUtils.IsBlank(cellIdFin))
                        cellIdFin = cellIdInicio;

                    var cellType = ExcelAppFacade.GetStringValue(sDef, r + 1, defStart.C + 4);
                    if (StringUtils.IsNotBlank(cellType))
                    {
                        cellType = cellType.Trim();
                    }
                    C_TiposPregunta_Result type = types.FirstOrDefault(x => x.Nombre == cellType);
                    if (type == null)
                    {
                        throw new Exception(string.Format("El tipo de pregunta '{0}' no se permite", cellType));
                    }

                    var cellAyuda = ExcelAppFacade.GetStringValue(sDef, r + 1, defStart.C + 5);
                    var cellOpciones = ExcelAppFacade.GetStringValue(sDef, r + 1, defStart.C + 6);
                    var cellObliga = ExcelAppFacade.GetStringValue(sDef, r + 1, defStart.C + 7);
                    var cellEsMultiple = ExcelAppFacade.GetStringValue(sDef, r + 1, defStart.C + 8);
                    var valEsMultiple = false;
                    bool.TryParse(cellEsMultiple, out valEsMultiple);
                    var cellSoloSi = ExcelAppFacade.GetStringValue(sDef, r + 1, defStart.C + 9);
                    if (!string.IsNullOrEmpty(cellSoloSi))
                    {
                        int contAbre = cellSoloSi.Split('(').Length - 1;
                        int contCierra = cellSoloSi.Split(')').Length - 1;

                        if ((contAbre - contCierra) != 0)
                        {
                            throw new Exception("Error el valor de la celda validación de la pregunta " + cellName + " de la celda (" + (r + 1) + "," + (defStart.C + 9) + ")");
                        }
                    }

                    var cellTextos = ExcelAppFacade.GetStringValue(sDef, r + 1, defStart.C + 12);
                    if (!string.IsNullOrEmpty(cellTextos))
                    {
                        int contAbre = cellTextos.Split('(').Length - 1;
                        int contCierra = cellTextos.Split(')').Length - 1;
                        if ((contAbre - contCierra) != 0)
                        {
                            throw new Exception("Error el valor de la celda Referencia de Texto de la pregunta " + cellName + " de la celda (" + (r + 1) + "," + (defStart.C + 12) + ")");
                        }
                    }
                    var pCoordInicio = new Coordinate(cellIdInicio);
                    if (pCoordInicio.R == -1 && pCoordInicio.R == -1)
                    {
                        throw new Exception("Error el valor de la celda inicial de la pregunta " + cellName + " de la celda (" + (r + 1) + "," + (defStart.C + 1) + ")");
                    }
                    var pCoordFin = (Coordinate)null;
                    if (StringUtils.IsNotBlank(cellIdFin))
                    {
                        pCoordFin = new Coordinate(cellIdFin);
                        if (pCoordFin.R == -1 && pCoordFin.R == -1)
                        {
                            throw new Exception("Error el valor de la celda final de la pregunta " + cellName + " de la celda (" + (r + 1) + "," + (defStart.C + 2) + ")");
                        }
                    }
                    else
                        pCoordFin = pCoordInicio;

                    for (int pRow = pCoordInicio.R; pRow <= pCoordFin.R; pRow++)
                    {
                        for (int pCol = pCoordInicio.C; pCol <= pCoordFin.C; pCol++)
                        {
                            if (StringUtils.IsBlank(cellTextos))
                                cellTextos = "";
                            var textos = cellTextos.Split(',');
                            var sb = new StringBuilder();
                            if (StringUtils.IsBlank(cellTextos))
                            {
                                if (pCol > 0)
                                {
                                    var itemDiseno = seccion.Disenos.FirstOrDefault(x => x.RowIndex == pRow && x.ColumnIndex == pCol - 1);
                                    if (itemDiseno != null)
                                        sb.Append(itemDiseno.Texto);
                                }
                            }
                            else
                            {
                                foreach (var item in textos)
                                {
                                    var itemCoord = new Coordinate(item.Trim());
                                    if (itemCoord.R == -1 && itemCoord.R == -1)
                                    {
                                        throw new Exception("Error el valor de la celda textos (" + item.Trim() + ")");
                                    }
                                    var itemDiseno = seccion.Disenos.FirstOrDefault(x => x.RowIndex == itemCoord.R && x.ColumnIndex == itemCoord.C);
                                    if (itemDiseno != null)
                                        sb.Append(itemDiseno.Texto).Append(", ");
                                }
                            }

                            C_PreguntaXCodigo_Result pre = new C_PreguntaXCodigo_Result();

                            using (EntitiesRusicst BD = new EntitiesRusicst())
                            {
                                pre = BD.C_PreguntaXCodigo(cellName, null).FirstOrDefault();
                            }

                            if (pre != null)
                            {
                                var p = new PreguntaModels()
                                {
                                    IdSeccion = seccion.Id.Value,
                                    Nombre = pre.NombrePregunta,
                                    Ayuda = cellAyuda,
                                    IdTipoPregunta = pre.IdTipoPregunta.Value,
                                    RowIndex = pRow,
                                    ColumnIndex = pCol,
                                    EsMultiple = valEsMultiple,
                                    EsObligatoria = (StringUtils.IsBlank(cellObliga) ? false : cellObliga == "1"),
                                    SoloSi = cellSoloSi,
                                    Texto = sb.ToString()
                                };

                                if (StringUtils.IsNotBlank(cellOpciones))
                                {
                                    var opCoord = new Coordinate(cellOpciones);
                                    if (opCoord.R == -1 && opCoord.R == -1)
                                    {
                                        throw new Exception("Error el valor de la celda opciones (" + cellOpciones + ")");
                                    }
                                    p.OpcionPregunta = new List<OpcionPreguntaModels>();
                                    for (int rOpt = opCoord.R; ; rOpt++)
                                    {
                                        var op = ExcelAppFacade.GetStringValue(sOpc, rOpt + 1, opCoord.C + 1);
                                        if (StringUtils.IsBlank(op))
                                            break;
                                        p.OpcionPregunta.Add(new OpcionPreguntaModels() { Valor = op, Texto = op });
                                    }
                                }

                                seccion.Preguntas.Add(p);
                            }
                            else
                            {
                                //pregunta no existe
                                throw new Exception("Error En La Pregunta con Código ( " + cellName + " ). Por favor verifique y corrija el Archivo");
                            }

                        }
                    }
                }

                //GUARDADO DE DATOS EN LA BD
                using (EntitiesRusicst BD = new EntitiesRusicst())
                {
                    foreach (var diseno in seccion.Disenos)
                    {
                        Resultado = BD.I_DisenoInsert(diseno.IdSeccion, diseno.Texto,
                                                        diseno.ColumnSpan.HasValue ? diseno.ColumnSpan.Value : 0,
                                                        diseno.RowSpan.HasValue ? diseno.RowSpan.Value : 0, diseno.RowIndex, diseno.ColumnIndex).FirstOrDefault();
                    }
                    int idPregunta;
                    foreach (var pregunta in seccion.Preguntas)
                    {
                        Resultado = BD.I_PreguntaEncuestaInsert(pregunta.IdSeccion, pregunta.Nombre, pregunta.RowIndex, pregunta.ColumnIndex, pregunta.IdTipoPregunta.ToString(), pregunta.Ayuda, pregunta.EsObligatoria, pregunta.EsMultiple, pregunta.SoloSi, pregunta.Texto).FirstOrDefault();
                        idPregunta = Resultado.estado.Value;
                        if (pregunta.OpcionPregunta != null)
                        {
                            foreach (var item in pregunta.OpcionPregunta)
                            {
                                Resultado = BD.I_OpcionesInsert(idPregunta, item.Valor).FirstOrDefault();
                            }
                        }
                    }
                    //Resultado = BD.I_OpcionesInsert(p.Id, op).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                ExcelAppFacade.Close(name);
            }
        }

        public static List<DatosPrecargue> ParseExcelPrecargueRespuestas(PrecargueRespuestasModels data)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();
            List<DatosPrecargue> listaprecargue = new List<DatosPrecargue>();
            var name = Guid.NewGuid().ToString();
            try
            {
                Workbook wb = ExcelAppFacade.Load(data.Archivo.ToArray(), name);
                if (wb.Worksheets.Count > 1)
                    throw new Exception("Solo debe tener una hoja con la estructura predefinida");

                var hoja = (Worksheet)wb.Worksheets[1];
                int numFilasHojas = hoja.Rows.Count;
                numFilasHojas = 2;
                for (int i = 2; i <= numFilasHojas; i++)
                {
                    if (ExcelAppFacade.GetStringValue(hoja, i, 1) != "" && ExcelAppFacade.GetStringValue(hoja, i, 1) != null )
                    {                        
                        DatosPrecargue dprecargue = new DatosPrecargue();
                        dprecargue.IdEncuesta = Convert.ToInt32(ExcelAppFacade.GetStringValue(hoja, i, 1));
                        dprecargue.CodigoHomologado = ExcelAppFacade.GetStringValue(hoja, i, 2);
                        dprecargue.Divipola = Convert.ToInt32(ExcelAppFacade.GetStringValue(hoja, i, 3));
                        dprecargue.Valor = ExcelAppFacade.GetStringValue(hoja, i, 4);
                        listaprecargue.Add(dprecargue);
                        numFilasHojas = numFilasHojas + 1;
                    }
                    else
                    {
                        numFilasHojas = i - 2;
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                ExcelAppFacade.Close(name);
            }
            return listaprecargue;
        }

        public static List<DatosPrecargueSeguimientoPAT> ParseExcelPrecargueSeguimientoPAT(PrecargueRespuestasModels data)
        {
            C_AccionesResultado Resultado = new C_AccionesResultado();
            List<DatosPrecargueSeguimientoPAT> listaprecargue = new List<DatosPrecargueSeguimientoPAT>();
            var name = Guid.NewGuid().ToString();
            try
            {
                Workbook wb = ExcelAppFacade.Load(data.Archivo.ToArray(), name);
                if (wb.Worksheets.Count > 1)
                    throw new Exception("Solo debe tener una hoja con la estructura predefinida");

                var hoja = (Worksheet)wb.Worksheets[1];
                int numFilasHojas = hoja.Rows.Count;
                numFilasHojas = 2;
                for (int i = 2; i <= numFilasHojas; i++)
                {
                    if (ExcelAppFacade.GetStringValue(hoja, i, 1) != "" && ExcelAppFacade.GetStringValue(hoja, i, 1) != null)
                    {
                        DatosPrecargueSeguimientoPAT dprecargue = new DatosPrecargueSeguimientoPAT();
                        dprecargue.IdPreguntaPat = Convert.ToInt32(ExcelAppFacade.GetStringValue(hoja, i, 1));
                        dprecargue.IdMunicipio = Convert.ToInt32(ExcelAppFacade.GetStringValue(hoja, i, 2));
                        dprecargue.EntidadNacional = ExcelAppFacade.GetStringValue(hoja, i, 3);
                        try
                        {
                            dprecargue.PlanCompromiso = Convert.ToInt64(ExcelAppFacade.GetStringValue(hoja, i, 4));
                            dprecargue.PlanPresupuesto = Convert.ToDecimal(ExcelAppFacade.GetStringValue(hoja, i, 5));
                            dprecargue.SegCompromiso1 = Convert.ToInt64(ExcelAppFacade.GetStringValue(hoja, i, 6));
                            dprecargue.SegPresupuesto1 = Convert.ToDecimal(ExcelAppFacade.GetStringValue(hoja, i, 7));
                            dprecargue.SegCompromiso2 = Convert.ToInt64(ExcelAppFacade.GetStringValue(hoja, i, 8));
                            dprecargue.SegPresupuesto2 = Convert.ToDecimal(ExcelAppFacade.GetStringValue(hoja, i, 9));
                            dprecargue.Observaciones = ExcelAppFacade.GetStringValue(hoja, i, 10);
                            dprecargue.Programas = ExcelAppFacade.GetStringValue(hoja, i, 11);
                            listaprecargue.Add(dprecargue);
                            numFilasHojas = numFilasHojas + 1;
                        }
                        catch (Exception ex)
                        {
                            throw new Exception("Error en tipo de dato Fila:" + (numFilasHojas-2).ToString());                     
                        }
                    }
                    else
                    {
                        numFilasHojas = i - 2;
                        break;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                ExcelAppFacade.Close(name);
            }
            return listaprecargue;
        }
    }
    public class DatosPrecargue
    {
        public int IdEncuesta { get; set; }
        public string CodigoHomologado { get; set; }
        public int Divipola { get; set; }
        public string Valor { get; set; }
    }

    public class DatosPrecargueSeguimientoPAT
    {
        public int IdPreguntaPat { get; set; }
        public int IdMunicipio { get; set; }
        public string EntidadNacional { get; set; }
        public long PlanCompromiso { get; set; }
        public decimal PlanPresupuesto { get; set; }
        public long SegCompromiso1 { get; set; }
        public decimal SegPresupuesto1 { get; set; }
        public long SegCompromiso2 { get; set; }
        public decimal SegPresupuesto2 { get; set; }
        public string Observaciones { get; set; }
        public string Programas { get; set; }
    }


    public class EncuestasBorrar
    {
        public int IdEncuesta { get; set; }
        #region datos de auditoría

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    public class PreguntaSegActualizar
    {
        public int IdPregunta { get; set; }
        #region datos de auditoría

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <value>The name of the user.</value>
        public string AudUserName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [add ident].
        /// </summary>
        /// <value><c>true</c> if [add ident]; otherwise, <c>false</c>.</value>
        public bool AddIdent { get; set; }

        /// <summary>
        /// Gets or sets the user name add ident.
        /// </summary>
        /// <value>The user name add ident.</value>
        public string UserNameAddIdent { get; set; }

        /// <summary>
        /// Gets or sets a value
        /// Indica que hubo una excepción en la ejecución.
        /// </summary>
        /// <value><c>true</c> if excepcion; otherwise, <c>false</c>.</value>
        public bool Excepcion { get; set; }

        /// <summary>
        /// Gets or sets the mensaje.
        /// Mensaje que captura la excepción.
        /// </summary>
        /// <value>The mensaje.</value>
        public string ExcepcionMensaje { get; set; }

        #endregion
    }

    public class Coordinate
    {
        public int R { get; set; }
        public int C { get; set; }

        public static readonly string CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        public const string CELL_ID_PATTERN = @"\$?([A-Z]+)\$?([1-9][0-9]*)";
        public const string CELL_ID_ERRORS = @"^-[0-9]+$";
        public static readonly Regex CELL_ID_REGEX = new Regex(CELL_ID_PATTERN);
        public static readonly Regex CELL_ID_ERRORS_REGEX = new Regex(CELL_ID_ERRORS);
        public enum CVErrEnum : int
        {
            ErrDiv0 = -2146826281,
            ErrNA = -2146826246,
            ErrName = -2146826259,
            ErrNull = -2146826288,
            ErrNum = -2146826252,
            ErrRef = -2146826265,
            ErrValue = -2146826273
        };

        public Coordinate(int r, int c)
        {
            this.R = r;
            this.C = c;
        }

        public Coordinate(string str)
        {
            var matchError = CELL_ID_ERRORS_REGEX.Match(str);
            if (matchError.Success)
            {
                this.R = -1;
                this.C = -1;
            }
            else
            {
                var match = CELL_ID_REGEX.Match(str);
                if (match.Success == false)
                {
                    throw new Exception(string.Format("El identificador de celda '{0}' no es válido", str));
                }

                var aPart = match.Groups[1].Value;
                var nPart = match.Groups[2].Value;

                var col = 0;
                var pow = 0;
                foreach (var c in aPart.Reverse())
                {
                    int i = CHARS.IndexOf(c);
                    if (i == -1)
                        throw new Exception(string.Format("En el identificador de celda '{0}' no se puede resolver la letra '{1}'", str, c));
                    col += ((int)(Math.Pow(26, pow)) * (i + 1));
                    pow++;
                }
                this.C = col - 1;

                int row = 0;
                if (Int32.TryParse(nPart, out row) == false)
                    throw new Exception(string.Format("En el identificador de celda '{0}' no se puede resolver el número de fila '{1}'", str, nPart));

                if (row == 0)
                    throw new Exception(string.Format("En el identificador de celda '{0}' solo se permiten valores estríctamente mayores a cero", str));
                this.R = row - 1;
            }
        }
    }

    #region Funciones Libreria reactive-commons.ddl

    public static class StringUtils
    {
        public const string PASSWORD_ALLOWED_CHARS = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ0123456789!@$?_-";

        public static string CreateRandomPassword(int passwordLength)
        {
            char[] chArray = new char[passwordLength];
            Random random = new Random();
            for (int index = 0; index < passwordLength; ++index)
                chArray[index] = "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ0123456789!@$?_-"[random.Next(0, "abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ0123456789!@$?_-".Length)];
            return new string(chArray);
        }

        public static string Default(string str, string def)
        {
            if (!StringUtils.IsBlank(str))
                return str;
            return def;
        }

        public static string[] Explode(this string str)
        {
            return str.Explode(',');
        }

        public static string[] Explode(this string str, char delim)
        {
            if (StringUtils.IsBlank(str))
                return new string[0];
            return ((IEnumerable<string>)str.Split(delim)).Select<string, string>((Func<string, string>)(x => x.Trim())).ToArray<string>();
        }

        public static string Implode(this List<string> list)
        {
            return list.ToArray().Implode();
        }

        public static string Implode(this string[] array)
        {
            return array.Implode(int.MaxValue);
        }

        public static string Implode(this List<string> list, int max)
        {
            return list.ToArray().Implode(max);
        }

        public static string Implode(this string[] array, int max)
        {
            if (array == null || array.Length == 0)
                return string.Empty;
            StringBuilder stringBuilder = new StringBuilder(array[0]);
            for (int index = 1; index < array.Length && index < max; ++index)
                stringBuilder.Append(", ").Append(array[index]);
            return stringBuilder.ToString();
        }

        public static bool IsBlank(string str)
        {
            if (str != null)
                return str.Trim().Length == 0;
            return true;
        }

        public static bool IsNotBlank(string str)
        {
            return !StringUtils.IsBlank(str);
        }

        public static string Replace<T>(string text, Map<string, T> map)
        {
            if (text == null)
                return "";
            if (map == null || map.Keys.Count == 0)
                return text;
            string str = text;
            foreach (string key in map.Keys)
            {
                T obj = map[key];
                string newValue = "";
                if ((object)obj != null)
                    newValue = obj.ToString();
                str = str.Replace("{" + key + "}", newValue);
            }
            return str;
        }

        public static string Replace(string text, Dictionary<string, string> dictionary)
        {
            if (text == null)
                return "";
            if (dictionary == null || dictionary.Keys.Count == 0)
                return text;
            string str = text;
            foreach (string key in dictionary.Keys)
                str = str.Replace("{" + key + "}", dictionary[key]);
            return str;
        }
    }

    public class Map<TKEY, TVALUE>
    {
        private Dictionary<TKEY, TVALUE> _dic;

        public TVALUE this[TKEY key]
        {
            get
            {
                return this.Get(key);
            }
            set
            {
                this.Add(key, value);
            }
        }

        public List<TKEY> Keys
        {
            get
            {
                return this._dic.Keys.ToList<TKEY>();
            }
        }

        public List<TVALUE> Values
        {
            get
            {
                return this._dic.Values.ToList<TVALUE>();
            }
        }

        public Map()
        {
            this._dic = new Dictionary<TKEY, TVALUE>();
        }

        public void Add(TKEY key, TVALUE value)
        {
            lock (this._dic)
                this._dic[key] = value;
        }

        public void Clear()
        {
            lock (this._dic)
                this._dic.Clear();
        }

        public bool Constains(TKEY key)
        {
            return this._dic.ContainsKey(key);
        }

        public int Count()
        {
            return this._dic.Count;
        }

        public TVALUE Get(TKEY key)
        {
            if (this._dic.ContainsKey(key))
                return this._dic[key];
            return default(TVALUE);
        }

        public TVALUE Remove(TKEY key)
        {
            lock (this._dic)
            {
                TVALUE local_0 = this[key];
                this._dic.Remove(key);
                return local_0;
            }
        }
    }

    #endregion
}
