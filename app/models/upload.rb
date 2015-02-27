class Upload < ActiveRecord::Base
  belongs_to :user
  has_attached_file :file

  before_create :generate_token

  # TODO: we should validate against certain types, but we don't know what they are yet
  do_not_validate_attachment_file_type :file

  scope :in_plan_range, ->(user_plan){
    where(created_at: user_plan.last_charge_date..Time.now)
  }

  private

  def generate_token
    self.upload_token = SecureRandom.urlsafe_base64(nil, false)
  end
end
