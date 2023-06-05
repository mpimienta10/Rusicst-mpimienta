app.controller('ModalEliminarController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'datos', 'UtilsService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, datos, UtilsService) {
    $scope.msn = datos.msn || "¿Esta seguro de que desea realizar la eliminación?";
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    $scope.aceptar = function () {
        $scope.errors = [];
        if (datos.url) {
            if (datos.entity === undefined) datos.entity = null;
            var servCall = APIService.saveSubscriber(datos.entity, datos.url);
            servCall.then(function (response) {

                if ((response.status == 200 && response.data.estado == null && response.data == '') || response.data.estado == 3) {
                    $uibModalInstance.close(true);
                } else {
                    if (response.data.length > 0)
                        $scope.error = response.data;
                    else
                        $scope.error = response.data.respuesta;
                }
            }, function (error) {
                $scope.error = $scope.errorMessages.delete;
            });
        }
    };
}]);