<%@ Page Title="Mapa de Regionalización por Departamento" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RusicstDepartamento.aspx.cs" Inherits="RusicstBI.RusicstDepartamento" %>

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
                <h2><asp:Literal runat="server" Text="Mapa"/></h2>
            </div>
            <br />
            <div class="row">
                <div class="col-sm-3">

                </div>
                <div class="col-sm-2">
                    <asp:Label AssociatedControlID="ddlDepartamentos" runat="server" CssClass="control-label"><asp:Literal runat="server" Text="Departamento :" /></asp:Label>
                </div>
                <div class="col-sm-4">
                    <asp:DropDownList ID="ddlDepartamentos" runat="server" CssClass="form-control" data-toggle="tooltip" onchange="if (seleccionarDepartamento()) return false;"/>
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
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"></button>
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
                                <h2 class="title-medium-section"><asp:Literal runat="server" Text="Gráfica"/></h2>
                                <div id="chartDepartamentoRusicst" class="graph"></div>
                                <div class="text-center">
                                    <br />
                                    <a class="btn btn-default btn-pte-green center" role="button" id="details-btn-RusicstMunicipio"><asp:Literal runat="server" Text="Detalle por Municipio"/></a>                                    
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="bg-success">
            <div class="container">
                <p class="center-block"><asp:Literal runat="server" Text="Rusicst"/></p>
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
        function seleccionarDepartamento() {
            var listaDepartamentos = document.getElementById('<%: ddlDepartamentos.ClientID %>');
            var opcionDepartamento = listaDepartamentos.options[listaDepartamentos.selectedIndex].value;

            if (opcionDepartamento == "0")
            {
                return true;
            }
            else 
            {
                var departamentos = <%= this.Departamentos %>;
                var dataDepartamentos = <%= this.ChartData %>;
                var chartData;

                var dept = departamentos.filter(function (d) { return d.Id == opcionDepartamento; })[0];

                cartData = null;
                chartData = dataDepartamentos.filter(function (d) { return d.Id == opcionDepartamento; })[0];

                $('#details-btn-RusicstMunicipio').attr('href', 'RusicstMunicipio.aspx?Departamento=' + dept.Departamento);

                var labelGrafica = document.getElementById('myGraphsLabel');
                labelGrafica.innerText = "Departamento : " + dept.Departamento;

                $('.modal-graph').modal('show');

                $('.modal-graph').on('shown.bs.modal', function () {
                    if(chartData != null) {
                        $('#chartDepartamentoRusicst').jqChart({
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

                        $('#chartDepartamentoRusicst').bind('tooltipFormat', function (e, data) {
                            return "<b>" + data.x + "</b><br />" +
                                   data.series.title + " : " + data.y.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1,") + "<br />";
                        });

                    }
                });
            }
        }
    </script>

    <script type="text/javascript">
        var departamentos = <%= this.Departamentos %>;
        var dataDepartamentos = <%= this.ChartData %>;
        var chartData;

        $(document).ready(function () {
            $(".btn_close").click(function () {
                $(".tooltip-pte").toggle("fast")
            });
        });

        $('#map-pte').mapSvg(
            {
                source: 'assets/libs/map/mapa_colombia.svg',
                loadingText: 'Cargando mapa...',
                colors:
                {
                    base: "#b5d8de",
                    background: "transparent",
                    selected: "#0e6275",
                    hover: "#0e6275",
                    disabled: "#ffffff",
                    stroke: "#fff"
                },
                cursor: 'pointer',
                width: 1024,
                onClick: function (e, m) {
                    var itemId = this.node.id.replace("_1_", "").replace("_2_", "");
                    var dept = departamentos.filter(function(d) { return d.Id == itemId; })[0];

                    if(dept != null) {
                        m.showPopover(e, '<h4>Departamento : ' + dept.Departamento + '</h4><p>Número de Encuentas  : </p><span class="value">' + dept.Valor.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1.") + '</span><a href="#"><asp:Literal runat="server" Text="Ver"/></a>');

                        $('#details-btn-RusicstMunicipio').attr('href', 'RusicstMunicipio.aspx?Departamento=' + dept.Departamento);

                        $('.map_popover_content').click(function() {
                            var labelGrafica = document.getElementById('myGraphsLabel');
                            labelGrafica.innerText = "Departamento : " + dept.Departamento;

                            $('.modal-graph').modal('show');
                        });
                    }

                    cartData = null;
                    chartData = dataDepartamentos.filter(function(d) { return d.Id == itemId; })[0];

                    cartDataDetalle = null;
                    chartDataDetalle = dataDepartamentosDetalle.filter(function(d) { return d.Id == itemId; })[0];
                },
                tooltipsMode: 'names',
                zoom: 0,
                pan: 0,
                responsive: 1,
                zoomLimit: [-100, 100],
                popover:
                {
                    width: 333, height: 206
                },
            });

        $('.modal-graph').on('shown.bs.modal', function () {
            if(chartData != null) {
                $('#chartDepartamentoRusicst').jqChart({
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
                            title: 'Encuesta',
                            fillStyle: '#fe8c86',
                            data: chartData.Data,
                        }
                    ]
                });

                $('#chartDepartamentoRusicst').bind('tooltipFormat', function (e, data) {
                    return "<b>" + data.x + "</b><br />" +
                           data.series.title + " : " + data.y.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1,") + "<br />";
                });

            }

        });
    </script>
</asp:Content>
