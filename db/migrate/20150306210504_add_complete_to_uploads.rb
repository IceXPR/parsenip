class AddCompleteToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :complete, :boolean, default: false
  end
end
