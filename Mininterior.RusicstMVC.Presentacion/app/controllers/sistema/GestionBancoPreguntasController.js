app.controller('GestionBancoPreguntasController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$templateCache', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $templateCache, authService) {
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.isColumnDefs = false;
    $scope.cargoDatos = null;
    $scope.cargoDatosSpinner = true;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.colPdf = [
        { columna: 'Pregunta', col: null },
        { columna: 'Tipo Pregunta', col: null }
    ]
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            angular.forEach($scope.colPdf, function (fila) {
                if (col.colDef.displayName === fila.columna) fila.col = col;
            });
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
            gridApi.grid.options.exporterPdfCustomFormatter = function (docDefinition) {
                var datosPDF = docDefinition.content[0].table.body;
                UtilsService.personalizarExportPDF(datosPDF, $scope.colPdf)
                docDefinition.styles.headerStyle = { fontSize: 10, bold: true, alignment: 'center', color: '#63002D' };
                docDefinition.styles.footerStyle = { fontSize: 8, bold: true, alignment: 'center', color: '#333333' };
                return docDefinition;
            }
        },
    };
    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    var columnActions = [
        {
            name: ' ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpNuevoEditarPregunta(row.entity)">Modificar</a></div>',
            enableFiltering: false,
            pinnedLeft: true,
            minWidth: 70,
            width: 70,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        },
        {
            name: '  ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpClasificadoresPregunta(row.entity)">Clasificadores</a></div>',
            enableFiltering: false,
            enablePinning: true,
            pinnedRigth: true,
            minWidth: 145,
            width: 145,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        },
        {
            name: '    ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.openPopUpEliminar(row.entity)">Eliminar</a></div>',
            enableFiltering: false,
            enablePinning: true,
            pinnedRigth: true,
            minWidth: 60,
            width: 60,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        }
    ];

    //// Personalizar rejilla y exportación
    var columnsNoVisibles =
    [
        "IdPregunta",
        "IdTipoPregunta",
        "Descripcion"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "CodigoPregunta", newProperty: "Código" },
            { field: "NombrePregunta", newProperty: "Pregunta" },
            { field: "Nombre", newProperty: "Tipo Pregunta" },
            { field: "Descripcion", newProperty: "Descripción" },
        ]
    };

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    //getDatos();

    getTiposPregunta();

    function getTiposPregunta() {
        var url = '/api/Sistema/BancoPreguntas/ListaTiposPregunta/';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.tiposPregunta = datos;
        }, function (error) {
        });
    }

    $scope.filtrar = function () {
        if (!$scope.validar()) return false;
        $scope.cargoDatosSpinner = false;
        getDatos();
    }

    $scope.exportar = function () {
        //if (!$scope.validar()) return false;
        getDatosExportar();
    }

    var getDatosExportar = function () {
        
        //var idTipoPregunta = $scope.registro.idTipoPregunta == undefined ? null : $scope.registro.idTipoPregunta;
        //var codigoPregunta = $scope.registro.codigoPregunta == undefined ? '' : $scope.registro.codigoPregunta;
        var idTipoPregunta = null;
        var codigoPregunta = ' ';

        var url = $scope.serviceBase + '/api/Sistema/BancoPreguntas/ExportarBanco?idTipoPregunta=' + idTipoPregunta + '&codigoPregunta=' + codigoPregunta + '&isExportable=true';

        window.open(url)
    }

    function getDatos() {

        var idTipoPregunta = $scope.registro.idTipoPregunta == undefined ? null : $scope.registro.idTipoPregunta;
        var codigoPregunta = $scope.registro.codigoPregunta == undefined ? '' : $scope.registro.codigoPregunta;


        var url = '/api/Sistema/BancoPreguntas?idTipoPregunta=' + idTipoPregunta + '&codigoPregunta=' + codigoPregunta + '&isExportable=false';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);

            $scope.cargoDatos = true;
            $scope.cargoDatosSpinner = true;
            $scope.isColumnDefs = true;
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.cargoDatosSpinner = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //------------------------Lógica de Modal de Acciones -----------------------------------------
    $scope.PopUpNuevoEditarPregunta = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarPreguntas.html',
            controller: 'ModalNuevoEditarPreguntaController',
            size: 'md',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {
                        return angular.copy(entity);
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
                 $scope.isColumnDefs = true;
                 getDatos();
                 var mensaje = 'Se han actualizado los datos de la Pregunta';
                 openRespuesta(mensaje);
             }
        );
    };

    $scope.PopUpClasificadoresPregunta = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/ClasificadoresPreguntas.html',
            controller: 'ModalClasificadoresPreguntaController',
            size: 'lg',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {
                        return angular.copy(entity);
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
                 $scope.isColumnDefs = true;
                 getDatos();
                 var mensaje = 'Se han actualizado los datos de los Clasificadores de la Pregunta';
                 openRespuesta(mensaje);
             }
        );
    };

    //Confirmación
    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    $scope.deshabiltarRegistrese = false;
                    var enviar = { msn: mensaje, tipo: "alert alert-success" };
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
            });
    };

    $scope.openPopUpEliminar = function (entity) {
        $scope.Codigo = entity.CodigoPregunta;
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            backdrop: 'static', keyboard: false,
            resolve: {
                datos: function () {
                    if (entity) {

                        entity.AudUserName = authService.authentication.userName;
                        entity.AddIdent = authService.authentication.isAddIdent;
                        entity.UserNameAddIdent = authService.authentication.userNameAddIdent;

                        var url = '/api/Sistema/BancoPreguntas/Eliminar/';
                        var msn = "Está seguro de eliminar la pregunta con código: " + $scope.Codigo;
                        return { url: url, msn: msn, entity: entity }
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function () {
                 $scope.isColumnDefs = true;
                 getDatos();
                 var mensaje = 'La Pregunta ' + $scope.Codigo + ' ha sido eliminada satisfactoriamente.';
                 openRespuesta(mensaje);
             }
        );
    };
    //------------------Fin Lógica de acciones---------------------
}]);

