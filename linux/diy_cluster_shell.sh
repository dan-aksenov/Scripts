#!/bin/bash
cmd=$1
if [ -z ${hosts+x} ]
then
   echo "No hosts selected. Declare hosts variable."
   exit 1
fi

if [ -z ${1+x} ]
then 
   echo "No remote command set. Set it as first positional parameter."
   exit 1
fi

for host in $hosts
do
   ssh $host $cmd
done
