class AddHasHeaderToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :has_header, :boolean, default: false
  end
end
