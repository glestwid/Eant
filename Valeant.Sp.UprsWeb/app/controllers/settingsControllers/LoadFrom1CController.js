angular.module("valeant.controllers")

    .controller("LoadFrom1CController", function ($scope, $state, $stateParams, $http, toastr, $q, $timeout, $uibModal, $appConfig) {
        $scope.formData = {
            name: undefined,
            data: undefined
        };

        $scope.maxFilesSize = 10000000;
        $scope.currentFilesSize = 0;


        $scope.reload = function () {
            $http({
                method: "GET",
                url: "./loadFrom1C/getAll",
                cache: false
            }).success(function (response) {

            });
        }

        activate();

        function activate() {
            $scope.reload();
        }



        Array.prototype.remove = function (from, to) {
            var rest = this.slice((to || from) + 1 || this.length);
            this.length = from < 0 ? this.length + from : from;
            return this.push.apply(this, rest);
        };


        // Действия
        $scope.loadData = function () {
            if ($scope.selectedFile != undefined) {
                var reader = new FileReader();
                // If we use onloadend, we need to check the readyState.
                reader.onloadend = function (evt) {
                    if (evt.target.readyState === FileReader.DONE) { // DONE == 2

                        $scope.$apply(function () {
                            $scope.formData.name = $scope.selectedFile.name;
                            $scope.selectedFile = undefined;
                            $scope.formData.data = $scope._arrayBufferToBase64(evt.target.result);

                            $http({
                                method: "POST",
                                url: "./LoadFrom1C/loadData",
                                data: JSON.stringify($scope.formData)
                            }).success(function (response) {
                                $scope.data = response;

                                if ($scope.data.Success) {
                                    if ($appConfig.showSuccessToastr)
                                        toastr.success("Данные загружены");
                                }
                                else {
                                    if ($appConfig.showSuccessToastr)
                                        toastr.error($scope.data.Message);
                                }

                            }).error(function (error) {
                                toastr.error("Ошибка!");

                                throw error;
                            });

                        });
                    }
                };


                if (($scope.currentFilesSize + $scope.selectedFile.size) > $scope.maxFilesSize) {
                    $uibModal.open({
                        templateUrl: "app/templates/modals/notifyModal.html",
                        controller: "NotifyModalController",
                        resolve: {
                            title: function () {
                                return undefined;
                            },
                            message: function () {
                                return "Превышен максимальный объём файлов (10 мб)";
                            }
                        }
                    });
                    return false;
                } else {
                    $scope.currentFilesSize += $scope.selectedFile.size;
                }
                var blob = $scope.selectedFile.slice(0, $scope.selectedFile.size);
                reader.readAsArrayBuffer(blob);
            }
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

        $scope.goBack = function () {
            $state.transitionTo($state.params.prevState);
        }

    });