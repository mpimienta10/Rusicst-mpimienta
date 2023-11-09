app.controller('SeguimientoDepartamentoController', ['$scope', 'APIService', 'UtilsService', '$location', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', 'ngSettings', 'Upload', 'enviarDatos', function ($scope, APIService, UtilsService, $location, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService, ngSettings, Upload, enviarDatos) {
    $scope.idTablero = enviarDatos.datos.Id;
    if (!enviarDatos.datos.Id) {
        $location.url('/Index/TableroPat/TablerosSeguimientoDepartamento');
    }
    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.cargoDatosConsolidadoMunicipal = true;
    $scope.cargoDatosRC = true;
    $scope.cargoDatosRR = true;
    $scope.cargoDatosOD = true;
    $scope.model = { idMunicipioRC: 0, idMunicipioRR: 0 };
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
            $scope.disabled = $scope.activo ? '' : 'disabled';
            $scope.ActivoEnvioPATSeguimiento = false;
        }
    }
    $scope.busqueda;
    $scope.derecho = [];
    $scope.derechos = [];
    $scope.tableros = [];
    $scope.vigencias = [];
    $scope.entidades = [];
    $scope.model = {
        idMunicipioRC: 0,
        idMunicipioRR: 0,
        busqueda: ""
    };
    $scope.tablerosC = [];
    $scope.tablerosRC = [];
    $scope.tablerosRR = [];
    $scope.tablerosOD = [];

    $scope.maxSize = 15;
    $scope.maxSizeRR = 15;
    $scope.cantidadMostrar = 15;
    $scope.bigTotalItems = 0;
    $scope.bigTotalItemsRC = 0;
    $scope.bigTotalItemsRR = 0;
    $scope.bigCurrentPage = 1;
    $scope.bigCurrentPageRR = 1;
    $scope.flagVariable = false;
    $scope.activo = false;
    $scope.canFill = "";
    $scope.userPat = "";

    $scope.sortOrder = "";
    $scope.tipoSortOrder = "ASC";

    $scope.idUsuario;
    $scope.busqueda = '0';
    $scope.nombreDerecho = "Derecho";

    $scope.busquedaRC = '0';
    $scope.busquedaRR = '0';

    $scope.municipiosRC = [];
    $scope.municipiosRR = [];

    //$scope.mensajeSinDatos = "No se encontraron preguntas asociadas a los derechos del tablero";
    //$scope.mensajeSinDatosCM = "No se encontraron preguntas asociadas a " + $scope.model.busqueda + " para el consolidado municipal";
    //$scope.mensajeSinDatosRC = "No se encontraron preguntas asociadas a para Reparación Colectiva  para el municipio seleccionado";
    //$scope.mensajeSinDatosRR = "No se encontraron preguntas asociadas para Retornos y Reubicaciones para el municipio seleccionado";

    $scope.tablero;

    $scope.showWait = function () {
        $('#pleaseWaitDialog').modal();
    };
    $scope.closeWait = function () {
        $('#pleaseWaitDialog').modal('hide');
    };

    $scope.pageChanged = function (opcion) {
        if (opcion) {
            $scope.sortOrder = opcion + ' ' + $scope.tipoSortOrder;
            $scope.tipoSortOrder = $scope.tipoSortOrder == 'ASC' ? 'DESC' : 'ASC';
        }
        $scope.showData();
    };

    $scope.init = function () {
        $scope.showData();
    };
    $scope.showData = function () {
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.showWait();
        url = '/api/TableroPat/CargarTableroSeguimientoDepartamental/null,' + $scope.bigCurrentPage + ',' + $scope.cantidadMostrar + ',0,' + $scope.userName + ',' + $scope.idTablero;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.active = 0;
            $scope.cargoDatos = true;
            $scope.activo = datos.activo;
            $scope.disabled = $scope.activo ? '' : 'disabled';
            $scope.esConsulta = $scope.activo ? false : true;
            $scope.avance = datos.avance;
            $scope.tableros = datos.tablero;
            $scope.derechos = datos.derechos;
            $scope.vigencias = datos.vigencia;
            $scope.tablero = datos.idTablero;
            $scope.bigTotalItems = datos.totalItems;
            $scope.numPages = datos.TotalPages;
            $scope.bigTotalItemsRC = datos.totalItemsRC;
            $scope.numPagesRC = datos.TotalPagesRC;
            $scope.numPagesRR = datos.TotalPagesRR;
            $scope.bigTotalItemsRR = datos.totalItemsRR;
            $scope.Usuario = datos.datosUsuario[0];
            $scope.anoSeguimiento = datos.vigencia[0].Ano;
            $scope.tablerosOD = datos.datosOD;
            $scope.numSeguimiento = datos.numSeguimiento;
            $scope.ActivoEnvioPATSeguimiento = datos.ActivoEnvioPATSeguimiento;
            actualizarPie();
            $scope.ValidarConsulta();
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
        $scope.closeWait();
    };

    var actualizarPie = function () {

        angular.forEach($scope.avance, function (der) {
            der.dataPresupuesto = [der.AvancePresupuesto, 100 - der.AvancePresupuesto];
            der.dataCompromiso = [der.AvanceCompromiso, 100 - der.AvanceCompromiso];
            der.labelN = ["Presupuesto"];
            der.labelC = ["Compromiso"];
        });
        $scope.labels = ["Dilig %", "Pend %"];
        $scope.options = {
            legend: {
                fullWidth: true,
                display: true,
                labels: {
                    fontColor: 'black',
                    fontSize: 11
                }
            }
        };
        $scope.colores = ['#5cb85c', '#d9534f'];
    }
    $scope.buscarDatosDepartamentalesPorDerecho = function () {
        buscarDatosDepartamentalesPorDerecho();
    }
    function buscarDatosDepartamentalesPorDerecho() {
        $scope.active2 = 2;
        $scope.error = null;
        $scope.cargoDatosConsolidadoMunicipal = null;
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.datosTotales = [];
        $scope.municipiosRR = [];
        $scope.municipiosRC = [];
        $scope.showWait();
        var url = "";
        var idbusqueda = 0;
        var busq = $("#busqueda").val();
        angular.forEach($scope.derechos, function (der) {
            if (der.DESCRIPCION == busq) {
                idbusqueda = der.ID;
                $scope.IdDerecho = idbusqueda;
            }
        });

        getDatos();
        function getDatos() {
            url = '/api/TableroPat/CargarTableroSeguimientoConsolidado/null,' + $scope.bigCurrentPage + ',' + $scope.cantidadMostrar + ',' + idbusqueda + ',' + $scope.userName + ',' + $scope.idTablero;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatosConsolidadoMunicipal = true;
                $scope.tablerosC = datos.datos;
                $scope.municipiosRC.push({ Id: 0, Municipio: "--Seleccione--" });
                $scope.municipiosRR.push({ Id: 0, Municipio: "--Seleccione--" });
                angular.forEach(datos.datosMunicipioRC, function (dato) {
                    $scope.municipiosRC.push(dato);
                });
                angular.forEach(datos.datosMunicipioRR, function (dato) {
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
                $scope.nombreDerecho = datos.nombreDerecho;
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.closeWait();
    }
    $scope.generaExcel = function (index) {
        url = $scope.serviceBase + '/api/TableroPat/Departamentos/DatosExcelSeguimientoDepartamental?idDepartamento=' + $scope.Usuario.IdDepartamento + '&usuario=' + $scope.userName + '&idTablero=' + $scope.idTablero;
        window.open(url)

    }
    $scope.buscarDatosRC = function () {
        buscarDatosRC();
    }
    function buscarDatosRC() {
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.showWait();
        $scope.error = null;
        $scope.tablerosRC = [];
        if ($scope.dataRC.selectedOption.Id > 0) {
            $scope.cargoDatosRC = null;
            $scope.mensajeOK = null;
            $scope.mensajeWarning = null;
            $scope.tablerosRC = [];
            $scope.showWait();
            getDatos();
        }
        function getDatos() {
            var url = '/api/TableroPat/GetTableroSeguimientoDepartamentoRC/?idTablero=' + $scope.idTablero + '&idMunicipio=' + $scope.dataRC.selectedOption.Id;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatosRC = true;
                $scope.tablerosRC = datos;
            }, function (error) {
                $scope.cargoDatosRC = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.closeWait();
    };

    $scope.buscarDatosRC = function () {
        buscarDatosRC();
    }
    function buscarDatosRR() {
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.showWait();
        $scope.error = null;
        $scope.tablerosRR = [];
        if ($scope.dataRR.selectedOption.Id > 0) {
            $scope.cargoDatosRR = null;
            $scope.mensajeOK = null;
            $scope.mensajeWarning = null;
            $scope.tablerosRR = [];
            $scope.showWait();
            getDatos();
        }
        function getDatos() {
            var url = '/api/TableroPat/GetTableroSeguimientoDepartamentoRR/?idTablero=' + $scope.idTablero + '&idMunicipio=' + $scope.dataRR.selectedOption.Id;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatosRR = true;
                $scope.tablerosRR = datos;
            }, function (error) {
                $scope.cargoDatosRR = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.closeWait();
    };

    $scope.buscarDatosRR = function () {
        buscarDatosRR();
    }

    $scope.showDataRR = function () {
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.showWait();
        $scope.error = null;
        $scope.tablerosRR = [];
        if ($scope.dataRR.selectedOption.Id > 0) {
            $scope.cargoDatosRR = null;
            $scope.mensajeOK = null;
            $scope.mensajeWarning = null;
            $scope.tablerosRR = [];
            $scope.showWait();
            getDatos();
        }
        function getDatos() {
            var url = '/api/TableroPat/GetTableroSeguimientoDepartamentoRR/?idTablero=' + $scope.idTablero + '&idMunicipio=' + $scope.dataRR.selectedOption.Id;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatosRR = true;
                $scope.tablerosRR = datos;
            }, function (error) {
                $scope.cargoDatosRR = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.closeWait();
    };
    $scope.showDataOD = function () {
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.showWait();
        $scope.error = null;
        $scope.tablerosOD = [];
        $scope.cargoDatosOD = false;
        getDatos();
        function getDatos() {
            var url = '/api/TableroPat/GetTableroSeguimientoDepartamentoOtrosDerechos/?idTablero=' + $scope.idTablero + '&idUsuario=' + $scope.Usuario.Id;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.cargoDatosOD = true;
                $scope.tablerosOD = datos;
            }, function (error) {
                $scope.cargoDatosOD = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.closeWait();
    };


    $scope.init();
    $scope.started = true;
    $scope.Editar = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/SeguimientoDepartamentosPat.html',
            controller: 'SeguimientoDepartamentoEdicionCtrl',
            size: 'lg',
            resolve: {
                tablero: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.tableros[index]), activo: $scope.activo, numSeguimiento: $scope.numSeguimiento, idTablero: $scope.idTablero, serviceBase: $scope.serviceBase, anoSeguimiento: $scope.anoSeguimiento };
                    return datos;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (datosResponse) {
                if (datosResponse.estado > 0) {
                    mostrarMensaje("El tablero se actualizó correctamente");
                }
                else {
                    mostrarMensaje("No se procesó la Pregunta correctamente. " + datosResponse.respuesta);
                }
            }
        );
    }
    $scope.EditarConsolidado = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/SeguimientoDetalleConsolidadoPat.html',
            controller: 'SeguimientoDepartamentoEdicionConsolidadoCtrl',
            size: 'lg',
            resolve: {
                tableroC: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.tablerosC[index]), activo: $scope.activo, numSeguimiento: $scope.numSeguimiento, idTablero: $scope.idTablero, serviceBase: $scope.serviceBase, anoSeguimiento: $scope.anoSeguimiento };
                    return datos;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
                $scope.buscarDatosDepartamentalesPorDerecho();
            }
        );
    }

    $scope.EditarRC = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/SeguimientoDepartamentosRC.html',
            controller: 'SeguimientoDepartamentoEdicionRCCtrl',
            size: 'lg',
            resolve: {
                tableroRC: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.tablerosRC[index]), activo: $scope.activo, numSeguimiento: $scope.numSeguimiento, idTablero: $scope.idTablero, serviceBase: $scope.serviceBase, anoSeguimiento: $scope.anoSeguimiento };
                    return datos;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (datosResponse) {
                if (datosResponse.estado == 1 || datosResponse.estado == 2) {
                    mostrarMensajeRCyRR("El tablero se actualizó correctamente");
                }
                else {
                    mostrarMensajeRCyRR("No se procesó la Pregunta correctamente. " + datosResponse.respuesta);
                }
            }
        );
    }

    $scope.EditarRR = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/SeguimientoDepartamentosRR.html',
            controller: 'SeguimientoDepartamentoEdicionRRCtrl',
            size: 'lg',
            resolve: {
                tableroRR: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.tablerosRR[index]), activo: $scope.activo, numSeguimiento: $scope.numSeguimiento, idTablero: $scope.idTablero, serviceBase: $scope.serviceBase };
                    return datos;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (datosResponse) {
                if (datosResponse.estado == 1 || datosResponse.estado == 2) {
                    mostrarMensaje("El tablero se actualizó correctamente");
                }
                else {
                    mostrarMensaje("No se procesó la Pregunta correctamente. " + datosResponse.respuesta);
                }
            }
        );
    }

    $scope.agregarOD = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/SeguimientoDepartamentosAgregarOD.html',
            controller: 'SeguimientoDepartamentoAgregarODCtrl',
            size: 'lg',
            resolve: {
                datos: function () {
                    var datos = { Usuario: $scope.Usuario, activo: $scope.activo, numSeguimiento: $scope.numSeguimiento, idTablero: $scope.idTablero, serviceBase: $scope.serviceBase, anoSeguimiento: $scope.anoSeguimiento };
                    return datos;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (datosResponse) {
                $scope.mensajeWarning = null;
                $scope.mensajeOK = null;
                if (datosResponse.estado == 1 || datosResponse.estado == 2) {
                    mostrarMensajeOD("El tablero se actualizó correctamente");
                }
                else {
                    mostrarMensajeOD("No se procesó la Pregunta correctamente. " + datosResponse.respuesta);
                }
            }
        );
    }

    $scope.eliminarOD = function (index) {
        var SeguimientoMedidas = $scope.tablerosOD[index];
        //// Cargar los datos de auditoría
        SeguimientoMedidas.AudUserName = authService.authentication.userName;
        SeguimientoMedidas.AddIdent = authService.authentication.isAddIdent;
        SeguimientoMedidas.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var modalInstance = $uibModal.open({
            templateUrl: '/app/views/modals/Confirmacion.html',
            controller: 'ModalConfirmacionController',
            backdrop: 'static', keyboard: false,
            resolve: {
                datos: function () {
                    $scope.disabledguardando = 'disabled';
                    var titulo = 'Eliminar otros derechos';
                    var url = '/api/TableroPat/EliminarMedidaDepartamentoOD';
                    var entity = SeguimientoMedidas;
                    var msn = "¿Está seguro de eliminar la medida seleccionada? (Tenga en cuenta que si es la única medida del derecho agregado, se eliminará también el derecho)";
                    return { url: url, entity: entity, msn: msn, titulo: titulo }
                }
            }
        });
        modalInstance.result.then(
            function (datosResponse) {
                if (datosResponse.estado) {
                    if (datosResponse.estado == 3) {
                        mostrarMensajeOD("El registro se eliminó correctamente");
                    }
                    else {
                        mostrarMensajeOD("No se eliminó correctamente el derecho. " + datosResponse.respuesta);
                    }
                }
            }
        );
    }

    $scope.EditarOD = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'editarOD.html',
            controller: 'SeguimientoDepartamentoEdicionODCtrl',
            size: 'lg',
            backdrop: 'static',
            keyboard: false,
            resolve: {
                tableroOD: function () {
                    return angular.copy($scope.tablerosOD[index]);
                }
            }
        });
        modalInstance.result.then(
            function (datosResponse) {
                $scope.mensajeWarning = null;
                $scope.mensajeOK = null;
                if (datosResponse.d.exito) {
                    $scope.init();
                    $scope.mensajeOK = "El tablero se actualizó correctamente";
                }
                else {
                    $scope.mensajeWarning = "No se procesó la Pregunta correctamente";
                }
            }
        );
    }

    $scope.descargar = function (index) {
        var url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.tablerosOD[index].NombreAdjunto + '&nombreArchivo=' + $scope.tablerosOD[index].NombreAdjunto + '&type=OD&idTablero=' + $scope.idTablero + '&idPregunta= ' + $scope.tablerosOD[index].IdSeguimiento + '&idUsuario=' + $scope.Usuario.Id;
        window.open(url)
    }
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
                 $scope.showData();
             }
           );
    }
    function mostrarMensajeOD(mensaje) {
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
                 $scope.showDataOD();
             }
           );
    }
    function mostrarMensajeRCyRR(mensaje) {
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
        modelo.tipoEnvio = "SD" + $scope.numSeguimiento;

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
                    var enviar = { msn: respuesta.respuesta, tipo: respuesta.estado == 1 ? "alert alert-success" : "alert alert-warning" };
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
}])

