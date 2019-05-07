#!/bin/sh
set -e

export WORKDIR=`pwd`

apt update
apt install python3-dev python3-pip -y

pip3 install python-openstackclient

echo $OS_PASSWORD

openstack server list