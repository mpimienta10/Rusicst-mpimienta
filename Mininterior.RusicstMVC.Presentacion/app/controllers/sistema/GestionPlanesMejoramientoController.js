app.controller('GestionPlanesMejoramientoController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$templateCache', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $templateCache, authService) {
    //------------------- Inicio logica de la grilla -------------------
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
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'FechaLimite' || col.colDef.displayName === 'Fecha Limite') value = new Date(value).toLocaleDateString();
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
            name: '  ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpConfigurarPlan(row.entity)">Configurar</a></div>',
            enableFiltering: false,
            enablePinning: true,
            pinnedRigth: true,
            minWidth: 145,
            width: 145,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        }
    ];

    //// Personalizar rejilla y exportación
    var columnsNoVisibles =
    [
        "IdPlanMejoramiento"
    ];

    $scope.datePicker = {
        options: {
            formatMonth: 'MM',
            startingDay: 1
        },
        format: "dd/MM/yyyy"
    };

    $scope.showDatePopup = [];
    $scope.showDatePopup.push({ opened: false });

    var formatDate =
       {
           action: "CambiarFecha",
           parameters: [
               { field: "FechaLimite" },
           ]
       };

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "IdPlanMejoramiento", newProperty: "Id Plan de Mejoramiento" },
            { field: "URLList", newProperty: "Encuesta(s)" },
            { field: "FechaLimite", newProperty: "Fecha Limite" },
        ]
    };

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/PlanesMejoramiento/ListadoPlanes/';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };


    //------------------------Lógica de Modal de Acciones -----------------------------------------
    $scope.PopUpNuevoPlan = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoPlan.html',
            controller: 'ModalNuevoPlanController',
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
                 var mensaje = 'Se ha Creado el Nuevo Plan de Mejoramiento';
                 openRespuesta(mensaje);
             }
        );
    };

    $scope.PopUpConfigurarPlan = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/ConfigurarPlanMejoramiento.html',
            controller: 'ModalConfigurarPlanController',
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
                 var mensaje = 'Se han actualizado los datos del Plan de Mejoramiento';
                 openRespuesta(mensaje);
             }
        );
    };

    $scope.PopUpTiposRecurso = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/TiposRecursoPlann.html',
            controller: 'ModalRecursosPlanController',
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
                        var url = '/api/Sistema/BancoPreguntas/Eliminar?id=' + entity.IdPregunta;
                        var msn = "Está seguro de eliminar la pregunta con código: " + $scope.Codigo;
                        return { url: url, msn: msn }
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

//Modal nuevo plan
app.controller('ModalNuevoPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.plan = {};
    $log.log(entity);
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '/api/Sistema/PlanesMejoramiento/InsertarPlanMejoramiento/';
    $scope.encuestasSinResponder;

    getListadoEncuestasSinResponder();

    function getListadoEncuestasSinResponder() {
        var url = '/api/Sistema/PlanesMejoramiento/ListadoEncuestasSinResponder?idPlan=null';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.encuestasSinResponder = datos;
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


        $scope.plan.AudUserName = authService.authentication.userName;
        $scope.plan.AddIdent = authService.authentication.isAddIdent;
        $scope.plan.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.plan, $scope.url);

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


    //DataPicker
    $scope.popup1 = {
        opened: false
    };
    $scope.open1 = function () {
        $scope.popup1.opened = true;
    };
    $scope.dateOptions = {
        formatYear: 'yyyy',
        startingDay: 1
    };

    $scope.format = "dd/MM/yyyy";

}]);

