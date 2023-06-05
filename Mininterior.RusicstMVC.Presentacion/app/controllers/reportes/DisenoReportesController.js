app.controller('DisenoReportesController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService) {

    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.cargoDatos = null;
    $scope.datos = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Validacion-') {
                value = value.replace(/”/g, "");
                value = value.replace(/“/g, "");
                value = value.replace(/–/g, "-");
            }
            return value;
        },
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Fecha Inicio' || col.colDef.displayName === 'Fecha Fin') value = new Date(value).toLocaleDateString();
            return value;
        },
        exporterSuppressColumns: ['Id'],
        exporterPdfFilename: 'Listado de Encuestas',
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom($scope.gridApi1);
        },
    };

    $scope.isColumnDefs = false;
    $scope.columnDefsFijas = [];

    $scope.datePicker = {
        options: {
            formatMonth: 'MM',
            startingDay: 1
        },
        format: "dd/MM/yyyy"
    };
    var formatDate = {
        action: "CambiarFecha",
        parameters: [
            { field: "FechaInicio" },
            { field: "FechaFin" },
        ]
    };
    $scope.showDatePopup = [];
    $scope.showDatePopup.push({ opened: false });

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "Titulo", newProperty: "Título" },
            { field: "FechaInicio", newProperty: "Fecha Inicio" },
            { field: "FechaFin", newProperty: "Fecha Finalización" }
        ]
    };

    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid'); }
    });

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    $scope.toggleFiltering = function () {
        $scope.gridOptions.enableFiltering = !$scope.gridOptions.enableFiltering;
        $scope.gridApi.core.notifyDataChange(uiGridConstants.dataChange.COLUMN);
    };

    $scope.openPopUpNuevoReporte = function (reporte) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/reportes/modals/NuevoReporte.html',
            controller: 'ModalNuevoReporteController',
            resolve: {
                reporte: function () {
                    if (reporte) {
                        return reporte.Id;
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
                buscar();
                var mensaje;
                if (resultado.estado === 1) mensaje = "La encuesta fue creada satisfactoriamente";
                if (resultado.estado === 2) mensaje = "La encuesta fue actualizada satisfactoriamente";
                openRespuesta(mensaje);
            }
           );
    };

    $scope.openPopUpSeccionesReporte = function (idReporte) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/reportes/modals/SeccionesReporte.html',
            controller: 'ModalSeccionesReporteController',
            size: 'lg',
            resolve: {
                idReporte: function () {
                    if (idReporte) {
                        return idReporte
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
                buscar();
            }
        );
    };

    $scope.openPopUpEliminarReporte = function (reporte) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            resolve: {
                datos: function () {
                    if (reporte.Id) {

                        reporte.AudUserName = authService.authentication.userName;
                        reporte.AddIdent = authService.authentication.isAddIdent;
                        reporte.UserNameAddIdent = authService.authentication.userNameAddIdent;

                        var enviar = { url: '/api/Reportes/DisenoReporte/Eliminar/', msn: "¿Está seguro de realizar la eliminación del reporte?", entity: reporte };
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
                 buscar();
             }
           );
    };

    function agregarColumnasFijas() {
        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 100,
            field: 'Modificar',
            name: '#',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.openPopUpNuevoReporte(row.entity)">Modificar</a></div>', enableFiltering: false,
            pinnedLeft: true,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 100,
            field: 'Secciones',
            name: 'Secciones',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.openPopUpSeccionesReporte(row.entity.Id)">Secciones</a></div>',
            enableFiltering: false,
            pinnedRight: true,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
        var columnDefsJsonFijas = {
            minWidth: 100,
            width: 100,
            field: 'Eliminar',
            name: ' ',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.openPopUpEliminarReporte(row.entity)">Eliminar</a></div>',
            enableFiltering: false,
            pinnedRight: true,
            exporterSuppressExport: true,
        };
        $scope.columnDefsFijas.push(columnDefsJsonFijas);
    }

    function buscar() {
        var url = '/api/Reportes/DisenoReporte/';
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatos = true;
                $scope.isGrid = true;
                $scope.gridOptions.data = datos;
                agregarColumnasFijas();
                var columsNoVisibles = [];
                if (!$scope.isColumnDefs) {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                    $scope.isColumnDefs = true;
                } else {
                    UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, $scope.columnDefsFijas, columsNoVisibles);
                }
                UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
            }, function (error) {
                $scope.cargoDatos = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
    };

    buscar();

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

    // Fin logica del popup de los filtro que no se desarrollara por el momento
}]);

