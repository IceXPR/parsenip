class AddTokenToUpload < ActiveRecord::Migration
  def change
    add_column :uploads, :upload_token, :string
  end
end
