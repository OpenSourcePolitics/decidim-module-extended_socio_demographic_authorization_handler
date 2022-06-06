# frozen_string_literal: true

require "spec_helper"

describe "User authorizations", type: :system do
  include Decidim::TranslatableAttributes

  let!(:organization) do
    create(:organization,
           available_authorizations: ["extended_socio_demographic_authorization_handler"])
  end

  let(:user) { create(:user, :confirmed) }

  before do
    stub_request(:get, /datanova.laposte.fr/)
      .with(headers: { "Accept" => "application/json" })
      .to_return(status: 200, body: { "nhits": 1, "parameters": { "dataset": "laposte_hexasmal", "q": "75018", "rows": 10, "start": 0, "facet": %w(code_postal ligne_10), "format": "json", "timezone": "UTC" }, "records": [{ "datasetid": "laposte_hexasmal", "recordid": "29faec4345bff1b24c52cc6e6bc9ddfa899eb862", "fields": { "nom_de_la_commune": "PARIS 18", "libelle_d_acheminement": "PARIS 18", "code_postal": "75018", "coordonnees_gps": [48.892570317, 2.3481765980000002], "code_commune_insee": "75118" }, "geometry": { "type": "Point", "coordinates": [2.3481765980000002, 48.892570317] }, "record_timestamp": "2022-03-20T23:35:00Z" }], "facet_groups": [{ "name": "code_postal", "facets": [{ "name": "75018", "count": 1, "state": "displayed", "path": "75018" }] }] }.to_json, headers: {})

    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim.root_path
    click_link user.name
    click_link "My account"
    click_link "Authorizations"
  end

  it "displays the authorization item" do
    within ".tabs-content.vertical" do
      expect(page).to have_content("Additional informations")
    end
  end

  context "when accessing authorization" do
    before do
      visit "/authorizations"

      click_link "Additional informations"
    end

    it "displays authorization form" do
      expect(page).to have_content "Additional informations"

      within ".new_authorization_handler" do
        expect(page).to have_content("Last name")
        expect(page).to have_field("First name")
        expect(page).to have_field("Address")
        expect(page).to have_field("Postal code")
        expect(page).to have_content("City")
        expect(page).to have_field("Email")
        expect(page).to have_field("Phone number")
        expect(page).to have_field("Resident")
        expect(page).to have_field("Rgpd")
      end
    end

    it "allows user to fill form" do
      fill_in :authorization_handler_last_name, with: "Doe"
      fill_in :authorization_handler_first_name, with: "John"
      fill_in :authorization_handler_address, with: "21 Jump Street"
      fill_in :authorization_handler_postal_code, with: "75018"

      fill_in :authorization_handler_email, with: "user@example.org"
      fill_in :authorization_handler_phone_number, with: "+33654321234"
      check :authorization_handler_resident
      check :authorization_handler_rgpd
      click_button "Send"

      expect(page).to have_content("You've been successfully authorized")
    end

    it "allows to select a city when multiple cities are enabled" do
      fill_in :authorization_handler_last_name, with: "Doe"
      fill_in :authorization_handler_first_name, with: "John"
      fill_in :authorization_handler_address, with: "21 Jump Street"
      fill_in :authorization_handler_postal_code, with: "75018"
      select "PARIS 18", from: :authorization_handler_city

      fill_in :authorization_handler_email, with: "user@example.org"
      fill_in :authorization_handler_phone_number, with: "+33654321234"
      check :authorization_handler_resident
      check :authorization_handler_rgpd
      click_button "Send"

      expect(page).to have_content("You've been successfully authorized")
    end
  end
end