app.controller('ModalConfigurarPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModal', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModal, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.plan = {};
    $log.log(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.url = '/api/Sistema/PlanesMejoramiento/ActualizarPlanMejoramiento/';

    $scope.plan.idPlan = entity.IdPlanMejoramiento;
    $scope.plan.nombrePlan = entity.Nombre.toString();
    $scope.plan.fechaLimite = new Date(entity.FechaLimite);

    $scope.plan.AudUserName = authService.authentication.userName;
    $scope.plan.AddIdent = authService.authentication.isAddIdent;
    $scope.plan.UserNameAddIdent = authService.authentication.userNameAddIdent;

    getListadoEncuestasSinResponder();
    getListadoEncuestasAsignadasPlan();

    function getListadoEncuestasSinResponder() {
        var url = '/api/Sistema/PlanesMejoramiento/ListadoEncuestasSinResponder?idPlan=' + $scope.plan.idPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.encuestasSinResponder = datos;
        }, function (error) {
        });
    }

    function getListadoEncuestasAsignadasPlan() {
        var url = '/api/Sistema/PlanesMejoramiento/ListadoEncuestasPlan?idPlan=' + $scope.plan.idPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            //$scope.plan.encuestasAsociadas = datos;
            $scope.plan.idEncuesta = datos.Id;
        }, function (error) {
        });
    }

    //Defs Grid

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
            field: 'Eliminar',
            name: ' ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.openPopUpEliminarRecomendacion(row.entity)">Eliminar</a></div>',
            enableFiltering: false,
            pinnedLeft: true,
            minWidth: 70,
            width: 70,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        },
        {
            field: 'Editar',
            name: 'Editar',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpEditarSeccion(row.entity)">Editar</a></div>',
            enableFiltering: false,
            enablePinning: true,
            pinnedRigth: true,
            minWidth: 145,
            width: 145,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        },
        {
            field: 'Objetivos',
            name: 'Objetivos',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpObjetivosSeccion(row.entity)">Objetivos</a></div>',
            enableFiltering: false,
            enablePinning: true,
            pinnedRigth: true,
            minWidth: 145,
            width: 145,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        }
    ];

    //// Personalizar rejilla y exportación
    var columnsNoVisibles =
    [
        "IdSeccionPlanMejoramiento",
        "IdSeccionPlanMejoramientoPadre",
        "IdPlanMejoramiento"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "ObjetivoGeneral", newProperty: "Objetivo General" },
        ]
    };

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/PlanesMejoramiento/SeccionesPlan/ListadoSecciones?idPlan=' + $scope.plan.idPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            if (datos.length > 0) {
                $scope.cargoDatos = true;
                $scope.isGrid = true;
                $scope.gridOptions.data = datos;

                if (!$scope.isColumnDefs) {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
                    $scope.isColumnDefs = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
                }

                UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            } else {
                $scope.cargoDatos = true;
                $scope.isGrid = false;
            }
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    //Modal Eliminar Recomendacion

    $scope.openPopUpEliminarRecomendacion = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            backdrop: 'static', keyboard: false,
            resolve: {
                datos: function () {
                    if (entity) {

                        entity.idSeccion = entity.IdSeccionPlanMejoramiento;
                        entity.AudUserName = authService.authentication.userName;
                        entity.AddIdent = authService.authentication.isAddIdent;
                        entity.UserNameAddIdent = authService.authentication.userNameAddIdent;

                        var url = '/api/Sistema/PlanesMejoramiento/SeccionesPlan/EliminarSeccion/';
                        var msn = "¿Está seguro que quiere eliminar la Sección?";
                        return { url: url, msn: msn, entity: entity }
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function () {
                 getDatos();
                 var mensaje = 'Se ha eliminado correctamente la Sección.';
                 openRespuesta(mensaje);
             }
        );
    };

    //Modal editar detalle

    $scope.PopUpEditarSeccion = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarSeccionPlan.html',
            controller: 'ModalEditarSeccionPlanController',
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
                 getDatos();
                 var mensaje = 'Se han actualizado los datos de la Sección';
                 openRespuesta(mensaje);
             }
        );
    };

    $scope.PopUpNuevaSeccion = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarSeccionPlan.html',
            controller: 'ModalNuevaSeccionPlanController',
            size: 'md',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {
                        return angular.copy(entity);
                    } else {
                        entity = { IdPlanMejoramiento: $scope.plan.idPlan };

                        return angular.copy(entity);
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
                 getDatos();
                 var mensaje = 'Se ha Creado la Nueva Sección';
                 openRespuesta(mensaje);
             }
        );
    };

    //Modal Objetivos + Recomendaciones

    $scope.PopUpObjetivosSeccion = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/RecomendacionesPlan.html',
            controller: 'ModalRecomendacionesPlanController',
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
             }
        );
    };


    //Modal Activar Plan

    $scope.PopUpActivarPlan = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/ActivacionPlan.html',
            controller: 'ModalActivarPlanController',
            size: 'md',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {
                        return angular.copy(entity);
                    } else {
                        return angular.copy($scope.plan);
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
                 var mensaje = resultado.data.respuesta;
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

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {


        var servCall = APIService.saveSubscriber($scope.plan, $scope.url);
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

    //DataPicker
    $scope.popup1 = {
        opened: false
    };
    $scope.open1 = function () {
        $scope.popup1.opened = true;
    };
    $scope.dateOptions = {
        formatYear: 'yyyy',
        startingDay: 1
    };

    $scope.format = "dd/MM/yyyy";
}]);

