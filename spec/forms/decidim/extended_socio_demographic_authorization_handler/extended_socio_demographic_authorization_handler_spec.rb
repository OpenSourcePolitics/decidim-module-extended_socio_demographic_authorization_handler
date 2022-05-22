# frozen_string_literal: true

require "spec_helper"

describe ExtendedSocioDemographicAuthorizationHandler do
  subject do
    described_class.new(
      last_name: last_name,
      first_name: first_name,
      address: address,
      postal_code: postal_code,
      city: city,
      email: email,
      phone_number: phone_number,
      resident: resident,
      rgpd: rgpd
    )
  end

  let(:user) { create(:user) }

  let(:organization) { user.organization }

  let(:last_name) { "Doe" }
  let(:first_name) { "John" }
  let(:address) { "21 Jump Street" }
  let(:postal_code) { "1234" }
  let(:city) { "Nowhere" }
  let(:email) { "user@example.org" }
  let(:phone_number) { "+33640123422" }
  let(:resident) { "1" }
  let(:rgpd) { "1" }

  context "when the information is valid" do
    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "when name is nil" do
    let(:last_name) { nil }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when first name is nil" do
    let(:first_name) { nil }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when postal code is nil" do
    let(:postal_code) { nil }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when postal code is not a number" do
    let(:postal_code) { "Some string" }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when city is nil" do
    let(:city) { nil }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when email is nil" do
    let(:email) { nil }

    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "when email is invalid" do
    let(:email) { "something invalid" }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when phone number is nil" do
    let(:phone_number) { nil }

    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "when phone number and email are nil" do
    let(:email) { nil }
    let(:phone_number) { nil }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when phone number is nil email is present" do
    let(:phone_number) { nil }

    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "when phone number is present and  email is nil" do
    let(:email) { nil }

    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "when phone number is invalid" do
    let(:phone_number) { 1234 }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when resident is nil" do
    let(:resident) { "0" }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when rgpd is nil" do
    let(:rgpd) { "0" }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end
end
