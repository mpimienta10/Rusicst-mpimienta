app.controller('GestionDepartamentalController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', '$location', 'ngSettings', 'enviarDatos', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService, $location, ngSettings, enviarDatos) {
    $scope.idTablero = enviarDatos.datos.Id;
    $scope.anoPlaneacion = enviarDatos.datos.Planeacion;
    if (!enviarDatos.datos.Id) {
        $location.url('/Index/TableroPat/TablerosDepartamento');
    }
    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.derecho = [];
    $scope.derechos = [];
    $scope.tableros = [];
    $scope.vigencias = [];
    $scope.cargoDatosConsolidadoMunicipal = true;
    $scope.cargoDatosRC = true;
    $scope.cargoDatosRR = true;
    $scope.listaNumRegistros = {
        availableOptions: [
          { id: '10', name: '10' },
          { id: '20', name: '20' },
          { id: '30', name: '30' },
          { id: '40', name: '40' },
          { id: '50', name: '50' },
          { id: '60', name: '60' },
          { id: '70', name: '70' },
          { id: '80', name: '80' },
          { id: '90', name: '90' },
          { id: '100', name: '100' }
        ],
        selectedOption: { id: '10', name: '10' }
    };
    $scope.tab = 2
    $scope.maxSize = 100;
    $scope.maxSizeRR = 100;
    $scope.maxSizeRC = 100;
    $scope.bigTotalItems = 0;
    $scope.bigTotalItemsRC = 0;
    $scope.bigTotalItemsRR = 0;
    $scope.bigCurrentPage = 1;
    $scope.bigCurrentPageRC = 1;
    $scope.bigCurrentPageRR = 1;
    $scope.flagVariable = false;
    $scope.activo = false;
    $scope.autenticacion = authService.authentication;
    $scope.esConsulta = false;
    if (enviarDatos.Consulta && enviarDatos.datos.Entidad) {
        //viene de la pantalla de consulta y debe tomar el usuario que selecciono y solo debe permitir consulta
        $scope.userName = enviarDatos.datos.Entidad;
        $scope.esConsulta = true;
    } else {//si no toma el usuario actual     
        $scope.userName = $scope.autenticacion.userName;
    }
    $scope.ValidarConsulta = function () {
        if (enviarDatos.Consulta && enviarDatos.datos.Entidad) {
            $scope.active = 0;
            $scope.activo = false;
            $scope.ActivoEnvioPATPlaneacion = false;
        }
    }
    $scope.sortOrder = "";
    $scope.tipoSortOrder = "ASC";
    $scope.idUsuario;
    $scope.busqueda;
    $scope.started = true;
    $scope.model = {
        idMunicipioRC: 0,
        idMunicipioRR: 0,
        busqueda: ""
    };
    $scope.municipiosRC = [];
    $scope.municipiosRR = [];
    //--------------Metodos para "PREGUNTAS DEPARTAMENTO"
    $scope.init = function () {
        $scope.showData();
    };
    $scope.showData = function () {
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.tableros = [];
        $scope.tablerosRR = [];
        $scope.tablerosRC = [];
        $scope.vigencias = [];
        $scope.cargoDatos = null;
        var url = "";
        getDatos();
        function getDatos() {
            url = '/api/TableroPat/CargarTableroDepartamentos/null,' + $scope.bigCurrentPage + ',' + $scope.listaNumRegistros.selectedOption.id + ',0,' + $scope.userName + ',' + $scope.idTablero;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.active = 0;
                $scope.cargoDatos = true;
                $scope.activo = datos.activo;
                $scope.disabled = $scope.activo ? '' : 'disabled';
                $scope.esConsulta = $scope.activo ? false : true;
                $scope.derechos = datos.derechos;
                $scope.avance = datos.avance;
                $scope.vigencias = datos.vigencia;
                $scope.Usuario = datos.datosUsuario[0];
                $scope.tableros = datos.datos;
                $scope.bigTotalItems = datos.totalItems;
                $scope.numPages = datos.TotalPages;
                $scope.ActivoEnvioPATPlaneacion = datos.ActivoEnvioPATPlaneacion;
                $scope.ValidarConsulta();                
                if ($scope.busqueda) {
                    buscarDatosMunicipalesPorDerecho();
                }

            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
    };
    $scope.init();
    $scope.Editar = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/DepartamentosPat.html',
            controller: 'DepartamentoEdicionCtrl',
            size: 'lg',
            resolve: {
                tablero: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.tableros[index]), activo: $scope.activo };
                    return datos;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (datosResponse) {
                mostrarMensaje(datosResponse);
            }
        );
    }
    $scope.$watchGroup(['listaNumRegistros.selectedOption'], function (newValue, oldValue) {
        if (newValue || oldValue) {
            if ($scope.model.busqueda) {
                if ($scope.tab == "2") {      //tab de derechos normales               
                    $scope.buscarDatosMunicipalesPorDerechoPorCambioPag();
                }
                if ($scope.tab == "3") {    //tab de reparacion colectiva
                    $scope.buscarDatosRC();
                }
                if ($scope.tab == "4") {    //tab de Retornos y reubicacione
                    $scope.buscarDatosRR();
                }
            }
        }
    });
    //--------------Metodos para "CONSOLIDADO MUNICIPAL"
    $scope.pageChanged = function (opcion) {
        if (opcion) {
            $scope.sortOrder = opcion + ' ' + $scope.tipoSortOrder;
            $scope.tipoSortOrder = $scope.tipoSortOrder == 'ASC' ? 'DESC' : 'ASC';
        }
        buscarDatosMunicipalesPorDerecho();
    };
    $scope.pageChangedRR = function () {
        $scope.buscarDatosRR();
    };
    $scope.pageChangedRC = function () {
        $scope.buscarDatosRC()
    };
    $scope.buscarDatosMunicipalesPorDerecho = function () {
        buscarDatosMunicipalesPorDerecho();
    }
    function buscarDatosMunicipalesPorDerecho(busqueda) {
        $scope.active2 = 2;
        $scope.error = null;
        $scope.cargoDatosConsolidadoMunicipal = null;
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.datosTotales = [];
        var url = "";
        var idbusqueda = 0;
        var busq = $("#busqueda").val();
        angular.forEach($scope.derechos, function (der) {
            if (der.DESCRIPCION == busq) {
                idbusqueda = der.ID;
            }
        });
        getDatos();
        function getDatos() {
            url = '/api/TableroPat/CargarTableroConsolidadoMunicipal/null,' + $scope.bigCurrentPage + ',' + $scope.listaNumRegistros.selectedOption.id + ',' + idbusqueda + ',' + $scope.userName + ',' + $scope.idTablero;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatosConsolidadoMunicipal = true;
                $scope.datosTotales = datos.datosTotales;
                $scope.numPages = datos.TotalPagesTotales;
                $scope.bigTotalItems = datos.totalTotales;
                $scope.municipiosRC = [];
                $scope.municipiosRR = [];
                $scope.municipiosRC.push({ Id: 0, Municipio: "--Seleccione--" });
                $scope.municipiosRR.push({ Id: 0, Municipio: "--Seleccione--" });
                angular.forEach(datos.municipiosRC, function (dato) {
                    $scope.municipiosRC.push(dato);
                });
                angular.forEach(datos.municipiosRR, function (dato) {
                    $scope.municipiosRR.push(dato);
                });
                $scope.dataRC = {
                    availableOptions: $scope.municipiosRC,
                    selectedOption: { Id: '0', Municipio: '--Seleccione--' }
                };
                $scope.dataRR = {
                    availableOptions: $scope.municipiosRR,
                    selectedOption: { Id: '0', Municipio: '--Seleccione--' }
                };
                $scope.urlDerechos = datos.urlDerechos;
                if ($scope.urlDerechos.length > 0) {
                    $scope.abrirArchivosUrlsDerechos($scope.urlDerechos);
                }
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
    }

    //=========== Abrir Modal Configuración derechos ===============================
    $scope.abrirArchivosUrlsDerechos = function (entidad) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/ArchivosUrlsDerechos.html',
            controller: 'ModalArchivosUrlsDerechosController',
            backdrop: 'static', keyboard: false, size: 'lg',
            resolve: {
                entidad: function () {
                    if (entidad) {
                        return angular.copy(entidad);
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
    //********************* MFin Mostrar Modal ******************************************************
    $scope.buscarDatosMunicipalesPorDerechoPorCambioPag = function () {
        $scope.active2 = 2;
        $scope.error = null;
        $scope.cargoDatosConsolidadoMunicipal = null;
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.datosTotales = [];
        var url = "";
        var idbusqueda = 0;
        var busq = $("#busqueda").val();
        angular.forEach($scope.derechos, function (der) {
            if (der.DESCRIPCION == busq) {
                idbusqueda = der.ID;
            }
        });

        getDatos();
        function getDatos() {
            url = '/api/TableroPat/CargarTableroConsolidadoMunicipal/null,' + $scope.bigCurrentPage + ',' + $scope.listaNumRegistros.selectedOption.id + ',' + idbusqueda + ',' + $scope.userName + ',' + $scope.idTablero;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatosConsolidadoMunicipal = true;
                $scope.datosTotales = datos.datosTotales;
                $scope.numPages = datos.TotalPagesTotales;
                $scope.bigTotalItems = datos.totalTotales;
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }

    }
    $scope.generaExcel = function (index) {
        url = $scope.serviceBase + '/api/TableroPat/Departamentos/DatosExcelDepartamental?idMunicipio=' + $scope.Usuario.IdMunicipio + '&usuario=' + $scope.userName + '&idTablero=' + $scope.idTablero;
        window.open(url)

    }
    $scope.EditarConsolidado = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/DepartamentosConsolidadoPat.html',
            controller: 'DepartamentoConsolidadoCtrl',
            size: 'lg',
            resolve: {
                total: function () {
                    return { Usuario: $scope.Usuario, total: angular.copy($scope.datosTotales[index]), activo: $scope.activo ,anoPlaneacion:$scope.anoPlaneacion };
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
             function (datosResponse) {
                 buscarDatosMunicipalesPorDerecho();
             }
         );
    }
    $scope.EditarAP = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/ConsolidadoMunicipalAccionesProgramas.html',
            controller: 'DepartamentoAPCtrl',
            size: 'lg',
            resolve: {
                tablero: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.datosTotales[index]), activo: $scope.activo };
                    return datos;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
             function (datosResponse) {
                 if (datosResponse.estado == 1 || datosResponse.estado == 2) {
                     mostrarMensajeConsolidado("El tablero se actualizó correctamente");
                 }
                 else {
                     mostrarMensajeConsolidado("No se procesó la Pregunta correctamente. " + datosResponse.respuesta);
                 }
             }
         );
    }

    $scope.cambiotab = function (tab) {
        $scope.tab = tab;
    }
    //--------------MetodosReparacion colectiva   
    $scope.buscarDatosRC = function () {
        buscarDatosRC();
    }
    function buscarDatosRC() {
        $scope.error = null;
        $scope.tablerosRC = [];
        if ($scope.dataRC.selectedOption.Id > 0) {
            $scope.cargoDatosRC = null;
            $scope.mensajeOK = null;
            $scope.mensajeWarning = null;
            getDatos();
        }
        function getDatos() {
            var url = '/api/TableroPat/CargarTableroDepartamentosRC/?sortOrder=null&page=' + $scope.bigCurrentPageRC + '&numMostrar=' + $scope.listaNumRegistros.selectedOption.id + '&idMunicipio=' + $scope.dataRC.selectedOption.Id + '&idTablero=' + $scope.idTablero;
            var servCall = APIService.getSubs(url);

            servCall.then(function (datos) {
                $scope.cargoDatosRC = true;
                $scope.tablerosRC = datos.datosRC;
                $scope.numPagesRC = datos.TotalPages;
                $scope.bigTotalItemsRC = datos.total;
            }, function (error) {
                $scope.cargoDatosRC = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
    }
    $scope.EditarRC = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/DepartamentosPatRC.html',
            controller: 'DepartamentoRCCtrl',
            size: 'lg',
            resolve: {
                tablero: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.tablerosRC[index]), activo: $scope.activo };
                    return datos;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
             function (datosResponse) {
                 if (datosResponse.estado == 1 || datosResponse.estado == 2) {
                     mostrarMensajeRC("El tablero se actualizó correctamente");
                 }
                 else {
                     mostrarMensaje(datosResponse);
                 }
             }
         );
    }

    //--------------MetodosRetornos y reubicaciones
    $scope.buscarDatosRR = function () {
        buscarDatosRR();
    }
    function buscarDatosRR() {
        $scope.error = null;
        $scope.tablerosRR = [];
        if ($scope.dataRR.selectedOption.Id > 0) {
            $scope.cargoDatosRR = null;
            $scope.mensajeOK = null;
            $scope.mensajeWarning = null;
            $scope.tablerosRR = [];
            getDatos();
        }
        function getDatos() {
            var url = '/api/TableroPat/CargarTableroDepartamentosRR/?sortOrder=null&page=' + $scope.bigCurrentPageRR + '&numMostrar=' + $scope.listaNumRegistros.selectedOption.id + '&idMunicipio=' + $scope.dataRR.selectedOption.Id + '&idTablero=' + $scope.idTablero;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatosRR = true;
                $scope.tablerosRR = datos.datosRR;
                $scope.numPagesRR = datos.TotalPages;
                $scope.bigTotalItemsRR = datos.total;
            }, function (error) {
                $scope.cargoDatosRR = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
    }
    $scope.EditarRR = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/DepartamentosPatRR.html',
            controller: 'DepartamentoRRCtrl',
            size: 'lg',
            resolve: {
                tablero: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.tablerosRR[index]), activo: $scope.activo };
                    return datos;
                }
            },
            backdrop: 'static', keyboard: false

        });
        modalInstance.result.then(
             function (datosResponse) {
                 if (datosResponse.estado == 1 || datosResponse.estado == 2) {
                     mostrarMensajeRR("El tablero se actualizó correctamente");
                 }
                 else {
                     mostrarMensaje(datosResponse);
                 }
             }
         );
    }

    function mostrarMensaje(mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    var enviar = { msn: mensaje.respuesta, tipo: (mensaje.estado == 1 || mensaje.estado == 2) ? "alert alert-success" : "alert alert-warning" };
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
             function () {
                 $scope.showData();
             }
           );
    }
    function mostrarMensajeConsolidado(mensaje) {
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
                 $scope.buscarDatosMunicipalesPorDerecho();
             }
           );
    }
    function mostrarMensajeRC(mensaje) {
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
                 buscarDatosRC();
             }
           );
    }
    function mostrarMensajeRR(mensaje) {
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
                 buscarDatosRR();
             }
           );
    }

    //=========== funciones de enviar PAT ===============================  
    $scope.enviar = function () {
        openConfirmacionEnvio();
    };

    var openConfirmacionEnvio = function () {
        var modelo = {};
        //// Cargar los datos de auditoría
        modelo.AudUserName = authService.authentication.userName;
        modelo.AddIdent = authService.authentication.isAddIdent;
        modelo.UserNameAddIdent = authService.authentication.userNameAddIdent;
        modelo.idTablero = $scope.idTablero;
        modelo.idUsuario = $scope.Usuario.Id;
        modelo.Usuario = $scope.Usuario.UserName;
        modelo.tipoEnvio = "PD";

        var modalInstance = $uibModal.open({
            templateUrl: '/app/views/modals/Confirmacion.html',
            controller: 'ModalConfirmacionController',
            resolve: {
                datos: function () {
                    $scope.disabledguardando = 'disabled';
                    var titulo = 'Envio de tablero PAT';
                    var url = '/api/TableroPat/EnvioTablero';
                    var entity = modelo;
                    var msn = "¿Desea enviar el tablero Pat?";
                    return { url: url, entity: entity, msn: msn, titulo: titulo }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
                 function (datosResponse) {
                     if (datosResponse != false) {
                         mostrarMensajeEnvio(datosResponse);
                     }
                 }
             );
    };
    function mostrarMensajeEnvio(respuesta) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    var enviar = { msn: respuesta.respuesta, tipo: (respuesta.estado == 1 || respuesta.estado == 2) ? "alert alert-success" : "alert alert-warning" };
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
             function () {

             }
           );
    }

}]);

