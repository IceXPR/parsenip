class AssignedColumn < ActiveRecord::Base
  belongs_to :upload
  belongs_to :column
end
