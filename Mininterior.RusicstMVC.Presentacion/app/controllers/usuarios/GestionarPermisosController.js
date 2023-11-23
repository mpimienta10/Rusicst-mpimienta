app.controller('GestionarPermisosController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', '$dsb', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, $dsb, authService) {


    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.cargoDatos = null;
    $scope.datos = [];
    $scope.isColumnDefs = false;
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        onRegisterApi: function (gridApi) {
            gridApi.pagination.raise.paginationChanged = function (currentPage, pageSize) {
            };
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };
    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });
    var columnActions = [{
        name: ' ',
        cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.openPopUpEliminar(row.entity)">Eliminar</a></div>',
        enableFiltering: false,
        pinnedRigth: true,
        width: 100,
        enableColumnMenu: false,
        exporterSuppressExport: true,
    }];

    var columnsNoVisibles = [
        "IdTipoUsuario",
        "IdRecurso",
        "IdSubRecurso",
    ]
    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;
    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "IdRol", newProperty: "Tipo Usuario" },
            { field: "NombreRecurso", newProperty: "Menú" },
            { field: "NombreSubRecurso", newProperty: "Opción de Menú" },
        ]
    };

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    getDatos();

    function getDatos() {
        var url = '/api/Usuarios/GestionarPermisos?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
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

    $scope.openPopUp = function (entity) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/NuevoEditarGestionarPermisos.html',
            controller: 'ModalNuevoEditarGestionarPermisosController',
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
             function () {
                 $scope.isColumnDefs = true;
                 getDatos();
                 openRespuesta('Se otorga permisos al tipo de usuario satisfactoriamente')
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

                        var url = '/api/Usuarios/GestionarPermisos/Eliminar/';
                        var msn = "Está seguro de eliminar la opción de menú: " + entity.NombreSubRecurso;
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
                var mensaje = 'El permiso para la opción de menú ' + entity.NombreSubRecurso + ' fue eliminado(a) satisfactoriamente.';
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

app.controller('ModalNuevoEditarGestionarPermisosController', function ($scope, APIService, UtilsService, $filter, $log, $uibModalInstance, $http, entity, authService) {
    $scope.registro = entity || {};
    $scope.isNew = $.isEmptyObject($scope.registro);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.validacionOpcionesMenu = true;
    $scope.url = '';
    if ($scope.isNew) {
        $scope.url = '/api/Usuarios/GestionarPermisos/Insertar';
    } else {
        $scope.url = '/api/Usuarios/GestionarPermisos/Modificar';
    }

    //// Obtener tipo de roles
    var urlGetRoles = '/api/General/Listas/TipoUsuarios?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;

    getRoles();

    function getRoles() {
        var servCall = APIService.getSubs(urlGetRoles);
        servCall.then(function (datos) {
            $scope.roles = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    //// Obtener Menus
    getRecursos();
    function getRecursos() {
        var urlGetMenus = '/api/General/Listas/Recursos?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(urlGetMenus);
        servCall.then(function (datos) {
            $scope.Recursos = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    $scope.getSubRecursos = function () {

        var idRecurso = parseInt($scope.registro.IdRecurso);
        var idTipoUsuario = parseInt($scope.registro.IdTipoUsuario);
        //var urlGetMenus = '/api/General/Listas/SubRecursos?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent + '&idRecurso=' + idRecurso;
        var urlGetMenus = '/api/Usuarios/GestionarPermisosPorUsuarioyRol?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent + '&idRecurso=' + idRecurso + '&idTipoUsuario=' + idTipoUsuario;
        var servCall = APIService.getSubs(urlGetMenus);
        servCall.then(function (datos) {

            angular.forEach(datos, function (item, key) {
                item.value = item.AsignadoRol;
            });

            $scope.SubRecursos = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    }

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {

        $scope.errors = [];
        if (!$scope.validar()) return false;

        //obtener lista Id de subrecursos
        $scope.registro.ListaIdSubRecurso = getListaIdSubrecurso($scope.SubRecursos);
        $scope.registro.AudUserName = authService.authentication.userName;
        $scope.registro.AddIdent = authService.authentication.isAddIdent;
        $scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;

        if ($scope.registro.ListaIdSubRecurso === "") {
            $scope.validacionOpcionesMenu = false;
            return false;
        }


        guardarDatos();
    };

    function guardarDatos() {

        var servCall = APIService.saveSubscriber($scope.registro, $scope.url);
        servCall.then(function (response) {
            if (response.data.estado > 0) {
                switch (response.data.estado) {
                    case 0:
                        $scope.error = response.data.respuesta;
                        break;
                    case 1:
                        $uibModalInstance.close();
                        break;
                }
            } else {
                $scope.error = "Se generó un error en la petición, no se guardaron los datos." + response.data.respuesta;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    var getListaIdSubrecurso = function (items) {
        var ids = "";
        angular.forEach(items, function (item) {
            if (item.value == true) {
                ids += item.IdSubRecurso + ",";
            }
        });

        var t = ids.length;
        ids = ids.substr(0, t - 1);
        return ids;
    }
});
