default_run_options[:pty] = true

set :application, "lena"
set :repository, "file://."
# set :repository,  "git@github.com:lenalena/blog.git"
set :scm,         :git
set :branch,      "master"
set :use_sudo,    false
set :deploy_to,   "/var/www/#{application}"
set :deploy_via,  :copy
set :git_shallow_clone, 1
set :copy_exclude, [".git/*", "**/.git/*"]

role :app, "lenaherrmann.net"
role :web, "lenaherrmann.net"
role :db,  "lenaherrmann.net", :primary => true

deploy.task :restart, :roles => :web do
  run "touch #{current_path}/tmp/restart.txt"
end

deploy.task :start, :roles => :web do
  run "touch #{current_path}/tmp/restart.txt"
end

deploy.task :spinner, :roles => :web do
  # nothing
end

after 'deploy:setup' do
  run "mkdir -p #{shared_path}/log"
  run "mkdir -p #{shared_path}/db"

  run "touch #{shared_path}/log/production.log"
  run "chmod 666 #{shared_path}/log/production.log"
end

after 'deploy:symlink' do
  run "rm -fr #{release_path}/log"
  run "ln -nfs #{shared_path}/log #{release_path}/log"
end