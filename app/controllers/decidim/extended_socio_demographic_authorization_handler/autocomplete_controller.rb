# frozen_string_literal: true

module Decidim
  module ExtendedSocioDemographicAuthorizationHandler
    class AutocompleteController < ApplicationController
      def city
        return render json: [] if params[:postal_code].blank?

        return render json: Rails.cache.read(cache_key) if Rails.cache.exist?(cache_key)

        response = Decidim::ExtendedSocioDemographicAuthorizationHandler::AutocompleteService.for(params[:postal_code])

        return render json: [] if response == "null"

        Rails.cache.write(cache_key, response, expires_in: 1.month)

        render json: response

      end

      def cache_key
        "postal_code_autocomplete/#{params[:postal_code]}"
      end
    end
  end
end

