app.controller('AutoevaluacionController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService) {
    //------------------- Inicio logica de filtros de la pantalla -------------------
    $scope.filtro = {};
    $scope.GobernacionAlcaldias = [];
    $scope.alcaldias = [];
    $scope.columnDefsFijas = [];
    $scope.cargoDatos = true;
    $scope.encuestas;
    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "FechaCumplimiento", newProperty: "Fecha de Cumplimiento" },
            { field: "Encuesta", newProperty: "Reporte" },
            { field: "Autoevaluacion", newProperty: "Autoevaluación" },
            { field: "Calificacion", newProperty: "Calificación" },
            { field: "Categoria", newProperty: "Categoría" },
            { field: "Recomendacion", newProperty: "Recomendación" }
        ]
    };
    var formatDate =
       {
           action: "CambiarFecha",
           parameters: [
               { field: "FechaCumplimiento" },
           ]
       };

    function cargarComboDepartamentos() {
        var url = '/api/General/Listas/DepartamentosMunicipios?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.GobernacionAlcaldias = response;
            var flags = [], output = [], l = response.length, i;
            for (i = 0; i < l; i++) {
                if (flags[response[i].IdDepartamento]) continue;
                flags[response[i].IdDepartamento] = true;
                output.push(response[i]);
            }
            $scope.gobernaciones = output;
        }, function (error) {
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición";
        });
    }
    $scope.cargarComboMunicipios = function () {
        $scope.alcaldias = [];
        if ($scope.filtro.departamento == 0) {
            $scope.alerta = "Debe seleccionar una Gobernación o un Departamento.";
        }
        else {
            angular.forEach($scope.GobernacionAlcaldias, function (alcaldia) {
                if (alcaldia.IdDepartamento == $scope.filtro.departamento)
                    $scope.alcaldias.push(alcaldia);
            });
        }
    }
    function cargarComboEncuesta() {
        var url = '/api/General/Listas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de combo de encuestas";
        });
    }
    cargarComboDepartamentos();
    cargarComboEncuesta();
    $scope.filtrar = function () {
        $scope.alerta = null;
        $scope.cargoDatos = null;
        var url = '/api/Informes/InformeAutoevaluacion?idEncuesta=' + $scope.filtro.EncuestaRelacionada + '&idDepartamento=' + $scope.filtro.departamento + '&idMunicipio=' + $scope.filtro.municipio;
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatos = true;
                $scope.error = "";
                if (datos.length > 0) {
                    $scope.isGrid = true;
                    $scope.gridOptions.data = datos;
                    if (!$scope.isColumnDefs) {
                        UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, null);
                        $scope.isColumnDefs = true;
                    } else {
                        UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, null);
                    }
                    UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                    UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
                } else {
                    $scope.isGrid = false;
                    $scope.isColumnDefs = false;
                    $scope.alerta = "No se encontraron datos";
                }
            }, function (error) {
                $scope.isGrid = false;
                $scope.isColumnDefs = false;
                $scope.cargoDatos = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
    }
    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            //-----------------Insertar texto en un string--------------------------
            String.prototype.splice = function (idx, rem, str) {
                return this.slice(0, idx) + str + this.slice(idx + Math.abs(rem));
            };

            //========= Quebrar línea para los usuarios en el segundo underscore ===================
            if (col.colDef.displayName === 'Usuario') {
                var indexPrimerUnderscore = value.indexOf("_");
                if (indexPrimerUnderscore != -1) {
                    var substringValue = value.substring(indexPrimerUnderscore + 1);
                    var indexSegundoUnderscore = substringValue.indexOf("_");
                    if (indexSegundoUnderscore != -1) {
                        indexSegundoUnderscore = indexSegundoUnderscore + indexPrimerUnderscore + 2;
                        value = value.splice(indexSegundoUnderscore, 0, ' ');
                    }
                }
            }
            if (col.colDef.displayName === 'Fecha de Cumplimiento') {
                value = new Date(value);
                value = value.toLocaleDateString();
            }
            
            return value;
        },
        onRegisterApi: function (gridApi) {
            gridApi.pagination.raise.paginationChanged = function (currentPage, pageSize) {
            };
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
            gridApi.grid.options.exporterPdfTableHeaderStyle = { fontSize: 6, bold: true, color: 'white', fillColor: '#63002D', alignment: 'center' };
            gridApi.grid.options.exporterPdfDefaultStyle = { fontSize: 5 };
            gridApi.grid.options.exporterPdfTableStyle = { margin: [0, 0, 0, 0] };
            gridApi.grid.options.exporterPdfCustomFormatter = function (docDefinition) {
                docDefinition.styles.headerStyle = { fontSize: 10, bold: true, alignment: 'center', color: '#63002D' };
                docDefinition.styles.footerStyle = { fontSize: 8, bold: true, alignment: 'center', color: '#333333' };
                docDefinition.content[0].table.widths = [50, 60, 40, 40, 40, 40, 20, 30, 50, 70, 45, 50, 70, 35, 35];
                docDefinition.pageMargins = [10, 50, 10, 50];
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

    //$scope.colsGroup = angular.copy($scope.gridOptions.columnDefs);
    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    $scope.toggleFiltering = function () {
        $scope.gridOptions.enableFiltering = !$scope.gridOptions.enableFiltering;
        $scope.gridApi.core.notifyDataChange(uiGridConstants.dataChange.COLUMN);
    };
    $scope.openPopUp = function () {
        var modalInstance = $uibModal.open({
            templateUrl: '/scripts/views/modals/Filtro.html',
            controller: 'PopUpfiltroController',
            resolve: {
                colsGroup: function () { return { columnDefs: $scope.gridOptions.columnDefs, arregloFinalFiltro: $scope.arregloFinalFiltro } }
            }
        });
        modalInstance.result.then(
             function (arregloFiltro) {
                 $scope.arregloFinalFiltro = arregloFiltro;
                 if ($scope.arregloFinalFiltro.length > 0) {
                     //se debe hacer un post pasandole el $scope.arregloFinalFiltro                
                     //$http.post(url, $scope.arregloFinalFiltro).then(function (response) {
                 }
             }
           );
    };
    // Fin logica del popup de los filtro que no se desarrollara por el momento
}]);
