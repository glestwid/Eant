angular.module("valeant.services")
    .factory("$storageService", function () {

        var internalStorage = new Array();

        var store = function (key, data) {
            internalStorage[key] = data;
        }

        var get = function (key) {
            return internalStorage[key];
        }

        return {
            store: store,
            get: get
        };
    });
