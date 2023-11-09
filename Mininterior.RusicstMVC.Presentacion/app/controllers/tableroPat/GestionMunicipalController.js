app.controller('GestionMunicipalController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', '$location', 'ngSettings', 'enviarDatos', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService, $location, ngSettings, enviarDatos) {
    $scope.idTablero = enviarDatos.datos.Id;
    $scope.tablero = enviarDatos.datos;
    if (!enviarDatos.datos.Id) {
        $location.url('/Index/TableroPat/TablerosMunicipio');
    }

    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.derecho = [];
    $scope.derechos = [];
    $scope.tableros = [];
    $scope.vigencias = [];
    $scope.entidades = [];
    $scope.tablerosRC = [];
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
    $scope.maxSize = 100;
    $scope.maxSizeRR = 100;
    $scope.maxSizeRC = 100;
    $scope.bigTotalItems = 0;
    $scope.bigTotalItemsRC = 0;
    $scope.bigTotalItemsRR = 0;
    $scope.bigCurrentPage = 1;
    $scope.bigCurrentPageRC = 1;
    $scope.bigCurrentPageRR = 1;
    $scope.flagVariable = "disabled";
    $scope.activo = false;
    $scope.urlEnvio = '/api/Sistema/Diligenciamiento/EnviarPlan';

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
    $scope.init = function () {
        $scope.showData();
    };

    //---------Metodos para la paginacion
    $scope.pageChanged = function () {
        CargarTableroIndividual();
    };
    $scope.pageChangedRR = function () {
        CargarTableroRR();
    };
    $scope.pageChangedRC = function () {
        CargarTableroRC();
    };
    function CargarTableroIndividual() {
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.tableros = [];
        $scope.cargoDatos = null;
        var url = "";
        getDatos();
        function getDatos() {
            var idbusqueda = 0;
            angular.forEach($scope.derechos, function (der) {
                if (der.DESCRIPCION == $scope.busqueda) {
                    idbusqueda = der.ID;
                }
            });
            url = '/api/TableroPat/CargarTablero/null,' + $scope.bigCurrentPage + ',' + $scope.listaNumRegistros.selectedOption.id + ',0,' + $scope.userName + ',' + $scope.idTablero;
            if ($scope.busqueda) {
                url = '/api/TableroPat/CargarTablero/null,' + $scope.bigCurrentPage + ',' + $scope.listaNumRegistros.selectedOption.id + ',' + idbusqueda + ',' + $scope.userName + ',' + $scope.idTablero;
            }
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.active = 0;
                $scope.cargoDatos = true;
                $scope.tableros = datos.datos;
                $scope.numPages = datos.TotalPages;
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
    };
    function CargarTableroRR() {
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.tablerosRR = [];
        var url = "";
        getDatosRR();
        function getDatosRR() {
            var idbusqueda = 0;
            angular.forEach($scope.derechos, function (der) {
                if (der.DESCRIPCION == $scope.busqueda) {
                    idbusqueda = der.ID;
                }
            });
            url = '/api/TableroPat/CargarTableroRR/null,' + $scope.bigCurrentPageRR + ',' + $scope.listaNumRegistros.selectedOption.id + ',0,' + $scope.userName + ',' + $scope.idTablero;
            if ($scope.busqueda) {
                url = '/api/TableroPat/CargarTableroRR/null,' + $scope.bigTotalItemsRR + ',' + $scope.listaNumRegistros.selectedOption.id + ',' + idbusqueda + ',' + $scope.userName + ',' + $scope.idTablero;
            }
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.tablerosRR = datos.datosRR;
                $scope.bigTotalItemsRR = datos.totalItemsRR;
                $scope.numPagesRR = datos.TotalPagesRR;
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
    };
    function CargarTableroRC() {
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.tablerosRC = [];
        var url = "";
        getDatosRC();
        function getDatosRC() {
            var idbusqueda = 0;
            angular.forEach($scope.derechos, function (der) {
                if (der.DESCRIPCION == $scope.busqueda) {
                    idbusqueda = der.ID;
                }
            });
            url = '/api/TableroPat/CargarTableroRC/null,' + $scope.bigCurrentPageRC + ',' + $scope.listaNumRegistros.selectedOption.id + ',0,' + $scope.userName + ',' + $scope.idTablero;
            if ($scope.busqueda) {
                url = '/api/TableroPat/CargarTableroRC/null,' + $scope.bigCurrentPageRC + ',' + $scope.listaNumRegistros.selectedOption.id + ',' + idbusqueda + ',' + $scope.userName + ',' + $scope.idTablero;
            }
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.tablerosRC = datos.datosRC;
                $scope.bigTotalItemsRC = datos.totalItemsRC;
                $scope.numPagesRC = datos.TotalPagesRC;
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
    };

    $scope.showData = function (mostrarmodal) {
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        $scope.tableros = [];
        $scope.tablerosRR = [];
        $scope.tablerosRC = [];
        $scope.vigencias = [];
        $scope.entidades = [];
        $scope.cargoDatos = null;
        var url = "";
        getDatos();
        function getDatos() {
            var idbusqueda = 0;
            angular.forEach($scope.derechos, function (der) {
                if (der.DESCRIPCION == $scope.busqueda) {
                    idbusqueda = der.ID;
                }
            });
            url = '/api/TableroPat/CargarTablero/null,' + $scope.bigCurrentPage + ',' + $scope.listaNumRegistros.selectedOption.id + ',0,' + $scope.userName + ',' + $scope.idTablero;
            if ($scope.busqueda) {
                url = '/api/TableroPat/CargarTablero/null,' + $scope.bigCurrentPage + ',' + $scope.listaNumRegistros.selectedOption.id + ',' + idbusqueda + ',' + $scope.userName + ',' + $scope.idTablero;
            }
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.active = 0;
                $scope.cargoDatos = true;
                $scope.activo = datos.activo;
                $scope.disabled = $scope.activo ? '' : 'disabled';
                //$scope.esConsulta = $scope.activo ? false : true;
                $scope.derechos = datos.derechos;
                $scope.avance = datos.avance;
                $scope.vigencias = datos.vigencia;
                $scope.Usuario = datos.datosUsuario[0];
                $scope.tableros = datos.datos;
                $scope.tablerosRC = datos.datosRC;
                $scope.tablerosRR = datos.datosRR;

                $scope.bigTotalItems = datos.totalItems;
                $scope.bigTotalItemsRC = datos.totalItemsRC;
                $scope.bigTotalItemsRR = datos.totalItemsRR;

                $scope.numPages = datos.TotalPages;
                $scope.numPagesRC = datos.TotalPagesRC;
                $scope.numPagesRR = datos.TotalPagesRR;
                $scope.urlDerechos = datos.urlDerechos;
                $scope.ActivoEnvioPATPlaneacion = datos.ActivoEnvioPATPlaneacion;
                if ($scope.urlDerechos.length > 0 && mostrarmodal) {
                    $scope.abrirArchivosUrlsDerechos($scope.urlDerechos);
                }
                actualizarPie();
                $scope.ValidarConsulta();

                if ($scope.derechos) {
                    if ($scope.derechos.length == 0 && $scope.busqueda) {
                        $scope.mensajeWarning = "No se encontraron preguntas asociadas a los derechos del tablero " + $scope.idTablero;
                    }
                    if ($scope.tableros.length == 0 && $scope.busqueda) {
                        $scope.mensajeWarning = "No se encontraron resultados para el derecho indicado";
                    }
                }
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
    };
    $scope.init();

    $scope.$watchGroup(['busqueda', 'listaNumRegistros.selectedOption'], function (newValue, oldValue) {
        if (newValue || oldValue) {
            if ($scope.busqueda) {
                $scope.showData(true);
            }
        }
    });

    $scope.generaExcel = function (index) {
        url = $scope.serviceBase + '/api/TableroPat/Municipios/DatosExcel?idMunicipio=' + $scope.Usuario.IdMunicipio + '&idTablero=' + $scope.idTablero;
        window.open(url)

    }

    $scope.Editar = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/MunicipiosPat.html',
            controller: 'MunicipioEdicionCtrl',
            size: 'lg',
            resolve: {
                tablero: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.tableros[index]), esConsulta : $scope.esConsulta };
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
    $scope.EditarRC = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/MunicipiosRCPat.html',
            controller: 'MunicipioEdicionRCCtrl',
            size: 'lg',
            resolve: {
                tablero: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.tablerosRC[index]), esConsulta: $scope.esConsulta };
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
    $scope.EditarRR = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/MunicipiosRRPat.html',
            controller: 'MunicipioEdicionRRCtrl',
            size: 'lg',
            resolve: {
                tablero: function () {
                    var datos = { Usuario: $scope.Usuario, tablero: angular.copy($scope.tablerosRR[index]), esConsulta: $scope.esConsulta };
                    return datos;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (datosResponse) {
                $scope.mensajeWarning = null;
                $scope.mensajeOK = null;
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
                 $scope.showData(false);
             }
           );
    }
    var actualizarPie = function () {

        angular.forEach($scope.avance, function (der) {
            der.dataNecesidad = [der.PINDICATIVA, 100 - der.PINDICATIVA];
            der.dataCompromiso = [der.PCOMPROMISO, 100 - der.PCOMPROMISO];
            der.labelN = ["Necesidad"];
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
    };
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
        modelo.anoTablero = $scope.tablero.Planeacion;
        modelo.idUsuario = $scope.Usuario.Id;
        modelo.Usuario = $scope.Usuario.UserName;
        modelo.tipoEnvio = "PM";

        var modalInstance = $uibModal.open({
            templateUrl: '/app/views/modals/Confirmacion.html',
            controller: 'ModalConfirmacionController',
            resolve: {
                datos: function () {
                    $scope.disabledguardando = 'disabled';
                    var titulo = 'Envio de Tablero PAT';
                    var url = '/api/TableroPat/EnvioTablero';
                    var entity = modelo;
                    var msn = "¿Desea enviar el Tablero PAT?";
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

app.controller('MunicipioEdicionCtrl', ['$scope', 'APIService', '$http', 'tablero', '$uibModalInstance', '$uibModal', '$filter', '$log', 'authService', 'ngSettings', 'Upload', 'UtilsService', function ($scope, APIService, $http, tablero, $uibModalInstance, $uibModal, $filter, $log, authService, ngSettings, Upload, UtilsService) {
    $scope.tablero = tablero.tablero || { ID: 0 };
    $scope.esConsulta = tablero.esConsulta;
    $scope.Usuario = tablero.Usuario;
    $scope.habilita = false;
    $scope.flagVariable = false;
    $scope.accionesAgregadas = [];
    $scope.programasAgregados = [];
    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.init = function () {
        if ($scope.tablero.ID == null) {
            $scope.tablero.ID = 0;
        }
        var url = "/api/TableroPat/DatosInicialesEdicionMunicipio?pregunta=" + $scope.tablero.IDPREGUNTA + "&id=" + $scope.tablero.ID + '&IdUsuario=' + $scope.Usuario.Id + "&Usuario=" + $scope.Usuario.UserName + '&idTablero=' + $scope.tablero.IDTABLERO;
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.activo = datos.activo;
                $scope.disabled = $scope.activo ? '' : 'disabled';
                $scope.programasOferta = datos.programasOferta;
                $scope.totalNecesidades = datos.totalNecesidades;
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

                $scope.activo = $scope.esConsulta ? false : $scope.activo;
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
        $scope.tablero.NombreAdjunto = (!$scope.tablero.NombreAdjunto) ? ($scope.file ? $scope.file.name : "") : $scope.tablero.NombreAdjunto;

        var EstadoEncontro = false;
        var IdEncontro = 0;
        $scope.listafuentesRespuesta = [];

        angular.forEach($scope.tablero.FUENTES, function (fuente) {
            angular.forEach($scope.FuentesPresupuestoRespuesta, function (exitente) {
                if (fuente.Id == exitente.IdFuentePresupuesto) {
                    EstadoEncontro = fuente.check;
                    IdEncontro = fuente.Id;
                }
            });
            if (!EstadoEncontro) {
                $scope.listafuentesRespuesta.push({ "Id": fuente.Id, "insertar": 1 });//Insertar si no lo encontro
            }
        });

        var esta = false;
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

        var url = "/api/TableroPat/ModificarMunicipio";

        //// Cargar los datos de auditoría
        $scope.tablero.AudUserName = authService.authentication.userName;
        $scope.tablero.AddIdent = authService.authentication.isAddIdent;
        $scope.tablero.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.tablero, url);
        servCall.then(function (response) {
            $scope.flagVariable = false;
            if ($scope.file) {
                $scope.tablero.usuario = $scope.tablero.IDUSUARIO;
                $scope.tablero.tablero = $scope.tablero.IDTABLERO;
                $scope.tablero.pregunta = $scope.tablero.IDPREGUNTA;
                $scope.tablero.type = 'GMunicipios';
                $scope.upload($scope.file);
            }
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = data;
        });
    };


    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
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
    $scope.validar = function () {
        return $scope.registerForm.$valid;
    };
    $scope.BorraMensaje = function () {
        $scope.errors.DESCRIPCION = '';
    };

    $scope.VerUnoaUnoSIGO = function () {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/PrecargueSIGO.html',
            controller: 'PrecargueSIGOCtrl',
            size: 'lg',
            resolve: {
                tablero: function () {
                    return datos = { tablero: $scope.tablero, idUsuario: $scope.Usuario.Id };
                }
            },
            backdrop: 'static', keyboard: false
        });
    }

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
        var url = $scope.serviceBase + '/api/TableroPat/DownloadDiligenciamiento?archivo=' + $scope.tablero.NombreAdjunto + '&nombreArchivo=' + $scope.tablero.NombreAdjunto + '&type=GMunicipios&idTablero=' + $scope.tablero.IDTABLERO + '&idPregunta= ' + $scope.tablero.IDPREGUNTA + '&idUsuario=' + $scope.Usuario.Id;
        window.open(url)
    }
}]);

app.controller('PrecargueSIGOCtrl', ['$scope', 'APIService', 'UtilsService', '$filter', '$log', '$uibModalInstance', '$http', 'tablero', 'authService', 'ngSettings', function ($scope, APIService, UtilsService, $filter, $log, $uibModalInstance, $http, tablero, authService, ngSettings) {
    $scope.tablero = tablero.tablero;
    $scope.IdUsuario = tablero.idUsuario;
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.cargoDatos = false;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };
    $scope.isColumnDefs = false;
    $scope.columnDefsFijas = [];

    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };


    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "TipoDocumento", newProperty: "Tipo Documento" },
            { field: "NumeroDocumento", newProperty: "Numero Documento" },
            { field: "NombreVictima", newProperty: "Nombre" },
        ]
    };

    getDatos();

    function getDatos() {
        var url = '/api/TableroPat/PrecargueUnoaUno/?IdUsuario=' + $scope.IdUsuario + '&IdPregunta=' + $scope.tablero.IDPREGUNTA;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            $scope.isGrid = true;
            $scope.gridOptions.data = datos;
            if (!$scope.isColumnDefs) {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, null);
                $scope.isColumnDefs = true;
            } else {
                UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, null, null);
            }
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };
    $scope.cancelar = function () {
        $uibModalInstance.close();
    };
}]);

