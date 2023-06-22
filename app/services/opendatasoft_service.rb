# frozen_string_literal: true

# Find related cities to given zipcode
class OpendatasoftService
  def initialize(zipcode, organization)
    @zipcode = zipcode
    @organization = organization
  end

  def fetch_cities!
    return [] if @zipcode.blank?
    return [] unless @zipcode.match?(/^(([0-8][0-9])|(9[0-5])|(2[AB]))[0-9]{3}$/)

    Rails.cache.fetch(cache_key, expires_in: 15.days) do
      Rails.logger.info("ExtendedSocioDemographicAuthorizationHandler - Faraday - Looking for zipcode : #{@zipcode}")
      make_api_call!
    end
  end

  private

  def make_api_call!
    response = Faraday.get(url) do |req|
      req.headers["Referer"] = @organization.host
      req.headers["accept"] = "application/json"
      req.headers["Authorization"] = "Apikey #{api_key}" if api_key.present?
    end

    response_h = response&.to_hash
    return [] if response_h.blank?

    body = JSON.parse(response_h.fetch(:body, {}))
    body.fetch("records", []).map do |record|
      record["fields"]["nom_de_la_commune"]
    end
  end

  def url
    @url ||= "https://datanova.laposte.fr/api/records/1.0/search/?dataset=laposte_hexasmal&q=#{@zipcode}&facet=code_postal&facet=ligne_10"
  end

  def cache_key
    @cache_key ||= "opendatasoft/#{@zipcode}"
  end

  def api_key
    @api_key ||= ENV.fetch("OPENDATASOFT_API_KEY", "")
  end
end
