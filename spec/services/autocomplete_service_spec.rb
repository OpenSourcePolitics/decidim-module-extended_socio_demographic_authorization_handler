# frozen_string_literal: true

require "spec_helper"

module Decidim
  module ExtendedSocioDemographicAuthorizationHandler
    describe AutocompleteService do
      subject do
        described_class.for(postal_code)
      end

      let!(:postal_code) { 75_018 }
      let(:cache_store) { :memory_store }

      before do
        allow(Rails).to receive(:cache).and_return(ActiveSupport::Cache.lookup_store(cache_store))
        Rails.cache.clear
      end

      context "when the code postal is valid" do
        context "and it's the first time being asked" do
          before do
            stub_request(:get, "https://apicarto.ign.fr/api/codes-postaux/communes/#{postal_code}")
              .with(
                headers: {
                  "Accept" => "*/*",
                  "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
                  "User-Agent" => "Faraday v2.6.0"
                }
              )
              .to_return(status: 200, body: [{ nomCommune: "PARIS 18", libelle_d_acheminement: "PARIS 18", codePostal: postal_code, code_commune_insee: "75118" }].to_json, headers: {})
          end

          it "returns the good city and saves it in the cache" do
            expect(subject).to eq([{ postal_code => "PARIS 18" }])
            expect(Rails.cache.read("postal_code_autocomplete/#{postal_code}")).to eq([{ postal_code => "PARIS 18" }])
          end
        end

        context "and it's not the first time it's asked" do
          before do
            Rails.cache.write("postal_code_autocomplete/#{postal_code}", [{ postal_code => "PARIS 18" }])
          end

          it "render the good code without asking for the service" do
            expect(Rails.cache).not_to receive(:write)
            expect(subject).to eq([{ postal_code => "PARIS 18" }])
            expect(Rails.cache.read("postal_code_autocomplete/#{postal_code}")).to eq([{ postal_code => "PARIS 18" }])
          end
        end
      end

      context "when the code postal is not found" do
        let!(:postal_code) { 75_035 }

        before do
          stub_request(:get, "https://apicarto.ign.fr/api/codes-postaux/communes/#{postal_code}")
            .with(
              headers: {
                "Accept" => "*/*",
                "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
                "User-Agent" => "Faraday v2.6.0"
              }
            )
            .to_return(status: 200, body: "Not Found", headers: {})
        end

        it "returns nothing and doesn't saves it in the cache" do
          expect(subject).to be_nil
          expect(Rails.cache).not_to exist("postal_code_autocomplete/#{postal_code}")
        end
      end

      context "when the code postal is invalid" do
        let!(:postal_code) { "foobar" }

        before do
          stub_request(:get, "https://apicarto.ign.fr/api/codes-postaux/communes/#{postal_code}")
            .with(
              headers: {
                "Accept" => "*/*",
                "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
                "User-Agent" => "Faraday v2.6.0"
              }
            )
            .to_return(status: 400, body: { code: 400, response: [{ nomCommune: "", libelle_d_acheminement: "", codePostal: "", code_commune_insee: "" }] }.to_json, headers: {})
        end

        it "returns nothing and doesn't saves it in the cache" do
          expect(subject).to be_nil
          expect(Rails.cache).not_to exist("postal_code_autocomplete/#{postal_code}")
        end
      end
    end
  end
end
