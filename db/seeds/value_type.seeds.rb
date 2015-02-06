value_type_attributes = [ 
  {name: 'First Name', key: 'first_name'},
  {name: 'Last Name', key: 'last_name'}
]

value_type_attributes.each do |value_type|
  value_type = ValueType.where(value_type).first_or_new
  value_type.update_attributes(value_type)
end
