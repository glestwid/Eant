angular.module("valeant.controllers")

    .controller("EditPersonController", function ($scope, $uibModalInstance, $http, toastr, $appConfig, row) {
        $scope.row = row;
        $scope.persons = [];
        $scope.roles = [];
        $scope.selectedRole = undefined;
        $scope.selectedDeputy = undefined;
        $scope.selectedAssistant = undefined;
       
        $scope.ok = function () {
            $scope.row.DeputyId = $scope.selectedDeputy == undefined? null : $scope.selectedDeputy.Id;
            $scope.row.DeputyName = $scope.selectedDeputy == undefined ? null : $scope.selectedDeputy.FullName;
            $scope.row.AssistantId = $scope.selectedAssistant == undefined ? null : $scope.selectedAssistant.Id;
            $scope.row.AssistantName = $scope.selectedAssistant == undefined ? null : $scope.selectedAssistant.FullName;
           
            $http({
                method: "POST",
                url: "./security/updateRoles",
                data: JSON.stringify($scope.row)
            }).success(function (response) {
                $uibModalInstance.close($scope.row);
            }).error(function (error) {
                throw error;
            });           
        };

        $scope.cancel = function () {
            $uibModalInstance.dismiss("cancel");
        };

        $scope.addNewRole = function() {
            $scope.row.Roles.push({ Name: "", Id: -1 });
        }

        $scope.removeRole = function(index) {
            $scope.row.Roles.splice(index, 1);
        }
       
        $scope.removeDeputy = function () {
            $scope.selectedDeputy = undefined;
        }
        
        activate();

        function activate() {
            $http({
                method: "GET",
                url: "./security/getHumans?statusesString=Работает,Уволен",
                cache: false
            }).success(function (response) {
                $scope.persons = response;
                response.forEach(function (p) {
                    if(row.DeputyId === p.Id) {
                        $scope.selectedDeputy = p;
                    }
                    if (row.AssistantId === p.Id) {
                        $scope.selectedAssistant = p;
                    }
                });
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные получены!");
            }).error(function (error) {
                throw error;
            });

            $http({
                method: "POST",
                url: "./references/getAll",
                data: JSON.stringify(["role"])
            }).success(function (response) {
                $scope.roles = response.roles;
                if ($appConfig.showSuccessToastr)
                    toastr.success("роли получены!");
            }).error(function (error) {
                throw error;
            });
        }

       
});