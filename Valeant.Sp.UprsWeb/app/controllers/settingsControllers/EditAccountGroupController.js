angular.module("valeant.controllers")

    .controller("EditAccountGroupController", function ($scope, $uibModalInstance, $http, row) {
        $scope.row = row;

        $scope.ok = function () {
            if ($scope.row.IsNew)
                $scope.process("create");
            else
                $scope.process("update");
        };

        $scope.process = function (action) {
            $http({
                method: "POST",
                url: "./accountGroups/" + action,
                data: JSON.stringify($scope.row)
            }).success(function (response) {
                $uibModalInstance.close($scope.row);
            }).error(function (error) {
                throw error;
            });
        }

        $scope.cancel = function () {
            $uibModalInstance.dismiss("cancel");
        };

       
        activate();

        function activate() {

        }       
});