'use strict'
app.controller('_ParcialCarruselController', ['$scope', function ($scope) {
    //Carrusel
    $scope.myInterval = 5000;
    $scope.noWrapSlides = false;
    $scope.active = 1;
    $scope.slides = [
        {
            image: 'images/prueba.jpg',
            text: 'text1',
            id: 0
        },
        {
            image: 'images/prueba2.jpg',
            text: 'text2',
            id: 1
        },
        {
            image: 'images/prueba3.jpg',
            text: 'text3',
            id: 2
        }
    ];


}]);