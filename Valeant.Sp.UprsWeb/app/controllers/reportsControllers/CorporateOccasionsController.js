angular.module("valeant.controllers")

    .controller("CorporateOccasionsController", function ($scope, $uibModalInstance, row, index, toastr, $http, $q, $uibModal, $appConfig) {
        $scope.row = row;
        $scope.formData = {
            index: index,
            date: moment(new Date()).format(),
            place: undefined,
            aim: undefined,
            sum: 0,
            participants: { rows: [] },
            count: 0,
            average : 0
        }

        $scope.persons = [];

        Array.prototype.remove = function (from, to) {
            var rest = this.slice((to || from) + 1 || this.length);
            this.length = from < 0 ? this.length + from : from;
            return this.push.apply(this, rest);
        };
        $scope.addParticipant = function() {
            var p = { index: $scope.formData.participants.rows.length + 1, person: undefined }
            $scope.formData.participants.rows.push(p);
            $scope.averageCost();
        }

        $scope.removeParticipant = function() {
            $scope.formData.participants.rows.remove(this.$index);
            $scope.averageCost();
        }

        $scope.averageCost = function () {
            var participantsCount = $scope.countParticipants();
            $scope.formData.average =
                ($scope.formData.sum / (participantsCount === 0 ? 1 : participantsCount)).toFixed(2);
        }

        $scope.inputFocus = function (val) {
            if (val == 0) //==, вдруг будет 000000 !!!
                $scope.formData.sum = "";
        }

        $scope.inputBlur = function (val) {
            if (val === "")
                $scope.formData.sum = 0;
        }

        $scope.countParticipants = function() {
            return $scope.formData.participants.rows.filter(function(p) { return p.person !== undefined; }).length;
        }

        activate();

        function activate() {
            if($scope.row != null) {
                $scope.formData = row;
            }

            var personsRequest = $http({
                method: "GET",
                url: "./security/getHumans",
                cache: false
            }).success(function (response) {
                $scope.persons = response;
            }).error(function (error) {
                throw error;
            });

            $q.all([personsRequest]).then(function (responses) {
                if ($appConfig.showSuccessToastr)
                    toastr.success("Данные загружены");
            });
        }

        $scope.ok = function () {

            $scope.$broadcast("runCustomValidations");
            var participantsExist = $scope.countParticipants() === 0;
            if (!$scope.formCorporate.$valid || participantsExist) {
                $uibModal.open({
                    templateUrl: "app/templates/modals/notifyModal.html",
                    controller: "NotifyModalController",
                    resolve: {
                        title: function () {
                            return "Ошибки при валидации формы";
                        },
                        message: function () {
                            var errorMsg = "Заполните обязательные поля!";
                            if (participantsExist)
                                errorMsg += "</br>" + "Не выбрано ни одного участника!";
                            return errorMsg;
                        }
                    }
                });

                return false;
            }

            var row = $scope.formData;
            row.participants.rows = row.participants.rows.filter(function(p) { return p.person !== undefined });
            row.count = row.participants.rows.length;
            $uibModalInstance.close(row);
        }

        $scope.cancel = function () {
            $uibModalInstance.dismiss("cancel");
        };

        //Filter to prevent double selection of one person.
        $scope.filteredPersons = function (own) {
            var knownIds = $scope.formData.participants.rows
                .filter(function (row) {
                    return row.person != undefined && row.person !== own;
                })
                .map(function (row) {
                    return row.person.Id;
                });

            var result = $scope.persons.filter(function (el) {
                return !knownIds.includes(el.Id);
            });

            return result;
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