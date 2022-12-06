# frozen_string_literal: true

# Allows to create a form for simple Socio Demographic authorization
class ExtendedSocioDemographicAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :last_name, String
  attribute :usual_last_name, String
  attribute :first_name, String
  attribute :usual_first_name, String
  attribute :birth_date, Date
  attribute :address, String
  attribute :postal_code, String
  attribute :city, String
  attribute :email, String
  attribute :certification, Boolean
  attribute :news_cese, Boolean

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :birth_date, presence: true
  validates :address, presence: true
  validates :postal_code, numericality: { only_integer: true }, presence: true, length: { is: 5 }
  validates :city, presence: true
  validates :email, format: { with: Devise.email_regexp }, presence: true
  validates :certification, acceptance: true, presence: true

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
