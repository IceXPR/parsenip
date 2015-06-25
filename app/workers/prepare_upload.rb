

class PrepareUpload
  include Sidekiq::Worker
  def perform(upload_id)
    upload = Upload.find(upload_id)
    upload.convert_to_csv!
    upload.set_metadata!
    Detect.perform_async(upload_id)
  end
end