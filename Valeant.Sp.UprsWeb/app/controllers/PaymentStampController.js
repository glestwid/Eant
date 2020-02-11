angular.module("valeant.controllers")
    .controller("PaymentStampController", function ($scope, $http, $uibModal, toastr, $state, $appConfig) {
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
                { name: "№ документа", field: "Number", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Дата документа", field: "Date", cellTemplate: $appConfig.gridCellTemplate, cellFilter: "date: 'dd.MM.yyyy'" },
                { name: "Тип документа", field: "Type", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Сотрудник", field: "Person", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Подразделение", field: "Division", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Оплачено", field: "dummy", cellTemplate: '<div><div class="ui-grid-cell-contents text-center"><div class="checkbox"><checkbox ng-model="row.entity.paid" ng-click="grid.appScope.changePaidState(row.entity)"></checkbox></div></div></div>' },
                { name: "Действия", field: "dummy", width: 180, cellTemplate: $appConfig.gridHistoryCellTemplate }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight,
                cellClicked: function (row, col) {
                    var data = row.entity;
                    setTimeout(function () {
                        if (data.Type === "Заявка на аванс")
                            $state.transitionTo("approvalPrepaymentRequest", { id: data.Id, prevState: $state.current.name });
                    }, 300);
                },
                changePaidState: function (data) {
                    if (data.Paid) {
                        $scope.markUnpaid(data.Id);
                    } else {
                        $scope.markPaid(data.Id);
                    }
                },
                showHistory: function (data) {
                    $appConfig.showHistoryFunction($uibModal, data);
                }
            }
        };

        $scope.selectedStatusCriteria = "Утверждена";
        $scope.selectedDateRangeCriteria = "Месяц";

        $scope.markPaid = function(documentId) {
            $http({
                method: "POST",
                url: "./prepaymentRequests/markPaid",
                data: JSON.stringify({ documentId: documentId })
            }).success(function (response) {
                if ($appConfig.showSuccessToastr)
                    toastr.success("Отметка об оплате установлена!");
                $scope.reload();
            }).error(function (error) {
                toastr.error("При установке отметки об оплате произошла ошибка!");
                throw error;
            });
        }

        $scope.markUnpaid = function (documentId) {
            $http({
                method: "POST",
                url: "./prepaymentRequests/markUnpaid",
                data: JSON.stringify({ documentId: documentId })
            }).success(function (response) {
                if ($appConfig.showSuccessToastr)
                    toastr.success("Отметка об оплате снята!");
                $scope.reload();
            }).error(function (error) {
                toastr.error("При снятии отметки об оплате произошла ошибка!");
                throw error;
            });
        }

        $scope.changePaidState = function(advance) {
            if (advance.Paid) {
                $scope.markUnpaid(advance.Id);
            } else {
                $scope.markPaid(advance.Id);
            }
        }

        $scope.reload = function () {
            $http({
                method: "GET",
                url: "./prepaymentRequests/getApproved?dateRangeFilter=" + $scope.selectedDateRangeCriteria,
                cache: false
            }).success(function (response) {
                $scope.approvals = response;
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные о документах, ожидающих оплаты, получены!");
            }).error(function (error) {
                throw error;
            });
        }

        activate();

        function activate() {
            $scope.reload();
        }
    });