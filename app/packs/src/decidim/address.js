const codesPostaux = require('codes-postaux');

const setCityOption = ($element, city, selected = false) => {
    const selectedAttr = selected ? 'selected="selected"' : '';

    if ('libelleAcheminement' in city) {
        $element.append(`<option value="${city.libelleAcheminement}" ${selectedAttr}>${city.libelleAcheminement}</option>`);
    }
}

$("#authorization_handler_postal_code").on("input", (e) => {
    const $element = $(e.currentTarget);
    const value = $element.val();
    const $authorizationHandlerCity = $("#authorization_handler_city");

    if (value.length > 4) {
        let cities = codesPostaux.find(value);

        $authorizationHandlerCity.empty();

        if (cities.length === 1) {
            setCityOption($authorizationHandlerCity, cities[0], true);
        } else {
            for (let i = 0; i < cities.length; i++) {
                setCityOption($authorizationHandlerCity, cities[i]);
            }
        }
    }
})
