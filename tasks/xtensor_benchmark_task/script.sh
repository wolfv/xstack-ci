#!/bin/sh
set -e -v

echo "Running next version."

export WORKDIR=`pwd`

mkdir -p ~/.ssh/

echo $SSH_PRIVATE_KEY > ~/.ssh/id_rsa
echo $SSH_PUBLIC_KEY > ~/.ssh/id_rsa.pub

apt update
apt install jq python3-dev python3-pip ssh -y

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

export $SERVER_IPADDR=$(python3 $WORKDIR/buildscripts/tasks/xtensor_benchmark_task/getip.py)

echo "IP ADDRESS ", $SERVER_IPADDR

ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ubuntu@$SERVER_IPADDR /bin/uname -a