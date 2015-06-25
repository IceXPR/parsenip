class AddDataSentToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :data_sent, :datetime
  end
end
