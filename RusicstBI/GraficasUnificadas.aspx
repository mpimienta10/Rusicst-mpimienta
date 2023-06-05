<%@ Page Title="Gráficas Unificadas de Gastos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GraficasUnificadas.aspx.cs" Inherits="RusicstBI.GraficasUnificadas" %>

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
                <h2><asp:Literal id="litNombreGrafica" runat="server" Text="Gráficas Rusicst"/></h2>
            </div>
            <br />
            <div class="row">
                <div class="col-sm-3">

                </div>
                <div class="col-sm-2">
                    <asp:Label AssociatedControlID="ddlTiposGrafica" runat="server" CssClass="control-label"><asp:Literal runat="server" Text="Tipos de Gráfica :" /></asp:Label>
                </div>
                <div class="col-sm-4">
                    <asp:DropDownList ID="ddlTiposGrafica" runat="server" CssClass="form-control" data-toggle="tooltip" onchange="seleccionarTiposGrafica();"/>
                </div>
            </div>
            <br />
            <div class="row">
                <ol class="filter">
                    <li></li>
                    <li><span><asp:Literal runat="server" Text="Encuesta :"/><asp:Literal ID="litEncuesta" runat="server"></asp:Literal></span></li>
                    <li><span><asp:Literal runat="server" Text="Departamento :"/><asp:Literal ID="litDepartamento" runat="server"></asp:Literal></span></li>
                    <li><span><asp:Literal runat="server" Text="Municipio :"/><asp:Literal ID="litMunicipio" runat="server"></asp:Literal></span></li>
                </ol>
            </div>
        </div>
    </div>
    <!-- End page title -->
    <section id="graficas-pte" data-speed="2" data-type="background">
        <div class="graficas-pte-wrapper" style="visibility:visible"  id="divGrafica">
            <div class="container">
                <h2 class="title-medium-section"><asp:Literal id="grGrafica" runat="server" /></h2>
                <div id="chartGrafico" style="height: 400px;"></div>
            </div>
        </div>
        <!-- End tables container -->
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

    <script type="text/javascript">
        $(document).ready(function(){
            $('[data-toggle="tooltip"]').tooltip({ placement : 'bottom' });
        });
    </script>

    <script type="text/javascript">
        function seleccionarTiposGrafica() {
            var listaTiposGrafica = document.getElementById('<%: ddlTiposGrafica.ClientID %>');
            var opcionTipoGrafica = listaTiposGrafica.options[listaTiposGrafica.selectedIndex].value;

            switch(opcionTipoGrafica)
            {
                case '0':
                    $('#chartGrafico').jqChart({
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
                                font: '8px sans-serif',
                                angle:-45 },
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
                            location : 'left',
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
                                title: '<%= NombreEje%>',
                                fillStyle: '#3ac4b7',
                                data: <%= DatosRejilla %>,
                            }
                        ]
                    });

                    $('#chartGrafico').bind('tooltipFormat', function (e, data) {
                        return "<b>" + data.x + "</b><br />" +
                               data.series.title + " : " + data.y.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1,") + "<br />";
                    });

                    break;
                case '1':
                    $('#chartGrafico').jqChart({
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
                                type: 'pie',
                                title: '<%= NombreEje%>',
                                fillStyle: '#3ac4b7',
                                data: <%= DatosRejilla %>,
                                labels: { font: '12px Roboto', }
                            }
                        ]
                    });

                    $('#chartGrafico').bind('tooltipFormat', function (e, data) {
                        return "<b>" + data.x + "</b><br />" +
                               data.series.title + " : " + data.y.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1,") + "<br />";
                    });

                    break;
                case '2':
                    $('#chartGrafico').jqChart({
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
                                font: '8px sans-serif',
                                angle:-45 },
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
                            location : 'left',
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
                                type: 'line',
                                title: '<%= NombreEje%>',
                                fillStyle: '#996f75',
                                data: <%= DatosRejilla %>,
                                labels: { font: '12px Roboto', }
                            }
                        ]
                    });

                    $('#chartGrafico').bind('tooltipFormat', function (e, data) {
                        return "<b>" + data.x + "</b><br />" +
                               data.series.title + " : " + data.y.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1,") + "<br />";
                    });

                    break;
                case '3':
                    $('#chartGrafico').jqChart({
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
                                type: 'bar',
                                title: '<%= NombreEje%>',
                                fillStyle: '#fec793',
                                data: <%= DatosRejilla %>,
                            }
                        ]
                    });

                    $('#chartGrafico').bind('tooltipFormat', function (e, data) {
                        return "<b>" + data.x + "</b><br />" +
                               data.series.title + " : " + data.y.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1,") + "<br />";
                    });

                    break;
            }
        }
    </script>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#chartGrafico').jqChart({
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
                        font: '8px sans-serif',
                        angle:-45 },
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
                    location : 'left',
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
                        title: '<%= NombreEje%>',
                        fillStyle: '#3ac4b7',
                        data: <%= DatosRejilla %>,
                    }
                ]
            });

            $('#chartGrafico').bind('tooltipFormat', function (e, data) {
                return "<b>" + data.x + "</b><br />" +
                       data.series.title + " : " + data.y.toString().replace(/(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1,") + "<br />";
            });

        });
    </script>
</asp:Content>
