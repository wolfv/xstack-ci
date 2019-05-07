#!/bin/sh
set -e

export WORKDIR=`pwd`

apt update
apt install python3-dev python3-pip ssh -y

pip3 install python-openstackclient

printenv | grep OS_

openstack server list

openstack keypair create autokey

# create openstack server with ubuntu 18.04
openstack server create benchmakina --flavor b2-7 --image 9f8b2735-4c30-4784-9847-dc18b0e58951 --key-name autokey

openstack server show benchmakina -c addresses -f json > address.json

python3 getip.py
source getipresult.sh

ssh ubuntu@$SERVER_IPADDR