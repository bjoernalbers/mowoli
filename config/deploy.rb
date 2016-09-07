# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'mowoli'
set :repo_url, 'git@github.com:bjoernalbers/mowoli.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'
set :deploy_to, ->{ File.join('/Users', fetch(:user), fetch(:application)) }

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml',
                                                 'config/secrets.yml',
                                                 'db/production.sqlite3',
                                                 '.env')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :services, %w(app purge_expired_orders)

namespace :deploy do
  namespace :check do
    # This stuff here is only used for the first deployment (a.k.a. "cold
    # start") in order to get the beast running.
    # We just have to make sure that the linked files do exist.
    task :linked_files => %w(config/database.yml config/secrets.yml db/production.sqlite3 .env)

    remote_file 'config/database.yml' => 'config/database.yml.sample', roles: :app
    remote_file '.env' => 'env.sample', roles: :app

    # NOTE: The local file (second argument) must have a different path or we'd
    # get circular dependency errors.
    # Therefore we use a './' prefix here.
    remote_file 'config/secrets.yml' => './config/secrets.yml', roles: :app
    remote_file 'db/production.sqlite3' => './db/production.sqlite3', roles: :db

    file './db/production.sqlite3' do
      unless identical? 'config/database.yml', 'config/database.yml.sample'
        fail 'No, we do not setup a production database when config/database.yml was changed!'
      end
      sh 'RAILS_ENV=production bin/rake db:setup'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'launchd:unload'
      invoke 'launchd:load'
    end
  end

  after :publishing, :restart
end