app.controller('ModalArchivosUrlsDerechosController', ['$scope', 'APIService', 'UtilsService', '$filter', '$log', '$uibModalInstance', '$http', 'entidad', 'authService', 'ngSettings', function ($scope, APIService, UtilsService, $filter, $log, $uibModalInstance, $http, entidad, authService, ngSettings) {
    $scope.gobernacionUrls = [];
    $scope.gobernacionArchivos = [];
    $scope.alcaldiasUrls = [];
    $scope.alcaldiasArchivos = [];
    $scope.open1 = true;
    $scope.open2 = true;


    if (entidad.length > 0) {
        angular.forEach(entidad, function (fila) {
            if (fila.Papel === 'gobernacion' && fila.Tipo === 'url') { $scope.gobernacionUrls.push(fila); }
            else if (fila.Papel === 'gobernacion' && fila.Tipo === 'archivo') { $scope.gobernacionArchivos.push(fila); }
            else if (fila.Papel === 'alcaldia' && fila.Tipo === 'url') { $scope.alcaldiasUrls.push(fila); }
            else if (fila.Papel === 'alcaldia' && fila.Tipo === 'archivo') { $scope.alcaldiasArchivos.push(fila); }
        })
    }
    getTodosDerechos();
    function getTodosDerechos() {
        var url = '/api/sistema/configuracionderechospat/todosderechos';
        var servcall = APIService.getSubs(url);
        servcall.then(function (datos) {
            if (datos.length > 0) {
                $scope.textos = {};
                var IdBuscar = entidad[0].IdDerecho;
                angular.forEach(datos, function (fila) {
                    if (IdBuscar === fila.Id) {
                        $scope.textos.TextoExplicativoGOB = fila.TextoExplicativoGOB;
                        $scope.textos.TextoExplicativoALC = fila.TextoExplicativoALC;
                        $scope.textos.DescripcionDetallada = fila.DescripcionDetallada;
                        $scope.textos.Descripcion = fila.Descripcion;
                    }
                })
            }
        }, function (error) {
            $scope.cargodatos = true;
            $scope.error = "se generó un error en la petición";
        });
    }

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.descargar = function (item) {
        var url = ngSettings.apiServiceBaseUri + '/api/Sistema/ConfiguracionDerechosPAT/Descargar?archivo=' + item.ParametroValor;
        window.open(url)
    }


}]);

