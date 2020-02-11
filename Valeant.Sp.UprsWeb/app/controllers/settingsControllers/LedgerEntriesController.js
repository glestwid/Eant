angular.module("valeant.controllers")

    .controller("LedgerEntriesController", function ($scope, $http, toastr, $appConfig) {
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
                { name: "Дата", field: "FormatedDate" },
                { name: "Тип документа", field: "DocumentType" },
                { name: "Документ", field: "DocumentNumber" },
                { name: "Уч. группа", field: "PostingGroup" },
                { name: "Цель платежа", field: "PaymentPurpose" },
                { name: "Сумма", field: "Ammount" },
                { name: "Сумма остатка", field: "AmmountSum" },
                { name: "Описание", field: "Description" }
            ],
            appScopeProvider: {
                getGridHeight: $appConfig.getGridHeight
            }
        };


        $scope.reload = function () {
            $http({
                method: "GET",
                url: "./ledgerEntries/getAll?entryType=0",
                cache: false
            }).success(function (response) {
                $scope.data = response;
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные получены!");
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