app.controller('ModalNuevoEditarPreguntaController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.pregunta = {};
    $log.log(entity);
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '';
    $scope.CodigoPregunta = '';
    $scope.tiposPregunta;
    if ($scope.isNew) {
        $scope.url = '/api/Sistema/BancoPreguntas/Insertar';
    } else {
        $scope.url = '/api/Sistema/BancoPreguntas/Modificar';
    }

    $log.log($scope.url);
    $log.log($scope.pregunta);

    //Obtener el código de pregunta, solo si es nueva

    if ($scope.isNew) {
        getCodigoPregunta();
    }
    else {
        $scope.pregunta.codigoPregunta = entity.CodigoPregunta.toString();
        $scope.pregunta.idPregunta = entity.IdPregunta.toString();
        $scope.pregunta.nombrePregunta = entity.NombrePregunta.toString();
        $scope.pregunta.tipoPregunta = entity.IdTipoPregunta.toString();
    }

    getTiposPregunta();

    function getCodigoPregunta() {
        var url = '/api/Sistema/BancoPreguntas/CodigoPregunta/';
        var servCall = APIService.getSubs(url);
        servCall.then(function (codigo) {
            $scope.pregunta.codigoPregunta = codigo;
        }, function (error) {
        });
    }

    function getTiposPregunta() {
        var url = '/api/Sistema/BancoPreguntas/ListaTiposPregunta/';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.tiposPregunta = datos;
        }, function (error) {
        });
    }

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {
        
        $scope.pregunta.AudUserName= authService.authentication.userName;
        $scope.pregunta.AddIdent = authService.authentication.isAddIdent;
        $scope.pregunta.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.pregunta, $scope.url);
        servCall.then(function (response) {
            $log.log(response);
            switch (response.data.estado) {
                case 0:
                    $scope.error = response.data.respuesta;
                    break;
                case 2:
                    $uibModalInstance.close($scope.pregunta);
                    break;
                case 1:
                    $uibModalInstance.close($scope.pregunta);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);

app.controller('ModalClasificadoresPreguntaController', ['$scope', 'APIService', '$filter', '$log', '$uibModal', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModal, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.pregunta = {};
    $log.log(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.pregunta.codigoPregunta = entity.CodigoPregunta.toString();
    $scope.pregunta.idPregunta = entity.IdPregunta.toString();
    $scope.pregunta.nombrePregunta = entity.NombrePregunta.toString();
    $scope.pregunta.tipoPregunta = entity.IdTipoPregunta.toString();

    //// Defs Grid
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.isColumnDefs = false;
    $scope.cargoDatos = null;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];

    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
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

    var columnActions = [
        {
            name: ' ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpNuevoEditarClasificador(row.entity)">Editar</a></div>',
            enableFiltering: false,
            pinnedLeft: true,
            minWidth: 70,
            width: 70,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        }
    ];

    //// Personalizar rejilla y exportación
    var columnsNoVisibles =
    [
        "IdPregunta",
        "IdDetalleClasificador",
        "IdPreguntaDetalleClasificador",
        "IdClasificador"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "NombreClasificador", newProperty: "Clasificador" },
            { field: "NombreDetalleClasificador", newProperty: "Detalle Clasificador" },
        ]
    };

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/ClasificadoresPreguntas?idPregunta=' + $scope.pregunta.idPregunta;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    //// Modal editar detalle
    $scope.PopUpNuevoEditarClasificador = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/EditarDetalleClasificador.html',
            controller: 'ModalEditarClasificadorController',
            size: 'md',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {
                        return angular.copy(entity);
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
                 $scope.isColumnDefs = true;
                 getDatos();
                 var mensaje = 'Se han actualizado los datos del detalle del clasificador';
                 openRespuesta(mensaje);
             }
        );
    };

    //// Confirmación
    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    $scope.deshabiltarRegistrese = false;
                    var enviar = { msn: mensaje, tipo: "alert alert-success" };
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
            });
    };

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);

app.controller('ModalEditarClasificadorController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.detalle = {};
    $log.log(entity);
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '/api/Sistema/ClasificadoresPreguntas/ModificarDetalleClasificador/';

    $scope.detalles;
    $scope.detalle.nombreDetalle = entity.NombreClasificador.toString();
    $scope.detalle.idPregunta = entity.IdPregunta.toString();
    $scope.detalle.idDetalle = entity.IdDetalleClasificador.toString();
    $scope.detalle.idDetalleClasificador = entity.IdPreguntaDetalleClasificador.toString();
    $scope.detalle.idClasificador = entity.IdClasificador.toString();

    getDetallesClasificadores();

    function getDetallesClasificadores() {
        var url = '/api/Sistema/ClasificadoresPreguntas/DetallesClasificadores?idClasificador=' + $scope.detalle.idClasificador;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.detalles = datos;
        }, function (error) {
        });
    }

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {

        $scope.detalles.AudUserName = authService.authentication.userName;
        $scope.detalles.AddIdent = authService.authentication.isAddIdent;
        $scope.detalles.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.detalle, $scope.url);
        servCall.then(function (response) {
            $log.log(response);
            switch (response.data.estado) {
                case 0:
                    $scope.error = response.data.respuesta;
                    break;
                case 2:
                    $uibModalInstance.close($scope.detalle);
                    break;
                case 1:
                    $uibModalInstance.close($scope.detalle);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);