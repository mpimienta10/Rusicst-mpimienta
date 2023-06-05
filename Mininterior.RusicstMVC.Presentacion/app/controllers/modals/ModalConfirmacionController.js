app.controller('ModalConfirmacionController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'datos', 'UtilsService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, datos, UtilsService) {
    $scope.titulo = datos.titulo;
    $scope.msn = datos.msn;
    $scope.flagVariable = false;
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.cancelar = function () {
        $uibModalInstance.close(false);
    };
    $scope.aceptar = function () {
        $scope.flagVariable = true;
        $scope.errors = [];
        if (datos.url) {
            if (datos.entity === undefined) datos.entity = null;
            var servCall = APIService.saveSubscriber(datos.entity, datos.url);
            servCall.then(function (response) {
                $scope.flagVariable = false;
                $uibModalInstance.close(response.data);
            }, function (error) {
                $scope.flagVariable = false;
                $scope.error = $scope.errorMessages.exception;
            });
        }
        else
        {
            $uibModalInstance.close();
        }
    };
}]);