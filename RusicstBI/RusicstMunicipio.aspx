<%@ Page Title="Mapa de Regionalización por Municipio" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RusicstMunicipio.aspx.cs" Inherits="RusicstBI.RusicstMunicipio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <webopt:BundleReference runat="server" Path="~/Content/charts" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="content" runat="server">
    <div class="breadcrumb-wrapper">
        <div class="container">
            <%= SiteMap() %>
        </div>
    </div>
    <!-- End navigation breadcrumbs -->

    <div class="jumbotron">
        <div class="container">
            <div class="row">
                <h2><asp:Literal runat="server" Text="Mapa Municipio"/></h2>
                <ol class="filter">
                    <li></li>
                    <li><span><asp:Literal runat="server" Text="Departamento :"/><asp:Literal ID="litDepartamento" runat="server"></asp:Literal></span></li>
                </ol>
            </div>
            <br />
            <div class="row">
                <div class="col-sm-3">

                </div>
                <div class="col-sm-2">
                    <asp:Label AssociatedControlID="ddlMunicipios" runat="server" CssClass="control-label"><asp:Literal runat="server" Text="Municipios" /></asp:Label>
                </div>
                <div class="col-sm-4">
                    <asp:DropDownList ID="ddlMunicipios" runat="server" CssClass="form-control" data-toggle="tooltip" onchange="if (seleccionarMunicipio()) return false;"/>
                </div>
            </div>
        </div>
    </div>

    <section id="region" data-speed="2" data-type="background">
        <div class="region-wrapper">
            <div class="container">
                <div class="row">
                    <div class="col-xs-2 col-xs-offset-10 col-md-2 col-md-offset-10">
                        <!-- modal window-->
                        <button type="button" class="btn-info2" data-toggle="modal" data-target=".modal-info2"></button>
                        <div class="modal fade modal-info2" tabindex="-1" role="dialog" aria-labelledby="Ayuda mapa">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                        <h4 class="modal-title" id="myModalLabel"><asp:Literal runat="server" Text=""/></h4>
                                    </div>
                                    <div class="modal-body">
                                        <p>
                                            <asp:Literal runat="server" Text=""/>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--Map-->
                <div id="map-pte"></div>
                <!--modal para grafica-->
                <div class="modal fade modal-graph" tabindex="-1" role="dialog" aria-labelledby="Ayuda mapa">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close"></button>
                                <h4 style="text-indent: 5em;" class="modal-title" id="myGraphsLabel">Título</h4>
                            </div>
                            <div class="modal-body">
                                <h2 class="title-medium-section"><asp:Literal runat="server" Text="Municipios"/></h2>
                                <div id="chartMunicipios" class="graph"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="bg-success">
            <div class="container">
                <p class="center-block"><asp:Literal runat="server" Text="Rusist"/></p>
            </div>
        </div>
    </section>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <%: Scripts.Render("~/bundles/bootstrap") %>
    <%: Scripts.Render("~/bundles/charts") %>
    <%: Scripts.Render("~/bundles/map") %>

    <script type="text/javascript">
        $(document).ready(function(){
            $('[data-toggle="tooltip"]').tooltip({ placement : 'bottom' });
        });
    </script>

    <script type="text/javascript">
        function seleccionarMunicipio() {
            var listaMunicipios = document.getElementById('<%: ddlMunicipios.ClientID %>');
            var opcionMunicipio = listaMunicipios.options[listaMunicipios.selectedIndex].value;

            if (opcionMunicipio == "0")
            {
                return true;
            }
            else 
            {
                var municipios = <%= this.Municipios %>;
                var dataMunicipios = <%= this.ChartData %>;
                var chartData;

                //alert(corregida);
                var mun = municipios.filter(function(d) { return d.CodigoMunicipio == opcionMunicipio; })[0];

                cartData = null;
                chartData = dataMunicipios.filter(function(d) { return d.Id == opcionMunicipio; })[0];

                var labelGrafica = document.getElementById('myGraphsLabel');
                labelGrafica.innerText = "Municipio : " + mun.NombreMunicipio;

                $('.modal-graph').modal('show');

                $('.modal-graph').on('shown.bs.modal', function () {
                    if(chartData != null) {
                        $('#chartMunicipios').jqChart({
                            title: { text: '' },
                            animation: { duration: 1 },
                            shadows: {
                                enabled: false
                            },
                            border: {
                                cornerRadius: 0,
                                lineWidth: 1,
                                strokeStyle: '#e1e8ea'
                            },
                            axes: [{
                                location: 'bottom',
                                labels: { 
                                    fillStyle: '#8d9395',
                                    font: '12px sans-serif',
                                    angle:-180 },
                            }],
                            labels:	{
                                textFillStyle: '#0e6275',
                            },
                            watermark: {
                                text: 'Rusicst',
                                fillStyle: '#d7dbdd',
                                font: '10px Roboto',
                                hAlign: 'right',
                                vAlign: 'bottom'
                            },
                            legend: {
                                visible: true,
                                location : 'right',
                                allowHideSeries: true,
                                border: {
                                    lineWidth: 0,
                                    strokeStyle: ''
                                },
                                font: '12px Roboto',
                                textFillStyle: '#0e6275',
                                background: '',
                                margin: 20
                            },
                            series: [
                                {
                                    type: 'column',
                                    title: '<asp:Literal runat="server" Text="Dimensión"/>',
                                    fillStyle: '#fe8c86',
                                    data: chartData.Data,
                                }
                            ]
                        });

                        $('#chartMunicipios').bind('tooltipFormat', function (e, data) {
                            return "<b>" + data.x + "</b><br />" +
                                   data.series.title + " : " + data.y.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1,") + "<br />";
                        });
                    }
                });
            }
        }
    </script>


    <script type="text/javascript">
        function getParameterByName(name, url) {
            if (!url) {
                url = window.location.href;
            }
            name = name.replace(/[\[\]]/g, "\\$&");
            var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
                results = regex.exec(url);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, " "));
        }

        var sessionDepartamento = '<%=Session["Departamento"]%>'

        var departamentoFiltro = getParameterByName('Departamento');
        if (departamentoFiltro == null)
        {
            departamentoFiltro = sessionDepartamento;
        }

        var mapaMunicipio = "";

        switch (departamentoFiltro)
        {
            case "Amazonas":
                mapaMunicipios = "assets/libs/map/Colombia_Amazonas_Leticia.svg";
                break;
            case "Antioquia":
                mapaMunicipios = "assets/libs/map/Colombia_Antioquia_Medellin.svg";
                break;
            case "Arauca":
                mapaMunicipios = "assets/libs/map/Colombia_Arauca_Arauca.svg";
                break;
            case "Atlántico":
                mapaMunicipios = "assets/libs/map/Colombia_Atlantico_Barranquilla.svg";
                break;
            case "Bogotá, D.C.":
                mapaMunicipios = "assets/libs/map/Colombia_Bogota_Bogota.svg";
                break;
            case "Bolívar":
                mapaMunicipios = "assets/libs/map/Colombia_Bolivar_Cartagena.svg";
                break;
            case "Boyacá":
                mapaMunicipios = "assets/libs/map/Colombia_Boyaca_Tunja.svg";
                break;
            case "Caldas":
                mapaMunicipios = "assets/libs/map/Colombia_Caldas_Manizales.svg";
                break;
            case "Caquetá":
                mapaMunicipios = "assets/libs/map/Colombia_Caqueta_Florencia.svg";
                break;
            case "Casanare":
                mapaMunicipios = "assets/libs/map/Colombia_Casanare_Yopal.svg";
                break;
            case "Cauca":
                mapaMunicipios = "assets/libs/map/Colombia_Cauca_Popayan.svg";
                break;
            case "Cesar":
                mapaMunicipios = "assets/libs/map/Colombia_Cesar_Valledupar.svg";
                break;
            case "Chocó":
                mapaMunicipios = "assets/libs/map/Colombia_Choco_Quibdo.svg";
                break;
            case "Córdoba":
                mapaMunicipios = "assets/libs/map/Colombia_Cordoba_Monteria.svg";
                break;
            case "Cundinamarca":
                mapaMunicipios = "assets/libs/map/Colombia_Cundinamarca_Bogota.svg";
                break;
            case "Guainía":
                mapaMunicipios = "assets/libs/map/Colombia_Guainia_Inirida.svg";
                break;
            case "La Guajira":
                mapaMunicipios = "assets/libs/map/Colombia_LaGuajira_Riohacha.svg";
                break;
            case "Guaviare":
                mapaMunicipios = "assets/libs/map/Colombia_Guaviare_SanJoseDelGuaviare.svg";
                break;
            case "Huila":
                mapaMunicipios = "assets/libs/map/Colombia_Huila_Neiva.svg";
                break;
            case "Magdalena":
                mapaMunicipios = "assets/libs/map/Colombia_Magdalena_SantaMarta.svg";
                break;
            case "Meta":
                mapaMunicipios = "assets/libs/map/Colombia_Meta_Villavicencio.svg";
                break;
            case "Nariño":
                mapaMunicipios = "assets/libs/map/Colombia_Narino_Pasto.svg";
                break;
            case "Norte de Santander":
                mapaMunicipios = "assets/libs/map/Colombia_NorteDeSantander_Cucuta.svg";
                break;
            case "Putumayo":
                mapaMunicipios = "assets/libs/map/Colombia_Putumayo_Mocoa.svg";
                break;
            case "Quindio":
                mapaMunicipios = "assets/libs/map/Colombia_Quindio_Armenia.svg";
                break;
            case "Risaralda":
                mapaMunicipios = "assets/libs/map/Colombia_Risaralda_Pereira.svg";
                break;
            case "Archipiélago de San Andrés":
                mapaMunicipios = "assets/libs/map/Colombia_SanAndres_y_Providencia.svg";
                break;
            case "Santander":
                mapaMunicipios = "assets/libs/map/Colombia_Santander_Bucaramanga.svg";
                break;
            case "Sucre":
                mapaMunicipios = "assets/libs/map/Colombia_Sucre_Sincelejo.svg";
                break;
            case "Tolima":
                mapaMunicipios = "assets/libs/map/Colombia_Tolima_Ibague.svg";
                break;
            case "Valle del Cauca":
                mapaMunicipios = "assets/libs/map/Colombia_ValleCauca_SantiagoCali.svg";
                break;
            case "Vaupés":
                mapaMunicipios = "assets/libs/map/Colombia_Vaupes_Mitu.svg";
                break;
            case "Vichada":
                mapaMunicipios = "assets/libs/map/Colombia_Vichada_PuertoCarreno.svg";
                break;
        }


        var municipios = <%= this.Municipios %>;
        var dataMunicipios = <%= this.ChartData %>;
        var chartData;

        $(document).ready(function () {
            $(".btn_close").click(function () {
                $(".tooltip-pte").toggle("fast")
            });
        });

        $('#map-pte').mapSvg(
            {
                source: mapaMunicipios,
                loadingText: 'Cargando mapa...',
                colors:
                {
                    //base: "#b5d8de",
                    background: "transparent",
                    selected: "#0e6275",
                    hover: "#0e6275",
                    //disabled: "#ffffff"
                    //stroke: "#fff"
                },
                cursor: 'pointer',
                width: 700,
                onClick: function (e, m) {
                    var itemId = this.node.id.replace("_1_", "").replace("_2_", "");
                    var invertida = itemId.split('').reverse().join('');
                    var corregida = invertida.substring(0,5).split('').reverse().join('');
                    //alert(corregida);
                    var mun = municipios.filter(function(d) { return d.CodigoMunicipio == corregida; })[0];
                    if(mun != null) {
                        m.showPopover(e, '<h4>Municipio: ' + mun.NombreMunicipio + '</h4><p>Número de Encuestas : </p><span class="value">' + mun.Valor.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1.") + '</span><a href="#"><asp:Literal runat="server" Text="Ver"/></a>');

                        $('.map_popover_content').click(function() {
                            var labelGrafica = document.getElementById('myGraphsLabel');
                            labelGrafica.innerText = "Municipio : " + mun.NombreMunicipio;

                            $('.modal-graph').modal('show');
                        });
                    }
                    cartData = null;
                    chartData = dataMunicipios.filter(function(d) { return d.Id == corregida; })[0];
                },
                tooltipsMode: 'names',
                zoom: 0,
                pan: 0,
                responsive: 1,
                zoomLimit: [-100, 100],
                popover:
                {
                    width: 333, height: 155
                },
            });
        $('.modal-graph').on('shown.bs.modal', function () {
            if(chartData != null) {
                $('#chartMunicipios').jqChart({
                    title: { text: '' },
                    animation: { duration: 1 },
                    shadows: {
                        enabled: false
                    },
                    border: {
                        cornerRadius: 0,
                        lineWidth: 1,
                        strokeStyle: '#e1e8ea'
                    },
                    axes: [{
                        location: 'bottom',
                        labels: { 
                            fillStyle: '#8d9395',
                            font: '12px sans-serif',
                            angle:-135 },
                    }],
                    labels:	{
                        textFillStyle: '#0e6275',
                    },
                    watermark: {
                        text: 'Rusicst',
                        fillStyle: '#d7dbdd',
                        font: '10px Roboto',
                        hAlign: 'right',
                        vAlign: 'bottom'
                    },
                    legend: {
                        visible: true,
                        location : 'right',
                        allowHideSeries: true,
                        border: {
                            lineWidth: 0,
                            strokeStyle: ''
                        },
                        font: '12px Roboto',
                        textFillStyle: '#0e6275',
                        background: '',
                        margin: 20
                    },
                    series: [
                        {
                            type: 'column',
                            title: 'Encuesta',
                            fillStyle: '#fe8c86',
                            data: chartData.Data,
                        }
                    ]
                });

                $('#chartMunicipios').bind('tooltipFormat', function (e, data) {
                    return "<b>" + data.x + "</b><br />" +
                           data.series.title + " : " + data.y.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1,") + "<br />";
                });
            }
        });
    </script>
</asp:Content>
