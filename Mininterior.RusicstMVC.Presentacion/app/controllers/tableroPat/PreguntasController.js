app.controller('PreguntasController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout) {
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.cargoDatos = false;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Descripción') {
                value = value.replace(/”/g, "");
                value = value.replace(/“/g, "");
                value = value.replace(/–/g, "-");
            }
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            if (col.colDef.displayName === 'Apoyo Departamental') value === true ? value = "SI" : value = "NO";
            if (col.colDef.displayName === 'Apoyo Entidad Nacional') value === true ? value = "SI" : value = "NO";
            if (col.colDef.displayName === 'Requiere Adjunto') value === true ? value = "SI" : value = "NO";
            return value;
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
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.Editar(row.entity)">Modificar</a></div>',
            enableFiltering: false,
            pinnedLeft: true,
            enableCellEdit: false,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
    }
    var columsNoVisibles = ["IdDerecho", "IdComponente", "IdMedida", "IdUnidadMedida"];


    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "PreguntaIndicativa", newProperty: "Pregunta Indicativa" },
            { field: "PreguntaCompromiso", newProperty: "Pregunta Compromiso" },
            { field: "UnidadMedida", newProperty: "Unidad de Medida" },
            { field: "IdTablero", newProperty: "Tablero" },
            { field: "Id", newProperty: "N°" },
            { field: "ApoyoDepartamental", newProperty: "Apoyo Departamental" },
            { field: "ApoyoEntidadNacional", newProperty: "Apoyo Entidad Nacional" },
            { field: "RequiereAdjunto", newProperty: "Requiere Adjunto" },
            { field: "ExplicacionPregunta", newProperty: "Explicación Pregunta" },
            { field: "MensajeAdjunto", newProperty: "Mensaje Adjunto" }

        ]
    };
    var checboxCell = {
        action: "CambiarDefinicion",
        definition: "cellTemplate",
        parameters: [
            { field: "Activo", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
            { field: "ApoyoDepartamental", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
            { field: "ApoyoEntidadNacional", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
            { field: "RequiereAdjunto", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
        ]
    };
    var actionJsonExport = {
        action: "CambiarDefinicion",
        definition: "exporterSuppressExport",
        parameters: [
            { field: "IdDerecho", newProperty: true },
            { field: "IdComponente", newProperty: true },
            { field: "IdMedida", newProperty: true },
            { field: "IdUnidadMedida", newProperty: true },
        ]
    };
    var actionJsonTamano = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "Id", newProperty: "40" },
            { field: "IdTablero", newProperty: "40" },
            { field: "Nivel", newProperty: "40" },
            { field: "Activo", newProperty: "50" },
            { field: "ApoyoDepartamental", newProperty: "50" },
            { field: "ApoyoEntidadNacional", newProperty: "50" },
            { field: "RequiereAdjunto", newProperty: "50" },
            { field: "MensajeAdjunto", newProperty: "50" },
            { field: "ExplicacionPregunta", newProperty: "50" },
        ]
    };

    getDatos();

    function getDatos() {
        var url = '/api/TableroPat/Preguntas/';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            //agregarColumnasFijas();
            if (!$scope.isColumnDefs) {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                $scope.isColumnDefs = true;
            } else {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
            }
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            UtilsService.utilsGridOptions($scope.gridOptions, checboxCell);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJsonTamano);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJsonExport);

        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    $scope.Editar = function (pregunta) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/PreguntasPat.html',
            controller: 'PreguntaEdicionController',
            resolve: {
                pregunta: function () {
                    if (pregunta) {
                        return angular.copy(pregunta);
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (mensaje) {
                $scope.isColumnDefs = true;
                mostrarMensaje(mensaje.respuesta);
            }
           );
    };
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
                 getDatos();
             }
           );
    }
}])

app.controller('PreguntaEdicionController', ['$scope', 'APIService', '$http', 'pregunta', '$uibModalInstance', '$filter', '$log', 'authService', function ($scope, APIService, $http, pregunta, $uibModalInstance, $filter, $log, authService) {
    $scope.pregunta = pregunta || { Id: 0, ApoyoDepartamental: false, ApoyoEntidadNacional: false, Activo: true };
    $scope.habilita = false;
    $scope.Niveles = [{ Id: 1, Descripcion: 'Nacional' }, { Id: 2, Descripcion: 'Departamental' }, { Id: 3, Descripcion: 'Municipal' }]
    $scope.init = function () {
        var url = "/api/TableroPat/CargarEdicionPreguntas/";
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.Derechos = datos.derechos;
                $scope.Componentes = datos.componentes;
                $scope.Medidas = datos.medidas;
                $scope.UnidadesMedidas = datos.unidadesMedida;
                $scope.Tableros = datos.tableros;
                angular.forEach($scope.Tableros, function (t) {
                    t.VigenciaInicio = new Date(t.VigenciaInicio).toLocaleDateString();
                    t.VigenciaFin = new Date(t.VigenciaFin).toLocaleDateString();
                    t.Etiqueta = t.Año;
                });
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.submitted = false;
    };

    $scope.errors = [];

    $scope.init();

    $scope.guardar = function () {
        if (!$scope.validar()) return false;
        $scope.habilita = true;
        var url = "/api/TableroPat/ModificarPreguntas/";

        //// Cargar los datos de auditoría
        $scope.pregunta.AudUserName = authService.authentication.userName;
        $scope.pregunta.AddIdent = authService.authentication.isAddIdent;
        $scope.pregunta.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.pregunta, url);
        servCall.then(function (response) {
            $scope.flagVariable = false;
            response.data.Id = $scope.pregunta.Id;
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.data.ExceptionMessage;
        });
    };

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.validar = function () {
        return $scope.registerForm.$valid;
    };
}]);