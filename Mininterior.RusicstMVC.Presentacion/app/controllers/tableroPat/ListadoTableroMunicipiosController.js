app.controller('ListadoTableroMunicipiosController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$location', 'ngSettings', 'enviarDatos', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $location, ngSettings, enviarDatos, authService) {
    $scope.autenticacion = authService.authentication;
    $scope.userName = $scope.autenticacion.userName;
    $scope.MunicipioCompletados = function () {
        var url = '/api/TableroPat/TablerosMunicipio/ListaTablerosMunicipioCompletados/' + $scope.userName ;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            if (datos.length > 0) {
                $scope.ListaTablerosMunicipioCompletados = datos;
            } else {
                $scope.alerta = $scope.alerta + "No se encontraron tableros completadas";
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };
    $scope.MunicipioPorCompletar = function () {
        var url = '/api/TableroPat/TablerosMunicipio/ListaTablerosMunicipioPorCompletar/' + $scope.userName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos2) {
            if (datos2.length > 0) {
                $scope.ListaTablerosMunicipioPorCompletar = datos2;
            } else {
                $scope.alerta2 = "No se encontraron tableros sin diligenciar";
            }
        }, function (error) {
            $scope.error2 = "Se generó un error en la petición";
        });
    };
    $scope.MunicipioCompletados();
    $scope.MunicipioPorCompletar();
    $scope.Consultar = function (index) {
        tablero = $scope.ListaTablerosMunicipioCompletados[index];
        enviarDatos.datos = tablero;
        $location.url('/Index/TableroPat/GestionMunicipal');
    }
    $scope.Completar = function (index) {
        tablero = $scope.ListaTablerosMunicipioPorCompletar[index];
        enviarDatos.datos = tablero;
        $location.url('/Index/TableroPat/GestionMunicipal');
    }

}]);