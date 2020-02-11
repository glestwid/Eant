angular.module("valeant.controllers")

    .controller("PersonRolesController", function ($scope, $http, toastr, $uibModal, $appConfig) {
        $scope.searchFilter = "";

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
                { name: "E-mail", field: "Email" },
                { name: "ФИО", field: "FullName" },
                { name: "Статус", field: "EmployeeStatus" },
                { name: "Табельный номер", field: "ClockNumber" },
                { name: "Роли", field: "Roles", cellFilter: "personRolesFilter" },
                { name: "Руководитель", field: "ManagerName" },
                { name: "Заместитель", field: "DeputyName" },
                { name: "Ассистент", field: "AssistantName" },
                { name: "", width: 70, field: "empty", enableCellEdit: false, cellTemplate: "app/templates/settings/modals/editLink.html" }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight,
                editRow: function (grid, row) {
                    var modalInstance = $uibModal.open({
                        templateUrl: "app/templates/settings/modals/editPersonModal.html",
                        controller: "EditPersonController",
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

        $scope.reload = function () {
            $http({
                method: "GET",
                url: "./security/getHumans?statusesString=Работает,Уволен&search=" + $scope.searchFilter,
                cache: false
            }).success(function (response) {
                $scope.data = response;
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные о ролях получены!");
            }).error(function (error) {
                throw error;
            });
        }


        $scope.export = function (searchString) {
            window.open("./printing/export?statusesString=Работает,Уволен&search=" + searchString + "&rand=" + Math.random());
            return false;
        }

        activate();

        function activate() {
            $scope.reload();
        }
    });