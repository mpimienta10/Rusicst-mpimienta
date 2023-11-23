app.controller('ConsultaEntidadesTerritorialesController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$location', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $location, authService) {
    //------------------- Inicio logica de filtros de la pantalla -------------------
    $scope.gobernacionSeleccionada = null;
    $scope.cargoDatos = null;
    $scope.registro = {};
    $scope.GobernacionAlcaldias = [];
    $scope.alcaldias = [];
    $scope.columnDefsFijas = [];
    $scope.registro = {};
    $scope.errorsMessages = UtilsService.getErrorMessages();
    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "titulo", newProperty: "Título" },
            { field: "FechaFin", newProperty: "Fecha límite" },
        ]
    };
    var formatDate =
       {
           action: "CambiarFecha",
           parameters: [
               { field: "FechaFin" },
           ]
       };
    //cargar el combo de gobernaciones
    function cargarComboGobernacion() {
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

    //cargar el combo de las alcaldias de una gobernacion seleccionada
    $scope.cargarComboAlcaldias = function () {
        $scope.alcaldias = [];
        if ($scope.gobernacionSeleccionada == 0) {
            $scope.alerta = "Debe seleccionar una Gobernación o un Departamento.";
        }
        else {
            angular.forEach($scope.GobernacionAlcaldias, function (alcaldia) {
                if (alcaldia.IdDepartamento == $scope.registro.idDepartamento)
                    $scope.alcaldias.push(alcaldia);
            });
        }
        
    }
    cargarComboGobernacion();

    function agregarColumnasFijas() {
        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 100,
            field: 'Modificar',
            name: '#',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.ver(row.entity)">ver</a></div>',
            enableFiltering: false,
            pinnedLeft: true,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
    }

    //=============== Funcion VER =========================================
    $scope.ver = function (fila) {
        debugger
        //var usuario = '';
        //var departamento = '';
        //var idDepartamento = parseInt($scope.registro.idDepartamento);
        //angular.forEach($scope.gobernaciones, function (gobernacion, key) {
        //    if (gobernacion.IdDepartamento === idDepartamento) {
        //        departamento = gobernacion.Departamento;
        //    }
        //})
        //if ($scope.registro.idMunicipio == undefined || $scope.registro.idMunicipio == '' ) {
        //    usuario = 'gobernacion_' + departamento;
        //} else {
        //    var municipio = '';
        //    var idMunicipio = parseInt($scope.registro.idMunicipio);
        //    angular.forEach($scope.alcaldias, function (alcaldia, key) {
        //        if (alcaldia.IdMunicipio === idMunicipio) {
        //            municipio = alcaldia.Departamento;
        //        }
        //    })
        //    usuario = 'alcaldia_' + municipio + '_' + departamento;
        //}

        
        //usuario = usuario.toLowerCase();
        //usuario = usuario.replace(/á/g, "a");
        //usuario = usuario.replace(/é/g, "e");
        //usuario = usuario.replace(/í/g, "i");
        //usuario = usuario.replace(/ó/g, "o");
        //usuario = usuario.replace(/ú/g, "u");
        //usuario = usuario.replace(/ /g, "_");
        var url = '/api/Usuarios/Usuarios/BuscarXDepYMun';
        
        $scope.registro.AudUserName = authService.authentication.userName;
        $scope.registro.AddIdent = authService.authentication.isAddIdent;
        $scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (respuesta) {
            debugger;
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
                $location.url('/Index/Reportes/IndiceEncuesta/' + fila.id + '/' + fila.titulo + '/' + idUsuario);
            }
       }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
       
    }

    //=====================================================================

    //Definir columnas invinsibles
    var columsNoVisibles = ["id"];

    $scope.filtrar = function () {
        if (!$scope.validar()) return false;
        getDatos();
    }

    var getDatos = function () {
        $scope.cargoDatos = true;
        var url = '/api/Reportes/ConsultaEntidadesTerritoriales/GetFiltered';
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (datos) {
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
                UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
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
            if (col.colDef.displayName === 'Fecha límite') value = new Date(value).toLocaleDateString();
            return value;
        },
        exporterSuppressColumns: ["id",],
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };
    $scope.isColumnDefs = false;
    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    //$scope.colsGroup = angular.copy($scope.gridOptions.columnDefs);
    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };
}]);
