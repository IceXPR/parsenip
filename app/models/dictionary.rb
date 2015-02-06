class Dictionary < ActiveRecord::Base
  belongs_to :value_type
  
  scope :by_type, ->(type){
    joins(:value_type).where(value_types: {key: type})
  }
end
