require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

set :domain, ENV['DOMAIN'] || 'lvee.org'
set :user, ENV['REMOTE_USER'] || 'lvee'
set :deploy_to, "/home/#{fetch(:user)}/engine"
set :repository, 'https://github.com/lvee/lvee-engine.git'
set :branch, ENV['BRANCH'] || 'master'
set :keep_releases, 2

set :app_path,   "#{fetch(:current_path)}"

set :shared_dirs, fetch(:shared_dirs, []).push("log", "tmp", "public")
set :shared_files, fetch(:shared_files, []).push(
    "config/puma.rb",
    "config/database.yml",
    "config/initializers/constants.rb",
    "config/initializers/google_parameters.rb",
    "config/environments/production.rb"
)

#set :rails_env, 'production'
#set :port, '22'
#set :ssh_options, '-A'

task :remote_environment do
  invoke :'rvm:use', ENV['RUBY'] || 'ruby-2.3.3@default'
end

task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    # command "#{fetch (:bundle_prefix)} rake bootstrap"
    invoke :'rails:assets_precompile'
    on :launch do
      command %{systemctl --user restart puma-lvee.org}
    end
  end
end
