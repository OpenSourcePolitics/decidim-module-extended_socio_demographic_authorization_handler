# frozen_string_literal: true

require "spec_helper"

describe ExtendedSocioDemographicAuthorizationHandler do
  subject do
    described_class.new(
      last_name: last_name,
      usual_last_name: usual_last_name,
      first_name: first_name,
      usual_first_name: usual_first_name,
      address: address,
      postal_code: postal_code,
      city: city,
      email: email,
      birth_date: birth_date,
      certification: certification,
      news_cese: news_cese
    )
  end

  let(:user) { create(:user) }

  let(:organization) { user.organization }

  let(:last_name) { "Doe" }
  let(:usual_last_name) { "Smith" }
  let(:first_name) { "John" }
  let(:usual_first_name) { "Jack" }
  let(:address) { "21 Jump Street" }
  let(:postal_code) { "75018" }
  let(:city) { "Nowhere" }
  let(:email) { "user@example.org" }
  let(:birth_date) { 20.years.ago.to_date }
  let(:certification) { true }
  let(:news_cese) { true }

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
      expect(subject).to be_invalid
    end
  end

  context "when email is invalid" do
    let(:email) { "something invalid" }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when certification is unchecked" do
    let(:certification) { "0" }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when birthdate is nil" do
    let(:birth_date) { nil }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end

  context "when the person is too young" do
    let(:birth_date) { 14.years.ago.to_date }

    it "is invalid" do
      expect(subject).to be_invalid
    end
  end
end
