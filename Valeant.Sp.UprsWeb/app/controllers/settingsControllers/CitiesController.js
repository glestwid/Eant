﻿angular.module("valeant.controllers")

    .controller("CitiesController", function ($scope, $http, toastr, $uibModal, $q, $appConfig) {
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
                { name: "Город", field: "Name" },
                { name: "Страна", field: "CountryId", cellFilter: "idToCountryName:grid.appScope.countries" },
                { name: "", width: 100, field: "empty", enableCellEdit: false, cellTemplate: "app/templates/settings/modals/editRemoveLink.html" }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight,
                editRow: function (grid, row) {
                    var modalInstance = $uibModal.open({
                        templateUrl: "app/templates/settings/modals/editCityModal.html",
                        controller: "EditCityController",
                        resolve: {
                            row: function () {
                                return angular.copy(row.entity);
                            },
                            countries: function () {
                                return $scope.countries;
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
                            url: "./cities/delete",
                            data: JSON.stringify(row.entity)
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
                templateUrl: "app/templates/settings/modals/editCityModal.html",
                controller: "EditCityController",
                resolve: {
                    row: function () {
                        return { IsNew: true };
                    },
                    countries: function () {
                        return $scope.countries;
                    }
                }
            });

            modalInstance.result.then(function (editedRow) {
                $scope.reload();
            }, function () {
                console.log("Modal dismissed at: " + new Date());
            });
        }

        $scope.reload = function () {
            var referencesRequest = $http({
                method: "POST",
                url: "./references/getAll",
                data: JSON.stringify(["country"])
            }).success(function (response) {
                $scope.countries = response.countries;
            }).error(function (error) {
                toastr.error("Ошибка!");
                throw error;
            });

            $q.all([referencesRequest]).then(function (responses) {
                $http({
                    method: "GET",
                    url: "./cities/getAll",
                    cache: false
                }).success(function (response) {
                    $scope.data = response;
                    if ($appConfig.showSuccessToastr)
                        toastr.success("Данные о городах получены!");
                }).error(function (error) {
                    toastr.error("Ошибка!");
                    throw error;
                });
            });
        }

        activate();

        function activate() {
            $scope.reload();
        }
    });