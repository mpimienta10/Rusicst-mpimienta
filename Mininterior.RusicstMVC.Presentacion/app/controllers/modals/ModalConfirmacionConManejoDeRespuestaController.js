app.controller('ModalConfirmacionConManejoDeRespuestaController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'datos', 'UtilsService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, datos, UtilsService) {
    $scope.titulo = datos.titulo;
    $scope.msn = datos.msn;
    $scope.tipo = datos.tipo;
    $scope.cancelar = function () {
        $uibModalInstance.close(false);
    };
    $scope.aceptar = function () {
         $uibModalInstance.close(true);
    
    };
}]);