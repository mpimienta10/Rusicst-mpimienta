'use strict';

app.factory('authService', ['$http', '$q', 'localStorageService', 'ngSettings', '$location', 'APIService', 'PermPermissionStore', '$state', '$uibModal', function ($http, $q, localStorageService, ngSettings, $location, APIService, PermPermissionStore, $state, $uibModal) {
    var serviceBase = ngSettings.apiServiceBaseUri;
    var authServiceFactory = {};
    var self = this;
    var getToken = '';

    var _authentication = {
        isAuth: false,
        isAddIdent: false,
        userNameAddIdent: "",
        userName: "",
        useRefreshTokens: false,
        idUsuario: 0,
        idTipoUsuario: 0,
    };

    var _login = function (loginData) {

        var data = "grant_type=password&username=" + loginData.userName + "&password=" + loginData.password;

        if (loginData.useRefreshTokens) {
            data = data + "&client_id=" + ngSettings.clientId;
        }

        var deferred = $q.defer();

        $http.post(serviceBase + '/token', data, { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }).then(function (response) {
            if (loginData.useRefreshTokens) {
                localStorageService.set('authorizationData', { token: response.data.access_token, userName: loginData.userName, refreshToken: response.refresh_token, useRefreshTokens: true });
            }
            else {
                localStorageService.set('authorizationData', { token: response.data.access_token, userName: loginData.userName, refreshToken: "", useRefreshTokens: false, validDays: response.data["90"] });
            }

            _authentication.isAuth = true;
            _authentication.userName = loginData.userName;
            _authentication.useRefreshTokens = loginData.useRefreshTokens;
            deferred.resolve(response);
            if (response.data["90"].toUpperCase() == "TRUE") {

                abrirModal(response.data, true);
                


            }

        }, function (err, status) {
            var count = parseInt(localStorageService.get("loginIntents")) || 0;
            localStorageService.set('loginIntents', count += 1);
            if (count >= 3) {
                localStorageService.remove('loginIntents');
                $http.post(serviceBase + '/api/Usuarios/Usuarios/ChangeStatus', {
                    AudUserName: loginData.userName,
                    Activo: false
                }, {
                    headers: {
                        'Content-Type': 'application/json',
                    }
                }).then(function (response) {
                    localStorageService.set(
                        'authorizationData',
                        { token: response.data.token.access_token, userName: response.data.token.userName, refreshToken: "", useRefreshTokens: false }
                    );
                })
            }
            console.log('se me metio ', localStorageService.get("loginIntents"));
            _logOutLogin();
            deferred.reject(err);
        });

        return deferred.promise;
    };

    function abrirModal(response, isHidden) {
        getDatos();
        function getDatos() {
            var registro = {};

            registro.UserName = _authentication.userName;

            registro.AudUserName = _authentication.userName;
            registro.AddIdent = _authentication.isAddIdent;
            registro.UserNameAddIdent = _authentication.userNameAddIdent;

            var url = '/api/Usuarios/Usuarios/BuscarXUsuario';
            var servCall = APIService.saveSubscriber(registro, url);
            servCall.then(function (datos) {
               var newData = datos.data[0];
                abrirModalIntern(newData, isHidden);
            }, function (error) {
            });
        };


    };

    var abrirModalIntern = function abrirModalIntern(entity, isHidden) {
        var modalInstance = $uibModal.open({
            templateUrl: 'app/views/usuarios/modals/NuevoEditarUsuarios.html',
            controller: 'ModalNuevoEditarUsuarioController',
            backdrop: 'static', keyboard: false,
            size: 'lg',
            resolve: {
                entity: function () {
                    return entity;
                },
                isHidden: function () {
                    return isHidden;
                }
            }
        });
        modalInstance.result.then(
            function () {
                var mensaje = "Los datos de contacto de " + entity.Nombres + " han sido actualizados satisfactoriamente";
                openRespuesta(mensaje);
            }
        );
    }

    var _loginAD = function (response) {
        var deferred = $q.defer();
        localStorageService.set('authorizationData', { token: response.data.access_token, userName: response.data.userName, refreshToken: "", useRefreshTokens: false });
        _authentication.isAuth = true;
        _authentication.userName = response.data.userName;
        _authentication.useRefreshTokens = false;
        deferred.resolve(response);
        return deferred.promise;
    };

    var _logOutLogin = function () {
        localStorageService.remove('authorizationData');
        _authentication.isAuth = false;
        _authentication.isAddIdent = false,
        _authentication.userNameAddIdent = "",
        _authentication.userName = "";
        _authentication.useRefreshTokens = false;
        _authentication.idUsuario = 0;
        _authentication.idTipoUsuario = 0;
        _authentication.logOut = false;
        $location.url('home/login');
    };

    var _getTokenValidation = function (token) {
        getToken = token;
    }

    var _isTokenValidation = function () {
        if (getToken.trim() !== '') {
            return true;
        }
        return false;
    }

    var _validateToken = function () {
        var deferred = $q.defer();
        _authentication.logOut = undefined;

        $http.post(serviceBase + '/api/v1/verify-access', null, {
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'Authorization': 'Bearer ' + getToken
            }
        }).then(function (response) {
            localStorageService.set(
                'authorizationData',
                { token: response.data.token.access_token, userName: response.data.token.userName, refreshToken: "", useRefreshTokens: false }
            );

            _authentication.isAuth = true;
            _authentication.userName = response.data.token.userName;
            _authentication.useRefreshTokens = false;

            deferred.resolve(response);
        }, function (err, status) {
            _logOutLogin();
            deferred.reject(err);
            });

        getToken = '';

        return deferred.promise;
    }

    ////===================================================================
    //// Este método se independizo para poder auditar el cierre de sesión
    ////===================================================================
    var _logOut = function () {
        _authentication.logOut = true;
    };

    var _fillAuthData = function () {
        var authData = localStorageService.get('authorizationData');
        if (authData) {
            _authentication.isAuth = true;
            _authentication.userName = authData.userName;
            _authentication.useRefreshTokens = authData.useRefreshTokens;
            _authentication.idUsuario = authData.idUsuario;
            _authentication.idTipoUsuario = authData.idTipoUsuario;
        }
    };

    var _refreshToken = function () {
        var deferred = $q.defer();
        var authData = localStorageService.get('authorizationData');
        if (authData) {
            if (authData.useRefreshTokens) {
                var data = "grant_type=refresh_token&refresh_token=" + authData.refreshToken + "&client_id=" + ngAuthSettings.clientId;
                localStorageService.remove('authorizationData');
                $http.post(serviceBase + 'token', data, { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }).success(function (response) {
                    localStorageService.set('authorizationData', { token: response.access_token, userName: response.userName, refreshToken: response.refresh_token, useRefreshTokens: true });
                    deferred.resolve(response);
                }).error(function (err, status) {
                    _logOutLogin();
                    deferred.reject(err);
                });
            }
        }
        return deferred.promise;
    };

    var _addIdentity = function (entity) {
        var authData = localStorageService.get('authorizationData');
        if (authData) {
            _authentication.isAddIdent = true;
            _authentication.userName = entity.UserName;
            _authentication.userNameAddIdent = authData.userName;

            localStorageService.set('authorizationData', {
                token: authData.token,
                userName: entity.UserName,
                refreshToken: authData.refreshToken,
                useRefreshTokens: authData.useRefreshTokens,
                userNameAddIdent: authData.userName,
            });

            $state.go('Index.Index', {}, { reload: true });
        }
    };

    var _obtainAccessToken = function (externalData) {
        var deferred = $q.defer();
        $http.get(serviceBase + 'api/account/ObtainLocalAccessToken', { params: { provider: externalData.provider, externalAccessToken: externalData.externalAccessToken } }).success(function (response) {
            localStorageService.set('authorizationData', { token: response.access_token, userName: response.userName, refreshToken: "", useRefreshTokens: false });
            _authentication.isAuth = true;
            _authentication.userName = response.userName;
            _authentication.useRefreshTokens = false;
            deferred.resolve(response);
        }).error(function (err, status) {
            _logOut();
            deferred.reject(err);
        });
        return deferred.promise;
    };

    authServiceFactory.login = _login;
    authServiceFactory.logOut = _logOut;
    authServiceFactory.loginAD = _loginAD;
    authServiceFactory.fillAuthData = _fillAuthData;
    authServiceFactory.authentication = _authentication;
    authServiceFactory.refreshToken = _refreshToken;
    authServiceFactory.addIdentity = _addIdentity;
    authServiceFactory.logOutLogin = _logOutLogin;
    authServiceFactory.validateToken = _validateToken;
    authServiceFactory.getTokenValidation = _getTokenValidation;
    authServiceFactory.isTokenValidation = _isTokenValidation;

    return authServiceFactory;
}]);