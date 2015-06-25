

# Send the parsed data to the callback url
class SendParseData
  include Sidekiq::Worker
  def perform(upload_id)
    upload = Upload.find(upload_id)
    upload.send_parse_data! unless upload.data_sent
  end
end