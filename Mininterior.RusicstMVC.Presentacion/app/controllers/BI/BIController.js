app.controller('BIController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', 'enviarDatos', 'uiGridGroupingConstants', '$log', '$uibModal', '$templateCache', '$location', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, enviarDatos, uiGridGroupingConstants, $log, $uibModal, $templateCache, $location) {
    //===== Declaración de Variables ======================
    var url = '';
    var exportar;
    var codPreguntas = "";
    var idConsultaPredefinida = "";
    $scope.consultaPredefinidas = [];
    $scope.filasSeleccionadas = [];
    $scope.datosSeleccionados = {};
    $scope.gridUbicacionFiltroOptions = {data: []};
    $scope.isGrid = false;
    $scope.gridOptions = {
        columnDefs: [],
        paginationPageSizes: [25, 50],
        paginationPageSize: 25,
        multiSelect: true,
        onRegisterApi: function (gridApi) {
            
            $scope.gridApi1 = gridApi;
            //gridApi.grid.options.enableFiltering = false; 
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
            gridApi.selection.on.rowSelectionChanged($scope, function (row) {
                var msg = 'row selected ' + row.isSelected;
                $scope.filasSeleccionadas.push(row.entity);
                $log.log($scope.filasSeleccionadas);
            });
            gridApi.selection.on.rowSelectionChangedBatch($scope, function (rows) {
                var msg = 'rows changed ' + rows.length;
                $log.log(msg);
            });

            //$scope.gridApi.selection.multiSelect = false;
        },
    };

    $scope.$watchGroup(['gridOptions.totalItems', 'gridOptions.paginationCurrentPage'], function (newValue, oldValue) {
        if (newValue || oldValue) { UtilsService.autoajustarAltura($scope.gridOptions.totalItems, $scope.gridOptions.paginationCurrentPage, $scope.gridOptions.paginationPageSize, 'grid'); }
    });


    $scope.consultaPredifinida = {
        expandido : false
    }
    $scope.dimensiones = 
        {
            label: "Dimensión",
            valor: false,
            expandido: false,
            segundoNivel: [
                {
                    label: "Encuestas",
                    valor: false,
                    expandido: false,
                    tercerNivel: [
                        {
                            label: "Código de Encuesta",
                            valor: false,
                            expandido: false,
                            control: 'cbCodigoEncuesta'
                        },
                        {
                            label: "Nombre de Encuesta",
                            valor: false,
                            expandido: false,
                            control: 'cbNombreEncuesta'
                        }
                    ]
                },
                {
                    label: "Preguntas",
                    valor: false,
                    expandido: false,
                    tercerNivel: [
                        {
                            label: "Código de Pregunta",
                            valor: false,
                            expandido: false,
                            control: 'cbCodigoPregunta'
                        },
                        {
                            label: "Nombre de Pregunta",
                            valor: false,
                            expandido: false,
                            control: 'cbNombreEncuesta'
                        }
                    ]
                },
                {
                    label: "Departamentos",
                    valor: false,
                    expandido: false,
                    tercerNivel: [
                        {
                            label: "Código de Departamento",
                            valor: false,
                            expandido: false,
                            control: 'cbCodigoDepartamento'
                        },
                        {
                            label: "Nombre de Departamento",
                            valor: false,
                            expandido: false,
                            control: 'cbCodigoDepartamento'
                        }
                    ]
                },
                {
                    label: "Municipios",
                    valor: false,
                    expandido: false,
                    tercerNivel: [
                        {
                            label: "Código de Municipio",
                            valor: false,
                            expandido: false,
                            control: 'cbCodigoMunicipio'
                        },
                        {
                            label: "Nombre de Municipio",
                            valor: false,
                            expandido: false,
                            control: 'cbNombreMunicipio'
                        }
                    ]
                },
                {
                    label: "Otros",
                    valor: false,
                    expandido: false,
                    tercerNivel: [
                        {
                            label: "Etapa Política",
                            valor: false,
                            expandido: false,
                            control: 'cbEtapaPolitica'
                        },
                        {
                            label: "Sección",
                            valor: false,
                            expandido: false,
                            control: 'cbSeccion'
                        },
                        {
                            label: "Tema",
                            valor: false,
                            expandido: false,
                            control: 'cbTema'
                        },
                        {
                            label: "Hecho Victimizante",
                            valor: false,
                            expandido: false,
                            control: 'cbHechoVictimizante'
                        },
                        {
                            label: "Dinámica de Desplazamiento",
                            valor: false,
                            expandido: false,
                            control: 'cbDinamicaDesplazamiento'
                        },
                        {
                            label: "Enfoque Diferencial",
                            valor: false,
                            expandido: false,
                            control: 'cbEnfoqueDiferencial'
                        },
                        {
                            label: "Factores de Riesgo",
                            valor: false,
                            expandido: false,
                            control: 'cbFactoresriesgo'
                        },
                        {
                            label: "Rango Etareo",
                            valor: false,
                            expandido: false,
                            control: 'cbRangoEtareo'
                        }
                    ]
                },

            ]

        },
    $scope.hechos = {
        label: "Hechos",
        valor: false,
        expandido: false,
        segundoNivel: [
            {
                label: "Tipos de Respuesta",
                valor: false,
                expandido: false,
                tercerNivel: [
                    {
                        label: "Moneda",
                        valor: false,
                        expandido: false,
                    },
                    {
                        label: "Número",
                        valor: false,
                        expandido: false,
                    },
                    {
                        label: "Porcentaje",
                        valor: false,
                        expandido: false,
                    },
                    {
                        label: "Respuesta Única",
                        valor: false,
                        expandido: false,
                    },
                ]
            }
        ]
        }
    $scope.hechoSeleccionado = "";

    //=================== Actualizar Opciones ==========================================
    $scope.actualizarOption = function (opcion) {
         ;
        $scope.hechoSeleccionado = opcion.label;
        $scope.hechos.valor = true;
        $scope.hechos.segundoNivel[0].valor = true;
        $scope.datosSeleccionados.hechos = $scope.hechoSeleccionado;
    };

    $scope.actualizarCheck = function (opcion) {
        ;
        if (!opcion.valor) {
            $scope.hechoSeleccionado = "";
            var optionRefresh = $('#opcionRefresh').html();
        }
    }

    // ===========Obtener Nombres de Filtros Seleccionados ==============================
    $scope.obtenerNombreFiltros = function(idEncuesta, idDepartamento, idMunicipio){
         ;
        if (idEncuesta != null) {
            angular.forEach($scope.encuestas, function (encuesta) {
                if (encuesta.CodigoEncuesta === idEncuesta) {
                    $scope.datosSeleccionados.encuesta = 'encuesta: ' + encuesta.NombreEncuesta + ', ';
                }
            })
        }
        if (idDepartamento != null) {
            angular.forEach($scope.gobernaciones, function (departamento) {
                if (departamento.CodigoDepartamento === idDepartamento) {
                    $scope.datosSeleccionados.departamento = 'departamento: ' + departamento.NombreDepartamento + ', ';
                }
            })
        }
        if (idMunicipio != null) {
            if (idDepartamento !== null) {
                $scope.registro.idDepartamento = idDepartamento;
            }
            $scope.cargarComboMunicipios(idMunicipio)
        }
    };

    //======== Consulta predefinida =====================================================
    $scope.consultarPredefinida = function () {
        if ($scope.consultaPredifinida.expandido) {
            $scope.datosConsultaPredefinidas = {};
            getConsultarPredefinida(url)
            function getConsultarPredefinida() {
                url = 'adomdConnector.svc/ObtenerListadoConsultaPredefinida';
                var servCall = APIService.getMetodoBI(url);
                servCall.then(function (datos) {
                     
                    if ($scope.consultaPredefinidas.length === 0) {
                        $scope.datosConsultaPredefinidas = datos.ObtenerListadoConsultaPredefinidaResult[1];
                        $scope.consultaPredefinidas = JSON.parse($scope.datosConsultaPredefinidas)
                        $scope.totalItemsPredefinidas = $scope.consultaPredefinidas.length;
                        $scope.currentPagePredefinidas = 1;
                        $scope.itemsPerPagePredefinidas = 5;
                        $scope.maxSizePredefinidas = 5;
                    }
                 
                }, function (error) {
                });
            };
        }
    };

    $scope.consultarSeleccionada = function (item) {
        var datos;
        $scope.datosSeleccionados.consultaPredifinida = item.Nombre;
        limpiarDato();
        idConsultaPredefinida = item.IdConsultaPredefinida;
        angular.forEach($scope.consultaPredefinidas, function (fila) {
           fila.seleccionada = false;
        })
        angular.forEach($scope.consultaPredefinidas, function (fila) {
            if (fila.IdConsultaPredefinida === idConsultaPredefinida) {
                fila.seleccionada = true;
            }
        })
        var url = 'AdomdConnector.svc/ObtenerInformacionConsultaPredefinida?idConsultaPredefinida=' + idConsultaPredefinida;
        var servCall = APIService.getMetodoBI(url);
        servCall.then(function (response) {
            
            datos = response.ObtenerInformacionConsultaPredefinidaResult;
            $scope.registro.idEncuesta = datos[3].toString().replace("codigoEncuesta =", "");
            $scope.registro.idDepartamento = datos[4].toString().replace("codigoDepartamento =", "");
            $scope.registro.idMunicipio = datos[5].toString().replace("codigoMunicipio =", "");
            $scope.obtenerNombreFiltros( $scope.registro.idEncuesta, $scope.registro.idDepartamento,  $scope.registro.idMunicipio );
            codPreguntas = datos[2].toString().replace("codigoPreguntas =", "");
            cargarComboMunicipioXPre($scope.registro.idMunicipio);
            
            var NombreConsultaPredefinida = datos[0].replace("nombre =", "");
            var DescripcionConsultaPredefinida = datos[1].replace("descripcion =", "");

            var url1 = 'AdomdConnector.svc/ObtenerControlesDimensionesConsultaPredefinida?idConsulaPredefinida=' + idConsultaPredefinida;
            var servCall1 = APIService.getMetodoBI(url1);
            servCall1.then(function (response) {
                ;
                if (response.ObtenerControlesDimensionesConsultaPredefinidaResult === "No existen registros para esta consulta.") {
                    alert("No existen dimensiones cargadas para esta consulta predefinida.");
                } else {
                    $scope.ubicacion = JSON.parse(response.ObtenerControlesDimensionesConsultaPredefinidaResult);
                    pintarDimensiones($scope.ubicacion);
                    PintarUbicacionFiltro();
                }
            }, function (error) {
                console.log('Se generó un error en la petición')
                $scope.error = "Se generó un error en la petición";
            });

            //-------------Función pintar dimensiones
            pintarDimensiones = function (ubicacion) {
                if (ubicacion.length > 0) {
                    angular.forEach(ubicacion, function (ubi, key) {
                        switch (ubi.Control) {
                            case "cbCodigoEncuesta":
                                $scope.dimensiones.segundoNivel[0].tercerNivel[0].valor = true;
                                break;
                            case "cbNombreEncuesta":
                                $scope.dimensiones.segundoNivel[0].tercerNivel[1].valor = true;
                                break;
                            case "cbCodigoPregunta":
                                $scope.dimensiones.segundoNivel[1].tercerNivel[0].valor = true;
                                break;
                            case "cbNombrePregunta":
                                $scope.dimensiones.segundoNivel[1].tercerNivel[1].valor = true;
                                break;
                            case "cbNombreDepartamento":
                                $scope.dimensiones.segundoNivel[2].tercerNivel[0].valor = true;
                                break;
                            case "cbNombreDepartamento":
                                $scope.dimensiones.segundoNivel[2].tercerNivel[1].valor = true;
                                break;
                            case "cbCodigoMunicipio":
                                $scope.dimensiones.segundoNivel[3].tercerNivel[0].valor = true;
                                break;
                            case "cbNombreMunicipio":
                                $scope.dimensiones.segundoNivel[3].tercerNivel[1].valor = true;
                                break;
                            case "cbEtapaPolitica":
                                $scope.dimensiones.segundoNivel[4].tercerNivel[0].valor = true;
                                break;
                            case "cbSeccion":
                                $scope.dimensiones.segundoNivel[4].tercerNivel[1].valor = true;
                                break;
                            case "cbTema":
                                $scope.dimensiones.segundoNivel[4].tercerNivel[2].valor = true;
                                break;
                            case "cbHechoVictimizante":
                                $scope.dimensiones.segundoNivel[4].tercerNivel[3].valor = true;
                                break;
                            case "cbDinamicaDesplazamiento":
                                $scope.dimensiones.segundoNivel[4].tercerNivel[4].valor = true;
                                break;
                            case "cbEnfoqueDiferencial":
                                $scope.dimensiones.segundoNivel[4].tercerNivel[5].valor = true;
                                break;
                            case "cbFactoresRiesgo":
                                $scope.dimensiones.segundoNivel[4].tercerNivel[6].valor = true;
                                break;
                            case "cbRangoEtareo":
                                $scope.dimensiones.segundoNivel[4].tercerNivel[7].valor = true;
                                break;
                            default:
                                break;
                        }
                    });
                 obtenerDatosSeleccionados();
                }
            }
            var hechos;
            var urlh = 'AdomdConnector.svc/ObtenerControlesHechosConsultaPredefinida?idConsulaPredefinida=' + idConsultaPredefinida;
            var servCallh = APIService.getMetodoBI(urlh);
            servCallh.then(function (response) {
                hechos = JSON.parse(response.ObtenerControlesHechosConsultaPredefinidaResult); 
                if (hechos.length > 0) {
                    switch (hechos[0].Control) {
                        case "cbMoneda":
                            $scope.hechoSeleccionado = 'Moneda';
                            break;
                        case "cbNumero":
                            $scope.hechoSeleccionado = 'Número';
                            break;
                        case "cbPorcentaje":
                            $scope.hechoSeleccionado = 'Porcentaje';
                            break;
                        case "cbRespuesta":
                            $scope.hechoSeleccionado = 'Respuesta Única';
                            break;
                        default:
                            break;
                    };
                    $scope.hechos.segundoNivel[0].valor = true;
                    $scope.hechos.valor = true;
                    $scope.datosSeleccionados.hechos = $scope.hechoSeleccionado;
                }
            }, function (error) {
                console.log('Se generó un error en la petición')
                $scope.error = "Se generó un error en la petición";
            });

            var urlp = 'AdomdConnector.svc/ObtenerPreguntasPorConsultaPredefinidaJSON?idConsultaPredefinida=' + idConsultaPredefinida;
            var servCallp = APIService.getMetodoBI(urlp);
            servCallp.then(function (response) {
                $scope.preguntasSeleccionadas = JSON.parse(response.ObtenerPreguntasPorConsultaPredefinidaJSONResult);
                PintarPreguntsFiltro();
            }, function (error) {
                console.log('Se generó un error en la petición')
                $scope.error = "Se generó un error en la petición";
            });

        }, function (error) {
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición";
            });
    }


    //=====Cargar Combos de Encuestas, Departamento y Municipio===========================
    $scope.cargoDatos = true;
    $scope.GobernacionAlcaldias = [];
    $scope.alcaldias = [];
    $scope.registro = {};

    function cargarComboDepartamentos(idDepartamento) {
        var url = 'AdomdConnector.svc/ObtenerDepartamentosJSON';
        var servCall = APIService.getMetodoBI(url);
        servCall.then(function (response) {
            $scope.gobernaciones = JSON.parse(response.ObtenerDepartamentosJSONResult);
            $scope.registro.idDepartamento = $scope.gobernaciones[0].CodigoDepartamento;
        }, function (error) {
            console.log('Se generó un error en la petición')
            $scope.error = "Se generó un error en la petición";
        });
    }
    $scope.cargarComboMunicipios = function (idMunicipio) {
        $scope.alcaldias = [];
        $scope.obtenerNombreFiltros(null, $scope.registro.idDepartamento, null)
        $scope.datosSeleccionados.municipio = "";
        if ($scope.registro.idDepartamento == 0) {
            $scope.alerta = "Debe seleccionar una Gobernación o un Departamento.";
        }
        else {
            var url = 'AdomdConnector.svc/ObtenerMunicipiosJSON?codigoDepartamento=' + $scope.registro.idDepartamento;
            var servCall = APIService.getMetodoBI(url);
            servCall.then(function (response) {
                $scope.alcaldias = JSON.parse(response.ObtenerMunicipiosJSONResult);
                //$scope.registro.idMunicipio = $scope.alcaldias[0].CodigoMunicipio;
                $scope.alcaldias.shift();  
                angular.forEach( $scope.alcaldias, function(municipio){
                if(municipio.CodigoMunicipio === idMunicipio){
                    $scope.datosSeleccionados.municipio = 'departamento: ' + municipio.NombreMunicipio;
                    $scope.registro.idMunicipio = idMunicipio;
                };
            });
            }, function (error) {
                console.log('Se generó un error en la petición')
                $scope.error = "Se generó un error en la petición";
            });
        }
    }

    function cargarComboMunicipioXPre(IdMunicipio) {
        $scope.alcaldias = [];
        if ($scope.registro.idDepartamento == 0) {
            $scope.alerta = "Debe seleccionar una Gobernación o un Departamento.";
        }
        else {
            var url = 'AdomdConnector.svc/ObtenerMunicipiosJSON?codigoDepartamento=' + $scope.registro.idDepartamento;
            var servCall = APIService.getMetodoBI(url);
            servCall.then(function (response) {
                $scope.alcaldias = JSON.parse(response.ObtenerMunicipiosJSONResult);
                $scope.registro.idMunicipio = IdMunicipio;
            }, function (error) {
                console.log('Se generó un error en la petición')
                $scope.error = "Se generó un error en la petición";
            });
        }
    }

    function cargarComboEncuesta() {
        var url = 'AdomdConnector.svc/ObtenerEncuestasJSON';
        var servCall = APIService.getMetodoBI(url);
        servCall.then(function (response) {
             ;
            $scope.encuestas = JSON.parse(response.ObtenerEncuestasJSONResult);
            $scope.registro.idEncuesta = $scope.encuestas[0].CodigoEncuesta;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de combo de encuestas";
        });
    }
    cargarComboDepartamentos();
    cargarComboEncuesta();
    
    //======== Preguntas =====================================================
    function consultarPreguntas () {
        $scope.totalItemsPreguntas = $scope.preguntas.length;
        $scope.currentPagePreguntas = 1;
        $scope.itemsPerPagePreguntas = 10;
        $scope.maxSizePreguntas = 10; //Number of pager buttons to show
    }

    $scope.consultarPreguntasXCodigo = function () {
        $scope.preguntas = [];
        var url = 'AdomdConnector.svc/ObtenerPreguntasPorCodigoJSON?codigoEncuesta=' + $scope.registro.idEncuesta + '&codigoPregunta=' + $scope.registro.pregunta;
        var servCall = APIService.getMetodoBI(url);
        servCall.then(function (response) {
            $scope.preguntas = JSON.parse(response.ObtenerPreguntasPorCodigoJSONResult);
            consultarPreguntas();
        }, function (error) {
            $scope.error = "Se generó un error en la petición de preguntas por codigo";
        });
    }

    $scope.consultarPreguntasXNombre = function () {
        $scope.preguntas = [];
        var url = 'AdomdConnector.svc/ObtenerPreguntasPorNombreJSON?codigoEncuesta=' + $scope.registro.idEncuesta + '&nombrePregunta=' + $scope.registro.pregunta;
        var servCall = APIService.getMetodoBI(url);
        servCall.then(function (response) {
            ;
            $scope.preguntas = JSON.parse(response.ObtenerPreguntasPorNombreJSONResult);
            consultarPreguntas();
        }, function (error) {
            $scope.error = "Se generó un error en la petición de preguntas por nombre";
        });
    }

    $scope.seleccionarPreguntas = function () {
        $scope.preguntasSeleccionadas = [];
        angular.forEach($scope.preguntas, function (registro) {
            if (registro.IsCheck)
            {
                $scope.preguntasSeleccionadas.push(registro);
            }
        })
        PintarPreguntsFiltro();
    }

    function PintarPreguntsFiltro() {
         ;
        $scope.gridPreguntasFiltroOptions = { };
        $scope.gridPreguntasFiltroOptions.data = $scope.preguntasSeleccionadas;
    }

    function PintarUbicacionFiltro() {
        $scope.gridUbicacionFiltroOptions = { };
        $scope.gridUbicacionFiltroOptions.data = $scope.ubicacion;
    }

    //================Funciones de los Checkbox====================================
    $scope.checkboxClick = function (index, $event, array , nivel, item) {
        $event.stopPropagation();
           //Se selecciona el array
        var label = item.label;
            var arrayRecorrer = [];
            switch (array) {
                case 'dimensiones':
                    arrayRecorrer = $scope.dimensiones;
                    break;
                case 'hechos':
                    arrayRecorrer = $scope.hechos;
                    break
                default:
                    break;
            }

            //Se selecciona el nivel
            switch (nivel) {
                case 'primerNivel':
                    recorrerSegundoNivel();
                    break;
                case 'segundoNivel':
                    recorrerTercerNivel(arrayRecorrer.segundoNivel[index].valor, index);
                    validarSegundoNivel()
                    break;
                case 'tercerNivel':
                    validarTercerNivel();
                    validarSegundoNivel();
                    break;
                default:
                    break;

            }

            obtenerDatosSeleccionados();
        
            function recorrerSegundoNivel() {
                angular.forEach(arrayRecorrer.segundoNivel, function (registro, key) {
                    registro.valor = arrayRecorrer.valor;
                    recorrerTercerNivel(registro.valor, key);
                })
            }

            function recorrerTercerNivel(valorSegundoNivel, indexSegundoNivel) {
                angular.forEach(arrayRecorrer.segundoNivel[indexSegundoNivel].tercerNivel, function (registro) {
                    registro.valor = valorSegundoNivel;
                })
            }

            function validarSegundoNivel() {
                var valSegundoNivel = true;
                angular.forEach(arrayRecorrer.segundoNivel, function (registro) {
                    if (registro.valor === false) {
                        valSegundoNivel = false;
                    }
                });
                arrayRecorrer.valor = valSegundoNivel;
            }

            function validarTercerNivel() {
                var indexSegundoNivel2;
                var valTercerNivel = true;
                angular.forEach(arrayRecorrer.segundoNivel, function (registro, key) {
                    angular.forEach(registro.tercerNivel, function (registro2,key2) {
                        if (registro2.label === label) {
                            indexSegundoNivel2 = key;
                        }
                    })
                });
                angular.forEach(arrayRecorrer.segundoNivel[indexSegundoNivel2].tercerNivel, function (registro) {
                    if (registro.valor === false) {
                        valTercerNivel = false;
                    }
                })
                arrayRecorrer.segundoNivel[indexSegundoNivel2].valor = valTercerNivel;
            }
    }

    function obtenerDatosSeleccionados(){
        $scope.datosSeleccionados.dimensiones = '';
        $scope.gridUbicacionFiltroOptions.data = [];
        angular.forEach($scope.dimensiones.segundoNivel, function(segundoNivel){
            angular.forEach(segundoNivel.tercerNivel, function(tercerNivel){
                if (tercerNivel.valor === true) {
                    var existeUbicacion = true;
                    $scope.datosSeleccionados.dimensiones += tercerNivel.label + ', ';
                    if (existeUbicacion) {
                        $scope.gridUbicacionFiltroOptions.data.push(
                            {
                                Control: tercerNivel.control,
                                Nombre: tercerNivel.label,
                                Ubicacion: 'Columnas'
                            }
                        );
                    }
                }
            })
        })
        var longDimensiones = $scope.datosSeleccionados.dimensiones.length;
         $scope.datosSeleccionados.dimensiones =   $scope.datosSeleccionados.dimensiones.substr(0, longDimensiones - 2);
    }
    //=============== Generar Datos ==========================================================
    $scope.generarDatos = function () {
        var dimensionesFilas = false;
        var codEncuesta = false, codEncuestaFila = true;
        var nomEncuesta = false, nomEncuestaFila = true;
        var codPregunta = false, codPreguntaFila = true;
        var nomPregunta = false, nomPreguntaFila = true;
        var codDepartamento = false, codDepartamentoFila = true;
        var nomDepartamento = false, nomDepartamentoFila = true;
        var codMunicipio = false, codMunicipioFila = true;
        var nomMunicipio = false, nomMunicipioFila = true;
        var etaPolitica = false, etaPoliticaFila = true;
        var sec = false, secFila = true;
        var tem = false, temFila = true;
        var hechoVicti = false, hechoVictiFila = true;
        var dinamicaDespla = false, dinamicaDesplazaFila = true;
        var enfoqueDifer = false, enfoqueDiferFila = true;
        var factorRiesgo = false, factorRiesgoFila = true;
        var ranEtareo = false, ranEtareoFila = true;
        var moneda = false, monedaFila = false;
        var numero = false, numeroFila = false;
        var porcentaje = false, porcentajeFila = false;
        var respuestaUnica = false, respuestaUnicaFila = false;

        var contDimensiones = 0;
        $scope.filasSeleccionadas = [];
        angular.forEach($scope.dimensiones.segundoNivel, function (segundoNivel, key) {
            if (segundoNivel.valor == true)
                contDimensiones++;
            angular.forEach(segundoNivel.tercerNivel, function (tercerNivel) {
                if (tercerNivel.valor == true)
                    contDimensiones++;
            })
        })

        if (contDimensiones > 0)//
        {

        angular.forEach($scope.gridUbicacionFiltroOptions.data, function (ubicacion) {
            switch (ubicacion.Control) {
                case "cbCodigoEncuesta":
                    codEncuesta = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        codEncuestaFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbNombreEncuesta":
                    nomEncuesta = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        nomEncuestaFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbCodigoPregunta":
                    codPregunta = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        codPreguntaFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbNombrePregunta":
                    nomPregunta = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        nomPreguntaFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbCodigoDepartamento":
                    codDepartamento = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        codDepartamentoFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbNombreDepartamento":
                    nomDepartamento = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        nomDepartamentoFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbCodigoMunicipio":
                    codMunicipio = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        codMunicipioFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbNombreMunicipio":
                    nomMunicipio = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        nomMunicipioFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbEtapaPolitica":
                    etaPolitica = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        etaPoliticaFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbSeccion":
                    sec = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        secFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbTema":
                    tem = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        temFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbHechoVictimizante":
                    hechoVicti = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        hechoVictiFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbDinamicaDesplazamiento":
                    dinamicaDespla = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        dinamicaDesplazaFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbEnfoqueDiferencial":
                    enfoqueDifer = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        enfoqueDiferFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbFactoresRiesgo":
                    factorRiesgo = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        factorRiesgoFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "cbRangoEtareo":
                    ranEtareo = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        ranEtareoFila = false;
                    else
                        dimensionesFilas = true;
                    break;
            }
        });

        if ($scope.gridUbicacionFiltroOptions.data.length == 0)
            dimensionesFilas = true;
       
        //Se organizan los hechos
            
        angular.forEach($scope.gridUbicacionFiltroOptions.data, function (ubicacion) {
            switch ($scope.hechoSeleccionado) {
                case "Moneda":
                    moneda = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        monedaFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "Número":
                    numero = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        numeroFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "Porcentaje":
                    porcentaje = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        porcentajeFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                case "Respuesta Única":
                    respuestaUnica = true;
                    if (ubicacion.Ubicacion == "Columnas")
                        respuestaUnicaFila = false;
                    else
                        dimensionesFilas = true;
                    break;
                default:
                    break;

            };
          
        });

        if (dimensionesFilas == false)
            alert("Al menos una dimensión debe estar en Filas");
        else {
            model = {
                codigoEncuesta: codEncuesta,
                codigoEncuestaFila: codEncuestaFila,
                nombreEncuesta: nomEncuesta,
                nombreEncuestaFila: nomEncuestaFila,
                codigoPregunta: codPregunta,
                codigoPreguntaFila: codPreguntaFila,
                nombrePregunta: nomPregunta,
                nombrePreguntaFila: nomPreguntaFila,
                codigoDepartamento: codDepartamento,
                codigoDepartamentoFila: codDepartamentoFila,
                nombreDepartamento: nomDepartamento,
                nombreDepartamentoFila: nomDepartamentoFila,
                codigoMunicipio: codMunicipio,
                codigoMunicipioFila: codMunicipioFila,
                nombreMunicipio: nomMunicipio,
                nombreMunicipioFila: nomMunicipioFila,
                etapaPolitica: etaPolitica,
                etapaPoliticaFila: etaPoliticaFila,
                seccion: sec,
                seccionFila: secFila,
                tema: tem,
                temaFila: temFila,
                hechoVictimizante: hechoVicti,
                hechoVictimizanteFila: hechoVictiFila,
                dinamicaDesplazamiento: dinamicaDespla,
                dinamicaDesplazamientoFila: dinamicaDesplazaFila,
                enfoqueDiferencial: enfoqueDifer,
                enfoqueDiferencialFila: enfoqueDiferFila,
                factoresRiesgo: factorRiesgo,
                factoresRiesgoFila: factorRiesgoFila,
                rangoEtareo: ranEtareo,
                rangoEtareoFila: ranEtareoFila,
                moneda: moneda,
                monedaFila: monedaFila,
                numero: numero,
                numeroFila: numeroFila,
                porcentaje: porcentaje,
                porcentajeFila: porcentajeFila,
                respuestaUnica: respuestaUnica,
                respuestaUnicaFila: respuestaUnicaFila,
                filtroencuesta: $scope.registro.idEncuesta.toString(), 
                filtrodepartamento: $scope.registro.idDepartamento.toString(), 
                filtromunicipio: $scope.registro.idMunicipio,//.toString(),   //ddlmunicipios.selectedindex == -1 ? "-1" : ddlmunicipios.selectedvalue.tostring()
                filtropreguntas: codPreguntas
            };
            var model2 = JSON.stringify(model);
            url = 'AdomdConnector.svc/ConsultasPersonalizadasRusicstJSON?model=' + model2;
            $scope.isGrid = false;
            var servCall = APIService.getMetodoBI(url);
            servCall.then(function (datos) {
                $scope.error = "";
                datos = datos.ConsultasPersonalizadasRusicstJSONResult;
                if (!datos.startsWith("No se encontró información")) {
                    exportar = datos;
                    var datosGenerados = JSON.parse(datos);
                    for (propiedad in datosGenerados[0]) {
                        if (propiedad.includes("[") || propiedad.includes("]")) {
                            var nombrePropiedad = propiedad.replace(/\[/g, '<');
                            nombrePropiedad = nombrePropiedad.replace(/\]/g, '>');
                            for (var item of datosGenerados) {
                                item[nombrePropiedad] = item[propiedad];
                                delete item[propiedad];
                            }
                        }
                    }
                    $scope.gridOptions.data = angular.copy(datosGenerados);
                    UtilsService.getColumnDefs($scope.gridOptions, false, null, null);
                    $scope.isGrid = true;
                    $scope.consultaPredifinida.expandido = false;
                //var grillaGenerar = $('#grid').html();
                } else {
                    $scope.error = datos;
                }
                
            }, function (error) {
                
            });
        }        
    }
    else
        $scope.error = "Debe escoger al menos una dimensión y una medida.";
    }


    //=============== Limpiar Datos ==========================================================
    $scope.limpiarDatos = function () {
        limpiarDato();
        $scope.datosSeleccionados = {};
        angular.forEach($scope.consultaPredefinidas, function (fila) {
            fila.seleccionada = false;
        })
    }

    $scope.GuardarPredefinida = function () {
        
        var idConsultaPredefinidaSalida = "0";

        if ($scope.predefinida.Nombre == "" || $scope.predefinida.Descripcion == "") {
            $scope.error = "La consulta predefinida debe tener nombre o descripción.";
        }
        else {
            model = {
                idConsultaPredefinida: idConsultaPredefinida,
                nombre: $scope.predefinida.Nombre,
                descripcion: $scope.predefinida.Descripcion,
                codigoPreguntas: codPreguntas,
                codigoEncuesta: $scope.registro.idEncuesta.toString(),
                codigoDepartamento: $scope.registro.idDepartamento.toString(),
                codigoMunicipio: $scope.registro.idMunicipio,
            };
            var model2 = JSON.stringify(model);
            url = 'AdomdConnector.svc/PersistirConsultaPredefinida?model=' + model2;
            $scope.isGrid = false;
            var servCall = APIService.getMetodoBI(url);
            servCall.then(function (datos) {
                ;
                datos = datos.PersistirConsultaPredefinidaResult;
                if (datos.length < 6) {
                    url = 'AdomdConnector.svc/LimpiarConsultaPredefinida?idConsultaPredefinida=' + datos;
                    $scope.isGrid = false;
                    var servCall = APIService.getMetodoBI(url);
                    servCall.then(function (datos) {
                        ;
                        datos = datos.LimpiarConsultaPredefinidaResult;
                    })
                    angular.forEach($scope.dimensiones.segundoNivel, function (segundoNivel, key) {
                        angular.forEach(segundoNivel.tercerNivel, function (tercerNivel) {
                            if (tercerNivel.valor) {
                                modelX = {
                                    idConsultaPredefinida: datos,
                                    control: tercerNivel.label,
                                };
                                var model3 = JSON.stringify(modelX);
                                urlDim = 'AdomdConnector.svc/PersistirDimensionHechoConsultaPrefefinida?model=' +  model3 ;
                               // $scope.isGrid = false;
                                var servCall = APIService.getMetodoBI(urlDim);
                                servCall.then(function (datos) {
                                })
                            }
                        })
                    })
                  alert("Se guardo la consulta predefinida.");
                }
                else
                    alert(datos);
            })
        }  
    }

    function limpiarDato() {
        $scope.registro.idEncuesta = "-1";
        $scope.registro.idDepartamento = "0";
        $scope.registro.idMunicipio = "0";
        $scope.registro.pregunta = "";
        $scope.preguntasSeleccionadas = [];
        $scope.ubicacion = [];
        $scope.gridOptions.data = [];
        UtilsService.getColumnDefs($scope.gridOptions, false, null, null);
        $scope.isGrid = false;
        PintarPreguntsFiltro();
        PintarUbicacionFiltro();
        $scope.dimensiones.valor = false;
        angular.forEach($scope.dimensiones.segundoNivel, function (segundoNivel, key) {
            segundoNivel.valor = false;
            angular.forEach(segundoNivel.tercerNivel, function (tercerNivel) {
                tercerNivel.valor = false;
            })
        });
        $scope.hechos.valor = false;
        $scope.hechos.segundoNivel[0].valor = false;
        $scope.hechoSeleccionado = "";
        $scope.filasSeleccionadas = [];

    }

    //=============== Exportar Datos ==========================================================
    $scope.exportarJson = function (entity) {
        var blob = new Blob([exportar], { type: "application/json" });
        var blobURL = (window.URL || window.webkitURL).createObjectURL(blob);
        var anchor = document.createElement("a");
        anchor.download = "ConsultasBIRusicst.Json";
        anchor.href = blobURL;
        anchor.click();
    }

    //getDatos('AdomdConnector.svc/LoadSchema');
    function getDatos(url, datos) {
        datos = {
            codigoEncuesta : true,
            codigoEncuestaFila : true,
        };
       var servCall = APIService.postMetodoBI(datos, url);
        servCall.then(function (datos) {
            datos = datos;
        }, function (error) {
           
        });
    };
 
    $scope.graficar = function ()
    {
        var i = 0;

        for (var propiedad in $scope.gridOptions.data[0]) {
            if (typeof $scope.gridOptions.data[0][propiedad] == 'number') {
                i++;
            }
        }
        if (i > 1) {
            enviarDatos.datos = {
                datos :  $scope.filasSeleccionadas,
                tipo: 1,
                filtros: [ $scope.datosSeleccionados.encuesta, $scope.datosSeleccionados.departamento, $scope.datosSeleccionados.municipio ]
            }
               
        } else {
            enviarDatos.datos = {
                datos :  $scope.gridOptions.data.slice(0,9),
                tipo: 2,
                filtros: [ $scope.datosSeleccionados.encuesta, $scope.datosSeleccionados.departamento, $scope.datosSeleccionados.municipio ]
            }
        }
        $scope.enviarDatos = JSON.stringify(enviarDatos.datos);
    }
  
}]);