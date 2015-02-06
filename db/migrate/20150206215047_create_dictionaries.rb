class CreateDictionaries < ActiveRecord::Migration
  def change
    create_table :dictionaries do |t|
      t.string :value
      t.integer :value_type_id

      t.timestamps null: false
    end
  end
end
