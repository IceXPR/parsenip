class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.references :user, index: true
      t.string :key
      t.string :permit_url

      t.timestamps null: false
    end
    add_foreign_key :api_keys, :users
  end
end
