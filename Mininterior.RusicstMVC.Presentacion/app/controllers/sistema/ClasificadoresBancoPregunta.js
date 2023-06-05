app.controller('ClasificadoresBancoPreguntasController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $templateCache, authService) {
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.isColumnDefs = false;
    $scope.cargoDatos = null;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };
    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    var columnActions = [
        {
            name: ' ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpNuevoEditarDetalle(row.entity)">Detalle</a></div>',
            enableFiltering: false,
            enablePinning: true,
            pinnedRigth: true,
            minWidth: 70,
            width: 70,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        }
    ];

    //// Personalizar rejilla y exportación
    var columnsNoVisibles =
    [
        "IdClasificador",
        "CodigoClasificador"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "NombreClasificador", newProperty: "Nombre Clasificador" },
        ]
    };

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/Clasificadores/';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    //------------------------Lógica de Modal de Acciones -----------------------------------------
    $scope.PopUpNuevoEditarDetalle = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/DetalleClasificador.html',
            controller: 'ModalNuevoEditarDetalleController',
            size: 'lg',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {
                        return angular.copy(entity);
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
                 $scope.isColumnDefs = true;
                 getDatos();
                 var mensaje = 'Se han actualizado los datos de la Pregunta';
                 openRespuesta(mensaje);
             }
        );
    };

    //Confirmación
    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    $scope.deshabiltarRegistrese = false;
                    var enviar = { msn: mensaje, tipo: "alert alert-success" };
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
            });
    };

    $scope.openPopUpEliminar = function (entity) {
        $scope.Codigo = entity.CodigoPregunta;
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            backdrop: 'static', keyboard: false,
            resolve: {
                datos: function () {
                    if (entity) {

                        entity.AudUserName = authService.authentication.userName;
                        entity.AddIdent = authService.authentication.isAddIdent;
                        entity.UserNameAddIdent = authService.authentication.userNameAddIdent;

                        var url = '/api/Sistema/BancoPreguntas/Eliminar/';
                        var msn = "Está seguro de eliminar la pregunta con código: " + $scope.Codigo;
                        return { url: url, msn: msn, entity: entity }
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function () {
                 $scope.isColumnDefs = true;
                 getDatos();
                 var mensaje = 'La Pregunta ' + $scope.Codigo + ' ha sido eliminada satisfactoriamente.';
                 openRespuesta(mensaje);
             }
        );
    };
    //------------------Fin Lógica de acciones---------------------
}]);

