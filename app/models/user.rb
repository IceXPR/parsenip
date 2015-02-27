class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :assign_secret_key
  after_create :create_user_plan
 
  has_one :user_plan
  has_one :plan, through: :user_plan
  
  has_many :uploads

  private
 
  def assign_secret_key
    self.secret_key = ApiAuth.generate_secret_key
  end

  def create_user_plan 
    UserPlan.create(user_id: self.id) 
  end
end
