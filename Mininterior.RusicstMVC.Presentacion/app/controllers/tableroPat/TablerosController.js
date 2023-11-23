app.controller('TablerosController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', 'authService', 'ngSettings', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, authService, ngSettings) {
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.cargoDatos = false;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            if (col.colDef.displayName === 'ActivoEnvioPATPlaneacion') value === true ? value = "SI" : value = "NO";
            if (col.colDef.displayName === 'ActivoEnvioPATSeguimiento') value === true ? value = "SI" : value = "NO";
            if (col.colDef.displayName === 'Inicio Planeación') value = (value != "" ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Límite Planeación') value = (value != "" ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Inicio 1º Seguimiento') value = (value != "" ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Fin 1º Seguimiento') value = (value != "" ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Inicio 2º Seguimiento') value = (value != "" ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Fin 2º Seguimiento') value = (value != "" ? new Date(value).toLocaleDateString() : "");
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
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid1'); }
    });

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    function agregarColumnasFijas() {
        $scope.columnDefsFijas = [
            {
                minWidth: 100,
                width: 100,
                name: 'Todos',
                field: 'Preguntas',
                cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.Preguntas(row.entity)">Preguntas</a></div> ',
                enableFiltering: false,
                pinnedLeft: true,
                enableCellEdit: false,
                exporterSuppressExport: true,
            },
         {
             minWidth: 50,
             width: 50,
             name: 'RC',
             field: 'RC',
             cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.PreguntasRC(row.entity)">RC</a></div> ',
             enableFiltering: false,
             pinnedLeft: true,
             enableCellEdit: false,
             exporterSuppressExport: true,
         },
        {
            minWidth: 50,
            width: 50,
            name: 'RR',
            field: 'RR',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.PreguntasRR(row.entity)">RR</a></div> ',
            enableFiltering: false,
            pinnedLeft: true,
            enableCellEdit: false,
            exporterSuppressExport: true,
        },
        {
            minWidth: 100,
            width: 100,
            name: 'Modificar',
            field: 'Modificar',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.abrirModalNuevoTablero(row.entity)">Modificar</a></div> ',
            enableFiltering: false,
            pinnedLeft: true,
            enableCellEdit: false,
            exporterSuppressExport: true,
        }
        ];
    }
    var columsNoVisibles = ['Nivel', 'Id'];

    var columnsNoVisiblesExportacion =
    [
        "Id", "Nivel"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "IdTablero", newProperty: "Tablero" },
            { field: "anoTablero", newProperty: "Año" },
            { field: "NombreNivel", newProperty: "Nivel" },
            { field: "VigenciaInicio", newProperty: "Inicio Planeación" },
            { field: "VigenciaFin", newProperty: "Límite Planeación" },
            { field: "Seguimiento1Inicio", newProperty: "Inicio 1º Seguimiento" },
            { field: "Seguimiento1Fin", newProperty: "Fin 1º Seguimiento" },
            { field: "Seguimiento2Inicio", newProperty: "Inicio 2º Seguimiento" },
            { field: "Seguimiento2Fin", newProperty: "Fin 2º Seguimiento" },
            { field: "ActivoEnvioPATPlaneacion", newProperty: "Activo Envio PAT Planeacion" },
            { field: "ActivoEnvioPATSeguimiento", newProperty: "Activo Envio PAT Seguimiento" },
        ]
    };
    var checboxCell = {
        action: "CambiarDefinicion",
        definition: "cellTemplate",
        parameters: [
            { field: "Activo", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
            { field: "ActivoEnvioPATPlaneacion", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
            { field: "ActivoEnvioPATSeguimiento", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
        ]
    };
    var formatDate = {
        action: "CambiarFecha",
        parameters: [
            { field: "VigenciaInicio" },
            { field: "VigenciaFin" },
            { field: "Seguimiento1Inicio" },
            { field: "Seguimiento1Fin" },
            { field: "Seguimiento2Inicio" },
            { field: "Seguimiento2Fin" },
        ]
    };
    var actionJsonTamano = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "IdTabero", newProperty: "100" },
            { field: "Ano", newProperty: "100" },
            { field: "Seguimiento1Inicio", newProperty: "180" },
            { field: "Seguimiento1Fin", newProperty: "180" },
             { field: "Seguimiento2Inicio", newProperty: "180" },
            { field: "Seguimiento2Fin", newProperty: "180" },
              { field: "NombreNivel", newProperty: "150" },
                { field: "Nivel", newProperty: "150" },
        ]
    };

    var optionsFilter = [
       { value: false, label: "NO" },
       { value: true, label: "SI" },
    ]
    var filters = [{ selectOptions: optionsFilter, term: '', type: uiGridConstants.filter.SELECT, condition: uiGridConstants.filter.EXACT, disableCancelFilterButton: true, }, { condition: uiGridConstants.filter.CONTAINS, }];
    var filtersChange = {
        action: "CambiarDefinicion",
        definition: "filters",
        parameters: [
            { field: "Activo", newProperty: filters },
            { field: "ActivoEnvioPATPlaneacion", newProperty: filters },
            { field: "ActivoEnvioPATSeguimiento", newProperty: filters },
        ]
    };

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisiblesExportacion;

    getDatos();

    function getDatos() {
        $scope.tituloadmintablero = 'Administración de Tableros';
        var url = '/api/TableroPat/ListaTodosTableros/';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            agregarColumnasFijas();
            if (!$scope.isColumnDefs) {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                $scope.isColumnDefs = true;
            } else {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
            }
            UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            UtilsService.utilsGridOptions($scope.gridOptions, checboxCell);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJsonTamano);
            UtilsService.utilsGridOptions($scope.gridOptions, filtersChange);
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    $scope.abrirModalNuevoTablero = function (tablero) {
        if (tablero) {
            //modificar
            var modalInstance = $uibModal.open({
                templateUrl: '/app/views/tableroPat/modals/EditarTableroPat.html',
                controller: 'ModalEditarTableroController',
                resolve: {
                    tablero: function () {
                        if (tablero) {
                            return angular.copy(tablero);
                        } else {
                            return null;
                        }
                    }
                },
                backdrop: 'static', keyboard: false
            });
            modalInstance.result.then(
                function (mensaje) {
                    if (mensaje) {
                        getDatos();
                        UtilsService.abrirRespuesta(mensaje);
                    }
                }
               );
        } else {
            //Nuevo tablero
            var modelo = {};
            //// Cargar los datos de auditoría
            modelo.AudUserName = authService.authentication.userName;
            modelo.AddIdent = authService.authentication.isAddIdent;
            modelo.UserNameAddIdent = authService.authentication.userNameAddIdent;

            var modalInstance = $uibModal.open({
                templateUrl: '/app/views/modals/Confirmacion.html',
                controller: 'ModalConfirmacionController',
                backdrop: 'static', keyboard: false,
                resolve: {
                    datos: function () {
                        $scope.disabledguardando = 'disabled';
                        var titulo = 'Creación de nuevo tablero';
                        var url = '/api/TableroPat/IngresarTablero';
                        var entity = modelo;
                        var msn = "¿Está seguro de crear un nuevo tablero? El sistema creará los 3 niveles de gobierno para el nuevo tablero";
                        return { url: url, entity: entity, msn: msn, titulo: titulo }
                    }
                }
            });
            modalInstance.result.then(
                function (datosResponse) {
                    if (datosResponse) {
                        mostrarMensaje(datosResponse.mensaje);
                    }
                }
            );
        }

    };

    $scope.Preguntas = function (tablero) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/AdministracionPreguntas.html',
            controller: 'AdministracionPreguntasController',
            size: 'lg',
            resolve: {
                datos: function () {
                    if (tablero) {
                        $scope.tituloadmintablero = '';
                        return angular.copy(tablero);
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (mensaje) {
                $scope.tituloadmintablero = 'Administración de Tableros';
            }
           );
    };

    $scope.PreguntasRC = function (tablero) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/AdministracionPreguntasRC.html',
            controller: 'AdministracionPreguntasRCController',
            size: 'lg',
            resolve: {
                datos: function () {
                    if (tablero) {
                        return angular.copy(tablero);
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (mensaje) {
            }
           );
    };

    $scope.PreguntasRR = function (tablero) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/AdministracionPreguntasRR.html',
            controller: 'AdministracionPreguntasRRController',
            size: 'lg',
            resolve: {
                datos: function () {
                    if (tablero) {
                        return angular.copy(tablero);
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (mensaje) {
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

app.controller('ModalEditarTableroController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', 'tablero', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, tablero, authService) {
    $scope.tablero = tablero || {};
    //$scope.tablero = { VigenciaInicio: new Date(), VigenciaFin: new Date() };

    $scope.inactivarbtnGuardar = false;
    $scope.tablero.VigenciaInicio = new Date($scope.tablero.VigenciaInicio);
    $scope.tablero.VigenciaFin = new Date($scope.tablero.VigenciaFin);

    $scope.tablero.Seguimiento1Inicio = $scope.tablero.Seguimiento1Inicio ? new Date($scope.tablero.Seguimiento1Inicio) : null;
    $scope.tablero.Seguimiento1Fin = $scope.tablero.Seguimiento1Fin ? new Date($scope.tablero.Seguimiento1Fin) : null;
    $scope.tablero.Seguimiento2Inicio = $scope.tablero.Seguimiento2Inicio ? new Date($scope.tablero.Seguimiento2Inicio) : null;
    $scope.tablero.Seguimiento2Fin = $scope.tablero.Seguimiento2Fin ? new Date($scope.tablero.Seguimiento2Fin) : null;

    //DataPicker
    $scope.popup1 = {
        opened: false
    };
    $scope.open1 = function () {
        $scope.popup1.opened = true;
    };
    $scope.popup2 = {
        opened: false
    };
    $scope.open2 = function () {
        $scope.popup2.opened = true;
    };

    $scope.popup3 = {
        opened: false
    };
    $scope.open3 = function () {
        $scope.popup3.opened = true;
    };
    $scope.popup4 = {
        opened: false
    };
    $scope.open4 = function () {
        $scope.popup4.opened = true;
    };

    $scope.popup5 = {
        opened: false
    };
    $scope.open5 = function () {
        $scope.popup5.opened = true;
    };
    $scope.popup6 = {
        opened: false
    };
    $scope.open6 = function () {
        $scope.popup6.opened = true;
    };
    $scope.dateOptions = {
        formatYear: 'yyyy',
        startingDay: 1
    };
    $scope.dateOptions2 = {
        formatYear: 'yyyy',
        startingDay: 1
    };
    $scope.dateOptions2.minDate = $scope.tablero.VigenciaInicio;
    $scope.$watch('popup1.opened', function (newVal, oldVal) {
        if (newVal != oldVal && !newVal) {
            //close event

            //si las fecha de inicio es mayor que la fecha final, la cambiamos
            if ($scope.tablero.VigenciaInicio) {
                $scope.tablero.VigenciaFin = $scope.tablero.VigenciaFin;
                $scope.dateOptions2.minDate = $scope.tablero.VigenciaInicio;
            }
        }
    });


    $scope.checkErr = function (fechainicio, fechafin) {
        $scope.error = null;
        var curDate = new Date();
        if (new Date(fechainicio) > new Date(fechafin)) {
            $scope.error = 'La fecha de finalización de planeación debe ser mayor o igual a la de inicio';
            $scope.registerForm.$valid = false;
            return false;
        }
    };
    $scope.checkErrS1 = function (fechainicio, fechafin) {
        $scope.errorS1 = null;
        var curDate = new Date();
        if (new Date(fechainicio) > new Date(fechafin)) {
            $scope.errorS1 = 'La fecha de finalización del primer seguimiento debe ser mayor o igual a la de inicio';
            $scope.registerForm.$valid = false;
            return false;
        }
    };
    $scope.checkErrS2 = function (fechainicio, fechafin) {
        $scope.errorS2 = null;
        var curDate = new Date();
        if (new Date(fechainicio) > new Date(fechafin)) {
            $scope.errorS2 = 'La fecha de finalización del segundo seguimiento debe ser mayor o igual a la de inicio';
            $scope.registerForm.$valid = false;
            return false;
        }
    };

    $scope.format = "dd/MM/yyyy";

    if (tablero) {
        $scope.modificar = true;
        $scope.url = '/api/TableroPat/Modificar';
    } else {
        $scope.modificar = false;
        $scope.url = '/api/TableroPat/Insertar';
    }

    $scope.cancelar = function () {
        $uibModalInstance.close();
    };

    $scope.guardar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        if ($scope.error || $scope.error != null || $scope.errorS1 || $scope.errorS1 != null || $scope.errorS2 || $scope.errorS2 != null) return false;
        guardarDatos();
    };

    function guardarDatos() {
        $scope.inactivarbtnGuardar = true;
        $scope.tablero.AudUserName = authService.authentication.userName;
        $scope.tablero.AddIdent = authService.authentication.isAddIdent;
        $scope.tablero.UserNameAddIdent = authService.authentication.userNameAddIdent;
        var url = '/api/TableroPat/ModificarNivelTablero/';
        var servCall = APIService.saveSubscriber($scope.tablero, url);
        servCall.then(function (response) {
            var mensaje = {};
            switch (response.data.estado) {
                case 0:
                    $scope.error = response.data.respuesta;
                    break;
                case 1:
                    mensaje = { msn: 'El nuevo término fue adicionado al glosario satisfactoriamente', tipo: 'alert alert-success' };
                    $uibModalInstance.close(mensaje);
                    break;
                case 2:
                    mensaje = { msn: response.data.respuesta, tipo: 'alert alert-success' };
                    $uibModalInstance.close(mensaje);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos: " + error.data.respuesta;
        });
        $scope.inactivarbtnGuardar = true;
    }

    $scope.validar = function () {
        return $scope.registerForm.$valid;
    };
}])

//ADMINISTRACION DE PREGUNTAS DE TODOS LOS DERECHOS
app.controller('AdministracionPreguntasController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', 'datos', '$uibModalInstance', '$filter', '$log', 'authService', '$uibModal', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, datos, $uibModalInstance, $filter, $log, authService, $uibModal) {
    $scope.tablero = datos;
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
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid2'); }
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

    var columsNoVisibles = ["Nivel", "IdTablero", "IdDerecho", "IdComponente", "IdMedida", "IdUnidadMedida", "ApoyoDepartamental", "ApoyoEntidadNacional", "PreguntaCompromiso"];

    var optionsFilter = [
       { value: false, label: "NO" },
       { value: true, label: "SI" },
    ]

    var filters = [{ selectOptions: optionsFilter, term: '', type: uiGridConstants.filter.SELECT, condition: uiGridConstants.filter.EXACT, disableCancelFilterButton: true, }, { condition: uiGridConstants.filter.CONTAINS, }];

    var filtersChange = {
        action: "CambiarDefinicion",
        definition: "filters",
        parameters: [
            { field: "Activo", newProperty: filters },
            { field: "RequiereAdjunto", newProperty: filters },
        ]
    };

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "PreguntaIndicativa", newProperty: "Pregunta Indicativa" },
            { field: "PreguntaCompromiso", newProperty: "Pregunta Compromiso" },
            { field: "UnidadMedida", newProperty: "Unidad de Medida" },
            { field: "IdTablero", newProperty: "Tablero" },
            { field: "RequiereAdjunto", newProperty: "Requiere Adjunto" },
            { field: "MensajeAdjunto", newProperty: "Mensaje para el Adjunto" },
            { field: "ExplicacionPregunta", newProperty: "Explicación de la Pregunta" }
        ]
    };

    var checboxCell = {
        action: "CambiarDefinicion",
        definition: "cellTemplate",
        parameters: [
            { field: "Activo", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
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
            { field: "ApoyoDepartamental", newProperty: true },
            { field: "ApoyoEntidadNacional", newProperty: true },
        ]
    };

    getDatos();

    var actionJsonTamano = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "Medida", newProperty: "150" },
            { field: "PreguntaIndicativa", newProperty: "150" },
            { field: "UnidadMedida", newProperty: "150" },
            { field: "Derecho", newProperty: "150" },
            { field: "Componente", newProperty: "150" },
            { field: "MensajeAdjunto", newProperty: "150" },
            { field: "ExplicacionPregunta", newProperty: "150" },
        ]
    };

    $scope.gridOptions.exporterSuppressColumns = columsNoVisibles;

    function getDatos() {
        $scope.tituloadminpregunta = 'Administración de Preguntas';
        var url = '/api/TableroPat/PreguntasPorTablero/' + $scope.tablero.IdTablero + ',' + $scope.tablero.Nivel;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            if (datos.length > 0) {
                $scope.cargoDatos = true;
                $scope.isGrid = true;
                $scope.gridOptions.data = datos;
                agregarColumnasFijas();
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
                UtilsService.utilsGridOptions($scope.gridOptions, filtersChange);
            } else {
                $scope.cargoDatos = true;
                $scope.isGrid = false;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    $scope.Editar = function (pregunta) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/PreguntasPat.html',
            controller: 'AdministracionPreguntaEdicionController',
            size: 'lg',
            resolve: {
                pregunta: function () {
                    if (pregunta) {
                        $scope.tituloadminpregunta = '';
                        return { pregunta: angular.copy(pregunta), tablero: $scope.tablero };
                    } else {
                        return { pregunta: null, tablero: $scope.tablero };
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (mensaje) {
                $scope.tituloadminpregunta = 'Administración de Preguntas';

                if (mensaje.respuesta !== undefined)
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

    $scope.cancelar = function () {
        $uibModalInstance.close();
    };
}])

app.controller('AdministracionPreguntaEdicionController', ['$scope', 'APIService', 'UtilsService', '$http', 'pregunta', '$uibModalInstance', '$filter', '$log', 'authService', function ($scope, APIService, UtilsService, $http, pregunta, $uibModalInstance, $filter, $log, authService) {
    $scope.lang = 'es';
    $scope.datos = {};
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.ColumnDefs = false;
    $scope.flagVariable = false;
    $scope.pregunta = pregunta.pregunta || { Id: 0, ApoyoDepartamental: false, ApoyoEntidadNacional: false, Activo: true, Nivel: pregunta.tablero.Nivel, IdTablero: pregunta.tablero.IdTablero };
    $scope.pregunta.incluir = false;
    $scope.pregunta.idsNivelesArray = [];

    $scope.habilita = false;
    $scope.Niveles = [{ Id: 1, Descripcion: 'Nacional' }, { Id: 2, Descripcion: 'Departamental' }, { Id: 3, Descripcion: 'Municipal' }]
    $scope.mostrarUbicacion = $scope.pregunta.Nivel !== 1;

    ////=================================================================================================================
    //// Rejilla con los ítems no incluidos. Varía de acuerdo al nivel seleccionado. Puede ser municipios o departamento
    ////=================================================================================================================
    $scope.getDatosItemsNivel = function (isColumnDef) {
        $scope.alerta = '';
        $scope.cargoDatos = true;

        //// Determina que el nivel es departamental
        if ($scope.pregunta.Nivel === 2) {
            var url = '/api/TableroPat/CargarEdicionDepartamentosXPreguntaPAT?idPregunta=' + $scope.pregunta.Id + '&incluidos=' + $scope.pregunta.incluir;
            $scope.tituloincluir = 'Departamentos';
        }

            //// Determina que el nivel es municipal
        else if ($scope.pregunta.Nivel === 3) {
            var url = '/api/TableroPat/CargarEdicionMunicipiosXPreguntaPAT?idPregunta=' + $scope.pregunta.Id + '&incluidos=' + $scope.pregunta.incluir;
            $scope.tituloincluir = 'Municipios';
        }

        else { $scope.cargoDatos = false; return false; }

        var servCall = APIService.getSubs(url);

        servCall.then(function (datos) {

            if (datos.length > 0) {
                $scope.pregunta.idsNivelesArray = [];
                //$scope.isColumnDefs = isColumnDef && $scope.ColumnDefs;
                $scope.ColumnDefs = true;
                $scope.isGrid = true;
                $scope.gridOptions.data = datos;

                if (!$scope.isColumnDefs) {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
                    $scope.isColumnDefs = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
                }


                UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                //UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid3');
            } else {
                $scope.isGrid = false;
                $scope.alerta = "No se encontraron datos";
            };

            $scope.cargoDatos = false;

        }, function (error) {
            $scope.cargoDatos = true;
            $scope.errorgeneral = "Se generó un error en la petición";
        });
    };

    ///=======================================================
    //// Rejilla de opciones de acuerdo al nivel seleccionado
    ////======================================================
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Usuario') value = UtilsService.exportPdfColumnLarge(col, value);
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);

            //Selección de datos
            gridApi.selection.on.rowSelectionChanged($scope, function (row) {
                $scope.errorgeneral = '';
                if (row.isSelected) {
                    $scope.pregunta.idsNivelesArray.push(row.entity.Id);
                } else {
                    var index = $scope.pregunta.idsNivelesArray.indexOf(row.entity.Id);
                    if (index != -1) {
                        $scope.pregunta.idsNivelesArray.splice(index, 1);
                    }

                }
            });

            gridApi.selection.on.rowSelectionChangedBatch($scope, function (rows) {
                $scope.errorgeneral = '';

                ////------------------------------------------------------------------------------
                //// Desde esta línea se puede controlar la cantidad que se pueden pasar en batch
                ////------------------------------------------------------------------------------
                rows = rows.slice(0, 1200);

                angular.forEach(rows, function (row, key) {
                    if (row.isSelected) {
                        $scope.pregunta.idsNivelesArray.push(row.entity.Id);
                    } else {
                        var index = $scope.pregunta.idsNivelesArray.indexOf(row.entity.Id);
                        if (index != -1) {
                            $scope.pregunta.idsNivelesArray.splice(index, 1);
                        }
                    }
                })
            });
        },
    };

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Divipola", newProperty: "Código Dane" },
        ]
    };
    var columnsNoVisibles = ["Id"];
    var columnActions = null;
    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    ////=============
    //// autoajustar
    ////=============
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid3'); }
    });

    $scope.init = function () {
        var url = "/api/TableroPat/CargarEdicionPreguntas/";

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

            $scope.getDatosItemsNivel(false);

        }, function (error) {
            $scope.errorgeneral = "Se generó un error en la petición";
        });

        $scope.submitted = false;
    };

    $scope.errors = [];

    $scope.init();

    $scope.guardar = function () {
        $scope.flagVariable = true;
        ////===========================================================
        //// Validación de datos y que se haya seleccionado algún ítem
        ////===========================================================
        if (!$scope.validar()) return false;
        if (!$scope.validarSeleccionNivel()) return false;

        ////========================================
        //// Descarga los datos al objeto principal
        ////========================================
        $scope.pregunta.IdsNivel = $scope.pregunta.idsNivelesArray.toString();
        $scope.pregunta.Incluir = !$scope.pregunta.incluir;

        $scope.habilita = true;
        var url = "/api/TableroPat/ModificarPreguntas/";

        ////===============================
        //// Cargar los datos de auditoría
        ////===============================
        $scope.pregunta.AudUserName = authService.authentication.userName;
        $scope.pregunta.AddIdent = authService.authentication.isAddIdent;
        $scope.pregunta.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.pregunta, url);

        servCall.then(function (response) {
            $scope.flagVariable = false;
            response.data.Id = $scope.pregunta.Id;

            if (response.data.estado === 0) {
                $scope.errorgeneral = response.data.respuesta;
                $scope.mostrarRelacionar = true; $scope.mostrarPregunta = false;
                $scope.ColumnDefs = false;
            }
            else
                $uibModalInstance.close(response.data);

        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.data.ExceptionMessage;
        });
    };

    $scope.cancelar = function () {
        $uibModalInstance.close('');
    };

    $scope.validar = function () {
        $scope.errorgeneral = '';
        var validar = $scope.registerForm.$valid;
        if (!validar) { $scope.mostrarPregunta = true; $scope.mostrarRelacionar = false; }
        return validar;
    };

    ////============================================
    //// Valida que se haya seleccionado algún ítem
    ////============================================
    $scope.validarSeleccionNivel = function () {
        //// Valida si no es nivel nacional
        if ($scope.pregunta.Nivel !== 1) {
            if ($scope.pregunta.idsNivelesArray.toString().length == 0) {
                //// Valida si esta insertando la información l
                if ($scope.pregunta.Id == 0) {
                    if ($scope.pregunta.IdsDane === undefined || $scope.pregunta.IdsDane.length === 0) {
                        $scope.errorgeneral = "Es necesario seleccionar mínimo una entidad territorial.";
                        $scope.mostrarRelacionar = true; $scope.mostrarPregunta = false;
                        return false;
                    }
                }
            }
        }

        return true;
    };
}])

