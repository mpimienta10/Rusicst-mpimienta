<%@ Page Title="Consulta Personalizada" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ConsultaRusicstBI.aspx.cs" Inherits="RusicstBI.ConsultaRusicstBI" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
            <h2>Consultas de BI para Rusicst</h2>
            <ol class="filter">
                <li></li>
<%--                <li><span>a&ntilde;o:
                    <asp:Literal ID="litAnio" runat="server" /></span></li>
                <li><span>sector:
                    <asp:Literal ID="litSector" runat="server" /></span></li>
                <li><span>entidad:
                    <asp:Literal ID="litEntidad" runat="server" /></span></li>--%>
            </ol>
            <!-- End search filters -->
        </div>
    </div>

    <section id="consultas" data-speed="6" data-type="background">
        <div class="container">
            <h1 class="title-main-section">Selecciona los filtros que deseas aplicar a tu búsqueda:</h1>
            <div class="filter-collapse">
                <div class="panel-group accordion" id="accordion" role="tabpanel" aria-multiselectable="true">
                    <div class="panel panel-default">
                        <div class="panel-heading" id="heading3" role="tab">
                            <h4 class="panel-title">
                                <a class="collapsed" role="button" aria-expanded="true" aria-controls="filter3" href="#filter3" data-toggle="collapse" data-parent="#accordion"><b>Consultas Predefinidas</b></a>
                            </h4>
                        </div>
                        <asp:Panel ID="Panel2" runat="server">
                            <div class="panel-collapse collapse" id="filter3" role="tab" aria-labelledby="heading3">
                                <div class="panel-body">
                                    <div class="container">
                                        <div class="row">
                                            <asp:GridView ID="grdConsultaPredefinida" runat="server" CssClass="table table-striped table-hover table-bordered"
                                                GridLines="None" AutoGenerateColumns="False" AllowPaging="True" OnSorting="grdConsultaPredefinida_Sorting"
                                                OnPageIndexChanging="grdConsultaPredefinida_PageIndexChanging" OnRowCommand="grdConsultaPredefinida_RowCommand" AllowSorting="True" OnDataBound="grdAll_DataBound">
                                                <Columns>
                                                    <asp:BoundField DataField="IdConsultaPredefinida" HeaderText="Consulta"
                                                        ItemStyle-CssClass="text-left-cp" HeaderStyle-CssClass="text-center-cp" >
                                                        <HeaderStyle CssClass="text-center-cp"></HeaderStyle>
                                                        <ItemStyle CssClass="text-left-cp"></ItemStyle>
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Nombre" SortExpression="Nombre">
                                                        <ItemTemplate>
                                                            <div style="width: 400px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis">
                                                                <%# Eval("Nombre") %>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Descripcion" SortExpression="Descripcion">
                                                        <ItemTemplate>
                                                            <div style="width: 400px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis">
                                                                <%# Eval("Descripcion") %>
                                                            </div>
                                                        </ItemTemplate>
                                                    </asp:TemplateField>
                                                    <asp:TemplateField>
                                                      <ItemTemplate>
                                                        <asp:Button ID="cmdSeleccionarConsultaPredefinida" runat="server" CommandName="SeleccionarConsultaPredefinida" CommandArgument="<%# ((GridViewRow) Container).RowIndex %>" Text="Seleccionar" Font-Bold="True" />
                                                      </ItemTemplate> 
                                                    </asp:TemplateField>
                                                </Columns>
                                                <PagerSettings Mode="NumericFirstLast" />
                                                <PagerStyle CssClass="pagination-ys" />
                                            </asp:GridView>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>

                        <div class="panel-heading" id="heading0" role="tab">
                            <h4 class="panel-title">
                                <asp:CheckBox ID="cbDimensiones" runat="server" /><asp:Label AssociatedControlID="cbDimensiones" runat="server" />
                                <a class="collapsed" role="button" aria-expanded="true" aria-controls="filter0" href="#filter0" data-toggle="collapse" data-parent="#accordion">Dimensiones</a>
                            </h4>
                        </div>
                        <asp:Panel ID="ParametrosContainer" runat="server">
                            <div class="panel-collapse collapse" id="filter0" role="tab" aria-labelledby="heading0">
                                <div class="panel-body">
                                    <div class="panel-group subaccordion" id="subAcordion0" role="tab" aria-multiselectable="true">
                                        <div class="panel panel-default">
                                            <div class="panel-heading" id="subheading3" role="tab">
                                                <h4 class="panel-title">
                                                    <asp:CheckBox ID="cbEncuestas" runat="server" /><asp:Label AssociatedControlID="cbEncuestas" runat="server" />
                                                    <a class="collapsed" role="button" aria-expanded="true" aria-controls="subfilter03" href="#subfilter03" data-toggle="collapse" data-parent="subAcordion0">Encuestas</a></h4>
                                            </div>
                                            <div class="panel-collapse collapse" id="subfilter03" role="tablist" aria-labelledby="subheading2">
                                                <div class="panel-body">
                                                    <ul class="filters-list">
                                                        <li>
                                                            <asp:CheckBox ID="cbCodigoEncuesta" runat="server" /><asp:Label AssociatedControlID="cbCodigoEncuesta" Text="Código de Encuesta" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbNombreEncuesta" runat="server" /><asp:Label AssociatedControlID="cbNombreEncuesta" Text="Nombre de Encuesta" runat="server" /></li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="panel-heading" id="subheading2" role="tab">
                                                <h4 class="panel-title">
                                                    <asp:CheckBox ID="cbPreguntas" runat="server" /><asp:Label AssociatedControlID="cbPreguntas" runat="server" />
                                                    <a class="collapsed" role="button" aria-expanded="true" aria-controls="subfilter02" href="#subfilter02" data-toggle="collapse" data-parent="subAcordion0">Preguntas</a></h4>
                                            </div>
                                            <div class="panel-collapse collapse" id="subfilter02" role="tablist" aria-labelledby="subheading2">
                                                <div class="panel-body">
                                                    <ul class="filters-list">
                                                        <li>
                                                            <asp:CheckBox ID="cbCodigoPregunta" runat="server" /><asp:Label AssociatedControlID="cbCodigoPregunta" Text="Código de Pregunta" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbNombrePregunta" runat="server" /><asp:Label AssociatedControlID="cbNombrePregunta" Text="Nombre de Pregunta" runat="server" /></li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="panel-heading" id="subheading0" role="tab">
                                                <h4 class="panel-title">
                                                    <asp:CheckBox ID="cbDepartamentos" runat="server" /><asp:Label AssociatedControlID="cbDepartamentos" runat="server" />
                                                    <a class="collapsed" role="button" aria-expanded="true" aria-controls="subfilter00" href="#subfilter00" data-toggle="collapse" data-parent="subAcordion0">Departamentos</a></h4>
                                            </div>
                                            <div class="panel-collapse collapse" id="subfilter00" role="tablist" aria-labelledby="subheading0">
                                                <div class="panel-body">
                                                    <ul class="filters-list">
                                                        <li>
                                                            <asp:CheckBox ID="cbCodigoDepartamento" runat="server" /><asp:Label AssociatedControlID="cbCodigoDepartamento" Text="Código del Departamento" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbNombreDepartamento" runat="server" /><asp:Label AssociatedControlID="cbNombreDepartamento" Text="Nombre del Departamento" runat="server" /></li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="panel-heading" id="subheading1" role="tab">
                                                <h4 class="panel-title">
                                                    <asp:CheckBox ID="cbMunicipios" runat="server" /><asp:Label AssociatedControlID="cbMunicipios" runat="server" />
                                                    <a class="collapsed" role="button" aria-expanded="true" aria-controls="subfilter01" href="#subfilter01" data-toggle="collapse" data-parent="subAcordion0">Municipios</a></h4>
                                            </div>
                                            <div class="panel-collapse collapse" id="subfilter01" role="tablist" aria-labelledby="subheading1">
                                                <div class="panel-body">
                                                    <ul class="filters-list">
                                                        <li>
                                                            <asp:CheckBox ID="cbCodigoMunicipio" runat="server" /><asp:Label AssociatedControlID="cbCodigoMunicipio" Text="Código del Municipio" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbNombreMunicipio" runat="server" /><asp:Label AssociatedControlID="cbNombreMunicipio" Text="Nombre del Municipio" runat="server" /></li>

                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="panel-heading" id="subheading4" role="tab">
                                                <h4 class="panel-title">
                                                    <asp:CheckBox ID="cbOtros" runat="server" /><asp:Label AssociatedControlID="cbOtros" runat="server" />
                                                    <a class="collapsed" role="button" aria-expanded="true" aria-controls="subfilter04" href="#subfilter04" data-toggle="collapse" data-parent="subAcordion0">Otros</a></h4>
                                            </div>
                                            <div class="panel-collapse collapse" id="subfilter04" role="tablist" aria-labelledby="subheading3">
                                                <div class="panel-body">
                                                    <ul class="filters-list">
                                                        <li>
                                                            <asp:CheckBox ID="cbEtapaPolitica" runat="server" /><asp:Label AssociatedControlID="cbEtapaPolitica" Text="Etapa Política" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbSeccion" runat="server" /><asp:Label AssociatedControlID="cbSeccion" Text="Sección" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbTema" runat="server" /><asp:Label AssociatedControlID="cbTema" Text="Tema" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbHechoVictimizante" runat="server" /><asp:Label AssociatedControlID="cbHechoVictimizante" Text="Hecho Victimizante" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbDinamicaDesplazamiento" runat="server" /><asp:Label AssociatedControlID="cbDinamicaDesplazamiento" Text="Dinámica del Desplazamiento" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbEnfoqueDiferencial" runat="server" /><asp:Label AssociatedControlID="cbEnfoqueDiferencial" Text="Enfoque Diferencial" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbFactoresRiesgo" runat="server" /><asp:Label AssociatedControlID="cbFactoresRiesgo" Text="Factores de Riesgo" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbRangoEtareo" runat="server" /><asp:Label AssociatedControlID="cbRangoEtareo" Text="Rango Etareo" runat="server" /></li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                        <!-- End filtros parámetros -->

                        <div class="panel-heading" runat="server" id="heading1" role="tab">
                            <h4 class="panel-title">
                                <asp:CheckBox ID="cbHechos" runat="server" /><asp:Label AssociatedControlID="cbHechos" runat="server" />
                                <a class="collapsed" role="button" aria-expanded="true" aria-controls="filter1" href="#filter1" data-toggle="collapse" data-parent="#accordion">Hechos</a></h4>
                        </div>
                        <asp:Panel ID="ValoresContainer" runat="server">
                            <div class="panel-collapse collapse" id="filter1" role="tab" aria-labelledby="heading1">
                                <div class="panel-body">
                                    <div class="panel-group subaccordion" id="subAcordion1" role="tab" aria-multiselectable="true">
                                        <div class="panel panel-default">
                                            <div class="panel-heading" role="tab" id="subheading5">
                                                <h4 class="panel-title">
                                                    <asp:CheckBox ID="cbTipoRespuesta" runat="server" /><asp:Label AssociatedControlID="cbTipoRespuesta" runat="server" />
                                                    <a class="collapsed" role="button" aria-expanded="true" aria-controls="subfilter10" href="#subfilter10" data-toggle="collapse" data-parent="subAcordion1">Tipos de Respuesta</a></h4>
                                            </div>
                                            <div class="panel-collapse collapse" id="subfilter10" role="tablist" aria-labelledby="subheading5">
                                                <div class="panel-body">
                                                    <ul class="filters-list">
                                                        <li>
                                                            <asp:CheckBox ID="cbMoneda" runat="server" /><asp:Label AssociatedControlID="cbMoneda" Text="Moneda" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbNumero" runat="server" /><asp:Label AssociatedControlID="cbNumero" Text="Número" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbPorcentaje" runat="server" /><asp:Label AssociatedControlID="cbPorcentaje" Text="Porcentaje" runat="server" /></li>
                                                        <li>
                                                            <asp:CheckBox ID="cbRespuestaUnica" runat="server" /><asp:Label AssociatedControlID="cbRespuestaUnica" Text="Respuesta Unica" runat="server" /></li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>

                        <div class="panel-heading" id="heading4" role="tab">
                            <h4 class="panel-title">
                                <a class="collapsed" role="button" aria-expanded="true" aria-controls="filter4" href="#filter4" data-toggle="collapse" data-parent="#accordion"><b>Filtros</b></a>
                            </h4>
                        </div>
                        <asp:Panel ID="Panel3" runat="server">
                            <div class="panel-collapse collapse" id="filter4" role="tab" aria-labelledby="heading3">
                                <section id="filtrous" data-speed="6" data-type="background">
                                    <div class="container">
                                        <div class="row">
                                            <div class="tab-container">
                                                <ul class="nav nav-tabs nav-justified" role="tablist">
                                                    <li id="tabBasicos" role="presentation"><a href="#basicos" aria-controls="home" role="tab" data-toggle="tab">Básicos</a></li>
                                                    <li id="tabPreguntas" role="presentation"><a href="#preguntas" aria-controls="profile" role="tab" data-toggle="tab">Preguntas</a></li>
                                                    <li id="tabUbicacion" role="presentation"><a href="#ubicacion" aria-controls="messages" role="tab" data-toggle="tab">Ubicación</a></li>
                                                </ul>
                                                <div class="tab-content">
                                                    <div role="tabpanel" class="tab-pane fade in" id="basicos">
                                                        <div class="tab-container-content clearfix">
                                                            <div class="form-horizontal pte-form">
                                                                <div class="row">
                                                                    <div class="col-sm-6">
                                                                        <div class="row">
                                                                            <div class="col-sm-5">
                                                                                <asp:Label AssociatedControlID="ddlEncuestas" runat="server" CssClass="control-label">Encuesta:</asp:Label>
                                                                            </div>
                                                                            <div class="col-sm-6">
                                                                                <asp:DropDownList ID="ddlEncuestas" runat="server" CssClass="form-control" data-toggle="tooltip" title="Encuestas contenidas en Rusicst">
                                                                                </asp:DropDownList>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="row">
                                                                    <div class="col-sm-6">
                                                                        <div class="row">
                                                                            <div class="col-sm-5">
                                                                                <asp:Label AssociatedControlID="ddlDepartamentos" runat="server" CssClass="control-label">Departamentos:</asp:Label>
                                                                            </div>
                                                                            <div class="col-sm-6">
                                                                                <asp:DropDownList ID="ddlDepartamentos" runat="server" CssClass="form-control" data-toggle="tooltip"  title="Departamentos contenidos en Rusicst" AutoPostBack="True" OnSelectedIndexChanged="ddlDepartamentos_SelectedIndexChanged" >
                                                                                </asp:DropDownList>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="col-sm-6">
                                                                        <div class="row">
                                                                            <div class="col-sm-5">
                                                                                <asp:Label AssociatedControlID="ddlMunicipios" runat="server" CssClass="control-label">Municipios:</asp:Label>
                                                                            </div>
                                                                            <div class="col-sm-6">
                                                                                <asp:DropDownList ID="ddlMunicipios" runat="server" CssClass="form-control" data-toggle="tooltip" title="Encuestas contenidos en Rusicst">
                                                                                </asp:DropDownList>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!--End Ingresos Tab-->

                                                    <div role="tabpanel" class="tab-pane fade" id="preguntas">
                                                        <div class="tab-container-content clearfix">
                                                            <div class="form-horizontal pte-form">
                                                                <div class="row">
                                                                    <div class="col-sm-6">
                                                                        <div class="row">
                                                                            <div class="col-sm-5">
                                                                                <asp:Label AssociatedControlID="grdFiltroPreguntas" runat="server" CssClass="control-label">Preguntas:</asp:Label>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <br />
                                                                    <div class="row">
                                                                        <asp:GridView ID="grdFiltroPreguntas" runat="server" CssClass="table table-striped table-hover table-bordered"
                                                                            GridLines="None" AutoGenerateColumns="False" AllowPaging="True" OnSorting="grdFiltroPreguntas_Sorting"
                                                                            OnPageIndexChanging="grdFiltroPreguntas_PageIndexChanging" AllowSorting="True" OnDataBound="grdAll_DataBound">
                                                                            <Columns>
                                                                                <asp:BoundField DataField="CodigoPregunta" HeaderText="Codigo Pregunta"
                                                                                    ItemStyle-CssClass="text-left-cp" HeaderStyle-CssClass="text-center-cp"
                                                                                    SortExpression="CodigoPregunta">
                                                                                    <HeaderStyle CssClass="text-center-cp"></HeaderStyle>
                                                                                    <ItemStyle CssClass="text-left-cp"></ItemStyle>
                                                                                </asp:BoundField>
                                                                                <asp:BoundField DataField="NombrePregunta" HeaderText="Nombre Pregunta"
                                                                                    ItemStyle-CssClass="text-left-cp" HeaderStyle-CssClass="text-center-cp"
                                                                                    SortExpression="NombrePregunta">
                                                                                    <HeaderStyle CssClass="text-center-cp"></HeaderStyle>
                                                                                    <ItemStyle CssClass="text-left-cp"></ItemStyle>
                                                                                </asp:BoundField>
                                                                            </Columns>
                                                                            <PagerSettings Mode="NumericFirstLast" />
                                                                            <PagerStyle CssClass="pagination-ys" />
                                                                        </asp:GridView>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- End Gastos Tab -->

                                                    <div role="tabpanel" class="tab-pane fade" id="ubicacion">
                                                        <div class="tab-container-content clearfix">
                                                            <div class="form-horizontal pte-form">
                                                                <div class="row">
                                                                    <div class="col-sm-6">
                                                                        <div class="row">
                                                                            <div class="col-sm-5">
                                                                                <asp:Label AssociatedControlID="grdUbicacion" runat="server" CssClass="control-label">Ubicación:</asp:Label>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <div class="row">
                                                                        <asp:GridView ID="grdUbicacion" runat="server" CssClass="table table-striped table-hover table-bordered"
                                                                            GridLines="None" AutoGenerateColumns="False" AllowPaging="True" OnPageIndexChanging="grdUbicacion_PageIndexChanging" OnDataBound="grdAll_DataBound" OnRowDataBound="grdUbicacion_RowDataBound">
                                                                            <Columns>
                                                                                <asp:BoundField DataField="Componente" HeaderText="Componente"
                                                                                    ItemStyle-CssClass="text-left-cp" HeaderStyle-CssClass="text-center-cp"
                                                                                    SortExpression="Componente">
                                                                                    <HeaderStyle CssClass="text-center-cp"></HeaderStyle>
                                                                                    <ItemStyle CssClass="text-left-cp"></ItemStyle>
                                                                                </asp:BoundField>
                                                                                <asp:templatefield HeaderText="Ubicación">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="lblUbicacion" runat="server" Text='<%# Eval("Ubicacion") %>' Visible = "false" />
                                                                                        <asp:DropDownList ID="ddlUbicacion" runat="server" ItemStyle-CssClass="text-left-cp" HeaderStyle-CssClass="text-center-cp" ></asp:DropDownList>
                                                                                    </ItemTemplate>
                                                                                </asp:templatefield>
                                                                            </Columns>
                                                                            <PagerSettings Mode="NumericFirstLast" />
                                                                            <PagerStyle CssClass="pagination-ys" />
                                                                        </asp:GridView>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <!-- End Tab Contratos -->
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </section>
                                <!-- End Section tabbed content -->
                            </div>
                        </asp:Panel>

                        <div class="panel-heading" id="heading2" role="tab">
                            <h4 class="panel-title">
                                <a class="collapsed" role="button" aria-expanded="true" aria-controls="filter2" href="#filter2" data-toggle="collapse" data-parent="#accordion"><b>Preguntas</b></a>
                                <asp:TextBox ID="tbPreguntas" runat="server" CssClass="form-control" data-toggle="tooltip" title="En esta caja de texto, se deben escribir los codigos de las preguntas separadas por punto y coma (;) para que la busqueda utilice este filtro."  Visible="False" /> 
                            </h4>
                        </div>
                        <asp:Panel ID="Panel1" runat="server">
                            <div class="panel-collapse collapse" id="filter2" role="tab" aria-labelledby="heading2">
                                <div class="panel-body">
                                    <br />
                                    <div class="container">
                                        <div class="row">
                                            <div class="col-sm-1">
                                                <asp:Label AssociatedControlID="tbFiltroPreguntas" runat="server" CssClass="control-label">Filtro:</asp:Label>
                                            </div>
                                            <div class="col-sm-5">
                                                <asp:TextBox ID="tbFiltroPreguntas" runat="server" CssClass="form-control" data-toggle="tooltip" title="En esta caja de texto, el usuario escribe el texto que desea buscar, ya sea el código o el nombre de la pregunta."/>                                        
                                            </div>
                                            <div class="col-sm-2">
                                                <asp:Button ID="cmdBuscarPreguntas" runat="server" Text="Buscar por Código" CssClass="btn btn-default" OnClick="cmdBuscarPreguntas_Click" data-toggle="tooltip" title="Después de definir el criterios de busqueda y el portal busca la información solicitada, presentandola en la rejilla que se encuentra definida para este fin."/>
                                            </div>
                                            <div class="col-sm-2">
                                                <asp:Button ID="cmdBuscarNombre" runat="server" Text="Buscar por Nombre" CssClass="btn btn-default" OnClick="cmdBuscarNombre_Click" data-toggle="tooltip" title="Después de definir el criterios de busqueda y el portal busca la información solicitada, presentandola en la rejilla que se encuentra definida para este fin."/>                                                    
                                            </div>
                                        </div>
                                        <div class="row">
                                            <asp:GridView ID="grdPreguntas" runat="server" CssClass="table table-striped table-hover table-bordered"
                                                GridLines="None" AutoGenerateColumns="False" AllowPaging="True" OnSorting="grdPreguntas_Sorting"
                                                OnPageIndexChanging="grdPreguntas_PageIndexChanging" AllowSorting="True" OnDataBound="grdAll_DataBound">
                                                <Columns>
                                                    <asp:templatefield HeaderText="Seleccionar">
                                                        <ItemTemplate>
                                                            <asp:checkbox ID="ckSeleccionar" ItemStyle-CssClass="text-left-cp" HeaderStyle-CssClass="text-center-cp" runat="server" >
                                                            </asp:checkbox>
                                                        </ItemTemplate>
                                                    </asp:templatefield>
                                                    <asp:BoundField DataField="CodigoPregunta" HeaderText="Codigo Pregunta"
                                                        ItemStyle-CssClass="text-left-cp" HeaderStyle-CssClass="text-center-cp"
                                                        SortExpression="CodigoPregunta">
                                                        <HeaderStyle CssClass="text-center-cp"></HeaderStyle>
                                                        <ItemStyle CssClass="text-left-cp"></ItemStyle>
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="NombrePregunta" HeaderText="Nombre Pregunta"
                                                        ItemStyle-CssClass="text-left-cp" HeaderStyle-CssClass="text-center-cp"
                                                        SortExpression="NombrePregunta">
                                                        <HeaderStyle CssClass="text-center-cp"></HeaderStyle>
                                                        <ItemStyle CssClass="text-left-cp"></ItemStyle>
                                                    </asp:BoundField>
                                                </Columns>
                                                <PagerSettings Mode="NumericFirstLast" />
                                                <PagerStyle CssClass="pagination-ys" />
                                            </asp:GridView>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-1">
                                            </div>
                                            <div class="col-sm-5">
                                                <asp:Button ID="cmdSeleccionar" runat="server" Text="Seleccionar" CssClass="btn btn-default" OnClick="cmdSeleccionar_Click" data-toggle="tooltip" title="Seleccionar."/>
                                            </div>
                                        </div>
                                        <br />
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                        <!-- End filtros valores -->
                    </div>
                </div>
            </div>
        </div>
        <div style="text-align: center;">
            <div id="modalConsultaPersonalizada" class="modal fade modal-info1" tabindex="-1" role="dialog" aria-labelledby="Ingresos">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">Consulta Predefinida</h4>
                        </div>
                        <div class="modal-body">
                            <div class="container">
                                <div class="row">
                                    <div class="col-sm-2">
                                        <asp:Label AssociatedControlID="tbNombreConsulta" runat="server" CssClass="control-label">Nombre</asp:Label>
                                    </div>
                                    <div class="col-sm-5">
                                        <asp:TextBox ID="tbNombreConsulta" runat="server" CssClass="form-control" data-toggle="tooltip" title="En esta caja de texto, el usuario digita el nombre de la consulta predefinida."/>
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-sm-2">
                                        <asp:Label AssociatedControlID="tbDescripcionConsulta" runat="server" CssClass="control-label">Descripción</asp:Label>
                                    </div>
                                    <div class="col-sm-6">
                                        <asp:TextBox ID="tbDescripcionConsulta" runat="server" CssClass="form-control" data-toggle="tooltip" title="En esta caja de texto, el usuario digita el nombre de la consulta predefinida." TextMode="MultiLine" />
                                    </div>
                                </div>
                                <br />
                                <div class="row">
                                    <div class="col-sm-1">
                                        <asp:Button ID="cmdGuardar" runat="server" Text="Guardar" CssClass="btn btn-default btn-pte-green" OnClick="cmdGuardar_Click" data-toggle="tooltip" title="Guarda los parametros de la consulta predefinida ."/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div>
                <div class="row">
                    <asp:Button ID="cmdGenerarDatos" runat="server" Text="Generar Datos" CssClass="btn btn-default btn-pte-green" OnClick="cmdGenerarDatos_Click" data-toggle="tooltip" title="Después de definir los criterios de busqueda y escoger las opciones que desea incluir en la consulta el ciudadano hace clic en este botón y el portal busca la información solicitada, presentandola en la rejilla que se encuentra en la página."/>
                    <asp:Button ID="cmdLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-default btn-pte-green" OnClick="cmdLimpiar_Click" data-toggle="tooltip" title="Limpia los parametros de la consulta."/>
                    <button type="button" class="btn btn-default btn-pte-green" data-toggle="modal" data-target="#modalConsultaPersonalizada">Guardar Predefinida</button>
                </div>
            </div>
        </div>
    </section>
    <div class="graficas-pte-wrapper">
        <div class="container">
            <div class="table-responsive">
                <asp:GridView ID="grdResultados" runat="server" CssClass="table table-striped table-hover table-bordered"
                    GridLines="None" AutoGenerateColumns="false" AllowPaging="True" OnPageIndexChanging="grdResultados_PageIndexChanging" OnDataBound="grdAll_DataBound" >
                    <Columns>
                        <asp:templatefield HeaderText="Seleccionar">
                            <itemtemplate>
                                <asp:checkbox ID="ckSeleccionarFiltro" ItemStyle-CssClass="text-left-cp" HeaderStyle-CssClass="text-center-cp" runat="server" />
                            </itemtemplate>
                        </asp:templatefield>
                    </Columns>
                    <PagerSettings Mode="NumericFirstLast" />
                    <PagerStyle CssClass="pagination-ys" />
                </asp:GridView>
            </div>
            <div class="row">
                <div class="col-md-12" style="margin-left: 30px;">
                    <asp:Label runat="server" CssClass="control-label">Exportar :</asp:Label>
                    <asp:Button ID="cmdExportarXLS" runat="server" Text="XLS" CssClass="btn btn-default" OnClick="cmdExportarXLS_Click" data-toggle="tooltip" title="Al hacer clic sobre este boton se descarga un archivo en formato XLS que contiene la información de la rejilla que se encuentra en la página."/>
                    <asp:Button ID="cmdExportarJSON" runat="server" Text="JSON" CssClass="btn btn-default" OnClick="cmdExportarJSON_Click" data-toggle="tooltip" title="Al hacer clic sobre este boton se descarga un archivo en formato JSON que contiene la información de la rejilla que se encuentra en la página."/>
                    <asp:Button ID="cmdGraficas" runat="server" Text="Gráficas" CssClass="btn btn-default" OnClick="cmdGraficas_Click" data-toggle="tooltip" title="Gráficas"/>
                    <asp:Button ID="cmdMapa" runat="server" Text="Mapa" CssClass="btn btn-default" OnClick="cmdMapa_Click" data-toggle="tooltip" title="Mapa"/>
                </div>
            </div>
        </div>
    </div>
    <div class="bg-success">
        <div class="container">
            <p class="center-block">Fuente: Rusicst</p>
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
    <%: Scripts.Render("~/bundles/bootstrap") %>

    <script type="text/javascript">
        $(document).ready(function () {
            $('[data-toggle="tooltip"]').tooltip({ placement: 'bottom' });
        });
    </script>

    <script type="text/javascript">
        $(window).load(function() {
            $('.nav-tabs a[href="#<%: ActiveTab %>"]').tab('show');
            if('true' == '<%: GoToTabbedPane %>') {
                $('#filtrous').goTo();
                //var top = $('#consult').position().top;
                //$(window).scrollTop(top);
            }
        });

    </script>

    <script type="text/javascript">
        window["_gaUserPrefs"] = { ioo: function () { return true; } }

        $(document).ready(function () {
            var checkBoxArray = [{
                checkbox: document.getElementById('<%= cbDimensiones.ClientID  %>'),
                children: [{
                    checkbox: document.getElementById('<%= cbEncuestas.ClientID  %>'), children: [
                        { checkbox: document.getElementById('<%= cbCodigoEncuesta.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbNombreEncuesta.ClientID  %>') }]
                }, {
                    checkbox: document.getElementById('<%= cbDepartamentos.ClientID  %>'), children: [
                        { checkbox: document.getElementById('<%= cbCodigoDepartamento.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbNombreDepartamento.ClientID  %>') }]
                }, {
                    checkbox: document.getElementById('<%=  cbMunicipios.ClientID  %>'), children: [
                        { checkbox: document.getElementById('<%= cbCodigoMunicipio.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbNombreMunicipio.ClientID  %>') }]
                }, {
                    checkbox: document.getElementById('<%= cbPreguntas.ClientID  %>'), children: [
                        { checkbox: document.getElementById('<%= cbCodigoPregunta.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbNombrePregunta.ClientID  %>') }]
                }, {
                    checkbox: document.getElementById('<%= cbOtros.ClientID  %>'), children: [
                        { checkbox: document.getElementById('<%= cbEtapaPolitica.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbSeccion.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbTema.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbHechoVictimizante.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbDinamicaDesplazamiento.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbEnfoqueDiferencial.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbFactoresRiesgo.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbRangoEtareo.ClientID  %>') }]
                }]
            }, {
                checkbox: document.getElementById('<%= cbHechos.ClientID  %>'),
                children: [
                {
                    checkbox: document.getElementById('<%= cbTipoRespuesta.ClientID  %>'), children: [
                        { checkbox: document.getElementById('<%= cbMoneda.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbNumero.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbPorcentaje.ClientID  %>') },
                        { checkbox: document.getElementById('<%= cbRespuestaUnica.ClientID  %>') }]
                }]
            }]

            $('input[type="checkbox"]').change(function () {
                var currentCheckBox = this;

                for (var i = 0; i < checkBoxArray.length; i++) {
                    var children = checkBoxArray[i].children;

                    if (checkBoxArray[i].checkbox == currentCheckBox) {
                        for (var j = 0; j < children.length; j++) {
                            if (currentCheckBox.checked) {
                                children[j].checkbox.checked = true;
                            } else {
                                children[j].checkbox.checked = false;
                            }
                            var grandChildren = children[j].children;
                            for (var k = 0; k < grandChildren.length; k++) {
                                if (currentCheckBox.checked) {
                                    grandChildren[k].checkbox.checked = true;
                                } else {
                                    grandChildren[k].checkbox.checked = false;
                                }
                            }
                        }
                    } else {
                        checkBoxArray[i].checkbox.checked = true;;
                        for (var j = 0; j < children.length; j++) {
                            var grandChildren = children[j].children;
                            if (children[j].checkbox == currentCheckBox) {
                                for (var k = 0; k < grandChildren.length; k++) {

                                    if (currentCheckBox.checked) {
                                        grandChildren[k].checkbox.checked = true;
                                    } else {
                                        grandChildren[k].checkbox.checked = false;
                                    }
                                }
                            } else {
                                children[j].checkbox.checked = true;
                                for (var k = 0; k < grandChildren.length; k++) {
                                    if (grandChildren[k].checkbox == currentCheckBox) {
                                        if (currentCheckBox.checked) {
                                            grandChildren[k].checkbox.checked = true;
                                        } else {
                                            children[j].checkbox.checked = false;
                                            checkBoxArray[i].checkbox.checked = false;
                                        }
                                    }
                                    if (!grandChildren[k].checkbox.checked) {
                                        children[j].checkbox.checked = false;
                                        checkBoxArray[i].checkbox.checked = false;
                                    }
                                }
                            }
                            if (!children[j].checkbox.checked) {
                                checkBoxArray[i].checkbox.checked = false;
                            }
                        }
                    }
                }
            });
        });
    </script>
</asp:Content>
