

class PrepareUpload
  include Sidekiq::Worker
  def perform(upload_id)
    upload = Upload.find(upload_id)
    upload.prepare_file!
    Detect.perform_async(upload_id)
  end
end