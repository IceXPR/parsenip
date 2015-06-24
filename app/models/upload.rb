class Upload < ActiveRecord::Base
  belongs_to :user
  has_many :parse_data, class_name: "ParseData"
  has_many :completed_chunks
  has_attached_file :file

  before_create :generate_token

  # TODO: we should validate against certain types, but we don't know what they are yet
  do_not_validate_attachment_file_type :file

  scope :in_plan_range, ->(user_plan){
    where(created_at: user_plan.last_charge_date..Time.now)
  }

  def numerical_headers
    ("0"..number_of_columns.to_s).to_a
  end

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
    queue_send_parse_data
    completed_chunks.destroy_all
  end

  def queue_send_parse_data
    SendParseData.perform_async(id)
  end

  # Send the parse data to the callback url.
  # This should only be called from the SendParseData background job.
  def send_parse_data!
    raise "No callback url provided for upload #{id}" if callback_url.blank?

    HTTParty.post(callback_url, {
        body:{
            upload_token: upload_token,
            data: parse_data.to_json({only: [:first_name, :last_name, :email, :phone]})
        }
    })
  end

  def set_number_of_lines
    number_of_lines = File.foreach(file.path).count
    update(lines: number_of_lines)
  end

  # Get the number of columns by counting the number of columns on the first row
  def set_number_of_columns
    SmarterCSV.process(file.path, {remove_empty_values: false, row_sep: :auto}) do |line|
      return update(number_of_columns: line[0].keys.length)
    end
  end

  def iterate_lines(limit)
    chunk_size = [limit, 100, (lines/10).to_i].min
    processed = 0

    SmarterCSV.process(file.path, {headers_in_file: false, user_provided_headers: numerical_headers, chunk_size: chunk_size, remove_empty_values: false, row_sep: :auto}) do |chunk|
      if processed >= limit
        return
      end
      yield(chunk)
      processed += chunk_size
    end
  end

  def get_first_lines(number)
    first = []
    iterate_lines(number) do |chunk|
      first += chunk
    end
    first
  end

  # Update the % and divide by 2 to make sure it doesn't surpass 50%

  def update_progress_from_dictionary
    percent = BigDecimal(processed_chunks) / BigDecimal(total_chunks)
    update(progress: (percent * 100).round(0).to_i / 2)
  end

  # Update the % and divide by 2 and add 50 to show progress from 50% to 100%

  def update_progress_from_data_grabber
    percent = BigDecimal(completed_chunks.count) / BigDecimal(total_chunks)
    update(progress: ((percent * 100).round(0).to_i / 2) + 50)
    if self.reload.completed_chunks.count == total_chunks
      complete!
    end
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