app.controller('DepartamentoEdicionCtrl', ['$scope', 'APIService', '$http', 'tablero', '$uibModalInstance', '$filter', '$log', 'authService', 'ngSettings', 'Upload', 'UtilsService', function ($scope, APIService, $http, tablero, $uibModalInstance, $filter, $log, authService, ngSettings, Upload, UtilsService) {
    $scope.tablero = tablero.tablero;
    $scope.Usuario = tablero.Usuario;
    $scope.activo = tablero.activo;
    $scope.flagVariable = false;
    $scope.disabled = $scope.activo ? '' : 'disabled';
    if ($scope.tablero.IdRespuesta == null) {
        $scope.tablero.IdRespuesta = 0;
        $scope.tablero.ID = 0;
    } else {
        $scope.tablero.ID = $scope.tablero.IdRespuesta;
        $scope.tablero.IdRespuesta = $scope.tablero.IdRespuesta;
    }
    $scope.habilita = false;
    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.accionesAgregadas = [];
    $scope.programasAgregados = [];
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.init = function () {
        var url = "/api/TableroPat/DatosInicialesEdicionDepartamento?pregunta=" + $scope.tablero.ID_PREGUNTA + "&id=" + $scope.tablero.IdRespuesta + '&IdUsuario=' + $scope.Usuario.Id + "&Usuario=" + $scope.Usuario.UserName + '&idTablero=' + $scope.tablero.IdTablero;
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                //$scope.programasOferta = data.d.programasOferta;
                $scope.accionesAgregadas = datos.datosAcciones;
                $scope.programasAgregados = datos.datosProgramas;
                $scope.FuentesPresupuestoRespuesta = datos.FuentesPresupuestoRespuesta;
                $scope.listadoFuentesPresupuestoPAT = datos.listadoFuentesPresupuestoPAT;
                $scope.tablero.FUENTES = [];
                var esta = false;

                angular.forEach($scope.listadoFuentesPresupuestoPAT, function (listado) {
                    angular.forEach($scope.FuentesPresupuestoRespuesta, function (actuales) {
                        if (listado.Id == actuales.IdFuentePresupuesto) {
                            listado.checked = true;
                        }
                    });
                });
                angular.forEach($scope.accionesAgregadas, function (accion) {
                    accion.ACTIVO = true;
                });
                angular.forEach($scope.programasAgregados, function (accion) {
                    accion.ACTIVO = true;
                });
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.submitted = false;
    };
    $scope.errors = [];
    $scope.init();
    $scope.agregarAccion = function () {
        $scope.errors.ACCION = '';
        if ($scope.tablero.ACCION) {
            if ($scope.tablero.ACCION.length > 500) {
                $scope.errors.ACCION = "La acción no debe exceder los 500 caracteres";
                return;
            }
            var accionExistente = false;
            angular.forEach($scope.accionesAgregadas, function (accion) {
                if (accion.ACCION == $scope.tablero.ACCION) {
                    accionExistente = true;
                    if (accion.ACTIVO == false) {
                        accion.ACTIVO = true;
                    }
                }
            });
            if (!accionExistente) {
                $scope.accionesAgregadas.push({ ACCION: $scope.tablero.ACCION, ACTIVO: true });
            }
            $scope.tablero.ACCION = null;
            $("#accion").focus();
        } else {
            $scope.errors.ACCION = "La acción es requerida";
        }
    }
    $scope.borrarAccion = function (index) {
        $scope.accionesAgregadas[index].ACTIVO = false;
    }

    $scope.agregarProgramaOferta = function (index) {
        var programaOferta = $scope.programasOferta[index].PROGRAMA;
        var programaExistente = false;
        angular.forEach($scope.programasAgregados, function (programa) {
            if (programa.PROGRAMA == programaOferta) {
                programaExistente = true;
                if (programa.ACTIVO == false) {
                    programa.ACTIVO = true;
                }
            }
        });
        if (!programaExistente) {
            $scope.programasAgregados.push({ PROGRAMA: programaOferta, ACTIVO: true });
        }
        programaOferta = null;
    }

    $scope.agregarPrograma = function () {
        $scope.errors.PROGRAMA = '';
        if ($scope.tablero.PROGRAMA) {
            if ($scope.tablero.PROGRAMA.length > 1000) {
                $scope.errors.PROGRAMA = "El programa no debe exceder los 1000 caracteres";
                return;
            }
            var programaExistente = false;
            angular.forEach($scope.programasAgregados, function (programa) {
                if (programa.PROGRAMA == $scope.tablero.PROGRAMA) {
                    programaExistente = true;
                    if (programa.ACTIVO == false) {
                        programa.ACTIVO = true;
                    }
                }
            });
            if (!programaExistente) {
                $scope.programasAgregados.push({ PROGRAMA: $scope.tablero.PROGRAMA, ACTIVO: true });
            }
            $scope.tablero.PROGRAMA = null;
            $("#programa").focus();
        } else {
            $scope.errors.PROGRAMA = "El programa es requerido";
        }
    }

    $scope.borrarPrograma = function (index) {
        $scope.programasAgregados[index].ACTIVO = false;
    }

    $scope.guardar = function () {
        $scope.submitted = true;
        $scope.extension = false;
        $scope.errors = [];
        if (!$scope.validar()) return false;
        if (!$scope.validarExtension()) return false;
        if ($scope.tablero.ACCION) {
            $scope.errors.ACCION = "Tiene acciones pendientes por agregar";
            return false;
        }
        if ($scope.tablero.PROGRAMA) {
            $scope.errors.PROGRAMA = "Tiene programas pendientes por agregar";
            return false;
        }
        $scope.habilita = true;
        $scope.flagVariable = true;
        $scope.tablero.NECESIDADIDENTIFICADA = $scope.totalNecesidades;
        $scope.tablero.RespuestaPatAccion = $scope.accionesAgregadas;
        $scope.tablero.RespuestaPatPrograma = $scope.programasAgregados;
        $scope.tablero.IDUSUARIO = $scope.Usuario.Id;
        $scope.tablero.IDPREGUNTA = $scope.tablero.ID_PREGUNTA;
        $scope.tablero.NombreAdjunto = (!$scope.tablero.NombreAdjunto) ? ($scope.file ? $scope.file.name : "") : $scope.tablero.NombreAdjunto;

        $scope.tablero.RespuestaPatFuente = [];
        angular.forEach($scope.listadoFuentesPresupuestoPAT, function (fuente) {
            if (fuente.checked == true) {
                $scope.tablero.RespuestaPatFuente.push({ "Id": fuente.Id, "checked": true, insertar: true });
            }
            if (fuente.checked == false) {
                $scope.tablero.RespuestaPatFuente.push({ "Id": fuente.Id, "checked": true, insertar: false });
            }
        });

        if ($scope.tablero.ID == null) {
            $scope.tablero.ID = 0;
        }

        var url = "/api/TableroPat/ModificarDepartamento";

        //// Cargar los datos de auditoría
        $scope.tablero.AudUserName = authService.authentication.userName;
        $scope.tablero.AddIdent = authService.authentication.isAddIdent;
        $scope.tablero.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.tablero, url);
        servCall.then(function (response) {
            $scope.flagVariable = false;
            $uibModalInstance.close(response.data);
            if ($scope.file) {
                $scope.tablero.usuario = $scope.tablero.IDUSUARIO;
                $scope.tablero.tablero = $scope.tablero.IdTablero;
                $scope.tablero.pregunta = $scope.tablero.IDPREGUNTA;
                $scope.tablero.type = 'GDepartamentos';
                $scope.upload($scope.file);
            }
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = data;
        });
    };

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.validar = function () {
        return $scope.registerForm.$valid;
    };
    $scope.validarExtension = function () {
        if ($scope.file) {
            var filename = $scope.file.name;
            var index = filename.lastIndexOf(".");
            var strsubstring = filename.substring(index, filename.length);
            strsubstring = strsubstring.toLowerCase();
            if (strsubstring == '.pdf' || strsubstring == '.doc' || strsubstring == '.docx' || strsubstring == '.xlsx' || strsubstring == '.xls' || strsubstring == '.png' || strsubstring == '.jpeg' || strsubstring == '.png' || strsubstring == '.jpg' || strsubstring == '.gif' || strsubstring == '.txt' || strsubstring == '.rar' || strsubstring == '.zip' || strsubstring == '.7z') {
                $scope.extension = true;
                return true;
            } else {
                return false;
            }
        } else {
            return true;
        }
    }
    $scope.BorraMensaje = function () { // $scope que acciona el ng-kepress
        $scope.errors.DESCRIPCION = '';
    };

    $scope.upload = function (file) {
        Upload.upload({
            url: serviceBase + '/api/TableroPat/AdjutarArchivo',
            method: "POST",
            data: $scope.tablero,
            file: file,
        }).then(function (resultado) {
            $scope.deshabiltarRegistrese = false;
            //$uibModalInstance.close(resultado.data);
        }, function (resultado) {
            $scope.deshabiltarRegistrese = false;
            var mensaje = { msn: 'Error: ' + resultado.data.ExceptionMessage, tipo: "alert alert-danger" };
        }, function (evt) {
            //var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
            //console.log('progress: ' + progressPercentage + '% ' + evt.config.data.file.name);
        });
    };
    $scope.borrarAdjunto = function () {
        $scope.tablero.NombreAdjunto = "";
    }
    $scope.descargar = function (index) {
        var url = $scope.serviceBase + '/api/TableroPat/DownloadDiligenciamiento?archivo=' + $scope.tablero.NombreAdjunto + '&nombreArchivo=' + $scope.tablero.NombreAdjunto + '&type=GDepartamentos&idTablero=' + $scope.tablero.IdTablero + '&idPregunta= ' + $scope.tablero.ID_PREGUNTA + '&idUsuario=' + $scope.Usuario.Id;
        window.open(url)
    }
}]);

