app.controller('AdministrarUsuariosController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$templateCache', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $templateCache, authService) {
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
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpNuevoEditarUsuario(row.entity)">Modificar</a></div>',
            enableFiltering: false,
            pinnedLeft: true,
            minWidth: 70,
            width: 70,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        },
        {
            name: '  ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.openPopUpConfirmacion(row.entity)">Adquirir Identidad</a></div>',
            enableFiltering: false,
            enablePinning: true,
            pinnedRigth: true,
            minWidth: 145,
            width: 145,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        },
        {
            name: '    ',
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
        "Id",
        "IdUser",
        "IdTipoUsuario",
        "IdDepartamento",
        "IdMunicipio",
        "IdEstado",
        "Estado",
        "IdUsuarioTramite",
        "TelefonoFijoIndicativo",
        "TelefonoFijoExtension",
        "EmailAlternativo",
        "Enviado",
        "DatosActualizados",
        "Token",
        "FechaNoRepudio",
        "FechaTramite",
        "FechaConfirmacion",

        "FechaSolicitud",
        "Cargo",
        "TelefonoFijo",
        "TelefonoCelular",
        "Email",
        "Municipio",
        "DocumentoSolicitud",

        "NombresYUsername",

        "TipoTipoUsuario"
    ];

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Nombres", newProperty: "Nombres y Apellidos" },
            { field: "TipoUsuario", newProperty: "Tipo de Usuario" },
            { field: "UserName", newProperty: "Usuario" }
        ]
    };

    var widthChange = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "TipoUsuario", newProperty: 140 },
            { field: "Departamento", newProperty: 135 },
            { field: "Activo", newProperty: 80 },
        ]
    };

    var minWidthChange = {
        action: "CambiarDefinicion",
        definition: "minWidth",
        parameters: [
            { field: "TipoUsuario", newProperty: 140 },
            { field: "Departamento", newProperty: 135 },
            { field: "Activo", newProperty: 80 },
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

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    getDatos();

    function getDatos() {
        var url = '/api/Usuarios/Usuarios?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            UtilsService.utilsGridOptions($scope.gridOptions, widthChange);
            UtilsService.utilsGridOptions($scope.gridOptions, minWidthChange);
            UtilsService.utilsGridOptions($scope.gridOptions, checboxCell);
            UtilsService.utilsGridOptions($scope.gridOptions, filtersChange);

        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    $scope.PopUpNuevoEditarUsuario = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/NuevoEditarUsuarios.html',
            controller: 'ModalNuevoEditarUsuarioController',
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
                 var mensaje = 'Los datos de contacto de ' + resultado.Nombres.toUpperCase() + ' han sido actualizados satisfactoriamente.';
                 openRespuesta(mensaje);
             }
        );
    };

    //// Mensaje respuesta
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
        $scope.Nombres = entity.Nombres.toUpperCase();
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

                        var url = '/api/Usuarios/Usuarios/Eliminar/';
                        var msn = "Está seguro de eliminar el usuario con nombre: " + $scope.Nombres;
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
                 var mensaje = 'El usuario ' + $scope.Nombres + ' ha sido eliminado satisfactoriamente.';
                 openRespuesta(mensaje);
             }
        );
    };

    //// Confirmación para adquirir identidad
    $scope.openPopUpConfirmacion = function (entity) {
        debugger;
        var modalInstance = $uibModal.open({
            templateUrl: '/app/views/modals/Confirmacion.html',
            controller: 'ModalConfirmacionController',
            backdrop: 'static', keyboard: false,
            resolve: {
                datos: function () {
                    var titulo = 'Adquirir Identidad';
                    var msn = "¿Está seguro que quiere adquirir la identidad del usuario " + entity.UserName + " ?";
                    return { method: "AddIdentity", entity: entity, msn: msn, titulo: titulo }
                }
            }
        });
        modalInstance.result.then(
            function (response) {
                authService.addIdentity(entity);
            }
        );
    };
}]);

app.controller('ModalNuevoEditarUsuarioController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.registro = entity || {};
    $scope.registro.IdTipoUsuario = null != entity.IdTipoUsuario ? entity.IdTipoUsuario.toString() : null;
    $log.log(entity);
    $scope.isNew = $.isEmptyObject($scope.registro);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '';

    if ($scope.isNew) {
        $scope.url = '/api/Usuarios/Usuarios/Insertar';
    } else {
        $scope.url = '/api/Usuarios/Usuarios/Modificar';
        UtilsService.getDatosUsuarioAutenticado().respuesta().then(function (respuesta) {
            $scope.usuarioAutenticado = respuesta;
        });
    }

    //// Obtener el Tipo de Usuario
    getDatosTipoUsuario();

    function getDatosTipoUsuario() {
        var url = '/api/Usuarios/TipoUsuario?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.TiposUsuario = datos;
            angular.forEach($scope.TiposUsuario, function (fila) {
                $scope.TiposUsuario.IdTipoUsuario = parseInt(fila.IdTipoUsuario)
            });

        }, function (error) {
        });
    };

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {
        $scope.registro.AudUserName = authService.authentication.userName;
        $scope.registro.AddIdent = authService.authentication.isAddIdent;
        $scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.registro, $scope.url);
        servCall.then(function (response) {
            switch (response.data.estado) {
                case 0:
                    $scope.error = response.data.respuesta;
                    break;
                case 2:
                    $uibModalInstance.close($scope.registro);
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
