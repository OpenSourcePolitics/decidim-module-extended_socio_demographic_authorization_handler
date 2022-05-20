# frozen_string_literal: true

require "spec_helper"

describe ExtendedSocioDemographicAuthorizationHandler do
  subject do
    described_class.new(
      last_name: last_name,
      first_name: first_name,
      address: address,
      postal_code: postal_code,
      city: city
    )
  end

  let(:user) { create(:user) }

  let(:organization) { user.organization }

  let(:last_name) { "Doe" }
  let(:first_name) { "John" }
  let(:address) { "21 Jump Street" }
  let(:postal_code) { "1234" }
  let(:city) { "Nowhere" }

  context "when the information is valid" do
    it "is valid" do
      expect(subject).to be_valid
    end
  end

  context "when name is nil" do
    let(:last_name) { nil }

    it "is valid" do
      expect(subject).to be_invalid
    end
  end

  context "when first name is nil" do
    let(:first_name) { nil }

    it "is valid" do
      expect(subject).to be_invalid
    end
  end

  context "when postal code is nil" do
    let(:postal_code) { nil }

    it "is valid" do
      expect(subject).to be_invalid
    end
  end

  context "when city is nil" do
    let(:city) { nil }

    it "is valid" do
      expect(subject).to be_invalid
    end
  end
end
