class ModifyApiKeys < ActiveRecord::Migration
  def change
    rename_column :api_keys, :key, :javascript_api_key
  end
end
