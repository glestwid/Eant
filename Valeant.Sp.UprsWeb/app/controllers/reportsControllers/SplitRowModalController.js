angular.module("valeant.controllers")

    .controller("SplitRowModalController", function ($scope, row, rowModelName, $uibModalInstance,toastr) {
        $scope.rowModelName = rowModelName;
        $scope.row = row;
        $scope.formData = {
            sum1: "0.00",
            sum2: "0.00",
            account1: undefined,
            account2: undefined
        }

        $scope.calcSum2 = function () {
            if ($scope.formData.sum1 === "")
                return row.sum;
            $scope.formData.sum2 = parseFloat(row.sum, 10) - parseFloat($scope.formData.sum1, 10);
            return $scope.formData.sum2;
        };

        $scope.ok = function () {
            var rows = [];
            $scope.$broadcast("runCustomValidations");
            if (!$scope.formSplit.$valid) {
                return false;
            }

            //if ($scope.rowModelName === "Командировочные расходы") {
                var copy1 = angular.copy(row);
                copy1.sum = $scope.formData.sum1;
                copy1.credit = $scope.formData.account1;

                var copy2 = angular.copy(row);
                copy2.sum = $scope.formData.sum2;
                copy2.credit = $scope.formData.account2;

                // Проверим, что сумма не изменилась
                if (parseFloat(copy1.sum, 10) > parseFloat(row.sum, 10)) {
                    toastr.warning("Новая сумма больше исходной!");
                    return false;
                }

                rows.push(copy1);
                rows.push(copy2);
            //}

            $uibModalInstance.close(rows);
        };

        $scope.cancel = function () {
            $uibModalInstance.dismiss("cancel");
        };

        $scope.inputFocus = function (val, isFirst) {
            if (val == 0) {
                if(isFirst)
                    $scope.formData.sum1 = "";
                else
                    $scope.formData.sum2 = "";
            }
        }

        $scope.inputBlur = function (val, isFirst) {
            if (val === "") {
                if(isFirst)
                    $scope.formData.sum1 = "0.00";
                else
                    $scope.formData.sum2 = "0.00";
                return false;
            }

            if (isFirst)
                $scope.formData.sum1 = parseFloat($scope.formData.sum1, 10).toFixed(2);
            else
                $scope.formData.sum2 = parseFloat($scope.formData.sum2, 10).toFixed(2);
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
            "account": [
                {
                    errorMessage: "Поле 'Счёт' не заполнено",
                    validator: function (errorMessageElement, val, attr, element, model, modelCtrl) {
                        return val.length > 0;
                    }
                }
            ]
        };
    });