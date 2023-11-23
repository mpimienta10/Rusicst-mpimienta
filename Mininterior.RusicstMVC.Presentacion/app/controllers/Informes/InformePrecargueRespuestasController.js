app.controller('InformePrecargueRespuestasController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService) {
    //------------------- Inicio logica de la grilla -------------------
    $scope.idEncuesta = 0;
    $scope.lang = 'es';
    $scope.cargoDatos = true;
    $scope.isGrid = false;

    //cargar el combo de reportes
    function cargarComboReportes() {
        $scope.grupos = [];
        $scope.secciones = [];
        $scope.subsecciones = [];
        var url = '/api/General/Listas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.reportes = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición del combo de encuestas";
        });
    }
    cargarComboReportes();
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Fecha de Envío') value = new Date(value).toLocaleDateString();
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
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid'); }
    });
    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };
    var columsNoVisibles = ["IdUsuario", "IdEncuesta", "IdPregunta", "TipoEncuesta"];
    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Titulo", newProperty: "Encuesta" },
            { field: "TipoEncuesta", newProperty: "Tipo Encuesta" },
            { field: "TipoPregunta", newProperty: "Tipo Pregunta" },
            { field: "ValorPrecargue", newProperty: "Valor Precargue" },
            { field: "FechaPrecargue", newProperty: "Fecha Precargue" },
            { field: "UsuarioIngreso", newProperty: "Usuario Ingreso" },
            { field: "Codigohomologado", newProperty: "Codigo homologado" },
        ]
    };
    var actionJsonExport = {
        action: "CambiarDefinicion",
        definition: "exporterSuppressExport",
        parameters: [
            { field: "IdUsuario", newProperty: true },
            { field: "IdMunicipio", newProperty: true },
            { field: "IdDepartamento", newProperty: true },
        ]
    };
    var formatDate = {
        action: "CambiarFecha",
        parameters: [
            { field: "FechaEnvio" },
        ]
    };

    $scope.buscar = function () {
        $scope.cargoDatos = false;
        $scope.alerta = null;
        $scope.error = null;
        var url = '/api/Informes/InformePrecargueRespuestas/DatosRejilla?idEncuesta=' + $scope.idEncuesta;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            if (datos.length > 0) {
                $scope.isGrid = true;
                $scope.gridOptions.data = datos;
                if (!$scope.isColumnDefs) {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, columsNoVisibles);
                    $scope.isColumnDefs = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, columsNoVisibles);
                }
                UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions, actionJsonExport);
                UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
            } else {
                $scope.isGrid = false;
                $scope.isColumnDefs = false;
                $scope.alerta = "No se encontraron datos";
            }
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };
}])
;