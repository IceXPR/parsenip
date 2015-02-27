class RemoveStripeInfoFromUserAndAddToUserPlan < ActiveRecord::Migration
  def up 
    remove_column :users, :stripe_card_id 
    add_column :user_plans, :stripe_customer_id, :string
  end
  
  def down
    remove_column :user_plans, :stripe_customer_id
    add_column :users, :stripe_card_id, :string
  end
end
