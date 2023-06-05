app.controller('ModificarPreguntasController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService) {
    //------------------- Inicio logica de filtros de la pantalla -------------------
    $scope.filtro = {};
    $scope.grupos = [];
    $scope.columnDefsFijas = [];
    $scope.cargoDatos = false;

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
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición del combo de encuestas";
        });
    }

    cargarComboReportes();

    //cargar el combo de los grupos de un reporte seleccionado
    $scope.cargarComboGrupo = function () {
        $scope.secciones = [];
        $scope.subsecciones = [];
        if ($scope.filtro.idEncuesta) {
            var url = '/api/General/Listas/SeccionXEncuesta?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent + '&idEncuesta=' + $scope.filtro.idEncuesta;
            getDatos();
            function getDatos() {
                var servCall = APIService.getSubs(url);
                servCall.then(function (datos) {
                    $scope.grupos = datos;
                }, function (error) {
                    $scope.error = "Se generó un error en la petición del combo de grupo";
                });
            }
        }
    }

    //cargar el combo de los seccion de un grupo seleccionado
    $scope.cargarComboSeccion = function () {
        $scope.subsecciones = [];
        if ($scope.filtro.idGrupo) {
            var url = '/api/General/Listas/SeccionXGrupo?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent + '&idGrupo=' + $scope.filtro.idGrupo + '&idEncuesta=' + $scope.filtro.idEncuesta;
            getDatos();
            function getDatos() {
                var servCall = APIService.getSubs(url);
                servCall.then(function (datos) {
                    $scope.secciones = datos;
                }, function (error) {
                    $scope.error = "Se generó un error en la petición del combo de seccion ";
                });
            }
        } else {
            $scope.secciones = [];
        }
    }

    //cargar el combo de las subsecciones de la seccion seleccionada
    $scope.cargarComboSubSeccion = function () {
        if ($scope.filtro.idSeccion) {
            var url = '/api/General/Listas/SubSeccionXSeccion?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent + '&idSeccion=' + $scope.filtro.idSeccion + '&idEncuesta=' + $scope.filtro.idEncuesta;
            getDatos();
            function getDatos() {
                var servCall = APIService.getSubs(url);
                servCall.then(function (datos) {
                    $scope.subsecciones = datos;
                }, function (error) {
                    $scope.error = "Se generó un error en la petición del combo de subseccion ";
                });
            }
        } else {
            $scope.subsecciones = [];
        }
    }

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Id", newProperty: "Código Único" },
            { field: "IdPregunta", newProperty: "Código Homologado" },
            { field: "TipoPregunta", newProperty: "Tipo Pregunta" },
            { field: "EsObligatoria", newProperty: "Obligatoria" },
            { field: "Validacion", newProperty: "Validación" },
            { field: "Seccion", newProperty: "Sección" },
        ]
    };

    function agregarColumnasFijas() {
        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 100,
            name: ' ',
            field: 'seleccionar',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.openPopUpSeleccionar(row.entity)">Seleccionar</a></div>',
            enableFiltering: false,
            pinnedRight: true,
            enableCellEdit: false,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
    }

    var changeWidth = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "Nombre", newProperty: 200 },
        ]
    };

    $scope.openPopUpSeleccionar = function (pregunta) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/reportes/modals/Pregunta.html',
            controller: 'ModalPreguntaController',
            size: 'lg',
            resolve: {
                pregunta: function () {
                    if (pregunta) {
                        return pregunta.Id;
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (resultado) {

                $scope.isColumnDefs = true;
                buscarDatos();
                var mensaje;
                if (resultado.estado === 1) mensaje = "El Tipo de Usuario fue creado satisfactoriamente";
                if (resultado.estado === 2) mensaje = "El Tipo de Usuario fue actualizado satisfactoriamente";
                openRespuesta(mensaje);
            }
           );
    };

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

    $scope.buscar = function () {
        buscarDatos();
    }

    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    $scope.validarFiltros = function () {

        var valido = true;

        //codigo banco + idencuesta
        console.log($scope.filtro);
        console.log(angular.isDefined($scope.filtro.idPreguntaAnterior));
        valido = ((angular.isDefined($scope.filtro.idEncuesta) && $scope.filtro.idEncuesta != null) || (angular.isDefined($scope.filtro.idPreguntaAnterior) && $scope.filtro.idPreguntaAnterior != null) || (angular.isDefined($scope.filtro.codigoPreguntaBanco) && $scope.filtro.codigoPreguntaBanco != ''));
        return valido;

    };

    function buscarDatos() {
        $scope.cargoDatos = true;
        $scope.error = null;
        $scope.alerta = null;
        if (!$scope.validarFiltros()) {
            $scope.alerta = "Debe seleccionar una Encuesta para el cargue de la rejilla o buscar por Código Único de Pregunta o por Código Homologado.";
            $scope.cargoDatos = true;
        }
        else {
            var url = '/api/Reportes/ModificarPreguntas/';
            getDatos();
            function getDatos() {
                var servCall = APIService.saveSubscriber($scope.filtro, url);
                servCall.then(function (datos) {
                    $scope.cargoDatos = false;
                    if (datos.data.length > 0) {
                        $scope.isGrid = true;
                        var columsNoVisibles = ["IdSeccion", "RowIndex", "ColumnIndex", "Ayuda", "EsMultiple", ];
                        $scope.gridOptions.data = datos.data;
                        agregarColumnasFijas();
                        if (!$scope.isColumnDefs) {
                            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                            $scope.isColumnDefs = true;
                        } else {
                            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                        }
                        UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                        UtilsService.utilsGridOptions($scope.gridOptions, checboxCell);
                        UtilsService.utilsGridOptions($scope.gridOptions, changeWidth);
                    } else {
                        $scope.isGrid = false;
                        $scope.isColumnDefs = false;
                        $scope.alerta = "No se encontraron datos";
                    }
                }, function (error) {
                    $scope.cargoDatos = false;
                    $scope.error = "Se generó un error en la petición";
                });
            }
        }

    }
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.isExporterPDF = true;
    $scope.gridOptions = {
        columnDefs: [],
        exporterSuppressColumns: ['Id'],
        exporterFieldCallback: function (grid, row, col, value) {
            if ($scope.isExporterPDF === true) {
                if (col.colDef.displayName === 'Nombre') value = UtilsService.exportPdfColumnLarge(col, value);
                if (col.colDef.displayName === 'Validacion') value = UtilsService.exportPdfColumnLarge(col, value);
            }

            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi, $scope.isExporterPDF);
        },
    };
    $scope.isColumnDefs = false;

    var checboxCell = {
        action: "CambiarDefinicion",
        definition: "cellTemplate",
        parameters: [
            { field: "EsObligatoria", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },

        ]
    };
    var optionsFilter = [
        { value: false, label: "NO" },
        { value: true, label: "SI" },
    ];
    var filters = [{ selectOptions: optionsFilter, term: '', type: uiGridConstants.filter.SELECT, condition: uiGridConstants.filter.EXACT, disableCancelFilterButton: true, }, { condition: uiGridConstants.filter.CONTAINS, }];
    var filtersChange = {
        action: "CambiarDefinicion",
        definition: "filters",
        parameters: [
            { field: "Activo", newProperty: filters },

        ]
    };

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

}]);