app.controller('ModalEditarSeccionPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.seccion = {};
    $log.log(entity);
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '/api/Sistema/PlanesMejoramiento/SeccionesPlan/ActualizarSeccion/';

    $scope.seccion.idSeccion = entity.IdSeccionPlanMejoramiento.toString();
    $scope.seccion.idPlan = entity.IdPlanMejoramiento.toString();
    $scope.seccion.objetivoGeneral = entity.ObjetivoGeneral.toString();
    $scope.seccion.titulo = entity.Titulo.toString();
    $scope.seccion.ayuda = entity.Ayuda.toString();
    $scope.seccion.idSeccionPadre = entity.IdSeccionPlanMejoramientoPadre.toString();

    $scope.seccion.AudUserName = authService.authentication.userName;
    $scope.seccion.AddIdent = authService.authentication.isAddIdent;
    $scope.seccion.UserNameAddIdent = authService.authentication.userNameAddIdent;

    $log.log($scope.url);

    $scope.seccionPadre;

    $scope.seccionesEncuestas;

    getSeccionesEncuestas();

    function getSeccionesEncuestas() {
        var url = '/api/Sistema/PlanesMejoramiento/SeccionesPlan/SeccionesEncuestas?idPlan=' + $scope.seccion.idPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.seccionesEncuestas = datos;

            angular.forEach(datos, function (item, key) {
                $log.log(entity.IdSeccionPlanMejoramientoPadre);
                if (item.Id == entity.IdSeccionPlanMejoramientoPadre) {
                    $scope.seccionPadre = $scope.seccionesEncuestas[key];
                }
            });

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

        $scope.seccion.titulo = $scope.seccionPadre.Titulo;
        $scope.seccion.idSeccionPadre = $scope.seccionPadre.Id;

        $log.log($scope.seccion);

        var servCall = APIService.saveSubscriber($scope.seccion, $scope.url);
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

app.controller('ModalNuevaSeccionPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.seccion = {};
    $log.log(entity);
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.seccionPadre;

    $scope.url = '/api/Sistema/PlanesMejoramiento/SeccionesPlan/InsertarSeccion/';

    $scope.seccion.idPlan = entity.IdPlanMejoramiento.toString();
    $scope.seccion.ayuda = '';

    $scope.seccion.AudUserName = authService.authentication.userName;
    $scope.seccion.AddIdent = authService.authentication.isAddIdent;
    $scope.seccion.UserNameAddIdent = authService.authentication.userNameAddIdent;

    $scope.seccionesEncuestas;

    getSeccionesEncuestas();

    function getSeccionesEncuestas() {
        var url = '/api/Sistema/PlanesMejoramiento/SeccionesPlan/SeccionesEncuestas?idPlan=' + $scope.seccion.idPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.seccionesEncuestas = datos;
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

        $log.log($scope.seccionPadre);

        $scope.seccion.titulo = $scope.seccionPadre.Titulo;
        $scope.seccion.idSeccionPadre = $scope.seccionPadre.Id;

        $log.log($scope.seccion);

        var servCall = APIService.saveSubscriber($scope.seccion, $scope.url);
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

app.controller('ModalRecursosPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModal', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModal, $uibModalInstance, $http, entity, UtilsService, authService) {

    $scope.errorMessages = UtilsService.getErrorMessages();

    //Defs Grid

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
            name: '  ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpEditarRecurso(row.entity)">Editar</a></div>',
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
            minWidth: 145,
            width: 145,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        }
    ];

    //// Personalizar rejilla y exportación
    var columnsNoVisibles =
    [
        "IdTipoRecurso"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "NombreTipoRecurso", newProperty: "Nombre Tipo Recurso" },
            { field: "Clase", newProperty: "Clase Tipo Recurso" },
        ]
    };

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/PlanesMejoramiento/RecursosPlan';
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

    //Modal editar detalle

    $scope.PopUpEditarRecurso = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarTipoRecurso.html',
            controller: 'ModalEditarRecursoPlanController',
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
                 var mensaje = 'Se han actualizado los datos del Tipo de Recurso';
                 openRespuesta(mensaje);
             }
        );
    };

    $scope.PopUpNuevoRecurso = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarTipoRecurso.html',
            controller: 'ModalNuevoRecursoPlanController',
            size: 'md',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {
                        return angular.copy(entity);
                    } else {
                        //entity = { IdPlanMejoramiento: $scope.plan.idPlan };

                        //return angular.copy(entity);

                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
                 $scope.isColumnDefs = true;
                 getDatos();
                 var mensaje = 'Se ha Creado el nuevo Tipo de Recurso';
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
        $scope.NombreTipoRecurso = entity.NombreTipoRecurso;
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            backdrop: 'static', keyboard: false,
            resolve: {
                datos: function () {
                    if (entity) {

                        entity.idTipo = entity.IdTipoRecurso;
                        entity.nombreTipo = entity.NombreTipoRecurso;
                        entity.AudUserName = authService.authentication.userName;
                        entity.AddIdent = authService.authentication.isAddIdent;
                        entity.UserNameAddIdent = authService.authentication.userNameAddIdent;
                        
                        var url = '/api/Sistema/PlanesMejoramiento/RecursosPlan/EliminarRecurso';
                        var msn = "Está seguro de eliminar el recurso: " + $scope.NombreTipoRecurso;
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
                 var mensaje = 'El Recurso: ' + $scope.NombreTipoRecurso + ' ha sido eliminado satisfactoriamente.';
                 openRespuesta(mensaje);
             }
        );
    };

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

}]);

