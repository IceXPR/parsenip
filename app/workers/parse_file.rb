
# Take a file and begin parsing it
class ParseFile
  include Sidekiq::Worker
  def perform(upload_id)
    upload = Upload.find(upload_id)

    raise "Upload #{upload.id} already processed" if upload.parse_data.count > 0

    upload.set_number_of_lines

    headers = ColumnMatchService.new(upload.reload).detect
    puts "Detected headers: #{headers.inspect}"
    DataGrabberService.new(headers, upload).start
  end
end