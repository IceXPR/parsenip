class UserPlan < ActiveRecord::Base
  belongs_to :user
  belongs_to :plan

  def can_make_request? 
    return user.uploads.in_plan_range(self).count < plan.max_calls_allowed
  end
end