app.controller('ModalNuevoRecursoPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.tipo = {};

    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.seccionPadre;

    $scope.url = '/api/Sistema/PlanesMejoramiento/RecursosPlan/InsertarRecurso/';

    $scope.tipo.AudUserName = authService.authentication.userName;
    $scope.tipo.AddIdent = authService.authentication.isAddIdent;
    $scope.tipo.UserNameAddIdent = authService.authentication.userNameAddIdent;

    $scope.tiposClase = [{
        Id: 'MONEDA',
        Nombre: 'Moneda'
    }, {
        Id: 'NUMERO',
        Nombre: 'Número'
    }, {
        Id: 'PARAGRAFO',
        Nombre: 'Parágrafo'
    }];

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {

        var servCall = APIService.saveSubscriber($scope.tipo, $scope.url);
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

app.controller('ModalEditarRecursoPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.tipo = {};
    $log.log(entity);
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '/api/Sistema/PlanesMejoramiento/RecursosPlan/ActualizarRecurso/';

    $scope.tiposClase = [{
        Id: 'MONEDA',
        Nombre: 'Moneda'
    }, {
        Id: 'NUMERO',
        Nombre: 'Número'
    }, {
        Id: 'PARAGRAFO',
        Nombre: 'Parágrafo'
    }];

    $scope.tipo.idTipo = entity.IdTipoRecurso.toString();
    $scope.tipo.nombreTipo = entity.NombreTipoRecurso.toString();
    $scope.tipo.clase = entity.Clase.toString();

    $scope.tipo.AudUserName = authService.authentication.userName;
    $scope.tipo.AddIdent = authService.authentication.isAddIdent;
    $scope.tipo.UserNameAddIdent = authService.authentication.userNameAddIdent;

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {

        var servCall = APIService.saveSubscriber($scope.tipo, $scope.url);
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

app.controller('ModalRecomendacionesPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModal', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModal, $uibModalInstance, $http, entity, UtilsService, authService) {

    $scope.seccion = {};
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.url = '/api/Sistema/PlanesMejoramiento/ActualizarPlanMejoramiento/';

    $scope.seccion.idPlan = entity.IdPlanMejoramiento;
    $scope.seccion.idSeccion = entity.IdSeccionPlanMejoramiento;

    //Defs Grid

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
            name: '    ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.openPopUpEliminarRecomendacion(row.entity)">Eliminar</a></div>',
            enableFiltering: false,
            enablePinning: true,
            pinnedRigth: true,
            minWidth: 145,
            width: 145,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        }
    ];

    //// Personalizar rejilla y exportación
    var columnsNoVisibles =
    [
        "IdRecomendacion",
        "IdSeccionPlanMejoramiento",
        "IdObjetivoEspecifico",
        "IdPregunta",
        "Calificacion"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "ObjetivoEspecifico", newProperty: "Objetivo Específico" },
            { field: "ObjetivoGeneral", newProperty: "Objetivo General" },
            { field: "Opcion", newProperty: "Opción" },
            { field: "Calificacion", newProperty: "Calificación" },
            { field: "PorcentajeObjetivo", newProperty: "Porcentaje" },
            { field: "NombrePregunta", newProperty: "Pregunta" },
            { field: "Recomendacion", newProperty: "Recomendación" },
            { field: "Titulo", newProperty: "Sección" },
        ]
    };

    var changeWidth = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "ObjetivoEspecifico", newProperty: 200 },
            { field: "ObjetivoGeneral", newProperty: 200 },
            { field: "Opcion", newProperty: 125 },
            { field: "Calificacion", newProperty: 100 },
            { field: "PorcentajeObjetivo", newProperty: 135 },
            { field: "NombrePregunta", newProperty: 100 },
            { field: "Recomendacion", newProperty: 135 },
            { field: "Titulo", newProperty: 135 }
        ]
    };

    var changeMinWidth = {
        action: "CambiarDefinicion",
        definition: "minWidth",
        parameters: [
            { field: "ObjetivoEspecifico", newProperty: 200 },
            { field: "ObjetivoGeneral", newProperty: 200 },
            { field: "Opcion", newProperty: 125 },
            { field: "Calificacion", newProperty: 100 },
            { field: "PorcentajeObjetivo", newProperty: 135 },
            { field: "NombrePregunta", newProperty: 100 },
            { field: "Recomendacion", newProperty: 135 },
            { field: "Titulo", newProperty: 135 }
        ]
    };

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ListadoRecomendaciones?idSeccion=' + $scope.seccion.idSeccion;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {

            if (datos.length > 0) {

                $scope.cargoDatos = true;
                $scope.isGrid = true;
                $scope.gridOptions.data = datos;

                if (!$scope.isColumnDefs) {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
                    $scope.isColumnDefs = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
                }

                UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions, changeWidth);
                UtilsService.utilsGridOptions($scope.gridOptions, changeMinWidth);
            } else {
                $scope.cargoDatos = true;
                $scope.isGrid = false;
            }            

        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    //Modal Eliminar Recomendacion

    $scope.openPopUpEliminarRecomendacion = function (entity) {

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

                        var url = '/api/Sistema/PlanesMejoramiento/RecomendacionesPlan/EliminarRecomendacion';
                        var msn = "¿Está seguro que quiere eliminar la recomendación?";
                        return { url: url, msn: msn, entity: entity }
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function () {
                 getDatos();
                 var mensaje = 'Se ha Eliminado la Recomendación.';
                 openRespuesta(mensaje);
             }
        );
    };


    //Modal Nueva Recomendacion

    $scope.PopUpCrearRecomendaciones = function (entity) {

        var url = "/api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ValidarCreacionRecomendaciones?idPlan=" + $scope.seccion.idPlan + "&idSeccion=" + $scope.seccion.idSeccion;

        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.proceder = datos;

            if ($scope.proceder) {
                var modalInstance = $uibModal.open({
                    templateUrl: 'app/views/sistema/modals/NuevoEditarRecomendacionesPlan.html',
                    controller: 'ModalNuevaRecomendacionPlanController',
                    size: 'md',
                    backdrop: 'static', keyboard: false,
                    resolve: {
                        entity: function () {
                            if (entity) {
                                return angular.copy(entity);
                            } else {
                                entity = { IdPlanMejoramiento: $scope.seccion.idPlan, IdSeccionPlanMejoramiento: $scope.seccion.idSeccion };

                                return angular.copy(entity);
                            }
                        }
                    }
                });
                modalInstance.result.then(
                     function (resultado) {
                         getDatos();
                         var mensaje = resultado.respuesta;

                         if (resultado.estado == 1)
                         {
                             openRespuesta(mensaje);
                         } else {
                             openRespuestaWarning(mensaje);
                         }                         
                     }
                );
            } else {
                var mensaje = 'No se puede cargar el formulario de creación de Objetivos Específicos y Recomendaciones. El porcentaje total actualmente usado es 100%.';
                openRespuestaWarning(mensaje);
            }


        }, function (error) {
        });
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

    //Alerta Warning
    var openRespuestaWarning = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    $scope.deshabiltarRegistrese = false;
                    var enviar = { msn: mensaje, tipo: "alert alert-warning" };
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

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);

app.controller('ModalNuevaRecomendacionPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModal', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModal, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.objetivo = { porcObjetivo: 1, objetivoEspecifico: '' };
    $scope.recomendacion = {};
    $scope.datos = {};

    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.seccionPadre;

    $scope.listaPreguntasFiltered = [];
    $scope.listaOpciones = [];
    $scope.recomendacion = [];
    $scope.maxPorcentaje = 0;

    $scope.url = '/api/Sistema/PlanesMejoramiento/RecomendacionesPlan/InsertarObjetivoRecomendaciones/';

    $scope.datos.AudUserName = authService.authentication.userName;
    $scope.datos.AddIdent = authService.authentication.isAddIdent;
    $scope.datos.UserNameAddIdent = authService.authentication.userNameAddIdent;

    getListadoPreguntasPlan();
    getMaximoPorcentajeRecomendaciones();

    function getListadoPreguntasPlan() {
        var url = '/api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ListadoPreguntasPlan?idPlan=' + entity.IdPlanMejoramiento;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.listaPreguntas = datos;
        }, function (error) {
        });
    }

    function getMaximoPorcentajeRecomendaciones() {
        var url = '/api/Sistema/PlanesMejoramiento/RecomendacionesPlan/PorcentajeRecomendacionesSeccion?idPlan=' + entity.IdPlanMejoramiento + "&idSeccion=" + entity.IdSeccionPlanMejoramiento;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {

            $scope.maxPorcentaje = 100 - datos;

        }, function (error) {
        });
    }

    $scope.getLocation = function (val) {
        //return $http.get('//maps.googleapis.com/maps/api/geocode/json', {
        //    params: {
        //        address: val,
        //        sensor: false
        //    }
        //}).then(function (response) {
        //    return response.data.results.map(function (item) {
        //        return item.formatted_address;
        //    });
        //});

        $scope.listaPreguntasFiltered = [];

        if (val.length > 5) {
            angular.forEach($scope.listaPreguntas, function (pregunta, key) {

                if (pregunta.NombrePregunta.indexOf(val) !== -1) {
                    $scope.listaPreguntasFiltered.push(pregunta);
                }

            });
        }

        return $scope.listaPreguntasFiltered;
    };

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;

        $scope.datos.idSeccion = entity.IdSeccionPlanMejoramiento;
        $scope.datos.objetivoEspecifico = $scope.objetivo.objetivoEspecifico;
        $scope.datos.porcObjetivo = $scope.objetivo.porcObjetivo;
        $scope.datos.recomendaciones = $scope.recomendacion;

        guardarDatos();
    };

    $scope.applyPattern = function (index) {

        if($scope.recomendacion[index].aplica)
        {
            $scope.recomendacion[index].pattern = /^[0-9]*$/;
        } else 
        {
            $scope.recomendacion[index].pattern = '';
        }

    };

    $scope.asociar = function () {

        if (!$scope.validar()) return false;

        var url = "/api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ListadoOpcionesPreguntaAsociada?idPregunta=" + $scope.objetivo.Pregunta.IdPregunta;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.listaOpciones = datos;

            angular.forEach($scope.listaOpciones, function (opcionItem, key) {
                var item = { aplica: false, opcion: opcionItem.Valor, idPregunta: $scope.objetivo.Pregunta.IdPregunta, pattern: '' };

                $scope.recomendacion.push(item);
            });

        }, function (error) {
        });

    };

    function guardarDatos() {

        var servCall = APIService.saveSubscriber($scope.datos, $scope.url);
        servCall.then(function (response) {
            $log.log(response);
            switch (response.data.estado) {
                case 0:
                    $scope.error = response.data.respuesta;
                    break;
                case 2:
                    $uibModalInstance.close(response.data);
                    break;
                case 1:
                    $uibModalInstance.close(response.data);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //Modales buscar recomendacion y objetivos
    $scope.PopUpBuscarObjetivos = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/ModalObjetivosPrevios.html',
            controller: 'ModalBuscarObjetivosController',
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
                 //aca va la copia del objetivo seleccionado
                 $scope.objetivo.objetivoEspecifico = resultado.ObjetivoEspecifico;
             }
        );
    };

    $scope.PopUpBuscarRecomendaciones = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/ModalRecomendacionesPrevias.html',
            controller: 'ModalBuscarRecomendacionesController',
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
                 //aca va la copia de las recomendaciones seleccionadas
                 angular.forEach($scope.recomendacion, function (reco, key) {
                     for (var i = 0; i < resultado.length; i++) {
                         if (reco.opcion === resultado[i].Opcion) {
                             reco.aplica = true;
                             reco.calificacion = resultado[i].Calificacion;
                             reco.texto = resultado[i].Recomendacion;
                         }
                     }
                 });
             }
        );
    };

}]);

