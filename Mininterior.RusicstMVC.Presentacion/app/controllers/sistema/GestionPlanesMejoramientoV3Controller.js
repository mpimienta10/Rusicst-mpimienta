app.controller('GestionPlanesMejoramientoV3Controller', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$templateCache', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $templateCache, authService) {
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
    ////*** autoajustar
    //$scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
    //    if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    //});

    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid'); }
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
        },
        {
            name: ' ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpConfigurarSeguimientoPlan(row.entity)">Seguimiento</a></div>',
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
        var url = '/api/Sistema/PlanesMejoramientoV3/ListadoPlanes/';
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
                 var mensaje = 'Se ha creado el nuevo Plan de Mejoramiento';
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

    $scope.PopUpConfigurarSeguimientoPlan = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/ConfigurarSeguimientoPlanMejoramiento.html',
            controller: 'ModalConfigurarSeguimientoPlanController',
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
             }
        );
    };

    $scope.PopUpEstadosAcciones = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/EstadosAccionesSeguimiento.html',
            controller: 'ModalEstadosAccionesPlanController',
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
    //------------------Fin Lógica de acciones---------------------
}]);

//Modal nuevo plan
app.controller('ModalNuevoPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.plan = {};
    $log.log(entity);
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '/api/Sistema/PlanesMejoramientoV3/InsertarPlanMejoramiento/';
    $scope.encuestasSinResponder;

    getListadoEncuestasSinResponder();

    function getListadoEncuestasSinResponder() {
        var url = '/api/Sistema/PlanesMejoramientoV3/ListadoEncuestasSinResponder?idPlan=null';
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

//Modal configurar plan (diligenciamiento)
app.controller('ModalConfigurarPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModal', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModal, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.plan = {};
    $log.log(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.url = '/api/Sistema/PlanesMejoramientoV3/ActualizarPlanMejoramiento/';

    $scope.plan.idPlan = entity.IdPlanMejoramiento;
    $scope.plan.nombrePlan = entity.Nombre.toString();
    $scope.plan.fechaLimite = new Date(entity.FechaLimite);

    $scope.plan.AudUserName = authService.authentication.userName;
    $scope.plan.AddIdent = authService.authentication.isAddIdent;
    $scope.plan.UserNameAddIdent = authService.authentication.userNameAddIdent;

    getListadoEncuestasSinResponder();
    getListadoEncuestasAsignadasPlan();

    function getListadoEncuestasSinResponder() {
        var url = '/api/Sistema/PlanesMejoramientoV3/ListadoEncuestasSinResponder?idPlan=' + $scope.plan.idPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.encuestasSinResponder = datos;
        }, function (error) {
        });
    }

    function getListadoEncuestasAsignadasPlan() {
        var url = '/api/Sistema/PlanesMejoramientoV3/ListadoEncuestasPlan?idPlan=' + $scope.plan.idPlan;
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
    $scope.isGrid2 = false;
    $scope.isColumnDefs2 = false;
    $scope.cargoDatos = null;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];

    $scope.gridOptions2 = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi2 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };

    ////*** autoajustar
    //$scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
    //    if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    //});

    //*** autoajustar
    $scope.$watchGroup(['gridOptions2.totalItems', 'gridOptions2.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions2.totalItems, $scope.gridOptions2.paginationCurrentPage, $scope.gridOptions2.paginationPageSize, 'grid2'); }
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
            field: 'ObjetivosGenerales',
            name: 'Objetivos Generales',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpObjetivosSeccion(row.entity)">Objetivos Generales</a></div>',
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
        "IdPlanMejoramiento",
        "ObjetivoGeneral"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "ObjetivoGeneral", newProperty: "Objetivo General" },
        ]
    };

    $scope.gridOptions2.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion2 = function () {
        $scope.gridApi2.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/PlanesMejoramientoV3/SeccionesPlan/ListadoSecciones?idPlan=' + $scope.plan.idPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            if (datos.length > 0) {
                $scope.cargoDatos = true;
                $scope.isGrid2 = true;
                $scope.gridOptions2.data = datos;

                if (!$scope.isColumnDefs2) {
                    UtilsService.getColumnDefs($scope.gridOptions2, $scope.isColumnDefs2, columnActions, columnsNoVisibles);
                    $scope.isColumnDefs2 = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions2, $scope.isColumnDefs2, columnActions, columnsNoVisibles);
                }

                UtilsService.utilsGridOptions($scope.gridOptions2, actionJson);
                UtilsService.autoajustarAltura($scope.gridOptions2.totalItems, $scope.gridOptions2.paginationCurrentPage, $scope.gridOptions2.paginationPageSize, 'grid2');

            } else {
                $scope.cargoDatos = true;
                $scope.isGrid2 = false;
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

                        var url = '/api/Sistema/PlanesMejoramientoV3/SeccionesPlan/EliminarSeccion/';
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
                 var mensaje = 'Se ha creado la nueva sección';
                 openRespuesta(mensaje);
             }
        );
    };

    //Modal Estrategias + Tareas

    $scope.PopUpEstrategiasSeccion = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/TareasPlan.html',
            controller: 'ModalTareasPlanController',
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

    $scope.PopUpObjetivosSeccion = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/ObjetivosPlan.html',
            controller: 'ModalObjetivosPlanController',
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
            templateUrl: 'app/views/sistema/modals/ActivacionPlanV3.html',
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
    $scope.url = '/api/Sistema/PlanesMejoramientoV3/SeccionesPlan/ActualizarSeccion/';

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
        var url = '/api/Sistema/PlanesMejoramientoV3/SeccionesPlan/SeccionesEncuestas?idPlan=' + $scope.seccion.idPlan;
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
        $scope.seccion.objetivoGeneral = "";

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

    $scope.url = '/api/Sistema/PlanesMejoramientoV3/SeccionesPlan/InsertarSeccion/';

    $scope.seccion.idPlan = entity.IdPlanMejoramiento.toString();
    $scope.seccion.ayuda = '';

    $scope.seccion.AudUserName = authService.authentication.userName;
    $scope.seccion.AddIdent = authService.authentication.isAddIdent;
    $scope.seccion.UserNameAddIdent = authService.authentication.userNameAddIdent;

    $scope.seccionesEncuestas;

    getSeccionesEncuestas();

    function getSeccionesEncuestas() {
        var url = '/api/Sistema/PlanesMejoramientoV3/SeccionesPlan/SeccionesEncuestas?idPlan=' + $scope.seccion.idPlan;
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
        $scope.seccion.objetivoGeneral = "";

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

//Modal objetivos generales (lista)
app.controller('ModalObjetivosPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModal', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModal, $uibModalInstance, $http, entity, UtilsService, authService) {

    $scope.seccion = {};
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.url = '/api/Sistema/PlanesMejoramiento/ActualizarPlanMejoramiento/';

    $scope.seccion.idPlan = entity.IdPlanMejoramiento;
    $scope.seccion.idSeccion = entity.IdSeccionPlanMejoramiento;

    //Defs Grid

    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid4 = false;
    $scope.isColumnDefs4 = false;
    $scope.cargoDatos = null;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];

    $scope.gridOptions4 = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi4 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };

    //*** autoajustar
    //$scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
    //    if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    //});

    $scope.$watchGroup(['gridOptions4.totalItems', 'gridOptions3.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions4.totalItems, $scope.gridOptions4.paginationCurrentPage, $scope.gridOptions4.paginationPageSize, 'grid4'); }
    });

    var columnActions = [
        {
            name: '    ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.openPopUpEliminarObjetivo(row.entity)">Eliminar</a></div>',
            enableFiltering: false,
            enablePinning: true,
            pinnedRigth: true,
            minWidth: 145,
            width: 145,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        },
        {
            field: 'Editar',
            name: 'Editar',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpEditarObjetivo(row.entity)">Editar</a></div>',
            enableFiltering: false,
            enablePinning: true,
            pinnedRigth: true,
            minWidth: 145,
            width: 145,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        },
        {
            field: 'Estrategias',
            name: 'Estrategias',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpEstrategiasObjetivo(row.entity)">Estrategias</a></div>',
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
        "IdObjetivoGeneral",
        "IdSeccionPlanMejoramiento",
        "Ayuda",
        "IdPlanMejoramiento"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "ObjetivoGeneral", newProperty: "Objetivo General" },
            { field: "Titulo", newProperty: "Sección" },
        ]
    };

    var changeWidth = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "ObjetivoGeneral", newProperty: 200 },
            { field: "Titulo", newProperty: 135 }
        ]
    };

    var changeMinWidth = {
        action: "CambiarDefinicion",
        definition: "minWidth",
        parameters: [
            { field: "ObjetivoGeneral", newProperty: 200 },
            { field: "Titulo", newProperty: 135 }
        ]
    };

    $scope.gridOptions4.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion4 = function () {
        $scope.gridApi4.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/PlanesMejoramientoV3/ObjetivosGenerales/ListadoObjetivos?idSeccion=' + $scope.seccion.idSeccion;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {

            if (datos.length > 0) {

                $scope.cargoDatos = true;
                $scope.isGrid4 = true;
                $scope.gridOptions4.data = datos;

                if (!$scope.isColumnDefs4) {
                    UtilsService.getColumnDefs($scope.gridOptions4, $scope.isColumnDefs4, columnActions, columnsNoVisibles);
                    $scope.isColumnDefs4 = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions4, $scope.isColumnDefs4, columnActions, columnsNoVisibles);
                }

                UtilsService.utilsGridOptions($scope.gridOptions4, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions4, changeWidth);
                UtilsService.utilsGridOptions($scope.gridOptions4, changeMinWidth);
            } else {
                $scope.cargoDatos = true;
                $scope.isGrid4 = false;
            }

        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    //Modal Editar Objetivo
    $scope.PopUpEditarObjetivo = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarObjetivosPlan.html',
            controller: 'ModalEditarObjetivosPlanController',
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
                 var mensaje = 'Se han actualizado los datos del Objetivo General';
                 openRespuesta(mensaje);
             }
        );
    };

    //Modal Nuevo Objetivo
    $scope.PopUpNuevoObjetivo = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarObjetivosPlan.html',
            controller: 'ModalNuevoObjetivoPlanController',
            size: 'md',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {
                        return angular.copy(entity);
                    } else {
                        entity = { IdSeccionPlanMejoramiento: $scope.seccion.idSeccion };

                        return angular.copy(entity);
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
                 getDatos();
                 var mensaje = 'Se ha creado el Objetivo General';
                 openRespuesta(mensaje);
             }
        );
    };

    //Modal Eliminar Objetivo general
    $scope.openPopUpEliminarObjetivo = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            backdrop: 'static', keyboard: false,
            resolve: {
                datos: function () {
                    if (entity) {

                        $scope.entityDelete = {
                            idSeccion: entity.IdSeccionPlanMejoramiento,
                            idObjetivoGeneral: entity.IdObjetivoGeneral,
                            objetivoGeneral: entity.ObjetivoGeneral
                        };

                        $scope.entityDelete.AudUserName = authService.authentication.userName;
                        $scope.entityDelete.AddIdent = authService.authentication.isAddIdent;
                        $scope.entityDelete.UserNameAddIdent = authService.authentication.userNameAddIdent;

                        var url = '/api/Sistema/PlanesMejoramientoV3/ObjetivosGenerales/EliminarObjetivo';
                        var msn = "¿Está seguro que quiere eliminar el Objetivo General?";
                        return { url: url, msn: msn, entity: $scope.entityDelete }
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function () {
                 getDatos();
                 var mensaje = 'Se ha eliminado el Objetivo General.';
                 openRespuesta(mensaje);
             }
        );
    };

    //Modal Estrategias + Acciones
    $scope.PopUpEstrategiasObjetivo = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/TareasPlan.html',
            controller: 'ModalTareasPlanController',
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

//Modal nuevo objetivo general
app.controller('ModalNuevoObjetivoPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.objetivo = {};
    $log.log(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.url = '/api/Sistema/PlanesMejoramientoV3/ObjetivosGenerales/InsertarObjetivo/';

    $scope.objetivo.idSeccion = entity.IdSeccionPlanMejoramiento.toString();

    $scope.objetivo.AudUserName = authService.authentication.userName;
    $scope.objetivo.AddIdent = authService.authentication.isAddIdent;
    $scope.objetivo.UserNameAddIdent = authService.authentication.userNameAddIdent;

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {
        
        $log.log($scope.objetivo);

        var servCall = APIService.saveSubscriber($scope.objetivo, $scope.url);
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

//Modal editar objetivo general
app.controller('ModalEditarObjetivosPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.objetivo = {};
    $log.log(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '/api/Sistema/PlanesMejoramientoV3/ObjetivosGenerales/ActualizarObjetivo/';

    $scope.objetivo.idSeccion = entity.IdSeccionPlanMejoramiento.toString();
    $scope.objetivo.idObjetivoGeneral = entity.IdObjetivoGeneral.toString();
    $scope.objetivo.objetivoGeneral = entity.ObjetivoGeneral.toString();
        
    $scope.objetivo.AudUserName = authService.authentication.userName;
    $scope.objetivo.AddIdent = authService.authentication.isAddIdent;
    $scope.objetivo.UserNameAddIdent = authService.authentication.userNameAddIdent;
    
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {
        
        $log.log($scope.objetivo);

        var servCall = APIService.saveSubscriber($scope.objetivo, $scope.url);
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

//Modal con rejilla de Acciones y Estrategias
app.controller('ModalTareasPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModal', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModal, $uibModalInstance, $http, entity, UtilsService, authService) {

    $scope.seccion = {};
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.url = '/api/Sistema/PlanesMejoramiento/ActualizarPlanMejoramiento/';

    $scope.seccion.idPlan = entity.IdPlanMejoramiento;
    $scope.seccion.idObjetivoGeneral = entity.IdObjetivoGeneral;

    //Defs Grid

    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid3 = false;
    $scope.isColumnDefs3 = false;
    $scope.cargoDatos = null;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];

    $scope.gridOptions3 = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi3 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };

    //*** autoajustar
    //$scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
    //    if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    //});

    $scope.$watchGroup(['gridOptions3.totalItems', 'gridOptions3.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions3.totalItems, $scope.gridOptions3.paginationCurrentPage, $scope.gridOptions3.paginationPageSize, 'grid3'); }
    });

    var columnActions = [
        {
            name: '    ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.openPopUpEliminarTarea(row.entity)">Eliminar</a></div>',
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
        "IdEstrategia",
        "IdSeccionPlanMejoramiento",
        "IdTarea",
        "IdPregunta"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "ObjetivoGeneral", newProperty: "Objetivo General" },
            { field: "Opcion", newProperty: "Opción" },
            { field: "NombrePregunta", newProperty: "Pregunta" },
            { field: "Titulo", newProperty: "Sección" },
        ]
    };

    var changeWidth = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "Estrategia", newProperty: 200 },
            { field: "ObjetivoGeneral", newProperty: 200 },
            { field: "Opcion", newProperty: 125 },
            { field: "NombrePregunta", newProperty: 100 },
            { field: "Tarea", newProperty: 135 },
            { field: "Titulo", newProperty: 135 }
        ]
    };

    var changeMinWidth = {
        action: "CambiarDefinicion",
        definition: "minWidth",
        parameters: [
            { field: "Estrategia", newProperty: 200 },
            { field: "ObjetivoGeneral", newProperty: 200 },
            { field: "Opcion", newProperty: 125 },
            { field: "NombrePregunta", newProperty: 100 },
            { field: "Tarea", newProperty: 135 },
            { field: "Titulo", newProperty: 135 }
        ]
    };

    $scope.gridOptions3.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion3 = function () {
        $scope.gridApi3.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/PlanesMejoramientoV3/TareasPlan/ListadoTareas?idObjetivoGeneral=' + $scope.seccion.idObjetivoGeneral;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {

            if (datos.length > 0) {

                $scope.cargoDatos = true;
                $scope.isGrid3 = true;
                $scope.gridOptions3.data = datos;

                if (!$scope.isColumnDefs3) {
                    UtilsService.getColumnDefs($scope.gridOptions3, $scope.isColumnDefs3, columnActions, columnsNoVisibles);
                    $scope.isColumnDefs3 = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions3, $scope.isColumnDefs3, columnActions, columnsNoVisibles);
                }

                UtilsService.utilsGridOptions($scope.gridOptions3, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions3, changeWidth);
                UtilsService.utilsGridOptions($scope.gridOptions3, changeMinWidth);
            } else {
                $scope.cargoDatos = true;
                $scope.isGrid3 = false;
            }            

        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    //Modal Eliminar Accion
    $scope.openPopUpEliminarTarea = function (entity) {

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

                        var url = '/api/Sistema/PlanesMejoramientoV3/TareasPlan/EliminarTareas';
                        var msn = "¿Está seguro que quiere eliminar la acción?";
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
                 var mensaje = 'Se ha eliminado la acción.';
                 openRespuesta(mensaje);
             }
        );
    };
    
    //Modal Nueva Accion
    $scope.PopUpCrearRecomendaciones = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarTareasPlan.html',
            controller: 'ModalNuevaTareaPlanController',
            size: 'md',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {
                        return angular.copy(entity);
                    } else {
                        entity = { IdPlanMejoramiento: $scope.seccion.idPlan, IdObjetivoGeneral: $scope.seccion.idObjetivoGeneral };

                        return angular.copy(entity);
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
                 getDatos();
                 var mensaje = resultado.respuesta;

                 if (resultado.estado == 1) {
                     openRespuesta(mensaje);
                 } else {
                     openRespuestaWarning(mensaje);
                 }
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

//Modal agregar Acciones y Estrategias
app.controller('ModalNuevaTareaPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModal', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModal, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.estrategia = { estrategia: '' };
    $scope.tarea = {};
    $scope.datos = {};

    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.seccionPadre;

    $scope.listaPreguntasFiltered = [];
    $scope.listaOpciones = [];
    $scope.tarea = [];
    $scope.maxPorcentaje = 0;

    $scope.url = '/api/Sistema/PlanesMejoramientoV3/TareasPlan/InsertarEstrategiaTareas/';

    $scope.datos.AudUserName = authService.authentication.userName;
    $scope.datos.AddIdent = authService.authentication.isAddIdent;
    $scope.datos.UserNameAddIdent = authService.authentication.userNameAddIdent;

    getListadoPreguntasPlan();

    function getListadoPreguntasPlan() {
        var url = '/api/Sistema/PlanesMejoramiento/RecomendacionesPlan/ListadoPreguntasPlan?idPlan=' + entity.IdPlanMejoramiento;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.listaPreguntas = datos;
        }, function (error) {
        });
    }
    
    $scope.getLocation = function (val) {

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

        $scope.datos.idObjetivoGeneral = entity.IdObjetivoGeneral;
        $scope.datos.estrategia = $scope.estrategia.estrategia;
        $scope.datos.tareas = $scope.tarea;


        guardarDatos();
    };

    $scope.applyPattern = function (index) {

        if ($scope.tarea[index].aplica)
        {
            $scope.tarea[index].pattern = /^[0-9]*$/;
        } else 
        {
            $scope.tarea[index].pattern = '';
        }

    };

    $scope.asociar = function () {

        if (!$scope.validar()) return false;

        var url = "/api/Sistema/PlanesMejoramientoV3/TareasPlan/ListadoOpcionesPreguntaAsociada?idPregunta=" + $scope.estrategia.Pregunta.IdPregunta;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.listaOpciones = datos;
            $scope.tareas = [];

            angular.forEach($scope.listaOpciones, function (opcionItem, key) {
                var item = { aplica: false, opcion: opcionItem.Valor, idPregunta: $scope.estrategia.Pregunta.IdPregunta, pattern: '', tareas: [], textoTarea: '' };

                $scope.tarea.push(item);
            });

        }, function (error) {
        });

    };

    $scope.agregarTarea = function (index) {


        var programaExistente = false;
        angular.forEach($scope.tarea[index].tareas, function (tarea) {
            if (tarea == $scope.tarea[index].textoTarea) {
                programaExistente = true;
            }
        });
        if (!programaExistente) {
            if ($scope.tarea[index].textoTarea.length == 0)
            {
                $scope.tarea[index].textoTareaError = 'Debe escribir el texto de la acción';
            } else
            {
                $scope.tarea[index].tareas.push($scope.tarea[index].textoTarea);
                $scope.tarea[index].textoTarea = '';
                $scope.tarea[index].textoTareaError = '';
            }            
        }
    };

    $scope.borrarTarea = function (index, tIndex) {
        $scope.tarea[index].tareas.splice(tIndex, 1);
    };

    $scope.editarTarea = function (index, tIndex) {
        var modalInstance = $uibModal.open({
            templateUrl: 'edicionTarea.html',
            controller: 'edicionTareaController',
            size: 'sm',
            resolve: {
                tarea: function () {
                    return angular.copy($scope.tarea[index].tareas[tIndex]);
                }
            }
        });
        modalInstance.result.then(
            function (datosResponse) {
                $scope.mensajeWarningEdit = null;
                $scope.mensajeOKEdit = null;
                if (datosResponse) {
                    $scope.tarea[index].tareas[tIndex] = datosResponse;
                }
                else {
                }
            }
        );
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
    $scope.PopUpBuscarEstrategias = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/ModalEstrategiasPrevias.html',
            controller: 'ModalBuscarEstrategiasController',
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
                 $scope.estrategia.estrategia = resultado.Estrategia;
             }
        );
    };

    $scope.PopUpBuscarTareas = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/ModalTareasPrevias.html',
            controller: 'ModalBuscarTareasController',
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
                 angular.forEach($scope.tarea, function (reco, key) {
                     for (var i = 0; i < resultado.length; i++) {
                         if (reco.opcion === resultado[i].Opcion) {
                             reco.aplica = true;
                             reco.texto = resultado[i].Recomendacion;
                         }
                     }
                 });
             }
        );
    };

}]);

