angular.module("valeant.controllers")

    .controller("NotifyModalController", function ($scope, $uibModalInstance, title, message) {
        $scope.title = title;
        $scope.message = message;

        activate();

        function activate() {
        }

        $scope.cancel = function () {
            $uibModalInstance.dismiss("cancel");
        };

    });