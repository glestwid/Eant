angular.module("valeant.controllers")

    .controller("CostItemsController", function ($scope, $http, toastr, $uibModal, $appConfig) {
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
                { name: "Статья расходов", field: "Title" },
                { name: "", width: 100, field: "empty", enableCellEdit: false, cellTemplate: "app/templates/settings/modals/editRemoveLink.html" }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight,
                editRow: function (grid, row) {
                    var modalInstance = $uibModal.open({
                        templateUrl: "app/templates/settings/modals/editCostItemModal.html",
                        controller: "EditCostItemController",
                        resolve: {
                            row: function () {
                                return angular.copy(row.entity);
                            }
                        }
                    });

                    modalInstance.result.then(function (editedRow) {
                        $scope.reload(); //список должны пересортировать
                    }, function () {
                        console.log("Modal dismissed at: " + new Date());
                    });
                },
                removeRow: function (grid, row) {
                    var modalInstance = $uibModal.open({
                        templateUrl: "app/templates/modals/approveAction.html",
                        controller: "ApproveActionModalController",
                        resolve: {
                            title: function () {
                                return "Удаление";
                            }
                        }
                    });

                    modalInstance.result.then(function (res) {
                        $http({
                            method: "POST",
                            url: "./costItems/delete",
                            data: JSON.stringify(row.entity.ExpenditureId)
                        }).success(function (response) {
                            if ($appConfig.showSuccessToastr)
                                toastr.success("Удалено!");
                            $scope.reload();
                        }).error(function (error) {
                            throw error;
                        });
                    }, function () {
                        console.log("Modal dismissed at: " + new Date());
                    });
                }
            }
        };

        $scope.addRow = function (grid, row) {
            var modalInstance = $uibModal.open({
                templateUrl: "app/templates/settings/modals/editCostItemModal.html",
                controller: "EditCostItemController",
                resolve: {
                    row: function () {
                        return { IsNew: true };
                    }
                }
            });

            modalInstance.result.then(function (editedRow) {
                $scope.reload(); //список должны пересортировать
            }, function () {
                console.log("Modal dismissed at: " + new Date());
            });
        }

        $scope.reload = function () {
            $http({
                method: "GET",
                url: "./costItems/getAll",
                cache: false
            }).success(function (response) {
                $scope.data = response;
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные статей расходов получены!");
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