class Upload < ActiveRecord::Base
  belongs_to :user
  has_attached_file :file

  # TODO: we should validate against certain types, but we don't know what they are yet
  do_not_validate_attachment_file_type :file
end
