"use strict";

/**
 * @ngdoc module
 * @name ng-bootstrap-select.extra
 * @description
 * ng-bootstrap-select extra.
 */

angular.module("angular-bootstrap-select.extra", [])
  .directive("dropdownToggle", [dropdownToggleDirective])
  .directive("dropdownClose", [dropdownCloseDirective]);

/**
 * @ngdoc directive
 * @name dropdownToggle
 * @restrict ACE
 *
 * @description
 * This extra directive provide dropdown toggle specifically to bootstrap-select without loading bootstrap.js.
 *
 * @usage
 * ```html
 * <div class="dropdown-toggle">
 *   <select class="selectpicker">
 *      <option value="">Select one</option>
 *      <option>Mustard</option>
 *      <option>Ketchup</option>
 *      <option>Relish</option>
 *   </select>
 * </div>
 *
 * <div dropdown-toggle>
 *   <select class="selectpicker">
 *      <option value="">Select one</option>
 *      <option>Mustard</option>
 *      <option>Ketchup</option>
 *      <option>Relish</option>
 *   </select>
 * </div>
 *
 * <dropdown-toggle>
 *   <select class="selectpicker">
 *      <option value="">Select one</option>
 *      <option>Mustard</option>
 *      <option>Ketchup</option>
 *      <option>Relish</option>
 *   </select>
 * </dropdown-toggle>
 * ```
 */

function dropdownToggleDirective() {
    return {
        restrict: "ACE",
        priority: 101,
        link: function (scope, element, attrs) {
            var toggleFn = function (e) {
                var parent = angular.element(this).parent();

                angular.element(".bootstrap-select.open", element)
                  .not(parent)
                  .removeClass("open");

                parent.toggleClass("open");
            };

            element.on("click.bootstrapSelect", ".dropdown-toggle", toggleFn);

            scope.$on("$destroy", function () {
                element.off(".bootstrapSelect");
            });
        }
    };
}

/**
 * @ngdoc directive
 * @name dropdownClear
 * @restrict ACE
 *
 * @description
 * This extra directive provide the closing of ALL open dropdowns clicking away
 *
 * @usage
 * ```html
 * <div class="dropdown-close">
 *   <select class="selectpicker">
 *      <option value="">Select one</option>
 *      <option>Mustard</option>
 *      <option>Ketchup</option>
 *      <option>Relish</option>
 *   </select>
 * </div>
 *
 * <div dropdown-close>
 *   <select class="selectpicker">
 *      <option value="">Select one</option>
 *      <option>Mustard</option>
 *      <option>Ketchup</option>
 *      <option>Relish</option>
 *   </select>
 * </div>
 *
 * <dropdown-close>
 *   <select class="selectpicker">
 *      <option value="">Select one</option>
 *      <option>Mustard</option>
 *      <option>Ketchup</option>
 *      <option>Relish</option>
 *   </select>
 * </dropdown-close>
 * ```
 */

function dropdownCloseDirective() {
    return {
        restrict: "ACE",
        priority: 101,
        link: function (scope, element, attrs) {
            var hideFn = function (e) {
                var parent = e.target.tagName !== "A" && angular.element(e.target).parents(".bootstrap-select");

                angular.element(".bootstrap-select.open", element)
                  .not(parent)
                  .removeClass("open");
            };

            angular.element(document).on("click.bootstrapSelect", hideFn);

            scope.$on("$destroy", function () {
                angular.element(document).off(".bootstrapSelect");
            });
        }
    };
}

/**
 * @ngdoc module
 * @name ng-bootstrap-select
 * @description
 * ng-bootstrap-select.
 */

angular.module("angular-bootstrap-select", [])
  .directive("selectpicker", ["$parse", "$timeout", selectpickerDirective]);

/**
 * @ngdoc directive
 * @name selectpicker
 * @restrict A
 *
 * @param {object} selectpicker Directive attribute to configure bootstrap-select, full configurable params can be found in [bootstrap-select docs](http://silviomoreto.github.io/bootstrap-select/).
 * @param {string} ngModel Assignable angular expression to data-bind to.
 *
 * @description
 * The selectpicker directive is used to wrap bootstrap-select.
 *
 * @usage
 * ```html
 * <select selectpicker ng-model="model">
 *   <option value="">Select one</option>
 *   <option>Mustard</option>
 *   <option>Ketchup</option>
 *   <option>Relish</option>
 * </select>
 *
 * <select selectpicker="{dropupAuto:false}" ng-model="model">
 *   <option value="">Select one</option>
 *   <option>Mustard</option>
 *   <option>Ketchup</option>
 *   <option>Relish</option>
 * </select>
 * ```
 */

function selectpickerDirective($parse, $timeout) {
    return {
        restrict: "A",
        priority: 1000,
        require: "ngModel",
        link: function (scope, element, attrs, ctrl) {
            var pattern = /ng-[^\s]+/g;

            function refresh() {
                scope.$applyAsync(function () {
                    element.selectpicker("refresh");

                    element.data("selectpicker").$newElement.removeClass(function (i, c) {
                        return (c.match(pattern) || []).join(" ");
                    });
                });
            }

            element.selectpicker($parse(attrs.selectpicker)());

            scope.$watch(function () {
                if (element.data("selectpicker") == undefined)
                    return false;
                return element.data("selectpicker").$element.attr("class");
            }, function (newVal) {
                if (newVal === false)
                    return;

                var classes = (newVal.match(pattern) || []).join(" ");
                element.data("selectpicker").$button.removeClass(function (i, c) {
                    return (c.match(pattern) || []).join(" ");
                });

                element.data("selectpicker").$button.addClass(classes);
            }, true);

            scope.$watch(attrs.ngModel, function (newVal) {
                if (/track by/.test(attrs.ngOptions)) {
                    var trackBy = attrs.ngOptions.substr(attrs.ngOptions.indexOf("track by"));
                    trackBy = trackBy.substring(trackBy.indexOf(".") + 1);
                    if (newVal != undefined)
                        element.val(newVal[trackBy]);
                } else {
                    element.val(newVal);
                }

                refresh();
            }, true);

            element.bind("change", function (e) {
                scope.$apply(function () {
                    refresh();
                });
            });

            if (attrs.ngOptions && / in /.test(attrs.ngOptions)) {
                scope.$watch(attrs.ngOptions.replace("::", "").split(" in ")[1].split(" ")[0], refresh, true);
            }

            if (attrs.ngDisabled) {
                scope.$watch(attrs.ngDisabled, refresh, true);
            }

            scope.$on("$destroy", function () {
                $timeout(function () {
                    element.selectpicker("destroy");
                });
            });
        }
    };
}