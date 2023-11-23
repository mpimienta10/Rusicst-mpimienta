app.controller('ConsolidadoDiligenciamientoController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService) {
    //------------------- Inicio logica de filtros de la pantalla -------------------
   $scope.filtro = {};
    $scope.started = true;
    $scope.mostrarReporte = false;
    $scope.cargoDatos = true;
    $scope.GobernacionAlcaldias = [];
    $scope.alcaldias = [];
    $scope.columnDefsFijas = [];
    $scope.datosPie = { siGuardo: 0, noGuardo: 0, siCompleto: 0, noCompleto: 0, siEnvio: 0, noEnvio: 0, siGuardoPlan: 0, noGuardoPlan: 0 };
 
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
    function cargarComboEncuesta() {
        var url = '/api/General/Listas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent;
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de combo de encuestas";
        });
    }
    cargarComboDepartamentos();
    cargarComboEncuesta();

    var getDepartamentoYEncuesta = function (departamento, encuesta) {
        var result = { departamento: "", encuesta: "" };
        if (parseInt(departamento) === -1) {
            result.departamento = "Todos";
        }
        else {
            angular.forEach($scope.gobernaciones, function (value, key) {
           
                if (value.IdDepartamento === parseInt(departamento)) {
                    result.departamento = value.Departamento;
                }
            });
        };
        angular.forEach($scope.encuestas, function (value, key) {
            if (value.Id === parseInt(encuesta)) {
                result.encuesta = value.Titulo;
             }
        });
        return result;
    };
  
    $scope.filtrar = function () {
        if (!$scope.validar()) return false;
        $scope.alerta = null;
        $scope.cargoDatos = false;
        getDatos();
    };
    var getDatos = function () {
        $scope.datos = null;
        $scope.alerta = ""
        var url = '/api/Informes/ConsolidadoDiligenciamientoDetalle/';
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (response) {
            $scope.cargoDatos = true;
            if (response.data.length > 0) {
                $scope.datos = response.data;
                $scope.departametoYEncuesta = getDepartamentoYEncuesta($scope.registro.idDepartamento, $scope.registro.idEncuesta);
                $scope.datosFormatados = getDatosFormatados();
                actualizarPie(); 
                $scope.mostrarReporte = true;
            } else {
                $scope.alerta = "No se encontraron datos para los criterios seleccionados"
            }
            

        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    }
    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //------------------------EXPORTAR---------------------------------------

    $scope.exportar = function () {
        $scope.datosFormatados = getDatosFormatados();
        //Obtener Canvas
        var canvas1 = $('#pie1').get(0);
        var canvas2 = $('#pie2').get(0);
        var canvas3 = $('#pie3').get(0);
        var canvas4 = $('#pie4').get(0);
        //Exportar Url 
        $scope.pie1 = canvas1.toDataURL({ format: "png" });
        $scope.pie2 = canvas2.toDataURL({ format: "png" });
        $scope.pie3 = canvas3.toDataURL({ format: "png" });
        $scope.pie4 = canvas4.toDataURL({ format: "png" });
        printJson();
    }
   //----------------------FIN EXPORTAR-------------------------------------
  
    //------------------Inicio Charts Pie------------------------------------
   var actualizarPie = function () {
        $scope.labels1 = ["GUARDÓ INFORMACIÓN: " + $scope.total[2], "NO GUARDÓ INFORMACIÓN: " + $scope.total[3]];
        $scope.data1   = [$scope.total[2], $scope.total[3] ];

        $scope.labels2 = ["COMPLETÓ EL INFORME: " + $scope.total[4], "NO COMPLETÓ EL INFORME: " + $scope.total[5]];
        $scope.data2 = [$scope.total[4], $scope.total[5]];

        $scope.labels3 = ["ENVIÓ EL REPORTE: " + $scope.total[6], "NO ENVIÓ EL REPORTE: " + $scope.total[7]];
        $scope.data3 = [$scope.total[6], $scope.total[7]];

        $scope.labels4 = ["GUARDÓ INFO. EN EL \n PLAN DE MEJORAMIENTO" + $scope.total[8], "NO GUARDÓ INFO. EN EL PLAN DE MEJORAMIENTO: " + $scope.total[9]];
        $scope.data4 = [$scope.total[8], $scope.total[9]];

        $scope.options = {
            legend: {
                fullWidth: true,
                display: true,
                labels: {
                    fontColor: 'black',
                    fontSize: 11
                }
            }
        };

        $scope.colores = ['#FAAC58', '#008080'];
   }

   $scope.header = [
       { text: 'DEPARTAMENTO', style: 'tableHeader' },
       { text: 'MUNICIPIOS', style: 'tableHeader' },
       { text: 'GUARDARON INFORMACIÓN', style: 'tableHeader' },
       { text: 'NO GUARDÓ INFORMACIÓN COMPLETÓ EL REPORTE', style: 'tableHeader' },
       { text: 'COMPLETÓ EL REPORTE', style: 'tableHeader' },
       { text: 'NO COMPLETÓ EL REPORTE', style: 'tableHeader' },
       { text: 'GUARDÓ INFORMACION EN EL PLAN DE MEJORAMIENTO', style: 'tableHeader' },
       { text: 'NO GUARDÓ INFORMACION EN EL PLAN DE MEJORAMIENTO', style: 'tableHeader' },
       { text: 'ENVIÓ EL REPORTE', style: 'tableHeader' },
       { text: 'NO ENVIÓ EL REPORTE', style: 'tableHeader' }       
   ];

   var getDatosFormatados = function () {

       var body = [$scope.header];
       var fila = [];
       $scope.total = ['Total', 0, 0, 0, 0, 0, 0, 0, 0, 0];
       angular.forEach($scope.datos, function (value, key) {

           for (propiedad in value) {
               if (value[propiedad] === null) value[propiedad] = '0';
           }
           fila = [value.DEPARTAMENTO, value.MUNICIPIOS, value.SI_GUARDO, value.NO_GUARDO, value.SI_COM_REP, value.NO_COM_REP, value.SI_ENVIARON, value.NO_ENVIARON, value.SI_INFO_PLAN, value.NO_INFO_PLAN];

           for (i = 1; i < fila.length; i++) {
               $scope.total[i] += parseInt(fila[i]);
           }
           body.push(fila);
       });
       //obtener totales para reporte en PDF - solo acepta string
       var totalJson = { text: "", style: 'tableFooter' };
       $scope.total_ParaReportePDF = [{ text: 'Total', style: 'tableFooter'}]
       for (i = 1; i < fila.length; i++) {
           var totalCopia = angular.copy(totalJson);
           totalCopia.text = $scope.total[i].toString();
           $scope.total_ParaReportePDF.push(totalCopia);
       }

       body.push($scope.total_ParaReportePDF);
       return body;
   }

    //------------------PDFMAKE----------------------------------------------
   var getLayoutHeader = function () {
       return {
           hLineWidth: function () {
               return 0.5;
           },
           vLineWidth: function () {
               return 0;
           },
           hLineColor: function () {
               return 'white';
           },
           vLineColor: function () {
               return 'white';
           }
       };
   };

    var getLayout = function () {
        return {
            hLineWidth: function () {
                return 1;
            },
            vLineWidth: function () {
                return 0;
            },
            hLineColor: function () {
                return '#BDBDBD';
            },
            vLineColor: function () {
                return 'white';
            }
        };
    };

    var getLayoutImages = function () {
        return {
            hLineWidth: function () {
                return 0.1;
            },
            vLineWidth: function () {
                return 0.1;
            },
            hLineColor: function () {
                return 'white';
            },
            vLineColor: function () {
                return 'white';
            }
        };
    };


    //// Variables
    var widthImages = 150;
    var heigthImages = 150;
    var fillColor = 'maroon';
    var printJson = function () {
        $scope.definiciones = UtilsService.getDefinicionesReportesEjecutivos();
        var docDefinition = {
            compress: false,
            pageMargins: [50, 170, 50, 50],
            layout: 'headerLineOnly',
            pageSize: 'A4',
            header: function () {
                var header = [
                    $scope.definiciones.logosEncabezado,
                    {
                        style: 'tableHeader1',
                        table: {
                            widths: ['*'],
                            body: [
                                [{ text: 'CONSOLIDADO DEL DILIGENCIAMIENTO DEL RUSICST', fillColor: fillColor }],
                                [{ text: $scope.departametoYEncuesta.encuesta, fillColor: fillColor, style: 'tableHeader2' }],
                                [{ text: 'REPORTE UNIFICADO DEL SISTEMA DE INFORMACIÓN, COORDINACIÓN Y SEGUIMIENTO TERRITORIAL DE LA POLÍTICA PÚBLICA DE VÍCTIMAS - RUSICST', fillColor: fillColor, style: 'tableHeader3' }],

                            ]
                        }, layout: getLayoutHeader()
                    },
                    {
                        text: 'A continuación encontrará los datos cuantitativos sobre el nivel de reporte en el RUSICST de los municipios de su jurisdicción, durante el periodo seleccionado. \n\n',
                        alignment: 'center',
                        fontSize: 6,
                    },
                    {
                        margin: [150, 0, 150, 0],
                        fontSize: 9,
                        alignment: 'center',
                        table: {
                            widths: ['*', '*'],
                            body: [
                                [{ text: 'DEPARTAMENTO', fillColor: fillColor, color: '#FFF5BA', }, { text: $scope.departametoYEncuesta.departamento }],
                            ]
                        }, layout: getLayout()
                    },
                ];
              
                return header;
            },

            footer: function (currentPage, pageCount) {
                return {
                    stack: [
                        {
                            fontSize: 7,
                            columns: [
                            {},
                            { text: currentPage.toString(), alignment: 'center' },
                            { text: "Fecha de generación: " + new Date().toLocaleString(), alignment: 'right', margin: [0, 0, 50, 0] }
                        ]
                    }]

                };
            },
            content: [
                {
                    text: '\n',
                    fontSize: 6,
                },
                {
                    alignment: 'center',
                    fontSize: 7,
                     table: {
                        widths: ['*', '*'],
                        body: [
                            [{ text: 'GUARDÓ INFORMACIÓN',  }, { text: 'COMPLETÓ REPORTE' }],
                            [{ image: $scope.pie1, width: widthImages, height: heigthImages }, { image: $scope.pie2, width: widthImages, height: heigthImages }],
                            [{ text: 'ENVIÓ EL REPORTE' }, { text: 'GUARDÓ INFORMACIÓN EN EL PLAN DE MEJORAMIENTO' }],
                            [{ image: $scope.pie3, width: widthImages, height: heigthImages }, { image: $scope.pie4, width: widthImages, height: heigthImages }],
                        ]
                    }, layout: getLayoutImages()
                },
                {
                    style: 'tableBody',
                    table: {
                        headerRows: 1,
                        body: 
                        $scope.datosFormatados
                    },
                    layout: getLayout()
                },
            ],
            styles: {
                'tableHeader': {
                    fontSize: 6,
                    fillColor: fillColor,
                    color: 'white',
                    alignment: 'center',
                },
                'tableBody': {
                    fontSize: 6,
                    fillColor: fillColor,
                    alignment: 'center',
                },
                'tableHeader1': {
                    bold: true,
                    fontSize: 10,
                    color: '#FFF5BA',
                    alignment: 'center',
                    margin: [50, 0, 50, 0]
                },
                'tableHeader2': {
                    bold: true,
                    fontSize: 9,
                    color: 'white',
                    alignment: 'center',
                },
                'tableHeader3': {
                    fontSize: 7,
                    color: 'white',
                    alignment: 'center',
                },
                'image': {
                    width: 150,
                    height: 150,
                },
                'tableFooter': {
                    fillColor: '#D2D2D2',
                    color: 'black',
                    alignment: 'center',
                    bold: true
                }
            }
        }
        
        var date = new Date();
        //pdfMake.createPdf(docDefinition).open('PDF_.pdf');
        pdfMake.createPdf(docDefinition).download("ConsolidadoDiligenciamientoRusicst.pdf");

    };    
}]);
