app.controller('ModalRespuestaController', function ($scope, $uibModalInstance, datos) {
    $scope.msn = datos.msn || "Proceso realizado con éxito";
    $scope.tipo = datos.tipo;
    $scope.cerrar = function () {        
        $uibModalInstance.close();
    };
});