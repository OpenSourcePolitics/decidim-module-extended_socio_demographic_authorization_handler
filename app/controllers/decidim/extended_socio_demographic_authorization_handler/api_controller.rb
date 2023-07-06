# frozen_string_literal: true

module Decidim
  module ExtendedSocioDemographicAuthorizationHandler
    class ApiController < Decidim::ApplicationController
      def postal_code
        opendatasoft_service = OpendatasoftService.new(params["zipcode"], current_organization)
        render json: { records: opendatasoft_service.fetch_cities! }
      end
    end
  end
end
