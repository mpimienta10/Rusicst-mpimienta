/// <reference path="views/tableroPat/TablerosEnviados.html" />
var app = angular.module('APIModule', [
    'ui.grid',
    'ui.grid.grouping',
    'ui.grid.pagination',
    'ui.grid.moveColumns',
    'ui.grid.resizeColumns',
    'ui.grid.pinning',
    'ui.grid.autoResize',
    'ui.grid.exporter',
    'ui.grid.selection',
    'ui.grid.autoScroll',
    'ui.grid.expandable',
    'ui.grid.selection',
    'ui.grid.autoResize',
    'LocalStorageModule',
    'ngSanitize',
    'ngFileUpload',
    'ui.router',
    'angular-loading-bar',
    'vcRecaptcha',
    'ui.bootstrap',
    'ui.tinymce',
    'chart.js',
    'permission',
    'permission.ui',
    'multipleSelect',
    'checklist-model',
    'ui.mask',
    'ncy-angular-breadcrumb',
    'doubleScrollBars',
    'blockUI'
]);

app.config(function ($stateProvider, $urlRouterProvider, uiGridConstants, $provide) {
    // For any unmatched url, send to /populations
    $urlRouterProvider.otherwise(function ($injector) {
        var $state = $injector.get("$state");
        $state.go('home.login');
    });

    $stateProvider
        //*========== HOME ===================================
        .state('home', {
            abstract: true,
            url: '/home',
            templateUrl: '/app/views/layouts/LayoutHome.html',
            controller: 'LayoutHomeController',
            authenticate: false,
        })
        .state('home.login', {
            url: "/login",
            templateUrl: "/app/views/home/Login.html",
            //El controlador para el login, recuperar contraseña y contáctenos esta en el html.
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Bienvenidos a Rusicts',
                parent: 'home'
            }
        })
        .state('home.registro', {
            url: "/registro",
            templateUrl: "/app/views/home/Registro.html",
            controller: "RegistroController",
            authenticate: false
        })
        .state('home.confirmarsolicitud', {
            url: "/confirmarsolicitud",
            templateUrl: "/app/views/home/ConfirmarSolicitud.html",
            controller: "ConfirmarSolicitudController",
            authenticate: false
        })
        .state('home.establecercontrasena', {
            url: "/establecercontrasena",
            templateUrl: "/app/views/home/EstablecerContrasena.html",
            controller: "EstablecerContrasenaController",
            authenticate: false
        })

        //===================== INDEX ============================
        .state('Index', {
            abstract: true,
            url: '/Index',
            templateUrl: '/app/views/layouts/LayoutIndex.html',
            controller: 'LayoutIndexController',
            authenticate: false,
            ncyBreadcrumb: {
                label: ''
            }
        })
        .state('Index.Index', {
            url: "",
            templateUrl: "/app/views/home/index.html",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Inicio',
                parent: 'Index'
            }
        })

        //-------------Menus Abstractos, para efectos de la jerarquización y la miga de pan-------
        .state('Usuarios', {
            abstract: true,
            ncyBreadcrumb: {
                label: 'Usuarios',
                parent: 'Index.Index',
            }
        })
        .state('Sistema', {
            abstract: true,
            ncyBreadcrumb: {
                label: 'Sistema',
                parent: 'Index.Index',
            }
        })
        .state('Reportes', {
            abstract: true,
            ncyBreadcrumb: {
                label: 'Reportes',
                parent: 'Index.Index',
            }
        })
        .state('Informes', {
            abstract: true,
            ncyBreadcrumb: {
                label: 'Informes',
                parent: 'Index.Index',
            }
        })
        .state('TableroPAT', {
            abstract: true,
            ncyBreadcrumb: {
                label: 'Tablero PAT',
                parent: 'Index.Index',
            }
        })
        .state('Retroalimentación', {
            abstract: true,
            ncyBreadcrumb: {
                label: 'Retroalimentación',
                parent: 'Index.Index',
            }
        })
        .state('BI', {
            abstract: true,
            ncyBreadcrumb: {
                label: 'Acceso BI',
                parent: 'Index.Index',
            }
        })

        //----------------- Usuarios -------------------------------
        .state('Index.AdministrarTiposUsuario', {
            url: "/Usuario/AdministrarTiposUsuario",
            templateUrl: "/app/views/usuarios/AdministrarTiposUsuario.html",
            controller: "AdministrarTipoUsuarioController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Administrar Tipos de Usuario',
                parent: 'Usuarios'
            }
        })
        .state('Index.AdministrarUsuario', {
            url: "/Usuario/AdministrarUsuario",
            templateUrl: "/app/views/usuarios/AdministrarUsuarios.html",
            controller: "AdministrarUsuariosController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Administrar Usuarios',
                parent: 'Usuarios'
            }
        })
        .state('Index.GestionarSolicitudes', {
            url: "/Usuario/GestionarSolicitudes",
            templateUrl: "/app/views/usuarios/GestionarSolicitudes.html",
            controller: "GestionarSolicitudesController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Gestión de Solicitudes Usuario',
                parent: 'Usuarios'
            }
        })
        .state('Index.HistoricoUsuarios', {
            url: "/Usuario/HistoricoUsuarios",
            templateUrl: "/app/views/usuarios/HistoricoUsuarios.html",
            controller: "HistoricoUsuariosController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Histórico de Usuarios',
                parent: 'Usuarios'
            }
        })
        .state('Index.GestionarPermisos', {
            url: "/Usuario/GestionarPermisos",
            templateUrl: "/app/views/usuarios/GestionarPermisos.html",
            controller: "GestionarPermisosController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Gestionar Permisos de Usuario',
                parent: 'Usuarios'
            }
        })
        .state('Index.HabilitarReportes', {
            url: "/Usuario/HabilitarReportes",
            templateUrl: "/app/views/usuarios/HabilitarReportes.html",
            controller: "HabilitarReportesController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Habilitar Reportes a Usuarios',
                parent: 'Usuarios'
            }
        })
        .state('Index.ExtensionesAnteriores', {
            url: "/Usuario/ExtensionesAnteriores",
            templateUrl: "/app/views/usuarios/ExtensionesAnteriores.html",
            controller: "ExtensionesAnterioresController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Extensiones de Tiempo Concedidas',
                parent: 'Index.HabilitarReportes'
            }
        })
        .state('Index.EmailMasivo', {
            url: "/Usuario/EmailMasivo",
            templateUrl: "/app/views/usuarios/EmailMasivos.html",
            controller: "EmailMasivosController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Email Masivo',
                parent: 'Usuarios'
            }
        })

        //----------------- Sistema -------------------------------
        .state('Index.ConfiguracionArchivosAyuda', {
            url: "/Sistema/ConfiguracionArchivosAyuda",
            templateUrl: "/app/views/sistema/ConfiguracionArchivosAyuda.html",
            controller: "ConfiguracionArchivosAyudaController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Configuración Archivos Ayuda',
                parent: 'Sistema'
            }
        })
        .state('Index.ParametrosSistema', {
            url: "/Sistema/ParametrosSistema",
            templateUrl: "/app/views/sistema/ParametrosSistema.html",
            controller: "ParametrosSistemaController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Parametros del Sistema',
                parent: 'Sistema'
            }
        })
        .state('ConfiguracionHome', {
            abstract: false,
            url: "/Sistema/ConfiguracionHome",
            templateUrl: "/app/views/sistema/ConfiguracionHome.html",
            controller: "ConfiguracionHomeController",
            authenticate: true,
        })
        .state('ConfiguracionSistema', {
            abstract: false,
            url: "/Sistema/ConfiguracionSistema",
            templateUrl: "/app/views/sistema/ConfiguracionSistema.html",
            controller: "ConfiguracionSistemaController",
            authenticate: true,
        })
        .state('Index.GestionAuditoriaEventos', {
            abstract: false,
            url: "/Sistema/GestionAuditoriaEventos",
            templateUrl: "/app/views/sistema/GestionAuditoriaEventos.html",
            controller: "GestionAuditoriaEventosController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Gestión Auditoría Eventos',
                parent: 'Sistema'
            }
        })
        .state('Index.GestionAuditoriaOldEventos', {
            abstract: false,
            url: "/Sistema/GestionAuditoriaOldEventos",
            templateUrl: "/app/views/sistema/GestionAuditoriaOldEventos.html",
            controller: "GestionAuditoriaOldEventosController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Histórico de Auditoría y Eventos',
                parent: 'Sistema'
            }
        })
        .state('Index.GestionErroresAplicacion', {
            abstract: false,
            url: "/Sistema/GestionErroresAplicacion",
            templateUrl: "/app/views/sistema/GestionErroresAplicacion.html",
            controller: "GestionErroresAplicacionController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Gestión Errores de Aplicación',
                parent: 'Sistema'
            }
        })
        .state('Index.GestionarRoles', {
            url: "/Usuario/GestionarRoles",
            templateUrl: "/app/views/usuarios/GestionarRoles.html",
            controller: "GestionarRolesController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Gestionar Roles',
                parent: 'Sistema'
            }
        })
        .state('Index.GestionBancoPreguntas', {
            url: "/Sistema/GestionBancoPreguntas",
            templateUrl: "/app/views/sistema/GestionBancoPreguntas.html",
            controller: "GestionBancoPreguntasController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Gestión del Banco de Preguntas',
                parent: 'Sistema'
            }
        })
        .state('Index.ClasificadoresBancoPreguntas', {
            url: "/Sistema/ClasificadoresBancoPreguntas",
            templateUrl: "/app/views/sistema/ClasificadoresBancoPreguntas.html",
            controller: "ClasificadoresBancoPreguntasController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Clasificadores del Banco de Preguntas',
                parent: 'Sistema'
            }
        })
        .state('Index.GestionPlanesMejoramiento', {
            url: "/Sistema/GestionPlanesMejoramiento",
            templateUrl: "/app/views/sistema/GestionPlanesMejoramiento.html",
            controller: "GestionPlanesMejoramientoController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Gestión de Planes de Mejoramiento',
                parent: 'Sistema'
            }
        })
        .state('Index.GestionPlanesMejoramientoV3', {
            url: "/Sistema/GestionPlanesMejoramientoV3",
            templateUrl: "/app/views/sistema/GestionPlanesMejoramientoV3.html",
            controller: "GestionPlanesMejoramientoV3Controller",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Gestión de Planes de Mejoramiento',
                parent: 'Sistema'
            }
        })
        .state('Index.ConfiguracionDerechosPAT', {
            url: "/Sistema/ConfiguracionDerechosPAT",
            templateUrl: "/app/views/sistema/ConfiguracionDerechosPAT.html",
            controller: "ConfiguracionDerechosPATController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Configuración de Derechos PAT',
                parent: 'Sistema'
            }
        })

        //----------------- Reportes -------------------------------
        .state('Index.ConsultaEntidadesTerritoriales', {
            url: "/Sistema/ConsultaEntidadesTerritoriales",
            templateUrl: "/app/views/reportes/ConsultaEntidadesTerritoriales.html",
            controller: "ConsultaEntidadesTerritorialesController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Consulta Reportes Entidades Territoriales',
                parent: 'Reportes'
            }
        })
        .state('Index.CompletarConsultarReportes', {
            url: "/Reportes/CompletarConsultarReportes",
            templateUrl: "/app/views/reportes/CompletarConsultarReportes.html",
            controller: "CompletarConsultarReportesController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Completar/Consultar Reportes',
                parent: 'Reportes'
            }
        })
        .state('Index.DisenoReportes', {
            url: "/Reportes/DisenoReportes",
            templateUrl: "/app/views/reportes/DisenoReportes.html",
            controller: "DisenoReportesController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Diseño de Reportes',
                parent: 'Reportes'
            }
        })
        .state('Index.GlosarioReportes', {
            url: "/Reportes/GlosarioReportes",
            templateUrl: "/app/views/reportes/GlosarioReportes.html",
            controller: "GlosarioReporteController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Administrar Glosario',
                parent: 'Reportes'
            }
        })
        .state('Index.ModificarPreguntas', {
            url: "/Reportes/ModificarPreguntas",
            templateUrl: "/app/views/reportes/ModificarPreguntas.html",
            controller: "ModificarPreguntasController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Modificar Preguntas',
                parent: 'Reportes'
            }
        })
        .state('Index.RevisionRespuestasAG', {
            url: "/Reportes/RevisionRespuestasAG",
            templateUrl: "/app/views/reportes/RevisionRespuestasAG.html",
            controller: "RevisionRespuestasAGController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Revisar Respuestas Alcaldías Gobernación',
                parent: 'Reportes'
            }
        })

        .state('Index.PrecargueRespuestas', {
            url: "/Reportes/PrecargueRespuestasController",
            templateUrl: "/app/views/reportes/PrecargueRespuestas.html",
            controller: "PrecargueRespuestasController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Precargue de Respuestas',
                parent: 'Reportes'
            }
        })

        .state('Index.PrecargueSeguimientoPAT', {
            url: "/Reportes/PrecargueSeguimientoPATController",
            templateUrl: "/app/views/reportes/PrecargueSeguimientoPAT.html",
            controller: "PrecargueSeguimientoPATController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Precargue Nivel Nacional',
                parent: 'Reportes'
            }
        })

        //----------------- Reportes: Encuestas ------------------------------
        .state('Index.IndiceEncuesta', {
            url: "/Reportes/IndiceEncuesta/{IdEncuesta}/{Titulo}/{IdUsuario}",
            templateUrl: "/app/views/reportes/IndiceEncuesta.html",
            controller: "IndiceEncuestaController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Consultar Encuesta',
                parent: 'Reportes'
            }
        })
        .state('Index.Encuesta', {
            url: "/Reportes/Encuesta/{IdEncuesta}/{SuperSeccion}/{IdPagina}/{Titulo}/{IdUsuario}",
            templateUrl: "/app/views/reportes/Encuesta.html",
            controller: "EncuestaController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Encuesta',
                parent: 'Index.CompletarConsultarReportes'
            }
        })
        .state('Index.DiligenciarPlan', {
            url: "/Reportes/PlanMejoramiento/DiligenciarPlan/{IdPlan}/{IdUsuario}",
            templateUrl: "/app/views/sistema/DiligenciarPlan.html",
            controller: "DiligenciarPlanController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Plan de Mejoramiento',
                parent: 'Index.IndiceEncuesta'
            }
        })
        .state('Index.DiligenciarPlanV3', {
            url: "/Reportes/PlanMejoramiento/DiligenciarPlanV3/{IdPlan}/{IdUsuario}",
            templateUrl: "/app/views/sistema/DiligenciarPlanV3.html",
            controller: "DiligenciarPlanV3Controller",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Plan de Mejoramiento',
                parent: 'Index.IndiceEncuesta'
            }
        })
        .state('Index.SeguimientoPlanV3', {
            url: "/Reportes/PlanMejoramiento/SeguimientoPlanV3/{IdPlan}/{IdSeguimiento}/{IdUsuario}",
            templateUrl: "/app/views/sistema/SeguimientoPlanV3.html",
            controller: "SeguimientoPlanV3Controller",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Seguimiento Plan de Mejoramiento',
                parent: 'Index.IndiceEncuesta'
            }
        })
        .state('Index.AutoevaluacionV1', {
            url: "/Reportes/Autoevaluacion/{IdEncuesta}/{IdUsuario}",
            templateUrl: "/app/views/reportes/Autoevaluacion.html",
            controller: "AutoevaluacionV1Controller",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Autoevaluación',
                parent: 'Index.IndiceEncuesta'
            }
        })

        //----------------- reporte encuestas -------------------------------
        .state('Index.RespuestaEncuestaFile', {
            url: "/Reportes/RespuestaEncuestaFile",
            templateUrl: "/app/views/reportes/RespuestaEncuestaFile.html",
            controller: "RespuestaEncuestaFileController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Respuestas no encontradas en File Server',
                parent: 'Reportes'
            }
        })

        //----------------- Ayuda -------------------------------
        .state('Index.Ayuda', {
            url: "/VerAyuda",
            templateUrl: "/app/views/ayuda/VerAyuda.html",
            controller: "VerAyudaController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Ayuda',
                parent: 'Index.Index'
            }
        })

        //----------------- Informes -------------------------------
        .state('Index.ConsolidadoDiligenciamiento', {
            url: "/Informes/ConsolidadoDiligenciamiento",
            templateUrl: "/app/views/informes/ConsolidadoDiligenciamiento.html",
            controller: "ConsolidadoDiligenciamientoController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Consolidado del Diligenciamiento del RUSICST',
                parent: 'Informes'
            }
        })
        .state('Index.Autoevaluacion', {
            url: "/Informes/Autoevaluacion",
            templateUrl: "/app/views/informes/Autoevaluacion.html",
            controller: "AutoevaluacionController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Informe de Auto Evaluación',
                parent: 'Informes'
            }
        })
        .state('Index.InformeRespuestas', {
            url: "/Informes/InformeRespuestas",
            templateUrl: "/app/views/informes/InformeRespuestas.html",
            controller: "InformeRespuestasController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Informe de Respuestas',
                parent: 'Informes'
            }
        })
        .state('Index.OpcionesMenu', {
            url: "/Informes/OpcionesMenu",
            templateUrl: "/app/views/informes/OpcionesMenu.html",
            controller: "OpcionesMenuController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Opciones Menú',
                parent: 'Informes'
            }
        })
        .state('Index.OpcionesRol', {
            url: "/Informes/OpcionesRol",
            templateUrl: "/app/views/informes/OpcionesRol.html",
            controller: "OpcionesRolController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Opciones Rol',
                parent: 'Informes'
            }
        })
        .state('Index.SalidaInformacionGobernacion', {
            url: "/Informes/SalidaInformacionGobernacion",
            templateUrl: "/app/views/informes/SalidaInformacionGobernacion.html",
            controller: "SalidaInformacionGobernacionController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Salida de Información Gobernaciones',
                parent: 'Informes'
            }
        })
        .state('Index.SalidaInformacionMunicipal', {
            url: "/Informes/SalidaInformacionMunicipal",
            templateUrl: "/app/views/informes/SalidaInformacionMunicipal.html",
            controller: "SalidaInformacionMunicipalController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Salida de Información Municipal',
                parent: 'Informes'
            }
        })
        .state('Index.UsuariosSistema', {
            url: "/Informes/UsuariosSistema",
            templateUrl: "/app/views/informes/UsuariosSistema.html",
            controller: "UsuariosSistemaController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Usuarios del Sistema',
                parent: 'Informes'
            }
        })
        .state('Index.UsuariosGuardaronInformacion', {
            url: "/Informes/UsuariosGuardaronInformacion",
            templateUrl: "/app/views/informes/UsuariosGuardaronInformacion.html",
            controller: "UsuariosGuardaronInformacionController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Usuarios Guardaron Información en el Sistema',
                parent: 'Informes'
            }
        })
        .state('Index.UsuarioReporte', {
            url: "/Informes/UsuarioReporte",
            templateUrl: "/app/views/informes/UsuarioReporte.html",
            controller: "UsuarioReporteController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Usuarios Enviaron Reporte',
                parent: 'Informes'
            }
        })
        .state('Index.UsuariosGuardaronAutoevaluacion', {
            url: "/Informes/UsuariosGuardaronAutoevaluacion",
            templateUrl: "/app/views/informes/UsuariosGuardaronAutoevaluacion.html",
            controller: "UsuariosGuardaronAutoevaluacionController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Usuarios que Guardaron Información de Plan de Mejoramiento',
                parent: 'Informes'
            }
        })
        .state('Index.UsuariosPasaronAutoevaluacion', {
            url: "/Informes/UsuariosPasaronAutoevaluacion",
            templateUrl: "/app/views/informes/UsuariosPasaronAutoevaluacion.html",
            controller: "UsuariosPasaronAutoevaluacionController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Usuarios que Pasaron a Auto-evaluación',
                parent: 'Informes'
            }
        })
         .state('Index.EnvioTableroPAT', {
             url: "/TableroPat/EnvioTablero",
             templateUrl: "/app/views/tableroPat/TablerosEnviados.html",
             controller: "EnvioTableroController",
             authenticate: false,
             ncyBreadcrumb: {
                 label: 'Consulta Envio tableros PAT',
                 parent: 'Informes'
             }
        })
        .state('Index.UsuariosIniciarionSesion', {
            url: "/Informes/UsuariosIniciarionSesion",
            templateUrl: "/app/views/informes/UsuariosIniciarionSesion.html",
            controller: "UsuariosIniciarionSesionController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Usuarios que Iniciaron Sesión',
                parent: 'Informes'
            }
        })
        .state('Index.InformePrecargueRespuestas', {
            url: "/Informes/InformePrecargueRespuestas",
            templateUrl: "/app/views/informes/InformePrecargueRespuestas.html",
            controller: "InformePrecargueRespuestasController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Informe de Precargues repuestas de encuestas',
                parent: 'Informes'
            }
        })
        //----------------- Tablero PAT -------------------------------
        .state('Index.TablerosMunicipio', {
            url: "/TableroPat/TablerosMunicipio",
            templateUrl: "/app/views/tableroPat/TablerosMunicipio.html",
            controller: "ListadoTableroMunicipiosController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Tableros PAT – Planeación',
                parent: 'TableroPAT'
            }
        })
        .state('Index.GestionMunicipal', {
            url: "/TableroPat/GestionMunicipal",
            templateUrl: "/app/views/tableroPat/GestionMunicipal.html",
            controller: "GestionMunicipalController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Planeación Municipal',
                parent: 'TableroPAT'
            }
        })
        .state('Index.TablerosDepartamento', {
            url: "/TableroPat/TablerosDepartamento",
            templateUrl: "/app/views/tableroPat/TablerosDepartamento.html",
            controller: "ListadoTableroDepartamentosController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Tableros PAT – Planeación',
                parent: 'TableroPAT'
            }
        })
        .state('Index.GestionDepartamental', {
            url: "/TableroPat/GestionDepartamental",
            templateUrl: "/app/views/tableroPat/GestionDepartamental.html",
            controller: "GestionDepartamentalController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Planeación Departamental',
                parent: 'TableroPAT'
            }
        })
        .state('Index.PreguntasPat', {
            url: "/TableroPat/PreguntasPat",
            templateUrl: "/app/views/tableroPat/AdministracionPreguntas.html",
            controller: "PreguntasController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Preguntas Tablero PAT',
                parent: 'TableroPAT'
            }
        })
        .state('Index.AdminTablerosPat', {
            url: "/TableroPat/TablerosPat",
            templateUrl: "/app/views/tableroPat/AdministracionTableros.html",
            controller: "TablerosController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Administración de Tableros PAT',
                parent: 'Sistema'
            }
        })
        .state('Index.AdministracionServiciosWeb', {
            url: "/TableroPat/AdministracionServiciosWeb",
            templateUrl: "/app/views/tableroPat/AdministracionServiciosWeb.html",
            controller: "AdministracionServiciosWebController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Administración de Servicios Web',
                parent: 'Sistema'
            }
        })
        .state('Index.ConsultaDiligenciamientoEntidades', {
            url: "/TableroPat/ConsultaDiligenciamientoEntidades",
            templateUrl: "/app/views/tableroPat/ConsultaDiligenciamientoEntidades.html",
            controller: "ConsultaDiligenciamientoEntidadesController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Consultas Planeación PAT',
                parent: 'TableroPAT'
            }
        })
        .state('Index.TablerosSeguimientoMunicipio', {
            url: "/TableroPat/TablerosSeguimientoMunicipio",
            templateUrl: "/app/views/tableroPat/TablerosSeguimientoMunicipio.html",
            controller: "ListadoTableroSeguimientoMunicipiosController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Tableros Seguimiento Municipio',
                parent: 'TableroPAT'
            }
        })
        .state('Index.SeguimientoMunicipal', {
            url: "/TableroPat/SeguimientoMunicipal",
            templateUrl: "/app/views/tableroPat/SeguimientoMunicipal.html",
            controller: "SeguimientoMunicipalController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Seguimiento Gestión municipal Tablero PAT',
                parent: 'TableroPAT'
            }
        })
        .state('Index.TablerosSeguimientoDepartamento', {
            url: "/TableroPat/TablerosSeguimientoDepartamento",
            templateUrl: "/app/views/tableroPat/TablerosSeguimientoDepartamento.html",
            controller: "ListadoTableroSeguimientoDepartamentosController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Tableros Seguimiento Departamento',
                parent: 'TableroPAT'
            }
        })
        .state('Index.SeguimientoDepartamento', {
            url: "/TableroPat/SeguimientoDepartamento",
            templateUrl: "/app/views/tableroPat/SeguimientoDepartamento.html",
            controller: "SeguimientoDepartamentoController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Seguimiento Gestión departamento Tablero PAT',
                parent: 'TableroPAT'
            }
        })
        .state('Index.ConsultaSeguimiento', {
            url: "/TableroPat/ConsultaSeguimiento",
            templateUrl: "/app/views/tableroPat/ConsultaSeguimiento.html",
            controller: "ConsultaSeguimientoController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Consultas Seguimiento PAT',
                parent: 'TableroPAT'
            }
        })
        .state('Index.EvaluacionPat', {
            url: "/TableroPat/EvaluacionPat",
            templateUrl: "/app/views/tableroPat/EvaluacionPat.html",
            controller: "EvaluacionController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Evaluación Tablero PAT',
                parent: 'TableroPAT'
            }
        })
        .state('Index.EvaluacionConsolidadoPat', {
            url: "/TableroPat/EvaluacionConsolidadoPat",
            templateUrl: "/app/views/tableroPat/EvaluacionConsolidadoPat.html",
            controller: "EvaluacionConsolidadoController",
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Evaluación Consolidado Tablero PAT',
                parent: 'TableroPAT'
            }
        })
         
        //----------------- Retroalimentacion -------------------------------
        .state('Index.RetroRusicst', {
            url: "/reAlimentacion/ReAlimentacion",
            templateUrl: "/app/views/reAlimentacion/ReAlimentacion.html",
            controller: "ReAlimentacionController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'RUSICST',
                parent: 'Retroalimentación'
            }
        })
        .state('Index.AdminRetroalimentacion', {
            url: "/reAlimentacion/AdminRetro",
            templateUrl: "/app/views/reAlimentacion/AdminRetro.html",
            controller: "AdminRetroController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Administrar Retroalimentacion',
                parent: 'Sistema'
            }
        })
        .state('Index.RetroConsulta', {
            url: "/reAlimentacion/RetroConsulta",
            templateUrl: "/app/views/reAlimentacion/RetroConsulta.html",
            controller: "RetroConsultaController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Consultar/Editar',
                parent: 'Retroalimentación'
            }
        })

        //----------------- BI -------------------------------
        .state('Index.BI', {
            url: "/BI/BI",
            templateUrl: "/app/views/BI/BI.html",
            controller: "BIController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Análisis',
                parent: 'BI'
            }
        })

        //----------------- Buscador -------------------------------
        .state('Index.Buscador', {
            url: "/Buscador",
            templateUrl: "/app/views/ayuda/Buscador.html",
            controller: "BuscadorController",
            params: { textoBusqueda: null },
            authenticate: false,
            ncyBreadcrumb: {
                label: 'Buscador',
                parent: 'Index.Index'
            },
            //
        })
        .state('Index.Graficas', {
            url: "/BI/Graficas/{enviarDatos}",
            templateUrl: "/app/views/BI/Graficas.html",
            controller: "GraficasController",
            authenticate: true,
            ncyBreadcrumb: {
                label: 'Gráficas',
                parent: 'BI'
            }
        })
    ;

    $provide.decorator('GridOptions', function ($delegate) {
        var gridOptions;
        gridOptions = angular.copy($delegate);
        gridOptions.initialize = function (options) {
            var initOptions;
            initOptions = $delegate.initialize(options);
            initOptions.enablePaginationControls = true;
            initOptions.paginationPageSizes = [25, 50],
            initOptions.paginationPageSize = 25;
            initOptions.paginationTemplate = "<div role=\"contentinfo\" class=\"ui-grid-pager-panel\" ui-grid-pager ng-show=\"grid.options.enablePaginationControls\"><div role=\"navigation\" class=\"ui-grid-pager-container\"><div role=\"menubar\" class=\"ui-grid-pager-control\"><button type=\"button\" role=\"menuitem\" class=\"ui-grid-pager-first\" ui-grid-one-bind-title=\"aria.pageToFirst\" ui-grid-one-bind-aria-label=\"aria.pageToFirst\" ng-click=\"pageFirstPageClick()\" ng-disabled=\"cantPageBackward()\"><div ng-class=\"grid.isRTL() ? 'last-triangle' : 'first-triangle'\"><div ng-class=\"grid.isRTL() ? 'last-bar-rtl' : 'first-bar'\"></div></div></button> <button type=\"button\" role=\"menuitem\" class=\"ui-grid-pager-previous\" ui-grid-one-bind-title=\"aria.pageBack\" ui-grid-one-bind-aria-label=\"aria.pageBack\" ng-click=\"pagePreviousPageClick()\" ng-disabled=\"cantPageBackward()\"><div ng-class=\"grid.isRTL() ? 'last-triangle prev-triangle' : 'first-triangle prev-triangle'\"></div></button> <input type=\"number\" ui-grid-one-bind-title=\"aria.pageSelected\" ui-grid-one-bind-aria-label=\"aria.pageSelected\" class=\"ui-grid-pager-control-input\" ng-model=\"grid.options.paginationCurrentPage\" min=\"1\" max=\"{{ paginationApi.getTotalPages() }}\" required> <span class=\"ui-grid-pager-max-pages-number\" ng-show=\"paginationApi.getTotalPages() > 0\"><abbr ui-grid-one-bind-title=\"paginationOf\"></abbr><div class=\"pagination-of\"> {{'de ' + paginationApi.getTotalPages() }}</div></span> <button type=\"button\" role=\"menuitem\" class=\"ui-grid-pager-next\" ui-grid-one-bind-title=\"aria.pageForward\" ui-grid-one-bind-aria-label=\"aria.pageForward\" ng-click=\"pageNextPageClick()\" ng-disabled=\"cantPageForward()\"><div ng-class=\"grid.isRTL() ? 'first-triangle next-triangle' : 'last-triangle next-triangle'\"></div></button> <button type=\"button\" role=\"menuitem\" class=\"ui-grid-pager-last\" ui-grid-one-bind-title=\"aria.pageToLast\" ui-grid-one-bind-aria-label=\"aria.pageToLast\" ng-click=\"pageLastPageClick()\" ng-disabled=\"cantPageToLast()\"><div ng-class=\"grid.isRTL() ? 'first-triangle' : 'last-triangle'\"><div ng-class=\"grid.isRTL() ? 'first-bar-rtl' : 'last-bar'\"></div></div></button></div><div class=\"ui-grid-pager-row-count-picker\" ng-if=\"grid.options.paginationPageSizes.length > 1 && !grid.options.useCustomPagination\"><select ui-grid-one-bind-aria-labelledby-grid=\"'items-per-page-label'\" ng-model=\"grid.options.paginationPageSize\" ng-options=\"o as o for o in grid.options.paginationPageSizes\"></select><span ui-grid-one-bind-id-grid=\"'items-per-page-label'\" class=\"ui-grid-pager-row-count-label\">&nbsp;{{sizesLabel}}</span></div><span ng-if=\"grid.options.paginationPageSizes.length <= 1\" class=\"ui-grid-pager-row-count-label\">{{grid.options.paginationPageSize}}&nbsp;{{sizesLabel}}</span></div><div class=\"ui-grid-pager-count-container\"><div class=\"ui-grid-pager-count\"><span ng-show=\"grid.options.totalItems > 0\"> <abbr ui-grid-one-bind-title=\"paginationThrough\"></abbr> {{grid.options.totalItems}} {{totalItemsLabel}}</span></div></div></div>"
            initOptions.enableFiltering = true;
            initOptions.enableVerticalScrollbar = uiGridConstants.scrollbars.NEVER;
            initOptions.enableHorizontalScrollbar = uiGridConstants.scrollbars.ALWAYS;
            initOptions.enableGridMenu = true;
            initOptions.gridMenuShowHideColumns = false;
            initOptions.exporterMenuPdf = false;
            initOptions.exporterMenuCsv = false;
            initOptions.exporterIsExcelCompatible = true,
            initOptions.exporterOlderExcelCompatibility = true,
            initOptions.exporterCsvFilename = $("#titulo").text() + '.csv';
            initOptions.exporterPdfFilename = $("#titulo").text() + '.pdf';
            initOptions.exporterCsvColumnSeparator = ';';
            initOptions.exporterHeaderFilterUseName = true;
            initOptions.exporterPdfTableLayout = true;
            initOptions.exporterPdfDefaultStyle = { fontSize: 9 };
            initOptions.exporterPdfTableStyle = { margin: [5, 5, 5, 5] };
            initOptions.exporterPdfTableHeaderStyle = { fontSize: 10, bold: true, color: 'white', fillColor: '#63002D', alignment: 'center' };
            initOptions.exporterPdfHeader = { text: "\n" + $(".titulo-rejilla").text(), style: 'headerStyle' },
            initOptions.exporterPdfFooter = function (currentPage, pageCount) {
                var fecha = new Date().toLocaleString();
                var footer = {
                    style: 'footerStyle',
                    widths: [500, 'auto'],
                    layout: 'noBorders',
                    text: 'Página' + currentPage.toString() + ' de ' + pageCount.toString() + '                                          ' + 'Fecha de generación: ' + fecha,
                };
                return footer;
            };
            initOptions.exporterPdfCustomFormatter = function (docDefinition) {
                docDefinition.styles.headerStyle = { fontSize: 14, bold: true, alignment: 'center', color: '#63002D' };
                docDefinition.styles.footerStyle = { fontSize: 10, bold: true, alignment: 'center', color: '#333333' };
                return docDefinition;
            };
            initOptions.exporterPdfOrientation = 'landscape';
            initOptions.exporterPdfPageSize = 'A4';
            initOptions.exporterPdfMaxGridWidth = 670;
            initOptions.exporterCsvLinkElement = angular.element(document.querySelectorAll(".custom-csv-link-location"));
            return initOptions;
        };
        return gridOptions;
    });
});