//Modal de edicion de Acciones y Estrategias -- no implementado aún
app.controller('edicionTareaController', ['$scope', '$http', 'tarea', '$uibModalInstance', 'Upload', function ($scope, $http, tarea, $uibModalInstance, Upload) {
    $scope.datos = tarea;
    
    $scope.init = function () {
        $scope.submitted = false;
    };

    $scope.errors = [];

    $scope.guardar = function () {
        if (!$scope.validar()) return false;

        if ($scope.datos.length > 1024) {
            $scope.errors.PROGRAMAEDIT = "La acción no debe exceder los 1024 caracteres";
            return false;
        }

        $scope.habilita = true;

        $uibModalInstance.close($scope.datos);
    };
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.validar = function () {
        return $scope.editForm.$valid;
    };
    $scope.BorraMensaje = function () { // $scope que acciona el ng-kepress
        $scope.errors.PROGRAMAEDIT = '';
    };
}]);

app.controller('ModalBuscarEstrategiasController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.estrategia = {};

    $scope.errorMessages = UtilsService.getErrorMessages();

    //Defs Grid

    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid4 = false;
    $scope.isColumnDefs4 = false;
    $scope.cargoDatos = null;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];

    $scope.gridOptions4 = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi4 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);

            //Selección de datos
            gridApi.selection.on.rowSelectionChanged($scope, function (row) {
                if (row.isSelected) {
                    $scope.estrategia = row.entity;
                } else {
                    //var index = $scope.registro.idsUsuariosArray.indexOf(row.entity.IdUser);
                    //if (index != -1) {
                    //    $scope.registro.idsUsuariosArray.splice(index, 1);
                    //}
                    $scope.estrategia = {};
                }
            });
        },
    };

    $scope.gridOptions4.multiSelect = false;
    $scope.gridOptions4.enableSelectAll = false;

    //*** autoajustar
    //$scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
    //    if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    //});
    $scope.$watchGroup(['gridOptions4.totalItems', 'gridOptions4.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions4.totalItems, $scope.gridOptions4.paginationCurrentPage, $scope.gridOptions4.paginationPageSize, 'grid4'); }
    });

    var columnActions = [];

    //// Personalizar rejilla y exportación
    var columnsNoVisibles =
    [
        "IdEstrategia"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "NombrePlan", newProperty: "Plan Mejoramiento" },
            { field: "FechaLimite", newProperty: "Fecha Límite" },
            { field: "NombreSeccion", newProperty: "Sección" },
        ]
    };

    var changeWidth = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "NombrePlan", newProperty: 200 },
            { field: "FechaLimite", newProperty: 70 },
            { field: "NombreSeccion", newProperty: 250 },
            { field: "Estrategia", newProperty: 350 }
        ]
    };

    var changeMinWidth = {
        action: "CambiarDefinicion",
        definition: "minWidth",
        parameters: [
            { field: "NombrePlan", newProperty: 200 },
            { field: "FechaLimite", newProperty: 70 },
            { field: "NombreSeccion", newProperty: 250 },
            { field: "Estrategia", newProperty: 350 }
        ]
    };

    var formatDate = {
        action: "CambiarFecha",
        parameters: [
            { field: "FechaLimite" },
        ]
    };

    $scope.gridOptions4.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion4 = function () {
        $scope.gridApi4.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/PlanesMejoramientoV3/TareasPlan/ListadoBusquedaEstrategias';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid4 = true;
            $scope.gridOptions4.data = datos;
            if (!$scope.isColumnDefs4) {
                UtilsService.getColumnDefs($scope.gridOptions4, $scope.isColumnDefs4, columnActions, columnsNoVisibles);
                $scope.isColumnDefs4 = true;
            } else {
                UtilsService.getColumnDefs($scope.gridOptions4, $scope.isColumnDefs4, columnActions, columnsNoVisibles);
            }

            UtilsService.utilsGridOptions($scope.gridOptions4, actionJson);
            UtilsService.utilsGridOptions($scope.gridOptions4, changeWidth);
            UtilsService.utilsGridOptions($scope.gridOptions4, changeMinWidth);
            UtilsService.utilsGridOptions($scope.gridOptions4, formatDate);

        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };



    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        $uibModalInstance.close($scope.estrategia);
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

}]);

