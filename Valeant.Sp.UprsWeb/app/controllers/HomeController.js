angular.module("valeant.controllers")

    .controller("HomeController", function ($scope, $http, toastr, $state, $appConfig) {
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
                { name: "№ заявки", field: "number", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Дата заявки", field: "creationDate", cellTemplate: $appConfig.gridCellTemplate, cellFilter: "date: 'dd.MM.yyyy'" },
                { name: "Тип заявки", field: "documentType", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Город", field: "city", cellTemplate: $appConfig.gridCellTemplate },
                { name: "Дата начала", field: "tripStartDate", cellTemplate: $appConfig.gridCellTemplate, cellFilter: "date: 'dd.MM.yyyy'" },
                { name: "Статус", field: "documentState", cellTemplate: $appConfig.gridCellTemplate }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight,
                cellClicked: function (row, col) {
                    var data = row.entity;
                    setTimeout(function () {
                        $state.transitionTo("newTripRequest", { id: data.id, prevState: $state.current.name });
                    }, 300);
                }
            }
        };

        $scope.employeeLedgerEntries = [];
        $scope.transactionsSum = 0;
        $scope.accountGroups =[];

        $scope.issues = [];
        $scope.reportTypes = [
             { type: "tripAdvanceReport", title: "Авансовый отчёт по командировке/служебной поездке" },
             { type: "representativeAdvanceReport", title: "Авансовый отчёт по представительским и текущим расходам" }
        ];

        $scope.calcTransactionsSum = function () {
          
            var i= 0;
            angular.forEach($scope.accountGroups, function (v, k) {
                $scope.issues[i] = { "title": undefined, "sum": 0 };
                $scope.issues[i].title = v.AccountGroupName;
                $scope.issues[i].sum = 0;

                i++;
            });
            var sum = 0;

            angular.forEach($scope.employeeLedgerEntries, function (v, k) {
                sum += v.Ammount;
                              
                angular.forEach($scope.issues, function (s, n) {
                    
                    if (s.title == v.PostingGroup) {
                        s.sum += v.Ammount;
                        s.sum = Math.round(s.sum * 100) / 100;
                    }
                });
               
                $scope.transactionsSum = isNaN(sum) ? 0 : sum.toFixed(2);
                
            });
        }

        $scope.createNew = function (type) {
            switch (type) {
                case "tripAdvanceReport":
                    {
                        $state.transitionTo("newTripAdvanceReport", { id: undefined, prevState: $state.current.name });
                        break;
                    }
                case "representativeAdvanceReport":
                    {
                        $state.transitionTo("newRepresentativeAdvanceReport", { id: undefined, prevState: $state.current.name });
                        break;
                    }
                case "prepaymentRequest":
                    {
                        $state.transitionTo("newPrepaymentRequest", { id: undefined, prevState: $state.current.name });
                        break;
                    }
                case "tripRequest":
                    {
                        $state.transitionTo("newTripRequest", { id: undefined, prevState: $state.current.name });
                        break;
                    }
                default:
                    toastr.error("Не реализовано");
            }
        }


        $scope.reload = function () {
            $http({
                method: "GET",
                url: "./tripRequests/getUnclosed",
                cache: false
            }).success(function (response) {
                $scope.data = response;
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные о заявках получены!");
            }).error(function (error) {
                throw error;
            });

            $http({
                method: "GET",
                url: "./ledgerEntries/getAll?entryType=0",
                cache: false
            }).success(function (response) {
                $scope.employeeLedgerEntries = response;
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные о транзакциях получены!");
                $http({
                    method: "GET",
                    url: "./accountGroups/getAll",
                    cache: false
                }).success(function (response) {
                    $scope.accountGroups = response;
                    $scope.calcTransactionsSum();
                    if ($appConfig.showSuccessToastr)
                        toastr.success("Данные о учетных группах получены!");
                }).error(function (error) {
                    throw error;
                });

               
            }).error(function (error) {
                throw error;
            });

           

        }

        activate();

        function activate() {
            $scope.reload();
        }
    });