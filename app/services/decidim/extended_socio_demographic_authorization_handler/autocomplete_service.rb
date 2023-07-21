# frozen_string_literal: true

module Decidim
  module ExtendedSocioDemographicAuthorizationHandler
    class AutocompleteService
      def initialize(postal_code)
        @postal_code = postal_code
      end

      def self.for(postal_code)
        new(postal_code).call
      end

      def call
        return [] if @postal_code.blank?

        return Rails.cache.read(cache_key) if Rails.cache.exist?(cache_key)

        response = JSON.dump(parsed_response(request))

        return [] if response == "null"

        Rails.cache.write(cache_key, response, expires_in: 1.month)

        response
      end

      private

      def request
        response = Faraday.get("https://apicarto.ign.fr/api/codes-postaux/communes/#{@postal_code}")
        response.body
      rescue StandardError => e
        Rails.logger.warn("Error while fetching municipality names for postal code #{@postal_code} with error #{e}")

        "{}"
      end

      def parsed_response(body)
        return if body == "Not Found"
        return unless JSON.parse(body).is_a?(Array)

        features = JSON.parse(body)
        features.map do |feature|
          { feature.fetch("codePostal", nil) => feature.fetch("nomCommune", nil) }
        end.compact
      end

      def cache_key
        "postal_code_autocomplete/#{@postal_code}"
      end

      def url
        @url ||= URI("https://apicarto.ign.fr/api/codes-postaux/communes/#{@postal_code}")
      end
    end
  end
end