app.controller('MunicipioEdicionRCCtrl', ['$scope', 'APIService', '$http', 'tablero', '$uibModalInstance', 'authService', function ($scope, APIService, $http, tablero, $uibModalInstance, authService) {
    $scope.tableroRC = tablero.tablero || { ID: 0 };
    $scope.esConsulta = tablero.esConsulta;
    $scope.Usuario = tablero.Usuario;
    $scope.habilita = false;
    $scope.flagVariable = false;
    $scope.accionesRCAgregadas = [];
    $scope.init = function () {
        if ($scope.tableroRC.ID == null) {
            $scope.tableroRC.ID = 0;
        }
        var url = "/api/TableroPat/DatosInicialesEdicionMunicipioRC?pregunta=" + $scope.tableroRC.IDPREGUNTARC + "&id=" + $scope.tableroRC.ID + '&IdUsuario=' + $scope.Usuario.Id + "&Usuario=" + $scope.Usuario.UserName + '&idTablero=' + $scope.tableroRC.IDTABLERO;
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.activo = datos.activo;
                $scope.disabled = $scope.activo ? '' : 'disabled';
                $scope.accionesRCAgregadas = datos.datosAccionesRC;
                angular.forEach($scope.accionesRCAgregadas, function (accionRC) {
                    accionRC.ACTIVO = true;
                });
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.submitted = false;
    };

    $scope.agregarAccionRC = function () {
        $scope.errors.ACCION = '';
        if ($scope.tableroRC.ACCION_RC) {
            if ($scope.tableroRC.ACCION_RC.length > 500) {
                $scope.errors.ACCION = "La acción no debe exceder los 500 caracteres";
                return;
            }
            var accionRCExistente = false;
            angular.forEach($scope.accionesRCAgregadas, function (accion) {
                if (accion.ACCION == $scope.tableroRC.ACCION_RC) {
                    accionRCExistente = true;
                }
            });
            if (!accionRCExistente) {
                $scope.accionesRCAgregadas.push({ ACCION: $scope.tableroRC.ACCION_RC, ACTIVO: true });
            }
            $scope.tableroRC.ACCION_RC = null;
            $("#accion").focus();
        } else {
            $scope.errors.ACCION = "La acción es requerida";
        }
    }
    $scope.borrarAccionRC = function (index) {
        $scope.accionesRCAgregadas[index].ACTIVO = false;
    }

    $scope.errors = [];

    $scope.init();

    $scope.guardar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        if ($scope.tableroRC.ACCION_RC) {
            $scope.errors.ACCION = "Tiene acciones pendientes por agregar";
            return false;
        }
        $scope.habilita = true;
        $scope.flagVariable = true;
        $scope.tableroRC.RespuestaRCPatAccion = $scope.accionesRCAgregadas;
        $scope.tableroRC.IDUSUARIO = $scope.Usuario.Id;
        if ($scope.tableroRC.ID == null) {
            $scope.tableroRC.ID = 0
        }

        var url = "/api/TableroPat/ModificarMunicipioRC";

        //// Cargar los datos de auditoría
        $scope.tableroRC.AudUserName = authService.authentication.userName;
        $scope.tableroRC.AddIdent = authService.authentication.isAddIdent;
        $scope.tableroRC.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.tableroRC, url);
        servCall.then(function (response) {
            $scope.flagVariable = false;
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = data;
        });
    };
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.validar = function () {
        return $scope.registerFormRC.$valid;
    };
    $scope.BorraMensaje = function () {
        $scope.errors.DESCRIPCION = '';
    };
}]);

