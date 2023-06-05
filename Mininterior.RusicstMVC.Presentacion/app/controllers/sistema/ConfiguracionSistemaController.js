app.controller('ConfiguracionSistemaController', ['$scope', '$http', 'APIService', 'UtilsService', '$log', '$uibModal', 'Upload', 'ngSettings', 'authService', function ($scope, $http, APIService, UtilsService, $log, $uibModal, Upload, ngSettings, authService) {
    $scope.started = true;
    $scope.datosHome = {};
    $scope.serviceBase = ngSettings.apiServiceBaseUri;
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.uploadingText = false;
    $scope.uploadingMint = false;
    $scope.uploadingApp = false;
    $scope.uploadingGob = false;
    $scope.uploadingLinks = false;

    //regex para validar urls validas
    $scope.regexURL = "^(http[s]?:\\/\\/){0,1}(www\\.){0,1}[a-zA-Z0-9\\.\\-]+\\.[a-zA-Z]{2,5}[\\.]{0,1}";

    //TinyMCE BODY Config
    $scope.tinymceOptions = {
        height: 500,
        theme: 'modern',
        menubar: true,
        language: 'es',
        plugins: 'advlist autolink lists link image charmap print preview anchor searchreplace visualblocks code fullscreen insertdatetime media table contextmenu paste code emoticons template paste textcolor colorpicker textpattern imagetools',
        toolbar1: 'undo redo | insert | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | code',
        toolbar2: 'print preview media | fontselect fontsizeselect forecolor backcolor emoticons',
        content_css: '//www.tinymce.com/css/codepen.min.css'
    };

    //TinyMCE Footer Config
    $scope.tinymceOptionsFooter = {
        height: 200,
        theme: 'modern',
        menubar: true,
        language: 'es',
        plugins: 'advlist autolink lists link image charmap print preview anchor searchreplace visualblocks code fullscreen insertdatetime media table contextmenu paste code emoticons template paste textcolor colorpicker textpattern imagetools',
        toolbar1: 'undo redo | insert | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | code',
        toolbar2: 'print preview media | fontselect fontsizeselect forecolor backcolor emoticons',
        content_css: '//www.tinymce.com/css/codepen.min.css'
    };

    $scope.range = function (min, max, step) {
        step = step || 1;
        var input = [];
        for (var i = min; i < max; i += step) {
            input.push(i);
        }
        return input;
    };

    function cargarHome() {
        var url = '/api/Sistema/ConfiguracionSistema/';
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.datosHome = datos;
            }, function (error) {
                $scope.error = "Se generó un error en la petición al cargar los datos del Home";
            });
        }
    }

    cargarHome();

    $scope.eliminarLinkGobierno = function (group, num) {

        $scope.Link = {};
        $scope.Link.idNum = num;
        $scope.Link.group = group;

        $scope.Link.AudUserName = authService.authentication.userName;
        $scope.Link.AddIdent = authService.authentication.isAddIdent;
        $scope.Link.UserNameAddIdent = authService.authentication.userNameAddIdent;

        $scope.uploadingLinks = true;

        $scope.url = '/api/Sistema/ConfiguracionSistema/EliminarParametroGobierno';

        var servCall = APIService.saveSubscriber($scope.Link, $scope.url);
        servCall.then(function (response) {
            var resultado = {};
            resultado.estado = response.data.estado
            switch (response.data.estado) {
                case 0:
                    var mensaje = { msn: 'Error: ' + response.data.respuesta, tipo: "alert alert-danger" };
                    UtilsService.abrirRespuesta(mensaje);
                    $scope.uploadingLinks = false;
                    cargarHome();
                    break;
                default:
                    var mensaje = { msn: "Se Eliminó correctamente el Enlace", tipo: "alert alert-success" };
                    UtilsService.abrirRespuesta(mensaje);
                    $scope.uploadingLinks = false;
                    cargarHome();
                    break;
            }
        }, function (error) {
            var mensaje = { msn: 'Error: ' + error, tipo: "alert alert-danger" };
            UtilsService.abrirRespuesta(mensaje);
            $scope.uploadingLinks = false;
            cargarHome();
        });

        cargarHome();
    }

    $scope.agregarLinkGobierno = function (group) {
        var valido = true;
        var msg = '';
        console.log('URL: ' + $scope.newItemUrl);
        if ($scope.newItemUrl == '' || $scope.newItemUrl == undefined)
        {
            msg = 'La URL ingresada no es válida';
            valido = false;
        }

        if ($scope.itemText == '' || $scope.itemText == undefined) {
            msg = 'Debe escribir el Nombre del Enlace';
            valido = false;
        }

        if (valido)
        {
            $scope.Link = {};
            $scope.Link.keyUrl = $scope.newItemUrl;
            $scope.Link.keyNombre = $scope.itemText;
            $scope.Link.keyColor = $scope.itemColor;
            $scope.Link.group = group;

            $scope.Link.AudUserName = authService.authentication.userName;
            $scope.Link.AddIdent = authService.authentication.isAddIdent;
            $scope.Link.UserNameAddIdent = authService.authentication.userNameAddIdent;

            $scope.uploadingLinks = true;

            $scope.url = '/api/Sistema/ConfiguracionSistema/GuardarParametroGobierno';

            var servCall = APIService.saveSubscriber($scope.Link, $scope.url);
            servCall.then(function (response) {
                var resultado = {};
                resultado.estado = response.data.estado
                switch (response.data.estado) {
                    case 0:
                        var mensaje = { msn: 'Error: ' + response.data.respuesta, tipo: "alert alert-danger" };
                        UtilsService.abrirRespuesta(mensaje);
                        $scope.uploadingLinks = false;
                        cargarHome();
                        break;
                    default:
                        var mensaje = { msn: "Se Agregó correctamente el Enlace", tipo: "alert alert-success" };
                        UtilsService.abrirRespuesta(mensaje);
                        $scope.uploadingLinks = false;
                        $scope.newItemUrl = '';
                        $scope.itemText = '';
                        cargarHome();
                        break;
                }
            }, function (error) {
                var mensaje = { msn: 'Error: ' + error, tipo: "alert alert-danger" };
                UtilsService.abrirRespuesta(mensaje);
                $scope.uploadingLinks = false;
                cargarHome();
            });

            cargarHome();
        } else {
            var mensaje = { msn: msg, tipo: "alert alert-danger" };
            UtilsService.abrirRespuesta(mensaje);
        }
    }

    $scope.modificarFooterHome = function (key, value, group){
        $scope.text = {};
        $scope.text.key = key;
        $scope.text.value = value;
        $scope.text.group = group;

        $scope.text.AudUserName = authService.authentication.userName;
        $scope.text.AddIdent = authService.authentication.isAddIdent;
        $scope.text.UserNameAddIdent = authService.authentication.userNameAddIdent;

        $scope.uploadingText = true;

        $scope.url = '/api/Sistema/ConfiguracionSistema/GuardarTextoFooterBody';

        var servCall = APIService.saveSubscriber($scope.text, $scope.url);
        servCall.then(function (response) {
            var resultado = {};
            resultado.estado = response.data.estado
            switch (response.data.estado) {
                case 0:
                    var mensaje = { msn: 'Error: ' + response.data.respuesta, tipo: "alert alert-danger" };
                    UtilsService.abrirRespuesta(mensaje);
                    $scope.uploadingText = false;
                    cargarHome();
                    break;
                default:
                    var mensaje = { msn: "Se Actualizó correctamente el Texto", tipo: "alert alert-success" };
                    UtilsService.abrirRespuesta(mensaje);
                    $scope.uploadingText = false;
                    cargarHome();
                    break;
            }
        }, function (error) {
            
            var mensaje = { msn: 'Error: ' + error, tipo: "alert alert-danger" };
            UtilsService.abrirRespuesta(mensaje);
            $scope.uploadingText = false;
            cargarHome();
        });

        cargarHome();
    }

    $scope.agregarMint = function (file, key, value, group) {
        
        $scope.uploadingMint = true;
        $scope.uploadMint(file, key, value, group);
    }

    $scope.uploadMint = function (file, key, value, group) {
        $scope.imageMint = {};
        $scope.imageMint.key = key;
        $scope.imageMint.value = value;
        $scope.imageMint.group = group;

        $scope.imageMint.AudUserName = authService.authentication.userName;
        $scope.imageMint.AddIdent = authService.authentication.isAddIdent;
        $scope.imageMint.UserNameAddIdent = authService.authentication.userNameAddIdent;

        Upload.upload({
            url: $scope.serviceBase + '/api/Sistema/ConfiguracionSistema/ModificarMint',
            method: "POST",
            data: $scope.imageMint,
            file: file,
        }).then(function (resp) {
            var mensaje = { msn: "Se cargó Correctamente la Imagen", tipo: "alert alert-success" };
            UtilsService.abrirRespuesta(mensaje);
            $scope.uploadingMint = false;
            cargarHome();
        }, function (resp) {
            var mensaje = { msn: 'Error: ' + resp.status, tipo: "alert alert-danger" };
            UtilsService.abrirRespuesta(mensaje);
            $scope.uploadingMint = false;
            cargarHome();
        }, function (evt) {
            var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
            $scope.progressPercentage = 'progreso: ' + progressPercentage + '% ' + evt.config.data.file.name;
        });
    };
    
    $scope.agregarApp = function (file, key, value, group) {

        $scope.uploadingApp = true;
        $scope.uploadApp(file, key, value, group);
    }

    $scope.uploadApp = function (file, key, value, group) {
        $scope.imageMint = {};
        $scope.imageMint.key = key;
        $scope.imageMint.value = value;
        $scope.imageMint.group = group;

        $scope.imageMint.AudUserName = authService.authentication.userName;
        $scope.imageMint.AddIdent = authService.authentication.isAddIdent;
        $scope.imageMint.UserNameAddIdent = authService.authentication.userNameAddIdent;

        Upload.upload({
            url: $scope.serviceBase + '/api/Sistema/ConfiguracionSistema/ModificarApp',
            method: "POST",
            data: $scope.imageMint,
            file: file,
        }).then(function (resp) {
            var mensaje = { msn: "Se cargó Correctamente la Imagen", tipo: "alert alert-success" };
            UtilsService.abrirRespuesta(mensaje);
            $scope.uploadingApp = false;
            cargarHome();
        }, function (resp) {
            var mensaje = { msn: 'Error: ' + resp.status, tipo: "alert alert-danger" };
            UtilsService.abrirRespuesta(mensaje);
            $scope.uploadingApp = false;
            cargarHome();
        }, function (evt) {
            var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
            $scope.progressPercentage = 'progreso: ' + progressPercentage + '% ' + evt.config.data.file.name;
        });
    };

    $scope.agregarGob = function (file, key, value, group) {

        $scope.uploadingGob = true;
        $scope.uploadGob(file, key, value, group);
    }

    $scope.uploadGob = function (file, key, value, group) {
        $scope.imageMint = {};
        $scope.imageMint.key = key;
        $scope.imageMint.value = value;
        $scope.imageMint.group = group;

        $scope.imageMint.AudUserName = authService.authentication.userName;
        $scope.imageMint.AddIdent = authService.authentication.isAddIdent;
        $scope.imageMint.UserNameAddIdent = authService.authentication.userNameAddIdent;

        Upload.upload({
            url: $scope.serviceBase + '/api/Sistema/ConfiguracionSistema/ModificarGob',
            method: "POST",
            data: $scope.imageMint,
            file: file,
        }).then(function (resp) {
            var mensaje = { msn: "Se cargó Correctamente la Imagen", tipo: "alert alert-success" };
            UtilsService.abrirRespuesta(mensaje);
            $scope.uploadingGob = false;
            cargarHome();
        }, function (resp) {
            var mensaje = { msn: 'Error: ' + resp.status, tipo: "alert alert-danger" };
            UtilsService.abrirRespuesta(mensaje);
            $scope.uploadingGob = false;
            cargarHome();
        }, function (evt) {
            var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
            $scope.progressPercentage = 'progreso: ' + progressPercentage + '% ' + evt.config.data.file.name;
        });
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //**********Acciones******************************

    $scope.abrirModalModificarRS = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/ModificarRS.html',
            controller: 'ModalModificarRSController',
            resolve: {
                rs: function () {
                    if ($scope.datosHome.listRS[index]) {
                        return angular.copy($scope.datosHome.listRS[index]);
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
                cargarHome();
            }
        );
    };

    $scope.abrirModalModificarSL = function (index) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/ModificarSL.html',
            controller: 'ModalModificarSLController',
            resolve: {
                sl: function () {
                    if ($scope.datosHome.listSlider[index]) {
                        return angular.copy($scope.datosHome.listSlider[index]);
                    } else {
                        return null;
                    }
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
                cargarHome();
            }
        );
    };

    //**********Fin Acciones******************************

}]);

