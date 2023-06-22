require 'spec_helper'

describe OpendatasoftService do
  let(:zipcode) { '12345' }
  let(:organization) { create :organization }
  let(:service) { OpendatasoftService.new(zipcode, organization) }

  describe '#fetch_cities!' do
    context 'when the zipcode is blank' do
      let(:zipcode) { '' }

      it 'returns an empty array' do
        expect(service.fetch_cities!).to eq([])
      end
    end

    context 'when the zipcode is invalid' do
      let(:zipcode) { '123' }

      it 'returns an empty array' do
        expect(service.fetch_cities!).to eq([])
      end
    end

    context 'when the zipcode is valid' do
      let(:zipcode) { '12345' }
      let(:cache_key) { 'opendatasoft/12345' }
      let(:response_body) do
        {
          "records" => [
            { "fields" => { "nom_de_la_commune" => "City 1" } },
            { "fields" => { "nom_de_la_commune" => "City 2" } }
          ]
        }
      end
      let(:response) { double('Response', to_hash: { body: response_body.to_json }) }

      before do
        allow(Rails.cache).to receive(:fetch).and_yield
        allow(Faraday).to receive(:get).and_return(response)
      end

      it 'returns the cities extracted from the API response' do
        expect(service.fetch_cities!).to eq(['City 1', 'City 2'])
      end

      it 'caches the response' do
        expect(Rails.cache).to receive(:fetch).with(cache_key, expires_in: 15.days).and_yield

        service.fetch_cities!
      end
    end
  end
end