app.controller('ModalBuscarTareasController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
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
        "IdTarea",
        "IdEstrategia",
        "Estrategia",
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
        ]
    };

    var changeWidth = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "Nombre", newProperty: 200 },
            { field: "Opcion", newProperty: 150 },
            { field: "Tarea", newProperty: 350 }
        ]
    };

    var changeMinWidth = {
        action: "CambiarDefinicion",
        definition: "minWidth",
        parameters: [
            { field: "Nombre", newProperty: 200 },
            { field: "Opcion", newProperty: 150 },
            { field: "Tarea", newProperty: 350 }
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
        var url = '/api/Sistema/PlanesMejoramientoV3/TareasPlan/ListadoBusquedaTareas?idPregunta=' + entity;
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
    $scope.url = '/api/Sistema/PlanesMejoramientoV3/ActivarPlan/';

    function getDatosActivacionPlan() {
        var url = '/api/Sistema/PlanesMejoramientoV3/DatosActivacionPlan?idPlan=' + entity.idPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            
            $scope.activacion.muestraPorc = false;
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

        var url = '/api/Sistema/PlanesMejoramientoV3/ValidarActivacionPlan?idPlan=' + $scope.activacion.idPlan;
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


//**SEGUIMIENTO PLAN DE MEJORAMIENTO -- NUEVO -- ANDRES BONILLA**//

//Modal configurar seguimiento plan
app.controller('ModalConfigurarSeguimientoPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModal', '$uibModalInstance', '$http', 'uiGridConstants', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModal, $uibModalInstance, $http, uiGridConstants, entity, UtilsService, authService) {
    $scope.plan = {};
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.plan.idPlan = entity.IdPlanMejoramiento;

    $scope.plan.AudUserName = authService.authentication.userName;
    $scope.plan.AddIdent = authService.authentication.isAddIdent;
    $scope.plan.UserNameAddIdent = authService.authentication.userNameAddIdent;

    $scope.cantDatos = 0;
    
    //Defs Grid
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid2 = false;
    $scope.isColumnDefs2 = false;
    $scope.cargoDatos = null;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];

    $scope.gridOptions2 = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            if (col.colDef.displayName === 'FechaInicio') value = (value != '' ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'FechaFin') value = (value != '' ? new Date(value).toLocaleDateString() : "");
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi2 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };

    ////*** autoajustar
    //$scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
    //    if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    //});

    //*** autoajustar
    $scope.$watchGroup(['gridOptions2.totalItems', 'gridOptions2.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions2.totalItems, $scope.gridOptions2.paginationCurrentPage, $scope.gridOptions2.paginationPageSize, 'grid2'); }
    });

    var columnActions = [
        {
            field: 'Eliminar',
            name: ' ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.openPopUpEliminarSeguimiento(row.entity)">Eliminar</a></div>',
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
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpEditarSeguimiento(row.entity)">Editar</a></div>',
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
        "IdPlanSeguimiento",
        "IdPlanMejoramiento",
        "NombrePlan",
        "IdEncuesta"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "MensajeSeguimiento", newProperty: "Mensaje Seguimiento" },
            { field: "NombrePlan", newProperty: "Plan de Mejoramiento" },
            { field: "NumeroSeguimiento", newProperty: "#" },
            { field: "FechaInicio", newProperty: "Desde" },
            { field: "FechaFin", newProperty: "Hasta" },
        ]
    };

    var checboxCell = {
        action: "CambiarDefinicion",
        definition: "cellTemplate",
        parameters: [
            { field: "Activo", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
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

    var formatDate = {
        action: "CambiarFecha",
        parameters: [
            { field: "FechaInicio" },
            { field: "FechaFin" },
        ]
    };

    var changeWidth = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "MensajeSeguimiento", newProperty: 280 },
            { field: "FechaInicio", newProperty: 80 },
            { field: "FechaFin", newProperty: 80 },
            { field: "Activo", newProperty: 80 },
            { field: "Encuesta", newProperty: 200 }
        ]
    };

    var changeMinWidth = {
        action: "CambiarDefinicion",
        definition: "minWidth",
        parameters: [
            { field: "MensajeSeguimiento", newProperty: 280 },
            { field: "FechaInicio", newProperty: 80 },
            { field: "FechaFin", newProperty: 80 },
            { field: "Activo", newProperty: 50 },
            { field: "Encuesta", newProperty: 200 }
        ]
    };

    $scope.gridOptions2.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion2 = function () {
        $scope.gridApi2.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/SeguimientoPlanMejoramiento/ListadoSeguimientos?idPlan=' + $scope.plan.idPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {

            $scope.cantDatos = datos.length;

            if (datos.length > 0) {
                $scope.cargoDatos = true;
                $scope.isGrid2 = true;
                $scope.gridOptions2.data = datos;

                if (!$scope.isColumnDefs2) {
                    UtilsService.getColumnDefs($scope.gridOptions2, $scope.isColumnDefs2, columnActions, columnsNoVisibles);
                    $scope.isColumnDefs2 = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions2, $scope.isColumnDefs2, columnActions, columnsNoVisibles);
                }

                UtilsService.utilsGridOptions($scope.gridOptions2, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions2, changeWidth);
                UtilsService.utilsGridOptions($scope.gridOptions2, changeMinWidth);
                UtilsService.utilsGridOptions($scope.gridOptions2, checboxCell);
                UtilsService.utilsGridOptions($scope.gridOptions2, filtersChange);
                UtilsService.utilsGridOptions($scope.gridOptions2, formatDate);
                UtilsService.autoajustarAltura($scope.gridOptions2.totalItems, $scope.gridOptions2.paginationCurrentPage, $scope.gridOptions2.paginationPageSize, 'grid2');

            } else {
                $scope.cargoDatos = true;
                $scope.isGrid2 = false;
            }
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    //Modal Eliminar Seguimiento
    $scope.openPopUpEliminarSeguimiento = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            backdrop: 'static', keyboard: false,
            resolve: {
                datos: function () {
                    if (entity) {

                        entity.idSeguimiento = entity.IdPlanSeguimiento;
                        entity.idPlan = entity.IdPlanMejoramiento;
                        entity.numeroSeguimiento = entity.NumeroSeguimiento;
                        entity.mensajeSeguimiento = entity.MensajeSeguimiento;
                        entity.fechaInicio = entity.FechaInicio;
                        entity.fechaFin = entity.FechaFin;
                        entity.activo = entity.Activo;


                        entity.AudUserName = authService.authentication.userName;
                        entity.AddIdent = authService.authentication.isAddIdent;
                        entity.UserNameAddIdent = authService.authentication.userNameAddIdent;

                        var url = '/api/Sistema/SeguimientoPlanMejoramiento/EliminarSeguimientoPlanMejoramiento/';
                        var msn = "¿Está seguro que quiere eliminar el seguimiento?";
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
                 var mensaje = 'Se ha eliminado correctamente el seguimiento.';
                 openRespuesta(mensaje);
             }
        );
    };


    //Modal editar seguimiento
    $scope.PopUpEditarSeguimiento = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarSeguimientoPlan.html',
            controller: 'ModalEditarSeguimientoPlanController',
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
                 var mensaje = 'Se han actualizado los datos del seguimiento';
                 openRespuesta(mensaje);
             }
        );
    };


    //Modal nuevo seguimiento
    $scope.PopUpNuevoSeguimiento = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarSeguimientoPlan.html',
            controller: 'ModalNuevoSeguimientoPlanController',
            size: 'md',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {

                        entity.cantDatos = $scope.cantDatos;

                        return angular.copy(entity);
                    } else {
                        entity = { idPlan: $scope.plan.idPlan, cantDatos: $scope.cantDatos };

                        return angular.copy(entity);
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
                 getDatos();
                 var mensaje = 'Se ha creado el nuevo seguimiento';
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
        $uibModalInstance.dismiss('cancel');
    };

    $scope.format = "dd/MM/yyyy";
}]);

