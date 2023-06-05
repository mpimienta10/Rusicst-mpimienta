using Newtonsoft.Json;
using RusicstBI.Controls;
using RusicstBI.Extensions;
using RusicstBI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ServiceStack.Text;
using System.Data;
using System.Data.SqlClient;

namespace RusicstBI
{
    public partial class ConsultaRusicstBI : System.Web.UI.Page
    {
        private ConsumirCubo.AdomdConnectorClient connBI;

        public ConsultaRusicstBI()
        {
            connBI = new ConsumirCubo.AdomdConnectorClient();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    String errorServicio = String.Empty;

                    IEnumerable<ModeloDepartamentos> departamentos = JsonConvert.DeserializeObject<IEnumerable<ModeloDepartamentos>>(connBI.ObtenerDepartamentosJSON(ref errorServicio));

                    ddlDepartamentos.DataSource = departamentos;
                    ddlDepartamentos.DataValueField = "CodigoDepartamento";
                    ddlDepartamentos.DataTextField = "NombreDepartamento";
                    ddlDepartamentos.DataBind();
                    ddlDepartamentos.SelectedIndex = 0;

                    IEnumerable<ModeloEncuestas> encuestas = JsonConvert.DeserializeObject<IEnumerable<ModeloEncuestas>>(connBI.ObtenerEncuestasJSON(ref errorServicio));

                    ddlEncuestas.DataSource = encuestas;
                    ddlEncuestas.DataValueField = "CodigoEncuesta";
                    ddlEncuestas.DataTextField = "NombreEncuesta";
                    ddlEncuestas.DataBind();
                    ddlEncuestas.SelectedIndex = 0;

                    IEnumerable<ModeloConsultasPredefinidas> consultasPredefinidas = JsonConvert.DeserializeObject<IEnumerable<ModeloConsultasPredefinidas>>(connBI.ObtenerListadoConsultaPredefinida(ref errorServicio));

                    Session["ConsultasPredefinidas"] = consultasPredefinidas;
                    Session["IdConsultaPredefinida"] = "0";

                    grdConsultaPredefinida.DataSource = consultasPredefinidas;
                    grdConsultaPredefinida.DataBind();
                }
                catch (Exception ex)
                {
                    Mensaje("Error en la página : " + ex.Message.ToString());
                }
            }
        }

        private void Mensaje(string mensajeMostrar)
        {
            string Script = @"<script> alert('" + mensajeMostrar.Replace("'", "") + @"!'); </script>";
            ClientScript.RegisterStartupScript(GetType(), "Alert", Script);
        }

        public string SiteMap()
        {
            return CustomSiteMapPath.CustomSiteMap(System.Web.SiteMap.CurrentNode);
        }

        protected void cmdGenerarDatos_Click(object sender, EventArgs e)
        {
            bool codigoEncuesta = false,
                    codigoEncuestaFila = true,
                    nombreEncuesta = false,
                    nombreEncuestaFila = true,
                    codigoPregunta = false,
                    codigoPreguntaFila = true,
                    nombrePregunta = false,
                    nombrePreguntaFila = true,
                    codigoDepartamento = false,
                    codigoDepartamentoFila = true,
                    nombreDepartamento = false,
                    nombreDepartamentoFila = true,
                    codigoMunicipio = false,
                    codigoMunicipioFila = true,
                    nombreMunicipio = false,
                    nombreMunicipioFila = true,
                    etapaPolitica = false,
                    etapaPoliticaFila = true,
                    seccion = false,
                    seccionFila = true,
                    tema = false,
                    temaFila = true,
                    hechoVictimizante = false,
                    hechoVictimizanteFila = true,
                    dinamicaDesplazamiento = false,
                    dinamicaDesplazamientoFila = true,
                    enfoqueDiferencial = false,
                    enfoqueDiferencialFila = true,
                    factoresRiesgo = false,
                    factoresRiesgoFila = true,
                    rangoEtareo = false,
                    rangoEtareoFila = true,
                    moneda = false,
                    monedaFila = false,
                    numero = false,
                    numeroFila = false,
                    porcentaje = false,
                    porcentajeFila = false,
                    respuestaUnica = false,
                    respuestaUnicaFila = false;

            IEnumerable<CheckBox> parametros = this.ParametrosContainer.FindDescendants<CheckBox>().Where(cb => cb.Checked);
            IEnumerable<CheckBox> valores = this.ValoresContainer.FindDescendants<CheckBox>().Where(cb => cb.Checked);

            if ((parametros.Count() > 0) && (valores.Count() > 0))
            {
                try
                {
                    #region Set selected filters

                    bool dimensionesFilas = false;

                    foreach (var parametro in parametros)
                    {
                        switch (parametro.ID)
                        {
                            case "cbCodigoEncuesta":
                                codigoEncuesta = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Codigo de la Encuesta")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            codigoEncuestaFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbNombreEncuesta":
                                nombreEncuesta = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Nombre de la Encuesta")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            nombreEncuestaFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbCodigoPregunta":
                                codigoPregunta = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Codigo de la Pregunta")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            codigoPreguntaFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbNombrePregunta":
                                nombrePregunta = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Nombre de la Pregunta")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            nombrePreguntaFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbCodigoDepartamento":
                                codigoDepartamento = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Codigo del Departamento")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            codigoDepartamentoFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbNombreDepartamento":
                                nombreDepartamento = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Nombre del Departamento")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            nombreDepartamentoFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbCodigoMunicipio":
                                codigoMunicipio = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Codigo del Municipio")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            codigoMunicipioFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbNombreMunicipio":
                                nombreMunicipio = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Nombre del Municipio")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            nombreMunicipioFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbEtapaPolitica":
                                etapaPolitica = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Etapa Politica")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            etapaPoliticaFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbSeccion":
                                seccion = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Seccion")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            seccionFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbTema":
                                tema = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Tema")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            temaFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbHechoVictimizante":
                                hechoVictimizante = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Hecho Victimizante")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            hechoVictimizanteFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbDinamicaDesplazamiento":
                                dinamicaDesplazamiento = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Dinamica del Desplazamiento")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            dinamicaDesplazamientoFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbEnfoqueDiferencial":
                                enfoqueDiferencial = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Enfoque Diferencial")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            codigoEncuestaFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbFactoresRiesgo":
                                factoresRiesgo = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Factores de Riesgo")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            factoresRiesgoFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;
                            case "cbRangoEtareo":
                                rangoEtareo = true;

                                foreach (GridViewRow gvr in grdUbicacion.Rows)
                                {
                                    if (gvr.Cells[0].Text == "Rango Etareo")
                                    {
                                        if ((gvr.FindControl("ddlUbicacion") as DropDownList).Text == "Columnas")
                                        {
                                            rangoEtareoFila = false;
                                        }
                                        else
                                        {
                                            dimensionesFilas = true;
                                        }
                                    }
                                }

                                break;

                        }
                    }

                    if (grdUbicacion.Rows.Count == 0)
                    {
                        dimensionesFilas = true;
                    }

                    int cantidadHechos = 0;
                    string nombreHechos = string.Empty;

                    foreach (var valor in valores)
                    {
                        switch (valor.ID)
                        {
                            case "cbMoneda":
                                moneda = true;
                                nombreHechos = "Moneda";
                                ++cantidadHechos;
                                break;
                            case "cbNumero":
                                numero = true;
                                nombreHechos = "Número";
                                ++cantidadHechos;
                                break;
                            case "cbPorcentaje":
                                porcentaje = true;
                                nombreHechos = "Porcentaje";
                                ++cantidadHechos;
                                break;
                            case "cbRespuestaUnica":
                                respuestaUnica = true;
                                nombreHechos = "Respuesta Unica";
                                ++cantidadHechos;
                                break;
                        }
                    }
                    #endregion

                    if (dimensionesFilas == false)
                    {
                        Mensaje("Al menos una dimensión debe estar en Filas");
                    }
                    else
                    {
                        if (cantidadHechos > 1)
                        {
                            Mensaje("Solo puede tener una medida por consulta.");
                        }
                        else
                        {
                            string errorServicio = string.Empty;

                            Session["encuesta"] = ddlEncuestas.SelectedValue.ToString();
                            Session["preguntas"] = tbPreguntas.Text;

                            DataTable dtResultados = connBI.ConsultasPersonalizadasRusicstJSON(codigoEncuesta, codigoEncuestaFila, nombreEncuesta, nombreEncuestaFila, codigoPregunta, codigoPreguntaFila, nombrePregunta, nombrePreguntaFila, codigoDepartamento, codigoDepartamentoFila, nombreDepartamento, nombreDepartamentoFila,
                                codigoMunicipio, codigoMunicipioFila, nombreMunicipio, nombreMunicipioFila, etapaPolitica, etapaPoliticaFila, seccion, seccionFila, tema, temaFila, hechoVictimizante, hechoVictimizanteFila, dinamicaDesplazamiento, dinamicaDesplazamientoFila, enfoqueDiferencial, enfoqueDiferencialFila, factoresRiesgo, factoresRiesgoFila, rangoEtareo, rangoEtareoFila, moneda, monedaFila, numero, numeroFila, porcentaje, porcentajeFila, respuestaUnica, respuestaUnicaFila, ddlEncuestas.SelectedValue.ToString(), ddlDepartamentos.SelectedValue.ToString(), ddlMunicipios.SelectedIndex == -1 ? "-1" : ddlMunicipios.SelectedValue.ToString(), tbPreguntas.Text, ref errorServicio);

                            if (errorServicio.Equals(string.Empty))
                            {
                                if (dtResultados.Rows.Count != 0)
                                {
                                    if (grdResultados.Columns.Count != 0)
                                    {
                                        for (int i = grdResultados.Columns.Count - 1; i >= 1; --i)
                                        {
                                            grdResultados.Columns.RemoveAt(i);
                                        }
                                    }

                                    int columnDouble = 0;

                                    for (int i = 0; i < dtResultados.Columns.Count; ++i)
                                    {
                                        if (dtResultados.Columns[i].DataType.Name.ToString() == "Double")
                                        {
                                            ++columnDouble;
                                        }
                                    }

                                    for (int i = 0; i < dtResultados.Columns.Count; ++i)
                                    {
                                        BoundField bfield = new BoundField();
                                        bfield.HeaderText = dtResultados.Columns[i].ColumnName;
                                        bfield.DataField = dtResultados.Columns[i].ColumnName;

                                        if (dtResultados.Columns[i].DataType.Name.ToString() == "Double")
                                        {
                                            bfield.DataFormatString = "{0:N0}";
                                        }

                                        grdResultados.Columns.Add(bfield);
                                    }

                                    Session["columnDouble"] = columnDouble;
                                    Session["ResultadosRusicst"] = dtResultados;
                                    Session["nombreHechos"] = nombreHechos;

                                    grdResultados.DataSource = dtResultados;
                                    grdResultados.DataBind();

                                    DataTable dt = new DataTable("FiltrosBIRusicst");

                                    dt.Columns.Add("CodigoFiltro", typeof(string));
                                    dt.Columns.Add("NombreFiltro", typeof(string));

                                    DataTable dtRejillaUbicacion = new DataTable("RejillaUbicacionBIRusicst");

                                    dtRejillaUbicacion.Columns.Add("Componente", typeof(string));
                                    dtRejillaUbicacion.Columns.Add("Ubicacion", typeof(string));

                                    #region Set columns visibility

                                    if (codigoEncuesta == true)
                                    {
                                        dt.Rows.Add("0", "Codigo de la Encuesta");

                                        if (codigoEncuestaFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Codigo de la Encuesta", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Codigo de la Encuesta", "Columnas");
                                        }
                                    }

                                    if (nombreEncuesta == true)
                                    {
                                        dt.Rows.Add("1", "Nombre de la Encuesta");

                                        if (nombreEncuestaFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Nombre de la Encuesta", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Nombre de la Encuesta", "Columnas");
                                        }
                                    }


                                    if (codigoPregunta == true)
                                    {
                                        dt.Rows.Add("2", "Codigo de la Pregunta");

                                        if (codigoPreguntaFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Codigo de la Pregunta", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Codigo de la Pregunta", "Columnas");
                                        }
                                    }

                                    if (nombrePregunta == true)
                                    {
                                        dt.Rows.Add("3", "Nombre de la Pregunta");

                                        if (nombrePreguntaFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Nombre de la Pregunta", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Nombre de la Pregunta", "Columnas");
                                        }
                                    }

                                    if (codigoDepartamento == true)
                                    {
                                        dt.Rows.Add("4", "Codigo del Departamento");

                                        if (codigoDepartamentoFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Codigo del Departamento", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Codigo del Departamento", "Columnas");
                                        }
                                    }

                                    if (nombreDepartamento == true)
                                    {
                                        dt.Rows.Add("5", "Nombre del Departamento");

                                        if (nombreDepartamentoFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Nombre del Departamento", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Nombre del Departamento", "Columnas");
                                        }
                                    }

                                    if (codigoMunicipio == true)
                                    {
                                        dt.Rows.Add("6", "Codigo del Municipio");

                                        if (codigoMunicipioFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Codigo del Municipio", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Codigo del Municipio", "Columnas");
                                        }
                                    }

                                    if (nombreMunicipio == true)
                                    {
                                        dt.Rows.Add("7", "Nombre del Municipio");

                                        if (nombreMunicipioFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Nombre del Municipio", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Nombre del Municipio", "Columnas");
                                        }
                                    }

                                    if (etapaPolitica == true)
                                    {
                                        dt.Rows.Add("8", "Etapa Politica");

                                        if (etapaPoliticaFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Etapa Politica", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Etapa Politica", "Columnas");
                                        }
                                    }

                                    if (seccion == true)
                                    {
                                        dt.Rows.Add("9", "Seccion");

                                        if (seccionFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Seccion", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Seccion", "Columnas");
                                        }
                                    }

                                    if (tema == true)
                                    {
                                        dt.Rows.Add("10", "Tema");

                                        if (temaFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Tema", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Tema", "Columnas");
                                        }
                                    }

                                    if (hechoVictimizante == true)
                                    {
                                        dt.Rows.Add("11", "Hecho Victimizante");

                                        if (hechoVictimizanteFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Hecho Victimizante", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Hecho Victimizante", "Columnas");
                                        }
                                    }

                                    if (dinamicaDesplazamiento == true)
                                    {
                                        dt.Rows.Add("12", "Dinamica del Desplazamiento");

                                        if (dinamicaDesplazamientoFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Dinamica del Desplazamiento", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Dinamica del Desplazamiento", "Columnas");
                                        }
                                    }

                                    if (enfoqueDiferencial == true)
                                    {
                                        dt.Rows.Add("13", "Enfoque Diferencial");

                                        if (enfoqueDiferencialFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Enfoque Diferencial", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Enfoque Diferencial", "Columnas");
                                        }
                                    }

                                    if (factoresRiesgo == true)
                                    {
                                        dt.Rows.Add("14", "Factores de Riesgo");

                                        if (factoresRiesgoFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Factores de Riesgo", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Factores de Riesgo", "Columnas");
                                        }
                                    }

                                    if (rangoEtareo == true)
                                    {
                                        dt.Rows.Add("15", "Rango Etareo");

                                        if (rangoEtareoFila == true)
                                        {
                                            dtRejillaUbicacion.Rows.Add("Rango Etareo", "Filas");
                                        }
                                        else
                                        {
                                            dtRejillaUbicacion.Rows.Add("Rango Etareo", "Columnas");
                                        }
                                    }


                                    grdUbicacion.DataSource = dtRejillaUbicacion;
                                    grdUbicacion.DataBind();

                                    #endregion

                                }
                                else
                                {
                                    Session["ResultadosRusicst"] = null;

                                    grdResultados.DataSource = null;
                                    //grdResultados.DataBind();

                                    Mensaje("No se encontró información con los parámetros utilizados, por favor cambie los parametros y realice una nueva busqueda.");
                                }
                            }
                            else
                            {
                                Session["ResultadosRusicst"] = null;

                                grdResultados.DataSource = null;
                                //grdResultados.DataBind();

                                Mensaje(errorServicio);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    Mensaje("Existen problemas presentando la información - Error : " + ex.Message.ToString());
                }
            }
            else
            {
                Mensaje("Debe escoger al menos una dimensión y una medida.");
            }
        }

        protected void grdResultados_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                grdResultados.PageIndex = e.NewPageIndex;
                grdResultados.DataSource = (DataTable)Session["ResultadosRusicst"];
                grdResultados.DataBind();
            }
            catch (Exception exc)
            {
                Mensaje("Existen problemas cambiando de página - Error : " + exc.Message.ToString());
            }
        }

        //protected void grdResultados_Sorting(object sender, GridViewSortEventArgs e)
        //{
        //    try
        //    {
        //        List<ModeloConsultasPersonalizadas> consulta = (List<ModeloConsultasPersonalizadas>)Session["ResultadosRusicst"];

        //        if (consulta != null)
        //        {
        //            SortDirection nextDir = SortDirection.Ascending;
        //            if (ViewState["sort"] != null && ViewState["sort"].ToString() == e.SortExpression)
        //            {
        //                nextDir = SortDirection.Descending;
        //                ViewState["sort"] = null;
        //            }
        //            else
        //            {
        //                ViewState["sort"] = e.SortExpression;
        //            }
        //            var sortParam = typeof(ModeloConsultasPersonalizadas).GetProperty(e.SortExpression);

        //            if (nextDir.Equals(SortDirection.Ascending))
        //            {
        //                consulta = consulta.OrderBy(c => sortParam.GetValue(c, null)).ToList();
        //            }
        //            else
        //            {
        //                consulta = consulta.OrderByDescending(c => sortParam.GetValue(c, null)).ToList();
        //            }

        //            Session["ResultadosRusicst"] = consulta;

        //            grdResultados.DataSource = consulta;
        //            grdResultados.DataBind();
        //        }
        //    }
        //    catch(Exception exc)
        //    {
        //        Mensaje("Existen problemas ordenando la información - Error : " + exc.Message.ToString());
        //    }
        //}

        protected void grdAll_DataBound(object sender, EventArgs e)
        {
            ((GridView)sender).HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        protected void cmdExportarXLS_Click(object sender, EventArgs e)
        {
            try
            {
                DataTable dt = (DataTable)Session["ResultadosRusicst"];

                ExportToExcel(dt);
            }
            catch (Exception exc)
            {
                Mensaje("Existen problemas exportando la información a Excel - Error : " + exc.Message.ToString());
            }

        }

        protected void cmdExportarJSON_Click(object sender, EventArgs e)
        {
            try
            {
                DataTable dt = (DataTable)Session["ResultadosRusicst"];

                ExportToJSON(dt);
            }
            catch (Exception exc)
            {
                Mensaje("Existen problemas exportando la información a JSON - Error : " + exc.Message.ToString());
            }

        }

        private void ExportToExcel(DataTable dt)
        {
            if (dt != null && dt.Rows.Count > 0)
            {
                string filename = "ConsultasBIRusicst.xls";

                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/vnd.ms-excel";
                Response.AppendHeader("Content-Disposition", "attachment; filename=" + filename + "");
                Response.ContentEncoding = System.Text.Encoding.Default;
                Response.Charset = "utf-8";

                System.Globalization.CultureInfo culture = new System.Globalization.CultureInfo("es-CO");
                System.IO.StringWriter tw = new System.IO.StringWriter(culture);
                System.Web.UI.HtmlTextWriter hw = new System.Web.UI.HtmlTextWriter(tw);

                DataGrid dgGrid = new DataGrid();
                dgGrid.DataSource = dt;
                dgGrid.DataBind();
                dgGrid.RenderControl(hw);

                Response.Write(tw.ToString());
                this.EnableViewState = false;
                Response.End();
            }
        }

        private void ExportToJSON(DataTable dt)
        {
            if (dt != null && dt.Rows.Count > 0)
            {
                string filename = "ConsultasBIRusicst.json";

                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/json";
                Response.AppendHeader("Content-Disposition", "attachment; filename=" + filename + "");
                Response.ContentEncoding = System.Text.Encoding.Default;
                Response.Charset = "utf-8";

                string json = JsonConvert.SerializeObject(dt, Newtonsoft.Json.Formatting.Indented);

                Response.Write(json);
                this.EnableViewState = false;
                Response.End();
            }
        }

        protected void ddlDepartamentos_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarMunicipios();
        }

        protected void grdPreguntas_Sorting(object sender, GridViewSortEventArgs e)
        {

            try
            {
                List<ModeloPreguntas> consulta = (List<ModeloPreguntas>)Session["ResultadosPreguntas"];

                if (consulta != null)
                {
                    SortDirection nextDir = SortDirection.Ascending;
                    if (ViewState["sort"] != null && ViewState["sort"].ToString() == e.SortExpression)
                    {
                        nextDir = SortDirection.Descending;
                        ViewState["sort"] = null;
                    }
                    else
                    {
                        ViewState["sort"] = e.SortExpression;
                    }
                    var sortParam = typeof(ModeloPreguntas).GetProperty(e.SortExpression);

                    if (nextDir.Equals(SortDirection.Ascending))
                    {
                        consulta = consulta.OrderBy(c => sortParam.GetValue(c, null)).ToList();
                    }
                    else
                    {
                        consulta = consulta.OrderByDescending(c => sortParam.GetValue(c, null)).ToList();
                    }

                    Session["ResultadosPreguntas"] = consulta;

                    grdPreguntas.DataSource = consulta;
                    grdPreguntas.DataBind();
                }
            }
            catch(Exception exc)
            {
                Mensaje("Existen problemas ordenando la información - Error : " + exc.Message.ToString());
            }
        }

        protected void grdPreguntas_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                grdPreguntas.PageIndex = e.NewPageIndex;
                grdPreguntas.DataSource = (List<ModeloPreguntas>)Session["ResultadosPreguntas"];
                grdPreguntas.DataBind();
            }
            catch (Exception exc)
            {
                Mensaje("Existen problemas cambiando de página - Error : " + exc.Message.ToString());
            }

        }

        protected void cmdBuscarPreguntas_Click(object sender, EventArgs e)
        {
            
            try 
            {
                string errorServicio = string.Empty;

                string json = connBI.ObtenerPreguntasPorCodigoJSON(ddlEncuestas.SelectedValue.ToString(), tbFiltroPreguntas.Text.Replace("\"", ""), ref errorServicio);

                if (errorServicio.Equals(string.Empty))
                {
                    List<ModeloPreguntas> consulta = JsonConvert.DeserializeObject<List<ModeloPreguntas>>(json);

                    if (consulta.Count != 0)
                    {
                        Session["ResultadosPreguntas"] = consulta;

                        grdPreguntas.DataSource = consulta;
                        grdPreguntas.DataBind();
                    }
                }
                else
                {
                    Mensaje(errorServicio);
                }
 
            }
            catch (Exception ex)
            {
                Mensaje("Error : "+ ex.Message.ToString());
            }

        }

        protected void cmdSeleccionar_Click(object sender, EventArgs e)
        {
            tbPreguntas.Text = String.Empty;

            DataTable tb = new DataTable("Preguntas");

            tb.Columns.Add("CodigoPregunta", typeof(string));
            tb.Columns.Add("NombrePregunta", typeof(string));

            foreach (GridViewRow row in grdPreguntas.Rows)
            {
                CheckBox ck = ((CheckBox)row.FindControl("ckSeleccionar"));

                if (ck.Checked)
                {
                    if (tbPreguntas.Text == String.Empty)
                    {
                        tbPreguntas.Text = row.Cells[1].Text;
                    }
                    else
                    {
                        tbPreguntas.Text = tbPreguntas.Text + "," + row.Cells[1].Text;
                    }

                    tb.Rows.Add(row.Cells[1].Text, row.Cells[2].Text);
                }
            }

            if (tb != null)
            {
                grdFiltroPreguntas.DataSource = tb;
                grdFiltroPreguntas.DataBind();
            }

            if (tbPreguntas.Text != String.Empty)
            {
                string errorServicio = string.Empty;
                bool hechoMoneda = false,
                    hechoNumero = false,
                    hechoPorcentaje = false,
                    hechoRespuestaUnica = false,
                    dimensionEtapaPolitica = false,
                    dimensionSeccion = false,
                    dimensionTema = false,
                    dimensionHechoVictimizante = false,
                    dimensionDinamicaDesplazamiento = false,
                    dimensionEnfoqueDiferencial = false,
                    dimensionFactoresRiesgo = false,
                    dimensionRangoEtareo = false;


                connBI.ObtenerDimensionesHechosPorPregunta(tbPreguntas.Text, ref hechoMoneda, ref hechoNumero, ref hechoPorcentaje, ref hechoRespuestaUnica, ref dimensionEtapaPolitica, ref dimensionSeccion, ref dimensionTema, ref dimensionHechoVictimizante, ref dimensionDinamicaDesplazamiento,  ref dimensionEnfoqueDiferencial, ref dimensionFactoresRiesgo, ref dimensionRangoEtareo , ref errorServicio);

                if (hechoMoneda == false)
                {
                    cbMoneda.Checked = false;
                }
                else
                {
                    cbMoneda.Checked = true;
                }

                if (hechoNumero == false)
                {
                    cbNumero.Checked = false;
                }
                else
                {
                    cbNumero.Checked = true;
                }

                if (hechoPorcentaje == false)
                {
                    cbPorcentaje.Checked = false;
                }
                else
                {
                    cbPorcentaje.Checked = true;
                }

                if (hechoRespuestaUnica == false)
                {
                    cbRespuestaUnica.Checked = false;
                }
                else
                {
                    cbRespuestaUnica.Checked = true;
                }

                if (dimensionEtapaPolitica == false)
                {
                    cbEtapaPolitica.Checked = false;
                }
                else
                {
                    cbEtapaPolitica.Checked = true;
                }

                if (dimensionSeccion == false)
                {
                    cbSeccion.Checked = false;
                }
                else
                {
                    cbSeccion.Checked = true;
                }

                if (dimensionTema == false)
                {
                    cbTema.Checked = false;
                }
                else
                {
                    cbTema.Checked = true;
                }

                if (dimensionHechoVictimizante == false)
                {
                    cbHechoVictimizante.Checked = false;
                }
                else
                {
                    cbHechoVictimizante.Checked = true;
                }

                if (dimensionDinamicaDesplazamiento == false)
                {
                    cbDinamicaDesplazamiento.Checked = false;
                }
                else
                {
                    cbDinamicaDesplazamiento.Checked = true;
                }

                if (dimensionEnfoqueDiferencial == false)
                {
                    cbEnfoqueDiferencial.Checked = false;
                }
                else
                {
                    cbEnfoqueDiferencial.Checked = true;
                }

                if (dimensionFactoresRiesgo == false)
                {
                    cbFactoresRiesgo.Checked = false;
                }
                else
                {
                    cbFactoresRiesgo.Checked = true;
                }

                if (dimensionRangoEtareo == false)
                {
                    cbRangoEtareo.Checked = false;
                }
                else
                {
                    cbRangoEtareo.Checked = true;
                }
            }

        }

        protected void cmdBuscarNombre_Click(object sender, EventArgs e)
        {

            try
            {
                string errorServicio = string.Empty;

                string json = connBI.ObtenerPreguntasPorNombreJSON(ddlEncuestas.SelectedValue.ToString(), tbFiltroPreguntas.Text, ref errorServicio);

                if (errorServicio.Equals(string.Empty))
                {
                    List<ModeloPreguntas> consulta = JsonConvert.DeserializeObject<List<ModeloPreguntas>>(json);

                    if (consulta.Count != 0)
                    {
                        Session["ResultadosPreguntas"] = consulta;

                        grdPreguntas.DataSource = consulta;
                        grdPreguntas.DataBind();
                    }
                }
                else
                {
                    Mensaje(errorServicio);
                }

            }
            catch (Exception ex)
            {
                Mensaje("Error : " + ex.Message.ToString());
            }

        }

        protected void grdConsultaPredefinida_Sorting(object sender, GridViewSortEventArgs e)
        {

            try
            {
                List<ModeloConsultasPredefinidas> consulta = (List<ModeloConsultasPredefinidas>)Session["ConsultasPredefinidas"];

                if (consulta != null)
                {
                    SortDirection nextDir = SortDirection.Ascending;
                    if (ViewState["sort"] != null && ViewState["sort"].ToString() == e.SortExpression)
                    {
                        nextDir = SortDirection.Descending;
                        ViewState["sort"] = null;
                    }
                    else
                    {
                        ViewState["sort"] = e.SortExpression;
                    }
                    var sortParam = typeof(ModeloConsultasPredefinidas).GetProperty(e.SortExpression);

                    if (nextDir.Equals(SortDirection.Ascending))
                    {
                        consulta = consulta.OrderBy(c => sortParam.GetValue(c, null)).ToList();
                    }
                    else
                    {
                        consulta = consulta.OrderByDescending(c => sortParam.GetValue(c, null)).ToList();
                    }

                    Session["ConsultasPredefinidas"] = consulta;

                    grdConsultaPredefinida.DataSource = consulta;
                    grdConsultaPredefinida.DataBind();
                }
            }
            catch (Exception exc)
            {
                Mensaje("Existen problemas ordenando la información - Error : " + exc.Message.ToString());
            }

        }

        protected void grdConsultaPredefinida_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {

            try
            {
                grdConsultaPredefinida.PageIndex = e.NewPageIndex;
                grdConsultaPredefinida.DataSource = (List<ModeloConsultasPredefinidas>)Session["ConsultasPredefinidas"];
                grdConsultaPredefinida.DataBind();
            }
            catch (Exception exc)
            {
                Mensaje("Existen problemas cambiando de página - Error : " + exc.Message.ToString());
            }

        }

        protected void grdConsultaPredefinida_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "SeleccionarConsultaPredefinida")
            {
                ddlEncuestas.SelectedIndex = -1;
                ddlDepartamentos.SelectedIndex = -1;
                ddlMunicipios.SelectedIndex = -1;

                tbPreguntas.Text = String.Empty;

                cbCodigoEncuesta.Checked = false;
                cbNombreEncuesta.Checked = false;
                cbCodigoPregunta.Checked = false;
                cbNombrePregunta.Checked = false;
                cbCodigoDepartamento.Checked = false;
                cbNombreDepartamento.Checked = false;
                cbCodigoMunicipio.Checked = false;
                cbNombreMunicipio.Checked = false;
                cbEtapaPolitica.Checked = false;
                cbSeccion.Checked = false;
                cbTema.Checked = false;
                cbHechoVictimizante.Checked = false;
                cbDinamicaDesplazamiento.Checked = false;
                cbEnfoqueDiferencial.Checked = false;
                cbFactoresRiesgo.Checked = false;
                cbRangoEtareo.Checked = false;

                cbMoneda.Checked = false;
                cbNumero.Checked = false;
                cbPorcentaje.Checked = false;
                cbRespuestaUnica.Checked = false;

                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = grdConsultaPredefinida.Rows[index];

                int idConsultaPredefinida = Convert.ToInt32(row.Cells[0].Text);
                String nombreConsultaPredefinida = String.Empty;
                String descripcionConsultaPredefinida = String.Empty;

                Session["IdConsultaPredefinida"] = idConsultaPredefinida.ToString();

                try
                {
                    string errorServicio = string.Empty;
                    string json = String.Empty;

                    String codigoPreguntas = String.Empty;
                    String codigoEncuesta = String.Empty;
                    String codigoDepartamento = String.Empty;
                    String codigoMunicipio = String.Empty;

                    connBI.ObtenerInformacionConsultaPredefinida(idConsultaPredefinida, ref nombreConsultaPredefinida, ref descripcionConsultaPredefinida, ref codigoPreguntas, ref codigoEncuesta, ref codigoDepartamento, ref codigoMunicipio, ref errorServicio);

                    if (errorServicio.Equals(string.Empty))
                    {
                        ddlEncuestas.SelectedValue = codigoEncuesta;
                        ddlDepartamentos.SelectedValue = codigoDepartamento;
                        CargarMunicipios();
                        ddlMunicipios.SelectedValue = codigoMunicipio;
                        tbPreguntas.Text = codigoPreguntas;

                        Session["NombreConsultaPredefinida"] = nombreConsultaPredefinida;
                        Session["DescripcionConsultaPredefinida"] = descripcionConsultaPredefinida;

                        tbNombreConsulta.Text = nombreConsultaPredefinida;
                        tbDescripcionConsulta.Text = descripcionConsultaPredefinida;

                        json = connBI.ObtenerControlesDimensionesConsultaPredefinida(idConsultaPredefinida, ref errorServicio);

                        if (errorServicio.Equals(string.Empty))
                        {
                            List<ModeloControles> consultaDimensiones = JsonConvert.DeserializeObject<List<ModeloControles>>(json);

                            if (consultaDimensiones != null)
                            {
                                if (consultaDimensiones.Count != 0)
                                {
                                    DataTable dtRejillaUbicacion = new DataTable("RejillaUbicacionBIRusicst");

                                    dtRejillaUbicacion.Columns.Add("Componente", typeof(string));
                                    dtRejillaUbicacion.Columns.Add("Ubicacion", typeof(string));

                                    foreach (ModeloControles dimension in consultaDimensiones)
                                    {
                                        ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("content");

                                        if (cph != null)
                                        {
                                            CheckBox controlDimension = (CheckBox)cph.FindControl(dimension.Control);
                                            if (controlDimension != null)
                                            {
                                                controlDimension.Checked = true;
                                            }
                                        }

                                        dtRejillaUbicacion.Rows.Add(dimension.Nombre, dimension.Ubicacion);

                                    }

                                    Session["RejillaUbicacion"] = dtRejillaUbicacion;

                                    grdUbicacion.DataSource = dtRejillaUbicacion;
                                    grdUbicacion.DataBind();
                                }
                            }
                        }

                        json = connBI.ObtenerControlesHechosConsultaPredefinida(idConsultaPredefinida, ref errorServicio);

                        if (errorServicio.Equals(string.Empty))
                        {
                            List<ModeloControles> consultaHechos = JsonConvert.DeserializeObject<List<ModeloControles>>(json);

                            if (consultaHechos != null)
                            {
                                if (consultaHechos.Count != 0)
                                {
                                    ContentPlaceHolder cph = (ContentPlaceHolder)this.Master.FindControl("content");

                                    if (cph != null)
                                    {
                                        foreach (ModeloControles hecho in consultaHechos)
                                        {
                                            CheckBox controlHecho = (CheckBox)cph.FindControl(hecho.Control);
                                            if (controlHecho != null)
                                            {
                                                controlHecho.Checked = true;
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        json = connBI.ObtenerPreguntasPorConsultaPredefinidaJSON(idConsultaPredefinida, ref errorServicio);

                        if (errorServicio.Equals(string.Empty))
                        {
                            List<ModeloPreguntas> consultaPreguntas = JsonConvert.DeserializeObject<List<ModeloPreguntas>>(json);

                            if (consultaPreguntas != null)
                            {
                                if (consultaPreguntas.Count != 0)
                                {
                                    Session["RejillaFiltroPreguntas"] = consultaPreguntas;

                                    grdFiltroPreguntas.DataSource = consultaPreguntas;
                                    grdFiltroPreguntas.DataBind();
                                }
                            }
                        }
                    }
                    else
                    {
                        Mensaje(errorServicio);
                    }

                }
                catch (Exception ex)
                {
                    Mensaje("Error : " + ex.Message.ToString());
                }

            }

        }

        protected void cmdLimpiar_Click(object sender, EventArgs e)
        {

            ddlEncuestas.SelectedIndex = -1;
            ddlDepartamentos.SelectedIndex = -1;
            ddlMunicipios.SelectedIndex = -1;

            tbPreguntas.Text = String.Empty;

            cbCodigoEncuesta.Checked = false;
            cbNombreEncuesta.Checked = false;
            cbCodigoPregunta.Checked = false;
            cbNombrePregunta.Checked = false;
            cbCodigoDepartamento.Checked = false;
            cbNombreDepartamento.Checked = false;
            cbCodigoMunicipio.Checked = false;
            cbNombreMunicipio.Checked = false;
            cbEtapaPolitica.Checked = false;
            cbSeccion.Checked = false;
            cbTema.Checked = false;
            cbHechoVictimizante.Checked = false;
            cbDinamicaDesplazamiento.Checked = false;
            cbEnfoqueDiferencial.Checked = false;
            cbFactoresRiesgo.Checked = false;
            cbRangoEtareo.Checked = false;

            cbMoneda.Checked = false;
            cbNumero.Checked = false;
            cbPorcentaje.Checked = false;
            cbRespuestaUnica.Checked = false;

            grdResultados.DataSource = null;
      
        }

        protected void cmdGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                String codigoPreguntas = tbPreguntas.Text;
                String codigoEncuesta = ddlEncuestas.SelectedValue.ToString();
                String codigoDepartamento = ddlDepartamentos.SelectedValue.ToString();
                String codigoMunicipio = ddlMunicipios.SelectedIndex == -1 ? "-1" : ddlMunicipios.SelectedValue.ToString();
                int idConsultaPredefinida = Convert.ToInt32(Session["IdConsultaPredefinida"].ToString());
                int idConsultaPredefinidaSalida = 0;
                String errorServicio = String.Empty;

                if (tbNombreConsulta.Text.Trim() == String.Empty || tbDescripcionConsulta.Text.Trim() == string.Empty)
                {
                    Mensaje("La consulta predefinida debe tener nombre o descripción.");
                }
                else
                { 
                    connBI.PersistirConsultaPredefinida(idConsultaPredefinida, tbNombreConsulta.Text, tbDescripcionConsulta.Text, codigoPreguntas, codigoEncuesta, codigoDepartamento, codigoMunicipio, ref idConsultaPredefinidaSalida, ref errorServicio);

                    if (errorServicio == String.Empty)
                    {
                        connBI.LimpiarConsultaPredefinida(idConsultaPredefinidaSalida, ref errorServicio);

                        List<CheckBox> allControls = new List<CheckBox>();
                        GetControlList<CheckBox>(Page.Controls, allControls);

                        foreach (CheckBox ck in allControls)
                        {
                            if (ck.Checked)
                            {
                                connBI.PersistirDimensionHechoConsultaPrefefinida(idConsultaPredefinidaSalida, ck.ID, ref errorServicio);
                            }
                        }

                        foreach (GridViewRow gvr in grdUbicacion.Rows)
                        {
                            connBI.PersistirUbicacionConsultaPrefefinida(idConsultaPredefinidaSalida, gvr.Cells[0].Text, (gvr.FindControl("ddlUbicacion") as DropDownList).Text, ref errorServicio);
                        }

                        foreach (GridViewRow gvr in grdFiltroPreguntas.Rows)
                        {
                            connBI.PersistirPreguntaConsultaPrefefinida(idConsultaPredefinidaSalida, gvr.Cells[0].Text, ref errorServicio);
                        }

                        IEnumerable<ModeloConsultasPredefinidas> consultasPredefinidas = JsonConvert.DeserializeObject<IEnumerable<ModeloConsultasPredefinidas>>(connBI.ObtenerListadoConsultaPredefinida(ref errorServicio));

                        Session["ConsultasPredefinidas"] = consultasPredefinidas;
                        Session["IdConsultaPredefinida"] = idConsultaPredefinidaSalida.ToString();
                        Session["NombreConsultaPredefinida"] = tbNombreConsulta.Text;
                        Session["DescripcionConsultaPredefinida"] = tbDescripcionConsulta.Text;

                        grdConsultaPredefinida.DataSource = consultasPredefinidas;
                        grdConsultaPredefinida.DataBind();

                        Mensaje("Se guardo la consulta predefinida.");
                    }
                    else
                    {
                        Mensaje("Error : " + errorServicio);
                    }
                }
            }
            catch (Exception ex)
            {
                Mensaje("Error : " + ex.Message.ToString());
            }
        }

        private void GetControlList<T>(ControlCollection controlCollection, List<T> resultCollection)
        where T : Control
        {
            foreach (Control control in controlCollection)
            {
                //if (control.GetType() == typeof(T))
                if (control is T) // This is cleaner
                    resultCollection.Add((T)control);

                if (control.HasControls())
                    GetControlList(control.Controls, resultCollection);
            }
        }

        private void CargarMunicipios()
        {
            try
            {
                if (ddlDepartamentos.SelectedIndex != -1 && ddlDepartamentos.SelectedValue.ToString() != "-1")
                {
                    String errorServicio = String.Empty;
                    connBI = new ConsumirCubo.AdomdConnectorClient();

                    IEnumerable<ModeloMunicipios> municipios = JsonConvert.DeserializeObject<IEnumerable<ModeloMunicipios>>(connBI.ObtenerMunicipiosJSON(ddlDepartamentos.SelectedValue.ToString(), ref errorServicio));

                    ddlMunicipios.DataSource = municipios;
                    ddlMunicipios.DataValueField = "CodigoMunicipio";
                    ddlMunicipios.DataTextField = "NombreMunicipio";
                    ddlMunicipios.DataBind();
                    ddlMunicipios.SelectedIndex = 0;
                }
                else
                {
                    ddlMunicipios.Items.Clear();
                    ddlMunicipios.DataSource = null;
                    ddlMunicipios.DataBind();
                }
            }
            catch (Exception exc)
            {
                Mensaje("Existen problemas buscando información de los municipios - Error : " + exc.Message.ToString());
            }

        }

        protected void cmdOrganizar_Click(object sender, EventArgs e)
        {

        }

        protected void grdUbicacion_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                //Find the DropDownList in the Row
                DropDownList ddlUbicacion = (e.Row.FindControl("ddlUbicacion") as DropDownList);

                DataTable dtUbicacion = new DataTable("UbicacionBIRusicst");

                dtUbicacion.Columns.Add("Ubicacion", typeof(string));

                dtUbicacion.Rows.Add("Filas");
                dtUbicacion.Rows.Add("Columnas");

                ddlUbicacion.DataValueField = "Ubicacion";
                ddlUbicacion.DataTextField = "Ubicacion";
                ddlUbicacion.DataSource = dtUbicacion;
                ddlUbicacion.DataBind();

                //Add Default Item in the DropDownList
                //ddlUbicacion.Items.Insert(0, new ListItem("Seleccione ..."));

                //Select the Country of Customer in DropDownList
                string ubicacion = (e.Row.FindControl("lblUbicacion") as Label).Text;
                ddlUbicacion.Items.FindByValue(ubicacion).Selected = true;
            }
        }

        protected void cmdGraficas_Click(object sender, EventArgs e)
        {
            if (Session["ResultadosRusicst"] != null)
            {
                String EjeX = String.Empty;
                String NombreGrafica = String.Empty;
                DataTable dtResultadosRusicst = (DataTable)Session["ResultadosRusicst"];

                DataTable dtDatosGrafica = new DataTable("DatosGrafica");

                dtDatosGrafica.Columns.Add("Item", typeof(string));
                dtDatosGrafica.Columns.Add("Valor", typeof(double));

                if ((int)Session["columnDouble"] == 1)
                {
                    foreach(DataRow drResultadosRusicst in dtResultadosRusicst.Rows)
                    {
                        String item = String.Empty;
                        Double valor = 0;

                        for(int columna = 0; columna < dtResultadosRusicst.Columns.Count; ++columna)
                        {
                            if (dtResultadosRusicst.Columns[columna].DataType.Name.ToString() == "String")
                            {
                                if (item != String.Empty) item = item + " - ";

                                item = item + drResultadosRusicst[columna].ToString();
                            }

                            if (dtResultadosRusicst.Columns[columna].DataType.Name.ToString() == "Double")
                            {
                                valor = Convert.ToDouble(drResultadosRusicst[columna].ToString());
                            }
                        }

                        DataRow drDatosGrafica = dtDatosGrafica.NewRow();

                        drDatosGrafica[0] = item;
                        drDatosGrafica[1] = valor;

                        dtDatosGrafica.Rows.Add(drDatosGrafica);
                    }

                    if (dtDatosGrafica.Rows.Count > 35)
                    {
                        Mensaje("Existen muchos datos para dibujar en la gráfica, por favor afinar la busqueda");
                    }
                    else
                    {
                        for (int columna = 0; columna < dtResultadosRusicst.Columns.Count; ++columna)
                        {
                            if (dtResultadosRusicst.Columns[columna].DataType.Name.ToString() == "String")
                            {
                                if (EjeX != String.Empty)
                                {
                                    EjeX = EjeX + " - ";
                                }

                                EjeX = EjeX + dtResultadosRusicst.Columns[columna].ColumnName.ToString();
                            }
                        }

                        Session["DatosGrafica"] = dtDatosGrafica;
                        Session["FiltroEncuesta"] = ddlEncuestas.SelectedItem.Text;
                        Session["FiltroDepartamento"] = ddlDepartamentos.SelectedItem.Text;
                        Session["FiltroMunicipio"] = ddlMunicipios.SelectedIndex != -1 ? ddlMunicipios.SelectedItem.Text : "TODOS";
                        Session["EjeX"] = EjeX;

                        if (Session["NombreConsultaPredefinida"] != null)
                        {
                            Session["NombreGrafica"] = Session["NombreConsultaPredefinida"];
                        }
                        else
                        {
                            Session["NombreGrafica"] = EjeX;
                        }

                        Response.Redirect("~/GraficasUnificadas.aspx");
                    }
                }
                else
                {
                    int cantidadFilasSeleccionadas = 0;
                    int filaSeleccionada = 0;

                    foreach (GridViewRow row in grdResultados.Rows)
                    {
                        CheckBox ck = ((CheckBox)row.FindControl("ckSeleccionarFiltro"));

                        if (ck.Checked)
                        {
                            ++cantidadFilasSeleccionadas;
                            filaSeleccionada = row.RowIndex;
                        }
                    }

                    if (cantidadFilasSeleccionadas == 0)
                    {
                        Mensaje("Debe seleccionar al menos un registro.");
                    }

                    if (cantidadFilasSeleccionadas > 1)
                    {
                        Mensaje("Debe seleccionar solo un registro.");
                    }

                    if (cantidadFilasSeleccionadas == 1)
                    {
                        String item = String.Empty;
                        Double valor = 0;

                        for (int columna = 0; columna < dtResultadosRusicst.Columns.Count; ++columna)
                        {
                            if (dtResultadosRusicst.Columns[columna].DataType.Name.ToString() == "Double")
                            {
                                item = dtResultadosRusicst.Columns[columna].ColumnName;
                                valor = Convert.ToDouble(dtResultadosRusicst.Rows[filaSeleccionada][columna]);

                                DataRow drDatosGrafica = dtDatosGrafica.NewRow();

                                drDatosGrafica[0] = item;
                                drDatosGrafica[1] = valor;

                                dtDatosGrafica.Rows.Add(drDatosGrafica);
                            }

                        }

                        if (dtDatosGrafica.Columns.Count > 35)
                        {
                            Mensaje("Existen muchos datos para dibujar en la gráfica, por favor afinar la busqueda");
                        }
                        else
                        {
                            for (int columna = 0; columna < dtResultadosRusicst.Columns.Count; ++columna)
                            {
                                if (dtResultadosRusicst.Columns[columna].DataType.Name.ToString() == "String")
                                {
                                    if (EjeX != String.Empty)
                                    {
                                        EjeX = EjeX + " - ";
                                    }

                                    EjeX = EjeX + dtResultadosRusicst.Columns[columna].ColumnName.ToString();

                                    if (NombreGrafica != String.Empty)
                                    {
                                        NombreGrafica = NombreGrafica + " - ";
                                    }

                                    NombreGrafica = NombreGrafica + dtResultadosRusicst.Rows[filaSeleccionada][columna].ToString();
                                }
                            }

                            Session["DatosGrafica"] = dtDatosGrafica;
                            Session["FiltroEncuesta"] = ddlEncuestas.SelectedItem.Text;
                            Session["FiltroDepartamento"] = ddlDepartamentos.SelectedItem.Text;
                            Session["FiltroMunicipio"] = ddlMunicipios.SelectedIndex != -1 ? ddlMunicipios.SelectedItem.Text : "TODOS";
                            Session["EjeX"] = EjeX;

                            if (Session["NombreConsultaPredefinida"] != null)
                            {
                                Session["NombreGrafica"] = Session["NombreConsultaPredefinida"];
                            }
                            else
                            {
                                Session["NombreGrafica"] = NombreGrafica;
                            }

                            Response.Redirect("~/GraficasUnificadas.aspx");
                        }
                    }
                }
            }
            else
            {
                Mensaje("No ha ejecutado ninguna consulta.");
            }
        }

        protected void cmdMapa_Click(object sender, EventArgs e)
        {
            if (Session["ResultadosRusicst"] != null)
            {
                Response.Redirect("~/RusicstDepartamento.aspx");
            }
            else
            {
                Mensaje("No ha ejecutado ninguna consulta.");
            }
        }

        protected void grdFiltroPreguntas_Sorting(object sender, GridViewSortEventArgs e)
        {
            try
            {
                List<ModeloPreguntas> consulta = (List<ModeloPreguntas>)Session["RejillaFiltroPreguntas"];

                if (consulta != null)
                {
                    SortDirection nextDir = SortDirection.Ascending;
                    if (ViewState["sort"] != null && ViewState["sort"].ToString() == e.SortExpression)
                    {
                        nextDir = SortDirection.Descending;
                        ViewState["sort"] = null;
                    }
                    else
                    {
                        ViewState["sort"] = e.SortExpression;
                    }
                    var sortParam = typeof(ModeloPreguntas).GetProperty(e.SortExpression);

                    if (nextDir.Equals(SortDirection.Ascending))
                    {
                        consulta = consulta.OrderBy(c => sortParam.GetValue(c, null)).ToList();
                    }
                    else
                    {
                        consulta = consulta.OrderByDescending(c => sortParam.GetValue(c, null)).ToList();
                    }

                    Session["RejillaFiltroPreguntas"] = consulta;

                    grdFiltroPreguntas.DataSource = consulta;
                    grdFiltroPreguntas.DataBind();
                }
            }
            catch (Exception exc)
            {
                Mensaje("Existen problemas ordenando la información - Error : " + exc.Message.ToString());
            }

        }

        protected void grdFiltroPreguntas_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                grdFiltroPreguntas.PageIndex = e.NewPageIndex;
                grdFiltroPreguntas.DataSource = (List<ModeloPreguntas>)Session["RejillaFiltroPreguntas"];
                grdFiltroPreguntas.DataBind();
            }
            catch (Exception exc)
            {
                Mensaje("Existen problemas cambiando de página - Error : " + exc.Message.ToString());
            }
        }

        public string ActiveTab
        {
            get
            {
                object viewState = this.ViewState["ActiveTab"];
                return (viewState == null) ? "basicos" : (string)viewState;
            }
            set { this.ViewState["ActiveTab"] = value; }
        }

        public string GoToTabbedPane
        {
            get
            {
                object viewState = this.ViewState["GoToTabbedPane"];
                return (viewState == null) ? "false" : (string)viewState;
            }
            set { this.ViewState["GoToTabbedPane"] = value; }
        }

        protected void grdUbicacion_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                grdUbicacion.PageIndex = e.NewPageIndex;
                grdUbicacion.DataSource = (DataTable)Session["RejillaUbicacion"];
                grdUbicacion.DataBind();
            }
            catch (Exception exc)
            {
                Mensaje("Existen problemas cambiando de página - Error : " + exc.Message.ToString());
            }
        }
    }
}