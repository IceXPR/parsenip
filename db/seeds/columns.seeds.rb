

# Generate the standard seeds that should appear on each contact
# When changing these, you MUST add the corresponding key to the ParseData model.
# Adding new columns will automatically reflect the new column on the confirmation step
# on the client's application.
columns = [
    {
        key: 'first_name',
        name: "First name",
    },
    {
        key: 'last_name',
        name: "Last name",
    },
    {
        key: 'middle_initial',
        name: "Middle initial",
    },
    {
        key: 'middle_name',
        name: "Middle name",
    },
    {
        key: 'full_name',
        name: "Full name",
    },
    {
        key: 'birthdate',
        name: "Birthdate",
    },
    {
        key: 'email',
        name: "Email",
    },
    {
        key: 'phone',
        name: "Phone",
    },
    {
        key: 'address_1',
        name: "Address Line 1",
    },
    {
        key: 'address_2',
        name: "Address Line 2",
    },
    {
        key: 'zipcode',
        name: "Zipcode",
    },
    {
        key: 'city',
        name: "City",
    },
    {
        key: 'state',
        name: "State",
    },
    {
        key: 'country',
        name: "Country",
    },
    {
        key: 'company',
        name: "Company",
    },
    {
        key: 'notes',
        name: "Notes",
    }
]

columns.each do |c|
  column = Column.where({key: c[:key]}).first_or_create(c)
  c.delete :key
  column.update(c)
end