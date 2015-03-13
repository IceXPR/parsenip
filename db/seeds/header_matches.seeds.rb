headers = [
  "first_name", "fn", "first", "name", "firstname", "last_name", "ln", "last", "lastname", "address",
  "email", "e-mail"
]

headers.each do |header|
  HeaderMatch.where(value: header).first_or_create
end
