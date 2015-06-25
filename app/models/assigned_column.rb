class AssignedColumn < ActiveRecord::Base
  belongs_to :upload
  belongs_to :column

  scope :ordered, -> { order('column_number asc') }
end