app.controller('ModalBuscarObjetivosController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.objetivo = {};

    $scope.errorMessages = UtilsService.getErrorMessages();

    //Defs Grid

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

            //Selección de datos
            gridApi.selection.on.rowSelectionChanged($scope, function (row) {
                if (row.isSelected) {
                    $scope.objetivo = row.entity;
                } else {
                    //var index = $scope.registro.idsUsuariosArray.indexOf(row.entity.IdUser);
                    //if (index != -1) {
                    //    $scope.registro.idsUsuariosArray.splice(index, 1);
                    //}
                    $scope.objetivo = {};
                }
            });
        },
    };

    $scope.gridOptions.multiSelect = false;
    $scope.gridOptions.enableSelectAll = false;

    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    var columnActions = [];

    //// Personalizar rejilla y exportación
    var columnsNoVisibles =
    [
        "IdObjetivoEspecifico"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "NombrePlan", newProperty: "Plan Mejoramiento" },
            { field: "FechaLimite", newProperty: "Fecha Límite" },
            { field: "NombreSeccion", newProperty: "Sección" },
            { field: "ObjetivoEspecifico", newProperty: "Objetivo Específico" },
        ]
    };

    var changeWidth = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "NombrePlan", newProperty: 200 },
            { field: "FechaLimite", newProperty: 70 },
            { field: "NombreSeccion", newProperty: 250 },
            { field: "ObjetivoEspecifico", newProperty: 350 }
        ]
    };

    var changeMinWidth = {
        action: "CambiarDefinicion",
        definition: "minWidth",
        parameters: [
            { field: "NombrePlan", newProperty: 200 },
            { field: "FechaLimite", newProperty: 70 },
            { field: "NombreSeccion", newProperty: 250 },
            { field: "ObjetivoEspecifico", newProperty: 350 }
        ]
    };

    var formatDate = {
        action: "CambiarFecha",
        parameters: [
            { field: "FechaLimite" },
        ]
    };

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ListadoBusquedaObjetivos';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            if (!$scope.isColumnDefs) {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
                $scope.isColumnDefs = true;
            } else {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
            }

            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            UtilsService.utilsGridOptions($scope.gridOptions, changeWidth);
            UtilsService.utilsGridOptions($scope.gridOptions, changeMinWidth);
            UtilsService.utilsGridOptions($scope.gridOptions, formatDate);

        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };



    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        $uibModalInstance.close($scope.objetivo);
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

}]);

