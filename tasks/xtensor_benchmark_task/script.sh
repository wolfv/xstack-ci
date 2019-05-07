#!/bin/sh
set -e

export WORKDIR=`pwd`

apt update
apt install openstack -y

export OS_PASSWORD=$SECRET_KEY

echo "Secret key 1?"
echo $SECRET_KEY
echo $SCK1
echo "Secret key 2?"
echo $SECRET_KEY2
echo $SCK2

echo $OS_PASSWORD


openstack server list