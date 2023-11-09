app.controller('SalidaInformacionGobernacionController', ['$scope', 'APIService', 'UtilsService', 'i18nService', '$http', 'uiGridConstants', '$interval', 'uiGridGroupingConstants', '$log', '$uibModal', 'authService', function ($scope, APIService, UtilsService, i18nService, $http, uiGridConstants, $interval, uiGridGroupingConstants, $log, $uibModal, authService) {
    //------------------- Inicio logica de filtros de la pantalla -------------------
    $scope.filtro = {};
    $scope.registro = {};
    $scope.started = true;
    $scope.mostrarReporte = false;
    $scope.cargoDatos = true;
    $scope.GobernacionAlcaldias = [];
    $scope.alcaldias = [];
    $scope.columnDefsFijas = [];
    $scope.errorMessages = UtilsService.getErrorMessages();

    var autenticacion = authService.authentication;
    var url = '/api/Usuarios/Usuarios/BuscarXUsuario';
    var usuario = { UserName: autenticacion.userName };
    $scope.datosUsuario = {};
    var servCall = APIService.saveSubscriber(usuario, url);
    servCall.then(function (response) {
        if (response.data[0]) {
            $scope.datosUsuario = response.data[0];
            if ($scope.datosUsuario.IdTipoUsuario == 7)
                $scope.registro.IdDepartamento = $scope.datosUsuario.IdDepartamento;
            else
                cargarComboDepartamentos();
        }
        cargarComboEncuesta();
    }, function (error) {
    });

    function cargarComboDepartamentos() {
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
            $scope.error = "Se generó un error en la petición";
        });
    }

    function cargarComboEncuesta() {
        var url = '/api/General/Listas/Encuestas?audUserName=' + authService.authentication.userName + '&userNameAddIdent=' + authService.authentication.userNameAddIdent + '&idTipoEncuesta=2';
        var servCall = APIService.getSubs(url);
        servCall.then(function (response) {
            $scope.encuestas = response;
        }, function (error) {
            $scope.error = "Se generó un error en la petición de combo de encuestas";
        });
    }

    $scope.filtrar = function () {
        if (!$scope.validar()) return false;
        $scope.alerta = null;
        $scope.cargoDatos = false;
        getDatos();
        $scope.submitted = false;
    };

    var getDatos = function () {
        $scope.datos = null;
        var url = '/api/Informes/SalidaInformacionGobernacion/';
        var servCall = APIService.saveSubscriber($scope.registro, url);
        servCall.then(function (response) {
            $scope.cargoDatos = true;
            if (response.data.length > 0) {
                $scope.datos = response.data;
                $scope.nombreEncuesta = response.data[0].nombreencuesta;
                $scope.nombreDepartamento = response.data[0].nombredepartamento;
                obtenerDatosFormatados(angular.copy($scope.datos));
            } else {
                $scope.alerta = "No se encontraron datos para los criterios seleccionados";
            }
        }, function (error) {
            $scope.error = "Se generó un error en la petición";
        });
    }

    $scope.validar = function () {
        return $scope.myForm.$valid;
    };

    //-----------------------CREAR INFORME---------------------------------
    function getDatosFormatadosHtml(datos) {

    }

    //------------------------EXPORTAR---------------------------------------
    $scope.exportar = function () {
        printJson();
    }

    //----------------------FIN EXPORTAR-------------------------------------


    function obtenerDatosFormatados(datos) {
        var maxCol = 9;
        $scope.datosFormatadosPDF = [];

        var titulosSecciones = [
            [{ text: 'I. Información General de la Gobernación', colSpan: maxCol, style: 'fila-seccion' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
            [{ text: 'II. Comité Territorial de Justicia Transicional', style: 'fila-seccion', colSpan: maxCol }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
            [{ text: 'III. Herramientas de Planificación', style: 'fila-seccion', colSpan: maxCol }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
            [{ text: 'IV. Participación de la Población Víctima', style: 'fila-seccion', colSpan: maxCol }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
            [{ text: 'V.Articulación Institucional', style: 'fila-seccion', colSpan: maxCol }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
            [{ text: 'VI.Adecuación Institucional', style: 'fila-seccion', colSpan: maxCol }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }],
        ];
        //---logica para traer los datos necesarios para colocar en el pdf
        //select a.CodigoPregunta 'Codigo_colocar_js', b.IdPreguntaAnterior  'Codigo_Excel_Olimpo', c.Nombre 'pregunta' FROM  BancoPreguntas.PreguntaModeloAnterior b 
        //join BancoPreguntas.Preguntas a on b.IdPregunta = a.IdPregunta
        //JOIN Pregunta c WITH (NOLOCK) ON b.IdPreguntaAnterior = c.Id
        //--I. Información General de la Gobernación
        //--where  b.IdPreguntaAnterior in ('772080', '772081')
        //--II. Comité Territorial de Justicia Transicional
        //--where  b.IdPreguntaAnterior in ('772202','772255','772256','772265','775222','775224', '775225','775238')
        //--Comités Departamentales Ampliados
        //--where  b.IdPreguntaAnterior in ('774959','774961','777074','777075','777077','777078','774951','774952','774951','774954','777035','777036','777069')
        //-- Subcomités departamentales con los que cuenta la Gobernación					
        //--Coordinación Nacional Territorial	
        //--where  b.IdPreguntaAnterior in	('772361','772481',	'772501'	,'772561',	'772621'	,'775486'	,'775506')
        //--Sistemas de Información		
        //--where  b.IdPreguntaAnterior in	(772362,	772482	,772502	,772562	,772622,	775487	,775507)
        //--Atención y Asistencia		
        //--where  b.IdPreguntaAnterior in	(772363	,772483	,772503,	772563,	772623,	775488	,775508)
        //--Medidas de Rehabilitación		
        //--where  b.IdPreguntaAnterior in	(772364	,772484,	772504,	772564,	772624,	775489	,775509)--
        //--Reparación Colectiva		
        //--where  b.IdPreguntaAnterior in	(772365,	772485,	772505,	772565,	772625	,775490,	775510)
        //--Restitución		
        //--where  b.IdPreguntaAnterior in	(772366,	772486,	772506,	772566,	772626,	775491,	775511)
        //--Indemnización Adminstrativa		
        //--where  b.IdPreguntaAnterior in	(772367	,772487,	772507,	772567,	772627,	775492,	775512)
        //--Medidas de Satisfacción		
        //--where  b.IdPreguntaAnterior in	(772368	,772488,	772508,	772568,	772628,	775493,	775513)
        //--Prevención, Protección y Garantias de no Repetición		
        //where  b.IdPreguntaAnterior in(772369,	772489,	772509,	772569	,772629,	775494,	775514)
        //--Enfoque Diferencial		772370	772490	772510	772570	772630	775495	775515

        //SECCIÓN 1
        //I. Información General de la Gobernación       
        $scope.tabla_1 = [
          [
               { text: 'Total Victimas', style: 'fila-pregunta', colSpan: 2 }, { text: '' }, { text: 10048041, colSpan: 2 }, { text: '' },//764294
               { text: 'Total Víctimas de Desplazamiento Forzado', style: 'fila-pregunta', colSpan: 3 }, { text: '' }, { text: '' }, { text: 10048042, colSpan: 2 }, { text: '' }//764295
          ]
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_1, datos, maxCol, 'vertical');//ok
        $scope.tabla_1.splice(0, 0, titulosSecciones[0]);
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_1)

        //SECCIÓN2
        //II. Comité Territorial de Justicia Transicional
        //where  b.IdPreguntaAnterior in ('772202','772255','772256','772265','775222','775224', '775225','775238')
        var codigosPreguntas_2 = ['10137572', '10129313', '10117083', '10129312', '10147694', '10059561', '10059562', '10147689'];
        $scope.preguntas_seccion2 = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigosPreguntas_2, datos, maxCol, 'vertical');
        $scope.preguntas_seccion2.splice(0, 0, titulosSecciones[1]);//este coloca el titulo dela seccion principal
         organizarDatos($scope.datosFormatadosPDF, $scope.preguntas_seccion2)

        //METERLE EL subtitulo 
        $scope.tabla_titulo1 = [[{ text: 'Comités Departamentales Ampliados', style: 'reporte-subtitulo', colSpan: maxCol }]];
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_titulo1)

        //Comités Departamentales Ampliados         
        var codigosPreguntas_cda = ['10129297', '10117096', '10117097', '10129301', '10035330', '10156126', '10072193', '10156106', '10156116', '10023227', '10156117', '10072646'];//where  b.IdPreguntaAnterior in ('774959','774961','777074','777075','777077','777078','774951','774952','774951','774954','777035','777036','777069')
        $scope.preguntas_seccion2 = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigosPreguntas_cda, datos, maxCol, 'vertical');
        organizarDatos($scope.datosFormatadosPDF, $scope.preguntas_seccion2)

        //METERLE EL subtitulo 
        $scope.tabla_titulo1 = [[{ text: 'Subcomités departamentales con los que cuenta la Gobernación', style: 'reporte-subtitulo', colSpan: maxCol }]];
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_titulo1)

        //tabla_2: se pinta en el html
        $scope.tabla_2 = [
            [
                { text: 'Subcomité Departamental de Justicia Transicional', style: 'fila-encabezado-tabla', colSpan: 2 }
                , { text: '', style: 'fila-encabezado-tabla', border: [false, false, false, false] }
                , { text: 'Cuenta con este Subcomité', style: 'fila-encabezado-tabla' }
                , { text: 'Cuenta con una secretaría técnica', style: 'fila-encabezado-tabla' }
                , { text: 'Entidad que tiene a cargo la secretaría técnica', style: 'fila-encabezado-tabla' }
                , { text: 'Entidades que conforman el Subcomité', style: 'fila-encabezado-tabla' }
                , { text: 'Las Víctimas participan en este Subcomité', style: 'fila-encabezado-tabla' }
                , { text: 'Se reunió durante el semestre', style: 'fila-encabezado-tabla' }
                , { text: 'Número de veces que se reunió durante el semestre', style: 'fila-encabezado-tabla' }
            ],
            [{ text: 'Coordinación Nacional Territorial', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10129104 }, { text: 10129060 }, { text: 10117345 }, { text: 10117341 }, { text: 10129143 }, { text: 10129383 }, { text: 10035338 }],//where  b.IdPreguntaAnterior in	('772361','772481',	'772501'	,'772561',	'772621'	,'775486'	,'775506')
            [{ text: 'Sistemas de Información', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10129105 }, { text: 10129061 }, { text: 10117276 }, { text: 10117342 }, { text: 10129144 }, { text: 10129384 }, { text: 10035340 }],//where  b.IdPreguntaAnterior in	(772362,	772482	,772502	,772562	,772622,	775487	,775507)
            [{ text: 'Atención y Asistencia', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10129108 }, { text: 10129062 }, { text: 10117277 }, { text: 10117343 }, { text: 10129145 }, { text: 10129385 }, { text: 10035341 }],//where  b.IdPreguntaAnterior in	(772363	,772483	,772503,	772563,	772623,	775488	,775508)
            [{ text: 'Medidas de Rehabilitación', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10129109 }, { text: 10129063 }, { text: 10117278 }, { text: 10117344 }, { text: 10129146 }, { text: 10129386 }, { text: 10035342 }],//where  b.IdPreguntaAnterior in	(772364	,772484,	772504,	772564,	772624,	775489	,775509)
            [{ text: 'Reparación Colectiva', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10129110 }, { text: 10129064 }, { text: 10117279 }, { text: 10117259 }, { text: 10129147 }, { text: 10129387 }, { text: 10035343 }],//where  b.IdPreguntaAnterior in	(772365,	772485,	772505,	772565,	772625	,775490,	775510)
            [{ text: 'Restitución', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10129111 }, { text: 10129065 }, { text: 10117280 }, { text: 10117260 }, { text: 10129148 }, { text: 10129388 }, { text: 10035344 }],//where  b.IdPreguntaAnterior in	(772366,	772486,	772506,	772566,	772626,	775491,	775511)
            [{ text: 'Indemnización Adminstrativa', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10129112 }, { text: 10129066 }, { text: 10117281 }, { text: 10117261 }, { text: 10129149 }, { text: 10129389 }, { text: 10035345 }],//where  b.IdPreguntaAnterior in	(772367	,772487,	772507,	772567,	772627,	775492,	775512)
            [{ text: 'Medidas de Satisfacción', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10129113 }, { text: 10129069 }, { text: 10117282 }, { text: 10117262 }, { text: 10129150 }, { text: 10129390 }, { text: 10035346 }],//where  b.IdPreguntaAnterior in	(772368	,772488,	772508,	772568,	772628,	775493,	775513)
            [{ text: 'Prevención, Protección y Garantias de no Repetición', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10129114 }, { text: 10129070 }, { text: 10117283 }, { text: 10117263 }, { text: 10129151 }, { text: 10129391 }, { text: 10035347 }],//where  b.IdPreguntaAnterior in(772369	772489	772509	772569	772629	775494	775514)
            [{ text: 'Enfoque Diferencial', colSpan: 2, style: 'fila-pregunta' }, { text: '' }, { text: 10129115 }, { text: 10129071 }, { text: 10117284 }, { text: 10117264 }, { text: 10129152 }, { text: 10129392 }, { text: 10035348 }],//where  b.IdPreguntaAnterior in(772370,	772490,	772510	,772570	,772630,	775495,	775515)
            [{ text: 'Otro ¿Cuál?', colSpan: 1, style: 'fila-pregunta', border: [true, true, false, true] }, { text: 10117356, border: [false, true, false, true] }, { text: 10129116 }, { text: 10129072 }, { text: 10117285 }, { text: 10117265 }, { text: 10129153 }, { text: 10129393 }, { text: 10035349 }],//(772351,	772371,	772491,	772511,	772571,	772631,	775496,	775516)
            [{ text: 'Otro ¿Cuál?', colSpan: 1, style: 'fila-pregunta', border: [true, true, false, true] }, { text: 10117357, border: [false, true, false, true] }, { text: 10129117 }, { text: 10129073 }, { text: 10117286 }, { text: 10117268 }, { text: 10129154 }, { text: 10129394 }, { text: 10035350 }],//(772352,	772372,	772492,	772512,	772572,	772632,	775497,	775517)
            [{ text: 'Otro ¿Cuál?', colSpan: 1, style: 'fila-pregunta', border: [true, true, false, true] }, { text: 10117358, border: [false, true, false, true] }, { text: 10129118 }, { text: 10129074 }, { text: 10117287 }, { text: 10117269 }, { text: 10129155 }, { text: 10129395 }, { text: 10035351 }],//(772353,	772373,	772493,	772513,	772573,	772633,	775498,	775518)
            [{ text: 'Otro ¿Cuál?', colSpan: 1, style: 'fila-pregunta', border: [true, true, false, true] }, { text: 10117359, border: [false, true, false, true] }, { text: 10129119 }, { text: 10129075 }, { text: 10117288 }, { text: 10117270 }, { text: 10129156 }, { text: 10129396 }, { text: 10035352 }],//(772354,	772374,	772494,	772514,	772574,	772634,	775499,	775519)
            [{ text: 'Otro ¿Cuál?', colSpan: 1, style: 'fila-pregunta', border: [true, true, false, true] }, { text: 10117360, border: [false, true, false, true] }, { text: 10129120 }, { text: 10129078 }, { text: 10117289 }, { text: 10117271 }, { text: 10129157 }, { text: 10129399 }, { text: 10035353 }],//(772355,	772375,	772495,	772515,	772575,	772635,	775500,	775520)
            [{ text: 'Otro ¿Cuál?', colSpan: 1, style: 'fila-pregunta', border: [true, true, false, true] }, { text: 10117362, border: [false, true, false, true] }, { text: 10129121 }, { text: 10129079 }, { text: 10117290 }, { text: 10117272 }, { text: 10129158 }, { text: 10129400 }, { text: 10035333 }],//(772356,	772376,	772496,	772516,	772576,	772636,	775501,	775521)
            [{ text: 'Otro ¿Cuál?', colSpan: 1, style: 'fila-pregunta', border: [true, true, false, true] }, { text: 10117363, border: [false, true, false, true] }, { text: 10129136 }, { text: 10129080 }, { text: 10117291 }, { text: 10117273 }, { text: 10129159 }, { text: 10129401 }, { text: 10035334 }],//(772357,	772377,	772497,	772517,	772577,	772637,	775502,	775522)
            [{ text: 'Otro ¿Cuál?', colSpan: 1, style: 'fila-pregunta', border: [true, true, false, true] }, { text: 10117364, border: [false, true, false, true] }, { text: 10129137 }, { text: 10129081 }, { text: 10117292 }, { text: 10117274 }, { text: 10129160 }, { text: 10129402 }, { text: 10035335 }],//(772358,	772378,	772498,	772518,	772578,	772638,	775503,	775523)
            [{ text: 'Otro ¿Cuál?', colSpan: 1, style: 'fila-pregunta', border: [true, true, false, true] }, { text: 10117365, border: [false, true, false, true] }, { text: 10129138 }, { text: 10129082 }, { text: 10117293 }, { text: 10117349 }, { text: 10129161 }, { text: 10129403 }, { text: 10035336 }],//(772359,	772379,	772499,	772519,	772579,	772639,	775504,	775524)
            [{ text: 'Otro ¿Cuál?', colSpan: 1, style: 'fila-pregunta', border: [true, true, false, true] }, { text: 10117366, border: [false, true, false, true] }, { text: 10129139 }, { text: 10129083 }, { text: 10117294 }, { text: 10117350 }, { text: 10129162 }, { text: 10129404 }, { text: 10035337 }],

        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_2, datos, maxCol, 'vertical');
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_2)

        
        //SECCIÓN 3
        //III. Herramientas de Planificación
        //tabla
        $scope.tabla_3 = [
            [
                { text: 'PLAN DEPARTAMENTAL', style: 'fila-encabezado-tabla', colSpan: 4 }, { text: '' }, { text: '' }, { text: '' },
                { text: 'Cuenta con este Plan', style: 'fila-encabezado-tabla' },
                { text: 'Fecha de Actualización del Plan', style: 'fila-encabezado-tabla' },
                { text: 'Plan Aprobado en el marco del Comité', style: 'fila-encabezado-tabla' },
                { text: 'Presupuesto destinado para la implementación de este plan en el cuatrienio 2012 - 2015', style: 'fila-encabezado-tabla', colSpan: 2 }, { text: '' }
            ],
            [{ text: 'Plan de Acción Territorial', colSpan: 4, style: 'fila-pregunta' }, { text: '' }, { text: '' }, { text: '' }, { text: 10147354 }, { text: 10007307 }, { text: 10147361 }, { text: 10029375, colSpan: 2 }, { text: '' }],//(772880,	772890,	772904,	772932)
            [{ text: 'Plan Integral de Prevención', colSpan: 4, style: 'fila-pregunta' }, { text: '' }, { text: '' }, { text: '' }, { text: 10147355 }, { text: 10007308 }, { text: 10147362 }, { text: 10029376, colSpan: 2 }, { text: '' }],//(772881,	772891,	772905,	772933)
            [{ text: 'Plan de Contingencia', colSpan: 4, style: 'fila-pregunta' }, { text: '' }, { text: '' }, { text: '' }, { text: 10147356 }, { text: 10007309 }, { text: 10147363 }, { text: 10029377, colSpan: 2 }, { text: '' }],//(772882,	772892,	772906,	772934)
            [{ text: 'Plan Operativo de Sistemas de Información', colSpan: 4, style: 'fila-pregunta' }, { text: '' }, { text: '' }, { text: '' }, { text: 10147357 }, { text: 10007310 }, { text: 10147364 }, { text: 10029378, colSpan: 2 }, { text: '' }],//(772883,	772893,	772907,	772935)
            [{ text: 'Otro Plan', colSpan: 3, style: 'fila-pregunta', border: [true, true, false, true] }, { text: '' }, { text: '' }, { text: 10147358, border: [false, true, false, true] }, { text: 10086020 }, { text: 10007311 }, { text: 10147365 }, { text: 10029379, colSpan: 2 }, { text: '' }],//(772887,	772884,	772894,	772908,	772936)
            [{ text: 'Otro Plan', colSpan: 3, style: 'fila-pregunta', border: [true, true, false, true] }, { text: '' }, { text: '' }, { text: 10147359, border: [false, true, false, true] }, { text: 10086021 }, { text: 10007312 }, { text: 10147366 }, { text: 10029380, colSpan: 2 }, { text: '' }],//(772888,	772885,	772895,	772909,	772937)
            [{ text: 'Otro Plan', colSpan: 3, style: 'fila-pregunta', border: [true, true, false, true] }, { text: '' }, { text: '' }, { text: 10147360, border: [false, true, false, true] }, { text: 10086022 }, { text: 10007313 }, { text: 10147367 }, { text: 10029381, colSpan: 2 }, { text: '' }],//(772889,	772886,	772896,	772910,	772938)
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_3, datos, maxCol, 'vertical');
        $scope.tabla_3.splice(0, 0, titulosSecciones[2]);//le coloca el titulo del numeral
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_3)

        //METERLE EL subtitulo 
        $scope.tabla_titulo1 = [[{ text: 'Contenido del Plan de Acción Territorial', style: 'reporte-subtitulo', colSpan: maxCol }]];
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_titulo1)

        //preguntas
        //var codigosPreguntas_3_3 = ['10137572', '10129313', '10117083', '10129312', '10147694', '10059561', '10059562', '10147689'];//este es un ejemplo que trae datos
        var codigosPreguntas_3_3 = ['10147338', '10147339','10147321', '10147340', '10147341','10147342'];//(772951,772952,772953,772954,772955,772956)
        $scope.preguntas_seccion3 = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigosPreguntas_3_3, datos, maxCol, 'vertical');//no se ve en el reporte
        organizarDatos($scope.datosFormatadosPDF, $scope.preguntas_seccion3)


        //SECCIÓN 4
        //IV. Participación de la Población Víctima
        //preguntas
        var codigosPreguntas_4 = ['10147298', '10059565', '10059566', '10147693',' 10129273', '10129258', '10129259', '10117206', '10129256', '10129257', '10117207', '10117208'];//774150, 774151, 774152, 774633, 774691, 774692, 774693, 774694, 774696, 774695, 774697, 774674
        $scope.preguntas_seccion4 = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigosPreguntas_4, datos, maxCol, 'vertical');
        $scope.preguntas_seccion4.splice(0, 0, titulosSecciones[3]);//le coloca el titulo del numeral
        organizarDatos($scope.datosFormatadosPDF, $scope.preguntas_seccion4)

        //METERLE EL subtitulo 
        $scope.tabla_4_titulo1 = [[{ text: 'Participación de Minorías Étnicas en la Mesa de Participación', style: 'reporte-subtitulo', colSpan: maxCol }]];
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_4_titulo1)

        //tabla
        $scope.tabla_4 = [
            [
                { text: 'Representantes de las Organizaciones de Víctimas de Pueblos y Comunidades Indígenas', style: 'fila-encabezado-tabla', colSpan: 3 }, { text: '' }, { text: '' },
                { text: 'Representantes de las Organizaciones de Víctimas de las Comunidades negras, afrocolombianas, raizales y palenqueras', style: 'fila-encabezado-tabla', colSpan: 3 }, { text: '' }, { text: '' },
                { text: 'Representantes de las Organizaciones de Víctimas del Pueblo Rrom o Gitano', style: 'fila-encabezado-tabla', colSpan: 3 }, { text: '' }, { text: '' }
            ],
            [{ text: 10117200, colSpan: 3 }, { text: '' }, { text: '' }, { text: 10117201, colSpan: 3 }, { text: '' }, { text: '' }, { text: 10117202, colSpan: 3 }, { text: '' }, { text: '' }],//(774679	,	774680	,	774681	)
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_4, datos, maxCol, 'vertical');
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_4);

        //METERLE EL subtitulo 
        $scope.tabla_4_titulo2 = [[{ text: 'Participación en la Mesa de Participación con Enfoque diferencial', style: 'reporte-subtitulo', colSpan: maxCol }]];
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_4_titulo2)

        //tabla de enfoque diferencial
        $scope.tabla_4_4 = [
            [
                { text: 'Mujeres', style: 'fila-encabezado-tabla', colSpan: 1 },
                { text: 'Jóvenes', style: 'fila-encabezado-tabla', colSpan: 1 },
                { text: 'Personas Mayores', style: 'fila-encabezado-tabla', colSpan: 3 }, { text: '' }, { text: '' },
                { text: 'LGBTI', style: 'fila-encabezado-tabla', colSpan: 1 },
                { text: 'Personas en condición de discapacidad', style: 'fila-encabezado-tabla', colSpan: 3 }, { text: '' }, { text: '' }
            ],
            [{ text: 10129267, colSpan: 1 }, { text: 10129268, colSpan: 1 }, { text: 10129269, colSpan: 3 }, { text: '' }, { text: '' }, { text: 10129270, colSpan: 1 }, { text: 10129271, colSpan: 3 }, { text: '' }, { text: '' }],//(774682,	774683,	774684,	774685,	774686	)
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_4_4, datos, maxCol, 'vertical');
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_4_4);

        //otras preguntas
        var codigosPreguntas_4_4 = ['10137542', '10155976', '10155971'];//(774635,777658,777671	)
        $scope.preguntas_seccion4_4 = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigosPreguntas_4_4, datos, maxCol, 'vertical');
        organizarDatos($scope.datosFormatadosPDF, $scope.preguntas_seccion4_4)



        //SECCIÓN 5
        //V.Articulación Institucional
        var codigosPreguntas_5 = ['10137567', '10101256', '10137570', '10137563', '10101214', '10129216', '10117253', '10129217', '10129233', '10129236'];//(774828,774829,774857,774889, 774890,774906, 774907,774912,774916,774930	)
        $scope.preguntas_seccion5 = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigosPreguntas_5, datos, maxCol, 'vertical');
        $scope.preguntas_seccion5.splice(0, 0, titulosSecciones[4]);
        organizarDatos($scope.datosFormatadosPDF, $scope.preguntas_seccion5)

        //METERLE EL subtitulo 
        $scope.tabla_5_titulo1 = [[{ text: 'Apoyo a los municipios en la implementación de la Política Pública de Víctimas', style: 'reporte-subtitulo', colSpan: maxCol }]];
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_5_titulo1)

        var codigosPreguntas_5_5 = ['10147427', '10147428', '10147429', '10147430', '10085022', '10147449','10085008', '10085009', '10147448', '10085020', '10085021'];//(776029,776030,776031,776032,776033,776046,	776047,	776048,776049,776050,776051	)
        $scope.preguntas_seccion_5_5 = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigosPreguntas_5_5, datos, maxCol, 'vertical');
        organizarDatos($scope.datosFormatadosPDF, $scope.preguntas_seccion_5_5)

        //SECCIÓN 6
        //VI. Adecuación Institucional
        var codigosPreguntas_6 = ['10137602', '10102697', '10138587', '10103002'];//(776419,776420,	776744, 776745	)
        $scope.preguntas_seccion6 = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigosPreguntas_6, datos, maxCol, 'vertical');
        $scope.preguntas_seccion6.splice(0, 0, titulosSecciones[5]);
        organizarDatos($scope.datosFormatadosPDF, $scope.preguntas_seccion6)
        
        //(776911,776912,776913,776914,776915,776916	)
        $scope.tabla_6_1 = [
            [{ style: 'fila-encabezado-tabla', text: 'Recursos con los que cuenta la gobernación para la implementación de la Política Pública Víctimas del conflicto armado', colSpan: maxCol }],
            [{ style: 'fila-pregunta', text: 'Oficinas (espacio físico o instalaciones)', colSpan: 5 }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: 10127891, colSpan: 4 }, { text: '' }, { text: '' }, { text: '' }],
            [{ style: 'fila-pregunta', text: 'Equipos de cómputo y comunicación', colSpan: 5 }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: 10127892, colSpan: 4 }, { text: '' }, { text: '' }, { text: '' }],
            [{ style: 'fila-pregunta', text: 'Acceso a internet', colSpan: 5 }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: 10127893, colSpan: 4 }, { text: '' }, { text: '' }, { text: '' }],
            [{ style: 'fila-pregunta', text: 'Papelería y materiales de oficina', colSpan: 5 }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: 10127894, colSpan: 4 }, { text: '' }, { text: '' }, { text: '' }],
            [{ style: 'fila-pregunta', text: 'Albergues temporales', colSpan: 5 }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: 10127895, colSpan: 4 }, { text: '' }, { text: '' }, { text: '' }],
            [{ style: 'fila-pregunta', text: 'Servicio de energía eléctrico', colSpan: 5 }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: 10127896, colSpan: 4 }, { text: '' }, { text: '' }, { text: '' }],
        ];

        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_6_1, datos, maxCol, 'vertical');
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_6_1)


        var codigosPreguntas_6_6 = ['10129023', '10129025', '10117434', '10157198'];//(776869,776871,776876,776879)
        $scope.preguntas_seccion6_6 = UtilsService.funcionesReportes('obtenerPreguntasXCodigo', codigosPreguntas_6_6, datos, maxCol, 'vertical');
        organizarDatos($scope.datosFormatadosPDF, $scope.preguntas_seccion6_6);

        //METERLE EL subtitulo 
        $scope.tabla_6_titulo1 = [[{ text: 'Estrategias de Atención Complementarias implementadas por la gobernación', style: 'reporte-subtitulo', colSpan: maxCol }]];
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_6_titulo1)

        $scope.tabla_6_2 = [
            [
                { style: 'fila-encabezado-tabla', text: ' ', colSpan: 3 }, { text: '' }, { text: '' },
                { style: 'fila-encabezado-tabla', text: 'Cuenta con esta estrategia' },
                { style: 'fila-encabezado-tabla', text: 'COBERTURA TERRITORIAL (departamental, zona, municipios, municipio)', colSpan: 2 }, { text: '' },
                { style: 'fila-encabezado-tabla', text: 'Servicios que se prestan o bienes que se entregan' },
                { style: 'fila-encabezado-tabla', text: 'Servidores públicos responsables', colSpan: 2 }, { text: '' },
            ],
            [{ style: 'fila-pregunta', text: 'Esquemas móviles', colSpan: 3 }, { text: '' }, { text: '' }, { text: 10129016 }, { text: 10117416, colSpan: 2 }, { text: '' }, { text: 10117426 }, { text: 10118544, colSpan: 2 }, { text: '' }],//(776882,	776890,	776897,	776904)
            [{ style: 'fila-pregunta', text: 'Enlace municipal', colSpan: 3 }, { text: '' }, { text: '' }, { text: 10129017 }, { text: 10117417, colSpan: 2 }, { text: '' }, { text: 10117427 }, { text: 10118545, colSpan: 2 }, { text: '' }],//(776883,	776891,	776898,	776905)
            [{ style: 'fila-pregunta', text: 'Enlace con las organizaciones de víctimas', colSpan: 3 }, { text: '' }, { text: '' }, { text: 10129018 }, { text: 10117418, colSpan: 2 }, { text: '' }, { text: 10117428 }, { text: 10118519, colSpan: 2 }, { text: '' }],//(776884,	776892,	776899,	776906)
            [{ style: 'fila-pregunta', text: 'Atención telefónica', colSpan: 3 }, { text: '' }, { text: '' }, { text: 10129019 }, { text: 10117420, colSpan: 2 }, { text: '' }, { text: 10118535 }, { text: 10118520, colSpan: 2 }, { text: '' }],//(776885,	776893,	776900,	776907)
            [{ style: 'fila-pregunta', text: 'Punto de Atención', colSpan: 3 }, { text: '' }, { text: '' }, { text: 10129020 }, { text: 10117421, colSpan: 2 }, { text: '' }, { text: 10118536 }, { text: 10118526, colSpan: 2 }, { text: '' }],//(776886,	776894,	776901,	776908)
            [{ style: 'fila-pregunta', text: 'Traductores étnicos', colSpan: 3 }, { text: '' }, { text: '' }, { text: 10129021 }, { text: 10117422, colSpan: 2 }, { text: '' }, { text: 10118537 }, { text: 10118527, colSpan: 2 }, { text: '' }],//(776887,	776895,	776902,	776909)
            [{ style: 'fila-pregunta', text: 'Otro ¿Cuál?', colSpan: 2 }, { text: '' }, { text: 10129006, colSpan: 2 }, { text: 10117415 }, { text: 10117425, colSpan: 2 }, { text: '' }, { text: 10118538 }, { text: 10118528, colSpan: 2 }, { text: '' }],//(776889,	776888	,776896	,776903	,776910)
        ];
        UtilsService.funcionesReportes('obtenerRepuestaTablaXCodigo', $scope.tabla_6_2, datos, maxCol, 'vertical');
        organizarDatos($scope.datosFormatadosPDF, $scope.tabla_6_2)
        
        return true;
    }

    var printJson = function () {
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
                                [{ text: 'SALIDA DE INFORMACIÓN GOBERNACIONES', fillColor: $scope.definiciones.colorInstitucional }],
                                [{ text: $scope.nombreEncuesta, style: 'fila-titulo-1' }],
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
                            widths: ['*', '*'],
                            body: [
                                [{ text: 'Gobernación', }, { text: $scope.nombreDepartamento, fillColor: 'white' }],
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
                                {},
                                { text: currentPage.toString(), alignment: 'center' },
                                { text: "Fecha de generación: " + new Date().toLocaleString(), alignment: 'right', }
                            ]
                        }]
                };
            },
            content: [

              {
                  fontSize: 7,
                  table: {
                      body: $scope.datosFormatadosPDF,
                  },
                  layout: UtilsService.getLayout('preguntasRespuestas')
              },
                //{
                //    fontSize: tamanhoFuente,
                //    alignment: 'center',
                //    table: {
                //        headerRows: 1,
                //        body: $scope.tabla_2
                //    },
                //    pageBreak: 'after',
                //    layout: UtilsService.getLayout('tabla2')
                //},
                //{
                //    fontSize: tamanhoFuente,
                //    table: {
                //        body: $scope.datosFormatadosPDF2
                //    },
                //    layout: UtilsService.getLayout('preguntasRespuestas')
                //},
            ],
            styles: $scope.definiciones.estilos
        }

        var date = new Date();
        date = moment(date).format('DD_MMM_YYYY_HH_mm_ss');
        pdfMake.createPdf(docDefinition).download('PDF_' + date + '.pdf');

    };

    //-----------------Obtener los códigos de pregunta---------------
    function obtenerPreguntasXCodigo(codigosPreguntas, datos) {
        String.prototype.splice = function (idx, rem, str) {
            return this.slice(0, idx) + str + this.slice(idx + Math.abs(rem));
        };

        var respuesta = [];
        for (var i = 0; i < codigosPreguntas.length; i++) {
            for (var j = 0; j < datos.length; j++) {
                if (codigosPreguntas[i] === datos[j].codigopregunta) {
                    if (datos[j].descripcionpregunta.length > 142) datos[j].descripcionpregunta = datos[j].descripcionpregunta.splice(142, 0, " ");
                    if (datos[j].respuesta === '') datos[j].respuesta = ' ';
                    respuesta.push([{ text: datos[j].descripcionpregunta + ' - ' + datos[j].codigopregunta, style: 'fila-pregunta' }]);//, colSpan: 8 }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: ''}]);
                    respuesta.push([{ text: datos[j].respuesta }]);//, colSpan: 8  }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: '' }, { text: ''}]);
                    break;
                }
            }
        }
        return respuesta;

    }

    function obtenerRepuestaTablaXCodigo(tabla, datos) {
        var celda;
        var celdaString;

        //Recorremos la tabla
        for (var i = 0; i < tabla.length; i++) {
            for (var j = 0; j < tabla[i].length; j++) {

                celda = tabla[i][j].text;
                if (typeof (celda) == 'number') {
                    celdaString = celda.toString();
                    //Recorremos los datos donde esté el valor de la celda
                    for (var k = 0; k < datos.length; k++) {
                        if (datos[k].codigopregunta === celdaString) {
                            tabla[i][j].text = datos[k].respuesta;
                            break;
                        }
                    }
                }
            }
        }
    }

    function organizarDatos(datosFormatados, columnas) {
        for (var i = 0; i < columnas.length; i++) {
            datosFormatados.push(columnas[i]);
        }
    }

    function insertarColumnas(columnasOriginal, ColumnasXInsertar, index) {
        var long = ColumnasXInsertar.length;
        for (var i = 0; i < long; i++) {
            columnasOriginal.splice(index, 0, ColumnasXInsertar[i]);
        }

    }
}]);
