angular.module("valeant.controllers")

    .controller("LoadLedgerEntriesController", function ($scope, $http, toastr, $uibModal, $appConfig) {
        $scope.selectedDateRangeCriteria = "Месяц";
        $scope.gridOptions = {
            data: "data.Data",
            enableSorting: false,
            enableGridMenu: false,
            paginationPageSizes: [15],
            paginationPageSize: 15,
            rowHeight: 40,
            enableFiltering: false,
            enableColumnResizing: false,
            columnDefs: [
               { name: "Дата", field: "FormatedDate" },
               { name: "Сотрудник", field: "EmployeeName" },
               { name: "Тип документа", field: "DocumentType" },
               { name: "Номер", field: "Number" },
               { name: "Документ", field: "DocumentNumber" },
               { name: "Уч. группа", field: "PostingGroup" },
               { name: "Цель платежа", field: "PaymentPurpose" },
               { name: "Сумма", field: "Ammount" }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight
            }
        };

        $scope.update = function () {
            var modalInstance = $uibModal.open({
                templateUrl: "app/templates/modals/passwordModal.html",
                controller: "PasswordModalController"

            });


            modalInstance.result.then(function (Password) {

                $http({
                    method: "POST",
                    url: "./loadLedgerEntries/update",
                    data: JSON.stringify(Password)
                })
                    .success(function (response) {
                        $scope.data = response;

                        if ($scope.data.Success) {
                            if ($appConfig.showSuccessToastr)
                                toastr.success($scope.data.Message);
                        }
                        else
                            toastr.error($scope.data.Message);
                        $scope.reload();
                    })
                    .error(function (error) {
                        throw error;
                    });


            }, function () {
                console.log("Modal dismissed at: " + new Date());
            });
        }


        $scope.reload = function () {
            $http({
                method: "GET",
                url: "./loadLedgerEntries/getAll?dateRangeFilter=" + $scope.selectedDateRangeCriteria,
                cache: false
            }).success(function (response) {
                $scope.data = response;

                if ($scope.data.Success) {
                    if ($appConfig.showSuccessToastr)
                        toastr.success("Данные получены");
                }
                else
                    toastr.error($scope.data.Message);

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