app.controller('OpcionesRolController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal) {
    $scope.cargoDatos = null;
    //------------------- Inicio logica de filtros de la pantalla -------------------
    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Menu", newProperty: "Menú" },
            { field: "SubMenu", newProperty: "Sub Menú" },       
            { field: "TipoUsuario", newProperty: "Tipo Usuario" },
        ]
    };
    var actionJson1 = {
        action: "CambiarDefinicion",
        definition: "exporterSuppressExport",
        parameters: [
            { field: "Url", newProperty: true },
        ]
    };
    var columsNoVisibles = ["Url"];
    function buscar() {
        $scope.alerta = null;
        var url = '/api/Informes/OpcionesRol/';
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatos = true;
                if (datos.length > 0) {
                    $scope.isGrid = true;
                    $scope.gridOptions.data = datos;                    
                    if (!$scope.isColumnDefs) {
                        UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, columsNoVisibles);
                        $scope.isColumnDefs = true;
                    } else {
                        UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, columsNoVisibles);
                    }
                    UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                    UtilsService.utilsGridOptions($scope.gridOptions, actionJson1);
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
    $scope.gridOptions = {
        columnDefs: [],
        onRegisterApi: function (gridApi) {
            gridApi.pagination.raise.paginationChanged = function (currentPage, pageSize) {
                //angular.element(document.getElementsByClassName('grid')[0]).css('height', 500 + 'px');
                //alert(gridApi.pagination.nextPage());
            };
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };
    $scope.isColumnDefs = false;

    //DIMENSIONAR LA TABLA
    $scope.getTableHeight = function () {
        var rowHeight = 30; // your row height
        var headerHeight = 30; // your header height
        return {
            height: '500px'//($scope.gridData.data.length * rowHeight + headerHeight) + "px"
        };
    };
    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });
    //$scope.colsGroup = angular.copy($scope.gridOptions.columnDefs);
    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    $scope.toggleFiltering = function () {
        $scope.gridOptions.enableFiltering = !$scope.gridOptions.enableFiltering;
        $scope.gridApi.core.notifyDataChange(uiGridConstants.dataChange.COLUMN);
    };   
}]);
