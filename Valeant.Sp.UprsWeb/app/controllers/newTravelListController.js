angular.module("valeant.controllers")
    .controller("NewTravelListController", function ($scope, $http, $q, $state, $stateParams, toastr, $uibModal, $appConfig) {
        $scope.formData = {
            requestId: undefined,
            number: undefined,
            status: undefined,
            date: { startDate: moment(new Date()).startOf("day").format(), endDate: moment(new Date()).startOf("day").format() },
            denyReason: undefined,

           // startDate: undefined,
           // endDate: undefined,

            carData: undefined,
            fuelType: { CarType: "", FuelGrade:"", ConsumptionSummer : 0.00, ConsumptionWinter: 0.00},
            fuelExpense: undefined,
            limit : 0.00,


            odometerStart: undefined,
            odometerEnd: undefined,
            fuelStart: 0.00,
            fuelEnd: 0.00,
            refueledByCard: 0.00,
            refueledByCardSum: 0.00,
            refueledNotByCard: 0.00,
            refueledNotByCardSum: 0.00,
            spentSum: 0.00
        }

        $scope.travelListData = undefined;
        $scope.currentFuleConsumption = undefined;
        $scope.docPath = ["Ваш руководитель","Вышестоящий руководитель при превышении лимита расхода на топливо"];


        $scope.validations = {
            "carData": [
                   {
                       errorMessage: "Не выбран автомобиль",
                       validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                                                   
                           var res = (val.length>0);

                           if (!res) {
                               element.focus();
                           }
                           return res;
                       }
                   }
            ],
            "refueledNotByCard": [
                    {
                        errorMessage: "Недопустимое значение поля Заправлено не по ТК",
                        validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                                                       
                            var res = !isNaN($scope.parseNumber(val));
                                                      
                            if (!res) {
                                element.focus();
                            }
                            return res;
                        }
                    }
            ],
            "refueledNotByCardSum": [
                {
                    errorMessage: "Недопустимое значение поля Заправлено не по ТК руб.",
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {

                        var res = !isNaN($scope.parseNumber(val));

                        if (!res) {
                            element.focus();
                        }
                        return res;
                    }
                }
            ],
            "odometerStart": [
                {
                    errorMessage: "Недопустимое значение поля Показания одометра Начало периода",
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {

                        var res = !isNaN($scope.parseNumber(val));

                        if (!res) {
                            element.focus();
                        }
                        return res;
                       
                    }
                }
            ],
            "odometerEnd": [
                {
                    errorMessage: "Недопустимое значение поля Показания одометра Конец периода",
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                       
                        var res = !isNaN($scope.parseNumber(val));
                        console.log(res);


                        if (!res) {
                            element.focus();
                        }
                        return res;
                        
                    }
                }
            ],
            "fuelStart": [
                {
                    errorMessage: "Недопустимое значение поля Топливо в баке Начало периода",
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                        
                        var res = !isNaN($scope.parseNumber(val));
                      
                        if (!res) {
                            element.focus();
                        }
                        return res;

                    }
                }
            ],
            "fuelEnd": [
                {
                    errorMessage: "Недопустимое значение поля Топливо в баке Конец периода",
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                       
                        var res = !isNaN($scope.parseNumber(val));
                       

                        if (!res) {
                            element.focus();
                        }
                        return res;

                    }
                }
            ],
            
        };


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

       
        $scope.errors = [];
        $scope.$on("customValidationComplete", function (e, data) {
            if (data.validation != undefined)
                $scope.errors.push(data);
        });


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

            $scope.approveIsNeeded(status).then(function (result) {
                if (result) {
                   

                    if (!$scope.form1.$valid ) {
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
                                  
                                    return res;
                                }
                            }
                        });
                        return false;
                    }
                    $scope.showModalIfNeed(status).then(function (result) {
                      
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
            }).result.then(function (result) {
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
                url: "./travelLists/save",
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

        $scope.goBack = function () {
            $state.transitionTo($scope.prevState);
        }

        // tp#557 
        $scope.initDates = function () {
            var today = moment(new Date()).startOf("day");
            var date1 = undefined,
                date2 = undefined;
            if (today.date() >= 1 && today.date() <= 15) {
                //  date1 = today.subtract(1, 'month').startOf('month');
             
                date1 = moment(new Date()).startOf("day").subtract(1, "month").startOf("month");
                date2 = moment(new Date()).startOf("day").subtract(1, "month").endOf("month");
                console.log(date1);
                console.log(date2);


            } else {
                date2 = moment(new Date()).startOf("day");
                date1 = today.startOf("month");
            }
            $scope.formData.date.startDate = date1.format();
            $scope.formData.date.endDate = date2.format();
           
        }

        $scope.getConsumption = function (car) {
          
            console.log(car);

            if (car == undefined & car==null) return undefined;
            var fc = undefined;
           

            angular.forEach($scope.travelListData.fuelConsumption, function(v, k) {
                if (v.Name === car.Type) {
                    fc = v;
                }
            });
            if(fc!=undefined)
               $scope.formData.fuelType = fc;
            return fc;
        }

        $scope.updatePeriod = function () {
            $scope.calcRefuelingByCards();
            $scope.calcRealConsumption();
            
        }

        $scope.calcRefuelingByCards = function () {
           var q = 0;
           var sum = 0;
           angular.forEach($scope.travelListData.fuelCardTransactions, function (v, k) {
                var tm = moment(v.Time);
                if (moment($scope.formData.date.startDate).startOf("day") <= tm && moment($scope.formData.date.endDate).endOf("day") > tm) {
                   
                    sum += Math.round(v.FullAmmount *100 / 1.18 ) /100;
                    q += v.Quantity;
                 }
            });
            $scope.formData.refueledByCardSum = sum.toFixed(2);
            $scope.formData.refueledByCard = q.toFixed(2);
        }

        $scope.parseFuelExpence = function () {
            if ($scope.formData.fuelType === undefined) return "";
            var today = moment(new Date()).startOf("day");
            var consumptionPeriod = undefined;
            if (today.month() >= 3 && today.month() <= 8)
                consumptionPeriod = $scope.formData.fuelType.ConsumptionSummer;
            else
                consumptionPeriod = $scope.formData.fuelType.ConsumptionWinter;
            var res = consumptionPeriod;
            $scope.formData.fuelExpense = res;
            return res;
        }

        $scope.calcRealConsumption = function () {
           //var refueledNotByCard;
           //if ($scope.formData.refueledNotByCard != undefined) {
           //     refueledNotByCard = $scope.parseNumber($scope.formData.refueledNotByCard);
           //    if (isNaN(refueledNotByCard)) {
           //        refueledNotByCard = 0;
           //    }
           //}
           //else {
           //    refueledNotByCard = 0;
           //}
            if ($scope.formData.fuelStart === 0 && $scope.formData.fuelEnd === 0) {
                // tp#681 п.1
                $scope.formData.spent = $scope.parseNumber($scope.formData.refueledByCard) +
                                        $scope.parseNumber($scope.formData.refueledNotByCard);
            }
            else if ($scope.formData.fuelStart != undefined && $scope.formData.fuelEnd != undefined &&
                $scope.formData.refueledByCard!=undefined) {
                // tp#681 п.2
                var res = $scope.parseNumber($scope.formData.fuelStart) + $scope.parseNumber($scope.formData.refueledByCard) +
                          $scope.parseNumber($scope.formData.refueledNotByCard) - $scope.parseNumber($scope.formData.fuelEnd);
                $scope.formData.spent = res.toFixed(2);
                
               
               
            }
            $scope.calcOverSpent();
            $scope.formData.spentSum = $scope.getTotalRefuel();
           
        }

       

        $scope.parseNumber = function(n) {
            return parseFloat(n, 10);
        }
        $scope.calcSpentByExpense = function () {
            if ($scope.formData.odometerStart != undefined && $scope.formData.odometerEnd != undefined) {
                var res = (($scope.parseNumber( $scope.formData.odometerEnd) - $scope.parseNumber($scope.formData.odometerStart)) * $scope.parseNumber($scope.formData.fuelExpense) / 100).toFixed(2);
                if (res >= 0) {
                    $scope.formData.spentByExpense = res;
                    $scope.calcOverSpent();
                }
            }
        }
        $scope.calcOverSpent = function() {
            if ($scope.formData.spentByExpense != undefined && $scope.formData.spent != undefined) {
                $scope.formData.overSpent = ($scope.parseNumber($scope.formData.spent) - $scope.parseNumber($scope.formData.spentByExpense)).toFixed(2);
                if ($scope.formData.overSpent <= 0)
                    $scope.formData.overSpent = undefined;

            }
        }

        $scope.calcOverLimit = function () {
            return $scope.parseNumber($scope.getTotalRefuel()) <= $scope.parseNumber($scope.formData.limit);
        }

        $scope.getTotalRefuel = function () {
            if ($scope.formData.refueledByCardSum !== undefined && $scope.formData.refueledNotByCardSum !== undefined && $scope.formData.refueledNotByCardSum !== null) {
                var res = $scope.parseNumber($scope.formData.refueledByCardSum) +
                    $scope.parseNumber($scope.formData.refueledNotByCardSum);
                return res.isNaN ? 0 : res.toFixed(2);
            }
            return 0;
        }

        $scope.getLimit = function () {
            var limit = 6000;

            if ($scope.travelListData == null) return limit;
          
            $.each($scope.travelListData.limit, function (key, value) {
                if (key === "Бензин") {
                    limit = value;
                   
                }
            });
           
            return limit;
        }

        activate();

        function activate() {
            $scope.prevState = $stateParams.prevState;
            $scope.action = $stateParams.action;
            $stateParams.action = $stateParams.action == undefined ? "Создать, Отправить" : $stateParams.action;
            $scope.initDates();

            var referencesRequest = $http({
                method: "POST",
                url: "./references/getAll",
                
                data: JSON.stringify(["person", "car", "fuelConsumption", "fuelCard","fuelCardTransaction", "limit"])

            }).success(function (response) {
               
                $scope.travelListData = response;               
                
                
                $scope.calcRefuelingByCards();
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные маршрутного листа получены!");
            }).error(function (error) {
                toastr.error("Ошибка!");
                throw error;
            });

            $q.all([referencesRequest])
                .then(function(responses) {
                    if ($stateParams.id === undefined)
                        $stateParams.id = -1;

                    $http({
                            method: "GET",
                            url: "./travelLists/get?id=" + $stateParams.id,
                            cache: false
                        })
                        .success(function(response) {
                            $scope.formData = response;

                            $scope.getConsumption($scope.formData.carData);

                            if ($scope.travelListData.cars[0]==undefined) {
                                $scope.travelListData.cars[0] = $scope.formData.carData;
                            }

                            if ($stateParams.id === -1) {
                                $scope.formData.person = JSON.parse(sessionStorage.getItem("currentUser"));
                                $scope.formData.limit = $scope.getLimit();
                                                              
                            }
                            if ($scope.formData.limit !== undefined)
                                $scope.docPath[1] += " " + $scope.formData.limit.toFixed(2) + " руб.";

                            $scope.accessList = $scope.formData.accessList;
                            if ($appConfig.showSuccessToastr)
                                toastr.success("Данные маршрутных листов получены!");

                            setTimeout(function() {
                                    $scope.$broadcast("runCustomValidations");
                                },
                                1000);
                        })
                        .error(function(error) {
                            toastr.error("Ошибка!");
                            throw error;
                        });
                })
                .then(function(res) {
                    $scope.calcRealConsumption();

                });
        }

        $scope.showHistory = function () {
            $uibModal.open({
                templateUrl: "app/templates/requests/modals/prepaymentRequestHistory.html",
                controller: "PrepaymentRequestHistoryController",
                resolve: {
                    stateParams: function () {
                        return { Type: "Заявка на аванс", Id: $stateParams.id };
                    }
                }
            });
        }
    });