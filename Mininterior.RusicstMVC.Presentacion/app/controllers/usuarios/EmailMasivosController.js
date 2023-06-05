app.controller('EmailMasivosController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$templateCache', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $templateCache, authService) {

    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.isColumnDefs = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.gridOptions = {
        columnDefs: [],
        exporterFieldCallback: function (grid, row, col, value) {
            if (col.colDef.displayName === 'Fecha') value = new Date(value).toLocaleDateString();
            return value;
        },
        onRegisterApi: function (gridApi) {
            $scope.gridApi1 = gridApi;
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
        },
    };
    $scope.isColumnDefs = false;

    //*** autoajustar
    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize); }
    });

    // Set Bootstrap DatePickerPopup config
    $scope.datePicker = {
        options: {
            formatMonth: 'MM',
            startingDay: 1
        },
        format: "dd/MM/yyyy"
    };

    // Set two filters, one for the 'Greater than' filter and other for the 'Less than' filter
    $scope.showDatePopup = [];
    $scope.showDatePopup.push({ opened: false });
    $scope.showDatePopup.push({ opened: false });

    var columnActions = [
        {
            name: 'Texto',
            cellTemplate: '<div class="text-center"><a href="" ng-click="grid.appScope.PopUpMostrarCampana(row.entity)">Mostrar</a></div>',
            enableFiltering: false,
            pinnedRigth: true,
            minWidth: 100,
            enableColumnMenu: false,
            exporterSuppressExport: true,
        }];

    var columnsNoVisibles = ["Id", "Mensaje"];

    $scope.gridOptions.exporterSuppressColumns = columnsNoVisibles;

    var actionJson = {
        action: "CambiarDefinicion",
        definition: "displayName",
        parameters: [
            { field: "TipoUsuario", newProperty: "Tipo Destinatario" },
        ]
    };

    var widthChange = {
        action: "CambiarDefinicion",
        definition: "width",
        parameters: [
            { field: "Asunto", newProperty: 300 },
        ]
    };

    var formatDate = {
        action: "CambiarFecha",
        parameters: [
            { field: "Fecha" },
        ]
    };

    $scope.limpiarAgrupacion = function () {
        $scope.gridApi1.grouping.clearGrouping();
    };

    var url = '/api/Usuarios/EmailMasivo?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
    getDatos();
    function getDatos() {
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.isGrid = true;
            $scope.cargoDatos = true;
            $scope.gridOptions.data = datos;
            UtilsService.getColumnDefs($scope.gridOptions, $scope.isColumnDefs, columnActions, columnsNoVisibles);
            UtilsService.utilsGridOptions($scope.gridOptions, actionJson);
            UtilsService.utilsGridOptions($scope.gridOptions, widthChange);
            UtilsService.utilsGridOptions($scope.gridOptions, formatDate);
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    //------------------------------Lógica de las acciones---------------------------------------------
    $scope.PopUpNuevaCampana = function () {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/NuevaCampana.html',
            controller: 'ModalNuevaCampanaController',
            size: 'lg',
            backdrop: 'static', keyboard: false,
            resolve: {}
        });
        modalInstance.result.then(
             function (result) {
                 $scope.isColumnDefs = true;
                 getDatos();
                 openRespuesta("Correo(s) enviados satisfactoriamente");
             }
           );
    };

    $scope.PopUpMostrarCampana = function (entity) {

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/MostrarCampana.html',
            controller: 'ModalMostrarCampanaController',
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
             function (result) {

             }
           );
    };

    //-------CONFIRMAR RESPUESTA---------------
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
        modalInstance.result.then(
             function () {

             });
    };
    //-------FIN-----------------------------
}]);

