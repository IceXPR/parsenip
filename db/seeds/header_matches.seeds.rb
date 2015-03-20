headers = [
  "first_name", "fn", "first", "name", "firstname", "first name", "last name", "last_name", "ln", "last", "lastname", 
  "address", "email", "e-mail", "phone", "company", "contact", "city", "state", "postal code", "postal", "postal_code", 
  "postalcode", "zip code", "zip", "zip_code", "zipcode", "comp."
]

headers.each do |header|
  HeaderMatch.where(value: header).first_or_create
end
