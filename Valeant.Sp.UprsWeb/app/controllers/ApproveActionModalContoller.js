angular.module("valeant.controllers")

    .controller("ApproveActionModalController", function ($scope, $uibModalInstance, title) {
        $scope.title = title;
        $scope.ok = function () {
            $uibModalInstance.close(true);
        };

        $scope.cancel = function () {
            $uibModalInstance.dismiss("cancel");
        };
    });