app.controller('DepartamentoConsolidadoCtrl', ['$scope', 'APIService', '$http', 'total', '$uibModal', '$uibModalInstance', 'authService', function ($scope, APIService, $http, total, $uibModal, $uibModalInstance, authService) {
    $scope.total = total.total || { ID: 0 };
    $scope.anoPlaneacion = total.anoPlaneacion;
    $scope.Usuario = total.Usuario;
    $scope.activo = total.activo;
    $scope.disabled = $scope.activo ? '' : 'disabled';
    $scope.consolidados = [];
    $scope.habilita = false;
    $scope.cargoDatos = false;
    $scope.init = function () {
        var url = "/api/TableroPat/DatosConsolidado/?pregunta=" + $scope.total.ID_PREGUNTA + '&idUsuario=' + $scope.Usuario.Id + '&idTablero=' + $scope.total.IDTABLERO;
        getDatos();
        function getDatos() {
            $scope.cargoDatos = false;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.consolidados = datos.datos;
                if ($scope.consolidados.length == 0) {
                    $scope.mensaje = "No se encontraron necesidades ni compromisos establecidos para esta pregunta indicativa";
                }
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
            $scope.cargoDatos = true;
        }
        $scope.submitted = false;
    };

    $scope.errors = [];
    $scope.init();

    $scope.guardar = function () {
        if (!$scope.validar()) return false;
        $scope.habilita = true;
        angular.forEach($scope.consolidados, function (item) {
            if (item.ID == null) {
                item.ID = 0;
            }
            item.ID = item.Id;
            item.IDTABLERO = item.ID_TABLERO;
            item.IDPREGUNTA = item.ID_PREGUNTA;
            item.RESPUESTACOMPROMISO = item.RESPUESTA_COMPROMISO;
            item.OBSERVACIONCOMPROMISO = item.ObservacionCompromiso;
            item.IDMUNICIPIORESPUESTA = item.ID_MUNICIPIO_RESPUESTA;
            item.IDUSUARIO = $scope.Usuario.Id;

            var url = "/api/TableroPat/ModificarRespuestaDepartamento";

            //// Cargar los datos de auditoría
            item.AudUserName = authService.authentication.userName;
            item.AddIdent = authService.authentication.isAddIdent;
            item.UserNameAddIdent = authService.authentication.userNameAddIdent;

            var servCall = APIService.saveSubscriber(item, url);
            servCall.then(function (response) {
                response.data.total = { ID: item.ID };
                $uibModalInstance.close(response.data);
            }, function (error) {
                $scope.flagVariable = false;
                $scope.errorgeneral = data;
            });
        });
    };
    $scope.cancelar = function () {
        $uibModalInstance.close();
    };
    $scope.validar = function () {
        return $scope.registroConsolidado.$valid;
    };

    //-------------Metodo para mostrar modal de planeacion departamentos de municipios    
    $scope.EditarConsolidadoMunicipios = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/DepartamentosMunicipiosPat.html',
            controller: 'DepartamentoConsolidadoEdicionCtrl',
            size: 'lg',
            resolve: {
                tablero: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.consolidados[index]), activo: $scope.activo, anoPlaneacion: $scope.anoPlaneacion };
                    return datos;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (datosResponse) {
                mostrarMensaje(datosResponse);
            }
        );
    }
    function mostrarMensaje(mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    var enviar = { msn: mensaje.respuesta, tipo: (mensaje.estado == 1 || mensaje.estado == 2) ? "alert alert-success" : "alert alert-warning" };
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
             function () {
                 $scope.init();
             }
           );
    }

}]);