app.controller('SeguimientoDepartamentoEdicionCtrl', ['$scope', 'APIService', '$http', 'Upload', 'tablero', '$uibModal', '$uibModalInstance', '$filter', '$log', 'authService', 'UtilsService', function ($scope, APIService, $http, Upload, tablero, $uibModal, $uibModalInstance, $filter, $log, authService, UtilsService) {
    $scope.tablero = tablero.tablero;
    $scope.Usuario = tablero.Usuario;
    $scope.activo = tablero.activo;
    $scope.serviceBase = tablero.serviceBase;
    $scope.anoSeguimiento = tablero.anoSeguimiento;
    $scope.idTablero = tablero.idTablero;
    $scope.seguimiento = tablero.numSeguimiento;
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.habilita = false;
    $scope.programasAgregados1 = [];
    $scope.programasAgregados2 = [];
    $scope.programasAgregados = [];
    $scope.datosRespuesta;
    $scope.verListadoSigo = false;
    $scope.flagVariable = false;
    $scope.replaced1 = false;
    $scope.replaced2 = false;
    $scope.replaced3 = false;
    $scope.replaced4 = false;
    $scope.changed = false;
    $scope.mensajeErrorForm = "Existen errores en el formulario. Por favor verifique e intente de nuevo.";

    $scope.extensionesPermitidas = ['.docx', '.doc', '.xls', '.xlsx', '.ppt', '.pptx',  //De microsoft
    '.pdf', '.txt',                                                             //Varias
    '.bmp', '.jpg', '.gif', '.jpg', '.jpeg', '.tif', '.tiff', '.png',           //Imágenes
    '.zip', '.7z', '.rar'
    ];

    //========================VALIDAR ARCHIVO ADJUNTO===================================
    $scope.validarArchivo = function (file, numSeg) {
        var respuestaValidarArchivo = true;
        var indexUltimoPunto = file.name.lastIndexOf(".");
        if (indexUltimoPunto != -1) {
            var extension = file.name.slice(indexUltimoPunto);
            extension = extension.toLowerCase();
            if ($scope.extensionesPermitidas.indexOf(extension) === -1) {
                var mensaje = { msn: "La extensión '" + extension + "' no es permitida", tipo: "alert alert-danger" };
                respuestaValidarArchivo = false;
                quitarArchivoAdjunto();
                openRespuesta(mensaje);
            } else if (file.name.search(/[!*$#,´'`~+]/g) != -1) {
                var mensaje = { msn: "El nombre de archivo '" + file.name + "' contiene caracteres no permitidos (!*$#,´'`~+). Modifíquelo e intente nuevamente.", tipo: "alert alert-danger" };
                respuestaValidarArchivo = false;
                quitarArchivoAdjunto();
                openRespuesta(mensaje);
            }
        } else {
            var mensaje = { msn: "No existe ninguna extensión para el archivo", tipo: "alert alert-danger" };
            respuestaValidarArchivo = false;
            quitarArchivoAdjunto();
            openRespuesta(mensaje);
        }

        if (respuestaValidarArchivo) {
            if (file.size > 10000000) {
                quitarArchivoAdjunto();
                file = null;
                var mensaje = { msn: 'El tamaño del archivo no debe superar los 10 MB', tipo: "alert alert-danger" };
                openRespuesta(mensaje);
            }
        }

        function quitarArchivoAdjunto() {
            file = null;
        }

        return respuestaValidarArchivo;
    }

    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    return mensaje;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (resultado) {
            });
    };


    $scope.init = function () {
        if ($scope.tablero.ID == null) {
            $scope.tablero.ID = 0;
        }
        if (!$scope.seguimiento) { $scope.seguimiento = 0;}
        var url = '/api/TableroPat/DatosInicialesSeguimientoDepartamento?idPregunta=' + $scope.tablero.Id + '&IdUsuario=' + $scope.Usuario.Id + '&idTablero=' + $scope.idTablero + '&idDepartamento=' + $scope.Usuario.IdDepartamento + '&numSeguimiento=' + $scope.seguimiento;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.datosRespuesta = datos.datosRespuesta;
            $scope.totalNecesidades = datos.totalNecesidades;
            $scope.programasAgregados = datos.datosProgramas;
            $scope.programasSIGO = datos.programasSIGO;
            if ($scope.programasAgregados.length > 0) {
                angular.forEach($scope.programasAgregados, function (programa) {
                    if (programa.NumeroSeguimiento == 2) {
                        $scope.programasAgregados2.push({ PROGRAMA: programa.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: 2 });
                    } else {
                        if ($scope.datosRespuesta.IdSeguimiento == 0) {
                            // agrego los programas de SIGO al seguimiento 1
                            angular.forEach($scope.programasSIGO, function (programa) {
                                $scope.programasAgregados1.push({ PROGRAMA: programa.NombrePrograma, IdSeguimiento: 0, numeroSeguimiento: 1, EstaRelacionado: true, Tipo: programa.Tipo, NumeroPrograma: programa.NumeroPrograma });
                            });
                            //Por cada programa de planeacion se valida si esta en los de SIGO para que se vea la relacion y el detalle y se agrega al arreglo.Solo para el S1
                            angular.forEach($scope.programasAgregados, function (programa) {
                                var estaRealcionado = false;
                                angular.forEach($scope.programasSIGO, function (programaSIGO) {
                                    if (programa.ID == programaSIGO.IdRespuestaPrograma) {
                                        estaRealcionado = true;
                                    }
                                });
                                if (!estaRealcionado) {
                                    $scope.programasAgregados1.push({ PROGRAMA: programa.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: 1 });
                                }
                            });
                        } else {
                            //si ya tiene una respuesta se agrega al arreglo
                            $scope.programasAgregados1.push({ PROGRAMA: programa.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: 1 });
                            //se valida si este tenia relacion 
                        }
                    }
                });
                // inicio requerimiento unidad de victimas   
                //si es seguimiento 2 y no tiene programas guardados debe traer el precargue, en caso contrario debe mostar solo lo guardado
                if ($scope.seguimiento == 2 && $scope.programasAgregados2.length == 0) {
                    // agrego los programas de SIGO al seguimiento 2
                    angular.forEach($scope.programasSIGO, function (programa) {
                        $scope.programasAgregados2.push({ PROGRAMA: programa.NombrePrograma, IdSeguimiento: 0, numeroSeguimiento: 2, EstaRelacionado: true, Tipo: programa.Tipo, NumeroPrograma: programa.NumeroPrograma });
                    });
                    //Por cada programa de seguimiento 2 precargado se valida si esta en los de SIGO para que se vea la relacion y el detalle y se agrega al arreglo.Solo para el S1
                    angular.forEach($scope.programasAgregados, function (programa) {
                        var estaRealcionado = false;
                        angular.forEach($scope.programasSIGO, function (programaSIGO) {
                            if (programa.PROGRAMA == programaSIGO.NombrePrograma) {
                                estaRealcionado = true;
                            }
                        });
                        if (!estaRealcionado) {
                            $scope.programasAgregados2.push({ PROGRAMA: programa.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: 2 });
                        }
                    });
                }
                //fin requerimiento unidad de victimas
            } else {
                if ($scope.datosRespuesta.IdSeguimiento == 0) {
                    // agrego los programas de SIGO al seguimiento 1
                    angular.forEach($scope.programasSIGO, function (programa) {
                        $scope.programasAgregados1.push({ PROGRAMA: programa.NombrePrograma, IdSeguimiento: 0, numeroSeguimiento: 1, EstaRelacionado: true, Tipo: programa.Tipo, NumeroPrograma: programa.NumeroPrograma });
                    });
                }
            }

            if ($scope.programasAgregados2.length == 0 && $scope.seguimiento == 2) {
                angular.forEach($scope.programasAgregados1, function (programa) {
                    $scope.programasAgregados2.push({ PROGRAMA: programa.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: 2 });
                });
            }
            $scope.datosSegNacional = datos.datosSegNacional;
            if ($scope.datosRespuesta.IdSeguimiento == 0) {
                $scope.replaced1 = true;
                $scope.replaced2 = true;
                $scope.replaced3 = true;
                $scope.replaced4 = true;
                $scope.datosRespuesta.CompromisoPrimerSemestre = "";
                $scope.datosRespuesta.PresupuestoPrimerSemestre = "";
                $scope.datosRespuesta.CompromisoSegundoSemestre = "";
                $scope.datosRespuesta.PresupuestoSegundoSemestre = "";
                $scope.datosRespuesta.CompromisoTotal = 0;
                $scope.datosRespuesta.PresupuestoTotal = 0;
                if (!$scope.datosRespuesta.CompromisoDefinitivo || $scope.datosRespuesta.CompromisoDefinitivo == null) {
                    $scope.datosRespuesta.CompromisoDefinitivo = $scope.datosRespuesta.RespuestaCompromiso;
                }
                if (!$scope.datosRespuesta.PresupuestoDefinitivo || $scope.datosRespuesta.PresupuestoDefinitivo == null) {
                    $scope.datosRespuesta.PresupuestoDefinitivo = $scope.datosRespuesta.Presupuesto;
                }
            } else if ($scope.seguimiento == 1) {
                $scope.replaced3 = true;
                $scope.replaced4 = true;
                if (!$scope.datosRespuesta.CompromisoDefinitivo || $scope.datosRespuesta.CompromisoDefinitivo == null) {
                    $scope.datosRespuesta.CompromisoDefinitivo = $scope.datosRespuesta.RespuestaCompromiso;
                }
                if (!$scope.datosRespuesta.PresupuestoDefinitivo || $scope.datosRespuesta.PresupuestoDefinitivo == null) {
                    $scope.datosRespuesta.PresupuestoDefinitivo = $scope.datosRespuesta.Presupuesto;
                }

                $scope.datosRespuesta.CompromisoSegundoSemestre = 0;
                $scope.datosRespuesta.PresupuestoSegundoSemestre = 0;
            } else if ($scope.seguimiento == 2) {
                $scope.replaced3 = true;
                $scope.replaced4 = true;

                if ($scope.datosRespuesta.CompromisoPrimerSemestre == -1) {
                    $scope.replaced1 = true;
                    $scope.datosRespuesta.CompromisoPrimerSemestre = 0;
                } else if ($scope.datosRespuesta.PresupuestoPrimerSemestre == -1) {
                    $scope.replaced2 = true;
                    $scope.datosRespuesta.PresupuestoPrimerSemestre = 0;
                }
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
        $scope.submitted = false;
    };
    $scope.errors = [];

    $scope.init();

    $scope.sumTotalCantidad = function () {
        $scope.datosRespuesta.CompromisoTotal = $scope.datosRespuesta.CompromisoPrimerSemestre + ($scope.datosRespuesta.CompromisoSegundoSemestre > -1 ? $scope.datosRespuesta.CompromisoSegundoSemestre : 0);
        $scope.replaced1 = false;
    };
    $scope.sumTotalPresupuesto = function () {
        $scope.datosRespuesta.PresupuestoTotal = $scope.datosRespuesta.PresupuestoPrimerSemestre + ($scope.datosRespuesta.PresupuestoSegundoSemestre > -1 ? $scope.datosRespuesta.PresupuestoSegundoSemestre : 0);
        $scope.replaced2 = false;
    };
    $scope.sumTotalCantidad2 = function () {
        $scope.datosRespuesta.CompromisoTotal = $scope.datosRespuesta.CompromisoPrimerSemestre + $scope.datosRespuesta.CompromisoSegundoSemestre;
        $scope.replaced3 = false;
    };
    $scope.sumTotalPresupuesto2 = function () {
        $scope.datosRespuesta.PresupuestoTotal = $scope.datosRespuesta.PresupuestoPrimerSemestre + $scope.datosRespuesta.PresupuestoSegundoSemestre;
        $scope.replaced4 = false;
    };;

    $scope.restoreDefaultValues = function () {

        if ($scope.datosRespuesta.IdSeguimiento == 0 || $scope.seguimiento == 1) {
            $scope.datosRespuesta.COMPROMISO_SEGUNDO = -1;
            $scope.datosRespuesta.PRESUPUESTO_SEGUNDO = -1;
        }
    };


    $scope.agregarPrograma = function (semestre) {
        $scope.errors.PROGRAMA = '';
        $scope.errors.PROGRAMA2 = '';
        if (semestre == 1) {
            if ($scope.tablero.PROGRAMA) {
                if ($scope.tablero.PROGRAMA.length > 1000) {
                    $scope.errors.PROGRAMA = "El programa no debe exceder los 1000 caracteres";
                    return;
                }
                var programaExistente = false;
                angular.forEach($scope.programasAgregados1, function (programa) {
                    if (programa.Programa == $scope.tablero.PROGRAMA) {
                        programaExistente = true;
                    }
                });
                if (!programaExistente) {
                    $scope.programasAgregados1.push({ PROGRAMA: $scope.tablero.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: semestre });
                }
                $scope.tablero.PROGRAMA = null;
                $("#programa").focus();
            } else {
                $scope.errors.PROGRAMA = "El programa es requerido";
            }
        } else {
            if ($scope.tablero.PROGRAMA2) {
                if ($scope.tablero.PROGRAMA2.length > 1000) {
                    $scope.errors.PROGRAMA2 = "El programa no debe exceder los 1000 caracteres";
                    return;
                }
                var programaExistente = false;
                angular.forEach($scope.programasAgregados2, function (programa) {
                    if (programa.Programa == $scope.tablero.PROGRAMA2) {
                        programaExistente = true;
                    }
                });
                if (!programaExistente) {
                    $scope.programasAgregados2.push({ PROGRAMA: $scope.tablero.PROGRAMA2, IdSeguimiento: 0, numeroSeguimiento: semestre });
                }
                $scope.tablero.PROGRAMA2 = null;
                $("#programa2").focus();
            } else {
                $scope.errors.PROGRAMA2 = "El programa es requerido";
            }
        }

    }
    $scope.borrarPrograma = function (index) {
        $scope.programasAgregados1.splice(index, 1);
    }
    $scope.EditarPrograma = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/EdicionPrograma.html',
            controller: 'SeguimientoMunicipioEdicionProgramaCtrl',
            size: 'sm',
            resolve: {
                programa: function () {
                    return angular.copy($scope.programasAgregados1[index]);
                }
            }
        });
        modalInstance.result.then(
            function (datosResponse) {
                $scope.mensajeWarningEdit = null;
                $scope.mensajeOKEdit = null;
                if (datosResponse) {
                    $scope.programasAgregados1[index] = datosResponse;
                    $scope.mensajeOKEdit = "El Programa se actualizó correctamente";
                }
                else {
                    $scope.mensajeWarningEdit = "No se actualizó el Programa";
                }
            }
        );
    }

    $scope.borrarPrograma2 = function (index) {
        $scope.programasAgregados2.splice(index, 1);
    }
    $scope.EditarPrograma2 = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/EdicionPrograma.html',
            controller: 'SeguimientoMunicipioEdicionProgramaCtrl',
            size: 'sm',
            resolve: {
                programa: function () {
                    return angular.copy($scope.programasAgregados2[index]);
                }
            }
        });
        modalInstance.result.then(
            function (datosResponse) {
                $scope.mensajeWarningEdit = null;
                $scope.mensajeOKEdit = null;
                if (datosResponse) {
                    $scope.programasAgregados2[index] = datosResponse;
                    $scope.mensajeOKEdit = "El Programa se actualizó correctamente";
                }
                else {
                    $scope.mensajeWarningEdit = "No se actualizó el Programa";
                }
            }
        );
    }

    $scope.borrarAdjunto = function (semestre) {
        if (semestre == 1) {
            $scope.datosRespuesta.AdjuntoSeguimiento = "";
        } else {
            $scope.datosRespuesta.NombreAdjuntoSegundo = "";
        }
    }
    $scope.guardar = function () {
        $scope.submitted = true;
        $scope.extension = false;
        if (!$scope.validar()) return false;
        if (!$scope.validarExtension()) return false;
        $scope.habilita = true;
        $scope.flagVariable = true;
        $scope.mensajeErrorForm = "";

        $scope.seguimiento = {};
        $scope.seguimiento.IdSeguimiento = $scope.tablero.IdSeguimiento;
        $scope.seguimiento.IdPregunta = $scope.tablero.Id;
        $scope.seguimiento.IdUsuario = $scope.Usuario.Id;
        $scope.seguimiento.IdTablero = $scope.idTablero;
        $scope.seguimiento.CantidadPrimer = $scope.datosRespuesta.CompromisoPrimerSemestre;
        $scope.seguimiento.PresupuestoPrimer = $scope.datosRespuesta.PresupuestoPrimerSemestre;
        $scope.seguimiento.CantidadSegundo = $scope.datosRespuesta.CompromisoSegundoSemestre;
        $scope.seguimiento.PresupuestoSegundo = $scope.datosRespuesta.PresupuestoSegundoSemestre;
        $scope.seguimiento.Observaciones = $scope.datosRespuesta.ObservacionesSeguimiento;
        $scope.seguimiento.ObservacionesSegundo = $scope.datosRespuesta.ObservacionesSegundo;
        $scope.seguimiento.ObservacionesDefinitivo = $scope.datosRespuesta.ObservacionesDefinitivo;

        $scope.seguimiento.CompromisoDefinitivo = $scope.datosRespuesta.CompromisoDefinitivo;
        $scope.seguimiento.PresupuestoDefinitivo = $scope.datosRespuesta.PresupuestoDefinitivo;

        $scope.seguimiento.NombreAdjunto = (!$scope.datosRespuesta.AdjuntoSeguimiento) ? ($scope.file ? $scope.file.name : "") : $scope.datosRespuesta.AdjuntoSeguimiento;
        $scope.seguimiento.NombreAdjuntoSegundo = (!$scope.datosRespuesta.NombreAdjuntoSegundo) ? ($scope.file2 ? $scope.file2.name : "") : $scope.datosRespuesta.NombreAdjuntoSegundo;
        $scope.seguimiento.SeguimientoProgramas = [];
        angular.forEach($scope.programasAgregados1, function (pro) {
            $scope.seguimiento.SeguimientoProgramas.push({ PROGRAMA: pro.PROGRAMA, NumeroSeguimiento: 1 });
        });
        angular.forEach($scope.programasAgregados2, function (pro) {
            $scope.seguimiento.SeguimientoProgramas.push({ PROGRAMA: pro.PROGRAMA, NumeroSeguimiento: 2 });
        });

        //var url = "/api/TableroPat/RegistrarSeguimientoDepartamento";
        var url = "/api/TableroPat/RegistrarSeguimiento";


        //// Cargar los datos de auditoría
        $scope.seguimiento.AudUserName = authService.authentication.userName;
        $scope.seguimiento.AddIdent = authService.authentication.isAddIdent;
        $scope.seguimiento.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.seguimiento, url);
        servCall.then(function (response) {
            $scope.deshabiltarRegistrese = false;
            $scope.seguimiento.usuario = $scope.seguimiento.IdUsuario;
            $scope.seguimiento.tablero = $scope.seguimiento.IdTablero;
            $scope.seguimiento.pregunta = $scope.seguimiento.IdPregunta;
            $scope.flagVariable = false;
            if ($scope.file) { $scope.upload($scope.file, 1); }
            if ($scope.file2) { $scope.upload($scope.file2, 2); }
            $scope.restoreDefaultValues();
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.message;
        });
    };
    $scope.upload = function (file, semestre) {
        if (semestre == 1) {
            $scope.seguimiento.type = 'D';
        }
        if (semestre == 2) {
            $scope.seguimiento.type = 'D2';
        }
        Upload.upload({
            url: serviceBase + '/api/TableroPat/AdjutarArchivoSeguimiento',
            method: "POST",
            data: $scope.seguimiento,
            file: file,
        }).then(function (resultado) {
            $scope.deshabiltarRegistrese = false;
            $uibModalInstance.close(resultado.data);
        }, function (resultado) {
            $scope.deshabiltarRegistrese = false;
            var mensaje = { msn: 'Error: ' + resultado.data.ExceptionMessage, tipo: "alert alert-danger" };
        }, function (evt) {
            var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
        });
    };
    $scope.borrarAdjunto = function (semestre) {
        if (semestre == 1) {
            $scope.datosRespuesta.AdjuntoSeguimiento = "";
        } else {
            $scope.datosRespuesta.NombreAdjuntoSegundo = "";
        }
    }
    $scope.descargar = function (index, semestre) {
        var url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.datosRespuesta.AdjuntoSeguimiento + '&nombreArchivo=' + $scope.datosRespuesta.AdjuntoSeguimiento + '&type=D&idTablero=' + $scope.idTablero + '&idPregunta= ' + $scope.tablero.Id + '&idUsuario=' + $scope.Usuario.Id + '&NumSeguimiento=1';
        if (semestre == 2) {
            url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.datosRespuesta.NombreAdjuntoSegundo + '&nombreArchivo=' + $scope.datosRespuesta.NombreAdjuntoSegundo + '&type=D2&idTablero=' + $scope.idTablero + '&idPregunta= ' + $scope.tablero.Id + '&idUsuario=' + $scope.Usuario.Id + '&NumSeguimiento=2';
        }
        window.open(url)
    }
    $scope.cancelar = function () {
        $uibModalInstance.close();
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
            if ($scope.file2) {
                var filename = $scope.file2.name;
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
    }
    $scope.BorraMensaje = function () { // $scope que acciona el ng-kepress
        $scope.errors.DESCRIPCION = '';
    };

    $scope.VerDetallePrograma = function (index) {
        if ($scope.programasAgregados1[index].EstaRelacionado == true) {
            var tipo = $scope.programasAgregados1[index].Tipo;
            var numeroPrograma = $scope.programasAgregados1[index].NumeroPrograma;
            $scope.ProgramaDetalle = {};
            angular.forEach($scope.programasSIGO, function (programa) {
                if (programa.Tipo == tipo && programa.NumeroPrograma == numeroPrograma) {
                    $scope.ProgramaDetalle = programa;
                }
            });
        }


        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/DetalleProgramaSIGO.html',
            controller: 'SeguimientoDepartamentoDetalleProgramaSIGOCtrl',
            size: 'md',
            resolve: {
                programa: function () {
                    return angular.copy($scope.ProgramaDetalle);
                }
            }
        });
        modalInstance.result.then(
            function (datosResponse) {
            }
        );
    }

    $scope.VerDetalleProgramaTodo = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/DetalleProgramaSIGO.html',
            controller: 'SeguimientoDepartamentoDetalleProgramaSIGOCtrl',
            size: 'md',
            resolve: {
                programa: function () {
                    return angular.copy($scope.programasSIGO[index]);
                }
            }
        });
        modalInstance.result.then(
            function (datosResponse) {
            }
        );
    }
    
}])
//Modal para ver el detalle de los programas de SIGO
app.controller('SeguimientoDepartamentoDetalleProgramaSIGOCtrl', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModalInstance', 'authService', 'ngSettings', 'enviarDatos', 'programa', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModalInstance, authService, ngSettings, enviarDatos, programa) {
    $scope.programa = programa;
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
}])
//Modal detalle consolidado 
app.controller('SeguimientoDepartamentoEdicionConsolidadoCtrl', ['$scope', 'APIService', '$http', 'Upload', 'tableroC', '$uibModal', '$uibModalInstance', '$filter', '$log', function ($scope, APIService, $http, Upload, tableroC, $uibModal, $uibModalInstance, $filter, $log) {
    $scope.datos = tableroC.tablero;
    $scope.Usuario = tableroC.Usuario;
    $scope.activo = tableroC.activo;
    $scope.serviceBase = tableroC.serviceBase;
    $scope.anoSeguimiento = tableroC.anoSeguimiento;
    $scope.idTablero = tableroC.idTablero;
    $scope.numSeguimiento = tableroC.numSeguimiento;
    $scope.errors = [];
    $scope.datosRespuesta;
    $scope.habilita = false;
    $scope.init = function () {
        var url = '/api/TableroPat/DatosInicialesConsolidadoSeguimientoDepto?idPregunta=' + $scope.datos.IdPregunta + '&IdUsuario=' + $scope.Usuario.Id + '&idTablero=' + $scope.idTablero;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.datosRespuesta = datos.datosRespuesta;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
        $scope.submitted = false;
    };
    $scope.init();
    $scope.EditarDetalleConsolidado = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/SeguimientoEdicionConsolidadoPat.html',
            controller: 'SeguimientoDepartamentoEdicionDetalleConsolidadoCtrl',
            size: 'lg',
            resolve: {
                tableroDetalle: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.datosRespuesta[index]), activo: $scope.activo, numSeguimiento: $scope.numSeguimiento, idTablero: $scope.idTablero, serviceBase: $scope.serviceBase, anoSeguimiento: $scope.anoSeguimiento };
                    return datos;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (datosResponse) {
                if (datosResponse.estado == 1 || datosResponse.estado == 2) {
                    mostrarMensaje("El tablero se actualizó correctamente");
                }
                else {
                    mostrarMensaje("No se procesó la Pregunta correctamente. " + datosResponse.respuesta);
                }
            }
        );
    }
    $scope.guardar = function () {
        if (!$scope.validar()) return false;
        $scope.habilita = true;
        $uibModalInstance.close($scope.datos);
    };
    $scope.cancelar = function () {
        $uibModalInstance.close();
    };
    $scope.validar = function () {
        return $scope.editForm.$valid;
    };
    $scope.BorraMensaje = function () { // $scope que acciona el ng-kepress
        $scope.errors.PROGRAMAEDIT = '';
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
                 $scope.init();
             }
           );
    }
}])
//Modal edicion detalle consolidado
app.controller('SeguimientoDepartamentoEdicionDetalleConsolidadoCtrl', ['$scope', 'APIService', '$http', 'Upload', 'tableroDetalle', '$uibModal', '$uibModalInstance', '$filter', '$log', 'authService', 'UtilsService', function ($scope, APIService, $http, Upload, tableroDetalle, $uibModal, $uibModalInstance, $filter, $log, authService, UtilsService) {
    $scope.Usuario = tableroDetalle.Usuario;
    $scope.activo = tableroDetalle.activo;
    $scope.serviceBase = tableroDetalle.serviceBase;
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.anoSeguimiento = tableroDetalle.anoSeguimiento;
    $scope.idTablero = tableroDetalle.idTablero;
    $scope.seguimiento = tableroDetalle.numSeguimiento;
    $scope.tableroDetalle = tableroDetalle.tablero || { ID_PREGUNTA: 0 };
    $scope.habilita = false;
    $scope.programasAgregados1 = [];
    $scope.programasAgregados2 = [];
    $scope.programasAgregados = [];
    $scope.programasAgregadosAlcaldia1 = [];
    $scope.programasAgregadosAlcaldia2 = [];
    $scope.programasAgregadosAlcaldia = [];
    $scope.datosRespuesta;
    $scope.CompromisoTotal;
    $scope.PresupuestoTotal;
    $scope.ADJUNTO;
    $scope.errors = [];
    $scope.flagVariable = false;
    $scope.replaced1 = false;
    $scope.replaced2 = false;
    $scope.replaced3 = false;
    $scope.replaced4 = false;
    $scope.mensajeErrorForm = "Existen errores en el formulario. Por favor verifique e intente de nuevo.";

    $scope.extensionesPermitidas = ['.docx', '.doc', '.xls', '.xlsx', '.ppt', '.pptx',  //De microsoft
'.pdf', '.txt',                                                             //Varias
'.bmp', '.jpg', '.gif', '.jpg', '.jpeg', '.tif', '.tiff', '.png',           //Imágenes
'.zip', '.7z', '.rar'
    ];

    //========================VALIDAR ARCHIVO ADJUNTO===================================
    $scope.validarArchivo = function (file, numSeg) {
        var respuestaValidarArchivo = true;
        var indexUltimoPunto = file.name.lastIndexOf(".");
        if (indexUltimoPunto != -1) {
            var extension = file.name.slice(indexUltimoPunto);
            extension = extension.toLowerCase();
            if ($scope.extensionesPermitidas.indexOf(extension) === -1) {
                var mensaje = { msn: "La extensión '" + extension + "' no es permitida", tipo: "alert alert-danger" };
                respuestaValidarArchivo = false;
                quitarArchivoAdjunto();
                openRespuesta(mensaje);
            } else if (file.name.search(/[!*$#,´'`~+]/g) != -1) {
                var mensaje = { msn: "El nombre de archivo '" + file.name + "' contiene caracteres no permitidos (!*$#,´'`~+). Modifíquelo e intente nuevamente.", tipo: "alert alert-danger" };
                respuestaValidarArchivo = false;
                quitarArchivoAdjunto();
                openRespuesta(mensaje);
            }
        } else {
            var mensaje = { msn: "No existe ninguna extensión para el archivo", tipo: "alert alert-danger" };
            respuestaValidarArchivo = false;
            quitarArchivoAdjunto();
            openRespuesta(mensaje);
        }

        if (respuestaValidarArchivo) {
            if (file.size > 10000000) {
                quitarArchivoAdjunto();
                file = null;
                var mensaje = { msn: 'El tamaño del archivo no debe superar los 10 MB', tipo: "alert alert-danger" };
                openRespuesta(mensaje);
            }
        }

        function quitarArchivoAdjunto() {
            file = null;
        }

        return respuestaValidarArchivo;
    }

    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    return mensaje;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (resultado) {
            });
    };
    $scope.VerMas = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/SeguimientoMunicipiosPatAccYProg.html',
            controller: 'SeguimientoMunicipioConsolidadoVerAccYProCtrl',
            size: 'lg',
            backdrop: 'static',
            keyboard: false,
            resolve: {
                accProg: function () {
                    var datos = { accProg: angular.copy($scope.datosPrecargueNacional[index]) };
                    return datos;
                }
            }
        });
        modalInstance.result.then(
            function (datosResponse) {
                $scope.mensajeWarning = null;
                $scope.mensajeOK = null;
                if (datosResponse.estado == 1 || datosResponse.estado == 2) {
                    $scope.init();
                    mostrarMensaje("El tablero se actualizó correctamente");
                }
                else {
                    mostrarMensaje("No se procesó la Pregunta correctamente. " + datosResponse.respuesta);
                }
            }
        );
    }


    $scope.init = function () {
        var url = "/api/TableroPat/DatosInicialesConsolidadoXMpioSeguimientoDepto?idRespuesta=" + $scope.tableroDetalle.IdRespuestaDepartamentoMunicipio + "&idSeguimiento=" + $scope.tableroDetalle.IdSeguimiento + "&idPregunta=" + $scope.tableroDetalle.IdPRegunta + "&idUsuarioAlcaldia=" + $scope.tableroDetalle.IdUsuarioAlcaldia + "&idDepartamento=" + $scope.Usuario.IdDepartamento + "&idMunicipio=" + $scope.tableroDetalle.IdMunicipio + "&idSeguimientoMun=" + $scope.tableroDetalle.IdSeguimientoMunicipio + "&numSeguimiento=" + $scope.seguimiento + "&idRespuestaDpto=" + $scope.tableroDetalle.IdRespuestaDept + "&idUsuarioGob=" + $scope.Usuario.Id;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.datosRespuesta = datos.datosSeguimiento;
            $scope.programasAgregados = datos.datosProgramas;
            angular.forEach($scope.programasAgregados, function (programa) {
                if (programa.NumeroSeguimiento == 2) {
                    $scope.programasAgregados2.push({ PROGRAMA: programa.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: 2 });
                } else {
                    $scope.programasAgregados1.push({ PROGRAMA: programa.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: 1 });
                }
            });
            if ($scope.programasAgregados2.length == 0 && $scope.seguimiento == 2) {
                angular.forEach($scope.programasAgregados1, function (programa) {
                    $scope.programasAgregados2.push({ PROGRAMA: programa.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: 2 });
                });
            }
            $scope.datosSegAlcaldia = datos.datosSegAlcaldia[0];
            $scope.programasAgregadosAlcaldia = datos.datosProgramasAlcaldia;
            angular.forEach($scope.programasAgregadosAlcaldia, function (programa) {
                if (programa.NumeroSeguimiento == 2) {
                    $scope.programasAgregadosAlcaldia2.push({ PROGRAMA: programa.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: 2 });
                } else {
                    $scope.programasAgregadosAlcaldia1.push({ PROGRAMA: programa.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: 1 });
                }
            });
            if ($scope.programasAgregadosAlcaldia2.length == 0 && $scope.seguimiento == 2) {
                angular.forEach($scope.programasAgregadosAlcaldia1, function (programa) {
                    $scope.programasAgregadosAlcaldia2.push({ PROGRAMA: programa.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: 2 });
                });
            }
            $scope.datosSegNacional = datos.datosSegNacional;
            //si no tengo ningun seguimiento
            if ($scope.datosRespuesta.IdSeguimiento == 0) {
                $scope.replaced1 = true;
                $scope.replaced2 = true;
                $scope.replaced3 = true;
                $scope.replaced4 = true;
                $scope.datosRespuesta.CantidadPrimer = "";
                $scope.datosRespuesta.PresupuestoPrimer = "";
                $scope.datosRespuesta.CantidadSegundo = "";
                $scope.datosRespuesta.PresupuestoSegundo = "";
                $scope.datosRespuesta.COMPROMISO_TOTAL = "";
                $scope.datosRespuesta.PRESUPUESTO_TOTAL = "";
                if ($scope.datosRespuesta.CompromisoDefinitivo == null) {
                    $scope.datosRespuesta.CompromisoDefinitivo = $scope.tableroDetalle.CompromisoGobernacion;
                }
                if (!$scope.datosRespuesta.PresupuestoDefinitivo || $scope.datosRespuesta.PresupuestoDefinitivo == null) {
                    $scope.datosRespuesta.PresupuestoDefinitivo = $scope.tableroDetalle.Presupuesto;
                }
            } else if ($scope.seguimiento == 1) {
                $scope.replaced3 = true;
                $scope.replaced4 = true;
                $scope.datosRespuesta.CantidadSegundo = $scope.datosRespuesta.CantidadSegundo > 0 ? $scope.datosRespuesta.CantidadSegundo : 0;
                $scope.datosRespuesta.PresupuestoSegundo = $scope.datosRespuesta.PresupuestoSegundo > 0 ? $scope.datosRespuesta.PresupuestoSegundo : 0;
                $scope.datosRespuesta.COMPROMISO_TOTAL = $scope.datosRespuesta.CantidadPrimer + $scope.datosRespuesta.CantidadSegundo;
                $scope.datosRespuesta.PRESUPUESTO_TOTAL = $scope.datosRespuesta.PresupuestoPrimer + $scope.datosRespuesta.PresupuestoSegundo;
                $scope.PRESUPUESTO_TOTAL = $scope.datosRespuesta.PRESUPUESTO_TOTAL;
                if ($scope.datosRespuesta.CompromisoDefinitivo == null) {
                    $scope.datosRespuesta.CompromisoDefinitivo = $scope.tableroDetalle.CompromisoGobernacion;
                }
                if (!$scope.datosRespuesta.PresupuestoDefinitivo || $scope.datosRespuesta.PresupuestoDefinitivo == null) {
                    $scope.datosRespuesta.PresupuestoDefinitivo = $scope.tableroDetalle.Presupuesto;
                }

            } else if ($scope.seguimiento == 2) {
                //$scope.replaced3 = false;
                //$scope.replaced4 = false;
                $scope.datosRespuesta.CantidadSegundo = $scope.datosRespuesta.CantidadSegundo > 0 ? $scope.datosRespuesta.CantidadSegundo : 0;
                $scope.datosRespuesta.PresupuestoSegundo = $scope.datosRespuesta.PresupuestoSegundo > 0 ? $scope.datosRespuesta.PresupuestoSegundo : 0;
                if ($scope.datosRespuesta.CantidadSegundo >= 0) {
                    $scope.replaced3 = false;
                } else if ($scope.datosRespuesta.PresupuestoSegundo >= 0) {
                    $scope.replaced4 = false;
                }
                $scope.datosRespuesta.COMPROMISO_TOTAL = $scope.datosRespuesta.CantidadPrimer + $scope.datosRespuesta.CantidadSegundo;
                $scope.COMPROMISO_TOTAL = $scope.datosRespuesta.CantidadPrimer + $scope.datosRespuesta.CantidadSegundo;
                $scope.datosRespuesta.PRESUPUESTO_TOTAL = $scope.datosRespuesta.PresupuestoPrimer + $scope.datosRespuesta.PresupuestoSegundo;
                $scope.PRESUPUESTO_TOTAL = $scope.datosRespuesta.PresupuestoPrimer + $scope.datosRespuesta.PresupuestoSegundo;
                if ($scope.datosRespuesta.CantidadPrimer == -1) {
                    $scope.replaced1 = true;
                    $scope.datosRespuesta.CantidadPrimer = 0;
                } else if ($scope.datosRespuesta.PresupuestoPrimer == -1) {
                    $scope.replaced2 = true;
                    $scope.datosRespuesta.PresupuestoPrimer = 0;
                }
            }
            $scope.ADJUNTO = $scope.datosRespuesta.NombreAdjunto;

            $scope.datosSegNacional = datos.datosSegNacional;
            $scope.datosPrecargueNacional = datos.datosPrecargueNacional;

            for (var j = 0; j < $scope.datosPrecargueNacional.length; j++) {
                $scope.datosSegNacional.CompromisoN += $scope.datosPrecargueNacional[j].PlanCompromiso;
                $scope.datosSegNacional.PresupuestoN += $scope.datosPrecargueNacional[j].PlanPresupuesto;
                $scope.datosSegNacional.CantidadPrimerSemestreN += $scope.datosPrecargueNacional[j].SegCompromiso1;
                $scope.datosSegNacional.PresupuestoPrimerSemestreN += $scope.datosPrecargueNacional[j].SegPresupuesto1;
                //if ($scope.datosSegNacional.CantidadPrimerSemestreN == 0) {           
                //    //if ($scope.datosPrecargueNacional[j].Programas != "") {
                //    //    var array = $scope.datosPrecargueNacional[j].Programas.split('//');
                //    //    for (var i = 0; i < array.length; i++) {
                //    //        $scope.programasAgregados1.push({ PROGRAMA: array[i], IdSeguimiento: 0, numeroSeguimiento: 1 });
                //    //    }
                //    //}
                //    //if ($scope.datosPrecargueNacional[j].Acciones != "") {
                //    //    var array = $scope.datosPrecargueNacional[j].Acciones.split('//');
                //    //    for (var i = 0; i < array.length; i++) {
                //    //        $scope.AccionesAgregados1.push({ ACCION: array[i], IdSeguimiento: 0, numeroSeguimiento: 1 });
                //    //    }
                //    //}

                //}
                $scope.datosSegNacional.CantidadSegundoSemestreN += $scope.datosPrecargueNacional[j].SegCompromiso2;
                $scope.datosSegNacional.PresupuestoSegundoSemestreN += $scope.datosPrecargueNacional[j].SegPresupuesto2;
                //if ($scope.datosSegNacional.CantidadSegundoSemestreN == 0) {
                //    //if ($scope.datosPrecargueNacional[j].Programas != "") {
                //    //    var array = $scope.datosPrecargueNacional[j].Programas.split('//');
                //    //    for (var i = 0; i < array.length; i++) {
                //    //        $scope.programasAgregados2.push({ PROGRAMA: array[i], IdSeguimiento: 0, numeroSeguimiento: 2 });
                //    //    }
                //    //}
                //    //if ($scope.datosPrecargueNacional[j].Acciones != "") {
                //    //    var array = $scope.datosPrecargueNacional[j].Acciones.split('//');
                //    //    for (var i = 0; i < array.length; i++) {
                //    //        $scope.AccionesAgregados2.push({ ACCION: array[i], IdSeguimiento: 0, numeroSeguimiento: 1 });
                //    //    }
                //    //}
                //}
            }

            $scope.datosSegNacional.CompromisoTotalN = $scope.datosSegNacional.CantidadPrimerSemestreN + $scope.datosSegNacional.CantidadSegundoSemestreN;
            $scope.datosSegNacional.PresupuestoTotalN = $scope.datosSegNacional.PresupuestoPrimerSemestreN + $scope.datosSegNacional.PresupuestoSegundoSemestreN;;

        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
        $scope.submitted = false;
    };
    $scope.init();
    $scope.sumTotalCantidad = function () {
        $scope.datosRespuesta.COMPROMISO_TOTAL = $scope.datosRespuesta.CantidadPrimer + ($scope.datosRespuesta.CantidadSegundo > -1 ? $scope.datosRespuesta.CantidadSegundo : 0);
        $scope.replaced1 = false;
    };
    $scope.sumTotalPresupuesto = function () {
        $scope.datosRespuesta.PRESUPUESTO_TOTAL = $scope.datosRespuesta.PresupuestoPrimer + ($scope.datosRespuesta.PresupuestoSegundo > -1 ? $scope.datosRespuesta.PresupuestoSegundo : 0);
        $scope.replaced2 = false;
    };
    $scope.sumTotalCantidad2 = function () {
        $scope.datosRespuesta.COMPROMISO_TOTAL = $scope.datosRespuesta.CantidadPrimer + $scope.datosRespuesta.CantidadSegundo;
        $scope.replaced3 = false;
    };
    $scope.sumTotalPresupuesto2 = function () {
        $scope.datosRespuesta.PRESUPUESTO_TOTAL = $scope.datosRespuesta.PresupuestoPrimer + $scope.datosRespuesta.PresupuestoSegundo;
        $scope.replaced4 = false;
    };

    $scope.restoreDefaultValues = function () {

        if ($scope.datosRespuesta.IdSeguimiento == 0 || $scope.seguimiento == 1) {
            $scope.datosRespuesta.CantidadSegundo = -1;
            $scope.datosRespuesta.PresupuestoSegundo = -1;
        }
    };
    $scope.agregarPrograma = function (semestre) {
        $scope.errors.PROGRAMA = '';
        $scope.errors.PROGRAMA2 = '';
        if (semestre == 1) {
            if ($scope.tablero.PROGRAMA) {
                if ($scope.tablero.PROGRAMA.length > 1000) {
                    $scope.errors.PROGRAMA = "El programa no debe exceder los 1000 caracteres";
                    return;
                }
                var programaExistente = false;
                angular.forEach($scope.programasAgregados1, function (programa) {
                    if (programa.Programa == $scope.tablero.PROGRAMA) {
                        programaExistente = true;
                    }
                });
                if (!programaExistente) {
                    $scope.programasAgregados1.push({ PROGRAMA: $scope.tablero.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: semestre });
                }
                $scope.tablero.PROGRAMA = null;
                $("#programa").focus();
            } else {
                $scope.errors.PROGRAMA = "El programa es requerido";
            }
        } else {
            if ($scope.tablero.PROGRAMA2) {
                if ($scope.tablero.PROGRAMA2.length > 1000) {
                    $scope.errors.PROGRAMA2 = "El programa no debe exceder los 1000 caracteres";
                    return;
                }
                var programaExistente = false;
                angular.forEach($scope.programasAgregados2, function (programa) {
                    if (programa.Programa == $scope.tablero.PROGRAMA2) {
                        programaExistente = true;
                    }
                });
                if (!programaExistente) {
                    $scope.programasAgregados2.push({ PROGRAMA: $scope.tablero.PROGRAMA2, IdSeguimiento: 0, numeroSeguimiento: semestre });
                }
                $scope.tablero.PROGRAMA2 = null;
                $("#programa2").focus();
            } else {
                $scope.errors.PROGRAMA2 = "El programa es requerido";
            }
        }

    }
    $scope.borrarPrograma = function (index) {
        $scope.programasAgregados1.splice(index, 1);
    }
    $scope.EditarPrograma = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/EdicionPrograma.html',
            controller: 'SeguimientoMunicipioEdicionProgramaCtrl',
            size: 'sm',
            resolve: {
                programa: function () {
                    return angular.copy($scope.programasAgregados1[index]);
                }
            }
        });
        modalInstance.result.then(
            function (datosResponse) {
                $scope.mensajeWarningEdit = null;
                $scope.mensajeOKEdit = null;
                if (datosResponse) {
                    $scope.programasAgregados1[index] = datosResponse;
                    $scope.mensajeOKEdit = "El Programa se actualizó correctamente";
                }
                else {
                    $scope.mensajeWarningEdit = "No se actualizó el Programa";
                }
            }
        );
    }

    $scope.borrarPrograma2 = function (index) {
        $scope.programasAgregados2.splice(index, 1);
    }
    $scope.EditarPrograma2 = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/EdicionPrograma.html',
            controller: 'SeguimientoMunicipioEdicionProgramaCtrl',
            size: 'sm',
            resolve: {
                programa: function () {
                    return angular.copy($scope.programasAgregados2[index]);
                }
            }
        });
        modalInstance.result.then(
            function (datosResponse) {
                $scope.mensajeWarningEdit = null;
                $scope.mensajeOKEdit = null;
                if (datosResponse) {
                    $scope.programasAgregados2[index] = datosResponse;
                    $scope.mensajeOKEdit = "El Programa se actualizó correctamente";
                }
                else {
                    $scope.mensajeWarningEdit = "No se actualizó el Programa";
                }
            }
        );
    }

    $scope.borrarAdjunto = function (semestre) {
        if (semestre == 1) {
            $scope.datosRespuesta.NombreAdjunto = "";
        } else {
            $scope.datosRespuesta.NombreAdjuntoSegundo = "";
        }
    }

    $scope.guardar = function () {
        $scope.submitted = true;
        $scope.extension = false;
        if (!$scope.validar()) return false;
        if (!$scope.validarExtension()) return false;
        $scope.habilita = true;
        $scope.flagVariable = true;
        $scope.mensajeErrorForm = "";

        $scope.datosRespuesta.IdSeguimiento = $scope.tableroDetalle.IdSeguimiento;
        $scope.datosRespuesta.IdPregunta = $scope.tableroDetalle.IdPRegunta;
        $scope.datosRespuesta.IdUsuario = $scope.Usuario.Id;
        $scope.datosRespuesta.IdTablero = $scope.idTablero;
        $scope.datosRespuesta.IdUsuarioAlcaldia = $scope.tableroDetalle.IdUsuarioAlcaldia;
        $scope.datosRespuesta.NombreAdjunto = (!$scope.datosRespuesta.NombreAdjunto) ? ($scope.file ? $scope.file.name : "") : $scope.datosRespuesta.NombreAdjunto;
        $scope.datosRespuesta.NombreAdjuntoSegundo = (!$scope.datosRespuesta.NombreAdjuntoSegundo) ? ($scope.file2 ? $scope.file2.name : "") : $scope.datosRespuesta.NombreAdjuntoSegundo;
        $scope.datosRespuesta.PresupuestoPrimer = $scope.datosRespuesta.PresupuestoPrimer >= 0 ? $scope.datosRespuesta.PresupuestoPrimer : 0;
        $scope.datosRespuesta.PresupuestoSegundo = $scope.datosRespuesta.PresupuestoSegundo >= 0 ? $scope.datosRespuesta.PresupuestoSegundo : 0;
        $scope.datosRespuesta.CantidadPrimer = $scope.datosRespuesta.CantidadPrimer >= 0 ? $scope.datosRespuesta.CantidadPrimer : 0;
        $scope.datosRespuesta.CantidadSegundo = $scope.datosRespuesta.CantidadSegundo >= 0 ? $scope.datosRespuesta.CantidadSegundo : 0;

        $scope.datosRespuesta.ObservacionesDefinitivo = $scope.datosRespuesta.ObservacionesDefinitivo;
        $scope.datosRespuesta.CompromisoDefinitivo = $scope.datosRespuesta.CompromisoDefinitivo;
        $scope.datosRespuesta.PresupuestoDefinitivo = $scope.datosRespuesta.PresupuestoDefinitivo;

        $scope.datosRespuesta.SeguimientoProgramas = [];
        angular.forEach($scope.programasAgregados1, function (pro) {
            $scope.datosRespuesta.SeguimientoProgramas.push({ PROGRAMA: pro.PROGRAMA, NumeroSeguimiento: 1 });
        });
        angular.forEach($scope.programasAgregados2, function (pro) {
            $scope.datosRespuesta.SeguimientoProgramas.push({ PROGRAMA: pro.PROGRAMA, NumeroSeguimiento: 2 });
        });
        $scope.datosRespuesta.Observaciones = $scope.datosRespuesta.Observaciones;
        $scope.programasAgregados = [];
        angular.forEach($scope.programasAgregados, function (pro) {
            $scope.datosRespuesta.SeguimientoProgramas.push({ PROGRAMA: pro.PROGRAMA });
        });

        var url = "/api/TableroPat/RegistrarSeguimientoDepartamento";

        //// Cargar los datos de auditoría
        $scope.datosRespuesta.AudUserName = authService.authentication.userName;
        $scope.datosRespuesta.AddIdent = authService.authentication.isAddIdent;
        $scope.datosRespuesta.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.datosRespuesta, url);
        servCall.then(function (response) {
            $scope.deshabiltarRegistrese = false;
            $scope.seguimiento = [];
            $scope.seguimiento.usuario = $scope.Usuario.Id;
            $scope.seguimiento.tablero = $scope.idTablero;
            $scope.seguimiento.pregunta = $scope.tableroDetalle.IdPRegunta;
            $scope.seguimiento.type = 'CSD';
            if ($scope.file) { $scope.upload($scope.file, 1); }
            if ($scope.file2) { $scope.upload($scope.file2, 2); }
            $scope.flagVariable = false;
            //uploadFileSeguimiento(data.d.idTablero, data.d.usuario, data.d.idPregunta, "CSD");
            $scope.restoreDefaultValues();
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.message;
        });
    };
    $scope.upload = function (file, semestre) {
        if (semestre == 1) {
            $scope.seguimiento.type = 'CSD';
        }
        if (semestre == 2) {
            $scope.seguimiento.type = 'CSD2';
        }
        Upload.upload({
            url: serviceBase + '/api/TableroPat/AdjutarArchivoSeguimiento',
            method: "POST",
            data: $scope.seguimiento,
            file: file,
        }).then(function (resultado) {
            $scope.deshabiltarRegistrese = false;
            $uibModalInstance.close(resultado.data);
        }, function (resultado) {
            $scope.deshabiltarRegistrese = false;
            var mensaje = { msn: 'Error: ' + resultado.data.ExceptionMessage, tipo: "alert alert-danger" };
        }, function (evt) {
            var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
        });
    };
    $scope.descargar = function (index, semestre) {
        var url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.datosRespuesta.NombreAdjunto + '&nombreArchivo=' + $scope.datosRespuesta.NombreAdjunto + '&type=CSD&idTablero=' + $scope.idTablero + '&idPregunta=' + $scope.datosRespuesta.IdPregunta + '&idUsuario=' + $scope.Usuario.Id + '&NumSeguimiento=1';
        if (semestre == 2) {
            var url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.datosRespuesta.NombreAdjuntoSegundo + '&nombreArchivo=' + $scope.datosRespuesta.NombreAdjuntoSegundo + '&type=CSD2&idTablero=' + $scope.idTablero + '&idPregunta=' + $scope.datosRespuesta.IdPregunta + '&idUsuario=' + $scope.Usuario.Id + '&NumSeguimiento=2';
        }
        window.open(url)
    }
    $scope.descargarAlcaldias = function (index, semestre) {
        var url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.datosSegAlcaldia.AdjuntoSeguimiento + '&nombreArchivo=' + $scope.datosSegAlcaldia.AdjuntoSeguimiento + '&type=D&idTablero=' + $scope.idTablero + '&idPregunta=' + $scope.datosRespuesta.IdPregunta + '&idUsuario=' + $scope.datosRespuesta.IdUsuarioAlcaldia + '&NumSeguimiento=1';
        if (semestre == 2) {
            var url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.datosSegAlcaldia.NombreAdjuntoSegundo + '&nombreArchivo=' + $scope.datosSegAlcaldia.NombreAdjuntoSegundo + '&type=D2&idTablero=' + $scope.idTablero + '&idPregunta=' + $scope.datosRespuesta.IdPregunta + '&idUsuario=' + $scope.datosRespuesta.IdUsuarioAlcaldia + '&NumSeguimiento=2';
        }
        window.open(url)
    }
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
            if ($scope.file2) {
                var filename = $scope.file2.name;
                var index = filename.lastIndexOf(".");
                var strsubstring = filename.substring(index, filename.length);
                strsubstring = strsubstring.toLowerCase();
                if (strsubstring == '.pdf' || strsubstring == '.doc' || strsubstring == '.docx' || strsubstring == '.xlsx' || strsubstring == '.xls' || strsubstring == '.png' || strsubstring == '.jpeg' || strsubstring == '.png' || strsubstring == '.jpg' || strsubstring == '.gif' || strsubstring == '.txt' || strsubstring == '.rar' || strsubstring == '.zip' || strsubstring == '.7z') {
                    $scope.extension2 = true;
                    return true;
                } else {
                    return false;
                }
            } else {
                return true;
            }
        }
    }
    $scope.BorraMensaje = function () { // $scope que acciona el ng-kepress
        $scope.errors.DESCRIPCION = '';
    };
}])
app.controller('SeguimientoMunicipioConsolidadoVerAccYProCtrl', ['$scope', 'APIService', 'UtilsService', 'Upload', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModalInstance', 'authService', 'ngSettings', 'enviarDatos', 'accProg', function ($scope, APIService, UtilsService, Upload, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModalInstance, authService, ngSettings, enviarDatos, accProg) {
    $scope.accProg = { Observaciones: accProg.accProg.Observaciones, Programas: accProg.accProg.Programas }// accProg.accProg || { IdPregunta: 0 };
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
}])

