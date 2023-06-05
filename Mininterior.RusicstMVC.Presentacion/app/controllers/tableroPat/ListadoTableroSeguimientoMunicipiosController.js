app.controller('ListadoTableroSeguimientoMunicipiosController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$location', 'ngSettings', 'enviarDatos', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $location, ngSettings, enviarDatos, authService) {
    $scope.autenticacion = authService.authentication;
    $scope.userName = $scope.autenticacion.userName;
    $scope.MunicipioCompletados = function () {
        var url = '/api/TableroPat/ListaTablerosSeguimientoMunicipioCompletados/' + $scope.userName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.cargoDatos = true;
            if (datos.length > 0) {
                $scope.ListaTablerosMunicipioCompletados = datos;
            } else {
                $scope.alertaCompletados = "No se encontraron tableros por consultar";
            }
        }, function (error) {
            $scope.errorCompletados = "Se generó un error en la petición";
        });
    };
    $scope.MunicipioPorCompletar = function () {
        var url = '/api/TableroPat/ListaTablerosSeguimientoMunicipioPorCompletar/' + $scope.userName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos2) {
            if (datos2.length > 0) {
                $scope.ListaTablerosMunicipioPorCompletar = datos2;
            } else {
                $scope.alertaPorcompletar = "No se encontraron tableros por diligenciar";
            }
        }, function (error) {
            $scope.errorPorcompletar = "Se generó un error en la petición";
        });
    };
    $scope.MunicipioCompletados();
    $scope.MunicipioPorCompletar();
    $scope.Consultar = function (index) {
        tablero = $scope.ListaTablerosMunicipioCompletados[index];
        enviarDatos.datos = tablero;
        $location.url('/Index/TableroPat/SeguimientoMunicipal');
    }
    $scope.Completar = function (index) {
        tablero = $scope.ListaTablerosMunicipioPorCompletar[index];
        enviarDatos.datos = tablero;
        $location.url('/Index/TableroPat/SeguimientoMunicipal');
    }

}]);