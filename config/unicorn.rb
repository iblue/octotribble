# -*- encoding : utf-8 -*-
environment = ENV['RAILS_ENV'] || 'production'

root = File.expand_path(File.dirname(__FILE__)+"/..")

working_directory root
pid "/var/log/octotribble/unicorn.pid"
stderr_path "/var/log/octotribble/unicorn.log"
stdout_path "/var/log/octotribble/unicorn.log"

listen "/tmp/unicorn.octotribble.sock"

# Adjust to number of CPUs
worker_processes 2


# ATTENTION!
# If a worker got a long running process it will be blocked the whole period defined here.
# So it might be possible that a deployment within will fail due to non-responding worker.
timeout 30

preload_app true

# The deployment script fails every 5 deploys, when we delete the
# original old release directory. This is, because the old Gemfile
# location is cached by bundler in some ugly environment variable.
#
# This makes sure, it always uses the correct Gemfile, and makes
# the deployment work
before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = "#{root}/Gemfile"
end

before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = '/var/log/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end


after_fork do |server, worker|
  ##
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection

  ::Sequel::Model.db.disconnect

  ##
  # Unicorn master is started as root, which is fine, but let's
  # drop the workers to deploy:deploy

  begin
    # Make sure the database is accessible
    `chown www-data:www-data #{environment}.db`

    uid, gid = Process.euid, Process.egid
    user, group = 'www-data', 'www-data'
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end

  rescue => e
    if environment == 'development'
      STDERR.puts "couldn't change user, oh well"
    else
      raise e
    end
  end
end

