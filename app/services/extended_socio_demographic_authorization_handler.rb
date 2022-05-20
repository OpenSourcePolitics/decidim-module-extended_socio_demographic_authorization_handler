# frozen_string_literal: true

# Allows to create a form for simple Socio Demographic authorization
class ExtendedSocioDemographicAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :last_name, String
  attribute :first_name, String
  attribute :address, String
  attribute :postal_code, String
  attribute :city, String

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :address, presence: true
  validates :postal_code, presence: true
  validates :city, presence: true

  def metadata
    super.merge(
      last_name: last_name,
      first_name: first_name,
      address: address,
      postal_code: postal_code,
      city: city
    )
  end
end
