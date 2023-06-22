require 'spec_helper'

module Decidim
  module ExtendedSocioDemographicAuthorizationHandler
    describe ApiController, type: :controller do
      describe 'GET #postal_code' do
        let(:organization) { create(:organization) }
        let(:zipcode) { '12345' }
        let(:opendatasoft_service) { instance_double(OpendatasoftService) }
        let(:cities) { ['City 1', 'City 2'] }

        before do
          allow(controller).to receive(:current_organization).and_return(organization)
          allow(OpendatasoftService).to receive(:new).with(zipcode, organization).and_return(opendatasoft_service)
          allow(opendatasoft_service).to receive(:fetch_cities!).and_return(cities)
        end

        it 'creates a new instance of OpendatasoftService with the correct arguments' do
          expect(OpendatasoftService).to receive(:new).with(zipcode, organization)

          get :postal_code, params: { zipcode: zipcode }
        end

        it 'calls fetch_cities! on the OpendatasoftService instance' do
          expect(opendatasoft_service).to receive(:fetch_cities!)

          get :postal_code, params: { zipcode: zipcode }
        end

        it 'renders a JSON response with the fetched cities' do
          get :postal_code, params: { zipcode: zipcode }

          expect(response).to have_http_status(:ok)
          expect(response.content_type).to eq('application/json; charset=utf-8')
          expect(JSON.parse(response.body)).to eq({ 'records' => cities })
        end
      end
    end
  end
end
