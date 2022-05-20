# frozen_string_literal: true

require "spec_helper"

describe ExtendedSocioDemographicAuthorizationHandler do
  subject do
    described_class.new(
      last_name: last_name,
      first_name: first_name
    )
  end

  let(:user) { create(:user) }

  let(:organization) { user.organization }

  let(:last_name) { "Doe" }
  let(:first_name) { "John" }

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
end
