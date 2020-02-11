angular.module("valeant.controllers")

    .controller("DenyReasonModalController", function ($scope, $uibModalInstance) {
        $scope.reasonText = undefined;
        $scope.ok = function () {
            $uibModalInstance.close($scope.reasonText);
        };

        activate();

        function activate() {
           
        }

        $scope.close = function () {
            $uibModalInstance.dismiss();
        };

    });