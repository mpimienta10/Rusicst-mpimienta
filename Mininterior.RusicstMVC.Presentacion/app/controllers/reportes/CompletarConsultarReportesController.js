app.controller('CompletarConsultarReportesController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', '$location', 'enviarDatos', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService, $location,enviarDatos) {
    //------------------- Inicio logica de la grilla -------------------
    $scope.autenticacion = authService.authentication;
    $scope.registro = { idTipoUsuario: $scope.autenticacion.idTipoUsuario, idUsuario: $scope.autenticacion.idUsuario };
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.isGrid2 = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.columnDefsFijas = [];
    $scope.columnDefsFijas2 = [];
   
    $scope.gridOptions = {

        columnDefs: [],
        exporterSuppressColumns: ['Id'],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Fecha límite') value = new Date(value).toLocaleDateString();
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom($scope.gridApi1);
        },
    };
    $scope.gridOptions2 = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Fecha límite') value = new Date(value).toLocaleDateString();
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi2 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom($scope.gridApi2);
        },
    };
    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid'); }
    });
    $scope.$watchGroup(['gridOptions2.totalItems', 'gridOptions2.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions2.totalItems, $scope.gridOptions2.paginationCurrentPage, $scope.gridOptions2.paginationPageSize, 'grid2'); }
    });

    $scope.isColumnDefs = false;
    $scope.isColumnDefs2 = false;

    $scope.datePicker = {
        options: {
            formatMonth: 'MM',
            startingDay: 1
        },
        format: "dd/MM/yyyy"
    };
    var formatDate =
      {
          action: "CambiarFecha",
          parameters: [
              { field: "FechaFin" },
          ]
      };
    $scope.showDatePopup = [];
    $scope.showDatePopup.push({ opened: false });

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };
    $scope.limpiarAgrupacion2 = function () {
        $scope.gridApi2.grouping.clearGrouping();
    };
 
    function agregarColumnasFijas() {
        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 140,
            name: ' ',
            field: 'Consultar',
            cellTemplate: '<div class="text-center"> <a href="" ng-click="grid.appScope.ConsultarEncuestasCompletadas2(row.entity)">Consultar</a></div>',
            enableFiltering: false,
            pinnedRight: true,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 140,
            name: ' ',
            field: 'Consultar',
            cellTemplate: '<div class="text-center"> <a href="" ng-click="grid.appScope.ConsultarEncuestasCompletadas(row.entity)">Consultar</a></div>',
            enableFiltering: false,
            pinnedRight: true,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
    };
    function agragarColumnasFijas2() {
        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 140,
            name: ' ',
            field: 'Consultar',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.ConsultarEncuestasNoCompletadas(row.entity)">Completar</a></div>',
            enableFiltering: false,
            pinnedRight: true,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas2.push(columnDefsJsonFijas);
  
    };
  
    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Titulo", newProperty: "Título" },
            { field: "FechaFin", newProperty: "Fecha límite" },
        ]
    };

    var dateJson = {
        action: "CambiarDefinicion",
        definition: "sort",
        parameters: [
            {
                field: "FechaFin",
                newProperty: {
                    direction: uiGridConstants.DESC,
                    priority: 1
                }
            },
        ]
    };

   
    
    var columsNoVisibles = ["Id"];
    
    //=============================Obtener Listas de encuestas completadas o No completadas ==================================
    //----Se obtiene Lista de encuestas completadas------
    var getDatos = function () {
        $scope.alerta = null;
        $scope.autenticacion;
        $scope.registro = { UserName: $scope.autenticacion.userName };
        var url = '/api/Reportes/ConsultarCompletarReportes/ListaEncuestasCompletadas/';
        var servCall = APIService.saveSubscriber($scope.registro, url);;
        servCall.then(function (datos) {
            debugger;
            if (datos.data.length > 0) {
                $scope.isGrid = true;
                $scope.gridOptions.data = datos.data;
                agregarColumnasFijas();
                if (!$scope.isColumnDefs) {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                    $scope.isColumnDefs = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                }
                UtilsService.utilsGridOptions($scope.gridOptions, dateJson);
                UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
               
            } else {
                $scope.isGrid = false;
                $scope.isColumnDefs = false;
                if ($scope.alerta) {
                    $scope.alerta = $scope.alerta + "No se encontraron encuestas completadas";
                } else {
                    $scope.alerta = "No se encontraron encuestas completadas";
                }
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };
    getDatos();
  
    //----Se obtiene Lista de encuestas No completadas------
    var getDatos2 = function () {
        $scope.registro = { UserName: $scope.autenticacion.userName };
        var url = '/api/Reportes/ConsultarCompletarReportes/ListaEncuestasNoCompletadas/';
        var servCall = APIService.saveSubscriber($scope.registro, url);;
        servCall.then(function (datos2) {
            if (datos2.data.length > 0) {
                $scope.isGrid2 = true;
                $scope.gridOptions2.data = datos2.data;
                agragarColumnasFijas2();
                if (!$scope.isColumnDefs2) {
                    UtilsService.getColumnDefs($scope.gridOptions2, $scope.isColumnDefs2, $scope.columnDefsFijas2, columsNoVisibles);
                    $scope.isColumnDefs2 = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions2, $scope.isColumnDefs2, $scope.columnDefsFijas2, columsNoVisibles);
                }
                UtilsService.utilsGridOptions($scope.gridOptions2, dateJson);
                UtilsService.utilsGridOptions($scope.gridOptions2, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions2, formatDate);
            } else {
                $scope.isGrid2 = false;
                $scope.isColumnDefs2 = false;
                if ($scope.alerta2) {
                    $scope.alerta2 = $scope.alerta2 + "No se encontraron encuestas sin completar";
                } else {
                    $scope.alerta2 = "No se encontraron encuestas sin completar";
                }
            }
        }, function (error) {
            $scope.error2 = "Se generó un error en la petición";
        });
    };
    getDatos2();

     //===============================Ir a consulta============================================

    $scope.ConsultarEncuestasNoCompletadas = function (entidad) {
        debugger
        enviarDatos.datos = entidad;
        $location.url('/Index/Reportes/IndiceEncuesta/' + entidad.Id + '/' + entidad.Titulo + '/' + null);
    }

 

    $scope.ConsultarEncuestasCompletadas = function (entidad) {
        enviarDatos.datos = entidad; 
        $location.url('/Index/Reportes/IndiceEncuesta/' + entidad.Id + '/' + entidad.Titulo + '/' + null);
    }
}]);

