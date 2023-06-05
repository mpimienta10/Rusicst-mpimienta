//Directiva para crear el índice de la encuesta
app.directive('pintarSecciones', pintarSecciones);
function pintarSecciones() {
    return {
        restrict: 'E',
        transclude: true,
        scope: {
            seccion: '=',
        },
        template: function (elem, attr) {
            return  '<div uib-accordion-group class="seccion-indice seccion-indice-titulo {{seccion.Estilos}}" is-open="seccion.expandido" ng>' +
                        '<uib-accordion-heading>' +
                            '<div>{{seccion.Titulo}} <i class="pull-right fa" ng-class="{\'fa-chevron-down\': seccion.expandido, \'fa-chevron-right\': !seccion.expandido}"></i></div>' +
                        '</uib-accordion-heading>' +
                        '<ng-transclude></ng-transclude>' +
                    '</div>'
        },
    }
}

//Directiva para cseleccionar el tipo de elemento
app.directive('grilla', tipoElemento);
function tipoElemento() {
    return {
        //restrict: 'E',
        //transclude: true,
        scope: //true,
        {
            data: '=',
        },
        template: function (elem, attr) {
            return '<div class="id">' +
             '</div>';
        },
        link: function (scope, element, attrs, controller, transcludeFn) {

            attrs.$observe('grilla', function () {
                console.log(' type:', attrs.grilla);
                var datos = JSON.parse(attrs.grilla);
                var maxRow = getMax(datos, 'RowIndex') + 1;
                var maxCol = getMax(datos, 'ColumnIndex') + 1;

                
                //var datosCell = [maxRow][maxCol];
                var datosCell = new Array(maxRow);
                for (var i = 0; i < maxRow; i++) {
                    datosCell[i] = new Array(maxCol);
                }
                var res = new Array(3);
                angular.forEach(datos, function (valor) {
               
                    if (valor.Texto) {
                        res = valor.Texto.split("%");
                    } else {
                        res[1] = ""; res[2] = "";
                    }
                    datosCell[valor.RowIndex][valor.ColumnIndex] = { class: res[1], valor: res[2] };

                });
                //Función para armar la grilla
                var tabla = document.createElement("table");
                var tbody = document.createElement("tbody");
                for (var r = 0; r < maxRow; r++) {
                    //var tr = '<tr>';

                    var tr = document.createElement("tr");
                    var textoCelda = "";
                    for (var c = 0; c < maxCol; c++) {
                        var td = document.createElement("td");
                        td.classList.add('rus-label-cell'); 
                        td.id = r + c;
                        
                        if (datosCell[r][c]) {
                            var clase = datosCell[r][c]['class'];

                            var indexColspan = clase.indexOf("CS=") + 3;
                            if (indexColspan != -1) {
                                var indexPuntoyComa = clase.indexOf(";");
                                var colspan = clase.substring(indexColspan, indexPuntoyComa);
                                td.colSpan = parseInt(colspan);
                                //eliminarSpan()
                            }
                            td.className = 'rus-label-cell ' + clase.replace(/;/g," ");
                            textoCelda = document.createTextNode(datosCell[r][c]['valor']);
                        } else {
                            textoCelda = document.createTextNode("");
                        }
                        td.appendChild(textoCelda);
                        tr.appendChild(td);
                   }
                    tbody.appendChild(tr);
                }

                tabla.appendChild(tbody);

                element.html(tabla);
            });



            // Crea un elemento <table> y un elemento <tbody>
            
          
            function getMax(myArray, columna) {
                var highest = Number.NEGATIVE_INFINITY;
                var tmp;
                for (var i = myArray.length - 1; i >= 0; i--) {
                    tmp = myArray[i][columna];
                    if (tmp > highest) highest = tmp;
                }
                return highest;
            }
         
        }
    }
}

//Directiva para cseleccionar el tipo de elemento
app.directive('tipoPregunta', tipoPregunta);
function tipoPregunta($compile) {
    return {
        restrict: 'E',
        scope: {
            pregunta: '=',
            //valor: '='
        },
        templateUrl: '/app/directives/plantillas/TipoPregunta.html',
        link: function (scope, element, attrs) {
            scope.$watch(attrs.compile, function (newValue, oldValue) {
                element.html(newValue);
                $compile(element.contents())(scope);
            });
        }
    }
};


