# frozen_string_literal: true

Rails.application.routes.draw do
  post "extended_socio_demographic_authorization_handler/postal_code", to: "decidim/extended_socio_demographic_authorization_handler/api#postal_code"
end
