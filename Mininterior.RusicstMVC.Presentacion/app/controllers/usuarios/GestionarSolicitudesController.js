app.controller('GestionarSolicitudesController', ['$scope', 'APIService', 'UtilsService', 'authService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', '$dsb', 'authService', function ($scope, APIService, UtilsService, authService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, $dsb, authService) {

    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.isGrid2 = false;
    $scope.cargoDatos = null;
    $scope.colPdf = [
        { columna: 'E-Mail', col: null },
        { columna: 'Fecha', col: null }
    ]
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            angular.forEach($scope.colPdf, function (fila) {
                if (col.colDef.displayName === fila.columna) fila.col = col;
            });
            if (col.colDef.displayName === 'Fecha') value = (value != '' ? new Date(value).toLocaleDateString() : "");
            return value;
        },
        onRegisterApi: function (gridApi1) {
            $scope.gridApi1 = gridApi1;
            gridApi1.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom($scope.gridApi1);
            gridApi1.grid.options.exporterPdfTableHeaderStyle = { fontSize: 7, bold: true, color: 'white', fillColor: '#63002D', alignment: 'center' };
            gridApi1.grid.options.exporterPdfDefaultStyle = { fontSize: 6 };
            gridApi1.grid.options.exporterPdfCustomFormatter = function (docDefinition) {
                var datosPDF = docDefinition.content[0].table.body;
                UtilsService.personalizarExportPDF(datosPDF, $scope.colPdf)
                docDefinition.styles.headerStyle = { fontSize: 10, bold: true, alignment: 'center', color: '#63002D' };
                docDefinition.styles.footerStyle = { fontSize: 8, bold: true, alignment: 'center', color: '#333333' };
                //docDefinition.content[0].table.widths = [50, 50, 50, 50, 50, 100, 50, 50, '*', '*'];
                //docDefinition.pageMargins = [10, 50, 10, 50];
                return docDefinition;
            }
        },
    };
    $scope.colPdf2 = [
        { columna: 'E-Mail', col: null },
        { columna: 'Tipo Usuario', col: null },
        { columna: 'Celular', col: null },
        { columna: 'Fecha', col: null }
    ]
    $scope.gridOptions2 = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            angular.forEach($scope.colPdf2, function (fila) {
                if (col.colDef.displayName === fila.columna) fila.col = col;
            });
            if (col.colDef.displayName === 'Fecha') value = (value != '' ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Fecha No Repudio') value = (value != '' ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Fecha Trámite') value = (value != '' ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Fecha Confirma') value = (value != '' ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            return value;
        },
        onRegisterApi: function (gridApi2) {
            $scope.gridApi2 = gridApi2;
            gridApi2.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom($scope.gridApi2);
            gridApi2.grid.options.exporterPdfTableHeaderStyle = { fontSize: 7, bold: true, color: 'white', fillColor: '#63002D', alignment: 'center' };
            gridApi2.grid.options.exporterPdfDefaultStyle = { fontSize: 6 };
            gridApi2.grid.options.exporterPdfCustomFormatter = function (docDefinition) {
                var datosPDF = docDefinition.content[0].table.body;
                UtilsService.personalizarExportPDF(datosPDF, $scope.colPdf2)
                docDefinition.styles.headerStyle = { fontSize: 10, bold: true, alignment: 'center', color: '#63002D' };
                docDefinition.styles.footerStyle = { fontSize: 8, bold: true, alignment: 'center', color: '#333333' };
                //docDefinition.content[0].table.widths = [40, 30, 30, 30, 30, 30, 30, 30, 30, '*'];
                docDefinition.pageMargins = [10, 50, 10, 50];
                return docDefinition;
            }
        }
    };

    //*** autoajustar
    //$scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
    //    if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    //});
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid1'); }
    });
    //$scope.$watchGroup(['gridOptions2.totalItems', 'gridOptions2.paginationCurrentPage'], function (newValue, oldValue) {
    //    if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions2.totalItems, $scope.gridOptions2.paginationCurrentPage, $scope.gridOptions2.paginationPageSize); }
    //});
    $scope.$watchGroup(['gridOptions2.totalItems', 'gridOptions2.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions2.totalItems, $scope.gridOptions2.paginationCurrentPage, $scope.gridOptions2.paginationPageSize, 'grid2'); }
    });

    $scope.isColumnDefs = false;
    $scope.isColumnDefs2 = false;

    var columnActions = [
    {
        name: '#',
        cellTemplate: '<div class="text-center" style="padding-top:5px;"><a href="" ng-click="grid.appScope.openVerDetalles(row.entity)"><i class="fa fa-plus-square-o"></i></a> <a href=""  ng-click="grid.appScope.abrirRemitir(row.entity)">Remitir</a></div>',
        enableFiltering: false,
        pinnedLeft: true,
        width: 80,
        enableColumnMenu: false,
        exporterSuppressExport: true,
    }];

    var columnActions2 = [
    {
        name: '#',
        cellTemplate: '<div class="text-center" style="padding-top:5px;"><a href="" ng-click="grid.appScope.openVerDetalles2(row.entity)"><i class="fa fa-plus-square-o"></i></a></div>',
        enableFiltering: false,
        pinnedLeft: true,
        width: 80,
        enableColumnMenu: false,
        exporterSuppressExport: true,
    }];

    var columnsNoVisibles = [
        "UserName",
        "TipoUsuario",
        "TelefonoFijoIndicativo",
        "TelefonoFijoExtension",
        "EmailAlternativo",
        "IdDepartamento",
        "IdMunicipio",
        "FechaNoRepudio",
        "UsuarioTramite",
        "FechaTramite",
        "FechaConfirmacion",
        "Token",
        "Estado",
        "IdSolicitudUsuario",
        "Id",
        "IdUser",
        "IdTipoUsuario",
        "IdEstado",
        "IdUsuarioTramite",
        "Enviado",
        "DatosActualizados",
        "Activo"
    ]

    var columnsNoVisibles2 = [
        "EmailAlternativo",
        "Id",
        "TelefonoFijoIndicativo",
        "TelefonoFijoExtension",
        "Cargo"
    ]

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "TelefonoFijo", newProperty: "Teléfono Fijo" },
            { field: "FechaSolicitud", newProperty: "Fecha" },
            { field: "TelefonoCelular", newProperty: "Celular" },
            { field: "DocumentoSolicitud", newProperty: "Documento" },
            { field: "Email", newProperty: "E-Mail" },

            { field: "TipoUsuario", newProperty: "Tipo Usuario" },
            { field: "UsuarioTramite", newProperty: "Tramitó" },
            { field: "FechaNoRepudio", newProperty: "Fecha No Repudio" },
            { field: "FechaTramite", newProperty: "Fecha Trámite" },
            { field: "FechaConfirmacion", newProperty: "Fecha Confirma" },
            { field: "NombresYUsername", newProperty: "Nombres y Usuario" }
        ]
    };

    var actionJsonExportar = [
        "UserName",
        "TipoUsuario",
        "TelefonoFijoIndicativo",
        "TelefonoFijoExtension",
        "EmailAlternativo",
        "IdDepartamento",
        "IdMunicipio",
        "FechaNoRepudio",
        "UsuarioTramite",
        "FechaTramite",
        "FechaConfirmacion",
        "Token",
        "Estado",
        "IdSolicitudUsuario",
        "Id",
        "IdUser",
        "IdTipoUsuario",
        "IdEstado",
        "IdUsuarioTramite",
        "Enviado",
        "DatosActualizados",
        "Activo",
        "DocumentoSolicitud"
    ]

    var actionJsonExportar2 = [
        "EmailAlternativo",
        "Id",
        "TelefonoFijoIndicativo",
        "TelefonoFijoExtension",
        "Cargo",
        "DocumentoSolicitud"
    ]

    var changeWidth = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "Nombres", newProperty: 95 },
            { field: "FechaSolicitud", newProperty: 75 },
            { field: "E-Mail", newProperty: 100 },
            { field: "Telefono Fijo", newProperty: 95 },
            { field: "Tipo Usuario", newProperty: 100 },
            { field: "Celular", newProperty: 95 },
            //{ field: "DocumentoSolicitud", newProperty: 135 },
            { field: "Municipio", newProperty: 95 },
            { field: "Departamento", newProperty: 100 },

            //{ field: "Cargo", newProperty: 135 },
            { field: "UsuarioTramite", newProperty: 100 },
            { field: "Fecha No Repudio", newProperty: 50 },
            { field: "Fecha Trámite", newProperty: 80 },
            { field: "Fecha Confirma", newProperty: 80 },
            { field: "Activo", newProperty: 50 }
        ]
    };

    var changeMinWidth = {
        action: "CambiarDefinicion",
        definition: "minWidth",
        parameters: [
            { field: "Nombres", newProperty: 95 },
            { field: "FechaSolicitud", newProperty: 75 },
            { field: "E-Mail", newProperty: 100 },
            { field: "Telefono Fijo", newProperty: 95 },
            { field: "Tipo Usuario", newProperty: 100 },
            { field: "Celular", newProperty: 95 },
            //{ field: "DocumentoSolicitud", newProperty: 135 },
            { field: "Municipio", newProperty: 95 },
            { field: "Departamento", newProperty: 100 },

            //{ field: "Cargo", newProperty: 135 },
            { field: "UsuarioTramite", newProperty: 100 },
            { field: "Fecha No Repudio", newProperty: 50 },
            { field: "Fecha Trámite", newProperty: 80 },
            { field: "Fecha Confirma", newProperty: 80 },
            { field: "Activo", newProperty: 50 }
        ]
    };

    var documentoSolicitudCelda = {
        action: "CambiarDefinicion",
        definition: "cellTemplate",
        parameters: [
            { field: "DocumentoSolicitud", newProperty: '<div style="padding-top:5px; padding-left:2px; text-align: center"><a style="padding-top:5px" href="" ng-click="grid.appScope.descargar(row.entity)">Ver</a></div>' },
        ]
    };

    var formatDate = {
        action: "CambiarFecha",
        parameters: [
            { field: "FechaSolicitud" },
            { field: "FechaNoRepudio" },
            { field: "FechaTramite" },
            { field: "FechaConfirmacion" },
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
    ]
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

    $scope.limpiarAgrupacion2 = function () {
        $scope.gridApi2.grouping.clearGrouping();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Usuarios/GestionarSolicitudes?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            if (datos.length > 0) {
                $scope.isGrid = true;
                $scope.gridOptions.data = datos;
                $log.log(datos);
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
                UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions, changeWidth);
                UtilsService.utilsGridOptions($scope.gridOptions, changeMinWidth);
                UtilsService.utilsGridOptions($scope.gridOptions, documentoSolicitudCelda);
                UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
                $scope.gridOptions.exporterSuppressColumns = actionJsonExportar;
            } else {
                $scope.isGrid = false;
                $scope.isColumnDefs = false;
                $scope.cargoDatos = true;
                $scope.alerta = "No se encontraron solicitudes pendientes";
            }
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    getDatos2();
    function getDatos2() {
        var url = '/api/Usuarios/GestionarSolicitudes/Historico?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos2) {
            $scope.cargoDatos = true;
            if (datos2.length > 0) {
                $scope.gridOptions2.data = datos2;
                $log.log(datos2);
                UtilsService.getColumnDefs($scope.gridOptions2, $scope.isColumnDefs2, columnActions2, columnsNoVisibles2);
                UtilsService.utilsGridOptions($scope.gridOptions2, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions2, changeWidth);
                UtilsService.utilsGridOptions($scope.gridOptions2, changeMinWidth);
                UtilsService.utilsGridOptions($scope.gridOptions2, documentoSolicitudCelda);
                UtilsService.utilsGridOptions($scope.gridOptions2, formatDate);
                UtilsService.utilsGridOptions($scope.gridOptions2, checboxCell);
                UtilsService.utilsGridOptions($scope.gridOptions2, filtersChange);
                $scope.gridOptions2.exporterSuppressColumns = actionJsonExportar2;
                $scope.isGrid2 = true;
            } else {
                $scope.isGrid2 = false;
                $scope.isColumnDefs2 = false;
                $scope.cargoDatos = true;
                $scope.alerta2 = "No se encontraron datos";
            }
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error2 = "Se generó un error en la petición";
        });
    };

    $scope.descargar = function (entity) {
        var url = '/api/Usuarios/GestionarSolicitudes/Download?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent + '&archivo=' + entity.DocumentoSolicitud + '&nombreArchivo=' + entity.DocumentoSolicitud;
        APIService.open(url);
    }

    //--------------------Acciones de la Grilla-----------------------------------------
    $scope.abrirRemitir = function (entity) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/Remitir.html',
            controller: 'ModalRemitirController',
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
             function (mensaje) {
                 $scope.isColumnDefs = true;
                 $scope.isColumnDefs2 = true;
                 getDatos();
                 getDatos2();
                 if (mensaje !== false)
                     openRespuesta(mensaje);
             }
           );
    };

    $scope.openVerDetalles = function (entity) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/VerDetalles.html',
            controller: 'ModalVerDetallesController',
            backdrop: 'static', keyboard: false,
            size: 'lg',
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
    };

    $scope.openVerDetalles2 = function (entity) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/VerDetalles.html',
            controller: 'ModalVerHistoricoController',
            backdrop: 'static', keyboard: false,
            size: 'lg',
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
    };

    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    $scope.deshabiltarRegistrese = false;
                    var enviar = mensaje;
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {

            });
    };

    //=============Cambiar Tabs===============================
    $scope.tab = 0;
    $scope.cambiarTab = function (tab) {
        $scope.tab = tab;
    }

    //============ Doble Scroll ===============================
    //debugger;
    //$(".scroll-bar-arriba").scroll(function () {
    //    debugger
    //    $(".scroll-bar-abajo")
    //        .scrollLeft($(".scroll-bar-arriba").scrollLeft());
    //});
    //$(".scroll-bar-abajo").scroll(function () {
    //    $(".scroll-bar-arriba")
    //        .scrollLeft($(".scroll-bar-abajo").scrollLeft());
    //});

}]);