app.filter('unsafe', function ($sce) { return $sce.trustAsHtml; });

var frontEndBase = location.host + '/#!/';
var serviceBase = 'http://localhost:60438';
var serviceBaseBI = 'http://localhost:1071/';
//var serviceBase = 'http://localhost:51908/';
//var serviceBase = 'http://186.155.31.160';

app.constant('ngSettings', {
    apiServiceBaseUri: serviceBase,
    apiServiceBI: serviceBaseBI,
    frontEndBaseUri: frontEndBase,
    clientId: 'APIModule'
});

app.config(function ($httpProvider) {
    $httpProvider.interceptors.push('authInterceptorService');
});

app.run(['authService', function (authService) {
    authService.fillAuthData();
}]);

app.run(function ($rootScope, $state, authService) {
    $rootScope.$on("$stateChangeStart", function (event, toState, toParams, fromState, fromParams) {
        if (toState.authenticate && !authService.authentication.isAuth) {
            // El usuario no está autenticado
            $state.transitionTo("home.login");
            event.preventDefault();
        }
    });
});

app.config(function ($breadcrumbProvider) {
    $breadcrumbProvider.setOptions({
        prefixStateName: 'Index.Index',
        //template: 'bootstrap3',
        includeAbstract: true,
        template: '<ol class="breadcrumb">' +
                        '<li ng-repeat="step in steps.slice(1)" ng- class="{active: $last}" ng-switch="$last || !!step.abstract" >' +
                            '<a ng-switch-when="false" href="{{step.ncyBreadcrumbLink}}">{{ step.ncyBreadcrumbLabel }}</a>' +
                            '<span ng-switch-when="true">{{ step.ncyBreadcrumbLabel }}</span>' +
                        '</li>' +
                     '</ol>'
    });
})


