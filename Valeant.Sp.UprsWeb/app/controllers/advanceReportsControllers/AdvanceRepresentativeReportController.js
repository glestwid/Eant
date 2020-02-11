angular.module("valeant.controllers")

    .controller("AdvanceRepresentativeReportController", function ($scope, $state, $stateParams, $http, toastr, $q, $timeout, $uibModal, $appConfig) {
        $scope.formData = {
            costsData: { rows: [], options: {sumFiscal: 0, sumNoFiscal: 0} },
            scanPdfsData: { rows: [], options: {} },
            thirdPartyOccasionsData: { rows: [], options: {} },
            corporateOccasionsData: { rows: [], options: {} },
            giftsData: {  rows: [], options: {}},
            reportMainData: {
                date: moment(new Date()).format(""),
                comment: undefined,
                person: undefined
            }
        };
       // $scope.maxFilesSize = 10000000;
       // $scope.currentFilesSize = 0;
        $scope.tripRequests = [];
        $scope.entertainmentExpensesData = [];
        $scope.persons = [];

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

        $scope.totalFiscal = function () {
            var total = 0;
            for (var i = 0; i < $scope.formData.costsData.rows.length; i++) {
                if ($scope.formData.costsData.rows[i].fiscal) {
                    var curr = parseFloat($scope.formData.costsData.rows[i].sum, 10);
                    if (!isNaN(curr))
                        total += curr;
                    //else {
                    //    return "";
                    //}
                }
            }
            $scope.formData.costsData.options.sumFiscal = total;
            return total;
        }

        $scope.totatNoFiscal = function () {
            var total = 0;
            for (var i = 0; i < $scope.formData.costsData.rows.length; i++) {
                if (!$scope.formData.costsData.rows[i].fiscal) {
                    var curr = parseFloat($scope.formData.costsData.rows[i].sum, 10);
                    if (!isNaN(curr))
                        total += curr;
                    //else {
                    //    return "";
                    //}
                }
            }
            $scope.formData.costsData.options.sumNoFiscal = total;
            return total;
        }

        $scope.$watch("formData.costsData.rows", function (newRows, oldRows) {
            $scope.totatNoFiscal();
            $scope.totalFiscal();
        });

        activate();

        function activate() {
            // Тип документа, статья раходов, УГ
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

            var costItems = $http({
                method: "GET",
                url: "./costItems/getDocumentLimits?documentType=RepresentativeReport&documentId=" + $stateParams.id,
                cache: false
            }).success(function (response) {
                $scope.costItems = response;
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

            var triprequests = $http({
                method: "GET",
                url: "./tripRequests/getAll?statusFilter=" + "Все" + "&dateRangeFilter=" + $scope.selectedDateRangeCriteria,
                cache: false
            }).success(function (response) {
                angular.forEach(response, function (v, k) {
                    if (v.Status === "Черновик" || v.Status.indexOf("Согласован") !== -1)
                        return false;;
                    $scope.tripRequests.push(v);
                });
                
            }).error(function (error) {
                throw error;
            });

            $q.all([referencesRequest, costItems, personsRequest, triprequests])
                .then(function(responses) {
                    if ($stateParams.id == undefined)
                        $stateParams.id = -1;

                    console.log($stateParams.id);
                    $http({
                            method: "GET",
                            url: "./representativeAdvanceReport/get?id=" + $stateParams.id,
                            cache: false
                        })
                        .success(function(response) {                            
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

                            $scope.accessList = $scope.formData.accessList;
                            if ($appConfig.showSuccessToastr)
                                toastr.success("Данные получены!");
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

        // Расходы - переименовать
        $scope.addCost = function () {
            var tripCost = {
                index: $scope.formData.costsData.rows.length + 1,
                documentType: undefined,
                costItem: undefined,
                accountGroup: undefined,
                date: null,
                documentNumber: undefined,
                sum: 0,
                absence: false,
                fiscal: true,
                debit: undefined, // для бухгалтера
                credit: undefined // для бухгалтера
            };
            $scope.formData.costsData.rows.push(tripCost);
        }

        $scope.resolveModal = function(model) {
            var modalUrl = undefined,
                controllerName = undefined;
            if (model === "thirdParty") {
                controllerName = "ThirdPartyController";
                modalUrl = "thirdPartyModal";
            }
            if (model === "corporate") {
                controllerName = "CorporateOccasionsController";
                modalUrl = "corporateOccasionsModal";
            }
            if (model === "gift") {
                controllerName = "GiftModalController";
                modalUrl = "giftModal";
            }
            return { url: modalUrl, controller: controllerName };
        }

        // вызовы модалок
        $scope.addRow = function (model) {
            var resolved = $scope.resolveModal(model);
            $uibModal.open({
                templateUrl: "app/templates/advanceReports/modals/" + resolved.url + ".html",
                controller: resolved.controller,
                resolve: {
                    row: function() {
                        return null;
                    },
                    index: function() {
                        return resolved.length + 1;
                    }
                }
            }).result.then(function (result) {
                console.log(result);
                if (result) {

                    if (model === "thirdParty") {
                        result.index = $scope.formData.thirdPartyOccasionsData.rows.length + 1;
                        $scope.formData.thirdPartyOccasionsData.rows.push(result);
                    }
                    if (model === "corporate") {
                        result.index = $scope.formData.corporateOccasionsData.rows.length + 1;
                        $scope.formData.corporateOccasionsData.rows.push(result);
                    }
                    if (model === "gift") {
                        result.index = $scope.formData.giftsData.rows.length + 1;
                        $scope.formData.giftsData.rows.push(result);
                    }
                }
            });
        }


        $scope.approveIsNeeded = function (action) {
            if (action === "Редактировать" || action === "Разделить") {
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
        $scope.applyAction = function (action, model) {
            var indexToApply = this.$index;
            $scope.approveIsNeeded(action).then(function (result) {
                if (result) {
                    var rowsToModify = undefined;
                    if (model === "costs")
                        rowsToModify = $scope.formData.costsData.rows;
                    if (model === "thirdParty")
                        rowsToModify = $scope.formData.thirdPartyOccasionsData.rows;
                    if (model === "corporate")
                        rowsToModify = $scope.formData.corporateOccasionsData.rows;
                    if (model === "gift")
                        rowsToModify = $scope.formData.giftsData.rows;
                    if (action === "Удалить") {
                        if(rowsToModify != undefined)
                            rowsToModify.remove(indexToApply);
                    }
                    if (action === "Редактировать") {
                        var resolved = $scope.resolveModal(model);
                        $uibModal.open({
                            templateUrl: "app/templates/advanceReports/modals/" + resolved.url + ".html",
                            controller: resolved.controller,
                            resolve: {
                                row: function() {
                                    return angular.copy(rowsToModify[indexToApply]);
                                },
                                index : function() {
                                    return rowsToModify[indexToApply].index;
                                }
                            }
                        }).result.then(function (result) {
                            if (result) {
                                console.log(result);
                                rowsToModify[indexToApply] = result;
                            }
                        });
                    }
                    if (action === "Разделить") {
                        $timeout(function () {
                            $uibModal.open({
                                templateUrl: "app/templates/advanceReports/modals/splitRow.html",
                                controller: "SplitRowModalController",
                                resolve: {
                                    row: function () {
                                        return angular.copy(rowsToModify[indexToApply]); //$scope.formData.costsData.rows[indexToApply];
                                    },
                                    rowModelName: function () {
                                        return "Расходы";
                                    }
                                }
                            }).result.then(function (splittedRows) {
                                //удалям строчку по индексу indexToApply и вставляем на её место две новых
                                if (splittedRows != undefined) {
                                    rowsToModify[indexToApply] = splittedRows[0];
                                    rowsToModify.splice(indexToApply, 0, splittedRows[1]);
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

        $scope.save = function (status) {
            console.log($scope.formData);
            status = status.replace(/^\s\s*/, "");

            $scope.$broadcast("runCustomValidations");

            var destDataEmptyMsg = "";
            if ($scope.formData.costsData.rows.length === 0)
                destDataEmptyMsg = "Таблица расходов пуста";

            //#934 Блок приложенных документов должен быть обязательным
            if ($scope.formData.scanPdfsData.rows.length === 0)
                destDataEmptyMsg += "<br/>" + "Блок приложенных документов пуст";

            if (!$scope.formCost.$valid || !$scope.formHeader.$valid || destDataEmptyMsg !== "") {
                $uibModal.open({
                    templateUrl: "app/templates/modals/notifyModal.html",
                    controller: "NotifyModalController",
                    resolve: {
                        title: function () {
                            return "Ошибки при валидации формы";
                        },
                        message: function () {
                            var msg = "Заполните обязательные поля";
                            return destDataEmptyMsg === "" ? msg : destDataEmptyMsg;
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
                url: "./representativeAdvanceReport/save",
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


        // Сканы todo: добавить ограничение на 10мб как в заявке на командировку
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
               // if (($scope.currentFilesSize + $scope.selectedFile.size) > $scope.maxFilesSize) {
                    //$uibModal.open({
                    //    templateUrl: "app/templates/modals/notifyModal.html",
                    //    controller: "NotifyModalController",
                    //    resolve: {
                    //        title: function () {
                    //            return undefined;
                    //        },
                    //        message: function () {
                    //            return "Превышен максимальный объём файлов (10 мб)";
                    //        }
                    //    }
                   // });
                  //  return false;
               // } else {
                   // $scope.currentFilesSize += $scope.selectedFile.size;
               // }
                var blob = $scope.selectedFile.slice(0, $scope.selectedFile.size - 1);
                reader.readAsArrayBuffer(blob);
            }
        }
        $scope.removeScanPdf = function () {
           // $scope.currentFilesSize = $scope.currentFilesSize - $scope.formData.scanPdfsData.rows[this.$index].data.length;
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
                        return { Type: "Авансовый отчет по представительским и текущим расходам", Id: $stateParams.id };
                    }
                }
            });
        }


        $scope.goBack = function () {
            $state.transitionTo($state.params.prevState);
        }
    });