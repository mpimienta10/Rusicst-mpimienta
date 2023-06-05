app.controller('ConfirmarSolicitudController', ['$scope', 'APIService', 'UtilsService', '$log', '$location', 'ngSettings', function ($scope, APIService, UtilsService, $log, $location, ngSettings) {

    $scope.registro = {};
    var url = window.location.href;
    var index = url.indexOf("Id=");

    $scope.registro.Token = url.substring(index + 3);

    //// Verificar si el usuario es válido
    function VerificarSolicitud() {
        
        var url = "/api/Usuarios/Autenticacion/VerificarSolicitud";
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (response) {
            
            if (response.data.estado > 0) {
                if (response.data.estado == 4) {
                    return true;
                }
                $scope.registro.mensaje = response.data.respuesta;


            } else {
                $scope.error = "Se generó un error en la petición, no se guardaron los datos." + response.data.respuesta;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    function guardarDatos() {
        
        var url = "/api/Usuarios/GestionarSolicitudes/ConfirmarSolicitud";
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (response) {
            
            switch (response.data.estado) {
                case 4:
                    $location.url(response.data.respuesta);
                    $location.replace();
                    break;
                case 2:
                    $scope.registro.mensaje = response.data.respuesta;
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos" + error.data.respuesta;
        });
    }
    guardarDatos();
}]);