//Modal RC
app.controller('SeguimientoDepartamentoEdicionRCCtrl', ['$scope', 'APIService', '$http', 'Upload', 'tableroRC', '$uibModal', '$uibModalInstance', '$filter', '$log', 'authService', 'UtilsService', function ($scope, APIService, $http, Upload, tableroRC, $uibModal, $uibModalInstance, $filter, $log, authService, UtilsService) {
    $scope.tableroRC = tableroRC.tablero;
    $scope.Usuario = tableroRC.Usuario;
    $scope.activo = tableroRC.activo;
    $scope.serviceBase = tableroRC.serviceBase;
    $scope.anoSeguimiento = tableroRC.anoSeguimiento;
    $scope.idTablero = tableroRC.idTablero;
    $scope.seguimiento = tableroRC.numSeguimiento;
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.habilita = false;
    $scope.flagVariable = false;
    $scope.datosRespuesta;
    $scope.seguimiento;
    $scope.adjunto = false;

    $scope.extensionesPermitidas = ['.docx', '.doc', '.xls', '.xlsx', '.ppt', '.pptx',  //De microsoft
    '.pdf', '.txt',                                                             //Varias
    '.bmp', '.jpg', '.gif', '.jpg', '.jpeg', '.tif', '.tiff', '.png',           //Imágenes
    '.zip', '.7z', '.rar'
    ];

    //========================VALIDAR ARCHIVO ADJUNTO===================================
    $scope.validarArchivo = function (file, numSeg) {
        var respuestaValidarArchivo = true;
        var indexUltimoPunto = file.name.lastIndexOf(".");
        if (indexUltimoPunto != -1) {
            var extension = file.name.slice(indexUltimoPunto);
            extension = extension.toLowerCase();
            if ($scope.extensionesPermitidas.indexOf(extension) === -1) {
                var mensaje = { msn: "La extensión '" + extension + "' no es permitida", tipo: "alert alert-danger" };
                respuestaValidarArchivo = false;
                quitarArchivoAdjunto();
                openRespuesta(mensaje);
            } else if (file.name.search(/[!*$#,´'`~+]/g) != -1) {
                var mensaje = { msn: "El nombre de archivo '" + file.name + "' contiene caracteres no permitidos (!*$#,´'`~+). Modifíquelo e intente nuevamente.", tipo: "alert alert-danger" };
                respuestaValidarArchivo = false;
                quitarArchivoAdjunto();
                openRespuesta(mensaje);
            }
        } else {
            var mensaje = { msn: "No existe ninguna extensión para el archivo", tipo: "alert alert-danger" };
            respuestaValidarArchivo = false;
            quitarArchivoAdjunto();
            openRespuesta(mensaje);
        }

        if (respuestaValidarArchivo) {
            if (file.size > 10000000) {
                quitarArchivoAdjunto();
                file = null;
                var mensaje = { msn: 'El tamaño del archivo no debe superar los 10 MB', tipo: "alert alert-danger" };
                openRespuesta(mensaje);
            }
        }

        function quitarArchivoAdjunto() {
            file = null;
        }

        return respuestaValidarArchivo;
    }

    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    return mensaje;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (resultado) {
            });
    };

    $scope.init = function () {
        if ($scope.tableroRC.IdPregunta == null) {
            $scope.tableroRC.IdPregunta = 0;
        }
        var url = "/api/TableroPat/DatosInicialesSeguimientoDepartamentoRC?idPregunta=" + $scope.tableroRC.IdPregunta + "&idUsuarioAlcaldia=" + $scope.tableroRC.IdMunicipio + "&idRespuestaRC=" + $scope.tableroRC.IdRespuestaDepartamento;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.datosRespuesta = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
        $scope.submitted = false;
    };

    $scope.errors = [];
    $scope.init();
    $scope.guardar = function () {
        $scope.submitted = true;
        $scope.extension = false;
        if (!$scope.validarExtension()) return false;
        if (!$scope.validar()) return false;
        $scope.habilita = true;
        $scope.flagVariable = true;
        $scope.datosRespuesta.IdTablero = $scope.idTablero;
        $scope.datosRespuesta.IdUsuario = $scope.Usuario.Id;
        $scope.datosRespuesta.IdRespuestaRC = $scope.tableroRC.IdRespuestaDepartamento;
        $scope.datosRespuesta.IdUsuarioAlcaldia = $scope.tableroRC.IdMunicipio;
        $scope.datosRespuesta.NombreAdjunto = (!$scope.datosRespuesta.NombreAdjunto) ? ($scope.file ? $scope.file.name : "") : $scope.datosRespuesta.NombreAdjunto;

        var url = "/api/TableroPat/RegistrarSeguimientoDepartamentoRC/";

        //// Cargar los datos de auditoría
        $scope.datosRespuesta.AudUserName = authService.authentication.userName;
        $scope.datosRespuesta.AddIdent = authService.authentication.isAddIdent;
        $scope.datosRespuesta.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.datosRespuesta, url);
        servCall.then(function (response) {
            $scope.seguimiento = [];
            $scope.seguimiento.usuario = $scope.Usuario.Id;
            $scope.seguimiento.tablero = $scope.idTablero;
            $scope.seguimiento.pregunta = $scope.datosRespuesta.IdPregunta;
            $scope.seguimiento.type = 'RC';
            $scope.upload($scope.file);
            $scope.flagVariable = false;
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.data.ExceptionMessage;
        });
    };
    $scope.upload = function (file) {
        Upload.upload({
            url: serviceBase + '/api/TableroPat/AdjutarArchivoSeguimiento',
            method: "POST",
            data: $scope.seguimiento,
            file: file,
        }).then(function (resultado) {
            $scope.deshabiltarRegistrese = false;
            $uibModalInstance.close(resultado.data);
        }, function (resultado) {
            $scope.deshabiltarRegistrese = false;
            var mensaje = { msn: 'Error: ' + resultado.data.ExceptionMessage, tipo: "alert alert-danger" };
        }, function (evt) {
            //var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
        });
    };
    $scope.borrarAdjunto = function () {
        $scope.datosRespuesta.NombreAdjunto = "";
        $scope.adjunto = false;
    }
    $scope.descargar = function (index) {
        var url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.datosRespuesta.NombreAdjunto + '&nombreArchivo=' + $scope.datosRespuesta.NombreAdjunto + '&type=RC&idTablero=' + $scope.idTablero + '&idPregunta= ' + $scope.datosRespuesta.IdPregunta + '&idUsuario=' + $scope.Usuario.Id;
        window.open(url)
    }
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.validar = function () {
        return $scope.editRCForm.$valid;
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
}])
//modal RR
app.controller('SeguimientoDepartamentoEdicionRRCtrl', ['$scope', 'APIService', '$http', 'Upload', 'tableroRR', '$uibModal', '$uibModalInstance', '$filter', '$log', 'authService', 'UtilsService', function ($scope, APIService, $http, Upload, tableroRR, $uibModal, $uibModalInstance, $filter, $log, authService, UtilsService) {
    $scope.tableroRR = tableroRR.tablero;
    $scope.Usuario = tableroRR.Usuario;
    $scope.activo = tableroRR.activo;
    $scope.serviceBase = tableroRR.serviceBase;
    $scope.anoSeguimiento = tableroRR.anoSeguimiento;
    $scope.idTablero = tableroRR.idTablero;
    $scope.seguimiento = tableroRR.numSeguimiento;
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.habilita = false;
    $scope.flagVariable = false;
    $scope.datosRespuesta;
    $scope.seguimiento;
    $scope.adjunto = false;

    $scope.extensionesPermitidas = ['.docx', '.doc', '.xls', '.xlsx', '.ppt', '.pptx',  //De microsoft
'.pdf', '.txt',                                                             //Varias
'.bmp', '.jpg', '.gif', '.jpg', '.jpeg', '.tif', '.tiff', '.png',           //Imágenes
'.zip', '.7z', '.rar'
    ];

    //========================VALIDAR ARCHIVO ADJUNTO===================================
    $scope.validarArchivo = function (file, numSeg) {
        var respuestaValidarArchivo = true;
        var indexUltimoPunto = file.name.lastIndexOf(".");
        if (indexUltimoPunto != -1) {
            var extension = file.name.slice(indexUltimoPunto);
            extension = extension.toLowerCase();
            if ($scope.extensionesPermitidas.indexOf(extension) === -1) {
                var mensaje = { msn: "La extensión '" + extension + "' no es permitida", tipo: "alert alert-danger" };
                respuestaValidarArchivo = false;
                quitarArchivoAdjunto();
                openRespuesta(mensaje);
            } else if (file.name.search(/[!*$#,´'`~+]/g) != -1) {
                var mensaje = { msn: "El nombre de archivo '" + file.name + "' contiene caracteres no permitidos (!*$#,´'`~+). Modifíquelo e intente nuevamente.", tipo: "alert alert-danger" };
                respuestaValidarArchivo = false;
                quitarArchivoAdjunto();
                openRespuesta(mensaje);
            }
        } else {
            var mensaje = { msn: "No existe ninguna extensión para el archivo", tipo: "alert alert-danger" };
            respuestaValidarArchivo = false;
            quitarArchivoAdjunto();
            openRespuesta(mensaje);
        }

        if (respuestaValidarArchivo) {
            if (file.size > 10000000) {
                quitarArchivoAdjunto();
                file = null;
                var mensaje = { msn: 'El tamaño del archivo no debe superar los 10 MB', tipo: "alert alert-danger" };
                openRespuesta(mensaje);
            }
        }

        function quitarArchivoAdjunto() {
            file = null;
        }

        return respuestaValidarArchivo;
    }

    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    return mensaje;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (resultado) {
            });
    };

    $scope.init = function () {
        if ($scope.tableroRR.Id == null) {
            $scope.tableroRR.Id = 0;
        }
        var url = "/api/TableroPat/DatosInicialesSeguimientoDepartamentoRR?idPregunta=" + $scope.tableroRR.Id + "&idUsuarioAlcaldia=" + $scope.tableroRR.IdMunicipio;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.datosRespuesta = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
        $scope.submitted = false;
    };

    $scope.errors = [];
    $scope.init();
    $scope.guardar = function () {
        $scope.submitted = true;
        $scope.extension = false;
        if (!$scope.validarExtension()) return false;
        if (!$scope.validar()) return false;
        $scope.habilita = true;
        $scope.flagVariable = true;
        $scope.datosRespuesta.IdTablero = $scope.idTablero;
        $scope.datosRespuesta.IdUsuario = $scope.Usuario.Id
        $scope.datosRespuesta.IdUsuarioAlcaldia = $scope.tableroRR.IdMunicipio;
        $scope.datosRespuesta.NombreAdjunto = (!$scope.datosRespuesta.NombreAdjunto) ? ($scope.file ? $scope.file.name : "") : $scope.datosRespuesta.NombreAdjunto;

        var url = "/api/TableroPat/RegistrarSeguimientoDepartamentoRR/";

        //// Cargar los datos de auditoría
        $scope.datosRespuesta.AudUserName = authService.authentication.userName;
        $scope.datosRespuesta.AddIdent = authService.authentication.isAddIdent;
        $scope.datosRespuesta.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.datosRespuesta, url);
        servCall.then(function (response) {
            $scope.seguimiento = [];
            $scope.seguimiento.usuario = $scope.Usuario.Id;
            $scope.seguimiento.tablero = $scope.idTablero;
            $scope.seguimiento.pregunta = $scope.datosRespuesta.IdPregunta;
            $scope.seguimiento.type = 'RR';
            $scope.upload($scope.file);
            $scope.flagVariable = false;
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.data.ExceptionMessage;
        });
    };
    $scope.upload = function (file) {
        Upload.upload({
            url: serviceBase + '/api/TableroPat/AdjutarArchivoSeguimiento',
            method: "POST",
            data: $scope.seguimiento,
            file: file,
        }).then(function (resultado) {
            $scope.deshabiltarRegistrese = false;
            $uibModalInstance.close(resultado.data);
        }, function (resultado) {
            $scope.deshabiltarRegistrese = false;
            var mensaje = { msn: 'Error: ' + resultado.data.ExceptionMessage, tipo: "alert alert-danger" };
        }, function (evt) {
            //var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
        });
    };
    $scope.borrarAdjunto = function () {
        $scope.datosRespuesta.NombreAdjunto = "";
        $scope.adjunto = false;
    }
    $scope.descargar = function (index) {
        var url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.datosRespuesta.NombreAdjunto + '&nombreArchivo=' + $scope.datosRespuesta.NombreAdjunto + '&type=RR&idTablero=' + $scope.idTablero + '&idPregunta= ' + $scope.datosRespuesta.IdPregunta + '&idUsuario=' + $scope.Usuario.Id;
        window.open(url)
    }
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.validar = function () {
        return $scope.editRRForm.$valid;
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
}])
//Modal Agregar otros derechos
app.controller('SeguimientoDepartamentoAgregarODCtrl', ['$scope', 'APIService', 'UtilsService', 'Upload', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$uibModalInstance', 'authService', 'ngSettings', 'enviarDatos', 'datos', 'authService', 'UtilsService', function ($scope, APIService, UtilsService, Upload, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $uibModalInstance, authService, ngSettings, enviarDatos, datos, authService, UtilsService) {
    $scope.Usuario = datos.Usuario;
    $scope.idTablero = datos.idTablero;
    $scope.datos = {};
    $scope.habilita = false;
    $scope.flagVariable = false;
    $scope.derecho = [];
    $scope.listaMapa = [];
    $scope.listaAlcaldias = [];
    $scope.listaDerechos = [];
    $scope.listaComponentes = [];
    $scope.listaMedidas = [];
    $scope.listaUnidades = [];
    $scope.medidas = [];
    $scope.errors = [];
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.extensionesPermitidas = ['.docx', '.doc', '.xls', '.xlsx', '.ppt', '.pptx',  //De microsoft
'.pdf', '.txt',                                                             //Varias
'.bmp', '.jpg', '.gif', '.jpg', '.jpeg', '.tif', '.tiff', '.png',           //Imágenes
'.zip', '.7z', '.rar'
    ];

    //========================VALIDAR ARCHIVO ADJUNTO===================================
    $scope.validarArchivo = function (file, numSeg) {
        var respuestaValidarArchivo = true;
        var indexUltimoPunto = file.name.lastIndexOf(".");
        if (indexUltimoPunto != -1) {
            var extension = file.name.slice(indexUltimoPunto);
            extension = extension.toLowerCase();
            if ($scope.extensionesPermitidas.indexOf(extension) === -1) {
                var mensaje = { msn: "La extensión '" + extension + "' no es permitida", tipo: "alert alert-danger" };
                respuestaValidarArchivo = false;
                quitarArchivoAdjunto();
                openRespuesta(mensaje);
            } else if (file.name.search(/[!*$#,´'`~+]/g) != -1) {
                var mensaje = { msn: "El nombre de archivo '" + file.name + "' contiene caracteres no permitidos (!*$#,´'`~+). Modifíquelo e intente nuevamente.", tipo: "alert alert-danger" };
                respuestaValidarArchivo = false;
                quitarArchivoAdjunto();
                openRespuesta(mensaje);
            }
        } else {
            var mensaje = { msn: "No existe ninguna extensión para el archivo", tipo: "alert alert-danger" };
            respuestaValidarArchivo = false;
            quitarArchivoAdjunto();
            openRespuesta(mensaje);
        }

        if (respuestaValidarArchivo) {
            if (file.size > 10000000) {
                quitarArchivoAdjunto();
                file = null;
                var mensaje = { msn: 'El tamaño del archivo no debe superar los 10 MB', tipo: "alert alert-danger" };
                openRespuesta(mensaje);
            }
        }

        function quitarArchivoAdjunto() {
            file = null;
        }

        return respuestaValidarArchivo;
    }

    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    return mensaje;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (resultado) {
            });
    };

    $scope.init = function () {
        $scope.submitted = false;
        var url = '/api/TableroPat/DatosInicialesEdicionSeguimientoDepartamentoOD?idTablero=' + $scope.idTablero + '&idUsuario=' + $scope.Usuario.Id;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.listaDerechos = datos.listaDerechos;
            $scope.listaUnidades = datos.listaUnidades;
            $scope.listaAlcaldias = datos.listaMunicipios;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };
    $scope.GetComponentesByDerecho = function () {
        $scope.listaComponentes = [];
        $scope.listaMedidas = [];
        $scope.medidas = [];
        var url = '/api/TableroPat/GetComponentesDerechoOD?idDerecho=' + $scope.derecho.IdDerecho;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.listaComponentes = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };
    $scope.GetMedidasByComponente = function () {
        $scope.listaMedidas = [];
        $scope.medidas = [];
        var url = '/api/TableroPat/GetMedidasByComponenteOD?idComponente=' + $scope.componente.IdComponente;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.listaMedidas = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };
    $scope.addMapa = function (medida, checked) {
        if (checked) {
            var mapaExiste = false;
            angular.forEach($scope.listaMapa, function (mapa) {
                if (mapa.IdMedida == medida.IdMedida) {
                    mapaExiste = true;
                }
            });
            if (!mapaExiste) {
                var mapa = { IdDerecho: $scope.derecho.IdDerecho, Derecho: $scope.derecho.Descripcion, IdComponente: $scope.componente.IdComponente, Componente: $scope.componente.Descripcion, Medida: medida.Descripcion, IdMedida: medida.IdMedida };
                $scope.listaMapa.push(mapa);
            }
        }
    };
    $scope.eliminarMapa = function (index) {
        var medidaElim = $scope.listaMapa[index].IdMedida;
        var idx = -1;
        angular.forEach($scope.medidas, function (medida, key) {
            if (medida.IdMedida == medidaElim) {
                idx = key;
            }
        });
        $scope.medidas.splice(idx, 1);
        $scope.listaMapa.splice(index, 1);
    };
    $scope.guardar = function () {
        $scope.error = null;
        if (!$scope.validarExtension()) return false;
        if (!$scope.validar()) return false;
        if ($scope.listaMapa.length == 0) {
            $scope.error = "Debe seleccionarse por lo menos una medida para poder agregar la información";
            return false;
        }
        $scope.MedidasOD = [];
        angular.forEach($scope.listaMapa, function (medida, key) {

            var medidaOD = { IdSeguimiento: 0, IdMedida: medida.IdMedida, IdDerecho: medida.IdDerecho, IdComponente: medida.IdComponente };

            $scope.MedidasOD.push(medidaOD);
        });


        $scope.seguimientoOD = {};
        $scope.seguimientoOD.IdUsuario = $scope.Usuario.Id;
        $scope.seguimientoOD.IdTablero = $scope.idTablero;
        $scope.seguimientoOD.IdSeguimiento = 0;
        $scope.seguimientoOD.Programa = $scope.programa;
        $scope.seguimientoOD.Accion = $scope.accion;
        $scope.seguimientoOD.Cantidad = $scope.seguimiento;
        $scope.seguimientoOD.IdUnidad = $scope.unidad.Id;
        $scope.seguimientoOD.Presupuesto = $scope.presupuesto;
        $scope.seguimientoOD.Observaciones = $scope.observaciones;
        $scope.seguimientoOD.IdUsuarioAlcaldia = $scope.alcaldia.IdUsuario;
        $scope.seguimientoOD.NombreAdjunto = $scope.file ? $scope.file.name : "";
        $scope.seguimientoOD.SeguimientoGobernacionOtrosDerechosMedidas = $scope.MedidasOD;

        $scope.habilita = true;
        $scope.flagVariable = true;

        var url = "/api/TableroPat/RegistrarSeguimientoDepartamentalOD";

        //// Cargar los datos de auditoría
        $scope.seguimientoOD.AudUserName = authService.authentication.userName;
        $scope.seguimientoOD.AddIdent = authService.authentication.isAddIdent;
        $scope.seguimientoOD.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.seguimientoOD, url);
        servCall.then(function (response) {
            if ($scope.file) {
                $scope.seguimiento = [];
                $scope.seguimiento.usuario = $scope.seguimientoOD.IdUsuario;
                $scope.seguimiento.tablero = $scope.seguimientoOD.IdTablero;
                $scope.seguimiento.pregunta = response.data.id;//como no se tiene pregunta se guarda con el idSeguimiento
                $scope.seguimiento.type = 'OD';
                $scope.upload($scope.file);
                $scope.flagVariable = false;
                $uibModalInstance.close(response.data);
            } else {
                $scope.flagVariable = false;
                $uibModalInstance.close(response.data);
            }
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = data;
        });
    };
    $scope.upload = function (file) {
        Upload.upload({
            url: serviceBase + '/api/TableroPat/AdjutarArchivoSeguimiento',
            method: "POST",
            data: $scope.seguimiento,
            file: file,
        }).then(function (resultado) {
            $scope.deshabiltarRegistrese = false;
            $uibModalInstance.close(resultado.data);
        }, function (resultado) {
            $scope.deshabiltarRegistrese = false;
            var mensaje = { msn: 'Error: ' + resultado.data.ExceptionMessage, tipo: "alert alert-danger" };
        }, function (evt) {
            //var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
        });
    };
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.validar = function () {
        return $scope.editForm.$valid;
    };
    $scope.validarExtension = function () {
        if ($scope.file) {
            $scope.submitted = true;
            $scope.extension = false;
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
        $scope.errors.PROGRAMAEDIT = '';
    };
    $scope.init();
}])
//Modal Editar otros derechos
.controller('SeguimientoDepartamentoEdicionODCtrl', ['$scope', '$http', '$uibModalInstance', 'Upload', 'tableroOD', function ($scope, $http, $uibModalInstance, Upload, tableroOD) {
    $scope.tableroOD = tableroOD || { idSeguimiento: 0 };
    $scope.habilita = false;

    $scope.init = function () {
        $scope.submitted = false;
    };

    $scope.errors = [];

    $scope.guardar = function () {
        if (!$scope.validar()) return false;

        if ($scope.datos.Programa.length > 1000) {
            $scope.errors.PROGRAMAEDIT = "El programa no debe exceder los 1000 caracteres";
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
}])

.filter('pagination', function () {
    return function (input, start) {
        start = +start;
        return input.slice(start);
    };
})
.directive('ngEnter', function () {
    return function (scope, element, attrs) {
        element.bind("keydown keypress", function (event) {
            if (event.which === 13) {
                scope.$apply(function () {
                    scope.$eval(attrs.ngEnter);
                });
                event.preventDefault();
            }
        });
    };
})
.directive('customPopover', function () {
    return {
        restrict: 'A',
        template: '<span>{{label}}</span>',
        link: function (scope, el, attrs) {
            scope.label = attrs.popoverLabel;
            $(el).popover({
                trigger: 'focus',
                html: true,
                content: attrs.popoverHtml,
                placement: attrs.popoverPlacement
            });
        }
    };
});