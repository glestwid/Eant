angular.module("valeant.controllers")

    .controller("FuelCardsController", function ($scope, $http, toastr, $uibModal, $appConfig) {
        $scope.gridOptions = {
            data: "data",
            enableSorting: false,
            enableGridMenu: false,
            paginationPageSizes: [15],
            paginationPageSize: 15,
            rowHeight: 40,
            enableFiltering: false,
            enableColumnResizing: false,
            columnDefs: [
                { name: "Сотрудник", field: "FullName" },
                { name: "Номер карты", field: "FuelCard" },
                { name: "", width: 100, field: "empty", enableCellEdit: false, cellTemplate: "app/templates/settings/modals/editLink.html" }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight,
                editRow: function (grid, row) {
                    var modalInstance = $uibModal.open({
                        templateUrl: "app/templates/settings/modals/editFuelCardModal.html",
                        controller: "EditFuelCardController",
                        resolve: {
                            row: function () {
                                return row.entity;
                            },
                            countries: function () {
                                return $scope.countries;
                            }
                        }
                    });

                    modalInstance.result.then(function (editedRow) {
                        row = editedRow;
                    }, function () {
                        console.log("Modal dismissed at: " + new Date());
                    });
                }
            }
        };

        $scope.reload = function () {
            $http({
                method: "GET",
                url: "./fuelCards/getAll",
                cache: false
            }).success(function (response) {
                $scope.data = response;
                console.log("fuelCards");

                console.log(response);
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные по ТК  получены!");
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