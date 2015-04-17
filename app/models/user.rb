class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :create_user_plan
 
  has_one :user_plan
  has_one :plan, through: :user_plan
  
  has_many :uploads
  has_many :api_keys

  private

  def create_user_plan 
    UserPlan.create(user_id: self.id) 
  end
end
