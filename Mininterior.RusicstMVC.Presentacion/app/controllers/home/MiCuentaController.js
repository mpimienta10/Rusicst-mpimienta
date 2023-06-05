app.controller('MiCuentaController', ['$scope', 'APIService', '$uibModal', 'authService', function ($scope, APIService, $uibModal, authService) {
    $scope.registro = {};
   

    //------------------------Lógica de Modal de Acciones -----------------------------------------
    $scope.abrirModal = function () {
        getDatos();
        function getDatos() {
            $scope.autenticacion = authService.authentication;
            $scope.registro.UserName = $scope.autenticacion.userName;

            $scope.registro.AudUserName = authService.authentication.userName;
            $scope.registro.AddIdent = authService.authentication.isAddIdent;
            $scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;

            var url = '/api/Usuarios/Usuarios/BuscarXUsuario';
            var servCall = APIService.saveSubscriber($scope.registro, url);
            servCall.then(function (datos) {
                $scope.datos = datos.data[0];
                abrirModal($scope.datos);
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        };

       
    };

    var abrirModal = function (entity) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/NuevoEditarUsuarios.html',
            controller: 'ModalNuevoEditarUsuarioController',
            backdrop: 'static', keyboard: false,
            size: 'lg',
            resolve: {
                entity: function () {
                    return entity;
                }
            }
        });
        modalInstance.result.then(
            function () {
                var mensaje = "Los datos de contacto de " + entity.Nombres + " han sido actualizados satisfactoriamente";
                openRespuesta(mensaje);
            }
        );
    }
    

    //-----------------MODAL DE CONFIRMACIÓN------------------
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