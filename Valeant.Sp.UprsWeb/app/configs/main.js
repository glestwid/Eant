angular.module("valeant.controllers", []);
angular.module("valeant.services", []);
angular.module("valeant.directives", []);
angular.module("valeant.filters", []);

angular.module("valeant.app",
    [
        "valeant.controllers",
        "valeant.services",
        "valeant.directives",
        "valeant.filters",
        "ui.router",
        "oi.select",
        "ngPatternRestrict",
        "daterangepicker",
        "angularMoment",
        "ui.checkbox",
        "ui.radio",
        "ui.mask",
        "angular-bootstrap-select",
        "ngSanitize",
        "ui.grid",
        "ui.grid.pagination",
        "ui.grid.autoResize",
        "ui.bootstrap.dropdown",
        "angular-loading-bar",
        "ngAnimate",
        "toastr",
        "ui.bootstrap",
        "directives.customvalidation.customValidationTypes",
        "ui.bootstrap.typeahead"
    ])
    .run(function() {
    });