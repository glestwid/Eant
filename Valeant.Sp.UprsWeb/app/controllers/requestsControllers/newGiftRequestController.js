angular.module("valeant.controllers")

    .controller("NewGiftRequestController", function ($scope, $q, $http, $uibModal, $state, $stateParams, toastr, $appConfig) {

        $scope.formData = {
            date: moment(new Date()).format(),
            giftDate: moment(new Date()).format(),
            description: undefined,
            reason: undefined,
            sum: 0,
            otherGiftsSum: 0,
            giftReciever: undefined,
            otherGiftsExist: false,
            otherGiftsComment: undefined
        }

        $scope.giftRecievers = [];

        activate();

        function activate() {
            $scope.prevState = $stateParams.prevState;

            var giftRecievers = $http({
                method: "GET",
                url: "./giftRecievers/getAll"
            }).success(function (response) {
                $scope.giftRecievers = response;
            }).error(function (error) {
                toastr.error("Ошибка!");
                throw error;
            });

            $q.all([giftRecievers]).then(function (responses) {
                if ($stateParams.id === undefined)
                    $stateParams.id = -1;

                console.log($stateParams.id);
                $http({
                    method: "GET",
                    url: "./giftRequests/get?id=" + $stateParams.id,
                    cache: false
                }).success(function (response) {
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
                    $scope.getPreviousGifts($scope.formData.giftReciever);
                    $scope.accessList = $scope.formData.accessList;
                    if ($appConfig.showSuccessToastr)
                        toastr.success("Данные о заявке получены!");
                }).error(function (error) {
                    toastr.error("Ошибка!");
                    throw error;
                });
            });
        }

        $scope.$watch("formData.giftReciever",
            function (newValue) {
                if (newValue)
                    $scope.getPreviousGifts(newValue);
            },
            true);

        $scope.getPreviousGifts = function (data) {
            if (data != undefined)
                $scope.formData.gifts = data.PreviousGifts === null ? [] : data.PreviousGifts;
        }

        $scope.addGiftReciever = function () {
            $uibModal.open({
                templateUrl: "app/templates/settings/modals/editGiftRecieverModal.html",
                controller: "EditGiftRecieverController",
                resolve: {
                    row: function () {
                        return { IsNew: true };
                    }
                }
            }).result.then(function (result) {
                $http({
                    method: "GET",
                    url: "./giftRecievers/getAll"
                }).success(function (response) {
                    $scope.giftRecievers = response;

                    if (result.IsNew) {
                        var newGiftReciever = $scope.giftRecievers.filter(function (gr) {
                            if (gr.Name === result.Name && gr.SecondName === result.SecondName ||
                                gr.MiddleName === result.MiddleName ||
                                gr.AgreementNumber === result.AgreementNumber ||
                                gr.Position === result.Position ||
                                gr.Organization === result.Organization)
                                return true;
                        })[0];
                        $scope.formData.giftReciever = newGiftReciever;
                    }
                }).error(function (error) {
                    toastr.error("Ошибка!");
                    throw error;
                });

            });
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

        $scope.errors = [];
        $scope.$on("customValidationComplete", function (e, data) {
            if (data.validation !== undefined)
                $scope.errors.push(data.validation);
        });

        $scope.save = function (status) {
            console.log($scope.formData);
            status = status.replace(/^\s\s*/, "");

            if (status === "Печать") {
                console.log("Печать...");
                if ($appConfig.showSuccessToastr)
                    toastr.success("Формирование отчёта...!");
                window.open("./printing/getForm?id=" + $stateParams.id + "&format=PDF");
                return false;
            }

            $scope.errors = [];
            $scope.$broadcast("runCustomValidations");
            $scope.approveIsNeeded(status).then(function (result) {
                if (result) {
                    if (!$scope.formGift.$valid) {
                        $uibModal.open({
                            templateUrl: "app/templates/modals/notifyModal.html",
                            controller: "NotifyModalController",
                            resolve: {
                                title: function () {
                                    return "";
                                },
                                message: function () {
                                    return "Заполните обязательные поля!<br/><br/>" + $scope.errors.join("<br/>");
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
                url: "./giftRequests/save",
                data: JSON.stringify({ action: status, data: $scope.formData, denyReason: $scope.formData.denyReason })
            }).success(function (response) {
                if (response.limitErr) {
                    $uibModal.open({
                        templateUrl: "app/templates/modals/notifyModal.html",
                        controller: "NotifyModalController",
                        resolve: {
                            title: function () { return undefined; },
                            message: function () {
                                return response.limitErr !== undefined ? response.limitErr : "Невозможно сохранить заявку";
                            }
                        }
                    });
                } else {
                    if (status === "Отозвать") {
                        window.location.reload();
                        return;
                    }
                    $scope.goBack();
                }
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

        // валидация
        $scope.validations = {
            "sum": [
                {
                    errorMessage: "Поле 'Сумма' не заполнено",
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                        return val > 0 && val !== "";
                    }
                }
            ],
            "input": [
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
            "reciever": [
              {
                  validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                      var res = val.length > 0 || model.giftReciever !== undefined;
                      if (!res) {
                          element.focus();
                      }
                      return res;
                  }
              }
            ],
            "comment": [
               {
                   errorMessage: "Поле 'Коментарий' не заполнено",
                   validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                       var res = val.length > 0;
                       if ($scope.formData.otherGiftsExist) {
                           if (!res) {
                               element.focus();
                               return false;
                           }
                       }
                       return true;
                   }
               }
            ],
            "otherGiftsSum": [
               {
                   errorMessage: "Поле 'Сумма' не заполнено",
                   validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                       return val > 0 && val !== "";
                   }
               }
            ],
            "date": [
            {
                errorMessage: "Плановая дата вручения не может быть меньше текущей",
                validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                    if (!moment(val, "DD.MM.YYYY").isValid())
                        return false;
                    if (moment(val, "DD.MM.YYYY").startOf("day").isSame(moment($scope.formData.date).startOf("day")))
                        return true;
                    if (moment(val, "DD.MM.YYYY").isBefore(moment($scope.formData.date)))
                        return false;
                    return true;
                }
            }]
        };

        $scope.inputFocus = function (val) {
            if (val === 0) //==, вдруг будет 000000 !!!
                $scope.formData.sum = "";
        }

        $scope.inputBlur = function (val) {
            if (val === "")
                $scope.formData.sum = 0;
        }

        $scope.goBack = function () {
            $state.transitionTo($scope.prevState);
        }
    });