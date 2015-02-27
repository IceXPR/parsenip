class Plan < ActiveRecord::Base
  
  scope :detailed_plans, ->(){
    where.not(max_calls_allowed: nil)
  }
  
  def self.update_plans
    active_plans = []
    Stripe::Plan.all.each do |stripe_plan|
      active_plans << stripe_plan.id
      create_or_update_plans stripe_plan
    end
    deactivate_non_active_plans active_plans
  end

  def self.create_or_update_plans stripe_plan
    db_plan = Plan.where(stripe_id: stripe_plan.id).first_or_create
    db_plan.update_attributes(stripe_id: stripe_plan.id, price_in_cents: stripe_plan.amount, name: stripe_plan.name,
                interval_count: stripe_plan.interval_count, interval: stripe_plan.interval)
  end

  def self.deactivate_non_active_plans active_plans
    Plan.where.not(id: active_plans).each do |plan|
      plan.deactivate
    end
  end

  def deactivate
    self.active = false
    self.save
  end
end
