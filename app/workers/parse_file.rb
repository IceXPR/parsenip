
# Take a file and begin parsing it
class ParseFile
  include Sidekiq::Worker
  def perform(upload_id)
    upload = Upload.find(upload_id)
    headers = ColumnMatchService.new(upload.file).detect


    binding.pry
  end
end