//Modal nuevo seguimiento plan
app.controller('ModalNuevoSeguimientoPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.seguimiento = {};
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    
    $scope.url = '/api/Sistema/SeguimientoPlanMejoramiento/InsertarSeguimientoPlanMejoramiento/';

    $scope.seguimiento.idPlan = entity.idPlan;
    $scope.seguimiento.numeroSeguimiento = entity.cantDatos + 1;

    $scope.seguimiento.AudUserName = authService.authentication.userName;
    $scope.seguimiento.AddIdent = authService.authentication.isAddIdent;
    $scope.seguimiento.UserNameAddIdent = authService.authentication.userNameAddIdent;

    function cargarComboReportes() {
        var url = '/api/General/Listas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestasSeguimiento = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición del combo de encuestas";
        });
    }

    cargarComboReportes();

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {
        
        var servCall = APIService.saveSubscriber($scope.seguimiento, $scope.url);
        servCall.then(function (response) {
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
            if ($scope.seguimiento.fechaInicio > $scope.seguimiento.fechaFin) {
                $scope.seguimiento.fechaFin = $scope.seguimiento.fechaInicio;
                $scope.dateOptions2.minDate = $scope.seguimiento.fechaInicio;
            }
        }
    });


    //DataPicker
    $scope.popup2 = {
        opened: false
    };
    $scope.open2 = function () {
        $scope.dateOptions2.minDate = $scope.seguimiento.fechaInicio;
        $scope.popup2.opened = true;
    };
    $scope.dateOptions2 = {
        formatYear: 'yyyy',
        startingDay: 1
    };
}]);

