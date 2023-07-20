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
    stub_request(:get, "https://apicarto.ign.fr/api/codes-postaux/communes/75018")
      .with(
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Host" => "apicarto.ign.fr",
          "User-Agent" => "Ruby"
        }
      )
      .to_return(status: 200, body: [{ nomCommune: "PARIS 18", libelle_d_acheminement: "PARIS 18", codePostal: "75018", code_commune_insee: "75118" }].to_json, headers: {})

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
