'use strict'
app.controller('_ParcialCreditosController', ['$scope', function ($scope) {

    //Créditos
    $scope.creditos = [
        { value: "Vicepresidencia", background: "#64002C", link: "http://www.vicepresidencia.gov.co" },
        { value: "MinAmbiente", background: "#64002C", link: "http://www.minambiente.gov.co/" },
        { value: "MinJusticia", background: "#12169C", link: "http://www.minjusticia.gov.co/" },
        { value: "MinEducación", background: "#64002C", link: "http://www.mineducacion.gov.co" },
        { value: "MinInterior", background: "#64002C", link: "http://www.mininterior.gov.co/" },
        { value: "MinTIC", background: "#59009A", link: "http://www.mintic.gov.co" },
        { value: "Retroalimentación", background: "#999999", link: "http://retroalimentacion.somee.com/" },
    ];

}]);