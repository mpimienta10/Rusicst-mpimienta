app.controller('ConsultaDiligenciamientoEntidadesController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$location', 'ngSettings', 'enviarDatos', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $location, ngSettings, enviarDatos) {
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.cargoDatos = false;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
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
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    function agregarColumnasFijas() {

        angular.forEach($scope.tableros, function (tab) {
            var columnDefsJsonFijas = {
                minWidth: 80,
                width: 80,
                name: tab.AnoTablero,
                field: 'Tablero_' + tab.Id,
                cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.Consultar(row.entity,' + tab.Id + ')">Consultar</a></div>',
                enableFiltering: false,
                pinnedRight: true,
                enableCellEdit: false,
                exporterSuppressExport: true,
            };
            $scope.columnDefsFijas.push(columnDefsJsonFijas);
        });
    }
    var columsNoVisibles = ["IdMunicipio", "TipoTipoUsuario"];


    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "TipoUsuario", newProperty: "Tipo de Usuario" },
        ]
    };

    var actionJsonExport = {
        action: "CambiarDefinicion",
        definition: "exporterSuppressExport",
        parameters: [
            { field: "IdMunicipio", newProperty: true },
            { field: "TipoTipoUsuario", newProperty: true }
        ]
    };
    var actionJsonTamano = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "Id", newProperty: "50" },
        ]
    };
    getDatos();
    function getDatos() {
        var url = '/api/TableroPat/DatosConsultaDiligenciamiento/';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.tableros = datos.tableros;
            $scope.gridOptions.data = datos.datos;
            agregarColumnasFijas();
            if (!$scope.isColumnDefs) {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                $scope.isColumnDefs = true;
            } else {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
            }
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJsonTamano);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJsonExport);

        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    $scope.Consultar = function (entidad, Id) {
        enviarDatos.datos = entidad;
        enviarDatos.datos.Id = Id
        enviarDatos.Consulta = true
        if (entidad.TipoTipoUsuario == "ALCALDIA") {
            $location.url('/Index/TableroPat/GestionMunicipal');
        } else {
            $location.url('/Index/TableroPat/GestionDepartamental');
        }
    }
}])
;