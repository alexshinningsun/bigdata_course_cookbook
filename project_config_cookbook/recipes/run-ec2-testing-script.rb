HOMEDIR= "/home/ec2-user"
instance = search("aws_opsworks_instance", "self:true").first
Chef::Log.info("********** The instance's hostname is '#{instance['hostname']}' **********")
Chef::Log.info("********** The instance's ID is '#{instance['instance_id']}' **********")
Chef::Log.info("********** This instance's public IP address is '#{instance['public_ip']}' **********")

#user = search("aws_opsworks_user").first
#Chef::Log.info("********** The user's user name is '#{user['username']}' **********")
#Chef::Log.info("********** The user's user ARN is '#{user['iam_user_arn']}' **********")

# 1 CPU - Sysbench --> compare events per second
execute "Run Sysbench ec2 testing script" do
  command "touch #{HOMEDIR}/ec2-testing-script/cpu-measurement/result-sb-#{instance['hostname']}; sysbench --test=cpu --threads=1 --time=30 run > #{HOMEDIR}/ec2-testing-script/cpu-measurement/result-sb-#{instance['hostname']}"
end

# 2 CPU - 7-Zip --> single thread benchmark:
execute "Run 7-Zip(single thread benchmark) ec2 testing script" do
  command "touch #{HOMEDIR}/ec2-testing-script/cpu-measurement/result-7z-st-#{instance['hostname']}; 7z b -mmt1 > #{HOMEDIR}/ec2-testing-script/cpu-measurement/result-7z-st-#{instance['hostname']}"
end

# 3 CPU - 7-Zip --> Multi-threaded benchmarking:
execute "Run 7-Zip(Multi-threaded benchmarking) ec2 testing script" do
  command "touch #{HOMEDIR}/ec2-testing-script/cpu-measurement/result-7z-mt-#{instance['hostname']}; 7z b > #{HOMEDIR}/ec2-testing-script/cpu-measurement/result-7z-mt-#{instance['hostname']}"
end

# 4 Memory - Sysbench --> Write (memory-block-size=1M)
execute "Run Sysbench Write (memory-block-size=1M) testing script" do
  command "touch #{HOMEDIR}/ec2-testing-script/memory-measurement/result-sb-w1m-#{instance['hostname']}; sysbench --test=memory --memory-scope=global --memory-block-size=1M --memory-total-size=100G --num-threads=1 run > #{HOMEDIR}/ec2-testing-script/memory-measurement/result-sb-w1m-#{instance['hostname']}"
end

# 5 Memory - Sysbench --> Write (memory-block-size=1K)
execute "Run Sysbench Write (memory-block-size=1K) testing script" do
  command "touch #{HOMEDIR}/ec2-testing-script/memory-measurement/result-sb-w1k-#{instance['hostname']}; sysbench --test=memory --memory-scope=global --memory-block-size=1K --memory-total-size=100G --num-threads=1 run > #{HOMEDIR}/ec2-testing-script/memory-measurement/result-sb-w1k-#{instance['hostname']}"
end

# 6 Memory - Sysbench --> Read (memory-block-size=1M)
execute "Run Sysbench Read (memory-block-size=1M) testing script" do
  command "touch #{HOMEDIR}/ec2-testing-script/memory-measurement/result-sb-r1m-#{instance['hostname']}; sysbench --test=memory --memory-oper=read --memory-scope=global --memory-block-size=1M --memory-total-size=100G --num-threads=1 run > #{HOMEDIR}/ec2-testing-script/memory-measurement/result-sb-r1m-#{instance['hostname']}"
end

# 7 Memory - Sysbench --> Read (memory-block-size=1K)
execute "Run Sysbench Read (memory-block-size=1K) testing script" do
  command "touch #{HOMEDIR}/ec2-testing-script/memory-measurement/result-sb-r1k-#{instance['hostname']}; sysbench --test=memory --memory-oper=read --memory-scope=global --memory-block-size=1K --memory-total-size=100G --num-threads=1 run > #{HOMEDIR}/ec2-testing-script/memory-measurement/result-sb-r1k-#{instance['hostname']}"
end

# 8 ram - ioping --> Read 
execute "Run ioping Read testing script" do
  command "touch #{HOMEDIR}/ec2-testing-script/ioping/result-io-r-#{instance['hostname']}; ioping -A -s16k -c 10 /tmp/ram/. > #{HOMEDIR}/ec2-testing-script/ioping/result-io-r-#{instance['hostname']}"
end

# 9 ram - ioping --> Write 
execute "Run ioping Write testing script" do
  command "touch #{HOMEDIR}/ec2-testing-script/ioping/result-io-w-#{instance['hostname']}; ioping -S64M -L -s4k -W -c 10 /tmp/ram/. > #{HOMEDIR}/ec2-testing-script/ioping/result-io-w-#{instance['hostname']}"
end

#execute "Run the ec2 testing script" do
#  command "sh #{HOMEDIR}/ec2-testing-script/ec2-testing.sh > #{HOMEDIR}/ec2-testing-script/result-#{instance['hostname']}"
#end
