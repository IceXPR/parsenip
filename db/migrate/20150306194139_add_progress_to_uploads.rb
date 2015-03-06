class AddProgressToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :progress, :int
  end
end
