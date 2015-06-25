class AddDetectionCompletedToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :detection_completed, :datetime
  end
end
