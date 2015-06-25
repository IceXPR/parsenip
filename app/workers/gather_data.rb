

# Gather data using the confirmed columns
class GatherData
  include Sidekiq::Worker
  def perform(upload_id)
    upload = Upload.find(upload_id)

    # Gather the data
    upload.iterate_lines do |chunk|
      GatherChunkData.perform_async(upload_id, chunk)
    end
  end
end