app.controller('ModalRemitirController', ['$scope', 'APIService', 'UtilsService', 'Upload', '$log', '$uibModalInstance', 'entity', 'ngSettings', 'authService', function ($scope, APIService, UtilsService, Upload, $log, $uibModalInstance, entity, ngSettings, authService) {
    $scope.entity = entity || {};
    $scope.enviando = false;
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.registro = { IdTipoUsuario: '0', ExcepcionMensaje: '' };
    $scope.registro.Nombres = entity.Nombres;
    $scope.registro.IdSolicitudUsuario = entity.IdSolicitudUsuario;
    $scope.respuestas = [{ value: "", label: "" },
                         { value: true, label: "SI" },
                         { value: false, label: "NO" }];

    $scope.cancelar = function () {
        $uibModalInstance.close(false);
    };
    $scope.aceptar = function () {
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    function guardarDatos() {
        var url = '/api/Usuarios/GestionarSolicitudes/Remitir';

        $scope.registro.Id = entity.Id;
        $scope.registro.Token = entity.Token;
        $scope.registro.Url = ngSettings.frontEndBaseUri;
        $scope.enviando = true;
        $scope.registro.AudUserName = authService.authentication.userName;
        $scope.registro.AddIdent = authService.authentication.isAddIdent;
        $scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var serviceBase = ngSettings.apiServiceBaseUri;
        Upload.upload({
            url: serviceBase + url,
            method: "POST",
            data: $scope.registro,
            file: $scope.registro.file,
        }).then(function (Resultado) {
            $scope.enviando = false;
            switch (Resultado.data.estado) {
                case 0:
                    var mensaje = { msn: Resultado.data.respuesta, tipo: "alert alert-warning" };
                    $uibModalInstance.close(mensaje);
                    break;
                case 2:
                    var mensaje = { msn: Resultado.data.respuesta, tipo: 'alert alert-success' }
                    $uibModalInstance.close(mensaje);
            }
        }, function (error) {
            $scope.enviando = false;
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    getTiposUsuario();

    function getTiposUsuario() {
        var url = '/api/General/Listas/TipoUsuarios?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.roles = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);

app.controller('ModalVerDetallesController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity) {
    //--------------------Inicio-------------------------------------
    $scope.registro = entity;

    $scope.items = [
        { label: "Nombres", value: getDato(entity.Nombres) },
        { label: "Cargo", value: getDato(entity.Cargo) },
        { label: "Departamento", value: getDato(entity.Departamento) },
        { label: "Municipio", value: getDato(entity.Municipio) },
        { label: "Email", value: getDato(entity.Email) },
        { label: "Fecha No Repudio", value: getDate(entity.FechaNoRepudio) },
        { label: "Email Alternativo", value: getDato(entity.EmailAlternativo) },
        { label: "Fecha Solicitud", value: getDate(entity.FechaSolicitud) },
        { label: "Teléfono Celular", value: getDato(entity.TelefonoCelular) },
        { label: "Teléfono Fijo", value: getDato(entity.TelefonoFijo) },
        { label: "Extensión", value: getDato(entity.TelefonoFijoExtension) },
        { label: "Indicativo", value: getDato(entity.TelefonoFijoIndicativo) }
    ];

    function getDate(fecha) {
        if (!fecha) return "Sin Información";
        return new Date(fecha).toLocaleDateString();
    }

    function getDato(dato) {
        if (dato == null || dato.length == 0 || dato.trim() == '') return "Sin información";
        return dato;
    }

    $scope.cancelar = function () {
        $uibModalInstance.close(false);
    };
    //--------------------Fin ---------------------------------------

}]);

app.controller('ModalVerHistoricoController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', '$dsb', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, $dsb) {
    //--------------------Inicio-------------------------------------
    $scope.registro = entity;
    $scope.items = [
        { label: "Nombres", value: getDato(entity.Nombres) },
        { label: "Cargo", value: getDato(entity.Cargo) },
        { label: "Departamento", value: getDato(entity.Departamento) },
        { label: "Municipio", value: getDato(entity.Municipio) },
        { label: "Email", value: getDato(entity.Email) },
        { label: "Fecha Confirmación", value: getDate(entity.FechaConfirmacion) },
        { label: "Fecha No Repudio", value: getDate(entity.FechaNoRepudio) },
        { label: "Email Alternativo", value: getDato(entity.EmailAlternativo) },
        { label: "Fecha Solicitud", value: getDate(entity.FechaSolicitud) },
        { label: "Fecha Trámite", value: getDate(entity.FechaTramite) },
        { label: "Teléfono Celular", value: getDato(entity.TelefonoCelular) },
        { label: "Teléfono Fijo", value: getDato(entity.TelefonoFijo) },
        { label: "Extensión", value: getDato(entity.TelefonoFijoExtension) },
        { label: "Indicativo", value: getDato(entity.TelefonoFijoIndicativo) },
        { label: "Tipo Usuario", value: getDato(entity.TipoUsuario) },
        { label: "Usuario Trámite", value: getDato(entity.UsuarioTramite) },
    ];

    function getDate(fecha) {
        if (!fecha) return "Sin Información";
        return new Date(fecha).toLocaleDateString();
    }

    function getDato(dato) {
        if (dato == null || dato.length == 0 || dato.trim() == '') return "Sin información";
        return dato;
    }

    $scope.cancelar = function () {
        $uibModalInstance.close(false);
    };
    //--------------------Fin ---------------------------------------

    $scope.scrollBarSize = $dsb.getSize();
}]);


