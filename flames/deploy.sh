#!/bin/bash

#FLEETCTL_TUNNEL="[2001:470:79::9:0]:22"
FLEETCTL_TUNNEL="209.51.167.36:22"
PORT=9010
NAME=access

INSTANCES="1 2"

function waitInstance() {
   waiting=1
   loopcount=0
   INSTANCEIP=$(fleetctl list-units |grep meteor.${NAME}@${INSTANCE} |cut -d'/' -f2 |cut -f1)
   echo -n "Waiting for instance ${INSTANCE} on ${INSTANCEIP} to come up"
   while [ $waiting -eq 1 ]; do
      curl http://${INSTANCEIP}:${PORT} >/dev/null 2>/dev/null
      if [ $? -eq 0 ]; then
         waiting=0
      fi
      echo -n "."
      if [ $loopcount -gt 60 ]; then
         echo ""
         echo "FAILED to bring up instance ${INSTANCE} on ${INSTANCEIP}"
         echo "Log output from ${INSTANCEIP}:"
         fleetctl journal -lines=10 meteor.${NAME}@${INSTANCE}
         exit 2
      fi
      loopcount=$[$loopcount + 1]
      sleep 10
   done
   echo ""
   echo "Instance ${INSTANCE} on ${INSTANCEIP} is UP"
}

for i in $INSTANCES; do
   # Stop the instance
   echo "Stopping instance $i..."
   fleetctl stop meteor.${NAME}@${i}
   if [ $? -ne 0 ]; then
      echo "Failed"
      exit 1
   fi
   sleep 1

   echo "Starting instance $i..."
   fleetctl start meteor.${NAME}@${i}
   if [ $? -ne 0 ]; then
      echo "Failed"
      exit 1
   fi
   
   # Wait on the instance
   INSTANCE=${i}
   waitInstance
done
