angular.module("valeant.controllers")

    .controller("ReesterController", function ($scope, $http, $state, $stateParams) {
        $scope.reesterName = $stateParams.reesterName;
        $scope.selectedDateRangeCriteria = "Месяц";
        $scope.Title = "";

       
        if ($scope.reesterName == "travelLists")
            $scope.Title ="Маршрутные листы";

        if ($scope.reesterName == "overspents")
            $scope.Title = "Перерасходы топлива";

        if ($scope.reesterName == "giftRequests")
            $scope.Title = "Заявки на подарок";


        $scope.getReester = function () {

            console.log("getreester");
            console.log($scope.reesterName);

            if ($scope.reesterName == "travelLists")
                window.location.href = "TravelLists/export?dateRangeFilter=" + $scope.selectedDateRangeCriteria + "&rand=" + Math.random();

            if ($scope.reesterName == "overspents")
                window.location.href = "TravelLists/exportOverspents?dateRangeFilter=" + $scope.selectedDateRangeCriteria + "&rand=" + Math.random();

            if ($scope.reesterName == "giftRequests")
                window.location.href = "GiftRequests/export?dateRangeFilter=" + $scope.selectedDateRangeCriteria + "&rand=" + Math.random();
        }

        activate();

        function activate() {
          //  $scope.reload();

           
        }

    });