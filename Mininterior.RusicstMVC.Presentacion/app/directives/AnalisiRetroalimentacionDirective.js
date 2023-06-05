//Directiva para crear el índice de la encuesta
app.directive('recomendacion', recomendacion);
function recomendacion() {
    return {
        restrict: 'E',
        scope: {
            datos: '=',
            guardar: '&'
        },
        templateUrl: '/app/directives/plantillas/Recomendacion.html',
    }
}