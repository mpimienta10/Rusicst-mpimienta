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
    public partial class RusicstMunicipio : System.Web.UI.Page
    {
        private ConsumirCubo.AdomdConnectorClient conn;

        public RusicstMunicipio()
        {
            conn = new ConsumirCubo.AdomdConnectorClient();
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Page.IsPostBack)
            {
                try
                {
                    string departamentoFiltro = string.Empty;
                    string errorServicio = string.Empty;

                    if (Request.QueryString.ToString() != String.Empty)
                    {
                        departamentoFiltro = Request.QueryString["Departamento"];
                        Session["Departamento"] = departamentoFiltro;
                    }
                    else
                    {
                        departamentoFiltro = Session["Departamento"].ToString();
                    }

                    litDepartamento.Text = departamentoFiltro;

                    IEnumerable<MunicipiosListaModel> municipiosLista = JsonConvert.DeserializeObject<IEnumerable<MunicipiosListaModel>>(conn.ObtenerMunicipiosPorDepartamentoJSON(departamentoFiltro, ref errorServicio));

                    ddlMunicipios.DataSource = municipiosLista;
                    ddlMunicipios.DataValueField = "CodigoMunicipio";
                    ddlMunicipios.DataTextField = "NombreMunicipio";
                    ddlMunicipios.DataBind();
                    ddlMunicipios.SelectedValue = "0";

                    var jsonMunicipios = conn.ConsultaMunicipioRusicstJSON(departamentoFiltro, Session["nombreHechos"].ToString(), Session["encuesta"].ToString(), Session["preguntas"].ToString(), ref errorServicio);

                    if (errorServicio.Equals(string.Empty))
                    {

                        IEnumerable<MunicipioModel> municipios = JsonConvert.DeserializeObject<IEnumerable<MunicipioModel>>(jsonMunicipios);

                        errorServicio = string.Empty;

                        var jsonEncuestas = conn.ConsultaMunicipioEncuestaRusicstJSON(departamentoFiltro, Session["nombreHechos"].ToString(), Session["encuesta"].ToString(), Session["preguntas"].ToString(), ref errorServicio);

                        if (errorServicio.Equals(string.Empty))
                        {
                            IEnumerable<EncuestaMunicipioModel> encuestas = JsonConvert.DeserializeObject<IEnumerable<EncuestaMunicipioModel>>(jsonEncuestas);

                            List<string> munElements = new List<string>();

                            foreach (var encuesta in encuestas.GroupBy(s => s.CodigoMunicipio))
                            {
                                int numeroEncuestas = encuesta.Count<EncuestaMunicipioModel>();
                                MunicipioModel mun = municipios.Where(d => d.CodigoMunicipio.Equals(encuesta.Key)).FirstOrDefault();
                                mun.Valor = numeroEncuestas;

                                if (mun != null)
                                {
                                    //var chartData = string.Concat(string.Join(", ", mes.OrderByDescending(d => d.ValorGirosSGP).Take(9).Select(d => string.Format(@"['{0}', {1}]", d.Mes, Convert.ToInt32(d.ValorGirosSGP / 1000000))).ToArray()), ", ['Otros Temas', ", Convert.ToInt32(mes.OrderBy(d => d.ValorGirosSGP).Skip(9).Sum(d => d.ValorGirosSGP) / 1000000), "]");

                                    var chartData = string.Concat(string.Join(", ", encuesta.Select(d => string.Format(@"['{0}', {1}]", d.Encuesta, d.Valor)).ToArray()));
                                    munElements.Add(string.Concat("{'Id': '", mun.CodigoMunicipio, "', 'Data': [", chartData, "]}"));
                                }
                            }

                            ChartData = string.Concat("[", string.Join(", ", munElements), "]");
                        }

                        Municipios = (JsonConvert.SerializeObject(municipios));
                    }
                    else
                    {
                        Municipios = "[]";
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

        public string Municipios
        {
            get
            {
                object viewState = this.ViewState["Municipios"];

                return (viewState == null) ? string.Empty : (string)viewState;
            }
            set 
            { 
                this.ViewState["Municipios"] = value; 
            }
        }

        public string ChartData
        {
            get
            {
                object viewState = this.ViewState["ChartData"];

                return (viewState == null) ? string.Empty : (string)viewState;
            }
            set 
            { 
                this.ViewState["ChartData"] = value; 
            }
        }

        public string MapaMunicipios
        {
            get
            {
                object viewState = this.ViewState["MapaMunicipios"];

                return (viewState == null) ? string.Empty : (string)viewState;
            }
            set 
            { 
                this.ViewState["MapaMunicipios"] = value; 
            }
        }

    }
}