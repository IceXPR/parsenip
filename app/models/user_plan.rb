class UserPlan < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  before_create :permit_only_one

  def can_make_request? 
    return user.uploads.in_plan_range(self).count < plan.max_calls_allowed
  end

  private

  def permit_only_one
    return !UserPlan.where(user_id: self.user_id).first
  end

end
