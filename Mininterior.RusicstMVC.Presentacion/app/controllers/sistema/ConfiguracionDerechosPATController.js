app.controller('ConfiguracionDerechosPATController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', '$log', '$uibModal', '$templateCache', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, $log, $uibModal, $templateCache, authService) {
    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.derechos = [];
    $scope.cargando = false;

    getTodosDerechos();
    function getTodosDerechos() {        
        var url = '/api/sistema/configuracionderechospat/todosderechos';
        var servcall = APIService.getSubs(url);
        servcall.then(function (datos) {            
            $scope.derechos = datos;
        }, function (error) {
            $scope.cargodatos = true;
            $scope.error = "se generó un error en la petición";
        });
    }

    $scope.consultar = function () {
        if (!$scope.validar()) {
            $scope.validacion = false;
            return false;
        }
        $scope.validacion = true;
        $scope.gobernacionUrls = [];
        $scope.gobernacionArchivos = [];
        $scope.alcaldiasUrls = [];
        $scope.alcaldiasArchivos = [];
        $scope.cargando = true;
        var url = '/api/Sistema/ConfiguracionDerechosPAT/CargarParametros?Id=' + $scope.registro.Id;
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {            
            if (datos.length > 0) {
                angular.forEach(datos, function (fila) {
                    if (fila.Papel === 'gobernacion' && fila.Tipo === 'url') { $scope.gobernacionUrls.push(fila); }
                    else if (fila.Papel === 'gobernacion' && fila.Tipo === 'archivo') { $scope.gobernacionArchivos.push(fila); }
                    else if (fila.Papel === 'alcaldia' && fila.Tipo === 'url') { $scope.alcaldiasUrls.push(fila); }
                    else if (fila.Papel === 'alcaldia' && fila.Tipo === 'archivo') { $scope.alcaldiasArchivos.push(fila); }
                })
            }
            $scope.textos = {};
            var IdBuscar = parseInt($scope.registro.Id);
            angular.forEach($scope.derechos, function (fila) {
                if (IdBuscar === fila.Id) {
                    $scope.textos.TextoExplicativoGOB = fila.TextoExplicativoGOB;
                    $scope.textos.TextoExplicativoALC = fila.TextoExplicativoALC;
                    $scope.textos.DescripcionDetallada = fila.DescripcionDetallada;
                }
            })
            $scope.cargando = false;
        }, function (error) {
            $scope.error = "Se generó un error en la petición al cargar las ayudas";
        });
    };

    $scope.actualizarTexto = function () {
        var url = '/api/Sistema/ConfiguracionDerechosPAT/ModificarTexto';
        $scope.textos.IdDerecho = $scope.registro.Id;        
        var servcall = APIService.saveSubscriber($scope.textos, url);
        servcall.then(function (datos) {
            getTodosDerechos();
            var msn = { msn: "El texo explicativo fue actualizado satisfactoriamente", tipo: "alert alert-success" }
            UtilsService.abrirRespuesta(msn)
        }, function (error) {
            $scope.cargodatos = true;
            $scope.error = "se generó un error en la petición";
        });
    }

    $scope.descargar = function (item) {
        var url = $scope.serviceBase + '/api/Sistema/ConfiguracionDerechosPAT/Descargar?archivo=' + item.ParametroValor;
        window.open(url)
    }

    $scope.abrirModal = function (tipo, papel, isNuevo, id, item) {
        isNuevo === false ? id = id : id = 0;
        var entidad = { IdDerecho: $scope.registro.Id, Tipo: tipo, Papel: papel, Nuevo: isNuevo, Id: id, Item : item };
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/sistema/modals/NuevoModificarUrlArchivos.html',
            controller: 'ModalEditarUrlArchivosController',
            backdrop: 'static', keyboard: false,
            resolve: {
                entidad: function () {
                    if (entidad) {
                        return angular.copy(entidad);
                    } else {
                        return null;
                    }
                }
            }
        });
        modalInstance.result.then(
            function () {
                $scope.consultar();
            }
        );
    };

    $scope.abrirModalEliminar = function (item) {        
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionEliminar.html',
            controller: 'ModalEliminarController',
            resolve: {
                datos: function () {
                    if (item.Id) {

                        //$scope.ayudas[index].AudUserName = authService.authentication.userName;
                        //$scope.ayudas[index].AddIdent = authService.authentication.isAddIdent;
                        //$scope.ayudas[index].UserNameAddIdent = authService.authentication.userNameAddIdent;

                        var enviar = { url: '/api/Sistema/ConfiguracionDerechosPAT/Eliminar', msn: '¿Está Seguro de Eliminar el material "' + item.Texto + '"?', entity: item };
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
                $scope.consultar();
            });
    };

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //================== ABRIR GLOSARIO ==========================================================
    $scope.mostrarDescripcion = function (elemento) {
        if (elemento) {
            var termino = elemento.outerText;
            $scope.tituloTermino = termino;
            for (var i = 0; i < $scope.glosario.length; i++) {
                if ($scope.glosario[i].Termino == termino) {
                    $scope.textoTermino = $scope.glosario[i].Descripcion;
                    break;
                }
            }
        }
    }
}]);

