app.controller('AdministracionServiciosWebController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout) {
    $scope.cargoDatos = true;
    $scope.tablero = {};
    $scope.tablero.VigenciaInicio = new Date($scope.tablero.VigenciaInicio);
    $scope.tablero.VigenciaFin = new Date($scope.tablero.VigenciaFin);
    //DataPicker
    $scope.popup1 = {
        opened: false
    };
    $scope.open1 = function () {
        $scope.popup1.opened = true;
    };
    $scope.popup2 = {
        opened: false
    };
    $scope.open2 = function () {
        $scope.popup2.opened = true;
    };
    $scope.dateOptions = {
        formatYear: 'yyyy',
        startingDay: 1
    };
    $scope.dateOptions2 = {
        formatYear: 'yyyy',
        startingDay: 1
    };
    $scope.checkErr = function (fechainicio, fechafin) {
        $scope.error = null;
        var curDate = new Date();
        if (new Date(fechainicio) > new Date(fechafin)) {
            $scope.error = 'La fecha de finalización debe ser mayor o igual a la de inicio';
            $scope.registerForm.$valid = false;
            return false;
        }
    };
    $scope.$watch('popup1.opened', function (newVal, oldVal) {
        if (newVal != oldVal && !newVal) {
            //close event

            //si las fecha de inicio es mayor que la fecha final, la cambiamos
            if ($scope.tablero.VigenciaInicio) {
                $scope.tablero.VigenciaFin = $scope.tablero.VigenciaFin;
                $scope.dateOptions2.minDate = $scope.tablero.VigenciaInicio;
            }
        }
    });
    $scope.format = "dd/MM/yyyy";

    $scope.idmetodo = 0;
    $scope.metodos = [
        { Id: 1, nombre: "Obtener Entidades Nacionales" },
        { Id: 2, nombre: "Obtener Compromisos Entidades Nacionales" },
        { Id: 3, nombre: "Obtener Seguimiento Entidades Nacionales" },
        { Id: 4, nombre: "Obtener Compromisos Entidades Nacionales Retornos y Reubicaciones" },
        { Id: 5, nombre: "Obtener Seguimiento Entidades Nacionales Reparacion Colectiva" },
        { Id: 6, nombre: "Obtener Seguimiento Entidades Nacionales Retornos y Reubicaciones" }
    ];
    $scope.metodosSIGO = [
       { Id: 1, nombre: "Obtener Precargue Necesidades" },
       { Id: 2, nombre: "Obtener Precargue Accesos Efectivos de Necesidades" },
       { Id: 3, nombre: "Obtener Seguimiento Programas" }
    ];

    $scope.seguimientos = [
        { Id: 1, nombre: "Primer semestre" },
        { Id: 2, nombre: "Segundo semestre" }
    ];

    $scope.anos = [
        { Id: 2018, nombre: 2018 },
        { Id: 2019, nombre: 2019 },
        { Id: 2020, nombre: 2020 },
        { Id: 2021, nombre: 2021 }
    ];
    
    $scope.init = function () {
        var url = "/api/TableroPat/TodosTableros/";
        var servCall = APIService.getSubs(url);
        servCall.then(function (datos) {
            $scope.Tableros = datos;
            angular.forEach($scope.Tableros, function (t) {
                t.VigenciaInicio = new Date(t.VigenciaInicio).toLocaleDateString();
                t.VigenciaFin = new Date(t.VigenciaFin).toLocaleDateString();
                t.Etiqueta = t.Año;
            });
        }, function (error) {
            $scope.errorgeneral = "Se generó un error en la petición";
        });

        $scope.submitted = false;
    };
    $scope.init();

    $scope.wsEntidadesNacionales = function () {
        var url = '';
        $scope.error = "";
        $scope.alerta = "";
        if ($scope.idmetodo > 0) {
            switch ($scope.idmetodo) {
                case 1:
                    url = '/api/TableroPat/IngresoEntidadesNacionales/';
                    break;
                case 2:
                    if ($scope.IdTablero) {
                        url = '/api/TableroPat/IngresoCompromisosEntidades?idTablero=' + $scope.IdTablero;
                    }
                    break;
                case 3:
                    if ($scope.IdTablero && $scope.numSeguimiento) {
                        url = '/api/TableroPat/IngresoSeguimientoEntidades?idTablero=' + $scope.IdTablero + '&semestre=' + $scope.numSeguimiento;
                    }
                    break;
                case 4://No funciona en produccion Esigna
                    if ($scope.IdTablero) {
                        url = '/api/TableroPat/IngresoCompromisosRREntidades?idTablero=' + $scope.IdTablero;
                    }
                    break;
                case 5://No funciona en produccion Esigna
                    if ($scope.IdTablero && $scope.numSeguimiento) {
                        url = '/api/TableroPat/IngresoSeguimientoRCEntidades?idTablero=' + $scope.IdTablero + '&semestre=' + $scope.numSeguimiento;
                    }
                    break;
                case 6://No funciona en produccion Esigna
                    if ($scope.IdTablero && $scope.numSeguimiento) {
                        url = '/api/TableroPat/IngresoSeguimientoRREntidades?idTablero=' + $scope.IdTablero + '&semestre=' + $scope.numSeguimiento;
                    }
                    break;
            }
        } else {
            $scope.error = "Debe seleccionar un método";
            return;
        }
        if (url != '') {
            $scope.cargoDatos = false;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                if (datos.estado > 0) {
                    $scope.alerta = 'Termino el proceso exitosamente.'
                } else {
                    $scope.error = "Se generó un error en la petición." + datos.respuesta;
                }
                $scope.cargoDatos = true;
            }, function (error) {
                $scope.cargoDatos = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
    };
    $scope.validar = function () {
        return $scope.registerForm.$valid;
    };


    $scope.wsSGO = function () {
        $scope.datos = {};
        var url = '';
        $scope.error = null;
        $scope.alerta = null;
        if ($scope.idmetodoSIGO > 0) {
            if ($scope.ano) {
                var idTablero = 1;
                switch ($scope.ano) {
                    case 2018:
                        idTablero = 2;
                        break;
                    case 2019:
                        idTablero = 3;
                        break;
                    case 2020:
                        idTablero = 4;
                        break;
                    case 2021:
                        idTablero = 5;
                        break;
                }
                $scope.datos.ano = $scope.ano;
                $scope.datos.semestre = $scope.numSeguimiento;
                $scope.datos.idTablero = idTablero;

                switch ($scope.idmetodoSIGO) {
                    case 1:
                        $scope.datos.fechaIni = $scope.tablero.VigenciaInicio;
                        $scope.datos.fechaFin = $scope.tablero.VigenciaFin;
                        url = '/api/TableroPat/ObtenerPrecargueNecesidades';
                        break;
                    case 2:                        
                        url = '/api/TableroPat/ObtenerPrecargueAccesosEfectivoNecesidades';
                        break;
                    case 3:
                        url = '/api/TableroPat/ObtenerSeguimientoProgramas';
                        break;
                }
            } else {
                $scope.error = "Debe seleccionar los filtros requeridos para el método";
                return;
            }
        } else {
            $scope.error = "Debe seleccionar un método";
            return;
        }
        if (url != '') {
            $scope.cargoDatos = false;
            var servCall = APIService.saveSubscriber($scope.datos, url);
            servCall.then(function (datos) {
                if (datos.data.estado > 0) {
                    $scope.alerta = 'Termino el proceso exitosamente.'
                } else {
                    $scope.error = "Se generó un error en la petición." + datos.respuesta;
                }
                $scope.cargoDatos = true;
            }, function (error) {
                $scope.cargoDatos = true;
                $scope.error = "Se generó un error en la petición";
            });
        }
    };
    $scope.validar = function () {
        return $scope.registerForm.$valid;
    };
}])
;