app.controller('ModalNuevoReporteController', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, reporte, $timeout, authService) {
    $scope.reporte = { AutoevaluacionHabilitada: false, TipoEncuesta: 'TIPO_ANTIGUO', EncuestaRelacionada: 0 };
    $scope.Idreporte = 0 || reporte;
    cargarComboEncuesta();
    $scope.EncuestaRelacionada = 0;
    $scope.tiposReporteSeleccionados = {};
    $scope.tiposReporte = {};

    function cargarComboTiposReporteMod() {
        var url = '/api/Reportes/DisenoReporte/RolxEncuesta/' + $scope.Idreporte;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            if (response.length > 0 )
                $scope.tiposReporteSeleccionados = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de los tipos de encuesta Modificación";
        });
    }

    function cargarComboTiposReporte() {
        var url = '/api/General/Listas/Roles?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.tiposReporte = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de los tipos de encuesta";
        });
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

    function cargarDatosModificar() {
        var url = '/api/Reportes/DisenoReporte/' + $scope.Idreporte;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.reporte = response;
            if ($scope.reporte.IsPrueba == 1)
                $scope.reporte.IsPrueba = true;
            else
                $scope.reporte.IsPrueba = false;
            if ($scope.tiposReporteSeleccionados.length > 0)
                $scope.reporte.TipoReporte = $scope.tiposReporteSeleccionados;
            else
                $scope.reporte.TipoReporte = $scope.tiposReporte;
            $scope.reporte.FechaInicio = new Date($scope.reporte.FechaInicio);
            $scope.reporte.FechaFin = new Date($scope.reporte.FechaFin);
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de datos del reporte indicado";
        });
    }

    function guardarDatos() {
        var url = '/api/Reportes/DisenoReporte/Insertar/';
        if ($scope.reporte.Id) {
            url = '/api/Reportes/DisenoReporte/Modificar/';
        }
        $scope.reporte.IsDeleted = false;
        if ($scope.reporte.IsPrueba)
            $scope.reporte.IsPrueba = 1;
        else
            $scope.reporte.IsPrueba = 0;

        $scope.reporte.AudUserName = authService.authentication.userName;
        $scope.reporte.AddIdent = authService.authentication.isAddIdent;
        $scope.reporte.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.reporte, url);
        servCall.then(function (response) {
            var resultado = {};
            resultado.estado = response.data.estado
            switch (response.data.estado) {
                case 0:
                    $scope.error = response.data.respuesta;
                    if ($scope.reporte.IsPrueba == 1)
                        $scope.reporte.IsPrueba = true;
                    else
                        $scope.reporte.IsPrueba = false;
                    break;
                case 1:
                    $uibModalInstance.close(resultado);
                    break;
                case 2:
                    $uibModalInstance.close(resultado);
                    break;
            }
            $scope.tiposReporteSeleccionados = {};
            $scope.tiposReporte = {};
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
            //document.location.reload();
        });
    }

    if ($scope.Idreporte > 0) {
        cargarComboTiposReporteMod();
        cargarComboTiposReporte();
        cargarDatosModificar();
    }
    else {
        cargarComboTiposReporte();
    }

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    $scope.validar = function () {
        $scope.checkErr($scope.reporte.FechaInicio, $scope.reporte.FechaFin);
        return $scope.myFormReporte.$valid;
    };

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
    $scope.dateOptions = {
        formatYear: 'yyyy',
        startingDay: 1
    };

    $scope.checkErr = function (fechainicio, fechafin) {

        $scope.error = '';
        var curDate = new Date();

        if (new Date(fechainicio) > new Date(fechafin)) {
            $scope.error = 'La fecha de finalización debe ser mayor o igual a la de inicio';
            $scope.myFormReporte.$valid = false;
            return false;
        }
    };

    $scope.format = "dd/MM/yyyy";
});