app.controller('ModalEditarUrlArchivosController', ['$scope', 'Upload', 'APIService', 'UtilsService', '$filter', '$log', '$uibModalInstance', '$http', 'entidad', 'authService', 'ngSettings', function ($scope, Upload, APIService, UtilsService, $filter, $log, $uibModalInstance, $http, entidad, authService, ngSettings) {
    $scope.entidad = entidad || {};
    $scope.isNew = $.isEmptyObject($scope.entidad);
    $scope.errorMessages = UtilsService.getErrorMessages();
    $scope.url = '';
    $scope.isUrl = null;
    if ($scope.entidad.Nuevo) {
        $scope.url = '/api/Usuarios/TipoUsuario/Insertar';
        $scope.titulo = "Adicionar Parámetro";
        $scope.entidad.EsModificar = false;
    } else {
        $scope.url = '/api/Usuarios/TipoUsuario/Modificar';
        $scope.titulo = "Editar Parámetro";
        $scope.entidad.EsModificar = true;
       // if ($scope.entidad.Tipo === 'url') {
            $scope.entidad.ParametroValor = $scope.entidad.Item.ParametroValor;
            $scope.entidad.Texto = $scope.entidad.Item.Texto; 
            $scope.entidad.Descripcion = $scope.entidad.Item.Descripcion;
       // }
    }

    $scope.entidad.Tipo === 'url' ? $scope.isUrl = true : $scope.isUrl = false;

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.adicionar = function () {
        if (!$scope.validar()) return false;
        if ($scope.isUrl) {
            if ($scope.entidad.ParametroValor.substring(0, 4) != 'http') {
                $scope.entidad.ParametroValor = 'http://' + $scope.entidad.ParametroValor;
            }
            adicionarModificarUrl()
        } else {
                $scope.upload($scope.archivo);
        }
    }
    $scope.upload = function (archivo) {
        $scope.errorArchivo = false;
        if (!$scope.entidad.EsModificar && !archivo) {
            $scope.errorArchivo = true;
            return;
        }

        //$scope.registro.AudUserName = authService.authentication.userName;
        //$scope.registro.AddIdent = authService.authentication.isAddIdent;
        //$scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;
        if (archivo != undefined) {
            var filename = archivo.name;
            var index = filename.lastIndexOf(".");
            var strsubstring = filename.substring(index, filename.length);
            strsubstring = strsubstring.toLowerCase();
            $scope.entidad.nombre = filename;
            $scope.entidad.ParametroValor = $scope.entidad.nombre;
            $scope.entidad.NombreParametro = $scope.entidad.nombre;
            if (strsubstring == '.pdf' || strsubstring == '.doc' || strsubstring == '.docx' || strsubstring == '.xlsx' || strsubstring == '.xls' || strsubstring == '.png' || strsubstring == '.jpeg' || strsubstring == '.png' || strsubstring == '.jpg' || strsubstring == '.gif' || strsubstring == '.txt' || strsubstring == '.rar' || strsubstring == '.zip' || strsubstring == '.7z') {
                $scope.extension = true;
            }
      
        } else {
            archivo = [];
            $scope.extension = true;
        }

        if ($scope.extension) {
            Upload.upload({
                url: ngSettings.apiServiceBaseUri + '/api/Sistema/ConfiguracionDerechosPAT/Insertar',
                method: "POST",
                data: $scope.entidad,
                file: archivo,
            }).then(function (resp) {
                var mensaje = { msn: "El material ha sido registrado/actualizado satisfactoriamente", tipo: "alert alert-success" };
                $uibModalInstance.close();
                UtilsService.abrirRespuesta(mensaje);
            }, function (resp) {
                var mensaje = { msn: 'Error: ' + resp.status, tipo: "alert alert-danger" };
                UtilsService.abrirRespuesta(mensaje);
            }, function (evt) {
            });
            $scope.nombre = null;
            $scope.progressPercentage = '';
            $scope.submitted = false;
            $scope.archivo = {};
            $scope.archivo = null;
            $scope.registro = null;
            submitted = null;
        }
        else {
           
        }
    };
    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //================ ADICIONAR MODIFICAR URL ========================================================
    function adicionarModificarUrl() {
        var url = '/api/Sistema/ConfiguracionDerechosPAT/InsertarModificarUrl';        
        var servcall = APIService.saveSubscriber($scope.entidad, url);
        servcall.then(function (datos) {
            var mensaje = { msn: "El material ha sido registrado/actualizado satisfactoriamente", tipo: "alert alert-success" };
            $uibModalInstance.close();
            UtilsService.abrirRespuesta(mensaje);
        }, function (error) {
            $scope.error = "se generó un error en la petición";
        });
    }
}]);