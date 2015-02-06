
after 'development:seeds' do
  user = User.where({email: 'john@example.com'})

  if Upload.where({user: user}).count == 0
    Upload.create({user: user, file: open(Rails.root.join('csv_test_files', '1.csv'))})
    Upload.create({user: user, file: open(Rails.root.join('csv_test_files', '2.csv'))})
    Upload.create({user: user, file: open(Rails.root.join('csv_test_files', '3.csv'))})
  end
end
