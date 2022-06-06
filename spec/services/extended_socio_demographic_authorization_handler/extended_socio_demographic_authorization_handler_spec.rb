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
  let(:postal_code) { "75018" }
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

  context "with postal code" do
    context "and nil" do
      let(:postal_code) { nil }

      it "is invalid" do
        expect(subject).to be_invalid
      end
    end

    context "and not a number" do
      let(:postal_code) { "Some string" }

      it "is invalid" do
        expect(subject).to be_invalid
      end
    end

    context "and length inferior than 5 chars" do
      let(:postal_code) { "1234" }

      it "is invalid" do
        expect(subject).to be_invalid
      end
    end

    context "and length greater than 5 chars" do
      let(:postal_code) { "123456" }

      it "is invalid" do
        expect(subject).to be_invalid
      end
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

  context "with phone number and email" do
    it "is valid" do
      expect(subject).to be_valid
    end

    context "and phone number is nil" do
      let(:phone_number) { nil }

      it "is valid" do
        expect(subject).to be_valid
      end
    end

    context "and email is nil" do
      let(:email) { nil }

      it "is valid" do
        expect(subject).to be_valid
      end
    end

    context "and both phone number and email are nil" do
      let(:email) { nil }
      let(:phone_number) { nil }

      it "is invalid" do
        expect(subject).to be_invalid
      end
    end

    context "with invalid phone number" do
      let(:phone_number) { 1234 }

      it "form is invalid" do
        expect(subject).to be_invalid
      end
    end

    context "with invalid email" do
      let(:email) { "invalid.email.com" }

      it "form is invalid" do
        expect(subject).to be_invalid
      end
    end
  end

  context "when resident is false" do
    let(:resident) { "0" }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when rgpd is false" do
    let(:rgpd) { "0" }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end
end