app.controller('DepartamentoAPCtrl', ['$scope', 'APIService', '$http', 'tablero', '$uibModalInstance', 'authService', function ($scope, APIService, $http, tablero, $uibModalInstance, authService) {
    $scope.tablero = tablero.tablero;
    $scope.Usuario = tablero.Usuario;
    $scope.activo = tablero.activo;
    $scope.disabled = $scope.activo ? '' : 'disabled';
    $scope.habilita = false;
    $scope.accionesAgregadas = [];
    $scope.programasAgregados = [];
    $scope.init = function () {
        if ($scope.tablero.ID == null) {
            $scope.tablero.ID = 0;
        }
        var url = "/api/TableroPat/DatosConsolidadoAccionesProgramas/?pregunta=" + $scope.tablero.ID_PREGUNTA + '&id=' + $scope.tablero.ID + '&idUsuario=' + $scope.Usuario.Id + '&idTablero=' + $scope.tablero.IDTABLERO;
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                //$scope.programasOferta = datos.programasOferta;
                $scope.accionesAgregadas = datos.datosAcciones;
                $scope.programasAgregados = datos.datosProgramas;

                angular.forEach($scope.accionesAgregadas, function (accion) {
                    accion.ACTIVO = true;
                });

                angular.forEach($scope.programasAgregados, function (accion) {
                    accion.ACTIVO = true;
                });
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.submitted = false;
    };

    $scope.errors = [];

    $scope.init();

    $scope.agregarAccion = function () {
        $scope.errors.ACCION = '';
        if ($scope.tablero.ACCION) {
            if ($scope.tablero.ACCION.length > 500) {
                $scope.errors.ACCION = "La acción no debe exceder los 500 caracteres";
                return;
            }
            var accionExistente = false;
            angular.forEach($scope.accionesAgregadas, function (accion) {
                if (accion.ACCION == $scope.tablero.ACCION) {
                    accionExistente = true;
                    if (accion.ACTIVO == false) {
                        accion.ACTIVO = true;
                    }
                }
            });
            if (!accionExistente) {
                $scope.accionesAgregadas.push({ ACCION: $scope.tablero.ACCION, ACTIVO: true });
            }
            $scope.tablero.ACCION = null;
            $("#accion").focus();
        } else {
            $scope.errors.ACCION = "La acción es requerida";
        }
    }

    $scope.borrarAccion = function (index) {
        $scope.accionesAgregadas[index].ACTIVO = false;
    }

    $scope.agregarProgramaOferta = function (index) {
        var programaOferta = $scope.programasOferta[index].PROGRAMA;
        var programaExistente = false;
        angular.forEach($scope.programasAgregados, function (programa) {
            if (programa.PROGRAMA == programaOferta) {
                programaExistente = true;
                if (programa.ACTIVO == false) {
                    programa.ACTIVO = true;
                }
            }
        });
        if (!programaExistente) {
            $scope.programasAgregados.push({ PROGRAMA: programaOferta, ACTIVO: true });
        }
        programaOferta = null;
    }

    $scope.agregarPrograma = function () {
        $scope.errors.PROGRAMA = '';
        if ($scope.tablero.PROGRAMA) {
            if ($scope.tablero.PROGRAMA.length > 1000) {
                $scope.errors.PROGRAMA = "El programa no debe exceder los 1000 caracteres";
                return;
            }
            var programaExistente = false;
            angular.forEach($scope.programasAgregados, function (programa) {
                if (programa.PROGRAMA == $scope.tablero.PROGRAMA) {
                    programaExistente = true;
                    if (programa.ACTIVO == false) {
                        programa.ACTIVO = true;
                    }
                }
            });
            if (!programaExistente) {
                $scope.programasAgregados.push({ PROGRAMA: $scope.tablero.PROGRAMA, ACTIVO: true });
            }
            $scope.tablero.PROGRAMA = null;
            $("#programa").focus();
        } else {
            $scope.errors.PROGRAMA = "El programa es requerido";
        }
    }

    $scope.borrarPrograma = function (index) {
        $scope.programasAgregados[index].ACTIVO = false;
    }

    $scope.guardar = function () {
        if (!$scope.validar()) return false;
        if ($scope.tablero.ACCION) {
            $scope.errors.ACCION = "Tiene acciones pendientes por agregar";
            return false;
        }
        if ($scope.tablero.PROGRAMA) {
            $scope.errors.PROGRAMA = "Tiene programas pendientes por agregar";
            return false;
        }

        var programaExistente = false;
        angular.forEach($scope.programasAgregados, function (programa) {
            if (programa.ACTIVO == true) {
                programaExistente = true;
            }
        })
        if (programaExistente == false) {
            $scope.advertenciageneral = "Se debe registrar al menos un Programa"; return false;
        }

        $scope.habilita = true;
        $scope.tablero.NECESIDADIDENTIFICADA = $scope.totalNecesidades;
        $scope.tablero.RespuestaPatAccion = $scope.accionesAgregadas;
        $scope.tablero.RespuestaPatPrograma = $scope.programasAgregados;
        $scope.tablero.IDUSUARIO = $scope.Usuario.Id;
        $scope.tablero.IDPREGUNTA = $scope.tablero.ID_PREGUNTA;

        if ($scope.tablero.ID == null) {
            $scope.tablero.ID = 0
        }

        var url = "/api/TableroPat/ModificarDepartamento";

        //// Cargar los datos de auditoría
        $scope.tablero.AudUserName = authService.authentication.userName;
        $scope.tablero.AddIdent = authService.authentication.isAddIdent;
        $scope.tablero.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.tablero, url);
        servCall.then(function (response) {
            $scope.flagVariable = false;
            response.data.ID = $scope.tablero.ID;
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.data.ExceptionMessage;
        });
    };

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.validar = function () {
        return $scope.registerAP.$valid;
    };

    $scope.BorraMensaje = function () { // $scope que acciona el ng-kepress
        $scope.errors.DESCRIPCION = '';
    };
}]);

