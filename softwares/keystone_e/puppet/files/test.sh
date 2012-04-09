#!/bin/bash

#check if keystone is running
status keystone | grep running
if [ $? != 0 ]; then
    echo "Service kyestone is not started."
    exit 1
fi

apt-get install gawk -y

pid1="`status keystone | awk '{print $4}'`"
sleep 2
pid2="`status keystone | awk '{print $4}'`"
if [ $pid1 != $pid2 ]; then
    echo "Service keystone's pid is changing."
    exit 1
fi

output=`keystone --tenant=admin --username=admin --password=$1 --auth_url=http://127.0.0.1:5000/v2.0 user-list`

for user in admin glance nova demo
do
  echo "$output" | grep $user
  if [ $? != 0 ]; then
    echo "User $user wasn't added."
    exit 1
  fi
done

echo "Test finished. It is OK."
