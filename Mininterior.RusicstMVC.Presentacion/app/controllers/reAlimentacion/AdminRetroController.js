app.controller('AdminRetroController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService) {

    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.cargoDatos = null;
    $scope.TituloModificar = "Nombre";
    $scope.IdModificar = 0;
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

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Nombre", newProperty: "Título" },
            { field: "Titulo", newProperty: "Encuesta Relacionada" },
        ]
    };

    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid'); }
    });

    function agregarColumnasFijas() {
        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 100,
            field: 'Modificar',
            name: 'Modificar',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.ModificarRetroAdminEncuesta(row.entity.Id, row.entity.Nombre)">Modificar</a></div>',
            enableFiltering: false,
            pinnedRight: true,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);

        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 100,
            field: 'Eliminar',
            name: 'Eliminar',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.EliminarRetroAdminEncuesta(row.entity)">Eliminar</a></div>',
            enableFiltering: false,
            pinnedRight: true,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
    };

    function cargarComboEncuesta() {
        var url = '/api/General/Listas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de combo de encuestas";
        });
    }

    function cargarRealimentaciones() {
        var url = '/api/ReAlimentacion/ObtenerAdminRetro/';
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                if (datos.length > 0) {
                    $scope.cargoDatos = true;
                    $scope.isGrid = true;
                    $scope.gridOptions.data = datos;
                    agregarColumnasFijas();
                    var columsNoVisibles = ["Id", "IdEncuesta"];
                    if (!$scope.isColumnDefs) {
                        UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                        $scope.isColumnDefs = true;
                    } else {
                        UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                    }
                    UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                }
            }, function (error) {
                $scope.cargoDatos = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
    };

    $scope.crearRealimentacion = function () {
        var url = '/api/ReAlimentacion/InsertarAdminRetro/';
        getDatos();
        function getDatos() {

            $scope.Retro.AudUserName = authService.authentication.userName;
            $scope.Retro.AddIdent = authService.authentication.isAddIdent;
            $scope.Retro.UserNameAddIdent = authService.authentication.userNameAddIdent;

            var servCall = APIService.saveSubscriber($scope.Retro, url);

            servCall.then(function (response) {
                switch (response.data.estado) {
                    case 0:
                        var mensaje = { msn: response.data.respuesta, tipo: "alert alert-warning" };
                        openRespuesta(mensaje);
                        break;
                    case 1:
                        var mensaje = { msn: "La Retroalimentación fue creada satisfactoriamente", tipo: "alert alert-success" };
                        openRespuesta(mensaje);
                        $scope.Retro.Titulo = "";
                        $scope.Retro.IdEncuesta = "0";
                        break;
                }
                cargarRealimentaciones();
            }, function (error) {
                $scope.cargoDatos = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
    };

    $scope.cancelar = function () {
        if ($scope.Retro != undefined || $scope.Retro != null) {
            $scope.Retro.Titulo = "";
            $scope.Retro.IdEncuesta = "0";
        }
    };


    cargarRealimentaciones();
    cargarComboEncuesta();

    //Confirmación
    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({

            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    var enviar = mensaje
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
            });
    };

    $scope.ModificarRetroAdminEncuesta = function (id, Nombre) {
        var $panel = angular.element($("#PanelMRM")).scope();
        $panel.mostrarRetroModificar = 1;
        $scope.TituloModificar = Nombre;
        $scope.IdModificar = id;
    }

    $scope.EliminarRetroAdminEncuesta = function (entity) {

        entity.AudUserName = authService.authentication.userName;
        entity.AddIdent = authService.authentication.isAddIdent;
        entity.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var enviar = { url: '/api/ReAlimentacion/EliminarAdminRetro/', msn: "¿Está seguro de eliminar la Retroalimentación?", entity: entity };
        var templateUrl = 'app/views/modals/ConfirmacionEliminar.html';
        var controller = 'ModalEliminarController';
        var cont = 0;
        var modalInstance = $uibModal.open({
            templateUrl: templateUrl,
            controller: controller,
            resolve: {
                datos: function () {
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
                cargarRealimentaciones();
            }
        );
    }
   
    $scope.modificarRealimentacion = function () {
        $scope.model = {};
        var url = '/api/ReAlimentacion/ModificarAdminRetro/';
        getDatos();
        function getDatos() {
            $scope.model.Id = $scope.IdModificar;
            $scope.model.Titulo = $scope.TituloModificar;
            $scope.model.AudUserName = authService.authentication.userName;
            $scope.model.AddIdent = authService.authentication.isAddIdent;
            $scope.model.UserNameAddIdent = authService.authentication.userNameAddIdent;

            var servCall = APIService.saveSubscriber($scope.model, url);

            servCall.then(function (response) {
                switch (response.data.estado) {
                    case 0:
                        var mensaje = { msn: response.data.respuesta, tipo: "alert alert-warning" };
                        openRespuesta(mensaje);
                        break;
                    case 2:
                        var mensaje = { msn: "La Retroalimentación fue actualizada satisfactoriamente", tipo: "alert alert-success" };
                        openRespuesta(mensaje);
                        $scope.TituloModificar = "";
                        break;
                }
                cargarRealimentaciones();
            }, function (error) {
                $scope.cargoDatos = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
    };
}]);