app.controller('ModalSeccionesReporteController', ['$scope', 'APIService', 'UtilsService', 'Upload', 'ngSettings', 'i18nService', '$uibModalInstance', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$uibModal', 'idReporte', 'authService', '$anchorScroll', '$location',
    function ($scope, APIService, UtilsService, Upload, ngSettings, i18nService, $uibModalInstance, $http, uiGridConstants, $interval, uiGridGroupingConstants, $uibModal, idReporte, authService, $anchorScroll, $location) {
        $scope.url = '/api/Reportes/DisenoReporte/InsertarSeccion/';
        $scope.isGrid2 = false;
        $scope.Secciones = {};
        $scope.Seccion = {};
        $scope.SubSeccion = {};
        $scope.lang = "es";
        $scope.errorMessages = UtilsService.getErrorMessages();

        //-----UPLOAD FILE---------------------------------------------
        // upload on file select or drop
        $scope.upload = function (file, url) {

            $scope.Seccion.AudUserName = authService.authentication.userName;
            $scope.Seccion.AddIdent = authService.authentication.isAddIdent;
            $scope.Seccion.UserNameAddIdent = authService.authentication.userNameAddIdent;

            $scope.deshabiltarSeccion = true;
            var serviceBase = ngSettings.apiServiceBaseUri;
            if (file != null) {
                var filename = file.name;
                var index = filename.lastIndexOf(".");
                var strsubstring = filename.substring(index, filename.length);
                if (!(strsubstring == '.xlsx' || strsubstring == '.xls')) {
                    $scope.extension = true;
                    $scope.deshabiltarSeccion = false;
                    return;
                }
            }
            $scope.extension = false;
            $scope.deshabiltarSeccion = true;
            Upload.upload({
                url: serviceBase + url,
                method: "POST",
                data: $scope.Seccion,
                file: file,
            }).then(function (Resultado) {
                $scope.deshabiltarSeccion = false;
                $scope.extension = false;
                switch (Resultado.data.EstadoResultado) {
                    case 0:
                        var mensaje = { msn: Resultado.data.respuesta, tipo: "alert alert-warning" };
                        openRespuesta(mensaje);
                        break;
                    case 1:
                        var mensaje = { msn: "El proceso fue creado satisfactoriamente", tipo: "alert alert-success" };
                        openRespuesta(mensaje);
                        break;
                    case 2:
                        var mensaje = { msn: "El proceso fue actualizado satisfactoriamente", tipo: "alert alert-success" };
                        openRespuesta(mensaje);
                        break;
                }
                buscarSeccion(idReporte);
            }, function (Resultado) {
                $scope.deshabiltarSeccion = false;
                var mensaje = { msn: 'Error: ' + resultado.data.exceptionMessage, tipo: "alert alert-danger" };
                alert(mensaje);
            }, function (evt) {
                var $panel = angular.element($("#PanelCM")).scope();
                $panel.mostrarSeccionNueva = 0;
            });
        };

        $scope.gridOptions2 = {
            columnDefs: [],
            exporterFieldCallback: function (grid, row, col, value) {
                if (col.colDef.displayName === 'Validacion-') {
                    value = value.replace(/”/g, "");
                    value = value.replace(/“/g, "");
                    value = value.replace(/–/g, "-");
                }
                return value;
            },
            exporterSuppressColumns: ['Id'],
            exporterPdfFilename: 'Listado de Encuestas',
            onRegisterApi: function (gridApi) {
                $scope.gridApi2 = gridApi;
                gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom($scope.gridApi2);
            },
        };
        $scope.isColumnDefs2 = false;
        $scope.columnDefsFijas2 = [];
        $scope.SubSeccion = {};

        function cargarComboSeccion(id) {
            var url = '/api/Reportes/DisenoReporte/ObtenerSubSecciones/' + id;
            var servCall = APIService.getSubs(url);
            servCall.then(function (response) {
                $scope.SubSeccion = response;
            }, function (error) {
                $scope.error = "Se generó un error en la petición de cargue de las Secciones";
            });
        }

        function agregarColumnasFijasSeccion() {
            var columnDefsJsonFijas = {
                minWidth: 100,
                width: 100,
                field: 'Modificar',
                name: '#',
                cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.openNuevoEditarSeccion(row.entity)">Modificar</a></div>', enableFiltering: false,
                pinnedLeft: true,
                exporterSuppressExport: true,
            };
            $scope.columnDefsFijas2.push(columnDefsJsonFijas);
            var columnDefsJsonFijas = {
                minWidth: 100,
                width: 100,
                field: 'Descargar',
                name: 'Descargar',
                cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.descargaExcelSeccion(row.entity)">Descargar</a></div>',
                enableFiltering: false,
                pinnedRight: true,
                exporterSuppressExport: true,
            };
            $scope.columnDefsFijas2.push(columnDefsJsonFijas);
            var columnDefsJsonFijas = {
                minWidth: 100,
                width: 100,
                field: 'Eliminar',
                name: ' ',
                cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.openPopUpEliminarSeccion(row.entity)">Eliminar</a></div>',
                enableFiltering: false,
                pinnedRight: true,
                exporterSuppressExport: true,
            };
            $scope.columnDefsFijas2.push(columnDefsJsonFijas);
            var columnDefsJsonFijas = {
                minWidth: 0,
                width: 0,
                field: 'Preguntas',
                name: 'Preguntas',
                enableFiltering: false,
                pinnedRight: false,
                exporterSuppressExport: false,
            };
            $scope.columnDefsFijas2.push(columnDefsJsonFijas);
        }

        function buscarSeccion(id) {
            var url = '/api/Reportes/DisenoReporte/ObtenerSecciones/' + id;
            getDatosSeccion();
            function getDatosSeccion() {
                var servCall = APIService.getSubs(url);
                servCall.then(function (datos) {
                    if (datos.length > 0) {
                        $scope.Secciones = datos;
                        $scope.Seccion = datos[0];
                        $scope.cargoDatos = true;
                        $scope.isGrid2 = true;
                        $scope.gridOptions2.data = datos;
                        agregarColumnasFijasSeccion();
                        var columsNoVisibles = ["Id", "IdUsuario" , "IdEncuesta", "Ayuda", "SuperSeccion", "IsDeleted", "Archivo", "OcultaTitulo", "Estilos", "Disenos", "Preguntas", "AudUserName", "AddIdent", "UserNameAddIdent", "Excepcion", "ExcepcionMensaje"];
                        
                        if (!$scope.isColumnDefs2) {
                            UtilsService.getColumnDefs($scope.gridOptions2, $scope.isColumnDefs2, $scope.columnDefsFijas2, columsNoVisibles);
                            $scope.isColumnDefs2 = true;
                        } else {
                            UtilsService.getColumnDefs($scope.gridOptions2, $scope.isColumnDefs2, $scope.columnDefsFijas2, columsNoVisibles);
                        }
                        UtilsService.utilsGridOptions($scope.gridOptions2, actionJsonSeccion);
                        UtilsService.utilsGridOptions($scope.gridOptions2, actionJsonSeccion1);
                    }
                }, function (error) {
                    $scope.error = "Se generó un error en la petición";
                });
            }
        };

        function guardarDatosSeccion() {
            $scope.url = '/api/Reportes/DisenoReporte/ModificarSeccion';
            $scope.upload($scope.file, $scope.url);
            if ($scope.Seccion.SuperSeccion == null)
                $scope.Seccion.SuperSeccion = 0;
            $scope.Seccion.IsDeleted = false;
            $scope.Seccion.IdEncuesta = idReporte;
            $scope.Seccion.IdUsuario = 0;
        }

        $scope.redirectToAyudaEstilo = function () {
            window.open('app/views/reportes/AyudaEstilos.html');
        };

        $scope.descargaExcelSeccion = function (entity) {
            var url = '/api/Reportes/DisenoReporte/DescargarExcelSeccion/' + entity.Id;
            getExcelSeccion();
            function getExcelSeccion() {
                var servCall = APIService.getArray(url);
                servCall.then(function (data) {
                    var blob = new Blob([data], { type: "application/vnd.ms-excel" });
                    var blobURL = (window.URL || window.webkitURL).createObjectURL(blob);
                    var anchor = document.createElement("a");
                    anchor.download = "seccion-" + entity.Id;
                    anchor.href = blobURL;
                    anchor.click();
                }, function (error) {
                    var mensaje = { msn: "No tiene Archivo Excel asociado", tipo: "alert alert-warning" };
                    openRespuesta(mensaje);
                });
            }
        }

        $scope.openNuevoEditarSeccion = function (entity) {
            $scope.Seccion = entity;
            $scope.SuperSeccion = entity.SuperSeccion;
            var $panel = angular.element($("#PanelCM")).scope();
            $panel.mostrarSeccionNueva = 1;
            $anchorScroll('PanelFull');
        };

        buscarSeccion(idReporte);

        cargarComboSeccion(idReporte);

        var actionJsonSeccion = {
            action: "CambiarDefinicion",
            definition: "displayName",
            parameters: [
                { field: "TituloSS", newProperty: "Etapa" },
                { field: "Titulo", newProperty: "Título" },
                { field: "Ayuda", newProperty: "Ayuda" }
            ]
        };

        var actionJsonSeccion1 = {
            action: "CambiarDefinicion",
            definition: "exporterSuppressExport",
            parameters: [
                { field: "IdUsuario", newProperty: true },
                { field: "IdEncuesta", newProperty: true },
                { field: "Disenos", newProperty: true },
                { field: "Preguntas", newProperty: true },
                { field: "Ayuda", newProperty: true },
                { field: "SuperSeccion", newProperty: true },
                { field: "IsDeleted", newProperty: true },
                { field: "Archivo", newProperty: true },
                { field: "OcultaTitulo", newProperty: true },
                { field: "Estilos", newProperty: true },
            ]
        };

        //*** autoajustar
        $scope.$watchGroup(['gridOptions2.totalItems', 'gridOptions2.paginationCurrentPage'], function (newValue, oldValue) {
            if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions2.totalItems, $scope.gridOptions2.paginationCurrentPage, $scope.gridOptions2.paginationPageSize, 'grid2'); }
        });

        $scope.limpiarAgrupacion = function () {
            $scope.gridApi2.grouping.clearGrouping();
        };

        $scope.toggleFiltering = function () {
            $scope.gridOptions2.enableFiltering = !$scope.gridOptions2.enableFiltering;
            $scope.gridApi2.core.notifyDataChange(uiGridConstants.dataChange.COLUMN);
        };

        $scope.cancelar = function () {
            $uibModalInstance.dismiss('cancel');
        };

        $scope.nuevaSeccion = function () {
            $scope.Seccion = {};
        };

        $scope.aceptar = function () {
            $scope.errors = [];
            if (!$scope.validar()) return false;
            guardarDatosSeccion();
        };

        $scope.validar = function () {
            return $scope.myFormReporte.$valid;
        };

        //Confirmación
        var openRespuesta = function (mensaje) {
            var modalInstance = $uibModal.open({

                templateUrl: 'app/views/modals/Respuesta.html',
                controller: 'ModalRespuestaController',
                resolve: {
                    datos: function () {
                        $scope.deshabiltarSeccion = false;
                        var enviar = mensaje
                        cargarComboSeccion(idReporte);
                        return enviar;
                    }
                },
                backdrop: 'static', keyboard: false
            });
            modalInstance.result.then(
                function () {
                    buscarSeccion(idReporte);
                    $scope.file = null;
                });
        };

        $scope.openPopUpEliminarSeccion = function (seccion) {

            seccion.AudUserName = authService.authentication.userName;
            seccion.AddIdent = authService.authentication.isAddIdent;
            seccion.UserNameAddIdent = authService.authentication.userNameAddIdent;

            var enviar = { url: '/api/Reportes/DisenoReporte/EliminarSeccion/', msn: "¿Está seguro de realizar la eliminación?", entity:seccion };
            var templateUrl = 'app/views/modals/ConfirmacionEliminar.html';
            var controller = 'ModalEliminarController';
            var cont = 0;
            angular.forEach($scope.Secciones, function (seccio, key) {
                if (seccio.SuperSeccion == seccion.Id) {
                    enviar = { url: '', msn: "No se puede eliminar la Etapa" };
                    templateUrl = 'app/views/modals/Respuesta.html';
                    controller = 'ModalRespuestaController';
                    cont++;
                }
            });
            var modalInstance = $uibModal.open({
                templateUrl: templateUrl,
                controller: controller,
                resolve: {
                    datos: function () {
                        return enviar;
                    }
                },
                backdrop: 'static', keyboard: false
            });
            modalInstance.result.then(
                function () {
                    buscarSeccion(idReporte);
                    cargarComboSeccion(idReporte);
                }
            );
        };
    }]);