app.controller('DepartamentoRCCtrl', ['$scope', 'APIService', '$http', '$uibModalInstance', 'tablero', 'authService', function ($scope, APIService, $http, $uibModalInstance, tablero, authService) {
    $scope.preguntaRC = tablero.tablero || { Id: 0 };
    $scope.Usuario = tablero.Usuario;
    $scope.activo = tablero.activo;
    $scope.flagVariable = false;
    $scope.disabled = $scope.activo ? '' : 'disabled';
    $scope.preguntaRC.IdUsuario = $scope.Usuario.Id;
    $scope.habilita = false;
    $scope.errors = [];
    $scope.submitted = false;

    $scope.guardar = function () {
        if (!$scope.validar()) return false;
        $scope.habilita = true;
        $scope.flagVariable = true;
        if ($scope.preguntaRC.Id == null) {
            $scope.preguntaRC.Id = 0
        }

        var url = "/api/TableroPat/ModificarRespuestaDepartamentoRC/";

        //// Cargar los datos de auditoría
        $scope.preguntaRC.AudUserName = authService.authentication.userName;
        $scope.preguntaRC.AddIdent = authService.authentication.isAddIdent;
        $scope.preguntaRC.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.preguntaRC, url);
        servCall.then(function (response) {
            $scope.flagVariable = false;
            response.data.ID = $scope.preguntaRC.ID;
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.data.ExceptionMessage;
        });
    };

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.validar = function () {
        return $scope.registerForm.$valid;
    };
}]);

