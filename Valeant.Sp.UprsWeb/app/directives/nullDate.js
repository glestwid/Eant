angular.module("valeant.directives")
.directive("fixNullDatepicker", function($timeout) {
    return {
        restrict: "A",
        link: function(scope, element, attr){
            var $element  = $(element);
            $element.data().daterangepicker.oldEndDate = null;
            $element.data().daterangepicker.oldStartDate = null;

            $element.on("show.daterangepicker", function (ev, picker) {
                var l = $element.val().trim().length;

                if (l < 1) {
                    $(document).find(".daterangepicker .ranges li").removeClass("active");

                    $element.data().daterangepicker.oldEndDate = null;
                    $element.data().daterangepicker.oldStartDate = null;
                }
            });
        }
    }
})