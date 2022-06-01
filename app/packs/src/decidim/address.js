$("#authorization_handler_postal_code").on("input", (e) => {
    var $element = $(e.currentTarget);
    var value = $element.val();

    if (value.length > 4) {
        console.log(value);
    }
})
