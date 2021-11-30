HOMEDIR= "/home/ec2-user"
stack = search("aws_opsworks_stack").first
Chef::Log.info("********** The stack's name is '#{stack['name']}' **********")
Chef::Log.info("********** This stack gets its cookbooks from '#{stack['custom_cookbooks_source']['url']}' **********")

layer = search("aws_opsworks_layer").first
Chef::Log.info("********** The layer's name is '#{layer['name']}' **********")

instance = search("aws_opsworks_instance", "self:true").first
Chef::Log.info("********** The instance's hostname is '#{instance['hostname']}' **********")
Chef::Log.info("********** The instance's ID is '#{instance['instance_id']}' **********")
Chef::Log.info("********** This instance's public IP address is '#{instance['public_ip']}' **********")

#user = search("aws_opsworks_user").first
#Chef::Log.info("********** The user's user name is '#{user['username']}' **********")
#Chef::Log.info("********** The user's user ARN is '#{user['iam_user_arn']}' **********")

cookbook_file "Copy ec2 performance setup script file to home directory" do
  group "root"
  mode "0755"
  owner "ec2-user"
  path "#{HOMEDIR}/ec2-testing-script/ec2-setup.sh"
  source "ec2-setup.sh"
end

execute "Run the ec2 testing script" do
  command "sh #{HOMEDIR}/ec2-testing-script/ec2-setup.sh"
end

directory "Create a directory" do
  group "root"
  mode "0777"
  owner "ec2-user"
  path "#{HOMEDIR}/ec2-testing-script"
  action :create
end

file "Remove older result" do
  path "#{HOMEDIR}/ec2-testing-script/result-#{instance['hostname']}"
  backup false
  action :delete
end

file "Create an empty result file" do
  content ""
  group "root"
  mode "0777"
  owner "ec2-user"
  path "#{HOMEDIR}/ec2-testing-script/result-#{instance['hostname']}"
end

cookbook_file "Copy ec2 performance testing script file to home directory" do
  group "root"
  mode "0755"
  owner "ec2-user"
  path "#{HOMEDIR}/ec2-testing-script/ec2-testing.sh"
  source "ec2-testing.sh"
end
