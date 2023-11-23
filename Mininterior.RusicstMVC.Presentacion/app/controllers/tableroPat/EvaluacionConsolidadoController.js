app.controller('EvaluacionConsolidadoController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, authService) {
    $scope.autenticacion = authService.authentication;
    $scope.userName = $scope.autenticacion.userName;
    $scope.filtro = {};
    $scope.totales = { CompromisoGobernacionPrimer: 0, PresupuestoGobernacionPrimer: 0, CompromisoGobernacionSegundo: 0, PresupuestoGobernacionSegundo: 0 };
    $scope.cargoDatos = true;
    $scope.init = function () {
        var url = "/api/TableroPat/CargarEvaluacionConsolidado/" + $scope.userName;
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.Tableros = datos.tableros;
                $scope.datosUsuario = datos.datosUsuario[0];
                angular.forEach($scope.Tableros, function (t) {
                    t.Etiqueta = "Planeación " + t.Año;
                });
                cargarComboDepartamentos();
            }, function (error) {
                $scope.error = "Se generó un error en la petición";
            });
        }
        $scope.submitted = false;
    };
    function cargarComboDepartamentos() {

        if ($scope.datosUsuario.TipoTipoUsuario == 'GOBERNACION') {
            $scope.filtro.departamento = $scope.datosUsuario.IdDepartamento;
        } else {
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
    $scope.validar = function () {
        return $scope.editForm.$valid;
    };
    $scope.init();
    $scope.filtrar = function () {
        $scope.datos = [];
        $scope.alerta = null;
        $scope.error = null;
        if (!$scope.validar()) return false;
        if (!$scope.filtro.departamento) {
            $scope.errorDepartamento = true;
        }
        $scope.totales = { CompromisoGobernacionPrimer: 0, PresupuestoGobernacionPrimer: 0, CompromisoGobernacionAcumulado: 0, PresupuestoGobernacionAcumulado: 0 };
        var idTablero = $scope.filtro.IdTablero ? $scope.filtro.IdTablero : 0;
        var url = "/api/TableroPat/EvaluacionConsolidado/" + idTablero + ',' + $scope.filtro.departamento;
        $scope.cargoDatos = false;
        getDatos();
        function getDatos() {
            var servCall = APIService.getSubs(url);
            servCall.then(function (datos) {
                $scope.datos = datos;
                if ($scope.datos.length > 0) {
                    angular.forEach($scope.datos, function (item) {

                        $scope.totales.CompromisoGobernacionPrimer = item.AvancePrimerSemestreGobernaciones + $scope.totales.CompromisoGobernacionPrimer;
                        $scope.totales.PresupuestoGobernacionPrimer = item.AvancePresupuestoPrimerSemestreGobernaciones + $scope.totales.PresupuestoGobernacionPrimer;
                        $scope.totales.CompromisoGobernacionAcumulado = item.AvanceAcumuladoGobernaciones + $scope.totales.CompromisoGobernacionAcumulado;
                        $scope.totales.PresupuestoGobernacionAcumulado = item.AvancePresupuestoAcumuladoGobernaciones + $scope.totales.PresupuestoGobernacionAcumulado;
                    });
                    $scope.totales.CompromisoGobernacionPrimer = $scope.totales.CompromisoGobernacionPrimer / $scope.datos.length;
                    $scope.totales.PresupuestoGobernacionPrimer = $scope.totales.PresupuestoGobernacionPrimer / $scope.datos.length;
                    $scope.totales.CompromisoGobernacionAcumulado = $scope.totales.CompromisoGobernacionAcumulado / $scope.datos.length;
                    $scope.totales.PresupuestoGobernacionAcumulado = $scope.totales.PresupuestoGobernacionAcumulado / $scope.datos.length;
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
}])
;