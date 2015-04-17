
# Take a file and begin parsing it
class SendParseData
  include Sidekiq::Worker
  def perform(upload_id)
    upload = Upload.find(upload_id)
    upload.send_parse_data!
  end
end