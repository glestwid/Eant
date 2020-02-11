angular.module("valeant.controllers")

    .controller("EditCostItemController", function ($scope, $uibModalInstance, $http, row, $uibModal) {
        $scope.row = row;

        $scope.accountGroups = null;
        $scope.roles = null;

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

        $scope.process = function (action) {
            $http({
                method: "POST",
                url: "./costItems/" + action,
                data: JSON.stringify($scope.row)
            }).success(function (response) {
                $uibModalInstance.close($scope.row);
            }).error(function (error) {
                throw error;
            });
        }

        $scope.cancel = function () {
            $uibModalInstance.dismiss("cancel");
        };

        $scope.changeDocumentBelonging = function (type) {
            var index = $scope.row.Documents.indexOf(type);
            if (index > -1) {
                $scope.row.Documents.splice(index, 1);
            } else {
                $scope.row.Documents.push(type);
            }
        }

        $scope.validations = {
            "required": [
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
            $http({
                method: "GET",
                url: "./accountGroups/getAll",
                cache: false
            }).success(function (response) {
                $scope.accountGroups = response;
            }).error(function (error) {
                throw error;
            });

            $http({
                method: "GET",
                url: "./security/getRoles",
                cache: false
            }).success(function (response) {
                $scope.roles = response;
            }).error(function (error) {
                throw error;
            });

            if ($scope.row.IsNew) {
                $scope.row.Documents = [];
                $scope.row.Limits = [
                    { PositionGroup: 1, Limit: 0 },
                    { PositionGroup: 2, Limit: 0 },
                    { PositionGroup: 3, Limit: 0 },
                    { PositionGroup: 4, Limit: 0 },
                    { PositionGroup: 5, Limit: 0 },
                    { PositionGroup: 6, Limit: 0 },
                    { PositionGroup: 7, Limit: 0 },
                    { PositionGroup: 8, Limit: 0 }
                ];
            }

            $scope.documentCheckboxes = {
                prepayment: $scope.row.Documents.filter(function (el) {return el === 1}).length > 0,
                trip: $scope.row.Documents.filter(function (el) {return el === 4}).length > 0,
                representative: $scope.row.Documents.filter(function (el) { return el === 5 }).length > 0
            };
        }      
});