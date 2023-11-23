app.controller('GestionarRolesController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$templateCache', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $templateCache, authService) {
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
            name: 'Modificar',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.PopUpNuevoRol(row.entity)">Modificar</a></div>',
            enableFiltering: false,
            pinnedRigth: true,
            minWidth: 100,
            maxWidth: 100,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        },
        {
            name: 'Eliminar',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.openPopUpEliminar(row.entity)">Eliminar</a></div>',
            enableFiltering: false,
            pinnedRigth: true,
            minWidth: 100,
            maxWidth: 100,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        }
    ];

    var columnsNoVisibles = ["Id", "AudUserName", "AddIdent", "UserNameAddIdent", "Excepcion", "ExcepcionMensaje"];
    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;
    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    var url = '/api/Usuarios/GestionarRoles?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
    getDatos();
    function getDatos() {
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    //------------------------Lógica de Modal de Acciones -----------------------------------------
    $scope.PopUpNuevoRol = function (entity) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/NuevoEditarRol.html',
            controller: 'ModalNuevoEditarRolController',
            backdrop: 'static', keyboard: false, size: 'lg',
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
                if (resultado.estado === 1) mensaje = "El Rol fue creado satisfactoriamente";
                if (resultado.estado === 2) mensaje = "El Rol fue actualizado satisfactoriamente";
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

                        var url = '/api/Usuarios/GestionarRoles/Eliminar/';
                        var msn = "Está seguro de eliminar el Rol con nombre: " + entity.Nombre;
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
                var mensaje = 'El Rol ' + entity.Nombre + ' fue eliminado satisfactoriamente.';
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

app.controller('ModalNuevoEditarRolController', ['$scope', 'APIService', 'UtilsService', '$filter', '$log', '$uibModalInstance', '$uibModal', '$http', 'entity', 'authService', function ($scope, APIService, UtilsService, $filter, $log, $uibModalInstance, $uibModal, $http, entity, authService) {
    $scope.lang = 'es';
    $scope.registro = entity || {};
    $scope.datos = {};
    $scope.isNew = $.isEmptyObject($scope.registro);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '';
    $scope.registro.incluir = false;
    $scope.registro.idsUsuariosArray = [];

    //// REJILLA CON LOS USUARIOS NO INCLUIDOS
    $scope.getDatosUsuarios = function (isColumnDef) {
        var url = '/api/Usuarios/GestionarRoles/TraerUsuariosRelacionados?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent + '&idRol=' + $scope.roles + '&incluidos=' + $scope.registro.incluir;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.registro.idsUsuariosArray = [];
            $scope.isColumnDefs = isColumnDef;
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

    if ($scope.isNew) {
        $scope.url = '/api/Usuarios/GestionarRoles/Insertar';
        $scope.registro.Nombre = '';
        $scope.titulo = "Nuevo Rol";
    } else {
        $scope.url = '/api/Usuarios/GestionarRoles/Modificar';
        $scope.titulo = "Editar Rol";
        $scope.roles = entity.Id;
        $scope.getDatosUsuarios(false);
    }

    $scope.cancelar = function () {
        $uibModalInstance.close();
    };

    $scope.aceptar = function () {
        if (!$scope.validar()) return false;
        $scope.cargando = true;
        guardarDatos();
    };

    //// Guarda el Rol y activa la rejilla para relacionar los usuarios
    function guardarDatos() {

        $scope.registro.AudUserName = authService.authentication.userName;
        $scope.registro.AddIdent = authService.authentication.isAddIdent;
        $scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.registro, $scope.url);
        servCall.then(function (response) {
            $scope.cargando = false;
            $scope.roles = response.data;

            mostrarMensaje("Se guardó el nombre del rol correctamente");
        }, function (error) {
            $scope.cargando = false;
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    function mostrarMensaje(mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    var enviar = { msn: mensaje, tipo: "alert alert-success" };
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
             function () {
                 $scope.getDatosUsuarios(!$scope.isNew);
             }
           );
    }

    //// Rejilla de Usuarios
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Usuario') value = UtilsService.exportPdfColumnLarge(col, value);
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);

            //Selección de datos
            gridApi.selection.on.rowSelectionChanged($scope, function (row) {
                if (row.isSelected) {
                    $scope.registro.idsUsuariosArray.push(row.entity.IdUser);
                } else {
                    var index = $scope.registro.idsUsuariosArray.indexOf(row.entity.IdUser);
                    if (index != -1) {
                        $scope.registro.idsUsuariosArray.splice(index, 1);
                    }

                }
            });

            gridApi.selection.on.rowSelectionChangedBatch($scope, function (rows) {

                rows = rows.slice(0, 100);
                angular.forEach(rows, function (row, key) {
                    if (row.isSelected) {
                        $scope.registro.idsUsuariosArray.push(row.entity.IdUser);
                    } else {
                        var index = $scope.registro.idsUsuariosArray.indexOf(row.entity.IdUser);
                        if (index != -1) {
                            $scope.registro.idsUsuariosArray.splice(index, 1);
                        }
                    }
                })
            });

            //gridApi.grid.options.exporterPdfTableHeaderStyle = { fontSize: 8, bold: true, color: 'white', fillColor: '#63002D', alignment: 'center' };
            //gridApi.grid.options.exporterPdfDefaultStyle = { fontSize: 7 };
            //gridApi.grid.options.exporterPdfCustomFormatter = function (docDefinition) {
            //    debugger
            //    docDefinition.styles.headerStyle = { fontSize: 10, bold: true, alignment: 'center', color: '#63002D' };
            //    docDefinition.styles.footerStyle = { fontSize: 8, bold: true, alignment: 'center', color: '#333333' };
            //    return docDefinition;
            //}
        },
    };

    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "TipoUsuario", newProperty: "Tipo Usuario" },
        ]
    };

    var columnsNoVisibles = ["Id", "IdUser"];
    var columnActions = null;
    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;
    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    //============================================================================
    //  Incluye o retira los usuarios del rol
    //============================================================================
    $scope.enviar = function () {

        $scope.datos.IdsUsuarios = $scope.registro.idsUsuariosArray.toString();
        $scope.datos.IdRol = $scope.roles;
        $scope.datos.Incluir = !$scope.registro.incluir;

        $scope.datos.AudUserName = authService.authentication.userName;
        $scope.datos.AddIdent = authService.authentication.isAddIdent;
        $scope.datos.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var url = '/api/Usuarios/GestionarRoles/GestionarUsuariosAlRol/';
        var servCall = APIService.saveSubscriber($scope.datos, url);

        servCall.then(function (datos) {

            if ($.isEmptyObject(datos.data)) {
                $scope.registro.idsUsuariosArray = [];
                $scope.getDatosUsuarios(true);
            }
            else
                $scope.error = $scope.registro.incluir ? "No fue posible INCLUIR los USUARIOS" : "No fue posible RETIRAR los USUARIOS";
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.registro.idsUsuariosArray = [];
            $scope.error = "Se generó un error en la petición";
        });
    };
}]);