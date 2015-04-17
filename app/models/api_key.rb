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
    self.server_api_key = SecureRandom.urlsafe_base64
  end

  def valid_request(request)
    origin = request.env["HTTP_ORIGIN"] || request.ip
    return false if origin.nil?
    origin.gsub(/^https?:\/\//, '') == permit_url
  end
end
