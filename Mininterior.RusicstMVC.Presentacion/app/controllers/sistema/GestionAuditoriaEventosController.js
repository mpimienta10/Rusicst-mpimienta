app.controller('GestionAuditoriaEventosController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', '$templateCache', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, $templateCache, authService) {
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.usuarioSeleccionado = undefined;

    $scope.isGrid = false;
    $scope.isColumnDefs = false;
    $scope.cargoDatos = false;
    $scope.datos = [];
    $scope.registro = {};
    $scope.arregloFinalFiltro = [];

    //// Carga de combo de usuarios
    function getUsuario() {
        var url = '/api/Usuarios/Usuarios?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.usuarios = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    getUsuario();

    //// Carga de combo de categorías o acciones
    function getCategory() {
        var url = '/api/General/Listas/Category?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.acciones = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    getCategory();

    //// Rejilla
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
            name: '#',
            cellTemplate: '<div class="text-center" style="padding-top:5px;"><a href="" ng-click="grid.appScope.openVerDetalles(row.entity)"><i class="fa fa-plus-square-o"></i></a></div>',
            enableFiltering: false,
            pinnedLeft: true,
            width: 80,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        }];

    var columnsNoVisibles = ["LogID", "UrlYBrowser"];
    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Categoria", newProperty: "Categoría" }
        ]
    };

    $scope.filtrar = function () {
        if (!$scope.validar()) return false;
        getDatos();
    }

    var getDatos = function () {
        $scope.cargoDatos = true;
        var url = '/api/Sistema/LogXCategoria/';
        $scope.registro.UserName = $scope.usuarioSeleccionado !== undefined ? $scope.usuarioSeleccionado.UserName : null;
        //$scope.registro.CategoryId = $scope.CategoryId !== undefined ? $scope.usuarioSeleccionado.CategoryId : null;
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (datos) {
            if (datos.data.length > 0) {
                $scope.isGrid = true;
                $scope.gridOptions.data = datos.data;
                $scope.alerta = '';
                if (!$scope.isColumnDefs) {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
                    UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                    $scope.isColumnDefs = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
                }
            } else {
                $scope.isGrid = false;
                $scope.isColumnDefs = false;
                $scope.alerta = "No se encontraron datos";
            };
            $scope.cargoDatos = false;
        }, function (error) {
            $scope.cargoDatos = false;
            $scope.error = "Se generó un error en la petición";
        });
    }

    $scope.exportar = function () {
        if (!$scope.validar()) return false;
        getDatosExportar();
    }

    var getDatosExportar = function () {
        var FechaIni = $scope.registro.FechaInicio.getMonth() + 1 + '/' + $scope.registro.FechaInicio.getDate() + '/' + $scope.registro.FechaInicio.getFullYear();
        var FechaFin = $scope.registro.FechaFin.getMonth() + 1 + '/' + $scope.registro.FechaFin.getDate() + '/' + $scope.registro.FechaFin.getFullYear();

        if ($scope.usuarioSeleccionado == null && $scope.registro.CategoryId == null)
            var url = $scope.serviceBase + '/api/Sistema/LogXCategoriaExportar/?pCategoria=' + 0 + '&pUserName=' + null + '&pFechaIni=' + FechaIni + '&pFechaFin=' + FechaFin;
        else if ($scope.usuarioSeleccionado == null && $scope.registro.CategoryId != null)
            var url = $scope.serviceBase + '/api/Sistema/LogXCategoriaExportar/?pCategoria=' + $scope.registro.CategoryId + '&pUserName=' + null + '&pFechaIni=' + FechaIni + '&pFechaFin=' + FechaFin;
        else if ($scope.usuarioSeleccionado != null && $scope.registro.CategoryId == null)
            var url = $scope.serviceBase + '/api/Sistema/LogXCategoriaExportar/?pCategoria=' + 0 + '&pUserName=' + $scope.usuarioSeleccionado.UserName + '&pFechaIni=' + FechaIni + '&pFechaFin=' + FechaFin;
        else
            var url = $scope.serviceBase + '/api/Sistema/LogXCategoriaExportar/?pCategoria=' + $scope.registro.CategoryId + '&pUserName=' + $scope.usuarioSeleccionado.UserName + '&pFechaIni=' + FechaIni + '&pFechaFin=' + FechaFin;
        window.open(url)
    }

    $scope.validar = function () {
        $scope.dateNoMatch = $scope.registro.FechaInicio > $scope.registro.FechaFin;
        valido = !$scope.dateNoMatch;
        return valido;
    };

    $scope.openVerDetalles = function (entity) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/VerDetallesColumna.html',
            controller: 'ModalVerAuditoriaController',
            backdrop: 'static', keyboard: false,
            size: 'lg',
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
    };

    //====================================================================
    //--------------------- DataPicker -----------------------------------
    //====================================================================
    $scope.registro = {};
    $scope.today = function () {
        $scope.registro.FechaFin = new Date();
        $scope.registro.FechaInicio = new Date();
    };
    $scope.today();
    $scope.clear = function () {
        $scope.registro.FechaFin = null;
        $scope.registro.FechaInicio = null;
    };

    $scope.dateOptions = {
        formatYear: 'yy',
        maxDate: new Date(2030, 5, 22),
        minDate: new Date(2010, 1, 1),
        startingDay: 1
    };

    $scope.open1 = function () {
        $scope.dateNoMatch = false;
        $scope.popup1.opened = true;
    };

    $scope.open2 = function () {
        $scope.dateNoMatch = false;
        $scope.popup2.opened = true;
    };

    $scope.format = "dd/MM/yyyy";

    $scope.popup1 = {
        opened: false
    };

    $scope.popup2 = {
        opened: false
    };

    function getDayClass(data) {
        var date = data.date,
            mode = data.mode;
        if (mode === 'day') {
            var dayToCheck = new Date(date).setHours(0, 0, 0, 0);

            for (var i = 0; i < $scope.events.length; i++) {
                var currentDay = new Date($scope.events[i].date).setHours(0, 0, 0, 0);

                if (dayToCheck === currentDay) {
                    return $scope.events[i].status;
                }
            }
        }
        return '';
    }
}]);

app.controller('ModalVerAuditoriaController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity) {
    //--------------------Inicio-------------------------------------
    $scope.registro = entity;

    //// Carga de combo de categorías o acciones
    function getAuditoria() {
        var url = '/api/Sistema/Log?logId=' + entity.LogID;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            entity = datos;
            $scope.items = [
                { label: "Usuario", value: entity.Title },
                { label: "Mensaje Auditado", value: entity.FormattedMessage }
            ];
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    getAuditoria();

    function getDato(dato) {
        if (dato == null || dato.length == 0 || dato.trim() == '') return "Sin información";
        return dato;
    }

    $scope.cancelar = function () {
        $uibModalInstance.close(false);
    };
}]);

