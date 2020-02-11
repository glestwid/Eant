angular.module("valeant.app")
    .config(function(toastrConfig) {

        angular.extend(toastrConfig,
            {
                autoDismiss: false,
                containerId: "toast-container",
                maxOpened: 0,
                newestOnTop: true,
                positionClass: "toast-bottom-left",
                preventDuplicates: false,
                preventOpenDuplicates: false,
                target: "body",
                timeOut: 5000
            });
    })
    .config([
        "$httpProvider", function($httpProvider) {
            //initialize get if not there
            if (!$httpProvider.defaults.headers.get) {
                $httpProvider.defaults.headers.get = {};
            }

            // Answer edited to include suggestions from comments
            // because previous version of code introduced browser-related errors

            //disable IE ajax request caching
            $httpProvider.defaults.headers.get["If-Modified-Since"] = "Mon, 26 Jul 1997 05:00:00 GMT";
            // extra
            $httpProvider.defaults.headers.get["Cache-Control"] = "no-cache";
            $httpProvider.defaults.headers.get["Pragma"] = "no-cache";
            $httpProvider.interceptors.push(function($q) {
                return {
                    'request': function(config) {
                        config.url = encodeURI(config.url);
                        return config || $q.when(config);
                    }
                }
            });
        }
    ])
    .config(function(dateRangePickerOptionsProvider) {
        var options = {
            clearLabel: "Очистить",
            autoUpdateInput: false,
            locale: {
                format: "DD.MM.YYYY",
                separator: " - ",
                applyLabel: "Применить",
                cancelLabel: "Отмена",
                fromLabel: "От",
                toLabel: "До",
                customRangeLabel: "Пользовательский",
                daysOfWeek: [
                    "Вс",
                    "Пн",
                    "Вт",
                    "Ср",
                    "Чт",
                    "Пт",
                    "Сб"
                ],
                monthNames: [
                    "Январь",
                    "Ферваль",
                    "Март",
                    "Апрель",
                    "Май",
                    "Июнь",
                    "Июль",
                    "Август",
                    "Сентябрь",
                    "Октябрь",
                    "Ноябрь",
                    "Декабрь"
                ],
                firstDay: 1
            }
        }


        dateRangePickerOptionsProvider.setDefaultOptions(options);
    })
    .config(function(cfpLoadingBarProvider) {
        cfpLoadingBarProvider.includeBar = false;
        cfpLoadingBarProvider.includeSpinner = false;
        cfpLoadingBarProvider.latencyThreshold = 1000;
    })
    .config([
        "uiMask.ConfigProvider", function(uiMaskConfigProvider) {
            uiMaskConfigProvider.clearOnBlur(false);
        }
    ])
    .constant("$appConfig",
        {
            showSuccessToastr: false,
            gridCellTemplate: '<div><div ng-click="grid.appScope.cellClicked(row,col)" style="cursor: pointer;" class="ui-grid-cell-contents">{{COL_FIELD CUSTOM_FILTERS}}</div></div>',
            gridHistoryCellTemplate: '<div><div class="ui-grid-cell-contents text-center"><a style="cursor: pointer;" class="val-text" ng-click="grid.appScope.showHistory(row.entity)">История</a></div></div>',
            getGridHeight: function () {
                var htmlHeight = document.getElementsByTagName("html")[0].clientHeight;
                var tableTop = document.getElementsByClassName("ui-grid")[0].getBoundingClientRect().top + document.body.scrollTop;
                var footerHeight = document.getElementsByClassName("site-footer")[0].clientHeight;
                return htmlHeight - tableTop - 10 - footerHeight + "px";
            },
            showHistoryFunction: function (uibModal, data) {
                uibModal.open({
                    templateUrl: "app/templates/requests/modals/prepaymentRequestHistory.html",
                    controller: "PrepaymentRequestHistoryController",
                    resolve: {
                        stateParams: function () {
                            return data;
                        }
                    }
                });
            }

});
