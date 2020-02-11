angular.module("valeant.filters")
   .filter("toFixed", function () {
       return function (input, digits) {
           var floatValue = parseFloat(input, 10);
           if (isNaN(floatValue))
               return input;

           return floatValue.toFixed(digits);
       };
   });