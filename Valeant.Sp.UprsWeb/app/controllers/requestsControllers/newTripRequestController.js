angular.module("valeant.controllers")

    .controller("NewTripRequestController", function ($scope, $state, $stateParams, $http, toastr, $q, $timeout, $uibModal, $appConfig) {

        // для удаления  todo: вынести отседова
        Array.prototype.remove = function (from, to) {
            var rest = this.slice((to || from) + 1 || this.length);
            this.length = from < 0 ? this.length + from : from;
            return this.push.apply(this, rest);
        };
       // $scope.maxFilesSize = 10000000;
       // $scope.currentFilesSize = 0;
        $scope.selectedFile = undefined;
        $scope.formData = {
            number: undefined,
            date: moment(new Date()).format(""),
            scanPdfsData: { rows: [], options: { tripNumber: undefined, comment: undefined, overLimit: false } },
            destinationsData: {
                rows: [],
                options: {
                    before: { ownExpense: false, days: undefined, ownExpenseOption: "До поездки"/*$scope.tripRequestData.ownExpenseOptions[0]*/ },
                    after: { ownExpense: false, days: undefined, ownExpenseOption: "После поездки" /*$scope.tripRequestData.ownExpenseOptions[1]*/ },
                    isWeekendDayTrip : false
                }
            },
            dailyCostsData: { rows: [], options: { entry: null, departure: null, sum: 0 } },
            ticketRequestsData: { rows: [], options: { isNeed: false } },
            hotelRequestsData: { rows: [], options: { isNeed: false } },
            trasferRequestsData: { rows: [], options: { isNeed: false } },
            requestMainData: {
                tripType: undefined,
                tripAim: undefined,
                vehicle: undefined,
                comment: undefined,
                person: undefined,
                orderData: {
                    orderNum: undefined,
                    date: undefined,
                    isApproved: false
                }
            }
        }

        $scope.tripRequestData = [];
        $scope.foreignDestination = false;
        $scope.accessList = {};
        $scope.persons = [];
        $scope.orderBlockVisible = false;
        $scope.travelBlockVisible = false;

        $scope.setBlocksVisibility = function () {
            var currentUser = JSON.parse(sessionStorage.getItem("currentUser"));

            if ($scope.formData.requestMainData.tripType != null) {
                $scope.orderBlockVisible = $scope.formData.requestMainData.tripType.Id === 2 && $scope.accessList.order !== 3/* && currentUser.IsHr*/;
            }

            if ($scope.accessList.travelCoordinator != null) {
                $scope.travelBlockVisible = $scope.accessList.travelCoordinator !== 3/* && currentUser.IsTravelCoordinator*/;
                if ($scope.travelBlockVisible === true) {
                    $scope.accessList.hotelRequestsData = 0;
                    $scope.accessList.trasferRequestsData = 0;
                    $scope.accessList.ticketRequestsData = 0;
                }
            }
        }

        $scope.validations = {
            "comment": [
                {
                    errorMessage: "Необходимо указать комментарий, если транспорт не требуется",
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                        if ($scope.formData.requestMainData.vehicle != undefined) {
                            var res = $scope.formData.requestMainData.vehicle.Name === "Транспорт не требуется";
                            if (res && val.length === 0) {
                                element.focus();
                                return false;
                            }
                        }
                        return true;
                    }
                }
            ],
            "tripType": [
                {
                    errorMessage: "Тип поездки не выбран",
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        var res = val.length > 0;
                        if(!res) {
                            element.focus();
                        }
                        return res;
                    }
                }
            ],
            "tripAim": [
                {
                    errorMessage: "Цель поездки не выбрана",
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                        var res = val.length > 0;
                        if (!res) {
                            element.focus();
                        }
                        return res;
                    }
                }
            ],
            "vehicle": [
                    {
                        errorMessage: "Вид транспорта не выбран",
                        validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                            var res = val.length > 0;
                            if (!res) {
                                element.focus();
                            }
                            return res;
                        }
                    }
            ],
            "orderField": [
                {
                    errorMessage: "Не заполнен 'Номер приказа'",
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        var res = val.length > 0;
                        if (!res) {
                            element.focus();
                        }
                        return res;
                    }
                }
            ],
            "inputField": [
                {
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        var res = val.length > 0;
                        if (!res) {
                            element.focus();
                        }
                        return res;
                    }
                }
            ],
            "country": [
                {
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        var res = val.length > 0;
                        if (!res) {
                            element.focus();
                        }
                        return res;
                    }
                }
            ],
            "city": [
                {
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        var res = val.length > 0;
                        if (!res) {
                            element.focus();
                        }
                        return res;
                    }
                }
            ],
            "endDate": [
                {
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        var endDate = moment(val, "DD.MM.YYYY").startOf("day");
                        var startDate = moment(model.date.startDate).startOf("day");
                        if (!startDate.isValid()) return true;
                        if (endDate.isSame(startDate)) return true;
                        return endDate.isAfter(startDate);
                    }
                }
            ],
            "startDate": [
                {
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        var startDate = moment(val, "DD.MM.YYYY").startOf("day");
                        var endDate = moment(model.date.endDate).startOf("day");
                        var today = moment().startOf("day");
                        //var possibleStartDate = today.add(2, "days");
                        //if (!startDate.isAfter(possibleStartDate)) {
                        //    return false;
                        //}
                        if (today.isAfter(startDate)) {
                            return false;
                        }
                        if (!endDate.isValid()) return true; // если не выбрана дата окончания
                        if (endDate.isSame(startDate)) return true;
                        return endDate.isAfter(startDate);
                    }
                }
            ],
            // Заказ билетов, гостиниц
            "transferDateInRange": [
                {
                    errorMessage: "Проверьте соответствие дат поездки и дат трансферов",
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        var td = moment(val, "DD.MM.YYYY").startOf("day");
                        var range = $scope.getDestinationDateRange(false);
                        if (range == undefined)
                            return true;

                        if (range["startDate"].isAfter(td) || td.isAfter(range["endDate"]))
                            return false;
                        return true;
                    }
                }
            ],
            "ticketDateInRange": [
                           {
                               errorMessage: "Проверьте соответствие дат поездки и дат в таблице заказа билетов",
                               validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                                   var td = moment(val, "DD.MM.YYYY").startOf("day");
                                   var range = $scope.getDestinationDateRange(false);
                                   if (range == undefined)
                                       return true;

                                   if (range["startDate"].isAfter(td) || td.isAfter(range["endDate"]))
                                       return false;
                                   return true;
                               }
                           }
            ],
            "hotelDateInRange": [
                            {
                                errorMessage: "Проверьте соответствие дат поездки и дат в таблице заказа гостиниц",
                                validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                                    var td = moment(val, "DD.MM.YYYY").startOf("day");
                                    var inputName = element.attr("name");
                                    if (inputName.indexOf("start") !== -1) {
                                        if (td.isAfter(moment(model.endDate)))
                                            return false;
                                    } 
                                    var range = $scope.getDestinationDateRange(false);
                                    if (range == undefined)
                                        return true;
                                    if (range["startDate"].isAfter(td) || td.isAfter(range["endDate"]))
                                        return false;
                                    return true;
                                }
                            }
            ],
            "foreignDateInRange": [
                {
                    errorMessage : "Не заполнены даты пересечения границы",
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        var td = moment(val, "DD.MM.YYYY").startOf("day");;
                        var range = $scope.getDestinationDateRange(true);
                        if (range == undefined)
                            return true;
                        if (!td.isValid()) return false;

                        if (range["startDate"].isAfter(td) || td.isAfter(range["endDate"])) {
                            return false;
                        }
                        return true;
                    }
                }
            ],
            //Заказ гостиниц
            "hotel": [
                {

                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        var res = val.length > 0;
                        if (!res) {
                            element.focus();
                        }
                        return res;
                    }
                }
            ],
            "destinationRows": [
                {
                    errorMessage: "Таблица пунктов назначений пуста",
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        if ($scope.formData.dailyCostsData.rows.length === 0)
                            return false;
                        else
                            return true;
                    }
                }
            ],
        };

        $scope.clearBlock = function(isNeed, blockDescr) {
            if (isNeed) {
                $timeout(function() {
                    if (blockDescr === "hotel") {
                        $scope.formData.hotelRequestsData.rows = [];
                    }
                    if (blockDescr === "transfer") {
                        $scope.formData.trasferRequestsData.rows = [];
                    }
                });
            }
        }

        $scope.checkBlockVisibility = function(blockName) {
            var condition = true;
            if (blockName === "tickets") {
                condition = $scope.formData.requestMainData.vehicle != undefined &&
                ($scope.formData.requestMainData.vehicle.Name === "Авиа" || $scope.formData.requestMainData.vehicle.Name === "ЖД");
                if (!condition)
                    $scope.formData.ticketRequestsData.rows = [];
                return condition;
            }
            if (blockName === "transfer") {
                if ($scope.formData.requestMainData.vehicle)
                    condition =  $scope.formData.requestMainData.vehicle.Name !== "Служебный автомобиль";
                if (!condition)
                    $scope.formData.trasferRequestsData.rows = [];
                return condition;
            }
        }

        // Расчет суммы суточных
        $scope.totalDailyCosts = function () {
            var total = 0;
            if ($scope.formData != undefined)
                if ($scope.formData.dailyCostsData != undefined) {
                    for (var i = 0; i < $scope.formData.dailyCostsData.rows.length; i++) {
                        total += $scope.formData.dailyCostsData.rows[i].cost;
                    }
                }

            $scope.formData.dailyCostsData.options.sum = total;
            return total;
        }

        // фильтр городов по стране
        $scope.countryToCityFilter = function(row) {
            var temp = [];
            //if (row.country == undefined) return $scope.tripRequestData.cities;
            //angular.forEach($scope.tripRequestData.cities, function (v, k) {
            //    if (v.CountryId === row.country.Id) {
            //        temp.push(v);
            //    }
            //});
            //return temp;
            if (row.country.Name === "Россия")
                return $scope.tripRequestData.cities;
            else return [];
        }

        // Командировка в выходной день
        $scope.isWeekendDayTrip = function () {
            var isWeekendDayTrip = false;
            for (var i = 0; i < $scope.formData.dailyCostsData.rows.length; i++) {
                var dateStart = moment($scope.formData.dailyCostsData.rows[i].date);
                if (dateStart.isoWeekday() === 6 || dateStart.isoWeekday() === 7) {
                    isWeekendDayTrip = true;
                    break;
                }
            }
            $scope.formData.destinationsData.options.isWeekendDayTrip = isWeekendDayTrip;
            return isWeekendDayTrip ? "Да" : "Нет";
        }
        // проверка типа транспорта для отрисовки таблицы с билетами
        $scope.checkVehicleType = function() {
            if($scope.formData.requestMainData.vehicle != undefined) {
                if ($scope.formData.requestMainData.vehicle.Id === 1)
                    return true;
            }
            return false;
        }

        activate();

        function activate() {
            $scope.prevState = $stateParams.prevState;
            $scope.formData.scanPdfsData.options.tripNumber = $stateParams.id;
            $scope.requestid = $stateParams.id;

            var referencesRequest = $http({
                method: "POST",
                url: "./references/getAll",
                data: JSON.stringify(["person", "country", "vehicle", "tripAim", "ownExpenseOption", "city", "hotel", "tripType", "costItem", "Expenditure", "dailyLimitBase", "dailyLimit"])
            }).success(function (response) {
                $scope.tripRequestData = response;

            }).error(function (error) {
                toastr.error("Ошибка!");
                throw error;
            });

            var personsRequest = $http({
                method: "GET",
                url: "./security/getHumans",
                cache: false
            }).success(function (response) {
                $scope.persons = response;
            }).error(function (error) {
                throw error;
            });

            $q.all([referencesRequest, personsRequest])
                .then(function(responses) {
                    if ($stateParams.id == undefined)
                        $stateParams.id = -1;
                    console.log($stateParams.id);
                    $http({
                            method: "GET",
                            url: "./tripRequests/get?id=" + $stateParams.id,
                            cache: false
                        })
                        .success(function (response) {
                            if (response === "") {
                                var modalInstance = $uibModal.open({
                                    templateUrl: "app/templates/modals/notifyModal.html",
                                    controller: "NotifyModalController",
                                    resolve: {
                                        title: function () {
                                            return "Ошибка";
                                        },
                                        message: function () {
                                            return "Заявка недоступна";
                                        }
                                    }
                                });

                                modalInstance.result.then(function () {
                                    $state.transitionTo("home");
                                }, function () {
                                    console.log("Modal dismissed at: " + new Date());
                                });

                                return;
                            }

                            $scope.formData = response;
                            if ($stateParams.id === -1)
                                $scope.formData.requestMainData.person = JSON.parse(sessionStorage.getItem("currentUser"));
                            $scope.savedDailyCosts = $scope.formData.dailyCostsData.rows;
                            $scope.accessList = $scope.formData.accessList;
                            $scope.setBlocksVisibility();
                            if ($appConfig.showSuccessToastr)
                                toastr.success("Данные о заявке получены!");

                            setTimeout(function() {
                                    $scope.$broadcast("runCustomValidations");
                                },
                                1000);
                        })
                        .error(function(error) {
                            throw error;
                        });
                });
        }

        // Return a random number between 1 and 100
        $scope.generateScanKey = function() {
            var rnd = Math.floor((Math.random() * 100) + 1);
            angular.forEach($scope.formData.scanPdfsData.rows, function (v, k) {
                if(v.key === rnd ) {
                    rnd = Math.floor((Math.random() * 100) + 1);
                }
            });
            return rnd;
        }

        // Сканы
        $scope.addScanPdf = function () {
            if ($scope.selectedFile != undefined) {
                var reader = new FileReader();
                // If we use onloadend, we need to check the readyState.
                reader.onloadend = function (evt) {
                    if (evt.target.readyState === FileReader.DONE) { // DONE == 2
                        var rndKey = $scope.generateScanKey();
                        var scan = { name: $scope.selectedFile.name, index: $scope.formData.scanPdfsData.rows.length + 1, data: $scope._arrayBufferToBase64(evt.target.result), key: rndKey }
                        $scope.$apply(function() {
                            $scope.formData.scanPdfsData.rows.push(scan);
                            $scope.selectedFile = undefined;
                        });
                    }
                };

                var blob = $scope.selectedFile.slice(0, $scope.selectedFile.size - 1);
                reader.readAsArrayBuffer(blob);
            }
        }
        $scope.removeScanPdf = function () {
            $scope.formData.scanPdfsData.rows.remove(this.$index);
        }

        // преобразование в base64string
        $scope._arrayBufferToBase64 = function( buffer ) {
            var binary = "";
            var bytes = new Uint8Array( buffer );
            var len = bytes.byteLength;
            for (var i = 0; i < len; i++) {
                binary += String.fromCharCode( bytes[ i ] );
            }
            return window.btoa( binary );
        }

        // Пункты назначения
        $scope.addDestination = function () {
            if ($scope.formData.requestMainData.tripType == undefined) {
                toastr.warning("Сначала укажите 'Тип поездки'");
                return false;
            }

            var destinationObj = {
                index: $scope.formData.destinationsData.rows.length + 1,
                country: undefined,
                city: undefined, organization: undefined,
                date: { startDate: null, endDate: null }
                
            }
            if ($scope.formData.destinationsData.rows.length === 0) {
                destinationObj.date.startDate = moment(new Date()).startOf("day");
                //В первую созданную строку проставлять по умолчанию Росию
                var ownCountryObjects = this.filteredCountries.filter(function (c) { return c.Name === $scope.formData.requestMainData.person.Country });
                if (ownCountryObjects.length === 1)
                    destinationObj.country = ownCountryObjects[0];
            }
            if ($scope.formData.destinationsData.rows.length >= 1) {
                var lastRow = $scope.formData.destinationsData.rows[$scope.formData.destinationsData.rows.length - 1];
                if(lastRow.date.endDate === null ) {
                    $scope.$broadcast("runCustomValidations");
                    return;
                }
                destinationObj.date.startDate = moment(lastRow.date.endDate).add(1, "days").format();  // дата следующей поездки начинается на следующий день после конца предыдущей
                destinationObj.country = $scope.formData.destinationsData.rows[0].country; // о вторую и последующие строки проставлять по умолчанию значения из первой строки
            }
            $scope.formData.destinationsData.rows.push(destinationObj);
        }
        $scope.removeDestination = function () {
            $scope.formData.destinationsData.rows.remove(this.$index);
        }

        // обновляет значения чекбоксов в подтянутых сохраненных суточных
        $scope.updateSavedDataIfExist = function(row) {
            if($scope.savedDailyCosts.length > 0) {
                for (var i = 0; i < $scope.savedDailyCosts.length; i++) {
                    if (moment($scope.savedDailyCosts[i].date).diff(moment(row.date), "days") === 0) {
                        $scope.savedDailyCosts[i].dinner = row.dinner;
                        $scope.savedDailyCosts[i].supper = row.supper;
                    }
                }
            }
        }

        // период поездок
        $scope.getDestinationDateRange = function (isForeignDate) {
            if ($scope.formData.dailyCostsData.rows.length === 0)
                return null;
            var minDate = moment($scope.formData.dailyCostsData.rows[0].date);
            var maxDate = moment($scope.formData.dailyCostsData.rows[$scope.formData.dailyCostsData.rows.length - 1].date);
            var daysBefore = undefined,
                daysAfter = undefined;
            if (!isForeignDate) {
                if ($scope.formData.destinationsData.options.before.ownExpense === true ||
                    $scope.formData.destinationsData.options.after.ownExpense === true) {
                    // check before or after
                    daysBefore = $scope.formData.destinationsData.options.before.days;
                    daysAfter = $scope.formData.destinationsData.options.after.days;
                    if ($scope.formData.destinationsData.options.before.ownExpense === true) {
                        minDate = minDate.subtract(daysBefore, "days");
                    }
                    if ($scope.formData.destinationsData.options.after.ownExpense === true) {
                        maxDate = maxDate.add(daysAfter, "days");
                    }
                }
            } else {
                if ($scope.formData.destinationsData.options.before.ownExpense === true ||
                   $scope.formData.destinationsData.options.after.ownExpense === true) {
                    // check before or after
                    daysBefore = $scope.formData.destinationsData.options.before.days;
                    daysAfter = $scope.formData.destinationsData.options.after.days;
                    if ($scope.formData.destinationsData.options.before.ownExpense === true) {
                        minDate = minDate.subtract(daysBefore, "days");
                    }
                    if ($scope.formData.destinationsData.options.after.ownExpense === true) {
                        maxDate = maxDate.add(daysAfter, "days");
                    }
                }
            }
            return { startDate: minDate, endDate: maxDate };
        }

        $scope.getLimit = function (row) {
            if (row.country == undefined)
                return 0;

            if (!row.country.IsForeign) {
                var costLocal = $scope.getCost("Россия");
                row.baseCost = costLocal[0];
            } else {
                var depDate = moment($scope.formData.dailyCostsData.options.departure);//$scope.formData.dailyCostsData.rows[0].date;
                var entryDate = moment($scope.formData.dailyCostsData.options.entry);//$scope.formData.dailyCostsData.rows[$scope.formData.dailyCostsData.rows.length - 1].date;
                if (row.country.IsCis) {
                    var costCis = $scope.getCost("СНГ");
                    row.baseCost = costCis[0];
                }
                else {
                    var costForeign = $scope.getCost("Прочие");
                    row.baseCost = costForeign[0];
                }
                if (row.date.isSame($scope.formData.dailyCostsData.rows[$scope.formData.dailyCostsData.rows.length - 1].date)) { // последний день командировки (последнияя запись в таблице суточных)
                    row.baseCost = $scope.getCost($scope.getOwnCountryCost())[0];
                }
                if (depDate.isAfter(row.date) || row.date.isAfter(entryDate) || row.date.isSame(entryDate)) {
                    var costExcept = $scope.getCost($scope.getOwnCountryCost());
                    row.baseCost = costExcept[0];
                }
            }
            return row.baseCost;
        }

        $scope.getOwnCountryCost = function() {
           var countries = $scope.tripRequestData.countries.filter(function(c) {return c.Name === $scope.formData.requestMainData.person.Country }); // своя страна
                    var ownCountryName = "Россия";
                    if (countries.length > 0)
                        ownCountryName = countries[0].Name;
            return ownCountryName;
        }

        $scope.getCost = function (condition) {
            var cost = $scope.tripRequestData.dailyLimitsBase.filter(function (x) {
                return x.RateName === condition; // *своя страна*
            }).map(function (x) {
                return x.Limit;
            });
            return cost;
        }

        $scope.getDailyCost = function (row) {
            if($scope.formData.dailyCostsData.rows.length === 1) {
                return row.cost = 0;
            }
            var numSelected = 0;
            if (row.dinner)
                numSelected++;
            if (row.supper)
                numSelected++;

            var cost = $scope.tripRequestData.dailyLimits.filter(function(x) {
                return x.NumSelected === numSelected;
            })[0];

            if (cost.IsMultiplier) {
                row.cost = row.baseCost * cost.Number;
            } else {
                row.cost = cost.Number;
            }
            return row.cost;
        }

        $scope.filteredCountries = [];

        $scope.$watch("formData.requestMainData.tripType", function (newValue, oldValue) {
            if ($scope.tripRequestData.countries == undefined)
                return [];

            $scope.filteredCountries = $scope.tripRequestData.countries.filter(function (x) {
                if (newValue == undefined)
                    return true;

                if (newValue.Name === "Служебная поездка" && x.Name !== $scope.formData.requestMainData.person.Country) {
                    return false;
                } else
                    return true;
            });
        }, true);
   
        // триггер для заполнения суточных, проверки пересечения границы
        $scope.$watch("formData.destinationsData.rows", function (rows, oldRows) {
            if (rows.length === 0) {
                // если удалили все строчки, то начинаем инициализировать все коллекции заново.
                $scope.formData.dailyCostsData.rows = [];
                $scope.savedDailyCosts = undefined;
                return;
            } else if (rows.length >= oldRows.length) {
                $scope.savedDailyCosts = $scope.formData.dailyCostsData.rows; // сохраняем уже выбранные
            }
            //дефолт
            $scope.foreignDestination = false;

            $timeout(function () {
                $scope.formData.dailyCostsData.rows = [];
                var tempArray = [];
                //проверяем обе даты заполнены и наличие зарубежных стран
                for (var i = 0; i < rows.length; i++) {
                    if (rows[i].country != undefined) {
                        $scope.foreignDestination = rows[i].country.IsForeign;
                    }
                    // вычислить количество дней между датами
                    if (rows[i].date.startDate === "" || rows[i].date.endDate === "") continue;
                    var startDate = moment(rows[i].date.startDate);
                    var endDate = moment(rows[i].date.endDate);
                    var days = endDate.diff(startDate, "days") + 1;
                    // Суточные на однодневную поездку не должны считаться и отображаться при согласовании
                    if (days === 1)
                        continue;
                    for (var j = 0; j < days; j++) {
                        var dailyCost = {
                            index: $scope.formData.dailyCostsData.rows.length + 1,
                            date: moment(rows[i].date.startDate).add(j, "days"),
                            city: rows[i].city,
                            dinner: false,
                            supper: false,
                            baseCost: 0,
                            cost: 0,
                            country: rows[i].country
                        }
                        if ($scope.savedDailyCosts != undefined) {
                            // Если добавились dailyCosts или
                            var savedRows = $scope.savedDailyCosts;
                            for (var k = 0; k < savedRows.length; k++) {
                                if (moment(savedRows[k].date).diff(dailyCost.date, "days") === 0) {
                                    dailyCost.dinner = savedRows[k].dinner;
                                    dailyCost.supper = savedRows[k].supper;
                                }
                            }
                        }
                        tempArray.push(dailyCost);
                        //$scope.formData.dailyCostsData.rows.push(dailyCost);
                        // обновляем даты пересечения границы, если командировка
                        if ($scope.formData.requestMainData.tripType.Name === "Командировка") {
                            $scope.formData.dailyCostsData.options.departure = $scope.formData.destinationsData.rows[0].date.startDate;
                            $scope.formData.dailyCostsData.options.entry = $scope.formData.destinationsData.rows[$scope.formData.destinationsData.rows.length - 1].date.endDate;
                        }
                        // обновляем даты в отелях и трансферах
                        $scope.updateHotelDates();
                        $scope.updateTransferRequests();
                    }
                }
                $scope.formData.dailyCostsData.rows = tempArray;
            }, 250);
            
        }, true);

        //$scope.entryDateChanged = function() {
        //   if ($scope.formData.ticketRequestsData.rows.length === 2) {
        //       if ($scope.formData.dailyCostsData.options.entry)
        //           $scope.formData.ticketRequestsData.rows[1].date = $scope.formData.dailyCostsData.options.entry;
        //   }
        //}

        // Заказ билетов
        $scope.addTicketRequest = function () {
            if ($scope.formData.destinationsData.rows.length === 0) {
                toastr.warning("Сначала укажите 'Пункты назначения'");
                return false;
            }
            var ticketRequest = {
                index: $scope.formData.ticketRequestsData.rows.length + 1,
                date: $scope.formData.destinationsData.rows[0].date.startDate,
                from: undefined,
                to: $scope.formData.destinationsData.rows[0].city,
                ticketDescription: undefined,
                comment: undefined
            }
            if ($scope.formData.ticketRequestsData.rows.length === 1) {
                ticketRequest.from = $scope.formData.ticketRequestsData.rows[0].to;
                ticketRequest.to = $scope.formData.ticketRequestsData.rows[0].from;
                // устанавливаем дату конца с учтов дат пересечения границы
                ticketRequest.date = $scope.formData.destinationsData.rows[$scope.formData.destinationsData.rows.length - 1].date.endDate;
                if ($scope.formData.destinationsData.options.after.ownExpense === true) {
                    var daysAfter = $scope.formData.destinationsData.options.after.days;
                    var maxDate = moment($scope.formData.dailyCostsData.rows[$scope.formData.dailyCostsData.rows.length - 1].date);
                    maxDate = maxDate.add(daysAfter, "days");
                    ticketRequest.date = maxDate.format("DD.YYYY.MMMM");
                }
            }
            if ($scope.formData.ticketRequestsData.rows.length >= 2) {
                ticketRequest.from = undefined;
                ticketRequest.to = undefined;
                ticketRequest.date = undefined;
            }
            $scope.formData.ticketRequestsData.rows.push(ticketRequest);
        }

        $scope.removeTicketRequest = function () {
            $scope.formData.ticketRequestsData.rows.remove(this.$index);
        }

        $scope.resetHotel = function(hr) {
            hr.hotel = undefined;
        }

        // Заказ гостиниц
        $scope.addHotelRequest = function() {
            if ($scope.formData.destinationsData.rows.length === 0) {
                toastr.warning("Сначала укажите 'Пункты назначения'");
                return false;
            }
            $timeout(function() {
                var hotelRequest = {
                    index: $scope.formData.hotelRequestsData.rows.length + 1,
                    country: $scope.formData.destinationsData.rows[0].country,
                    city: $scope.formData.destinationsData.rows[0].city,
                    hotel: "",
                    startDate: $scope.formData.destinationsData.rows[0].date.startDate,
                    endDate: $scope.formData.destinationsData.rows[$scope.formData.destinationsData.rows.length - 1].date.endDate
                }
                $scope.formData.hotelRequestsData.rows.push(hotelRequest);
            }, 500);
        }

        $scope.removeHotelRequest = function () {
            $scope.formData.hotelRequestsData.rows.remove(this.$index);
        }

        $scope.updateHotelDates = function() {
            for (var i = 0; i < $scope.formData.hotelRequestsData.rows.length; i++) {
                $scope.formData.hotelRequestsData.rows[i].startDate = $scope.formData.destinationsData.rows[0].date.startDate;
                $scope.formData.hotelRequestsData.rows[i].endDate = $scope.formData.destinationsData.rows[$scope.formData.destinationsData.rows.length - 1].date.endDate;
            }
        }

        // фильтр отеля по городу
        $scope.cityToHotelFilter = function (row) {
            var temp = [];
            var city = undefined;
            angular.forEach($scope.tripRequestData.cities, function (v, k) {
                if(v.Name === row.city) {
                    city = v;
                    return false;
                }
            });
            if (city == undefined) return [];
            angular.forEach($scope.tripRequestData.hotels, function (v, k) {
               if(city.Id === v.CityId) {
                   temp.push(v);
               }

            });
            return temp;
        }

        // Заказ трансферов
        $scope.addTransferRequest = function () {
            if ($scope.formData.destinationsData.rows.length === 0) {
                toastr.warning("Сначала укажите 'Пункты назначения'");
                return false;
            }

            var trasferRequest = {
                index: $scope.formData.trasferRequestsData.rows.length + 1,
                date: $scope.formData.destinationsData.rows[0].date.startDate,//moment().startOf("day").format(),
                from: undefined,
                to: undefined 
            }

            if ($scope.formData.trasferRequestsData.rows.length === 1) {
                trasferRequest.date = $scope.formData.destinationsData.rows[$scope.formData.destinationsData.rows.length - 1].date.endDate;
            }
            $scope.formData.trasferRequestsData.rows.push(trasferRequest);
        }
        $scope.removeTransferRequest = function () {
            $scope.formData.trasferRequestsData.rows.remove(this.$index);
        }

        $scope.updateTransferRequests = function() {
            if($scope.formData.trasferRequestsData.rows.length > 0) {
                $scope.formData.trasferRequestsData.rows[1].date = $scope.formData.destinationsData.rows[$scope.formData.destinationsData.rows.length - 1].date.endDate;
            }
        }

        $scope.sendToApproval = function () {
            $http({
                method: "POST",
                url: "./tripRequests/save",
                data: JSON.stringify($scope.formData)
            }).success(function (response) {
                $scope.goBack();
            }).error(function (error) {
                throw error;
            });
            console.log(this);
        }


        $scope.errors = [];
        $scope.$on("customValidationComplete", function (e, data) {
            if(data.validation != undefined)
                $scope.errors.push(data);
        });

        // SAVE
        $scope.save = function (status) {
            status = status.replace(/^\s\s*/, "");
            $scope.errors = [];
            $scope.$broadcast("runCustomValidations");

            if (status === "Печать") {
                console.log("Печать...");
                if ($appConfig.showSuccessToastr)
                    toastr.success("Формирование отчёта...!");
                window.open("./printing/getForm?id=" + $stateParams.id + "&format=PDF");
                return false;
            }

            $scope.approveIsNeeded(status).then(function(result) {
                if (result) {
                    var destDataEmptyMsg = "";
                    if ($scope.formData.destinationsData.rows.length === 0)
                        destDataEmptyMsg = "<br/>" + "Таблица пунктов назначений пуста";

                    if (!$scope.form1.$valid ||
                        !$scope.formOrder.$valid ||
                        !$scope.formDest.$valid ||
                        !$scope.ticketForm.$valid ||
                        !$scope.hotelForm.$valid ||
                        !$scope.transferForm.$valid ||
                        (!$scope.foreignDatesForm.$valid && $scope.formData.requestMainData.tripType.Name === "Командировка") ||
                        destDataEmptyMsg !== "") {
                            $uibModal.open({
                                templateUrl: "app/templates/modals/notifyModal.html",
                                controller: "NotifyModalController",
                                resolve: {
                                    title: function () {
                                        return undefined;
                                    },
                                    message: function () {
                                        var res = $scope.errors.map(function (x) { return x.validation; }).join("<br/>");
                                        if (res === "") res = "Ошибки при валидации формы";
                                        res += destDataEmptyMsg;
                                        return res;
                                    }
                                }
                            });
                        return false;
                    }
                    $scope.showModalIfNeed(status).then(function (result) {
                        console.log(result);
                        if (result === true) {
                            $scope.saveAjaxCall(status);
                        }
                    });
                }
            });

            return false;
        }

        $scope.approveIsNeeded = function (status) {
            if (status !== "Отозвать" && status !== "Аннулировать") {
                return $q.resolve(true);
            }

            return $uibModal.open({
                templateUrl: "app/templates/modals/approveAction.html",
                controller: "ApproveActionModalController",
                resolve: {
                    title: function () {
                        return status;
                    }
                }
            }).result.then(function(result) {
                return result;
            });
        }

        $scope.showModalIfNeed = function (status) {
            if (status !== "Отказать" && status !== "На доработку") {
                return $q.resolve(true);
            }

            return $uibModal.open({
                templateUrl: "app/templates/requests/modals/denyReasonModal.html",
                controller: "DenyReasonModalController"
            }).result.then(function (reasonText) {
                $scope.formData.denyReason = reasonText;
                return true;
            }, function () {
                return false;
            });
        }

        $scope.saveAjaxCall = function (status) {
            $http({
                method: "POST",
                url: "./tripRequests/save",
                data: JSON.stringify({ action: status, data: $scope.formData, denyReason: $scope.formData.denyReason })
            }).success(function (response) {
                if (status === "Отозвать") {
                    window.location.reload();
                    return;
                }
                $scope.goBack();
            }).error(function (error) {
                $uibModal.open({
                    templateUrl: "app/templates/modals/notifyModal.html",
                    controller: "NotifyModalController",
                    resolve: {
                        title: function () {
                            return undefined;
                        },
                        message: function () {
                            return "Невозможно сохранить заявку";
                        }
                    }
                });

                toastr.error("Ошибка!");
                throw error;
            });
        }


        $scope.createNewTravelNumber = function () {
            $scope.formData.scanPdfsData.options.tripNumber = $stateParams.id;
            $scope.requestid = $stateParams.id;
            $http({
                method: "GET",
                url: "./tripRequests/getNextTripRequestTkNumber"
            }).success(function (response) {
                $scope.formData.scanPdfsData.options.tripNumber = response;
            }).error(function (error) {
                throw error;
            });

        }

        $scope.showHistory = function () {
            $uibModal.open({
                templateUrl: "app/templates/requests/modals/prepaymentRequestHistory.html",
                controller: "PrepaymentRequestHistoryController",
                resolve: {
                    stateParams: function () {
                        return { Type: "Заявка на командировку/служебную поездку", Id: $stateParams.id };
                    }
                }
            });
        }

        $scope.goBack = function () {
            if ($scope.prevState != null)
                $state.transitionTo($scope.prevState);
            else
                $state.transitionTo("tripRequests");
        }

        $scope.printReport = function (d) {
            window.open("./TripRequests/export?id=" + d.requestId + "&rand=" + Math.random());
            return false;
        }

    });