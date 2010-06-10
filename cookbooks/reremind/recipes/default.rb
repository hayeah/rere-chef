Gem.clear_paths # needed for Chef to find the gem...
require 'mysql' # requires the mysql gem

# create database
execute "create database #{node[:rere][:db][:name]}" do
  command "/usr/bin/mysqladmin -u root -p#{node[:mysql][:server_root_password]} create #{node[:rere][:db][:name]}"
  not_if do
    m = Mysql.new("localhost", "root", @node[:mysql][:server_root_password])
    m.list_dbs.include?(@node[:rere][:db][:name])
  end
end

user do
  username "rere"
end

group do
  group_name "rere"
  members ["rere"]
end

directory "/app/rere" do
  owner "rere"
  group "rere"
  mode "0755"
  action :create
  recursive true
  not_if "test -d /tmp/something"
end

# create database user for application
# execute "create mysql user" do
#   "grant all on rere.* to rere identified by 'rere'"
# end

# deploy "/app/reremind" do
#   repository "git://github.com/hayeah/rere.git"
#   user "rere"
#   group "rere"
#   shallow_clone true
#   environment "RAILS_ENV" => "production"
#   migrate true
#   migration_command "rake db:migrate"
# end
