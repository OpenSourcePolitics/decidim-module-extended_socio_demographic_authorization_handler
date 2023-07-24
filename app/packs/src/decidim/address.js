class AhApi {
    constructor() {
        this.records = [];
    }

    citiesFor(postalCode) {
        this.records = this.fetchCities(postalCode);
        return this.records;
    }

    // returns cities for a given postal code
    fetchCities(postalCode) {
        let results =[];

        let response = this.fetchFromApi(postalCode).responseJSON;
        for (let i = 0; i < response.length; i++) {
            for (let key in response[i]) {
                results.push(response[i][key]);
            }
        }
        return results;
    }

    // Fetch cities for a given postal code against defined Api
    fetchFromApi(postalCode) {
        return $.ajax({async: false, crossDomain: true, url: this.builtApiUrl(postalCode), method: "GET", headers: {
            "accept": "application/json",
            }}).done((data) => {
                return data.records;
        });
    }

    // returns the API Url for the given postal code
    builtApiUrl(postalCode) {
        return `/postal-code-autocomplete/${postalCode}`
    }
}

// Manipulates AH HTML Form in DOM
class AhFormHTML {
    constructor($citiesSelectElement) {
        this.$citiesSelectElement = $citiesSelectElement;
    }


// Create cities HTML options in select field
// It clears the previous list before
    setCities(cities) {
        this.clearCities();

        if (cities.length === 1) {
            this.setCityOption(cities[0], true);
        } else {
            for (let i = 0; i < cities.length; i++) {
                this.setCityOption(cities[i]);
            }
        }
    }


// Appends cities found in the select field as HTML option field
    setCityOption(city, selected = false) {
        const selectedAttr = selected ? 'selected="selected"' : '';

        this.$citiesSelectElement.append(`<option value="${city}" ${selectedAttr}>${city}</option>`);
    }


// Remove items from city select field
// Enabled : Optional - Allows to disable or not the select HTML tag
    clearCities(enabled = true) {
        this.$citiesSelectElement.empty();

        if (!enabled) {
            this.$citiesSelectElement.attr("disabled", "disabled");
        } else {
            this.$citiesSelectElement.removeAttr("disabled")
        }
    }

}

// On page loading, set the cities list in select field if it is already set in session storage
$(document).ready(() => {
    if ($("[id*='new_impersonate_user']").length > 0) {
        var citiesElementIdentifier = "[id*='authorization_city']"
        var postalCodeIdentifier = "[id*='authorization_postal_code']"
    } else {
        var citiesElementIdentifier = "#authorization_handler_city"
        var postalCodeIdentifier = "#authorization_handler_postal_code"
    }

    const $citiesElement = $(citiesElementIdentifier);
    const $postalCode = $(postalCodeIdentifier);
    const ahApi = new AhApi();
    const ahFormHTML = new AhFormHTML($citiesElement);

    if ($postalCode.val() !== "") {
        let cities = ahApi.citiesFor($postalCode.val());
        if (cities.length > 0) {
            ahFormHTML.clearCities();
            ahFormHTML.setCities(cities);
        }
    }

    // For each input on the postal code field, it looks for the corresponding city for the given postal code
    // While the postal code length is under 5, it clears the select field
    // Otherwise it stores the cities found in session storage and append to select field
    $postalCode.on("input", (e) => {
        const $element = $(e.currentTarget);
        const value = $element.val();

        if (value.length > 4) {
            let cities = ahApi.citiesFor(value);
            if (cities.length > 0) {
                ahFormHTML.clearCities(false);
                ahFormHTML.setCities(cities);
            } else {
                ahFormHTML.clearCities(true);
            }
        }
    })
});
