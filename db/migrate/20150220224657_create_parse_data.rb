class CreateParseData < ActiveRecord::Migration
  def change
    create_table :parse_data do |t|
      t.references :upload, index: true
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email

      t.timestamps null: false
    end
    add_foreign_key :parse_data, :uploads
  end
end
