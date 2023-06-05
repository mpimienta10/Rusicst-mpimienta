app.controller('UsuariosSistemaController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal) {
    //------------------- Inicio logica de filtros de la pantalla -------------------
    $scope.cargoDatos = null;
    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "NombreDeUsuario", newProperty: "Nombre de Usuario" },
            { field: "TelefonoCelular", newProperty: "Teléfono Celular" },
            { field: "TipoUsuario", newProperty: "Tipo de Usuario" }
        ]
    };
    var checboxCell = {
        action: "CambiarDefinicion",
        definition: "cellTemplate",
        parameters: [
            { field: "Activo", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },

        ]
    };
    var optionsFilter = [
      //{ value: "", label: "" },
      { value: false, label: "NO" },
      { value: true, label: "SI" },
    ]
    var filters = [{ selectOptions: optionsFilter, term: '', type: uiGridConstants.filter.SELECT, condition: uiGridConstants.filter.EXACT, disableCancelFilterButton: true, }, { condition: uiGridConstants.filter.CONTAINS, }];
    var filtersChange = {
        action: "CambiarDefinicion",
        definition: "filters",
        parameters: [
            { field: "Activo", newProperty: filters },

        ]
    };

    function buscar() {
        $scope.alerta = null;
        var url = '/api/Informes/UsariosEnSistema/';
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatos = true;
                if (datos.length > 0) {
                    $scope.isGrid = true;
                    $scope.gridOptions.data = datos;
                    if (!$scope.isColumnDefs) {
                        UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, null);
                        UtilsService.utilsGridOptions($scope.gridOptions, checboxCell);
                        UtilsService.utilsGridOptions($scope.gridOptions, filtersChange);
                        $scope.isColumnDefs = true;
                    } else {
                        UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, null);
                    }
                    UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                } else {
                    $scope.isGrid = false;
                    $scope.isColumnDefs = false;
                    $scope.alerta = "No se encontraron datos";
                }
            }, function (error) {
                $scope.cargoDatos = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
    }
    buscar();
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.colPdf = [
        { columna: 'Nombre de Usuario', col: null },
        { columna: 'Email', col: null }
    ]
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            angular.forEach($scope.colPdf, function (fila) {
                if (col.colDef.displayName === fila.columna) fila.col = col;
            });
            return value;
        },
        onRegisterApi: function (gridApi) {
           
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
            gridApi.grid.options.exporterPdfTableHeaderStyle = { fontSize: 8, bold: true, color: 'white', fillColor: '#63002D', alignment: 'center' };
            gridApi.grid.options.exporterPdfDefaultStyle = { fontSize: 7 };
            gridApi.grid.options.exporterPdfCustomFormatter = function (docDefinition) {
                var datosPDF = docDefinition.content[0].table.body;
                UtilsService.personalizarExportPDF(datosPDF, $scope.colPdf)
                docDefinition.styles.headerStyle = { fontSize: 10, bold: true, alignment: 'center', color: '#63002D' };
                docDefinition.styles.footerStyle = { fontSize: 8, bold: true, alignment: 'center', color: '#333333' };
                return docDefinition;
            }
        },
    };
    $scope.isColumnDefs = false;
    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });
    //DIMENSIONAR LA TABLA
    $scope.getTableHeight = function () {
        var rowHeight = 30; // your row height
        var headerHeight = 30; // your header height
        return {
            height: '500px'//($scope.gridData.data.length * rowHeight + headerHeight) + "px"
        };
    };

    //$scope.colsGroup = angular.copy($scope.gridOptions.columnDefs);
    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    $scope.toggleFiltering = function () {
        $scope.gridOptions.enableFiltering = !$scope.gridOptions.enableFiltering;
        $scope.gridApi.core.notifyDataChange(uiGridConstants.dataChange.COLUMN);
    };
}]);
