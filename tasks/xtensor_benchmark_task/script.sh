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
export SERVER_IMAGE=`openstack image list -f json | jq -r '.[] | select(.Name=="Ubuntu 18.04")["ID"]'`
openstack server create $SERVER_NAME --flavor b2-7 --image $SERVER_IMAGE --key-name ngkey

# wait until the openstack server is active!
counter=0
active="FALSE"
until [ "$active" = "ACTIVE" ]
do
  active=$(openstack server show $SERVER_NAME -f json | jq -r .status)
  echo "Status: " $active
  sleep 2s;
  counter=$((counter+1))
  if [ "$counter" -gt 150 ]; then
       echo "Counter: $counter times reached; Exiting loop!";
       exit 1;
  fi
done

openstack server add volume $SERVER_NAME benchresults

openstack server show $SERVER_NAME -c addresses -f json > address.json

# extract the IP address.
export SERVER_IPADDR=$(python3 $WORKDIR/buildscripts/tasks/xtensor_benchmark_task/getip.py)

sleep 10s

mkdir -p ~/.ssh

counter=0
until ssh -o StrictHostKeyChecking=no -i ssh_key ubuntu@$SERVER_IPADDR "/bin/uname -a"
do
  echo "Try again";
  sleep 2s;
  counter=$((counter+1))
  if [ "$counter" -gt 150 ]; then
       echo "Counter: $counter times reached; Exiting loop!";
       exit 1;
  fi
done

scp -o StrictHostKeyChecking=no -i ssh_key $WORKDIR/buildscripts/tasks/xtensor_benchmark_task/bench_script.sh ubuntu@$SERVER_IPADDR:~/bench_script.sh
ssh -o StrictHostKeyChecking=no -i ssh_key ubuntu@$SERVER_IPADDR "sh ~/bench_script.sh $1"

# Wait for shutdown!
sleep 30s

openstack server remove volume $SERVER_NAME benchresults

openstack server delete $SERVER_NAME