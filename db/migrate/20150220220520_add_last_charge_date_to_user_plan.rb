class AddLastChargeDateToUserPlan < ActiveRecord::Migration
  def change
    add_column :user_plans, :last_charge_date, :datetime
  end
end
