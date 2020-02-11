angular.module("valeant.controllers")

    .controller("ExportAdvanceReportController", function ($scope, $http, toastr, $uibModal, $appConfig) {
        $scope.export = function () {
            var modalInstance = $uibModal.open({
                templateUrl: "app/templates/modals/passwordModal.html",
                controller: "PasswordModalController"

            });
           
            modalInstance.result.then(function (Password) {
               
                $http({
                    method: "POST",
                    url: "./exportAdvanceReport/export",
                    data: JSON.stringify(Password)
                }).success(function (response) {

                   
                    $scope.data = response;

                    if ($scope.data.Success)
                        if ($appConfig.showSuccessToastr)
                            toastr.success($scope.data.Message);
                    else
                        toastr.error($scope.data.Message);
                    $scope.reload();
                }).error(function (error) {
                   
                    throw error;
                });


            }, function () {
                console.log("Modal dismissed at: " + new Date());
            });
        }


        $scope.reload = function () {
             
        }

        activate();

        function activate() {            
            $scope.reload();
        }
    });