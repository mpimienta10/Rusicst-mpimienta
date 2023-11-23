app.controller('RegistroController', ['$scope', 'APIService', 'UtilsService', '$log', 'Upload', '$uibModal', '$templateCache', 'vcRecaptchaService', 'ngSettings', '$location', 'authService', function ($scope, APIService, UtilsService, $log, Upload, $uibModal, $templateCache, vcRecaptchaService, ngSettings, $location, authService) {
    $scope.submitted = false;
    $scope.deshabiltarRegistrese = false;
    $scope.registro = {};
    $scope.departamentoSeleccionado = 0;
    $scope.errorMessages = UtilsService.getErrorMessages();

    //--------------Obtener Departamentos y Municipios-------------------
    getDepartamentosYMunicipios();
    function getDepartamentosYMunicipios() {
        var urlServGet = '/api/General/Listas/DepartamentosMunicipios?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servGet = APIService.getSubs(urlServGet);
        servGet.then(function (response) {
            $scope.DepartamentosYMunicipios = response;
            $scope.Departamentos = UtilsService.getArrayCascade(response, "IdDepartamento", "Departamento");
        }, function (error) {
            $scope.error = "se generó un error en la petición, no se guardaron los datos";
        });
    }
    $scope.cargarMunicipios = function () {
        var idDepartamento = parseInt($scope.registro.IdDepartamento);
        $scope.Municipios = [];
        $scope.Municipios.push({ Departamento: '', IdDepartamento: idDepartamento, IdMunicipio: 0, Municipio: "--Seleccione--" });
        if (idDepartamento === 0) {
            $scope.alerta = "Debe seleccionar un departamento";
        }
        else {
            angular.forEach($scope.DepartamentosYMunicipios, function (municipio) {
                if (municipio.IdDepartamento === idDepartamento)
                    $scope.Municipios.push(municipio);
            });
        }
    }
    //--------------Fin Obtener Departamento y Municipios------------------------

    //-----UPLOAD FILE---------------------------------------------
    // upload on file select or drop
    $scope.upload = function (file) {
        $scope.deshabiltarRegistrese = true;
        ////================================================================
        ////Este ajuste fue necesario para evitar un rompimiento en el JSON 
        var idMunicipio = $scope.registro.IdMunicipio;
        if (idMunicipio == null) $scope.registro.IdMunicipio = 0;
        ////================================================================
        $scope.registro.Nombres = $scope.registro.Nombre + ' ' + $scope.registro.Apellidos;
        var serviceBase = ngSettings.apiServiceBaseUri;
        $scope.registro.Url = ngSettings.frontEndBaseUri;
        Upload.upload({
            url: serviceBase + '/api/Usuarios/GestionarSolicitudes/InsertarSolicitud',
            method: "POST",
            data: $scope.registro,
            file: file,
        }).then(function (resultado) {
            $scope.deshabiltarRegistrese = false;
            switch (resultado.data.estado) {
                case 0:
                    var mensaje = { msn: resultado.data.respuesta, tipo: "alert alert-warning" };
                    openRespuesta(mensaje);
                    break;
                case 1:
                    var mensaje = { msn: resultado.data.respuesta, tipo: "alert alert-success" };
                    openRespuesta(mensaje);
                    $scope.registro = {};
                    break;
            }
        }, function (resultado) {
            $scope.deshabiltarRegistrese = false;
            var mensaje = { msn: 'Error: ' + resultado.data.ExceptionMessage, tipo: "alert alert-danger" };
            openRespuesta(mensaje);
        }, function (evt) {
            var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
        });
    };
    //--------------FIN UPLOADER-----------------------------------

    //----------------RECAPTCHA------------------------------------
    $scope.response = null;
    $scope.widgetId = null;
    $scope.model = {
        key: '6Ld4QxcUAAAAACKpAioYiaNsE4XMREcSfEm-NAKf'
    };
    $scope.setResponse = function (response) {
        $scope.response = response;
    };
    $scope.setWidgetId = function (widgetId) {
        $scope.widgetId = widgetId;
    };
    $scope.cbExpiration = function () {
        vcRecaptchaService.reload($scope.widgetId);
        $scope.response = null;
    };
    //--------------FIN RECAPTCHA----------------------------------

    //---------------ACCION GUARDAR DATOS--------------------------
    $scope.aceptar = function () {
        $scope.errors = [];
        //Validar Captcha
        var v = grecaptcha.getResponse();
        $scope.errorValidationCaptcha = false;
        if (v.length == 0) {
            vcRecaptchaService.reload($scope.widgetId);
            $scope.errorValidationCaptcha = true;
            return false;
        }

        //Validar otros campos
        if (!$scope.validar()) return false;


        $scope.upload($scope.file);
        vcRecaptchaService.reload($scope.widgetId);
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //------------------------Lógica de Modal de Acciones -----------------------------------------
    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    $scope.deshabiltarRegistrese = false;
                    var enviar = mensaje;
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
             function () {

             });
    };

}]);

