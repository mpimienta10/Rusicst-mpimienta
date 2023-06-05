using Newtonsoft.Json;
using RusicstBI.Controls;
using RusicstBI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Globalization;
using System.Threading;

namespace RusicstBI
{
    public partial class RusicstDepartamento : System.Web.UI.Page
    {
        private ConsumirCubo.AdomdConnectorClient conn;

        public RusicstDepartamento()
        {
            conn = new ConsumirCubo.AdomdConnectorClient();
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                try
                {
                    IEnumerable<DepartamentosListaModel> departamentosLista = JsonConvert.DeserializeObject<IEnumerable<DepartamentosListaModel>>(conn.ObtenerListaDepartamentosJSON());

                    ddlDepartamentos.DataSource = departamentosLista;
                    ddlDepartamentos.DataValueField = "CodigoDepartamento";
                    ddlDepartamentos.DataTextField = "NombreDepartamento";
                    ddlDepartamentos.DataBind();
                    ddlDepartamentos.SelectedValue = "0";

                    string errorServicio = string.Empty;

                    var jsonDepartamentos = conn.ConsultaDepartamentosRusicstJSON(Session["nombreHechos"].ToString(), Session["encuesta"].ToString(), Session["preguntas"].ToString(), ref errorServicio);

                    if (errorServicio.Equals(string.Empty))
                    {
                        IEnumerable<DepartamentoModel> departamentos = JsonConvert.DeserializeObject<IEnumerable<DepartamentoModel>>(jsonDepartamentos);

                        #region Assign path ids
                        foreach (var departamento in departamentos)
                        {
                            switch (departamento.Departamento)
                            {
                                case "Amazonas":
                                    departamento.Id = "Amazonas";
                                    break;
                                case "Antioquia":
                                    departamento.Id = "Antioquia";
                                    break;
                                case "Arauca":
                                    departamento.Id = "Arauca";
                                    break;
                                case "Atlántico":
                                    departamento.Id = "Atlántico";
                                    break;
                                case "Bogotá, D.C.":
                                    departamento.Id = "Bogotá_D.C.";
                                    break;
                                case "Bolívar":
                                    departamento.Id = "Bolivar";
                                    break;
                                case "Boyacá":
                                    departamento.Id = "Boyacá";
                                    break;
                                case "Caldas":
                                    departamento.Id = "Caldas";
                                    break;
                                case "Caquetá":
                                    departamento.Id = "Caquetá";
                                    break;
                                case "Casanare":
                                    departamento.Id = "Casanare";
                                    break;
                                case "Cauca":
                                    departamento.Id = "Cauca";
                                    break;
                                case "Cesar":
                                    departamento.Id = "Cesar";
                                    break;
                                case "Chocó":
                                    departamento.Id = "Choco";
                                    break;
                                case "Córdoba":
                                    departamento.Id = "Córdoba";
                                    break;
                                case "Cundinamarca":
                                    departamento.Id = "Cundinamarca";
                                    break;
                                case "Guainía":
                                    departamento.Id = "Guainía";
                                    break;
                                case "La Guajira":
                                    departamento.Id = "La_Guajira";
                                    break;
                                case "Guaviare":
                                    departamento.Id = "Guaviare";
                                    break;
                                case "Huila":
                                    departamento.Id = "Huila";
                                    break;
                                case "Magdalena":
                                    departamento.Id = "Magdalena";
                                    break;
                                case "Meta":
                                    departamento.Id = "Meta";
                                    break;
                                case "Nariño":
                                    departamento.Id = "Nariño";
                                    break;
                                case "Norte de Santander":
                                    departamento.Id = "Norte_de_Santander";
                                    break;
                                case "Putumayo":
                                    departamento.Id = "Putumayo";
                                    break;
                                case "Quindio":
                                    departamento.Id = "Quindío";
                                    break;
                                case "Risaralda":
                                    departamento.Id = "Risaralda";
                                    break;
                                case "Archipiélago de San Andrés":
                                    departamento.Id = "San_Andrés_y_Providencia";
                                    break;
                                case "Santander":
                                    departamento.Id = "Santander";
                                    break;
                                case "Sucre":
                                    departamento.Id = "Sucre";
                                    break;
                                case "Tolima":
                                    departamento.Id = "Tolima";
                                    break;
                                case "Valle del Cauca":
                                    departamento.Id = "Valle_del_Cauca";
                                    break;
                                case "Vaupés":
                                    departamento.Id = "Vaupes";
                                    break;
                                case "Vichada":
                                    departamento.Id = "Vichada";
                                    break;
                            }
                        }
                        #endregion

                        errorServicio = string.Empty;

                        var jsonEncuestas = conn.ConsultaDepartamentosEncuestasRusicstJSON(Session["nombreHechos"].ToString(), Session["encuesta"].ToString(), Session["preguntas"].ToString(), ref errorServicio);

                        if (errorServicio.Equals(string.Empty))
                        {
                            IEnumerable<EncuestaDepartamento> encuestas = JsonConvert.DeserializeObject<IEnumerable<EncuestaDepartamento>>(jsonEncuestas);

                            List<string> dptoElements = new List<string>();

                            foreach (var encuesta in encuestas.GroupBy(s => s.Departamento))
                            {
                                int numeroEncuestas = encuesta.Count<EncuestaDepartamento>();
                                DepartamentoModel dpto = departamentos.Where(d => d.Departamento.Equals(encuesta.Key)).FirstOrDefault();
                                dpto.Valor = numeroEncuestas;

                                if (dpto != null)
                                {
                                    var chartData = string.Concat(string.Join(", ", encuesta.Select(d => string.Format(@"['{0}', {1}]", d.Encuesta, d.Valor)).ToArray()));
                                    dptoElements.Add(string.Concat("{'Id': '", dpto.Id, "', 'Data': [", chartData, "]}"));
                                }
                            }

                            ChartData = string.Concat("[", string.Join(", ", dptoElements), "]");
                        }
                        Departamentos = (JsonConvert.SerializeObject(departamentos));
                    }
                    else
                    {
                        Departamentos = "[]";
                        ChartData = "[]";

                        Mensaje(errorServicio);
                    }


                }
                catch (Exception ex)
                {
                    Mensaje("Error en la página : " + ex.Message.ToString());
                }
            }
        }

        public string SiteMap()
        {
            return CustomSiteMapPath.CustomSiteMap(System.Web.SiteMap.CurrentNode);
        }

        private void Mensaje(string mensajeMostrar)
        {
            string Script = @"<script> alert('" + mensajeMostrar.Replace("'", "") + @"!'); </script>";
            ClientScript.RegisterStartupScript(GetType(), "Alert", Script);
        }

        public string Departamentos
        {
            get
            {
                object viewState = this.ViewState["Departamentos"];

                return (viewState == null) ? string.Empty : (string)viewState;
            }
            set { this.ViewState["Departamentos"] = value; }
        }

        public string DepartamentosDetalle
        {
            get
            {
                object viewState = this.ViewState["DepartamentosDetalle"];

                return (viewState == null) ? string.Empty : (string)viewState;
            }
            set { this.ViewState["DepartamentosDetalle"] = value; }
        }


        public string ChartData
        {
            get
            {
                object viewState = this.ViewState["ChartData"];

                return (viewState == null) ? string.Empty : (string)viewState;
            }
            set { this.ViewState["ChartData"] = value; }
        }

        public string ChartDataDetalle
        {
            get
            {
                object viewState = this.ViewState["ChartDataDetalle"];

                return (viewState == null) ? string.Empty : (string)viewState;
            }
            set { this.ViewState["ChartDataDetalle"] = value; }
        }

    }
}