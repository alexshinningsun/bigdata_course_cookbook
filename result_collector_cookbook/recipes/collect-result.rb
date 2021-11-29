HOMEDIR= "/root/bigdata_course_cookbook"
TARGET_HOMEDIR="/home/ec2-user"

stack = search("aws_opsworks_stack").first
Chef::Log.info("********** The stack's name is '#{stack['name']}' **********")
Chef::Log.info("********** This stack gets its cookbooks from '#{stack['custom_cookbooks_source']['url']}' **********")

layer = search("aws_opsworks_layer").first
Chef::Log.info("********** The layer's name is '#{layer['name']}' **********")

instance = search("aws_opsworks_instance", "self:true").first
Chef::Log.info("********** The instance's hostname is '#{instance['hostname']}' **********")
Chef::Log.info("********** The instance's ID is '#{instance['instance_id']}' **********")
Chef::Log.info("********** This instance's public IP address is '#{instance['public_ip']}' **********")

file '#{HOMEDIR}/results/*' do
  action :delete
end

directory "Create a directory" do
  group "root"
  mode "0755"
  owner "root"
  path "#{HOMEDIR}/results"
  action :create
end

search("aws_opsworks_instance").each do |instance|
  
  execute "Copy files from testing ec2 to workstation" do
    command "scp -i /root/keys/testing123.pem ec2-user@#{instance['private_ip']}:#{TARGET_HOMEDIR}/ec2-testing-script/result-*  #{HOMEDIR}/results/"
  end
  #Chef::Log.info("********** The instance's hostname is '#{instance['hostname']}' **********")
  #Chef::Log.info("********** The instance's ID is '#{instance['instance_id']}' **********")
end 
