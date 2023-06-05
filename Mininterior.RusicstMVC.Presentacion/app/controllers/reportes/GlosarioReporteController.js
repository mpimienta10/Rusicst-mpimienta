app.controller('GlosarioReporteController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, authService) {
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.cargoDatos = false;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            //-----------------Insertar texto en un string--------------------------
            String.prototype.splice = function (idx, rem, str) {
                return this.slice(0, idx) + str + this.slice(idx + Math.abs(rem));
            };

            //Quebrar líne para los usuarios
            if (col.colDef.displayName === 'Descripción') {
                var indexUltimoUnderscore = value.lastIndexOf("planet");

            }
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

        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 100,
            name: '#',
            field: 'modificar',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.abrirModalNuevoEditarTermino(row.entity)">Modificar</a></div>',
            enableFiltering: false,
            pinnedLeft: true,
            enableCellEdit: false,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
        columnDefsJsonFijas = {
            minWidth: 100,
            width: 100,
            name: ' ',
            field: 'eliminar',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.abrirModalEliminarTerminmo(row.entity)">Eliminar</a></div>',
            enableFiltering: false,
            pinnedRight: true,
            enableCellEdit: false,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
    }

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Termino", newProperty: "Término" },
            { field: "Descripcion", newProperty: "Descripción" },
        ]
    };
    var actionJson1 = {
        action: "CambiarDefinicion",
        definition: "exporterSuppressExport",
        parameters: [
            { field: "Clave", newProperty: true },
        ]
    };
    var columsNoVisibles = ["Clave"];

    getDatos();
    function getDatos() {
        var url = '/api/Reportes/Glosario/';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            agregarColumnasFijas();

            if (!$scope.isColumnDefs) {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                $scope.isColumnDefs = true;
            } else {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
            }
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson1);
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    //--------------------------------- Acciones Crear Nuevo y Eliminar---------------------------------------------------
    $scope.abrirModalNuevoEditarTermino = function (termino) {
        var modalInstance = $uibModal.open({
            templateUrl: '/app/views/reportes/modals/NuevoEditarTerminoGlosario.html',
            controller: 'ModalNuevoEditarTerminoGlosarioController',
            resolve: {
                termino: function () {
                    if (termino) {
                        return angular.copy(termino);
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (mensaje) {
                if (mensaje !== false) {
                    $scope.isColumnDefs = true;
                    getDatos();
                    UtilsService.abrirRespuesta(mensaje);
                }
            }
           );
    };

    $scope.abrirModalEliminarTerminmo = function (termino) {
        $scope.termino = termino;
        var modalInstance = $uibModal.open({
            templateUrl: '/app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            resolve: {
                datos: function () {
                    if (termino.Clave) {

                        termino.AudUserName = authService.authentication.userName;
                        termino.AddIdent = authService.authentication.isAddIdent;
                        termino.UserNameAddIdent = authService.authentication.userNameAddIdent;

                        var enviar = { url: '/api/Reportes/Glosario/Eliminar/', msn: '¿Está seguro que desea realizar la eliminación del término "' + termino.Termino + '"?', entity: termino };
                        return enviar;
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
                $scope.isColumnDefs = true;
                getDatos();
                var mensaje = { msn: 'El término "' + $scope.termino.Termino + '" fue eliminado satisfactoriamente.', tipo: 'alert alert-success' }
                UtilsService.abrirRespuesta(mensaje);
            }
           );
    };
}]);

app.controller('ModalNuevoEditarTerminoGlosarioController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', 'termino', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, termino, authService) {
    $scope.glosario = termino || {};
    if (termino) {
        $scope.modificar = true;
        $scope.url = '/api/Reportes/Glosario/Modificar';
    } else {
        $scope.modificar = false;
        $scope.url = '/api/Reportes/Glosario/Insertar';
    }

    $scope.cancelar = function () {
        $uibModalInstance.close(false);
    };

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {

        $scope.glosario.AudUserName = authService.authentication.userName;
        $scope.glosario.AddIdent = authService.authentication.isAddIdent;
        $scope.glosario.UserNameAddIdent = authService.authentication.userNameAddIdent;

        if (!$scope.modificar) $scope.glosario.Clave = $scope.glosario.Termino;
        var servCall = APIService.saveSubscriber($scope.glosario, $scope.url);
        servCall.then(function (response) {
            var mensaje = {};
            switch (response.data.estado) {
                case 0:
                    $scope.error = response.data.respuesta;
                    break;
                case 1:
                    mensaje = { msn: 'El nuevo término fue adicionado al glosario satisfactoriamente', tipo: 'alert alert-success' };
                    $uibModalInstance.close(mensaje);
                    break;
                case 2:
                    mensaje = { msn: response.data.respuesta, tipo: 'alert alert-success' };
                    $uibModalInstance.close(mensaje);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos: " + error.data.respuesta;
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);

