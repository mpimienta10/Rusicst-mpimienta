app.controller('RetroConsultaController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'myTipo', 'myRetro', '$filter', 'authService', '$sce', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, myTipo, myRetro, $filter, authService, $sce) {

    $scope.prueba = "prueba";

    $scope.GobernacionAlcaldias = [];
    $scope.alcaldias = [];
    $scope.miRetroAdmin = myRetro.get();
    $scope.idRetroAdmin = $scope.miRetroAdmin.Id;
    $scope.idEncuesta = $scope.miRetroAdmin.IdEncuesta;
    $scope.Usuario = {};
    $scope.TipoUser = 'A';//'AD' Admin , 'AN' Analista
    $scope.mostrarSelMunicipio = false;
    $scope.realimentacion = { IdTipoGuardado: 0, Id: 0, IdRetroAdmin: 0 };
    $scope.SeleccionGraf = [{ Id: 2, Descripcion: 'Barras' }, { Id: 7, Descripcion: 'Barra Horizontal' }]
    $scope.SeleccionColor = [{ Id: '#803690', Descripcion: 'Morado' }, { Id: '#2471A3', Descripcion: 'Azul' }, { Id: '#DCDCDC', Descripcion: 'Gris' }, { Id: '#2ECC71', Descripcion: 'Verde' }, { Id: '#FDB45C', Descripcion: 'Amarillo' }, { Id: '#C0392B', Descripcion: 'Rojo' }, { Id: '#212F3C', Descripcion: 'Negro' }, { Id: '#E67E22', Descripcion: 'Naranja' }]


    function ObtenerUsuario() {
        var datos = { UserName: authService.authentication.userName };
        var url = '/api/Usuarios/Usuarios/BuscarXUsuario';
        var servCall = APIService.saveSubscriber(datos, url);
        servCall.then(function (datos) {
            $scope.Usuario.UserName = datos.data[0].UserName;
            $scope.Usuario.IdMunicipio = datos.data[0].IdMunicipio;
            $scope.Usuario.IdTipoUsuario = datos.data[0].IdTipoUsuario;
            $scope.Usuario.Id = datos.data[0].Id;
            $scope.Usuario.UserPrint = datos.data[0].Departamento + ' ' + datos.data[0].Municipio;
            $scope.Usuario.TipoTipoUsuario = datos.data[0].TipoTipoUsuario;
            if ($scope.Usuario.TipoTipoUsuario == 'ADMIN')
                $scope.TipoUser = 'AD';
            else if ($scope.Usuario.TipoTipoUsuario == 'ANALISTA')
                $scope.TipoUser = 'AN';
            cargarComboDepartamentos();
            cargarReAlimentacion();
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    ObtenerUsuario();

    $scope.idBanderaDes = 0; //Para saber si ya existen preguntas cargadas 0 NO - 1 Si
    $scope.idBanderaRev = 0; //Para saber si ya existen preguntas cargadas 0 NO - 1 Si en Revision
    $scope.tipo = myTipo.get();
    $scope.tipoGraf = 1;
    $scope.encuestas;
    $scope.RetroArchivo;
    $scope.registro = {}; //la etapa del analisis
    $scope.recomendaciones = {}; // para las recomendacion del analisis
    $scope.encuestasDes = []; // Tengo las encuestas de desarrollo
    $scope.encuestasDesGrilla = [];
    $scope.archivosRevGrilla = [];
    $scope.usuarios = [];
    $scope.titGen = null;
    $scope.Nivel = {
        Id: 0,
        IdNivelGraf: 2, Color1Niv: '#803690', Titulo: 'Nivel de Avance Porcentaje diligenciamiento RUSICST', IdRetroEncuesta: 0,
        Nombre1Niv: ' '
    };
    $scope.Desarrollo = {
        ColorDesDis: '#E67E22', ColorDesImp: '#803690', ColorDesEval: '#2471A3',
        Nombre1Des: 'Diseno 2014', Nombre2Des: 'Diseno 2015', Nombre3Des: 'Diseno 2016', Nombre4Des: 'Implementacion 2014', Nombre5Des: 'Implementacion 2015', Nombre6Des: 'Implementacion 2016', Nombre7Des: 'Evaluacion 2014', Nombre8Des: 'Evaluacion 2015', Nombre9Des: 'Evaluacion 2016',
        Titulo: 'Nivel de Avance Politica publica de Victimas'
    };

    $scope.TituloGen = "Cambiar Titulos por Alcaldia";

    $scope.CambiarTituBoton = function () {
        if ($scope.TituloGen == "Cambiar Titulos por Alcaldia")
            $scope.TituloGen = "Cambiar Titulos Generales";
        else {
            $scope.TituloGen = "Cambiar Titulos por Alcaldia";
            $scope.titGen = null;
        }
        $scope.realimentacion = { IdTipoGuardado: 0, Id: 0, IdRetroAdmin: 0 };
        cargarDatos($scope.idRetroAdmin);
    }

    $scope.cargarMunicipiosTitulos = function () {
        $scope.titGen = $scope.titulos.municipio;
        $scope.realimentacion = { IdTipoGuardado: 0, Id: 0, IdRetroAdmin: 0 };
        cargarDatos($scope.idRetroAdmin);
    }


    
    //------------------------EXPORTAR---------------------------------------
    $scope.exportarPrint = function () {
        window.print();
    }

    $scope.exportar = function () {
        //if ($scope.data2 == []) $timeout.cancel(filterTextTimeout);

        //tempFilterText = val;
        //filterTextTimeout = $timeout(function () {
        //    $scope.filterText = tempFilterText;
        //}, 25000); // delay 250 ms
        var data0;
        var data1;
        var data2;
        var data3, data31;
        var data4;
        var data5;
        var data6;
        var data7;
        html2canvas(document.getElementById('PrintContent0'), {
            onrendered: function (canvas) {
                data0 = canvas.toDataURL();
                html2canvas(document.getElementById('PrintContent'), {
                    onrendered: function (canvas) {
                        data1 = canvas.toDataURL();
                        html2canvas(document.getElementById('PrintContent2'), {
                            onrendered: function (canvas) {
                                data2 = canvas.toDataURL();
                                html2canvas(document.getElementById('PrintContent31'), {
                                    onrendered: function (canvas) {
                                        data31 = canvas.toDataURL();
                                                html2canvas(document.getElementById('PrintContent3'), {
                                                    onrendered: function (canvas) {
                                                        data3 = canvas.toDataURL();
                                                        //html2canvas(document.getElementById('PrintContent4'), {
                                                        //    onrendered: function (canvas) {
                                                        //        data4 = canvas.toDataURL();
                                                                html2canvas(document.getElementById('PrintContent5'), {
                                                                    onrendered: function (canvas) {
                                                                        data5 = canvas.toDataURL();
                                                                        html2canvas(document.getElementById('PrintContent6'), {
                                                                            onrendered: function (canvas) {
                                                                                data6 = canvas.toDataURL();
                                                                                html2canvas(document.getElementById('PrintContent7'), {
                                                                                    onrendered: function (canvas) {
                                                                                        data7 = canvas.toDataURL();
                                                                                        var docDefinition = {
                                                                                            content: [{
                                                                                                image: data0,
                                                                                                width: 500,
                                                                                            },
                                                                                            {
                                                                                                image: data1,
                                                                                                width: 500,
                                                                                            },
                                                                                            {
                                                                                                image: data2,
                                                                                                width: 500,
                                                                                            },
                                                                                            {
                                                                                                image: data3,
                                                                                                width: 500,
                                                                                            },
                                                                                            {
                                                                                                image: data31,
                                                                                                width: 500,
                                                                                            },
                                                                                            //{
                                                                                            //    image: data4,
                                                                                            //    width: 500,
                                                                                            //},
                                                                                            {
                                                                                                image: data5,
                                                                                                width: 500,
                                                                                            },
                                                                                            {
                                                                                                image: data6,
                                                                                                width: 500,
                                                                                            },
                                                                                            {
                                                                                                image: data7,
                                                                                                width: 500,
                                                                                            }]
                                                                                        };
                                                                                        pdfMake.createPdf(docDefinition).download("RetroAlimentación" + $scope.Usuario.UserName + ".pdf");
                                                                                    }
                                                                                });
                                                                            }
                                                                        });
                                                                    }
                                                                });

                                                        //    }
                                                        //});
                                                    }
                                        });
                                    }
                                });
                            }
                        });
                    }
                });
            }
        });
    };

    //-----------------------OBTENER SECCIONES Y SUBSECCIONES----------------------------------
    $scope.CargarSeccionesAnalisis = function (modoAdmin) {
        $scope.AnalisisAco = [{ Titulo: '01 Dinámica del Conflicto Armado', Conteo: 0, Recomendacion: [] },
        { Titulo: '02 Comité de Justicia Transicional', Conteo: 0, Recomendacion: [] },
        { Titulo: '03 Plan de Acción Territorial', Conteo: 0, Recomendacion: [] },
        { Titulo: '04 Participación de las Víctimas', Conteo: 0, Recomendacion: [] },
        { Titulo: '05 Articulación Institucional', Conteo: 0, Recomendacion: [] },
        { Titulo: '06 Retorno y Reubicación', Conteo: 0, Recomendacion: [] },
        { Titulo: '07 Adecuación Institucional', Conteo: 0, Recomendacion: [] }
        ]
        var url;
        $scope.AccionesMejora = { siTotal: 0, siParcial: 0, No: 0 };
        $scope.AccionesCumplidas = { cumplidas: 0, NoCumplidas: 0 };
        $scope.Tiempo = { vencidas: 0, proxima: 0, aTiempo: 0, cumplida: 0 };
        var FechaHoy = moment(new Date());
        if (modoAdmin)
            url = '/api/ReAlimentacion/ObtenerAnaRecomendacion/?pIdEncuesta=' + $scope.idEncuesta + '&pUsername=' + $scope.analisis.municipio;
        else
            url = '/api/ReAlimentacion/ObtenerAnaRecomendacion/?pIdEncuesta=' + $scope.idEncuesta + '&pUsername=' + $scope.Usuario.UserName;
        var servCall1 = APIService.getSubs(url);
        servCall1.then(function (response) {
            $scope.recomendaciones = response;
            angular.forEach(response, function (datos) {

                if (Date.parse(datos.FechaCumplimiento) < Date.parse(FechaHoy)) {
                    datos.FechaTipo = 0;//vencida
                    $scope.Tiempo.vencidas++;
                }
                else if (Date.parse(datos.FechaCumplimiento) > Date.parse(FechaHoy) && Date.parse(datos.FechaCumplimiento) < Date.parse(FechaHoy.add(3, 'months'))) {
                    datos.FechaTipo = 1;//proxima
                    $scope.Tiempo.proxima++;
                }
                else if (Date.parse(datos.FechaCumplimiento) > Date.parse(FechaHoy) && Date.parse(datos.FechaCumplimiento) > Date.parse(FechaHoy.add(3, 'months'))) {
                    datos.FechaTipo = 2;//a Tiempo
                    $scope.Tiempo.aTiempo++;
                }
                else {
                    datos.FechaTipo = 3;//Cumplida
                    $scope.Tiempo.cumplida++;
                }
                datos.AccionPermite = datos.AccionPermite.toString();
                datos.AccionCumplio = datos.AccionCumplio.toString();
                datos.tipo = $scope.tipo;
                switch (datos.Titulo.substr(0, 2)) {
                    case '01':
                        $scope.AnalisisAco[0].Recomendacion.push(datos);
                        $scope.AnalisisAco[0].Conteo++;
                        break;
                    case '02':
                        $scope.AnalisisAco[1].Recomendacion.push(datos);
                        $scope.AnalisisAco[1].Conteo++;
                        break;
                    case '03':
                        $scope.AnalisisAco[2].Recomendacion.push(datos);
                        $scope.AnalisisAco[2].Conteo++;
                        break;
                    case '04':
                        $scope.AnalisisAco[3].Recomendacion.push(datos);
                        $scope.AnalisisAco[3].Conteo++;
                        break;
                    case '05':
                        $scope.AnalisisAco[4].Recomendacion.push(datos);
                        $scope.AnalisisAco[4].Conteo++;
                        break;
                    case '06':
                        $scope.AnalisisAco[5].Recomendacion.push(datos);
                        $scope.AnalisisAco[5].Conteo++;
                        break;
                    case '07':
                        $scope.AnalisisAco[6].Recomendacion.push(datos);
                        $scope.AnalisisAco[6].Conteo++;
                }
                switch (datos.AccionPermite) {
                    case '0':
                        $scope.AccionesMejora.No++;
                        break;
                    case '1':
                        $scope.AccionesMejora.siTotal++;
                        break;
                    case '2':
                        $scope.AccionesMejora.siParcial++;
                        break;
                }
                if (datos.AccionCumplio == 1)
                    $scope.AccionesCumplidas.cumplidas++;
                else
                    $scope.AccionesCumplidas.NoCumplidas++;

            });
            actualizarGraficaAnalisis();
        }, function (error) {
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición";
        });
    };

    function mySplit(string, nb) {
        var array = string.split(',');
        return array[nb];
    };

    $scope.goEliminar = function (entity) {
        if (entity.Id != 0) {
            entity.IdPregunta = entity.Id;
            entity.AudUserName = authService.authentication.userName;
            entity.AddIdent = authService.authentication.isAddIdent;
            entity.UserNameAddIdent = authService.authentication.userNameAddIdent;

            var enviar = { url: '/api/ReAlimentacion/EliminarRetroDesPreguntaXId/', msn: "¿Está seguro de eliminar la pregunta?", entity: entity };
            var templateUrl = 'app/views/modals/ConfirmacionEliminar.html';
            var controller = 'ModalEliminarController';
            var cont = 0;
            var modalInstance = $uibModal.open({
                templateUrl: templateUrl,
                controller: controller,
                resolve: {
                    datos: function () {
                        return enviar;
                    }
                },
                backdrop: 'static', keyboard: false
            });
            ;
            modalInstance.result.then(
                function (resultado) {
                    if (resultado) {
                        var index = $scope.encuestasDesGrilla.indexOf(entity);
                        $scope.encuestasDesGrilla.splice(index, 1)
                    }
                }
            );
        }
        else {
            var index = $scope.encuestasDesGrilla.indexOf(entity);
            $scope.encuestasDesGrilla.splice(index, 1);
        }
    };

    $scope.goEliminarRev = function (entity) {
        if (entity.Id != 0) {

            entity.AudUserName = authService.authentication.userName;
            entity.AddIdent = authService.authentication.isAddIdent;
            entity.UserNameAddIdent = authService.authentication.userNameAddIdent;

            var enviar = { url: '/api/ReAlimentacion/EliminarRetroArcPreguntas/', msn: "¿Está seguro de eliminar la pregunta?", entity: entity };
            var templateUrl = 'app/views/modals/ConfirmacionEliminar.html';
            var controller = 'ModalEliminarController';
            var cont = 0;
            var modalInstance = $uibModal.open({
                templateUrl: templateUrl,
                controller: controller,
                resolve: {
                    datos: function () {
                        return enviar;
                    }
                },
                backdrop: 'static', keyboard: false
            });
            modalInstance.result.then(
                function (resultado) {
                    if (resultado) {
                        var index = $scope.archivosRevGrilla.indexOf(entity);
                        $scope.archivosRevGrilla.splice(index, 1)
                    }
                }
            );
        }
        else {
            var index = $scope.archivosRevGrilla.indexOf(entity);
            $scope.archivosRevGrilla.splice(index, 1);
        }
    };

    function cargarComboDepartamentos() {
        var url = '/api/General/Listas/DepartamentosMunicipios?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.GobernacionAlcaldias = response;
            var flags = [], output = [], l = response.length, i;
            for (i = 0; i < l; i++) {
                if (flags[response[i].IdDepartamento]) continue;
                flags[response[i].IdDepartamento] = true;
                output.push(response[i]);
            }
            $scope.gobernaciones = output;
        }, function (error) {
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición";
        });
    }

    $scope.cargarComboUsuarios = function () {
        $scope.usuarios = [];
        var url = '/api/ReAlimentacion/ObtenerRetroUsuarioDesarrollo/?pIdDepartamento=' + $scope.Desarrollo.departamento;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            angular.forEach(response, function (usuario) {
                $scope.usuarios.push(usuario);
            })
        }, function (error) {
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición";
        });
    }

    $scope.cargarComboMunicipiosTitulos = function () {
        $scope.usuarios = [];
        var url = '/api/ReAlimentacion/ObtenerRetroUsuarioDesarrollo/?pIdDepartamento=' + $scope.titulos.departamento;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            angular.forEach(response, function (usuario) {
                $scope.usuarios.push(usuario);
            })
        }, function (error) {
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición";
        });
    }

    $scope.cargarComboMunicipios = function () {
        $scope.usuarios = [];
        var url = '/api/ReAlimentacion/ObtenerRetroUsuarioDesarrollo/?pIdDepartamento=' + $scope.revision.departamento;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            angular.forEach(response, function (usuario) {
                $scope.usuarios.push(usuario);
            })
        }, function (error) {
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición";
        });
    }

    $scope.cargarComboMunicipiosNivel = function () {
        $scope.usuarios = [];
        var url = '/api/ReAlimentacion/ObtenerRetroUsuarioDesarrollo/?pIdDepartamento=' + $scope.nivel.departamento;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            angular.forEach(response, function (usuario) {
                $scope.usuarios.push(usuario);
            })
        }, function (error) {
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición";
        });
    }

    $scope.cargarComboMunicipiosAnalisis = function () {
        $scope.usuarios = [];
        var url = '/api/ReAlimentacion/ObtenerRetroUsuarioDesarrollo/?pIdDepartamento=' + $scope.analisis.departamento;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            angular.forEach(response, function (usuario) {
                $scope.usuarios.push(usuario);
            })
        }, function (error) {
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición";
        });
    }

    $scope.cargarComboMunicipiosHistorico = function () {
        $scope.usuarios = [];
        var url = '/api/ReAlimentacion/ObtenerRetroUsuarioDesarrollo/?pIdDepartamento=' + $scope.historico.departamento;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            angular.forEach(response, function (usuario) {
                $scope.usuarios.push(usuario);
            })
        }, function (error) {
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición";
        });
    }

    function ObtenerSeriesNivel(pIdRetroAdmin) {
        var url = '/api/ReAlimentacion/ObtenerDatosNivelAdmin/?pIdRetroAdmin=' + pIdRetroAdmin + '&pIdUser=' + $scope.Usuario.UserName; //
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.data = [[response.Municipio]];
            $scope.data2 = [response.Municipio];
            $scope.Nivel.TxtGrafica = "Su municipio respondió " + response.RespuestasMunicipio + " de " + response.TotalPreguntas + " preguntas habilitadas "
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    function ObtenerGraficaNivel() {
        var url = '/api/ReAlimentacion/ObtenerGraficaRetroNivel/?pIdRetroAdmin=' + $scope.idRetroAdmin;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            if (response.length > 0) {
                $scope.Nivel = {
                    IdNivelGraf: response[0].TipoGrafica, Color1Niv: response[0].Color1serie, Color2Niv: response[0].Color2serie, Color3Niv: response[0].Color3serie, Titulo: response[0].TituloGraf,
                    Nombre1Niv: response[0].NombreSerie1, Nombre2Niv: response[0].NombreSerie2, Nombre3Niv: response[0].NombreSerie3
                };
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    function ObtenerGraficaDesarrollo() {
        var url = '/api/ReAlimentacion/ObtenerGraficaRetroDesarrollo/?pIdRetroAdmin=' + $scope.idRetroAdmin;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            if (response.length > 0) {
                $scope.Desarrollo = {
                    ColorDesDis: response[0].ColorDis, ColorDesImp: response[0].ColorImp, ColorDesEval: response[0].ColorEval,
                    Nombre1Des: response[0].NombreSerie1, Nombre2Des: response[0].NombreSerie2, Nombre3Des: response[0].NombreSerie3,
                    Nombre4Des: response[0].NombreSerie4, Nombre5Des: response[0].NombreSerie5, Nombre6Des: response[0].NombreSerie6,
                    Nombre7Des: response[0].NombreSerie7, Nombre8Des: response[0].NombreSerie8, Nombre9Des: response[0].NombreSerie9,
                    Titulo: response[0].NombreGrafica
                };
                actualizarGraficaDesarrollo();
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    $scope.ObtenerSeriesNivelxUsuario = function () {
        var url = '/api/ReAlimentacion/ObtenerDatosNivelAdmin/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pIdUser=' + $scope.nivel.municipio; //
        var servCall = APIService.getSubs(url);
        $scope.cargarNivel = true;
        servCall.then(function (response) {
            $scope.data = [[response.Municipio]];
            $scope.data2 = [response.Municipio];
            $scope.Nivel.TxtGrafica = "Su municipio respondió " + response.RespuestasMunicipio + " de " + response.TotalPreguntas + " preguntas habilitadas "
            actualizarGraficaNivel();
            $scope.cargarNivel = false;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    function cargarDatos(pIdRetroAdmin) {
        var url = '/api/ReAlimentacion/ReAlimentacion/';
        $scope.realimentacion.IdRetroAdmin = $scope.idRetroAdmin;
        $scope.realimentacion.Municipio = $scope.titGen;
        var servCall = APIService.saveSubscriber($scope.realimentacion, url);
        servCall.then(function (datos) {
            $scope.realimentacion = datos.data;
            var PresTexto = $scope.realimentacion.PresTexto;
            PresTexto = $sce.trustAsHtml(PresTexto);
            $scope.myHTMLPresTexto = PresTexto;
            var NivTexto = $scope.realimentacion.NivTexto;
            NivTexto = $sce.trustAsHtml(NivTexto);
            $scope.myHTMLNivTexto = NivTexto;
            var Niv2Texto = $scope.realimentacion.Niv2Texto;
            Niv2Texto = $sce.trustAsHtml(Niv2Texto);
            $scope.myHTMLNiv2Texto = Niv2Texto;
            var DesTexto = $scope.realimentacion.DesTexto;
            DesTexto = $sce.trustAsHtml(DesTexto);
            $scope.myHTMLDesTexto = DesTexto;
            var Des2Texto = $scope.realimentacion.Des2Texto;
            Des2Texto = $sce.trustAsHtml(Des2Texto);
            $scope.myHTMLDes2Texto = Des2Texto;
            var AnaTexto = $scope.realimentacion.AnaTexto;
            AnaTexto = $sce.trustAsHtml(AnaTexto);
            $scope.myHTMLAnaTexto = AnaTexto;
            var RevTexto = $scope.realimentacion.RevTexto;
            RevTexto = $sce.trustAsHtml(RevTexto);
            $scope.myHTMLRevTexto = RevTexto;
            var HisTexto = $scope.realimentacion.HisTexto;
            HisTexto = $sce.trustAsHtml(HisTexto);
            $scope.myHTMLHisTexto = HisTexto;
            var ObsTexto = $scope.realimentacion.ObsTexto;
            ObsTexto = $sce.trustAsHtml(ObsTexto);
            $scope.myHTMLObsTexto = ObsTexto;
        }, function (error) {
            $scope.cargoDatos = true;
            $scope.error = "Se generó un error en la petición";
        });
    };

    $scope.pintarGrafNivel = function () {
        actualizarGraficaNivel();
    }

    function actualizarGraficaNivel() {
        if ($scope.nivel != null) {
            $scope.series = [$scope.nivel.municipio];//[$scope.Nivel.Nombre1Niv];
            $scope.labels = [$scope.nivel.municipio];//[$scope.Nivel.Nombre1Niv];
        }
        else {
            $scope.series = [$scope.Usuario.UserName];
            $scope.labels = [$scope.Usuario.UserName];
        }
        $scope.colors = [$scope.Nivel.Color1Niv];
        

        $scope.optionsNiv = {
            barShowStroke: false,
            scales: {
                yAxes: [{
                    display: true,
                    ticks: {
                        beginAtZero: true,
                        max: 100,
                        callback: function (value, index, values) {
                            return value + ' %';
                        }
                    }
                }]
            }
        };

        $scope.optionsNivPA = {
            scales: {
                display: true,
                ticks: {
                    beginAtZero: true,
                    max: 100,
                    callback: function (value, index, values) {
                        return value + ' %';
                    }
                }
            }            
        };

        $scope.optionsNivHB = {
            tooltipEvents: [],
            showTooltips: true,
            tooltipCaretSize: 10,
            onAnimationComplete: function () {
                this.showTooltip(this.segments, true);
            },
            scales: {
                xAxes: [{
                    display: true,
                    ticks: {
                        beginAtZero: true,
                        max: 100,
                        callback: function (value, index, values) {
                            return value + ' %';
                        }
                    }
                }]
            }
        };

        $scope.datasetOverrideNiv = [
            {
                series: [$scope.nivel.municipio],//[$scope.Nivel.Nombre1Niv],
                fill: true,
                backgroundColor: [$scope.Nivel.Color1Niv]
            }];
    }

    function actualizarGraficaAnalisis() {
        $scope.data1Ana = [$scope.AccionesMejora.siTotal, $scope.AccionesMejora.siParcial, $scope.AccionesMejora.No];
        $scope.colorsAna1 = ['#2ECC71', '#2471A3', '#C0392B'];
        $scope.labelsAna1 = ['Si, totalmente', 'Si, parcialmente', 'No'];

        $scope.data2Ana = [$scope.AccionesCumplidas.cumplidas, $scope.AccionesCumplidas.NoCumplidas];
        $scope.colorsAna2 = ['#2ECC71', '#C0392B'];
        $scope.labelsAna2 = ['Cumplidas', 'No, Cumplidas'];

        $scope.data3Ana = [$scope.Tiempo.cumplida, $scope.Tiempo.aTiempo, $scope.Tiempo.proxima, $scope.Tiempo.vencidas];
        $scope.colorsAna3 = ['#2ECC71', '#2471A3', '#FDB45C', '#C0392B'];
        $scope.labelsAna3 = ['Cumplidas', 'A tiempo', 'Próximas a Vencer', 'Vencidas'];

        $scope.OpcionAna = {
            legend: {
                fullWidth: false,
                display: true,
                position: 'top',
                labels: {
                    fontColor: 'Black',
                    fontSize: 11
                }
            }
        }
    }

    $scope.pintarGrafDesarrollo = function () {
        actualizarGraficaDesarrollo();
    }

    function actualizarGraficaDesarrollo() {
        $scope.labelsDes = [$scope.Desarrollo.Nombre1Des, $scope.Desarrollo.Nombre2Des, $scope.Desarrollo.Nombre3Des, $scope.Desarrollo.Nombre4Des, $scope.Desarrollo.Nombre5Des, $scope.Desarrollo.Nombre6Des, $scope.Desarrollo.Nombre7Des, $scope.Desarrollo.Nombre8Des, $scope.Desarrollo.Nombre9Des];
        $scope.dataDes = [
            [30, 20, 10, 40, 50, 60, 70, 50, 90]
        ];

        $scope.optionsDes = {
            barShowStroke: false,
            scales: {
                xAxes: [{
                    ticks: {
                        autoSkip: false,
                        maxRotation: 90,
                        minRotation: 90
                    }
                }],
                yAxes: [{
                    display: true,
                    ticks: {
                        beginAtZero: true,
                        max: 100,
                        callback: function (value, index, values) {
                            return value + ' %';
                        }
                    }
                }]
            }
        };

        $scope.datasetOverride = [
            {
                series: [$scope.Desarrollo.Nombre1Des, $scope.Desarrollo.Nombre2Des, $scope.Desarrollo.Nombre3Des, $scope.Desarrollo.Nombre4Des, $scope.Desarrollo.Nombre5Des, $scope.Desarrollo.Nombre6Des, $scope.Desarrollo.Nombre7Des, $scope.Desarrollo.Nombre8Des, $scope.Desarrollo.Nombre9Des],
                fill: true,
                backgroundColor: [$scope.Desarrollo.ColorDesDis, $scope.Desarrollo.ColorDesDis, $scope.Desarrollo.ColorDesDis, $scope.Desarrollo.ColorDesImp, $scope.Desarrollo.ColorDesImp, $scope.Desarrollo.ColorDesImp, $scope.Desarrollo.ColorDesEval, $scope.Desarrollo.ColorDesEval, $scope.Desarrollo.ColorDesEval]
            }];
    }

    function cargarComboEncuesta() {
        var url = '/api/General/Listas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de combo de encuestas";
        });
    };

    function AgregarEncuestaPrincipal() {
        var newTemp = $filter("filter")($scope.encuestas, { Id: $scope.idEncuesta });
        var Titulo = "";
        angular.forEach(newTemp, function (Enc) {
            if (Enc.Id == $scope.idEncuesta)
                Titulo = Enc.Titulo;
        });

        $scope.encuestasDes.push({
            'Id': $scope.idEncuesta,
            'Titulo': Titulo
        });

    };

    $scope.AgregarEncDes = function () {
        if ($scope.encuestasDes.length < 3) {
            var index = true;
            angular.forEach($scope.encuestasDes, function (Enc) {
                if (Enc.Id == $scope.filtro.EncuestaRelacionada)
                    index = false;
            });
            if (index) {
                var newTemp = $filter("filter")($scope.encuestas, { Id: $scope.filtro.EncuestaRelacionada });
                var Titulo = "";
                angular.forEach(newTemp, function (Enc) {
                    if (Enc.Id == $scope.filtro.EncuestaRelacionada)
                        Titulo = Enc.Titulo;
                });

                $scope.encuestasDes.push({
                    'Id': $scope.filtro.EncuestaRelacionada,
                    'Titulo': Titulo
                });
            }
            else {
                var mensaje = { msn: 'la Encuesta ya esta agregada!!. ', tipo: "alert alert-warning" };
                openRespuesta(mensaje);
            }
        }
        else {
            var mensaje = { msn: 'Solo se pueden Cargar 3 Encuestas. ', tipo: "alert alert-warning" };
            openRespuesta(mensaje);
        }
    };

    $scope.eliminarEncDes = function (item) {
        if ($scope.idBanderaDes == 0) {
            var index = $scope.encuestasDes.indexOf(item);
            if (index == 0) {
                var mensaje = { msn: 'No se puede eliminar la encuesta principal. ', tipo: "alert alert-warning" };
                openRespuesta(mensaje);
            }
            else {
                $scope.encuestasDes.splice(index, 1);
            }
        }
        else {

            item.idRetroAdmin = $scope.idRetroAdmin;
            item.AudUserName = authService.authentication.userName;
            item.AddIdent = authService.authentication.isAddIdent;
            item.UserNameAddIdent = authService.authentication.userNameAddIdent;

            var enviar = { url: '/api/ReAlimentacion/EliminarRetroDesPreguntas/', msn: "Al eliminar la encuesta se eliminan todas las preguntas asociadas a las encuestas ¿Está seguro de realizar la eliminación?", entity: item };
            var templateUrl = 'app/views/modals/ConfirmacionEliminar.html';
            var controller = 'ModalEliminarController';
            var cont = 0;
            var modalInstance = $uibModal.open({
                templateUrl: templateUrl,
                controller: controller,
                resolve: {
                    datos: function () {
                        return enviar;
                    }
                },
                backdrop: 'static', keyboard: false
            });
            modalInstance.result.then(
                function () {
                    var index = $scope.encuestasDes.indexOf(item);
                    $scope.encuestasDes.splice(index, 1);
                }
            );
        };
    };

    $scope.buscarPregunta = function () {
        var index = true;
        angular.forEach($scope.encuestasDesGrilla, function (Enc) {
            if (Enc.CodigoPregunta == $scope.codigoNiv.Pregunta)
                index = false;
        });
        if (index) {
            var idsEncuesta = "";
            angular.forEach($scope.encuestasDes, function (Enc) {
                idsEncuesta = idsEncuesta + "," + Enc.Id;
            });
            var url = '/api/ReAlimentacion/ObtenerPreguntaXcodigo/?pCodigoPregunta=' + $scope.codigoNiv.Pregunta + '&pIdsEncuestao=' + idsEncuesta.substring(1);
            var servCall = APIService.getSubs(url);
            servCall.then(function (response) {
                var Pregunta = response;
                var idEncNOestan = "";
                angular.forEach(Pregunta, function (Pre) {
                    if (Pre.IdEncuesta == null) {
                        angular.forEach($scope.encuestasDes, function (Enc) {
                            if (Pre.Palabra == Enc.Id)
                                idEncNOestan = idEncNOestan + ',' + Enc.Titulo;
                        });
                    }
                });
                if (idEncNOestan == "") {

                    $scope.encuestasDesGrilla.push(Pregunta[0]);
                }
                else {
                    var mensaje = { msn: 'las siguientes Encuestas no contienen el codigo de pregunta . ' + idEncNOestan, tipo: "alert alert-warning" };
                    openRespuesta(mensaje);
                }
            }, function (error) {
                $scope.error = "Se generó un error en la petición de cargue de las Secciones";
            });
        }
        else {
            var mensaje = { msn: 'La pregunta ya se encuentra agregada. ', tipo: "alert alert-warning" };
            openRespuesta(mensaje);
        }
    };

    $scope.buscarPreguntaRev = function () {
        var index = true;
        angular.forEach($scope.archivosRevGrilla, function (Enc) {
            if (Enc.CodigoPregunta == $scope.revision.CodigoPre)
                index = false;
        });
        if (index) {
            var url = '/api/ReAlimentacion/ObtenerPreguntaXcodigoArchivoAdmin/?pCodigoPregunta=' + $scope.revision.CodigoPre + '&pIdEncuesta=' + $scope.idEncuesta;// + '&pIdDepartamento=' + $scope.revision.departamento + '&pIdMunicipio=' + $scope.revision.municipio;
            var servCall = APIService.getSubs(url);
            servCall.then(function (response) {
                if (response.length > 0) {
                    var Pregunta = response;
                    Pregunta[0].Sumatoria = true;
                    $scope.archivosRevGrilla.push(Pregunta[0]);
                }
                else {
                    var mensaje = { msn: 'La encuesta no contiene el codigo de la pregunta.', tipo: "alert alert-warning" };
                    openRespuesta(mensaje);
                }
            }, function (error) {
                $scope.error = "Se generó un error en la petición de cargue de las Secciones";
            });
        }
        else {
            var mensaje = { msn: 'La pregunta ya se encuentra agregada. ', tipo: "alert alert-warning" };
            openRespuesta(mensaje);
        }
    };

    $scope.descargarArchivo = function (item) {
        $scope.RetroArchivo = { Valor: item.Valor, Nombre: item.Nombre }
        var url = $scope.serviceBase + '/api/Sistema/DescargarRetro/?path=' + item.Valor + '&nombreArchivo=' + item.Nombre;
        window.open(url)
    }

    $scope.guardarPresentacion = function () {
        guardarDatos(1); // Presentacion
    };

    $scope.guardarNivel = function () {
        guardarDatos(2); // Nivel
        guardarDatosGrafNivel();
    };

    $scope.guardarDesarrollo = function () {
        guardarDatos(3); // Desarrollo
        guardarDatosGrafDesarrollo();
    };

    $scope.guardarAnalisis = function () {
        guardarDatos(4); // Analisis
    };

    $scope.guardarRevision = function () {
        guardarDatos(5); // Revision
    };

    $scope.guardarHistorial = function () {
        guardarDatos(6); // Historial
    };

    $scope.guardarObservacion = function () {
        guardarDatos(7); // Observacion
    };

    function guardarDatos(tipoGuardado) {
        var url = '/api/ReAlimentacion/ReAlimentacion/ActualizarRetro/';
        $scope.realimentacion.IdTipoGuardado = tipoGuardado;
        $scope.realimentacion.IdRetroAdmin = $scope.idRetroAdmin;
        $scope.realimentacion.Municipio = $scope.titGen;

        $scope.realimentacion.AudUserName = authService.authentication.userName;
        $scope.realimentacion.AddIdent = authService.authentication.isAddIdent;
        $scope.realimentacion.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.realimentacion, url);
        servCall.then(function (response) {
            var resultado = {};
            switch (response.data.estado) {
                case 0:
                    var mensaje = { msn: response.data.respuesta, tipo: "alert alert-warning" };
                    openRespuesta(mensaje);
                    break;
                case 1:
                    var mensaje = { msn: "El registro fue creado satisfactoriamente", tipo: "alert alert-success" };
                    openRespuesta(mensaje);
                    break;
                case 2:
                    var mensaje = { msn: "El registro fue actualizado satisfactoriamente", tipo: "alert alert-success" };
                    openRespuesta(mensaje);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
            document.location.reload();
        });
    };

    $scope.guardarAnalisisReco = function (recomendacion) {
        var url = '/api/ReAlimentacion/ReAlimentacion/ActualizarAnaRecomendacion/';

        recomendacion.AudUserName = authService.authentication.userName;
        recomendacion.AddIdent = authService.authentication.isAddIdent;
        recomendacion.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber(recomendacion, url);
        servCall.then(function (response) {
            var resultado = {};
            switch (response.data.estado) {
                case 0:
                    var mensaje = { msn: response.data.respuesta, tipo: "alert alert-warning" };
                    openRespuesta(mensaje);
                    break;
                case 1:
                    var mensaje = { msn: "El registro fue creado satisfactoriamente", tipo: "alert alert-success" };
                    openRespuesta(mensaje);
                    break;
                case 2:
                    var mensaje = { msn: "El registro fue actualizado satisfactoriamente", tipo: "alert alert-success" };
                    openRespuesta(mensaje);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
            document.location.reload();
        });
    };

    function guardarDatosGrafNivel() {
        var url = '/api/ReAlimentacion/ReAlimentacion/ActualizarGrafNivel/';
        $scope.Nivel.IdRetroAdmin = $scope.idRetroAdmin;

        $scope.Nivel.AudUserName = authService.authentication.userName;
        $scope.Nivel.AddIdent = authService.authentication.isAddIdent;
        $scope.Nivel.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.Nivel, url);
        servCall.then(function (response) {
            var resultado = {};
            resultado.estado = response.data.estado
            switch (response.data.estado) {
                case 0:
                    var mensaje = { msn: response.data.respuesta, tipo: "alert alert-warning" };
                    openRespuesta(mensaje);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
            document.location.reload();
        });
    };

    function guardarDatosGrafDesarrollo() {
        var url = '/api/ReAlimentacion/ReAlimentacion/ActualizarGrafDesarrollo/';

        $scope.Desarrollo.IdRetroAdmin = $scope.idRetroAdmin;
        $scope.Desarrollo.AudUserName = authService.authentication.userName;
        $scope.Desarrollo.AddIdent = authService.authentication.isAddIdent;
        $scope.Desarrollo.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var servCall = APIService.saveSubscriber($scope.Desarrollo, url);
        servCall.then(function (response) {
            var resultado = {};
            resultado.estado = response.data.estado
            switch (response.data.estado) {
                case 0:
                    var mensaje = { msn: response.data.respuesta, tipo: "alert alert-warning" };
                    openRespuesta(mensaje);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
            document.location.reload();
        });
    };

    $scope.guardarPreguntasDesarrollo = function () {
        if ($scope.encuestasDesGrilla.length > 0) {
            var idsEncuesta = "";
            angular.forEach($scope.encuestasDes, function (Enc) {
                idsEncuesta = idsEncuesta + "," + Enc.Id;
            });
            var pListaPreguntas = []
            var Models = {};
            angular.forEach($scope.encuestasDesGrilla, function (Enc) {
                var RetroPreguntasDesModels = angular.copy(Models);
                RetroPreguntasDesModels.IdRetroConsulta = $scope.idRetroAdmin;
                RetroPreguntasDesModels.IdsEncuestas = idsEncuesta.substring(1);
                RetroPreguntasDesModels.CodigoPregunta = Enc.CodigoPregunta;
                RetroPreguntasDesModels.NombrePregunta = Enc.NombrePregunta;
                RetroPreguntasDesModels.Nombre = Enc.Nombre;
                RetroPreguntasDesModels.Valor = Enc.Valor;

                RetroPreguntasDesModels.AudUserName = authService.authentication.userName;
                RetroPreguntasDesModels.AddIdent = authService.authentication.isAddIdent;
                RetroPreguntasDesModels.UserNameAddIdent = authService.authentication.userNameAddIdent;

                pListaPreguntas.push(RetroPreguntasDesModels);
            });

            var url = '/api/ReAlimentacion/InsertarRetroDesPreguntas/';

            var servCall = APIService.saveSubscriber(pListaPreguntas, url);
            servCall.then(function (response) {
                var resultado = {};
                resultado.estado = response.data.estado
                switch (response.data.estado) {
                    case 0:
                        var mensaje = { msn: response.data.respuesta, tipo: "alert alert-warning" };
                        openRespuesta(mensaje);
                        break;
                    case 1:
                        var mensaje = { msn: "El registro fue creado satisfactoriamente", tipo: "alert alert-success" };
                        openRespuesta(mensaje);
                        break;
                    case 2:
                        var mensaje = { msn: "El registro fue actualizado satisfactoriamente", tipo: "alert alert-success" };
                        openRespuesta(mensaje);
                        break;
                }
            }, function (error) {
                $scope.error = "Se generó un error en la petición, no se guardaron los datos";
                document.location.reload();
            });
        }
        else {
            var mensaje = { msn: "No hay preguntas para guardar", tipo: "alert alert-warning" };
            openRespuesta(mensaje);
        }
    };

    $scope.guardarPreguntasRevision = function () {
        var pListaPreguntas = []
        var Models = {};
        angular.forEach($scope.archivosRevGrilla, function (Arc) {
            var RetroPreguntasRevModels = angular.copy(Models);
            RetroPreguntasRevModels.Id = Arc.Id;
            RetroPreguntasRevModels.IdRetroAdmin = $scope.idRetroAdmin;
            RetroPreguntasRevModels.IdEncuesta = $scope.idEncuesta;
            RetroPreguntasRevModels.CodigoPregunta = Arc.CodigoPregunta;
            RetroPreguntasRevModels.Documento = Arc.Nombre;
            RetroPreguntasRevModels.Valor = Arc.Valor;
            RetroPreguntasRevModels.Check = Arc.Envio;
            RetroPreguntasRevModels.Sumatoria = Arc.Sumatoria;
            RetroPreguntasRevModels.Pertenece = Arc.Corresponde;
            RetroPreguntasRevModels.Observacion = Arc.Observaciones;
            RetroPreguntasRevModels.Observacion2 = Arc.Observaciones2;
            RetroPreguntasRevModels.Usuario = authService.authentication.userName;

            RetroPreguntasRevModels.AudUserName = authService.authentication.userName;
            RetroPreguntasRevModels.AddIdent = authService.authentication.isAddIdent;
            RetroPreguntasRevModels.UserNameAddIdent = authService.authentication.userNameAddIdent;

            pListaPreguntas.push(RetroPreguntasRevModels);
        });

        var url = '/api/ReAlimentacion/InsertarRetroArcPreguntas/';
        var servCall = APIService.saveSubscriber(pListaPreguntas, url);
        servCall.then(function (response) {
            var resultado = {};
            resultado.estado = response.data.estado
            switch (response.data.estado) {
                case 0:
                    var mensaje = { msn: response.data.respuesta, tipo: "alert alert-warning" };
                    openRespuesta(mensaje);
                    break;
                case 1:
                    var mensaje = { msn: "El registro fue creado satisfactoriamente", tipo: "alert alert-success" };
                    openRespuesta(mensaje);
                    $scope.cargarPreguntasRevision(true);
                    break;
                case 2:
                    var mensaje = { msn: "El registro fue actualizado satisfactoriamente", tipo: "alert alert-success" };
                    openRespuesta(mensaje);
                    $scope.cargarPreguntasRevision(true);
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
            document.location.reload();
        });
    };

    $scope.guardarPreguntasRevisionXUsuario = function () {
        var pListaPreguntas = []
        var Models = {};
        angular.forEach($scope.archivosRevGrilla, function (Arc) {
            var RetroPreguntasRevModels = angular.copy(Models);
            RetroPreguntasRevModels.Id = Arc.Id;
            RetroPreguntasRevModels.IdRetroAdmin = $scope.idRetroAdmin;
            RetroPreguntasRevModels.Valor = Arc.Valor;
            RetroPreguntasRevModels.Check = Arc.Envio;
            RetroPreguntasRevModels.Pertenece = Arc.Corresponde;
            RetroPreguntasRevModels.Observacion = Arc.Observaciones;
            RetroPreguntasRevModels.Observacion2 = Arc.Observaciones2;

            RetroPreguntasRevModels.AudUserName = authService.authentication.userName;
            RetroPreguntasRevModels.AddIdent = authService.authentication.isAddIdent;
            RetroPreguntasRevModels.UserNameAddIdent = authService.authentication.userNameAddIdent;

            if ($scope.Usuario.IdTipoUsuario == 1)
                RetroPreguntasRevModels.Usuario = authService.authentication.userName;
            else
                RetroPreguntasRevModels.Usuario = $scope.Usuario.UserName;
            pListaPreguntas.push(RetroPreguntasRevModels);
        });

        var url = '/api/ReAlimentacion/ActualizarRetroArcPreguntasXUsuario/';
        var servCall = APIService.saveSubscriber(pListaPreguntas, url);

        servCall.then(function (response) {
            var resultado = {};
            resultado.estado = response.data.estado
            switch (response.data.estado) {
                case 0:
                    var mensaje = { msn: response.data.respuesta, tipo: "alert alert-warning" };
                    openRespuesta(mensaje);
                    break;
                case 1:
                    var mensaje = { msn: "El registro fue creado satisfactoriamente", tipo: "alert alert-success" };
                    openRespuesta(mensaje);
                    break;
                case 2:
                    var mensaje = { msn: "El registro fue actualizado satisfactoriamente", tipo: "alert alert-success" };
                    openRespuesta(mensaje);
                    break;
            }
            actualizarGraficaRevision(false);
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
            document.location.reload();
        });
    };

    function actualizarGraficaRevision(validar) {
        var No = 0;
        var Si = 0;
        var Parcial = 0;
        if (validar) {
            angular.forEach($scope.archivosRevGrilla, function (Arc) {
                if (Arc.Sumatoria) {
                    if (Arc.Corresponde == "Si")
                        Si++;
                    else if (Arc.Corresponde == "No aplica")
                        Parcial++;
                    else
                        No++;
                }
            });
        }
        else
        {
            angular.forEach($scope.archivosRevGrilla, function (Arc) {
                if (Arc.Sumatoria) {
                    if (Arc.Corresponde == "1")
                        Si++;
                    else if (Arc.Corresponde == "2")
                        Parcial++;
                    else
                        No++;
                }
            });
        }

        $scope.colorsRev = ['#C0392B', '#2ECC71', '#2471A3'];
        $scope.labelsRev = ['No', 'Si', 'No aplica'];
        $scope.data2Rev = [No, Si, Parcial];

        $scope.OpcionRev = {
            legend: {
                fullWidth: true,
                display: true,
                position: 'bottom',
                labels: {
                    fontColor: 'Black',
                    fontSize: 11
                }
            }
        }
    }

    $scope.graficar7Des = function () {
        ObtenerDatosGraficaDesAcumulada();
        ObtenerDatosGraficaDesDinamica();
        ObtenerDatosGraficaDesComite();
        ObtenerDatosGraficaDesTerritorial();
        ObtenerDatosGraficaDesParticipacion();
        ObtenerDatosGraficaDesArticulacion();
        ObtenerDatosGraficaDesRetorno();
        ObtenerDatosGraficaDesAdecuacion();
    };

    $scope.graficar7DesXusuario = function () {
        if ($scope.Usuario.IdTipoUsuario != 1) {
            ObtenerDatosGraficaDesAcumulada();
            ObtenerDatosGraficaDesDinamica();
            ObtenerDatosGraficaDesComite();
            ObtenerDatosGraficaDesTerritorial();
            ObtenerDatosGraficaDesParticipacion();
            ObtenerDatosGraficaDesArticulacion();
            ObtenerDatosGraficaDesRetorno();
            ObtenerDatosGraficaDesAdecuacion();
        }
    };

    $scope.cargarPreguntas = function () {
        $scope.encuestasDes = [];
        $scope.encuestasDesGrilla = [];
        cargarComboEncuesta();
        var url = '/api/ReAlimentacion/ObtenerPreguntasDesXIdRetro/?pIdRetroAdmin=' + $scope.idRetroAdmin;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            if (response.length > 0) {
                for (var i = 0; i < 3; i++) {
                    var IdEncBus = mySplit(response[i].IdEncuesta, i);
                    var newTemp = $filter("filter")($scope.encuestas, { Id: IdEncBus });
                    var Titulo = "";
                    angular.forEach(newTemp, function (Enc) {
                        if (Enc.Id == IdEncBus)
                            Titulo = Enc.Titulo;
                    });

                    $scope.encuestasDes.push({
                        'Id': IdEncBus,
                        'Titulo': Titulo
                    });
                }

                angular.forEach(response, function (Enc) {
                    $scope.encuestasDesGrilla.push(Enc);
                });
                $scope.idBanderaDes = 1;
            }
            else
                AgregarEncuestaPrincipal();
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    $scope.cargarPreguntasRevision = function (modoAdmin) {
        $scope.archivosRevGrilla = [];
        if (modoAdmin)
            var url = '/api/ReAlimentacion/ObtenerPreguntasRevXIdRetroAdmin/?pIdRetroAdmin=' + $scope.idRetroAdmin;
        else
            var url = '/api/ReAlimentacion/ObtenerPreguntasRevXIdRetroXUsuario/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.revision.municipio + '&pIdEncuesta=' + $scope.idEncuesta;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            if (response.length > 0) {
                angular.forEach(response, function (Arc) {
                    Arc.Corresponde = Arc.Corresponde.toString();
                    $scope.archivosRevGrilla.push(Arc);
                });
                $scope.idBanderaRev = 1;
            }
            actualizarGraficaRevision(false);
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    $scope.cargarPreguntasRevisionXusuario = function () {
        $scope.archivosRevGrilla = [];
        var url = '/api/ReAlimentacion/ObtenerPreguntasRevXIdRetroXUsuario/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Usuario.UserName + '&pIdEncuesta=' + $scope.idEncuesta;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            if (response.length > 0) {
                angular.forEach(response, function (Arc) {
                    Arc.Corresponde = Arc.Corresponde.toString();
                    if (Arc.Corresponde == "0")
                        Arc.Corresponde = "No"
                    else if (Arc.Corresponde == "1")
                        Arc.Corresponde = "Si"
                    else
                        Arc.Corresponde = "No aplica"
                    $scope.archivosRevGrilla.push(Arc);
                });
                $scope.idBanderaRev = 1;
            }
            actualizarGraficaRevision(true);
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    $scope.cargarHistorico = function () {
        $scope.archivosHisGrilla1Periodo = [];
        $scope.archivosHisGrilla2Periodo = [];

        var url = '/api/ReAlimentacion/ObtenerHistoricoMunicipio/?pIdMunicipio=' + $scope.historico.municipio;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            if (response.length > 0) {
                for (var i = 0; i < 7; i++) {
                    $scope.archivosHisGrilla1Periodo.push(response[i]);
                }
                for (var i = 7; i < response.length; i++) {
                    $scope.archivosHisGrilla2Periodo.push(response[i]);
                }
                $scope.idBanderaRev = 1;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    $scope.cargarHistorialXusuario = function () {

        $scope.archivosHisGrilla1Periodo = [];
        $scope.archivosHisGrilla2Periodo = [];
        var url = '/api/ReAlimentacion/ObtenerHistoricoMunicipio/?pIdMunicipio=' + $scope.Usuario.UserName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            if (response.length > 0) {
                for (var i = 0; i < 7; i++) {
                    $scope.archivosHisGrilla1Periodo.push(response[i]);
                }
                for (var i = 7; i < response.length; i++) {
                    $scope.archivosHisGrilla2Periodo.push(response[i]);
                }
                $scope.idBanderaRev = 1;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    $scope.CrearHistorico = function () {
        var Models = {};
        Models.IdEncuesta = $scope.idEncuesta;
        Models.IdPregunta = $scope.historia.pregunta;
        Models.IdNombre = $scope.historia.nombre;
        Models.AudUserName = authService.authentication.userName;
        Models.AddIdent = authService.authentication.isAddIdent;
        Models.UserNameAddIdent = authService.authentication.userNameAddIdent;

        var url = '/api/ReAlimentacion/InsertarRetroHistoricoXEncuesta/';
        var servCall = APIService.saveSubscriber(Models, url);
        $scope.crearHisTodos = true;
        servCall.then(function (response) {
            var resultado = {};
            switch (response.data.estado) {
                case 0:
                    var mensaje = { msn: response.data.respuesta, tipo: "alert alert-warning" };
                    openRespuesta(mensaje);
                    $scope.crearHisTodos = false;
                    break;
                case 1:
                    var mensaje = { msn: response.data.respuesta, tipo: "alert alert-success" };
                    openRespuesta(mensaje);
                    $scope.crearHisTodos = false;
                    break;
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
            document.location.reload();
        });
    };

    function ObtenerDatosGraficaDesAcumulada() {
        var url;
        if ($scope.Usuario.IdTipoUsuario == 1)
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesAcumulada/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Desarrollo.usuario;
        else
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesAcumulada/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Usuario.UserName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {

            var labelTodo = [];
            var dataTodo = [];

            for (var i = 0; i < response.length; i++) {
                dataTodo.push(response[i].porcentaje);
                labelTodo.push(response[i].Etapa);
            };

            $scope.dataDesTodo = [dataTodo];
            $scope.labelsDesTodo = [$scope.Desarrollo.Nombre1Des, $scope.Desarrollo.Nombre2Des, $scope.Desarrollo.Nombre3Des, $scope.Desarrollo.Nombre4Des, $scope.Desarrollo.Nombre5Des, $scope.Desarrollo.Nombre6Des, $scope.Desarrollo.Nombre7Des, $scope.Desarrollo.Nombre8Des, $scope.Desarrollo.Nombre9Des];
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    function ObtenerDatosGraficaDesDinamica() {
        var url;
        if ($scope.Usuario.IdTipoUsuario == 1)
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesDinamica/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Desarrollo.usuario;
        else
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesDinamica/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Usuario.UserName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {

            var labelDin = [];
            var dataDin = [];

            for (var i = 0; i < response.length; i++) {
                dataDin.push(response[i].porcentaje);
                labelDin.push(response[i].Etapa);
            };

            $scope.dataDesDin = [dataDin];
            $scope.labelsDesDin = [$scope.Desarrollo.Nombre1Des, $scope.Desarrollo.Nombre2Des, $scope.Desarrollo.Nombre3Des, $scope.Desarrollo.Nombre4Des, $scope.Desarrollo.Nombre5Des, $scope.Desarrollo.Nombre6Des, $scope.Desarrollo.Nombre7Des, $scope.Desarrollo.Nombre8Des, $scope.Desarrollo.Nombre9Des];
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    function ObtenerDatosGraficaDesComite() {
        var url;
        if ($scope.Usuario.IdTipoUsuario == 1)
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesComite/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Desarrollo.usuario;
        else
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesComite/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Usuario.UserName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {

            var labelCom = [];
            var dataCom = [];

            for (var i = 0; i < response.length; i++) {
                dataCom.push(response[i].porcentaje);
                labelCom.push(response[i].Etapa);
            };

            $scope.dataDesCom = [dataCom];
            $scope.labelsDesCom = [$scope.Desarrollo.Nombre1Des, $scope.Desarrollo.Nombre2Des, $scope.Desarrollo.Nombre3Des, $scope.Desarrollo.Nombre4Des, $scope.Desarrollo.Nombre5Des, $scope.Desarrollo.Nombre6Des, $scope.Desarrollo.Nombre7Des, $scope.Desarrollo.Nombre8Des, $scope.Desarrollo.Nombre9Des];
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    function ObtenerDatosGraficaDesTerritorial() {
        var url;
        if ($scope.Usuario.IdTipoUsuario == 1)
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesTerritorial/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Desarrollo.usuario;
        else
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesTerritorial/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Usuario.UserName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {

            var dataTerr = [];
            var labelTerr = [];

            for (var i = 0; i < response.length; i++) {
                dataTerr.push(response[i].porcentaje);
                labelTerr.push(response[i].Etapa);
            };

            $scope.dataDesTerr = [dataTerr];
            $scope.labelsDesTerr = [$scope.Desarrollo.Nombre1Des, $scope.Desarrollo.Nombre2Des, $scope.Desarrollo.Nombre3Des, $scope.Desarrollo.Nombre4Des, $scope.Desarrollo.Nombre5Des, $scope.Desarrollo.Nombre6Des, $scope.Desarrollo.Nombre7Des, $scope.Desarrollo.Nombre8Des, $scope.Desarrollo.Nombre9Des];
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    function ObtenerDatosGraficaDesParticipacion() {
        var url;
        if ($scope.Usuario.IdTipoUsuario == 1)
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesParticipacion/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Desarrollo.usuario;
        else
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesParticipacion/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Usuario.UserName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {

            var labelPar = [];
            var dataPar = [];

            for (var i = 0; i < response.length; i++) {
                dataPar.push(response[i].porcentaje);
                labelPar.push(response[i].Etapa);
            };

            $scope.dataDesPar = [dataPar];
            $scope.labelsDesPar = [$scope.Desarrollo.Nombre1Des, $scope.Desarrollo.Nombre2Des, $scope.Desarrollo.Nombre3Des, $scope.Desarrollo.Nombre4Des, $scope.Desarrollo.Nombre5Des, $scope.Desarrollo.Nombre6Des, $scope.Desarrollo.Nombre7Des, $scope.Desarrollo.Nombre8Des, $scope.Desarrollo.Nombre9Des];
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    function ObtenerDatosGraficaDesArticulacion() {
        var url;
        if ($scope.Usuario.IdTipoUsuario == 1)
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesArticulacion/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Desarrollo.usuario;
        else
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesArticulacion/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Usuario.UserName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {

            var labelArt = [];
            var dataArt = [];

            for (var i = 0; i < response.length; i++) {
                dataArt.push(response[i].porcentaje);
                labelArt.push(response[i].Etapa);
            };

            $scope.dataDesArt = [dataArt];
            $scope.labelsDesArt = [$scope.Desarrollo.Nombre1Des, $scope.Desarrollo.Nombre2Des, $scope.Desarrollo.Nombre3Des, $scope.Desarrollo.Nombre4Des, $scope.Desarrollo.Nombre5Des, $scope.Desarrollo.Nombre6Des, $scope.Desarrollo.Nombre7Des, $scope.Desarrollo.Nombre8Des, $scope.Desarrollo.Nombre9Des];
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    function ObtenerDatosGraficaDesRetorno() {
        var url;
        if ($scope.Usuario.IdTipoUsuario == 1)
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesRetorno/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Desarrollo.usuario;
        else
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesRetorno/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Usuario.UserName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {

            var labelRet = [];
            var dataRet = [];

            for (var i = 0; i < response.length; i++) {
                dataRet.push(response[i].porcentaje);
                labelRet.push(response[i].Etapa);
            };

            $scope.dataDesRet = [dataRet];
            $scope.labelsDesRet = [$scope.Desarrollo.Nombre1Des, $scope.Desarrollo.Nombre2Des, $scope.Desarrollo.Nombre3Des, $scope.Desarrollo.Nombre4Des, $scope.Desarrollo.Nombre5Des, $scope.Desarrollo.Nombre6Des, $scope.Desarrollo.Nombre7Des, $scope.Desarrollo.Nombre8Des, $scope.Desarrollo.Nombre9Des];
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    function ObtenerDatosGraficaDesAdecuacion() {
        var url;
        if ($scope.Usuario.IdTipoUsuario == 1)
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesAdecuacion/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Desarrollo.usuario;
        else
            url = '/api/ReAlimentacion/ObtenerDatosGraficaDesAdecuacion/?pIdRetroAdmin=' + $scope.idRetroAdmin + '&pUserName=' + $scope.Usuario.UserName;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {

            var labelAdec = [];
            var dataAdec = [];

            for (var i = 0; i < response.length; i++) {
                dataAdec.push(response[i].porcentaje);
                labelAdec.push(response[i].Etapa);
            };

            $scope.dataDesAdec = [dataAdec];
            $scope.labelsDesAdec = [$scope.Desarrollo.Nombre1Des, $scope.Desarrollo.Nombre2Des, $scope.Desarrollo.Nombre3Des, $scope.Desarrollo.Nombre4Des, $scope.Desarrollo.Nombre5Des, $scope.Desarrollo.Nombre6Des, $scope.Desarrollo.Nombre7Des, $scope.Desarrollo.Nombre8Des, $scope.Desarrollo.Nombre9Des];
        }, function (error) {
            $scope.error = "Se generó un error en la petición de cargue de las Secciones";
        });
    };

    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({

            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    var enviar = mensaje
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function () {
            });
    };

    function cargarReAlimentacion() {
        if ($scope.tipo == 1) {
            cargarDatos($scope.idRetroAdmin);
            if ($scope.Usuario.IdTipoUsuario != 1)
                ObtenerSeriesNivel($scope.idRetroAdmin)
            ObtenerGraficaNivel();
            ObtenerGraficaDesarrollo();
            actualizarGraficaNivel();
            actualizarGraficaDesarrollo();
        }
        else {
            if ($scope.TipoUser != 'AD' && $scope.TipoUser != 'AN')
                $scope.titGen = $scope.Usuario.UserName;
            cargarDatos($scope.idRetroAdmin)
            if ($scope.Usuario.IdTipoUsuario != 1)
                ObtenerSeriesNivel($scope.idRetroAdmin)
            ObtenerGraficaNivel();
            ObtenerGraficaDesarrollo();
            actualizarGraficaDesarrollo();
            actualizarGraficaNivel();
            $scope.graficar7DesXusuario();
            $scope.cargarPreguntas();
            $scope.CargarSeccionesAnalisis(false);
            $scope.cargarPreguntasRevisionXusuario();
            $scope.cargarHistorialXusuario();

        }
    }

}]);