'use strict';

app.service("APIService", ['$http', 'ngSettings', function ($http, ngSettings, $q) {

    var serviceBase = ngSettings.apiServiceBaseUri;
    var apiServiceBI = ngSettings.apiServiceBI;

    this.getSubs = function (url) {
        url = serviceBase + url;
        return $http.get(url).then(function (response) {
            return response.data;
        });
    }

    this.getArray = function (url) {
        url = serviceBase + url;
        return $http({
            url: url,
            method: "POST",
            responseType: 'arraybuffer',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            }
        }).then(function (response) {
            return response.data;
        });
    }

    this.saveSubscriber = function (sub, url) {
        url = serviceBase + url;
        return $http({
            method: 'post',
            data: sub,
            url: url
        });
    }

    this.updateSubscriber = function (sub) {
        return $http({
            method: 'put',
            data: sub,
            url: 'api/Subscriber'
        });
    }

    this.deleteSubscriber = function (subID, url) {
        url = serviceBase + url;
        return $http({
            method: 'delete',
            data: subID,
            url: url,
            headers: {
                'Content-Type': 'application/json'
            }
        });
    }

    this.open = function (url) {
        url = serviceBase + url;
        window.open(url)
    }

    //============= Métodos para llamar WCF =================

    this.getMetodoBI = function (url) {
        url = apiServiceBI + url;
        return $http.get(url).then(function (response) {
            return response.data;
        });
    }

    this.postMetodoBI = function (model, url) {
        url = apiServiceBI + url;
        return $http({
            method: 'post',
            data: model,
            url: url,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
            }
        });
    }
}]);