#server "spokane", :app, :db, :primary => true
server "mohave", :app, :web
server "mohawk", :app, :web
#server "classic", :app, :search, :task_master
#server "cholon", :app, :worker
#server "choctaw", :app, :worker
#server "chumash", :app, :worker

set :application,         "shopsearch"
set :rails_env,           "production"
set :repository,          "git@github.com:tribesports/rollup.git"
set :deploy_to,           "/opt/rollup"
set :deploy_via,          :remote_cache
set :user,                "rails"
set :port,                717
set :scm,                 "git"
set :scm_username,        "tribesports"
set :branch,              "master"
set :use_sudo,            false
set :keep_releases,       20

require 'bundler/capistrano'

set :rake, "#{rake} --trace"

Dir[File.expand_path('../deploy/recipes/*.rb', __FILE__)].each do |recipe|
  require recipe
end

default_environment['PATH'] = "/usr/local/bin:$PATH"

# Task ordering
after   "deploy:update_code",     "deploy:build"

task :deploy do
  update_code
  deploy.build
end

namespace :deploy do
  desc "build jar"
  task :build, :roles => :web do
    run "cd #{release_path} && RAILS_ENV=#{rails_env} bundle exec rake"
  end
end

