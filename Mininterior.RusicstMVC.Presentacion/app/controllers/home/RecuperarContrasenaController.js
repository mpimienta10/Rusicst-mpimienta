
app.controller('RecuperarContrasenaController', ['$scope', 'APIService', '$uibModal', function ($scope, APIService, $uibModal) {
    $scope.abrirModalRecuperarContrasena = function () {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/home/modals/RecuperarContrasena.html',
            controller: 'ModalRecuperarContrasenaController',
            backdrop: 'static', keyboard: false,
            size: 'lg',
        });
    };
}]);

app.controller('ModalRecuperarContrasenaController', ['$scope', 'APIService', 'UtilsService', '$log', '$uibModalInstance', function ($scope, APIService, UtilsService, $log, $uibModalInstance) {
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.registro = {};

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
        $scope.registro.Url = location.host + '/#!/';
        var servCall = APIService.saveSubscriber($scope.registro, url);

        servCall.then(function (response) {
            $scope.cargando = false;
            $uibModalInstance.close();

            if (response.data == '')
                var mensaje = { msn: 'Una nueva contraseña fue enviada al correo proporcionado', tipo: 'alert alert-success' };
            else
                var mensaje = { msn: response.data, tipo: 'alert alert-danger' };

            UtilsService.abrirRespuesta(mensaje);
        }, function (error) {
            $scope.cargando = false;
            $scope.esExistoso = false;
            mensaje = { msn: "Error: " + error.data.ModelState[""][0] + '.', tipo: "alert alert-danger" };
            UtilsService.abrirRespuesta(mensaje);
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
    //---------------FIN ENVIAR DATOS-------------

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

