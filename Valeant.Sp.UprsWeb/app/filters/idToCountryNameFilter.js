angular.module("valeant.filters")
    .filter("idToCountryName", function() {
        return function (value, countries) {
            var name = undefined;
            angular.forEach(countries, function (country, i) {
                if (country.Id === value) {
                    name = country.Name;
                    return false;
                }
            });

            return name;
        };
    }); 