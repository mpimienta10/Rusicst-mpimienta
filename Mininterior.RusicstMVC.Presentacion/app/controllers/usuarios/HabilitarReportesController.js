app.controller('HabilitarReportesController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, authService) {
    //// --------------------Cargar Página---------------------------------
    $scope.started = true;
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.usuarioSeleccionado = undefined;
    $scope.encuestaSeleccionada = undefined;

    $scope.encuestas = [];

    //// Carga de combo de usuarios
    function getUsuario() {
        var url = '/api/Usuarios/Usuarios?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.usuarios = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    //// Carga del combo de encuestas
    function getEncuesta() {
        var url = '/api/General/Listas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = [];

            $scope.encuestas = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargar el listado de encuestas";
        });
    }

    //// Carga del combo de planes de mejoramiento
    function getPlanesM() {
        var url = '/api/Sistema/PlanesMejoramientoV3/ListadoPlanes/';
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = [];

            angular.forEach(response, function (item, key) {
                var plan = { Titulo: item.Nombre, Id: item.IdPlanMejoramiento };
                $scope.encuestas.push(plan);
            });

        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargar el listado de Planes de Mejoramiento";
        });
    }

    //// Carga del combo de tableros
    function getTablerosPATMun() {
        var url = '/api/TableroPat/ListaTodosTablerosPlaneacionActivos/';
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = [];
            angular.forEach(response, function (item, key) {                
                var tablero = { Titulo: item.Planeacion + ' - ' + item.Tipo, Id: item.Id };
                $scope.encuestas.push(tablero);
            });

        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargar el listado de Tableros PAT";
        });
    }  

    //// Carga del combo de tableros
    function getTablerosPATSeg1() {
        var url = '/api/TableroPat/ListaTodosTablerosSeguimientosActivos/' + 1;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = [];

            angular.forEach(response, function (item, key) {
                var tablero = { Titulo: item.Ano + ' - ' + item.Tipo, Id: item.Id };
                $scope.encuestas.push(tablero);
            });

        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargar el listado de Tableros PAT";
        });
    }

    //// Carga del combo de tableros
    function getTablerosPATSeg2() {
        var url = '/api/TableroPat/ListaTodosTablerosSeguimientosActivos/' + 2;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = [];

            angular.forEach(response, function (item, key) {
                var tablero = { Titulo: item.Ano + ' - ' + item.Tipo, Id: item.Id };
                $scope.encuestas.push(tablero);
            });

        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargar el listado de Tableros PAT";
        });
    }

    //// Carga del combo de encuestas
    function getTiposExtension() {
        var url = '/api/Usuarios/HabilitarReportes/TiposExtensiones?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.tipos = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargar el listado de Tipos de Extensiones";
        });
    }

    getUsuario();
    getTiposExtension();

    $scope.changeTipo = function () {

        switch ($scope.tipoSeleccionado.idTipo) {

            case 1:
                getEncuesta();
                break;
            case 2:
                getPlanesM();
                break;
            case 3:
                getTablerosPATMun();                
                break;
            case 4:
                getTablerosPATSeg1();
                break;
            case 5:
                getTablerosPATSeg2();
                break;
            default:
                break;
        }

        $scope.encuestaSeleccionada = '';

    };

    //------------------- Accion Guardar datos -------------------
    $scope.aceptar = function () {
        if (!$scope.validar()) return false;

        //// Se arma el registro a enviar
        $scope.registro.IdUsuario = $scope.usuarioSeleccionado.Id;
        $scope.registro.IdEncuesta = $scope.encuestaSeleccionada.Id;
        $scope.registro.IdTipoTramite = $scope.tipoSeleccionado.idTipo;

        //// Cargar el nombre del usuario que esta autenticado
        $scope.registro.AudUserName = $scope.autenticacion.userName;
        $scope.registro.AddIdent = $scope.autenticacion.isAddIdent;
        $scope.registro.UserNameAddIdent = $scope.autenticacion.userNameAddIdent;

        //// Despliega la ventana modal
        $scope.openPopUpConfirmacion();
    };

    //// Validacion del form
    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //// Confirmación
    $scope.openPopUpConfirmacion = function () {
        var modalInstance = $uibModal.open({
            templateUrl: '/app/views/modals/Confirmacion.html',
            controller: 'ModalConfirmacionController',
            backdrop: 'static', keyboard: false,
            resolve: {
                datos: function () {
                    $scope.disabledguardando = 'disabled';
                    var titulo = 'Extensiones de Tiempo';
                    var url = '/api/Usuarios/HabilitarReportes/ExtenderPlazo/';
                    var entity = $scope.registro;
                    var msn = "Está seguro de extender el plazo para " + $scope.usuarioSeleccionado.Nombres + " hasta la fecha " + $scope.registro.FechaFin.toLocaleDateString();
                    return { url: url, entity: entity, msn: msn, titulo: titulo }
                }
            }
        });
        modalInstance.result.then(
            function (response) {
                $scope.guardando = null;
                $scope.disabledguardando = null;
                openRespuesta(response);
            }
        );
    };

    //// Respuesta
    var openRespuesta = function (response) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    $scope.deshabiltarRegistrese = false;
                    var enviar = { msn: response.estado == 1 ? "El permiso del usuario " + $scope.usuarioSeleccionado.Nombres + " al reporte " + $scope.encuestaSeleccionada.Titulo + " ha sido guardado" : response.respuesta, tipo: response.estado == 1 ? "alert alert-success" : "alert alert-warning" };
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
            });
    };

    //--------------------- DataPicker -----------------------------------

    $scope.registro = {};
    $scope.today = function () {
        $scope.registro.FechaFin = new Date();
    };
    $scope.today();
    $scope.clear = function () {
        $scope.registro.FechaFin = null;
    };
    $scope.dateOptions = {
        formatYear: 'yy',
        maxDate: new Date(2029, 5, 22),
        minDate: new Date(),
        startingDay: 1
    };

    $scope.open1 = function () {
        $scope.popup1.opened = true;
    };

    $scope.open2 = function () {
        $scope.popup2.opened = true;
    };

    $scope.format = "dd/MM/yyyy";

    $scope.popup1 = {
        opened: false
    };

    $scope.popup2 = {
        opened: false
    };

    function getDayClass(data) {
        var date = data.date,
          mode = data.mode;
        if (mode === 'day') {
            var dayToCheck = new Date(date).setHours(0, 0, 0, 0);

            for (var i = 0; i < $scope.events.length; i++) {
                var currentDay = new Date($scope.events[i].date).setHours(0, 0, 0, 0);

                if (dayToCheck === currentDay) {
                    return $scope.events[i].status;
                }
            }
        }
        return '';
    }
}]);
