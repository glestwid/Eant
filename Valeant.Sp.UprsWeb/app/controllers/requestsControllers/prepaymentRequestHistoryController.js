angular.module("valeant.controllers")

    .controller("PrepaymentRequestHistoryController", function ($scope, $uibModalInstance, $http, stateParams) {
        $scope.historyItems = [];
        $scope.ok = function () {
            $uibModalInstance.close("smthing");
        };

        $scope.export = function () {
            window.open("./history/export?requestType=" + stateParams.Type + "&id=" + stateParams.Id);
        };


        activate();

        function activate() {
            $http({
                method: "POST",
                url: "./history/getHistory?requestType=" + stateParams.Type + "&id=" + stateParams.Id
            }).success(function (response) {
                console.log(response);
                $scope.historyItems = response;
            }).error(function (error) {
                throw error;
            });

        } 

    });