app.controller('ModalPreguntaController', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, $uibModal, pregunta, authService) {
    $scope.pregunta = {};
    $scope.Idpregunta = 0 || pregunta;
    $scope.pregunta.opciones = [];

    function ObtenerTiposPregunta() {
        var url = '/api/Reportes/ModificarPreguntas/ObtenerTiposPregunta';
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.tipospregunta = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de datos de tipos de pregunta";
        });
    }

    cargarDatosModificar();

    function cargarDatosModificar() {
        var url = '/api/Reportes/ModificarPreguntas/ObtenerDatosPregunta/' + $scope.Idpregunta;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {

            $scope.pregunta = response;
            $scope.pregunta.IdTipoPregunta = response.IdTipoPregunta.toString();
            $scope.editando = true;

            if ($scope.pregunta.TipoPregunta == 'UNICA') {
                buscarOpcionesRespuesta();
            }

        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de datos de la pregunta indicada";
        });
    }

    function buscarOpcionesRespuesta() {
        var url = '/api/Reportes/ModificarPreguntas/ObtenerOpciones/' + $scope.Idpregunta;//este se debe cambiar por el que carga las opciones de respuesta
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.pregunta.opciones = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de datos de opciones de la pregunta";
        });
    }

    $scope.editarOpcion = function (index) {
        $scope.mostrarCampo = true;
        $scope.errorRespuesta = null;
        $scope.alertaRespuesta = null;
        if (index >= 0) {
            $scope.opcion = angular.copy($scope.pregunta.opciones[index]);
        } else {
            $scope.opcion = {};
        }
    }

    $scope.cancelarOpcion = function () {
        $scope.mostrarCampo = false;
        $scope.errorRespuesta = null;
        $scope.alertaRespuesta = null;
        $scope.opcion = {};
    }

    $scope.guardarOpcion = function () {
        $scope.errorRespuesta = null;
        $scope.alertaRespuesta = null;

        //// Datos de la auditoría
        $scope.opcion.AudUserName = authService.authentication.userName;
        $scope.opcion.AddIdent = authService.authentication.isAddIdent;
        $scope.opcion.UserNameAddIdent = authService.authentication.userNameAddIdent;

        if ($scope.opcion.Valor) {
            $scope.opcion.IdPregunta = $scope.pregunta.Id;
            var url = '/api/Reportes/ModificarPreguntas/InsertarOpcion';
            if ($scope.opcion.Id) {
                var url = '/api/Reportes/ModificarPreguntas/ModificarOpcion';
            }
            var servCall = APIService.saveSubscriber($scope.opcion, url);
            servCall.then(function (response) {
                if (response.data.estado > 0) {
                    $scope.alertaRespuesta = response.respuesta;
                    $scope.mostrarCampo = false;
                    buscarOpcionesRespuesta();
                } else {
                    $scope.errorRespuesta = "se genero un error en la peticion, no se guardaron los datos." + response.respuesta;
                }
            }, function (error) {
                $scope.errorRespuesta = "se genero un error en la peticion, no se guardaron los datos";
            });
        } else {
            $scope.errorRespuesta = "Ingrese un valor para la opcion de respuesta";
        }
    }

    $scope.eliminarOpcion = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            resolve: {
                datos: function () {
                    if ($scope.pregunta.opciones[index].Id) {

                        $scope.pregunta.opciones[index].AudUserName = authService.authentication.userName;
                        $scope.pregunta.opciones[index].AddIdent = authService.authentication.isAddIdent;
                        $scope.pregunta.opciones[index].UserNameAddIdent = authService.authentication.userNameAddIdent;

                        var enviar = { url: '/api/Reportes/ModificarPreguntas/EliminarOpcion', msn: "¿Está seguro que quiere eliminar la opción de respuesta?", entity: $scope.pregunta.opciones[index] };
                        return enviar;
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
             function () {
                 cargarDatosModificar();
             }
           );
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

        //// Datos de la auditoría
        $scope.pregunta.AudUserName = authService.authentication.userName;
        $scope.pregunta.AddIdent = authService.authentication.isAddIdent;
        $scope.pregunta.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var url = '/api/Reportes/ModificarPreguntas/Modificar';
        var servCall = APIService.saveSubscriber($scope.pregunta, url);
        servCall.then(function (response) {
            if (response.data.estado > 0) {
                $uibModalInstance.close(response);
            } else {
                $scope.error = "Se generó un error en la petición, no se guardaron los datos." + response.data.respuesta;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }
    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    if ($scope.Idpregunta > 0) {
        ObtenerTiposPregunta();
    }
});