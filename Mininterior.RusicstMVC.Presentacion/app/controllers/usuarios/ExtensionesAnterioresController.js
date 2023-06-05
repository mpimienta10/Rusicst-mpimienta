app.controller('ExtensionesAnterioresController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, authService) {

    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.cargoDatos = null;
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        //data: $scope.datos,
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            
            if (col.colDef.displayName === 'Fecha' || col.colDef.displayName === 'Fecha autorización') value = new Date(value).toLocaleDateString();
            return value;
        },
        onRegisterApi: function (gridApi) {
            gridApi.pagination.raise.paginationChanged = function (currentPage, pageSize) {
            };
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };
    $scope.isColumnDefs = false;

    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });
    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "FechaTramite", newProperty: "Fecha autorización" }
            , { field: "TipoExtension", newProperty: "Tipo Extensión" }
        ]
    };

    var formatDate =
    {
        action: "CambiarFecha",
        parameters: [
            { field: "Fecha" },
            { field: "FechaTramite" },
        ]
    };

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    var url = '/api/Usuarios/HabilitarReportes?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;

    getDatos();

    function getDatos() {
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            UtilsService.getColumnDefs($scope.gridOptions, false);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            UtilsService.utilsGridOptions($scope.gridOptions, formatDate);

        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };


    //------------------- Inicio logica del popup de los filtro que no se desarrollara por el momento -------------------
    $scope.openPopUp = function () {
        var modalInstance = $uibModal.open({
            templateUrl: '/scripts/views/modals/Filtro.html',
            controller: 'PopUpfiltroController',
            resolve: {
                colsGroup: function () { return { columnDefs: $scope.gridOptions.columnDefs, arregloFinalFiltro: $scope.arregloFinalFiltro } }
            }
        });
        modalInstance.result.then(
             function (arregloFiltro) {
                 $scope.arregloFinalFiltro = arregloFiltro;
                 if ($scope.arregloFinalFiltro.length > 0) {
                     //se debe hacer un post pasandole el $scope.arregloFinalFiltro                
                     //$http.post(url, $scope.arregloFinalFiltro).then(function (response) {
                 }
             }
           );
    };
    // Fin logica del popup de los filtro que no se desarrollara por el momento
}]);