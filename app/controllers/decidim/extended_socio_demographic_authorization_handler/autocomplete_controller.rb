# frozen_string_literal: true

module Decidim
  module ExtendedSocioDemographicAuthorizationHandler
    class AutocompleteController < ApplicationController
      def city
        render json: Decidim::ExtendedSocioDemographicAuthorizationHandler::AutocompleteService.for(params[:postal_code])
      end
    end
  end
end