app.controller('ModalNuevoEditarDetalleController', ['$scope', 'APIService', '$filter', '$log', '$uibModal', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModal, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.clasificador = {};
    $log.log(entity);
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '';
    $scope.CodigoPregunta = '';

    $scope.clasificador.nombreClasificador = entity.NombreClasificador.toString();
    $scope.clasificador.idClasificador = entity.IdClasificador.toString();
    $scope.clasificador.codigoClasificador = entity.CodigoClasificador.toString();


    //Defs Grid

    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.isColumnDefs = false;
    $scope.cargoDatos = null;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];

    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };


    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    var columnActions = [
        {
            name: ' ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpNuevoEditarClasificador(row.entity)">Editar</a></div>',
            enableFiltering: false,
            enablePinning: true,
            pinnedRigth: true,
            minWidth: 70,
            width: 70,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        },
        {
            name: '   ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.openPopUpEliminar(row.entity)">Eliminar</a></div>',
            enableFiltering: false,
            enablePinning: true,
            pinnedRigth: true,
            minWidth: 60,
            width: 60,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        }
    ];

    //// Personalizar rejilla y exportación
    var columnsNoVisibles =
    [
        "IdDetalleClasificador",
        "ValorDefecto",
        "IdClasificador"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "NombreDetalleClasificador", newProperty: "Detalle Clasificador" },
        ]
    };

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/Clasificadores/DetallesClasificadores?idClasificador=' + $scope.clasificador.idClasificador;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    //Modal editar detalle

    $scope.PopUpNuevoEditarClasificador = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarDetalleClasificador.html',
            controller: 'ModalNuevoEditarClasificadorController',
            size: 'md',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {
                        return angular.copy(entity);
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
                 $scope.isColumnDefs = true;
                 getDatos();
                 var mensaje = 'Se han actualizado los datos del detalle del clasificador';
                 openRespuesta(mensaje);
             }
        );
    };

    $scope.PopUpNuevoClasificador = function (entity) {

        entity = $scope.clasificador.idClasificador;

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarDetalleClasificador.html',
            controller: 'ModalNuevoClasificadorController',
            size: 'md',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {
                        return angular.copy(entity);
                    } else {
                        return $scope.clasificador.idClasificador;
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
                 $scope.isColumnDefs = true;
                 getDatos();
                 var mensaje = 'Se han actualizado los datos del detalle del clasificador';
                 openRespuesta(mensaje);
             }
        );
    };

    //Confirmación
    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    $scope.deshabiltarRegistrese = false;
                    var enviar = { msn: mensaje, tipo: "alert alert-success" };
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
            });
    };

    $scope.openPopUpEliminar = function (entity) {
        $scope.NombreDetalleClasificador = entity.NombreDetalleClasificador;
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            backdrop: 'static', keyboard: false,
            resolve: {
                datos: function () {
                    if (entity) {

                        entity.AudUserName = authService.authentication.userName;
                        entity.AddIdent = authService.authentication.isAddIdent;
                        entity.UserNameAddIdent = authService.authentication.userNameAddIdent;

                        var url = '/api/Sistema/Clasificadores/Eliminar/';
                        var msn = "Está seguro de eliminar el Detalle de Clasificador: " + $scope.NombreDetalleClasificador;
                        return { url: url, msn: msn, entity: entity }
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function () {
                 $scope.isColumnDefs = true;
                 getDatos();
                 var mensaje = 'El Detalle de Clasificador ' + $scope.NombreDetalleClasificador + ' ha sido eliminado satisfactoriamente.';
                 openRespuesta(mensaje);
             }
        );
    };

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);

app.controller('ModalNuevoEditarClasificadorController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.detalle = {};
    $log.log(entity);
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();

    if ($scope.isNew) {
        $scope.url = '/api/Sistema/Clasificadores/Insertar/';
        $scope.detalle.nombreDetalle = '';
    }
    else {
        $scope.url = '/api/Sistema/Clasificadores/Modificar/';

        $scope.detalle.nombreDetalle = entity.NombreDetalleClasificador.toString();
        $scope.detalle.idDetalle = entity.IdDetalleClasificador.toString();
        $scope.detalle.idClasificador = entity.IdClasificador.toString();
    }

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {

        $scope.detalle.AudUserName = authService.authentication.userName;
        $scope.detalle.AddIdent = authService.authentication.isAddIdent;
        $scope.detalle.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.detalle, $scope.url);
        servCall.then(function (response) {
            $log.log(response);
            switch (response.data.estado) {
                case 0:
                    $scope.error = response.data.respuesta;
                    break;
                case 2:
                    $uibModalInstance.close($scope.detalle);
                    break;
                case 1:
                    $uibModalInstance.close($scope.detalle);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);

app.controller('ModalNuevoClasificadorController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.detalle = {};
    $log.log(entity);
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '/api/Sistema/Clasificadores/Insertar/';
    $scope.detalle.nombreDetalle = '';
    $scope.detalle.idClasificador = entity;

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {

        $scope.detalle.AudUserName = authService.authentication.userName;
        $scope.detalle.AddIdent = authService.authentication.isAddIdent;
        $scope.detalle.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.detalle, $scope.url);
        servCall.then(function (response) {
            $log.log(response);
            switch (response.data.estado) {
                case 0:
                    $scope.error = response.data.respuesta;
                    break;
                case 2:
                    $uibModalInstance.close($scope.detalle);
                    break;
                case 1:
                    $uibModalInstance.close($scope.detalle);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);