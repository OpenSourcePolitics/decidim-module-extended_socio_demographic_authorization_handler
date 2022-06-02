const codesPostaux = require('codes-postaux');

const setCityOption = ($element, city, selected = false) => {
    const selectedAttr = selected ? 'selected="selected"' : '';

    if ('libelleAcheminement' in city) {
        $element.append(`<option value="${city.libelleAcheminement}" ${selectedAttr}>${city.libelleAcheminement}</option>`);
    }
}

const setLocalStorage = (array) => {
    if (array.length > 0) {
        localStorage.setItem('cities', JSON.stringify(array));
    }
}

const clearLocalStorage = () => {
    localStorage.removeItem('cities');
}

const getCities = () => {
    return JSON.parse(localStorage.getItem('cities'));
}

const clearCities = ($element, enabled = true) => {
    $element.empty();

    if (!enabled) {
        $element.attr("disabled", "disabled");
    } else {
        $element.removeAttr("disabled")
    }
}

const setCities = ($element, cities) => {
    clearCities($element);

    if (cities.length === 1) {
        setCityOption($element, cities[0], true);
    } else {
        for (let i = 0; i < cities.length; i++) {
            setCityOption($element, cities[i]);
        }
    }
}

$("#authorization_handler_postal_code").on("input", (e) => {
    const $element = $(e.currentTarget);
    const value = $element.val();
    const $authorizationHandlerCity = $("#authorization_handler_city");

    if (value.length > 4) {
        let cities = codesPostaux.find(value);

        clearCities($authorizationHandlerCity);
        setLocalStorage(cities);

        setCities($authorizationHandlerCity, cities);
    } else {
        clearCities($authorizationHandlerCity, false);
        clearLocalStorage()
    }
})

$("#authorization_handler_postal_code").on("change", (e) => {
    const $element = $(e.currentTarget);
    const value = $element.val();
    const $authorizationHandlerCity = $("#authorization_handler_city");

    if (value.length < 5) {
        clearCities($authorizationHandlerCity, false);
    }
})


$(document).ready(() => {
    const $authorizationHandlerCity = $("#authorization_handler_city");

    if (getCities() !== null && getCities().length > 0) {
        setCities($authorizationHandlerCity, getCities());
        setTimeout(clearLocalStorage(), 200);
    }
});
