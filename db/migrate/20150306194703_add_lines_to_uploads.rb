class AddLinesToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :lines, :int
  end
end