app.controller('ConsultarReporteController', ['$scope', 'APIService', 'UtilsService', '$log', '$uibModalInstance', 'entidad', function ($scope, APIService, UtilsService, $log, $uibModalInstance, entidad) {
    $scope.registro = entidad || {};
  
    $scope.config = {
        disenho: { abierto: true },
        implementacion: { abierto: true },
        evaluacionYSeguimiento: { abierto: true },
    };

    getDatos();
    function getDatos() {
        $scope.registro.disenho = [
            { valor: 'Dinámica del Conflicto Armado' },
            { valor: 'Comité Territorrial de Justicia Transicional' },
            { valor: 'Plan de Acción Territorrial' },
            { valor: 'Participación de las victimas' },
            { valor: 'Articulación Institucional' },
            { valor: 'Retorno y Reubicación' },
        ];

        $scope.registro.implementacion = [
            { valor: 'Comité Territorrial de Justicia Transicional' },
            { valor: 'Plan de Acción Territorrial' },
            { valor: 'Participación de las victimas' },
            { valor: 'Articulación Institucional' },
            { valor: 'Retorno y Reubicación' },
            { valor: 'Adecuación Institucional' },
        ];

        $scope.registro.evaluacionYSeguimiento = [
            { valor: 'Comité Territorrial de Justicia Transicional' },
            { valor: 'Plan de Acción Territorrial' },
            { valor: 'Participación de las victimas' },
            { valor: 'Retorno y Reubicación' },
        ];
    };

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {
        //var servCall = APIService.saveSubscriber($scope.registro, $scope.url);
        //servCall.then(function (response) {
        //    var resultado = {};
        //    resultado.estado = response.data.estado
        //    switch (response.data.estado) {
        //        case 0:
        //            $scope.error = response.data.respuesta;
        //            break;
        //        case 1:
        //            $uibModalInstance.close(resultado);
        //            break;
        //        case 2:
        //            $uibModalInstance.close(resultado);
        //            break;
        //    }
        //}, function (error) {
        //    $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        //});
    }
    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

}]);