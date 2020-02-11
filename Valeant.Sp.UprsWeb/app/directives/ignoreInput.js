angular.module("valeant.directives")

 .directive("ignoreInput", [function () {
     return {
         restrict: "A",
         link: function(scope, elem, attrs) {
             angular.element(elem).on("keypress", function(e) {
                 e.preventDefault();
             });
         }
     }
 }]);