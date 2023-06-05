app.factory('myTipo', function () {
    var savedData = {}
    function set(data) {
        savedData = data;
    }
    function get() {
        return savedData;
    }
    return {
        set: set,
        get: get
    }
});

app.factory('myRetro', function () {
    var savedData = {}
    function set(data) {
        savedData = data;
    }
    function get() {
        return savedData;
    }
    return {
        set: set,
        get: get
    }
});

app.controller('ReAlimentacionController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$location', 'myTipo', 'myRetro', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $location, myTipo, myRetro, authService) {

    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.cargoDatos = null;
    $scope.IdTipoUsuario;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Validacion-') {
                value = value.replace(/”/g, "");
                value = value.replace(/“/g, "");
                value = value.replace(/–/g, "-");
            }
            return value;
        },
        exporterSuppressColumns: ['Id'],
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };

    $scope.isColumnDefs = false;
    $scope.columnDefsFijas = [];

    $scope.showDatePopup = [];
    $scope.showDatePopup.push({ opened: false });

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Nombre", newProperty: "Título" },
            { field: "Titulo", newProperty: "Encuesta Asociada" },
        ]
    };

    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    $scope.toggleFiltering = function () {
        $scope.gridOptions.enableFiltering = !$scope.gridOptions.enableFiltering;
        $scope.gridApi.core.notifyDataChange(uiGridConstants.dataChange.COLUMN);
    };

    function agregarColumnasFijas() {
        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 100,
            field: 'Consultar',
            name: '',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.goConsultar(row.entity)">Consultar</a></div>',
            enableFiltering: false,
            pinnedRight: true,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
        if ($scope.IdTipoUsuario == 1 || $scope.IdTipoUsuario == 3) {
            var columnDefsJsonFijas = {
                minWidth: 100,
                width: 100,
                field: 'Editar',
                name: 'Editar',
                cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.goEditar(row.entity)">Editar</a></div>',
                enableFiltering: false,
                pinnedRight: true,
                exporterSuppressExport: true,
            };
            $scope.columnDefsFijas.push(columnDefsJsonFijas);
        }
    }

    $scope.goConsultar = function (entidad) {
        $location.path("/Index/reAlimentacion/RetroConsulta");
        myTipo.set(0);//consulta
        myRetro.set(entidad);
    };

    $scope.goEditar = function (entidad) {
        $location.path("/Index/reAlimentacion/RetroConsulta");
        myTipo.set(1);//editar
        myRetro.set(entidad);
    };


    function cargarRealimentaciones() {
        var url = '/api/ReAlimentacion/ObtenerAdminRetro/';
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatos = true;
                $scope.isGrid = true;
                $scope.gridOptions.data = datos;
                agregarColumnasFijas();
                var columsNoVisibles = ["Id","IdEncuesta"];
                if (!$scope.isColumnDefs) {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                    $scope.isColumnDefs = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                }
                UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            }, function (error) {
                $scope.cargoDatos = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
    };

    function ObtenerUsuario() {
        var datos = { UserName: authService.authentication.userName };
        var url = '/api/Usuarios/Usuarios/BuscarXUsuario';
        var servCall = APIService.saveSubscriber(datos, url);
        servCall.then(function (datos) {
            $scope.IdTipoUsuario = datos.data[0].IdTipoUsuario;
            cargarRealimentaciones();
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };
    ObtenerUsuario();


}]);