app.controller('ModalModificarRSController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', 'Upload', 'UtilsService', 'ngSettings', 'rs', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, Upload, UtilsService, ngSettings, rs, authService) {
    $scope.rs = rs || {};
    $scope.serviceBase = ngSettings.apiServiceBaseUri;

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.agregar = function () {
        if (!$scope.validar()) return false;
        $scope.upload($scope.file);
    }

    $scope.upload = function (file) {
        $scope.rs.contentUrl = $scope.contenturl;
        $scope.rs.imgID = file.name;

        $scope.rs.AudUserName = authService.authentication.userName;
        $scope.rs.AddIdent = authService.authentication.isAddIdent;
        $scope.rs.UserNameAddIdent = authService.authentication.userNameAddIdent;

        Upload.upload({
            url: $scope.serviceBase + '/api/Sistema/ConfiguracionSistema/ModificarRS',
            method: "POST",
            data: $scope.rs,
            file: file,
        }).then(function (resp) {
            var mensaje = { msn: "Se ha actualizado satisfactoriamente la Red Social", tipo: "alert alert-success" };
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
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);


app.controller('ModalModificarSLController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', 'Upload', 'UtilsService', 'ngSettings', 'sl', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, Upload, UtilsService, ngSettings, sl, authService) {
    $scope.sl = sl || {};
    $scope.showVid = false;
    $scope.showImg = false;
    $scope.serviceBase = ngSettings.apiServiceBaseUri;

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.doSlider = function (t) {
        if(t == 'V')
        {
            $scope.showVid = true;
            $scope.showImg = false;
        } else 
        {
            $scope.showVid = false;
            $scope.showImg = true;
        }
    }

    $scope.agregarImg = function () {
        if (!$scope.validar()) return false;
        $scope.upload($scope.fileImgSL);
    }

    $scope.agregarVid = function () {
        if (!$scope.validar()) return false;
        $scope.upload($scope.fileVidSL);
    }

    $scope.upload = function (file) {
        $scope.sl.type = $scope.type;
        $scope.sl.content = file.name;

        $scope.sl.AudUserName = authService.authentication.userName;
        $scope.sl.AddIdent = authService.authentication.isAddIdent;
        $scope.sl.UserNameAddIdent = authService.authentication.userNameAddIdent;

        Upload.upload({
            url: $scope.serviceBase + '/api/Sistema/ConfiguracionSistema/ModificarSL',
            method: "POST",
            data: $scope.sl,
            file: file,
        }).then(function (resp) {
            var mensaje = { msn: "Se ha actualizado satisfactoriamente el Slide", tipo: "alert alert-success" };
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
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };
}]);
