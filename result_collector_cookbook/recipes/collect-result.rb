HOMEDIR= "/home/ec2-user"
TARGET_HOMEDIR="/home/ec2-user"

stack = search("aws_opsworks_stack").first
Chef::Log.info("********** The stack's name is '#{stack['name']}' **********")
Chef::Log.info("********** This stack gets its cookbooks from '#{stack['custom_cookbooks_source']['url']}' **********")

layer = search("aws_opsworks_layer").first
Chef::Log.info("********** The layer's name is '#{layer['name']}' **********")

my_instance = search("aws_opsworks_instance", "self:true").first
Chef::Log.info("********** The instance's hostname is '#{my_instance['hostname']}' **********")
Chef::Log.info("********** The instance's ID is '#{my_instance['instance_id']}' **********")
Chef::Log.info("********** This instance's public IP address is '#{my_instance['public_ip']}' **********")

directory "Create a directory" do
  group "root"
  mode "0755"
  owner "ec2-user"
  path "#{HOMEDIR}/bigdata_course_cookbook/results"
  action :create
end

file '#{HOMEDIR}/bigdata_course_cookbook/results/*' do
  action :delete
  backup false
end

search("aws_opsworks_instance").each do |instance|
  if "#{instance['hostname']}" != "#{my_instance['hostname']}"
    execute "Copy files from '#{instance['hostname']}' ec2 to workstation" do
      command "scp -v -i #{HOMEDIR}/keys/testing123.pem ec2-user@#{instance['private_ip']}:#{TARGET_HOMEDIR}/ec2-testing-script/result-*  #{HOMEDIR}/bigdata_course_cookbook/results/"
    end
  end
  #Chef::Log.info("********** The instance's hostname is '#{instance['hostname']}' **********")
  #Chef::Log.info("********** The instance's ID is '#{instance['instance_id']}' **********")
end 
