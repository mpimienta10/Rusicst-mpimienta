app.controller('BuscadorController', ['$state', 'authService', '$location', '$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', function ($state, authService, $location, $scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal) {
    //------------------- Inicio logica de filtros de la pantalla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.isGrid = false;
    $scope.isColumnDefs = false;
    $scope.cargoDatos = false;

    $scope.busqueda = $state.params.textoBusqueda;

    //// Rejilla
    $scope.gridOptions = {
        columnDefs: [],
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };

    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    var columnsNoVisibles = [
        "id_encuesta",
        "id_etapa",
        "id_seccion",
        "id_pagina",
        "id_pregunta",
        "Usuario",
        "div_depto",
        "div_muni"
    ];

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "titulo_encuesta", newProperty: "Título Encuesta" },
            { field: "Seccion", newProperty: "Sección" },
            { field: "Pagina", newProperty: "Página" }
        ]
    };

    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Pregunta') value = UtilsService.exportPdfColumnLarge(col, value);
            if (col.colDef.displayName === 'Respuesta') value = UtilsService.exportPdfColumnLarge(col, value);
            if (col.colDef.displayName === 'Página') value = UtilsService.exportPdfColumnLarge(col, value);
            return value;
        },
        onRegisterApi: function (gridApi) {

            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
            gridApi.grid.options.exporterPdfTableHeaderStyle = { fontSize: 8, bold: true, color: 'white', fillColor: '#63002D', alignment: 'center' };
            gridApi.grid.options.exporterPdfDefaultStyle = { fontSize: 7 };
            gridApi.grid.options.exporterPdfCustomFormatter = function (docDefinition) {
                docDefinition.styles.headerStyle = { fontSize: 10, bold: true, alignment: 'center', color: '#63002D' };
                docDefinition.styles.footerStyle = { fontSize: 8, bold: true, alignment: 'center', color: '#333333' };
                return docDefinition;
            }
        },
    };

    var getDatos = function (nmtexto) {
        $scope.cargoDatos = true;
        var url = '/api/General/Buscador?textoBusqueda=' + nmtexto + '&audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            if (datos.length > 0) {
                $scope.isGrid = true;
                $scope.gridOptions.data = datos;
                $scope.alerta = '';
                if (!$scope.isColumnDefs) {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, columnsNoVisibles);
                    UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                    $scope.isColumnDefs = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, columnsNoVisibles);
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

    if ($scope.busqueda !== undefined && null !== $scope.busqueda)
        if ($scope.busqueda.length > 0)
            getDatos($scope.busqueda);

    $scope.gridOptions = {
        enableRowSelection: true,
        enableRowHeaderSelection: false,
        multiSelect: false,
        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;
            gridApi.selection.on.rowSelectionChanged($scope, function (rows) {
                var selection = gridApi.selection.getSelectedRows();
                $state.go('Index.Encuesta', { IdEncuesta: selection[0].id_encuesta, IdPagina: selection[0].id_pagina, });
            });
        }
    };
}]);
