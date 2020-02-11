angular.module("valeant.app")
    .config(function($stateProvider, $urlRouterProvider) {

        // AngularUI router config
        $stateProvider
            //главная страница
            .state("home", {
                url: "/home",
                templateUrl: "app/templates/home.html",
                controller: "HomeController"
            })
            //заявки
            .state("tripRequests", {
                url: "/requests/tripRequests",
                templateUrl: "app/templates/requests/tripRequests.html",
                controller: "TripRequestsController"
            })
            .state("newTripRequest", {
                url: "/requests/tripRequests/newTripRequest?id&prevState",
                templateUrl: "app/templates/requests/newTripRequest.html",
                controller: "NewTripRequestController"
            })
            .state("giftRequests", {
                url: "/requests/giftRequests",
                templateUrl: "app/templates/requests/giftRequests.html",
                controller: "GiftRequestsController"
            })
            .state("newGiftRequest", {
                url: "/requests/giftRequests/newGiftRequest?id&prevState",
                templateUrl: "app/templates/requests/newGiftRequest.html",
                controller: "NewGiftRequestController"
            })
            .state("prepaymentRequests", {
                url: "/requests/prepaymentRequests",
                templateUrl: "app/templates/requests/prepaymentRequests.html",
                controller: "PrepaymentRequestsContoller"
            })
            .state("newPrepaymentRequest", {
                url: "/requests/newPrepaymentRequest?id&prevState",
                templateUrl: "app/templates/requests/newPrepaymentRequest.html",
                controller: "NewPrepaymentRequestController"
            })

            //отчёты
            .state("costsReports", {
                url: "/reports/costsReports",
                templateUrl: "app/templates/reports/costsReports.html",
                controller: "CostsReportsController"
            })
            .state("advanceTripReports", {
                url: "/reports/advanceTripReports",
                templateUrl: "app/templates/reports/advanceTripReports.html",
                controller: "AdvanceTripReportsController"
            })

            //авансовые отчёты
            .state("advanceReports", {
                url: "/advanceReports",
                templateUrl: "app/templates/advanceReports/advanceReports.html",
                controller: "AdvanceReportsController"
            })

            // транзакции
            .state("ledgerEntries", {
                url: "/ledgerEntries",
                templateUrl: "app/templates/ledgerEntries/ledgerEntries.html",
                controller: "LedgerEntriesController"
            })
            // выгрузка реестров
            .state("reester", {
                url: "/reester?reesterName",
                templateUrl: "app/templates/reester.html",
                controller: "ReesterController",
                auth: "стбух"
            })


            .state("newTripAdvanceReport", {
                url: "/advanceReports/newTripAdvanceReport?id&prevState",
                templateUrl: "app/templates/advanceReports/newTripAdvanceReport.html",
                controller: "AdvanceTripReportsController"
            })

            .state("newRepresentativeAdvanceReport", {
                url: "/advanceReports/newRepresentativeAdvanceReport?id&prevState",
                templateUrl: "app/templates/advanceReports/newRepresentativeAdvanceReport.html",
                controller: "AdvanceRepresentativeReportController"
             })

            //маршрутные листы
        

            .state("travelLists", {
                url: "/travelLists",
                templateUrl: "app/templates/travelLists.html",
                controller: "TravelListsController"
            })

            .state("newTravelList", {
                url: "/travelLists/newTravelList?id&prevState",
                templateUrl: "app/templates/newTravelList.html",
                controller: "NewTravelListController"
            })

            //согласование
            .state("approval", {
                url: "/approval",
                templateUrl: "app/templates/approval.html",
                controller: "ApprovalController"
            })
            .state("paymentStamps", {
                url: "/paymentStamps",
                templateUrl: "app/templates/paymentStampList.html",
                controller: "PaymentStampController"
            })

            .state("approvalTripRequest", {
                url: "/approval/tripRequest?id&prevState",
                templateUrl: "app/templates/requests/newTripRequest.html",
                controller: "NewTripRequestController"
            })

            .state("approvalPrepaymentRequest", {
                url: "/approval/prepaymentRequest?id&prevState",
                templateUrl: "app/templates/requests/newPrepaymentRequest.html",
                controller: "NewPrepaymentRequestController"
            })

            .state("approvalTravelList", {
                url: "/approval/travelList?id&prevState",
                templateUrl: "app/templates/newTravelList.html",
                controller: "NewTravelListController"
            })

            .state("approvalTripAdvanceReport", {
                url: "/approval/tripAdvanceReport?id&prevState",
                templateUrl: "app/templates/advanceReports/newTripAdvanceReport.html",
                controller: "AdvanceTripReportsController"
            })

            .state("approvalRepresentativeAdvanceReport", {
                url: "/approval/representativeAdvanceReport?id&prevState",
                templateUrl: "app/templates/advanceReports/newRepresentativeAdvanceReport.html",
                controller: "AdvanceRepresentativeReportController"
            })

            .state("approvalGiftRequest", {
                url: "/approval/giftRequest?id&prevState",
                templateUrl: "app/templates/requests/newGiftRequest.html",
                controller: "NewGiftRequestController"
            })

            // реестры
            .state("personRolesSettings", {
                url: "/settings/personRoles",
                templateUrl: "app/templates/settings/personRoles.html",
                controller: "PersonRolesController",
                auth: "стбух"
            })

            //настройки
            .state("countriesSettings", {
                url: "/settings/countries",
                templateUrl: "app/templates/settings/countries.html",
                controller: "CountriesController",
                auth: "тк"
            })
          
            .state("rolesSettings", {
                url: "/settings/roles",
                templateUrl: "app/templates/settings/roles.html",
                controller: "RolesController",
                auth: "стбух"
            })

             .state("citiesSettings", {
                 url: "/settings/cities",
                 templateUrl: "app/templates/settings/cities.html",
                 controller: "CitiesController",
                 auth: "тк"
             })

             .state("hotelsSettings", {
                 url: "/settings/hotels",
                 templateUrl: "app/templates/settings/hotels.html",
                 controller: "HotelsController",
                 auth: "тк"
             })

            .state("costItemsSettings", {
                url: "/settings/costItems",
                templateUrl: "app/templates/settings/costItems.html",
                controller: "CostItemsController",
                auth: "стбух"
            })

            .state("costCentersSettings", {
                url: "/settings/costCenters",
                templateUrl: "app/templates/settings/costCenters.html",
                controller: "CostCentersController",
                auth: "стбух"
            })

            .state("tripAimsSettings", {
                url: "/settings/tripAims",
                templateUrl: "app/templates/settings/tripAims.html",
                controller: "TripAimsController",
                auth: "тк"
            })

            .state("vehicleTypesSettings", {
                url: "/settings/vehicleTypes",
                templateUrl: "app/templates/settings/vehicleTypes.html",
                controller: "VehicleTypesController",
                auth: "стбух"
            })

            .state("dailyLimitsBaseSettings", {
                url: "/settings/dailyLimitsBase",
                templateUrl: "app/templates/settings/dailyLimitsBase.html",
                controller: "DailyLimitsBaseController",
                auth: "стбух"
            })

            .state("loadLedgerEntries", {
                  url: "/settings/loadLedgerEntries",
                  templateUrl: "app/templates/settings/loadLedgerEntries.html",
                  controller: "LoadLedgerEntriesController",
                  auth: "стбух"
            })

            .state("fuelCardsSettings", {
                url: "/settings/fuelCards",
                templateUrl: "app/templates/settings/fuelCards.html",
                controller: "FuelCardsController",
                auth: "ка"
            })
            
            .state("giftRecieversSettings", {
                url: "/settings/giftRecievers",
                templateUrl: "app/templates/settings/giftRecievers.html",
                controller: "GiftRecieversController",
                auth: "стбух"
            })

            .state("accountGroupsSettings", {
                url: "/settings/accountGroups",
                templateUrl: "app/templates/settings/accountGroups.html",
                controller: "AccountGroupsController",
                auth: "стбух"
            })
            .state("documentTypesSettings", {
                url: "/settings/documentTypes",
                templateUrl: "app/templates/settings/documentTypes.html",
                controller: "DocumentTypesController",
                auth: "стбух"
            })
             .state("carsSettings", {
                 url: "/settings/cars",
                 templateUrl: "app/templates/settings/cars.html",
                 controller: "CarsController",
                 auth: "ка"
             })
             .state("fuelConsumptionSettings", {
                 url: "/settings/fuel",
                 templateUrl: "app/templates/settings/fuelCosumption.html",
                 controller: "FuelConsumptionController",
                 auth: "ка"
             })
             .state("fuelCardsTransactionSettings", {
                 url: "/settings/fuelCardTransactions",
                 templateUrl: "app/templates/settings/loadFuelCardTransactions.html",
                 controller: "LoadFuelCardTransactionsController",
                 auth: "ка"
             })
            // выгрузка авансовых отчетов в Navision
            .state("exportAdvanceReport", {
                url: "/exportAdvanceReport",
                templateUrl: "app/templates/settings/exportAdvanceReport.html",
                controller: "ExportAdvanceReportController",
                auth: "стбух"
            })

            //профиль
            .state("profile", {
                url: "/profile",
                templateUrl: "app/templates/profile.html",
                controller: "ProfileController"
            })
            // Загрузка данных из 1С
            .state("loadFrom1C", {
                url: "/settings/loadFrom1C",
                templateUrl: "app/templates/settings/loadFrom1C.html",
                controller: "LoadFrom1CController",
                auth: "ка"
            });

        // if none of the above states are matched, use this as the fallback
        $urlRouterProvider.otherwise("/home");
    });