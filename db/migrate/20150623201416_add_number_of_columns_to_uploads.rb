class AddNumberOfColumnsToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :number_of_columns, :integer
  end
end
