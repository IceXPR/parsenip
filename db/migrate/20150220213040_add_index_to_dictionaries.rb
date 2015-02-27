class AddIndexToDictionaries < ActiveRecord::Migration
  def change
    add_index :dictionaries, :value_type_id
  end
end
