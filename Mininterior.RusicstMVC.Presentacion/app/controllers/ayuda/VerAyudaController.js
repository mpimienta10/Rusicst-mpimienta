app.controller('VerAyudaController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'ngSettings', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, ngSettings) {
    $scope.started = true;
    $scope.ayudas = [];
    $scope.serviceBase = ngSettings.apiServiceBaseUri;

    function cargarAyudas() {
        var url = '/api/Sistema/ConfiguracionArchivosAyuda/';
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.ayudas = datos;
            }, function (error) {
                $scope.error = "Se generó un error en la petición al cargar las ayudas";
            });
        }
    }

    cargarAyudas();

    $scope.descargar = function (index) {
        var url = $scope.serviceBase + '/api/Sistema/Download?archivo=' + $scope.ayudas[index].Id + '&nombreArchivo=' + $scope.ayudas[index].Titulo;
        window.open(url)
    }
}]);