app.controller('DepartamentoRRCtrl', ['$scope', 'APIService', '$http', 'tablero', '$uibModalInstance', 'authService', function ($scope, APIService, $http, tablero, $uibModalInstance, authService) {
    $scope.preguntaRR = tablero.tablero || { IdRespuestaDepartamento: 0 };
    $scope.Usuario = tablero.Usuario;
    $scope.activo = tablero.activo;
    $scope.flagVariable = false;
    $scope.disabled = $scope.activo ? '' : 'disabled';
    $scope.preguntaRR.IdUsuario = $scope.Usuario.Id;
    $scope.preguntaRR.IdMunicipioRespuesta = $scope.preguntaRR.IdMunicipio;
    $scope.habilita = false;
    $scope.errors = [];
    $scope.submitted = false;

    $scope.guardar = function () {
        if (!$scope.validar()) return false;
        $scope.habilita = true;
        $scope.flagVariable = true;
        if ($scope.preguntaRR.IdRespuestaDepartamento == null) {
            $scope.preguntaRR.IdRespuestaDepartamento = 0
        }

        var url = "/api/TableroPat/ModificarRespuestaDepartamentoRR";

        //// Cargar los datos de auditoría
        $scope.preguntaRR.AudUserName = authService.authentication.userName;
        $scope.preguntaRR.AddIdent = authService.authentication.isAddIdent;
        $scope.preguntaRR.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.preguntaRR, url);
        servCall.then(function (response) {
            $scope.flagVariable = false;
            response.data.IdRespuestaDepartamento = $scope.preguntaRR.ID;
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.data.ExceptionMessage;
        });

    };

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.validar = function () {
        return $scope.registerForm.$valid;
    };
}]);

