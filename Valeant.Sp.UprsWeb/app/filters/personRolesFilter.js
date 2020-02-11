angular.module("valeant.filters")
    .filter("personRolesFilter", function() {
        return function (value) {
            var result = [];
            $.each(value, function(i, role) {
                result.push(role.Name);
            });

            return result.join(", ");
        };
    }); 