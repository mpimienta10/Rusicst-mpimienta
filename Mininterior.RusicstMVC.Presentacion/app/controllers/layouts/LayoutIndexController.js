'use strict'

app.controller('LayoutIndexController', ['$scope', 'authService', 'APIService', 'localStorageService', '$q', '$http', 'PermPermissionStore', 'ngSettings', '$uibModal', function ($scope, authService, APIService, localStorageService, $q, $http, PermPermissionStore, ngSettings, $uibModal) {
    $scope.salir = function () {
        $scope.permisos = {};
        $scope.recursos = {};
        PermPermissionStore.clearStore();
        authService.logOut();
    }

    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.datosHome = {};

    cargarHome();

    function cargarHome() {
        var url = '/api/Sistema/ConfiguracionHome/';
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.datosHome = datos;
            }, function (error) {
                $scope.error = "Se generó un error en la petición al cargar los datos del Home";
            });
        }
    }

    //// Carrusel
    $scope.myInterval = 5000;
    $scope.noWrapSlides = false;
    $scope.active = 0;

    $scope.autenticacion = authService.authentication;
    $scope.autenticado = $scope.autenticacion.isAuth;

    if ($scope.autenticado) {
        var user = $scope.autenticacion.userName;
        var addident = $scope.autenticacion.isAddIdent;
        var usernameaddident = $scope.autenticacion.userNameAddIdent;

        getDatosUsuarioAutenticado(user, addident, usernameaddident);
        getRolesUsuarioAutenticado(user);
    }
    else {
        authService.logOutLogin();
    }

    function getDatosUsuarioAutenticado(username, addident, usernameaddident) {
        var url = '/api/Usuarios/Usuarios/UsuarioAutenticado';
        var datos = { AudUserName: username, AddIdent: addident, UserNameAddIdent: usernameaddident };
        $http.post(serviceBase + url, datos).then(function (response) {
            if (response.data[0]) {
                $scope.datosUsuario = response.data[0];
                if (response.data[0].DatosActualizados === false && !$scope.autenticacion.isAddIdent) {
                    $scope.PopUpCambiarContrasena($scope.datosUsuario);
                }
            }
        }, function (err, status) {
            defered.reject(err)
        });
    };

    function getRolesUsuarioAutenticado(username) {
        var registro = {};
        var url = '/api/Usuarios/GestionarPermisos/Permisos';
        registro = { UserName: username };
        var servCall = APIService.saveSubscriber(registro, url);

        servCall.then(function (response) {
            var permisos = {};
            var recursos = {};
            var permisosArray = [];
            var recursosArray = [];

            angular.forEach(response.data, function (value, key) {
                permisos["subrecurso_" + value.IdSubRecurso] = value.NombreSubRecurso;
                recursos["recurso_" + value.IdRecurso] = value.NombreRecurso;
                permisosArray.push("subrecurso_" + value.IdSubRecurso);
                recursosArray.push("recurso_" + value.IdRecurso);
            });

            $scope.permisos = permisos;
            $scope.recursos = recursos;

            PermPermissionStore.defineManyPermissions(permisosArray, function (permissionName) {
                return permisosArray.includes(permissionName);
            });
        }, function (error) {
            var error = "Se generó un error en la petición, no se guardaron los datos";
        });
    };

    $scope.PopUpCambiarContrasena = function (entity) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/home/modals/CambiarContrasena.html',
            controller: 'ModalCambiarContrasenaController',
            size: 'lg',
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
             function (resultado) {
                 var mensaje = 'Los datos de ' + resultado.Nombres.toUpperCase() + ' han sido actualizados satisfactoriamente.';
                 openRespuesta(mensaje);
             }
        );
    };

    var openRespuesta = function (mensaje) {
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
        modalInstance.result.then()
    };
}]);

app.controller('ModalCambiarContrasenaController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {
    $scope.registro = entity || {};
    $log.log(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '/api/Usuarios/Autenticacion/ModificarContrasena';

    $scope.logout = function () { debugger; authService.logOut(); $uibModalInstance.close() };

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    function guardarDatos() {
        $scope.cargando = true;
        $scope.registro.IdUsuarioTramite = authService.authentication.userName;

        $scope.registro.AudUserName = authService.authentication.userName;
        $scope.registro.AddIdent = authService.authentication.isAddIdent;
        $scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.registro, $scope.url);
        servCall.then(function (response) {

            $scope.cargando = false;
            switch (response.data.estado) {
                case 0:
                    $scope.error = response.data.respuesta;
                    break;
                case 2:
                    $uibModalInstance.close($scope.registro);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }
}]);
