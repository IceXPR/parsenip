class Dictionary < ActiveRecord::Base
  extend Memoist
  belongs_to :value_type
  
  scope :by_type, ->(type){
    joins(:value_type).where(value_types: {key: type})
  }

  class << self
    extend Memoist
    def first_names
      with_type('first_name').all
    end

    def last_names
      with_type('last_name').all
    end

    def with_type(type)
      where({ value_type_id: by_type(type).first.id })
    end

    memoize :first_names
    memoize :last_names
  end
end
