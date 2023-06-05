using Newtonsoft.Json;
using RusicstBI.Controls;
using RusicstBI.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

using System.Globalization;
using System.Threading;

namespace RusicstBI
{
    public partial class GraficasUnificadas : System.Web.UI.Page
    {
        private ConsumirCubo.AdomdConnectorClient connBI;

        public GraficasUnificadas()
        {
            connBI = new ConsumirCubo.AdomdConnectorClient();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                try
                {
                    String datos = String.Empty;
                    string json = string.Empty;

                    litNombreGrafica.Text = Session["NombreGrafica"].ToString();
                    litEncuesta.Text = Session["FiltroEncuesta"].ToString();
                    litDepartamento.Text = Session["FiltroDepartamento"].ToString();
                    litMunicipio.Text = Session["FiltroMunicipio"].ToString();

                    String errorServicio = String.Empty;

                    IEnumerable<ModeloTiposGrafica> tiposGrafica = JsonConvert.DeserializeObject<IEnumerable<ModeloTiposGrafica>>(connBI.ObtenerTiposGraficaJSON());

                    ddlTiposGrafica.DataSource = tiposGrafica;
                    ddlTiposGrafica.DataValueField = "CodigoTipoGrafica";
                    ddlTiposGrafica.DataTextField = "NombreTipoGrafica";
                    ddlTiposGrafica.DataBind();
                    ddlTiposGrafica.SelectedIndex = 0;

                    NombreEje = Session["EjeX"].ToString();

                    DataTable dt = (DataTable)Session["DatosGrafica"];

                    foreach(DataRow dr in dt.Rows)
                    {
                        String etiqueta = String.Empty;
                        String item = String.Empty;

                        item = "['" + dr[0].ToString() + "', " + dr[1].ToString() + "]";

                        if (datos != String.Empty)
                        {
                            datos = datos + ", ";
                        }

                        datos = datos + item;
                    }

                    datos = "[" + datos + "]";

                    DatosRejilla = datos;
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

        protected void grdAll_DataBound(object sender, EventArgs e)
        {
            ((GridView)sender).HeaderRow.TableSection = TableRowSection.TableHeader;
        }

        public string SiteMap()
        {
            return CustomSiteMapPath.CustomSiteMap(System.Web.SiteMap.CurrentNode);
        }

        #region Charts data
        public string DatosRejilla
        {
            get
            {
                object viewState = this.ViewState["DatosRejilla"];
                return (viewState == null) ? string.Empty : (string)viewState;
            }
            set { this.ViewState["DatosRejilla"] = value; }
        }

        public string NombreEje
        {
            get
            {
                object viewState = this.ViewState["NombreEje"];
                return (viewState == null) ? string.Empty : (string)viewState;
            }
            set { this.ViewState["NombreEje"] = value; }
        }

        #endregion    
    }
}