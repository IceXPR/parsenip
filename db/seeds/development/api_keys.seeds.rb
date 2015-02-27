
after 'development:users' do
  user = User.where({email: 'john@example.com'}).first
  user.api_keys.where({permit_url: "callonthego.com"}).first_or_create
  user.api_keys.where({permit_url: "localhost"}).first_or_create
end
