require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/config'

set :term_mode, :system
set :forward_agent, true
set :rvm_path, '/usr/local/rvm/scripts/rvm'

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/system"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/system"]

  queue! %[touch "#{deploy_to}/shared/config/app_config.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/app_config.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/secrets.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/secrets.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    # queue! "RAILS_ENV=#{rails_env} bundle exec rake db:create"
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      #invoke :'resque:stop'
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      #invoke :'resque:start'
    end

    invoke :'seed'
    invoke :'deploy:cleanup'
  end
end

desc "Seed data to the database"
task :seed => :environment do
  puts "-----> Seeding Database"
  queue "cd #{release_path}/"
  queue "RAILS_ENV=#{rails_env} bundle exec rake db:seed"
  puts "-----> Seeding Completed."
end

desc "Populate database.yml"
task :'setup:db:database_yml' => :environment do
  puts "-----> Configuring database.yml"
  queue! %[touch "#{deploy_to}/shared/config/database.yml"]

  puts "Enter a name for the new database"
  db_name = STDIN.gets.chomp
  puts "Enter a user for the new database"
  db_username = STDIN.gets.chomp
  puts "Enter a password for the new database"
  db_pass = STDIN.gets.chomp
  # Virtual Host configuration file
  database_yml = <<-DATABASE.dedent
#{rails_env}:
      adapter: postgresql
      database: #{db_name}
      username: #{db_username}
      password: #{db_pass}
  DATABASE
  queue! %{
    echo "-----> Populating database.yml"
    echo "#{database_yml}" > #{deploy_to!}/shared/config/database.yml
    echo "-----> Done"
  }
end

task :'sidekiq:stop' => :environment do
  queue %{
    echo "-----> Stopping #{rails_env} resque workers."
    ps ax | grep sidekiq | grep "#{app}" | awk -F ' ' '{print $1}' | xargs kill -9
  }
end

task :'sidekiq:start' => :environment do
  queue! %{
    echo "-----> Starting #{rails_env} sidekiq workers and resque scheduler with nohup."
    cd #{deploy_to}/#{current_path} && nohup bundle exec sidekiq -d -L log/sidekiq.log -C config/sidekiq.yml -e #{rails_env}
  }
end
