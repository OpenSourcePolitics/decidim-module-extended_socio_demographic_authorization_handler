# frozen_string_literal: true

# Allows to create a form for simple Socio Demographic authorization
class ExtendedSocioDemographicAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :last_name, String
  attribute :first_name, String
  attribute :address, String
  attribute :postal_code, String
  attribute :city, String
  attribute :email, String
  attribute :phone_number, String
  attribute :resident, Boolean
  attribute :rgpd, Boolean

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :address, presence: true
  validates :postal_code, numericality: { only_integer: true }, presence: true
  validates :city, presence: true
  validates :email, presence: true, unless: ->(form) { form.phone_number.present? }
  validates :email, format: { with: Devise.email_regexp }, if: ->(form) { form.email.present? }
  validates :phone_number, presence: true, unless: ->(form) { form.email.present? }
  validates :phone_number, format: { with: /(0|\+33)[1-9]([-.]?[0-9]{2}){3}([-.]?[0-9]{2})/ }, if: ->(form) { form.phone_number.present? }
  validates :resident, acceptance: true, presence: true
  validates :rgpd, acceptance: true, presence: true

  def metadata
    super.merge(
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
end
