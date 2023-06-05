app.controller('Test1Controller', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', 'uiGridExporterConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', 'uiGridExporterService', 'Excel', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, uiGridExporterConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, uiGridExporterService,Excel) {

    //------------------- Inicio logica de la grilla -------------------
    $scope.lang = 'es';
    $scope.started = true;
    $scope.isGrid = false;
    $scope.datos = [];
    $scope.arregloFinalFiltro = [];
    $scope.isTablaExportarCreada = false;
    $scope.gridApi = null;
   $scope.gridOptions = {
        columnDefs: [
          { field: 'name' },
          { field: 'gender' },
          { field: 'company' }
        ],
        //gridMenuCustomItems : [
        //       {
        //           icon: 'fa fa-file-pdf-o icono-exportacion-todos', title: 'PDF Todos',
        //           action: function ($event) {
        //               
        //               gridApi.exporter.pdfExport(uiGridExporterConstants.ALL, uiGridExporterConstants.ALL);
        //           },
        //           order: 110
        //       }, 
        //       {
        //           icon: 'fa fa-file-pdf-o icono-exportacion-vista', title: 'PDF Vista',
        //           action: function ($event) {
        //               
        //               gridApi.exporter.pdfExport(uiGridExporterConstants.VISIBLE, uiGridExporterConstants.VISIBLE);
        //           },
        //           order: 120
        //       }, 
        //       {
        //           icon: 'fa fa-file-excel-o icono-exportacion-todos icono-exportacion-excel', title: 'XLS Todos',
        //           action: function ($event) {
                        
        //               //
        //               self.exportTo(gridApi.grid, uiGridExporterConstants.ALL, uiGridExporterConstants.ALL, ',', filename, 'xls');
        //           },
        //           order: 130
        //       },
        //        {
        //            icon: 'fa fa-file-excel-o icono-exportacion-vista icono-exportacion-excel', title: 'XLS Vista',
        //            action: function ($event) {
        //                var filename = $("#titulo").text() + ' (Todos)';
        //                //
        //                //var aa = gridApi.grid.api.grouping.getGrouping.length;
        //                self.exportTo(gridApi.grid, uiGridExporterConstants.VISIBLE, uiGridExporterConstants.VISIBLE, ',', filename, 'xls');
        //            },
        //            order: 140
        //        },
        //       {
        //           icon: 'icono-exportacion-excel', title: 'CSV Todos',
        //           action: function ($event) {
        //               
        //               var filename = $("#titulo").text() + ' (Todos)';
        //               //
        //               self.exportTo(gridApi.grid, uiGridExporterConstants.ALL, uiGridExporterConstants.ALL, ';', filename, 'csv');
        //               //var myElement = angular.element(document.querySelectorAll(".custom-csv-link-location"));
        //               //$scope.gridApi.exporter.csvExport($scope.gridApi.grid, uiGridExporterConstants.ALL, myElement);
        //           },
        //           order: 150
        //       },
        //       {
        //           icon: 'icono-exportacion-vista icono-exportacion-excel', title: 'CSV Vista',
        //           action: function ($event) {
             
        //               var filename = $("#titulo").text() + ' (Vista)';
        //               //
        //               self.exportTo(gridApi.grid, uiGridExporterConstants.VISIBLE, uiGridExporterConstants.VISIBLE, ';', filename, 'txt');
        //               //var myElement = angular.element(document.querySelectorAll(".custom-csv-link-location"));
        //               //$scope.gridApi.exporter.csvExport($scope.gridApi.grid, uiGridExporterConstants.ALL, myElement);
        //           },
        //           order: 160
        //       },
        //       {
        //           icon: 'fa fa-file-text icono-exportacion-todos', title: 'TXT Todos',
        //           action: function ($event) {
               
        //               var filename = $("#titulo").text() + ' (Todos)';
        //               //
        //               self.exportTo(gridApi.grid, uiGridExporterConstants.ALL, uiGridExporterConstants.ALL, ';', filename, 'txt');
        //               //var myElement = angular.element(document.querySelectorAll(".custom-csv-link-location"));
        //               //$scope.gridApi.exporter.csvExport($scope.gridApi.grid, uiGridExporterConstants.ALL, myElement);
        //           },
        //           order: 170
        //       },
        //       {
        //           icon: 'fa fa-file-text icono-exportacion-vista', title: 'TXT Vista',
        //           action: function ($event) {
        //               
        //               var filename = $("#titulo").text() + ' (Vista)';
        //               //
        //               self.exportTo(gridApi.grid, uiGridExporterConstants.VISIBLE, uiGridExporterConstants.VISIBLE, ';', filename, 'txt');
        //               //var myElement = angular.element(document.querySelectorAll(".custom-csv-link-location"));
        //               //$scope.gridApi.exporter.csvExport($scope.gridApi.grid, uiGridExporterConstants.ALL, myElement);
        //           },
        //           order: 180
        //       },
        //],
        onRegisterApi: function (gridApi) {
            $scope.gridApi = gridApi;
            $log.log($scope.gridApi);
            gridApi.grid.options.gridMenuCustomItems = UtilsService.getMenuGridCustom(gridApi);
           
           
        },
       
   };

   $scope.gridOptions2 = {
       columnDefs: [
         { field: 'name' },
        ],
   
       onRegisterApi: function (gridApi) {
           $scope.gridApi2 = gridApi;
       },

   };

   

   $scope.excelExport = function (grid, rowTypes, colTypes, separator, filename, type ) {
      
       var self = this;
       var exportService = uiGridExporterService;
       exportService.loadAllDataIfNeeded(grid, rowTypes, colTypes).then(function () {
           //
           var exportColumnHeaders = grid.options.showHeader ? exportService.getColumnHeaders(grid, colTypes) : [];
           var exportData = exportService.getData(grid, rowTypes, colTypes);
           var csvContent = exportService.formatAsCsv(exportColumnHeaders, exportData, separator);
           var ext = '.' + type;
           if (type === 'doc') {
               ext = '.rtf';
           }
           var fileName = 'ExportedData' + ext;

           if(type === "xls"){
               formatAsExcel(exportColumnHeaders, exportData, filename, type);
           } else if (type === "rtf") {
              
               var aa = $('#TableToExport').html();
               
               formatAsRTF(exportColumnHeaders, exportData, filename, type);
               //$('#TableToExport').tableExport({ type: 'rtf', escape:'true',htmlContent:'true' });
           }
          
           self.downloadExcelDocXMLFile(fileName, csvContent, grid.grid.options.exporterOlderExcelCompatibility);
       })
   };

   formatAsRTF = function (exportColumnHeaders, exportData, filename, type) {
       
       var rtf = '{\rtf1\ansicpg1252' +
                    '{' +
                        '\fonttbl' +
                        '{\f0 Times New Roman;}' +
                        '{\f1 Arial;}' +
                    '}' +
                    '{' +
                       '\colortbl;' +
                       '\red169\green169\blue169;' +
                       '\red255\green255\blue255;' +
                       '\red0\green0\blue0;' +
                       '\red128\green128\blue128;' +
                     '}' +
                  '\sectd\paperw12240\paperh15840\margl1440\margr1440\margt1440\margb1440{\pard\overlay\posx45\posy1440\absw4365\absh-285\frmtxlrtb\pvpg\qc \brdrt\brdrs\brdrw15\brdrcf1\brdrb\brdrs\brdrw15\brdrcf1\brdrl\brdrs\brdrw15\brdrcf1\brdrr\brdrs\brdrw15\brdrcf1\cbpat2\cf3\b\f1\fs20 Tipos de Usuario\par}\sect'+
                  '}'

       ;
       
       var base64data = "base64," + base64.encode(rtf);
       window.open('data:application/' + 'txt' + ';filename=exportData;' + rtf);
       //var uri = 'data:application/txt;base64,';
       //base64 = function (s) { return $window.btoa(unescape(encodeURIComponent(s))); };
       //href = uri + base64(rtf);
   }
   
   formatAsExcel = function (exportColumnHeaders, exportData, filename, type) {
       var self = this;

       var bareHeaders = exportColumnHeaders.map(function (header) { return { value: header.displayName }; });
       var excel = '<div>';
       excel += "<table>";
       excel += "<tr>";
       angular.forEach(bareHeaders, function (value, key) {
           excel += "<th>" + value.value + "</th>";
       });
       excel += '</tr>';
       angular.forEach(exportData, function (row, key) {
           excel += "<tr>";
           angular.forEach(row, function (val, k) {
               excel += "<td>" + val.value.toString().replace(/"/g, "") + " </td>";
           });
           excel += '</tr>';
       });
       excel += '</table>'
       excel += '</div>';
    
       var exportHref = Excel.tableToExcel(excel, filename);
       $timeout(function () { location.href = exportHref; }, 100); // trigger download
 
   }

   formatRowAsExcel = function (exporter) {
       return function (row) {
           return row.map(exporter.formatFieldAsCsv);
       };
   }

   //exportToExcel = function (tableId) { // ex: '#my-table'
    
   //}

  




    $scope.gridOptions.data = [
    {
        "name": "Ethel Price",
        "gender": "female",
        "company": "Enersol dadsa jsdlahsd dasldlka dasdhasl  dasdlahsd shdahsd hasd hsakdjha djhashdsak"
    },
    {
        "name": "Claudine Neal",
        "gender": "female",
        "company": "Sealoud"
    },
    {
        "name": "Beryl Rice",
        "gender": "female",
        "company": "Velity"
    },
    {
        "name": "Wilder Gonzales",
        "gender": "male",
        "company": "Geekko"
    },
    {
        "name": "Georgina Schultz",
        "gender": "female",
        "company": "Suretech"
    },
    {
        "name": "Carroll Buchanan",
        "gender": "male",
        "company": "Ecosys"
    },
    {
        "name": "Valarie Atkinson",
        "gender": "female",
        "company": "Hopeli"
    },
    {
        "name": "Schroeder Mathews",
        "gender": "male",
        "company": "Polarium"
    },
    {
        "name": "Lynda Mendoza",
        "gender": "female",
        "company": "Dogspa"
    },
    {
        "name": "Sarah Massey",
        "gender": "female",
        "company": "Bisba"
    },
    {
        "name": "Robles Boyle",
        "gender": "male",
        "company": "Comtract"
    },
    {
        "name": "Evans Hickman",
        "gender": "male",
        "company": "Parleynet"
    },
    {
        "name": "Dawson Barber",
        "gender": "male",
        "company": "Dymi"
    },
    {
        "name": "Bruce Strong",
        "gender": "male",
        "company": "Xyqag"
    },
    {
        "name": "Nellie Whitfield",
        "gender": "female",
        "company": "Exospace"
    },
    {
        "name": "Jackson Macias",
        "gender": "male",
        "company": "Aquamate"
    },
    {
        "name": "Pena Pena",
        "gender": "male",
        "company": "Quarx"
    },
    {
        "name": "Lelia Gates",
        "gender": "female",
        "company": "Proxsoft"
    },
    {
        "name": "Letitia Vasquez",
        "gender": "female",
        "company": "Slumberia"
    },
    {
        "name": "Trevino Moreno",
        "gender": "male",
        "company": "Conjurica"
    },
    {
        "name": "Barr Page",
        "gender": "male",
        "company": "Apex"
    },
    {
        "name": "Kirkland Merrill",
        "gender": "male",
        "company": "Utara"
    },
    {
        "name": "Blanche Conley",
        "gender": "female",
        "company": "Imkan"
    },
    {
        "name": "Atkins Dunlap",
        "gender": "male",
        "company": "Comveyor"
    },
    {
        "name": "Everett Foreman",
        "gender": "male",
        "company": "Maineland"
    },
    {
        "name": "Gould Randolph",
        "gender": "male",
        "company": "Intergeek"
    },
    {
        "name": "Kelli Leon",
        "gender": "female",
        "company": "Verbus"
    },
    {
        "name": "Freda Mason",
        "gender": "female",
        "company": "Accidency"
    },
    {
        "name": "Tucker Maxwell",
        "gender": "male",
        "company": "Lumbrex"
    },
    {
        "name": "Yvonne Parsons",
        "gender": "female",
        "company": "Zolar"
    },
    {
        "name": "Woods Key",
        "gender": "male",
        "company": "Bedder"
    },
    {
        "name": "Stephens Reilly",
        "gender": "male",
        "company": "Acusage"
    },
    {
        "name": "Mcfarland Sparks",
        "gender": "male",
        "company": "Comvey"
    },
    {
        "name": "Jocelyn Sawyer",
        "gender": "female",
        "company": "Fortean"
    },
    {
        "name": "Renee Barr",
        "gender": "female",
        "company": "Kiggle"
    },
    {
        "name": "Gaines Beck",
        "gender": "male",
        "company": "Sequitur"
    },
    {
        "name": "Luisa Farrell",
        "gender": "female",
        "company": "Cinesanct"
    },
    {
        "name": "Robyn Strickland",
        "gender": "female",
        "company": "Obones"
    },
    {
        "name": "Roseann Jarvis",
        "gender": "female",
        "company": "Aquazure"
    },
    {
        "name": "Johnston Park",
        "gender": "male",
        "company": "Netur"
    },
    {
        "name": "Wong Craft",
        "gender": "male",
        "company": "Opticall"
    },
    {
        "name": "Merritt Cole",
        "gender": "male",
        "company": "Techtrix"
    },
    {
        "name": "Dale Byrd",
        "gender": "female",
        "company": "Kneedles"
    },
    {
        "name": "Sara Delgado",
        "gender": "female",
        "company": "Netagy"
    },
    {
        "name": "Alisha Myers",
        "gender": "female",
        "company": "Intradisk"
    },
    {
        "name": "Felecia Smith",
        "gender": "female",
        "company": "Futurity"
    },
    {
        "name": "Neal Harvey",
        "gender": "male",
        "company": "Pyramax"
    },
    {
        "name": "Nola Miles",
        "gender": "female",
        "company": "Sonique"
    },
    {
        "name": "Herring Pierce",
        "gender": "male",
        "company": "Geeketron"
    },
    {
        "name": "Shelley Rodriquez",
        "gender": "female",
        "company": "Bostonic"
    },
    {
        "name": "Cora Chase",
        "gender": "female",
        "company": "Isonus"
    },
    {
        "name": "Mckay Santos",
        "gender": "male",
        "company": "Amtas"
    },
    {
        "name": "Hilda Crane",
        "gender": "female",
        "company": "Jumpstack"
    },
    {
        "name": "Jeanne Lindsay",
        "gender": "female",
        "company": "Genesynk"
    },
    {
        "name": "Frye Sharpe",
        "gender": "male",
        "company": "Eplode"
    },
    {
        "name": "Velma Fry",
        "gender": "female",
        "company": "Ronelon"
    },
    {
        "name": "Reyna Espinoza",
        "gender": "female",
        "company": "Prismatic"
    },
    {
        "name": "Spencer Sloan",
        "gender": "male",
        "company": "Comverges"
    },
    {
        "name": "Graham Marsh",
        "gender": "male",
        "company": "Medifax"
    },
    {
        "name": "Hale Boone",
        "gender": "male",
        "company": "Digial"
    },
    {
        "name": "Wiley Hubbard",
        "gender": "male",
        "company": "Zensus"
    },
    {
        "name": "Blackburn Drake",
        "gender": "male",
        "company": "Frenex"
    },
    {
        "name": "Franco Hunter",
        "gender": "male",
        "company": "Rockabye"
    },
    {
        "name": "Barnett Case",
        "gender": "male",
        "company": "Norali"
    },
    {
        "name": "Alexander Foley",
        "gender": "male",
        "company": "Geekosis"
    },
    {
        "name": "Lynette Stein",
        "gender": "female",
        "company": "Macronaut"
    },
    {
        "name": "Anthony Joyner",
        "gender": "male",
        "company": "Senmei"
    },
    {
        "name": "Garrett Brennan",
        "gender": "male",
        "company": "Bluegrain"
    },
    {
        "name": "Betsy Horton",
        "gender": "female",
        "company": "Zilla"
    },
    {
        "name": "Patton Small",
        "gender": "male",
        "company": "Genmex"
    },
    {
        "name": "Lakisha Huber",
        "gender": "female",
        "company": "Insource"
    },
    {
        "name": "Lindsay Avery",
        "gender": "female",
        "company": "Unq"
    },
    {
        "name": "Ayers Hood",
        "gender": "male",
        "company": "Accuprint"
    },
    {
        "name": "Torres Durham",
        "gender": "male",
        "company": "Uplinx"
    },
    {
        "name": "Vincent Hernandez",
        "gender": "male",
        "company": "Talendula"
    },
    {
        "name": "Baird Ryan",
        "gender": "male",
        "company": "Aquasseur"
    },
    {
        "name": "Georgia Mercer",
        "gender": "female",
        "company": "Skyplex"
    },
    {
        "name": "Francesca Elliott",
        "gender": "female",
        "company": "Nspire"
    },
    {
        "name": "Lyons Peters",
        "gender": "male",
        "company": "Quinex"
    },
    {
        "name": "Kristi Brewer",
        "gender": "female",
        "company": "Oronoko"
    },
    {
        "name": "Tonya Bray",
        "gender": "female",
        "company": "Insuron"
    },
    {
        "name": "Valenzuela Huff",
        "gender": "male",
        "company": "Applideck"
    },
    {
        "name": "Tiffany Anderson",
        "gender": "female",
        "company": "Zanymax"
    },
    {
        "name": "Jerri King",
        "gender": "female",
        "company": "Eventex"
    },
    {
        "name": "Rocha Meadows",
        "gender": "male",
        "company": "Goko"
    },
    {
        "name": "Marcy Green",
        "gender": "female",
        "company": "Pharmex"
    },
    {
        "name": "Kirk Cross",
        "gender": "male",
        "company": "Portico"
    },
    {
        "name": "Hattie Mullen",
        "gender": "female",
        "company": "Zilencio"
    },
    {
        "name": "Deann Bridges",
        "gender": "female",
        "company": "Equitox"
    },
    {
        "name": "Chaney Roach",
        "gender": "male",
        "company": "Qualitern"
    },
    {
        "name": "Consuelo Dickson",
        "gender": "female",
        "company": "Poshome"
    },
    {
        "name": "Billie Rowe",
        "gender": "female",
        "company": "Cemention"
    },
    {
        "name": "Bean Donovan",
        "gender": "male",
        "company": "Mantro"
    },
    {
        "name": "Lancaster Patel",
        "gender": "male",
        "company": "Krog"
    },
    {
        "name": "Rosa Dyer",
        "gender": "female",
        "company": "Netility"
    },
    {
        "name": "Christine Compton",
        "gender": "female",
        "company": "Bleeko"
    },
    {
        "name": "Milagros Finch",
        "gender": "female",
        "company": "Handshake"
    },
    {
        "name": "Ericka Alvarado",
        "gender": "female",
        "company": "Lyrichord"
    },
    {
        "name": "Sylvia Sosa",
        "gender": "female",
        "company": "Circum"
    },
    {
        "name": "Humphrey Curtis",
        "gender": "male",
        "company": "Corepan"
    }
    ];
    

}]);

