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

  def self.uploader_chunk_size
    return 250
  end

  def header_match_offset
    return 50.0
  end

  def set_header_match_offset 
    update(progress: header_match_offset)
  end

  def complete!
    update(complete: true, progress: 100)
  end

  def set_number_of_lines
    number_of_lines = File.foreach(file.path).count
    puts "***#{number_of_lines}***"
    update(lines: number_of_lines)
  end

  # Update the % and divide by 2 to make sure it doesn't surpass 50%
  def update_progress_from_position(position)
    position = BigDecimal.new(position)
    lines = BigDecimal.new(self.lines)
    update(progress: (((position / lines) * 100)*(header_match_offset/100)))
  end

  def update_progress_from_dictionary
    percent = BigDecimal(processed_chunks) / BigDecimal(total_chunks)
    update(progress: (percent * 100).round(0).to_i / 2)
  end

  def dictionary_percent_complete
    percent = BigDecimal(processed_chunks) / BigDecimal(total_chunks)
    "#{(percent * 100).round(0).to_i.to_s}%"
  end

  def update_progress_on_parse_data(position)
    position = BigDecimal.new(position)
    lines = BigDecimal.new(self.lines)
    update(progress: (((position / lines) * 100) * (1 - (header_match_offset/100))) + header_match_offset)
  end

  def percent_complete
    progress_percent = progress ? progress : 0
    "#{progress_percent}%"
  end

  private

  def generate_token
    self.upload_token = SecureRandom.urlsafe_base64(nil, false)
  end
end
