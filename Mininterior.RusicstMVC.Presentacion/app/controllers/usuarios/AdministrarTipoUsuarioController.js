app.controller('AdministrarTipoUsuarioController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$templateCache', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $templateCache, authService) {
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
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.PopUpNuevoEditarTipoUsuario(row.entity)">Modificar</a></div>',
            enableFiltering: false,
            pinnedLeft: true,
            minWidth: 80,
            maxWidth: 120,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        },
        {
            name: 'Eliminar',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.openPopUpEliminar(row.entity)">Eliminar</a></div>',
            enableFiltering: false,
            pinnedRigth: true,
            minWidth: 80,
            maxWidth: 120,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        }
    ];

    var changeWidth = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "Activo", newProperty: 80 }
        ]
    };

    var changeMinWidth = {
        action: "CambiarDefinicion",
        definition: "minWidth",
        parameters: [
            { field: "Activo", newProperty: 80 }
        ]
    };

    var columnsNoVisibles = ["Id"];
    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    var checboxCell = {
        action: "CambiarDefinicion",
        definition: "cellTemplate",
        parameters: [{ field: "Activo", newProperty: '<input style="vertical-align: middle; display: block; margin-right: auto; margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' }]
    };

    var optionsFilter = [{ value: false, label: "NO" }, { value: true, label: "SI" }]
    var filters = [{ selectOptions: optionsFilter, term: '', type: uiGridConstants.filter.SELECT, condition: uiGridConstants.filter.EXACT, disableCancelFilterButton: true, }, { condition: uiGridConstants.filter.CONTAINS, }];
    var filtersChange = {
        action: "CambiarDefinicion",
        definition: "filters",
        parameters: [
            { field: "Activo", newProperty: filters },
        ]
    };

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    getDatos();

    function getDatos() {
        var url = '/api/Usuarios/TipoUsuario?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
            UtilsService.utilsGridOptions($scope.gridOptions, changeWidth);
            UtilsService.utilsGridOptions($scope.gridOptions, changeMinWidth);
            UtilsService.utilsGridOptions($scope.gridOptions, checboxCell);
            UtilsService.utilsGridOptions($scope.gridOptions, filtersChange);
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    //------------------------ Lógica de Modal de Acciones -----------------------------------------
    $scope.PopUpNuevoEditarTipoUsuario = function (entity) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/NuevoEditarTipoUsuarios.html',
            controller: 'ModalNuevoEditarTipoUsuarioController',
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
                var mensaje;
                if (resultado.estado === 1) mensaje = "El Tipo de Usuario fue creado satisfactoriamente";
                if (resultado.estado === 2) mensaje = "El Tipo de Usuario fue actualizado satisfactoriamente";
                openRespuesta(mensaje);
            }
           );
    };

    $scope.openPopUpEliminar = function (entity) {
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

                        var url = '/api/Usuarios/TipoUsuario/Eliminar/';
                        var msn = "Está seguro de eliminar el tipo de usuario con nombre: " + entity.Nombre;
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
                var mensaje = 'El Tipo de Usuario ' + entity.Nombre + ' fue eliminado satisfactoriamente.';
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
}]);

app.controller('ModalNuevoEditarTipoUsuarioController', ['$scope', 'APIService', 'UtilsService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'authService', function ($scope, APIService, UtilsService, $filter, $log, $uibModalInstance, $http, entity, authService) {
    $scope.registro = entity || {};
    $scope.isNew = $.isEmptyObject($scope.registro);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '';
    if ($scope.isNew) {
        $scope.url = '/api/Usuarios/TipoUsuario/Insertar';
        $scope.registro.Tipo = '';
        $scope.registro.Nombre = '';
        $scope.registro.Activo = false;
        $scope.titulo = "Nuevo Tipo de Usuario";
    } else {
        $scope.url = '/api/Usuarios/TipoUsuario/Modificar';
        $scope.titulo = "Editar Tipo de Usuario";
    }

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {
        $scope.registro.AudUserName = authService.authentication.userName;
        $scope.registro.AddIdent = authService.authentication.isAddIdent;
        $scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.registro, $scope.url);
        servCall.then(function (response) {
            var resultado = {};
            resultado.estado = response.data.estado
            switch (response.data.estado) {
                case 0:
                    $scope.error = response.data.respuesta;
                    break;
                case 1:
                    $uibModalInstance.close(resultado);
                    break;
                case 2:
                    $uibModalInstance.close(resultado);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    function DoubleScroll(element) {
        var scrollbar = document.createElement('div');
        scrollbar.appendChild(document.createElement('div'));
        scrollbar.style.overflow = 'auto';
        scrollbar.style.overflowY = 'hidden';
        scrollbar.firstChild.style.width = element.scrollWidth + 'px';
        scrollbar.firstChild.style.paddingTop = '1px';
        scrollbar.firstChild.appendChild(document.createTextNode('\xA0'));
        scrollbar.onscroll = function () {
            element.scrollLeft = scrollbar.scrollLeft;
        };
        element.onscroll = function () {
            scrollbar.scrollLeft = element.scrollLeft;
        };
        element.parentNode.insertBefore(scrollbar, element);
    }

    DoubleScroll(document.getElementById('doublescroll'));
}]);