app.controller('ContactanosController', ['$scope', 'APIService', '$uibModal', function ($scope, APIService, $uibModal) {
   
    //------------------------Lógica de Modal de Acciones -----------------------------------------
    $scope.abrirModalContactanos = function () {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/home/modals/Contactanos.html',
            controller: 'ModalContactanosController',
            backdrop: 'static', keyboard: false,
            size: 'lg',
        });
        modalInstance.result.then(
            function () {
                var mensaje = "El correo fue enviado satisfactoriamente";
                openRespuesta(mensaje);
            }
        );
    };
    
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

app.controller('ModalContactanosController', ['$scope', 'APIService', 'UtilsService', '$log', '$uibModalInstance', function ($scope, APIService, UtilsService, $log, $uibModalInstance) {
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.registro = {};
    $scope.enviando = false;
   
    //---------------ENVIAR DATOS-----------------
    $scope.cancelar = function () {
        $uibModalInstance.dismiss();
    };

    $scope.aceptar = function () {
         $scope.errors = [];
        if (!$scope.validar()) return false;
        $scope.registro.Mensaje = $scope.registro.Mensaje.replace(/"/g, "'");
        guardarDatos();
    };

    function guardarDatos() {
        $scope.enviando = true;
        var url = "/api/Usuarios/Contactenos/Enviar";
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (response) {
            $scope.enviando = false;
            $scope.estado = response.data.estado;
            switch ($scope.estado) {
                    case 0:
                        $scope.error = 'Ocurrió un error al enviar el correo';
                        break;
                    case 5:
                        $uibModalInstance.close();
                        break;
            }
        }, function (error) {
            $scope.enviando = false;
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }
    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
    //---------------FIN ENVIAR-------------

    //---------------------TinyMCE---------------------------------
    $scope.registro.Mensaje = '';

    $scope.tinymceOptions = {
        language: 'es',
        forced_root_block: "",
        statusbar: false,
        browser_spellcheck: false,
        theme: 'modern',
        toolbar1: 'undo redo | insert | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image',
        image_advtab: true,
        templates: [
            { title: 'Test template 1', content: 'Test 1' },
            { title: 'Test template 2', content: 'Test 2' }
        ],
        content_css: [
            '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
            '//www.tinymce.com/css/codepen.min.css'
        ],
        height: 300,
    };
    //---------------Fin TinyMCE-----------------------------------------
}]);
app.controller('PopUpRecuperarContrasenaController', ['$scope', 'APIService', 'UtilsService', '$log', '$uibModalInstance', function ($scope, APIService, UtilsService, $log, $uibModalInstance) {
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.registro = {};

    //---------------ENVIAR DATOS-----------------
    $scope.cancelar = function () {
        $uibModalInstance.close(false);
    };
    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        $scope.registro.Mensaje = $scope.registro.Mensaje.replace(/"/g, "'");
        $scope.cargando = true;
        guardarDatos();
    };
    function guardarDatos() {
        var url = "/api/Usuarios/Autenticacion/RecuperarContrasena";
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (response) {
            $scope.cargando = false;
            $scope.estado = response.data.estado;
            switch ($scope.estado) {
                case 0:
                    $scope.error = 'Ocurrió un error al enviar el correo';
                    break;
                case 5:
                    $uibModalInstance.close();
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }
    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
    //---------------FIN ENVIAR-------------

    //---------------------TinyMCE---------------------------------
    $scope.registro.Mensaje = '';

    $scope.tinymceOptions = {
        language: 'es',
        forced_root_block: "",
        statusbar: false,
        browser_spellcheck: false,
        theme: 'modern',
        toolbar1: 'undo redo | insert | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image',
        image_advtab: true,
        templates: [
            { title: 'Test template 1', content: 'Test 1' },
            { title: 'Test template 2', content: 'Test 2' }
        ],
        content_css: [
            '//fonts.googleapis.com/css?family=Lato:300,300i,400,400i',
            '//www.tinymce.com/css/codepen.min.css'
        ],
        height: 300,
    };
    //---------------Fin TinyMCE-----------------------------------------
}]);

