default_run_options[:pty] = true
set :application, "draftback"
set :repository,  "git@github.com:jsomers/draftback.git"
set :scm, "git"
# Command to load new code: touch /home/james/public_html/jeopardy/current/tmp/restart.txt
# set :scm_passphrase, "D0nkeyB0nkers!" # This is your custom user's password
set :branch, "master"
set :user, "james"
set :deploy_via, :remote_cache
set :port, 30000

set :runner, "james"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/james/public_html/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

set :location, "draftback.com"
role :app, location
role :web, location
role :db,  location, :primary => true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch /home/james/public_html/draftback/current/tmp/restart.txt"
  end
  
  task :start do
    # nothing
  end
end