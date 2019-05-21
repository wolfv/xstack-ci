#!/bin/sh
set -v

echo "Running next version."

export WORKDIR=`pwd`

apt-get update
apt-get install jq python3-dev python3-pip ssh -y

python3 $WORKDIR/buildscripts/tasks/xtensor_benchmark_task/formatssh.py
chmod 600 ssh_key

pip3 install python-openstackclient

openstack server list

# create openstack server with ubuntu 18.04
openstack server create benchmakina --flavor b2-7 --image 9f8b2735-4c30-4784-9847-dc18b0e58951 --key-name ngkey

active="FALSE"

until [ "$active" = "ACTIVE" ]
do
  active=$(openstack server show benchmakina -f json | jq -r .status)
  echo "Status: " $active
done

openstack server show benchmakina
openstack server show benchmakina -c addresses -f json > address.json

cat address.json

export SERVER_IPADDR=$(python3 $WORKDIR/buildscripts/tasks/xtensor_benchmark_task/getip.py)

echo "IP ADDRESS ", $SERVER_IPADDR

ssh -o StrictHostKeyChecking=no -i ssh_key ubuntu@$SERVER_IPADDR /bin/uname -a
ssh -o StrictHostKeyChecking=no -i ssh_key ubuntu@$SERVER_IPADDR sudo apt-get update
ssh -o StrictHostKeyChecking=no -i ssh_key ubuntu@$SERVER_IPADDR sudo apt-get install cmake git g++ -y
ssh -o StrictHostKeyChecking=no -i ssh_key ubuntu@$SERVER_IPADDR git clone https://github.com/QuantStack/xtl
ssh -o StrictHostKeyChecking=no -i ssh_key ubuntu@$SERVER_IPADDR git clone https://github.com/QuantStack/xtensor
ssh -o StrictHostKeyChecking=no -i ssh_key ubuntu@$SERVER_IPADDR git clone https://github.com/QuantStack/xsimd
ssh -o StrictHostKeyChecking=no -i ssh_key ubuntu@$SERVER_IPADDR cd xtl && mkdir build && cd build && cmake .. && sudo make install
ssh -o StrictHostKeyChecking=no -i ssh_key ubuntu@$SERVER_IPADDR cd xsimd && mkdir build && cd build && cmake .. && sudo make install
ssh -o StrictHostKeyChecking=no -i ssh_key ubuntu@$SERVER_IPADDR cd xtensor && mkdir build && cd build && cmake .. -DBUILD_BENCHMARK=ON -DXTENSOR_USE_XSIMD && make xbenchmark

openstack server delete benchmakina