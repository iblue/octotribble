require 'rubygems'
require 'bundler'

if ENV['RACK_ENV'] == 'production'
  Bundler.require(:default, :production)
else
  Bundler.require(:default, :development)
end

require './octotribble.rb'

# rake asset:precompile
require 'sinatra/asset_pipeline/task.rb'
Sinatra::AssetPipeline::Task.define! Octotribble::App


SSH_USER = 'username'
SSH_HOST = 'yourdomain.com'
SSH_DIR  = '/var/www/octotribble'

desc "Deploy website via rsync"
task :push do
  puts "## Deploying project via rsync to #{SSH_HOST}"
  status = system("rsync -avze 'ssh' --delete . #{SSH_USER}@#{SSH_HOST}:#{SSH_DIR}")
  system("ssh root@#{SSH_HOST} 'cd #{SSH_DIR}; rake asset:precompile; chown -R www-data:www-data public production.db'")
  puts status ? "OK" : "FAILED"
end

desc "Deploy config"
task :config do
  puts "## Deploying nginx config to #{SSH_HOST}"
  system("rsync -avze 'ssh' nginx.conf root@#{SSH_HOST}:/etc/nginx/sites-available/octotribble")
  system("ssh root@#{SSH_HOST} '/etc/init.d/nginx reload'")
end

desc "Build and deploy website"
task :deploy => [:push] do
end
