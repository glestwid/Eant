angular.module("valeant.controllers")

    .controller("IndexController", function ($scope, $http, $state) {
        $scope.$on("cfpLoadingBar:loading", function (event, data) {
            console.log("loading"); // 'Data to send'
            $.blockUI({ message: "<div class='splash'><h4 class='message'>Данные загружаются...</h4><i class='fa fa-spinner fa-pulse fa-2x'></i></div>" });
        });

        $scope.$on("cfpLoadingBar:completed", function (event, data) {
            console.log("completed"); // 'Data to send'
            $.unblockUI();
        });

        $scope.$on("$stateChangeStart", function (event, toState, toParams, fromState, fromParams) {            
            if (fromParams.skipSomeAsync) {
               return false;
            }            
            fromParams.skipSomeAsync = true;
            event.preventDefault();            

            activate().finally(function() {
               if (toState.auth) {
                   var result = $scope.canShowForRole(toState.auth);
                   if (result === false) {
                       $state.go("home");
                   }
                   else
                       $state.go(toState.name, toParams);
               }
               else
                   $state.go(toState.name, toParams);
           });
        });

        $scope.getPersonRoles = function() {
            if ($scope.currentUser != undefined) {
                var roles = $scope.currentUser.Roles.map(function (r) { return r.Id }).join();
                return roles;
            }
            return undefined;
        }

        $scope.checkShow = function(routeName) {
            var targetRoute = $state.get()
                .filter(function(x) {
                    return x.name === routeName;
                })[0];
            if (targetRoute.auth) {
                var can = $scope.canShowForRole(targetRoute.auth);
                return can;
            }
            return true;
        }

        $scope.canShowForRole = function (userRole) {
            var roles = $scope.getPersonRoles();
            if (roles == undefined)
                return undefined;

            switch (userRole) {
                case "тк":
                    return roles.indexOf(4) !== -1; // тр.координатор
                case "стбух":
                    return roles.indexOf(6) !== -1; // старший бухгалтер
                case "ка":
                    return roles.indexOf(8) !== -1; // координатор автопарка
                case "бух":
                    return roles.indexOf(5) !== -1; // бухгалтер
                default:
                    return true;
            }
        };

        function activate() {
            return $http({
                method: "GET",
                url: "./security/getCurrent",
                cache: false
            }).success(function (response) {
                $scope.currentUser = response;
                console.log($scope.getPersonRoles());
                sessionStorage.setItem("currentUser", JSON.stringify($scope.currentUser));
            }).error(function (error) {
                throw error;
            });
        }
    });