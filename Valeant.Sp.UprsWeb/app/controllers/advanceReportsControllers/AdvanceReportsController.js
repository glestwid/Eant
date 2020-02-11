angular.module("valeant.controllers")
    .controller("AdvanceReportsController", function ($scope, $http, toastr, $state, $q, $uibModal, $appConfig) {
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
                { name: "Сумма", field: "Sum", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Статус", field: "Status", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Действия", field: "dummy", width: 180, cellTemplate: $appConfig.gridHistoryCellTemplate }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight,
                cellClicked: function (row, col) {
                    var data = row.entity;
                    setTimeout(function () {
                        switch (data.Type) {
                            case "Авансовый отчет по командировке/служебной поездке":
                                {
                                    $state.transitionTo("newTripAdvanceReport", { id: data.Id, prevState: $state.current.name });
                                    break;
                                }
                            case "Авансовый отчет по представительским и текущим расходам":
                                {
                                    $state.transitionTo("newRepresentativeAdvanceReport", { id: data.Id, prevState: $state.current.name });
                                    break;
                                }
                            default:
                                toastr.error("Не реализовано");
                        }
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

        $scope.reportTypes = [
            { type: "trip", title: "Авансовый отчёт по командировке/служебной поездке" },
            { type: "representative", title: "Авансовый отчёт по представительским и текущим расходам" }
        ];

        $scope.reload = function() {
           var tripReports =   $http({
                method: "GET",
                url: "./tripAdvanceReports/getAll?statusFilter=" + $scope.selectedStatusCriteria + "&dateRangeFilter=" + $scope.selectedDateRangeCriteria,
                cache: false
           }).success(function (response) {
            }).error(function(error) {
                throw error;
            });

           var representativeAdvanceReports = $http({
               method: "GET",
               url: "./representativeAdvanceReport/getAll?statusFilter=" + $scope.selectedStatusCriteria + "&dateRangeFilter=" + $scope.selectedDateRangeCriteria,
               cache: false
           }).success(function (response) {
           }).error(function (error) {
               throw error;
           });

           $q.all([tripReports, representativeAdvanceReports]).then(function (responses) {
               if ($appConfig.showSuccessToastr)
                   toastr.success("Данные об отчётах получены!");
               $scope.data = [];
               angular.forEach(responses, function(v, k) {
                   angular.forEach(v.data, function(e, m) {
                       $scope.data.push(e);
                   });
               });

           });
        }

        $scope.createNew = function(type) {
            switch (type) {
                case "trip":
                    {
                        $state.transitionTo("newTripAdvanceReport", { id: undefined, prevState: $state.current.name });
                        break;
                    }
                case "representative":
                    {
                        $state.transitionTo("newRepresentativeAdvanceReport", { id: undefined, prevState: $state.current.name });
                        break;
                    }
                default:
                    toastr.error("Не реализовано");
            }
        }

        activate();

        function activate() {
            $scope.reload();
        }
    });