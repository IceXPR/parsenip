class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :uploads, :users
  end
end
