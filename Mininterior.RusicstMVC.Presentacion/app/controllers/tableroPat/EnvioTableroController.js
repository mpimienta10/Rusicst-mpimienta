app.controller('EnvioTableroController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout) {
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.cargoDatos = false;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {            
            if (col.colDef.displayName === 'Fecha de Envío') value = new Date(value).toLocaleDateString();
            return value;
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };
    $scope.isColumnDefs = false;
    $scope.columnDefsFijas = [];
    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid'); }
    });
    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };
    var columsNoVisibles = ["IdUsuario", "IdMunicipio", "IdDepartamento"];
    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "AnoPlaneacion", newProperty: "Año Planeación" },
            { field: "FechaEnvio", newProperty: "Fecha de Envio" },
            { field: "IdTablero", newProperty: "Tablero" },
            { field: "TipoEnvio", newProperty: "Tipo Envío" },
        ]
    };
    var actionJsonExport = {
        action: "CambiarDefinicion",
        definition: "exporterSuppressExport",
        parameters: [
            { field: "IdUsuario", newProperty: true },
            { field: "IdMunicipio", newProperty: true },
            { field: "IdDepartamento", newProperty: true },
        ]
    };
    var formatDate = {
        action: "CambiarFecha",
        parameters: [
            { field: "FechaEnvio" },
        ]
    };

    getDatos();
    function getDatos() {
        var url = '/api/TableroPat/ListaEnvioTablero/';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            if (!$scope.isColumnDefs) {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, columsNoVisibles);
                $scope.isColumnDefs = true;
            } else {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, columsNoVisibles);
            }
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJsonExport);
            UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };   
}])
;