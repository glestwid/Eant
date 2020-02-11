angular.module("valeant.directives")

.directive("modelToFixed", function () {
    return {
        require: "ngModel",
        link: function (scope, element, attrs, ngModelController) {
            ngModelController.$parsers.push(function (data) {
                //convert data from view format to model format
                return data; //converted
            });

            ngModelController.$formatters.push(function (data) {
                //convert data from model format to view format
                var floatValue = parseFloat(data, 10);
                if (isNaN(floatValue))
                    return data;

                return floatValue.toFixed(attrs.modelToFixed); //converted
            });
        }
    }
});