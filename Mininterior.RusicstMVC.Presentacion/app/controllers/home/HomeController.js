app.controller('HomeController', ['$scope', function ($scope) {
    // ------------------- Inicio logica propia de la pagina-------------------
    $scope.hide = true;
  
    //---------CAMBIAR EL COLOR DE LA MIGA DE PAN----------------------
    //Verificar si no estamos en el home
    var location = window.location.pathname;
    if (location != '/' && location != '') {
        location = location.toUpperCase();
        var pos = location.indexOf("/HOME");
        if (pos == -1) {
            var str = $(".miga-de-pan").html();
            var menu = $(".miga-de-pan").text();
            var pos = menu.indexOf(">");
            menu = menu.substring(pos + 1);
            pos = menu.indexOf(">");
            menu = menu.substring(0, pos - 1);
            str = str.replace(menu, '<span class="estatico">' + menu + '</span>');
            $(".miga-de-pan").html(str);
        }
    };
   
    //-----FIN---------------------

    $scope.credits = [
        { value: "Vicepresidencia", background: "#64002C", link: "http://www.vicepresidencia.gov.co" },
        { value: "MinAmbiente", background: "#64002C", link: "http://www.minambiente.gov.co/" },
        { value: "MinJusticia", background: "#12169C", link: "http://www.minjusticia.gov.co/" },
        { value: "MinEducación", background: "#64002C", link: "http://www.mineducacion.gov.co" },
        { value: "MinInterior", background: "#64002C", link: "http://www.mininterior.gov.co/" },
        { value: "MinTIC", background: "#59009A", link: "http://www.mintic.gov.co" },
        { value: "Retroalimentación", background: "#999999", link: "http://retroalimentacion.somee.com/" },
    ];

    //Slides
    $scope.myInterval = 5000;
    $scope.noWrapSlides = false;
    $scope.active = 0;
    var slides = $scope.slides = [];
    var currIndex = 0;

    // Fin logica del popup de los filtro que no se desarrollara por el momento
}]);