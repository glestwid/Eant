angular.module("valeant.controllers")

    .controller("PasswordModalController", function ($scope, $uibModalInstance, $http) {
        
        $scope.formData = {
            Username: undefined,
            Password: undefined
        }
       
        $scope.ok = function () {
           
            $uibModalInstance.close($scope.formData);
        };

        $scope.cancel = function () {
            $uibModalInstance.dismiss("cancel");
            
        };

        $scope.reload = function () {

            $http({
                method: "GET",
                url: "./login/getUser",
                cache: false
            }).success(function (response) {
                $scope.formData.Username = response;
                
            }).error(function (error) {
                toastr.error("Ошибка!");
                throw error;
            });

        }

               
        activate();

        function activate() {
            $scope.reload();
        }       
});