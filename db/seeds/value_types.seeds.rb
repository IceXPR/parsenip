value_types_attributes = [ 
  {name: 'First Name', key: 'first_name'},
  {name: 'Last Name', key: 'last_name'}
]

value_types_attributes.each do |value_type_attributes|
  value_type = ValueType.where(value_type_attributes).first
  unless value_type
    value_type = ValueType.new 
  end
  value_type.update_attributes(value_type_attributes)
end