app.controller('MunicipioEdicionRRCtrl', ['$scope', 'APIService', '$http', 'tablero', '$uibModalInstance', 'authService', function ($scope, APIService, $http, tablero, $uibModalInstance, authService) {
    $scope.tableroRR = tablero.tablero || { ID: 0 };
    $scope.esConsulta = tablero.esConsulta;
    $scope.Usuario = tablero.Usuario;
    $scope.habilita = false;
    $scope.flagVariable = false;
    $scope.accionesRRAgregadas = [];
    $scope.init = function () {
        if ($scope.tableroRR.ID == null) {
            $scope.tableroRR.ID = 0;
        }
        var url = "/api/TableroPat/DatosInicialesEdicionMunicipioRR?pregunta=" + $scope.tableroRR.ID_PREGUNTA_RR + "&id=" + $scope.tableroRR.ID + '&IdUsuario=' + $scope.Usuario.Id + "&Usuario=" + $scope.Usuario.UserName + '&idTablero=' + $scope.tableroRR.ID_TABLERO;
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.activo = datos.activo;
                $scope.accionesRRAgregadas = datos.datosAccionesRR;
                $scope.disabled = $scope.activo ? '' : 'disabled';
                angular.forEach($scope.accionesRRAgregadas, function (accionRR) {
                    accionRR.ACTIVO = true;
                });
                $scope.activo = $scope.esConsulta ? false : $scope.activo;
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.submitted = false;
    };

    $scope.agregarAccionRR = function () {
        $scope.errors.ACCION = '';
        if ($scope.tableroRR.ACCION_RR) {
            if ($scope.tableroRR.ACCION_RR.length > 500) {
                $scope.errors.ACCION_RR = "La acción no debe exceder los 500 caracteres";
                return;
            }
            var accionRRExistente = false;
            angular.forEach($scope.accionesRRAgregadas, function (accion) {
                if (accion.ACCION == $scope.tableroRR.ACCION_RR) {
                    accionRRExistente = true;
                }
            });
            if (!accionRRExistente) {
                $scope.accionesRRAgregadas.push({ ACCION: $scope.tableroRR.ACCION_RR, ACTIVO: true });
            }
            $scope.tableroRR.ACCION_RR = null;
            $("#accion").focus();
        } else {
            $scope.errors.ACCION = "La acción es requerida";
        }
    }
    $scope.borrarAccionRR = function (index) {
        $scope.accionesRRAgregadas[index].ACTIVO = false;
    }

    $scope.errors = [];

    $scope.init();

    $scope.guardar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        if ($scope.tableroRR.ACCION_RR) {
            $scope.errors.ACCION = "Tiene acciones pendientes por agregar";
            return false;
        }
        $scope.habilita = true;
        $scope.flagVariable = true;
        $scope.tableroRR.RespuestaRRPatAccion = $scope.accionesRRAgregadas;
        $scope.tableroRR.IDUSUARIO = $scope.Usuario.Id;
        if ($scope.tableroRR.ID == null) {
            $scope.tableroRR.ID = 0
        }

        var url = "/api/TableroPat/ModificarMunicipioRR";

        //// Cargar los datos de auditoría
        $scope.tableroRR.AudUserName = authService.authentication.userName;
        $scope.tableroRR.AddIdent = authService.authentication.isAddIdent;
        $scope.tableroRR.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.tableroRR, url);
        servCall.then(function (response) {
            $scope.flagVariable = false;
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = data;
        });
    };
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.validar = function () {
        return $scope.registerFormRR.$valid;
    };
    $scope.BorraMensaje = function () { // $scope que acciona el ng-kepress
        $scope.errors.DESCRIPCION = '';
    };
}])
