const codesPostaux = require('codes-postaux');

// Appends cities found in the select field as HTML option field
const setCityOption = ($element, city, selected = false) => {
    const selectedAttr = selected ? 'selected="selected"' : '';

    if ('libelleAcheminement' in city) {
        $element.append(`<option value="${city.libelleAcheminement}" ${selectedAttr}>${city.libelleAcheminement}</option>`);
    }
}

// Store the cities found in local storage
// Allows to keep the given list if postal code is filled and an error happen on the form
const setLocalStorage = (array) => {
    if (array.length > 0) {
        localStorage.setItem('cities', JSON.stringify(array));
    }
}

// Clear the cities of the local storage
const clearLocalStorage = () => {
    localStorage.removeItem('cities');
}

// Fetch cities from local storage
const getCities = () => {
    return JSON.parse(localStorage.getItem('cities'));
}

// Remove items from city select field
// Enabled : Optional - Allows to disable or not the select HTML tag
const clearCities = ($element, enabled = true) => {
    $element.empty();

    if (!enabled) {
        $element.attr("disabled", "disabled");
    } else {
        $element.removeAttr("disabled")
    }
}

// Create cities HTML options in select field
// It clears the previous list before
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

// For each input on the postal code field, it looks for the corresponding city for the given postal code
// While the postal code length is under 5, it clears the select field
// Otherwise it stores the cities found in local storage and append to select field
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

// Clears the cities list when postal code changes and is under 5 chars
$("#authorization_handler_postal_code").on("change", (e) => {
    const $element = $(e.currentTarget);
    const value = $element.val();
    const $authorizationHandlerCity = $("#authorization_handler_city");

    if (value.length < 5) {
        clearCities($authorizationHandlerCity, false);
    }
})

// On page loading, set the cities list in select field if it is already set in local storage
// If local storage contains the cities, it clears the local storage after appending to the list
$(document).ready(() => {
    const $authorizationHandlerCity = $("#authorization_handler_city");

    if (getCities() !== null && getCities().length > 0) {
        setCities($authorizationHandlerCity, getCities());
        setTimeout(clearLocalStorage(), 200);
    }
});
