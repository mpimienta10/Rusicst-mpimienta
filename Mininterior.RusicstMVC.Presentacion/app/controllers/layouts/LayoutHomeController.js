'use strict'
app.controller('LayoutHomeController', ['$scope', 'authService', 'APIService', 'ngSettings', '$location', 'localStorageService', function ($scope, authService, APIService, ngSettings, $location, localStorageService) {

    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.datosHome = {};
    $scope.datosAuditoria = {};

    cargarHome();
    function cargarHome() {
        var url = '/api/Sistema/ConfiguracionSistema/';
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

    var url = window.location.href;
    var token = url.Id
    var index = url.indexOf("Id=");

    if (index >= 1) {
        $scope.Token = url.substring(index + 3);
    }

    //// Carrusel
    $scope.myInterval = 5000;
    $scope.noWrapSlides = false;
    $scope.active = 0;

    $scope.salir = function () {
        authService.logOut();
    }

    //$scope.openBuscador = function (nmtexto) {
    //    if (nmtexto !== undefined) {
    //        $state.go('Index.Buscador', { textobusqueda: nmtexto }, { reload: true });
    //    }
    //}

    ////==================================================================================================
    //// Audita el logOut en caso que la variable determine que el usuario esta saliendo de la aplicación
    ////==================================================================================================
    if (authService.authentication.logOut !== undefined) {
        auditarLogOut();
    }

    ////==================================================================================================
    //// Método que permite auditar la salida del RUSICST y limpia el storage de autenticación
    ////==================================================================================================
    function auditarLogOut() {

        $scope.datosAuditoria.AudUserName = authService.authentication.userName;
        $scope.datosAuditoria.AddIdent = authService.authentication.isAddIdent;
        $scope.datosAuditoria.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var url = '/api/Usuarios/Autenticacion/LogOut/';

        var servCall = APIService.saveSubscriber($scope.datosAuditoria, url);
        servCall.then(function (response) {

            localStorageService.remove('authorizationData');
            authService.authentication.isAuth = false;
            authService.authentication.isAddIdent = false,
            authService.authentication.userNameAddIdent = "",
            authService.authentication.userName = "";
            authService.authentication.useRefreshTokens = false;
            authService.authentication.idUsuario = 0;
            authService.authentication.idTipoUsuario = 0;
            authService.authentication.logOut = false;
            $location.url('home/login');

        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }
}]);