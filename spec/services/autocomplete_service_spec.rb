# frozen_string_literal: true

require "spec_helper"

module Decidim
  module ExtendedSocioDemographicAuthorizationHandler
    describe AutocompleteService do
      subject do
        described_class.for(postal_code)
      end
      let!(:postal_code){ 75018 }

      context "when the code postal is valid" do
        before do
          stub_request(:get, "https://apicarto.ign.fr/api/codes-postaux/communes/75018").
            with(
              headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Host'=>'apicarto.ign.fr',
                'User-Agent'=>'Ruby'
              }).
            to_return(status: 200, body: [{ "nomCommune": "PARIS 18", "libelle_d_acheminement": "PARIS 18", "codePostal": "75018", "code_commune_insee": "75118" }].to_json, headers: {})
        end

        it "returns the good city" do
          expect(subject).to eq(JSON.dump([{ 75018 => "PARIS 18" }]))
        end
      end

      context "when the code postal is not found" do
        let!(:postal_code){ 75035 }

        before do
          stub_request(:get, "https://apicarto.ign.fr/api/codes-postaux/communes/75035").
            with(
              headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Host'=>'apicarto.ign.fr',
                'User-Agent'=>'Ruby'
              }).
            to_return(status: 200, body: "Not Found", headers: {})
        end

        it "returns the good city" do
          expect(subject).to eq("null")
        end
      end

      context "when the code postal is invalid" do
        let!(:postal_code){ "foobar" }

        before do
          stub_request(:get, "https://apicarto.ign.fr/api/codes-postaux/communes/foobar").
            with(
              headers: {
                'Accept'=>'*/*',
                'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Host'=>'apicarto.ign.fr',
                'User-Agent'=>'Ruby'
              }).
            to_return(status: 400, body: { "code": 400, "response": [{ "nomCommune": "PARIS 18", "libelle_d_acheminement": "PARIS 18", "codePostal": "75018", "code_commune_insee": "75118" }] }.to_json, headers: {})
        end

        it "returns the good city" do
          expect(subject).to eq("null")
        end
      end
    end
  end
end
