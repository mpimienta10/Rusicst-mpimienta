app.controller('GraficasController', ['$scope', 'APIService', 'UtilsService', '$log', '$uibModal', 'enviarDatos', '$stateParams', function ($scope, APIService, UtilsService, $log, $uibModal, enviarDatos, $stateParams) {
    $scope.enviarDatos = JSON.parse($stateParams.enviarDatos);
    $scope.datos = $scope.enviarDatos.datos;
    $scope.tipo = $scope.enviarDatos.tipo;
    $scope.filtros = $scope.enviarDatos.filtros;
    $scope.filtros[0] = $scope.filtros[0].replace(',', '')
    $scope.filtros[1] = $scope.filtros[1].replace(',', '')
    if ($scope.filtros[2]) {
        $scope.filtros[2].replace(',', '')
    } else {
        $scope.filtros[2] = 'municipio : TODOS'
    }

    $scope.registro = { tipo: 'Columnas'}
    console.log($scope.datos);

    var i = 0;
    $scope.labels = [];
    $scope.dataX = [];
    $scope.filaX = [];
    $scope.series = [];
    var serie = '';
    var i = 0;
    if ($scope.tipo === 1) {
        angular.forEach($scope.datos, function (fila) {
            var filaX = angular.copy($scope.filaX);
            for (propiedad in fila) {
               
                if (typeof fila[propiedad] == 'string') {
                    if (propiedad !== '$$hashKey') {
                        serie = serie + ' ' + fila[propiedad];
                    }


                } else if (typeof fila[propiedad] == 'number') {
                    filaX.push(fila[propiedad])
                    if (i === 0) {
                        $scope.labels.push(propiedad);
                    }
                }
            }
            i++;
            $scope.series.push(serie);
            $scope.dataX.push(filaX);
            serie = ''
        })
       
       
    } else if ($scope.tipo === 2) {
        var filaX = [];
        angular.forEach($scope.datos, function (fila) {
            var label = '';
            for (propiedad in fila) {

                if (typeof fila[propiedad] == 'string') {
                    if (propiedad !== '$$hashKey') {
                        label = label + ' ' + fila[propiedad];
                    }
                } else if (typeof fila[propiedad] == 'number') {
                    filaX.push(fila[propiedad])
                    serie = propiedad;
                }
            };
            $scope.labels.push(label)
        });
        $scope.dataX.push(filaX);
        $scope.series.push(serie);
    }


    
    console.log($scope.labels);
    console.log($scope.dataX);
    console.log($scope.series);

   
    $scope.options = {
        legend: {
            display: true,
            labels: {
                fontColor: 'black'
            }
        },
        scales: {
            xAxes: [{
                ticks: {
                    autoSkip: false,
                    maxRotation: 45,
                    minRotation: 70
                }
            }],
            yAxes: [{
                display: true,
                ticks: {
                    beginAtZero: true,
                }
            }]
        }
    };

    $scope.options2 = {
        legend: {
            display: true,
            labels: {
                fontColor: 'black'
            }
        }
    };

    $scope.onClick = function (points, evt) {
        console.log(points, evt);
    };
    $scope.datasetOverride = [{ yAxisID: 'y-axis-1' }, { yAxisID: 'y-axis-2' }];
    $scope.options3 = {
        scales: {
            xAxes: [{
                ticks: {
                    autoSkip: false,
                    maxRotation: 45,
                    minRotation: 70
                }
            }],
            yAxes: [
                {
                    id: 'y-axis-1',
                    type: 'linear',
                    display: true,
                    position: 'left'
                },
                {
                    id: 'y-axis-2',
                    type: 'linear',
                    display: true,
                    position: 'right'
                }
            ]
        }
    };

    $scope.tipoGraficas = [
        {
            tipo: 'Columnas'
        },
        {
            tipo: 'Pastel'
        },
        {
            tipo: 'Linea'
        },
        {
            tipo: 'Barra'
        },
    ]


}]);
