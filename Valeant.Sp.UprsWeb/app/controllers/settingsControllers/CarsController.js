angular.module("valeant.controllers")

    .controller("CarsController", function ($scope, $http, toastr, $uibModal, $appConfig) {
        $scope.gridOptions = {
            data: "data.Cars",
            enableSorting: false,
            enableGridMenu: false,
            paginationPageSizes: [15],
            paginationPageSize: 15,
            rowHeight: 40,
            enableFiltering: false,
            enableColumnResizing: false,
            columnDefs: [
                { name: "Автомобиль", field: "Type" },
                { name: "Номер", field: "Number"},
                { name: "Сотрудник", field: "Human.FullName"}               
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight
            }
        };
        

        $scope.updateList = function () {
            var modalInstance = $uibModal.open({
                templateUrl: "app/templates/modals/passwordModal.html",
                controller: "PasswordModalController"

            });
          

            modalInstance.result.then(function (Password) {
                console.log("Password" + Password);
                $http({
                    method: "POST",
                    url: "./cars/update",
                    data: JSON.stringify(Password)
                }).success(function (response) {

                  
                    $scope.data = response;

                    if ($scope.data.Success)
                        if ($appConfig.showSuccessToastr)
                            toastr.success("Данные получены!");
                    else
                        toastr.error("Справочник не был обновлен. Ошибка доступа к сервису");
                    $scope.reload();
                }).error(function (error) {
                   
                    throw error;
                });


            }, function () {
                console.log("Modal dismissed at: " + new Date());
            });
        }

        $scope.reload = function () {
                    
                $http({
                    method: "GET",
                    url: "./cars/getAll",
                    cache: false
                }).success(function (response) {
                    $scope.data = response;
                    if ($appConfig.showSuccessToastr)
                        toastr.success("Данные получены!");
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