//ADMINISTRACION DE PREGUNTAS DE REPARACION COLECTIVA
app.controller('AdministracionPreguntasRCController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', 'datos', '$uibModalInstance', '$filter', '$log', 'authService', '$uibModal', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, datos, $uibModalInstance, $filter, $log, authService, $uibModal) {
    $scope.tablero = datos;
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.cargoDatos = false;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
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
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid4'); }
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
    var columsNoVisibles = ["IdMedida", "IdDepartamento", "IdMunicipio", "IdTablero"];


    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Id", newProperty: "Número" },
            { field: "MedidaReparacionColectiva", newProperty: "Medida RC" }
        ]
    };
    var checboxCell = {
        action: "CambiarDefinicion",
        definition: "cellTemplate",
        parameters: [
            { field: "Activo", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
        ]
    };
    var actionJsonExport = {
        action: "CambiarDefinicion",
        definition: "exporterSuppressExport",
        parameters: [
            { field: "IdMedida", newProperty: true },
            { field: "IdDepartamento", newProperty: true },
            { field: "IdMunicipio", newProperty: true },
        ]
    };
    var actionJsonTamano = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "Id", newProperty: "50" },
            { field: "Activo", newProperty: "50" },
        ]
    };



    var optionsFilter = [
       { value: false, label: "NO" },
       { value: true, label: "SI" },
    ]
    var filters = [{ selectOptions: optionsFilter, term: '', type: uiGridConstants.filter.SELECT, condition: uiGridConstants.filter.EXACT, disableCancelFilterButton: true, }, { condition: uiGridConstants.filter.CONTAINS, }];
    var filtersChange = {
        action: "CambiarDefinicion",
        definition: "filters",
        parameters: [
            { field: "Activo", newProperty: filters },
        ]
    };


    getDatos();

    function getDatos() {
        var url = '/api/TableroPat/PreguntasRC/?idTablero=' + $scope.tablero.IdTablero;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            if (datos.length > 0) {
                $scope.cargoDatos = true;
                $scope.isGrid = true;
                $scope.gridOptions.data = datos;
                agregarColumnasFijas();
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
                UtilsService.utilsGridOptions($scope.gridOptions, filtersChange);
            } else {
                $scope.cargoDatos = true;
                $scope.isGrid = false;
            }

        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    $scope.Editar = function (pregunta) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/PreguntasRCPat.html',
            controller: 'AdministracionPreguntaEdicionRCController',
            resolve: {
                pregunta: function () {
                    if (pregunta) {
                        return { pregunta: angular.copy(pregunta), tablero: $scope.tablero };
                    } else {
                        return { pregunta: null, tablero: $scope.tablero };
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (mensaje) {
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

    $scope.cancelar = function () {
        $uibModalInstance.close();
    };
}])

app.controller('AdministracionPreguntaEdicionRCController', ['$scope', 'APIService', '$http', 'pregunta', '$uibModalInstance', '$filter', '$log', 'authService', function ($scope, APIService, $http, pregunta, $uibModalInstance, $filter, $log, authService) {
    $scope.pregunta = pregunta.pregunta || { Id: 0, Activo: true, IdTablero: pregunta.tablero.IdTablero };
    $scope.gobernacionSeleccionada = null;
    $scope.GobernacionAlcaldias = [];
    $scope.alcaldias = [];
    $scope.habilita = false;
    $scope.flagVariable = false;
    $scope.init = function () {
        var url = '/api/TableroPat/CargarEdicionPreguntasRC?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.Medidas = datos.medidas;
                $scope.GobernacionAlcaldias = datos.departamentos;
                var flags = [], output = [], l = datos.departamentos.length, i;
                for (i = 0; i < l; i++) {
                    if (flags[datos.departamentos[i].IdDepartamento]) continue;
                    flags[datos.departamentos[i].IdDepartamento] = true;
                    output.push(datos.departamentos[i]);
                }
                $scope.gobernaciones = output;
                $scope.Tableros = datos.tableros;
                angular.forEach($scope.Tableros, function (t) {
                    t.VigenciaInicio = new Date(t.VigenciaInicio).toLocaleDateString();
                    t.VigenciaFin = new Date(t.VigenciaFin).toLocaleDateString();
                    t.Etiqueta = t.Año;
                });
                if ($scope.pregunta.Id > 0) {
                    $scope.gobernacionSeleccionada = $scope.pregunta.IdDepartamento;
                    $scope.cargarComboAlcaldias();
                }
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.submitted = false;
    };
    $scope.errors = [];
    $scope.init();
    //cargar el combo de las alcaldias de una gobernacion seleccionada
    $scope.cargarComboAlcaldias = function () {
        $scope.alcaldias = [];
        if ($scope.gobernacionSeleccionada == 0) {
            $scope.alerta = "Debe seleccionar un Departamento.";
        }
        else {
            angular.forEach($scope.GobernacionAlcaldias, function (alcaldia) {
                if (alcaldia.IdDepartamento == $scope.pregunta.IdDepartamento)
                    $scope.alcaldias.push(alcaldia);
            });
        }
    }
    $scope.guardar = function () {
        $scope.flagVariable = true;
        if (!$scope.validar()) return false;
        $scope.habilita = true;
        var url = "/api/TableroPat/ModificarPreguntasRC/";

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
        $uibModalInstance.close();
    };
    $scope.validar = function () {
        return $scope.registerForm.$valid;
    };
}])

//ADMINISTRACION DE PREGUNTAS DE RETORNOS Y REUBICACIONES
app.controller('AdministracionPreguntasRRController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', 'datos', '$uibModalInstance', '$filter', '$log', 'authService', '$uibModal', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, datos, $uibModalInstance, $filter, $log, authService, $uibModal) {
    $scope.tablero = datos;
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.cargoDatos = false;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
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
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid5'); }
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
    var columsNoVisibles = ["IdMedida", "IdDepartamento", "IdMunicipio", "IdTablero"];


    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Id", newProperty: "Número" }
        ]
    };
    var checboxCell = {
        action: "CambiarDefinicion",
        definition: "cellTemplate",
        parameters: [
            { field: "Activo", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
        ]
    };
    var actionJsonExport = {
        action: "CambiarDefinicion",
        definition: "exporterSuppressExport",
        parameters: [
            { field: "IdMedida", newProperty: true },
            { field: "IdDepartamento", newProperty: true },
            { field: "IdMunicipio", newProperty: true },
        ]
    };
    var actionJsonTamano = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "Id", newProperty: "50" },
            { field: "Activo", newProperty: "50" },
            { field: "NombreNivel", newProperty: "150" },
            { field: "Hogares", newProperty: "150" },
            { field: "Personas", newProperty: "150" },
            { field: "Sector", newProperty: "150" },
            { field: "Componente", newProperty: "150" },
            { field: "Ubicacion", newProperty: "150" },
            { field: "MedidaRetornoReubicacion", newProperty: "150" },
            { field: "IndicadorRetornoReubicacion", newProperty: "150" },
            { field: "EntidadResponsable", newProperty: "150" },
            { field: "Departamento", newProperty: "150" },
            { field: "Municipio", newProperty: "150" },
        ]
    };

    getDatos();



    var optionsFilter = [
       { value: false, label: "NO" },
       { value: true, label: "SI" },
    ]
    var filters = [{ selectOptions: optionsFilter, term: '', type: uiGridConstants.filter.SELECT, condition: uiGridConstants.filter.EXACT, disableCancelFilterButton: true, }, { condition: uiGridConstants.filter.CONTAINS, }];
    var filtersChange = {
        action: "CambiarDefinicion",
        definition: "filters",
        parameters: [
            { field: "Activo", newProperty: filters },
        ]
    };



    function getDatos() {
        var url = '/api/TableroPat/PreguntasRR/?idTablero=' + $scope.tablero.IdTablero;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            if (datos.length > 0) {
                $scope.cargoDatos = true;
                $scope.isGrid = true;
                $scope.gridOptions.data = datos;
                agregarColumnasFijas();
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
                UtilsService.utilsGridOptions($scope.gridOptions, filtersChange);
            } else {
                $scope.cargoDatos = true;
                $scope.isGrid = false;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    $scope.Editar = function (pregunta) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/PreguntasRRPat.html',
            controller: 'AdministracionPreguntaEdicionRRController',
            resolve: {
                pregunta: function () {
                    if (pregunta) {
                        return { pregunta: angular.copy(pregunta), tablero: $scope.tablero };
                    } else {
                        return { pregunta: null, tablero: $scope.tablero };
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (mensaje) {
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

    $scope.cancelar = function () {
        $uibModalInstance.close();
    };
}])

app.controller('AdministracionPreguntaEdicionRRController', ['$scope', 'APIService', '$http', 'pregunta', '$uibModalInstance', '$filter', '$log', 'authService', function ($scope, APIService, $http, pregunta, $uibModalInstance, $filter, $log, authService) {
    $scope.pregunta = pregunta.pregunta || { Id: 0, Activo: true, IdTablero: pregunta.tablero.IdTablero };
    $scope.gobernacionSeleccionada = null;
    $scope.GobernacionAlcaldias = [];
    $scope.alcaldias = [];
    $scope.habilita = false;
    $scope.flagVariable = false;
    $scope.init = function () {
        var url = '/api/TableroPat/CargarEdicionPreguntasRC?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.Medidas = datos.medidas;
                $scope.GobernacionAlcaldias = datos.departamentos;
                var flags = [], output = [], l = datos.departamentos.length, i;
                for (i = 0; i < l; i++) {
                    if (flags[datos.departamentos[i].IdDepartamento]) continue;
                    flags[datos.departamentos[i].IdDepartamento] = true;
                    output.push(datos.departamentos[i]);
                }
                $scope.gobernaciones = output;
                $scope.Tableros = datos.tableros;
                angular.forEach($scope.Tableros, function (t) {
                    t.VigenciaInicio = new Date(t.VigenciaInicio).toLocaleDateString();
                    t.VigenciaFin = new Date(t.VigenciaFin).toLocaleDateString();
                    t.Etiqueta = t.Año;
                });
                if ($scope.pregunta.Id > 0) {
                    $scope.gobernacionSeleccionada = $scope.pregunta.IdDepartamento;
                    $scope.cargarComboAlcaldias();
                }
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.submitted = false;
    };
    $scope.errors = [];
    $scope.init();
    //cargar el combo de las alcaldias de una gobernacion seleccionada
    $scope.cargarComboAlcaldias = function () {
        $scope.alcaldias = [];
        if ($scope.gobernacionSeleccionada == 0) {
            $scope.alerta = "Debe seleccionar un Departamento.";
        }
        else {
            angular.forEach($scope.GobernacionAlcaldias, function (alcaldia) {
                if (alcaldia.IdDepartamento == $scope.pregunta.IdDepartamento)
                    $scope.alcaldias.push(alcaldia);
            });
        }
    }
    $scope.guardar = function () {
        if (!$scope.validar()) return false;
        $scope.habilita = true;
        var url = "/api/TableroPat/ModificarPreguntasRR/";

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
        $uibModalInstance.close();
    };
    $scope.validar = function () {
        return $scope.registerForm.$valid;
    };
}])
;