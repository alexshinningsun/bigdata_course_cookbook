HOMEDIR= "/home/ec2-user"
TARGET_HOMEDIR="/home/ec2-user"
key_file_name="cloud-course-prj.pem"

stack = search("aws_opsworks_stack").first
Chef::Log.info("********** The stack's name is '#{stack['name']}' **********")
Chef::Log.info("********** This stack gets its cookbooks from '#{stack['custom_cookbooks_source']['url']}' **********")

layer = search("aws_opsworks_layer").first
Chef::Log.info("********** The layer's name is '#{layer['name']}' **********")

my_instance = search("aws_opsworks_instance", "self:true").first
Chef::Log.info("********** The instance's hostname is '#{my_instance['hostname']}' **********")
Chef::Log.info("********** The instance's ID is '#{my_instance['instance_id']}' **********")
Chef::Log.info("********** This instance's public IP address is '#{my_instance['public_ip']}' **********")

dir_paths = ["#{HOMEDIR}/bigdata_course_cookbook/results", "#{HOMEDIR}/bigdata_course_cookbook/results/cpu-measurement", "#{HOMEDIR}/bigdata_course_cookbook/results/memory-measurement"]
dir_paths.each do |eachpath|
  directory "Create a directory" do
    group "root"
    mode "0777"
    owner "ec2-user"
    path "#{eachpath}"
    action :create
  end
end


file '#{HOMEDIR}/bigdata_course_cookbook/results/cpu-measurement/*' do
  action :delete
  backup false
end

file '#{HOMEDIR}/bigdata_course_cookbook/results/memory-measurement/*' do
  action :delete
  backup false
end

search("aws_opsworks_instance").each do |instance|
  if "#{instance['hostname']}" != "#{my_instance['hostname']}"
    execute "Copy cpu result files from '#{instance['hostname']}' ec2 to workstation" do
      command "scp -o StrictHostKeyChecking=no -v -i #{HOMEDIR}/keys/#{key_file_name} ec2-user@#{instance['private_ip']}:#{TARGET_HOMEDIR}/ec2-testing-script/cpu-measurement/result-*  #{HOMEDIR}/bigdata_course_cookbook/results/cpu-measurement/"
    end
    execute "Copy memory result files from '#{instance['hostname']}' ec2 to workstation" do
      command "scp -o StrictHostKeyChecking=no -v -i #{HOMEDIR}/keys/#{key_file_name} ec2-user@#{instance['private_ip']}:#{TARGET_HOMEDIR}/ec2-testing-script/memory-measurement/result-*  #{HOMEDIR}/bigdata_course_cookbook/results/memory-measurement/"
    end
  end
  #Chef::Log.info("********** The instance's hostname is '#{instance['hostname']}' **********")
  #Chef::Log.info("********** The instance's ID is '#{instance['instance_id']}' **********")
end 
