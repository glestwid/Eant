angular.module("valeant.controllers")

    .controller("ThirdPartyController", function ($scope, $uibModalInstance, row, index, toastr, $uibModal) {
        $scope.row = row;
        $scope.formData = {
            index: index,
            date: moment(new Date()).format(),
            city: undefined,
            address: undefined,
            organization: undefined,
            occasionType: undefined,
            sum: 0,
            representatives: 1,
            representativesPosition: undefined,
            theme: undefined,
            employeeParticipats: undefined,
            averageSum: function() {
                if (this.representatives !== 0) {
                    return (this.sum / this.representatives).toFixed(2);
                }
                return "";
            }
        }

        $scope.inputFocus = function (val) {
            if (val == 0) //==, вдруг будет 000000 !!!
                $scope.formData.sum = "";
        }

        $scope.inputBlur = function (val) {
            if (val === "")
                $scope.formData.sum = 0;
        }

        $scope.thirdPartyData = {
            occasionTypes: [
                { id: 1, Name: "Фармкружок" }, { id: 2, Name: "Презентация" }, { id: 3, Name: "Круглый стол" }, { id: 4, Name: "Школа провизора" }
            ] // в справочники ?
        }

        activate();

        function activate() {
            if ($scope.row != null) {
                $scope.formData = row;
            }
        }

        $scope.ok = function () {

            $scope.$broadcast("runCustomValidations");
            if (!$scope.formThirdParty.$valid) {
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