angular.module("valeant.filters")
   .filter("applyFunction", function () {
       return function (data, func) {
           return func(data);
       };
   });