app.controller('ModalBuscarRecomendacionesController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.recomendacion = [];

    $scope.errorMessages = UtilsService.getErrorMessages();

    //Defs Grid

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

            //Selección de datos
            gridApi.selection.on.rowSelectionChanged($scope, function (row) {
                if (row.isSelected) {
                    $scope.recomendacion.push(row.entity);
                } else {
                    var index = $scope.recomendacion.IdRecomendacion.indexOf(row.entity.IdRecomendacion);
                    if (index != -1) {
                        $scope.recomendacion.splice(index, 1);
                    }
                }
            });
        },
    };

    $scope.gridOptions.multiSelect = true;
    $scope.gridOptions.enableSelectAll = false;

    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    var columnActions = [];

    //// Personalizar rejilla y exportación
    var columnsNoVisibles =
    [
        "IdRecomendacion",
        "IdObjetivoEspecifico",
        "ObjetivoEspecifico",
        "PorcentajeObjetivo",
        "ObjetivoGeneral",
        "IdSeccionPlanMejoramiento",
        "Titulo",
        "Ayuda",
        "IdPlanMejoramiento",
        "FechaLimite",
        "CondicionesAplicacion",
        "CodigoPregunta",
        "NombrePregunta",
        "IdTipoPregunta"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Nombre", newProperty: "Plan Mejoramiento" },
            { field: "Opcion", newProperty: "Opción" },
            { field: "Recomendacion", newProperty: "Recomendación" },
            { field: "Calificacion", newProperty: "Calificación" },
        ]
    };

    var changeWidth = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "Nombre", newProperty: 200 },
            { field: "Opcion", newProperty: 150 },
            { field: "Calificacion", newProperty: 150 },
            { field: "Recomendacion", newProperty: 350 }
        ]
    };

    var changeMinWidth = {
        action: "CambiarDefinicion",
        definition: "minWidth",
        parameters: [
            { field: "Nombre", newProperty: 200 },
            { field: "Opcion", newProperty: 150 },
            { field: "Calificacion", newProperty: 150 },
            { field: "Recomendacion", newProperty: 350 }
        ]
    };

    var formatDate = {
        action: "CambiarFecha",
        parameters: [
            { field: "FechaLimite" },
        ]
    };

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ListadoBusquedaRecomendaciones?idPregunta=' + entity;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            if (!$scope.isColumnDefs) {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
                $scope.isColumnDefs = true;
            } else {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
            }

            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            UtilsService.utilsGridOptions($scope.gridOptions, changeWidth);
            UtilsService.utilsGridOptions($scope.gridOptions, changeMinWidth);
            UtilsService.utilsGridOptions($scope.gridOptions, formatDate);

        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };



    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        $uibModalInstance.close($scope.recomendacion);
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

}]);

