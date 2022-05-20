# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module ExtendedSocioDemographicAuthorizationHandler
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::ExtendedSocioDemographicAuthorizationHandler

      initializer "decidim.extends" do
        require "decidim/extends/controllers/confirmations_controller_extend"
      end
    end
  end
end
