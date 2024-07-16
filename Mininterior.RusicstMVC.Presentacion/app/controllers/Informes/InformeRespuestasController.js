app.controller('InformeRespuestasController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, authService) {
    $scope.autenticacion = authService.authentication;
    $scope.filtro = {};
    $scope.GobernacionAlcaldias = [];
    $scope.alcaldias = [];
    $scope.cargoDatos = null;
    $scope.seleccionarTodos = false;

    //ADMIN, ENLACE, ANALISTA, ALCALDIA, GOBERNACION
    $scope.Usuario = { idUsuario: $scope.autenticacion.idUsuario, idTipoUsuario: $scope.autenticacion.idTipoUsuario, usuario: $scope.autenticacion.userName, nombreTipoUsuario: '', idDepartamento: 0, idMunicipio: 0 };

    getDatosUsuario();
    cargarComboEncuesta();

    $scope.cargarSecciones = function () {
        if ($scope.filtro.idEncuesta) {
            var url = '/api/Informes/InformeRespuestas/ObtenerSecciones/' + $scope.filtro.idEncuesta;
            getDatos();
            function getDatos() {
                var servCall = APIService.getSubs(url);
                servCall.then(function (datos) {
                    $scope.secciones = datos;
                }, function (error) {
                    $scope.error = "Se generó un error en la petición del listado de grupos";
                });
            }
        }
    }

    $scope.cargarComboMunicipios = function () {
        cargarMunicipios();
    }

    $scope.seleccionarTodo = function () {
        angular.forEach($scope.secciones, function (item) {
            item.check = !$scope.seleccionarTodos;
            angular.forEach(item.ListaSubsecciones, function (item2) {
                item2.check = !$scope.seleccionarTodos;
                angular.forEach(item2.ListaSubsecciones, function (item3) {
                    item3.check = !$scope.seleccionarTodos;
                });
            });
        });
        $scope.seleccionarTodos = !$scope.seleccionarTodos;
    };

    function getDatosUsuario() {
        var datos = { UserName: $scope.autenticacion.userName };
        var url = '/api/Usuarios/Usuarios/BuscarXUsuario';
        var servCall = APIService.saveSubscriber(datos, url);
        servCall.then(function (datos) {
            $scope.datos = datos.data[0];
            $scope.Usuario.idTipoUsuario = $scope.datos.IdTipoUsuario;
            $scope.Usuario.nombreTipoUsuario = $scope.datos.TipoTipoUsuario;
            $scope.Usuario.idDepartamento = $scope.datos.IdDepartamento;
            $scope.Usuario.idMunicipio = $scope.datos.IdMunicipio;

            cargarComboDepartamentos_Municipios();

        }, function (error) {
        });
    };

    function cargarMunicipios() {
        $scope.alcaldias = [];
        if ($scope.filtro.departamento == 0) {
            $scope.alerta = "Debe seleccionar una Gobernación o un Departamento.";
        }
        else {
            angular.forEach($scope.GobernacionAlcaldias, function (alcaldia) {
                if (alcaldia.IdDepartamento == $scope.filtro.departamento)
                    $scope.alcaldias.push(alcaldia);
            });
        }
    }

    function cargarComboDepartamentos_Municipios() {
        if ($scope.Usuario.idTipoUsuario != 3) { //ALCALDIA
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

        if ($scope.Usuario.idTipoUsuario == 7) {//GOBERNACION
            $timeout(function () {
                $scope.filtro.departamento = $scope.Usuario.idDepartamento;
                cargarMunicipios();
            }, 1000);
        }
    }

    function cargarComboEncuesta() {
        ////==============================================================================================================================================================================================================================
        ////Esto debe cambiar ya que se debe pasar el tipo de usuario
        ////var url = '/api/Informes/InformeRespuestas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent+'&TipoUsuario=' + $scope.Usuario.idTipoUsuario;
        ////==============================================================================================================================================================================================================================
        var url = '/api/General/Listas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de combo de encuestas";
        });
    }

    //------------------- Inicio logica de filtros de la pantalla -------------------

    $scope.filtrar = function () {
        $scope.alerta = null;
        if (!$scope.filtro.idEncuesta) {
            $scope.alerta = "Seleccione por lo menos una encuesta para realizar la búsqueda";
            return;
        }
        var strListaSubsecciones = "";
        angular.forEach($scope.secciones, function (item) {
            if (item.check) {
                strListaSubsecciones = strListaSubsecciones + item.Id + ',';
            }
            angular.forEach(item.ListaSubsecciones, function (item2) {
                if (item2.check) {
                    strListaSubsecciones = strListaSubsecciones + item2.Id + ',';
                }
                angular.forEach(item2.ListaSubsecciones, function (item3) {
                    if (item3.check) {
                        strListaSubsecciones = strListaSubsecciones + item3.Id + ',';
                    }
                });
            });
        });
        strListaSubsecciones = strListaSubsecciones.substring(0, strListaSubsecciones.length - 1);
        var url = '/api/Informes/InformeRespuestas/DatosRejilla?idEncuesta=' + $scope.filtro.idEncuesta + '&listaIdSubsecciones=' + strListaSubsecciones + '&usuario=' + $scope.Usuario.usuario;
        if ($scope.filtro.departamento) { url = url + '&idDepartamento=' + $scope.filtro.departamento; }
        else {
            url = url + '&idDepartamento='
        }
        if ($scope.filtro.municipio) { url = url + '&idMunicipio=' + $scope.filtro.municipio; }
        else {
            url = url + '&idMunicipio='
        }
        getDatos();
        function getDatos() {
            $scope.cargoDatos = true;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatos = null;
                if (datos.length > 0) {
                    $scope.isGrid = true;
                    $scope.gridOptions.data = datos;
                    var columsNoVisibles = [];
                    if (!$scope.isColumnDefs) {
                        UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs);
                        $scope.isColumnDefs = true;
                    } else {
                        UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs);
                    }
                    UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
                } else {
                    $scope.isGrid = false;
                    $scope.isColumnDefs = false;
                    $scope.alerta = "No se encontraron datos";
                }
            }, function (error) {
                $scope.cargoDatos = null;
                $scope.error = "Se generó un error en la petición";
            });
        }
    }

    $scope.exportar = function () {
        //var exportColumnHeaders = [{ align: "left", displayName: "Clave", name: "Nombre" }, { align: "left", displayName: "Clave2", name: "Nombre2" }];
        //var exportData = [{ value:"col11", value:"col12"}, { value:"col21", value:"col22"}];
        //var fileName = '.xls';
        //var type = 'xls';
        //UtilsService.exportToExcel(exportColumnHeaders, exportData, fileName, type);
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //------------------- Inicio logica de la grilla ------------------- 
    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "PreguntaId", newProperty: "Id Pregunta" },
            { field: "PreguntaTexto", newProperty: "Texto Pregunta" },
            { field: "Seccion", newProperty: "Sección" },
        ]
    };
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.colPdf = [
        { columna: 'Pregunta', col: null },
        { columna: 'Sección', col: null },
        { columna: 'Usuario', col: null }
    ]
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            angular.forEach($scope.colPdf, function (fila) {
                if (col.colDef.displayName === fila.columna) fila.col = col;
            });
            //if (col.colDef.displayName === 'Pregunta') $scope.colPregunta = col; // value = UtilsService.exportPdfColumnLarge(col, value);
            //if (col.colDef.displayName === 'Sección') value = UtilsService.exportPdfColumnLarge(col, value);
            //if (col.colDef.displayName === 'Usuario') value = UtilsService.exportPdfColumnLarge(col, value);
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
            gridApi.grid.options.exporterPdfTableHeaderStyle = { fontSize: 8, bold: true, color: 'white', fillColor: '#63002D', alignment: 'center' };
            gridApi.grid.options.exporterPdfDefaultStyle = { fontSize: 7 };
            gridApi.grid.options.exporterPdfCustomFormatter = function (docDefinition) {

                var datosPDF = docDefinition.content[0].table.body;
                UtilsService.personalizarExportPDF(datosPDF, $scope.colPdf)
                //var pp = 0;
                //var primeraFila = angular.copy(datosPDF[0]);
                //for (var propiedad in primeraFila) {
                //    angular.forEach($scope.colPdf, function (fila) {
                //        if (fila.columna === datosPDF[0][propiedad].text) fila.indice = pp;
                //    });
                //    pp++
                //}
                //datosPDF.shift();
                //angular.forEach(datosPDF, function (fila) {
                //    angular.forEach($scope.colPdf, function (fila2) {
                //        fila[fila2.indice] = UtilsService.exportPdfColumnLarge( fila2.col, fila[fila2.indice]);
                //    });
                //    // fila[3] = UtilsService.exportPdfColumnLarge($scope.colPregunta, fila[3]);
                //});
                //datosPDF.unshift(primeraFila);

                docDefinition.styles.headerStyle = { fontSize: 10, bold: true, alignment: 'center', color: '#63002D' };
                docDefinition.styles.footerStyle = { fontSize: 8, bold: true, alignment: 'center', color: '#333333' };
                return docDefinition;
            }
        },
    };
    $scope.isColumnDefs = false;



    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    //DIMENSIONAR LA TABLA
    $scope.getTableHeight = function () {
        var rowHeight = 30; // your row height
        var headerHeight = 30; // your header height
        return {
            height: '500px'//($scope.gridData.data.length * rowHeight + headerHeight) + "px"
        };
    };

    //$scope.colsGroup = angular.copy($scope.gridOptions.columnDefs);
    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    $scope.toggleFiltering = function () {
        $scope.gridOptions.enableFiltering = !$scope.gridOptions.enableFiltering;
        $scope.gridApi.core.notifyDataChange(uiGridConstants.dataChange.COLUMN);
    };
}]);
