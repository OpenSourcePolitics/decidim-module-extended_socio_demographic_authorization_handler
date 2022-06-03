# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_path("#{base_path}/app/packs")
Decidim::Webpacker.register_entrypoints(
  extended_socio_demographic_authorization_handler: "#{base_path}/app/packs/entrypoints/extended_socio_demographic_authorization_handler.js",
  extended_socio_demographic_css: "#{base_path}/app/packs/stylesheets/decidim/extended_socio_demographic.scss"
)
# Decidim::Webpacker.register_stylesheet_import("stylesheets/decidim/extended_socio_demographic")
