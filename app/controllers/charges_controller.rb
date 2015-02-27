class ChargesController < ApplicationController
  before_filter :authenticate_user

  def new
    @current_plan = UserPlan.where(user: current_user).first.try(:plan)
  end

  def create
    @amount = 500
    customer = Stripe::Customer.create(
      email: params[:stripeEmail],
      card: params[:stripeToken],
      plan: params[:stripePlan] 
    )
    send_plan_to_stripe
  end

  private

  def send_plan_to_stripe customer
    plan = Plan.where(stripe_id: params[:stripePlan]).first
    current_user.user_plan.update_attributes plan_id: plan.id, last_charge_date: Time.now, stripe_customer_id: customer.id
    redirect_to new_charge_path
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
  end
end
