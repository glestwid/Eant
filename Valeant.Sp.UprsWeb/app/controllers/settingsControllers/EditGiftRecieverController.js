angular.module("valeant.controllers")

    .controller("EditGiftRecieverController", function ($scope, $uibModalInstance, $http, row, $uibModal) {
        $scope.row = row;

        $scope.ok = function () {
            $scope.$broadcast("runCustomValidations");
            if (!$scope.form.$valid) {
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
            if ($scope.row.IsNew)
                $scope.process("create");
            else
                $scope.process("update");
        };

        $scope.getRecievers = function(action) {
            $http({
                method: "POST",
                url: "./giftRecievers/" + action,
                data: JSON.stringify($scope.row)
            }).success(function (response) {
                $uibModalInstance.close($scope.row);
            }).error(function (error) {
                throw error;
            });
        }

        $scope.process = function (action) {
            $scope.getRecievers(action);
        }

        $scope.cancel = function () {
            $uibModalInstance.dismiss("cancel");
        };

        $scope.validations = {
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
       
        activate();

        function activate() {
           // $scope.$broadcast("runCustomValidations");
        }       
});