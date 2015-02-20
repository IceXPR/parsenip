class ChargesController < ApplicationController
  def new
  end

  def create
    @amount = 500
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :card  => params[:stripeToken],
      plan: params[:stripePlan] 
    )
  
    plan = Plan.where(stripe_id: params[:stripePlan]).first
    UserPlan.create plan_id: plan.id, user_id: current_user.id, last_charge_date: Time.now
    redirect_to new_charge_path
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
  end
end
