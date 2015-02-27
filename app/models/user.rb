class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  before_create :assign_secret_key
  has_many :uploads
  has_many :api_keys

  private
 
  def assign_secret_key
    self.secret_key = ApiAuth.generate_secret_key
  end
end
