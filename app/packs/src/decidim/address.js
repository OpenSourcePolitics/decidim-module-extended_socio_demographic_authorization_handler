const codesPostaux = require('codes-postaux');

$("#authorization_handler_postal_code").on("input", (e) => {
    const $element = $(e.currentTarget);
    const value = $element.val();

    if (value.length > 4) {
        var cities = codesPostaux.find(value);

        for (var i = 0; i < cities.length; i++) {
            $("#authorization_handler_city").append(`<option value="${cities[i].libelleAcheminement}">${cities[i].libelleAcheminement}</option>`)
        }
    }
})
