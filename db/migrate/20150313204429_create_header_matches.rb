class CreateHeaderMatches < ActiveRecord::Migration
  def change
    create_table :header_matches do |t|
      t.string :value
      t.string :key

      t.timestamps null: false
    end
  end
end
