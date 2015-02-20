class CreateUserPlans < ActiveRecord::Migration
  def change
    create_table :user_plans do |t|
      t.integer :user_id
      t.integer :plan_id
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :next_charge_date
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
