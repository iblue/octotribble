load './config/deploy.conf.rb'

set :application, "octotribble"
set :ssh_options, { :forward_agent => true }

set :deploy_via, :copy
set :scm, "git"
set :repository, "."
set :local_repository, "."

set :deploy_to, "/var/www/octotribble"

after "deploy:restart", "deploy:cleanup"

set :server_user,    "www-data"
set :server_group,   "www-data"

set :shared_children, %w(db public cache)
set :normalize_asset_timestamps, false

# TODO: Add unicorn init scripts and config
#
namespace :deploy do
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, releases_path, shared_path]
    shared_subdirs = shared_children.map { |d| File.join(shared_path, d.split('/').last) }
    run "#{try_sudo} mkdir -p #{(dirs+shared_subdirs).join(' ')}"
    run "#{try_sudo} chown -R #{user}:#{group} #{dirs.join(' ')}"
    run "#{try_sudo} chown -R #{server_user}:#{server_group} #{shared_subdirs.join(' ')}"
    run "#{try_sudo} mkdir -p /var/log/octotribble"
    run "#{try_sudo} chown -R #{server_user}:#{server_group} /var/log/octotribble"

    # Link server config
    run "#{try_sudo} ln -sf #{deploy_to}/current/config/nginx.conf /etc/nginx/sites-enabled/#{application}.conf"
    run "#{try_sudo} ln -sf #{deploy_to}/current/config/initscript.sh /etc/init.d/#{application}"
  end

  task :restart, :except => {:no_release => true} do
    run "#{try_sudo} /etc/init.d/nginx reload"
    run "#{try_sudo} /etc/init.d/#{application} upgrade"
  end
end