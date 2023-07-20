# frozen_string_literal: true

Rails.application.routes.draw do
  get "/postal-code-autocomplete/:postal_code", to: "decidim/extended_socio_demographic_authorization_handler/autocomplete#city"
end
