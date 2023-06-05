app.controller('RespuestaEncuestaFileController', ['$scope', 'APIService', '$stateParams', '$location', '$log', '$sce', 'ngSettings', 'Upload', '$uibModal', 'UtilsService', 'authService', function ($scope, APIService, $stateParams, $location, $log, $sce, ngSettings, Upload, $uibModal, UtilsService, authService) {
    //===== Declaración de Variables ======================
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.cargoDatos = null;
    $scope.datos = [];
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
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Fecha Inicio' || col.colDef.displayName === 'Fecha Fin') value = new Date(value).toLocaleDateString();
            return value;
        },
        exporterSuppressColumns: ['Id'],
        exporterPdfFilename: 'Listado de Encuestas',
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom($scope.gridApi1);
        },
    };

    $scope.isColumnDefs = false;
    $scope.columnDefsFijas = [];
    encuestaNoFileServer();

    function encuestaNoFileServer() {
        var url = '/api/Reportes/Encuesta/ConsultarRespuestaFile';
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatos = true;
                $scope.isGrid = true;
                $scope.gridOptions.data = datos;
                agregarColumnasFijas();
                var columsNoVisibles = [];
                if (!$scope.isColumnDefs) {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                    $scope.isColumnDefs = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                }
                UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
            }, function (error) {
                $scope.cargoDatos = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
    };
}]);