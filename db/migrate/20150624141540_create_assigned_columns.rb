class CreateAssignedColumns < ActiveRecord::Migration
  def change
    create_table :assigned_columns do |t|
      t.references :upload, index: true
      t.integer :column_number
      t.references :column, index: true

      t.timestamps null: false
    end
    add_foreign_key :assigned_columns, :uploads
    add_foreign_key :assigned_columns, :columns
  end
end
