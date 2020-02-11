angular.module("valeant.filters")
    .filter("idToCityName", function () {
        return function (value, cities) {
            var name = undefined;
            angular.forEach(cities, function (city, i) {
                if (city.Id === value) {
                    name = city.Name;
                    return false;
                }
            });

            return name;
        };
    }); 