#!/bin/bash
# list of nodes must be supplied as quoted, space separated list. ie "node1 node2".
NODES=$1
for i in $NODES; do ssh $i systemctl start pcsd.service; done
for i in $NODES; do ssh $i pcs cluster destroy; done
pcs cluster auth $NODES  -u hacluster -p manager
pcs cluster setup --name pgcluster $NODES
pcs cluster start --all
pcs property set stonith-enabled="false"
