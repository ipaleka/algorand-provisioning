#!/bin/bash
#
# usage:
#
# verify_user_ssh_connection.sh user host
#
#
RC=0
ansible $2 -u $1 -m ping
if [ $? -eq 0 ]
then
   echo "success"
else
   echo "failure"
   RC=1
fi
exit $RC
