angular.module("valeant.controllers")

    .controller("ProfileController", function ($scope, $http, $state, toastr, $appConfig) {

        $scope.reload = function() {
            $http({
                method: "GET",
                url: "./security/getCurrent",
                cache: false
            }).success(function(response) {
                $scope.person = response;
            }).error(function(error) {
                throw error;
            });

            $http({
                method: "GET",
                url: "./cars/getCurrentUserCars",
                cache: false
            }).success(function (response) {
                $scope.cars = response;
            }).error(function (error) {
                throw error;
            });
        };

        $scope.save = function () {
            console.log(this);
            $http({
                method: "POST",
                url: "./security/save",
                data: JSON.stringify($scope.person)
            }).success(function (response) {
                if ($appConfig.showSuccessToastr)
                    toastr.success("Сохранено!");
                sessionStorage.setItem("currentUser", JSON.stringify($scope.person));
                $state.transitionTo("home");
            }).error(function (error) {
                throw error;
            });
        }
        
        $scope.goBack = function() {
            $state.transitionTo("home");
        }

        activate();

        function activate() {
            $scope.reload();
        }
    })
    ;