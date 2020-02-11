angular.module("valeant.controllers")

    .controller("AdvanceTripReportsController", function ($scope, $state, $stateParams, $http, toastr, $q, $timeout, $uibModal, $appConfig) {
        $scope.formData = {
            tripCostsData: { rows: [], options: {sum: 0} },
            scanPdfsData: { rows: [], options: {} },
            reportMainData: {
                date: moment(new Date()).format(""),
                tripRequest: undefined,
                tripType: undefined,
                serviceVehicle: false,
                comment: undefined,
                person: undefined
            }
        };
        //$scope.maxFilesSize = 10000000;
        //$scope.currentFilesSize = 0;
        $scope.tripRequests = [];
        $scope.tripReportData = [];
        $scope.persons = [];
        $scope.costItems = [];

        $scope.validations = {
            "selectInputField": [
                {
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                        var res = val.length > 0;
                        if (!res) {
                            element.focus();
                        }
                        return res;
                    }
                }
            ],
            "date": [
                  {
                      validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                          var res = val.length > 0;
                          if (!res) {
                              element.focus();
                          }
                          return res;
                      }
                  }
            ],
            "sum": [
                {
                    errorMessage: "Поле 'Сумма' не заполнено",
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                        return val > 0 && val !== "";
                    }
                },
                {
                    errorMessage: "Превышение поля 'Сумма'",
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                        //if (model.sum > model.limit) {
                        //    return model.comment.length > 0;
                        //}

                        return true;
                    }
                }
            ]
            
        };

        $scope.inputFocus = function (val) {
            if (val.sum == 0) //==, вдруг будет 000000 !!!
                val.sum = "";
        }

        $scope.inputBlur = function (val) {
            if (val.sum === "")
                val.sum = 0;
            val.sum = parseFloat(val.sum, 10).toFixed(2);
        }

        $scope.tripRequestChanged = function() {
            $scope.formData.reportMainData.tripType = $scope.formData.reportMainData.tripRequest.TripTypeName;
            $scope.formData.reportMainData.serviceVehicle = $scope.formData.reportMainData.tripRequest.ServiceVehicle;

            if ($scope.formData.tripCostsData.rows.length === 0) {
                $scope.addTripCost();
            }
            $scope.formData.tripCostsData.rows[0].sum = $scope.formData.reportMainData.tripRequest.Sum;

            $scope.formData.tripCostsData.rows[0].documentType = function() {
                if ($scope.formData.reportMainData.tripRequest.TripTypeName === "Командировка")
                    return $scope.tripReportData.documentTypes.filter(function(u) { return u.Name === "Приказ" })[0];
                else
                    return $scope.tripReportData.documentTypes.filter(function(u) { return u.Name === "Служебное задание" })[0];
            }();

            $scope.formData.tripCostsData.rows[0].documentNumber = $scope.formData.reportMainData.tripRequest.Number;
            $scope.formData.tripCostsData.rows[0].date = function() {
                if ($scope.formData.reportMainData.tripRequest.TripTypeName === "Командировка")
                    return $scope.formData.reportMainData.tripRequest.FromDate;
                else
                    return $scope.formData.reportMainData.tripRequest.DateStart;
            }();


        }

        $scope.totalTripCost = function () {
            var total = 0;
            if ($scope.formData.tripCostsData == undefined) return "";
            for (var i = 0; i < $scope.formData.tripCostsData.rows.length; i++) {
                var curr = parseFloat($scope.formData.tripCostsData.rows[i].sum, 10);
                if (!isNaN(curr))
                    total += curr;
                //else {
                //    return "";
                //}
            }
            $scope.formData.tripCostsData.options.sum = total;
            return total;
        }

        $scope.$watch("formData.tripCostsData.rows", function (newRows, oldRows) {
           $scope.totalTripCost();
        });

        activate();

        function activate() {
            // accessLists,
            // Данные текущего отчёта, 
            // Заявки на поездку, не в статусе «Черновик», «На согласовании», «Согласован». 
            $scope.prevState = $stateParams.prevState;

            var referencesRequest = $http({
                method: "POST",
                url: "./references/getAll",
                data: JSON.stringify(["person", "accountGroup", "documentType"])
            }).success(function (response) {
                $scope.tripReportData = response;

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

            var costItems =  $http({
                method: "GET",
                url: "./costItems/getDocumentLimits?documentType=TripReport&documentId=" + $stateParams.id,
                cache: false
            }).success(function (response) {
                $scope.costItems = response;
            }).error(function (error) {
                toastr.error("Ошибка!");
                throw error;
            });

            var triprequests = $http({
                method: "GET",
                url: "./tripRequests/getAllForReport",
                cache: false
            }).success(function (response) {
                $scope.tripRequests = response;
                //angular.forEach(response, function (v, k) {
                //    if (v.Status === "Черновик" || v.Status.indexOf("Согласован") !== -1)
                //        return false;;
                //    $scope.tripRequests.push(v);
                //});
                
            }).error(function (error) {
                throw error;
            });

            $q.all([referencesRequest, personsRequest, triprequests, costItems])
                .then(function(responses) {
                    if ($stateParams.id == undefined)
                        $stateParams.id = -1;

                    console.log($stateParams.id);
                    $http({
                            method: "GET",
                            url: "./tripAdvanceReports/get?id=" + $stateParams.id,
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
                                $scope.formData.reportMainData.person = JSON.parse(sessionStorage.getItem("currentUser"));

                            $scope.accessList = response.accessList;
                            if ($appConfig.showSuccessToastr)
                                toastr.success("Данные об отчёте получены!");
                            setTimeout(function() {
                                    $scope.$broadcast("runCustomValidations");
                                },
                                1000);
                        })
                        .error(function(error) {
                            throw error;
                        });
                });
        };

        Array.prototype.remove = function (from, to) {
            var rest = this.slice((to || from) + 1 || this.length);
            this.length = from < 0 ? this.length + from : from;
            return this.push.apply(this, rest);
        };

        // Расходы
        $scope.addTripCost = function() {
            var tripCost = {
                index: $scope.formData.tripCostsData.rows.length + 1,
                documentType: undefined,
                costItem: undefined,
                accountGroup: undefined,
                date: null,
                documentNumber: undefined,
                sum: 0.00,
                absence: false,
                fiscal: true,
                debit: undefined, // для бухгалтера
                credit: undefined // для бухгалтера
            };
            $scope.formData.tripCostsData.rows.push(tripCost);
        };

        $scope.approveIsNeeded = function (action) {
            if (action === "Разделить") {
                return $q.resolve(true);
            }

            return $uibModal.open({
                templateUrl: "app/templates/modals/approveAction.html",
                controller: "ApproveActionModalController",
                resolve: {
                    title: function () {
                        return action;
                    }
                }
            }).result.then(function (result) {
                return result;
            });
        }

        // Действия
        $scope.applyAction = function (action) {
            var indexToApply = this.$index;
            $scope.approveIsNeeded(action).then(function (result) {
                if (result) {
                    if (action === "Удалить")
                        $scope.formData.tripCostsData.rows.remove(indexToApply);
                    if (action === "Разделить") {
                        $timeout(function() {
                            $uibModal.open({
                                templateUrl: "app/templates/advanceReports/modals/splitRow.html",
                                controller: "SplitRowModalController",
                                resolve: {
                                    row: function () {
                                        return $scope.formData.tripCostsData.rows[indexToApply];
                                    },
                                    rowModelName: function () {
                                        return "Командировочные расходы";
                                    }
                                }
                            }).result.then(function (splittedRows) {
                                //удалям строчку по индексу indexToApply и вставляем на её место две новых
                                if (splittedRows != undefined) {
                                    $scope.formData.tripCostsData.rows[indexToApply] = splittedRows[0];
                                    $scope.formData.tripCostsData.rows.splice(indexToApply, 0, splittedRows[1]);
                                    $scope.$broadcast("runCustomValidations");
                                }
                            });
                        }, 700);
                    }
                }
            }, function () {
                return false;
            });
        }
        // Сохранение

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

        $scope.saveAjaxCall = function(status) {
            $http({
                method: "POST",
                url: "./tripAdvanceReports/save",
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

        $scope.$on("customValidationComplete", function (e, data) {
            //TODO: Frontend developer code review required.
            //var rowIndexes = $scope.formData.advanceRequestsData.rows.map(function (el) {
            //    return el.index;
            //});
            //if (rowIndexes.includes(data.model.index)) {
            //    $scope.errors.push(data);
            //}

            $scope.errors.push(data);
        });

        $scope.errors = [];
        $scope.save = function (status) {
            console.log($scope.formData);
            status = status.replace(/^\s\s*/, "");
            $scope.errors = [];

            $scope.$broadcast("runCustomValidations");
            var isScansRequired = false;
            if (!$scope.formData.reportMainData.tripRequest.IsOnlyDailyCostsExist && $scope.formData.scanPdfsData.rows.length === 0)
                isScansRequired = true;

            if (!$scope.formTrip.$valid ||
                !$scope.formHeader.$valid || isScansRequired) {
                $uibModal.open({
                    templateUrl: "app/templates/modals/notifyModal.html",
                    controller: "NotifyModalController",
                    resolve: {
                        title: function () {
                            return "Ошибки при валидации формы";
                        },
                        message: function () {
                            var scanMsgRequired = isScansRequired ? "Блок приложенных документов пуст" : "";
                            return "Заполните обязательные поля! </br>" + scanMsgRequired;
                            //$scope.errors.map(function (x) { return "Строка " + x.model.index + " : " + x.validation }).join("<br/>");
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

            return false;
        }

        // Сканы
        // Return a random number between 1 and 100 Для сканов
        $scope.generateScanKey = function () {
            var rnd = Math.floor((Math.random() * 100) + 1);
            angular.forEach($scope.formData.scanPdfsData.rows, function (v, k) {
                if (v.key === rnd) {
                    rnd = Math.floor((Math.random() * 100) + 1);
                }
            });
            return rnd;
        }
        $scope.addScanPdf = function () {
            if ($scope.selectedFile != undefined) {
                var reader = new FileReader();
                // If we use onloadend, we need to check the readyState.
                reader.onloadend = function (evt) {
                    if (evt.target.readyState === FileReader.DONE) { // DONE == 2
                        var rndKey = $scope.generateScanKey();
                        var scan = { name: $scope.selectedFile.name, index: $scope.formData.scanPdfsData.rows.length + 1, data: $scope._arrayBufferToBase64(evt.target.result), key: rndKey }
                        $scope.$apply(function () {
                            $scope.formData.scanPdfsData.rows.push(scan);
                            $scope.selectedFile = undefined;
                        });
                       
                    }
                };
                //checkCurrentSum
                //if (($scope.currentFilesSize + $scope.selectedFile.size) > $scope.maxFilesSize) {
                //    $uibModal.open({
                //        templateUrl: "app/templates/modals/notifyModal.html",
                //        controller: "NotifyModalController",
                //        resolve: {
                //            title: function () {
                //                return undefined;
                //            },
                //            message: function () {
                //                return "Превышен максимальный объём файлов (10 мб)";
                //            }
                //        }
                //    });
                //    return false;
                //} else {
                //    $scope.currentFilesSize += $scope.selectedFile.size;
                //}
                var blob = $scope.selectedFile.slice(0, $scope.selectedFile.size - 1);
                reader.readAsArrayBuffer(blob);
            }
        }
        $scope.removeScanPdf = function () {
            //$scope.currentFilesSize = $scope.currentFilesSize - $scope.formData.scanPdfsData.rows[this.$index].data.length;
            $scope.formData.scanPdfsData.rows.remove(this.$index);
        }
        // преобразование в base64string
        $scope._arrayBufferToBase64 = function (buffer) {
            var binary = "";
            var bytes = new Uint8Array(buffer);
            var len = bytes.byteLength;
            for (var i = 0; i < len; i++) {
                binary += String.fromCharCode(bytes[i]);
            }
            return window.btoa(binary);
        }

        $scope.showHistory = function () {
            $uibModal.open({
                templateUrl: "app/templates/requests/modals/prepaymentRequestHistory.html",
                controller: "PrepaymentRequestHistoryController",
                resolve: {
                    stateParams: function () {
                        return { Type: "Авансовый отчет по командировке/служебной поездке", Id: $stateParams.id };
                    }
                }
            });
        }

        $scope.goBack = function () {
            $state.transitionTo($state.params.prevState);
        }


        $scope.printMemo = function (d) {
            window.open("./TripAdvanceReports/printMemo?id=" + d.requestId + '&rand=' + Math.random());
            return false;
        }


    });