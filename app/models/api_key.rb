class ApiKey < ActiveRecord::Base
  API_KEY_LENGTH = 32
  belongs_to :user

  validates :permit_url, presence: true, uniqueness: {scope: :user_id}

  before_create :assign_api_key

  def by_user
    user.api_keys
  end

  def assign_api_key
    self.javascript_api_key = SecureRandom.urlsafe_base64
  end

  def valid_request(request)
    origin = request.env["HTTP_ORIGIN"] || request.ip
    if origin.nil?
      Rails.logger.debug "Invalid request for api key #{javascript_api_key}, origin is nil: #{origin}"
      return false
    end

    origin_url = origin.gsub(/^https?:\/\//, '')
    valid_url =  origin_url == permit_url
    if ! valid_url
      Rails.logger.debug "Invalid request for api key #{javascript_api_key}, url is invalid: #{origin_url} (origin) != #{permit_url} (permitted)"
      return false
    end

    true
  end
end
