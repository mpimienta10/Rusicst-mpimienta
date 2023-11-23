app.controller('RevisionRespuestasAGController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$location', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $location, authService) {
    $scope.alcaldias = [];
    $scope.cargoDatos = true;
    $scope.registro = {};
    //---------------Cargar Combo municipios---------------------------
    function cargarComboMunicipios() {
        var url = '/api/General/ObtenerMunicipiosPorUsuario?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.alcaldias = datos;
        }, function (error) {
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición del combo de Alcaldías";
        });
    }
    cargarComboMunicipios();

    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterSuppressColumns: ["Id", "FechaInicio"],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Fecha Límite') value = new Date(value).toLocaleDateString();
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };
    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    $scope.isColumnDefs = false;
    $scope.columnDefsFijas = [];
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

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "FechaFin", newProperty: "Fecha Límite" }
        ]
    };
    $scope.showDatePopup = [];
    $scope.showDatePopup.push({ opened: false });

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    function agregarColumnasFijas() {

        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 120,
            name: '#',
            field: 'Modificar',
            //cellTemplate: '<div class="text-center"><a href="" ng-click="ver().onClick(row.entity.fullName)">Ver</a></div>',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.ver(row.entity)">Ver</a></div>',
            enableFiltering: false,
            pinnedLeft: true,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
    }

    //=============== Funcion VER =========================================
    $scope.ver = function (fila) {
        var url = '/api/Usuarios/Usuarios/BuscarXDepYMun';

        $scope.registro.AudUserName = authService.authentication.userName;
        $scope.registro.AddIdent = authService.authentication.isAddIdent;
        $scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (respuesta) {
            if (respuesta.data.length > 0) {
                var idUsuario = '';
                if ($scope.registro.idMunicipio == undefined || $scope.registro.idMunicipio == '') {
                    angular.forEach(respuesta.data, function (gobernacion, key) {
                        if (gobernacion.UserName != null && gobernacion.UserName.startsWith("gobernacion")) {
                            idUsuario = gobernacion.Id;
                        }
                    })
                } else {
                    angular.forEach(respuesta.data, function (municipio, key) {
                        if (municipio.UserName != null && municipio.UserName.startsWith("alcaldia")) {
                            idUsuario = municipio.Id;
                        }
                    })
                }
                $location.url('/Index/Reportes/IndiceEncuesta/' + fila.Id + '/' + fila.Titulo + '/' + idUsuario);
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });

    }

    //=====================================================================


    $scope.buscar = function () {
        $scope.error = null;
        $scope.alerta = null
        $scope.cargoDatos = null;
        if (!$scope.alcaldiaSeleccionada) {
            $scope.alerta = "Debe seleccionar una alcaldía";
        }
        else {
            var url = '/api/Reportes/RevisionRespuestasAG?idmunicipio=' + $scope.alcaldiaSeleccionada;
            getDatos();
            function getDatos() {
                $scope.parametro = {};
                var servCall = APIService.getSubs(url);
                servCall.then(function (datos) {
                    $scope.cargoDatos = true;
                    if (datos.length > 0) {       
                        $scope.registro.idMunicipio = $scope.alcaldiaSeleccionada;
                        $scope.isGrid = true;
                        $scope.gridOptions.data = datos;
                        agregarColumnasFijas();
                        var columsNoVisibles = ["Id", "FechaInicio"];
                        if (!$scope.isColumnDefs) {
                            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                            $scope.isColumnDefs = true;
                        } else {
                            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                        }
                        UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                        UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
                    } else {
                        $scope.isGrid = false;
                        $scope.isColumnDefs = false;
                        $scope.cargoDatos = true;
                        $scope.alerta = "No se encontraron datos";
                    }
                }, function (error) {
                    $scope.cargoDatos = true;
                    $scope.error = "Se generó un error en la petición";
                });
            }
        }
    };
   
    //$scope.openPopUp = function () {
    //    var modalInstance = $uibModal.open({
    //        templateUrl: '/scripts/views/modals/Filtro.html',
    //        controller: 'PopUpfiltroController',
    //        resolve: {
    //            colsGroup: function () { return { columnDefs: $scope.gridOptions.columnDefs, arregloFinalFiltro: $scope.arregloFinalFiltro } }
    //        }
    //    });
    //    modalInstance.result.then(
    //         function (arregloFiltro) {
    //             $scope.arregloFinalFiltro = arregloFiltro;
    //             if ($scope.arregloFinalFiltro.length > 0) {
    //                 //se debe hacer un post pasandole el $scope.arregloFinalFiltro     
    //                 //var url = '/api/Reportes/Glosario/GetFiltered';
    //                 //$http.post(url, $scope.arregloFinalFiltro).then(function (response) {
    //             }
    //         }
    //       );
    //};
    // Fin logica del popup de los filtro que no se desarrollara por el momento
}]);