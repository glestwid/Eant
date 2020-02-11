angular.module("valeant.controllers")
    .controller("TripRequestsController", function ($scope, $state, $http, toastr, $uibModal, $timeout, $appConfig) {
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
                { name: "Дата документа", field: "FromDate", cellTemplate: $appConfig.gridCellTemplate, cellFilter: "date: 'dd.MM.yyyy'" },
                { name: "Тип документа", field: "DocumentType", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Сумма", field: "Sum", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Статус", field: "Status", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Действия", field: "dummy", width: 180, cellTemplate: $appConfig.gridHistoryCellTemplate }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight,
                cellClicked: function (row, col) {
                    var data = row.entity;
                    setTimeout(function () {
                        $state.transitionTo("newTripRequest", { id: data.Id, prevState: $state.current.name });
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
                url: "./tripRequests/getAll?statusFilter=" + $scope.selectedStatusCriteria + "&dateRangeFilter=" + $scope.selectedDateRangeCriteria,
                cache: false
            }).success(function (response) {
                $scope.data = response;
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные о заявках получены!");
            }).error(function (error) {
                throw error;
            });
        }

        $scope.createNew = function () {
            $state.transitionTo("newTripRequest", { id: undefined, prevState: $state.current.name });
        }

        $scope.printList = function (d) {
            window.open("./TripRequests/printList?statusFilter=" + $scope.selectedStatusCriteria + "&dateRangeFilter=" + $scope.selectedDateRangeCriteria + "&rand=" + Math.random());
            return false;
        }

        activate();

        function activate() {
            $scope.reload();
        }
    });