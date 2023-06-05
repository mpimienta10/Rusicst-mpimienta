app.controller('SeguimientoMunicipalController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', '$location', 'ngSettings', 'enviarDatos', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService, $location, ngSettings, enviarDatos) {
    $scope.idTablero = enviarDatos.datos.Id;
    if (!enviarDatos.datos.Id) {
        $location.url('/Index/TableroPat/TablerosSeguimientoMunicipio');
    }
    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.autenticacion = authService.authentication;
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
            $scope.disabled = $scope.activo ? '' : 'disabled';
            $scope.ActivoEnvioPATSeguimiento = false;
        }
    }
    $scope.busqueda;
    $scope.derecho = [];
    $scope.derechos = [];
    $scope.avance = [];
    $scope.tableros = [];
    $scope.vigencias = [];
    $scope.entidades = [];
    $scope.tablerosRC = [];
    $scope.tablerosRR = [];
    $scope.tablerosOD = [];
    $scope.listaNumRegistros = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100];

    $scope.maxSize = 15;
    $scope.maxSizeRR = 15;
    $scope.cantidadMostrar = 20;
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
        $scope.tableros = [];
        $scope.tablerosRR = [];
        $scope.tablerosRC = [];
        $scope.vigencias = [];
        $scope.entidades = [];
        $scope.cargoDatos = null;
        $scope.mensajeOK = null;
        $scope.mensajeWarning = null;
        //$scope.showWait();
        var url = "";
        var idbusqueda = 0;
        angular.forEach($scope.derechos, function (der) {
            if (der.DESCRIPCION == $scope.busqueda) {
                idbusqueda = der.ID;
            }
        });
        url = '/api/TableroPat/CargarTableroSeguimiento/null,' + $scope.bigCurrentPage + ',' + $scope.cantidadMostrar + ',0,' + $scope.userName + ',' + $scope.idTablero;
        if ($scope.busqueda) {
            url = '/api/TableroPat/CargarTableroSeguimiento/null,' + $scope.bigCurrentPage + ',' + $scope.cantidadMostrar + ',' + idbusqueda + ',' + $scope.userName + ',' + $scope.idTablero;
        }
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.active = 0;
            $scope.cargoDatos = true;
            $scope.activo = datos.activo;
            $scope.disabled = $scope.activo ? '' : 'disabled';
            $scope.esConsulta = $scope.activo ? false : true;
            $scope.avance = datos.datos;
            $scope.tableros = datos.datos1;
            $scope.tablerosInformacionNacional = datos.InformacionNacional;
            //$scope.tablerosInformacionNacional = [{"IdDerecho":8,"Componente":"Asistencia y Atención","Medida":"Salud","Programa":"Número de personas afiliadas al Sistema General de Seguridad Social en Salud.","EntidadNacional":"Ministerio de Salud","CantidadEjecutada":4,"IdMunicipio":5001,"Municipio":"Medellín","Departamento":"Antioquia"},{"IdDerecho":8,"Componente":"Asistencia y Atención","Medida":"Salud","Programa":"Número de personas afiliadas al Sistema General de Seguridad Social en Salud.","EntidadNacional":"Ministerio de Salud","CantidadEjecutada":1387,"IdMunicipio":5001,"Municipio":"Medellín","Departamento":"Antioquia"}];
            $scope.derechos = datos.derechos;
            $scope.vigencias = datos.vigencia;
            $scope.anoSeguimiento = datos.vigencia[0].Ano;
            $scope.Usuario = datos.datos4[0];
            $scope.tablerosRC = datos.datosRC;
            $scope.tablerosRR = datos.datoRR;
            $scope.tablerosOD = datos.datosOD;
            $scope.bigTotalItems = datos.totalItems;
            $scope.numPages = datos.TotalPages;
            $scope.bigTotalItemsRC = datos.totalItemsRC;
            $scope.numPagesRC = datos.TotalPagesRC;
            $scope.numPagesRR = datos.TotalPagesRR;
            $scope.bigTotalItemsRR = datos.totalItemsRR;
            $scope.nombreDerecho = datos.nombreDerecho;
            $scope.numSeguimiento = datos.numSeguimiento;
            $scope.ActivoEnvioPATSeguimiento = datos.ActivoEnvioPATSeguimiento;
            if ($scope.numSeguimiento == null) { $scope.numSeguimiento = 2; }
            $scope.tablero = datos.idTablero;
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
        //$scope.closeWait();
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

    $scope.init();
    $scope.started = true;
    $scope.$watchGroup(['busqueda', 'cantidadMostrar'], function (newValue, oldValue) {
        if (newValue || oldValue) {
            if ($scope.busqueda) {
                $scope.showData();
            }
        }
    });

    $scope.Editar = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/SeguimientoMunicipiosPat.html',
            controller: 'SeguimientoMunicipioEdicionCtrl',
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
    $scope.EditarRC = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/SeguimientoMunicipiosRC.html',
            controller: 'SeguimientoMunicipioEdicionRCCtrl',
            size: 'lg',
            backdrop: 'static',
            keyboard: false,
            resolve: {
                tableroRC: function () {
                    var datos = { Usuario: $scope.Usuario, tableroRC: angular.copy($scope.tablerosRC[index]), activo: $scope.activo, numSeguimiento: $scope.numSeguimiento, serviceBase: $scope.serviceBase, anoSeguimiento: $scope.anoSeguimiento };
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
    $scope.EditarRR = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/SeguimientoMunicipiosRR.html',
            controller: 'SeguimientoMunicipioEdicionRRCtrl',
            size: 'lg',
            backdrop: 'static',
            keyboard: false,
            resolve: {
                tableroRR: function () {
                    var datos = { Usuario: $scope.Usuario, tableroRR: angular.copy($scope.tablerosRR[index]), activo: $scope.activo, numSeguimiento: $scope.numSeguimiento, serviceBase: $scope.serviceBase, anoSeguimiento: $scope.anoSeguimiento };
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
    $scope.agregarOD = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/SeguimientoMunicipiosAgregarOD.html',
            controller: 'SeguimientoMunicipioAgregarODCtrl',
            size: 'lg',
            backdrop: 'static',
            keyboard: false,
            resolve: {
                tablero: function () {
                    var datos = { Usuario: $scope.Usuario, idTablero: $scope.idTablero, anoSeguimiento: $scope.anoSeguimiento };
                    return datos;
                }
            },
        });
        modalInstance.result.then(
            function (datosResponse) {
                $scope.mensajeWarning = null;
                $scope.mensajeOK = null;
                if (datosResponse.estado == 1 || datosResponse.estado == 2) {
                    mostrarMensaje("El tablero se actualizó correctamente");
                    $scope.init();
                }
                else {
                    mostrarMensaje("No se procesó la Pregunta correctamente. " + datosResponse.respuesta);
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
                    var url = '/api/TableroPat/EliminarMedidaOD';
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
                        mostrarMensaje("El registro se eliminó correctamente");
                    }
                    else {
                        mostrarMensaje("No se eliminó correctamente el derecho. " + datosResponse.respuesta);
                    }
                }
            }
        );
    }

    $scope.EditarOD = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'editarOD.html',
            controller: 'SeguimientoMunicipioEdicionODCtrl',
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

    $scope.generaExcel = function (index) {
        url = $scope.serviceBase + '/api/TableroPat/SeguimientoMunicipios/DatosExcel?idUsuario=' + $scope.Usuario.Id + '&idTablero=' + $scope.idTablero;
        window.open(url)

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
        modelo.anoTablero = $scope.vigencias[0].Ano;
        modelo.idUsuario = $scope.Usuario.Id;
        modelo.Usuario = $scope.Usuario.UserName;
        modelo.tipoEnvio = "SM" + $scope.numSeguimiento;

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

app.controller('SeguimientoMunicipioEdicionCtrl', ['$scope', 'APIService', '$http', 'Upload', 'tablero', '$uibModal', '$uibModalInstance', '$filter', '$log', 'authService', '$timeout', 'UtilsService', function ($scope, APIService, $http, Upload, tablero, $uibModal, $uibModalInstance, $filter, $log, authService, $timeout, UtilsService) {
    $scope.tablero = tablero.tablero || { ID: 0 };
    $scope.Usuario = tablero.Usuario;
    $scope.activo = tablero.activo;
    $scope.serviceBase = tablero.serviceBase;
    $scope.idTablero = tablero.idTablero;
    $scope.seguimiento = tablero.numSeguimiento;
    $scope.anoSeguimiento = tablero.anoSeguimiento;
    $scope.habilita = false;
    $scope.programasAgregados1 = [];
    $scope.programasAgregados2 = [];
    $scope.programasAgregados = [];
    $scope.AccionesAgregados1 = [];
    $scope.AccionesAgregados2 = [];
    $scope.datosRespuesta;
    $scope.verListadoSigo = false;
    $scope.replaced1 = false;
    $scope.replaced2 = false;
    $scope.replaced3 = false;
    $scope.replaced4 = false;
    $scope.changed = false;
    $scope.flagVariable = false;
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.mensajeErrorForm = "Existen errores en el formulario. Por favor verifique e intente de nuevo.";
    $scope.errors = [];

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


    $scope.descargar = function (index, semestre) {
        var url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.datosRespuesta.AdjuntoSeguimiento + '&nombreArchivo=' + $scope.datosRespuesta.AdjuntoSeguimiento + '&type=D&idTablero=' + $scope.idTablero + '&idPregunta= ' + $scope.tablero.ID + '&idUsuario=' + $scope.Usuario.Id + '&NumSeguimiento=1';
        if (semestre == 2) {
            url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.datosRespuesta.NombreAdjuntoSegundo + '&nombreArchivo=' + $scope.datosRespuesta.NombreAdjuntoSegundo + '&type=D2&idTablero=' + $scope.idTablero + '&idPregunta= ' + $scope.tablero.ID + '&idUsuario=' + $scope.Usuario.Id + '&NumSeguimiento=2';
        }
        window.open(url)
    }
    $scope.VerMas = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/tableroPat/modals/SeguimientoMunicipiosPatAccYProg.html',
            controller: 'SeguimientoMunicipioVerAccYProCtrl',
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
        if ($scope.tablero.ID == null) {
            $scope.tablero.ID = 0;
        }
        var url = '/api/TableroPat/DatosInicialesSeguimientoMunicipio?idPregunta=' + $scope.tablero.ID + '&IdUsuario=' + $scope.Usuario.Id + '&idTablero=' + $scope.idTablero + '&idMunicipio=' + $scope.Usuario.IdMunicipio + '&numSeguimiento=' + $scope.seguimiento + '&idDerecho=' + $scope.tablero.IdDerecho;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.datosRespuesta = datos.datosRespuesta[0];
            $scope.totalNecesidades = datos.totalNecesidades;
            $scope.programasAgregados = datos.datosProgramas;//si no tiene seguimiento y se seguimiento 1: se trae la informacion de planeacion, pero si es seguimiento 2 trae los programas de seguimiento 1
            $scope.programasSIGO = datos.programasSIGO;

            angular.forEach($scope.programasAgregados, function (programa) {
                if (programa.NumeroSeguimiento == 2) {
                    //si ya tiene programas para el seguimiento 2, es que ya guardo y no debe precargar nada mas.
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
            if ($scope.seguimiento == 2 && $scope.programasAgregados2.length ==0) {
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

            if ($scope.programasAgregados2.length == 0 && $scope.seguimiento == 2) {
                angular.forEach($scope.programasAgregados1, function (programa) {
                    $scope.programasAgregados2.push({ PROGRAMA: programa.PROGRAMA, IdSeguimiento: 0, numeroSeguimiento: 2 });
                });
            }
            $scope.datosSegGobernaciones = datos.datosSegGobernaciones;
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

            if ($scope.datosRespuesta.IdSeguimiento == 0) {
                $scope.replaced1 = true;
                $scope.replaced2 = true;
                $scope.replaced3 = true;
                $scope.replaced4 = true;
                $scope.datosRespuesta.CompromisoPrimerSemestre = "";
                $scope.datosRespuesta.PresupuestoPrimerSemestre = "";
                $scope.datosRespuesta.CompromisoSegundoSemestre = "";
                $scope.datosRespuesta.PresupuestoSegundoSemestre = "";
                $scope.datosRespuesta.CompromisoTotal = "";
                $scope.datosRespuesta.PresupuestoTotal = "";
                if (!$scope.datosRespuesta.CompromisoDefinitivo || $scope.datosRespuesta.CompromisoDefinitivo == null) {
                    $scope.datosRespuesta.CompromisoDefinitivo = $scope.datosRespuesta.RespuestaCompromiso;
                }
                if (!$scope.datosRespuesta.PresupuestoDefinitivo || $scope.datosRespuesta.PresupuestoDefinitivo == null) {
                    $scope.datosRespuesta.PresupuestoDefinitivo = $scope.datosRespuesta.Presupuesto;
                }
            } else if ($scope.seguimiento == 1) {
                $scope.replaced3 = true;
                $scope.replaced4 = true;
                $scope.datosRespuesta.CompromisoSegundoSemestre = 0;
                $scope.datosRespuesta.PresupuestoSegundoSemestre = 0;
                if ($scope.datosRespuesta.CompromisoDefinitivo == null) {
                    $scope.datosRespuesta.CompromisoDefinitivo = $scope.datosRespuesta.RespuestaCompromiso;
                }
                if ($scope.datosRespuesta.PresupuestoDefinitivo == null) {
                    $scope.datosRespuesta.PresupuestoDefinitivo = $scope.datosRespuesta.Presupuesto;
                }
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
    };
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
                console.log(datosResponse);
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
                console.log(datosResponse);
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
        $scope.extension2 = false;
        if (!$scope.validar()) return false;
        if (!$scope.validarExtension()) return false;
        $scope.habilita = true;
        $scope.flagVariable = true;
        $scope.mensajeErrorForm = "";
        $scope.restoreDefaultValues();
        $scope.seguimiento = {};
        $scope.seguimiento.IdSeguimiento = $scope.tablero.IdSeguimiento;
        $scope.seguimiento.IdPregunta = $scope.tablero.ID;
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

        $scope.seguimiento.seguimiento = $scope.datosRespuesta.seguimiento;
        $scope.seguimiento.NombreAdjunto = (!$scope.datosRespuesta.AdjuntoSeguimiento) ? ($scope.file ? $scope.file.name : "") : $scope.datosRespuesta.AdjuntoSeguimiento;
        $scope.seguimiento.NombreAdjuntoSegundo = (!$scope.datosRespuesta.NombreAdjuntoSegundo) ? ($scope.file2 ? $scope.file2.name : "") : $scope.datosRespuesta.NombreAdjuntoSegundo;
        $scope.seguimiento.SeguimientoProgramas = [];
        angular.forEach($scope.programasAgregados1, function (pro) {
            $scope.seguimiento.SeguimientoProgramas.push({ PROGRAMA: pro.PROGRAMA, NumeroSeguimiento: 1 });
        });
        angular.forEach($scope.programasAgregados2, function (pro) {
            $scope.seguimiento.SeguimientoProgramas.push({ PROGRAMA: pro.PROGRAMA, NumeroSeguimiento: 2 });
        });

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
            if ($scope.file) { $scope.upload($scope.file, 1); }
            if ($scope.file2) { $scope.upload($scope.file2, 2); }
            //uploadFileSeguimiento(data.d.idTablero, data.d.usuario, data.d.idPregunta, "D");
            $scope.flagVariable = false;
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.message;
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
    $scope.validar = function () {
        console.log($scope.registerForm.$error);
        return $scope.registerForm.$valid;
    };
    $scope.BorraMensaje = function () { // $scope que acciona el ng-kepress
        $scope.errors.DESCRIPCION = '';
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
            console.log('progress: ' + progressPercentage + '% ' + evt.config.data.file.name);
        });
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
            controller: 'SeguimientoMunicipioDetalleProgramaSIGOCtrl',
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
            controller: 'SeguimientoMunicipioDetalleProgramaSIGOCtrl',
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
app.controller('SeguimientoMunicipioDetalleProgramaSIGOCtrl', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModalInstance', 'authService', 'ngSettings', 'enviarDatos', 'programa', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModalInstance, authService, ngSettings, enviarDatos, programa) {
    $scope.programa = programa;
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
}])

//Modal de edicion de programas en el tab de todos los derechos
app.controller('SeguimientoMunicipioEdicionProgramaCtrl', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModalInstance', 'authService', 'ngSettings', 'enviarDatos', 'programa', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModalInstance, authService, ngSettings, enviarDatos, programa) {
    $scope.datos = programa || { IdSeguimientoPrograma: 0 };
    $scope.habilita = false;
    $scope.accionesRCAgregadas = [];
    $scope.init = function () {
        $scope.submitted = false;
    };
    $scope.errors = [];
    $scope.guardar = function () {
        if (!$scope.validar()) return false;
        if ($scope.datos.PROGRAMA.length > 1000) {
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

//// Modal RC
app.controller('SeguimientoMunicipioEdicionRCCtrl', ['$scope', 'APIService', 'UtilsService', 'Upload', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$uibModalInstance', 'authService', 'ngSettings', 'enviarDatos', 'tableroRC', function ($scope, APIService, UtilsService, Upload, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $uibModalInstance, authService, ngSettings, enviarDatos, tableroRC) {
    $scope.Usuario = tableroRC.Usuario;
    $scope.tableroRC = tableroRC.tableroRC || { IdPregunta: 0 };
    $scope.activo = tableroRC.activo;
    $scope.flagVariable = false;
    $scope.serviceBase = tableroRC.serviceBase;
    $scope.seguimiento = tableroRC.numSeguimiento;
    $scope.anoSeguimiento = tableroRC.anoSeguimiento;
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.adjunto = ($scope.tableroRC.NombreAdjunto != '' && $scope.tableroRC.NombreAdjunto != null) ? true : false;
    $scope.habilita = false;
    $scope.borrarAdjunto = function () {
        $scope.tableroRC.NombreAdjunto = "";
        $scope.adjunto = false;
    }
    $scope.errors = [];


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

    $scope.guardar = function () {
        $scope.submitted = true;
        $scope.extension = false;
        if (!$scope.validarExtension()) return false;
        if (!$scope.validar()) return false;
        $scope.habilita = true;
        $scope.flagVariable = true;
        $scope.mensajeErrorForm = "";
        $scope.seguimiento = {};
        $scope.seguimiento.IdSeguimientoRC = $scope.tableroRC.IdSeguimiento;
        $scope.seguimiento.IdPregunta = $scope.tableroRC.IdPregunta;
        $scope.seguimiento.IdRespuestaRC = $scope.tableroRC.IdRespuesta;
        $scope.seguimiento.IdUsuario = $scope.Usuario.Id;
        $scope.seguimiento.IdTablero = $scope.tableroRC.IdTablero;
        $scope.seguimiento.AvancePrimer = $scope.tableroRC.AvancePrimerSemestreAlcaldia ? $scope.tableroRC.AvancePrimerSemestreAlcaldia : "";
        $scope.seguimiento.AvanceSegundo = $scope.tableroRC.AvanceSegundoSemestreAlcaldia ? $scope.tableroRC.AvanceSegundoSemestreAlcaldia : "";
        $scope.seguimiento.NombreAdjunto = document.getElementById("fileSeguimiento") != null ? document.getElementById("fileSeguimiento").files.length > 0 ? document.getElementById("fileSeguimiento").files[0].name : "" : $scope.datosRespuesta.ADJUNTO_SEGUIMIENTO;

        var url = "/api/TableroPat/RegistrarSeguimientoRC";

        //// Cargar los datos de auditoría
        $scope.seguimiento.AudUserName = authService.authentication.userName;
        $scope.seguimiento.AddIdent = authService.authentication.isAddIdent;
        $scope.seguimiento.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.seguimiento, url);
        servCall.then(function (response) {
            $scope.flagVariable = false;
            $scope.deshabiltarRegistrese = false;
            $scope.seguimiento.usuario = $scope.seguimiento.IdUsuario;
            $scope.seguimiento.tablero = $scope.seguimiento.IdTablero;
            $scope.seguimiento.pregunta = $scope.seguimiento.IdPregunta;
            $scope.seguimiento.type = 'RC';
            $scope.upload($scope.file);
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.message;
        });
    };
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
            //console.log('progress: ' + progressPercentage + '% ' + evt.config.data.file.name);
        });
    };
    $scope.descargar = function (index) {
        var url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.tableroRC.NombreAdjunto + '&nombreArchivo=' + $scope.tableroRC.NombreAdjunto + '&type=RC&idTablero=' + $scope.tableroRC.IdTablero + '&idPregunta= ' + $scope.tableroRC.IdPregunta + '&idUsuario=' + $scope.Usuario.Id;
        window.open(url)
    }
}])

//// modal RR
app.controller('SeguimientoMunicipioEdicionRRCtrl', ['$scope', 'APIService', 'UtilsService', 'Upload', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$uibModalInstance', 'authService', 'ngSettings', 'enviarDatos', 'tableroRR', function ($scope, APIService, UtilsService, Upload, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $uibModalInstance, authService, ngSettings, enviarDatos, tableroRR) {
    $scope.Usuario = tableroRR.Usuario;
    $scope.tableroRR = tableroRR.tableroRR || { IdPregunta: 0 };
    $scope.activo = tableroRR.activo;
    $scope.seguimiento = tableroRR.numSeguimiento;
    $scope.anoSeguimiento = tableroRR.anoSeguimiento;
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.serviceBase = tableroRR.serviceBase;
    $scope.habilita = false;
    $scope.adjunto = ($scope.tableroRR.NombreAdjunto != '' && $scope.tableroRR.NombreAdjunto != null) ? true : false;
    $scope.errors = [];
    $scope.borrarAdjunto = function () {
        $scope.tableroRR.NombreAdjunto = "";
        $scope.adjunto = false;
    }

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

    $scope.guardar = function () {
        $scope.submitted = true;
        $scope.extension = false;
        if (!$scope.validarExtension()) return false;
        if (!$scope.validar()) return false;
        $scope.habilita = true;
        $scope.flagVariable = true;
        $scope.mensajeErrorForm = "";
        if ($scope.tableroRR.ID == null) {
            $scope.tableroRR.ID = 0
        }
        $scope.seguimiento = {};
        $scope.seguimiento.IdSeguimientoRR = $scope.tableroRR.IdSeguimiento;
        $scope.seguimiento.IdPregunta = $scope.tableroRR.Id;
        $scope.seguimiento.IdUsuario = $scope.Usuario.Id;
        $scope.seguimiento.IdTablero = $scope.tableroRR.IdTablero;
        $scope.seguimiento.AvancePrimer = $scope.tableroRR.AvancePrimerSemestreAlcaldia ? $scope.tableroRR.AvancePrimerSemestreAlcaldia : "";
        $scope.seguimiento.AvanceSegundo = $scope.tableroRR.AvanceSegundoSemestreAlcaldia ? $scope.tableroRR.AvanceSegundoSemestreAlcaldia : "";
        $scope.seguimiento.NombreAdjunto = document.getElementById("fileSeguimiento") != null ? document.getElementById("fileSeguimiento").files.length > 0 ? document.getElementById("fileSeguimiento").files[0].name : "" : $scope.datosRespuesta.ADJUNTO_SEGUIMIENTO;

        var url = "/api/TableroPat/RegistrarSeguimientoRR";

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
            $scope.seguimiento.type = 'RR';
            $scope.upload($scope.file);
            $scope.flagVariable = false;
            $uibModalInstance.close(response.data);
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.message;
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
            //console.log('progress: ' + progressPercentage + '% ' + evt.config.data.file.name);
        });
    };
    $scope.descargar = function (index) {
        var url = $scope.serviceBase + '/api/TableroPat/Download?archivo=' + $scope.tableroRR.NombreAdjunto + '&nombreArchivo=' + $scope.tableroRR.NombreAdjunto + '&type=RR&idTablero=' + $scope.tableroRR.IdTablero + '&idPregunta= ' + $scope.tableroRR.Id + '&idUsuario=' + $scope.Usuario.Id;
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

//// Modal Agregar otros derechos
app.controller('SeguimientoMunicipioAgregarODCtrl', ['$scope', 'APIService', 'UtilsService', 'Upload', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$uibModalInstance', 'authService', 'ngSettings', 'enviarDatos', 'tablero', function ($scope, APIService, UtilsService, Upload, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $uibModalInstance, authService, ngSettings, enviarDatos, tablero) {
    $scope.Usuario = tablero.Usuario;
    $scope.idTablero = tablero.idTablero;
    $scope.datos = {};
    $scope.habilita = false;
    $scope.flagVariable = false;
    $scope.derecho = [];
    $scope.listaMapa = [];
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
        var url = '/api/TableroPat/DatosInicialesEdicionSeguimientoMunicipioOD?idTablero=' + $scope.idTablero;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.listaDerechos = datos.listaDerechos;
            $scope.listaUnidades = datos.listaUnidades;
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
    $scope.init();
    $scope.guardar = function () {
        $scope.submitted = true;
        $scope.extension = false;
        $scope.error = null;
        if (!$scope.validarExtension()) return false;
        if (!$scope.validar()) return false;
        if ($scope.listaMapa.length == 0) {
            $scope.error = "Debe seleccionarse por lo menos una medida para poder agregar la información";
            return false;
        }
        $scope.flagVariable = true;
        $scope.MedidasOD = [];
        angular.forEach($scope.listaMapa, function (medida, key) {

            var medidaOD = { IdSeguimiento: 0, IdMedida: medida.IdMedida, IdDerecho: medida.IdDerecho, IdComponente: medida.IdComponente };

            $scope.MedidasOD.push(medidaOD);
        });
        console.log($scope.unidad);
        console.log($scope.unidad.ID);
        $scope.seguimientoOD = {};
        $scope.seguimientoOD.IdUsuario = $scope.Usuario.Id;
        $scope.seguimientoOD.IdTablero = $scope.idTablero;
        $scope.seguimientoOD.IdSeguimiento = 0;
        $scope.seguimientoOD.Programa = $scope.programa;
        $scope.seguimientoOD.Accion = $scope.accion;
        $scope.seguimientoOD.NumSeguimiento = $scope.seguimiento;
        $scope.seguimientoOD.IdUnidad = $scope.unidad.Id;
        $scope.seguimientoOD.Presupuesto = $scope.presupuesto;
        $scope.seguimientoOD.Observaciones = $scope.observaciones;
        $scope.seguimientoOD.NombreAdjunto = $scope.file ? $scope.file.name : "";
        $scope.seguimientoOD.SeguimientoOtrosDerechosMedidas = $scope.MedidasOD;

        $scope.habilita = true;

        var url = "/api/TableroPat/RegistrarSeguimientoOD";

        //// Cargar los datos de auditoría
        $scope.seguimientoOD.AudUserName = authService.authentication.userName;
        $scope.seguimientoOD.AddIdent = authService.authentication.isAddIdent;
        $scope.seguimientoOD.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.seguimientoOD, url);
        servCall.then(function (response) {
            if ($scope.file) {
                $scope.upload($scope.file);
                $scope.deshabiltarRegistrese = false;

                $scope.seguimiento = [];
                $scope.seguimiento.usuario = $scope.seguimientoOD.IdUsuario;
                $scope.seguimiento.tablero = $scope.seguimientoOD.IdTablero;
                $scope.seguimiento.pregunta = response.data.id;//como no se tiene pregunta se guarda con el idSeguimiento
                $scope.seguimiento.type = 'OD';
                $scope.upload($scope.file);
                $scope.flagVariable = false;
                $uibModalInstance.close(response.data);
            } else {
                $uibModalInstance.close(response.data);
            }
        }, function (error) {
            $scope.flagVariable = false;
            $scope.errorgeneral = error.message;
        });
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
            //console.log('progress: ' + progressPercentage + '% ' + evt.config.data.file.name);
        });
    };
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.validar = function () {
        console.log($scope.editForm.$error);
        return $scope.editForm.$valid;
    };
    $scope.BorraMensaje = function () { // $scope que acciona el ng-kepress
        $scope.errors.PROGRAMAEDIT = '';
    };
}])
//Modal Editar otros derechos
app.controller('SeguimientoMunicipioEdicionODCtrl', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', 'ngSettings', 'enviarDatos', 'tableroOD', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService, ngSettings, enviarDatos, tableroOD) {
    //.controller('SeguimientoMunicipioEdicionODCtrl', ['$scope', '$http', '$uibModalInstance', 'Upload', 'tableroOD', function ($scope, $http, $uibModalInstance, Upload, tableroOD) {
    $scope.tableroOD = tablero.tableroOD || { idSeguimiento: 0 };
    $scope.Usuario = tablero.Usuario;
    $scope.habilita = false;
    $scope.flagVariable = false;

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
    ;

//// modal VER Observaciones y Programas
app.controller('SeguimientoMunicipioVerAccYProCtrl', ['$scope', 'APIService', 'UtilsService', 'Upload', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModalInstance', 'authService', 'ngSettings', 'enviarDatos', 'accProg', function ($scope, APIService, UtilsService, Upload, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModalInstance, authService, ngSettings, enviarDatos, accProg) {
    $scope.accProg = { Observaciones: accProg.accProg.Observaciones, Programas: accProg.accProg.Programas}// accProg.accProg || { IdPregunta: 0 };
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
}])
