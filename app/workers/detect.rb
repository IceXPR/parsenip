

# Match data
class Detect
  include Sidekiq::Worker
  DETECTION_AMOUNT = 15
  def perform(upload_id)
    upload = Upload.find(upload_id)
    matches = ColumnMatchService.new(upload).detect(DETECTION_AMOUNT)
    matches.each_pair do |column_number, column|
      upload.assigned_columns.create({
                                         column_number: column_number,
                                         column: Column.find_by_key(column.to_s)
                                     })
    end

    upload.detection_complete!
  end
end