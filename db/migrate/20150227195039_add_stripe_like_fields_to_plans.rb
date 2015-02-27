class AddStripeLikeFieldsToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :active, :boolean, default: true
    add_column :plans, :interval, :string
    add_column :plans, :interval_count, :integer
  end
end
