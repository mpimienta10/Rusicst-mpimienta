app.controller('ConfiguracionArchivosAyudaController', ['$scope', 'APIService', 'UtilsService', '$log', '$uibModal', 'Upload', 'ngSettings', 'authService', function ($scope, APIService, UtilsService, $log, $uibModal, Upload, ngSettings, authService) {
    $scope.started = true;
    $scope.archivo = {};
    $scope.ayudas = [];
    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.descargar = function (index) {
        var url = $scope.serviceBase + '/api/Sistema/Download?archivo=' + $scope.ayudas[index].Id + '&nombreArchivo=' + $scope.ayudas[index].Titulo;
        window.open(url)
    }

    function cargarAyudas() {
        var url = '/api/Sistema/ConfiguracionArchivosAyuda/';
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.ayudas = datos;
            }, function (error) {
                $scope.error = "Se generó un error en la petición al cargar las ayudas";
            });
        }
    }
    cargarAyudas();

    //**************  Agregar y Upload *****************************************
    $scope.agregar = function () {
        if (!$scope.validar()) return false;
        $scope.upload($scope.file);
    }
    $scope.upload = function (file) {
        $scope.registro = {};
        $scope.registro.nombre = $scope.nombre;

        $scope.registro.AudUserName = authService.authentication.userName;
        $scope.registro.AddIdent = authService.authentication.isAddIdent;
        $scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var filename = file.name;
        var index = filename.lastIndexOf(".");
        var strsubstring = filename.substring(index, filename.length);
        strsubstring = strsubstring.toLowerCase();

        if (strsubstring == '.pdf' || strsubstring == '.doc' || strsubstring == '.docx' || strsubstring == '.xlsx' || strsubstring == '.xls' || strsubstring == '.png' || strsubstring == '.jpeg' || strsubstring == '.png' || strsubstring == '.jpg' || strsubstring == '.gif' || strsubstring == '.txt') {
            Upload.upload({
                url: $scope.serviceBase + '/api/Sistema/ConfiguracionArchivosAyuda/Insertar',
                method: "POST",
                data: $scope.registro,
                file: file,
            }).then(function (resp) {
                var mensaje = { msn: "El material de ayuda ha sido registrado satisfactoriamente", tipo: "alert alert-success" };
                UtilsService.abrirRespuesta(mensaje);
                cargarAyudas();
            }, function (resp) {
                var mensaje = { msn: 'Error: ' + resp.status, tipo: "alert alert-danger" };
                UtilsService.abrirRespuesta(mensaje);
                cargarAyudas();
            }, function (evt) {
                //var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
                //$scope.progressPercentage = 'progreso: ' + progressPercentage + '% ' + evt.config.data.file.name;
            });
            $scope.nombre = null;
            $scope.progressPercentage = '';
            $scope.submitted = false;
            $scope.archivo = {};
            $scope.file = null;
            $scope.registro = null;
            submitted = null;
        }
        else {
            $scope.extension = true;
        }
    };
    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
    //********* Fin Agregar y Upload ******************

    //********** Acciones ******************************
    $scope.abrirModalModificarAyuda = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/ModificarAyuda.html',
            controller: 'ModalModificarAyudaController',
            resolve: {
                ayuda: function () {
                    if ($scope.ayudas[index]) {

                        $scope.ayudas[index].AudUserName = authService.authentication.userName;
                        $scope.ayudas[index].AddIdent = authService.authentication.isAddIdent;
                        $scope.ayudas[index].UserNameAddIdent = authService.authentication.userNameAddIdent;

                        return angular.copy($scope.ayudas[index]);
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
                cargarAyudas();
            }
        );
    };

    $scope.abrirModalEliminar = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            resolve: {
                datos: function () {
                    if ($scope.ayudas[index].Id) {

                        $scope.ayudas[index].AudUserName = authService.authentication.userName;
                        $scope.ayudas[index].AddIdent = authService.authentication.isAddIdent;
                        $scope.ayudas[index].UserNameAddIdent = authService.authentication.userNameAddIdent;

                        var enviar = { url: '/api/Sistema/ConfiguracionArchivosAyuda/Eliminar/', msn: '¿Está Seguro de Eliminar el material de ayuda "' + $scope.ayudas[index].Titulo + '"?', entity: $scope.ayudas[index] };
                        return enviar;
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
                cargarAyudas();
                var mensaje = { msn: 'El material de ayuda ha sido eliminado satisfactoriamente.', tipo: 'alert alert-success' };
                UtilsService.abrirRespuesta(mensaje);
            }
           );
    };
}]);

app.controller('ModalModificarAyudaController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', 'Upload', 'UtilsService', 'ngSettings', 'ayuda', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, Upload, UtilsService, ngSettings, ayuda, authService) {
    $scope.ayuda = ayuda || {};
    $scope.nombre = $scope.ayuda.Titulo;
    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.errorMessages = UtilsService.getErrorMessages();

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.agregar = function () {
        if (!$scope.validar()) return false;
        if ($scope.file) {
            $scope.upload($scope.file);
        } else {
            $scope.ayuda.nombre = $scope.nombre;
            var url = "/api/Sistema/ConfiguracionArchivosAyuda/ModificarNombre";
            var servCall = APIService.saveSubscriber($scope.ayuda, url);
            servCall.then(function (response) {
                var mensaje = { msn: "El material de ayuda ha sido actualizado satisfactoriamente", tipo: "alert alert-success" };
                UtilsService.abrirRespuesta(mensaje);
                $uibModalInstance.close();
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
    }

    $scope.upload = function (file) {
        var filename = file.name;
        var index = filename.lastIndexOf(".");
        var strsubstring = filename.substring(index, filename.length);
        strsubstring = strsubstring.toLowerCase();
        if (strsubstring == '.pdf' || strsubstring == '.doc' || strsubstring == '.docx' || strsubstring == '.xlsx' || strsubstring == '.xls' || strsubstring == '.png' || strsubstring == '.jpeg' || strsubstring == '.png' || strsubstring == '.jpg' || strsubstring == '.gif' || strsubstring == '.txt') {
            $scope.ayuda.nombre = $scope.nombre;
            Upload.upload({
                url: $scope.serviceBase + '/api/Sistema/ConfiguracionArchivosAyuda/Modificar',
                method: "POST",
                data: $scope.ayuda,
                file: file,
            }).then(function (resp) {
                var mensaje = { msn: "El material de ayuda ha sido actualizado satisfactoriamente", tipo: "alert alert-success" };
                UtilsService.abrirRespuesta(mensaje);
                $uibModalInstance.close();
            }, function (resp) {
                var mensaje = { msn: 'Error: ' + resp.status, tipo: "alert alert-danger" };
                UtilsService.abrirRespuesta(mensaje);
            }, function (evt) {
                var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
                console.log('progress: ' + progressPercentage + '% ' + evt.config.data.file.name);
                $scope.progressPercentage = 'progress: ' + progressPercentage + '% ' + evt.config.data.file.name;
            });
        } else {
            $scope.extension = true;
        }

    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);