app.controller('ModalNuevaCampanaController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'UtilsService', 'Upload', 'ngSettings', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, UtilsService, Upload, ngSettings, authService) {
    $scope.registro = {};
    $scope.autenticacion = authService.authentication;
    $scope.registro.Usuario = $scope.autenticacion.userName;
    $scope.errorMessages = UtilsService.getErrorMessages();

    var urlGetRoles = '/api/General/Listas/TipoUsuarios?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
    getRoles();
    function getRoles() {
        var servCall = APIService.getSubs(urlGetRoles);
        servCall.then(function (datos) {
            $scope.tipoUsuarios = datos;
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    };

    //-----UPLOAD FILE---------------------------------------------
    // upload on file select or drop
    $scope.upload = function (file, url) {

        if (null != file) {
            var filename = file.name;
            var index = filename.lastIndexOf(".");
            var strsubstring = filename.substring(index, filename.length);

            if (strsubstring != '.pdf' && strsubstring != '.doc' && strsubstring != '.docx' && strsubstring != '.xlsx' && strsubstring != '.xls' && strsubstring != '.png' && strsubstring != '.jpeg' && strsubstring != '.png' && strsubstring != '.gif' && strsubstring != '.txt') {
                $scope.cargando = false;
                $scope.extension = true;
                return;
            }
        }

        var serviceBase = ngSettings.apiServiceBaseUri;

        $scope.registro.AudUserName = authService.authentication.userName;
        $scope.registro.AddIdent = authService.authentication.isAddIdent;
        $scope.registro.UserNameAddIdent = authService.authentication.userNameAddIdent;

        Upload.upload({
            url: serviceBase + url,
            method: "POST",
            data: $scope.registro,
            file: file,
        }).then(function (Resultado) {

            $scope.cargando = false;
            switch (Resultado.data.estado) {
                case 0:
                    $scope.error = Resultado.data.respuesta;
                    break
                case 1:
                    $scope.enviado = true;
                    $scope.tipo === 'prueba' ? "" : $uibModalInstance.close();
                    break;
            }
        }, function (Resultado) {
            $scope.enviando = false;
            var mensaje = { msn: 'Error: ' + resultado.data.exceptionMessage, tipo: "alert alert-danger" };
            alert(mensaje);
        }, function (evt) {

            if (null != evt.config.data.file) {
                var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
                console.log('progress: ' + progressPercentage + '% ' + evt.config.data.file.name);
            }
        });

    };

    //---ACCIONES: GUARDAR Y CANCELAR---------------
    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    $scope.enviar = function (tipo) {

        if (!$scope.validar()) {
            $scope.mensajeDiligenciado = $scope.registro.Mensaje.length > 1;
            return false;
        }
        var url;
        $scope.tipo = tipo;
        $scope.tipo === "prueba" ? url = '/api/Usuarios/EmailMasivo/EnviarCorreoPrueba' : url = '/api/Usuarios/EmailMasivo/Insertar';
        $scope.cargando = true;
        $scope.mensajeDiligenciado = true;
        $scope.registro.Mensaje = limpiarMensaje($scope.registro.Mensaje);
        $scope.upload($scope.file, url);
    };

    $scope.validar = function () {
        return $scope.myForm.$valid && $scope.registro.Mensaje.length > 1;
    };

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
    //--------------REEMPLAZAR LAS COMILLAS DOBLES POR SIMPLE--------------------
    var limpiarMensaje = function (mensaje) {
        var mensaje = mensaje.replace(/"/g, "'");
        return mensaje;
    }
    //-----------------FIN-------------------------------------------------------

    //---------------------TinyMCE---------------------------------
    $scope.registro.Mensaje = '';

    $scope.tinymceOptions = {
        language: 'es',
        theme: 'modern',
        plugins: [
            'advlist autolink lists link image charmap print preview hr anchor pagebreak',
            'searchreplace wordcount visualblocks visualchars code fullscreen',
            'insertdatetime media nonbreaking save table contextmenu directionality',
            'emoticons template paste textcolor colorpicker textpattern imagetools codesample toc'
        ],
        toolbar1: 'undo redo | insert | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image',
        toolbar2: 'print preview media | forecolor backcolor emoticons | codesample',
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
    //---------------------------FIN TINYMCE------------------------------------------
}]);

app.controller('ModalMostrarCampanaController', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService) {
    $scope.registro = entity || {};
    if (!$scope.registro.Mensaje) $scope.registro.Mensaje = '<div class"text-center">Mensaje Vacío</div>'

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };
});

