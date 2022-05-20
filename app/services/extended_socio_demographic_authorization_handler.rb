# frozen_string_literal: true

# Allows to create a form for simple Socio Demographic authorization
class ExtendedSocioDemographicAuthorizationHandler < Decidim::AuthorizationHandler
  attribute :last_name, String
  attribute :first_name, String

  validates :last_name, presence: true
  validates :first_name, presence: true

  def metadata
    super.merge(last_name: last_name, first_name: first_name)
  end
end