//Modal editar seguimiento plan
app.controller('ModalEditarSeguimientoPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.seguimiento = {};
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();


    $scope.url = '/api/Sistema/SeguimientoPlanMejoramiento/ActualizarSeguimientoPlanMejoramiento/';

    $scope.seguimiento.idSeguimiento = entity.IdPlanSeguimiento;
    $scope.seguimiento.idPlan = entity.IdPlanMejoramiento;
    $scope.seguimiento.numeroSeguimiento = entity.NumeroSeguimiento;
    $scope.seguimiento.mensajeSeguimiento = entity.MensajeSeguimiento;
    $scope.seguimiento.fechaInicio = new Date(entity.FechaInicio);
    $scope.seguimiento.fechaFin = new Date(entity.FechaFin);
    $scope.seguimiento.activo = entity.Activo;
    $scope.seguimiento.idEncuesta = entity.IdEncuesta;

    $scope.seguimiento.AudUserName = authService.authentication.userName;
    $scope.seguimiento.AddIdent = authService.authentication.isAddIdent;
    $scope.seguimiento.UserNameAddIdent = authService.authentication.userNameAddIdent;

    function cargarComboReportes() {
        var url = '/api/General/Listas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestasSeguimiento = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición del combo de encuestas";
        });
    }

    cargarComboReportes();

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {

        $log.log($scope.seguimiento);

        var servCall = APIService.saveSubscriber($scope.seguimiento, $scope.url);
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
            if ($scope.seguimiento.fechaInicio > $scope.seguimiento.fechaFin) {
                $scope.seguimiento.fechaFin = $scope.seguimiento.fechaInicio;
                $scope.dateOptions2.minDate = $scope.seguimiento.fechaInicio;
            }
        }
    });


    //DataPicker
    $scope.popup2 = {
        opened: false
    };
    $scope.open2 = function () {
        $scope.dateOptions2.minDate = $scope.seguimiento.fechaInicio;
        $scope.popup2.opened = true;
    };
    $scope.dateOptions2 = {
        formatYear: 'yyyy',
        startingDay: 1
    };
}]);

