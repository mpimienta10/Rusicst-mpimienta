app.controller('LoginController', ['$scope', 'APIService', 'UtilsService', 'authService', '$log', '$location', '$uibModal', function ($scope, APIService, UtilsService, authService, $log, $location, $uibModal) {

    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.registro = {};
    $scope.intento = false;
    $scope.cargando = false;
    $scope.IE = false;
    var es_ie = navigator.appName;

    if (es_ie == 'Microsoft Internet Explorer') {
        var ua = navigator.userAgent,
            re = new RegExp("MSIE ([0-9]{1,}[\\.0-9]{0,})");

        if (re.exec(ua) !== null) {
            errorExplorador();
        }
    }
    else if (es_ie == "Netscape") {
        if (navigator.appVersion.indexOf('Trident') > -1) {
            errorExplorador();
        }
    }

    function errorExplorador() {
        var mensaje = { msn: 'Este navegador no soporta la página seleccionada, por favor utilice Google Chrome o Firefox para continuar con el acceso.', tipo: "alert alert-danger" };
        UtilsService.abrirRespuesta(mensaje);
        $scope.IE = true;
    }

    //------------Acción de Loguearse---------------------
    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        $scope.registro.useRefreshTokens = false;
        $scope.cargando = true;
        guardarDatos();
    };

    function guardarDatos() {

        authService.login($scope.registro).then(function (response) {
            $location.url('/Index');
        },
            function (err) {
                ////===========================================================================
                //// Si en el primer intento no se loguea se intentará hacer una vez más.
                //// La razón, a veces en la primera vez que se ingresa el sistema esta 'frio'
                ////===========================================================================
                if (err.data === null && $scope.intento === false) {
                    $scope.cargando = true;
                    $scope.intento === true;
                    guardarDatos();
                };

                if (err.data.error) {
                    var mensaje = { msn: 'Error: El nombre de USUARIO y/o la CONTRASEÑA no son correctos.', tipo: "alert alert-danger" };
                    UtilsService.abrirRespuesta(mensaje);
                }
            });
        $scope.cargando = false;
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    ////===============================================================
    //// Función utilizada para la autenticación por directorio activo
    ////===============================================================
    $scope.autenticarAD = function () {
        //// Despliega la ventana modal
        $scope.PopUpUsuariosInternos();
    };

    $scope.PopUpUsuariosInternos = function (entity) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/home/modals/UsuariosInternos.html',
            controller: 'ModalUsuariosInternosController',
            size: 'lg',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    if (entity) {
                        return angular.copy(entity);
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
             function (resultado) {
             }
        );
    };
}]);

app.controller('ModalUsuariosInternosController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', '$state', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService, $state) {
    $scope.registro = entity || {};
    $log.log(entity);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '/api/Usuarios/Autenticacion/ValidarUsuariosInternos';

    $scope.aceptar = function () {
        $scope.errors = [];
        if (!$scope.validar()) return false;
        enviarDatos();
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    $scope.cancelar = function () {
        $uibModalInstance.close(false);
    };

    function enviarDatos() {
        $scope.cargando = true;
        $scope.error = '';
        var servCall = APIService.saveSubscriber($scope.registro, $scope.url);
        servCall.then(function successCallback(response) {
            debugger;
            if (response.data != '' && response.data != '-1' && response.data != '-2') {
                $scope.cargando = false;
                authService.loginAD(response);
                $state.go('Index.Index', {}, { reload: true });
                $uibModalInstance.close(false);
            }
            else {
                $scope.registro.UserName = null;
                $scope.registro.password = null;
                $scope.cargando = false;

                if (response.data != '')
                    $scope.error = response.data == '-1' ? "El usuario no se encuentra en el RUSICST" : "Se encontraron errores en el Nombre de Usuario o en la Contraseña. Por favor verifique";
            }
        }, function errorCallback(response) {
            $scope.cargando = false;
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    }
}]);
