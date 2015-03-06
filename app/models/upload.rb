class Upload < ActiveRecord::Base
  belongs_to :user
  has_many :parse_data, class_name: "ParseData"
  has_attached_file :file

  before_create :generate_token

  # TODO: we should validate against certain types, but we don't know what they are yet
  do_not_validate_attachment_file_type :file

  scope :in_plan_range, ->(user_plan){
    where(created_at: user_plan.last_charge_date..Time.now)
  }

  def set_halfway_complete
    update(progress: 50)
  end

  def complete
    update(progress: 100)
  end

  def set_number_of_lines
    update(lines: File.foreach(file.path).count)
  end

  # Update the % and divide by 2 to make sure it doesn't surpass 50%
  def update_progress_from_position(position)
    position = BigDecimal.new(position)
    lines = BigDecimal.new(self.lines)
    update(progress: ((position / lines) * 100) / 2)
  end

  def update_progress_on_parse_data(position)
    position = BigDecimal.new(position)
    lines = BigDecimal.new(self.lines)
    update(progress: (((position / lines) * 100) / 2) + 50)
  end

  def percent_complete
    "#{progress}%"
  end

  private

  def generate_token
    self.upload_token = SecureRandom.urlsafe_base64(nil, false)
  end
end
