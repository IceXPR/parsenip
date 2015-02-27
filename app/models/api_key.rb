class ApiKey < ActiveRecord::Base
  API_KEY_LENGTH = 32
  belongs_to :user

  before_create :assign_api_key
  def assign_api_key
    self.key = SecureRandom.urlsafe_base64
  end
end
