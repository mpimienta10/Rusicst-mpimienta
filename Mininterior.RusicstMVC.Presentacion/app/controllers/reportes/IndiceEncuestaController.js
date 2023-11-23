app.controller('IndiceEncuestaController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', '$location', '$log', '$uibModal', 'authService', 'enviarDatos', '$stateParams', '$state', function ($scope, APIService, UtilsService, i18nService, $http, $location, $log, $uibModal, authService, enviarDatos, $stateParams, $state) {
    $scope.registro = {};
   if (enviarDatos.datos)
       var registro = enviarDatos.datos;

   if ($stateParams.IdUsuario != 'null') {
       $scope.IdUsuario = $stateParams.IdUsuario;
   } else {
       UtilsService.getDatosUsuarioAutenticado().respuesta().then(function (respuesta) {
           $scope.IdUsuario = respuesta.Id;
       });
   }

   $scope.cargoDatos = true;

    //-----------------------OBTENER SECCIONES Y SUBSECCIONES----------------------------------
    getDatos();
    function getDatos() {
        var url = '/api/Reportes/IndiceEncuestas/ConsultarSecciones_Pintar';
        $scope.registro.IdEncuesta = $stateParams.IdEncuesta; 
        $scope.registro.Titulo = $stateParams.Titulo;
        $scope.registro.Id = $stateParams.IdUsuario;
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (respuesta) {
            if (respuesta.status === 200) {
                $scope.datos = respuesta.data;
                angular.forEach($scope.datos, function (valor) {
                    var regex = new RegExp("^[0-9]+(.*)$");
                    var res = regex.exec(valor.Titulo);
                    if (res != null) {
                        valor.Titulo = res[1];
                    }
                    valor.expandido = false;
                    angular.forEach(valor.LSubSecciones, function (subseccion) {
                        if (subseccion.IdPagina === 0) {
                            var res = regex.exec(subseccion.Titulo);
                            if (res != null) {
                                subseccion.Titulo = res[1];
                            }
                        }
                        
                    })
                  });
                 //$scope.datos[0].expandido = true;
            };
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    };

    $scope.irAutoevaluacion = function () {

        $scope.cargoDatos = false;

        var url = '/api/Sistema/PlanesMejoramiento/Diligenciamiento/ValidarPreguntasObligatorias?idEncuesta=' + $scope.registro.IdEncuesta + '&idUsuario=' + $scope.IdUsuario;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {

            $scope.cargoDatos = true;

            if(response.length > 0)
            {
                $scope.listaPreguntas = response;
            } else 
            {
                if ($scope.registro.IdEncuesta > 55)
                {
                    var url2 = '/api/Sistema/PlanesMejoramiento/Diligenciamiento/ObtenerPlanEncuesta?idEncuesta=' + $scope.registro.IdEncuesta;
                    var servCall = APIService.getSubs(url2);
                    servCall.then(function (response) {

                        var url3 = '/api/Sistema/PlanesMejoramiento/Diligenciamiento/ObtenerTipoPlanEncuesta?idEncuesta=' + $scope.registro.IdEncuesta;

                        $scope.idPlan = response;

                        var servCall = APIService.getSubs(url3);
                        servCall.then(function (response3) {

                            if (response3 == 2)
                            {
                                //plan mejoramiento v2
                                $location.url('/Index/Reportes/PlanMejoramiento/DiligenciarPlan/' + $scope.idPlan + '/' + $scope.IdUsuario);
                            } else {

                                var url4 = '/api/Sistema/PlanesMejoramientoV3/Seguimiento/TipoPlanEIds?idEncuesta=' + $scope.registro.IdEncuesta + '&idUsuario=' + $scope.IdUsuario;
                                var servCall4 = APIService.getSubs(url4);
                                servCall4.then(function (response4) {

                                    $scope.idPlan = response4.IdPlan;

                                    //Diligenciamiento (planeacion) plan de mejoramiento
                                    if (response4.TipoPlan == "P") {    
                                        $location.url('/Index/Reportes/PlanMejoramiento/DiligenciarPlanV3/' + $scope.idPlan + '/' + $scope.IdUsuario);
                                    } else if (response4.TipoPlan == "SP") {
                                        ///Seguimiento Plan de mejoramiento
                                        $location.url('/Index/Reportes/PlanMejoramiento/SeguimientoPlanV3/' + $scope.idPlan + '/' + response4.IdSeguimiento + '/' + $scope.IdUsuario);
                                    } else if (response4.TipoPlan == "ND") {
                                        $scope.error = "La encuesta no tiene asociado un Plan de Mejoramiento o el Seguimiento de un Plan de Mejoramiento. Por favor indíquele al Administrador";
                                    }

                                }, function (error) {
                                });

                                //plan mejoramiento v3
                                    
                            }

                        }, function (error) {
                        });

                    }, function (error) {
                    });
                } else 
                {
                    //aca va la autoevaluacion vieja
                    $location.url('/Index/Reportes/Autoevaluacion/' + $scope.registro.IdEncuesta + '/' + $scope.IdUsuario);
                }                
            }

        }, function (error) {
        });

    };

    //-----------------------LINKS A SECCIONES Y SUBSECCIONES----------------------------------
    $scope.AbrirSubseccion = function (item) {
       var idEncuesta = $scope.registro.IdEncuesta;
       var titulo = $scope.registro.Titulo;
       var SuperSeccion;
       var cancelar = false;
       if (item.SuperSeccion == null) {
           if (item.Ayuda === "Si tiene archivo") {
               SuperSeccion = item.Id;
               $scope.IdPagina = item.Id;
           } else {
               cancelar = true;
           }
       } else {
           SuperSeccion = item.Id;
           //Encontrar número de primera página
           for (var i = 0; i < $scope.datos.length; i++) {
               for (var j = 0; j < $scope.datos[i].LSubSecciones.length; j++) {
                   if ($scope.datos[i].LSubSecciones[j].SuperSeccion === SuperSeccion) {
                       $scope.IdPagina = $scope.datos[i].LSubSecciones[j].Id;
                       break;
                   }
               }
           }
       }

       if ($scope.IdPagina == undefined && !cancelar)
       {
           SuperSeccion = item.SuperSeccion;
           $scope.IdPagina = item.Id;
       }
      
       if (!cancelar) $location.url('/Index/Reportes/Encuesta/' + idEncuesta + '/' + SuperSeccion + '/' + $scope.IdPagina + '/' + titulo + '/' + $scope.registro.Id );
       };

}]);