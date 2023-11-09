app.controller('HistoricoUsuariosController', ['$scope', 'APIService', 'UtilsService', 'authService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', '$dsb', 'authService', function ($scope, APIService, UtilsService, authService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, $dsb, authService) {
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;

    $scope.cargoDatos = null;
    $scope.colPdf = [
        { columna: 'E-Mail', col: null },
        { columna: 'Tipo Usuario', col: null },
        { columna: 'Celular', col: null },
        { columna: 'Fecha', col: null }
    ]
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            angular.forEach($scope.colPdf, function (fila) {
                if (col.colDef.displayName === fila.columna) fila.col = col;
            });
            if (col.colDef.displayName === 'Fecha') value = (value != '' ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Fecha No Repudio') value = (value != '' ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Fecha Trámite') value = (value != '' ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Fecha Confirma') value = (value != '' ? new Date(value).toLocaleDateString() : "");
            if (col.colDef.displayName === 'Activo') value === true ? value = "SI" : value = "NO";
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom($scope.gridApi);
            gridApi.grid.options.exporterPdfTableHeaderStyle = { fontSize: 7, bold: true, color: 'white', fillColor: '#63002D', alignment: 'center' };
            gridApi.grid.options.exporterPdfDefaultStyle = { fontSize: 6 };
            gridApi.grid.options.exporterPdfCustomFormatter = function (docDefinition) {
                var datosPDF = docDefinition.content[0].table.body;
                UtilsService.personalizarExportPDF(datosPDF, $scope.colPdf)
                docDefinition.styles.headerStyle = { fontSize: 10, bold: true, alignment: 'center', color: '#63002D' };
                docDefinition.styles.footerStyle = { fontSize: 8, bold: true, alignment: 'center', color: '#333333' };
                //docDefinition.content[0].table.widths = [40, 30, 30, 30, 30, 30, 30, 30, 30, '*'];
                docDefinition.pageMargins = [10, 50, 10, 50];
                return docDefinition;
            }
        }
    };

    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid'); }
    });

    $scope.isColumnDefs = false;

    var columnsNoVisibles = [
        "EmailAlternativo",
        "Id",
        "TelefonoFijoIndicativo",
        "TelefonoFijoExtension",
        "Cargo",
        "IdUsuarioHistorico",
    ]

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi.grouping.clearGrouping();
    };

    var actionJsonExportar = [
        "EmailAlternativo",
        "Id",
        "TelefonoFijoIndicativo",
        "TelefonoFijoExtension",
        "Cargo",
        "DocumentoSolicitud"
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
            { field: "Municipio", newProperty: 95 },
            { field: "Departamento", newProperty: 100 },
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
            { field: "Municipio", newProperty: 95 },
            { field: "Departamento", newProperty: 100 },
            { field: "UsuarioTramite", newProperty: 100 },
            { field: "Fecha No Repudio", newProperty: 50 },
            { field: "Fecha Trámite", newProperty: 80 },
            { field: "Fecha Confirma", newProperty: 80 },
            { field: "Activo", newProperty: 50 }
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

    var checboxCell = {
        action: "CambiarDefinicion",
        definition: "cellTemplate",
        parameters: [
            { field: "Activo", newProperty: '<input style="vertical-align: middle; display: block;margin-right: auto;margin-left: auto;" type="checkbox" ng-model="COL_FIELD" ng-true-value="true" ng-false-value="false"/>' },
        ]
    };

    var columnDefsJsonFijas = [{
        name: '#',
        cellTemplate: '<div class="text-center" style="padding-top:5px;"><a href="" ng-click="grid.appScope.openVerDetalles(row.entity)"><i class="fa fa-plus-square-o"></i></a></div>',
        enableFiltering: false,
        pinnedLeft: true,
        width: 80,
        enableColumnMenu: false,
        exporterSuppressExport: true,
    }];



    //------------------- Declaración de variables a nivel de Controller -------------------
    $scope.registro = {};
    $scope.GobernacionAlcaldias = [];
    $scope.alcaldias = [];
    $scope.mostrarReporte = false;
    $scope.cargando = null;
    $scope.TipoUsuario;

    var autenticacion = authService.authentication;
    var url = '/api/Usuarios/Usuarios/BuscarXUsuario';
    var usuario = { UserName: autenticacion.userName };
    $scope.datosUsuario = {};
    var servCall = APIService.saveSubscriber(usuario, url);
    servCall.then(function (response) {
        if (response.data[0]) {
            $scope.datosUsuario = response.data[0];
            cargarComboDepartamentos();
            getTiposUsuario();
        }


    }, function (error) {
    });

    //-------------------Se carga los combos de Reporte, Departamento y Municipio------------
    function cargarComboDepartamentos() {
        if ($scope.datosUsuario.IdTipoUsuario != 3) { //ALCALDIA
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
    }

    $scope.cargarComboMunicipios = function () {
        cargarMunicipios();
    }

    function cargarMunicipios() {
        $scope.alcaldias = [];
        if ($scope.registro.idDepartamento == 0) {
            $scope.alerta = "Debe seleccionar una Gobernación o un Departamento.";
        }
        else {
            angular.forEach($scope.GobernacionAlcaldias, function (alcaldia) {
                if (alcaldia.IdDepartamento == $scope.registro.idDepartamento)
                    $scope.alcaldias.push(alcaldia);
            });
        }
    }

    function getTiposUsuario() {
        var url = '/api/General/Listas/TipoUsuarios?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.roles = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    //------------------Se obtienen los datos------------------------------
    $scope.aceptar = function () {
        if (!$scope.validar()) return false;
        $scope.alerta = null;
        getFiltros();
    };

    getDatos();
    function getDatos() {
        var url = '/api/Usuarios/GestionarSolicitudes/HistoricoUsuario?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent + '&pIdDepto=' + $scope.registro.idDepartamento + '&pIdMun=' + $scope.registro.idMunicipio + '&pIdTipoUsuario=' + $scope.registro.IdTipoUsuario;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            if (datos.length > 0) {
                $scope.gridOptions.data = datos;
                $log.log(datos);
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnDefsJsonFijas, columnsNoVisibles);
                UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions, changeWidth);
                UtilsService.utilsGridOptions($scope.gridOptions, changeMinWidth);
                //UtilsService.utilsGridOptions($scope.gridOptions, documentoSolicitudCelda);
                UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
                UtilsService.utilsGridOptions($scope.gridOptions, checboxCell);
                UtilsService.utilsGridOptions($scope.gridOptions, filtersChange);
                $scope.gridOptions.exporterSuppressColumns = actionJsonExportar;
                $scope.isColumnDefs = true;
                $scope.isGrid = true;
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
    };

    function getFiltros() {
        var url = '/api/Usuarios/GestionarSolicitudes/HistoricoUsuario?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent + '&pIdDepto=' + $scope.registro.idDepartamento + '&pIdMun=' + $scope.registro.idMunicipio + '&pIdTipoUsuario=' + $scope.registro.IdTipoUsuario;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            if (datos.length > 0) {
                $scope.gridOptions.data = datos;
                $log.log(datos);
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnDefsJsonFijas, columnsNoVisibles);
                UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                UtilsService.utilsGridOptions($scope.gridOptions, changeWidth);
                UtilsService.utilsGridOptions($scope.gridOptions, changeMinWidth);
                //UtilsService.utilsGridOptions($scope.gridOptions, documentoSolicitudCelda);
                UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
                //UtilsService.utilsGridOptions($scope.gridOptions, checboxCell);
                UtilsService.utilsGridOptions($scope.gridOptions, filtersChange);
                $scope.gridOptions.exporterSuppressColumns = actionJsonExportar;
                $scope.isColumnDefs = true;
                $scope.isGrid = true;
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
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //-----------------Insertar texto en un string--------------------------
    String.prototype.splice = function (idx, rem, str) {
        return this.slice(0, idx) + str + this.slice(idx + Math.abs(rem));
    };

    $scope.openVerDetalles = function (entity) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/VerDetallesHistorico.html',
            controller: 'ModalVerDetallesHistoricoController',
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

}]);


app.controller('ModalVerDetallesHistoricoController', ['$scope', 'APIService', 'authService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', function ($scope, APIService, authService, $filter, $log, $uibModalInstance, $http, entity) {
    //--------------------Inicio-------------------------------------
    $scope.registro = entity;
    ObtenerUsuarioHistorico(entity);

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

    function ObtenerUsuarioHistorico(entity) {
        var url = '/api/Usuarios/GestionarSolicitudes/UsuarioHistorico?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent + '&pUsername=' + entity.UserName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            if (datos.length > 0) {
                $scope.usuariosHistoricos = datos;
            } else {
                $scope.alerta = "No se encontraron datos";
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });

    }

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
