class AddCallbackUrlToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :callback_url, :string
  end
end
