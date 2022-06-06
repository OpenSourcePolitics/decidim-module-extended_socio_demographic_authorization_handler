# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/extended_socio_demographic_authorization_handler/version"

Gem::Specification.new do |s|
  s.version = Decidim::ExtendedSocioDemographicAuthorizationHandler.version
  s.authors = ["Armand"]
  s.email = ["fardeauarmand@gmail.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-extended_socio_demographic_authorization_handler"
  s.required_ruby_version = ">= 2.7"

  s.name = "decidim-extended_socio_demographic_authorization_handler"
  s.summary = "A decidim extended_socio_demographic_authorization_handler module"
  s.description = "Authorization Handler that asks for personal information to the user. It contains a postal code / city completion through La Poste's API"

  s.files = Dir["{app,config,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::ExtendedSocioDemographicAuthorizationHandler.version
end
