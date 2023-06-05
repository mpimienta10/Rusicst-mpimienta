app.controller('ParametrosSistemaController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService) {
    $scope.started = true;
    $scope.parametro = {};


    //TinyMCE BODY Config
    $scope.tinymceOptions = {
        height: 250,
        theme: 'modern',
        menubar: true,
        language: 'es',
        plugins: 'advlist autolink lists link image charmap print preview anchor searchreplace visualblocks code fullscreen insertdatetime media table contextmenu paste code emoticons template paste textcolor colorpicker textpattern imagetools',
        toolbar1: 'undo redo | insert | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | code',
        toolbar2: 'print preview media | fontselect fontsizeselect forecolor backcolor emoticons',
        content_css: '//www.tinymce.com/css/codepen.min.css'
    };

    function cargarDatosSistema() {
        var url = '/api/Sistema/ParametrosSistema/';
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.registro = datos;
            }, function (error) {
                $scope.error = "Se generó un error en la petición al cargar las ayudas";
            });
        }
    }

    cargarDatosSistema();

    $scope.guardar = function () {
        $scope.alerta = null;
        $scope.error = null;

        $scope.registro.AudUserName = authService.authentication.userName;
        $scope.registro.AddIdent = authService.authentication.isAddIdent;
        $scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var url = '/api/Sistema/ParametrosSistema/Modificar';
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (response) {
            if (!response.status == 200 && !response.statusText == "OK") {
                $scope.error = "Se generó un error en la petición, no se guardaron los datos." + response.statusText;
            } else {
                var mensaje = { msn: "La información se ha actualizado satisfactoriamente.", tipo: "alert alert-success" }
                UtilsService.abrirRespuesta(mensaje);
                cargarDatosSistema();
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);
