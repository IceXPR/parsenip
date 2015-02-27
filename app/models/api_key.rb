class ApiKey < ActiveRecord::Base
  API_KEY_LENGTH = 32
  belongs_to :user

  validates :permit_url, presence: true

  before_create :assign_api_key

  def by_user
    user.api_keys
  end

  def assign_api_key
    self.key = SecureRandom.urlsafe_base64
  end

  def valid_request(request)
    request.env["HTTP_ORIGIN"].gsub(/^https?:\/\//, '') == permit_url
  end
end
