app.controller('UsuariosPasaronAutoevaluacionController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService) {
    // ------------------- Inicio logica propia de la pagina-------------------
    $scope.EncuestaSeleccionada = "";
    $scope.usuarioSeleccionado = "";
    $scope.cargoDatos = true;
    function cargarCombo() {
        //cargar el combo de encuestas
        var url = '/api/General/Listas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición para cargar el combo de encuestas";
        });
    }
    $scope.$watch('EncuestaSeleccionada', function (newValue, oldValue) {
        if (newValue || oldValue) {
            if (newValue > 0) {
                $scope.alerta = null;
            }
        }
    });
    cargarCombo();    
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.colPdf = [
        { columna: 'Nombre de Usuario', col: null },
        { columna: 'Email', col: null }
    ]
    $scope.gridOptions = {        
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            angular.forEach($scope.colPdf, function (fila) {
                if (col.colDef.displayName === fila.columna) fila.col = col;
            });
            return value;
        },
        onRegisterApi: function (gridApi) {
            gridApi.pagination.raise.paginationChanged = function (currentPage, pageSize) {
            };
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
            gridApi.grid.options.exporterPdfTableHeaderStyle = { fontSize: 9, bold: true, color: 'white', fillColor: '#63002D', alignment: 'center' };
            gridApi.grid.options.exporterPdfDefaultStyle = { fontSize: 8 };
            gridApi.grid.options.exporterPdfCustomFormatter = function (docDefinition) {
                var datosPDF = docDefinition.content[0].table.body;
                UtilsService.personalizarExportPDF(datosPDF, $scope.colPdf)
                docDefinition.styles.headerStyle = { fontSize: 10, bold: true, alignment: 'center', color: '#63002D' };
                docDefinition.styles.footerStyle = { fontSize: 8, bold: true, alignment: 'center', color: '#333333' };
                //docDefinition.content[0].table.widths = [80, 80, '*', '*', '*', 20]; // para definir las margenes de cada columna
                //docDefinition.pageMargins = [10, 50, 10, 50];
                return docDefinition;
            }
        },
    };
    $scope.isColumnDefs = false;
    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });
    //DIMENSIONAR LA TABLA
    $scope.getTableHeight = function () {
        var rowHeight = 30; // your row height
        var headerHeight = 30; // your header height
        return {
            height: '500px'//($scope.gridData.data.length * rowHeight + headerHeight) + "px"
        };
    };    
    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    $scope.toggleFiltering = function () {
        $scope.gridOptions.enableFiltering = !$scope.gridOptions.enableFiltering;
        $scope.gridApi.core.notifyDataChange(uiGridConstants.dataChange.COLUMN);
    };

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Paso", newProperty: "Pasó" },
            { field: "Usuario", newProperty: "Nombre de Usuario" },
        ]
    };
    $scope.buscar = function () {
        $scope.alerta = null;
        if ($scope.EncuestaSeleccionada == 0) {
            $scope.alerta = "Debe seleccionar un ítem de la lista desplegable";
        }
        else {            
            var url = '/api/Informes/UsuariosPasaronAutoevaluacion?idEncuesta=' + $scope.EncuestaSeleccionada;
            getDatos();
            function getDatos() {
                $scope.cargoDatos = null;
                var servCall = APIService.getSubs(url);
                servCall.then(function (datos) {
                    $scope.cargoDatos = true;
                    if (datos.length > 0) {
                        $scope.isGrid = true;
                        $scope.gridOptions.data = datos;
                        if (!$scope.isColumnDefs) {
                            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, null);
                            $scope.isColumnDefs = true;
                        } else {
                            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, null);
                        }
                        UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                    } else {
                        $scope.isGrid = false;
                        $scope.isColumnDefs = false;
                        $scope.alerta = "No se encontraron datos";
                    }
                }, function (error) {
                    $scope.cargoDatos = true;
                    $scope.error = "Se generó un error en la petición para llenar la rejilla";
                });
            }
        }
    };
}]);
