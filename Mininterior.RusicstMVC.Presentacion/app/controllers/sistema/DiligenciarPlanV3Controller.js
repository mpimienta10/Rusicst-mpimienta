app.controller('DiligenciarPlanV3Controller', ['$scope', 'APIService', '$stateParams', '$location', '$log', '$sce', 'ngSettings', 'Upload', '$uibModal', 'UtilsService', 'authService', '$filter', function ($scope, APIService, $stateParams, $location, $log, $sce, ngSettings, Upload, $uibModal, UtilsService, authService, $filter) {
    //===== Declaración de Variables ======================
    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.autenticacion = authService.authentication;

    $scope.plan = {};
    $scope.plan.IdPlan = parseFloat($stateParams.IdPlan);
    $scope.plan.IdUsuario = null;
    $scope.plan.userName = $scope.autenticacion.userName;

    $scope.cargoDatos = null;
    $scope.datos = [];
    $scope.datosPDF = [];
    $scope.datosGuardar = [];

    $scope.listaAvances = {};
    $scope.listaAutoeva = {};
    $scope.listaRecursos = {};

    $scope.openFile = false;
    $scope.fileIsVacio = true;
    $scope.fileLocation = '';

    $scope.cssClass;

    $scope.guardando = false;
    $scope.enviando = false;

    //$scope.maxDate = new Date();
    //cambios de la unidad de victimas realizado por la ingeniera Vilma Rodriguez
    $scope.annoActual = (new Date()).getFullYear();
    //$scope.maxDate = new Date((parseInt($scope.annoActual)), 11, 31, 18, 59, 59);//ESTE LO DEJA EN UN FORMATO QUE NO INTERPRETA BIEN LA FECHA EN LAS VALIDACIONES DEL blacklist
    $scope.maxDate = $scope.annoActual + 1 + '-12-31';
    //fin cambios de la unidad de victimas

    $scope.mensajeEnvioPlan = '';
    //$scope.progreso = 0;
    //$scope.activo = false;

    //$scope.filePlan;

    $scope.url = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/GuardarDiligenciamientoPlan';
    $scope.urlEnvio = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/EnviarPlan';

    $scope.listaArchivos = [];
    $scope.extensionesPermitidas = ['.docx', '.doc', '.xls', '.xlsx', '.ppt', '.pptx',  //De microsoft
        '.pdf', '.txt',                                                             //Varias
        '.bmp', '.jpg', '.gif', '.jpg', '.jpeg', '.tif', '.tiff', '.png'            //Imágenes
        , '.rar', '.zip', '.7z'                                                      //Comprimidos
    ];

    UtilsService.getDatosUsuarioAutenticado().respuesta().then(function (respuesta) {

        if (angular.isDefined($stateParams.IdUsuario) && $stateParams.IdUsuario == "null") {
            $scope.plan.IdUsuario = respuesta.Id;
        } else {
            $scope.plan.IdUsuario = $stateParams.IdUsuario;
        }

        getDatos();
        getDatosPDF();
    });



    //========================Cerrar archivo adjunto ===================================
    $scope.cerrar = function () {
        $scope.isCerrando = true;
        var mensaje = { msn: "¿Esta seguro de eliminar el archivo: '" + $scope.fileLocation + "'?", tipo: "alert alert-danger" };
        openConfirmacion(mensaje);
    }

    //========================VALIDAR ARCHIVO ADJUNTO===================================
    $scope.validarArchivo = function (file) {
        var respuestaValidarArchivo = true;
        $scope.datos.deleteFile = false;
        //$scope.fileLocation = file.name;
        var indexUltimoPunto = file.name.lastIndexOf(".");
        if (indexUltimoPunto != -1) {
            var extension = file.name.slice(indexUltimoPunto);
            extension = extension.toLowerCase();
            if ($scope.extensionesPermitidas.indexOf(extension) === -1) {
                var mensaje = { msn: "La extensión '" + extension + "' no es permitida", tipo: "alert alert-danger" };
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

        function quitarArchivoAdjunto() {
            $scope.datos.file = '';
            $scope.datos.deleteFile = true;
        }

        return respuestaValidarArchivo;
    }


    //-----------------------OBTENER SECCIONES Y Recomendaciones----------------------------------

    //getDatosRecursos();

    function getMensajeFinalizacionPlan() {
        var url = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/MensajeEnvioPlan';
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.mensajeEnvioPlan = response;
        }, function (error) {
        });
    };

    function getDatosPlan() {
        var url = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ObtenerDatosPlan?idPlan=' + $scope.plan.IdPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.datosPlan = response;

            var annoEncuesta = $scope.datosPlan.NombreEncuesta.match(/\d+/)[0]; // la fecha maxima siempre debe ser 12/31 del año que procede a la encuesta, ej: 2017-I, 2017-II : MAX: 12/31/2018

            //.match(/\d+/)[0]

            //$scope.maxDate = new Date((parseInt(annoEncuesta) + 1), 11, 31, 18, 59, 59);

        }, function (error) {
        });
    };

    function getActivacionPlan() {
        var url = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ValidarDiligenciamientoPlan?idPlan=' + $scope.plan.IdPlan + '&idUsuario=' + $scope.plan.IdUsuario;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.activo = response;
        }, function (error) {
        });
    };

    function getRutaPlan() {
        var url = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ArchivoFinalizacionPlan?idPlan=' + $scope.plan.IdPlan + '&idUsuario=' + $scope.plan.IdUsuario;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.fileLocation = response;
            $scope.fileIsVacio = !$scope.fileLocation.length > 0;
        }, function (error) {
        });
    };

    function getDatos() {

        $scope.listaSeccionesUnica = [];
        $scope.listaIdsObjetivos = [];
        $scope.seccion = "";

        var url = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoSeccionesPlan?idPlan=' + $scope.plan.IdPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.cargoDatos = true;

            angular.forEach(response, function (item, key) {
                if ($scope.seccion == "" || $scope.seccion != item.Titulo) {
                    item.listaObjetivos = [];
                    $scope.listaSeccionesUnica.push(item);
                    $scope.seccion = item.Titulo;
                }
            });

            angular.forEach($scope.listaSeccionesUnica, function (item, key) {
                angular.forEach(response, function (subitem, subkey) {

                    if (item.Titulo == subitem.Titulo) {
                        item.listaObjetivos.push(subitem.IdSeccionPlanMejoramiento);
                    }
                });
            });

            angular.forEach($scope.listaSeccionesUnica, function (item, key) {
                item.expandido = false;
                item.estrategias = [];
                angular.forEach(item.listaObjetivos, function (obj, objKey) {

                    //Estrategias
                    var urlR = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoEstrategiasDiligenciamientoPlan?idPlan=' + $scope.plan.IdPlan + '&idUsuario=' + $scope.plan.IdUsuario + '&idSeccion=' + obj;
                    var servCallR = APIService.getSubs(urlR);
                    servCallR.then(function (response) {

                        angular.forEach(response, function (subitem, subkey) {
                            var url = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoTareasDiligenciamientoPlan?idEstrategia=' + subitem.IdEstrategia + '&idUsuario=' + $scope.plan.IdUsuario;
                            var servCall = APIService.getSubs(url);
                            servCall.then(function (response) {

                                angular.forEach(response, function (subsubitem, subsubkey) {

                                    var parseddate = new Date(subsubitem.FechaInicioEjecucion);
                                    var parseddate2 = new Date(subsubitem.FechaFinEjecucion);

                                    subsubitem.FechaInicioEjecucion = parseddate;
                                    subsubitem.FechaFinEjecucion = parseddate2;
                                    subsubitem.FechaMax = parseMaxDate(new Date());
                                });

                                subitem.tareasDiligenciadas = response;
                            }, function (error) {
                            });


                            url = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoTareasDiligenciarPlan?idEstrategia=' + subitem.IdEstrategia + '&idUsuario=' + $scope.plan.IdUsuario + '&opcion=' + subitem.Opcion;
                            servCall = APIService.getSubs(url);
                            servCall.then(function (response) {
                                subitem.tareasDiligenciar = response;
                            }, function (error) {
                            });

                            item.estrategias.push(subitem);
                        });

                        item.IdUsuario = $scope.plan.IdUsuario;
                        item.IdPlan = $scope.plan.IdPlan;

                    }, function (error) {
                    });

                });
            });

            getActivacionPlan();
            getRutaPlan();
            getDatosPlan();
            getMensajeFinalizacionPlan();

            $scope.datos = $scope.listaSeccionesUnica;


        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    function getDatosPDF() {

        $scope.listaSeccionesUnicaPDF = [];
        $scope.listaIdsObjetivos = [];
        $scope.seccion = "";

        var url = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoSeccionesPlan?idPlan=' + $scope.plan.IdPlan;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.cargoDatos = true;

            angular.forEach(response, function (item, key) {
                if ($scope.seccion == "" || $scope.seccion != item.Titulo) {
                    item.listaObjetivos = [];
                    $scope.listaSeccionesUnicaPDF.push(item);
                    $scope.seccion = item.Titulo;
                }
            });

            angular.forEach($scope.listaSeccionesUnicaPDF, function (item, key) {
                angular.forEach(response, function (subitem, subkey) {

                    if (item.Titulo == subitem.Titulo) {
                        item.listaObjetivos.push(subitem.IdSeccionPlanMejoramiento);
                    }
                });
            });

            angular.forEach($scope.listaSeccionesUnicaPDF, function (item, key) {
                item.expandido = false;
                item.estrategias = [];
                angular.forEach(item.listaObjetivos, function (obj, objKey) {

                    //Estrategias
                    var urlR = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoEstrategiasDiligenciamientoPlan?idPlan=' + $scope.plan.IdPlan + '&idUsuario=' + $scope.plan.IdUsuario + '&idSeccion=' + obj;
                    var servCallR = APIService.getSubs(urlR);
                    servCallR.then(function (response) {

                        angular.forEach(response, function (subitem, subkey) {
                            var url = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoTareasDiligenciamientoPlan?idEstrategia=' + subitem.IdEstrategia + '&idUsuario=' + $scope.plan.IdUsuario;
                            var servCall = APIService.getSubs(url);
                            servCall.then(function (response) {

                                angular.forEach(response, function (subsubitem, subsubkey) {

                                    var parseddate = new Date(subsubitem.FechaInicioEjecucion);
                                    var parseddate2 = new Date(subsubitem.FechaFinEjecucion);

                                    subsubitem.FechaInicioEjecucion = parseddate;
                                    subsubitem.FechaFinEjecucion = parseddate2;
                                    subsubitem.FechaMax = parseMaxDate(new Date());
                                });

                                subitem.tareasDiligenciadas = response;
                            }, function (error) {
                            });


                            url = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoTareasDiligenciarPlan?idEstrategia=' + subitem.IdEstrategia + '&idUsuario=' + $scope.plan.IdUsuario + '&opcion=' + subitem.Opcion;
                            servCall = APIService.getSubs(url);
                            servCall.then(function (response) {
                                subitem.tareasDiligenciar = response;
                            }, function (error) {
                            });

                            item.estrategias.push(subitem);
                        });

                        item.IdUsuario = $scope.plan.IdUsuario;
                        item.IdPlan = $scope.plan.IdPlan;

                    }, function (error) {
                    });

                });
            });

            $scope.datosPDF = $scope.listaSeccionesUnicaPDF;


        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    getDatosAutoEva();

    function getDatosAutoEva() {
        var url = '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/ListadoAutoevaluacion';
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.listaAutoeva = response;
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    $scope.getTareas = function (sIndex, eIndex) {

        var nowDate = new Date();
        var dateWT = nowDate.getFullYear() + '/' + (nowDate.getMonth() + 1) + '/' + nowDate.getDate();

        var tarea = $scope.datos[sIndex].estrategias[eIndex].Tarea;

        var item = { IdTarea: tarea.IdTarea, Tarea: tarea.Tarea, FechaInicioEjecucion: new Date(dateWT), FechaFinEjecucion: new Date(dateWT), Responsable: '', IdAutoevaluacion: null, FechaFinMin: parseMinDate(new Date()), FechaMax: parseMaxDate(new Date(dateWT)) };

        //agregar a la tabla
        $scope.datos[sIndex].estrategias[eIndex].tareasDiligenciadas.push(item);

        var index = $scope.datos[sIndex].estrategias[eIndex].tareasDiligenciar.indexOf(tarea);

        //eliminar del combo
        $scope.datos[sIndex].estrategias[eIndex].tareasDiligenciar.splice(index, 1);
    };

    $scope.borrarTarea = function (sIndex, eIndex, tIndex) {

        var mensaje = { msn: "¿Está seguro de eliminar la acción seleccionada?", tipo: "alert alert-warning" };

        openConfirmacionDeleteTarea(mensaje, sIndex, eIndex, tIndex);
    };

    $scope.setMinDateFin = function (sIndex, eIndex, tIndex) {
        var tarea = $scope.datos[sIndex].estrategias[eIndex].tareasDiligenciadas[tIndex];
        var iniDate = tarea.FechaInicioEjecucion;
        var finDate = tarea.FechaFinEjecucion;

        tarea.FechaFinMin = parseMinDate(iniDate);

        if (iniDate > finDate) {
            tarea.FechaFinEjecucion = iniDate;
        }       
    };

    function parseMinDate(date) {
        var min = date;
        var dd = min.getDate();
        var mm = min.getMonth() + 1; //January is 0!
        var yyyy = min.getFullYear();
        if (dd < 10) {
            dd = '0' + dd
        }
        if (mm < 10) {
            mm = '0' + mm
        }

        return min = yyyy + '-' + mm + '-' + dd;
    }

    function parseMaxDate(date) {
        var max = date;

        var annoEncuesta = $scope.datosPlan.NombreEncuesta.match(/\d+/)[0]; // la fecha maxima siempre debe ser 12/31 del año que procede a la encuesta, ej: 2017-I, 2017-II : MAX: 12/31/2018

        //.match(/\d+/)[0]

        return max = (parseInt(annoEncuesta) + 1) + '-12-31';
    }

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

    //Descargar adjunto
    $scope.descargar = function () {
        var url = $scope.serviceBase + '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/PlanMejoramientoDownload?nombreArchivo=' + $scope.fileLocation + '&usuario=' + $scope.plan.userName + '&idPlan=' + $scope.plan.IdPlan;
        window.open(url)
    }

    //Descargar adjunto
    $scope.exportarExcel = function () {
        var url = $scope.serviceBase + '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/PlanMejoramientoDownloadExcel?idUsuario=' + $scope.plan.IdUsuario + '&idPlan=' + $scope.plan.IdPlan;
        window.open(url)
    }

    //Guardado del  plan
    $scope.aceptar = function () {

        $scope.errors = [];
        if (!$scope.validar()) {

            var mensaje = { msn: "Por favor verifique que se han diligenciado correctamente todos los campos de las acciones a realizar", tipo: "alert alert-danger" };

            openRespuesta(mensaje);

            return false;
        }


        $scope.guardando = true;

        guardarDatos();
    };


    //Guardado del  plan
    $scope.enviar = function () {

        //var mensaje = { msn: "¿Desea enviar el Plan de mejoramiento? con esto no va a haber marcha atrás", tipo: "alert alert-warning" };
        var mensaje = { msn: $scope.mensajeEnvioPlan, tipo: "alert alert-warning" };

        openConfirmacionEnvio(mensaje);
    };

    function enviarPlan() {

        $scope.plan.AudUserName = authService.authentication.userName;
        $scope.plan.AddIdent = authService.authentication.isAddIdent;
        $scope.plan.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.plan, $scope.urlEnvio);
        servCall.then(function (response) {
            $log.log(response);

            var mensaje = { msn: response.data.respuesta, tipo: "alert alert-success" };

            switch (response.data.estado) {
                case 0:
                    mensaje = { msn: response.data.respuesta, tipo: "alert alert-danger" };
                    break;
                case 1:
                    mensaje = { msn: response.data.respuesta, tipo: "alert alert-success" };
                    break;
            }

            $scope.enviando = false;

            UtilsService.abrirRespuesta(mensaje);

            getDatos();
            getDatosPDF();

        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    function guardarDatos() {

        $scope.tareasGuardar = [];

        angular.forEach($scope.datos, function (item, key) {
            angular.forEach(item.estrategias, function (subitem, subkey) {
                angular.forEach(subitem.tareasDiligenciadas, function (subsubitem, subsubkey) {
                    $scope.tareasGuardar.push(subsubitem);
                });
            });
        });

        $scope.plan.tareas = $scope.tareasGuardar;
        $scope.plan.AudUserName = authService.authentication.userName;
        $scope.plan.AddIdent = authService.authentication.isAddIdent;
        $scope.plan.UserNameAddIdent = authService.authentication.userNameAddIdent;

        $scope.planUpload = {};

        $scope.planUpload.IdPlan = $scope.plan.IdPlan;
        $scope.planUpload.IdUsuario = $scope.plan.IdUsuario;
        $scope.planUpload.userName = $scope.plan.userName;



        //Guardamos las respuestas primero
        var servCall = APIService.saveSubscriber($scope.plan, $scope.url);
        servCall.then(function (response) {
            //$log.log(response);            

            //Cargamos el archivo -- si existe y fue seleccionado
            if (angular.isDefined($scope.datos.file)) {
                $scope.fileLocation = $scope.datos.file.name;
                Upload.upload({
                    url: $scope.serviceBase + '/api/Sistema/PlanesMejoramientoV3/Diligenciamiento/GuardarArchivoDiligenciamientoPlan',
                    method: "POST",
                    data: $scope.planUpload,
                    file: $scope.datos.file,
                }).then(function (resp) {
                    var mensaje = { msn: response.data.respuesta, tipo: "alert alert-success" };

                    $scope.guardando = false;

                    UtilsService.abrirRespuesta(mensaje);
                    //$scope.uploadingMint = false;
                    //cargarHome();
                }, function (resp) {
                    var mensaje = { msn: 'Error: ' + resp.status, tipo: "alert alert-danger" };
                    UtilsService.abrirRespuesta(mensaje);
                }, function (evt) {
                    var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
                    $scope.progressPercentage = 'progreso: ' + progressPercentage + '% ' + evt.config.data.file.name;
                });
            } else {
                var mensaje = { msn: response.data.respuesta, tipo: "alert alert-success" };

                switch (response.data.estado) {
                    case 0:
                        mensaje = { msn: response.data.respuesta, tipo: "alert alert-danger" };
                        break;
                    case 1:
                        mensaje = { msn: response.data.respuesta, tipo: "alert alert-success" };
                        break;
                }

                $scope.guardando = false;

                UtilsService.abrirRespuesta(mensaje);
            }

            getDatos();
            getDatosPDF();

        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //=======================Confirmaciones========================================================
    var openConfirmacion = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionConManejoDeRespuesta.html',
            controller: 'ModalConfirmacionConManejoDeRespuestaController',
            resolve: {
                datos: function () {
                    return mensaje;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (resultado) {
                if ($scope.isCerrando && resultado) {
                    $scope.fileLocation = '';
                    $scope.fileIsVacio = true;
                    $scope.isCerrando = false;
                    $scope.datos.deleteFile = true;
                }
            });
    };

    var openConfirmacionDeleteTarea = function (mensaje, sIndex, eIndex, tIndex) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionConManejoDeRespuesta.html',
            controller: 'ModalConfirmacionConManejoDeRespuestaController',
            resolve: {
                datos: function () {
                    return mensaje;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (resultado) {
                if (resultado) {
                    var tarea = $scope.datos[sIndex].estrategias[eIndex].tareasDiligenciadas[tIndex];

                    var item = { IdTarea: tarea.IdTarea, Tarea: tarea.Tarea };

                    //agregar al combo
                    $scope.datos[sIndex].estrategias[eIndex].tareasDiligenciar.push(item);

                    //eliminar de la tabla
                    $scope.datos[sIndex].estrategias[eIndex].tareasDiligenciadas.splice(tIndex, 1);
                }
            });
    };

    var openConfirmacionEnvio = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionConManejoDeRespuestaPlan.html',
            controller: 'ModalConfirmacionConManejoDeRespuestaController',
            resolve: {
                datos: function () {
                    return mensaje;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (resultado) {
                if (resultado) {
                    $scope.enviando = true;
                    enviarPlan();
                }
            });
    };

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


    //=======================Exportar PDF========================================================

    var getLayoutHeader = function () {
        return {
            hLineWidth: function () {
                return 0.5;
            },
            vLineWidth: function () {
                return 0;
            },
            hLineColor: function () {
                return 'white';
            },
            vLineColor: function () {
                return 'white';
            }
        };
    };

    var getLayout = function () {
        return {
            hLineWidth: function () {
                return 1;
            },
            vLineWidth: function () {
                return 0;
            },
            hLineColor: function () {
                return '#BDBDBD';
            },
            vLineColor: function () {
                return 'white';
            }
        };
    };

    var getLayoutImages = function () {
        return {
            hLineWidth: function () {
                return 0.1;
            },
            vLineWidth: function () {
                return 0.1;
            },
            hLineColor: function () {
                return 'white';
            },
            vLineColor: function () {
                return 'white';
            }
        };
    };

    var getLogoApp = function () {
        var logoRus = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAtsAAAA1CAYAAACQoSdzAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2hpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDowODgwMTE3NDA3MjA2ODExODIyQUZFQTUxMjkyRjQyNSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo5QzM0RDlBNjZDRjcxMUU0QkNFMUJFMzg3MjU2NUU0NiIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo5QzJENzJBNjZDRjcxMUU0QkNFMUJFMzg3MjU2NUU0NiIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChNYWNpbnRvc2gpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MDI4MDExNzQwNzIwNjgxMThDMTRCNjY2RTJEQjAzOUMiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MDg4MDExNzQwNzIwNjgxMTgyMkFGRUE1MTI5MkY0MjUiLz4gPC9yZGY6RGVzY3Jp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';

        var logoAPP = {
            margin: [20, 0, 20, 10],
            alignment: 'center',
            table: {
                widths: ['*'],
                body: [[{ image: logoRus, width: 300 }]]
            }, layout: 'noBorders'
        }
        return logoAPP;
    };

    var getDatosFormatados = function () {

        getDatosPDF();

        var body = [];
        var fila = [];
        var fila2 = [];

        angular.forEach($scope.datosPDF, function (value, key) {

            $scope.datosReco = getFilasEstrategias(value.estrategias);

            fila = [
                {
                    text: value.Titulo,
                    style: 'headerSeccion',
                    pageBreak: key == 0 ? 'none' : 'before'
                }
            ];

            fila2 = [
                {
                    table: {
                        widths: ['*'],
                        body: [
                            [{ text: value.Ayuda, bold: true, alignment: 'justify' }],
                            [{
                                table: {
                                    headerRows: 2,
                                    body: $scope.datosReco
                                }
                            }]
                        ]
                    },
                    margin: [0, 0, 0, 0],
                    layout: 'noBorders'
                }
            ];

            body.push(fila);
            body.push(fila2);


        });

        return body;
    }

    function getFilasTareas(tareas) {
        var body = [];
        var fila = [];

        angular.forEach(tareas, function (tarea, key) {
            fila = [
                { text: tarea.Tarea, style: 'tableContent3' },
                { text: $filter('date')(tarea.FechaInicioEjecucion, 'dd/MM/yyyy'), style: 'tableContent2' },
                { text: $filter('date')(tarea.FechaFinEjecucion, 'dd/MM/yyyy'), style: 'tableContent2' },
                { text: tarea.Responsable, style: 'tableContent1' },
                { text: (tarea.IdAutoevaluacion - 1).toString(), style: 'tableContent2' }
            ];

            body.push(fila);
        });

        return body;
    }

    function getFilasEstrategias(estrategias) {
        var body = [];
        var fila = [];

        fila = [
            { text: 'Objetivo', style: 'recoHeader', rowSpan: 2 },
            { text: 'Estrategia', style: 'recoHeader', rowSpan: 2 },
            { text: 'Acciones a Realizar', style: 'recoHeader', rowSpan: 2 },
            { text: 'Tiempos de Ejecución', style: 'recoHeader', colSpan: 2 },
            {},
            { text: 'Responsables', style: 'recoHeader', rowSpan: 2 },
            { text: 'Auto Evaluación', style: 'recoHeader', rowSpan: 2 }
        ];

        body.push(fila);

        fila = [
            {},
            {},
            {},
            { text: 'Fecha Inicio', style: 'recoHeader' },
            { text: 'Fecha Final', style: 'recoHeader' },
            {},
            {}
        ];

        body.push(fila);

        angular.forEach(estrategias, function (estra, keyR) {

            $scope.tareasPDF = getFilasTareas(estra.tareasDiligenciadas);


            angular.forEach(estra.tareasDiligenciadas, function (tarea, keyT) {

                if (keyT == 0) {
                    fila = [
                        { text: estra.ObjetivoGeneral, style: 'tableContent1', rowSpan: estra.tareasDiligenciadas.length },
                        { text: estra.Estrategia, style: 'tableContent1', rowSpan: estra.tareasDiligenciadas.length }
                    ];
                } else {
                    fila = [
                        {},
                        {}
                    ];
                }

                var col1 = { text: tarea.Tarea, style: 'tableContent3' };
                var col2 = { text: $filter('date')(tarea.FechaInicioEjecucion, 'dd/MM/yyyy'), style: 'tableContent2' };
                var col3 = { text: $filter('date')(tarea.FechaFinEjecucion, 'dd/MM/yyyy'), style: 'tableContent2' };
                var col4 = { text: tarea.Responsable, style: 'tableContent1' };
                var col5 = { text: (tarea.IdAutoevaluacion - 1).toString(), style: 'tableContent2' };

                fila.push(col1);
                fila.push(col2);
                fila.push(col3);
                fila.push(col4);
                fila.push(col5);

                body.push(fila);
            });
        });

        return body;
    }

    $scope.exportar = function () {

        $scope.datosFormatados = getDatosFormatados();
        $scope.definiciones = UtilsService.getDefinicionesReportesEjecutivos();

        var widthImages = 150;
        var heigthImages = 150;
        var fillColor = 'maroon';

        var docDefinition = {
            compress: false,
            pageMargins: [30, 150, 30, 50],
            layout: 'headerLineOnly',
            pageSize: 'A4',
            pageOrientation: 'landscape',
            header: function (currentPage, pageCount) {

                var header = [
                $scope.definiciones.logosEncabezado,
                getLogoApp(),
                {
                    style: 'tableHeader4',
                    table: {
                        widths: ['*', 'auto'],
                        body: [
                            [{ text: 'Plan de Mejoramiento: ' + $scope.datosPlan.Nombre, alignment: 'left' }, { text: 'Usuario: ' + $scope.plan.userName }]
                        ]
                    }, layout: getLayoutHeader()
                }
                ];

                return header;
            },
            footer: function (currentPage, pageCount) {
                return {
                    stack: [
                        {
                            fontSize: 7,
                            columns: [
                            { text: "Página: " + currentPage.toString() + "/" + pageCount.toString(), alignment: 'left', margin: [30, 0, 0, 0], bold: true },
                            { text: "Fecha de generación: " + new Date().toLocaleString(), alignment: 'right', margin: [0, 0, 30, 0], bold: true }
                            ]
                        }]

                };
            },

            content: [
                {
                    table: {
                        widths: ['*'],
                        body:
                        $scope.datosFormatados
                    },
                    layout: getLayout()
                }
            ],
            styles: {
                'tableHeader': {
                    fontSize: 6,
                    fillColor: fillColor,
                    color: 'white',
                    alignment: 'center',
                },
                'tableBody': {
                    fontSize: 6,
                    fillColor: fillColor,
                    alignment: 'center',
                },
                'tableHeader1': {
                    bold: true,
                    fontSize: 15,
                    color: '#63002D',
                    alignment: 'center',
                    margin: [50, 0, 50, 0]
                },
                'tableHeader2': {
                    bold: true,
                    fontSize: 9,
                    color: 'white',
                    alignment: 'center',
                },
                'tableHeader3': {
                    fontSize: 7,
                    color: 'white',
                    alignment: 'center',
                },
                'tableHeader4': {
                    bold: true,
                    fontSize: 10,
                    color: '#63002D',
                    alignment: 'center',
                    margin: [50, 0, 50, 0]
                },
                'image': {
                    width: 150,
                    height: 150,
                },
                'tableFooter': {
                    fillColor: '#D2D2D2',
                    color: 'black',
                    alignment: 'center',
                    bold: true
                },
                'headerSeccion': {
                    fillColor: '#63002D',
                    color: 'white',
                    alignment: 'center',
                    bold: true
                },
                'tableContent1': {
                    fontSize: 7,
                    color: 'black',
                    alignment: 'justify',
                },
                'tableContent2': {
                    fontSize: 9,
                    color: 'black',
                    alignment: 'center',
                },
                'tableContent3': {
                    fontSize: 6,
                    color: 'black',
                    alignment: 'justify',
                },
                'recoHeader': {
                    bold: true,
                    fontSize: 10,
                    fillColor: '#cccccc',
                    color: 'white',
                    alignment: 'center'
                }
            }
        };

        pdfMake.createPdf(docDefinition).download("PlanMejoramiento.pdf");
        //pdfMake.createPdf(docDefinition).open();

        //html2canvas(document.getElementById('exportthis'), {
        //    onrendered: function (canvas) {
        //        var data = canvas.toDataURL();
        //        var docDefinition = {
        //            content: [{
        //                image: data,
        //                width: 500,
        //            }]
        //        };
        //        pdfMake.createPdf(docDefinition).download("Score_Details.pdf");
        //    }
        //});

    };
}]);

app.directive('blacklist', function () {
    return {
        require: 'ngModel',
        link: function (scope, elem, attr, ngModel) {

            var maxAllowedDateStr = attr.blacklist;
            var maxAllowedDate = new Date(maxAllowedDateStr);

            maxAllowedDate.setDate(maxAllowedDate.getDate() + 1); //Add 1 day always

            //For DOM -> model validation
            ngModel.$parsers.unshift(function (value) {               
                var valDate = new Date(value);
                valDate.setHours(0, 0, 0, 0);
                valDate.setDate(valDate.getDate() + 1); //Add 1 day always

                var valid = (valDate < maxAllowedDate);
                ngModel.$setValidity('blacklist', valid);
                return valid ? value : undefined;
            });
           
            //For model -> DOM validation
            ngModel.$formatters.unshift(function (value) {
                var valDate = new Date(value);
                valDate.setHours(0, 0, 0, 0);
                valDate.setDate(valDate.getDate() + 1); //Add 1 day always

                ngModel.$setValidity('blacklist', (valDate < maxAllowedDate));
                return value;
            });
        }
    };
});