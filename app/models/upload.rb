class Upload < ActiveRecord::Base
  belongs_to :user
  has_attached_file :file

  before_create :generate_token

  # TODO: we should validate against certain types, but we don't know what they are yet
  do_not_validate_attachment_file_type :file

  def percent_complete
    1 + Random.rand(101)
  end

  private

  def generate_token
    self.upload_token = SecureRandom.urlsafe_base64(nil, false)
  end
end
