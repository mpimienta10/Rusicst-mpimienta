app.controller('EvaluacionController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, authService) {
    $scope.autenticacion = authService.authentication;
    $scope.userName = $scope.autenticacion.userName;
    $scope.filtro = {};
    $scope.totales = { CompromisoAlcaldiaPrimer: 0, PresupuestoAlcaldiaPrimer: 0, CompromisoGobernacionPrimer: 0, PresupuestoGobernacionPrimer: 0, CompromisoAlcaldiaSegundo: 0, PresupuestoAlcaldiaSegundo: 0, CompromisoGobernacionSegundo: 0, PresupuestoGobernacionSegundo: 0 };
    $scope.GobernacionAlcaldias = [];
    $scope.alcaldias = [];
    $scope.cargoDatos = true;
    $scope.init = function () {
        var url = "/api/TableroPat/CargarEvaluacion/" + $scope.userName;
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.Derechos = datos.derechos;
                $scope.Tableros = datos.tableros;
                $scope.datosUsuario = datos.datosUsuario[0];
                angular.forEach($scope.Tableros, function (t) {                           
                    t.Etiqueta = "Planeación " + t.Año;
                });
                cargarComboDepartamentos_Municipios();
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.submitted = false;
    };
    $scope.init();
    $scope.cargarComboMunicipios = function () {
        cargarMunicipios();
    }
    function cargarMunicipios() {
        $scope.alcaldias = [];
        $scope.alcaldias.push({ IdMunicipio: 0, Municipio: 'Todos' });
        if (!$scope.filtro.departamento == 0) {
            angular.forEach($scope.GobernacionAlcaldias, function (alcaldia) {
                if (alcaldia.IdDepartamento == $scope.filtro.departamento)
                    $scope.alcaldias.push(alcaldia);
            });
        }
    }
    function cargarComboDepartamentos_Municipios() {
        switch ($scope.datosUsuario.TipoTipoUsuario) {
            case 'GOBERNACION':
                var url = '/api/General/Listas/DepartamentosMunicipios?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
                var servCall = APIService.getSubs(url);
                servCall.then(function (response) {
                    $scope.GobernacionAlcaldias = response;
                    var flags = [], output = [], l = response.length, i;
                    output.push({ IdDepartamento: 0, Departamento: 'Todos' });
                    for (i = 0; i < l; i++) {
                        if (flags[response[i].IdDepartamento]) continue;
                        flags[response[i].IdDepartamento] = true;
                        output.push(response[i]);
                    }
                    $scope.gobernaciones = output;
                }, function (error) {
                    $scope.error = "Se generó un error en la petición";
                });
                $timeout(function () {
                    $scope.filtro.departamento = $scope.datosUsuario.IdDepartamento;
                    cargarMunicipios();
                }, 1000);
                break;
            case 'ALCALDIA':
                $scope.filtro.municipio = $scope.datosUsuario.IdMunicipio;
                $scope.filtro.departamento = $scope.datosUsuario.IdDepartamento;
                break;
            default:
                var url = '/api/General/Listas/DepartamentosMunicipios?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
                var servCall = APIService.getSubs(url);
                servCall.then(function (response) {
                    $scope.GobernacionAlcaldias = response;
                    var flags = [], output = [], l = response.length, i;
                    output.push({ IdDepartamento: 0, Departamento: 'Todos' });
                    for (i = 0; i < l; i++) {
                        if (flags[response[i].IdDepartamento]) continue;
                        flags[response[i].IdDepartamento] = true;
                        output.push(response[i]);
                    }
                    $scope.gobernaciones = output;
                }, function (error) {
                    $scope.error = "Se generó un error en la petición";
                });
        }
    }
    $scope.filtrar = function () {
        $scope.totales = { CompromisoAlcaldiaPrimer: 0, PresupuestoAlcaldiaPrimer: 0, CompromisoGobernacionPrimer: 0, PresupuestoGobernacionPrimer: 0, CompromisoAlcaldiaSegundo: 0, PresupuestoAlcaldiaSegundo: 0, CompromisoGobernacionSegundo: 0, PresupuestoGobernacionSegundo: 0, CompromisoGobernacionPrimer: 0, PresupuestoGobernacionPrimer: 0, CompromisoGobernacionSegundo: 0, PresupuestoGobernacionSegundo: 0 };
        $scope.errorDepartamento = false;
        $scope.errorMunicipio = false;
        if (!$scope.filtro.departamento) {
            $scope.errorDepartamento = true;
        }
        if (!$scope.filtro.municipio) {
            $scope.errorMunicipio = true;
            return false;
        }
        if ($scope.errorDepartamento || $scope.errorMunicipio) {
            return false;
        }
        if (!$scope.validar()) return false;
        var url = "/api/TableroPat/Evaluacion/" + $scope.filtro.IdTablero + ',' + $scope.filtro.departamento + ',' + $scope.filtro.municipio + ',' + $scope.filtro.IdDerecho;
        $scope.cargoDatos = false;
        getDatos();
        function getDatos() {
            $scope.datos = [];
            $scope.alerta = null;
            $scope.error = null;
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.datos = datos;
                if ($scope.datos.length > 0) {
                    angular.forEach($scope.datos, function (item) {
                        $scope.totales.CompromisoAlcaldiaPrimer = item.AvancePrimerSemestreAlcaldias + $scope.totales.CompromisoAlcaldiaPrimer;
                        $scope.totales.PresupuestoAlcaldiaPrimer = item.AvancePresupuestoPrimerSemestreAlcaldias + $scope.totales.PresupuestoAlcaldiaPrimer;
                        $scope.totales.CompromisoGobernacionPrimer = item.AvancePrimerSemestreGobernaciones + $scope.totales.CompromisoGobernacionPrimer;
                        $scope.totales.PresupuestoGobernacionPrimer = item.AvancePresupuestoPrimerSemestreGobernaciones + $scope.totales.PresupuestoGobernacionPrimer;

                        $scope.totales.CompromisoAlcaldiaSegundo = item.AvanceAcumuladoAlcaldias + $scope.totales.CompromisoAlcaldiaSegundo;
                        $scope.totales.PresupuestoAlcaldiaSegundo = item.AvancePresupuestoAcumuladoAlcaldias + $scope.totales.PresupuestoAlcaldiaSegundo;
                        $scope.totales.CompromisoGobernacionSegundo = item.AvanceAcumuladoGobernaciones + $scope.totales.CompromisoGobernacionSegundo;
                        $scope.totales.PresupuestoGobernacionSegundo = item.AvancePresupuestoGobernaciones + $scope.totales.PresupuestoGobernacionSegundo;
                    });

                    $scope.totales.CompromisoAlcaldiaPrimer = $scope.totales.CompromisoAlcaldiaPrimer / $scope.datos.length;
                    $scope.totales.PresupuestoAlcaldiaPrimer = $scope.totales.PresupuestoAlcaldiaPrimer / $scope.datos.length;
                    $scope.totales.CompromisoGobernacionPrimer = $scope.totales.CompromisoGobernacionPrimer / $scope.datos.length;
                    $scope.totales.PresupuestoGobernacionPrimer = $scope.totales.PresupuestoGobernacionPrimer / $scope.datos.length;

                    $scope.totales.CompromisoAlcaldiaSegundo = $scope.totales.CompromisoAlcaldiaSegundo / $scope.datos.length;
                    $scope.totales.PresupuestoAlcaldiaSegundo =$scope.totales.PresupuestoAlcaldiaSegundo / $scope.datos.length;
                    $scope.totales.CompromisoGobernacionSegundo = $scope.totales.CompromisoGobernacionSegundo / $scope.datos.length;
                    $scope.totales.PresupuestoGobernacionSegundo = $scope.totales.PresupuestoGobernacionSegundo / $scope.datos.length;

                } else {
                    $scope.alerta = "No se encontraron datos para el filtro relacionado";
                }
                $scope.cargoDatos = true;
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
                $scope.cargoDatos = true;
            });
        }
        $scope.submitted = false;
    }
    $scope.validar = function () {
        return $scope.editForm.$valid;
    };
}])
;