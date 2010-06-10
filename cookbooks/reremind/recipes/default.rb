Gem.clear_paths # needed for Chef to find the gem...
require 'mysql' # requires the mysql gem

execute "create #{node[:reremind][:db][:database]} database" do
  command "/usr/bin/mysqladmin -u root -p#{node[:mysql][:server_root_password]} create #{node[:reremind][:db][:name]}"
  not_if do
    m = Mysql.new("localhost", "root", @node[:mysql][:server_root_password])
    m.list_dbs.include?(@node[:reremind][:db][:name])
  end
end

deploy "/app/reremind" do
  repository "git://github.com/hayeah/rere.git"
  user "rere"
  group "rere"
  shallow_clone true
  environment "RAILS_ENV" => "production"
  migrate true
  migration_command "rake db:migrate"
end