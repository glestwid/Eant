angular.module("valeant.controllers")
    .controller("NewPrepaymentRequestController", function ($scope, $q, $state, $stateParams, toastr, $http, $uibModal, $appConfig) {
        $scope.formData = {
            requestId: undefined,
            number: undefined,
            status: undefined,
            date: undefined,
            denyReason: undefined,

            advanceRequestsData: {
                rows: [],
                options: {
                    advanceDate: moment().startOf("day").format(),
                    sum: 0
                }
            }
        }

        //Валидация
        $scope.validations = {
            "advance": [
                {
                    errorMessage: "Поле 'Аванс' не заполнено",
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        return val > 0 && val !== "";
                    }
                },
                {
                    errorMessage: "Превышение поля 'Аванс'",
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        if (model.advance > model.costItem.Limit) {
                            return model.comment.length > 0;
                        }

                        return true;
                    }
                }
            ],
            "comment": [
                {
                    errorMessage: "Не выбрана статья расходов",
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                        return model.costItem != undefined;
                    }
                },
                {
                    errorMessage: "Не заполнен комментарий - введённая сумма больше допустимого лимита",
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        if (model.advance > model.costItem.limit) {
                            return val.length > 0;
                        }
                        return true;
                    }
                },
                {
                    errorMessage: "Не заполнен комментарий - выбрана статья 'Прочие расходы'",
                    validator: function(errorMessageElement, val, attr, element, model, modelCtrl) {
                        if (model.costItem == undefined)
                            return true;

                        if (model.costItem.Name === "Прочие расходы")
                            return val.length > 0;
                        return true;
                    }
                }
            ]
        };

        $scope.accessList = {};
        $scope.referencesData = [];
        $scope.action = undefined;

        $scope.totalAdvances = function () {
            var total = 0;
            for (var i = 0; i < $scope.formData.advanceRequestsData.rows.length; i++) {
                var curr = parseFloat($scope.formData.advanceRequestsData.rows[i].advance, 10);
                if (!isNaN(curr))
                    total += curr;
                else {
                    return "";
                }
            }
            total = total.toFixed(2);
            $scope.formData.advanceRequestsData.options.sum = total;
            return total;
        }

        // для удаления  todo: вынести отседова
        Array.prototype.remove = function (from, to) {
            var rest = this.slice((to || from) + 1 || this.length);
            this.length = from < 0 ? this.length + from : from;
            return this.push.apply(this, rest);
        };

        $scope.inputFocus = function(val) {
            if (val.advance == 0) //==, вдруг будет 000000
                val.advance = "";
        }

        $scope.inputBlur = function (val) {
            if (val.advance === "")
                val.advance = 0;
        }

        $scope.selectChanged = function (row, oldValue) {
            // преверяем использовано ли значение
            var exist = false;
            angular.forEach($scope.formData.advanceRequestsData.rows.filter(function(x) {
                return x !== row;
            }), function (value, key) {
                if (value.costItem != null && row.costItem != null)
                    if (value.costItem.Id === row.costItem.Id) {
                        exist = true;
                    }
            });

            //если уже есть такая статья, то оставляем старое значение
            if (exist) {
                row.costItem = oldValue;
                return false;
            }

            //обнуляем аванс при смене статьи расходов
            row.advance = 0;
        }

        $scope.print = function () {
            $http({
                method: "GET",
                url: "./printing/getForm?id=" + $scope.formData.requestId,
                cache: false
            }).success(function (response) {
                window.open(response);
            }).error(function (error) {
                toastr.error("Ошибка!");
                throw error;
            });
        }

        activate();

        function activate() {
            $scope.prevState = $stateParams.prevState;

            var referencesRequest = $http({
                method: "GET",
                url: "./costItems/getDocumentLimits?documentType=PrepaumentRequest&documentId=" + $stateParams.id
            }).success(function (response) {
                $scope.costItems = response;
            }).error(function (error) {
                toastr.error("Ошибка!");
                throw error;
            });

            $q.all([referencesRequest])
                .then(function(responses) {
                    if ($stateParams.id == undefined) {
                        $stateParams.id = -1;
                    }
                    console.log($stateParams.id);
                    $http({
                            method: "GET",
                            url: "./prepaymentRequests/get?id=" + $stateParams.id,
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
                            $scope.accessList = $scope.formData.accessList;
                            if ($stateParams.id == -1) {
                                var initialRow = {
                                    index: $scope.formData.advanceRequestsData.rows.length + 1,
                                    costItem: undefined,
                                    advance: 0,
                                    comment: "",
                                    timestamp: Date.now()
                                }
                                $scope.formData.advanceRequestsData.rows.push(initialRow);
                            }
                            if ($appConfig.showSuccessToastr)
                                toastr.success("Данные о заявке получены!");
                        })
                        .error(function(error) {
                            toastr.error("Ошибка!");
                            throw error;
                        });
                });

            
        }

        // заявки на аванс
        $scope.addAdvanceRequest = function () {
            var advanceRequest = { index: $scope.formData.advanceRequestsData.rows.length + 1, costItem: undefined, advance: 0, comment: "", timestamp: Date.now() }
            $scope.formData.advanceRequestsData.rows.push(advanceRequest);
        }

        $scope.removeAdvanceRequest = function () {
            var removeIndex = this.$index;
            $scope.formData.advanceRequestsData.rows.remove(removeIndex);
            

            for (var i = 0; i < $scope.formData.advanceRequestsData.rows.length; i++) {
                $scope.formData.advanceRequestsData.rows[i].index = i + 1;
            }
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

        $scope.errors = [];
        $scope.$on("customValidationComplete", function (e, data) {
            //TODO: Frontend developer code review required.
            var rowIndexes = $scope.formData.advanceRequestsData.rows.map(function(el) {
                return el.timestamp;
            });
            if (rowIndexes.includes(data.model.timestamp)) {
                $scope.errors.push(data);
            }

            //$scope.errors.push(data);
        });

        $scope.save = function (status) {
            status = status.replace(/^\s\s*/, "");
            console.log(status);
            $scope.errors = [];
           
            if (status === "Печать") {
                console.log("Печать...");
                if ($appConfig.showSuccessToastr)
                    toastr.success("Формирование отчёта...!");
                window.open("./printing/getForm?id=" + $stateParams.id + "&format=PDF");
                return false;
            }

            $scope.$broadcast("runCustomValidations");

            $scope.approveIsNeeded(status).then(function(result) {
                if (result) {
                    if (!$scope.form.$valid) {
                        $uibModal.open({
                            templateUrl: "app/templates/modals/notifyModal.html",
                            controller: "NotifyModalController",
                            resolve: {
                                title: function () {
                                    return "Ошибки при валидации формы";
                                },
                                message: function () {
                                    return $scope.errors.map(function (x) { return "Строка " + x.model.index + " : "+ x.validation }).join("<br/>");
                                }
                            }
                        });

                        return false;
                    }

                    if ($scope.formData.advanceRequestsData.options.sum === "0.00") {
                        $uibModal.open({
                            templateUrl: "app/templates/modals/notifyModal.html",
                            controller: "NotifyModalController",
                            resolve: {
                                title: function () {
                                    return undefined;
                                },
                                message: function () {
                                    return "Заполните заявку на аванс"; //"Сумма расхода нулевая!";
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

        $scope.saveAjaxCall = function (status) {
            $http({
                method: "POST",
                url: "./prepaymentRequests/save",
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

        $scope.goBack = function () {
            $state.transitionTo($scope.prevState);
        }
    });