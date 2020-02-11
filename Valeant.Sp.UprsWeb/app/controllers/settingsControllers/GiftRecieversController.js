angular.module("valeant.controllers")

    .controller("GiftRecieversController", function ($scope, $http, toastr, $uibModal, $appConfig) {
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
                { name: "Фамилия", field: "SecondName" },
                { name: "Имя", field: "Name" },
                { name: "Отчество", field: "MiddleName" },
                { name: "Организация", field: "Organization" },
                { name: "Должность", field: "Position" },
                { name: "Номер договора", field: "AgreementNumber" },
                {
                    name: "",
                    width: 100,
                    field: "empty",
                    enableCellEdit: false,
                    cellTemplate: "app/templates/settings/modals/editRemoveLink.html"
                }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight,
                editRow: function (grid, row) {
                    var modalInstance = $uibModal.open({
                        templateUrl: "app/templates/settings/modals/editGiftRecieverModal.html",
                        controller: "EditGiftRecieverController",
                        resolve: {
                            row: function () {
                                return angular.copy(row.entity);
                            }
                        }
                    });

                    modalInstance.result.then(function (editedRow) {
                        //row.entity = editedRow;
                        $scope.reload(); //список должны пересортировать
                    }, function () {
                        console.log("Modal dismissed at: " + new Date());
                    });
                },
                removeRow: function(grid, row) {
                    var modalInstance = $uibModal.open({
                        templateUrl: "app/templates/modals/approveAction.html",
                        controller: "ApproveActionModalController",
                        resolve: {
                            title: function() {
                                return "Удаление";
                            }
                        }
                    });

                    modalInstance.result.then(function(res) {
                        $http({
                            method: "POST",
                            url: "./giftRecievers/delete",
                            data: JSON.stringify(row.entity)
                        }).success(function(response) {
                            if ($appConfig.showSuccessToastr)
                                toastr.success("Удалено!");
                            $scope.reload();
                        }).error(function(error) {
                            throw error;
                        });
                    }, function() {
                        console.log("Modal dismissed at: " + new Date());
                    });
                }
            }
        };

        $scope.addRow = function (grid, row) {
            $uibModal.open({
                templateUrl: "app/templates/settings/modals/editGiftRecieverModal.html",
                controller: "EditGiftRecieverController",
                resolve: {
                    row: function() {
                        return { IsNew: true };
                    }
                }
            }).result.then(function() {
                $scope.reload();
            });
        }


        $scope.getRecievers = function() {
            $http({
                method: "GET",
                url: "./giftRecievers/getAll"
            }).success(function (response) {
                $scope.data = response;
            }).error(function (error) {
                toastr.error("Ошибка!");
                throw error;
            });
        }

        $scope.reload = function () {
            $scope.getRecievers();
        }

        activate();

        function activate() {
            $scope.reload();
        }
    });