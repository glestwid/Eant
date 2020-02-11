angular.module("valeant.controllers")

    .controller("RolesController", function ($scope, $http, toastr, $uibModal, $appConfig) {
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
                { name: "Должность", field: "Name" },
                { name: "Группа должностей", field: "Code" },
                { name: "", width: 100, field: "empty", enableCellEdit: false, cellTemplate: "app/templates/settings/modals/editLink.html" }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight,
                editRow: function (grid, row) {
                    var modalInstance = $uibModal.open({
                        templateUrl: "app/templates/settings/modals/editRoleModal.html",
                        controller: "EditRoleController",
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
                }
            }
        };

        $scope.addRow = function (grid, row) {
            var modalInstance = $uibModal.open({
                templateUrl: "app/templates/settings/modals/editRoleModal.html",
                controller: "EditRoleController",
                resolve: {
                    row: function () {
                        return { IsNew: true };
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
            $http({
                method: "GET",
                url: "./roles/getAll",
                cache: false
            }).success(function (response) {
                $scope.data = response;
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные целей поездки получены!");
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