app.controller('ModalActivarPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.activacion = { idPlan: entity.idPlan, fechaIni: new Date(), fechaFin: new Date(), muestraPorc: false };

    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '/api/Sistema/PlanesMejoramiento/ActivarPlan/';

    function getDatosActivacionPlan() {
        var url = '/api/Sistema/PlanesMejoramiento/DatosActivacionPlan?idPlan=' + entity.idPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {


            $scope.activacion.muestraPorc = response.bitShowPorcentaje;
            $scope.activacion.fechaIni = new Date(response.FechaInicio);
            $scope.activacion.fechaFin = new Date(response.FechaFin);

        }, function (error) {
        });
    };

    getDatosActivacionPlan();

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;

        var url = '/api/Sistema/PlanesMejoramiento/ValidarActivacionPlan?idPlan=' + $scope.activacion.idPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            
            if(response) {
                guardarDatos();
            }
            else {
                var mensaje = { msn: "El Plan de Mejoramiento no se puede activar!", tipo: "alert alert-danger" };
                
                UtilsService.abrirRespuesta(mensaje);
            }


        }, function (error) {
        });
    };


    function guardarDatos() {

        $scope.activacion.AudUserName = authService.authentication.userName;
        $scope.activacion.AddIdent = authService.authentication.isAddIdent;
        $scope.activacion.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.activacion, $scope.url);
        servCall.then(function (response) {
            $log.log(response);
            switch (response.data.estado) {
                case 0:
                    $scope.error = response.data.respuesta;
                    break;
                case 2:
                    $uibModalInstance.close(response);
                    break;
                case 1:
                    $uibModalInstance.close(response);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };


    //DataPicker

    $scope.minDate = new Date();

    $scope.popup1 = {
        opened: false
    };
    $scope.open1 = function () {
        $scope.popup1.opened = true;
    };
    $scope.dateOptions = {
        formatYear: 'yyyy',
        startingDay: 1
    };

    $scope.format = "dd/MM/yyyy";

    $scope.$watch('popup1.opened', function (newVal, oldVal) {
        if (newVal != oldVal && !newVal) {
            //close event
            
            //si las fecha de inicio es mayor que la fecha final, la cambiamos
            if ($scope.activacion.fechaIni > $scope.activacion.fechaFin)
            {
                $scope.activacion.fechaFin = $scope.activacion.fechaIni;
                $scope.dateOptions2.minDate = $scope.activacion.fechaIni;
            }
        }
    });


    //DataPicker
    $scope.popup2 = {
        opened: false
    };
    $scope.open2 = function () {
        $scope.dateOptions2.minDate = $scope.activacion.fechaIni;
        $scope.popup2.opened = true;
    };
    $scope.dateOptions2 = {
        formatYear: 'yyyy',
        startingDay: 1
    };

}]);