app.controller('EstablecerContrasenaController', ['$scope', 'APIService', 'UtilsService', '$log', '$uibModal', '$location', function ($scope, APIService, UtilsService, $log, $uibModal, $location) {
    
    $location.replace();
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.deshabiltar = false;
    $scope.isUsername = false;
    $scope.registro = {};
    $scope.started = true;
    $scope.esExitoso = false;
    $scope.registro.Token = $scope.Token;

    getUsername();

    //---------------INICIO OBTENER USERNAME-------------
    function getUsername() {
        
        var url = "/api/Usuarios/Autenticacion/Registrese";
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (response) {
            $scope.estado = response.data.estado;
            if ($scope.estado > 0) {
                $scope.registro.Username = response.data.respuesta;
                $scope.isUsername = true;
            } else {
                $scope.error = response.data.respuesta;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    //---------------FIN OBTENER USERNAME---------------


    //---------------INICIO GUARDAR-----------------
    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        guardarDatos();
    };
    function guardarDatos() {
        
        $scope.deshabiltar = true;
        var url = "/api/Usuarios/Autenticacion/EstablecerContrasena";
        $scope.registro.Url = window.location.host + '/#!/';
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (response) {
           var mensaje = { msn: "El Usuario y la Contraseña fueron establecidos satisfactoriamente.", tipo: "alert alert-success" };
           $scope.esExistoso = true;
           $scope.deshabiltar = false;
            openRespuesta(mensaje);
        }, function (error) {
            
            $scope.deshabiltar = false;
           var mensaje = {};
           if (error.data.ModelState.estado[0] === "5") {
               $scope.esExistoso = true;
                mensaje = { msn: 'No hay solicitud de establecimiento de contraseña pendiente para este usuario.', tipo: "alert alert-danger" };
           }
           else if (error.data.ModelState.estado[0] === "0") {
               $scope.esExistoso = false;
               mensaje = { msn: 'El nombre de Usuario ya existe. por favor intente con otro', tipo: "alert alert-danger" };
           }
           else {
                $scope.esExistoso = false;
                mensaje = { msn: "Error: " + error.data.ModelState[""][0] + '.', tipo: "alert alert-danger" };
            }
           openRespuesta(mensaje);
        });
    }
    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
    //---------------FIN GUARDAR-------------

    //-----------------MODAL DE CONFIRMACIÓN------------------
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
            function () {
                if ($scope.esExistoso === true) $location.url("/Home/login");
             });
    };
}]);