# frozen_string_literal: true

Decidim::Core::Engine.routes.draw do
  get "/postal-code-autocomplete/:postal_code", to: "extended_socio_demographic_authorization_handler/autocomplete#city"
end
