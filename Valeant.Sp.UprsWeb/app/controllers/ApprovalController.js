angular.module("valeant.controllers")
    .controller("ApprovalController", function ($scope, $http, $uibModal, toastr, $state, $appConfig) {
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
                { name: "№ документа", field: "Number", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Дата документа", field: "Date", cellTemplate: $appConfig.gridCellTemplate, cellFilter: "date: 'dd.MM.yyyy'" },
                { name: "Тип документа", field: "Type", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Сотрудник", field: "Person", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Подразделение", field: "Division", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Согласовано", field: "IsApproved", cellTemplate: $appConfig.gridCellTemplate, cellFilter: "applyFunction:grid.appScope.isApprovedFilter" },
                { name: "Статус", field: "Status", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Действия", field: "dummy", width: 180, cellTemplate: $appConfig.gridHistoryCellTemplate }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight,
                isApprovedFilter: function(value) {
                    return value ? "Да" : "Нет";
                },
                cellClicked: function (row, col) {
                    var data = row.entity;
                    setTimeout(function () {
                        if (data.Type === "Заявка на аванс")
                            $state.transitionTo("approvalPrepaymentRequest", { id: data.Id, prevState: $state.current.name });
                        if (data.Type === "Заявка на командировку/служебную поездку")
                            $state.transitionTo("approvalTripRequest", { id: data.Id, prevState: $state.current.name });
                        if (data.Type === "Маршрутный лист")
                            $state.transitionTo("approvalTravelList", { id: data.Id, prevState: $state.current.name });
                        if (data.Type === "Авансовый отчет по командировке/служебной поездке")
                            $state.transitionTo("approvalTripAdvanceReport", { id: data.Id, prevState: $state.current.name });
                        if (data.Type === "Авансовый отчет по представительским и текущим расходам")
                            $state.transitionTo("approvalRepresentativeAdvanceReport", { id: data.Id, prevState: $state.current.name });
                        if (data.Type === "Заявка на подарок")
                            $state.transitionTo("approvalGiftRequest", { id: data.Id, prevState: $state.current.name });

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
            "На согласовании",
            "Аннулирована",
            "На доработке",
            "Заменена",
            "Ожидает авансового отчета"
        ];

        $scope.reload = function () {
            $http({
                method: "GET",
                url: "./approvals/getAll?statusFilter=" + $scope.selectedStatusCriteria + "&dateRangeFilter=" + $scope.selectedDateRangeCriteria + "&search=" + $scope.searchFilter,
                cache: false
            }).success(function (response) {
                $scope.data = response;
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные согласования получены!");
            }).error(function (error) {
                throw error;
            });
        }

        activate();

        function activate() {
            $scope.reload();
        }
    });