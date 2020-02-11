angular.module("valeant.controllers")

    .controller("EditFuelCardController", function ($scope, $uibModalInstance, $http, row, countries) {
        $scope.row = row;
       

        $scope.ok = function () {
           
                $scope.process("update");
        };

        $scope.process = function (action) {
            $http({
                method: "POST",
                url: "./fuelCards/" + action,
                data: JSON.stringify($scope.row)
            }).success(function (response) {
                $uibModalInstance.close($scope.row);
            }).error(function (error) {
                throw error;
            });
        }

        $scope.saveAndClose = function () {
            $uibModalInstance.dismiss("saveAndClose");
        };

       
        activate();

        function activate() {

        }       
});