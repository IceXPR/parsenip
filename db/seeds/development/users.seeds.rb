

User.where({email: 'john@example.com'}).first_or_create({password: 'password'})