//Modal estados acciones seguimiento plan
app.controller('ModalEstadosAccionesPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModal', '$uibModalInstance', '$http', 'uiGridConstants', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModal, $uibModalInstance, $http, uiGridConstants, entity, UtilsService, authService) {
    
    //Defs Grid
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid3 = false;
    $scope.isColumnDefs3 = false;
    $scope.cargoDatos = null;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];

    $scope.gridOptions3 = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi3 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };

    //*** autoajustar
    $scope.$watchGroup(['gridOptions3.totalItems', 'gridOptions3.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions3.totalItems, $scope.gridOptions3.paginationCurrentPage, $scope.gridOptions3.paginationPageSize, 'grid3'); }
    });

    var columnActions = [
        {
            field: 'Eliminar',
            name: ' ',
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.openPopUpEliminarEstado(row.entity)">Eliminar</a></div>',
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
            cellTemplate: '<div class="text-center" style="font-size:12px; margin-top:5px"><a href="" ng-click="grid.appScope.PopUpEditarEstado(row.entity)">Editar</a></div>',
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
        "IdEstadoAccion"
    ];

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "EstadoAccion", newProperty: "Estado" },
        ]
    };

    var checboxCell = {
        action: "CambiarDefinicion",
        definition: "cellTemplate",
        parameters: [
            { field: "Activo", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
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

    $scope.gridOptions3.exporterSuppressColumns = columnsNoVisibles;

    $scope.limpiarAgrupacion3 = function () {
        $scope.gridApi3.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Sistema/SeguimientoPlanMejoramiento/ListadoEstadosAcciones';
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            
            if (datos.length > 0) {
                $scope.cargoDatos = true;
                $scope.isGrid3 = true;
                $scope.gridOptions3.data = datos;

                if (!$scope.isColumnDefs3) {
                    UtilsService.getColumnDefs($scope.gridOptions3, $scope.isColumnDefs3, columnActions, columnsNoVisibles);
                    $scope.isColumnDefs3 = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions3, $scope.isColumnDefs3, columnActions, columnsNoVisibles);
                }

                UtilsService.utilsGridOptions($scope.gridOptions3, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions3, checboxCell);
                UtilsService.utilsGridOptions($scope.gridOptions3, filtersChange);
                UtilsService.autoajustarAltura($scope.gridOptions3.totalItems, $scope.gridOptions3.paginationCurrentPage, $scope.gridOptions3.paginationPageSize, 'grid3');

            } else {
                $scope.cargoDatos = true;
                $scope.isGrid3 = false;
            }
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    //Modal Eliminar Seguimiento
    $scope.openPopUpEliminarEstado = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            backdrop: 'static', keyboard: false,
            resolve: {
                datos: function () {
                    if (entity) {

                        entity.idEstadoAccion = entity.IdEstadoAccion;

                        entity.AudUserName = authService.authentication.userName;
                        entity.AddIdent = authService.authentication.isAddIdent;
                        entity.UserNameAddIdent = authService.authentication.userNameAddIdent;

                        var url = '/api/Sistema/SeguimientoPlanMejoramiento/EstadoAccion/EliminarEstadoAccion/';
                        var msn = "¿Está seguro que quiere eliminar el estado?";
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
                 var mensaje = 'Se ha eliminado correctamente el estado.';
                 openRespuesta(mensaje);
             }
        );
    };


    //Modal editar seguimiento
    $scope.PopUpEditarEstado = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarEstadoAccionPlan.html',
            controller: 'ModalEditarEstadosSeguimientoPlanController',
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
                 var mensaje = 'Se han actualizado los datos del estado';
                 openRespuesta(mensaje);
             }
        );
    };


    //Modal nuevo seguimiento
    $scope.PopUpNuevoEstado = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoEditarEstadoAccionPlan.html',
            controller: 'ModalNuevoEstadoSeguimientoPlanController',
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
                 var mensaje = 'Se ha creado el nuevo estado';
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
        $uibModalInstance.dismiss('cancel');
    };

    $scope.format = "dd/MM/yyyy";
}]);

