app.controller('EncuestaController', ['$scope', 'APIService', '$stateParams', '$location', '$log', '$sce', 'ngSettings', 'Upload', '$uibModal', 'UtilsService', 'authService', function ($scope, APIService, $stateParams, $location, $log, $sce, ngSettings, Upload, $uibModal, UtilsService, authService) {
    //===== Declaración de Variables ======================
    $scope.registro = {};
    $scope.registro.Id = parseFloat($stateParams.IdPagina);
    $scope.registro.Titulo = $stateParams.Titulo;
    $scope.registro.IdUsuario = null;
    $scope.listaSum = [];
    $scope.rowNuevaFila = [];
    $scope.columnNuevaFila = [];
    $scope.rowIndexNuevaFila = [];
    $scope.columnIndexNuevaFila = [];
    $scope.guardando = true;
    $scope.paginaAnterior = 1;
    $scope.cuentador = 0;
    $scope.listaArchivos = [];
    $scope.extensionesPermitidas = ['.docx', '.doc', '.xls', '.xlsx', '.ppt', '.pptx',  //De microsoft
        '.pdf', '.txt',                                                             //Varias
        '.bmp', '.jpg', '.gif', '.jpg', '.jpeg', '.tif', '.tiff', '.png',           //Imágenes
        '.zip', '.7z', '.rar'
    ];
    if ($stateParams.IdUsuario != 'null') {
        $scope.registro.IdUsuario = $stateParams.IdUsuario;
        getDatos($scope.registro);
    } else {
        UtilsService.getDatosUsuarioAutenticado().respuesta().then(function (respuesta) {
            $scope.registro.IdUsuario = respuesta.Id;
            getDatos($scope.registro);
        });
    }

    //Descargar adjunto
    $scope.descargarArchivo = function (nombreArchivo, idpregunta) {

        var arrA = nombreArchivo.split("-");

        if (arrA.length > 2) {
            if (arrA[0] == arrA[1]) {
                arrA.splice(0, 1);
                nombreArchivo = arrA.join("-");
            }
        }

        var url = $scope.serviceBase + '/api/Reportes/Encuesta/EncuestaDownload?nombreArchivo=' + nombreArchivo + '&idUsuario=' + $scope.registro.IdUsuario + '&idSeccion=' + $scope.registro.Id + '&idPregunta=' + idpregunta;
        window.open(url)
    }


    $scope.PopUpModoDescarga = function () {

        $scope.entityExcel = { seccion: $scope.registro.Id, etapa: $stateParams.SuperSeccion, encuesta: $stateParams.IdEncuesta, usuario: $scope.registro.IdUsuario, serviceBase: $scope.serviceBase };

        //console.log($scope.entityExcel);

        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/reportes/modals/ModoDescargaExcel.html',
            controller: 'ModalDescargarExcelController',
            size: 'md',
            backdrop: 'static', keyboard: false,
            resolve: {
                entity: function () {
                    return angular.copy($scope.entityExcel);
                }
            }
        });
        modalInstance.result.then();
    };

    //Descargar adjunto
    $scope.descargaExcel = function () {
        var url = $scope.serviceBase + '/api/Reportes/Encuesta/DescargarExcelEncuesta?idUsuario=' + $scope.registro.IdUsuario + '&idSeccion=' + $scope.registro.Id;
        window.open(url)
    }

    $scope.descargaExcelEtapa = function () {
        var url = $scope.serviceBase + '/api/Reportes/Encuesta/DescargarExcelEncuestaEtapa?idUsuario=' + $scope.registro.IdUsuario + '&idEtapa=' + $stateParams.SuperSeccion + '&idEncuesta=' + $stateParams.IdEncuesta;
        window.open(url)
    }

    //===== Se obtiene los datos de la encuenta a ser pintada =====

    function getDatos(registro) {
        $scope.cargando = true;
        var url = '/api/Reportes/Encuesta/ConsultaDisenoEncuesta';
        var servCall = APIService.saveSubscriber(registro, url);
        servCall.then(function (respuesta) {
            $scope.listaSum = [];
            $scope.secciones = respuesta.data._Secciones;
            $scope.preguntas = respuesta.data._Preguntas;
            $scope.glosario = respuesta.data._Glosario;
            $scope.isConsulta = respuesta.data.isConsulta;
            $scope.listaPrecargado = [];
            $scope.cuentador = 0;
            $scope.rowSpanNuevaFila = 0;

            $scope.rowNuevaFila = [];
            $scope.columnNuevaFila = [];
            $scope.rowIndexNuevaFila = [];
            $scope.columnIndexNuevaFila = [];

            var esPrimerRow = true;
            var sAnterior = 0;
            var diferenciaS = 0;
            var maxRow = getMax($scope.secciones, 'RowIndex') + 1;
            var maxCol = getMax($scope.secciones, 'ColumnIndex') + 1;
            $scope.grilla = new Array(maxRow);
            for (var i = 0; i < maxRow; i++) {
                $scope.grilla[i] = new Array(maxCol);
                for (var c = 0; c < maxCol; c++) {
                    $scope.grilla[i][c] = { mostrar: true, class: 'rus-label-cell ' }
                }
            }

            //===== PINTAR SECCIONES DE LA ENCUESTA ========================
            for (var s = 0; s < $scope.secciones.length; s++) {
                var mostrar = true;
                var res = new Array(3);
                var clase = "";
                var colspan = 1;
                var rowspan = 1;
                if ($scope.secciones[s].Texto) {
                    res = $scope.secciones[s].Texto.split("%");
                    //Este IF se crea por si el texto tiene el siguiente formato %xxxx%xxx%texto
                    if (res.length === 4) {
                        res[1] = res[1] + res[2];
                        res[2] = res[3];
                    }
                    clase = res[1];
                    if (clase != null) {
                        //----- Se obtiene el colspan de la delda
                        var indexColspan = clase.indexOf("CS=");
                        if (indexColspan != -1) {
                            var subclase = clase.substr(indexColspan);
                            var indexFinal = subclase.indexOf(";");
                            if (indexFinal > 0) {
                                colspan = subclase.substring(3, indexFinal);
                            } else {
                                colspan = subclase.substr(3);
                            }
                            colspan = parseInt(colspan);
                        };
                        //----- Se obtiene el rowspan de la delda
                        var indexRowspan = clase.indexOf("RS=");
                        if (indexRowspan != -1) {
                            var subclase = clase.substr(indexRowspan);
                            var indexFinal = subclase.indexOf(";");
                            if (indexFinal > 0) {
                                rowspan = subclase.substring(3, indexFinal);
                            } else {
                                rowspan = subclase.substr(3);
                            }
                            rowspan = parseInt(rowspan);
                        }

                        //----- Se obtiene las clases de la celda
                        clase = 'rus-label-cell ' + clase.replace(/;/g, " ");
                    } else {
                        res[1] = ""; res[2] = "";
                    }

                } else {
                    res[1] = ""; res[2] = "";
                }


                //----- Obtener los links ------
                var texto = res[2].replace(/\[\[/g, '<a href="" uib-popover="{{textoTermino}}" popover-title="{{tituloTermino}}" popover-trigger="\'mouseenter\'" ng-mouseover="abrirGlosario($event.currentTarget)" >');//'<a href="" uib-tooltip="I can have a custom class applied to me!">');
                texto = texto.replace(/\]\]/g, '</a>');

                //----- Se colocan los datos de cada celda de la encuesta ------
                $scope.grilla[$scope.secciones[s].RowIndex][$scope.secciones[s].ColumnIndex].posicion = $scope.secciones[s].RowIndex + '|' + $scope.secciones[s].ColumnIndex;
                $scope.grilla[$scope.secciones[s].RowIndex][$scope.secciones[s].ColumnIndex].id = $scope.secciones[s].Id;
                $scope.grilla[$scope.secciones[s].RowIndex][$scope.secciones[s].ColumnIndex].class = clase;
                $scope.grilla[$scope.secciones[s].RowIndex][$scope.secciones[s].ColumnIndex].valor = res[2];
                $scope.grilla[$scope.secciones[s].RowIndex][$scope.secciones[s].ColumnIndex].colspan = colspan;
                $scope.grilla[$scope.secciones[s].RowIndex][$scope.secciones[s].ColumnIndex].rowspan = rowspan;
                $scope.grilla[$scope.secciones[s].RowIndex][$scope.secciones[s].ColumnIndex].rowIndex = $scope.secciones[s].RowIndex;
                $scope.grilla[$scope.secciones[s].RowIndex][$scope.secciones[s].ColumnIndex].columnIndex = $scope.secciones[s].ColumnIndex;
                $scope.grilla[$scope.secciones[s].RowIndex][$scope.secciones[s].ColumnIndex].pregunta = { tipo: 'LABEL', valor: texto };

                //----- Para dibujar el botón NUEVA FILA (si existe) ------

                if (clase != null && clase.includes('sh-no-')) {
                    if (sAnterior !== 0) {
                        diferenciaS = $scope.secciones[s].RowIndex - sAnterior;
                        if (diferenciaS > rowspan) {
                            esPrimerRow = true
                        }
                    }

                    sAnterior = $scope.secciones[s].RowIndex;

                    $scope.cuentador = $scope.cuentador + 1;
                    if (esPrimerRow === true) {
                        //console.log("rownindex: " + $scope.secciones[s].RowIndex);
                        $scope.rowNuevaFila.push($scope.secciones[s].RowIndex - 1);
                        $scope.columnNuevaFila.push($scope.secciones[s].ColumnIndex);
                        $scope.rowIndexNuevaFila.push($scope.secciones[s].RowIndex);
                        $scope.columnIndexNuevaFila.push($scope.secciones[s].ColumnIndex);
                        $scope.rowSpanNuevaFila = rowspan;
                        esPrimerRow = false;
                    }

                    var primerRow = $scope.secciones[s].RowIndex - 1
                    mostrar = false;
                    for (var rs = 0; rs < rowspan; rs++) {
                        for (var w = 0; w < maxCol; w++) {
                            $scope.grilla[$scope.secciones[s].RowIndex + rs][w].mostrar = false;
                        };
                    }

                    $scope.grilla[$scope.secciones[s].RowIndex - rowspan][$scope.secciones[s].ColumnIndex].pregunta = { tipo: 'NUEVAFILA', valor: texto, rowIndex: $scope.secciones[s].RowIndex, columnIndex: $scope.secciones[s].ColumnIndex };


                };

            };

            //===== PINTAR LAS PREGUNTAS =====
            var lon_p = $scope.preguntas.length;
            for (var p = 0; p < lon_p; p++) {
                var fila = $scope.preguntas[p]
                fila.Valor = '';
                fila.copyEnc = false;
                var claseElemento = '';
                var texto = fila.Texto.split("%");
                var clase = texto[1];
                if (clase != null) {
                    clase = clase.replace(/;/g, ' ')
                    clase = 'rus-control-cell ' + clase;
                } else {
                    clase = 'rus-control-cell ';
                }

                if ($scope.isConsulta === false) {
                    //----------Se procesan las funciones precargadas---------------------------------------------------------
                    var deshabilitar = false;
                    if (fila.Funciones != null) {
                        switch (fila.Funciones.Func) {
                            case 'copy':
                            case 'copyenc':
                                if ($scope.isEmpty(fila.Respuesta)) {
                                    if (fila.Funciones.Valor != null) {
                                        if (fila.TipoPregunta === 'NUMERO' || fila.TipoPregunta === 'DECIMAL'
                                            || fila.TipoPregunta === 'PORCENTAJE' || fila.TipoPregunta === 'MONEDA') {
                                            fila.Valor = parseInt(fila.Funciones.Valor);
                                        } else if (fila.TipoPregunta === 'FECHA') {
                                            //var fecha = fila.Funciones.Valor.split("-");
                                            //fila.Valor = new Date(fecha[2], fecha[1] - 1, fecha[0]);
                                            //fila.Valor = new Date(fila.Funciones.Valor);
                                            fila.Valor = fila.Funciones.Valor;
                                        }
                                        else {
                                            fila.Valor = fila.Funciones.Valor;
                                        }

                                        fila.copyEnc = true;
                                        claseElemento = 'estilo-copy';
                                    }
                                }
                                break;
                            case "disableclear":
                                //Se borra la información
                                fila.Valor = "";
                                fila.Respuesta = "";
                                //Ponemos el valor en listaprecargado para realizar la acción disableclear.
                                $scope.listaPrecargado.push(fila.Funciones);
                                break;
                            case "disable":
                                //Ponemos el valor en listaprecargado para realizar la acción disableclear.
                                $scope.listaPrecargado.push(fila.Funciones);
                                break;
                            case "enable":
                                //Ponemos el valor en listaprecargado para realizar la acción disableclear.
                                $scope.listaPrecargado.push(fila.Funciones);
                                break;
                            case "sum":
                                //Ponemos el valor en listaprecargado para realizar la acción disableclear.
                                var longSums = fila.Funciones.Valor.length;
                                var valor = fila.Funciones.Valor;
                                //$scope.listaSum = [];
                                for (var s = 0; s < longSums; s++) {
                                    $scope.listaSum.push({
                                        idTotal: fila.Funciones.IdPreguntaSUM,
                                        idSumando: valor[s],
                                        //valor: fila.LPreCargado[i].Valor
                                    });
                                };

                                deshabilitar = true;
                                break;
                            case "exec":
                                if (fila.Funciones.Valor != null) {
                                    for (var cExec = 0; cExec < fila.Funciones.Valor.length; cExec++) {
                                        var funcExec = fila.Funciones.Valor[cExec];

                                        switch (funcExec.Func) {
                                            case 'copy':
                                            case 'copyenc':
                                                if ($scope.isEmpty(fila.Respuesta)) {
                                                    if (funcExec.Valor != null) {
                                                        if (fila.TipoPregunta === 'NUMERO' || fila.TipoPregunta === 'DECIMAL'
                                                            || fila.TipoPregunta === 'PORCENTAJE' || fila.TipoPregunta === 'MONEDA') {
                                                            fila.Valor = parseInt(funcExec.Valor);
                                                        } else if (fila.TipoPregunta === 'FECHA') {
                                                            //var fecha = fila.Funciones.Valor.split("-");
                                                            //fila.Valor = new Date(fecha[2], fecha[1] - 1, fecha[0]);
                                                            //fila.Valor = new Date(fila.Funciones.Valor);
                                                            fila.Valor = funcExec.Valor;
                                                        }
                                                        else {
                                                            fila.Valor = funcExec.Valor;
                                                        }

                                                        fila.copyEnc = true;
                                                        claseElemento = 'estilo-copy';
                                                    }
                                                }
                                                break;
                                            case "disableclear":
                                                //Se borra la información
                                                fila.Valor = "";
                                                fila.Respuesta = "";
                                                //Ponemos el valor en listaprecargado para realizar la acción disableclear.
                                                $scope.listaPrecargado.push(funcExec);
                                                break;
                                            case "disable":
                                                //Ponemos el valor en listaprecargado para realizar la acción disableclear.
                                                $scope.listaPrecargado.push(funcExec);
                                                break;
                                            case "enable":
                                                //Ponemos el valor en listaprecargado para realizar la acción disableclear.
                                                $scope.listaPrecargado.push(funcExec);
                                                break;
                                            default:
                                                break;
                                        }
                                    }
                                }
                                break;
                            default:
                                break;
                        }
                    };
                    if (fila.TienePrecargue == 1 && (fila.Respuesta == null || (fila.TipoPregunta == 'FECHA') && fila.Respuesta == "")) {
                        claseElemento = 'estilo-precargue';
                        fila.Respuesta = fila.ValorPrecargue;
                        fila.Valor = fila.ValorPrecargue;
                    }
                } else {
                    deshabilitar = true;
                }

                //----- Se ponen los datos de las preguntas en cada celda -----
                if ($scope.isConsulta === false) {
                    $scope.grilla[fila.RowIndex][fila.ColumnIndex].pregunta = {
                        claseElemento: claseElemento, tipo: fila.TipoPregunta, valor: parseValor(fila.Valor, fila.Respuesta, fila.TipoPregunta),
                        LOpciones: fila.LOpciones, deshabilitar: deshabilitar, fila: fila.RowIndex, columna: fila.ColumnIndex,
                        esObligatoria: fila.EsObligatoria, copyEnc: fila.copyEnc
                    };
                } else {
                    $scope.grilla[fila.RowIndex][fila.ColumnIndex].pregunta = {
                        claseElemento: claseElemento, tipo: fila.TipoPregunta, valor: parseValorSoloConsulta(fila.Valor, fila.Respuesta, fila.TipoPregunta),
                        LOpciones: fila.LOpciones, deshabilitar: deshabilitar, fila: fila.RowIndex, columna: fila.ColumnIndex,
                        esObligatoria: fila.EsObligatoria, copyEnc: fila.copyEnc
                    };
                }

                $scope.grilla[fila.RowIndex][fila.ColumnIndex].class = "";
                $scope.grilla[fila.RowIndex][fila.ColumnIndex].id = fila.Id;

                //Lógica para los Archivos Adjuntos
                if (fila.TipoPregunta === 'ARCHIVO') {
                    if ($scope.isEmpty(fila.Respuesta) && $scope.isEmpty(fila.Valor)) {
                        $scope.grilla[fila.RowIndex][fila.ColumnIndex].pregunta.isVacia = true;
                    } else {
                        $scope.grilla[fila.RowIndex][fila.ColumnIndex].pregunta.valor = $scope.isEmpty(fila.Respuesta) ? fila.Valor : fila.Respuesta;
                    }
                }
            };

            //===== SE OCULTAN LAS CELDAS DEL COLSPAN =====
            angular.forEach($scope.grilla, function (fila, key) {
                var numfila = key;
                var a = 0;
                angular.forEach(fila, function (celda, key) {
                    numcelda = key;
                    if (celda.rowspan > 1) {
                        for (var colspan = 0; colspan < celda.colspan; colspan++) {
                            for (var i = 1; i < celda.rowspan; i++) {
                                $scope.grilla[numfila + i][numcelda + colspan] = { mostrar: false, class: '', valor: "", colspan: celda.colspan, rowspan: 1 };

                            }
                        }
                    }
                });
            });

            //===== SE OCULTAN LAS CELDAS DEL ROWSPAN =====
            angular.forEach($scope.grilla, function (fila, key) {
                var numfila = key;
                var numCelda = null;
                var rowspanRelleno = null;
                var sumaColumnas = 0;
                angular.forEach(fila, function (celda, key) {
                    sumaColumnas += celda.colspan;
                    rowspanRelleno = celda.rowspan;
                    numcelda = key;
                    if (celda.colspan > 1) {
                        for (var i = 1; i < celda.colspan; i++) {
                            $scope.grilla[numfila][numcelda + i] = { mostrar: false, class: '', valor: "", colspan: 1, rowspan: 1 };
                        }
                    }
                });
            });

            //Si hay botón Nueva Fila
            if ($scope.columnNuevaFila.length > 0) {
                for (var ii = 0; ii < $scope.columnNuevaFila.length; ii++) {
                    var reversa = 0;
                    var escapar = true
                    do {
                        var contador = $scope.rowNuevaFila[ii] - reversa;
                        if ($scope.grilla[contador][$scope.columnNuevaFila[ii]].mostrar === true) {
                            //console.log("restando");
                            //console.log("contador: " + contador + " - colunmnuevafila[ii]: " + $scope.columnNuevaFila[ii] + " - rowspanprev: " + $scope.grilla[contador][$scope.columnNuevaFila[ii]].rowspan + " - rowspannuevafila: " + $scope.rowNuevaFila[ii]);
                            $scope.grilla[contador][$scope.columnNuevaFila[ii]].rowspan = $scope.grilla[contador][$scope.columnNuevaFila[ii]].rowspan - 1;
                            escapar = false;
                        }
                        reversa++;
                    } while (escapar || contador === 0);
                    if ($scope.cuentador > 1) {
                        $scope.grilla[$scope.rowNuevaFila[ii]][$scope.columnNuevaFila[ii]].pregunta = { tipo: 'NUEVAFILA', valor: "", rowIndex: $scope.rowIndexNuevaFila[ii], columnIndex: $scope.columnIndexNuevaFila[ii] };
                        $scope.grilla[$scope.rowNuevaFila[ii]][$scope.columnNuevaFila[ii]].mostrar = true;
                    }
                }
            }

            //===== SE REALIZAN LAS ACCIONES DEL PRECARGADO ============================
            for (var n = 0; n < $scope.listaPrecargado.length; n++) {
                var celda = buscarValorXId(parseInt($scope.listaPrecargado[n].Valor));
                if (celda != null) {
                    var fila = celda.pregunta.fila, columna = celda.pregunta.columna;
                    var accion = $scope.listaPrecargado[n].Func.toLowerCase();
                    switch (accion) {
                        case 'enable':
                            $scope.grilla[fila][columna].pregunta.deshabilitar = false;
                            break;
                        case 'disable':
                            $scope.grilla[fila][columna].pregunta.deshabilitar = true;
                            break;
                        case 'disableclear':
                            $scope.grilla[fila][columna].pregunta.deshabilitar = true;
                            break;
                        case 'sum':
                            $scope.grilla[fila][columna].pregunta.deshabilitar = true;
                            break;
                        default:
                            break;
                    }
                }
            }

            //=================== SE ADICIONA LOS SUMANDOS, SI LOS HAY ==================
            if ($scope.listaSum.length > 0) {
                for (var m = 0; m < $scope.listaSum.length; m++) {
                    var celda = buscarValorXId($scope.listaSum[m].idSumando);
                    if (celda != null) {
                        var fila = celda.pregunta.fila, columna = celda.pregunta.columna;
                        $scope.grilla[fila][columna].pregunta.sumando = true;
                        $scope.grilla[fila][columna].pregunta.idTotal = $scope.listaSum[m].idTotal;
                    }
                    $scope.performSUM($scope.listaSum[m].idTotal);
                }
            };
            //===== SE GUARDA UNA COPIA DE LA GRILLA, PARA LUEGO COMPARAR SI EL USUARIO HIZO CAMBIOS ======
            $scope.grillaCopia = angular.copy($scope.grilla);
            $scope.cargando = false;
            $scope.guardando = false;
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    };

    $scope.deleteFile = function (celda) {
        celda.pregunta.isVacia = true;
        celda.pregunta.valor = null;
        celda.pregunta.copyEnc = false;
    };

    //================== ABRIR GLOSARIO ==========================================================
    $scope.abrirGlosario = function (elemento) {
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

    $scope.performSUM = function (celdaIdTotal) {

        var resultado = 0;
        var sumando, celdaSumando;
        var idTotal = celdaIdTotal;
        var long = $scope.listaSum.length;
        for (var l = 0; l < long; l++) {
            if ($scope.listaSum[l].idTotal === idTotal) {
                celdaSumando = buscarValorXId($scope.listaSum[l].idSumando);

                sumando = celdaSumando.pregunta.valor;
                var tipoSumando = typeof sumando;
                if (tipoSumando == "string") {
                    if (sumando == "") sumando = 0;
                    sumando = parseInt(sumando);
                }

                resultado += isNaN(sumando) ? 0 : sumando;
            }
        }

        var celdaTotal = buscarValorXId(idTotal);

        if (celdaTotal != null) {
            var fila = celdaTotal.pregunta.fila, columna = celdaTotal.pregunta.columna;
            $scope.grilla[fila][columna].pregunta.valor = resultado;
        }

    };

    //==================POSTCARGADO===========================================================
    $scope.postcargado = function (celda) {

        //Si la Celda es un Sumando
        if (celda.pregunta.sumando != null) {
            if (celda.pregunta.sumando) {
                var resultado = 0;
                var sumando, celdaSumando;
                var idTotal = celda.pregunta.idTotal;
                var long = $scope.listaSum.length;
                for (var l = 0; l < long; l++) {
                    if ($scope.listaSum[l].idTotal === idTotal) {
                        celdaSumando = buscarValorXId($scope.listaSum[l].idSumando);

                        sumando = celdaSumando.pregunta.valor;
                        var tipoSumando = typeof sumando;
                        if (tipoSumando == "string") {
                            if (sumando == "") sumando = 0;
                            sumando = parseInt(sumando);
                        }

                        resultado += isNaN(sumando) ? 0 : sumando;
                    }
                }

                var celdaTotal = buscarValorXId(celda.pregunta.idTotal);
                if (celdaTotal != null) {
                    var fila = celdaTotal.pregunta.fila, columna = celdaTotal.pregunta.columna;
                    $scope.grilla[fila][columna].pregunta.valor = resultado;
                }
            }
            //Si la Celda debe ir hasta el API.
        } else {

            //Obtenemos los datos de los controles previo al postcargado -- callback
            $scope.getDatosPostcargadoControles();

            var registroPostcargado = { Id: celda.id, Valor: celda.pregunta.valor, IdUsuario: $scope.registro.IdUsuario, datosControles: $scope.datosPostCargado };
            var url = '/api/Reportes/Encuesta/Postcargado'
            getPostcargado();
            function getPostcargado() {
                var servCall = APIService.saveSubscriber(registroPostcargado, url);
                servCall.then(function (respuesta) {

                    var postCargados = respuesta.data.LPostCargado
                    var valor;
                    if (postCargados.length > 0) {
                        angular.forEach(postCargados, function (postCargado) {
                            ejecutar(postCargado.Func, postCargado.IdPregunta, postCargado.Valor);
                        });
                    }
                }, function (error) {
                    $scope.cargoDatos = true;
                    $scope.error = "Se generó un error en la petición";
                });
            };
        }
    }

    //-----------------ParseValores
    function parseValor(valor, respuesta, tipo) {
        var retVal = !$scope.isEmpty(respuesta) ? respuesta : valor;

        if (tipo === 'NUMERO' || tipo === 'DECIMAL'
            || tipo === 'PORCENTAJE' || tipo === 'MONEDA') {
            if ($scope.isEmpty(retVal)) retVal = '';
            else
                retVal = parseInt(retVal);
        } else if (tipo === 'FECHA') {
            if (!$scope.isEmpty(retVal)) {
                var fecha = retVal.split("-");
                retVal = new Date(fecha[2], fecha[1] - 1, fecha[0]);
            } else {
                retVal = '';
            }
        }
        return retVal;
    }

    //-----------------ParseValores
    function parseValorSoloConsulta(valor, respuesta, tipo) {
        var retVal = !$scope.isEmpty(respuesta) ? respuesta : valor;

        if (tipo === 'NUMERO' || tipo === 'DECIMAL'
            || tipo === 'PORCENTAJE' || tipo === 'MONEDA') {
            if ($scope.isEmpty(retVal)) retVal = '';
            else
                retVal = parseInt(retVal);
        } else if (tipo === 'FECHA') {
            if (!$scope.isEmpty(retVal)) {
                var fecha = retVal.split("-");
                retVal = new Date(fecha[2], fecha[1] - 1, fecha[0]);
            } else {
                retVal = '';
            }
        }
        return retVal;
    }

    $scope.isEmpty = function (value) {
        return (value === "" || value === null);
    };

    //--------------------------Buscar Valor por Id-------------------------------------
    function buscarValorXId(id) {
        for (var i = 0; i < $scope.grilla.length; i++) {
            for (var j = 0; j < $scope.grilla[i].length; j++) {
                if ($scope.grilla[i][j].id === id) {
                    return $scope.grilla[i][j];
                    break;
                }
            }
        }
    }

    //----------------------Ejecutar Accion-------------------------------------------------
    function ejecutar(accion, id, valor) {
        var celda = buscarValorXId(id);
        var fila = celda.pregunta.fila, columna = celda.pregunta.columna;

        //console.log("Ejecutar postcargado");
        //console.log(accion);
        //console.log(id);
        //console.log(valor);

        switch (accion) {
            case 'enable':
                $scope.grilla[fila][columna].pregunta.deshabilitar = false;
                break;
            case 'disable':
                $scope.grilla[fila][columna].pregunta.deshabilitar = true;
                break;
            case 'disableclear':
                $scope.grilla[fila][columna].pregunta.deshabilitar = true;
                $scope.grilla[fila][columna].pregunta.valor = "";
                break;
            case 'exec':
                if (valor != null) {
                    for (var i = 0; i < valor.length; i++) {
                        var funcExec = valor[i];
                        ejecutar(funcExec.Func, id, funcExec.Valor);
                    }
                }
                break;
        }
    }

    //====================Dibujar Nueva Fila===================================================
    $scope.adicionarNuevaFila = function (celda) {
        for (var rss = 0; rss < $scope.rowSpanNuevaFila; rss++) {
            for (var z = 0; z < $scope.grilla[0].length; z++) {
                if ($scope.grilla[celda.pregunta.rowIndex + rss][z].id != null) {
                    $scope.grilla[celda.pregunta.rowIndex + rss][z].mostrar = true;
                }
            }
        }

        if (celda.rowspan == 0) {
            celda.rowspan = $scope.rowSpanNuevaFila;
        }

        $scope.grilla[celda.pregunta.rowIndex - $scope.rowSpanNuevaFila][celda.pregunta.columnIndex].pregunta = { tipo: 'LABEL', valor: '' };

        if (celda.pregunta.rowIndex !== undefined) {
            $scope.grilla[celda.pregunta.rowIndex - 1][celda.pregunta.columnIndex].pregunta = { tipo: 'LABEL', valor: '' };
        }

    }

    //====================Obtener Valor Máximo de los Datos=====================================
    function getMax(myArray, columna) {
        var highest = Number.NEGATIVE_INFINITY;
        var tmp;
        for (var i = myArray.length - 1; i >= 0; i--) {
            tmp = myArray[i][columna];
            if (tmp > highest) highest = tmp;
        }
        return highest;
    }

    //======================OBTENER SECCIONES Y SUBSECCIONES==================================
    getDatosEncuesta();
    function getDatosEncuesta() {
        var url = '/api/Reportes/IndiceEncuestas/ConsultarSecciones_Pintar';
        $scope.registro.IdEncuesta = $stateParams.IdEncuesta;
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (respuesta) {
            if (respuesta.status === 200) {
                $scope.datos = respuesta.data;
                $scope.paginas = obtenerPaginas($scope.datos);
                //Datos de paginación
                $scope.MaximoTamanho = 10;
                $scope.totalPaginas = $scope.paginas.paginas.length * 9;
                $scope.paginaActual = $scope.paginas.paginaActual;
            };
        }, function (error) {
            $scope.error = "Se generó un error en la petición, no se guardaron los datos";
        });
    };

    //============Obtener número de páginas=================
    function obtenerPaginas(datos) {

        //Encontramos sección
        var paginas = [];
        var paginaActual = 0;
        angular.forEach(datos, function (seccion) {

            for (var i = 0; i < seccion.LSubSecciones.length; i++) {
                if (seccion.LSubSecciones[i].SuperSeccion === parseInt($stateParams.SuperSeccion)) {
                    paginas.push(seccion.LSubSecciones[i].Id);
                }
            }
        });
        //Contamos las páginas de esa supersección
        return { paginas: paginas, paginaActual: 1 }
    }
    //==========================Cambio de Página========================================
    $scope.cambiarPagina = function (paginaActual) {
        //Se guarda la página anterior

        if (!angular.equals($scope.grilla, $scope.grillaCopia)) {
            abrirConfirmacion('¿Quieres salir de esta página? Pero has realizado cambios. Si continuas, los cambios no serán guardados.');
        } else {
            $scope.guardando = true;
            var index = $scope.paginaActual - 1;
            $scope.registro.Id = $scope.paginas.paginas[index];
            $scope.paginaAnterior = $scope.paginaActual;
            getDatos($scope.registro);
        }
    };

    //Confirmación
    function abrirConfirmacion(mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmarSalirPagina.html',
            controller: 'ModalConfirmacionSalirPaginaController',
            resolve: {
                datos: function () {
                    var enviar = { msn: mensaje, tipo: "alert alert-warning" };
                    return enviar;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (respuesta) {
                if (respuesta) {
                    //Continuar - Se continua a la página solicitada
                    $scope.guardando = true;
                    var index = $scope.paginaActual - 1;
                    $scope.registro.Id = $scope.paginas.paginas[index];
                    $scope.paginaAnterior = $scope.paginaActual;
                    getDatos($scope.registro);
                } else {
                    //Cancelar - se queda sobre la misma página
                    var temp = $scope.paginaActual
                    $scope.paginaActual = $scope.paginaAnterior;
                    $scope.paginaAnterior = temp;
                }
            });
    };

    //==========================Volver al índice========================================
    $scope.volverIndice = function () {
        var idEncuesta = $scope.registro.IdEncuesta;
        var titulo = $scope.registro.Titulo;
        $location.url('/Index/Reportes/IndiceEncuesta/' + idEncuesta + '/' + titulo + '/' + $scope.registro.IdUsuario);
    };

    //========================Cerrar archivo adjunto ===================================
    $scope.cerrar = function (celda) {
        $scope.isCerrando = true;
        $scope.celdaCerrar = celda;
        var mensaje = { msn: "¿Esta seguro de eliminar el archivo: '" + celda.pregunta.valor + "'?", tipo: "alert alert-danger" };
        openConfirmacion(mensaje);
    }

    //========================VALIDAR ARCHIVO ADJUNTO===================================
    $scope.validarArchivo = function (celda, file) {
        var respuestaValidarArchivo = true;
        var indexUltimoPunto = file.name.lastIndexOf(".");
        if (indexUltimoPunto != -1) {
            var extension = file.name.slice(indexUltimoPunto);
            extension = extension.toLowerCase();
            if ($scope.extensionesPermitidas.indexOf(extension) === -1) {
                var mensaje = { msn: "La extensión '" + extension + "' no es permitida", tipo: "alert alert-danger" };
                respuestaValidarArchivo = false;
                quitarArchivoAdjunto(celda);
                openRespuesta(mensaje);
            } else if (file.name.search(/[!*$#,´'`~+]/g) != -1) {
                var mensaje = { msn: "El nombre de archivo '" + file.name + "' contiene caracteres no permitidos (!*$#,´'`~+). Modifíquelo e intente nuevamente.", tipo: "alert alert-danger" };
                respuestaValidarArchivo = false;
                quitarArchivoAdjunto(celda);
                openRespuesta(mensaje);
            }
        } else {
            var mensaje = { msn: "No existe ninguna extensión para el archivo", tipo: "alert alert-danger" };
            respuestaValidarArchivo = false;
            quitarArchivoAdjunto(celda);
            openRespuesta(mensaje);
        }

        //Se valida que el tamaño máximo de la suma de los archivos no exceda los 10 MB
        if (respuestaValidarArchivo) {
            var isArchivo = false;
            if ($scope.listaArchivos.length > 0) {
                angular.forEach($scope.listaArchivos, function (archivo) {
                    if (celda.id === archivo.id) {
                        archivo.valor = file.size;
                        isArchivo = true;
                    }
                })
            }

            if (!isArchivo) {
                $scope.listaArchivos.push({
                    id: angular.copy(celda.id),
                    valor: angular.copy(file.size)
                })
            }

            var sumArchivos = 0;
            if ($scope.listaArchivos.length > 0) {
                angular.forEach($scope.listaArchivos, function (archivo) {
                    sumArchivos += archivo.valor;
                })

                if (sumArchivos > 10000000) {
                    quitarArchivoAdjunto(celda);
                    file = null;
                    var mensaje = { msn: 'La suma de los tamaños de los archivos no debe supera los 10 MB', tipo: "alert alert-danger" };
                    openRespuesta(mensaje);
                }
            }
        }

        function quitarArchivoAdjunto(celda) {
            $scope.grilla[celda.pregunta.fila][celda.pregunta.columna].pregunta.valor = null;
            file = '';
            celda = {};
            var id = $('#archivo').html();
        }

        return respuestaValidarArchivo;

    }

    //============================DATOS POSTCARGADO PREGUNTAS+RESPUESTAS EN CONTROLES===============================================
    $scope.getDatosPostcargadoControles = function () {
        var listaRespuestas = [];
        var filas = $scope.grilla.length;
        var abortar = false;
        loop1:
            for (var x = 0; x < filas; x++) {
                loop2:
                    for (var y = 0; y < $scope.grilla[x].length; y++) {
                        if ($scope.grilla[x][y].pregunta != null) {

                            if ($scope.grilla[x][y].pregunta.tipo != 'LABEL' && $scope.grilla[x][y].pregunta.tipo != 'NUEVAFILA' && $scope.grilla[x][y].pregunta.tipo != 'ARCHIVO') {

                                var pregunta = {
                                    Id: $scope.grilla[x][y].id,
                                    Valor: $scope.isEmpty($scope.grilla[x][y].pregunta.valor) ? '' : $scope.grilla[x][y].pregunta.valor,
                                    aDelete: $scope.isEmpty($scope.grilla[x][y].pregunta.valor)
                                }
                                listaRespuestas.push(pregunta);
                            }
                        }
                    };
            }
        if (!abortar) {
            $scope.datosPostCargado = listaRespuestas;
        }
    }

    //============================GUARDAR===============================================
    $scope.guardar = function () {
        var listaRespuestas = [];
        var listaRespuestasArchivos = []
        var archivos = [];
        var archivo = {};
        var filas = $scope.grilla.length;
        var abortar = false;
        $scope.indicesArchivos = [];
        loop1:
            for (var x = 0; x < filas; x++) {
                loop2:
                    for (var y = 0; y < $scope.grilla[x].length; y++) {
                        if ($scope.grilla[x][y].pregunta != null) {

                            if ($scope.grilla[x][y].pregunta.tipo != 'LABEL' && $scope.grilla[x][y].pregunta.tipo != 'NUEVAFILA' && $scope.grilla[x][y].pregunta.tipo != 'ARCHIVO') {

                                //console.log($scope.grilla[x][y].pregunta);
                                //console.log(typeof $scope.grilla[x][y].pregunta.valor);

                                var pregunta = {
                                    id: $scope.grilla[x][y].id,
                                    valor: $scope.isEmpty($scope.grilla[x][y].pregunta.valor) ? '' : $scope.grilla[x][y].pregunta.valor,
                                    aDelete: $scope.isEmpty($scope.grilla[x][y].pregunta.valor)
                                }
                                listaRespuestas.push(pregunta);
                            }
                            if ($scope.grilla[x][y].pregunta.tipo === 'ARCHIVO' && !$scope.isEmpty($scope.grilla[x][y].pregunta.valor) && typeof $scope.grilla[x][y].pregunta.valor === 'object') {
                                var archivoCopy = angular.copy(archivo);
                                archivoCopy = $scope.grilla[x][y].pregunta.valor;
                                archivos.push(archivoCopy);
                                //listaRespuestasArchivos.push(archivoCopy);

                                var repuestaArchivo = {
                                    id: $scope.grilla[x][y].id,
                                    valor: archivoCopy.name,
                                    aDelete: false
                                };
                                listaRespuestas.push(repuestaArchivo);
                            }

                            if ($scope.grilla[x][y].pregunta.tipo === 'ARCHIVO' && $scope.grilla[x][y].pregunta.copyEnc && typeof $scope.grilla[x][y].pregunta.valor != 'object') {
                                //console.log($scope.grilla[x][y].pregunta);
                                var pregunta = {
                                    id: $scope.grilla[x][y].id,
                                    valor: $scope.grilla[x][y].pregunta.valor,
                                    aDelete: !($scope.grilla[x][y].pregunta.valor.toString().length > 0)
                                }
                                listaRespuestas.push(pregunta);
                            }

                            if ($scope.grilla[x][y].pregunta.tipo === 'ARCHIVO' && typeof $scope.grilla[x][y].pregunta.valor != 'object' && $scope.isEmpty($scope.grilla[x][y].pregunta.valor)) {
                                var pregunta = {
                                    id: $scope.grilla[x][y].id,
                                    valor: $scope.grilla[x][y].pregunta.valor,
                                    aDelete: !($scope.grilla[x][y].pregunta.valor.toString().length > 0)
                                }
                                listaRespuestas.push(pregunta);
                            }
                        }
                    };
            }
        if (!abortar) {
            $scope.datosGuardar = {
                usuario: $scope.registro.IdUsuario,
                idSeccion: $scope.registro.Id,

                //// Datos de auditoría
                AudUserName: authService.authentication.userName,
                AddIdent: authService.authentication.isAddIdent,
                UserNameAddIdent: authService.authentication.userNameAddIdent,

                listaRespuestas: listaRespuestas,
                listaRespuestasArchivos: listaRespuestasArchivos
            }

            $scope.upload(archivos);
        }
    }

    $scope.upload = function (archivos) {
        $scope.guardando = true;
        //console.log($scope.datosGuardar);
        var serviceBase = ngSettings.apiServiceBaseUri;
        Upload.upload({
            url: serviceBase + '/api/Reportes/Encuesta/GuardarEncuesta',
            method: "POST",
            data: $scope.datosGuardar,
            file: archivos,
        }).then(function (resultado) {
            $scope.deshabiltarRegistrese = false;
            switch (resultado.data.estado) {
                case 0:
                    var mensaje = { msn: resultado.data.respuesta, tipo: "alert alert-warning" };
                    openRespuestaGuardado(mensaje);
                    break;
                case 1:
                    var mensaje = { msn: resultado.data.respuesta, tipo: "alert alert-success" };
                    openRespuestaGuardado(mensaje);
                    break;
            };
            getDatos($scope.registro);
        }, function (resultado) {
            $scope.deshabiltarRegistrese = false;
            $scope.guardando = false;
            var mensaje = { msn: 'Error: ' + resultado.message, tipo: "alert alert-danger" };
            openRespuestaGuardado(mensaje);
        }, function (evt) {
            var progressPercentage = parseInt(100.0 * evt.loaded / evt.total);
            console.log('progress: ' + progressPercentage + '% ' + evt.config.data.file.name);
        });
    };


    //$scope.$watch('paginaActual', function (newVal, oldVal) {
    //    console.log(newVal);
    //    console.log(oldVal);
    //});


    //=======================Confirmaciones========================================================
    var openConfirmacion = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/ConfirmacionConManejoDeRespuesta.html',
            controller: 'ModalConfirmacionConManejoDeRespuestaController',
            resolve: {
                datos: function () {
                    return mensaje;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (resultado) {
                if ($scope.isCerrando && resultado) {

                    var fila = $scope.celdaCerrar.pregunta.fila, columna = $scope.celdaCerrar.pregunta.columna;
                    $scope.grilla[fila][columna].pregunta.valor = '';
                    $scope.grilla[fila][columna].pregunta.copyEnc = false;
                    $scope.grilla[fila][columna].pregunta.isVacia = true;
                    $scope.celdaCerrar = {};
                    $scope.isCerrando = false;
                }
            });
    };

    var openRespuesta = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    return mensaje;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (resultado) {
            });
    };

    var openRespuestaGuardado = function (mensaje) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/modals/Respuesta.html',
            controller: 'ModalRespuestaController',
            resolve: {
                datos: function () {
                    return mensaje;
                }
            },
            backdrop: 'static', keyboard: false
        });
        modalInstance.result.then(
            function (resultado) {
                $scope.listaArchivos = [];
            });
    };
}]);

app.controller('ModalDescargarExcelController', ['$scope', 'APIService', '$filter', '$log', '$uibModalInstance', '$http', 'entity', 'UtilsService', 'authService', function ($scope, APIService, $filter, $log, $uibModalInstance, $http, entity, UtilsService, authService) {

    $scope.serviceBase = entity.serviceBase;
    $scope.idSeccion = entity.seccion;
    $scope.idEtapa = entity.etapa;
    $scope.idEncuesta = entity.encuesta;
    $scope.idUsuario = entity.usuario;

    $scope.cancelar = function () {
        $uibModalInstance.dismiss('cancel');
    };

    //Descargar adjunto
    $scope.descargaExcel = function () {
        var url = $scope.serviceBase + '/api/Reportes/Encuesta/DescargarExcelEncuesta?idUsuario=' + $scope.idUsuario + '&idSeccion=' + $scope.idSeccion;
        window.open(url)
    }

    $scope.descargaExcelSeccion = function () {
        var url = $scope.serviceBase + '/api/Reportes/Encuesta/DescargarExcelEncuestaEtapa?idUsuario=' + $scope.idUsuario + '&idEtapa=' + $scope.idEtapa + '&idEncuesta=' + $scope.idEncuesta;
        window.open(url)
    }

}]);