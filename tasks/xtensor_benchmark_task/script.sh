#!/bin/sh
set -v

export WORKDIR=`pwd`

apt-get update
apt-get install jq python3-dev python3-pip ssh -y

python3 $WORKDIR/buildscripts/tasks/xtensor_benchmark_task/formatssh.py
chmod 600 ssh_key

pip3 install python-openstackclient

export SERVER_NAME="benchmachine"

# create openstack server with ubuntu 18.04
openstack server create $SERVER_NAME --flavor b2-7 --image 9f8b2735-4c30-4784-9847-dc18b0e58951 --key-name ngkey

# wait until the openstack server is active!
active="FALSE"
until [ "$active" = "ACTIVE" ]
do
  active=$(openstack server show $SERVER_NAME -f json | jq -r .status)
  echo "Status: " $active
done

openstack server add volume $SERVER_NAME benchresults

openstack server show $SERVER_NAME -c addresses -f json > address.json

# extract the IP address.
export SERVER_IPADDR=$(python3 $WORKDIR/buildscripts/tasks/xtensor_benchmark_task/getip.py)

# mkdir -p ~/.ssh
# ssh-keyscan $SERVER_IPADDR >> ~/.ssh/known_hosts

ssh -o StrictHostKeyChecking=no -i ssh_key ubuntu@$SERVER_IPADDR "/bin/uname -a"
scp -o StrictHostKeyChecking=no -i ssh_key $WORKDIR/buildscripts/tasks/xtensor_benchmark_task/bench_script.sh ubuntu@$SERVER_IPADDR:~/bench_script.sh
ssh -o StrictHostKeyChecking=no -i ssh_key -o StrictHostKeyChecking=no ubuntu@$SERVER_IPADDR "sh ~/bench_script.sh"

# ssh -i ssh_key ubuntu@$SERVER_IPADDR "sudo apt-get update"
# ssh -i ssh_key ubuntu@$SERVER_IPADDR "sudo apt-get install cmake git g++ -y"
# ssh -i ssh_key ubuntu@$SERVER_IPADDR "git clone https://github.com/QuantStack/xtl"
# ssh -i ssh_key ubuntu@$SERVER_IPADDR "git clone https://github.com/QuantStack/xtensor"
# ssh -i ssh_key ubuntu@$SERVER_IPADDR "git clone https://github.com/QuantStack/xsimd"
# ssh -i ssh_key ubuntu@$SERVER_IPADDR "cd xtl && mkdir build && cd build && cmake .. && sudo make install"
# ssh -i ssh_key ubuntu@$SERVER_IPADDR "cd xsimd && mkdir build && cd build && cmake .. && sudo make install"
# ssh -i ssh_key ubuntu@$SERVER_IPADDR "cd xtensor && mkdir build && cd build && cmake .. -DBUILD_BENCHMARK=ON -DXTENSOR_USE_XSIMD=ON && make xbenchmark"

# openstack server delete $SERVER_NAME