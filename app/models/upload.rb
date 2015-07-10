class Upload < ActiveRecord::Base
  belongs_to :user
  has_many :parse_data, class_name: "ParseData"
  has_many :completed_chunks
  has_many :assigned_columns
  has_attached_file :file

  before_create :generate_token

  def set_metadata!
    set_number_of_lines
    set_number_of_columns
  end

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
    raise "Parse data already sent for upload #{id}" unless data_sent.blank?

    HTTParty.post(callback_url, {
        body:{
            upload_token: upload_token,
            data: parse_data.to_json({only: Column.all_keys})
        }
    })

    update(data_sent: DateTime.now)
  end

  def set_number_of_lines
    # Get the number of CSV *records*, not the number of lines in a file.
    # This adds support for CSV records with newlines in the data.
    number_of_lines = CSV.read(file.path).length
    update(lines: number_of_lines)
  end

  def csv_process(options = nil, &block)
    options ||= {}
    default_options = {
        row_sep: :auto
    }
    options = default_options.merge(options)

    SmarterCSV.process(file.path, options) do |chunk_or_line|
      yield(chunk_or_line)
    end
  end

  # Get the number of columns by counting the number of columns on the first row
  def set_number_of_columns
    csv_process({remove_empty_values: false, row_sep: :auto}) do |line|
      return update(number_of_columns: line[0].keys.length)
    end
  end

  # Prepare the file for reading and parsing:
  #  1. Convert excel files to csv
  #  2. Fix any encoding issues
  #  3. Set the metadata for the file (upload lines, etc)
  def prepare_file!
    convert_excel_to_csv!
    check_and_fix_encoding!
    set_metadata!
  end

  # Get the current content and convert it to utf8 from the encoding it's in now
  # This may cause memory issues for huge files...
  def get_utf8_encoded_content
    content = File.read(file.path)
    CharlockHolmes::Converter.convert content, detect_encoding, 'UTF-8'
  end

  def detect_encoding
    content = File.read(file.path)
    detection = CharlockHolmes::EncodingDetector.detect(content)
    detection[:encoding]
  end

  def check_and_fix_encoding!
    fix_encoding! unless utf8_encoded?
  end

  def utf8_encoded?
    detect_encoding == "UTF-8"
  end

  def fix_encoding!
    target = Rails.root.join('tmp', 'upload' + id.to_s + '.csv').to_s

    File.open(target, 'w+') do |target_file|
      target_file << get_utf8_encoded_content
    end
    self.update(file: File.open(target))
    File.unlink(target)
  end

  def convert_excel_to_csv!
    return if file.content_type == "text/csv"
    convert_to_csv!
  end

  def convert_to_csv!
    spreadsheet = Roo::Spreadsheet.open(file.path)
    target      = Rails.root.join('tmp', 'upload' + id.to_s + '.csv').to_s
    File.write(target, spreadsheet.to_csv)
    self.update(file: File.open(target))
    File.unlink(target)
  end

  def iterate_lines(limit = nil)
    limit = lines if limit.nil?
    chunk_size = [limit, 100, (lines/10).to_i].min
    processed = 0

    csv_options = {headers_in_file: false, user_provided_headers: numerical_headers, chunk_size: chunk_size, remove_empty_values: false}
    csv_process(csv_options) do |chunk|
      if processed >= limit
        return
      end
      yield(chunk)
      processed += chunk_size
    end
  end

  def detection_complete!
    update(detection_completed: DateTime.now)
  end

  def matches
    hash = {}
    assigned_columns.each do |ac|
      hash[ac.column_number] =  ac.column ? ac.column.key : nil
    end
    hash
  end

  def get_first_lines(number)
    first = []
    iterate_lines(number) do |chunk|
      chunk.each do |line|
        first.push line
        if first.length >= number
          return first
        end
      end
    end
    # It reaches this point if we requested more than the file actually has
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
