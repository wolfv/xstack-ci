#!/bin/sh
set -e -v

echo "Running next version."

export WORKDIR=`pwd`

mkdir -p ~/.ssh/

echo $SSH_PRIVATE_KEY > ~/.ssh/id_rsa
echo $SSH_PUBLIC_KEY > ~/.ssh/id_rsa.pub

apt update
apt install python3-dev python3-pip ssh -y

pip3 install python-openstackclient

openstack server list

# create openstack server with ubuntu 18.04
openstack server create benchmakina --flavor b2-7 --image 9f8b2735-4c30-4784-9847-dc18b0e58951 --key-name ngkey

openstack server show benchmakina
openstack server show benchmakina -c addresses -f json > address.json

ls -al

python3 $WORKDIR/getip.py
source $WORKDIR/getipresult.sh

echo "IP ADDRESS "
echo $SERVER_IPADDR

ssh -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa ubuntu@$SERVER_IPADDR /bin/uname -a