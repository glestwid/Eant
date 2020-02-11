(function () {
    var picker = angular.module("daterangepicker", []);

    picker.provider("dateRangePickerOptions", function () {
        var defaultOptions = {
            clearLabel: "Clear",
            locale: {
                separator: " - ",
                format: "DD.MM.YYYY"
            }
        };
        var defaultOptionsFunc = function (options) {
            return defaultOptions = options;
        };
        this.setDefaultOptions = function (options) {
            defaultOptions = options;
        };
        this.$get = [
          function () {
              return defaultOptionsFunc(defaultOptions);
          }
        ];
        return this;
    });

    picker.directive("dateRangePicker", function ($compile, $timeout, $parse, dateRangePickerOptions) {
        return {
            require: "ngModel",
            restrict: "A",
            scope: {
                min: "=",
                max: "=",
                model: "=ngModel",
                opts: "=options",
                clearable: "="
            },
            link: function ($scope, element, attrs, modelCtrl) {
                var _clear, _format, _init, _initBoundaryField, _mergeOpts, _picker, _setDatePoint, _setEndDate, _setStartDate, _setViewValue, _validate, _validateMax, _validateMin, customOpts, defaultOpts, el, opts;
                _mergeOpts = function () {
                    var localeExtend = angular.extend.apply(angular, Array.prototype.slice.call(arguments).map(function (opt) {
                        return opt != null ? opt.locale : void 0;
                    }).filter(function (opt) {
                        return !!opt;
                    }));
                    var extend = angular.extend.apply(angular, arguments);
                    extend.locale = localeExtend;
                    return extend;
                };
                el = $(element);
                customOpts = $scope.opts;
                defaultOpts = angular.copy(dateRangePickerOptions);
                opts = (customOpts != null ? customOpts.locale : void 0) != null ? _mergeOpts({}, defaultOpts, customOpts) : _mergeOpts({}, dateRangePickerOptions, customOpts);
                _picker = null;
                _clear = function () {
                    _picker.setStartDate();
                    return _picker.setEndDate();
                };
                _setDatePoint = function (setter) {
                    return function (newValue) {
                        if (_picker && newValue) {
                            return setter(moment(newValue));
                        }
                    };
                };
                _setStartDate = _setDatePoint(function (m) {
                    if (_picker.endDate < m) {
                        _picker.setEndDate(m);
                    }
                    opts.startDate = m;
                    return _picker.setStartDate(m);
                });
                _setEndDate = _setDatePoint(function (m) {
                    if (_picker.startDate > m) {
                        _picker.setStartDate(m);
                    }
                    opts.endDate = m;
                    return _picker.setEndDate(m);
                });
                _format = function (objValue) {
                    var f = function (date) {
                        if (!moment.isMoment(date)) {
                            return moment(date).format(opts.locale.format);
                        } else {
                            return date.format(opts.locale.format);
                        }
                    };
                    if (objValue) {
                        if (opts.singleDatePicker) {
                            return f(objValue);
                        } else {
                            return [f(objValue.startDate), f(objValue.endDate)].join(opts.locale.separator);
                        }
                    } else {
                        return "";
                    }
                };

                _setViewValue = function (objValue) {
                    var value;
                    if (!objValue || objValue.hasOwnProperty("startDate") && objValue.startDate === null || objValue.hasOwnProperty("endDate") && objValue.endDate === null) {
                        value = null;
                    } else {
                        value = _format(objValue);
                    }
                    el.val(value);
                    return modelCtrl.$setViewValue(objValue);
                };
                _validate = function (validator) {
                    return function (boundary, actual) {
                        if (boundary && actual) {
                            return validator(moment(boundary), moment(actual));
                        } else {
                            return true;
                        }
                    };
                };
                _validateMin = _validate(function (min, start) {
                    return min.isBefore(start) || min.isSame(start, "day");
                });
                _validateMax = _validate(function (max, end) {
                    return max.isAfter(end) || max.isSame(end, "day");
                });
                modelCtrl.$formatters.push(_format);
                modelCtrl.$render = function () {
                    if (modelCtrl.$modelValue && modelCtrl.$modelValue.startDate) {
                        _setStartDate(modelCtrl.$modelValue.startDate);
                        _setEndDate(modelCtrl.$modelValue.endDate);
                    } else {
                        _clear();
                    }
                    return el.val(modelCtrl.$viewValue);
                }
                modelCtrl.$parsers.push(function (val) {
                    if (!moment(val, opts.locale.format, true).isValid()) {
                        return val;
                    }

                    var objValue, x;
                    var f = function (value) {
                        return moment(value, opts.locale.format, true).format(/*opts.locale.format*/);
                    };
                    objValue = {
                        startDate: null,
                        endDate: null
                    };
                    if (angular.isString(val) && val.length > 0) {
                        if (opts.singleDatePicker) {
                            objValue = f(val);
                        } else {
                            x = val.split(opts.locale.separator).map(f);
                            objValue.startDate = x[0];
                            objValue.endDate = x[1];
                        }
                    }
                    return objValue;
                });
                modelCtrl.$isEmpty = function (val) {
                    return !(angular.isString(val) && val.length > 0);
                };
                _init = function () {
                    var eventType;
                    el.daterangepicker(angular.extend(opts, {
                        autoUpdateInput: false
                    }), function (start, end) {
                        return _setViewValue(opts.singleDatePicker ? start.format() : {
                            startDate: start.format(),
                            endDate: end.format()
                        });
                    });
                    _picker = el.data("daterangepicker");

                    el.on("apply.daterangepicker", function (ev, picker) {
                        return _setViewValue(opts.singleDatePicker ? picker.startDate.format() : {
                            startDate: picker.startDate.format(),
                            endDate: picker.endDate.format()
                        });
                    });

                    var results = [];
                    for (eventType in opts.eventHandlers) {
                        results.push(el.on(eventType, function (e) {
                            var eventName = e.type + "." + e.namespace;
                            return $scope.$evalAsync(opts.eventHandlers[eventName]);
                        }));
                    }
                    return results;
                };
                _init();


                $scope.$watch("model", function (n) {
                    if (!moment(n, opts.locale.format, true).isValid() && !moment(n, moment.defaultFormat, true).isValid()) {
                        return false;
                    }

                    if (!n.startDate && !n.endDate) {
                        _setStartDate(n);
                        _setEndDate(n);
                        return _setViewValue($scope.model);
                    }
                });
                $scope.$watch("model.startDate", function (n) {
                    _setStartDate(n);
                    return _setViewValue($scope.model);
                });
                $scope.$watch("model.endDate", function (n) {
                    _setEndDate(n);
                    return _setViewValue($scope.model);
                });
                _initBoundaryField = function (field, validator, modelField, optName) {
                    if (attrs[field]) {
                        modelCtrl.$validators[field] = function (value) {
                            return value && validator(opts[optName], value[modelField]);
                        };
                        return $scope.$watch(field, function (date) {
                            opts[optName] = date ? moment(date) : false;
                            return _init();
                        });
                    }
                };
                _initBoundaryField("min", _validateMin, "startDate", "minDate");
                _initBoundaryField("max", _validateMax, "endDate", "maxDate");
                if (attrs.options) {
                    $scope.$watch("opts", function (newOpts) {
                        opts = _mergeOpts(opts, newOpts);
                        return _init();
                    }, true);
                }
                if (attrs.clearable) {
                    $scope.$watch("clearable", function (newClearable) {
                        if (newClearable) {
                            opts = _mergeOpts(opts, {
                                locale: {
                                    cancelLabel: opts.clearLabel
                                }
                            });
                        }
                        _init();
                        if (newClearable) {
                            return el.on("cancel.daterangepicker", _setViewValue.bind(this, opts.singleDatePicker ? null : {
                                startDate: null,
                                endDate: null
                            }));
                        }
                    });
                }
                return $scope.$on("$destroy", function () {
                    return _picker != null ? _picker.remove() : void 0;
                });
            }
        };
    });

}).call(this);
