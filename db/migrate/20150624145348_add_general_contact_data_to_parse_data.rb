class AddGeneralContactDataToParseData < ActiveRecord::Migration
  def change
    add_column :parse_data, :middle_initial, :string
    add_column :parse_data, :middle_name, :string
    add_column :parse_data, :full_name, :string
    add_column :parse_data, :birthdate, :date
    add_column :parse_data, :address_1, :string
    add_column :parse_data, :address_2, :string
    add_column :parse_data, :zipcode, :string
    add_column :parse_data, :city, :string
    add_column :parse_data, :state, :string
    add_column :parse_data, :country, :string
    add_column :parse_data, :company, :string
    add_column :parse_data, :notes, :text
  end
end
