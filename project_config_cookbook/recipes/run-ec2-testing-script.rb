HOMEDIR= "/home/ec2-user"
instance = search("aws_opsworks_instance").first
Chef::Log.info("********** The instance's hostname is '#{instance['hostname']}' **********")
Chef::Log.info("********** The instance's ID is '#{instance['instance_id']}' **********")
Chef::Log.info("********** This instance's public IP address is '#{instance['public_ip']}' **********")

#user = search("aws_opsworks_user").first
#Chef::Log.info("********** The user's user name is '#{user['username']}' **********")
#Chef::Log.info("********** The user's user ARN is '#{user['iam_user_arn']}' **********")

execute "Run the ec2 testing script" do
  command "sh #{HOMEDIR}/ec2-testing-script/ec2-testing.sh > #{HOMEDIR}/ec2-testing-script/result-#{instance['hostname']}"
end
