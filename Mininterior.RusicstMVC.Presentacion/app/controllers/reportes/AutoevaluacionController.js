app.controller('AutoevaluacionV1Controller', ['$scope', 'APIService', '$stateParams', '$location', '$log', '$sce', 'ngSettings', 'Upload', '$uibModal', 'UtilsService', 'authService', '$filter', function ($scope, APIService, $stateParams, $location, $log, $sce, ngSettings, Upload, $uibModal, UtilsService, authService, $filter) {
    //===== Declaración de Variables ======================
    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.autenticacion = authService.authentication;

    $scope.plan = {};
    $scope.plan.IdEncuesta = parseFloat($stateParams.IdEncuesta);
    $scope.plan.IdUsuario = null;

    $scope.cargoDatos = null;
    $scope.datos = [];

    $scope.cssClass;

    $scope.showRowProceso = true;
    $scope.showRowCategoria = true;

    $scope.cantProceso = '';
    $scope.cantCategoria = '';

    UtilsService.getDatosUsuarioAutenticado().respuesta().then(function (respuesta) {

        if (angular.isDefined($stateParams.IdUsuario) && $stateParams.IdUsuario == "null") {
            $scope.plan.IdUsuario = respuesta.Id;
        } else {
            $scope.plan.IdUsuario = $stateParams.IdUsuario;
        }

        getDatos();
    });
    
    //-----------------------OBTENER SECCIONES Y Recomendaciones----------------------------------
    
    function getDatos() {
        var url = '/api/Reportes/Encuesta/AutoevaluacionV1/DatosAutoevaluacion?idEncuesta=' + $scope.plan.IdEncuesta + '&idUsuario=' + $scope.plan.IdUsuario;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.cargoDatos = true;

            angular.forEach(response, function (item, key) {

                item.showRowProceso = $scope.cantProceso != item.NombreProceso;
                item.showRowCategoria = $scope.cantCategoria != item.NombreCategoria;

                $scope.cantProceso = item.NombreProceso;
                $scope.cantCategoria = item.NombreCategoria;

            });

            $scope.datos = response;

            //console.log($scope.datos);

        }, function (error) {
            console.log(error);
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };
    
    //DataPicker

    $scope.minDate = new Date();

    $scope.popup1 = {
        opened: false
    };
    $scope.open1 = function () {
        $scope.popup1.opened = true;
    };
    $scope.dateOptions = {
        formatYear: 'yyyy',
        startingDay: 1
    };

    $scope.format = "dd/MM/yyyy";

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

}]);