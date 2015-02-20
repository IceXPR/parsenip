class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.string :stripe_id
      t.integer :price_in_cents
      t.string :description
      t.integer :max_calls_allowed
      t.integer :length_in_days

      t.timestamps null: false
    end
  end
end
