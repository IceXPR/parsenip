
# Take a file and begin parsing it
class ParseFile
  include Sidekiq::Worker
  def perform(upload_id)
    upload = Upload.find(upload_id)
    # TODO: raise error if upload already has parse_data
    # raise "Upload #{upload.id} already processed" if upload.parse_data.count > 0
    # TODO: remove this:
    # upload.parse_data.destroy_all

    upload.set_number_of_lines

    headers = ColumnMatchService.new(upload.reload).detect
    puts "Detected headers: #{headers.inspect}"
    DataGrabberService.new(headers, upload).start
    upload.complete
  end
end