angular.module("valeant.controllers")
    .controller("PrepaymentRequestsContoller", function ($scope, $state, $http, toastr, $uibModal, $appConfig) {
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
                { name: "№ заявки", field: "Number", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Дата заявки", field: "Date", cellTemplate: $appConfig.gridCellTemplate, cellFilter: "date: 'dd.MM.yyyy'" },
                { name: "Тип заявки", field: "Type", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Сумма", field: "Sum", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Статус", field: "Status", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Действия", field: "dummy", width: 180, cellTemplate: $appConfig.gridHistoryCellTemplate }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight,
                cellClicked: function (row, col) {
                    var data = row.entity;
                    setTimeout(function () {
                        $state.transitionTo("newPrepaymentRequest", { id: data.Id, prevState: $state.current.name });
                    }, 300);
                },
                showHistory: function (data) {
                    $appConfig.showHistoryFunction($uibModal, data);
                }
            }
        };

        $scope.selectedStatusCriteria = "Все";
        $scope.selectedDateRangeCriteria = "Месяц";
        $scope.requestStatuses = [
            "Все",
            "Черновик",
            "На согласовании (Непосредственный руководитель)",
            "Аннулирована",
            "На доработке",
            "На согласовании (HR сотр.)",
            "На согласовании (Трэвел координатор)",
            "На согласовании (Руководитель 2-го уровня)",
            "На согласовании (Директор департамента)",
            "На согласовании (Ген. директор)",
            "Заменена",
            "Ожидает авансового отчета"
        ];

        $scope.reload = function () {
            $http({
                method: "GET",
                url: "./prepaymentRequests/getAll?statusFilter=" + $scope.selectedStatusCriteria + "&dateRangeFilter=" + $scope.selectedDateRangeCriteria + "&search=" + $scope.searchFilter,
                cache: false
            }).success(function (response) {
                $scope.data = response;
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные о заявках получены!");
            }).error(function (error) {
                throw error;
            });
        }

        $scope.createNew = function() {
            $state.transitionTo("newPrepaymentRequest", { id: undefined, prevState: $state.current.name });
        }

        activate();

        function activate() {
            $scope.reload();
        }
    });