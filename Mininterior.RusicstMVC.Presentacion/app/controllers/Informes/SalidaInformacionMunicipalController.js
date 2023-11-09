app.controller('SalidaInformacionMunicipalController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', '$timeout', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, $timeout, authService) {

    //------------------- Declaración de variables a nivel de Controller -------------------
    $scope.registro = {};
    $scope.GobernacionAlcaldias = [];
    $scope.alcaldias = [];
    $scope.mostrarReporte = false;
    $scope.cargando = null;
    $scope.encuestas;

    var autenticacion = authService.authentication;
    var url = '/api/Usuarios/Usuarios/BuscarXUsuario';
    var usuario = { UserName: autenticacion.userName };
    $scope.datosUsuario = {};
    var servCall = APIService.saveSubscriber(usuario, url);
    servCall.then(function (response) {
        if (response.data[0]) {
            $scope.datosUsuario = response.data[0];
            cargarComboDepartamentos();
        }

        cargarComboEncuesta();

    }, function (error) {
    });

    //-------------------Se carga los combos de Reporte, Departamento y Municipio------------
    function cargarComboDepartamentos() {
        if ($scope.datosUsuario.IdTipoUsuario != 3) { //ALCALDIA
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

        if ($scope.datosUsuario.IdTipoUsuario == 7) {//GOBERNACION
            $timeout(function () {
                $scope.registro.idDepartamento = $scope.datosUsuario.IdDepartamento;
                cargarMunicipios();
            }, 1000);
        }
    }

    $scope.cargarComboMunicipios = function () {
        cargarMunicipios();
    }

    function cargarMunicipios() {
        $scope.alcaldias = [];
        if ($scope.registro.idDepartamento == 0) {
            $scope.alerta = "Debe seleccionar una Gobernación o un Departamento.";
        }
        else {
            angular.forEach($scope.GobernacionAlcaldias, function (alcaldia) {
                if (alcaldia.IdDepartamento == $scope.registro.idDepartamento)
                    $scope.alcaldias.push(alcaldia);
            });
        }
    }

    function cargarComboEncuesta() {
        var url = '/api/General/Listas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent + '&idTipoEncuesta=1';
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de combo de encuestas";
        });
    }

    //------------------Se obtienen los datos------------------------------
    $scope.aceptar = function () {
        if (!$scope.validar()) return false;
        $scope.alerta = null;
        getDatos();
    };

    function getDatos() {
        $scope.cargando = true;
        $scope.datos = null;
        var url = '/api/Informes/SalidaInformacionMunicipal/';
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (response) {
            if (response.data.length > 0) {
                $scope.datos = response.data;
                $scope.nombreEncuesta = $scope.datos[0].nombreencuesta;
                $scope.nombreDepartamento = $scope.datos[0].nombredepartamento;
                $scope.nombreMunicipio = $scope.datos[0].nombremunicipio;
                obtenerDatosFormatadosPDF($scope.datos);
            } else {
                $scope.alerta = "No se encontraron datos para los criterios seleccionados";
            }

            $scope.cargando = false;
        }, function (error) {
            $scope.cargando = false;
            $scope.error = "Se generó un error en la petición";
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //-----------------Insertar texto en un string--------------------------
    String.prototype.splice = function (idx, rem, str) {
        return this.slice(0, idx) + str + this.slice(idx + Math.abs(rem));
    };

    //-------------------Obtener los datos formatados para presentación PDF---------------
    function obtenerDatosFormatadosPDF(datos) {
        $scope.datosFormatadosPDF = [];
        var maxCol = 9;
        //pageBreak: 'before'  esto coloca apartir de esa posicion en otra hoja
        var titulosSecciones = [
            [{ text: 'I. Información General del municipio', style: 'fila-seccion', colSpan: maxCol }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
            [{ text: 'II. Dinámica del Conflicto Armado', style: 'fila-seccion', colSpan: maxCol }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
            [{ text: 'III. Comités Departamentales Ampliados', style: 'fila-seccion', colSpan: maxCol, }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
            [{ text: 'IV. Herramientas de Planificación', style: 'fila-seccion', colSpan: maxCol }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
            [{ text: 'V. Participación de la Población Víctima', style: 'fila-seccion', colSpan: maxCol}, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
            [{ text: 'VI.Articulación Institucional', style: 'fila-seccion', colSpan: maxCol, }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
            [{ text: 'VII.Retornos y Reubicaciones', style: 'fila-seccion', colSpan: maxCol, }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
            [{ text: 'VIII. Adecuación Institucional', style: 'fila-seccion', colSpan: maxCol, }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
        ];

        //SECCIÓN 1
        //I. Información General del municipio
        $scope.tabla_1 = [
           [
                { text: 'Total Victimas', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10059660, colSpan: 2 }, { text: '' }, //764294
                { text: 'Total Víctimas de Desplazamiento Forzado', style: 'fila-pregunta', colSpan: 3 }, { text: '' }, { text: '' }, { text: 10059661, colSpan: 2 }//764295
                , { text: '' }
           ]
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_1, datos, maxCol, 'vertical');//ok
        $scope.tabla_1.splice(0, 0, titulosSecciones[0]);
        organizarDatos($scope.tabla_1);

        //separador de tabla        
        organizarDatos([[{ text: ' ', colSpan: maxCol }]]);

        //SECCIÓN 2
        //II. Dinámica del Conflicto Armado
        var codigos_seccion2 = ['10137657', '10047958', '10146522', '10060016', '10146554', '10146544', '10060018', '10146553'];//(764020,764021,764218,764221	,764223	,764226,764229	,764231	)
        $scope.preguntas_seccion2 = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigos_seccion2, datos, maxCol, 'vertical');
        $scope.preguntas_seccion2.splice(0, 0, titulosSecciones[1]);
        organizarDatos($scope.preguntas_seccion2);//no sale

        //SECCIÓN 3A
        //III. Comité Territorial de Justicia Transicional
        var codigos_seccion3a = ['10146940', '10147040', '10084809', '10147041', '10147134', '10084762', '10147132', '10084759', '10146894', '10059839', '10059840', '10147087', '10155883', '10116229', '10155791'];//765394,765447,765448	,765457,767822,767823	,767824,767825	,767835,767837,767838,767851,770020,770021,	770054
        $scope.tabla_seccion3a = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigos_seccion3a, datos, maxCol, 'vertical');
        $scope.tabla_seccion3a.splice(0, 0, titulosSecciones[2]);
        organizarDatos($scope.tabla_seccion3a);//se ve raro

        //separador de tabla        
        organizarDatos([[{ text: ' ', colSpan: maxCol }]]);

        $scope.tabla_seccion3c = [
           [{ text: 'Comités Departamentales Ampliados', style: 'fila-encabezado-tabla', colSpan: maxCol }],
           [{ text: 'Número de Comités Departamentales de Justicia Transicional Ampliado a los que fue convocada durante el SEMESTRE', style: 'fila-pregunta', colSpan: 5 }, { text: 10059768, colSpan: 4 }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],//767831
           [{ text: 'Número de Comités Departamentales de Justicia Transicional Ampliados a los que asistió durante el SEMESTRE', style: 'fila-pregunta', colSpan: 5 }, { text: 10059838, colSpan: 4 }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }]//767834
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_seccion3c, datos, maxCol, 'vertical');
        organizarDatos($scope.tabla_seccion3c);

        //METERLE EL subtitulo 
        $scope.tabla_titulo3 = [[{ text: ' Subcomités territoriales de justicia transicional o mesas con los que cuenta el municipio', style: 'reporte-subtitulo', colSpan: maxCol }]];
        organizarDatos($scope.tabla_titulo3);


        $scope.tabla_seccion3b = [
            [{ text: 'Subcomite Territorial de Justicia Transicional', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' },
                { text: 'Cuenta con este Subcomité', style: 'fila-encabezado-tabla' },
                { text: 'Cuenta con una secretaría técnica', style: 'fila-encabezado-tabla' },
                { text: 'Entidad que tiene a cargo la secretaría técnica', style: 'fila-encabezado-tabla' },
                { text: 'Entidades que conforman el Subcomité', style: 'fila-encabezado-tabla' },
                { text: 'Las Víctimas participan en este Subcomité', style: 'fila-encabezado-tabla' },
                { text: 'Se reunió durante el semestre', style: 'fila-encabezado-tabla' },
                { text: 'Número de veces que se reunió durante el semestre', style: 'fila-encabezado-tabla' }
            ],
            [{ text: 'Coordinación Nacional Territorial', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10155744 }, { text: 10155921 }, { text: 10071567 }, { text: 10084949 }, { text: 10146989 }, { text: 10137821 }, { text: 10047901 }],//765553,	765673,	765693,	765753,	765813,	768099,	768119
            [{ text: 'Sistemas de Información', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10155745 }, { text: 10155922 }, { text: 10071568 }, { text: 10084950 }, { text: 10146990 }, { text: 10137822 }, { text: 10047902 }],//765554,	765674,	765694,	765754,	765814,	768100,	768120
            [{ text: 'Atención y Asistencia', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10155746 }, { text: 10155904 }, { text: 10071569 }, { text: 10084951 }, { text: 10146975 }, { text: 10137823 }, { text: 10047903 }],//765555,	765675,	765695,	765755,	765815,	768101,	768121
            [{ text: 'Medidas de Rehabilitación', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10155747 }, { text: 10155905 }, { text: 10071571 }, { text: 10084952 }, { text: 10146976 }, { text: 10137824 }, { text: 10047904 }],//765556,	765676,	765696,	765756,	765816,	768102,	768122
            [{ text: 'Reparación Colectiva', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10155748 }, { text: 10155906 }, { text: 10071572 }, { text: 10084953 }, { text: 10146977 }, { text: 10137814 }, { text: 10047905 }],//765557,	765677,	765697,	765757,	765817,	768103,	768123
            [{ text: 'Restitución', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10155749 }, { text: 10155907 }, { text: 10071573 }, { text: 10084954 }, { text: 10146978 }, { text: 10137815 }, { text: 10047881 }],//765558,	765678,	765698,	765758,	765818,	768104,	768124
            [{ text: 'Indemnización Adminstrativa', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10155750 }, { text: 10155908 }, { text: 10071574 }, { text: 10084957 }, { text: 10146979 }, { text: 10137816 }, { text: 10047882 }],//765559,	765679,	765699,	765759,	765819,	768105,	768125
            [{ text: 'Medidas de Satisfacción', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10155751 }, { text: 10155909 }, { text: 10071575 }, { text: 10084958 }, { text: 10146980 }, { text: 10137817 }, { text: 10047883 }],//765560,	765680,	765700,	765760,	765820,	768106,	768126
            [{ text: 'Prevención, Protección y Garantias de no Repetición', style: 'fila-pregunta', colSpan: 2 },{ text: '' }, { text: 10155752 }, { text: 10155910 }, { text: 10071576 }, { text: 10084959 }, { text: 10146981 }, { text: 10137818 }, { text: 10047884 }],//765561,	765681,	765701,	765761,	765821,	768107,	768127
            [{ text: 'Enfoque Diferencial ', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10155753 }, { text: 10155897 }, { text: 10071577 }, { text: 10084960 }, { text: 10146982 }, { text: 10137819 }, { text: 10047885 }],//765562,	765682,	765702,	765762,	765822,	768108, 768128
            [{ text: 'Otro ¿Cuál ?', style: 'fila-pregunta' }, { text: 10070467 }, { text: 10155951 }, { text: 10155898 }, { text: 10071579 }, { text: 10084961 }, { text: 10146983 }, { text: 10137820 }, { text: 10047886 }],//765543,	765563,	765683,	765703,	765763,	765823,	768109,	768129
            [{ text: 'Otro ¿Cuál ?', style: 'fila-pregunta' }, { text: 10070468 }, { text: 10155952 }, { text: 10155899 }, { text: 10071580 }, { text: 10084962 }, { text: 10146984 }, { text: 10137806 }, { text: 10047887 }],//765544,	765564,	765684,	765704,	765764,	765824,	768110,	768130
            [{ text: 'Otro ¿Cuál ?', style: 'fila-pregunta' }, { text: 10070469 }, { text: 10155953 }, { text: 10155900 }, { text: 10071581 }, { text: 10084963 }, { text: 10146985 }, { text: 10137807 }, { text: 10047890 }],//765545,	765565,	765685,	765705,	765765,	765825,	768111,	768131
            [{ text: 'Otro ¿Cuál ?', style: 'fila-pregunta' }, { text: 10070470 }, { text: 10155954 }, { text: 10155901 }, { text: 10071582 }, { text: 10084966 }, { text: 10146986 }, { text: 10137808 }, { text: 10047891 }],//765546,	765566,	765686,	765706,	765766,	765826,	768112,	768132
            [{ text: 'Otro ¿Cuál ?', style: 'fila-pregunta' }, { text: 10070471 }, { text: 10155955 }, { text: 10155902 }, { text: 10071583 }, { text: 10084967 }, { text: 10146987 }, { text: 10137809 }, { text: 10047892 }],//765547,	765567,	765687,	765707,	765767,	765827,	768113,	768133
            [{ text: 'Otro ¿Cuál ?', style: 'fila-pregunta' }, { text: 10070472 }, { text: 10155956 }, { text: 10155903 }, { text: 10071584 }, { text: 10084968 }, { text: 10146988 }, { text: 10137810 }, { text: 10047893 }],//765548,	765568,	765688,	765708,	765768,	765828,	768114,	768134
            [{ text: 'Otro ¿Cuál ?', style: 'fila-pregunta' }, { text: 10070475 }, { text: 10155957 }, { text: 10155911 }, { text: 10071585 }, { text: 10084969 }, { text: 10146941 }, { text: 10137811 }, { text: 10047894 }],//765549,	765569,	765689,	765709,	765769,	765829,	768115,	768135
            [{ text: 'Otro ¿Cuál ?', style: 'fila-pregunta' }, { text: 10070476 }, { text: 10155944 }, { text: 10155912 }, { text: 10071587 }, { text: 10084970 }, { text: 10146942 }, { text: 10137812 }, { text: 10047895 }],//765550,	765570,	765690,	765710,	765770,	765830,	768116,	768136
            [{ text: 'Otro ¿Cuál ?', style: 'fila-pregunta' }, { text: 10070477 }, { text: 10155945 }, { text: 10155913 }, { text: 10071588 }, { text: 10084971 }, { text: 10146943 }, { text: 10137829 }, { text: 10047896 }],//765551,	765571,	765691,	765711,	765771,	765831,	768117,	768137
            [{ text: 'Otro ¿Cuál ?', style: 'fila-pregunta' }, { text: 10070478 }, { text: 10155946 }, { text: 10155914 }, { text: 10071589 }, { text: 10084972 }, { text: 10146944 }, { text: 10137830 }, { text: 10047900 }],//765552,	765572,	765692,	765712,	765772,	765832,	768118,	768138
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_seccion3b, datos, maxCol, 'vertical');
        organizarDatos($scope.tabla_seccion3b);

        //separador de tabla        
        organizarDatos([[{ text: ' ', colSpan: maxCol }]]);

        //SECCIÓN 4
        //IV. Herramientas de Planificación
        $scope.tabla_seccion4a = [
            [{ text: 'PLAN', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' },
                { text: 'Cuenta con este Plan', style: 'fila-encabezado-tabla', colSpan: 1 },
                { text: 'Fecha de Actualización del Plan', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' },
                { text: 'Plan Aprobado en el marco del Comité', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' },
                { text: 'Presupuesto destinado para la implementación de este plan en el cuatrienio 2012 - 2015', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' }                
            ],
            [{ text: 'Plan de Acción Territorial', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10146417, colSpan: 1 }, { text: 10007350, colSpan: 2 }, { text: '' }, { text: 10146354, colSpan: 2 }, { text: '' }, { text: 10016727, colSpan: 2 }, { text: '' }],//765953,	765965,	765983,	766019
            [{ text: 'Plan Integral de Prevención', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10146418, colSpan: 1 }, { text: 10007351, colSpan: 2 }, { text: '' }, { text: 10146376, colSpan: 2 }, { text: '' }, { text: 10023099, colSpan: 2 }, { text: '' }],//765954,	765966,	765984,	766020
            [{ text: 'Plan de Contingencia', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10146419, colSpan: 1 }, { text: 10007352, colSpan: 2 }, { text: '' }, { text: 10146338, colSpan: 2 }, { text: '' }, { text: 10023100, colSpan: 2 }, { text: '' }],//765955,	765967,	765985,	766021
            [{ text: 'Planes de Retorno y Reubicación', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10146426, colSpan: 1 }, { text: 10007353, colSpan: 2 }, { text: '' }, { text: 10146339, colSpan: 2 }, { text: '' }, { text: 10023101, colSpan: 2 }, { text: '' }],//765956,	765968,	765986,	766022
            [{ text: 'Plan Operativo de Sistemas de Información', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10146427, colSpan: 2 }, { text: 10007354, colSpan: 2 }, { text: '' }, { text: 10146340, colSpan: 2 }, { text: '' }, { text: 10023102, colSpan: 2 }, { text: '' }],//765957,	765969,	765987,	766023
            [{ text: 'Planes de Reparación Colectiva', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10146428, colSpan: 2 }, { text: 10007355, colSpan: 2 }, { text: '' }, { text: 10146341, colSpan: 2 }, { text: '' }, { text: 10023103, colSpan: 2 }, { text: '' }],//765958,	765970,	765988,	766024
            [{ text: 'Otro Plan', style: 'fila-pregunta', }, { text: 10146429 }, { text: 10083543, colSpan: 1 }, { text: 10007356, colSpan: 2 }, { text: '' }, { text: 10146342, colSpan: 2 }, { text: '' }, { text: 10023104, colSpan: 2 }, { text: '' }],//765962,	765959,	765971,	765989,	766025
            [{ text: 'Otro Plan', style: 'fila-pregunta', }, { text: 10146430 }, { text: 10083545, colSpan: 1 }, { text: 10007357, colSpan: 2 }, { text: '' }, { text: 10146343, colSpan: 2 }, { text: '' }, { text: 10023105, colSpan: 2 }, { text: '' }],//765963,	765960,	765972,	765990,	766026
            [{ text: 'Otro Plan', style: 'fila-pregunta', }, { text: 10146431 }, { text: 10083546, colSpan: 1 }, { text: 10007358, colSpan: 2 }, { text: '' }, { text: 10146344, colSpan: 2 }, { text: '' }, { text: 10023106, colSpan: 2 }, { text: '' }],  //    765964,	765961,	765973, 765991,	766027      
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_seccion4a, datos, maxCol, 'vertical');
        $scope.tabla_seccion4a.splice(0, 0, titulosSecciones[3]);
        organizarDatos($scope.tabla_seccion4a);

        //METERLE EL subtitulo 
        $scope.tabla_titulo4 = [[{ text: ' Contenido del Plan de Acción Territorial', style: 'reporte-subtitulo', colSpan: maxCol }]];
        organizarDatos($scope.tabla_titulo4);

        var codigos_seccion4b = ['10155422', '10155423', '10155424', '10155425', '10155426'];//766044,766045,766046,766047,766048
        $scope.preguntas_seccion4b = UtilsService.funcionesReportes('obtenerPreguntasXCodigo2', codigos_seccion4b, datos, maxCol, 'vertical');
        organizarDatos($scope.preguntas_seccion4b);//no se ve

        //SECCION 5
        //. Participación de la Población Víctima
        var codigos_seccion5 = ['10128147', '10036074', '10138347', '10138323', '10138307', '10138308', '10138309', '10138310', '10102087', '10070842'];//767044,767045	,767526,767584,767585,767586,767588	,767587,767589	,767565
        $scope.preguntas_seccion5 = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigos_seccion5, datos, maxCol, 'vertical');
        $scope.preguntas_seccion5.splice(0, 0, titulosSecciones[4]);
        organizarDatos($scope.preguntas_seccion5);

        //METERLE EL subtitulo 
        $scope.tabla_titulo5 = [[{ text: ' Participación de Minorías Étnicas en la Mesa de Participación', style: 'reporte-subtitulo', colSpan: maxCol }]];
        organizarDatos($scope.tabla_titulo5);

        $scope.tabla_seccion5a = [
           [{ text: 'Representantes de las Organizaciones de Víctimas de Pueblos y Comunidades Indígenas', style: 'fila-encabezado-tabla', colSpan: 3 }, { text: '' }, { text: '' },
               { text: 'Representantes de las Organizaciones de Víctimas de las Comunidades negras, afrocolombianas, raizales y palenqueras', style: 'fila-encabezado-tabla', colSpan: 3 }, { text: '' }, { text: '' },
               { text: 'Representantes de las Organizaciones de Víctimas del Pueblo Rrom o Gitano', style: 'fila-encabezado-tabla', colSpan: 3 }, { text: '' }, { text: '' }                
           ],
           [{ text: 10138322, colSpan: 3 }, { text: '' }, { text: '' }, { text: 10138314, colSpan: 3 }, { text: '' }, { text: '' }, { text: 10138315, colSpan: 3 }, { text: '' }, { text: '' }]//767567,767568,767569
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_seccion5a, datos, maxCol, 'vertical');
        organizarDatos($scope.tabla_seccion5a);

        //METERLE EL subtitulo 
        $scope.tabla_titulo5a = [[{ text: 'Participación en la Mesa de Participación con Enfoque diferencial ', style: 'reporte-subtitulo', colSpan: maxCol }]];
        organizarDatos($scope.tabla_titulo5a);

        $scope.tabla_seccion5b = [
           [{ text: 'Mujeres', style: 'fila-encabezado-tabla' },
               { text: 'Jóvenes', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' },
               { text: 'Personas Mayores', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' },
               { text: 'LGBTI', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' },
               { text: 'Personas en condición de discapacidad', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' }              
           ],
           [{ text: 10138320 }, { text: 10138321, colSpan: 2 }, { text: '' }, { text: 10138316, colSpan: 2 }, { text: '' }, { text: 10138317, colSpan: 2 }, { text: '' }, { text: 10138318, colSpan: 2 }, { text: '' }]//767573,	767574	,767575,	767576	,767577
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_seccion5b, datos, maxCol, 'vertical');
        organizarDatos($scope.tabla_seccion5b);

        var codigos_seccion5b = ['10138348', '10155676', '10155665'];//767527,768415,768428
        $scope.preguntas_seccion5b = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigos_seccion5b, datos, maxCol, 'vertical');
        organizarDatos($scope.preguntas_seccion5b);

        //SECCION 6
        //VI.Articulación Institucional
        var codigos_seccion6 = ['10147086', '10084768', '10147126', '10147128', '10128919', '10128915'];//767713,767714	,767718,767716,768444,768449
        $scope.preguntas_seccion6 = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigos_seccion6, datos, maxCol, 'vertical');
        $scope.preguntas_seccion6.splice(0, 0, titulosSecciones[5]);
        organizarDatos($scope.preguntas_seccion6);//no se ven

        $scope.tabla_seccion6 = [
           [{ text: 'Alcaldía', style: 'fila-encabezado-tabla', colSpan: maxCol }],
           [{ text: 'Conoce la estrategia de acompañamiento técnico a las entidades territoriales, liderada por la gobernación', colSpan: 7 },  { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' },{ text: 10128916, colSpan: 2 }, { text: '' }]//768450
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_seccion6, datos, maxCol, 'vertical');
        organizarDatos($scope.tabla_seccion6);

        //separador de tabla        
        organizarDatos([[{ text: ' ', colSpan: maxCol }]]);


        var codigos_seccion6a = ['10128930', '10128928', '10128960'];//768465,768473,768493
        $scope.preguntas_seccion6a = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigos_seccion6a, datos, maxCol, 'vertical');
        organizarDatos($scope.preguntas_seccion6a);

        //SECCION7
        //VII. Retornos y Reubicaciones
        var codigos_seccion7a = ['10137418', '10048024', '10035385', '10155587', '10155588','10069437', '10069438', '10155605'];//767742,767743,767733,767751,767753,767750,767752,767758
        $scope.preguntas_seccion7a = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigos_seccion7a, datos, maxCol, 'vertical');
        $scope.preguntas_seccion7a.splice(0, 0, titulosSecciones[6]);
        organizarDatos($scope.preguntas_seccion7a);

        //SECCION8
        //VIII. Adecuación Institucional
        var codigos_seccion8a = ['10128963', '10116298', '10155830', '10071754'];//769586,769587	,769717,769718	
        $scope.preguntas_seccion8a = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigos_seccion8a, datos, maxCol, 'vertical');
        $scope.preguntas_seccion8a.splice(0, 0, titulosSecciones[7]);
        organizarDatos($scope.preguntas_seccion8a);

        $scope.tabla_seccion8 = [
           [{ text: 'Recursos con los que cuenta la alcaldía para la implementación de la Política Pública Víctimas del conflicto armado', style: 'fila-encabezado-tabla', colSpan: maxCol }],
           [{ text: 'Oficinas (espacio físico o instalaciones)', colSpan: 7, style: 'fila-pregunta' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: 10155793, colSpan: 2 }, { text: '' }],//768450
           [{ text: 'Equipos de cómputo y comunicación', colSpan: 7, style: 'fila-pregunta' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: 10155794, colSpan: 2 }, { text: '' }],//768450
           [{ text: 'Acceso a internet', colSpan: 7, style: 'fila-pregunta' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: 10155795, colSpan: 2 }, { text: '' }],//768450
           [{ text: 'Papelería y materiales de oficina', colSpan: 7, style: 'fila-pregunta' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: 10155877, colSpan: 2 }, { text: '' }],//768450
           [{ text: 'Albergues temporales', colSpan: 7, style: 'fila-pregunta' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: 10128949, colSpan: 2 }, { text: '' }],//768450
           [{ text: 'Servicio de energía eléctrico', colSpan: 7, style: 'fila-pregunta' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: 10155878, colSpan: 2 }, { text: '' }]//768450
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_seccion8, datos, maxCol, 'vertical');
        organizarDatos($scope.tabla_seccion8);

        //separador de tabla        
        organizarDatos([[{ text: ' ', colSpan: maxCol }]]);

        var codigos_seccion8b = ['10155847', '10155851', '10128860'];//769844,769848,769999
        $scope.preguntas_seccion8b = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigos_seccion8b, datos, maxCol, 'vertical');
        organizarDatos($scope.preguntas_seccion8b);

        //METERLE EL subtitulo 
        $scope.tabla_titulo8a = [[{ text: 'Estrategias de Atención Complementarias implementadas por el municipio', style: 'reporte-subtitulo', colSpan: maxCol }]];
        organizarDatos($scope.tabla_titulo8a);

        $scope.tabla_seccion8b = [
                  [{ text: '_', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' },
                      { text: 'Cuenta con esta estrategia', style: 'fila-encabezado-tabla', colSpan: 1 },
                      { text: 'Funciones Principales', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' },
                      { text: 'Periodicidad de Atención', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' },
                      { text: 'Entidades que hacen parte del Punto de Atención', style: 'fila-encabezado-tabla', colSpan: 2 } , { text: '' }                     
                  ],
                  [{ text: 'Esquemas móviles', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10155836, colSpan: 1 }, { text: 10071733, colSpan: 2 }, { text: '' }, { text: 10155865, colSpan: 2 }, { text: '' }, { text: 10071727, colSpan: 2 }, { text: '' }],//769857,	769866,	769874,	769882
                  [{ text: 'Enlace municipal', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10155837, colSpan: 1 }, { text: 10071734, colSpan: 2 }, { text: '' }, { text: 10155859, colSpan: 2 }, { text: '' }, { text: 10071728, colSpan: 2 }, { text: '' }],//769858,	769867,	769875,	769883 
                  [{ text: 'Enlace con las organizaciones de víctimas', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10155838, colSpan: 1 }, { text: 10071735, colSpan: 2 }, { text: '' }, { text: 10155860, colSpan: 2 }, { text: '' }, { text: 10071729, colSpan: 2 }, { text: '' }],//769859,	769868,	769876,	769884
                  [{ text: 'Atención telefónica', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10155839, colSpan: 1 }, { text: 10071738, colSpan: 2 }, { text: '' }, { text: 10155861, colSpan: 2 }, { text: '' }, { text: 10071730, colSpan: 2 }, { text: '' }],//769860,	769869,	769877,	769885
                  [{ text: 'Punto de Atención', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10155840, colSpan: 1 }, { text: 10071739, colSpan: 2 }, { text: '' }, { text: 10155862, colSpan: 2 }, { text: '' }, { text: 10071731, colSpan: 2 }, { text: '' }],//769861,	769870,	769878,	769886
                  [{ text: 'Centro Regional', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10155841, colSpan: 1 }, { text: 10071740, colSpan: 2 }, { text: '' }, { text: 10155863, colSpan: 2 }, { text: '' }, { text: 10071257, colSpan: 2 }, { text: '' }],//769862,	769871,	769879,	769887
                  [{ text: 'Traductores étnicos', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10155845, colSpan: 1 }, { text: 10071741, colSpan: 2 }, { text: '' }, { text: 10155864, colSpan: 2 }, { text: '' }, { text: 10071258, colSpan: 2 }, { text: '' }],//769863, 769872,	769880,	769888
                  [{ text: 'Otro ¿Cuál?', colSpan: 1, style: 'fila-pregunta' }, { text: 10155846, colSpan: 1 }, { text: 10071732, colSpan: 1 }, { text: 10071742, colSpan: 2 }, { text: '' }, { text: 10155869, colSpan: 2 }, { text: '' }, { text: 10071259, colSpan: 2 }, { text: '' }]//769865,	769864,	769873,	769881,	769889
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_seccion8b, datos, maxCol, 'vertical');
        organizarDatos($scope.tabla_seccion8b);        
        return true;
    }

    function organizarDatos(columnas) {
        for (var i = 0; i < columnas.length; i++) {
            $scope.datosFormatadosPDF.push(columnas[i]);
        }
    }

    function insertarColumnas(columnasOriginal, ColumnasXInsertar, index) {
        var long = ColumnasXInsertar.length;
        for (var i = 0; i < long; i++) {
            columnasOriginal.splice(index, 0, ColumnasXInsertar[i]);
        }
    }

    //------------------------EXPORTAR---------------------------------------
    $scope.exportar = function () {
        printJson();
    }

    function printJson() {        
        $scope.definiciones = UtilsService.getDefinicionesReportesEjecutivos();
        var docDefinition = {
            compress: false,
            pageMargins: [50, 170, 50, 50],
            pageSize: 'A4',
            header: function () {
                var header = [
                    $scope.definiciones.logosEncabezado,
                    {
                        style: 'tableHeader1',
                        table: {
                            widths: ['*'],
                            body: [
                                [{text: 'SALIDA DE INFORMACIÓN MUNICIPAL', fillColor: $scope.definiciones.colorInstitucional}],
                                [{  text: $scope.nombreEncuesta, style: 'fila-titulo-1'}],
                                [{ text: 'REPORTE UNIFICADO DEL SISTEMA DE INFORMACIÓN, COORDINACIÓN Y SEGUIMIENTO TERRITORIAL DE LA POLÍTICA PÚBLICA DE VÍCTIMAS - RUSICST', style: 'fila-titulo-2' }],
                            ]
                        }, layout: UtilsService.getLayout('header')
                    },
                    {
                        text: 'A continuación encontrará algunos datos cuantitativos sobre el total de los municipios por cada uno de los departamentos, que reportaron información con respecto al Diseño, \n la Implementación y la Evaluación de la Política'
                        + 'Pública de Víctimas en el RUSICST durante el periodo seleccionado. \n\n',
                        style: 'fila-titulo-3',
                    },
                    {
                        style: 'fila-departamento',
                        table: {
                            //widths: ['*', '*'],
                            body: [
                                [{ text: 'Departamento', }, { text: $scope.nombreDepartamento, fillColor: 'white' }, { text: 'Municipio', }, { text: $scope.nombreMunicipio, fillColor: 'white' }],
                            ]
                        }, layout: UtilsService.getLayout('tabla')
                    },
                ];
                return header;
            },
            footer: function (currentPage, pageCount) {
                return {
                    stack: [
                        {
                            fontSize: 7,
                            margin: [50, 20, 50, 20],
                            columns: [
                            {
                            },
                            {
                                text: currentPage.toString(), alignment: 'center'
                            },
                            { text: "Fecha de generación: " + new Date().toLocaleString(), alignment: 'right', }
                            ]
                        }]
                };
            },
            content: [
                {
                    fontSize: 7,
                    table: {
                        body: $scope.datosFormatadosPDF
                    },
                    layout: UtilsService.getLayout('preguntasRespuestas')
                },
            ],
            styles: $scope.definiciones.estilos
        }

        var date = new Date();
        date = moment(date).format('DD_MMM_YYYY_HH_mm_ss');
        pdfMake.createPdf(docDefinition).download('PDF_' + date + '.pdf');
    }
}]);