app.controller('DepartamentoConsolidadoEdicionCtrl', ['$scope', 'APIService', '$http', 'tablero', '$uibModal', '$uibModalInstance', '$filter', '$log', 'authService', 'ngSettings', 'Upload', 'UtilsService', function ($scope, APIService, $http, tablero, $uibModal, $uibModalInstance, $filter, $log, authService, ngSettings, Upload, UtilsService) {
    $scope.tablero = tablero.tablero;
    $scope.Usuario = tablero.Usuario;
    $scope.activo = tablero.activo;
    $scope.anoPlaneacion = tablero.anoPlaneacion;
    $scope.accionesAgregadas = [];
    $scope.programasAgregados = [];
    $scope.flagVariable = false;
    $scope.disabled = $scope.activo ? '' : 'disabled';
    $scope.habilita = false;
    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.accionesAgregadas = [];
    $scope.programasAgregados = [];
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.init = function () {
        var url = "/api/TableroPat/DatosInicialesRespuestaConsolidadoAccionesProgramas?pregunta=" + $scope.tablero.ID_PREGUNTA + "&id=" + $scope.tablero.Id + '&IdUsuario=' + $scope.Usuario.Id + "&Usuario=" + $scope.Usuario.UserName + '&idTablero=' + $scope.tablero.ID_TABLERO;
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.accionesAgregadas = datos.datosAcciones;
                $scope.programasAgregados = datos.datosProgramas;
                var esta = false;
                angular.forEach($scope.accionesAgregadas, function (accion) {
                    accion.ACTIVO = true;
                });
                angular.forEach($scope.programasAgregados, function (accion) {
                    accion.ACTIVO = true;
                });
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.submitted = false;
    };
    $scope.errors = [];
    $scope.init();
    //Metodos para acciones
    $scope.agregarAccion = function () {
        $scope.errors.ACCION = '';
        if ($scope.tablero.ACCION) {
            if ($scope.tablero.ACCION.length > 500) {
                $scope.errors.ACCION = "La acción no debe exceder los 500 caracteres";
                return;
            }
            var accionExistente = false;
            angular.forEach($scope.accionesAgregadas, function (accion) {
                if (accion.ACCION == $scope.tablero.ACCION) {
                    accionExistente = true;
                    if (accion.ACTIVO == false) {
                        accion.ACTIVO = true;
                    }
                }
            });
            if (!accionExistente) {
                $scope.accionesAgregadas.push({ ACCION: $scope.tablero.ACCION, ACTIVO: true });
            }
            $scope.tablero.ACCION = null;
            $("#accion").focus();
        } else {
            $scope.errors.ACCION = "La acción es requerida";
        }
    }
    $scope.borrarAccion = function (index) {
        $scope.accionesAgregadas[index].ACTIVO = false;
    }
    //Metodos para los programas
    $scope.agregarProgramaOferta = function (index) {
        var programaOferta = $scope.programasOferta[index].PROGRAMA;
        var programaExistente = false;
        angular.forEach($scope.programasAgregados, function (programa) {
            if (programa.PROGRAMA == programaOferta) {
                programaExistente = true;
                if (programa.ACTIVO == false) {
                    programa.ACTIVO = true;
                }
            }
        });
        if (!programaExistente) {
            $scope.programasAgregados.push({ PROGRAMA: programaOferta, ACTIVO: true });
        }
        programaOferta = null;
    }
    $scope.agregarPrograma = function () {
        $scope.errors.PROGRAMA = '';
        if ($scope.tablero.PROGRAMA) {
            if ($scope.tablero.PROGRAMA.length > 1000) {
                $scope.errors.PROGRAMA = "El programa no debe exceder los 1000 caracteres";
                return;
            }
            var programaExistente = false;
            angular.forEach($scope.programasAgregados, function (programa) {
                if (programa.PROGRAMA == $scope.tablero.PROGRAMA) {
                    programaExistente = true;
                    if (programa.ACTIVO == false) {
                        programa.ACTIVO = true;
                    }
                }
            });
            if (!programaExistente) {
                $scope.programasAgregados.push({ PROGRAMA: $scope.tablero.PROGRAMA, ACTIVO: true });
            }
            $scope.tablero.PROGRAMA = null;
            $("#programa").focus();
        } else {
            $scope.errors.PROGRAMA = "El programa es requerido";
        }
    }
    $scope.borrarPrograma = function (index) {
        $scope.programasAgregados[index].ACTIVO = false;
    }
    //Metodos de guardado
    $scope.guardar = function () {
        $scope.submitted = true;
        $scope.errors = [];
        if (!$scope.validar()) return false;
        if ($scope.tablero.ACCION) {
            $scope.errors.ACCION = "Tiene acciones pendientes por agregar";
            return false;
        }
        if ($scope.tablero.PROGRAMA) {
            $scope.errors.PROGRAMA = "Tiene programas pendientes por agregar";
            return false;
        }
        $scope.habilita = true;
        $scope.flagVariable = true;
        $scope.tablero.RespuestaPatAccion = $scope.accionesAgregadas;
        $scope.tablero.RespuestaPatPrograma = $scope.programasAgregados;
        if ($scope.tablero.ID == null) {
            $scope.tablero.ID = 0;
        }
        $scope.tablero.ID = $scope.tablero.Id;
        $scope.tablero.IDTABLERO = $scope.tablero.ID_TABLERO;
        $scope.tablero.IDPREGUNTA = $scope.tablero.ID_PREGUNTA;
        $scope.tablero.RESPUESTACOMPROMISO = $scope.tablero.RESPUESTA_COMPROMISO;
        $scope.tablero.OBSERVACIONCOMPROMISO = $scope.tablero.ObservacionCompromiso;
        $scope.tablero.IDMUNICIPIORESPUESTA = $scope.tablero.ID_MUNICIPIO_RESPUESTA;
        $scope.tablero.IDUSUARIO = $scope.Usuario.Id;

        var url = "/api/TableroPat/ModificarRespuestaDepartamento";

        //// Cargar los datos de auditoría
        $scope.tablero.AudUserName = authService.authentication.userName;
        $scope.tablero.AddIdent = authService.authentication.isAddIdent;
        $scope.tablero.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.tablero, url);
        servCall.then(function (response) {
            $scope.flagVariable = false;
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = data;
        });
    };
    $scope.cancelar = function () {
        if ($scope.activo) { 
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmarSalirPagina.html',
            controller: 'ModalConfirmacionSalirPaginaController',
            resolve: {
                datos: function () {
                    var enviar = { msn: "¿Desea salir sin guardar cambios?",titulo:"Confirmación", tipo: "alert alert-warning" };
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });        
        modalInstance.result.then(
                 function (datosResponse) {
                     if (datosResponse) { $uibModalInstance.dismiss('cancel'); }

                 }
             );
        } else {
            $uibModalInstance.close();
        }

    };
    $scope.validar = function () {
        return $scope.registerForm.$valid;
    };
}]);