app.controller('ModalNuevoEstadoSeguimientoPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.estado = {};
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();


    $scope.url = '/api/Sistema/SeguimientoPlanMejoramiento/EstadoAccion/InsertarEstadoAccion/';
    
    $scope.estado.AudUserName = authService.authentication.userName;
    $scope.estado.AddIdent = authService.authentication.isAddIdent;
    $scope.estado.UserNameAddIdent = authService.authentication.userNameAddIdent;


    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {

        $log.log($scope.estado);

        var servCall = APIService.saveSubscriber($scope.estado, $scope.url);
        servCall.then(function (response) {
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

app.controller('ModalEditarEstadosSeguimientoPlanController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.estado = {};
    $scope.isNew = $.isEmptyObject(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();


    $scope.url = '/api/Sistema/SeguimientoPlanMejoramiento/EstadoAccion/ActualizarEstadoAccion/';

    $scope.estado.idEstadoAccion = entity.IdEstadoAccion;
    $scope.estado.estadoAccion = entity.EstadoAccion;
    $scope.estado.activo = entity.Activo;

    $scope.estado.AudUserName = authService.authentication.userName;
    $scope.estado.AddIdent = authService.authentication.isAddIdent;
    $scope.estado.UserNameAddIdent = authService.authentication.userNameAddIdent;


    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {

        $log.log($scope.estado);

        var servCall = APIService.saveSubscriber($scope.estado, $scope.url);
        servCall.then(function (response) {
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