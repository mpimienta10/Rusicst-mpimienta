app.controller('PrecargueRespuestasController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', 'Upload', 'ngSettings', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService, Upload, ngSettings) {
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.alerta = "Debe seleccionar un archivo de excel con peso menor a 25MB";
    $scope.reporte = [];
    $scope.realizoPrecargue = true;
    $scope.validarExtension = function () {
        $scope.extension = false;
        if ($scope.file) {
            var filename = $scope.file.name;
            var index = filename.lastIndexOf(".");
            var strsubstring = filename.substring(index, filename.length);
            strsubstring = strsubstring.toLowerCase();
            if (strsubstring == '.xlsx' || strsubstring == '.xls') {
                $scope.extension = true;
                return true;
            } else {
                $scope.extension = false;
                //$scope.realizoPrecargue = true;
                return false;
            }
        }
    }
    $scope.upload = function (file) {
        var serviceBase = ngSettings.apiServiceBaseUri;      
        Upload.upload({
            url: serviceBase + $scope.url,
            method: "POST",
            data: $scope.reporte,
            file: file,
        }).then(function (Resultado) {
            $scope.extension = false;
            switch (Resultado.data.estado) {
                case 0:
                    var mensaje = { msn: Resultado.data.respuesta, tipo: "alert alert-warning" };
                    mostrarMensaje(mensaje);
                    break;
                case 1:
                    var ids = "";
                    angular.forEach(Resultado.data.listaIdEncuestasBorradas, function (encuesta) {
                        ids = ids + encuesta.IdEncuesta + ","
                    });
                    var mensajeborradas = (Resultado.data.listaIdEncuestasBorradas.length > 0) ? " Se borro informacion anterior de las siguientes " + Resultado.data.listaIdEncuestasBorradas.length + " encuestas: " + ids.substring(0, ids.length-1) : "";
                    var mensaje = { msn: "El proceso se realizo satisfactoriamente. Se precargaron " + Resultado.data.cantidadPrecargue + " respuestas." + mensajeborradas, tipo: "alert alert-success" };
                    mostrarMensaje(mensaje);
                    break;
                case 2:
                    var mensajeborradas = (Resultado.data.listaIdEncuestasBorradas.length > 0) ? " Se borro informacion anterior de las siguientes " + Resultado.data.listaIdEncuestasBorradas.length + " encuestas: " + ids.substring(0, ids.length - 1) : "";
                    var mensaje = { msn: "El proceso se realizo satisfactoriamente. Se precargaron " + Resultado.data.cantidadPrecargue + " respuestas." + mensajeborradas, tipo: "alert alert-success" };
                    mostrarMensaje(mensaje);
                    break;
            }            
        }, function (Resultado) {
            var mensaje = { msn: 'Error: ' + resultado.data.exceptionMessage, tipo: "alert alert-danger" };
            $scope.realizoPrecargue = true;
            alert(mensaje);
        }, function (evt) {
            //alert("evt");
        });        
    };

    function mostrarMensaje(mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    var enviar = { msn: mensaje.msn, tipo: mensaje.tipo };
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
             function (datosRespuesta) {
                 $scope.extension = true;
                 $scope.realizoPrecargue = true;
             }
           );
    }

    $scope.guardarDatos = function () {
        if ($scope.file) {
            $scope.realizoPrecargue = false;
            $scope.extension = true;
            $scope.alerta = null;
            if (!$scope.validarExtension()) return false;
            $scope.url = '/api/Reportes/PrecargueRespuestas/CargarArchivo';
            $scope.reporte.AudUserName = authService.authentication.userName;
            $scope.reporte.AddIdent = authService.authentication.isAddIdent;
            $scope.reporte.UserNameAddIdent = authService.authentication.userNameAddIdent;
            $scope.abrirModalNConfirmacion();           
        } else {
            $scope.alerta = "Debe seleccionar un archivo de excel con peso menor a 25MB";
        }
    }
    $scope.abrirModalNConfirmacion = function () {
        var modelo = {};
        //// Cargar los datos de auditoría
        modelo.AudUserName = authService.authentication.userName;
        modelo.AddIdent = authService.authentication.isAddIdent;
        modelo.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var modalInstance = $uibModal.open({
            templateUrl: '/app/views/modals/Confirmacion.html',
            controller: 'ModalConfirmacionController',
            backdrop: 'static', keyboard: false,
            resolve: {
                datos: function () {
                    $scope.disabledguardando = 'disabled';
                    var titulo = 'Cargar precargue de respuestas de encuestas';
                    var url = '/api/TableroPat/IngresarTablero';
                    var entity = modelo;
                    var msn = "¿Está seguro de cargar el archivo? Tenga en cuenta que si ya existe un precargue para la encuesta indicada en el nuevo archivo, se borrarán los registros y se reemplazarán con estos nuevos.";
                    return { url: url, entity: entity, msn: msn, titulo: titulo }
                }
            }
        });
        modalInstance.result.then(
            function (datosResponse) {
                if (datosResponse) {
                    $scope.upload($scope.file);
                }
            }
        );
    };
}])
;