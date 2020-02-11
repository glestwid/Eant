angular.module("valeant.controllers")
    .controller("GiftModalController", function($http, $scope, $uibModalInstance, row, index, toastr, $q, $uibModal) {
        $scope.row = row;
        $scope.formData = {
            index: index,
            giftRequest: undefined,
            date: moment(new Date()).format(),
            description: undefined,
            reason: undefined,
            sum: 0,
            giftReciever: undefined,
            fio : function() {
                return this.giftReciever.SecondName + " " + this.giftReciever.Name + " " + this.giftReciever.MiddleName;
            }
        }

        $scope.giftModalData = undefined;
        $scope.giftRequests = []; // список заявок
        $scope.gifts = []; // подарки за последние 12 месяцев


        $scope.inputFocus = function (val) {
            if (val == 0) //==, вдруг будет 000000 !!!
                $scope.formData.sum = "";
        }

        $scope.inputBlur = function (val) {
            if (val === "")
                $scope.formData.sum = 0;
        }

        $scope.getRecievers = function () {
           return $http({
                method: "GET",
                url: "./giftRecievers/getAll"
            }).success(function (response) {
                $scope.giftModalData = response;
            }).error(function (error) {
                toastr.error("Ошибка!");
                throw error;
            });
        }

        $scope.getGiftRequests = function () {
            return $http({
                method: "GET",
                url: "./giftRequests/getAll?statusFilter=Все" + "&dateRangeFilter=Год",
                cache: false
            }).success(function (response) {
                $scope.giftRequests = response;
            }).error(function (error) {
                toastr.error("Ошибка!");
                throw error;
            });
        }

        $scope.reload = function () {
            $scope.getRecievers();
            $scope.getGiftRequests();
        }

        $scope.updateGiftForm = function(gift) {
            if (gift) {
                $http({
                    method: "GET",
                    url: "./giftRequests/get?id=" + gift.Id,
                    cache: false
                }).success(function (giftRequest) {
                    console.log(giftRequest);
                    $scope.formData.reason = giftRequest.reason;
                    $scope.formData.description = giftRequest.description;
                    $scope.formData.sum = giftRequest.sum;
                    $scope.formData.giftReciever = giftRequest.giftReciever;
                    $scope.formData.date = giftRequest.giftDate;
                    $scope.gifts = giftRequest.giftReciever.PreviousGifts;

                }).error(function (error) {
                    toastr.error("Ошибка!");
                    throw error;
                });
            }
        }

        activate();

        function activate() {
            if ($scope.row != null) {
                $scope.formData = row;
                $scope.updateGiftForm($scope.formData.giftRequest);
            }

            $scope.reload();
        }

        $scope.addGiftReciever = function() {
            $uibModal.open({
                templateUrl: "app/templates/settings/modals/editGiftRecieverModal.html",
                controller: "EditGiftRecieverController",
                resolve: {
                    row: function () {
                        return { IsNew: true };
                    }
                }
            }).result.then(function (result) {
                var recievers = $scope.getRecievers();
                $q.all([recievers])
                    .then(function(responses) {
                        if (result.IsNew) {
                            var newGiftReciever = $scope.giftModalData.filter(function(gr) {
                                if (gr.Name === result.Name && gr.SecondName === result.SecondName ||
                                    gr.MiddleName === result.MiddleName ||
                                    gr.AgreementNumber === result.AgreementNumber ||
                                    gr.Position === result.Position ||
                                    gr.Organization === result.Organization)
                                    return true;
                            })[0];
                            $scope.formData.giftReciever = newGiftReciever;
                        }
                    });

            });
        }

        $scope.ok = function () {
            $scope.$broadcast("runCustomValidations");
            if (!$scope.formGift.$valid) {
                $uibModal.open({
                    templateUrl: "app/templates/modals/notifyModal.html",
                    controller: "NotifyModalController",
                    resolve: {
                        title: function () {
                            return "Ошибки при валидации формы";
                        },
                        message: function () {
                            return "Заполните обязательные поля!";
                        }
                    }
                });

                return false;
            }

            var row = $scope.formData;
            $uibModalInstance.close(row);
        }

        $scope.cancel = function () {
            $uibModalInstance.dismiss("cancel");
        };

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
            "name": [
                {
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                        var res = val.length > 0;
                        if (!res) {
                            element.focus();
                        }
                        return res;
                    }
                }
            ]
        };
});